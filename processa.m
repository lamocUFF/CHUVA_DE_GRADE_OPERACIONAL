clear all

disp(strcat(datestr(now),' ABRINDO BANCO DE DADOS'));



%
% grava dados
%

% fid=fopen('CHUVA_MEIOGRAU.dat','wb');
% fwrite(fid,DADOS,'single');
% fclose(fid);
% 
% fid=fopen('CHUVA_MEIOGRAU.status','w');
% fprintf(fid,'%d %d %d\n',91,101,size(BRUTOS)+1);
% fprintf(fid,'%d %d\n',DATA_INICIAL,DATA_FINAL);
% fprintf(fid,'%s\n',datestr(now));
% fclose(fid);

TAMX=102;
TAMY=91;
NUMREG=size(BRUTOS)+1; 

%
% abre arquivo de dados
%
fid=fopen('CHUVA_MEIOGRAU.status','r');
A=fscanf(fid,'%d');
TAMY=A(1);
TAMX=A(2);
NUMREG=A(3);
DATA_INICIAL=A(5);
DATA_FINAL=A(6);
fclose(fid);
fid=fopen('CHUVA_MEIOGRAU.dat','rb');
B=fread(fid,TAMX*TAMY*NUMREG,'single');
DADOS=reshape(B,[TAMY TAMX NUMREG]);
fclose(fid);


%
% geometria da grade chuva ncep
%
[Y,X]=ndgrid(-89.75:0.50:89.75,0.25:0.5:360);
LON=X(110:200,560:660)-360;
LAT=Y(110:200,560:660);
%
% ABRE ARQUIVO CONTENDO BACIAS HIDROGRAFICAS CADASTRADAS
%   
disp(strcat(datestr(now),' ABRINDO ARQUIVOS DE BACIAS'));
[D,P]=xlsread('CONTORNOS.xlsx','PONTOS');
[anoref,~,~]=datevec(DATA_INICIAL);
[anofim,~,~]=datevec(DATA_FINAL);
[b,~]=size(P);
NUM_BACIAS=ceil((b+1)/2);

%
% PROCESSA MEDIA DIARIA
%
disp(strcat(datestr(now),' PROCESSANDO MEDIA DIARIA'));
MEDIA_DIARIA=zeros(NUM_BACIAS,ceil(DATA_FINAL-DATA_INICIAL));
SOMA_MENSAL=zeros(NUM_BACIAS,anofim-anoref,12);
CONTA_MENSAL=zeros(NUM_BACIAS,anofim-anoref,12);
MEDIA_MENSAL=zeros(NUM_BACIAS,anofim-anoref,12);

if ((DATA_FINAL-DATA_INICIAL) > NUMREG)
    DATA_FINAL_PROCESS=NUMREG;
else
    DATA_FINAL_PROCESS=(DATA_FINAL-DATA_INICIAL);
end 
 b=1;
for t=1:DATA_FINAL_PROCESS
        b=1;
        indice=t;
        [ano,mes,dia]=datevec(DATA_INICIAL+t);
        LABELDATA(indice)=DATA_INICIAL+t;
        LABELDATAMES(ano-anoref,mes)=DATA_INICIAL+t;
        
        for bacia=1:NUM_BACIAS
             SOMA=0;
             for i=1:D(b,1)
                  [l,c]=find((LON == D(b,i+1)) & (LAT == D(b+1,i+1)));
                  VALOR_CHUVA=DADOS(l,c,indice);
                  if (VALOR_CHUVA >=0 )
                    SOMA=SOMA+VALOR_CHUVA;
                  end
             end
             
             MEDIA_DIARIA(bacia,indice)=SOMA/D(b,1);
             SOMA_MENSAL(bacia,ano-anoref,mes)=SOMA_MENSAL(bacia,ano-anoref,mes)+SOMA/D(b,1);
             CONTA_MENSAL(bacia,ano-anoref,mes)=CONTA_MENSAL(bacia,ano-anoref,mes)+1;
             b=b+2;
         end
   
end

%
% MEDIA MENSAL FINAL 
%
disp(strcat(datestr(now),' PROCESSANDO MEDIA MENSAL'));

for t=DATA_INICIAL+1:DATA_FINAL-1
    
    [ano,mes,dia]=datevec(t);
   
    for bacia=1:NUM_BACIAS
     
        if (CONTA_MENSAL(bacia,ano-anoref,mes)> 0) 
            MEDIA_MENSAL(bacia,ano-anoref,mes)=SOMA_MENSAL(bacia,ano-anoref,mes)/CONTA_MENSAL(bacia,ano-anoref,mes);
        else
            MEDIA_MENSAL(bacia,ano-anoref,mes)=NaN;
        end
    end

