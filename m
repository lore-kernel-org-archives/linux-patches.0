Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2F55038F9
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 22:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790633752; cv=none; b=tkYoIDDUWu66BRQK93eHUVeJN5uNlAHZrzytYcc8+FaRTNc8AtTxOyRuogFS++9e5AUqYtbCPB5TFZTsmWCY1mDKylsIJ8Yic8MC+sf8XLbRhiKT/ccckqkx4qVZBiAXw86zpB8kLMVZCFqMcLciiPTA2HCSv+Ku76e77D10yxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790633752; c=relaxed/simple;
	bh=zarMUfTCpUXp7DLByEJr+/FZe1A/4v8sWeebaBH7CyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIzMhYZ8B3C4DCZQH1GB36Sso86RoXxzlQgwmsu7pOnekR658zK8lYiAfYFahwsvjz/P05vQh+9xLDuV3fTTzILOvZ2kc5neXlx/gDzPMwAjGHAeIdLezBFH0bwvzYgbnsI/H94PRgPDzV1obtCevzQ2akEkImtxz92PkCK5pEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H9pbHX9w; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H9pbHX9w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790633750; x=1822169750;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zarMUfTCpUXp7DLByEJr+/FZe1A/4v8sWeebaBH7CyA=;
  b=H9pbHX9wUXN/Ft3Q6b8LQ5dWuI9As6FgOsdw/IX20F/ZhXrwaKLdxjmr
   n/IB+Ab2tJJUz9njhumfj2/jz66Q5DeF38gp6+at95wNGbG8nfpdInde+
   NGviqluc/ua2KUJxjdIJDWvC9zhSHclinUSX1F6ofO3+fUb+rVduSULgw
   i5o5PlgeeIRn0j5/mAz6vA6Ophzz5PRRzcVx6bs0wVj6AlL+WZMXfnwXT
   b5cxAGm9ifHLz2N8xdoxhEBbStapyuuxBgA/Mj4+XDJRClNs1GVQRzKwE
   fWZuplcDe06HkRR06yHGuUKmxbaz9QjYsr5DwWKKXEV/8HPi8m/PO9DgW
   Q==;
X-CSE-ConnectionGUID: V806aUT9RviFg0be00jFYQ==
X-CSE-MsgGUID: Wpcpu+/OQ56Z6tCWNHd2ig==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="90387349"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="90387349"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:21 -0700
X-CSE-ConnectionGUID: gazdNe4hSoKSh0EZ+pTfWA==
X-CSE-MsgGUID: xtB1eP38Sy6Nbd7iXX/13g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="274685538"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.143])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:20 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v13 21/25] x86/resctrl: Export interface to report telemetry unbind/remove
Date: Mon, 28 Sep 2026 15:15:05 -0700
Message-ID: <20260928221509.68002-22-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928221509.68002-1-tony.luck@intel.com>
References: <20260928221509.68002-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linux allows devices to be unbound from drivers, even if the modules
cannot be unloaded because of reference counts.

For telemetry this results in teardown of the virtual address mappings
of the MMIO regions which hold the event counters. Subsequent access
to these counters will page fault.

Export intel_aet_invalidate() for the pmt_telemetry module to inform
resctrl when invalidation is about to happen.

The mount time call from aet_get_events() to the pmt_telemetry module holds
the existing aet_register_lock and then acquires ep_lock establishing
the lock hierarchy.

The pmt_telemetry module will need to call intel_aet_invalidate() while
holding the ep_lock. If intel_aet_invalidate() tried to use aet_register_lock
for locking it would create an A-B B-A deadlock.

Add a new mutex to protect telemetry_region::addr from simultaneous
invalidation and use by intel_aet_read_event().

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v13:
	Dropped telemetry_region::addr from list of things protected
	by aet_register_lock.

	Declare and use aet_mmio_lock in this patch instead of next one.

	Explain the reason for the new lock.
---
 include/linux/intel_vsec.h              |  2 ++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 29 +++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/linux/intel_vsec.h b/include/linux/intel_vsec.h
index c04b1d0f3143..bcbf4937c71c 100644
--- a/include/linux/intel_vsec.h
+++ b/include/linux/intel_vsec.h
@@ -262,11 +262,13 @@ void intel_aet_register_enumeration(struct module *module,
 				    struct pmt_feature_group *(*get)(enum pmt_feature_id id),
 				    void (*put)(struct pmt_feature_group *p));
 void intel_aet_unregister_enumeration(void);
+void intel_aet_invalidate(u8 package_id);
 #else
 static inline void intel_aet_register_enumeration(struct module *module,
 						  struct pmt_feature_group *(*get)(enum pmt_feature_id id),
 						  void (*put)(struct pmt_feature_group *p)) { }
 static inline void intel_aet_unregister_enumeration(void) { }
+static inline void intel_aet_invalidate(u8 package_id) { }
 #endif /* CONFIG_X86_CPU_RESCTRL_INTEL_AET */
 
 #endif
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index e64e5a44511f..59066e1c6333 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -308,6 +308,9 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
  */
 static DEFINE_MUTEX(aet_register_lock);
 
+/* Protects telemetry_region::addr. */
+static DEFINE_MUTEX(aet_mmio_lock);
+
 static struct module *pmt_module;
 static struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
 static void (*put_feature)(struct pmt_feature_group *p);
@@ -371,6 +374,30 @@ void intel_aet_unregister_enumeration(void)
 }
 EXPORT_SYMBOL_NS_GPL(intel_aet_unregister_enumeration, "INTEL_PMT");
 
+/*
+ * pmt_telemetry driver calls this for unbind/remove operations that
+ * will invalidate the virtual addresses of MMIO registers provided
+ * by intel_pmt_get_regions_by_feature().
+ */
+void intel_aet_invalidate(u8 package_id)
+{
+	struct event_group **peg;
+
+	guard(mutex)(&aet_mmio_lock);
+
+	for_each_event_group(peg) {
+		struct event_group *e = *peg;
+
+		if (!e->pfg)
+			continue;
+		for (int i = 0; i < e->pfg->count; i++) {
+			if (e->pfg->regions[i].plat_info.package_id == package_id)
+				e->pfg->regions[i].addr = NULL;
+		}
+	}
+}
+EXPORT_SYMBOL_NS_GPL(intel_aet_invalidate, "INTEL_PMT");
+
 bool intel_aet_pre_mount(void)
 {
 	guard(mutex)(&aet_register_lock);
@@ -435,6 +462,8 @@ int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 	void *pevt0;
 	u32 idx;
 
+	guard(mutex)(&aet_mmio_lock);
+
 	pevt0 = pevt - pevt->idx;
 	e = container_of(pevt0, struct event_group, evts);
 	idx = rmid * e->num_events;
-- 
2.55.0

