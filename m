Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3D3254845
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 23:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744069273; cv=none; b=Gs1BBqSHqNegsB4ZL7KTuC2VsQe7etiws5B8jXMGcv1fiKnjQIW1uX8gXkFYWFxVsVYCa8/FdBJ2orVw4yR2CAS4JNYYq1WsdQonWMfPrXKUaaq7x2Gt4jP/JOlY9ILoHhkUbjXo9QjMZp8MSOyYBH3nnvlB5ehnndJdTv0YWEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744069273; c=relaxed/simple;
	bh=yr5nHpaopd1NZz+g077gSUSbgIi4RWyZKVBYkSkwieQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dcm+GRnU6utq7IQ8+MpxLCb1c5S/gi8MmuIj2Ry/t+O51pUNusNW6Brm4eBJw9hBzuQ/ydjF6UxPitlUinDAUg3u1VGYAkLHDXnlWyGWcNN4nuLYFyRZ5HWXbqSXaCxK/5y3GCpXunYNrTiR0tg5PJo6OzksZJ+oqVRfhNTkHtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hZsM/JRZ; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hZsM/JRZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744069269; x=1775605269;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yr5nHpaopd1NZz+g077gSUSbgIi4RWyZKVBYkSkwieQ=;
  b=hZsM/JRZRge1LbFT1CjSgcUOwVj13lsDWtEGrwrgmFEc9EcM8DAn2lh5
   G54c1Ti87Lmevg9U+ufL4Z3B0JJ61RTZFVHWljMuEUhYZwKyWHSY2Qxhu
   5EN/ueAhP4BOZDL+wMl1zUuxFY7HDqeNCRIGCNwJG3fBYjfeoIROozrRU
   s/M7lFxjLnhLkZUHpayFUwmHD4pTvGTS/b845Y5kjnJNab1j2Kud6fJvm
   /kGEjL3IlDkFcukrWn4/WcdhoArhjJSghQPrs6JgtQsZhqCGPaRwe7nmQ
   aTJfAlB7bTuqlvdjys0lfwlrouz6Nwa9KHBW4m4oJ9UZji1jRu2OdzfYo
   A==;
X-CSE-ConnectionGUID: w9qwCMpGT+y86pKpQBezSg==
X-CSE-MsgGUID: aDejkW/3RwmUc7yyB3V5HQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="48193307"
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="48193307"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:59 -0700
X-CSE-ConnectionGUID: g6//5lGvSuqmbgGvUV8Onw==
X-CSE-MsgGUID: pFmv8TNbTkaH0x04cfURpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="165315535"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:58 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 26/26] x86/resctrl: Update Documentation for package events
Date: Mon,  7 Apr 2025 16:40:28 -0700
Message-ID: <20250407234032.241215-27-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250407234032.241215-1-tony.luck@intel.com>
References: <20250407234032.241215-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Each "mon_data" directory is now divided between L3 events and package
events.

The "info/PERF_PKG_MON" directory contains parameters for perf events.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/filesystems/resctrl.rst | 38 ++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 6768fc1fad16..b89a188b0321 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -167,7 +167,7 @@ with respect to allocation:
 			bandwidth percentages are directly applied to
 			the threads running on the core
 
-If RDT monitoring is available there will be an "L3_MON" directory
+If RDT L3 monitoring is available there will be an "L3_MON" directory
 with the following files:
 
 "num_rmids":
@@ -261,6 +261,17 @@ with the following files:
 		bytes) at which a previously used LLC_occupancy
 		counter can be considered for re-use.
 
+If RDT PERF monitoring is available there will be an "L3_PERF_PKG" directory
+with the following files:
+
+"num_rmids":
+		The guaranteed number of hardware countes supporting RMIDs.
+		If more "CTRL_MON" + "MON" groups than this number are created,
+		the system may report that counters are "unavailable" when read.
+
+"mon_features":
+		Lists the perf monitoring events that are enabled on this system.
+
 Finally, in the top level of the "info" directory there is a file
 named "last_cmd_status". This is reset with every "command" issued
 via the file system (making new directories or writing to any of the
@@ -366,15 +377,22 @@ When control is enabled all CTRL_MON groups will also contain:
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
+	package directories "mon_PERF_PKG_00", "mon_PERF_PKG_01" etc.
+
+	Within each directory there is one file per event. In
+	the L3 directories: "llc_occupancy", "mbm_total_bytes",
+	and "mbm_local_bytes".	In the PERF_PKG directories: "core_energy",
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

