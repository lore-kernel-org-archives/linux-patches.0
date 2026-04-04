Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C9E2D94AF
	for <patches@lists.linux.dev>; Sat,  4 Apr 2026 01:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775267813; cv=none; b=iVVjIunuM5rIIScoR4hNstDZwtFnfzis9K1Pbu5f4dSWehnoBemSYzMhiMt3lEKKX/YZLb4yTc7Ae8q24ZExkYfCJ2wU+ql0lYpbOkdpb6QKIFBfLvvgxbwgCRVzJumSIlfHfhvfDNYoRY772vpWV4bJFcerMtdaZMBiXMoZ140=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775267813; c=relaxed/simple;
	bh=cRbJHEngvN7Z01nJA5XO8GqSctVY4W6GnAmvnR3EiLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BifK6mJWHxCx4vMs8V1sN6Vhi5UMkAGhDAKzbo8IAqd+qgs6KXerDGtYDQ3ao1Fdr3OYIvfDXHX6F9AofvoK226QTnP8WhFNnxfuJbG9VwZaGvSvXY2rkOIZwoLJnA5XudcqCHDPGdQ3pJOeQczxN+JgePM3FiaRU23yr+vEYr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oEhTZ9tJ; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oEhTZ9tJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775267811; x=1806803811;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cRbJHEngvN7Z01nJA5XO8GqSctVY4W6GnAmvnR3EiLY=;
  b=oEhTZ9tJeX99VDDdpXJpMeszCaN5/Q0bZZtPplzL3DewGne5moNZ6BbI
   lxuGczyv5Xmdc7hRwp8/8VH3pIlHFLoKhflVPQexJ5MCmIz4HHMb/A/c6
   DPwpIamfNRoWajnZncl9r5HPDY+YSfL428ap3rh+VAq8bdEySSP/jB5RK
   C0gyrT0wsEiGvrn7BRSPSf0ac0KABWBcKmlSaD2CPjDYZeozTF+zJJar8
   UK14pioxsZqi6XvHHhsUAGBLlnn+FsTmy5tUGu0FsITMDIO/L4OV29Oix
   Fn+AduPfDch2siIVZxvwSoG4E+4D2nn3k6v0lpVlYAI1BLwkXgiW8mdzo
   g==;
X-CSE-ConnectionGUID: lvGp3ifYTEOETK2y2u5qGA==
X-CSE-MsgGUID: SvxlgP4jR+y7sb9v4cElmA==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="76219372"
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="76219372"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 18:56:44 -0700
X-CSE-ConnectionGUID: lLSUd3Z2QkWWpkEpY9Smeg==
X-CSE-MsgGUID: Er5r7O4KTu6EZWIt17+ntA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="224121545"
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
Subject: [PATCH v4 07/10] selftests/resctrl: Raise threshold at which MBM and PMU values are compared
Date: Fri,  3 Apr 2026 18:56:06 -0700
Message-ID: <b374c33ddd324130d6255cbb91c3dd500e8277e7.1775266384.git.reinette.chatre@intel.com>
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

Commit 501cfdba0a40 ("selftests/resctrl: Do not compare performance
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
Tested-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
Changes since v2:
- Add Chen Yu's tag.

Changes since v3:
- Start sentence in changelog with upper case. (Ilpo)
- Add Ilpo's RB tag.
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
index 7f2ab28be857..3bad2d80c09b 100644
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

