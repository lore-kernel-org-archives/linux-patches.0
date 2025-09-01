Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BEC241673
	for <patches@lists.linux.dev>; Mon,  1 Sep 2025 09:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756718161; cv=none; b=lU5kHIFMt0L8oXkb6SdM3xrAR0k8AZdbcWgTlHIvTJXGYd0h3i5e4shign8rDNIRlZD/c9mHjfn3Ir5Bd20u1XVpbVmXhZX4P8eeFueFHz0s9CDo/ni3619wrXM9Sx4+s00oV5rd8Na7cG4eN6JffqHZfIhiX4YERrMXy1uSDQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756718161; c=relaxed/simple;
	bh=uZf2IakSfTQaFKX1vM1m/YK6WJ46fYXNBqBBEW+YLNs=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=mnLfJWFxQmHsehgqk7rsAVxui6yTg4KQ5mims+LK7qhCI6UVyb/XcgN3As2t0GeRN6cGcSZ2A0FOeRYIs3UhwjENMj43FKDP435bOquUJWQnEp8PXg2jXpjmYJI8H08kC0w1EQnjkI4/pls2LVRxDy0ZSXfCeqDzu2b9o00b1EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mBsUcqEv; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mBsUcqEv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756718160; x=1788254160;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=uZf2IakSfTQaFKX1vM1m/YK6WJ46fYXNBqBBEW+YLNs=;
  b=mBsUcqEvvg43kE0o6PSZ3g2ZDrulRQ7Tv7dXZQaUb/068eSTYz1SQZkY
   n7gnpBMjQfNcF5/wOeYTWloXb/B+k39Wk+bHQRLLsavlgt9lH+RCp0BNs
   1HYaMydepO7FtmdY1cUWRj2mnVoWuwDh7vrNfFtNTOSg98BM6LTjHvIua
   cyVJhq3CLX9hE/diyrHGcYoEDvCoUgytNStit05vm0rYljbl4QQpAeKN7
   s4cWFkju0RPWt/I3klarns40h31Cbkx3POLKZiWvaWYFeTNnojB7ncu6g
   4tQ2GDL8NTzYR8Z5zKh1VSlfIOvpxjex77xyNRYvRIz7yRiphl6cDPC7g
   A==;
X-CSE-ConnectionGUID: F2C3M3FJSgyEAuMGyV8tOA==
X-CSE-MsgGUID: DDMOkLicSKudhLQHpzrAfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11539"; a="70074978"
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="70074978"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 02:15:59 -0700
X-CSE-ConnectionGUID: pu9mFY/bSc294BZqaXtguA==
X-CSE-MsgGUID: k62oB3IsSImcrt2AF5Cr2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="201920497"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.193])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 02:15:53 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Mon, 1 Sep 2025 12:15:49 +0300 (EEST)
To: Tony Luck <tony.luck@intel.com>
cc: Fenghua Yu <fenghuay@nvidia.com>, 
    Reinette Chatre <reinette.chatre@intel.com>, 
    Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, 
    Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>, 
    Babu Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, 
    Dave Martin <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, 
    x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, 
    patches@lists.linux.dev
Subject: Re: [PATCH v9 21/31] x86/resctrl: Read telemetry events
In-Reply-To: <20250829193346.31565-22-tony.luck@intel.com>
Message-ID: <3b0546d4-d0bc-f76e-e1c2-eef2b4abf0f1@linux.intel.com>
References: <20250829193346.31565-1-tony.luck@intel.com> <20250829193346.31565-22-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 29 Aug 2025, Tony Luck wrote:

