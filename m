Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C52C1392;
	Mon, 14 Apr 2025 05:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744610387; cv=none; b=AdG1cv97RwQtfjuXXmv1Li3vRQwOihAGrnRKwaLu3u0g/0IWaAqrDdioGhI7Yn94yPyLL1cxk02bgF3uYINCF3wQFYt94duC49u2RGejBLFybo5kzqpgqF2hmn47iQ962Zl1hh/DrjQVj+OolAB1LXsvQTzSvGGdZM+L8pY/lfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744610387; c=relaxed/simple;
	bh=Oq460Jfx1W6eGwNg8M1MpmjCeigvBd/Jc44g+bd53Sw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FfSB/cXamHZCbnLcWi7AnIr55TbM24wNmb9tSKmQbEEEPCyLLQ9Xf2uh2aW4VY/eHe0hcpaDd1eMyawQGcsPpPDBkUx/j/DvDgQgsH+/1rHvIKYjHzA3SUOpaB7038aUt1E0XVjEH3i5v/9NicK78ef35M7yqo1TN6pmRwqR74I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sd/liRSV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sd/liRSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E767BC4CEE2;
	Mon, 14 Apr 2025 05:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744610386;
	bh=Oq460Jfx1W6eGwNg8M1MpmjCeigvBd/Jc44g+bd53Sw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sd/liRSVz7Cuuh+OgXtKtyLG2PVyVYqilMNLdT4ogszOKxlsgcanwUp/WyNo0ILo0
	 HZOcg9XrC/7Q2V6C4BM1+oQQqrRXTFDlSJggcepCUZ2wTiv4rqOjqF9+zgm7R88HTy
	 L/zYngg4NJasBT0oOldYsWwe6KXrn0wTkYkePabDPTnD/ZMbbw9rsqd34f7hrOE69y
	 aZlvaMfTdS/1tAOtt2hzXaT7XDC7UM9wBRxbWNY0S3we0W5BjWNyBJmKSvkOaRf1Fp
	 eW9o8+I6OCGuSL6wnn+nqW5W/Pjc/dF72Hfq2KQjWHwn4tk5hkBGr3RaIt9MF41T8p
	 1aGxIVIvtBDqw==
Message-ID: <5cd9db3f-4abf-4b66-b401-633508e905ac@kernel.org>
Date: Mon, 14 Apr 2025 07:59:42 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 084/731] wifi: ath11k: update channel list in reg
 notifier instead reg worker
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Wen Gong <quic_wgong@quicinc.com>,
 Kang Yang <quic_kangyang@quicinc.com>,
 Aditya Kumar Singh <quic_adisi@quicinc.com>,
 Jeff Johnson <jeff.johnson@oss.qualcomm.com>, Sasha Levin <sashal@kernel.org>
References: <20250408104914.247897328@linuxfoundation.org>
 <20250408104916.224926328@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20250408104916.224926328@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08. 04. 25, 12:39, Greg Kroah-Hartman wrote:
