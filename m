Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F15318BB9
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 16:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770741393; cv=none; b=Ld5rDEiqau01JcoVYr/m9usqpx2fyikgZ8efNZw4YgPFJPe22CclKGlv+7T0V36wNbvTHkLX6lsDZ1oNxoD3aYWzneZX36L8Y2Esfuou4hFoHKdVQlc1vDCjirHlEn0fjh7/hZNvOddYaxOASGc8ifTyH/eNH6piwHfogVIFJwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770741393; c=relaxed/simple;
	bh=uBBHGG+Pb79Ww3RCSOJRUJ3SLe13CGVilpi6FeCHHrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P25qQwjDfKvw79elUp1TNDkIJ0qUgj26LEMqmFVnwIl4qZDX6ptgFiLfKGNRNtjwW0LsFIiPRDRvEm5spDFws9ViaCTqA6duiDdKinL8mnQuDUfEpriIIuuU3mGIsfoPVJK3Lf2SVWdAifFLSqmEQ3argYXoClKPqTk91B4uySA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LuNheeOk; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LuNheeOk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770741391; x=1802277391;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uBBHGG+Pb79Ww3RCSOJRUJ3SLe13CGVilpi6FeCHHrg=;
  b=LuNheeOkdSpKMlhE4nhYF4RpzLN653aL8SHEmuPi+Y5WQihe7Mt4O31S
   G+L1mKdeNionW/Dj3GfDzlwkPmtI2zJ5ilnrImrcJOQegYmylSm6soxjQ
   bnAQ63pHZslNomsE5oS4hPQw+intU0azTf37GU68I33oMLUWbPzPdYY2D
   ChfTKE662Bo7ucN6bSPlk/RW5kqNVW6ofPlbRwWI8N+sSmvMZBLvx/IBB
   UZaq/7G45ae7UTQDYoWhZ6dT8OxCF4rVkxh+JtYPZLjg4XKKzbrdRP6P1
   eV66eezrVVJMHy8ykMOfIwsezj9FecYC/QTUAxcwExcHvvGQNim4aHnpp
   w==;
X-CSE-ConnectionGUID: ct2QW7euQ1uqhbDHkvVwQg==
X-CSE-MsgGUID: 3JZfqVaoR4iY5Aze7D0DIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="74476849"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="74476849"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 08:36:28 -0800
X-CSE-ConnectionGUID: kgqoaQyeSpGwLmoIF7R/5w==
X-CSE-MsgGUID: 9pKWE1k5SQGIXVZN5pI9QQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="212003466"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 08:36:27 -0800
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
Subject: [PATCH 5/8] selftests/resctrl: Raise threshold at which MBM and PMU values are compared
Date: Tue, 10 Feb 2026 08:50:44 -0800
Message-ID: <d166b443790a2941cb32a6d3b952a51142c7e391.1770406608.git.reinette.chatre@intel.com>
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

commit 501cfdba0a40 ("selftests/resctrl: Do not compare performance
counters and resctrl at low bandwidth") introduced a threshold under which
memory bandwidth values from MBM and performance counters are not compared.
This is needed because MBM and the PMUs do not have an identical view of
memory bandwidth since PMUs can count all memory traffic while MBM does not
count "overhead" (for example RAS) traffic that cannot be attributed to an
RMID. As a ratio this difference in view of memory bandwidth is pronounced
at low memory bandwidths.

The 750MiB threshold was chosen arbitrarily after comparisons on different
platforms. Exposed to more platforms after introduction this threshold has
proven to be inadequate.

Having accurate comparison between performance counters and MBM requires
careful management of system load as well as control of features that
introduce extra memory traffic, for example, patrol scrub. This is not
appropriate for the resctrl selftests that are intended to run on a
variety of systems with various configurations.

Increase the memory bandwidth threshold under which no comparison is made
between performance counters and MBM. Add additional leniency by increasing
the percentage of difference that will be tolerated between these counts.

There is no impact to the validity of the resctrl selftests results as a
measure of resctrl subsystem health.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 tools/testing/selftests/resctrl/mba_test.c | 2 +-
 tools/testing/selftests/resctrl/mbm_test.c | 2 +-
 tools/testing/selftests/resctrl/resctrl.h  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/resctrl/mba_test.c b/tools/testing/selftests/resctrl/mba_test.c
index cd4c715b7ffd..39cee9898359 100644
--- a/tools/testing/selftests/resctrl/mba_test.c
+++ b/tools/testing/selftests/resctrl/mba_test.c
@@ -12,7 +12,7 @@
 
 #define RESULT_FILE_NAME	"result_mba"
 #define NUM_OF_RUNS		5
-#define MAX_DIFF_PERCENT	8
+#define MAX_DIFF_PERCENT	15
 #define ALLOCATION_MAX		100
 #define ALLOCATION_MIN		10
 #define ALLOCATION_STEP		10
diff --git a/tools/testing/selftests/resctrl/mbm_test.c b/tools/testing/selftests/resctrl/mbm_test.c
index 58201f844740..6dbbc3b76003 100644
--- a/tools/testing/selftests/resctrl/mbm_test.c
+++ b/tools/testing/selftests/resctrl/mbm_test.c
@@ -11,7 +11,7 @@
 #include "resctrl.h"
 
 #define RESULT_FILE_NAME	"result_mbm"
-#define MAX_DIFF_PERCENT	8
+#define MAX_DIFF_PERCENT	15
 #define NUM_OF_RUNS		5
 
 static int
diff --git a/tools/testing/selftests/resctrl/resctrl.h b/tools/testing/selftests/resctrl/resctrl.h
index c72045c74ac4..861bf25f2f28 100644
--- a/tools/testing/selftests/resctrl/resctrl.h
+++ b/tools/testing/selftests/resctrl/resctrl.h
@@ -55,7 +55,7 @@
  * and MBM respectively, for instance generating "overhead" traffic which
  * is not counted against any specific RMID.
  */
-#define THROTTLE_THRESHOLD	750
+#define THROTTLE_THRESHOLD	2500
 
 /*
  * fill_buf_param:	"fill_buf" benchmark parameters
-- 
2.50.1

