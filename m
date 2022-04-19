Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C4F1374
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 16:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650386349; x=1681922349;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3+cnaOKNg1DXMe24Z7ON6hVz8Ha5Eswt2xisuNXIrDk=;
  b=FLRr+RVGr3pFD1u5Ispr1UiQxVZkmT1wlwZtXHFppS345nOxcdRRScy8
   LB9kvBg5jUp24Al215v/ZtL4V+501HwYZyqRzlXoe5yv7P/SUfz6mFObW
   YF556ImVl2CsGgPkuUp9EjzyH/eEmBAmgz4cEJxNDwpyEafeDZ45+Mz/M
   MlLabT6rWeoJ+j9KWTFl5BLWhXjBstjY/cDsbDfPkVmvMF4gLduA/OJTa
   78OsviV+aqxbPQdhcp29X3dpOIk9O5p+EyTu4nFyh5yTUUePyedRPp87E
   2m8XDWs4wcyeODAiqYc757EaV9BiWSXBKLFZArIN83FQLuKa8+7/ayQ7S
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="244395689"
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="244395689"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 09:39:07 -0700
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="554802136"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 09:39:06 -0700
From: Tony Luck <tony.luck@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	corbet@lwn.net,
	gregkh@linuxfoundation.org,
	andriy.shevchenko@linux.intel.com,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	rostedt@goodmis.org,
	dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com
Subject: [PATCH v3 03/11] platform/x86/intel/ifs: Create device for Intel IFS (In Field Scan)
Date: Tue, 19 Apr 2022 09:38:51 -0700
Message-Id: <20220419163859.2228874-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419163859.2228874-1-tony.luck@intel.com>
References: <20220407191347.9681-1-jithu.joseph@intel.com>
 <20220419163859.2228874-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The initial implementation of IFS is model specific. Enumeration is
via a combination of family-model-stepping and a check for a bit in the
CORE_CAPABILITIES MSR.

Linux has handled this lack of enumeration before with a code stub to
create a device.  See arch/x86/kernel/pmem.c. Use the same approach
here.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 MAINTAINERS                                   |  7 +++
 drivers/platform/x86/intel/Kconfig            |  1 +
 drivers/platform/x86/intel/Makefile           |  1 +
 drivers/platform/x86/intel/ifs/Kconfig        |  2 +
 drivers/platform/x86/intel/ifs/Makefile       |  1 +
 .../platform/x86/intel/ifs/intel_ifs_device.c | 50 +++++++++++++++++++
 6 files changed, 62 insertions(+)
 create mode 100644 drivers/platform/x86/intel/ifs/Kconfig
 create mode 100644 drivers/platform/x86/intel/ifs/Makefile
 create mode 100644 drivers/platform/x86/intel/ifs/intel_ifs_device.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 40fa1955ca3f..9e372a960fa5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9861,6 +9861,13 @@ B:	https://bugzilla.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git
 F:	drivers/idle/intel_idle.c
 
+INTEL IN FIELD SCAN (IFS) DRIVER
+M:	Jithu Joseph <jithu.joseph@intel.com>
+R:	Ashok Raj <ashok.raj@intel.com>
+R:	Tony Luck <tony.luck@intel.com>
+S:	Maintained
+F:	drivers/platform/x86/intel/ifs
+
 INTEL INTEGRATED SENSOR HUB DRIVER
 M:	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
 M:	Jiri Kosina <jikos@kernel.org>
diff --git a/drivers/platform/x86/intel/Kconfig b/drivers/platform/x86/intel/Kconfig
index 1f01a8a23c57..794968bda115 100644
--- a/drivers/platform/x86/intel/Kconfig
+++ b/drivers/platform/x86/intel/Kconfig
@@ -4,6 +4,7 @@
 #
 
 source "drivers/platform/x86/intel/atomisp2/Kconfig"
+source "drivers/platform/x86/intel/ifs/Kconfig"
 source "drivers/platform/x86/intel/int1092/Kconfig"
 source "drivers/platform/x86/intel/int3472/Kconfig"
 source "drivers/platform/x86/intel/pmc/Kconfig"
diff --git a/drivers/platform/x86/intel/Makefile b/drivers/platform/x86/intel/Makefile
index c61bc3e97121..10285d0fd16a 100644
--- a/drivers/platform/x86/intel/Makefile
+++ b/drivers/platform/x86/intel/Makefile
@@ -5,6 +5,7 @@
 #
 
 obj-$(CONFIG_INTEL_ATOMISP2_PDX86)	+= atomisp2/
+obj-y					+= ifs/
 obj-$(CONFIG_INTEL_SAR_INT1092)		+= int1092/
 obj-$(CONFIG_INTEL_SKL_INT3472)		+= int3472/
 obj-$(CONFIG_INTEL_PMC_CORE)		+= pmc/
diff --git a/drivers/platform/x86/intel/ifs/Kconfig b/drivers/platform/x86/intel/ifs/Kconfig
new file mode 100644
index 000000000000..51325b699563
--- /dev/null
+++ b/drivers/platform/x86/intel/ifs/Kconfig
@@ -0,0 +1,2 @@
+config INTEL_IFS_DEVICE
+	bool
diff --git a/drivers/platform/x86/intel/ifs/Makefile b/drivers/platform/x86/intel/ifs/Makefile
new file mode 100644
index 000000000000..12c2f5ce9925
--- /dev/null
+++ b/drivers/platform/x86/intel/ifs/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_INTEL_IFS_DEVICE)	+= intel_ifs_device.o
diff --git a/drivers/platform/x86/intel/ifs/intel_ifs_device.c b/drivers/platform/x86/intel/ifs/intel_ifs_device.c
new file mode 100644
index 000000000000..64a143871d72
--- /dev/null
+++ b/drivers/platform/x86/intel/ifs/intel_ifs_device.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2022 Intel Corporation. */
+
+#include <linux/platform_device.h>
+#include <linux/init.h>
+#include <asm/cpu_device_id.h>
+
+#define MSR_IA32_CORE_CAPS_INTEGRITY_BIT	2
+#define MSR_IA32_CORE_CAPS_INTEGRITY		BIT(MSR_IA32_CORE_CAPS_INTEGRITY_BIT)
+
+#define X86_MATCH(model)					\
+	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 6,		\
+		INTEL_FAM6_##model, X86_FEATURE_CORE_CAPABILITIES, NULL)
+
+static const struct x86_cpu_id ifs_cpu_ids[] __initconst = {
+	X86_MATCH(SAPPHIRERAPIDS_X),
+	{}
+};
+
+static __init int register_ifs_device(void)
+{
+	struct platform_device *pdev;
+	const struct x86_cpu_id *m;
+	u64 ia32_core_caps;
+
+	m = x86_match_cpu(ifs_cpu_ids);
+	if (!m)
+		return -ENODEV;
+
+	if (rdmsrl_safe(MSR_IA32_CORE_CAPS, &ia32_core_caps))
+		return -ENODEV;
+
+	if (ia32_core_caps & MSR_IA32_CORE_CAPS_INTEGRITY) {
+		pdev = platform_device_alloc("intel_ifs", 0);
+		if (pdev) {
+			if (platform_device_add(pdev))
+				platform_device_put(pdev);
+		}
+	}
+
+	/*
+	 * Failure here will be visible by a missing device
+	 * in sysfs. Returning an error code would not make
+	 * that any easier to diagnose. Would also complicate
+	 * future implementations that may support a subset of
+	 * the types of tests.
+	 */
+	return 0;
+}
+device_initcall(register_ifs_device);
-- 
2.35.1

