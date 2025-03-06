// #include <stdio.h>

// #define _POSIX_C_SOURCE 199309L
// #include <time.h>
// #include <stdio.h>
// #include <stdlib.h>
// #include <string.h>
// #include <math.h>
// #include <unistd.h>

// #define ARRAY_SIZE 1000000

// int main() {
//     struct timespec start, end;
//     if (clock_gettime(CLOCK_MONOTONIC, &start) == -1) {
//         perror("clock_gettime");
//         return 1;
//     }

//     printf("Starting benchmark...\n");

//     // 1. File I/O operations
//     FILE *file = fopen("benchmark_test.txt", "w");
//     if (file) {
//         fprintf(file, "Testing file I/O operations...\n");
//         fclose(file);
//     }

//     file = fopen("benchmark_test.txt", "r");
//     if (file) {
//         char buffer[256];
//         fgets(buffer, sizeof(buffer), file);
//         fclose(file);
//     }

//     // 2. Memory allocation and deallocation
//     int *arr = (int *)malloc(ARRAY_SIZE * sizeof(int));
//     if (arr) {
//         for (int i = 0; i < ARRAY_SIZE; i++) {
//             arr[i] = i * 2;
//         }
//         free(arr);
//     }

//     // 3. String manipulation
//     char str1[] = "Benchmarking";
//     char str2[] = "Libc Functions";
//     char str3[50];
//     strcpy(str3, str1);
//     strcat(str3, " with ");
//     strcat(str3, str2);

//     // 4. Mathematical computations
//     double sum = 0.0;
//     for (int i = 1; i <= 10000; i++) {
//         sum += sqrt(i) + log(i) + exp(i % 10);
//     }

//     // 5. System call: sleep for 1 millisecond
//     usleep(1000);

//     // 6. Environment variable operations
//     setenv("TEST_ENV_VAR", "12345", 1);
//     char *env_var = getenv("TEST_ENV_VAR");

//     // 7. Sorting an array (qsort)
//     int nums[] = {9, 5, 3, 8, 2, 6, 4, 7, 1, 0};
//     qsort(nums, 10, sizeof(int), (int (*)(const void *, const void *)) strcmp);

//     // 8. Generating random numbers
//     srand(time(NULL));
//     for (int i = 0; i < 10; i++) {
//         rand();
//     }

//     // 9. Getting process ID
//     int id = getpid(); 

//     // End time measurement
//     if (clock_gettime(CLOCK_MONOTONIC, &end) == -1) {
//         perror("clock_gettime");
//         return 1;
//     }

//     long seconds = end.tv_sec - start.tv_sec;
//     long nanoseconds = end.tv_nsec - start.tv_nsec;
//     double elapsed = seconds + nanoseconds * 1e-9;

//     printf("Elapsed time: %.9f seconds\n", elapsed);
//     return 0;
// }

//1. malloc

#define _POSIX_C_SOURCE 199309L
#include <time.h>
#include <stdio.h>
#include <stdlib.h>

#define ARRAY_SIZE 1000000

int main() {
    struct timespec start, end;

    // Start time measurement
    if (clock_gettime(CLOCK_MONOTONIC, &start) == -1) {
        perror("clock_gettime");
        return 1;
    }

    printf("Starting malloc benchmark...\n");

    // Memory allocation benchmark using malloc
    int *arr = (int *)malloc(ARRAY_SIZE * sizeof(int));
    if (arr == NULL) {
        perror("malloc");
        return 1;
    }

    // Simple operation to prevent compiler optimization
    // for (int i = 0; i < ARRAY_SIZE; i++) {
    //     arr[i] = i;
    // }

    // Free the allocated memory
    free(arr);

    // End time measurement
    if (clock_gettime(CLOCK_MONOTONIC, &end) == -1) {
        perror("clock_gettime");
        return 1;
    }

    long seconds = end.tv_sec - start.tv_sec;
    long nanoseconds = end.tv_nsec - start.tv_nsec;
    double elapsed = seconds + nanoseconds * 1e-9;

    printf("Elapsed time for malloc benchmark: %.9f seconds\n", elapsed);

    return 0;
}

//memcpy

// #define _POSIX_C_SOURCE 199309L
// #include <time.h>
// #include <stdio.h>
// #include <stdlib.h>
// #include <string.h>

// #define ARRAY_SIZE 1000000

// int main() {
//     struct timespec start, end;

