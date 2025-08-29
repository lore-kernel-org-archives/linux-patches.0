Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414E834AB05
	for <patches@lists.linux.dev>; Fri, 29 Aug 2025 19:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756496056; cv=none; b=hW6lV7Dwmc1okni9/hAA7SacJH6aCr4WOrkzriveioiXF8fJEL0Kp7Js6aksVcpEPq5um0RRjMtPQ6xc6GHzEBYcBVb+PdFXGe8Fk6GeJlQLCoHn5cBmmqGZYZxoFpjJwgl+VOyv9i4i10PuJq8dqntw6jakGaCgaU3ZyarhwC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756496056; c=relaxed/simple;
	bh=Lncq/jLYO+WU5E8LHu+kqPvJFoGVWOJEXvzfJAno3+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=om5boDrJUKjlhf3f6SB/NnN6WxTueFjiPKbp2WG1RdgqpIG/S0Pjlrbks7OgRpY1vS+tkl/QhYTtGAM0XvfhAZOP3OcrH8tr0XeYLidwoSTh1KWmazytSce3TyzVEkhYFIHhEyu2RaQ7O+94P2w/cjkqTRfrUvsLAhxA15gGKFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eQEqGa0f; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eQEqGa0f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756496054; x=1788032054;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Lncq/jLYO+WU5E8LHu+kqPvJFoGVWOJEXvzfJAno3+U=;
  b=eQEqGa0f2w00UKmxu+YnrT7EYbwhx5Iowrob0O0mzJJ2iQzL82qLSAGF
   fLsh/vbX9WixytO33/6PnSAMdA5Eyn9orAoMcuykD0nELpFjSAbJ7Q0Tn
   82mc/EC5nMdNfKdDSWGFsJxZ+WePMtzcTtKITTC2SzALgvuSTwoQAKiBT
   RbJU8kLxRh6NlXx+1xqvVZAOZLUc9FWmiC5nNnT2u/CKF02E4iEURAl5v
   D7wSJhg36gD1QIE40MyLdt+KDL0YR7E6OyR+427eck0y3S1DQIIOTelIH
   fx4QIVci/x/SW7Ouy+aTn9Icvjt6tmoYfvUqVinnnRGoojacbp4MADN7O
   Q==;
X-CSE-ConnectionGUID: uX9svAtwSxOvblS4KzeDGw==
X-CSE-MsgGUID: /gkOuqeVTuaDuv4hZ6+rvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62625382"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62625382"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:33:57 -0700
X-CSE-ConnectionGUID: nUBALeHzRXeNLRceRV0c+w==
X-CSE-MsgGUID: d7bFGg2cQt+Zsp6B1i90Iw==
X-ExtLoop1: 1
Received: from ldmartin-desk2.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.202])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:33:57 -0700
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
Subject: [PATCH v9 29/31] fs/resctrl: Provide interface to create architecture specific debugfs area
Date: Fri, 29 Aug 2025 12:33:41 -0700
Message-ID: <20250829193346.31565-30-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829193346.31565-1-tony.luck@intel.com>
References: <20250829193346.31565-1-tony.luck@intel.com>
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
 include/linux/resctrl.h |  9 +++++++++
 fs/resctrl/rdtgroup.c   | 29 +++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 1f42bc761377..8a010c29c8b4 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -569,6 +569,15 @@ void resctrl_arch_reset_all_ctrls(struct rdt_resource *r);
 extern unsigned int resctrl_rmid_realloc_threshold;
 extern unsigned int resctrl_rmid_realloc_limit;
 
+/**
+ * resctrl_debugfs_mon_info_arch_mkdir() - Create a debugfs info directory.
+ *					   Removed by resctrl_exit().
+ * @r:	Resource (must be mon_capable).
+ *
+ * Return: dentry pointer on success, or NULL on error.
+ */
+struct dentry *resctrl_debugfs_mon_info_arch_mkdir(struct rdt_resource *r);
+
 int resctrl_init(void);
 void resctrl_exit(void);
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 886de0e01e8a..8f0bcb139a74 100644
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
@@ -4355,6 +4358,31 @@ int resctrl_init(void)
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
@@ -4406,6 +4434,7 @@ void resctrl_exit(void)
 
 	debugfs_remove_recursive(debugfs_resctrl);
 	debugfs_resctrl = NULL;
+	debugfs_resctrl_info = NULL;
 	unregister_filesystem(&rdt_fs_type);
 
 	/*
-- 
2.50.1

