Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2B438C400
	for <patches@lists.linux.dev>; Mon,  6 Apr 2026 18:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775498840; cv=none; b=KTGFdwL813SJbmbePd5tYmq8E9R/+lVr6EYp8RVNmcPlgm5le95Y0Yrsy1wsHHzzgkhZ3q1bxkRYCOrWcOfkQPXaGoaj7LldbGTT8/ow0Xei3oqiVNGpssbSBkec3j1gfmO4R5sgD3BtK/ABDD9voNY2GZ7doFj5MawgJfc8trQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775498840; c=relaxed/simple;
	bh=F8PlIRhzyHtJKS7UI2wcrWjEJO7KvCE+P0kBXuh8O8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mKnPSAbxPFADIRp71QC9BZf+k2YGRCZx/NiUPuRb9nS6SSCXsSnsMTLhvlZ3xO+3c7Pbp6Bx+tmxGp2v5xikEZNM3QIFreawuXrRXuYNXhJhu14oKzJy6CHJuVpugFa5Kdw0JwnArPQZ9AF+MV5jaq6c3x8YqKQ+9oSh79+wpho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dZa7XGw3; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dZa7XGw3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775498839; x=1807034839;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F8PlIRhzyHtJKS7UI2wcrWjEJO7KvCE+P0kBXuh8O8E=;
  b=dZa7XGw3afyRPuVeUWWcKYel8YF/zAwU+Jg62sxVsUlCZassNmDg5Py2
   76Cnc6g4pOKdnfm4n3YPiaQUwLvUPO7vpRdjB6fJucm+OQZaxMRL+aD2U
   GpNN/oFzTO7wxC36+h1Chz5ztM6qCpgeZZXD7RSwAbjFVGfO/11zykdK7
   5X2hwNQbiRuaejXg3D257uAZWRzqKwo/lDUwBlIXso5Oa3WL33NG5EN8S
   98a8EfaDNTWFE0x9YKUDhyMjGY19u6s+l8sAEqnQiXQH0zFMCWDWN+eB8
   /GUwREoYf3W2rrvFZaN5jSa1USUyjP+NzF7HDmS0CvJ0JGnMtDz7FLgrc
   w==;
X-CSE-ConnectionGUID: n3ZlZJxhS5KpYwZThCOuFQ==
X-CSE-MsgGUID: Feq5HDhUSdOlHEideBUbog==
X-IronPort-AV: E=McAfee;i="6800,10657,11751"; a="76574904"
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="76574904"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 11:07:19 -0700
X-CSE-ConnectionGUID: ipqvhWDzSd+EvgtG70w6xg==
X-CSE-MsgGUID: aUXkT0MPQi23l0j00z5NvA==
X-ExtLoop1: 1
Received: from debox1-desk4.jf.intel.com (HELO localhost) ([10.88.27.138])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 11:07:18 -0700
Date: Mon, 6 Apr 2026 11:07:17 -0700
From: David Box <david.e.box@linux.intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>, 
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, 
	Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, 
	David E Box <david.e.box@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Subject: Re: [PATCH v4 1/7] platform/x86/intel/pmt: Export PMT enumeration
 functions as GPL
Message-ID: <2nxmhhbxjqnljbxbqzwhh4rxfrh7opak2q65k3guyisf4nznk5@jbrec5xhd4y4>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-2-tony.luck@intel.com>
 <6fdc6275-c898-4b97-a702-8eb66e5f38dc@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6fdc6275-c898-4b97-a702-8eb66e5f38dc@intel.com>

On Fri, Apr 03, 2026 at 05:00:05PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 3/30/26 2:43 PM, Tony Luck wrote:
> > The symbol_get() function requires that objects be GPL licensed.
> 
> I do not know if this cryptic note is sufficient for the driver's maintainers.
> Looking at the dependencies among symbols it does look possible to add more
> context here that makes it clear that this is the right and obvious thing to do
> for this driver. Doing so makes inclusion of this change just a formality. If
> it is not the right and obvious thing to do then I similarly expect a better
> motivation than some planned usage since any planned usage may cause a debate
> about whether it should be supported.
> 
> Reinette

Tony,

Something along the lines of this would make it clearer:

"Prepare PMT enumeration interfaces for GPL-only users by converting
intel_pmt_get_regions_by_feature() and intel_pmt_put_feature_group() to
EXPORT_SYMBOL_GPL(). This enables future users of these interfaces to
access them via symbol_get(), which requires GPL-exported symbols."

With that clarification, this looks good to me.

Acked-by: David E. Box <david.e.box@linux.intel.com>
