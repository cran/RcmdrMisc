# various high-level plots

# last modified 2020-07-22 by J. Fox

Hist <- function(x, groups, scale=c("frequency", "percent", "density"), xlab=deparse(substitute(x)), 
    ylab=scale, main="", breaks="Sturges", ...){
    xlab # evaluate
    scale <- match.arg(scale)
    ylab
    if (!missing(groups)){
        groupsName <- deparse(substitute(groups))
        if (!is.factor(groups)){
          if (!(is.character(groups) || is.logical(groups)))
            warning("groups variable is not a factor, character, or logical")
          groups <- as.factor(groups)
        }
        counts <- table(groups)
        if (any(counts == 0)){
            levels <- levels(groups)
            warning("the following groups are empty: ", paste(levels[counts == 0], collapse=", "))
        }
        levels <- levels(groups)
        hists <- lapply(levels, function(level) if (counts[level] != 0)  
            hist(x[groups == level], plot=FALSE, breaks=breaks)
            else list(breaks=NA))
        range.x <- range(unlist(lapply(hists, function(hist) hist$breaks)), na.rm=TRUE)
        n.breaks <- max(sapply(hists, function(hist) length(hist$breaks)))
        breaks. <- seq(range.x[1], range.x[2], length=n.breaks)
        hists <- lapply(levels, function(level) if (counts[level] != 0) 
            hist(x[groups == level], plot=FALSE, breaks=breaks.)
            else list(counts=0, density=0))
        names(hists) <- levels
        ylim <- if (scale == "frequency"){
            max(sapply(hists, function(hist) max(hist$counts)))
        }
        else if (scale == "density"){
            max(sapply(hists, function(hist) max(hist$density)))
        }
        else {
            max.counts <- sapply(hists, function(hist) max(hist$counts))
            tot.counts <- sapply(hists, function(hist) sum(hist$counts))
            ylims <- tot.counts*(max(max.counts[tot.counts != 0]/tot.counts[tot.counts != 0]))
            names(ylims) <- levels
            ylims
        }
        save.par <- par(mfrow=n2mfrow(sum(counts != 0)), oma = c(0, 0, if (main != "") 1.5 else 0, 0))
        on.exit(par(save.par))
        for (level in levels){
            if (counts[level] == 0) next
            if (scale != "percent") Hist(x[groups == level], scale=scale, xlab=xlab, ylab=ylab, 
                main=paste(groupsName, "=", level), breaks=breaks., ylim=c(0, ylim), ...)
            else Hist(x[groups == level], scale=scale, xlab=xlab, ylab=ylab, 
                main=paste(groupsName, "=", level), breaks=breaks., ylim=c(0, ylim[level]), ...)
        }
        if (main != "") mtext(side = 3, outer = TRUE, main, cex = 1.2)
        return(invisible(hists))
    }
    x <- na.omit(x)
    if (scale == "frequency") {
        hist <- hist(x, xlab=xlab, ylab=ylab, main=main, breaks=breaks, ...)
    }
    else if (scale == "density") {
        hist <- hist(x, freq=FALSE, xlab=xlab, ylab=ylab, main=main, breaks=breaks, ...)
    }
    else {
        n <- length(x)
        hist <- hist(x, axes=FALSE, xlab=xlab, ylab=ylab, main=main, breaks=breaks, ...)
        axis(1)
        max <- ceiling(10*par("usr")[4]/n)
        at <- if (max <= 3) (0:(2*max))/20
        else (0:max)/10
        axis(2, at=at*n, labels=at*100)
    }
    box()
    abline(h=0)
    invisible(hist)
}

