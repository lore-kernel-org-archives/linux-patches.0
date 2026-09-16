Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B1E51FCCD
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 23:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600429; cv=none; b=fYNUCMRaAXnR10SzkVEAgmSnlafbSx6NfhmT5A/rkug409Fc0IXMnenXVDJubCdQZGbJwmNVynwZRvFVGgS/9Qje9UbN475GvVMNMClK0ddpUw1/fVOaSXlyZQJzZ9kLjNu8sor3JFN+YsMsD/jJoNfPdXlIdO1Jeh6l+5RDUY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600429; c=relaxed/simple;
	bh=bjl53x6ixGVQwtoXJbvhU84Wge/Z4FIAwJfWtvF1zdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbO0U7Y2OB41Q6zhu2+lcufo02P2GaNYDpPpSNHf8qmIGg4bt8dafSbSKoKZcJwJtrL5SHkGugItDMwNpBQ42HhWibcZSy+Vo9BxETwYFFPiipLvfddV7gkZMykouxYXy/ad4zZzWWs4rCLHN9WiZNexBIhmoRXHt2Z9wvhCiEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KFyYFO9C; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KFyYFO9C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789600427; x=1821136427;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bjl53x6ixGVQwtoXJbvhU84Wge/Z4FIAwJfWtvF1zdo=;
  b=KFyYFO9CD0DKVGZ/38FL5ch94QHLNLYbS1pqbLXBilU09+dNvBnc0JwW
   IqSJ/uOcNrTVyfyuno7+1rn7Kzy5aWUMFoQKo4WsIVuhzJCqUeEWVxf4w
   zlwoNtd1xdcJAcfe4jBFA6RaiospF3ktZMiD68aNI2DHVWIV5JOm0bw6k
   sbq13MM39zhkwkiNeleEGwfy9aDf4CFc83f+HGLI08V50nhr1gATJyhtB
   XWYK9LLsF77Q6GbmEicmLXSCbbtw8HTIoCveJVWEbjEg01A/RspNG4gaG
   M3+vc4fbPSLhzzcxzlpOiaF4QfZ0iQApvKi8NwCfClAd3jPjURTY18zIi
   w==;
X-CSE-ConnectionGUID: xlkCJ2PDTUGV5lLsK3KMrg==
X-CSE-MsgGUID: PV7w3WJcSj6eaXlMojHuvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93861444"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93861444"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:36 -0700
X-CSE-ConnectionGUID: RT5IhKlMSmaXgZQnznc2Iw==
X-CSE-MsgGUID: 2n05r5EDT42UKKmYE1PkeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="277231472"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.219])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:36 -0700
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
Subject: [PATCH v12 14/25] fs/resctrl: Rebuild free RMID list on each mount
Date: Wed, 16 Sep 2026 16:13:09 -0700
Message-ID: <20260916231320.14502-15-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916231320.14502-1-tony.luck@intel.com>
References: <20260916231320.14502-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Application Energy Telemetry (AET) event enumeration takes place
asynchronously. Linux builds the pmt_telemetry module into the kernel to
kick off enumeration early enough that it completes before first mount of
the resctrl file system.

Allowing pmt_telemetry to be a loadable module means that it is possible
for different numbers of RMIDs to be supported on each mount, depending
on whether pmt_telemetry module is loaded.

Initialize rmid_free_lru based on the number of RMIDs available for the
current mount cycle.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v12:
	New patch. Split from patch 12.
---
 fs/resctrl/monitor.c | 64 +++++++++++++++++++++++++++++---------------
 1 file changed, 42 insertions(+), 22 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index b8bd59c52c62..8dde2b81b72f 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -75,6 +75,11 @@ static unsigned int rmid_limbo_count;
  */
 static struct rmid_entry	*rmid_ptrs;
 
+/*
+ * @num_rmid_ptrs - The number of elements in rmid_ptrs[].
+ */
+static u32 num_rmid_ptrs;
+
 /*
  * This is the threshold cache occupancy in bytes at which we will consider an
  * RMID available for re-allocation.
@@ -975,45 +980,60 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
 
 int setup_rmid_lru_list(void)
 {
-	struct rmid_entry *entry = NULL;
-	u32 idx_limit;
-	u32 idx;
+	struct rmid_entry *entry;
+	u32 cur_idx_limit;
+	u32 rsvd_idx;
 	int i;
 
 	if (!resctrl_mon_capable())
 		return 0;
 
 	/*
-	 * Called on every mount, but the number of RMIDs cannot change
-	 * after the first mount, so keep using the same set of rmid_ptrs[]
-	 * until resctrl_exit(). Note that the limbo handler continues to
-	 * access rmid_ptrs[] after resctrl is unmounted.
+	 * Allocate the largest number of RMIDs that this system will ever
+	 * need. These cannot be freed until resctrl_exit() because the limbo
+	 * handler continues to access rmid_ptrs[] after resctrl is unmounted.
 	 */
-	if (rmid_ptrs)
-		return 0;
+	if (!rmid_ptrs) {
+		num_rmid_ptrs = resctrl_arch_system_max_rmid_idx();
+		rmid_ptrs = kzalloc_objs(struct rmid_entry, num_rmid_ptrs);
+		if (!rmid_ptrs) {
+			num_rmid_ptrs = 0;
+			return -ENOMEM;
+		}
 
-	idx_limit = resctrl_arch_system_max_rmid_idx();
-	rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
-	if (!rmid_ptrs)
-		return -ENOMEM;
+		for (i = 0; i < num_rmid_ptrs; i++) {
+			entry = &rmid_ptrs[i];
+			INIT_LIST_HEAD(&entry->list);
 
-	for (i = 0; i < idx_limit; i++) {
-		entry = &rmid_ptrs[i];
-		INIT_LIST_HEAD(&entry->list);
+			resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
+		}
+	}
 
-		resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
-		list_add_tail(&entry->list, &rmid_free_lru);
+	/* Find how many RMIDs are available for this mount */
+	cur_idx_limit = resctrl_arch_system_num_rmid_idx();
+	if (cur_idx_limit > num_rmid_ptrs) {
+		pr_warn_once("RMID count %u exceeds allocated %u; capping\n",
+			     cur_idx_limit, num_rmid_ptrs);
+		cur_idx_limit = num_rmid_ptrs;
 	}
 
+	INIT_LIST_HEAD(&rmid_free_lru);
+
 	/*
 	 * RESCTRL_RESERVED_CLOSID and RESCTRL_RESERVED_RMID are special and
 	 * are always allocated. These are used for the rdtgroup_default
 	 * control group, which was setup earlier in rdtgroup_setup_default().
 	 */
-	idx = resctrl_arch_rmid_idx_encode(RESCTRL_RESERVED_CLOSID,
-					   RESCTRL_RESERVED_RMID);
-	entry = __rmid_entry(idx);
-	list_del(&entry->list);
+	rsvd_idx = resctrl_arch_rmid_idx_encode(RESCTRL_RESERVED_CLOSID,
+						RESCTRL_RESERVED_RMID);
+
+	for (i = 0; i < cur_idx_limit; i++) {
+		entry = &rmid_ptrs[i];
+		/* Don't add reserved or busy entries to free list */
+		if (i == rsvd_idx || entry->busy)
+			continue;
+		list_add_tail(&entry->list, &rmid_free_lru);
+	}
 
 	return 0;
 }
-- 
2.55.0

