# Matlab Simulation

A simulation in Matlab by Dotdash32

## Premise

Simulate the first 100 BB players and see how the environment of Brain Burst changed over time.


## Simulation

The siimulation is broken into two main phases:

1. Creation of the first 100 players and

2. Repeated rounds of duels and BP exchanges

### Creation of player  - `makePlayer(parent, parentGen, round)`

* Basic code to create a new player with minimum inputs.

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

### Duels - `duel(players, p1, p2, rounds)`
Function to simulate a duel between two players, `p1` (Player 1) and `p2` (Player 2) contained within the `players` struct.  `rounds` is taken as an input for record keeping.

Player 1 is always considered the challenger, and loses a Burst Point automatically upon beginning the duel.

>It's possible for someone to have 1 BP, accelerate, be at zero, and not actually die, but it seems like the volume supports this as an option

The sweep area on the color circle between the two players is then determined.  This is defined as the area between the colors as *theta* and thesaturations as *rho*.  This creates 