Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC5E18C323
	for <patches@lists.linux.dev>; Wed, 13 Nov 2024 22:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731538704; cv=none; b=qkpsbnv4hxyJt3fEPEcrHXOyz7/Yu2yg39bazGLWR6Nu8OrSNuMjZbzSPKGyTp7pWS6v0KPAcwpbMv4/D0zh+6JIxDT/cYDELd4Eqvsh3NTrgF2dZRODPtmkyf7DgKiKIfv/8zjPkiB+KINVYOPAotQJ19IlxllVv16/57m7dVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731538704; c=relaxed/simple;
	bh=GPzpJG2PUmVXqNohmD8igEt8vsvKY0MkCptWiPFpVQY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GIcJ/7b8iRKHBgHwj76uVLDimH7Ndzgixp/Os+TqreZeihhZNkwG5f/FIcauH+NvSxsCH/wdKNaxzG1sbbEDlaPRPUZe3N8yiPWBdLVmFVbs1QOPhIcy4epeh3W9nuI+o2DEcq2kfoQfisUvRf9XqjVTTIzY65S27UBb8m4YlAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MS2ifE49; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MS2ifE49"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731538702; x=1763074702;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GPzpJG2PUmVXqNohmD8igEt8vsvKY0MkCptWiPFpVQY=;
  b=MS2ifE499a2tz4Pna/EeiL7FrZ+Ud6FCJPjybUGkHI96eKgs1f1Elv0X
   ukhaZjtIRewZGTWaI2SQ0AE0M6Q/Kmuo1Fjylw1HQuUGvvlDIZ+evu0rC
   nQDEF/hc2M6PqIXBHvVR8HKhoq2KFJVjkr2f0bxDG79yFbhGXWfdNphal
   qnGbattctNYeY8J1Lu4W8E3yo9uzm5pCbUboKbYYSt6puM9FDf2oapNiI
   FBk8+kFPOtILvlOSbcLDqukDxR+tdwSfMkP7oDH0hQoFO3zYLDpJ/aT3i
   eH/pnU9xCQSK3EFpvKOJRmdFvpVyf0TwRkWAvxRuiwhjw6MVcvNI5DANB
   Q==;
X-CSE-ConnectionGUID: FgXpFhpaSyC8SN7nXArE2A==
X-CSE-MsgGUID: DWMYBG5zSvaRvFhpqEHfsg==
X-IronPort-AV: E=McAfee;i="6700,10204,11255"; a="30863183"
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="30863183"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 14:58:12 -0800
X-CSE-ConnectionGUID: ZG15JIMjS+eTLWEYfhKByg==
X-CSE-MsgGUID: lsFdZ0AyTvGSn5SYqHu26Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="111324806"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 14:58:13 -0800
Date: Wed, 13 Nov 2024 14:58:11 -0800
From: Tony Luck <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v8 3/7] x86/resctrl: Refactor mbm_update()
Message-ID: <ZzUvA2XE01U25A38@agluck-desk3>
References: <20241029172832.93963-1-tony.luck@intel.com>
 <20241029172832.93963-4-tony.luck@intel.com>
 <f4845fee-3f91-4e78-a186-a7bdc58f7873@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4845fee-3f91-4e78-a186-a7bdc58f7873@intel.com>

On Wed, Nov 13, 2024 at 02:25:53PM -0800, Reinette Chatre wrote:
> Hi Tony,
> 
> On 10/29/24 10:28 AM, Tony Luck wrote:
> > Computing memory bandwidth for all enabled events resulted in
> > identical code blocks for total and local bandwidth in mbm_update().
> > 
> > Refactor with a helper function to eliminate code duplication.
> > 
> > No functional change.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  arch/x86/kernel/cpu/resctrl/monitor.c | 69 ++++++++++-----------------
> >  1 file changed, 24 insertions(+), 45 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> > index 3ef339e405c2..1b6cb3bbc008 100644
> > --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> > +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> > @@ -829,62 +829,41 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
> >  	resctrl_arch_update_one(r_mba, dom_mba, closid, CDP_NONE, new_msr_val);
> >  }
> >  
> > -static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
> > -		       u32 closid, u32 rmid)
> > +static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *d,
> > +				 u32 closid, u32 rmid, enum resctrl_event_id evtid)
> >  {
> >  	struct rmid_read rr = {0};
> >  
> >  	rr.r = r;
> >  	rr.d = d;
> > +	rr.evtid = evtid;
> > +	rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
> > +	if (IS_ERR(rr.arch_mon_ctx)) {
> > +		pr_warn_ratelimited("Failed to allocate monitor context: %ld",
> > +				    PTR_ERR(rr.arch_mon_ctx));
> > +		return;
> > +	}
> > +
> > +	__mon_event_count(closid, rmid, &rr);
> > +
> > +	if (is_mba_sc(NULL))
> > +		mbm_bw_count(closid, rmid, &rr);
> > +
> 
> As I am staring at this more there seems to be an existing issue here ... note how
> __mon_event_count()'s return value is not checked before mbm_bw_count() is called.
> This means that mbm_bw_count() may run with rr.val of 0 that results in wraparound
> inside it resulting in some unexpected bandwidth numbers. Since a counter read can fail
> with a "Unavailable"/"Error" from hardware it is not deterministic how frequently this
> issue can be encountered.
> 
> Skipping mbm_bw_count() if rr.val is 0 is one option ... that would keep the bandwidth
> measurement static at whatever was the last successful read and thus not cause dramatic
> changes by the software controller ... setting bandwidth to 0 if rr.val is 0 is another
> option to reflect that bandwidth data is unavailable, but then the software controller should
> perhaps get signal to not make adjustments? I expect there are better options? What do
> you think?

Skipping mbm_bw_count() is also undesirable. If some later
__mon_event_count() does succeed the bandwidth will be computed
based on the last and current values as if they were one second
apart, when actually some longer interval elapsed.

I don't think this is a big issue for current Intel CPU RDT
implementations because I don't think they will return the
bit 62 unavailable value in the IA32_QM_CTR MSR. I'll ask
around to check.

But it does mean that implementing the "summary bandwidth"
file discussed in the other e-mail thread[1] may be more
complex on systems that can return that a counter is
unavailable. We'd have to keep track that two succesful
counter reads occured, with a measure of the interval
between them before reporting a value in the summary file.

-Tony

[1] https://lore.kernel.org/all/CALPaoCjCWZ4ZYfwooFEzMn15jJM7s9Rfq83YhorOGUD=1GdSyw@mail.gmail.com/
