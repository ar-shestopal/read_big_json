# Setup

Clone the repo.
Then run:

```
bundle install
```

# Notes

I wrote some comments in the code as many simplifictions were made.
I used `yajl/ffi` gem to parse json file as steram which allow us to parse it without loading the whole file into memory.

After parsing objects and making modifications JsonFileWriter is called, which ises threads to efficiantly write data into files.
I made few simplifications there as well, in production system it is better to use ThreadPool and have JsonFileWriter as separate process with Message Brocker for communication between JsonFileReader and JsonFileWriter.

Do to lack of time I can not guarante test coverage as well, but main functionality is tested.

# How ot run

Go to `/bin`
Run
```
chmod +x json_file_parser
```

run
```
./json_file_parser -- path_to_your_file
```

Resulting files are generated to `/out` folder

