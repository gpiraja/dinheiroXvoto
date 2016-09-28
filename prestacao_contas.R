# Automatização da obtenção dos dados do repositório do TSE
## Baixando e extraindo dados do TSE
### Carrega library
library(dplyr)

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
despesas_partidos <- despesas_partidos_parcial_2016_SC.txt[,c(4,8, 9, 10, 13, 15, 17:21)]
receitas_candidatos <- receitas_candidatos_parcial_2016_SC.txt[, c(4,8, 9, 10,11, 12, 13, 17, 19, 20:35)]
receitas_partidos <- receitas_partidos_parcial_2016_SC.txt[, c(4,8,9,10,13, 15,17:25)]

#### Formata o campo data


