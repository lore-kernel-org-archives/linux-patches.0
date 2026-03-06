Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E6C34A3D2
	for <patches@lists.linux.dev>; Fri,  6 Mar 2026 09:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772790455; cv=none; b=fXkGth2VaDr8rwB9lwpAK70VmjabCpO7pXc3c4RHNsojAVuIAhb8MmUbiS92IiQ1NP1BPbJ+HpX7o0PuhetkgfstFq9kfQJ3y9o5H4CCdrgYxdEFdVUK7L8JiWunP+KrRn51YANC5bsCN7w99OXU/Vq6EkDMmtF3LDUV2l3ABF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772790455; c=relaxed/simple;
	bh=rDLUCvrka8Fq5woiwauplUppQ/Xsp2anjGUokU5vFHM=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=GcALDT54jYRQfmUFPRqfKlxLFiWXfPsMu4fIGgOdIuX3e6mJIsqddAsxXGR3gzLa3khtWpIvtLyuaO8fZKEdhsEms5K6hDGN+w1dY27HJJqkOUOsegKGi/ywNREuMqHEa5B5Bbq+QZuhc60Fx2CDBeuuc8ZQA3KpE0GgF4Rj/is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TtGUev/j; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TtGUev/j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772790454; x=1804326454;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=rDLUCvrka8Fq5woiwauplUppQ/Xsp2anjGUokU5vFHM=;
  b=TtGUev/jkRgFWjtQu3jdQrVihtqJwoKMUk/nxA3ruBQQT8qe2PoRUZHz
   SbM+mpFIR4KGgXu+bpHQsLo4DPZnkCkKdLbdc1RWJfP04xULYKKwKRHhb
   bF89JJx9ts56bzhtlDnxfe1TwrVbulkn68HVcUF7k/XL1xcxu7QP2JRIe
   PkkebqDgjd11OENR2IRIS5kO+8AqqutLJGaIEuHe9SU6Nt0QwWnr8w0gW
   qv58tu9IMPlNdh14y4QABzHiwLRvaWrNpZdroMe17b51gujD5mfeKUEpZ
   xzeAfH2VxA8nE3ovQwu+E8vIDcp1ph0QAZFbeo+B0NXHK09XgDrHy/thT
   w==;
X-CSE-ConnectionGUID: OQ1DU4PoRI2Aqodg016GlQ==
X-CSE-MsgGUID: 1HNp33ugSeyGHBlFUcx6RA==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="85243661"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="85243661"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 01:47:34 -0800
X-CSE-ConnectionGUID: SO521QKNRSiLNqXZg77hMg==
X-CSE-MsgGUID: EoQCNVRkRHawRQJCy1gnfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="215668798"
Received: from fpallare-mobl4.ger.corp.intel.com (HELO localhost) ([10.245.244.235])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 01:47:26 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Fri, 6 Mar 2026 11:47:22 +0200 (EET)
To: Reinette Chatre <reinette.chatre@intel.com>
cc: shuah@kernel.org, Dave.Martin@arm.com, james.morse@arm.com, 
    tony.luck@intel.com, babu.moger@amd.com, fenghuay@nvidia.com, 
    peternewman@google.com, zide.chen@intel.com, dapeng1.mi@linux.intel.com, 
    ben.horgan@arm.com, yu.c.chen@intel.com, linux-kselftest@vger.kernel.org, 
    LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH v2 1/9] selftests/resctrl: Improve accuracy of cache
 occupancy test
In-Reply-To: <a43f404b9fdcf01d8c8cd825c17f39f95083c813.1772582958.git.reinette.chatre@intel.com>
Message-ID: <db270056-a2b5-e5f0-1ed4-e652d67e90fe@linux.intel.com>
References: <cover.1772582958.git.reinette.chatre@intel.com> <a43f404b9fdcf01d8c8cd825c17f39f95083c813.1772582958.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 3 Mar 2026, Reinette Chatre wrote:

