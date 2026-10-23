Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.217
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792742937;
	b=GmVqMDKBKxl6mgsUe2es1g9DfAkrwxZu78lXCk7z24iHoQpghzlKaNTyfxP+caoj0mBy
	 w1M/rclUFXEnkyoKLGX3LCFZxq/w+DMR/CXnldlQbkYuyrqO2QH6BYsCbgHcxWAnrrPwv
	 uIJlHJAskr10fNdgdGCt97H4ojtS9HBD7lu+578PllnpZnVSBKRxou9HHaH5h7s7Zqqhd
	 17+0QxYIzdiHqhWkPx+awZucwSlSuMOP4N5OJWF/iMbD1Xhg5erhKQCyCU2l7qxpq5we2
	 2ZOgoUNL2fPXYoTjgufvldfN5uvslE8w9YoBShRsZPQNVJ6yI3okAEHL129GjBxbGmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792742937;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=1RVh2/Dbz81D9r2JCs/p2pOJTWf7dMj+/zj30/kv+Rg=;
	b=3NAK0PETIY/5ylsmqKzVRh6xZCChPDQShQiwBFQNF6h5qWBSDToxn+qjlmpMte1BbVJM
	 VM0uOH5WSc+km3fOoBYes1Iu00OpOTs8XgulHmOirBvSwuvPq0zQ9M0ypDpJuBWW6AoKk
	 2Zu6VW7YkzTf7J525X3tYiu1ua7/+FTnA6llK4Ym94Mn/vTA9g55WGHjCiudx3N0LQKTl
	 WxqoCKdEYtndoxHCEzj0o2zAQxgA5gEBjutDzwI9wLC7X5nqhN51jKE3SJbS3aIJPONVy
	 B8ZA8kN1/4N8MuHucEJ7ShlnIqYa7/owoWzkLEDMoIYE4Ry9QxxqozIsYyu/loLiX6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=OXYQntCY;
	arc=none smtp.remote-ip=113.46.200.217
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5AC606A321
	for <patches@lists.linux.dev>; Fri, 23 Oct 2026 08:08:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E5AC606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=OXYQntCY
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1RVh2/Dbz81D9r2JCs/p2pOJTWf7dMj+/zj30/kv+Rg=;
	b=OXYQntCY9JSvb+0ZyqwbzKWoNTRqfD1P+SAsk+lz3UDzx+yL1GsN/j2pFCeUYIjmZaMwhJBV+
	2dkR+JpAfJcWMxzM4i/pzVyMBCW2IEukCypSQLhe0Zr2geBNE61Q2hnzHPXmARGEul6k1dQmlcd
	oyU46dFciaSQpW0bxd1OmtU=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4j9wdQ2vPZzcb41;
	Fri, 23 Oct 2026 16:08:42 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id DD7C840575;
	Fri, 23 Oct 2026 16:08:46 +0800 (CST)
Received: from [10.67.110.68] (10.67.110.68) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 23 Oct
 2026 16:08:45 +0800
Message-ID: <63de9d6d-96c9-401e-963e-0e3183ef5fd1@huawei.com>
Date: Fri, 23 Oct 2026 16:08:45 +0800
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
Subject: Re: [RFC PATCH v2 02/10] arm_mpam: resctrl: Rename ctrl_comp in
 mpam_resctrl_alloc_domain()
To: Reinette Chatre <reinette.chatre@intel.com>, <ben.horgan@arm.com>,
	<james.morse@arm.com>, <Dave.Martin@arm.com>, <fenghuay@nvidia.com>
CC: <tony.luck@intel.com>, <yu.c.chen@intel.com>, <babu.moger@amd.com>,
	<fustini@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1792443633.git.reinette.chatre@intel.com>
 <adeb2b33540572b5da5edb79d2ddacc9fc098e01.1792443633.git.reinette.chatre@intel.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <adeb2b33540572b5da5edb79d2ddacc9fc098e01.1792443633.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk200008.china.huawei.com (7.202.194.74)



在 2026/10/20 6:07, Reinette Chatre 写道:
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

Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>


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

-- 
Best regards,
Jinjie

