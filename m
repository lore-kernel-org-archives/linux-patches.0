Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131B02FF672
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 00:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772583596; cv=none; b=qCQhwYMrOWWhVTDqfhjMf2pWFTaG+UITqTgCaMzlthRJHQWu7MaLBzt4M/Bw3SEG/otCxhoAO4nHDiVYJwoeukc52wPH0hJc/LK8ukVn8wiDs2iK1t9S94kVCCTqetr8w5W5p1WbKNKZHmPqtI3oB9Vr/K/7ghi4lzawHF9TXf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772583596; c=relaxed/simple;
	bh=kH8up4x2qXh5qYwxKPcjYKankJXfqnKuAMLBmbTJGVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmzEN1+NHOYDrkXo25dH/YDX5e5jIED4HsANTDHm2m/qG4ImeU35JbvudqFuwpVZf019nTZp06rFHj7vVACAhYgq8TkSsn0pPvKlGDbkfULuQcscSMPQEfmLVLzAK6cpaJIkPEzMjDOtP+N2N41bUdf5NtKKwHIVmQozPSNfjXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fO4yBQbj; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fO4yBQbj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772583592; x=1804119592;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kH8up4x2qXh5qYwxKPcjYKankJXfqnKuAMLBmbTJGVg=;
  b=fO4yBQbjJQKfge9vjI7ioEz0i58J1ydmsPH1p/voxkM0g/jvShCg+/1N
   sCu6JzRv89qdC2juUoNWCMNeaE5CKAQ2GLNI0wL5aibzq7c9LC+9iyKq+
   TuA9kKx0TCqQtY+T2AbiY9gD2bLwHDUsaI3jU2S6rn57YrD8pxb1ymLCc
   atlJaZ6FcaZxXD9BhkYRuPc8PprfcJB9mHKRLa6SHnPAF5uKnt6t0qLX7
   PIY8O9VpOHx6Wr2NOfszFolJJTrqsHG5azPm1OnCFo9fs2mnbVJ8RtIIH
   da1t82jWhG3HBYxXKZVFkLh7X00XOYvTGDh55fHaTANF0+VIn4Tohnp+E
   g==;
X-CSE-ConnectionGUID: S6Cgku+kS6GYpJtF8rtX6Q==
X-CSE-MsgGUID: OEU4AmWRTleuBpOZCIFdGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="73545051"
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="73545051"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 16:19:45 -0800
X-CSE-ConnectionGUID: rCwJYapUTwm3WbWIEEzlYw==
X-CSE-MsgGUID: nAYhehVISAqS3bjxZeL/Aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="218120409"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 16:19:45 -0800
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
	reinette.chatre@intel.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v2 9/9] selftests/resctrl: Reduce L2 impact on CAT test
Date: Tue,  3 Mar 2026 16:19:38 -0800
Message-ID: <74657e85c607b1494c898353087fa40e80a8af01.1772582958.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1772582958.git.reinette.chatre@intel.com>
References: <cover.1772582958.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The L3 CAT test loads a buffer into cache that is proportional to the L3
size allocated for the workload and measures cache misses when accessing
the buffer as a test of L3 occupancy. When loading the buffer it can be
assumed that a portion of the buffer will be loaded into the L2 cache and
depending on cache design may not be present in L3. It is thus possible
for data to not be in L3 but also not trigger an L3 cache miss when
accessed.

Reduce impact of L2 on the L3 CAT test by, if L2 allocation is supported,
minimizing the portion of L2 that the workload can allocate into. This
encourages most of buffer to be loaded into L3 and support better
comparison between buffer size, cache portion, and cache misses when
accessing the buffer.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 tools/testing/selftests/resctrl/cat_test.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/resctrl/cat_test.c b/tools/testing/selftests/resctrl/cat_test.c
index 6aac03147d41..26062684a9f4 100644
--- a/tools/testing/selftests/resctrl/cat_test.c
+++ b/tools/testing/selftests/resctrl/cat_test.c
@@ -157,6 +157,12 @@ static int cat_test(const struct resctrl_test *test,
 	if (ret)
 		goto reset_affinity;
 
+	if (!strcmp(test->resource, "L3") && resctrl_resource_exists("L2")) {
+		ret = write_schemata(param->ctrlgrp, "0x1", uparams->cpu, "L2");
+		if (ret)
+			goto reset_affinity;
+	}
+
 	perf_event_attr_initialize(&pea, PERF_COUNT_HW_CACHE_MISSES);
 	pe_fd = perf_open(&pea, bm_pid, uparams->cpu);
 	if (pe_fd < 0) {
-- 
2.50.1

