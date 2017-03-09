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

processEntries :: (MonadIO m, MonadState Options m) => [String] -> m ()
processEntries n = do
  es <- readLogEntries n
  applyFilters es >>= writeOutput

run :: [String] -> IO ()
run argv = do
  (options, n) <- parseOptions argv
  runStateT (processEntries n) options
  return ()
