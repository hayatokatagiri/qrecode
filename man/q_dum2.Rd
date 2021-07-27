\name{q_dum2}
\alias{q_dum2}
\title{
Recording a Binaly Question to the Dummy Variable
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
q_dum2(old, rev = F)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{old}{

}
  \item{rev}{
%%     ~~Describe \code{rev} here~~
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
function (old, rev = F)
{
    if (rev == TRUE) {
        print("Crosstable of the old variable")
        print(table(old))
        new <- NA
        new[old == 1] <- 0
        new[old == 2] <- 1
        print("Crosstable of the new variable")
        print(table(new))
        return(new)
    }
    else {
        print("Crosstable of the old variable")
        print(table(old))
        new <- NA
        new[old == 1] <- 1
        new[old == 2] <- 0
        print("Crosstable of the new variable")
        print(table(new))
        return(new)
    }
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
