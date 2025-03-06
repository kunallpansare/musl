; ModuleID = 'hello.c'
source_filename = "hello.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.timespec = type { i64, i64 }

@.str = private unnamed_addr constant [14 x i8] c"clock_gettime\00", align 1
@.str.1 = private unnamed_addr constant [30 x i8] c"Starting malloc benchmark...\0A\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"malloc\00", align 1
@.str.3 = private unnamed_addr constant [49 x i8] c"Elapsed time for malloc benchmark: %.9f seconds\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca %struct.timespec, align 8
  %3 = alloca %struct.timespec, align 8
  %4 = alloca i32*, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca double, align 8
  store i32 0, i32* %1, align 4
  %8 = call i32 @clock_gettime(i32 1, %struct.timespec* %2) #4
  %9 = icmp eq i32 %8, -1
  br i1 %9, label %10, label %11

10:                                               ; preds = %0
  call void @perror(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0)) #5
  store i32 1, i32* %1, align 4
  br label %43

11:                                               ; preds = %0
  %12 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([30 x i8], [30 x i8]* @.str.1, i64 0, i64 0))
  %13 = call noalias i8* @malloc(i64 4000000) #4
  %14 = bitcast i8* %13 to i32*
  store i32* %14, i32** %4, align 8
  %15 = load i32*, i32** %4, align 8
  %16 = icmp eq i32* %15, null
  br i1 %16, label %17, label %18

17:                                               ; preds = %11
  call void @perror(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i64 0, i64 0)) #5
  store i32 1, i32* %1, align 4
  br label %43

18:                                               ; preds = %11
  %19 = load i32*, i32** %4, align 8
  %20 = bitcast i32* %19 to i8*
  call void @free(i8* %20) #4
  %21 = call i32 @clock_gettime(i32 1, %struct.timespec* %3) #4
  %22 = icmp eq i32 %21, -1
  br i1 %22, label %23, label %24

23:                                               ; preds = %18
  call void @perror(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0)) #5
  store i32 1, i32* %1, align 4
  br label %43

24:                                               ; preds = %18
  %25 = getelementptr inbounds %struct.timespec, %struct.timespec* %3, i32 0, i32 0
  %26 = load i64, i64* %25, align 8
  %27 = getelementptr inbounds %struct.timespec, %struct.timespec* %2, i32 0, i32 0
  %28 = load i64, i64* %27, align 8
  %29 = sub nsw i64 %26, %28
  store i64 %29, i64* %5, align 8
  %30 = getelementptr inbounds %struct.timespec, %struct.timespec* %3, i32 0, i32 1
  %31 = load i64, i64* %30, align 8
  %32 = getelementptr inbounds %struct.timespec, %struct.timespec* %2, i32 0, i32 1
  %33 = load i64, i64* %32, align 8
  %34 = sub nsw i64 %31, %33
  store i64 %34, i64* %6, align 8
  %35 = load i64, i64* %5, align 8
  %36 = sitofp i64 %35 to double
  %37 = load i64, i64* %6, align 8
  %38 = sitofp i64 %37 to double
  %39 = fmul double %38, 1.000000e-09
  %40 = fadd double %36, %39
  store double %40, double* %7, align 8
  %41 = load double, double* %7, align 8
  %42 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([49 x i8], [49 x i8]* @.str.3, i64 0, i64 0), double %41)
  store i32 0, i32* %1, align 4
  br label %43

43:                                               ; preds = %24, %23, %17, %10
  %44 = load i32, i32* %1, align 4
  ret i32 %44
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
