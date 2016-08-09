{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE NegativeLiterals #-}

module TextRowNew where

import Control.Applicative
import Database.MySQL.Base
import Database.MySQL.Protocol
import qualified System.IO.Streams as Stream
import Test.Tasty.HUnit
import Data.Time.Calendar (fromGregorian)
import Data.Time.LocalTime (LocalTime(..), TimeOfDay(..))

tests :: MySQLConn -> Assertion
tests c = do
    (f, is) <- query_ c "SELECT \
                            \__datetime   ,\
                            \__timestamp  ,\
                            \__time        \
                            \ FROM test57;"

    assertEqual "decode Field types" (columnType <$> f)
        [ MYSQL_TYPE_DATETIME
        , MYSQL_TYPE_TIMESTAMP
        , MYSQL_TYPE_TIME
        ]

    Just v <- Stream.read is
    assertEqual "decode NULL values" v
        [ MySQLNull
        , MySQLNull
        , MySQLNull
        ]

    Stream.skipToEof is

    execute_ c "UPDATE test57 SET \
                \__datetime   = '2016-08-08 17:25:59.12'                  ,\
                \__timestamp  = '2016-08-08 17:25:59.1234'                ,\
                \__time       = '-199:59:59.123456' WHERE __id=0;"

    (_, is) <- query_ c "SELECT * FROM test57;"
    Just v <- Stream.read is

    assertEqual "decode text protocol" v
        [ MySQLInt32 0
        , MySQLDateTime (LocalTime (fromGregorian 2016 08 08) (TimeOfDay 17 25 59.12))
        , MySQLTimeStamp (LocalTime (fromGregorian 2016 08 08) (TimeOfDay 17 25 59.1234))
        , MySQLTime 1 (TimeOfDay 199 59 59.123456)
        ]

    Stream.skipToEof is

    execute c "UPDATE test57 SET \
            \__datetime   = ?     ,\
            \__timestamp  = ?     ,\
            \__time       = ?  WHERE __id=0;"
                [ MySQLDateTime (LocalTime (fromGregorian 2016 08 08) (TimeOfDay 17 25 59.12))
                , MySQLTimeStamp (LocalTime (fromGregorian 2016 08 08) (TimeOfDay 17 25 59.1234))
                , MySQLTime 1 (TimeOfDay 199 59 59.123456)
                ]


    (_, is) <- query_ c "SELECT * FROM test57;"
    Just v <- Stream.read is

    assertEqual "roundtrip text protocol" v
        [ MySQLInt32 0
        , MySQLDateTime (LocalTime (fromGregorian 2016 08 08) (TimeOfDay 17 25 59.12))
        , MySQLTimeStamp (LocalTime (fromGregorian 2016 08 08) (TimeOfDay 17 25 59.1234))
        , MySQLTime 1 (TimeOfDay 199 59 59.123456)
        ]

    Stream.skipToEof is
