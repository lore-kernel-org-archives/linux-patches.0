Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0137423170
	for <patches@lists.linux.dev>; Wed, 29 Apr 2026 18:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777488566; cv=none; b=QFQp2OSWfTQ1PBfjTHFCvhz6p0hKd0PK1Ux0mw1AaOjSC/Ux1eI2tk1STDbfYgGMGZEqH2KP9lRL3payOtv/g6NbWzdNFaB7N/4DQyE7pnp1N7YKbfex770j9nTIv45yGCJSL2mJuWsuqb1g027XO/Zsrnv+FMZBBbrtutYzjWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777488566; c=relaxed/simple;
	bh=xNTNK/75KML/j4U9TRC6Wx+YLGkaG8GrlGihkDxsK+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DouxOY/dmqirZsVsjr/t6xIPGQQdBStaCs0Zzbbi71ZbIX57fhVGPf+65fVe3cjK7Fxy094rW4uqB5Xqtxvoy5y2KqPNp9h2eX5mbxsPdXpITZAE91OCuW3HkSfOM0lVu7YdMfcOoLOiDUjDtW+0loIq5suR4amDkmbCCdwUz0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FEVVFPNs; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FEVVFPNs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777488561; x=1809024561;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xNTNK/75KML/j4U9TRC6Wx+YLGkaG8GrlGihkDxsK+8=;
  b=FEVVFPNskkGWDGl5PddTLFybS953oWGV+lIC4S3CqNazdKOHWBarAkNq
   KQP/CJV7h4hWuxsrx05Ul6YjJwD6OR1y+pxV/SzMZ03D2UbxFXBRt6p9d
   REoKoYqTA5UqFhPqweKqqVjtcnHUjuOqp40QW23oKFejfhQ0Y+qZCfy9T
   5hoQJMDJ/aWJpY4e+el0oRvSqW/5jv87+/UXrD+W0SEyCG0OpC2UVBuPz
   w3y4Aj5PVAgNlqb11le1eRArFgRMDloUUs5uEiGQm8nRIv3UDSeqPWFfu
   96uVoWWyI75JRCUwRnIePhkYNynjmZtkz4vPGIUzfnRhf9ASwdCFYifzd
   w==;
X-CSE-ConnectionGUID: z1DwkRIGTyG9qY4neuxG3A==
X-CSE-MsgGUID: 9PvqyIf7Q5eJu2CZdFfcdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="89890755"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="89890755"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:49:09 -0700
X-CSE-ConnectionGUID: wFpEGzeURE6/rw7YT1dcfg==
X-CSE-MsgGUID: 9ubC7sEHRl2OQPcNGkR1/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="238323040"
Received: from mjruhl-desk.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.13])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:49:08 -0700
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
Subject: [PATCH v6 08/10] fs/resctrl: Call architecture hooks for every mount/unmount
Date: Wed, 29 Apr 2026 11:48:56 -0700
Message-ID: <20260429184858.36423-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429184858.36423-1-tony.luck@intel.com>
References: <20260429184858.36423-1-tony.luck@intel.com>
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

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h | 7 +++++--
 fs/resctrl/rdtgroup.c   | 9 +++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 9534d42e0c57..e8a87c3664db 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -552,12 +552,15 @@ void resctrl_online_cpu(unsigned int cpu);
 void resctrl_offline_cpu(unsigned int cpu);
 
 /*
- * Architecture hook called at beginning of first file system mount attempt.
+ * Architecture hook called before attempting to mount the file system.
  * No locks are held.
  */
 void resctrl_arch_pre_mount(void);
 
-/* Called to report unmount. */
+/*
+ * Architecture hook called when mount fails, or on unmount.
+ * No locks are held.
+ */
 void resctrl_arch_unmount(void);
 
 /**
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 2e31ff753114..134ad69de194 100644
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
@@ -2790,7 +2789,7 @@ static int rdt_get_tree(struct fs_context *fc)
 	struct rdt_resource *r;
 	int ret;
 
-	DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
+	resctrl_arch_pre_mount();
 
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
@@ -2899,6 +2898,10 @@ static int rdt_get_tree(struct fs_context *fc)
 	rdt_last_cmd_clear();
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
+
+	if (ret)
+		resctrl_arch_unmount();
+
 	return ret;
 }
 
@@ -3191,6 +3194,8 @@ static void rdt_kill_sb(struct super_block *sb)
 	kernfs_kill_sb(sb);
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
+
+	resctrl_arch_unmount();
 }
 
 static struct file_system_type rdt_fs_type = {
-- 
2.53.0

