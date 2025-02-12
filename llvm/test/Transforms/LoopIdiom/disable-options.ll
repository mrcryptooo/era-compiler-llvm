; XFAIL: eravm

; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -basic-aa -loop-idiom                             < %s -S | FileCheck %s --check-prefix=DIS-NONE
; RUN: opt -basic-aa -loop-idiom -disable-loop-idiom-all    < %s -S | FileCheck %s --check-prefix=DIS-ALL
; RUN: opt -basic-aa -loop-idiom -disable-loop-idiom-memcpy < %s -S | FileCheck %s --check-prefix=DIS-MEMCPY
; RUN: opt -basic-aa -loop-idiom -disable-loop-idiom-memset < %s -S | FileCheck %s --check-prefix=DIS-MEMSET
; RUN: opt -basic-aa -loop-idiom -disable-loop-idiom-memset -disable-loop-idiom-memcpy < %s -S | FileCheck %s --check-prefix=DIS-ALL
; RUN: opt -passes="loop-idiom" -aa-pipeline=basic-aa                             < %s -S | FileCheck %s --check-prefix=DIS-NONE
; RUN: opt -passes="loop-idiom" -aa-pipeline=basic-aa -disable-loop-idiom-all    < %s -S | FileCheck %s --check-prefix=DIS-ALL
; RUN: opt -passes="loop-idiom" -aa-pipeline=basic-aa -disable-loop-idiom-memcpy < %s -S | FileCheck %s --check-prefix=DIS-MEMCPY
; RUN: opt -passes="loop-idiom" -aa-pipeline=basic-aa -disable-loop-idiom-memset < %s -S | FileCheck %s --check-prefix=DIS-MEMSET
; RUN: opt -passes="loop-idiom" -aa-pipeline=basic-aa -disable-loop-idiom-memset -disable-loop-idiom-memcpy < %s -S | FileCheck %s --check-prefix=DIS-ALL

