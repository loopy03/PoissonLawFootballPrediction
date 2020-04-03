clear all
close all
clc

%% Exemple de pr�diction avec le match Marseille - Lyon
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Codes repris de Opthitonka (originellement en R) (http://opisthokonta.net/?p=296)

load('F12018_transf')  % Chargement des donn�es (mises en forme au pr�alable)
T=F12018_transf;

model = fitglm(T,'Distribution','Poisson','Link','log');  % Cr�ation du mod�le lin�aire g��nralis�

pred_table1 = T(T.Team=='Marseille' & T.Opponent=='Lyon' & T.Home==1,:) ;
pred_table2 = T(T.Team=='Lyon' & T.Opponent=='Marseille' & T.Home==0,:) ;

lambda_marseille = predict(model,pred_table1);
lambda_lyon = predict(model,pred_table2);

% Distribution de buts
x=0:10;
y_marseille = poisspdf(x,lambda_marseille) ;
y_lyon = poisspdf(x,lambda_lyon) ;

% Graphe lois de Poisson
figure(1)
plot(x,y_marseille,'-x','LineWidth',1.5)
hold on
plot(x,y_lyon,'-o','LineWidth',1.5)

xlim([0 10])
ylim([0 0.4])
title('Distributions de buts marqu�s (OM-OL)')
xlabel('Nb de buts')
ylabel('Probabilit�')
legend(['Marseille (\lambda=',num2str(lambda_marseille,3),')'],['Lyon (\lambda=',num2str(lambda_lyon,3),')']')

% Distribution diff�rence de buts
x=-8:8 ;
diff = skellampdf( x , lambda_marseille , lambda_lyon ) ;  % Loi de Skellam

% Graphe loi de Skellam
figure(2)
hold on
idx=x>=0&x<=8;
area(x(idx),diff(idx),'FaceAlpha',0.5,'EdgeColor','none');
idx=x>=-8&x<=0;
area(x(idx),diff(idx),'FaceAlpha',0.5,'EdgeColor','none');
idx=x==0;
area(x(idx),diff(idx),'LineWidth',1.5,'EdgeColor','green','EdgeAlpha',0.5,'FaceAlpha',0);
plot(x,diff,'-x','LineWidth',1.5,'color','k')

legend('Cas Marseille gagne','Cas Lyon gagne','Cas match nul','Distribution')
xlim([-8 8])
ylim([0 0.4])
xlabel('Diff�rence de buts')
ylabel('Probabilit�')
title('Distribution de la diff�rence de buts (OM-OL)')

% Calcul des probabilit�s de victoires, d�faites et nul
p_home = sum(skellampdf( 1:100 , lambda_marseille , lambda_lyon )) ;
p_draw = sum(skellampdf( 0 , lambda_marseille , lambda_lyon )) ;
p_away = sum(skellampdf( -100:-1 , lambda_marseille , lambda_lyon )) ;

% Cotes du match (sans marge bookmaker)
cotes = 1./[p_home p_draw p_away];