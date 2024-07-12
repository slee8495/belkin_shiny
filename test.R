library(shiny)
library(shinythemes)
library(shinyWidgets)
library(DT)
library(rmarkdown)
library(shinyjs)
library(readxl)

# Define the path to your Excel file
excel_file_path <- "/Users/stanlee/Desktop/Desktop - Sangho’s MacBook Pro/Belkin/Case Study/belkin_shiny/belkin_data.xlsx"

ui <- fluidPage(
  theme = shinythemes::shinytheme("flatly"),
  tags$head(
    tags$style(HTML("
      .navbar .navbar-nav {
        width: 100%;
      }

      .navbar-brand {
        font-size: 25px; 
        margin-bottom: 30px;
        font-family: 'Verdana', sans-serif; 
      }
    "))
  ),
  
  navbarPage(
    id = "main_nav",
    title = div(class = "navbar-brand", "Belkin - Case Study: eCommerce Data Analyst Hiring Process [Sangho Lee]"),
    tabPanel("📱", value = "home", uiOutput("home")),
    navbarMenu("Introduction",
               tabPanel("Overview", value = "overview", 
                        fluidPage(
                          uiOutput("overview")
                        )),
               tabPanel("Data", value = "data",
                        fluidPage(
                          uiOutput("data_html"),
                          br(),
                          dataTableOutput("overview_table")
                        ))
    ),
    navbarMenu("Key Questions to answer",
               tabPanel("Chapter 1: Decision Analysis", value = "chapter1",
                        fluidPage(
                          pickerInput("chapter1_select", "Choose a Case:",
                                      choices = c("Bio-Imaging Development Strategies", 
                                                  "Bill Sampras Summer Job Decision")),
                          uiOutput("chapter1_content"))),
               
               
               tabPanel("Chapter 6: Regression Models: Concepts and Practice", value = "chapter6",
                        fluidPage(
                          pickerInput("chapter6_select", "Choose a Case:",
                                      choices = c("The Construction Department at Croq'Pain")),
                          uiOutput("chapter6_content")))
               
    ),
    navbarMenu("Bonus Question",
               tabPanel("Marketing Analytics", value = "mar_analytics",
                        fluidPage(
                          pickerInput("mar1_select", "Choose a Case:",
                                      choices = c("Segmentation: K-means Clustering [Palmer Penguin]",
                                                  "A/B Testing [Fund raising: Donation]",
                                                  "Maximum Likelihood Estimation [Blueprinty]",
                                                  "Maximum Likelihood Estimation [Air BnB]",
                                                  "Multi-nomial Logit (MNL) Model [Yogurt]",
                                                  "Multi-nomial Logit (MNL) Model [Minivan]",
                                                  "Variable Importance [Payment Card]")),
                          uiOutput("mar1_content")
                        )),
               
               tabPanel("Supply Chain Analytics", value = "sc_analytics",
                        fluidPage(
                          pickerInput("sup1_select", "Choose a Case:",
                                      choices = c("Clustering Analysis [Late Order Acknowledgement]",
                                                  "Distribution Center Cost Comparison: Regional vs. National",
                                                  "Customer Flow Analysis [Rogers Market: Amazon Just Walk Out Technology]"
                                      )),
                          uiOutput("sup1_content")
                        )),
               
               
               tabPanel("People Analytics", value = "pep_analytics",
                        fluidPage(
                          pickerInput("pep1_select", "Choose a Case:",
                                      choices = c("Forecasting Attrition Rates for Each Manufacturing Facility")),
                          uiOutput("pep1_content")
                        ))
               
    )
  )
)

server <- function(input, output, session) {
  active_tab <- reactiveVal("home")
  
  observeEvent(input$main_nav, {
    if(input$main_nav == "home") {
      rendered_html <- rmarkdown::render("home.Rmd", output_dir = "www", output_file = "home.html")
      active_tab(input$main_nav)
    }
  })
  
  output$home <- renderUI({
    if (active_tab() == "home") {
      tags$iframe(src = "home.html", style = "width:100%; height:800px;")
    }
  })
  
  observeEvent(input$main_nav, {
    if(input$main_nav == "overview") {
      rendered_html <- rmarkdown::render("overview.Rmd", output_dir = "www", output_file = "overview.html")
      active_tab(input$main_nav)
    }
  })
  
  output$overview <- renderUI({
    if (active_tab() == "overview") {
      tags$iframe(src = "overview.html", style = "width:100%; height:800px;")
    }
  })
  
  observeEvent(input$main_nav, {
    if(input$main_nav == "data") {
      rendered_html <- rmarkdown::render("data.Rmd", output_dir = "www", output_file = "data.html")
      active_tab(input$main_nav)
    }
  })
  
  output$data_html <- renderUI({
    if (active_tab() == "data") {
      tags$iframe(src = "data.html", style = "width:100%; height:400px;")
    }
  })
  
  # Read the data from the Excel file
  data <- read_excel(excel_file_path)
  
  output$overview_table <- renderDataTable({
    datatable(
      data,
      options = list(pageLength = 10)
    )
  })
}

shinyApp(ui = ui, server = server)