//     // Start time measurement
//     if (clock_gettime(CLOCK_MONOTONIC, &start) == -1) {
//         perror("clock_gettime");
//         return 1;
//     }

//     printf("Starting memcpy benchmark...\n");

//     // Allocate memory for source and destination arrays
//     char *src = (char *)malloc(ARRAY_SIZE * sizeof(char));
//     char *dest = (char *)malloc(ARRAY_SIZE * sizeof(char));

//     if (src == NULL || dest == NULL) {
//         perror("malloc");
//         return 1;
//     }

//     // Initialize source array with some data
//     for (int i = 0; i < ARRAY_SIZE; i++) {
//         src[i] = (char)(i % 256);
//     }

//     // Benchmark memcpy
//     memcpy(dest, src, ARRAY_SIZE);

//     // Free allocated memory
//     free(src);
//     free(dest);

//     // End time measurement
//     if (clock_gettime(CLOCK_MONOTONIC, &end) == -1) {
//         perror("clock_gettime");
//         return 1;
//     }

//     long seconds = end.tv_sec - start.tv_sec;
//     long nanoseconds = end.tv_nsec - start.tv_nsec;
//     double elapsed = seconds + nanoseconds * 1e-9;

//     printf("Elapsed time for memcpy benchmark: %.9f seconds\n", elapsed);

//     return 0;
// }


//3 . strcpy, strncpy

// #define _POSIX_C_SOURCE 199309L
// #include <time.h>
// #include <stdio.h>
// #include <stdlib.h>
// #include <string.h>

// #define ARRAY_SIZE 1000000

// int main() {
//     struct timespec start, end;

//     // Allocate memory for source and destination strings
//     char *src = (char *)malloc(ARRAY_SIZE * sizeof(char));
//     char *dest1 = (char *)malloc(ARRAY_SIZE * sizeof(char));
//     char *dest2 = (char *)malloc(ARRAY_SIZE * sizeof(char));

//     if (src == NULL || dest1 == NULL || dest2 == NULL) {
//         perror("malloc");
//         return 1;
//     }

//     // Initialize source string with some data
//     memset(src, 'A', ARRAY_SIZE - 1);
//     src[ARRAY_SIZE - 1] = '\0';

//     // Benchmark strcpy
//     if (clock_gettime(CLOCK_MONOTONIC, &start) == -1) {
//         perror("clock_gettime");
//         return 1;
//     }

//     strcpy(dest1, src);

//     if (clock_gettime(CLOCK_MONOTONIC, &end) == -1) {
//         perror("clock_gettime");
//         return 1;
//     }

//     long seconds = end.tv_sec - start.tv_sec;
//     long nanoseconds = end.tv_nsec - start.tv_nsec;
//     double elapsed_strcpy = seconds + nanoseconds * 1e-9;

//     printf("Elapsed time for strcpy benchmark: %.9f seconds\n", elapsed_strcpy);

//     // Benchmark strncpy
//     if (clock_gettime(CLOCK_MONOTONIC, &start) == -1) {
//         perror("clock_gettime");
//         return 1;
//     }

//     strncpy(dest2, src, ARRAY_SIZE);

//     if (clock_gettime(CLOCK_MONOTONIC, &end) == -1) {
//         perror("clock_gettime");
//         return 1;
//     }

//     seconds = end.tv_sec - start.tv_sec;
//     nanoseconds = end.tv_nsec - start.tv_nsec;
//     double elapsed_strncpy = seconds + nanoseconds * 1e-9;

//     printf("Elapsed time for strncpy benchmark: %.9f seconds\n", elapsed_strncpy);

//     // Free allocated memory
//     free(src);
//     free(dest1);
//     free(dest2);

//     return 0;
// }


//4 

// #define _POSIX_C_SOURCE 199309L
// #include <time.h>
// #include <stdio.h>
// #include <stdlib.h>
// #include <string.h>

// #define ARRAY_SIZE 1000000

// int main() {
//     struct timespec start, end;

//     // Allocate memory for source and destination strings
//     char *src = (char *)malloc(ARRAY_SIZE * sizeof(char));
//     char *dest1 = (char *)malloc(ARRAY_SIZE * 2 * sizeof(char));
//     char *dest2 = (char *)malloc(ARRAY_SIZE * 2 * sizeof(char));

//     if (src == NULL || dest1 == NULL || dest2 == NULL) {
//         perror("malloc");
//         return 1;
//     }

