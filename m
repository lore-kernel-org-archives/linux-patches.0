Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBBE2E2DE8
	for <patches@lists.linux.dev>; Mon, 11 Aug 2025 18:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754936263; cv=none; b=MOVy8A/vSiQiPu4Aa1EfJjIqxfMcDjPIjov0o4lRnsYxBZ4sYdjeqiY3e8d1N1xdeiqinUyHszb0+w7dNKcaxeVXzBroPeIErrUHlre2pqrFLQ0dAZ2UAe72X64WPR3M8t10YNa/7fkFNaBNVWg/h0FrkQLn9K7G6wTp5ZNE9Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754936263; c=relaxed/simple;
	bh=tiN+hbV8N2y0qYnYfboP2LM2eI9E8FHvJartB9jdL6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9ruCvlWVF55pvtBb6V8E9S9EUWmHfFFJ3MXRMvrWG8VoPa0g9hxfoUu6X3B9TcU/7TjYLCu2F7VGPm6MF/JhBaJ+eHtk1aWHFO4TstDfUU8Rym4onVIDvz/QzLkuVxaJWxT/1Ifi7RUgWqRlqaDymc9IohS9ATJj0xfJSQXHRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cWQMgWys; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cWQMgWys"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754936262; x=1786472262;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tiN+hbV8N2y0qYnYfboP2LM2eI9E8FHvJartB9jdL6E=;
  b=cWQMgWysuj2shX82ugAeAgEUkWqMDH2TF8IjpYc1JubcTlxd1jDTiLpn
   P7lhirBBiSkdUIabwPdoJjcnDH8bGmZsFsYubWENXiZprfHfp5cAY8oCX
   hIOrtGDi7kKOOLHrP233j1lfsYMKZkI0QJ9Za4f/tdG9du+PdopvK72bl
   9O8pK6dj0D5AA/MCq4WmessQzXfLlSucUVuqEFSG+Yx2x28iMOMDWqNsd
   3C6V7NDvCExZEVexR0hbFxxCpb9Qxwf2NaQoPAhdBmvAMoJGhkPOi1l/I
   tHBsLAHmU8vUys33SnN7czgTWkxAQnQGEzHibJ3lTCFzZgGM2NBVMmbH5
   A==;
X-CSE-ConnectionGUID: rurPZKrITn2MT8l7Ye9Yiw==
X-CSE-MsgGUID: cnxTP9QWRN6yF2UyG/QG1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="68277413"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68277413"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:27 -0700
X-CSE-ConnectionGUID: OoFydq4GRMuuVhIE5KtHQA==
X-CSE-MsgGUID: hzh363I5Rlm/p216ei15RA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="196825661"
Received: from puneetse-mobl.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.229])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:24 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v8 15/32] x86,fs/resctrl: Add an architectural hook called for each mount
Date: Mon, 11 Aug 2025 11:16:49 -0700
Message-ID: <20250811181709.6241-16-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811181709.6241-1-tony.luck@intel.com>
References: <20250811181709.6241-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enumeration of Intel telemetry events is an asyncronnous process involving
several mutually dependent drivers added as auxiliary devices during
the device_initcall() phase of Linux boot. The process completes after
the probe functions for these drivers are called. But this happens after
resctrl_arch_late_init() is executed.

Tracing the enumeration process shows that it does complete a full seven
seconds before the earliest possible mount of the resctrl file system
(when included in /etc/fstab for automatic mount by systemd).

Add a hook at the beginning of the mount code that will be used
to check for telemetry events and initialize if any are found.

Call the hook on every attempted mount. But expectations are that
most actions (like enumeration) will only need to be performed
on the first call.

The call is made with no locks held. Architecture code is responsible
for any required locking.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            | 6 ++++++
 arch/x86/kernel/cpu/resctrl/core.c | 9 +++++++++
 fs/resctrl/rdtgroup.c              | 2 ++
 3 files changed, 17 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 38809c497b44..19409227ccd0 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -461,6 +461,12 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
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
index f6fda15da9c1..480e381d416e 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -718,6 +718,15 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
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
index b917d48a806a..31f9425783ef 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2585,6 +2585,8 @@ static int rdt_get_tree(struct fs_context *fc)
 	struct rdt_resource *r;
 	int ret;
 
+	resctrl_arch_pre_mount();
+
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 	/*
-- 
2.50.1

