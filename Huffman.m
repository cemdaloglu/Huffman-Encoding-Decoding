close all;
clear all;
rand('seed', sum(100*clock));

% part 2

str = "TODAY IS THE LONGEST DAY OF THE SPRING SEMESTER IN BILKENT";
x = repmat(str,[1 1100]);
str_to_char = char(x);
size_of_str(1:3) = size(str_to_char);
char_x = unique(char(str));
char_trace = char(x);
length_char = length(char_x);
length_string = length(char_trace);
length_x = length(x);
count_array = zeros(1,length_char);
pmf = zeros(1, length_char);

for k = 1:1:length_char
    for m = 1:1:length_string
        if char_x(k) == char_trace(m)
            count_array(k) = count_array(k)+1;
        end
    end
end
count_array = count_array*length_x;
for k = 1:1:length_char
    pmf(k) = count_array(k)/(length_string*length_x);
end
figure;
stem(pmf);
xticks(1:length_char);
str1 = [char_x(:)];
xticklabels(str1);

% Huffman-coding

s = "";

for i=1:length(char_x)
    s(i) = convertCharsToStrings(char_x(i));
end

p = pmf;
i = 1;

for m = 1:length(p)
    for n = 1:length(p)
        if p(m) > p(n)
            a = p(n);
            a1 = s(n);
            p(n) = p(m);
            s(n) = s(m);
            p(m) = a;
            s(m) = a1;
        end
    end
end

s1 = char(s);
totalstr = [""];
w = length(p);
length_p = [w];
str_tree(i,:) = s;
prob_tree(i,:) = p;

while length(p) > 2
    probsum = p(length(p)) + p(length(p)-1);
    strsum = [s(length(s)-1) + s(length(s))];
    totalstr = [totalstr,strsum];
    p = [p(1:length(p)-2)];
    s = [s(1:length(s)-2)];
    flag = 0;
    k = 1;
    while flag == 0
        if probsum <= p(k) && probsum >= p(k+1)
            p = [p(1:(k)), probsum, p(k+1:length(p))];
            s = [s(1:(k)), strsum, s(k+1:length(s))];
            w1 = k;
            flag = 1;
        elseif probsum > p(1)
            p = [probsum, p(1:length(p))];
            s = [strsum, s(1:length(s))];
            w1 = 1;
            flag = 1;
        elseif probsum < p(length(p))
            p = [p(1:length(p)),probsum];
            s = [s(1:length(s)),strsum];
            w1 = length(p);
            flag = 1;
        else
            k=k+1;
        end
    end
    i = i+1;
    prob_tree(i,:) = [p, zeros(1, w-length(p))];
    str_tree(i,:) = [s, zeros(1, w-length(s))];
    length_p = [length_p, length(p)];
end
sizeb(1:2) = size(str_tree);
tempstr = "";
temp2 = [];

for i= 1:sizeb(2)
    temp2 = [temp2,str_tree(1,i)];
end

e=1;
code_array(1,:) = str_tree(1,:);
for ifinal = 1:sizeb(2)
    code1 = [s1(ifinal),':'];
    code2 = [];
    for j = 1:sizeb(1)
        tempstr = "";
        for i1 = 1:sizeb(2)
            if str_tree(j,i1) == temp2(e)
                tempstr = str_tree(j,i1);
            end
            if tempstr == "" && str_tree(j,i1) == totalstr(j)
                tempstr = str_tree(j,i1);
            end
        end
        if tempstr == str_tree(j, length_p(j))
            code2 = [code2,'1'];
        elseif tempstr == str_tree(j, length_p(j)-1)
            code2 = [code2,'0'];
        end
        temp2(e) = tempstr;
    end
    code2 = fliplr(code2);
    code_array(2,e) = code2;
    code_total = [code1,code2];
    display(code_total) %display final codeword
    e = e+1;
end

encoded_out = "";
length_total = length(x)*size_of_str(2);

for k = 1:length_total
    location = find( str_to_char(k) == code_array(1,:));
    encoded_out = encoded_out + code_array(2,location);
end

input_sequence = encoded_out;
disp("Decoded input is: " + huffman_decoder(input_sequence, code_array));


% decode

function [decoded_output] = huffman_decoder(x, codeword_array)

char_input = char(x);
temp_cdword = "";
decoded_output = "";

for i = 1:length(char_input)
   temp_cdword = temp_cdword + convertCharsToStrings(char_input(i));
   location = find( temp_cdword == codeword_array(2,:) );
   if ~isempty(location)
       decoded_output = decoded_output + codeword_array(1,location);
       temp_cdword = "";
   end
end

end