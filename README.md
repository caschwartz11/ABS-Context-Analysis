# How Context Influences ABS Challenges
An analysis of over 30,000 MLB pitches investigating whether ABS challenge decisions are driven primarily by pitch accuracy or by game context.
![Overturned/Confirmed Locations](figures/README-figures/pos_over_conf.png)
## Overview
Automated Ball-Strike (ABS) was implemented at the beginning of the 2026 MLB season. It allows pitchers, catchers, and batters to challenge balls and called strikes. With a new technology comes a new strategy. Since managers and the bench are not allowed to help the challenger, what influences a player to challenge a call?
## Research Question
Are ABS challenges driven primarily by pitch accuracy or are they influenced by game context?
## Data
  This data comes from [Baseball Savant](https://baseballsavant.mlb.com/) and Statcast. There are over 6,000 challenged pitches and 30,000 pitches in total from the beginning of the season to June 1st. 
  Variables include: pitch location, challenge result, pitch type, count, inning, outs, strike zones, and base runners. 
## Methodology
  Baseball Savant's data classifies the pitches as balls and strikes, and by pitch type. Thus, analysis based on those traits is trivial. However, Savant also classifies pitches as "reasonable," meaning a player could reasonably challenge the pitch. Savant defines a reasonable challenge as a pitch that was called incorrectly, was within 3 inches of the strike zone and would gain at least .3 runs, or the pitch has an expected challenge rate of at least 20%. Unfortunately, the publicly assessiable data does not include labelled reasonable pitches, thus a function was implemented to find the data. 
  For probabilities of challenges, I added the challengeable pitches to normalize find the probability that a pitch would be challenged based on the context. 
## Key Figures
### Challenged and Unchallenged Pitches by Location
![Challenge Locations](figures/README-figures/pos_challenged_unchallenged.png)
This figure compares challenged and unchallenged pitches by location. The unchallenged but reasonable pitches are concentrated in the corners. The challenged pitches are more common on the bottom half of the plate, but there are a lot of reasonable unchallenged pitches on the top of the plate. 

### Confirmed and Overturned Pitches by Location
![Overturned/Confirmed Locations](figures/README-figures/pos_over_conf.png)
This figure compares challenged pitches by outcome and location. Most challenged pitches occur on the bottom half of the plate. Challenge outcomes appear to be distributed similarly across pitch locations, suggesting that location alone may not fully explain whether a challenge is confirmed or overturned.

### Distance from Zone by Day
![Distance from Zone](figures/README-figures/dist_from_zone.png)
This figure shows the distance from the edge of the strike zone by day, the daily average. and the overall average. I hypothesized that teams would become more accurate as they get more experience. The average daily distance from the strike zone edge is consistent through the season so far. Thus, the distance from the strike zone is not improving as the season progresses. This supports the conclusion that teams are challenging based on context over distance. 

### Challenge Frequency by Count
![Probability by Count](figures/README-figures/prob_count.png)
This figure shows the frequency of challenges by count (ball-strike). Players are most likely to challenge on a 3-2 count by 10%. Players are unlikely to challenge a 0-0 or 3-0 count. This further supports the conclusion that the context of the pitch determines if a player challenges it. 

### Challenge Frequency by Runners On
![Frequency Runners](figures/README-figures/prob_runners_on.png)
This figure shows the frequency of challenges by runners on base. Players are most likely to challenge a pitch when there are 3 runners on base. The probability increases as the number of runners on base increases. This supports the conclusion that the context is the determining factor of a challenge. 

## Key Findings
1. Challenges are not getting more accurate as the season progresses, at least so far.
2. Challenges are more likely to occur in later innings and with full counts.
3. Challenge accuracy does not seem to be determined by location (high, low, wide).

## Future Work
  The analysis of this data is from only the first two months of the 2026 MLB season. Repeating the analysis with a full regular season would allow trends observed here to be evaluated over a larger sample. Additionally, repeating with only postseason data will show if teams change strategies as games become more important. Since the postseason includes series results, it would also include more data on teams in elimination games. Further analysis could show which factor each organization considers the most important and which strategy is most effective. 
