Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1B833F8CA
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 17:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765992123; cv=none; b=HYT/VAUq/gvQbMAAOcejRQGUDajxu+SGvF8X8RPrkS5gNQDSJyE2vV6wkA+uLf00yjcXHzvg89xY3cV74AaDvLx9SODFLhWv3UyJdypoN88+zO0vbclxmtK12xdnj3UkGgD8Rz/IRkton6ZW5tyFT4OT04YvOOxCOkc1ypluX+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765992123; c=relaxed/simple;
	bh=Zbah9AsGyv8lZL/yNB7qwNiWl6aswBv2gheUbQt6CcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4oWmV2KdhJwqZ5MBEh88nnaa+LxV/Fft8lenV0reRlVGygXcSlQVH/Y6Ld3CsWqpej3r3QKvZ22KGxEsYcWhnXVAH5MGrv5VKaZnxmiALX+Yr3WDrepf5NzOhOw4Wgt2KzQtJhdkF/iZLUlc+z7hGGlZvOj6R22/ZFFRbTPmvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XAqb+uU/; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XAqb+uU/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765992117; x=1797528117;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zbah9AsGyv8lZL/yNB7qwNiWl6aswBv2gheUbQt6CcE=;
  b=XAqb+uU/GmNOXCOe4A9kH95MoaHZ28C4WPiVjdKx03fZcyxR0riw06+/
   lvdqj0ns/QuqjgqY7bINbWPISR9g4Lgx+yw+sT2Eir//Arf5soSOuMCgx
   UNZN2zetWiT7/8ADYB3iPAVzwiIzU2oDDS0bLD6s0pd7/7aaDer0/r+3x
   jFfBmgd5yLxplcIG1i0HcNQcOzmThedEog1irdL6ack6XPFbZpi0Pee/6
   lyS16qTFrXkRfr48sBTKZqG+6BWKTZExQLWYLaM+Kd9npvYZcjP4iwu5M
   07PmJ+nZReWUMdh3UHplOgOZrMm3NbVjv542KO4LSQo2rrf07YeuFvGzH
   w==;
X-CSE-ConnectionGUID: Mpp2yT1VSdyV/uclRH754Q==
X-CSE-MsgGUID: 5kdpHoFmQ1+5pa/XrK7HyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="90594719"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="90594719"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:34 -0800
X-CSE-ConnectionGUID: GY+pFM0YRByUU8yftTWh8A==
X-CSE-MsgGUID: BIAToKeoQqi8y1f+nnVU6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="221748201"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.131])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:33 -0800
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
Subject: [PATCH v17 13/32] x86,fs/resctrl: Add an architectural hook called for each mount
Date: Wed, 17 Dec 2025 09:21:00 -0800
Message-ID: <20251217172121.12030-14-tony.luck@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217172121.12030-1-tony.luck@intel.com>
References: <20251217172121.12030-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enumeration of Intel telemetry events is an asynchronous process involving
several mutually dependent drivers added as auxiliary devices during
the device_initcall() phase of Linux boot. The process finishes after
the probe functions of these drivers completes. But this happens after
resctrl_arch_late_init() is executed.

Tracing the enumeration process shows that it does complete a full seven
seconds before the earliest possible mount of the resctrl file system (when
included in /etc/fstab for automatic mount by systemd).

Add a hook at the beginning of the mount code that will be used to check
for telemetry events and initialize if any are found.

Call the hook on every attempted mount. Expectations are that most actions
(like enumeration) will only need to be performed on the first call.

resctrl filesystem calls the hook with no locks held. Architecture code is
responsible for any required locking.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 include/linux/resctrl.h            | 6 ++++++
 arch/x86/kernel/cpu/resctrl/core.c | 9 +++++++++
 fs/resctrl/rdtgroup.c              | 2 ++
 3 files changed, 17 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index c43526cdf304..dc148b7feb71 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -514,6 +514,12 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 void resctrl_online_cpu(unsigned int cpu);
 void resctrl_offline_cpu(unsigned int cpu);
 
+/*
+ * Architecture hook called at beginning of each file system mount attempt.
+ * No locks are held.
+ */
+void resctrl_arch_pre_mount(void);
+
 /**
  * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
  *			      for this resource and domain.
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 9222eee7ce07..2dd48b59ba9b 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -726,6 +726,15 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
 	return 0;
 }
 
+void resctrl_arch_pre_mount(void)
+{
+	static atomic_t only_once = ATOMIC_INIT(0);
+	int old = 0;
+
+	if (!atomic_try_cmpxchg(&only_once, &old, 1))
+		return;
+}
+
 enum {
 	RDT_FLAG_CMT,
 	RDT_FLAG_MBM_TOTAL,
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 771e40f02ba6..b20d104ea0c9 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2785,6 +2785,8 @@ static int rdt_get_tree(struct fs_context *fc)
 	struct rdt_resource *r;
 	int ret;
 
+	resctrl_arch_pre_mount();
+
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 	/*
-- 
2.52.0

