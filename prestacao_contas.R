# Automatização da obtenção dos dados do repositório do TSE

temp <- tempfile()
download.file("http://agencia.tse.jus.br/estatistica/sead/odsele/prestacao_contas/cnpj_campanha_2016.zip"
              ,temp)
data <- read.csv(unz("prestacao_contas.zip", "despesas_candidatos_2016_SC.txt"))
unlink(temp)
unzip("")
rec_cand <- read.csv("receitas_candidatos_2016_SC.txt", fileEncoding = "latin1", sep = ";", 
                     colClasses = c(rep("character", 35)))
rec_cand$Valor.receita <- as.numeric(gsub("[,]", ".", rec_cand$Valor.receita))
