import java.util.regex.Pattern
import java.util.regex.Matcher

println args[0]

String postFix = 5
int oneCharacterContent = 0 + postFix.toInteger()
int maxContentSize = 15 - postFix.size()

File inputFile = new File(args[0])
String fileText = inputFile.getText("UTF-8")

//def fileText = """<?xml version="1.0"?>
//<ns0:SiebelMessage xmlns:ns0="http://www.lyse.no/xml/2.0/LESiebelAccount"
// MessageId="MessageId_1"
//    MessageType="MessageType_1"
//    IntObjectName="IntObjectName_1"
//    IntObjectFormat="IntObjectFormat_1">
//    <ns0:ListOfLeSiebelAccount>
//        <ns0:Account>
//            <ns0:Id>string1</ns0:Id>
//            <ns0:Created>string1</ns0:Created>
//            <ns0:DeleteRequestReason>string1</ns0:DeleteRequestReason>
//            <ns0:Status>string1</ns0:Status>
//            <ns0:AccountTypeCode>string1</ns0:AccountTypeCode>
//            <ns0:BusinessNumber>string1</ns0:BusinessNumber>
//            <ns0:RequestForDelete>string1</ns0:RequestForDelete>
//            <ns0:IntegrationId>string1</ns0:IntegrationId>"""
String pattern = /(<(.+:)?(.+)>)(string.*|\d)(<\\/(.+:)?.+>)/
//matcher = fileText =~ pattern

def cutInput = { matcher ->
    String content = matcher[4]
    String out
    if (content =~ /string.*/) {
        int tagNameLength = matcher[3].size()
        if (tagNameLength > maxContentSize) {
            String tokenizePattern = /[A-Z][^A-Z]*/
            def tokenizeTagName = matcher[3] =~ tokenizePattern
            int tokenizeMaxLength = Math.floor(maxContentSize / tokenizeTagName.size())
//            println tokenizeMaxLength
            out = matcher[3].replaceAll(/[A-Z][^A-Z]*/) { w ->
//                println w;
                return w.replaceAll("(.{0,${tokenizeMaxLength}}).*", "\$1") }
        } else {
            out = matcher[3]
        }
		out += postFix
    } else if (content =~ /^\d$/) {
        oneCharacterContent = oneCharacterContent < 9 ? ++oneCharacterContent : 0
        return oneCharacterContent
    }
//    println content
    return out
}

String prepared = fileText.replaceAll(pattern, { return it[1] + cutInput(it) + it[5]})
println prepared
inputFile.setText(prepared, "UTF-8")
