% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/jmeterbarplotter.r
\name{jbp_read}
\alias{jbp_read}
\title{read csv files exported from jmeter.}
\usage{
jbp_read(files = c(), file_encoding = "UTF-8", elapsed = "elapsed",
  label = "label", file_separator = ";|:")
}
\arguments{
\item{files}{file path and alias name of csv file.}

\item{file_encoding}{file encoding type. default value is "UTF-8". not required.}

\item{elapsed}{column name for "elapsed time". default value is "elapsed". not required.}

\item{label}{column name for "label". default value is "label". not required.}

\item{file_separator}{separator of filepath. default is ";|:", not requred.}
}
\value{
The dataframe generated from csv.
}
\description{
read csv files exported from jmeter.
}
\examples{
\dontrun{
files <- c(result1="examples/path1/result.csv", result2="examples/path2/result.csv")
logs <- rtl_read(files)
}
}
