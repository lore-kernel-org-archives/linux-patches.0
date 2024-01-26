Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E35E51C53
	for <patches@lists.linux.dev>; Fri, 26 Jan 2024 22:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706308736; cv=none; b=WghQnJ9slgWY0YDzSLl7rnNlklL3MNBRY6wb6FpP2PlKLohdb8SSMH0ZRFlloM13xdS1N3h84z8cUkiCYMhry5i39eDkrFhgbru0igEZdWhkXROsmxhwlsH3tAzQ9dWyD1A4g+2e1xKaBmj+vPtC8zzoEiLjpD5y3kVm1Sy8Zz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706308736; c=relaxed/simple;
	bh=+qqwl/QGgrcrhJ6bwo0zQQqegC4LYQZlox3muG18Qkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCYI4FZ0aPuomqX67vn9CtFkpLsO/slELVuuwzkz7oxh3HRfJgoFv7ER42QBGYprvbxYwpppYjE3L92e6+tHS/sj1+XOXfGuOO3nlj8cSHrCFWyR9C1aldpsK/8l7qRWpvho7n1K/tZbrPQrpBNr9HXHkIvYlD2i39MRSM5E4Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ND8EzDw+; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ND8EzDw+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706308733; x=1737844733;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+qqwl/QGgrcrhJ6bwo0zQQqegC4LYQZlox3muG18Qkg=;
  b=ND8EzDw+5mRFgSWydPN5qImkwSsiKWXwBIbbq4NrO/ayVNTTQYmXJC7L
   dZHifagW81Z3LlODIkfmzwVNrt7VF4AlPig2JT7zOBFsiWLNcFSEP+R+n
   AMSQw+nNY+wzB2+9kCpnUbh2QynKHA/dvG+RvU+0WAjii7VoYjqlSBaK4
   PWfg72R4nwhv15qA/93U98LRKtPKny9UvEq+h1GMoULSFHFPZh7+SkfER
   72qyzrfCxBHdVVcR8oZ2A9a/472tkumP7/y3dH4LYGxPyywmYDkuGIH2z
   YWiDbjG3QLbM+SWEZd8/Cg4IP7r7XRvJBzwY+RlYyHPQvyeWpOcHh/hWJ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9707744"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="9707744"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 14:38:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="35560272"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 14:38:49 -0800
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>,
	Babu Moger <babu.moger@gmail.com>
Subject: [PATCH v14 8/8] x86/resctrl: Update documentation with Sub-NUMA cluster changes
Date: Fri, 26 Jan 2024 14:38:37 -0800
Message-ID: <20240126223837.21835-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240126223837.21835-1-tony.luck@intel.com>
References: <20231204185357.120501-1-tony.luck@intel.com>
 <20240126223837.21835-1-tony.luck@intel.com>
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

Users should be aware that SNC mode also affects the amount of L3 cache
available for allocation within each SNC node.

Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Peter Newman <peternewman@google.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Babu Moger <babu.moger@gmail.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/arch/x86/resctrl.rst | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/Documentation/arch/x86/resctrl.rst b/Documentation/arch/x86/resctrl.rst
index a6279df64a9d..15f1cff6ee76 100644
--- a/Documentation/arch/x86/resctrl.rst
+++ b/Documentation/arch/x86/resctrl.rst
@@ -366,10 +366,10 @@ When control is enabled all CTRL_MON groups will also contain:
 When monitoring is enabled all MON groups will also contain:
 
 "mon_data":
-	This contains a set of files organized by L3 domain and by
-	RDT event. E.g. on a system with two L3 domains there will
-	be subdirectories "mon_L3_00" and "mon_L3_01".	Each of these
-	directories have one file per event (e.g. "llc_occupancy",
+	This contains a set of files organized by L3 domain or by NUMA
+	node (depending on whether Sub-NUMA Cluster (SNC) mode is disabled
+	or enabled respectively) and by RDT event.  Each of these
+	directories has one file per event (e.g. "llc_occupancy",
 	"mbm_total_bytes", and "mbm_local_bytes"). In a MON group these
 	files provide a read out of the current value of the event for
 	all tasks in the group. In CTRL_MON groups these files provide
@@ -478,6 +478,23 @@ if non-contiguous 1s value is supported. On a system with a 20-bit mask
 each bit represents 5% of the capacity of the cache. You could partition
 the cache into four equal parts with masks: 0x1f, 0x3e0, 0x7c00, 0xf8000.
 
+Notes on Sub-NUMA Cluster mode
+==============================
+When SNC mode is enabled, Linux may load balance tasks between Sub-NUMA
+nodes much more readily than between regular NUMA nodes since the CPUs
+on Sub-NUMA nodes share the same L3 cache and the system may report
+the NUMA distance between Sub-NUMA nodes with a lower value than used
+for regular NUMA nodes.  Users who do not bind tasks to the CPUs of a
+specific Sub-NUMA node must read the "llc_occupancy", "mbm_total_bytes",
+and "mbm_local_bytes" for all Sub-NUMA nodes where the tasks may execute
+to get the full view of traffic for which the tasks were the source.
+
+The cache allocation feature still provides the same number of
+bits in a mask to control allocation into the L3 cache, but each
+of those ways has its capacity reduced because the cache is divided
+between the SNC nodes. The values reported in the resctrl
+"size" files are adjusted accordingly.
+
 Memory bandwidth Allocation and monitoring
 ==========================================
 
-- 
2.43.0

