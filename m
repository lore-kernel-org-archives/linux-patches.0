Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE4525A645
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 22:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749077898; cv=none; b=e362HX8oPT+DHwm+mQywRmI5/zc7DTchfx7HCM21hK2oRcubbGqhDX3I3doiZND4BQS5PEl+FlcbBe4xC4SNUBMNgN7Sx0hEWEZouecxm3MOixTNvqXgp3c4H33b9Xd3aCntneI8dpoDWXVGu+ZtSUz5jpgiwU9b8hXLl419zm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749077898; c=relaxed/simple;
	bh=GzZ17EHodviThy4cQKgn2BX/gexgbOOUAnxS5f9iIGM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d6dK7MD0ZBDp9vua81wBCT5sjEsoa2AtT7UvHX+ds0SKr0na2JSsEoT/i0u/nH79lEZrFRfhxpN+NGpR0bJCuMfL2Qo/BTaf305wCJfpIikbWsYfDB+3SVFJ9NNZXmYYTz+MKl/QfB4LcOmoEPeVL0zfQuU6fTW+PJCUhLGzD6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jEpoRbEb; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jEpoRbEb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749077896; x=1780613896;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GzZ17EHodviThy4cQKgn2BX/gexgbOOUAnxS5f9iIGM=;
  b=jEpoRbEbTwDodqPiuRZSwE5OdM3OD4PDixrVpXt36Ha0NzrrnSNVJWig
   aic/TPG6iniIk66I0b2H8gM2I7/9lQ1MLkhf+kgpBpOMgAKyjllB5loVJ
   s399Fh3x8o+XOv/JwqV+2djDs+50LtmTohE/Pq/xgl4cLE36pQhXsArt8
   yW5QJ76oFTTdfoeoL4Aq8nDDN3pQ/8KjVKDxq+fvT/cgcm8qvxkXKwIuJ
   X6IeXGKHUjnNPO3jBBQJ49NXHC5Z8FKFKbNHiuJ7Q4da2TsNVouiALAOd
   YYonA4WCbbx/KmQuFLZt4fJwngP4Qhe1lIsYKtlQlb+odXAfqHMlOVwzu
   w==;
X-CSE-ConnectionGUID: VUxE1bRYS5yITvh58hG+dQ==
X-CSE-MsgGUID: qOxRGBXLQfeOuiv3E1tZsg==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="62236326"
X-IronPort-AV: E=Sophos;i="6.16,210,1744095600"; 
   d="scan'208";a="62236326"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 15:58:15 -0700
X-CSE-ConnectionGUID: HvRB10eBRu2SOyT/rezorg==
X-CSE-MsgGUID: SZcZejnDTRymQr5MNeGdeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,210,1744095600"; 
   d="scan'208";a="149160214"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 15:58:14 -0700
Date: Wed, 4 Jun 2025 15:58:13 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v5 06/29] x86,fs/resctrl: Improve domain type checking
Message-ID: <aEDPhbwyjzeum_Km@agluck-desk3>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-7-tony.luck@intel.com>
 <7de291ed-a29b-4768-9b27-7fd9f5602e37@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7de291ed-a29b-4768-9b27-7fd9f5602e37@intel.com>

