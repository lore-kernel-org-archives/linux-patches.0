Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7E12E7635
	for <patches@lists.linux.dev>; Fri, 20 Mar 2026 22:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774044237; cv=none; b=nwAl9lV926o9Aa7zZt9nOCnf8E+vEk7rAGA18Xl228I/Q685QkTfCoyCjZ/Qb+Ex8updDtHD5Z3dUTUJUKkLDV+Qc9eZOfKEMjdNlS0Kz6hpQcmdpZQqTh991koXoeBJpP4BDhHDRtXzlYGcVM9Zxg2XfAW+KeZETQWASxc0l1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774044237; c=relaxed/simple;
	bh=dxMeQSQAI9H8hX2jXObajzEdPFMeYDHhhrSWJaEFRwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M24JGO8FT4YFCnRDso/CwZ3tIYokZP9rmL0uSkh9EIg6oC7so9j1jSnuOYQ4o5x6rAisq3gl/0zkEPfAz4zMS465WY1PdjUgud8+O+77zUrDJajyWsUUqer0JnIqkzSXT4g9nvekfMcR79CD8hwJXhTGi9L9zOfDoSOsZp+B8oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CY6ZV/yf; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CY6ZV/yf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774044236; x=1805580236;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dxMeQSQAI9H8hX2jXObajzEdPFMeYDHhhrSWJaEFRwc=;
  b=CY6ZV/yfg/osb7uDMhxn5SfMoiRXuxnDidzCngjszEfaIc8vZ2JE9zAf
   G4bMrT3TUtsTvjzRRDhcM3rKf/Xs9WStwsZcvsW8fHTkhZo7cb+VdIElz
   VMZqj9USlUriF9w6uP173foYEWa41TP3jx/p+7nEWItMqvQ5HzZbokN3b
   w2atSq7kPPxrqRLshTsnyr0VooVTdUpVK5ivk5XKm6hkrp12ojTgAvIxB
   xuB1wv3vexlHhtPrrhgx4uikaYvugPLNdA5ZKU4s0K8OQvuBltEGTYoRi
   hMn2RhkdUWsCl0nOgwcefxSlKAZwvkXB5YCJJsI0w0QQV7xI+sgJs9zwj
   g==;
X-CSE-ConnectionGUID: xdDr2qQGSNCRR6BexHbiSQ==
X-CSE-MsgGUID: khUG3IfIQEC0SxVA2Z/ANw==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="97758365"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="97758365"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:54 -0700
X-CSE-ConnectionGUID: kjgW30mDRiqcqnbSuLmq9w==
X-CSE-MsgGUID: D1js8yzHTdK8hJxtnJ6ogA==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:54 -0700
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
Subject: [PATCH v2 04/14] fs/resctrl: Use correct format specifier for printing error pointers
Date: Fri, 20 Mar 2026 15:03:14 -0700
Message-ID: <a53c700d3f555953283750a1ac089359e4b94e04.1774043709.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1774043709.git.reinette.chatre@intel.com>
References: <cover.1774043709.git.reinette.chatre@intel.com>
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

