Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4946B2236E0
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 19:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780343804; cv=none; b=alIHuLAYxZ4qTh/Ys3D3gDBsm3kDahsKWJSYqvURRJ6dJcLs7o8emk+nQQXoEsZIXsso5e+n9jGsYt+waN+f3DB/726XD5SV4+zlgaJYTgUuG4Q0DchJ8rJvfg5ssn9kP7WyCIrg42DduOmZK9pBj6l4iFw3u76k8pQdYIsy4KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780343804; c=relaxed/simple;
	bh=KWzZiN4PnLBKT0ZxCr2BGbKILpgQE+52KEovuBGUNfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIGqIgKnCPDVEYT8B/2kDWzvUQQkY4C7sUSrqCfmJ1XZqDQ/lgilk5x/oZBpdDVYyXpMJC1xyxcC3CohdacE/ToL0E+wWmwcj9EfBTu4PvApaPswQxopmgQ1X4eHEHI+x1o9aXASkA+Yd/Dm2nMwe/VLZMtjyJj+AuHGeF5tNFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gY1KPrFO; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gY1KPrFO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780343803; x=1811879803;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KWzZiN4PnLBKT0ZxCr2BGbKILpgQE+52KEovuBGUNfc=;
  b=gY1KPrFO9UitqL4GvMD6DOm1hZW04QBjI2E2NHdmgEyP/hidIrNuD7WL
   XiQPRuhMuMcYLhjcN12YjCWr0JHteTiaHsM9BkoyUvX0STKrjzoKb9MvJ
   W2FraiXq6ONbvvXusNft9090UOb5y9W58snDGU1Ggrk9BzvZdexDGXzwd
   5yRi4u/x/T5SmBHwg3ii6GBTG44X0EnVqqJk33dXBqBgLrM1k1idH+5VL
   pkiYpzrVfPVGeB891ysFSluhqSMa+RP3YWVsxC+MzC/QC4deZczqsq6ZY
   tED5RWRjw19+zMdYRQN2KBOFMs4OcUKmTk77VEbtk02BP3aGsf8fXNaIL
   A==;
X-CSE-ConnectionGUID: W7Fi0KUBQXyiKPyvvNI61A==
X-CSE-MsgGUID: 6yB9GMt0QFWRKgpdiT857g==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="81011577"
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="81011577"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:41 -0700
X-CSE-ConnectionGUID: rnaDRR4rTHGNFIuff739MA==
X-CSE-MsgGUID: AB3hqHX5S+m7P6b0ZDXrHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="247946496"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.168])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:40 -0700
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
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v7 03/14] fs/resctrl: Fix use-after-free during unmount
Date: Mon,  1 Jun 2026 12:56:21 -0700
Message-ID: <20260601195632.15876-4-tony.luck@intel.com>
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

During unmount or failure teardown all mon_data structures that contain
monitoring event file private data are freed after which kernfs nodes are
removed. However, the RDT_DELETED flag is never set for the statically
allocated default resource group.

A concurrent reader of an event file associated with the default resource
group may, after dropping kernfs active protection, block on rdtgroup_mutex
while unmount proceeds to free the file private data and destroy the kernfs
node without waiting for the reader.

When the mutex is released, the reader wakes up, observes that RDT_DELETED
is not set for the default group, and dereferences the already-freed
file private data.

Set RDT_DELETED for the default group unconditionally since the flag does
not lead to free of this statically allocated group.

Do not allow a new resctrl mount if there are any waiters on default group
of previous mount. A new mount will re-initialize the default group that
would appear to waiters from previous mount as though the default group is
accessible causing them to access the mon_data structures from the previous
mount that have been removed.

Fixes: 2a6566038544 ("x86/resctrl: Expand the width of domid by replacing mon_data_bits")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260508182143.14592-1-tony.luck%40intel.com?part=2 [1]
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
---
 fs/resctrl/rdtgroup.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 506b40dc9430..ac3285ba8775 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -585,14 +585,20 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
  *
  * On resource group creation via a mkdir, an extra kernfs_node reference is
  * taken to ensure that the rdtgroup structure remains accessible for the
- * rdtgroup_kn_unlock() calls where it is removed.
+ * rdtgroup_kn_unlock() calls where it is removed. The default group is
+ * statically allocated: it does not have an extra reference but will have
+ * RDT_DELETED set on unmount to support safe access to its associated files
+ * via rdtgroup_kn_lock_live/rdtgroup_kn_unlock().
  *
- * Drop the extra reference here, then free the rdtgroup structure.
+ * For all but the default group: drop the extra reference, then free the
+ * rdtgroup structure.
  *
  * Return: void
  */
 static void rdtgroup_remove(struct rdtgroup *rdtgrp)
 {
+	if (rdtgrp == &rdtgroup_default)
+		return;
 	kernfs_put(rdtgrp->kn);
 	kfree(rdtgrp);
 }
@@ -2965,6 +2971,7 @@ static void resctrl_fs_teardown(void)
 	mon_put_kn_priv();
 	rdt_pseudo_lock_release();
 	rdtgroup_default.mode = RDT_MODE_SHAREABLE;
+	rdtgroup_default.flags = RDT_DELETED;
 	closid_exit();
 	schemata_list_destroy();
 	rdtgroup_destroy_root();
@@ -2990,6 +2997,12 @@ static int rdt_get_tree(struct fs_context *fc)
 		goto out;
 	}
 
+	/* Avoid races from pending operations from a previous mount */
+	if (atomic_read(&rdtgroup_default.waitcount) != 0) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	ret = setup_rmid_lru_list();
 	if (ret)
 		goto out;
@@ -4265,6 +4278,7 @@ static int rdtgroup_setup_root(struct rdt_fs_context *ctx)
 
 	ctx->kfc.root = rdt_root;
 	rdtgroup_default.kn = kernfs_root_to_node(rdt_root);
+	rdtgroup_default.flags = 0;
 
 	return 0;
 }
-- 
2.54.0

