Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56599367F2F
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 18:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787681749; cv=none; b=KbNMkdzcrh5nWwccnAnT86ELc5NCoGWTuV4vaj3c8Zhq21+pik019fcODlYEE+Rgg6Ouabup2S0NiAwvTfOwKedynx1+Oc3Nfd8j+e7kdVRJkFB8sd/ATkCeZCXtuTXo9bSbAk3RSXPnh+da6smScKN3Ys/b/dXm38yjwFfAbZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787681749; c=relaxed/simple;
	bh=tYe30c5XGpV4s6273ZOEWMoRrlUMZipr2eNqrbd2K/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZvKQPXkHeiLALP6uuQKTBpIr3gschfjJisMlWIfoBimRv+Wkq6h0Qvv/EowcBSC5tecxCyAvvzMuVSKbex9kA8ueSGZ5HPd4wq2mJgdoOM37CQed0vuFwUslxk521P3Y++r6N2d5Wbql96cIqv1YGh0f8jSvrwezsENxR0Gq0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=luvsFI2X; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="luvsFI2X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787681740; x=1819217740;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tYe30c5XGpV4s6273ZOEWMoRrlUMZipr2eNqrbd2K/o=;
  b=luvsFI2XyRxX/kSpC9XevBgIyu1NqUvTGYOxuMkSSqcREHcmjPHZmAzh
   gX0bH+6EJL4BbcSvaVeoVaCOYW2I1JCsBy2DjHHl0HjGd+HNKCjLAA92p
   TqOFfsw6cpd+C816M5IcT5jIP7Qdmc7rQdQN/nMeFmBmHM+uXEiwiFUC4
   po6dBXfjFCue6N5h8SOKSRynayRfZK+Er0o2hOjgulDfE+zZWqiWBCrFq
   peyOe69uifePHSHmxkAAXzryKOaQe4KlJTGQsQM38L86BI6F38SsreFqJ
   tFcRo6qlOiL9J8TBxlULw1gErQlTiF0Vv5qhd2VywC3x3w4MBpA9Zsnt8
   A==;
X-CSE-ConnectionGUID: Yuc9PNvpTwOvRfLT75aDuw==
X-CSE-MsgGUID: DSLPJkBHRvqI4/oZHy3gTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="88174230"
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="88174230"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 11:15:35 -0700
X-CSE-ConnectionGUID: 9c+OJRBNRaOnatZg6yJojA==
X-CSE-MsgGUID: 1LtFGbwXRtqbYIncNl/6AQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="265559616"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.141])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 11:15:35 -0700
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
Subject: [PATCH 7/7] platform/x86/intel/bff: Report frequent filter resets
Date: Tue, 25 Aug 2026 11:15:26 -0700
Message-ID: <20260825181526.13203-8-tony.luck@intel.com>
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

If an instance of a bitfix filter contains some transient errors built
up over time, then resetting the filter will free up slots in the filter
to store persistent errors.

Save a time stamp when "yellow" status is seen and clear the filter.

Log at KERN_WARNING level if the overflow occurred quickly after a
previous overflow on the same bitfix filter instance. Use KERN_NOTICE
for first, or long delayed, overflow.

Co-developed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/bff.c | 71 +++++++++++++++++++++++++++++++-
 1 file changed, 70 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/bff.c b/drivers/platform/x86/intel/bff.c
index ae9dc0bf2777..7c22a1ad6b9d 100644
--- a/drivers/platform/x86/intel/bff.c
+++ b/drivers/platform/x86/intel/bff.c
@@ -23,14 +23,19 @@
 #include <linux/cpufeature.h>
 #include <linux/cpuhplock.h>
 #include <linux/device-id/x86_cpu.h>
+#include <linux/err.h>
 #include <linux/errno.h>
+#include <linux/gfp_types.h>
 #include <linux/init.h>
+#include <linux/jiffies.h>
 #include <linux/limits.h>
 #include <linux/module.h>
 #include <linux/notifier.h>
 #include <linux/printk.h>
