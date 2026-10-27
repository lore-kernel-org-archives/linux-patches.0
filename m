Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.217
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793089794;
	b=f6TNCQ+R4aSIzRuIJpaAAVQYTc5oFBxdbZvTuBRurhV0Lsf/1A9BOvqupane+wvjCuPa
	 3udNpqS6Spw+DRe14s+6A1HQgISTBFe+dCeHKG5yoh523TJipZldMnLaKvKgd9l5VROHq
	 +6SqE+ZGKEe+Cim+NHRhFqDiRY9mMUrN9ZbYR1re7fSeTVVpjQie3S+zmcFXdbFv/8GEg
	 uDcM2seurH9l6Ank1vG31LXAyy1tabJCTNvFppaXUxj01r+aW2j9r3pT0ydW4Zu+BT3vb
	 ALbv7VDa7zpl2ICkVe//3cQZO1V4JO93Sy0oM5/0jbWemcH3ob/Z7xMs8/kMybiVMDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793089794;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=QFQbNPRL5qB+ZdzhYI0SHCIte+Ug/BskoqyTmeMBVJk=;
	b=FAp+V5GnS/eSF95Gz6v5v6yZBNY97XMBf8CewD38gpJHPTGOdICipF89PCs+fVF/RzmR
	 2OPUve+sP6iTctPmtmfIm6LYp9txEzJZkiCg5xvRNacqo6y5sgr6uVnt/YYkCfhN3caP9
	 ydAxSZ84plBr1Oip3BpnKbY+Aj6Z9zPVk96Jdn9UygbDGfv4Iye0hSW5vhqUuwk6E5ZQL
	 sqHKdeRkmRQmIyaCFMXiUDZf7OnFZwVt1r7PekRgXrbKm2NUQKHamG7+oQnPWvoTS8mXw
	 W5AFo+tB7WG7qK2/YVgvYVHC0OfE/2KPFazr1GGgaj91OWGsC/iEuNDuGZJe6yTXXMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=tm2uQKiq;
	arc=none smtp.remote-ip=113.46.200.217
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF18E606A31B
	for <patches@lists.linux.dev>; Tue, 27 Oct 2026 08:29:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF18E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=tm2uQKiq
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QFQbNPRL5qB+ZdzhYI0SHCIte+Ug/BskoqyTmeMBVJk=;
	b=tm2uQKiq8I/V9kOmWIabdEQjfssc7+YdNZ8/QUkrEHBDF5iJTMfWe4ZpHN4sHwx/W5AbLCr4D
	WRD06rwwCKxa6+NPfD+hICfvYRrJoX/2FECDzupJzIFWkOQh775Ja9GDPed2i96Hgrbm3hNgs6/
	wodYY5sOibkKg0SJixnI+qw=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4jDNvT6JJBzcbTJ;
	Tue, 27 Oct 2026 16:29:25 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id C475340579;
	Tue, 27 Oct 2026 16:29:37 +0800 (CST)
Received: from [10.67.110.68] (10.67.110.68) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 27 Oct
 2026 16:29:36 +0800
Message-ID: <b696f0f2-6ee8-4a8c-99f5-bf9836aff223@huawei.com>
Date: Tue, 27 Oct 2026 16:29:36 +0800
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
Subject: Re: [PATCH v2 2/5] x86,fs/resctrl: Remove unnecessary non-linear MBA
 configuration check
To: Reinette Chatre <reinette.chatre@intel.com>, <tony.luck@intel.com>,
	<ben.horgan@arm.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <fustini@kernel.org>,
	<fenghuay@nvidia.com>, <peternewman@google.com>, <yu.c.chen@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1791406459.git.reinette.chatre@intel.com>
 <54ee80a047388ed372f1e848eccbac930a9745be.1791406459.git.reinette.chatre@intel.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <54ee80a047388ed372f1e848eccbac930a9745be.1791406459.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk200008.china.huawei.com (7.202.194.74)



