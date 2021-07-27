\name{q_rev}
\alias{q_rev}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Reversing question alternatives
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
q_rev(old, DK = F)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{old}{
%%     ~~Describe \code{old} here~~
}
  \item{DK}{
%%     ~~Describe \code{DK} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Hayato KATAGIRI

https://hayatokatagiri.jimdofree.com/
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (old, DK = F)
{
    print("Crosstable of the old variable")
    print(table(old))
    old_alt <- unique(old)
    j <- 1
    while (j <= length(DK)) {
        old_alt <- old_alt[old_alt != DK[j]]
        j <- j + 1
    }
    old_alt <- old_alt[complete.cases(old_alt)]
    old_alt <- sort(old_alt)
    print("Alternatives of the old variable without DK")
    print(old_alt)
    new_alt <- 1:length(old_alt)
    new_alt <- rev(new_alt)
    print("Alternatives of the new variable")
    print(new_alt)
    new <- NA
    max_value <- max(old, na.rm = T)
    i <- 1
    while (i <= length(old_alt)) {
        new[old == old_alt[i]] <- new_alt[i]
        i <- i + 1
    }
    print("Crosstable of the new variable")
    print(table(new))
    return(new)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
