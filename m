Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795199992;
	b=5CuKR5xxQwmoRXw9kuWU2HEg2k48x3AVqIpifcq1CL1sbLepEQ2MvYRxDS/inipF6vQh
	 WqNtxXRNUaVmpXPm143lh5FGok750t8F/BKkxkhsSjm4I46rL8BGwGOzTHc/P7PsqXbGe
	 j7DTPh2ogQD4wq4LjyOEfgrbWGPcKBjhpvHe9glxgXuGkNkQx3gBsYVRVSLo9ka2H5iO2
	 b82jaBAPUI9mj7pu0fW7Etf3rcrriT1dJIP7N5SDFXkgGbet3MqBQiKmclKvyTAKErJoT
	 d1Z+MTjD4V6GxQm/UJXJ9Ncw8viNNtzg22tF4IJBWpzjiFkj+KtdSwQ6ql8+QowkphQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795199992;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vS3paOgEZLv1A1g8OmyxuKuZIhXIN3I0FA00VP71j9E=;
	b=eNx6LO3mWpZ2uDUdYv3yaSepMLUICgJXmvF//m3wSMysNqdO2hYR9kt57Fvni0bdZ+o/
	 onqDkxhploYUOuKWQRC2Spqn7aOcQlKA9F2oPNxRUOUpAeVbthdhXpFp5WDpS4zdSrBJL
	 0ZCPqDQzrrfRNlVVDFi0rsg6+k/2iHD/Ch2HuJKsHCokkU4SaQQHFcL6Sro4R5oNpHgoX
	 FM1aA1kqM166rc5WvKvYtdpcjcOowzw/4EdfZ3QxXA1qWcHFZ/+3kGx+Sdr87MJKKnxh2
	 y1Mx/NFUtVJ/qCeaCQeIKQWSaHlgY8CTgiYMcj6qh4PDSVKJPKwZd0WTnhHeOe4bWKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=CmbpBmzq;
	arc=none smtp.remote-ip=198.175.65.9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A5860A2621
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 18:39:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2A5860A2621
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=CmbpBmzq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795199983; x=1826735983;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=artrgIEQtld+2V6JfYqBRD0b9Ldu3nOeD2Sv3wtSRlc=;
  b=CmbpBmzqIeLQlaEEoBsgVh8pWVXR4g9s4iCwyFbQIPOUlv1h76Klx/Jj
   kryh4mudo+xXrpFuw0aSCyKQU+8yiqRA0ysQhWrpldm7GTD7sX9B6dMOw
   S74ziEfG+NGWSYM0zElrtHyg34b0sqVRVRyPNmO31NmiMeGb54ELUjZPe
   DgmphCo9ymANc3ASQX9Og+CejDotUaIvQQX8jx3NYwHJG+l4gQ7RTDC0R
   tjBu3O1zL2lCPoIcZqIDUM996UlVDCteFXIgW20i+zMsHQB26qRnMqM/+
   8ieTs1ftfFCGMq0m3a4Cd112aUYHvpJjSz1wCpLVsKYZxSxzwXfCnRAC/
   w==;
X-CSE-ConnectionGUID: N7zpec0/Qba/ExHmrkX64g==
X-CSE-MsgGUID: cJy/1XnoSFOfKOFHxUqQzQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="3931862"
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="3931862"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 10:39:41 -0800
X-CSE-ConnectionGUID: 1AYaa7RqTi6A0NpsPcW6MA==
X-CSE-MsgGUID: vgafOxPTSLq/IEr0tRm6dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="12590722"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 10:39:41 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: kees@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com,
	tony.luck@intel.com,
	ben.horgan@arm.com,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	babu.moger@amd.com,
	fustini@kernel.org,
	jedrzej.wasiukiewicz@intel.com
