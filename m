Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06020288C96
	for <patches@lists.linux.dev>; Fri, 28 Aug 2026 15:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787931022; cv=none; b=PEDprH8afFWavtsetAg+NLAtwBuRu7RwCUC2bUe5rn0obggBBpPDbUtWE7UfeAMHLSQnZx4GJVVJOW2Q0nSsExmUHe8KFMxEeaSb2mTlH/SB2j1y9WEattJsuXbvOY1wrzrswQ5xGDsw9PLTgUMAXTYwVnBqZPJsCQjfnKuR118=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787931022; c=relaxed/simple;
	bh=YdNVhDNcqcNuZkeks7ysbwhNgbRkfvVgZV/jw4bmStY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqZ5p7GytcZHkYKrOoy1fS9/QJZSX93C+wwMo4Rk7jQ6ccgYZu3WccW1fCcUr6s8s2f9Z/UM5of4wbOaehox8/HwhdcwWtxrQfGCADBhh41tdf9yyEGPo/7IaqhpkYHqTIxvZo0rpzzKjbdZ0UIkW8bCxJAuQwscHwEayNZ2SwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WweU7NQC; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WweU7NQC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787931017; x=1819467017;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YdNVhDNcqcNuZkeks7ysbwhNgbRkfvVgZV/jw4bmStY=;
  b=WweU7NQCpGvJVpDVx/wQamGUtCDwOglKxMDo/9KHhVC58Zj9h59SM0i+
   Nsi84RrCy4y0/8MrKbrHtlGjnoSAP9IaeLlMjHMaUqnKdn117dRBEcuGB
   CEuO6H13OzYvsdi0+PO5GFwGwseGR5Rr2QqUb5PhVqW+FTeVFFbttaaes
   AtllYbLWfvboPfLsV4bODTaR/QQTrenp81r2S/R7XISlGe9DcY2xbFinM
   SqWk9FcD8RP57ZRMN8xnFFnofOq2VZMdyQ359kbwLAj4SNNYmfx3nMLiJ
   IUe/M39JjM+NhucGVitsL437TgdutS/2aA3KEjE3yYqE8XwQ83YhqFIkL
   Q==;
X-CSE-ConnectionGUID: esrZzscjTSOUcV0CJLEfvA==
X-CSE-MsgGUID: Ix+Qrp8YTUqwECkrcuMRQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11889"; a="99104591"
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="99104591"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 08:30:09 -0700
X-CSE-ConnectionGUID: 3W3gJfl3R1Gkb/Gs7Bxr+Q==
X-CSE-MsgGUID: leqq57gOSzK71mjL9+fekg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="291682279"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.223.138])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 08:30:09 -0700
From: Tony Luck <tony.luck@intel.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Breno Leitao <leitao@debian.org>,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v2 3/7] EDAC/intel-bff: Add stub Intel bitfix filter driver
Date: Fri, 28 Aug 2026 08:29:58 -0700
Message-ID: <20260828153002.10290-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260828153002.10290-1-tony.luck@intel.com>
References: <20260828153002.10290-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check if the platform supports threshold based cache error reporting and
the bitfix filter reset feature.

Co-developed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/edac/intel-bff.c | 54 ++++++++++++++++++++++++++++++++++++++++
 MAINTAINERS              |  6 +++++
 drivers/edac/Kconfig     | 13 ++++++++++
 drivers/edac/Makefile    |  2 ++
 4 files changed, 75 insertions(+)
 create mode 100644 drivers/edac/intel-bff.c

diff --git a/drivers/edac/intel-bff.c b/drivers/edac/intel-bff.c
new file mode 100644
index 000000000000..905cbe58bc53
--- /dev/null
+++ b/drivers/edac/intel-bff.c
@@ -0,0 +1,54 @@
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
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
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
+	rdmsrq(MSR_IA32_CORE_CAPS, core_caps);
+	if (!(core_caps & MSR_IA32_CORE_CAPS_BFF_RESET))
+		return -ENODEV;
+
+	return 0;
+}
+
+module_init(bff_init);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Tony Luck");
+MODULE_DESCRIPTION("Intel bitfix filter reset driver");
diff --git a/MAINTAINERS b/MAINTAINERS
index 8014b9f8253e..edc50f7cb025 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9405,6 +9405,12 @@ L:	linux-edac@vger.kernel.org
 S:	Maintained
 F:	drivers/edac/igen6_edac.c
 
+EDAC-INTEL-BFF-RESET
+M:	Tony Luck <tony.luck@intel.com>
+L:	linux-edac@vger.kernel.org
+S:	Maintained
+F:	drivers/edac/intel-bff.c
+
 EDAC-MPC85XX
 M:	Johannes Thumshirn <morbidrsa@gmail.com>
 L:	linux-edac@vger.kernel.org
diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index a44b85c440ca..f7964cd9545e 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -280,6 +280,19 @@ config EDAC_IMH
 	  first used on the Diamond Rapids servers but may appear on
 	  others in the future.
 
+config EDAC_INTEL_BFF_RESET
+	tristate "Intel bitfix filter reset driver"
+	depends on X86_64 && X86_MCE_INTEL
+	help
+	  Support for Intel systems that implement bitfix filters to
+	  suppress repeated logging and signaling of the same corrected
+	  error. Those filters can become clogged with transient errors
+	  over time. Clearing the filter may make space for additional
+	  hard errors.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called intel_bff.
+
 config EDAC_PND2
 	tristate "Intel Pondicherry2"
 	depends on PCI && X86_64 && X86_MCE_INTEL
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index a37534300ab9..c2bae03f247b 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -66,6 +66,8 @@ obj-$(CONFIG_EDAC_I10NM)		+= i10nm_edac.o skx_edac_common.o
 imh_edac-y				:= imh_base.o
 obj-$(CONFIG_EDAC_IMH)			+= imh_edac.o skx_edac_common.o
 
+obj-$(CONFIG_EDAC_INTEL_BFF_RESET)	+= intel-bff.o
+
 obj-$(CONFIG_EDAC_HIGHBANK_MC)		+= highbank_mc_edac.o
 obj-$(CONFIG_EDAC_HIGHBANK_L2)		+= highbank_l2_edac.o
 
-- 
2.55.0

