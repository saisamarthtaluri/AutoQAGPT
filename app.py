import pyperclip
import time
import openai
import pyautogui
from pynput import keyboard
import threading
import random

# Store your API key in a secure manner (for example, as an environment variable)
openai.api_key = '<key>'

def ask_gpt(question):
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        temperature = 0.4,
        # top_p = 0.1,
        messages=[
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": "Write the bash script only (Don't include any explanation/comments or any other content and give it in raw text format. Don't include #!/bin/bash and dont embed the code within ```bash ```.) for the following question: " + question},
        ]
    )
    return response['choices'][0]['message']['content']

def type_text(output):
    # Get the screen size
    screen_width, screen_height = pyautogui.size()

    # Click at the center of the screen
    pyautogui.click(screen_width // 2, screen_height // 2)

    time.sleep(5)

    pyautogui.press("enter")

    # Type each character of the output with a random interval
    for char in output:
        if char == "\n":  # Check for newline character
            pyautogui.press("enter")
            pyautogui.press("home")  # Move cursor to the start of the new line
        elif char == "\t":  # Check for tab character
            pyautogui.press("tab")
        else:
            pyautogui.write(char)  # Write single character

        # Sleep for a random interval between 0.1 and 0.5
        time.sleep(random.uniform(0.3, 1))


output = None  # Global variable to store the GPT-3 output
key_buffer = []  # To keep track of the last two keys pressed

# This function will be called whenever a key is pressed
def on_key_press(key):
    global output, key_buffer

    # Append key to buffer and keep its size to 2
    key_buffer.append(key)
    key_buffer = key_buffer[-2:]

    # Check if the last two keys are '#' and '1'
    if [k for k in key_buffer if hasattr(k, 'char')] == [keyboard.KeyCode.from_char('#'), keyboard.KeyCode.from_char('1')] and output:
        type_text(output)

keyboard_listener = keyboard.Listener(on_press=on_key_press)
keyboard_listener.start()

def main():
    global output
    last_clipboard_content = ""

    try:
        while True:
            current_clipboard_content = pyperclip.paste()

            if current_clipboard_content != last_clipboard_content:
                output = ask_gpt(current_clipboard_content)
                print(output)
                last_clipboard_content = current_clipboard_content

            time.sleep(1)  # Check the clipboard every second
    except KeyboardInterrupt:
        print("\nExiting gracefully...")
        keyboard_listener.stop()
        exit(0)

if __name__ == "__main__":
    main()