indexplot <- function(x, groups, labels=seq_along(x), id.method="y", type="h", id.n=0, ylab, legend="topright", title, col=palette(), ...){
    if (is.data.frame(x)) {
        if (missing(labels)) labels <- rownames(x)
        x <- as.matrix(x)
    }
    if (!missing(groups)){
        if (missing(title)) title <- deparse(substitute(groups))
        if (!is.factor(groups)) groups <- as.factor(groups)
        groups <- addNA(groups, ifany=TRUE)
        grps <- levels(groups)
        grps[is.na(grps)] <- "NA"
        levels(groups) <- grps
        if (length(grps) > length(col)) stop("too few colors to plot groups")
    }
    else {
        grps <- NULL
        legend <- FALSE
    }
    if (is.matrix(x)){
        ids <- NULL
        mfrow <- par(mfrow=c(ncol(x), 1))
        on.exit(par(mfrow)) 
        if (missing(labels)) labels <- 1:nrow(x)
        if (is.null(colnames(x))) colnames(x) <- paste0("Var", 1:ncol(x))
        for (i in 1:ncol(x)) {
            id <- indexplot(x[, i], groups=groups, labels=labels, id.method=id.method, type=type, id.n=id.n,
                            ylab=if (missing(ylab)) colnames(x)[i] else ylab, legend=legend, title=title, ...)
            ids <- union(ids, id)
            legend <- FALSE
        }
        if (is.null(ids) || any(is.na(x))) return(invisible(NULL)) else {
            ids <- sort(ids)
            names(ids) <- labels[ids]
            if (any(is.na(names(ids))) || all(ids == names(ids))) names(ids) <- NULL
            return(ids)
        }
    }
    if (missing(ylab)) ylab <- deparse(substitute(x))
    plot(x, type=type, col=if (is.null(grps)) col[1] else col[as.numeric(groups)],
         ylab=ylab, xlab="Observation Index", ...)
    if (!isFALSE(legend)){
        legend(legend, title=title, bty="n",
               legend=grps, col=palette()[1:length(grps)], lty=1, horiz=TRUE, xpd=TRUE)
    }
    if (par("usr")[3] <= 0) abline(h=0, col='gray')
    ids <- showLabels(seq_along(x), x, labels=labels, method=id.method, n=id.n)
    if (is.null(ids)) return(invisible(NULL)) else return(ids)
}

lineplot <- function(x, ..., legend){
    xlab <- deparse(substitute(x))
    y <- cbind(...)
    m <- ncol(y)
    legend <- if (missing(legend)) m > 1
    if (legend && m > 1) {
        mar <- par("mar")
        top <- 3.5 + m
        old.mar <- par(mar=c(mar[1:2], top, mar[4]))
        on.exit(par(old.mar))
    }
    if (m > 1) matplot(x, y, type="b", lty=1, xlab=xlab, ylab="")
    else plot(x, y, type="b", pch=16, xlab=xlab, ylab=colnames(y))
    if (legend && ncol(y) > 1){
        xpd <- par(xpd=TRUE)
        on.exit(par(xpd), add=TRUE)
        ncols <- length(palette())
        cols <- rep(1:ncols, 1 + m %/% ncols)[1:m]
        usr <- par("usr")
        legend(usr[1], usr[4] + 1.2*top*strheight("x"), 
            legend=colnames(y), col=cols, lty=1, pch=as.character(1:m))
    }
    return(invisible(NULL))
}

plotDistr <- function(x, p, discrete=FALSE, cdf=FALSE, regions=NULL, col="gray", 
                      legend=TRUE, legend.pos="topright", ...){
  if (discrete){
    if (cdf){
      plot(x, p, ..., type="n")
      abline(h=0:1, col="gray")
      lines(x, p, ..., type="s")
    }
    else {
      plot(x, p, ..., type="h")
      points(x, p, pch=16)
      abline(h=0, col="gray")
    }
  }
  else{
    if (cdf){
      plot(x, p, ..., type="n")
      abline(h=0:1, col="gray")
      lines(x, p, ..., type="l")
    }
    else{
      plot(x, p, ..., type="n")
      abline(h=0, col="gray")
      lines(x, p, ..., type="l")
    }
    if (!is.null(regions)){
      col <- rep(col, length=length(regions))
      for (i in 1:length(regions)){
        region <- regions[[i]]
        which.xs <- (x >= region[1] & x <= region[2])
        xs <- x[which.xs]
        ps <- p[which.xs]
        xs <- c(xs[1], xs, xs[length(xs)])
        ps <- c(0, ps, 0)
        polygon(xs, ps, col=col[i])
      }
      if (legend){
        if (length(unique(col)) > 1){
          legend(legend.pos, title = if (length(regions) > 1) "Regions" else "Region", 
                 legend=sapply(regions, function(region){ 
                   paste(round(region[1], 2), "to", round(region[2], 2))
                 }),
                 col=col, pch=15, pt.cex=2.5, inset=0.02)
        }
        else
        {
          legend(legend.pos, title = if (length(regions) > 1) "Regions" else "Region", 
                 legend=sapply(regions, function(region){ 
                   paste(round(region[1], 2), "to", round(region[2], 2))
                 }), inset=0.02)
        }
      }
    }
  }
  return(invisible(NULL))
}

