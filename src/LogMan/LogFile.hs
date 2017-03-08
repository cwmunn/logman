{-# LANGUAGE OverloadedStrings #-}
module LogMan.LogFile
      ( readLogEntries
      ) where

import Prelude hiding             (readFile, lines, getContents)
import Data.Aeson
import Data.ByteString.Lazy       (ByteString, readFile, getContents)
import Data.ByteString.Lazy.Char8 (lines, unpack)
import Data.Monoid ((<>))

import LogMan.LogEntry hiding     (error)

parseLine :: ByteString -> [LogData]
parseLine l = case eitherDecode l of
  Left  err   -> error $ err <> " in log entry:\n" <> (unpack l)
  Right entry -> [(entry, l)]

parseLines :: [ByteString] -> [LogData]
parseLines []     = []
parseLines (l:ls) = (parseLine  l) ++ (parseLines ls)

readLogFile :: FilePath -> IO [LogData]
readLogFile fileName = do
  log <- readFile fileName
  return $ parseLines $ lines log

readLogFromStdin :: IO [LogData]
readLogFromStdin = do
  contents <- getContents
  return $ parseLines . lines $ contents

readLogEntries :: [String] -> IO [LogData]
readLogEntries []    = readLogFromStdin
readLogEntries (f:_) = readLogFile f
