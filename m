Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.218
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793088466;
	b=SU0TwbvBmQbNT3I02vcKbYZ7WMWBVge67uL+EJ7ARYvpX0FGryPCsUXxaTSA1pes9reP
	 4vD/McmKNQEqu62UPCHsv9M2ZKLqwpvk5aiC7FpeLNLDUEnXzs+cef6aYB9LgBKw1e3f9
	 lS0dnT6louSX7ATyH+BPN4oJyBSmpWhlZMuGEEqdo8U8mnZnam8SBJ5imN7AoPQWc8Y7w
	 8D9oJNGggTcYthaOuhpoLlhtT76H1qUv2g81AM6o/fxmvBw665ueYENYzM8+rd0k95M9n
	 +1WbZ7P4+HCTqjJ8arXv4T4fHPy9hKyGL+eKTKLObz6YRKRr9PBsfk60UKTNDzu2THA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793088466;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=0243sCBpCNcmZDAWTzlEENPZT2gXQuSJvy2mR0kQ7DA=;
	b=kb88UOtFD9PxG8h70OkKdYbGIeYyzLWpCpWmCPbelfAc4ufB4tN+zMCXBf2FA8IaytsA
	 6Ub/wDpLuR7+7qPX7pJPTG/eQ6mKivcM43Gp9tgKj88G9qJhLXn5a6G9i9hgelMsFSriN
	 iNlxrPsK3JNsuoz9A7oWHHfmDzgb4J4xvR8FP+uQy2qfXlpixJ26M1BsR8mzK7ebzZ303
	 g/LyhTlTVt5djEVGJvS8fsChdR6jhpHOPBSPxJkcJT1MFGbT8qiWFmXpsPdh5jrSI7XAd
	 3xWpwJiNEBKzi3j3vWTghrbT93GCFySWh/bwfHh3faag6HlkpoSxje3CcbDpSlFTqWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	arc=none smtp.remote-ip=113.46.200.218
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A4F606A32C
	for <patches@lists.linux.dev>; Tue, 27 Oct 2026 08:07:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77A4F606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0243sCBpCNcmZDAWTzlEENPZT2gXQuSJvy2mR0kQ7DA=;
	b=bA5BgE5ILkwOFIkh8UBXWjEQC9n5v7dblWsgX27NCKFjPz8B4BLTy8l581wEltSJmyJVffTfY
	ppcaZMkelRaFEKGveLhUJhr6g7/4H6ghrBAk8etNkPmz59XXz/HNXmAvAl5pO0j7rgxzbAhKCUX
	8Se+qUSTrQuDf2/9VNBY78Q=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4jDNQ33TsdzpSt7;
	Tue, 27 Oct 2026 16:07:23 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 27F4540538;
	Tue, 27 Oct 2026 16:07:34 +0800 (CST)
Received: from [10.67.110.68] (10.67.110.68) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 27 Oct
 2026 16:07:33 +0800
Message-ID: <2b7e4de7-ad06-40a1-92e0-479b3d7812af@huawei.com>
Date: Tue, 27 Oct 2026 16:07:32 +0800
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
Subject: Re: [PATCH v2 1/5] x86,fs/resctrl: Remove unused non-linear bandwidth
 delay mapping
To: Reinette Chatre <reinette.chatre@intel.com>, <tony.luck@intel.com>,
	<ben.horgan@arm.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <fustini@kernel.org>,
	<fenghuay@nvidia.com>, <peternewman@google.com>, <yu.c.chen@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1791406459.git.reinette.chatre@intel.com>
 <103c954ead8905b3582b6ade76e2082dffb01fc6.1791406459.git.reinette.chatre@intel.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <103c954ead8905b3582b6ade76e2082dffb01fc6.1791406459.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk200008.china.huawei.com (7.202.194.74)



