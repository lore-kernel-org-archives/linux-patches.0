Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7627C2417C8
	for <patches@lists.linux.dev>; Mon,  3 Mar 2025 23:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741044899; cv=none; b=cMcavsP7ZfnpQNuLB8fmqsgocutJ6QoLm4FrxmJid8iFFAKGZqzaG4vTy6zceMpAaKhG5kf7A5wG7bs2pkBfxqeCzzBFU0bn1k91ImI21taFR94OAY4s2F3b66c5ic49kE50G32wQ5MUBuiNwbY314InH1208hSDO8wNpkSbtCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741044899; c=relaxed/simple;
	bh=nEsNTILO+oJDYQMdfU/3EJz/B3Q6iXwLDlSx6wG2pIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agmhQO74JYgyypXSlm76QQrZCsgc8JNgsI/5qZ+EPvOVVdBwnw4XnwnE4J+oXk2JL8Ibr00EavAYERPmb9cyXd4ct6rInQkjsHoSrkTEyXtElx9uRzSVszAT5FlKqt2ryNoqBfNmaP38ddhNgv/EOArRZQ8ciVyenLrrmVvGVs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gW17uiWJ; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gW17uiWJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741044897; x=1772580897;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nEsNTILO+oJDYQMdfU/3EJz/B3Q6iXwLDlSx6wG2pIA=;
  b=gW17uiWJ068/Ny3kf1XA4k15gZYEf7jdadtdPmMHQF6HbvnJEZxb5zGg
   3gXNUybOsiCA0XssdwWuU9ksBTiGDUvuHD4hE0tjLdG/CiJ1fYXgclDl0
   DjMVYGwxsaYUmTeH1xUibWNyHu3DysxDOO1SW2UBmApTxaS7tXlNvle3g
   uVG0yF5H0qg7fgd9aPJGX3xW4Aede2fPy8XH8xi4+uZPW4XROP7dzx+jK
   Uxetprdyg34Jlrm2dgFFXrLFwOCSTBW+RBnXJzp6LR9GbQthmA5tUel8n
   bW7/EWoeCVn8WxAkk3qQDDKHDV3bdw7gFBHD1Dz8NDR3ISmn0CWjOGKk8
   A==;
X-CSE-ConnectionGUID: U/uOPYspSwqBXZYdCoFstw==
X-CSE-MsgGUID: Tfkhb5L/RZGLWqzWn7cJ4A==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41835994"
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="41835994"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:34:48 -0800
X-CSE-ConnectionGUID: sD+Nu1xHR0aY9Xs5JtfndA==
X-CSE-MsgGUID: aGS+uZrnS8u66wL7QIVUqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="117982308"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:33:53 -0800
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
Subject: [RFC PATCH 15/17] x86/resctrl: Add status files to info/PKG_MON
Date: Mon,  3 Mar 2025 15:33:35 -0800
Message-ID: <20250303233340.333743-16-tony.luck@intel.com>
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

Each of the package event groups includes status about the number
of missed events and timestamps (from a 25 MHz clock) on last time
an update was missed and last time an update was processed.