> 6.14-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Wen Gong <quic_wgong@quicinc.com>
> 
> [ Upstream commit 933ab187e679e6fbdeea1835ae39efcc59c022d2 ]
> 
> Currently when ath11k gets a new channel list, it will be processed
> according to the following steps:
> 1. update new channel list to cfg80211 and queue reg_work.
> 2. cfg80211 handles new channel list during reg_work.
> 3. update cfg80211's handled channel list to firmware by
> ath11k_reg_update_chan_list().
> 
> But ath11k will immediately execute step 3 after reg_work is just
> queued. Since step 2 is asynchronous, cfg80211 may not have completed
> handling the new channel list, which may leading to an out-of-bounds
> write error:
> BUG: KASAN: slab-out-of-bounds in ath11k_reg_update_chan_list
> Call Trace:
>      ath11k_reg_update_chan_list+0xbfe/0xfe0 [ath11k]
>      kfree+0x109/0x3a0
>      ath11k_regd_update+0x1cf/0x350 [ath11k]
>      ath11k_regd_update_work+0x14/0x20 [ath11k]
>      process_one_work+0xe35/0x14c0
> 
> Should ensure step 2 is completely done before executing step 3. Thus
> Wen raised patch[1]. When flag NL80211_REGDOM_SET_BY_DRIVER is set,
> cfg80211 will notify ath11k after step 2 is done.
> 
> So enable the flag NL80211_REGDOM_SET_BY_DRIVER then cfg80211 will
> notify ath11k after step 2 is done. At this time, there will be no
> KASAN bug during the execution of the step 3.
> 
> [1] https://patchwork.kernel.org/project/linux-wireless/patch/20230201065313.27203-1-quic_wgong@quicinc.com/
> 
> Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3
> 
> Fixes: f45cb6b29cd3 ("wifi: ath11k: avoid deadlock during regulatory update in ath11k_regd_update()")
> Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
> Signed-off-by: Kang Yang <quic_kangyang@quicinc.com>
> Reviewed-by: Aditya Kumar Singh <quic_adisi@quicinc.com>
> Link: https://patch.msgid.link/20250117061737.1921-2-quic_kangyang@quicinc.com
> Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/net/wireless/ath/ath11k/reg.c | 22 +++++++++++++++-------
>   1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/reg.c b/drivers/net/wireless/ath/ath11k/reg.c
> index b0f289784dd3a..7bfe47ad62a07 100644
> --- a/drivers/net/wireless/ath/ath11k/reg.c
> +++ b/drivers/net/wireless/ath/ath11k/reg.c
> @@ -1,7 +1,7 @@
>   // SPDX-License-Identifier: BSD-3-Clause-Clear
>   /*
>    * Copyright (c) 2018-2019 The Linux Foundation. All rights reserved.
> - * Copyright (c) 2021-2024 Qualcomm Innovation Center, Inc. All rights reserved.
> + * Copyright (c) 2021-2025 Qualcomm Innovation Center, Inc. All rights reserved.
>    */
>   #include <linux/rtnetlink.h>
>   
> @@ -55,6 +55,19 @@ ath11k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
>   	ath11k_dbg(ar->ab, ATH11K_DBG_REG,
>   		   "Regulatory Notification received for %s\n", wiphy_name(wiphy));
>   
> +	if (request->initiator == NL80211_REGDOM_SET_BY_DRIVER) {
> +		ath11k_dbg(ar->ab, ATH11K_DBG_REG,
> +			   "driver initiated regd update\n");
> +		if (ar->state != ATH11K_STATE_ON)
> +			return;
> +
> +		ret = ath11k_reg_update_chan_list(ar, true);
> +		if (ret)
> +			ath11k_warn(ar->ab, "failed to update channel list: %d\n", ret);
> +
> +		return;
> +	}

I suspect this causes stalls for me.

Workqueues are waiting for rtnl_lock:
> Showing busy workqueues and worker pools:
> workqueue events_unbound: flags=0x2
>   pwq 64: cpus=0-15 flags=0x4 nice=0 active=1 refcnt=2
>     in-flight: 107692:linkwatch_event
> workqueue netns: flags=0x6000a
>   pwq 64: cpus=0-15 flags=0x4 nice=0 active=1 refcnt=18
>     in-flight: 107676:cleanup_net   
> workqueue pm: flags=0x4
>   pwq 2: cpus=0 node=0 flags=0x0 nice=0 active=5 refcnt=6
>     in-flight: 107843:pm_runtime_work ,100179:pm_runtime_work ,50846:pm_runtime_work ,107845:pm_runtime_work ,107652:pm_runtime_work
> workqueue ipv6_addrconf: flags=0x6000a
>   pwq 64: cpus=0-15 flags=0x4 nice=0 active=1 refcnt=18
>     in-flight: 107705:addrconf_dad_work

While the above reg_notifier is stuck too:

 > workqueue events: flags=0x0
 >   pwq 14: cpus=3 node=0 flags=0x0 nice=0 active=1 refcnt=2
 >     in-flight: 107807:reg_todo [cfg80211]

waiting for:
> Workqueue: events reg_todo [cfg80211]
> Call Trace:
>  <TASK>
>  __schedule+0x437/0x1470
>  schedule+0x27/0xf0
>  schedule_timeout+0x73/0xe0
>  __wait_for_common+0x8e/0x1c0
>  ath11k_reg_update_chan_list+0x23c/0x290 [ath11k 30c4a145118dc3331f552d6275ec7d6272671444]
>  ath11k_reg_notifier+0x5a/0x80 [ath11k 30c4a145118dc3331f552d6275ec7d6272671444]
>  reg_process_self_managed_hint+0x170/0x1b0 [cfg80211 2571f504aa68d55c11440c869062c668de1a2dce]
>  reg_process_self_managed_hints+0x47/0xf0 [cfg80211 2571f504aa68d55c11440c869062c668de1a2dce]
>  reg_todo+0x207/0x290 [cfg80211 2571f504aa68d55c11440c869062c668de1a2dce]
>  process_one_work+0x17b/0x330
>  worker_thread+0x2ce/0x3f0


Is stable missing some backport or is this a problem in 6.15-rc too?

/me looking...

Ah, what about:
commit 02aae8e2f957adc1b15b6b8055316f8a154ac3f5
Author: Wen Gong <quic_wgong@quicinc.com>
Date:   Fri Jan 17 14:17:37 2025 +0800

     wifi: ath11k: update channel list in worker when wait flag is set

?

thanks,
-- 
js
suse labs

