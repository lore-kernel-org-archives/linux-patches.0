Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B465218ADD
	for <patches@lists.linux.dev>; Mon, 31 Mar 2025 21:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743458017; cv=none; b=Z9JwQh0hoHlbR525N8dkA5B8E2LcQK+zZ5UAmw9fiBIkWOIU8/H010xY6MMzX4ncMRSd5Fz2tW+aOs6UxDmkcP9XnwfIOzFjIook7SR3FM31BShbIgw6n86ShJ1XkAN+f9DjqrrseuiJWRpCG1J7pR/qlyjKuBFSiG+MSxC4AoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743458017; c=relaxed/simple;
	bh=snXi95JqhGRAgGRsx36YGyhVdrjUExqEqy0ROtKAnq0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=esqXRP05+F2EW4+DpzAxI5qu+oF/9dMnblGQooP9AsBSZ5ipYRqWCD8f5eu+8veL4S1VSnbkD+wMhcvoEVJ3HpSl/Jg+fWSl565q9geo7q7sCNL40HTArfbKBRtFCzWNgv3luHu4WPw4SikxLzZTVDNyqrSg5Ubojzfsli53uMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AAfZ+yXP; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AAfZ+yXP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743458015; x=1774994015;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=snXi95JqhGRAgGRsx36YGyhVdrjUExqEqy0ROtKAnq0=;
  b=AAfZ+yXPOj/DnFUdDz85bsuPtHOS7VcUyoVaiXHIlvCcuo5U7YjyYXhq
   riIiSr+s+ubg+QbFbb1J9dY79W/9NCeRCNfTgiYzJopm95SlajeEkE4S4
   0UbGQc1Vc1HPcOGWynhnab/YPfCyhy/Ura7pQLLSTRNa1a7bL/Xcj2wYY
   fAnVEgHabAbKD9gsrE2TbD0WdOalM+0hJKH/CKXeisnTBM/9139+l3m0M
   SImKdqJG9WlmDHIy00Cp3vKg+hDb0MADc8yYk3HP7IxkEI22p4WpHb29K
   YolbMmLKqBkcDosenfNKH/TwB5jSs+eaBAOpS+FOeeWXeHVm4FlXuofH0
   Q==;
X-CSE-ConnectionGUID: a0Fa06XMQ0yKBfl6oSmspA==
X-CSE-MsgGUID: eHzi2vHZSZycCLxHTODnuw==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="32364057"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="32364057"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 14:53:34 -0700
X-CSE-ConnectionGUID: zgsftM23QmOdtoN6TrKKcQ==
X-CSE-MsgGUID: h2Q69vc2Q9moB6kpclSyMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="125957046"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 14:53:34 -0700
Date: Mon, 31 Mar 2025 14:53:32 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 07/16] x86/resctrl: Add initialization hook for Intel
 PMT events
Message-ID: <Z-sO3G8OdzVwnvo8@agluck-desk3>
References: <20250321231609.57418-1-tony.luck@intel.com>
 <20250321231609.57418-8-tony.luck@intel.com>
 <8e4b51cc-9405-4505-8bd3-07d46f246efa@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e4b51cc-9405-4505-8bd3-07d46f246efa@intel.com>

On Mon, Mar 31, 2025 at 09:20:07AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 3/21/25 4:15 PM, Tony Luck wrote:
> > Call the OOBMSM discovery code to find out if there are any
> > event groups that match unique identifiers understood by resctrl.
> > 
> > Note that initiialzation must happen in two phases because the
> 
> "initiialzation" -> "initialization"

Wil fix.

> > OOBMSM VSEC discovery process is not complete at resctrl
> > "lateinit()" initialization time. So there is an initial hook
> > that assumes that Intel PMT will exist, called early so that
> > package scoped domain groups are initialized.
> > 
> > At first mount the remainder of initialization is done. If there
> > are no Intel PMT events, the package domain lists are removed.
> > 
> > Move definition of struct mon_evt to <linux/resctrl_types.h>
> 
> Why not include/resctrl.h?

I put in in resctrl_types.h because it is a type definition?
I'm not sure of the criteria James used to decide what goes
in resctrl_types.h and what goes in resctrl.h

