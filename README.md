# Bare on iOS

Example of embedding Bare in an iOS application using <https://github.com/holepunchto/bare-kit>.


## Build Steps

1. Clone this repo:

    ```
    git clone https://github.com/holepunchto/pear-expo-hello-world.git
    ```

2. run following command to sync git submodules:

    ```sh
    git submodule update --init --recursive
    ```

    > [!NOTE]
    > From now on, you should run `npx bare-dev vendor sync` after updating `bare` git submodule.

3. Configure build with `npx bare-dev configure --debug --platform ios --arch arm64 --simulator`

4. Build the App with `npx bare-dev build --debug`

5. Run the application with `npx bare-dev ios run --attach`

## License

Apache-2.0
