Program Booking_systen;
uses crt,dos{,systilus};
type 	nametype=string[3];
		datetype=string[8];
		timetype=string[4];
		passwordtype=string[6];
        roomtype=string[3];

Const   max=50;
		printtime=5;
		max_period_no=10;

Var
	booklist,teacherlist,roomlist,adminlist:text;
	i,j,c,opt_int,code,pos,l,m,n:integer;
	opt:string;
	name_arr,admin_name_arr:array[1..max] of nametype;
	password_arr,admin_password_arr:array[1..max] of passwordtype;
	room_arr:array[1..max] of roomtype;
	date_arr:array[1..max] of datetype;
	start_arr,end_arr:array[1..max] of timetype;
	t_name,t_admin_name,t_password,t_admin_password,t_room,t_date,t_start,t_end:string;
	this_year,this_month,YY:integer;
	calendar:array[1..6,1..7] of integer;
	x,y,z,x2,y2:array[1..max] of integer;
	monthday:array[1..12] of integer;
	month:array[1..12] of string;
	YYYY,MM,DD,WD:word;
    weekname:array[0..6] of string;
	Hour,Min,Sec,HSec:word;
    line_no:array[1..max] of string;
    period_start_no:array[1..max] of string;
    period_end_no:array[1..max] of string;
	month_code:array[1..12] of integer;
	not_avail_day:array[1..max] of datetype;
	not_avail_day_no:integer;
    syyt,o,p,q,r:string;
	current_room_no:integer;

Function break(t:string):boolean;
var
	temp:boolean;
Begin
	temp:=false;
	if (t='') or (t='x') or (t=' ') then temp:=true;
	break:=temp;
end;

Function cap(target:string):string;
var c:integer;
Begin
	for c:=1 to length(target) do
		if (target[c] >='a') and (target[c]<='z') then target[c]:=chr(ord(target[c])-32);
	cap:=target;
end;

Procedure date_to_format (target:string);
Begin
	val(copy(target,1,4),l,code);
	val(copy(target,5,2),m,code);
	val(copy(target,7,2),n,code);
end;

Procedure time_to_format (target1,target2:string);
Begin
	o:=copy(target1,1,2);
	p:=copy(target1,3,2);
	q:=copy(target2,1,2);
	r:=copy(target2,3,2);
end;

Procedure read_teacher;
Begin
	reset(teacherlist);
	i:= 0;
	while not eof(teacherlist) do
	begin
		i:= i+1;
		readln(teacherlist,name_arr[i],password_arr[i]);
	end;
	close(teacherlist);
End;

Function find_teacher(target:string):boolean;
var found:boolean;
    temp_list:array[1..max] of nametype;
Begin
	found:=false;
	reset(teacherlist);
	j:=0;
	while not eof(teacherlist) and (not(found)) do
	begin
		j:=j+1;
		readln(teacherlist,temp_list[j]);
		if (temp_list[j]=target) then found:=true;
	end;
	close(teacherlist);
	find_teacher:=found;
end;

Procedure print_teacher;
Begin
	read_teacher;
	writeln('Print registered teacher...');
	for c:=1 to i do
	begin
		writeln(chr(195),' ',name_arr[c]);
		{sleep(printtime);}
	end;
end;

Function valid_teacher(target:string):boolean;
Var temp:boolean;
	counter:integer;
Begin
	temp:=true;
	if length(t_name)<>3 then temp:=false;
	for counter:=1 to length(target) do
	begin
		if (target[counter]<'A') or (target[counter]>'z') then temp:=false;
		if (target[counter]>'Z') and (target[counter]<'a') then temp:=false;
	end;
	valid_teacher:=temp;
end;

Procedure add_teacher;
var ans:string;
Begin
	clrscr;
	writeln('Administrator -> add teacher');
	print_teacher;
	write('Input teacher initial that you want to register: ');
	readln(t_name);
	t_name:=cap(t_name);
	while (not(valid_teacher(t_name)) or find_teacher(t_name))  and not(break(t_name))do
	begin
		if find_teacher(t_name) then writeln('Duplication occurs!Please enter the teacher again.')
		else writeln('You should input 3 letters only e.g.ABC');
		write('Input teacher initial that you want to register: ');
		readln(t_name);
		t_name:=cap(t_name);
	end;
	if not(break(t_name)) then
	begin
		write('Set the password(length:6): ');
		readln(t_password);
		while (length(t_password)<>6) and (not(break(t_password))) do
		begin
			writeln('You should input 6 letters or numbers only e.g.ABC');
			write('Set the password: ');
			readln(t_password);
		end;
		if not(break(t_password)) then
		begin
			writeln('The record is as following: ');
			writeln('Teacher initial:', t_name);
			writeln('Password:', t_password);
			writeln('Input Yes to confirm.');
			readln(ans);
			if cap(ans)='YES' then
			begin
				read_teacher;
				name_arr[j+1]:=cap(t_name);
				password_arr[j+1]:=t_password;
				rewrite(teacherlist);
				for c:=1 to j+1 do
					writeln(teacherlist,name_arr[c],password_arr[c]);
				close(teacherlist);
				writeln('Added.');
			end 
			else writeln('Cancelled.');
		end;
	end;
	writeln('Enter to continue.');
	readln;
end;

Procedure read_room;
Begin
	reset(roomlist);
	j:=0;
	while not eof(roomlist) do
		begin
			j:=j+1;
			readln(roomlist,room_arr[j]);
		end;
	close(roomlist);
end;

Procedure read_room_2;
Begin
	reset(roomlist);
	j:=0;
	while not eof(roomlist) do
		begin
			j:=j+1;
			readln(roomlist,line_no[j]);
		end;
	close(roomlist);
end;

Function find_room(target:string):boolean;
var temp:boolean;
    temp_list:roomtype;
Begin
	temp:=false;
	reset(roomlist);
	j:=0;
	while not eof(roomlist) and (not(temp)) do
		begin
			j:=j+1;
			readln(roomlist,temp_list);
			if (temp_list=target) then temp:=true;
		end;
	close(roomlist);
	find_room:=temp;
end;

Procedure print_room;
Begin
	read_room;
	current_room_no:=j;
	writeln('Print registered room...'); 
	for c:=1 to j do
	begin
		line_no[c]:=room_arr[c];
		writeln('Line',c,' ',room_arr[c]);
		{sleep(printtime);}
	end;
end;

Procedure print_room_2;
Begin
	read_room;
	current_room_no:=j;
	writeln('Print registered room...'); 
	for c:=1 to current_room_no do
	begin
		line_no[c]:=room_arr[c];
		writeln(chr(195),' ',room_arr[c]);
		{sleep(printtime);}
	end;
end;

Procedure add_room;
var ans:string;
Begin
	clrscr;
	writeln('Administrator -> add room');
	print_room_2;
	write('Input the room you want to register: ');
	readln(t_room);
	
	while find_room(t_room) and not(break(t_room)) do
	begin
		writeln('Duplication occurs!Please enter the room again.');
		write('Input the room that you want to add: ');
		readln(t_room);
	end;
	if (not(break(t_room))) then
	begin
		writeln('The record is as following: ');
		writeln('Room:', t_room);
		writeln('Input Yes to confirm.');
		readln(ans);
		if cap(ans)='YES' then 
		begin
			room_arr[current_room_no+1]:=t_room;
			rewrite(roomlist);
			for c:=1 to current_room_no+1 do
				writeln(roomlist,room_arr[c]);
			close(roomlist);
			writeln('Added.');
		end 
		else writeln('Cancelled.');	
	end;
	writeln('Enter to continue.');
	readln;
	
