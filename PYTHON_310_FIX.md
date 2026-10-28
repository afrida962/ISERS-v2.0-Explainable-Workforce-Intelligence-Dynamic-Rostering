# Python 3.10 startup fix

The previous v1.1 package used `from datetime import UTC`, which is only available in Python 3.11+.

This v1.2 package uses `timezone.utc` instead, so it supports Python 3.10+.

If you saw this error:

```text
ImportError: cannot import name 'UTC' from 'datetime'
```

use this v1.2 package.

## Windows

1. Extract the ZIP.
2. Double-click `start_windows.bat`.
3. Wait until the server window shows `Uvicorn running on http://127.0.0.1:8000`.
4. The browser should open automatically.

If port 8000 is already in use, close the older server window first, then run `start_windows.bat` again.
