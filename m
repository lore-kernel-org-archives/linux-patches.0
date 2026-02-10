Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2DA3126D0
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 16:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770741391; cv=none; b=nIs/0yMtBg78egRVxKr/UN3f1mSuYqdz/xLGea9KdVPLDu9gmWTwCRmRCQ2KCucUAgfFSvLxCMGTLkB/7XEM6XX7NM0lTloNRHFNJQjsfwKdb+Vixj3sn9sKAbfiflWj71wzb1ppzgC8zO/91t0GY/yqZ9Joofgcnm9o+2ta2OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770741391; c=relaxed/simple;
	bh=aYBwxsXexDx1wpURXe2fS8HHTkWNax3PozdPsyGor0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBAtTMeGWlupSOYFi3stisPiE7i3N13Q2tUzpPca/Zg2ZdnxBJnRgy2gyH7PRFgmO//CeIGCV/YX4kDctdwjR7UF2gEyNL2pl94n63CMpjx4/FfQMYWaWMrp8Kx47pjwtXpwwrgiQXUzjk7JS8YW32arYDkxzNyTQc22qKw6XOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BZqYQVX4; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BZqYQVX4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770741391; x=1802277391;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aYBwxsXexDx1wpURXe2fS8HHTkWNax3PozdPsyGor0A=;
  b=BZqYQVX4UkwKy9N9Fk/slC+K1vxB1cKAdkYc3ctFZoKm1BxELZJKvAYu
   boqlU4NlbGJBdwY/q/saq/pIA4rXe0CghoDoNgbsecraoUna0yegdJa8m
   smOXarWxupQO5/G+FdqEAbQMGJOLBOcBJ6atnlW6kzCHCn0O46nfI062s
   rgtpPSXC+vYLJFgjOKsExjGteguePLZKC/IvFdqJY3OdiAJ50R13ie47c
   aj8ShafpsjpDH94VTNx5O9MPNFBgwqZ0BXOKcvhqj0QlHSGzk2msF/OGx
   CKInuVZTOSSb6B7T/x5dypcTFhhK0r+mGc3h4yIbQ6vibKjZPnmCN7TPl
   w==;
X-CSE-ConnectionGUID: ZH9ZsL9oQneHKTozHq7G4Q==
X-CSE-MsgGUID: Z92t7MCCTgm41vRYM0u6AQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="74476843"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="74476843"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 08:36:28 -0800
X-CSE-ConnectionGUID: XzwkwnOAQMiCaAWCwzCMaA==
X-CSE-MsgGUID: V+DCmGD4QXiSe4HwU8rtPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="212003463"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 08:36:26 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: shuah@kernel.org,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	tony.luck@intel.com,
	peternewman@google.com,
	babu.moger@amd.com,
	ilpo.jarvinen@linux.intel.com
Cc: zide.chen@intel.com,
	dapeng1.mi@linux.intel.com,
	fenghuay@nvidia.com,
	reinette.chatre@intel.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 4/8] selftests/resctrl: Increase size of buffer used in MBM and MBA tests
Date: Tue, 10 Feb 2026 08:50:43 -0800
Message-ID: <7bc3153a34e2736d389e94a12762ede4460873fe.1770406608.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1770406608.git.reinette.chatre@intel.com>
References: <cover.1770406608.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Errata for Sierra Forest [1] (SRF42) and Granite Rapids[2] (GNR12)
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
Link: https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details/ # [1]
Link: https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/birch-stream/xeon-6900-6700-6500-series-processors-with-p-cores-specification-update/011US/errata-details/ # [2]
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

