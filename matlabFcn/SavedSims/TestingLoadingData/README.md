# Brain Burst Simulation: TestingLoadingData 

Graphical Trends in the Simulation:

![Trends Graphs](trendsPic.png)

--- 

## Parameters 
### Global: 

Seed: 1 

Rounds to count as a Survivor: 2 

--- 

### makePlayer (Player Creation Function): 

Experience Version: Discrete (continuous or discrete)

Possible Experience Range: 2 to 11(discrete integer values only) 

Maximum possible Experience: 8 (continuous distrobution) 

Beta Distrobution Factors for Saturation: A = 3.75 B = 3.50 

Beta Distrobution Factors for Luminance: A = 6.00 B = 8.00 

--- 

### duel (Individual Duels): 

Modifier for experience gain: 1.50e-01 

Tolerance for Draws: 7.00e-05 

Point Transfer Function if Winner is higher levelled: @(lvlDiff)round(20/(1+lvlDiff)) 

Point Transfer Function if Winner is lower levelled: @(lvlDiff)(20*(1+lvlDiff)) 

Points to tranfer if both player are of equal level: 50 

Points to transfer in a draw: -1

Level Contribution Function to Win Chance: @(lvl)lvl.^3 

--- 

### killEm (Eliminate Players):

None here yet :(

--- 

### lvlUp (Level Up Players) 

Points needed for each Level:

|Level|1 -> 2|2 -> 3|3 -> 4|4 -> 5|5 -> 6|6 -> 7|7 -> 8|8 -> 9|9 -> 10|
|---|---|---|---|---|---|---|---|---|---|
|Points|301|401|601|901|1501|3001|6001|10001|Undefined|

Safety Margin Multiplier: @()1.7

--- 

### makeBabes (Create Gen2+ Players)

Chance of Kid Function: @(rounds,lvl,gen)randi(floor(rounds/20)+1,1) 

--- 

### Pure Colors (Easy to follow Players) 

Color Values (HSL): 

|King |Color|Saturation|Luminance|
|---|---|---|---|
| Red | 3 | 100 | 50 |
| Yellow | 63 | 100 | 50 |
| Green | 123 | 100 | 50 |
| Blue | 243 | 100 | 50 |
| Purple | 278 | 100 | 37 |
| White | 183 | 3 | 100 |

Experience of each Pure Color: 15.00

--- 

