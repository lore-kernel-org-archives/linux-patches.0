Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D94D134AC
	for <patches@lists.linux.dev>; Thu, 14 Nov 2024 00:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731543445; cv=none; b=HbY9gI8ohPO/3Eu2Ed3mE1XRaEp1fakaJfgoFz3VDpk/O977bUH5Zp3Waetbe7e67hFwq8JW3k2QexusBDuCTUA85GJp4nooEm37SvJkm8SivdOizATaKWcsjZoajKsz9bxuFf+6M73PZgJ99+L/KZ68j0Febc7SodqUoixVxVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731543445; c=relaxed/simple;
	bh=GIBBPueD41f/gJbHQyFVQ4yIOZGadcuF/ZE+ZTaWWqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMF7oEqH7bBsprTBrj4K5khgKdixUBHLmfHUxtkvOQH68oBcCMT5RFYT6fqhD+isU7oO/UyN2s8r69a2molMNknUxpOV9IuN47d6ubHESFkHaGVZayVKAMbyL2V1LHprhWPWY9N53j74ugUJ8i2YZGA6uYyW5GgKx0iWvF4Lo5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CJ7CzM43; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CJ7CzM43"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731543443; x=1763079443;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GIBBPueD41f/gJbHQyFVQ4yIOZGadcuF/ZE+ZTaWWqc=;
  b=CJ7CzM43604Fvh1WrIGZx3SGH8dk8OHtxv9TkvGt7cgiAS+rL9Z4Pyks
   qxXb/ik9Zadenpfqib9O45/GmKOpnFNBmbV2iP5lv0QTsWh0JVa9J591T
   qg07U642z+ThRXOiZ+TV4xOu1FxgccXrh7n1OjuNz8Ego84eXrtyo8n1N
   bkKnBX0aC0C7UilSSFX0dvCP8VeOII9zRCA+OxbQYN2tHkK+8n2SAzt5U
   DdUMap65a5dtVeume5Ci0GoAmHeK3iUIJ1bwzy2SS2RBGCTG7Ap6uFTsr
   hF5iX715lSKK3ijJoj/FgHbNfsuJrEu0EgfhjRKOWYjf9D163oZjZoLMz
   g==;
X-CSE-ConnectionGUID: WAEzLphmTzagLyfi43ic8A==
X-CSE-MsgGUID: q6U+OqeFSBSz9gi/8fl2sA==
X-IronPort-AV: E=McAfee;i="6700,10204,11255"; a="30869520"
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="30869520"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 16:17:18 -0800
X-CSE-ConnectionGUID: dAGrj+e/QTeHbfwF+6rOeQ==
X-CSE-MsgGUID: AXTdSrBDQNiZGzAmRXtJ9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="92081169"
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
Subject: [PATCH v9 7/9] x86/resctrl: Add write option to "mba_MBps_event" file
Date: Wed, 13 Nov 2024 16:17:09 -0800
Message-ID: <20241114001712.80315-8-tony.luck@intel.com>
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

The "mba_MBps" mount option provides an alternate method to control memory
bandwidth. Instead of specifying allowable bandwidth as a percentage of
maximum possible, the user provides a MiB/s limit value.

Historically the limit was enforced by a feedback loop from the measure
local bandwidth to adjust the memory bandwidth allocation controls.

There is a file in each ctrl_mon group directory that shows the event
currently in use (always says "mbm_local_bytes").

Allow writing that file to choose a different event.

A user can choose any of the memory bandwidth monitoring events listed in
/sys/fs/resctrl/info/L3_mon/mon_features independently for each ctrl_mon
group by writing to the "mba_MBps_event" file.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h    |  2 ++
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 40 +++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    |  3 +-
 3 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index ce10a883ecf8..6345ab3e0890 100644
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
index 5fa37b4ecc7a..ee983b68c046 100644
--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -518,6 +518,46 @@ static int smp_mon_event_count(void *arg)
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
+			ret = -EINVAL;
+	} else if (!strcmp(buf, "mbm_total_bytes")) {
+		if (is_mbm_total_enabled())
+			rdtgrp->mba_mbps_event = QOS_L3_MBM_TOTAL_EVENT_ID;
+		else
+			ret = -EINVAL;
+	} else {
+		ret = -EINVAL;
+	}
+
+	if (ret)
+		rdt_last_cmd_printf("Unsupported event id '%s'\n", buf);
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
index 416e1acfad9f..3f2e035208e6 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -1945,8 +1945,9 @@ static struct rftype res_common_files[] = {
 	},
 	{
 		.name		= "mba_MBps_event",
-		.mode		= 0444,
+		.mode		= 0644,
 		.kf_ops		= &rdtgroup_kf_single_ops,
+		.write		= rdtgroup_mba_mbps_event_write,
 		.seq_show	= rdtgroup_mba_mbps_event_show,
 	},
 	{
-- 
2.47.0

