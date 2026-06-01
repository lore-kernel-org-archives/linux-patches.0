Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642553DE439
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 19:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780343819; cv=none; b=j/1RCWHxzE/B19GcE5X0OqHlApQ4N/6cvW0ezzEwKdG93Aj2an+c6g0i/OJ2A83veDc7d/G6a/TXhFng9zB3BWQ7vspPGiwFfM0e3Mg9Si+GWGa9kljMFSEx5NXQehn0e135PNjnuTAXE1WuyjE2bw+BZzT9GPlLFuueX6fQQH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780343819; c=relaxed/simple;
	bh=85p7ItNAhTY8AtSyHL6/wWbocxWYL2NWxuDEDMK36/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1hbCsLgT+gek6Avs6qtab13POI9NGPEKtqIfVGbUdCuxvGaEvmuevr7JkSlGZ5nVL+PJNwChCgVrydqFFF86qXgYBlKFh9k5I1wnb58hg56E9TtpRakWVe41ewyxaDDJcbw3NtH81CMsX4KvQoprxjN6MQsefyqoqytiHotiIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B1arSZYv; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B1arSZYv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780343818; x=1811879818;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=85p7ItNAhTY8AtSyHL6/wWbocxWYL2NWxuDEDMK36/E=;
  b=B1arSZYvJk5RSD0erbri0RiqaGuSEYHVR4r/Hq2ldsrBKxRMwn4CV6NG
   C7UVvh3KyXTGP81qHZOq3aBCZx+k+woyHGa2IwEYgZLoH5c9GOpSbpmer
   5rutGRAMUx/5PYGXFaF1FwLP0YzY01qkZoFeXFN8Fuq6otg1/nLzeeXsJ
   3DDLUtqRWJfRj/yb5WssrD6lB9prVQgyrK/A64cdOW+P7jfAB55rrCZ23
   cHEfDHwlVefjo1lbCV0ejSXT1q3mCYwoXYFI7OVsvVWMeiYQdbNubGF6n
   mGluAyViACGT6wx7LlQhv7i1x7gf02OVMa0Zj1g0yHsDVwa0YeeaANaJD
   g==;
X-CSE-ConnectionGUID: Od5mw21JQoaoRZa2kIOymQ==
X-CSE-MsgGUID: Nr8pyPwKQFqRpTHJ+gjlGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="81011679"
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="81011679"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:46 -0700
X-CSE-ConnectionGUID: GfKAONXhTAmKb3HJzJ2L+w==
X-CSE-MsgGUID: 1BMn2RaPTvKi7CaRM9536Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="247946536"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.168])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:45 -0700
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
Subject: [PATCH v7 14/14] Documentation/filesystems/resctrl: Add footnote for telemetry fstab mount caveat
Date: Mon,  1 Jun 2026 12:56:32 -0700
Message-ID: <20260601195632.15876-15-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601195632.15876-1-tony.luck@intel.com>
References: <20260601195632.15876-1-tony.luck@intel.com>
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
2.54.0

