Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B83A360ED0
	for <patches@lists.linux.dev>; Fri, 28 Aug 2026 15:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787931024; cv=none; b=tFqQWxvjvXxTa8lf/xSgc1DpQrdVrO5jKvxJKn98kGdHDcWgX5uXBFC6BwZQ5XSZH1JByop95bwT1K4VD6tLkjKC5LXAqV6RW/C3BJHXujU8iLAqJ9xYRzWaanPU/lpe+9g208n7yEFRMlDLjQn5ZnjjQFFUS3qYZmblWMjN6Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787931024; c=relaxed/simple;
	bh=TZBaltimlxJ09g+m37Hr8LTGXn/rNqzVEM9ivilaUU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQOFGKNTTbM7+DB14qwQZHK5Uz5wKAoXoR+jkTlkAWV8vWmKujiIrwRzG5thb/9WVtG7orY4RPVZq45h8/2Q6imRiEX9MUhxXuw/m8v9xChilvB1FYJMuFuctbTzEY9VNFieDurPAmtS6WlUNF0lYqdczVoWkCA9+lf8MzjGSGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hA+fHZXS; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hA+fHZXS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787931022; x=1819467022;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TZBaltimlxJ09g+m37Hr8LTGXn/rNqzVEM9ivilaUU8=;
  b=hA+fHZXS/swdgADUeqLfTyPkRldQJznUSOrsrOOXYdrJGm/w0ZrhvcCq
   hJsCCxXa6QiYLUxZFVcyVssmLdcfsKkSur64IqOX1fSDLl0uGM0JY8ud9
   oGoVwiP5ifecsUM/4ATG0yq1pxw3I3NKqEorgnLsv5Z47zLVXHJCh9chp
   hFFOHZv7i2YfPBoC+fRatsQfAaS04lkECUwZpqOc9ltf68GkUOnscNp9j
   NBOMTPMGzeTdf1G2JzsU51+LOmF7lWgBarufahg1GKge36n5zNqhNZGaI
   sI1i1EWKI2NgmeVhqf7d/nGDiLwpKIcWbuFtyv2vsfFZs4Vv96RPQY1Ve
   Q==;
X-CSE-ConnectionGUID: rfCCja+aRrKTpIS9pJBiaw==
X-CSE-MsgGUID: QTL3M8XwQXOwZ770R1HHkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11889"; a="99104603"
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="99104603"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 08:30:10 -0700
X-CSE-ConnectionGUID: kjXiaU0DTkmsq+gk1XJaSg==
X-CSE-MsgGUID: lAhY5Xt8S0GqKoyYdq6ZgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="291682288"
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
Subject: [PATCH v2 6/7] EDAC/intel-bff: Compute unique ID for overflowed filter
Date: Fri, 28 Aug 2026 08:30:01 -0700
Message-ID: <20260828153002.10290-7-tony.luck@intel.com>
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

Each L2 cache instance has its own bitfix filter, but always reports
errors in machine check bank 3 (on Diamond Rapids).

Compute a unique bitfix filter instance number based on the CPU that
logged the error and the machine check bank number.

Special-case the banks associated with the Integrated Memory Hub (IMH).
Here the "even" numbered CPU modules are associated with IMH0 and the
"odd" modules with IMH1.

The unique id will be used to store a time stamp of when the bitfix
filter overflowed so that frequent overflows can be logged.

Co-developed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/edac/intel-bff.c | 80 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/drivers/edac/intel-bff.c b/drivers/edac/intel-bff.c
index c46d5255f34b..06a79745c2fb 100644
--- a/drivers/edac/intel-bff.c
+++ b/drivers/edac/intel-bff.c
@@ -19,13 +19,18 @@
 
 #include <linux/bitfield.h>
 #include <linux/bits.h>
+#include <linux/cacheinfo.h>
+#include <linux/cleanup.h>
 #include <linux/cpufeature.h>
+#include <linux/cpuhplock.h>
 #include <linux/device-id/x86_cpu.h>
 #include <linux/errno.h>
 #include <linux/init.h>
+#include <linux/limits.h>
 #include <linux/module.h>
 #include <linux/notifier.h>
 #include <linux/printk.h>
+#include <linux/topology.h>
 #include <linux/types.h>
 
 #include <asm/cpu_device_id.h>
@@ -72,12 +77,87 @@ MODULE_DEVICE_TABLE(x86cpu, bff_cpu_ids);
 
 static const enum bff_bank_type *bff_bank_types;
 
+/* Diamond Rapids maps APICID[2] to the IMH instance within a socket. */
+#define APICID_IMH_NUM		GENMASK(2, 2)
+#define IMH_NUM(apicid)		FIELD_GET(APICID_IMH_NUM, apicid)
+#define NUM_IMH_PER_SOCKET	2
+
+static void bff_set_imh_id(struct mce *mce, unsigned long *id)
+{
+	int imh_num;
+
+	imh_num = NUM_IMH_PER_SOCKET * topology_physical_package_id(mce->extcpu) +
+			IMH_NUM(mce->apicid);
+
+	*id |= imh_num;
+}
+
+static bool bff_set_cache_id(int cpu, int level, unsigned long *id)
+{
+	int cacheid;
+
+	guard(cpus_read_lock)();
+
+	cacheid = get_cpu_cacheinfo_id(cpu, level);
+	if (cacheid == -1) {
+		pr_warn("Could not get L%d cache id for CPU %d\n", level, cpu);
+		return false;
+	}
+
+	*id |= cacheid;
+
+	return true;
+}
+
+/*
+ * Cache IDs are only unique within a cache level.
+ * Include the MCA bank number so each BFF-capable hardware
+ * resource has a unique tracking ID.
+ */
+#define BFF_ID_BANK_FIELD	GENMASK(63, 32)
+
+static unsigned long bff_get_id(struct mce *mce)
+{
+	unsigned long id = FIELD_PREP(BFF_ID_BANK_FIELD, mce->bank);
+
+	switch (bff_bank_types[mce->bank]) {
+	case BFF_BANK_DCU:
+	case BFF_BANK_DTLB:
+		if (!bff_set_cache_id(mce->extcpu, 1, &id))
+			return ULONG_MAX;
+		break;
+
+	case BFF_BANK_MLC:
+		if (!bff_set_cache_id(mce->extcpu, 2, &id))
+			return ULONG_MAX;
+		break;
+
+	case BFF_BANK_CCF:
+		if (!bff_set_cache_id(mce->extcpu, 3, &id))
+			return ULONG_MAX;
+		break;
+
+	case BFF_BANK_HSF:
+	case BFF_BANK_IOCACHE:
+		bff_set_imh_id(mce, &id);
+		break;
+
+	default:
+		return ULONG_MAX;
+	}
+
+	return id;
+}
+
 static void bff_reset_and_report(struct mce *mce)
 {
 	/* Reset bitfix filter using the CPU that logged the yellow status */
 	if (wrmsrq_on_cpu(mce->extcpu, MSR_MCx_BFF_CTL(mce->bank), MCI_BFF_RESET))
 		pr_warn("Failed to reset bitfix filter for CPU %d Bank %d\n",
 			mce->extcpu, mce->bank);
+
+	/* Placeholder use of bff_get_id() */
+	pr_debug("unique_id = 0x%lx\n", bff_get_id(mce));
 }
 
 static int bff_mce_notify(struct notifier_block *nb, unsigned long val, void *data)
-- 
2.55.0

