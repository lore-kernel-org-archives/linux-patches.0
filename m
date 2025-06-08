Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028CC256C76
	for <patches@lists.linux.dev>; Sun,  8 Jun 2025 22:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749420003; cv=none; b=TB5Hm5vHe3UtSFb/Km1uREapwtdzJppxio79Jf08aCNwEw7wfOLuQi7xdRyv1JJGbAYO8Mrn3FBLs8Aa2xnJ9/LQPeKbt6o9AUABPy8EnUEbX6Josomdzh8r5vxmQg6O1O3ga//fsSdcXhdiFu/0oTjzDV4vWJ5djbcyjsalhRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749420003; c=relaxed/simple;
	bh=7EutwoH4X9Mh1hoaQBaw6NBPwLfzRL9LKYyc4fUNNPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JpQSS2zWNqJv5Veon9D/V7v5WGCLHE0b5vruegXgtDE22YKC4Pl3YVT2hfOi+IZlqcihx2tCNQq8EAwnKLEIVLpiLLXDAJTYlr555W9KEJMnU2EKPQ8LptKLZIXDe5fQG4PJuot/GxmmHYasKDLECBjaD8Y9GXVFsUIFk2F5THk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EK4ozIkj; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EK4ozIkj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749420002; x=1780956002;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=7EutwoH4X9Mh1hoaQBaw6NBPwLfzRL9LKYyc4fUNNPk=;
  b=EK4ozIkj1s0qgj/tKc5pB0RhZaeVigtKgKcC8+U8/QTFv8TnXv0RKf/g
   S0ymtMC960FwwgHKLpg6L2VK8KNREQozmRSgJlUXzZAxYDylSwko1XMXm
   VSK9Y7v3saOerZUiUunaU7WlD9mjD+1GRFhBCbT28TJIXiT9RK3A3Gdnx
   Uv1ZXVrk253EbTaawApviHkUKXVzzDJmhkkVk2VuozJ8ZItke6RtMWQna
   Lqi1FU/QTh+qu9EoI9WQowbD+8A2s75gEoHqiB4bLT9nthmcZNvLJkOm4
   J4mf7GSAM6UJHMUo5cew5gvOEXOznYxCJYgjELTKu+IiHLmEwcGo98aU7
   w==;
X-CSE-ConnectionGUID: cMYVdQI6Q+ujkDIFKWyNLg==
X-CSE-MsgGUID: X1HaKpfQSWi5PBwKYy2/8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11458"; a="62147820"
X-IronPort-AV: E=Sophos;i="6.16,221,1744095600"; 
   d="scan'208";a="62147820"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2025 15:00:01 -0700
X-CSE-ConnectionGUID: /Z/2ii+6TzO5xNezwEZt3g==
X-CSE-MsgGUID: ZCIKP44gTUyGSmj4bRt+0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,221,1744095600"; 
   d="scan'208";a="146239261"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2025 15:00:01 -0700
Date: Sun, 8 Jun 2025 14:59:59 -0700
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
Subject: Re: [PATCH v5 04/29] x86,fs/resctrl: Prepare for more monitor events
Message-ID: <aEYH38g4N_ZNlv6b@agluck-desk3>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-5-tony.luck@intel.com>
 <462eb5cb-56bc-4639-9029-5166cb71b5bf@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <462eb5cb-56bc-4639-9029-5166cb71b5bf@nvidia.com>

On Fri, Jun 06, 2025 at 05:45:58PM -0700, Fenghua Yu wrote:
[SNIP]

> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index 819bc7a09327..4403a820db12 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -364,8 +364,8 @@ static void ctrl_domain_free(struct rdt_hw_ctrl_domain *hw_dom)
> >   static void mon_domain_free(struct rdt_hw_mon_domain *hw_dom)
> >   {
> > -	kfree(hw_dom->arch_mbm_total);
> > -	kfree(hw_dom->arch_mbm_local);
> > +	for (int i = 0; i < QOS_NUM_L3_MBM_EVENTS; i++)
> > +		kfree(hw_dom->arch_mbm_states[i]);
> 
> Is it better to define a helper for_each_mon_event_idx(i)?
> 
> #define for_each_mbm_event_idx(i) \
> 
>     for (int i = 0; i < QOS_NUM_L3_MBM_EVENTS; i++)
> 
> Then the above for loop can be simplified to:
> 
>     for_each_mbm_event_idxd(i)
> 
> 	kfree(hw_dom->arch_mbm_states[i]);
> 
> The helper can be used in other places as well (see below).

I think there are only two places total. So maybe?

-Tony
