Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB308374C4
	for <patches@lists.linux.dev>; Mon,  3 Jun 2024 23:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717456542; cv=none; b=rUGfLxdZQjC+GPRgqp811iU5B/CoGdylFHmdRbuad9hJWI2JGI0HiumwAs4hMPiCvnJgagERK9hVXkxw+cT6esEEhOibWq+KR58qYUb04Qbb9PvJcNMcw0nPzs3LlUX9OAFGTzuazpbisNc0/FQ/sz+3CRekVGzBp7dLc7Q5loU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717456542; c=relaxed/simple;
	bh=8oem86It5+4h0XVIcJq2Hk0hjpuSoibDwTR1LSjFAg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PbDMqNJmjVnOIDsb1iDChWdz2hl6d9VzvpMgLnQBcZG3cVXCB41Bl7fepjVXaiBKdsQF/AMsXDqUeIYnEuvtLn/2Dj7PkPRzJByjWRQHfVGZu3kBP8yTdBOmilpDauVKECcQhrSXrXazna3kebat8gJSYWHlf2YXKEoczT5wZ1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LlHGu8eb; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LlHGu8eb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717456540; x=1748992540;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8oem86It5+4h0XVIcJq2Hk0hjpuSoibDwTR1LSjFAg0=;
  b=LlHGu8eboKLsN/WRE7eYtcdRcZZsk8O5Ve1t7a8RgvxF6prQf3vpGmyJ
   +mfCT3jPMqDq22q69PN37KSX3b+syX3on0x72/WvUoi8cBvF92XgpnZ+5
   7vQwt1TKypu/XvYohqwvIIyV2+nF7w1MCqyLkmqMBLDNVe6i/fttBejc/
   AVwu3kRqcpD15uDc8U9A35dOY2JZYsgLMShk6KYL3ffVecX5c6JPy4rxb
   XK+AET/B7M/iMe+2fbAu6Zm3+r3PK0mG/1H3H2T08Hme8BPJ8y1SFQiGj
   AjLvnI0rlHqC9eTBUdNLJraA4xP9+2rz4E4wNW8C5lSIvVrrKwM2sWCdF
   w==;
X-CSE-ConnectionGUID: xujBfPgvQsilGSo50bZJEA==
X-CSE-MsgGUID: zWHho+VEQ7qHQncn8X+uIQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11092"; a="24599704"
X-IronPort-AV: E=Sophos;i="6.08,212,1712646000"; 
   d="scan'208";a="24599704"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2024 16:15:39 -0700
X-CSE-ConnectionGUID: uZc91RJCTIeBnvfs/FjpgA==
X-CSE-MsgGUID: qG5yKnFLQ0WqpNYOBzRnNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,212,1712646000"; 
   d="scan'208";a="37481514"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2024 16:15:39 -0700
Date: Mon, 3 Jun 2024 16:15:37 -0700
From: Tony Luck <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v19 16/20] x86/resctrl: Make resctrl_arch_rmid_read()
 handle sum over domains
Message-ID: <Zl5OmVWFpBtA509j@agluck-desk3.sc.intel.com>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <20240528222006.58283-17-tony.luck@intel.com>
 <9818c304-9056-4d79-acbe-2b35cb847ecd@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9818c304-9056-4d79-acbe-2b35cb847ecd@intel.com>

