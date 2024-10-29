Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF57207A0B
	for <patches@lists.linux.dev>; Tue, 29 Oct 2024 17:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730222928; cv=none; b=LBGeD29tpsE7bLGpX20WAMPAzJl1CztPPq2oxmfBwSib/YsvBtmTJQ+jitV1Q0J90tmI5pDTYGwuRZJt8eMEFgObbjOuhttj2zMEvPbZjKMAW7af/8og3CZZdPn2NdmTPSSBSc2CvA0809wWGCtI1Z0a7WzhixeT8mLnDuh3QG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730222928; c=relaxed/simple;
	bh=y0upCVuwoxT9d72GZhH8/7dZn6beeSrJGjp/BYFWoQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKlVDOalsonKQghFwW0ewrxRjJF7MmneIdoQL3Rka0EBHD3ToMwN1ER/cmoZMT157/jqHeK2PkC0ZJNNqvWVETd+keh8ZzXVKvMe93dJ9SC0zn0x8h9Q3ichgTkNDC8flp9MHMV1a473QiOPcrO6+SSzGm5YGL0saR9NKOCMMWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ORkjkVDD; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ORkjkVDD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730222926; x=1761758926;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y0upCVuwoxT9d72GZhH8/7dZn6beeSrJGjp/BYFWoQs=;
  b=ORkjkVDDQXRmAJdg39QfVZPyXD0iQddWzVxP6wc3e7q7SLNFvceKKU9D
   Ym8RM2EgZjObDa7q6EyLfRW6pECzNkojoc7hRZ/koXpbzmH5ad6JW7CJd
   xvQESYyfLoZVtcRQlryZgxe18sYCVx7wFpdESBUpFZcUJ2IUbjWzPjrkG
   EJ3dWuMq36mBecsG0trrof10ryEbJ8yQirLleIe/zX23nx/KLnwI6OmD0
   +h3rz9+f0SpVT+FFcHoD7o8DT5V+0kcjbseww43SjNiiUwP6ywftPMuP7
   tiC4QTGqs7JFd0NuJlxoqLiRNhbbWJRfzim8J/52cKAy1dAlj4uaSQUah
   g==;
X-CSE-ConnectionGUID: nA24NCPXS/moZATk/okI8Q==
X-CSE-MsgGUID: u4ZDyA/5SWO8qiu6qRJ96w==
X-IronPort-AV: E=McAfee;i="6700,10204,11240"; a="17515700"
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="17515700"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 10:28:40 -0700
X-CSE-ConnectionGUID: RdYFygGKQamJaMq+6/fmQQ==
X-CSE-MsgGUID: YXzBzLS/RcGsdbhsZgnuMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="81585613"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 10:28:40 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
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
Subject: [PATCH v8 6/7] x86/resctrl: Add write option to "mba_MBps_event" file
Date: Tue, 29 Oct 2024 10:28:31 -0700
Message-ID: <20241029172832.93963-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241029172832.93963-1-tony.luck@intel.com>
References: <20241029172832.93963-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A user can choose any of the memory bandwidth monitoring events
listed in /sys/fs/resctrl/info/L3_mon/mon_features independently
for each ctrl_mon group by writing to the "mba_MBps_event" file.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h    |  2 +
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 46 +++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    |  1 +
 3 files changed, 49 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 5f3438ca9e2b..35483c6615b6 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -609,6 +609,8 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 				char *buf, size_t nbytes, loff_t off);
 int rdtgroup_schemata_show(struct kernfs_open_file *of,
 			   struct seq_file *s, void *v);
+ssize_t rdtgroup_mba_mbps_event_write(struct kernfs_open_file *of,
+				      char *buf, size_t nbytes, loff_t off);
 int rdtgroup_mba_mbps_event_show(struct kernfs_open_file *of,
 				 struct seq_file *s, void *v);
 bool rdtgroup_cbm_overlaps(struct resctrl_schema *s, struct rdt_ctrl_domain *d,
diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
index b9ba419e5c88..fc5585dc688f 100644
--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -518,6 +518,52 @@ static int smp_mon_event_count(void *arg)
 	return 0;
 }
 
+ssize_t rdtgroup_mba_mbps_event_write(struct kernfs_open_file *of,
+				      char *buf, size_t nbytes, loff_t off)
+{
+	struct rdtgroup *rdtgrp;
+	int ret = 0;
+
+	/* Valid input requires a trailing newline */
+	if (nbytes == 0 || buf[nbytes - 1] != '\n')
+		return -EINVAL;
+	buf[nbytes - 1] = '\0';
+
+	rdtgrp = rdtgroup_kn_lock_live(of->kn);
+	if (!rdtgrp) {
+		rdtgroup_kn_unlock(of->kn);
+		return -ENOENT;
+	}
+	rdt_last_cmd_clear();
+
+	if (!strcmp(buf, "mbm_local_bytes")) {
+		if (is_mbm_local_enabled())
+			rdtgrp->mba_mbps_event = QOS_L3_MBM_LOCAL_EVENT_ID;
+		else
+			ret = -ENXIO;
+	} else if (!strcmp(buf, "mbm_total_bytes")) {
+		if (is_mbm_total_enabled())
+			rdtgrp->mba_mbps_event = QOS_L3_MBM_TOTAL_EVENT_ID;
+		else
+			ret = -ENXIO;
+	} else {
+		ret = -EINVAL;
+	}
+
+	switch (ret) {
+	case -ENXIO:
+		rdt_last_cmd_printf("Unsupported event id '%s'\n", buf);
+		break;
+	case -EINVAL:
+		rdt_last_cmd_printf("Unknown event id '%s'\n", buf);
+		break;
+	}
+
+	rdtgroup_kn_unlock(of->kn);
+
+	return ret ?: nbytes;
+}
+
 int rdtgroup_mba_mbps_event_show(struct kernfs_open_file *of,
 				 struct seq_file *s, void *v)
 {
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 3ba81963e981..6fa501ef187f 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -1947,6 +1947,7 @@ static struct rftype res_common_files[] = {
 		.name		= "mba_MBps_event",
 		.mode		= 0644,
 		.kf_ops		= &rdtgroup_kf_single_ops,
+		.write		= rdtgroup_mba_mbps_event_write,
 		.seq_show	= rdtgroup_mba_mbps_event_show,
 	},
 	{
-- 
2.47.0

