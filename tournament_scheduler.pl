% Define the groups
grp(1, [team1, team2, team3, team4, team5]).
grp(2, [team6, team7, team8, team9, team10]).
grp(3, [team11, team12, team13, team14, team15]).
grp(4, [team16, team17, team18, team19, team20]).
grp(5, [team21, team22, team23, team24, team25]).
grp(6, [team26, team27, team28, team29, team30]).

% Collect all groups into a list
all_grps(AllGroups) :-
    findall(Group, grp(_, Group), AllGroups).

% Finds all valid team pairs from all groups,
% ensuring no team plays more than twice
all(ValidTeams) :-
    all_grps(AllGroups),
    findall((A, B), (
        member(Group, AllGroups),
        member(A, Group),
        select(A, Group, Rest),
        member(B, Rest),
        A @< B  % Avoid duplicates like (B, A)
    ), AllPairs),
    repeated(AllPairs, [], ValidTeams).

% Ensures each team appears in at most two pairs
repeated([], ValidTeams, ValidTeams).
repeated([(A, B) | Pairs], SortedTeams, ValidTeams) :-
    home(SortedTeams, A, CountHome),
    CountHome < 2,
    append(SortedTeams, [(A, B)], NewSortedTeams),
    repeated(Pairs, NewSortedTeams, ValidTeams).
repeated([(A, B) | Pairs], SortedTeams, ValidTeams) :-
    append(SortedTeams, [(B, A)], NewSortedTeams),
    repeated(Pairs, NewSortedTeams, ValidTeams).

% Counts the number of times a team appears in a list of pairs
home([], _, 0).
home([(A, B) | T], Team, CountHome) :-
    ( A = Team ; B = Team ),
    home(T, Team, Temp),
    CountHome is Temp + 1.
home([(A, B) | T], Team, CountHome) :-
    A \= Team, B \= Team,
    home(T, Team, CountHome).

% Generates a schedule of pairs for multiple days,
% assigning no more than 3 matches per day
schedule(PairsWithDays) :-
    all(AllPairs),
    random_permutation(AllPairs, Pairs),
    schedule_helper(Pairs, 1, [], PairsWithDays).

schedule_helper([], _, PairsWithDays, PairsWithDays).
schedule_helper([Pair | Pairs], CurrentDay, PairsWithDaysSoFar, PairsWithDays) :-
    pair_by_day(PairsWithDaysSoFar, CurrentDay, Count),
    Count < 3,
    done_day([Pair], CurrentDay, PairWithDay),
    append(PairsWithDaysSoFar, PairWithDay, SortedDays),
    schedule_helper(Pairs, CurrentDay, SortedDays, PairsWithDays).
schedule_helper([Pair | Pairs], CurrentDay, PairsWithDaysSoFar, PairsWithDays) :-
    pair_by_day(PairsWithDaysSoFar, CurrentDay, Count),
    Count >= 3,
    NextDay is CurrentDay + 1,
    schedule_helper([Pair | Pairs], NextDay, PairsWithDaysSoFar, PairsWithDays).

% Counts the number of pairs scheduled on a given day
pair_by_day([], _, 0).
pair_by_day([(_, _, Day) | T], Day, Count) :-
    pair_by_day(T, Day, Temp),
    Count is Temp + 1.
pair_by_day([(_, _, D) | T], Day, Count) :-
    Day \= D,
    pair_by_day(T, Day, Count).

% Tags a pair with the day number
done_day([], _, []).
done_day([(A, B)], Day, [(A, B, Day)]).
