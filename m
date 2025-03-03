Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEC324290B
	for <patches@lists.linux.dev>; Mon,  3 Mar 2025 23:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741044900; cv=none; b=t0Jki45uuU/7ro030lWrx3KjSd9ke6G22uRL3jLwG8iMx0XGy/2YIllJoGC0CUgqr5UWl/3PmbV3zzsylbxIBv1bPY0CbY3BaQaHRT121QXfFI7FhvJZwpVBfb22+v+EqTb+A2MDR1GP3WjFDuuo/OphClnU0iTNw6hXBUCC/ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741044900; c=relaxed/simple;
	bh=aUA08AFTrU4Oj+k0TfMPmLNrgGY6OrG+i+m/giJeBT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=biCNtIN2gvazvNPDMNdscNapFd9kcqjtnSXGdymiCnD98I+D1NFRSKSkyRZ5wh0s8NDnu5w/Jqq7CFI0N8KiW2/CU5QLy3WGdlxnfavd1wcqZqAf43uftpYPWH6r2zIgQhfjSQQjFBcr/gOQnI6XXYnR4X6fECSXQsu2PERuTDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C37+j5m2; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C37+j5m2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741044899; x=1772580899;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aUA08AFTrU4Oj+k0TfMPmLNrgGY6OrG+i+m/giJeBT0=;
  b=C37+j5m27gIcwCrQUsM0C9PQFuKIgytUd8+fKbbyCgVQJrrKh5ODngtL
   2vDmT5XcILwHqjvy4KE0v+wXNMkpZ8q+R8ISDaU1OnziN2yd/QHhFX1vH
   5CvPHxn1AR22NopgfK6IKBHKu8sk/lRrJsQdbniF/jFea6Xs0Vi99D1hv
   l4hG+vQcYLqkcT/0Qt0b2RE5z7CUSKZLSHLd/9zxfo3LdX6wINIWC8j+n
   XFgKVuKwzEzmu0t7oYYpkZySTsfHz2koxA8NYrss6kVi3+1UnmaayhDjb
   JndspnQCidOHjN3vKYc1MRV9wif9bAn/AhuXyDMVs/6oACov/HuXNt4qh
   w==;
X-CSE-ConnectionGUID: 0O2U20LVRle3CjQ6jj/xpA==
X-CSE-MsgGUID: 6kkWNVY8SIKUEaiYR4dmIQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41836010"
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="41836010"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:34:48 -0800
X-CSE-ConnectionGUID: DuAGdh4QQpyklPPlgWYW1g==
X-CSE-MsgGUID: nbPf924GTMKWtzKv6p7lKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="117982312"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:33:54 -0800
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
Subject: [RFC PATCH 17/17] x86/resctrl: Update Documentation for package events
Date: Mon,  3 Mar 2025 15:33:37 -0800
Message-ID: <20250303233340.333743-18-tony.luck@intel.com>
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

Each "mon_data" directory is now divided between L3 events and package
events.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/arch/x86/resctrl.rst | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/Documentation/arch/x86/resctrl.rst b/Documentation/arch/x86/resctrl.rst
index 6768fc1fad16..0e915b7c55aa 100644
--- a/Documentation/arch/x86/resctrl.rst
+++ b/Documentation/arch/x86/resctrl.rst
@@ -366,15 +366,22 @@ When control is enabled all CTRL_MON groups will also contain:
 When monitoring is enabled all MON groups will also contain:
 
 "mon_data":
-	This contains a set of files organized by L3 domain and by
-	RDT event. E.g. on a system with two L3 domains there will
-	be subdirectories "mon_L3_00" and "mon_L3_01".	Each of these
-	directories have one file per event (e.g. "llc_occupancy",
-	"mbm_total_bytes", and "mbm_local_bytes"). In a MON group these
-	files provide a read out of the current value of the event for
-	all tasks in the group. In CTRL_MON groups these files provide
-	the sum for all tasks in the CTRL_MON group and all tasks in
-	MON groups. Please see example section for more details on usage.
+	This contains a set of directories, one for each instance
+	of an L3 cache, or of a processor package. The L3 cache
+	directories are named "mon_L3_00", "mon_L3_01" etc. The
+	package directories "mon_PKG_00", "mon_PKG_01" etc.
+
+	Within each directory there is one file per event. In
+	the L3 directories: "llc_occupancy", "mbm_total_bytes",
+	and "mbm_local_bytes".	In the PKG directories: "core_energy",
+	"activity", etc.
+
+	In a MON group these files provide a read out of the current
+	value of the event for all tasks in the group. In CTRL_MON groups
+	these files provide the sum for all tasks in the CTRL_MON group
+	and all tasks in MON groups. Please see example section for more
+	details on usage.
+
 	On systems with Sub-NUMA Cluster (SNC) enabled there are extra
 	directories for each node (located within the "mon_L3_XX" directory
 	for the L3 cache they occupy). These are named "mon_sub_L3_YY"
-- 
2.48.1

