Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F403327A07
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 20:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758830667; cv=none; b=cLCtXAA8ox5jErF6BA+g/lWmz2mGVoaphDqe8s5+afeMTtCg3SWB3nXI1DCeMPU9SF/fd6S0hf8rrAwISFbIr13TrDx0vgYuZN21EsfL+M2t1PtRYI57YGpdBMnRaAm21dFetTyrkyvs98mGuirJKPuEYr7gmj6GmeVP4DON1qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758830667; c=relaxed/simple;
	bh=JdXqo8CyC6iZZ1CPme9AeWkUa3NJj4dp5td2iQYLYZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/GZ9oddbqhHHBgjC2mPJV7qFAwC6oZ0Ei4bBjWOvFI6AbaUb2GdR+P9p/i9fkkNYfdoM5MHj/1Qt5uXykUt4BJEtgEkN2NeEklnErMT6fcaFh4IPADFBEed7Xc1oy0/wBK4NNBlKRpWqEbr+XKK7wGazxHQH8EzZjH8FXDGsOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mb/+a+Fa; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mb/+a+Fa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758830666; x=1790366666;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JdXqo8CyC6iZZ1CPme9AeWkUa3NJj4dp5td2iQYLYZk=;
  b=Mb/+a+FaxpL03KTbH2y4eiOKfBLfANRiXFbCVWIFVfbPYD+GsolTkmim
   1FxsRNmX+q4wm8kqFX/QLLEyzLaxeVO4yqUPuNP3j2irUFxr4utrzpUNe
   1D/l4GozAkwdvqrWExOs3hA/NJzn9fucqFLQog45Ft3eGl/HurTuNlKyf
   LDYffDj2ZdHp+kRjm4Y21kyuUBJh7SHaIBaD5JzsF9/GJAx6Y3IlZ+wRw
   6dMesII2SMb88M0Sp9EYnYRXktfRSkNVFi6BwehGKrRgznD/6x3fg2Blh
   DugXAZuZ6kkcwc3WUobI8l8YFXYyjuIIB8iiZMh1JxhQy7VHpsxUMjqPi
   A==;
X-CSE-ConnectionGUID: 95RkZGhEQaKOoNZAX1GvvA==
X-CSE-MsgGUID: GRr5nwJWS/a/BO/hZxfugw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61074381"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61074381"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:15 -0700
X-CSE-ConnectionGUID: MX1cIAToSWyzBq95uiBNWA==
X-CSE-MsgGUID: lnT2P06XQy6H8eHs9XTzhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177003702"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.206])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:15 -0700
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
Subject: [PATCH v11 28/31] fs/resctrl: Provide interface to create architecture specific debugfs area
Date: Thu, 25 Sep 2025 13:03:22 -0700
Message-ID: <20250925200328.64155-29-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925200328.64155-1-tony.luck@intel.com>
References: <20250925200328.64155-1-tony.luck@intel.com>
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
index f82bdb8f6f1d..16b088c5f2be 100644
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
@@ -4513,6 +4516,31 @@ int resctrl_init(void)
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
@@ -4564,6 +4592,7 @@ void resctrl_exit(void)
 
 	debugfs_remove_recursive(debugfs_resctrl);
 	debugfs_resctrl = NULL;
+	debugfs_resctrl_info = NULL;
 	unregister_filesystem(&rdt_fs_type);
 
 	/*
-- 
2.51.0

