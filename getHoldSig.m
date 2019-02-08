function val = getHoldSig( fname )
%Obtain holding signal value
%   Detailed explanation goes here
    pat = '\w*Hold(\w*).mat';
    str = regexp(fname,pat,'tokens');
    str = str{:};
    str = strrep(str,'Neg','-');
    val = str2double(str);

end

