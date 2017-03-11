% %
% % evalAlign
% %
% %  This is simply the script (not the function) that you use to perform your evaluations in 
% %  Task 5. 
% 
% % some of your definitions
trainDir     = '/u/cs401/A2_SMT/data/Hansard/Training';
testDir      = '/u/cs401/A2_SMT/data/Hansard/Testing';
fn_LME       = 'training_english.mat';
fn_LMF       = 'training_french.mat';
lm_type      = '';
delta        = 0;
vocabSize    = 27726; 
numSentences = 1000;

% refFiles = ['Task5.e', 'Task5.google.e'];
% canFiles = ['candidates-1000.txt', 'candidates-5000.txt', 'candidates-10000.txt', 'candidates-30000.txt'];

LME = lm_train(trainDir, 'e', fn_LME);
LMF = lm_train(trainDir, 'f', fn_LMF);

AMFE = align_ibm1(trainDir, numSentences, 100, 'am.mat');
AM = load('am.mat');

fsents = {'Dans le monde reel, il n''y a rien de mal a cela.',
'Cela vaut pour tous les deputes.',
'Je ne pense pas que ce soit la notre objectif.',
'Que tous ceux qui appuient la motion veuillent bien dire oui.',
'Le bonne nouvelle est que Postes Canada est tout ouie.',
'La question se pose donc, pourquoi?',
'Les deputes liberaux sont nombreux a representer des circonscription rurales.',
'Nous vivons dans une democratie.',
'C''est le comble du ridicule',
'A mon avis, les non l''emportent',
'Tous les deputes de tous les partis connaissent bien ces programmes',
'Nous n''avons pas l''intention de mettre fin a cela.',
'Tachons d''honorer nos engagements de Kyoto.',
'Le ministre des Finances a sabre a tour de bras dans les transferts aux provinces.'
'Mais laissons cela et entrons dans le coeur du debat.',
'Nous estimons qu''il est possible de faire mieux.',
'C''est le plus pur style liberal.',
'Nous y revoila, et le premier ministre va determiner qui est le president du conseil.',
'Il est clair que cela constituerait un conflit d''interets.',
'Nous nous rejouissons de ces nouvelles perspectives.',
'Je declare la motion rejetee.',
'Et plus de cinq deputes s''etant leves:',
'Je ne crois pas que ce soit la solution du probleme.',
'Je felicite le depute de Winnipeg-Centre d''avoir presente ce projet de loi.',
'Il faut que ca change.'};


% filename = 'candidates.txt';
% fid = fopen(filename, 'w');
decoded = {};
for iSentsFr=1:numel(fsents)
    decoded{iSentsFr} = decode2(fsents{iSentsFr}, LM, AMs{iAMs}, '', 0, vocabSize);
end
% fclose(fid);

% not google
ref1 = {'In the real world there is nothing wrong with that.',
'That is true for every member of Parliament.',
'I would think this is not at all what we want to do here.',
'All those in favour of the motion will please say yea.',
'The good news is that Canada Post is listening.',
'We have to ask why.',
'Many Liberal members come from rural ridings.',
'We live in a democracy.',
'I cannot imagine anything so ridiculous.'
'In my opinion the nays have it.',
'All members of all parties are aware of these programs.',
'We do not intend to stop that.',
'Let us meet our Kyoto commitments.',
'The Minister of Finance has made deep cuts to provincial transfers.',
'Let us get on with it and continue to engage in debate.',
'We are suggesting that we could pass a better bill.',
'This is reminiscent of the Liberal way of doing things.',
'The Prime Minister will determine who the president of the council will be.',
'Clearly it is a conflict of interest situation.',
'We welcome the opportunity.',
'I declare the motion lost.',
'And more than five members having risen:',
'I do not think a union is the key to solving the problem.',
'I commend the member for Winnipeg centre for bringing forward this bill.',
'Something has to change.'};

%google
ref2 = {'In the real world, there is nothing wrong with that.',
'This applies to all deputies.',
'I do not think it''s our goal.',
'All those in favor will please say yea.',
'The good news is that Canada Post is all ears.',
'The question arises, why?',
'The liberal deputies are many represent a rural constituency.',
'We live in a democracy.',
'It is the height of ridicule',
'In my opinion, the nays',
'All MPs from all parties are familiar with these programs',
'We do not intend to terminate it.',
'Let us try to honor our Kyoto commitments.',
'The finance minister saber vengeance in transfers to the provinces.',
'But let''s leave that and move into the heart of the debate.',
'We believe it is possible to do better.',
'This is the style liberal.',
'We''m back there, and the Prime Minister will determine who is the chairman of the board.',
'Clearly this would be a conflict of interest.',
'We are looking forward to these new opportunities.',
'I declare the motion rejected.',
'And more than five deputies are being leves:',
'I do not think this is the solution of the problem.',
'I congratulate the MP for Winnipeg Centre have presented the bill.',
'It has to change.'};


n = 2;
for i=1:length(decoded)
    
    % unigram precision
    sent = preprocess(decoded{i});
    words = strsplit(' ', sent);
    ref1words = strsplit(' ', preprocess(ref1{i}));
    ref2words = strsplit(' ', preprocess(ref2{i}));
    
    ref1ref2combined = union(ref1words, ref2words);
    N = length(words);
    C = length(intersection(ref1ref2combined, words);
    uniPrec = C / N;
    
    % brevity
    ref1brev = abs(length(words) - length(ref1words));
    ref2brev = abs(length(words) -length(ref2words));
    
    shortest = min(ref1brev, ref2brev);
    
    brevity = length(words) / shortest;
    
    if brevity < 1
        BP = 1;
    else
        BP = exp(1-brevity);
    end
    
end
% 

% % Train your language models. This is task 2 which makes use of task 1
% LME = lm_train( trainDir, 'e', fn_LME );
% LMF = lm_train( trainDir, 'f', fn_LMF );
% 
% % % Train your alignment model of French, given English 
% % AMFE = align_ibm1( trainDir, numSentences );
% % % ... TODO: more 
% 
% % Get alignment models
% AM = load('am.mat');
% 
% % TODO: a bit more work to grab the English and French sentences. 
% %       You can probably reuse your previous code for this  
% 
% % Decode the test sentence 'fre'
% eng = decode( fre, LME, AMFE, 'smooth', delta, vocabSize );
%  
% 
% [status, result] = unix('')