Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032901;
	b=LNumNplodUGDiHqxlNgh+8EI7u7KsH/4IG1ckhyIdacXAehEVe9dBBaZo/Iug5ifuRMS
	 RIoCBxba6FsGQhlO3nPjcCAMcBRlWH1nmdHFkyLsjXksmoNq+8m6KIlE+jXmizoaT8vdc
	 YWHaLMmPa4y/5HBvkuZ1AjQ+tQ500v35sLNgJpw1WKy7QNN44t3Ck6BGsCr9VElyXvmMX
	 1ubJ4OhL7OusIxt1OBKu62Wa8zMQEQSMAod5TnfTJo5mNEpPRovqlA+wYYQOrjKojUFdr
	 LhHzRbTF3I7FVYBeyGT8hdgIh+LC/9xVR9rvP5oe0KFDSzqJNYO61pQTdIBr2uHldDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=51bNGf+4PjElyu2FDMxClUl2V1xUHeA+pqVWnkyOB+s=;
	b=pHOt/tP1S+ICUxJh+C7ivH69byVFCN/7USAdV2d628tcevJmtA3N8oLclBeaV/Jl0Hrz
	 a7Cpas1mo+MIQ51essJjfpBdhO9peY7KxGEV0T/OJ/vSMAWlo3vw/KzDhL39f9oTpJaNx
	 PT2UpBU6W47Rb23S7z8DylraVz10EwX50i+duvreU8B23pdI5spep9BOsuGnU0XJ/mNNe
	 3jL12pS3ZF55ItevKAkSU4a00T2vPHsKQ0f00qOk8SqO8C0wpeWKck/SS/CFrhjeaFfjr
	 fjX5Vm0If8Ik20IrH4j7XD2PxI8e6u/Ei0EeZLMHAx6RWRzIKtCNSUPupMjq0zKG60w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LsQds7Zo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727F660A2602;
	Wed, 18 Nov 2026 20:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LsQds7Zo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935D21F000C4;
	Wed, 18 Nov 2026 20:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032901;
	bh=51bNGf+4PjElyu2FDMxClUl2V1xUHeA+pqVWnkyOB+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LsQds7Zo0yUsnNSnINum70Nu5YBUGorjuTdkFhz7QDk8wSiNgx/9QQpoXzHaHeN+l
	 KXX2e0eqjCgmKiyg0NWhPADcj8ZiL8g7hONI/yKHgZMDqQUTOCyKLyQ8YTkinWiVwW
	 9oOlsXZaYVF/AqdkLJrAULKKtjauIZkcxEQNz9Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksei Oladko <aleksey.oladko@virtuozzo.com>,
	Shuah Khan <shuah@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>,
	Chelsy Ratnawat <chelsyratnawat2001@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1576/1756] selftests: fix ARCH normalization to handle command-line argument
Date: Wed, 18 Nov 2026 16:01:43 +0100
Message-ID: <20261118150112.499870451@linuxfoundation.org>
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

From: Aleksei Oladko <aleksey.oladko@virtuozzo.com>

[ Upstream commit 5a1292137e89c8c4b12076b17427eb00f788a4ed ]

Several selftests Makefiles (e.g.  prctl, breakpoints, etc) attempt to
normalize the ARCH variable by converting x86_64 and i.86 to x86.
However, it uses the conditional assignment operator '?='.

When ARCH is passed as a command-line argument (e.g., during an rpmbuild
process), the '?=' operator ignores the shell command and the sed
transformation.  This leads to an incorrect ARCH value being used, which
causes build failures

  # make -C tools/testing/selftests TARGETS=prctl ARCH=x86_64
  make: Entering directory '/build/tools/testing/selftests'
  make[1]: Entering directory '/build/tools/testing/selftests/prctl'
  make[1]: *** No targets.  Stop.
  make[1]: Leaving directory '/build/tools/testing/selftests/prctl'
  make: *** [Makefile:197: all] Error 2

Change the assignment to use 'override' and ':=' to ensure the
normalization logic is applied regardless of how the ARCH variable was
initially defined.

