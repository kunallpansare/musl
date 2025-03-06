// #include <stdio.h>
// #include <stdlib.h>
// #include <string.h>
// #include <stdint.h> // Include this for uint64_t

// typedef struct table_entry {
//    uint64_t* table;
//    int n;
//    char* func_name;
//    struct table_entry* next;
// } table_entry;

// table_entry* first = NULL;
// table_entry* last = NULL;

// // create a table for each function and insert it into the 
// // ll of function tables
// void* init_table(int size, char* func_name) {
//     // printf("init table for %s\n", func_name);
//     table_entry* entry = malloc(sizeof(table_entry));
//     uint64_t* table = malloc(size*sizeof(uint64_t));
//     memset(table, 0, size * sizeof(uint64_t));

//     // init data
//     entry->table = table;
//     entry->n = size;
//     entry->func_name = func_name;
//     entry->next = NULL;

//     // insert into ll
//     if (first == NULL) {
//         first = entry;
//         last = entry;
//     } else {
//         last->next = entry;
//         last = entry;
//     }
//     return entry;
// }

// // increment index i of the given table
// void inc_table_entry(table_entry* entry, int i) {
//     // printf("increment entry %d of %s\n", i, entry->func_name);
//     entry->table[i]++;
// }

// // print all the results for each function
// void print_results() {
//     table_entry* next = first;
//     while(next != NULL) {
//         int i;
//         printf("%s:\n", next->func_name);
//         for (i = 0; i < next->n; i++) {
//             printf("\t%d = %lld\n", i, next->table[i]);
//         }
//         free(next->table);
//         table_entry* prev = next;
//         next = next->next;
//         free(prev);
//     }
// }

// #include <stdio.h>
// #include <stdlib.h>
// #include <stdint.h>

// // ------------------------------------------------------------------
// // We define a single global variable that records the last path ID.
// // Use 'volatile' to prevent overly aggressive compiler optimizations 
// // when measuring overheads.
// volatile int64_t g_last_path_id = 0;

// // ------------------------------------------------------------------
// // We keep the same signature, but return NULL (or any dummy pointer).
// // This avoids calling malloc and prevents the malloc->init_table->malloc cycle.

// void* init_table(int size, char* func_name) {
//     // Do nothing; just return a dummy pointer
//     (void)size;       // unused
//     (void)func_name;  // unused
//     return NULL;
// }

// // ------------------------------------------------------------------
// // Instead of incrementing an entry in a per-function table, 
// // just update our global variable.

// void inc_table_entry(void* dummy_table, int i) {
//     // We simply record the path number 'i' in the global variable.
//     // 'dummy_table' is ignored here.
//     (void)dummy_table;  
//     g_last_path_id = i;
// }

// // ------------------------------------------------------------------
// // Print out the final recorded path number.

// void print_results() {
//     printf("Last recorded path ID: %lld\n", (long long)g_last_path_id);
// }

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define SMC_CALL_OVERHEAD_US 190
#define SMC_CALL_THRESHOLD 64000000


volatile int64_t g_last_path_id = 0;
volatile uint64_t smc_counter = 0;


void* init_table(int size, char* func_name) {
    (void)size;       // unused
    (void)func_name;  // unused
    return NULL;
}


void inc_table_entry(void* dummy_table, int i) {
    (void)dummy_table;   // unused
    g_last_path_id = i;
    smc_counter++;


    if (smc_counter >= SMC_CALL_THRESHOLD) {
        for (int i = 0; i < 200000; i++) {
        // A no-op to prevent the compiler from optimizing away the loop
        __asm__ __volatile__ (""); 
        }
        smc_counter = 0; // Reset the counter after triggering SMC
    }
}



void print_results() {
    printf("Last recorded path ID: %lld\n", (long long)g_last_path_id);
}

