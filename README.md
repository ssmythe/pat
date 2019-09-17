# pat: project architecture templates cli
This cli is for assembling various git repo templates into usable git repos.

# Requirements
* `pat` will never overwrite files or directories unless you tell it to.
* `pat` will place a `.pat` file in the target directory to indicate it has been processed by `pat`.
* `pat` will skip processing directories that have a `.pat` file in it unless you specify an override.
* `pat` allows you to process individual files or directories by specifying them as an option.
* `pat` allows for multiple source and destination repositories all having unique references.
* `pat` supports github and bitbucket.
* `pat` requires `hub`, `bitbucket-cli`, and `gomplate` to be installed and available in the system path.
* `pat` supports specification processing a single file or a directory structure of files.

# Prerequisites
## hub (if you're using github)
https://github.com/github/hub

### Instructions to initialize hub (if you're using github):

Clone an existing repo you have in your github account.  If you don't have one, just create one with
a README.md file.
```bash
$ hub clone {username}/{repo_name}
```
hub will ask for your github username, then your github password.
Hub will not store this password.  It uses these credentials to establish
a personal access token.

Delete the files you pulled down
```bash
$ rm -fr {repo_name}
``` 

### Instructions to update access token (if you're using github): 
1. Navigate to https://github.com and login
2. Click on your profile icon in the upper left corner to get dropdown list, choose "Settings"
3. Click "Developer settings" on left hand list
4. Click "Personal access tokens"
5. Click on "hub for {username}@{machinename}" link
6. Scroll down on permissions list, and check "delete_repo" permissions
7. Scroll to bottom and click "Update token"

## .netrc/_netrc (if you're not using github)
Please refer to the following article that explains this credential mechanism
https://confluence.atlassian.com/bitbucketserver/permanently-authenticating-with-git-repositories-776639846.html

## gomplate
https://github.com/hairyhenderson/gomplate
https://docs.gomplate.ca/installing/

# Installation
```How to install pat instructions here```

# Specification File
```yaml
variables:
  project: foo
  component: bar
sourcerepos:
  - name: templates
    repo: bitbucket.org/foo/pat_test_templates
destrepos:
  - name: component
    repo: bitbucket.org/foo/pat_test_component
  - name: job_dsl_dev
    repo: bitbucket.org/foo/pat_test_job_dsl_dev
  - name: job_dsl_nonprod
    repo: bitbucket.org/foo/pat_test_job_dsl_nonprod
  - name: job_dsl_prod
    repo: bitbucket.org/foo/pat_test_job_dsl_prod
templates:
  - name: reference
    sourcerepo: templates
    sourcepath: reference_app/bash/
    destrepos: [ component ]
    destpath: ./
  - name: ansible
    sourcerepo: templates
    sourcepath: iasc/ansible_openshift_springboot_service/
    destrepos: [ component ]
    destpath: ansible/
  - name: openshift
    sourcerepo: templates
    sourcepath: iasc/openshift_objects/
    destrepos: [ component ]
    destpath: openshift/
  - name: view
    sourcerepo: templates
    sourcepath: job_dsl/project_view.groovy
    destrepos: [ job_dsl_dev, job_dsl_nonprod, job_dsl_prod ]
    destpath: view-foo.groovy
  - name: job
    sourcerepo: templates
    sourcepath: job_dsl/component_job_echo.groovy
    destrepos: [ job_dsl_dev, job_dsl_nonprod, job_dsl_prod ]
    destpath: job-foo.bar-echo.groovy
```
