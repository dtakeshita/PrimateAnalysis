function  [psd, F, Pfft, Ffft] = calcPowerSpec(elements, Fs, st,ed)
    if nargin == 0
        %close; 
        clear;
        %add AUImodel to the path
        setAUImodel_path();
        dat_path = '/Users/dtakeshi/Documents/Data/PrimateData/LYAPB';
        %fname = 'Elements_081809Bc2_ConditionAmes_nDat50000_Amp0_1_HoldNeg60.mat';
        fname = 'Elements_081809Bc2_ConditionLYAPB2_nDat50000_Amp0_1_HoldNeg60.mat';
        dat = load(fullfile(dat_path,fname));
        elements = dat.elements;
        st = 1;
        ed = 40000;
        Fs = 10000;
    end
    dat0 = cellfun(@(e)e.responses.Amp_1.data,elements,'unif',0);
    dat = cellfun(@(d)d(st:ed),dat0,'unif',0);
    [psd,F] = cellfun(@(d)pwelch(d,[],[],[],Fs,'onesided'),dat,'unif',0);
    % fft
    L = cellfun(@length, dat,'unif',0);
    N = cellfun(@(l)2^nextpow2(l),L,'unif',0);
    Y = cellfun(@(x,n)fft(x,n),dat,N,'unif',0);
    Ffft = cellfun(@(n)Fs*(0:(n/2))/n,N,'unif',0);
    Pfft = cellfun(@(y,n)abs(y(1:n/2+1)/n),Y,N,'unif',0);
    
    %startTime = getStartTime(elements);
    if nargin == 0
        figure;
        subplot(2,2,1)
        loglog(F{1},psd{1},'k')
        hold on
        loglog(Ffft{1},Pfft{1})
        subplot(2,2,2)
        loglog(F{end},psd{end},'r')
        hold on
        loglog(Ffft{end},Pfft{end})
        title(fname,'interpreter','none')
    end
end