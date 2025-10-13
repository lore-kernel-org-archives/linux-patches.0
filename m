Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C399330E82C
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 22:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394860; cv=none; b=pCe4tjqrFHqKgOkBKDzmWKBkzOmr8KmIJsGLFkqvoxaYkoAgjf02Xa/w++1cI5/y4Cs6f9UV+vXzspCUD1DP1uU2LW02vdd4wYUc4vGGBIOt0MRfNzZK3J+f79LhRKJB3MaJ/3Ezg2JS/gnrP4atMf++7zyLRFFDwYvwGjJfuqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394860; c=relaxed/simple;
	bh=6WQUDfQRsydZVo/VpmymvYGGyCN/ihqK9hxiNqQvcrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyYqX/wSFvzsjpiv010Qcf2h5427rVO80P5kdaxfhoCLKEMVM5l7+fPIPzmqHqXw5yFndE7TbtdV8IuL+TwbUxiF+kn7rFJJrm52vdR77WABNRgmQDbge2TwAuAsffSz7QkM6nInTxkM3AP2Prfwl82FMpz0ZnEKWCNnBfxfssU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O5u8P1kt; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O5u8P1kt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760394858; x=1791930858;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6WQUDfQRsydZVo/VpmymvYGGyCN/ihqK9hxiNqQvcrM=;
  b=O5u8P1ktfNVS5L84oIzukGVdLUDpcabzopeGmx13U9nPqrLiHTyzu1iw
   yH4psuGco4S9Xkp+lIZVyDXYjfv8ZZedCqHDo/C1oSVpMAYIUYj+m+r1j
   qEH01rPU+vQgDo9hCDVNzsaRWmRPHuSy4Wk+yaFT6StPjM4f0aY+Qn2XZ
   YiUzJ/d6ETPnIapMc5TjCEVM9qoK16M4Ap8vSQFMPMDHB76ebPK1Ok00p
   g/9hWSAjW69rH4jQTVerRNh4YVpw6pZ3vPvkBA6e0a3Rfv1ZdGGGaTxU0
   v3oiyDz3FmKm3q3T3t8puWkvAIUPDzQF52sgCaJxOm55oNfaDv/xDw5yf
   w==;
X-CSE-ConnectionGUID: ptESB6W8RD6f7BdSn01iBA==
X-CSE-MsgGUID: 1/YnjuBOSkCE+nrtZXnSuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="85168957"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="85168957"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:04 -0700
X-CSE-ConnectionGUID: sbQ0bViMR2WbFkuhnoqMPg==
X-CSE-MsgGUID: eGJ4wCjPQMaqB0RVhTkwqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="182145342"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.79])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:04 -0700
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
Subject: [PATCH v12 29/31] fs/resctrl: Provide interface to create architecture specific debugfs area
Date: Mon, 13 Oct 2025 15:33:43 -0700
Message-ID: <20251013223348.103390-30-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013223348.103390-1-tony.luck@intel.com>
References: <20251013223348.103390-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All files below /sys/fs/resctrl are considered user ABI.

This leaves no place for architectures to provide additional
interfaces.

Add resctrl_debugfs_mon_info_arch_mkdir() which creates a directory in
the debugfs file system for a monitoring resource. Naming follows the
layout of the main resctrl hierarchy:

	/sys/kernel/debug/resctrl/info/{resource}_MON/{arch}

The {arch} last level directory name matches the output of
the user level "uname -m" command.

Architecture code may use this directory for debug information,
or for minor tuning of features. It must not be used for basic
feature enabling as debugfs may not be configured/mounted on
production systems.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h | 10 ++++++++++
 fs/resctrl/rdtgroup.c   | 29 +++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index c7b5e56d25bb..d4be0f54c7e8 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -678,6 +678,16 @@ void resctrl_arch_reset_cntr(struct rdt_resource *r, struct rdt_l3_mon_domain *d
 extern unsigned int resctrl_rmid_realloc_threshold;
 extern unsigned int resctrl_rmid_realloc_limit;
 
+/**
+ * resctrl_debugfs_mon_info_arch_mkdir() - Create a debugfs info directory.
+ *					   Removed by resctrl_exit().
+ * @r:	Resource (must be mon_capable).
+ *
+ * Return: NULL if resource is not monitoring capable,
+ * dentry pointer on success, or ERR_PTR(-ERROR) on failure.
+ */
+struct dentry *resctrl_debugfs_mon_info_arch_mkdir(struct rdt_resource *r);
+
 int resctrl_init(void);
 void resctrl_exit(void);
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index c1c02b5bf5d7..728f4936e5d5 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -24,6 +24,7 @@
 #include <linux/sched/task.h>
 #include <linux/slab.h>
 #include <linux/user_namespace.h>
+#include <linux/utsname.h>
 
 #include <uapi/linux/magic.h>
 
@@ -75,6 +76,8 @@ static void rdtgroup_destroy_root(void);
 
 struct dentry *debugfs_resctrl;
 
+static struct dentry *debugfs_resctrl_info;
+
 /*
  * Memory bandwidth monitoring event to use for the default CTRL_MON group
  * and each new CTRL_MON group created by the user.  Only relevant when
@@ -4541,6 +4544,31 @@ int resctrl_init(void)
 	return ret;
 }
 
+/*
+ * Create /sys/kernel/debug/resctrl/info/{r->name}_MON/{arch} directory
+ * by request for architecture to use for debugging or minor tuning.
+ * Basic functionality of features must not be controlled by files
+ * added to this directory as debugfs may not be configured/mounted
+ * on production systems.
+ */
+struct dentry *resctrl_debugfs_mon_info_arch_mkdir(struct rdt_resource *r)
+{
+	struct dentry *moninfodir;
+	char name[32];
+
+	if (!r->mon_capable)
+		return NULL;
+
+	if (!debugfs_resctrl_info)
+		debugfs_resctrl_info = debugfs_create_dir("info", debugfs_resctrl);
+
+	sprintf(name, "%s_MON", r->name);
+
+	moninfodir = debugfs_create_dir(name, debugfs_resctrl_info);
+
+	return debugfs_create_dir(utsname()->machine, moninfodir);
+}
+
 static bool resctrl_online_domains_exist(void)
 {
 	struct rdt_resource *r;
@@ -4592,6 +4620,7 @@ void resctrl_exit(void)
 
 	debugfs_remove_recursive(debugfs_resctrl);
 	debugfs_resctrl = NULL;
+	debugfs_resctrl_info = NULL;
 	unregister_filesystem(&rdt_fs_type);
 
 	/*
-- 
2.51.0

