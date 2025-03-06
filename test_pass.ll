; ModuleID = 'hello.ll'
source_filename = "hello.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.timespec = type { i64, i64 }

@.str = private unnamed_addr constant [14 x i8] c"clock_gettime\00", align 1
@.str.1 = private unnamed_addr constant [30 x i8] c"Starting malloc benchmark...\0A\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"malloc\00", align 1
@.str.3 = private unnamed_addr constant [49 x i8] c"Elapsed time for malloc benchmark: %.9f seconds\0A\00", align 1
@__main_table = private global i8* null, align 8
@0 = private unnamed_addr constant [5 x i8] c"main\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
check_init:
  %0 = alloca i32, align 4
  store i32 0, i32* %0, align 4
  %1 = load i8*, i8** @__main_table, align 8
  %2 = icmp eq i8* %1, null
  br i1 %2, label %is_uninit, label %block0

block0:                                           ; preds = %is_uninit, %check_init
  %3 = alloca i32, align 4
  %4 = alloca %struct.timespec, align 8
  %5 = alloca %struct.timespec, align 8
  %6 = alloca i32*, align 8
  %7 = alloca i64, align 8
  %8 = alloca i64, align 8
  %9 = alloca double, align 8
  store i32 0, i32* %3, align 4
  %10 = call i32 @clock_gettime(i32 1, %struct.timespec* %4) #4
  %11 = icmp eq i32 %10, -1
  br i1 %11, label %block1, label %block2

block1:                                           ; preds = %block0
  call void @perror(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0)) #5
  store i32 1, i32* %3, align 4
  br label %block7

block2:                                           ; preds = %block0
  %12 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([30 x i8], [30 x i8]* @.str.1, i64 0, i64 0))
  %13 = call noalias i8* @malloc(i64 4000000) #4
  %14 = bitcast i8* %13 to i32*
  store i32* %14, i32** %6, align 8
  %15 = load i32*, i32** %6, align 8
  %16 = icmp eq i32* %15, null
  br i1 %16, label %block3, label %block4

block3:                                           ; preds = %block2
  call void @perror(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i64 0, i64 0)) #5
  store i32 1, i32* %3, align 4
  br label %45

block4:                                           ; preds = %block2
  %17 = load i32*, i32** %6, align 8
  %18 = bitcast i32* %17 to i8*
  call void @free(i8* %18) #4
  %19 = call i32 @clock_gettime(i32 1, %struct.timespec* %5) #4
  %20 = icmp eq i32 %19, -1
  br i1 %20, label %block5, label %block6

block5:                                           ; preds = %block4
  call void @perror(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0)) #5
  store i32 1, i32* %3, align 4
  br label %42

block6:                                           ; preds = %block4
  %21 = getelementptr inbounds %struct.timespec, %struct.timespec* %5, i32 0, i32 0
  %22 = load i64, i64* %21, align 8
  %23 = getelementptr inbounds %struct.timespec, %struct.timespec* %4, i32 0, i32 0
  %24 = load i64, i64* %23, align 8
  %25 = sub nsw i64 %22, %24
  store i64 %25, i64* %7, align 8
  %26 = getelementptr inbounds %struct.timespec, %struct.timespec* %5, i32 0, i32 1
  %27 = load i64, i64* %26, align 8
  %28 = getelementptr inbounds %struct.timespec, %struct.timespec* %4, i32 0, i32 1
  %29 = load i64, i64* %28, align 8
  %30 = sub nsw i64 %27, %29
  store i64 %30, i64* %8, align 8
  %31 = load i64, i64* %7, align 8
  %32 = sitofp i64 %31 to double
  %33 = load i64, i64* %8, align 8
  %34 = sitofp i64 %33 to double
  %35 = fmul double %34, 1.000000e-09
  %36 = fadd double %32, %35
  store double %36, double* %9, align 8
  %37 = load double, double* %9, align 8
  %38 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([49 x i8], [49 x i8]* @.str.3, i64 0, i64 0), double %37)
  store i32 0, i32* %3, align 4
  br label %39

39:                                               ; preds = %block6
  %40 = load i32, i32* %0, align 4
  %41 = add i32 %40, 3
  store i32 %41, i32* %0, align 4
  br label %block7

42:                                               ; preds = %block5
  %43 = load i32, i32* %0, align 4
  %44 = add i32 %43, 2
  store i32 %44, i32* %0, align 4
  br label %block7

45:                                               ; preds = %block3
  %46 = load i32, i32* %0, align 4
  %47 = add i32 %46, 1
  store i32 %47, i32* %0, align 4
  br label %block7

block7:                                           ; preds = %45, %42, %39, %block1
  %48 = load i32, i32* %3, align 4
  %49 = load i8*, i8** @__main_table, align 8
  %50 = load i32, i32* %0, align 4
  call void @inc_table_entry(i8* %49, i32 %50)
  call void @print_results()
  ret i32 %48

is_uninit:                                        ; preds = %check_init
  %51 = call i8* @init_table(i32 500, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @0, i32 0, i32 0))
  store i8* %51, i8** @__main_table, align 8
  br label %block0
}

; Function Attrs: nounwind
declare dso_local i32 @clock_gettime(i32, %struct.timespec*) #1

; Function Attrs: cold
declare dso_local void @perror(i8*) #2

declare dso_local i32 @printf(i8*, ...) #3

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #1

; Function Attrs: nounwind
declare dso_local void @free(i8*) #1

declare i8* @init_table(i32, i8*)

declare void @inc_table_entry(i8*, i32)

declare void @print_results()

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { cold "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }
attributes #5 = { cold }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 11.1.0 (https://github.com/llvm/llvm-project.git 1fdec59bffc11ae37eb51a1b9869f0696bfd5312)"}
