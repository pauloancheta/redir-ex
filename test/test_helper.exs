ExUnit.start()

# exclude running tests tagged with disabled
ExUnit.configure exclude: [disabled: true]
