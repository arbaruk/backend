#!/usr/bin/env python
import os
import sys

if __name__ == "__main__":
    # Ajusta la variable de entorno con las settings
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "project.settings")
    try:
        from django.core.management import execute_from_command_line
    except Exception as exc:
        raise exc
    execute_from_command_line(sys.argv)
