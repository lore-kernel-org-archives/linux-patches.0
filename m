Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EAD319847
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 18:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772477189; cv=none; b=ZrrNlvhr1WEieSvVfxwWi4d4s8gJ8ySxZ5b2EU9Ppvih/Hj9a8u2tHWi+UddCADlPBQ7K/Epcej/bAuipSAEECYvFpM9UJeVJ5KHPL0d++AiuTxGAz8ND/PGxWI2j+tjiTHPmc9e9+53M1ssIngkip8dyKz5rVb6uf2CZttQkuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772477189; c=relaxed/simple;
	bh=lPprbTGisbGA0s+d/uOwEM9KiYptDpYY2nJtKbgMbQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZRV+ZM1vTKv9XHaMuefBphKj0K21lmCckvaPYzNkTpnvbdW4kyr4rT3nMz8Dyb5rPdU8PGQkBGoARZ+yvWE+eaX6VE29MlxEvd13SaU0aIAMTsU/hesrzjcuSE3WQJzM3Qc9QC+cxgq2VGC6nXB/or/jbPWekXBCwi/r5f3aTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MRNrB7/w; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MRNrB7/w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772477188; x=1804013188;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lPprbTGisbGA0s+d/uOwEM9KiYptDpYY2nJtKbgMbQQ=;
  b=MRNrB7/wT3O7LWWbbhQZeh4Ybdb6JIZQoXtINcqO5oN2ieTuJuCNyl45
   k2TG9IEQlkeD/yGl3kPan64HRKcwqGq5zRGoCrp4pW0/+79bdzr/aK384
   RYBJYWT4H9UXuzdZXCYBiRe5CzxT0wK8EL1ABsylqLWTourAwDV0N0SUA
   +r428a1dsjfUiJDSmmL5J7AiCvH/FdzbWUOCkmbF+In/nmJg9l7oPk3dB
   yPzLQOTKGgJrKZRfAY5xcddSaSG7W7Uae4Kca8ZpDJBxaV/paRuZxRqsD
   wu8L/fWN1nGCW10KlvEQubdRyLJ7azk4S+7xTqV36cd221yGUAIEgA60V
   g==;
X-CSE-ConnectionGUID: xqNA9o3WRVWH1wc7C6rZ7w==
X-CSE-MsgGUID: AzjE2hxNSZaOAD2ff63QNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="84135426"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="84135426"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 10:46:26 -0800
X-CSE-ConnectionGUID: JCQRu/dqQ8KB0ZBbsmdL4A==
X-CSE-MsgGUID: SEJPw139QMm+4U2hSuKJcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="255604077"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 10:46:26 -0800
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
Subject: [PATCH 01/11] fs/resctrl: Add missing return value descriptions
Date: Mon,  2 Mar 2026 10:46:07 -0800
Message-ID: <e973d6a29193d6de7d9335600076d7ec3af9610b.1772476561.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1772476561.git.reinette.chatre@intel.com>
References: <cover.1772476561.git.reinette.chatre@intel.com>
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
index 0cd5476a483a..93db7c1cd7be 100644
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
index ba8d503551cd..3c9508fc558d 100644
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

