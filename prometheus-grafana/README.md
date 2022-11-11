# Anatomia da métrica

- Métricas Simples
  - Scalar
  - String
- Métricas mais dificeis
  - Instante Vector
  - Range Vector
- Tipos de Métricas
  - Count
  - Gauge
  - Histogram
  - Summary

## Instante Vector - Vetor de tempo
Quando eu escolho uma métrica e faço a busca ele me retorna um Vetor, e cada linha que retornou é um indice desse vetor. No exemplo abaixo temos 5 indices. 
```bash
Indice 1
Indice 2
Indice 3
Indice 4
Indice 5
```

Cada um desses elementos é uma série Temporal, então temos 5 séries temporais que estão armazenadas na métrica ` prometheus_http_request_duration_seconds_bucket` e quando eu consulto uma métrica, ele me retorna um vetor de série temporal.


![image](https://user-images.githubusercontent.com/52141340/199484604-7b5a62ec-f1b2-417a-b742-9e7a76c7d4a4.png)

- Dashboard
![image](https://user-images.githubusercontent.com/52141340/199484734-8c909689-188d-41d5-ae84-83d42889fcd2.png)


## Range Vector
  - É um Range de tempo, dentro de uma Série Temporal.
  - É um valor especifico a cada scraping time, lembrando que podemos configurar o periodo do scraping no arquivo `prometheus.yml`.

![image](https://user-images.githubusercontent.com/52141340/199484410-cb455017-6d9d-4893-8a0b-9acf50a48060.png)

- O número na lateral é o timestamp que o prometheus usa para chumbar no TSDB.
```bash
3 @1667390815.115
3 @1667390830.112
3 @1667390845.115
3 @1667390860.112
```

- Vamos executar ele no bash do linux para ver o resultado.

![image](https://user-images.githubusercontent.com/52141340/199486561-33bcdc16-8bec-4cb1-8203-ab6834786256.png)

- Aqui criei um for para executar a lista. Primeiro salvei os valores em uma variavel, e então executei o for para verificar o resultado do array. Podemos verificar que o scraping foi feito a cada 15 segundos.

```bash
array=( @1667390815.115 @1667390830.112 @1667390845.115 @1667390860.112 )
for i in "${array[@]}" ; do date -d $i ; done
qua 02 nov 2022 09:06:55 -03
qua 02 nov 2022 09:07:10 -03
qua 02 nov 2022 09:07:25 -03
qua 02 nov 2022 09:07:40 -03

```
![image](https://user-images.githubusercontent.com/52141340/199487638-81cb7ada-57c5-4da6-a165-36168cc378c4.png)


Dashboard
![image](https://user-images.githubusercontent.com/52141340/199484890-2389b85c-8b6f-4580-936f-06ef8768e9e1.png)

- Também podemos olhar um intervalo especifico dentro de uma série temporal, através de uma `SUBQUERY`
Vamos olhar os últimos 5 minutos e ver apenas o intervalo de 1 minuto.
```bash
prometheus_http_requests_total[5m:1m]
```
![image](https://user-images.githubusercontent.com/52141340/199536710-40398b13-8e99-4a30-b083-c65a8d98ac9e.png)

- Lembrando: Se você tentar ver o resultado em um gráfico, vai receber um ERRO com a seguinte mensagem.
```bash
Erro ao executar a consulta: tipo de expressão inválido "range vector" para consulta de intervalo, deve ser Scalar ou instant Vector.
```
Em Resumo, não podemos formar um gráfico, quando minha saída possui mais de um valor, e então devemos usar Scalar ou Instant Vector.

## Tipos de Métricas
- As bibliotecas do cliente Prometheus oferecem quatro tipos de métricas principais.
- Fáceis:
  - Counter(Contador)
  - Gauge(Medidor)
- Complexas:
  - Histogram(Histograma)
  - Summary(Resumo)
- Histogramas e resumos são tipos de métrica mais complexas. Um único histogram ou Summary cria uma infinidade de séries temporais, tornando mais difícil utilizar esses tipos de métrica corretamente.

### Counter
 Um contador é uma métrica cumulativa que representa um único contador monotonicamente crescente cujo valor só pode aumentar ou ser zerado na reinicialização. Por exemplo, você pode usar um contador para representar o número de solicitações atendidas, tarefas concluídas ou erros.

OBS: Não use um contador para expor um valor que pode diminuir. Por exemplo, não use um contador para o número de processos em execução no momento(CPU,MEMÓRIA); em vez disso, use um medidor.

- COUNT - Contador de solicitações HTTP
```bash
prometheus_http_requests_total{code="200",handler="/metrics"}
```
### GAUGE:
-  Um medidor é uma métrica que representa um único valor numérico que pode subir e descer arbitrariamente. Os medidores são normalmente usados para valores medidos como temperaturas ou uso de memória atual, mas também `CONTAGENS` que podem aumentar e diminuir, como o número de solicitações simultâneas.
- Métrica: O número de bytes que são usados atualmente para armazenamento local por todos os blocos.
```bash
prometheus_tsdb_storage_blocks_bytes
```

### HISTOGRAM:
-  Um histograma mostra observações (geralmente coisas como durações de solicitação ou tamanhos de resposta) e as conta em buckets configuráveis. Ele também fornece uma soma de todos os valores observados.
Um histograma com um nome de métrica base de `<basename>` expõe várias séries temporais durante uma raspagem:
  - contadores cumulativos para os baldes de observação, expostos como `<basename>_bucket{le="<upper inclusive bound>"}`
  - a `soma total` de todos os valores observados, expostos como `<basename>_sum`
  - a `contagem` de eventos que foram observados, expostos como `<basename>_count` (idêntico ao `<basename>_bucket{le="+Inf"}` acima)
- Use a função `histogram_quantile()` para calcular `quantis de histogramas` ou mesmo `agregações de histogramas`. Um histograma também é adequado para calcular uma pontuação `Apdex` . Ao operar em `Buckets`, lembre-se de que o histograma é cumulativo.

Histogram - Latências para solicitações HTTP.
```bash
prometheus_http_request_duration_seconds_bucket{handler="/api/v1/query_range",le="0.1"}
```
### SUMMARY:
- Semelhante a um histograma , um resumo mostra observações (geralmente coisas como durações de solicitação e tamanhos de resposta). Embora também forneça uma contagem total de observações e uma soma de todos os valores observados, ele calcula quantis configuráveis em uma janela de tempo deslizante.

Um resumo com um nome de métrica base de `<basename>` expõe várias séries temporais durante uma raspagem:

  - streaming de `φ-quantis (0 ≤ φ ≤ 1)` de eventos observados, expostos como `<basename>{quantile="<φ>"}`
  - a soma total de todos os valores observados, expostos como `<basename>_sum`
  - a contagem de eventos que foram observados, expostos como `<basename>_count`

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







