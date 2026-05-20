Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F945270545;
	Wed, 20 May 2026 18:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301849; cv=none; b=K2xXuNH4p3WnLvoNW/5iLueWD/VBJvzo9KP26YjXHmDmF6nPs+xqFdD8ASKlICy735P8CD+OlxDXH2538iEyF3eoSbyTbfoyA1/GkwPdfRXA7Doj8b+lUKJkMy3ufwyw629puwELKgqIymlsJahV+rChgX/Ifec/F4DKhWLQpXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301849; c=relaxed/simple;
	bh=6ZLx4uAGbdPNjsHieh4BFPToB6x4lgCbQKTARZlch/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvmPND0DnNSYPzu4fUxLx/RE+H/utgwDzl0B8M7Cr3DKOzO2FC9S0eWwxEDvhvhx6F6d1zyMXw1pjMS60ltCBGbIjTYi7xNOc/jDv1hmZRCQwn5GndeQPpl3S0YiVNi7EN4VPnyGVVZApfQDFjvG5e37UhYXOWc1pw3H8QaxNno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWsSnp24; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWsSnp24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DEBD1F00898;
	Wed, 20 May 2026 18:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301848;
	bh=kKFAYOGTZl3c5VzviJNKzw12RFAqC+QVQh2xRjofY+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EWsSnp24WxK5pS6pdbr7Of3mBw2Z1qSLQwLbbYvqHCm1yJ7sPQwSqKARKOYC4mSMA
	 WNSDKVroEH6Qf0lFTZbDikpCIdd0erE29dm/h0zJa2HJoF/OpMoE8KOA0l/s7Jf5Hm
	 ubABkNqKF9qFIyCyxpqjJ0duBOE7GmTkhkd9+sDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/508] selftests/powerpc: Re-order *FLAGS to follow lib.mk
Date: Wed, 20 May 2026 18:17:47 +0200
Message-ID: <20260520162059.549030047@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Madhavan Srinivasan <maddy@linux.ibm.com>

[ Upstream commit 37496845c812db2a470d51088a59ee38156e8058 ]

In some powerpc/ sub-folder Makefiles, CFLAGS are defined before lib.mk
include. Clean it up by re-ordering the flags to follow after the mk
include. This is needed to support sub-folders in powerpc/ buildable on
its own.

Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240229093711.581230-1-maddy@linux.ibm.com
Stable-dep-of: 6e65886fceb2 ("selftests/powerpc: Suppress -Wmaybe-uninitialized with GCC 15")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/powerpc/benchmarks/Makefile     |  4 ++--
 .../selftests/powerpc/copyloops/Makefile      | 20 +++++++++----------
 .../selftests/powerpc/nx-gzip/Makefile        |  4 ++--
 .../selftests/powerpc/pmu/ebb/Makefile        | 20 +++++++++----------
 .../powerpc/pmu/event_code_tests/Makefile     |  4 ++--
 .../powerpc/pmu/sampling_tests/Makefile       |  4 ++--
 .../selftests/powerpc/primitives/Makefile     |  4 ++--
 .../selftests/powerpc/security/Makefile       |  4 ++--
 .../testing/selftests/powerpc/signal/Makefile |  3 ++-
 .../selftests/powerpc/stringloops/Makefile    | 10 +++++-----
 .../selftests/powerpc/switch_endian/Makefile  |  4 ++--
 .../selftests/powerpc/syscalls/Makefile       |  4 ++--
 tools/testing/selftests/powerpc/vphn/Makefile |  4 ++--
 13 files changed, 45 insertions(+), 44 deletions(-)

diff --git a/tools/testing/selftests/powerpc/benchmarks/Makefile b/tools/testing/selftests/powerpc/benchmarks/Makefile
index a32a6ab899144..75f5232c3aeca 100644
--- a/tools/testing/selftests/powerpc/benchmarks/Makefile
+++ b/tools/testing/selftests/powerpc/benchmarks/Makefile
@@ -4,11 +4,11 @@ TEST_GEN_FILES := exec_target
 
 TEST_FILES := settings
 
-CFLAGS += -O2
-
 top_srcdir = ../../../../..
 include ../../lib.mk
 
+CFLAGS += -O2
+
 $(TEST_GEN_PROGS): ../harness.c
 
 $(OUTPUT)/context_switch: ../utils.c
