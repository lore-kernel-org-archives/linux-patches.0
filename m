Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021797;
	b=dCyPrgnTTcuLneL39y0GSyv+44PudLXtWdmvAyml25Dh8jM/aBFzrj6JGklZbuWgBgXY
	 c13NxVfMFEDtO+mBnrMzRw58KQJOLSo9qXqONVHwzrfSaHamPFtZa8g1OdL7F9jn8iNqa
	 ENWVA93K8kVi7TJDysGhOVQGDd8CDnFHvxsnvNkG7Xx5OCPrp0tqFiIxxdCFeJEc3MOZ8
	 V2Bl0K9iQGHTSfXYTdbzjI9Q6xIc9icBiCDJ/poiO04UnweLQmB/M1PTMzxr+I9F1xm5b
	 59BlvZGNDIhtOm2LC7fbPqsM0tkl35g3M4uS59ejTSWXUhwVrfH+6bu5eN/Ta3rkGIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xli92eQFlYrM8QqaWCwc8jQlJ2GKyyXQJCmhM3Lsgm4=;
	b=fk+Sh1WXz6sZcqtLpgIwxU3ctPmVPkTLux+Ej84VXXyNnKAUarYFNLqdsQtaDAYAQrpN
	 BFKDKmU4mVJp6Zvx0pv29xLD6arxpCQarCh5oJfWr0+VjXuprae6erUWfhI3dSHN8+FiA
	 f5fw9jcMpPVk2p7c7jINlAw+xqU5aSL8lWGMLlrJ0tvkakXe6KUKIkCEdyhn2IygwaNKH
	 WtyRFGxvfBt7v21zS5QNrIlatjblV+kWbA4CcnLj9Q5cEj3hqrfG7s1KvPu+qFiFQG0WX
	 s7VwM2mthNKV4W+nbskPnEJCvOiMmF7kwqTOzeu9ECvRsz9k2v0lRcb6ko/+jMA9vpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DeFwmyEO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E9E606A33B;
	Wed, 18 Nov 2026 17:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DeFwmyEO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F621F000C4;
	Wed, 18 Nov 2026 17:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021796;
	bh=Xli92eQFlYrM8QqaWCwc8jQlJ2GKyyXQJCmhM3Lsgm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DeFwmyEO90zQlMm26PP6eURgJEbyyZ11K7URajc3gGYa5+QV8YPZOFNBH2uyRtRfo
	 A1uAtgqZp2yS2JvbtTt6VfnB7yNlJGnEUNda9hCDXmeHSq8AxF4K7M3TIOZfDzOA4o
	 U2JR+Ts+VCC1NhgNnd5w8Q92BoY8YFd805nLS5+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.3 2433/2651] selftests/thermal: allow cross builds of the Intel tests
Date: Wed, 18 Nov 2026 16:01:13 +0100
Message-ID: <20261118150412.787193451@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit ff4194e54f840b4df4eb2489c63ee88283895efc ]

The power_floor and workload_hint Makefiles build nothing when
CROSS_COMPILE is set, even for an x86 target, and they include lib.mk
only on x86. Other architectures therefore have no install or
emit_tests rules for these suites, and their installation fails with a
missing target.

Select the x86 tests from the target ARCH when it is given and from the
host's SUBARCH otherwise, and include lib.mk unconditionally so that the
suites install and emit an empty runlist on other architectures. Use a
private ARCH_PROCESSED instead of the ARCH override added by
commit 5a1292137e89 ("selftests: fix ARCH normalization to handle
command-line argument"): the override changed the value lib.mk uses to
pick the clang target, whereas leaving ARCH unset lets lib.mk use the
compiler's native triple. A command-line ARCH such as x86_64 is still
normalized for the selection, while an ARCH spelling that lib.mk does
not know, such as i686 with LLVM=1, is rejected as in other selftests.

Fixes: 27801542b2b8 ("selftests/thermel/intel: Add test to read workload hint")
Fixes: d4d27e5a1a88 ("selftests/thermel/intel: Add test to read power floor status")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Link: https://patch.msgid.link/20261014200127.1363472-4-sashal@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/thermal/intel/power_floor/Makefile     | 12 +++++-------
 .../selftests/thermal/intel/workload_hint/Makefile   | 12 +++++-------
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/thermal/intel/power_floor/Makefile b/tools/testing/selftests/thermal/intel/power_floor/Makefile
index 07463c2160e09..16d26eab55652 100644
--- a/tools/testing/selftests/thermal/intel/power_floor/Makefile
+++ b/tools/testing/selftests/thermal/intel/power_floor/Makefile
@@ -1,12 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
-ifndef CROSS_COMPILE
-ARCH ?= $(shell uname -m 2>/dev/null || echo not)
-override ARCH := $(shell echo $(ARCH) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
+top_srcdir = ../../../../../..
+include $(top_srcdir)/scripts/subarch.include
+ARCH_PROCESSED := $(shell echo $(or $(ARCH),$(SUBARCH)) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
 
-ifeq ($(ARCH),x86)
+ifeq ($(ARCH_PROCESSED),x86)
 TEST_GEN_PROGS := power_floor_test
+endif
 
 include ../../../lib.mk
-
-endif
-endif
diff --git a/tools/testing/selftests/thermal/intel/workload_hint/Makefile b/tools/testing/selftests/thermal/intel/workload_hint/Makefile
index 49e3bc2b20f9d..e53d6ecd9f8de 100644
--- a/tools/testing/selftests/thermal/intel/workload_hint/Makefile
+++ b/tools/testing/selftests/thermal/intel/workload_hint/Makefile
@@ -1,12 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
-ifndef CROSS_COMPILE
-ARCH ?= $(shell uname -m 2>/dev/null || echo not)
-override ARCH := $(shell echo $(ARCH) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
+top_srcdir = ../../../../../..
+include $(top_srcdir)/scripts/subarch.include
+ARCH_PROCESSED := $(shell echo $(or $(ARCH),$(SUBARCH)) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
 
-ifeq ($(ARCH),x86)
+ifeq ($(ARCH_PROCESSED),x86)
 TEST_GEN_PROGS := workload_hint_test
+endif
 
 include ../../../lib.mk
-
-endif
-endif
-- 
2.53.0



