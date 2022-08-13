%{ 
#include <stdio.h>
#include<stdlib.h>
#include<string.h>
int n = 0,line= 0,limit=0; 
char identifiers[100][100];
int identify = 0;
%} 

%% 
\n {line++;}
"#".*">"\n {fprintf(yyout,"\t Preprocessor directory : %s\n",yytext);}
[/]{1}[*]{1}.*[*]{1}[/]{1}\n {fprintf(yyout,"\t MultiLine Comment : %s\n",yytext);}
\"(\\.|[^"\\])*\" {n++,fprintf(yyout,"\t String literal : %s\n",yytext);}

[/]{1}[*]{1}.*\n {fprintf(yyout,"\t error MultiLine Comment : %s\n",yytext);
return 0;}

"//".*\n {fprintf(yyout,"\t single line comment : %s\n",yytext); }

"//".* { fprintf(yyout,"\t error single line comment : %s\n",yytext); }


"while"|"if"|"else"|"for"|"printf"|"scanf"|"return"|"main" {n++;fprintf(yyout,"\t keywords : %s\n", yytext);} 

"int"|"float" {n++;fprintf(yyout,"\t keywords : %s\t", yytext); 
	if(strcmp(yytext, "int") == 0) {
		identify = 1;
	} else if(strcmp(yytext, "float") == 0) {
		
		identify = 1;
	}
}

[a-zA-Z_][a-zA-Z0-9_]* { 
if(identify) {
	fprintf(yyout,"\t identifier : %s\n", yytext);
	strcpy(identifiers[limit], yytext);
      limit++;
} else {
	int k = 0;
	for(int i = 0; i <= limit; i++) {
		if(strcmp(identifiers[i], yytext) == 0) {
			fprintf(yyout,"\t identifier: %s\n", yytext);
			k = 1;
			break;
		}
	}
	if(k == 0) {
			fprintf(yyout,"\t Unrecognized Token: %s\n", yytext);
                  return 0;	
			
		}
} };  

"<="|"=="|"="|"++"|"-"|"*"|"+"|">=" {n++;fprintf(yyout,"\t operator : %s\n", yytext);} 

[(){}|,;] {n++;fprintf(yyout,"\t special symbol : %s\n", yytext); 
if(strcmp(yytext, ";")== 0){
identify = 0;
limit++;
}
if(strcmp(yytext, ",") == 0) {
	limit++;
}
}  

[0-9]*"."[0-9]+ {n++;fprintf(yyout,"\t float : %s\n", yytext);} 

[0-9]+ {n++;fprintf(yyout,"\t integer : %s\n", yytext);}	

. {fprintf(yyout,"");}

%% 

yywrap(){}
int main() 

{ 
	
      extern FILE *yyin, *yyout;
      yyin = fopen("input.txt","r");
      yyout = fopen("output.txt","w");
      yylex(); 
	fprintf(yyout,"\n total no. of token = %d\n", n);
      fclose(yyin);
yyin=fopen("input.txt","r");
int l=1;
int t=0;
int j=0;
int i,flag;
char ch,str[20];

char keyword[30][30] = {"int","main","if","else","do","while","for","printf","scanf"};
fprintf(yyout,"Line no. \t Token no. \t Token \t Lexeme\n\n");
while(!feof(yyin))
{
i=0;
flag=0;
ch=fgetc(yyin);
if(ch=='#')
{
str[i]=ch;
i++;
ch=fgetc(yyin);
while(ch!='>')
{
str[i]=ch;
i++;
ch=fgetc(yyin);
}
str[i++]='>';
str[i]='\0';
fprintf(yyout,"%7d\t\t %7d\t\t Preprocessor directory\t %7s\n",l,t,str);

}

else if(ch=='"')
{
str[i]=ch;
i++;
ch=fgetc(yyin);
while(ch!='"')
{
str[i]=ch;
i++;
ch=fgetc(yyin);
}
str[i++]='"';
str[i]='\0';
fprintf(yyout,"%7d\t\t %7d\t\t String literal\t %7s\n",l,t,str);

}



else if( ch=='+' || ch== '-' || ch=='*' || ch=='/' )
{
fprintf(yyout,"%7d\t\t %7d\t\t Operator\t %7c\n",l,t,ch);
t++;
}
else if( ch==';' || ch=='{' || ch=='}' || ch=='(' || ch==')' || ch=='?' ||
ch=='@' || ch=='!' ||
ch=='%')
{
fprintf(yyout,"%7d\t\t %7d\t\t Special symbol\t %7c\n",l,t,ch);
t++;
}

else if(isdigit(ch))
{
fprintf(yyout,"%7d\t\t %7d\t\t Digit\t\t %7c\n",l,t,ch);
t++;
}

else if(isalpha(ch))
{
str[i]=ch;
i++;
ch=fgetc(yyin);
while(isalnum(ch) && ch!=' ')
{
str[i]=ch;
i++;
ch=fgetc(yyin);
}
str[i]='\0';
for(j=0;j<=30;j++)
{
if(strcmp(str,keyword[j])==0)
{
flag=1;
break;
}
}
if(flag==1)
{
fprintf(yyout,"%7d\t\t %7d\t\t Keyword\t %7s\n",l,t,str);
t++;
}
else
{
fprintf(yyout,"%7d\t\t %7d\t\t Identifier\t %7s\n",l,t,str);
t++;
}

}
else if(ch=='\n')
{
l++;
}
}

return 0;

} 