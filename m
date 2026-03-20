Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13F2314B66
	for <patches@lists.linux.dev>; Fri, 20 Mar 2026 22:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774044236; cv=none; b=QS2P9NHwD1wKwd0IhcdQu5mWx+4Esu4C3V6byqMRDgx8K7fiOtvdbnwCsH25SKpEOODtoNkJig0xt6ZnmKhgsopyP3ocSaxRLHGn9EGekvgV3myyy6UTY8wjgFzOgqUBV+SFdB9PvpNH9cTyJhG81gNdJorFmbbNy/g/CDZ+xHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774044236; c=relaxed/simple;
	bh=+S/4TGzCCyx9HY4E3iHxxpFMHM+peJEtYrBOdwsV+tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s60cQgDdxc81zABUjK6ppqfVGY+LjK08uqd6Lq4erjHJI7w7ZN5TR3NiDphnF7kggqr4OlPCyUXs1YwfHZL1QbgclDO0VQfU3xONa5rseCa4+YrmYApcx23ss25bTeO5Kgs+6FCp31qbiFYzd84DLLaPzOz7IR7DoEdYlO5zS3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VjKvpxVw; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VjKvpxVw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774044235; x=1805580235;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+S/4TGzCCyx9HY4E3iHxxpFMHM+peJEtYrBOdwsV+tM=;
  b=VjKvpxVwL2V6xNHnI+0DV4FeAaX1k1whUVkHXluo45LR0OyUdqhuI6Qy
   FFR/EZT+Yf87t33LdO2pj0+7QJCVjD+/XtVHsYRbVKjZS/T3pd0a69FOb
   Q0QObT9MEl4FUueGaqwxUR/rEC2DIkTSurRygd1hSgqAuR2WaAYS+QWK3
   vppk/faBSQa6EwX78rsOpTdp5J3YaxMbhUv9Hds3aNtnPTxWpPdy3RcMx
   04VX7avpq+C9GxgCYMlcnmgHZAHdApXiOnO3Jpp9l+yhURENcaCeP8R2r
   SbzKrGyVyrn9b11HCulPJaQPKZPU1TM/bogboxUI+fmL95qgOsVUKnEwd
   A==;
X-CSE-ConnectionGUID: OJH2H48sTrGkVFZQQZroBA==
X-CSE-MsgGUID: vkUPQs2hQMK/LH2XZNP5iw==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="97758344"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="97758344"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:53 -0700
X-CSE-ConnectionGUID: oa2KjgbzSKuaMUPzDUTG2Q==
X-CSE-MsgGUID: gHKT/FcnQgeAiYavngLJng==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:53 -0700
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
Subject: [PATCH v2 02/14] fs/resctrl: Add missing return value descriptions
Date: Fri, 20 Mar 2026 15:03:12 -0700
Message-ID: <4261365d3cba00afbe846dc85fb4a3386eb5feb2.1774043709.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1774043709.git.reinette.chatre@intel.com>
References: <cover.1774043709.git.reinette.chatre@intel.com>
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
index 5da305bd36c9..111bff8e33fd 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1519,6 +1519,8 @@ static ssize_t rdtgroup_mode_write(struct kernfs_open_file *of,
  *
  * @cbm is unsigned long, even if only 32 bits are used to make the
  * bitmap functions work correctly.
+ *
+ * Return: size in bytes, 0 on failure.
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

