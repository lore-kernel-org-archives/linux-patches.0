Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C2136074F
	for <patches@lists.linux.dev>; Fri, 28 Aug 2026 15:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787931028; cv=none; b=cerG47TfRN+JiBn3EqrZRHEI1yBZM+JKDCYBYbWzBkRP4FgdwSzZwm1Wbo+jcbD7X3N5Saf7Y1GheCXJPxo+dhsxPbP/B8PILhYlBq63q/SvruFb2iIm22uw9AWDT77qxi1UF0dgeEFCYVnnJ9Zp0v4rtudiSKgTmkOS2OWQQOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787931028; c=relaxed/simple;
	bh=gxPoFx6SdnptXG3Hw+pks3NJkGqlI1aInjSfIWG4UM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHOTbO27d4+9kN+37b8GbBm02WCGvu6PF/vuBFSS8GMkRR08jtQvCC26VH+Jml2z3iaxHznGZrH9dECkXryhqIpH44NxUXImAX99Dzz7BQjYP0G7jghcxRgXSGYdC9p9jsSUOMAFE7hFaVWuVrtRqMvKJDKbGy2xORlB2bL6EGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mAmn8hld; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mAmn8hld"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787931023; x=1819467023;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gxPoFx6SdnptXG3Hw+pks3NJkGqlI1aInjSfIWG4UM4=;
  b=mAmn8hld4ZxRLigbcUlDqemrfZKbOkOJJ/aAh7ukYU3ibKyx4rxSTJUh
   t86yq7CbgOHN6pqWWsyXTvLZ5R2q2wkJNxWtKxzr2GxTj1Rodl4gudUcX
   JqjAEsx25Pq0VU4bZ0aI2oksRCCyYHqBlFKfsbtY7RXEZDHby+aDWjodx
   pN1F6VW5iaI7CY8DiLIoOiDQjQHWM83TaJazNcD2aOlpGlFehRWXa5xl0
   zFyPotmDkuue2xTcTlglxHoa7qJ3tf6YOmysCJvF7eJEekZBMovJFuO/A
   iBe0YW9QYbI7GhMY1sR9Lyhw8PWxu15NohM7mVoRnRMlUAcWNCJtzSmH3
   w==;
X-CSE-ConnectionGUID: 21MYlNkFRxaRpzlDpaUyxg==
X-CSE-MsgGUID: Nw0ResHnTUOVJllyIrFo9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11889"; a="99104607"
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="99104607"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 08:30:10 -0700
X-CSE-ConnectionGUID: 6aL0J0V6SnGOTVglG3NbKw==
X-CSE-MsgGUID: Vh4gdHBASvOJyPNYILowYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="291682292"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.223.138])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 08:30:10 -0700
From: Tony Luck <tony.luck@intel.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Breno Leitao <leitao@debian.org>,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v2 7/7] EDAC/intel-bff: Report frequent filter overflows
Date: Fri, 28 Aug 2026 08:30:02 -0700
Message-ID: <20260828153002.10290-8-tony.luck@intel.com>
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

If an instance of a bitfix filter contains some transient errors built
up over time, then resetting the filter will free up slots in the filter
to store persistent errors.

Save a timestamp when "yellow" status is seen and clear the filter.

Log at KERN_WARNING level if the overflow occurred quickly after a
previous overflow on the same bitfix filter instance. Use KERN_NOTICE
for first, or long delayed, overflow.

Co-developed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/edac/intel-bff.c | 72 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 70 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/intel-bff.c b/drivers/edac/intel-bff.c
index 06a79745c2fb..adf2ec343129 100644
--- a/drivers/edac/intel-bff.c
+++ b/drivers/edac/intel-bff.c
@@ -25,13 +25,17 @@
 #include <linux/cpuhplock.h>
 #include <linux/device-id/x86_cpu.h>
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
@@ -40,6 +44,16 @@
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
+#define BFF_OVERFLOW_INTERVAL	secs_to_jiffies(10 * 60)
+
 /* Intel bitfix filter control register defines */
 #define MSR_MC0_BFF_CTL		0x000006c0
 #define MSR_MCx_BFF_CTL(x)	(MSR_MC0_BFF_CTL + (x))
@@ -77,6 +91,8 @@ MODULE_DEVICE_TABLE(x86cpu, bff_cpu_ids);
 
 static const enum bff_bank_type *bff_bank_types;
 
+static DEFINE_XARRAY(bff_bank_xa);
+
 /* Diamond Rapids maps APICID[2] to the IMH instance within a socket. */
 #define APICID_IMH_NUM		GENMASK(2, 2)
 #define IMH_NUM(apicid)		FIELD_GET(APICID_IMH_NUM, apicid)
@@ -149,6 +165,41 @@ static unsigned long bff_get_id(struct mce *mce)
 	return id;
 }
 
+/*
+ * Save current timestamp for bff_id. Return true if it is within
+ * BFF_OVERFLOW_INTERVAL of previous timestamp for this bff_id.
+ */
+static bool bff_overflow_is_frequent(unsigned long bff_id)
+{
+	unsigned long now = jiffies, interval_end;
+	unsigned long *ts;
+
+	if (bff_id == ULONG_MAX)
+		return false;
+
+	ts = xa_load(&bff_bank_xa, bff_id);
+	if (!ts) {
+		ts = kzalloc_obj(*ts);
+		if (!ts) {
+			pr_warn("Failed to allocate timestamp for bitfix filter 0x%lx\n", bff_id);
+			return false;
+		}
+		if (xa_is_err(xa_store(&bff_bank_xa, bff_id, ts, GFP_KERNEL))) {
+			kfree(ts);
+			pr_warn("Failed to record timestamp for bitfix filter 0x%lx\n", bff_id);
+			return false;
+		}
+		*ts = now;
+
+		return false;
+	}
+
+	interval_end = *ts + BFF_OVERFLOW_INTERVAL;
+	*ts = now;
+
+	return time_before(now, interval_end);
+}
+
 static void bff_reset_and_report(struct mce *mce)
 {
 	/* Reset bitfix filter using the CPU that logged the yellow status */
@@ -156,8 +207,18 @@ static void bff_reset_and_report(struct mce *mce)
 		pr_warn("Failed to reset bitfix filter for CPU %d Bank %d\n",
 			mce->extcpu, mce->bank);
 
-	/* Placeholder use of bff_get_id() */
-	pr_debug("unique_id = 0x%lx\n", bff_get_id(mce));
+	/*
+	 * Use the unique id for the bitfix filter instance that overflowed and
+	 * check if this is a repeat within the BFF_OVERFLOW_INTERVAL. If it
+	 * is, then report at WARN severity as the user may want to take action.
+	 */
+	if (bff_overflow_is_frequent(bff_get_id(mce))) {
+		pr_warn_ratelimited(HW_ERR "Socket %d CPU %d Bank %d bitfix filter overflowed frequently\n",
+				    mce->socketid, mce->extcpu, mce->bank);
+	} else {
+		pr_notice_ratelimited(HW_ERR "Socket %d CPU %d Bank %d bitfix filter overflowed\n",
+				      mce->socketid, mce->extcpu, mce->bank);
+	}
 }
 
 static int bff_mce_notify(struct notifier_block *nb, unsigned long val, void *data)
@@ -216,7 +277,14 @@ static int __init bff_init(void)
 
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

