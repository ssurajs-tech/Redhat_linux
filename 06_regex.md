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

## Basic and Extended Regular Expression Syntax

Regular expressions come in two main flavors in Unix/Linux: Basic (BRE) and Extended (ERE). The table below summarizes the main syntax differences and provides descriptions and examples for each construct.

| Basic Syntax | Extended Syntax | Description | Example | Example Explanation |
|--------------|----------------|-------------|---------|--------------------|
| `.` | `.` | Matches any single character except newline. | `gr.p` | Matches "grep", "grap", "gr9p", etc. |
| `?` | `?` | The preceding item is optional and is matched at most once (only ERE). | `colou?r` | Matches "color" and "colour" (ERE: `grep -E 'colou?r' file`) |
| `*` | `*` | The preceding item is matched zero or more times. | `lo*l` | Matches "ll", "lol", "lool", etc. |
| `\+` | `+` | The preceding item is matched one or more times. | `go\+gle` (BRE) <br> `go+gle` (ERE) | Matches "gogle", "google", "gooogle", etc. |
| `\{n\}` | `{n}` | The preceding item is matched exactly n times. | `a\{3\}` (BRE) <br> `a{3}` (ERE) | Matches "aaa" |
| `\{n,\}` | `{n,}` | The preceding item is matched n or more times. | `b\{2,\}` (BRE) <br> `b{2,}` (ERE) | Matches "bb", "bbb", "bbbb", etc. |
| `\{,m\}` | `{,m}` | The preceding item is matched at most m times. | `c\{,2\}` (BRE) <br> `c{,2}` (ERE) | Matches "", "c", "cc" |
| `\{n,m\}` | `{n,m}` | The preceding item is matched at least n times, but not more than m times. | `d\{1,3\}` (BRE) <br> `d{1,3}` (ERE) | Matches "d", "dd", "ddd" |
| `[:alnum:]` | `[:alnum:]` | Alphanumeric characters: `[A-Za-z0-9]` | `[[:alnum:]]` | Matches any letter or digit |
| `[:alpha:]` | `[:alpha:]` | Alphabetic characters: `[A-Za-z]` | `[[:alpha:]]` | Matches any letter |
| `[:blank:]` | `[:blank:]` | Blank characters: space and tab | `[[:blank:]]` | Matches space or tab |
| `[:cntrl:]` | `[:cntrl:]` | Control characters (ASCII 0-31, 127) | `[[:cntrl:]]` | Matches non-printable control chars |
| `[:digit:]` | `[:digit:]` | Digits: `[0-9]` | `[[:digit:]]` | Matches any digit |
| `[:graph:]` | `[:graph:]` | Graphical (printable, not space) | `[[:graph:]]` | Matches visible, non-space chars |
| `[:lower:]` | `[:lower:]` | Lowercase letters: `[a-z]` | `[[:lower:]]` | Matches any lowercase letter |
| `[:print:]` | `[:print:]` | Printable (including space) | `[[:print:]]` | Matches any printable char |
| `[:punct:]` | `[:punct:]` | Punctuation characters | `[[:punct:]]` | Matches punctuation marks |
| `[:space:]` | `[:space:]` | Whitespace: space, tab, newline, etc. | `[[:space:]]` | Matches any whitespace char |
| `[:upper:]` | `[:upper:]` | Uppercase letters: `[A-Z]` | `[[:upper:]]` | Matches any uppercase letter |
| `[:xdigit:]` | `[:xdigit:]` | Hexadecimal digits: `[0-9A-Fa-f]` | `[[:xdigit:]]` | Matches hex digits |
| `\b` | `\b` | Match at word boundary (PCRE/grep -P) | `\bcat\b` | Matches "cat" as a whole word |
| `\B` | `\B` | Not at word boundary (PCRE/grep -P) | `\Bcat\B` | Matches "cat" inside words |
| `\<` | `\<` | Beginning of word (BRE) | `\<cat` | Matches "cat" at word start |
| `\>` | `\>` | End of word (BRE) | `cat\>` | Matches "cat" at word end |
| `\w` | `\w` | Word character: `[A-Za-z0-9_]` (PCRE/grep -P) | `\w+` | Matches words |
| `\W` | `\W` | Non-word character (PCRE/grep -P) | `\W+` | Matches non-word chars |
| `\s` | `\s` | Whitespace (PCRE/grep -P) | `\s+` | Matches spaces, tabs, etc. |
| `\S` | `\S` | Non-whitespace (PCRE/grep -P) | `\S+` | Matches non-space chars |

### Notes and Examples

- **Period (`.`):**  
  Matches any single character except newline.  
  Example:  
  ```bash
  grep 'c.t' file
  ```
  Matches "cat", "cut", "cot", etc.

- **Asterisk (`*`):**  
  Matches zero or more occurrences of the preceding character.  
  Example:  
  ```bash
  grep 'lo*l' file
  ```
  Matches "ll", "lol", "lool", etc.

- **Plus (`+`):**  
  In BRE, use `\+`; in ERE, just `+`. Matches one or more occurrences.  
  Example:  
  ```bash
  grep -E 'go+gle' file
  ```
  Matches "gogle", "google", "gooogle", etc.

- **Curly Braces (`{n,m}`):**  
  In BRE, escape with backslashes: `\{n,m\}`. In ERE, just `{n,m}`.  
  Example:  
  ```bash
  grep -E 'a{2,4}' file
  ```
  Matches "aa", "aaa", "aaaa".

- **Character Classes (`[[:digit:]]`, `[[:alpha:]]`, etc.):**  
  Use within brackets to match sets of characters.  
  Example:  
  ```bash
  grep '[[:digit:]]' file
  ```
  Matches any line containing a digit.

- **Word Boundaries (`\b`, `\<`, `\>`):**  
  `\b` is supported in Perl-compatible regex (grep -P).  
  `\<` and `\>` are for word start/end in BRE.  
  Example:  
  ```bash
  grep '\<cat\>' file
  ```
  Matches "cat" as a whole word.

- **Whitespace (`\s`, `[[:space:]]`):**  
  `\s` is Perl-compatible; `[[:space:]]` is POSIX.  
  Example:  
  ```bash
  grep '[[:space:]]' file
  ```
  Matches any whitespace character.

- **Alphanumeric (`[[:alnum:]]`):**  
  Matches any letter or digit.  
  Example:  
  ```bash
  grep '[[:alnum:]]' file
  ```
  Matches lines with at least one alphanumeric character.

- **Punctuation (`[[:punct:]]`):**  
  Matches any punctuation character.  
  Example:  
  ```bash
  grep '[[:punct:]]' file
  ```
  Matches lines with punctuation.

#### Practical Usage

- Use `grep -E` for extended regular expressions (no need to escape `+`, `?`, `{}`).
- Use `grep -P` for Perl-compatible regular expressions (enables `\b`, `\w`, `\s`, etc.).
- Use character classes for locale-aware matching (e.g., `[[:alpha:]]` for letters in any language supported by your locale).

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