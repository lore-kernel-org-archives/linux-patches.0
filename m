Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B841299927
	for <patches@lists.linux.dev>; Fri, 28 Aug 2026 15:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787931012; cv=none; b=POXs8H8Oie4yikrOZnN9M/ongpiuV60mvgwsoprbhUgkRUn9NU7WulD6liDuIxkm2qsRre/geI+v7MYJll0L8jOBNXHOH230CQtPOJgd3G8Ah47Hc+PFmVDElB6rpO9AvM+aqLtkTWxf3kw7zy1Cne4jvAwAQWjsAdXWfFZZ8oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787931012; c=relaxed/simple;
	bh=EvYVX1jlXunQVQY2wapQxH15oGSKPDjk3N3QBKE/0U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYmG/ZTKqSCfs5IWaKcxx/MZVOwdCTBxYhx2b/SFVJu9/KzzuFLPGhhDAa9+REMzkwyaqt6t802a3jE+UialCep/0gJG/sVc4QEAHLnW2h31nrab/KPXy5i8hxCltryWUbSqyzT3fkK1bD1rQY6vbZvpFB2wbS3JLHJrrf3Q9qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ENILynUc; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ENILynUc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787931010; x=1819467010;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EvYVX1jlXunQVQY2wapQxH15oGSKPDjk3N3QBKE/0U0=;
  b=ENILynUcNkgodrXUcYb/MWrZ1h1HgW7c65YFQqRgp8Pw2N9VSUfhBeEg
   vuYBsvXlI57nywPIxCcOj8Q4ZigdXjlXfO53Fi34EucFObILErFneLsKE
   ZttYqqEjfph1ow6M4E8GMT9jjle3IrqqQrslZfUqaVcg4UPKoqUYK5606
   chx2yVbDBoWLxRU/pDM0nCfY+8Xq3bIZaY2jU8pw7+Re1zInzkkGKLhqG
   SuZWayWnrulvtwSwViXdyP5u2sfKVOU1xx1fk3wtwp5oQ+DVGRimq3dYP
   TzYNEfnB4iPVBVbj2G6bL/C8DN47MvazpCfrv+69dyykf58WDl6gWEm0s
   Q==;
X-CSE-ConnectionGUID: eZHSLbpORuyGDi/QJJRMmw==
X-CSE-MsgGUID: 9TcvfdC4RzazUO6AHzPwbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11889"; a="99104595"
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="99104595"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 08:30:10 -0700
X-CSE-ConnectionGUID: Y4uBGVy4THG9uoS3wSZ3QA==
X-CSE-MsgGUID: OczJIe/qTqOH4FTiKMLqpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="291682282"
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
Subject: [PATCH v2 4/7] EDAC/intel-bff: Add Diamond Rapids support
Date: Fri, 28 Aug 2026 08:29:59 -0700
Message-ID: <20260828153002.10290-5-tony.luck@intel.com>
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
 drivers/edac/intel-bff.c | 45 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/edac/intel-bff.c b/drivers/edac/intel-bff.c
index 905cbe58bc53..f70c5e697dae 100644
--- a/drivers/edac/intel-bff.c
+++ b/drivers/edac/intel-bff.c
@@ -18,18 +18,55 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
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
 
+/* Machine check bank hardware unit types */
+enum bff_bank_type {
+	BFF_BANK_NONE = 0,
+	BFF_BANK_DCU,
+	BFF_BANK_DTLB,
+	BFF_BANK_MLC,
+	BFF_BANK_CCF,
+	BFF_BANK_HSF,
+	BFF_BANK_IOCACHE,
+};
+
+/*
+ * Mapping from machine check bank numbers on Diamond Rapids CPU, that are
+ * supported by a bitfix filter, to hardware unit type.
+ */
+static const enum bff_bank_type dmr_mcbanks[MAX_NR_BANKS] = {
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
+static const enum bff_bank_type *bff_bank_types;
+
 static int __init bff_init(void)
 {
+	const struct x86_cpu_id *m;
 	u64 core_caps, mcg_cap;
 
 	if (!cpu_feature_enabled(X86_FEATURE_MCA))
@@ -44,6 +81,14 @@ static int __init bff_init(void)
 	if (!(core_caps & MSR_IA32_CORE_CAPS_BFF_RESET))
 		return -ENODEV;
 
+	m = x86_match_cpu(bff_cpu_ids);
+	if (!m) {
+		pr_info("CPU model not supported by the bitfix filter reset driver\n");
+		return -ENODEV;
+	}
+
+	bff_bank_types = (const enum bff_bank_type *)m->driver_data;
+
 	return 0;
 }
 
-- 
2.55.0

