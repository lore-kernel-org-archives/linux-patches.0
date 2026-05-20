Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560E036D9F5;
	Wed, 20 May 2026 17:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298546; cv=none; b=qpeVWQLt2dE84He/sgc1vqxgS5RZpLfhkp1pM0U7Bd5/hVJfeFiLYjr7TYJztgOPMosppJqYID+ttArA+4uAWCcWMLRx4vUAzfFnQfUF6NLE9efofc7bh48TdCldR1o/cXP4PgUQ7o4H4NeAa1R3nRfNABcS4c2Yw5xfBId8nGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298546; c=relaxed/simple;
	bh=W5vZpeqMh408jfx9qx4vbN4utvKRmUK3zWBjjpTyZ2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0yZY0EIPhlg0lihP+958bHjkR54SxZePfWWWRF7WzDBF2ZMOIB3rTuO04WIC61mlb84E/bKhNeYY8v+6lK+Ka4Zkd6ZGsHfIuKJG7OJd0vNlQN58TPMHhOdIOvZE4o7JYzgKp+8K33SOYUsbKks1oQ3vhhLRU+4kjQwZhUP/ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pkTdeiLg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pkTdeiLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD661F000E9;
	Wed, 20 May 2026 17:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298543;
	bh=n+7Zxa2j6d9z+krUbesienpbABihCqjYPNTEZcHmqVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pkTdeiLg0ZPU4NQ4xdFOg0o0F4YrG+wlr+z5yK9IwBGY/9rn8N8tXHdjJ18TKaB+e
	 nNP6YZgOeQygz6LUPlWy6Kf12ZPiVjXN9s7FTHaNZ5s/M69hA5LPZ8CRbOZPsRJ7hv
	 blOxfBBVWNmwj/9hcAY0m0ZabHZ0w5xBnNI3BQ1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yury Norov <ynorov@nvidia.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Jani Nikula <jani.nikula@intel.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 452/957] tracing: move tracing declarations from kernel.h to a dedicated header
Date: Wed, 20 May 2026 18:15:35 +0200
Message-ID: <20260520162144.323561172@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yury Norov <ynorov@nvidia.com>

[ Upstream commit bec261fec6d41318e414c4064f2b67c6db628acd ]

Tracing is a half of the kernel.h in terms of LOCs, although it's a
self-consistent part.  It is intended for quick debugging purposes and
isn't used by the normal tracing utilities.

Move it to a separate header.  If someone needs to just throw a
trace_printk() in their driver, they will not have to pull all the heavy
tracing machinery.

This is a pure move.