diff --git a/tools/testing/selftests/powerpc/copyloops/Makefile b/tools/testing/selftests/powerpc/copyloops/Makefile
index 77594e697f2fa..72684ed589c0a 100644
--- a/tools/testing/selftests/powerpc/copyloops/Makefile
+++ b/tools/testing/selftests/powerpc/copyloops/Makefile
@@ -1,14 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-# The loops are all 64-bit code
-CFLAGS += -m64
-CFLAGS += -I$(CURDIR)
-CFLAGS += -D SELFTEST
-CFLAGS += -maltivec
-CFLAGS += -mcpu=power4
-
-# Use our CFLAGS for the implicit .S rule & set the asm machine type
-ASFLAGS = $(CFLAGS) -Wa,-mpower4
-
 TEST_GEN_PROGS := copyuser_64_t0 copyuser_64_t1 copyuser_64_t2 \
 		copyuser_p7_t0 copyuser_p7_t1 \
 		memcpy_64_t0 memcpy_64_t1 memcpy_64_t2 \
@@ -21,6 +11,16 @@ EXTRA_SOURCES := validate.c ../harness.c stubs.S
 top_srcdir = ../../../../..
 include ../../lib.mk
 
+# The loops are all 64-bit code
+CFLAGS += -m64
+CFLAGS += -I$(CURDIR)
+CFLAGS += -D SELFTEST
+CFLAGS += -maltivec
+CFLAGS += -mcpu=power4
+
+# Use our CFLAGS for the implicit .S rule & set the asm machine type
+ASFLAGS = $(CFLAGS) -Wa,-mpower4
+
 $(OUTPUT)/copyuser_64_t%:	copyuser_64.S $(EXTRA_SOURCES)
 	$(CC) $(CPPFLAGS) $(CFLAGS) \
 		-D COPY_LOOP=test___copy_tofrom_user_base \
diff --git a/tools/testing/selftests/powerpc/nx-gzip/Makefile b/tools/testing/selftests/powerpc/nx-gzip/Makefile
index 0785c2e99d407..b40991f902b2c 100644
--- a/tools/testing/selftests/powerpc/nx-gzip/Makefile
+++ b/tools/testing/selftests/powerpc/nx-gzip/Makefile
@@ -1,8 +1,8 @@
-CFLAGS = -O3 -m64 -I./include -I../include
-
 TEST_GEN_FILES := gzfht_test gunz_test
 TEST_PROGS := nx-gzip-test.sh
 
 include ../../lib.mk
 
+CFLAGS = -O3 -m64 -I./include -I../include
+
 $(TEST_GEN_FILES): gzip_vas.c ../utils.c
diff --git a/tools/testing/selftests/powerpc/pmu/ebb/Makefile b/tools/testing/selftests/powerpc/pmu/ebb/Makefile
index 0101606902272..b3946ce17e0c1 100644
--- a/tools/testing/selftests/powerpc/pmu/ebb/Makefile
+++ b/tools/testing/selftests/powerpc/pmu/ebb/Makefile
@@ -4,16 +4,6 @@ include ../../../../../build/Build.include
 noarg:
 	$(MAKE) -C ../../
 
-# The EBB handler is 64-bit code and everything links against it
-CFLAGS += -m64
-
-TMPOUT = $(OUTPUT)/TMPDIR/
-# Toolchains may build PIE by default which breaks the assembly
-no-pie-option := $(call try-run, echo 'int main() { return 0; }' | \
-        $(CC) -Werror $(KBUILD_CPPFLAGS) $(CC_OPTION_CFLAGS) -no-pie -x c - -o "$$TMP", -no-pie)
-
-LDFLAGS += $(no-pie-option)
-
 TEST_GEN_PROGS := reg_access_test event_attributes_test cycles_test	\
 	 cycles_with_freeze_test pmc56_overflow_test		\
 	 ebb_vs_cpu_event_test cpu_event_vs_ebb_test		\
@@ -29,6 +19,16 @@ TEST_GEN_PROGS := reg_access_test event_attributes_test cycles_test	\
 top_srcdir = ../../../../../..
 include ../../../lib.mk
 
+# The EBB handler is 64-bit code and everything links against it
+CFLAGS += -m64
+
+TMPOUT = $(OUTPUT)/TMPDIR/
+# Toolchains may build PIE by default which breaks the assembly
+no-pie-option := $(call try-run, echo 'int main() { return 0; }' | \
+        $(CC) -Werror $(KBUILD_CPPFLAGS) $(CC_OPTION_CFLAGS) -no-pie -x c - -o "$$TMP", -no-pie)
+
+LDFLAGS += $(no-pie-option)
+
 $(TEST_GEN_PROGS): ../../harness.c ../../utils.c ../event.c ../lib.c \
 	       ebb.c ebb_handler.S trace.c busy_loop.S
 
