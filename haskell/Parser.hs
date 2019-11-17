module Parser
(
    getJSON,
    getTransations
) where

import qualified Data.ByteString.Lazy as B  
import Data.Aeson
import Data.Maybe
import DataTypes

jsonFile :: FilePath
jsonFile = "data/dados.json"

getJSON :: IO B.ByteString
getJSON = B.readFile jsonFile

getTransations :: IO [Transacao]
getTransations = do
    transations <- (decode <$> getJSON) :: IO (Maybe [Transacao])
    return (fromJust transations)