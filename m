Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF021C303A
	for <patches@lists.linux.dev>; Thu, 21 Nov 2024 17:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732210937; cv=none; b=UfcmWkf/5MaNRDAvY4BDmwzfYE4+s5vGv8nN4KIGI6wQ/nbUdomUSLLZK5UXX8+p3FUZ6+C1MXPlje7Ag2t/w7HuzUwx5eF3RS2aFjy45C6CA8j6D/aGPn7dBCw048SZ6e7bTaLaFNPp39Y0H/PCVxjC5mAtK2F/KrWTJvmS8JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732210937; c=relaxed/simple;
	bh=jOFQHTKYUkPfNsXrd9VoXZV858hzfj/YVhEOk2Y5duU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bLZn482TMvSGLZBSzFoVK/0cfyO9auCFN+dk1pAsB85/IEy6Q3VpyebQwChPJzs149z5J0OqQZ2uxP0Hrw57bFz7PhKgELmQxWqCEDnAwaGeFwPvwt7r4sqVjm7qoq1mtDgZ0AElKXiFaY1/pI2maLl5TbJAfw/F7HJelqjJxms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OMevH85j; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OMevH85j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732210936; x=1763746936;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jOFQHTKYUkPfNsXrd9VoXZV858hzfj/YVhEOk2Y5duU=;
  b=OMevH85jAomir2+gqiH2N5qcyAQv8wqhE221jwcp7dsQyp9nSiPB6gxs
   ag/xrD/d8rd/7O1vvWnrI3ZImsw9bfIFWrPoqBuTgVn0lmaiw7P533Uuk
   KWQ0l9ENcuhMXJT/HYoBym4WlP7ii6mQUWTH4FQlQjO8PHg6O1SkeVbok
   eBqwKz1dTp1/GTQICnqrbGXvi7hpViVUVYCoPJI9YiGqrsdPKz/S4mzxT
   WljvSudZO+l4LY07+IxIwzKauwJtfYSneYz+KtFxYUDyjHVrSDbDgQ2r8
   PMmQ9ouCT5iKxalzS5XVAj9Iq8RCkhmiWzjUTpSn2TrCow031y9aYEJ4v
   w==;
X-CSE-ConnectionGUID: RnStNnS+QzezCTokUdTMlA==
X-CSE-MsgGUID: 1/KI0+xuSRye6TV1sEIhZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="43405148"
X-IronPort-AV: E=Sophos;i="6.12,173,1728975600"; 
   d="scan'208";a="43405148"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 09:42:14 -0800
X-CSE-ConnectionGUID: aQY4trkfR3i3hpRXS4MZfg==
X-CSE-MsgGUID: Ao+P2QtZQiKI4tfyTNWfbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,173,1728975600"; 
   d="scan'208";a="90125950"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 09:42:13 -0800
Date: Thu, 21 Nov 2024 09:42:12 -0800
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
Subject: Re: [PATCH v9 6/9] x86/resctrl: Add "mba_MBps_event" file to
 ctrl_mon directories
Message-ID: <Zz9w9FYAqbgu2aOq@agluck-desk3>
References: <20241114001712.80315-1-tony.luck@intel.com>
 <20241114001712.80315-7-tony.luck@intel.com>
 <4796ded1-a988-4038-bdbb-fc9a93da0c55@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4796ded1-a988-4038-bdbb-fc9a93da0c55@intel.com>

On Tue, Nov 19, 2024 at 08:03:06PM -0800, Reinette Chatre wrote:
> Hi Tony,
> 
> On 11/13/24 4:17 PM, Tony Luck wrote:
> > The "mba_MBps" mount option provides an alternate method to
> > control memory bandwidth. Instead of specifying allowable
> > bandwidth as a percentage of maximum possible, the user
> > provides a MiB/s limit value.
> > 
> > Historically the limit was enforced by a feedback loop from
> 
> "Historically the limit was enforced" no history needed since
> this is still the case at the time of this patch.
> 
> > the measure local bandwidth to adjust the memory bandwidth
> > allocation controls.
> 
> I am not sure what is meant by "a feedback loop from the measure
> local bandwidth" (that was copy&pasted to next patch).

Dropped the whole of the "Historically" paragraph.
> 
> > 
> > In preparation to allow the user to pick the memory bandwidth
> > monitoring event used as input to the feedback loop, provide
> > a file in each ctrl_mon group directory that shows the event
> 
> In the documentation the custom is to use CTRL_MON.

Fixed here (and in several other places in the series).

> > currently in use.
> 
> Much better changelog. I think it will help to add a snippet that
> mentions the file is only visible to user space if resctrl
> was mounted with mba_MBps, and thus only visible when mba_sc is
> enabled, and thus reinforcing that this maintains the contract
> that rdtgrp->mba_mbps_event is only accessed when mba_sc is enabled.

Added text to commit message about this file only being visible
when the "mba_MBps" mount option is in use.

> > 
> > Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> 
> Reinette

-Tony
