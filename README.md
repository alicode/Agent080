#Agent080
這是Bash Script 撰寫, 主要是抓取Name080網站 DNS服務上的資料。只要有購買Name080 DNS代管服務,就適用此腳本來抓取Hostname及IP相關資料。

##How to Work
1.只要修改Script 內容  loginID及passw (在Name080 註冊的帳號及密碼)
  loginID=""
  passw=""

2.sh Agent080 -g

3.若是第一次執行會詢問 "The DomainIndex.txt is not exist. Need Rebuild Domain Index. Please Input  Y/N:",只要鍵入 "Y"就可以抓資料。

4.sh Agent080 -h  About Help  

##History


**v2.0** / (2015-06-17)
  -新增 單一筆 SubdomainName 刪除的功能
  -修改指令參數 相關程式
  -~~未來新增 Subdomain Name 功能。~~

**v2.0** / (2015-06-12)
  -目前修改與 Get Data 合為一版 。(測試版)
  -未來取資料,以 單一筆DomainIndex來取(功能增加)
  -未來能update DomainDB(File)的功能,不必每次都從第一筆開始到最後一筆。

**v1.0** / (2014-09-22)
  -初稿  Get Data




