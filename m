Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5FB1375
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 16:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650386349; x=1681922349;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v4WGCF2s5f5KuKam370PTpkZM1RS4K0r/UhQwRsUGzE=;
  b=FKvR0KuwKRQtTA0X82f/s4mH8kWosiQtwIZ+F2v5g0H3F71DO1C2/S0C
   MQiNL6JYrnJ/VhuPO4ii9/ED8bxx+u/2qAIQu79Vt7dcyhRUFH5wqMa3A
   hlUxeghS5ZCgBVW+dTccBK/rRoUQzsPCl5goktpE7V0xCHpaLU2ccZAdh
   m4QpcIGu7+UuiaY5Nexoklijgj8ixFEzxbFY9+gt58Gf4raddYvQGINMz
   R8fyHLjGRP3/EVG/qPIG/a2d7plZt9f0V/jNvDsLSNEpzRNJavMV2c2dW
   NOPyeKGhX9SeG75df6xrVmLo78iVAu5ZqCdzlcbSm8wr3k1G47nPQv1LC
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="244395695"
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="244395695"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 09:39:07 -0700
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="554802139"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 09:39:07 -0700
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
Subject: [PATCH v3 04/11] platform/x86/intel/ifs: Add stub driver for In-Field Scan
Date: Tue, 19 Apr 2022 09:38:52 -0700
Message-Id: <20220419163859.2228874-5-tony.luck@intel.com>
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

Cloud Service Providers that operate fleets of servers have reported
[1] occasions where they can detect that a CPU has gone bad due to
effects like electromigration, or isolated manufacturing defects.
However, that detection method is A/B testing seemingly random
application failures looking for a pattern. In-Field Scan (IFS) is
a driver for a platform capability to load a crafted 'scan image'
to run targeted low level diagnostics outside of the CPU's architectural
error detection capabilities.

[1]: https://www.youtube.com/watch?v=QMF3rqhjYuM

Kconfig for this driver selects CONFIG_INTEL_IFS_DEVICE so the base
kernel will be built with code to create the device to which this driver
will attach.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>

---
Not using module_platform_driver() for this simple stub because
later patches need to add init()/exit() functions.
---
 drivers/platform/x86/intel/ifs/Kconfig  | 14 ++++++++++++
 drivers/platform/x86/intel/ifs/Makefile |  4 ++++
 drivers/platform/x86/intel/ifs/core.c   | 29 +++++++++++++++++++++++++
 3 files changed, 47 insertions(+)
 create mode 100644 drivers/platform/x86/intel/ifs/core.c

diff --git a/drivers/platform/x86/intel/ifs/Kconfig b/drivers/platform/x86/intel/ifs/Kconfig
index 51325b699563..0aa5ecc5ef42 100644
--- a/drivers/platform/x86/intel/ifs/Kconfig
+++ b/drivers/platform/x86/intel/ifs/Kconfig
@@ -1,2 +1,16 @@
 config INTEL_IFS_DEVICE
 	bool
+
+config INTEL_IFS
+	tristate "Intel In Field Scan"
+	depends on X86 && 64BIT && SMP
+	select INTEL_IFS_DEVICE
+	help
+	  Enable support for the In Field Scan capability in select
+	  CPUs. The capability allows for running low level tests via
+	  a scan image distributed by Intel via Github to validate CPU
+	  operation beyond baseline RAS capabilities. To compile this
+	  driver as a module, choose M here. The module will be called
+	  intel_ifs.
+
+	  If unsure, say N.
diff --git a/drivers/platform/x86/intel/ifs/Makefile b/drivers/platform/x86/intel/ifs/Makefile
index 12c2f5ce9925..bf8adc57892c 100644
--- a/drivers/platform/x86/intel/ifs/Makefile
+++ b/drivers/platform/x86/intel/ifs/Makefile
@@ -1 +1,5 @@
 obj-$(CONFIG_INTEL_IFS_DEVICE)	+= intel_ifs_device.o
+
+obj-$(CONFIG_INTEL_IFS)		+= intel_ifs.o
+
+intel_ifs-objs			:= core.o
diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
new file mode 100644
index 000000000000..eb34b877dac0
--- /dev/null
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2022 Intel Corporation. */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+static struct platform_driver intel_ifs_driver = {
+	.driver = {
+		.name = "intel_ifs",
+	},
+};
+
+static int __init ifs_init(void)
+{
+	return platform_driver_register(&intel_ifs_driver);
+}
+
+static void __exit ifs_exit(void)
+{
+	platform_driver_unregister(&intel_ifs_driver);
+}
+
+module_init(ifs_init);
+module_exit(ifs_exit);
+
+MODULE_ALIAS("platform:intel_ifs*");
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Intel In Field Scan (IFS) driver");
-- 
2.35.1

