Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF681331ED6
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 18:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787681739; cv=none; b=pGOSISyZ9DGOUl5SJ6jr4Aa+PbY4Uv1+zdWx9iaXdc+uiqc6dlxGFsZNMrkVDodPLNn3l18/8R0najOlSvtp9l33LcEryezbWcIfDYsM6yepdwFDHj59slv9mWa2qMwWT+l07O+N8JNcmzCpaWSUu17PtH7U4UIilrBSNpWKlhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787681739; c=relaxed/simple;
	bh=+cdNIaAabyorKn/HrwhM9Ndub9E+MnRccu4cl/hmMCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDAf2lthBueuIRlda4Zcf/Uo9FBdTj1w2V7F4evBQlhDeepVtO060e3MHmUBQcerYZhbL7+HF72660h3W5sosZTXElXK9f6lZowRfKzIFFABuY0//Y2LUvAjWGlmpdRPUo21146ccI1/ZVdb55LXZxkzjyn3QCzRM0zf7+IpdpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iLSLVwed; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iLSLVwed"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787681737; x=1819217737;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+cdNIaAabyorKn/HrwhM9Ndub9E+MnRccu4cl/hmMCM=;
  b=iLSLVwed6jf7/AAVU+lNwwSuDBMMjDlx4Oxlns9PVraiNQUU86wiMOWy
   A8xfkVwSNDEfW48LsI+8KnBwqhxlvozqOjcOe05VOCCaG3Zm74c17CzkN
   TVGVbVjPn8Rs7ETLv3qFRUENZsV9CbKj4qlBWiax1cQ2zE4G2tTvLvxkW
   nz2pyOdbYVA7iXDQijCtPQaDkyTqjm8bmCcF2ZTNypQq9XhaoYhHUJsJT
   yjKEUsxYEDdh2WEYBzrIOQX5ZTMzm+abieeSOlUN3t1fEoB5ta3SmOYgl
   OI2GlLvBq9BVFIRm5ZHgwC6xl7gjCVLOS6hDMQHULtcyooOPH9pQPL6j/
   g==;
X-CSE-ConnectionGUID: iu27te5DTVW/z+477bpNJg==
X-CSE-MsgGUID: PDr+CSQrTIa0nZTqCacRyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="88174215"
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="88174215"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 11:15:34 -0700
X-CSE-ConnectionGUID: sO0dtylRQkqW7ORIW42BOQ==
X-CSE-MsgGUID: 9lbD1c29TG2JBe8pzQUYpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="265559605"
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
Subject: [PATCH 4/7] platform/x86/intel/bff: Add Diamond Rapids support
Date: Tue, 25 Aug 2026 11:15:23 -0700
Message-ID: <20260825181526.13203-5-tony.luck@intel.com>
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

There are potentially bitfix filters associated with each machine check
bank. Only some banks may implement them.

Machine check banks have varying scope. E.g. there is a separate L2
cache for each module, each instance has its own bitfix filter.

Add information that will be used to map a <cpu,bank> pair to a unique
instance number for a bitfix filter.

Co-developed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/bff.c | 41 ++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/platform/x86/intel/bff.c b/drivers/platform/x86/intel/bff.c
index 9522bdb1401d..6360bbc92347 100644
--- a/drivers/platform/x86/intel/bff.c
+++ b/drivers/platform/x86/intel/bff.c
@@ -18,18 +18,51 @@
 #define pr_fmt(fmt) "bff: " fmt
 
 #include <linux/cpufeature.h>
+#include <linux/device-id/x86_cpu.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/printk.h>
 #include <linux/types.h>
 
+#include <asm/cpu_device_id.h>
 #include <asm/cpufeatures.h>
+#include <asm/intel-family.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
 #include <asm/msr-index.h>
 
+/* Machine check bank scope types */
+enum bff_type {
+	BFF_NONE = 0,
+	BFF_BANK_DCU,
+	BFF_BANK_DTLB,
+	BFF_BANK_MLC,
+	BFF_BANK_CCF,
+	BFF_BANK_HSF,
+	BFF_BANK_IOCACHE,
+};
+
+static const enum bff_type dmr_mcbanks[MAX_NR_BANKS] = {
+	[1]	= BFF_BANK_DCU,
+	[2]	= BFF_BANK_DTLB,
+	[3]	= BFF_BANK_MLC,
+	[6]	= BFF_BANK_CCF,
+	[13]	= BFF_BANK_HSF,
+	[17]	= BFF_BANK_IOCACHE
+};
+
+static const struct x86_cpu_id bff_cpu_ids[] __initconst = {
+	X86_MATCH_VFM(INTEL_DIAMONDRAPIDS_X, dmr_mcbanks),
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, bff_cpu_ids);
+
+static const enum bff_type *bank_types;
+
 static int __init bff_init(void)
 {
+	const struct x86_cpu_id *m;
 	u64 core_caps, mcg_cap;
 
 	if (!cpu_feature_enabled(X86_FEATURE_MCA))
@@ -45,6 +78,14 @@ static int __init bff_init(void)
 	if (!(core_caps & MSR_IA32_CORE_CAPS_BFF_RESET_DETECT))
 		return -ENODEV;
 
+	m = x86_match_cpu(bff_cpu_ids);
+	if (!m) {
+		pr_info("CPU supports bitfix filter, but driver does not\n");
+		return -ENODEV;
+	}
+
+	bank_types = (const enum bff_type *)m->driver_data;
+
 	return 0;
 }
 
-- 
2.55.0

