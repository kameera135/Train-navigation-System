/*DATABASE*/

%STATIONS
%Metropolitan
station(al, [metropolitan]). 				%aldgate
station(bs, [metropolitan]). 				%baker_street
station(fr, [metropolitan]). 				%finchley_road
station(ls, [metropolitan,central]). 		%liverpool_street
station(kx, [metropolitan,victoria]).		%kings_cross
%Central
station(bg, [central]).	 					%bethnal_green
station(cl, [central]). 					%chancery_lane
station(lg, [central]). 					%lancaster_gate
station(nh, [central]). 					%notting_hill_gate
station(tc, [central,northern]). 			%tottenham_court_road
%Victoria
station(br, [victoria]). 					%brixton
station(fp, [victoria]). 					%finsbur_park
station(vi, [victoria]). 					%victoria
%Bakerloo
station(ec, [bakerloo]). 					%elephant_and_castle
station(em, [bakerloo, northern]). 			%embankment
station(pa, [bakerloo]). 					%paddington
station(wa, [bakerloo]). 					%warwick_avenue
station(oc, [bakerloo,central,victoria]). 	%oxford_circus
%Northern
station(eu, [northern]). 					%euston
station(ke, [northern]). 					%kennington
station(ws, [northern,victoria]). 			%warren_street

%ADJACENT STATIONS
%bakerloo_line
adjacent_stations(wa,pa).  /*adjacent_stations(X, Y) can be interpreted as term(Atom, Atom).*/
adjacent_stations(pa,oc).
adjacent_stations(oc,em).
adjacent_stations(em,ec).

%central_line
adjacent_stations(nh,lg).
adjacent_stations(lg,oc).
adjacent_stations(oc,tc).
adjacent_stations(tc,cl).
adjacent_stations(cl,ls).
adjacent_stations(ls,bg).

%metropolitan
adjacent_stations(fr,bs).
adjacent_stations(bs,kx).
adjacent_stations(kx,ls).
adjacent_stations(ls,al).

%northern
adjacent_stations(eu,ws).
adjacent_stations(ws,tc).
adjacent_stations(tc,em).
adjacent_stations(em,ke).

%victoria
adjacent_stations(br,vi).
adjacent_stations(vi,oc).
adjacent_stations(oc,ws).
adjacent_stations(ws,kx).
adjacent_stations(kx,fp).

%PROBLEMS AND SOLUTIONS                             Problems in track
solutions(dt,1,'after the problem solve go!!').     %dt -> damaged track
solutions(dt,2,'Cancel train!!').                   %wp -> weather problem
solutions(wp,1,'after the problem solve go!!').     %ai -> another issue
solutions(wp,2,'Cancel train!!').
solutions(ai,1,'after the problem solve go!!').
solutions(ai,2,'Cancel train!!').
%----------------------------------------------------------------------------------------------------------------------------------------------
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
    (Choos == 'yes' -> define(Spoint,Epoint); train_permission1(Route) ).

define(Spoint,_):-
    write('Give the stations that issue happen in between!!!'),nl,
    write('Start station:'),nl,nl,
    read(Pspoint),nl,
    write('End Station: '),nl,nl,
    read(_),nl,
    solution(Spoint,Pspoint).
    
solution(Spoint,Pspoint):-
    route(Spoint,Pspoint,Route),
    write('Send message "Go" signal -> '),write(Spoint),write(' to '),write(Pspoint),write(' in '),write(Route),write(' route'),nl,nl,
    write('   What is the problem: '),nl,
    write('1. dt'),nl,
    write('1. wp'),nl,
    write('1. ai'),nl,
    read(Prob),nl,
    write('   How long take for solve the problem: '),nl,
    write('1. Within 2 hours'),nl,
    write('2. 2 or above hours'),nl,
    write('   Enter the number of time!!!!'),nl,
    read(Time),nl,
    solutions(Prob,Time,Sol),
    write('The solution is: '),nl,
    write(Sol),nl,
    (Sol == 'after the problem solve go!!' -> train_permission2(Route); !).


train_permission1(Route):-
    get_station(Route,3,St),
    count(Route,Co),
    (Co>3 -> write('Allow 2nd train to go to after 1st train go to '),write(St),write(' station.'); 
     (Co<3) -> write('1st train route is over and 2nd train allow to go.')).

train_permission2(Route):-
    count(Route,Co),
    (Co>3 -> write('Allow 2nd train to go to after 1st train go to '),write(St),write(' station.'); 
     (Co<3) -> write('1st train route is over and 2nd train allow to go.')).

adjacent(X,Y):- adjacent_stations(X,Y).
adjacent(X,Y):- adjacent_stations(Y,X).   

findAllStations(Line, ListOfStations):-
    findall(Station,(station(Station,NewLine), member(Line, NewLine)), ListOfStations).

sameline(Station1, Station2, Line):-
    station(Station1, Line1), 			/*Declares Station1 as the Atom of station. For Example: Station1 = station(al, ([metropilitan])). */
    station(Station2, Line2),			/*Declares Station2 as an atom of station.*/
    member(Line, Line1),      			/*Checks if Line is a member of Line1.*/
    member(Line, Line2).	  			/*Checks if Line is a member of Line2.*/

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
