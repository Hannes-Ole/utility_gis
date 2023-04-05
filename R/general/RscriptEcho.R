#### RscriptEcho.R
# from https://stackoverflow.com/questions/14167178/passing-command-line-arguments-to-r-cmd-batch
#
# usage: RScript RscriptEcho.R exec_script.R args_exec_script
# example: Rscript RscriptEcho.R myScript.R 5 100
#
# will execute myScript.R with the supplied arguments 
# and sink interleaved input, output, and messages to a uniquely named .Rout.

args <- commandArgs(TRUE)
srcFile <- args[1]
outFile <- paste0(make.names(date()), ".Rout")
args <- args[-1]

sink(outFile, split = TRUE)
source(srcFile, echo = TRUE)