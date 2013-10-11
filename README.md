# Airbrake notification step

## Options

* ``api-key``  (required) Your airbrake API KYE
* ``host``  Your airbrake HOST. default airbrake.io
* ``secure``  default false.
* ``environment`` default production.
* ``message`` message.

## Example

```
deploy:
  after-steps:
    - 1syo/airbrake-notify@0.0.5:
        api-key: YOUR_AIRBRAKE_API_KEY
```

## License

The MIT License (MIT)
