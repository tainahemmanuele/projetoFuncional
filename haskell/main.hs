module Main where
import Parser
import DataTypes
import Control.Monad
import Data.Time.Clock
import Data.Time.Calendar


main = do
  db <- getTransactions
  putStrLn "DB carregado."
  putStrLn "Fim."

--Pra usar no GHCI primeiro chame:
--	db <- getTransactions
--	depois pode chamar normalmente com:
--  yearEquals db 2017
--  Transacao (data valor textoIdentificador descricao numeroDoc tipos)


-- Date
getYear (GregorianCalendar y _ _ ) = y
getMonth (GregorianCalendar _ m _ ) = m
getDay (GregorianCalendar _ _ d) = d
monthDaysList y m = [1..gregorianMonthLength y (m+1)]

-- Info
getValor (Transacao _ v _ _ _ _) = v
getDate (Transacao d _ _ _ _ _) = d
getType (Transacao _ _ _ _ _ t) = t

--Util

yearEquals y (Transacao c _ _ _ _ _) = y == getYear c
yearMonthEquals y m (Transacao c _ _ _ _ _) = y == getYear c && m == getMonth c
yearMonthDayEquals y m d (Transacao c _ _ _ _ _) = y == getYear c && m == getMonth c && getDay c == d

isCredit (Transacao _ v _ _ _ t) = (not (elem SALDO_CORRENTE t)) && (not (elem VALOR_APLICACAO t)) && (not (elem APLICACAO t))  && (v > 0)
isDebit (Transacao _ v _ _ _ t) = (not (elem SALDO_CORRENTE t)) && (not (elem VALOR_APLICACAO t)) && (not (elem APLICACAO t)) && (v < 0)
isBalance (Transacao _ v _ _ _ t) = (elem SALDO_CORRENTE t)
isCreditOrDebit (Transacao _ v _ _ _ t) = (not (elem SALDO_CORRENTE t)) && (not (elem VALOR_APLICACAO t)) && (not (elem APLICACAO t)) 
isCreditOrDebitOrBalance (Transacao _ v _ _ _ t) = (not (elem VALOR_APLICACAO t)) && (not (elem APLICACAO t)) 

sumValues [] = 0
sumValues (t:ts) = getValor t + sumValues ts

--Filtra as transações
filterTransactions db = filter (isCreditOrDebitOrBalance) db

--Filtrar transações por ano.
filterByYear db y = filter (yearEquals y) db

--Filtrar transações por ano e mês.
filterByYearMonth db y m = filter (yearMonthEquals y m) db

--Filtrar transações por ano, mês e dia.
filterByYearMonthDay db y m d = filter (yearMonthDayEquals y m d) db

--Calcular o valor das receitas (créditos) em um determinado mês e ano.
sumCreditsByYearMonth db y m = sumValues (filter (isCredit) (filterByYearMonth db y m))

--Calcular o valor das despesas (débitos) em um determinado mês e ano.
sumDebitByYearMonth db y m = sumValues (filter (isDebit) (filterByYearMonth db y m))

--Calcular a sobra (receitas - despesas) de determinado mês e ano
sumSobra db y m = (sumCreditsByYearMonth db y m) + (sumDebitByYearMonth db y m) 

--Calcular o saldo final em um determinado ano e mês
finalBalanceInMonth db y m = sumValues (filterTransactions (filterByYearMonth db y m))

--Calcular o saldo máximo atingido em determinado ano e mês
getSaldoMax [] _ _ = 0
getSaldoMax db y m = maximum (getSaldos (tail ts) (getValor (balance) ))
 where 
 ts = filter (isCreditOrDebit) (filterByYearMonth db y m)
 balance = head (filter (isBalance) (filterTransactions (filterByYearMonth db y m)))

getSaldos [] _ = []
getSaldos (t:ts) b = [b] ++ getSaldos ts ((getValor t)+b)

--Calcular o saldo mínimo atingido em determinado ano e mês
getSaldoMin [] _ _ = 0
getSaldoMin db y m = minimum (getSaldos (tail ts) (getValor (balance) ))
 where 
 ts = filter (isCreditOrDebit) (filterByYearMonth db y m)
 balance = head (filter (isBalance) (filterTransactions (filterByYearMonth db y m)))
 
--Calcular a média das receitas em determinado ano
meanCreditYear db y = (sumValues filtered) / (fromIntegral (length filtered))
 where filtered = (filter (isCredit) (filterByYear db y))

--Calcular a média das despesas em determinado ano
meanDebitYear db y = (sumValues filtered) / (fromIntegral (length filtered))
 where filtered = (filter (isDebit) (filterByYear db y))

--Calcular a média das sobras em determinado ano
meanSobraYear db y = (sumValues filtered) / (fromIntegral (length filtered))
 where filtered = (filter (isCreditOrDebit) (filterByYear db y))

--Retornar o fluxo de caixa de determinado mês/ano. O fluxo de caixa nada mais é do que uma lista contendo pares (dia,saldoFinalDoDia).
cashFlow db y m = cashFlow' ndb ds y m
 where 
 ds = monthDaysList (fromIntegral y) m
 ndb = filterTransactions (filterByYearMonth db y m)

cashFlow' _ [] y m = []
cashFlow' db (d:ds) y m = [ (show y ++ "/" ++ show m ++ "/" ++ show d , sumValues [t | t <- db, (getDay (getDate t)) <= d]) ] ++ cashFlow' db ds y m 
