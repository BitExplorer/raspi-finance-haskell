{-# LANGUAGE OverloadedStrings,TemplateHaskell #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric  #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE RecordWildCards #-}

import Data.Aeson
import Data.Aeson.TH
import qualified Data.ByteString.Lazy.Char8 as BL
import Data.Time
import Data.Typeable
import qualified Data.Time as Time
import qualified Data.ByteString as SB
import qualified Data.ByteString.Lazy as LB
--import System.Locale (defaultTimeLocale)
import Data.Time.Format (formatTime)
import Data.Time.Clock
import Data.List
import System.Directory
import Data.Aeson.Parser
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToField
import Database.PostgreSQL.Simple.ToRow
-- import Database.PostgreSQL.Simple.Statement
import GHC.Generics (Generic)
--import Control.Lens
import Data.Ratio
import Control.Lens
-- import qualified Data.Text                       as T
import Data.Text

-- newtype DateTime = DateTime {getDateTime :: UTCTime}
--   deriving (Generic, Eq, Ord, Show, Read)

-- makeDateTime :: UTCTime -> DateTime
-- makeDateTime (UTCTime d s) = DateTime (UTCTime d (fixTime s))
--   where
--     fixTime = picosecondsToDiffTime . unMili . diffTimeToPicoseconds
--       where
--         unMili pico = (pico `div` 1000000000) * 1000000000


newtype DateTime = MakeInteger LocalTime
   deriving (Generic, Eq, Ord, Show, Read)

-- toDateTime :: LocalTime -> Integer
-- toDateTime x = formatTime defaultTimeLocale "%s" x
-- epoch_int <- (read . formatTime defaultTimeLocale "%s" <$> getCurrentTime) :: IO Int

-- fromInteger :: Integer -> LocalTime
-- fromInteger x =

data Transaction a = Transaction String String String String String String String Integer Integer Integer Bool a a a deriving (Show, Eq)

newtype TransactionWithoutA = TransactionWithoutA (Transaction ())

newtype TransactionWithA = TransactionWithA (Transaction (LocalTime, LocalTime, LocalTime))

newtype TransactionWithOne = TransactionWithOne (Transaction LocalTime)


data TransactionNew = TransactionNew String String String String String String String Integer Integer Integer Bool DateTime deriving (Show, Eq, Generic)
-- newtype URL = URL { getURL :: Text } deriving (Show, Eq, Generic)

makeLenses ''TransactionWithoutA

--instance FromRow Transaction
-- instance ToRow TransactionWithoutA



instance FromJSON TransactionNew
--
instance FromRow TransactionNew
instance ToRow TransactionNew


-- instance FromRow TransactionWithoutA where
--   fromRow = TransactionWithoutA <$>
--     field <*>
--     field <*>
--     field <*>
--     field <*>
--     field <*>
--     field <*>
--     field <*>
--     field <*>
--     field <*>
--     field <*>
--     field

-- -- (Book <$> field)
-- -- works lambda function
-- instance FromJSON TransactionWithoutA where
--   parseJSON = withObject "transaction" $ \o ->
--     TransactionWithoutA <$> o .: "guid"
--            <*> o .: "description"
--            <*> o .: "category"
--            <*> o .: "sha256"
--            <*> o .: "accountType"
--            <*> o .: "accountNameOwner"
--            <*> o .: "notes"
--            <*> o .: "cleared"
--            <*> o .: "accountId"
--            <*> o .: "transactionId"
--            <*> o .: "reoccurring"
--
--



newtype Natural = MakeNatural Integer

toNatural :: Integer -> Natural
toNatural x | x < 0 = error "Can't create negative naturals!"
            | otherwise = MakeNatural x

fromNatural :: Natural -> Integer
fromNatural (MakeNatural i) = i

main :: IO ()
main = do putStrLn "--- start ---"
          singleRecord <- LB.readFile "file.json"
          records <- LB.readFile "filelist.json"
          list <- LB.readFile "list.json"
          conn <- connect defaultConnectInfo { connectHost = "localhost", connectDatabase = "finance_db", connectUser = "henninb", connectPassword = "monday1"}
          print (decode singleRecord :: Maybe Transaction)
          putStrLn "--- separated ---"
          print (decode records :: Maybe [Transaction])
          putStrLn "--- separated ---"
          mapM_ print =<< (query_ conn "SELECT 1 + 1" :: IO [Only Int])
          putStrLn "--- separated ---"
