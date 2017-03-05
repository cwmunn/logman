{-# LANGUAGE OverloadedStrings, TemplateHaskell #-}
module LogEntry
      ( LogEntry(..)
      , LogData
      ) where

import Data.Aeson.TH
import Data.ByteString.Lazy
import Data.Text

type LogData = (LogEntry, ByteString)

data LogEntry = LogEntry 
    { name          :: Text
    , hostname      :: Text
    , pid           :: Int
    , from          :: Text
    , level         :: Int
    , time          :: Text
    , msg           :: Text 
    , v             :: Int
    , sessionId     :: Maybe Text
    , username      :: Maybe Text
    , requestId     :: Maybe Text
    , cookie        :: Maybe Text
    , url           :: Maybe Text
    , method        :: Maybe Text
    , statusCode    :: Maybe Int
    , durationInMs  :: Maybe Int
    , objectCount   :: Maybe Int
    } deriving (Show, Eq)

$(deriveJSON defaultOptions ''LogEntry)