{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import           Control.Concurrent.Async
import           Control.Monad
import           Database.MySQL.Base
import           Database.MySQL.Protocol
import           System.Environment
import           System.IO.Streams        (fold)
import  qualified Data.ByteString as B

main :: IO ()
main = do
    args <- getArgs
    case args of [threadNum] -> go (read threadNum)
                 _ -> putStrLn "No thread number provided."

go :: Int -> IO ()
go n = void . flip mapConcurrently [1..n] $ \ _ -> do
    c <- connect defaultConnectInfo { ciUser = "testMySQLHaskell"
                                    , ciDatabase = "testMySQLHaskell"
                                    }


    (fs, is) <- query_ c "SELECT * FROM employees"
    (rowCount :: Int) <- fold (\s _ -> s+1) 0 is
    forM_ fs $ \ f -> B.putStr (columnName f) >> B.putStr ", "

    putStr "total row count: "
    print rowCount






