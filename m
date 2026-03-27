Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD55E1D88A4
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 16:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774629566; cv=none; b=ayP5VmeWIAzWrG2w+P/Q1ls/cWBCK3u8H2r7BHRqPZsfOgswoePEEt70XaNV+Oqcdd0eBA+t4tEMsWzBHyvaldIBeKvTtXuD7Indf4o5XeODApeEGAGKkoDPmrxGzWKSIPhNt6iIC4BBzl8el6rK+7C1j3c9OeecWK2SNMXjyUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774629566; c=relaxed/simple;
	bh=Ug/ab8iP6ME2l07TVsC5v2v1bKrKqfhaUnvTrMu3giQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XzFvlITd55TU9+QXXlgF4HxOpCnCZGxZMUVwWc9U1rDXM35NTY1JKurPLPzmkLyHjMFqkwEz6kZy9E90LOG7NfW6jnP90U+Bv52cWCGlfaFo6az4iNz/DL3W9ciPo1l9eHg+I6FdjFAFt5aXLYJ1yOidydEi79DjM6jUh8BRuyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YYvN6frn; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YYvN6frn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774629565; x=1806165565;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ug/ab8iP6ME2l07TVsC5v2v1bKrKqfhaUnvTrMu3giQ=;
  b=YYvN6frnVAAgfjHacrqpZNwe/yuiXdZucpwnR22nJfzkJjyysekY2C3f
   mpn8wHQWVG8t35PJ22b0cVdtbmNTnpM7Z/cAPhi0lWAuunSHL0u+fjZUY
   VgQK2t08ea18nRLMSHuaY0VH7IqI+Y4IQn3R7ZLy/v4vBhVcHFxNSaZ2S
   6UD1bDXxEw7WtidSFWDDLXo6+cZeburAClECLadCnwaW6WDt/3IfAcsEn
   fFuh98YxpxliiQAdA7wntISpGaTM1QsdNco4qosgyufQfOEXdzJi6aYyO
   Cnw2me51pks+oQuZj0W1BnnTkhQPU2g7zhObhtT4huQo/UhAId7wjOS3x
   g==;
X-CSE-ConnectionGUID: HZ9FdXNpQwiKcw1+mK6+Nw==
X-CSE-MsgGUID: d8FPqtufSniOkb966h54HA==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="86326654"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="86326654"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 09:39:24 -0700
X-CSE-ConnectionGUID: snGvkQs/RUexVI2i5JPEEA==
X-CSE-MsgGUID: Lg8nEkwZRn2UGT/u1WRWDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="229859616"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.180]) ([10.125.110.180])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 09:39:23 -0700
Message-ID: <37a5ee0d-c60d-4775-8fbb-1c94247e7bb8@intel.com>
Date: Fri, 27 Mar 2026 09:39:22 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/9] cxl/region: Limit visibility of
 cxl_region_contains_resource()
To: Dan Williams <dan.j.williams@intel.com>
Cc: patches@lists.linux.dev, linux-cxl@vger.kernel.org,
 alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-4-dan.j.williams@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260327052821.440749-4-dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/26/26 10:28 PM, Dan Williams wrote:
> The dax_hmem dependency on cxl_region_contains_resource() is a one-off
> special case. It is not suitable for other use cases.
> 
> Move the definition to the other CONFIG_CXL_REGION guarded definitions in
> drivers/cxl/cxl.h and include that by a relative path include. This matches
> what drivers/dax/cxl.c does for its limited private usage of CXL core
> symbols.
> 
> Reduce the symbol export visibility from global to just dax_hmem, to
> further clarify its applicability.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/cxl/cxl.h         |  5 +++++
>  include/cxl/cxl.h         | 15 ---------------
>  drivers/cxl/core/region.c |  3 +--
>  drivers/dax/hmem/hmem.c   |  2 +-
>  4 files changed, 7 insertions(+), 18 deletions(-)
>  delete mode 100644 include/cxl/cxl.h
> 
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 30a31968f266..84ad04a02bde 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -941,6 +941,7 @@ struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
>  int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
>  struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
>  u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa);
> +bool cxl_region_contains_resource(struct resource *res);
>  #else
>  static inline bool is_cxl_pmem_region(struct device *dev)
>  {
> @@ -963,6 +964,10 @@ static inline u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint,
>  {
>  	return 0;
>  }
> +static inline bool cxl_region_contains_resource(struct resource *res)
> +{
> +	return false;
> +}
>  #endif
>  
>  void cxl_endpoint_parse_cdat(struct cxl_port *port);
> diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
> deleted file mode 100644
> index b12d3d0f6658..000000000000
> --- a/include/cxl/cxl.h
> +++ /dev/null
> @@ -1,15 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0-only */
> -/* Copyright (c) 2026 Advanced Micro Devices, Inc. */
> -#ifndef _CXL_H_
> -#define _CXL_H_
> -
> -#ifdef CONFIG_CXL_REGION
> -bool cxl_region_contains_resource(struct resource *res);
> -#else
> -static inline bool cxl_region_contains_resource(struct resource *res)
> -{
> -	return false;
> -}
> -#endif
> -
> -#endif /* _CXL_H_ */
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index b72556c1458b..12a9572f34d5 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -12,7 +12,6 @@
>  #include <linux/idr.h>
>  #include <linux/memory-tiers.h>
>  #include <linux/string_choices.h>
> -#include <cxl/cxl.h>
>  #include <cxlmem.h>
>  #include <cxl.h>
>  #include "core.h"
> @@ -4253,7 +4252,7 @@ bool cxl_region_contains_resource(struct resource *res)
>  	return bus_for_each_dev(&cxl_bus_type, NULL, res,
>  				region_contains_resource) != 0;
>  }
> -EXPORT_SYMBOL_GPL(cxl_region_contains_resource);
> +EXPORT_SYMBOL_FOR_MODULES(cxl_region_contains_resource, "dax_hmem");
>  
>  static int cxl_region_can_probe(struct cxl_region *cxlr)
>  {
> diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
> index 9ceda6b5cadf..0051e553c33f 100644
> --- a/drivers/dax/hmem/hmem.c
> +++ b/drivers/dax/hmem/hmem.c
> @@ -3,7 +3,7 @@
>  #include <linux/memregion.h>
>  #include <linux/module.h>
>  #include <linux/dax.h>
> -#include <cxl/cxl.h>
> +#include "../../cxl/cxl.h"
>  #include "../bus.h"
>  
>  static bool region_idle;

