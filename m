Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.216
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793008324;
	b=oGSdsw9lIlORJu1newfUsz/r9dUe75Px6qrgpVwTyaDkoeHOsqhkEYHccGcVcwYazLEM
	 spy3ng0dvJmBrj8NcA8bQZrD3gIqkld2uyHbN1oRxIeXv6d5A3ScccGvUxyqdeeUZbT0a
	 L9r60a1EmuVbwyOxh2qNWOXoVqVDh27czIeCg8rmcEzk/0QQI6V0/ctakaecsbP8AG3Qs
	 4nm1JJ/rUNMx4rywF0E0ad+fKNl/Eh9h3rMQZlfL2SEPvPsloTT+flM2fWQRw/SkDi6Xh
	 geLWoU+GcHOVJVu/p/hM47D+YStilZPXwmifF4sT/VMTIPoIxKVQqta65uiLQDFebiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793008324;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=1/hnSVO0qNWPHzymRfeFblNxFqKdYqMKmWvP+gKl0eY=;
	b=i9tQV/zQHt/yyNM0ezpc1kJhpnGzkjudhh2cedFCAcWReEL5W6oRdNtGjev7gTmrlVns
	 Z/XysSnxY6g3X5QmyPftu1OjPdM3CVy0G18bAlv1XSiDOngMi+kj/G84oL2OC92XfWcWu
	 FJtj+odzLBfBy/eAupncKPRntyLXtUqYrhiP69gg26/3OuMa/yLsvbLGJnQSPYViG/ygG
	 cYo9pKtMGbzC0U7pkjJxX/DvXfZsgKQLWVbIcfrC6NpWomI20XE3aIq7LeLtwIdc685Fg
	 Jk10sl9lg8BErGKhs/yPx7aDgl8AThqypXRYJ8qgTYbmP2cdIs5G2hnrBE9wcY8kyyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=CuqQUOLg;
	arc=none smtp.remote-ip=113.46.200.216
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30BB606A31B
	for <patches@lists.linux.dev>; Mon, 26 Oct 2026 09:52:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D30BB606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=CuqQUOLg
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1/hnSVO0qNWPHzymRfeFblNxFqKdYqMKmWvP+gKl0eY=;
	b=CuqQUOLguK0FGBBx0r0fJQVdpKAooBNNu1J69jMzFkxc43D2a0tEV29Y6uLrOsp06m6QqE/JP
	zF0SDL9pHErTXuF0Oo0JdY/cIquSDZRgA5bJmfxkHTcaIHhKmorOIHzhAey+UmiR1yQATUE+39R
	2neOuihWOQOWT69XxR8wfMI=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4jCpn353cYz1T4Fj;
	Mon, 26 Oct 2026 17:51:51 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 8A1E64057A;
	Mon, 26 Oct 2026 17:51:58 +0800 (CST)
Received: from [10.67.110.68] (10.67.110.68) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 26 Oct
 2026 17:51:47 +0800
Message-ID: <a7419cfe-f597-408a-a982-f210b4a5be8c@huawei.com>
Date: Mon, 26 Oct 2026 17:51:47 +0800
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
Subject: Re: [RFC PATCH v2 03/10] arm_mpam: resctrl: Do not fail CPU online
 when domain setup fails
To: Reinette Chatre <reinette.chatre@intel.com>, <ben.horgan@arm.com>,
	<james.morse@arm.com>, <Dave.Martin@arm.com>, <fenghuay@nvidia.com>
CC: <tony.luck@intel.com>, <yu.c.chen@intel.com>, <babu.moger@amd.com>,
	<fustini@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1792443633.git.reinette.chatre@intel.com>
 <660ffee2c7d069aed25c2757c51e12b28318bbc7.1792443633.git.reinette.chatre@intel.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <660ffee2c7d069aed25c2757c51e12b28318bbc7.1792443633.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk200008.china.huawei.com (7.202.194.74)



在 2026/10/20 6:07, Reinette Chatre 写道:
> When a CPU comes online, mpam_resctrl_online_cpu() adds it to the resctrl
> domains of each resource in use, and sets up a new domain when the CPU
> is the first of its domain to come online. A failure to set up a domain
> is returned as the failure of MPAM's CPU hotplug startup callback.

Indeed the code works this way.

