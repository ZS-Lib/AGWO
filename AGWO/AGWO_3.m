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

% Grey Wolf Optimizer
function [Alpha_score,Alpha_pos,Convergence_curve]=AGWO_3(SearchAgents_no,Max_iter,lb,ub,dim,fobj)

% initialize alpha, beta, and delta_pos
Alpha_pos=zeros(1,dim);
Alpha_score=inf; %change this to -inf for maximization problems

Beta_pos=zeros(1,dim);
Beta_score=inf; %change this to -inf for maximization problems

Delta_pos=zeros(1,dim);
Delta_score=inf; %change this to -inf for maximization problems

%Initialize the positions of search agents
Positions=initialization(SearchAgents_no,dim,ub,lb);

Convergence_curve=zeros(1,Max_iter);

l=0;% Loop counter

% Main loop
while l<Max_iter
    for i=1:size(Positions,1)  
        
       % Return back the search agents that go beyond the boundaries of the search space
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;               
        
        % Calculate objective function for each search agent
        fitness=fobj(Positions(i,:));
        
        % Update Alpha, Beta, and Delta
        if fitness<Alpha_score 
            Alpha_score=fitness; % Update alpha
            Alpha_pos=Positions(i,:);
        end
        
        if fitness>Alpha_score && fitness<Beta_score 
            Beta_score=fitness; % Update beta
            Beta_pos=Positions(i,:);
        end
        
        if fitness>Alpha_score && fitness>Beta_score && fitness<Delta_score 
            Delta_score=fitness; % Update delta
            Delta_pos=Positions(i,:);
        end
    end
    
    
    % 求Alpha狼的距角距离变化率
    A=zeros(SearchAgents_no);           %初始化每个狼跟alpha狼的距离矩阵
    for i=1:SearchAgents_no
        var=0;
        for d=1:dim
            var=var+((Positions(i,d)-Alpha_pos(d))^2);    
        end
        std=sqrt(var)/SearchAgents_no;       %每个狼跟alpha狼的距离
        A(i)=std;
    end
    dist1max=max(A);      %最大聚焦距离
    dist1max=dist1max(1);
    dist1ave=sum(A)/SearchAgents_no;    %平均聚焦距离
    dist1ave=dist1ave(1);
    lambda1=(dist1max-dist1ave)/dist1max;    %收敛因子系数
    
    % 求Beta狼的距角距离变化率
    B=zeros(SearchAgents_no);           %初始化每个狼跟alpha狼的距离矩阵
    for i=1:SearchAgents_no
        var=0;
        for d=1:dim
            var=var+((Positions(i,d)-Beta_pos(d))^2);    
        end
        std=sqrt(var)/SearchAgents_no;       %每个狼跟alpha狼的距离
        B(i)=std;
    end
    dist2max=max(B);    %最大聚焦距离
    dist2max=dist2max(1);
    dist2ave=sum(B)/SearchAgents_no;  %平均聚焦距离
    dist2ave=dist2ave(1);
    lambda2=(dist2max-dist2ave)/dist2max;    %收敛因子系数
    
    % 求Delta狼的距角距离变化率
    C=zeros(SearchAgents_no);           %初始化每个狼跟alpha狼的距离矩阵
    for i=1:SearchAgents_no
        var=0;
        for d=1:dim
            var=var+((Positions(i,d)-Delta_pos(d))^2);    
        end
        std=sqrt(var)/SearchAgents_no;       %每个狼跟alpha狼的距离
        C(i)=std;
    end
    dist3max=max(C);      %最大聚焦距离
    dist3max=dist3max(1);
    dist3ave=sum(C)/SearchAgents_no;    %平均聚焦距离
    dist3ave=dist3ave(1);
    lambda3=(dist3max-dist3ave)/dist3max;    %收敛因子系数
    
    a=2-log10(1+6*lambda1*(l/Max_iter)); % a decreases linearly fron 2 to 0
    
    % Update the Position of search agents including omegas
    for i=1:size(Positions,1)
        for j=1:size(Positions,2)     
                       
            r1=rand(); % r1 is a random number in [0,1]
            r2=rand(); % r2 is a random number in [0,1]
            
            A1=2*a*r1-a; % Equation (3.3)
            C1=2*r2; % Equation (3.4)
            
            D_alpha=abs(C1*Alpha_pos(j)-Positions(i,j)); % Equation (3.5)-part 1
            X1=Alpha_pos(j)-A1*D_alpha; % Equation (3.6)-part 1
                       
            r1=rand();
            r2=rand();
            
            A2=2*a*r1-a; % Equation (3.3)
            C2=2*r2; % Equation (3.4)
            
            D_beta=abs(C2*Beta_pos(j)-Positions(i,j)); % Equation (3.5)-part 2
            X2=Beta_pos(j)-A2*D_beta; % Equation (3.6)-part 2       
            
            r1=rand();
            r2=rand(); 
            
            A3=2*a*r1-a; % Equation (3.3)
            C3=2*r2; % Equation (3.4)
            
            D_delta=abs(C3*Delta_pos(j)-Positions(i,j)); % Equation (3.5)-part 3
            X3=Delta_pos(j)-A3*D_delta; % Equation (3.5)-part 3             
            
            w1=(lambda1)/(lambda1+lambda2+lambda3);
            w2=(lambda2)/(lambda1+lambda2+lambda3);
            w3=(lambda3)/(lambda1+lambda2+lambda3);
            Positions(i,j)=(w1*X1+w2*X2+w3*X3)/3;% Equation (3.7)
            
        end
    end
    l=l+1;    
    Convergence_curve(l)=Alpha_score;
end