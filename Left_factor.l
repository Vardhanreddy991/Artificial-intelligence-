%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAXP 50
#define MAXL 200

char lhs;
char prod[MAXP][MAXL];
int n;

/* left factoring logic */
void left_factor()
{
    char prefix[MAXL];
    int i, j;

    strcpy(prefix, prod[0]);

    for (i = 1; i < n; i++)
    {
        j = 0;
        while (prefix[j] && prod[i][j] &&
               prefix[j] == prod[i][j])
            j++;
        prefix[j] = '\0';
    }

    if (strlen(prefix) == 0)
    {
        printf("\nLeft factoring not required:\n");
        printf("%c -> ", lhs);
        for (i = 0; i < n; i++)
        {
            printf("%s", prod[i]);
            if (i != n - 1) printf(" | ");
        }
        printf("\n");
        return;
    }

    printf("\nAfter Left Factoring:\n");
    printf("%c -> %s%c'", lhs, prefix, lhs);

    int extra = 0;
    for (i = 0; i < n; i++)
        if (strncmp(prod[i], prefix, strlen(prefix)) != 0)
            extra = 1;

    if (extra)
    {
        printf(" | ");
        for (i = 0; i < n; i++)
            if (strncmp(prod[i], prefix, strlen(prefix)) != 0)
                printf("%s | ", prod[i]);
        printf("\b\b ");
    }

    printf("\n%c' -> ", lhs);

    for (i = 0; i < n; i++)
    {
        if (strncmp(prod[i], prefix, strlen(prefix)) == 0)
        {
            char *rem = prod[i] + strlen(prefix);
            if (*rem == '\0')
                printf("#");
            else
                printf("%s", rem);
            printf(" | ");
        }
    }
    printf("\b\b \n");
}
%}

%%
[A-Z]"->"[^\n]+   {
    char rhs[MAXL];
    char *tok;

    n = 0;
    lhs = yytext[0];

    strcpy(rhs, strchr(yytext, '>') + 1);

    tok = strtok(rhs, "|");
    while (tok != NULL)
    {
        strcpy(prod[n++], tok);
        tok = strtok(NULL, "|");
    }

    left_factor();
}
%%
int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        printf("Usage: a.out <cfgfile>\n");
        return 0;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin)
    {
        printf("Cannot open file\n");
        return 0;
    }

    yylex();
    return 0;
}

int yywrap()
{
    return 1;
}
