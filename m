Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D90A19F40F
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 16:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749054802; cv=none; b=ZcSV8Hk0Mb+4sexC+6gWhVY1QKxbGB8Bp68UGH5WmxcvlpgYR+iygc0T4A14+dwHrNYbSFM4cdDRu9/surrOwSU31xHdjRelSW9vtfviPolrCdXMmBV0ROF5FvR8M+1ALTkqIRpdC19c1yW0rNcaGDQ+wD3jDAZKauec5+zJJH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749054802; c=relaxed/simple;
	bh=m8wrsrYetnFPXLpdb3LHDq6bHI0VFrmQjNBUVQzBUvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gmNekDkSWVnEqXAAqxQRW+Ogjz24s3ZY1tP+tuCYYwiAdH3swM5Gn/0pxSqxpfFNTl/WrV12tCcFQvEczwPPbiG5RXOnHmboaG9ZFow+KgZ8AXdxn0YD0Z1XRv1M41B0Da/Xo7GOuLhufKDiBbXUgjlaqkpOAKGhgTSryjoDx0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hb49oWMK; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hb49oWMK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749054801; x=1780590801;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=m8wrsrYetnFPXLpdb3LHDq6bHI0VFrmQjNBUVQzBUvg=;
  b=Hb49oWMK5dfGQZIBjX8PLvk+02V7oNqY8GFovpGJCCgoi87JD9iAa3CC
   p/dc2Z3YoxKXdM3WkpkrybclXlGNAJLLRBUR+zmBZvoyDFy1nL1TUItUy
   07jw//27cw4sgQSd/sX0OlSlpTczTByIDAufr/aHJb5IMy4njtvRF/M/r
   QmYFh5nBb5DaAMl01seL9IlTG9jQ9Ie29dTXJZPioxw6C8cMnwNf6btKS
   EqHH5s9S1RDB7xj+4tPpSd+cWoQKpo/asZObONFxO+If0XSMnMNDMKUzl
   x32UE/qyLusbGUSbseBBCKOmBXf2oxdsxN08bDmTshEEpRC66gCj8WHkN
   Q==;
X-CSE-ConnectionGUID: rAjGg8+jTtWVT+c0rBso9w==
X-CSE-MsgGUID: FwxIUwFgSE6YDivb6NgJPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="61412245"
X-IronPort-AV: E=Sophos;i="6.16,209,1744095600"; 
   d="scan'208";a="61412245"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 09:33:20 -0700
X-CSE-ConnectionGUID: n0iGB6tNQqK0vyV181+V/g==
X-CSE-MsgGUID: DcL2yp/LRBqedDGBaK+8Rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,209,1744095600"; 
   d="scan'208";a="150121986"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 09:33:20 -0700
Date: Wed, 4 Jun 2025 09:33:19 -0700
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
Subject: Re: [PATCH v5 01/29] x86,fs/resctrl: Consolidate monitor event
 descriptions
Message-ID: <aEB1T0GFqLl6RG22@agluck-desk3>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-2-tony.luck@intel.com>
 <7eec0d2a-457a-42c7-904d-2c85633dc2a3@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7eec0d2a-457a-42c7-904d-2c85633dc2a3@intel.com>

On Tue, Jun 03, 2025 at 08:25:56PM -0700, Reinette Chatre wrote:
> Hi Tony,
> > +void resctrl_enable_mon_event(enum resctrl_event_id evtid);
> > +
> >  bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt);
> 
> nit: When code is consistent in name use it is easier to read. 
> Above there is already resctrl_arch_is_evt_configurable() that uses "evt"
> as parameter name so naming the new parameter "evt" instead of "evtid"
> will be much easier on the eye to make clear that this is the "same thing".
> Also later, when resctrl_is_mbm_event() is moved it will be clean to have
> it also use "evt" as parameter name and not end up with three different
> "evtid", "evt",  and "e" for these related functions.

Should I also clean up existing muddled naming?  Upstream has the
following names for parameters and local variables of type enum
resctrl_event_id (counts for number of occurrences of each):

      6 eventid
      2 evt
      1 evt_id
      3 evtid
      2 mba_mbps_default_event
      1 mba_mbps_event

It seems that "eventid" is the most popular of existing uses.

Also seems the most descriptive.

Perhaps "mevt" would be a good standard choice for "struct mon_evt *mevt"?
Upstream uses this three times, but I add some extra using "*evt".

-Tony
