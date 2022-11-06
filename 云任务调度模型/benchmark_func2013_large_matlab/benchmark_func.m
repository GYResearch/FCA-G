
%INPUTS:
% x:       the decision vector to the objective function in form of a column vector
%          it can also be a matrix where each column represent a decision vector.
%
%func_num: the index of the objective function to be evaluated ranging [1,15].
%
%return:   the objective value the specified objective function for the give decision vector.


function fit = benchmark_func(x,cost1,func_num)
 
persistent fnum fhd

if (isempty(fnum) || fnum~= func_num)
    fnum = func_num;
    % 1. Fully-separable Functions
	if     (func_num ==  1) fhd = str2func('f1');
    elseif (func_num ==  2) fhd = str2func('f2');
    elseif (func_num ==  3) fhd = str2func('f3');
    % 2. Partially Additively Separable Functions
    %    2.1. Functions with a separable subcomponent:
	elseif (func_num ==  4) fhd = str2func('f4');
    elseif (func_num ==  5) fhd = str2func('f5');
    elseif (func_num ==  6) fhd = str2func('f6');
    elseif (func_num ==  7) fhd = str2func('f7');
    %    2.2. Functions with no separable subcomponents:
	elseif (func_num ==  8) fhd = str2func('f8');
    elseif (func_num ==  9) fhd = str2func('f9');
    elseif (func_num == 10) fhd = str2func('f10');
    elseif (func_num == 11) fhd = str2func('f11');
    %3. Overlapping Functions 
	elseif (func_num == 12) fhd = str2func('f12');
    elseif (func_num == 13) fhd = str2func('f13');
    elseif (func_num == 14) fhd = str2func('f14');
    % 4. Fully Non-separable Functions
    elseif (func_num == 15) fhd = str2func('f15');
    end

end

fit = feval(fhd, x,cost1);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BASE FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------------
% Sphere Function 
%------------------------------------------------------------------------------
function fit = sphere(x)
    fit = sum(x.*x);
end


%------------------------------------------------------------------------------
% Elliptic Function
%------------------------------------------------------------------------------
function fit = elliptic(x)
    %TODO Do we need symmetry breaking?
    %TODO Implement to support a matrix as input.

    [D ps] = size(x);
    condition = 1e+6;
    coefficients = condition .^ linspace(0, 1, D); 
    fit = coefficients * T_irreg(x).^2; 
end

%------------------------------------------------------------------------------
% Rastrigin's Function
%------------------------------------------------------------------------------
function fit = rastrigin(x)
    [D ps] = size(x);
    A = 10;
    x = T_diag(T_asy(T_irreg(x), 0.2), 10);
    fit = A*(D - sum(cos(2*pi*x), 1)) + sum(x.^2, 1);
end



%------------------------------------------------------------------------------
% Ackley's Function
%------------------------------------------------------------------------------
function fit = ackley(x)
    [D ps] = size(x);
    x = T_irreg(x);
    x = T_asy(x, 0.2);
    x = T_diag(x, 10);
    fit = sum(x.^2,1);
    fit = 20-20.*exp(-0.2.*sqrt(fit./D))-exp(sum(cos(2.*pi.*x),1)./D)+exp(1);
end


%------------------------------------------------------------------------------
% Schwefel's Problem 1.2
%------------------------------------------------------------------------------
function fit = schwefel(x)
    [D ps] = size(x);
    x = T_asy(T_irreg(x), 0.2);
    fit = 0;
    for i = 1:D
        fit = fit + sum(x(1:i,:),1).^2;
    end
end


%------------------------------------------------------------------------------
% Rosenbrock's Function
%------------------------------------------------------------------------------
function fit = rosenbrock(x)
    [D ps] = size(x);
    fit = sum(100.*(x(1:D-1,:).^2-x(2:D, :)).^2+(x(1:D-1, :)-1).^2);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BENCHMARK FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------------
