library(tidyverse)


state_enc_rate <- read.csv("state.level.enc.rate.csv")

view(state_enc_rate)

#Get rid of uneccessary columns
state_enc_rate_clean <- state_enc_rate %>%
  select(
    -query.volume.state #not needed for analysis
  )

view(state_enc_rate_clean)

#filter to just Idaho
state_enc_rate_clean_filtered <- state_enc_rate_clean %>%
  filter(
    state == "Idaho",
    
  )

view(state_enc_rate_clean_filtered)

#get rid of species with no encounter rate
ID_enc_rate <- state_enc_rate_clean_filtered %>%
  filter(encounter.state.normalized!=0
  )

#get ride of encounter rates below 50
ID_enc_rate <- ID_enc_rate %>%
  filter(encounter.state.normalized > 50)

view(ID_enc_rate)

#Pull passerines from this list
passerine_enc_rate <- ID_enc_rate %>%
  filter(common.name %in% c("American robin", "bank swallow", "black-billed magpie", "black-headed grosbeak", "Brewer's blackbird", "Bullock's oriole", "Cassin's finch", "Cassin's vireo", "cedar waxwing", "cliff swallow", "dark-eyed junco", "dusky flycatcher", "European starling", "evening grosbeak", "Hammond's flycatcher", "house finch", "laxuli bunting", "MacGillivray's warbler", "mountain chickadee", "northern rough-winged swallow", "olive-sided flycatcher", "pine siskin", "red crossbill", "red-winged blackbird", "sage thrasher", "song sparrow", "western kingbird", "western tanager", "western wood-pewee", "willow flycatcher", "yellow warbler"))