> Dave Martin reported inconsistent CMT test failures. In one experiment
> the first run of the CMT test failed because of too large (24%) difference
> between measured and achievable cache occupancy while the second run passed
> with an acceptable 4% difference.
> 
> The CMT test is susceptible to interference from the rest of the system.
> This can be demonstrated with a utility like stress-ng by running the CMT
> test while introducing cache misses using:
> 
>    stress-ng --matrix-3d 0 --matrix-3d-zyx
> 
> Below shows an example of the CMT test failing because of a significant
> difference between measured and achievable cache occupancy when run with
> interference:
>     # Starting CMT test ...
>     # Mounting resctrl to "/sys/fs/resctrl"
>     # Cache size :56623104
>     # Writing benchmark parameters to resctrl FS
>     # Benchmark PID: 3275
>     # Checking for pass/fail
>     # Fail: Check cache miss rate within 15%
>     # Percent diff=97
>     # Number of bits: 5
>     # Average LLC val: 501350
>     # Cache span (bytes): 23592960
>     not ok 1 CMT: test
> 
> The CMT test creates a new control group that is also capable of monitoring
> and assigns the workload to it. The workload allocates a buffer that by
> default fills a portion of the L3 and keeps reading from the buffer,
> measuring the L3 occupancy at intervals. The test passes if the workload's
> L3 occupancy is within 15% of the buffer size.
> 
> By not adjusting any capacity bitmasks the workload shares the cache with
> the rest of the system. Any other task that may be running could evict
> the workload's data from the cache causing it to have low cache occupancy.
> 
> Reduce interference from the rest of the system by ensuring that the
> workload's control group uses the capacity bitmask found in the user
> parameters for L3 and that the rest of the system can only allocate into
> the inverse of the workload's L3 cache portion. Other tasks can thus no
> longer evict the workload's data from L3.
> 
> Take the L2 cache into account to further improve test accuracy.
> By default the buffer size is the same as the L3 portion that the workload
> can allocate into. This buffer size does not take into account that some
> of the workload's data may land in L2/L1. Address this in two ways:
>  - Reduce the amount of L2 cache the workload can allocate into to the

"into to the" sounds wrong.

>    minimum on systems that support L2 cache allocation.
>  - Increase the buffer size to accommodate data that may be allocated into
>    the L2 cache. Use a buffer size double the L3 portion to keep using the
>    L3 portion size as goal for L3 occupancy while taking into account that
>    some of the data may be in L2.

To me the this control over L2 looks logically pretty separate from the 
inverse of L3 portion control so it would seem like logically belong to a 
separate change.

