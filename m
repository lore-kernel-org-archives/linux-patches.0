Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793741000;
	b=JY/FNUgFjGp7jr+Hoe9ln+wZRgVhnhJF/2Skwc5xDUUPf2naQfwU7X7sGVj3CDCOYoXm
	 MB3/hXOWRSLIpE1WR67TRWLF7wSxHncP9BkzWQonHN+0ul82hUg3lJDnsFyjLGh3THP35
	 E1gbTwiCcJUtnLXESYG2Nb91/5O3W71kpzlhESr7ngogy2xOLZmtr/5wakSjQfple0iPk
	 HcpGhGT5tUKrd8jnWN7T2qw7zSO5kM3dyCvCteEuKsGI8Q2/OcuM1UiX2UMiPUtD/ITF0
	 8wi7FjE/5j5X1VYui718HDIhvdN+iD6WKpb/TYqC1d6RreD5asoEQptJgNIKVBiOkng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793741000;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=49wHpfS1iBmOzeF/9QKpHr1zrETms8BaGm7SVOEBTc0=;
	b=Quy7Xzt0BnifPATRGVNnrOLnLxGjLIO5kS8b4Ztdiq9P+Ib8u1HlWcB8a0hN1QAgiv2O
	 2Wh02rtB3EiMMJBwLpOlJg3YS0HJQo5p/TESiGrZw8HOBi2GhdmN+2Xf74pyGrNcZ1vtx
	 +dpqIGIS42eRmADR+HF5PExJS+fab3ZqtETrH8nRsN+gexqz8mjTKuPCVIbhHdnc0ovwm
	 Ly6xKVe3691AfuBJdyq509m5JYgWZeXKZhgXk/3Iwlihjlb1No8w3ken4XKIBOznUuPAb
	 Z6FKXqXr6eV013mJu28XBQs0QGRTaBLWWE9lUGn12i81zYDxotnhfwhloD9KP3ENtqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ePoEa621;
	arc=none smtp.remote-ip=192.198.163.11
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E73F606D80D
	for <patches@lists.linux.dev>; Tue,  3 Nov 2026 21:23:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E73F606D80D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ePoEa621
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793740995; x=1825276995;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nOh5LvjpLeZd1ekSqK8H/akhvhVopMAuvYo9A8HWnFs=;
  b=ePoEa621DtZ1nFa01MLUwSMZUkEexAjW898G3pRmNSbaL8F01blpHYCT
   5qHMPJiELPJHYbL4ai6ReDwECZ5o93WQw1dXgPBy1b4n4dMWCj2jZe6Qf
   VupAq/K1bs4xaJGnndbzkT6ArNfTu5xWLwg1Rdk847JYGfJ9qs2xQbDJl
   ITMvlPKbkESkEQEa8MTSJggvioeABO0i9sZWaywVzzI+7FReLUWOuy/jN
   X66/v6d9m77DlgKRDaI9ZONgG0VXS0cncjVRyvrVNZKGHyhpImMXx43Jb
   96mmNtiWew8P3ezpJK8UE8VwJI1bANmjSaJJzPiGJ/oXSOp1biB4XfwqV
   g==;
X-CSE-ConnectionGUID: RS8SoHPBRn+n2RjS16Eueg==
X-CSE-MsgGUID: 38qQ7hbFRh6ySMMwaO+iOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2393510"
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="2393510"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 13:23:11 -0800
X-CSE-ConnectionGUID: t5fXAp7KRhaFXSHYFvHH2Q==
X-CSE-MsgGUID: fGsRE4vdSBu8mCZJNGZOrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="6624583"
Received: from rosenzwe-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.124])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 13:23:09 -0800
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
Subject: [RFC PATCH v2 07/11] arm,x86,fs/resctrl: Store cache bitmask length per control domain
Date: Tue,  3 Nov 2026 13:22:50 -0800
Message-ID: <20261103212254.18314-8-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103212254.18314-1-tony.luck@intel.com>
References: <20261103212254.18314-1-tony.luck@intel.com>
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

Cache allocation bitmask properties currently live on the shared control,
which assumes that every domain has the same CBM length. Asymmetric cache
domains can have different lengths.

Store CBM length on each control domain and use that value when initializing
default controls, validating and displaying masks, and calculating cache
allocation sizes. Initialize the per-domain value in the x86 and MPAM
implementations.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                | 10 +++++++--
 arch/x86/kernel/cpu/resctrl/core.c     |  9 +++++---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c |  2 +-
 drivers/resctrl/mpam_resctrl.c         | 14 +++++++-----
 fs/resctrl/ctrlmondata.c               |  9 ++++----
 fs/resctrl/pseudo_lock.c               |  2 +-
 fs/resctrl/rdtgroup.c                  | 31 ++++++++++++++------------
 7 files changed, 47 insertions(+), 30 deletions(-)

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
index 7981ddbde8c9..cd3bcd71f475 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -484,14 +484,14 @@ void rdt_ctrl_update(void *arg)
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
@@ -524,7 +524,7 @@ static int domain_setup_ctrlval(struct rdt_resource *r, struct resctrl_ctrl *ctr
 		return -ENOMEM;
 
 	hw_dom->ctrl_val = dc;
-	setup_default_ctrlval(r, ctrl, dc);
+	setup_default_ctrlval(r, ctrl, dc, d);
 
 	m.res = r;
 	m.ctrl = ctrl;
@@ -625,6 +625,9 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r,
 	d->hdr.rid = r->rid;
 	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
 
+	if (ctrl->type == RESCTRL_CTRL_BITMAP)
+		d->cbm_len = ctrl->bitmap.cbm_len;
+
 	rdt_domain_reconfigure_cdp(r);
 
 	if (domain_setup_ctrlval(r, ctrl, d)) {
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
index 12315cc7dec6..d2890b0d1cd8 100644
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
 
@@ -1704,6 +1704,10 @@ mpam_resctrl_alloc_ctrl_domain(unsigned int cpu, struct mpam_resctrl_res *res,
 	dom->ctrl_comp = ctrl_comp;
 
 	ctrl_d = &dom->resctrl_ctrl_dom;
+
+	if (ctrl->type == RESCTRL_CTRL_BITMAP)
+		ctrl_d->cbm_len = ctrl->bitmap.cbm_len;
+
 	mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, r->rid, &ctrl_d->hdr);
 	ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
 	err = resctrl_online_ctrl_domain(r, ctrl, ctrl_d);
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
index 836a9b93a587..043a704aa8c9 100644
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
index 57c050b05798..02636fee9dfd 100644
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

