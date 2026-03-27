Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECF8334688
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 23:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774652564; cv=none; b=Vhcn5aK1g+LhE1KoQkH28eY6B6TqdErWteCfXSUk5TadYqpeoVH19RgfOzFae5zWZwHQjfpS2Mb/1tkqGHiFsK/3430ujLgM8fhfYpOIuLDaTxkTiBGi7GMlCXXMRFSm+6bbkT4BtIKWc+JOQ/a39MmzLVTp3ZVCcnTA5BH2KUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774652564; c=relaxed/simple;
	bh=dB3lGaNS4U1dLL4aMG+UkqrJsLJ7iKlcbiBKiDYPHCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLemSxeS7sx0UF9lRCLkcgNEf2S7ioolz4gI5jxCQmpqq62RI7mT+0C2AMOBY3UzxICHFyrPAtvLYakRc92jgjfx+XRMGFWWeu9GSznTiXGmUtvdg+5rIEVIP16nHvtkqqDHOfsDPdAFTrgNrIMmw0LqVGCR3awgJuYzozcnYkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GZD+4Jag; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GZD+4Jag"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774652563; x=1806188563;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dB3lGaNS4U1dLL4aMG+UkqrJsLJ7iKlcbiBKiDYPHCA=;
  b=GZD+4JagBOcVItsrlV2vPZz8IqycPJNn34ddvD9LeognyEytsi+V6zJo
   7tX1xRRRG4Q2uPSBVpAnnlbXL9u2CkYALbQQCUa2t37V8jlp+yo1Wc9j+
   kyCk4ct5+jJ0l4DbHJX0+tfgeLzmHvSDw56kGKNTvE1FhX1JeWHGBoxMI
   Ezy49Fc2oGdhOTuYMA0L31dttAi/jxpqHDK6ZxtSDMI4m8zvv6sMRBG+H
   8QgDae6pi751ZEUZ1IChE87z2iR9E0ehL6vhKWZyug3TgF++kxdHJht9q
   vYwaQ/1VcWRegavxe4HfnN7vZOTUnBQR9DoHfL3qrIpoXNgKSwDGXiQik
   A==;
X-CSE-ConnectionGUID: 8htm+lyaSeyfpwuPXR/thw==
X-CSE-MsgGUID: WgV+v75TQ7u+DeTR4gXlkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="75613290"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="75613290"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:02:39 -0700
X-CSE-ConnectionGUID: fzDIn5lSRzqMw6SSGQKh2w==
X-CSE-MsgGUID: I0EV8/UQQD6hd1eZePt80w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="218816034"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.83])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:02:15 -0700
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
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 6/7] x86/resctrl: Delete intel_aet_exit()
Date: Fri, 27 Mar 2026 16:02:07 -0700
Message-ID: <20260327230208.18094-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327230208.18094-1-tony.luck@intel.com>
References: <20260323163452.25044-1-tony.luck@intel.com>
 <20260327230208.18094-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All cleanup for AET is now handled during file system unmount.

Drop intel_aet_exit().

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  | 2 --
 arch/x86/kernel/cpu/resctrl/core.c      | 2 --
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 4 ----
 3 files changed, 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 6f322818a9e6..2230b64fa2ba 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -237,7 +237,6 @@ void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 bool intel_aet_pre_mount(void);
 void intel_aet_mount_result(int ret);
 void intel_aet_unmount(void);
-void __exit intel_aet_exit(void);
 int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
 void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 				struct list_head *add_pos);
@@ -246,7 +245,6 @@ bool intel_handle_aet_option(bool force_off, char *tok);
 static inline bool intel_aet_pre_mount(void) { return false; }
 static inline void intel_aet_mount_result(int ret) { }
 static inline void intel_aet_unmount(void) { }
-static inline void __exit intel_aet_exit(void) { }
 static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 {
 	return -EINVAL;
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 162eca2cfcdb..1951df519dea 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -1172,8 +1172,6 @@ late_initcall(resctrl_arch_late_init);
 
 static void __exit resctrl_arch_exit(void)
 {
-	intel_aet_exit();
-
 	cpuhp_remove_state(rdt_online);
 
 	resctrl_exit();
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 2d5766904fd8..c6c213d28275 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -328,10 +328,6 @@ static bool get_events(void)
 	return ret;
 }
 
-void __exit intel_aet_exit(void)
-{
-}
-
 static bool get_pmt_references(void)
 {
 	get_feature = symbol_get(intel_pmt_get_regions_by_feature);
-- 
2.53.0