plotMeans <- function(response, factor1, factor2, error.bars = c("se", "sd", "conf.int", "none"),
                      level=0.95, xlab=deparse(substitute(factor1)), ylab=paste("mean of", deparse(substitute(response))),
                      legend.lab=deparse(substitute(factor2)), 
                      legend.pos=c("farright", "bottomright", "bottom", "bottomleft", "left", "topleft", "top", "topright", "right", "center"),
                      main="Plot of Means",
                      pch=1:n.levs.2, lty=1:n.levs.2, col=palette(), connect=TRUE, ...){
    if (!is.numeric(response)) stop("Argument response must be numeric.")
    xlab # force evaluation
    ylab
    legend.lab
    legend.pos <- match.arg(legend.pos)
    error.bars <- match.arg(error.bars)
    if (!is.factor(factor1)) {
      if (!(is.character(factor1) || is.logical(factor1))) 
        stop("Argument factor1 must be a factor, character, or logical.")
      factor1 <- as.factor(factor1)
    }
    if (missing(factor2)){
        valid <- complete.cases(factor1, response)
        factor1 <- factor1[valid]
        response <- response[valid]
        means <- tapply(response, factor1, mean)
        sds <- tapply(response, factor1, sd)
        ns <- tapply(response, factor1, length)
        if (error.bars == "se") sds <- sds/sqrt(ns)
        if (error.bars == "conf.int") sds <- qt((1 - level)/2, df=ns - 1, lower.tail=FALSE) * sds/sqrt(ns)
        sds[is.na(sds)] <- 0
        yrange <-  if (error.bars != "none") c( min(means - sds, na.rm=TRUE), max(means + sds, na.rm=TRUE)) else range(means, na.rm=TRUE)
        levs <- levels(factor1)
        n.levs <- length(levs)
        plot(c(1, n.levs), yrange, type="n", xlab=xlab, ylab=ylab, axes=FALSE, main=main, ...)
        points(1:n.levs, means, type=if (connect) "b" else "p", pch=16, cex=2)
        box()
        axis(2)
        axis(1, at=1:n.levs, labels=levs)
        if (error.bars != "none") arrows(1:n.levs, means - sds, 1:n.levs, means + sds,
                                         angle=90, lty=2, code=3, length=0.125)
    }
    else {
        if (!is.factor(factor2)) {
          if (!(is.character(factor2) || is.logical(factor2))) 
            stop("Argument factor2 must be a factor, charcter, or logical.")
          factor2 <- as.factor(factor2)
        }        
        valid <- complete.cases(factor1, factor2, response)
        factor1 <- factor1[valid]
        factor2 <- factor2[valid]
        response <- response[valid]
        means <- tapply(response, list(factor1, factor2), mean)
        sds <- tapply(response, list(factor1, factor2), sd)
        ns <- tapply(response, list(factor1, factor2), length)
        if (error.bars == "se") sds <- sds/sqrt(ns)
        if (error.bars == "conf.int") sds <- qt((1 - level)/2, df=ns - 1, lower.tail=FALSE) * sds/sqrt(ns)
        sds[is.na(sds)] <- 0
        yrange <-  if (error.bars != "none") c( min(means - sds, na.rm=TRUE), max(means + sds, na.rm=TRUE)) else range(means, na.rm=TRUE)
        levs.1 <- levels(factor1)
        levs.2 <- levels(factor2)
        n.levs.1 <- length(levs.1)
        n.levs.2 <- length(levs.2)
        if (length(pch) == 1) pch <- rep(pch, n.levs.2)
        if (length(col) == 1) col <- rep(col, n.levs.2)
        if (length(lty) == 1) lty <- rep(lty, n.levs.2)
        expand.x.range <- if (legend.pos == "farright") 1.4 else 1
        if (n.levs.2 > length(col)) stop(sprintf("Number of groups for factor2, %d, exceeds number of distinct colours, %d."), n.levs.2, length(col))		
        plot(c(1, n.levs.1 * expand.x.range), yrange, type="n", xlab=xlab, ylab=ylab, axes=FALSE, main=main, ...)
        box()
        axis(2)
        axis(1, at=1:n.levs.1, labels=levs.1)
        for (i in 1:n.levs.2){
            points(1:n.levs.1, means[, i], type=if (connect) "b" else "p", pch=pch[i], cex=2, col=col[i], lty=lty[i])
            if (error.bars != "none") arrows(1:n.levs.1, means[, i] - sds[, i],
                                             1:n.levs.1, means[, i] + sds[, i], angle=90, code=3, col=col[i], lty=lty[i], length=0.125)
        }
        if (legend.pos == "farright"){
            x.posn <- n.levs.1 * 1.1
            y.posn <- sum(c(0.1, 0.9) * par("usr")[c(3,4)])
            #            text(x.posn, y.posn, legend.lab, adj=c(0, -.5))
            legend(x.posn, y.posn, levs.2, pch=pch, col=col, lty=lty, title=legend.lab)
        }
        else legend(legend.pos, levs.2, pch=pch, col=col, lty=lty, title=legend.lab, inset=0.02)
    }
    invisible(NULL)
}
