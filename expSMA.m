% for i = 1:15
clear all 
close all
clc
tic
% add function
% addpath([pwd,'/CCMWOA']);
%  addpath([pwd,'/Origin']);
%  addpath([pwd,'/statics']);
%  addpath([pwd,'/subFunction']);
%  addpath([pwd,'/cec05']);
addpath(genpath(pwd));
%% parm setting
% option setting
SearchAgents_no=30; % Number of search agents
% Number of the plot dot.
NumofRecord=40;
dim=30;
MaxFEs=300000;
%% basic algoritem
%  algorithmName={'CCMWOA','WOA','BA','FA','MFO'};
%% advanced algorithm
% algorithmName={'CCMWOA','DECLS','CGPSO','ALCPSO','BLPSO'};
%% algorithm
% algorithmName = {'BSSMA_28', 'SHADE', 'SADE', 'gs_SMA_l4'};
% algorithmName = {'WGWO', 'W2GWO', 'W3GWO', 'GWO'};
% algorithmName = {'W3GWO_4', 'W3GWO_8', 'W3GWO_6', 'W3GWO_2'};
% algorithmName = {'SMBSA1', 'SMBSA', 'BSA', 'SMA'};
algorithmName = {'modBSA_revise', 'modBSA_revise2'}


% Flod=10;
% Flod=4;
% Flod=30;
% Flod = 16;
% Flod = 24;    
% Flod=32;
Flod = 4;
%% perpare xlsfile
timestr=datestr(now,'mm-dd_HH_MM');
% dirname=['exp_result/11.18-',algorithmName{1},'-',algorithmName{2},'-',timestr,'-Dim',num2str(dim)];
dirname=['exp_result/', algorithmName{1},'-',timestr];
mkdir(dirname);
% Excel filename.
% filename=[dirname,'/jona-',timestr];
filename=[dirname,'/', algorithmName{1}];

te= {'F','Algrithm','max','min','mean','std'};
xlsfilename=[filename,'.xlsx'];
writecell(te, xlsfilename, 'Sheet', 'overall')
startLineNum=2;% the startLineNum of overall sheet to write data


algrithmNum=size(algorithmName,2);
% generate the space of linestyles, MarkerEdgeColors,Markers
nLines = algrithmNum;
basic_linestyles = cellstr(char('-',':','-.','--'));
basic_Markers    = cellstr(char('o','x','+','*','s','d','v','^','<','>','p','h','.'));
MarkerEdgeColors = hsv(nLines);
linestyles       = repmat(basic_linestyles,ceil(nLines/numel(basic_linestyles)),1);
Markers          = repmat(basic_Markers,ceil(nLines/numel(basic_Markers)),1);
%% =======uncomment for specify function===============
% CEC17  107   CEC14 24   CEC05 54   CEC13 79
%Function

% Function_name_all = {'F107'};
% Function_name_all={'F1','F2','F3','F5','F7','F8','F9','F10','F11','F12','F13','F14','F18','F20','F21','F22','F23','F26','F31','F33','F35','F42','F45','F46','F50','F51','F53','F59','F62','F65','F66','F76','F89','F92','F95','F96','F97','F100'};

% Function_name_all={'F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12','F13','F14','F15','F16','F17','F18','F19','F20','F21','F22','F23'};

% Function_name_all={'F24','F25','F26','F27','F28','F29','F30','F31','F32','F33','F34','F35','F36','F37','F38','F39','F40','F41','F42','F43','F44','F45','F46','F47','F48','F49','F50','F51','F52','F53',...
%  'F107','F108','F109','F110','F111','F112','F113','F114','F115','F116','F117','F118','F119','F120','F121','F122','F123','F124','F125','F126','F127','F128','F129','F130','F131','F132','F133','F134','F135','F136'};
%  Function_name_all={'F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12','F13','F14','F15','F16','F17','F18','F19','F20','F21','F22','F23','F46','F47','F48','F49','F50','F51','F52','F53','F129','F130','F131','F132','F133','F134','F135','F136'};
%Function_name_all={'F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12','F13','F46','F47','F48','F49','F50','F51','F52','F53','F127','F128','F129','F130','F131','F132','F133','F134','F135','F136'};

 
%Function_name_all={'F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12','F13','F15','F21','F22','F23','F41','F46','F47','F48','F50','F51','F52','F53'};
%Function_name_all={'F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12','F13','F14','F15','F16','F17','F18','F19','F20','F21','F22','F23',...
%'F24','F25','F26','F27','F28','F29','F30','F31','F32','F33','F34','F35','F36','F37','F38','F39','F40','F41','F42','F43','F44','F45','F46','F47','F48','F49','F50','F51','F52','F53'};
%  'F107','F108','F109','F110','F111','F112','F113','F114','F115','F116','F117','F118','F119','F120','F121','F122','F123','F124','F125','F126','F127','F128','F129','F130','F131','F132','F133','F134','F135','F136'};
% Function_name_all={'F107','F108','F113','F115','F129','F130','F131','F132','F133','F134','F135','F136'};

