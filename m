Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0145EF9C0
	for <patches@lists.linux.dev>; Thu, 14 Nov 2024 00:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731543444; cv=none; b=riIlxude+o/TgPKhWv5/vMri00yy50WFYLWErlpvL+KhFZOlfaFg3ealThvmq7MiLXv369EuxvmfSsbG9tUMtiudaGGYXlU4E7vYDRaCEHImdzTQCpuXHIFR+kSDMfsA92S1ScNXzw44nAL9BkJq9DKr06rwPzAamU8TTtT4uT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731543444; c=relaxed/simple;
	bh=5Q4+X0iEeH+YMNS6vFyI/IkaOhw7AVsWZa5jlibXe4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JP6mF+guhZEu8PSJJ1TEzxVEqIencH3Dk/YtrAznVUWC3+nNzBPrVBLM3ETLIIBT5RBNlWw8HmC/mDuclsHSk64nM3/yOnh7IoYD/Y+wiU6PI1gAEyZNCmfYNX5tqBMDbfjgWjluUVcp19Fl82eOCbGKslDUVkMhyP693iPoerM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L7SXvKZY; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L7SXvKZY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731543443; x=1763079443;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5Q4+X0iEeH+YMNS6vFyI/IkaOhw7AVsWZa5jlibXe4Y=;
  b=L7SXvKZYwcfLVZIhGPk0EG8yNp2F6AR1whbc2WQPJEOEf/dC8V09uxuX
   cOlDCODsq1dENcc0Mgts4IzT7Q7it7Lnz3Ps8lWAiIQFzhgHMinZUC057
   e4WR8lJf8I/SVFz2QL4r7PaEGc4CTgafd1IfZvJZ8GtmqAsoM0ii5yT1m
   r3AMm2QeNU1+EQlBs5ZJgMLcWW2Nz56Mn5vLF3E3j2IIyyWQN7/Lso6cr
   3PmTAnLIqoVZaNY5bz31jZ+bra2now4SS9uTN0h2Xrjef3vEate9NczGj
   wUc3fAMny10z9bmlSSrY/EQjHVx8/lMX1fWPVlkKpPhRkMX0b7h0SM4cF
   g==;
X-CSE-ConnectionGUID: Hp7WeSdKRGCoQxlYvrZXTg==
X-CSE-MsgGUID: F3Evtn3AQcSWbiW90lyW0A==
X-IronPort-AV: E=McAfee;i="6700,10204,11255"; a="30869510"
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="30869510"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 16:17:18 -0800
X-CSE-ConnectionGUID: OBJ9MdICQK2y9UU0cxo7vA==
X-CSE-MsgGUID: g0naypt6TpWIMR76BCOIYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="92081166"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 16:17:19 -0800
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
Subject: [PATCH v9 6/9] x86/resctrl: Add "mba_MBps_event" file to ctrl_mon directories
Date: Wed, 13 Nov 2024 16:17:08 -0800
Message-ID: <20241114001712.80315-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241114001712.80315-1-tony.luck@intel.com>
References: <20241114001712.80315-1-tony.luck@intel.com>
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

Historically the limit was enforced by a feedback loop from
the measure local bandwidth to adjust the memory bandwidth
allocation controls.

In preparation to allow the user to pick the memory bandwidth
monitoring event used as input to the feedback loop, provide
a file in each ctrl_mon group directory that shows the event
currently in use.

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
index 3a89516e6f56..416e1acfad9f 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -1943,6 +1943,12 @@ static struct rftype res_common_files[] = {
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
@@ -2348,6 +2354,7 @@ static int set_mba_sc(bool mba_sc)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
 	u32 num_closid = resctrl_arch_get_num_closid(r);
 	struct rdt_ctrl_domain *d;
+	unsigned long fflags;
 	int i;
 
 	if (!supports_mba_mbps() || mba_sc == is_mba_sc(r))
@@ -2360,6 +2367,9 @@ static int set_mba_sc(bool mba_sc)
 			d->mbps_val[i] = MBA_MAX_MBPS;
 	}
 
+	fflags = mba_sc ? RFTYPE_CTRL_BASE | RFTYPE_MON_BASE : 0;
+	resctrl_file_fflags_init("mba_MBps_event", fflags);
+
 	return 0;
 }
 
-- 
2.47.0