% f1: Shifted Elliptic Function
% D = 1000
%------------------------------------------------------------------------------
function fit = f1(x)
cost = sum(x,2);
M=100;
core_ration = rand(1,M)*1;
mem_ration = rand(1,M)*1;
bw_ration = rand(1,M)*1;
coreration_old =1; 
memration_old =1; 
bwration_old =1;
%总的资源利用率
for j=1:M
  ration_vm(j)=coreration_old + memration_old + bwration_old + core_ration(j)+ mem_ration(j)+ bw_ration(j);
end
ave_ration = sum(ration_vm)/M;
%负载均衡
sum0 = 0;
for j=1:M
  sum0 = (ration_vm(j)-ave_ration)^2;
  sum0 = sum0 + sum0;
end
f0 = sum0/M
%适应度函数：系数分别为0.5和0.5
fit = 0.5 * cost + 0.5 * f0;
%     persistent xopt lb ub
% 
%     [D ps] = size(x);
%     if (isempty(xopt))
%         load 'datafiles/f01.mat';
%         
%     end
% 
%     idx = checkBounds(x, lb, ub);
%     x = x-repmat(xopt, 1, ps);
%     fit = elliptic(x);
%     fit(idx) = NaN;
%     if ~isempty(idx)
%         warning "Some of the solutions are violating boundary constraints.";
%     end
end

%------------------------------------------------------------------------------
% f2: Shifted Rastrigin's Function
% D = 1000
%------------------------------------------------------------------------------
function fit = f2(x)
     
cost = sum(x,2);
M=100;
core_ration = rand(1,M)*1;
mem_ration = rand(1,M)*1;
bw_ration = rand(1,M)*1;
coreration_old =1; 
memration_old =1; 
bwration_old =1;
%总的资源利用率
for j=1:M
  ration_vm(j)=coreration_old + memration_old + bwration_old + core_ration(j)+ mem_ration(j)+ bw_ration(j);
end
ave_ration = sum(ration_vm)/M;
%负载均衡
sum0 = 0;
for j=1:M
  sum0 = (ration_vm(j)-ave_ration)^2;
  sum0 = sum0 + sum0;
end
f0 = sum0/M
%适应度函数：系数分别为0.5和0.5
fit = 0.5 * cost + 0.5 * f0;
%     persistent xopt lb ub
% 
%     [D ps] = size(x);
%     if (isempty(xopt))
%         load 'datafiles/f02.mat';
%         
%     end
% 
%     idx = checkBounds(x, lb, ub);
%     x = x-repmat(xopt, 1, ps);
%     fit = rastrigin(x);
%     fit(idx) = NaN;
%     if ~isempty(idx)
%         warning "Some of the solutions are violating boundary constraints.";
%     end
end

%------------------------------------------------------------------------------
% f3: Shifted Ackley's Function
% D = 1000
%------------------------------------------------------------------------------
function fit = f3(x)
     
cost = sum(x,2);
M=100;
core_ration = rand(1,M)*1;
mem_ration = rand(1,M)*1;
bw_ration = rand(1,M)*1;
coreration_old =1; 
memration_old =1; 
bwration_old =1;
%总的资源利用率
for j=1:M
  ration_vm(j)=coreration_old + memration_old + bwration_old + core_ration(j)+ mem_ration(j)+ bw_ration(j);
end
ave_ration = sum(ration_vm)/M;
%负载均衡
sum0 = 0;
for j=1:M
  sum0 = (ration_vm(j)-ave_ration)^2;
  sum0 = sum0 + sum0;
end
f0 = sum0/M
%适应度函数：系数分别为0.5和0.5
fit = 0.5 * cost + 0.5 * f0;
%     persistent xopt lb ub
% 
%     [D ps] = size(x);
%     if (isempty(xopt))
%         load 'datafiles/f03.mat';
%         
%     end
% 
%     idx = checkBounds(x, lb, ub);
%     x = x-repmat(xopt, 1, ps);
%     fit = ackley(x);
%     fit(idx) = NaN;
%     if ~isempty(idx)
%         warning "Some of the solutions are violating boundary constraints.";
%     end
end


