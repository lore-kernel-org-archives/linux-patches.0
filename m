Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64EA1448E3
	for <patches@lists.linux.dev>; Tue, 12 Mar 2024 21:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710279784; cv=none; b=QbgoDYMu4h37IjLOT0YTOh8drfOyJQtfbHCTX+SIOGTbhsF5SiBDOWOsq4/+TkqTokcpbhhLfEovpydeI43oxA9B/2PBtbSPCLoQhEDcszA50HuOy92d7R0Q3t05wB3EH+Lq7EVATYcgIqeA8TCjlOjeAyBBUHAcgte/bTksdtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710279784; c=relaxed/simple;
	bh=zWLx2GxDeEK0EZRN9uxA4roG5ab9+WL2q0h+bTlfNq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fcmEg6uk1mWDkjdIrgCx3NnyrYKMt/Mbn5NGHu/oUxtHF1cuGWPkCci0JKovHClqfMniQqFFB1LRnIp6erh3jd0nhFfsRl+vjZonSMzoTqKiFWE2HJDhM44qdQATwehrfsPSWTJOyfZDQX7cULtPXPuNN6XdbUvHFuRv0oLu870=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CxiNL8bc; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CxiNL8bc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710279783; x=1741815783;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zWLx2GxDeEK0EZRN9uxA4roG5ab9+WL2q0h+bTlfNq4=;
  b=CxiNL8bc3FyHH2FD1ULAGXYm04odaTUNdmC4DtNvORhNRUZq6eELx/e3
   fAG5tB0EP184r3gLvifzPOmzdjiflRE5lrvqvCnoWB/txif5vwklOLncn
   YLnyWxwr3HzSyyF1n8N1TR4MWRjBrSoLEI1VhdGVNGAZ5qs50HoY2K2ip
   Am2E5fJGVQ9W39kFaKnZdQC/Ggh4gB1TCIl/ndJDG3l9Ypevq7Z/l2ZfD
   Ngg5RGWRSRZQme6TOuqJD4ZFaGxQulp21xwMwfivscbu9yS29Ke/l1YOe
   gH45LMQ8SzQZOAcdKr3kayCIv/dUZqozqf8UDve2YttufxERlVRAXd237
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11011"; a="4884878"
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="4884878"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 14:42:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="12280165"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 14:42:56 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	x86@kernel.org
Cc: Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Drew Fustini <dfustini@baylibre.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v16 9/9] x86/resctrl: Add info files to show mappings from domains to lists of cpus
Date: Tue, 12 Mar 2024 14:42:47 -0700
Message-ID: <20240312214247.91772-10-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240312214247.91772-1-tony.luck@intel.com>
References: <20240312214247.91772-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Users who want to find out which CPUs are part of which resctrl domain
need to jump through some hoops in /sys to find the lists of CPUs. This
is extra complicated when Sub-NUMA cluster is enabled on a system since
there is no simple indication that this feature is active, or how many
numa nodes are present per L3 cache.

Add files in each resource info directory to provide this information
in each of "list" and "bitmap" form.

E.g.

$ cat /sys/fs/resctrl/info/domain_cpu_list
0: 0-35,72-107
1: 36-71,108-143
$ cat /sys/fs/resctrl/info/domain_cpu_map
0: 0000,00000fff,ffffff00,0000000f,ffffffff
1: ffff,fffff000,000000ff,fffffff0,00000000

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/arch/x86/resctrl.rst     | 19 +++++++++
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 57 ++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/Documentation/arch/x86/resctrl.rst b/Documentation/arch/x86/resctrl.rst
index 15f1cff6ee76..8c42ad3369fd 100644
--- a/Documentation/arch/x86/resctrl.rst
+++ b/Documentation/arch/x86/resctrl.rst
@@ -261,6 +261,25 @@ with the following files:
 		bytes) at which a previously used LLC_occupancy
 		counter can be considered for re-use.
 
