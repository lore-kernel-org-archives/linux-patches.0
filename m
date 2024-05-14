Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6529191
	for <patches@lists.linux.dev>; Tue, 14 May 2024 00:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715646121; cv=none; b=uQhOoWFXwWSLnb5atmJib6qdzcN6gnxPrYUuDaUFz97TpzmTrhe0t6WcNrkNma6Req+tM2d5YVw+srtMjirxKoq4wEeP8zsN+9v/asEpWgESLn5EwbSu08UwcnZ64/JgxdBOP6XDtkyoojFI147/Qd+U6JAWF6+ecz+PXF19J3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715646121; c=relaxed/simple;
	bh=yiGka99JENwMGosH6D29+zkU5TKHKPRm5DDQgv+RtDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QoiaG3EYvybqtc/NfUINcD4NSRNnmffI8wAibsEWgHvBup64MLZEMW5mEds88RY3oZumSWOzLDfYkr5GNLWKnjfgdAbx2eLlTXBOxZ1zX6rDXblu/K6ngRs/EMFMZRCo10vP5OdhfDXvEwE1O/9z8rN4h1PIuJlEEKRkgyeAtrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A/yof6dz; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A/yof6dz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715646119; x=1747182119;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yiGka99JENwMGosH6D29+zkU5TKHKPRm5DDQgv+RtDQ=;
  b=A/yof6dzonGiN4ZB6nvN5lbFwmAFIV5xMNoG8qJe8wQVRpIUcxhCKBqA
   yZhb+C/FeKRq4Y04Wy7n+jUe5EWKSNYq2Z3mN6GX/swbHTG7A4ll5ixaW
   kTefezCEkahR+l0shkMi/8e5w1TyOxoVeYnAYGSfAOp0Jlv1cCDVIhUFY
   Z0gF9d9uKgnXl7/gsVy89kIXHCK7da6PmsTfEz0afV4HYUb9DaYSSIyO1
   z99VDa7ANshUhl5K6u1/45RvUdlmNiP9pFVDKbCxhNPQhVPBRk0JIsmhF
   SUj3EVJc5Te42XPvWXfdiJwfvE58cUewDpyKv7w9L3UFKjLFBMONXCFx2
   g==;
X-CSE-ConnectionGUID: 0EYr+Zr9S4WN/Lnh2+FBhw==
X-CSE-MsgGUID: 4cj5dLlaTqeC6VNvWxC/dw==
X-IronPort-AV: E=McAfee;i="6600,9927,11072"; a="15442014"
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="15442014"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 17:21:58 -0700
X-CSE-ConnectionGUID: AW56gmIWQDeagz2mqLH1XA==
X-CSE-MsgGUID: 29wYm/ZEQyyHajPaoWFNMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="30536834"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.105])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 17:21:58 -0700
Date: Mon, 13 May 2024 17:21:56 -0700
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
Message-ID: <ZkKupOKRu5S7Rkgx@agluck-desk3>
References: <20240503203325.21512-1-tony.luck@intel.com>
 <20240503203325.21512-8-tony.luck@intel.com>
 <0178e84e-d55f-47bf-b8b0-58e05fcaa108@intel.com>
 <ZkJIZdU2knEUJN7Q@agluck-desk3>
 <f49931b0-d9bf-45f0-ab35-93b1a78f6b97@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f49931b0-d9bf-45f0-ab35-93b1a78f6b97@intel.com>

On Mon, May 13, 2024 at 11:53:17AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 5/13/2024 10:05 AM, Tony Luck wrote:
> > On Fri, May 10, 2024 at 02:24:13PM -0700, Reinette Chatre wrote:
> >> Hi Tony,
> > 
> > Hi Reinette,
> > 
> > Thanks for the review. Detailed comments below. But overall I'm
> > going to split patch 7 into a bunch of smaller changes, each with
> > a better commit message.
> > 
> >> On 5/3/2024 1:33 PM, Tony Luck wrote:
> >>
> >> (Could you please start the changelog with some context?)
> >>
> >>> Add a field to the rdt_resource structure to track whether monitoring
> >>> resources are tracked by hardware at a different scope (NODE) from
> >>> the legacy L3 scope.
> >>
> >> This seems to describe @mon_scope that was introduced in patch #3?
> > 
> > Not really. Patch #3 made the change so that control an monitor
> > functions can have different scope. That's still needed as with SNC
> > enabled the underlying data collection is at the node level for
> > monitoring, while control stays at the L3 cache scope.
> > 
> > This new field describes the legacy scope of monitoring, so that
> > resctrl can provide correctly scoped monitor files for legacy
> > applications that aren't aware of SNC. So I'm using this both
> > to indicate when SNC is enabled (with mon_scope != mon_display_scope)
> > or disabled (when they are the same).
> 
> This seems to enforce the idea that these new additions aim to be
> generic on the surface but the only goal is to support SNC.

If you have some more ideas on how to make this more generic and
less SNC specific I'm all ears.

