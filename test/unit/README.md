# Test Procedure

For each module we have a unit test that consists of a `main.tf` and a `test.go`. The `main.tf` contains all the dependencies required to import that module and only that module. The `test.go` then contains the code to `apply`, test and destroy the module.

Finally we can run all this code in a CI pipeline with:

```sh
cd tests/unit
go test -v ./...
```

and we will obtain a global `pass/fail`.

## Conclusion

This set up isolates smaller parts of the infrastructure and if you run them in `parallel` (Go’s testing framework can run in `parallel`) then this shortens the feedback cycle. Of course the tests are only as quick as the `slowest` test, so there is some impetus to speed up deployment times by baking static elements in to images.
