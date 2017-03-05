module Main where

import System.Environment
import Processor

main :: IO ()
main = do
  args <- getArgs 
  run args
