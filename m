Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997CE4C92
	for <patches@lists.linux.dev>; Thu, 26 Jan 2023 18:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674758554; x=1706294554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lazqj33+wcKOHpjgmXNXHNJZww2MNyt2EHBaLJXRYCw=;
  b=R1aakBsrZVjwct6Xz6YqttZUOzULxZivtDU17vYiJN3twUCbYqtF/UHt
   ZBS/jNtw2i71pZ4Ei65VFk+OsDsPMW78/gbD4MbEIKYzMaHoyRGqN5Pn+
   6nllavmXZvoqySvhn8cxsD/QaPiTOwZsvpn7wv/yj0ABTmSUExEU/GqRU
   zpxm77/Ia7fI8TmUSTspnrqGR1gXPmYjm1sKtGURbFlkLCtOhycKoaThN
   C0W2S/vZcCU+/QCnmFocfuasDXyt5LFdZXDe0XqVpKdVZnAJWB4jycvIU
   4sDGP8heyUIZCKDMbltltpgVZNDhdaETJ68d43UMR+Jxmgn8EE2ns+eqv
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="354203362"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="354203362"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 10:42:06 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="991745452"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="991745452"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 10:42:06 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	x86@kernel.org
Cc: Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 5/7] x86/resctrl: Add a new "snc_ways" file to the monitoring info directory.
Date: Thu, 26 Jan 2023 10:41:55 -0800
Message-Id: <20230126184157.27626-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230126184157.27626-1-tony.luck@intel.com>
References: <20230126184157.27626-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make it easy for the user to tell if Sub-NUMA Cluster is enabled by
providing an info/ file.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index a0dc64a70d01..392e7a08d083 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -997,6 +997,14 @@ static int rdt_num_rmids_show(struct kernfs_open_file *of,
 	return 0;
 }
 
+static int rdt_snc_ways_show(struct kernfs_open_file *of,
+			     struct seq_file *seq, void *v)
+{
+	seq_printf(seq, "%d\n", snc_ways);
+
+	return 0;
+}
+
 static int rdt_mon_features_show(struct kernfs_open_file *of,
 				 struct seq_file *seq, void *v)
 {
@@ -1451,6 +1459,13 @@ static struct rftype res_common_files[] = {
 		.seq_show	= rdt_num_rmids_show,
 		.fflags		= RF_MON_INFO,
 	},
+	{
+		.name		= "snc_ways",
+		.mode		= 0444,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= rdt_snc_ways_show,
+		.fflags		= RF_MON_INFO,
+	},
 	{
 		.name		= "cbm_mask",
 		.mode		= 0444,
-- 
2.39.1

