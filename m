Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792443074;
	b=0ghtx3edVNIPghk1NGw+hFaM8SD3V8VWpL8pgOlhkr4two/sYLAhZt0tvVQI8kuN4d6V
	 cyCwE+srOnvPcAMj7k5a64Dxz6aAiNgQTzVd3IYaQjxMugBC7mzhdLqOSTg5uMXzaDipa
	 w/MnuCBtktShtq8Vmmn9ckjKqh1TJUyxYxc81Edk1is9kv16IBhUODZcjvCc9/96VuBC7
	 xG8QRGVvznFiaOp0yQLVq+zNwvwMAB1FryD7CfUynubtqtt/SjFn438qhYzVue5flCnIU
	 uBLhd7JqMGTzLPIitPf3nqpZ2pnMp3iCHh47ACcavJwENzBOiK92I01JKBtZa9EEmnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792443074;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3AAjvZIRWiQW+gK3vnNy9D2avRnjF9IaCmrvGUbt8AE=;
	b=ihG7PzrYenzugaA5BTVvG0zQ1EvjV5x5pOhiCs14/vyf1kplNYdK2gMsdMATZFNoPZjK
	 hfpqM7o342UWe4++NI3dc5f+qgat3qv3kyze5/WeTz0lYk8GTb+M3gHFtRGX+ujizOCie
	 lDRfNLqqzAunk2XMTwCZp2kaEJ1zrfBPLuzh3bjnhpuG36SjYq/nM7yoFjzcsFF0x2TCi
	 gQZI4XzhhP5V2I//qjGZtPi+p74b7hWrO4u4hH4kBb9rBMtqyDqJ3pKIFXp2PmzA+nVIs
	 vQKkgugFpPWdM8W2KnsYuaauE99xnDbXyq7Qn/J3FLQ6ag4jlWeSNxfDmy2TMdJ26Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=MQ94VrRr;
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E4260A4AF7
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 20:51:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85E4260A4AF7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=MQ94VrRr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792443073; x=1823979073;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ioWPp4jOIpND+/d8HJaRuiW2367Lq4ZEumGCYHGbrqA=;
  b=MQ94VrRr5LGb6QY1NfJevEnCBExWnvUEfU2ypt6eEL8Cge/0Yv2laZNs
   uj3TH+k77oaW/MIKN7Ef21CxEOa5bjLBt7Xwj+HEdrmYJ4JH4zz8m5o0t
   JSblpWYJFTr1zmGOizpPmQtq6LM/rqkMzdsANQxfS2slMjGBTZOEnWTVG
   9X5mHyMSZAUnA4x98CTjVBgGXhGf0EVJmLOmcytlcnIYvZxH0NvUad6yq
   9cwGirWJf7y/2fe3w5OS2qNiGh8qciRs6Sec8Z8FmalrXGE2i6IXoo3vx
   z8sgyfsDYFwdx7oLqp4DDA3mhP2kArcEpRfdCDhMEVIC6Xp7gDmcsmvkw
   g==;
X-CSE-ConnectionGUID: rn4iEf1SSWClSaP0M/MfCw==
X-CSE-MsgGUID: gCP+iEzORkOqDlJgomnP3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1131320"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1131320"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:52 -0700
X-CSE-ConnectionGUID: GyssZcrpS2aWKlQBZaowWg==
X-CSE-MsgGUID: wqJ0RreiQiCIsSffauJ1Bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="3008713"
Received: from spandruv-mobl5.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.87])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:52 -0700
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
Subject: [PATCH v14 24/24] x86,fs/resctrl: Document telemetry mount timing caveat
Date: Mon, 19 Oct 2026 13:50:31 -0700
Message-ID: <20261019205031.16977-25-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019205031.16977-1-tony.luck@intel.com>
References: <20261019205031.16977-1-tony.luck@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl enumerates telemetry events each time it is mounted, using
functions that the pmt_telemetry driver registers when it loads. The
driver can be built as a module, which is typically loaded by udev during
boot.

An automatic mount of resctrl from /etc/fstab early in boot can run
before pmt_telemetry has loaded. Telemetry events are then not enabled
in that mount, with no indication why.

Document the race, how to avoid it by mounting resctrl after
pmt_telemetry has loaded, and that unmounting and mounting resctrl again
enables the telemetry events.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v14:
	Updated commit message. Include unmount/remount as solution
	if early mount did not include AET.
---
 Documentation/filesystems/resctrl.rst | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index b52795e03303..66ffb625aac0 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -629,7 +629,7 @@ When monitoring is enabled all MON groups will also contain:
 	each instance of an L3 cache. Each directory contains files for the enabled
 	L3 events (e.g. "llc_occupancy", "mbm_total_bytes", and "mbm_local_bytes").
 
-	If telemetry monitoring is enabled, there will be a "mon_PERF_PKG_YY"
+	If telemetry monitoring is enabled [#]_, there will be a "mon_PERF_PKG_YY"
 	directory for each physical processor package. Each directory contains
 	files for the enabled telemetry events (e.g. "core_energy". "activity",
 	"uops_retired", etc.)
@@ -668,6 +668,12 @@ When monitoring is enabled all MON groups will also contain:
 	returned if the MBM event does not have an assigned counter in the
 	CTRL_MON group nor in any of its associated MON groups.
 
+.. [#] Telemetry features are enumerated asynchronously by the PMT driver, so
+   an automatic mount of resctrl from ``/etc/fstab`` at boot may not enable
+   them. To avoid this race, defer the mount until after the ``pmt_telemetry``
+   module has loaded. Unmounting and remounting the resctrl file system will
+   fix the issue.
+
 "mon_hw_id":
 	Available only with debug option. The identifier used by hardware
 	for the monitor group. On x86 this is the RMID.
-- 
2.56.0

