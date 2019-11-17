import Parser
import DataTypes
import Control.Monad

main = do
  db <- getTransactions
  putStrLn "DB carregado."
  putStrLn "Fim."

--Pra usar no GHCI primeiro chame:
--	db <- getTransactions
--	depois pode chamar normalmente com:
--  filterByYear db 2017


-- Date
getYear (GregorianCalendar y _ _ ) = y
getMonth (GregorianCalendar _ m _ ) = m
getDay (GregorianCalendar _ _ d) = d

getValor (Transacao _ v _ _ _ _) = v
getDate (Transacao d _ _ _ _ _) = d
getType (Transacao _ _ _ _ _ t) = t


--Filtrar transações por ano.
filterByYear y (Transacao c _ _ _ _ _) = y == getYear c
getTransactionsByYear db y = filter (filterByYear y) db

--Filtrar transações por ano e mês.
filterByYearMonth y m (Transacao c _ _ _ _ _) = y == getYear c && m == getMonth c
getTransactionsByYearMonth db y m = filter (filterByYearMonth y m) db

--Filtrar transações por ano, mês e dia.
filterByYearMonthDay y m d (Transacao c _ _ _ _ _) = y == getYear c && m == getMonth c && getDay c == d
getTransactionsByYearMonthDay db y m d = filter (filterByYearMonthDay y m d) db

--Calcular o valor das receitas (créditos) em um determinado mês e ano.

--Calcular o valor das despesas (débitos) em um determinado mês e ano.

--Calcular a sobra (receitas - despesas) de determinado mês e ano

--Calcular o saldo final em um determinado ano e mês

--Calcular o saldo máximo atingido em determinado ano e mês

--Calcular o saldo mínimo atingido em determinado ano e mês

--Calcular a média das receitas em determinado ano

--Calcular a média das despesas em determinado ano

--Calcular a média das sobras em determinado ano

--Retornar o fluxo de caixa de determinado mês/ano. O fluxo de caixa nada mais é do que uma lista contendo pares (dia,saldoFinalDoDia). 