Cc: fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [RFC PATCH 3/3] NOT_FOR_INCLUSION: selftests/resctrl: Tasks keep using removed RMID after fork() reproducer
Date: Fri, 20 Nov 2026 10:39:32 -0800
Message-ID: <2f95c069a2646af7d5745b14d2c53d0d9d450bc7.1795197419.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1795197419.git.reinette.chatre@intel.com>
References: <cover.1795197419.git.reinette.chatre@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jedrzej Wasiukiewicz <jedrzej.wasiukiewicz@intel.com>

Introduce stray_tasks_repro.sh that demonstrates how a task forked while
its monitor group is being removed may continue to use the removed RMID.

What this script does:
  1. Starts 8 processes inside a new monitor group "m" that fork sleeping
     children as fast as they can.
  2. Removes "m" while they are forking.
  3. Creates new monitor groups until no RMID is free, so the RMID freed in
     step 2 gets a new owner. Nothing is ever moved into these groups.
  4. Reports every task found in them. Each one carries the removed group's
     RMID and is a stray. The expected result is none.

To avoid the freed RMID landing in limbo, the script requires that LLC
occupancy monitoring is disabled (on x86, boot with "rdt=!cmt").

Example of issue encountered:

  monitor groups created: 566, stopped on: No space left on device
  tasks in new monitor groups (expect none): 1
  /sys/fs/resctrl/c/mon_groups/n565/tasks
  RESULT: 1 stray task(s) kept the removed group's RMID

See script header for more detail.

Signed-off-by: Jedrzej Wasiukiewicz <jedrzej.wasiukiewicz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 .../selftests/resctrl/stray_tasks_repro.sh    | 122 ++++++++++++++++++
 1 file changed, 122 insertions(+)
 create mode 100755 tools/testing/selftests/resctrl/stray_tasks_repro.sh

