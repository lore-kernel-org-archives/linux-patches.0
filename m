Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4349E37F303
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 08:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787733568; cv=none; b=fKCbz2YdMvj+rDyTtLNqxSYxU/wfQojCGZ+583rZSfhtcsEUxYUKZuSbnt70Qj+tMs3w0+3VVY3EsNCPUWyadmFkloryJD17xk5EHn3i7UuDMLHEua92ZzoZ66X0dD5YjwN7O6UA8xVvGxpyrbrD6GojDxKaGCk2BK6Xq5xzOBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787733568; c=relaxed/simple;
	bh=TdZ8UFNh1OALXK9j0y/76G5BZoSIOCMAqrFD1yHPzKc=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ZCNJOxRO4AwjZ1ySKJwo8iG3oagbcByrMPRSD44v2aY5jXI6S/CsYbqL/L7VSEEAyjxRCiVfUNb6FxC7GLsaxw4Me6KMXtrZN0qJZ9ql25Zqu5l4TGLKQ2fDcHCAzgDnuIHl6lZLt9Dmm0FHQ8bKnq+pdt1GhKzSQn5T881AbRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V0PRV0Mv; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V0PRV0Mv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787733566; x=1819269566;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=TdZ8UFNh1OALXK9j0y/76G5BZoSIOCMAqrFD1yHPzKc=;
  b=V0PRV0MvIZOPN9f1ayZ+6ddUxXqsdVkz/JUXZ1OXZqYZHxdcLRve0A96
   sgVr9nmmvT9qMj1WHYn4Jb/PErsoXo1O0ZB+5vmSH0EV4OAYZGQ8DGYVb
   perSIxCcbt5v82e40ducTk5TGtSq6ikhyHdEr4Ate3L5AGl4sciHqCMxx
   aT8aSw2hGnO8XKtSuDbnouMaDZ6T9PZuNZaDPXR2Ju0CjSdcrSK4N13M9
   aRwGleKhgzl8s6RnTiseZu3UuUZmrc4dK/V+h+aPcHniqpLBa4tSdc8AM
   1NqNYUJKcJgvKqOtAeWlo9v+VkwZcMSVuxjt8XFhTekiea72Pem/LsYca
   g==;
X-CSE-ConnectionGUID: D64FKs0bTVKHfSvfISgXZw==
X-CSE-MsgGUID: Entx1cBfT82eR/MZeV00Vw==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="105588191"
X-IronPort-AV: E=Sophos;i="6.25,244,1779174000"; 
   d="scan'208";a="105588191"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2026 01:39:26 -0700
X-CSE-ConnectionGUID: PBtX6s1IThmjYuDWm4PyWA==
X-CSE-MsgGUID: pPBjI0rKThuYUGkwenanNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,244,1779174000"; 
   d="scan'208";a="263224045"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.247])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2026 01:39:22 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Wed, 26 Aug 2026 11:39:18 +0300 (EEST)
To: Tony Luck <tony.luck@intel.com>
cc: Hans de Goede <hansg@kernel.org>, Borislav Petkov <bp@alien8.de>, 
    Breno Leitao <leitao@debian.org>, platform-driver-x86@vger.kernel.org, 
    LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
    Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: Re: [PATCH 7/7] platform/x86/intel/bff: Report frequent filter
 resets
In-Reply-To: <20260825181526.13203-8-tony.luck@intel.com>
Message-ID: <80796712-e183-45d5-1325-553dd0e9d409@linux.intel.com>
References: <20260825181526.13203-1-tony.luck@intel.com> <20260825181526.13203-8-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 25 Aug 2026, Tony Luck wrote:

> If an instance of a bitfix filter contains some transient errors built
> up over time, then resetting the filter will free up slots in the filter
> to store persistent errors.
> 
> Save a time stamp when "yellow" status is seen and clear the filter.
> 
> Log at KERN_WARNING level if the overflow occurred quickly after a
> previous overflow on the same bitfix filter instance. Use KERN_NOTICE
> for first, or long delayed, overflow.
> 
> Co-developed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  drivers/platform/x86/intel/bff.c | 71 +++++++++++++++++++++++++++++++-
>  1 file changed, 70 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/platform/x86/intel/bff.c b/drivers/platform/x86/intel/bff.c
> index ae9dc0bf2777..7c22a1ad6b9d 100644
> --- a/drivers/platform/x86/intel/bff.c
> +++ b/drivers/platform/x86/intel/bff.c
> @@ -23,14 +23,19 @@
>  #include <linux/cpufeature.h>
>  #include <linux/cpuhplock.h>
>  #include <linux/device-id/x86_cpu.h>
> +#include <linux/err.h>
>  #include <linux/errno.h>
> +#include <linux/gfp_types.h>
>  #include <linux/init.h>
> +#include <linux/jiffies.h>
>  #include <linux/limits.h>
>  #include <linux/module.h>
>  #include <linux/notifier.h>
>  #include <linux/printk.h>
> +#include <linux/slab.h>
>  #include <linux/topology.h>
>  #include <linux/types.h>
> +#include <linux/xarray.h>

