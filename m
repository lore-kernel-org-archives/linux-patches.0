Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6FD230278
	for <patches@lists.linux.dev>; Thu, 19 Jun 2025 14:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750345148; cv=none; b=JiQtXBBsA5zP6mCTH906+4KY6MBDSWVwNgVakKzekHkb5lJ2ivOQ60L9/2xaiZKLS2KuJ1Eep7VtCUvF3cctffBwrp/WHoXC7F2G0YUfPkCDUGiC8zu8M56qLNP5VUoAJy/8TQuxj5bkDzUj+p8zLg5ZqERKRo8jwWSwb8y7IzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750345148; c=relaxed/simple;
	bh=1zDbp04MJR2rOEZZQubXN0u0q2gp9kvtbea6XhIT9k8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R4YO0+3NN4VAOW0Q0WeIwYfKaf/9yStVQlQutKAJ8rzHvbPh52QJojzjPQTAuNX+izNk1QAS17QCdpg7HmOyiBliDiZeWaEzDkrni70q7aw01BC2uWfiSBv5K9aYB6XQ2Bd0YykyIYATZgipZ68nNtoZFEP+ZU6IGwJe5jObHDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yBBxRRsi; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yBBxRRsi"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a6cd1a6fecso576429f8f.3
        for <patches@lists.linux.dev>; Thu, 19 Jun 2025 07:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750345144; x=1750949944; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ECCoI/71JS3u+USP7IvsywfMmQCP+sHbNR0kEPdIEZI=;
        b=yBBxRRsi0GjPBX8JKatWE5QJkZ29Nr3sm8S7l3S/DHmxJGmsuUW0IIWYghgyKQZqS5
         gyfqrHEixozHRh4YAb1YgeTF7oFd4DKzJn2Mz1+7JOUlvoNTfjlJUXde9bPXX4H74hfC
         obvAdyO57Teq7bJYKxonlz6NpuN8NYX+QSR71dpisBcqOVjFXOlxKIEfeb+RZPNooV8M
         DYpRNg5PZ08DQ+ls7Q3GMP8R/rVhnVP16XYLWc0UldW+NppXqBgSDwXWUmvJ1U2kan+q
         +WMWqNGgFu7oM7tSkvNiu3wZ/lnsU+DscZXAIuG7CWYRtzBLzrPkIa/KzIR2pC9NSSIY
         cldw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750345144; x=1750949944;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ECCoI/71JS3u+USP7IvsywfMmQCP+sHbNR0kEPdIEZI=;
        b=W8j+wUcLCvFADcAl056iUCMtpz7Z8QXu5s20UG7eUauvaUsLXXO6gKTSJx3/L+qT09
         AsrHpygkhLP/0Z0NnELTctx93tP6mASP/x0mO5oND3x0ni98SbSz+BTZpCYydujwy+zr
         NWiHPixjVfaMTxh7M9Q0vyQ+22/GLeZRqxNFrJrojdi8i+GbjI+0D074iSeeP39MDmeS
         x5LzqDkF8GDrl055L+6BRWCzm/CEnr4R86ARkgOZZj8ealA5kgeG1x6j0lU3BZMwKZVz
         goOM5Qr9BDaE/bkN45sy6Q9uoRUadRwo763jRHpQ9gGR9D4PLjBAD220DhP/w+sAH6sI
         MO7A==
X-Forwarded-Encrypted: i=1; AJvYcCUBnC2qsaco6HtPtRNkko0Yn2KHG5PYdTPXlDm3qtzDq3rrjhhMnTtKIaOWmITl5O9VMBDmtMj8@lists.linux.dev
X-Gm-Message-State: AOJu0YwXGdI0upqBUruvQMn6ZqYdY+U7jLn4Vnug4xP8jFdRZkkZK3e0
	fS5HMF1YSd/844KrYsRnqBXn8NgUsDhUQlmSkf7RB8oCH6PBWozZS8+PxeqkAGLpWXA=
X-Gm-Gg: ASbGncuu3JYHDm4d2k7BRAymyv5ECMhKlp3StFu5tW2YGalRY0u5WuBC6NecUDHCxOw
	TsfUjYL/S2ZoyDKFXNnUYnxk+SBzAu4YR83jAVtbfnELzybZrXtsOYAyUvBVM3S5ONutkxkpKJ1
	kLLCZzKXiJfywP63OGbM/mPUD4kF74BZtv2JO/4RFUGi6Rc8qtDhjtkBPcydRlDdeFsA4lx1+eB
	egeBCA34vQIcfilmLFXz5ePjE8atO8YitjN+syrlpQBXz32ymAV2qKS4Bnqs3Smfw65+1QmY8BP
	fJyC3z5zsk2ZUobIFgmOP0dGBKT+CSyjFICMHJBWmFw3nACWVxOMnw8fXDLz1JQlMVFXqK5TVqf
	PsJzFxNPvHw24f83rLoZw0TUiXk4Mvx/C+K0=
