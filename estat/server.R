library(shiny)
library(shinydashboard)
library(tidyverse)
library(DT)
library(estatapi)

shinyServer(function(input,output,session){
  options(shiny.maxRequestSize=1000*1024^2)
  options(digits=3)

  
  #appID='ddbfecf8400828ef145464e15a1a2499f431dc16'
  appID=reactive(trimws(input$id))
  
  code=eventReactive(input$bt0,{
    estat_getStatsList(appID(),searchWord=trimws(input$inp0))    
  })
  
  str1=reactive(trimws(input$inp1))
  str2=reactive(trimws(input$inp2))
  str3=eventReactive(input$bt1,{trimws(input$inp3)})
  
  data=reactive(estat_getStatsData(appID(),
                                   statsDataId=str3(),
                                   lvCat01='1'))
  
  output$out1=renderPrint(
    code() %>% 
      select(STAT_NAME,MAIN_CATEGORY,SUB_CATEGORY) %>% 
      distinct(STAT_NAME, .keep_all=T) %>% 
      arrange(MAIN_CATEGORY) %>% 
      print(n=Inf)
  )
  
  output$out2=renderPrint(
    code() %>%
      filter(str_detect(STAT_NAME,str1())) %>% 
      select(STATISTICS_NAME) %>% 
      distinct(STATISTICS_NAME, .keep_all=T) %>% 
      print(n=Inf)
  )
  
  output$out3=renderPrint(
    code() %>%
      filter(str_detect(STATISTICS_NAME,str2())) %>%
      select('@id',TITLE) %>%
      distinct(`@id`, .keep_all=T) %>% 
      print(n=Inf)
  )
  
  output$out4=renderPrint(
    code() %>%
      filter(str_detect(`@id`,str3())) %>%
      distinct(TITLE, .keep_all=T) %>%
      select(1:8) %>% 
      as.character()
  )
  
  output$table=renderDT({
    #cols=seq(3,ncol(data)-3)
    cols=seq(2,ncol(data())-3,2)
    
    data() %>%
      mutate_at(vars(cols),as_factor) %>%     
      select(cols,value) %>%
      datatable(rownames=F,
                filter='top',
                options=list(autoWidth=T,
                             scrollX=T,
                             scrollCollape=T))
  })
  
  output$download=downloadHandler(
    filename=function(){'data00.csv'},
    content=function(file) {
      write.csv(data(),file,fileEncoding='CP932')}
  )
})