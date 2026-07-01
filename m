Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844CA3CC33C
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 21:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782941770; cv=none; b=O5Ulkaa0+uqMdlbnEvjgnloYCrfpktI/4BWH2FtTU9mBLGaa25Rc48zIBpKMQhISs29+wGTmPoPljze64QvQkyxR3luP+8sNQMAAYLs+W41Z3U5fFHjKBj4xBK6b9scjqoa1cbnuUKlDgje3sH0T3Ke3zJdB/FgjJDdr+zwVX14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782941770; c=relaxed/simple;
	bh=M63gvpVzATWCN7q9Uo+8+WosNzHmET0sJyy7GVQM3b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePhqVHrOE278+AUP6vOY6k5sjIkKLK/WHlXkRLvjQSGbiLN1KiHbxI/9o/2VhxiokLA0SfyQqxGuVCJtO2lGRYxBtNVXqPmRDpYWCXxMppviNGabNh1liyg3rOkEZwaqAujlNyhY1S3n+SvFxYuMxHOj0HcNk9UJV1fLvvZNKPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F3fjwRdv; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F3fjwRdv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782941770; x=1814477770;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M63gvpVzATWCN7q9Uo+8+WosNzHmET0sJyy7GVQM3b4=;
  b=F3fjwRdv0htj2QCn/OISojg71NxB+J0z3Xw/+dpGAu/m3ztkeCJuJNIP
   0Nnu7HW3LWabrmh6mjon/btqvVLUwOTMyWoJZY+IH1y9ear9knJER7A6e
   ldDsiZgiyZnu2onIp2hGw0OC910xmitVRYhnwNK9knYglg1fbRsX44hd6
   GV5nsAgPkWbIHyEc9b8bJ6ycjR6CptWDfx5/ssU27swVwEY4MFaDQoAa0
   jzS9oZlkxq2godduRYqN4mOsZqsZ+beqv/xoJiULfmHDxtQ7BP8YiYAus
   Ps84QKxSbEshm58vHhIx8tDxqIcXSeNmGlL5tcZk2m91ugDOPV/xetZVK
   g==;
X-CSE-ConnectionGUID: WGZTyeEPQjOPYKmxFAbZNg==
X-CSE-MsgGUID: BsD9MjOuQnCLsQTI6BuXCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11834"; a="94285832"
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="94285832"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:05 -0700
X-CSE-ConnectionGUID: xozZy37XSli0uUBXhQy43w==
X-CSE-MsgGUID: forGSD8dT7SEiRCBnecDYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="252242551"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.120])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:05 -0700
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
Subject: [PATCH v9 10/12] fs/resctrl: Call architecture hooks for every mount/unmount
Date: Wed,  1 Jul 2026 14:35:51 -0700
Message-ID: <20260701213553.15222-11-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260701213553.15222-1-tony.luck@intel.com>
References: <20260701213553.15222-1-tony.luck@intel.com>
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
 include/linux/resctrl.h | 2 +-
 fs/resctrl/rdtgroup.c   | 8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 4dc41dc99dc2..483a50df7ae6 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -559,7 +559,7 @@ void resctrl_online_cpu(unsigned int cpu);
 void resctrl_offline_cpu(unsigned int cpu);
 
 /*
- * Architecture hook called at beginning of first file system mount attempt.
+ * Architecture hook called before attempting to mount the file system.
  * No locks are held.
  */
 void resctrl_arch_pre_mount(void);
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 763e4191d717..96a337156f3c 100644
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
@@ -3168,6 +3167,8 @@ static void resctrl_unmount(void)
 	resctrl_mounted = false;
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
+
+	resctrl_arch_unmount();
 }
 
 static int rdt_get_tree(struct fs_context *fc)
@@ -3179,7 +3180,7 @@ static int rdt_get_tree(struct fs_context *fc)
 	struct rdt_resource *r;
 	int ret;
 
-	DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
+	resctrl_arch_pre_mount();
 
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
@@ -3318,6 +3319,9 @@ static int rdt_get_tree(struct fs_context *fc)
 out:
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
+
+	resctrl_arch_unmount();
+
 	return ret;
 }
 
-- 
2.54.0

