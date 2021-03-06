% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Other_Indices.R
\name{H}
\alias{H}
\title{Construct Replicability}
\usage{
H(Lambda)
}
\arguments{
\item{Lambda}{is a matrix of standardized factor loadings}
}
\value{
a vector of construct reliabilities.
}
\description{
\code{H} computes construct replicability for all factors given
standardized factor loadings.
}
\details{
\code{H} is called by \code{\link{bifactorIndices}} and the various convenience functions
for exploratory models and/or Mplus output,
which are the only functions in this package intended for casual users.
}
\examples{
Lambda <- matrix(c(.82, .10,   0,   0,
                   .77, .35,   0,   0,
                   .79, .32,   0,   0,
                   .66, .39,   0,   0,
                   .51,   0, .71,   0,
                   .56,   0, .43,   0,
                   .68,   0, .13,   0,
                   .60,   0, .50,   0,
                   .83,   0,   0, .47,
                   .60,   0,   0, .27,
                   .78,   0,   0, .28,
                   .55,   0,   0, .75),
                   ncol = 4, byrow = TRUE)
colnames(Lambda) <- c("General", "SF1", "SF2", "SF3")
H(Lambda)

}
\seealso{
\code{\link{bifactorIndices}}
}