Add a three info files to report per-aggregator values of these
status values.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  | 13 ++++
 arch/x86/kernel/cpu/resctrl/intel_pmt.c | 92 ++++++++++++++++++++++---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c  | 22 +++++-
 3 files changed, 117 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 068a47b015e7..5f3656e938ed 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -321,6 +321,7 @@ struct rdtgroup {
 #define RFTYPE_CTRL_INFO		(RFTYPE_INFO | RFTYPE_CTRL)
 #define RFTYPE_MON_INFO			(RFTYPE_INFO | RFTYPE_MON)
 #define RFTYPE_TOP_INFO			(RFTYPE_INFO | RFTYPE_TOP)
+#define RFTYPE_PKG_INFO			(RFTYPE_INFO | RFTYPE_RES_PKG)
 #define RFTYPE_CTRL_BASE		(RFTYPE_BASE | RFTYPE_CTRL)
 #define RFTYPE_MON_BASE			(RFTYPE_BASE | RFTYPE_MON)
 
@@ -642,6 +643,12 @@ int rdt_get_intel_pmt_mon_config(void);
 int rdtgroup_intel_pmt_data_show(struct seq_file *m, struct rdt_resource *r,
 				 int domid, struct rdtgroup *rdtgrp, u32 evtid,
 				 struct rmid_read *rr);
+int rdtgroup_last_update_show(struct kernfs_open_file *of,
+			      struct seq_file *seq, void *v);
+int rdtgroup_overflows_show(struct kernfs_open_file *of,
+			    struct seq_file *seq, void *v);
+int rdtgroup_overflow_timestamp_show(struct kernfs_open_file *of,
+				     struct seq_file *seq, void *v);
 void rdt_get_intel_pmt_mount(void);
 void setup_intel_pmt_mon_domain(int cpu, int id, struct rdt_resource *r, struct list_head *add_pos);
 void rdt_intel_pmt_exit(void);
@@ -650,6 +657,12 @@ static inline int rdt_get_intel_pmt_mon_config(void) { return 0; }
 static inline int rdtgroup_intel_pmt_data_show(struct seq_file *m, struct rdt_resource *r,
 					       int domid, struct rdtgroup *rdtgrp, u32 evtid,
 					       struct rmid_read *rr) { return 0; }
+static inline int rdtgroup_last_update_show(struct kernfs_open_file *of,
+					    struct seq_file *seq, void *v) { return 0; };
+static inline int rdtgroup_overflows_show(struct kernfs_open_file *of,
+					  struct seq_file *seq, void *v) { return 0; };
+static inline int rdtgroup_overflow_timestamp_show(struct kernfs_open_file *of,
+						   struct seq_file *seq, void *v) { return 0; };
 static inline void rdt_get_intel_pmt_mount(void) { }
 static inline void setup_intel_pmt_mon_domain(int cpu, int id, struct rdt_resource *r,
 					      struct list_head *add_pos) { }
diff --git a/arch/x86/kernel/cpu/resctrl/intel_pmt.c b/arch/x86/kernel/cpu/resctrl/intel_pmt.c
index 4067aacd9d80..e89130387387 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_pmt.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_pmt.c
@@ -321,25 +321,37 @@ void setup_intel_pmt_mon_domain(int cpu, int id, struct rdt_resource *r, struct
 		mkdir_mondata_subdir_allrdtgrp(r, &hw_dom->hdr);
 }
 
+enum ops {
+	DO_SUM_EVENT,
+	DO_PRINTVALS
+};
+
 #define VALID_BIT	BIT_ULL(63)
 #define DATA_BITS	GENMASK_ULL(62, 0)
 
-static u64 scan_pmt_devs(int package, int guid, int offset)
+static u64 scan_pmt_devs(struct seq_file *m, int package, int guid, int offset, enum ops op)
 {
-	u64 rval, val;
+	u64 rval = 0, val;
+	char *sep = "";
 	int ndev = 0;
 
-	rval = 0;
-
 	for (int i = 0; i < pkg_info[package].count; i++) {
 		if (pkg_info[package].regions[i].guid != guid)
 			continue;
 		ndev++;
 		val = readq(pkg_info[package].regions[i].addr + offset);
 
-		if (!(val & VALID_BIT))
-			return ~0ull;
-		rval += val & DATA_BITS;
+		switch (op) {
+		case DO_SUM_EVENT:
+			if (!(val & VALID_BIT))
+				return ~0ull;
+			rval += val & DATA_BITS;
+			break;
+		case DO_PRINTVALS:
+			seq_printf(m, "%s0x%llx", sep, val);
+			sep = ",";
+			break;
+		}
 	}
 
 	return ndev ? rval : ~0ull;
@@ -377,7 +389,7 @@ int rdtgroup_intel_pmt_data_show(struct seq_file *m, struct rdt_resource *r,
 	offset = rdtgrp->mon.rmid * EVT_STRIDE(evtid);
 	offset += EVT_OFFSET(evtid);
 
-	val = scan_pmt_devs(domid, EVT_GUID(evtid), offset);
+	val = scan_pmt_devs(m, domid, EVT_GUID(evtid), offset, DO_SUM_EVENT);
 	if (val == ~0ull) {
 		seq_puts(m, "unavailable\n");
 		return 0;
@@ -388,7 +400,7 @@ int rdtgroup_intel_pmt_data_show(struct seq_file *m, struct rdt_resource *r,
 		list_for_each_entry(entry, head, mon.crdtgrp_list) {
 			offset = entry->mon.rmid * EVT_STRIDE(evtid);
 			offset += EVT_OFFSET(evtid);
-			cval = scan_pmt_devs(domid, EVT_GUID(evtid), offset);
+			cval = scan_pmt_devs(m, domid, EVT_GUID(evtid), offset, DO_SUM_EVENT);
 			if (cval == ~0ull) {
 				seq_puts(m, "unavailable\n");
 				return 0;
@@ -408,3 +420,65 @@ int rdtgroup_intel_pmt_data_show(struct seq_file *m, struct rdt_resource *r,
 
 	return 0;
 }
+
+static void status_show(struct seq_file *seq, char *name, int guid, int offset)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_INTEL_PMT].r_resctrl;
+	struct rdt_mon_domain *d;
+	char *sep = "";
+
+	seq_printf(seq, "%s: ", name);
+
+	cpus_read_lock();
+	list_for_each_entry(d, &r->mon_domains, hdr.list) {
+		seq_printf(seq, "%s%d=[", sep, d->hdr.id);
+		scan_pmt_devs(seq, d->hdr.id, guid, offset, DO_PRINTVALS);
+		seq_puts(seq, "]");
+		sep = ";";
+	}
+	cpus_read_unlock();
+
+	seq_puts(seq, "\n");
+}
+
+int rdtgroup_last_update_show(struct kernfs_open_file *of,
+			      struct seq_file *seq, void *v)
+{
+	struct telem_entry **t;
+
+	for (t = telem_entry; *t; t++) {
+		if (!(*t)->active)
+			continue;
+		status_show(seq, (*t)->name, (*t)->guid, (*t)->last_update_tstamp_off);
+	}
+
+	return 0;
+}
+
+int rdtgroup_overflows_show(struct kernfs_open_file *of,
+			    struct seq_file *seq, void *v)
+{
+	struct telem_entry **t;
+
+	for (t = telem_entry; *t; t++) {
+		if (!(*t)->active)
+			continue;
+		status_show(seq, (*t)->name, (*t)->guid, (*t)->overflow_counter_off);
+	}
+
+	return 0;
+}
+
+int rdtgroup_overflow_timestamp_show(struct kernfs_open_file *of,
+				     struct seq_file *seq, void *v)
+{
+	struct telem_entry **t;
+
+	for (t = telem_entry; *t; t++) {
+		if (!(*t)->active)
+			continue;
+		status_show(seq, (*t)->name, (*t)->guid, (*t)->last_overflow_tstamp_off);
+	}
+
+	return 0;
+}
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 93da2e4f7fec..635c17042f7a 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -1986,7 +1986,27 @@ static struct rftype res_common_files[] = {
 		.seq_show	= rdtgroup_closid_show,
 		.fflags		= RFTYPE_CTRL_BASE | RFTYPE_DEBUG,
 	},
-
+	{
+		.name		= "last_update",
+		.mode		= 0444,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= rdtgroup_last_update_show,
+		.fflags		= RFTYPE_PKG_INFO,
+	},
+	{
+		.name		= "overflows",
+		.mode		= 0444,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= rdtgroup_overflows_show,
+		.fflags		= RFTYPE_PKG_INFO,
+	},
+	{
+		.name		= "overflow_timestamp",
+		.mode		= 0444,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= rdtgroup_overflow_timestamp_show,
+		.fflags		= RFTYPE_PKG_INFO,
+	},
 };
 
 static int rdtgroup_add_files(struct kernfs_node *kn, unsigned long fflags)
-- 
2.48.1

