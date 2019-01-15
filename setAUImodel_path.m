function setAUImodel_path()
%Set AUImodel on the path - necessary for primate data set 
%AUIModel - files on the server
%(/m/nbe/archive/ala-laurila_lab/data/alalap1/SeattleCode)
    auimodel_path = '/Users/dtakeshi/Documents/MATLAB/PetriCode/matlab/MatlabAUIModel';
    addpath(genpath(auimodel_path));
end

