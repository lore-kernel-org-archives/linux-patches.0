Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718901;
	b=WHopyjdjFQ7XnD9wguc3zIpoHJlvs6cORBT1C+cAS1s0gRSRyLORaN9dhczMGWE0KEnr
	 Ih35cTpNxQMyI0cJc4S3MjBfochYgD6L5AezxYx1VW6T/aOS5MdqxgyDVVxyLMEMHTwj1
	 QLgo+DUTXQZA1FnUa7pOp94LGxZqPyroCKXzDXq0zw4D/VfMRVWP2ExCfr0gZFaLRlBzg
	 UpAblaorp2H2BOS58SauttG6ywTfl1HLAs/jm3A9FtBPMO71ZsejHxUfbmYCD2i4PZedN
	 RATib1U8PhFbKa9wed1PnyMaAkEgUo7mkLjk0kVn4P5EnolTRTOG6iq7e68M/zOFkVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718901;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=fpeI5xCCAbNRv2edwRMBg6hx8Gz/r5TkEihn42aKnQs=;
	b=HN/09+NMYji2RE/TJBXV6oGH8+w64MOyk/5ZJP1PLXwUrGiYHPxYTg4aF0KPqNgCmmNm
	 hXOQSOZzsAennfm7/188d0gn9fB77GY8q5ODa+yr6pndksBjhdNlC5+//KKHid5FOSHO/
	 vezFRyAiFXz2kHdwRPjhWLI1aeYaBsTcViuqSyZb71zeTx4U8VAYl/d8+jmzB+DmiJe4p
	 ilxPKWutv9UBuOIamcKwLr+aPww73dP04AUVDLa+GSmoO0gr0tfsl7UFLKY8SL8BeGkTg
	 xxdj6VBb7q0WxPUFGF5N9HoTdZ53h0p+ijKhObT3zyyw5RkRibIaHseMz204n1BPrug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=GApZLW3s;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 260ED606EEBC
	for <patches@lists.linux.dev>; Tue,  3 Nov 2026 15:14:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 260ED606EEBC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=GApZLW3s
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0EEF31595;
	Tue,  3 Nov 2026 07:14:51 -0800 (PST)
Received: from [10.211.55.3] (unknown [10.57.89.242])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 547F43F673;
	Tue,  3 Nov 2026 07:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793718894; bh=3HKe2lu0Za8JcJiKkaHesTFYMnbN4ggiqN7ow3agR9g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GApZLW3s4CjcqNBAmeZD9b1rQ0nDB2NN6EHkG4ncFPJypEo6wyyyi27TgLMy8kx8m
	 l8ANWIogR3y740vLkrqcG8x7igY4XgZukA81JYjbO1E5XBr/Fw3HgfC+irtrK7jat+
	 bjQeZJ4eicPcxS93SbbjZRRLQOvEEk9Fe5oP/FFc=
Message-ID: <e958ad39-d81c-4410-ad69-bdcc975219cb@arm.com>
Date: Tue, 3 Nov 2026 15:14:50 +0000
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
Subject: Re: [RFC PATCH v2 02/10] arm_mpam: resctrl: Rename ctrl_comp in
 mpam_resctrl_alloc_domain()
To: Reinette Chatre <reinette.chatre@intel.com>, james.morse@arm.com,
 Dave.Martin@arm.com, fenghuay@nvidia.com
Cc: tony.luck@intel.com, yu.c.chen@intel.com, babu.moger@amd.com,
 fustini@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1792443633.git.reinette.chatre@intel.com>
 <adeb2b33540572b5da5edb79d2ddacc9fc098e01.1792443633.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <adeb2b33540572b5da5edb79d2ddacc9fc098e01.1792443633.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 19/10/2026 23:07, Reinette Chatre wrote:
> mpam_resctrl_alloc_domain() looks up the component of the resource's
> class that contains the CPU and fails the domain allocation if there is
> none. The component is held in a local variable named ctrl_comp and, when
> the resource supports allocation, it also backs the control domain.
> 
> The lookup and its check apply to every resource, including one that
> supports only monitoring. For such a resource the component does not
> back a control domain, so the name ctrl_comp is misleading. The name also
> makes a comment in the same function ambiguous. The comment notes that
> there may be no ctrl_comp for the L3, which is true of the control
> domain's component but contradicts the local variable, which always
> refers to a component once the lookup succeeds.
> 
> Rename the local variable to comp. Keep the ctrl_comp name for the
> control domain's reference to its component because it only ever refers
> to the component that backs the control domain. Leave the comment
> unchanged since it now unambiguously refers to that component.
> 
> No functional change.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Makes sense.

Reviewed-by: Ben Horgan <ben.horgan@arm.com>

> ---
>  drivers/resctrl/mpam_resctrl.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 3d5f90f9f1f3..b07e5dd895dd 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -1623,14 +1623,14 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>  	struct rdt_l3_mon_domain *mon_d;
>  	struct rdt_ctrl_domain *ctrl_d;
>  	struct mpam_class *class = res->class;
> -	struct mpam_component *ctrl_comp;
> +	struct mpam_component *comp;
>  	struct rdt_resource *r = &res->resctrl_res;
>  
>  	lockdep_assert_held(&domain_list_lock);
>  
> -	ctrl_comp = find_component(class, cpu);
> +	comp = find_component(class, cpu);
>  	/* class has no component for this CPU */
> -	if (WARN_ON_ONCE(!ctrl_comp))
> +	if (WARN_ON_ONCE(!comp))
>  		return ERR_PTR(-EINVAL);
>  
>  	dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
> @@ -1638,10 +1638,10 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>  		return ERR_PTR(-ENOMEM);
>  
>  	if (r->alloc_capable) {
> -		dom->ctrl_comp = ctrl_comp;
> +		dom->ctrl_comp = comp;
>  
>  		ctrl_d = &dom->resctrl_ctrl_dom;
> -		mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, r->rid, &ctrl_d->hdr);
> +		mpam_resctrl_domain_hdr_init(cpu, comp, r->rid, &ctrl_d->hdr);
>  		ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
>  		err = resctrl_online_ctrl_domain(r, ctrl_d);
>  		if (err)

