module Main where

import System.Environment
import LogMan.Processor

main :: IO ()
main = do
  args <- getArgs 
  run args
