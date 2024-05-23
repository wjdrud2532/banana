#include <stdio.h>
#include <pthread.h>

// 공유 변수 
int shared_var = 0;

// CAS 연산 함수

int atomic_cas(int* ptr, int old_value, int new_value)
{
	int result;

	__asm__ __volatile__(
		"lock cmpxchg %1, %2"
		: "=a" (result)
		: "r" (new_value), "m" (*ptr), "a" (old_value)
		: "memory"
	);

	return result;
}


//스레드 함수
void* thread_func(void* arg) 
{
	int old_val, new_val;

	//공유 변수 
	old_val = shared_var;

	//새로운 값 계산
	new_val = old_val + 1;

	//CAS 연산 수행
	while (atomic_cas(&shared_var, old_val, new_val) != old_val)
	{
		// CAS 
		old_val = shared_var;
		new_val = old_val + 1;
	}
	
	return NULL;
}


int main()
{
	pthread_t threads[2];

	//두 개의 스레드 생성
	for(int i = 0; i < 2; i ++)
	{
		pthread_create(&threads[i], NULL, thread_func, NULL);
	}

	//스레드 종료 대기
	for(int i = 0; i < 2; i ++)
	{
		pthread_join(threads[i], NULL);
	}


	//공유 변수 출력
	printf("shared_var: %d\n", shared_var);

	return 0;
}




