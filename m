Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB8B19BDD
	for <patches@lists.linux.dev>; Wed, 21 Jun 2023 17:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687369245; x=1718905245;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r5UMYKpVO7CH5T1tFztMST9Hrba8NtQtdvEfQNwuWZQ=;
  b=ZWx3ot16wFFkPhpQuyo9Tm/vD2ZiHCH+uJLxO5FaINLBdffPvDGp8Roq
   yeUF2QmwIijGkG3Xh6BAPf+MTcUP0ROh1OhGS1Nlkuax7Qk9aztXj1NCz
   vB9UoenMBGP/WytSDs9QrRLH98mxBL5dPU6+UzKbzs7bZdvyVUoaU0+Hg
   sVBy/TdFy7mxbZK6VZGFeyRRas7Z4WbRleiOpjCTXxYEKRtoaeHRVJBOG
   C5TcG4AIuwDM2g6vBJgP7k1NLoeMKJzcpSGUza0kwL78B0rUcxccBgToE
   ZCP+ve/fx3B90JWryfGx74D/cd639+YBujkRcL+L3TBK+4C3Ntl2UUh2m
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="359120554"
X-IronPort-AV: E=Sophos;i="6.00,261,1681196400"; 
   d="scan'208";a="359120554"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2023 10:40:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="779921580"
X-IronPort-AV: E=Sophos;i="6.00,261,1681196400"; 
   d="scan'208";a="779921580"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2023 10:40:17 -0700
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
Subject: [PATCH v2 6/7] x86/resctrl: Update documentation with Sub-NUMA cluster changes
Date: Wed, 21 Jun 2023 10:40:05 -0700
Message-Id: <20230621174006.42533-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230621174006.42533-1-tony.luck@intel.com>
References: <20230621174006.42533-1-tony.luck@intel.com>
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
---
 Documentation/arch/x86/resctrl.rst | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/arch/x86/resctrl.rst b/Documentation/arch/x86/resctrl.rst
index cb05d90111b4..13fc9fa664fc 100644
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
+	"mon_L3_00" and "mon_L3_01" the numerical suffix refers to the
+	L3 cache id.  With SNC enabled the directory names are the same,
+	but the numerical suffix refers to the node id.  Each of these
 	directories have one file per event (e.g. "llc_occupancy",
 	"mbm_total_bytes", and "mbm_local_bytes"). In a MON group these
 	files provide a read out of the current value of the event for
-- 
2.40.1

