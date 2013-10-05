# Errbit notification step

## Options

* ``host``  (required) YOUR_ERRBIT_HOST
* ``api-key``  (required) YOUR_ERRBIT_API_KEY
* ``ssl``  default false.
* ``environment`` default production.

## Example

```
deploy:
  after-steps:
    - 1syo/errbit-notify@0.0.1:
        host: YOUR_ERRBIT_HOST
        api-key: YOUR_ERRBIT_HOST
```

## License

The MIT License (MIT)