end;

Procedure delete_teacher;
var ans:string;
Begin
	clrscr;
	print_teacher;
	
	write('Input the teacher initial that you want to delete: ');
	readln(t_name);
	while (not(find_teacher(t_name)) or (length(t_name)<>3)) and not(break(t_name)) do 
	begin
		if (length(t_name)<>3) then writeln('You should input 3 letters only e.g.ABC')
		else writeln('Teacher name does not exist!');
		write('Input the teacher initial that you want to delete: ');
		readln(t_name);
		t_name:=cap(t_name);
	end;
	if not(break(t_name)) then
	begin	
		writeln('The record that you want to delete is as following: ');
		writeln('Teacher initial:', t_name);
		writeln('Input Yes to confirm.');
		readln(ans);
		if cap(ans)='YES' then 
		begin
			read_teacher;
			for c:=j to i-1 do 
			begin
				name_arr[c]:=name_arr[c+1];
				password_arr[c]:=password_arr[c+1];
			end;
			rewrite(teacherlist);
			for c:=1 to i-1 do
				writeln(teacherlist,name_arr[c],password_arr[c]);
			close(teacherlist);
			writeln('Deleted.')
		end 
		else writeln('No record is deleted.');	
	end;
	
	writeln('Enter to continue.');
	readln;
end;

Procedure delete_room;
var ans:string;
Begin
	clrscr;
	print_room_2;
	
	write('Input the room you want to delete: ');
	readln(t_room);
	while not(find_room(t_room)) and not(break(t_room))  do 
	begin
		if not(find_room(t_room)) then writeln('Room number does not exist!')
			else writeln('You should input 3 number only e.g.201');
			write('Input the room you want to delete: ');
			readln(t_room);
	end;
	
	if not(break(t_room)) then
	begin		
		writeln('The record that you want to delete is as following: ');
		writeln('Room:', t_room);
		writeln('Input Yes to confirm.');
		readln(ans);
		if cap(ans)='YES' then 
		begin
			for c:=j to current_room_no-1 do
			room_arr[c]:=room_arr[c+1];
			rewrite(roomlist);
			for c:=1 to current_room_no-1 do
				writeln(roomlist,room_arr[c]);
			close(roomlist);
			writeln('Deleted.');
		end 
		else writeln('No record is deleted.');	
	end;
	
	writeln('Enter to continue.');
	readln;
end;

Procedure read_book_list;
Begin
	reset(booklist);
	i:= 0;
	while not eof(booklist) do
		begin
			i:= i+1;
			readln(booklist,name_arr[i],room_arr[i],date_arr[i],start_arr[i],end_arr[i]);
		end;
    close(booklist);
end;

Function valid_date(target:datetype):boolean; {date format: YYYYMMDD }
Var temp:boolean;
	a,b,c:integer;
Begin
	temp:=true;
	val(copy(target,1,4),a,code);
	val(copy(target,5,2),b,code);
	val(copy(target,7,2),c,code);
	if (a mod 4=0)and(a mod 100<>0) or (a mod 400=0) then monthday[2]:=29;
	if (a<YYYY) or ((a=YYYY) and (b<MM)) or ((a=YYYY) and (b=MM) and (c<DD)) then
		temp:=false;
	if (b>12) or (b<1) or (c>monthday[b]) or (c<1) then
		temp:=false;
	valid_date:=temp;
end;

Function valid_time(target:timetype):boolean;
Var temp:boolean;
	code:integer;
	a,b:integer;
Begin
	temp:=true;
	val(copy(target,1,2),a,code);
	val(copy(target,3,2),b,code);
	if (a<8) or (a>18) then temp:=false;
	if (b<0) or (b>59) then temp:=false;
	if (a=18) and (b=0) then temp:=true;
	valid_time:=temp;
end;

Function fin_valid_time(st,en:timetype):boolean;
Var temp:boolean;
	d,e,f,g:integer;
Begin
	temp:=true;
	val(copy(st,1,2),d,code);
	val(copy(st,3,2),e,code);
	val(copy(en,1,2),f,code);
	val(copy(en,3,2),g,code);
	if (f<d) then temp:=false;
	if (f=d) and (g<e) then temp:=false;
	if (d=18) or ((f=18)and(g>0)) then temp:=false;
    fin_valid_time:=temp;
end;

Procedure initialization_calendar;
var counter1,counter2:integer;
Begin
	for counter2:=1 to 6 do
		for counter1:=1 to 7 do
			calendar[counter2][counter1]:=0;
end;

Function avail(target_room:roomtype;target_date:datetype;target_start,target_end:timetype):boolean;
Var temp:boolean;
Begin
	read_book_list;
	temp:=false;
	for c:=1 to i do
	begin
		if (target_room=room_arr[c]) then
			if (target_date=date_arr[c]) then
				if (not(fin_valid_time(end_arr[c],target_start))) and (not(fin_valid_time(target_end,start_arr[c]))) then temp:=true;
	end;
	avail:=not(temp);
end;

Function valid_month(t_month,t_year:integer):boolean;
var temp:boolean;
begin
	temp:=true;
	if (t_year<YYYY) or ((t_year=YYYY) and (t_month<MM)) then
		temp:=false;
	if (t_month>12) or (t_month<1) then
		temp:=false;
	valid_month:=temp;
end;

Procedure printcalendar;
var syy:string;
    stday:integer;
    leapyearcode:integer;
    counter1,counter2:integer;
    assignday:integer;
Begin
	repeat
		writeln('Print Calendar...');
		write('Year: ');
		readln(syyt);
		write('Month: ');
		readln(this_month);
		val(sYYt,this_year,code);
	until valid_month(this_month,this_year);
	
	sYY:=copy(syyt,3,2);
	val(sYY,YY,code);
	if ((this_year mod 4 = 0) and (this_year mod 100<>0)) or (this_year mod 400=0)
	then begin leapyearcode:=1; monthday[2]:=29; end
	else leapyearcode:=0;
	
	initialization_calendar;
	stday:=(((YY + (YY div 4)) mod 7)+month_code[this_month]+1+6-leapyearcode) mod 7;
    if stday=0 then stday:=7;
	TextColor(magenta);
	writeln(month[this_month]:14);
	TextColor(blue);
	write(' MON TUE WED THU FRI');
    TextColor(red);
    writeln(' SAT SUN');
    TextColor(blue);
	assignday:=1;
	for counter1:=stday to 7 do
	begin
		calendar[1][counter1]:=assignday;
		assignday:=assignday+1;
	end;
	for counter2:=2 to 6 do
		for counter1:=1 to 7 do
		begin
			if assignday<=monthday[this_month] then calendar[counter2][counter1]:=assignday;
			assignday:=assignday+1;
		end;
	for counter2:=1 to 6 do
		begin
		for counter1:=1 to 7 do
			if (calendar[counter2][counter1]<>0)then
                                begin
                                if (counter1=6)or(counter1=7) then
				begin
					TextColor(RED);
					write(calendar[counter2][counter1]:4);
					TextColor(blue);
				end else write(calendar[counter2][counter1]:4);
                                end
			else write('    ');
		writeln;
		end;
end;

Procedure booking_book;
begin
	read_book_list;
	rewrite(booklist);
	for c:=1 to i do
		writeln(booklist,name_arr[c],room_arr[c],date_arr[c],start_arr[c],end_arr[c]);
	writeln(booklist,t_name,t_room,t_date,t_start,t_end);
	close(booklist);
end;

