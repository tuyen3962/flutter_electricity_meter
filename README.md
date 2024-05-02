## Features

This is the UI with the animation as Electricity meter and you can customize it by yourself.

## Demo

![Gif](/assets/example.gif)

## Getting started

The first thing you need to do is initialize the ElectricityMeterManager with the maximum value.
```
final manager = ElectricityMeterManager(maxValue: 100000);
```

After that you can setup in your widget by this.

```
ElectricityMeter(
    width: MediaQuery.of(context).size.width,
    manager: manager,
    colors: const [
        Color(0xFFfb0505),
        Color(0xFFfb7607),
        Color(0xFFf4ea07),
        Color(0xFF61f205),
        Color(0xFF00f6cb),
    ],
)
```

## Usage

When you want to update the value, you can call this function "startRotate" in the manager with the integer input.

Or you want to change the value from the current value, you can call this function "onChange".
