Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901E1305E0D
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 20:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764881658; cv=none; b=RxH1+ed+U2CP7Aq6M3GQGwUNcF8w3MaOmnjnSM+nYqsQEK02n8FwClzWbohkl8ZNrBp/KLXakhLcyHi1FeMgKmq2Pf0xdgJ9twlbYCrAV1kOG6vn2hKl6NHpfkvvnUwS/z/40YgGa9DRYCsMBZ+9HinwZgpsdidG7UVoSyEBMAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764881658; c=relaxed/simple;
	bh=u7RmMkbdyc5QHVMIPLc9Jc97zGTH0J2VNf3TiEGFH8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfNjZDMAROOP0tQ1TTnTrmCZGVjrbx505USigS7zPISJXvNxKa4+8JEa+GGl14lM4YpBz0SJWIW1Qm8XFXCJuRZ6GEemcwbUlZisoCRlzbFaa13iBsyb01tXRiNnRUcrGkrHNYaKvrGiN5tFjFgPO1exW/KHKFLj/wIZyzU6gKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=albmORFp; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="albmORFp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764881656; x=1796417656;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u7RmMkbdyc5QHVMIPLc9Jc97zGTH0J2VNf3TiEGFH8k=;
  b=albmORFpXPIz2/14KJp6wus+fQSm+MIZeIudrlfFZxpnH17c4ZNVgDOF
   R01U7FvH3e5eksVUZBqj6ethmlRBkgtmYhuSC4S5a0fux4lnSoNeTn80Y
   4NkzoioYBrzjsvke8YYAcOGWznmSNPExPn9lc83Bi41ZRQXNMcEqqG/bS
   nUE9a49Nks8Y7Q4pm+HdTImM6DY8y7anr091aiKeshXcyGCwlMjajnSig
   +S9f89kvgXROwIpnGI0e40nYG19+FDZPDAuftafeXB0W8Upetypw4zw+T
   hGmcDavwRoqznuu1fjNL4Ba3b86a2KlJByPnD6EbdqPi8aU8J1TBk9B2O
   Q==;
X-CSE-ConnectionGUID: uglZkGIBQa2mJDyjTwfFyQ==
X-CSE-MsgGUID: ADd6Z0mRTfSUDOUM29vx4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="69510870"
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="69510870"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:15 -0800
X-CSE-ConnectionGUID: NcU3xXg5TH2Gzt2EMbxyYg==
X-CSE-MsgGUID: 0QncwkP0RmyL5VrIa32hxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="225752734"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.165])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:14 -0800
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
Subject: [PATCH v15 04/32] x86/resctrl: Clean up domain_remove_cpu_ctrl()
Date: Thu,  4 Dec 2025 12:53:34 -0800
Message-ID: <20251204205404.12763-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251204205404.12763-1-tony.luck@intel.com>
References: <20251204205404.12763-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For symmetry with domain_remove_cpu_mon() refactor domain_remove_cpu_ctrl()
to take an early return when removing a CPU does not empty the domain.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 49b133e847d4..64ed81cbf8bf 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -604,28 +604,27 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
 		return;
 	}
 
+	cpumask_clear_cpu(cpu, &hdr->cpu_mask);
+	if (!cpumask_empty(&hdr->cpu_mask))
+		return;
+
 	if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
 		return;
 
 	d = container_of(hdr, struct rdt_ctrl_domain, hdr);
 	hw_dom = resctrl_to_arch_ctrl_dom(d);
 
-	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
-	if (cpumask_empty(&d->hdr.cpu_mask)) {
-		resctrl_offline_ctrl_domain(r, d);
-		list_del_rcu(&d->hdr.list);
-		synchronize_rcu();
-
-		/*
-		 * rdt_ctrl_domain "d" is going to be freed below, so clear
-		 * its pointer from pseudo_lock_region struct.
-		 */
-		if (d->plr)
-			d->plr->d = NULL;
-		ctrl_domain_free(hw_dom);
+	resctrl_offline_ctrl_domain(r, d);
+	list_del_rcu(&hdr->list);
+	synchronize_rcu();
 
-		return;
-	}
+	/*
+	 * rdt_ctrl_domain "d" is going to be freed below, so clear
+	 * its pointer from pseudo_lock_region struct.
+	 */
+	if (d->plr)
+		d->plr->d = NULL;
+	ctrl_domain_free(hw_dom);
 }
 
 static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
-- 
2.51.1

