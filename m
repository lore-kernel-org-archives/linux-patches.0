Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051853;
	b=NtB74IrJ564+9ibMDus0HTsVTgSB/v+P4fc6eq5vvfkXvqL1OIfsP/RndU8dvpeUVyDa
	 C6HlDjvmS9dimd39Ft6vmj3sjvrRiDGXo/Wyi5PLF0z+36Chu9z+3YjCrwtpN7USDGtdm
	 /JrFlO6Y2EvOBzaZSxY5vehY97Bt5/dPFn+wCVDAj8FdyCvVI0hGtIyM75HRxZohv0Sxp
	 ZkP9BtCmvOfYH87+L3wYT5ImvyMXTGIX3B5sk3ZAICTX5QIIdXtj6+TN2peHRix+HZ93e
	 tV63VH89QliBfAQ7v5eqi50XMpXnlDmX/SP6+nsUrHEXzsruyRnArDjNZwktmi4H/8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051853;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9iyiNA+0v2MC8/2Au7ysQPdv2R4pRGbQqq6nFu9LGGE=;
	b=iIyFxaLN1h1d+KHJsTOEXfZz499d0T3zLVHaoq04pDG09EPeCfxuUYapWs4i5lkMVUpr
	 Umsqh5XlTxFB+UYbEGQ1+PnwXS/z7Aeb11CrL/WOh8Cmo4hRgx983Ti9R6Dp+QltSOQYF
	 lN9fn9U86ql1T7TpH7prBeYMoM0bJhwTZV7CqRbyQFif2OUmbkSpoS8d6WbxgAxrirjLQ
	 71qAWn1+kM7XUTfF3oyHu3ZdAxzxVyl2LIKUzV3iPV8uJVY7T33ctjwdYxtoZW0REcI8z
	 ovGTPpfPFMw/gJKBeuU55VLv2ggN2bthwQeppEDKqzensmsgBGMdJNqfELEIZ0/qiug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=H1lInXMx;
	arc=none smtp.remote-ip=192.198.163.14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8720D606A33D
	for <patches@lists.linux.dev>; Mon, 26 Oct 2026 21:57:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8720D606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=H1lInXMx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793051853; x=1824587853;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5cFpmz0oKoFFCmmqoj34e/SFrMQBD1qaiUQ8CCv6zt4=;
  b=H1lInXMxsZNKVj740PJ8X2kgV3XBDDzpk5gNVB2I33UukCYOMhq+ZzKP
   W88XBe8E3RtknFJO8UMuAzVjFZ+Qm/nFQpX7HVabWQsYrtu1oDw+jw+BO
   uwoZSm+TjIqaqASxiV0kuaiOsOEJ6vyAd8+UGpJVSJTBlCKGvlEQnUfza
   BB7NjGcgdXNv7RuLVWxUr6Rzq89XikEzSfI6tzD2dv3WWya0oGr6InCAP
   XJQbNgOpbSQF3cYa5le6WHUc1ogosZFtnqWEI1r9nGDQs7k2Xw1gY8f+A
   ghsNlpeXRdpbiS8svoNV+I29AwRNnC93c0AWCe/xzbc+p66zGmoVj9b0z
   A==;
X-CSE-ConnectionGUID: zjMWKfrZQMevC0IdoxdS5g==
X-CSE-MsgGUID: EO2qBwO5Rx+Ko6EsGcZNPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11947"; a="1766415"
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="1766415"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 14:57:29 -0700
X-CSE-ConnectionGUID: ilaQyGnLTg2amzyG/7hDMQ==
X-CSE-MsgGUID: NOp+WPU7QBWna4oEjFCmjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="4240279"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.204])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 14:57:28 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 6/8] arm,x86,fs/resctrl: Prepare for asymmetric caches
Date: Mon, 26 Oct 2026 14:57:16 -0700
Message-ID: <20261026215718.16810-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026215718.16810-1-tony.luck@intel.com>
References: <20261026215718.16810-1-tony.luck@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Each struct resctrl_ctrl carries a struct resctrl_ctrl_bitmap that describes
properties (cbm_len, min_cbm_bits, shareable_bits, flags) shared by every
control domain using that control. This assumes all domains of a control are
symmetric. Future asymmetric systems may have control domains with differing
bitmap properties, in particular a @cbm_len that varies by cache instance.

Add a field to the rdt_ctrl_domain structure to store per-domain cache
bitmap lengths.

