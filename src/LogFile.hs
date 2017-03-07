module LogFile
      ( readLogFile
      , readLogFromStdin
      ) where

import Prelude hiding             (readFile, lines, getContents)
import Data.Aeson
import Data.ByteString.Lazy
import Data.ByteString.Lazy.Char8 (lines)

import LogEntry

parseLine :: ByteString -> [LogData]
parseLine l = case decode l of
  Nothing    -> []
  Just entry -> [(entry, l)]

parseLines :: [ByteString] -> [LogData]
parseLines []     = []
parseLines (l:ls) = (parseLine l) ++ (parseLines ls)

readLogFile :: FilePath -> IO [LogData]
readLogFile fileName = do
  log <- readFile fileName
  return $ parseLines $ lines log

readLogFromStdin :: IO [LogData]
readLogFromStdin = do
  contents <- getContents
  return $ parseLines . lines $ contents
