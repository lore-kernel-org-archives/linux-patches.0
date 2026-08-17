Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE4178F4A
	for <patches@lists.linux.dev>; Mon, 17 Aug 2026 20:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786997912; cv=none; b=sAYHuAIj9PBnsMmTJmhAF96IFfgwOaaZYU8QZ5wK0oAH+3NSzQ77e7aX1MZkUwP1Vk/0v3sWlUQFHZYkGyIJ+UtiOfUFUoNc1u6y8pJDPQvJIHRq5+HzKYx9j3wp9lE3ubfT2flGpDHVUGA4/PRwdTWIQdMpef/WYUCElOCVjko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786997912; c=relaxed/simple;
	bh=TE1hIpoaPcqTZGDR04S+7oNnMFv7ZuheYACMnpIQF98=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qfo7RpOQ0bF3gOc6/b8Q95EsKUYBbKKHQ4NnrB/D/GVpGF2LjNOOM4dUPaZwQKgd6uCwF2jAfLDlx4o0zyKO2PRqiD4h8PVsqzwAw1QOvFjU69BONfmBLRro7811aPMg1i+xr3hi32RC+MVumS/5PR/Xhr2AzrI5aTbfDuW5hek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HbjEYrh1; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HbjEYrh1"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ceb096e675so43940035ad.0
        for <patches@lists.linux.dev>; Mon, 17 Aug 2026 13:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786997911; x=1787602711; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5zY/Y5PhSQuxWDHF9kHAoPxjL55SbtIZKrGskYEz5Z4=;
        b=HbjEYrh1nO5ec7Jri7fnwhdFHRbPtJISfl71WygqB4RoUNxBIS7/RvbHfOw4E9Olrf
         VKt4HypFSBiH37Yd/L0ZfZ2y1wrIe9oqY6Ead+UgtV5OL8YLZZSZIkLacAc4AusshQMo
         Ca1FxQ48rmGALFkOumTbc7HNJBHwm28oN6/LP9Adov81JOb2aArKuYn/qQvHxajIq3hg
         vuOiSihbccOtLUllv79/i1M/4X64x4hAW99/Hfoy5qpbb3Q+caU935frb3nmGpX1S71+
         wQndY4dwE+Okmoe3+xvooGeWHSDo7tIxXbwPcH+ZXKU6Oabdr3h+0fyg1k79O17VmfW6
         iG9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786997911; x=1787602711;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5zY/Y5PhSQuxWDHF9kHAoPxjL55SbtIZKrGskYEz5Z4=;
        b=M+xG9ejqawvUmybi1lJ9uXrjx4mKHI+qEMKQ+nyRjf/FZ8fSln89NdSyss8Xx6Xd0V
         yYyAx1oCtL1mIQev+7sr194t2jLLbc3zD6IxZ41PtjgBu4Jo06en9MBs8/cGo94QY3ca
         TPM7E6XmErvbvoS9a57q4BYPw1q05yQb8IzM086oOlCzGB7eyXw6+sz8XzJfwrp/j3ig
         ESdnXNYipn+aLlP+f2LT2TPt+H/z8XUrPEshN6s68HzPG1L0rihd3RI85j/zfJ9wHBdL
         ObRDZb0nTGNvUr3UOCd6VMK9jtXhlLrxOxlJvBxLGPkEDpDerH7aX1i3MfNIMTGPMsON
         c5og==
X-Gm-Message-State: AOJu0YwbrO7pERUAhArB8DdqXxbyLFfI0MM/BDbCUNqouXa002/boAyO
	Nt6Z07fPHw0nVEZmdwOEpWZaf79bM7ITia1//OiiZHjyxrpYUndKBjRp
X-Gm-Gg: AR+sD11BYzQJlb+Ti316Hs5DCdPSdV1ozqY2ZC1tmVDjMrGDZONVb8ElsrlB1HMFFKZ
	TcnP2SbSHfuWLte3IZlfKsfRnRii3+uhNKJghDf5ufgQViZ4G2UqFyVAukF82Jks8N/W2c99R2R
	IyHibBNy/DGA61CSTs4cHg6KGeArbOiHdlJdzdFTdXsoUP2rEeZV9RHqu/Mc60mdBp7kzUbquZF
	Ue7mPZxrHxb+2QtopWXte+cdYkuHkfQ4DpEYSrLlrVLVUXjiCVgxdb8PH5ixz646ByiLILktoFH
	GOo6tRcnyPL253WET8/FfWoBuxicOrNZeVgdrfGy9u19Pn0qLAa1l2g5Cls1HUyQ48NvjPSyGMJ
	RUGCGLi8jdihYETk8N4MMy0XmVSBa+BFMbAm4Ps6MzAgEuk1qRb+BKcigF6csAAYS2ibS73+Olf
	rK75BmU1lVHymTxNbh6TLqofTa6un3QBrYuGxbO4ke6Wbpexw4apSgOQFsBGAgi67wiGGsdEovG
	svzB6vSVdwCZlc=
X-Received: by 2002:a05:6a21:a4a:b0:3c3:9070:96b3 with SMTP id adf61e73a8af0-3cc71af165bmr32004977637.3.1786997911027;
        Mon, 17 Aug 2026 13:18:31 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3267be8e5c8sm9203221eec.16.2026.08.17.13.18.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 13:18:30 -0700 (PDT)
Message-ID: <8858686e-14bf-4420-bc6c-5646b0223dfd@gmail.com>
Date: Mon, 17 Aug 2026 13:18:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/181] 6.12.104-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260817132535.394764707@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/26 06:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.104 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.104-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
