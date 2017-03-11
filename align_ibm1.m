function AM = align_ibm1(trainDir, numSentences, maxIter, fn_AM)
%
%  align_ibm1
% 
%  This function implements the training of the IBM-1 word alignment algorithm. 
%  We assume that we are implementing P(foreign|english)
%
%  INPUTS:
%
%       dataDir      : (directory name) The top-level directory containing 
%                                       data from which to train or decode
%                                       e.g., '/u/cs401/A2_SMT/data/Toy/'
%       numSentences : (integer) The maximum number of training sentences to
%                                consider. 
%       maxIter      : (integer) The maximum number of iterations of the EM 
%                                algorithm.
%       fn_AM        : (filename) the location to save the alignment model,
%                                 once trained.
%
%  OUTPUT:
%       AM           : (variable) a specialized alignment model structure
%
%
%  The file fn_AM must contain the data structure called 'AM', which is a 
%  structure of structures where AM.(english_word).(foreign_word) is the
%  computed expectation that foreign_word is produced by english_word
%
%       e.g., LM.house.maison = 0.5       % TODO
% 
% Template (c) 2011 Jackie C.K. Cheung and Frank Rudzicz
  
  global CSC401_A2_DEFNS
  
  AM = struct();
  
  % Read in the training data
  [eng, fr] = read_hansard(trainDir, numSentences);

  % Initialize AM uniformly 
  AM = initialize(eng, fr, numSentences);
% 
  % Iterate between E and M steps
  for iter=1:maxIter,
    AM = em_step(AM, eng, fre);
  end

  % Save the alignment model
  save( fn_AM, 'AM', '-mat'); 

  end





% --------------------------------------------------------------------------------
% 
%  Support functions
%
% --------------------------------------------------------------------------------

function [eng, fr] = read_hansard(mydir, numSentences)
%
% Read 'numSentences' parallel sentences from texts in the 'dir' directory.
%
% Important: Be sure to preprocess those texts!
%
% Remember that the i^th line in fubar.e corresponds to the i^th line in fubar.f
% You can decide what form variables 'eng' and 'fre' take, although it may be easiest
% if both 'eng' and 'fre' are cell-arrays of cell-arrays, where the i^th element of 
% 'eng', for example, is a cell-array of words that you can produce with
%
%         eng{i} = strsplit(' ', preprocess(english_sentence, 'e'));
%
  eng = {};
  fr = {};

  DE = dir( [ mydir, filesep, '*', 'e'] );
  DF = dir( [ mydir, filesep, '*', 'e'] );
 
  num_files = min(length(DE), length(DF));
  limitReached = 0;
  
  for iFile = 1:num_files
    linesEng = textread([mydir, filesep, DE(iFile).name], '%s','delimiter','\n');
    linesFr = textread([mydir, filesep, DF(iFile).name], '%s','delimiter','\n');
    for l=1:length(linesEng)
        processedLineEng =  preprocess(linesEng{l}, 'e');
        processedLineFr = preprocess(linesFr{l}, 'f');
        wordsEng = strsplit(' ', processedLineEng);
        wordsFr = strsplit(' ', processedLineFr);
        eng{l} = wordsEng;
        fr{l} = wordsFr;
        if length(eng) == numSentences
            limitReached = 1;
            break
        end
    end
    if limitReached
        break
    end
  end
  
  save(strcat('words_eng-', num2str(numSentences), '.mat'), 'eng');
  save(strcat('words_fr-', num2str(numSentences), '.mat'), 'fr');
  
end


function AM = initialize(eng, fr, numSentences)
%
% Initialize alignment model uniformly.
% Only set non-zero probabilities where word pairs appear in corresponding sentences.
%
    AM = struct(); % AM.(english_word).(foreign_word)
    for iSent=1:numel(eng)
       sentEng = eng{iSent};
       sentFr = fr{iSent};
       for iWordEng=1:numel(sentEng)
           word = sentEng{iWordEng};
           if ~strcmp(word, 'SENTSTART') && ~strcmp(word, 'SENTEND')
               if ~isfield(AM, word)
                  AM.(word) = struct();
               end
               for iWordFr=1:numel(sentFr)
                  wordFr = sentFr(iWordFr);
                  wordFr = wordFr{1};
                  if ~strcmp(wordFr, 'SENTSTART') && ~strcmp(wordFr, 'SENTEND')
                      AM.(word).(wordFr) = 0;
                  end
               end
           end 
       end
    end
    fnEng = fieldnames(AM);
    for iFieldEng=1:length(fnEng)
        wordEng = fnEng(iFieldEng);
        wordEng = wordEng{1};
        fnFr = fieldnames(AM.(wordEng));
        for iFieldFr=1:length(fnFr)
            wordFr = fnFr(iFieldFr);
            wordFr = wordFr{1};
            AM.(wordEng).(wordFr) = 1 / (length(fnFr));
        end
    end
    
    AM.SENTSTART = struct();
    AM.SENTEND = struct();
    AM.SENTSTART.SENTSTART = 1;
    AM.SENTEND.SENTEND = 1;
    save(strcat('AM_struct-', num2str(numSentences), '.mat'), 'AM');

end

function t = em_step(t, eng, fr)
% 
% One step in the EM algorithm.
%
    FECount = struct();
    ECount = struct();
    
    for iEngSent = 1:numel(eng)
        currEngSent = eng{iSent};
        currFrSent = fr{iSent};
        uniqueEng = unique(currEngSent);
        uniqueFr = unique(currFrSent);
        
        for iUniqueFr=1:numel(uniqueFr)
            currUniqueFr = uniqueFr{iUniqueFr};
            denom_c = 0;
            for iUniqueEng=1:numel(uniqueEng)
                currUniqueEng = uniqueEng{iUniqueEng};
                % denom-c += P(f|e) * F.count(f)
                denom_c = denom_c + (t.(currUniqueEng).(currUniqueFr) * length(find(strcmp(currFrSent,currUniqueFr))));
            end
            for iUniqueEng=1:numel(uniqueEng)
                currUniqueEng = uniqueEng{iUniqueEng};
                
                % Update tcount(f,e)
                if ~isfield(FECount, currUniqueFr)
                    FECount.(currUniqueFr) = struct();
                end
                if ~isfield(FECount.(currUniqueFr), currUniqueEng)
                    FECount.(currUniqueFr).(currUniqueEng) = 0;
                end
                countf = length(find(strcmp(currFrSent,currUniqueFr)));
                counte = length(find(strcmp(currEngSent,currUniqueEng)));
                ProbFE = t.(currUniqueEng).(currUniqueFr);
                FECount.(currUniqueFr).(currUniqueEng) = FECount.(currUniqueFr).(currUniqueEng) + (ProbFE * countf * counte / denom_c);
                
                % Update tcount(e)
                if ~isfield(ECount, currUniqueEng)
                    ECount.(currUniqueEng) = 0;
                end
                ECount.(currUniqueEng) = ECount.(currUniqueEng) + (ProbFE * countf * counte / denom_c);
            end
        end
    end
    
    fnE = fieldnames(ECount);
    for iCountE=1:numel(fnE);  
        fnFE = fieldnames(FECount); 
        fnFECount = numel(fieldnames(fnFE));
        for iCountFE=1:fnFECount
            currE = fnE{iCountE};
            currF = fnFE{iCountFE};
            t.(currE).(currF) = FECount.(currF).(currE) / ECount.(currE);
        end
    end

end


