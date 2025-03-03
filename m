Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420B222FAC3
	for <patches@lists.linux.dev>; Mon,  3 Mar 2025 23:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741044895; cv=none; b=czk0wGD34XHWeE+pk4P94PcHnLWkeLHdqAQX4O7SVNUeK7ZLs00pZN1MXtb6cYEc7wQ3wbMHmmBV/1exuwIZSvpN4wJmOGsKVIqe8MTyfLV8TwKrvRIIhlxjvlCeI3iOwWcW9kHhewSejNvJCzGQodXuwPZQon2fHt1R5+e7PQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741044895; c=relaxed/simple;
	bh=d7RQfizMQbYx4OTl2luYPTFNKrA57PgoWS6A/03o7W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Coh96MhSz7/SiwJuW+gWojYJV1twg5zRnLH2H5/fgbmKt7RMVfOZmXI/+eoQK5HYxCjtLJ1ZdBlAMZu4q4r7DPoPethFGjO+daf//mrTgenImzotg/TMBNvCJq2pV7X5VvMlusjSMctH8lGC0147wuzNQCkWKF5erMpWez05Ucc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EleZ5YpN; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EleZ5YpN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741044893; x=1772580893;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d7RQfizMQbYx4OTl2luYPTFNKrA57PgoWS6A/03o7W8=;
  b=EleZ5YpNzBOXOE+knpQVEooQwPCsbLtfAeAg1cwlhfG8h/gpZACZ44HA
   3puS0rthhx8dA2nqbUtuaBdK2xHK+ElXwdiVAAjKTWKfkKzUJOAnyTuqt
   XfHuDwbjkAnb0t44kanbjt8u3+t3K7ZZkOUHeKHUQ3Q25T2E6sl2LooXg
   Pk1iDUbvJJGB2mIW9lwl/NJ0fWW2s2LyG/Vh6Gx/062PE+FMSNBQZ+/yO
   4L5q17Q6A0c/Sg/KmtVhg/YKVpuj2adV+pLOz1WGyKvR3JXDO6M54Zisz
   AzimxkVoLy9/GxK6FvjMwKIrZYXhrBUZqMNzu2U+LZIi43jquTRZNosiW
   Q==;
X-CSE-ConnectionGUID: 0KnmRgAXS9e5KQslBXkDlg==
X-CSE-MsgGUID: 1szy5rwARriRNuSSskSrCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41835954"
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="41835954"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:34:47 -0800
X-CSE-ConnectionGUID: cgak7XuLRfK2/yvUzIkgew==
X-CSE-MsgGUID: wQBnkkGqT3e0lCNvfpvjyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="117982296"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:33:52 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 09/17] x86/resctrl: Add Intel PMT domain specific code
Date: Mon,  3 Mar 2025 15:33:29 -0800
Message-ID: <20250303233340.333743-10-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250303233340.333743-1-tony.luck@intel.com>
References: <20250303233340.333743-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Domain specific initialization and tear down. Very simple as
there are no domain specific elements that need to be allocated
or initiailazed. Just the domain itself.

This does need the mkdir_mondata_subdir_allrdtgrp() and
rmdir_mondata_subdir_allrdtgrp() functions. So change them
from static to global so they can be called from other source
files.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  |  7 +++++++
 arch/x86/kernel/cpu/resctrl/core.c      | 12 ++++++++++++
 arch/x86/kernel/cpu/resctrl/intel_pmt.c | 16 ++++++++++++++++
 arch/x86/kernel/cpu/resctrl/rdtgroup.c  |  6 ++----
 4 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index f530382d8871..65bbe223f8a1 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -640,9 +640,12 @@ int rdt_get_mon_l3_config(struct rdt_resource *r);
 #ifdef CONFIG_INTEL_PMT_RESCTRL
 int rdt_get_intel_pmt_mon_config(void);
 void rdt_get_intel_pmt_mount(void);