+#include <linux/slab.h>
 #include <linux/topology.h>
 #include <linux/types.h>
+#include <linux/xarray.h>
 
 #include <asm/cpu_device_id.h>
 #include <asm/cpufeatures.h>
@@ -39,6 +44,16 @@
 #include <asm/msr.h>
 #include <asm/msr-index.h>
 
+/*
+ * A 10-minute observation period helps distinguish between:
+ *
+ *  - A long-term accumulation of transient corrected errors
+ *    (filter stays clear after reset).
+ *
+ *  - Permanent defects (filter overflows again quickly).
+ */
+#define BFF_OVERFLOW_INTERVAL   secs_to_jiffies(10 * 60)
+
 #define NUM_IMH_PER_SKT		2
 
 /* Intel bitfix filter control register defines */
@@ -74,6 +89,8 @@ MODULE_DEVICE_TABLE(x86cpu, bff_cpu_ids);
 
 static const enum bff_type *bank_types;
 
+static DEFINE_XARRAY(bff_bank_xa);
+
 /* Diamond Rapids maps APICID[2] to the IMH instance. */
 static void bff_set_imh_id(struct mce *mce, unsigned long *id)
 {
@@ -139,13 +156,58 @@ static unsigned long get_bff_id(struct mce *mce)
 	return id;
 }
 
+/*
+ * Save current timestamp for bff_id. Return true if it is within
+ * BFF_OVERFLOW_INTERVAL of previous timestamp for this bff_id.
+ */
+static bool bff_note_event_and_check_burst(unsigned long bff_id)
+{
+	unsigned long now = jiffies, when;
+	unsigned long *ts;
+
+	if (bff_id == ULONG_MAX)
+		return false;
+
+	ts = xa_load(&bff_bank_xa, bff_id);
+	if (!ts) {
+		ts = kzalloc_obj(*ts);
+		if (!ts) {
+			pr_warn("Timestamp allocation failed\n");
+			return false;
+		}
+		if (IS_ERR(xa_store(&bff_bank_xa, bff_id, ts, GFP_KERNEL))) {
+			kfree(ts);
+			pr_warn("Timestamp save failure\n");
+			return false;
+		}
+		*ts = now;
+
+		return false;
+	}
+
+	when = *ts + BFF_OVERFLOW_INTERVAL;
+	*ts = now;
+
+	return time_before(now, when);
+}
+
 static void handle_bff(struct mce *mce)
 {
+	bool burst = false;
+
 	/* The bitfix filter overflowed, get the target CPU to reset it. */
 	if (wrmsrq_on_cpu(mce->extcpu, MSR_MCx_BFF_CTL(mce->bank), MCI_BFF_RESET))
 		pr_warn("Failed to reset bitfix filter for CPU %d Bank %d\n", mce->extcpu, mce->bank);
 
-	pr_debug("unique_id = 0x%lx\n", get_bff_id(mce));
+	/* Get unique id for bitfix filter instance that overflowed */
+	burst = bff_note_event_and_check_burst(get_bff_id(mce));
+
+	if (burst)
+		pr_warn_ratelimited(HW_ERR "Socket %d CPU %d Bank %d bitfix filter overflowed frequently\n",
+				    mce->socketid, mce->extcpu, mce->bank);
+	else
+		pr_notice_ratelimited(HW_ERR "Socket %d CPU %d Bank %d bitfix filter overflowed\n",
+				      mce->socketid, mce->extcpu, mce->bank);
 }
 
 static int bff_mce_notify(struct notifier_block *nb, unsigned long val, void *data)
@@ -205,7 +267,14 @@ static int __init bff_init(void)
 
 static void __exit bff_exit(void)
 {
+	unsigned long bff_id;
+	unsigned long *ts;
+
 	mce_unregister_decode_chain(&bff_notifier);
+
+	xa_for_each(&bff_bank_xa, bff_id, ts)
+		kfree(ts);
+	xa_destroy(&bff_bank_xa);
 }
 
 module_init(bff_init);
-- 
2.55.0

