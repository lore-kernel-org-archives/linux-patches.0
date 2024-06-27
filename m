Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D9D1A0AF6
	for <patches@lists.linux.dev>; Thu, 27 Jun 2024 20:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719520757; cv=none; b=orzMrve2Me71CMII7YnZjeLhGUyyUANuGm/x4h9eNZt7K9/vo1lkBVnzMB72Pso4opoqVZdVFgzO/4wMCB8oI54Fz4RnlF2cuun4R1oHv1E9xLmt/B+yrKVIZGBU4QcpdE6VtJFEUKfCi2RfumudwiOZc6RorSNcWQlt28qf63M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719520757; c=relaxed/simple;
	bh=fJdyJmm169ahsAE7AU4WeTiO841LkwbRErK0K/CR60c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHP9XrsOJbzZ+lsdzNETENF5SAYyf15i/UeqzCX+ifN+crDbuiC6MDGNBkOcSyzHyOyLJheKgBk9O61XXTsouy3CEZBNs3LZRY0KGwK1xj8rXFPg0pcjaEjH4V9eOfXW4eTZ9nES6j2Z0dL8NdbJrNSSkmWD1nr0vXaYI0lYidI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bZOlYAek; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bZOlYAek"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719520756; x=1751056756;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fJdyJmm169ahsAE7AU4WeTiO841LkwbRErK0K/CR60c=;
  b=bZOlYAekppoQEa6hAhfuDR5qoyN0J8a9BEF3PzqC6a7WWh/VeSUFwXm5
   MIh3wfFUh8Y1IFVgR7kggRDzws5bdAnvx6wVy0M8kJi/rOFBb7CLzuj30
   9OUpEq89cb5NnUwF0NmnwODxdKhSwQQDttyRtgJBjIzfV+UhI/S0ZMPN2
   R9/+8XwoX/cyCy2ODqN4QkjCS2nXSvdP+znEMlnU+mCh41eFIOOYw6aF4
   kSJfWwe7L95BDOFqedtQ8I2UiVyChbyVHz/C7FHYwtYNpB2oEFRc1oWvP
   b/+sHIh0unQfxQiL76UNjZkBYPf90d7h8a8NjXF948qeNi9Q76S2BNPij
   w==;
X-CSE-ConnectionGUID: CQUwnxxBTG2WPfyLAmSQ2Q==
X-CSE-MsgGUID: l4WiHyUMRU6KnFhoUYJzNQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="16809815"
X-IronPort-AV: E=Sophos;i="6.09,167,1716274800"; 
   d="scan'208";a="16809815"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 13:39:10 -0700
X-CSE-ConnectionGUID: JpNs+7SFR66Cjb/jD/+CZA==
X-CSE-MsgGUID: M1P9tn/2RQ+9+T3tJezhQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,167,1716274800"; 
   d="scan'208";a="82052910"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 13:39:09 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v22 11/18] x86/resctrl: Allocate a new field in union mon_data_bits
Date: Thu, 27 Jun 2024 13:38:49 -0700
Message-ID: <20240627203856.66628-12-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240627203856.66628-1-tony.luck@intel.com>
References: <20240627203856.66628-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When Sub-NUMA Cluster (SNC) mode is enabled the legacy monitor reporting
files must report the sum of the data from all of the SNC nodes that
share the L3 cache that is referenced by the monitor file.

Resctrl squeezes all the attributes of these files into 32-bits so they
can be stored in the "priv" field of struct kernfs_node.

Currently only three monitor events are defined by enum resctrl_event_id
so reducing it from 8-bits to 7-bits still provides more than enough
space to represent all the known event types. But note that this choice
was arbitrary. The "rid" field is also far wider than needed for the
current number of resource id types.  This structure is purely internal
to resctrl, no ABI issues with modifying it. Subsequent changes may
rearrange the allocation of bits between each of the fields as needed.

Give the bit to a new "sum" field that indicates that reading this file
must sum across SNC nodes. This bit also indicates that the domid field
is the id of an L3 cache (instead of a domain id) to find which domains
must be summed.

Fix up other issues in the kerneldoc description for mon_data_bits.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 681b5bdcd2f9..13d862221f9c 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -127,19 +127,25 @@ struct mon_evt {
 };
 
 /**
- * union mon_data_bits - Monitoring details for each event file
+ * union mon_data_bits - Monitoring details for each event file.
  * @priv:              Used to store monitoring event data in @u
- *                     as kernfs private data
- * @rid:               Resource id associated with the event file
- * @evtid:             Event id associated with the event file
- * @domid:             The domain to which the event file belongs
- * @u:                 Name of the bit fields struct
+ *                     as kernfs private data.
+ * @u.rid:             Resource id associated with the event file.
+ * @u.evtid:           Event id associated with the event file.
+ * @u.sum:             Set when event must be summed across multiple
+ *                     domains.
+ * @u.domid:           When @u.sum is zero this is the domain to which
+ *                     the event file belongs. When @sum is one this
+ *                     is the id of the L3 cache that all domains to be
+ *                     summed share.
+ * @u:                 Name of the bit fields struct.
  */
 union mon_data_bits {
 	void *priv;
 	struct {
 		unsigned int rid		: 10;
-		enum resctrl_event_id evtid	: 8;
+		enum resctrl_event_id evtid	: 7;
+		unsigned int sum		: 1;
 		unsigned int domid		: 14;
 	} u;
 };
-- 
2.45.2

