Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6526CDAF
	for <patches@lists.linux.dev>; Thu, 21 Nov 2024 17:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732210590; cv=none; b=BAKMk/4TSO+wQ7acMoIU20yV8GV2slhiV9onlKxK2WOIrlJoDZbWSVBDmQXqsz9DkD+HNsDqjihLgcmsrMNLn0A1VnFovBT+sZgoePHIb+0NIGOjzvzAy/SGtt/a1+kvXthOoFEMLo/QSUJn0xL0gyjwW9OLw8F8g+c+by5cs3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732210590; c=relaxed/simple;
	bh=yX1zhmwlvBuriodeGff27vo3wKuh7ROaK4e8d4UaQBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lz9R6XJXxSY2ayhPP2y9WHhMj/xt1hU7rRPk7HeSMqBXr+rK+aP+zyHFk+1dcXyjHEmthU8XNSr2IpnS8HjcFFl4hesP9yg7J8WmcchTCjh0vyslltgeEQlDXvgZSheD8YYXywFkkib1DiOU5UrU8GgsLfsCWYVqge0Vl5E82T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j9SaBsGg; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j9SaBsGg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732210589; x=1763746589;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yX1zhmwlvBuriodeGff27vo3wKuh7ROaK4e8d4UaQBs=;
  b=j9SaBsGgyNyiPlrKDQDEGkEZoYQcgqlk5TogZdQtVxTttIUQttXGGGjB
   Wjf1htXHvf0ffL5376W+966Oq4r5IfgC2dc3AHhGtq2BFd4GWWycgTO6E
   VqaUNjFtwG+Aj2HOlpsHTcErIwVXIqYTHgimCLYl0HPADCVBvgkNwMKTz
   EXXs4vtYxX526zRpKgz7kNjhkX/gEsnkeK+R5QQgG/7RIbKkUTnwlDi+e
   qw74AYpv083uLC0g0bl6jGUqWxh3fMQNMUUHk1lCzBRaPfSXvw8AXITqp
   W6fWHmDcop4C0mkPGyJM067i7wqNuaZEQMCsTN2b+MCiDjAOICtYB5ekI
   Q==;
X-CSE-ConnectionGUID: wit4K+dKQRyHl5mmIiIKQQ==
X-CSE-MsgGUID: YlAXKGeNRi+lZqW6D8+scQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="32270583"
X-IronPort-AV: E=Sophos;i="6.12,173,1728975600"; 
   d="scan'208";a="32270583"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 09:36:28 -0800
X-CSE-ConnectionGUID: CKXB3Rt+Sp+eYwhCjNcFzw==
X-CSE-MsgGUID: jFMliDHIQHen4cnwNuIPXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,173,1728975600"; 
   d="scan'208";a="95274569"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 09:36:28 -0800
Date: Thu, 21 Nov 2024 09:36:26 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>, x86@kernel.org,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v9 4/9] x86/resctrl: Compute memory bandwidth for all
 supported events
Message-ID: <Zz9vmuv6JoyYKSwo@agluck-desk3>
References: <20241114001712.80315-1-tony.luck@intel.com>
 <20241114001712.80315-5-tony.luck@intel.com>
 <6fada5bb-7ca2-4f6b-9174-109c429e8d68@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fada5bb-7ca2-4f6b-9174-109c429e8d68@intel.com>

On Tue, Nov 19, 2024 at 07:45:01PM -0800, Reinette Chatre wrote:
> Hi Tony,
> 
> On 11/13/24 4:17 PM, Tony Luck wrote:
> > Computing the bandwidth for an event is cheap, and only done once
> > per second. Doing so simplifies switching between events and allows
> > choosing different events per ctrl_mon group.
> 
> This just reads like some a general statement. There surely can be
> some context, problem and *some* description about how this patch goes
> about addressing the problem?

I've rewritten this in the problem ... solution format.

> > 
> > Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  arch/x86/kernel/cpu/resctrl/monitor.c | 72 ++++++++++++---------------
> >  1 file changed, 33 insertions(+), 39 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> > index 2176e355e864..da4ae21350c8 100644
> > --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> > +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> > @@ -663,9 +663,12 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
> >   */
> >  static void mbm_bw_count(u32 closid, u32 rmid, struct rmid_read *rr)
> >  {
> > -	u32 idx = resctrl_arch_rmid_idx_encode(closid, rmid);
> > -	struct mbm_state *m = &rr->d->mbm_local[idx];
> >  	u64 cur_bw, bytes, cur_bytes;
> > +	struct mbm_state *m;
> > +
> > +	m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
> > +	if (WARN_ON_ONCE(!m))
> > +		return;
> >  
> >  	cur_bytes = rr->val;
> >  	bytes = cur_bytes - m->prev_bw_bytes;
> > @@ -826,54 +829,45 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
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
> >  
> >  	/*
> > -	 * This is protected from concurrent reads from user
> > -	 * as both the user and we hold the global mutex.
> > +	 * If the software controller is enabled, compute the
> > +	 * bandwidth for this event id.
> >  	 */
> > -	if (is_mbm_total_enabled()) {
> > -		rr.evtid = QOS_L3_MBM_TOTAL_EVENT_ID;
> > -		rr.val = 0;
> > -		rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
> > -		if (IS_ERR(rr.arch_mon_ctx)) {
> > -			pr_warn_ratelimited("Failed to allocate monitor context: %ld",
> > -					    PTR_ERR(rr.arch_mon_ctx));
> > -			return;
> > -		}
> > -
> > -		__mon_event_count(closid, rmid, &rr);
> > +	if (is_mba_sc(NULL))
> > +		mbm_bw_count(closid, rmid, &rr);
> >  
> > -		resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
> > -	}
> > -	if (is_mbm_local_enabled()) {
> > -		rr.evtid = QOS_L3_MBM_LOCAL_EVENT_ID;
> > -		rr.val = 0;
> > -		rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
> > -		if (IS_ERR(rr.arch_mon_ctx)) {
> > -			pr_warn_ratelimited("Failed to allocate monitor context: %ld",
> > -					    PTR_ERR(rr.arch_mon_ctx));
> > -			return;
> > -		}
> > -
> > -		__mon_event_count(closid, rmid, &rr);
> > +	resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
> > +}
> >  
> > -		/*
> > -		 * Call the MBA software controller only for the
> > -		 * control groups and when user has enabled
> > -		 * the software controller explicitly.
> > -		 */
> > -		if (is_mba_sc(NULL))
> > -			mbm_bw_count(closid, rmid, &rr);
> > +static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
> > +		       u32 closid, u32 rmid)
> > +{
> > +	/*
> > +	 * This is protected from concurrent reads from user
> > +	 * as both the user and we hold the global mutex.
> 
> I understand that you are just copy&pasting a comment here but could you please
> help to avoid any obstacles by removing the code impersonation? Perhaps something like:
> 
> 	 * This is protected from concurrent reads from user
> 	 * as both the user and overflow handler hold the global mutex.
> 
> (please feel free to improve)

No improvement to the text needed. But I did move some words from 2nd
line to the first to look better (IMHO).

> > +	 */
> > +	if (is_mbm_total_enabled())
> > +		mbm_update_one_event(r, d, closid, rmid, QOS_L3_MBM_TOTAL_EVENT_ID);
> >  
> > -		resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
> > -	}
> > +	if (is_mbm_local_enabled())
> > +		mbm_update_one_event(r, d, closid, rmid, QOS_L3_MBM_LOCAL_EVENT_ID);
> >  }
> >  
> >  /*
> 
> Reinette

-Tony