在 2026/10/8 5:06, Reinette Chatre 写道:
> Intel MBA throttles memory bandwidth with delay values, while resctrl
> exposes memory bandwidth to user space as a percentage. When delay values
> are linear there is a direct mapping between the two. Support for
> non-linear delay values would need a pre-calibrated table mapping
> percentages to delay values.
> 
> Commit
> 
>   05b93417ce5b ("x86/intel_rdt/mba: Add primary support for Memory Bandwidth Allocation (MBA)")
> 
> added a placeholder for such a table to the resctrl_membw structure, but
> the table was never populated and never read. rdt_get_mb_table(), which
> would provide it, always fails. As a result, an Intel MBA resource with
> non-linear delay values is never marked as capable of allocation, and its
> control values are never written to hardware.
> 
> Remove the unused mapping table and fold the linear percentage-to-delay
> conversion into the function that writes the control values to hardware.
> 
> Keep the check that delay values are linear as a defensive measure in
> preparation for supporting multiple controls, which turns the memory
> bandwidth control into a generic scalar control that indicates whether it
> requires linear values.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Reviewed-by: Chen Yu <yu.c.chen@intel.com>
> ---
> Changes since RFC v1:
> - Also drop separate delay_bw_map() and instead integrate the only
>   mapping to when control value is written.
> 
> Changes since RFC v2:
> - Rework changelog.
> 
> Changes since v1:
> - Rewrite changelog, fix subject prefix.
> - Match error message about linear support with similar message during
>   enumeration added in next patch.
> - Add Chenyu's Reviewed-by tag
> ---
>  arch/x86/kernel/cpu/resctrl/core.c | 23 +++++++----------------
>  include/linux/resctrl.h            |  2 --
>  2 files changed, 7 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 55214d6fdc49..f9677e52790e 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -323,29 +323,20 @@ static void mba_wrmsr_amd(struct msr_param *m)
>  		wrmsrq(hw_res->msr_base + i, hw_dom->ctrl_val[i]);
>  }
>  
> -/*
> - * Map the memory b/w percentage value to delay values
> - * that can be written to QOS_MSRs.
> - * There are currently no SKUs which support non linear delay values.
> - */
> -static u32 delay_bw_map(unsigned long bw, struct rdt_resource *r)
> -{
> -	if (r->membw.delay_linear)
> -		return MAX_MBA_BW - bw;
> -
> -	pr_warn_once("Non Linear delay-bw map not supported but queried\n");
> -	return MAX_MBA_BW;
> -}
> -
>  static void mba_wrmsr_intel(struct msr_param *m)
>  {
>  	struct rdt_hw_ctrl_domain *hw_dom = resctrl_to_arch_ctrl_dom(m->dom);
>  	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(m->res);
>  	unsigned int i;
>  
> -	/*  Write the delay values for mba. */
> +	if (!m->res->membw.delay_linear) {
> +		pr_warn_once("Non-linear MBA delay values not supported\n");
> +		return;
> +	}
> +
> +	/* Program bandwidth percentage mapped to linear delay value. */
>  	for (i = m->low; i < m->high; i++)
> -		wrmsrq(hw_res->msr_base + i, delay_bw_map(hw_dom->ctrl_val[i], m->res));
> +		wrmsrq(hw_res->msr_base + i, MAX_MBA_BW - hw_dom->ctrl_val[i]);

LGTM
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>

>  }
>  
>  static void cat_wrmsr(struct msr_param *m)
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 10dfdca7f4bf..b63dc62690ca 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -253,7 +253,6 @@ enum membw_throttle_mode {
>   * @throttle_mode:	Bandwidth throttling mode when threads request
>   *			different memory bandwidths
>   * @mba_sc:		True if MBA software controller(mba_sc) is enabled
> - * @mb_map:		Mapping of memory B/W percentage to memory B/W delay
>   */
>  struct resctrl_membw {
>  	u32				min_bw;
> @@ -263,7 +262,6 @@ struct resctrl_membw {
>  	bool				arch_needs_linear;
>  	enum membw_throttle_mode	throttle_mode;
>  	bool				mba_sc;
> -	u32				*mb_map;
>  };
>  
>  struct resctrl_schema;

-- 
Best regards,
Jinjie