X-Google-Smtp-Source: AGHT+IGmnPNdDdO/SCEtEybjm+3oFAXmRDg5jmS5KEozw5rxP3jACidjef48u3E+8nsnsfMd8Ti7wg==
X-Received: by 2002:a05:6000:4201:b0:3a4:d898:3e2d with SMTP id ffacd0b85a97d-3a572e2dabcmr17534877f8f.24.1750345144440;
        Thu, 19 Jun 2025 07:59:04 -0700 (PDT)
Received: from ?IPV6:2a0e:c5c1:0:100:b058:b8f5:b561:423c? ([2a0e:c5c1:0:100:b058:b8f5:b561:423c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4535f7febcfsm25710235e9.18.2025.06.19.07.59.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jun 2025 07:59:03 -0700 (PDT)
Message-ID: <3d50a859-d4bb-4d71-a493-d8a2a114dd6c@linaro.org>
Date: Thu, 19 Jun 2025 16:59:03 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 296/356] ath10k: snoc: fix unbalanced IRQ enable in
 crash recovery
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Caleb Connolly <caleb.connolly@linaro.org>,
 Loic Poulain <loic.poulain@oss.qualcomm.com>,
 Jeff Johnson <jeff.johnson@oss.qualcomm.com>, Sasha Levin <sashal@kernel.org>
References: <20250617152338.212798615@linuxfoundation.org>
 <20250617152350.087643471@linuxfoundation.org>
 <a91ca229-0603-4385-9f9e-01f3c3ede855@linaro.org>
 <2025061953-alarm-oxidize-1967@gregkh>
 <2ac47529-d72b-4de0-873e-247cce7c3c1c@linaro.org>
 <2025061946-squiggle-cheer-27c8@gregkh>
Content-Language: en-US
From: Casey Connolly <casey.connolly@linaro.org>
In-Reply-To: <2025061946-squiggle-cheer-27c8@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/19/25 16:53, Greg Kroah-Hartman wrote:
> On Thu, Jun 19, 2025 at 04:09:00PM +0200, Casey Connolly wrote:
>>
>>
>> On 6/19/25 06:21, Greg Kroah-Hartman wrote:
>>> On Wed, Jun 18, 2025 at 08:06:45PM +0200, Casey Connolly wrote:
>>>>
>>>>
>>>> On 6/17/25 17:26, Greg Kroah-Hartman wrote:
>>>>> 6.6-stable review patch.  If anyone has any objections, please let me know.
>>>>>
>>>>> ------------------
>>>>>
>>>>> From: Caleb Connolly <caleb.connolly@linaro.org>
>>>>>
>>>>> [ Upstream commit 1650d32b92b01db03a1a95d69ee74fcbc34d4b00 ]
>>>>>
>>>>> In ath10k_snoc_hif_stop() we skip disabling the IRQs in the crash
>>>>> recovery flow, but we still unconditionally call enable again in
>>>>> ath10k_snoc_hif_start().
>>>>>
>>>>> We can't check the ATH10K_FLAG_CRASH_FLUSH bit since it is cleared
>>>>> before hif_start() is called, so instead check the
>>>>> ATH10K_SNOC_FLAG_RECOVERY flag and skip enabling the IRQs during crash
>>>>> recovery.
>>>>>
>>>>> This fixes unbalanced IRQ enable splats that happen after recovering from
>>>>> a crash.
>>>>>
>>>>> Fixes: 0e622f67e041 ("ath10k: add support for WCN3990 firmware crash recovery")
>>>>> Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
>>>>
>>>> If fixing my name is acceptable, that would be appreciated...
>>>
>>> I can, to what?  This was a cherry-pick from what is in Linus's tree
>>> right now, and what was sent to the mailing list, was that incorrect?
>>
>> s/Caleb/Casey/ I sent this patch before updating my name.
> 
> Ah, sorry, I already did the release.  I would recommend sending in a
> .mailmap update for the kernel so this gets caught going forward.

Ok, no worries.

I already updated mailmap and all the other references so this shouldn't 
happen again, just bad timing with this patch.

Kind regards,>
> thanks,
> 
> greg k-h
-- 
Casey (she/they)

