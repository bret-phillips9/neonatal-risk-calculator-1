appTheme <- bs_theme(
     version = 5,
     bootswatch = "solar"
)

appSidebar <- checkboxGroupInput(
     inputId = "SelectMorbid",
     label = strong("Select conditions (check all that apply):"),
     choiceNames = list("Bronchopulmornary Dysplasia", "Serious Brain Injury", "Severe Retinopathy of Prematurity"),
     choiceValues = list("BPD", "TBI", "ROP")
)

appMain <- mainPanel(
     tabsetPanel(
          tabPanel("Overall Risk", 
                   plotOutput("OverallPlot"),
                   p("NOTE: This chart is not interactive.")
                   ),
          tabPanel("Specific Outcome Risks",
                   strong("INSTRUCTIONS"),
                   p("This is an interactive chart.  Select/de-select checkboxes at left to see change in probabilities below."),
                   plotOutput("SpecificPlot")
                   ),
          tabPanel("Report"),
          tabPanel("Reference",
                   p("This dashboard is based on the work of"),
                   p("Schmidt, B., Roberts, R.S., Davis, P.G., Doyle, L.W., Asztalos, E.V., Opie, G., Bairam, A., Solimano, A., Arnon, S., & Sauve, R.S. (2015).  Prediction of late death or disability at age 5 years using a count of 3 neonatal morbidities in very low birth weight infants. ",
                     span("The Journal of Pediatrics, 167,", style = "font-weight: bold"),
                     " 962-986.")
                   )
     )
)
     
page_sidebar(
     title = "Neonatal Risk Calculator",
     sidebar = appSidebar,
     theme = appTheme,
     appMain
)
