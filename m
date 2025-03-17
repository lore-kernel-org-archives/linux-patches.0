Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360B61A2630
	for <patches@lists.linux.dev>; Mon, 17 Mar 2025 18:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742235797; cv=none; b=pysvHXqlEa9yKeEwVX1C/n5ttd0/6RUeU/cqVs30hqTiQ/dTGph8CDTiOvbFatnfh9LpfsWh4ylS6UPps+y6X3TEMhOAvIqocUsXLVh3iCiUdJUFpuOICVWLo8a57Kuf9x4KGtw21U11yqc+qFUSqhPuZ5QA6UCRC3AoCMezgWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742235797; c=relaxed/simple;
	bh=4w2t8ziQ3MaQSWNJnAtKVR9xCLHkPnm+0yL66gLdGMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i2VNV8pjv7abQCEgsDL6IQgbDkfhhdReDCB1aIzyWmTPBTqHqGWC9ORM1F8qdeY0CAo/uWn4sILfzrFIqeZYVbboFkbLdieKsMjVJE/0+Kfp+dvdBwPdrMYscI+Rmes5DGcE2MvXlTJnUGcrbGiIrdqnSupBMSdDra5PeWr01N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lrj/7YEq; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lrj/7YEq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742235795; x=1773771795;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4w2t8ziQ3MaQSWNJnAtKVR9xCLHkPnm+0yL66gLdGMY=;
  b=lrj/7YEqiwLPJl2NCuswzCy1X0WdaLv1VnzF6n6lCYJuyYBZ35PPT5D9
   /FiBYzHUDapyLJwTkRDBlnwm7YGBZkOTltMqwhr4wnmb2txMJhTHCOlJi
   +fEMDpelh2rTRV2iyNpt43kytcswme9VjZY9k/CEO9IrZTIQqm+q1Xi3+
   ddthoCn7LXGAmSCLim2K1xqVbne/RKNLo3akFTiU//ZuvUoFe0Q41GTmG
   IC5LS3Vdh5lxRYnA9Z8UsLztgSXBhjpH41uAfC20xZ04U6VbHkrrHZuaW
   +nEKAMByBWQBTmp75/MGnAWhpD0aQwKfGxrgJN1Dps3qj4FZo7zATLWwj
   A==;
X-CSE-ConnectionGUID: rMKipwROS36RO9cpom6OvQ==
X-CSE-MsgGUID: y3uB9C8dRXW4/DzenEQ7DQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11376"; a="47235924"
X-IronPort-AV: E=Sophos;i="6.14,254,1736841600"; 
   d="scan'208";a="47235924"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 11:23:14 -0700
X-CSE-ConnectionGUID: fZX/3bVJQW6gDdd5wJXL3Q==
X-CSE-MsgGUID: dW1/HaRuSGe9/hUl9tNyNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,254,1736841600"; 
   d="scan'208";a="122001407"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 11:23:14 -0700
Date: Mon, 17 Mar 2025 11:23:12 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] x86/resctrl: Refactor to make adding extra MBM events
 easy
Message-ID: <Z9hokNv4PvUILFjF@agluck-desk3>
References: <20250314202609.5753-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250314202609.5753-1-tony.luck@intel.com>

Here's my other bug:

> @@ -4162,31 +4156,29 @@ static int domain_setup_mon_state(struct rdt_resource *r, struct rdt_mon_domain
>  {
>  	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
>  	size_t tsize;
> +	int evt;
>  
>  	if (resctrl_arch_is_llc_occupancy_enabled()) {
>  		d->rmid_busy_llc = bitmap_zalloc(idx_limit, GFP_KERNEL);
>  		if (!d->rmid_busy_llc)
>  			return -ENOMEM;
>  	}
> -	if (resctrl_arch_is_mbm_total_enabled()) {
> -		tsize = sizeof(*d->mbm_total);
> -		d->mbm_total = kcalloc(idx_limit, tsize, GFP_KERNEL);
> -		if (!d->mbm_total) {
> -			bitmap_free(d->rmid_busy_llc);
> -			return -ENOMEM;
> -		}
> -	}
> -	if (resctrl_arch_is_mbm_local_enabled()) {
> -		tsize = sizeof(*d->mbm_local);
> -		d->mbm_local = kcalloc(idx_limit, tsize, GFP_KERNEL);
> -		if (!d->mbm_local) {
> -			bitmap_free(d->rmid_busy_llc);
> -			kfree(d->mbm_total);
> -			return -ENOMEM;
> -		}
> +
> +	for_each_set_bit(evt, &rdt_mon_features, sizeof(rdt_mon_features)) {
> +		if (!resctrl_arch_is_mbm_event(evt))
> +			continue;
> +		d->mbm_states[evt] = kcalloc(idx_limit, tsize, GFP_KERNEL);

tsize used uninitialized ... so "random" allocation amount.

> +		if (!d->mbm_states[evt])
> +			goto cleanup;
>  	}
>  
>  	return 0;
> +cleanup:
> +	bitmap_free(d->rmid_busy_llc);
> +	for (evt = 0; evt < QOS_L3_NUM_EVENTS; evt++)
> +		kfree(d->mbm_states[evt]);
> +
> +	return -ENOMEM;
>  }

-Tony
