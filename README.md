# Cache-Gitter-Archiver
A tiny class for InterSystems Caché that downloads all Gitter's room messages to the archive file.

**Keywords**: InterSystems, Caché, HTTPS, HTTP, Request, Gitter, API.

Usage
-----

1. Import `Gitter.Archiver.cls` class to Caché.
2. Gitter uses HTTPS, so you need to [set up](http://docs.intersystems.com/latest/csp/docbook/DocBook.UI.Page.cls?KEY=GCAS_ssltls) SSL configuration in the Management Portal and then replace `DefaultSSL` in `set req.SSLConfiguration = "DefaultSSL"` line of code to the name of your SSL sertificate.
3. Run the script in terminal:

![2016-05-29_230926](https://cloud.githubusercontent.com/assets/4989256/15635854/ab5ba444-25f3-11e6-8578-ac9fb74644aa.png)
