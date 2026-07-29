Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAC739060B
	for <patches@lists.linux.dev>; Wed, 29 Jul 2026 17:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785346092; cv=none; b=fwjKUUF9BjVGacFg8psRtNas0hcZHDL1uOyln21pVoneNIStca+bXdvafHUQuei6WHAC7713bXnBu25snUAamcyNh6h7CieopnerzC7OipfumDPITKa7z3s/VeDZ+HpvLefXjHxQEfoF4tAGKIfOvLN6xd6AsO056Jdez4imyQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785346092; c=relaxed/simple;
	bh=mWVZEzDlZtNwUJUexPsoN8ix4vQboGhHSRMINCgPeY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUlhejtA8QxO63vyo3a3grvq5Nm55WZSvy51pbSkcJ7I5QWC4YUeThQ+I9Nwk2wTQcxxatJUYG67Vnfe7k4DqZsITZPzIfsFTYJk932Su5B39Cw2gWBWQhBsHzq3BZyzHaDyW0A63VC+yWtOD9GsXiL/3TY19+Hvo/A62SyrmEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nBxx1zkO; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nBxx1zkO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785346090; x=1816882090;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mWVZEzDlZtNwUJUexPsoN8ix4vQboGhHSRMINCgPeY0=;
  b=nBxx1zkOatvWFhqflKWFiEIR7x8JHCVAK5EHsCE2lOfTYKhoeWYwyDWn
   6k5ymEQRENCM3z7ybKwWDScAZeO40bNT5Dqlq9AW/og8BiaDU6wsNlBcF
   XHFePXjAY5AxhmK0/xz9jpeeptPf8PrEBQLOrKzr4FL0mPgwA9fjcECXg
   YTrCbloV2FpFb8uyyQtiQiWPT9KNbfKE4XvX7Hbr1LM3nQx8rDGG3ajaG
   vw8T01NxMU5Eu5m8ebZbtlKuz5Mj2lE1R0FrWQs1LRZN4ohNBmtnAPG15
   D1P8CHJk9+s5UH3Jyuh69HJVEjs0pTCAHXZMP190VlnKlEGAMSZgvxYcT
   g==;
X-CSE-ConnectionGUID: kz4y0XXRRM2pj9u6io+UlA==
X-CSE-MsgGUID: QPe//IrZRL+wS6gYEZK+Vw==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="97473672"
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="97473672"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:03 -0700
X-CSE-ConnectionGUID: TIir+1jVQIi7woYnDB+gOw==
X-CSE-MsgGUID: LetGeuk8SDKUilw7OiKAew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="262024606"
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
Subject: [PATCH v10 12/17] x86/resctrl: Prepare to handle nested mount requests
Date: Wed, 29 Jul 2026 10:27:47 -0700
Message-ID: <20260729172752.11561-13-tony.luck@intel.com>
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

There is no upper level serialization of mount(2) system calls.

mount/unmount operations can happen in parallel with CPU hotplug events
that need to add/remove files and directories when domains are added or
removed.

Use cpus_read_lock() plus mutex_lock(&domain_list_lock) to protect
architecture code from races.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v10:
	New patch

 include/linux/resctrl.h            |  2 +-
 arch/x86/kernel/cpu/resctrl/core.c | 40 ++++++++++++++++++++++++------
 drivers/resctrl/mpam_resctrl.c     |  3 ++-
 3 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 568a650c0224..65245f2fdad0 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -579,7 +579,7 @@ void resctrl_offline_cpu(unsigned int cpu);
  * Architecture hook called at beginning of first file system mount attempt.
  * No locks are held.
  */
-void resctrl_arch_pre_mount(void);
+int resctrl_arch_pre_mount(void);
 
 /*
  * Architecture hook called when mount fails, or on unmount.
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index e335a143f3e5..906aa4dfc363 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -16,7 +16,6 @@
 
 #define pr_fmt(fmt)	"resctrl: " fmt
 
-#include <linux/cleanup.h>
 #include <linux/cpu.h>
 #include <linux/slab.h>
 #include <linux/err.h>
@@ -807,25 +806,47 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
 	return 0;
 }
 
-void resctrl_arch_pre_mount(void)
+/*
+ * Linux provides no synchronization for mount(2) system calls.
+ * resctrl_arch_pre_mount() and resctrl_arch_unmount() are called
+ * with no locks held. Mount/unmount may also race with CPU hotplug
+ * events that add/remove per-domain files and directories.
+ *
+ * Use cpus_read_lock() plus domain_list_lock to protect operations.
+ *
+ * Keep track locally at the architecture level whether the file
+ * system is mounted (or in process of being mounted).
+ */
+static bool arch_mounted;
+
+int resctrl_arch_pre_mount(void)
 {
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
+	int ret = -EBUSY;
 	int cpu;
 
+	cpus_read_lock();
+	mutex_lock(&domain_list_lock);
+	if (arch_mounted)
+		goto unlock;
+	arch_mounted = true;
+	ret = 0;
+
 	if (!intel_aet_pre_mount())
-		return;
+		goto unlock;
 
 	/*
 	 * Late discovery of telemetry events means the domains for the
 	 * resource were not built. Do that now.
 	 */
-	cpus_read_lock();
-	mutex_lock(&domain_list_lock);
 	r->mon_capable = true;
 	for_each_online_cpu(cpu)
 		domain_add_cpu_mon(cpu, r);
+unlock:
 	mutex_unlock(&domain_list_lock);
 	cpus_read_unlock();
+
+	return ret;
 }
 
 void resctrl_arch_unmount(void)
@@ -833,16 +854,19 @@ void resctrl_arch_unmount(void)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	int cpu;
 
+	cpus_read_lock();
+	mutex_lock(&domain_list_lock);
+	arch_mounted = false;
+
 	if (!r->mon_capable)
-		return;
+		goto unlock;
 
 	intel_aet_unmount();
 
-	cpus_read_lock();
-	mutex_lock(&domain_list_lock);
 	for_each_online_cpu(cpu)
 		domain_remove_cpu_mon(cpu, r);
 	r->mon_capable = false;
+unlock:
 	mutex_unlock(&domain_list_lock);
 	cpus_read_unlock();
 }
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 5859cc0f5e37..71125779484f 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -158,8 +158,9 @@ bool resctrl_arch_get_io_alloc_enabled(struct rdt_resource *r)
 	return false;
 }
 
-void resctrl_arch_pre_mount(void)
+int resctrl_arch_pre_mount(void)
 {
+	return 0;
 }
 
 void resctrl_arch_unmount(void)
-- 
2.55.0

