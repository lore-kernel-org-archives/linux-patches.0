Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030308;
	b=leE8q1mfmglJiugHt3LtBlkV6DrDD3TghslY8vjXkRgOXqbVI5wOMdVSy55/pa6VzZj7
	 a7igmJ0JKmSwclK17FBtd38frJbJLcx7roo9lC4XGN+a/RjjNZIr0d+1LI9o61RjcR1Up
	 VzRuphl2ojztDSzl6YXxWVL9R960QETlfE9EC9IGq44RpLa8ikiUa27cdoteznCdzC8kT
	 CAaSKZ0MLKAQnQoX2tKUlDkTYDers2cK2jEwdLUIYf75xR8Le63dulh3Shq0+W11X+Fo0
	 KPhmDfjk73rTzuvc2Mb8lOekr5tMXCicClV4VBYva8Rxb+Jdy2Tc3mt+Js0lWq1Jidg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q8j5Xkx21kXMPKaww9p/jJDKH0y+sUAM25w7ZYnABec=;
	b=gMe7pvnqjndv172N/RxBsx/LDi//deNsXA/AxxDume31L88IHlHbahHRs4z+1rMFnIoM
	 TLBGvYaqUcXIGQb7k1qzzlSC8FatgqfrMo55EFiCvdoKTdG+36yE7Sz3i83V9ri9nriOA
	 uHiSmlyiS/v9++vCbjeHJcGkLba6A2pR7U7NQFkqCngWfNExIQH0aChOInwlCr/m6ADGd
	 hhptkT1QLP8obh2ELexZ2xa4KD1HDLDx9juSfVv6D3/VnMk5bUvABUJ1b2/bcGNeFQc3D
	 /VIX/m7Yk0wWIOOE1qXf9OV423jDSMjjc9Ch+hD4KGu0KuJS5hMGSZwVtQgNqszgwiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V0Xx7RkE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422B8606A7CA;
	Wed, 18 Nov 2026 19:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V0Xx7RkE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BE11F000C4;
	Wed, 18 Nov 2026 19:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030308;
	bh=Q8j5Xkx21kXMPKaww9p/jJDKH0y+sUAM25w7ZYnABec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V0Xx7RkEaPbnWj/ufQYaX8BwP7tHqAss3iN381Fdg6aplZTOvViQXv8/9PuAqiASD
	 jk8vDm4qkTClt/Dcyv4J7UgbkY6l+Gr2JnX4axMJdfFKXzi0/v9IXlX2w6GMwLSiIi
	 jScqSK69skM5sXD9e0yYYEO6xcVO0rzI2TkN/jNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0659/1756] perf debug: Add function symbols to dump_stack
Date: Wed, 18 Nov 2026 15:46:26 +0100
Message-ID: <20261118150035.216239660@linuxfoundation.org>
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

[ Upstream commit 9c9f4a27eb1096beb650f312a1ce996a9960b56c ]

Symbolize stack traces by creating a live machine. Add this
functionality to dump_stack and switch dump_stack users to use
it. Switch TUI to use it. Add stack traces to the child test function
which can be useful to diagnose blocked code.