Link: https://lkml.kernel.org/r/20260116042510.241009-7-ynorov@nvidia.com
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 473e470f16f9 ("tracing: move __printf() attribute on __ftrace_vbprintk()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kernel.h       | 196 +--------------------------------
 include/linux/trace_printk.h | 204 +++++++++++++++++++++++++++++++++++
 2 files changed, 205 insertions(+), 195 deletions(-)
 create mode 100644 include/linux/trace_printk.h

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d5a939b8c3911..356a6f1db9dac 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -32,7 +32,7 @@
 #include <linux/build_bug.h>
 #include <linux/sprintf.h>
 #include <linux/static_call_types.h>
-#include <linux/instruction_pointer.h>
+#include <linux/trace_printk.h>
 #include <linux/util_macros.h>
 #include <linux/wordpart.h>
 
@@ -192,200 +192,6 @@ enum system_states {
 };
 extern enum system_states system_state;
 
-/*
- * General tracing related utility functions - trace_printk(),
- * tracing_on/tracing_off and tracing_start()/tracing_stop
- *
- * Use tracing_on/tracing_off when you want to quickly turn on or off
- * tracing. It simply enables or disables the recording of the trace events.
- * This also corresponds to the user space /sys/kernel/tracing/tracing_on
- * file, which gives a means for the kernel and userspace to interact.
- * Place a tracing_off() in the kernel where you want tracing to end.
- * From user space, examine the trace, and then echo 1 > tracing_on
- * to continue tracing.
- *
- * tracing_stop/tracing_start has slightly more overhead. It is used
- * by things like suspend to ram where disabling the recording of the
- * trace is not enough, but tracing must actually stop because things
- * like calling smp_processor_id() may crash the system.
- *
- * Most likely, you want to use tracing_on/tracing_off.
- */
-
-enum ftrace_dump_mode {
-	DUMP_NONE,
-	DUMP_ALL,
-	DUMP_ORIG,
-	DUMP_PARAM,
-};
-
-#ifdef CONFIG_TRACING
-void tracing_on(void);
-void tracing_off(void);
-int tracing_is_on(void);
-void tracing_snapshot(void);
-void tracing_snapshot_alloc(void);
-
-extern void tracing_start(void);
-extern void tracing_stop(void);
-
-static inline __printf(1, 2)
-void ____trace_printk_check_format(const char *fmt, ...)
-{
-}
-#define __trace_printk_check_format(fmt, args...)			\
-do {									\
-	if (0)								\
-		____trace_printk_check_format(fmt, ##args);		\
-} while (0)
-
-/**
- * trace_printk - printf formatting in the ftrace buffer
- * @fmt: the printf format for printing
- *
- * Note: __trace_printk is an internal function for trace_printk() and
- *       the @ip is passed in via the trace_printk() macro.
- *
- * This function allows a kernel developer to debug fast path sections
- * that printk is not appropriate for. By scattering in various
- * printk like tracing in the code, a developer can quickly see
- * where problems are occurring.
- *
- * This is intended as a debugging tool for the developer only.
- * Please refrain from leaving trace_printks scattered around in
- * your code. (Extra memory is used for special buffers that are
- * allocated when trace_printk() is used.)
- *
- * A little optimization trick is done here. If there's only one
- * argument, there's no need to scan the string for printf formats.
- * The trace_puts() will suffice. But how can we take advantage of
- * using trace_puts() when trace_printk() has only one argument?
- * By stringifying the args and checking the size we can tell
- * whether or not there are args. __stringify((__VA_ARGS__)) will
- * turn into "()\0" with a size of 3 when there are no args, anything
- * else will be bigger. All we need to do is define a string to this,
- * and then take its size and compare to 3. If it's bigger, use
- * do_trace_printk() otherwise, optimize it to trace_puts(). Then just
- * let gcc optimize the rest.
- */
-
-#define trace_printk(fmt, ...)				\
-do {							\
-	char _______STR[] = __stringify((__VA_ARGS__));	\
-	if (sizeof(_______STR) > 3)			\
-		do_trace_printk(fmt, ##__VA_ARGS__);	\
-	else						\
-		trace_puts(fmt);			\
-} while (0)
-
-#define do_trace_printk(fmt, args...)					\
-do {									\
-	static const char *trace_printk_fmt __used			\
-		__section("__trace_printk_fmt") =			\
-		__builtin_constant_p(fmt) ? fmt : NULL;			\
-									\
-	__trace_printk_check_format(fmt, ##args);			\
-									\
-	if (__builtin_constant_p(fmt))					\
-		__trace_bprintk(_THIS_IP_, trace_printk_fmt, ##args);	\
-	else								\
-		__trace_printk(_THIS_IP_, fmt, ##args);			\
-} while (0)
-
-extern __printf(2, 3)
-int __trace_bprintk(unsigned long ip, const char *fmt, ...);
-
-extern __printf(2, 3)
-int __trace_printk(unsigned long ip, const char *fmt, ...);
-
-/**
- * trace_puts - write a string into the ftrace buffer
- * @str: the string to record
- *
- * Note: __trace_bputs is an internal function for trace_puts and
- *       the @ip is passed in via the trace_puts macro.
- *
- * This is similar to trace_printk() but is made for those really fast
- * paths that a developer wants the least amount of "Heisenbug" effects,
- * where the processing of the print format is still too much.
- *
- * This function allows a kernel developer to debug fast path sections
- * that printk is not appropriate for. By scattering in various
- * printk like tracing in the code, a developer can quickly see
- * where problems are occurring.
- *
- * This is intended as a debugging tool for the developer only.
- * Please refrain from leaving trace_puts scattered around in
- * your code. (Extra memory is used for special buffers that are
- * allocated when trace_puts() is used.)
- *
- * Returns: 0 if nothing was written, positive # if string was.
- *  (1 when __trace_bputs is used, strlen(str) when __trace_puts is used)
- */
-
-#define trace_puts(str) ({						\
-	static const char *trace_printk_fmt __used			\
-		__section("__trace_printk_fmt") =			\
-		__builtin_constant_p(str) ? str : NULL;			\
-									\
-	if (__builtin_constant_p(str))					\
-		__trace_bputs(_THIS_IP_, trace_printk_fmt);		\
-	else								\
-		__trace_puts(_THIS_IP_, str);				\
-})
-extern int __trace_bputs(unsigned long ip, const char *str);
-extern int __trace_puts(unsigned long ip, const char *str);
-
-extern void trace_dump_stack(int skip);
-
-/*
- * The double __builtin_constant_p is because gcc will give us an error
- * if we try to allocate the static variable to fmt if it is not a
- * constant. Even with the outer if statement.
- */
-#define ftrace_vprintk(fmt, vargs)					\
-do {									\
-	if (__builtin_constant_p(fmt)) {				\
-		static const char *trace_printk_fmt __used		\
-		  __section("__trace_printk_fmt") =			\
-			__builtin_constant_p(fmt) ? fmt : NULL;		\
-									\
-		__ftrace_vbprintk(_THIS_IP_, trace_printk_fmt, vargs);	\
-	} else								\
-		__ftrace_vprintk(_THIS_IP_, fmt, vargs);		\
-} while (0)
-
-extern __printf(2, 0) int
-__ftrace_vbprintk(unsigned long ip, const char *fmt, va_list ap);
-
-extern __printf(2, 0) int
-__ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap);
-
-extern void ftrace_dump(enum ftrace_dump_mode oops_dump_mode);
-#else
-static inline void tracing_start(void) { }
-static inline void tracing_stop(void) { }
-static inline void trace_dump_stack(int skip) { }
-
-static inline void tracing_on(void) { }
-static inline void tracing_off(void) { }
-static inline int tracing_is_on(void) { return 0; }
-static inline void tracing_snapshot(void) { }
-static inline void tracing_snapshot_alloc(void) { }
-
-static inline __printf(1, 2)
-int trace_printk(const char *fmt, ...)
-{
-	return 0;
-}
-static __printf(1, 0) inline int
-ftrace_vprintk(const char *fmt, va_list ap)
-{
-	return 0;
-}
-static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
-#endif /* CONFIG_TRACING */
-
 /* Rebuild everything on CONFIG_DYNAMIC_FTRACE */
 #ifdef CONFIG_DYNAMIC_FTRACE
 # define REBUILD_DUE_TO_DYNAMIC_FTRACE
diff --git a/include/linux/trace_printk.h b/include/linux/trace_printk.h
new file mode 100644
index 0000000000000..bb5874097f24e
--- /dev/null
+++ b/include/linux/trace_printk.h
@@ -0,0 +1,204 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_TRACE_PRINTK_H
+#define _LINUX_TRACE_PRINTK_H
+
+#include <linux/compiler_attributes.h>
+#include <linux/instruction_pointer.h>
+#include <linux/stddef.h>
+#include <linux/stringify.h>
+
+/*
+ * General tracing related utility functions - trace_printk(),
+ * tracing_on/tracing_off and tracing_start()/tracing_stop
+ *
+ * Use tracing_on/tracing_off when you want to quickly turn on or off
+ * tracing. It simply enables or disables the recording of the trace events.
+ * This also corresponds to the user space /sys/kernel/tracing/tracing_on
+ * file, which gives a means for the kernel and userspace to interact.
+ * Place a tracing_off() in the kernel where you want tracing to end.
+ * From user space, examine the trace, and then echo 1 > tracing_on
+ * to continue tracing.
+ *
+ * tracing_stop/tracing_start has slightly more overhead. It is used
+ * by things like suspend to ram where disabling the recording of the
+ * trace is not enough, but tracing must actually stop because things
+ * like calling smp_processor_id() may crash the system.
+ *
+ * Most likely, you want to use tracing_on/tracing_off.
+ */
+
+enum ftrace_dump_mode {
+	DUMP_NONE,
+	DUMP_ALL,
+	DUMP_ORIG,
+	DUMP_PARAM,
+};
+
+#ifdef CONFIG_TRACING
+void tracing_on(void);
+void tracing_off(void);
+int tracing_is_on(void);
+void tracing_snapshot(void);
+void tracing_snapshot_alloc(void);
+
+extern void tracing_start(void);
+extern void tracing_stop(void);
+
+static inline __printf(1, 2)
+void ____trace_printk_check_format(const char *fmt, ...)
+{
+}
+#define __trace_printk_check_format(fmt, args...)			\
+do {									\
+	if (0)								\
+		____trace_printk_check_format(fmt, ##args);		\
+} while (0)
+
+/**
+ * trace_printk - printf formatting in the ftrace buffer
+ * @fmt: the printf format for printing
+ *
+ * Note: __trace_printk is an internal function for trace_printk() and
+ *       the @ip is passed in via the trace_printk() macro.
+ *
+ * This function allows a kernel developer to debug fast path sections
+ * that printk is not appropriate for. By scattering in various
+ * printk like tracing in the code, a developer can quickly see
+ * where problems are occurring.
+ *
+ * This is intended as a debugging tool for the developer only.
+ * Please refrain from leaving trace_printks scattered around in
+ * your code. (Extra memory is used for special buffers that are
+ * allocated when trace_printk() is used.)
+ *
+ * A little optimization trick is done here. If there's only one
+ * argument, there's no need to scan the string for printf formats.
+ * The trace_puts() will suffice. But how can we take advantage of
+ * using trace_puts() when trace_printk() has only one argument?
+ * By stringifying the args and checking the size we can tell
+ * whether or not there are args. __stringify((__VA_ARGS__)) will
+ * turn into "()\0" with a size of 3 when there are no args, anything
+ * else will be bigger. All we need to do is define a string to this,
+ * and then take its size and compare to 3. If it's bigger, use
+ * do_trace_printk() otherwise, optimize it to trace_puts(). Then just
+ * let gcc optimize the rest.
+ */
+
+#define trace_printk(fmt, ...)				\
+do {							\
+	char _______STR[] = __stringify((__VA_ARGS__));	\
+	if (sizeof(_______STR) > 3)			\
+		do_trace_printk(fmt, ##__VA_ARGS__);	\
+	else						\
+		trace_puts(fmt);			\
+} while (0)
+
+#define do_trace_printk(fmt, args...)					\
+do {									\
+	static const char *trace_printk_fmt __used			\
+		__section("__trace_printk_fmt") =			\
+		__builtin_constant_p(fmt) ? fmt : NULL;			\
+									\
+	__trace_printk_check_format(fmt, ##args);			\
+									\
+	if (__builtin_constant_p(fmt))					\
+		__trace_bprintk(_THIS_IP_, trace_printk_fmt, ##args);	\
+	else								\
+		__trace_printk(_THIS_IP_, fmt, ##args);			\
+} while (0)
+
+extern __printf(2, 3)
+int __trace_bprintk(unsigned long ip, const char *fmt, ...);
+
+extern __printf(2, 3)
+int __trace_printk(unsigned long ip, const char *fmt, ...);
+
+/**
+ * trace_puts - write a string into the ftrace buffer
+ * @str: the string to record
+ *
+ * Note: __trace_bputs is an internal function for trace_puts and
+ *       the @ip is passed in via the trace_puts macro.
+ *
+ * This is similar to trace_printk() but is made for those really fast
+ * paths that a developer wants the least amount of "Heisenbug" effects,
+ * where the processing of the print format is still too much.
+ *
+ * This function allows a kernel developer to debug fast path sections
+ * that printk is not appropriate for. By scattering in various
+ * printk like tracing in the code, a developer can quickly see
+ * where problems are occurring.
+ *
+ * This is intended as a debugging tool for the developer only.
+ * Please refrain from leaving trace_puts scattered around in
+ * your code. (Extra memory is used for special buffers that are
+ * allocated when trace_puts() is used.)
+ *
+ * Returns: 0 if nothing was written, positive # if string was.
+ *  (1 when __trace_bputs is used, strlen(str) when __trace_puts is used)
+ */
+
+#define trace_puts(str) ({						\
+	static const char *trace_printk_fmt __used			\
+		__section("__trace_printk_fmt") =			\
+		__builtin_constant_p(str) ? str : NULL;			\
+									\
+	if (__builtin_constant_p(str))					\
+		__trace_bputs(_THIS_IP_, trace_printk_fmt);		\
+	else								\
+		__trace_puts(_THIS_IP_, str);				\
+})
+extern int __trace_bputs(unsigned long ip, const char *str);
+extern int __trace_puts(unsigned long ip, const char *str);
+
+extern void trace_dump_stack(int skip);
+
+/*
+ * The double __builtin_constant_p is because gcc will give us an error
+ * if we try to allocate the static variable to fmt if it is not a
+ * constant. Even with the outer if statement.
+ */
+#define ftrace_vprintk(fmt, vargs)					\
+do {									\
+	if (__builtin_constant_p(fmt)) {				\
+		static const char *trace_printk_fmt __used		\
+		  __section("__trace_printk_fmt") =			\
+			__builtin_constant_p(fmt) ? fmt : NULL;		\
+									\
+		__ftrace_vbprintk(_THIS_IP_, trace_printk_fmt, vargs);	\
+	} else								\
+		__ftrace_vprintk(_THIS_IP_, fmt, vargs);		\
+} while (0)
+
+extern __printf(2, 0) int
+__ftrace_vbprintk(unsigned long ip, const char *fmt, va_list ap);
+
+extern __printf(2, 0) int
+__ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap);
+
+extern void ftrace_dump(enum ftrace_dump_mode oops_dump_mode);
+#else
+static inline void tracing_start(void) { }
+static inline void tracing_stop(void) { }
+static inline void trace_dump_stack(int skip) { }
+
+static inline void tracing_on(void) { }
+static inline void tracing_off(void) { }
+static inline int tracing_is_on(void) { return 0; }
+static inline void tracing_snapshot(void) { }
+static inline void tracing_snapshot_alloc(void) { }
+
+static inline __printf(1, 2)
+int trace_printk(const char *fmt, ...)
+{
+	return 0;
+}
+static __printf(1, 0) inline int
+ftrace_vprintk(const char *fmt, va_list ap)
+{
+	return 0;
+}
+static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
+#endif /* CONFIG_TRACING */
+
+#endif
-- 
2.53.0



