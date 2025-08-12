Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA3126FA77;
	Tue, 12 Aug 2025 19:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025921; cv=none; b=DXLksQttpHPZOZFRNVYHcCiYrl/Oj9iqdvHNvyLRkIJvetsywpXX9AXcwhTkm2NpUnDzQFnyq4jZhgpexHOM2PwRiY1B8W+xzKdNFvN67PP1dVUzL/l0Y+mkcHMo/f+QNFoXzIkUl1qBR1SUGNminW5h+yaWOR9yAw9DtlTmlOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025921; c=relaxed/simple;
	bh=wBTIlnp/tcXXvsMYiVNuy3sZ+Dys2cyyODk/2M7wUUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMOLqpJ573LYiHAfve4KCFduVvYNV5og4KuZXwF+ubE1T3mLutr5o/81ZEsiRmPjxMzv62VHTCf4tq1rQHf7ojN6XdMAllAZarDumtmYyFU7U6DqaF/RozBRksLytzeHJZ3JDtS1yzbYK40S6QgxqPzi1iJqj7dnKaeAQUIK8Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CcSm3pDy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CcSm3pDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A54C4CEF0;
	Tue, 12 Aug 2025 19:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025921;
	bh=wBTIlnp/tcXXvsMYiVNuy3sZ+Dys2cyyODk/2M7wUUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CcSm3pDy/eTJDrX8AY1V/aX3xrwitrbmLjtPr19WPKDCY8J1JLvXcNiWZrOjqy4CP
	 okLTbzoDfoVqOrWNy5YELVkhtiOXyd7j2BFLvzCUk2rVlVqSXiJb3FUeJwiuBDtktR
	 3dR1tyZ1863sfj+akmRobkUD5O7hWc615PT82P3k=
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
Subject: [PATCH 6.15 183/480] PM: cpufreq: powernv/tracing: Move powernv_throttle trace event
Date: Tue, 12 Aug 2025 19:46:31 +0200
Message-ID: <20250812174405.061919626@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 22ab45209f9b..246f58b496da 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_CPUFREQ_VIRT)		+= virtual-cpufreq.o
 
 # Traces
 CFLAGS_amd-pstate-trace.o               := -I$(src)
+CFLAGS_powernv-cpufreq.o                := -I$(src)
 amd_pstate-y				:= amd-pstate.o amd-pstate-trace.o
 
 ##################################################################################
diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
index afe5abf89d33..b7c3251e7e87 100644
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
index 9253e83b9bb4..ff0974e9be9a 100644
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



