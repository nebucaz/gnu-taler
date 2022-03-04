# Fuzzing Taler REST APIs
## Usage
### Using docker-compose
```
docker-compose exec fuzzer sh -c "openapi-fuzzer -s api/test.yaml -u http://exchange:5890/"
```
or
```
docker-compose exec fuzzer openapi-fuzzer -s api/test.yaml -u http://exchange:5890/
```
### Exclude Responses with certain status-codes
To exclude status codes not defined in the specification but thrown add them with the -i flag
 
```
docker-compose exec fuzzer openapi-fuzzer -s api/test-3.yaml -u http://exchange:5890/ -i 400 -i 404 -i 414
```

### Standalone
Run the fuzzer at `http://exchange:5890/` based on the OpenAPI specification `api/test.yaml` from within the fuzzer directory:
```
docker run -it  --network gnu-taler-docker_inet taler/fuzzer sh -c "openapi-fuzzer -s api/test.yaml -u http://exchange:5890/"
```


