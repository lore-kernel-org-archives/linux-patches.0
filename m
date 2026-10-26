Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793018417;
	b=eWUTbjz6Tz29lf5A2+9h+S/ZPVPXNegzrmt1E93rkW72oIBRXNHivSF3QRu11po4zrm0
	 vvlel63isQtoPmGTT3AmJ3ZRijQ1Pum8QkVMI+X0wYLgud9Iy26zpGTBN+wNfXyG63KqN
	 LbzvRluwiTNzVzKMbs4Y+pHPqpX0B8JWM5qYTdl+NN17uO424zXKa7A23szAw41FngW6n
	 3yX7Oiaygz5IWpdhUjjzHZk5c4ET3DNGE64JX/I3PwCyGaNr4dsCFbPB/9E1PrEVVbPD+
	 W63bS+tX3PB71jhGMwybx9e5ArE/FsmPu8b1Eq5BPVN0ZB4bSK8Wfm23lA9l3eE387A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793018417;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=ihE3J0tMhcm8xJUaaHT/JhbOlKVqb9U5D80ilvr1OUQ=;
	b=0ba1hYsRJ/j/LaMRQO91DCVTfesGTHIJWfUlhcepKqttfdLLY57BVAAYbTFhegnUJ0V6
	 u/hKRr2fydESjMRQLEYXZnA81rAYQ8S8I2O96dFq26fPJUVHkEP3Uv5nVScOKtWgtBObU
	 Aw+NQTb63EzTchGHDiWgxFz+Mb5toGC4+KG+TwpSZjWgveMqLmRf+pjqIOp7xhEH74H36
	 0HpiLTY672qVQ7gKyuY0vb0X63gMXJO6YgTAmEhiJeCT+CX9IdADUTNCTAVIwveg1cbwA
	 q9XlSrHvL+x956Yz9utoF8MTpcrMoh1dSAHz/lZPl8YvtHD0sOfjYUTaCM7RQ9TlrBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=uNqZM3HM;
	arc=none smtp.remote-ip=113.46.200.226
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D847606A329
	for <patches@lists.linux.dev>; Mon, 26 Oct 2026 12:40:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D847606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=uNqZM3HM
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ihE3J0tMhcm8xJUaaHT/JhbOlKVqb9U5D80ilvr1OUQ=;
	b=uNqZM3HMTQk9Xu0sNLqrju0QZDjawzqeIsP44Uzit3ceBjCo26aeQZ5A0ydLfrwhewGbTQkXv
	e8bfZW6CITdgUHVckYH7sONZYnXt/JUb3hMIw4EGjTCeSww7wtZYWv/JyKKWEjklt62bJFtQsYC
	e5HBTHxLlvihKPry+4HlAY8=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4jCtW470pPzKm9S;
	Mon, 26 Oct 2026 20:40:00 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id D49CB40586;
	Mon, 26 Oct 2026 20:40:08 +0800 (CST)
Received: from [10.67.110.68] (10.67.110.68) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 26 Oct
 2026 20:40:08 +0800
Message-ID: <d77ead72-4c5c-42bb-b002-f5928c2ae496@huawei.com>
Date: Mon, 26 Oct 2026 20:40:07 +0800
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
Subject: Re: [RFC PATCH v2 06/10] arm_mpam: resctrl: Rename struct
 mpam_resctrl_dom to mpam_resctrl_ctrl_dom
To: Reinette Chatre <reinette.chatre@intel.com>, <ben.horgan@arm.com>,
	<james.morse@arm.com>, <Dave.Martin@arm.com>, <fenghuay@nvidia.com>
CC: <tony.luck@intel.com>, <yu.c.chen@intel.com>, <babu.moger@amd.com>,
	<fustini@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1792443633.git.reinette.chatre@intel.com>
 <fe38eaea025896ace1baa536fa8e73b409f22b9a.1792443633.git.reinette.chatre@intel.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <fe38eaea025896ace1baa536fa8e73b409f22b9a.1792443633.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk200008.china.huawei.com (7.202.194.74)



在 2026/10/20 6:07, Reinette Chatre 写道:
> struct mpam_resctrl_dom holds the control domain of a resource, while
> its monitoring domain is held by struct mpam_resctrl_mon_dom. Unlike the
> name of the monitoring structure, the name struct mpam_resctrl_dom does
> not say which kind of domain the structure holds.
> 
> Rename it to struct mpam_resctrl_ctrl_dom to match its monitoring
> counterpart.
> 
> No functional change.

LGTM
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>

> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  drivers/resctrl/mpam_internal.h |  2 +-
>  drivers/resctrl/mpam_resctrl.c  | 18 +++++++++---------
>  2 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
> index 1df439ecb055..dc304e4e0dc0 100644
> --- a/drivers/resctrl/mpam_internal.h
> +++ b/drivers/resctrl/mpam_internal.h
> @@ -432,7 +432,7 @@ struct mpam_msc_ris {
>  	struct mpam_garbage	garbage;
>  };
>  
> -struct mpam_resctrl_dom {
> +struct mpam_resctrl_ctrl_dom {
>  	struct mpam_component		*ctrl_comp;
>  	struct rdt_ctrl_domain		resctrl_ctrl_dom;
>  };
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index ce5519635c51..022920be1862 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -1375,7 +1375,7 @@ u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
>  	struct mpam_config *cfg;
>  	struct mpam_props *cprops;
>  	struct mpam_resctrl_res *res;
> -	struct mpam_resctrl_dom *dom;
> +	struct mpam_resctrl_ctrl_dom *dom;
>  	enum mpam_device_features configured_by;
>  
>  	lockdep_assert_cpus_held();
> @@ -1384,7 +1384,7 @@ u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
>  		return resctrl_get_default_ctrl(r);
>  
>  	res = container_of(r, struct mpam_resctrl_res, resctrl_res);
> -	dom = container_of(d, struct mpam_resctrl_dom, resctrl_ctrl_dom);
> +	dom = container_of(d, struct mpam_resctrl_ctrl_dom, resctrl_ctrl_dom);
>  	cprops = &res->class->props;
>  
>  	/*
> @@ -1435,7 +1435,7 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
>  	struct mpam_config cfg;
>  	struct mpam_props *cprops;
>  	struct mpam_resctrl_res *res;
> -	struct mpam_resctrl_dom *dom;
> +	struct mpam_resctrl_ctrl_dom *dom;
>  
>  	lockdep_assert_cpus_held();
>  	lockdep_assert_irqs_enabled();
> @@ -1448,7 +1448,7 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
>  	 * resctrl_arch_update_domains() relies on this.
>  	 */
>  	res = container_of(r, struct mpam_resctrl_res, resctrl_res);
> -	dom = container_of(d, struct mpam_resctrl_dom, resctrl_ctrl_dom);
> +	dom = container_of(d, struct mpam_resctrl_ctrl_dom, resctrl_ctrl_dom);
>  	cprops = &res->class->props;
>  
>  	if (mpam_resctrl_hide_cdp(r->rid))
> @@ -1618,7 +1618,7 @@ static struct mpam_component *find_component(struct mpam_class *class, int cpu)
>  static int mpam_resctrl_setup_ctrl_domain(unsigned int cpu,
>  					  struct rdt_resource *r,
>  					  struct mpam_component *comp,
> -					  struct mpam_resctrl_dom *dom)
> +					  struct mpam_resctrl_ctrl_dom *dom)
>  {
>  	struct rdt_ctrl_domain *ctrl_d = &dom->resctrl_ctrl_dom;
>  	int err;
> @@ -1710,10 +1710,10 @@ static struct mpam_resctrl_mon_dom *mpam_resctrl_get_mon_domain_from_cpu(int cpu
>  	return NULL;
>  }
>  
> -static struct mpam_resctrl_dom *
> +static struct mpam_resctrl_ctrl_dom *
>  mpam_resctrl_get_ctrl_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
>  {
> -	struct mpam_resctrl_dom *dom;
> +	struct mpam_resctrl_ctrl_dom *dom;
>  	struct rdt_resource *r = &res->resctrl_res;
>  
>  	lockdep_assert_cpus_held();
> @@ -1730,7 +1730,7 @@ static void mpam_resctrl_add_cpu_ctrl_domain(unsigned int cpu,
>  					     struct mpam_resctrl_res *res)
>  {
>  	struct rdt_resource *r = &res->resctrl_res;
> -	struct mpam_resctrl_dom *dom;
> +	struct mpam_resctrl_ctrl_dom *dom;
>  	struct mpam_component *comp;
>  
>  	lockdep_assert_held(&domain_list_lock);
> @@ -1780,7 +1780,7 @@ static void mpam_resctrl_remove_cpu_ctrl_domain(unsigned int cpu,
>  						struct mpam_resctrl_res *res)
>  {
>  	struct rdt_resource *r = &res->resctrl_res;
> -	struct mpam_resctrl_dom *dom;
> +	struct mpam_resctrl_ctrl_dom *dom;
>  
>  	lockdep_assert_held(&domain_list_lock);
>  

-- 
Best regards,
Jinjie

