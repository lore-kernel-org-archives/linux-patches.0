Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500771E00A0
	for <patches@lists.linux.dev>; Mon,  1 Sep 2025 08:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756716007; cv=none; b=UwcAylRDQBFWpubO6Gtn2I0Zj8BnUgdaRagtsfAHfiYm4hmKTdsvYHKMeyq9HSGumSDesC3uQ0QFf8WFzSagWUtjM1fhYvKjv2RrCCvXdumsH9glsGHrzpOrlMiQdg07ToC9UpRVlstxWh5759D2Ia5XIAn+CmA62aYgJoUvDmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756716007; c=relaxed/simple;
	bh=L8ya84k8av++shUQG5N950EOECY4v3HYZMKkdf03dWo=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=XE/9JINyuwf/UAG5YXLmSLEMPeRrsvLv1XjwvbBvA5hS3ZqMhca2WaYUKPLfqqrCPK8tdrvNFRCYBN7smBaOQA2L6LUrWiFocuXgyTfE1kLpy+U8TstMNXuLYK0CxmnuB5DxEKRdRml13JAA5JxOxR0LDToRttfDuI3mbVosCYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nq/MG4BI; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nq/MG4BI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756716005; x=1788252005;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=L8ya84k8av++shUQG5N950EOECY4v3HYZMKkdf03dWo=;
  b=Nq/MG4BI4oDVlg7P3A9eI+Sz4uVyP31tyl2XbdIcTKg0YS3kBbM9729U
   Hv7fjo7FJqnl7KmynqyezVsebnFj1sMg/rem2qjXZWEcB+lO5OMFIJE6a
   bOAXb84fGonxnKR68qlvoX0LxLCPZl8NXed+BNf77qKv5C2eaW51v7XFF
   8iNZVO/1r30S5xnG3dXXPq9zv/PATCQJY8kkokdIGpoQ2dHHLsd2sOOIT
   x+KG+XvmKBR/gDW83SN7mlq2ABLA+9zkrDssoYENFCIo8vg8Vx+s1hyJH
   Nn+qCDh0D8u90P1/s7fRHgiychHbVyKuKQmTgZpDqBmHnk2cCpVFn/t6o
   g==;
X-CSE-ConnectionGUID: GEp0TWwVQTGizmIBNp2YpQ==
X-CSE-MsgGUID: 4xaymN/aR1e3L4yr9y3YqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11539"; a="62610159"
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="62610159"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 01:40:04 -0700
X-CSE-ConnectionGUID: ChOqJKo4TGGtlhA3ttG6Yw==
X-CSE-MsgGUID: 3Sbye7tvSdKLYtUg+r3bOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="170249300"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.193])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 01:40:00 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Mon, 1 Sep 2025 11:39:56 +0300 (EEST)
To: Tony Luck <tony.luck@intel.com>
cc: Fenghua Yu <fenghuay@nvidia.com>, 
    Reinette Chatre <reinette.chatre@intel.com>, 
    Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, 
    Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>, 
    Babu Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, 
    Dave Martin <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, 
    x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, 
    patches@lists.linux.dev
Subject: Re: [PATCH v9 17/31] x86/resctrl: Discover hardware telemetry
 events
In-Reply-To: <20250829193346.31565-18-tony.luck@intel.com>
Message-ID: <1cc035b1-7bd8-8fa9-e3d5-f530bcdec517@linux.intel.com>
References: <20250829193346.31565-1-tony.luck@intel.com> <20250829193346.31565-18-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 29 Aug 2025, Tony Luck wrote:

