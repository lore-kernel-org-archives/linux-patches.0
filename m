Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7550156F5E
	for <patches@lists.linux.dev>; Thu, 21 Nov 2024 17:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732210776; cv=none; b=up5cPXNLBxHX/tduYx/jGmMN+xvriRHqfG0Wu4ZffNx91TPH4bP1xJjSFmyWKtPkqolH24VrpRBeAqrrqgM9oSubXpS5Ynn9GUG2HnBfsc6xNNArU9FNL6HowoaSQ0vUMakhqr9WzV9L6HyDlEMra3aLLbAMRjRYW7kInJWUWPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732210776; c=relaxed/simple;
	bh=uT1Nv9OIO5LpSBXoquolSqcEzlSL841t1zuKuEVmULI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TfC1bWFjWJLRm3A0vp9h8cj5d50sxuiQNT20Z0ar/jlXs2snZ/vsV6iLgp/1sNblWNquTBsw3VMYoVoVMOwAvoTUEmAvdGnHw+hCI5piPxDlruisdVnU9tnPFF/z9kKC8elU2+6HaYnkw2kRCIQncD1iCGYCT7V9AFLbx+l0ZzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UHPYmaaD; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UHPYmaaD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732210774; x=1763746774;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uT1Nv9OIO5LpSBXoquolSqcEzlSL841t1zuKuEVmULI=;
  b=UHPYmaaDU1Pw0wldrUnAxVGpHCxpJrW0bE/h0JhpdRTHV/4Pdmv8IXdk
   qAhuwpiL2uAkxVYMj6+qVYPHuo1BySRWMdv8ItLqW6jnt+EMkKxk7d2LR
   F4fWIG75fS6RCqnVZnEjOZlj33owLPP1gZiYC6uXdaFeMzFPf0T5rkmOE
   xY9406TqpmifxYOd4wis0nS8cXDWl9aXG5I1G2ftfUQmZiPoN9QqfcuAz
   GwT2Szz+G6FxIY8wlh2Q3NNaz+cEfI5L9SVhXLlykbQjM5M2ydE7J0Sdp
   T6NiSFMbKzs0YU5rYkNl4Fyjz0ZKi/N4yXDS03MOArCCJmKkzTYc+5ZqP
   Q==;
X-CSE-ConnectionGUID: vgPgWSQLSAeqg8+GVm1ogg==
X-CSE-MsgGUID: WEu7OBVkSLyFwvOn8ValUQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="32271168"
X-IronPort-AV: E=Sophos;i="6.12,173,1728975600"; 
   d="scan'208";a="32271168"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 09:39:34 -0800
X-CSE-ConnectionGUID: JM42aBx2T0edIsgjq5qWGw==
X-CSE-MsgGUID: IrQ8vYMxTw6INmJ++BcMGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,173,1728975600"; 
   d="scan'208";a="90739796"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 09:39:34 -0800
Date: Thu, 21 Nov 2024 09:39:32 -0800
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
Subject: Re: [PATCH v9 5/9] x86/resctrl: Relax checks for mba_MBps mount
 option
Message-ID: <Zz9wVHIzbgL9ob21@agluck-desk3>
References: <20241114001712.80315-1-tony.luck@intel.com>
 <20241114001712.80315-6-tony.luck@intel.com>
 <a87640c0-0cd5-42be-83fc-bd12385bf69f@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a87640c0-0cd5-42be-83fc-bd12385bf69f@intel.com>

On Tue, Nov 19, 2024 at 07:54:10PM -0800, Reinette Chatre wrote:
> Hi Tony,
> 
> On 11/13/24 4:17 PM, Tony Luck wrote:
> > This option may be used with any memory bandwidth monitoring event.
> 
> Needs a changelog.

Added one.

> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  arch/x86/kernel/cpu/resctrl/rdtgroup.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> > index a8022bddf9f7..3a89516e6f56 100644
> > --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> > +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> > @@ -2334,7 +2334,7 @@ static bool supports_mba_mbps(void)
> >  	struct rdt_resource *rmbm = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> >  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
> >  
> > -	return (is_mbm_local_enabled() &&
> > +	return (is_mbm_enabled() &&
> >  		r->alloc_capable && is_mba_linear() &&
> >  		r->ctrl_scope == rmbm->mon_scope);
> >  }
> 
> I *thought* I had a handle on things with the understanding that rdtgroup.mba_mbps_event
> is only valid when mba_sc is enabled. This understanding falls apart with this change since
> at this point in series if a system only supports total MBM then mba_sc may be true
> but rdtgroup.mba_mbps_event will be zero.
> 
> The expectation is that patches build on each other to create a solution but this series
> does not respect this making it difficult to reason about this work.  I think this series
> will be easier to understand if "x86/resctrl: Make mba_sc use total bandwidth if local
> is not supported" is moved before this change.

Rather than moving that patch before this one, I've merged it into this
patch since both are small and intimately connected.

> > @@ -2759,7 +2759,7 @@ static int rdt_parse_param(struct fs_context *fc, struct fs_parameter *param)
> >  		ctx->enable_cdpl2 = true;
> >  		return 0;
> >  	case Opt_mba_mbps:
> > -		msg = "mba_MBps requires local MBM and linear scale MBA at L3 scope";
> > +		msg = "mba_MBps requires MBM and linear scale MBA at L3 scope";
> >  		if (!supports_mba_mbps())
> >  			return invalfc(fc, msg);
> >  		ctx->enable_mba_mbps = true;
> 
> Reinette

-Tony
