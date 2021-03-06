clear; close all;
%% paths
list_path = '/Users/dtakeshi/Dropbox/AlaLaurila-Lab-Yoda/Patch rig/CellList';
save_path = '/Users/dtakeshi/analysis/summaryPlots/PreliminaryAnalysis/PrimateAnalysis/WC/LYAPB';
lw = 2;
st = 1; ed = 40000;
Fs = 10000;
setAUImodel_path();
dat_path = '/Volumes/PALHD23/primateData/LYAPB';
%dat_path = '/Users/dtakeshi/Documents/Data/PrimateData/LYAPB';


[props, keys] = load_celllist('Primate*LYAPB', list_path);
cellNames = props('CellName');
conditions = props('Condition');
elementsUsed = props('Elements used');
doAnalysis = cellfun(@(p)strcmpi(p,'x'),props('Analyze'));
hasCellName = cellfun(@ischar,cellNames);
idx = [find(hasCellName);length(hasCellName)+1];
idxPerCell = arrayfun(@(i)idx(i):idx(i+1)-1,1:length(idx)-1,'unif',0);
nCells = length(idxPerCell);
for nc=1:nCells
    cname = cellNames{idxPerCell{nc}};
    indices = idxPerCell{nc};
    h = figure;
    str_legend = {};
    for ni = 1:length(indices)
        if ~doAnalysis(indices(ni))
            continue;
        end
        condition = conditions{indices(ni)};
        idxUsed = eval([elementsUsed{indices(ni)}]);
        %str_file = sprintf('Elements_%s*.mat', cname);
        str_file = sprintf('Elements_%s_Condition%s*.mat', cname, condition);
        files = dir(fullfile(dat_path, str_file));
        nfiles = length(files);
        if length(nfiles)>1
           error('More than one file for a single condition'); 
        end
        elements = loadElements(files(1).name,dat_path);
        %% to-do: copmare results with FFT
        [psd, F, Pfft, Ffft] = calcPowerSpec(elements, Fs, st,ed);
        %% choose elements specified
        F_used = F(idxUsed);
        Pxx_used = psd(idxUsed);
        Ffft_used = Ffft(idxUsed);
        Pfft_used = Pfft(idxUsed);

        %% take average over elements
        psd_ave = mean(cell2mat(Pxx_used'),2);
        Pfft_ave = mean(cell2mat(Pfft_used),1);
        %% plot average
        if ~isempty(strfind(lower(condition),'ames'))
            clr = 'k';
            str_legend{end+1} = 'Ames';
        elseif ~isempty(strfind(lower(condition),'lyapb'))
            clr = 'r';
            str_legend{end+1} = 'LY/APB';
        end
        ah_welch = subplot(2,1,1)
        Fave = F_used{1};
        lh = loglog(Fave,psd_ave,clr);
        set(ah_welch,'xlim',[Fave(1) Fave(end)]);
        set(lh,'linewidth',2)
        hold on
        title(sprintf('%s with Welch''s method',cname))
        ah_fft = subplot(2,1,2)
        Fave_fft = Ffft_used{1};
        lh = loglog(Fave_fft, Pfft_ave,clr);
        set(ah_fft,'xlim',[Fave(1) Fave(end)]);
        set(lh,'linewidth',2)
        hold on
        title(sprintf('%s with FFT',cname))
        
        
        
        %% plot individuals
%         
%        
%         hold on 
%         h = cellfun(@(f,p)loglog(f,p,clr),F_used,Pxx_used,'unif',0);
%         set(gca,'xscale','log','yscale','log')
    end
    % change figure size
    set(gcf,'PaperUnits','centimeters')
    set(gcf,'PaperPosition',[0 0 15 25])
    %% add legend
    legend(ah_welch, str_legend)
    set([ah_welch ah_fft],'fontsize',18)
    xlabel(ah_welch,'Frequency (Hz)')
    xlabel(ah_fft,'Frequency (Hz)')
    ylabel(ah_welch,'PSD')
    ylabel(ah_fft,'PSD')
    % save figure
    sname = sprintf('PSD_LYAPB_%s',cname);
    saveas(h, fullfile(save_path,sname),'fig');
    saveas(h, fullfile(save_path,sname),'png');
    
end


