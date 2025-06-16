# 📘 Quiz-Taker

**Quiz-Taker** is a simple Lua program for entering quiz scores via the command line. It’s ideal for teachers who prefer lightweight, text-based tools. The output is saved in a `.tsv` (Tab-Separated Values) format, which can easily be imported into spreadsheet applications like Excel, Google Sheets, or LibreOffice.

---

## 🚀 Features

- 🆓 Free and open-source  
- 🖥️ Text-based yet user-friendly  
- 💾 Saves scores in a clean TSV (Tab-Separated Values) file


## 🛠️ Installation

First, clone the repository:

```bash
git clone https://github.com/muthym/Quiz-Taker.git
```

Make sure Lua is installed on your system. To check:
```
lua -v
```


## 📦 Usage

Navigate to the project folder and run:
```
lua qt.lua <filename> <max_score>
```

## 🔍 Example
```
lua qt.lua students.tsv 10
```
This will:

    Prompt you to enter student names and scores

    Save the results in students.tsv

    Assume the maximum possible score for each quiz is 10


## 📝 Notes

    You can open .tsv files directly in Excel, Google Sheets, etc.

    File will be created if it doesn’t already exist.

    Input is interactive and straightforward.


## 🤝 Contributing

Got suggestions or improvements? Contributions are welcome! Please:

    Fork the repo

    Create a new branch

    Submit a pull request

Or just open an issue to start a discussion.


## 📄 License

This project is licensed under the MIT License.
See the LICENSE file for full details.

## 📫 Contact

Made by Muthym
Feel free to reach out via GitHub for questions or feedback.
