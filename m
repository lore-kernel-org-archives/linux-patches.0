Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D1530D40A
	for <patches@lists.linux.dev>; Fri,  5 Jun 2026 04:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780634851; cv=none; b=R7PLdxIqyYPSK5IpbvVdp58bvoQQwU8+aMHdDoCR1hXgs+whN067GPSZ36VSzp1VVKIIwzo4YRP6DNOqbYdYz6oeVBQRZ99Vhqt3R0Yxh6V9CCqY2fgFlmZMddCOw0hCMXxTgaqFcek1pPg4rFZTiNUZOiBAqlzR6Z9i0q4ws8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780634851; c=relaxed/simple;
	bh=97IGAAnBI1e+DTfT29z4xqc4kMta8WlkeU157gOp86U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YSLfv2fZAXubyL9HmHWLDETCxzBseSvGqkTI1CN3GP9kQhLhqJ29PtCf3+9LgTf9hR9SgokoITSZWlJkRogG/X0RKFsDAJahPKpxdNGORx3Fh4ATISq1J3Fhse/GNiv5oLGQ0dF87aDjaLVI6LfCts7+HVRDDuWCJdj5jh7SMP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IXx6LwFa; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IXx6LwFa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780634850; x=1812170850;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=97IGAAnBI1e+DTfT29z4xqc4kMta8WlkeU157gOp86U=;
  b=IXx6LwFaW9xHCAhPfPAhV5Y0hz1WETk33KH3BiWaJkIosYV6QGn6NXLl
   Yswog9O29ZgIXRtTr0/xx5VFXmBbgjMfwZvmSD8sTYVBzLi3TJXjdjKFn
   a8V5n1+SomFWNKH/aRaqzWz+aGN9GUfOSM55+4p6QnuCoH+4Kacod3ApY
   LV2/Uya/Hcr8jmsyFXyxVCA7f+7XKq5FgWIcZSK8dnNOker7t4p2BZ3nb
   slKddp8sxJ3X6xaXxtm3tFGVJnG2X3yGe0N/wB3W8e7NBROQZmozB5xpI
   8PdtJjSWNP211JUZxaKvnUUHEibu7dJYFz+wSeY+6e7yAz4TSJCFqi7CR
   Q==;
X-CSE-ConnectionGUID: QFmfRpQwSMadKxCC60h8TA==
X-CSE-MsgGUID: DxUOYr2ES/CoxRB+txOI8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11807"; a="81212921"
X-IronPort-AV: E=Sophos;i="6.24,188,1774335600"; 
   d="scan'208";a="81212921"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 21:47:29 -0700
X-CSE-ConnectionGUID: 2nBrIbehSZKQY1wdB2ZtsQ==
X-CSE-MsgGUID: ZI7qzas4RwWSe2xNou/ewA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,188,1774335600"; 
   d="scan'208";a="243658121"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 21:47:29 -0700
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
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v2] x86/resctrl: Only check Intel systems for SNC
Date: Thu,  4 Jun 2026 21:46:49 -0700
Message-ID: <9849330f45ac86344cc5ac54df2d313906d70bc4.1780634584.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tony Luck <tony.luck@intel.com>

topology_num_nodes_per_package() reports values greater than one on certain
AMD systems resulting in resctrl's Intel model specific SNC detection
printing the confusing message "CoD enabled system? Resctrl not supported".

Add a check for Intel systems before looking at topology.

[ reinette: Add Closes tag, fix tag typos, rework changelog ]

Fixes: 59674fc9d0bf ("x86/resctrl: Fix SNC detection")
Reported-by: Babu Moger <babu.moger@amd.com>
Closes: https://lore.kernel.org/lkml/37ac0376-43a3-4283-a3d5-4d57b3bec578@amd.com/
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
---
Changes since V1:
- v1: https://lore.kernel.org/lkml/20260428232657.107381-1-tony.luck@intel.com/
- Add Closes tag
- Fix Babu's name in tags.
- Rework changelog to describe less code and more what it does/means.
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 794a6fb175e4..645df3448cbc 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -377,7 +377,12 @@ static const struct x86_cpu_id snc_cpu_ids[] __initconst = {
 
 static __init int snc_get_config(void)
 {
-	int ret = topology_num_nodes_per_package();
+	int ret;
+
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return 1;
+
+	ret = topology_num_nodes_per_package();
 
 	if (ret > 1 && !x86_match_cpu(snc_cpu_ids)) {
 		pr_warn("CoD enabled system? Resctrl not supported\n");
-- 
2.50.1

