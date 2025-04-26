server <- function(input, output, session){
     
     SpecificData <- reactive({
          risk_df |> 
               filter(n_morbid == length(input$SelectMorbid)) |> 
               filter(outcome != "Death or impairment") |> 
               select(outcome, avg_odds) 
     })
     
     output$OverallPlot <- renderPlot({
          ggplot(risk_df[risk_df$outcome=="Death or impairment",], aes(x = n_morbid, y = avg_odds, label = avg_odds)) +
               geom_point() +
               geom_text(hjust = "right", size = 12 / .pt) +
               scale_y_continuous(limits = c(0,100), breaks = seq(0,100,10)) +
               xlab("Number of morbidities") +
               ylab("Probability (%)") +
               geom_errorbar(aes(ymin = lower, ymax = upper)) +
               ggtitle("Overall Probability (95% CI) of Death or Impairment at 5 Years")
     })
     
     output$SpecificPlot <- renderPlot({
          ggplot(SpecificData()) +
               geom_col(aes(x = avg_odds, y = reorder(outcome, avg_odds)), fill = "blue") +
               geom_text(aes(x = avg_odds, y = reorder(outcome, avg_odds), label = avg_odds), hjust = "left", size = 12 / .pt) +
               xlab("Probability (%)") +
               ylab(NULL) +
               scale_x_continuous(limits = c(0,25)) +
               ggtitle("Average Probability of Specific Adverse Outcomes at 5 Years")
     })
     
}
