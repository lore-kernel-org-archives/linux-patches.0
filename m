Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35D913AC1
	for <patches@lists.linux.dev>; Sun,  8 Jun 2025 22:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749420307; cv=none; b=GLdxbdBm2kceUNCLLG6pM6+T2kfHMyA9F6DTj5CiEDMHNhNYnwngFPTBqg3RYh9O7CoR+atPwKslm72Arf6Z39iAAXkMzHJ81am5rmcWv7jEC2exbxLEPDkUM4eQKjCTNkl+C/tEDOI6kq+3Gs7o/RpYT5rPZ748X6dFb7HeAOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749420307; c=relaxed/simple;
	bh=VFqBlw1ityMj1ZRZZ/8UV2lj+Vl0zY08vGR/qD2MUNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LBBum1LvVTGQpYv/IdEwhyorvuyYopCijQwS959ll1iggEMa2XJAP3Nnob2XYcSWAvP64tLQBQoQDh+VWuxGFO9IFKed5Dc7aJ6oCHCvS1ZlZwJwcZiki/YRlc1h1BQoSvP5JT8EsF6mc/sNA0KCY2+0VRKMaYfOnqWAHbb9eUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C7OKgtEY; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C7OKgtEY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749420306; x=1780956306;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VFqBlw1ityMj1ZRZZ/8UV2lj+Vl0zY08vGR/qD2MUNw=;
  b=C7OKgtEYCydDKSysial9ZjF/TECQEqGL3T4NGz37SGK8cHOdAKN/JZg3
   Hy44FaPqK7L0EV4sDKrtcA0MvVXwibQkplEbDLnRpmMffPaC4zYHzYDwE
   qFaBW2f1vLb6ZIJebXbF9+++4cK5Ygx7tPXl63e5eBeUVZIzC+sdHuYnv
   mO5FOn9DPnhX/5MHFLdP9UQwtgwCxu18AIuQ0XxM018M4W2z4D3KmqAG5
   MsQdNz8jnwUPPx1rJqwGY68PC85mRyAPoRKv7fX8isfViqqwy7V82hXYc
   DDnbCh0AUiwwHVH5JWcj1OEmekFMaIxBqBDnChUzeAd/dmRd3q8W/IAaG
   g==;
X-CSE-ConnectionGUID: Y8UEl6JgT6Sdz1pPY5OMJw==
X-CSE-MsgGUID: N/8wDuraQdWbVrhiiV5Q4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11458"; a="61761086"
X-IronPort-AV: E=Sophos;i="6.16,221,1744095600"; 
   d="scan'208";a="61761086"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2025 15:05:06 -0700
X-CSE-ConnectionGUID: 61Lci9KwTjG1IDwwkLJqAA==
X-CSE-MsgGUID: V17FTmdJS/yzI5qwFKaxiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,221,1744095600"; 
   d="scan'208";a="183533038"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2025 15:05:04 -0700
Date: Sun, 8 Jun 2025 15:05:03 -0700
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
Subject: Re: [PATCH v5 20/29] x86,fs/resctrl: Fill in details of Clearwater
 Forest events
Message-ID: <aEYJD8OUis3O1Tdd@agluck-desk3>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-21-tony.luck@intel.com>
 <68782596-4e0a-429a-9456-e535faadf465@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68782596-4e0a-429a-9456-e535faadf465@nvidia.com>

On Fri, Jun 06, 2025 at 05:57:09PM -0700, Fenghua Yu wrote:
> > @@ -60,6 +78,11 @@ struct event_group {
> >   static struct event_group energy_0x26696143 = {
> >   	.guid		= 0x26696143,
> >   	.mmio_size	= (576 * 2 + 3) * 8,
> > +	.num_events	= 2,
> > +	.evts				= {
> Please align the "=" with the above "=".

Fixed.

> > +		EVT(PMT_EVENT_ENERGY, 0, 18),
> > +		EVT(PMT_EVENT_ACTIVITY, 1, 18),
> > +	}
> >   };
> >   /*
> > @@ -69,6 +92,16 @@ static struct event_group energy_0x26696143 = {
> >   static struct event_group perf_0x26557651 = {
> >   	.guid		= 0x26557651,
> >   	.mmio_size	= (576 * 7 + 3) * 8,
> > +	.num_events	= 7,
> > +	.evts				= {
> 
> Ditto.

Ditto fixed.

Thanks

-Tony
