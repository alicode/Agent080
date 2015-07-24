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


**v2.0** / (2015-07-25)
  - Fix modifily  Bug    (DomainName 修改錯誤; ex:abc.com 會變成錯誤  abc.abc.com)

  - Fix AddSubDomain Bug (重覆 DomainID)

  - 增加 AddSubDomain  提示訊息 


**v2.0** / (2015-07-11)
 
  - 增加  "新增AddSubDomain  "功能,此功能是 依據 "modifily" 功能 修正的。

  - 未來要增加  同步 DomainBase 的功能。

**v2.0** / (2015-07-06)

  - 測試 使用 一個 session 對應一個 DomainName

  - 目前小量測試 8個  subdomain (2個 Doamin ; 每一個Domain 4個 SubDomain),時間 花費 49 S ,DNS 沒有跟不上的情況)

**v2.0** / (2015-06-18)

  - 修改 遺漏變數名稱。

  - 測試 多個session (一台電腦一個session)執行Agent080.sh,比之前穩定一些,測6個(2個session)subdomain 都沒問題;測15個(3個session)都有一個會無法更新到DNS。

  - 以下是測試時,並未更新的 DomainName

    1.kk1.bs2828.com

    2.kk9.bs2828.com

**v2.0** / (2015-06-17)

  - 新增 單一筆 SubdomainName 刪除的功能

  - 修改指令參數 相關程式

  - ~~未來新增 Subdomain Name 功能。~~

**v2.0** / (2015-06-12)

  - 目前修改與 Get Data 合為一版 。(測試版)

  - 未來取資料,以 單一筆DomainIndex來取(功能增加)

  - 未來能update DomainDB(File)的功能,不必每次都從第一筆開始到最後一筆。

**v1.0** / (2014-09-22)

  - 初稿  Get Data




