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

parseLines :: [ByteString] -> [LogEntry]
parseLines ls = go ls []
  where
    go []     rs = rs
    go (l:ls) rs = case parseLine l of
                    Just r  -> go ls (r:rs)
                    Nothing -> go ls rs

loadFile :: FilePath -> IO [LogEntry]
loadFile fileName = do
  log <- readLogFile fileName
  return $ parseLines $ lines log