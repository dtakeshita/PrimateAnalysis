function [ output_args ] = parseFileList( input_args )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    if nargin == 0
        list_path = '/Users/dtakeshi/Documents/Data/PrimateData/CellInformation';
        fname = 'H5filesListOnAmor.txt';
    end
    txt = textread(fullfile(list_path,fname),'%s');
    % get file name
    pat = '/([^/]*.h5)';
    fileNames = regexp(txt,pat,'tokens');
    if any(find(cellfun(@isempty, fileNames)))
        error('some files are not detected')
    end
    fileNames = cellfun(@(c)c{1}{:},fileNames,'unif',0);
    % get experiment date
    pat = '\w*(\d{6,6})[a-zA-Z_-0-9]*.h5';
    expDate = regexp(fileNames,pat,'tokens');
    hasNoValue = cellfun(@isempty,expDate);
    fileNameDateEmpty = fileNames(hasNoValue)
    expDateNonEmpty = expDate(~hasNoValue);
    % list of experiment dates
    expDate = cellfun(@(c)c{1}{:},expDateNonEmpty,'unif',0);
    expDateUnique = unique(expDate);
    expDateUnique = datetime(expDateUnique,'Format','MMddyy');
    sortedExpDateUnique = sort(expDateUnique)
end

