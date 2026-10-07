Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB673B14C9
	for <patches@lists.linux.dev>; Wed,  7 Oct 2026 21:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791407221; cv=none; b=JfQoy7bBSRXoU7JcVYjOHeJczx7pQTIOXC8EMzdaBPah8wTdbjpAF7n169k1aqjziIGWr53cTHOBPYMXLKUDADxN/NuEhbGZv9jtagwS2Nv3IaS/LcmUvWb/4ZQWBWZZNygf4zfbgVdmDKhs8O3MRWodl/0yGu1x/gTBHCJtxsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791407221; c=relaxed/simple;
	bh=1FcisK8P9jHgUgnlNM1jQOvy5bFk1A/el/4p9lnXeEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qAHmRN0eMojCViyVUOjN2iE6EzP5ewKrZ/E62RKfZgIGGuf8aINjP2lObYyBJHMUSCBgAPMeKAqPIvpDT19qpjGb6dofLOMuWZCM57tkPhfBY9brIB6HWPGLz3mkS3JjgtB43A+trzTInSVZUGMrCNY4zkRhkRxOHh/NIUlrXrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gfWMDInk; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gfWMDInk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791407219; x=1822943219;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1FcisK8P9jHgUgnlNM1jQOvy5bFk1A/el/4p9lnXeEo=;
  b=gfWMDInkZsMUmtVEE547ZsyBY0yYi3vFAddKmOL5uJEndv4L8aX2DZd/
   ofMQJ5XET4yl4FRm27e2NvsCuI3GLXqCictD5xWxq+uq7v5j3PQ6oB5ee
   fxPVW51h+hD1Wt5JftNPlK/8I++bb2Xy4KNqgljvvsoTxbHxiQlx1DZuF
   3qbfuh5PMnoNk1Q5rTq+rCznLzphCiipSbkOvPgspQVO7CWOTBGcOivWc
   bpKAF6WyudT/QYZ4OK2yGWtgu9LBKvS82S53F1UKLLHac/vcYHXyiND0l
   +/hvdl1/grG3C48OElkxqogNo7qMIwKxWfRnOrXDdGTHjFBuIUIH5tNKS
   Q==;
X-CSE-ConnectionGUID: v91QHEhQSey5EAfQiWYpRQ==
X-CSE-MsgGUID: FcWkVLQqR0SStEypvVxX6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="289399"
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="289399"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 14:06:57 -0700
X-CSE-ConnectionGUID: UORTnxvOStSNL0RGDVZY9w==
X-CSE-MsgGUID: EhrF5DDqTeySHQNF2zICTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="282359632"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 14:06:55 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	ben.horgan@arm.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v2 2/5] x86,fs/resctrl: Remove unnecessary non-linear MBA configuration check
Date: Wed,  7 Oct 2026 14:06:44 -0700
Message-ID: <54ee80a047388ed372f1e848eccbac930a9745be.1791406459.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1791406459.git.reinette.chatre@intel.com>
References: <cover.1791406459.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Writing a bandwidth value from user space is rejected if the MBA resource
has non-linear delay values while the architecture indicates (via
resctrl_membw::arch_needs_linear) it can only configure resources with
linear delay values. Intel indicates this for MBA while AMD and MPAM do not.

This check can never fail. No Intel SKU supports non-linear delay values,
and the placeholder for such support, rdt_get_mb_table(), is only called
during enumeration and always fails. A non-linear Intel MBA resource is
thus never marked as capable of allocation, and resctrl never exposes it
to user space or attempts to configure it. Every Intel MBA resource capable
of allocation has linear delay values, and AMD and MPAM never indicate a
need for them.

Fail enumeration of a non-linear Intel MBA resource directly to make clear
that it is not supported, and remove the check together with the
resctrl_membw::arch_needs_linear property it relies on.

Keep the informational message printed when such a system is encountered.
While moving it, reword it to no longer refer to the removed mapping table,
add the missing newline, and label the printed family value "family" instead
of "cpu".

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC v1:
- Fix typo in changelog

Changes since RFC v2:
- Rework changelog.
- Group all r->membw assignments together.

Changes since v1:
- Keep (and fix) existing pr_info() message if a non-linear platform
  appears. (Chenyu)
