# Copyright 2024 rysndavjd
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

ACCT_USER_ID=998
ACCT_USER_GROUPS=( slock )

acct-user_add_deps