> > 
> >>>
> >>> Add a field to the rdt_mon_domain structure to track the L3 cache id
> >>> which can be used to find all the domains that need resource counts
> >>> summed to provide accurate values in the legacy monitoring files.
> >>
> >> Why is this field necessary? Can this not be obtained dynamically?
> > 
> > I could compute it each time I need it (when making/removing
> > directories, or finding which SNC domains share an L3 domain).
> > 
> > 	id = get_domain_id_from_scope(cpumask_any(&d->cpu_mask), r->mon_display_scope);
> > 	if (id < 0)
> > 		// error path
> > 
> > But it seemed better to just discover this once at domain creation time.
> 
> This may be more clear in the next version?

My goal is to be more clear next version.

> ...
> 
> >>>  	/*
> >>>  	 * As per the SDM, when IA32_QM_EVTSEL.EvtID (bits 7:0) is configured
> >>>  	 * with a valid event code for supported resource type and the bits
> >>> @@ -207,7 +198,7 @@ static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
> >>>  	 * IA32_QM_CTR.Error (bit 63) and IA32_QM_CTR.Unavailable (bit 62)
> >>>  	 * are error bits.
> >>>  	 */
> >>> -	wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid + rmid_offset);
> >>> +	wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid);
> >>>  	rdmsrl(MSR_IA32_QM_CTR, msr_val);
> >>>  
> >>>  	if (msr_val & RMID_VAL_ERROR)
> >>> @@ -291,7 +282,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
> >>>  
> >>>  	resctrl_arch_rmid_read_context_check();
> >>>  
> >>> -	if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
> >>> +	if (d->display_id != get_cpu_cacheinfo_id(smp_processor_id(), r->mon_display_scope))
> >>>  		return -EINVAL;
> >>
> >> Does this mean that when SNC is enabled then reading data for an event within a particular
> >> monitor domain ("node scope") can read its data from any CPU within the L3 domain
> >> ("mon_display_scope") even if that CPU is not associated with the node for which it
> >> is reading the data?
> > 
> > Yes.
> > 
> >> If so this really turns many resctrl assumptions and architecture on its head since the
> >> resctrl expectation is that only CPUs within a domain's cpumask can be used to interact
> >> with the domain. This in turn makes this seemingly general feature actually SNC specific.
> > 
> > This is only an expectation for x86 features using IA32_QM_EVTSEL/IA32_QM_CTR
> > MSR method to read counters. ARM doesn't have the "CPU must be in
> > domain" restriction (as far as I can tell). Nor does the Intel IO RDT
> > (which uses MMIO space for control registers, these can be read/written
> > from any CPU).
> > 
> > We do know that those two MSRs can be read from any CPU that shares an
> > L3 cache. It would seem to be pointless overhead to force a cross
> > processor interrupt to read them from a different CPU just to satisfy
> > a "must be in same domain" non-requirement. I'l split this into its
> > own patch with suitable description.
> 
> I did not suggest that this should be done with multiple IPIs. My comment
> was related to this addition that claims to be generic but really just focuses
> on support for SNC. Any  future addition that may want to build on this would
> need to be aware of these expectations, which are not obvious at this time.

I can add some more comments to make this more obvious.

