Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9220B2528E3;
	Thu,  3 Apr 2025 15:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693846; cv=none; b=BLCdspo90FioqLIzLuoLe64SF+JN97tf7hBPlZxSreP60PPuQtJ0TGEr05v+cT5yXIPLTGj0RSU1gtcgNFJIxbYz9f/CBFqn1O58uSAm98kiHNpxJWHZl+0bgdXNGvtTnokRAsReQQZt7w2CmUbw8npmywQy5XsvIuj7S8hYcCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693846; c=relaxed/simple;
	bh=2doeibbupG141z1j+KCgNPEVAdQA8fm8ys2xHDGeWKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=in80KDohVzfWRNyDYQmURhH80xYLJn/LSwdhaninXVcYrFd3MMM4X9ycvqIJSntWh8y3yiArRaZeFW4Ajmj+z9LymShoUXXD++Y66vU8Y7HCXqqwV/TyKmFlLfWS2cEzr1a7hS6zAg2Qc7l1zG+1GyN+OUUTX9LqkWmCTMSTZgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jv4yM0NX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jv4yM0NX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8ECC4CEE3;
	Thu,  3 Apr 2025 15:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693846;
	bh=2doeibbupG141z1j+KCgNPEVAdQA8fm8ys2xHDGeWKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jv4yM0NXOZLGsw8fSg8z+k3yxUZEfVrN6/GWw6BS1rmMEA5Q4ZFbhXvu4D9xTXtgP
	 sFxXughWrZBifa9plA6SrE4Laom35Lz5skJP8uQpWcW3lf47NR0dcgBxqvUBB2tLse
	 hqai1gv1Xr1D1zd7/Um2RDHAc2ZjLr3h523ESPII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 6.14 19/21] perf tools: Fix up some comments and code to properly use the event_source bus
Date: Thu,  3 Apr 2025 16:20:23 +0100
Message-ID: <20250403151621.674268435@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151621.130541515@linuxfoundation.org>
References: <20250403151621.130541515@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 0cced76a0276610e86e8b187c09f0e9ef85b9299 upstream.

In sysfs, the perf events are all located in
/sys/bus/event_source/devices/ but some places ended up hard-coding the
location to be at the root of /sys/devices/ which could be very risky as
you do not exactly know what type of device you are accessing in sysfs
at that location.

So fix this all up by properly pointing everything at the bus device
list instead of the root of the sysfs devices/ tree.

Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/2025021955-implant-excavator-179d@gregkh
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/Documentation/intel-hybrid.txt |   12 ++++++------
 tools/perf/Documentation/perf-list.txt    |    2 +-
 tools/perf/arch/x86/util/iostat.c         |    2 +-
 tools/perf/builtin-stat.c                 |    2 +-
 tools/perf/util/mem-events.c              |    2 +-
 tools/perf/util/pmu.c                     |    4 ++--
 6 files changed, 12 insertions(+), 12 deletions(-)

--- a/tools/perf/Documentation/intel-hybrid.txt
+++ b/tools/perf/Documentation/intel-hybrid.txt
@@ -8,15 +8,15 @@ Part of events are available on core cpu
 on atom cpu and even part of events are available on both.
 
 Kernel exports two new cpu pmus via sysfs:
-/sys/devices/cpu_core
-/sys/devices/cpu_atom
+/sys/bus/event_source/devices/cpu_core
+/sys/bus/event_source/devices/cpu_atom
 
 The 'cpus' files are created under the directories. For example,
 
-cat /sys/devices/cpu_core/cpus
+cat /sys/bus/event_source/devices/cpu_core/cpus
 0-15
 
-cat /sys/devices/cpu_atom/cpus
+cat /sys/bus/event_source/devices/cpu_atom/cpus
 16-23
 
 It indicates cpu0-cpu15 are core cpus and cpu16-cpu23 are atom cpus.
@@ -60,8 +60,8 @@ can't carry pmu information. So now this
 type. The PMU type ID is stored at attr.config[63:32].
 
 PMU type ID is retrieved from sysfs.
-/sys/devices/cpu_atom/type
-/sys/devices/cpu_core/type
+/sys/bus/event_source/devices/cpu_atom/type
+/sys/bus/event_source/devices/cpu_core/type
 
 The new attr.config layout for PERF_TYPE_HARDWARE:
 
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -188,7 +188,7 @@ in the CPU vendor specific documentation
 
 The available PMUs and their raw parameters can be listed with
 
-  ls /sys/devices/*/format
+  ls /sys/bus/event_source/devices/*/format
 
 For example the raw event "LSD.UOPS" core pmu event above could
 be specified as
--- a/tools/perf/arch/x86/util/iostat.c
+++ b/tools/perf/arch/x86/util/iostat.c
@@ -32,7 +32,7 @@
 #define MAX_PATH 1024
 #endif
 
-#define UNCORE_IIO_PMU_PATH	"devices/uncore_iio_%d"
+#define UNCORE_IIO_PMU_PATH	"bus/event_source/devices/uncore_iio_%d"
 #define SYSFS_UNCORE_PMU_PATH	"%s/"UNCORE_IIO_PMU_PATH
 #define PLATFORM_MAPPING_PATH	UNCORE_IIO_PMU_PATH"/die%d"
 
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -97,7 +97,7 @@
 #include <internal/threadmap.h>
 
 #define DEFAULT_SEPARATOR	" "
-#define FREEZE_ON_SMI_PATH	"devices/cpu/freeze_on_smi"
+#define FREEZE_ON_SMI_PATH	"bus/event_source/devices/cpu/freeze_on_smi"
 
 static void print_counters(struct timespec *ts, int argc, const char **argv);
 
--- a/tools/perf/util/mem-events.c
+++ b/tools/perf/util/mem-events.c
@@ -189,7 +189,7 @@ static bool perf_pmu__mem_events_support
 	if (!e->event_name)
 		return true;
 
-	scnprintf(path, PATH_MAX, "%s/devices/%s/events/%s", mnt, pmu->name, e->event_name);
+	scnprintf(path, PATH_MAX, "%s/bus/event_source/devices/%s/events/%s", mnt, pmu->name, e->event_name);
 
 	return !stat(path, &st);
 }
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -36,12 +36,12 @@
 #define UNIT_MAX_LEN	31 /* max length for event unit name */
 
 enum event_source {
-	/* An event loaded from /sys/devices/<pmu>/events. */
+	/* An event loaded from /sys/bus/event_source/devices/<pmu>/events. */
 	EVENT_SRC_SYSFS,
 	/* An event loaded from a CPUID matched json file. */
 	EVENT_SRC_CPU_JSON,
 	/*
-	 * An event loaded from a /sys/devices/<pmu>/identifier matched json
+	 * An event loaded from a /sys/bus/event_source/devices/<pmu>/identifier matched json
 	 * file.
 	 */
 	EVENT_SRC_SYS_JSON,


