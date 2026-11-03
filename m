Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793721662;
	b=435Kw2OBnMCUXjwPPUyUg4JogZAeLnQXEogIl6LB81wKZhFC5/BphOVccKwFl/jPtdJF
	 0eY+ncUxcXJ8xSoBUHaMS1qHWXGJeuzymr/cQPj4r+S9OyonlfR6cYR5jb9Bn/qrX4a31
	 hFm4oZ24fpv22RK6c7Pxm+J/ZTCbxF4zr6yzTj6eToWu0ZnG1aM0NmOEFZ+5it4n9i3uP
	 qfba0cUq2i9miOKQl9DXlCseP8t0p63mHV/Y38/lNLnFpsV/CH0Fn3kQ05t1zxhmRjC2O
	 Be2Smp1SxMSfirCPOdl0cSBXB4eHhNFiCralZ4OWqbaiaA4/WdneH4gRGZNMvfcVdKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793721662;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Wkiei5f031Olo+3i6CqJNkj3qPX9f5twKRL/qwtW7Xo=;
	b=HesmVKPA4A2bGkWVticaQBju68WH3egulie0vGpskH8vQGcyy2dgSePbjHhZaMq1p3QR
	 pGPNYxBAjjQeXwbmCPbElcSj6CdF1K5ut6tpQ662Xc5jyHamiMYpHYg8Jc1gEZFWqlnlX
	 Gv5GFjYUZfJkHKI984316U1Cc7noxVM+ouB4trO+05UJNtJlSxYVOWOz8egYQO8xHTf6+
	 0hjyru4bhnCyqD94jVInpcUftbzUXMqxMLRyPyGmEdOawID85P1uSCIRWkBvvxkp+cE/L
	 GDey6CPsE+wSR3uwiSXm//w0hj9y4jJHaQ2NN42E29fm8yYCtsNQEhsMeIcFFJ33o/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=REy1YgCe;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9C0D606D801
	for <patches@lists.linux.dev>; Tue,  3 Nov 2026 16:01:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9C0D606D801
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=REy1YgCe
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 050B81595;
	Tue,  3 Nov 2026 08:00:58 -0800 (PST)
Received: from [10.211.55.3] (unknown [10.57.89.242])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C8283F673;
	Tue,  3 Nov 2026 08:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793721661; bh=6wtQ649mZLnh1QZPpY5qMjizB73z4wqwnxTTLMnkZrA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=REy1YgCe9Vd9A3LdNVqT7mYMgVMDhrwo49K9PjynHx0TObmO/SfJvupHCd4znUOm/
	 AebGUT39EWzOFPPJU4I6HXyLQkjoODBDB7YlVKMaLtvek/4htq8LtqXTc1jW8TVhOO
	 4d9wGryNqv7WhwIbr6fFy8dIccEVLKMtB2PA4c3g=
Message-ID: <104d71f0-8fb3-4196-ac32-93ef89f78540@arm.com>
Date: Tue, 3 Nov 2026 16:00:57 +0000
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [RFC PATCH v2 04/10] arm_mpam: resctrl: Split control and
 monitoring domain setup into helpers
To: Reinette Chatre <reinette.chatre@intel.com>, james.morse@arm.com,
 Dave.Martin@arm.com, fenghuay@nvidia.com
Cc: tony.luck@intel.com, yu.c.chen@intel.com, babu.moger@amd.com,
 fustini@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1792443633.git.reinette.chatre@intel.com>
 <20621c28067916be2709fc4437473f1ccad7e334.1792443633.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <20621c28067916be2709fc4437473f1ccad7e334.1792443633.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

Generally makes sense.