On Tue, Jun 03, 2025 at 08:31:07PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 5/21/25 3:50 PM, Tony Luck wrote:
> > The rdt_domain_hdr structure is used in both control and monitor
> > domain structures to provide common methods for operations such as
> > adding a CPU to a domain, removing a CPU from a domain, accessing
> > the mask of all CPUs in a domain.
> > 
> > The "type" field provides a simple check whether a domain is a
> > control or monitor domain so that programming errors operating
> > on domains will be quickly caught.
> > 
> > To prepare for additional domain types that depend on the rdt_resource
> > to which they are connected add the resource id into the header
> > and check that in addition to the type.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  include/linux/resctrl.h            |  9 +++++++++
> >  arch/x86/kernel/cpu/resctrl/core.c | 10 ++++++----
> >  fs/resctrl/ctrlmondata.c           |  2 +-
> >  3 files changed, 16 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> > index 40f2d0d48d02..d6b09952ef92 100644
> > --- a/include/linux/resctrl.h
> > +++ b/include/linux/resctrl.h
> > @@ -131,15 +131,24 @@ enum resctrl_domain_type {
> >   * @list:		all instances of this resource
> >   * @id:			unique id for this instance
> >   * @type:		type of this instance
> > + * @rid:		index of resource for this domain
> >   * @cpu_mask:		which CPUs share this resource
> >   */
> >  struct rdt_domain_hdr {
> >  	struct list_head		list;
> >  	int				id;
> >  	enum resctrl_domain_type	type;
> > +	enum resctrl_res_level		rid;
> >  	struct cpumask			cpu_mask;
> >  };
> >  
> > +static inline bool domain_header_is_valid(struct rdt_domain_hdr *hdr,
> > +					  enum resctrl_domain_type type,
> > +					  enum resctrl_res_level rid)
> > +{
> > +	return !WARN_ON_ONCE(hdr->type != type || hdr->rid != rid);
> > +}
> > +
> >  /**
> >   * struct rdt_ctrl_domain - group of CPUs sharing a resctrl control resource
> >   * @hdr:		common header for different domain types
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index 4403a820db12..4983f6f81218 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -456,7 +456,7 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
> >  
> >  	hdr = resctrl_find_domain(&r->ctrl_domains, id, &add_pos);
> >  	if (hdr) {
> > -		if (WARN_ON_ONCE(hdr->type != RESCTRL_CTRL_DOMAIN))
> > +		if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
> >  			return;

This type check was added as part of the split of the rdt_domain
structure into sepaarte ctrl and mon structures. I think the concern
was that some code might look at the wrong rdt_resource list and
try to operate on a ctrl domain structure that is actually a mon
structure (or vice versa). This felt like a real possibility.

Extending this to save and check the resource id seemed like a
natural extension at the time. But I'm starting to doubt the value
of doing so.

For this new check to ever fail we would have to somehow add
a domain for some resource type to a list on a different
rdt_resource structure. I'm struggling to see how such an
error could ever occur. Domains are only added to an rdt_resource
list by one of domain_add_cpu_ctrl() or domain_add_cpu_mon().
But these same functions are the ones to allocate the domain
structure and initialize the "d->hdr.id" field a dozen or so
lines earlier in the function.

Note that I'm not disputing your comments where my patches
are still passing a rdt_l3_mon_domain structure down through
several levels of function calls only to do:

	if (r->rid == RDT_RESOURCE_PERF_PKG)
		return intel_aet_read_event(d->hdr.id, rmid, eventid, val);

revealing that it wasn't an rdt_l3_mon_domain at all!

But these domain_header_is_valid() checks didn't help uncover
that.

Bottom line: I'd like to just keep the "type" check and not
extend to check the resource id.

> >  		d = container_of(hdr, struct rdt_ctrl_domain, hdr);
> >  
> 
> This is quite subtle and not obvious until a few patches later that the
> domain_header_is_valid() is done in preparation for using the
> rdt_domain_hdr::rid to verify that the correct containing structure is
> obtained in a subsequent container_of() call.
> 
> Patch #10 mentions it explicitly: "Add sanity checks where
> container_of() is used to find the surrounding domain structure that
> hdr has the expected type."
>            
> The change above, when combined with later changes, results in
> code like:
> 
> 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
> 		/* handle failure */
> 
> 	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
> 	...
> 
> Considering this all I do not think using a variable r->rid is appropriate
> here. Specifically, if the code has it hardcoded that, for example,
> the containing structure is "struct rdt_l3_mon_domain" then should the
> test not similarly be hardcoded to ensure that rid is RDT_RESOURCE_L3?
> 
> Reinette

-Tony