> > 
> > Events for specific systems to be added by a separate patch.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  include/linux/resctrl.h                 |  14 ++
> >  include/linux/resctrl_types.h           |  14 ++
> >  arch/x86/kernel/cpu/resctrl/internal.h  |   6 +
> >  fs/resctrl/internal.h                   |  14 --
> >  arch/x86/kernel/cpu/resctrl/core.c      |   9 +-
> >  arch/x86/kernel/cpu/resctrl/intel_aet.c | 211 ++++++++++++++++++++++++
> >  fs/resctrl/rdtgroup.c                   |   3 +
> >  arch/x86/kernel/cpu/resctrl/Makefile    |   1 +
> >  8 files changed, 255 insertions(+), 17 deletions(-)
> >  create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c
> > 
> > diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> > index 6c895ec220fe..999e0802a26e 100644
> > --- a/include/linux/resctrl.h
> > +++ b/include/linux/resctrl.h
> > @@ -170,6 +170,14 @@ struct rdt_mon_domain {
> >  	int				cqm_work_cpu;
> >  };
> >  
> > +/**
> > + * struct rdt_core_mon_domain - CPUs sharing an Intel-PMT-scoped resctrl monitor resource
> 
> Please no arch specific references in fs code. I think it will help to explain and consume this
> work if patches are split into fs and arch patches.

Domain add/remove needs more thought on the hooks between FS and ARCH
layers. Splitting the patches into "new infrastructure for FS" and
"new ARCH implememtations" will help me get something cleaner.

> > + * @hdr:		common header for different domain types
> > + */
> > +struct rdt_core_mon_domain {
> > +	struct rdt_domain_hdr	hdr;
> > +};
> > +
> >  /**
> >   * struct resctrl_cache - Cache allocation related data
> >   * @cbm_len:		Length of the cache bit mask
> > @@ -522,4 +530,10 @@ extern unsigned int resctrl_rmid_realloc_limit;
> >  int resctrl_init(void);
> >  void resctrl_exit(void);
> >  
> > +#ifdef CONFIG_INTEL_AET_RESCTRL
> > +void rdt_get_intel_aet_mount(void);
> 
> Please no arch specific helpers in fs code. This could instead be a
> generic "resctrl_arch_*" helper that resctrl fs calls at beginning of
> fs mount for architectures to do what is needed. 

Agreed.

> 
> > +#else
> > +static inline void rdt_get_intel_aet_mount(void) { }
> > +#endif
> > +
> >  #endif /* _RESCTRL_H */
> > diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
> > index 8f967e03af5a..d56fcd082d2c 100644
> > --- a/include/linux/resctrl_types.h
> > +++ b/include/linux/resctrl_types.h
> > @@ -57,4 +57,18 @@ enum resctrl_event_id {
> >  
> >  #define QOS_NUM_EVENTS		(QOS_L3_MBM_LOCAL_EVENT_ID + 1)
> >  
> > +/**
> > + * struct mon_evt - Entry in the event list of a resource
> > + * @evtid:		per resource event id
> > + * @name:		name of the event
> > + * @configurable:	true if the event is configurable
> > + * @list:		entry in &rdt_resource->evt_list
> > + */
> > +struct mon_evt {
> > +	unsigned int		evtid;
> > +	char			*name;
> > +	bool			configurable;
> > +	struct list_head	list;
> > +};
> > +
> >  #endif /* __LINUX_RESCTRL_TYPES_H */
> > diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> > index 521db28efb3f..ada402c7678b 100644
> > --- a/arch/x86/kernel/cpu/resctrl/internal.h
> > +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> > @@ -168,6 +168,12 @@ void rdt_ctrl_update(void *arg);
> >  
> >  int rdt_get_mon_l3_config(struct rdt_resource *r);
> >  
> > +#ifdef CONFIG_INTEL_AET_RESCTRL
> > +int rdt_get_intel_aet_mon_config(void);
> > +#else
> > +static inline int rdt_get_intel_aet_mon_config(void) { return 0; }
> > +#endif
> > +
> >  bool rdt_cpu_has(int flag);
> >  
> >  void __init intel_rdt_mbm_apply_quirk(void);
> > diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> > index 422f36573db7..f5a698b49e97 100644
> > --- a/fs/resctrl/internal.h
> > +++ b/fs/resctrl/internal.h
> > @@ -67,20 +67,6 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
> >  	return container_of(kfc, struct rdt_fs_context, kfc);
> >  }
> >  
> > -/**
> > - * struct mon_evt - Entry in the event list of a resource
> > - * @evtid:		per resource event id
> > - * @name:		name of the event
> > - * @configurable:	true if the event is configurable
> > - * @list:		entry in &rdt_resource->evt_list
> > - */
> > -struct mon_evt {
> > -	unsigned int		evtid;
> > -	char			*name;
> > -	bool			configurable;
> > -	struct list_head	list;
> > -};
> > -
> >  /**
> >   * struct mon_data - Monitoring details for each event file.
> >   * @rid:             Resource id associated with the event file.
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index c8cc3104f56c..1ab0f5eec244 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -882,6 +882,7 @@ static __init bool get_rdt_alloc_resources(void)
> >  static __init bool get_rdt_mon_resources(void)
> >  {
> >  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> > +	int ret1 = -EINVAL, ret2;
> >  
> >  	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC))
> >  		rdt_mon_features |= (1 << QOS_L3_OCCUP_EVENT_ID);
> > @@ -890,10 +891,12 @@ static __init bool get_rdt_mon_resources(void)
> >  	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL))
> >  		rdt_mon_features |= (1 << QOS_L3_MBM_LOCAL_EVENT_ID);
> >  
> > -	if (!rdt_mon_features)
> > -		return false;
> > +	if (rdt_mon_features)
> > +		ret1 = rdt_get_mon_l3_config(r);
> > +
> > +	ret2 = rdt_get_intel_aet_mon_config();
> >  
> > -	return !rdt_get_mon_l3_config(r);
> > +	return ret1 == 0 || ret2;
> >  }
> >  
> >  static __init void __check_quirks_intel(void)
> > diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > new file mode 100644
> > index 000000000000..9a8ccb62b4ab
> > --- /dev/null
> > +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > @@ -0,0 +1,211 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Resource Director Technology(RDT)
> > + * - Intel Application Energy Telemetry
> > + *
> > + * Copyright (C) 2025 Intel Corporation
> > + *
> > + * Author:
> > + *    Tony Luck <tony.luck@intel.com>
> > + */
> > +
> > +#define pr_fmt(fmt)   "resctrl: " fmt
> > +
> > +#include <linux/cpu.h>
> > +#include <linux/cleanup.h>
> > +#include <linux/slab.h>
> > +#include "fake_intel_aet_features.h"
> > +#include <linux/intel_vsec.h>
> > +#include <asm/resctrl.h>
> > +
> > +#include "internal.h"
> > +
> > +static struct pmt_feature_group *feat_energy;
> > +static struct pmt_feature_group *feat_perf;
> > +
> > +/* All telemetry events from Intel CPUs */
> > +enum pmt_event_id {
> > +	PMT_EVENT_ENERGY,
> > +	PMT_EVENT_ACTIVITY,
> > +	PMT_EVENT_STALLS_LLC_HIT,
> > +	PMT_EVENT_C1_RES,
> > +	PMT_EVENT_UNHALTED_CORE_CYCLES,
> > +	PMT_EVENT_STALLS_LLC_MISS,
> > +	PMT_EVENT_AUTO_C6_RES,
> > +	PMT_EVENT_UNHALTED_REF_CYCLES,
> > +	PMT_EVENT_UOPS_RETIRED,
> > +
> > +	PMT_NUM_EVENTS
> > +};
> 
> I expect the above to become part of resctrl fs. Actually, I think
> all properties of the new events, the id, name and how to display it,
> should be part of resctrl fs.

