%___________________________________________________________________%
%  Grey Wold Optimizer (GWO) source codes version 1.0               %
%                                                                   %
%  Developed in MATLAB R2011b(7.13)                                 %
%                                                                   %
%  Author and programmer: Seyedali Mirjalili                        %
%                                                                   %
%         e-Mail: ali.mirjalili@gmail.com                           %
%                 seyedali.mirjalili@griffithuni.edu.au             %
%                                                                   %
%       Homepage: http://www.alimirjalili.com                       %
%                                                                   %
%   Main paper: S. Mirjalili, S. M. Mirjalili, A. Lewis             %
%               Grey Wolf Optimizer, Advances in Engineering        %
%               Software , in press,                                %
%               DOI: 10.1016/j.advengsoft.2013.12.007               %
%                                                                   %
%___________________________________________________________________%

% You can simply define your cost in a seperate file and load its handle to fobj 
% The initial parameters that you need are:
%__________________________________________
% fobj = @YourCostFunction
% dim = number of your variables
% Max_iteration = maximum number of generations
% SearchAgents_no = number of search agents
% lb=[lb1,lb2,...,lbn] where lbn is the lower bound of variable n
% ub=[ub1,ub2,...,ubn] where ubn is the upper bound of variable n
% If all the variables have equal lower bound you can just
% define lb and ub as two single number numbers

% To run GWO: [Best_score,Best_pos,GWO_cg_curve]=GWO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj)
%__________________________________________

clear all 
clc

SearchAgents_no=30; % Number of search agents

Function_name='F3'; % Name of the test function that can be from F1 to F23 (Table 1,2,3 in the paper)

Max_iteration=500; % Maximum numbef of iterations

score=zeros(20,9);
for i=1:20

j=1;
% Load details of the selected benchmark function
[lb,ub,dim,fobj]=Get_Functions_details(Function_name);

[Best_score_1,Best_pos_1,GWO_cg_curve]=GWO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
score(i,j)=Best_score_1;
j=j+1;
[Best_score_2,Best_pos_2,DGWO_cg_curve]=DGWO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
score(i,j)=Best_score_2;
j=j+1;
[Best_score_3,Best_pos_3,NGWO_1_cg_curve]=NGWO_1(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
score(i,j)=Best_score_3;
j=j+1;
[Best_score_4,Best_pos_4,NGWO_2_cg_curve]=NGWO_2(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
score(i,j)=Best_score_4;
j=j+1;
[Best_score_5,Best_pos_5,NGWO_3_cg_curve]=NGWO_3(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
score(i,j)=Best_score_5;
j=j+1;
[Best_score_6,Best_pos_6,NGWO_4_cg_curve]=NGWO_4(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
score(i,j)=Best_score_6;
j=j+1;
[Best_score_7,Best_pos_7,AGWO_1_cg_curve]=AGWO_1(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
score(i,j)=Best_score_7;
j=j+1;
[Best_score_8,Best_pos_8,AGWO_2_cg_curve]=AGWO_2(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
score(i,j)=Best_score_8;
j=j+1;
[Best_score_9,Best_pos_9,AGWO_3_cg_curve]=AGWO_3(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
score(i,j)=Best_score_9;
j=j+1;
PSO_cg_curve=PSO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj); % run PSO to compare to results

end
Mean=mean(score);
Std=std(score,0,1);

figure('Position',[500 500 660 290])
%Draw search space
if 0
    subplot(1,2,1);
    func_plot(Function_name);
    title('Parameter space')
    xlabel('x_1');
    ylabel('x_2');
    zlabel([Function_name,'( x_1 , x_2 )'])
end
%Draw objective space
%subplot(1,2,2);
plot(1,1)
semilogy(GWO_cg_curve,'Color','k')
hold on
semilogy(NGWO_1_cg_curve,'-s','Color','c')
hold on
semilogy(NGWO_2_cg_curve,'Color','m')
hold on
semilogy(NGWO_3_cg_curve,'Color','y')
hold on
semilogy(AGWO_1_cg_curve,'-h','Color','b')
hold on
semilogy(AGWO_2_cg_curve,'-o','Color','g')
hold on
semilogy(AGWO_3_cg_curve,'-*','Color','r')
hold on
semilogy(PSO_cg_curve,'Color','[0.7451 0.7451 0.7451]')
title('Objective space')
xlabel('Iteration');
ylabel('Best score obtained so far');

axis tight
grid on
box on
legend('GWO','NGWO_1','NGWO_2','NGWO_3','AGWO_1','AGWO_2','AGWO_3','PSO')

display(['The best solution obtained by GWO is : ', num2str(Best_pos_1)]);
display(['The best optimal value of the objective funciton found by GWO is : ', num2str(Best_score_1)]);



