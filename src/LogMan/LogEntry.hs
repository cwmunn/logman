{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}
module LogMan.LogEntry
      ( LogEntry(..)
      , LogData
      ) where

import Data.Char (toLower)
import qualified Data.HashMap.Strict as HM
import GHC.Generics
import Data.Aeson
import Data.Aeson.TH
import qualified Data.ByteString.Lazy as LBS
import qualified Data.Text as T
import Data.Text.Lazy hiding (drop, toLower, map)

type LogData = (LogEntry, LBS.ByteString)

data LogEntry = LogEntry 
    { logFrom          :: Maybe Text
    , logTime          :: Text
    , logMsg           :: Text 
    , logSessionId     :: Maybe Text
    , logUsername      :: Maybe Text
    , logStatusCode    :: Maybe Int
    , logDurationInMs  :: Maybe Int
    } deriving (Show, Eq, Generic)

instance FromJSON LogEntry where
  parseJSON = genericParseJSON opts . jsonLower
    where
      opts = defaultOptions { fieldLabelModifier = map toLower . drop 3 }

jsonLower :: Value -> Value
jsonLower (Object o) = Object . HM.fromList . map lowerPair . HM.toList $ o
  where lowerPair (key, val) = (T.toLower key, val)
jsonLower x = x
