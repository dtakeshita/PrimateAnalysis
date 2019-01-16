clear; close;
%% paths
list_path = '/Users/dtakeshi/Dropbox/AlaLaurila-Lab-Yoda/Patch rig/CellList';
    
lw = 2;
st = 1; ed = 40000;
Fs = 10000;
setAUImodel_path();
%dat_path = '/Volumes/PALHD23/primateData/LYAPB';
dat_path = '/Users/dtakeshi/Documents/Data/PrimateData/LYAPB';


[props, keys] = load_celllist('Primate*LYAPB', list_path);
cellNames = props('CellName');
conditions = props('Condition');
doAnalysis = cellfun(@(p)strcmpi(p,'x'),props('Analyze'));
hasCellName = cellfun(@ischar,cellNames);
idx = [find(hasCellName);length(hasCellName)+1];
idxPerCell = arrayfun(@(i)idx(i):idx(i+1)-1,1:length(idx)-1,'unif',0);
nCells = length(idxPerCell);
for nc=1:nCells
    cname = cellNames{idxPerCell{nc}};
    indices = idxPerCell{nc};
    ncond = length(indices);
    figure;
    str_legend = cell(1,ncond);
    for ni = 1:ncond
%         if ~doAnalysis(indices(ni))
%             continue;
%         end
        condition = conditions{indices(ni)};
        %str_file = sprintf('Elements_%s*.mat', cname);
        str_file = sprintf('Elements_%s_Condition%s*.mat', cname, condition);
        files = dir(fullfile(dat_path, str_file));
        nfiles = length(files);
        if length(nfiles)>1
           error('More than one file for a single condition'); 
        end
        elements = loadElements(files(1).name,dat_path);
        dat = getData(elements);
        [~,time,stimOn, stimOff, sampleRate] = getStimuliData(elements);
        %% calculate reponses (charge)
        Twindow = 1.0;
        charge = calcCharge(elements, Twindow);
        %% to-do: plot holding current
        ed = cellfun(@(t)find(t<0,1,'last'),time);
        st = ed-round(1.0*sampleRate);
        [IholdMean, IholdVar] = calcHoldingCurrentStat(elements,st, ed);
        %% plot responses
        str_legend{ni} = condition;
        ah_charge = subplot(2,1,1);
        hold on
        h = plot(charge,'o-');
        xlabel('# epochs');ylabel('Charge')
        ah_Ihold = subplot(2,1,2);
        hold on 
        plot(IholdMean,'o-')
        xlabel('# epochs');ylabel('Ihold')
        
    end
    set([ah_charge ah_Ihold],'fontsize',14)
    legend(ah_charge, str_legend,'location','best')
    title(ah_charge, cname)
end


