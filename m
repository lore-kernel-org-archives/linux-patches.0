Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030304;
	b=dHABQ6Ui8MyfqZtcYBXRJU6dxhElARs0AsvNPhrQ/pJHrw0PqGiDe3lfC5ne1xCpPz52
	 TtTlGPwMoQLcJdy8dqMCmt6irgtHqd6HgyMR/xMhRZGp7jnDx2Qlu91BIKnjjNY5Z4UuC
	 k8iIKEoHTaCvA527zYzbCQKfS+eDhD0/jESGjXMoN2ab7AFdgb3nSD5N8992lyh4LHqFe
	 ODw2TjAdxzlg13IVf65H5wKMzM1oXWQMXiUwW2ZTunhDxnXr7Ac8Da9grpIV9JkvLWxLQ
	 5JIRYgGDM+eWWNreGYRdkdgA8tv0itTsnWBFWzcSZzTn5KqAdRxRAdrOw593buQDaFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7FcLBxlpv6o+6xgt1VGOCbIB7ydOXHSgRl7IRpahBIg=;
	b=Mk+lWxkCt0/bjUl9aQNoQhF96qtz6mFD3VqC+tyS31ra79yOex2jafegvQIeDnKhdYI6
	 op89mMJF5/DDmfkPFwexL3qKkEhZmNSiWnGp/AOfMa/OMgz0ltFGLnIV8xLFp2+5Pgo+6
	 NmBEWTNO5Qd2+XztSMkcsnZQ8zdORZ5ruKJlotROuXJyuFMOU4g0ceaOptC4HJ59DgrFn
	 1yumiCNeT5LNwxLhFyVEsw7VYvSpLdkhf0m9dET/COvNj9Mgpwqw4FV9njv6T0R034NjK
	 ljw57SLhoq8q11iTmrSC7rG8La3brYIIYzArOmWAu3OI9BGGnOoZwevrz7H46VQ4i+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DF4oi4DZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09F9606A7CA;
	Wed, 18 Nov 2026 19:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DF4oi4DZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985461F000C4;
	Wed, 18 Nov 2026 19:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030304;
	bh=7FcLBxlpv6o+6xgt1VGOCbIB7ydOXHSgRl7IRpahBIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DF4oi4DZOyVTDp47ScMR4uCYPNGBF6n7o2PEw7drSZwA8oSZ7oKUwhdndY8A3euQR
	 gEAAe2GoQvHnxNgVn1Z06ttA+zhbMYm0NbxPHB9EtYTkhe5i96D9NPIDO3i8Kih9F1
	 fZXkfQ95mGavJ6I13DRtVrfqBPyuoEBZDnYM6B1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Anne Macedo <retpolanne@posteo.net>,
	Dmitriy Vyukov <dvyukov@google.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Howard Chu <howardchu95@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Michael Petlan <mpetlan@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0658/1756] perf machine: Factor creating a "live" machine out of dwarf-unwind
Date: Wed, 18 Nov 2026 15:46:25 +0100
Message-ID: <20261118150035.143600681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 4c04654455c09b4905b84c350d88f718260a4cd4 ]

Factor out for use in places other than the dwarf unwinding tests for
libunwind.

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Anne Macedo <retpolanne@posteo.net>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Dr. David Alan Gilbert <linux@treblig.org>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Link: https://lore.kernel.org/r/20250313052952.871958-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 58bf7b7af359 ("perf test code-reading: Fix duplicate kernel maps and machine leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/dwarf-unwind.c | 35 ++++------------------
 tools/perf/util/machine.c       | 53 +++++++++++++++++++++++++++------
 tools/perf/util/machine.h       |  1 +
 3 files changed, 51 insertions(+), 38 deletions(-)

diff --git a/tools/perf/tests/dwarf-unwind.c b/tools/perf/tests/dwarf-unwind.c
index 4803ab2d97ba6..525c46b7971ad 100644
--- a/tools/perf/tests/dwarf-unwind.c
+++ b/tools/perf/tests/dwarf-unwind.c
@@ -15,7 +15,6 @@
 #include "symbol.h"
 #include "thread.h"
 #include "callchain.h"
-#include "util/synthetic-events.h"
 
 /* For bsearch. We try to unwind functions in shared object. */
 #include <stdlib.h>
@@ -37,24 +36,6 @@
 #define NO_TAIL_CALL_BARRIER __asm__ __volatile__("" : : : "memory");
 #endif
 