> ...
> 
>  
> >>>  	return 0;
> >>>  }
> >>>  
> >>> +static u32 get_node_rmid(struct rdt_resource *r, struct rdt_mon_domain *d, u32 rmid)
> >>> +{
> >>> +	int cpu = cpumask_any(&d->hdr.cpu_mask);
> >>> +
> >>> +	return rmid + (cpu_to_node(cpu) % snc_nodes_per_l3_cache) * r->num_rmid;
> >>> +}
> >>> +
> >>> +static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
> >>> +{
> >>> +	struct rdt_mon_domain *d;
> >>> +	struct rmid_read tmp;
> >>> +	u32 node_rmid;
> >>> +	int ret = 0;
> >>> +
> >>> +	if (!rr->sumdomains) {
> >>> +		node_rmid = get_node_rmid(rr->r, rr->d, rmid);
> >>> +		return ___mon_event_count(closid, node_rmid, rr, &rr->val);
> >>> +	}
> >>> +
> >>> +	tmp = *rr;
> >>> +	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
> >>> +		if (d->display_id == rr->d->display_id) {
> >>> +			tmp.d = d;
> >>> +			node_rmid = get_node_rmid(rr->r, d, rmid);
> >>> +			ret = ___mon_event_count(closid, node_rmid, &tmp, &rr->val);
> >>
> >> If I understand correctly this function is run per IPI on a CPU associated
> >> with one of the monitor domains (depends on which one came online first),
> >> and then it will read the monitor data of the other domains from the same
> >> CPU? This is unexpected since the expectation is that monitor data
> >> needs to be read from a CPU associated with the domain it is
> >> reading data for.
> > 
> > See earlier note. The counter can be read from any CPU sharing the same
> > L3. Adding unnecessary IPI is pointless overhead. But I will add
> > comments.
> 
> I did not suggest to add extra IPIs, my comment was related to how this
> feature wedges itself into resctrl.

Sorry for my misunderstanding.

> > 
> >> Also, providing tmp as well as rr->val seems unnecessary?
> > 
> > I think I was unsure about modifying the domain field in the struct
> > rmid_read in the middle of the call chain. But the original caller
> > mon_event_read() doesn't look at rr->domain after the smp_call*()
> > function returns. I will drop "tmp".
> > 
> >>> +			if (ret)
> >>> +				break;
> >>> +		}
> >>> +	}
> >>> +
> >>> +	return ret;
> >>> +}
> >>> +
> >>>  /*
> >>>   * mbm_bw_count() - Update bw count from values previously read by
> >>>   *		    __mon_event_count().
> >>> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> >>> index 0923492a8bd0..a56ae08ca255 100644
> >>> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> >>> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> >>> @@ -3011,57 +3011,118 @@ static int mon_addfile(struct kernfs_node *parent_kn, const char *name,
> >>>   * and monitor groups with given domain id.
> >>>   */
> >>>  static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> >>> -					   unsigned int dom_id)
> >>> +					   struct rdt_mon_domain *d)
> >>>  {
> >>>  	struct rdtgroup *prgrp, *crgrp;
> >>> +	struct rdt_mon_domain *dom;
> >>> +	bool remove_all = true;
> >>> +	struct kernfs_node *kn;
> >>> +	char subname[32];
> >>>  	char name[32];
> >>>  
> >>> +	sprintf(name, "mon_%s_%02d", r->name, d->display_id);
> >>> +	if (r->mon_scope != r->mon_display_scope) {
> >>> +		int count = 0;
> >>> +
> >>> +		list_for_each_entry(dom, &r->mon_domains, hdr.list)
> >>> +			if (d->display_id == dom->display_id)
> >>> +				count++;
> >>> +		if (count > 1) {
> >>> +			remove_all = false;
> >>> +			sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
> >>> +		}
> >>> +	}
> >>
> >>
> >> This seems awkward. I wonder if it may not be simpler to just
> >> remove the directory and on completion check if the parent has
> >> any subdirectories left and remove the parent if there are no
> >> subdirectories remaining. Something possible via reading the inode's
> >> i_nlink that is accessible via kernfs_get_inode(). What do you think?
> > 
> > kernfs_get_inode() needs a pointer to the "struct super_block" for the
> > filesystem. Resctrl filesystem code doesn't seem to keep track of that
> > anywhere. Only mentioned in rdt_kill_sb() where core kernfs code passes
> > it in as the argument. When registering/mounting the resctrl filesystem
> > there's a "struct fs_context *fc" ... is there a function to get the
> > super block from that? Even if there is, I'd need to add a global to
> > save a copy of the fc_context.
> 
> hmmm ... I expected that struct file or struct dentry may be reachable
> from where sb can be obtained but I can only see that now for the
> paths that provide struct kernfs_open_file.

I'm going to keep this the same then. The "rmdir" call path doesn't have
any open files to plumb down to this function.

> 
> ...
> 
> >
> >>>  	}
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> >>> +				struct rdt_mon_domain *d,
> >>> +				struct rdt_resource *r, struct rdtgroup *prgrp)
> >>> +{
> >>> +	struct kernfs_node *kn, *ckn;
> >>> +	char name[32];
> >>> +	bool do_sum;
> >>> +	int ret;
> >>> +
> >>> +	do_sum = r->mon_scope != r->mon_display_scope;
> >>> +	sprintf(name, "mon_%s_%02d", r->name, d->display_id);
> >>> +	kn = kernfs_find_and_get_ns(parent_kn, name, NULL);
> >>> +	if (!kn) {
> >>> +		/* create the directory */
> >>> +		kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
> >>> +		if (IS_ERR(kn))
> >>> +			return PTR_ERR(kn);
> >>> +
> >>> +		ret = rdtgroup_kn_set_ugid(kn);
> >>> +		if (ret)
> >>> +			goto out_destroy;
> >>> +		ret = mon_add_all_files(kn, d, r, prgrp, do_sum);
> >>
> >> This does not look right. If I understand correctly the private data
> >> of these event files will have whichever mon domain came up first as
> >> its domain id. That seems completely arbitrary and does not reflect
> >> accurate state for this file. Since "do_sum" is essentially a "flag"
> >> on how this file can be treated, can its "dom_id" not rather be
> >> the "monitor scope domain id"? Could that not help to eliminate 
> >> that per-domain "display_id"?
> > 
> > You are correct that this should be the "monitor scope domain id" rather
> > than the first SNC domain that appears. I'll change to use that. I don't
> > think it helps in removing the per-domain display_id.
> 
> Wouldn't the file metadata then be the "display_id"?

Yes. The metadata is the display_id for files that need to sum across
SNC nodes, but the domain id for ones where no summation is needed.

> Reinette

-Tony
