library(rethinking)
# simulate career choices amoing 500 individuals
N <- 500
income <- c(1, 2, 5)
score <- 0.5 * income

p <- softmax(score)

career <- rep(NA, N)
set.seed(34302)

for (i in 1:N) career[i] <- sample( 1:3, size = 1, prob = p)



code_m11.13 <- "
data{
    int N; // number of individuals
    int K; // number of possible careers
    int career[N];  // outcome
    vector[K] career_income; 
}

parameters{
    vector[K-1] a; // intercepts
    real<lower = 0> b ; // association of income with choice
}

model{
    vector[K] p; 
    vector[K] s;
    a ~ normal( 0 , 1 ); 
    b ~ normal( 0 , 0.5 ); 
    s[1] = a[1] + b*career_income[1];
    s[3] = a[2] + b*career_income[2]; 
    s[2] = 0; 
    p = softmax( s ); 
    career ~ categorical( p );
}
"

data_list <- list(N = N, 
                  K = 3, 
                  career = career, 
                  career_income = income)

m11.13 <- stan( model_code = code_m11.13, 
                data = data_list, 
                chains = 4)

precis(m11.13, depth = 2)
