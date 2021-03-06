% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/BifactorIndices.R
\name{bifactorIndices}
\alias{bifactorIndices}
\title{bifactorIndices}
\usage{
bifactorIndices(
  Lambda,
  Theta = NULL,
  UniLambda = NULL,
  standardized = TRUE,
  Phi = NULL,
  Thresh = NULL
)
}
\arguments{
\item{Lambda}{is a matrix of factor loadings or an object that can be converted to a
matrix of factor loadings by \code{\link{getLambda}}. Currently fitted \pkg{lavaan}
objects and fitted \pkg{mirt} objects are supported in addition to raw factor loading
matrix input. For \code{Mplus} output files, use \code{\link{bifactorIndicesMplus}}.}

\item{Theta}{is a vector of residual variances. If omitted, \code{Theta} will be computed from
input for \code{Lambda}.}

\item{UniLambda}{is a matrix of factor loadings or an object that can be converted to
a matrix of factor loadings such as a fitted \pkg{lavaan} objects or fitted \pkg{mirt}
object. Defaults to \code{NULL}, as \code{UniLambda} is only required if you wish to
compute \code{\link{ARPB}}.}

\item{standardized}{lets the function know whether to look for standardized or
unstandardized results from \pkg{lavaan} and defaults to \code{TRUE}. If \code{Lambda} is not a
 \pkg{lavaan} object, then \code{standardized} will be ignored.}

\item{Phi}{is the correlation matrix of factors and defaults to \code{NULL}. User should generally ignore this
parameter. If not provided, \code{bifactorIndices} will try to determine \code{Phi} from \code{Lambda} when \code{Lambda}
is a fitted lavaan model or will assume it is the identity matrix otherwise.}

\item{Thresh}{is a list of vectors of item thresholds, used only when items are categorical.\code{bifactorIndices}
 will try to determine \code{Thresh} from \code{Lambda} when \code{Lambda}
is a fitted lavaan model and the indicators are categorical.
\code{Thresh} defaults to null, which indicates items are continuous.}
}
\value{
A list of bifactor indices, including three different ECV indices, IECV, PUC,
Omega, OmegaH, Factor Determinacy (FD), Construct Replicability (H) and ARPB.
Please note that many of these indices are interpretable even
when the model being used is not a bifactor model; some indices may be useful for
two-tier, trifactor, correlated traits, and even unidimensional models.
}
\description{
Computes all available bifactor indices for the input given.
}
\details{
Currently, factor loading matrices, fitted \pkg{lavaan} objects, and fitted \pkg{mirt}
objects are supported. For \code{Mplus} output, see \code{\link{bifactorIndicesMplus}}.
IRT parameters from \pkg{mirt} are converted to standardized factor loadings via the
correspondence described in Kamata & Bauer (2008). If you wish to use standardized
coefficients, item error variance will be computed directly from standardized factor
loadings. \code{\link{ARPB}} will only be computed if the factor loadings from a unidimensional model
are included, while \code{\link{ECV_GS}} and \code{\link{ECV_SG}} will only be computed for
models with a general factor, and \code{\link{PUC}} will only be conputed for a true bifactor
model. Note that if a correlated traits model is provided, the omega indices
will simply be the regular omega values for those factors. Interpretations for individual
indices as well as details about their computation can be found in the man page for the
individual indices.

Formulas for all indices can be found in Rodriguez et al. (2016). When indicators are categorical,
the methodology of Green and Yang (2009) is used for computing Omega and OmegaH.
}
\examples{

# Computing bifactor indices from fitted lavaan object
# (using mirt object is similar). Use of the unidimensional
# model is optional; it is only used to compute ARPB.

\donttest{
SRS_UnidimensionalModel <-
  "SRS =~ SRS_1  + SRS_2  + SRS_3  + SRS_4  + SRS_5  +
          SRS_6  + SRS_7  + SRS_8  + SRS_9  + SRS_10 +
          SRS_11 + SRS_12 + SRS_13 + SRS_14 + SRS_15 +
          SRS_16 + SRS_17 + SRS_18 + SRS_19 + SRS_20"

SRS_Unidimensional <- lavaan::cfa(SRS_UnidimensionalModel,
                                 SRS_data,
                                 ordered = paste0("SRS_", 1:20),
                                 orthogonal = TRUE)


SRS_BifactorModel <-
"SRS =~ SRS_1  + SRS_2  + SRS_3  + SRS_4  + SRS_5  +
        SRS_6  + SRS_7  + SRS_8  + SRS_9  + SRS_10 +
        SRS_11 + SRS_12 + SRS_13 + SRS_14 + SRS_15 +
        SRS_16 + SRS_17 + SRS_18 + SRS_19 + SRS_20
 Function     =~ SRS_5  + SRS_9  + SRS_12 + SRS_15 + SRS_18
 Pain         =~ SRS_1  + SRS_2  + SRS_8  + SRS_11 + SRS_17
 SelfImage    =~ SRS_4  + SRS_6  + SRS_10 + SRS_14 + SRS_19
 MentalHealth =~ SRS_3  + SRS_7  + SRS_13 + SRS_16 + SRS_20"

SRS_bifactor <- lavaan::cfa(SRS_BifactorModel,
                            SRS_data,
                            ordered = paste0("SRS_", 1:20),
                            orthogonal = TRUE)

bifactorIndices(SRS_bifactor, UniLambda = SRS_Unidimensional)
}


# Computing bifactor indices from standardized factor loading matrices
Lambda <-  matrix(c(.82, .10,   0,   0,
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
bifactorIndices(Lambda)


# bifactorIndices can also be used on two-tier models
MTMM_model <- "
Trait1  =~ T1M1_1 + T1M1_2 + T1M1_3 +
           T1M2_1 + T1M2_2 + T1M2_3 +
           T1M3_1 + T1M3_2 + T1M3_3
Trait2  =~ T2M1_1 + T2M1_2 + T2M1_3 +
           T2M2_1 + T2M2_2 + T2M2_3 +
           T2M3_1 + T2M3_2 + T2M3_3
Trait3  =~ T3M1_1 + T3M1_2 + T3M1_3 +
           T3M2_1 + T3M2_2 + T3M2_3 +
           T3M3_1 + T3M3_2 + T3M3_3

Method1  =~ T1M1_1 + T1M1_2 + T1M1_3 +
            T2M1_1 + T2M1_2 + T2M1_3 +
            T3M1_1 + T3M1_2 + T3M1_3
Method2  =~ T1M2_1 + T1M2_2 + T1M2_3 +
            T2M2_1 + T2M2_2 + T2M2_3 +
            T3M2_1 + T3M2_2 + T3M2_3
Method3  =~ T1M3_1 + T1M3_2 + T1M3_3 +
            T2M3_1 + T2M3_2 + T2M3_3 +
            T3M3_1 + T3M3_2 + T3M3_3

Trait1 ~~ 0*Method1
Trait1 ~~ 0*Method2
Trait1 ~~ 0*Method3
Trait2 ~~ 0*Method1
Trait2 ~~ 0*Method2
Trait2 ~~ 0*Method3
Trait3 ~~ 0*Method1
Trait3 ~~ 0*Method2
Trait3 ~~ 0*Method3

Method1 ~~ 0*Method2
Method1 ~~ 0*Method3
Method2 ~~ 0*Method3"

MTMM_fit <- lavaan::cfa(MTMM_model, MTMM_data)
bifactorIndices(MTMM_fit)

}
\references{
Green, S. B., & Yang, Y. (2009). Reliability of summed item scores using
structural equation modeling: An alternative to coefficient alpha.
\emph{Psychometrika, 74}(1), 155-167 \doi{10.1007/s11336-008-9099-3}.

Kamata, A., & Bauer, D. J. (2008). A note on the relation between factor analytic and item
response theory models. \emph{Structural Equation Modeling: A Multidisciplinary Journal, 15}
(1), 136-153.

#' Rodriguez, A., Reise, S. P., & Haviland, M. G. (2016). Evaluating bifactor models:
calculating and interpreting statistical indices. \emph{Psychological Methods, 21}(2),
137 \doi{10.1037/met0000045}.
}
\seealso{
\code{\link{bifactorIndicesMplus}},
         \code{\link{bifactorIndices_expl}},
         \code{\link{bifactorIndicesMplus_expl}},
         \code{\link{bifactorIndicesMplus_ESEM}},
         \code{\link{ECV_SS}},
         \code{\link{ECV_SG}},
         \code{\link{ECV_GS}},
         \code{\link{IECV}},
         \code{\link{PUC}},
         \code{\link{Omega_S}},
         \code{\link{Omega_H}},
         \code{\link{cat_Omega_S}},
         \code{\link{cat_Omega_H}},
         \code{\link{H}},
         \code{\link{FD}},
         \code{\link{ARPB}}
}
