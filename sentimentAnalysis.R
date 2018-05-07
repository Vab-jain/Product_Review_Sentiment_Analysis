##########  BASIC SENTIMENT ANALYSIS USING R ############

# setting up the libraries
library("dplyr")
library("tidytext")
library("tidyr")

# retrieving the train data which is the reviews of products from amazon
setwd("~/Documents/R-Assignments/R-Project")
reviews<-read.csv("Reviews.csv")

n = 50000

# getting the essential information from the data set
new_reviews<-reviews[1:n,c("Score","Text")]
# new_reviews

# extracting the reviews data and creating a vector
string<-lapply(new_reviews[1:n,c("Text")],as.character)

# string

# creating a data frame for the reviews so that it can be tokenized
text_df<-data_frame(line = 1:n, Text = string)

text_df

print("unnest_tokens")
tidy_reviews<-text_df %>% 
		unnest_tokens(word,Text)

# get the stop words that can be removed 
# in order extract effective information
data(stop_words)

print("removing stop words")
# remove the stop words
tidy_reviews<-tidy_reviews %>% anti_join(stop_words)

print("counting the frequency of each word")
# count the frequency of each word
count_review<-tidy_reviews %>%
  count(word, sort = TRUE)

m<-sum(count_review[,"n"])
# m<-sum(tidy_reviews[,"n"])

print("getting the positive sentiments")
# now calculating the sentiments of each word

tidy_reviews<-tidy_reviews %>% inner_join(get_sentiments("bing")) %>%
  count(word,sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative)

# bing<-get_sentiments("bing") %>% 
#   filter(sentiment == "positive")

# tidy_reviews %>% inner_join(bing) %>% count(word, sort = TRUE)

tidy_reviews

sum(tidy_reviews[,"sentiment"])*5/m