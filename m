Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.219
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793020507;
	b=zzcIzIzQHhno6MsguixLV5FKdOnxiPTiX6zoThtP6V+8a5Ck7qPd4WYGw9wQauKcoI4K
	 yf3kYWoyV6sacdNJSRY1OWkmDImQWWVkz1s2VhfScnFviiNFlGK+hofZ4TLxaVIeXd0NW
	 1jff0PTWhw3kLXoIQUwN+kCYHmydlDsg1nE7kCjG71JdqZg493VcVgqjZVT6KgLckd5i6
	 KqnjI0RWwubKdwP8SFEx2ddlKztU7zDl6JPU4AUnQzAAAfgGjlc3H7YULfhR7avyYOjZN
	 1DEH1KHda1HcvcuOqz9kcKVTTSlakhC7OFsKe3s/R94J43zblOPPEKwzEwZkLyj0RQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793020507;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=LChBFc7NyA4kYe4eWX6P8OUX1NQ9dlfzg5VF5MaM0QQ=;
	b=1YGXeGmTFf0HYfZAuRKWkdZ4DLf3tiDeNxcBCx3t6NuII/SX3QJnI0H5pZjSVyChCfbs
	 ChHtgnwJtNVz0T/G610KFZs+8ZURY3QwbkNi8SgtWMX9kaK3BPmJoW4iJiRJV8T6MUwan
	 Iblg0PUIVtzNY9uNlnqlxePcbZ1e7FX7dQWlaFllLa1FjQMX6wqs3SbUTUGnDC+XRku3g
	 wa2FnR3SbFQ8ya//yt2ugonbshdFkPlyBaphcj0v0JBP42cLAp9w75Exsmy4rH7jSmpeW
	 /DizVoSc7nBZ+qU6OQ2f/eIhhv9KVUjHdCO1uMSchw+2GS9YwLT5/+yoqepX/nnuqkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=WTkj1Hz9;
	arc=none smtp.remote-ip=113.46.200.219
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE27B606A320
	for <patches@lists.linux.dev>; Mon, 26 Oct 2026 13:15:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE27B606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=WTkj1Hz9
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=LChBFc7NyA4kYe4eWX6P8OUX1NQ9dlfzg5VF5MaM0QQ=;
	b=WTkj1Hz98KtbFvD5jQZgc5A9tiEOtCFlXYcuRZDUmncC+ctfEjtQL7bIKLjyuGoa8fnjIv3TP
	I3dhb7S9tqk3koarvwaJAiz1JTH+SXMXwaJM9x3a0pOfMtPoyoZArP8zf4lCX8Pj1xZW6SJltVM
	DrodVf9ZMa0Ao8lFm8Z+Nlk=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4jCvHK44Bzz1prQ6;
	Mon, 26 Oct 2026 21:14:53 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 925744056D;
	Mon, 26 Oct 2026 21:15:00 +0800 (CST)
Received: from [10.67.110.68] (10.67.110.68) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 26 Oct
 2026 21:14:59 +0800
Message-ID: <ce191ccd-1948-448f-8279-b30008191b8b@huawei.com>
Date: Mon, 26 Oct 2026 21:14:59 +0800
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
Subject: Re: [RFC PATCH v2 07/10] arm_mpam: resctrl: Warn when no monitoring
 component is found for a CPU
To: Reinette Chatre <reinette.chatre@intel.com>, <ben.horgan@arm.com>,
	<james.morse@arm.com>, <Dave.Martin@arm.com>, <fenghuay@nvidia.com>
CC: <tony.luck@intel.com>, <yu.c.chen@intel.com>, <babu.moger@amd.com>,
	<fustini@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1792443633.git.reinette.chatre@intel.com>
 <1c68a6ae981095ec93250cf0e394bb4df15c7e66.1792443633.git.reinette.chatre@intel.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <1c68a6ae981095ec93250cf0e394bb4df15c7e66.1792443633.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk200008.china.huawei.com (7.202.194.74)



在 2026/10/20 6:07, Reinette Chatre 写道:
> Setting up a monitoring domain fails if no monitoring class has a
> component that contains the CPU. This is not expected to happen: a
> resource only supports monitoring when at least one monitoring class
> was picked, and only classes that cover all possible CPUs are picked
> for monitoring.
> 
> The failure path calls WARN_ON_ONCE(0), which never warns. The
> unexpected failure is thus silent and the CPU is left without a
> monitoring domain with nothing reporting why.
> 
> Warn when no monitoring component is found for the CPU, as is already
> done when setting up a control domain finds no component in the
> resource's class.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  drivers/resctrl/mpam_resctrl.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 022920be1862..63c5bf45856d 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -1665,10 +1665,8 @@ static int mpam_resctrl_setup_mon_domain(unsigned int cpu,
>  		if (mon_comp)
>  			any_mon_comp = mon_comp;
>  	}
> -	if (!any_mon_comp) {
> -		WARN_ON_ONCE(0);
> +	if (WARN_ON_ONCE(!any_mon_comp))
>  		return -EFAULT;
> -	}

Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>

>  
>  	mpam_resctrl_domain_hdr_init(cpu, any_mon_comp, r->rid, &mon_d->hdr);
>  	mon_d->hdr.type = RESCTRL_MON_DOMAIN;

-- 
Best regards,
Jinjie

