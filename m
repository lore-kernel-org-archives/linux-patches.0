Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9477F647
	for <patches@lists.linux.dev>; Sat, 22 Jul 2023 19:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690052878; x=1721588878;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cXpDt+dnuqr6w3vRcORF5earUb+5d5AO1lTx5qdXM8g=;
  b=ShpTjp+yJGNH3UOV9sWFLGKqY91MOycJsJRp4C03o36JIBO7hCVXEsd0
   PW6PSXjeyTUXnQDEo/DWElbhbw0G2dqr2tV5NsKT7Y5VpIDrAhnSj8U+w
   VgLwpBM7COXBvodxttibo4JiUx3Iz3DqAS+jo0dnaCtmBZmLhmG+ynjxF
   KuNWNhVAnvnTf1gaE3+S+n5KB8QjGQ3U+rzN31hZ0uXhegMOwDnFyDQsL
   G/9/avEytcPM+XcZkkewq7+UcfWxMYQxREb1C7Aou2Kr8gboKvSH2asER
   qpcpLpMzablnTJnpizeSPLRccTg2FDwPMVutdAsjTXU5ttvhm+wX1eCU1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10779"; a="346823989"
X-IronPort-AV: E=Sophos;i="6.01,224,1684825200"; 
   d="scan'208";a="346823989"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2023 12:07:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10779"; a="815368094"
X-IronPort-AV: E=Sophos;i="6.01,224,1684825200"; 
   d="scan'208";a="815368094"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2023 12:07:52 -0700
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
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 6/7] x86/resctrl: Update documentation with Sub-NUMA cluster changes
Date: Sat, 22 Jul 2023 12:07:39 -0700
Message-Id: <20230722190740.326190-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230722190740.326190-1-tony.luck@intel.com>
References: <20230713163207.219710-1-tony.luck@intel.com>
 <20230722190740.326190-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With Sub-NUMA Cluster mode enabled the scope of monitoring resources is
per-NODE instead of per-L3 cache. Suffixes of directories with "L3" in
their name refer to Sub-NUMA nodes instead of L3 cache ids.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Peter Newman <peternewman@google.com>
---
 Documentation/arch/x86/resctrl.rst | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/arch/x86/resctrl.rst b/Documentation/arch/x86/resctrl.rst
index cb05d90111b4..4d9ddb91751d 100644
--- a/Documentation/arch/x86/resctrl.rst
+++ b/Documentation/arch/x86/resctrl.rst
@@ -345,9 +345,13 @@ When control is enabled all CTRL_MON groups will also contain:
 When monitoring is enabled all MON groups will also contain:
 
 "mon_data":
-	This contains a set of files organized by L3 domain and by
-	RDT event. E.g. on a system with two L3 domains there will
-	be subdirectories "mon_L3_00" and "mon_L3_01".	Each of these
+	This contains a set of files organized by L3 domain or by NUMA
+	node (depending on whether Sub-NUMA Cluster (SNC) mode is disabled
+	or enabled respectively) and by RDT event. E.g. on a system with
+	SNC mode disabled with two L3 domains there will be subdirectories
+	"mon_L3_00" and "mon_L3_01". The numerical suffix refers to the
+	L3 cache id.  With SNC enabled the directory names are the same,
+	but the numerical suffix refers to the node id.  Each of these
 	directories have one file per event (e.g. "llc_occupancy",
 	"mbm_total_bytes", and "mbm_local_bytes"). In a MON group these
 	files provide a read out of the current value of the event for
-- 
2.40.1