> 
> The CPU hotplug core does not run the teardown callback for a CPU whose
> startup callback failed, so everything done for the CPU before the
> failure stays in place: the CPU remains in the domains of the resources
> that were handled before the failing one, and MPAM's per-MSC state for
> the CPU is not undone. If the failure happens when MPAM installs its
> CPU hotplug callbacks during enabling, the hotplug core discards the
> callbacks, leaving MPAM enabled and resctrl initialized but MPAM no

By the way, I previously ran into a case during testing where adding the
"maxcpu" boot parameter caused MPAM enabling to fail.

Link:
https://lore.kernel.org/all/20261020134239.3921377-6-ruanjinjie@huawei.com/

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

Yes, We now always call resctrl_online_cpu() to add them to the default
group.

> when a domain could not be set up, since the CPU is online and runs
> tasks regardless, and resctrl expects every online CPU to belong to a
> resource group. Drop the warning when a CPU going offline has no domain,
> since a missing domain is now expected.

It is now valid for the domain to be empty when a CPU goes offline.

> 
> Only domains that were set up are exposed through resctrl and torn down
> when their CPUs go offline. When another CPU of the same domain comes
> online, it sets up the domain again, and if that succeeds the domain
> does not include the CPU for which setup failed.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  drivers/resctrl/mpam_devices.c  |  2 +-
>  drivers/resctrl/mpam_internal.h |  4 ++--
>  drivers/resctrl/mpam_resctrl.c  | 31 +++++++++++++++----------------
>  3 files changed, 18 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
> index 48adc49b833c..d17d7a72dba1 100644
> --- a/drivers/resctrl/mpam_devices.c
> +++ b/drivers/resctrl/mpam_devices.c
> @@ -2249,7 +2249,7 @@ static int mpam_cpu_online(unsigned int cpu)
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
> index b07e5dd895dd..dc442851fd7e 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -1615,8 +1615,8 @@ static struct mpam_component *find_component(struct mpam_class *class, int cpu)
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
> @@ -1631,11 +1631,11 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>  	comp = find_component(class, cpu);
>  	/* class has no component for this CPU */
>  	if (WARN_ON_ONCE(!comp))
> -		return ERR_PTR(-EINVAL);
> +		return;
>  
>  	dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
>  	if (!dom)
> -		return ERR_PTR(-ENOMEM);
> +		return;
>  
>  	if (r->alloc_capable) {
>  		dom->ctrl_comp = comp;
> @@ -1678,7 +1678,6 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>  		}
>  		if (!any_mon_comp) {
>  			WARN_ON_ONCE(0);
> -			err = -EFAULT;
>  			goto offline_ctrl_domain;
>  		}
>  
> @@ -1694,7 +1693,7 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>  		pr_debug("Skipped monitor domain online - no monitors\n");
>  	}
>  
> -	return dom;
> +	return;
>  
>  offline_ctrl_domain:
>  	if (r->alloc_capable) {
> @@ -1703,9 +1702,6 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>  	}
>  free_domain:
>  	kfree(dom);
> -	dom = ERR_PTR(err);
> -
> -	return dom;
>  }
>  
>  /*
> @@ -1757,7 +1753,7 @@ mpam_resctrl_get_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
>  	return mpam_resctrl_get_mon_domain_from_cpu(cpu);
>  }
>  
> -int mpam_resctrl_online_cpu(unsigned int cpu)
> +void mpam_resctrl_online_cpu(unsigned int cpu)
>  {
>  	struct mpam_resctrl_res *res;
>  	enum resctrl_res_level rid;
> @@ -1772,9 +1768,13 @@ int mpam_resctrl_online_cpu(unsigned int cpu)
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
> @@ -1790,8 +1790,6 @@ int mpam_resctrl_online_cpu(unsigned int cpu)
>  	}
>  
>  	resctrl_online_cpu(cpu);
> -
> -	return 0;
>  }
>  
>  void mpam_resctrl_offline_cpu(unsigned int cpu)
> @@ -1812,8 +1810,9 @@ void mpam_resctrl_offline_cpu(unsigned int cpu)
>  		if (!res->class)
>  			continue;	// dummy resource
>  
> +		/* The domain may be missing if its setup failed. */
>  		dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
> -		if (WARN_ON_ONCE(!dom))
> +		if (!dom)
>  			continue;

Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>

>  
>  		if (r->alloc_capable) {

-- 
Best regards,
Jinjie

