Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B837CBA2E
	for <patches@lists.linux.dev>; Tue,  1 Apr 2025 00:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743466932; cv=none; b=cbXUvNiLSq8Hu2R7nBPBpkyfsu7gL3AEZFJKJnBgSM4gEwmUnd0qt86ltTU/5eQTurLYWuxe5ZbxPsMKpZ4es0NQNYrmxUO/jD6my1JoswlmcETpT94Cu4y688UdgLqV2LeHoOUPTo/MMjWgZgwML9Keo8b7lX+pJWYZMnmafp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743466932; c=relaxed/simple;
	bh=wpWKU59KHo+Aek3Z7jbJqO9yr5KqJsTqb01/uswJIqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qcNb0BatoxvIi7ZIxKIndZxO88od6YsJH+bqRaJSDVQiUll+CghBUMLXvJN7OY7YsIFPvj8hlVnbKhPzzFdaXVZAcQTym3INL9XK56dl8ToY8J3joe/PqYEp0nunRHO+oiIV029BX2zWcQnzYOwEYM0dl/IGsIGyHQvxk34Ka8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FtDcGREa; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FtDcGREa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743466931; x=1775002931;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wpWKU59KHo+Aek3Z7jbJqO9yr5KqJsTqb01/uswJIqA=;
  b=FtDcGREayWPa7Ya2MHd37YTow2Gp6R/n1Mi9/+XYCInZyO3bRtmvgmU2
   BLl4MK/Qs7r6+MCcHH5UqYnlJamkrkQ4/oou/pXV79PAm/SkqMiRLhbHi
   WdO9J6knjW2vPzqws8fGEZjgdUc2MgnFr8YbTUTCBqgjAhXgjOBZPNNyU
   T4Z5aOpWALnJsVarHmprhz9+QoOqu2RxeKIBPyixKD7+0UZzXcITkO0U0
   8s0xYqIbtpI6pj4WwEKaX9Jfp7Kz69G8XTRK9WDSPd9Wz8vYYZ0UuJOkB
   89dH/Sye+hi+mv8XQUwa3fdX+ekBp4PFGfOallNt4QkN72eOzP3zKhm6P
   w==;
X-CSE-ConnectionGUID: e1iRnJ47Tx+4yv3pJW4vzw==
X-CSE-MsgGUID: az5mivwTQRKJ0ytZ4A9ewg==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="44657633"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="44657633"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 17:22:10 -0700
X-CSE-ConnectionGUID: yhbU/9+0T1y8XkTFAI6l8w==
X-CSE-MsgGUID: f/NGGToTSwaylWmPsd4V7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="126127270"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 17:22:10 -0700
Date: Mon, 31 Mar 2025 17:22:08 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 10/16] x86/resctrl: Allocate per-package structures
 for known events
Message-ID: <Z-sxsHMF6xvR19wq@agluck-desk3>
References: <20250321231609.57418-1-tony.luck@intel.com>
 <20250321231609.57418-11-tony.luck@intel.com>
 <cbd8198d-467b-456e-b329-baf6ac5cff82@intel.com>
 <Z-sV98FdOH4PNQQo@agluck-desk3>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-sV98FdOH4PNQQo@agluck-desk3>

On Mon, Mar 31, 2025 at 03:23:53PM -0700, Luck, Tony wrote:
> On Mon, Mar 31, 2025 at 09:21:49AM -0700, Reinette Chatre wrote:
> > include/linux/cleanup.h has this to say about mixing goto and free helpers:
> > "convert all resources that need a "goto" cleanup to scope-based cleanup, or convert
> > none of them"
> 
> Seems an awkward restriction for this case. "pkg" is a pointer to
> a dynamic array, and each of the elements of the array might have
> been initialized by another allocation. "pkg" is under control of
> the __free() cleanup function.
> 
> Maybe I could define a custom cleanup (syntax of multi-statement
> action to be figured out):
> 
> DEFINE_FREE(pkg_free, struct pkg_info *,
> 	if (_T)
> 		for (int i = 0; i < num_pkgs; i++)
> 			kfree(_T[i].regions);
> 	kfree(_T)
> )
> 
> 	struct pkg_info *pkg __free(pkg_free) = NULL;

Tried this out and it works (without any odd syntax for the multi-line
action (though I did miss that num_pkgs was a local variable, thankfully
simply initialized from topology_max_packages().


DEFINE_FREE(free_pkg_info, struct pkg_info *,				\
	if (_T)								\
		for (int i = 0; i < topology_max_packages(); i++)	\
			kfree(_T[i].regions);				\
	kfree(_T))

...

	struct pkg_info *pkg __free(free_pkg_info) = NULL;


-Tony
