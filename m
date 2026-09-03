Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBCF418360
	for <patches@lists.linux.dev>; Thu,  3 Sep 2026 16:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788454639; cv=none; b=FOONc1Diul9h+PrKoDCHsrpfEgKolvXjiSVqaO1V/G75djInNFm9tpaWvpgOnfVgYBUU1iW6rBoX9JMdrqBynEJaMou8mKzqMD1yBSkX9OlLaAjz1G1CtS+tco6bOkGrFvTfai2XWKXlpK1Y/Qser6cPfuxDS4mldHaipBU4L+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788454639; c=relaxed/simple;
	bh=i/k81EGLNxtO/O0oHsEnMXbYVmh6+JDKRa9c1Dfk3EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lS1JtHbFIdlOC5zo+X+yRSgSwwPu38q2njARMFhXqJc77Bq99DmYRN+MPlZ8K+cAxN+xKXCc9Sblc1AKFNNkLZSPC8pHHDgxiXOM2e6wa2oHUXw9JtjpWnFufLeYAd3rsmzKq20DymyCxprrOrO+e7WPfW7Wqs+7FdFfNUeVLMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XzocVcYK; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XzocVcYK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788454639; x=1819990639;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i/k81EGLNxtO/O0oHsEnMXbYVmh6+JDKRa9c1Dfk3EI=;
  b=XzocVcYKtWVp27rZygsGllhhlOkb38Ox6gIfnlelQZcvr8Bd5+V2pP7j
   dOmAm2/S7ipUpZ3pSf9PX+Xh++9aO+zM/I0Z5oTdRpJxFNCz5YNQDA/ty
   s3sQvToq39Ikrln51rKBLGvP2Adto6gv9Gkowvg61DF0qnDQR6zVRyMYA
   qdnxBTKrhXj0iYtyWGdYlIIbgWYnIEvWklRnGm6lal8lVDCCaJ4foF1C8
   +ZKWUr4m7WpyqjwhnrknEXGlHNgeexl+F8LAhERs/HXJlRBwBBbZbBszT
   alUkmDoKobafr7S9dnw0uUBGpmAhKBW1OC7YSxmcVZrSisjw+Fbe64Spb
   A==;
X-CSE-ConnectionGUID: kFZ14nm7RsKeLFtPnYIgbQ==
X-CSE-MsgGUID: Gv+WvefjRAeutI55HeA+zA==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="100103980"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="100103980"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 09:57:14 -0700
X-CSE-ConnectionGUID: ihv8a+w1RBqJ1bNQn23tpw==
X-CSE-MsgGUID: LK2sMfroTr28fBi1+gfeQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="273554217"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 09:57:13 -0700
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
Subject: [PATCH 2/5] x86,fs/resctrl: Remove "arch_needs_linear"
Date: Thu,  3 Sep 2026 09:57:04 -0700
Message-ID: <62904217290f2cd3225d8608c19e284d6dde3aec.1788452481.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788452481.git.reinette.chatre@intel.com>
References: <cover.1788452481.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

arch_needs_linear is used to reject any configuration attempt on
a non-linear Intel MBA resource yet there are no Intel SKUs that support
non-linear delay. If such non-existent non-linear Intel MBA resource is
encountered during enumeration then it will not be marked as alloc_capable
anyway and thus resctrl will never attempt configuration because of it not
being capable of allocation, not because of the arch_needs_linear value.

On Intel the MBA resource will thus always have:
    delay_linear == true and arch_needs_linear == true
On AMD the MBA resource will always have:
    delay_linear == false and arch_needs_linear == false
MPAM does not set arch_needs_linear.

rdt_get_mb_table() is only called during enumeration and since it always
returns false an Intel MBA resource without MBA_IS_LINEAR is not supported.
Drop the unnecessary venture to rdt_get_mb_table() to make it clear that
an Intel MBA resource without MBA_IS_LINEAR is not considered capable of
allocation. Drop the dead code that sets arch_needs_linear to false on Intel.

Since "if (!delay_linear && arch_needs_linear)" can never be true, drop
arch_needs_linear and its only usage during bandwidth validation.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC v1:
- Fix typo in changelog

Changes since RFC v2:
- Rework changelog.
- Group all r->membw assignments together.
---
 arch/x86/kernel/cpu/resctrl/core.c | 39 ++++++------------------------
 fs/resctrl/ctrlmondata.c           |  8 ------
 include/linux/resctrl.h            |  2 --
 3 files changed, 7 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 65cfde0d6a9b..0e34a1c541b9 100644
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
@@ -213,16 +192,13 @@ static __init bool __get_mem_config_intel(struct rdt_resource *r)
 	hw_res->num_closid = edx.split.cos_max + 1;
 	max_delay = eax.split.max_delay + 1;
 	r->membw.max_bw = MAX_MBA_BW;
-	r->membw.arch_needs_linear = true;
-	if (ecx & MBA_IS_LINEAR) {
-		r->membw.delay_linear = true;
-		r->membw.min_bw = MAX_MBA_BW - max_delay;
-		r->membw.bw_gran = MAX_MBA_BW - max_delay;
-	} else {
-		if (!rdt_get_mb_table(r))
-			return false;
-		r->membw.arch_needs_linear = false;
-	}
+
+	if (!(ecx & MBA_IS_LINEAR))
+		return false;
+
+	r->membw.delay_linear = true;
+	r->membw.min_bw = MAX_MBA_BW - max_delay;
+	r->membw.bw_gran = MAX_MBA_BW - max_delay;
 
 	if (boot_cpu_has(X86_FEATURE_PER_THREAD_MBA))
 		r->membw.throttle_mode = THREAD_THROTTLE_PER_THREAD;
@@ -255,7 +231,6 @@ static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
 
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