Procedure booking;
var ans:string;
Begin
	clrscr;
	read_book_list;
	printcalendar;

	write('Input the booking date in form of YYYYMMDD: ');
	readln(t_date);
	while not(valid_date(t_date)) do
	begin
		writeln('Not valid date.');
		write('Input the booking date in form of YYYYMMDD: ');
		readln(t_date);
	end;

	print_room_2;
	
	write('Input the room you want to book: ');
	readln(t_room);
	while not(find_room(t_room)) do
	begin
		writeln('This room does not exist.');
		write('Input the room you want to book.');
		readln(t_room);
	end;

	write('Input the starting time(from 0800-1800): ');
	readln(t_start);
	while not(valid_time(t_start)) do
	begin
		writeln('Not valid date.');
		write('Input the starting time(from 0800-1800): ');
		readln(t_start);
	end;
	
	write('Input the ending time(from 0800-1800): ');
	readln(t_end);
	while (not(fin_valid_time(t_start,t_end))) or (not(valid_time(t_end))) do
	begin
		writeln('Not valid time.');
		write('Input the ending time(from 0800-1800): ');
		readln(t_end);
	end;
	
	if avail(t_room,t_date,t_start,t_end) then 
	begin
		date_to_format(t_date);
		time_to_format(t_start,t_end);
			
		writeln('Your booking is as following: ');
		writeln('Room:' ,t_room);
		writeln('Date:' ,n,'/',m,'/',l);
		writeln('From ',o,':',p,' - ',q,':',r);
				
		writeln('Input Yes to confirm.');
		readln(ans);
		if cap(ans)='YES' then 
		begin
			booking_book;
			writeln('Booked.');
		end 
		else writeln('Cancelled.');
	end
	else writeln('Sorry.Not available!');
	
	write('Enter to continue.');
	readln;
	
end;

Procedure list_swap;
var temp:string;
    temp2:integer;
Begin
	temp:=name_arr[c+1];
	name_arr[c+1]:=name_arr[c];
	name_arr[c]:=temp;
	
	temp:=room_arr[c+1];
	room_arr[c+1]:=room_arr[c];
	room_arr[c]:=temp;

	temp2:=z[c+1];
	z[c+1]:=z[c];
	z[c]:=temp2;

	temp2:=y[c+1];
	y[c+1]:=y[c];
	y[c]:=temp2;

	temp2:=x[c+1];
	x[c+1]:=x[c];
	x[c]:=temp2;

	temp:=date_arr[c+1];
	date_arr[c+1]:=date_arr[c];
	date_arr[c]:=temp;

	temp2:=x2[c+1];
	x2[c+1]:=x2[c];
	x2[c]:=temp2;
	
	temp2:=y2[c+1];
	y2[c+1]:=y2[c];
	y2[c]:=temp2;
	
	temp:=start_arr[c+1];
	start_arr[c+1]:=start_arr[c];
	start_arr[c]:=temp;

	temp:=end_arr[c+1];
	end_arr[c+1]:=end_arr[c];
	end_arr[c]:=temp;
end;

Procedure rewrite_list;
Begin
	rewrite(booklist);
	for c:=1 to i do
		writeln(booklist,name_arr[c],room_arr[c],date_arr[c],start_arr[c],end_arr[c]);
	close(booklist);
end;

Procedure sort_list_by_time;
Begin
	read_book_list;
	for c:=1 to i do begin
		val(copy(date_arr[c],1,4),x[c],code);
		val(copy(date_arr[c],5,2),y[c],code);
		val(copy(date_arr[c],7,2),z[c],code);
		val(copy(start_arr[c],1,2),x2[c],code);
		val(copy(start_arr[c],3,2),y2[c],code);
	end;
	for j:=1 to i-1 do
		for c:=1 to i-j do
			if y2[c]>y2[c+1] then
				list_swap;	
	for j:=1 to i-1 do
		for c:=1 to i-j do
			if x2[c]>x2[c+1] then
				list_swap;
	for j:=1 to i-1 do
		for c:=1 to i-j do
			if z[c]>z[c+1] then
				list_swap;
	for j:=1 to i-1 do
		for c:=1 to i-j do
			if y[c]>y[c+1] then
				list_swap;
	for j:=1 to i-1 do
		for c:=1 to i-j do
			if x[c]>x[c+1] then
				list_swap;		
	rewrite_list;
end;

Procedure delete_booking;
Var record_no:array[1..max] of integer;
	temp:integer;
	tempst:string;
	temp1,temp2,temp3:timetype;
    ans:string;
Begin
	clrscr;
	writeln('Delete...');
	read_book_list;
	sort_list_by_time;
	j:=0;
	writeln('                 Room date       Starting Ending');
	writeln('                 ---- ----       -------- ------');
	for c:=1 to i do
	begin
		if name_arr[c]=t_name then
		begin
		j:=j+1;
		record_no[j]:=c;
		temp1:=copy(date_arr[c],1,4);
		temp2:=copy(date_arr[c],5,2);
		temp3:=copy(date_arr[c],7,2);
		write('No.',j:2,' booking: ');
		write(room_arr[c]:7,temp3:3,'-',temp2,'-',temp1);
		temp1:=copy(start_arr[c],1,2);
		temp2:=copy(start_arr[c],3,2);
		write(temp1:3,':',temp2);
		temp1:=copy(end_arr[c],1,2);
		temp2:=copy(end_arr[c],3,2);
		writeln(temp1:6,':',temp2);
		end;
	end;
	if j>0 then begin
		write('Input the no. of booking you want to delete.');
		readln(tempst);
		if not(break(tempst)) then begin
			val(tempst,temp,code);
			if (temp>=1)and(temp<=j) then
			begin
				date_to_format(date_arr[record_no[temp]]);
				time_to_format(start_arr[record_no[temp]],end_arr[record_no[temp]]);
					
				writeln('The booking that you want to delete is as following: ');
				writeln('Room:' ,room_arr[record_no[temp]]);
				writeln('Date:' ,n,'/',m,'/',l);
				writeln('From ',o,':',p,' - ',q,':',r);
						
				writeln('Input Yes to confirm.');
				readln(ans);
				if cap(ans)='YES' then 
				begin
					for c:=record_no[temp] to max-1 do
					begin
						name_arr[c]:=name_arr[c+1];
						room_arr[c]:=room_arr[c+1];
						date_arr[c]:=date_arr[c+1];
						start_arr[c]:=start_arr[c+1];
						end_arr[c]:=end_arr[c+1];
					end;
					rewrite(booklist);
					for c:=1 to i do
						writeln(booklist,name_arr[c],room_arr[c],date_arr[c],start_arr[c],end_arr[c]);
					close(booklist);
					writeln('Deleted.');
				end 
				else writeln('No record will be deleted.');
			end 
			else writeln('The record does not exist.');
				
		end; end
	else writeln('No record exist.');
	writeln('Enter to continue.');
	readln;
		
end;

Procedure modify_booking;
Var record_no:array[1..max] of integer;
    temp:integer;
	tempst:string;
	temp1,temp2,temp3,ans:string;
