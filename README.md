# Geopolitical News Sentiment and Financial Market Volatility

This repository contains the code and processed datasets used in the study Sentiment and Volatility in Financial Markets: A Review of BERT and GARCH Applications during Geopolitical Crises
Authored by Domenica Mino and Cillian Williamson.

## 🧠 Project Overview
This project investigates the impact of media sentiment regarding the Russia-Ukraine war on U.S. stock market volatility. Using Natural Language Processing (NLP) and econometric modeling, it demonstrates how sentiment extracted from news headlines correlates with financial instability, especially in times of geopolitical tension.

The analysis integrates:

BERT for fine-tuned sentiment extraction on financial headlines.

OLS for initial linear modeling.

GARCH(1,1) with Student-t distribution for volatility modeling.

Control Variables including VIX, bond yield, OFR, and EPU indices.

## 🧪 Methodology
Data Collection & Cleaning
Over 10,000 U.S. financial headlines (Jan 1 – Jul 17, 2024) were scraped and cleaned using Python (NLTK, RE, BeautifulSoup).

## Sentiment Analysis
Headlines were tokenized and classified using a fine-tuned BERT model. The sentiment score was defined as:

java
Copy
Edit
Sentiment Score = Logit_positive - Logit_negative
Econometric Modeling

OLS Regression tested the linear relationship between sentiment and market returns.

GARCH(1,1) modeled the volatility of S&P 500 returns, incorporating residual dynamics.

A Student-t distribution was employed to account for fat tails in return distributions.

## 📈 Key Findings
A significant negative correlation between negative sentiment and S&P 500 volatility was found (p = 0.0016).

VIX also significantly predicts volatility (p = 0.0094).

Traditional indicators (OFR, Bond, EPU) were not statistically significant in this crisis context.

The GARCH model captured volatility clustering and improved robustness via t-distribution.

## 🔧 Dependencies
Python:
transformers
pandas, numpy
matplotlib, seaborn
nltk, bs4, re

R:
rugarch, lmtest, car, sandwich, ggplot2