> Telemetry events are enumerated by the INTEL_PMT_TELEMETRY subsystem.
> resctrl enables events with resctrl_enable_mon_event() passing a pointer
> to the pmt_event structure for the event within the struct event_group.
> The file system stores it in mon_evt::arch_priv.
> 
> Clear the address field of regions that did not pass the checks in
> skip_this_region() so they will not be used by intel_aet_read_event().
> This is safe to do because intel_pmt_get_regions_by_feature() allocates
> a new pmt_feature_group structure to return to each caller and only
> makes use of the pmt_feature_group::kref field when
> intel_pmt_put_feature_group() returns the structure.
> 
> Add a check to resctrl_arch_rmid_read() for resource id
> RDT_RESOURCE_PERF_PKG and directly call intel_aet_read_event()
> passing the enum resctrl_event_id for the event and the arch_priv
> pointer that was supplied when the event was enabled.
> 
> There may be multiple aggregators tracking each package, so scan all of
> them and add up all counters. Aggregators may return an invalid data
> indication if they have received no records for a given RMID. Return
> success to the user if one or more aggregators provide valid data.
> 
> Resctrl now uses readq() so depends on X86_64. Update Kconfig.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/internal.h  |  7 ++++
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 53 ++++++++++++++++++++++++-
>  arch/x86/kernel/cpu/resctrl/monitor.c   |  3 ++
>  arch/x86/Kconfig                        |  2 +-
>  4 files changed, 63 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 9ddfbbe5c3cf..8986071dd72a 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -172,9 +172,16 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
>  bool intel_aet_get_events(void);
>  void __exit intel_aet_exit(void);
> +int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,
> +			 void *arch_priv, u64 *val);
>  #else
>  static inline bool intel_aet_get_events(void) { return false; }
>  static inline void __exit intel_aet_exit(void) { }
> +static inline int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,
> +				       void *arch_priv, u64 *val)
> +{
> +	return -EINVAL;
> +}
>  #endif
>  
>  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 5c5466dc3189..9239740e9647 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -14,6 +14,7 @@
>  #include <linux/cleanup.h>
>  #include <linux/cpu.h>
>  #include <linux/intel_vsec.h>
> +#include <linux/io.h>
>  #include <linux/resctrl.h>
>  
>  #include "internal.h"
> @@ -125,8 +126,14 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>  	bool usable_events = false;
>  
>  	for (int i = 0; i < p->count; i++) {
> -		if (skip_this_region(&p->regions[i], e))
> +		if (skip_this_region(&p->regions[i], e)) {
> +			/*
> +			 * Clear addr so that intel_aet_read_event() will
> +			 * skip this region.
> +			 */
> +			p->regions[i].addr = NULL;

As this is at least semi-hacky, I suggest you move it into own function 
and add a bit longer comment to the function (along the lines what the 
changelog also states why it works).

>  			continue;
> +		}
>  		usable_events = true;
>  	}
>  
> @@ -204,3 +211,47 @@ void __exit intel_aet_exit(void)
>  		(*peg)->pfg = NULL;
>  	}
>  }
> +
> +#define DATA_VALID	BIT_ULL(63)
> +#define DATA_BITS	GENMASK_ULL(62, 0)

+ linux/bits.h

> +
> +/*
> + * Read counter for an event on a domain (summing all aggregators
> + * on the domain). If an aggregator hasn't received any data for a
> + * specific RMID, the MMIO read indicates that data is not valid.
> + * Return success if at least one aggregator has valid data.
> + */
> +int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id eventid,
> +			 void *arch_priv, u64 *val)
> +{
> +	struct pmt_event *pevt = arch_priv;
> +	struct event_group *e;
> +	bool valid = false;
> +	u64 evtcount;
> +	void *pevt0;
> +	int idx;
> +
> +	pevt0 = pevt - pevt->idx;
> +	e = container_of(pevt0, struct event_group, evts);

+ linux/container_of.h

> +	idx = rmid * e->num_events;
> +	idx += pevt->idx;
> +
> +	if (idx * sizeof(u64) + sizeof(u64) > e->mmio_size) {
> +		pr_warn_once("MMIO index %d out of range\n", idx);
> +		return -EIO;
> +	}
> +
> +	for (int i = 0; i < e->pfg->count; i++) {
> +		if (!e->pfg->regions[i].addr)
> +			continue;
> +		if (e->pfg->regions[i].plat_info.package_id != domid)
> +			continue;
> +		evtcount = readq(e->pfg->regions[i].addr + idx * sizeof(u64));
> +		if (!(evtcount & DATA_VALID))
> +			continue;
> +		*val += evtcount & DATA_BITS;
> +		valid = true;
> +	}
> +
> +	return valid ? 0 : -EINVAL;
> +}
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 249569327e4a..0333dd85450b 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -232,6 +232,9 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
>  
>  	resctrl_arch_rmid_read_context_check();
>  
> +	if (r->rid == RDT_RESOURCE_PERF_PKG)
> +		return intel_aet_read_event(hdr->id, rmid, eventid, arch_priv, val);
> +
>  	if (r->rid != RDT_RESOURCE_L3)
>  		return -EINVAL;
>  
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 50051fdf4659..a42f749f31cb 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -527,7 +527,7 @@ config X86_CPU_RESCTRL
>  
>  config X86_CPU_RESCTRL_INTEL_AET
>  	bool "Intel Application Energy Telemetry" if INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
> -	depends on X86_CPU_RESCTRL && CPU_SUP_INTEL
> +	depends on X86_64 && X86_CPU_RESCTRL && CPU_SUP_INTEL
>  	help
>  	  Enable per-RMID telemetry events in resctrl.
>  
> 

-- 
 i.

