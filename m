Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024038;
	b=AcXbAGJQwNt4xBldlKTZggwG7mDdNQJv9Vi08D5uTMXBAi5cILWimK//iSPDs8jDkAsl
	 ioMX3UxTIksM7hscc3JCPKG2NSDQVvONH7N4dDet/qDBRUzV6CEgELh/MzKfkEX+xwMKT
	 mHtoHngWRWD5NjkTtxpi0n7E4N754sx0rCIV4qPYWkEWvNzskw8vC41NmcbW5FUOwN2Jb
	 VOOe0F6QVCxLQBghAKBtgV+xZOUu926O8Vg+aCdD248B4RxSytu5GYSef3TmdMvVZaR6I
	 VV12iB0TtxgOqIQ3xDVWhlWI9XcENDi0q5qd/F0o+EPQR4RlWXA9wrV0Q8uEQi4wDKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u/33CrgY0lsnQT8LLEQZX7T2WdNuxbNw8Oz3u5u0HyA=;
	b=Wfl/LQxZuakBPhfIo8r3NZXugSiiCEuujO4a/EKjOv+A9H6UAG7yJWU9+GjChtYe7nYf
	 oElRLSt1c5nUaovT05Tybegk14a16GnKMnCUigtm+T1aC+a/184Kjc977iFw0GtIAFrvt
	 eC6b8B7OvJQGAwmfkk4wr3SO2gCBWfaVfal/UxkrhC/GeoHHE8QeA0GrX8X7rVuMZZuFX
	 024+VgWJEkVq7NToHwWcUGwrSQylxgMeCDaUZRPh4XnlMejf7xvuU/1fU+YeCG12Ba81V
	 baSRClRiTm5M01EeccMwrBapNU9HtsaMuGx7N1JTUL3IUT4O9RMPSgr1GY96mFu2l/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pV7s11DF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27ECD606A320;
	Wed, 18 Nov 2026 17:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pV7s11DF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB551F000C4;
	Wed, 18 Nov 2026 17:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024038;
	bh=u/33CrgY0lsnQT8LLEQZX7T2WdNuxbNw8Oz3u5u0HyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pV7s11DFrZyx7yXOg0Hi6qQe1Ow5bak0Jt+cWluKFWDF1Sba38HDcP7RibREYaNBK
	 2+XYwmeTOFpkGJtQaVtGAkc3x1WAfmWv4PLZzTCiIN4cDvXsNEo/jqHke/eUgJ8jU0
	 /9vCYyIdrmadSXT9Gh0HoSYDKP444wsPiytVslxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Athira Rajeev <atrajeev@linux.ibm.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Dmitrii Dolgov <9erthalion6@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Howard Chu <howardchu95@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Leo Yan <leo.yan@linux.dev>,
	Li Guan <guanli.oerv@isrc.iscas.ac.cn>,
	Namhyung Kim <namhyung@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Shimin Guo <shimin.guo@skydio.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Will Deacon <will@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0583/2151] tools build: Deduplicate test-libunwind for different architectures
Date: Wed, 18 Nov 2026 15:38:38 +0100
Message-ID: <20261118150143.188584057@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 6d13d53be9ddab1425e0c2789788adc4d6f05d74 ]

The separate test files only exist to pass a different #include,
instead have a single source file and pass -include to $(CC) to
include the relevant header file for the architecture being
tested. Generate the rules using a foreach loop. Include tests for all
current libunwind architectures.

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Jones <andrew.jones@oss.qualcomm.com>
Cc: Athira Rajeev <atrajeev@linux.ibm.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Dmitrii Dolgov <9erthalion6@gmail.com>
Cc: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Leo Yan <leo.yan@linux.dev>
Cc: Li Guan <guanli.oerv@isrc.iscas.ac.cn>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shimin Guo <shimin.guo@skydio.com>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Cc: Tomas Glozar <tglozar@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: a5cac2df8b4a ("perf build: Remove leftovers of removed build options")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/Makefile.feature                  | 12 ++++-
 tools/build/feature/Makefile                  | 46 +++++++++----------
 tools/build/feature/test-libunwind-aarch64.c  | 27 -----------
 tools/build/feature/test-libunwind-arm.c      | 28 -----------
 .../test-libunwind-debug-frame-aarch64.c      | 17 -------
 .../feature/test-libunwind-debug-frame-arm.c  | 17 -------
 .../feature/test-libunwind-debug-frame.c      |  1 -
 tools/build/feature/test-libunwind-x86.c      | 28 -----------
 tools/build/feature/test-libunwind-x86_64.c   | 28 -----------
 tools/build/feature/test-libunwind.c          |  1 -
 10 files changed, 32 insertions(+), 173 deletions(-)
 delete mode 100644 tools/build/feature/test-libunwind-aarch64.c
 delete mode 100644 tools/build/feature/test-libunwind-arm.c
 delete mode 100644 tools/build/feature/test-libunwind-debug-frame-aarch64.c
 delete mode 100644 tools/build/feature/test-libunwind-debug-frame-arm.c
 delete mode 100644 tools/build/feature/test-libunwind-x86.c
 delete mode 100644 tools/build/feature/test-libunwind-x86_64.c

diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
index a0133d52aa8a0..d188cdbee4e53 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -104,6 +104,9 @@ FEATURE_TESTS_BASIC :=                  \
 
 # FEATURE_TESTS_BASIC + FEATURE_TESTS_EXTRA is the complete list
 # of all feature tests
+
+LIBUNWIND_ARCHS:=aarch64 arm loongarch64 mips ppc32 ppc64 riscv s390x x86 x86_64
+
 FEATURE_TESTS_EXTRA :=                  \
          bionic                         \
          compile-32                     \
@@ -124,7 +127,10 @@ FEATURE_TESTS_EXTRA :=                  \
          libpfm4                        \
          libdebuginfod			\
          clang-bpf-co-re		\
-         bpftool-skeletons
+         bpftool-skeletons		\
+         libunwind			\
+         libunwind-debug-frame		\
+         $(foreach arch,$(LIBUNWIND_ARCHS),libunwind-$(arch) libunwind-debug-frame-$(arch))
 
 
 FEATURE_TESTS ?= $(FEATURE_TESTS_BASIC)
@@ -206,6 +212,10 @@ ifeq ($(feature-all), 1)
   $(call feature_check,compile-x32)
   $(call feature_check,bionic)
   $(call feature_check,libbabeltrace)
+  $(call feature_check,libunwind)
+  $(call feature_check,libunwind-debug-frame)
+  $(foreach arch,$(LIBUNWIND_ARCHS),$(call feature_check,libunwind-$(arch)))
+  $(foreach arch,$(LIBUNWIND_ARCHS),$(call feature_check,libunwind-debug-frame-$(arch)))
 else
   $(foreach feat,$(FEATURE_TESTS),$(call feature_check,$(feat)))
 endif
diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index c972304c32117..9a85b884e964b 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 include ../../scripts/Makefile.include
 
+LIBUNWIND_ARCHS:=aarch64 arm loongarch64 mips ppc32 ppc64 riscv s390x x86 x86_64
+
 FILES=                                          \
          test-all.bin                           \
          test-backtrace.bin                     \
@@ -38,12 +40,7 @@ FILES=                                          \
          test-libtracefs.bin                    \
          test-libunwind.bin                     \
          test-libunwind-debug-frame.bin         \
-         test-libunwind-x86.bin                 \
-         test-libunwind-x86_64.bin              \
-         test-libunwind-arm.bin                 \
-         test-libunwind-aarch64.bin             \
-         test-libunwind-debug-frame-arm.bin     \
-         test-libunwind-debug-frame-aarch64.bin \
+         $(foreach arch,$(LIBUNWIND_ARCHS),test-libunwind-$(arch).bin test-libunwind-debug-frame-$(arch).bin) \
          test-pthread-attr-setaffinity-np.bin   \
          test-pthread-barrier.bin		\
          test-stackprotector-all.bin            \
@@ -201,27 +198,26 @@ $(OUTPUT)test-numa_num_possible_cpus.bin:
 	$(BUILD) -lnuma
 
 $(OUTPUT)test-libunwind.bin:
-	$(BUILD) -lelf -llzma
+	$(BUILD) -include libunwind.h -lelf -llzma -lunwind
 
 $(OUTPUT)test-libunwind-debug-frame.bin:
-	$(BUILD) -lelf -llzma
-$(OUTPUT)test-libunwind-x86.bin:
-	$(BUILD) -lelf -llzma -lunwind-x86
-
-$(OUTPUT)test-libunwind-x86_64.bin:
-	$(BUILD) -lelf -llzma -lunwind-x86_64
-
-$(OUTPUT)test-libunwind-arm.bin:
-	$(BUILD) -lelf -llzma -lunwind-arm
-
-$(OUTPUT)test-libunwind-aarch64.bin:
-	$(BUILD) -lelf -llzma -lunwind-aarch64
-
-$(OUTPUT)test-libunwind-debug-frame-arm.bin:
-	$(BUILD) -lelf -llzma -lunwind-arm
-
-$(OUTPUT)test-libunwind-debug-frame-aarch64.bin:
-	$(BUILD) -lelf -llzma -lunwind-aarch64
+	$(BUILD) -include libunwind.h -lelf -llzma -lunwind
+
+define LIBUNWIND_RULE
+$$(OUTPUT)test-libunwind-$(1).bin:
+	$$(CC) $$(CFLAGS) -MD -Wall -Werror -include libunwind-$(1).h -o $$@ \
+		test-libunwind.c $$(LDFLAGS) -lelf -llzma -lunwind-$(1) \
+		> $$(@:.bin=.make.output) 2>&1
+
+$$(OUTPUT)test-libunwind-debug-frame-$(1).bin:
+	$$(CC) $$(CFLAGS) -MD -Wall -Werror -include libunwind-$(1).h -o $$@ \
+		test-libunwind-debug-frame.c $$(LDFLAGS) -lelf -llzma -lunwind-$(1) \
+		> $$(@:.bin=.make.output) 2>&1
+
+endef
+$(foreach arch,$(LIBUNWIND_ARCHS), \
+    $(eval $(call LIBUNWIND_RULE,$(arch))) \
+)
 
 $(OUTPUT)test-libslang.bin:
 	$(BUILD) -lslang
diff --git a/tools/build/feature/test-libunwind-aarch64.c b/tools/build/feature/test-libunwind-aarch64.c
deleted file mode 100644
index 323803f49212a..0000000000000
--- a/tools/build/feature/test-libunwind-aarch64.c
+++ /dev/null
@@ -1,27 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <libunwind-aarch64.h>
-#include <stdlib.h>
-
-extern int UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
-					       unw_word_t ip,
-					       unw_dyn_info_t *di,
-					       unw_proc_info_t *pi,
-					       int need_unwind_info, void *arg);
-
-#define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
-
-static unw_accessors_t accessors;
-
-int main(void)
-{
-	unw_addr_space_t addr_space;
-
-	addr_space = unw_create_addr_space(&accessors, 0);
-	if (addr_space)
-		return 0;
-
-	unw_init_remote(NULL, addr_space, NULL);
-	dwarf_search_unwind_table(addr_space, 0, NULL, NULL, 0, NULL);
-
-	return 0;
-}
diff --git a/tools/build/feature/test-libunwind-arm.c b/tools/build/feature/test-libunwind-arm.c
deleted file mode 100644
index cb378b7d68669..0000000000000
--- a/tools/build/feature/test-libunwind-arm.c
+++ /dev/null
@@ -1,28 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <libunwind-arm.h>
-#include <stdlib.h>
-
-extern int UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
-					       unw_word_t ip,
-					       unw_dyn_info_t *di,
-					       unw_proc_info_t *pi,
-					       int need_unwind_info, void *arg);
-
-
-#define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
-
-static unw_accessors_t accessors;
-
-int main(void)
-{
-	unw_addr_space_t addr_space;
-
-	addr_space = unw_create_addr_space(&accessors, 0);
-	if (addr_space)
-		return 0;
-
-	unw_init_remote(NULL, addr_space, NULL);
-	dwarf_search_unwind_table(addr_space, 0, NULL, NULL, 0, NULL);
-
-	return 0;
-}
diff --git a/tools/build/feature/test-libunwind-debug-frame-aarch64.c b/tools/build/feature/test-libunwind-debug-frame-aarch64.c
deleted file mode 100644
index 36d6646c185e1..0000000000000
--- a/tools/build/feature/test-libunwind-debug-frame-aarch64.c
+++ /dev/null
@@ -1,17 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <libunwind-aarch64.h>
-#include <stdlib.h>
-
-extern int
-UNW_OBJ(dwarf_find_debug_frame) (int found, unw_dyn_info_t *di_debug,
-				 unw_word_t ip, unw_word_t segbase,
-				 const char *obj_name, unw_word_t start,
-				 unw_word_t end);
-
-#define dwarf_find_debug_frame UNW_OBJ(dwarf_find_debug_frame)
-
-int main(void)
-{
-	dwarf_find_debug_frame(0, NULL, 0, 0, NULL, 0, 0);
-	return 0;
-}
diff --git a/tools/build/feature/test-libunwind-debug-frame-arm.c b/tools/build/feature/test-libunwind-debug-frame-arm.c
deleted file mode 100644
index 8696e48e12684..0000000000000
--- a/tools/build/feature/test-libunwind-debug-frame-arm.c
+++ /dev/null
@@ -1,17 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <libunwind-arm.h>
-#include <stdlib.h>
-
-extern int
-UNW_OBJ(dwarf_find_debug_frame) (int found, unw_dyn_info_t *di_debug,
-				 unw_word_t ip, unw_word_t segbase,
-				 const char *obj_name, unw_word_t start,
-				 unw_word_t end);
-
-#define dwarf_find_debug_frame UNW_OBJ(dwarf_find_debug_frame)
-
-int main(void)
-{
-	dwarf_find_debug_frame(0, NULL, 0, 0, NULL, 0, 0);
-	return 0;
-}
diff --git a/tools/build/feature/test-libunwind-debug-frame.c b/tools/build/feature/test-libunwind-debug-frame.c
index efb55cdd8d019..4c57e37004b3a 100644
--- a/tools/build/feature/test-libunwind-debug-frame.c
+++ b/tools/build/feature/test-libunwind-debug-frame.c
@@ -1,5 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <libunwind.h>
 #include <stdlib.h>
 
 extern int
