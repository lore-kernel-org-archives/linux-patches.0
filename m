Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6BF2264B0
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 18:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752084766; cv=none; b=kGyO0b18NwU4PE2jc5mVQmgrysB1cwL1iS+WvUsiw42TUgDYjTtqHAxIrCYUoMZAyPIs0LADqBUNcm9P8Yb2RUD6LYI0qCCCNZWQ+fUWVkj21f/InM7VfZo5YUgrrNwJZEq8bYxtvKOnvG1ASZ21kEx1BG8lvrrH+UMvPju7h/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752084766; c=relaxed/simple;
	bh=ZGKG7E1vpbJmu+R+ZP5tg4O6G4wQmSXGehTcEDAAtXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dosrjiHQROGvfepmXW+ZoMT1VR//5dkr00sx/DNErCbtGPkpwiinIoWwUbi9o6qIMuDNLXWLKIYJZtXtEkMV1SZ2/4skGSw3jnJ8LCsUU9GAtAT7Y2n64sa8C3ac668fad6DGGrsq8HqJg0/hdQNks/rkLwkaAPji8P01Ng/+aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RhoyAJ2m; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RhoyAJ2m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752084765; x=1783620765;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZGKG7E1vpbJmu+R+ZP5tg4O6G4wQmSXGehTcEDAAtXQ=;
  b=RhoyAJ2mpulGhQFhjOiFFeLdjm1XlrR21xpRxaG1aFYInRHElF6DANS3
   +WSXwM/ZSHM5DdnUiow+8qxOeI0P8o4r1G7s8d6TENVHlREAdigLl9cKO
   Mx50c61QDyta6+98ZThOALF9a/TlUuWTOQTG3OLU7eLtL0FCrzXzgb1EM
   yfTWIKEr7xrNeNcOmnnRZ0ZmSerbq6XUgzQyqwLmmUkDA7LeOevSh7pN4
   //NU43kO2DDMFC9PqXky6YhkAj4tCqyK3M07xUonIusYUdPh3xsOFTbtv
   vsEPglAJD4gKUcWN6WezDiq13u+ZktWmtytN9HciBxYktfBNj1VFsG+ZV
   A==;
X-CSE-ConnectionGUID: IuuOiek1Tz2Zb5dlku3fbw==
X-CSE-MsgGUID: pbAk6rYKSCiOB3ai6FHDCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="64935872"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="64935872"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 11:12:42 -0700
X-CSE-ConnectionGUID: RQko7YZZR/auVI5oMgTCCg==
X-CSE-MsgGUID: B8lXHw/QSR6tq5xCXq+HIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="159869615"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 11:12:41 -0700
Date: Wed, 9 Jul 2025 11:12:40 -0700
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
Subject: Re: [PATCH v6 18/30] x86/resctrl: Count valid telemetry aggregators
 per package
Message-ID: <aG6xGGiOy3xKL-t4@agluck-desk3>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-19-tony.luck@intel.com>
 <69f18b65-4e20-4383-a559-46fe1eda7db0@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69f18b65-4e20-4383-a559-46fe1eda7db0@intel.com>

On Tue, Jul 08, 2025 at 07:20:35PM -0700, Reinette Chatre wrote:
> As I understand there is 1:1 relationship between struct event_group and struct pmt_feature_group.
> It thus seems unnecessary to loop through all the telemetry regions of a struct pmt_feature_group
> if it is known to not be associated with the "event group"?
> Could it be helpful to add a new (hardcoded) event_group::id that is of type enum pmt_feature_id
> that can be used to ensure that only relevant struct pmt_feature_group is used to discover events
> for a particular struct event_group?
> 
> Another consideration is that this implementation seems to require that guids are unique across
> all telemetry regions of all RMID telemetry features, is this guaranteed?

The guids are unique. The XML file tags them like this:

	<TELEM:uniqueid>26557651</TELEM:uniqueid>

the "guid" naming of the value comes from the Intel PMT_DISCOVERY driver.

An alternative to adding the new event_group::id field would be to
separate the arrays of known event groups. I.e. change from:

static struct event_group *known_event_groups[] = {
        &energy_0x26696143,
        &perf_0x26557651,
};

to

static struct event_group *known_energy_event_groups[] = {
        &energy_0x26696143,
};

static struct event_group *known_perf_event_groups[] = {
        &perf_0x26557651,
};

then only scan the appropriate array that matches the
enum pmt_feature_id passed to get_pmt_feature().


With only one option in each array today this looks
like extra infrasctruture. But I already have a patch
for the next generation system that adds another guid.

-Tony

