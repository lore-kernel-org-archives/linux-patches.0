Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FEE262D0B;
	Wed, 23 Apr 2025 14:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745416890; cv=none; b=sKwcjK7bswFbmWwXrcpFZddWEsG9Mv6/SHS1uZq8CAj1jNVMXXI9DCJaxmX8anW7Ble/EFZ1Sc6nBzOflPimA9RVGUtS0mlC+2/nXaPD2PVFVyMC8M8Pp+buDDAU6gXg+j5PpY60ns5DhKsQVR1fVIew/Y789bj56KPwe9RX0lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745416890; c=relaxed/simple;
	bh=xIVMmyvZfh3hGJ6hzL0vT1Yla3mDQFmjTEfQNN+WN8k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q/bM20Tb/0cy63T8sdrU+2exHrTy/5Tvkpxn/L6NQKONwoBjpYFYZ6OYj4VegG6yXBWlUxsg0JsIXULLFR9yYqOos5jVmsFshEPd88Cz7qsji6egT4wZwMIc4bqxjP7WOq/mxoz9Ylhy97Zk72b245iDz+ZcHnKPVh56f6L3aKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=OjZlLZcD; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="OjZlLZcD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1745416881;
	bh=xIVMmyvZfh3hGJ6hzL0vT1Yla3mDQFmjTEfQNN+WN8k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OjZlLZcDL0ESfghrgpABz+tyVK9R+FSUhFn2X5gIvW2ylDbvnTh7fFyynmyHjOhPK
	 k9BqxygG/CEw3ayjjhxgM3fNIQT6lBrqienJ33XRt0LHQTAywkYjfVIDN/+gmIAWX6
	 4uSkfLiVSfZ7t6BW6hPA76BKv5aOSI003g+MGabYbo1ktsQeykfHA3sTxHHxKgCJvv
	 FKHGWXvzLIqPmOu6+JTyQrpBirBLc83cZery7cOOOgOnI140L+3ufkWSSYOA9HsG0p
	 ex2MjfniDWw+K0T65V7pVBU+rLhyz/UAi6FRTRqVPr5wptAb6qRKYEOkJjjHLGeRhE
	 uYUV2+zyQF7tQ==
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id B206017E014F;
	Wed, 23 Apr 2025 16:01:20 +0200 (CEST)
Message-ID: <4cd274f8-85ab-43dc-bef4-41646d43b775@collabora.com>
Date: Wed, 23 Apr 2025 16:01:20 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drm/panel: himax-hx8279: Initialize goa_{even,odd}_valid
 in hx8279_check_goa_config()
To: neil.armstrong@linaro.org, Nathan Chancellor <nathan@kernel.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>
Cc: Jessica Zhang <quic_jesszhan@quicinc.com>,
 dri-devel@lists.freedesktop.org, llvm@lists.linux.dev,
 patches@lists.linux.dev
References: <20250422-panel-himax-hx8279-fix-sometimes-uninitialized-v1-1-614dba12b30d@kernel.org>
 <a6e47775-33c3-44c2-b6d5-58164e4a0a50@linaro.org>
 <b8d21e46-c50a-4212-ae7a-d292c2ec6ce4@linaro.org>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <b8d21e46-c50a-4212-ae7a-d292c2ec6ce4@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Il 23/04/25 15:50, Neil Armstrong ha scritto:
> On 23/04/2025 15:45, Neil Armstrong wrote:
>> On 22/04/2025 23:20, Nathan Chancellor wrote:
>>> Clang warns (or errors with CONFIG_WERROR=y):
>>>
>>>    drivers/gpu/drm/panel/panel-himax-hx8279.c:838:6: error: variable 
>>> 'goa_even_valid' is used uninitialized whenever 'if' condition is false [- 
>>> Werror,-Wsometimes-uninitialized]
>>>      838 |         if (num_zero == ARRAY_SIZE(desc->goa_even_timing))
>>>          |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>    drivers/gpu/drm/panel/panel-himax-hx8279.c:842:23: note: uninitialized use 
>>> occurs here
>>>      842 |         if (goa_odd_valid != goa_even_valid)
>>>          |                              ^~~~~~~~~~~~~~
>>>    drivers/gpu/drm/panel/panel-himax-hx8279.c:838:2: note: remove the 'if' if 
>>> its condition is always true
>>>      838 |         if (num_zero == ARRAY_SIZE(desc->goa_even_timing))
>>>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>      839 |                 goa_even_valid = false;
>>>    drivers/gpu/drm/panel/panel-himax-hx8279.c:818:36: note: initialize the 
>>> variable 'goa_even_valid' to silence this warning
>>>      818 |         bool goa_odd_valid, goa_even_valid;
>>>          |                                           ^
>>>          |                                            = 0
>>>
>>> Even though only the even valid variable gets flagged, both valid
>>> variables appear to have the same issue of possibly being used
>>> uninitialized if the if statement initializing them to false is not
>>> taken.
>>>
>>> Initialize both values to true to clear up the warning and remove any
>>> possibility of encountering undefined behavior.
>>>
>>> Fixes: 38d42c261389 ("drm: panel: Add driver for Himax HX8279 DDIC panels")
>>> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
>>> ---
>>>   drivers/gpu/drm/panel/panel-himax-hx8279.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/gpu/drm/panel/panel-himax-hx8279.c b/drivers/gpu/drm/panel/ 
>>> panel-himax-hx8279.c
>>> index b48b350b62da..92f351e66c25 100644
>>> --- a/drivers/gpu/drm/panel/panel-himax-hx8279.c
>>> +++ b/drivers/gpu/drm/panel/panel-himax-hx8279.c
>>> @@ -815,7 +815,7 @@ static int hx8279_check_gmux_config(struct hx8279 *hx, 
>>> struct device *dev)
>>>   static int hx8279_check_goa_config(struct hx8279 *hx, struct device *dev)
>>>   {
>>>       const struct hx8279_panel_desc *desc = hx->desc;
>>> -    bool goa_odd_valid, goa_even_valid;
>>> +    bool goa_odd_valid = true, goa_even_valid = true;
>>>       int i, num_zero, num_clr = 0;
>>>       /* Up to 4 zero values is a valid configuration. Check them all. */
>>>
>>> ---
>>> base-commit: dcbd5dcc956e2331414fd7020b4655df08deeb87
>>> change-id: 20250422-panel-himax-hx8279-fix-sometimes-uninitialized-207354fb930c
>>>
>>> Best regards,
>>
>> Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
> 
> I'll wait a few days until AngeloGioacchino Del Regno reviews it to be sure
> it's the right fix.
> 
> Thanks,
> Neil

I would prefer

	if (num_zero == ARRAY_SIZE(desc->goa_odd_timing))
		goa_odd_valid = false;
	else
		goa_odd_valid = true;

	/* Up to 3 zeroes is a valid config. Check them all. */
	num_zero = 1;
	for (i = 0; i < ARRAY_SIZE(desc->goa_even_timing); i++) {
		if (desc->goa_even_timing[i])
			num_zero++;
	}

	if (num_zero == ARRAY_SIZE(desc->goa_even_timing))
		goa_even_valid = false;
	else
		goa_even_valid = true;

or the shorter form:

	goa_odd_valid = (num_zero != ARRAY_SIZE(desc->goa_odd_timing));

	/* Up to 3 zeroes is a valid config. Check them all. */
	num_zero = 1;
	for (i = 0; i < ARRAY_SIZE(desc->goa_even_timing); i++) {
		if (desc->goa_even_timing[i])
			num_zero++;
	}

	goa_even_valid = (num_zero != ARRAY_SIZE(desc->goa_even_timing));

...to avoid double initialization.

But anyway, the proposed solution also works just fine, as the sense is, as well
understood by Nathan, "if it's all zeroes something is wrong, otherwise it's ok".

Btw , I'm sorry about this - not sure how the code ended up being like this,
probably that last minute cleanup that I did.

Ultimately, whether to avoid the double init or not is Neil's call - so for this
commit you can get my

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

And sorry again about the (stupid) mistake.

Cheers,
Angelo