define void @test-memcpy(i64 %Size) nounwind ssp {
; DIS-NONE-LABEL: @test-memcpy(
; DIS-NONE-NEXT:  bb.nph:
; DIS-NONE-NEXT:    [[BASE:%.*]] = alloca i8, i32 10000, align 1
; DIS-NONE-NEXT:    [[DEST:%.*]] = alloca i8, i32 10000, align 1
; DIS-NONE-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 [[DEST]], i8* align 1 [[BASE]], i64 [[SIZE:%.*]], i1 false)
; DIS-NONE-NEXT:    br label [[FOR_BODY:%.*]]
; DIS-NONE:       for.body:
; DIS-NONE-NEXT:    [[INDVAR:%.*]] = phi i64 [ 0, [[BB_NPH:%.*]] ], [ [[INDVAR_NEXT:%.*]], [[FOR_BODY]] ]
; DIS-NONE-NEXT:    [[I_0_014:%.*]] = getelementptr i8, i8* [[BASE]], i64 [[INDVAR]]
; DIS-NONE-NEXT:    [[DESTI:%.*]] = getelementptr i8, i8* [[DEST]], i64 [[INDVAR]]
; DIS-NONE-NEXT:    [[V:%.*]] = load i8, i8* [[I_0_014]], align 1
; DIS-NONE-NEXT:    [[INDVAR_NEXT]] = add i64 [[INDVAR]], 1
; DIS-NONE-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVAR_NEXT]], [[SIZE]]
; DIS-NONE-NEXT:    br i1 [[EXITCOND]], label [[FOR_END:%.*]], label [[FOR_BODY]]
; DIS-NONE:       for.end:
; DIS-NONE-NEXT:    ret void
;
; DIS-ALL-LABEL: @test-memcpy(
; DIS-ALL-NEXT:  bb.nph:
; DIS-ALL-NEXT:    [[BASE:%.*]] = alloca i8, i32 10000, align 1
; DIS-ALL-NEXT:    [[DEST:%.*]] = alloca i8, i32 10000, align 1
; DIS-ALL-NEXT:    br label [[FOR_BODY:%.*]]
; DIS-ALL:       for.body:
; DIS-ALL-NEXT:    [[INDVAR:%.*]] = phi i64 [ 0, [[BB_NPH:%.*]] ], [ [[INDVAR_NEXT:%.*]], [[FOR_BODY]] ]
; DIS-ALL-NEXT:    [[I_0_014:%.*]] = getelementptr i8, i8* [[BASE]], i64 [[INDVAR]]
; DIS-ALL-NEXT:    [[DESTI:%.*]] = getelementptr i8, i8* [[DEST]], i64 [[INDVAR]]
; DIS-ALL-NEXT:    [[V:%.*]] = load i8, i8* [[I_0_014]], align 1
; DIS-ALL-NEXT:    store i8 [[V]], i8* [[DESTI]], align 1
; DIS-ALL-NEXT:    [[INDVAR_NEXT]] = add i64 [[INDVAR]], 1
; DIS-ALL-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVAR_NEXT]], [[SIZE:%.*]]
; DIS-ALL-NEXT:    br i1 [[EXITCOND]], label [[FOR_END:%.*]], label [[FOR_BODY]]
; DIS-ALL:       for.end:
; DIS-ALL-NEXT:    ret void
;
; DIS-MEMCPY-LABEL: @test-memcpy(
; DIS-MEMCPY-NEXT:  bb.nph:
; DIS-MEMCPY-NEXT:    [[BASE:%.*]] = alloca i8, i32 10000, align 1
; DIS-MEMCPY-NEXT:    [[DEST:%.*]] = alloca i8, i32 10000, align 1
; DIS-MEMCPY-NEXT:    br label [[FOR_BODY:%.*]]
; DIS-MEMCPY:       for.body:
; DIS-MEMCPY-NEXT:    [[INDVAR:%.*]] = phi i64 [ 0, [[BB_NPH:%.*]] ], [ [[INDVAR_NEXT:%.*]], [[FOR_BODY]] ]
; DIS-MEMCPY-NEXT:    [[I_0_014:%.*]] = getelementptr i8, i8* [[BASE]], i64 [[INDVAR]]
; DIS-MEMCPY-NEXT:    [[DESTI:%.*]] = getelementptr i8, i8* [[DEST]], i64 [[INDVAR]]
; DIS-MEMCPY-NEXT:    [[V:%.*]] = load i8, i8* [[I_0_014]], align 1
; DIS-MEMCPY-NEXT:    store i8 [[V]], i8* [[DESTI]], align 1
; DIS-MEMCPY-NEXT:    [[INDVAR_NEXT]] = add i64 [[INDVAR]], 1
; DIS-MEMCPY-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVAR_NEXT]], [[SIZE:%.*]]
; DIS-MEMCPY-NEXT:    br i1 [[EXITCOND]], label [[FOR_END:%.*]], label [[FOR_BODY]]
; DIS-MEMCPY:       for.end:
; DIS-MEMCPY-NEXT:    ret void
;
; DIS-MEMSET-LABEL: @test-memcpy(
; DIS-MEMSET-NEXT:  bb.nph:
; DIS-MEMSET-NEXT:    [[BASE:%.*]] = alloca i8, i32 10000, align 1
; DIS-MEMSET-NEXT:    [[DEST:%.*]] = alloca i8, i32 10000, align 1
; DIS-MEMSET-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 [[DEST]], i8* align 1 [[BASE]], i64 [[SIZE:%.*]], i1 false)
; DIS-MEMSET-NEXT:    br label [[FOR_BODY:%.*]]
; DIS-MEMSET:       for.body:
; DIS-MEMSET-NEXT:    [[INDVAR:%.*]] = phi i64 [ 0, [[BB_NPH:%.*]] ], [ [[INDVAR_NEXT:%.*]], [[FOR_BODY]] ]
; DIS-MEMSET-NEXT:    [[I_0_014:%.*]] = getelementptr i8, i8* [[BASE]], i64 [[INDVAR]]
; DIS-MEMSET-NEXT:    [[DESTI:%.*]] = getelementptr i8, i8* [[DEST]], i64 [[INDVAR]]
; DIS-MEMSET-NEXT:    [[V:%.*]] = load i8, i8* [[I_0_014]], align 1
; DIS-MEMSET-NEXT:    [[INDVAR_NEXT]] = add i64 [[INDVAR]], 1
; DIS-MEMSET-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVAR_NEXT]], [[SIZE]]
; DIS-MEMSET-NEXT:    br i1 [[EXITCOND]], label [[FOR_END:%.*]], label [[FOR_BODY]]
; DIS-MEMSET:       for.end:
; DIS-MEMSET-NEXT:    ret void
;
bb.nph:
  %Base = alloca i8, i32 10000
  %Dest = alloca i8, i32 10000
  br label %for.body

