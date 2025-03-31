Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D898E1A3150
	for <patches@lists.linux.dev>; Mon, 31 Mar 2025 22:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743459835; cv=none; b=YzMmFWthSLhs8KW+NqG2QHxN0bsZqHoiZFsI634WpkFvmEzhRUsw7YN2cgmwqpVTQOD2vMIY2yij49LSp0itHfvrve3VXGKT5DYFPCtBuNNWGmnvZf64y9jATrM9WaT1mHi4RRnakT2NCje+5iU+APt2u4+6KOyOZv7HAQlXZ00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743459835; c=relaxed/simple;
	bh=09pr09NMFxHj0kcdIN7iMOo5Q1Zkq6bezOHGZwuBRQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MhE1M2JGw7Vgsm5SUQ9G5XYhemLqGlT3mBvahZOlzOaUHizCv1KVhWbuwvkx48Dkt+losPqINblLp9vHuhI55jkkD6opmHGNxg3VB4d7a7ipGOHSpajtKWXoyR9vltTCu8ifV7KPuAwg5OyqUcGT6NKTtH+endlPUnHEEO0PN1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dGWxC2HH; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dGWxC2HH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743459834; x=1774995834;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=09pr09NMFxHj0kcdIN7iMOo5Q1Zkq6bezOHGZwuBRQ4=;
  b=dGWxC2HH8kgY08B+2aK5Ox+2l9voNEY1RJq4VFHRp65RFQKzvJKEyZ4b
   MeDyLWyypci+vKmytRLpR0kppDWelu+GfJ4dHf/Emn0UvJTAr7bHb0AZW
   xGCAhPlzeNqFSL8zeK79Xv4PnZc0i4tN2YfIU21K9EKviiAbvCHSsf83a
   XtV0VQkLQbkO8XggYFRWBFocGj9bwbg8D5hBKcvlWwNy5UBaNuJxNlMDv
   XIUHB6u8w0U/8e1bno/aVjgDMDwcOv3W4O9D2pgv9r7ug4ABwJjIMioz7
   qMdPCLPyulKIzNxaX5ZXccmRSvdeEfOmk3WivQ7Kvw1upMlKtJcroGK0L
   g==;
X-CSE-ConnectionGUID: 4ZWQ8ttQRLmlBO/ZaOPPUQ==
X-CSE-MsgGUID: 2XmWt+UiQn+tJToI1T+OhA==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="44776710"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="44776710"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 15:23:53 -0700
X-CSE-ConnectionGUID: EH1F/nK1T4KAf0AWWzhdZA==
X-CSE-MsgGUID: T7LlyhAoQAK8uHHZwLf7ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="126034544"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 15:23:53 -0700
Date: Mon, 31 Mar 2025 15:23:51 -0700
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
Message-ID: <Z-sV98FdOH4PNQQo@agluck-desk3>
References: <20250321231609.57418-1-tony.luck@intel.com>
 <20250321231609.57418-11-tony.luck@intel.com>
 <cbd8198d-467b-456e-b329-baf6ac5cff82@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbd8198d-467b-456e-b329-baf6ac5cff82@intel.com>

On Mon, Mar 31, 2025 at 09:21:49AM -0700, Reinette Chatre wrote:
> hi Tony,
> 
> On 3/21/25 4:16 PM, Tony Luck wrote:
> > Use the per-package counts of known events to allocate arrays to
> > make a copy of just the known events.
> > 
> > Add hook into resctrl_exit() to cleanup.
> 
> (above is not done in patch)

I think I shuffled it to a different patch. I will track it
down and move this comment to the right place.

> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  arch/x86/kernel/cpu/resctrl/internal.h  |  2 +
> >  arch/x86/kernel/cpu/resctrl/core.c      |  2 +
> >  arch/x86/kernel/cpu/resctrl/intel_aet.c | 60 ++++++++++++++++++++++++-
> >  3 files changed, 63 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> > index ada402c7678b..2503a24e4177 100644
> > --- a/arch/x86/kernel/cpu/resctrl/internal.h
> > +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> > @@ -170,8 +170,10 @@ int rdt_get_mon_l3_config(struct rdt_resource *r);
> >  
> >  #ifdef CONFIG_INTEL_AET_RESCTRL
> >  int rdt_get_intel_aet_mon_config(void);
> > +void rdt_intel_aet_exit(void);
> >  #else
> >  static inline int rdt_get_intel_aet_mon_config(void) { return 0; }
> > +static inline void rdt_intel_aet_exit(void) { };
> >  #endif
> >  
> >  bool rdt_cpu_has(int flag);
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index 2adf40d8de32..d011c095aafa 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -1095,6 +1095,8 @@ static void __exit resctrl_arch_exit(void)
> >  {
> >  	cpuhp_remove_state(rdt_online);
> >  
> > +	rdt_intel_aet_exit();
> > +
> >  	resctrl_exit();
> >  }
> >  
> > diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > index 67862e81b9e0..e2d8eab997fc 100644
> > --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > @@ -188,6 +188,26 @@ static bool count_events(struct pkg_info *pkg, int max_pkgs, struct pmt_feature_
> >  	return found;
> >  }
> >  
> > +static int setup(struct pkg_info *pkg, int pkgnum, struct pmt_feature_group *p, int slot)
> 
> Could you please add a comment to this function to explain what it does?

