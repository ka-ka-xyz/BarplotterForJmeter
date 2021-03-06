% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/jmeterbarplotter.r
\name{jbp_plot}
\alias{jbp_plot}
\title{plot barplot for dataframe exported from jmeter.}
\usage{
jbp_plot(data = data.frame(), horizonal = F, show_value = T,
  errorbar_type = "", pagesize = 10, pic_prefix = "result_",
  pic_width = 20, pic_height = 20, pic_dpi = 300, title = "Result",
  xlab = "labels", ylab = "elapsed time (ms)")
}
\arguments{
\item{data}{dataframe exported from jmeter}

\item{errorbar_type}{errorbar type, "sd" means Standard Deviation, "ci" means 95% Confidence Interval. not required.}

\item{pagesize}{number of labels in one graph. default value is "10". not required.}

\item{pic_prefix}{prefix for graph image file(png). default value is "result_". not required.}

\item{pic_width}{width of graph image file (cm). default value = 20. not required.}

\item{pic_height}{height of graph image file (cm). default value = 20. not required.}

\item{pic_dpi}{dpi of graph image file. default value = 300. not required.}

\item{title}{title of graph. default value is "Jmeter Result". not required.}

\item{xlab}{graph label of x-axis. default value is "elapsed time (ms)". not required.}

\item{ylab}{graph label of y-axis. default value is "labels". not required.}
}
\description{
plot barplot for dataframe exported from jmeter.
}
\examples{
\dontrun{
files <- c(result1="examples/path1/result.csv", result2="examples/path2/result.csv")
logs <- rtl_read(files)
}
}
