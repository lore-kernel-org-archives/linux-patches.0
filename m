Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F4823E331
	for <patches@lists.linux.dev>; Wed, 21 May 2025 22:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867868; cv=none; b=H9963qiyGbUaHIKSVzx1/bU3qlYOe20EsxssPcOUJM/0F5e20cP/jhOF8RRLX0RuRRkcxQ0s7cPnJFZghXr/W83WQT8f29AO9Drm98YxFtynmgBGabCVeZhNc1uXDdEUNpN18yEWx/CbQ+he/4x1FqzYVpJnm7So2P+dPqj1x/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867868; c=relaxed/simple;
	bh=0F07DEq15poZiIZ6S3FcEqN2NGOe2aVEvkV51hDbxXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPfUlNRmHHo/PV1LzATtXbXkq6ChkO8hz6i8qMI9m1GO47o2wfPIlUr7xxlFfj5Lb3vLWpzM1XS7Gh0RTEnvkXEwLEUMDh9VJKrvNfLUirMX0Q+TMrEfnPn8Dax1u5DpTGc652c1J3U6Lyu366NNe6QDDNOW85hGWipEEz8I2KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KTk3O+y4; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KTk3O+y4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747867866; x=1779403866;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0F07DEq15poZiIZ6S3FcEqN2NGOe2aVEvkV51hDbxXk=;
  b=KTk3O+y4F7JMP4f0u9BaLqzhc0NupvR1ei1NRlcpHKBTU94XBh2R9Z3l
   BIqU/pUxyCrxdZQX4JOzKZzzyeM3x8a2kL2O046SwwegE1NXNjGkG8w/v
   VdO2Zyxl7feBFw65Iov5kSdeMz9WNhbJooKQymYTn+Ilm028+pSi8lsQf
   mRjoy7iLXz21ZFXAcZTa0w4jfq9RXV4H4W/Wd+ru6xyhDIa5XdH7jAmr6
   UFjziwznZXbbf8AaMRs0hYyNip+DSJzpdXTBYZU5bPiJO3jMioJJVj26V
   U+J9buAyu7H6YLL9NIJF1hDCsgPkRBe6ovIkFkfmPMb6lN5OwPNbR3wO+
   g==;
X-CSE-ConnectionGUID: uEt2i/rMT1C1z597LOAvFw==
X-CSE-MsgGUID: v1aIGcT0Qn2p0WRtrxm10A==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="53677718"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="53677718"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:58 -0700
X-CSE-ConnectionGUID: NPkrjNmiRNmXRyNsKiRtZQ==
X-CSE-MsgGUID: 1g6f3jqtQZuZ1PGErah1ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="141352166"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:58 -0700
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
Subject: [PATCH v5 15/29] fs/resctrl: Add an architectural hook called for each mount
Date: Wed, 21 May 2025 15:50:33 -0700
Message-ID: <20250521225049.132551-16-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521225049.132551-1-tony.luck@intel.com>
References: <20250521225049.132551-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enumeration of Intel telemetry events is not complete when the
resctrl "late_init" code is executed.

Add a hook at the beginning of the mount code that will be used
to check for telemetry events and initialize if any are found.

The hook is called on every attempted mount. But expectations are that
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
index 46ba62ee94a1..4ad3d7f10580 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -452,6 +452,12 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 void resctrl_online_cpu(unsigned int cpu);
 void resctrl_offline_cpu(unsigned int cpu);
 
+/*
+ * Architecture hook called for each attempted file system mount.
+ * No locks are held.
+ */
+void resctrl_arch_pre_mount(void);
+
 /**
  * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
  *			      for this resource and domain.
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 306afb50fd37..f8c9840ce7dc 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -710,6 +710,15 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
 	return 0;
 }
 
+void resctrl_arch_pre_mount(void)
+{
+	static atomic_t only_once;
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
index 67482f1110b3..bdad98ac0d27 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2583,6 +2583,8 @@ static int rdt_get_tree(struct fs_context *fc)
 	struct rdt_resource *r;
 	int ret;
 
+	resctrl_arch_pre_mount();
+
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 	/*
-- 
2.49.0