diff --git a/tools/testing/selftests/powerpc/pmu/event_code_tests/Makefile b/tools/testing/selftests/powerpc/pmu/event_code_tests/Makefile
index 4e07d70464574..509d4b235b9e5 100644
--- a/tools/testing/selftests/powerpc/pmu/event_code_tests/Makefile
+++ b/tools/testing/selftests/powerpc/pmu/event_code_tests/Makefile
@@ -1,6 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -m64
-
 TEST_GEN_PROGS := group_constraint_pmc56_test group_pmc56_exclude_constraints_test group_constraint_pmc_count_test \
 	group_constraint_repeat_test group_constraint_radix_scope_qual_test reserved_bits_mmcra_sample_elig_mode_test \
 	group_constraint_mmcra_sample_test invalid_event_code_test reserved_bits_mmcra_thresh_ctl_test \
@@ -12,4 +10,6 @@ TEST_GEN_PROGS := group_constraint_pmc56_test group_pmc56_exclude_constraints_te
 top_srcdir = ../../../../../..
 include ../../../lib.mk
 
+CFLAGS += -m64
+
 $(TEST_GEN_PROGS): ../../harness.c ../../utils.c ../event.c ../lib.c ../sampling_tests/misc.h ../sampling_tests/misc.c
diff --git a/tools/testing/selftests/powerpc/pmu/sampling_tests/Makefile b/tools/testing/selftests/powerpc/pmu/sampling_tests/Makefile
index 9e67351fb252b..d45892151e05d 100644
--- a/tools/testing/selftests/powerpc/pmu/sampling_tests/Makefile
+++ b/tools/testing/selftests/powerpc/pmu/sampling_tests/Makefile
@@ -1,6 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -m64
-
 TEST_GEN_PROGS := mmcr0_exceptionbits_test mmcr0_cc56run_test mmcr0_pmccext_test \
 		   mmcr0_pmcjce_test mmcr0_fc56_pmc1ce_test mmcr0_fc56_pmc56_test \
 		   mmcr1_comb_test mmcr2_l2l3_test mmcr2_fcs_fch_test \
@@ -12,4 +10,6 @@ TEST_GEN_PROGS := mmcr0_exceptionbits_test mmcr0_cc56run_test mmcr0_pmccext_test
 top_srcdir = ../../../../../..
 include ../../../lib.mk
 
+CFLAGS += -m64
+
 $(TEST_GEN_PROGS): ../../harness.c ../../utils.c ../event.c ../lib.c misc.c misc.h ../loop.S ../branch_loops.S
diff --git a/tools/testing/selftests/powerpc/primitives/Makefile b/tools/testing/selftests/powerpc/primitives/Makefile
index 9b9491a632136..6dc5c5a42ca95 100644
--- a/tools/testing/selftests/powerpc/primitives/Makefile
+++ b/tools/testing/selftests/powerpc/primitives/Makefile
@@ -1,9 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0-only
-CFLAGS += -I$(CURDIR)
-
 TEST_GEN_PROGS := load_unaligned_zeropad
 
 top_srcdir = ../../../../..
 include ../../lib.mk
 
+CFLAGS += -I$(CURDIR)
+
 $(TEST_GEN_PROGS): ../harness.c
diff --git a/tools/testing/selftests/powerpc/security/Makefile b/tools/testing/selftests/powerpc/security/Makefile
index e0d979ab02040..0a08386be9696 100644
--- a/tools/testing/selftests/powerpc/security/Makefile
+++ b/tools/testing/selftests/powerpc/security/Makefile
@@ -5,10 +5,10 @@ TEST_PROGS := mitigation-patching.sh
 
 top_srcdir = ../../../../..
 
-CFLAGS += $(KHDR_INCLUDES)
-
 include ../../lib.mk
 
+CFLAGS += $(KHDR_INCLUDES)
+
 $(TEST_GEN_PROGS): ../harness.c ../utils.c
 
 $(OUTPUT)/spectre_v2: CFLAGS += -m64
