Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6469532D433
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 20:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764881689; cv=none; b=qBRsOzWZqiJxCwH2WqgurC1+k7cEgrlDNC0qxtW9LQl4Fd+n4UaSHL021clhyqgCBOuDMlI/VQQLDt3DjBZcZYSmlCtkoLguOHfW89Nxr5Ga7pvw6BM2ZHQRcH3uFsAaVBicFXqBhVET+X9EznDEiSuzuyEG3HiC1HcreEvmrAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764881689; c=relaxed/simple;
	bh=Zb42NFH4f2rjklwZ01XPhH0/lWBFTrR4cuGDvYQslxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KomTy0vVD9dQU69oSYFBR7hy/IbhU42StMTULcr0XUAVxLFZ9a3xsF1JcAyWpidep1q6ImoxLMart3MsV54+DWv2yt4N5aK2CG3QowVhMJL+KXqJUmYaAAPfO47RLYckV+YwYKtA5QGR+5Ul/65w3LJJPq6VpXIQdNQwBPg6ChU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OfWBcLO6; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OfWBcLO6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764881687; x=1796417687;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zb42NFH4f2rjklwZ01XPhH0/lWBFTrR4cuGDvYQslxU=;
  b=OfWBcLO6XNbaQ8W7IOoat9QfatMmbhgqcIzMmVCjyXp1A3x1E5lG3Vc3
   paWOIfoXb7sDcqYy3YTvekYso/QF8KWFQHXH44tubQFntsLbTe1uk+zoF
   Qj2/Lu5ik3wVWfiexgsflt911QcSqYvP0/UjE1QROC5Hu1CQ2t7LPZG6/
   X6NVRAdJ6i53gDyokTtHUm4XWKHRsFeJ4hpcU8j5CxhwxhHL6cV9QqSYc
   ooLxAGoACloykxy2vqIXrK4u1RufY7PHGjwFhM2j6LKDk93uZhFClwrp/
   jj0soxABqY1eTNYosf5pMW7agAkexd82TfwZ+BfSx5K5EyPOkaNlZSxSX
   A==;
X-CSE-ConnectionGUID: 7lsRRUfRRJ+phI5jokRNZw==
X-CSE-MsgGUID: vogXF79BTxKD4G2Q1rj0qA==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="69511119"
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="69511119"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:35 -0800
X-CSE-ConnectionGUID: nFzSkxhsQVWuvAeM3IEnmA==
X-CSE-MsgGUID: WXny7BQmQAmIxHAhalsmmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="225752908"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.165])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:34 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v15 32/32] x86,fs/resctrl: Update documentation for telemetry events
Date: Thu,  4 Dec 2025 12:54:02 -0800
Message-ID: <20251204205404.12763-33-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251204205404.12763-1-tony.luck@intel.com>
References: <20251204205404.12763-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update resctrl filesystem documentation with the details about the
resctrl files that support telemetry events.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/filesystems/resctrl.rst | 102 +++++++++++++++++++++++---
 1 file changed, 90 insertions(+), 12 deletions(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 8c8ce678148a..5418ca72bed3 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -252,13 +252,12 @@ with respect to allocation:
 			bandwidth percentages are directly applied to
 			the threads running on the core
 
-If RDT monitoring is available there will be an "L3_MON" directory
+If L3 monitoring is available there will be an "L3_MON" directory
 with the following files:
 
 "num_rmids":
-		The number of RMIDs available. This is the
-		upper bound for how many "CTRL_MON" + "MON"
-		groups can be created.
+		The number of RMIDs supported by hardware for
+		L3 monitoring events.
 
 "mon_features":
 		Lists the monitoring events if
@@ -484,6 +483,25 @@ with the following files:
 		bytes) at which a previously used LLC_occupancy
 		counter can be considered for re-use.
 
