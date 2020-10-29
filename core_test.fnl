(import-macros {: fn*} :macros.fn)
(import-macros {: into} :macros.core)
(import-macros {: assert-eq : assert-ne : assert* : testing : deftest} :test)

(local
 {: apply
  : seq
  : first
  : rest
  : last
  : butlast
  : conj
  : cons
  : concat
  : reduce
  : reduce-kv
  : mapv
  : filter
  : map?
  : seq?
  : nil?
  : zero?
  : pos?
  : neg?
  : even?
  : odd?
  : int?
  : pos-int?
  : neg-int?
  : double?
  : string?
  : boolean?
  : false?
  : true?
  : empty?
  : not-empty
  : eq?
  : identity
  : comp
  : every?
  : some
  : not-any?
  : complement
  : constantly
  : range
  : reverse
  : inc
  : dec
  : assoc
  : get
  : get-in}
 (require :core))

(deftest equality
  (testing eq?
    (assert* (not (pcall eq?)))
    ;; comparing basetypes
    (assert-eq 1 1)
    (assert-ne 1 2)
    (assert* (eq? 1 1 1 1 1))
    (assert-eq 1.0 1.0)
    (assert* (eq? 1.0 1.0 1.0))
    (assert* (eq? 1.0 1.0 1.0))
    (assert* (eq? "1" "1" "1" "1" "1"))

    ;; deep comparison
    (assert* (eq? []))
    (assert-eq [] [])
    (assert-eq [] {})
    (assert-eq [1 2] [1 2])
    (assert-ne [1] [1 2])
    (assert-ne [1 2] [1])
    (assert* (eq? [1 [2]] [1 [2]] [1 [2]]))
    (assert* (eq? [1 [2]] [1 [2]] [1 [2]]))
    (assert* (not (eq? [1 [2]] [1 [2]] [1 [2 [3]]])))

    (let [a {:a 1 :b 2}
          b {:a 1 :b 2}]
      (table.insert b 10)
      (assert-ne a b))

    (let [a [1 2 3]
          b [1 2 3]]
      (tset b :a 10)
      (assert-ne a b))

    (assert-eq [1 2 3] {1 1 2 2 3 3})

    ;; TODO: decide if this is right or not.  Looking from `seq'
    ;; perspective, it is correct, as `(seq {4 1})' and `(seq [nil nil
    ;; nil 1])' both yield `{4 1}'.  From Lua's point this is not the
    ;; same thing, for example because the sizes of these tables are
    ;; different.
    (assert-eq {4 1} [nil nil nil 1])))

(testing range
  (assert* (not (pcall range)))
  (assert-eq (range 10) [0 1 2 3 4 5 6 7 8 9])
  (assert-eq (range -5 5) [-5 -4 -3 -2 -1 0 1 2 3 4])
  (assert-eq [0 0.2 0.4 0.6 0.8] [0 0.2 0.4 0.6 0.8])
  (assert-eq (range 0 1 0.2) (range 0 1 0.2)))

(deftest predicates
  (testing zero?
    (assert* (zero? 0))
    (assert* (zero? -0))
    (assert* (not (zero? 1))))

  (testing int?
    (assert* (int? 1))
    (assert* (not (int? 1.1))))

  (testing pos?
    (assert* (pos? 1))
    (assert* (and (not (pos? 0)) (not (pos? -1)))))

  (testing neg?
    (assert* (neg? -1))
    (assert* (and (not (neg? 0)) (not (neg? 1)))))

  (testing pos-int?
    (assert* (pos-int? 42))
    (assert* (not (pos-int? 4.2))))

  (testing neg-int?
    (assert* (neg-int? -42))
    (assert* (not (neg-int? -4.2))))

  (testing string?
    (assert* (string? :s)))

  (testing double?
    (assert* (double? 3.3))
    (assert* (not (double? 3.0))))

  (testing map?
    (assert* (map? {:a 1}))
    (assert* (not (map? {}))))

  (testing seq?
    (assert* (not (seq? [])))
    (assert* (seq? [{:a 1}]))
    (assert* (not (seq? {})))
    (assert* (not (seq? {:a 1}))))

  (testing nil?
    (assert* (nil?))
    (assert* (nil? nil))
    (assert* (not (nil? 1))))

  (testing odd?
    (assert* (odd? 3))
    (assert* (odd? -3))
    (assert* (not (odd? 2)))
    (assert* (not (odd? -2))))

  (testing even?
    (assert* (even? 2))
    (assert* (even? -2))
    (assert* (not (even? 23)))
    (assert* (not (even? -23))))

  (testing true?
    (assert* (true? true))
    (assert* (not (true? false)))
    (assert* (not (true? 10)))
    (assert* (not (true? :true))))

  (testing false?
    (assert* (false? false))
    (assert* (not (false? true)))
    (assert* (not (false? 10)))
    (assert* (not (false? :true))))

  (testing boolean?
    (assert* (boolean? true))
    (assert* (boolean? false))
    (assert* (not (boolean? :false)))
    (assert* (not (boolean? (fn [] true))))))

