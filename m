Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FF418DF9D
	for <patches@lists.linux.dev>; Mon, 31 Mar 2025 22:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743458831; cv=none; b=lqERIx792oI1h1uQ/08aJCWMD+0m5cMNB3QyvSy4T11APEiYi5Z3TvO6S01ZCnnCEfFej2XLf+zt5M3pnoDNs3mvcltITvvZCYZDaOGrqxmv93NpXnGbnz0VwzFlsXrnrxw+hRoEAEEGrXcBriaP3YNtBNAdtAGj4e6SryRuJS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743458831; c=relaxed/simple;
	bh=2NqZpCA3qeuwU0Nn4e8zDBI0oTYQyEs2BI14MWKnkM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cu6fz8F6bbGSeIQF7GWAbcB7vqQYI4gsHqntqzhYan1GpZC3Y9QKskkftchjn/YxDUlhY9JZhW7RCIvXdqn2V/3ryDfxqlvnfxWpGymdoy8TyKw98Vu9eehx/y48cx8nq5/T2W1t9Bwm3dAf6Hu0hmTpYJk7+Tfm2s5OOZIA3HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZpYYcTwX; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZpYYcTwX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743458830; x=1774994830;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2NqZpCA3qeuwU0Nn4e8zDBI0oTYQyEs2BI14MWKnkM0=;
  b=ZpYYcTwXPEHiLIZIWHUlsG4lNF/fYpxzYi3Dcy2w4OUzzc6xM+OT4Wxf
   1WsYPyibwf3xb2z148y4NwJY6QJD5R/JoToIHubvjAH6DIq2JimfzTshz
   h1y/nvoc6pIQirBQL/ZhRhaxaFY3GTQgEcYK6lTCBu+ucdVl8+Gu+82Pg
   m3jYsIWlTx5g9SjZwnQKRo7beP8aQnFEXDmdXTBIkCiENhnmDHTj3qbCy
   HwXSf5nqVOg6RB6jfbeoI/R6jiHFzwL7yZuaWUW1egV565CoW0OYKyd5x
   u5GhhHo/8IqNkZrQQKY0eikGoWoDRVg2ThXIh+iXks0d6AnBz4XHhobY7
   g==;
X-CSE-ConnectionGUID: Au9QwuMaQAqSiLCA/Xj7fA==
X-CSE-MsgGUID: oMl2QEGxROOfVWW2Te9Zbg==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="67239070"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="67239070"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 15:07:09 -0700
X-CSE-ConnectionGUID: eZrBjxbxTQaHukq1pM7yDA==
X-CSE-MsgGUID: kFUlYBfGTumyCycU683KiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="126676066"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 15:07:10 -0700
Date: Mon, 31 Mar 2025 15:07:07 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 09/16] x86/resctrl: Add detailed descriptions for
 Clearwater Forest events
Message-ID: <Z-sSC48XsxFrzlVY@agluck-desk3>
References: <20250321231609.57418-1-tony.luck@intel.com>
 <20250321231609.57418-10-tony.luck@intel.com>
 <03f00372-e863-4405-a077-86173e39368c@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03f00372-e863-4405-a077-86173e39368c@intel.com>

On Mon, Mar 31, 2025 at 09:21:11AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 3/21/25 4:15 PM, Tony Luck wrote:
> > There are two event groups one for energy reporting and another
> > for "perf" events.
> > 
> > See the XML description files in https://github.com/intel/Intel-PMT
> > in the xml/CWF/OOBMSM/{RMID-ENERGY,RMID-PERF}/ for the detailed
> > descriptions that were used to derive these descriptions.
> 
> It is unexpected to me that this is made model specific while the
> implementation is built around a guid. What will happen when
> a new system using the same event layout arrives? Will the url
> above be duplicated for this new system's acronym and contain
> duplicate data? How will the resctrl support change? If I understand
> correctly resctrl will not need to be changed but instead the "CWF"
> events will just automatically be used for this new hypothetical
> system? This makes me think that this should not be so CWF specific.

I was told that we might expect to see new guid values to describe
different event register layouts for the same CPU model. The event
aggregators are all firmware driven. So a BIOS update could make changes.

So I've left open the option to add additional structure defintions for
Clearwater Forest with some future firmware update.

If a future processor uses the exact same layout with the same guid value,
then no Linux update would be needed. We'd just have the slight oddity
that a structure named "cwf_*" would match and be used.

Next system to implement these telemetry events has a very different
list of supported events.

> Reinette

-Tony
