{-# LANGUAGE OverloadedStrings, FlexibleContexts #-}
module LogMan.Output
     ( writeOutput
     ) where

import Prelude hiding             (putStrLn, appendFile, concat, error)
import Control.Monad.State
import Data.ByteString.Lazy       (ByteString)
import Data.ByteString.Lazy.Char8 (putStrLn, appendFile, pack)
import Data.Monoid                ((<>))
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
  output le $ encodeUtf8 $ concat $ (logTime le) : " " : (logMsg le) : []
  writeMinimal es

getFilename :: LogEntry -> FilePath
getFilename LogEntry { logUsername  = Nothing  } = "other.log"
getFilename LogEntry { logUsername  = Just "-" } = "other.log"
getFilename LogEntry { logSessionId = Nothing  } = "other.log"
getFilename LogEntry { logSessionId = Just s, logUsername = Just u } = 
  unpack $ u <> "." <> s <> ".log"

output :: (MonadIO m, MonadState Options m) => LogEntry -> ByteString -> m ()
output le s = do
  o <- get
  if optSplitAll o then liftIO $ appendFile (getFilename le) (s <> pack "\n")
  else case optOutputFile o of
    Nothing -> liftIO $ putStrLn s
    Just f  -> liftIO $ appendFile f (s <> pack "\n")

writeOutput :: (MonadIO m, MonadState Options m) => [LogData] -> m ()
writeOutput es = do
  o <- get
  case optMessageOnly o of 
    True  -> writeMinimal    es
    False -> writeFullOutput es
