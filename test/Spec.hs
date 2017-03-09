
testEntry :: LogEntry
testEntry = LogEntry 
    { name          = "name"
    , hostname      = "hostname"
    , pid           = 123
    , from          = "from"
    , level         = 10
    , time          = "time"
    , msg           = "msg"
    , v             = 0
    , error         = Nothing
    , contentLength = Nothing
    , sessionId     = Just "123"
    , username      = Just "user"
    , requestId     = Nothing
    , cookie        = Nothing
    , url           = Nothing
    , method        = Nothing
    , statusCode    = Nothing
    , durationInMs  = Nothing
    , objectCount   = Nothing
    } 

main :: IO ()
main = putStrLn "Test suite not yet implemented"
