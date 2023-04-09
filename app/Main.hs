module Main(main) where
import Data.Conduit.Binary (sinkFile) -- Exported from the package conduit-extra
import Network.HTTP.Conduit
import Conduit (runConduit, (.|))
import Control.Monad.Trans.Resource (runResourceT)

deffaultTimeout :: Int
deffaultTimeout = 10000000

main :: IO ()
main = do
     request <- parseRequest "https://stcis.go.kr/openapi/quarterod.json?apikey=20221126141403qgg7ai670q8nhpk2baj3mjvjqu&opratDate=20220505&stgEmdCd=4111113100&arrEmdCd=4111113500"
     manager <- newManager $ tlsManagerSettings { managerResponseTimeout = responseTimeoutMicro deffaultTimeout}
     runResourceT $ do
         response <- http request manager
         runConduit $ responseBody response .| sinkFile "result.json"
