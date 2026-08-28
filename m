Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04605348C7D
	for <patches@lists.linux.dev>; Fri, 28 Aug 2026 15:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787931018; cv=none; b=H2Q8wNBb18B/eMW6y2F/yLTkshy+u/2WjmkGsIO9LbrrDCHGz9hemUUHLhaM7N/lSdZPl+P5ONqLGHrAUnrqwhzNJ87f3sfJfsWe1Xh43dWy5ooruoLl8RM5FRpbT+OPySk9F6PeYDiE2RGHmvmXyQu8J/WnYxnSmMxSeG3iRd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787931018; c=relaxed/simple;
	bh=nnHlv8oO55P0LwkFNxkXh4+Oe4hBeg+9+D4lDzARXs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlVESlixhZCJ/uNJLlq8VEH7WxcgfGQiNd8yZ48x1MSpEURASMYoZEARi+v2g0qgCdAAp7FKhdevWErFO84XMPwFCwIfTRkTK1G52b7w2VSL50IdIMJd6PAkD40AtVHkOkBgPVUyg7B3ZDGyeXgIyQ6DBQFjktXG9nSB0tzXTmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nADjzwxG; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nADjzwxG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787931014; x=1819467014;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nnHlv8oO55P0LwkFNxkXh4+Oe4hBeg+9+D4lDzARXs8=;
  b=nADjzwxGHExhAXXZcFFaKFxjxaYN0vERQYB/8teneYbmCeB+CUz8wYEq
   bz0SFC+GGTInKIX/Md4ZmVxwhL3MePKxZAsTphCnGIV1cZS0DIvh79+LN
   VIUBTD76DreT2dfCNuL79qNFYiWxEtytFyXsA+fgtiHgOhGlszRtD4bwk
   HwbYBy7iGFo/ctI/ZXn1p52dj0ZaYA3rdrUkMWsPOefILVK+FUJmnF+X5
   6ciVVR9rH1nXceu2Pby9VSnrW8rx84voU8/XXMp4VLnghHppHQ4VNj8Oz
   +vRjan8+iltZ0X3E9NeO3hRM+X3Q5z24a3cwIUAwgETs3sZ/WRtF5/lnr
   Q==;
X-CSE-ConnectionGUID: WhOY1fIJT9S0T3UhC6CyeA==
X-CSE-MsgGUID: HO7W725LRviQvYRHmECO8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11889"; a="99104583"
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="99104583"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 08:30:09 -0700
X-CSE-ConnectionGUID: BFdpWAV6Q720PoHIAxKKpg==
X-CSE-MsgGUID: BOYpFh9aQQ6KA/dfGVeAhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="291682272"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.223.138])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 08:30:09 -0700
From: Tony Luck <tony.luck@intel.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Breno Leitao <leitao@debian.org>,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v2 1/7] cacheinfo: Export get_cpu_cacheinfo_id() for loadable modules
Date: Fri, 28 Aug 2026 08:29:56 -0700
Message-ID: <20260828153002.10290-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260828153002.10290-1-tony.luck@intel.com>
References: <20260828153002.10290-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

get_cpu_cacheinfo_id() is a static inline that requires get_cpu_cacheinfo(),
which is not exported. Modules that need to identify which cache instance
a CPU belongs to therefore cannot use it.

Move it out of line and export it.

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

