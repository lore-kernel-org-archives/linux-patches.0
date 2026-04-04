Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A122F25E4
	for <patches@lists.linux.dev>; Sat,  4 Apr 2026 01:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775267813; cv=none; b=REYrhd51zeqP/JyD0JrdhjpQmb4QzPWW071RYBLQ8f2M3/VJFhaTsMR8IP8kGoiIv2/qt0uLdE43+3Sc6hyEi44bDtmAnbB/Qgo6ShBP4dIkh/ymEnzte08Im/cHT/fSW+2b+Rgc8hY3TJpP6zswbKG9Vw5d6DqwHfRyCZ/4iss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775267813; c=relaxed/simple;
	bh=TMYWBwczQQyNXGbZEwr5vrsjgD4HeYYTjcWXQ5+Sv5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dXtotV6agCwa4j88FS4V9C9UniL6pT9SonQlyVrtQ5CT+nm7dWyfv8CfUBH1qwAuMFPNd+qPRpCjEjY0KfWpoB7EqWKqvyOAkewP5kl3JcymYrbYucI2q8XJFpncTmFyGXVnHvdt9FKjhxH5Anfp9Jg9Ks8nEQfqm8L0xqeBIzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dL/Kk/7d; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dL/Kk/7d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775267812; x=1806803812;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TMYWBwczQQyNXGbZEwr5vrsjgD4HeYYTjcWXQ5+Sv5s=;
  b=dL/Kk/7dEK2er8nHt92QDJJbwN0MRSKjVoH0a0PlisVQM4VLukJTytUb
   9vgK1ZblrLfYGVWwyDMusc9jlXzSGPVbxx6bVE/KC/P/mJBpBQAPYqSy8
   z8jJHw2V8PWcT7FDMdzHRY3cvMBKe6RvHCq0uTg+1T0g/sGN/SVtgZKUH
   poe1zanbByJUsYJJU9lBksOExjRRs9oTOmB0mDynjF5MjOTuEVJOgoQcK
   dejgVHPW/R1bAM95+NKHcpuKSoJ2BUBKcdhKkJiN2FAcrPWd9spaeFlWQ
   G6gfUWW4AerTlTQZeBpQBbAebGr3a3bYmH+ZP/gEU2aSpgaiIw3WjQ1j4
   A==;
X-CSE-ConnectionGUID: Fj8zH0HbTWOypjAT9MGboA==
X-CSE-MsgGUID: 5+OvKaAsR4K/AazW9c13+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="76219374"
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="76219374"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 18:56:44 -0700
X-CSE-ConnectionGUID: VWRYRkZaT8+CPdTF+Y0Raw==
X-CSE-MsgGUID: TdQQh+obTtOK4eAOI9UkiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="224121550"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 18:56:20 -0700
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
Subject: [PATCH v4 10/10] selftests/resctrl: Reduce L2 impact on CAT test
Date: Fri,  3 Apr 2026 18:56:09 -0700
Message-ID: <1f5aad318889cd6d4f9a8d8b0fbe83e3848d41a9.1775266384.git.reinette.chatre@intel.com>
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
Tested-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
Changes since v2:
- Add Chen Yu's tag.

Changes since v3:
- Add Ilpo's RB tag.
---
 tools/testing/selftests/resctrl/cat_test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/resctrl/cat_test.c b/tools/testing/selftests/resctrl/cat_test.c
index 6aac03147d41..371a2f26dc47 100644
--- a/tools/testing/selftests/resctrl/cat_test.c
+++ b/tools/testing/selftests/resctrl/cat_test.c
@@ -157,6 +157,10 @@ static int cat_test(const struct resctrl_test *test,
 	if (ret)
 		goto reset_affinity;
 
+	ret = minimize_l2_occupancy(test, uparams, param);
+	if (ret)
+		goto reset_affinity;
+
 	perf_event_attr_initialize(&pea, PERF_COUNT_HW_CACHE_MISSES);
 	pe_fd = perf_open(&pea, bm_pid, uparams->cpu);
 	if (pe_fd < 0) {
-- 
2.50.1

