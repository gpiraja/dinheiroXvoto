# Automatização da obtenção dos dados do repositório do TSE
## Baixando e extraindo dados do TSE
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
        assign(i, read.csv(fpath, sep=";", fileEncoding = "latin1"))}


