Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DABF2E1C79
	for <patches@lists.linux.dev>; Mon, 11 Aug 2025 18:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754936258; cv=none; b=lfk5cLBMr9Ps0x/7+FCg2zlg92hnEFcAobu1zzEVuiT9t1X3tG7n6ngQTETlU/Ctp7gGTGTav9wGaM9Mt+8Tod/+SlddOMI3A03IlmFrsAf6tH40rTh7oP/btpjo7csOEM9dXWtGMTQL3JOJVrZzrJh/Dyl1zdehrv3+V6JpNfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754936258; c=relaxed/simple;
	bh=gnLa9WvyRdjIUFjfbMI1N4aTtFJiDEPN/R7F6YbjB9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQotYIr+TAqa3iGKpuSijKNZ9U28JkzdNwqc5uTdZI2bQOmwl+hCEejREY0PRU8CK2YPJFZuMAZujfFh5S3q8YUrLJpxVHJ+TntyjVSMeIBKARgxJYm6PihPHI/oibTNQLNjHZcRc03W0quRP4UGsCDIBhb3/O1fnSbTuqRCU5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BBbU0A6u; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BBbU0A6u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754936257; x=1786472257;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gnLa9WvyRdjIUFjfbMI1N4aTtFJiDEPN/R7F6YbjB9M=;
  b=BBbU0A6uWPZkuGUtNNYNYLty+cacsnxf+MsuEtn1G5i46kyFrsHBq/Vx
   KAehwaov5LB9ah3IiINGFPvaslR8t2eJKqbgDTXMGpwhDk2Wd09Lo+tTi
   djPUmsxJYXFWfQtBZRBdXq7CS7Q/3rD9frPXG7GxEnIR15iYS3xE28og0
   S49leD0BCyhIBWOox2wuwynuDPdGYP/CWxfpd3xaiTlrkz5DvC1K+RMD5
   SJ1nOUwEJQZYR/vd0qcG6AMBwBmtEPdzunDDislgxFbyM+6z2hklq4FA+
   /O4X3dnSRfu9G9mtB8yip0j8H1gdbokZFGHTihop7EMXBFeRfJOQmAM2y
   g==;
X-CSE-ConnectionGUID: GZJHfDOtT9KnO8xusuJaGw==
X-CSE-MsgGUID: fpmvcboiQze9oM2NzeXD0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="68277375"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68277375"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:26 -0700
X-CSE-ConnectionGUID: /FtfbUo3QRChOZIC8+aMDg==
X-CSE-MsgGUID: lP23JNMuSN6SmvVVc9cE9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="196825635"
Received: from puneetse-mobl.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.229])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:23 -0700
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
Subject: [PATCH v8 08/32] x86/resctrl: Clean up domain_remove_cpu_ctrl()
Date: Mon, 11 Aug 2025 11:16:42 -0700
Message-ID: <20250811181709.6241-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811181709.6241-1-tony.luck@intel.com>
References: <20250811181709.6241-1-tony.luck@intel.com>
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
index 448c2bf9837d..911100994fcd 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -603,25 +603,24 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
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
2.50.1

