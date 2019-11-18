module Tests
where
import Main
import Test.HUnit
import DataTypes
import ParserTest


main = do
   
   testFilterYear 

--testFilterYear :: ([Transacao] -> Assertion) -> IO b0
testFilterYear = 
   TestCase (do db <- getTransactionsTest 
                assertEqual "Filtra o ano" ([db !! 0 ] ++ [db !! 1] ++ [db !! 2]) (filterByYear  db  2017))