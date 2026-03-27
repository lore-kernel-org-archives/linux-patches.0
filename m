Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8A83FBEA1
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 17:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774633561; cv=none; b=ubCZKhlgea4k1T7UQSdkDZboc/8KmlYl0Mf4Ezja9gNEbbR08oaM/oNhMH4RImxbwMEaFzgRmYblQlE1VozVT+ZzJt95U4U2fWfNm6RXcIESI9hC7y6rnICd6pLUqwQbJD6LdeS+MlRAglSmD49vkPa0yRuNi5wqZRlxKSZxHqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774633561; c=relaxed/simple;
	bh=VDLUygIeHTF6UKS2susCw9pnom6/bqUbYhGVGaz8DNg=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=E9Xu/m90KAXFsBSdi9UG8vt+6UDDTLppsmGQRqPKUJn16hsdpy71NXRoF6BKlxNvesBNiRhK2EoCeoNuN5vVflII7iVUV0TEgecEH4WgR0vs/v/uW+4vJjxBsGqGs8H48FPOyxarsc1z3XqQWJSe78BPoJ00svS8eAqwRbvwj9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PzNsAzzW; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PzNsAzzW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774633559; x=1806169559;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=VDLUygIeHTF6UKS2susCw9pnom6/bqUbYhGVGaz8DNg=;
  b=PzNsAzzWYFriqpeOizn2TzvASepdN0oKDIfeG8Gi8Q3PXkz3pSY0c+0H
   udMkveleEaQAVe24j44Ck1b7QyiWF/83xAI5TM2yqWxlDSp/c2fSO0QAS
   JQcJ3xlgO/EhT4K3s5dy16Z78hVICb/ddh2PzB5GajqYkddVHKJ4dV0cE
   ppHTb7JTLZYbVtv4vt4q4LB/V0r7xn7Y4kwsHrKeK864nvK2nKEhEzPhu
   SmoqSc5KYGLI9VndmDKDZNE+mFt09K2zznpBuWkI6G3IdUnQsGhe07Sy7
   qxvG60bAIQRAfsgQGM9zaF/rpwc0dU7PdcvjZAFWv6inlomXfyZQfEDCW
   g==;
X-CSE-ConnectionGUID: P3aSWtCgTpi0vSpVYQiMCg==
X-CSE-MsgGUID: Bz2WnYzZRLa9YoL2w4kzfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="87185712"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="87185712"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 10:45:59 -0700
X-CSE-ConnectionGUID: DdJ8IjeqQx+TfYWX8Vn3Xw==
X-CSE-MsgGUID: /+31AVSkSoGLTNwWNhfY9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="229456756"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.186])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 10:45:53 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Fri, 27 Mar 2026 19:45:50 +0200 (EET)
To: Reinette Chatre <reinette.chatre@intel.com>
cc: shuah@kernel.org, Dave.Martin@arm.com, james.morse@arm.com, 
    tony.luck@intel.com, babu.moger@amd.com, fenghuay@nvidia.com, 
    peternewman@google.com, zide.chen@intel.com, dapeng1.mi@linux.intel.com, 
    ben.horgan@arm.com, yu.c.chen@intel.com, jason.zeng@intel.com, 
    linux-kselftest@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
    patches@lists.linux.dev
Subject: Re: [PATCH v3 08/10] selftests/resctrl: Remove requirement on cache
 miss rate
In-Reply-To: <1fc79420f76d585231252e59d4fcf19b3e704ee3.1773432891.git.reinette.chatre@intel.com>
Message-ID: <4e3b5362-e751-03a4-f98c-a760ad274d02@linux.intel.com>
References: <cover.1773432891.git.reinette.chatre@intel.com> <1fc79420f76d585231252e59d4fcf19b3e704ee3.1773432891.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 13 Mar 2026, Reinette Chatre wrote:

