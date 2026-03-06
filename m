Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331CD21C160
	for <patches@lists.linux.dev>; Fri,  6 Mar 2026 10:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772793316; cv=none; b=gEcLrbPdwswU4ncIiKT146OtXILlQC07xbo3mGTswV+TqVITEa7v5+ZZLPqKQaaSH3yXt+5lqEvO4sNMzYhmsE8Lv6ZVLIbMFPpP9RiGm39RwLFriOMapSc2DejRYFHV7rzdwqvo5ehYojb1W0mLb5f59GZv0Zn7PBM//1FG8Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772793316; c=relaxed/simple;
	bh=56j/Dz5yR3NWbJ1+SqrCNPWOzDvXvg3ezeHAGS115bQ=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ZmfNrtDkNvKSVCriS49QKR/LweBILAxvZeE4UNHs0FVt98kkRBjfGzkHhXXnhNVholEfS5o5tHjpbN8lQMyks94NV/KrIBhD+/uMxhwcEduV40jTtLqHeuHW2jjvapoDnPVoaN0wxNFQyEKERp4N/vXHJ6NgzNSEDT0DF0QsFNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ipdj6Jle; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ipdj6Jle"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772793316; x=1804329316;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=56j/Dz5yR3NWbJ1+SqrCNPWOzDvXvg3ezeHAGS115bQ=;
  b=ipdj6JleeaHhgAKHgolOAe0rGIVqpU/CGbAyJO+fHZ6z+ActPTR775pi
   hj4d9wUxzR8lxwc964hQMLpRM0aUbKJxm8IO7vfSR/UUKYww046XSb81l
   kcCDtTc7zC7F2UESXKNRoVVhyk3EkHaIH0pbhAIcVRJ9NEA5ikKoSeE42
   NF2yO2+PCl6kl1nFDffsqcTVepvcQSE6cRs5KtLLegaSLbSoyko8GHr5u
   sDycr+xR8MNaCiGQwi7xEnqzIoeBN9jB8KthWzO21eD8f1He614v3o3/G
   tSLB8faDfs8Xa4OyO8rwggSLAWC4i02+Ca3dRTSAN0kUIBZqSDT94kjbU
   Q==;
X-CSE-ConnectionGUID: whYd2tYHQPiv3bis53mKbQ==
X-CSE-MsgGUID: 9+fgCrf7QlqonraStZwQJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="85374142"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="85374142"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 02:35:15 -0800
X-CSE-ConnectionGUID: VtaWfGO0ToaBZZR6oC1Njg==
X-CSE-MsgGUID: n+hLaWLIT6usj1bZkx9Vtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="218924625"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.235])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 02:35:09 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Fri, 6 Mar 2026 12:35:04 +0200 (EET)
To: Reinette Chatre <reinette.chatre@intel.com>
cc: shuah@kernel.org, Dave.Martin@arm.com, james.morse@arm.com, 
    tony.luck@intel.com, babu.moger@amd.com, fenghuay@nvidia.com, 
    peternewman@google.com, zide.chen@intel.com, dapeng1.mi@linux.intel.com, 
    ben.horgan@arm.com, yu.c.chen@intel.com, linux-kselftest@vger.kernel.org, 
    LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH v2 9/9] selftests/resctrl: Reduce L2 impact on CAT test
In-Reply-To: <74657e85c607b1494c898353087fa40e80a8af01.1772582958.git.reinette.chatre@intel.com>
Message-ID: <a36e9760-f59d-5bfe-640f-7ec8679336d4@linux.intel.com>
References: <cover.1772582958.git.reinette.chatre@intel.com> <74657e85c607b1494c898353087fa40e80a8af01.1772582958.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 3 Mar 2026, Reinette Chatre wrote:

> The L3 CAT test loads a buffer into cache that is proportional to the L3
> size allocated for the workload and measures cache misses when accessing
> the buffer as a test of L3 occupancy. When loading the buffer it can be
> assumed that a portion of the buffer will be loaded into the L2 cache and
> depending on cache design may not be present in L3. It is thus possible
> for data to not be in L3 but also not trigger an L3 cache miss when
> accessed.
> 
> Reduce impact of L2 on the L3 CAT test by, if L2 allocation is supported,
> minimizing the portion of L2 that the workload can allocate into. This
> encourages most of buffer to be loaded into L3 and support better
> comparison between buffer size, cache portion, and cache misses when
> accessing the buffer.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  tools/testing/selftests/resctrl/cat_test.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tools/testing/selftests/resctrl/cat_test.c b/tools/testing/selftests/resctrl/cat_test.c
> index 6aac03147d41..26062684a9f4 100644
> --- a/tools/testing/selftests/resctrl/cat_test.c
> +++ b/tools/testing/selftests/resctrl/cat_test.c
> @@ -157,6 +157,12 @@ static int cat_test(const struct resctrl_test *test,
>  	if (ret)
>  		goto reset_affinity;
>  
> +	if (!strcmp(test->resource, "L3") && resctrl_resource_exists("L2")) {
> +		ret = write_schemata(param->ctrlgrp, "0x1", uparams->cpu, "L2");
> +		if (ret)
> +			goto reset_affinity;
> +	}

This looks similar to what you did in the CMT test. Maybe add a common 
function for minimizing L2 cache size so it doesn't have to duplicated to 
all L3 related tests.

> +
>  	perf_event_attr_initialize(&pea, PERF_COUNT_HW_CACHE_MISSES);
>  	pe_fd = perf_open(&pea, bm_pid, uparams->cpu);
>  	if (pe_fd < 0) {
> 

-- 
 i.

