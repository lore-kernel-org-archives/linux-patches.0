Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F14F2E425D
	for <patches@lists.linux.dev>; Mon, 11 Aug 2025 18:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754936268; cv=none; b=su+b9ZWfmmcQGIbhykhmOgUR+kduBnPoQ4cfgnSNKvZUJHKUfxPSe1wJ/SXoRLB2PUpEeO70e7e3F73+t0HCrwidVEI+IbRjSOCx5Ma8S+uh3BHdhfAOU9QHdWf+jYwQ1C//olzSiZCn6PAwA9E9S80DBAiLc4+M7M/1RwFrzaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754936268; c=relaxed/simple;
	bh=fcNC4h2TEkm1ATe2ICOxIcVqPMlso311x+so9qRG1J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTGwC1BQu0xPYUEUORXja0Leb53W9/UEoLW+B4e9wj2e2sc8Rkp85OZH//IaG44n2A6oMu/yniWL1V6wjn32uEv2hsog5f+xI6IGkHqDY4HM06Fh1uas1JE6JYls2yK5sPg1c57WaNyYoKf94j8uUZzPX8F/gF7vAaEWEM6LOUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TZ8bNYTX; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TZ8bNYTX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754936267; x=1786472267;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fcNC4h2TEkm1ATe2ICOxIcVqPMlso311x+so9qRG1J4=;
  b=TZ8bNYTXK16nKECyhSno2+MSd6vaqkDX6gAX5dgXlHqkKtD11iol/uwi
   fO2O3o8LTmpLiRa7bYsZKWJ7GJY79O01+uEwjkBYHTd1uGfpxja16cNw+
   oZ2SfsH1xVrOQtEo35knkA6J9TFXrXRzvyFNC6SvggsQB7WHNE4vSAwvA
   Jy/31jFWfxlvuk1w8vzQXNpvIPIR59E+flbe6Qs3gQ0MfKCKwus8Yld7J
   M7Uf7sZkMrv3hK5FxRKY409knZhXC9CLMFa14a6CKfD4APKCZXwHzvMn7
   RgEjDJPgmxBn4du2m76z6Do8mt+NSK6/WlrfvFipEVGDUVSm3v4fYRNqs
   Q==;
X-CSE-ConnectionGUID: GSygI7q3T5GOCQBY8cVkSg==
X-CSE-MsgGUID: E6EN3s6yThCfRzLqEy1mSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="68277451"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68277451"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:27 -0700
X-CSE-ConnectionGUID: B/1Jy3UvTYu4Ka7d1Mo80g==
X-CSE-MsgGUID: Iz8qZpK0TY2BtOEEAORk7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="196825687"
Received: from puneetse-mobl.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.229])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:25 -0700
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
Subject: [PATCH v8 22/32] x86/resctrl: Read telemetry events
Date: Mon, 11 Aug 2025 11:16:56 -0700
Message-ID: <20250811181709.6241-23-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811181709.6241-1-tony.luck@intel.com>
References: <20250811181709.6241-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Telemetry events are enumerated by the INTEL_PMT_TELEMETRY subsystem.
resctrl enables events with resctrl_enable_mon_event() passing a pointer
to the pmt_event structure for the event within the struct event_group.
The file system stores it in mon_evt::arch_priv.

Add a check to resctrl_arch_rmid_read() for resource id
RDT_RESOURCE_PERF_PKG and directly call intel_aet_read_event()
passing the enum resctrl_event_id for the event and the arch_priv
pointer that was supplied when the event was enabled.

There may be multiple aggregators tracking each package, so scan all of
them and add up all counters.

Resctrl now uses readq() so depends on X86_64. Update Kconfig.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  |  7 ++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 44 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c   |  3 ++
 arch/x86/Kconfig                        |  2 +-
 4 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 710493ec6548..b2f0769f63f6 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -172,9 +172,16 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
 bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
+int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,
+			 void *arch_priv, u64 *val);
 #else
 static inline bool intel_aet_get_events(void) { return false; }
 static inline void __exit intel_aet_exit(void) { }
+static inline int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,
+				       void *arch_priv, u64 *val)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index dbd317e99ee0..5d49ed446b94 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -14,6 +14,7 @@
 #include <linux/cleanup.h>
 #include <linux/cpu.h>
 #include <linux/intel_vsec.h>
+#include <linux/io.h>
 #include <linux/resctrl.h>
 #include <linux/slab.h>
 
@@ -211,6 +212,9 @@ static int discover_events(struct event_group *e, struct pmt_feature_group *p)
 
 	list_add(&e->list, &active_event_groups);
 
+	for (int i = 0; i < e->num_events; i++)
+		resctrl_enable_mon_event(e->evts[i].id, true, e->evts[i].bin_bits, &e->evts[i]);
+
 	return 0;
 }
 
@@ -278,3 +282,43 @@ void __exit intel_aet_exit(void)
 		list_del(&evg->list);
 	}
 }
+
+#define DATA_VALID	BIT_ULL(63)
+#define DATA_BITS	GENMASK_ULL(62, 0)
+
+/*
+ * Read counter for an event on a domain (summing all aggregators
+ * on the domain).
+ */
+int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id eventid,
+			 void *arch_priv, u64 *val)
+{
+	struct pmt_event *pevt = arch_priv;
+	struct pkg_mmio_info *mmi;
+	struct event_group *e;
+	bool valid = false;
+	u64 evtcount;
+	void *pevt0;
+	int idx;
+
+	pevt0 = pevt - pevt->idx;
+	e = container_of(pevt0, struct event_group, evts);
+	idx = rmid * e->num_events;
+	idx += pevt->idx;
+	mmi = e->pkginfo[domid];
+
+	if (idx * sizeof(u64) + sizeof(u64) > e->mmio_size) {
+		pr_warn_once("MMIO index %d out of range\n", idx);
+		return -EIO;
+	}
+
+	for (int i = 0; i < mmi->num_regions; i++) {
+		evtcount = readq(mmi->addrs[i] + idx * sizeof(u64));
+		if (!(evtcount & DATA_VALID))
+			continue;
+		*val += evtcount & DATA_BITS;
+		valid = true;
+	}
+
+	return valid ? 0 : -EINVAL;
+}
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 185b203f6321..51d7d99336c6 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -232,6 +232,9 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 
 	resctrl_arch_rmid_read_context_check();
 
+	if (r->rid == RDT_RESOURCE_PERF_PKG)
+		return intel_aet_read_event(hdr->id, rmid, eventid, arch_priv, val);
+
 	if (r->rid != RDT_RESOURCE_L3)
 		return -EINVAL;
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 56f0ff94c430..32beb66f0a92 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -527,7 +527,7 @@ config X86_CPU_RESCTRL
 
 config X86_CPU_RESCTRL_INTEL_AET
 	bool "Intel Application Energy Telemetry" if INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
-	depends on X86_CPU_RESCTRL && CPU_SUP_INTEL
+	depends on X86_64 && X86_CPU_RESCTRL && CPU_SUP_INTEL
 	help
 	  Enable per-RMID telemetry events in resctrl
 
-- 
2.50.1

