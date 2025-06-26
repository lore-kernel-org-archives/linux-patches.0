Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833FA2ECE88
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 16:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750956598; cv=none; b=MDz9wBAN8I8PvvWEU+0DZV4xYrBqzLp+nrDHu0NAJ9PiDJFDtYK+ztARK94OMsTojtMJNP6WKdaP0a/vHhlbOMOSOK4CRmhmkulw+477fGPl/7q0MvYSpFTXuGLFzqb0xQz/aGjhnfWxP6YyNxl8/KESWDytL+19i9QMXpnOOhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750956598; c=relaxed/simple;
	bh=Sz59o1KY9HW32CpIGuJWeV6g2Rwxdp5XLjIExlNvaF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUrGsb5VX6nws2F0+hW0mpZ2wrEyqmbSGN3XF1TsxaJZAxoWa8J8awpJTa5ea/HZPpU9biix8WyFRhYnRm4zX/mHMJUtaydVXgSfHtdJjtEP5X2RhcBTT8Uwr9sg5xSZolwCl8AYNQc2ALFInioNLAyQe0GSSYVrZyU/ifuuhQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KNHqkVmj; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KNHqkVmj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750956597; x=1782492597;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Sz59o1KY9HW32CpIGuJWeV6g2Rwxdp5XLjIExlNvaF4=;
  b=KNHqkVmjS5oxVIfu3mBaI3hPnmRbPyhDv+uoEHdPHqpx1CLMYm0PTpkY
   p468ezVZy/EZQ+wYGYTOJEmCWzBFXjXGViefsEkSz2g2ks758wO3OzCzD
   ATT/Lh4kh4DEO6YF8w07FLQVtID3tyYnavzQvlmrjG5n3e4zBKKtdXgwj
   riOVvItwoHYXUjveUlQa0vTrunHkmainvjuK4dKFQ8cxW0cLWjVjTcfYX
   FZSfeJqBOXHLCVfnXMic43tbZafMzC+QCubg2C64j6mMxn5GWYvF13s5h
   n+OmfV9kF5l3DMsIEjF99KxonK6+CxWKKsU33ig9MkOEtLyLNncximO/p
   A==;
X-CSE-ConnectionGUID: MWfEi/d+QVO1C3WO+RJZhg==
X-CSE-MsgGUID: ejknOIZoTzq0c/xg4VXnAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53136374"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53136374"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:49:54 -0700
X-CSE-ConnectionGUID: mFVPZ2+DQXecSM+f69O0yg==
X-CSE-MsgGUID: bZKfy6nFSFC6iGeGkdDzmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="153069193"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:49:53 -0700
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
Subject: [PATCH v6 08/30] x86/resctrl: Clean up domain_remove_cpu_ctrl()
Date: Thu, 26 Jun 2025 09:49:17 -0700
Message-ID: <20250626164941.106341-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250626164941.106341-1-tony.luck@intel.com>
References: <20250626164941.106341-1-tony.luck@intel.com>
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
index 4bf264b6a333..2075c98aa4e7 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -602,25 +602,24 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
 	if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
 		return;
 
+	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
+	if (!cpumask_empty(&d->hdr.cpu_mask))
+		return;
+
 	d = container_of(hdr, struct rdt_ctrl_domain, hdr);
 	hw_dom = resctrl_to_arch_ctrl_dom(d);
 
-	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
-	if (cpumask_empty(&d->hdr.cpu_mask)) {
-		resctrl_offline_ctrl_domain(r, d);
-		list_del_rcu(&d->hdr.list);
-		synchronize_rcu();
+	resctrl_offline_ctrl_domain(r, d);
+	list_del_rcu(&d->hdr.list);
+	synchronize_rcu();
 
-		/*
-		 * rdt_ctrl_domain "d" is going to be freed below, so clear
-		 * its pointer from pseudo_lock_region struct.
-		 */
-		if (d->plr)
-			d->plr->d = NULL;
-		ctrl_domain_free(hw_dom);
-
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
2.49.0

