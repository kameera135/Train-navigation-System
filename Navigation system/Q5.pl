/*Database*/
%STATIONS.
station(bg, [central]).	 					%bethnal_green
station(cl, [central]). 					%chancery_lane
station(lg, [central]). 					%lancaster_gate
station(nh, [central]). 					%notting_hill_gate

station(br, [victoria]). 					%brixton
station(fp, [victoria]). 					%finsbur_park
station(vi, [victoria]). 					%victoria
station(kx, [victoria]).		            %kings_cross

station(eu, [northern]). 					%euston
station(ke, [northern]). 					%kennington
station(ws, [northern,victoria]). 			%warren_street
station(tc, [northern]). 			        %tottenham_court_road

%ADJACENT STATIONS.
%in central route
adjacent_stations(bg,cl).
adjacent_stations(cl,lg).
adjacent_stations(lg,nh).

%in victoria route
adjacent_stations(br,fp).
adjacent_stations(fp,vi).
adjacent_stations(vi,kx).

%in northen route
adjacent_stations(eu,ke).
adjacent_stations(ke,ws).
adjacent_stations(ws,tc).

%PROBLEMS AND SOLUTIONS                             Problems in track
solutions(dt,1,'after the problem solve go!!').     %dt -> damaged track
solutions(dt,2,'Cancel train!!').                   %wp -> weather problem
solutions(wp,1,'after the problem solve go!!').     %ai -> another issue
solutions(wp,2,'Cancel train!!').
solutions(ai,1,'after the problem solve go!!').
solutions(ai,2,'Cancel train!!').
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
start:-
    write('Train navigation system!!!'),nl,nl,nl,
    write('Enter the first station: '),nl,nl,
    read(Spoint),nl,
    write('Enter the end station:'),nl,nl,
    read(Epoint),nl,
    process(Spoint,Epoint).

process(Spoint,Epoint):-
    route(Spoint,Epoint,Route),
    write('List of stations are '),write(Route),nl,nl,
    write('   Is any problem between '),write(Spoint),write(' and '),write(Epoint),nl,
    write('1. Yes'),nl,
    write('2. No'),nl,
    write('   Enter yes or no!!'),nl,nl,
    read(Choos),nl,
    (Choos == 'yes' -> define(Spoint,Epoint); train_permission(Route,Spoint) ).

define(Spoint,Epoint):-
    write('Give the stations that issue happen in between!!!'),nl,
    write('Start station:'),nl,nl,
    read(Pspoint),nl,
    write('End Station: '),nl,nl,
    read(_),nl,
    solution(Spoint,Epoint,Pspoint).
    
solution(Spoint,Epoint,Pspoint):-
    route(Spoint,Pspoint,Route1),
    route(Spoint,Epoint,Route),
    write('Send message "Go" signal -> '),write(Spoint),write(' to '),write(Pspoint),write(' in '),write(Route1),write(' route'),nl,nl,
    write('   What is the problem: '),nl,
    write('1. dt'),nl,
    write('2. wp'),nl,
    write('3. ai'),nl,
    read(Prob),nl,
    write('   How long take for solve the problem: '),nl,
    write('1. Within 2 hours'),nl,
    write('2. 2 or above hours'),nl,
    write('   Enter the number of time!!!!'),nl,
    read(Time),nl,
    solutions(Prob,Time,Sol),
    write('The solution is: '),nl,
    write(Sol),nl,
    (Sol == 'after the problem solve go!!' -> train_permission(Route,Spoint); !).


train_permission(Route,Spoint):-
    get_station(Route,2,St),
    write('Go to '),write(St),write(' station from one by one station.'),nl,
    write('   Now train can change the direction of track. want it?'),nl,
    write('1. Yes'),nl,
    write('2. No'),nl,
    read(Inter),nl,
    (Inter == 'yes' -> interchahge(Spoint,St); write('Go through the track!! and 2nd train can come in the route.')).

interchahge(Spoint,St):-
    write('2nd train have to stop'),nl,
    route(St,Spoint,Route),
    write('1st train come under '),write(Route),write(' route'),nl,nl,
    write('After 1st train come to the '),write(Spoint),write(' 2nd train can go!!').

adjacent(X,Y):- adjacent_stations(X,Y).
adjacent(X,Y):- adjacent_stations(Y,X).   

findAllStations(Line, ListOfStations):-
    findall(Station,(station(Station,NewLine), member(Line, NewLine)), ListOfStations).

route(Station1, Station2, Route):-							 	/*Main rule for declaring the route between two stations*/
    route1( Station1, Station2, [], RouteReturn),
    reverse([Station2|RouteReturn],Route).

route1(Station1, Station2, TempRoute, Route):- 					/*Main rule for finding route between two stations*/
    adjacent(Station1, Station2),
    \+member(Station1, TempRoute),
    Route = [Station1|TempRoute].

route1(Station1, Station2, TempRoute, Route):-					/*Recursive rule */
    adjacent(Station1,Next),
    Next \== Station2,
    \+member(Station1, TempRoute),
    route1(Next, Station2, [Station1|TempRoute], Route).

routeTime(Station1, Station2, Route, RouteTime):-               /*routeTime is called a user called method.*/
	route(Station1, Station2, Route),				            /*route(Station1, Station2, Route) inherits the route algorithm above.*/
	length(Route, Time),						              	/*Length(Route, Time) returns length of the route and the time.*/
    RouteTime is (Time -1) * 4.						            /*Returns the time it takes to travel.*/

get_station([H|_],0,H):-!.   
get_station([_|T],N,H):-
    N>0,
    N1 is N-1,
    get_station(T,N1,H).

count([],0).
count([_|T], X) :- count(T, X1), X is X1 + 1.
