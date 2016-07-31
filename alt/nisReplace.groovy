import java.util.regex.Matcher
import java.lang.reflect.Array
import groovy.lang.GroovyShell
scriptDir = new File(getClass().protectionDomain.codeSource.location.path).parent + "\\"
evaluate(new File(scriptDir + "importNisReplaceUtils.groovy"))
evaluate(new File("D:\\dropbox\\Dropbox\\nis\\persister\\" + "nisReplace.txt"))

String matchFiles = "(((Count|NewerRecord)\\.biz)|((Insert|Update|Upsert)\\.proxy))"
String matchContent = "([\\\"\\/>]|from )"

//nisCopyAndRename(initialName + matchFiles, replaceName + '$1')
//nisReplaceText(replaceName + matchFiles, matchContent + initialName, '$1' + replaceName)
//replaceNames = ["AccountContact", "Address", "Asset", "Contact", "Premise", "ServicePoint"]
replaceNames.eachWithIndex { names, i ->
	nisReplaceUtils.nisCopyAndRenameAndReplaceAndSchema(initialName, matchFiles, names, matchContent, replaceSchema[i])
}


