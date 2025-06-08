Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657F92A1BA
	for <patches@lists.linux.dev>; Sun,  8 Jun 2025 22:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749420164; cv=none; b=kz+rGS/jFvKq9fFlyEbnjczPiBrLZD+75diz0HR9NEyVGTHMUJTDdHxjWBBgTESC5taAZp9jeUVuBB+5gkEGgnVyuklqyRiGTbdsL2WT/iryLA/+1OALD3D9JIp6b3HYE6rRAEdmP37YkLcF9ztvnZ9BNGXkC2AIOIKa7qytgqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749420164; c=relaxed/simple;
	bh=O9dNT9dMJc0CQjfX6AgO0FGF/8pLldSCs6ftKHmFru8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LHOQjfF+RYt9N/BtGbkm4HJPaBGLoX3+WX8TxYlc1yXwKosFZxfZvHiitbhdyNBssXnOLuNSE72r0s/JWnTzcsTPKKfhEQfu1KbJeaNEVTq2e1RZE2pgK7GV7eM/fyunGc1CPsxndY7A0D9ZnmK6jt0wlQvcVHKdEEvTI5n/vwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FEPDgj7C; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FEPDgj7C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749420163; x=1780956163;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=O9dNT9dMJc0CQjfX6AgO0FGF/8pLldSCs6ftKHmFru8=;
  b=FEPDgj7CHf3yYuK6nH5+CxADa8uOKO1GGbVnVIpqbkSZyuu30XuopSoD
   hW6WVb4wyYQ2+gp7oLaB7NOE9GmRpKSXBQGoLqwQEvYuTdAtXu7jZ67UG
   oel/XV88IIJcrLsWc9qCCsoOKEQxSWTDGXpOIhFjwVTKW8sV2eiUbUZHT
   sI54REabqjxxxkYaeNDObrYf+KIOPbR1zUzUemrgiiAw14/qKgFxs+KFn
   2qaS7dx1LFyAdCxrLY3DeqBQtwnTkZJbeigc5jBNee2ufY7xwXPENcmjP
   nAm9xUXS9jsfS7WKWGAirmdERWoRwdLQX09ccXZluqEayAxoi6w0Sj8EU
   g==;
X-CSE-ConnectionGUID: 0oWc6jg2QVGYET4jki+FOA==
X-CSE-MsgGUID: /c95u+WqSOavCdiHC8/GYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11458"; a="61761037"
X-IronPort-AV: E=Sophos;i="6.16,221,1744095600"; 
   d="scan'208";a="61761037"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2025 15:02:42 -0700
X-CSE-ConnectionGUID: L4klLxCwTEqlbWXUbW1GUw==
X-CSE-MsgGUID: rOLmuoT9RyiqgzFR52QV5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,221,1744095600"; 
   d="scan'208";a="183532699"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2025 15:02:41 -0700
Date: Sun, 8 Jun 2025 15:02:40 -0700
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
Subject: Re: [PATCH v5 10/29] x86/resctrl: Change generic domain functions to
 use struct rdt_domain_hdr
Message-ID: <aEYIgMqU5i7YqTbX@agluck-desk3>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-11-tony.luck@intel.com>
 <ccb22f13-c717-478d-ab0f-ab4fbb0a8862@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccb22f13-c717-478d-ab0f-ab4fbb0a8862@nvidia.com>

On Fri, Jun 06, 2025 at 05:52:16PM -0700, Fenghua Yu wrote:
> > -void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
> > +void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
> >   {
> > +	struct rdt_mon_domain *d;
> > +
> >   	mutex_lock(&rdtgroup_mutex);
> >   	/*
> > @@ -4039,11 +4065,15 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
> >   	 * per domain monitor data directories.
> >   	 */
> >   	if (resctrl_mounted && resctrl_arch_mon_capable())
> > -		rmdir_mondata_subdir_allrdtgrp(r, d);
> > +		rmdir_mondata_subdir_allrdtgrp(r, hdr);
> >   	if (r->rid != RDT_RESOURCE_L3)
> >   		goto done;
> > +	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
> > +		return;
> 
> rdtgroup_mutex is being locked right now. Cannot return without unlocking
> it.
> 
> s/return;/goto done;/

Yup. Though "goto out_unlock" to meet resctrl style of more meaningful
goto label names.

Thanks

-Tony
