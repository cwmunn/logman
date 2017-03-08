{-# LANGUAGE OverloadedStrings, FlexibleContexts #-}
module LogMan.Output
      ( writeOutput
      ) where

import Prelude hiding             (putStrLn, appendFile, concat)
import Control.Monad.State
import Data.ByteString.Lazy       (ByteString)
import Data.ByteString.Lazy.Char8 (putStrLn, appendFile)
import Data.Text.Lazy             (Text, concat)
import Data.Text.Lazy.Encoding    (encodeUtf8)

import LogMan.LogEntry
import LogMan.LogFile
import LogMan.Options

writeFullOutput :: (MonadIO m, MonadState Options m) => [LogData] -> m ()
writeFullOutput [] = return ()
writeFullOutput ((_,e):es) = do 
  output e
  writeFullOutput es
 
writeMinimal :: (MonadIO m, MonadState Options m) => [LogData] -> m ()
writeMinimal [] = return ()
writeMinimal ((le,_):es) = do 
  output $ encodeUtf8 $ concat $ (time le) : " " : (msg le) : []
  writeMinimal es

output :: (MonadIO m, MonadState Options m) => ByteString -> m ()
output s = do
  o <- get
  case optOutputFile o of
    Nothing -> liftIO $ putStrLn s
    Just f  -> liftIO $ appendFile f s

writeOutput :: (MonadIO m, MonadState Options m) => [LogData] -> m ()
writeOutput es = do
  o <- get
  case optMessageOnly o of 
    True  -> writeMinimal    es
    False -> writeFullOutput es
