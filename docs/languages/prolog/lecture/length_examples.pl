https://powcoder.com
代写代考加微信 powcoder
Assignment Project Exam Help
Add WeChat powcoder
% length_examples.pl

mylen([], 0).
mylen([_|Xs], Len) :-
	mylen(Xs, Rest_len),
	Len is 1 + Rest_len.
