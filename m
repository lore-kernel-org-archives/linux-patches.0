Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97A73A27E
	for <patches@lists.linux.dev>; Mon,  6 May 2024 01:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957402; cv=none; b=NtFpSQVKZjVrG9kKfmDkzgLlrvHIBewvdxGWJ2bBVih19juqgAdFUp4MVoqDcDa/y++xvoveTsPmgzeFf9D2KV3dZsB+2jiNdrWNSpJ18ph9eBSwFco9QRRw9ypk5NP6uQd6NREM2CKplAdsu/sOh1rcnk5XgKvBW3uDGDrIDTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957402; c=relaxed/simple;
	bh=SOd6zG3YGzocMe2eSnAlOoMrqEZAvtmT0QgFko6u+Ls=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=SJlfH5HIrQJMNmnraC4TJJJO8hF2tk4zYoxWirLC7Neia2pPFc+1pFwIy10Iza52psAqRtoMskcCOzfIXwGhp1fAptHoxIos5hb6cmCVyV9N/SPds9YScBXCadPTkCeG6bxYTizpUQetzQDYGovm1EZxJ19a75odVJH0voZKh9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4VXjk84x94z1RBbc;
	Mon,  6 May 2024 09:00:00 +0800 (CST)
Received: from dggpemm500002.china.huawei.com (unknown [7.185.36.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 54A1118005C;
	Mon,  6 May 2024 09:03:17 +0800 (CST)
Received: from [10.174.178.247] (10.174.178.247) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 09:03:16 +0800
Subject: Re: [PATCH] clocksource/drivers/arm_arch_timer: Mark
 hisi_161010101_oem_info const
To: Stephen Boyd <swboyd@chromium.org>, Daniel Lezcano
	<daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, dann frazier
	<dann.frazier@canonical.com>, Hanjun Guo <hanjun.guo@linaro.org>, Marc
 Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>
References: <20240502233447.420888-1-swboyd@chromium.org>
From: Hanjun Guo <guohanjun@huawei.com>
Message-ID: <ead7324b-3cc1-15da-d80f-ef5ea1bec218@huawei.com>
Date: Mon, 6 May 2024 09:03:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240502233447.420888-1-swboyd@chromium.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500002.china.huawei.com (7.185.36.229)

On 2024/5/3 7:34, Stephen Boyd wrote:
> This isn't modified at runtime. Mark it const so it can move to
> read-only data.
> 
> Cc: dann frazier <dann.frazier@canonical.com>
> Cc: Hanjun Guo <hanjun.guo@linaro.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>   drivers/clocksource/arm_arch_timer.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index 8d4a52056684..5bb43cc1a8df 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -331,7 +331,7 @@ static u64 notrace hisi_161010101_read_cntvct_el0(void)
>   	return __hisi_161010101_read_reg(cntvct_el0);
>   }
>   
> -static struct ate_acpi_oem_info hisi_161010101_oem_info[] = {
> +static const struct ate_acpi_oem_info hisi_161010101_oem_info[] = {
>   	/*
>   	 * Note that trailing spaces are required to properly match
>   	 * the OEM table information.

Looks good to me,

Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
