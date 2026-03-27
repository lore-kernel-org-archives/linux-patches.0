Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6EE355F24
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 16:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774629986; cv=none; b=ExPo927EpCTpqy6BmlOT/7cTX7RELir1Rd2a6vPfdKzRld25Seoug+aOJUqLQsviVTgh4o/YNwL7cAgpfl0gZ2DhS1ZLP7Oyc7UkDZ34PT1RlNOnPlnUjtjYQlNs+opZJYG6FwNLPK2AUBllrd9gDeEodEOQRFvNiqSxYyBSAGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774629986; c=relaxed/simple;
	bh=xaBjBm9xmI+Jjn50mkTSCSjnq5yUFZVniHrWGbO5MYc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uMBO+25pMGRaLs98Ub1fsGHXykzaZps772J4edfrajD9JDpnf0Nx9yoLzb9pGI7BavlpCHGQVZo+V3/e0+Gk9UXVR/D+eo5DDQqeaQ4o8QmCe6spjMb5Qs5lbkenPKqhCsBFQu0HL4bc2QRYeU43z5sB4hAWGE/p2lQO/HkmIYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YiasY3my; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YiasY3my"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774629984; x=1806165984;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xaBjBm9xmI+Jjn50mkTSCSjnq5yUFZVniHrWGbO5MYc=;
  b=YiasY3myOz6zwKJSVRE3ahsBqRVf6c3Q0RRTS8EanjS6b8g6VTpmR9FW
   V9/NEPzqmBCfssCKnKALtaMbEbXIyVSiRuTEHYFhO/nyLpFUPmCWFYg9z
   2FwqwOi1ahyDlPNPkiZBP/XEZ3agTYwcjbvJOKlZZL+nch+icUeqBdOQT
   XZyCu7gkBv8eF472Kr4QRdvdWrUH9lS/KrurUbgSOBYPZ2TIV1BttRtA5
   Za3ch37tcYQHC/zBFWSBnhE/XyYLvyt0hcoaKKVunsotHZA78Zp4V0W3D
   rENhfY6IAdUGy+SPKKJvRe/9LU91OJsTBetMKcQFtqtg3fEq8vdpktJ3s
   g==;
X-CSE-ConnectionGUID: /MxWSmPLTuKR4FJCmImjAA==
X-CSE-MsgGUID: qtiPq5Y/SKOF9eCfqfxnEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="75772447"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="75772447"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 09:46:23 -0700
X-CSE-ConnectionGUID: Wb7rTEY+R8ObQVbE8yI98A==
X-CSE-MsgGUID: PQmwxOZ2RayJfERnRTbFrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="230288885"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.180]) ([10.125.110.180])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 09:46:23 -0700
Message-ID: <4361824f-7346-47a4-9339-1dc33fc0a127@intel.com>
Date: Fri, 27 Mar 2026 09:46:21 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] dax/hmem: Reduce visibility of dax_cxl coordination
 symbols
To: Dan Williams <dan.j.williams@intel.com>
Cc: patches@lists.linux.dev, linux-cxl@vger.kernel.org,
 alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-6-dan.j.williams@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260327052821.440749-6-dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/26/26 10:28 PM, Dan Williams wrote:
> No other module or use case should be using dax_hmem_initial_probe or
> dax_hmem_flush_work(). Limit their use to dax_hmem, and dax_cxl
> respectively.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  drivers/dax/hmem/device.c | 2 +-
>  drivers/dax/hmem/hmem.c   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dax/hmem/device.c b/drivers/dax/hmem/device.c
> index 991a4bf7d969..675d56276d78 100644
> --- a/drivers/dax/hmem/device.c
> +++ b/drivers/dax/hmem/device.c
> @@ -9,7 +9,7 @@ static bool nohmem;
>  module_param_named(disable, nohmem, bool, 0444);
>  
>  bool dax_hmem_initial_probe;
> -EXPORT_SYMBOL_GPL(dax_hmem_initial_probe);
> +EXPORT_SYMBOL_FOR_MODULES(dax_hmem_initial_probe, "dax_hmem");
>  
>  static bool platform_initialized;
>  static DEFINE_MUTEX(hmem_resource_lock);
> diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
> index b2ab1292fa81..dd3d7f93baee 100644
> --- a/drivers/dax/hmem/hmem.c
> +++ b/drivers/dax/hmem/hmem.c
> @@ -74,7 +74,7 @@ void dax_hmem_flush_work(void)
>  {
>  	flush_work(&dax_hmem_work.work);
>  }
> -EXPORT_SYMBOL_GPL(dax_hmem_flush_work);
> +EXPORT_SYMBOL_FOR_MODULES(dax_hmem_flush_work, "dax_cxl");
>  
>  static int __hmem_register_device(struct device *host, int target_nid,
>  				  const struct resource *res)

