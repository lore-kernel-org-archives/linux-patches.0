Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462582EDD5F
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 23:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765408477; cv=none; b=Vq4w9SS3JR2ucsAzP3z4pbymiZ/rS9pluFoPdmlMJ7ohgDS0o8OwtbP1TCVUiLaZSdUl+PnbzVkjUNf3gQWoxcW5Q0B2HHsH+WRGofj4LKd2f7vBk/PnYLL/j5fDievBmdMKJpV6hU6X8QB0SZuhRMS1ApL99CWB5suXefKC0AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765408477; c=relaxed/simple;
	bh=u7RmMkbdyc5QHVMIPLc9Jc97zGTH0J2VNf3TiEGFH8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtL+YlHuQBTzJ16cHTtqxQdJV4QMC7DTIwHD/AMNOsPHcNDKOgoEg/Z9L11Rm+dKNAjTmhi9X5SJwXakPOj8Hfwksy5gWtlFxFqHN2MDwMxtaL5cF9L4gUS6NOHnTuxgDf0jcuJsHSvTlfrlxV4ciUh/xnDCdDaoO5OxqBbDX/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SRdztRvi; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SRdztRvi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765408474; x=1796944474;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u7RmMkbdyc5QHVMIPLc9Jc97zGTH0J2VNf3TiEGFH8k=;
  b=SRdztRviQj418AlArtx+CFp1/FWcYNaqhJ3VJdPq34kQy52YLP3bebDG
   HunxzjkzkVHxyIqSPtbojpjZlLGDqML3oRZQB7bqfmq4jE7yNAhYyPFEy
   EFKS3KG0rjUL8AI5Qjt33Xz7cav1z1FE++J7So+gWhFmCZwPXWPdUSgSs
   xnrWNTKxAtlykrPEhSy9vXmJEGQy+mFTEHJkio7F9s2hv/xxgjd2zwUu3
   doypAiVlEGj45EXwRXbVJL71yDTVaAFfmXI8Cr+DKM+i2y0O8TfIhasQ7
   Zen3srBP9+nbx/HNuH6rwTQQWB3uJgxX1Ts6tjHys9hApOZZLcIfvFF7E
   w==;
X-CSE-ConnectionGUID: Jx9V8BDLQjqrrFXCg+Tbag==
X-CSE-MsgGUID: psOlj7XGQ+ehdU5Os2Mtxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="69973507"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="69973507"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:26 -0800
X-CSE-ConnectionGUID: DYWPofemSwSnJHnuTMKglw==
X-CSE-MsgGUID: qNSB5aUJSbyInlvxUf8QhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227297038"
Received: from daliomra-mobl3.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.254])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:25 -0800
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
Subject: [PATCH v16 04/32] x86/resctrl: Clean up domain_remove_cpu_ctrl()
Date: Wed, 10 Dec 2025 15:13:43 -0800
Message-ID: <20251210231413.59102-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251210231413.59102-1-tony.luck@intel.com>
References: <20251210231413.59102-1-tony.luck@intel.com>
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

