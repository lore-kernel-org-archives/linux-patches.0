Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6884B165EFC
	for <patches@lists.linux.dev>; Mon, 17 Mar 2025 16:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742229436; cv=none; b=bL09A/O1P8G4Wvbg703+/AV3LRAJBM4UrqRyGJtk5cPOXIaW8tg+W5AU9ktNWL2WQqOc99ESF2w7r3g1SCSi9IJt6YVJe60zX1xJZgO03xleeHsS0LHL0HCoDH669SwWiYsGA8DvqJbaK+Piliu1nqUN9+zINlblyzfdJ+5uGXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742229436; c=relaxed/simple;
	bh=S6I2WavCtsoOuWUc2oZMW7mzzqpQSM5n/x+IPgYbHFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=piot4yb9qD0huoHvM8PmmtTa+vm7rnj2QXs2Qtrs7GTkcAdpbCqs2tFKAC3i/QmL0pwzKUZas6v/xoef2KKkC6XpwQQFRkHvrbMjddekhcERG3/NSDVaL+RB8GCg5MXf2OjHuDA/vRTfG3uzEgk27EMxOs5ArxM7FlJkH9GDfDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dN6e5qID; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dN6e5qID"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742229434; x=1773765434;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=S6I2WavCtsoOuWUc2oZMW7mzzqpQSM5n/x+IPgYbHFE=;
  b=dN6e5qID5fgx94o0b7P/wrDW6vq0UUAb45g6TiJGLgNilFZ29eh51rNx
   PYU/pf8fy3G0g7z8344nnGlWcTlKTywt4MlEo4pTiWcVfh5NVqIPNPNbp
   9LoD/dRRN5opMvhAfR5QY73L9YByKx1GKu0EiJiuKN3nS44TbHsOtmMEH
   aBpkMgpPUct7E4/diftv6tFrCZ0sD+HW8ZzDXKHveEHDV/E2osf56uTJm
   6Sie1jGjuM6ZyNGrl6SaE/qCJdMeJzHt53yr43nIyE4dW16Ng2p6OL0iH
   TTa5TyDAderfW7Aw3ElyQwT1YsvJyw3r/pFs4TNzRPoCnov/DejCAzf6z
   g==;
X-CSE-ConnectionGUID: zxi3haZlR/+mCH1/7oF8RA==
X-CSE-MsgGUID: y1aLkiqDSWeOHQ9cQ5jXkA==
X-IronPort-AV: E=McAfee;i="6700,10204,11376"; a="30916549"
X-IronPort-AV: E=Sophos;i="6.14,254,1736841600"; 
   d="scan'208";a="30916549"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 09:37:13 -0700
X-CSE-ConnectionGUID: A270ThBuSMyycNnywtyPVA==
X-CSE-MsgGUID: jDdGIhg1QGm8sCV4sXP7Yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,254,1736841600"; 
   d="scan'208";a="122487177"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 09:37:13 -0700
Date: Mon, 17 Mar 2025 09:37:12 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: "Moger, Babu" <babu.moger@amd.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] x86/resctrl: Refactor to make adding extra MBM events
 easy
Message-ID: <Z9hPuMV5n_FY02MM@agluck-desk3>
References: <20250314202609.5753-1-tony.luck@intel.com>
 <d4263bf7-9bd1-447f-976c-69fd96d3f204@amd.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4263bf7-9bd1-447f-976c-69fd96d3f204@amd.com>

Hi Babu,

Thanks for taking a look.

On Mon, Mar 17, 2025 at 09:54:59AM -0500, Moger, Babu wrote:
> >  static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
> >  		       u32 closid, u32 rmid)
> >  {
> > +	int evt;
> > +
> >  	/*
> >  	 * This is protected from concurrent reads from user as both
> >  	 * the user and overflow handler hold the global mutex.
> >  	 */
> > -	if (resctrl_arch_is_mbm_total_enabled())
> > -		mbm_update_one_event(r, d, closid, rmid, QOS_L3_MBM_TOTAL_EVENT_ID);
> > -
> > -	if (resctrl_arch_is_mbm_local_enabled())
> > -		mbm_update_one_event(r, d, closid, rmid, QOS_L3_MBM_LOCAL_EVENT_ID);
> > +	for_each_set_bit(evt, &rdt_mon_features, sizeof(rdt_mon_features))
> > +		mbm_update_one_event(r, d, closid, rmid, evt);
> 
> You need a check resctrl_arch_is_mbm_event() here.

Right. This is definitely broken. Needs that check.

> Will that be reason for your hang issue?

Might have. But it isn't my only problem. After fixing this my
kernel dies on a deref NULL.

> > @@ -1075,20 +1062,37 @@ static void dom_data_exit(struct rdt_resource *r)
> >  	mutex_unlock(&rdtgroup_mutex);
> >  }
> >  
> > -static struct mon_evt llc_occupancy_event = {
> > -	.name		= "llc_occupancy",
> > -	.evtid		= QOS_L3_OCCUP_EVENT_ID,
> > +static struct mon_evt all_events[] = {
> 
> There is one empty event here. You may need to make that clear.

Yes. I went with "some wasted space" for code simplicity just
using the bit numbers in rdt_mon_features to index this array.

Also applies to the mbm_states[] field in rdt_mon_domain and
the arch_mbm_states[] array in rdt_hw_mon_domain. The wasted
space could be reclaimed with some macros to convert from
bit numbers to array indices should this patch ever be
considered for inclusion.

-Tony
