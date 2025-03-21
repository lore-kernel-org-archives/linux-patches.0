Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BB922B8B1
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 23:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742598993; cv=none; b=A04Em/5FOPRTjPvmEMCqpggpmK8GczTlTCHfnBbbQzy2Nzj+5HWbLADSPGOEaVxz6J0BVaRF12PYS89pYcDdQd3l16AUXFJxzXx22BBdmNhgTs4hul9XRTQRZnX93NdlxsUvDpOzgTte1ZwWpA0bub2IYu9EsthHeToQqaInGJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742598993; c=relaxed/simple;
	bh=zyJSs4pgybNOmlhgq1YSJUekw4r0a/e87UbI4q1QkN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iuXFWh0sRLzA+LuxpizYowFbe3twALGgmfuU5EfbtYbGZxBXbiNOqvRVYkok92E18cC27Z2/Tpsr4K6dxooHTEMtcZZSlR42/QAqLuIaaDQ3X4p7am3FZSiB4X5pINgUuZyD9m+P2BzBI1100+lllkr0VgM+K7ALRbzx8sfVdzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R602ZwvU; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R602ZwvU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742598992; x=1774134992;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zyJSs4pgybNOmlhgq1YSJUekw4r0a/e87UbI4q1QkN0=;
  b=R602ZwvUYCRZgE4fya3Z4cA0MyIL+GyCXQMsmcH2EQ32RJvMMGzAmLh5
   iFPs8xRn3ZtrNwSxHDD4yoGhH7NsdmLm5MP6dscxwpkUY0j+8iCNw6YqO
   vobd/aNE8bXnFXR6z/QlRc/jC+VJ5riSQz4IaGj+eEzqiWf4Bv2hm3NfR
   OjeIw+b5kR980gvqC8rXmSKE24eJW0CdXLNogk5FZtTR0rlqKS1saJx0T
   IK6zwTor7tvsgHKCpAi1JV3JOwxa9xANN51OTK8HpT13QN9b5tWojqWbA
   6kQEL84WHLXZw28O7e5QXujBWYoovYYUBrury9UT8E83YY2g8pGmGmaOR
   A==;
X-CSE-ConnectionGUID: BCNFjgNpSgOV2xIlsTH33A==
X-CSE-MsgGUID: 4ueBK+vLTMqd7jOjMdUnDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="43604656"
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="43604656"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:25 -0700
X-CSE-ConnectionGUID: U3x594cXR1uLlU/ztr53uQ==
X-CSE-MsgGUID: I6ii42T0QG6dLYNPLYYv6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="128354340"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:25 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2 16/16] x86/resctrl: Update Documentation for package events
Date: Fri, 21 Mar 2025 16:16:06 -0700
Message-ID: <20250321231609.57418-17-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250321231609.57418-1-tony.luck@intel.com>
References: <20250321231609.57418-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Each "mon_data" directory is now divided between L3 events and package
events.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/filesystems/resctrl.rst | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 6768fc1fad16..0e915b7c55aa 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -366,15 +366,22 @@ When control is enabled all CTRL_MON groups will also contain:
 When monitoring is enabled all MON groups will also contain:
 
 "mon_data":
-	This contains a set of files organized by L3 domain and by
-	RDT event. E.g. on a system with two L3 domains there will
-	be subdirectories "mon_L3_00" and "mon_L3_01".	Each of these
-	directories have one file per event (e.g. "llc_occupancy",
-	"mbm_total_bytes", and "mbm_local_bytes"). In a MON group these
-	files provide a read out of the current value of the event for
-	all tasks in the group. In CTRL_MON groups these files provide
-	the sum for all tasks in the CTRL_MON group and all tasks in
-	MON groups. Please see example section for more details on usage.
+	This contains a set of directories, one for each instance
+	of an L3 cache, or of a processor package. The L3 cache
+	directories are named "mon_L3_00", "mon_L3_01" etc. The
+	package directories "mon_PKG_00", "mon_PKG_01" etc.
+
+	Within each directory there is one file per event. In
+	the L3 directories: "llc_occupancy", "mbm_total_bytes",
+	and "mbm_local_bytes".	In the PKG directories: "core_energy",
+	"activity", etc.
+
+	In a MON group these files provide a read out of the current
+	value of the event for all tasks in the group. In CTRL_MON groups
+	these files provide the sum for all tasks in the CTRL_MON group
+	and all tasks in MON groups. Please see example section for more
+	details on usage.
+
 	On systems with Sub-NUMA Cluster (SNC) enabled there are extra
 	directories for each node (located within the "mon_L3_XX" directory
 	for the L3 cache they occupy). These are named "mon_sub_L3_YY"
-- 
2.48.1

