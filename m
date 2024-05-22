Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FDA2E631
	for <patches@lists.linux.dev>; Wed, 22 May 2024 23:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716421647; cv=none; b=C/3tAXxQMYUdI+t8xKNiny5MUCsI+VVuGyueJgbjIVBygMD6WUUqhu5g2bxUNNdnNWIRK3UEmjiBvmRa5HGdnBlsYtEx35GdQnxLSQy9fgJ2xe7On0k3Okz5dTzRLYkR6CT2YlMt5gTEXoSHck9PwkNb8HabFWTPD2FhlGOLt/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716421647; c=relaxed/simple;
	bh=mcMDSvzSZvkz4h0Vl3V9NbPk8vcUsqlWmJWFs9CrDg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JBuBib/3er9LfcVxT6G9sKZ9wBWKsDPCZ7veos/SNiUE9F5B/Lqx5wLN6ND82zRe2KyK8gflLf8vgXs3V7ypG86zZCDVgiX+HaUwJCo4mL8rA74Av1DyW4scoPep7H12CEghpiUTNEbV73rCiObtnh9Xd+WoecQZ/oFDzNqIFuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZBRemrIb; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZBRemrIb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716421646; x=1747957646;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mcMDSvzSZvkz4h0Vl3V9NbPk8vcUsqlWmJWFs9CrDg4=;
  b=ZBRemrIb5pv1am0x83yhYVHI71mDtujdg2Q32O2bgZjVYkkQPWLmhQqK
   zOwft3mUUIFZJeVhUvKsvxDm15fk/4iaqnBVSVzrLiWE0OLiHvWRnrZYx
   DHTFgo7cpDCTG46hOhZYT4gxV22p2PaAE2CvVjHjwu26tdFjomaYoqs/o
   gTj6/PJuPvNdC7EcvGcmhjutPmNclcdy4ZNfQzrAz0HDWH+JiyeOgpsGU
   /iAtWZsYMQ7Eg/EXrUOC3KC06eP+ZOvbP9TlUpNuKp8Nqf9Z+XzvLCiXL
   QHl/7/AsNezi32pVkSRPmpMi9RTk1uVvaKxv8Vat1bmK+xO2B6DI18SUX
   w==;
X-CSE-ConnectionGUID: GrtKeBMgSOC78OGMpIBbbw==
X-CSE-MsgGUID: SjbInx4nQ5+tnilLN1ldjA==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="16548739"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="16548739"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 16:47:26 -0700
X-CSE-ConnectionGUID: pIK8TF54RbWo4WKxhgX0Zw==
X-CSE-MsgGUID: ieKqaBFzSiK82O5ULLNn/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="38301176"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 16:47:26 -0700
Date: Wed, 22 May 2024 16:47:23 -0700
From: Tony Luck <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v18 15/17] x86/resctrl: Fix RMID reading sanity check for
 Sub-NUMA (SNC) mode
Message-ID: <Zk6EC12hC0wzPiIu@agluck-desk3.sc.intel.com>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <20240515222326.74166-16-tony.luck@intel.com>
 <61e89a48-d1f4-49f2-8893-950e7e6ba7fe@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61e89a48-d1f4-49f2-8893-950e7e6ba7fe@intel.com>

On Wed, May 22, 2024 at 02:25:23PM -0700, Reinette Chatre wrote:
> > +		/*
> > +		 * SNC: OK to read events on any CPU sharing same L3
> > +		 * cache instance.
> > +		 */
> > +		if (d->display_id != get_cpu_cacheinfo_id(smp_processor_id(),
> > +							  r->mon_display_scope))
> 
> By hardcoding that mon_display_scope is a cache instead of using get_domain_id_from_scope()
> it seems that all pretending about being generic has just been abandoned at this point.

Yes. It now seems like a futile quest to make this look
like something generic.  All this code is operating on the
rdt_resources_all[RDT_RESOURCE_L3] resource (which by its very name is
"L3" scoped). In the SNC case the L3 has been divided (in some senses,
but not all) into nodes.

Given that pretending isn't working ... just be explicit?

Some "thinking aloud" follows ...

struct rdt_resource:
    In order to track monitor events, resctrl must build a domain list based
    on the smallest measurement scope. So with SNC enabled, that is the
    node. With it disabled it is L3 cache scope (which on existing systems
    is the same as node scope).

    Maybe keep .mon_scope with the existing name, but define it to be the
    minimum measurement scope and use it to build domains. So it
    defaults to RESCTRL_L3_CACHE but SNC detection will rewrite it to
    RESCTRL_L3_NODE.

    Drop the .mon_display_scope field. By definition it must always have
    the value RESCTRL_L3_CACHE. So replace checks that compare values
    rdt_resources_all[RDT_RESOURCE_L3] of .mon_scope & .mon_display_scope
    with:

    	if (r->mon_scope != RESCTRL_L3_CACHE)
    		// SNC stuff
    	else
    		// regular stuff

struct rdt_mon_domain:
    In the rdt_mon_domain rename the display_id field with the more
    honest name "l3_cache_id".  In addition save a pointer to the
    .shared_cpu_map of the L3 cache. When SNC is off, this will be the
    same as the d->hdr.cpu_mask for the domain. For SNC on it will be
    a superset (encompassing all the bits from cpu_masks in all domains
    that share an L3 instance).

    Where SNC specifc code is required, the check becomes:

    	if (d->hdr.id != d->l3_cache_id)
		// SNC stuff
	else
		// regular stuff

    The l3_cache_id can be used in mkdir code to make the mon_L3_XX
    directories. The L3 .shared_cpu_map in picking a CPU to read
    the counters for the "sum" files. l3_cache_id also indicates
    which domains should be summed.


Does this look like a useful direction to pursue?

-Tony