> Each CPU collects data for telemetry events that it sends to a nearby
> telemetry event aggregator either when the value of IA32_PQR_ASSOC.RMID
> changed, or when a two millisecond timer expires.
> 
> The telemetry event aggregators maintain per-RMID per-event counts of
> the total seen for all the CPUs. There may be more than one telemetry
> event aggregator per package.
> 
> Each telemetry event aggregator is responsible for a specific group of
> events. E.g. on the Intel Clearwater Forest CPU there are two types of
> aggregators. One type tracks a pair of energy related events. The other
> type tracks a subset of "perf" type events.
> 
> The event counts are made available to Linux in a region of MMIO space
> for each aggregator. All details about the layout of counters in each
> aggregator MMIO region are described in XML files published by Intel and
> made available in a GitHub repository: https://github.com/intel/Intel-PMT.
> 
> The key to matching a specific telemetry aggregator to the XML file that
> describes the MMIO layout is a 32-bit value. The Linux telemetry subsystem
> refers to this as a "guid" while the XML files call it a "uniqueid".
> 
> Each XML file provides the following information:
> 1) Which telemetry events are included in the group.
> 2) The order in which the event counters appear for each RMID.
> 3) The value type of each event counter (integer or fixed-point).
> 4) The number of RMIDs supported.
> 5) Which additional aggregator status registers are included.
> 6) The total size of the MMIO region for this aggregator.
> 
> The INTEL_PMT_TELEMETRY driver enumerates support for telemetry events.
> This driver provides intel_pmt_get_regions_by_feature() to list all
> available telemetry event aggregators. The list includes the "guid",
> the base address in MMIO space for the region where the event counters
> are exposed, and the package id where the CPUs that report to this
> aggregator are located.
> 
> Add a new Kconfig option CONFIG_X86_CPU_RESCTRL_INTEL_AET for the Intel
> specific parts of telemetry code. This depends on the INTEL_PMT_TELEMETRY
> and INTEL_TPMI drivers being built-in to the kernel for enumeration of
> telemetry features.
> 
> Call intel_pmt_get_regions_by_feature() for each pmt_feature_id that
> indicates per-RMID telemetry.
> 
> Save the returned pmt_feature_group pointers with guids that are known
> to resctrl for use at run time.  Those pointers are returned to the

Extra space

