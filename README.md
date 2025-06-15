# Team Scheduler (Prolog)

A simple tournament match scheduler written in Prolog for **CA208** coursework.

## Features

- Groups teams and generates valid matchups.
- Ensures each team plays at most twice.
- Distributes matches across multiple days (max 3 games per day).

## Usage

Run with [SWI-Prolog](https://www.swi-prolog.org/):

```prolog
?- [tournament_scheduler].
?- schedule(Schedule).
