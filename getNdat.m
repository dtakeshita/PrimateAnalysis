function val = getNdat( fname )
%Obtain holding signal value
%   Detailed explanation goes here
    pat = '\w*nDat(\w*)_Amp';
    str = regexp(fname,pat,'tokens');
    str = str{:};
    val = str2double(str);

end