% 'CEC17_func'
% Function_name_all={'F107','F108', 'F109','F110','F111','F112','F113','F114','F115','F116','F117','F118','F119','F120','F121','F122','F123','F124','F125','F126', 'F127', 'F128', 'F129','F130','F131','F132','F133','F134','F135','F136'};

% 'CEC17_fun F5-F11'
% Function_name_all = {'F111','F112','F113','F114','F115','F116','F117'}

% 'CEC17_func F1-F4'
% Function_name_all = {'F107', 'F108', 'F109', 'F110'}

% 'CEC17_func F1-F11'
% Function_name_all = {'F107','F108', 'F109','F110','F111','F112','F113','F114','F115','F116','F117'}

% 'CEC17_func F23-F29'
% Function_name_all = {'F129', 'F130', 'F131', 'F132', 'F133', 'F134', 'F135'}

'CEC17_func'
Function_name_all={'F107','F108', 'F109','F110','F111','F112','F113','F114','F115','F116','F117','F118','F119','F120','F121','F122','F123','F124','F125','F126', 'F127', 'F128', 'F129','F130','F131','F132','F133','F134','F135','F136'};



% From F1 to F20
% Function_name_all={'F107','F108','F109','F110','F111','F112','F113','F114','F115','F116','F117','F118','F119','F120','F121','F122','F123','F124','F125','F126'};
% Function_name_all={'F111','F112','F113','F114','F115'};

% Function_name_all={'F127','F128','F129','F130','F131','F132','F133','F134','F135','F136'};
%Function_name_all={'F107','F108','F109','F110','F111','F112','F113','F114','F115','F116','F117','F118','F119','F120','F121','F122','F123','F124','F125','F126','F127','F128','F129','F130','F131','F132','F133','F134','F135','F136'};
%Function_name_all={'F107','F108','F109','F110','F111','F112','F113','F114','F115','F116','F117','F118','F119','F120','F121','F122','F123','F124','F125','F126','F127','F128','F129','F130','F131','F132','F133','F134','F135','F136'};
%   Function_name_all = {'F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12','F13','F14','F15','F16','F17','F18','F19','F20','F21','F22','F23'};
% Function_name_all={'F24','F25','F26','F27','F28','F29','F30','F31','F32','F33','F34','F35','F36','F37','F38','F39','F40','F41','F42','F43','F44','F45','F46','F47','F48','F49','F50','F51','F52','F53'};
%  Function_name_all={'F110','F130','F131','F132','F133','F134','F135','F136'};
% Function_name_all={'F107'};
% CEC 2021
% Function_name_all={'F107','F34','F113','F123','F40','F122','F44','F128','F130','F131'};

for funcNum=1:size(Function_name_all,2)
%      dim = 30;
    Function_name=Function_name_all{funcNum};
    [lb,ub,dim,fhd]=Get_Functions(Function_name,dim);
    disp(['----------------',Function_name,'--------------------']);
    Function_name=['F',num2str(funcNum)];
%% =================uncomment for 1-23 function==========   
% for funcNum=107:136
%     dim = 10;
%     Function_name=['F',num2str(funcNum)]; % Name of the test function that can be from F1 to F23
%     [lb,ub,dim,fhd]=Get_Functions(Function_name,dim);
%     display(['----------------',Function_name,'--------------------']);
%% ======================================================  
    % benchmark function
    cg_curves=zeros(algrithmNum,Flod,NumofRecord);
%     
    parfor cflod=1:Flod
