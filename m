Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91F247ECEE
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 17:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198289; cv=none; b=WC44Pk3BmqQk2NlVgxVL1u4zkPxZjfoPZk1gMbPzvxN7A9pETUJj8KdCr+Nk4hRWSJ0dggj7cLwlyRvS5/9QBpVLt8Fbgioa8nggj+ADZq3CbvzJsVpHAWdYa5j4LGpphqfIyH8dqc0nJvK+x6aO1h2FXReSpX01soLUz4pq1X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198289; c=relaxed/simple;
	bh=91EBa5uQRaoKN+Mj8RVfDYQW/im1Ba/0OaInFENxN/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUDAytIP7Fi4YaZMIUssEr+Xmt9WWpVxey76kIK9ktox/b9ZqdvcnPAd9B0qEM4cjyc0WMz/7+CmvqecKHC6i+7PAIospp+m1C6VZmwHOyuUnLi30MH0ClXvcP4AS2qNLVJpv62bH/cqzK/zW+KrEGpr/A5o1CyrKWqT4A/P5ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TN0bk56W; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TN0bk56W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788198287; x=1819734287;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=91EBa5uQRaoKN+Mj8RVfDYQW/im1Ba/0OaInFENxN/c=;
  b=TN0bk56WxgjGc9XwIEqtgZuSxuMwnQ15rdu7ento83xujgQ6fvvUxyQ5
   2+nFF+EPgIp84lQcCgyWz1orfIWeMj1eb5B4DBxuji85M0Uvv5dXMh/r9
   FKxjnFP5mn2NOOS0TkTRay0eiPDGAqShL9StPbpOA8T92VPZhKJZmTGFN
   5kbBFlkksPS0CGW0WB6qH7bMLeHnHCBxxc8X4lfLdqrHzWlwXFxtA1P6E
   p01knwfzuqAeh+uMNC8UGP0L7IAfRAd6y+/qcJAS5DUTbZb2SCUvz8O2P
   g+4EVEw06YMIeNYY+Hjjm2GU56YncUIx7K1PpMRAoAG01GftYOX2d7VCP
   Q==;
X-CSE-ConnectionGUID: pKgTRk8ESSuK6RbrsxDw9g==
X-CSE-MsgGUID: RxxFtGo7R0y6tfDs1B7LRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="92480084"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="92480084"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:41 -0700
X-CSE-ConnectionGUID: v/fhqOwVSGOiujUI1nGgMw==
X-CSE-MsgGUID: FtzOZojWQfSrmSWagUL2TQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="268907013"
Received: from aherrold-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.17])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:40 -0700
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
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v11 18/23] fs/resctrl: Call arch code for every mount
Date: Mon, 31 Aug 2026 10:44:16 -0700
Message-ID: <20260831174421.13921-19-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831174421.13921-1-tony.luck@intel.com>
References: <20260831174421.13921-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linux file system code provides no serialization of mount(2) system
calls. Without such serialization calling resctrl_arch_pre_mount() on
every mount before acquiring rdtgroup_mutex would open up many complex
races between mount and unmount operations.

Add resctrl_mount_lock to provide serialization and protect resctrl_mounted.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v11:
	New patch. Locking at file system level replaces v10 attempt
	at locking inside architecture resctrl_arch_pre_mount() and
	resctrl_arch_unmount()

 fs/resctrl/rdtgroup.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 3ac518ed2368..7f09d76dbf8c 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -30,6 +30,9 @@
 
 #include "internal.h"
 
+/* Mutex protecting resctrl_mounted and mount/unmount operations */
+static DEFINE_MUTEX(resctrl_mount_lock);
+
 /* Mutex to protect rdtgroup access. */
 DEFINE_MUTEX(rdtgroup_mutex);
 
@@ -3149,6 +3152,7 @@ static void resctrl_unmount(void)
 {
 	struct rdt_resource *r;
 
+	mutex_lock(&resctrl_mount_lock);
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 
@@ -3166,6 +3170,8 @@ static void resctrl_unmount(void)
 	resctrl_mounted = false;
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
+	resctrl_arch_unmount();
+	mutex_unlock(&resctrl_mount_lock);
 }
 
 static int rdt_get_tree(struct fs_context *fc)
@@ -3177,24 +3183,27 @@ static int rdt_get_tree(struct fs_context *fc)
 	struct rdt_resource *r;
 	int ret;
 
-	DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
+	mutex_lock(&resctrl_mount_lock);
 
-	cpus_read_lock();
-	mutex_lock(&rdtgroup_mutex);
 	/*
 	 * resctrl file system can only be mounted once.
 	 */
 	if (resctrl_mounted) {
 		ret = -EBUSY;
-		goto out;
+		goto out_mount_unlock;
 	}
 
 	/* Avoid races from pending operations from a previous mount */
 	if (atomic_read(&rdtgroup_default.waitcount) != 0) {
 		ret = -EBUSY;
-		goto out;
+		goto out_mount_unlock;
 	}
 
+	resctrl_arch_pre_mount();
+
+	cpus_read_lock();
+	mutex_lock(&rdtgroup_mutex);
+
 	if (!resctrl_alloc_capable() && !resctrl_mon_capable()) {
 		ret = -EINVAL;
 		goto out;
@@ -3289,6 +3298,8 @@ static int rdt_get_tree(struct fs_context *fc)
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
 
+	mutex_unlock(&resctrl_mount_lock);
+
 	ret = kernfs_get_tree(fc);
 	/*
 	 * resctrl can only be mounted once, new superblock only expected
@@ -3297,7 +3308,8 @@ static int rdt_get_tree(struct fs_context *fc)
 	if (!ctx->kfc.new_sb_created)
 		resctrl_unmount();
 	kernfs_put(rdt_root_kn);
-	return ret;
+
+	return 0;
 
 out_mondata:
 	if (resctrl_mon_capable())
@@ -3318,8 +3330,12 @@ static int rdt_get_tree(struct fs_context *fc)
 out_root:
 	rdtgroup_destroy_root();
 out:
+	resctrl_arch_unmount();
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
+out_mount_unlock:
+	mutex_unlock(&resctrl_mount_lock);
+
 	return ret;
 }
 
-- 
2.55.0

