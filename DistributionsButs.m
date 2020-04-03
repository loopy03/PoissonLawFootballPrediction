clear all
close all
clc

%% Calculs des distributions de buts marqués par chaque équipe en L1 lors de la saisons 2018 - 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('F12018_transf') % Données prélablement formatées
T=F12018_transf;
x=0:10;

teams = unique(T.Team); % équipes participants à la compétition

figure(1)
for i=1:length(teams)

    pd{i} = fitdist(T.Goals(T.Team==cellstr(teams(i))),'poisson'); % Regression par loi de Poisson
    y_gene{i} = poisspdf(x,pd{i}.lambda) ;
    
    subplot(4,5,i)    
    histogram(T.Goals(T.Team==cellstr(teams(i))),'Normalization','probability');  % Disribution de buts marqués
    hold on
    plot(x,y_gene{i},'LineWidth',1.5)  % Tracé de la loi de Poisson
    
    title(cellstr(teams(i)))
    ylim([0 0.5])
    text(8,0.05,['\lambda=',num2str(pd{i}.lambda,3)])
    xlabel('Nb de buts');
    ylabel('Fréquence');
    
end