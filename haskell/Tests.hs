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
                assertEqual "Filtra o ano de 2017" ([db !! 0 ] ++ [db !! 1] ++ [db !! 2]) (filterByYear  db  2017)
                assertEqual "Filtra o ano de 2018 (Criado so para testes esses dados)" ([db !! 3] ++ [db !! 4]) (filterByYear  db  2018))