+Subdirectories of all resource types contain these files:
+
+"domain_cpu_list"
+		Provides a list of CPU numbers associated with each
+		domain for this resource.
+		Example::
+
+			# cat /sys/fs/resctrl/info/L3/domain_cpu_list
+			0: 0-35,72-107
+			1: 36-71,108-143
+
+"domain_cpu_map"
+		Same as above but the CPUs are listed in bitmap format.
+		Example::
+
+			# cat /sys/fs/resctrl/info/L3/domain_cpu_map
+			0: 0000,00000fff,ffffff00,0000000f,ffffffff
+			1: ffff,fffff000,000000ff,fffffff0,00000000
+
 Finally, in the top level of the "info" directory there is a file
 named "last_cmd_status". This is reset with every "command" issued
 via the file system (making new directories or writing to any of the
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 40e6bb8a8fc8..54673def7e9f 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -957,6 +957,20 @@ static int rdt_num_closids_show(struct kernfs_open_file *of,
 	return 0;
 }
 
+static int rdt_ctrl_cpus_show(struct kernfs_open_file *of,
+			      struct seq_file *seq, void *v)
+{
+	struct resctrl_schema *s = of->kn->parent->priv;
+	struct rdt_resource *r = s->res;
+	struct rdt_ctrl_domain *d;
+
+	list_for_each_entry(d, &r->ctrl_domains, hdr.list)
+		seq_printf(seq, is_cpu_list(of) ? "%d: %*pbl\n" : "%d: %*pb\n",
+			   d->hdr.id, cpumask_pr_args(&d->hdr.cpu_mask));
+
+	return 0;
+}
+
 static int rdt_default_ctrl_show(struct kernfs_open_file *of,
 			     struct seq_file *seq, void *v)
 {
@@ -1103,6 +1117,19 @@ static int rdt_num_rmids_show(struct kernfs_open_file *of,
 	return 0;
 }
 
+static int rdt_mon_cpus_show(struct kernfs_open_file *of,
+			     struct seq_file *seq, void *v)
+{
+	struct rdt_resource *r = of->kn->parent->priv;
+	struct rdt_mon_domain *d;
+
+	list_for_each_entry(d, &r->mon_domains, hdr.list)
+		seq_printf(seq, is_cpu_list(of) ? "%d: %*pbl\n" : "%d: %*pb\n",
+			   d->hdr.id, cpumask_pr_args(&d->hdr.cpu_mask));
+
+	return 0;
+}
+
 static int rdt_mon_features_show(struct kernfs_open_file *of,
 				 struct seq_file *seq, void *v)
 {
@@ -1810,6 +1837,21 @@ static struct rftype res_common_files[] = {
 		.seq_show	= rdt_num_closids_show,
 		.fflags		= RFTYPE_CTRL_INFO,
 	},
+	{
+		.name		= "domain_cpu_list",
+		.mode		= 0444,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= rdt_ctrl_cpus_show,
+		.flags		= RFTYPE_FLAGS_CPUS_LIST,
+		.fflags		= RFTYPE_CTRL_INFO,
+	},
+	{
+		.name		= "domain_cpu_map",
+		.mode		= 0444,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= rdt_ctrl_cpus_show,
+		.fflags		= RFTYPE_CTRL_INFO,
+	},
 	{
 		.name		= "mon_features",
 		.mode		= 0444,
@@ -1824,6 +1866,21 @@ static struct rftype res_common_files[] = {
 		.seq_show	= rdt_num_rmids_show,
 		.fflags		= RFTYPE_MON_INFO,
 	},
+	{
+		.name		= "domain_cpu_list",
+		.mode		= 0444,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= rdt_mon_cpus_show,
+		.flags		= RFTYPE_FLAGS_CPUS_LIST,
+		.fflags		= RFTYPE_MON_INFO,
+	},
+	{
+		.name		= "domain_cpu_map",
+		.mode		= 0444,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= rdt_mon_cpus_show,
+		.fflags		= RFTYPE_MON_INFO,
+	},
 	{
 		.name		= "cbm_mask",
 		.mode		= 0444,
-- 
2.44.0

