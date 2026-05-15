Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F311A376BEC
	for <patches@lists.linux.dev>; Fri, 15 May 2026 19:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778873995; cv=none; b=SgSaGbpDZ3iWW6RqEEm855uOXyktlCynVYvShOOAwQmCZpyeqN1PsqRDh9oahivW0CDwFSabtmZp9DePvu4+Dej4ev5Fj1mpS5l+/89kJyKy0wPSrXGhMAHwOFUqMMl4qUlgp75ntiX1bMooJ2zasUV1JIObMKZXUxHiU+z6MUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778873995; c=relaxed/simple;
	bh=z6bA6belrSfAUypBILamq7CWKvxjiNvjUeDFMb09bws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iwpc3LWsh0LXtEwB3riCSVi+cMtAdOdRtaFBXTMpDKAPjXKGHEx+krNGwleq1YjtNtCEaFgXvujeCPald8g4kdwpxlLfGoxHwYoGFrhp2a8yMfXfEO8+br5QnBz0NZnVPkDLL95FqweDiSYh8zJUx6gEmDugvUWu6SCLwRMvTXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hwOyDBCV; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hwOyDBCV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778873994; x=1810409994;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z6bA6belrSfAUypBILamq7CWKvxjiNvjUeDFMb09bws=;
  b=hwOyDBCVP1RPpdRy4XjF7j8+J9LeiNqXlmAi6VDX6CiWaKyXCCUeMi1G
   Fo5SKWl4y6RvbDQCtzHdUGQw6yzS9PojMgrWCfcAs8fN0PfHhAxa/wnGk
   bCHOSQBRTmvoX8VdpF3H6hwf4eAFb4CLTzwEgOdpOWkgYZLVXLmhZrwLo
   CQXXis9sgsU4XfBV95nME4D5bhAHKbYLzxT9D217R2o5JUekHkgkFk2V9
   RIGNfaTDhhMMg5utC40fFuotA3Xj+jkxrC9SmPRlRdvRr1zCEfHNIfuG2
   eK05OU5GR1zThxQKoZNyK5I5Vx4J8JBH74yfctdb7U03I74DAxkS4WIoV
   A==;
X-CSE-ConnectionGUID: tw5HY7xOSamTAfO/v11l6A==
X-CSE-MsgGUID: ecexXqbsTwK1Xchlogvjew==
X-IronPort-AV: E=McAfee;i="6800,10657,11787"; a="78972223"
X-IronPort-AV: E=Sophos;i="6.23,236,1770624000"; 
   d="scan'208";a="78972223"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 12:39:51 -0700
X-CSE-ConnectionGUID: guA8r3jSQK2N9pOBgbOKEA==
X-CSE-MsgGUID: nDUIVyG0TkqxbGKosg3K7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,236,1770624000"; 
   d="scan'208";a="237916565"
Received: from hanvin-mobl3.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.27])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 12:39:50 -0700
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
Subject: [PATCH v2 2/5] fs/resctrl: Free mon_data structures on rdt_get_tree() failure
Date: Fri, 15 May 2026 12:39:41 -0700
Message-ID: <20260515193944.15114-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515193944.15114-1-tony.luck@intel.com>
References: <20260515193944.15114-1-tony.luck@intel.com>
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

Fixes: 2a6566038544 ("x86/resctrl: Expand the width of domid by replacing mon_data_bits")
Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
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

