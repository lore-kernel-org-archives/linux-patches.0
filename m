Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001AB24BBFF
	for <patches@lists.linux.dev>; Wed, 21 May 2025 22:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867878; cv=none; b=bMRchKRNC7Jip2MOtIF1WrSX8hu7iPG9gS7MB4Dvj0coCBQW6U6s6LC1J15xe99PvRfudfhX4Fcl9kgHwDXPwMarxN3jJuFyo6E/DRq9O/hzsuVVfcItiotsZsxI/lDcYhsyAlPi8ez/kTGqvm1gbqbPXxmJsCtMUzDmgxfs0Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867878; c=relaxed/simple;
	bh=/krivHDJi4SFWsGi67ebg0mEW1Vx99a74/Iz9fin3WI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVj5GkUZM6Y+1TezQyscfKLoJNu5omvttP6c7N6Mf+95/kBUvOBkt2Ryv3aooTw+goh0vBl3W/CeL6iujTK6ocQnS68ah8obQDhvvwfeOInjBYG2hA16s8eDpdEn+gzQrX8lbJWO381qrC9VPmPDoOpJN0WDiHheJoKGQ+Ae9+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EQME42ek; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EQME42ek"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747867876; x=1779403876;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/krivHDJi4SFWsGi67ebg0mEW1Vx99a74/Iz9fin3WI=;
  b=EQME42ek3ErWjRQcvSPUjSEbxdAjGbwZQF/WPe/oCIwxcIgwOD3b//wM
   ZJ5aQ7/Af4ZCUiuuXEcwmzpkazzaT+f2Vp8yFeXCtxHf0ORiB8dHY+sGG
   LdAboBzpxs/hKtmQb2D6FCAnToh+eMeXr9ueNSlrrrfsKOo/6npewBVs6
   PNQmBW+f7RmgKI7r0JxGZXjEsDbYXyHmFnkrOHZI9LuDKulVwq6bd7VAA
   DVPxKJGKpOQsOlmBic94Ai3GYY3OYrRRzZPcydoX6Gyb8CIWj2rC5Cbxk
   yVN2C5rSwjYN1fVt/G/AtrfrscDtOdbltQWr5OZ9Dx3TQwI70B9+Wi1jZ
   A==;
X-CSE-ConnectionGUID: e1wuD011QUOBn0kvJi+HcQ==
X-CSE-MsgGUID: x99G7nz1TIO8OauZUqQ1QA==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="53677838"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="53677838"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:51:00 -0700
X-CSE-ConnectionGUID: tfRJrB6qQY6jUplilk01Uw==
X-CSE-MsgGUID: W+qKfc4lQxCn8z6+DovZNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="141352212"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:51:00 -0700
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
Subject: [PATCH v5 29/29] x86/resctrl: Update Documentation for package events
Date: Wed, 21 May 2025 15:50:47 -0700
Message-ID: <20250521225049.132551-30-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521225049.132551-1-tony.luck@intel.com>
References: <20250521225049.132551-1-tony.luck@intel.com>
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
 Documentation/filesystems/resctrl.rst | 53 ++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 10 deletions(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index c7949dd44f2f..a452fd54b3ae 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -167,7 +167,7 @@ with respect to allocation:
 			bandwidth percentages are directly applied to
 			the threads running on the core
 
-If RDT monitoring is available there will be an "L3_MON" directory
+If L3 monitoring is available there will be an "L3_MON" directory
 with the following files:
 
 "num_rmids":
@@ -261,6 +261,23 @@ with the following files:
 		bytes) at which a previously used LLC_occupancy
 		counter can be considered for re-use.
 
+If telemetry monitoring is available there will be an "PERF_PKG_MON" directory
+with the following files:
+
+"num_rmids":
+		The number of telemetry RMIDs supported. If this is different
+		from the number reported in the L3_MON directory the limit
+		on the number of "CTRL_MON" + "MON" directories is the
+		minimum of the values.
+
+"mon_features":
+		Lists the telemetry monitoring events that are enabled on this system.
+
+When the filesystem is mounted with the debug option each subdirectory
+for a monitor resource of the "info" directory will contain a "status"
+file. Resources may use this to supply debug information about the status
+of the hardware implementing the resource.
+
 Finally, in the top level of the "info" directory there is a file
 named "last_cmd_status". This is reset with every "command" issued
 via the file system (making new directories or writing to any of the
@@ -366,15 +383,31 @@ When control is enabled all CTRL_MON groups will also contain:
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
+	and "mbm_local_bytes". In the PERF_PKG directories: "core_energy",
+	"activity", etc.
+
+	"core_energy" reports a floating point number for the energy
+	(in Joules) used by cores for each RMID.
+
+	"activity" also reports a floating point value (in Farads).
+	This provides an estimate of work done independent of the
+	frequency that the cores used for execution.
+
+	All other events report decimal integer values.
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
2.49.0

