Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040672;
	b=pZV11AaskuBlek4YY5P029xDn3YxwoO/VIKpPP6LHJccG3pzIXHKB0dTHG6q4FJPYdw/
	 FZh+HuyoiIX1qHJzChyy5Yf7rtWHAwBQpexUlAWVyhuu15d0wKW1EJbSJMg3RuvAghLud
	 /ZUKOqxRA0Hy3ZYnQr0lRfXe03KWoRVatEiqf6wVYLOWofrNU5MJuavDmJrlITKEmrnk1
	 AyDpYqpPgUzy1a9Qz6Q9n0MdFA1TS+hpkrvXCJ4rtav8tqF6A/g0gWWnTKmAhno7bgJ/r
	 i016oAyQNgWwEhRmKYJv0IPmkDsJ0cBtAaKZ4nZsjJDd2KaAYuL5e/dhIPH3fnJB1ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h3TYMBypEjZHiJN8do1GJdLZAJV5EiTiPALHXHEvK8g=;
	b=0MZuPJ9yRN2ix4A/aZ37cmV7+7kzJJM+cZOak7WX5gFUewJqdrxXGt8oVjuT/R5ATIlt
	 4g2C42UAtlHNcC2jW8a1W8+TIIsqchG480h/iOqj9COciB/s1ftj9ss0gFfVMkce+nPOA
	 M9MqHKT7E7JSp+h/uIb+nBKiai24+4GbaHI9LBgKclFOG3VqqRULrxGIf/wZLkEUXgZ6p
	 xcs5HuZh+fYWWmjA6/s4KeyBymq8stmw6pwMGzTNg5q5gcXuM/DLPFs1dyJFw/g8Z/OFj
	 N+haMVjQmFXsz/Ff8J8oRjHvM6FNRZrl6Wma9utHqtVxWFeVn2Oo3tH40tTDnDfwF6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nFt2zsE3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C00606A32C;
	Wed, 18 Nov 2026 22:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nFt2zsE3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B191F000C4;
	Wed, 18 Nov 2026 22:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040671;
	bh=h3TYMBypEjZHiJN8do1GJdLZAJV5EiTiPALHXHEvK8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFt2zsE3YEaBlr/MRbsFSeS2wV7r1N+5Th9XVXPrDJ7kyOTfsvwnB4fqZYXa+O4pm
	 gbUMybcx/VI/5tkR7N6+vdyK6yY5jtFD1XiE7vH6Uara1t6Wv6KQp9IWqj/UemABCt
	 1PfPIvzh6HvPrwWSRW7Jf9WQv/b/hWjrlmZ/1BB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2501/3318] cpufreq: amd-pstate: remove global header file
Date: Wed, 18 Nov 2026 15:52:03 +0100
Message-ID: <20261118150436.415376894@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 779b8a14afde110dd3502566be907289eba72447 ]

When extra warnings are enabled, gcc points out a global variable
definition in a header:

