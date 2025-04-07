Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC7622A80F
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 23:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744069264; cv=none; b=Yy4hWcLeBR9gCO679mNhT7eTkB5b2/vsXWisf2og7/87g0CmoqjALVA2lHYYV1qVgZWwQKCe1FU3+4xLM1zYHPi9sIX0O/XW/awJD5rJydC7fzgEBM/zN11QSCn/ql8DhNHqUGwCFDc53/cfxfBgiOTmoZCp2fzA+UxTxYQ22pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744069264; c=relaxed/simple;
	bh=ay6kOKCacuZCn+XPR511HwTZVDvxxSctVUfQ7U+skIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/JO8BmoQAF5CTA7IxgTKqEXxIgPk2N0uLx9Y/x5xxSbvO8HWsB3WxKfXWMTOuf77ew/IWn7Xp43wJ8Amratjei937KDeLtNMbLB/KU6CHmGcCTA7Ht0mFdyk5z1j9DKqexxcH5Wa/ux8nFmTWNms9ZmFyJulvPNTzto8O29CLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dg3okPRd; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dg3okPRd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744069262; x=1775605262;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ay6kOKCacuZCn+XPR511HwTZVDvxxSctVUfQ7U+skIY=;
  b=Dg3okPRdNLFO0gHL8vMjPKwlrqWpS5cuP0eUMbva/mkZksrSHZ4Kq5Me
   xjhvKSdjO+PTOg1NEHO110kCFbapaNud0jIyocuRuN8HwpyPB+iNS3QN8
   0hvcxMYNfOKS0s724tcwGGnMZag+ThcrAa2qnLfyeWeg6YfRZNJ41lccE
   /3pfAuoZKXNmqca7su+mBqTTt01qlYaeDQGKbz/LNQuZ1vGhC3m+fsygJ
   rbLssSj+uVjsZ2CtW9NG178+quEbKFwSoDnWgbGIahsF8Bw9LSzz0Se+m
   0H5WW2BJYYR8f3uJX7S1oZyqPHKFRbwLrU6SHsUSY3b6qR7O3KmEW3BKw
   A==;
X-CSE-ConnectionGUID: PTZLUBZjRzmB+jJ3Q3oleQ==
X-CSE-MsgGUID: jNUaqnwqQ7GJXerG8DAwpg==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="48193234"
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="48193234"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:53 -0700
X-CSE-ConnectionGUID: GZ8TQAYCTFKf10lqF0nUOA==
X-CSE-MsgGUID: CXBsjddQRCqv2lufLJy7Gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="165315498"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:52 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 16/26] x86/resctrl: Third phase of telemetry event enumeration
Date: Mon,  7 Apr 2025 16:40:18 -0700
Message-ID: <20250407234032.241215-17-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250407234032.241215-1-tony.luck@intel.com>
References: <20250407234032.241215-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allocate per-package arrays for the known telemetry_regions and
initialize with pointers to the structures acquired from the
intel_pmt_get_regions_by_feature() calls.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 38 +++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 9d414dd40f8b..fb03f2e76306 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -108,6 +108,30 @@ static bool count_events(struct pkg_info *pkg, int max_pkgs, struct pmt_feature_
 	return found;
 }
 
+/*
+ * Copy the pointers to telemetry regions associated with a given package
+ * and with known guids over to the pkg_info structure for that package.
+ */
+static int setup(struct pkg_info *pkg, int pkgnum, struct pmt_feature_group *p, int slot)
+{
+	struct telem_entry **tentry;
+
+	for (int i = 0; i < p->count; i++) {
+		for (tentry = telem_entry; *tentry; tentry++) {
+			if (!(*tentry)->active)
+				continue;
+			if (pkgnum != p->regions[i].plat_info.package_id)
+				continue;
+			if (p->regions[i].guid != (*tentry)->guid)
+				continue;
+
+			pkg[pkgnum].regions[slot++] =  p->regions[i];
+		}
+	}
+
+	return slot;
+}
+
 DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,	\
 	if (!IS_ERR_OR_NULL(_T))					\
 		intel_pmt_put_feature_group(_T))
@@ -128,6 +152,7 @@ bool intel_aet_get_events(void)
 	struct pkg_info *pkg __free(free_pkg_info) = NULL;
 	int num_pkgs = topology_max_packages();
 	bool use_p1, use_p2;
+	int slot;
 
 	pkg = kcalloc(num_pkgs, sizeof(*pkg_info), GFP_KERNEL);
 	if (!pkg)
@@ -146,6 +171,19 @@ bool intel_aet_get_events(void)
 		return false;
 	}
 
+	for (int i = 0; i < num_pkgs; i++) {
+		if (!pkg[i].count)
+			continue;
+		pkg[i].regions = kmalloc_array(pkg[i].count, sizeof(*pkg[i].regions), GFP_KERNEL);
+		if (!pkg[i].regions)
+			return false;
+		slot = 0;
+		if (use_p1)
+			slot = setup(pkg, i, p1, slot);
+		if (use_p2)
+			slot = setup(pkg, i, p2, slot);
+	}
+
 	if (use_p1)
 		feat_energy = no_free_ptr(p1);
 	if (use_p2)
-- 
2.48.1

