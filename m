Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4E72C0274
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 23:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765408542; cv=none; b=urROUHc7Hny15ARDvPdGqjMtzBreEvrJIzLqt9bysz+YlP9twCKmM6a+j0e3+jiRBap6QI5C7wMHcA3BSSuRQJMJOMYvWyM4zwfsaPft8l5fEKgj0ftCMTu2qSp5ft+3X0ScNvsR0vp9ODCtVx7W+qeYleWl3gkKqNPSOxxe5Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765408542; c=relaxed/simple;
	bh=a6GqSiYes3g1hfurapo7TsD5x6nKUzU6tpAj8OUBXbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cu+1BWBjX5OFUuD7CTWOCdX9yODZMorboX81pbNvONuAULYm9ZTjmN6XTSu3LW9YRdLYg7plgibUFwXdE311plcy+iidwkmC7Yu+LT3AZBhRYVdD8XxmLklfv1uGmvtNjLQBWlIaxP+igkXwmICIkQE0XGHGs0SVxKrGjXoT7cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gsvmEec0; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gsvmEec0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765408534; x=1796944534;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a6GqSiYes3g1hfurapo7TsD5x6nKUzU6tpAj8OUBXbc=;
  b=gsvmEec0OEllwDhEaTXYlFVV9xtSoQpTQ/4nhws94R+2/58Xf7JiDcu5
   1bbabTOknb2wMicNiy9eW812AFBJko2e9E1y0BORRhN/IRqzrPLcy7iX6
   W0rZf/nSVI/wtQyP/MbF3HEIdyhpgnizUzd8YIOK1bc6F++MLu5SGWHTI
   rvh4chwkCZUMstJlp5lgBVPtaoT9AZsEEpArYl3Kvg+5i+MGzWyagVNsC
   VKd938yk/kKTZxjCWVJNVpxTuxzbilKlVNB/zMC0sgvbUCsPQHBM4ntqJ
   byGczNVRxzwza7ZuWPCQbNFHMJU6PgddEMgBcqJW09oF47h06In0BBkGA
   w==;
X-CSE-ConnectionGUID: a41uMwxgTB2QeEUzGEccMQ==
X-CSE-MsgGUID: y12+KvwnS3Gxfr1VXSxuqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="69973726"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="69973726"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:45 -0800
X-CSE-ConnectionGUID: 2kpcaM3ZTg+pj6CuVyfhXQ==
X-CSE-MsgGUID: txepatvgR+mGQcj+1qIL7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227297167"
Received: from daliomra-mobl3.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.254])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:44 -0800
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
Subject: [PATCH v16 30/32] fs/resctrl: Provide interface to create architecture specific debugfs area
Date: Wed, 10 Dec 2025 15:14:09 -0800
Message-ID: <20251210231413.59102-31-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251210231413.59102-1-tony.luck@intel.com>
References: <20251210231413.59102-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All files below /sys/fs/resctrl are considered user ABI.

This leaves no place for architectures to provide additional interfaces.

Add resctrl_debugfs_mon_info_arch_mkdir() which creates a directory in
the debugfs file system for a monitoring resource. Naming follows the
layout of the main resctrl hierarchy:

	/sys/kernel/debug/resctrl/info/{resource}_MON/{arch}

The {arch} last level directory name matches the output of the user level
"uname -m" command.

Architecture code may use this directory for debug information, or for minor
tuning of features. It must not be used for basic feature enabling as debugfs
may not be configured/mounted on production systems.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 include/linux/resctrl.h | 10 ++++++++++
 fs/resctrl/rdtgroup.c   | 29 +++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 8623e450619a..b862a9dd785b 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -702,6 +702,16 @@ bool resctrl_arch_get_io_alloc_enabled(struct rdt_resource *r);
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
index d49ffc56ea61..d13291d71adf 100644
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
@@ -4599,6 +4602,31 @@ int resctrl_init(void)
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
@@ -4650,6 +4678,7 @@ void resctrl_exit(void)
 
 	debugfs_remove_recursive(debugfs_resctrl);
 	debugfs_resctrl = NULL;
+	debugfs_resctrl_info = NULL;
 	unregister_filesystem(&rdt_fs_type);
 
 	/*
-- 
2.51.1

