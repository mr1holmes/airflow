#!/usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
# Script to run mypy on all code. Can be started from any working directory
# shellcheck source=scripts/in_container/_in_container_script_init.sh
. "$( dirname "${BASH_SOURCE[0]}" )/_in_container_script_init.sh"
export PYTHONPATH=${AIRFLOW_SOURCES}

ADDITIONAL_MYPY_OPTIONS=()

export MYPY_FORCE_COLOR=true
export TERM=ansi

if [[ ${SUSPENDED_PROVIDERS_FOLDERS=} != "" ]];
then
    for folder in ${SUSPENDED_PROVIDERS_FOLDERS=}
    do
        ADDITIONAL_MYPY_OPTIONS+=(
            "--exclude" "providers/${folder}/src/airflow/providers/${folder}/*"
            "--exclude" "providers/${folder}/tests/${folder}/*"
        )
    done
fi
set -x
mypy "${ADDITIONAL_MYPY_OPTIONS[@]}" "${@}"
