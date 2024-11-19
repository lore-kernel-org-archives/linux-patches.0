Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A951C139B
	for <patches@lists.linux.dev>; Tue, 19 Nov 2024 00:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731974481; cv=none; b=YMhbhnWvK6baZ0TGayCcEPRvj9NB1HdeOie+0zde2rhWqW0WLPf+pNU240s3xzrNzlEwe49p8h1im3HEtmUSbwjxMTJiSV5E5B8lduWN8J7PBzMuqXngWwdVEe2jl68kbA97oOUOWYcf1pEnFO0u9SsfOQEz/lR12a4BkSdU0Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731974481; c=relaxed/simple;
	bh=orDGzAQZwG4+RKWIEagT15/dScedZ3c9WyAs38EzDNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=isg9iGcG4gaDbTVO4WRa5vaO+l0Lf4OwwRX2A5ADkVq0pYiQMILLKABfZ+lD6HEQbIRmsI4Lz9gGd7s+Spdi+21ZON9JPPcABesTq3nsUqYL73mknzNNaQH90JLomDMqwCP/suTPjyVheXezP4wOgPT+OsEA5Kgjo+IQUTSGfeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AKYdGxKa; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AKYdGxKa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731974480; x=1763510480;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=orDGzAQZwG4+RKWIEagT15/dScedZ3c9WyAs38EzDNo=;
  b=AKYdGxKa8PikJBoI5/LwitwynyHSVvBFWYSF/KXsGRy8oJPtNZxd98sv
   zcITOlR5bTCiljAnL9s47GtIwVJ9d4OIegAGUFB6XuD5JEl0gCLFtgj+7
   gt7MDfziIHdEY7RWqbv6Vgf8OeNhIE4VazYoIthXyw/s7hZqJ3L+ffjqa
   4pnM24PSwqJpZVKcyOO39mC/PV0B/MvqfAvxbn2wz+ZlDa46oberWQi3r
   xydZhtjFAS9t2M9DtkO4BRiFfUkSN6qjvt+IoYy8n56ZPpdYb40WFp6YB
   M3TfqQdceAvaDqx3A1TuXeT7v79/CMFFMzS1XFYyphq4CKuvClcqdvv3L
   Q==;
X-CSE-ConnectionGUID: 1i4DACP8StCp28JTgGmGqQ==
X-CSE-MsgGUID: BWiUbPs5Swi/D9cWvn79nw==
X-IronPort-AV: E=McAfee;i="6700,10204,11260"; a="31880392"
X-IronPort-AV: E=Sophos;i="6.12,165,1728975600"; 
   d="scan'208";a="31880392"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 16:01:19 -0800
X-CSE-ConnectionGUID: qXwrRl6GToWMf9KoDHF3sw==
X-CSE-MsgGUID: dxx68Z4qSeeeG4qAmcaUcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="94432635"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 16:01:15 -0800
Date: Mon, 18 Nov 2024 16:01:13 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: babu.moger@amd.com
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>, x86@kernel.org,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v9 3/9] x86/resctrl: Modify update_mba_bw() to use per
 ctrl_mon group event
Message-ID: <ZzvVSamxTo9QSWBU@agluck-desk3>
References: <20241114001712.80315-1-tony.luck@intel.com>
 <20241114001712.80315-4-tony.luck@intel.com>
 <b4b31f4f-7f09-4ee3-9373-6ffe5ea859a6@amd.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4b31f4f-7f09-4ee3-9373-6ffe5ea859a6@amd.com>

On Fri, Nov 15, 2024 at 10:21:01AM -0600, Moger, Babu wrote:
> Hi Tony,

Thanks for looking at this patch.

> 
> On 11/13/2024 6:17 PM, Tony Luck wrote:
> > Instead of hard-coding the memory bandwidth local event as the
> > input to the mba_sc feedback look, use the event that the user
> > configured for each ctrl_mon group.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >   arch/x86/kernel/cpu/resctrl/monitor.c | 23 ++++++++++++++++++-----
> >   1 file changed, 18 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> > index 7ef1a293cc13..2176e355e864 100644
> > --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> > +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> > @@ -752,20 +752,31 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
> >   	u32 closid, rmid, cur_msr_val, new_msr_val;
> >   	struct mbm_state *pmbm_data, *cmbm_data;
> >   	struct rdt_ctrl_domain *dom_mba;
> > +	enum resctrl_event_id evt_id;
> >   	struct rdt_resource *r_mba;
> > -	u32 cur_bw, user_bw, idx;
> >   	struct list_head *head;
> >   	struct rdtgroup *entry;
> > +	u32 cur_bw, user_bw;
> > -	if (!is_mbm_local_enabled())
> > +	if (!is_mbm_enabled())
> >   		return;
> >   	r_mba = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
> > +	evt_id = rgrp->mba_mbps_event;
> > +
> > +	if (WARN_ON_ONCE(!is_mbm_event(evt_id)))
> > +		return;
> 
> I feel this check is enough.
> 
> > +	if (WARN_ON_ONCE(evt_id == QOS_L3_MBM_LOCAL_EVENT_ID && !is_mbm_local_enabled()))
> > +		return;
> > +	if (WARN_ON_ONCE(evt_id == QOS_L3_MBM_TOTAL_EVENT_ID && !is_mbm_total_enabled()))
> > +		return;
> 
> These two checks are not necessary.  You are already validating it while
> initializing(in patch 7).

I added this in response to a comment on v7 from Reinette that evt_id
wasn't properly validated here - in conjuction with the change a few
lines earlier that relaxed the check for is_mbm_local_enabled() to
just is_mbm_enabled().

See: https://lore.kernel.org/r/bb30835f-5be9-44b4-8544-2f528e7fc573@intel.com

In theory all of these tests could be dropped. As you point out the
sanity checks are done higher in the call sequence. But some folks
like the "belt and braces" approach to such sanity checks.

> > +
> >   	closid = rgrp->closid;
> >   	rmid = rgrp->mon.rmid;
> > -	idx = resctrl_arch_rmid_idx_encode(closid, rmid);
> > -	pmbm_data = &dom_mbm->mbm_local[idx];
> > +	pmbm_data = get_mbm_state(dom_mbm, closid, rmid, evt_id);
> > +	if (WARN_ON_ONCE(!pmbm_data))
> > +		return;
> >   	dom_mba = get_ctrl_domain_from_cpu(smp_processor_id(), r_mba);
> >   	if (!dom_mba) {
> > @@ -784,7 +795,9 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
> >   	 */
> >   	head = &rgrp->mon.crdtgrp_list;
> >   	list_for_each_entry(entry, head, mon.crdtgrp_list) {
> > -		cmbm_data = &dom_mbm->mbm_local[entry->mon.rmid];
> > +		cmbm_data = get_mbm_state(dom_mbm, entry->closid, entry->mon.rmid, evt_id);
> > +		if (WARN_ON_ONCE(!cmbm_data))
> > +			return;
> >   		cur_bw += cmbm_data->prev_bw;
> >   	}
> 
> -- 
> - Babu Moger

-Tony