Begin
	clrscr;
	writeln('Modify...');
	sort_list_by_time;
	c:=0;
	j:=0;
	writeln('                 Room date       Starting Ending');
	writeln('                 ---- ----       -------- ------');
	while c<=i do {*binary_search}
	begin
		c:=c+1;
		if name_arr[c]=t_name then
		begin
		j:=j+1;
		record_no[j]:=c;
		temp1:=copy(date_arr[c],1,4);
		temp2:=copy(date_arr[c],5,2);
		temp3:=copy(date_arr[c],7,2);
		write('No.',j:2,' booking: ');
		write(room_arr[c]:7,temp3:3,'-',temp2,'-',temp1);
		temp1:=copy(start_arr[c],1,2);
		temp2:=copy(start_arr[c],3,2);
		write(temp1:3,':',temp2);
		temp1:=copy(end_arr[c],1,2);
		temp2:=copy(end_arr[c],3,2);
		writeln(temp1:6,':',temp2);
		end;
	end;

	if j>0 then begin
	write('Input the no. of booking you want to modify: ');
	readln(tempst);
	if not(break(tempst)) then begin
		val(tempst,temp,code);
		
		printcalendar;
		write('Input the booking date in form of YYYYMMDD: ');
		readln(t_date);
		while not(valid_date(t_date)) and not(break(t_date)) do
		begin
			writeln('Not valid date.');
			write('Input the booking date in form of YYYYMMDD: ');
			readln(t_date);
		end;
		if (t_date<>'') then date_arr[record_no[temp]]:=t_date;
		
		print_room_2;
		write('Input the room you want to book: ');
		readln(t_room);
		while not(find_room(t_room)) and not(break(t_room)) do
		begin
			writeln('This room does not exist.');
			write('Input the room you want to book: ');
			readln(t_room);
		end;
		if (t_room<>'') then room_arr[record_no[temp]]:=t_room;

		write('Input the starting time(from 0800-1800): ');
		readln(t_start);
		while not(valid_time(t_start)) and not(break(t_start))  do
		begin
			writeln('Not valid date.');
			write('Input the starting time(from 0800-1800): ');
			readln(t_start);
		end;
		if (t_start<>'') then start_arr[record_no[temp]]:=t_start;

		write('Input the ending time(from 0800-1800): ');
		readln(t_end);
		while ((not(fin_valid_time(t_start,t_end))) or (not(valid_time(t_end)))) and not(break(t_end)) do
		begin
			writeln('Not valid time.');
			write('Input the ending time(from 0800-1800): ');
			readln(t_end);
		end;
		if (t_end<>'') then end_arr[record_no[temp]]:=t_end;

		if avail(t_room,t_date,t_start,t_end) then 
		begin
			date_to_format(date_arr[record_no[temp]]);
			time_to_format(start_arr[record_no[temp]],end_arr[record_no[temp]]);
				
			writeln('Your booking is as following: ');
			writeln('Room:' ,room_arr[record_no[temp]]);
			writeln('Date:' ,n,'/',m,'/',l);
			writeln('From ',o,':',p,' - ',q,':',r);
					
			writeln('Input Yes to confirm.');
			readln(ans);
			if cap(ans)='YES' then 
			begin
				rewrite(booklist);
				for c:=1 to i do
					writeln(booklist,name_arr[c],room_arr[c],date_arr[c],start_arr[c],end_arr[c]);
				close(booklist);
				writeln('Modified.');
			end 
			else writeln('Cancelled.');
		end
		else writeln('Sorry.Not available!');
	end; end
	else writeln('Record does not exist.');
	writeln('Enter to continue.');
	readln;
end;

Procedure printing;
var
	temp1,temp2,temp3:string;
Begin
	clrscr;
	writeln('                 Name Room date       Starting Ending');
	writeln('                 ---- ---- ----       -------- ------');
	for c:=1 to i do begin
		temp1:=copy(date_arr[c],1,4);
		temp2:=copy(date_arr[c],5,2);
		temp3:=copy(date_arr[c],7,2);
		write('No.',c:2,' booking: ');
		write(name_arr[c]:7,room_arr[c]:5,temp3:3,'-',temp2,'-',temp1);
		temp1:=copy(start_arr[c],1,2);
		temp2:=copy(start_arr[c],3,2);
		write(temp1:3,':',temp2);
		temp1:=copy(end_arr[c],1,2);
		temp2:=copy(end_arr[c],3,2);
		writeln(temp1:6,':',temp2);
	end;
	write('Enter to continue.');
	readln;
end;

Procedure sort_by_time;
Begin
	for c:=1 to i do begin
		val(copy(date_arr[c],1,4),x[c],code);
		val(copy(date_arr[c],5,2),y[c],code);
		val(copy(date_arr[c],7,2),z[c],code);
		val(copy(start_arr[c],1,2),x2[c],code);
		val(copy(start_arr[c],3,2),y2[c],code);
	end;
	for j:=1 to i-1 do
		for c:=1 to i-j do
			if y2[c]>y2[c+1] then
				list_swap;		
	for j:=1 to i-1 do
		for c:=1 to i-j do
			if x2[c]>x2[c+1] then
				list_swap;
	for j:=1 to i-1 do
		for c:=1 to i-j do
			if z[c]>z[c+1] then
				list_swap;
	for j:=1 to i-1 do
		for c:=1 to i-j do
			if y[c]>y[c+1] then
				list_swap;
	for j:=1 to i-1 do
		for c:=1 to i-j do
			if x[c]>x[c+1] then
				list_swap;
	printing;
end;

Procedure sort_by_name;
Begin
	for j:=1 to i-1 do
		for c:=1 to i-j do
			if name_arr[c]>name_arr[c+1] then
				list_swap;
	printing;
end;

Procedure sort_by_room;
Begin
	for j:=1 to i-1 do
		for c:=1 to i-j do
			if room_arr[c]>room_arr[c+1] then
				list_swap;
	printing;
end;

Procedure print_menu;
Begin
	clrscr;
	read_book_list;
	sort_list_by_time;
	writeln('Printing Menu');
	writeln('1. Sorted by time');
	writeln('2. Sorted by name');
	writeln('3. Sorted by room');
	writeln('4. Return to General Menu');
	write('Option ');
	readln(opt);
	val(opt,opt_int,code);
	
	case opt_int of
		1: sort_by_time;
		2: sort_by_name;
		3: sort_by_room
    end;
end;

Procedure rewrite_teacher;
Begin
	rewrite(teacherlist);
	for  j:= 1 to i do
		writeln(teacherlist,name_arr[j],password_arr[j]);
	close(teacherlist);
end;

Procedure change_password;
var ans,t_password2,t_password3:string;
Begin
	clrscr;
	read_teacher;
	TextColor(Red);
	write('Do you want to change you password?(Please input ');
	TextColor(yellow);
	write('Yes/No');
	TextColor(Red);
	writeln(')');
	readln(ans);
	TextColor(Blue);
	ans:=cap(ans);
	if ans='YES' then
		begin
			write('Input your new password: ');
			readln(t_password);
			while (length(t_password)<>6) and not(break(t_password2)) do
			begin
				writeln('You should input 6 letters or numbers only e.g.ABC');
				write('Input your new password: ');
				readln(t_password);
			end;
			if not(break(t_password)) then
			begin
				write('Confirm password: ');
				readln(t_password2);
				while (t_password2<>t_password) and not(break(t_password2)) do
				begin
					writeln('Two passwords do not match!');
					write('Confirm password: ');
					readln(t_password2);
				end;
				if not(break(t_password2)) then
				begin
					t_password3:=copy(t_password,1,3);
					clrscr;
					writeln('The record that you want to change is as following: ');
					writeln('Password: ',t_password3,'***');
					writeln('Input Yes to confirm.');
					readln(ans);
					if cap(ans)='YES' then 
					begin
						password_arr[pos]:=t_password;
						rewrite_teacher;
						writeln('Added.');
					end 
					else writeln('Cancelled.');	
				end;
			end;
		end;
	write('Enter to continue.');
	readln;
end;

