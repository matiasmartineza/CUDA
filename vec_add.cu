#include <stdio.h>

__global__ void vec_add(float *A, float *B, float *C, int N){
	int i = threadIdx.x + blockDim.x * blockIdx.x;
	
	if (i >= N) {return;}
	
	C[i] = A[i] + B[i];
}

void main(){

	int N = 200

	float *A_h = new float[N];
	float *B_h = new float[N];
	float *C_h = new float[N];

	for(int i0; i<N; i++){
		A_h[i] = 1.3f;
		B_h[i] = 2.0f;
	}

	float *A_d, *B_d, *C_d;

	cudaMalloc( (void**) &A_d, N * sizeof(float));
	cudaMalloc( (void**) &B_d, N * sizeof(float));
	cudaMalloc( (void**) &C_d, N * sizeof(float));

	cudaMemcpy(A_d, A_h, N*sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(B_d, B_h, N*sizeof(float), cudaMemcpyHostToDevice);

	int blocks = int(N-0.5)/256 + 1;
	vec_add<<<blocks, 256>>> (A_d, B_d, C_d, N);

	cudaMemcpy(C_h, C_d, N*sizeof(float), cudaMemcpyDeviceToHost)

	cudaFree(A_d);
	cudaFree(B_d);
	cudaFree(C_d);

}