diff --git a/tools/build/feature/test-libunwind-x86.c b/tools/build/feature/test-libunwind-x86.c
deleted file mode 100644
index e5e0f6c896374..0000000000000
--- a/tools/build/feature/test-libunwind-x86.c
+++ /dev/null
@@ -1,28 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <libunwind-x86.h>
-#include <stdlib.h>
-
-extern int UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
-					       unw_word_t ip,
-					       unw_dyn_info_t *di,
-					       unw_proc_info_t *pi,
-					       int need_unwind_info, void *arg);
-
-
-#define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
-
-static unw_accessors_t accessors;
-
-int main(void)
-{
-	unw_addr_space_t addr_space;
-
-	addr_space = unw_create_addr_space(&accessors, 0);
-	if (addr_space)
-		return 0;
-
-	unw_init_remote(NULL, addr_space, NULL);
-	dwarf_search_unwind_table(addr_space, 0, NULL, NULL, 0, NULL);
-
-	return 0;
-}
diff --git a/tools/build/feature/test-libunwind-x86_64.c b/tools/build/feature/test-libunwind-x86_64.c
deleted file mode 100644
index 62ae4db597dca..0000000000000
--- a/tools/build/feature/test-libunwind-x86_64.c
+++ /dev/null
@@ -1,28 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <libunwind-x86_64.h>
-#include <stdlib.h>
-
-extern int UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
-					       unw_word_t ip,
-					       unw_dyn_info_t *di,
-					       unw_proc_info_t *pi,
-					       int need_unwind_info, void *arg);
-
-
-#define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
-
-static unw_accessors_t accessors;
-
-int main(void)
-{
-	unw_addr_space_t addr_space;
-
-	addr_space = unw_create_addr_space(&accessors, 0);
-	if (addr_space)
-		return 0;
-
-	unw_init_remote(NULL, addr_space, NULL);
-	dwarf_search_unwind_table(addr_space, 0, NULL, NULL, 0, NULL);
-
-	return 0;
-}
diff --git a/tools/build/feature/test-libunwind.c b/tools/build/feature/test-libunwind.c
index 53fd26614ff0f..5af5dc3a73d4e 100644
--- a/tools/build/feature/test-libunwind.c
+++ b/tools/build/feature/test-libunwind.c
@@ -1,5 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <libunwind.h>
 #include <stdlib.h>
 
 extern int UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
-- 
2.53.0



