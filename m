Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352633CCFC5
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 16:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775577759; cv=none; b=G2aJeUPDiRkIWK0YKpbPBrIkeRvAdiXIfapPQr9eWrU3GkMA4JltAzJ6vy9UW1/uW6ryHjxQn25u3gyndcVW5Rpe5myTahijrOYOtL/sokGvLuijqaR2NoO/U9lWFGgxoHeomaMb9TK7TnJUUIJtqEbjxzURPINpLx6knejr2ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775577759; c=relaxed/simple;
	bh=dxMeQSQAI9H8hX2jXObajzEdPFMeYDHhhrSWJaEFRwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azZFTwUjg4V3oHbKkYIZ5vkLvsbjfU6K2pKG3MI52bG2fG81J/iKqc6K+hL8xKkkVc5FneabGdJzEgnQ53agcVZlBmLYn6PxXM3aK4W6lLqhisbB8CTmIhUkqKGW7D1QSkuZTr2DzVTfxSOvFHNKvfCr74tJZYUzInz4kdpcUjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jLlCmAFh; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jLlCmAFh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775577753; x=1807113753;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dxMeQSQAI9H8hX2jXObajzEdPFMeYDHhhrSWJaEFRwc=;
  b=jLlCmAFhsKIwm55eEVAM+rv3rifF2dod1WydUnmeAbfMVn3JxWzgZl1I
   z92TCoUqcZmxJh5MWGJUn8EJHkGMYFKtAwlWeWqT5XZ7ad2d02yqtlZIk
   YbHWa5ix8XrVflGNJs7bZHqEsGT6UbJTN3wyy4o/R6sqyHr2tiKGce72v
   7MgbJC9DZsD46+iI7RPWm9hiGyiSvhanO8CpCyR4nFBM0YAsp/SONOB/w
   PMq/sALScgTtOZ3RXzSnPpmKi9+7J0I87wJ5l3XU1GrmzPPWFD5qYzELw
   VabjtNMC8UP5wsjtRAE5zi1i0j8P52ME8uxTtye2ivff/LICJmuTxJXjD
   g==;
X-CSE-ConnectionGUID: qOtrham/QUaofcUMcANJdA==
X-CSE-MsgGUID: z9CmKR4FQummrQsrxsmSqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="80432677"
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="80432677"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:19 -0700
X-CSE-ConnectionGUID: fCBkfvl1RguHnBh+eSDjng==
X-CSE-MsgGUID: LPtNjwpASKK0lUknhoHOBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="228119040"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:18 -0700
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
Subject: [PATCH v3 04/13] fs/resctrl: Use correct format specifier for printing error pointers
Date: Tue,  7 Apr 2026 09:02:01 -0700
Message-ID: <3ec5d5ca313451725e5e230648f3b14eb747b05f.1775576382.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1775576382.git.reinette.chatre@intel.com>
References: <cover.1775576382.git.reinette.chatre@intel.com>
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
index 9fd901c78dc6..8194fdfbea81 100644
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

