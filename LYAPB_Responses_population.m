clear; close all;
%% paths
list_path = '/Users/dtakeshi/Dropbox/AlaLaurila-Lab-Yoda/Patch rig/CellList';
save_root = '/Users/dtakeshi/analysis/summaryPlots/PreliminaryAnalysis/PrimateAnalysis/WC/LYAPB'
dat_path = '/Volumes/PALHD23/primateData/LYAPB';
%dat_path = '/Users/dtakeshi/Documents/Data/PrimateData/LYAPB';
%% set a AUI model path to read primate data files
setAUImodel_path();

lw = 2;
%st = 1; ed = 40000;
Fs = 10000;
[props, keys] = load_celllist('Primate*LYAPB', list_path);
cellNames = props('CellName');
conditions = props('Condition');
amps = props('Amp');
holdSigs = props('HoldingSignal');
nDats = props('nDat');
doAnalysis = cellfun(@(p)strcmpi(p,'x'),props('Analyze'));
hasCellName = cellfun(@ischar,cellNames);
idx = [find(hasCellName);length(hasCellName)+1];
idxPerCell = arrayfun(@(i)idx(i):idx(i+1)-1,1:length(idx)-1,'unif',0);
nCells = length(idxPerCell);
for nc=1:nCells
    indices = idxPerCell{nc};
    cname = cellNames{idxPerCell{nc}};
    indices = indices(doAnalysis(indices));
    if isempty(indices)
        continue;
    end
    ncond = length(indices);
    str_legend = cell(1,ncond);
    FH_charge = figure;
    for ni = 1:ncond
        condition = conditions{indices(ni)};
        str_file = sprintf('Elements_%s_Condition%s*', cname, condition);
        if ~isnan(nDats{indices(ni)})
            str_file = sprintf('%snDat%d*',str_file,nDats{indices(ni)});
        end
        if ~isnan(amps{indices(ni)})
            str_file = sprintf('%sAmp%s*',str_file,strrep(num2str(amps{indices(ni)}),'.','_'));
        end
        if ~isnan(holdSigs{indices(ni)})
            str_file = sprintf('%sHold%s*',str_file,strrep(num2str(holdSigs{indices(ni)}),'-','Neg'));
        end
        str_file = sprintf('%s.mat',str_file);
        files = dir(fullfile(dat_path, str_file));
        nfiles = length(files);
        if nfiles>1
           error('More than one file for a single condition'); 
        end
        fileName = files(1).name;
        elements = loadElements(fileName,dat_path);
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
        holdSig = getHoldSig( fileName );
        amp = getAmp( fileName );
        nDat = getNdat( fileName );
        baseName = sprintf('%s %s Hold%d Amp%g nDat%d',cname, condition, holdSig, amp, nDat);
        FHresponse = plotRawData(baseName, elements, nrow, ncol, figOffset );
        save_fullpath = fullfile(save_root,cname,condition);
        save_base_name = sprintf('%s_%s_Response',cname,condition);
        saveFigures( FHresponse, save_base_name, save_fullpath );
        %% plot charge and holding current
        figure(FH_charge);
        str_legend{ni} = sprintf('%s amp%g hold%d ndat%d',condition,amp, holdSig, nDat);
        ah_charge = subplot(3,1,1);
        hold on
        h = plot(charge,'o-');
        xlabel('# epochs');ylabel('Charge')
        ah_Ihold = subplot(3,1,2);
        hold on 
        plot(IholdMean,'o-')
        xlabel('# epochs');ylabel('Ihold mean') 
        ah_IholdVar = subplot(3,1,3);
        hold on 
        plot(IholdVar,'o-')
        xlabel('# epochs');ylabel('Ihold variance')
    end
    %if exist('ah_charge','var')
        set([ah_charge ah_Ihold ah_IholdVar],'fontsize',14)
        set(ah_IholdVar,'yscale','log')
        legend(ah_charge, str_legend,'location','best')
        title(ah_charge, cname)
        %% save as figures
        save_folder = fullfile(save_root,cname);
        if ~exist(save_folder,'dir')
            mkdir(save_folder);
        end
        saveas(FH_charge,fullfile(save_folder,sprintf('%s_ChargeAndIhold.bmp',cname)))
    %end
end




