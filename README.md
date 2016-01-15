# CHUVA_DE_GRADE_OPERACIONAL
script em matlab para calculo de chuva de grade diaria e mensal por bacia
## PRE-REQUISITOS 

1 - QUE NO DIRETORIO /BLN  TENHA ARQUIVOS DE CONTORNO EM FORMATO BLN DAS BACIAS OU SUB-BACIAS.
2 - QUE OS ARQUIVOS /DADOS0P50  TENHAM O MESMO TAMANHO. SE HOUVER ALGUM ARQUIVO COM TAMAMNHO DIFERENTE, APAGUE-O. 
3 - PLANILHAS RESULTADOS.xlsx E CONTORNOS.xlsx NÃO SETEJA ABERTAS NA HORA DE EXECUÇÃO DO SCRIPT. 

## INCLUINDO UM NOVO CONTORNO DE BACIA AO SISTEMA 

APOS OBTER O ARQUIVO DE CONTORNO EM FORMATO BLN , COLOQUE-O NO DIRETORIO /BLN 
EXECUTE O SCRIPT contorno.m 
O RESULTADO SERÁ CONTORNOS.xlsx (ESSE ARQUIVO NÃO DEVE SER EDITADO).

## CONFIGURANDO O SCRIPT 

AS LINHAS A SEREM CONFIGURADAS SÃO AS SEGUINTES NO ARQUIVO inicio.m 

DATA_INICIAL=datenum(2014,1,1);
DATA_FINAL=datenum(2015,12,31);        
DATA_DOWNLOAD_INICIAL=datenum(2014,1,1);

Data inicial do processamento:

DATA_INICIAL=datenum( ANO INICIAL , MES INICIAL, DIA INICIAL )

Data final do processamento:

DATA_FINAL=datenum( ANO INICIAL , MES INICIAL, DIA INICIAL )

Data de download:

Pode ser que os dados a serem baixados sejam uma parte somente do conjunto de que se deseja pocessar.
Obviamente , a DATA_DOWNLAOD_INICIAL tem que fica entre DATA_INICIAL e DATA_FINAL.  

DATA_DOWNLAOD_INICIAL=datenum( ANO INICIAL , MES INICIAL, DIA INICIAL )


### RODANDO O SCRIPT 

PARA A ESUA EXECUÇÃO, RODE O inicio.m 
ELE FARÁ ALEITURA DO ARQUIVO CONTORNOS.xlsx E DOS ARQUIVOS DE CHUVA OBSERVADA EM /DADOS_0P50 
O ARQUIVO DE SAÍDA SERA O RESULTADOS.xlsx












