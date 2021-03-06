# Automatização da obtenção dos dados do repositório do TSE
## Baixando e extraindo dados do TSE
### Carrega library
library(dplyr)
library(tidyr)


### Dados da prestacao de contas parcial
loc.url <- "http://agencia.tse.jus.br/estatistica/sead/odsele/prestacao_contas/prestacao_contas_parcial_2016.zip"
td <- tempdir()
tf <- tempfile(tmpdir=td, fileext=".zip")
download.file(loc.url, tf)
#### Relaciona o nome dos arquivos compactados
lista_nome <- unzip(tf, list=TRUE)$Name
#### Seleciona os arquivos relacionados ao Estado de SC
lista_sc <- grep("SC", lista_nome)

#### Descompacta arquivos de interesse
length(lista_sc)
unzip(tf, files=lista_nome[lista_sc], exdir=td, overwrite=TRUE)
for (i in lista_nome[lista_sc]) {
        fpath <- file.path(td, i)
        assign(i, read.csv(fpath, sep=";", fileEncoding = "latin1", colClasses = "character"))} # para leitura de todas as colunas como character
#### Transforma campos Valor.receita e Valor Despesa para número
despesas_candidatos_parcial_2016_SC.txt$Valor.despesa <- as.numeric(gsub("[,]",".",despesas_candidatos_parcial_2016_SC.txt$Valor.despesa))
despesas_partidos_parcial_2016_SC.txt$Valor.despesa <- as.numeric(gsub("[,]",".",despesas_partidos_parcial_2016_SC.txt$Valor.despesa))
receitas_candidatos_parcial_2016_SC.txt$Valor.receita <- as.numeric(gsub("[,]",".",receitas_candidatos_parcial_2016_SC.txt$Valor.receita))
receitas_partidos_parcial_2016_SC.txt$Valor.receita <- as.numeric(gsub("[,]",".",receitas_partidos_parcial_2016_SC.txt$Valor.receita))

#### Remove colunas inúteis
despesas_candidatos <- despesas_candidatos_parcial_2016_SC.txt[,c(4, 8, 9, 10, 11, 12, 13, 17, 19:25)]
receitas_candidatos <- receitas_candidatos_parcial_2016_SC.txt[, c(4,8, 9, 10,11, 12, 13, 17, 19, 20:35)]
despesas_partidos <- despesas_partidos_parcial_2016_SC.txt[,c(4,8, 9, 10, 13, 15, 17:21)]
receitas_partidos <- receitas_partidos_parcial_2016_SC.txt[, c(4,8,9,10,13, 15,17:25)]

#### Formata o campo data
despesas_candidatos$Data.da.despesa <- as.Date(substr(despesas_candidatos$Data.da.despesa, 1,10), "%d/%m/%Y")
receitas_candidatos$Data.da.receita <- as.Date(substr(receitas_candidatos$Data.da.receita, 1,10), "%d/%m/%Y")
# precisa ajuste de formato de data para dados dos partidos ## 
##### receita
receitas_partidos$Data.da.receita <- gsub("MAY", "05", receitas_partidos$Data.da.receita)
receitas_partidos$Data.da.receita <- gsub("JUN", "06", receitas_partidos$Data.da.receita)
receitas_partidos$Data.da.receita <- gsub("JUL", "07", receitas_partidos$Data.da.receita)
receitas_partidos$Data.da.receita <- gsub("AUG", "08", receitas_partidos$Data.da.receita)
receitas_partidos$Data.da.receita <- gsub("SEP", "09", receitas_partidos$Data.da.receita)
receitas_partidos$Data.da.receita <- as.Date(substr(receitas_partidos$Data.da.receita, 1,8), "%d-%m-%Y")
##### despesas
despesas_partidos$Data.da.despesa <- gsub("JAN", "01", despesas_partidos$Data.da.despesa)
despesas_partidos$Data.da.despesa <- gsub("FEB", "02", despesas_partidos$Data.da.despesa)
despesas_partidos$Data.da.despesa <- gsub("MAY", "05", despesas_partidos$Data.da.despesa)
despesas_partidos$Data.da.despesa <- gsub("JUN", "06", despesas_partidos$Data.da.despesa)
despesas_partidos$Data.da.despesa <- gsub("JUL", "07", despesas_partidos$Data.da.despesa)
despesas_partidos$Data.da.despesa <- gsub("AUG", "08", despesas_partidos$Data.da.despesa)
despesas_partidos$Data.da.despesa <- gsub("SEP", "09", despesas_partidos$Data.da.despesa)
despesas_partidos$Data.da.despesa <- as.Date(substr(despesas_partidos$Data.da.despesa, 1,8), "%d-%m-%Y")
### transformar em factor
head(despesas_partidos[ , c("Data.da.despesa", "Valor.despesa")])

### Ajuste de campos para para factor
col_factor <- names(select(receitas_partidos, -Data.da.receita, -Valor.receita))
for (i in col_factor) {receitas_partidos[,i ] <- as.factor(receitas_partidos[,i])}
  
col_factor <- names(select(receitas_candidatos, -Data.da.receita, -Valor.receita))
for (i in col_factor) {receitas_candidatos[,i ] <- as.factor(receitas_candidatos[,i])}

col_factor <- names(select(despesas_partidos, -Data.da.despesa, -Valor.despesa))
for (i in col_factor) {despesas_partidos[,i ] <- as.factor(despesas_partidos[,i])}

col_factor <- names(select(despesas_candidatos, -Data.da.despesa, -Valor.despesa))
for (i in col_factor) {despesas_candidatos[,i ] <- as.factor(despesas_candidatos[,i])}


## curiosidades
## Candidatos a prefeito e vereadores que mais receberam
rec_vereador_florianopolis <- filter (receitas_candidatos[,c(2,3,5,6,9,16) ], Nome.da.UE == "FLORIANÓPOLIS" & Cargo == "Vereador")
arrange(summarise(group_by(rec_vereador_florianopolis, Nome.candidato, Sigla..Partido), valor= sum(Valor.receita)), desc(valor))[1:20,]
rec_prefeito_florianopolis <- filter (receitas_candidatos[,c(2,3,5,6,9,16) ], Nome.da.UE == "FLORIANÓPOLIS" & Cargo == "Prefeito")
arrange(summarise(group_by(rec_prefeito_florianopolis, Nome.candidato), valor= sum(Valor.receita)), desc(valor))[1:20,]


## Maiores financiadores de cand. prefeitos 
arrange(summarise(group_by(rec_prefeito_florianopolis,  Nome.do.doador..Receita.Federal.), valor= sum(Valor.receita)), desc(valor))[1:20,]
arrange(summarise(group_by(rec_vereador_florianopolis,  Nome.do.doador..Receita.Federal.), valor= sum(Valor.receita)), desc(valor))[1:20,]

## cruzar informação entre doadores e candidatos
teste <-arrange(summarise(group_by(rec_prefeito_florianopolis,  Doador = Nome.do.doador..Receita.Federal.,
                                  Cand = Nome.candidato), 
                                  valor= sum(Valor.receita)),
                desc(valor))
matrix <- spread(teste, Doador, valor)
matrix[is.na(matrix)] <- 0 
heatmaply(matrix)