procedure print_period;
begin
	writeln('Print the period list...');
	write('Period  1 ');
	period_start_no[1]:='0800';
	period_end_no[1]:='0900';
	writeln('08:00-09:00');
	write('Period  2 ');
	period_start_no[2]:='0900';
	period_end_no[2]:='1000';
	writeln('09:00-10:00');
	write('Period  3 ');
	period_start_no[3]:='1000';
	period_end_no[3]:='1100';
	writeln('10:00-11:00');
	write('Period  4 ');
	period_start_no[4]:='1100';
	period_end_no[4]:='1200';
	writeln('11:00-12:00');
	write('Period  5 ');
	period_start_no[5]:='1200';
	period_end_no[5]:='1300';
	writeln('12:00-13:00');
	write('Period  6 ');
	period_start_no[6]:='1300';
	period_end_no[6]:='1400';
	writeln('13:00-14:00');
	write('Period  7 ');
	period_start_no[7]:='1400';
	period_end_no[7]:='1500';
	writeln('14:00-15:00');
	write('Period  8 ');
	period_start_no[8]:='1500';
	period_end_no[8]:='1600';
	writeln('15:00-16:00');
	write('Period  9 ');
	period_start_no[9]:='1600';
	period_end_no[9]:='1700';
	writeln('16:00-17:00');
	write('Period 10 ');
	period_start_no[10]:='1700';
	period_end_no[10]:='1800';
	writeln('17:00-18:00');
end;

Function IntToStr (I:integer):string;
var S:string;
begin
	str(I,S);
	IntToStr:=S;
end;

Procedure check_not_avail_day;
begin
	read_book_list;
	not_avail_day_no:=0;
	for c:=1 to i do
	begin
		if t_room=room_arr[c] then
		begin
			{if  end_arr[c]<=t_start or end_arr[c]<=t_start}
			if not(fin_valid_time(end_arr[c],t_start)) and not(fin_valid_time(t_end,start_arr[c])) then
			begin
				not_avail_day_no:=not_avail_day_no+1;
				not_avail_day[not_avail_day_no]:=date_arr[c];
			end;
		end;
	end;
	
end;

Function check_not_avail(temp_day_int:integer):boolean;
var temp_match:boolean;
	temp_day:string;
begin
	temp_match:=false;
	for c:=1 to not_avail_day_no do
		begin
			if this_month < 10 then
				temp_day:=syyt+'0'+IntToStr(this_month)
			else temp_day:=syyt+IntToStr(this_month); 
			if temp_day_int < 10 then 
				temp_day:=temp_day+'0'+IntToStr(temp_day_int)
			else temp_day:=temp_day+IntToStr(temp_day_int);
			if not_avail_day[c]=temp_day then temp_match:=true;
		end;
	check_not_avail:=temp_match;
end;

Procedure printcalendar_avail;
var syy:string;
    stday:integer;
    leapyearcode:integer;
    counter1,counter2:integer;
    assignday:integer;
    a,b,c,d:integer;
    temp_day:string;
	temp_match:boolean;

Begin
	repeat
		writeln('Print Calendar of the available day...');
		write('Year: ');
		readln(syyt);
		write('Month: ');
		readln(this_month);
		val(sYYt,this_year,code);
	until valid_month(this_month,this_year);
    sYY:=copy(syyt,3,2);
    val(sYY,YY,code);
	if ((this_year mod 4 = 0) and (this_year mod 100<>0)) or (this_year mod 400=0)
	then begin leapyearcode:=1; monthday[2]:=29; end
	else leapyearcode:=0;
	
	initialization_calendar;
	stday:=(((YY + (YY div 4)) mod 7)+month_code[this_month]+1+6-leapyearcode) mod 7;
    if stday=0 then stday:=7;
	TextColor(magenta);
	writeln(month[this_month]:14);
	TextColor(blue);
	write(' MON TUE WED THU FRI');
    TextColor(red);
    writeln(' SAT SUN');
    TextColor(blue);
	assignday:=1;
	for counter1:=stday to 7 do
	begin
		calendar[1][counter1]:=assignday;
		assignday:=assignday+1;
	end;
	for counter2:=2 to 6 do
		for counter1:=1 to 7 do
		begin
			if assignday<=monthday[this_month] then calendar[counter2][counter1]:=assignday;
			assignday:=assignday+1;
		end;

	check_not_avail_day;

	for counter2:=1 to 6 do
		begin
		for counter1:=1 to 7 do
			if (calendar[counter2][counter1]<>0)then
                begin
					if (counter1=6)or(counter1=7) then
					begin
						TextColor(RED);
						write(calendar[counter2][counter1]:4);
						TextColor(blue);
					end
					else write(calendar[counter2][counter1]:4);
                end
				else write('    ');

		writeln;

		for counter1:=1 to 7 do
			if (calendar[counter2][counter1]<>0) then
            begin
				if check_not_avail(calendar[counter2][counter1]) then
				begin
					TextColor(Red);
					write(chr(219):4);
					TextColor(blue);
				end
				else
				begin
					TextColor(Green);
					write(chr(219):4);
					TextColor(blue);
				end;
            end
			else write('    ');

		writeln;

		end;
end;

Procedure book_by_room;
var line_str,period_str,temp_day_str,ans:string;
    line_int,period_int,temp:integer;
begin
	clrscr;
	print_room;
	write('Input the line no. of the room you want to book: ');
	readln(line_str);
	val(line_str,line_int,code);
	
	while ((code = 0)and(line_int>current_room_no) or (code<>0))  and not(break(line_str))do
	begin
		if (code<>0) then writeln('You should input the line no. instead of the room no.')
		else writeln('The line no. does not exist.');
		write('Input the line no. of the room you want to book: ');
		readln(line_str);
		val(line_str,line_int,code);
	end;
	if not(break(line_str)) then
	begin
		t_room:=line_no[line_int];

		print_period;
		
		write('Input the period no. you want to book: ');
		readln(period_str);
		val(period_str,period_int,code);
		while (((code = 0) and (period_int>max_period_no)) or (code <> 0))and not (break(period_str))do
		begin
			if (code<>0) then writeln('You should input the period no. instead of the period time.(e.g 2)')
			else writeln('The period no. does not exist.');
			write('Input the period no. you want to book.');
			readln(period_str);
			val(period_str,period_int,code);
		end;
		
		if not(break(period_str)) then
		begin
			t_start:=period_start_no[period_int];
			t_end:=period_end_no[period_int];
			printcalendar_avail;
			repeat
			writeln('Function menu');
			writeln('1. Check available day in the other month and year');
			writeln('2. Book the room(',line_no[period_int],')');
			writeln('3. Check availability of other room');
			writeln('4. Return');
			write('Option ');
			readln(opt);
			val(opt,opt_int,code);
			
			case opt_int of
				1:printcalendar_avail;
				2:begin
					writeln('The room(',line_no[period_int],') from ',t_start,' to ',t_end,' is available on the days with green light.');
					write('Input the day you want to book: ');
					readln(temp_day_str);
					val(temp_day_str,temp,code);
					
					while  (((code=0)and(temp<1) or (temp>monthday[this_month])) or (code<>0)) and not(break(temp_day_str)) do
					begin
						if (code<>0) then writeln('You should input the day only.(e.g 2)')
						else writeln('Invalid day.');
						write('Input the day you want to book: ');
						readln(temp_day_str);
						val(temp_day_str,temp,code);
					end;
						
					if 	not(break(temp_day_str)) then
					begin
						if this_month < 10 then
						t_date:=syyt+'0'+IntToStr(this_month)
						else t_date:=syyt+IntToStr(this_month);
						if temp < 10 then
						t_date:=t_date+'0'+temp_day_str
						else t_date:=t_date+temp_day_str;

						while (check_not_avail(temp) or not(valid_date(t_date))) and not(break(temp_day_str))do
						begin
							if not(valid_date(t_date)) then
								begin
									writeln('Wrong input.');
									write('Input the day again. ');
								end else
								begin
									writeln('The room is not available.');
									write('Input the day again. ');
								end;
								readln(temp_day_str);
								val(temp_day_str,temp,code);
								if this_month < 10 then
								t_date:=syyt+'0'+IntToStr(this_month)
								else t_date:=syyt+IntToStr(this_month);
								if temp < 10 then
								t_date:=t_date+'0'+temp_day_str
								else t_date:=t_date+temp_day_str;
						end;
						
						if not(break(temp_day_str)) then
						begin
							t_room:=line_no[line_int];

							date_to_format(t_date);
							time_to_format(t_start,t_end);
						
							writeln('Your booking is as following: ');
							writeln('Room:' ,t_room);
							writeln('Date:' ,n,'/',m,'/',l);
							writeln('From ',o,':',p,' - ',q,':',r);
							
							writeln('Input Yes to confirm.');
							readln(ans);
							if cap(ans)='YES' then 
							begin
								booking_book;
								writeln('Booked.');
							end 
							else writeln('Cancelled.');
							
						end;
					end;
						write('Enter to continue.');
						readln;
			    end;
				3:book_by_room;
            end;
			until (opt_int=2) or (opt_int=3) or (opt_int=4);
		end;
	end;
