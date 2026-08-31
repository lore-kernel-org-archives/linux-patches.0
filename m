Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4650F47ECF4
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 17:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198290; cv=none; b=fulr128JW1uRzhmifk9Q+k/yqnmqI46oH7xKKNQg6+seX3E6tYspjBWYvv1HqqmOBiPTBaMBHpUlN9bhBD4EyhDlA1GIKpOzSZiVy/O2ysWZXgDGpOlBh1C0EyhEAQ+o2gugcXmj7TafaXTBFxcTFuNxGq/Ocv2Kr8744QI8vLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198290; c=relaxed/simple;
	bh=wjiIbxvlTPGpNhMc3Vf+qB97b6a0iwGAeSDd/i6ui+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+MnO2cXT4i3lgCxkd5GWEjS6N4HF9drQ+6OD21/7yDxbh/FLNd5auPRQerVOKXEe+bYiNxl7dRK+IqqvEsg9HTgb/x9Z4K2cK7CvCFiBaucmST1LPAQ91NnLfcNTyW7csGALupWBdsufpKLCifREHz5tm1O99knlGTEV1is2oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ezffF7vH; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ezffF7vH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788198287; x=1819734287;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wjiIbxvlTPGpNhMc3Vf+qB97b6a0iwGAeSDd/i6ui+4=;
  b=ezffF7vHb/tp03zm0fxXU5k1Ph78K+zNJrVUwfNHyuhw0e9BamC2hmMN
   pzCFasYJMqU/sFc93qQdabbeuY4ff9PXYE7hc0winu/lf6etzHsRy+IlI
   yqh6OckUrm5WDCgA7hXs/Bj8sK53jdE9zsTXjzn8UV63yxdGyDrLmNkLw
   KdB6lCAPGbH9gZPBJdHTNPfr1JOWpESZaSxXvVDO1px+J19wKYervb/5h
   zplkQixMYBrzHSUVEVK8YLqqIBgBD/oW4P46p9j1/aeKzbg4sTlYcoLgs
   H4sGx5jQZArnaEMwNZ88sqwSlP5cb5JVcY9+2Da6V+KPvRWIpSSw67ECQ
   Q==;
X-CSE-ConnectionGUID: l0mBR345SLukROVf0Cpu6w==
X-CSE-MsgGUID: SLc6oIcISLaqQaCHBRfDFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="92480093"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="92480093"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:42 -0700
X-CSE-ConnectionGUID: 2JICnY5rRpmdZIzEiu/tGQ==
X-CSE-MsgGUID: 8ZkJJ4UvT9We3cHfoxFi/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="268907018"
Received: from aherrold-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.17])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:41 -0700
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
Subject: [PATCH v11 19/23] x86/resctrl: Export interface to report telemetry unbind/remove
Date: Mon, 31 Aug 2026 10:44:17 -0700
Message-ID: <20260831174421.13921-20-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831174421.13921-1-tony.luck@intel.com>
References: <20260831174421.13921-1-tony.luck@intel.com>
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

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v11:
	Replace bitpmap argument to intel_aet_invalidate() with
	package_id. David Box confirmed that unbind/remove operations
	do not cross package boundaries.
	Mark invalidated event counters by clearing "addr".

 include/linux/intel_vsec.h              |  2 ++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

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
index c3bd3536c514..5cd2711d00e7 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -376,6 +376,29 @@ void intel_aet_unregister_enumeration(void)
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
+	guard(mutex)(&aet_register_lock);
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
@@ -439,6 +462,8 @@ int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 	void *pevt0;
 	u32 idx;
 
+	guard(mutex)(&aet_register_lock);
+
 	pevt0 = pevt - pevt->idx;
 	e = container_of(pevt0, struct event_group, evts);
 	idx = rmid * e->num_events;
-- 
2.55.0

