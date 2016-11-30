%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Membres de l'équipe : Équipe 5
% Ahmed Gaaloul
% Gabriel Ruel-Fiset
% Thierry Bellevue
% Date: 2016-12-04
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sbc.pl
%
% Système de bases de connaissances pour Gestion d'employés et de formation
%
% Les besoins à combler sont:
%
% Qui a besoin d'une certification?
% besoin_certification()
%
% Qui a besoin d'une formation?
% besoin_formation()
%
% Qui mérite un avertissement (faiblesses)?
% avertissement()
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- use_module(coquille).
:- dynamic fait/1.


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Élaboration des profiles pour chaque poste
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Commis comptable

si poste(commis) alors taches(calculer_documents).
si poste(commis) alors taches(coder_totaliser).
si poste(commis) alors taches(compiler_donnees).
si poste(commis) alors competences(comptabilite).
si poste(commis) alors competences(savoir_calculer).
si poste(commis) alors competences(savoir_compiler).
si poste(commis) alors competences(savoir_preparer).
si poste(commis) alors exigences(bilinguisme).
si poste(commis) alors exigences(souci_du_detail).
si poste(commis) alors connaissances(bureautique).
si poste(commis) alors connaissances(logiciel_quickbooks).
si poste(commis) alors certifications(diplome_collegial).
si poste(commis) alors experiences(2).
si poste(commis) alors forces(polyvalence).
si poste(commis) alors forces(ordre).

%%% Comptable agréé

si poste(comptable) alors taches(analyser_etats).
si poste(comptable) alors taches(concilier_comptes).
si poste(comptable) alors taches(gerer_comptes).
si poste(comptable) alors competences(comptabilite).
si poste(comptable) alors competences(savoir_analyser).
si poste(comptable) alors competences(savoir_concilier).
si poste(comptable) alors competences(savoir_produire).
si poste(comptable) alors connaissances(bureautique).
si poste(comptable) alors connaissances(logiciel_quickbooks).
si poste(comptable) alors certifications(diplome_universitaire).
si poste(comptable) alors certifications(titre_comptable).
si poste(comptable) alors experiences(4).
si poste(comptable) alors forces(ordonne).
si poste(comptable) alors forces(meticulosite).

%%% Secrétaire comptable

si poste(secretaire) alors taches(preparer_correspondance).
si poste(secretaire) alors taches(fixer_rendezvous).
si poste(secretaire) alors taches(repondre_demandes).
si poste(secretaire) alors competences(comptabilite).
si poste(secretaire) alors exigences(rapidite_clavier).
si poste(secretaire) alors exigences(savoir_formuler).
si poste(secretaire) alors exigences(savoir_commander).
si poste(secretaire) alors exigences(savoir_fixer_rendezvous).
si poste(secretaire) alors certification(diplome_etudes_professionnelles).
si poste(secretaire) alors connaissances(bureautique).
si poste(secretaire) alors experiences(1).
si poste(secretaire) alors forces(rapidite).
si poste(secretaire) alors forces(meticulosite).

%%% Directeur financier

si poste(directeur) alors taches(superviser_production).
si poste(directeur) alors taches(rediger_rapport).
si poste(directeur) alors taches(superviser_equipe).
si poste(directeur) alors competences(communication).
si poste(directeur) alors competences(savoir_rediger).
si poste(directeur) alors competences(savoir_evaluer).
si poste(directeur) alors competences(savoir_planifier).
si poste(directeur) alors exigences(sens_organisation).
si poste(directeur) alors exigences(bilinguisme).
si poste(directeur) alors connaissances(bureautique).
si poste(directeur) alors connaissances(logiciel_quickbooks).
si poste(directeur) alors connaissances(logiciels_comptables).
si poste(directeur) alors certifications(diplome_universitaire).
si poste(directeur) alors certifications(titre_comptable).
si poste(directeur) alors experiences(10).
si poste(directeur) alors forces(leadership).
si poste(directeur) alors forces(discretion).
si poste(directeur) alors forces(meticulosite).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Formations de base
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Un employé permanent doit avoir une formation de base d'employé
si status(permanent) ou status(temporaire) alors formation(employe).
si not(formation(employe)) alors besoin_formation(employe).

%% Un employé nouveau doit avoir la formation des nouveaux employés
si status(nouveau) alors formation(nouvel_employe).
si not(formation(nouvel_employe)) et status(nouveau) alors besoin_formation(nouvel_employe).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Règles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Si l'employé occupe un poste, il doit avoir les connaissances, être capable de faire les tâches et avoir la certification en lien
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% S'il doit superviser et il manque de leadership, il faut l'aviser
si taches(superviser_production) et faiblesses(manque_de_leadership) alors avertissement(leadership).