end;

Procedure book_by_date_and_time;
var temp_day_str,period_str,line_str,ans:string;
	temp,period_int,counter1,c2,not_avail_room_no,line_int:integer;
	match:boolean;
	not_avail_room_line:array[1..max] of integer;
begin
	clrscr;
	printcalendar;
	write('Input the day you want to book: ');
	readln(temp_day_str);
	val(temp_day_str,temp,code);
	while ((temp>monthday[this_month]) or (temp<1)) and not(break(temp_day_str)) do
	begin
		writeln('You should input the day.');
		write('Input the day you want to book: ');
		readln(temp_day_str);
		val(temp_day_str,temp,code);
	end;

	if this_month < 10 then
		t_date:=syyt+'0'+IntToStr(this_month)
		else t_date:=syyt+IntToStr(this_month);
	if temp < 10 then
		t_date:=t_date+'0'+temp_day_str
		else t_date:=t_date+temp_day_str;

	if not(break(temp_day_str)) then
	begin
		print_period;
		write('Input the period no. you want to book: ');
		readln(period_str);
		val(period_str,period_int,code);
		while (((code = 0) and (period_int>max_period_no)) or (code<>0)) and not(break(period_str)) do
		begin
			if (code <> 0) then
				writeln('You should input the period no. instead of the period time.(e.g 2)')
			else writeln('The period no. does not exist.');
			write('Input the period no. you want to book: ');
			readln(period_str);
			val(period_str,period_int,code);
		end;
	t_start:=period_start_no[period_int];
	t_end:=period_end_no[period_int];
	end;


	read_book_list;
	not_avail_room_no:=0;
	if not(break(period_str)) then
	begin
		read_room_2;
		writeln('Print available room list...');
		for counter1:=1 to j do
		begin
			write('Line',counter1,' ',line_no[counter1]);
			match:=false;
			for c2:=1 to i do
			begin
				if (line_no[counter1]=room_arr[c2]) then
					if (t_date=date_arr[c2]) then
						if (not(fin_valid_time(end_arr[c2],t_start))) and (not(fin_valid_time(t_end,start_arr[c2]))) then match:=true;
			end;
			if match then
			begin
				not_avail_room_no:=not_avail_room_no+1;
				not_avail_room_line[not_avail_room_no]:=counter1;
				TextColor(Red);
				writeln(chr(219):4);
				TextColor(blue);
			end
			else	
			begin
				TextColor(Green);
				writeln(chr(219):4);
				TextColor(blue);
			end;
		end;
		current_room_no:=j;

		writeln('Rooms with green light are available.');
		write('Input the line no. of the room you want to book: ');
		readln(line_str);
		val(line_str,line_int,code);
		match:=false;
		if (code = 0) then
			for counter1:=1 to not_avail_room_no do
				if not_avail_room_line[counter1]=line_int then match:=true;
		while (((code = 0)and(line_int>current_room_no)) or match  or (code <> 0)) and not(break(line_str)) do
		begin
			if match then writeln('The room is unavailable.');
			if (code <> 0) then writeln('You should input line no but not the room name.');
			if (code = 0) and ((line_int>current_room_no) or (line_int<1)) then writeln('The line no. does not exist.');
			write('Input the line no. of the room you want to book: ');
			readln(line_str);
			val(line_str,line_int,code);
			match:=false;
			if (code = 0) then
			for counter1:=1 to not_avail_room_no do
				if not_avail_room_line[counter1]=line_int then match:=true;
		end;

		if not(break(line_str)) then
		begin
			t_room:=line_no[line_int];

			date_to_format(t_date);
			time_to_format(t_start,t_end);
		
			writeln('Your booking is as following: ');
			writeln('Room:' ,t_room);
			writeln('Date:' ,n,'/',m,'/',l);
			writeln('From ',o,':',p,' - ',q,':',r);
			
			writeln('Input Yes to confirm.');
			readln(ans);
			if cap(ans)='YES' then 
			begin
				booking_book;
				writeln('Booked.');
			end 
			else writeln('Cancelled.');
			
		end;
		
		writeln('Enter to continue.');
		readln;

	end;
	
end;

procedure print_calendar_today;
var stday:integer;
    leapyearcode:integer;
    counter1,counter2:integer;
    assignday:integer;
Begin
	this_year:=YYYY;
	this_month:=MM;
	YY:=YYYY mod 100;
	if ((this_year mod 4 = 0) and (this_year mod 100<>0)) or (this_year mod 400=0)
	then begin leapyearcode:=1; monthday[2]:=29; end
	else leapyearcode:=0;
	initialization_calendar;
	stday:=(((YY + (YY div 4)) mod 7)+month_code[this_month]+1+6-leapyearcode) mod 7;
    if stday=0 then stday:=7;
	TextColor(magenta);
	gotoxy(50,1);writeln(month[this_month]:14);
	TextColor(blue);
	Textbackground(yellow);
	gotoxy(50,2);write(' MON TUE WED THU FRI');
    TextColor(red);
    writeln(' SAT SUN');
    TextColor(blue);
	Textbackground(white);
	assignday:=1;
	for counter1:=stday to 7 do
	begin
		calendar[1][counter1]:=assignday;
		assignday:=assignday+1;
	end;
	for counter2:=2 to 6 do
		for counter1:=1 to 7 do
		begin
			if assignday<=monthday[this_month] then calendar[counter2][counter1]:=assignday;
			assignday:=assignday+1;
		end;
	for counter2:=1 to 6 do
		begin
		gotoxy(50,2+counter2);
		for counter1:=1 to 7 do
			if (calendar[counter2][counter1]<>0)then
                                begin
                                if (counter1=6)or(counter1=7) then
				begin
					TextColor(RED);
					write(calendar[counter2][counter1]:4);
					TextColor(blue);
				end else write(calendar[counter2][counter1]:4);
                                end
			else write('    ');
		writeln;
		end;
		
end;

Procedure new_ver_book_menu;
begin
	repeat	
		clrscr;
		writeln('New version Booking Menu');
		writeln('1. Book by room and time');
		writeln('2. Book by date and time');
		writeln('3. Return to booking menu');
		write('Option ');
		print_calendar_today;
		gotoxy(8,5);
		readln(opt);
		val(opt,opt_int,code);
		
		case opt_int of
			1: book_by_room;
			2: book_by_date_and_time;
		end;
	until opt_int=3;