On 19/10/2026 23:07, Reinette Chatre wrote:
> mpam_resctrl_alloc_domain() allocates one structure that holds both the
> control domain and the monitoring domain of a resource. It sets up
> whichever of the two domains the resource supports, with the setup of
> both open coded in the function, and undoes the control domain if
> setting up the monitoring domain fails.
> 
> Apart from the code that manages domains, every user of the structure
> accesses only one of its two domains, so the monitoring domain can be
> given a structure of its own. Doing so starts with separating its setup
> from that of the control domain.
> 
> Move the setup of each domain into its own helper in preparation for
> giving the monitoring domain its own structure as part of supporting
> multiple controls per resource. Keep the allocation and the error
> handling in mpam_resctrl_alloc_domain() so that a failure to set up the
> monitoring domain still undoes the control domain.
> 
> No functional change intended.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  drivers/resctrl/mpam_resctrl.c | 116 ++++++++++++++++++++-------------
>  1 file changed, 70 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index dc442851fd7e..246560247a28 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -1615,13 +1615,77 @@ static struct mpam_component *find_component(struct mpam_class *class, int cpu)
>  	return NULL;
>  }
>  
> +static int mpam_resctrl_setup_ctrl_domain(unsigned int cpu,
> +					  struct rdt_resource *r,
> +					  struct mpam_component *comp,
> +					  struct mpam_resctrl_dom *dom)
> +{
> +	struct rdt_ctrl_domain *ctrl_d = &dom->resctrl_ctrl_dom;
> +	int err;
> +
> +	dom->ctrl_comp = comp;
> +
> +	mpam_resctrl_domain_hdr_init(cpu, comp, r->rid, &ctrl_d->hdr);
> +	ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
> +	err = resctrl_online_ctrl_domain(r, ctrl_d);
> +	if (err)
> +		return err;
> +
> +	mpam_resctrl_domain_insert(&r->ctrl_domains, &ctrl_d->hdr);
> +
> +	return 0;
> +}
> +
> +static int mpam_resctrl_setup_mon_domain(unsigned int cpu,
> +					 struct rdt_resource *r,
> +					 struct mpam_resctrl_dom *dom)
> +{
> +	struct rdt_l3_mon_domain *mon_d = &dom->resctrl_mon_dom;
> +	struct mpam_component *any_mon_comp = NULL;
> +	enum resctrl_event_id eventid;
> +	struct mpam_resctrl_mon *mon;
> +	int err;
> +
> +	/*
> +	 * Even if the monitor domain is backed by a different
> +	 * component, the L3 component IDs need to be used... only
> +	 * there may be no ctrl_comp for the L3.
> +	 * Search each event's class list for a component with
> +	 * overlapping CPUs and set up the dom->mon_comp array.
> +	 */
> +
> +	for_each_mpam_resctrl_mon(mon, eventid) {
> +		struct mpam_component *mon_comp;
> +
> +		if (!mon->class)
> +			continue;       // dummy resource
> +
> +		mon_comp = find_component(mon->class, cpu);
> +		dom->mon_comp[eventid] = mon_comp;
> +		if (mon_comp)
> +			any_mon_comp = mon_comp;
> +	}
> +	if (!any_mon_comp) {
> +		WARN_ON_ONCE(0);
> +		return -EFAULT;
> +	}

If you squash the the warning patch into patch 3 as I suggest there then
this copy needs to change too (of course).

Thanks,

Ben

> +
> +	mpam_resctrl_domain_hdr_init(cpu, any_mon_comp, r->rid, &mon_d->hdr);
> +	mon_d->hdr.type = RESCTRL_MON_DOMAIN;
> +	err = resctrl_online_mon_domain(r, &mon_d->hdr);
> +	if (err)
> +		return err;
> +
> +	mpam_resctrl_domain_insert(&r->mon_domains, &mon_d->hdr);
> +
> +	return 0;
> +}
> +
>  static void mpam_resctrl_alloc_domain(unsigned int cpu,
>  				      struct mpam_resctrl_res *res)
>  {
>  	int err;
>  	struct mpam_resctrl_dom *dom;
> -	struct rdt_l3_mon_domain *mon_d;
> -	struct rdt_ctrl_domain *ctrl_d;
>  	struct mpam_class *class = res->class;
>  	struct mpam_component *comp;
>  	struct rdt_resource *r = &res->resctrl_res;
> @@ -1638,57 +1702,17 @@ static void mpam_resctrl_alloc_domain(unsigned int cpu,
>  		return;
>  
>  	if (r->alloc_capable) {
> -		dom->ctrl_comp = comp;
> -
> -		ctrl_d = &dom->resctrl_ctrl_dom;
> -		mpam_resctrl_domain_hdr_init(cpu, comp, r->rid, &ctrl_d->hdr);
> -		ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
> -		err = resctrl_online_ctrl_domain(r, ctrl_d);
> +		err = mpam_resctrl_setup_ctrl_domain(cpu, r, comp, dom);
>  		if (err)
>  			goto free_domain;
> -
> -		mpam_resctrl_domain_insert(&r->ctrl_domains, &ctrl_d->hdr);
>  	} else {
>  		pr_debug("Skipped control domain online - no controls\n");
>  	}
>  
>  	if (r->mon_capable) {
> -		struct mpam_component *any_mon_comp = NULL;
> -		struct mpam_resctrl_mon *mon;
> -		enum resctrl_event_id eventid;
> -
> -		/*
> -		 * Even if the monitor domain is backed by a different
> -		 * component, the L3 component IDs need to be used... only
> -		 * there may be no ctrl_comp for the L3.
> -		 * Search each event's class list for a component with
> -		 * overlapping CPUs and set up the dom->mon_comp array.
> -		 */
> -
> -		for_each_mpam_resctrl_mon(mon, eventid) {
> -			struct mpam_component *mon_comp;
> -
> -			if (!mon->class)
> -				continue;       // dummy resource
> -
> -			mon_comp = find_component(mon->class, cpu);
> -			dom->mon_comp[eventid] = mon_comp;
> -			if (mon_comp)
> -				any_mon_comp = mon_comp;
> -		}
> -		if (!any_mon_comp) {
> -			WARN_ON_ONCE(0);
> -			goto offline_ctrl_domain;
> -		}
> -
> -		mon_d = &dom->resctrl_mon_dom;
> -		mpam_resctrl_domain_hdr_init(cpu, any_mon_comp, r->rid, &mon_d->hdr);
> -		mon_d->hdr.type = RESCTRL_MON_DOMAIN;
> -		err = resctrl_online_mon_domain(r, &mon_d->hdr);
> +		err = mpam_resctrl_setup_mon_domain(cpu, r, dom);
>  		if (err)
>  			goto offline_ctrl_domain;
> -
> -		mpam_resctrl_domain_insert(&r->mon_domains, &mon_d->hdr);
>  	} else {
>  		pr_debug("Skipped monitor domain online - no monitors\n");
>  	}
> @@ -1697,8 +1721,8 @@ static void mpam_resctrl_alloc_domain(unsigned int cpu,
>  
>  offline_ctrl_domain:
>  	if (r->alloc_capable) {
> -		mpam_resctrl_offline_domain_hdr(cpu, &ctrl_d->hdr);
> -		resctrl_offline_ctrl_domain(r, ctrl_d);
> +		mpam_resctrl_offline_domain_hdr(cpu, &dom->resctrl_ctrl_dom.hdr);
> +		resctrl_offline_ctrl_domain(r, &dom->resctrl_ctrl_dom);
>  	}
>  free_domain:
>  	kfree(dom);