> INTEL_PMT_TELEMETRY subsystem at resctrl_arch_exit() time.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> Note that checkpatch complains about this:
> 
> DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,
> 		if (!IS_ERR_OR_NULL(_T))
> 			intel_pmt_put_feature_group(_T))
> with:
> CHECK: Alignment should match open parenthesis
> 
> But if the alignment is fixed, it then complains:
> WARNING: Statements should start on a tabstop
> ---
>  arch/x86/kernel/cpu/resctrl/internal.h  |   8 ++
>  arch/x86/kernel/cpu/resctrl/core.c      |   5 +
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 133 ++++++++++++++++++++++++
>  arch/x86/Kconfig                        |  13 +++
>  arch/x86/kernel/cpu/resctrl/Makefile    |   1 +
>  5 files changed, 160 insertions(+)
>  create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 6b3f3203edc4..9ddfbbe5c3cf 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -169,4 +169,12 @@ void __init intel_rdt_mbm_apply_quirk(void);
>  
>  void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  
> +#ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
> +bool intel_aet_get_events(void);
> +void __exit intel_aet_exit(void);
> +#else
> +static inline bool intel_aet_get_events(void) { return false; }
> +static inline void __exit intel_aet_exit(void) { }
> +#endif
> +
>  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 566530c6dbc3..57b34e1dc088 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -735,6 +735,9 @@ void resctrl_arch_pre_mount(void)
>  
>  	if (!atomic_try_cmpxchg(&only_once, &old, 1))
>  		return;
> +
> +	if (!intel_aet_get_events())
> +		return;
>  }
>  
>  enum {
> @@ -1087,6 +1090,8 @@ late_initcall(resctrl_arch_late_init);
>  
>  static void __exit resctrl_arch_exit(void)
>  {
> +	intel_aet_exit();
> +
>  	cpuhp_remove_state(rdt_online);
>  
>  	resctrl_exit();
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> new file mode 100644
> index 000000000000..45cadbb87dc8
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -0,0 +1,133 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Resource Director Technology(RDT)
> + * - Intel Application Energy Telemetry
> + *
> + * Copyright (C) 2025 Intel Corporation
> + *
> + * Author:
> + *    Tony Luck <tony.luck@intel.com>
> + */
> +
> +#define pr_fmt(fmt)   "resctrl: " fmt
> +
> +#include <linux/cleanup.h>
> +#include <linux/cpu.h>
> +#include <linux/intel_vsec.h>
> +#include <linux/resctrl.h>
> +
> +#include "internal.h"
> +
> +/**
> + * struct event_group - All information about a group of telemetry events.
> + * @pfg:		Points to the aggregated telemetry space information
> + *			within the INTEL_PMT_TELEMETRY driver that contains data for all
> + *			telemetry regions.
> + * @guid:		Unique number per XML description file.
> + */
> +struct event_group {
> +	/* Data fields for additional structures to manage this group. */
> +	struct pmt_feature_group	*pfg;
> +
> +	/* Remaining fields initialized from XML file. */
> +	u32				guid;
> +};
> +
> +/*
> + * Link: https://github.com/intel/Intel-PMT
> + * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
> + */
> +static struct event_group energy_0x26696143 = {
> +	.guid		= 0x26696143,
> +};
> +
> +/*
> + * Link: https://github.com/intel/Intel-PMT
> + * File: xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml
> + */
> +static struct event_group perf_0x26557651 = {
> +	.guid		= 0x26557651,
> +};
> +
> +static struct event_group *known_energy_event_groups[] = {
> +	&energy_0x26696143,
> +};
> +
> +static struct event_group *known_perf_event_groups[] = {
> +	&perf_0x26557651,
> +};
> +
> +#define for_each_enabled_event_group(_peg, _grp)			\
> +	for (_peg = _grp; _peg < &_grp[ARRAY_SIZE(_grp)]; _peg++)	\

+ linux/array_size.h

Wouldn't it be wiser to protect the args even if the current users seem 
fine?

> +		if ((*_peg)->pfg)
> +
> +/* Stub for now */
> +static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> +{
> +	return false;
> +}
> +
> +DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,
> +		if (!IS_ERR_OR_NULL(_T))
> +			intel_pmt_put_feature_group(_T))
> +
> +/*
> + * Make a request to the INTEL_PMT_TELEMETRY driver for the pmt_feature_group
> + * for a specific feature. If there is one the returned structure has an array

Missing comma?

> + * of telemetry_region structures. Each describes one telemetry aggregator.
> + * Try to use every telemetry aggregator with a known guid.
> + */
> +static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **evgs,
> +			    unsigned int num_evg)
> +{
> +	struct pmt_feature_group *p __free(intel_pmt_put_feature_group) = NULL;
> +	struct event_group **peg;
> +	int ret;
> +
> +	p = intel_pmt_get_regions_by_feature(feature);
> +
> +	if (IS_ERR_OR_NULL(p))

+ linux/err.h

> +		return false;
> +
> +	for (peg = evgs; peg < &evgs[num_evg]; peg++) {
> +		ret = enable_events(*peg, p);
> +		if (ret) {

This is super misleading. You place a bool returning function's return 
value into "int ret" and then use the value like bool.

> +			(*peg)->pfg = no_free_ptr(p);
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Ask INTEL_PMT_TELEMETRY driver for all the RMID based telemetry groups
> + * that it supports.
> + */
> +bool intel_aet_get_events(void)
> +{
> +	bool ret1, ret2;
> +
> +	ret1 = get_pmt_feature(FEATURE_PER_RMID_ENERGY_TELEM,
> +			       known_energy_event_groups,
> +			       ARRAY_SIZE(known_energy_event_groups));
> +	ret2 = get_pmt_feature(FEATURE_PER_RMID_PERF_TELEM,
> +			       known_perf_event_groups,
> +			       ARRAY_SIZE(known_perf_event_groups));
> +
> +	return ret1 || ret2;
> +}
> +
> +void __exit intel_aet_exit(void)
> +{
> +	struct event_group **peg;
> +
> +	for_each_enabled_event_group(peg, known_energy_event_groups) {
> +		intel_pmt_put_feature_group((*peg)->pfg);
> +		(*peg)->pfg = NULL;
> +	}
> +	for_each_enabled_event_group(peg, known_perf_event_groups) {
> +		intel_pmt_put_feature_group((*peg)->pfg);
> +		(*peg)->pfg = NULL;
> +	}
> +}
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 58d890fe2100..50051fdf4659 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -525,6 +525,19 @@ config X86_CPU_RESCTRL
>  
>  	  Say N if unsure.
>  
> +config X86_CPU_RESCTRL_INTEL_AET
> +	bool "Intel Application Energy Telemetry" if INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
> +	depends on X86_CPU_RESCTRL && CPU_SUP_INTEL
> +	help
> +	  Enable per-RMID telemetry events in resctrl.
> +
> +	  Intel feature that collects per-RMID execution data
> +	  about energy consumption, measure of frequency independent
> +	  activity and other performance metrics. Data is aggregated
> +	  per package.
> +
> +	  Say N if unsure.
> +
>  config X86_FRED
>  	bool "Flexible Return and Event Delivery"
>  	depends on X86_64
> diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
> index d8a04b195da2..273ddfa30836 100644
> --- a/arch/x86/kernel/cpu/resctrl/Makefile
> +++ b/arch/x86/kernel/cpu/resctrl/Makefile
> @@ -1,6 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
>  obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
>  obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
> +obj-$(CONFIG_X86_CPU_RESCTRL_INTEL_AET)	+= intel_aet.o
>  obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
>  
>  # To allow define_trace.h's recursive include:
> 

-- 
 i.

