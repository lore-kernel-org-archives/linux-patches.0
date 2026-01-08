Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F14C2DA769
	for <patches@lists.linux.dev>; Thu,  8 Jan 2026 17:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767894176; cv=none; b=EpCODf45xcLFAf/dlTLp7MeT7txri+RUf+rWJKDxOaWWm6xjJpsBy2+8ENZvtcfVGKBAsrwFwd77Lmzo1kTVseI75KkN1bmwD2NKcmY3w1O68TOnll+vzdE8zTsAVB90VdleHNQK1yR85MH55ZbsC3xeHT19yFHt3G5mgbI4aFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767894176; c=relaxed/simple;
	bh=mVon3QCCgN8CAIK2Kn9VD/59thFGAyRpr8gdLUq4cmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnVZLKqA45aN59SKz2u05l3JQuY0AtIPeznPRwnxe/K+bUxNwSuNJS/d4UlzpvuPnTSDv7xDnUGqjRgd00Po1XfssNEn/FyP7iMka3kqnQ90kdD6RRkvtUVeosyb/JxUh7kHnrgiKT3L9ZNdVZV9xRohSpYgzjW/ITDH7R8VCxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SXCcOCZg; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SXCcOCZg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767894172; x=1799430172;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mVon3QCCgN8CAIK2Kn9VD/59thFGAyRpr8gdLUq4cmw=;
  b=SXCcOCZgoJ/phd5dKQfdAoBp3MzbBQa1Rd0gdg4L7M9+CfgctEdhFqqd
   3tNoKtTt39OS1RkS0YD9SQv5V369jHcVpBJoKCjIfv826N1hbJA+3dmYt
   ma2sYdG0YYR37r++KgCXowE/2EJQGez0R5s7O9dajF7p8C2PgCz1VDugj
   chmKMF1yDgQWANtkaKZgD5VlOxk6ZzAqBGIBJcEYaySAJI2zsOPTJ9HMu
   hvZmxWzgSelzV09JYkwVE1nQGdSak/4jlmF63lUbfZKmJtOdY5ruBoiFz
   J6kWiAgNR5BU0kv5nks+ptEcEKSgzInrhqKvENuy0btACagPw7pvHA9rp
   Q==;
X-CSE-ConnectionGUID: 5JUYeemQRiWnqmW1XvjNdw==
X-CSE-MsgGUID: +R6TKhUqQ2q3L9leN5bouA==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="79998999"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="79998999"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 09:42:47 -0800
X-CSE-ConnectionGUID: DSplI35gRiKLdjkOtzL0sA==
X-CSE-MsgGUID: t/KsbgHwQiSZVLnaLqYzuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="240751109"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.16])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 09:42:48 -0800
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 13/32] x86,fs/resctrl: Add an architectural hook called for first mount
Date: Thu,  8 Jan 2026 09:42:25 -0800
Message-ID: <20260108174227.11307-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260108174227.11307-1-tony.luck@intel.com>
References: <20260108174227.11307-1-tony.luck@intel.com>
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

The hook is only called on the first mount of the resctrl file system as
that is all that is needed for telemetry enumeration.

resctrl filesystem calls the hook with no locks held. Architecture code is
responsible for any required locking.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            | 6 ++++++
 arch/x86/kernel/cpu/resctrl/core.c | 4 ++++
 fs/resctrl/rdtgroup.c              | 3 +++
 3 files changed, 13 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index c43526cdf304..2f938a5a16f8 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -514,6 +514,12 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 void resctrl_online_cpu(unsigned int cpu);
 void resctrl_offline_cpu(unsigned int cpu);
 
+/*
+ * Architecture hook called at beginning of first file system mount attempt.
+ * No locks are held.
+ */
+void resctrl_arch_pre_mount(void);
+
 /**
  * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
  *			      for this resource and domain.
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 9222eee7ce07..a2b7f869b4b0 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -726,6 +726,10 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
 	return 0;
 }
 
+void resctrl_arch_pre_mount(void)
+{
+}
+
 enum {
 	RDT_FLAG_CMT,
 	RDT_FLAG_MBM_TOTAL,
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 771e40f02ba6..0e3b8bcf4e53 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -18,6 +18,7 @@
 #include <linux/fs_parser.h>
 #include <linux/sysfs.h>
 #include <linux/kernfs.h>
+#include <linux/once.h>
 #include <linux/resctrl.h>
 #include <linux/seq_buf.h>
 #include <linux/seq_file.h>
@@ -2785,6 +2786,8 @@ static int rdt_get_tree(struct fs_context *fc)
 	struct rdt_resource *r;
 	int ret;
 
+	DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
+
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 	/*
-- 
2.52.0

