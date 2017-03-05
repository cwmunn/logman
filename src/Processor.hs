{-# LANGUAGE OverloadedStrings #-}

module Processor
    ( run
    ) where

import Prelude hiding (putStrLn)
import Data.ByteString.Lazy.Char8 (putStrLn)
import Data.Maybe (fromMaybe)
import Data.Text (Text)
import LogEntry
import LogFile
import Options

compareSessionId :: LogEntry -> Text -> Bool
compareSessionId e s = 
  case sessionId e of
    Just s2 -> s2 == s
    Nothing -> False

sessionFilter :: Options -> [LogData] -> [LogData]
sessionFilter o es = 
  case optSessionId o of
    Nothing  -> es
    Just sid -> filter (\(e, r) -> compareSessionId e sid) es

compareUsername :: LogEntry -> Text -> Bool
compareUsername e u = 
  case username e of
    Just u2 -> u2 == u
    Nothing -> False

usernameFilter :: Options -> [LogData] -> [LogData]
usernameFilter o es = 
  case optUsername o of
    Nothing -> es
    Just u  -> filter (\(e, r) -> compareUsername e u) es

writeOutput :: Options -> [LogData] -> IO ()
writeOutput _ d = go d
  where 
    go []         = return ()
    go ((_,e):es) = do 
        putStrLn e
        go es

processFile :: Options -> [LogData] -> IO ()
processFile o es = do
    let es'  = sessionFilter  o es 
    let es'' = usernameFilter o es'
    writeOutput o es''
    return ()

run :: [String] -> IO ()
run argv = do
  (options, n) <- parseOptions argv
  entries      <- loadFile (head n)
  processFile options entries