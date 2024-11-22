Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C1F1D362B
	for <patches@lists.linux.dev>; Fri, 22 Nov 2024 23:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732319924; cv=none; b=H7h6GVetrrXrCF/XLoDEFz4/iMJryT05LCLMA3Gp5n/t0U879s/L7hueiZIBVBaqHhCsACfNKofbQkcZ0EEBzYjwngU6t3SGeIRfn6Mu1xFLkzTwGLcPlvk4ToczAtGpEGWfqVsGjySFXusVEs8O8tnRYdYZUeEw410J2Q15VfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732319924; c=relaxed/simple;
	bh=80SJws0Hb0cg3maKZlhIw9vkNKd0N1ngxiJHAJ8H6KI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJ8VdZ+AhaQ4nL8/+ppIF39L6qXjWL8/Xi6PqYy7Mgj3/c2jgZlcKK5oP6r+G1YROXVwenRQl46h6mqDYcMkNLa4dba/ieTWoixf+XaDb4VXsFed+yMzKabKGC3BhRlqZaCnJeGcY4qYkgUxmhZooItd+P1+fWsZDEvQywYWCOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iTXharTO; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iTXharTO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732319923; x=1763855923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=80SJws0Hb0cg3maKZlhIw9vkNKd0N1ngxiJHAJ8H6KI=;
  b=iTXharTOc8enFSsU1JjdHaejWAZMTLQKrrlQR3W8WYkrscoa9na54jal
   5vGF32ftq+6NIEXaYtVn2irNSOhrom52oswD47Rci7XsRJUq/VF0gj9qU
   4vH2A3m8hEVh/goK0uFxBXsj3MVRgv/8G2OuAYowL7gbpOeXU/+16ySJ0
   7krvJFarU9DxbUz6ZnT0W0oqSrC5/u1PvJEzfqsK6ju5Qf6a13aH5vFKF
   VUnqJYcNPa8RaVsTC5VUlTUuinQVIpmviZ6O1i88bZD+FK9lEpVoESLWk
   hl6dNcrB1NyUqLrMwtuyMGuXFKHEutt4wF5WimST9N0Q2+0oM0fcjd7tT
   Q==;
X-CSE-ConnectionGUID: eMD5AUvWSOy6sj9IK4EIGA==
X-CSE-MsgGUID: FLjmApofTUurs7ZKhKWJAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11264"; a="32642745"
X-IronPort-AV: E=Sophos;i="6.12,177,1728975600"; 
   d="scan'208";a="32642745"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 15:58:40 -0800
X-CSE-ConnectionGUID: ZbB1NTZ/Ty2SwuWufgOqIQ==
X-CSE-MsgGUID: UEdOp2qpQeG88vTRvY+vFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,177,1728975600"; 
   d="scan'208";a="90850911"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 15:58:39 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	x86@kernel.org
Cc: James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v10 6/8] x86/resctrl: Add "mba_MBps_event" file to CTRL_MON directories
Date: Fri, 22 Nov 2024 15:58:30 -0800
Message-ID: <20241122235832.27498-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241122235832.27498-1-tony.luck@intel.com>
References: <20241122235832.27498-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The "mba_MBps" mount option provides an alternate method to
control memory bandwidth. Instead of specifying allowable
bandwidth as a percentage of maximum possible, the user
provides a MiB/s limit value.

In preparation to allow the user to pick the memory bandwidth
monitoring event used as input to the feedback loop, provide
a file in each CTRL_MON group directory that shows the event
currently in use. Note that this file is only visible when
the "mba_MBps" mount option is in use.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h    |  2 ++
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 30 +++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 10 ++++++++
 3 files changed, 42 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 485800055a7d..ce10a883ecf8 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -609,6 +609,8 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 				char *buf, size_t nbytes, loff_t off);
 int rdtgroup_schemata_show(struct kernfs_open_file *of,
 			   struct seq_file *s, void *v);
+int rdtgroup_mba_mbps_event_show(struct kernfs_open_file *of,
+				 struct seq_file *s, void *v);
 bool rdtgroup_cbm_overlaps(struct resctrl_schema *s, struct rdt_ctrl_domain *d,
 			   unsigned long cbm, int closid, bool exclusive);
 unsigned int rdtgroup_cbm_to_size(struct rdt_resource *r, struct rdt_ctrl_domain *d,
diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
index 200d89a64027..5fa37b4ecc7a 100644
--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -518,6 +518,36 @@ static int smp_mon_event_count(void *arg)
 	return 0;
 }
 
+int rdtgroup_mba_mbps_event_show(struct kernfs_open_file *of,
+				 struct seq_file *s, void *v)
+{
+	struct rdtgroup *rdtgrp;
+	int ret = 0;
+
+	rdtgrp = rdtgroup_kn_lock_live(of->kn);
+
+	if (rdtgrp) {
+		switch (rdtgrp->mba_mbps_event) {
+		case QOS_L3_MBM_LOCAL_EVENT_ID:
+			seq_puts(s, "mbm_local_bytes\n");
+			break;
+		case QOS_L3_MBM_TOTAL_EVENT_ID:
+			seq_puts(s, "mbm_total_bytes\n");
+			break;
+		default:
+			pr_warn_once("Bad event %d\n", rdtgrp->mba_mbps_event);
+			ret = -EINVAL;
+			break;
+		}
+	} else {
+		ret = -ENOENT;
+	}
+
+	rdtgroup_kn_unlock(of->kn);
+
+	return ret;
+}
+
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
 		    cpumask_t *cpumask, int evtid, int first)
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 98d27199c2fe..22265d3e238a 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -1952,6 +1952,12 @@ static struct rftype res_common_files[] = {
 		.seq_show	= rdtgroup_schemata_show,
 		.fflags		= RFTYPE_CTRL_BASE,
 	},
+	{
+		.name		= "mba_MBps_event",
+		.mode		= 0444,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= rdtgroup_mba_mbps_event_show,
+	},
 	{
 		.name		= "mode",
 		.mode		= 0644,
@@ -2357,6 +2363,7 @@ static int set_mba_sc(bool mba_sc)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
 	u32 num_closid = resctrl_arch_get_num_closid(r);
 	struct rdt_ctrl_domain *d;
+	unsigned long fflags;
 	int i;
 
 	if (!supports_mba_mbps() || mba_sc == is_mba_sc(r))
@@ -2371,6 +2378,9 @@ static int set_mba_sc(bool mba_sc)
 			d->mbps_val[i] = MBA_MAX_MBPS;
 	}
 
+	fflags = mba_sc ? RFTYPE_CTRL_BASE | RFTYPE_MON_BASE : 0;
+	resctrl_file_fflags_init("mba_MBps_event", fflags);
+
 	return 0;
 }
 
-- 
2.47.0

