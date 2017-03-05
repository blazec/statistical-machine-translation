function outSentence = separatePunctuations(inSentence)
     % For both
    %languages, separate sentence-final punctuation (sentences have already been determined for you), commas,
    %colons and semicolons, parentheses, dashes between parentheses, mathematical operators (e.g., +, -, <,
    %>, =), and quotation marks.
    
  outSentence = inSentence;
  
  outSentence = regexprep(outSentence, '\.', ' . ');
  outSentence = regexprep(outSentence, '\?', ' ? ');
  outSentence = regexprep(outSentence, '\!', ' ! ');
  outSentence = regexprep(outSentence, '\"', ' " ');
  outSentence = regexprep(outSentence, '\:', ' : ');
  outSentence = regexprep(outSentence, '\;', ' ; ');
  outSentence = regexprep(outSentence, '\(', ' ( ');
  outSentence = regexprep(outSentence, '\)', ' ) ');
  outSentence = regexprep(outSentence, '\-', ' - ');
  outSentence = regexprep(outSentence, '\+', ' + ');
  outSentence = regexprep(outSentence, ']\<', ' < ');
  outSentence = regexprep(outSentence, '\>', ' > ');
  outSentence = regexprep(outSentence, '\=', ' = ');
  
  % trim whitespaces
  outSentence = regexprep(outSentence, '\s+', ' ');

end