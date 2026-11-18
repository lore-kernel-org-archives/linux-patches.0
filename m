Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020365;
	b=QothtsM1Xa+zAto5pq2AWZLW8jC+VhniieTemdtNA/In0VamHP1ux/bHh6WbkZ99NeR9
	 /SAf8TAML3jaTTkIRQlRUUFte5VxY52+IjQLRjA9jVF7gPjA7Tv6Xid7y0vFjZ3JI9l2l
	 iA834j9T1Ij3ASr0dYsET1NOVujUJSShwBr58pwaQUw0Zn3JVnGN6qu8n+o/8txLGHwUZ
	 zSffSnbyrY85nRKlUUJF0fyNWd/4LAQIaWWoopNe4JP1YJsyCHhUt1DknBSKDo90ccrcd
	 qo/C8LAexNPiJMqCTP3JYG+UVxP8d+GmF5+8ht1u/eiYZ2eNsRrLAzaRaqUtWSy4PZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020365;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=7vXdMQjHN2tTjiwu1xZjW5W55857Pr3ga74FJdrpcT4=;
	b=hr8NlYqMS4GmkwOwYvreETX1XMFWprx/Kj/cFJGRkun8SPe7JaBTitv2GdhEawQIpnuy
	 RopDjQ9jKs5o90b6FlhASqCqZ28kiSa56STTaEUu5MNGsne73g7QbqCm2O3fp665LrbHz
	 r1BgAx48b7kQsXJvyaSXA7QYA/BvPqQhRJuXtYyNy+OXYpRxFHPjGGeiBC/ghfmYOxcUF
	 VbRRGGhKwgnz4FeuA7gERN5MV4y4ckE/1P+WqQPnjC2rsXy6SdNporIBryxIlBRsqkyx3
	 2RqTghck19tqHDQuGFv9zYwtnfXsl1takmXQl7ZTnHE1OnaHG7HkZ+Vi/HQF830qtbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=M1H70kVD;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1753606A325
	for <patches@lists.linux.dev>; Wed, 18 Nov 2026 16:46:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1753606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=M1H70kVD
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB298143D;
	Wed, 18 Nov 2026 08:46:00 -0800 (PST)
Received: from [10.2.212.8] (e134344.arm.com [10.2.212.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A83AC3F673;
	Wed, 18 Nov 2026 08:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795020363; bh=+PGfD/kjAVlPKhwHC0ibkDnGPTsKDJpyDcno2kNuw1Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=M1H70kVDxTMmz35+x9UnmPHajhkSeQKmH8+tgplZBxaWRm3/nE7C4Ph5OlqTlqXUO
	 jqO8sdiI53wrJSvPpAir4RX8ksqh7sYUDwm+xhWkZ2qr6vtag6fhGgTFnA/bbWXhPl
	 4P0BnCcX3JuYGxCqsFl76gsRqnAbcX+i9Ny3Fe0g=
Message-ID: <36314b21-6471-4e27-af4e-957c4eab0505@arm.com>
Date: Wed, 18 Nov 2026 16:46:00 +0000
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
Subject: Re: [PATCH v3 2/8] arm_mpam: resctrl: Use find_component() when
 allocating a domain
To: Reinette Chatre <reinette.chatre@intel.com>, james.morse@arm.com,
 Dave.Martin@arm.com, fenghuay@nvidia.com, ruanjinjie@huawei.com
Cc: tony.luck@intel.com, yu.c.chen@intel.com, babu.moger@amd.com,
 fustini@kernel.org, tan.shaopeng@fujitsu.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <cover.1794283825.git.reinette.chatre@intel.com>
 <c79ae06f66ab31db3425c537e765813711f3ceaa.1794283825.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <c79ae06f66ab31db3425c537e765813711f3ceaa.1794283825.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 10/11/2026 04:19, Reinette Chatre wrote:
> mpam_resctrl_alloc_domain() starts by checking that the resource's
> class has a component whose CPU affinity includes the CPU, and fails the
> domain allocation otherwise. When the resource supports allocation, that
> component also backs the control domain. The check uses an open-coded
> walk of the class's component list, while the same function uses
> find_component() to find the component backing each monitoring event.
> 
> The open-coded walk duplicates find_component(). It also holds the SRCU
> read lock until mpam_resctrl_alloc_domain() returns. However, the SRCU
> read lock is only needed while walking the component list, and
> find_component() holds it for that walk.
> 
> Replace the open-coded walk with find_component().
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
> - Shorten changelog. (Ben)
> ---
>  drivers/resctrl/mpam_resctrl.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 1b1e724ae040..a75f653031fd 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -1648,21 +1648,12 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>  	struct rdt_l3_mon_domain *mon_d;
>  	struct rdt_ctrl_domain *ctrl_d;
>  	struct mpam_class *class = res->class;
> -	struct mpam_component *comp_iter, *ctrl_comp;
> +	struct mpam_component *ctrl_comp;
>  	struct rdt_resource *r = &res->resctrl_res;
>  
>  	lockdep_assert_held(&domain_list_lock);
>  
> -	ctrl_comp = NULL;
> -	guard(srcu)(&mpam_srcu);
> -	list_for_each_entry_srcu(comp_iter, &class->components, class_list,
> -				 srcu_read_lock_held(&mpam_srcu)) {
> -		if (cpumask_test_cpu(cpu, &comp_iter->affinity)) {
> -			ctrl_comp = comp_iter;
> -			break;
> -		}
> -	}
> -
> +	ctrl_comp = find_component(class, cpu);
>  	/* class has no component for this CPU */
>  	if (WARN_ON_ONCE(!ctrl_comp))
>  		return ERR_PTR(-EINVAL);

