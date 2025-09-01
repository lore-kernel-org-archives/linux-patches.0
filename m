Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBB52FF142
	for <patches@lists.linux.dev>; Mon,  1 Sep 2025 08:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756717039; cv=none; b=qKUovekIsfnTM3TWYFUL3BEEbfPpL63ESB+XWBhCGbd2yg/Aq3H7K0jk9Dq6EHRbA4aqClYDh9RpDfY7fN7CeFbom92iFw3DJBZPszjTxsWRz7ar7Ph2iou1oxyaqmmhxFOYednWnLqdR1iPDbqd9CYYYM2umN/yPV3JMHOf7TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756717039; c=relaxed/simple;
	bh=Yk6fLn0INaj6RN9SmaZR/R2PaWIJGBhRMtwRjYc9yJA=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=lidfTL9fFsazqNoGj202Xo61rLadZa1p5Z+NzPJwPLDXQIPZXrwCt+sWJRfZdQIr6CMQyJVsFG70ZqtD6nr2rVYFELmNIryXLpW+5XjD93IlJ1Zu3qqVtDWRSKMkCNsp7itHXsClgDyaernA9HYrLfgADaF7tVjuT78b0tAhwAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mRZnULSF; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mRZnULSF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756717036; x=1788253036;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=Yk6fLn0INaj6RN9SmaZR/R2PaWIJGBhRMtwRjYc9yJA=;
  b=mRZnULSFpCIu2vPqvITKVkx+VGA93k/7DDuPU9xSjOF8v67+6LLRoCBh
   WNCdJoV8eCf5KZuUIepm3zb31z3pUqVt2pz/dz21HmfWy2p12BBd55xk0
   iHrfj9u5ebcB68fri7xFnDkTRD/KjFeXsAKUFBdM80saBcwr54mZ7c/e4
   AE/DMjgwGlsbkALtW5ckM/kUmyVHb8809CTHOrzCbsTxCaUshNKkLTdQ8
   TU8VpvV9WzDsg1by2VrjM+wIXZCYIoYpnv2FkslTVhWaLP1r2F+hLTLsZ
   kzJ43vOwSrp2+4sST+9y7+gqPi558TOiBEvaOnWilOFHwPGzvGaubtWtE
   w==;
X-CSE-ConnectionGUID: zTOhdGtlRWa2AAwuW5zORw==
X-CSE-MsgGUID: uzMueovPQMGcOdR/zla0pw==
X-IronPort-AV: E=McAfee;i="6800,10657,11539"; a="46549089"
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="46549089"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 01:57:16 -0700
X-CSE-ConnectionGUID: 6rM9f+CbSCuRI7yAgxn4Og==
X-CSE-MsgGUID: dj7dX9/FQg2ysJcte38UhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="176276741"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.193])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 01:57:11 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Mon, 1 Sep 2025 11:57:07 +0300 (EEST)
To: Tony Luck <tony.luck@intel.com>
cc: Fenghua Yu <fenghuay@nvidia.com>, 
    Reinette Chatre <reinette.chatre@intel.com>, 
    Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, 
    Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>, 
    Babu Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, 
    Dave Martin <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, 
    x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v9 18/31] x86,fs/resctrl: Fill in details of events for
 guid 0x26696143 and 0x26557651
In-Reply-To: <20250829193346.31565-19-tony.luck@intel.com>
Message-ID: <e1ed273e-ec4a-076b-45ed-e6f17f063194@linux.intel.com>
References: <20250829193346.31565-1-tony.luck@intel.com> <20250829193346.31565-19-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 29 Aug 2025, Tony Luck wrote:

> The Intel Clearwater Forest CPU supports two RMID-based pmt feature
> groups documented in the xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
> and xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml files in the Intel PMT
> GIT repository here:
> 
> Link: https://github.com/intel/Intel-PMT
> 
> The offsets in MMIO space are arranged in groups for each RMID.
> 
> E.g the "energy" counters for guid 0x26696143 are arranged like this:
> 
>         MMIO offset:0x0000 Counter for RMID 0 PMT_EVENT_ENERGY
>         MMIO offset:0x0008 Counter for RMID 0 PMT_EVENT_ACTIVITY
>         MMIO offset:0x0010 Counter for RMID 1 PMT_EVENT_ENERGY
>         MMIO offset:0x0018 Counter for RMID 1 PMT_EVENT_ACTIVITY
>         ...
>         MMIO offset:0x23F0 Counter for RMID 575 PMT_EVENT_ENERGY
>         MMIO offset:0x23F8 Counter for RMID 575 PMT_EVENT_ACTIVITY
> 
> Define these events in the file system code and add the events
> to the event_group structures.
> 
> PMT_EVENT_ENERGY and PMT_EVENT_ACTIVITY are produced in fixed point
> format. File system code must output as floating point values.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl_types.h           | 11 +++++++
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 41 +++++++++++++++++++++++++
>  fs/resctrl/monitor.c                    | 35 ++++++++++++---------
>  3 files changed, 72 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
> index d98351663c2c..6838b02d5ca3 100644
> --- a/include/linux/resctrl_types.h
> +++ b/include/linux/resctrl_types.h
> @@ -47,6 +47,17 @@ enum resctrl_event_id {
>  	QOS_L3_MBM_TOTAL_EVENT_ID	= 0x02,
>  	QOS_L3_MBM_LOCAL_EVENT_ID	= 0x03,
>  
> +	/* Intel Telemetry Events */
> +	PMT_EVENT_ENERGY,
> +	PMT_EVENT_ACTIVITY,
> +	PMT_EVENT_STALLS_LLC_HIT,
> +	PMT_EVENT_C1_RES,
> +	PMT_EVENT_UNHALTED_CORE_CYCLES,
> +	PMT_EVENT_STALLS_LLC_MISS,
> +	PMT_EVENT_AUTO_C6_RES,
> +	PMT_EVENT_UNHALTED_REF_CYCLES,
> +	PMT_EVENT_UOPS_RETIRED,
> +
>  	/* Must be the last */
>  	QOS_NUM_EVENTS,
>  };
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 45cadbb87dc8..565777841f5c 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -18,12 +18,30 @@
>  
>  #include "internal.h"
>  
> +/**
> + * struct pmt_event - Telemetry event.
> + * @id:		Resctrl event id.
> + * @idx:	Counter index within each per-RMID block of counters.
> + * @bin_bits:	Zero for integer valued events, else number bits in fraction
> + *		part of fixed-point.
> + */
> +struct pmt_event {
> +	enum resctrl_event_id	id;
> +	unsigned int		idx;
> +	unsigned int		bin_bits;
> +};
> +
> +#define EVT(_id, _idx, _bits) { .id = _id, .idx = _idx, .bin_bits = _bits }
> +
>  /**
>   * struct event_group - All information about a group of telemetry events.
>   * @pfg:		Points to the aggregated telemetry space information
>   *			within the INTEL_PMT_TELEMETRY driver that contains data for all
>   *			telemetry regions.
>   * @guid:		Unique number per XML description file.
> + * @mmio_size:		Number of bytes of MMIO registers for this group.
> + * @num_events:		Number of events in this group.
> + * @evts:		Array of event descriptors.
>   */
>  struct event_group {
>  	/* Data fields for additional structures to manage this group. */
> @@ -31,14 +49,26 @@ struct event_group {
>  
>  	/* Remaining fields initialized from XML file. */
>  	u32				guid;
> +	size_t				mmio_size;

+ linux/types.h, although it should probably have been added in patch 17 
already.

> +	unsigned int			num_events;
> +	struct pmt_event		evts[] __counted_by(num_events);

#include for __counted_by()?

>  };
>  
> +#define XML_MMIO_SIZE(num_rmids, num_events, num_extra_status) \
> +		      (((num_rmids) * (num_events) + (num_extra_status)) * sizeof(u64))
> +
>  /*
>   * Link: https://github.com/intel/Intel-PMT
>   * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
>   */
>  static struct event_group energy_0x26696143 = {
>  	.guid		= 0x26696143,
> +	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
> +	.num_events	= 2,
> +	.evts		= {
> +		EVT(PMT_EVENT_ENERGY, 0, 18),
> +		EVT(PMT_EVENT_ACTIVITY, 1, 18),
> +	}
>  };
>  
>  /*
> @@ -47,6 +77,17 @@ static struct event_group energy_0x26696143 = {
>   */
>  static struct event_group perf_0x26557651 = {
>  	.guid		= 0x26557651,
> +	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
> +	.num_events	= 7,
> +	.evts		= {
> +		EVT(PMT_EVENT_STALLS_LLC_HIT, 0, 0),
> +		EVT(PMT_EVENT_C1_RES, 1, 0),
> +		EVT(PMT_EVENT_UNHALTED_CORE_CYCLES, 2, 0),
> +		EVT(PMT_EVENT_STALLS_LLC_MISS, 3, 0),
> +		EVT(PMT_EVENT_AUTO_C6_RES, 4, 0),
> +		EVT(PMT_EVENT_UNHALTED_REF_CYCLES, 5, 0),
> +		EVT(PMT_EVENT_UOPS_RETIRED, 6, 0),
> +	}
>  };
>  
>  static struct event_group *known_energy_event_groups[] = {
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 8967ab2e494a..5fad7aa6b0dd 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -878,27 +878,32 @@ static void dom_data_exit(struct rdt_resource *r)
>  	mutex_unlock(&rdtgroup_mutex);
>  }
>  
> +#define MON_EVENT(_eventid, _name, _res, _fp)	\
> +	[_eventid] = {				\
> +	.name			= _name,	\
> +	.evtid			= _eventid,	\
> +	.rid			= _res,		\
> +	.is_floating_point	= _fp,		\
> +}
> +
>  /*
>   * All available events. Architecture code marks the ones that
>   * are supported by a system using resctrl_enable_mon_event()
>   * to set .enabled.
>   */
>  struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
> -	[QOS_L3_OCCUP_EVENT_ID] = {
> -		.name	= "llc_occupancy",
> -		.evtid	= QOS_L3_OCCUP_EVENT_ID,
> -		.rid	= RDT_RESOURCE_L3,
> -	},
> -	[QOS_L3_MBM_TOTAL_EVENT_ID] = {
> -		.name	= "mbm_total_bytes",
> -		.evtid	= QOS_L3_MBM_TOTAL_EVENT_ID,
> -		.rid	= RDT_RESOURCE_L3,
> -	},
> -	[QOS_L3_MBM_LOCAL_EVENT_ID] = {
> -		.name	= "mbm_local_bytes",
> -		.evtid	= QOS_L3_MBM_LOCAL_EVENT_ID,
> -		.rid	= RDT_RESOURCE_L3,
> -	},
> +	MON_EVENT(QOS_L3_OCCUP_EVENT_ID,		"llc_occupancy",	RDT_RESOURCE_L3,	false),
> +	MON_EVENT(QOS_L3_MBM_TOTAL_EVENT_ID,		"mbm_total_bytes",	RDT_RESOURCE_L3,	false),
> +	MON_EVENT(QOS_L3_MBM_LOCAL_EVENT_ID,		"mbm_local_bytes",	RDT_RESOURCE_L3,	false),
> +	MON_EVENT(PMT_EVENT_ENERGY,			"core_energy",		RDT_RESOURCE_PERF_PKG,	true),
> +	MON_EVENT(PMT_EVENT_ACTIVITY,			"activity",		RDT_RESOURCE_PERF_PKG,	true),
> +	MON_EVENT(PMT_EVENT_STALLS_LLC_HIT,		"stalls_llc_hit",	RDT_RESOURCE_PERF_PKG,	false),
> +	MON_EVENT(PMT_EVENT_C1_RES,			"c1_res",		RDT_RESOURCE_PERF_PKG,	false),
> +	MON_EVENT(PMT_EVENT_UNHALTED_CORE_CYCLES,	"unhalted_core_cycles",	RDT_RESOURCE_PERF_PKG,	false),
> +	MON_EVENT(PMT_EVENT_STALLS_LLC_MISS,		"stalls_llc_miss",	RDT_RESOURCE_PERF_PKG,	false),
> +	MON_EVENT(PMT_EVENT_AUTO_C6_RES,		"c6_res",		RDT_RESOURCE_PERF_PKG,	false),
> +	MON_EVENT(PMT_EVENT_UNHALTED_REF_CYCLES,	"unhalted_ref_cycles",	RDT_RESOURCE_PERF_PKG,	false),
> +	MON_EVENT(PMT_EVENT_UOPS_RETIRED,		"uops_retired",		RDT_RESOURCE_PERF_PKG,	false),
>  };
>  
>  void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, unsigned int binary_bits)
> 

-- 
 i.