%------------------------------------------------------------------------------
% f4: 7-nonseparable, 1-separable Shifted and Rotated Elliptic Function
% D = 1000
%------------------------------------------------------------------------------
function fit = f4(x,cost1)

    load './Data/task_information/length_t.mat';
    load './Data/task_information/size_t.mat';
    load './Data/VM_information/bw_vm.mat';
    load './Data/VM_information/core_vm.mat';
    load './Data/VM_information/mips_vm.mat';
        
    cost = sum(x,2);%%按行相加
    X=cost1';%%cost1当前是100*1000
    for i=1:size(X,1)
      [row,col] = find(X(i,:));
          for j=1:length(col)
              ration_vm(i)= 100000*100*3*length_t(col(j))/sum(length_t,2);
              ration_vm(i) = ration_vm(i)+ ration_vm(i);
          end
    end
    %总的资源平均利用率
    ave_ration = sum(ration_vm)/size(cost1,2);
    %负载均衡
    for j=1:size(cost1,2)
      sum0 = (ration_vm(j)-ave_ration)^2;
      sum0 = sum0 + sum0;
    end
    f0 = sum0/size(cost1,2);
    %适应度函数：系数分别为0.5和0.5
    fit = 0.8 * cost + 0.2 * f0;   















%     N=1000;%任务数量
%     M=100;%虚拟机数量，bw_vm宽带
%     load './Data/task_information/length_t.mat';
%     load './Data/task_information/size_t.mat';
%     load './Data/VM_information/bw_vm.mat';
%     load './Data/VM_information/core_vm.mat';
%     load './Data/VM_information/mips_vm.mat';
%     
%     % the initial population
%     for popnum =1:50
%         pay=1;
%         for i=1:N
%             for j=round(rand(1,1)*(M-1))+1;
%                 cost1(i,j) = (size_t(i)/bw_vm(j) + length_t(i)/(core_vm(j)*mips_vm(j))).^pay;
%             end
%         end
%         pop = cost1';
%         x=cost1;
%         cost = sum(x,2);
%         length_t = length_t;
%         X=x'
%         for i=1:size(X,1)
%           [row,col] = find(X(i,:));
%               for j=1:length(col)
%                   ration_vm(i)= 100000*100*3*length_t(col(j))/sum(length_t,2);
%                   ration_vm(i) = ration_vm(i)+ ration_vm(i);
%               end
%         end
%         %总的资源平均利用率
%         ave_ration = sum(ration_vm)/size(cost1,2);
%         %负载均衡
%         for j=1:size(cost1,2)
%           sum0 = (ration_vm(j)-ave_ration)^2;
%           sum0 = sum0 + sum0;
%         end
%         f0 = sum0/size(cost1,2)
%         %适应度函数：系数分别为0.5和0.5
%         fit(popnum) = 0.5 * sum(cost) + 0.5 * f0;      
%     end
 
