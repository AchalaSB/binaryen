(module
  (func $pick
   (local $x i32)
   (local $y i32)
   (set_local $x (get_local $y))
   (if (i32.const 1)
    (set_local $x (i32.const 1))
   )
   (set_local $x (get_local $y))
   (set_local $x (get_local $y))
  )
  (func $pick-2
   (local $x i32)
   (local $y i32)
   (set_local $y (get_local $x))
   (if (i32.const 1)
    (set_local $y (i32.const 1))
   )
   (set_local $y (get_local $x))
   (set_local $y (get_local $x))
  )
  (func $many
   (local $x i32)
   (local $y i32)
   (local $z i32)
   (local $w i32)
   (set_local $y (get_local $x))
   (set_local $z (get_local $y))
   (set_local $w (get_local $z))
   (set_local $x (get_local $z))
   (if (i32.const 1)
    (set_local $y (i32.const 1))
   )
   (set_local $x (get_local $z))
   (if (i32.const 1)
    (set_local $y (i32.const 1))
   )
   (set_local $y (get_local $x))
   (set_local $z (get_local $y))
   (set_local $w (get_local $z))
   (set_local $z (i32.const 2))
   (set_local $x (get_local $z))
   (if (i32.const 1)
    (set_local $y (i32.const 1))
   )
   (set_local $y (get_local $x))
   (set_local $z (get_local $y))
   (set_local $w (get_local $z))
   (set_local $z (i32.const 2))
   (set_local $x (get_local $w))
  )
  (func $loop-copies (param $x i32) (param $y i32)
   (loop $loop
    (set_local $x (get_local $y))
    (set_local $y (get_local $x))
    (br_if $loop (get_local $x))
   )
  )
  (func $proper-type (result f64)
   (local $var$0 i32)
   (local $var$2 f64)
   (set_local $var$0
    (select
     (i32.const 0)
     (i32.const 1)
     (get_local $var$0)
    )
   )
   (tee_local $var$2
    (get_local $var$2)
   )
  )
  (func $multi-pass-get-equivs-right (param $var$0 i32) (param $var$1 i32) (result f64)
   (local $var$2 i32)
   (set_local $var$2
    (get_local $var$0)
   )
   (i32.store
    (get_local $var$2)
    (i32.const 1)
   )
   (f64.promote/f32
    (f32.load
     (get_local $var$2)
    )
   )
  )
  (func $if-value-structure-equivalent (param $x i32) (result i32)
    (local $y i32)
    (if (i32.const 1)
      (set_local $x (i32.const 2))
      (block
        (set_local $y (get_local $x))
        (set_local $x (get_local $y))
      )
    )
    (get_local $x)
  )
  (func $block-just-one (param $x i32) (result i32)
    (block $b
      (drop (i32.const 10))
      (set_local $x (i32.const 20))
    )
    (drop (i32.const 30))
    (get_local $x)
  )
  (func $block-just-one-loop (param $x i32) (result i32)
    (loop $l
      (drop (i32.const 10))
      (br_if $l (i32.const 15))
      (set_local $x (i32.const 20))
    )
    (drop (i32.const 30))
    (get_local $x)
  )
  (func $one-break-one-sinkable (param $var$0 i32)
   (block $label$1
    (br_if $label$1
     (i32.const 0)
    )
    (set_local $var$0
     (i32.const 1)
    )
   )
  )
  (func $one-sinkable-has-value (param $var$0 i32) (result i32)
   (block $label$1
    (nop)
    (set_local $var$0
     (i32.const 1)
    )
   )
   (get_local $var$0)
  )
  (func $simple-block-sink
   (local $var$1 i32)
   (set_local $var$1
    (i32.const 14)
   )
   (nop)
  )
  (func $almost-simple-block-sink (param $a i32)
   (local $b i32)
   (set_local $b
    (i32.const 14)
   )
   (call $almost-simple-block-sink (get_local $b))
  )
  (func $yes-simple-block-sink (param $a i32)
   (local $b i32)
   (set_local $b
    (i32.const 14)
   )
   (call $almost-simple-block-sink (get_local $a))
  )
  (func $flow-throw-many (param $var$0 i32) (result f32)
   (local $var$1 f32)
   (local $temp f32)
   (loop $label$1
    (set_local $var$1
     (block $label$2 (result f32)
      (br_if $label$1
       (i32.load
        (i32.const 3)
       )
      )
      (tee_local $temp
       (loop (result f32)
        (get_local $var$1) ;; a trivial copy, given where we set it
       )
      )
     )
    )
    (br $label$1)
   )
  )
  (func $unblock-1
    (local $x i32)
    (set_local $x
      (block (result i32)
        (set_local $x (i32.const 0))
        (drop (i32.add (get_local $x) (get_local $x)))
        (i32.const 1)
      )
    )
  )
  (func $unblock-2
    (local $x i32)
    (loop $l
      (set_local $x
        (block (result i32)
          (set_local $x (i32.const 0))
          (drop (i32.add (get_local $x) (get_local $x)))
          (br_if $l (i32.const 10))
          (i32.const 1)
        )
      )
    )
  )
  (func $unblock-3
    (local $x i32)
    (if (i32.const 1)
      (set_local $x
        (block (result i32)
          (set_local $x (i32.const 0))
          (drop (i32.add (get_local $x) (get_local $x)))
          (i32.const 1)
        )
      )
      (nop)
    )
    (if (i32.const 1)
      (nop)
      (set_local $x
        (block (result i32)
          (set_local $x (i32.const 0))
          (drop (i32.add (get_local $x) (get_local $x)))
          (i32.const 1)
        )
      )
    )
  )
)

