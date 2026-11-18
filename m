Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028042;
	b=qwny4qKOKBTGxdNcC84h1GddQX00bGmHfsMBZrV0e8AJYRBG5gt7hWrgBC6VPnOU2Xwo
	 pecudDaX6q+Cw3G/n2KxorKuHZfqq0Ku7OgK5RZEfwVNx+Q5Fa7NcmDt2KqJ4+32P4a3o
	 MV7NHiGuWJ+E3aA8XMlN9YIn/YphMyWBiPA6i9eG6WZMw+9vELxSpumSRYriT/Kz8ORH9
	 HYctGzJK4sghkeNQWtu+LBN6XrxBG9Y3apCouSyQ+uAu6U14pvgVtFGrWyqy3xw8zFYSn
	 VVuYw0Je2NeaHTk4d4tX1lNhVB/dxkM1IrE2uYF93RrZuC6hOVIq2APgRPZGEvxTqFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h+Ythhywqhyjgp8zI93095Jnp1u6JAwIRwb7bUhJ9/M=;
	b=ES28Hn5V/BOM7RAfPFgJc4t6OUUwoZP6/aHDbg+1pfuuORfAOKpHhJqeC+lCLUCYhLcC
	 tEuYT+j6aRxd8cFK09c477Vzg1MKkou04DcY9JAN4fnUQWPdsUnS69CK0ZeJ/83jf1JQH
	 CoZiTXorCPnCPg79yLg2RqHI0iyrWHqf0mVUKxqiR0gFFxYAtyI9LVnlp9xCoP/iL73GI
	 SNCJtVgLRQl5J88cqpz+41o+Xl1VUJ2d1AOeVJfMJooI3MJ8Gbw0uaDifh4k3505oODOy
	 uY74hfZKqhl45zWDV26sJVE1HErW+Fqtfe32zT6wlNN4Vzt7fdlhdoUoHXuWSnbAyxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oj5TFbQh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793C1606A31C;
	Wed, 18 Nov 2026 18:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oj5TFbQh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9EF1F000C5;
	Wed, 18 Nov 2026 18:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028042;
	bh=h+Ythhywqhyjgp8zI93095Jnp1u6JAwIRwb7bUhJ9/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oj5TFbQh5QPNm/WrikD9uOYilN4sIQ9KxTmfU7w3+gCH/H8lon6Oaduz/vYCh+hr7
	 SyNFKSDwpv0PKRyJdGS8rP+CMhFch4nr/pC4AtZkDYpdly4S31DoXFW1pB+336fNB0
	 RgucDEtVvYWcsFOmbSisQLLs+w77WgNXlFsII3zY=
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
Subject: [PATCH 6.18 1963/2151] selftests: fix ARCH normalization to handle command-line argument
Date: Wed, 18 Nov 2026 16:01:38 +0100
Message-ID: <20261118150233.261536649@linuxfoundation.org>
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