% persistent xopt p s R25 R50 R100 lb ub w
% 
%     [D ps] = size(x);
%     if (isempty(xopt))
%         load 'datafiles/f04.mat';
%         
%     end
% 
%     idx = checkBounds(x, lb, ub);
%     x = x-repmat(xopt,1,ps);
%     fit = 0;
%     ldim = 1;
%     for i=1:length(s)
%         if (s(i) == 25)
%             f = elliptic(R25*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         elseif (s(i) == 50)
%             f = elliptic(R50*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         elseif (s(i) == 100)
%             f = elliptic(R100*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         end
%         fit = fit + w(i)*f;
%     end
%     fit = fit + elliptic(x(p(ldim:end), :));
%     fit(idx) = NaN;
%     if ~isempty(idx)
%         warning "Some of the solutions are violating boundary constraints.";
%     end
end


%------------------------------------------------------------------------------
% f5: 7-nonseparable, 1-separable Shifted and Rotated Rastrigin’s Function
% D = 1000
%------------------------------------------------------------------------------
function fit = f5(x)
 
cost = sum(x,2);
M=100;
core_ration = rand(1,M)*1;
mem_ration = rand(1,M)*1;
bw_ration = rand(1,M)*1;
coreration_old =1; 
memration_old =1; 
bwration_old =1;
%总的资源利用率
for j=1:M
  ration_vm(j)=coreration_old + memration_old + bwration_old + core_ration(j)+ mem_ration(j)+ bw_ration(j);
end
ave_ration = sum(ration_vm)/M;
%负载均衡
sum0 = 0;
for j=1:M
  sum0 = (ration_vm(j)-ave_ration)^2;
  sum0 = sum0 + sum0;
end
f0 = sum0/M
%适应度函数：系数分别为0.5和0.5
fit = 0.5 * cost + 0.5 * f0;
% persistent xopt p s R25 R50 R100 lb ub w
% 
%     [D ps] = size(x);
%     if (isempty(xopt))
%         load 'datafiles/f05.mat';
%         
%     end
% 
%     idx = checkBounds(x, lb, ub);
% 
%     x = x-repmat(xopt,1,ps);
%     fit = 0;
%     ldim = 1;
%     for i=1:length(s)
%         if (s(i) == 25)
%             f = rastrigin(R25*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         elseif (s(i) == 50)
%             f = rastrigin(R50*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         elseif (s(i) == 100)
%             f = rastrigin(R100*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         end
%         fit = fit + w(i)*f;
%     end
%     fit = fit + rastrigin(x(p(ldim:end), :));
%     fit(idx) = NaN;
%     if ~isempty(idx)
%         warning "Some of the solutions are violating boundary constraints.";
%     end
end


%------------------------------------------------------------------------------
% f6: 7-nonseparable, 1-separable Shifted and Rotated Ackley’s Function
% D = 1000
%------------------------------------------------------------------------------
function fit = f6(x)
 cost = sum(x,2);
M=100;
core_ration = rand(1,M)*1;
mem_ration = rand(1,M)*1;
bw_ration = rand(1,M)*1;
coreration_old =1; 
memration_old =1; 
bwration_old =1;
%总的资源利用率
for j=1:M
  ration_vm(j)=coreration_old + memration_old + bwration_old + core_ration(j)+ mem_ration(j)+ bw_ration(j);
end
ave_ration = sum(ration_vm)/M;
%负载均衡
sum0 = 0;
for j=1:M
  sum0 = (ration_vm(j)-ave_ration)^2;
  sum0 = sum0 + sum0;
end
f0 = sum0/M
%适应度函数：系数分别为0.5和0.5
fit = 0.5 * cost + 0.5 * f0;
% persistent xopt p s R25 R50 R100 lb ub w
% 
%     [D ps] = size(x);
%     if (isempty(xopt))
%         load 'datafiles/f06.mat';
%         
%     end
% 
%     idx = checkBounds(x, lb, ub);
%     x = x-repmat(xopt,1,ps);
%     fit = 0;
%     ldim = 1;
%     for i=1:length(s)
%         if (s(i) == 25)
%             f = ackley(R25*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         elseif (s(i) == 50)
%             f = ackley(R50*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         elseif (s(i) == 100)
%             f = ackley(R100*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         end
%         fit = fit + w(i)*f;
%     end
%     fit = fit + ackley(x(p(ldim:end), :));
%     fit(idx) = NaN;
%     if ~isempty(idx)
%         warning "Some of the solutions are violating boundary constraints.";
%     end
end



%------------------------------------------------------------------------------
% f7: 7-nonseparable, 1-separable Shifted Schwefel’s Function 
% D = 1000
%------------------------------------------------------------------------------
function fit = f7(x)
 cost = sum(x,2);
M=100;
core_ration = rand(1,M)*1;
mem_ration = rand(1,M)*1;
bw_ration = rand(1,M)*1;
coreration_old =1; 
memration_old =1; 
bwration_old =1;
%总的资源利用率
for j=1:M
  ration_vm(j)=coreration_old + memration_old + bwration_old + core_ration(j)+ mem_ration(j)+ bw_ration(j);
end
ave_ration = sum(ration_vm)/M;
%负载均衡
sum0 = 0;
for j=1:M
  sum0 = (ration_vm(j)-ave_ration)^2;
  sum0 = sum0 + sum0;
end
f0 = sum0/M
%适应度函数：系数分别为0.5和0.5
fit = 0.5 * cost + 0.5 * f0;
% persistent xopt p s R25 R50 R100 lb ub w
% 
%     [D ps] = size(x);
%     if (isempty(xopt))
%         load 'datafiles/f07.mat';
%         
%     end
% 
%     idx = checkBounds(x, lb, ub);
%     x = x-repmat(xopt,1,ps);
%     fit = 0;
%     ldim = 1;
%     for i=1:length(s)
%         if (s(i) == 25)
%             f = schwefel(R25*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         elseif (s(i) == 50)
%             f = schwefel(R50*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         elseif (s(i) == 100)
%             f = schwefel(R100*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         end
%         fit = fit + w(i)*f;
%     end
%     fit = fit + sphere(x(p(ldim:end), :));
%     fit(idx) = NaN;
%     if ~isempty(idx)
%         warning "Some of the solutions are violating boundary constraints.";
%     end
end



%------------------------------------------------------------------------------
% f8: 20-nonseparable Shifted and Rotated Elliptic Function
% D = 1000
%------------------------------------------------------------------------------
function fit = f8(x)
 cost = sum(x,2);
M=100;
core_ration = rand(1,M)*1;
mem_ration = rand(1,M)*1;
bw_ration = rand(1,M)*1;
coreration_old =1; 
memration_old =1; 
bwration_old =1;
%总的资源利用率
for j=1:M
  ration_vm(j)=coreration_old + memration_old + bwration_old + core_ration(j)+ mem_ration(j)+ bw_ration(j);
end
ave_ration = sum(ration_vm)/M;
%负载均衡
sum0 = 0;
for j=1:M
  sum0 = (ration_vm(j)-ave_ration)^2;
  sum0 = sum0 + sum0;
end
f0 = sum0/M
%适应度函数：系数分别为0.5和0.5
fit = 0.5 * cost + 0.5 * f0;
% persistent xopt p s R25 R50 R100 lb ub w
% 
%     [D ps] = size(x);
%     if (isempty(xopt))
%         load 'datafiles/f08.mat';
%         
%     end
% 
%     idx = checkBounds(x, lb, ub);
%     x = x-repmat(xopt,1,ps);
%     fit = 0;
%     ldim = 1;
%     for i=1:length(s)
%         if (s(i) == 25)
%             f = elliptic(R25*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         elseif (s(i) == 50)
%             f = elliptic(R50*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         elseif (s(i) == 100)
%             f = elliptic(R100*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         end
%         fit = fit + w(i)*f;
%     end
%     fit(idx) = NaN;
%     if ~isempty(idx)
%         warning "Some of the solutions are violating boundary constraints.";
%     end
end


%------------------------------------------------------------------------------
% f9: 20-nonseparable Shifted and Rotated Rastrigin’s Function
% D = 1000
%------------------------------------------------------------------------------
function fit = f9(x)
 cost = sum(x,2);
M=100;
core_ration = rand(1,M)*1;
mem_ration = rand(1,M)*1;
bw_ration = rand(1,M)*1;
coreration_old =1; 
memration_old =1; 
bwration_old =1;
%总的资源利用率
for j=1:M
  ration_vm(j)=coreration_old + memration_old + bwration_old + core_ration(j)+ mem_ration(j)+ bw_ration(j);
end
ave_ration = sum(ration_vm)/M;
%负载均衡
sum0 = 0;
for j=1:M
  sum0 = (ration_vm(j)-ave_ration)^2;
  sum0 = sum0 + sum0;
end
f0 = sum0/M
%适应度函数：系数分别为0.5和0.5
fit = 0.5 * cost + 0.5 * f0;
% persistent xopt p s R25 R50 R100 lb ub w
% 
%     [D ps] = size(x);
%     if (isempty(xopt))
%         load 'datafiles/f09.mat';
%         
%     end
% 
%     idx = checkBounds(x, lb, ub);
%     x = x-repmat(xopt,1,ps);
%     fit = 0;
%     ldim = 1;
%     for i=1:length(s)
%         if (s(i) == 25)
%             f = rastrigin(R25*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         elseif (s(i) == 50)
%             f = rastrigin(R50*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         elseif (s(i) == 100)
%             f = rastrigin(R100*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         end
%         fit = fit + w(i)*f;
%     end
%     fit(idx) = NaN;
%     if ~isempty(idx)
%         warning "Some of the solutions are violating boundary constraints.";
%     end
end



%------------------------------------------------------------------------------
% f10: 20-nonseparable Shifted and Rotated Ackley’s Function
% D = 1000
%------------------------------------------------------------------------------
function fit = f10(x)

cost = sum(x,2);
M=100;
core_ration = rand(1,M)*1;
mem_ration = rand(1,M)*1;
bw_ration = rand(1,M)*1;
coreration_old =1; 
memration_old =1; 
bwration_old =1;
%总的资源利用率
for j=1:M
  ration_vm(j)=coreration_old + memration_old + bwration_old + core_ration(j)+ mem_ration(j)+ bw_ration(j);
end
ave_ration = sum(ration_vm)/M;
%负载均衡
sum0 = 0;
for j=1:M
  sum0 = (ration_vm(j)-ave_ration)^2;
  sum0 = sum0 + sum0;
end
f0 = sum0/M
%适应度函数：系数分别为0.5和0.5
fit = 0.5 * cost + 0.5 * f0;

 
% persistent xopt p s R25 R50 R100 lb ub w
% 
%     [D ps] = size(x);
%     if (isempty(xopt))
%         load 'datafiles/f10.mat';
%         
%     end
% 
%     idx = checkBounds(x, lb, ub);
%     x = x-repmat(xopt,1,ps);
%     fit = 0;
%     ldim = 1;
%     for i=1:length(s)
%         if (s(i) == 25)
%             f = ackley(R25*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         elseif (s(i) == 50)
%             f = ackley(R50*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         elseif (s(i) == 100)
%             f = ackley(R100*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         end
%         fit = fit + w(i)*f;
%     end
%     fit(idx) = NaN;
%     if ~isempty(idx)
%         warning "Some of the solutions are violating boundary constraints.";
%     end
end



%------------------------------------------------------------------------------
% f11: 20-nonseparable Shifted Schwefel’s Function 
% D = 1000
%------------------------------------------------------------------------------
function fit = f11(x)
 cost = sum(x,2);
M=100;
core_ration = rand(1,M)*1;
mem_ration = rand(1,M)*1;
bw_ration = rand(1,M)*1;
coreration_old =1; 
memration_old =1; 
bwration_old =1;
%总的资源利用率
for j=1:M
  ration_vm(j)=coreration_old + memration_old + bwration_old + core_ration(j)+ mem_ration(j)+ bw_ration(j);
end
ave_ration = sum(ration_vm)/M;
%负载均衡
sum0 = 0;
for j=1:M
  sum0 = (ration_vm(j)-ave_ration)^2;
  sum0 = sum0 + sum0;
end
f0 = sum0/M
%适应度函数：系数分别为0.5和0.5
fit = 0.5 * cost + 0.5 * f0;
% persistent xopt p s R25 R50 R100 lb ub w
% 
%     [D ps] = size(x);
%     if (isempty(xopt))
%         load 'datafiles/f11.mat';
%         
%     end
% 
%     idx = checkBounds(x, lb, ub);
%     x = x-repmat(xopt,1,ps);
%     fit = 0;
%     ldim = 1;
%     for i=1:length(s)
%         if (s(i) == 25)
%             f = schwefel(R25*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         elseif (s(i) == 50)
%             f = schwefel(R50*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         elseif (s(i) == 100)
%             f = schwefel(R100*x(p(ldim:ldim+s(i)-1), :));
%             ldim = ldim + s(i);
%         end
%         fit = fit + w(i)*f;
%     end
%     fit(idx) = NaN;
%     if ~isempty(idx)
%         warning "Some of the solutions are violating boundary constraints.";
%     end
end


%------------------------------------------------------------------------------
% f12: Shifted Rosenbrock’s Function
% D = 1000
%------------------------------------------------------------------------------
function fit = f12(x)
    cost = sum(x,2);
M=100;
core_ration = rand(1,M)*1;
mem_ration = rand(1,M)*1;
bw_ration = rand(1,M)*1;
coreration_old =1; 
memration_old =1; 
bwration_old =1;
%总的资源利用率
for j=1:M
  ration_vm(j)=coreration_old + memration_old + bwration_old + core_ration(j)+ mem_ration(j)+ bw_ration(j);
end
ave_ration = sum(ration_vm)/M;
%负载均衡
sum0 = 0;
for j=1:M
  sum0 = (ration_vm(j)-ave_ration)^2;
  sum0 = sum0 + sum0;
end
f0 = sum0/M
%适应度函数：系数分别为0.5和0.5
fit = 0.5 * cost + 0.5 * f0; 
%     persistent xopt lb ub 
% 
%     [D ps] = size(x);
%     if (isempty(xopt))
%         load 'datafiles/f12.mat';
%         
%     end
% 
%     idx = checkBounds(x, lb, ub);
%     x = x-repmat(xopt, 1, ps);
%     fit = rosenbrock(x);
%     fit(idx) = NaN;
%     if ~isempty(idx)
%         warning "Some of the solutions are violating boundary constraints.";
%     end
end


%------------------------------------------------------------------------------
% f13: Shifted Schwefel’s Function with Conforming Overlapping Subcomponents
% D = 905
%------------------------------------------------------------------------------
function fit = f13(x)
 cost = sum(x,2);
M=100;
core_ration = rand(1,M)*1;
mem_ration = rand(1,M)*1;
bw_ration = rand(1,M)*1;
coreration_old =1; 
memration_old =1; 
bwration_old =1;
%总的资源利用率
for j=1:M
  ration_vm(j)=coreration_old + memration_old + bwration_old + core_ration(j)+ mem_ration(j)+ bw_ration(j);
end
ave_ration = sum(ration_vm)/M;
%负载均衡
sum0 = 0;
for j=1:M
  sum0 = (ration_vm(j)-ave_ration)^2;
  sum0 = sum0 + sum0;
end
f0 = sum0/M
%适应度函数：系数分别为0.5和0.5
fit = 0.5 * cost + 0.5 * f0;
% persistent xopt p s R25 R50 R100 m c lb ub w
% 
%     [D ps] = size(x);
%     if (isempty(xopt))
%         load 'datafiles/f13.mat';
%         c = cumsum(s);
%         
%     end
% 
%     idx = checkBounds(x, lb, ub);
%     x = x-repmat(xopt,1,ps);
%     fit = 0;
%     for i=1:length(s)
%         if i == 1
%             ldim = 1;
%         else
%             ldim = c(i-1) - ((i-1)*m) + 1;
%         end
%         udim = c(i) - ((i-1)*m);
%         if (s(i) == 25)
%             f = schwefel(R25*x(p(ldim:udim), :));
%         elseif (s(i) == 50)
%             f = schwefel(R50*x(p(ldim:udim), :));
%         elseif (s(i) == 100)
%             f = schwefel(R100*x(p(ldim:udim), :));
%         end
%         fit = fit + w(i)*f;
%     end
%     fit(idx) = NaN;
%     if ~isempty(idx)
%         warning "Some of the solutions are violating boundary constraints.";
%     end
end


%------------------------------------------------------------------------------
% f14: Shifted Schwefel’s Function with Conflicting Overlapping Subcomponents
% D = 905
%------------------------------------------------------------------------------
function fit = f14(x)
 cost = sum(x,2);
M=100;
core_ration = rand(1,M)*1;
mem_ration = rand(1,M)*1;
bw_ration = rand(1,M)*1;
coreration_old =1; 
memration_old =1; 
bwration_old =1;
%总的资源利用率
for j=1:M
  ration_vm(j)=coreration_old + memration_old + bwration_old + core_ration(j)+ mem_ration(j)+ bw_ration(j);
end
ave_ration = sum(ration_vm)/M;
%负载均衡
sum0 = 0;
for j=1:M
  sum0 = (ration_vm(j)-ave_ration)^2;
  sum0 = sum0 + sum0;
end
f0 = sum0/M
%适应度函数：系数分别为0.5和0.5
fit = 0.5 * cost + 0.5 * f0;
% persistent xopt p s R25 R50 R100 m c lb ub w
% 
%     [D ps] = size(x);
%     if (isempty(xopt))
%         load 'datafiles/f14.mat';
%         c = cumsum(s);
%         
%     end
% 
%     idx = checkBounds(x, lb, ub);
%     fit = 0;
%     for i=1:length(s)
%         if i == 1
%             ldim = 1;
%             ldimshift = 1;
%         else
%             ldim = c(i-1) - ((i-1)*m) + 1;
%             ldimshift = c(i-1) + 1;
%         end
%         udim = c(i) - ((i-1)*m);
%         udimshift = c(i);
%         z = x(p(ldim:udim), :) - repmat(xopt(ldimshift:udimshift), 1, ps);
%         if (s(i) == 25)
%             f = schwefel(R25*z);
%         elseif (s(i) == 50)
%             f = schwefel(R50*z);
%         elseif (s(i) == 100)
%             f = schwefel(R100*z);
%         end
%         fit = fit + w(i)*f;
%     end
%     fit(idx) = NaN;
%     if ~isempty(idx)
%         warning "Some of the solutions are violating boundary constraints.";
%     end
end


%------------------------------------------------------------------------------
% f15: Shifted Schwefel’s Function
% D = 1000
%------------------------------------------------------------------------------
function fit = f15(x)
    cost = sum(x,2);
M=100;
core_ration = rand(1,M)*1;
mem_ration = rand(1,M)*1;
bw_ration = rand(1,M)*1;
coreration_old =1; 
memration_old =1; 
bwration_old =1;
%总的资源利用率
for j=1:M
  ration_vm(j)=coreration_old + memration_old + bwration_old + core_ration(j)+ mem_ration(j)+ bw_ration(j);
end
ave_ration = sum(ration_vm)/M;
%负载均衡
sum0 = 0;
for j=1:M
  sum0 = (ration_vm(j)-ave_ration)^2;
  sum0 = sum0 + sum0;
end
f0 = sum0/M
%适应度函数：系数分别为0.5和0.5
fit = 0.5 * cost + 0.5 * f0; 
%     persistent xopt lb ub
% 
%     [D ps] = size(x);
%     if (isempty(xopt))
%         load 'datafiles/f15.mat';
%         
%     end
% 
%     idx = checkBounds(x, lb, ub);
%     x = x-repmat(xopt, 1, ps);
%     fit = schwefel(x);
%     fit(idx) = NaN;
%     if ~isempty(idx)
%         warning "Some of the solutions are violating boundary constraints.";
%     end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% HELPER FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------------
% This transformation function is used to break the symmetry of symmetric 
% functions.
%------------------------------------------------------------------------------
function g = T_asy(f, beta)
    [D popsize] = size(f);
    g = f;
    temp = repmat(beta * linspace(0, 1, D)', 1, popsize); 
    ind = f > 0;
    g(ind) = f(ind).^ (1 + temp(ind) .* sqrt(f(ind)));  
end


%------------------------------------------------------------------------------
% This transformation is used to create the ill-conditioning effect.
%------------------------------------------------------------------------------
function g = T_diag(f, alpha)
    [D popsize] = size(f);
    scales = repmat(sqrt(alpha) .^ linspace(0, 1, D)', 1, popsize); 
    g = scales .* f;
end


%------------------------------------------------------------------------------
% This transformation is used to create smooth local irregularities.
%------------------------------------------------------------------------------
function g = T_irreg(f)
   a = 0.1;
   g = f; 
   idx = (f > 0);
   g(idx) = log(f(idx))/a;
   g(idx) = exp(g(idx) + 0.49*(sin(g(idx)) + sin(0.79*g(idx)))).^a;
   idx = (f < 0);
   g(idx) = log(-f(idx))/a;
   g(idx) = -exp(g(idx) + 0.49*(sin(0.55*g(idx)) + sin(0.31*g(idx)))).^a;
end


%------------------------------------------------------------------------------
% This function tests a given decision vector against the boundaries of a function.
%------------------------------------------------------------------------------
function indices = checkBounds(x, lb, ub)
    indices = find(sum(x > ub | x < lb) > 0);
end

