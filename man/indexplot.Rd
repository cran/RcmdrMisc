\name{indexplot}
\alias{indexplot}

\title{
Index Plots
}

\description{
Index plots with point identification.
}

\usage{
indexplot(x, groups, labels = seq_along(x), id.method = "y", type = "h", 
    id.n = 0, ylab, legend="topright", title, col=palette(), ...) 
}

\arguments{
  \item{x}{a numeric variable, a matrix whose columns are numeric variables, or a numeric data frame;
    if \code{x} is a matrix or data frame, plots vertically aligned index plots for the columns.}
  \item{labels}{point labels; if \code{x} is a data frame, defaults to the row names of \code{x},
    otherwise to the case index.}
  \item{groups}{an optional grouping variable, typically a factor (or character or logical variable).}
  \item{id.method}{method for identifying points; see \code{\link[car]{showLabels}}.}
  \item{type}{to be passed to \code{\link{plot}}.}
  \item{id.n}{number of points to identify; see \code{\link[car]{showLabels}}.}
  \item{ylab}{label for vertical axis; if missing, will be constructed from \code{x}; for a data frame,
    defaults to the column names.}
  \item{legend}{(see \code{\link[graphics]{legend}}) giving location of the legend if \code{groups} are specified; 
    if \code{legend=FALSE}, the legend is suppressed.}
  \item{title}{title for the legend; may normally be omitted.}
  \item{col}{vector of colors for the \code{groups}.}
  \item{\dots}{to be passed to \code{plot}.}
}

\value{
Returns labelled indices of identified points or (invisibly) \code{NULL} if no points
are identified or if there are multiple variables with some missing data.
}

\author{
John Fox \email{jfox@mcmaster.ca}
}

\seealso{
\code{\link[car]{showLabels}}, \code{\link[graphics]{plot.default}}
}

\examples{
if (require("car")){
    with(Prestige, indexplot(income, id.n=2, labels=rownames(Prestige)))
    indexplot(Prestige[, c("income", "education", "prestige")], 
        groups = Prestige$type, id.n=2)
}
}

\keyword{hplot}