end;

Procedure booking_menu;
begin
	repeat
		clrscr;
		writeln('Booking Menu');
		TextColor(Red);
		writeln('**1. New version booking system (available now!)');
		TextColor(blue);
		writeln('2. Old version booking system');
		writeln('3. Return to general menu');
		writeln('New version booking system provide a more intelligent way to book.');
		write('Option ');
		readln(opt);
		val(opt,opt_int,code);
		
		case opt_int of
			1: new_ver_book_menu;
			2: booking;
		end;
	until opt_int=3;
end;

Procedure up_to_date;
var a,b,c:integer;
    counter1,counter2,counter3:integer;
    name_arr2,room_arr2,date_arr2:array[1..max] of string[8];
    start_arr2,end_arr2:array[1..max] of string[8];
    begin
	read_book_list;
	counter2:=0;
	for counter1:=1 to i do
	begin
		val(copy(date_arr[counter1],1,4),a,code);
		val(copy(date_arr[counter1],5,2),b,code);
		val(copy(date_arr[counter1],7,2),c,code);
		if not((a<YYYY) or ((a=YYYY) and (b<MM)) or ((a=YYYY) and (b=MM) and (c<DD))) then 
		begin
			counter2:=counter2+1;
			name_arr2[counter2]:=name_arr[counter1];
			room_arr2[counter2]:=room_arr[counter1];
			date_arr2[counter2]:=date_arr[counter1];
			start_arr2[counter2]:=start_arr[counter1];
			end_arr2[counter2]:=end_arr[counter1];
		end;
	end;
	rewrite(booklist);
	for counter3:=1 to counter2 do
		writeln(booklist,name_arr2[counter3],room_arr2[counter3],date_arr2[counter3],start_arr2[counter3],end_arr2[counter3]);
	close(booklist);
end;

Procedure print_time;
Begin
	write('Today: ',DD,'/',MM,'/',YYYY,'(',weekname[WD],')');
    write(' Time: ');
	if hour <10 then write('0',Hour,':') else write(Hour,':');
	if Min <10 then writeln('0',Min) else writeln(Min);
end;

Procedure layout_general;
Begin
	
	Textbackground(cyan);
	TextColor(magenta);
	write('General Menu ');
	write('Welcome ');
	write(t_name,' ');
	print_time;
	TextColor(blue);
	Textbackground(white);
end;

Procedure print_by_day;
var co,no:integer;
    temp1,temp2,temp3:string;
Begin
	clrscr;
	write('Print booking on one day');
	printcalendar;
	write('Input the date in form of YYYYMMDD: ');
	readln(t_date);
	while not(valid_date(t_date))and not(break(t_date)) do
	begin
		writeln('Not valid date.');
		write('Input the booking date in form of YYYYMMDD: ');
		readln(t_date);
	end;

	if not(break(t_date)) then
	begin
		no:=1;
		clrscr;
		read_book_list;
		writeln('                 Name Room date       Starting Ending');
		writeln('                 ---- ---- ----       -------- ------');
		for co:=1 to i do
		begin
			if date_arr[co]=t_date then
			begin
				temp1:=copy(date_arr[co],1,4);
				temp2:=copy(date_arr[co],5,2);
				temp3:=copy(date_arr[co],7,2);
				write('No.',no:2,' booking: ');
				write(name_arr[co]:7,room_arr[co]:5,temp3:3,'-',temp2,'-',temp1);
				temp1:=copy(start_arr[co],1,2);
				temp2:=copy(start_arr[co],3,2);
				write(temp1:3,':',temp2);
				temp1:=copy(end_arr[co],1,2);
				temp2:=copy(end_arr[co],3,2);
				writeln(temp1:6,':',temp2);
				no:=no+1;
			end;
		end;
		write('Enter to continue.');
		readln;
	end;
	
end;

Procedure print_by_name;
var co,no:integer;{counter}
temp1,temp2,temp3:string;
Begin
	clrscr;
	write('Print booking of a teacher');
	print_teacher;
	write('Input the teacher initial: ');
	readln(t_name);
	while (not(find_teacher(t_name)) or (length(t_name)<>3)) and not(break(t_name)) do 
	begin
		if (length(t_name)<>3) then writeln('You should input 3 letters only e.g.ABC')
		else writeln('Teacher name does not exist!');
		write('Input the teacher initial that you want to delete: ');
		readln(t_name);
		t_name:=cap(t_name);
	end;
	if not(break(t_name)) then
	begin	
		clrscr;
		read_book_list;
		no:=1;
		writeln('                 Name Room date       Starting Ending');
		writeln('                 ---- ---- ----       -------- ------');
		for co:=1 to i do 
		begin
			if name_arr[co]=t_name then 
			begin	
				temp1:=copy(date_arr[co],1,4);
				temp2:=copy(date_arr[co],5,2);
				temp3:=copy(date_arr[co],7,2);
				write('No.',no:2,' booking: ');
				write(name_arr[co]:7,room_arr[co]:5,temp3:3,'-',temp2,'-',temp1);
				temp1:=copy(start_arr[co],1,2);
				temp2:=copy(start_arr[co],3,2);
				write(temp1:3,':',temp2);
				temp1:=copy(end_arr[co],1,2);
				temp2:=copy(end_arr[co],3,2);
				writeln(temp1:6,':',temp2);
				no:=no+1;
			end;
		end;
		write('Enter to continue.');
		readln;
	end;

end;

Procedure print_by_room;
var co,no,line_int:integer;
line_str,temp1,temp2,temp3:string;
Begin
	clrscr;
	write('Print booking of a room');
	print_room;
	write('Input the line no. of the room you want to book: ');
	readln(line_str);
	val(line_str,line_int,code);
	
	while ((code = 0)and(line_int>current_room_no) or (code<>0))  and not(break(line_str))do
	begin
		if (code<>0) then writeln('You should input the line no. instead of the room no.')
		else writeln('The line no. does not exist.');
		write('Input the line no. of the room you want to book: ');
		readln(line_str);
		val(line_str,line_int,code);
	end;
	if not(break(line_str)) then
	begin
		t_room:=line_no[line_int];
		clrscr;
		read_book_list;
		no:=1;
		writeln('                 Name Room date       Starting Ending');
		writeln('                 ---- ---- ----       -------- ------');
		for co:=1 to i do 
		begin
			if room_arr[co]=t_room then 
			begin	
				temp1:=copy(date_arr[co],1,4);
				temp2:=copy(date_arr[co],5,2);
				temp3:=copy(date_arr[co],7,2);
				write('No.',no:2,' booking: ');
				write(name_arr[co]:7,room_arr[co]:5,temp3:3,'-',temp2,'-',temp1);
				temp1:=copy(start_arr[co],1,2);
				temp2:=copy(start_arr[co],3,2);
				write(temp1:3,':',temp2);
				temp1:=copy(end_arr[co],1,2);
				temp2:=copy(end_arr[co],3,2);
				writeln(temp1:6,':',temp2);
				no:=no+1;
			end;
		end;
		write('Enter to continue.');
		readln;
	end;
end;

Procedure print_select;
Begin
	clrscr;
	sort_list_by_time;
	writeln('Printing Menu');
	writeln('1. Print by day');
	writeln('2. Print by name');
	writeln('3. Print by room');
	writeln('4. Return to General Menu');
	write('Option ');
	readln(opt);
	val(opt,opt_int,code);
	
	case opt_int of
		1: print_by_day;
		2: print_by_name;
		3: print_by_room
    end;
end;

