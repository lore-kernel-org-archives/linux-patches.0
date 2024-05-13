Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA50208B0
	for <patches@lists.linux.dev>; Mon, 13 May 2024 17:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715619947; cv=none; b=sulFygLcV7Na90KWMZ84iRmhJnp8HhFRFfngi3mU2n3Fr2gj/OUXmM7GyonQ4LCzevlkAH1JZzCyN12lln3wraIa18nrBxe0gne2wvX8JGTJrWD0aigYd8ZC4e9jq4HmNEqiDQ28HcZIaGHqBO6D0K0XXX9aRssJPNz7fXn97fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715619947; c=relaxed/simple;
	bh=ssxfdLwxdPYLvNezYR2EIwOVjF9NqcN8AHFw6+V9vaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i+GMiYC6OG8q3khWxWSbNzcV8RBUoqHJ3LmkK5gMwMQS9WSlm8TJyBB37+z+G2DsZl6xLXDhyrprOnVxxoMWsheID4Od/LRKATdez9wL/TR+liMLSpH5nizucY5U/eJNkO+eCB3saqFeNIY32xF4Zp9WkYgb44EIEd8r2DmX/Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i0m1+642; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i0m1+642"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715619944; x=1747155944;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ssxfdLwxdPYLvNezYR2EIwOVjF9NqcN8AHFw6+V9vaY=;
  b=i0m1+642KgfmZhDtn/FKYzz1YPOXUrhwUiRNny/cLfP89V5cUeSgeikv
   uNpo631mxRsDGYj1dnNheE/pDw/xWzvwzGAAMoJXOOOkV7OgMFYE9Sdau
   a13/iuIYAb5bbRQ6+brLDLFXuJxZjrrcpggXeyweZ0R6x67qqMTcZ+p79
   /9f5DYLsXonWDIH6pDO2u+8jLZcgVoY9uOG56y67z7odZX6h3Pfbl6QeR
   b+eHpET7nylItcKCS8Y8br5khBIYUJvSL9gByHKwjHs3Xg4O5gOwIgxYb
   KKlDDMBOEiSxSSV+iQVqGnY35HY6sx89YbPcCK6Fs6EzxVJKOHWaLSSAx
   A==;
X-CSE-ConnectionGUID: 8xeCc6CvRuWtsjDegKGRew==
X-CSE-MsgGUID: ALkM+0EMSe2rQghbRHQF4A==
X-IronPort-AV: E=McAfee;i="6600,9927,11072"; a="11727262"
X-IronPort-AV: E=Sophos;i="6.08,158,1712646000"; 
   d="scan'208";a="11727262"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 10:05:43 -0700
X-CSE-ConnectionGUID: sWVMMjJYSpCXVSASIM9yBw==
X-CSE-MsgGUID: RofmYK5HTrOo8dIJlrdghQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,158,1712646000"; 
   d="scan'208";a="30969456"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.105])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 10:05:43 -0700
Date: Mon, 13 May 2024 10:05:41 -0700
From: Tony Luck <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v17 7/9] x86/resctrl: Add new monitor files for Sub-NUMA
 cluster (SNC) monitoring
Message-ID: <ZkJIZdU2knEUJN7Q@agluck-desk3>
References: <20240503203325.21512-1-tony.luck@intel.com>
 <20240503203325.21512-8-tony.luck@intel.com>
 <0178e84e-d55f-47bf-b8b0-58e05fcaa108@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0178e84e-d55f-47bf-b8b0-58e05fcaa108@intel.com>

On Fri, May 10, 2024 at 02:24:13PM -0700, Reinette Chatre wrote:
> Hi Tony,

Hi Reinette,

Thanks for the review. Detailed comments below. But overall I'm
going to split patch 7 into a bunch of smaller changes, each with
a better commit message.

> On 5/3/2024 1:33 PM, Tony Luck wrote:
> 
> (Could you please start the changelog with some context?)
> 
> > Add a field to the rdt_resource structure to track whether monitoring
> > resources are tracked by hardware at a different scope (NODE) from
> > the legacy L3 scope.
> 
> This seems to describe @mon_scope that was introduced in patch #3?