On Thu, May 30, 2024 at 01:24:57PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 5/28/24 3:20 PM, Tony Luck wrote:
> > Legacy resctrl monitor files must provide the sum of event values across
> > all Sub-NUMA Cluster (SNC) domains that share an L3 cache instance.
> > 
> > Rename the existing resctrl_arch_rmid_read() function as
> > resctrl_arch_rmid_read_one() (with some small refactoring to drop
> > arguments that are not needed.
> 
> Missing closing ")".

Will add.

> > 
> > Create a new resctrl_arch_rmid_read() that iterates across
> > domains when necessary. Pass a CPU number from the right domain to
> > resctrl_arch_rmid_read_one().
> 
> "when necessary"? Can you elaborate?
> "Pass a CPU ..." that just describes code that can be learned from patch.
> Please describe the changes not the code.

Will re-write.

> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >   arch/x86/kernel/cpu/resctrl/monitor.c | 41 ++++++++++++++++++++-------
> >   1 file changed, 31 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> > index 5f89ed4823ee..c9dd6ec68fcd 100644
> > --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> > +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> > @@ -200,10 +200,9 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
> >    * Caller is responsible to make sure execution running on a CPU in
> >    * the domain to be read.
> >    */
> > -static int logical_rmid_to_physical_rmid(int lrmid)
> > +static int logical_rmid_to_physical_rmid(int cpu, int lrmid)
> >   {
> >   	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> > -	int cpu = smp_processor_id();
> >   	if (snc_nodes_per_l3_cache  == 1)
> >   		return lrmid;
> > @@ -211,13 +210,13 @@ static int logical_rmid_to_physical_rmid(int lrmid)
> >   	return lrmid + (cpu_to_node(cpu) % snc_nodes_per_l3_cache) * r->num_rmid;
> >   }
> > -static int __rmid_read(u32 lrmid,
> > +static int __rmid_read(int cpu, u32 lrmid,
> >   		       enum resctrl_event_id eventid, u64 *val)
> >   {
> >   	u64 msr_val;
> >   	int prmid;
> > -	prmid = logical_rmid_to_physical_rmid(lrmid);
> > +	prmid = logical_rmid_to_physical_rmid(cpu, lrmid);
> >   	/*
> 
> Passing CPU as parameter to __rmid_read(), which is run via IPI, really
> obfuscates the code. How about renaming it to "__rmid_read_phys()"
> and provide it the "physical RMID" as parameter to make it clear what it is
> doing?
> That would mean an extra call to determine "physical RMID" before calling
> __rmid_read_phys() but making it clear that it needs a physical RMID should
> help to explain what is going on.
> 
> 
> >   	 * As per the SDM, when IA32_QM_EVTSEL.EvtID (bits 7:0) is configured
> >   	 * with a valid event code for supported resource type and the bits
> > @@ -269,7 +268,7 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
> >   		memset(am, 0, sizeof(*am));
> >   		/* Record any initial, non-zero count value. */
> > -		__rmid_read(rmid, eventid, &am->prev_msr);
> > +		__rmid_read(smp_processor_id(), rmid, eventid, &am->prev_msr);
> >   	}
> >   }
> > @@ -298,9 +297,8 @@ static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr, unsigned int width)
> >   	return chunks >> shift;
> >   }
> > -int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
> > -			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
> > -			   u64 *val, bool sum, struct cacheinfo *ci, void *ignored)
> > +static int resctrl_arch_rmid_read_one(struct rdt_resource *r, struct rdt_mon_domain *d,
> > +				      int cpu, u32 rmid, enum resctrl_event_id eventid, u64 *val)
> >   {
> >   	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
> >   	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
> > @@ -313,7 +311,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
> >   	if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
> >   		return -EINVAL;
> > -	ret = __rmid_read(rmid, eventid, &msr_val);
> > +	ret = __rmid_read(cpu, rmid, eventid, &msr_val);
> >   	if (ret)
> >   		return ret;
> > @@ -327,7 +325,30 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
> >   		chunks = msr_val;
> >   	}
> > -	*val = chunks * hw_res->mon_scale;
> > +	*val += chunks * hw_res->mon_scale;
> 
> The various new layers of indirection with SNC logic scattered between them
> makes this change hard to understand.
> 
> > +
> > +	return 0;
> > +}
> > +
> > +int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
> > +			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
> > +			   u64 *val, bool sum, struct cacheinfo *ci, void *ignored)
> 
> This is not architecture specific code.

Can you explain further? I've dropped the "sum" argument. As you pointed
out elsewhere this can be inferred from "d == NULL".  But I do need the
cacheinfo information in resctrl_arch_rmid_read() to:
1) determine which domains to sum (those that match ci->id).
2) sanity check code is executing on a CPU in ci->shared_cpu_map.

> > +{
> > +	int cpu = smp_processor_id();
> > +	int ret;
> > +
> > +	*val = 0;
> > +	if (!sum)
> > +		return resctrl_arch_rmid_read_one(r, d, cpu, rmid, eventid, val);
> > +
> 
> 	/* SNC quirk that needs to be documented */
> 
> > +	list_for_each_entry(d, &r->mon_domains, hdr.list) {
> > +		if (d->ci->id != ci->id)
> > +			continue;
> > +		cpu = cpumask_any(&d->hdr.cpu_mask);
> > +		ret = resctrl_arch_rmid_read_one(r, d, cpu, rmid, eventid, val);
> 
> The cpu parameter can be dropped, no? With the domain provided to resctrl_arch_rmid_read_one()
> it is not necessary to again split the SNC logic (in this case the "reading from any CPU
> in the cache domain is ok but still need accurate arch state") across multiple layers,
> just contain this in (documented portion of) resctrl_arch_rmid_read_one().

You are correct. I will drop the cpu argument.

> > +		if (ret)
> > +			return ret;
> > +	}
> >   	return 0;
> >   }
> 
> Reinette

-Tony