-static int mmap_handler(const struct perf_tool *tool __maybe_unused,
-			union perf_event *event,
-			struct perf_sample *sample,
-			struct machine *machine)
-{
-	return machine__process_mmap2_event(machine, event, sample);
-}
-
-static int init_live_machine(struct machine *machine)
-{
-	union perf_event event;
-	pid_t pid = getpid();
-
-	memset(&event, 0, sizeof(event));
-	return perf_event__synthesize_mmap_events(NULL, &event, pid, pid,
-						  mmap_handler, machine, true);
-}
-
 /*
  * We need to keep these functions global, despite the
  * fact that they are used only locally in this object,
@@ -202,8 +183,12 @@ noinline int test__dwarf_unwind(struct test_suite *test __maybe_unused,
 	struct machine *machine;
 	struct thread *thread;
 	int err = -1;
+	pid_t pid = getpid();
 
-	machine = machine__new_host();
+	callchain_param.record_mode = CALLCHAIN_DWARF;
+	dwarf_callchain_users = true;
+
+	machine = machine__new_live(/*kernel_maps=*/true, pid);
 	if (!machine) {
 		pr_err("Could not get machine\n");
 		return -1;
@@ -214,18 +199,10 @@ noinline int test__dwarf_unwind(struct test_suite *test __maybe_unused,
 		return -1;
 	}
 
-	callchain_param.record_mode = CALLCHAIN_DWARF;
-	dwarf_callchain_users = true;
-
-	if (init_live_machine(machine)) {
-		pr_err("Could not init machine\n");
-		goto out;
-	}
-
 	if (verbose > 1)
 		machine__fprintf(machine, stderr);
 
-	thread = machine__find_thread(machine, getpid(), getpid());
+	thread = machine__find_thread(machine, pid, pid);
 	if (!thread) {
 		pr_err("Could not get thread\n");
 		goto out;
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 78c021b246a6c..d124a196ad4cc 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -20,6 +20,7 @@
 #include "path.h"
 #include "srcline.h"
 #include "symbol.h"
+#include "synthetic-events.h"
 #include "sort.h"
 #include "strlist.h"
 #include "target.h"
@@ -125,23 +126,57 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 	return 0;
 }
 
-struct machine *machine__new_host(void)
+static struct machine *__machine__new_host(bool kernel_maps)
 {
 	struct machine *machine = malloc(sizeof(*machine));
 
-	if (machine != NULL) {
-		machine__init(machine, "", HOST_KERNEL_ID);
+	if (!machine)
+		return NULL;
 
-		if (machine__create_kernel_maps(machine) < 0)
-			goto out_delete;
+	machine__init(machine, "", HOST_KERNEL_ID);
 
-		machine->env = &perf_env;
+	if (kernel_maps && machine__create_kernel_maps(machine) < 0) {
+		free(machine);
+		return NULL;
 	}
+	machine->env = &perf_env;
+	return machine;
+}
+
+struct machine *machine__new_host(void)
+{
+	return __machine__new_host(/*kernel_maps=*/true);
+}
+
+static int mmap_handler(const struct perf_tool *tool __maybe_unused,
+			union perf_event *event,
+			struct perf_sample *sample,
+			struct machine *machine)
+{
+	return machine__process_mmap2_event(machine, event, sample);
+}
 
+static int machine__init_live(struct machine *machine, pid_t pid)
+{
+	union perf_event event;
+
+	memset(&event, 0, sizeof(event));
+	return perf_event__synthesize_mmap_events(NULL, &event, pid, pid,
+						  mmap_handler, machine, true);
+}
+
+struct machine *machine__new_live(bool kernel_maps, pid_t pid)
+{
+	struct machine *machine = __machine__new_host(kernel_maps);
+
+	if (!machine)
+		return NULL;
+
+	if (machine__init_live(machine, pid)) {
+		machine__delete(machine);
+		return NULL;
+	}
 	return machine;
-out_delete:
-	free(machine);
-	return NULL;
 }
 
 struct machine *machine__new_kallsyms(void)
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 2e5a4cb342d82..a3314f87a350e 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -165,6 +165,7 @@ void machines__set_comm_exec(struct machines *machines, bool comm_exec);
 
 struct machine *machine__new_host(void);
 struct machine *machine__new_kallsyms(void);
+struct machine *machine__new_live(bool kernel_maps, pid_t pid);
 int machine__init(struct machine *machine, const char *root_dir, pid_t pid);
 void machine__exit(struct machine *machine);
 void machine__delete_threads(struct machine *machine);
-- 
2.53.0



