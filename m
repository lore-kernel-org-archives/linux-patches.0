Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE87938757A
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 16:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775577753; cv=none; b=N+9em6oP8YkXsO2FdTaTZOOI1TEskYLqJqp8cI/YPE50kczAvU9SIuKqXnbsQSMqVlzmsZ0iTRL5eyg2jk6Z5+5Ol7NEB1xKKJA3w7WLukVe1Fbz8hLpGvjgL9LwmbCVGxOmnB5wuUJql0EATdX6FMJF/LKHur6RAD3h2JaNybM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775577753; c=relaxed/simple;
	bh=3L4hXu1knEj0HBaYia4CiizUwXDzBQpm5bYUEwGIm7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHgxtDhGAV+EGKvgeNqkStbSBThI8cwMYUBcaaYM7z7iYXDTg4si2e5wzMA6wnLv3jJUv84CIj9C1ibpr1KBx8OpsQ+NNZur4/KjWury4N5XL0tzCXDhoMgkYqSRFl5Sp8TKNOUjrDeFnXInQ/zXyjj0QnamJtLeufrBaOFP28o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bvmKobbm; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bvmKobbm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775577747; x=1807113747;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3L4hXu1knEj0HBaYia4CiizUwXDzBQpm5bYUEwGIm7s=;
  b=bvmKobbmEKYbNBP/5ReDBYJiBLUhh9e1IdIb/t210uL7DKY84oZhb8i1
   E+aNTY34uPr68sfVTr28eZ1IXG6oP59fKFO2g3QbzwBNE6QxvidsVeDW9
   uRCbh0PJk4CbtdDzFb1cezWaRdtoz+NDJCVFVTlonQ1ykmRySsjIl1uaH
   u0TAnNIqUnYnWUsgB6LnfarzO0EjJ9CA4aEjn/BQRYfgBcPibJbCwoeWO
   LxiJcEQCeiU2N0cv7lU5yXGOhXLPmrYipspnI0EG522pBPjmRwpwaQUkq
   Zrb37HovCde8huaMiIFwDKtwGEfw4Rv+XzW9SbAWftUu88puavG1yFzlA
   A==;
X-CSE-ConnectionGUID: xCL8B8i5TRqk4NTgEmvbcg==
X-CSE-MsgGUID: ihAK3H34T9yoI/h49F2FUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="80432656"
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="80432656"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:18 -0700
X-CSE-ConnectionGUID: VpQkY95sQRuB3nixMsMDSw==
X-CSE-MsgGUID: SwhC4WK0QB2RrjANABrM5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="228119034"
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
Subject: [PATCH v3 02/13] fs/resctrl: Add missing return value descriptions
Date: Tue,  7 Apr 2026 09:01:59 -0700
Message-ID: <1c50b9f7c73251c007133590986f127e1af57780.1775576382.git.reinette.chatre@intel.com>
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

Using the stricter "./tools/docs/kernel-doc -Wall -v" to verify proper
formatting of documentation comments includes warnings related to return
markup on functions that are omitted during the default verification
checks. This stricter verification reports a couple of missing return
descriptions in resctrl:

    Warning: .../fs/resctrl/rdtgroup.c:1536 No description found for return value of 'rdtgroup_cbm_to_size'
    Warning: .../fs/resctrl/rdtgroup.c:3131 No description found for return value of 'mon_get_kn_priv'
    Warning: .../fs/resctrl/rdtgroup.c:3523 No description found for return value of 'cbm_ensure_valid'
    Warning: .../fs/resctrl/monitor.c:238 No description found for return value of 'resctrl_find_cleanest_closid'

Add the missing return descriptions.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since v2:
- Provide more detail in return value description: "size in bytes" ->
  "Size (in bytes) of cache portion represented by CBM"
---
 fs/resctrl/monitor.c  | 2 ++
 fs/resctrl/rdtgroup.c | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 49f3f6b846b2..9fd901c78dc6 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -234,6 +234,8 @@ static struct rmid_entry *resctrl_find_free_rmid(u32 closid)
  *
  * When the CLOSID and RMID are independent numbers, the first free CLOSID will
  * be returned.
+ *
+ * Return: Free CLOSID on success, < 0 on failure.
  */
 int resctrl_find_cleanest_closid(void)
 {
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5da305bd36c9..5dfdaa6f9d8f 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1519,6 +1519,8 @@ static ssize_t rdtgroup_mode_write(struct kernfs_open_file *of,
  *
  * @cbm is unsigned long, even if only 32 bits are used to make the
  * bitmap functions work correctly.
+ *
+ * Return: Size (in bytes) of cache portion represented by CBM, 0 on failure.
  */
 unsigned int rdtgroup_cbm_to_size(struct rdt_resource *r,
 				  struct rdt_ctrl_domain *d, unsigned long cbm)
@@ -3102,6 +3104,8 @@ static void rmdir_all_sub(void)
  * @mevt:   The type of event file being created.
  * @do_sum: Whether SNC summing monitors are being created. Only set
  *	    when @rid == RDT_RESOURCE_L3.
+ *
+ * Return: Pointer to mon_data private data of the event, NULL on failure.
  */
 static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 					struct mon_evt *mevt,
@@ -3496,6 +3500,8 @@ static int mkdir_mondata_all(struct kernfs_node *parent_kn,
  * resource group is initialized. The user can follow this with a
  * modification to the CBM if the default does not satisfy the
  * requirements.
+ *
+ * Return: A CBM that is valid for resource @r.
  */
 static u32 cbm_ensure_valid(u32 _val, struct rdt_resource *r)
 {
-- 
2.50.1

