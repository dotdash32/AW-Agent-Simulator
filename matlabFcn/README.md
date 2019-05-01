# Matlab Simulation

A simulation in Matlab by Dotdash32

Notes on the construction and format of the simulation, in hopes of making the code simpler to understand.  
> Personal notes are in quotes, like this. 
> My own way of inserting comments about how the simulation has run in the past.

## Premise

Simulate the first 100 BB players and see how the environment of Brain Burst changed over time.

What key variables define how successive Brain Burst is compared to Accel Assault or Cosmos Corrupt?  The primary factors of investigation are

* Birth rate - how fast do players create new players with 100 BP

* Duel rate - how many and how often do people duel?  Can we simulate a way to factor in human factors like "winning streaks" or people being more conservative as they lose BP?

* Learning rate - how fast do people learn the game, and is there an inherent curve that is almost impossible to beat at any stage of the game?

* Inherent talent - how much gradation of talent/skill is there and at what rate do people learn and become better at fighting?


## Simulation

The siimulation is broken into several  phases:

1. Creation of the first 100 players

2. Repeated rounds of :

    * Duels  
        1. Select a player who is alive at random
        2. Check to make sure they haven't already dueled this round
        3. Select another player who is alive at random
        4. Check they haven't dueled and aren't the first person
        5. Initiate a duel, evaulate win condition, transfer BP
            *  More details in Duel section 
    * Births - Potentially introduce new players
        * Details in MakeBabes section
    * Tracking - print out data to track the simulation over time - TODO
        * Implement way to track interesting characters automatically?
        * Report BP amounts, number of players
        * Create graphs


### Creation of player  
`makePlayer(parent, parentGen, round)`

Basic code to create a new player with minimum inputs.

* `parent` is the numerical index of the parent player.  Zero if first generation (Originator)

* `parentGen` is the numerical generation of the parent player.  If player is originator, this value is ignored.  Split so that the entire player struct doesn't need to be fed into this function.

* `round` is the round number for recording purposes.

#### Format of player struct
Each player is assigned a number that is their index in the struct array.  As players die, their index remains the same.
* `players.gen` is the generation of the player.  Starting at 1 for Originators, incrementing as more generations are born.  Not changed throughout the simulation.
* `players.record` is a cell array of every event that has happened to the player.  The upper row (record{1,:}) is the round number in which the event happened.  The lower row (record{2,:}) is a text string that describes the event (creation, duel, death, etc)
* `players.color` and `players.sat` are the two components that describe a player's position on the color wheel in a poloar, *theta* and *rho*, style manner.  Color is a number between 1 and 360, the angular position of the color.  Saturation is the color purity, from 0 to 100.  These values are used to calculate experience gain.
* `players.rounds` is an array of when the player was active.  It has the form [startRound, endRound], where endRound = 0 if the player is still alive.
* `players.lvl` is the player's level, starting at 1 at birth and levelling up over time using Burst Points.
* `players.kid` is the number of child players the player has created.  For Originators, once they reach level 2, they have no limitation on the number of offspring they can have.  For generations 2 and above, only a single child can be produced.
* `players.BP` is the number of Burst Points a player has.  It begins at 100 and will increase or decrease as the player accelerates or duels.
* `players.exp` is the learned experience a player has.  While it is randomly generated at the start, it increases with duels and is factored into the win probability.  This is ment to simulate real life experience, the so called "perfect match" avatar, versus the person who can barely play.

Color, Saturaiton, and Experience are randomly assigned using MATLAB's `randi()` feature.  The range of starting experience is a major variable in how the game continues   
> In my experience, even with only 3 levels of base experience, only the top tier will be able to survive for any length of time.  It might be possible to more easily follow players by increasing the range of allowed base experience, and then tracking everyone who has the max rating at creation.

### Duels 
`duel(players, p1, p2, rounds)`

Function to simulate a duel between two players, `p1` (Player 1) and `p2` (Player 2) contained within the `players` struct.  `rounds` is taken as an input for record keeping.

Player 1 is always considered the challenger, and loses a Burst Point automatically upon beginning the duel.

>It's possible for someone to have 1 BP, accelerate, be at zero, and not actually die, but it seems like the light novels supports this as an option

The swept area on the color circle between the two players is then determined.  This is defined as the area between the colors as *theta* and the saturations as *rho*.  This creates a sector of a donut, and the percent coverage is obtained by dividing by the total area of the circle.  In this manner, an experience gain modifier is created based on percieved difference in matchup.

The above calculation relies on the idea that colors far away on the color wheel will not be as good of a matchup and will therefore be a more difficult duel and cause the player to learn more.  In a similar vein, having a high difference in saturation will be a different manner of fighting as well.  The logic is that if you know how you fight, then you would learn less from people of a similar section on the color wheel because comparative abilities would be more similar.

To calculate the win percentage, each player's experience is multiplied by a random number generated by `rand(1)` to get a single number ranging from 0-1.  In this manner, the largest factor in whether or not someone wins is the amount of experience they have, along with a random chance to account for potential upsets.  In this manner, most duels are decided by skill matchups while there are a few upsets that go against the grain.  

The winner of the duel is the player who has the higher chance calculated above.  A duel is considered a draw if the winning chances are equal.

> It might be worth adding a tolerance to "equal," since matlab is calculating too may decimals for to ever be exactly exactly equal.  This wouldn't be hard, I just haven't coded it yet.

Burst points are redistributed based on the levels of the players.  The formula is 10*(1+levelDifference) if the winner is lower level, 10/(1+levelDifference) if the winner is higher level, and 10 if they are the same level.  The winner always gains points, the loser always loses points.  This scheme is supposed to even out the loss that a younger lower level player would face when they encounter a more experienced veteran player.  In the second case, the number of BP must be rounded, since there are no fractional Burst Points.

>Destination on Discord has created several other models, but the above model is the one I'm going to implement because it has the most supporting evidence from the light novels, and would prevent younger players from immediately dying.

A record of the duel is placed in each `players.record` field of the struct, with round number on the top row and a text description in the bottom.  The result (win/loss/draw), current level, and opponent and their level are recorded.

### Eliminating Players
`killEm(players, rounds)`