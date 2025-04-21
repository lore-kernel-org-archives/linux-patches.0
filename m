Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654D41E6DC5
	for <patches@lists.linux.dev>; Mon, 21 Apr 2025 19:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745264075; cv=none; b=cU91bkw7Hg7XqQCBjX7NgM9PA0YeLCFzGkkibpJQH4i3KDAfpwvnXA/QH9YUX1E3/BHDturWDvaI+xULkqAIjLztf7kreFIS7eMX9299n65H5qzApCK7c0MXGFRBYXWf4IpVylAx+7GcENql9FEe0zfTeqyOBm6qfvCwh7JUbv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745264075; c=relaxed/simple;
	bh=lbCqO4UasLmk0cRcUke/nKG3/+FracWKIg8rPKiVO1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ovmJqMjPRZq/t+ObgRfO2pgNIMPc+iBpOgo8ZQstOjiIZ/StSZJqn4rod/NEPahE/4P985ZGwLpXcddkzTmWKc5i2kdXUaOOt4m98GOCd+li7gGhp2UJoygpmL9Y/RwZERlprFc5GWgTrgYjzDSaqB2K0yFd03Qsg5pN1wGRq3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LMySdXzn; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LMySdXzn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745264074; x=1776800074;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lbCqO4UasLmk0cRcUke/nKG3/+FracWKIg8rPKiVO1Q=;
  b=LMySdXznj1JYV8JtarCwspG1qjo50R5XSBuk/WacgOAXFEgO/8rhONSH
   CmqQ3EwrxQUlI7OwrNp90zFg8C/W0MO+XPORqqFfZX+q7OGXaCs0cme1q
   nVyeK9gHzV6Leiwlq+tUk7JJPNNbJqPOqHvlAJ+b0f5QyrF/TK4MeAXq7
   fURBtCjvtZq/a08wVnv/51C3Zl+u6+u7sDdhNDzYpLuvjet9mVifAhtQy
   EvQ5PM4TrHO2OQoHeA7Fyfoin7JGJHYPEm6/84yGfJm0iN75qVjdRo9y7
   9jdRwtxdIY1DmQGICghUxnWWnYv79qqv9Ec9zL7fXaOMP1rrWCNBkpJsW
   A==;
X-CSE-ConnectionGUID: JTjs9PEKQv2nE4u0fSHwQQ==
X-CSE-MsgGUID: +R74V9ZvR82jv9HBN1pVcg==
X-IronPort-AV: E=McAfee;i="6700,10204,11410"; a="46814033"
X-IronPort-AV: E=Sophos;i="6.15,229,1739865600"; 
   d="scan'208";a="46814033"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2025 12:34:33 -0700
X-CSE-ConnectionGUID: VnxHMjcyTp6Ad91L/0z9Kg==
X-CSE-MsgGUID: LtCNBmc1QO2jb348ucC48w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,229,1739865600"; 
   d="scan'208";a="132350000"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2025 12:34:32 -0700
Date: Mon, 21 Apr 2025 12:34:30 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v3 11/26] fs/resctrl: Add support for additional monitor
 event display formats
Message-ID: <aAadxhaapT_3-W-I@agluck-desk3>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-12-tony.luck@intel.com>
 <4c8da281-fb6a-423a-bf8f-56c9ee45514f@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c8da281-fb6a-423a-bf8f-56c9ee45514f@intel.com>

On Fri, Apr 18, 2025 at 04:02:08PM -0700, Reinette Chatre wrote:
> > +	case EVT_TYPE_U46_18:
> > +		frac = val & FRAC_MASK;
> > +		frac = frac * 1000000;
> > +		frac += 1ul << (NUM_FRAC_BITS - 1);
> 
> Could you please help me understand why above line is needed? Seems like
> shift below will just undo it?
> 
> > +		frac >>= NUM_FRAC_BITS;
> > +		seq_printf(m, "%llu.%06llu\n", val >> NUM_FRAC_BITS, frac);
> > +		break;
> > +	}

The extra addtion is to round the value to nearest decimal supported
value.

E.g. take the case where val == 1 This is a 1 in the 18th binary
place, so the precise decimal representation is:

	1 / 2^18 = 0.000003814697265625

rounding to six decimal places should give: 0.000004

If you run the above code without the small addition you get:

	frac = val & FRAC_MASK; // frac == 1
	frac = frac * 1000000;	// frac == 1000000
	frac >>= NUM_FRAC_BITS;	// frac == 3

So the output with be the truncated, not rounded, 0.000003

The addition will have a "carry bit" in to the upper bits.
That isn't lost when shifting right. The value added is
as if there was a "1" in the 19th binary place.

-Tony
