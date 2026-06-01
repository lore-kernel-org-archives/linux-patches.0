Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925483D88F6
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 19:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780343817; cv=none; b=Jy25/3ae9fTg3eqfJ+U4/bLO8yG2xMbEXvrmyvZE3tTAkJETeq22AQtf8LFNP8mVk7s0XvoNVw3bw3cQb++GgX7mTkP7F4PtHvvdyzQEb5OIp0bsh2S/z22CuzLBsg0UjB93qUt8dZ7Sx1N9w1uyLoLWFJFKlXuDKN7O1tJiGas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780343817; c=relaxed/simple;
	bh=vhcRn5GflIKPR5TdRF784Mb9z/uJDX2D/dGTqB0zBZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYPJTNPrY7siaPXHyDulpvcvW1QjvIWc6eloPvHmxxywcBvYXnrws/xnj/4owRNOvQiiy0heyroIAvSndMQ0Q1uU5t3TTM+w0WNpqa6dmj/rs7Lx/VX3kFvibIi+EULAOSd7X2UkZlShFcGHiMhgOvG0m2ES9rGha5nQgc0EiLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lm7KFjdM; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lm7KFjdM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780343816; x=1811879816;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vhcRn5GflIKPR5TdRF784Mb9z/uJDX2D/dGTqB0zBZM=;
  b=Lm7KFjdMcDYDbLfm5G/MViHj9im+NMcjwUNbtFQtwsHmvCTtlfuZnP/s
   xIbjuACiw4oxIW30JRfxfeC9/XTE7xkTeTZQoFcMnLsBaIe37kIBVpT52
   b+pW/Gu3T5IvKvDPoIrVA240bw41SZQZjVGZoQSPLaxqPu6oV4qJSSsBu
   qE0D0NXtAjkLBf4WyKMNANON6pkBdv0nfexQA60vDjMdczcZie3G2Lw+p
   nZMbDzFAFRx1HUrVUcIBFm+KQqyW+aEw8v8Q7oikPES94LZQaBwMzuwmr
   rw2iFbVlf5WqOO/HsbxaIEuZwA8awoGAUdVCjcSl0PPC6HFoTo/QqmxzT
   g==;
X-CSE-ConnectionGUID: D9HL2HahT9SaOqwWWki2LA==
X-CSE-MsgGUID: amMHQibmRu2doVJ5MLE7mA==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="81011661"
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="81011661"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:45 -0700
X-CSE-ConnectionGUID: 9hbvjgPCQAuM1F2KaksV6A==
X-CSE-MsgGUID: ISHGNnS5Qt+G+rxgoVQsyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="247946529"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.168])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:44 -0700
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
Subject: [PATCH v7 12/14] fs/resctrl: Call architecture hooks for every mount/unmount
Date: Mon,  1 Jun 2026 12:56:30 -0700
Message-ID: <20260601195632.15876-13-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601195632.15876-1-tony.luck@intel.com>
References: <20260601195632.15876-1-tony.luck@intel.com>
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
index 6d647b71c5db..195ebb15c5f0 100644
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
@@ -3147,6 +3148,10 @@ static int rdt_get_tree(struct fs_context *fc)
 out:
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
+
+	if (ret)
+		resctrl_arch_unmount();
+
 	return ret;
 }
 
-- 
2.54.0

