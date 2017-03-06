module LogFile
      ( readLogFile
      , readLogFromStdin
      ) where

import Prelude hiding             (readFile, lines, getContents)
import Data.Aeson
import Data.ByteString.Lazy
import Data.ByteString.Lazy.Char8 (lines)

import LogEntry

parseLine :: ByteString -> Maybe LogEntry
parseLine l = decode l

parseLines :: [ByteString] -> [LogData]
parseLines ls = go ls []
  where
    go []     rs = rs
    go (l:ls) rs = case parseLine l of
                    Just r  -> go ls (rs ++ [(r,l)])
                    Nothing -> go ls rs

readLogFile :: FilePath -> IO [LogData]
readLogFile fileName = do
  log <- readFile fileName
  return $ parseLines $ lines log

readLogFromStdin :: IO [LogData]
readLogFromStdin = do
  log <- getContents
  return $ parseLines $ lines log
