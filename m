Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78012FD1C2;
	Tue, 12 Aug 2025 18:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024106; cv=none; b=bPXeGKdE6XP2BT9q1nAaD0uv4gOIX/dE7y4jWRpZo3H1R/8EAyUxMtarDC3Zz3mJtsFPuHyYxajRN0BGq/abEhARK31eYvt2gqz49NSZ7e3FkRKYoKfrIUQgNjKpiDUZzpTq0ti6F8X22YzkSunWA3ozerhex3R6epSSyZ1GMBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024106; c=relaxed/simple;
	bh=ZbBnPhhQegHX+Cgw7f4ImND3zJim3xudKqwRJ7iBfEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/mbWXKEiwwx27xLBcVHVTK1vgR0ursObmDYzgofRrpDnSSjy+gEjpXvQSKuNtvcGm7FReWbC3/KhDTVXViU217HDJZ75ENzg13XpEt2AEsV5tXgpy1ySEvLiyY260VR5V9yQ/cg8ElPU4r6h1XtKWift3jfuTLqcqGkwrDm93c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XyNLDM9y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyNLDM9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C055C4CEF0;
	Tue, 12 Aug 2025 18:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024105;
	bh=ZbBnPhhQegHX+Cgw7f4ImND3zJim3xudKqwRJ7iBfEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyNLDM9yMYYNoUTn7Fhjj/h0xXAPEMblQxiY5vxAt8KS69qbleOIvX4Glpa1dp9dy
	 CS5MZt7XJIyIhjFO8NEFeYJ8TG7DytEQIYiDhNozcwYXyMG+eahzbNmU8MNrrIaqRK
	 4B7iCMYRJ3MmrpoZniz6FAzysqi8Fg6+MehXSCZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 243/627] PM: cpufreq: powernv/tracing: Move powernv_throttle trace event
Date: Tue, 12 Aug 2025 19:28:58 +0200
Message-ID: <20250812173428.542738883@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 647fe16b46999258ce1aec41f4bdeabb4f0cc8e7 ]

As the trace event powernv_throttle is only used by the powernv code, move
it to a separate include file and have that code directly enable it.

Trace events can take up around 5K of memory when they are defined
regardless if they are used or not. It wastes memory to have them defined
in configurations where the tracepoint is not used.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/20250612145407.906308844@goodmis.org
Fixes: 0306e481d479a ("cpufreq: powernv/tracing: Add powernv_throttle tracepoint")
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/Makefile          |  1 +
 drivers/cpufreq/powernv-cpufreq.c |  4 ++-
 drivers/cpufreq/powernv-trace.h   | 44 +++++++++++++++++++++++++++++++
 include/trace/events/power.h      | 22 ----------------
 kernel/trace/power-traces.c       |  1 -
 5 files changed, 48 insertions(+), 24 deletions(-)
 create mode 100644 drivers/cpufreq/powernv-trace.h

diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index d38526b8e063..681d687b5a18 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_CPUFREQ_VIRT)		+= virtual-cpufreq.o
 
 # Traces
 CFLAGS_amd-pstate-trace.o               := -I$(src)
+CFLAGS_powernv-cpufreq.o                := -I$(src)
 amd_pstate-y				:= amd-pstate.o amd-pstate-trace.o
 
 ##################################################################################
diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
index a8943e2a93be..7d9a5f656de8 100644
--- a/drivers/cpufreq/powernv-cpufreq.c
+++ b/drivers/cpufreq/powernv-cpufreq.c
@@ -21,7 +21,6 @@
 #include <linux/string_choices.h>
 #include <linux/cpu.h>
 #include <linux/hashtable.h>
-#include <trace/events/power.h>
 
 #include <asm/cputhreads.h>
 #include <asm/firmware.h>
@@ -30,6 +29,9 @@
 #include <asm/opal.h>
 #include <linux/timer.h>
 
+#define CREATE_TRACE_POINTS
+#include "powernv-trace.h"
+
 #define POWERNV_MAX_PSTATES_ORDER  8
 #define POWERNV_MAX_PSTATES	(1UL << (POWERNV_MAX_PSTATES_ORDER))
 #define PMSR_PSAFE_ENABLE	(1UL << 30)
diff --git a/drivers/cpufreq/powernv-trace.h b/drivers/cpufreq/powernv-trace.h
new file mode 100644
index 000000000000..8cadb7c9427b
--- /dev/null
+++ b/drivers/cpufreq/powernv-trace.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#if !defined(_POWERNV_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _POWERNV_TRACE_H
+
+#include <linux/cpufreq.h>
+#include <linux/tracepoint.h>
+#include <linux/trace_events.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM power
+
+TRACE_EVENT(powernv_throttle,
+
+	TP_PROTO(int chip_id, const char *reason, int pmax),
+
+	TP_ARGS(chip_id, reason, pmax),
+
+	TP_STRUCT__entry(
+		__field(int, chip_id)
+		__string(reason, reason)
+		__field(int, pmax)
+	),
+
+	TP_fast_assign(
+		__entry->chip_id = chip_id;
+		__assign_str(reason);
+		__entry->pmax = pmax;
+	),
+
+	TP_printk("Chip %d Pmax %d %s", __entry->chip_id,
+		  __entry->pmax, __get_str(reason))
+);
+
+#endif /* _POWERNV_TRACE_H */
+
+/* This part must be outside protection */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE powernv-trace
+
+#include <trace/define_trace.h>
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index 6c631eec23e3..913181cebfe9 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -99,28 +99,6 @@ DEFINE_EVENT(psci_domain_idle, psci_domain_idle_exit,
 	TP_ARGS(cpu_id, state, s2idle)
 );
 
-TRACE_EVENT(powernv_throttle,
-
-	TP_PROTO(int chip_id, const char *reason, int pmax),
-
-	TP_ARGS(chip_id, reason, pmax),
-
-	TP_STRUCT__entry(
-		__field(int, chip_id)
-		__string(reason, reason)
-		__field(int, pmax)
-	),
-
-	TP_fast_assign(
-		__entry->chip_id = chip_id;
-		__assign_str(reason);
-		__entry->pmax = pmax;
-	),
-
-	TP_printk("Chip %d Pmax %d %s", __entry->chip_id,
-		  __entry->pmax, __get_str(reason))
-);
-
 TRACE_EVENT(pstate_sample,
 
 	TP_PROTO(u32 core_busy,
diff --git a/kernel/trace/power-traces.c b/kernel/trace/power-traces.c
index 21bb161c2316..f2fe33573e54 100644
--- a/kernel/trace/power-traces.c
+++ b/kernel/trace/power-traces.c
@@ -17,5 +17,4 @@
 EXPORT_TRACEPOINT_SYMBOL_GPL(suspend_resume);
 EXPORT_TRACEPOINT_SYMBOL_GPL(cpu_idle);
 EXPORT_TRACEPOINT_SYMBOL_GPL(cpu_frequency);
-EXPORT_TRACEPOINT_SYMBOL_GPL(powernv_throttle);
 
-- 
2.39.5