diff --git a/tools/testing/selftests/resctrl/stray_tasks_repro.sh b/tools/testing/selftests/resctrl/stray_tasks_repro.sh
new file mode 100755
index 000000000000..42f65d7d7bb4
--- /dev/null
+++ b/tools/testing/selftests/resctrl/stray_tasks_repro.sh
@@ -0,0 +1,122 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# resctrl: a task forked while its monitor group is being removed keeps the
+# removed group's RMID.
+#
+# rdt_move_group_tasks() moves a removed group's tasks to the parent group
+# under read_lock(&tasklist_lock). That lock only delays a new child from
+# joining the task list. The child copies its parent's closid/rmid earlier,
+# in dup_task_struct(), without the lock. A child whose fork() is in flight
+# when the walk starts therefore joins the list afterwards with the removed
+# group's RMID, and is never moved.
+#
+# What this script does:
+#   1. Starts 8 processes inside a new monitor group "m" that fork sleeping
+#      children as fast as they can.
+#   2. Removes "m" while they are forking.
+#   3. Creates new monitor groups until no RMID is free, so the RMID freed in
+#      step 2 gets a new owner. Nothing is ever moved into these groups.
+#   4. Reports every task found in them. Each one carries the removed group's
+#      RMID and is a stray. The expected result is none.
+#
+# Requirements: bash, root, resctrl mounted with monitoring, and the L3
+# occupancy event (llc_occupancy) off. Memory bandwidth events (mbm_*) are
+# enough.
+#   mount -t resctrl resctrl /sys/fs/resctrl
+# With llc_occupancy a freed RMID waits in "limbo" until the cache lines tagged
+# with it are gone, so it may not be reused and the race cannot be seen. Without
+# that event a freed RMID is reusable at once. To turn the event off, boot with
+# the kernel parameter rdt=!cmt. The script refuses to run when llc_occupancy is
+# listed in info/L3_MON/mon_features.
+#
+# Output (example of a hit):
+#   monitor groups created: 566, stopped on: No space left on device
+#   tasks in new monitor groups (expect none): 1
+#   /sys/fs/resctrl/c/mon_groups/n565/tasks
+#   RESULT: 1 stray task(s) kept the removed group's RMID
+#
+# The race is probabilistic: run it several times. "no stray this run" is not
+# a pass. If the run stops on anything but "No space left on device", the
+# freed RMID was never reused, so strays cannot be seen. The script then
+# reports RESULT: INCONCLUSIVE and the run counts as no data.
+#
+# Side effects: creates and removes the control group "c" and its monitor
+# groups (it refuses to run if "c" exists) and starts thousands of short-lived
+# sleeping processes. Other resctrl groups are not touched, but while the RMID
+# pool is full anyone else creating a monitor group gets ENOSPC.
+
+R=/sys/fs/resctrl
+C=$R/c                      # control group used for the test
+M=$C/mon_groups/m           # monitor group that gets removed
+MF=$R/info/L3_MON/mon_features
+
+[ "$(id -u)" = 0 ] || { echo "run as root"; exit 1; }
+[ -f $MF ] || { echo "resctrl with monitoring is not mounted at $R"; exit 1; }
+if grep -q llc_occupancy $MF; then
+	echo "llc_occupancy is enabled: freed RMIDs can sit in limbo."
+	echo "Boot with the kernel parameter rdt=!cmt."
+	exit 1
+fi
+[ ! -e $C ] || { echo "$C already exists, remove it first"; exit 1; }
+
+FORKERS=()                  # PIDs of the forker processes
+KIDS=""                     # PIDs of their children
+
+# Runs on every exit, including Ctrl-C: stop all test processes and remove the
+# test groups.
+cleanup() {
+	trap - EXIT INT TERM
+	[ -n "$KIDS" ] || [ ${#FORKERS[@]} -eq 0 ] ||
+		KIDS=$(pgrep -P "$(IFS=,; echo "${FORKERS[*]}")")
+	[ ${#FORKERS[@]} -eq 0 ] || kill "${FORKERS[@]}" 2>/dev/null
+	[ -z "$KIDS" ] || kill $KIDS 2>/dev/null
+	sleep 1
+	rmdir $C/mon_groups/* 2>/dev/null
+	rmdir $C 2>/dev/null
+}
+trap cleanup EXIT
+trap 'exit 130' INT TERM
+
+mkdir $C $M || { echo "cannot create $C and $M"; exit 1; }
+
+# 8 forkers. Each joins c, then m, and then forks in a loop: a sleeping child
+# that lives 20 s, plus a very short one that keeps the fork rate high.
+for i in 1 2 3 4 5 6 7 8; do
+	( echo $BASHPID > $C/tasks; echo $BASHPID > $M/tasks
+	  while :; do sleep 20 & sleep 0.0003; done ) &
+	FORKERS+=($!)
+done
+sleep 0.3                   # let them start forking
+
+# The race window is while this walks the task list.
+rmdir $M
+
+# Remember the children for cleanup, then stop the forkers. The children stay.
+KIDS=$(pgrep -P "$(IFS=,; echo "${FORKERS[*]}")")
+kill "${FORKERS[@]}" 2>/dev/null
+sleep 2                     # let forks that are still in flight finish
+
+# Take every free RMID. Stop on the first error, normally ENOSPC (pool full).
+n=0
+while err=$(mkdir $C/mon_groups/n$n 2>&1); do n=$((n+1)); done
+echo "monitor groups created: $n, stopped on: ${err##*: }"
+
+# Nothing was ever put into n*, so any task listed here is a stray.
+strays=$(cat $C/mon_groups/n*/tasks 2>/dev/null | wc -l)
+echo "tasks in new monitor groups (expect none): $strays"
+if [ "$strays" -gt 0 ]; then
+	grep -l . $C/mon_groups/n*/tasks        # which group holds them
+	echo "RESULT: $strays stray task(s) kept the removed group's RMID"
+	exit 0
+fi
+
+case $err in
+*"No space left"*)
+	echo "RESULT: no stray this run, run again"
+	exit 0 ;;
+esac
+
+# Not ENOSPC: the pool was never full, so the freed RMID was not reused and a
+# stray cannot be seen in this run.
+echo "RESULT: INCONCLUSIVE, the freed RMID was never reused (${err##*: })"
-- 
2.56.0

