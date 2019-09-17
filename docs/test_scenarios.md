# Test Scenarios

Permutations
```
Single spec file
Multiple spec files

Single source repo
Multiple source repos

Single dest repo
Multiple dest repos

Github provider
Bitbucket provider

Positive cases
Negative cases

Write once
Overwrite
```

Dir Tests
```
New repo doesn't exist
New repo exists, unpopulated
New repo exists, unpopulated with .pat file in root
New repo exists, unpopulated with .pat file in root, subdirectory doesn't exist
New repo exists, unpopulated with .pat file in root, subdirectory exists and unpopulated
New repo exists, unpopulated with .pat file in root, subdirectory exists and populated with .pat file
```

File Tests
```
New repo doesn't exist
New repo exists, unpopulated
New repo exists, populated and file doesn't exist
New repo exists, populated and file exists
```

# File Testing
## Scenario 001
Permutation:
- single spec file, single source repo, single dest repo, github provider, positive case, write once

File Test:
- New repo doesn't exist

## Scenario 002
Permutation:
- single spec file, single source repo, single dest repo, github provider, positive case, write once

File Test:
- New repo exists, populated and file exists

Notes:
- Create file, and process it again with a different template value, no overwrite

## Scenario 003
Permutation:
- single spec file, single source repo, single dest repo, github provider, positive case, overwrite

File Test:
- New repo exists, populated and file exists

Notes:
- Create file, and process it again with a different template value with overwrite template flag, overwrite

## Scenario 004
Permutation:
- single spec file, single source repo, single dest repo, github provider, positive case, overwrite

File Test:
- New repo exists, populated and file exists

Notes:
- Create file, and process it again with a different template value with overwrite template * flag, overwrite

# Dir Testing
## Scenario 005
Permutation:
- single spec file, single source repo, single dest repo, github provider, positive case, write once

Dir Test:
- New repo doesn't exist

## Scenario 006
Permutation:
- single spec file, single source repo, single dest repo, github provider, positive case, write once

Dir Test:
- New repo exists, populated with .pat file in root

Notes:
- Create file, and process it again with a different template value, no overwrite

## Scenario 007
Permutation:
- single spec file, single source repo, single dest repo, github provider, positive case, overwrite

Dir Test:
- New repo exists, populated with .pat file in root

Notes:
- Create file, and process it again with a different template value with overwrite template flag, overwrite

## Scenario 008
Permutation:
- single spec file, single source repo, single dest repo, github provider, positive case, write once

Dir Test:
- New repo exists, populated with .pat file in root

Notes:
- Create file, and process it again with a different template value with overwrite template * flag, overwrite

# File Testing
## Scenario 009
Permutation:
- single spec file, single source repo, multiple dest repos, github provider, positive case, write once

Dir Test:
- New repo doesn't exist

## Scenario 010
Permutation:
- single spec file, single source repo, multiple dest repos, github provider, positive case, write once

File Test:
- New repo exists, populated and file exists

Notes:
- Create file, and process it again with a different template value, no overwrite

## Scenario 011
Permutation:
- single spec file, single source repo, multiple dest repos, github provider, positive case, overwrite

File Test:
- New repo exists, populated and file exists

Notes:
- Create file, and process it again with a different template value with overwrite template flag, overwrite

## Scenario 012
Permutation:
- single spec file, single source repo, multiple dest repos, github provider, positive case, overwrite

File Test:
- New repo exists, populated and file exists

Notes:
- Create file, and process it again with a different template value with overwrite template * flag, overwrite

# Dir Testing
# Scenario 013
Permutation:
- single spec file, single source repo, multiple dest repos, github provider, positive case, write once

Dir Test:
- New repo doesn't exist

## Scenario 014
Permutation:
- single spec file, single source repo, multiple dest repos, github provider, positive case, write once

Dir Test:
- New repo exists, populated with .pat file in root

Notes:
- Create file, and process it again with a different template value, no overwrite

## Scenario 015
Permutation:
- single spec file, single source repo, multiple dest repos, github provider, positive case, overwrite

Dir Test:
- New repo exists, populated with .pat file in root

Notes:
- Create file, and process it again with a different template value with overwrite template flag, overwrite

## Scenario 016
Permutation:
- single spec file, single source repo, multiple dest repos, github provider, positive case, write once

Dir Test:
- New repo exists, populated with .pat file in root

Notes:
- Create file, and process it again with a different template value with overwrite template * flag, overwrite

# Larger Tests
## Scenario 017
Similar to real world scenario with multiple templates merging into a single repo, and other files into other repos.

# Data Sources
## Scenario 18
Use datasource for complex data structures to expand iterative template

# Branch Tests
## Scenario 101
upstream: master, branch: feature (new branch)

## Scenario 102
upstream: master, branch: feature (new existing branch)

# Locked Tests
## Scenario 201
New repo, template locked, no file created

## Scenario 202
Existing repo, template locked, file not updated

## Scenario 203
Existing repo, template locked, force update, file not updated
