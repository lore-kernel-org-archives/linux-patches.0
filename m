Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B79480328
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 17:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198293; cv=none; b=TXMyBBTvaS7SMTahvouz6sb1F8aODSp92EbAY/kFro02j5/JqrIGt0aBTkWHy+o1oRNBkyp45oXFoX7vjYr9UeMlmABc5+RDN99vqyBGZ5gr97uy2mO01nUB4oOTIBgME9g0ga/BB98cf7pEjpmNRL7pt4w6+iMns1YkVfuH8wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198293; c=relaxed/simple;
	bh=mGH2TZt4HJM2wnl6CUjWUa/L01tsJgf/l5Hdr1T2Sqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZvNugXZv23snRXWRSQZ2Xfjk8U76fZh4H+UK1m2teipt4FiPIcKL23BEqtssnRK6L2U49/8UMcKsvKpjudiexxvRYXRqsVj9P3BzXU+Tnb0LJnZekhc2u9IG3UTUoSyL2h8A81nqDezCGfoZshK/LbnNL8w4als+cJsxPQKY40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MhhAZpoJ; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MhhAZpoJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788198291; x=1819734291;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mGH2TZt4HJM2wnl6CUjWUa/L01tsJgf/l5Hdr1T2Sqk=;
  b=MhhAZpoJ1E9h1R4vAAN00TGkZlfg8K+Zj3+VcWtImU6hSVPfPkFBWXow
   aZ9A8dR7L7r71r89PefFuxzTL55xeu2dZsHg+iWNXgICpqUzgzEACB9ly
   vSMJiifTfNQP4R58e6sJjG/ostT9HDtsdR0To8q/ipFPd/l5F1sT2JRaN
   1Dro5BT/GoMhYkkR08el0OgvFGN8qVK4DlS22ME4ewAk4ZYI1SSDES9VR
   mL1Atz9h/C4sfYRMMsM4+I9pDDNV3HqX6MD9r/Re2lLw+4j5h1JhbGHVg
   6JfJ8/o/pCBYCvOWAmnUjErMex0w4vRNVEdpLWKOp1skiVhQGPM3iMgUL
   A==;
X-CSE-ConnectionGUID: gl8oJJuHSBi/Klj5HqgUpQ==
X-CSE-MsgGUID: 5xXux8PAQsqlrO8Nb5T6BA==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="92480132"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="92480132"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:44 -0700
X-CSE-ConnectionGUID: YhYZVqyYS8+WxjTm1gCN6Q==
X-CSE-MsgGUID: M0EIs1UjQdqxftloFnRH/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="268907035"
Received: from aherrold-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.17])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:43 -0700
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
Subject: [PATCH v11 23/23] x86/resctrl: Document telemetry mount timing caveat
Date: Mon, 31 Aug 2026 10:44:21 -0700
Message-ID: <20260831174421.13921-24-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831174421.13921-1-tony.luck@intel.com>
References: <20260831174421.13921-1-tony.luck@intel.com>
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
---
v11:
	No change

 Documentation/filesystems/resctrl.rst | 60 ++++++++++++++++++++++++++-
 1 file changed, 59 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index e4b66af55ffb..e34910ac589c 100644
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
+service when the module appears. A tmpfs mount onto ``/sys/fs/resctrl`` is
+needed to prevent daemon tasks from obtaining references to the resctrl
+file system in the other namespaces that systemd uses during startup.
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
+  # Pause to let systemd start daemons (delay may need per-system tuning)
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
2.55.0

