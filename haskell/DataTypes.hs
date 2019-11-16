{-# LANGUAGE DeriveGeneric #-}
module DataTypes(
   Transacao(..),
   GregorianCalendar(..),
   TipoTransacao(..)
   )
   where
   
   import Data.Aeson
   import GHC.Generics
   
   data Transacao = 
   Transacao{
      date :: GregorianCalendar,
      valor :: Double,
      textoIdentificador :: String,
      descricao :: String,
      numeroDOC :: String,
      tipos :: [TipoTransacao], -- Na documentacao,fala em linkedlist - implementar ela no caso?
   } deriving (Generic, Show)
   
   data GregorianCalendar =
   GregorianCalendar {
      year :: Int,
      month :: Int,
      dayOfMonth :: Int
   } deriving (Generic, Show)
   
   data TipoTransacao = 
      SALDO_CORRENTE |
      VALOR_APLICACAO |
      RECEITA_OPERACIONAL |
      TAXA_CONDOMINIO |
      TAXA_EXTRA |
      TAXA_SALAO_FESTA |
      MULTAS_JUROS |
      TAXA_AGUA |
      RECUPERACAO_ATIVOS |
      MULTA_JURO_CORRECAO_COBRANCA |
      OUTRAS_RECEITAS |
      DESPESAS_PESSOAL |
      TERCEIRIZACAO_FUNCIONARIOS |
      VIGILANCIA |
      SALARIO_FUNCIONARIOS_ORGANICOS |
      ADIANTAMENTO_SALARIAL_FUNCIONARIOS_ORGANICOS |
      FERIAS |
      INSS |
      FGTS |
      PIS  |
      ISS  |
      BENEFICIO_SOCIAL |
      OUTRAS_DESPESAS_PESSOAL |
      DESPESAS_ADMINISTRATIVAS |
      ENERGISA |
      CAGEPA |
      COMPRA |
      ADMINISTRACAO_CONDOMINIO |
      MANUTENCAO |
      ABASTECIMENTO |
      SERVICOS_TERCEIROS |
      IRPF |
      TARIFAS_BANCARIAS |
      OUTRAS_DESPESAS_ADMINISTRATIVAS |
      APLICACAO |
      OUTROS deriving (Eq, Enum)
   
   -- Declarado conforme documentacao do Aeson (https://artyom.me/aeson#records-and-json-generics)
   instance ToJSON Transacao
   instance FromJSON Transacao
   
   instance ToJSON GregorianCalendar
   instance FromJSON GregorianCalendar
   
   
   
