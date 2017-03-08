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

writeFullOutput :: Options -> [LogData] -> IO ()
writeFullOutput o d = go d
  where 
    go []         = return ()
    go ((_,e):es) = do 
        output o e
        go es

writeMinimal :: Options -> [LogData] -> IO ()
writeMinimal o d = go d
  where 
    go []          = return ()
    go ((le,_):es) = do 
        output o $ encodeUtf8 $ concat $ (time le) : " " : (msg le) : []
        go es

output :: Options -> ByteString -> IO ()
output o = 
  case optOutputFile o of
    Nothing -> putStrLn
    Just f  -> appendFile f

writeOutput :: (MonadIO m, MonadState Options m) => [LogData] -> m ()
writeOutput es = do
  o <- get
  case optMessageOnly o of 
    True  -> liftIO $ writeMinimal o es
    False -> liftIO $ writeFullOutput o es