Update code that reads cbm_len to use the per-domain copy instead of the
resctrl_ctrl copy, so that domain-specific values will be picked up when
asymmetric domains are enumerated.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                | 10 +++++++--
 arch/x86/kernel/cpu/resctrl/core.c     | 23 ++++++++++++++++---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c |  2 +-
 drivers/resctrl/mpam_resctrl.c         | 19 +++++++++++-----
 fs/resctrl/ctrlmondata.c               |  9 ++++----
 fs/resctrl/pseudo_lock.c               |  2 +-
 fs/resctrl/rdtgroup.c                  | 31 ++++++++++++++------------
 7 files changed, 65 insertions(+), 31 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index f58a9e773ff6..8ac799d1feff 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -184,12 +184,15 @@ static inline bool domain_header_is_valid(struct rdt_domain_hdr *hdr,
  * @mbps_val:		When mba_sc is enabled, this holds the array of user
  *			specified control values for mba_sc in MBps, indexed
  *			by closid
+ * @cbm_len:		Length of cache bitmask for a cache control in this
+ *			domain
  */
 struct rdt_ctrl_domain {
 	struct rdt_domain_hdr		hdr;
 	struct pseudo_lock_region	*plr;
 	struct resctrl_staged_config	staged_config[CDP_NUM_TYPES];
 	u32				*mbps_val;
+	unsigned int			cbm_len;
 };
 
 /**
@@ -597,8 +600,11 @@ void resctrl_arch_sync_cpu_closid_rmid(void *info);
  * resctrl_get_default_ctrlval() - Return the default control value for this
  *                                 control.
  * @ctrl:	The control whose default control type is queried.
+ * @d:		The control domain to query, or NULL if @ctrl's properties
+ *		should be used instead (e.g. when no domain exists yet).
  */
-static inline u32 resctrl_get_default_ctrlval(struct resctrl_ctrl *ctrl)
+static inline u32 resctrl_get_default_ctrlval(struct resctrl_ctrl *ctrl,
+					      struct rdt_ctrl_domain *d)
 {
 	switch (ctrl->type) {
 	case RESCTRL_CTRL_BITMAP:
@@ -606,7 +612,7 @@ static inline u32 resctrl_get_default_ctrlval(struct resctrl_ctrl *ctrl)
 		 * Should map to 100% allocation as exposed to user space
 		 * via "cbm_mask".
 		 */
-		return BIT_MASK(ctrl->bitmap.cbm_len) - 1;
+		return BIT_MASK(d ? d->cbm_len : ctrl->bitmap.cbm_len) - 1;
 	case RESCTRL_CTRL_SCALAR:
 		return ctrl->scalar.reset_val;
 	}
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index c26fc75ccc07..f6b7358e50d7 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -485,14 +485,14 @@ void rdt_ctrl_update(void *arg)
 }
 
 static void setup_default_ctrlval(struct rdt_resource *r, struct resctrl_ctrl *ctrl,
-				  u32 *dc)
+				  u32 *dc, struct rdt_ctrl_domain *d)
 {
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
 	int i;
 
 	/* Initialize the control MSRs to their reset values. */
 	for (i = 0; i < hw_res->num_closid; i++, dc++)
-		*dc = resctrl_get_default_ctrlval(ctrl);
+		*dc = resctrl_get_default_ctrlval(ctrl, d);
 }
 
 static void ctrl_domain_free(struct rdt_hw_ctrl_domain *hw_dom)
@@ -525,7 +525,7 @@ static int domain_setup_ctrlval(struct rdt_resource *r, struct resctrl_ctrl *ctr
 		return -ENOMEM;
 
 	hw_dom->ctrl_val = dc;
-	setup_default_ctrlval(r, ctrl, dc);
+	setup_default_ctrlval(r, ctrl, dc, d);
 
 	m.res = r;
 	m.ctrl = ctrl;
@@ -585,6 +585,22 @@ static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
 	return -EINVAL;
 }
 
