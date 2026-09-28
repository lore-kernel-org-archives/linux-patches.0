Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AAC4908DD
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 22:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790633754; cv=none; b=lHLwYUwoJ5UFgxjmnGg1YN6ZrP2DsJU67xjBJlN1cgYAU109D1UfkdqVdmwWrtlsXtiaHBFmYr2YulcHw7kiGCrHdu7a8ZFF6wGDHEPCe2eK6/HiL9rR0H/YKf+sjGuG1m2av+JaLNG+uToJCl7AuZJWlAGboh2DNji5dfeo1mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790633754; c=relaxed/simple;
	bh=sNszKQchq7cQtxcVzIVlVMf/t28mnexgBL7l5QdwTD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4rPX29r0ZQEJk7usekd6puzB3M+yy0dvew9PhwdpJpht94g4SPFr4x1LyGF+YbtyUwys+XG1ngNpFsZTcNbddaasVcBFkDA4nut0yDFgaM1QJpkxrVARGz1PPpCkJHsi2oOiry39uzenRP2JmucHhRh02Q2D5s/iY60vzC1WLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lbOJr5Sp; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lbOJr5Sp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790633748; x=1822169748;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sNszKQchq7cQtxcVzIVlVMf/t28mnexgBL7l5QdwTD8=;
  b=lbOJr5SpC0XZmo4qvPWDoipNy2m+er+9rhtatIAMGHOvPcamsqRoXzDF
   MFoGKjckrPa4LS03ZlY0v10r+IBSya/t7UnFiYa7g/MuEhAjTJcqHTA8P
   P4/2RaohhzonZam5tqqMoz86RU64YbRRCE+FHVFP3JZZYuiubkhXcsBOL
   QdmWEZvzMqd1i5I7Sb/D+JWGAu3LpQe2s33ad6iFvC51hPWYyc/GbJmYT
   l9qy4YQgkI/iqJK+oBdNMfTiaODLGdzUxg3tOKKUHGvi6ORHovtC8eOqM
   o3eqym0IWf+NBOPfJgUGvO7jUYh5nyDxTlua5cy4WOU7yuRlQ9hw8Mfmc
   g==;
X-CSE-ConnectionGUID: BoC/Qn5yTh2+72KWT2zU7g==
X-CSE-MsgGUID: kzMjB0dXSZu6/D+nv5FSKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="90387300"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="90387300"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:20 -0700
X-CSE-ConnectionGUID: wCu6PmXSTmuqO44FlsoJvg==
X-CSE-MsgGUID: RxHkCz3WQLC20lcfg2FSlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="274685517"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.143])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:19 -0700
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
Subject: [PATCH v13 16/25] x86/resctrl: Add PMT registration API for AET enumeration callbacks
Date: Mon, 28 Sep 2026 15:15:00 -0700
Message-ID: <20260928221509.68002-17-tony.luck@intel.com>
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

resctrl is always built-in but needs to call into the pmt_telemetry
code to enumerate Application Energy Telemetry (AET) features. Requiring
CONFIG_INTEL_PMT_TELEMETRY=y allows these calls to work.

In preparation for allowing pmt_telemetry to be built as a module, add
and export register/unregister functions. pmt_telemetry can then supply
and clear the enumeration callbacks as it is loaded and unloaded.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v13:
	Rewrote commit message using correct context at this point in the series.
	Use "pmt_telemetry" throughout.
---
 include/linux/intel_vsec.h              | 12 ++++++++++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 24 ++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/linux/intel_vsec.h b/include/linux/intel_vsec.h
index 843cda8f8644..c04b1d0f3143 100644
--- a/include/linux/intel_vsec.h
+++ b/include/linux/intel_vsec.h
@@ -257,4 +257,16 @@ static inline void
 intel_pmt_put_feature_group(struct pmt_feature_group *feature_group) {}
 #endif
 
+#ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
+void intel_aet_register_enumeration(struct module *module,
+				    struct pmt_feature_group *(*get)(enum pmt_feature_id id),
+				    void (*put)(struct pmt_feature_group *p));
+void intel_aet_unregister_enumeration(void);
+#else
+static inline void intel_aet_register_enumeration(struct module *module,
+						  struct pmt_feature_group *(*get)(enum pmt_feature_id id),
+						  void (*put)(struct pmt_feature_group *p)) { }
+static inline void intel_aet_unregister_enumeration(void) { }
+#endif /* CONFIG_X86_CPU_RESCTRL_INTEL_AET */
+
 #endif
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 4ad6ad78e93e..6c4f0bf3b876 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -17,12 +17,14 @@
 #include <linux/cpumask.h>
 #include <linux/err.h>
 #include <linux/errno.h>
+#include <linux/export.h>
 #include <linux/gfp_types.h>
 #include <linux/init.h>
 #include <linux/intel_pmt_features.h>
 #include <linux/intel_vsec.h>
 #include <linux/io.h>
 #include <linux/minmax.h>
+#include <linux/module.h>
 #include <linux/printk.h>
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
@@ -291,6 +293,10 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
 	return FEATURE_INVALID;
 }
 
+static struct module *pmt_module;
+static struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
+static void (*put_feature)(struct pmt_feature_group *p);
+
 /*
  * Request a copy of struct pmt_feature_group for each event group. If there is
  * one, the returned structure has an array of telemetry_region structures,
@@ -325,6 +331,24 @@ bool intel_aet_get_events(void)
 	return ret;
 }
 
+void intel_aet_register_enumeration(struct module *module,
+				    struct pmt_feature_group *(*get)(enum pmt_feature_id id),
+				    void (*put)(struct pmt_feature_group *p))
+{
+	get_feature = get;
+	put_feature = put;
+	pmt_module = module;
+}
+EXPORT_SYMBOL_NS_GPL(intel_aet_register_enumeration, "INTEL_PMT");
+
+void intel_aet_unregister_enumeration(void)
+{
+	pmt_module = NULL;
+	get_feature = NULL;
+	put_feature = NULL;
+}
+EXPORT_SYMBOL_NS_GPL(intel_aet_unregister_enumeration, "INTEL_PMT");
+
 void __exit intel_aet_exit(void)
 {
 	struct event_group **peg;
-- 
2.55.0