I'm not convinced about the amount of re-use that there will be
for these events. I took a quick look at the current plan for a
processor that follows Clearwater Forest and I see 22 events, only
3 of them match events in the above list.

> We do not want other architectures to create their own display names for
> the same events. I expect that this will require more plumbing between
> arch and fs code to communicate which events are supported, similar to
> what exists for the L3 events (for example, resctrl_arch_is_mbm_total_enabled()).

Supported monitor events are indicated by setting bits in "rdt_mon_features"
currently "unsigned int" but could become "long" or a longer bitmap if
we really want the FS layer to keep track of every possible event for
every architecture.
> 
> This may result in struct rdt_core_mon_domain to no longer be empty but instead
> for resctrl to use it to manage state of which events are enabled or not. Theoretically
> all could be managed by the architecture but I think that could result in inconsistent
> error codes to user space.

rdt_core_mon_domain seems like the wrong level (unless we expect to have
different enabled events in different domains). rdt_resource seems
plausible ... or just expand "rdt_mon_features".

> > +
> > +/**
> > + * enum evt_type - Type for values for each event.
> > + * @EVT_U64:	Integer up to 64 bits
> > + * @EVT_U46_18:	Fixed point binary, 46 bits for integer, 18 binary place bits
> > + */
> > +enum evt_type {
> > +	EVT_U64,
> > +	EVT_U46_18,
> > +};
> > +
> > +#define EVT(id, evtname, offset, t)		\
> > +	{					\
> > +		.evt = {			\
> > +			.evtid = id,		\
> > +			.name = evtname		\
> > +		},				\
> > +		.evt_offset = offset,		\
> > +		.evt_type = t			\
> > +	}
> > +
> > +/**
> > + * struct pmt_event - Telemetry event.
> > + * @evt:	Resctrl event
> > + * @evt_offset:	MMIO offset of counter
> > + * @evt_type:	Type
> > + */
> > +struct pmt_event {
> > +	struct mon_evt	evt;
> > +	int		evt_offset;
> > +	enum evt_type	evt_type;
> > +};
> > +
> > +/**
> > + * struct telem_entry - Summarized form from XML telemetry description
> 
> It is not clear to me how useful it is to document that this is
> "Summarized form from XML telemetry description". Either more detail should
> be added to help reader understand what XML is being talked about or
> the description should be a summary of what this data structure represents.

More detail here is the right direction.

> > + * @name:			Name for this group of events
> > + * @guid:			Unique ID for this group
> > + * @num_rmids:			Number of RMIDS supported
> > + * @stride:			Number of bytes of counters for each RMID
> > + * @overflow_counter_off:	Offset od overflow count
> 
> od -> of
> 
> > + * @last_overflow_tstamp_off:	Offset of overflow timestamp
> > + * @last_update_tstamp_off:	Offset of last update timestamp
> > + * @active:			Marks this group as active on current CPU
> 
> Could you please elaborate what "on current CPU" implies with the events
> being "per package"?

I should have said "on current system" rather than using the overworked
"CPU" word.

> > + * @evts:			Telemetry events in this group
> 
> Since this is an array, could this comment also describe how the number of
> entries are determined?

Will add comment that it is terminated with a null entry.

> 
> > + */
> > +struct telem_entry {
> > +	char	*name;
> > +	int	guid;
> > +	int	num_rmids;
> > +	int	stride;
> > +	int	overflow_counter_off;
> > +	int	last_overflow_tstamp_off;
> > +	int	last_update_tstamp_off;
> > +	bool	active;
> > +	struct pmt_event evts[];
> > +};
> > +
> > +/* All known telemetry event groups */
> > +static struct telem_entry *telem_entry[] = {
> > +	NULL
> > +};
> > +
> > +/* Per-package event groups active on this machine */
> > +static struct pkg_info {
> > +	int			count;
> > +	struct telemetry_region	*regions;
> > +} *pkg_info;
> > +
> > +/*
> > + * Scan a feature group looking for guids recognized by this code
> 
> "this code" can be dropped

Agreed.

> > + * and update the per-package counts of known groups.
> > + */
> > +static bool count_events(struct pkg_info *pkg, int max_pkgs, struct pmt_feature_group *p)
> > +{
> > +	struct telem_entry **tentry;
> > +	bool found = false;
> > +
> > +	for (int i = 0; i < p->count; i++) {
> > +		struct telemetry_region *tr = &p->regions[i];
> > +
> > +		for (tentry = telem_entry; *tentry; tentry++) {
> > +			if (tr->guid == (*tentry)->guid) {
> > +				if (tr->plat_info.package_id > max_pkgs) {
> > +					pr_warn_once("Bad package %d\n", tr->plat_info.package_id);
> > +					continue;
> > +				}
> > +				found = true;
> > +				(*tentry)->active = true;
> > +				pkg[tr->plat_info.package_id].count++;
> 
> There seems to be some duplicate information between the structures. For example,
> telem_entry::num_rmids and the num_rmids from the pmt_feature_group. Are these
> expected to be identical? Since the num_rmids from telem_entry are hardcoded and
> the ones from pmt_feature_group discovered then this sounds like opportunity to
> add some sanity checking.
> Similarly, could there be a check here to ensure that the size of the memory region
> provided matches the expected size based on all the hardcoded properties?

I should also sanity check against CPUID(0xF,0x0).EBX

> 
> > +				break;
> > +			}
> > +		}
> > +	}
> > +
> > +	return found;
> > +}
> > +
> > +DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,	\
> > +	if (!IS_ERR_OR_NULL(_T))					\
> > +		intel_pmt_put_feature_group(_T))
> > +
> > +/*
> > + * Ask OOBMSM discovery driver for all the RMID based telemetry groups
> > + * that it supports.
> > + */
> > +static bool get_events(void)
> > +{
> > +	struct pmt_feature_group *p1 __free(intel_pmt_put_feature_group) = NULL;
> > +	struct pmt_feature_group *p2 __free(intel_pmt_put_feature_group) = NULL;
> > +	int num_pkgs = topology_max_packages();
> > +	struct pkg_info *pkg __free(kfree) = NULL;
> > +
> > +	pkg = kmalloc_array(num_pkgs, sizeof(*pkg_info), GFP_KERNEL | __GFP_ZERO);
> 
> kcalloc() ?

Yes.

> > +	if (!pkg)
> > +		return false;
> > +
> > +	p1 = intel_pmt_get_regions_by_feature(FEATURE_PER_RMID_ENERGY_TELEM);
> > +	p2 = intel_pmt_get_regions_by_feature(FEATURE_PER_RMID_PERF_TELEM);
> > +
> > +	if (IS_ERR_VALUE(p1) && IS_ERR_VALUE(p1))
> > +		return false;
> > +
> > +	if (!IS_ERR_VALUE(p1))
> > +		if (!count_events(pkg, num_pkgs, p1))
> > +			intel_pmt_put_feature_group(no_free_ptr(p1));
> 
> This seems to defeat the purpose of the cleanup handler.

Maybe this isn't needed. I'll have to dig through the various cases
of return values, and whether the .guid matches a known value.

> > +	if (!IS_ERR_VALUE(p2))
> > +		if (!count_events(pkg, num_pkgs, p2))
> > +			intel_pmt_put_feature_group(no_free_ptr(p2));
> > +
> > +	if (!IS_ERR_OR_NULL(p1))
> > +		feat_energy = no_free_ptr(p1);
> > +	if (!IS_ERR_OR_NULL(p2))
> > +		feat_perf = no_free_ptr(p2);
> > +	pkg_info = no_free_ptr(pkg);
> > +
> > +	return true;
> > +}
> > +
> > +/*
> > + * Early initialization. Cannot do much here because OOBMSM has not
> > + * completed enumeration of telemetry event groups.
> > + */
> > +int rdt_get_intel_aet_mon_config(void)
> > +{
> > +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_INTEL_AET].r_resctrl;
> > +
> > +	INIT_LIST_HEAD(&r->evt_list);
> > +
> > +	return 1;
> > +}
> > +
> > +/*
> > + * Late (first mount) initialization. Safe to ask OOBMSM which telemetry
> > + * event groups are supported.
> > + */
> > +void rdt_get_intel_aet_mount(void)
> > +{
> > +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_INTEL_AET].r_resctrl;
> > +	struct rdt_core_mon_domain *d, *tmp;
> > +	static int do_one_time;
> > +
> > +	if (do_one_time)
> > +		return;
> > +
> > +	do_one_time = 1;
> > +
> > +	if (!get_events()) {
> > +		list_for_each_entry_safe(d, tmp, &r->mon_domains, hdr.list)
> > +			kfree(d);
> > +		r->mon_capable = false;
> > +	}
> > +}
> > diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> > index a90291f57330..4833dfa08ce3 100644
> > --- a/fs/resctrl/rdtgroup.c
> > +++ b/fs/resctrl/rdtgroup.c
> > @@ -2572,6 +2572,9 @@ static int rdt_get_tree(struct fs_context *fc)
> >  
> >  	cpus_read_lock();
> >  	mutex_lock(&rdtgroup_mutex);
> > +
> > +	rdt_get_intel_aet_mount();
> > +
> >  	/*
> >  	 * resctrl file system can only be mounted once.
> >  	 */
> > diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
> > index 2c3b09f95127..a47e1c214087 100644
> > --- a/arch/x86/kernel/cpu/resctrl/Makefile
> > +++ b/arch/x86/kernel/cpu/resctrl/Makefile
> > @@ -2,6 +2,7 @@
> >  obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
> >  obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
> >  obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
> > +obj-$(CONFIG_INTEL_AET_RESCTRL)		+= intel_aet.o
> >  obj-$(CONFIG_INTEL_AET_RESCTRL)		+= fake_intel_aet_features.o
> >  
> >  # To allow define_trace.h's recursive include:
> 
> Reinette

-Tony
