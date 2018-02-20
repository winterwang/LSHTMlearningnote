xtsumR<-function(df,columns,individuals){
  df<-dplyr::arrange_(df,individuals)
  panel<-tibble::tibble()
  for (i in columns){
    v<-df %>% dplyr::group_by_() %>%
      dplyr::summarize_(
        mean=mean(df[[i]]),
        sd=sd(df[[i]]),
        min=min(df[[i]]),
        max=max(df[[i]])
      )
    v<-tibble::add_column(v,variacao="overal",.before=-1)
    v2<-aggregate(df[[i]],list(df[[individuals]]),"mean")[[2]]
    sdB<-sd(v2)
    varW<-df[[i]]-rep(v2,each=12) #
    varW<-varW+mean(df[[i]])
    sdW<-sd(varW)
    minB<-min(v2)
    maxB<-max(v2)
    minW<-min(varW)
    maxW<-max(varW)
    v<-rbind(v,c("between",NA,sdB,minB,maxB),c("within",NA,sdW,minW,maxW))
    panel<-rbind(panel,v)
  }
  var<-rep(names(df)[columns])
  n1<-rep(NA,length(columns))
  n2<-rep(NA,length(columns))
  var<-c(rbind(var,n1,n1))
  panel$var<-var
  panel<-panel[c(6,1:5)]
  names(panel)<-c("variable","variation","mean","standard.deviation","min","max")
  panel[3:6]<-as.numeric(unlist(panel[3:6]))
  panel[3:6]<-round(unlist(panel[3:6]),2)
  return(panel)
}