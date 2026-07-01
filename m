Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A0A390237
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 04:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782880042; cv=none; b=CmCSyw2xW3Qqo6x8FqnYv0uICNobfAhSwliLDlbKzLd3xUqCa4gsXBuIAxeYFuNAuuNd/7UWiTYTRh9CJqJfFWcAKYz66aoxr5bZRP/Jgsr37HPr03vr7bYeMWN5SYr7FxOEFMy+3TzeWJ4v7qeZaXK2GvLGFPBqV1f/YEn6J6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782880042; c=relaxed/simple;
	bh=HFHTR2ovwVv0ljvMnTj7YU4r8CD2WWTIFF2TWTSvghA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzK/8USQJNv7hoypVGMZ5z8BWl+jFMTgk3O41ZSzhG6hX8w2O9UywPAb2wDo8PRpyEGti17D8NoaWDQBugnV4egVMiMYPvlS8tAf3YeOlxewX3iQPlvzjlwd+8WiUIRkBGXXZkwWc4Gvb+WqcH652AaAyuv9tNaCgmKMBjYB8U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jmf48Mxi; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jmf48Mxi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782880039; x=1814416039;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HFHTR2ovwVv0ljvMnTj7YU4r8CD2WWTIFF2TWTSvghA=;
  b=Jmf48MxivywMXwfGRdg5NcAY36skOGQgbYv6IxVTjLphGXL+yigmab7H
   Y6vztAU5yzpqJ5yjpAIgKj8S2CZLigGpeaOa/5Nr5fEJj2bi+fTkEvZGD
   QjT/nPXzTZMgWpJFiS0EIyy43799w/Do57OQeLuFprXzlSwscuPzCVH5y
   txcytupPWQhkhss3HTc60yoZCCG7zxdnYn4wRp5d0Cf9ZWXEzSyViMuji
   hzwMB7baX62J6YvK420pBR+kyEFe/RDDCmkY+4ikWJ6smFDYxIPUzt4o1
   YmKm539odNN8yxUuk5Ld5E2efIG2FAMXZRWEZObUkuCQCMQMzqAWkXj40
   Q==;
X-CSE-ConnectionGUID: D8UrJkCfQiaJ5glMT7FRAA==
X-CSE-MsgGUID: E5on6QOORIOyRDH+EbuaFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="87514234"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="87514234"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:27:17 -0700
X-CSE-ConnectionGUID: lI+ZCdDLQ6OR0ULnjiae0Q==
X-CSE-MsgGUID: tioRJDvWSfu2VehdnclYaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="249080552"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:27:17 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	ben.horgan@arm.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v5 01/10] fs/resctrl: Use correct format specifier for printing error pointers
Date: Tue, 30 Jun 2026 21:27:01 -0700
Message-ID: <b4a45de57eca6364b7df9455f9eb25aa9bab5807.1782857711.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782857711.git.reinette.chatre@intel.com>
References: <cover.1782857711.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use correct format specifier for error pointer as coccinelle suggests:
    .../fs/resctrl/monitor.c:148:8-15: WARNING: Consider using %pe to print PTR_ERR()
    .../fs/resctrl/monitor.c:760:9-16: WARNING: Consider using %pe to print PTR_ERR()

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
Changes since v4:
- Add Tony's Reviewed-by tag.
---
 fs/resctrl/monitor.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 7340b1d17f17..29b13a690cf3 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -144,8 +144,8 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 	arch_priv = mon_event_all[QOS_L3_OCCUP_EVENT_ID].arch_priv;
 	arch_mon_ctx = resctrl_arch_mon_ctx_alloc(r, QOS_L3_OCCUP_EVENT_ID);
 	if (IS_ERR(arch_mon_ctx)) {
-		pr_warn_ratelimited("Failed to allocate monitor context: %ld",
-				    PTR_ERR(arch_mon_ctx));
+		pr_warn_ratelimited("Failed to allocate monitor context: %pe",
+				    arch_mon_ctx);
 		return;
 	}
 
@@ -771,8 +771,8 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_l3_mon_domai
 	} else {
 		rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, evtid);
 		if (IS_ERR(rr.arch_mon_ctx)) {
-			pr_warn_ratelimited("Failed to allocate monitor context: %ld",
-					    PTR_ERR(rr.arch_mon_ctx));
+			pr_warn_ratelimited("Failed to allocate monitor context: %pe",
+					    rr.arch_mon_ctx);
 			return;
 		}
 	}
-- 
2.54.0

