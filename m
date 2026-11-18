Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021306;
	b=wmN0LQnnVA9dQheECt27I/pW8jPH4vl4Ia0Lvn04SwdwZE1bZVHxN/6XmX6g/r44fqpg
	 DDw/SMD7BZ4EnWOSt0Jw68kPJKoByxTv+K4eSViCQGKV7dJBC78+vP7dsLIAbLNqCYGv5
	 jWluP3g1H9fR8eQm4D/4xmEkkkJhtKsbfo6fyCEUe7pXoM0dfmoEnBXPUHvxoXnbC7KnK
	 Cncawj6kQWFEH68XHgcZB56Sc5fdMyE6aQZYPxa8p8Ug8mKd4SN0Whqy6CXk9CeKsHUMl
	 Krtn6kAKLMTF1fNwdadtyVwbhT9yzthTouvUrx9kKTFMuxvkZpNJUzUuO1SZy9aEE4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021306;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=PRfp6SOVrrAYPUPThQxBxPybxQdM+w6pFXYthm3P4rY=;
	b=fpxWw4q9PApChnv5bv6uK+z2X0J2uPNjc65LdG56YdYH/0t0m7PadBdtSCprC4PL9AR6
	 qa9zw8FbyradSv4BdXIgfxMlbpDMk3HD5s1Tca+ABnM4pM9B0HJwREFDQzEMWrTxKCcwK
	 7Kqzt5/TUF61pCiVmONHjD+loTGm9TTdxMmT5f/DvUhFq6QGmlGBl+OeTo6tcUJmJc2hB
	 b/tTv9OVg7w8rTqMp5AHcr7t3jBqhxvole9ENv1z9gc7KnN2Cs3yBVheEOBLlZXEfmlX2
	 AXru6VW+VCnbmzBl07aYcIkME37kALpPFYnCmYFWu16a+ba4MkQSwa9h/JwCbe4Aiqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=BeDnEUjL;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6992F606A325
	for <patches@lists.linux.dev>; Wed, 18 Nov 2026 17:01:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6992F606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=BeDnEUjL
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9B401477;
	Wed, 18 Nov 2026 09:01:41 -0800 (PST)
