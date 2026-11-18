Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027928;
	b=2WmmiKCGiT9fDXgGacCNts66gEWyNipRTI9YhEghtmEg+esKHhSudb9Q+VttkJ0O7MdG
	 HRMjODA5zQuSZ2cY6ncaW/gI3nU5cBA/jRAh5qF4sV92/4r0fbE4HTbPqSyYWJrOjE9H+
	 4VUoLPbakg/bQig6eda+pObx2IMRmobUgyWr5Qd4d71Kzi29/trYdvcau0DZxSXY3a55f
	 FMLqquvx4RJC9SCvKBdD0tUFFR3EaQXT5M11YGX/rVD72IDXkyc4WJl56CYmEO+RQd9GS
	 GrIuM0cXpNWsHnGhJQRTo+bwDNo9uI/yfZH8r/kS19FTHGLdBnengci8cV7uWbIN4sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6clbrUfLXIDVgyKY81Y56mkOWZrF9VHDxrMbRxKLuPI=;
	b=CWs1u8duBwsmU1mqfaZSrylppbcjDWZPC8YbnS8uqNzrChxiLG0fS27iN7KycveXu470
	 fIO3l2XblJfA4ff8qG2+ZzWkLBAggYrtADblXcPupzP+CLxx/JodPH+arFJmTJqhjk98j
	 e9o7KEWwtqGLs04EPiGtm/odTvboQuVJt0p7k2iXCdpG0QbDMi6QdrmeH/IM0lO2pXdF/
	 S0GRQdNbq2S8zfq4V3fGnH6ltCmF+hzME/eYXHYwjjbrViX4KNlEfJbRBu08JOFtcK5+n
	 sO3Ew88tLxwhyOQpQNtUTftG4ykxyQ/v+MTEuWrVcy0JTk22TCorpaJ+fp4MH+Z+pRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dhvbF2nj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B1E606A31C;
	Wed, 18 Nov 2026 18:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dhvbF2nj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983171F000C4;
	Wed, 18 Nov 2026 18:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027928;
	bh=6clbrUfLXIDVgyKY81Y56mkOWZrF9VHDxrMbRxKLuPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dhvbF2njSbYTw684SukNf/5Pu5t0MbMCG2+Y/dENhsGiDlbGKnIrKPjI5V71waK6f
	 s+9W379075p35sAAP0BvzdRrHmBD9tNhWjFlnj3UWXtNvylJMIvIcpinylr5mPWZQ7
	 MZe8EJ/UO2mtjZqNGK3hWfByJeF/2qXAlW6yQtb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 1964/2151] selftests/thermal: allow cross builds of the Intel tests
Date: Wed, 18 Nov 2026 16:01:39 +0100
Message-ID: <20261118150233.296345522@linuxfoundation.org>
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