In file included from drivers/cpufreq/amd-pstate-ut.c:29:
include/linux/amd-pstate.h:123:27: error: 'amd_pstate_mode_string' defined but not used [-Werror=unused-const-variable=]
  123 | static const char * const amd_pstate_mode_string[] = {
      |                           ^~~~~~~~~~~~~~~~~~~~~~

This header is only included from two files in the same directory,
and one of them uses only a single definition from it, so clean it
up by moving most of the contents into the driver that uses them,
and making shared bits a local header file.

Fixes: 36c5014e5460 ("cpufreq: amd-pstate: optimize driver working mode selection in amd_pstate_param()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: f6d3cbc63935 ("cpufreq: amd-pstate: Restore previous mode when changing driver mode fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS                                   |  1 -
 drivers/cpufreq/amd-pstate-ut.c               |  3 +-
 drivers/cpufreq/amd-pstate.c                  | 34 ++++++++++++++++++-
 .../linux => drivers/cpufreq}/amd-pstate.h    | 33 ------------------
 4 files changed, 35 insertions(+), 36 deletions(-)
 rename {include/linux => drivers/cpufreq}/amd-pstate.h (81%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3a53278fc42e6..d5d62b56aace8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1040,7 +1040,6 @@ L:	linux-pm@vger.kernel.org
 S:	Supported
 F:	Documentation/admin-guide/pm/amd-pstate.rst
 F:	drivers/cpufreq/amd-pstate*
-F:	include/linux/amd-pstate.h
 F:	tools/power/x86/amd_pstate_tracer/amd_pstate_trace.py
 
 AMD PTDMA DRIVER
diff --git a/drivers/cpufreq/amd-pstate-ut.c b/drivers/cpufreq/amd-pstate-ut.c
index f04ae67dda372..fc275d41d51e9 100644
--- a/drivers/cpufreq/amd-pstate-ut.c
+++ b/drivers/cpufreq/amd-pstate-ut.c
@@ -26,10 +26,11 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/fs.h>
-#include <linux/amd-pstate.h>
 
 #include <acpi/cppc_acpi.h>
 
+#include "amd-pstate.h"
+
 /*
  * Abbreviations:
  * amd_pstate_ut: used as a shortform for AMD P-State unit test.
diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 34f330b5ad0de..803079b7e8193 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -36,7 +36,6 @@
 #include <linux/delay.h>
 #include <linux/uaccess.h>
 #include <linux/static_call.h>
-#include <linux/amd-pstate.h>
 #include <linux/topology.h>
 
 #include <acpi/processor.h>
@@ -46,6 +45,8 @@
 #include <asm/processor.h>
 #include <asm/cpufeature.h>
 #include <asm/cpu_device_id.h>
+
+#include "amd-pstate.h"
 #include "amd-pstate-trace.h"
 
 #define AMD_PSTATE_TRANSITION_LATENCY	20000
@@ -53,6 +54,37 @@
 #define CPPC_HIGHEST_PERF_PERFORMANCE	196
 #define CPPC_HIGHEST_PERF_DEFAULT	166
 
+#define AMD_CPPC_EPP_PERFORMANCE		0x00
+#define AMD_CPPC_EPP_BALANCE_PERFORMANCE	0x80
+#define AMD_CPPC_EPP_BALANCE_POWERSAVE		0xBF
+#define AMD_CPPC_EPP_POWERSAVE			0xFF
+
+/*
+ * enum amd_pstate_mode - driver working mode of amd pstate
+ */
+enum amd_pstate_mode {
+	AMD_PSTATE_UNDEFINED = 0,
+	AMD_PSTATE_DISABLE,
+	AMD_PSTATE_PASSIVE,
+	AMD_PSTATE_ACTIVE,
+	AMD_PSTATE_GUIDED,
+	AMD_PSTATE_MAX,
+};
+
+static const char * const amd_pstate_mode_string[] = {
+	[AMD_PSTATE_UNDEFINED]   = "undefined",
+	[AMD_PSTATE_DISABLE]     = "disable",
+	[AMD_PSTATE_PASSIVE]     = "passive",
+	[AMD_PSTATE_ACTIVE]      = "active",
+	[AMD_PSTATE_GUIDED]      = "guided",
+	NULL,
+};
+
+struct quirk_entry {
+	u32 nominal_freq;
+	u32 lowest_freq;
+};
+
 /*
  * TODO: We need more time to fine tune processors with shared memory solution
  * with community together.
diff --git a/include/linux/amd-pstate.h b/drivers/cpufreq/amd-pstate.h
similarity index 81%
rename from include/linux/amd-pstate.h
rename to drivers/cpufreq/amd-pstate.h
index 7b2cbb892fd91..bc341f35908d7 100644
--- a/include/linux/amd-pstate.h
+++ b/drivers/cpufreq/amd-pstate.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * linux/include/linux/amd-pstate.h
- *
  * Copyright (C) 2022 Advanced Micro Devices, Inc.
  *
  * Author: Meng Li <li.meng@amd.com>
@@ -12,11 +10,6 @@
 
 #include <linux/pm_qos.h>
 
-#define AMD_CPPC_EPP_PERFORMANCE		0x00
-#define AMD_CPPC_EPP_BALANCE_PERFORMANCE	0x80
-#define AMD_CPPC_EPP_BALANCE_POWERSAVE		0xBF
-#define AMD_CPPC_EPP_POWERSAVE			0xFF
-
 /*********************************************************************
  *                        AMD P-state INTERFACE                       *
  *********************************************************************/
@@ -104,30 +97,4 @@ struct amd_cpudata {
 	bool	suspended;
 };
 
-/*
- * enum amd_pstate_mode - driver working mode of amd pstate
- */
-enum amd_pstate_mode {
-	AMD_PSTATE_UNDEFINED = 0,
-	AMD_PSTATE_DISABLE,
-	AMD_PSTATE_PASSIVE,
-	AMD_PSTATE_ACTIVE,
-	AMD_PSTATE_GUIDED,
-	AMD_PSTATE_MAX,
-};
-
-static const char * const amd_pstate_mode_string[] = {
-	[AMD_PSTATE_UNDEFINED]   = "undefined",
-	[AMD_PSTATE_DISABLE]     = "disable",
-	[AMD_PSTATE_PASSIVE]     = "passive",
-	[AMD_PSTATE_ACTIVE]      = "active",
-	[AMD_PSTATE_GUIDED]      = "guided",
-	NULL,
-};
-
-struct quirk_entry {
-	u32 nominal_freq;
-	u32 lowest_freq;
-};
-
 #endif /* _LINUX_AMD_PSTATE_H */
-- 
2.53.0



