### Connect 4 AI in Prolog

#### Overview

This project implements **Connect 4** in Prolog with a robust game engine
supporting:

-   **Player vs Player** and **Player vs AI**.
-   **AI vs AI simulations** with three strategies:
    -   **Random moves**.
    -   **Minimax algorithm**.
    -   **Alpha-Beta Pruning**.

A comprehensive **test suite** validates game mechanics, and a **statistics
module** compares AI performance.

---

### Features

1. **Interactive Gameplay**

    - Fully playable in a command-line interface.
    - Players can choose between `X` or `O`.

2. **Artificial Intelligence**

    - Three AI strategies:
        - **Random**: Plays random moves.
        - **Minimax**: Simulates future moves for optimal play.
        - **Alpha-Beta Pruning**: Optimized Minimax for better performance.
    - AI prioritizes **winning moves** and **blocks opponent threats**.

3. **Game Mechanics**

    - Validates moves within board limits and column capacity.
    - Detects endgame scenarios:
        - **Win conditions** (horizontal, vertical, diagonal).
        - **Draw** when the board is full.

4. **AI Performance Statistics**

    - Run multiple AI vs AI matches to collect data:
        - Win/loss count.
        - Draw occurrences.
        - Average computation time per AI.
        - Average number of moves per game.

5. **Automated Testing**
    - Ensures correctness of:
        - **Board updates and visualization**.
        - **Move legality and win conditions**.
        - **AI behavior** (detecting and playing winning moves).

---

### File Structure

-   **`connect4.pl`**: Core game logic, board management, and AI algorithms.
-   **`test.pl`**: Unit tests for game mechanics and AI logic.
-   **`stats.pl`**: Simulations to compare AI performance.

---

### How to Use

#### Start a Game

1. Load the game in Prolog:
    ```prolog
    ?- [connect4].
    ```
2. Start the game:
    ```prolog
    ?- run.
    ```
3. Follow on-screen instructions:
    - Select **0, 1, or 2 human players**.
    - If AI is used, choose its strategy (**Random, Minimax, Alpha-Beta**).
    - Play by entering column numbers.

#### Run Tests

1. Load the test suite:
    ```prolog
    ?- [test].
    ```
2. Execute all tests:
    ```prolog
    ?- test_all.
    ```
3. Run specific AI tests:
    ```prolog
    ?- test_ia_win_next_move.  % AI should play a winning move.
    ?- test_ia_block_opponent. % AI should block the opponent.
    ```

#### Compare AI Performance

1. Load the statistics module:
    ```prolog
    ?- [stats].
    ```
2. Run AI simulations:
    ```prolog
    ?- run_stats.
    ```
3. Select two AI strategies to compare:
    - **random**: Plays randomly.
    - **minimax**: Uses Minimax strategy.
    - **alphabeta**: Uses Alpha-Beta Pruning.

Example output:

```
AI Comparison over 20 games:
AI1         AI2         Wins AI1  Wins AI2  Draws  Avg Time (ms)  Avg Moves
-----------------------------------------------------------------------------
Random      Minimax      2          18        0       50ms           40
Minimax     Alpha-Beta   9          11        0       120ms          38
Alpha-Beta  Random      20          0         0       30ms           36
```

---

### AI Behavior

#### Minimax and Alpha-Beta Strategies

-   AI evaluates board states based on:
    -   **Immediate wins** → +1000 points.
    -   **Imminent losses** → -1000 points.
    -   **Partial alignments** (e.g., three connected pieces with an open
        space).
-   **Minimax** explores all possible moves.
-   **Alpha-Beta Pruning** optimizes Minimax by reducing unnecessary
    calculations.

#### AI Prioritization

1. **Play a winning move if available**.
2. **Block the opponent's winning move**.
3. **Build strategic alignments for future turns**.

---

### Future Improvements

1. **Graphical Interface**

    - Develop a GUI for an enhanced experience.

2. **AI Enhancements**

    - Implement **variable search depth** in Minimax.
    - Experiment with **machine learning** for adaptive strategies.

3. **Testing Enhancements**

    - Add **complex scenarios** (e.g., detecting double threats).

4. **Performance Optimization**

    - Improve evaluation function for **faster AI decisions**.

5. **Customization Options**
    - Allow players to modify:
        - **Board size** (e.g., 8x8 grid).
        - **Number of pieces required to win**.
