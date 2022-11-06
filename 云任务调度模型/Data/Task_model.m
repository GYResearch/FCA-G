clear;clc;close all;
%%任务信息
N=1000;%任务数量
size_t = round(rand(1,N)*200)+800;
savePath = ['task_information',filesep];
if ~isfolder(savePath)
    mkdir(savePath);
end
save([savePath, filesep, 'size_t'], 'size_t');
length_t = (round(rand(1,N)*1)+9).*size_t;
save([savePath, filesep, 'length_t'], 'length_t');

%%虚拟机信息
M=100;%虚拟机数量，bw_vm宽带
bw_vm = rand(1,M)*5+1;
%core_vm虚拟机内核数量
core_vm = round(rand(1,M)*8)+4;
%mips_vm虚拟机内核处理速度
mips_vm = rand(1,M)*1+3;
%storage_vm虚拟机内核数量
storage_vm = round(rand(1,M)*2)+2;
savePath = ['VM_information',filesep];
if ~isfolder(savePath)
    mkdir(savePath);
end
save([savePath, filesep, 'bw_vm'], 'bw_vm');
save([savePath, filesep, 'core_vm'], 'core_vm');
save([savePath, filesep, 'mips_vm'], 'mips_vm');
save([savePath, filesep, 'storage_vm'], 'storage_vm');
  