diff --git a/tools/testing/selftests/powerpc/signal/Makefile b/tools/testing/selftests/powerpc/signal/Makefile
index f679d260afc87..b15d5dbccc24b 100644
--- a/tools/testing/selftests/powerpc/signal/Makefile
+++ b/tools/testing/selftests/powerpc/signal/Makefile
@@ -3,7 +3,6 @@ TEST_GEN_PROGS := signal signal_tm sigfuz sigreturn_vdso sig_sc_double_restart
 TEST_GEN_PROGS += sigreturn_kernel
 TEST_GEN_PROGS += sigreturn_unaligned
 
-CFLAGS += -maltivec
 $(OUTPUT)/signal_tm: CFLAGS += -mhtm
 $(OUTPUT)/sigfuz: CFLAGS += -pthread -m64
 
@@ -12,4 +11,6 @@ TEST_FILES := settings
 top_srcdir = ../../../../..
 include ../../lib.mk
 
+CFLAGS += -maltivec
+
 $(TEST_GEN_PROGS): ../harness.c ../utils.c signal.S
diff --git a/tools/testing/selftests/powerpc/stringloops/Makefile b/tools/testing/selftests/powerpc/stringloops/Makefile
index 9c39f55a58ff3..87c8c8f238daa 100644
--- a/tools/testing/selftests/powerpc/stringloops/Makefile
+++ b/tools/testing/selftests/powerpc/stringloops/Makefile
@@ -1,7 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-# The loops are all 64-bit code
-CFLAGS += -I$(CURDIR)
-
 EXTRA_SOURCES := ../harness.c
 
 build_32bit = $(shell if ($(CC) $(CFLAGS) -m32 -o /dev/null memcmp.c >/dev/null 2>&1) then echo "1"; fi)
@@ -27,9 +24,12 @@ $(OUTPUT)/strlen_32: CFLAGS += -m32
 TEST_GEN_PROGS += strlen_32
 endif
 
-ASFLAGS = $(CFLAGS)
-
 top_srcdir = ../../../../..
 include ../../lib.mk
 
+# The loops are all 64-bit code
+CFLAGS += -I$(CURDIR)
+
+ASFLAGS = $(CFLAGS)
+
 $(TEST_GEN_PROGS): $(EXTRA_SOURCES)
diff --git a/tools/testing/selftests/powerpc/switch_endian/Makefile b/tools/testing/selftests/powerpc/switch_endian/Makefile
index bdc081afedb0f..8f0c2a1d3333b 100644
--- a/tools/testing/selftests/powerpc/switch_endian/Makefile
+++ b/tools/testing/selftests/powerpc/switch_endian/Makefile
@@ -1,13 +1,13 @@
 # SPDX-License-Identifier: GPL-2.0
 TEST_GEN_PROGS := switch_endian_test
 
-ASFLAGS += -O2 -Wall -g -nostdlib -m64
-
 EXTRA_CLEAN = $(OUTPUT)/*.o $(OUTPUT)/check-reversed.S
 
 top_srcdir = ../../../../..
 include ../../lib.mk
 
+ASFLAGS += -O2 -Wall -g -nostdlib -m64
+
 $(OUTPUT)/switch_endian_test: ASFLAGS += -I $(OUTPUT)
 $(OUTPUT)/switch_endian_test: $(OUTPUT)/check-reversed.S
 
diff --git a/tools/testing/selftests/powerpc/syscalls/Makefile b/tools/testing/selftests/powerpc/syscalls/Makefile
index ee1740ddfb0c2..83dc335007732 100644
--- a/tools/testing/selftests/powerpc/syscalls/Makefile
+++ b/tools/testing/selftests/powerpc/syscalls/Makefile
@@ -1,9 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0-only
 TEST_GEN_PROGS := ipc_unmuxed rtas_filter
 
-CFLAGS += $(KHDR_INCLUDES)
-
 top_srcdir = ../../../../..
 include ../../lib.mk
 
+CFLAGS += $(KHDR_INCLUDES)
+
 $(TEST_GEN_PROGS): ../harness.c ../utils.c
diff --git a/tools/testing/selftests/powerpc/vphn/Makefile b/tools/testing/selftests/powerpc/vphn/Makefile
index cf65cbf33085a..ddc09a20b80fb 100644
--- a/tools/testing/selftests/powerpc/vphn/Makefile
+++ b/tools/testing/selftests/powerpc/vphn/Makefile
@@ -1,10 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
 TEST_GEN_PROGS := test-vphn
 
-CFLAGS += -m64 -I$(CURDIR)
-
 top_srcdir = ../../../../..
 include ../../lib.mk
 
+CFLAGS += -m64 -I$(CURDIR)
+
 $(TEST_GEN_PROGS): ../harness.c
 
-- 
2.53.0



