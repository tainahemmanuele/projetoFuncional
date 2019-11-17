module Parser
(
    getJSON,
    getTransactions
) where

import qualified Data.ByteString.Lazy as B  
import Data.Aeson
import Data.Maybe
import DataTypes

jsonFile :: FilePath
jsonFile = "data/dadosRequisicoes.json"

getJSON :: IO B.ByteString
getJSON = B.readFile jsonFile

getTransactions :: IO [Transacao]
getTransactions = do
    transations <- (decode <$> getJSON) :: IO (Maybe [Transacao])
    return (fromJust transations)
