Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD5E361658
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 18:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772477190; cv=none; b=ZpraQ29nYcEJ+mpJryAZw8mXSelJHnfQtiOoBScE1BBAf2TIofB7euHYFO6xEBR/jb7hAI+zsxORziVmMmxlnGGUadec6yQEHAfTShiW688+ZNCtvCbRsgiYSdZ15Jok5V7jr+DK9NNxqy1ZJj9SFQg4LsJU7/hNz220qRI4UhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772477190; c=relaxed/simple;
	bh=CwrHQgPqOa0N4wtOACFz3iQnSLts6rYcN5/ddoUE6hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfx1p3THMyoHM/80u+Cr4hNn4SiheOehFl55kUpH4RotTwuTXhGKfZox7ZRoePyz01ig1e3FnIqK+ccra9oqVgrQJzBl/uolEh9Zoe3X8K7rwKl8USVUclKc2U/K+RNK8vN+RcNpeNSVh9QP6qvRMPfrf7dllQhXrpiq3ZmnP4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R6skcoYT; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R6skcoYT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772477189; x=1804013189;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CwrHQgPqOa0N4wtOACFz3iQnSLts6rYcN5/ddoUE6hY=;
  b=R6skcoYTr2dUOJWFY5JX8n/RdvUYisJlUXmpUCtuqxiHt6rAV3bYsVb2
   zp8lFqK2RRN0bU/DALDhQfy5kTvcxsKq2X4+k9AjJeEEP6BcogSR/4xQn
   R++1s1tGQKsX0nrv9kmiqr0losLn+LvPqYRPYAudKimY+S9uXgY+Ohc3K
   iu+CSIecxnwftzqsujoPtO5rvOVWudXdsa2xZ9BhcNkEwY/Ju24Qe9HPY
   seRY7i6bYmPaoKGXSmDUgeCpbxlTYbgtWWUpO7jkEpaO9DvzOo8jXhJtW
   cuftFryw1eUvneWtZn1Rj3p99GNAWYLtJA7M3hE7xtLOk2bzkjxF68Ms+
   A==;
X-CSE-ConnectionGUID: S9uegYAgQMSah0W3CvKIoA==
X-CSE-MsgGUID: yVyJqIklQZ+wNOfRY4Eumw==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="84135446"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="84135446"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 10:46:26 -0800
X-CSE-ConnectionGUID: ZOSBaofOTT2D/GqNz4h9qw==
X-CSE-MsgGUID: MmJAruGuRCa+lDPCZdrUCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="255604083"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 10:46:26 -0800
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
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH 03/11] fs/resctrl: Use correct format specifier for printing error pointers
Date: Mon,  2 Mar 2026 10:46:09 -0800
Message-ID: <ffd0409345fa42dfafa73b1e5affa67be8b758c2.1772476561.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1772476561.git.reinette.chatre@intel.com>
References: <cover.1772476561.git.reinette.chatre@intel.com>
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
---
 fs/resctrl/monitor.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 93db7c1cd7be..421c70f96426 100644
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
 
@@ -752,8 +752,8 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_l3_mon_domai
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
2.50.1

