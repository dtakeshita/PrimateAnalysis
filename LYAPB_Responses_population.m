clear; close all;
%% paths
list_path = '/Users/dtakeshi/Dropbox/AlaLaurila-Lab-Yoda/Patch rig/CellList';
save_root = '/Users/dtakeshi/analysis/summaryPlots/PreliminaryAnalysis/PrimateAnalysis/WC/LYAPB'
dat_path = '/Volumes/PALHD23/primateData/LYAPB';
%dat_path = '/Users/dtakeshi/Documents/Data/PrimateData/LYAPB';
%% set a AUI model path to read primate data files
setAUImodel_path();

lw = 2;
st = 1; ed = 40000;
Fs = 10000;
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
    FH_charge = figure;
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
        Twindow = 1.0;%time window for calculating charge
        charge = calcCharge(elements, Twindow);
        %% Calculate holding current
        ed = cellfun(@(t)find(t<0,1,'last'),time);
        st = ed-round(1.0*sampleRate);
        [IholdMean, IholdVar] = calcHoldingCurrentStat(elements,st, ed);
        %% plot raw data
        nrow = 3; ncol = 2; 
        figOffset = getFigureOffset();
        baseName = sprintf('%s %s',cname, condition);
        FHresponse = plotRawData(baseName, elements, nrow, ncol, figOffset );
        save_fullpath = fullfile(save_root,cname,condition);
        save_base_name = sprintf('%s_%s_Response',cname,condition);
        saveFigures( FHresponse, save_base_name, save_fullpath );
        %% plot charge and holding current
        figure(FH_charge);
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
    %% save as figures
    save_folder = fullfile(save_root,cname);
    if ~exist(save_folder,'dir')
        mkdir(save_folder);
    end
    saveas(FH_charge,fullfile(save_folder,sprintf('%s_ChargeAndIhold.bmp',cname)))
end




