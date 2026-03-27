Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9393363093
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 17:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774631292; cv=none; b=bGTh/1reMKCuTzz0jzHrq+HrywB9KodRmX66ZDhlQQ7HWSLG0SwgPkcKCp4RUhfbezTukdP+c/E4gbWKs6Ezmmv+tDregR8Bds+C9A4idUv3kmzwkBSrQtWf7HQI23s98lf5zPY77gsq510VVBZ8yqYC920jOno2TzTWebK/WKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774631292; c=relaxed/simple;
	bh=jtoyvw8Q9Kn1mliaU05+k7f7HMXxYZSZkcjMw2THQKw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q8tOlvdOHPWINHOhg6WbiGHrjeSy72kB1ZSnKdJwiG0FdjB9rRVAudsskyog17kW8QOWzppydaYVMnNgwYXCeaWKYIaoP9oulaGBZniA6BzqJPWelUdBF8aZX1PsIe5zF++A3ODRYWBZvXZc/O929SMDlkEcMGOnoKjeBRztq0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k7ZqFK/q; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k7ZqFK/q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774631291; x=1806167291;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jtoyvw8Q9Kn1mliaU05+k7f7HMXxYZSZkcjMw2THQKw=;
  b=k7ZqFK/q7639K+8yROpQBd3T91Q1vMXN/CfqMJ+QSwFMNu0xYjJN2r61
   2eK4KAt9t769B1XnYPceylsRYdJ+UtUJgf/7CXz8f8RHFjXSQuSGgt4UR
   jBrxu6RtK4d7Tf3L39Z6KbAxjHanr22BHqrltmaCIychdbJ71tr8klYU5
   x1xQynPfyzBEeq0JIaXa15AW+/uxoCmm3Np5vzcnzCQT9nx/MpwOtEhV+
   BiNCirzDmH81s64YGXcQACMcvHyLSX3tIdbCOX+4uZ24TUNmcdsTG5xb7
   qpgtsjMqUdCkQPp9yYGONKklrdjtxQkUWCX/5iH7e0QkwLMWpDMuT2xLw
   Q==;
X-CSE-ConnectionGUID: w6eFG0IlSoKjHCLY3uiGzA==
X-CSE-MsgGUID: n4GTFwXWQvCm0EkLEkBQqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="79315563"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="79315563"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 10:08:11 -0700
X-CSE-ConnectionGUID: LYmPpeheSTq93PgXWPCL/w==
X-CSE-MsgGUID: U01MBGbdTn69g78mNXzj8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="225625718"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.180]) ([10.125.110.180])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 10:08:10 -0700
Message-ID: <01236b78-2da5-4d51-a5cc-4619e11cf561@intel.com>
Date: Fri, 27 Mar 2026 10:08:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] tools/testing/cxl: Simulate auto-assembly failure
To: Dan Williams <dan.j.williams@intel.com>
Cc: patches@lists.linux.dev, linux-cxl@vger.kernel.org,
 alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-9-dan.j.williams@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260327052821.440749-9-dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/26/26 10:28 PM, Dan Williams wrote:
> Add a cxl_test module option to skip setting up one of the members of the
> default auto-assembled region.
> 
> This simulates a device failing between firmware setup and OS boot, or
> region configuration interrupted by an event like kexec.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  tools/testing/cxl/test/cxl.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
> index 81e2aef3627a..7deeb7ff7bdf 100644
> --- a/tools/testing/cxl/test/cxl.c
> +++ b/tools/testing/cxl/test/cxl.c
> @@ -16,6 +16,7 @@
>  
>  static int interleave_arithmetic;
>  static bool extended_linear_cache;
> +static bool fail_autoassemble;
>  
>  #define FAKE_QTG_ID	42
>  
> @@ -819,6 +820,12 @@ static void mock_init_hdm_decoder(struct cxl_decoder *cxld)
>  		return;
>  	}
>  
> +	/* Simulate missing cxl_mem.4 configuration */
> +	if (hb0 && pdev->id == 4 && cxld->id == 0 && fail_autoassemble) {
> +		default_mock_decoder(cxld);
> +		return;
> +	}
> +
>  	base = window->base_hpa;
>  	if (extended_linear_cache)
>  		base += mock_auto_region_size;
> @@ -1620,6 +1627,8 @@ module_param(interleave_arithmetic, int, 0444);
>  MODULE_PARM_DESC(interleave_arithmetic, "Modulo:0, XOR:1");
>  module_param(extended_linear_cache, bool, 0444);
>  MODULE_PARM_DESC(extended_linear_cache, "Enable extended linear cache support");
> +module_param(fail_autoassemble, bool, 0444);
> +MODULE_PARM_DESC(fail_autoassemble, "Simulate missing member of an auto-region");
>  module_init(cxl_test_init);
>  module_exit(cxl_test_exit);
>  MODULE_LICENSE("GPL v2");

