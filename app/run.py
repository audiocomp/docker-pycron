# pylint: disable=W0621,W1514,C0114
from typing import Any, Dict, TYPE_CHECKING
from crontab import CronTab, CronItem
from ruamel.yaml import YAML
if TYPE_CHECKING:
    from _typeshed import FileDescriptorOrPath

DEFAULT_WORK = '/work'
DEFAULT_CONFIG = 'config.yaml'

CONFIG_AT = 'at'
CONFIG_SCHEDULE = 'schedule'
CONFIG_ARGS = 'args'
CONFIG_DAYS = 'days'
CONFIG_HOURS = 'hours'
CONFIG_MINUTES = 'minutes'


def new_job(
        cron: CronTab, filename: str, config: Dict[str, Any]):
    """Create a python job."""
    if CONFIG_ARGS in config:
        print(f"Found following args: {config[CONFIG_ARGS]}")
        for arg in config[CONFIG_ARGS]:
            filename = f"{filename} {arg}"

    return cron.new(command=f"/usr/local/bin/python {filename}")


def schedule_job(cron: CronTab, job: CronItem, config: Dict[str, Any]):
    """Creates scheduling for jobs."""
    try:
        schedule = config[CONFIG_SCHEDULE]
        print(f"{CONFIG_SCHEDULE}: {schedule}")
        if CONFIG_DAYS in schedule:
            job.every(schedule[CONFIG_DAYS]).days()  # type:ignore
        elif CONFIG_HOURS in schedule:
            job.every(schedule[CONFIG_HOURS]).hours()  # type:ignore
        elif CONFIG_MINUTES in schedule:
            job.every(schedule[CONFIG_MINUTES]).minutes()  # type:ignore
        else:
            print(f"Invalid entry {schedule}")

    except KeyError:
        print(f"{CONFIG_SCHEDULE} not found in {DEFAULT_CONFIG}")

    cron.write()

    return


def create_script_configs(cron: CronTab, config_file: "FileDescriptorOrPath"):
    """Create config entries for scripts."""
    yaml_config = load_yaml(config_file)

    for script, config in yaml_config.items():
        filename = f"{DEFAULT_WORK}/{script}.py"
        print(f"Setting up {filename}")

        job = new_job(cron, filename, config)

        schedule_job(cron, job, config)


def load_yaml(fname: "FileDescriptorOrPath"):
    """Load yaml file."""
    yaml = YAML(typ='safe')
    with open(fname) as cfg_file:
        return yaml.load(cfg_file)


if __name__ == '__main__':
    cron: CronTab = CronTab(user='root')
    create_script_configs(cron, f"{DEFAULT_WORK}/{DEFAULT_CONFIG}")
    cron.write('/etc/cron.d/pycron')
