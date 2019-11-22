module Util
(
    exibeFluxoDeCaixa,
    exibeTabelaTransacoes,
    slice
) where

import DataTypes

-- Date
getYear (GregorianCalendar y _ _ ) = y
getMonth (GregorianCalendar _ m _ ) = m
getDay (GregorianCalendar _ _ d) = d

-- Info
getValor (Transacao _ v _ _ _ _) = v
getDate (Transacao d _ _ _ _ _) = d
getType (Transacao _ _ _ _ _ t) = t

exibeTabelaTransacoes :: [Transacao] -> IO ()
exibeTabelaTransacoes transacoes = do 
    putStrLn cabecalho
    printLinha
    exibeTransacoes transacoes

exibeTransacoes :: [Transacao] -> IO ()
exibeTransacoes [] = printLinha
exibeTransacoes (x:xs) = do 
    putStrLn $ formataTransaction x
    exibeTransacoes xs

cabecalho =
    fmt 10 "   DATA" ++ " | " ++
    fmt 20 "   IDENTIFICADOR" ++ " | " ++
    fmt 12 "   VALOR" ++ " | " ++
    fmt 30 "          DESCRICAO" ++ " | " ++
    fmt 12 " NUMERO_DOC" ++ " | " ++
    fmt 20 "       TIPOS"

printLinha = putStrLn $ replicate 160 '-'

formataTransaction :: Transacao -> String
formataTransaction (Transacao d v ti desc ndoc tipos) =
    fmt 10 ( formataData $ d) ++ " | " ++
    fmt 20 (ti) ++ " | " ++
    fmt' 12 ( show $ v) ++ " | " ++
    fmt 30 ( desc) ++ " | " ++
    fmt' 12 ( ndoc) ++ " | " ++
    ( show $ tipos)

formataData :: GregorianCalendar -> String
formataData g = show (dayOfMonth g)++ "/"++ show (month g) ++"/"++ show (year g)

slice :: Int -> Int -> [a] -> [a]
slice start stop xs = fst $ splitAt (stop - start) (snd $ splitAt start xs)

fmt :: Int -> String  -> String
fmt esp str  
    | length str > esp = slice 0 (esp - 3) str ++ "..."
    | otherwise = str ++ replicate (esp - length str) ' '

fmt' :: Int -> String  -> String
fmt' esp str  
    | length str > esp = slice 0 (esp - 3) str ++ "..."
    | otherwise = replicate (esp - length str) ' ' ++ str 


exibeFluxoDeCaixa [] = do
    printLinha
exibeFluxoDeCaixa (x:xs) = do
    putStrLn (show $ x)
    exibeFluxoDeCaixa xs