//     // Initialize source and destination strings with some data
//     memset(src, 'A', ARRAY_SIZE - 1);
//     src[ARRAY_SIZE - 1] = '\0';
//     memset(dest1, 'B', ARRAY_SIZE - 1);
//     dest1[ARRAY_SIZE - 1] = '\0';
//     memset(dest2, 'B', ARRAY_SIZE - 1);
//     dest2[ARRAY_SIZE - 1] = '\0';

//     // Benchmark strcat
//     if (clock_gettime(CLOCK_MONOTONIC, &start) == -1) {
//         perror("clock_gettime");
//         return 1;
//     }

//     strcat(dest1, src);

//     if (clock_gettime(CLOCK_MONOTONIC, &end) == -1) {
//         perror("clock_gettime");
//         return 1;
//     }

//     long seconds = end.tv_sec - start.tv_sec;
//     long nanoseconds = end.tv_nsec - start.tv_nsec;
//     double elapsed_strcat = seconds + nanoseconds * 1e-9;

//     printf("Elapsed time for strcat benchmark: %.9f seconds\n", elapsed_strcat);

//     // Benchmark strncat
//     if (clock_gettime(CLOCK_MONOTONIC, &start) == -1) {
//         perror("clock_gettime");
//         return 1;
//     }

//     strncat(dest2, src, ARRAY_SIZE);

//     if (clock_gettime(CLOCK_MONOTONIC, &end) == -1) {
//         perror("clock_gettime");
//         return 1;
//     }

//     seconds = end.tv_sec - start.tv_sec;
//     nanoseconds = end.tv_nsec - start.tv_nsec;
//     double elapsed_strncat = seconds + nanoseconds * 1e-9;

//     printf("Elapsed time for strncat benchmark: %.9f seconds\n", elapsed_strncat);

//     // Free allocated memory
//     free(src);
//     free(dest1);
//     free(dest2);

//     return 0;
// }

// 5. qsort

// #define _POSIX_C_SOURCE 199309L
// #include <time.h>
// #include <stdio.h>
// #include <stdlib.h>

// #define ARRAY_SIZE 1000000

// // Comparison function for qsort
// int compare(const void *a, const void *b) {
//     int x = *(int *)a;
//     int y = *(int *)b;
//     return (x > y) - (x < y);
// }

// int main() {
//     struct timespec start, end;

//     // Allocate memory for the array
//     int *arr = (int *)malloc(ARRAY_SIZE * sizeof(int));
//     if (arr == NULL) {
//         perror("malloc");
//         return 1;
//     }

//     // Initialize the array with random integers
//     srand(time(NULL));
//     for (int i = 0; i < ARRAY_SIZE; i++) {
//         arr[i] = rand();
//     }

//     // Benchmark qsort
//     if (clock_gettime(CLOCK_MONOTONIC, &start) == -1) {
//         perror("clock_gettime");
//         free(arr);
//         return 1;
//     }

//     qsort(arr, ARRAY_SIZE, sizeof(int), compare);

//     if (clock_gettime(CLOCK_MONOTONIC, &end) == -1) {
//         perror("clock_gettime");
//         free(arr);
//         return 1;
//     }

//     long seconds = end.tv_sec - start.tv_sec;
//     long nanoseconds = end.tv_nsec - start.tv_nsec;
//     double elapsed = seconds + nanoseconds * 1e-9;

//     printf("Elapsed time for qsort benchmark: %.9f seconds\n", elapsed);

//     // Free allocated memory
//     free(arr);

//     return 0;
// }


//7. bsearch

// #define _POSIX_C_SOURCE 199309L
// #include <time.h>
// #include <stdio.h>
// #include <stdlib.h>

// #define ARRAY_SIZE 1000000

// // Comparison function for bsearch
// int compare(const void *a, const void *b) {
//     int x = *(int *)a;
//     int y = *(int *)b;
//     return (x > y) - (x < y);
// }

// int main() {
//     struct timespec start, end;

//     // Allocate memory for the array
//     int *arr = (int *)malloc(ARRAY_SIZE * sizeof(int));
//     if (arr == NULL) {
//         perror("malloc");
//         return 1;
//     }

//     // Initialize the array with sorted integers
//     for (int i = 0; i < ARRAY_SIZE; i++) {
//         arr[i] = i;
//     }

//     int key = ARRAY_SIZE / 2;

