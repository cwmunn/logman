{-# LANGUAGE OverloadedStrings, FlexibleContexts #-}
module LogMan.LogFile
      ( readLogEntries
      ) where

import Prelude hiding             (readFile, lines, getContents)
import Control.Monad.State
import Data.Aeson hiding          (Options)
import Data.ByteString.Lazy       (ByteString, readFile, getContents)
import Data.ByteString.Lazy.Char8 (lines, unpack)
import Data.Monoid                ((<>))

import LogMan.LogEntry hiding     (error)
import LogMan.Options

parseLine :: Options -> ByteString -> [LogData]
parseLine o l = case eitherDecode l of
  Right entry -> [(entry, l)]
  Left  err   -> case optIgnoreParseErrors o of
                  False -> error $ err <> " in log entry:\n" <> (unpack l)
                  True  -> []
  
parseLines :: Options -> [ByteString] -> [LogData]
parseLines o []     = []
parseLines o (l:ls) = (parseLine o l) ++ (parseLines o ls) -- CM: TODO

readLogFile :: (MonadIO m, MonadState Options m) => FilePath -> m [LogData]
readLogFile fileName = do
  o <- get
  log <- liftIO $ readFile fileName
  return $ parseLines o $ lines log

readLogFromStdin :: (MonadIO m, MonadState Options m) => m [LogData]
readLogFromStdin = do
  o <- get
  contents <- liftIO $ getContents
  return $ parseLines o . lines $ contents

readLogEntries :: (MonadIO m, MonadState Options m) => [String] -> m [LogData]
readLogEntries []    = readLogFromStdin
readLogEntries (f:_) = readLogFile f
