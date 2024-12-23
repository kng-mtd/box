library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(DT)

shinyUI(
  fluidPage(
    dashboardPage(skin='black',
      dashboardHeader(
        title='Looking around e-Stat',
        disable=F,titleWidth='20vw'),
      
      dashboardSidebar(
        h3(tags$a(href='https://www.e-stat.go.jp/api/sample/testform2/getStatsList.html',
                  'Go e-Stat API page',target='_blank')),
        h4('to get statsDataID directly'),
        textInput('id','appID',
                  value='ddbfecf8400828ef145464e15a1a2499f431dc16'),
        br(),
        textInput('inp0','keyword'),
        actionButton('bt0','Get, wait a few minutes'),
        br(),br(),
        textInput('inp1','STAT_NAME'),
        textInput('inp2','STATISTICS_NAME'),
        textInput('inp3','statsDataID'),
        actionButton('bt1','Get table'),
        br(),
        h3(tags$a(href='https://www.e-stat.go.jp/stat-search?page=1',
                  'Go e-Stat for details',target='_blank'))),
      
      dashboardBody(
        fluidRow(
          column(width=4,
                 box(width=12,
                     title='STAT_NAME',
                     collapsible=T,
                     collapsed=F,
                     style='height:200px;
                                overflow-y:scroll;',
                     withSpinner(
                       verbatimTextOutput('out1'))
                     ),
                 box(width=12,
                     title='STATISTICS_NAME',
                     collapsible=T,
                     collapsed=F,
                     style='height:300px;
                                overflow-y:scroll;',
                     verbatimTextOutput('out2')),
                 box(width=12,
                     title='statsDataID',
                     collapsible=T,
                     collapsed=F,
                     style='height:500px;
                                overflow-y:scroll;',
                     verbatimTextOutput('out3'))),

          column(width=8,
                 verbatimTextOutput('out4'),
                 DTOutput('table'),
                 downloadButton('download', '- Download -'))
          )
      )
    )
  )
)
