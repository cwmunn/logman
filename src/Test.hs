{-# LANGUAGE OverloadedStrings #-}

module Test where

import Data.Aeson

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
