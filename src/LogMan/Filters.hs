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
import LogMan.Utils

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
    f       -> return $ filter (\(e, r) -> (username e) == f) es

sessionFilter :: (MonadState Options m) => [LogData] -> m [LogData]
sessionFilter es = do
  o <- get
  case optSessionId o of
    Nothing  -> return es
    f        -> return $ filter (\(e, r) -> (sessionId e) == f) es

applyFilters :: (MonadState Options m) => [LogData] -> m [LogData]
applyFilters es = sessionFilter es >>= usernameFilter >>= startTimeFilter >>= endTimeFilter
