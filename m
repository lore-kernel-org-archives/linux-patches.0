Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DFD3B19C4
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 08:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787732815; cv=none; b=QyDCEvuGnYPaPH2IkH/aewrS9hT1DOuGcbRFUxoA3JFL+Vds+7+OB0OEcCO5ZjIcBxiQ0WKA9qlmr/NElwL6NtNVhGVUcSzmmqL+m5l1YzOlkhgab1IsY6RlwTNlasM226yUIL1JozSfNsmYnRHU8F3FH+J8TOk5xmwDstl1vOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787732815; c=relaxed/simple;
	bh=YQoJBloZZGt7uTocKg9hFKKJgPxjlonzNB1GRS8X5/8=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=jDyjVgc07D85FY0l89KuToquhGwGLwBUMcnoBzc97oqTU/YKBkBU1JTo7OO78BI6l+EYZhQGa5tKkx0k4beunR3zN6ytXKeZ91kcnA4CB8CylZFrBlydKwhN4Vju1Z75oytR31IFjLpr4QlcvqKuDmrEKfAHFNOblFrmqDpOodk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T40dWqHF; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T40dWqHF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787732809; x=1819268809;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=YQoJBloZZGt7uTocKg9hFKKJgPxjlonzNB1GRS8X5/8=;
  b=T40dWqHFVwCyqNwH6V3mUPCojK5wcD+uuLCgqn/OqxDV4gsMNeJoEOL2
   DXJ4dmjoDvE40JtbM3DWhhnWZgUn78xtXTny7S47PNieGyOtaJXUGWXPB
   FlQYXBhaPD9mtuHvq7aL9zSZLC5VS070BrcgOR5flbaujrqYObFkAiRXn
   tSqczxKqoTBKc1XZ/M6nR2Ln1GKhBWC8msMzPJA0fewGELvlFQZ93oyYb
   PdtySv3NchOtBFpuyP6JKhBs/pqf4viL4WUe1oJmthetlCBOlgQzpucZ0
   zVgDCV/uU51d32vlivERrOzk7NbZCjB4Llc5/BcLmyL2ih+cDbVAq9T3N
   Q==;
X-CSE-ConnectionGUID: dFZup9jGTkyj8/CFd4csTA==
X-CSE-MsgGUID: wxpex8hLQm+yHJu7U0fGIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="92025803"
X-IronPort-AV: E=Sophos;i="6.25,244,1779174000"; 
   d="scan'208";a="92025803"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2026 01:26:45 -0700
X-CSE-ConnectionGUID: Se2kcoxpThikA6TsG1HgYw==
X-CSE-MsgGUID: t1Bp7y4gR8+Er/Kdgtn6Zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,244,1779174000"; 
   d="scan'208";a="261382200"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.247])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2026 01:26:42 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Wed, 26 Aug 2026 11:26:37 +0300 (EEST)
To: Tony Luck <tony.luck@intel.com>
cc: Hans de Goede <hansg@kernel.org>, Borislav Petkov <bp@alien8.de>, 
    Breno Leitao <leitao@debian.org>, platform-driver-x86@vger.kernel.org, 
    LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
    Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: Re: [PATCH 6/7] platform/x86/intel/bff: Compute unique ID for
 overflowed filter
In-Reply-To: <20260825181526.13203-7-tony.luck@intel.com>
Message-ID: <c62f28a7-25a0-8b74-ae8c-9aca146c8ea9@linux.intel.com>
References: <20260825181526.13203-1-tony.luck@intel.com> <20260825181526.13203-7-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 25 Aug 2026, Tony Luck wrote:

> Each L2 cache instance has its own bitfix filter, but always reports
> errors in machine check bank 3 (on Diamond Rapids).
> 
> Compute a unique bitfix filter instance number based on the CPU that
> logged the error and the machine check bank number.
> 
> Special case for banks associated with the Integrated Memory Hub (IMH).
> Here the "even" numbered CPU modules are associated with IMH0 and the
> "odd" modules with IMH1.
> 
> The unique id will be used to store a time stamp of when the bitfix
> filter overflowed so that frequent overflows can be logged.
> 
> Co-developed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  drivers/platform/x86/intel/bff.c | 74 ++++++++++++++++++++++++++++++++
>  1 file changed, 74 insertions(+)
> 
> diff --git a/drivers/platform/x86/intel/bff.c b/drivers/platform/x86/intel/bff.c
> index 8cc29d11e019..ae9dc0bf2777 100644
> --- a/drivers/platform/x86/intel/bff.c
> +++ b/drivers/platform/x86/intel/bff.c
> @@ -18,13 +18,18 @@
>  #define pr_fmt(fmt) "bff: " fmt
>  
>  #include <linux/bits.h>
> +#include <linux/cacheinfo.h>
> +#include <linux/cleanup.h>
>  #include <linux/cpufeature.h>
> +#include <linux/cpuhplock.h>
>  #include <linux/device-id/x86_cpu.h>
>  #include <linux/errno.h>
>  #include <linux/init.h>
> +#include <linux/limits.h>
>  #include <linux/module.h>
>  #include <linux/notifier.h>
>  #include <linux/printk.h>
> +#include <linux/topology.h>
>  #include <linux/types.h>
>  
>  #include <asm/cpu_device_id.h>
> @@ -34,6 +39,8 @@
>  #include <asm/msr.h>
>  #include <asm/msr-index.h>
>  
> +#define NUM_IMH_PER_SKT		2
> +
>  /* Intel bitfix filter control register defines */
>  #define MSR_MC0_BFF_CTL		0x000006c0
>  #define MSR_MCx_BFF_CTL(x)	(MSR_MC0_BFF_CTL + (x))
> @@ -67,11 +74,78 @@ MODULE_DEVICE_TABLE(x86cpu, bff_cpu_ids);
>  
>  static const enum bff_type *bank_types;
>  
> +/* Diamond Rapids maps APICID[2] to the IMH instance. */
> +static void bff_set_imh_id(struct mce *mce, unsigned long *id)
> +{
> +	int imh_num = (NUM_IMH_PER_SKT * topology_physical_package_id(mce->extcpu)) +
> +		      ((mce->apicid >> 2) & 0x1);

FIELD_GET(), I suggest moving comment where you define the field for that.

> +
> +	*id |= imh_num;
> +}
> +
> +static bool bff_set_cache_id(int cpu, int level, unsigned long *id)
> +{
> +	int cacheid;
> +
> +	guard(cpus_read_lock)();
> +
> +	cacheid = get_cpu_cacheinfo_id(cpu, level);
> +	if (cacheid == -1) {
> +		pr_warn("Could not get L%d cache id for CPU %d\n", level, cpu);
> +		return false;
> +	}
> +
> +	*id |= cacheid;
> +
> +	return true;
> +}
> +
> +#define BFF_ID_BANK_SHIFT	16
> +
> +/*
> + * Cache IDs are only unique within a cache level.
> + * Include the MCA bank number so each BFF-capable hardware
> + * resource has a unique tracking ID.
> + */
> +static unsigned long get_bff_id(struct mce *mce)
> +{
> +	unsigned long id = (unsigned long)mce->bank << BFF_ID_BANK_SHIFT;

FIELD_PREP() ?

> +
> +	switch (bank_types[mce->bank]) {
> +	case BFF_BANK_DCU:
> +	case BFF_BANK_DTLB:
> +		if (!bff_set_cache_id(mce->extcpu, 1, &id))
> +			return ULONG_MAX;
> +		break;
> +
> +	case BFF_BANK_MLC:
> +		if (!bff_set_cache_id(mce->extcpu, 2, &id))
> +			return ULONG_MAX;
> +		break;
> +
> +	case BFF_BANK_CCF:
> +		if (!bff_set_cache_id(mce->extcpu, 3, &id))
> +			return ULONG_MAX;
> +		break;
> +
> +	case BFF_BANK_HSF:
> +	case BFF_BANK_IOCACHE:
> +		bff_set_imh_id(mce, &id);
> +		break;
> +	default:
> +		return ULONG_MAX;
> +	}
> +
> +	return id;
> +}
> +
>  static void handle_bff(struct mce *mce)
>  {
>  	/* The bitfix filter overflowed, get the target CPU to reset it. */
>  	if (wrmsrq_on_cpu(mce->extcpu, MSR_MCx_BFF_CTL(mce->bank), MCI_BFF_RESET))
>  		pr_warn("Failed to reset bitfix filter for CPU %d Bank %d\n", mce->extcpu, mce->bank);
> +
> +	pr_debug("unique_id = 0x%lx\n", get_bff_id(mce));
>  }
>  
>  static int bff_mce_notify(struct notifier_block *nb, unsigned long val, void *data)
> 

-- 
 i.