> As the CAT test reads the same buffer into different sized cache portions
> it compares the number of cache misses against an expected percentage
> based on the size of the cache portion.
> 
> Systems and test conditions vary. The CAT test is a test of resctrl
> subsystem health and not a test of the hardware architecture so it is not
> required to place requirements on the size of the difference in cache
> misses, just that the number of cache misses when reading a buffer
> increase as the cache portion used for the buffer decreases.
> 
> Remove additional constraint on how big the difference between cache
> misses should be as the cache portion size changes. Only test that the
> cache misses increase as the cache portion size decreases. This remains
> a good sanity check of resctrl subsystem health while reducing impact
> of hardware architectural differences and the various conditions under
> which the test may run.
> 
> Increase the size difference between cache portions to additionally avoid
> any consequences resulting from smaller increments.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Tested-by: Chen Yu <yu.c.chen@intel.com>
> ---
> Changes since v2:
> - Add Chen Yu's tag.
> ---
>  tools/testing/selftests/resctrl/cat_test.c | 33 ++++------------------
>  1 file changed, 5 insertions(+), 28 deletions(-)
> 
> diff --git a/tools/testing/selftests/resctrl/cat_test.c b/tools/testing/selftests/resctrl/cat_test.c
> index f00b622c1460..8bc47f06679a 100644
> --- a/tools/testing/selftests/resctrl/cat_test.c
> +++ b/tools/testing/selftests/resctrl/cat_test.c
> @@ -14,42 +14,20 @@
>  #define RESULT_FILE_NAME	"result_cat"
>  #define NUM_OF_RUNS		5
>  
> -/*
> - * Minimum difference in LLC misses between a test with n+1 bits CBM to the
> - * test with n bits is MIN_DIFF_PERCENT_PER_BIT * (n - 1). With e.g. 5 vs 4
> - * bits in the CBM mask, the minimum difference must be at least
> - * MIN_DIFF_PERCENT_PER_BIT * (4 - 1) = 3 percent.
> - *
> - * The relationship between number of used CBM bits and difference in LLC
> - * misses is not expected to be linear. With a small number of bits, the
> - * margin is smaller than with larger number of bits. For selftest purposes,
> - * however, linear approach is enough because ultimately only pass/fail
> - * decision has to be made and distinction between strong and stronger
> - * signal is irrelevant.
> - */
> -#define MIN_DIFF_PERCENT_PER_BIT	1UL
> -
>  static int show_results_info(__u64 sum_llc_val, int no_of_bits,
>  			     unsigned long cache_span,
> -			     unsigned long min_diff_percent,
>  			     unsigned long num_of_runs, bool platform,
>  			     __s64 *prev_avg_llc_val)
>  {
>  	__u64 avg_llc_val = 0;
> -	float avg_diff;
>  	int ret = 0;
>  
>  	avg_llc_val = sum_llc_val / num_of_runs;
>  	if (*prev_avg_llc_val) {
> -		float delta = (__s64)(avg_llc_val - *prev_avg_llc_val);
> -
> -		avg_diff = delta / *prev_avg_llc_val;
> -		ret = platform && (avg_diff * 100) < (float)min_diff_percent;
> -
> -		ksft_print_msg("%s Check cache miss rate changed more than %.1f%%\n",
> -			       ret ? "Fail:" : "Pass:", (float)min_diff_percent);
> +		ret = platform && (avg_llc_val < *prev_avg_llc_val);
>  
> -		ksft_print_msg("Percent diff=%.1f\n", avg_diff * 100);
> +		ksft_print_msg("%s Check cache miss rate increased\n",
> +			       ret ? "Fail:" : "Pass:");

While I'm fine with removing the amount of change check, this no longer 
shows any numbers which would be a bit annoying if/when there's a failure.

-- 
 i.

>  	}
>  	*prev_avg_llc_val = avg_llc_val;
>  
> @@ -58,10 +36,10 @@ static int show_results_info(__u64 sum_llc_val, int no_of_bits,
>  	return ret;
>  }
>  
> -/* Remove the highest bit from CBM */
> +/* Remove the highest bits from CBM */
>  static unsigned long next_mask(unsigned long current_mask)
>  {
> -	return current_mask & (current_mask >> 1);
> +	return current_mask & (current_mask >> 2);
>  }
>  
>  static int check_results(struct resctrl_val_param *param, const char *cache_type,
> @@ -112,7 +90,6 @@ static int check_results(struct resctrl_val_param *param, const char *cache_type
>  
>  		ret = show_results_info(sum_llc_perf_miss, bits,
>  					alloc_size / 64,
> -					MIN_DIFF_PERCENT_PER_BIT * (bits - 1),
>  					runs, get_vendor() == ARCH_INTEL,
>  					&prev_avg_llc_val);
>  		if (ret)
> 

