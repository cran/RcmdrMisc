\name{repeatedMeasuresPlot}
\alias{repeatedMeasuresPlot}

\title{
Plot Means for Repeated-Measures ANOVA Designs
}
\description{
Creates a means plot for a repeated-measures ANOVA design with one or two within-subjects factor and zero or more between-subjects factors, for data in "wide" format.
}
\usage{
repeatedMeasuresPlot(data, within, within.names, within.levels, 
    between.names = NULL, response.name = "score", trace, xvar, 
    pch=15:25, lty=1:6, col=palette()[-1], 
    plot.means=TRUE, print.tables = FALSE)
}

\arguments{
  \item{data}{a data frame in wide format.}
  \item{within}{a character vector with the names of the data columns containing the repeated measures.}
  \item{within.names}{a character vector with one or two elements, of names of the within-subjects factor(s).}
  \item{within.levels}{a named list whose elements are character vectors of level names for the within-subjects factors, with names corresponding to the names of the within-subjects factors; the product of the numbers of levels should be equal to the number of repeated-measures columns in \code{within}.}
  \item{between.names}{a column vector of names of the between-subjects factors (if any).}
  \item{response.name}{optional quoted name for the response variable, defaults to \code{"score"}.}
  \item{trace}{optional quoted name of the (either within- or between-subjects) factor to define profiles of means in each panel of the graph; the default is the within-subjects factor with the smaller number of levels, if there are two, or not used if there is one.}
  \item{xvar}{optional quoted name of the factor to define the horizontal axis of each panel; the default is the within-subjects factor with the larger number of levels.}
  \item{pch, lty}{vectors of symbol and line-type numbers to use for the profiles of means (i.e., levels of the \code{trace} factor); for the meaning of the defaults, see \code{\link[graphics]{points}} and \code{\link[graphics]{par}}.}
  \item{col}{vector of colors for the profiles of means; the default is given by \code{palette()}, starting at the second color.}
  \item{plot.means}{if \code{TRUE} (the default), draw a plot of means by the factors.}
  \item{print.tables}{if \code{TRUE} (the default is \code{FALSE}), print tables of means
  and standard deviations of the response by the factors.}
}

\value{A \code{"trellis"} object, which normally is just "printed" (i.e., plotted).}

\author{
John Fox \email{jfox@mcmaster.ca}
}

\seealso{\code{\link[car]{Anova}}, \code{\link[carData]{OBrienKaiser}}}

\examples{
if (require(carData)){
repeatedMeasuresPlot(
  data=OBrienKaiser, 
  within=c("pre.1", "pre.2", "pre.3", "pre.4", "pre.5",
          "post.1", "post.2", "post.3", "post.4", "post.5",
          "fup.1", "fup.2", "fup.3", "fup.4", "fup.5"), 
  within.names=c("phase", "hour"), 
  within.levels=list(phase=c("pre", "post", "fup"),
                    hour = c("1", "2", "3", "4", "5")),
  between.names=c("gender", "treatment"),
  response.name="improvement",
  print.tables=TRUE)
}

if (require(carData)){
repeatedMeasuresPlot(data=OBrienKaiser, 
  within=c("pre.1", "pre.2", "pre.3", "pre.4", "pre.5",
          "post.1", "post.2", "post.3", "post.4", "post.5",
          "fup.1", "fup.2", "fup.3", "fup.4", "fup.5"), 
  within.names=c("phase", "hour"), 
  within.levels=list(phase=c("pre", "post", "fup"),
                    hour = c("1", "2", "3", "4", "5")),
  between.names=c("gender", "treatment"),
  trace="gender") # note that gender is between subjects
}

if (require(carData)){
repeatedMeasuresPlot(
  data=OBrienKaiser, 
  within=c("fup.1", "fup.2", "fup.3", "fup.4", "fup.5"), 
  within.names="hour", 
  within.levels=list(hour = c("1", "2", "3", "4", "5")),
  between.names=c("treatment", "gender"),
  response.name="improvement")
}
}

\keyword{hplot}
