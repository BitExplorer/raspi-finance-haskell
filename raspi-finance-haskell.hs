{-# LANGUAGE OverloadedStrings,TemplateHaskell #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric  #-}

--stack install aeson-casing
import Data.Aeson
import Data.Aeson.TH
import Data.Aeson.Casing
import qualified Data.ByteString.Lazy.Char8 as BL
import Data.Time
import qualified Data.ByteString as SB
import qualified Data.ByteString.Lazy as LB
import System.Locale (defaultTimeLocale)
import Data.Time.Format (formatTime)
import Data.Time.Clock
import Data.List
import System.Directory
import Data.Aeson.Parser
--import Data.String.Utils
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToField
import Database.PostgreSQL.Simple.ToRow
import GHC.Generics (Generic)
--import Servant


data Book = Book
  {
    isbn :: String
  , title :: String
  , authors :: String
  } deriving (Show, Eq, FromRow, Generic)

--instance FromRow Book where
--  fromRow = Book <$> field <*> field <*> field

data Transaction = Transaction
    { guid :: String,
      description :: String,
      category    :: String,
      --transactionDate    :: UTCTime,
--      transactionDate    :: NominalDiffTime,
--      dateUpdated        :: NominalDiffTime,
--      dateAdded        :: NominalDiffTime,
      sha256 :: Maybe String,
      accountType    :: String,
      accountNameOwner    :: String,
      notes    :: String,
      amount      :: Double,
      cleared      :: Integer,
      accountId      :: Maybe Integer,
      transactionId     :: Maybe Integer,
      reoccurring      :: Bool
     -- account_id      :: Maybe Integer,
     -- transaction_id     :: Maybe Integer,
    } deriving (Show, Eq, FromRow, Generic)

$(deriveJSON defaultOptions ''Transaction)


--transaction1 :: Relation () Transaction
--transaction1 = relation $ do
--  a <- query account
--  wheres $ a ! Transaction.category' `in'` values ["fuel"]
--  return a

--instance FromRow Transaction where
--  fromRow = Transaction <$> field <*> field <*> field <*> field <*> field <*> field <*> field <*> field <*> field <*> field <*> field <*> field


--instance FromRow Transaction where
--  fromRow = Transaction{..} = [guid,accountNameOwner,notes,description,category]

--instance QueryParams Transaction where
--    renderParams Transaction{..} = [guid,accountNameOwner,notes,description,category]

isRegularFileOrDirectory :: FilePath -> Bool
isRegularFileOrDirectory f = f /= "." && f /= ".."

printValues :: [String] -> IO ()
printValues = putStrLn . unlines

readJsonFile f = do
  singleRecord <- LB.readFile f
  print (decode singleRecord :: Maybe Transaction)

-- does not work
printValuesFile =  map readJsonFile

transactionSumAmount :: [Transaction] -> Double
transactionSumAmount [] = 0.0
transactionSumAmount (x:xs) =  amount x + transactionSumAmount xs


--data App = App
--    { _sess :: Snaplet SessionManager
--    }
--
--makeLenses ''App
--
---- | The application's routes.
--routes :: [(LB.ByteString, Handler App App ())]
--routes = [ ("/",            writeText "hello")
--         ]

main :: IO ()
main = do putStrLn "read file and load it to a structure."
--          [file] <- getArgs
          singleRecord <- LB.readFile "file.json"
          records <- LB.readFile "filelist.json"
          list <- LB.readFile "list.json"
          --all <- getDirectoryContents "../raspi-finance-convert/json_in/.processed"
          jsonFiles <- filter isRegularFileOrDirectory <$> getDirectoryContents "../raspi-finance-convert/json_in/.processed"

--          conn <- connectPostgreSQL "host=localhost port=5432 connect_timeout=10 connectDatabase=finance_db"
          conn <- connect defaultConnectInfo { connectHost = "localhost", connectDatabase = "finance_db", connectUser = "henninb", connectPassword = "monday1"}

          --listBySuit = [ x = "one" | x <- jsonFiles]

          --let filtered = filter (endsWith "json") all
--          let toCamelCase = camelCase(jsonFiles)
          print (decode singleRecord :: Maybe Transaction)
          print (decode records :: Maybe [Transaction])
          --print (decode list :: Maybe [Transaction])
          --printValues jsonFiles
          let listOfTransactions = decode list :: Maybe [Transaction]
          print listOfTransactions
          --print (transactionSumAmount listOfTransactions)
          putStrLn "read file and load it to a structure."
          mapM_ print =<< (query_ conn "SELECT 1 + 1" :: IO [Only Int])
          --mapM_ print =<< (query conn "SELECT guid,description,category,sha256, account_type, account_name_owner FROM t_transaction WHERE guid = ? and account_name_owner = ?" ("c63dcaf1-c2b7-4d72-b2bb-8d4dafed8dbd" :: String, "usbankcash_brian" :: String) :: IO [Transaction])
          mapM_ print =<< (query conn  "SELECT isbn,title,authors FROM books WHERE title = ? AND authors = ?" ("test" :: String, "test" :: String) :: IO [Book])
          --mapM_ print =<< (query conn  "SELECT isbn,title,authors FROM books WHERE title = ?" (Only "test" :: String) :: IO [Book])
--          mapM_ print =<< (query_ conn bookQuery :: IO [Book]) where bookQuery = "SELECT isbn,title,authors FROM books LIMIT 1"
--          mapM_ print =<< (query_ conn transactionQuery :: IO [Transaction]) where transactionQuery = "SELECT guid,description,account_type,account_name_owner FROM t_transaction LIMIT 1"
          mapM_ print =<< (query_ conn q :: IO [Only LB.ByteString]) where q = "SELECT guid FROM t_transaction LIMIT 10"
--          mapM_ print =<< (query_ conn q :: IO [Transaction]) where q = "SELECT guid FROM t_transaction LIMIT 10"
--          mapM_ print =<< (query_ conn q :: IO [LB.ByteString, LB.ByteString]) where q = "SELECT guid,description FROM t_transaction LIMIT 10"
--          mapM_ print =<< (query_ conn "select guid from t_transaction" :: IO [Transaction])