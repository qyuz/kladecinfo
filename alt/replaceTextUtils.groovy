import java.util.regex.Matcher
import java.lang.reflect.Array
import groovy.transform.Field

@Field Map<String, String[]> extensionComment = [xsl: ["<!--", "-->"], xq: ["(:", ":)"]]

def matchFiles(dirs) {
    return matchFiles(dirs, null)
}

def matchFiles(dirs, matches) {
    dirs.inject(new ArrayList()) { init, item ->
        new File(item).eachFileRecurse { file ->
            if (matches != null) {
                matches.each {
                    if (file.getName() =~ it) {
                        init << file.absolutePath
                    }
                }
            } else {
                init << file.absolutePath
            }
        }
        return init
    }
}

def getTemplateConfigs(filePaths) {
    def templateConfigs = filePaths.inject(new ArrayList()) { init, filePath ->
        File templateFile = new File(filePath)
        String templateFileText = templateFile.getText()
        String templateName = templateFile.getName().replaceAll("(.*)\\..*", "\$1")
        Matcher templateMatcher = templateFileText =~ "(Template Config((\r\n)|\r|\n)(.*)((\r\n)|\r|\n))?Template Text((\r\n)|\r|\n)(.*(.*((\r\n)|\r|\n)*)+)"
        String template = templateMatcher[0][9]
        String templateConfig = templateMatcher[0][4]
        Object config = templateConfig != null ? evaluate(templateConfig) : null
//        println templateMatcher[0]
        init << [name: templateName, config: config, text: template]
        return init
    }
    return templateConfigs
}

def replaceTemplates(templateConfigs, replaceFilePaths) {
    return replaceTemplates(templateConfigs, replaceFilePaths, null)
}

def replaceTemplates(templateConfigs, replaceFilePaths, prepareReplace) {
    templateConfigs.each { templateConfig ->
        replaceFilePaths.each { replaceFilePath ->
            replaceTemplate(templateConfig, replaceFilePath, prepareReplace)
        }
    }
}

def replaceTemplate(templateConfig, replaceFilePath, prepareReplace) {
    Matcher matcher = replaceFilePath =~ ".*\\.(.*)"
    String replaceFileExtension = matcher[0][1]
    String start = String.format("%s ReplaceTemplate %s Start %s", extensionComment[replaceFileExtension][0], templateConfig.name, extensionComment[replaceFileExtension][1])
    String end = String.format("%s ReplaceTemplate %s End %s", extensionComment[replaceFileExtension][0], templateConfig.name, extensionComment[replaceFileExtension][1])
    File replaceFile = new File(replaceFilePath)
    String replaceFileText = replaceFile.getText("UTF-8")
    if (replaceFileText.contains(start)) {
        println String.format("[File: %s] contains [template: %s]", replaceFilePath, templateConfig.name)
        assert replaceFileText.contains(end), String.format("[Template: %s] in [file: %s] doesn't have the end tag", templateConfig.name, replaceFilePath)
        String replace = prepareReplace != null ? prepareReplace(templateConfig, replaceFilePath) : templateConfig.text
        String replacedText = "" + replaceFileText.substring(0, replaceFileText.indexOf(start) + start.length()) + "\r\n" + replace + "\r\n" + replaceFileText.substring(replaceFileText.indexOf(end))
//                println replacedText
        replaceFile.setText(replacedText, "UTF-8")
    }
}


def replaceTextAndSet(filePath, match, replace, newFilePath) {
    File file = newFilePath != null ? new File(newFilePath) : new File(filePath)
    file.setText(replaceText(filePath, match, replace), "UTF-8")
}

def replaceTextAndSet(filePath, match, replace) {
    replaceTextAndSet(filePath, match, replace, null)
}

def replaceText(filePath, match, replace) {
    File file = new File(filePath)
    String text = file.getText("UTF-8")
    text.replaceAll(match, replace)
}

def copyFile(sourcePath, targetPath) {
    File targetFile = new File(targetPath)
    createDirectory(targetPath)
    targetFile.setText(new File(sourcePath).getText("UTF-8"), "UTF-8")
}

def getExistingParentDirectory(filePath) {
    File file = new File(filePath)
    return file.isDirectory() == true ? file : getDirectory(file.getParent())
}

def createDirectory(filePath) {
    File file = new File(filePath)
    File directory = file.getParentFile()
    directory.mkdirs()
}

def safeReplaceAll(string, match, replace) {
    return string.replaceAll(Matcher.quoteReplacement(match), Matcher.quoteReplacement(replace))
}















