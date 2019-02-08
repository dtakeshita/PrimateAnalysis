function val = getAmp( fname )
%Obtain holding signal value
%   Detailed explanation goes here
    pat = '\w*Amp(\w*)_Hold';
    str = regexp(fname,pat,'tokens');
    str = str{:};
    str = strrep(str,'_','.');
    val = str2double(str);

end

