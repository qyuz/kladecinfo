import java.util.regex.Matcher
import java.lang.reflect.Array
import groovy.lang.GroovyShell
scriptDir = new File(getClass().protectionDomain.codeSource.location.path).parent + "\\"
evaluate(new File(scriptDir + "importReplaceTextUtils.groovy"))
evaluate(new File("D:\\dropbox\\Dropbox\\nis\\persister\\" + "configCore.txt"))

def nisReplaceFileName(filePath, matchName, replaceName) {
    return replaceTextUtils.safeReplaceAll(filePath, corePath, targetPath).replaceAll(matchName, replaceName)
}

def nisCopyAndRenameAndReplace(initialName, matchFiles, replaceNames, matchContent) {
    nisCopyAndRenameAndReplaceAndSchema(initialName, matchFiles, replaceNames, matchContent, null)
}

def nisCopyAndRenameAndReplaceAndSchema(initialName, matchFiles, replaceNames, matchContent, matchReplaceSchema) {
    replaceNames.each { replaceName ->
        nisCopyAndRename( initialName + matchFiles, replaceName + '$1')
        nisReplaceText(replaceName + matchFiles, matchContent + initialName, '$1' + replaceName)
        if(matchReplaceSchema != null && matchReplaceSchema[0] != null && matchReplaceSchema[1] != null) {
            nisReplaceText(replaceName + matchFiles, matchReplaceSchema[0], matchReplaceSchema[1])
        }
    }
}


def nisCopyAndRename(match, replace) {
    def matchedPaths = replaceTextUtils.matchFiles([corePath], [ "^" + match])
    println matchedPaths
    matchedPaths.each { filePath ->
        replaceTextUtils.copyFile(filePath, nisReplaceFileName(filePath, match, replace))
    }
}


def nisReplaceText(filesMatch, matchText, replaceText) {
    def files = replaceTextUtils.matchFiles([targetPath], [ "^" + filesMatch])
    println files
    files.each { filePath ->
        replaceTextUtils.replaceTextAndSet(filePath, matchText, replaceText)
    }
}

//String matchFiles = "(((Count|NewerRecord)_NISDB\\.biz)|((Insert|Update|Upsert)\\.proxy))"
//String matchContent = "([\\\"\\/>]|from )"

//nisCopyAndRename(initialName + matchFiles, replaceName + '$1')
//nisReplaceText(replaceName + matchFiles, matchContent + initialName, '$1' + replaceName)
//replaceNames = ["AccountContact", "Address", "Asset", "Contact", "Premise", "ServicePoint"]
//nisCopyAndRenameAndReplace(initialName, matchFiles, replaceNames, matchContent)