for.body:                                         ; preds = %bb.nph, %for.body
  %indvar = phi i64 [ 0, %bb.nph ], [ %indvar.next, %for.body ]
  %I.0.014 = getelementptr i8, i8* %Base, i64 %indvar
  %DestI = getelementptr i8, i8* %Dest, i64 %indvar
  %V = load i8, i8* %I.0.014, align 1
  store i8 %V, i8* %DestI, align 1
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp eq i64 %indvar.next, %Size
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @test-memset(i8* %Base, i64 %Size) nounwind ssp {
; CHECK-LABEL: @test-memset(
; CHECK-NEXT:  bb.nph:
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 1 [[BASE:%.*]], i8 0, i64 [[SIZE:%.*]], i1 false)
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVAR:%.*]] = phi i64 [ 0, [[BB_NPH:%.*]] ], [ [[INDVAR_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[I_0_014:%.*]] = getelementptr i8, i8* [[BASE]], i64 [[INDVAR]]
; CHECK-NEXT:    [[INDVAR_NEXT]] = add i64 [[INDVAR]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVAR_NEXT]], [[SIZE]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END:%.*]], label [[FOR_BODY]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
; DIS-NONE-LABEL: @test-memset(
; DIS-NONE-NEXT:  bb.nph:
; DIS-NONE-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 1 [[BASE:%.*]], i8 0, i64 [[SIZE:%.*]], i1 false)
; DIS-NONE-NEXT:    br label [[FOR_BODY:%.*]]
; DIS-NONE:       for.body:
; DIS-NONE-NEXT:    [[INDVAR:%.*]] = phi i64 [ 0, [[BB_NPH:%.*]] ], [ [[INDVAR_NEXT:%.*]], [[FOR_BODY]] ]
; DIS-NONE-NEXT:    [[I_0_014:%.*]] = getelementptr i8, i8* [[BASE]], i64 [[INDVAR]]
; DIS-NONE-NEXT:    [[INDVAR_NEXT]] = add i64 [[INDVAR]], 1
; DIS-NONE-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVAR_NEXT]], [[SIZE]]
; DIS-NONE-NEXT:    br i1 [[EXITCOND]], label [[FOR_END:%.*]], label [[FOR_BODY]]
; DIS-NONE:       for.end:
; DIS-NONE-NEXT:    ret void
;
; DIS-ALL-LABEL: @test-memset(
; DIS-ALL-NEXT:  bb.nph:
; DIS-ALL-NEXT:    br label [[FOR_BODY:%.*]]
; DIS-ALL:       for.body:
; DIS-ALL-NEXT:    [[INDVAR:%.*]] = phi i64 [ 0, [[BB_NPH:%.*]] ], [ [[INDVAR_NEXT:%.*]], [[FOR_BODY]] ]
; DIS-ALL-NEXT:    [[I_0_014:%.*]] = getelementptr i8, i8* [[BASE:%.*]], i64 [[INDVAR]]
; DIS-ALL-NEXT:    store i8 0, i8* [[I_0_014]], align 1
; DIS-ALL-NEXT:    [[INDVAR_NEXT]] = add i64 [[INDVAR]], 1
; DIS-ALL-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVAR_NEXT]], [[SIZE:%.*]]
; DIS-ALL-NEXT:    br i1 [[EXITCOND]], label [[FOR_END:%.*]], label [[FOR_BODY]]
; DIS-ALL:       for.end:
; DIS-ALL-NEXT:    ret void
;
; DIS-MEMCPY-LABEL: @test-memset(
; DIS-MEMCPY-NEXT:  bb.nph:
; DIS-MEMCPY-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 1 [[BASE:%.*]], i8 0, i64 [[SIZE:%.*]], i1 false)
; DIS-MEMCPY-NEXT:    br label [[FOR_BODY:%.*]]
; DIS-MEMCPY:       for.body:
; DIS-MEMCPY-NEXT:    [[INDVAR:%.*]] = phi i64 [ 0, [[BB_NPH:%.*]] ], [ [[INDVAR_NEXT:%.*]], [[FOR_BODY]] ]
; DIS-MEMCPY-NEXT:    [[I_0_014:%.*]] = getelementptr i8, i8* [[BASE]], i64 [[INDVAR]]
; DIS-MEMCPY-NEXT:    [[INDVAR_NEXT]] = add i64 [[INDVAR]], 1
; DIS-MEMCPY-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVAR_NEXT]], [[SIZE]]
; DIS-MEMCPY-NEXT:    br i1 [[EXITCOND]], label [[FOR_END:%.*]], label [[FOR_BODY]]
; DIS-MEMCPY:       for.end:
; DIS-MEMCPY-NEXT:    ret void
;
; DIS-MEMSET-LABEL: @test-memset(
; DIS-MEMSET-NEXT:  bb.nph:
; DIS-MEMSET-NEXT:    br label [[FOR_BODY:%.*]]
; DIS-MEMSET:       for.body:
; DIS-MEMSET-NEXT:    [[INDVAR:%.*]] = phi i64 [ 0, [[BB_NPH:%.*]] ], [ [[INDVAR_NEXT:%.*]], [[FOR_BODY]] ]
; DIS-MEMSET-NEXT:    [[I_0_014:%.*]] = getelementptr i8, i8* [[BASE:%.*]], i64 [[INDVAR]]
; DIS-MEMSET-NEXT:    store i8 0, i8* [[I_0_014]], align 1
; DIS-MEMSET-NEXT:    [[INDVAR_NEXT]] = add i64 [[INDVAR]], 1
; DIS-MEMSET-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVAR_NEXT]], [[SIZE:%.*]]
; DIS-MEMSET-NEXT:    br i1 [[EXITCOND]], label [[FOR_END:%.*]], label [[FOR_BODY]]
; DIS-MEMSET:       for.end:
; DIS-MEMSET-NEXT:    ret void
;
bb.nph:                                           ; preds = %entry
  br label %for.body

for.body:                                         ; preds = %bb.nph, %for.body
  %indvar = phi i64 [ 0, %bb.nph ], [ %indvar.next, %for.body ]
  %I.0.014 = getelementptr i8, i8* %Base, i64 %indvar
  store i8 0, i8* %I.0.014, align 1
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp eq i64 %indvar.next, %Size
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body, %entry
  ret void
}
