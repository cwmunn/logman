# logman

## Overview
This is a tool for filtering, formatting and analyzing a specific JSON based log format.

## Options

| Short        | Long           | Parameter  | Description |
| --------- | ------------- | ----- | ---------------------------------------- |
|| --session-id= | SESSIONID | Filter by provided session id
|| --username= | USERNAME | Filter by the provided username
| -o | --output= | OUTFILE | Write output to the specified file
|| --start-time= | TIME | Only keep entries after the specified UTC time
|| --end-time= | TIME | Only keep entries before the specified UTC time
|| --full-output | | Use full output format instread of the default minimal one
|| --split-all | | Split all log entries into user/session based files
|| --fail-on-parse-errors | | Don't ignore parsing errors

## Examples

**Basic formatting, ignoring errors**

Pipe input, minimal output format to stdout, ignore errors
```
cat sample.log | logman 
```
 
Same as above but specifying the input file as an argument
```
logman sample.log
```
 
output to a specified file
```
logman -o output.log sample.log
```
 
Same as above but using redirection
```
cat sample.log | logman > output.log
```


**Split input file into files based on user/session**

```
logman --split-all sample.log
```

**Filter by username**
```
logman --username="user1" sample.log > user1.log
```


**Filter by session id**
```
logman --session-id="123" sample.log > session123.log
```


**Filter by time range**
```
logman --start-time="2017-03-15 14:00:00.000" --end-time="2017-03-15 14:30:00.000" sample.log > timerange.log
```


 
 
 