Example output:
```
$ perf test -vv PERF_RECORD_
...
  7: PERF_RECORD_* events & perf_sample fields:
  7: PERF_RECORD_* events & perf_sample fields                       : Running (1 active)
^C
Signal (2) while running tests.
Terminating tests with the same signal
Internal test harness failure. Completing any started tests:
:  7: PERF_RECORD_* events & perf_sample fields:

---- unexpected signal (2) ----
    #0 0x55788c6210a3 in child_test_sig_handler builtin-test.c:0
    #1 0x7fc12fe49df0 in __restore_rt libc_sigaction.c:0
    #2 0x7fc12fe99687 in __internal_syscall_cancel cancellation.c:64
    #3 0x7fc12fee5f7a in clock_nanosleep@GLIBC_2.2.5 clock_nanosleep.c:72
    #4 0x7fc12fef1393 in __nanosleep nanosleep.c:26
    #5 0x7fc12ff02d68 in __sleep sleep.c:55
    #6 0x55788c63196b in test__PERF_RECORD perf-record.c:0
    #7 0x55788c620fb0 in run_test_child builtin-test.c:0
    #8 0x55788c5bd18d in start_command run-command.c:127
    #9 0x55788c621ef3 in __cmd_test builtin-test.c:0
    #10 0x55788c6225bf in cmd_test ??:0
    #11 0x55788c5afbd0 in run_builtin perf.c:0
    #12 0x55788c5afeeb in handle_internal_command perf.c:0
    #13 0x55788c52b383 in main ??:0
    #14 0x7fc12fe33ca8 in __libc_start_call_main libc_start_call_main.h:74
    #15 0x7fc12fe33d65 in __libc_start_main@@GLIBC_2.34 libc-start.c:128
    #16 0x55788c52b9d1 in _start ??:0

---- unexpected signal (2) ----
    #0 0x55788c6210a3 in child_test_sig_handler builtin-test.c:0
    #1 0x7fc12fe49df0 in __restore_rt libc_sigaction.c:0
    #2 0x7fc12fea3a14 in pthread_sigmask@GLIBC_2.2.5 pthread_sigmask.c:45
    #3 0x7fc12fe49fd9 in __GI___sigprocmask sigprocmask.c:26
    #4 0x7fc12ff2601b in __longjmp_chk longjmp.c:36
    #5 0x55788c6210c0 in print_test_result.isra.0 builtin-test.c:0
    #6 0x7fc12fe49df0 in __restore_rt libc_sigaction.c:0
    #7 0x7fc12fe99687 in __internal_syscall_cancel cancellation.c:64
    #8 0x7fc12fee5f7a in clock_nanosleep@GLIBC_2.2.5 clock_nanosleep.c:72
    #9 0x7fc12fef1393 in __nanosleep nanosleep.c:26
    #10 0x7fc12ff02d68 in __sleep sleep.c:55
    #11 0x55788c63196b in test__PERF_RECORD perf-record.c:0
    #12 0x55788c620fb0 in run_test_child builtin-test.c:0
    #13 0x55788c5bd18d in start_command run-command.c:127
    #14 0x55788c621ef3 in __cmd_test builtin-test.c:0
    #15 0x55788c6225bf in cmd_test ??:0
    #16 0x55788c5afbd0 in run_builtin perf.c:0
    #17 0x55788c5afeeb in handle_internal_command perf.c:0
    #18 0x55788c52b383 in main ??:0
    #19 0x7fc12fe33ca8 in __libc_start_call_main libc_start_call_main.h:74
    #20 0x7fc12fe33d65 in __libc_start_main@@GLIBC_2.34 libc-start.c:128
    #21 0x55788c52b9d1 in _start ??:0
  7: PERF_RECORD_* events & perf_sample fields                       : Skip (permissions)
```

Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250624210500.2121303-1-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 58bf7b7af359 ("perf test code-reading: Fix duplicate kernel maps and machine leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/builtin-test.c | 15 +++++++-
 tools/perf/ui/tui/setup.c       |  2 +-
 tools/perf/util/debug.c         | 68 +++++++++++++++++++++++++++------
 tools/perf/util/debug.h         |  1 +
 4 files changed, 73 insertions(+), 13 deletions(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index e35b138f4bd0e..4698b48d15a5c 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -6,6 +6,9 @@
  */
 #include <fcntl.h>
 #include <errno.h>
+#ifdef HAVE_BACKTRACE_SUPPORT
+#include <execinfo.h>
+#endif
 #include <poll.h>
 #include <unistd.h>
 #include <setjmp.h>
@@ -233,6 +236,16 @@ static jmp_buf run_test_jmp_buf;
 
 static void child_test_sig_handler(int sig)
 {
+#ifdef HAVE_BACKTRACE_SUPPORT
+	void *stackdump[32];
+	size_t stackdump_size;
+#endif
+
+	fprintf(stderr, "\n---- unexpected signal (%d) ----\n", sig);
+#ifdef HAVE_BACKTRACE_SUPPORT
+	stackdump_size = backtrace(stackdump, ARRAY_SIZE(stackdump));
+	__dump_stack(stderr, stackdump, stackdump_size);
+#endif
 	siglongjmp(run_test_jmp_buf, sig);
 }
 
@@ -246,7 +259,7 @@ static int run_test_child(struct child_process *process)
 
 	err = sigsetjmp(run_test_jmp_buf, 1);
 	if (err) {
-		fprintf(stderr, "\n---- unexpected signal (%d) ----\n", err);
+		/* Received signal. */
 		err = err > 0 ? -err : -1;
 		goto err_out;
 	}
diff --git a/tools/perf/ui/tui/setup.c b/tools/perf/ui/tui/setup.c
index 16c6eff4d2411..022534eed68cc 100644
--- a/tools/perf/ui/tui/setup.c
+++ b/tools/perf/ui/tui/setup.c
@@ -108,7 +108,7 @@ static void ui__signal_backtrace(int sig)
 
 	printf("-------- backtrace --------\n");
 	size = backtrace(stackdump, ARRAY_SIZE(stackdump));
-	backtrace_symbols_fd(stackdump, size, STDOUT_FILENO);
+	__dump_stack(stdout, stackdump, size);
 
 	exit(0);
 }
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index e56330c85fe7e..a561eb97a9a86 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -14,11 +14,18 @@
 #ifdef HAVE_BACKTRACE_SUPPORT
 #include <execinfo.h>
 #endif
+#include "addr_location.h"
 #include "color.h"
-#include "event.h"
 #include "debug.h"
+#include "event.h"
+#include "machine.h"
+#include "map.h"
 #include "print_binary.h"
+#include "srcline.h"
+#include "symbol.h"
+#include "synthetic-events.h"
 #include "target.h"
+#include "thread.h"
 #include "trace-event.h"
 #include "ui/helpline.h"
 #include "ui/ui.h"
@@ -298,21 +305,60 @@ void perf_debug_setup(void)
 	libapi_set_print(pr_warning_wrapper, pr_warning_wrapper, pr_debug_wrapper);
 }
 
