module ParserTest
(
    getJSONTest,
    getTransactionsTest
) where

import qualified Data.ByteString.Lazy as B  
import Data.Aeson
import Data.Maybe
import DataTypes

jsonFileTest :: FilePath
jsonFileTest = "data/dadosTests.json"

getJSONTest :: IO B.ByteString
getJSONTest = B.readFile jsonFileTest

getTransactionsTest :: IO [Transacao]
getTransactionsTest = do
    transations <- (decode <$> getJSONTest) :: IO (Maybe [Transacao])
    return (fromJust transations)