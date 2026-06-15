Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD60B31355B
	for <patches@lists.linux.dev>; Mon, 15 Jun 2026 18:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781547912; cv=none; b=rR+M4Enk5BQbO8/c76LVTMcGLJKbxxmZ86wbKdJ620xa9Ifr9KkK8PZwh8Rh3HJOLxB9kgXBB+yBcP3Z4tZJrBIZ5SvQIjJGCijWuyjFxK8ipd+ekI4q+29y0Pk7MO8DLiFsG9AsxVw0wkj0PcTQZ6tkGoYMEGuYNXOxeIBPObM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781547912; c=relaxed/simple;
	bh=rrS+ShOnTIe+Z2HmkEebbrrhPJuER4oUO425uK51bII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsVmdkDEBHnveaN+/W2zrzYkfLgDIFctIMtNsiPvYu4fYz93VYqgkEaPzl5E+JkPrcLLwn+D+X5W9sULMmJPHbf1UN3aKhCGYln6P4rB9+0KkTbFuwzeWLcQBiVXbyKJ3+e/j7rkTriuuF4dJLjs1IoKg349Dk5T8Rmk+YojVJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gFV2Hvvg; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gFV2Hvvg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781547910; x=1813083910;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rrS+ShOnTIe+Z2HmkEebbrrhPJuER4oUO425uK51bII=;
  b=gFV2Hvvg0Zb53yWfvwLkPV7tgl1UYBTooz4X/hlgXtGNIqDxZEOtuj+c
   OZ3MakyAglN8e5vFsbbuZNbLjixVNxGJvlVu8anTxKkozvHMyO0saJVdJ
   ZKpTjLQr/F0ti85HJOJ5HRnRE6EkbB/PAtZx/Li/dUT15qZx8MlWE3RxZ
   xySukeGz9n1365hucq9eJ8Fp60eJuwDhn17XoZPHpTT7/OV4mmbizeYQN
   cMDchRYAuwBMaRGQNJ2teF1QzvGyt1zHK2gnDP3UjQBnrUStosl6FpD37
   Eg+e0hE4AxW++2UkbpB7CdIizBh46NVsCVGZN4KWuyVJbxvbkw/NMgPdM
   A==;
X-CSE-ConnectionGUID: D724ucs1TCG1awAKBuqaCg==
X-CSE-MsgGUID: 658XR2UaRXKMMgUw/WV9hg==
X-IronPort-AV: E=McAfee;i="6800,10657,11818"; a="93789929"
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="93789929"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:06 -0700
X-CSE-ConnectionGUID: Hiw8gGhmTdSRUJDF0M5Pjw==
X-CSE-MsgGUID: YWU09aL2SBSc7ZRCMbp/dQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="247620593"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.121])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:06 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v8 02/16] fs/resctrl: Free mon_data structures on rdt_get_tree() failure
Date: Mon, 15 Jun 2026 11:24:43 -0700
Message-ID: <20260615182457.14725-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260615182457.14725-1-tony.luck@intel.com>
References: <20260615182457.14725-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If mkdir_mondata_all() or a subsequent call in rdt_get_tree() fails, the
mon_data structures allocated by mon_get_kn_priv() are leaked.

Add mon_put_kn_priv() to the out_mongrp error path to free the mon_data
structures.

Fixes: 2a6566038544 ("x86/resctrl: Expand the width of domid by replacing mon_data_bits")
Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Closes: https://lore.kernel.org/lkml/5d38c1fb-8f91-472b-8897-24b2f50c772b@intel.com/
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
---
 fs/resctrl/rdtgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index a6376a3fc4c3..506b40dc9430 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3071,6 +3071,7 @@ static int rdt_get_tree(struct fs_context *fc)
 		kernfs_remove(kn_mondata);
 out_mongrp:
 	if (resctrl_arch_mon_capable()) {
+		mon_put_kn_priv();
 		rdtgroup_unassign_cntrs(&rdtgroup_default);
 		kernfs_remove(kn_mongrp);
 	}
-- 
2.54.0

