Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EC830CD82
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 16:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774628973; cv=none; b=RCJ4M5uNhgLEdP2Y5w3dnYK1TKFYx2ctnzavnttwIf2rWQtbspezkjJJAc1LoAgty8yHqnX1XnyanXnOdwcZiq8WlHMiAB2cL9wV9LeDGzixUpMuLNskrz/Rf14LsqBGlkbmaOPAhiz7GT3lM/iwhRV25yYZanQPIjFAVAKNgT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774628973; c=relaxed/simple;
	bh=EZ0VZfn/qJWnIuF06J+3Kk9WvTdX52k2CJPwkvr58Ic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YSCQIi/Rnobe82NXRzV+W5R0vCnEYjbsxLpswwPsq38slUqNQFkotLkD1eKzYXLDiFdwNuT09k+XIaQFOwpaFBuO1ADNdT5flI0r/YTZXcdxSYu4QYrNgocDcmGMn3EZNZBsUAcKUSkeeeXKaKDotf3XmqV7Own/g6ocZUX+DP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d2ej8oRT; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d2ej8oRT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774628971; x=1806164971;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EZ0VZfn/qJWnIuF06J+3Kk9WvTdX52k2CJPwkvr58Ic=;
  b=d2ej8oRT1j7LmrWgfeTn9jUMKYJG4NukMAxcTUdG7aB+Nt+NDeIUb9+O
   Kx01qYI8QyZAV+TV+6SbHt2bOcGctJW8RnKyVrnviy9yXQmFXv3VSBvqq
   0yJoxpzdBS2dFpjyFydiwaBXwHrQeJLtdEv4B5tOUN9jsUHKGJORMGPw0
   IGk5wXq3sJaJrESETVjlIppcxnbq6BIhIHouGbYdYJtqogjTtfKjnP6Ho
   KasWkMUthIBlOeCNxPLuqloL2C7d4huQ+lW41Q0tzNNq7n6plw5k8AKHy
   ItBgqjU+qFAbWKP7O7wc34hxO08nTmoCxgQUTjlY24yD/v4yr+tvoDskc
   g==;
X-CSE-ConnectionGUID: g51md5+iSXCUoXt0Vlu4Og==
X-CSE-MsgGUID: 4v/6MMe/RvWRe5zVfDdyIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="101164731"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="101164731"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 09:29:30 -0700
X-CSE-ConnectionGUID: ZJft472TSkWANtNOCNcIIA==
X-CSE-MsgGUID: E/cyM1BCR4+oQcc88O3xIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="218743655"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.180]) ([10.125.110.180])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 09:29:29 -0700
Message-ID: <4d6bdd4c-3190-48e4-a9d4-b47a71756ccd@intel.com>
Date: Fri, 27 Mar 2026 09:29:27 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/9] dax/cxl: Fix HMEM dependencies
To: Dan Williams <dan.j.williams@intel.com>
Cc: patches@lists.linux.dev, linux-cxl@vger.kernel.org,
 alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-3-dan.j.williams@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260327052821.440749-3-dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/26/26 10:28 PM, Dan Williams wrote:
> The expectation is that DEV_DAX_HMEM=y should be disallowed if any of
> CXL_ACPI, or CXL_PCI are set =m. Also DEV_DAX_CXL=y should be disallowed if
> DEV_DAX_HMEM=m. Use "$config || !$config" syntax for each dependency.
> Otherwise, the invalid DEV_DAX_HMEM=m && DEV_DAX_CXL=y configuration is
> allowed.
> 
> Lastly, dax_hmem depends on the availability of the
> cxl_region_contains_resource() symbol published by the cxl_core.ko module.
> So, also prevent DEV_DAX_HMEM from being built-in when the cxl_core module
> is not built-in.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/dax/Kconfig | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
> index 3683bb3f2311..504f7f735ef5 100644
> --- a/drivers/dax/Kconfig
> +++ b/drivers/dax/Kconfig
> @@ -32,6 +32,9 @@ config DEV_DAX_HMEM
>  	depends on EFI_SOFT_RESERVE
>  	select NUMA_KEEP_MEMINFO if NUMA_MEMBLKS
>  	default DEV_DAX
> +	depends on CXL_ACPI || !CXL_ACPI
> +	depends on CXL_PCI || !CXL_PCI
> +	depends on CXL_BUS || !CXL_BUS
>  	help
>  	  EFI 2.8 platforms, and others, may advertise 'specific purpose'
>  	  memory. For example, a high bandwidth memory pool. The
> @@ -48,8 +51,7 @@ config DEV_DAX_CXL
>  	tristate "CXL DAX: direct access to CXL RAM regions"
>  	depends on CXL_BUS && CXL_REGION && DEV_DAX
>  	default CXL_REGION && DEV_DAX
> -	depends on CXL_ACPI >= DEV_DAX_HMEM
> -	depends on CXL_PCI >= DEV_DAX_HMEM
> +	depends on DEV_DAX_HMEM || !DEV_DAX_HMEM
>  	help
>  	  CXL RAM regions are either mapped by platform-firmware
>  	  and published in the initial system-memory map as "System RAM", mapped