//     // Benchmark bsearch
//     if (clock_gettime(CLOCK_MONOTONIC, &start) == -1) {
//         perror("clock_gettime");
//         free(arr);
//         return 1;
//     }

//     int *result = (int *)bsearch(&key, arr, ARRAY_SIZE, sizeof(int), compare);

//     if (clock_gettime(CLOCK_MONOTONIC, &end) == -1) {
//         perror("clock_gettime");
//         free(arr);
//         return 1;
//     }

//     long seconds = end.tv_sec - start.tv_sec;
//     long nanoseconds = end.tv_nsec - start.tv_nsec;
//     double elapsed = seconds + nanoseconds * 1e-9;

//     if (result != NULL) {
//         printf("Element found: %d\n", *result);
//     } else {
//         printf("Element not found\n");
//     }

//     printf("Elapsed time for bsearch benchmark: %.9f seconds\n", elapsed);

//     // Free allocated memory
//     free(arr);

//     return 0;
// }


//8 fopen, fclose

// #define _POSIX_C_SOURCE 199309L
// #include <time.h>
// #include <stdio.h>
// #include <stdlib.h>

// #define ITERATIONS 1000

// int main() {
//     struct timespec start, end;
//     double total_time = 0.0;

//     for (int i = 0; i < ITERATIONS; i++) {
//         // Start time measurement
//         if (clock_gettime(CLOCK_MONOTONIC, &start) == -1) {
//             perror("clock_gettime");
//             return 1;
//         }

//         // Open and close file
//         FILE *file = fopen("benchmark_test.txt", "w");
//         if (file == NULL) {
//             perror("fopen");
//             return 1;
//         }
//         fclose(file);

//         // End time measurement
//         if (clock_gettime(CLOCK_MONOTONIC, &end) == -1) {
//             perror("clock_gettime");
//             return 1;
//         }

//         long seconds = end.tv_sec - start.tv_sec;
//         long nanoseconds = end.tv_nsec - start.tv_nsec;
//         double elapsed = seconds + nanoseconds * 1e-9;

//         total_time += elapsed;
//     }

//     double average_time = total_time / ITERATIONS;
//     printf("Average elapsed time for fopen and fclose benchmark: %.9f seconds\n", average_time);

//     return 0;
// }


// 9. sleep, usleep, nanosleep

// #define _POSIX_C_SOURCE 199309L
// #include <time.h>
// #include <stdio.h>
// #include <stdlib.h>
// #include <unistd.h>

// #define ITERATIONS 10

// int main() {
//     struct timespec start, end;
//     double total_time = 0.0;

//     for (int i = 0; i < ITERATIONS; i++) {
//         // Start time measurement
//         if (clock_gettime(CLOCK_MONOTONIC, &start) == -1) {
//             perror("clock_gettime");
//             return 1;
//         }

//         // Perform sleep operations
//         sleep(1);       // Sleep for 1 second
//         usleep(1000000); // Sleep for 1 second (1,000,000 microseconds)

//         struct timespec req = {1, 0};
//         nanosleep(&req, NULL); // Sleep for 1 second

//         // End time measurement
//         if (clock_gettime(CLOCK_MONOTONIC, &end) == -1) {
//             perror("clock_gettime");
//             return 1;
//         }

//         long seconds = end.tv_sec - start.tv_sec;
//         long nanoseconds = end.tv_nsec - start.tv_nsec;
//         double elapsed = seconds + nanoseconds * 1e-9;

//         total_time += elapsed;
//     }

//     double average_time = total_time / ITERATIONS;
//     printf("Average elapsed time for sleep, usleep, and nanosleep benchmark: %.9f seconds\n", average_time);

//     return 0;
// }
// rand, srand


// #define _POSIX_C_SOURCE 199309L
// #include <time.h>
// #include <stdio.h>
// #include <stdlib.h>

// #define ITERATIONS 1000

// int main() {
//     struct timespec start, end;
//     double total_time = 0.0;

//     for (int i = 0; i < ITERATIONS; i++) {
//         // Start time measurement
//         if (clock_gettime(CLOCK_MONOTONIC, &start) == -1) {
//             perror("clock_gettime");
//             return 1;
//         }

//         // Perform srand and rand operations
//         srand((unsigned int)time(NULL));
//         for (int j = 0; j < 1000; j++) {
//             rand();
//         }

//         // End time measurement
//         if (clock_gettime(CLOCK_MONOTONIC, &end) == -1) {
//             perror("clock_gettime");
//             return 1;
//         }