end


%
%
% gravar planilha excell
%
%
% %
% % cria cabeçahos, coluna de datas etc..
% % para quando for gravar no excell 
disp(strcat(datestr(now),' GRAVANDO DADOS NO EXCEL '));
celula={'b2','c2','d2','e2','f2','g2','h2','i2','j2','k2','l2','m2','n2' ...
        'o2','p2','q2','r2','s2','t2','u2','v2','w2','x2','y2','z2','aa2' ...
        'ab2','ac2','ad2','ae2','af2','ag2','ah2','ai2','aj2','ak2','al2','am2','an2' ...
        'ao2','ap2','aq2','ar2','as2','at2','au2','av2','aw2','ax2','ay2','az2' };
xlswrite('RESULTADO.xlsx',unique(P)','MEDIA','a1');
xlswrite('RESULTADO.xlsx',unique(P)','MEDIAMES','a1');
xlswrite('RESULTADO.xlsx',unique(P)','SOMAMES','a1');
        
for i=1:size(MEDIA_DIARIA)
    xlswrite('RESULTADO.xlsx',MEDIA_DIARIA(i,:)','MEDIA',char(celula(i)));
    
    
    
    
end

for bacia=1:NUM_BACIAS
    a=squeeze(MEDIA_MENSAL(bacia,:,:));
    b=reshape(a',1,[]);
    xlswrite('RESULTADO.xlsx',b','MEDIAMES',char(celula(bacia)));
    
end


for bacia=1:NUM_BACIAS
    a=squeeze(SOMA_MENSAL(bacia,:,:));
    b=reshape(a',1,[]);
    xlswrite('RESULTADO.xlsx',b','SOMAMES',char(celula(bacia)));
    
end

a=datestr(LABELDATA,'dd/mm/yyyy');
b=cellstr(a);
xlswrite('RESULTADO.xlsx',b,'MEDIA','a2');
clear a b
a=datestr(LABELDATAMES','mm/yyyy');
b=cellstr(a);
xlswrite('RESULTADO.xlsx',b,'SOMAMES','a2');
xlswrite('RESULTADO.xlsx',b,'MEDIAMES','a2');
    
 









% 
% 
%        
% 
% 
%                
%                
% 
% 
% %
% % cria cabeçahos, coluna de datas etc..
% % para quando for gravar no excell 
% celula={'b2','c2','d2','e2','f2','g2','h2','i2','j2','k2','l2','m2','n2' ...
%         'o2','p2','q2','r2','s2','t2','u2','v2','w2','x2','y2','z2','aa2' ...
%         'ab2','ac2','ad2','ae2','af2','ag2','ah2','ai2','aj2','ak2','al2','am2','an2' ...
%         'ao2','ap2','aq2','ar2','as2','at2','au2','av2','aw2','ax2','ay2','az2' };
%   
% k=0;
% for t=DATA_INICIAL:DATA_FINAL
%     k=k+1;
%     [ano,mes,dia]=datevec(t);
%     datalabel{k}=strcat(num2str(ano),'/',num2str(mes),'/',num2str(dia)) ;
% end
% xlswrite('saida.xlsx',datalabel','DIARIO','a2');    
%  
% 
% % 
% % 
% % %
% % % processa
% % %
% % 
% 
% [anoi,~,~,~]=datevec(DATA_INICIAL);
% [anof,~,~,~]=datevec(DATA_FINAL);
% 
% SOMA_MENSAL=zeros(anof-anoi,18);
% CONTA_MENSAL=zeros(anof-anoi,18);
% SOMA_CLIMA=zeros(18);
% CONTA_CLIMA=zeros(18);
% CHUVA_MEDIA_DIARIA=zeros(ceil(DATA_FINAL-DATA_INICIAL));
% 
% 
% 
% 
% [~,~,lz]=size(DADOS);
% for loop=DATA_INICIAL+1:DATA_FINAL
%     [ano,mes,dia]=datevec(loop);
%     indice=loop-DATA_INICIAL;
%      
%     Z=reshape(DADOS(:,:,indice)',1,91*101)';
%     XX=reshape(LON(:,:)',1,91*101)'-360;
%     YY=reshape(LAT(:,:)',1,91*101)';
%     
%   
%     for bacia=1:size(CONTORNOS)
%         
%         N=dlmread(fullfile(DATABLN,CONTORNOS(bacia).name),',',2);
%         W=inpolygon(XX(:),YY(:),N(:,1),N(:,2));
%         [ly,lx]=size(W);
%         k=0;
%         SOMA=0;
%         for i=1:ly
%             if (W(i)==1 && Z(i)>0 )
%                 k=k+1;
%                 SOMA=SOMA+Z(i);
%             end
%         end
%        
%         if (SOMA > 0)
%             CHUVA_MEDIA_DIARIA(indice)=SOMA/k;
%             SOMA_MENSAL(loop-DATA_INICIAL,mes)=SOMA_MENSAL(loop-DATA_INICIAL,mes)+SOMA;
%             CONTA_MENSAL(loop-DATA_INICIAL,mes)=CONTA_MENSAL(loop-DATA_INICIAL,mes)+1;
%             SOMA_CLIMA(mes)=SOMA_CLIMA(mes)+SOMA;
%             CONTA_CLIMA(mes)=CONTA_CLIMA(mes)+1;
%             switch (mes)
%                 case {12,1,2,3}
%                      SOMA_MENSAL(loop-DATA_INICIAL,13)=SOMA_MENSAL(loop-DATA_INICIAL,13)+SOMA;
%                      CONTA_MENSAL(loop-DATA_INICIAL,13)=CONTA_MENSAL(loop-DATA_INICIAL,13)+1;
%                      SOMA_CLIMA(13)=SOMA_CLIMA(13)+SOMA;
%                      CONTA_CLIMA(13)=CONTA_CLIMA(13)+1;
%                 case {3,4,5,6}
%                       SOMA_MENSAL(loop-DATA_INICIAL,14)=SOMA_MENSAL(loop-DATA_INICIAL,14)+SOMA;
%                       CONTA_MENSAL(loop-DATA_INICIAL,14)=CONTA_MENSAL(loop-DATA_INICIAL,14)+1;
%                       SOMA_CLIMA(14)=SOMA_CLIMA(14)+SOMA;
%                       CONTA_CLIMA(14)=CONTA_CLIMA(14)+1;
%                 case {6,7,8,9}
%                       SOMA_MENSAL(loop-DATA_INICIAL,15)=SOMA_MENSAL(loop-DATA_INICIAL,15)+SOMA;
%                       CONTA_MENSAL(loop-DATA_INICIAL,15)=CONTA_MENSAL(loop-DATA_INICIAL,15)+1;
%                       SOMA_CLIMA(15)=SOMA_CLIMA(15)+SOMA;
%                       CONTA_CLIMA(15)=CONTA_CLIMA(15)+1;
%                 case {9,10,11,12}
%                       SOMA_MENSAL(loop-DATA_INICIAL,16)=SOMA_MENSAL(loop-DATA_INICIAL,16)+SOMA;
%                       CONTA_MENSAL(loop-DATA_INICIAL,16)=CONTA_MENSAL(loop-DATA_INICIAL,16)+1;
%                       SOMA_CLIMA(16)=SOMA_CLIMA(16)+SOMA;
%                       CONTA_CLIMA(16)=CONTA_CLIMA(16)+1;
%                 case {10,11,12,1,2,3}
%                       SOMA_MENSAL(loop-DATA_INICIAL,17)=SOMA_MENSAL(loop-DATA_INICIAL,17)+SOMA;
%                       CONTA_MENSAL(loop-DATA_INICIAL,17)=CONTA_MENSAL(loop-DATA_INICIAL,17)+1;
%                       SOMA_CLIMA(17)=SOMA_CLIMA(17)+SOMA;
%                       CONTA_CLIMA(17)=CONTA_CLIMA(17)+1;
%                 case {4,5,6,7,8,9}
%                       SOMA_MENSAL(loop-DATA_INICIAL,18)=SOMA_MENSAL(loop-DATA_INICIAL,18)+SOMA;
%                       CONTA_MENSAL(loop-DATA_INICIAL,18)=CONTA_MENSAL(loop-DATA_INICIAL,18)+1;
%                       SOMA_CLIMA(18)=SOMA_CLIMA(18)+SOMA;
%                       CONTA_CLIMA(18)=CONTA_CLIMA(18)+1;
%             end   
%             
%             
%             
%             
%             
%         end
%         
%          xlswrite('saida.xlsx',CHUVA_MEDIA_DIARIA,'DIARIO',char(celula(bacia)));
%      
%     end
% 