%     for cflod=1:Flod
        display(['flod',num2str(cflod)]);
        for cnum=1:algrithmNum
            alg_fhd=str2func(algorithmName{cnum});
            disp('fhd');
            disp(fhd);
            [~,cg_curve]=alg_fhd(SearchAgents_no,MaxFEs,lb,ub,dim,fhd);
            cg_curves(cnum,cflod,:)=MySampling(cg_curve,NumofRecord);
        end
    end
    
    %% write data to excel sheet
     algName_labels=cell(algrithmNum*Flod,1);
    all_curves=zeros(algrithmNum*Flod,NumofRecord);
    folds_labels=repmat(int32(1:Flod)',[algrithmNum,1]);
    for it=1:algrithmNum
        algName_labels((it-1)*Flod+1:(it-1)*Flod+Flod)=algorithmName(it);
        all_curves((it-1)*Flod+1:(it-1)*Flod+Flod,:)=cg_curves(it,:,:);
    end
    writecell(algName_labels, xlsfilename, 'Sheet', Function_name, 'Range', 'A1');
    writematrix(folds_labels, xlsfilename, 'Sheet', Function_name, 'Range', 'B1');
    writematrix(all_curves, xlsfilename, 'Sheet', Function_name, 'Range', 'C1');
    %write overall
    algName_labels2=algorithmName';
    statistic_values=zeros(algrithmNum,4);
    for it=1:algrithmNum
        statistic_values(it,:)=[max(cg_curves(it,:,end)),min(cg_curves(it,:,end)),mean(cg_curves(it,:,end)),std(cg_curves(it,:,end))];
    end
    funcNum_label=repmat({Function_name},algrithmNum,1);
    writecell(funcNum_label, xlsfilename, 'Sheet', 'overall', 'Range', ['A',num2str(startLineNum)]);
    writecell(algName_labels2, xlsfilename, 'Sheet', 'overall', 'Range', ['B',num2str(startLineNum)]);
    writematrix(statistic_values, xlsfilename, 'Sheet', 'overall', 'Range', ['C',num2str(startLineNum)]);
    startLineNum=startLineNum+algrithmNum;
    %% plot cg_curveline
    clf
    set(gcf,'Position',[0,100,1000,600])
    
    for it=1:algrithmNum
        yy(it,:)=mean(all_curves((it-1)*Flod+1:(it-1)*Flod+Flod,:));
    end
    xx=[1:NumofRecord]*(MaxFEs/NumofRecord);
    for it=1:algrithmNum
        semilogy(xx,yy(it,:),[linestyles{it} Markers{it}],'LineWidth', 1.5,'Color',MarkerEdgeColors(it,:));
        hold on;
    end
    hold off;
    set(gcf,'color','white')
    set(gca,'YScale','log','YLimMode','auto')
    title(Function_name)
    xlabel('FEs');
    ylabel('Best Score');
     algorithmName1=strrep(algorithmName,'_','\_');
    legend(algorithmName1,'location','best');
%     legend(algorithmName,'Best');
    legend('boxoff') 
    
    a=findobj(gcf); % get the handles associated with the current figure
    allaxes=findall(a,'Type','axes');
    % alllines=findall(a,'Type','line');
    alltext=findall(a,'Type','text');
    set(allaxes,'FontName','Times','LineWidth',1,'FontSize',14,'FontWeight','bold');
    % set(alllines,'Linewidth',1);
    set(alltext,'FontName','Times','FontSize',14,'FontWeight','bold')
    %
    set(gcf, 'PaperUnits', 'inches');
    % set(gcf, 'PaperUnits', 'centimeters');
    krare=3.5;
    % x_width=krare*1.618 ;
    x_width=krare*5/3 ;
    %  x_width=3*1;
    y_width=krare*4/3;
    set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
    % set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 4])
    set(gca, ...
        'Box'         , 'on'     , ...
        'TickDir'     , 'in'     , ...
        'TickLength'  , [.02 .02] , ...
        'XMinorTick'  , 'on'      , ...
        'YMinorTick'  , 'on'      , ...
        'YGrid'       , 'on'      , ...
        'XGrid'       , 'off'      , ...
        'XColor'      , [.3 .3 .3], ...
        'YColor'      , [.3 .3 .3], ...
        'LineWidth'   , 1         );
    axis tight
    grid on
    box on
    saveas(gcf,[filename,'-',Function_name,'-carve'],'fig')
    filename1= [filename,'-',Function_name,'-carve'];
    print(filename1,'-dtiff', '-r300'); %<-Save as PNG with 300 DPI
    print(filename1, '-dpdf', '-r600');
end

%     Orderhao(xlsfilename);
%     pValueToExcelKJ1(xlsfilename,Flod);
%     FridTest3( xlsfilename ,Flod)
%     FridTest4hao( xlsfilename ,Flod)
% Order(xlsfilename);
% pValueToExcelKJ(xlsfilename,Flod);
% FridTest3( xlsfilename ,Flod)
% FridTest4( xlsfilename ,Flod)
Orderhao(xlsfilename);
pValueToExcelhao(xlsfilename,Flod);
FridTest3( xlsfilename ,Flod)
FridTest4( xlsfilename ,Flod)

toc
close all
% end