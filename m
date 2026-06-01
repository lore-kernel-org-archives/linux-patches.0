Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D84F2F7F03
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 19:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780343802; cv=none; b=FarTyIH43Zs8HVIomUe1XkzIntVnxluXzU964sqYootzYr7Wpft2UwPFIt5KzQSWp6+M3gArMkMmiliV0DWEzboGujsW06TQRynk1n4c0qBskDK0kbTbblxz0R5r7sfXzrTInZ68+DxEkkvANMhWlhhmW0B0fjnZ2n+H/rNY/hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780343802; c=relaxed/simple;
	bh=TKc6gWppFBsDVx6x4J5vR8ORMiG/xUxRFM8fxE7zof4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxYSxMqcLtFKq5KudRmyvoHBs91p9K+d0HW9BxufoKHsN0GuWDxJIZNizfSP7hkrCX6Bkvg3QXklvxlHQj5pnudz0vP//HStxXweqjEodKkYZeoCSjAtO9TchGg1vzQjsc2bvWeS6h/COPdm2MvJ+jrL/avUI4E0MzjZuUpFwAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dbd/iVvQ; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dbd/iVvQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780343802; x=1811879802;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TKc6gWppFBsDVx6x4J5vR8ORMiG/xUxRFM8fxE7zof4=;
  b=dbd/iVvQJ1PiSkv0rQ2pSdQmLg0oHeBMYjB/zM4ajWH/QwTfpkqvPu+Y
   Jk13qmXM/EYCO601ezlqIQIOLdCtQdPEcOPdGwmFnGADynmaWS4pdQ+zD
   nNI4pJMWLR50nlNNdpgo6LHuH//i2DOZ8Hx0kWN4OAvikYGCg/J9pE1XD
   wjCgjOcbbOgplNqt5cZAM0oGz2xYiUK+laNX0plJDFS1vGmRLclUo7jY8
   +u19mQz8cXmkdOVS5RnVowJV2zz4pQAM9LE1Mn5DO9koP0CoMOiJJPKLk
   bqEX2lx6+NUiIp4hi9cA69V/6CbW6PiDVD95HxENmekew7tOfdCsBL0J+
   g==;
X-CSE-ConnectionGUID: 3baLgGhKSPeaobbpgOtaww==
X-CSE-MsgGUID: 1f/m/fjUTwuO4WQ1BmmHmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="81011568"
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="81011568"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:41 -0700
X-CSE-ConnectionGUID: zfxHr8X9S4GzqSysE6NxjA==
X-CSE-MsgGUID: Y5M5YCjSTsauvDSib0OTPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="247946493"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.168])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:39 -0700
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
Subject: [PATCH v7 02/14] fs/resctrl: Free mon_data structures on rdt_get_tree() failure
Date: Mon,  1 Jun 2026 12:56:20 -0700
Message-ID: <20260601195632.15876-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601195632.15876-1-tony.luck@intel.com>
References: <20260601195632.15876-1-tony.luck@intel.com>
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
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
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

