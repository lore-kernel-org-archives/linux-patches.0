Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C8A3B7B76
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 08:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787732264; cv=none; b=lIos69XWm6OSSu2WHkWa/ziFfGuazTKfdx/Ej7ssy/D2011fz2TRDu7kqb/RJrXmgm19pwCuSjfshU7C0/KJHiNxk44Z27cJoeJw53nqR7vKl/14cz33yrl0hX9ltuVQnLuFQt6sLQBWEZO/sBoVKQCBpvJKbeqBEX4ZH8HutGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787732264; c=relaxed/simple;
	bh=yoZPihR4dSN3Arf8/6Tjk5TGnhIQyxFA6g6a1jMa4hU=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=sdOZxs6YK5MZeJrdI8MrlBhMyWGDFcaCxJgskVJePibn8+NZ5F7vwv69XAlG7kBJbXpzZQLm9FVjd5pKhhZILs96qEzXPAQ4xwlgfStRbCMKYOjWPoRs15iXrIaC+TMpvUUdFmLf/qbRaRUiB8gP6W6dEQX71KGDXL611w2EpRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L9DUvTbG; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L9DUvTbG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787732261; x=1819268261;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=yoZPihR4dSN3Arf8/6Tjk5TGnhIQyxFA6g6a1jMa4hU=;
  b=L9DUvTbGFjF8FssJ0olqZ5orpwy9D/OJkuN3C3t+MQ5RGPIY0KDqAwdm
   tV6QspFopBFMIF5HgXzMVAiF1eWsP8oeqRW6mH+tGHn4AOPRYDu3J1pZZ
   APQSy2JvKWZ+WFTQRGQ6XOmQOkjztDn/uNioxyte0fRfe0smxIQt4OxmI
   lBWn2LrUu8R1Q1yKRjNsk3CCf6dvWz8trSm6lolHvw+6ppj5ZEaE28zmY
   uYMb5q58IEU4Db6L4nhjll9r6CeuovGMB1rXUgc2EX0MFJGQT7H/e1OQi
   6qtJGWMSky425jhxhOH94dRLWzosSsuCUqBRAHKgWeH+Dt10hDgv8Kp3T
   g==;
X-CSE-ConnectionGUID: akgQaP1oT6WsisDX21aD8g==
X-CSE-MsgGUID: MpCoAmrZR9CjGZl2Ys27pg==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="90720012"
X-IronPort-AV: E=Sophos;i="6.25,244,1779174000"; 
   d="scan'208";a="90720012"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2026 01:17:39 -0700
X-CSE-ConnectionGUID: pi5CYKv+R4iXy57VC7bWhg==
X-CSE-MsgGUID: 3wWPmRteSG2HTAppwvxOKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,244,1779174000"; 
   d="scan'208";a="269462537"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.247])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2026 01:17:35 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Wed, 26 Aug 2026 11:17:31 +0300 (EEST)
To: Tony Luck <tony.luck@intel.com>
cc: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
    Hans de Goede <hansg@kernel.org>, Borislav Petkov <bp@alien8.de>, 
    Breno Leitao <leitao@debian.org>, platform-driver-x86@vger.kernel.org, 
    linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
    Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: Re: [PATCH 4/7] platform/x86/intel/bff: Add Diamond Rapids support
In-Reply-To: <20260825181526.13203-5-tony.luck@intel.com>
Message-ID: <1dd80e86-aba7-0cf9-c2ca-5f72c9f0dcf3@linux.intel.com>
References: <20260825181526.13203-1-tony.luck@intel.com> <20260825181526.13203-5-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 25 Aug 2026, Tony Luck wrote:

> There are potentially bitfix filters associated with each machine check
> bank. Only some banks may implement them.
> 
> Machine check banks have varying scope. E.g. there is a separate L2
> cache for each module, each instance has its own bitfix filter.
> 
> Add information that will be used to map a <cpu,bank> pair to a unique
> instance number for a bitfix filter.
> 
> Co-developed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  drivers/platform/x86/intel/bff.c | 41 ++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
> 
> diff --git a/drivers/platform/x86/intel/bff.c b/drivers/platform/x86/intel/bff.c
> index 9522bdb1401d..6360bbc92347 100644
> --- a/drivers/platform/x86/intel/bff.c
> +++ b/drivers/platform/x86/intel/bff.c
> @@ -18,18 +18,51 @@
>  #define pr_fmt(fmt) "bff: " fmt
>  
>  #include <linux/cpufeature.h>
> +#include <linux/device-id/x86_cpu.h>
>  #include <linux/errno.h>
>  #include <linux/init.h>
>  #include <linux/module.h>
> +#include <linux/printk.h>
>  #include <linux/types.h>
>  
> +#include <asm/cpu_device_id.h>
>  #include <asm/cpufeatures.h>
> +#include <asm/intel-family.h>
>  #include <asm/mce.h>
>  #include <asm/msr.h>
>  #include <asm/msr-index.h>
>  
> +/* Machine check bank scope types */
> +enum bff_type {
> +	BFF_NONE = 0,
> +	BFF_BANK_DCU,
> +	BFF_BANK_DTLB,
> +	BFF_BANK_MLC,
> +	BFF_BANK_CCF,
> +	BFF_BANK_HSF,
> +	BFF_BANK_IOCACHE,
> +};
> +
> +static const enum bff_type dmr_mcbanks[MAX_NR_BANKS] = {
> +	[1]	= BFF_BANK_DCU,
> +	[2]	= BFF_BANK_DTLB,
> +	[3]	= BFF_BANK_MLC,
> +	[6]	= BFF_BANK_CCF,
> +	[13]	= BFF_BANK_HSF,
> +	[17]	= BFF_BANK_IOCACHE

Please add trailing comma.

> +};
> +
> +static const struct x86_cpu_id bff_cpu_ids[] __initconst = {
> +	X86_MATCH_VFM(INTEL_DIAMONDRAPIDS_X, dmr_mcbanks),
> +	{}
> +};
> +MODULE_DEVICE_TABLE(x86cpu, bff_cpu_ids);
> +
> +static const enum bff_type *bank_types;
> +
>  static int __init bff_init(void)
>  {
> +	const struct x86_cpu_id *m;
>  	u64 core_caps, mcg_cap;
>  
>  	if (!cpu_feature_enabled(X86_FEATURE_MCA))
> @@ -45,6 +78,14 @@ static int __init bff_init(void)
>  	if (!(core_caps & MSR_IA32_CORE_CAPS_BFF_RESET_DETECT))
>  		return -ENODEV;
>  
> +	m = x86_match_cpu(bff_cpu_ids);
> +	if (!m) {
> +		pr_info("CPU supports bitfix filter, but driver does not\n");
> +		return -ENODEV;
> +	}
> +
> +	bank_types = (const enum bff_type *)m->driver_data;
> +
>  	return 0;
>  }
>  
> 

-- 
 i.