%% S'il doit superviser la production et qu'il n'a pas de diplôme universitaire, il doit suivre une formation pour la certification
si taches(superviser_production) ou taches(gerer_comptes) et not(certification(diplome_universitaire)) alors besoin_certification(diplome_universitaire).

%% S'il doit compiler les données et qu'il n'a pas de diplôme collégial, il doit suivre une formation pour la certification
si taches(compiler_donnees) et not(certification(diplome_collegial)) alors besoin_certification(diplome_collegial).

%% S'il a la tâche de préparer la correspondance mais qu'il n'est pas rapide au clavier, il doit suivre une formation
si taches(preparer_correspondance) et not(exigences(rapidite_clavier)) alors besoin_formation(rapidite_clavier).

%% S'il doit être rapide au clavier pour son poste mais n'est pas très rapide au travail, il a besoin d'une formation au clavier
si exigences(rapidite_clavier) et faiblesses(lenteur) alors besoin_formation(rapidite_clavier).

%% S'il doit avoir le souci du détail pour son poste mais a une certaine négligeance, il doit être avisé
si exigences(souci_du_detail) et faiblesses(negligeance) alors avertissement(souci_du_detail).

%% S'il faut calculer des documents comptables ou concilier des comptes et que l'employé ce n'est pas dans ses compétences, il doit suivre une formation.
si taches(calculer_documents) ou taches(concilier_comptes) et not(competences(comptabilite)) alors besoin_formation(comptabilite).

%% Si l'employé a un an d'expérience, il doit encore suivre de la formation en comptabilite
si experiences(1) alors besoin_formation(comptabilite).

%% Si ses tâches consitent à fixer des rendez-vous et mais qu'il a des retards, il doit être avisé pour ses retards
si taches(fixer_rendezvous) et faiblesses(retard) alors avertissement(retard).

%% Si les taches consistents à calculer des documents comptables ou de rediger des rapports, et qu'il n'a pas le titre comptable, il a besoin de la certification
si taches(calculer_documents) ou taches(rediger_rapport) et not(certifications(titre_comptable)) alors besoin_certification(titre_comptable).

%% Si l'employé n'a pas de connaissances en bureautique et qu'il a le statut d'employé permanent, il doit suivre une formation de bureautique
si not(connaissances(bureautique)) et status(permanent) alors besoin_formation(bureautique).

%% Si les tâches consistent à gérer les comptes ou de coder et de totaliser ou de rediger des rapports mais n'a pas de connaissances en logiciel Quickbooks, il doit suivre une formation
si taches(gerer_comptes) ou taches(coder_totaliser) ou taches(rediger_rapport) et not(connaissances(logiciel_quickbooks)) alors besoin_formation(logiciel_quickbooks).


%% Base de faits
%% À mettre en commentaires ou enlever
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Benoit Desilets, employé permanent, n'a pas recu sa formation d'employé, occupe le poste de directeur, manque de leadership, est souvent en regard
%%% et n'est pas très bilingue
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fait(status(permanent)).
% fait(not(formation(employe))).
% fait(poste(directeur)).
% fait(faiblesses(manque_de_leadership)).
% fait(faiblesses(retard)).
% fait(not(exigences(bilinguisme))).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Suzanne Turcotte, employée temporaire, a recu sa formation d'employé, occupe le poste de secrétaire, manque de rapidité, se néglige quelques fois
%%% et n'a pas suivi de formation en bureautique
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fait(status(temporaire)).
% fait(formation(employe)).
% fait(poste(secretaire)).
% fait(faiblesses(lenteur)).
% fait(faiblesses(negligeance)).
% fait(not(connaissances(bureautique))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Vickie Houle, employée permanente, a recu sa formation d'employé, occupe le poste de comptable agrée, ne connait pas le logiciel Quickbooks,
%%% a un diplôme collégial et non universitaire et n'est pas très rapide au clavier
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fait(status(permanent)).
% fait(formation(employe)).
% fait(poste(comptable)).
% fait(not(connaissances(logiciel_quickbooks))).
% fait(not(certification(diplome_universitaire))).
% fait(faiblesses(lenteur)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Patrick Fréchette, nouvel employé, n'a pas recu sa formation de nouvel employé, occupe le poste de commis comptable, ne connait pas le logiciel Quickbooks,
%%% n'a pas de diplôme collégial et n'églige parfois son travail
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fait(status(nouveau)).
% fait(not(formation(employe))).
% fait(poste(commis)).
% fait(not(connaissances(logiciel_quickbooks))).
% fait(not(certification(diplome_collegial))).
% fait(faiblesses(negligeance)).
