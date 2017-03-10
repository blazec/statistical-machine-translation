function outSentence = preprocess( inSentence, language )
%
%  preprocess
%
%  This function preprocesses the input text according to language-specific rules.
%  Specifically, we separate contractions according to the source language, convert
%  all tokens to lower-case, and separate end-of-sentence punctuation 
%
%  INPUTS:
%       inSentence     : (string) the original sentence to be processed 
%                                 (e.g., a line from the Hansard)
%       language       : (string) either 'e' (English) or 'f' (French) 
%                                 according to the language of inSentence
%
%  OUTPUT:
%       outSentence    : (string) the modified sentence
%
%  Template (c) 2011 Frank Rudzicz 
  warning('off', 'all');
  global CSC401_A2_DEFNS
  
  % first, convert the input sentence to lower-case and add sentence marks 
  inSentence = [CSC401_A2_DEFNS.SENTSTART ' ' lower( inSentence ) ' ' CSC401_A2_DEFNS.SENTEND];

  % trim whitespaces down 
  inSentence = regexprep( inSentence, '\s+', ' '); 

  % initialize outSentence
  outSentence = inSentence;
 
  % perform language-agnostic changes
  outSentence = separatePunctuations(outSentence);

  switch language
   case 'e'
    % TODO: your code here
    % separate clitics and possessives
    outSentence = regexprep(outSentence, ''' s ', '''s ');
    outSentence = regexprep(outSentence, ''' re ', '''re ');
    outSentence = regexprep(outSentence, ''' m ', '''m ');
    outSentence = regexprep(outSentence, ''' ve ', '''ve ');
    outSentence = regexprep(outSentence, ''' d ', '''d ');
    outSentence = regexprep(outSentence, ''' l ', '''l ');
    
   case 'f'
    % Singular definite article (le, la) concatenated word. 
    % Separate leading l? from concatenated word 
    % ex: l?election ? l? election
    outSentence = regexprep(outSentence, '^l '' ', 'l'' ');
    outSentence = regexprep(outSentence, ' l '' ', ' l'' ');
    
    % Single-consonant words ending in e-?muet? (e.g., ?dropped?-e ce, je)
    % Separate leading consonant and apostrophe form concatenated word
    % ex: je t?aime ? je t? aime,
    outSentence = regexprep(outSentence, '^b '' ', 'b'' ');
    outSentence = regexprep(outSentence, ' b '' ', ' b'' ');
    outSentence = regexprep(outSentence, '^c '' ', 'c'' ');
    outSentence = regexprep(outSentence, ' c '' ', ' c'' ');
    outSentence = regexprep(outSentence, '^d '' ', 'd'' ');
    outSentence = regexprep(outSentence, ' d '' ', ' d'' ');
    outSentence = regexprep(outSentence, '^f '' ', 'f'' ');
    outSentence = regexprep(outSentence, ' f '' ', ' f'' ');
    outSentence = regexprep(outSentence, '^g '' ', 'g'' ');
    outSentence = regexprep(outSentence, ' g '' ', ' g'' ');
    outSentence = regexprep(outSentence, '^h '' ', 'h'' ');
    outSentence = regexprep(outSentence, ' h '' ', ' h'' ');
    outSentence = regexprep(outSentence, '^j '' ', 'j'' ');
    outSentence = regexprep(outSentence, ' j '' ', ' j'' ');
    outSentence = regexprep(outSentence, '^k '' ', 'k'' ');
    outSentence = regexprep(outSentence, ' k '' ', ' k'' ');
    outSentence = regexprep(outSentence, '^l '' ', 'l'' ');
    outSentence = regexprep(outSentence, ' l '' ', ' l'' ');
    outSentence = regexprep(outSentence, '^m '' ', 'm'' ');
    outSentence = regexprep(outSentence, ' m '' ', ' m'' ');
    outSentence = regexprep(outSentence, '^n '' ', 'n'' ');
    outSentence = regexprep(outSentence, ' n '' ', ' n'' ');
    outSentence = regexprep(outSentence, '^p '' ', 'p'' ');
    outSentence = regexprep(outSentence, ' p '' ', ' p'' ');
    outSentence = regexprep(outSentence, '^q '' ', 'q'' ');
    outSentence = regexprep(outSentence, ' q '' ', ' q'' ');
    outSentence = regexprep(outSentence, '^r '' ', 'r'' ');
    outSentence = regexprep(outSentence, ' s '' ', ' s'' ');
    outSentence = regexprep(outSentence, '^t '' ', 't'' ');
    outSentence = regexprep(outSentence, ' t '' ', ' t'' ');
    outSentence = regexprep(outSentence, '^v '' ', 'v'' ');
    outSentence = regexprep(outSentence, ' v '' ', ' v'' ');
    outSentence = regexprep(outSentence, '^w '' ', 'w'' ');
    outSentence = regexprep(outSentence, ' w '' ', ' w'' ');
    outSentence = regexprep(outSentence, '^x '' ', 'x'' ');
    outSentence = regexprep(outSentence, ' x '' ', ' x'' ');
    outSentence = regexprep(outSentence, '^y '' ', 'y'' ');
    outSentence = regexprep(outSentence, ' y '' ', ' y'' ');
    outSentence = regexprep(outSentence, '^z '' ', 'z'' ');
    outSentence = regexprep(outSentence, ' z '' ', ' z'' ');
    
    % the following French words should not be separated: 
    % d?abord, d?accord, d?ailleurs, d?habitude.
    outSentence = regexprep(outSentence, 'd '' abord', 'd''abord');
    outSentence = regexprep(outSentence, 'd '' ailleurs', 'd''ailleurs');
    outSentence = regexprep(outSentence, 'd '' habitude', 'd''habitude');
    outSentence = regexprep(outSentence, 'd '' accord', 'd''accord');
    
    % que 
    % Separate leading qu? from concatenated word
    % ex: qu?on ? qu? on,
    outSentence = regexprep(outSentence, '^qu '' ', 'qu'' ');
    outSentence = regexprep(outSentence, ' qu '' ', ' qu'' ');
    
    % Conjunctions puisque and lorsque
    % Separate following on or il
    % ex: puisqu?on ? puisqu? on, lorsqu?il ? lorsqu? il
    outSentence = regexprep(outSentence, 'puisqu '' on', 'puisqu'' on');
    outSentence = regexprep(outSentence, 'puisqu '' il', 'puisqu'' il');
    outSentence = regexprep(outSentence, 'lorsqu '' on', 'lorsqu'' on');
    outSentence = regexprep(outSentence, 'lorsqu '' il', 'lorsqu'' il');
    
  end

  % trim whitespaces
  outSentence = regexprep(outSentence, '\s+', ' ');
  
  % change unpleasant characters to codes that can be keys in dictionaries
  outSentence = convertSymbols( outSentence );

end
