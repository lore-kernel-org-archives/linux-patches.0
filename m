Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8117130F523
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 22:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394863; cv=none; b=f4xSLkvBThbLCWVDwx4gxtM1LboauImjgAJdWWdcKXgYn+U7ILrzFe0b6jWXo1NMxCa+J9id3zsf7A431o3zTVSNoz2ZuoBwaxRaQerxigyUMFmsfXeyo6LpnFAx2mfSK35+wAEwWagrnNp4Tw4NDvV/+EcdFv/6CPMIwc2sE3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394863; c=relaxed/simple;
	bh=3RWvTnQSEkux+jTameRPS1qJv6hGBV+LzBX5eUtRyXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgwcKTp81trka8hidj6V42Ob7idS8p8QaDZkwFcTdjTHnpf9LTA7rGS58nl0xrpJqA/inE4+B9lIakxJBXwD0RtA9Ntqe+18RRsAuUknBds25IMOQLb6Lgx4Etef54Dyc5qC/6qQ3H7ixdhMSH67hp+ACnlgVBHfY2pZBwaXtnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CbZORJTl; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CbZORJTl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760394861; x=1791930861;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3RWvTnQSEkux+jTameRPS1qJv6hGBV+LzBX5eUtRyXE=;
  b=CbZORJTlnc0ldfuQ1D6HZ3RgRZ44DHo2qWf6dJU0Y9sopEPaP43tIofa
   TGCifuTdsSHXhiruDr0PqavSNjZzS6WnEa0SxHJ2PB2XHxeO79Z73OzHq
   fO4gD0Vden7OMiJcP/JtHGriAK93Noph3xVwFh3eqpuwUxjiuRFtxULsU
   y0tRx25XiTNd6CAfbOtpAM7dBGnmPwkkPrKk5fhBo+YFX1xrL1VmfPeXg
   bVneuNNvm4dJGhd5nedliSJPATCJHCcBCFr/7WKCBq2UDame/veNjH9ee
   nA1v6e+kBHsaTWy/sA0HcYJdGJyDvLiLDyWoSvUJ+hIm20aH9I4aNbOLX
   w==;
X-CSE-ConnectionGUID: W7UYyvs7TtGTDsC98KF+pg==
X-CSE-MsgGUID: syqMxgd2QJmE7+WEp58GAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="85168973"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="85168973"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:04 -0700
X-CSE-ConnectionGUID: anHY2+bURe6Xzfg7m7P5VQ==
X-CSE-MsgGUID: 1G8zSumoR7qD3Y1SJvLmbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="182145348"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.79])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:04 -0700
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
Subject: [PATCH v12 31/31] x86,fs/resctrl: Update documentation for telemetry events
Date: Mon, 13 Oct 2025 15:33:45 -0700
Message-ID: <20251013223348.103390-32-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013223348.103390-1-tony.luck@intel.com>
References: <20251013223348.103390-1-tony.luck@intel.com>
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
index b7f35b07876a..5e4a5d4bbe9b 100644
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
@@ -400,6 +399,24 @@ with the following files:
 		bytes) at which a previously used LLC_occupancy
 		counter can be considered for re-use.
 
+If telemetry monitoring is available there will be an "PERF_PKG_MON" directory
+with the following files:
+
+"num_rmids":
+		The number of RMIDs for telemetry monitoring events. By default,
+		resctrl will not enable telemetry events of a particular type
+		("perf" or "energy") if the number of RMIDs supported is lower
+		than the number of RMIDs supported by the system. The user can
+		force-enable each type of telemetry events with the "rdt=" boot
+		command line option, but this will reduce the number of "MON"
+		groups that can be created.
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
@@ -505,15 +522,40 @@ When control is enabled all CTRL_MON groups will also contain:
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
+	package for the current RMID.
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
@@ -1506,6 +1548,42 @@ Example with C::
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
+The prefix of each file name describes the type ("energy" or "perf") which
+processor package it belongs to, and the instance number of the aggregator.
+For example: "energy_pkg1_agg2".
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