(deftest sequence-functions
  (testing seq
    (assert-eq (seq []) nil)
    (assert-eq (seq {}) nil)
    (assert-eq (seq [1]) [1])
    (assert-eq (seq [1 2 3]) [1 2 3])
    (assert-eq (seq {:a 1}) [["a" 1]]))

  (testing mapv
    (assert* (not (pcall mapv)))
    (assert* (not (pcall mapv #(do nil))))
    (assert-eq (mapv #(* $ $) [1 2 3 4]) [1 4 9 16])

    (assert-eq (into {} (mapv (fn [[k v]] [k (* v v)]) {:a 1 :b 2 :c 3}))
               (into {} [[:a 1] [:b 4] [:c 9]]))

    (assert-eq (into {} (mapv (fn [[k1 v1] [k2 v2]] [k1 (* v1 v2)])
                              {:a 1 :b 2 :c 3}
                              {:a -1 :b 0 :c 2}))
               {:a -1 :b 0 :c 6})
    (assert-eq (mapv #(* $1 $2 $3) [1] [2] [-1]) [-2])
    (assert-eq (mapv string.upper ["a" "b" "c"]) ["A" "B" "C"])
    (assert-eq (mapv #(+ $1 $2 $3 $4) [1 -1] [2 -2] [3 -3] [4 -4]) [(+ 1 2 3 4) (+ -1 -2 -3 -4)])
    (assert-eq (mapv (fn [f-name s-name company position]
                       (.. f-name " " s-name " works as " position " at " company))
                     ["Bob" "Alice"]
                     ["Smith" "Watson"]
                     ["Happy Days co." "Coffee With You"]
                     ["secretary" "chief officer"])
               ["Bob Smith works as secretary at Happy Days co."
                "Alice Watson works as chief officer at Coffee With You"]))

  (testing reduce
    (fn* plus
      ([] 0)
      ([a] a)
      ([a b] (+ a b))
      ([a b & c]
       (var res (+ a b))
       (each [_ v (ipairs c)]
         (set res (+ res v)))
       res))

    (assert-eq (reduce plus []) 0)
    (assert-eq (reduce plus [1]) 1)
    (assert-eq (reduce plus [1 2]) 3)
    (assert-eq (reduce plus (range 10)) 45)
    (assert-eq (reduce plus -3 (range 10)) 42)
    (assert-eq (reduce plus 10 []) 10)
    (assert-eq (reduce plus 10 [1]) 11)
    (assert-eq (reduce plus 10 nil) 10)
    (assert* (not (pcall reduce)))
    (assert* (not (pcall reduce plus)))

    (fn mapping [f]
      (fn [reducing]
        (fn [result input]
          (reducing result (f input)))))

    (fn reduce- [f init tbl]
      (if (and tbl (> (length tbl) 0))
          (reduce f (f init (first tbl)) (rest tbl))
          init))

    (assert-eq (reduce plus (range 10)) (reduce- plus 0 (range 10))))

  (testing filter
    (assert* (not (pcall filter)))
    (assert* (not (pcall filter even?)))
    (assert-eq (filter even? (range 10)) [0 2 4 6 8])
    (assert-eq (filter odd? (range 10)) [1 3 5 7 9])
    (assert-eq (filter map? [{:a 1} {5 1} [1 2] [] {}]) [{:a 1} {5 1}])
    (assert-eq (filter seq? [{:a 1} {5 1} [1 2] [] {}]) [[1 2]]))

  (testing concat
    (assert-eq (concat) nil)
    (assert-eq (concat []) [])
    (assert-eq (concat [1 2 3]) [1 2 3])
    (assert-eq (concat [1 2 3] [4 5 6]) [1 2 3 4 5 6])
    (assert-eq (concat [1 2] [3 4] [5 6]) [1 2 3 4 5 6])
    (assert-eq (concat {:a 1} {:b 2}) [[:a 1] [:b 2]])
    (assert-eq (concat [[:a 1]] {:b 2}) [[:a 1] [:b 2]])
    (assert-eq (concat {:a 1} [[:b 2]]) [[:a 1] [:b 2]])
    (assert-eq (concat [] [[:b 2]]) [[:b 2]])
    (assert-eq (concat [] []) [])
    (assert* (not (pcall concat 1)))
    (assert* (not (pcall concat 1 2)))
    (assert* (not (pcall concat 1 [])))
    (assert* (not (pcall concat [] 2)))
    (assert* (not (pcall concat [1] 2))))

  (testing reverse
    (assert-eq (reverse []) nil)
    (assert-eq (reverse [1 2 3]) [3 2 1])
    (assert-eq (reverse {:a 1}) [[:a 1]]))

  (testing conj
    (assert-eq (conj) [])
    (assert-eq (conj [1] nil) [1])
    (assert-eq (conj [] 1 2 3) [1 2 3])
    (assert-eq (conj [0] 1 2 3) [0 1 2 3])
    (assert-eq (conj {:a 1} [:b 2]) {:a 1 :b 2})
    (assert-eq (conj {:a 1}) {:a 1})
    (assert-eq (conj [1] 2 3 4 5 6 7) [1 2 3 4 5 6 7]))

  (testing cons
    (assert-eq (cons nil [1]) [1])
    (assert-eq (cons 1 []) [1])
    (assert-eq (cons 1 [0]) [1 0]))

  (testing first
    (assert-eq (first [1 2 3]) 1)
    (assert-eq (first {:a 1}) [:a 1])
    (assert-eq (first []) nil))

  (testing last
    (assert-eq (last [1 2 3]) 3)
    (assert-eq (last []) nil)
    (assert-eq (last nil) nil)
    (assert-eq (last {:a 1}) [:a 1]))

  (testing rest
    (assert-eq (rest [1 2 3]) [2 3])
    (assert-eq (rest {:a 1}) [])
    (assert-eq (rest []) [])
    (assert-eq (rest nil) []))

  (testing butlast
    (assert-eq (butlast [1 2 3]) [1 2])
    (assert-eq (butlast {:a 1}) nil)
    (assert-eq (butlast []) nil)
    (assert-eq (butlast nil) nil))

  (testing reduce-kv
    (assert-eq (reduce-kv #(+ $1 $3) 0 {:a 1 :b 2 :c 3}) 6)
    (assert* (not (pcall reduce-kv #(+ $1 $3) 0)))
    (assert* (not (pcall reduce-kv #(+ $1 $3))))
    (assert* (not (pcall reduce-kv))))

  (testing assoc
    (assert* (not (pcall assoc)))
    (assert* (not (pcall assoc {})))
    (assert-eq (assoc {} :a 1) {:a 1})
    (assert-eq (assoc {} :a 1 :b 2 :c 3 :d 4) {:a 1 :b 2 :c 3 :d 4})))

(deftest function-manipulation
  (testing constantly
    (let [always-nil (constantly nil)]
      (assert-eq (always-nil) nil)
      (assert-eq (always-nil 1) nil)
      (assert-eq (always-nil 1 2 3 4 "5") nil))

    (let [always-true (constantly true)]
      (assert* (always-true))
      (assert* (always-true false))))

  (testing complement
    (assert* ((complement #(do false))))
    (assert* ((complement nil?) 10))
    (assert* ((complement every?) double? [1 2 3 4]))
    (assert* ((complement #(= $1 $2 $3)) 1 1 2 1))
    (assert* ((complement #(= $1 $2)) 1 2)))

  (testing apply
    (fn* add
      ([x] x)
      ([x y] (+ x y))
      ([x y & zs]
       (add (+ x y) ((or _G.unpack table.unpack) zs))))
    (assert-eq (apply add [1 2 3 4]) 10)
    (assert-eq (apply add -1 [1 2 3 4]) 9)
    (assert-eq (apply add -2 -1 [1 2 3 4]) 7)
    (assert-eq (apply add -3 -2 -1 [1 2 3 4]) 4)
    (assert-eq (apply add -4 -3 -2 -1 [1 2 3 4]) 0)
    (assert-eq (apply add -5 -4 -3 -2 -1 [1 2 3 4]) -5)
    (assert* (not (pcall apply)))
    (assert* (not (pcall apply add))))

  (testing comp
    (assert-eq ((comp) 10) 10)
    (fn square [x] (* x x))
    (assert-eq (comp square) square)
    (assert-eq ((comp square inc) 6) 49)
    (assert-eq ((comp #(- $ 7) square inc inc inc inc inc inc inc) 0) 42)
    (fn sum-squares [x y] (+ (* x x) (* y y)))
    (assert-eq ((comp square inc sum-squares) 2 3) 196)
    (fn f [a b c] (+ a b c))
    (assert-eq ((comp inc f) 1 2 3) 7)
    (fn g [a b c d] (+ a b c d))
    (assert-eq ((comp inc g) 1 2 3 4) 11)
    (fn h [a b c d e f] (+ a b c d e f))
    (assert-eq ((comp inc h) 1 2 3 4 5 6) 22))

  (testing identity
    (fn f [] nil)
    (assert-eq (identity 1) 1)
    (assert-eq (identity {:a 1 :b 2}) {:a 1 :b 2})
    (assert-eq (identity [1 2 3]) [1 2 3])
    (assert-eq (identity "abc") "abc")
    (assert-eq (identity f) f)))

(deftest sequence-predicates
  (testing some
    (assert* (not (pcall some)))
    (assert* (not (pcall some pos-int?)))
    (assert* (some pos-int? [-1 1.1 2.3 -5.5 42 10 -27]))
    (assert* (not (some pos-int? {:a 1})))
    (assert* (some pos-int? [{:a 1} "1" -1 1])))

  (testing not-any?
    (assert* (not (pcall not-any?)))
    (assert* (not (pcall not-any? pos-int?)))
    (assert* (not-any? pos-int? [-1 1.1 2.3 -5.5 -42 -10 -27]))
    (assert* (not-any? pos-int? {:a 1}))
    (assert* (not (not-any? pos-int? [1 2 3 4 5]))))

  (testing every?
    (assert* (not (pcall every?)))
    (assert* (not (pcall every? pos-int?)))
    (assert* (not (every? pos-int? [-1 1.1 2.3 -5.5 42 10 -27])))
    (assert* (not (every? pos-int? {:a 1})))
    (assert* (every? pos-int? [1 2 3 4 5])))

  (testing empty?
    (assert* (not (pcall empty?)))
    (assert* (empty? []))
    (assert* (empty? {}))
    (assert* (empty? ""))
    (assert* (not (empty? "1")))
    (assert* (not (empty? [1])))
    (assert* (not (empty? {:a 1})))
    (assert* (not (pcall empty? 10))))

  (testing not-empty
    (assert* (not (pcall not-empty)))
    (assert-eq (not-empty []) nil)
    (assert-eq (not-empty {}) nil)
    (assert-eq (not-empty "") nil)
    (assert-eq (not-empty "1") "1")
    (assert-eq (not-empty [1]) [1])
    (assert-eq (not-empty {:a 1}) {:a 1})))

(deftest math-functions
  (testing inc
    (assert-eq (inc 1) 2)
    (assert-eq (inc -1) 0))
  (testing dec
    (assert-eq (dec 1) 0)
    (assert-eq (dec -1) -2)))

(deftest table-access
  (testing get
    (assert-eq (get {:key1 10 :key2 20} :key1) 10)
    (assert-eq (get {:key1 10 :key2 20} :key1 false) 10)
    (assert-eq (get {:key1 10 :key2 20} :key3 false) false)
    (assert-eq (get {:key1 10 :key2 20} :key3) nil)
    (assert* (not (pcall get)))
    (assert* (not (pcall get {}))))

  (testing get-in
    (local t {:a {:b {:c 10}}})
    (assert-eq (get-in t [:a]) {:b {:c 10}})
    (assert-eq (get-in t [:a :b]) {:c 10})
    (assert-eq (get-in t [:a :b :c]) 10)
    (assert-eq (get-in t [:a :b :c] false) 10)
    (assert-eq (get-in t [:a :b :d] false) false)
    (assert-eq (get-in t [:a :b :d]) nil)
    (assert-eq (get-in t []) t)
    (assert* (not (pcall get-in)))
    (assert* (not (pcall get-in {})))))
