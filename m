Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F9737702A
	for <patches@lists.linux.dev>; Mon, 15 Jun 2026 18:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781547921; cv=none; b=gEk8PreCCbO3/uA5fWp3qpozLFzYv+y9dO19WZPDDLqdTfa/8ffIKuQNYtKqlNOQgOcU+GgezL0U+w/0rkedMbF6KmxueoSKR780W4AmihHGpPbeihQlBUiNT6wOvO2aZrPhZTujloGcLe0q3RgtgU/cmBD5mMR/krj3mPEVztw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781547921; c=relaxed/simple;
	bh=lxsJCR217OWgpTb9kVFpj4zf+6hJpTyAdiR9fIcpXPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8QKPs5pzGHU2RXGW4cuFLFXh5j5je75TxDg8Qm7OZNs26b3Jy4EGIBE38aXUm7tB3YbysMy5yyo4JHO9VXI6Z5YZSfVpiMuMiQ7yYJ0asDuUM4ms9NqEvnefJmumiMxiqc6Evx1bvVY42RHkruo3OmaPnR0Od0jt2d1Rn3QV+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ma1R/VQH; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ma1R/VQH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781547920; x=1813083920;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lxsJCR217OWgpTb9kVFpj4zf+6hJpTyAdiR9fIcpXPU=;
  b=ma1R/VQH1Gmg5fhaX4Q/mv8L7R6Qz8ME8LFdoQzgW1YZGFyq7yF5oU35
   WEsjrruHVzXRAymicMnsFbwIC9hVtj8pUwhoTmzT1Z7d/IKACNK9ZTgqv
   Xej4lLv6VI/qMqtOuLwDmGLFrvATjq6FY9afJ76m3gUBPENT1HjurwDju
   ldShbrz/5KA2S7+wdBDI85HYmv1DDJK2zj+C0UG/sCFFV3X2jhO1lXPo6
   3vnMazs1nVRrZGRIKvd6SNgTVojeOIqgbUwthAZ4Ybn2Dy1BwL6cdNGPT
   0BfEltvadQrwG4J/ttA+gUkbllbZiGY9RbCbHH7O8VsjnPRpdRJHSl2Aa
   g==;
X-CSE-ConnectionGUID: 603dkJftTaGcaMX3isekUg==
X-CSE-MsgGUID: v3hbw9+eRHOXN7whFx41rg==
X-IronPort-AV: E=McAfee;i="6800,10657,11818"; a="93790066"
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="93790066"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:13 -0700
X-CSE-ConnectionGUID: UusTBMzJSx6RN6k8E3muKA==
X-CSE-MsgGUID: 2DP7jZJGTA6t4ix/TPiR5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="247620670"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.121])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:13 -0700
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
Subject: [PATCH v8 16/16] Documentation/filesystems/resctrl: Add footnote for telemetry fstab mount caveat
Date: Mon, 15 Jun 2026 11:24:57 -0700
Message-ID: <20260615182457.14725-17-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260615182457.14725-1-tony.luck@intel.com>
References: <20260615182457.14725-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a footnote to the 'If telemetry monitoring is enabled' sentence noting
that the PMT driver enumerates telemetry features asynchronously, so an
automatic mount of resctrl from /etc/fstab at boot may occur before those
features are available, resulting in them not being enabled.

The time for enumeration is only a few seconds, so retrying the remount
should work.

Assisted-by: Claude:Sonnet_4.6
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v8:
	Added to footnote that a remount should fix

 Documentation/filesystems/resctrl.rst | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index b003bed339fd..942194beebc8 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -620,7 +620,7 @@ When monitoring is enabled all MON groups will also contain:
 	each instance of an L3 cache. Each directory contains files for the enabled
 	L3 events (e.g. "llc_occupancy", "mbm_total_bytes", and "mbm_local_bytes").
 
-	If telemetry monitoring is enabled, there will be a "mon_PERF_PKG_YY"
+	If telemetry monitoring is enabled [#]_, there will be a "mon_PERF_PKG_YY"
 	directory for each physical processor package. Each directory contains
 	files for the enabled telemetry events (e.g. "core_energy". "activity",
 	"uops_retired", etc.)
@@ -659,6 +659,11 @@ When monitoring is enabled all MON groups will also contain:
 	returned if the MBM event does not have an assigned counter in the
 	CTRL_MON group nor in any of its associated MON groups.
 
+.. [#] Telemetry features are enumerated asynchronously by the PMT driver. If
+   resctrl is automatically mounted from ``/etc/fstab`` at boot, the telemetry
+   features may not yet be available at mount time and will therefore not be
+   enabled. Remounting a few seconds later should fix this.
+
 "mon_hw_id":
 	Available only with debug option. The identifier used by hardware
 	for the monitor group. On x86 this is the RMID.
-- 
2.54.0

