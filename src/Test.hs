{-# LANGUAGE OverloadedStrings #-}

module Test where

import Prelude hiding (replace)
import Data.Aeson
import Data.Time.Clock
import Data.Text
import LogEntry

testEntry :: LogEntry
testEntry = LogEntry 
    { name          = "name"
    , hostname      = "hostname"
    , pid           = 123
    , from          = "from"
    , level         = 123
    , time          = "time"
    , msg           = "msg"
    , v             = 0
    , sessionId     = Just "sessionId"
    , username      = Just "username"
    , requestId     = Nothing
    , cookie        = Nothing
    , url           = Nothing
    , method        = Nothing
    , statusCode    = Nothing
    , durationInMs  = Nothing
    , objectCount   = Nothing
  }

test :: Result LogEntry
test = fromJSON (toJSON testEntry)

timeTest :: UTCTime
timeTest = read "2011-11-19 18:28:52.607875Z"

timeTest2 :: UTCTime
timeTest2 = read "2011-11-19 18:28:54.607875Z"

timeTest3 :: Text -> UTCTime
timeTest3 t = read $ unpack t

replaceTest :: Text
replaceTest = replace "T" " " "2017-03-03T22:08:35.396Z"