+/*
+ * Take a snapshot of the cache bitmask length for cache controls (with
+ * the assumption that there is only one cache control for a resource).
+ */
+static void rdt_sync_ctrl_bitmap(struct rdt_resource *r, struct rdt_ctrl_domain *d)
+{
+	struct resctrl_ctrl *ctrl;
+
+	for_each_resource_ctrl(ctrl, r) {
+		if (ctrl->type != RESCTRL_CTRL_BITMAP)
+			continue;
+		d->cbm_len = ctrl->bitmap.cbm_len;
+		break;
+	}
+}
+
 static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r,
 				struct resctrl_ctrl *ctrl)
 {
@@ -625,6 +641,7 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r,
 	d->hdr.type = RESCTRL_CTRL_DOMAIN;
 	d->hdr.rid = r->rid;
 	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
+	rdt_sync_ctrl_bitmap(r, d);
 
 	rdt_domain_reconfigure_cdp(r);
 
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index edf42c59d7c1..691cd9fb1687 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -257,7 +257,7 @@ void resctrl_arch_reset_all_ctrls(struct rdt_resource *r)
 			hw_dom = resctrl_to_arch_ctrl_dom(d);
 
 			for (i = 0; i < hw_res->num_closid; i++)
-				hw_dom->ctrl_val[i] = resctrl_get_default_ctrlval(ctrl);
+				hw_dom->ctrl_val[i] = resctrl_get_default_ctrlval(ctrl, d);
 			msr_param.dom = d;
 			smp_call_function_any(&d->hdr.cpu_mask, rdt_ctrl_update, &msr_param, 1);
 		}
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 7a3afb6a411e..e420ca81434b 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -1246,7 +1246,7 @@ static int mpam_resctrl_control_init(struct mpam_resctrl_res *res)
 		 * we have configured the SMMU and GIC not to do this 'all the
 		 * bits' is the correct answer here.
 		 */
-		mpam_ctrl->r_ctrl.bitmap.shareable_bits = resctrl_get_default_ctrlval(&mpam_ctrl->r_ctrl);
+		mpam_ctrl->r_ctrl.bitmap.shareable_bits = resctrl_get_default_ctrlval(&mpam_ctrl->r_ctrl, NULL);
 		list_add(&mpam_ctrl->r_ctrl.entry, &r->controls);
 		r->alloc_capable = true;
 		break;
@@ -1411,7 +1411,7 @@ u32 resctrl_arch_get_config(struct rdt_resource *r, struct resctrl_ctrl *ctrl,
 	lockdep_assert_cpus_held();
 
 	if (!mpam_is_enabled())
-		return resctrl_get_default_ctrlval(ctrl);
+		return resctrl_get_default_ctrlval(ctrl, d);
 
 	res = container_of(r, struct mpam_resctrl_res, resctrl_res);
 	dom = container_of(d, struct mpam_resctrl_dom, resctrl_ctrl_dom);
@@ -1440,12 +1440,12 @@ u32 resctrl_arch_get_config(struct rdt_resource *r, struct resctrl_ctrl *ctrl,
 		}
 		fallthrough;
 	default:
-		return resctrl_get_default_ctrlval(ctrl);
+		return resctrl_get_default_ctrlval(ctrl, d);
 	}
 
 	if (!r->alloc_capable || partid >= resctrl_arch_get_num_closid(r) ||
 	    !mpam_has_feature(configured_by, cfg))
-		return resctrl_get_default_ctrlval(ctrl);
+		return resctrl_get_default_ctrlval(ctrl, d);
 
 	switch (configured_by) {
 	case mpam_feat_cpor_part:
@@ -1453,7 +1453,7 @@ u32 resctrl_arch_get_config(struct rdt_resource *r, struct resctrl_ctrl *ctrl,
 	case mpam_feat_mbw_max:
 		return mbw_max_to_percent(cfg->mbw_max, cprops);
 	default:
-		return resctrl_get_default_ctrlval(ctrl);
+		return resctrl_get_default_ctrlval(ctrl, d);
 	}
 }
 
