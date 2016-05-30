/// Archives messages to a file.
Class Gitter.Archiver
{

/// SSL configuration name used for HTTPS requests.
Parameter SSLConfig = "DefaultSSL";

/// Downloads all Gitter's room messages to the archive file. Specify fileName and roomID parameters,
/// or there would be used default values, which download messages from https://gitter.im/springjazzy/GIS_JKH_Integration
ClassMethod Archive(fileName As %String = "C:\chat.txt", roomID As %String = "56ea6f5f85d51f252ab942cd") As %Status
{
	new $namespace
	zn "%SYS"
	do:'##class(Security.SSLConfigs).Exists(..#SSLConfig) ##class(Security.SSLConfigs).Create(..#SSLConfig)
	
	set LIMIT = 100 // default limit for messages load. Could not be higher.
	set file = ##class(%File).%New(fileName)
	do file.Open("WSN")
	set req = ##class(%Net.HttpRequest).%New()
	set req.Server = "api.gitter.im"
	set req.Https = 1
	set req.SSLConfiguration = ..#SSLConfig
	set chat = ##class(%Object).$new()
	set beforeId = ""
	set mes = 0
	do {
		do req.SetHeader("Authorization", "Bearer c8de8cdb9a7f13d225a539a6a8165adb43633a37")
		do req.SetHeader("Accept", "application/json")
		do req.SetHeader("Content-Type", "application/json")
		write $system.Status.GetErrorText(
			req.Get("/v1/rooms/"_roomID_"/chatMessages?limit="_LIMIT
			_$case(beforeId '= "", 1:"&beforeId="_beforeId, :""))
		)
		set obj = ##class(%AbstractObject).$fromJSON(req.HttpResponse.Data)
		if (obj.$size() = 0) { continue }
		for k=obj.$size()-1:-1:0 {
			set message = obj.$get(k)
			set mes = mes + 1
			do chat.$set(mes, message)
		}
		write $c(13), "Messages downloaded: ", mes
		set beforeId = obj.$get(0).id
	} while (obj.$get(LIMIT-1) '= "") // until the last page is reached
	write ". Writing to "_fileName_"... "
	for k=mes:-1:1 {
		set message = chat.$get(k)
		do file.WriteLine(
			"["_$ZCONVERT(message.fromUser.displayName_" @ "_message.fromUser.username, "O", "UTF8")
			_"] ["_$piece($replace(message.sent, "T", " "), ".", 1)_"]:"
		)
		do file.WriteLine($ZCONVERT(message.text, "O", "UTF8"))
		do file.WriteLine()
	}
	write "Done."
	
	quit $$$OK
}

}
