Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD96D299
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 00:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745886851; cv=none; b=JmdX31NGYOQ2cuAnh067i/O46d7fYfWgV6tO/sKHf5ofUjGOyvLBRQa/GpUVoyNP/awiXjVI30kNrjXLYAmWRqpuE83yxu3Ebl+AAnCZNpz0fVwyaEshaRj3EYmx/sxZr/HEfnO/L0ZaVy1IH5/TwwtNu/W3wMuWmym4t0ZmnfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745886851; c=relaxed/simple;
	bh=s89vn9sB0pME8BKV2D41d5tcrp9Oq8gVpwGbRH8WjSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gw/DutA3hZvItviGbO7yECATlQIYRWp2wEBgvCqR/atxh5hKuOY2gIs0pH4Yqz4SS6I2iFYwgyMTVCTS4cTh3dBnGkFk0CSydn0BGs7iWb9q3zmKeRHz3c5vRDIGu/98Z/BNiUN+gV9KoH1DrT2lAKgYGDieWtwSSBE3GJeKor4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ez+wdCT+; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ez+wdCT+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745886850; x=1777422850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s89vn9sB0pME8BKV2D41d5tcrp9Oq8gVpwGbRH8WjSA=;
  b=Ez+wdCT+OuCQu84dL53ga+sF1GtPkSL4iT3IkToubbHvvGD2FZsZt5Z+
   M4z/b4CEAbtYy1+vPuFbqPdNIzprvQSFlex08R83T85+imOxcuW0xlRTV
   padFDEgiiMAgrJyIiw625/KzJtotZgF2Sir/qpCrZR/Uj5Wz7fO7t+mh4
   MnxhnP+Zi6izl78lAZOjYFs3sySrOH0MOlaW5Wk2fH+orJ1s5HN1dMOYT
   iw18pNG0qijpvYg6W3Z/Tui+c/ZWGKfsYAcpy6dS0JHKV6D6ohB+UDPL5
   d97q15L/m3Xm9ed3yPlIuvmhiLQLe/ct8kpEb28AeO1iw7BNvpfQmZ9oW
   A==;
X-CSE-ConnectionGUID: Kg12xBblSLO/XM7RKz2yGg==
X-CSE-MsgGUID: 1TJYgQFET5O/e+anXOLybw==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58148052"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="58148052"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:08 -0700
X-CSE-ConnectionGUID: a2HYZkUQR2K2myOHNarE9w==
X-CSE-MsgGUID: pj3P/77hScSOowQJaZ4xeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="133393958"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:08 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 03/31] fs/resctrl: Clean up rdtgroup_mba_mbps_event_{show,write}()
Date: Mon, 28 Apr 2025 17:33:29 -0700
Message-ID: <20250429003359.375508-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250429003359.375508-1-tony.luck@intel.com>
References: <20250429003359.375508-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These routines hard-code the two legacy mbm events.

Change to allow for other mbm events in the future.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/internal.h    |  4 ++++
 fs/resctrl/ctrlmondata.c | 39 +++++++++------------------------------
 fs/resctrl/monitor.c     | 16 ++++++++++++++++
 3 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index ff89a0ca130e..6029b3285dd3 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -393,6 +393,10 @@ bool closid_allocated(unsigned int closid);
 
 int resctrl_find_cleanest_closid(void);
 
+enum resctrl_event_id resctrl_get_mon_event_by_name(char *name);
+
+char *resctrl_mon_event_name(enum resctrl_event_id evt);
+
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
 int rdtgroup_locksetup_enter(struct rdtgroup *rdtgrp);
 
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index b17b60114afd..53388281ff7d 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -472,26 +472,17 @@ ssize_t rdtgroup_mba_mbps_event_write(struct kernfs_open_file *of,
 	}
 	rdt_last_cmd_clear();
 
-	if (!strcmp(buf, "mbm_local_bytes")) {
-		if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
-			rdtgrp->mba_mbps_event = QOS_L3_MBM_LOCAL_EVENT_ID;
-		else
-			ret = -EINVAL;
-	} else if (!strcmp(buf, "mbm_total_bytes")) {
-		if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
-			rdtgrp->mba_mbps_event = QOS_L3_MBM_TOTAL_EVENT_ID;
-		else
-			ret = -EINVAL;
-	} else {
+	ret = resctrl_get_mon_event_by_name(buf);
+	if (ret < 0 || !resctrl_is_mon_event_enabled(ret) || !resctrl_is_mbm_event(ret)) {
+		rdt_last_cmd_printf("Unsupported event id '%s'\n", buf);
 		ret = -EINVAL;
+	} else {
+		rdtgrp->mba_mbps_event = ret;
 	}
 
-	if (ret)
-		rdt_last_cmd_printf("Unsupported event id '%s'\n", buf);
-
 	rdtgroup_kn_unlock(of->kn);
 
-	return ret ?: nbytes;
+	return ret < 0 ? ret : nbytes;
 }
 
 int rdtgroup_mba_mbps_event_show(struct kernfs_open_file *of,
@@ -502,22 +493,10 @@ int rdtgroup_mba_mbps_event_show(struct kernfs_open_file *of,
 
 	rdtgrp = rdtgroup_kn_lock_live(of->kn);
 
-	if (rdtgrp) {
-		switch (rdtgrp->mba_mbps_event) {
-		case QOS_L3_MBM_LOCAL_EVENT_ID:
-			seq_puts(s, "mbm_local_bytes\n");
-			break;
-		case QOS_L3_MBM_TOTAL_EVENT_ID:
-			seq_puts(s, "mbm_total_bytes\n");
-			break;
-		default:
-			pr_warn_once("Bad event %d\n", rdtgrp->mba_mbps_event);
-			ret = -EINVAL;
-			break;
-		}
-	} else {
+	if (rdtgrp)
+		seq_printf(s, "%s\n", resctrl_mon_event_name(rdtgrp->mba_mbps_event));
+	else
 		ret = -ENOENT;
-	}
 
 	rdtgroup_kn_unlock(of->kn);
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index ef33970166af..625cd328c790 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -869,6 +869,22 @@ bool resctrl_is_mon_event_enabled(enum resctrl_event_id evtid)
 	return evtid < QOS_NUM_EVENTS && mon_event_all[evtid].enabled;
 }
 
+enum resctrl_event_id resctrl_get_mon_event_by_name(char *name)
+{
+	enum resctrl_event_id evt;
+
+	for (evt = 0; evt < QOS_NUM_EVENTS; evt++)
+		if (mon_event_all[evt].name && !strcmp(name, mon_event_all[evt].name))
+			return evt;
+
+	return -EINVAL;
+}
+
+char *resctrl_mon_event_name(enum resctrl_event_id evt)
+{
+	return evt < QOS_NUM_EVENTS && mon_event_all[evt].name ? mon_event_all[evt].name : "unknown";
+}
+
 /*
  * Initialize the event list for the resource.
  *
-- 
2.48.1