+void __dump_stack(FILE *file, void **stackdump, size_t stackdump_size)
+{
+	/* TODO: async safety. printf, malloc, etc. aren't safe inside a signal handler. */
+	pid_t pid = getpid();
+	struct machine *machine = machine__new_live(/*kernel_maps=*/false, pid);
+	struct thread *thread = NULL;
+
+	if (machine)
+		thread = machine__find_thread(machine, pid, pid);
+
+#ifdef HAVE_BACKTRACE_SUPPORT
+	if (!machine || !thread) {
+		/*
+		 * Backtrace functions are async signal safe. Fall back on them
+		 * if machine/thread creation fails.
+		 */
+		backtrace_symbols_fd(stackdump, stackdump_size, fileno(file));
+		machine__delete(machine);
+		return;
+	}
+#endif
+
+	for (size_t i = 0; i < stackdump_size; i++) {
+		struct addr_location al;
+		u64 addr = (u64)(uintptr_t)stackdump[i];
+		bool printed = false;
+
+		addr_location__init(&al);
+		if (thread && thread__find_map(thread, PERF_RECORD_MISC_USER, addr, &al)) {
+			al.sym = map__find_symbol(al.map, al.addr);
+			if (al.sym) {
+				fprintf(file, "    #%zd %p in %s ", i, stackdump[i], al.sym->name);
+				printed = true;
+			}
+		}
+		if (!printed)
+			fprintf(file, "    #%zd %p ", i, stackdump[i]);
+
+		map__fprintf_srcline(al.map, al.addr, "", file);
+		fprintf(file, "\n");
+		addr_location__exit(&al);
+	}
+	thread__put(thread);
+	machine__delete(machine);
+}
+
 /* Obtain a backtrace and print it to stdout. */
 #ifdef HAVE_BACKTRACE_SUPPORT
 void dump_stack(void)
 {
-	void *array[16];
-	size_t size = backtrace(array, ARRAY_SIZE(array));
-	char **strings = backtrace_symbols(array, size);
-	size_t i;
-
-	printf("Obtained %zd stack frames.\n", size);
-
-	for (i = 0; i < size; i++)
-		printf("%s\n", strings[i]);
+	void *stackdump[32];
+	size_t size = backtrace(stackdump, ARRAY_SIZE(stackdump));
 
-	free(strings);
+	__dump_stack(stdout, stackdump, size);
 }
 #else
 void dump_stack(void) {}
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index a4026d1fd6a31..6b737e195ce1b 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -85,6 +85,7 @@ void debug_set_display_time(bool set);
 void perf_debug_setup(void);
 int perf_quiet_option(void);
 
+void __dump_stack(FILE *file, void **stackdump, size_t stackdump_size);
 void dump_stack(void);
 void sighandler_dump_stack(int sig);
 
-- 
2.53.0



