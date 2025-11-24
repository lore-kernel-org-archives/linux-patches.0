Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC307322C9D
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 18:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010499; cv=none; b=YTzkNzDoYFnd4HaZndCk8Dq9+LYmqfiIMGQgNhmUqTTPAlBsIL3p0sEUYbLQ0L7lVN+wppQdS0HRRMyyCPkoEoGBIqzQdHadLF4zgydwp0ltA2OVhX2FkjT46nLXMkxqXf/9h5WJjsxMgzWBdxTv5CCN+W8sOejfHb0SQhNgbxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010499; c=relaxed/simple;
	bh=9KtQhAEuNacTIhDtiaux0qfjZKcSMZhDOZ14EYOTjwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdYtI886mnbGYwnIF22a5jnZUfYrigpBTC8e6WRw88Wtno6hJvSIEJM6yo7uFCWF2MEGHjFB65azirm/7R41ZQwe0bCQ4MmFpeNNjIdG7EOiSDg1tX9pjABjzhurUm3Su+LyvPKteiGkPRGvcTwSfIgpd3w6IJZVplpQEgO8jkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NoyesowL; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NoyesowL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764010498; x=1795546498;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9KtQhAEuNacTIhDtiaux0qfjZKcSMZhDOZ14EYOTjwQ=;
  b=NoyesowLsOBTwyCxcpoy9Z0Wx6Yw1wSVRTdU/PKNcHsx1seZrWSx8FuW
   elSexTjXdesyHqqV6O0jED9DSF808hIDXhcpwITfMnMRXVpRGsD0NWy9W
   fu2vC8hppu8HK1eF8NnY+QUu7SPvYOxv9p8LRCGNBqqxCAwGa29q58upC
   i7t7vPm4Os3iJr12+5/wmd9anRD+96vQVkmzeb3N00dA+7EC39um+mm2h
   z/GMr+6quOkJteH0Bf6KXMrn2/jqdQd/oCsQbLXukyNK6M3NRieAmQDIp
   pTwHTyoW/CKbZsi1Cye6iiwizplLoDcmjXm7uulUEzQ/W2SpYChhJ9yG6
   A==;
X-CSE-ConnectionGUID: Zo4xDX7iRQSrG8EOSWRWzA==
X-CSE-MsgGUID: AB1EAWReQVyTIQyrN3LrSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76636675"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="76636675"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:27 -0800
X-CSE-ConnectionGUID: 9Yll61mjQU+Eb3283ZWC+Q==
X-CSE-MsgGUID: Bxf/fMdCTYiiAEtH8Xs9hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192224990"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:26 -0800
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
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v14 15/32] fs/resctrl: Emphasize that L3 monitoring resource is required for summing domains
Date: Mon, 24 Nov 2025 10:53:52 -0800
Message-ID: <20251124185412.24155-16-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251124185412.24155-1-tony.luck@intel.com>
References: <20251124185412.24155-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The feature to sum event data across multiple domains supports systems with
Sub-NUMA Cluster (SNC) mode enabled. The top-level monitoring files in each
"mon_L3_XX" directory provide the sum of data across all SNC nodes sharing
an L3 cache instance while the "mon_sub_L3_YY" sub-directories provide the
event data of the individual nodes.

SNC is only associated with the L3 resource and domains and as a result the
flow handling the sum of event data implicitly assumes it is working with
the L3 resource and domains.

Reading of telemetry events do not require to sum event data so this feature
can remain dedicated to SNC and keep the implicit assumption of working with
the L3 resource and domains.

Add a WARN to where the implicit assumption of working with the L3 resource
is made and add comments on how the structure controlling the event sum
feature is used.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 fs/resctrl/internal.h    | 4 ++--
 fs/resctrl/ctrlmondata.c | 8 +++++++-
 fs/resctrl/rdtgroup.c    | 3 ++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 0110d1175398..50d88e91e0da 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -92,8 +92,8 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
  * @list:            Member of the global @mon_data_kn_priv_list list.
  * @rid:             Resource id associated with the event file.
  * @evt:             Event structure associated with the event file.
- * @sum:             Set when event must be summed across multiple
- *                   domains.
+ * @sum:             Set for RDT_RESOURCE_L3 when event must be summed
+ *                   across multiple domains.
  * @domid:           When @sum is zero this is the domain to which
  *                   the event file belongs. When @sum is one this
  *                   is the id of the L3 cache that all domains to be
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index f319fd1a6de3..cc4237c57cbe 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -677,7 +677,6 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 {
 	struct kernfs_open_file *of = m->private;
 	enum resctrl_res_level resid;
-	struct rdt_l3_mon_domain *d;
 	struct rdt_domain_hdr *hdr;
 	struct rmid_read rr = {0};
 	struct rdtgroup *rdtgrp;
@@ -705,6 +704,13 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 	r = resctrl_arch_get_resource(resid);
 
 	if (md->sum) {
+		struct rdt_l3_mon_domain *d;
+
+		if (WARN_ON_ONCE(resid != RDT_RESOURCE_L3)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		/*
 		 * This file requires summing across all domains that share
 		 * the L3 cache id that was provided in the "domid" field of the
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 4952ba6b8609..dce1f0a6d40b 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3095,7 +3095,8 @@ static void rmdir_all_sub(void)
  * @rid:    The resource id for the event file being created.
  * @domid:  The domain id for the event file being created.
  * @mevt:   The type of event file being created.
- * @do_sum: Whether SNC summing monitors are being created.
+ * @do_sum: Whether SNC summing monitors are being created. Only set
+ *	    when @rid == RDT_RESOURCE_L3.
  */
 static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 					struct mon_evt *mevt,
-- 
2.51.1

