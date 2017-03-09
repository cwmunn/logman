{-# LANGUAGE OverloadedStrings, FlexibleContexts #-}
module LogMan.Output
     ( writeOutput
     ) where

import Prelude hiding             (putStrLn, appendFile, concat, error)
import Control.Monad.State
import Data.ByteString.Lazy       (ByteString)
import Data.ByteString.Lazy.Char8 (putStrLn, appendFile)
import Data.Monoid ((<>))
import Data.Text.Lazy             (Text, concat, unpack)
import Data.Text.Lazy.Encoding    (encodeUtf8)

import LogMan.LogEntry
import LogMan.LogFile
import LogMan.Options

writeFullOutput :: (MonadIO m, MonadState Options m) => [LogData] -> m ()
writeFullOutput [] = return ()
writeFullOutput ((le,r):es) = do 
  output le r
  writeFullOutput es
 
writeMinimal :: (MonadIO m, MonadState Options m) => [LogData] -> m ()
writeMinimal [] = return ()
writeMinimal ((le,_):es) = do 
  output le $ encodeUtf8 $ concat $ (time le) : " " : (msg le) : []
  writeMinimal es

getFilename :: LogEntry -> FilePath
getFilename LogEntry { username  = Nothing } = "other.log"
getFilename LogEntry { sessionId = Nothing } = "other.log"
getFilename LogEntry { sessionId = Just s, username = Just u } = 
  unpack $ u <> "." <> s <> ".log"

output :: (MonadIO m, MonadState Options m) => LogEntry -> ByteString -> m ()
output le s = do
  o <- get
  if optSplitAll o then liftIO $ appendFile (getFilename le) s
  else case optOutputFile o of
    Nothing -> liftIO $ putStrLn s
    Just f  -> liftIO $ appendFile f s

writeOutput :: (MonadIO m, MonadState Options m) => [LogData] -> m ()
writeOutput es = do
  o <- get
  case optMessageOnly o of 
    True  -> writeMinimal    es
    False -> writeFullOutput es