+void setup_intel_pmt_mon_domain(int cpu, int id, struct rdt_resource *r, struct list_head *add_pos);
 #else
 static inline int rdt_get_intel_pmt_mon_config(void) { return 0; }
 static inline void rdt_get_intel_pmt_mount(void) { }
+static inline void setup_intel_pmt_mon_domain(int cpu, int id, struct rdt_resource *r,
+					      struct list_head *add_pos) { }
 #endif
 void __exit rdt_put_mon_l3_config(void);
 bool __init rdt_cpu_has(int flag);
@@ -667,4 +670,8 @@ void resctrl_file_fflags_init(const char *config, unsigned long fflags);
 void rdt_staged_configs_clear(void);
 bool closid_allocated(unsigned int closid);
 int resctrl_find_cleanest_closid(void);
+void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
+				    struct rdt_domain_hdr *hdr);
+void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
+				    struct rdt_domain_hdr *hdr);
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index c18d79e470d2..b6e6a25520f7 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -657,6 +657,9 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	case RDT_RESOURCE_L3:
 		setup_l3_mon_domain(cpu, id, r, add_pos);
 		break;
+	case RDT_RESOURCE_INTEL_PMT:
+		setup_intel_pmt_mon_domain(cpu, id, r, add_pos);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 	}
@@ -752,6 +755,15 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 		synchronize_rcu();
 		mon_domain_free(hw_dom);
 		break;
+	case RDT_RESOURCE_INTEL_PMT:
+		mutex_lock(&rdtgroup_mutex);
+		if (resctrl_mounted && resctrl_arch_mon_capable())
+			rmdir_mondata_subdir_allrdtgrp(r, hdr);
+		mutex_unlock(&rdtgroup_mutex);
+		list_del_rcu(&hdr->list);
+		synchronize_rcu();
+		kfree(container_of(hdr, struct rdt_core_mon_domain, hdr));
+		break;
 	}
 }
 
diff --git a/arch/x86/kernel/cpu/resctrl/intel_pmt.c b/arch/x86/kernel/cpu/resctrl/intel_pmt.c
index 44373052ca49..76ec42a67c48 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_pmt.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_pmt.c
@@ -167,3 +167,19 @@ void rdt_get_intel_pmt_mount(void)
 		r->mon_capable = false;
 	}
 }
+
+void setup_intel_pmt_mon_domain(int cpu, int id, struct rdt_resource *r, struct list_head *add_pos)
+{
+	struct rdt_core_mon_domain *hw_dom;
+
+	hw_dom = kzalloc_node(sizeof(*hw_dom), GFP_KERNEL, cpu_to_node(cpu));
+	if (!hw_dom)
+		return;
+
+	hw_dom->hdr.id = id;
+	hw_dom->hdr.type = RESCTRL_MON_DOMAIN;
+	cpumask_set_cpu(cpu, &hw_dom->hdr.cpu_mask);
+	list_add_tail_rcu(&hw_dom->hdr.list, add_pos);
+	if (resctrl_mounted && resctrl_arch_mon_capable())
+		mkdir_mondata_subdir_allrdtgrp(r, &hw_dom->hdr);
+}
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 4259bded5b7b..93da2e4f7fec 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -3041,8 +3041,7 @@ static void mon_rmdir_one_subdir(struct kernfs_node *pkn, char *name, char *subn
  * Remove files and directories containing "sum" of domain data
  * when last domain being summed is removed.
  */
-static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
-					   struct rdt_domain_hdr *hdr)
+void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
 {
 	struct rdtgroup *prgrp, *crgrp;
 	char subname[32];
@@ -3170,8 +3169,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
  * Add all subdirectories of mon_data for "ctrl_mon" groups
  * and "monitor" groups with given domain id.
  */
-static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
-					   struct rdt_domain_hdr *hdr)
+void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
 {
 	struct kernfs_node *parent_kn;
 	struct rdtgroup *prgrp, *crgrp;
-- 
2.48.1

