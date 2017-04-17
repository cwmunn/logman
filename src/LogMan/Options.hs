{-# LANGUAGE OverloadedStrings, ScopedTypeVariables #-}
module LogMan.Options
      ( Options(..)
      , parseOptions
      ) where

import Data.Text.Lazy         (Text)
import Data.String            (fromString)
import Data.Time.Clock
import System.Console.GetOpt

data Options = Options
  { optSessionId          :: Maybe Text
  , optUsername           :: Maybe Text
  , optOutputFile         :: Maybe FilePath
  , optMessageOnly        :: Bool
  , optStartTime          :: Maybe UTCTime
  , optEndTime            :: Maybe UTCTime
  , optSplitAll           :: Bool
  , optIgnoreParseErrors  :: Bool
  } deriving Show

defaultOptions = Options
  { optSessionId          = Nothing
  , optUsername           = Nothing
  , optOutputFile         = Nothing
  , optMessageOnly        = True
  , optStartTime          = Nothing
  , optEndTime            = Nothing
  , optSplitAll           = False
  , optIgnoreParseErrors  = True
  }

toUTCTime :: String -> UTCTime
toUTCTime s = read s

options :: [OptDescr (Options -> Options)]
options =
  [ Option [] ["session-id"]
      (ReqArg (\arg opts -> opts { optSessionId = Just $ fromString arg }) "SESSIONID")
      "session id"
  , Option [] ["username"]
      (ReqArg (\arg opts -> opts { optUsername = Just $ fromString arg }) "USERNAME")
      "username"
  , Option ['o'] ["output"]
      (ReqArg (\arg opts -> opts { optOutputFile = Just $ arg }) "OUTFILE")
      "outfile"
  , Option [] ["start-time"]
      (ReqArg (\arg opts -> opts { optStartTime = Just $ toUTCTime arg }) "TIME")
      "start time"
  , Option [] ["end-time"]
      (ReqArg (\arg opts -> opts { optEndTime = Just $ toUTCTime arg }) "TIME")
      "end time"
  , Option []     ["full-output"]
        (NoArg (\ opts -> opts { optMessageOnly = False }))
        "Full output"
  , Option []     ["split-all"]
        (NoArg (\ opts -> opts { optSplitAll = True }))
        "split activity into user/session based files"
  , Option []     ["fail-on-parse-errors"]
        (NoArg (\ opts -> opts { optIgnoreParseErrors = False }))
        "don't ignore parsing errors"
  ]

parseOptions :: [String] -> IO (Options, [String])
parseOptions argv =
  case getOpt RequireOrder options argv of
     (o,n,[]  ) -> return (foldl (flip id) defaultOptions o, n)
     (_,_,errs) -> ioError (userError (concat errs ++ usageInfo header options))
 where header = "Usage: logman [OPTION...] file"
