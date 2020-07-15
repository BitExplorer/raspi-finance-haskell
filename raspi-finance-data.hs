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

newtype DateTime = DateTime {getDateTime :: UTCTime}
  deriving (Generic, Eq, Ord, Show, Read)

makeDateTime :: UTCTime -> DateTime
makeDateTime (UTCTime d s) = DateTime (UTCTime d (fixTime s))
  where
    fixTime = picosecondsToDiffTime . unMili . diffTimeToPicoseconds
      where
        unMili pico = (pico `div` 1000000000) * 1000000000

data Transaction a = Transaction String String String String String String String Integer Integer Integer Bool a a deriving (Eq, Show)


-- newtype TransactionWithoutA = TransactionWithoutA (Transaction LocalTime)
newtype TransactionWithoutA = TransactionWithoutA (Transaction ())
newtype TransactionWithA = TransactionWithA (Transaction (LocalTime, LocalTime))


-- newtype URL = URL { getURL :: Text } deriving (Show, Eq, Generic)
-- data Transaction = Transaction
--     { guid :: String,
--       description :: String,
--       category    :: String,
--       sha256 :: String,
--       accountType    :: String,
--       accountNameOwner    :: String,
--       notes    :: String,
--       cleared   :: Integer,
--       accountId      :: Integer,
--       transactionId     :: Integer,
--       reoccurring      :: Bool
-- --      dateUpdated    ::  LocalTime -- NominalDiffTime,  LocalTime, UTCTime Integer
--     } deriving (Show, Eq, Generic, Ord)

makeLenses ''TransactionWithoutA

--instance FromRow Transaction
-- instance ToRow TransactionWithoutA

instance FromJSON TransactionWithoutA
instance ToJSON TransactionWithoutA
--
instance FromRow TransactionWithoutA
instance ToRow TransactionWithoutA


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

