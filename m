Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB0B32B11C
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 18:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787681739; cv=none; b=fUsXzSz84CosY8Af4kyYTZff10CDpNRT2N5hnSdTri/+C0wMenhRdWpX3UEBZexm87rNr5ip9CQDZ/TsAauix3Q/Im6iDuk5AhfRXoX5G7c+jmj4qF1EkgXCxoAQWR56rEMjnQpxsRPn1X0rRrnInQrb3iyreY38/QzM8LB0K2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787681739; c=relaxed/simple;
	bh=qA60IvVIKunK0kboQXNF7O/eTm70MAmNUKiDqF0nAI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbCB+Z5koUDA5cOuMWVZP7iOaD7oW16aKX+66nqStRY0d1fIRJf184XtIytUfrFhRjKts+P+Vx0Jn6inqEO71tauNBe94qFN0SYmw0Ox2iErKeLxgpD+dWrfHwCnk6yb8gGJ+0JolwdwZBPDoJbFgGCG0+6Q0kJgKbGZX1KPGZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QZJiVJpC; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QZJiVJpC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787681737; x=1819217737;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qA60IvVIKunK0kboQXNF7O/eTm70MAmNUKiDqF0nAI8=;
  b=QZJiVJpC1YCZO6IC8x1ZDob+3HKhKEp3OGJm0+x8VVheHlzifGXf5fIR
   WVFzjkYo1FU3qmnwhAzsmj0jKf47flRCOeqyfds6ymB4Qn4gDdWhhiVIK
   kEGyHFGSY72Ym7jK6Mmw4CM2jUOEUurfbrTri5HrxquqvswxtcBbGglnD
   VRzDGF344wqwdHSNeuezR4ythbjoN1W4xVIrfgUQ4Gwqv+eFo+bYYtv6a
   ZeAvDK+ObygRODCDswkUrQTAA/G88pzE9Frn5sB3athBNklGOaiVrHN0Z
   3iuPju6gGnV9b93OEjWOmsHwKCBp+tz0mRfMT8RagIsId94++lhJJGWb5
   A==;
X-CSE-ConnectionGUID: +nvvhIzHReWKJv7m6bREMg==
X-CSE-MsgGUID: 0loAITz/SVeUsJ7RIAN0Kg==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="88174210"
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="88174210"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 11:15:34 -0700
X-CSE-ConnectionGUID: O8RDDvbzRzmwUn5PrwoCIw==
X-CSE-MsgGUID: pcdRHad8Sy+I+cP0WGIprg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="265559602"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.141])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 11:15:34 -0700
From: Tony Luck <tony.luck@intel.com>
To: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hansg@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>,
	Breno Leitao <leitao@debian.org>,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: [PATCH 3/7] platform/x86/intel/bff: Add stub Intel bitfix filter driver
Date: Tue, 25 Aug 2026 11:15:22 -0700
Message-ID: <20260825181526.13203-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825181526.13203-1-tony.luck@intel.com>
References: <20260825181526.13203-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check if platform supports enhanced cache error reporting and the
bitfix filter reset feature.

Co-developed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/bff.c    | 59 +++++++++++++++++++++++++++++
 drivers/platform/x86/intel/Kconfig  | 13 +++++++
 drivers/platform/x86/intel/Makefile |  1 +
 3 files changed, 73 insertions(+)
 create mode 100644 drivers/platform/x86/intel/bff.c

diff --git a/drivers/platform/x86/intel/bff.c b/drivers/platform/x86/intel/bff.c
new file mode 100644
index 000000000000..9522bdb1401d
--- /dev/null
+++ b/drivers/platform/x86/intel/bff.c
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2026 Intel Corporation. */
+
+/*
+ * Intel driver to reset bitfix filters when they overflow.
+ *
+ * Each bitfix filter has limited slots to track corrected errors.
+ * These slots can be filled by transient corrected errors (e.g.,
+ * bit flips from particle strikes) that don't represent permanent
+ * hardware defects.
+ *
+ * When the filter overflows (yellow status), reset it to reclaim
+ * slots occupied by transient corrected errors. If the overflow
+ * repeats frequently after reset, it indicates persistent hardware
+ * defects that need attention: the system should be scheduled for
+ * servicing.
+ */
+#define pr_fmt(fmt) "bff: " fmt
+
+#include <linux/cpufeature.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/types.h>
+
+#include <asm/cpufeatures.h>
+#include <asm/mce.h>
+#include <asm/msr.h>
+#include <asm/msr-index.h>
+
+static int __init bff_init(void)
+{
+	u64 core_caps, mcg_cap;
+
+	if (!cpu_feature_enabled(X86_FEATURE_MCA))
+		return -ENODEV;
+	rdmsrq(MSR_IA32_MCG_CAP, mcg_cap);
+	if (!(mcg_cap & MCG_TES_P))
+		return -ENODEV;
+
+	if (!cpu_feature_enabled(X86_FEATURE_CORE_CAPABILITIES))
+		return -ENODEV;
+
+	rdmsrq(MSR_IA32_CORE_CAPS, core_caps);
+	if (!(core_caps & MSR_IA32_CORE_CAPS_BFF_RESET_DETECT))
+		return -ENODEV;
+
+	return 0;
+}
+
+static void __exit bff_exit(void)
+{
+}
+
+module_init(bff_init);
+module_exit(bff_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Intel bitfix filter reset driver");
diff --git a/drivers/platform/x86/intel/Kconfig b/drivers/platform/x86/intel/Kconfig
index 2900407d6095..f4e9af0116ee 100644
--- a/drivers/platform/x86/intel/Kconfig
+++ b/drivers/platform/x86/intel/Kconfig
@@ -251,3 +251,16 @@ config INTEL_VSEC
 
 	  To compile this driver as a module, choose M here: the module will
 	  be called intel_vsec.
+
+config INTEL_BFF_RESET
+	tristate "Intel bitfix filter reset driver"
+	depends on CPU_SUP_INTEL && X86_MCE
+	help
+	  Adds support for Intel systems that implement bitfix filters to
+	  suppress repeated logging and signaling of the same corrected
+	  error. Those filters can become clogged with transient errors
+	  over time. Clearing the filter may make space for additional
+	  hard errors.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called intel_bff.
diff --git a/drivers/platform/x86/intel/Makefile b/drivers/platform/x86/intel/Makefile
index 138b13756158..dc4e374758d5 100644
--- a/drivers/platform/x86/intel/Makefile
+++ b/drivers/platform/x86/intel/Makefile
@@ -27,6 +27,7 @@ intel-target-$(CONFIG_INTEL_ISHTP_ECLITE)	+= ishtp_eclite.o
 intel-target-$(CONFIG_INTEL_OAKTRAIL)		+= oaktrail.o
 intel-target-$(CONFIG_INTEL_SDSI)		+= sdsi.o
 intel-target-$(CONFIG_INTEL_VSEC)		+= vsec.o
+intel-target-$(CONFIG_INTEL_BFF_RESET)		+= bff.o
 
 # Intel PMIC / PMC / P-Unit drivers
 intel-target-$(CONFIG_INTEL_BYTCRC_PWRSRC)	+= bytcrc_pwrsrc.o
-- 
2.55.0

