Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2320B22A808
	for <patches@lists.linux.dev>; Fri, 11 Jul 2025 23:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278037; cv=none; b=ocA35ijbQGpEM7VuC/SjGbjtY58OBKs6yWUCgbrVsSJzDk+FdZWblIvgBXqDNjV+/FA6EL1DUJtDsPckB+rTHqReWlUTAjkj6JwS9M89GxEpeILj4PHmFVE25u8FgD6sIvUFgR+ABOT8Y5dB73nLZ54smst+VIogc2AeWR1tenQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278037; c=relaxed/simple;
	bh=VHRf+mGIrozE+oV4LMoAjhsGXkn+kVu3oSxagW1Qi9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNdj8C2YQiXASrxH2dZBSCQvwIbbFtIhVTiYdlIq1piJgh41lt+pu90SmayZsqlf19Ll8fyykoSXbyBLlcD+MNqOYOZwFUbtYG27PhUHufRMuAb+Xc9Xe37K/BwPHQYH4ZSHppJ7ZFCmjKEoGy20lOo43DHtXL2n1LuN1y1MMG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L2IfFXkf; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L2IfFXkf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752278036; x=1783814036;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VHRf+mGIrozE+oV4LMoAjhsGXkn+kVu3oSxagW1Qi9Q=;
  b=L2IfFXkfjI3Re/WDcEvn+xzDhMbEzOhoy5IevyC+n5BrEN2XkpXlZ4+V
   LiGn3ElA24siVRght9uxbMLuwOLgaVOCg0Iy6IdhIJxJ2MrJsJaYDZF9g
   x+kwMN1VM7BWk+Vzf7MoY85WPLROzjX0kL9PcpXsGj1IwGLRsefKBAI70
   PW2gMuG+vWKe1VuTfdjnE2qv7eQFZyU/3qI/fzAvkO10MXILGG98lEhps
   Zb4nR9yDFOPPWlMOA0VHJICMP9PGl+wipSoRmvpmpReW167bBS1OXDXWN
   FRgfV41JtvkqguDwfp7UiREZrUGkhoXp+VjOvTk+xqa3i7am7TNBYCC2F
   Q==;
X-CSE-ConnectionGUID: nPQ2GOm2RCeEN5F5rJnFHA==
X-CSE-MsgGUID: eBMo63YGQoWnt8On59U0sg==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54292635"
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="54292635"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:53:54 -0700
X-CSE-ConnectionGUID: +bOH+iBnRGqXkcgqYz5XWA==
X-CSE-MsgGUID: IV0fDzo3SdueiJyYwkf2aQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="155902110"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:53:55 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v7 08/31] x86/resctrl: Clean up domain_remove_cpu_ctrl()
Date: Fri, 11 Jul 2025 16:53:15 -0700
Message-ID: <20250711235341.113933-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250711235341.113933-1-tony.luck@intel.com>
References: <20250711235341.113933-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For symmetry with domain_remove_cpu_mon() refactor to take an
early return when removing a CPU does not empty the domain.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 49e17c246c60..0c5ada54bb20 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -602,25 +602,24 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
 	if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
 		return;
 
+	cpumask_clear_cpu(cpu, &hdr->cpu_mask);
+	if (!cpumask_empty(&hdr->cpu_mask))
+		return;
+
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
+	list_del_rcu(&d->hdr.list);
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
2.50.0