A bonus point from paying attention to having necessary includes already 
in v1 throughout the series. :-) (No action required, I'm just happy to 
see that for a change.)

>  #include <asm/cpu_device_id.h>
>  #include <asm/cpufeatures.h>
> @@ -39,6 +44,16 @@
>  #include <asm/msr.h>
>  #include <asm/msr-index.h>
>  
> +/*
> + * A 10-minute observation period helps distinguish between:
> + *
> + *  - A long-term accumulation of transient corrected errors
> + *    (filter stays clear after reset).
> + *
> + *  - Permanent defects (filter overflows again quickly).
> + */
> +#define BFF_OVERFLOW_INTERVAL   secs_to_jiffies(10 * 60)
> +
>  #define NUM_IMH_PER_SKT		2
>  
>  /* Intel bitfix filter control register defines */
> @@ -74,6 +89,8 @@ MODULE_DEVICE_TABLE(x86cpu, bff_cpu_ids);
>  
>  static const enum bff_type *bank_types;
>  
> +static DEFINE_XARRAY(bff_bank_xa);
> +
>  /* Diamond Rapids maps APICID[2] to the IMH instance. */
>  static void bff_set_imh_id(struct mce *mce, unsigned long *id)
>  {
> @@ -139,13 +156,58 @@ static unsigned long get_bff_id(struct mce *mce)
>  	return id;
>  }
>  
> +/*
> + * Save current timestamp for bff_id. Return true if it is within
> + * BFF_OVERFLOW_INTERVAL of previous timestamp for this bff_id.
> + */
> +static bool bff_note_event_and_check_burst(unsigned long bff_id)
> +{
> +	unsigned long now = jiffies, when;
> +	unsigned long *ts;
> +
> +	if (bff_id == ULONG_MAX)
> +		return false;
> +
> +	ts = xa_load(&bff_bank_xa, bff_id);
> +	if (!ts) {
> +		ts = kzalloc_obj(*ts);
> +		if (!ts) {
> +			pr_warn("Timestamp allocation failed\n");
> +			return false;
> +		}
> +		if (IS_ERR(xa_store(&bff_bank_xa, bff_id, ts, GFP_KERNEL))) {
> +			kfree(ts);
> +			pr_warn("Timestamp save failure\n");
> +			return false;
> +		}
> +		*ts = now;
> +
> +		return false;
> +	}
> +
> +	when = *ts + BFF_OVERFLOW_INTERVAL;

You could try to name "when" more descriptively so the name tells its the 
end of the ("too fast") burst time window.

> +	*ts = now;
> +
> +	return time_before(now, when);
> +}
> +
>  static void handle_bff(struct mce *mce)
>  {
> +	bool burst = false;
> +
>  	/* The bitfix filter overflowed, get the target CPU to reset it. */
>  	if (wrmsrq_on_cpu(mce->extcpu, MSR_MCx_BFF_CTL(mce->bank), MCI_BFF_RESET))
>  		pr_warn("Failed to reset bitfix filter for CPU %d Bank %d\n", mce->extcpu, mce->bank);
>  
> -	pr_debug("unique_id = 0x%lx\n", get_bff_id(mce));
> +	/* Get unique id for bitfix filter instance that overflowed */
> +	burst = bff_note_event_and_check_burst(get_bff_id(mce));
> +
> +	if (burst)
> +		pr_warn_ratelimited(HW_ERR "Socket %d CPU %d Bank %d bitfix filter overflowed frequently\n",
> +				    mce->socketid, mce->extcpu, mce->bank);
> +	else
> +		pr_notice_ratelimited(HW_ERR "Socket %d CPU %d Bank %d bitfix filter overflowed\n",
> +				      mce->socketid, mce->extcpu, mce->bank);
>  }
>  
>  static int bff_mce_notify(struct notifier_block *nb, unsigned long val, void *data)
> @@ -205,7 +267,14 @@ static int __init bff_init(void)
>  
>  static void __exit bff_exit(void)
>  {
> +	unsigned long bff_id;
> +	unsigned long *ts;
> +
>  	mce_unregister_decode_chain(&bff_notifier);
> +
> +	xa_for_each(&bff_bank_xa, bff_id, ts)
> +		kfree(ts);
> +	xa_destroy(&bff_bank_xa);
>  }
>  
>  module_init(bff_init);
> 

-- 
 i.

