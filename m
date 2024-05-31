Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDDC79B84
	for <patches@lists.linux.dev>; Fri, 31 May 2024 19:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717185455; cv=none; b=QDCisfG72EKVjhgqNyKD2fadUxtvFW624dtdNN3oVDayjWHPyEwuq64cMPr6+foeDJF18XrneBfvho7BoMyfkq7z/3THS4Rb2A8NHXF2pPhR0tneL/JOyH1atTHlC+dwnGHZFuByQqo7c1jlNlXuGUi6A3Cm0QOam6BgNpQKMrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717185455; c=relaxed/simple;
	bh=o83mz7amY+OfaedT6o7+b/lkwfPSdChdBSbbCqdXIZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSmrgiG/cI2fuapLrTgESuJARI8ijG1T0PHqhHSxWCCSHQAYR/TSHjVdnuJ0S7H2cVEdqM0tExs7UimL+r5w3/utG2vaRo2n+KcROTYYM8nSmZv77iUiagJoQyLXjpbyVHXYvc9jZwrwZWsqGT+cQUIbX0hYXBBWgNPlwYntj90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U1XCfE7E; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U1XCfE7E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717185453; x=1748721453;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o83mz7amY+OfaedT6o7+b/lkwfPSdChdBSbbCqdXIZU=;
  b=U1XCfE7Ex1kiYgk8UsX/twus1KIx2LmjBbeuf13hKM9+dHKAtFWae4ae
   PaXZY6vjDBAK83y815z8ySZRD9YIYvaOIaSw32Jf7cD6QcXRccv9XLKwz
   LPOYe/jowt1UNuBKsYwVvEslP/RjKoT9yBTdbv3MrBYEWU/mWwp8X1Lil
   z8Gh085fqOJlaZq23HHm88NxnOuqCxNh3cicF5aNZNY7rYQXG1b+57TpN
   4DAackRe3yLpsZvJFrN4XYFpycNW9QtjL9cdT10COfaqgFj8eyu+rWCr0
   RK3V7XF1bewKFh4RiUVLiah3849UL7RO0AgsYjqk7cvGKS+baEVHzUtrh
   A==;
X-CSE-ConnectionGUID: UzAt0aNfT5KP7b4/Kd/MNQ==
X-CSE-MsgGUID: zH+Kt6cbSZqt491bOlPq+Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="13501138"
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="13501138"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 12:57:32 -0700
X-CSE-ConnectionGUID: Bxe7bMbyT9CbNwD0OsZ/Tw==
X-CSE-MsgGUID: qpP2GZ2DQUezfaQV8RgBSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="59438870"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 12:57:32 -0700
From: Tony Luck <tony.luck@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
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
Subject: [PATCH 1/3] cacheinfo: Add function to get cacheinfo for a given (cpu, cachelevel)
Date: Fri, 31 May 2024 12:57:18 -0700
Message-ID: <20240531195720.232561-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240531195720.232561-1-tony.luck@intel.com>
References: <20240531195720.232561-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Resctrl code open codes a search for information about a given cache
level in a couple of places (and more are on the way).

Provide a new inline function get_cpu_cacheinfo_level() in
<linux/cacheinfo.h> to do the search and return a pointer to
the cacheinfo structure.

Simplify the existing get_cpu_cacheinfo_id() by using this new
function to do the search.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/cacheinfo.h | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/cacheinfo.h b/include/linux/cacheinfo.h
index 2cb15fe4fe12..301b0b24f446 100644
--- a/include/linux/cacheinfo.h
+++ b/include/linux/cacheinfo.h
@@ -113,10 +113,10 @@ int acpi_get_cache_info(unsigned int cpu,
 const struct attribute_group *cache_get_priv_group(struct cacheinfo *this_leaf);
 
 /*
- * Get the id of the cache associated with @cpu at level @level.
+ * Get the cacheinfo structure for cache associated with @cpu at level @level.
  * cpuhp lock must be held.
  */
-static inline int get_cpu_cacheinfo_id(int cpu, int level)
+static inline struct cacheinfo *get_cpu_cacheinfo_level(int cpu, int level)
 {
 	struct cpu_cacheinfo *ci = get_cpu_cacheinfo(cpu);
 	int i;
@@ -124,12 +124,23 @@ static inline int get_cpu_cacheinfo_id(int cpu, int level)
 	for (i = 0; i < ci->num_leaves; i++) {
 		if (ci->info_list[i].level == level) {
 			if (ci->info_list[i].attributes & CACHE_ID)
-				return ci->info_list[i].id;
-			return -1;
+				return &ci->info_list[i];
+			return NULL;
 		}
 	}
 
-	return -1;
+	return NULL;
+}
+
+/*
+ * Get the id of the cache associated with @cpu at level @level.
+ * cpuhp lock must be held.
+ */
+static inline int get_cpu_cacheinfo_id(int cpu, int level)
+{
+	struct cacheinfo *ci = get_cpu_cacheinfo_level(cpu, level);
+
+	return ci ? ci->id : -1;
 }
 
 #ifdef CONFIG_ARM64
-- 
2.45.0

