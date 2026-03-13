Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D267377022
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 20:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773433980; cv=none; b=bKve2GuWrHNxcJuzmvkAyKJiOtxu4F1BMLO2EzHPO4rhudrYt7UIedF16p9y38wn4QbbiA23ttrR3SCARXuMVTKTKaNEaPsAmvHSEkteZqX147ZW08EpGa9e/M3aLulic8qx+qzfbMr4WdTJfC4QVTQRbaevqGODcQtZ1SFAaJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773433980; c=relaxed/simple;
	bh=8KixJVU3eUU6QMa/RZIfK9ZWO4UtHzZLFNwGdwVoYV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qcuLyfL8+mYw5x0KGwichXibBmAZqcSw8XOocqhkO1PR+OdzZQGt2qTZ54KGag2aGem3i8mQXh+kOQ/5PafWsczfXU+TqdmR/AOfUaXQgxSD6rd8Tcp/zNk5xdmVRdFwqSiuaLjZk7vhOj+r0GzTRPdgaJAMyResIlpaHViy5nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cABjtrLb; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cABjtrLb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773433978; x=1804969978;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8KixJVU3eUU6QMa/RZIfK9ZWO4UtHzZLFNwGdwVoYV8=;
  b=cABjtrLbcMmxqB0sGSMvo3Oz+v4gj8ZtGlEkWZBrIuoucRHWtMxFRd2N
   kV6CLkkejzn8ztIkluO/yuEUIQ1tlAFk6wvvB3HxIfP4U4le17++wiIm1
   pZKYcFycMTakfOA6lfb/BEIj076bFpnlN1DIiJTin809fHBQgesInGcNw
   fY/d0L1D632xB6PFwjwWiP920Zan1I33gs4NqUTJJ0PRZvBAxUAPre61M
   O8ODzfFnNxzsHmlcWakj6vN0TBLvpIuTnLRSyOCRTk762zROuJn+MYmTA
   0FdBN7ZkFgPRKHXvCP+kvBb+iOmVHgCGiU3S+jlpzBpE04QwcfZ7x+8zO
   Q==;
X-CSE-ConnectionGUID: oy8bdKBLSRCmA9defwmP8Q==
X-CSE-MsgGUID: vmjEqY25Qa677ezYdW/BMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11728"; a="74519285"
X-IronPort-AV: E=Sophos;i="6.23,118,1770624000"; 
   d="scan'208";a="74519285"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 13:32:54 -0700
X-CSE-ConnectionGUID: DanAruqSQP+ISdUZ6bT4zA==
X-CSE-MsgGUID: vCrr5D40QNiqUWSgeLkDPA==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 13:32:54 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: shuah@kernel.org,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	tony.luck@intel.com,
	babu.moger@amd.com,
	ilpo.jarvinen@linux.intel.com
Cc: fenghuay@nvidia.com,
	peternewman@google.com,
	zide.chen@intel.com,
	dapeng1.mi@linux.intel.com,
	ben.horgan@arm.com,
	yu.c.chen@intel.com,
	jason.zeng@intel.com,
	reinette.chatre@intel.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v3 06/10] selftests/resctrl: Increase size of buffer used in MBM and MBA tests
Date: Fri, 13 Mar 2026 13:32:33 -0700
Message-ID: <32e610855f87010cd37ccc18c5eb23a1117fbb41.1773432891.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1773432891.git.reinette.chatre@intel.com>
References: <cover.1773432891.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Errata for Sierra Forest [1] (SRF42) and Granite Rapids [2] (GNR12)
describe the problem that MBM on Intel RDT may overcount memory bandwidth
measurements. The resctrl tests compare memory bandwidth reported by iMC
PMU to that reported by MBM causing the tests to fail on these systems
depending on the settings of the platform related to the errata.

Since the resctrl tests need to run under various conditions it is not
possible to ensure system settings are such that MBM will not overcount.
It has been observed that the overcounting can be controlled via the
buffer size used in the MBM and MBA tests that rely on comparisons
between iMC PMU and MBM measurements.

Running the MBM test on affected platforms with different buffer sizes it
can be observed that the difference between iMC PMU and MBM counts reduce
as the buffer size increases. After increasing the buffer size to more
than 4X the differences between iMC PMU and MBM become insignificant.

Increase the buffer size used in MBM and MBA tests to 4X L3 size to reduce
possibility of tests failing due to difference in counts reported by iMC
PMU and MBM.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Chen Yu <yu.c.chen@intel.com>
Link: https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details/ # [1]
Link: https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/birch-stream/xeon-6900-6700-6500-series-processors-with-p-cores-specification-update/011US/errata-details/ # [2]
---
Changes since v2:
- Add Chen Yu's tag.
---
 tools/testing/selftests/resctrl/fill_buf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/resctrl/fill_buf.c b/tools/testing/selftests/resctrl/fill_buf.c
index 19a01a52dc1a..b9fa7968cd6e 100644
--- a/tools/testing/selftests/resctrl/fill_buf.c
+++ b/tools/testing/selftests/resctrl/fill_buf.c
@@ -139,6 +139,6 @@ ssize_t get_fill_buf_size(int cpu_no, const char *cache_type)
 	if (ret)
 		return ret;
 
-	return cache_total_size * 2 > MINIMUM_SPAN ?
-			cache_total_size * 2 : MINIMUM_SPAN;
+	return cache_total_size * 4 > MINIMUM_SPAN ?
+			cache_total_size * 4 : MINIMUM_SPAN;
 }
-- 
2.50.1

