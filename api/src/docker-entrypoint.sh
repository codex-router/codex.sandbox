#!/bin/bash

CGROUP_FS="/sys/fs/cgroup"
if [ ! -e "$CGROUP_FS" ]; then
  echo "Cannot find $CGROUP_FS. Please make sure your system is using cgroup v2"
  exit 1
fi

if [ -e "$CGROUP_FS/unified" ]; then
  echo "Combined cgroup v1+v2 mode is not supported. Please make sure your system is using pure cgroup v2"
  exit 1
fi

if [ ! -e "$CGROUP_FS/cgroup.subtree_control" ]; then
  echo "Cgroup v2 not found. Please make sure cgroup v2 is enabled on your system"
  exit 1
fi

SEED_PACKAGES_DIR="/opt/piston-seed/packages"
TARGET_PACKAGES_DIR="/piston/packages"

has_runtime() {
  local runtime="$1"
  find "$TARGET_PACKAGES_DIR" -mindepth 1 -maxdepth 1 -type d -name "${runtime}-*" -print -quit 2>/dev/null | grep -q .
}

if [ -d "$SEED_PACKAGES_DIR" ]; then
  mkdir -p "$TARGET_PACKAGES_DIR"
  if [ -z "$(find "$TARGET_PACKAGES_DIR" -mindepth 2 -maxdepth 3 -name .ppman-installed -print -quit 2>/dev/null)" ]; then
    echo "Seeding preinstalled runtimes into ${TARGET_PACKAGES_DIR}"
    cp -a "$SEED_PACKAGES_DIR"/. "$TARGET_PACKAGES_DIR"/
  fi

  if ! has_runtime bash; then
    if find "$SEED_PACKAGES_DIR" -mindepth 1 -maxdepth 1 -type d -name "bash-*" -print -quit 2>/dev/null | grep -q .; then
      echo "Seeding missing bash runtime into ${TARGET_PACKAGES_DIR}"
      while IFS= read -r pkgdir; do
        cp -a "$pkgdir" "$TARGET_PACKAGES_DIR"/
      done < <(find "$SEED_PACKAGES_DIR" -mindepth 1 -maxdepth 1 -type d -name "bash-*" | sort)
    else
      echo "Runtime check warning: no bash runtime found in seed directory ${SEED_PACKAGES_DIR}"
    fi
  fi
fi

if has_runtime bash; then
  echo "Runtime check: bash is available in ${TARGET_PACKAGES_DIR}"
else
  echo "Runtime check warning: bash is NOT found in ${TARGET_PACKAGES_DIR}"
fi

cd /sys/fs/cgroup && \
mkdir isolate/ && \
echo 1 > isolate/cgroup.procs && \
echo '+cpuset +cpu +io +memory +pids' > cgroup.subtree_control && \
cd isolate && \
mkdir init && \
echo 1 > init/cgroup.procs && \
echo '+cpuset +memory' > cgroup.subtree_control && \
echo "Initialized cgroup" && \
chown -R piston:piston /piston && \
exec su -- piston -c 'ulimit -n 65536 && node /piston_api/src'
