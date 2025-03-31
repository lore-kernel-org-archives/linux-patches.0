Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0D9211A0D
	for <patches@lists.linux.dev>; Mon, 31 Mar 2025 21:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743455692; cv=none; b=QfEsAip/liG92kaabBUIbnjXqpMyVgUyNPY0KGDx0AJ8zD+f4N+CatU52TVaguvbhFtoIL3lak9cdGLJ307W31licOxWDL+Mdmf5D7mgqztr1eOZKAyaaD6dD7s5ZZ8qEdDksM2IQIj7VgWO3D16efr/hF2iHrEEuXsPtvWCZaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743455692; c=relaxed/simple;
	bh=wT9+Ex6zt8/02+6UehiAPV2rdCeodJx9xoDbISkZITM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R0czkf8xOA6pWAal4t8ZcWt592iNZMrZair7eK4LQwPFKSPUR9AcuLDnwRKmyEo7FUimUc4ndCQnr9ndX2HU3N0uF6gCtuZ/62jfPHoVJTia2dytyvSrMRYzLaalrOwfu/Zbk6FvlY9NhNNGqRSFRRhOxz2uhRxGsZ3KkN/gNfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N0kkbmGb; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N0kkbmGb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743455691; x=1774991691;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wT9+Ex6zt8/02+6UehiAPV2rdCeodJx9xoDbISkZITM=;
  b=N0kkbmGbzd7fyXwYYsQoIwdYlv0MaLWtHwCfMqYDQa0ydEZkgjZPPEWd
   qaZPwWp/TWKDO65FUn3JtCx5/oJIvkDUw2qxEnG+GmDOW5q/5HgCxwyyG
   44GS1OdMb7P1+98PIY/IYE72cLnkHBo0ymUxTgNdQsnpFBXRYdkf9e9J6
   i1UYSFacWSQ0jmKCZeebXrOt6DZ0USz9pFxFr+mwa6ungiaUdZaBznVyq
   DWYF9td79m+5Ozi1vufoiF8n2/wawm5/lzmi9XGfXhPeFWS8TDsNtjcC0
   l6+LRwgAHfRP+7LZN9EB9e9/Xkn2yZbawFGnFVrO1io6x5K6Vsd1Y4jvW
   A==;
X-CSE-ConnectionGUID: s/OuwheGSueRO+NunT9mkg==
X-CSE-MsgGUID: 4WonZewTS+yL03h6MI1BiQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="44890316"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="44890316"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 14:14:51 -0700
X-CSE-ConnectionGUID: zY54K0f1TVC2AhIJ/Bb1dg==
X-CSE-MsgGUID: bM/hvU5MRt2lF7PHi6cEew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="130305243"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 14:14:50 -0700
Date: Mon, 31 Mar 2025 14:14:49 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 04/16] x86/resctrl: Change generic monitor functions
 to use struct rdt_domain_hdr
Message-ID: <Z-sFyQBsGgKFAVGn@agluck-desk3>
References: <20250321231609.57418-1-tony.luck@intel.com>
 <20250321231609.57418-5-tony.luck@intel.com>
 <012377fd-e292-42fc-b348-4bb5e5becb97@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <012377fd-e292-42fc-b348-4bb5e5becb97@intel.com>

On Mon, Mar 31, 2025 at 09:15:36AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 3/21/25 4:15 PM, Tony Luck wrote:
> > Functions that don't need the internal details of the rdt_mon_domain
> > can operate on just the rdt_domain_hdr.
> 
> This does not seem accurate. The functions are modified to take rdt_domain_hdr
> as parameter but then the functions are modified to extract rdt_mon_domain
> based on rdt_domain_hdr .... and proceeds to operate on internals of
> rdt_mon_domain in a way that contradicts the changelog.
> 
> Considering what comes later this seems risky to me to rely on the
> code flow to interpret which structure rdt_domain_hdr forms part of. I think
> that it will be safer if rdt_domain_hdr gets an identifier that reflects which
> structure it forms part of so that the accessors could be made explicit and
> have error checking.

This needs some more thought and cleanup. I ended up with a mix of
places that really just wanted the header. E.g. adding second and subsequent
CPUs to a domain, or deleting any but the last CPU from a domain, only
need to update the cpu_mask. But other places end up clumsily using
container_of() to get to the surrounding mon_domain. With different
types of mon_domain a type field would help sanity checking.
> 
> Reinette

-Tony
