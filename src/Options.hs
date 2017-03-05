{-# LANGUAGE OverloadedStrings, ScopedTypeVariables #-}

module Options
      ( Options(..)
      , parseOptions
      ) where

import Data.Text (Text)
import Data.String (fromString)
import System.Console.GetOpt
import Data.Maybe ( fromMaybe )

data Options = Options
  { optSessionId   :: Maybe Text
  , optUsername    :: Maybe Text
  , optOutputFile  :: Maybe FilePath
  } deriving Show

defaultOptions = Options
  { optSessionId  = Nothing
  , optUsername   = Nothing
  , optOutputFile = Nothing
  }

options :: [OptDescr (Options -> Options)]
options =
  [ Option ['s'] ["session-id"]
      (ReqArg (\arg opts -> opts { optSessionId = Just $ fromString arg }) "SESSIONID")
      "session id",
    Option ['u'] ["username"]
      (ReqArg (\arg opts -> opts { optUsername = Just $ fromString arg }) "USERNAME")
      "username",
    Option ['o'] ["output"]
      (ReqArg (\arg opts -> opts { optOutputFile = Just $ arg }) "OUTFILE")
      "outfile"
  ]

parseOptions :: [String] -> IO (Options, [String])
parseOptions argv =
  case getOpt RequireOrder options argv of
     (o,n,[]  ) -> return (foldl (flip id) defaultOptions o, n)
     (_,_,errs) -> ioError (userError (concat errs ++ usageInfo header options))
 where header = "Usage: logman [OPTION...] file"
