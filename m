Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A3433A029
	for <patches@lists.linux.dev>; Fri,  8 May 2026 18:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778264513; cv=none; b=qgLrNGhx+SUTJdd8b0pi6b5ayhHrP1tClBtovXqvPrQgGtGQvjZ9JEmKVs0KKGUdA5Ee1LafTuN9X9ToMXS+Ympm0tI9YaPYq7uCUOMc482/vXilb8tc5gDkSNCC5y75gPqtyPIRaeyBKkMZrUNkHbIadXsneZF4naDDEmZm7V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778264513; c=relaxed/simple;
	bh=iyT99zIiNSdIpIGtVq5Qi2AwJVE0RhhZFB5O0IQZy2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0AbhAc+iyR2A5PUwZkwj1gb1+OHnX9deVmqbxNcik/IVyd2nGzqyf4xklFuXWUSqiczHBTN6jEq1P6y3tppC7QY8P/+3g7l4Xz9Xya+Vp+Ifb8vRgfSUeuJ22IaycdNs181zHcL2JKfvP9chCIEOTbcvCv0X3Y0sAnOpKI+GuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bp8rBNyR; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bp8rBNyR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778264512; x=1809800512;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iyT99zIiNSdIpIGtVq5Qi2AwJVE0RhhZFB5O0IQZy2w=;
  b=Bp8rBNyR90VUViU18mYxjQ48fhijV+pWGSVQA+ewZvAMsemoyrBQiy2A
   QIN1+dti7WhU0ZbHYbffm2hI8+B/Wfc9i3IfGTVUFqTtkCWElyxYwQSYT
   zCktNxPHQN0nWiWdGfDiW8LizYAwA/k8cGDOaIwRBpUvdPZMkEVBKz622
   WkFm3XlH/dEn3r1UeHkfc9/+lB4vFqUIiBQdBlvXOygjpSRXhdHa2OgKP
   A0+uqTAq6mSgXzMFiCCX24B4/d3O2LcYhr8iC6Va4nRL9YF67uRAbsP0S
   h3AU5ODCvLr6sb72U4YFhGG8qKXmu0qwS7lg3XCLhv0Dnmk2E/CVWk5my
   Q==;
X-CSE-ConnectionGUID: DJZMYRrCRA+V2NdEVPveaw==
X-CSE-MsgGUID: tJaRiBUbQJi+/1895iOXmA==
X-IronPort-AV: E=McAfee;i="6800,10657,11780"; a="79264148"
X-IronPort-AV: E=Sophos;i="6.23,224,1770624000"; 
   d="scan'208";a="79264148"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2026 11:21:49 -0700
X-CSE-ConnectionGUID: ggcTjZMeQlKRrYyYCEzkVA==
X-CSE-MsgGUID: WcjcKCZkR5K62iw8favORA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,224,1770624000"; 
   d="scan'208";a="233776429"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.98])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2026 11:21:49 -0700
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
Cc: Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 2/4] fs/resctrl: Free mon_data structures on rdt_get_tree() failure
Date: Fri,  8 May 2026 11:21:41 -0700
Message-ID: <20260508182143.14592-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260508182143.14592-1-tony.luck@intel.com>
References: <20260508182143.14592-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If mkdir_mondata_all() succeeds but a subsequent call in rdt_get_tree()
fails, the mon_data structures allocated by mon_get_kn_priv() are
leaked. Add mon_put_kn_priv() to the out_mondata error path to free
them.

mon_get_kn_priv() and mon_put_kn_priv() moved so defined before used.

Fixes: ee4f0ec938ad ("fs/resctrl: Simplify allocation of mon_data structures")
Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Assisted-by: GitHub_Copilot_CLI:claude-sonnet-4.6
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/rdtgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index a6376a3fc4c3..0db1a92aefbe 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3067,8 +3067,10 @@ static int rdt_get_tree(struct fs_context *fc)
 out_psl:
 	rdt_pseudo_lock_release();
 out_mondata:
-	if (resctrl_arch_mon_capable())
+	if (resctrl_arch_mon_capable()) {
+		mon_put_kn_priv();
 		kernfs_remove(kn_mondata);
+	}
 out_mongrp:
 	if (resctrl_arch_mon_capable()) {
 		rdtgroup_unassign_cntrs(&rdtgroup_default);
-- 
2.54.0

