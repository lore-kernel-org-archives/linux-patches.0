Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954433914E2
	for <patches@lists.linux.dev>; Wed, 29 Jul 2026 17:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785346094; cv=none; b=d8xOoDs0rF04355danBi02gDqMuq7C50Y1EJUE83b/XvPbSH2bUg0oPXnKfafc5Z4NovK1BbHtGkYwcGLBUz6jZ7GD9gd72jdj5hyM1U8eUvrMNA1VhO64a/ehL3mYOyGMUoRA3MmiJTNYKDYQ+K/b+J5hjklynhvxgvPPTLPtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785346094; c=relaxed/simple;
	bh=iInLczJVZpheVwDr4rEXHLOGHettNkNVQv8dhk6hc0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eeAnUeE3k7f9TUd5xWChQYm/ttSgFuJk7wJYoEMTaK20BE73YsuWupk6fnUd9hLpFd5pqsLidkBtxc6lo88Y1pJtUm2eoHzIUKyzpflIUMaHuY36cdinsIlnxWZI8SlG92xWSkSeNsuSKqqZ19D54oM/P3NOLLBYtjChzgEpSlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fy2/E/ui; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fy2/E/ui"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785346092; x=1816882092;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iInLczJVZpheVwDr4rEXHLOGHettNkNVQv8dhk6hc0A=;
  b=fy2/E/uiNGfU5Pa4W10CbcINXwe8DqAPvrRFNUHZInlzOKzWeH3/fnl0
   enPVAlJKdcDfH8iYlp8Bysskc7nK7w6+E+u5ELP5XYirjXv8WbgNG6KfM
   CPXI8Rp5FML1zUqv2JYawbPytF1v4S0GY7CquTOhGRT0i7WpZlk5BzuFG
   Y+cIfxmMJWiRCtVDkyzD0CwyVpeQKWr5hmqi7wellOynayVV8gDSxS85B
   smhYkCd5ObgRYVUL/8BN57goWdQDzyHeIMiAr92GYumX/5z3mLlxArX7y
   CDPEC66winQcD8/WsS5PE7F8KbfmQPKKBaf34j0BzJWTf8C4iKXzgLdEZ
   Q==;
X-CSE-ConnectionGUID: myBhJ7zETs2Qsy/lOXPxxw==
X-CSE-MsgGUID: nbQu6a+LSOSCt6nDdmwL1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="97473687"
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="97473687"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:03 -0700
X-CSE-ConnectionGUID: 8uUz5WhWTYaYOu+dWOl00A==
X-CSE-MsgGUID: jP+rPX0FTDOGVSkBS6O51A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="262024615"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.238])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:03 -0700
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
Subject: [PATCH v10 14/17] x86/resctrl: Export interface to report telemetry unbind/remove
Date: Wed, 29 Jul 2026 10:27:49 -0700
Message-ID: <20260729172752.11561-15-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729172752.11561-1-tony.luck@intel.com>
References: <20260729172752.11561-1-tony.luck@intel.com>
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
v10:
	New patch

 include/linux/intel_vsec.h              |  2 ++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 34 +++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/linux/intel_vsec.h b/include/linux/intel_vsec.h
index c04b1d0f3143..4da15ec03d20 100644
--- a/include/linux/intel_vsec.h
+++ b/include/linux/intel_vsec.h
@@ -262,11 +262,13 @@ void intel_aet_register_enumeration(struct module *module,
 				    struct pmt_feature_group *(*get)(enum pmt_feature_id id),
 				    void (*put)(struct pmt_feature_group *p));
 void intel_aet_unregister_enumeration(void);
+void intel_aet_invalidate(u64 pkgmask);
 #else
 static inline void intel_aet_register_enumeration(struct module *module,
 						  struct pmt_feature_group *(*get)(enum pmt_feature_id id),
 						  void (*put)(struct pmt_feature_group *p)) { }
 static inline void intel_aet_unregister_enumeration(void) { }
+static inline void intel_aet_invalidate(u64 pkgmask) { }
 #endif /* CONFIG_X86_CPU_RESCTRL_INTEL_AET */
 
 #endif
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 65b70cc8d0a5..eab27e487da9 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -177,6 +177,11 @@ static bool skip_telem_region(struct telemetry_region *tr, struct event_group *e
 			tr->guid);
 		return true;
 	}
+	if (tr->plat_info.package_id >= BITS_PER_LONG_LONG) {
+		pr_warn("Package %u out of range in guid 0x%x\n", tr->plat_info.package_id,
+			tr->guid);
+		return true;
+	}
 	if (tr->size != e->mmio_size) {
 		pr_warn("MMIO space wrong size (%zu bytes) for guid 0x%x. Expected %zu bytes.\n",
 			tr->size, e->guid, e->mmio_size);
@@ -299,6 +304,13 @@ static struct module *pmt_module;
 static struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
 static void (*put_feature)(struct pmt_feature_group *p);
 
+/*
+ * Bitmask of packages where MMIO virtual mappings have been invalidated
+ * by device unbind/remove operations. May be set to ~0ULL to indicate that
+ * all mappings may have been removed.
+ */
+static u64 invalid_pkg_mask;
+
 /*
  * Request a copy of struct pmt_feature_group for each event group. If there is
  * one, the returned structure has an array of telemetry_region structures,
@@ -373,6 +385,18 @@ void intel_aet_unregister_enumeration(void)
 }
 EXPORT_SYMBOL_NS_GPL(intel_aet_unregister_enumeration, "INTEL_PMT");
 
+/*
+ * pmt_telemetry driver calls this for unbind/remove operations that
+ * will invalidate the virtual addresses of MMIO registers provided
+ * by intel_pmt_get_regions_by_feature().
+ */
+void intel_aet_invalidate(u64 pkgmask)
+{
+	guard(mutex)(&aet_register_lock);
+	invalid_pkg_mask |= pkgmask;
+}
+EXPORT_SYMBOL_NS_GPL(intel_aet_invalidate, "INTEL_PMT");
+
 bool intel_aet_pre_mount(void)
 {
 	guard(mutex)(&aet_register_lock);
@@ -389,6 +413,11 @@ bool intel_aet_pre_mount(void)
 	}
 
 	pmt_in_use = true;
+	/*
+	 * All the regions enumerated by intel_pmt_get_regions_by_feature()
+	 * have valid MMIO mappings.
+	 */
+	invalid_pkg_mask = 0ULL;
 
 	return true;
 }
@@ -436,6 +465,11 @@ int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 	void *pevt0;
 	u32 idx;
 
+	guard(mutex)(&aet_register_lock);
+
+	if (invalid_pkg_mask == ~0ULL || (invalid_pkg_mask & BIT_ULL(domid)))
+		return -EINVAL;
+
 	pevt0 = pevt - pevt->idx;
 	e = container_of(pevt0, struct event_group, evts);
 	idx = rmid * e->num_events;
-- 
2.55.0

