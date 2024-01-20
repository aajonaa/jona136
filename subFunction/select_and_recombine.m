function [next_par par_best]=select_and_recombine(par,par_best,n)
    F=0.5;          %��������
    CR=0.8;         %������
    next_par=par;   %����Ⱥ
    for i=1:n
        
        while 1         %��ԭ��Ⱥ����ѡ����������ͬ�ĸ�����н������
            r1=floor(1+20*rand());
            r2=floor(1+20*rand());
            r3=floor(1+20*rand());
            if i~=r1 && i~=r2 && i~=r3 &&...
               r1~=r2 && r1~=r3 && r2~=r3
                break;
            end
        end
                     
        if rand()<CR    %�����ʣ����Զ�ÿһ�������ֱ����ã�������Ҫ��һ�����
            next_par(i).x=par(r1).x+F*(par(r2).x-par(r3).x);    %�������׼��
            next_par(i).y=par(r1).y+F*(par(r2).y-par(r3).y);              
        end
        
        %��������������Ӧ��
        next_par(i).fit=compute_fit(next_par(i));
        %����¸���û�б���ǰ������Ӧ�ȸߣ��¸��廹ԭΪ�ɸ���
        if par(i).fit>next_par(i).fit
            next_par(i)=par(i);
        end
        %����������Ӧ�ȸ�����Ⱥ�����Ӧ���壬�������Ⱥ��Ӧ����߸���
        if next_par(i).fit>par_best.fit
            par_best=next_par(i);
        end
    end    
end

function re=compute_fit(par)
    x=par.x;
    y=par.y;
    sigma=50;
    if x<-100 || x>100 || y<-100 || y>100
        re=0;        %������Χ��Ӧ��Ϊ0
    else            %������Ӧ�Ȱ�Ŀ�꺯�����
        re=(1/(2*pi*sigma^2))*exp(-(x.^2+y.^2)/(2*sigma^2)); 
    end
end