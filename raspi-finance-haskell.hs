{-# LANGUAGE OverloadedStrings,TemplateHaskell #-}

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

data Transaction = Transaction
    { guid :: String,
      description :: String,
      category    :: String,
      --transactionDate    :: UTCTime,
      transactionDate    :: NominalDiffTime,
      dateUpdated        :: NominalDiffTime,
      dateAdded        :: NominalDiffTime,
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
     -- account_name_owner    :: Maybe String,
     -- date_updated        :: Maybe NominalDiffTime,
     -- date_added        :: Maybe NominalDiffTime,
     -- transaction_date    :: Maybe NominalDiffTime
    } deriving (Show, Eq)

--data TransactionSnake = TransactionSnake
--    { guid :: String,
--      description :: String,
--      category    :: String,
--      sha256 :: Maybe String,
--      accountType    :: String,
--      notes    :: String,
--      amount      :: Double,
--      cleared      :: Integer,
--      account_id      :: Integer,
--      transaction_id     :: Integer,
--      account_name_owner    :: String,
--      date_updated        :: NominalDiffTime,
--      date_added        :: NominalDiffTime,
--      transaction_date    :: NominalDiffTime,
--      reoccurring      :: Bool
--    } deriving (Show, Eq)

$(deriveJSON defaultOptions ''Transaction)

snakeCaseParser = withObject "Transaction" $ \obj -> do
   transactionDate <- obj .: "transaction_date"
   dateAdded <- obj .: "date_added"
   dateUpdated <- obj .: "date_updated"
   accountNameOwner <- obj .: "account_name_owner"
   accountType <- obj .: "account_type"
   accountId <- obj .: "account_id"
   transactionId <- obj .: "transaction_id"
   guid <- obj .: "guid"
   description <- obj .: "description"
   category <- obj .: "category"
   sha256 <- obj .: "sha256"
   notes <- obj .: "notes"
   amount <- obj .: "amount"
   cleared <- obj .: "cleared"
   reoccurring <- obj .: "reoccurring"
   pure (Transaction {
                       accountNameOwner = accountNameOwner,
                       transactionDate = transactionDate,
                       dateAdded = dateAdded,
                       dateUpdated = dateUpdated,
                       accountType = accountType,
                       transactionId = transactionId,
                       accountId = accountId,
                       amount = amount,
                       notes = notes,
                       sha256 = sha256,
                       category = category,
                       description = description,
                       guid = guid,
                       reoccurring = reoccurring,
                       cleared = cleared
                       })

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

main :: IO ()
main = do putStrLn "read file and load it to a structure."
--          [file] <- getArgs
          singleRecord <- LB.readFile "/Users/z037640/projects/raspi-finance-haskell/file.json"
          records <- LB.readFile "/Users/z037640/projects/raspi-finance-haskell/filelist.json"
          list <- LB.readFile "/Users/z037640/projects/raspi-finance-haskell/list.json"
          --all <- getDirectoryContents "/Users/z037640/projects/raspi-finance-convert/json_in/.processed"
          jsonFiles <- filter isRegularFileOrDirectory <$> getDirectoryContents "/Users/z037640/projects/raspi-finance-convert/json_in/.processed"

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
