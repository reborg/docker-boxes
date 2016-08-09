{:user {
        :jvm-opts ["-Xmx1048m" "-XX:-OmitStackTraceInFastThrow"]
        :plugins [
                  [lein-midje "3.2"]
                  [refactor-nrepl "2.2.0"]
                  [lein-try "0.4.3"]
                  [lein-environ "1.0.0"]
                  ]
        :signing {:gpg-key "D1DAFAB4"}
        :env {
              :password "here"
              }}}

