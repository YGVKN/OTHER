(ns dev.core
  (:require [sample.sum :as s]
            [clojure.java.io :as io])
            ;;[clojure.repl :refer :all]
            ;;[clojure.java.shell :refer [sh] :as shell])
  (:gen-class))

(defn -main []
  (println "Result > " (s/sum 12345 67890))
  (println "Slurp file > " (slurp (io/resource "StaticFile"))))