Indeed yes, it really needs some description.
> 
> > +{
> > +	struct telem_entry **tentry;
> > +
> > +	for (int i = 0; i < p->count; i++) {
> > +		for (tentry = telem_entry; *tentry; tentry++) {
> > +			if (!(*tentry)->active)
> > +				continue;
> > +			if (pkgnum != p->regions[i].plat_info.package_id)
> > +				continue;
> > +			if (p->regions[i].guid != (*tentry)->guid)
> > +				continue;
> > +
> > +			pkg[pkgnum].regions[slot++] =  p->regions[i];
> > +		}
> > +	}
> > +
> > +	return slot;
> > +}
> > +
> >  DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,	\
> >  	if (!IS_ERR_OR_NULL(_T))					\
> >  		intel_pmt_put_feature_group(_T))
> > @@ -202,6 +222,8 @@ static bool get_events(void)
> >  	struct pmt_feature_group *p2 __free(intel_pmt_put_feature_group) = NULL;
> >  	int num_pkgs = topology_max_packages();
> >  	struct pkg_info *pkg __free(kfree) = NULL;
> > +	bool found_known_features = false;
> > +	int i, slot;
> >  
> >  	pkg = kmalloc_array(num_pkgs, sizeof(*pkg_info), GFP_KERNEL | __GFP_ZERO);
> >  	if (!pkg)
> > @@ -220,13 +242,32 @@ static bool get_events(void)
> >  		if (!count_events(pkg, num_pkgs, p2))
> >  			intel_pmt_put_feature_group(no_free_ptr(p2));
> >  
> > +	for (i = 0; i < num_pkgs; i++) {
> > +		if (!pkg[i].count)
> > +			continue;
> > +		found_known_features = true;
> > +		pkg[i].regions = kmalloc_array(pkg[i].count, sizeof(*pkg[i].regions), GFP_KERNEL);
> > +		if (!pkg[i].regions)
> > +			goto fail;
> > +
> > +		slot = 0;
> > +		if (!IS_ERR_VALUE(p1))
> > +			slot = setup(pkg, i, p1, slot);
> > +		if (!IS_ERR_VALUE(p2))
> > +			slot = setup(pkg, i, p2, slot);
> > +	}
> > +
> >  	if (!IS_ERR_OR_NULL(p1))
> >  		feat_energy = no_free_ptr(p1);
> >  	if (!IS_ERR_OR_NULL(p2))
> >  		feat_perf = no_free_ptr(p2);
> >  	pkg_info = no_free_ptr(pkg);
> >  
> > -	return true;
> > +	return found_known_features;
> > +fail:
> 
> include/linux/cleanup.h has this to say about mixing goto and free helpers:
> "convert all resources that need a "goto" cleanup to scope-based cleanup, or convert
> none of them"

Seems an awkward restriction for this case. "pkg" is a pointer to
a dynamic array, and each of the elements of the array might have
been initialized by another allocation. "pkg" is under control of
the __free() cleanup function.

Maybe I could define a custom cleanup (syntax of multi-statement
action to be figured out):

DEFINE_FREE(pkg_free, struct pkg_info *,
	if (_T)
		for (int i = 0; i < num_pkgs; i++)
			kfree(_T[i].regions);
	kfree(_T)
)

	struct pkg_info *pkg __free(pkg_free) = NULL;

> 
> > +	while (--i > 0)
> > +		kfree(pkg[i].regions);
> > +	return false;
> >  }
> >  
> >  /*
> > @@ -242,6 +283,23 @@ int rdt_get_intel_aet_mon_config(void)
> >  	return 1;
> >  }
> >  
> > +/* Clean up when resctrl shuts down completely */
> > +void rdt_intel_aet_exit(void)
> > +{
> > +	int num_pkgs = topology_max_packages();
> > +
> > +	if (pkg_info) {
> > +		for (int i = 0; i < num_pkgs; i++)
> > +			kfree(pkg_info[i].regions);
> > +		kfree(pkg_info);
> > +	}
> > +
> > +	if (feat_energy)
> > +		intel_pmt_put_feature_group(feat_energy);
> > +	if (feat_perf)
> > +		intel_pmt_put_feature_group(feat_perf);
> > +}
> > +
> >  /*
> >   * Late (first mount) initialization. Safe to ask OOBMSM which telemetry
> >   * event groups are supported.
> 
> Reinette
