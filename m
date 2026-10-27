Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.224
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793090058;
	b=EE4Tj2s40Qk1IBUShzWSrfgSn6h7oLmIKfSDWgFKUX9lUr/DvJIVp50lGfCRTl31dFM2
	 +Whk+VF19xHioDlV6Z3x2wQXw5iQVljABOj8OztM1RPD+x+bixbZe+lUjCZt8TbRVRDD/
	 1SwM3B6++/J2zq1xkUSnEilnGm1J77NRqKoGNaazFm4nu/MBsL5xpWmedSgvAB/dyC9aL
	 cozrf2wrJjzFqHfKOUbEA0GQyeRsoer+QZAAxwS6p6NaMW8C15blje6slXJAoJWMQkH2t
	 sIu2TqVtwcfZdSUKEr8g2JKL6aQBM7Q/24Jekm0Zbqo2g5yKfgx/LrbcS3f/szlkXMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793090058;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=Paz70CUE45Za5sCIaBCXSjkvwQezPROW6m2aMims3AY=;
	b=P7jw+RAY4MeD/9tIpvTRyYHZWLSzkiJwVlt/V792/HiSJ2Q9YxFFRFpezfd9AUdeDNVN
	 jM24p+W1uYgYXrUnL6IJEf1ncTtB022lsixyKf6ZsMSJglNALjEZFlEnKHXALwBnqUat5
	 DGH13FpJqPm7zudlIaMSMdWJ8e7J268vowF8AJAtMruQxVvN6YMMpLbNLpemHUCE/g4sm
	 gR9JGc6hVtSbTbKAHm49mgishCR7vC59cag3vjgwems3HffIbvSpZ2jB4q1x+nEWP7Go6
	 cJl4JLGjJSiz+qIyBMidElsd4eALVc2hW2DBsyrcgI8ZghvWtFrkC+w/xTj6JN2+c4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=QCjKH4ww;
	arc=none smtp.remote-ip=113.46.200.224
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C313C606A31D
	for <patches@lists.linux.dev>; Tue, 27 Oct 2026 08:34:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C313C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=QCjKH4ww
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Paz70CUE45Za5sCIaBCXSjkvwQezPROW6m2aMims3AY=;
	b=QCjKH4wwbxLVvROikxS5bkrF++9leg0mfIB3QR4giEMGIb82tHm8U7zlam2teLcUtmubZcl5E
	n6p2BKIvhiD6BVQmDLxEbFV+W7x0PTmYarRsmCkPHs3YazFtigkV8ko/GHg87JJOHq9sMKQ9P7C
	bf2aRIpweJ/1pXyMeDS+Scs=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4jDP0p0FlXz1cyQt;
	Tue, 27 Oct 2026 16:34:02 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 2839D40563;
	Tue, 27 Oct 2026 16:34:08 +0800 (CST)
Received: from [10.67.110.68] (10.67.110.68) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 27 Oct
 2026 16:34:07 +0800
Message-ID: <48a17188-cddb-4759-b5df-2ba5691f17ac@huawei.com>
Date: Tue, 27 Oct 2026 16:34:06 +0800
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
Subject: Re: [PATCH v2 4/5] fs/resctrl: Drop unnecessary is_mba_linear()
 helper
To: Reinette Chatre <reinette.chatre@intel.com>, <tony.luck@intel.com>,
	<ben.horgan@arm.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <fustini@kernel.org>,
	<fenghuay@nvidia.com>, <peternewman@google.com>, <yu.c.chen@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1791406459.git.reinette.chatre@intel.com>
 <816855328d87740b2cb720215d222702abba4b0f.1791406459.git.reinette.chatre@intel.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <816855328d87740b2cb720215d222702abba4b0f.1791406459.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk200008.china.huawei.com (7.202.194.74)



在 2026/10/8 5:06, Reinette Chatre 写道:
> is_mba_linear() assumes it operates on the MBA resource and returns whether
> the resource's delay values are linear. There is only one caller that
> separately makes the same assumption.
> 
> Avoid duplicating the resource assumptions and let the only caller access
> the needed property directly.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Reviewed-by: Chen Yu <yu.c.chen@intel.com>
> Reviewed-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes from RFC v1:
> - RFC v1 made bandwidth delay a resource property. That change was dropped
>   and this cleanup is all that remained.
> 
> Changes since v1:
> - Add Chenyu and Ben's Reviewed-by tags.
> - Clarify "resource is linear" vs. "resource's delay values are linear".
> ---
>  fs/resctrl/rdtgroup.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 68be9b903ac6..821c6e2b10f4 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -2577,11 +2577,6 @@ mongroup_create_dir(struct kernfs_node *parent_kn, struct rdtgroup *prgrp,
>  	return ret;
>  }
>  
> -static inline bool is_mba_linear(void)
> -{
> -	return resctrl_arch_get_resource(RDT_RESOURCE_MBA)->membw.delay_linear;
> -}
> -
>  static int mba_sc_domain_allocate(struct rdt_resource *r, struct rdt_ctrl_domain *d)
>  {
>  	u32 num_closid = resctrl_arch_get_num_closid(r);
> @@ -2621,7 +2616,7 @@ static bool supports_mba_mbps(void)
>  	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_MBA);
>  
>  	return (resctrl_is_mbm_enabled() &&
> -		r->alloc_capable && is_mba_linear() &&
> +		r->alloc_capable && r->membw.delay_linear &&

LGTM
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>

>  		r->ctrl_scope == rmbm->mon_scope &&
>  		!rmbm->mon.mbm_cntr_assignable);
>  }

-- 
Best regards,
Jinjie