Link: https://lkml.kernel.org/r/20260309205145.572778-1-aleksey.oladko@virtuozzo.com
Signed-off-by: Aleksei Oladko <aleksey.oladko@virtuozzo.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Cc: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: ff4194e54f84 ("selftests/thermal: allow cross builds of the Intel tests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/breakpoints/Makefile              | 4 ++--
 tools/testing/selftests/ipc/Makefile                      | 8 ++++----
 tools/testing/selftests/prctl/Makefile                    | 4 ++--
 tools/testing/selftests/sparc64/Makefile                  | 4 ++--
 .../testing/selftests/thermal/intel/power_floor/Makefile  | 4 ++--
 .../selftests/thermal/intel/workload_hint/Makefile        | 4 ++--
 6 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/breakpoints/Makefile b/tools/testing/selftests/breakpoints/Makefile
index 9ec2c78de8caa..0b8f5acf7c78f 100644
--- a/tools/testing/selftests/breakpoints/Makefile
+++ b/tools/testing/selftests/breakpoints/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 # Taken from perf makefile
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
+ARCH ?= $(shell uname -m 2>/dev/null || echo not)
+override ARCH := $(shell echo $(ARCH) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
 
 TEST_GEN_PROGS := step_after_suspend_test
 
diff --git a/tools/testing/selftests/ipc/Makefile b/tools/testing/selftests/ipc/Makefile
index 50e9c299fc4ae..fad10f2bb57b0 100644
--- a/tools/testing/selftests/ipc/Makefile
+++ b/tools/testing/selftests/ipc/Makefile
@@ -1,12 +1,12 @@
 # SPDX-License-Identifier: GPL-2.0
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
+ARCH ?= $(shell uname -m 2>/dev/null || echo not)
+override ARCH := $(shell echo $(ARCH) | sed -e s/i.86/i386/)
 ifeq ($(ARCH),i386)
-        ARCH := x86
+        override ARCH := x86
 	CFLAGS := -DCONFIG_X86_32 -D__i386__
 endif
 ifeq ($(ARCH),x86_64)
-	ARCH := x86
+        override ARCH := x86
 	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
 endif
 
diff --git a/tools/testing/selftests/prctl/Makefile b/tools/testing/selftests/prctl/Makefile
index 01dc90fbb5094..e770e86fad9ac 100644
--- a/tools/testing/selftests/prctl/Makefile
+++ b/tools/testing/selftests/prctl/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 ifndef CROSS_COMPILE
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
+ARCH ?= $(shell uname -m 2>/dev/null || echo not)
+override ARCH := $(shell echo $(ARCH) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
 
 ifeq ($(ARCH),x86)
 TEST_PROGS := disable-tsc-ctxt-sw-stress-test disable-tsc-on-off-stress-test \
diff --git a/tools/testing/selftests/sparc64/Makefile b/tools/testing/selftests/sparc64/Makefile
index a19531dba4dc3..88f7be76f962d 100644
--- a/tools/testing/selftests/sparc64/Makefile
+++ b/tools/testing/selftests/sparc64/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/x86_64/x86/)
+ARCH ?= $(shell uname -m 2>/dev/null || echo not)
+override ARCH := $(shell echo $(ARCH) | sed -e s/x86_64/x86/)
 
 ifneq ($(ARCH),sparc64)
 nothing:
diff --git a/tools/testing/selftests/thermal/intel/power_floor/Makefile b/tools/testing/selftests/thermal/intel/power_floor/Makefile
index 9b88e57dbba5a..07463c2160e09 100644
--- a/tools/testing/selftests/thermal/intel/power_floor/Makefile
+++ b/tools/testing/selftests/thermal/intel/power_floor/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 ifndef CROSS_COMPILE
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
+ARCH ?= $(shell uname -m 2>/dev/null || echo not)
+override ARCH := $(shell echo $(ARCH) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
 
 ifeq ($(ARCH),x86)
 TEST_GEN_PROGS := power_floor_test
diff --git a/tools/testing/selftests/thermal/intel/workload_hint/Makefile b/tools/testing/selftests/thermal/intel/workload_hint/Makefile
index 37ff3286283b6..49e3bc2b20f9d 100644
--- a/tools/testing/selftests/thermal/intel/workload_hint/Makefile
+++ b/tools/testing/selftests/thermal/intel/workload_hint/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 ifndef CROSS_COMPILE
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
+ARCH ?= $(shell uname -m 2>/dev/null || echo not)
+override ARCH := $(shell echo $(ARCH) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
 
 ifeq ($(ARCH),x86)
 TEST_GEN_PROGS := workload_hint_test
-- 
2.53.0