> With the above adjustments the CMT test is more consistent. Repeating the
> CMT test while generating interference with stress-ng on a sample
> system after applying the fixes show significant improvement in test
> accuracy:
> 
>     # Starting CMT test ...
>     # Mounting resctrl to "/sys/fs/resctrl"
>     # Cache size :56623104
>     # Writing benchmark parameters to resctrl FS
>     # Write schema "L3:0=fe0" to resctrl FS
>     # Write schema "L3:0=1f" to resctrl FS
>     # Benchmark PID: 3223
>     # Checking for pass/fail
>     # Pass: Check cache miss rate within 15%
>     # Percent diff=3
>     # Number of bits: 5
>     # Average LLC val: 22811443
>     # Cache span (bytes): 23592960
>     ok 1 CMT: test
> 
> Reported-by: Dave Martin <Dave.Martin@arm.com>
> Closes: https://lore.kernel.org/lkml/aO+7MeSMV29VdbQs@e133380.arm.com/
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> Changes since v1:
> - Fix typo in changelog: "data my be in L2" -> "data may be in L2".
> ---
>  tools/testing/selftests/resctrl/cmt_test.c    | 35 ++++++++++++++++---
>  tools/testing/selftests/resctrl/mba_test.c    |  4 ++-
>  tools/testing/selftests/resctrl/mbm_test.c    |  4 ++-
>  tools/testing/selftests/resctrl/resctrl.h     |  4 ++-
>  tools/testing/selftests/resctrl/resctrl_val.c |  2 +-
>  5 files changed, 41 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/resctrl/cmt_test.c b/tools/testing/selftests/resctrl/cmt_test.c
> index d09e693dc739..44e9938dfafd 100644
> --- a/tools/testing/selftests/resctrl/cmt_test.c
> +++ b/tools/testing/selftests/resctrl/cmt_test.c
> @@ -19,12 +19,39 @@
>  #define CON_MON_LCC_OCCUP_PATH		\
>  	"%s/%s/mon_data/mon_L3_%02d/llc_occupancy"
>  
> -static int cmt_init(const struct resctrl_val_param *param, int domain_id)
> +/*
> + * Initialize capacity bitmasks (CBMs) for control group being tested,
> + * default resource group to prevent its tasks from interfering with test,
> + * and L2 resource of control group to minimize allocations into L2 if
> + * possible to better predict L3 occupancy.
> + */
> +static int cmt_init(const struct resctrl_test *test,
> +		    const struct user_params *uparams,
> +		    const struct resctrl_val_param *param, int domain_id)
>  {
> +	unsigned long long_mask;
> +	char schemata[64];
> +	int ret;
> +
>  	sprintf(llc_occup_path, CON_MON_LCC_OCCUP_PATH, RESCTRL_PATH,
>  		param->ctrlgrp, domain_id);
>  
> -	return 0;
> +	ret = get_full_cbm(test->resource, &long_mask);
> +	if (ret)
> +		return ret;
> +
> +	snprintf(schemata, sizeof(schemata), "%lx", ~param->mask & long_mask);

I don't know why this is variable is called "long_mask", the type seems 
pretty unrelated to its use. Perhaps change it to e.g. full_mask?

Seems otherwise fine AFAICT.

-- 
 i.


> +	ret = write_schemata("", schemata, uparams->cpu, test->resource);
> +	if (ret)
> +		return ret;
> +
> +	snprintf(schemata, sizeof(schemata), "%lx", param->mask);
> +	ret = write_schemata(param->ctrlgrp, schemata, uparams->cpu, test->resource);
> +
> +	if (!ret && !strcmp(test->resource, "L3") && resctrl_resource_exists("L2"))
> +		ret = write_schemata(param->ctrlgrp, "0x1", uparams->cpu, "L2");
> +
> +	return ret;
>  }
>  
>  static int cmt_setup(const struct resctrl_test *test,
> @@ -153,11 +180,11 @@ static int cmt_run_test(const struct resctrl_test *test, const struct user_param
>  	span = cache_portion_size(cache_total_size, param.mask, long_mask);
>  
>  	if (uparams->fill_buf) {
> -		fill_buf.buf_size = span;
> +		fill_buf.buf_size = span * 2;
>  		fill_buf.memflush = uparams->fill_buf->memflush;
>  		param.fill_buf = &fill_buf;
>  	} else if (!uparams->benchmark_cmd[0]) {
> -		fill_buf.buf_size = span;
> +		fill_buf.buf_size = span * 2;
>  		fill_buf.memflush = true;
>  		param.fill_buf = &fill_buf;
>  	}
> diff --git a/tools/testing/selftests/resctrl/mba_test.c b/tools/testing/selftests/resctrl/mba_test.c
> index c7e9adc0368f..cd4c715b7ffd 100644
> --- a/tools/testing/selftests/resctrl/mba_test.c
> +++ b/tools/testing/selftests/resctrl/mba_test.c
> @@ -17,7 +17,9 @@
>  #define ALLOCATION_MIN		10
>  #define ALLOCATION_STEP		10
>  
> -static int mba_init(const struct resctrl_val_param *param, int domain_id)
> +static int mba_init(const struct resctrl_test *test,
> +		    const struct user_params *uparams,
> +		    const struct resctrl_val_param *param, int domain_id)
>  {
>  	int ret;
>  
> diff --git a/tools/testing/selftests/resctrl/mbm_test.c b/tools/testing/selftests/resctrl/mbm_test.c
> index 84d8bc250539..58201f844740 100644
> --- a/tools/testing/selftests/resctrl/mbm_test.c
> +++ b/tools/testing/selftests/resctrl/mbm_test.c
> @@ -83,7 +83,9 @@ static int check_results(size_t span)
>  	return ret;
>  }
>  
> -static int mbm_init(const struct resctrl_val_param *param, int domain_id)
> +static int mbm_init(const struct resctrl_test *test,
> +		    const struct user_params *uparams,
> +		    const struct resctrl_val_param *param, int domain_id)
>  {
>  	int ret;
>  
> diff --git a/tools/testing/selftests/resctrl/resctrl.h b/tools/testing/selftests/resctrl/resctrl.h
> index afe635b6e48d..c72045c74ac4 100644
> --- a/tools/testing/selftests/resctrl/resctrl.h
> +++ b/tools/testing/selftests/resctrl/resctrl.h
> @@ -135,7 +135,9 @@ struct resctrl_val_param {
>  	char			filename[64];
>  	unsigned long		mask;
>  	int			num_of_runs;
> -	int			(*init)(const struct resctrl_val_param *param,
> +	int			(*init)(const struct resctrl_test *test,
> +					const struct user_params *uparams,
> +					const struct resctrl_val_param *param,
>  					int domain_id);
>  	int			(*setup)(const struct resctrl_test *test,
>  					 const struct user_params *uparams,
> diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testing/selftests/resctrl/resctrl_val.c
> index 7c08e936572d..a5a8badb83d4 100644
> --- a/tools/testing/selftests/resctrl/resctrl_val.c
> +++ b/tools/testing/selftests/resctrl/resctrl_val.c
> @@ -569,7 +569,7 @@ int resctrl_val(const struct resctrl_test *test,
>  		goto reset_affinity;
>  
>  	if (param->init) {
> -		ret = param->init(param, domain_id);
> +		ret = param->init(test, uparams, param, domain_id);
>  		if (ret)
>  			goto reset_affinity;
>  	}
> 
