{-# LANGUAGE FlexibleContexts #-}
module LogMan.Processor
    ( run
    ) where

import Control.Monad.State

import LogMan.Filters
import LogMan.LogEntry
import LogMan.LogFile
import LogMan.Options
import LogMan.Output

processFile :: (MonadIO m, MonadState Options m) => [LogData] -> m ()
processFile es = applyFilters es >>= writeOutput

readLogEntries :: [String] -> IO [LogData]
readLogEntries []    = readLogFromStdin
readLogEntries (f:_) = readLogFile f

run :: [String] -> IO ()
run argv = do
  (options, n) <- parseOptions argv
  entries      <- readLogEntries n
  runStateT (processFile entries) options
  return ()
