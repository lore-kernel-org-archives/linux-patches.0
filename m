Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09884360EE4
	for <patches@lists.linux.dev>; Mon, 15 Jun 2026 18:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781547919; cv=none; b=EqPFjdpjZ5PvuWOaInpNoffDgCPYQ1HR+NwaggK8L+cT8Q5kc4ET4+F0c+JdDgsXwuOafvO5fqogkCIg2tqDAcu3quIS8+eJMb2YMjv4sqTc5wTpAHCFjVohi+Zid5KJzWzlj7mbfu9dF0Rpc7irElRHDM43b/+P9TQO5S+3Eek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781547919; c=relaxed/simple;
	bh=W0q/LR+GtRRWTrCUuqYhoRcxdKm7RXJuhll57sFPUTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmBS8LLefU1R3PiYYxi9QnJaJqEW08EVXxJvxJX6c2zhfTMmR31aqTptgkUIwbSoyAcJSO0kT76YdDsGe+7w72oS1vV0xAfYUS1LW1dhB41Cdfzsd3sbzdGH7mXcJcZ3Y+Dz/GRFZxZWI/IL1MLd6fuUL9S853N8Nrr8OSP3gXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hujQWrBO; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hujQWrBO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781547918; x=1813083918;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W0q/LR+GtRRWTrCUuqYhoRcxdKm7RXJuhll57sFPUTk=;
  b=hujQWrBOT5Tx64eGhPeYmTRWe/6VokMNGDLOr0eVKnrrfGqpUNgZpvIU
   PnBdXAmnEoTnnGQAjavTfLx1fdC3kcfkVeAVyOQRgeeuaRYR6JuW4RIaG
   4JvXJ2/VvQFmTMXNqHOXQfCN2AZXMAEW7qXENy2f8OH7neqG/UWDLak+2
   FqJNtbwTOxi0/u6aMV3P1KLEIh+SaIh2qhZ29fV6cESdWOguhBmP2mLnb
   voOQ++h9uMwOCLJp8hQKh2i0fjjasDMY6LA7BlQ7EegJUbgQJvouAxM2O
   mK5n8VzQG5exrC35xbUNOZm/R9kma64i6WcczOeMBFBSjDaW9OoL3ul8u
   A==;
X-CSE-ConnectionGUID: 7VEGeYFPSSau4Ot0ZiJJ7A==
X-CSE-MsgGUID: vTX2ClnjToehbrAh74WmYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11818"; a="93790047"
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="93790047"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:12 -0700
X-CSE-ConnectionGUID: Qtyql3TrQeCf4FLtOe5S4A==
X-CSE-MsgGUID: 5KIqEC6eTweLjoRFzwIC7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="247620660"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.121])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:12 -0700
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
Subject: [PATCH v8 14/16] fs/resctrl: Call architecture hooks for every mount/unmount
Date: Mon, 15 Jun 2026 11:24:55 -0700
Message-ID: <20260615182457.14725-15-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260615182457.14725-1-tony.luck@intel.com>
References: <20260615182457.14725-1-tony.luck@intel.com>
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
v8:
	Remove check for "ret" in rdt_get_tree() error path

 include/linux/resctrl.h | 2 +-
 fs/resctrl/rdtgroup.c   | 8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index ace41847da46..e23458bb6e4c 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -554,7 +554,7 @@ void resctrl_online_cpu(unsigned int cpu);
 void resctrl_offline_cpu(unsigned int cpu);
 
 /*
- * Architecture hook called at beginning of first file system mount attempt.
+ * Architecture hook called before attempting to mount the file system.
  * No locks are held.
  */
 void resctrl_arch_pre_mount(void);
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index ee948787f9db..ecb638088896 100644
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
@@ -2998,6 +2997,8 @@ static void resctrl_unmount(void)
 	resctrl_mounted = false;
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
+
+	resctrl_arch_unmount();
 }
 
 static int rdt_get_tree(struct fs_context *fc)
@@ -3009,7 +3010,7 @@ static int rdt_get_tree(struct fs_context *fc)
 	struct rdt_resource *r;
 	int ret;
 
-	DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
+	resctrl_arch_pre_mount();
 
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
@@ -3148,6 +3149,9 @@ static int rdt_get_tree(struct fs_context *fc)
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

