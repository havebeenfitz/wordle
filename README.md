# Wordle challenge

<img width="300" alt="wordle-scores" src="https://github.com/havebeenfitz/wordle/assets/31866271/5a94d086-da40-4bfd-9cec-02ffed98f28d">

## Design

In this challenge I wanted to meet all the requirements in the provided timeframe (3-4h). I also wanted to maintain the codestyle and conventions I encountered and keep changes to a minimum. 


- Implemented `TryResult` mechanism with standard data structures and, while not needed on this small dataset, I tried to maintain a reasonable algorithmic complexity. Added some tests for this method.

- Created a `ViewModel` to convert our core `Scores` to the iOS specific presentation models. Conversion happened in the `ViewController` `dataSource`. Handled the selection logic with `UICellConfigurationState` update. Double-checked the solution for cell reuse issues on a larger dataset, and it was fine.

- Replaced networking client with `live` implementation while testing but left it out of the scope for now.

## What would I improve:

- Add UItests
- Improve animations on selection
- Maybe replace the `CollectionView` to a grid style or make word rows bigger, a lot of space left out in the current implementation

