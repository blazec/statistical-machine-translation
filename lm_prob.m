function logProb = lm_prob(sentence, LM, type, delta, vocabSize)
%
%  lm_prob
% 
%  This function computes the LOG probability of a sentence, given a 
%  language model and whether or not to apply add-delta smoothing
%
%  INPUTS:
%
%       sentence  : (string) The sentence whose probability we wish
%                            to compute
%       LM        : (variable) the LM structure (not the filename)
%       type      : (string) either '' (default) or 'smooth' for add-delta smoothing
%       delta     : (float) smoothing parameter where 0<delta<=1 
%       vocabSize : (integer) the number of words in the vocabulary
%
% Template (c) 2011 Frank Rudzicz

  logProb = -Inf;

  % some rudimentary parameter checking
  if (nargin < 2)
    disp( 'lm_prob takes at least 2 parameters');
    return;
  elseif nargin == 2
    type = '';
    delta = 0;
    vocabSize = length(fieldnames(LM.uni));
  end
  if (isempty(type))
    delta = 0;
    vocabSize = length(fieldnames(LM.uni));
  elseif strcmp(type, 'smooth')
    if (nargin < 5)  
      disp( 'lm_prob: if you specify smoothing, you need all 5 parameters');
      return;
    end
    if (delta <= 0) or (delta > 1.0)
      disp( 'lm_prob: you must specify 0 < delta <= 1.0');
      return;
    end
  else
    disp( 'type must be either '''' or ''smooth''' );
    return;
  end

  words = strsplit(' ', sentence);
  disp(words);
  % TODO: the student implements the following
  
  % Type not specified
  if isempty(type)
      logProb = 0;
      for i = 1:length(words) - 1 
          word1 = lower(words{i});
          word2 = lower(words{i+1});
          
          % Get P(wt+1 | wt
          
          % check if unigram (word1) exists
          if isfield(LM.uni, word1)
            word1count = LM.uni.(word1);
            
            % check if bigram exists
            if isfield(LM.bi, word1)
                if isfield(LM.bi.(word1), word2)
                    word1word2bigramcount = LM.bi.(word1).(word2);
                    logProb = logProb + log2(word1word2bigramcount / word1count);
                end 
            % no bigram exists for combination    
            else
                logProb = log2(0);
                break
            end
          
          % unigram doesn't exist
          else
            logProb = log2(0);
            break
          end
      end 
      
  % Delta smoothing
  else
      
  end

  
  % TODO: once upon a time there was a curmudgeonly orangutan named Jub-Jub.
return