Not really. Patch #3 made the change so that control an monitor
functions can have different scope. That's still needed as with SNC
enabled the underlying data collection is at the node level for
monitoring, while control stays at the L3 cache scope.

This new field describes the legacy scope of monitoring, so that
resctrl can provide correctly scoped monitor files for legacy
applications that aren't aware of SNC. So I'm using this both
to indicate when SNC is enabled (with mon_scope != mon_display_scope)
or disabled (when they are the same).

> > 
> > Add a field to the rdt_mon_domain structure to track the L3 cache id
> > which can be used to find all the domains that need resource counts
> > summed to provide accurate values in the legacy monitoring files.
> 
> Why is this field necessary? Can this not be obtained dynamically?

I could compute it each time I need it (when making/removing
directories, or finding which SNC domains share an L3 domain).

	id = get_domain_id_from_scope(cpumask_any(&d->cpu_mask), r->mon_display_scope);
	if (id < 0)
		// error path

But it seemed better to just discover this once at domain creation time.

> 
> > 
> > When SNC is enabled create extra directories and files in each mon_data
> > directory to report per-SNC node counts.
> 
> The above cryptic sentence is the closest the changelog gets to explaining
> what this patch aims to do. Could you please enhance the changelog to
> describe what this patch aims to do and more importantly how it goes about
> doing so? This patch contains a significant number of undocumented quirks 
> and between the cryptic changelog and undocumented quirks in the patch I find
> it very hard to understand what it is trying to do and why.
> 
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  include/linux/resctrl.h                   |   4 +
> >  arch/x86/kernel/cpu/resctrl/internal.h    |   5 +-
> >  arch/x86/kernel/cpu/resctrl/core.c        |   2 +
> >  arch/x86/kernel/cpu/resctrl/ctrlmondata.c |   1 +
> >  arch/x86/kernel/cpu/resctrl/monitor.c     |  52 +++++++---
> >  arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 115 +++++++++++++++++-----
> >  6 files changed, 137 insertions(+), 42 deletions(-)
> > 
> > diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> > index 5c7775343c3e..2f8ac925bc18 100644
> > --- a/include/linux/resctrl.h
> > +++ b/include/linux/resctrl.h
> > @@ -96,6 +96,7 @@ struct rdt_ctrl_domain {
> >  /**
> >   * struct rdt_mon_domain - group of CPUs sharing a resctrl monitor resource
> >   * @hdr:		common header for different domain types
> > + * @display_id:		shared id used to identify domains to be summed for display
> >   * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
> >   * @mbm_total:		saved state for MBM total bandwidth
> >   * @mbm_local:		saved state for MBM local bandwidth
> > @@ -106,6 +107,7 @@ struct rdt_ctrl_domain {
> >   */
> >  struct rdt_mon_domain {
> >  	struct rdt_domain_hdr		hdr;
> > +	int				display_id;
> 
> (it is not clear to me why this is needed)

Described above. I will include that when I split this into its own
patch.

> >  	unsigned long			*rmid_busy_llc;
> >  	struct mbm_state		*mbm_total;
> >  	struct mbm_state		*mbm_local;
> > @@ -187,6 +189,7 @@ enum resctrl_scope {
> >   * @num_rmid:		Number of RMIDs available
> >   * @ctrl_scope:		Scope of this resource for control functions
> >   * @mon_scope:		Scope of this resource for monitor functions
> > + * @mon_display_scope:	Scope for user reporting monitor functions
> >   * @cache:		Cache allocation related data
> >   * @membw:		If the component has bandwidth controls, their properties.
> >   * @ctrl_domains:	RCU list of all control domains for this resource
> > @@ -207,6 +210,7 @@ struct rdt_resource {
> >  	int			num_rmid;
> >  	enum resctrl_scope	ctrl_scope;
> >  	enum resctrl_scope	mon_scope;
> > +	enum resctrl_scope	mon_display_scope;
> >  	struct resctrl_cache	cache;
> >  	struct resctrl_membw	membw;
> >  	struct list_head	ctrl_domains;
> > diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> > index 49440f194253..d41b388bb499 100644
> > --- a/arch/x86/kernel/cpu/resctrl/internal.h
> > +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> > @@ -132,6 +132,7 @@ struct mon_evt {
> >   *                     as kernfs private data
> >   * @rid:               Resource id associated with the event file
> >   * @evtid:             Event id associated with the event file
> > + * @sum:               Sum across domains with same display_id
> >   * @domid:             The domain to which the event file belongs
> >   * @u:                 Name of the bit fields struct
> >   */
> > @@ -139,7 +140,8 @@ union mon_data_bits {
> >  	void *priv;
> >  	struct {
> >  		unsigned int rid		: 10;
> > -		enum resctrl_event_id evtid	: 8;
> > +		enum resctrl_event_id evtid	: 7;
> > +		unsigned int sum		: 1;
> >  		unsigned int domid		: 14;
> >  	} u;
> 
> (No explanation about why evtid had to shrink and why it is ok
> to do so.)

Will split this into its own patch and provide description of need
and safety.

> >  };
> > @@ -150,6 +152,7 @@ struct rmid_read {
> >  	struct rdt_mon_domain	*d;
> >  	enum resctrl_event_id	evtid;
> >  	bool			first;
> > +	bool			sumdomains;
> >  	int			err;
> >  	u64			val;
> >  	void			*arch_mon_ctx;
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index cb181796f73b..a949e69308cd 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -71,6 +71,7 @@ struct rdt_hw_resource rdt_resources_all[] = {
> >  			.name			= "L3",
> >  			.ctrl_scope		= RESCTRL_L3_CACHE,
> >  			.mon_scope		= RESCTRL_L3_CACHE,
> > +			.mon_display_scope	= RESCTRL_L3_CACHE,
> >  			.ctrl_domains		= ctrl_domain_init(RDT_RESOURCE_L3),
> >  			.mon_domains		= mon_domain_init(RDT_RESOURCE_L3),
> >  			.parse_ctrlval		= parse_cbm,
> > @@ -613,6 +614,7 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
> >  
> >  	d = &hw_dom->d_resctrl;
> >  	d->hdr.id = id;
> > +	d->display_id = get_domain_id_from_scope(cpu, r->mon_display_scope);
> >  	d->hdr.type = RESCTRL_MON_DOMAIN;
> >  	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
> >  
> > diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> > index 3b9383612c35..a4ead8ffbaf3 100644
> > --- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> > +++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> > @@ -575,6 +575,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
> >  	resid = md.u.rid;
> >  	domid = md.u.domid;
> >  	evtid = md.u.evtid;
> > +	rr.sumdomains = md.u.sum;
> >  
> >  	r = &rdt_resources_all[resid].r_resctrl;
> >  	hdr = rdt_find_domain(&r->mon_domains, domid, NULL);
> > diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> > index d0bbeb410750..2e795b261b6f 100644
> > --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> > +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> > @@ -16,6 +16,7 @@
> >   */
> >  
> >  #include <linux/cpu.h>
> > +#include <linux/cacheinfo.h>
> 
> Can this be alphabetical?

Sure. Will fix.

> >  #include <linux/module.h>
> >  #include <linux/sizes.h>
> >  #include <linux/slab.h>
> > @@ -187,18 +188,8 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
> >  
> >  static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
> >  {
> > -	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> > -	int cpu = smp_processor_id();
> > -	int rmid_offset = 0;
> >  	u64 msr_val;
> >  
> > -	/*
> > -	 * When SNC mode is on, need to compute the offset to read the
> > -	 * physical RMID counter for the node to which this CPU belongs.
> > -	 */
> > -	if (snc_nodes_per_l3_cache > 1)
> > -		rmid_offset = (cpu_to_node(cpu) % snc_nodes_per_l3_cache) * r->num_rmid;
> > -
> 
> This removes code that was just added in previous patch. Can the end goal
> be reached without this churn? I expect doing so will make this patch easier to
> follow.

Oops, yes. I will delete this from patch 6 to avoid churn.

> >  	/*
> >  	 * As per the SDM, when IA32_QM_EVTSEL.EvtID (bits 7:0) is configured
> >  	 * with a valid event code for supported resource type and the bits
> > @@ -207,7 +198,7 @@ static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
> >  	 * IA32_QM_CTR.Error (bit 63) and IA32_QM_CTR.Unavailable (bit 62)
> >  	 * are error bits.
> >  	 */
> > -	wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid + rmid_offset);
> > +	wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid);
> >  	rdmsrl(MSR_IA32_QM_CTR, msr_val);
> >  
> >  	if (msr_val & RMID_VAL_ERROR)
> > @@ -291,7 +282,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
> >  
> >  	resctrl_arch_rmid_read_context_check();
> >  
> > -	if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
> > +	if (d->display_id != get_cpu_cacheinfo_id(smp_processor_id(), r->mon_display_scope))
> >  		return -EINVAL;
> 
> Does this mean that when SNC is enabled then reading data for an event within a particular
> monitor domain ("node scope") can read its data from any CPU within the L3 domain
> ("mon_display_scope") even if that CPU is not associated with the node for which it
> is reading the data?

Yes.

> If so this really turns many resctrl assumptions and architecture on its head since the
> resctrl expectation is that only CPUs within a domain's cpumask can be used to interact
> with the domain. This in turn makes this seemingly general feature actually SNC specific.

This is only an expectation for x86 features using IA32_QM_EVTSEL/IA32_QM_CTR
MSR method to read counters. ARM doesn't have the "CPU must be in
domain" restriction (as far as I can tell). Nor does the Intel IO RDT
(which uses MMIO space for control registers, these can be read/written
from any CPU).

We do know that those two MSRs can be read from any CPU that shares an
L3 cache. It would seem to be pointless overhead to force a cross
processor interrupt to read them from a different CPU just to satisfy
a "must be in same domain" non-requirement. I'l split this into its
own patch with suitable description.

> >  	ret = __rmid_read(rmid, eventid, &msr_val);
> > @@ -556,7 +547,7 @@ static struct mbm_state *get_mbm_state(struct rdt_mon_domain *d, u32 closid,
> >  	}
> >  }
> >  
> > -static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
> > +static int ___mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr, u64 *rrval)
> >  {
> >  	struct mbm_state *m;
> >  	u64 tval = 0;
> > @@ -574,11 +565,44 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
> >  	if (rr->err)
> >  		return rr->err;
> >  
> > -	rr->val += tval;
> > +	*rrval += tval;
> >  
> 
> Why is rrval needed?

I don't think it is anymore. I think I wanted it while I was developing
this set of changes. But I will drop it.

> >  	return 0;
> >  }
> >  
> > +static u32 get_node_rmid(struct rdt_resource *r, struct rdt_mon_domain *d, u32 rmid)
> > +{
> > +	int cpu = cpumask_any(&d->hdr.cpu_mask);
> > +
> > +	return rmid + (cpu_to_node(cpu) % snc_nodes_per_l3_cache) * r->num_rmid;
> > +}
> > +
> > +static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
> > +{
> > +	struct rdt_mon_domain *d;
> > +	struct rmid_read tmp;
> > +	u32 node_rmid;
> > +	int ret = 0;
> > +
> > +	if (!rr->sumdomains) {
> > +		node_rmid = get_node_rmid(rr->r, rr->d, rmid);
> > +		return ___mon_event_count(closid, node_rmid, rr, &rr->val);
> > +	}
> > +
> > +	tmp = *rr;
> > +	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
> > +		if (d->display_id == rr->d->display_id) {
> > +			tmp.d = d;
> > +			node_rmid = get_node_rmid(rr->r, d, rmid);
> > +			ret = ___mon_event_count(closid, node_rmid, &tmp, &rr->val);
> 
> If I understand correctly this function is run per IPI on a CPU associated
> with one of the monitor domains (depends on which one came online first),
> and then it will read the monitor data of the other domains from the same
> CPU? This is unexpected since the expectation is that monitor data
> needs to be read from a CPU associated with the domain it is
> reading data for.

See earlier note. The counter can be read from any CPU sharing the same
L3. Adding unnecessary IPI is pointless overhead. But I will add
comments.

> Also, providing tmp as well as rr->val seems unnecessary?

I think I was unsure about modifying the domain field in the struct
rmid_read in the middle of the call chain. But the original caller
mon_event_read() doesn't look at rr->domain after the smp_call*()
function returns. I will drop "tmp".

> > +			if (ret)
> > +				break;
> > +		}
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> >  /*
> >   * mbm_bw_count() - Update bw count from values previously read by
> >   *		    __mon_event_count().
> > diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> > index 0923492a8bd0..a56ae08ca255 100644
> > --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> > +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> > @@ -3011,57 +3011,118 @@ static int mon_addfile(struct kernfs_node *parent_kn, const char *name,
> >   * and monitor groups with given domain id.
> >   */
> >  static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> > -					   unsigned int dom_id)
> > +					   struct rdt_mon_domain *d)
> >  {
> >  	struct rdtgroup *prgrp, *crgrp;
> > +	struct rdt_mon_domain *dom;
> > +	bool remove_all = true;
> > +	struct kernfs_node *kn;
> > +	char subname[32];
> >  	char name[32];
> >  
> > +	sprintf(name, "mon_%s_%02d", r->name, d->display_id);
> > +	if (r->mon_scope != r->mon_display_scope) {
> > +		int count = 0;
> > +
> > +		list_for_each_entry(dom, &r->mon_domains, hdr.list)
> > +			if (d->display_id == dom->display_id)
> > +				count++;
> > +		if (count > 1) {
> > +			remove_all = false;
> > +			sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
> > +		}
> > +	}
> 
> 
> This seems awkward. I wonder if it may not be simpler to just
> remove the directory and on completion check if the parent has
> any subdirectories left and remove the parent if there are no
> subdirectories remaining. Something possible via reading the inode's
> i_nlink that is accessible via kernfs_get_inode(). What do you think?

kernfs_get_inode() needs a pointer to the "struct super_block" for the
filesystem. Resctrl filesystem code doesn't seem to keep track of that
anywhere. Only mentioned in rdt_kill_sb() where core kernfs code passes
it in as the argument. When registering/mounting the resctrl filesystem
there's a "struct fs_context *fc" ... is there a function to get the
super block from that? Even if there is, I'd need to add a global to
save a copy of the fc_context.

> > +
> >  	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
> > -		sprintf(name, "mon_%s_%02d", r->name, dom_id);
> > -		kernfs_remove_by_name(prgrp->mon.mon_data_kn, name);
> > +		if (remove_all) {
> > +			kernfs_remove_by_name(prgrp->mon.mon_data_kn, name);
> > +		} else {
> > +			kn = kernfs_find_and_get_ns(prgrp->mon.mon_data_kn, name, NULL);
> > +			if (kn)
> > +				kernfs_remove_by_name(kn, subname);
> > +		}
> >  
> > -		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list)
> > -			kernfs_remove_by_name(crgrp->mon.mon_data_kn, name);
> > +		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list) {
> > +			if (remove_all) {
> > +				kernfs_remove_by_name(crgrp->mon.mon_data_kn, name);
> > +			} else {
> > +				kn = kernfs_find_and_get_ns(prgrp->mon.mon_data_kn, name, NULL);
> > +				if (kn)
> > +					kernfs_remove_by_name(kn, subname);
> > +			}
> > +		}
> >  	}
> >  }
> >  
> > -static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> > -				struct rdt_mon_domain *d,
> > -				struct rdt_resource *r, struct rdtgroup *prgrp)
> > +static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
> > +			     struct rdt_resource *r, struct rdtgroup *prgrp,
> > +			     bool do_sum)
> >  {
> >  	union mon_data_bits priv;
> > -	struct kernfs_node *kn;
> >  	struct mon_evt *mevt;
> >  	struct rmid_read rr;
> > -	char name[32];
> >  	int ret;
> >  
> > -	sprintf(name, "mon_%s_%02d", r->name, d->hdr.id);
> > -	/* create the directory */
> > -	kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
> > -	if (IS_ERR(kn))
> > -		return PTR_ERR(kn);
> > -
> > -	ret = rdtgroup_kn_set_ugid(kn);
> > -	if (ret)
> > -		goto out_destroy;
> > -
> > -	if (WARN_ON(list_empty(&r->evt_list))) {
> > -		ret = -EPERM;
> > -		goto out_destroy;
> > -	}
> > +	if (WARN_ON(list_empty(&r->evt_list)))
> > +		return -EPERM;
> >  
> >  	priv.u.rid = r->rid;
> >  	priv.u.domid = d->hdr.id;
> > +	priv.u.sum = do_sum;
> >  	list_for_each_entry(mevt, &r->evt_list, list) {
> >  		priv.u.evtid = mevt->evtid;
> >  		ret = mon_addfile(kn, mevt->name, priv.priv);
> >  		if (ret)
> > -			goto out_destroy;
> > +			return ret;
> >  
> >  		if (is_mbm_event(mevt->evtid))
> >  			mon_event_read(&rr, r, d, prgrp, mevt->evtid, true);
> 
> I do not think that the "do_sum" file should be doing any initialization, this
> will be repeated for the "real" mon domain, no?

Good point. I'll drop from the "sum" files and just run it for the
"real" ones.

> >  	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> > +				struct rdt_mon_domain *d,
> > +				struct rdt_resource *r, struct rdtgroup *prgrp)
> > +{
> > +	struct kernfs_node *kn, *ckn;
> > +	char name[32];
> > +	bool do_sum;
> > +	int ret;
> > +
> > +	do_sum = r->mon_scope != r->mon_display_scope;
> > +	sprintf(name, "mon_%s_%02d", r->name, d->display_id);
> > +	kn = kernfs_find_and_get_ns(parent_kn, name, NULL);
> > +	if (!kn) {
> > +		/* create the directory */
> > +		kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
> > +		if (IS_ERR(kn))
> > +			return PTR_ERR(kn);
> > +
> > +		ret = rdtgroup_kn_set_ugid(kn);
> > +		if (ret)
> > +			goto out_destroy;
> > +		ret = mon_add_all_files(kn, d, r, prgrp, do_sum);
> 
> This does not look right. If I understand correctly the private data
> of these event files will have whichever mon domain came up first as
> its domain id. That seems completely arbitrary and does not reflect
> accurate state for this file. Since "do_sum" is essentially a "flag"
> on how this file can be treated, can its "dom_id" not rather be
> the "monitor scope domain id"? Could that not help to eliminate 
> that per-domain "display_id"?

You are correct that this should be the "monitor scope domain id" rather
than the first SNC domain that appears. I'll change to use that. I don't
think it helps in removing the per-domain display_id.

> > +		if (ret)
> > +			goto out_destroy;
> > +	}
> > +
> > +	if (do_sum) {
> > +		sprintf(name, "mon_sub_%s_%02d", r->name, d->hdr.id);
> > +		ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);
> > +		if (IS_ERR(ckn))
> > +			goto out_destroy;
> > +
> > +		ret = rdtgroup_kn_set_ugid(ckn);
> > +		if (ret)
> > +			goto out_destroy;
> > +
> > +		ret = mon_add_all_files(ckn, d, r, prgrp, false);
> > +		if (ret)
> > +			goto out_destroy;
> > +	}
> > +
> >  	kernfs_activate(kn);
> >  	return 0;
> >  
> > @@ -3077,8 +3138,8 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> >  static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> >  					   struct rdt_mon_domain *d)
> >  {
> > -	struct kernfs_node *parent_kn;
> >  	struct rdtgroup *prgrp, *crgrp;
> > +	struct kernfs_node *parent_kn;
> >  	struct list_head *head;
> >  
> >  	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
> > @@ -3950,7 +4011,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
> >  	 * per domain monitor data directories.
> >  	 */
> >  	if (resctrl_mounted && resctrl_arch_mon_capable())
> > -		rmdir_mondata_subdir_allrdtgrp(r, d->hdr.id);
> > +		rmdir_mondata_subdir_allrdtgrp(r, d);
> >  
> >  	if (is_mbm_enabled())
> >  		cancel_delayed_work(&d->mbm_over);
> 
> Reinette

-Tony
