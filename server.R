server <- function(input, output, session){
     
     morbidities <- reactive({
          length(input$SelectMorbid)
     })
     
     SpecificData <- reactive({
          risk_df |> 
               filter(n_morbid == morbidities()) |> 
               filter(outcome != "Death or impairment") |> 
               select(outcome, avg_odds) 
     })
     
     overall_plot <- reactive({
          ggplot(risk_df[risk_df$outcome=="Death or impairment",], aes(x = n_morbid, y = avg_odds, label = avg_odds)) +
               geom_point() +
               geom_text(hjust = "right", size = 12 / .pt) +
               scale_y_continuous(limits = c(0,100), breaks = seq(0,100,10)) +
               xlab("Number of morbidities") +
               ylab("Probability (%)") +
               geom_errorbar(aes(ymin = lower, ymax = upper)) +
               ggtitle("Overall Probability (95% CI) of Death or Impairment at 5 Years") 
     })
     
     specific_plot <- reactive({
          ggplot(SpecificData()) +
               geom_col(aes(x = avg_odds, y = reorder(outcome, avg_odds)), fill = "blue") +
               geom_text(aes(x = avg_odds, y = reorder(outcome, avg_odds), label = avg_odds), hjust = "left", size = 12 / .pt) +
               xlab("Probability (%)") +
               ylab(NULL) +
               scale_x_continuous(limits = c(0,25)) +
               labs(caption = paste("Results based on having", morbidities(), "of Schmidt's morbidities.")) +
               theme(plot.caption = element_text(hjust = 0)) +
               ggtitle("Average Probability of Specific Adverse Outcomes at 5 Years")
     })
     
     output$OverallPlot <- renderPlot({
          print(overall_plot())
     })
     
     output$SpecificPlot <- renderPlot({
          print(specific_plot())
     })
     
     output$Report <- downloadHandler(
          filename = 'Report.pdf',
          
          content = function(file){
               pdf(file)
               print(overall_plot())
               print(specific_plot())
               dev.off()
          }
     )
     
}
