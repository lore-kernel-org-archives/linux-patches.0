Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526D8390CBF
	for <patches@lists.linux.dev>; Wed, 29 Jul 2026 17:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785346094; cv=none; b=Cs5yMnii7OMypG9WzjpnlDiPcbky/Lin2zm746MZPywffx8VgF0+WYdLjLFmZuUQmZsSUZYkOzL1wT7OnJF2+KwX/o0WrchhGpMQ8StRJuuhnwn6PAqoLzJfiMQ2/Th/QMbLFjJsvcydAn5OMoQcFvyalPnnChSBecnxw8icU10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785346094; c=relaxed/simple;
	bh=1FdEg/UZ9Xp0GoVXeNtjBirJm6FyFDzslgcIi6zqvZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQBW0XiwXD6kMwT4JSyD7ED2iMtGPgG3n3ogOpcpBjhetYNcX9ABIS36v1tfvXlb/vwd0Uzjxbyx7B8MksvyH5gvpghaNML7LcuxnbyclGRx/9KTDVxKuicf0hxugd32/4vRUbAz7JH9jjQxrOM2cHD9bC76U1PhjqV7vojP/ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R6mVZT5K; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R6mVZT5K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785346092; x=1816882092;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1FdEg/UZ9Xp0GoVXeNtjBirJm6FyFDzslgcIi6zqvZE=;
  b=R6mVZT5K1UOpwdSy1wdGP0VXylRTvpf8x8diAn0qQxZh9TnyqfFu+EtA
   +vSkUBzhQ3Js5GC9EvJ7mHcc7ifE8JziUj1kP3b4vnz7dmaxBuidReJCS
   vauVzfZODO0VOlLc18B11Bty/lyKbqXqujA1sbD5KTkvbvxJP6nh+xh7l
   yMrvYeMAS0kmaoTV3Oiut5nwKyRV1UfwqHjthnFbV1mbnwGzWV+k4uLlt
   xBOlgMSa/p7PZ+cxA3NqXQ+wmpQd0ghId6yRYZ36Dkrd+mHn+wZ2Fqlvh
   mDN3vlfjC85UhMdEcPdrxtm/qPCu5wbdV20Xpwg5ZwsI7GdOvpeeE/GGi
   A==;
X-CSE-ConnectionGUID: hPooRz42TSKARcXonUzbTA==
X-CSE-MsgGUID: Ghi+SOS1TMWVPdm6zJltrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="97473685"
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="97473685"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:03 -0700
X-CSE-ConnectionGUID: l03TEhNIRIyAyRqQ1uo1oA==
X-CSE-MsgGUID: Mc4FLG6/QZ6hd8Bxw63yLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="262024610"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.238])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:02 -0700
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
Subject: [PATCH v10 13/17] fs/resctrl: Call architecture hooks for every mount/unmount
Date: Wed, 29 Jul 2026 10:27:48 -0700
Message-ID: <20260729172752.11561-14-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729172752.11561-1-tony.luck@intel.com>
References: <20260729172752.11561-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The intel_pmt module should only be pinned while the resctrl file system
is mounted.

Add hooks for every mount/unmount of the resctrl file system so that
architecture code can increment the intel_pmt module reference count on
mount and decrement on unmount.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v10:
	Don't call resctrl_arch_unmount() when failing a nested mount.

 include/linux/resctrl.h |  2 +-
 fs/resctrl/rdtgroup.c   | 12 ++++++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 65245f2fdad0..1e4ca75a02de 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -576,7 +576,7 @@ void resctrl_online_cpu(unsigned int cpu);
 void resctrl_offline_cpu(unsigned int cpu);
 
 /*
- * Architecture hook called at beginning of first file system mount attempt.
+ * Architecture hook called before attempting to mount the file system.
  * No locks are held.
  */
 int resctrl_arch_pre_mount(void);
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 0a9645c35f43..6f12537f89b7 100644
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
@@ -3166,6 +3165,8 @@ static void resctrl_unmount(void)
 	resctrl_mounted = false;
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
+
+	resctrl_arch_unmount();
 }
 
 static int rdt_get_tree(struct fs_context *fc)
@@ -3175,9 +3176,11 @@ static int rdt_get_tree(struct fs_context *fc)
 	struct kernfs_node *rdt_root_kn;
 	struct rdt_l3_mon_domain *dom;
 	struct rdt_resource *r;
+	bool cleanup = true;
 	int ret;
 
-	DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
+	if (resctrl_arch_pre_mount() == -EBUSY)
+		return -EBUSY;
 
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
@@ -3186,6 +3189,7 @@ static int rdt_get_tree(struct fs_context *fc)
 	 */
 	if (resctrl_mounted) {
 		ret = -EBUSY;
+		cleanup = false;
 		goto out;
 	}
 
@@ -3316,6 +3320,10 @@ static int rdt_get_tree(struct fs_context *fc)
 out:
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
+
+	if (cleanup)
+		resctrl_arch_unmount();
+
 	return ret;
 }
 
-- 
2.55.0

