Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C872192FE
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 00:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745886875; cv=none; b=P7a7PrJq7lYSWde2x11qEZB4npkHva+4N6LzYgauv107v1m6dYxQSRgE0tJxUYqTKtefXucez3mq3Epb/OMPR+AHjZV/82GRv0q7KM4EKV2TG0IubpJjQ75jhxgiGqzSB73BHJmuykY+KMUMsF12qM3fqzkyxK+31BA3GwK8fxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745886875; c=relaxed/simple;
	bh=YUTOhGbd6dZ07bX6i5x+8jR4iKqyRRJwMY4hLQXMO6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAfAw815UpGLziF2TPk2xgXZ2bUTwGgY2Umkw3L5K/9EmEZk8ah20ow0I0DW+VI/lRcasp/Skr+uBXlXD0ydaUNwhstpz8wkPMDchiY63nRuoZC9JSvKNT83bm9C1D3YD+ZykO7PsQMNs4EO012x1cwjiAaQErqo1b56xAdyXz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HYFVcDlP; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HYFVcDlP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745886873; x=1777422873;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YUTOhGbd6dZ07bX6i5x+8jR4iKqyRRJwMY4hLQXMO6w=;
  b=HYFVcDlPYAqwxskZWPXTNT9+8luezjvolSLilkpn3Iqs7kDgXCKtHdMe
   RjErERkRN+Nv0u/Pd9hNH6N/ycemM0TTh2tGwSWIBjpfLxy9zJQxI3fAd
   JU/6dCttUtssPsgj1t1yjTi8hBv80gS90BvAdyUDE3Hj1wEJvlepxVOld
   oBRv6huXJdCSZDxjRbNizNf5onYiS2uIRIHxgyAV7YUrkWdu0xTHm3cKI
   qg7Oa5t84M4aUokhMHMRz6eYby2rJIGr16d6eStLQnmXmNCNLLrDdwnFD
   vSsXC6r1oviPIxkhMUDIchTVm5OH2TAJcD/Gw/Vtt4J3GmKfVibsMxvP+
   A==;
X-CSE-ConnectionGUID: rWhXBSvDQPmKKbwCSFiamg==
X-CSE-MsgGUID: KOCHE9Q8TTKJzWFX43ZMjw==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58148317"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="58148317"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:25 -0700
X-CSE-ConnectionGUID: mWOeDafiSPGZibV08Ym2wQ==
X-CSE-MsgGUID: rtUInqN9RcqmWFms5o5K3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="133394087"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:24 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 29/31] fs/resctrl: Add interface for per-resource debug info files
Date: Mon, 28 Apr 2025 17:33:55 -0700
Message-ID: <20250429003359.375508-30-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250429003359.375508-1-tony.luck@intel.com>
References: <20250429003359.375508-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are some status registers on each of the telemetry aggregators.
Users may need to view these to understand unexpected event counter
values.

Add the file system support for a "status" file in each mon_capable
resource directory in the "info" directory. This will only be present if
the file system is mounted with the "-o debug" option. It will only have
content for resources that provide a rdt_resource::info_debug() routine.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h |  1 +
 fs/resctrl/rdtgroup.c   | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 3ae50b947a99..675cfbe3e6c6 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -299,6 +299,7 @@ struct rdt_resource {
 	struct list_head	evt_list;
 	unsigned int		mbm_cfg_mask;
 	bool			cdp_capable;
+	void			(*info_debug)(struct seq_file *s);
 };
 
 /*
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 195e41eb73fb..5948e279b44c 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1022,6 +1022,17 @@ static int rdt_shareable_bits_show(struct kernfs_open_file *of,
 	return 0;
 }
 
+static int rdtgroup_info_debug_show(struct kernfs_open_file *of,
+				struct seq_file *s, void *v)
+{
+	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
+
+	if (r->info_debug)
+		r->info_debug(s);
+
+	return 0;
+}
+
 /*
  * rdt_bit_usage_show - Display current usage of resources
  *
@@ -1983,6 +1994,13 @@ static struct rftype res_common_files[] = {
 		.seq_show	= rdtgroup_closid_show,
 		.fflags		= RFTYPE_CTRL_BASE | RFTYPE_DEBUG,
 	},
+	{
+		.name		= "status",
+		.mode		= 0444,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= rdtgroup_info_debug_show,
+		.fflags		= RFTYPE_MON_INFO | RFTYPE_DEBUG,
+	},
 };
 
 static int rdtgroup_add_files(struct kernfs_node *kn, unsigned long fflags)
-- 
2.48.1

