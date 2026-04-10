Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B0D392C21
	for <patches@lists.linux.dev>; Fri, 10 Apr 2026 20:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775851556; cv=none; b=lKEKipOUZSsSWuNp6ES1zp3h/WCx2HSu/1ZVYXv60XplHgd45ojmRGNAJFGA/hfbBmDJkdKqx4MsZXicpkxpIHDDqS7ol4U6MMIAcj61r9V9SxC4qlGmzfNVAkZY1RBMR6az8/2zkbLlirLhRneKuG51BGZ7UM6/7i5cIKwlrWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775851556; c=relaxed/simple;
	bh=8+xCiqAx7z0gGvhV6GHtmnlfV71IyVd56yR7wAWwwTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJyQFr1DS1vTEWGv1NCOS8L4kLe8LwTFDkvvyv/FesSU+OXu1ru4LoAYRlWsMC8qT5Upz0O68cXQ9hJc0mAMFyNg9llC68SWz1PRQKre6VKsSRvPSLl4yKO5ojBEt6yj43crTFgTujAvWugaGZrXCXi3Hdap//3ps0KDniN/+u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ed2jUDMg; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ed2jUDMg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775851545; x=1807387545;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8+xCiqAx7z0gGvhV6GHtmnlfV71IyVd56yR7wAWwwTU=;
  b=ed2jUDMgYJpVTos6xV7VOFppTiTg8+H2WhX1gKU/vlLiNWZxYZz3RT9I
   X8M3vpRmtLJswwzeZBpZvF+4X1WMqByl3SnhJZz+sG+KvResoDPisFOFk
   hCKH2tfjxzdz2/trsR8ZefKNLN/X3s09BKsMvUnX1BkzA+vvps6CDLHVE
   9/J2lvqNpDnPi8VlnD89m6Q/XWXEvSOb3Lg+iFTcyoX18O0LSajECJFVU
   /jbmR/F1sVfj0rP6C8ZrLCgV45D21nNrZ8yWctETFY3DMrjnLOdqZZoMi
   5sGEtW9zJv1duTjFMJX9ICNAozz9oAp2ALj6/ad8jYWCM64opRWQUDiEa
   A==;
X-CSE-ConnectionGUID: s6RWBJPRSLyAU9M3Ff4/fg==
X-CSE-MsgGUID: 1r6KL0LITwidrxOIQaZejQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11755"; a="76898107"
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="76898107"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 13:05:42 -0700
X-CSE-ConnectionGUID: Qf75QDRhQHCJLvKXJkN5BA==
X-CSE-MsgGUID: Yw7VLsxaTuiHmyMwK/u8Gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="228155028"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.106])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 13:05:41 -0700
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
Subject: [RFC PATCH v5 6/7] fs/resctrl: Call architecture hooks for every mount/unmount
Date: Fri, 10 Apr 2026 13:05:31 -0700
Message-ID: <20260410200532.58602-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260410200532.58602-1-tony.luck@intel.com>
References: <20260410200532.58602-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Architecture code for AET needs to acquire INTEL_PMT_TELEMETRY module
references on mount and release them on unmount.

Add hooks for every mount/unmount of the resctrl file system so that
architecture code can allocate on mount and free on unmount.

Add resctrl_mount_lock to protect mount/unmount operations and write access
to "resctrl_mounted". This simplifies the code flow around the repeat mount
with -EBUSY return to avoid calling resctrl_arch_pre_mount() when the file
system is mounted.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h |  9 ++++++---
 fs/resctrl/rdtgroup.c   | 35 ++++++++++++++++++++++++++++-------
 2 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index f3eb6dfa61d4..f3da533e182c 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -551,12 +551,15 @@ void resctrl_online_cpu(unsigned int cpu);
 void resctrl_offline_cpu(unsigned int cpu);
 
 /*
- * Architecture hook called at beginning of first file system mount attempt.
- * No locks are held.
+ * Architecture hook called before attempting to mount the file system.
+ * Called with just resctrl_mount_lock held.
  */
 void resctrl_arch_pre_mount(void);
 
-/* Called to report unmount. */
+/*
+ * Architecture hook called when mount fails, or on unmount.
+ * Called with just resctrl_mount_lock held.
+ */
 void resctrl_arch_unmount(void);
 
 /**
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5da305bd36c9..444bc359e4a7 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -18,7 +18,6 @@
 #include <linux/fs_parser.h>
 #include <linux/sysfs.h>
 #include <linux/kernfs.h>
-#include <linux/once.h>
 #include <linux/resctrl.h>
 #include <linux/seq_buf.h>
 #include <linux/seq_file.h>
@@ -48,7 +47,14 @@ LIST_HEAD(resctrl_schema_all);
  */
 static LIST_HEAD(mon_data_kn_priv_list);
 
-/* The filesystem can only be mounted once. */
+/* Mutex protecting mount/unmount operations */
+static DEFINE_MUTEX(resctrl_mount_lock);
+
+/*
+ * The filesystem can only be mounted once.
+ * Updated with both rdtgroup_mutex and resctrl_mount_lock held.
+ * Safe to read while holding either rdtgroup_mutex or resctrl_mount_lock.
+ */
 bool resctrl_mounted;
 
 /* Kernel fs node for "info" directory under root */
@@ -2788,18 +2794,21 @@ static int rdt_get_tree(struct fs_context *fc)
 	struct rdt_resource *r;
 	int ret;
 
-	DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
+	mutex_lock(&resctrl_mount_lock);
 
-	cpus_read_lock();
-	mutex_lock(&rdtgroup_mutex);
 	/*
 	 * resctrl file system can only be mounted once.
 	 */
 	if (resctrl_mounted) {
-		ret = -EBUSY;
-		goto out;
+		mutex_unlock(&resctrl_mount_lock);
+		return -EBUSY;
 	}
 
+	resctrl_arch_pre_mount();
+
+	cpus_read_lock();
+	mutex_lock(&rdtgroup_mutex);
+
 	ret = setup_rmid_lru_list();
 	if (ret)
 		goto out;
@@ -2897,6 +2906,12 @@ static int rdt_get_tree(struct fs_context *fc)
 	rdt_last_cmd_clear();
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
+
+	if (ret)
+		resctrl_arch_unmount();
+
+	mutex_unlock(&resctrl_mount_lock);
+
 	return ret;
 }
 
@@ -3169,6 +3184,8 @@ static void rdt_kill_sb(struct super_block *sb)
 {
 	struct rdt_resource *r;
 
+	mutex_lock(&resctrl_mount_lock);
+
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 
@@ -3187,6 +3204,10 @@ static void rdt_kill_sb(struct super_block *sb)
 	kernfs_kill_sb(sb);
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
+
+	resctrl_arch_unmount();
+
+	mutex_unlock(&resctrl_mount_lock);
 }
 
 static struct file_system_type rdt_fs_type = {
-- 
2.53.0

