# How Context Influences ABS Challenges
An analysis of over 30,000 MLB pitches investigating whether ABS challenge decisions are driven primarily by pitch accuracy or by game context.
![Overturned/Confirmed Locations](figures/README-figures/pos_over_conf.png)
## Highlights
* 6,000+ challenged pitches analyzed
* MATLAB analysis using Baseball Savant data
* Recreated Baseball Savant's "reasonable pitch" classification
* Found challenge decisions depend on both pitch accuracy and game context
## Full Report
The complete paper can be found [here](ABS_Context_Analysis.pdf).
## Overview
Automated Ball-Strike (ABS) was implemented at the beginning of the 2026 MLB season. It allows pitchers, catchers, and batters to challenge balls and called strikes. With a new technology comes a new strategy. Since managers and the bench are not allowed to help the challenger, what influences a player to challenge a call?
## Research Question
**Are ABS challenges driven primarily by pitch accuracy, or are they influenced by game context?**
## Data
Source: [Baseball Savant](https://baseballsavant.mlb.com/)
* 6,000+ challenged pitches
* 25,000+ challengeable pitches
* 10 variables collected
* March 25 - June 10
## Methodology
  Baseball Savant's data classifies the pitches as balls and strikes, and by pitch type.  Savant also classifies pitches as "reasonable," meaning a player could reasonably challenge the pitch. Savant defines a reasonable challenge as a pitch that was called incorrectly, was within 3 inches of the strike zone and would gain at least .3 runs, or the pitch has an expected challenge rate of at least 20%. Unfortunately, the publicly accessible data does not include labeled reasonable pitches; thus, a function was implemented to find the data. 
  For probabilities of challenges, I added the challengeable pitches to normalize and find the probability that a pitch would be challenged based on the context. 
## Key Finding
* Players first evaluate pitch location before considering a challenge.
* Game context significantly influences whether a challenge is used.
* Challenge accuracy did not improve over the first two months of the 2026 season.
* Distance from the strike zone alone does not explain challenge outcomes.

## Key Figures
### Challenged and Unchallenged Pitches by Location
![Challenge Locations](figures/README-figures/pos_challenged_unchallenged.png)
The unchallenged but reasonable pitches are concentrated in the corners. The challenged pitches are more common on the bottom half of the plate, but there are a lot of reasonable unchallenged pitches on the top of the plate. 

### Confirmed and Overturned Pitches by Location
![Overturned/Confirmed Locations](figures/README-figures/pos_over_conf.png)
Most challenged pitches occur on the bottom half of the plate. Challenge outcomes appear to be distributed similarly across pitch locations, suggesting that location alone may not fully explain whether a challenge is confirmed or overturned.

### Distance from Zone by Day
![Distance from Zone](figures/README-figures/dist_from_zone.png)
I hypothesized that teams would become more accurate as they get more experience. The average daily distance from the strike zone edge is consistent through the season so far. Thus, the distance from the strike zone is not improving as the season progresses. This supports the conclusion that teams are challenging based on context over distance. 

### Challenge Frequency by Count
![Probability by Count](figures/README-figures/prob_count.png)
Players are most likely to challenge on a 3-2 count by 10%. Players are unlikely to challenge a 0-0 or 3-0 count. This further supports the conclusion that the context of the pitch determines if a player challenges it. 

### Challenge Frequency by Runners On
![Frequency Runners](figures/README-figures/prob_runners_on.png)
Players are most likely to challenge a pitch when there are 3 runners on base. The probability increases as the number of runners on base increases. This supports the conclusion that the context is the determining factor of a challenge. 

## Future Work
* Analyze the remainder of the 2026 regular season
* Compare regular season and postseason strategies
* Compare challenge strategies across organizations
* Extend the analysis to future MLB seasons

## Contact
If you have questions about this project or would like to discuss the analysis, feel free to connect with me on [LinkedIn](www.linkedin.com/in/carly-schwartz-0b6263337)
