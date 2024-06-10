Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A05A38
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 00:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717979979; cv=none; b=k5eQCx1e5lcqZHizCg5rxlg9AvcMNt4iQQAl5gGu7V6BzFr9uH5eLclehD9G9nJaR4LWy5fJ2rCLSYi9lpH+5x5+xIGcG55za1e/Xbty97VzTZm9yYc6g8ai5yrAUmFrnzT5oadyf6AtTE1SIL3TlgUTc+EuV7dPph3mqBikRVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717979979; c=relaxed/simple;
	bh=MaTT5NLRLK/9xjGGntVtiy1F2BB5m4kTBp+KyL/z3eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+2o1yLRSsbqtZ7ZlS+R4TwxLTjbyqcxF6PCYToQvB7aN3cisekhQQTEODchuglXKHzBEmdIUllu7f5AYFQrtq8ueru+bgP6eAYbmqLrVcE3pmCBG9I1/G0uqMIbdR44eVuJQg/5HQuRFNIfgxNZxyETyqMxbULEzZac4jtSjuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DLZ2pOhV; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DLZ2pOhV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717979977; x=1749515977;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MaTT5NLRLK/9xjGGntVtiy1F2BB5m4kTBp+KyL/z3eQ=;
  b=DLZ2pOhVv7D5dNCT1lYWymfcdr++jMXJwVmsxJiELIpstna0wpJqOzPN
   7tyzb8YoNsugGsXczGItwo5/Wwq4S3Fl5h8lINts/9d6WY4XCKUpSjIM8
   2rsRb+me/h3nU05RNZMXINDOjx+mUmfdED7I84iej++oMmYaiRX2naHld
   dppzwh07p41enObc/XAEvAdOaopfVyTJrdqB6k6/gZF+hC1xi/TrWqOdd
   CkF+qMiTd93ZvWox70EinYQvzEzi6FoSSCdi5mbietrA8qLUBLJzMDLek
   lh4PXI0sf1evK3VlJu9pL3Twn+sbglOjw88NP0+uHltOODQM9tr9Y96i2
   Q==;
X-CSE-ConnectionGUID: mFTJpXJeQ86xuMz6Hd9/VA==
X-CSE-MsgGUID: /TwDDxGFRDuZEGy9oZUifw==
X-IronPort-AV: E=McAfee;i="6600,9927,11098"; a="37154971"
X-IronPort-AV: E=Sophos;i="6.08,226,1712646000"; 
   d="scan'208";a="37154971"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2024 17:39:36 -0700
X-CSE-ConnectionGUID: kfPTOPqQRnKuDbP8IIMMew==
X-CSE-MsgGUID: LwlmMSKfSraYitRhRBs3ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,226,1712646000"; 
   d="scan'208";a="38829881"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2024 17:39:36 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 2/4] cpu: Drop "extern" from function declarations in cpuhplock.h
Date: Sun,  9 Jun 2024 17:39:25 -0700
Message-ID: <20240610003927.341707-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240610003927.341707-1-tony.luck@intel.com>
References: <20240610003927.341707-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This file was created with a direct cut and paste from cpu.h so
kept the legacy declaration style.

But the Linux coding standard for function declarations in header
files is to avoid use of "extern".

Drop "extern" from all function declarations.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/cpuhplock.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/cpuhplock.h b/include/linux/cpuhplock.h
index d42d2434dab6..999f475bea98 100644
--- a/include/linux/cpuhplock.h
+++ b/include/linux/cpuhplock.h
@@ -15,18 +15,18 @@ struct device;
 extern int lockdep_is_cpus_held(void);
 
 #ifdef CONFIG_HOTPLUG_CPU
-extern void cpus_write_lock(void);
-extern void cpus_write_unlock(void);
-extern void cpus_read_lock(void);
-extern void cpus_read_unlock(void);
-extern int  cpus_read_trylock(void);
-extern void lockdep_assert_cpus_held(void);
-extern void cpu_hotplug_disable(void);
-extern void cpu_hotplug_enable(void);
+void cpus_write_lock(void);
+void cpus_write_unlock(void);
+void cpus_read_lock(void);
+void cpus_read_unlock(void);
+int  cpus_read_trylock(void);
+void lockdep_assert_cpus_held(void);
+void cpu_hotplug_disable(void);
+void cpu_hotplug_enable(void);
 void clear_tasks_mm_cpumask(int cpu);
 int remove_cpu(unsigned int cpu);
 int cpu_device_down(struct device *dev);
-extern void smp_shutdown_nonboot_cpus(unsigned int primary_cpu);
+void smp_shutdown_nonboot_cpus(unsigned int primary_cpu);
 
 #else /* CONFIG_HOTPLUG_CPU */
 
-- 
2.45.0

