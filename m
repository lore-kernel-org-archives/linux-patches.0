Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC34621E091
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 16:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774629619; cv=none; b=VlXlLB/p624TQ/ACZcNlSJbEbwh5mhLWlXb+5rcHppPxdRQomWQ7lBf7t9rRGAdCMEuZ4X36CyuZN+W/G/oIA1+y5xgi1ii+O1XiUKdBnQdaZin3PaSvCjkveaShAtRN3t/NZZ1Zc62z7aZ4iXnpicP0L2hvl4wZbKYej+mWJLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774629619; c=relaxed/simple;
	bh=oyQjQCBpxYQK3unuHMezpzUR+2E2Jv/RBO8HwhTFHQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XEGsSfEF/ZS+DfMVC+SqDc5XppEtj+taesBqVEGLQL1RSdVQlGaedAtH2+s5F5FZeKu6V3NEHk1eVk6B73h/UayXOTkKpkRm/OqsMDDmL9K/3PxsuDSFp0NXl4H4Nvi2CerQiwhFCn+uREWlbUL9d6a/dMkhCFCtTNeDc5Vqp5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ke7Yf0EV; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ke7Yf0EV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774629617; x=1806165617;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oyQjQCBpxYQK3unuHMezpzUR+2E2Jv/RBO8HwhTFHQI=;
  b=Ke7Yf0EVlhjbsL+RCXN6gtc138AtKkueqYBWT6hszMTk467aO2WPvTKM
   OJostOSAz7eZSV73Ff0CjRy629E1NqsfOTASTxIdOPU43DU4tWn1WT4xT
   ccIYUV8d9IBrndLbzXGH1noV1dKvyWxKiPnHYT5CSxTjEzskwXE9CcZrk
   1VgirAhDavJrKmZpKzHCToJt87fuMRzirhkagaqervnbeficxam8q7p+e
   Vt7fw55vyL1SFfcfwGteajxArup5FNxKJgn3j6jGkph34eac9etdQURHq
   FpVuiIhvtwiYQSPp6Gm0yYH/saVh4qfgMifG3+IurBTCo8jj3StHNhowk
   g==;
X-CSE-ConnectionGUID: Yuga9NETSPyGQ+9jz5KBEA==
X-CSE-MsgGUID: AsoOyl9UTva8iNqcEChyaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="79567022"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="79567022"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 09:40:17 -0700
X-CSE-ConnectionGUID: ualc4q9jTAy+d3dksFQcCA==
X-CSE-MsgGUID: nlQj/wnlTnSYfXkW8CCSmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="230287532"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.180]) ([10.125.110.180])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 09:40:17 -0700
Message-ID: <71b35604-0f55-40a3-a423-2efa9396747c@intel.com>
Date: Fri, 27 Mar 2026 09:40:16 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/9] cxl/region: Constify cxl_region_resource_contains()
To: Dan Williams <dan.j.williams@intel.com>
Cc: patches@lists.linux.dev, linux-cxl@vger.kernel.org,
 alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-5-dan.j.williams@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260327052821.440749-5-dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/26/26 10:28 PM, Dan Williams wrote:
> The call to cxl_region_resource_contains() in hmem_register_cxl_device()
> need not cast away 'const'. The problem is the usage of the
> bus_for_each_dev() API which does not mark its @data parameter as 'const'.
> Switch to bus_find_device() which does take 'const' @data, fixup
> cxl_region_resource_contains() and its caller.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/cxl/cxl.h         |  4 ++--
>  drivers/cxl/core/region.c | 11 ++++++-----
>  drivers/dax/hmem/hmem.c   |  2 +-
>  3 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 84ad04a02bde..340bdc9fcacc 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -941,7 +941,7 @@ struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
>  int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
>  struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
>  u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa);
> -bool cxl_region_contains_resource(struct resource *res);
> +bool cxl_region_contains_resource(const struct resource *res);
>  #else
>  static inline bool is_cxl_pmem_region(struct device *dev)
>  {
> @@ -964,7 +964,7 @@ static inline u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint,
>  {
>  	return 0;
>  }
> -static inline bool cxl_region_contains_resource(struct resource *res)
> +static inline bool cxl_region_contains_resource(const struct resource *res)
>  {
>  	return false;
>  }
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 12a9572f34d5..a8b183f2d9c5 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -4225,9 +4225,9 @@ static int cxl_region_setup_poison(struct cxl_region *cxlr)
>  	return devm_add_action_or_reset(dev, remove_debugfs, dentry);
>  }
>  
> -static int region_contains_resource(struct device *dev, void *data)
> +static int region_contains_resource(struct device *dev, const void *data)
>  {
> -	struct resource *res = data;
> +	const struct resource *res = data;
>  	struct cxl_region *cxlr;
>  	struct cxl_region_params *p;
>  
> @@ -4246,11 +4246,12 @@ static int region_contains_resource(struct device *dev, void *data)
>  	return resource_contains(p->res, res) ? 1 : 0;
>  }
>  
> -bool cxl_region_contains_resource(struct resource *res)
> +bool cxl_region_contains_resource(const struct resource *res)
>  {
>  	guard(rwsem_read)(&cxl_rwsem.region);
> -	return bus_for_each_dev(&cxl_bus_type, NULL, res,
> -				region_contains_resource) != 0;
> +	struct device *dev __free(put_device) = bus_find_device(
> +		&cxl_bus_type, NULL, res, region_contains_resource);
> +	return !!dev;
>  }
>  EXPORT_SYMBOL_FOR_MODULES(cxl_region_contains_resource, "dax_hmem");
>  
> diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
> index 0051e553c33f..b2ab1292fa81 100644
> --- a/drivers/dax/hmem/hmem.c
> +++ b/drivers/dax/hmem/hmem.c
> @@ -159,7 +159,7 @@ static int hmem_register_cxl_device(struct device *host, int target_nid,
>  			      IORES_DESC_CXL) == REGION_DISJOINT)
>  		return 0;
>  
> -	if (cxl_region_contains_resource((struct resource *)res)) {
> +	if (cxl_region_contains_resource(res)) {
>  		dev_dbg(host, "CXL claims resource, dropping: %pr\n", res);
>  		return 0;
>  	}