- Rework changelog.
- Group rdt_resource::membw assignments together.
---
 arch/x86/kernel/cpu/resctrl/core.c | 42 +++++++-----------------------
 fs/resctrl/ctrlmondata.c           |  8 ------
 include/linux/resctrl.h            |  2 --
 3 files changed, 10 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index f9677e52790e..f96f7cf255d0 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -181,27 +181,6 @@ static inline void cache_alloc_hsw_probe(void)
 	rdt_alloc_capable = true;
 }
 
-/*
- * rdt_get_mb_table() - get a mapping of bandwidth(b/w) percentage values
- * exposed to user interface and the h/w understandable delay values.
- *
- * The non-linear delay values have the granularity of power of two
- * and also the h/w does not guarantee a curve for configured delay
- * values vs. actual b/w enforced.
- * Hence we need a mapping that is pre calibrated so the user can
- * express the memory b/w as a percentage value.
- */
-static inline bool rdt_get_mb_table(struct rdt_resource *r)
-{
-	/*
-	 * There are no Intel SKUs as of now to support non-linear delay.
-	 */
-	pr_info("MBA b/w map not implemented for cpu:%d, model:%d",
-		boot_cpu_data.x86, boot_cpu_data.x86_model);
-
-	return false;
-}
-
 static __init bool __get_mem_config_intel(struct rdt_resource *r)
 {
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
@@ -212,18 +191,18 @@ static __init bool __get_mem_config_intel(struct rdt_resource *r)
 	cpuid_count(0x00000010, 3, &eax.full, &ebx, &ecx, &edx.full);
 	hw_res->num_closid = edx.split.cos_max + 1;
 	max_delay = eax.split.max_delay + 1;
-	r->membw.max_bw = MAX_MBA_BW;
-	r->membw.arch_needs_linear = true;
-	if (ecx & MBA_IS_LINEAR) {
-		r->membw.delay_linear = true;
-		r->membw.min_bw = MAX_MBA_BW - max_delay;
-		r->membw.bw_gran = MAX_MBA_BW - max_delay;
-	} else {
-		if (!rdt_get_mb_table(r))
-			return false;
-		r->membw.arch_needs_linear = false;
+
+	if (!(ecx & MBA_IS_LINEAR)) {
+		pr_info("Non-linear MBA delay values not supported for family:%d, model:%d\n",
+			boot_cpu_data.x86, boot_cpu_data.x86_model);
+		return false;
 	}
 
+	r->membw.delay_linear = true;
+	r->membw.max_bw = MAX_MBA_BW;
+	r->membw.min_bw = MAX_MBA_BW - max_delay;
+	r->membw.bw_gran = MAX_MBA_BW - max_delay;
+
 	if (boot_cpu_has(X86_FEATURE_PER_THREAD_MBA))
 		r->membw.throttle_mode = THREAD_THROTTLE_PER_THREAD;
 	else
@@ -255,7 +234,6 @@ static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
 
 	/* AMD does not use delay */
 	r->membw.delay_linear = false;
-	r->membw.arch_needs_linear = false;
 
 	/*
 	 * AMD does not use memory delay throttle model to control
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index cafebdff70dc..4562072b8ba6 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -45,14 +45,6 @@ static bool bw_validate(char *buf, u32 *data, struct rdt_resource *r)
 	int ret;
 	u32 bw;
 
-	/*
-	 * Only linear delay values is supported for current Intel SKUs.
-	 */
-	if (!r->membw.delay_linear && r->membw.arch_needs_linear) {
-		rdt_last_cmd_puts("No support for non-linear MB domains\n");
-		return false;
-	}
-
 	ret = kstrtou32(buf, 10, &bw);
 	if (ret) {
 		rdt_last_cmd_printf("Invalid MB value %s\n", buf);
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index b63dc62690ca..66dc9813c888 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -249,7 +249,6 @@ enum membw_throttle_mode {
  * @max_bw:		Maximum memory bandwidth value, used as the reset value
  * @bw_gran:		Granularity at which the memory bandwidth is allocated
  * @delay_linear:	True if memory B/W delay is in linear scale
- * @arch_needs_linear:	True if we can't configure non-linear resources
  * @throttle_mode:	Bandwidth throttling mode when threads request
  *			different memory bandwidths
  * @mba_sc:		True if MBA software controller(mba_sc) is enabled
@@ -259,7 +258,6 @@ struct resctrl_membw {
 	u32				max_bw;
 	u32				bw_gran;
 	u32				delay_linear;
-	bool				arch_needs_linear;
 	enum membw_throttle_mode	throttle_mode;
 	bool				mba_sc;
 };
-- 
2.55.0

