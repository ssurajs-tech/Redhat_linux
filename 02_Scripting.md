# Match Text in Command Output with Regular Expressions

## Objectives
- Create regular expressions to match data.
- Apply regular expressions to text files with the grep command.
- Use grep to search files and data from piped commands.
- Understand anchors, character classes, quantifiers, grouping and alternation.
- Learn differences between Basic, Extended and Perl-compatible regular expressions.
- Learn practical tips for quoting, performance and debugging patterns.

---

## Introduction and overview

Regular expressions (often abbreviated "regex") are a compact language for describing patterns in text. They are used by many Unix/Linux utilities (grep, sed, awk, perl, python, vim) to search, match, extract and transform text. This document preserves the original material and expands it with detailed explanations, worked examples, practical tips and exercises so it can be used as a comprehensive GitHub page for learning and reference.

This page focuses on POSIX Basic Regular Expressions (BRE) and Extended Regular Expressions (ERE) as encountered with common shell tools, plus notes on Perl-Compatible Regular Expressions (PCRE) where supported (grep -P or pcregrep).

---

## Basic concepts — exact matches and examples

A regular expression can be as simple as a literal string. Given this example file (lines shown):

cat
dog
concatenate
dogma
category
educated
boondoggle
vindication
chilidog

- The pattern `cat` will match any line that contains the substring `cat`, so it finds `cat`, `concatenate`, `category`, `educated`, `vindication`, and `chilidog`.
- To match only lines that are exactly the word `cat`, anchor the pattern with `^` and `$`: `^cat$`.

---

## Anchors: beginning and end of line

- `^pattern` — match pattern at beginning of line.
- `pattern$` — match pattern at end of line.
- `^pattern$` — match the entire line exactly.

Examples:
````bash
# Only lines beginning with "cat"
grep '^cat' file

# Only lines ending with "dog"
grep 'dog$' file

# Only lines that are exactly "cat"
grep '^cat$' file
````

---

## Character classes: sets of characters

- `[abc]` — match any one of the characters a, b, or c.
- `[^abc]` — match any character except a, b, or c.
- `[a-z]` — match any lowercase letter.
- `[A-Z]` — match any uppercase letter.
- `[0-9]` — match any digit.

Examples:
````bash
# Lines with "cat", "cot", or "cut"
grep '[cC][aou]t' file

# Lines with "dog" but not "dogma"
grep 'dog[^ma]' file

# Lines with a digit
grep '[0-9]' file
````

---

## Quantifiers: specifying number of occurrences

- `n` — match exactly n occurrences of the previous element.
- `n,` — match n or more occurrences of the previous element.
- `,m` — match up to m occurrences of the previous element.
- `n,m` — match between n and m occurrences of the previous element.
- `*` — match zero or more occurrences of the previous element.
- `+` — match one or more occurrences of the previous element.
- `?` — match zero or one occurrence of the previous element.

Examples:
````bash
# Lines with "c" followed by exactly 3 characters and then "t"
grep 'c.t\{3\}' file

# Lines with "a" followed by 2 to 4 "b"s and then "c"
grep 'ab\{2,4\}c' file

# Lines with "x" occurring 0 or more times
grep 'x*' file

# Lines with "y" occurring 1 or more times
grep 'y+' file

# Lines with "z" occurring 0 or 1 time
grep 'z?' file
````

---

## Grouping and alternation: sub-patterns and choices

- `(abc)` — match the exact sequence abc.
- `a|b` — match either a or b.

Examples:
````bash
# Lines with "foo" or "bar"
grep 'foo\|bar' file

# Lines with "start" followed by "end"
grep 'start\(end\)' file

# Lines with "cat" or "dog" at the beginning
grep '^\(cat\|dog\)' file
````

---



## Practical tips

- To search recursively in directories, use `grep -r 'pattern' directory`.
- To ignore case, use `grep -i 'pattern' file`.
- To show line numbers with matches, use `grep -n 'pattern' file`.
- To match whole words, use `grep -w 'word' file`.
- To use extended regex features, use `grep -E 'pattern' file`.

---

## Exercises

1. Given a file with lines of text, write a regex to find lines that contain email addresses.
2. Write a regex to match lines that start with a timestamp in the format `[YYYY-MM-DD HH:MM:SS]`.
3. Given a file of URLs, write a regex to extract the domain names.
4. Write a regex to find lines that contain a valid IPv4 address.
5. Given a log file, write a regex to extract all unique error codes.

---

## Conclusion

Regular expressions are a powerful tool for text processing. Mastery of regex syntax and concepts enables efficient and flexible text searching, matching, and manipulation in various Unix/Linux utilities and programming languages. Practice and experimentation with real-world text data and regex patterns solidify understanding and proficiency in using regular expressions effectively.