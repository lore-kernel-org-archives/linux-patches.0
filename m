Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096033D7D8D
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 21:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782941772; cv=none; b=g8PAempPxErIpQV/jJPtHYrXjAyPwi1JXJxCFkgEwBPlTxDwAR7on5RR6ZWQSOoIWNtomtmNMPljurm5F7nIdMSO5R7TNUd3np9in8JVkJ66gtW4pOXO3OcRkcjQBoIpcZCmcKd1/JoWbrwXByBao9jTe9sl+PgYMX5Een5Eeto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782941772; c=relaxed/simple;
	bh=EnNNVhSKQJ1RnqGp0nStFHpfHGG4O1gg3+FPndB54NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZaJUtUjDMMFDzydrwG129vhH9pdvdY0q0tV6x1/Gspekgrxc+uW4ZWB6hnLhVQX/+jKxJ+FNLxnUpa0R++b2hZfh2obRhbAlfg3rrZnzJ7Fdb3wXXxCzBvxXM8mMLuJ88LxLQ0Afaf1i3buhlWLMiHMqAG931l7/x703owHCSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AXwLWrzK; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AXwLWrzK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782941771; x=1814477771;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EnNNVhSKQJ1RnqGp0nStFHpfHGG4O1gg3+FPndB54NQ=;
  b=AXwLWrzK4k2oRSbauv/7rRxKHbcmVK72XH6TSRp+d95efFZfivAb2JjJ
   6kECAq7eQPYwiRvZMOPld1Nx3rPs6fyejbfH6SAZRoPRcuGykLFolRCGU
   6JRrUCm7PjUhgBDTvT9hnBmHRosummn+ZPzyhVI22HqMq3zC4zrubdLxY
   AjkxlEJBduoFFSQg8ohdGBgdIR+c9whdwy7vX7gFXOwfWKCnN+vFVYGNP
   cGggLJJ2lub36d9BngVnOG2uEm/7Cx1gbPlI/PtUgklmkec1WzSPZpbkW
   0ZGVhiW01p/Zf1g8A/bXGAoVZ1r3Bi0dy6+dmV6Xka8N8NSGpdzQ4dOik
   A==;
X-CSE-ConnectionGUID: ASrxRdQdQi+NvEZncFRUdw==
X-CSE-MsgGUID: v9IzGglVTkSPoM1hRpeGbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11834"; a="94285850"
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="94285850"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:06 -0700
X-CSE-ConnectionGUID: OKzLnKZSRWaXDPDJSPDA6Q==
X-CSE-MsgGUID: 8H1jlqpxTlaObdFK3Uh2YA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="252242559"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.120])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:05 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v9 12/12] Documentation/filesystems/resctrl: Document telemetry mount timing caveat
Date: Wed,  1 Jul 2026 14:35:53 -0700
Message-ID: <20260701213553.15222-13-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260701213553.15222-1-tony.luck@intel.com>
References: <20260701213553.15222-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The PMT driver enumerates telemetry features asynchronously, so an
automatic mount of resctrl from /etc/fstab early in boot may occur before
those features are available, resulting in them not being enabled in the
mounted instance.

Add a footnote to the 'If telemetry monitoring is enabled' sentence
pointing readers to a new "Mounting resctrl with telemetry" section. That
section explains the race and provides example systemd service and udev
rule snippets that defer the mount until after the pmt_telemetry module
has loaded.

Assisted-by: Claude:Opus_4.7
Signed-off-by: Tony Luck <tony.luck@intel.com>
--
v9:
	Added section with example udev/systemd configuration
---
 Documentation/filesystems/resctrl.rst | 60 ++++++++++++++++++++++++++-
 1 file changed, 59 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index e4b66af55ffb..260a5eef675f 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -630,7 +630,7 @@ When monitoring is enabled all MON groups will also contain:
 	each instance of an L3 cache. Each directory contains files for the enabled
 	L3 events (e.g. "llc_occupancy", "mbm_total_bytes", and "mbm_local_bytes").
 
-	If telemetry monitoring is enabled, there will be a "mon_PERF_PKG_YY"
+	If telemetry monitoring is enabled [#]_, there will be a "mon_PERF_PKG_YY"
 	directory for each physical processor package. Each directory contains
 	files for the enabled telemetry events (e.g. "core_energy". "activity",
 	"uops_retired", etc.)
@@ -669,6 +669,10 @@ When monitoring is enabled all MON groups will also contain:
 	returned if the MBM event does not have an assigned counter in the
 	CTRL_MON group nor in any of its associated MON groups.
 
+.. [#] Telemetry features are enumerated asynchronously by the PMT driver, so
+   an automatic mount of resctrl from ``/etc/fstab`` at boot may not enable
+   them. See `Mounting resctrl with telemetry`_ below.
+
 "mon_hw_id":
 	Available only with debug option. The identifier used by hardware
 	for the monitor group. On x86 this is the RMID.
@@ -1898,6 +1902,60 @@ m. Unmount the resctrl filesystem.
 
   # umount /sys/fs/resctrl/
 
+Mounting resctrl with telemetry
+===============================
+
+Telemetry features (e.g. the ``mon_PERF_PKG_YY`` events) are enumerated
+asynchronously by the PMT driver. If resctrl is mounted before that
+enumeration completes - for example, when mounted automatically from
+``/etc/fstab`` early in boot - the telemetry features will not be available
+at mount time and will therefore not be enabled in the mounted instance.
+
+To avoid this race, defer the mount until after the ``pmt_telemetry`` module
+has loaded. One way to do this is with a udev rule that triggers a systemd
+service when the module appears. A tmpfs mount onto /sys/fs/resctrl is
+needed to prevent daemon tasks from obtaining references to the resctrl
+file system in the other name spaces that systemd uses during startup.
+
+Example systemd tmpfs mount service (``/etc/systemd/system/sys-fs-resctrl.mount``)::
+
+  [Unit]
+  Description=Early Resctrl Namespace Firewall
+  DefaultDependencies=no
+  Before=basic.target local-fs.target
+
+  [Mount]
+  What=tmpfs
+  Where=/sys/fs/resctrl
+  Type=tmpfs
+  Options=private,nosuid,nodev,noexec,mode=755
+
+  [Install]
+  WantedBy=sysinit.target
+
+Example systemd service (``/etc/systemd/system/mount-resctrl.service``)::
+
+  [Unit]
+  Description=Mount real resctrl pseudo-filesystem natively
+  DefaultDependencies=no
+  Requires=sys-fs-resctrl.mount
+  After=sys-fs-resctrl.mount
+
+  [Service]
+  Type=oneshot
+  # Pause to let systemd start daemons
+  ExecStart=/usr/bin/sleep 10
+  # Mount the real resctrl file system
+  ExecStart=/usr/bin/mount -t resctrl resctrl /sys/fs/resctrl
+  RemainAfterExit=no
+
+  [Install]
+  WantedBy=multi-user.target
+
+Example udev rule (``/etc/udev/rules.d/99-rmid-telemetry.rules``)::
+
+  SUBSYSTEM=="module", KERNEL=="pmt_telemetry", ACTION=="add", RUN+="/usr/bin/systemctl start mount-resctrl.service"
+
 Intel RDT Errata
 ================
 
-- 
2.54.0

