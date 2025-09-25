Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270BC328564
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 20:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758830669; cv=none; b=tyQpj9ZR7qpx6GLpIy7cH6Ko9kOmB7yNYvaUNn2B0KFFyXr78B+nKZVZDY1nhJJxTU7Tle0OkWs506yU03MKTPi3Z5NIojhUoqBemLb55taw6I8H08qvqOkMSVzgafmAHHm+a0pMeI4ZJRuLwzGnkNWzM1LvbVzpxYPzaVCyADY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758830669; c=relaxed/simple;
	bh=GTDzyftXvBl8MpKeSXIIhicwNVfPwqh8GuSLto2mY4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXUU60Nr7WJx7KVBSu2a+ZWVnTViC63UEoJgdES3wgBk46l7Rw+wPfKU4uccJBlrA9ISbU/60A70Hv+hEXWYelaHuiVbTFeo/NqwcQ4pNTg9Rm9ssYjlXKS72QS6bIk6QhXLjYNb5ZpkvFbxssE1eRKrukQ2O16w5ns/gZXvFBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UB00AgtV; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UB00AgtV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758830668; x=1790366668;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GTDzyftXvBl8MpKeSXIIhicwNVfPwqh8GuSLto2mY4k=;
  b=UB00AgtVGG1Ij5DsrUX9gENCGBXFVlhJpXGfSH2EdTj79KueagvAxkFl
   WD2ZZ3YPN8aHKVEhR0k+h1eNoVhsInM7BnKaA2NHRj4CzQHGTyLnWDY5Q
   2M3Gp4EKK8lMScNlAnQrDofcVmZE/Os7RjjVQxNdsGij5X7ebuGOe9JYO
   uqKGYvn8Z9Sp6qqKTL4QeNrszkYolqgdriExrtwOOiqC9A/QEQVmc996t
   YvmDSabYZStDuhZ//CsxsNvIYBJLnObtdsAga0sGxq1sRv+yQiM3lM1CF
   0ziPgTxjZJlu4JKpPUI0kSGISe774mgkUop/MmzN1IAZ8hbf2MSDgZs0n
   Q==;
X-CSE-ConnectionGUID: Nt6p0VwIQdKXBNueLpCsCQ==
X-CSE-MsgGUID: QC4PeXckSlWp6l1R6sUlPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61074404"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61074404"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:16 -0700
X-CSE-ConnectionGUID: 131bugDMR2O3RoYVfQTXDA==
X-CSE-MsgGUID: vM1dP+P6RW2K3Eoa/a++BA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177003709"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.206])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:16 -0700
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
Subject: [PATCH v11 30/31] x86,fs/resctrl: Update Documentation for package events
Date: Thu, 25 Sep 2025 13:03:24 -0700
Message-ID: <20250925200328.64155-31-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925200328.64155-1-tony.luck@intel.com>
References: <20250925200328.64155-1-tony.luck@intel.com>
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
 Documentation/filesystems/resctrl.rst | 100 ++++++++++++++++++++++----
 1 file changed, 87 insertions(+), 13 deletions(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 006d23af66e1..cb6da9614f58 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -168,13 +168,12 @@ with respect to allocation:
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
@@ -400,6 +399,19 @@ with the following files:
 		bytes) at which a previously used LLC_occupancy
 		counter can be considered for re-use.
 
+If telemetry monitoring is available there will be an "PERF_PKG_MON" directory
+with the following files:
+
+"num_rmids":
+		The number of RMIDs supported by hardware for
+		telemetry monitoring events.
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
@@ -505,15 +517,40 @@ When control is enabled all CTRL_MON groups will also contain:
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
+	This contains directories for each monitor domain. One set for
+	each instance of an L3 cache, another set for each processor
+	package. The L3 cache directories are named "mon_L3_00",
+	"mon_L3_01" etc. The package directories "mon_PERF_PKG_00",
+	"mon_PERF_PKG_01" etc.
+
+	Within each directory there is one file per event. For
+	example the L3 directories may contain "llc_occupancy", "mbm_total_bytes",
+	and "mbm_local_bytes". The PERF_PKG directories may contain "core_energy",
+	"activity", etc. The info/`*`/mon_features files provide the full
+	list of event/file names.
+
+	"core energy" reports a floating point number for the energy (in Joules)
+	consumed by cores (registers, arithmetic units, TLB and L1/L2 caches)
+	during execution of instructions summed across all logical CPUs on a
+	package for the current RMID.
+
+	"activity" also reports a floating point value (in Farads).
+	This provides an estimate of work done independent of the
+	frequency that the CPUs used for execution.
+
+	Note that these two counters only measure energy/activity
+	in the "core" of the CPU (arithmetic units, TLB, L1 and L2
+	caches, etc.). They do not include L3 cache, memory, I/O
+	devices etc.
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
@@ -1506,6 +1543,43 @@ Example with C::
     resctrl_release_lock(fd);
   }
 
+Debugfs
+=======
+In addition to the use of debugfs for tracing of pseudo-locking
+performance, architecture code may create debugfs directories
+associated with monitoring features for a specific resource.
+
+The full pathname for these is in the form:
+
+    /sys/kernel/debug/resctrl/info/{resource_name}_MON/{arch}/
+
+The presence, names, and format of these files may vary
+between architectures even if the same resource is present.
+
+PERF_PKG_MON/x86_64
+-------------------
+Three files are present per telemetry aggregator instance
+that show status.  The prefix of
+each file name describes the type ("energy" or "perf") which
+processor package it belongs to, and the instance number of
+the aggregator. For example: "energy_pkg1_agg2".
+
+The suffix describes which data is reported in the file and
+is one of:
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
2.51.0

