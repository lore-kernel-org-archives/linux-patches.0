Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81AD3FE34F
	for <patches@lists.linux.dev>; Wed, 29 Apr 2026 18:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777488573; cv=none; b=AUJkTJroUEB7M1Ro8vlCfj1/gCYk7EEXauZUsl26oQk6DV+QH7rm19P7cYz5i3eCJoDV3EWu/HlUVX7FmbZT0c4jetfrUO6Cf2ciqgQsFtV9j3gvAf4Jw4Isq5HW+kv1Zk3e1Kgdp0fLVnrAFLIL3DpVoJcoZQjmU2V9BJSoR2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777488573; c=relaxed/simple;
	bh=c/VrSfeRyK2BcOQRuAeB5sHUimURnt5DR1Uti5gcW34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfKQhsy3n9dVDiemrfaMQBF/Kxgm+XJgABj/FugKiV+D18eW4U9txbmPEtnpTPJCe9fALcJekmY8UqDAFGlC+/zgCdiFdVr4Hg2Y/ZKfm3W0uwHZs5meGTDLcgzoLboFPaQvwLMlfxrAXA3t3qQkOByQE1sAK8mo391qcLne55I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PHTHWIC8; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PHTHWIC8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777488567; x=1809024567;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c/VrSfeRyK2BcOQRuAeB5sHUimURnt5DR1Uti5gcW34=;
  b=PHTHWIC8JxSd/JrBGYdHCRJVmDH9ZxdWt35xPfDi50HxeycqBLyd4ghz
   /9GCqQM8l1ldbtn1G9xKd4363WyI6M4iL/7ClWs9KOFM22DIs0JCZumcb
   xuJPj/rTsoI1gXFxsmCfA+eVfJETk7NaOM4gBiMpC6/lmC0EEIfjNVJSn
   bLBdMf60ppJKHzoikP7tUhiKGky7FAUHHSO5NXsE8xgjdWXqHO/yQ0Cv9
   MQRSl67npEayLbQpSoetsL6QtF5d0gSxuvjyxpe60l1F3nGMTUCueAPO+
   nAI6J/PDcVT4l0T0h+HgZL5hdusNZl7n48mmchHIaiiYtPyeGWamnMYJI
   w==;
X-CSE-ConnectionGUID: seV0LDaxQ66fpikUeNPNhQ==
X-CSE-MsgGUID: Ho8I1YwqQ1G/cv+cnIOuYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="89890777"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="89890777"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:49:10 -0700
X-CSE-ConnectionGUID: MhSFXGywQWy7d0AZLeImiA==
X-CSE-MsgGUID: w+v6jscRQma4D0+WlIqQEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="238323053"
Received: from mjruhl-desk.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.13])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:49:09 -0700
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
Subject: [PATCH v6 10/10] Documentation/filesystems/resctrl: Add footnote for telemetry fstab mount caveat
Date: Wed, 29 Apr 2026 11:48:58 -0700
Message-ID: <20260429184858.36423-11-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429184858.36423-1-tony.luck@intel.com>
References: <20260429184858.36423-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a footnote to the 'If telemetry monitoring is enabled' sentence noting
that because PMT driver enumerates telemetry features asynchronously, an
automatic mount of resctrl from /etc/fstab at boot may occur before those
features are available, resulting in them not being enabled.

Assisted-by: Claude:Sonnet_4.6
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/filesystems/resctrl.rst | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index b003bed339fd..4e62b8c5e0d6 100644
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
+   enabled.
+
 "mon_hw_id":
 	Available only with debug option. The identifier used by hardware
 	for the monitor group. On x86 this is the RMID.
-- 
2.53.0