在 2026/10/8 5:06, Reinette Chatre 写道:
> Writing a bandwidth value from user space is rejected if the MBA resource
> has non-linear delay values while the architecture indicates (via
> resctrl_membw::arch_needs_linear) it can only configure resources with
> linear delay values. Intel indicates this for MBA while AMD and MPAM do not.
> 
> This check can never fail. No Intel SKU supports non-linear delay values,
> and the placeholder for such support, rdt_get_mb_table(), is only called
> during enumeration and always fails. A non-linear Intel MBA resource is
> thus never marked as capable of allocation, and resctrl never exposes it
> to user space or attempts to configure it. Every Intel MBA resource capable
> of allocation has linear delay values, and AMD and MPAM never indicate a
> need for them.
> 
> Fail enumeration of a non-linear Intel MBA resource directly to make clear
> that it is not supported, and remove the check together with the
> resctrl_membw::arch_needs_linear property it relies on.
> 
> Keep the informational message printed when such a system is encountered.
> While moving it, reword it to no longer refer to the removed mapping table,
> add the missing newline, and label the printed family value "family" instead
> of "cpu".
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> Changes since RFC v1:
> - Fix typo in changelog
> 
> Changes since RFC v2:
> - Rework changelog.
> - Group all r->membw assignments together.
> 
> Changes since v1:
> - Keep (and fix) existing pr_info() message if a non-linear platform
>   appears. (Chenyu)
> - Rework changelog.
> - Group rdt_resource::membw assignments together.
> ---
>  arch/x86/kernel/cpu/resctrl/core.c | 42 +++++++-----------------------
>  fs/resctrl/ctrlmondata.c           |  8 ------
>  include/linux/resctrl.h            |  2 --
>  3 files changed, 10 insertions(+), 42 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index f9677e52790e..f96f7cf255d0 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -181,27 +181,6 @@ static inline void cache_alloc_hsw_probe(void)
>  	rdt_alloc_capable = true;
>  }
>  
> -/*
> - * rdt_get_mb_table() - get a mapping of bandwidth(b/w) percentage values
> - * exposed to user interface and the h/w understandable delay values.
> - *
> - * The non-linear delay values have the granularity of power of two
> - * and also the h/w does not guarantee a curve for configured delay
> - * values vs. actual b/w enforced.
> - * Hence we need a mapping that is pre calibrated so the user can
> - * express the memory b/w as a percentage value.
> - */
> -static inline bool rdt_get_mb_table(struct rdt_resource *r)
> -{
> -	/*
> -	 * There are no Intel SKUs as of now to support non-linear delay.
> -	 */
> -	pr_info("MBA b/w map not implemented for cpu:%d, model:%d",
> -		boot_cpu_data.x86, boot_cpu_data.x86_model);
> -
> -	return false;
> -}
> -
>  static __init bool __get_mem_config_intel(struct rdt_resource *r)
>  {
>  	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
> @@ -212,18 +191,18 @@ static __init bool __get_mem_config_intel(struct rdt_resource *r)
>  	cpuid_count(0x00000010, 3, &eax.full, &ebx, &ecx, &edx.full);
>  	hw_res->num_closid = edx.split.cos_max + 1;
>  	max_delay = eax.split.max_delay + 1;
> -	r->membw.max_bw = MAX_MBA_BW;
> -	r->membw.arch_needs_linear = true;
> -	if (ecx & MBA_IS_LINEAR) {
> -		r->membw.delay_linear = true;
> -		r->membw.min_bw = MAX_MBA_BW - max_delay;
> -		r->membw.bw_gran = MAX_MBA_BW - max_delay;
> -	} else {
> -		if (!rdt_get_mb_table(r))
> -			return false;
> -		r->membw.arch_needs_linear = false;
> +
> +	if (!(ecx & MBA_IS_LINEAR)) {
> +		pr_info("Non-linear MBA delay values not supported for family:%d, model:%d\n",
> +			boot_cpu_data.x86, boot_cpu_data.x86_model);
> +		return false;
>  	}

Acked-by: Jinjie Ruan <ruanjinjie@huawei.com>

>  
> +	r->membw.delay_linear = true;
> +	r->membw.max_bw = MAX_MBA_BW;
> +	r->membw.min_bw = MAX_MBA_BW - max_delay;
> +	r->membw.bw_gran = MAX_MBA_BW - max_delay;
> +
>  	if (boot_cpu_has(X86_FEATURE_PER_THREAD_MBA))
>  		r->membw.throttle_mode = THREAD_THROTTLE_PER_THREAD;
>  	else
> @@ -255,7 +234,6 @@ static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
>  
>  	/* AMD does not use delay */
>  	r->membw.delay_linear = false;
> -	r->membw.arch_needs_linear = false;
>  
>  	/*
>  	 * AMD does not use memory delay throttle model to control
> diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> index cafebdff70dc..4562072b8ba6 100644
> --- a/fs/resctrl/ctrlmondata.c
> +++ b/fs/resctrl/ctrlmondata.c
> @@ -45,14 +45,6 @@ static bool bw_validate(char *buf, u32 *data, struct rdt_resource *r)
>  	int ret;
>  	u32 bw;
>  
> -	/*
> -	 * Only linear delay values is supported for current Intel SKUs.
> -	 */
> -	if (!r->membw.delay_linear && r->membw.arch_needs_linear) {
> -		rdt_last_cmd_puts("No support for non-linear MB domains\n");
> -		return false;
> -	}
> -
>  	ret = kstrtou32(buf, 10, &bw);
>  	if (ret) {
>  		rdt_last_cmd_printf("Invalid MB value %s\n", buf);
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index b63dc62690ca..66dc9813c888 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -249,7 +249,6 @@ enum membw_throttle_mode {
>   * @max_bw:		Maximum memory bandwidth value, used as the reset value
>   * @bw_gran:		Granularity at which the memory bandwidth is allocated
>   * @delay_linear:	True if memory B/W delay is in linear scale
> - * @arch_needs_linear:	True if we can't configure non-linear resources
>   * @throttle_mode:	Bandwidth throttling mode when threads request
>   *			different memory bandwidths
>   * @mba_sc:		True if MBA software controller(mba_sc) is enabled
> @@ -259,7 +258,6 @@ struct resctrl_membw {
>  	u32				max_bw;
>  	u32				bw_gran;
>  	u32				delay_linear;
> -	bool				arch_needs_linear;
>  	enum membw_throttle_mode	throttle_mode;
>  	bool				mba_sc;
>  };

-- 
Best regards,
Jinjie

