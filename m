Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4309B157A5B
	for <patches@lists.linux.dev>; Wed, 26 Jun 2024 19:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719430504; cv=none; b=sPYuQjwnlkz6ibT1XdZ6XBiT5w0TBZzoA5clcKpxwtedwpoAbP+ElSQbzkrg/aRsyYVHDxmY6njksm9TQVWaJ9FRjfbS6vn48AIxI8TlMlz0AM1+2tcWYK9/mzVdCzQsLfZOUewK2CfvLLfzxXLkMZVK52e5yJVRhw1df7hzcdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719430504; c=relaxed/simple;
	bh=2beignGpCuAM6dT9gqJC6vOcvoJjdAklESkq76GPHFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h0wEg2lQH4H7LHlzSdpTOaEvpQyWl+Ei6JfNWIfN1EkBUOG6rYSNi+2VcFzsdtBW4kH7MXKc7q6ypqbaYnY/xBadCg4JG2K4tpG5cOKvPMm+cgVjzdJKlMkiRwOgfLDVqyCDLHHU9aGvEc05l6/AvXfwaIfVyRnMLu1pUkI6GRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XZhapUp7; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XZhapUp7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719430503; x=1750966503;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2beignGpCuAM6dT9gqJC6vOcvoJjdAklESkq76GPHFI=;
  b=XZhapUp79khBk6Buic4812/DHQohHKQG2M/iz5Sji2kn1euRUFA/OR4/
   Af/Qa1Y/LbY9EHP7nwXTF0J7Ji+k5mDzalnB/9/H0GmjkajUvSptcePdy
   FWkhtu8DQP0vtUJtpqUHMSgpu9K6Lls2d+AZKgPRTbDrogQ1tnMpV4wrT
   6HsN9ouVl5Ed4TH1OB/Fv8huq5N5H6mXLu1JGUc+J6hdn5iKFxEWz24mi
   WZpY5fFtZqqxeH4M6VS0NZkRU2JQimcoGwSL2eJ52M/BVbrFN11BnSv9p
   puMuFl1Ra/9dMzlcyynjhewhmgyiIgTTmKANxhfX4oodfR9f304Y84qu6
   w==;
X-CSE-ConnectionGUID: pOpwX6f9TkuNv4urFIfftA==
X-CSE-MsgGUID: wFTrUcgITS+XArSTqJpPsw==
X-IronPort-AV: E=McAfee;i="6700,10204,11115"; a="16661738"
X-IronPort-AV: E=Sophos;i="6.08,267,1712646000"; 
   d="scan'208";a="16661738"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2024 12:35:03 -0700
X-CSE-ConnectionGUID: 5Dd8HUxSR/2Y1DtuOGaSfw==
X-CSE-MsgGUID: t63qcv8+Traa9Y/7WQeIFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,267,1712646000"; 
   d="scan'208";a="49076676"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2024 12:35:03 -0700
Date: Wed, 26 Jun 2024 12:35:01 -0700
From: Tony Luck <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v21 14/18] x86/resctrl: Fill out rmid_read structure for
 smp_call*() to read a counter
Message-ID: <ZnxtZc140S11gFKL@agluck-desk3.sc.intel.com>
References: <20240621223859.43471-1-tony.luck@intel.com>
 <20240621223859.43471-15-tony.luck@intel.com>
 <8df55906-23b1-4772-ab11-703da64d5ebb@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8df55906-23b1-4772-ab11-703da64d5ebb@intel.com>

> > diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> > index ff4e74594a19..877d898e8fd0 100644
> > --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> > +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> > @@ -785,6 +785,7 @@ static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
> >   	rr.first = false;
> >   	rr.r = r;
> >   	rr.d = d;
> > +	rr.ci = NULL;
> 
> This keeps using a struct rmid_read with random data from stack and initialize members based on
> knowledge about how the called functions use this struct. Could you please add initialization to
> all these places that use struct rmid_read with whatever is on the stack? This includes
> mon_add_all_files() introduced in this series.
> Something like below should do (in mon_add_all_files() - done as part of patch 10, mbm_update(),
> and mon_add_all_files():
> 	struct rmid_read rr = {0};

I'm making that change to the three places that struct rmid_read
is defined as a local variable.

Should I also remove "useless" assignments now that the structure
is zeroed by the compiler. I.e. in the above snip the rr.first = false;
and rr.ci = NULL;

I suspect there are others.

Or do they serve as useful hints to human readers of the code?

-Tony
