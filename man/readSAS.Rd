\name{readSAS}
\alias{readSAS}
\title{
Read a SAS b7dat Data Set
}
\description{
\code{readSAS} reads a SAS ``b7dat'' data set, stored in a file of type \code{.sas7bdat}, into an R data frame; it provides
a front end to the \code{\link[haven]{read_sas}} function in the \pkg{haven} package.
}

\usage{
readSAS(file, rownames=FALSE, stringsAsFactors=FALSE)
}

\arguments{
  \item{file}{path to a SAS b7dat file.}
  \item{rownames}{if \code{TRUE} (the default is \code{FALSE}), the first column in the
    data set contains row names (which must be unique---i.e., no duplicates).}
  \item{stringsAsFactors}{if \code{TRUE} (the default is \code{FALSE}) then columns containing character data are converted to
    factors.}
}

\value{
a data frame
}

\author{
John Fox \email{jfox@mcmaster.ca}
}

\seealso{
\code{\link[haven]{read_sas}}
}

\keyword{manip}
