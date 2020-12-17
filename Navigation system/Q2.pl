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
%-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
    read(Choos),nl,
    (Choos == 'yes' -> define(Spoint,Epoint); write('Give signel to go!!!'),nl,nl,nl,select_track(Epoint) ).

define(Spoint,Epoint):-
    write('Give the stations that issue happen in between!!!'),nl,
    write('Start station:'),nl,nl,
    read(Pspoint),nl,
    write('End Station: '),nl,nl,
    read(_),nl,
    solution(Spoint,Pspoint,Epoint).
    
solution(Spoint,Pspoint,Epoint):-
    route(Spoint,Pspoint,Route),
    write('Send message "Go" signal -> '),write(Spoint),write(' to '),write(Pspoint),write(' in '),write(Route),write(' route'),nl,nl,
    write('What is the problem: '),nl,
    write('1. dt'),nl,
    write('2. wp'),nl,
    write('3. ai'),nl,
    read(Prob),nl,
    write('   How long take for solve the problem: '),nl,
    write('1. Within 2 hours'),nl,
    write('2. 2 or above hours'),nl,
    write(' Enter the number of time(1 or 2)!!!!'),nl,
    read(Time),nl,
    solutions(Prob,Time,Sol),
    write('The solution is: '),nl,
    write(Sol),nl,nl,nl,
    select_track(Epoint).

select_track(Epoint):-
    write('oc,ws,tc,kx,ls stations are connected with differnt lines.'),nl,
    write('Train can change the track in those stattions.Do you want?'),nl,
    write('Yes or no'),nl,
    read(Track),nl,
    (Track == 'yes' -> find_track(Epoint); write('Go in the same track!!')).

find_track(Epoint):-
    write('Enter the station that want to change track:'),nl,nl,
    read(St),nl,
    route(St,Epoint,Route),
    write('New route is '),write(Route).

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