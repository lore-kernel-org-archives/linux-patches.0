Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A4F1D5160
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 18:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787681737; cv=none; b=RNsSyyw+4bxO3aa9WM2nCPHvM0/Mm1IObmwinaCFwE8ZTEwXX2QU1d5FL0U/AM5EkeFQAoT5/6wwtkLqa9fhbUoG6KGu/bRL4tkGwwlLFyhvglZKBtOaDK7NzQqedUapcacqh41q1zcYW5iOrW6hqxFtquVqGqACtMHy6BcH4Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787681737; c=relaxed/simple;
	bh=C4Hw0dpWxnLm2zqjWobf/Gjv3zcKQWi2XEYwTIGVV98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdpOVMHZRUwrsbFmVoQ7YxEdVu8QZME6KRkAeC8rMLQvam908TISLkm6246X9guomIlm9Ozb7b/xxG7BZdM9Ct/MFfoiqRE2sXMpvA28KKCQvOuuCTUOsobAO43XL0zxSBUFR71UL4lbYZbRGtvjLEo7Uv6rhiEN9/ngVOwSADg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N7aZnNIF; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N7aZnNIF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787681735; x=1819217735;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C4Hw0dpWxnLm2zqjWobf/Gjv3zcKQWi2XEYwTIGVV98=;
  b=N7aZnNIFbYH72dGismo79mcd3a+y1VdB1YpDHDDrBQWeuM5E3rs0O8GO
   3ghdSL2sIJQYxLsbHUNAi61anwfIa+KREg/40S7bIvNIUKYhHDBNswPvN
   NiVSudgIb4m8AkvH3iA4kQ0cf0E8cN/0R3VByIYKfWvyYgTB+5LV4p4YG
   P3ts/nXoCetL53G2KEosYQb252cQ9g4Q6Vt3jJ6VuGdSMNSpNSWc/XiTh
   KqAgKD8S/FyKNdofsJ2KZ8WMMOSBUy2hfX4FkZzaLbICEk9KuD/x8SA+V
   ACxjcm5c/GrOocf1N70lojZhweJk2jPRPJOgcqCUhgDB3kdtd4hfKCmVA
   w==;
X-CSE-ConnectionGUID: 55olNoBySJORldm2NUqGAA==
X-CSE-MsgGUID: BabfV4SCSQyaa6J3rekr6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="88174200"
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="88174200"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 11:15:33 -0700
X-CSE-ConnectionGUID: ZTMJkrCzT8agKRfoAVrQSg==
X-CSE-MsgGUID: 97HmDp8mRvyALdPrknG9GQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="265559594"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.141])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 11:15:33 -0700
From: Tony Luck <tony.luck@intel.com>
To: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hansg@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>,
	Breno Leitao <leitao@debian.org>,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 1/7] cacheinfo: Export get_cpu_cacheinfo_id() for loadable modules
Date: Tue, 25 Aug 2026 11:15:20 -0700
Message-ID: <20260825181526.13203-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825181526.13203-1-tony.luck@intel.com>
References: <20260825181526.13203-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

Loadable drivers that track bitfix filter state need the cache ID to
distinguish shared cache instances. Without access to the cache ID, CPUs
sharing the same cache cannot be associated with the same tracking state.

The existing helper cannot be used by loadable modules because it depends
on a non-exported symbol, preventing the such drivers from building as
a module.

Export get_cpu_cacheinfo_id() so loadable modules can retrieve cache IDs
through a common cacheinfo interface.

Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/cacheinfo.h | 12 +-----------
 drivers/base/cacheinfo.c  | 17 +++++++++++++++++
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/include/linux/cacheinfo.h b/include/linux/cacheinfo.h
index fc879ac4cc4f..56fa646df0d1 100644
--- a/include/linux/cacheinfo.h
+++ b/include/linux/cacheinfo.h
@@ -82,6 +82,7 @@ struct cpu_cacheinfo {
 };
 
 struct cpu_cacheinfo *get_cpu_cacheinfo(unsigned int cpu);
+int get_cpu_cacheinfo_id(int cpu, int level);
 int early_cache_level(unsigned int cpu);
 int init_cache_level(unsigned int cpu);
 int init_of_cache_level(unsigned int cpu);
@@ -137,17 +138,6 @@ static inline struct cacheinfo *get_cpu_cacheinfo_level(int cpu, int level)
 	return NULL;
 }
 
-/*
- * Get the id of the cache associated with @cpu at level @level.
- * cpuhp lock must be held.
- */
-static inline int get_cpu_cacheinfo_id(int cpu, int level)
-{
-	struct cacheinfo *ci = get_cpu_cacheinfo_level(cpu, level);
-
-	return ci ? ci->id : -1;
-}
-
 #if defined(CONFIG_ARM64) || defined(CONFIG_ARM)
 #define use_arch_cache_info()	(true)
 #else
diff --git a/drivers/base/cacheinfo.c b/drivers/base/cacheinfo.c
index 70701d3bc81c..28d193bf6064 100644
--- a/drivers/base/cacheinfo.c
+++ b/drivers/base/cacheinfo.c
@@ -38,6 +38,23 @@ struct cpu_cacheinfo *get_cpu_cacheinfo(unsigned int cpu)
 	return ci_cacheinfo(cpu);
 }
 
+/**
+ * get_cpu_cacheinfo_id - Return the cache ID for a CPU and cache level
+ * @cpu: CPU number
+ * @level: Cache level
+ *
+ * The caller must hold the cpuhp lock.
+ *
+ * Return: Cache ID on success, or -1 if no matching cache exists.
+ */
+int get_cpu_cacheinfo_id(int cpu, int level)
+{
+	struct cacheinfo *ci = get_cpu_cacheinfo_level(cpu, level);
+
+	return ci ? ci->id : -1;
+}
+EXPORT_SYMBOL_GPL(get_cpu_cacheinfo_id);
+
 static inline bool cache_leaves_are_shared(struct cacheinfo *this_leaf,
 					   struct cacheinfo *sib_leaf)
 {
-- 
2.55.0

