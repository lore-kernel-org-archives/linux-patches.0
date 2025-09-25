Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E4E32779D
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 20:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758830669; cv=none; b=Cxqbgt1p0eB/xdC29CMaWRwN0m5KuVl+Wwj29fzlyRi+3p0IrTLNgbgrdtx1KJSq0baAMaNzXapJJEw+hsjw+enNOwo8/AXQa89K3NWhp5+g3titvxR22sb2SF2aH27ymTGbUgRoHUxKDuei8fDOSDjiERRzA2oDmwAIB7soA8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758830669; c=relaxed/simple;
	bh=KKZ76b6f1fVw3YfuVP6not30dWXnaMRHgFBHlr5XoWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UULNXurTYiAJAElslQ/BC4D+ag/MoivFX6oLKFLINmk7C2u0TSDkQGXqKYloc9jh9JPkEALfD0cL2okWKSnNpeVvHmVv2QZrHnCsIEuESTGzYMXbZHdmcCJqS6D1AY+Zc5eDbVuVG2iBYKq4zyMIT3Kjc4+Shk/dNjbo0zo1+VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OSSQAgT6; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OSSQAgT6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758830668; x=1790366668;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KKZ76b6f1fVw3YfuVP6not30dWXnaMRHgFBHlr5XoWI=;
  b=OSSQAgT62s6u15Jr9OkvVBRRDMbY7Hy6KKMNcE7dBITySXXAq4r4tPWh
   aauC1TZV5Ib4zohY3YcspeXHl4GGVoHN90dOZoDoSSU44MG6lxgnIyQVO
   M4wPRSqEDKq7h41T7plp40kps1MTrmt+qER5R1O29Z/9CC28e8el9o9pf
   UD4nxPfphYTANcIXZxtDGvA83nrZ9Vf+2Wh4CqF56oSieFpeAP80V/IOx
   2166Eg36TS1OjKOFzgY+2d/mFAMqQmbw/3wvoVWcM5zSZxuzCeKqUB87o
   yUGTLDXmj3g2ra1Y5+3ErISTnsa3xQSjJ5wSp6utM9qAKsq7Qb4H6eFm6
   A==;
X-CSE-ConnectionGUID: aIDZKE/9QwqDuDR0FfCHuA==
X-CSE-MsgGUID: 7tXmU5gSTKujD2z9cPSoKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61074413"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61074413"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:16 -0700
X-CSE-ConnectionGUID: K0RKm+OUSNqvhPHncTdHuA==
X-CSE-MsgGUID: 02TGTeRXQN2qyC4Yyn4/+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177003714"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.206])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:16 -0700
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
Subject: [PATCH v11 31/31] fs/resctrl: Some kerneldoc updates
Date: Thu, 25 Sep 2025 13:03:25 -0700
Message-ID: <20250925200328.64155-32-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925200328.64155-1-tony.luck@intel.com>
References: <20250925200328.64155-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl event monitoring on Sub-NUMA Cluster (SNC) systems sums the
counts for events across all nodes sharing an L3 cache.

Update the kerneldoc for rmid_read::sum and the do_sum argument to
mon_get_kn_priv() to say these are only used on the RDT_RESOURCE_L3
resource.

Add Return: value description for l3_mon_domain_mbm_alloc(),
resctrl_l3_mon_resource_init(), and domain_setup_l3_mon_state()

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/internal.h              | 4 ++--
 arch/x86/kernel/cpu/resctrl/core.c | 2 ++
 fs/resctrl/monitor.c               | 2 +-
 fs/resctrl/rdtgroup.c              | 5 +++--
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 223a6cc6a64a..0dd89d3fa31a 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -96,8 +96,8 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
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
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 48ed6242d136..78c176e15b93 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -418,6 +418,8 @@ static int domain_setup_ctrlval(struct rdt_resource *r, struct rdt_ctrl_domain *
  * l3_mon_domain_mbm_alloc() - Allocate arch private storage for the MBM counters
  * @num_rmid:	The size of the MBM counter array
  * @hw_dom:	The domain that owns the allocated arrays
+ *
+ * Return:	%0 for success; Error code otherwise.
  */
 static int l3_mon_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_l3_mon_domain *hw_dom)
 {
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index c0e1b672afce..4cc310b9e78e 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1811,7 +1811,7 @@ static void closid_num_dirty_rmid_free(void)
  * Resctrl's cpuhp callbacks may be called before this point to bring a domain
  * online.
  *
- * Returns 0 for success, or -ENOMEM.
+ * Return: %0 for success; Error code otherwise.
  */
 int resctrl_l3_mon_resource_init(void)
 {
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 16b088c5f2be..04765dad3d31 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3037,7 +3037,8 @@ static void rmdir_all_sub(void)
  * @rid:    The resource id for the event file being created.
  * @domid:  The domain id for the event file being created.
  * @mevt:   The type of event file being created.
- * @do_sum: Whether SNC summing monitors are being created.
+ * @do_sum: Whether SNC summing monitors are being created. Only set
+ *          when @rid == RDT_RESOURCE_L3.
  */
 static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 					struct mon_evt *mevt,
@@ -4281,7 +4282,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
  * at mount time. This means the rdt_l3_mon_domain::mbm_states[] and
  * rdt_l3_mon_domain::rmid_busy_llc allocations may be larger than needed.
  *
- * Returns 0 for success, or -ENOMEM.
+ * Return: %0 for success; Error code otherwise.
  */
 static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
 {
-- 
2.51.0

