Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D097530DE2
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 23:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600432; cv=none; b=PtGX+3XImbz+zQPaTw5AIfG4L4B8oNhSZQtunNFXG2QtaISNbYfklItkVFGh0sirINbJagBTEhZFuruNmYbs5Ix1Lh/D0u0WooZxBLDiHJu+xo3NM8hxiayFlTAtXxjHNaY49IkFEPC2vkNZWnmdHNfXdCO5KCEYsFdsChWSOQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600432; c=relaxed/simple;
	bh=88MyggT5anFVghCVKZ0w5+QpAf7rtxsu67L05dwPj80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnaYYOXcKnl2wR/QWX9H6u29I95IV4LYwlLLkaZ4KKOtDlI7uwxbp+HoKBjK9e8XK/zkB0n1aDbSxutywXf6ZMpzAUMKrqxHObcKZvXzHdoiG6K9DCXOCMhKFESZDTNEdmwmdgWLZYlRxlhuBnyPPGzg47cHJnfTIQWwKtrlQ2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nmtJhHy5; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nmtJhHy5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789600430; x=1821136430;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=88MyggT5anFVghCVKZ0w5+QpAf7rtxsu67L05dwPj80=;
  b=nmtJhHy5kgxDxisEBgL7o+nkTuCQrIUqtDjZwSeNEOEM8G/BRxzZkcb1
   F0U7WiYZim/u/Bxkd9EqYTneCESk2vmYIyGgzvP77756bhdg3fyWCf2kg
   LG5IlzbE/+ygaWz9blh7vIga6DffVGZxdKLfEpE81WTRW5SC7SSfRufNa
   flNTJ81HnkpH7EAFbLFuyaYNN4vkKVUZE8LuAcbHOksEe97j+ee77b9VP
   BgjmVRd0nqTQ6DuqNbG9MpWzxFDEM8q5H5mMCXDe13HriyLta/QRHDe/t
   6Vc9P9+T2yv2NRedAIXzG8c7rwLowZsFMmomyeu1bG2qBo0kDiQZhlkkp
   Q==;
X-CSE-ConnectionGUID: zWPI0sLmRfmWdoJITgpORg==
X-CSE-MsgGUID: zJPrkOnyRAWq6tzK9mCiMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93861480"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93861480"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:38 -0700
X-CSE-ConnectionGUID: 6dMgICLWQxO+TY6mgYv3kw==
X-CSE-MsgGUID: ym67Hz2BRTWrsNrJTcOuTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="277231486"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.219])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:38 -0700
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
Subject: [PATCH v12 18/25] x86/resctrl: Use registered function pointers for AET enumeration
Date: Wed, 16 Sep 2026 16:13:13 -0700
Message-ID: <20260916231320.14502-19-tony.luck@intel.com>
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

The INTEL_PMT_TELEMETRY driver registers enumeration functions with
resctrl Application Energy Telemetry (AET) code.

Use the function pointers instead of direct function calls in
preparation for the telemetry driver to be a loadable module.

In preparation for enumeration on each mount of the resctrl file system
place a hold on the pmt_telemetry module while enumerating AET events during
pre-mount processing. Release the hold if no events were enabled. This hold
will be released when the per-mount code is added.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v12:
	Split from part 17
---
 arch/x86/kernel/cpu/resctrl/internal.h  |  4 +--
 arch/x86/kernel/cpu/resctrl/core.c      |  2 +-
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 35 ++++++++++++++++++++++---
 3 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index d70c8cb1cb81..fc60b0af250d 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -234,15 +234,15 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 
 #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
-bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
+bool intel_aet_pre_mount(void);
 int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
 void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 				struct list_head *add_pos);
 bool intel_handle_aet_option(bool force_off, char *tok);
 #else
-static inline bool intel_aet_get_events(void) { return false; }
 static inline void __exit intel_aet_exit(void) { }
+static inline bool intel_aet_pre_mount(void) { return false; }
 static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 {
 	return -EINVAL;
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index addcb2a19c98..2fa4ebf7159a 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -795,7 +795,7 @@ void resctrl_arch_pre_mount(void)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	int cpu;
 
-	if (!intel_aet_get_events())
+	if (!intel_aet_pre_mount())
 		return;
 
 	/*
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 6c4f0bf3b876..32f3f30894a4 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -12,6 +12,7 @@
 #define pr_fmt(fmt)   "resctrl: " fmt
 
 #include <linux/bits.h>
+#include <linux/cleanup.h>
 #include <linux/compiler_types.h>
 #include <linux/container_of.h>
 #include <linux/cpumask.h>
@@ -25,6 +26,7 @@
 #include <linux/io.h>
 #include <linux/minmax.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/printk.h>
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
@@ -293,6 +295,13 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
 	return FEATURE_INVALID;
 }
 
+/*
+ * Protects pmt_module, get_feature, put_feature against races between module
+ * load/unload of the pmt_telemetry module and mount/unmount of the resctrl
+ * file system.
+ */
+static DEFINE_MUTEX(aet_register_lock);
+
 static struct module *pmt_module;
 static struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
 static void (*put_feature)(struct pmt_feature_group *p);
@@ -308,7 +317,7 @@ static void (*put_feature)(struct pmt_feature_group *p);
  * struct pmt_feature_group to indicate that its events are successfully
  * enabled.
  */
-bool intel_aet_get_events(void)
+static bool aet_get_events(void)
 {
 	struct pmt_feature_group *p;
 	enum pmt_feature_id pfid;
@@ -317,14 +326,14 @@ bool intel_aet_get_events(void)
 
 	for_each_event_group(peg) {
 		pfid = lookup_pfid((*peg)->pfname);
-		p = intel_pmt_get_regions_by_feature(pfid);
+		p = get_feature(pfid);
 		if (IS_ERR_OR_NULL(p))
 			continue;
 		if (enable_events(*peg, p)) {
 			(*peg)->pfg = p;
 			ret = true;
 		} else {
-			intel_pmt_put_feature_group(p);
+			put_feature(p);
 		}
 	}
 
@@ -335,6 +344,7 @@ void intel_aet_register_enumeration(struct module *module,
 				    struct pmt_feature_group *(*get)(enum pmt_feature_id id),
 				    void (*put)(struct pmt_feature_group *p))
 {
+	guard(mutex)(&aet_register_lock);
 	get_feature = get;
 	put_feature = put;
 	pmt_module = module;
@@ -343,12 +353,31 @@ EXPORT_SYMBOL_NS_GPL(intel_aet_register_enumeration, "INTEL_PMT");
 
 void intel_aet_unregister_enumeration(void)
 {
+	guard(mutex)(&aet_register_lock);
 	pmt_module = NULL;
 	get_feature = NULL;
 	put_feature = NULL;
 }
 EXPORT_SYMBOL_NS_GPL(intel_aet_unregister_enumeration, "INTEL_PMT");
 
+bool intel_aet_pre_mount(void)
+{
+	guard(mutex)(&aet_register_lock);
+
+	if (!get_feature || !put_feature)
+		return false;
+
+	if (!try_module_get(pmt_module))
+		return false;
+
+	if (!aet_get_events()) {
+		module_put(pmt_module);
+		return false;
+	}
+
+	return true;
+}
+
 void __exit intel_aet_exit(void)
 {
 	struct event_group **peg;
-- 
2.55.0

