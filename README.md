## Simples de Enterder 
Scalar - Float Simples
String 

## Mais dificeis
Instante Vector - Instântaneo 
Range Vector - Série Temporal

Histogram
Quando eu faço a busca ele me retorna um Vetor, e cada linha seria um indice desse vetor.
No exemplo abaixo temos 5 indices, indice 0, 1, 2, 3, 4 e 5.
Cada um desses elementos é uma série Temporal, então temos 5 séries temporais que estão armazenadas na métrica ` prometheus_http_request_duration_seconds_bucket` e quando eu consulto uma métrica, ele me retorna um vetor de série temporal.

- Instante Vector - Vetor de tempo
```bash
prometheus_http_request_duration_seconds_bucket{handler="/", instance="prometheus-forum-api:9090", job="prometheus-forum-api", le="+Inf"} 2
prometheus_http_request_duration_seconds_bucket{handler="/api/v1/query", instance="prometheus-forum-api:9090", job="prometheus-forum-api", le="20"} 52
prometheus_http_request_duration_seconds_bucket{handler="/api/v1/query_range", instance="prometheus-forum-api:9090", job="prometheus-forum-api", le="0.4"} 35
prometheus_http_request_duration_seconds_bucket{handler="/api/v1/series", instance="prometheus-forum-api:9090", job="prometheus-forum-api", le="+Inf"} 9
prometheus_http_request_duration_seconds_bucket{handler="/", instance="prometheus-forum-api:9090", job="prometheus-forum-api", le="1"} 2
```

Range Vector
```bash
prometheus_http_request_duration_seconds_bucket{handler="/", instance="prometheus-forum-api:9090", job="prometheus-forum-api", le="+Inf"} 2 @1667390080.112 2 @1667390095.112 2 @1667390110.112 2 @1667390125.112
```


# Anatomia da métrica
## Selecionando Séries

## Metric name (nome da métrica)
```bash
node_cpu_seconds_total
```
Ele vai identificar qual a série temporal que você quer buscar e entregar o resultado




## Selecione um intervalo de amostras de 5 minutos para séries com um determinado nome de métrica:
```bash
node_cpu_seconds_total[5m]
```
## Somente séries com valores de rótulo fornecidos:
```bash
node_cpu_seconds_total{cpu="0",mode="idle"}
```
## Combinadores de rótulos complexos 
```bash
- =: igualdade, 
- !=: não igualdade,
- =~: correspondência de regex
- !~ correspondência de regex negativa

node_cpu_seconds_total{cpu!="0",mode=~"user|system"}
```
# Selecione os dados de um dia atrás e mude para a hora atual:
```bash
process_resident_memory_bytes offset 1d
```
___

# Taxas de aumento para contadores
## Taxa de aumento por segundo, média nos últimos 5 minutos:
```bash
rate(apiserver_request_duration_seconds_count[5m])
```
## Taxa de aumento por segundo, calculada sobre as duas últimas amostras em uma janela de tempo de 1 minuto:
```bash
irate(apiserver_request_duration_seconds_count[1m])
```
## Aumento absoluto na última hora:
```bash
increase(apiserver_request_duration_seconds_count[1h])
```
___
# Agregando em várias séries
## Soma sobre todas as séries:
```bash
sum(node_filesystem_size_bytes)
```
## Preserve as dimensões da instância e do rótulo do job:
```bash
sum by(job, instance) (node_filesystem_size_bytes)
```
## Agregue as dimensões da instância e do rótulo do job:
```bash
sum without(instance, job) (node_filesystem_size_bytes)
```
[Operadores Disponiveis](https://prometheus.io/docs/prometheus/latest/querying/operators/#aggregation-operators)
```bash
sum(), min(), max(), avg(), stddev(), stdvar(), count(), count_values(), group(), bottomk(), topk(), quantile()
```
___
# Matemática entre séries
## Adicione todas as séries igualmente rotuladas de ambos os lados:
```bash
node_memory_MemFree_bytes + node_memory_Cached_bytes
```
## Adicione séries, correspondendo apenas aos rótulos instance e job
```bash
node_memory_MemFree_bytes + on(instance, job) node_memory_Cached_bytes
```
## Adicione séries, ignorando os rótulos para correspondência: instance e job
```bash
node_memory_MemFree_bytes + ignoring(instance, job) node_memory_Cached_bytes
```
## Include the version label from "one" (right) side in the result:
```bash
node_filesystem_avail_bytes * on(instance, job) group_left(version) node_exporter_build_info
```
___
# Filtrando séries por valor
## Mantenha apenas séries com um valor de amostra maior que um determinado número:
```bash
node_filesystem_avail_bytes > 10*1024*1024
```
## Mantenha apenas as séries do lado esquerdo cujos valores de amostra sejam maiores que suas correspondências do lado direito:
```bash
go_goroutines > go_threads
```
## Em vez de filtrar, retorne 0 ou 1 para cada série comparada:
```bash
go_goroutines > bool go_threads
```
## Corresponder apenas em rótulos específicos:
```bash
go_goroutines > bool on(job, instance) go_threads
```
[Operadores de Comparação](https://prometheus.io/docs/prometheus/latest/querying/operators/#comparison-binary-operators)
___
# Definir operações
## Inclua quaisquer conjuntos de rótulos que estejam no lado esquerdo ou direito:
```bash
up{job="prometheus-kube-prometheus-prometheus"} or up{job="node-exporter"}
```
___
# Quantis de histogramas
## Latência de solicitação de 90º percentil nos últimos 5 minutos, para cada dimensão de rótulo:
```bash
histogram_quantile(0.9, rate(apiserver_request_duration_seconds_bucket[5m]))
```
## ...apenas para as dimensões path e method
```bash
histogram_quantile(
  0.9,
  sum by(le, path, method) (
    rate(apiserver_request_duration_seconds_bucket[5m])
  )
)
```
___
# Mudanças nos medidores
## Preveja o valor em 1 hora, com base nas últimas 4 horas:
```bash
predict_linear(demo_disk_usage_bytes[4h], 3600)
```
# Agregando ao longo do tempo
## Média dentro de cada série durante um período de 5 minutos:
```bash
avg_over_time(go_goroutines[5m])
```
## Obtenha o máximo para cada série em um período de um dia:
```bash
max_over_time(process_resident_memory_bytes[1d])
```
## Conte o número de amostras para cada série durante um período de 5 minutos:
```bash
count_over_time(process_resident_memory_bytes[5m])
```

[funções de agregação](https://prometheus.io/docs/prometheus/latest/querying/functions/#aggregation_over_time)

# Subconsultas
## Calcule a taxa média de 5 minutos em um período de 1 hora, na resolução de subconsulta padrão (= intervalo de avaliação de regra global):
```bash
rate(demo_api_request_duration_seconds_count[5m])[1h:]
```
## Calcule a taxa média de 5 minutos em um período de 1 hora, em uma resolução de subconsulta de 15 segundos:
```bash
rate(demo_api_request_duration_seconds_count[5m])[1h:15s]
```
## Usando o resultado da subconsulta para obter a taxa máxima em um período de 1 hora:
```bash
max_over_time(
  rate(
    demo_api_request_duration_seconds_count[5m]
  )[1h:]
)
```