procedure general;
Begin
	up_to_date;
	repeat
		clrscr;
		layout_general;
		writeln('1. Booking');
		writeln('2. Delete your booking');
		writeln('3. Modify your booking');
		writeln('4. Print all booking');
		writeln('5. Print by selected info.');
		writeln('6. Change password');
		writeln('7. Return to main menu');
		write('Option ');
		readln(opt);
		val(opt,opt_int,code);
	
		case opt_int of
			1: booking_menu;
			2: delete_booking;
			3: modify_booking;
			4: print_menu;
			5: print_select;
			6: change_password;
		end;
	until opt_int=7;
End;
procedure security_general_user;
var found:boolean;
    ch:char;
    temp1,temp2:integer;
    s:string;
begin
	clrscr;
	read_teacher;
	found:=false;
	repeat
        clrscr;
        Writeln('Log in your account');
		writeln('Name: ');
		write('Password: ');
		gotoxy(7,2);
		readln(t_name);
		t_name:=cap(t_name);
		j:=0;
		while (j<i) and (not(found)) do
		begin
			j:=j+1;
			if t_name = name_arr[j] then
			begin
				found:=true;
				pos:=j;
			end;
		end;
		if not(found) then begin
                gotoxy(1,4);
				writeln ('Invalid id. Please input again.');
                readln;
                end;
	until found or break(t_name);
	
	if not(break(t_name)) then begin
	repeat
		t_password:='';
		gotoxy(11,3);
		temp1:=1;
		Repeat
           ch:=ReadKey;
           if (ord(ch)<>8) and (ord(ch)<>13) then
           begin
                write('*');
                s[temp1]:=ch;
                temp1:=temp1+1;
           end else
           if (temp1>1) and (ord(ch)=8) then
           begin
                temp1:=temp1-1;
                GotoXY(temp1+10,3);
                write(' ');
                gotoXY(temp1+10,3);
           end;
		Until Ord(ch)=13;{ch=Enter}
		for temp2:=1 to temp1-1 do
			t_password:=t_password+s[temp2];
		
		
		if t_password <> password_arr[j] then
			begin
				gotoxy(1,4);
				writeln ('Invalid password. Please input again.');
				readln;
				clrscr;
				Writeln('Log in your account');
				writeln('Name: ',t_name);
				write('Password: ');
			end;
	until t_password = password_arr[j] ;
	
	if not(break(t_password)) then
		general;
	end;
end;

Procedure layout_admin;
Begin
	
	Textbackground(cyan);
	TextColor(magenta);
	write('Administration Menu ');
	write('Welcome ');
	write(t_admin_name,' ');
	print_time;
	TextColor(blue);
	Textbackground(white);
end;

procedure admin;
Begin
    repeat
	clrscr;
	layout_admin;
	writeln('1. Add teacher');
	writeln('2. Add room');
	writeln('3. Delete teacher');
	writeln('4. Delete room');
	writeln('5. Return to main menu');
	write('Option ');
	readln(opt);
	val(opt,opt_int,code);
	
	case opt_int of
		1: add_teacher;
		2: add_room;
		3: delete_teacher;
		4: delete_room;
	end;
    until opt_int=5;
End;

Procedure read_admin;
Begin
	reset(adminlist);
	i:= 0;
	while not eof(adminlist) do
	begin
		i:= i+1;
		readln(adminlist,admin_name_arr[i],admin_password_arr[i]);
	end;
	close(adminlist);
End;

procedure security_admin;
var found:boolean;
    ch:char;
    temp1,temp2:integer;
    s:string;
begin
	clrscr;
	read_admin;
	found:=false;
	repeat
        clrscr;
        Writeln('Log in your account');
		writeln('Name: ');
		write('Password: ');
		gotoxy(7,2);
		readln(t_admin_name);
		t_name:=cap(t_admin_name);
		j:=0;
		while (j<i) and (not(found)) do
		begin
			j:=j+1;
			if t_admin_name = admin_name_arr[j] then
			begin
				found:=true;
				pos:=j;
			end;
		end;
		if not(found) then begin
                gotoxy(1,4);
				writeln ('Invalid id. Please input again.');
                readln;
                end;
	until found or break(t_admin_name);
	
	if not(break(t_admin_name)) then begin
	repeat
		t_admin_password:='';
		gotoxy(11,3);
		temp1:=1;
		Repeat
           ch:=ReadKey;
           if (ord(ch)<>8) and (ord(ch)<>13) then
           begin
                write('*');
                s[temp1]:=ch;
                temp1:=temp1+1;
           end else
           if (temp1>1) and (ord(ch)=8) then
           begin
                temp1:=temp1-1;
                GotoXY(temp1+10,3);
                write(' ');
                gotoXY(temp1+10,3);
           end;
		Until Ord(ch)=13;{ch=Enter}
		for temp2:=1 to temp1-1 do
			t_admin_password:=t_admin_password+s[temp2];
		
		
		if t_admin_password <> admin_password_arr[j] then
			begin
				gotoxy(1,4);
				writeln ('Invalid password. Please input again.');
				readln;
				clrscr;
				Writeln('Log in your account');
				writeln('Name: ',t_admin_name);
				write('Password: ');
			end;
	until t_admin_password = admin_password_arr[j] ;
	
	if not(break(t_admin_password)) then
		admin;
	end;
end;



Procedure main_menu;
Begin
	monthday[1]:=31; monthday[2]:=28; monthday[3]:=31; monthday[4]:=30; monthday[5]:=31; monthday[6]:=30;
	monthday[7]:=31; monthday[8]:=31; monthday[9]:=30; monthday[10]:=31; monthday[11]:=30; monthday[12]:=31;
	month[1]:='January'; month[2]:='February'; month[3]:='March'; month[4]:='April';
	month[5]:='May'; month[6]:='June'; month[7]:='July'; month[8]:='August';
	month[9]:='September'; month[10]:='October'; month[11]:='November';
	month[12]:='December';
	weekname[1]:='Mon'; weekname[2]:='Tue'; weekname[3]:='Wed';
	weekname[4]:='Thur'; weekname[5]:='Fri'; weekname[6]:='Sat';
	weekname[0]:='Sun';
	month_code[1]:=0; month_code[2]:=3; month_code[3]:=3;
	month_code[4]:=6; month_code[5]:=1; month_code[6]:=4;
	month_code[7]:=6; month_code[8]:=2; month_code[9]:=5;
	month_code[10]:=0; month_code[11]:=3; month_code[12]:=5;
	getdate(YYYY,MM,DD,WD);
	repeat
	GetTime(Hour,Min,Sec,HSec);
	clrscr;
    Textbackground(white);
	
    TextColor(cyan);
    write('Today: ',DD,'/',MM,'/',YYYY,'(',weekname[WD],')');
    write(' Time: ');
	if hour <10 then write('0',Hour,':') else write(Hour,':');
	if Min <10 then writeln('0',Min) else writeln(Min);
	writeln('---------------------------------');
	Textbackground(cyan);
	TextColor(magenta);
	writeln('Welcome to Classroom booking system!');
	Textbackground(white);
	TextColor(Blue);
	writeln('Menu');
	writeln('1. General User');
	writeln('2. Administrator');
	writeln('3. End');
	print_calendar_today;
	write('Option ');
	readln(opt);
	val(opt,opt_int,code);
	case opt_int of
		1: security_general_user;
		2: security_admin;
        end;
	until opt_int=3;
End;

Begin
	assign(booklist,'C:\Book.txt');
	assign(teacherlist,'C:\Teacher.txt');
	assign(roomlist,'C:\Room.txt');
	assign(adminlist,'C:\Admin.txt');
	main_menu;
End.
