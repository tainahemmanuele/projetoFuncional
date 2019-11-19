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
   testIsCredit
   testIsBalance
   testIsCreditOrDebit
   testSumValues

--testFilterYear :: ([Transacao] -> Assertion) -> IO b0
testFilterYear = 
   TestCase (do db <- getTransactionsTest 
                assertEqual "Filtra o ano de 2017" ([db !! 0 ] ++ [db !! 1] ++ [db !! 2]) (filterByYear  db  2017)
                assertEqual "Filtra o ano de 2018 (Criado so para testes esses dados)" ([db !! 3] ++ [db !! 4]) (filterByYear  db  2018))

testIsCredit = 
   TestCase (do db <- getTransactionsTest 
                assertEqual "É credito #1?" False (isCredit (db !! 0))
                assertEqual "É credito #2?" True (isCredit (db !! 3)))

testIsDebit = 
   TestCase (do db <- getTransactionsTest 
                assertEqual "É debito #1?" False (isDebit (db !! 0))
                assertEqual "É debito #2?" True (isDebit (db !! 1))
                assertEqual "É debito #3?" False (isDebit (db !! 3)))

testIsBalance = 
   TestCase (do db <- getTransactionsTest 
                assertEqual "Balance #1?" True (isBalance (db !! 0))
                assertEqual "Balance #2?" False (isBalance (db !! 1))
                assertEqual "Balance #3?" False (isBalance (db !! 3)))

testIsCreditOrDebit = 
   TestCase (do db <- getTransactionsTest 
                assertEqual "É credito ou debito #1?" False (isCreditOrDebit  (db !! 0))
                assertEqual "É credito ou debito #2?" True (isCreditOrDebit  (db !! 1))
                assertEqual "É credito ou debito #3?" True (isCreditOrDebit  (db !! 3))
                assertEqual "É credito ou debito #4?" True (isCreditOrDebit  (db !! 5)))


testIsCreditOrDebitOrBalance = 
   TestCase (do db <- getTransactionsTest 
                assertEqual "É credito ou debito ou balanco #1?" True (isCreditOrDebitOrBalancet  (db !! 0))
                assertEqual "É credito ou debito ou balanco #2?" True (isCreditOrDebitOrBalance  (db !! 1))
                assertEqual "É credito ou ou balanco #3?" True (isCreditOrDebitOrBalance  (db !! 3))

testSumValues = 
   TestCase (do db <- getTransactionsTest 
                assertEqual "Soma dos valores" 81589.56 (sumValues db))


                