Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41022FFDF1
	for <patches@lists.linux.dev>; Mon,  1 Sep 2025 08:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756717138; cv=none; b=rGhoCDaqaVOd/DUWGpqlGrX5kTkfJEyFA1SQmI28QbU8S+CfGOxUSwWM/6yKRS2Bulgaeaj5tvFis80CjbeT6+w/Ki7lQVA5sYAT8CVJFuOkZwdrX+acupSw7r4ZnRavcRKA7YFu1/Lnvedd67sfI2ma85YqmSioud+WoW59tGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756717138; c=relaxed/simple;
	bh=jzD/xLrSjUNGu8UFUriAfRlRjsfWdLWVjJI0cQvveg8=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=YTwAknQG0w/dtSb12VnyU3W73l1f3g1DNiUtwIMPfDXteoR/tDeMfsL3/R6oqXQtYcMDHRdT3FfkNxNWrEOHUW0GSjRk0GNYN6IEfXBUba4XJaYU0WdgRTZ5jdVeHnmCo8vEcpEagIJDf1Mj2BZjEzPP1AEzLeL0BiYel62DaRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k1tXXJJy; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k1tXXJJy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756717137; x=1788253137;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=jzD/xLrSjUNGu8UFUriAfRlRjsfWdLWVjJI0cQvveg8=;
  b=k1tXXJJyENkhRkpGVHYGCJ84O0IK7FPTIQvd7XceQzOBiqg+oGJv+/j9
   AqbZGzdvabMtzstOVq2q4hen9oxK+cA+jUH2bYhSdHq9+WC9wiCU+1RGD
   6tnhjpEha6+Jc9kXss353tnl2niNTS5vaV3Fr9doCia6C882zaqWe7nJ/
   yJg24h92m7/yxJIWBi6pBKG2STotWGnAveLpxZvFmWMQ5+c6xekA5TKIp
   DaroZpLdlNWWafdw57XKj49qOfV2Nj2ALdEg3AoQMHiktIg5KH3XPwwWK
   lqg1rE5L83ZU8huXN8pN7HvBAuQ6O7VFcGYsMcs6WM//K/Kc0F0sOGB3P
   Q==;
X-CSE-ConnectionGUID: FC91CusgThG/hEqzevINXw==
X-CSE-MsgGUID: w7rOMC84RECwJfd5TtSnbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="58918550"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58918550"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 01:58:56 -0700
X-CSE-ConnectionGUID: G0Fb6AZrRN+U72oDhsp65w==
X-CSE-MsgGUID: RP5y70t7QqGyWCX3UUm4ZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="175109418"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.193])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 01:58:51 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Mon, 1 Sep 2025 11:58:48 +0300 (EEST)
To: Tony Luck <tony.luck@intel.com>
cc: Fenghua Yu <fenghuay@nvidia.com>, 
    Reinette Chatre <reinette.chatre@intel.com>, 
    Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, 
    Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>, 
    Babu Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, 
    Dave Martin <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, 
    x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, 
    patches@lists.linux.dev
Subject: Re: [PATCH v9 20/31] x86/resctrl: Find and enable usable telemetry
 events
In-Reply-To: <20250829193346.31565-21-tony.luck@intel.com>
Message-ID: <9ac43e78-8955-db5d-61be-e08008e41f0d@linux.intel.com>
References: <20250829193346.31565-1-tony.luck@intel.com> <20250829193346.31565-21-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 29 Aug 2025, Tony Luck wrote:

> The INTEL_PMT driver provides telemetry region structures of the
> types requested by resctrl.
> 
> Scan these structures to discover which pass sanity checks:
> 
> 1) They have guid known to resctrl.
> 2) They have a valid package ID.
> 3) The enumerated size of the MMIO region matches the expected
>    value from the XML description file.
> 4) At least one region passes the above checks.
> 
> Enable the active events in resctrl filesystem to make them available to
> user space. Pass a pointer to the pmt_event structure of the event within
> the struct event_group that resctrl stores in mon_evt::arch_priv. resctrl
> passes this pointer back when asking to read the event data which enables
> the data to be found in MMIO.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 36 +++++++++++++++++++++++--
>  1 file changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 565777841f5c..5c5466dc3189 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -102,12 +102,44 @@ static struct event_group *known_perf_event_groups[] = {
>  	for (_peg = _grp; _peg < &_grp[ARRAY_SIZE(_grp)]; _peg++)	\
>  		if ((*_peg)->pfg)
>  
> -/* Stub for now */
> -static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> +static bool skip_this_region(struct telemetry_region *tr, struct event_group *e)

skip_telem_region? It would get rid of vague "this" in the name.

>  {
> +	if (tr->guid != e->guid)
> +		return true;
> +	if (tr->plat_info.package_id >= topology_max_packages()) {
> +		pr_warn_once("Bad package %d in guid 0x%x\n", tr->plat_info.package_id,
> +			     tr->guid);
> +		return true;
> +	}
> +	if (tr->size != e->mmio_size) {
> +		pr_warn_once("MMIO space wrong size (%zu bytes) for guid 0x%x. Expected %zu bytes.\n",
> +			     tr->size, e->guid, e->mmio_size);

Are _once warranted in these two cases? Do we call this function for the 
same guid and region combination more than once?

+ include for pr_*().

> +		return true;
> +	}
> +
>  	return false;
>  }
>  
> +static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> +{
> +	bool usable_events = false;
> +
> +	for (int i = 0; i < p->count; i++) {
> +		if (skip_this_region(&p->regions[i], e))
> +			continue;
> +		usable_events = true;

Do you need to loop beyond asserting this?

> +	}
> +
> +	if (!usable_events)
> +		return false;
> +
> +	for (int j = 0; j < e->num_events; j++)
> +		resctrl_enable_mon_event(e->evts[j].id, true,
> +					 e->evts[j].bin_bits, &e->evts[j]);
> +
> +	return true;
> +}
> +
>  DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,
>  		if (!IS_ERR_OR_NULL(_T))
>  			intel_pmt_put_feature_group(_T))
> 

-- 
 i.

