module LogFile
      (loadFile
      ) where

import Prelude hiding (readFile, lines)
import Data.Aeson
import Data.ByteString.Lazy
import Data.ByteString.Lazy.Char8 (lines)

import LogEntry

readLogFile :: FilePath -> IO ByteString
readLogFile fileName = readFile fileName

parseLine :: ByteString -> Maybe LogEntry
parseLine l = decode l

parseLines :: [ByteString] -> [LogData]
parseLines ls = go ls []
  where
    go []     rs = rs
    go (l:ls) rs = case parseLine l of
                    Just r  -> go ls ((r,l):rs)
                    Nothing -> go ls rs

loadFile :: FilePath -> IO [LogData]
loadFile fileName = do
  log <- readLogFile fileName
  return $ parseLines $ lines log