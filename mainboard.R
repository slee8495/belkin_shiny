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
               tabPanel("1. Key Metrics to Improve the Revenue", value = "q1",
                        fluidPage(
                          uiOutput("q1_content")
                        )),
               tabPanel("2. Investment Recommendations", value = "q2",
                        fluidPage(
                          uiOutput("q2_content")
                        )),
               tabPanel("3. Statistical Modeling", value = "chapter3",
                        fluidPage(
                          uiOutput("chapter3_content")
                        )),
               tabPanel("4. Visualizations", value = "chapter4",
                        fluidPage(
                          uiOutput("chapter4_content")
                        ))
    ),
    navbarMenu("Bonus Questions",
               tabPanel("1. Tableau", value = "bonus1",
                        fluidPage(
                          uiOutput("bonus1_content")
                        )),
               tabPanel("2. Automation Ideas", value = "bonus2",
                        fluidPage(
                          uiOutput("bonus2_content")
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
  
  
  ############################################################################################################################
  
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
  
  
  ############################################################################################################################
  
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
  
  ############################################################################################################################
  
  output$q1_content <- renderUI({
    file_name <- "q1.html" 
    if (!is.null(file_name)) {
      tags$iframe(src = file_name, style = "width:100%; height:800px;")
    }
  })
  
  
  ############################################################################################################################
  
  output$q2_content <- renderUI({
    file_name_2 <- "q2.html" 
    if (!is.null(file_name_2)) {
      tags$iframe(src = file_name_2, style = "width:100%; height:800px;")
    }
  })
  
  ############################################################################################################################
  
  
  
  # Read the data from the Excel file
  data  <- read_excel(excel_file_path) %>% 
    janitor::clean_names() %>% 
    dplyr::mutate(week_ending = as.Date(week_ending))
  
  output$overview_table <- renderDataTable({
    datatable(
      data,
      options = list(pageLength = 10)
    )
  })
}

shinyApp(ui = ui, server = server)
