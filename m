Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2512D7D59
	for <patches@lists.linux.dev>; Sat,  4 Apr 2026 01:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775267810; cv=none; b=N4C+wH5GqGNVGbT6VKeXPqtmMeagvNPae0rLEkZwcP++PtaNN9XwIfVWp6ZVUwknXnaRsPZ9vSpkjdJD3A1oE3o32656YXP4CqndIwaOsJrGkjXKhA4KoOVqmMy0IjRh/rdynqLlaWpSAAE+ZqT0wWkd0cvHoevpWfIMhbUGxLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775267810; c=relaxed/simple;
	bh=NoaYUKVR4lY9sNUPm9mCjY1AAjwxHOVH15U9IBXNMGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pkw2lzauadKkvrJ2Uj+si3j8PPZh+ZYxDbB0Se/nkvbr5dsiNbdKi0N4yVOT/nKiKSEf+r3R4jtSObOzh/lL44KoCMBqssPnN7/Zw8R7PueluXWz/kozSNG0gZC5Z+l4B8fLB/h3XQ0Ac+nW50nZI2d03YXIEFMoG1oADrsrtkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N8DwOhd+; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N8DwOhd+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775267808; x=1806803808;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NoaYUKVR4lY9sNUPm9mCjY1AAjwxHOVH15U9IBXNMGg=;
  b=N8DwOhd+NcJWl7fpXDXDBoAgW9xeTGekteTpAACpkSp+pKmd6chDVpCT
   IKRj3TFKheGRj1xDOsQyLTvmmwBPmthGeZ8bY2kLHKJmygdpDYuuTTuY3
   E6/YhCTiiQEZhbQ3NKJWcnVAFcpMH+ZXnELKFgBLdFJPs3wwh6gBEdIzo
   J53LMDSlA4gCniyrq+bT1uiBgkUEXOXmk8Rn+KDTP3Ita/SnjZyiqpBCx
   J3+11+DojI+1R77l+43komw5Ylq5HpYfQ27eRCMJryZ9NVWKjUxXsdnUp
   +4yBF7hojpiLLbbZmfiHvmkqJpdmyScYYVUjRD/BtMpDA7kHr5E9S6J+y
   g==;
X-CSE-ConnectionGUID: 5lQ/1DvsTKuhFE4ddg+d5w==
X-CSE-MsgGUID: wlo5L0czSx2IgLgXGMk07g==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="76219366"
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="76219366"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 18:56:44 -0700
X-CSE-ConnectionGUID: TR0B63d7Q7+AwsKDqmyRxQ==
X-CSE-MsgGUID: Y1InwMGzTo6hwV1e6P1mzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="224121542"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 18:56:18 -0700
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
Subject: [PATCH v4 06/10] selftests/resctrl: Increase size of buffer used in MBM and MBA tests
Date: Fri,  3 Apr 2026 18:56:05 -0700
Message-ID: <1bd4d8c5fc791234b0a9da94f29a3e278ba2f7ee.1775266384.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1775266384.git.reinette.chatre@intel.com>
References: <cover.1775266384.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details/ # [1]
Link: https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/birch-stream/xeon-6900-6700-6500-series-processors-with-p-cores-specification-update/011US/errata-details/ # [2]
---
Changes since v2:
- Add Chen Yu's tag.

Changes since v3:
- Add Ilpo's RB tag.
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

