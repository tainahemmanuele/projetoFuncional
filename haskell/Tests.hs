module Tests
where
import Main
import Test.HUnit
import DataTypes
import ParserTest

-- Roda usando runTestTT nomedaFuncaoTeste
--Compila Tests.hs antes

main = do
   testFilterYear 

--testFilterYear :: ([Transacao] -> Assertion) -> IO b0
testFilterYear = 
   TestCase (do db <- getTransactionsTest 
                assertEqual "Filtra o ano" ([db !! 0 ] ++ [db !! 1] ++ [db !! 2]) (filterByYear  db  2017))