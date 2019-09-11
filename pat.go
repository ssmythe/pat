package main

// TODO add --config for user defaults read from file

import (
	"flag"
	"fmt"
	"gopkg.in/yaml.v2"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

type Component struct {
	Variables   map[string]string
	SourceRepos []Repo
	DestRepos   []Repo
	Templates   []Template
}

type Repo struct {
	Name       string
	Repo       string
	Upstream   string
	Branch     string
	Visibility string
}

type Template struct {
	Name       string
	SourceRepo string
	SourcePath string
	DestRepos  []string
	DestPath   string
}

// Globals
const AppVersion = "0.0.23"

var tmpfile string
var user string
var debugMode bool
var commitMode bool

func debug(caller string, message ...string) {
	if debugMode == true {
		log.Println(caller, strings.Join(message, " "))
	}
}

func fatalIfError(caller string, err error) {
	if err != nil {
		log.Fatalf("%v: error: %v", caller, err)
	}
}

func loadSpecFile(path string) Component {
	data, err := ioutil.ReadFile(path)
	fatalIfError("loadSpecFile() ioutil.ReadFile", err)

	c := Component{}

	err = yaml.Unmarshal(data, &c)
	fatalIfError("loadSpecFile() yaml.Unmarshall", err)

	return c
}

func createTempVarsFile(tmpfile string, data Component) {
	content, err := yaml.Marshal(data.Variables)
	fatalIfError("createTempVarsFile() yaml.Marshal", err)

	err = ioutil.WriteFile(tmpfile, content, 0644)
	fatalIfError("createTempVarsFile() ioutil.WriteFile", err)
}

func deleteTempVarsFile(tmpfile string) {
	err := os.Remove(tmpfile)
	fatalIfError("deleteTempVarsFile() os.Remove", err)
}

func runCommand(caller string, cmdDir string, command string, args ...string) {
	debug("runCommand()", "cmdDir=["+cmdDir+"] running=["+command+" "+strings.Join(args, " ")+"]")
	cmd := exec.Command(command, args...)
	cmd.Dir = cmdDir
	err := cmd.Run()
	fatalIfError(caller, err)
}

func runCommandIgnoreError(cmdDir string, command string, args ...string) {
	debug("runCommandIgnoreError()", "cmdDir=["+cmdDir+"] running=["+command+" "+strings.Join(args, " ")+"]")
	cmd := exec.Command(command, args...)
	cmd.Dir = cmdDir
	_ = cmd.Run()
}

func createRepo(repoURL string, repoName string, visibility string, workDir string) {
	r := strings.Split(repoURL, "/")
	//provider := r[0]
	owner := r[1]
	repo := r[2]

	visflag := ""
	if visibility == "private" {
		visflag = "-p"
	}

	if _, err := os.Stat(workDir + "/" + repoName); os.IsNotExist(err) {
		targetDir := workDir + "/" + repoName
		err = os.MkdirAll(workDir+"/"+repoName, 0755)
		fatalIfError("createRepo() os.MkdirAll", err)
		fmt.Println("Creating repo:", repoName)
		runCommand("createRepo() cmd.Run hub init", targetDir, "hub", "init")
		runCommand("createRepo() cmd.Run hub create", targetDir, "hub", "create", visflag, owner+"/"+repo, repoName)
		runCommand("createRepo() cmd.Run hub remote add", targetDir, "hub", "remote", "add", owner+"/"+repo)

		err := ioutil.WriteFile(targetDir+"/README.md", []byte("# Welcome to "+repoName+"!\nRepo created by pat\n"), 0644)
		fatalIfError("addPatFile() ioutil.WriteFile", err)
		runCommand("createRepo() cmd.Run git add README.md", targetDir, "git", "add", "README.md")
		runCommand("createRepo() cmd.Run git add README.md", targetDir, "git", "commit", "-m", "Add README.md")
		runCommand("createRepo() cmd.Run hub push", targetDir, "hub", "push", "origin", "master")
	}
}

func cloneRepo(repoURL string, repoName string, upstream string, branch string, visibility string, workDir string) {
	r := strings.Split(repoURL, "/")
	provider := r[0]
	owner := r[1]
	repo := r[2]
	if _, err := os.Stat(workDir + "/" + repoName); os.IsNotExist(err) {
		fmt.Println("Cloning repo:", repoName)
		cmd := exec.Command("echo", "hello")
		if provider == "github.com" {
			cmd = exec.Command("hub", "clone", owner+"/"+repo, repoName)
		} else {
			cmd = exec.Command("git", "clone", "https://"+user+"@"+provider+"/"+owner+"/"+repo+".git", repoName)
		}
		cmd.Dir = workDir
		err := cmd.Run()
		if err != nil {
			fmt.Println("...can't find", repoName)
			if provider == "github.com" {
				createRepo(repoURL, repoName, visibility, workDir)
			} else {
				fmt.Println("Please manually create repo:", repoName)
				fatalIfError("cloneRepo() provider="+provider, err)
			}
		}
	}
	fmt.Println("Switching to branch:", repoName, branch)
	if upstream != branch {
		runCommandIgnoreError(workDir+"/"+repoName, "git", "checkout", upstream)
		runCommandIgnoreError(workDir+"/"+repoName, "git", "checkout", "-b", branch)
	}
	runCommand("cloneRepo() git checkout "+branch, workDir+"/"+repoName, "git", "checkout", branch)
	fmt.Println("Pulling repo:", repoName, "branch:", branch)
	if provider == "github.com" {
		runCommand("cloneRepo() hub pull origin "+branch, workDir+"/"+repoName, "hub", "pull", "origin", branch)
	} else {
		runCommand("cloneRepo() git clean -d -x -f", workDir+"/"+repoName, "git", "clean", "-d", "-x", "-f")
		runCommand("cloneRepo() git pull origin "+branch, workDir+"/"+repoName, "git", "pull", "origin", branch)
	}
}

func pushRepo(repoURL string, repoName string, branch string, workDir string) {
	r := strings.Split(repoURL, "/")
	provider := r[0]

	targetDir := workDir + "/" + repoName
	fmt.Println("Add files repo:", repoName)
	if provider == "github.com" {
		runCommand("pushRepo() hub add .", targetDir, "hub", "add", ".")
	} else {
		runCommand("pushRepo() git add .", targetDir, "git", "add", ".")
	}

	if commitMode == true {
		fmt.Println("Commit files repo:", repoName)
		cmd := exec.Command("echo", "hello")
		if provider == "github.com" {
			cmd = exec.Command("hub", "commit", "-m", "Adding files from pat")
		} else {
			cmd = exec.Command("git", "commit", "-m", "Adding files from pat")
		}
		cmd.Dir = targetDir
		err := cmd.Run()
		if err == nil {
			fmt.Println("Pushing repo:", repoName)
			if provider == "github.com" {
				runCommand("pushRepo() hub push origin "+branch, targetDir, "hub", "push", "origin", branch)
			} else {
				runCommand("pushRepo() git push origin "+branch, targetDir, "git", "push", "origin", branch)
			}
		} else {
			fmt.Println("...no new files to push:", repoName)
		}
	}
}

func isPathADir(path string) bool {
	if path[len(path)-1:] == "/" {
		return true
	}
	return false
}

// TODO test if files are actually getting removed, not just dirs
func removeContentsExcludeGit(dir string) error {
	d, err := os.Open(dir)
	if err != nil {
		return err
	}
	defer func() {
		err := d.Close()
		fatalIfError("removeContentsExcludeGit() func() d.Close", err)
	}()
	names, err := d.Readdirnames(-1)
	if err != nil {
		return err
	}
	for _, name := range names {
		if name != ".git" {
			err = os.RemoveAll(filepath.Join(dir, name))
			if err != nil {
				return err
			}
		}
	}
	return nil
}

func removeDirContents(dir string) {
	err := removeContentsExcludeGit(dir)
	fatalIfError("removeDirContents() removeContentsExcludeGit", err)
}

func callGomplate(workDir string, sourcePath string, destPath string, varsFile string, leftDelim string, rightDelim string, inputOpt string, outputOpt string, gomplateArgs string) {
	context := ".=" + varsFile
	args := []string{inputOpt, workDir + "/" + sourcePath, outputOpt, workDir + "/" + destPath, "-c", context, "--left-delim", leftDelim, "--right-delim", rightDelim}
	if gomplateArgs != "" {
		args = append(args, strings.Fields(gomplateArgs)...)
	}
	debug("callComplate(): running: gomplate", args...)
	cmd := exec.Command("gomplate", args...)
	err := cmd.Run()
	fatalIfError("callGomplate() cmd.Run", err)
}

func isFileNotExist(filepath string) bool {
	if _, err := os.Stat(filepath); os.IsNotExist(err) {
		return true
	}
	return false
}

func isPatFileNotExist(patfilepath string) bool {
	return isFileNotExist(patfilepath + "/.pat")
}

func addPatFile(patfilepath string) {
	fmt.Println("Adding .pat file to:", filepath.Clean(patfilepath))
	content := []byte("")
	if isPatFileNotExist(patfilepath) {
		err := ioutil.WriteFile(patfilepath+"/.pat", content, 0644)
		fatalIfError("addPatFile() ioutil.WriteFile", err)
	}
}

func processTemplate(workDir string, sourceRepo string, sourcePath string, destRepo string, destPath string, varsFile string, leftDelim string, rightDelim string, force bool, gomplateArgs string) {
	if isPathADir(sourcePath) {
		targetDir := filepath.Clean(workDir + "/" + destRepo + "/" + destPath)
		if isPatFileNotExist(targetDir) || force == true {
			removeDirContents(filepath.Clean(targetDir))
			callGomplate(workDir, sourceRepo+"/"+sourcePath, destRepo+"/"+destPath, varsFile, leftDelim, rightDelim, "--input-dir", "--output-dir", gomplateArgs)
			addPatFile(targetDir)
		} else {
			fmt.Println(".pat file exists, skipping", targetDir)
		}
	} else {
		targetFile := filepath.Clean(workDir + "/" + destRepo + "/" + destPath)
		if isFileNotExist(targetFile) || force == true {
			callGomplate(workDir, sourceRepo+"/"+sourcePath, destRepo+"/"+destPath, varsFile, leftDelim, rightDelim, "--file", "--out", gomplateArgs)
		} else {
			fmt.Println("File already exists:", targetFile)
		}
	}
}

func stringInSlice(a string, list []string) bool {
	for _, b := range list {
		if b == a {
			return true
		}
	}
	return false
}

func isTemplateInForceTemplates(template string, forceTemplates string) bool {
	result := false

	if forceTemplates == "*" {
		result = true
	} else {
		templates := strings.Split(forceTemplates, ",")
		if stringInSlice(template, templates) {
			result = true
		}
	}

	return result
}

func main() {
	forceTemplates := flag.String("force", "", "Comma separated list of templates to overwrite, use --force=* for all templates")
	specFile := flag.String("spec", "", "The path to spec file")
	workDir := flag.String("work", ".", "The path to working directory to process")
	localMode := flag.Bool("local", false, "Local mode: do not interact with remote git repo")
	userName := flag.String("user", "", "Username on git HTTP URL before @servicename")
	version := flag.Bool("version", false, "Display current application version")
	leftDelim := flag.String("left-delim", "{x{", "override the default left-delimiter")
	rightDelim := flag.String("right-delim", "}x}", "override the default right-delimiter")
	gomplateArgs := flag.String("gomplate-args", "", "additional gomplate args")
	debugFlag := flag.Bool("debug", false, "output extra information about what pat is doing")
	commitFlag := flag.Bool("commit", false, "git commit and push changes")
	flag.Parse()

	if *version {
		fmt.Println("pat version " + AppVersion)
		os.Exit(0)
	}

	tmpfile = "pat_tmp_vars.yml"
	user = *userName
	debugMode = *debugFlag
	commitMode = *commitFlag

	y := loadSpecFile(*specFile)
	createTempVarsFile(tmpfile, y)

	if *localMode == false {
		for r := range y.SourceRepos {
			cloneRepo(y.SourceRepos[r].Repo, y.SourceRepos[r].Name, y.SourceRepos[r].Upstream, y.SourceRepos[r].Branch, y.SourceRepos[r].Visibility, *workDir)
		}
		for r := range y.DestRepos {
			cloneRepo(y.DestRepos[r].Repo, y.DestRepos[r].Name, y.DestRepos[r].Upstream, y.DestRepos[r].Branch, y.DestRepos[r].Visibility, *workDir)
		}
	}

	for t := range y.Templates {
		name := y.Templates[t].Name
		sourceRepo := y.Templates[t].SourceRepo
		sourcePath := y.Templates[t].SourcePath
		destRepos := y.Templates[t].DestRepos
		destPath := y.Templates[t].DestPath
		force := isTemplateInForceTemplates(name, *forceTemplates)
		for r := range destRepos {
			destRepo := destRepos[r]
			fmt.Println("Processing template:", name)
			destFullPath := *workDir + "/" + destRepo + "/" + destPath
			if isPathADir(destFullPath) {
				err := os.MkdirAll(destFullPath, 0755)
				fatalIfError("main() isPathADir=true os.MkdirAll", err)
				processTemplate(*workDir, sourceRepo, sourcePath, destRepo, destPath, tmpfile, *leftDelim, *rightDelim, force, *gomplateArgs)
			} else {
				targetDir := filepath.Dir(destFullPath)
				if !isPathADir(targetDir) {
					fmt.Println("Creating dir:", targetDir)
					err := os.MkdirAll(targetDir, 0755)
					fatalIfError("main() isPathADir=false os.MkdirAll", err)
				}
				processTemplate(*workDir, sourceRepo, sourcePath, destRepo, destPath, tmpfile, *leftDelim, *rightDelim, force, *gomplateArgs)
			}
		}
	}

	if *localMode == false {
		for r := range y.DestRepos {
			pushRepo(y.DestRepos[r].Repo, y.DestRepos[r].Name, y.DestRepos[r].Branch, *workDir)
		}
	}

	deleteTempVarsFile(tmpfile)
}