Received: from [10.2.212.8] (e134344.arm.com [10.2.212.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE5373F673;
	Wed, 18 Nov 2026 09:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795021304; bh=LS1Mza+LT5GtPiXw370EYY3WnzupngYzyQpWADqAtBc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BeDnEUjL7hljS5HnslQ+mrbt0j2OSrGwkAzycbQGkJ56SzUhqugnrlY8dqEC28ay1
	 u6jKSZVACBDEC9FfwNUZ9l5pYvH+LDxkflx7EPYK5/+/CdPKaETp7p686GRaRLt21D
	 wrYcvhttDLmUtC6v+LjtNCVWHa4Zvg+KdEgdNSHw=
Message-ID: <de5ead8d-bfee-4e30-958b-d55e4a7160b4@arm.com>
Date: Wed, 18 Nov 2026 17:01:41 +0000
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/8] arm_mpam: resctrl: Do not fail CPU online when
 domain setup fails
To: Reinette Chatre <reinette.chatre@intel.com>, james.morse@arm.com,
 Dave.Martin@arm.com, fenghuay@nvidia.com, ruanjinjie@huawei.com
Cc: tony.luck@intel.com, yu.c.chen@intel.com, babu.moger@amd.com,
 fustini@kernel.org, tan.shaopeng@fujitsu.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <cover.1794283825.git.reinette.chatre@intel.com>
 <e0a6d37967c016019c82cbe368dd915902ecbca8.1794283825.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <e0a6d37967c016019c82cbe368dd915902ecbca8.1794283825.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 10/11/2026 04:19, Reinette Chatre wrote:
> When a CPU comes online, mpam_resctrl_online_cpu() adds it to the resctrl
> domains of each resource in use, and sets up a new domain when the CPU
> is the first of its domain to come online. A failure to set up a domain
> is returned as the failure of MPAM's CPU hotplug startup callback.
> 
> The CPU hotplug core does not run the teardown callback for a CPU whose
> startup callback failed, so everything done for the CPU before the
> failure stays in place: the CPU remains in the domains of the resources
> that were handled before the failing one, and MPAM's per-MSC state for
> the CPU is not undone. If the failure happens when MPAM installs its
> CPU hotplug callbacks during enabling, the hotplug core discards the
> callbacks, leaving MPAM enabled and resctrl initialized but MPAM no
> longer notified of CPU hotplug. If it happens when a CPU comes online
> later, the CPU fails to come online.
> 
> Setting up a domain only fails if a memory allocation fails or if a
> class unexpectedly has no component for the CPU. For such rare failures
> losing a resctrl domain is a smaller cost than failing CPU online or
> leaving MPAM in an inconsistent state.
> 
> Do not report domain setup failures from mpam_resctrl_online_cpu() and
> leave the CPU without a domain for that resource. Make
> mpam_resctrl_alloc_domain() return nothing since its failures are no
> longer reported. Keep adding the CPU to resctrl's default group even
> when a domain could not be set up, since the CPU is online and runs
> tasks regardless, and resctrl expects every online CPU to belong to a
> resource group. Warn on a failed domain allocation and on a missing
> monitoring component so these failures are not silent. Drop the warning
> when a CPU going offline has no domain, since a missing domain is now
> expected.
> 
> Only domains that were set up are exposed through resctrl and torn down
> when their CPUs go offline. When another CPU of the same domain comes
> online, it sets up the domain again, and if that succeeds the domain
> does not include the CPU for which setup failed.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Tested-by: Jinjie Ruan <ruanjinjie@huawei.com>
> Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>

Looks good to me.

Reviewed-by: Ben Horgan <ben.horgan@arm.com>

> ---
> Changes since RFC v2:
> - Add Jinjie's Reviewed-by tag.
> - Add Jinjie's Tested-by tag.
> - WARN when domain allocation fails. (Ben)
> - Squash patch that replaces WARN_ON_ONCE(0) with
>   WARN_ON_ONCE(!any_mon_comp). (Ben)
> ---
>  drivers/resctrl/mpam_devices.c  |  2 +-
>  drivers/resctrl/mpam_internal.h |  4 ++--
>  drivers/resctrl/mpam_resctrl.c  | 37 +++++++++++++++------------------
>  3 files changed, 20 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
> index 27abf60f4d67..a95326f2ef88 100644
> --- a/drivers/resctrl/mpam_devices.c
> +++ b/drivers/resctrl/mpam_devices.c
> @@ -2247,7 +2247,7 @@ static int mpam_cpu_online(unsigned int cpu)
>  	}
>  
>  	if (mpam_resctrl_enabled)
> -		return mpam_resctrl_online_cpu(cpu);
> +		mpam_resctrl_online_cpu(cpu);
>  
>  	return 0;
>  }
> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
> index 1f86cc158100..84c7adbb1a40 100644
> --- a/drivers/resctrl/mpam_internal.h
> +++ b/drivers/resctrl/mpam_internal.h
> @@ -525,13 +525,13 @@ int mpam_get_cpumask_from_cache_id(unsigned long cache_id, u32 cache_level,
>  #ifdef CONFIG_RESCTRL_FS
>  int mpam_resctrl_setup(void);
>  void mpam_resctrl_exit(void);
> -int mpam_resctrl_online_cpu(unsigned int cpu);
> +void mpam_resctrl_online_cpu(unsigned int cpu);
>  void mpam_resctrl_offline_cpu(unsigned int cpu);
>  void mpam_resctrl_teardown_class(struct mpam_class *class);
>  #else
>  static inline int mpam_resctrl_setup(void) { return 0; }
>  static inline void mpam_resctrl_exit(void) { }
> -static inline int mpam_resctrl_online_cpu(unsigned int cpu) { return 0; }
> +static inline void mpam_resctrl_online_cpu(unsigned int cpu) { }
>  static inline void mpam_resctrl_offline_cpu(unsigned int cpu) { }
>  static inline void mpam_resctrl_teardown_class(struct mpam_class *class) { }
>  #endif /* CONFIG_RESCTRL_FS */
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index d0c7c741ce90..ec39f3909388 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -1640,8 +1640,8 @@ static struct mpam_component *find_component(struct mpam_class *class, int cpu)
>  	return NULL;
>  }
>  
> -static struct mpam_resctrl_dom *
> -mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
> +static void mpam_resctrl_alloc_domain(unsigned int cpu,
> +				      struct mpam_resctrl_res *res)
>  {
>  	int err;
>  	struct mpam_resctrl_dom *dom;
> @@ -1656,11 +1656,11 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>  	comp = find_component(class, cpu);
>  	/* class has no component for this CPU */
>  	if (WARN_ON_ONCE(!comp))
> -		return ERR_PTR(-EINVAL);
> +		return;
>  
>  	dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
> -	if (!dom)
> -		return ERR_PTR(-ENOMEM);
> +	if (WARN_ON_ONCE(!dom))
> +		return;
>  
>  	if (r->alloc_capable) {
>  		dom->ctrl_comp = comp;
> @@ -1701,11 +1701,8 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>  			if (mon_comp)
>  				any_mon_comp = mon_comp;
>  		}
> -		if (!any_mon_comp) {
> -			WARN_ON_ONCE(0);
> -			err = -EFAULT;
> +		if (WARN_ON_ONCE(!any_mon_comp))
>  			goto offline_ctrl_domain;
> -		}
>  
>  		mon_d = &dom->resctrl_mon_dom;
>  		mpam_resctrl_domain_hdr_init(cpu, any_mon_comp, r->rid, &mon_d->hdr);
> @@ -1719,7 +1716,7 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>  		pr_debug("Skipped monitor domain online - no monitors\n");
>  	}
>  
> -	return dom;
> +	return;
>  
>  offline_ctrl_domain:
>  	if (r->alloc_capable) {
> @@ -1728,9 +1725,6 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>  	}
>  free_domain:
>  	kfree(dom);
> -	dom = ERR_PTR(err);
> -
> -	return dom;
>  }
>  
>  /*
> @@ -1782,7 +1776,7 @@ mpam_resctrl_get_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
>  	return mpam_resctrl_get_mon_domain_from_cpu(cpu);
>  }
>  
> -int mpam_resctrl_online_cpu(unsigned int cpu)
> +void mpam_resctrl_online_cpu(unsigned int cpu)
>  {
>  	struct mpam_resctrl_res *res;
>  	enum resctrl_res_level rid;
> @@ -1797,9 +1791,13 @@ int mpam_resctrl_online_cpu(unsigned int cpu)
>  
>  		dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
>  		if (!dom) {
> -			dom = mpam_resctrl_alloc_domain(cpu, res);
> -			if (IS_ERR(dom))
> -				return PTR_ERR(dom);
> +			/*
> +			 * On failure the CPU is left without a domain for this
> +			 * resource, which mpam_resctrl_offline_cpu() tolerates.
> +			 * resctrl_online_cpu() still adds the CPU to the default
> +			 * group because the CPU is online and runs tasks.
> +			 */
> +			mpam_resctrl_alloc_domain(cpu, res);
>  		} else {
>  			if (r->alloc_capable) {
>  				struct rdt_ctrl_domain *ctrl_d = &dom->resctrl_ctrl_dom;
> @@ -1815,8 +1813,6 @@ int mpam_resctrl_online_cpu(unsigned int cpu)
>  	}
>  
>  	resctrl_online_cpu(cpu);
> -
> -	return 0;
>  }
>  
>  void mpam_resctrl_offline_cpu(unsigned int cpu)
> @@ -1837,8 +1833,9 @@ void mpam_resctrl_offline_cpu(unsigned int cpu)
>  		if (!res->class)
>  			continue;	// dummy resource
>  
> +		/* The domain may be missing if its setup failed. */
>  		dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
> -		if (WARN_ON_ONCE(!dom))
> +		if (!dom)
>  			continue;
>  
>  		if (r->alloc_capable) {

