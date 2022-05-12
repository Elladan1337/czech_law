library(tidyverse)
# Import ------------------------------------------------------------------
import <- read.csv("~/Desktop/res_data.csv")
#https://www.czso.cz/csu/czso/registr-ekonomickych-subjektu-otevrena-data

pf_stats <- import %>%
  group_by(FORMA) %>%
  summarize(n())

# Step 2------------------------------------------------------------

complete = pf_stats %>%
  filter(FORMA %in% c(111, 112, 113, 121, 205, 931, 932, 933))

#Selection of relevant corporation forms

complete$Forma <- c("v.o.s.", "s.r.o.", "k.s.", "a.s.", "družstvo", "EHZS", "SE", "Ev. družstvo")
colnames(complete) <- c("Forma", "Počet")

#Renaming

ggplot(complete, aes(x=Forma, y=Počet, color=Forma, fill=Forma)) +
  geom_bar(stat="identity") +
  geom_text(aes(label=Počet), vjust=-0.3, color="black", size=3.5) +
  scale_y_continuous(labels = scales::label_number()) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5), plot.subtitle = element_text(hjust = 0.5)) +
  labs(title = "Počet obchodních korporací podle právní formy",
       subtitle = "Ke dni 3. května 2022")

#Visualization
