# Eleições 2012
# Objetivo é verificar os reais financiadores dos candidatos da região da grande Florianópolis.
# A dificuldade inicial é rastrear os dados oriundos dos comitês de campanha e dos partidos.
# Pré processamento: Download dos dados do repositório do TSE, seleção dos arquivos e ajuste dos nomes de coluna.
# Caregar pacotes
library(dplyr)

# Carregar dados para o R.
desp_candidato_sc <- read.csv2 ("despesas_candidatos_2012_SC.txt", encoding = "latin1")
desp_partidos_br <- read.csv2 ("despesas_partidos_2012_brasil.txt", encoding = "latin1")
desp_comites_sc <- read.csv2("despesas_comites_2012_SC.txt", encoding = "latin1")
desp_partidos_sc <- read.csv2("despesas_partidos_2012_SC.txt", encoding = "latin1")
rec_partidos_sc <- read.csv2 ("receitas_partidos_2012_SC.txt", encoding = 'latin1')
rec_comites_sc <- read.csv2("receitas_comites_2012_SC.txt", encoding = 'latin1')
rec_candidatos_sc <- read.csv2("receitas_candidatos_2012_SC.txt", encoding = 'latin1')
rec_comites_br <- read.csv2("receitas_comites_2012_brasil.txt", encoding = 'latin1')

#lista_campos <- list(names(desp_candidato_sc), names(desp_partidos_br), names(desp_partidos_br2), names(desp_comites_sc), 
#                     names(desp_partidos_sc), names(rec_partidos_sc), names(rec_comites_sc), names(rec_candidatos_sc),
#                     names(rec_comites_br))


# Quais comites doaram para os candidatos de SC?
rec_candidatos_sc_simpl <- select(rec_candidatos_sc, CPF_candidato, CPF_CNPJ_doador, Valor_receita, Data_receita)
rec_candidatos_sc_simpl <- summarise(group_by(rec_candidatos_sc_simpl, CPF_candidato, CPF_CNPJ_doador), valor = sum(Valor_receita))

desp_partidos_br_simpl <- select(desp_partidos_br, Sigla_Partido, Municipio, CPF_CNPJ_fornecedor, Data_despesa, Valor_despesa)
desp_partidos_br_simpl <- summarise(group_by(desp_partidos_br_simpl, Municipio, Sigla_Partido, CPF_CNPJ_fornecedor), valor = sum(Valor_despesa))

mistura_cand_partido <- merge(rec_candidatos_sc_simpl, desp_partidos_br_simpl, by.x = "CPF_candidato", by.y = "CPF_CNPJ_fornecedor", all.x = T)

#ajuste dos formatos
#remove data - nome fornecedor 
# Despesas
desp_partidos_sc <- select(desp_partidos_sc, -Data, -Nome_fornecedor )
desp_comites_sc <- select(desp_comites_sc, -Data, -Nome_fornecedor )
desp_partidos_br2 <- select(desp_partidos_br2, -Data, -Nome_fornecedor )
desp_partidos_br <- select(desp_partidos_br, -Cod_Eleicao, -Nome_fornecedor)
desp_candidato_sc <- select(desp_candidato_sc, -Data, - Nome_fornecedor)
# Receitas
rec_candidatos_sc <- select(rec_candidatos_sc, -Nome_doador, -Data )
rec_partidos_sc <- select(rec_partidos_sc, -Data, -Nome_doador )
rec_comites_sc <- select(rec_comites_sc, -Data, -Nome_doador )
rec_comites_br <- select(rec_comites_br, -Cod_Eleicao, -Nome_doador )
# corrige formato dos campos
# desp_candidato_sc
desp_candidato_sc$Seq_Candidato <- as.character(desp_candidato_sc$Seq_Candidato)
desp_candidato_sc$Numero_UE <- as.character(desp_candidato_sc$Numero_UE)
desp_candidato_sc$CPF_candidato <- as.character(desp_candidato_sc$CPF_candidato)
desp_candidato_sc$CPF_CNPJ_fornecedor <- as.character(desp_candidato_sc$CPF_CNPJ_fornecedor)
desp_candidato_sc$Data_despesa <- as.Date(desp_candidato_sc$Data_despesa, "%d/%m/%y")
#desp_partidos_br

#desp_comites_sc
desp_comites_sc$Numero_UE <- as.character(desp_comites_sc$Numero_UE)
desp_comites_sc$CPF_CNPJ_fornecedor <- as.character(desp_comites_sc$CPF_CNPJ_fornecedor)
desp_comites_sc$Data_despesa <- as.Date(desp_comites_sc$Data_despesa, "%d/%m/%y")$




rec_candidatos_sc$CPF_candidato <- as.character(rec_candidatos_sc$CPF_candidato)
rec_candidatos_sc$Seq_Candidato <- as.character(rec_candidatos_sc$Seq_Candidato)
des

# Separa candidatos por cargo
desp_candidato_pref_sc <- filter(desp_candidato_sc, Cargo == "Prefeito")
desp_candidato_vereador_sc <- filter(desp_candidato_sc, Cargo == "Vereador")
rec_candidato_pref_sc <- filter(rec_candidatos_sc, Cargo == "Prefeito")
rec_candidato_vereador_sc <- filter(rec_candidatos_sc, Cargo == "Vereador")

teste_merge<- merge(desp_partidos_br, rec_comites_sc, by.x = "CPF_CNPJ_fornecedor", by.y = "CPF_CNPJ_doador")


rec_candidatos_sc$CPF_candidato <- as.character(rec_candidatos_sc$CPF_candidato)
rec_candidatos_sc$Seq_Candidato <- as.character(rec_candidatos_sc$Seq_Candidato)
rec_pref_florianopolis <- filter (rec_candidatos_sc, Municipio == "FLORIANÓPOLIS" & Cargo == "Prefeito")
rec_pref_florianopolis$
rec_vereador_florianopolis <- filter (rec_candidatos_sc, Municipio == "FLORIANÓPOLIS" & Cargo == "Vereador")
arrange(summarise(group_by(rec_pref_florianopolis, Nome_candidato, ), valor= sum(Valor_receita), valor = (sum(Valor_receita))), desc(valor))
arrange(summarise(group_by(rec_vereador_florianopolis, Nome_candidato), valor= sum(Valor_receita)), desc(valor))
