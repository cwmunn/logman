{-# LANGUAGE OverloadedStrings, FlexibleContexts #-}
module LogMan.Filters
      (applyFilters
      ) where

import Control.Monad.State
import Data.ByteString.Lazy       (ByteString)
import Data.Text.Lazy             (Text, replace, unpack)
import Data.Time.Clock

import LogMan.LogEntry
import LogMan.Options

compareSessionId :: LogEntry -> Text -> Bool
compareSessionId e s = 
  case sessionId e of
    Just s2 -> s2 == s
    Nothing -> False

compareUsername :: LogEntry -> Text -> Bool
compareUsername e u = 
  case username e of
    Just u2 -> u2 == u
    Nothing -> False

convertTime :: Text -> UTCTime
convertTime t = read $ unpack $ replace "T" " " t

isBeforeTime :: LogEntry -> UTCTime -> Bool
isBeforeTime e endTime = convertTime (time e) < endTime

isAfterTime :: LogEntry -> UTCTime -> Bool
isAfterTime e starTime = convertTime (time e)  > starTime

startTimeFilter :: (MonadState Options m) => [LogData] -> m [LogData]
startTimeFilter es = do
  o <- get
  case optStartTime o of
    Nothing        -> return es
    Just startTime -> return $ filter (\(e, r) -> isAfterTime e startTime) es

endTimeFilter :: (MonadState Options m) => [LogData] -> m [LogData]
endTimeFilter es = do
  o <- get
  case optEndTime o of
    Nothing      -> return es
    Just endTime -> return $ filter (\(e, r) -> isBeforeTime e endTime) es

usernameFilter :: (MonadState Options m) => [LogData] -> m [LogData]
usernameFilter es = do
  o <- get
  case optUsername o of
    Nothing -> return es
    Just u  -> return $ filter (\(e, r) -> compareUsername e u) es

sessionFilter :: (MonadState Options m) => [LogData] -> m [LogData]
sessionFilter es = do
  o <- get
  case optSessionId o of
    Nothing  -> return es
    Just sid -> return $ filter (\(e, r) -> compareSessionId e sid) es

applyFilters :: (MonadState Options m) => [LogData] -> m [LogData]
applyFilters es = sessionFilter es >>= usernameFilter >>= startTimeFilter >>= endTimeFilter