//         long seconds = end.tv_sec - start.tv_sec;
//         long nanoseconds = end.tv_nsec - start.tv_nsec;
//         double elapsed = seconds + nanoseconds * 1e-9;

//         total_time += elapsed;
//     }

//     double average_time = total_time / ITERATIONS;
//     printf("Average elapsed time for rand and srand benchmark: %.9f seconds\n", average_time);

//     return 0;
// }


// 10. fork

// #define _POSIX_C_SOURCE 199309L
// #include <time.h>
// #include <stdio.h>
// #include <stdlib.h>
// #include <unistd.h>
// #include <sys/wait.h>

// #define ITERATIONS 100

// int main() {
//     struct timespec start, end;
//     double total_time = 0.0;

//     for (int i = 0; i < ITERATIONS; i++) {
//         // Start time measurement
//         if (clock_gettime(CLOCK_MONOTONIC, &start) == -1) {
//             perror("clock_gettime");
//             return 1;
//         }

//         // Perform fork operation
//         pid_t pid = fork();

//         if (pid < 0) {
//             perror("fork");
//             return 1;
//         } else if (pid == 0) {
//             // Child process exits immediately
//             exit(0);
//         } else {
//             // Parent process waits for the child to finish
//             wait(NULL);
//         }

//         // End time measurement
//         if (clock_gettime(CLOCK_MONOTONIC, &end) == -1) {
//             perror("clock_gettime");
//             return 1;
//         }

//         long seconds = end.tv_sec - start.tv_sec;
//         long nanoseconds = end.tv_nsec - start.tv_nsec;
//         double elapsed = seconds + nanoseconds * 1e-9;

//         total_time += elapsed;
//     }

//     double average_time = total_time / ITERATIONS;
//     printf("Average elapsed time for fork benchmark: %.9f seconds\n", average_time);

//     return 0;
// }


//11. fprintf, printf

// #define _POSIX_C_SOURCE 199309L
// #include <time.h>
// #include <stdio.h>
// #include <stdlib.h>

// #define ITERATIONS 1000

// int main() {
//     struct timespec start, end;
//     double total_time = 0.0;

//     for (int i = 0; i < ITERATIONS; i++) {
//         // Start time measurement
//         if (clock_gettime(CLOCK_MONOTONIC, &start) == -1) {
//             perror("clock_gettime");
//             return 1;
//         }

//         // Perform fprintf operation
//         FILE *file = fopen("benchmark_test.txt", "w");
//         if (file == NULL) {
//             perror("fopen");
//             return 1;
//         }
//         fprintf(file, "Iteration: %d\n", i);
//         fclose(file);

//         // Perform printf operation
//         printf("Iteration: %d\n", i);

//         // End time measurement
//         if (clock_gettime(CLOCK_MONOTONIC, &end) == -1) {
//             perror("clock_gettime");
//             return 1;
//         }

//         long seconds = end.tv_sec - start.tv_sec;
//         long nanoseconds = end.tv_nsec - start.tv_nsec;
//         double elapsed = seconds + nanoseconds * 1e-9;

//         total_time += elapsed;
//     }

//     double average_time = total_time / ITERATIONS;
//     printf("Average elapsed time for fprintf and printf benchmark: %.9f seconds\n", average_time);

//     return 0;
// }


// objdump -D helloworld
// gcc -o helloworld hello.c -L/usr/lib -I/usr/local/musl/include -lc -static
// gcc -c hello.c -I/usr/local/musl/include -o hello.o
// objdump -d ./helloworld | less
// objdump -d --disassemble=malloc ./helloworld
// gdb ./helloworld 
// run


// /usr/local/bin/clang -emit-llvm -S hello.c
// /usr/local/bin/opt -load /home/kunalpansare/llvm-pass-skeleton/build/skeleton/libSkeletonPass.* -skeleton -S hello.ll -o test_pass.ll
// /usr/local/bin/clang -c test_pass.ll
// /usr/local/bin/clang -c extras.c
// /usr/local/bin/clang extras.o test_pass.o -o test.bin -L/usr/lib -I/usr/local/musl/include -lc -static
// ./test.bin

 // 0.016433550
 // 0.017000583
// 0.015161492

// /usr/local/bin/clang -o helloworld hello.c -L/usr/lib -I/usr/local/musl/include -lc -static

//0.014964600
//0.015169369
// 0.013279296
// 0.013481943