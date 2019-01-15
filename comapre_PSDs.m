clear; close;
lw = 2;
st = 1; ed = 40000;
Fs = 10000;
setAUImodel_path();
dat_path = '/Volumes/PALHD23/primateData/LYAPB';
%cname = '081809Bc2';
cname = '082609Fc1';
ndat = 65000;
Amp = '0_73';
cond_ames = 'Ames';
cond_lyapb = 'LYAPB1';
fname_Ames = sprintf('Elements_%s_Condition%s_nDat%d_Amp%s_HoldNeg60.mat',...
    cname,cond_ames,ndat,Amp);
fname_lyapb = sprintf('Elements_%s_Condition%s_nDat%d_Amp%s_HoldNeg60.mat',...
    cname,cond_lyapb,ndat,Amp);
elements_ames = loadElements(fname_Ames,dat_path);
elements_lyapb = loadElements(fname_lyapb,dat_path);
[psd_ames, F_ames] = calcPowerSpec(elements_ames, Fs, st,ed);
[psd_lyapb, F_lyapb] = calcPowerSpec(elements_lyapb, Fs, st,ed);

figure;
h_ames = loglog(F_ames{1},psd_ames{1},'k');
hold on
h_ly = loglog(F_lyapb{end},psd_lyapb{end},'r');
title(cname)
legend([h_ames h_ly],{cond_ames,cond_lyapb})
xlabel('Frequency (Hz)');ylabel('PSD')
set(gca,'fontsize',20)
set([h_ames h_ly],'linewidth',lw);