+If telemetry monitoring is available there will be a "PERF_PKG_MON" directory
+with the following files:
+
+"num_rmids":
+		The number of RMIDs for telemetry monitoring events. By default,
+		resctrl will not enable telemetry events of a particular type
+		("perf" or "energy") if the number of RMIDs that can be tracked
+		concurrently for that type is lower than the total number of
+		RMIDs supported by that type. The user can force-enable each
+		type (or individual guids within a type) of telemetry events
+		with the "rdt=" boot command line option, but this may reduce
+		the number of monitoring groups that can be created.
+
+"mon_features":
+		Lists the telemetry monitoring events that are enabled on this system.
+
+The upper bound for how many "CTRL_MON" + "MON" can be created
+is the smaller of the L3_MON and PERF_PKG_MON "num_rmids" values.
+
 Finally, in the top level of the "info" directory there is a file
 named "last_cmd_status". This is reset with every "command" issued
 via the file system (making new directories or writing to any of the
@@ -589,15 +607,40 @@ When control is enabled all CTRL_MON groups will also contain:
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
+	This contains directories for each monitor domain.
+
+	If L3 monitoring is enabled, there will be a "mon_L3_XX" directory for
+	each instance of an L3 cache. Each directory contains files for the enabled
+	L3 events (e.g. "llc_occupancy", "mbm_total_bytes", and "mbm_local_bytes").
+
+	If telemetry monitoring is enabled, there will be a "mon_PERF_PKG_YY"
+	directory for each physical processor package. Each directory contains
+	files for the enabled telemetry events (e.g. "core_energy". "activity",
+	"uops_retired", etc.)
+
+	The info/`*`/mon_features files provide the full list of enabled
+	event/file names.
+
+	"core energy" reports a floating point number for the energy (in Joules)
+	consumed by cores (registers, arithmetic units, TLB and L1/L2 caches)
+	during execution of instructions summed across all logical CPUs on a
+	package for the current monitoring group.
+
+	"activity" also reports a floating point value (in Farads).  This provides
+	an estimate of work done independent of the frequency that the CPUs used
+	for execution.
+
+	Note that "core energy" and "activity" only measure energy/activity in the
+	"core" of the CPU (arithmetic units, TLB, L1 and L2 caches, etc.). They
+	do not include L3 cache, memory, I/O devices etc.
+
+	All other events report decimal integer values.
+
+	In a MON group these files provide a read out of the current value of
+	the event for all tasks in the group. In CTRL_MON groups these files
+	provide the sum for all tasks in the CTRL_MON group and all tasks in
 	MON groups. Please see example section for more details on usage.
+
 	On systems with Sub-NUMA Cluster (SNC) enabled there are extra
 	directories for each node (located within the "mon_L3_XX" directory
 	for the L3 cache they occupy). These are named "mon_sub_L3_YY"
@@ -1590,6 +1633,41 @@ Example with C::
     resctrl_release_lock(fd);
   }
 
+Debugfs
+=======
+In addition to the use of debugfs for tracing of pseudo-locking performance,
+architecture code may create debugfs directories associated with monitoring
+features for a specific resource.
+
+The full pathname for these is in the form:
+
+    /sys/kernel/debug/resctrl/info/{resource_name}_MON/{arch}/
+
+The presence, names, and format of these files may vary between architectures
+even if the same resource is present.
+
+PERF_PKG_MON/x86_64
+-------------------
+Three files are present per telemetry aggregator instance that show status.
+The prefix of each file name describes the type ("energy" or "perf"), the
+guid, which processor package it belongs to, and the instance number of the
+aggregator.  For example: "energy_0x26696143_pkg1_agg2".
+
+The suffix describes which data is reported in the file and is one of:
+
+data_loss_count:
+	This counts the number of times that this aggregator
+	failed to accumulate a counter value supplied by a CPU.
+
+data_loss_timestamp:
+	This is a "timestamp" from a free running 25MHz uncore
+	timer indicating when the most recent data loss occurred.
+
+last_update_timestamp:
+	Another 25MHz timestamp indicating when the
+	most recent counter update was successfully applied.
+
+
 Examples for RDT Monitoring along with allocation usage
 =======================================================
 Reading monitored data
-- 
2.51.1

