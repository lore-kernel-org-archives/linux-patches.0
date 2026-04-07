Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898253CCFCA
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 16:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775577771; cv=none; b=Ijee9Ym4qhpFcd0+48kN2ftJmJEW+djeIInzOgo0bo8dpKz+DIYn0saemkD5TvI6TbYgp/N0jR7CCQXQ3crW/8qcZBM/66Oxiwg2EO9LuWv4/4iPCFmPj72J7qo7//3UjLkvS5kwRqEHJ1ZQO8kSKANeYJas6FRpSRMCH/vHsEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775577771; c=relaxed/simple;
	bh=/aVegcj2Gd/PPwuq0w7v0DVXLWgC36AnHuP/93CopIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTvgUcaNbesaSvTUP1lnMKFwIGNu0ayylQwO6dYf00vpQysbb9/s6TBY1N14+cHKXhx4CzfszpLUqqQcQKZQwiLXN8nWHbHK+Jow9Sohxw2HRhgv8++uBkJ3Mf7uksFeEq4DmLGjDa9ngcvtcMbk7RgY/7RFQCpQxns7azkqSXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nurs0NBI; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nurs0NBI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775577765; x=1807113765;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/aVegcj2Gd/PPwuq0w7v0DVXLWgC36AnHuP/93CopIQ=;
  b=nurs0NBI+2iir0rhmjmrNDqVewR4Dfrb1u65eyj1Mw0u4gasCDTgiyJE
   pbv2bbWkLH4Yubki35+otS0TAEtM79dZkHLtsbPq2GjSqGO0pHxN7xQgm
   /ZXTINdihoqgHD8sLusmZZgbQsDSXLaPPuvm2RGb0Teu2Wi33L7PR1IdT
   bvOlm+AOk5w0685IQx32CHxo15DjFYnpcSjUb1uTtl9DHz02QIizM6HDt
   +ryQ2nXLrSa8KyLsXGeU1YWwaiWTX79d/QTg4+D6feTEbvGh9mgj+2thT
   nwGT3rJL8XWAb0z3chgcs8tcEqQFB1zfIB65hDgSE5lde/w0D5CJPp0Rt
   Q==;
X-CSE-ConnectionGUID: Z0RgcBTaSzmRnjlns1F6rw==
X-CSE-MsgGUID: liGWDfJlS4asPAS+xTrlsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="80432737"
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="80432737"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:19 -0700
X-CSE-ConnectionGUID: /8YAnnejSAaDG/xdgl374A==
X-CSE-MsgGUID: tiC2GrJBRM2uvnQt2g6P5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="228119056"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:18 -0700
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
	ben.horgan@arm.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v3 09/13] fs/resctrl: Add last_cmd_status support for writes to max_threshold_occupancy
Date: Tue,  7 Apr 2026 09:02:06 -0700
Message-ID: <3a55b9a6ced4d1cfc69894840afa747de592ce5d.1775576382.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1775576382.git.reinette.chatre@intel.com>
References: <cover.1775576382.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

info/last_cmd_status is intended to contain more information if a write to
any resctrl file fails. Writes to max_threshold_occupancy did not receive
last_cmd_status support during initial last_cmd_status enabling. Add it now.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since v1:
- Add Ben's RB tag.

Changes since v2:
- Switch to guard(). (Chenyu)
- Drop Ben's RB tag due to significant code change.
---
 fs/resctrl/rdtgroup.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5dfdaa6f9d8f..5e3ea92cc243 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -12,6 +12,7 @@
 
 #define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
 
+#include <linux/cleanup.h>
 #include <linux/cpu.h>
 #include <linux/debugfs.h>
 #include <linux/fs.h>
@@ -1238,12 +1239,20 @@ static ssize_t max_threshold_occ_write(struct kernfs_open_file *of,
 	unsigned int bytes;
 	int ret;
 
+	guard(mutex)(&rdtgroup_mutex);
+	rdt_last_cmd_clear();
+
 	ret = kstrtouint(buf, 0, &bytes);
-	if (ret)
+	if (ret) {
+		rdt_last_cmd_puts("Invalid input\n");
 		return ret;
+	}
 
-	if (bytes > resctrl_rmid_realloc_limit)
+	if (bytes > resctrl_rmid_realloc_limit) {
+		rdt_last_cmd_printf("Exceeds limit (before adjustment) of %u bytes\n",
+				    resctrl_rmid_realloc_limit);
 		return -EINVAL;
+	}
 
 	resctrl_rmid_realloc_threshold = resctrl_arch_round_mon_val(bytes);
 
-- 
2.50.1

