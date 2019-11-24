module Tests
where
import Main
import Test.HUnit
import DataTypes
import ParserTest

-- Roda usando runTestTT nomedaFuncaoTeste
--Compila Tests.hs antes
-- OBS: Base de dados usada para o teste: dadosTests.json . Essa base é pequena, apenas para mostrar o funcionamento dos metodos
--Se quiser rodar todos é só rodar Tests.main

main = do
   runTestTT testFilterYear
   runTestTT testFilterByYearMonth
   runTestTT testIsCredit
   runTestTT testIsDebit
   runTestTT testIsBalance
   runTestTT testIsCreditOrDebit
   runTestTT testIsCreditOrDebitOrBalance
   runTestTT testSumValues
   runTestTT testSumSobra
   runTestTT testFinalBalanceInMonth
   runTestTT testSumCreditsByYearMonth
   runTestTT testSumDebitByYearMonth


--testFilterYear :: ([Transacao] -> Assertion) -> IO b0
testFilterYear = 
   TestCase (do db <- getTransactionsTest 
                assertEqual "Filtra o ano de 2017" ([db !! 0 ] ++ [db !! 1] ++ [db !! 2]) (filterByYear  db  2017)
                assertEqual "Filtra o ano de 2018 (Criado so para testes esses dados)" ([db !! 3] ++ [db !! 4]) (filterByYear  db  2018))

testFilterByYearMonth = 
   TestCase (do db <- getTransactionsTest 
                assertEqual "Filtra o ano de 2016 e o mes 2" ([db !! 5 ] ++ [db !! 6] ++ [db !! 7] ++ [db !! 8]) (filterByYearMonth  db  2016 2))

                
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
                assertEqual "É credito ou debito ou balanco #1?" True (isCreditOrDebitOrBalance  (db !! 0))
                assertEqual "É credito ou debito ou balanco #2?" True (isCreditOrDebitOrBalance  (db !! 1))
                assertEqual "É credito ou ou balanco #3?" True (isCreditOrDebitOrBalance  (db !! 3)))

testSumValues = 
   TestCase (do db <- getTransactionsTest 
                assertEqual "Soma dos valores" 81589.56000000001 (sumValues db))

testSumCreditsByYearMonth = 
   TestCase (do db <- getTransactionsTest 
                assertEqual "Calcula os creditos  do ano de 2016 e o mes 2" 1152.11 (sumCreditsByYearMonth  db  2016 2)
                assertEqual "Calcula os creditos  do ano de 2018 e o mes 2" 1152.11 (sumCreditsByYearMonth  db  2018 2)
                assertEqual "Calcula os creditos  do ano de 2017 e o mes 2" 0.0 (sumCreditsByYearMonth  db  2017 2))

testSumDebitByYearMonth = 
   TestCase (do db <- getTransactionsTest 
                assertEqual "Calcula os debitos  do ano de 2016 e o mes 2" (-45.06999999999999) (sumDebitByYearMonth  db  2016 2)
                assertEqual "Calcula os debitos  do ano de 2018 e o mes 2" (-50.0) (sumDebitByYearMonth  db  2018 2))

testSumSobra = 
   TestCase (do db <- getTransactionsTest 
                assertEqual "Calcula a sobra(receitas - despesas)  do ano de 2018 e o mes 2" 1102.11 (sumSobra  db  2018 2))

testFinalBalanceInMonth = 
   TestCase (do db <- getTransactionsTest 
                assertEqual "Calcula o saldo final  do ano de 2016 e o mes 2" 1107.0399999999997 (finalBalanceInMonth  db  2016 2)
                assertEqual "Calcula o saldo final  do ano de 2018 e o mes 2" 1102.11 (finalBalanceInMonth  db  2018 2))