Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AF62A1BA
	for <patches@lists.linux.dev>; Sun,  8 Jun 2025 21:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749419533; cv=none; b=quLaKWIoVaR1Vdf+jk4NTrz3c6BWO+HNdsKvFVJVrorP9Akzyqf1+uEOokbY8BMJMRE7kNLxOJ3U31QNpCkB/e8CuKxz1s4zOpo0qDD4+fW+LDCjohkrYZIiRU3ISGtT/4XNU4VGQydKN2QdFrouRteQi5K8GDySsiFVz0vpuKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749419533; c=relaxed/simple;
	bh=/9w5UOSQHneQRj9Eh0j4t7bPnLEd4c1v15Iq2gRYH30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R8Ynu/RMVqTgqblw1F3jAoZVHis09oPNGhtGHj6YOtUbSJrqXIquY4LgOQA7aeEcWe99ROany6FHtiU0WoBvi6ibRPUEzw10K04R91z+1RDPzGOpiuZaB6GGMXGPa10hkBcd6lbT5dbc8IP3ZEUPqs/2urWCV6aYE/Zf/Dqwrg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bzrm9TV1; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bzrm9TV1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749419531; x=1780955531;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/9w5UOSQHneQRj9Eh0j4t7bPnLEd4c1v15Iq2gRYH30=;
  b=bzrm9TV1qp/M6prEZZsXoYU6dmhNqeAXLA1r+08ol2Mm3zO5xTywAS7a
   ly3Hd6azNgNp1BWSmnlTob5/8PZA9KKAhPK6LkZ633IdB/JtJv1+0jXJE
   6OC65UTDrqo2Y/j8Pz1oxELPxLf3ZomhqmMosvrK+S7L30IIup9MnXjGU
   P/F60Q3NqfI57XfDUaI0kfIhYWSalo1X7dZhjmS+QkyMaaAFYNBFTVEgo
   bi3kSJc/gdsJfnQFkhTc5qPLNVOtT+4++ZjJ8D/fLok8EINDVvkkaVhsD
   HylkWP5aRpAuHSaaMZ7J+OPaic+5SlR7MCp/3Iof+COrOtK+HfOZ4nhBC
   A==;
X-CSE-ConnectionGUID: pl8zVJyzSROIbttuTMpUNg==
X-CSE-MsgGUID: qIH0zkaURfiu+cYKsoFu8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11458"; a="51636565"
X-IronPort-AV: E=Sophos;i="6.16,221,1744095600"; 
   d="scan'208";a="51636565"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2025 14:52:11 -0700
X-CSE-ConnectionGUID: 61L1dikVQcyhvR6HVU1iXQ==
X-CSE-MsgGUID: Q3aIPz0OQTmXJGFpys1+pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,221,1744095600"; 
   d="scan'208";a="147273711"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2025 14:52:11 -0700
Date: Sun, 8 Jun 2025 14:52:09 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v5 24/29] x86/resctrl: Add energy/perf choices to rdt
 boot option
Message-ID: <aEYGCUuKS8_MDorA@agluck-desk3>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-25-tony.luck@intel.com>
 <f963081e-9cbb-4d8e-b978-b6092394a330@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f963081e-9cbb-4d8e-b978-b6092394a330@nvidia.com>

On Fri, Jun 06, 2025 at 04:55:37PM -0700, Fenghua Yu wrote:
> Hi, Tony,
> 
> On 5/21/25 15:50, Tony Luck wrote:
> > Users may want to force either of the telemetry features on
> > (in the case where they are disabled due to erratum) or off
> > (in the case that a limited number of RMIDs for a telemetry
> > feature reduces the number of monitor groups that can be
> > created.)

[SNIP]

> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index f07f5b58639a..b23309566500 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -797,6 +797,8 @@ enum {
> >   	RDT_FLAG_MBA,
> >   	RDT_FLAG_SMBA,
> >   	RDT_FLAG_BMEC,
> > +	RDT_FLAG_ENERGY,
> > +	RDT_FLAG_PERF,
> >   };
> >   #define RDT_OPT(idx, n, f)	\
> > @@ -822,6 +824,8 @@ static struct rdt_options rdt_options[]  __ro_after_init = {
> >   	RDT_OPT(RDT_FLAG_MBA,	    "mba",	X86_FEATURE_MBA),
> >   	RDT_OPT(RDT_FLAG_SMBA,	    "smba",	X86_FEATURE_SMBA),
> >   	RDT_OPT(RDT_FLAG_BMEC,	    "bmec",	X86_FEATURE_BMEC),
> > +	RDT_OPT(RDT_FLAG_ENERGY,    "energy",	0),
> > +	RDT_OPT(RDT_FLAG_PERF,	    "perf",	0),
> 
> Boot options "energy" and "perf" are PMT event groups level. Other boot
> options are individual event level.
> 
> E.g. "!perf" forces off all 7 PMT PERF events.
> 
> e.g. "uops retired" event has an erratum but all other PERF events work
> fine. Disabling "perf" group disables all PERF events. Is "!perf" a useful
> boot option?
> 
> Is there any consideration to have boot options at PMT event group level
> instead of individual PMT event level like legacy events?

This could be done. But it would add some complexity that may never
be needed. I'm optimisitic that all events in a group will work.

> 
> [SNIP]
> 
> Thanks.
> 
> -Fenghua
> 
