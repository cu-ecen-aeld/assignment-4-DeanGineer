#include "threading.h"
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

// Optional: use these functions to add debug or error prints to your application
#define DEBUG_LOG(msg,...)
//#define DEBUG_LOG(msg,...) printf("threading: " msg "\n" , ##__VA_ARGS__)
#define ERROR_LOG(msg,...) printf("threading ERROR: " msg "\n" , ##__VA_ARGS__)

void* threadfunc(void* thread_param)
{

    // TODO: wait, obtain mutex, wait, release mutex as described by thread_data structure
    // hint: use a cast like the one below to obtain thread arguments from your parameter
    //struct thread_data* thread_func_args = (struct thread_data *) thread_param;
    
    struct thread_data* thread_func_args = (struct thread_data *) thread_param;
    
    //wait
    DEBUG_LOG("Thread %d: Waiting for %d ms before locking mutex.\n", thread_func_args->t_id, thread_func_args->wait_delay);
    usleep(thread_func_args->wait_delay);  // Initial wait before locking
	//obtain mutex
    DEBUG_LOG("Thread %d: Trying to lock the mutex...\n", thread_func_args->t_id);
    pthread_mutex_lock(thread_func_args->mutex);  // Lock mutex
	//wait
    DEBUG_LOG("Thread %d: Locked mutex, waiting inside for %d ms.\n", thread_func_args->t_id, thread_func_args->wait_hold);
    usleep(thread_func_args->wait_hold);  // Wait while holding the mutex
	//release mutex
    DEBUG_LOG("Thread %d: Releasing the mutex.\n", thread_func_args->t_id);
    pthread_mutex_unlock(thread_func_args->mutex);  // Unlock mutex
    
    
    return thread_param;
}


bool start_thread_obtaining_mutex(pthread_t *thread, pthread_mutex_t *mutex,int wait_to_obtain_ms, int wait_to_release_ms)
{
    /**
     * TODO: allocate memory for thread_data, setup mutex and wait arguments, pass thread_data to created thread
     * using threadfunc() as entry point.
     *
     * return true if successful.
     *
     * See implementation details in threading.h file comment block
     */
     
     //allocate memory for thread_data
     struct thread_data* t_data = (struct thread_data *)malloc(sizeof(struct thread_data));
    if (!t_data) {
        return false; // Memory allocation failed
    }
     
     //setup mutex and wait arguments
	t_data->mutex = mutex;
    t_data->wait_delay = wait_to_obtain_ms;
    t_data->wait_hold = wait_to_release_ms;
    t_data->thread_complete_success = false;
    
    // Create the thread
    if (pthread_create(thread, NULL, threadfunc, t_data) != 0) {
        free(t_data); // Cleanup memory on failure
        return false;
    }else{
		t_data->thread_complete_success = true;
		return true;
	}
     
     
    ERROR_LOG("This point should not be reached!\n");
    return false;
}

