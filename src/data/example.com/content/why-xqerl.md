## Why xqerl

xQuery 3.1 Processor
* a well tested xQuery 3.1 Processor
* built for xQuery 3.1, with no prior baggage making it more lean.
* built with erlang, compiled to run as a **reliable** OTP beam application

The modules
* **http client module** requests result in XDM items
 - fetch and parse HTML doc produces a document-node XDM item 
 - fetch and parse JSON doc produces a map or array XDM items 
* fast parallel processing using the **actor module** 
 
The database
* can store data as XDM items: document-nodes, maps, arrays and even functions
* can store *links* to binary files
* uri domain based databases. 'http://example.com', 'http://markup.nz'
  two different databases
 