@@ -1864,16 +1864,23 @@ int mpam_resctrl_online_cpu(unsigned int cpu)
 
 		if (r->alloc_capable) {
 			for_each_resource_ctrl(ctrl, r) {
+				struct rdt_ctrl_domain *ctrl_d;
+
 				dom = mpam_resctrl_get_ctrl_domain_from_cpu(cpu, ctrl);
 				if (!dom) {
 					dom = mpam_resctrl_alloc_ctrl_domain(cpu, res, ctrl);
 					if (IS_ERR(dom))
 						return PTR_ERR(dom);
 				} else {
-					struct rdt_ctrl_domain *ctrl_d = &dom->resctrl_ctrl_dom;
+					ctrl_d = &dom->resctrl_ctrl_dom;
 
 					mpam_resctrl_online_domain_hdr(cpu, &ctrl_d->hdr);
 				}
+
+				if (ctrl->type == RESCTRL_CTRL_BITMAP) {
+					ctrl_d = &dom->resctrl_ctrl_dom;
+					ctrl_d->cbm_len = ctrl->bitmap.cbm_len;
+				}
 			}
 		}
 		if (r->mon_capable) {
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 627998fed555..90274fdb0364 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -189,10 +189,11 @@ static int parse_bw(struct rdt_parse_data *data, struct rdt_resource_final *f,
  * requires at least two bits set.
  * AMD allows non-contiguous bitmasks.
  */
-static bool cbm_validate(char *buf, u32 *data, struct resctrl_ctrl *ctrl)
+static bool cbm_validate(char *buf, u32 *data, struct rdt_ctrl_domain *d,
+			 struct resctrl_ctrl *ctrl)
 {
-	u32 supported_bits = BIT_MASK(ctrl->bitmap.cbm_len) - 1;
-	unsigned int cbm_len = ctrl->bitmap.cbm_len;
+	u32 supported_bits = BIT_MASK(d->cbm_len) - 1;
+	unsigned int cbm_len = d->cbm_len;
 	unsigned long first_bit, zero_bit, val;
 	int ret;
 
@@ -255,7 +256,7 @@ static int parse_cbm(struct rdt_parse_data *data, struct rdt_resource_final *f,
 		return -EINVAL;
 	}
 
-	if (!cbm_validate(data->buf, &cbm_val, ctrl))
+	if (!cbm_validate(data->buf, &cbm_val, d, ctrl))
 		return -EINVAL;
 
 	if ((mode == RDT_MODE_EXCLUSIVE || mode == RDT_MODE_SHAREABLE) &&
diff --git a/fs/resctrl/pseudo_lock.c b/fs/resctrl/pseudo_lock.c
index 17b99a075eaf..1f2e2da28bc5 100644
--- a/fs/resctrl/pseudo_lock.c
+++ b/fs/resctrl/pseudo_lock.c
@@ -637,7 +637,7 @@ bool rdtgroup_cbm_overlaps_pseudo_locked(struct rdt_ctrl_domain *d, unsigned lon
 		return false;
 	}
 
-	cbm_len = ctrl->bitmap.cbm_len;
+	cbm_len = d->cbm_len;
 	cbm_b = d->plr->cbm;
 	if (bitmap_intersects(&cbm, &cbm_b, cbm_len))
 		return true;
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 7119ad0029c1..46d39332706e 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1106,7 +1106,7 @@ static int rdt_default_ctrl_show(struct kernfs_open_file *of,
 	if (!ctrl)
 		goto out_unlock;
 
-	seq_printf(seq, "%x\n", resctrl_get_default_ctrlval(ctrl));
+	seq_printf(seq, "%x\n", resctrl_get_default_ctrlval(ctrl, NULL));
 
 out_unlock:
 	info_kn_unlock(of->kn);
@@ -1250,7 +1250,7 @@ static int rdt_bit_usage_show(struct kernfs_open_file *of,
 			hw_shareable |= ctrl_val;
 		}
 
-		for (i = ctrl->bitmap.cbm_len - 1; i >= 0; i--) {
+		for (i = dom->cbm_len - 1; i >= 0; i--) {
 			pseudo_locked = dom->plr ? dom->plr->cbm : 0;
 			hwb = test_bit(i, &hw_shareable);
 			swb = test_bit(i, &sw_shareable);
@@ -1546,7 +1546,7 @@ static bool __rdtgroup_cbm_overlaps(struct rdt_resource *r, struct rdt_ctrl_doma
 	/* Check for any overlap with regions used by hardware directly */
 	if (!exclusive) {
 		ctrl_b = ctrl->bitmap.shareable_bits;
-		if (bitmap_intersects(&cbm, &ctrl_b, ctrl->bitmap.cbm_len))
+		if (bitmap_intersects(&cbm, &ctrl_b, d->cbm_len))
 			return true;
 	}
 
@@ -1556,7 +1556,7 @@ static bool __rdtgroup_cbm_overlaps(struct rdt_resource *r, struct rdt_ctrl_doma
 		mode = rdtgroup_mode_by_closid(i);
 		if (closid_allocated(i) && i != closid &&
 		    mode != RDT_MODE_PSEUDO_LOCKSETUP) {
-			if (bitmap_intersects(&cbm, &ctrl_b, ctrl->bitmap.cbm_len)) {
+			if (bitmap_intersects(&cbm, &ctrl_b, d->cbm_len)) {
 				if (exclusive) {
 					if (mode == RDT_MODE_EXCLUSIVE)
 						return true;
@@ -1761,10 +1761,10 @@ unsigned int rdtgroup_cbm_to_size(struct rdt_resource *r, struct resctrl_ctrl *c
 	if (WARN_ON_ONCE(r->ctrl_scope != RESCTRL_L2_CACHE && r->ctrl_scope != RESCTRL_L3_CACHE))
 		return size;
 
-	num_b = bitmap_weight(&cbm, ctrl->bitmap.cbm_len);
+	num_b = bitmap_weight(&cbm, d->cbm_len);
 	ci = get_cpu_cacheinfo_level(cpumask_any(&d->hdr.cpu_mask), r->ctrl_scope);
 	if (ci)
-		size = ci->size / ctrl->bitmap.cbm_len * num_b;
+		size = ci->size / d->cbm_len * num_b;
 
 	return size;
 }
@@ -2479,7 +2479,7 @@ static int resctrl_ctrl_max_show(struct kernfs_open_file *of,
 			seq_printf(seq, "%d=%u", d->hdr.id, ctrl->scalar.max);
 			break;
 		case RESCTRL_CTRL_BITMAP:
-			seq_printf(seq, "%d=%lx", d->hdr.id, BIT_MASK(ctrl->bitmap.cbm_len) - 1);
+			seq_printf(seq, "%d=%lx", d->hdr.id, BIT_MASK(d->cbm_len) - 1);
 			break;
 		}
 		sep = true;
@@ -4227,6 +4227,9 @@ static int mkdir_mondata_all(struct kernfs_node *parent_kn,
  * cbm_ensure_valid - Enforce validity on provided CBM
  * @_val:	Candidate CBM
  * @r:		RDT resource to which the CBM belongs
+ * @d:		RDT domain to which the CBM belongs. Its bitmap properties
+ *		(e.g. @cbm_len) are used since these may differ from
+ *		@ctrl's on asymmetric systems.
  * @ctrl:	Properties of the bitmap control CBM should be tested against.
  *
  * The provided CBM represents all cache portions available for use. This
@@ -4241,10 +4244,10 @@ static int mkdir_mondata_all(struct kernfs_node *parent_kn,
  *
  * Return: A CBM that is valid for resource @r.
  */
-static u32 cbm_ensure_valid(u32 _val, struct rdt_resource *r,
+static u32 cbm_ensure_valid(u32 _val, struct rdt_resource *r, struct rdt_ctrl_domain *d,
 			    struct resctrl_ctrl *ctrl)
 {
-	unsigned int cbm_len = ctrl->bitmap.cbm_len;
+	unsigned int cbm_len = d->cbm_len;
 	unsigned long first_bit, zero_bit;
 	unsigned long val;
 
@@ -4312,20 +4315,20 @@ static int __init_one_rdt_domain(struct rdt_ctrl_domain *d, struct rdt_resource_
 	}
 	if (d->plr && d->plr->cbm > 0)
 		used_b |= d->plr->cbm;
-	unused_b = used_b ^ (BIT_MASK(ctrl->bitmap.cbm_len) - 1);
-	unused_b &= BIT_MASK(ctrl->bitmap.cbm_len) - 1;
+	unused_b = used_b ^ (BIT_MASK(d->cbm_len) - 1);
+	unused_b &= BIT_MASK(d->cbm_len) - 1;
 	cfg->new_ctrl |= unused_b;
 	/*
 	 * Force the initial CBM to be valid, user can
 	 * modify the CBM based on system availability.
 	 */
-	cfg->new_ctrl = cbm_ensure_valid(cfg->new_ctrl, r, ctrl);
+	cfg->new_ctrl = cbm_ensure_valid(cfg->new_ctrl, r, d, ctrl);
 	/*
 	 * Assign the u32 CBM to an unsigned long to ensure that
 	 * bitmap_weight() does not access out-of-bound memory.
 	 */
 	tmp_cbm = cfg->new_ctrl;
-	if (bitmap_weight(&tmp_cbm, ctrl->bitmap.cbm_len) < ctrl->bitmap.min_cbm_bits) {
+	if (bitmap_weight(&tmp_cbm, d->cbm_len) < ctrl->bitmap.min_cbm_bits) {
 		rdt_last_cmd_printf("No space on %s:%d\n", f->name, d->hdr.id);
 		return -ENOSPC;
 	}
@@ -4373,7 +4376,7 @@ static void rdtgroup_init_mba(struct rdt_resource *r, struct resctrl_ctrl *ctrl,
 		}
 
 		cfg = &d->staged_config[CDP_NONE];
-		cfg->new_ctrl = resctrl_get_default_ctrlval(ctrl);
+		cfg->new_ctrl = resctrl_get_default_ctrlval(ctrl, d);
 		cfg->have_new_ctrl = true;
 	}
 }
-- 
2.56.0

