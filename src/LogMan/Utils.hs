{-# LANGUAGE OverloadedStrings #-}
module LogMan.Utils
      ( isBeforeTime
      , isAfterTime
      ) where

import Data.Text.Lazy             (Text, replace, unpack)
import Data.Time.Clock

import LogMan.LogEntry

convertTime :: Text -> UTCTime
convertTime t = read $ unpack $ replace "T" " " t

isBeforeTime :: LogEntry -> UTCTime -> Bool
isBeforeTime e endTime = convertTime (time e) < endTime

isAfterTime :: LogEntry -> UTCTime -> Bool
isAfterTime e starTime = convertTime (time e)  > starTime
