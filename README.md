# logman

## Overview
This is a tool for filtering, formatting and analyzing a specific JSON based log format.

## Options

| Short        | Long           | Parameter  | Description |
| --------- | ------------- | ----- | ---------------------------------------- |
| -s | --session-id= | SESSIONID | Filter by provided session id
| -u | --username= | USERNAME | Filter by the provided username
| -o | --output= | OUTFILE | Write output to the specified file
| -t | --start-time= | TIME | Only keep entries after the specified UTC time
| -e | --end-time= | TIME | Only keep entries before the specified UTC time
| -m | --minimal | | Use minimal output format with time and msg
| -a | --split-all | | Split all log entries into user/session based files
| -i | --ignore-parse-errors | | Ignore parsing errors

## Examples

**Basic formatting, ignoring errors**

Pipe input, minimal output format to stdout, ignore errors
```
cat sample.log | logman -i -m 
```
 
Same as above but specifying the input file as an argument
```
logman -i -m sample.log
```
 
output to a specified file
```
logman -i -m -o output.log sample.log
```
 
Same as above but using redirection
```
cat sample.log | logman -i -m > output.log
```


**Split input file into files based on user/session**

```
logman -a -i sample.log
```

Same as above but with formatting also
```
logman -a -i -m sample.log
```


**Filter by username**
```
logman -a -i -m -u "user1" sample.log > user1.log
```


**Filter by session id**
```
logman -a -i -m -s "123" sample.log > session123.log
```


**Filter by time range**
```
logman -a -i -m --start-time="2017-03-15 14:00:00.000" --end-time="2017-03-15 14:30:00.000" sample.log > timerange.log
```


 
 
 
