Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F51B54CF54
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 23:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600435; cv=none; b=nFKrL7cEwQUdrT+Jkft0VYvw8QZsC/CNfsq09tawHPhINqOMvSFAl1Mki7wGkhOYYVXtrbae7Jd2bUGJrDF3kSkltUwkPG05TcKHncae8hPQBBZ0a4p/eqIHYU+UCJy+oZG9JRh/cTnix39v/SP6UK8tFRWe/J6bcSBmk/4DjPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600435; c=relaxed/simple;
	bh=lRVnP8afGZ4YUcFwYEKeR0nKKES4JnyPNa7s7rP6ep8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njqLQ/g6hMvc0iOsL5JKVQim74OETsDTQFOPyi5rS42WDs43X8/xADWs5IAuNTqoL9ps9h5KfrTqwK6CN/ftD90r+QSA1tqhMSIzDn3tEKdT3JdLsY5O6h1IrUyl7GIo67INpUENSV4aNhfttvUoESASFhkomSURWc5Cu3JxDLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XwJt0caA; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XwJt0caA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789600433; x=1821136433;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lRVnP8afGZ4YUcFwYEKeR0nKKES4JnyPNa7s7rP6ep8=;
  b=XwJt0caAS1nuaN1bndJJHLZpRDz+gVk7OYECGYDDnptDMPMgnDWOEXVj
   H5ZjjjIQ4S/amNsbtEp8Y9klbvaEqhmN51OGiBfOjMwbZwK7nBrQEUtBY
   kh4uRhCJrAHIGTIreSCpAkk9ZIbn7SrObVQ5LQ2kKKp9aEJuvaQHFIzsH
   VS5mg3ptRpvL+QtTFAezeVfED8neZotGJOAmdH8iMIThhq3npfBhUfNoL
   RG7YOEo28gyUMwGk92IuIDaJrXEA4gfFmAiZg49u6XTvNvxVBACs8XrJz
   Ri9kb9pDqJmX1ueMl7ZdHIvbjT4ugrrvE/+MMGqFnUWbHzPcaBuAYc4Wo
   w==;
X-CSE-ConnectionGUID: ytaIFQNJSCqxNm0SOKAIxQ==
X-CSE-MsgGUID: nF9uERg9R7Gw0szyNYu68Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93861508"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93861508"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:40 -0700
X-CSE-ConnectionGUID: jwP6xT9wSMO9d8sJ/h7dJg==
X-CSE-MsgGUID: 7NzeNJXoRsS8WaEOc78FAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="277231496"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.219])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:39 -0700
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
Subject: [PATCH v12 21/25] x86/resctrl: Export interface to report telemetry unbind/remove
Date: Wed, 16 Sep 2026 16:13:16 -0700
Message-ID: <20260916231320.14502-22-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916231320.14502-1-tony.luck@intel.com>
References: <20260916231320.14502-1-tony.luck@intel.com>
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
v12:
	Update comment on aet_register_lock
---
 include/linux/intel_vsec.h              |  2 ++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 28 ++++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

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
index 8aa2e18a6bbb..1fd25fd9cd96 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -298,7 +298,7 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
 /*
  * Protects pmt_module, get_feature, put_feature against races between module
  * load/unload of the pmt_telemetry module and mount/unmount of the resctrl
- * file system. Also protects pmt_in_use.
+ * file system. Also protects pmt_in_use telemetry_region::addr.
  */
 static DEFINE_MUTEX(aet_register_lock);
 
@@ -365,6 +365,30 @@ void intel_aet_unregister_enumeration(void)
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
@@ -428,6 +452,8 @@ int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 	void *pevt0;
 	u32 idx;
 
+	guard(mutex)(&aet_register_lock);
+
 	pevt0 = pevt - pevt->idx;
 	e = container_of(pevt0, struct event_group, evts);
 	idx = rmid * e->num_events;
-- 
2.55.0

