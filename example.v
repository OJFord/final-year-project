Inductive weekday: Set :=
    | monday: weekday
    | tuesday: weekday
    | wednesday: weekday
    | thursday: weekday
    | friday: weekday
    | saturday: weekday
    | sunday: weekday.

Function nextday (day: weekday) : weekday :=
    match day with
    | monday => tuesday
    | tuesday => wednesday
    | wednesday => thursday
    | thursday => friday
    | friday => saturday
    | saturday => sunday
    | sunday => monday
    end.

Function trans (day: weekday) (c: nat) : weekday :=
    match c with
    | 0 => day
    | S r => nextday (trans day r)
    end.

Lemma modular: forall day: weekday,
    trans day 7 = day.
Proof.
    intros.
    induction day.
    - reflexivity. (* Monday *)
    - reflexivity. (* Tuesday *)
    - reflexivity. (* Wednesday *)
    - reflexivity. (* Thursday *)
    - reflexivity. (* Friday *)
    - reflexivity. (* Saturday *)
    - reflexivity. (* Sunday *)
Qed.
