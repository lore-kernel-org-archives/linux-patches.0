Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718096;
	b=fBCT/LIVEAZdNDSIvldQTSdVbG2h5JsuxWQ18OtpV2dyIMU/g3P0hzDWOU3smsHq22jD
	 abahDOFwz2Db2kOewCPpxn3z27y4gKD9WfsxAl+pIPvV1vNonfQRPVipv2lvu1kT+qDPs
	 ntRPPcH2pZOT888xWUIqdb+v7rCK4kT+bNU9127qUWMR1P+fHoB/b0+0+iTMVGUM8iI/f
	 y3FFo2usMrI65EmgJRjSr/9CVMNC+pM/y3vbN5955Oy3kqNoIBkZ+8C9NaqKKSez1JKPr
	 SVMCbZ5FJBErnhHdqfMsXQu+frxaH9MPS+eoSaDQ048MwlPSnQTioavMlhoMggBGA6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718096;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=rEef8FS7q0lvCkkrIL907JgA/rs6+IUe1wrxy5V7xDA=;
	b=PSuUxKSNr43Vim7IpAsjiEqB+EJiAj+TG+v2KL17fdScst7yUNaw3q9viuRIhuW1BjCS
	 W97jBnAMZozJhu5QZi62dzcTh2V+ZzZ/wEMagoydKgJoZLXJBcc+owpWqv8AGTNMNzRLP
	 CldX+vF/78o6g/Jc+5iE5f6wvpFCqoP66wzVrYPkIGdG1rO6dwmXp+om38URJ0Lrcejvk
	 HGWx3MuGWwmkOBuSZF10GtqpgFCehmUUQPkOlHjyerk0E3l+NbJY/4WFJig1E6hwFfbsZ
	 sMiwSbn3VsSF2XLxlj0x9jfIzy55FXXMywLuZTot7swWqMoy2Xk9PLb0yEZchjuIrWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ZnDuSfKU;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2867B60A6F4F
	for <patches@lists.linux.dev>; Tue,  3 Nov 2026 15:01:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2867B60A6F4F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ZnDuSfKU
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F3E3C1595;
	Tue,  3 Nov 2026 07:01:30 -0800 (PST)
Received: from [10.211.55.3] (unknown [10.57.89.242])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 521733F628;
	Tue,  3 Nov 2026 07:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793718094; bh=CG6q8wsIPq+ixhkuVkm9929Wn3zQbR8LSPlxbsnxgtI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZnDuSfKUzzE9MrbULG40+AhOWauF13XR9ar+iCOPiMJNHMlvLoOqwPvWBa47p0fK1
	 8UJSFcHsd+Px1RBaKuZYevFUjD0Ba7z8RiIURshnbBLyoPtH8jIV86ji1j1uml8ztU
	 RsMBYlU5UXEbTrhovtUPjd5a7Em9ROyM3SdqHRUo=
Message-ID: <308b326e-9fc8-4d49-9c85-c3b9cb9288f3@arm.com>
Date: Tue, 3 Nov 2026 15:01:30 +0000
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
Subject: Re: [RFC PATCH v2 01/10] arm_mpam: resctrl: Use find_component() when
 allocating a domain
To: Reinette Chatre <reinette.chatre@intel.com>, james.morse@arm.com,
 Dave.Martin@arm.com, fenghuay@nvidia.com
Cc: tony.luck@intel.com, yu.c.chen@intel.com, babu.moger@amd.com,
 fustini@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1792443633.git.reinette.chatre@intel.com>
 <94ddff51b91f4a51965baf0384c2368e292c1a8c.1792443633.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <94ddff51b91f4a51965baf0384c2368e292c1a8c.1792443633.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

The change seems good but I think the commit message can be cut down at bit.

On 19/10/2026 23:07, Reinette Chatre wrote:
> mpam_resctrl_alloc_domain() starts by checking that the resource's
> class has a component whose CPU affinity includes the CPU, and fails the
> domain allocation otherwise. When the resource supports allocation, that
> component also backs the control domain. The check uses an open-coded
> walk of the class's component list, while the same function uses
> find_component() to find the component backing each monitoring event.
> 
> The open-coded walk duplicates find_component(). It also holds the SRCU
> read lock until mpam_resctrl_alloc_domain() returns, 

, -> .

which suggests that
> the component needs this protection while the domain is set up.
> 
> The component does not need it. Components are freed only when an MSC
> fails to probe, in which case MPAM is never enabled and no resctrl
> domain is created, or by mpam_disable(), which first removes the CPU
> hotplug callbacks and thereby tears down all resctrl domains. A component> therefore outlives every domain that refers to it.

You can drop the above section. The SRCU read lock, as you say, is just
intended for walking the list and modulo any bugs we can just take that
as read.

However, ...> The SRCU read lock is
> only needed while walking the component list, and find_component() holds
> it for that walk. 


In addition, mpam_resctrl_alloc_domain() only runs
> from MPAM's CPU hotplug startup callback, which already holds the SRCU
> read lock throughout.

I think this can go from the commit message too. It is interesting that
you point it out though as that is unexpected. I should have used
scoped_guard() in the case you are removing and in mpam_cpu_online()
rather than guard() so that the lock can be dropped as early as possible
and make the intent of the lock clearer.

Thanks,

Ben

> 
> Replace the open-coded walk with find_component().
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  drivers/resctrl/mpam_resctrl.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 9cec5843e8fa..3d5f90f9f1f3 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -1623,21 +1623,12 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
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

