Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1293CB2D9
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 17:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775757401; cv=none; b=eHi1SJcMldlHwXDoh5rjRGkIRuato3oj7qtxvbESGmvOg3Sf2jitLn8g2OV7ewq9AO/hdEvkNknzN1FMgwrZEdridCDVIe0Uh1qsrFojuoWR0WrmbCLVAokrWQyq/oSIDtuTQRe6k5MwLqdZX2U2GXVTeAtkaXyfTUOAiUvzzuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775757401; c=relaxed/simple;
	bh=syqRb8ZjrzL2v7saxbDAMLjih/Akx7H1/upy/WggxSA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ewxsn0arbjjkCr1wfZrsQjjDUJPc58BTg64zSSGb5MBkpz/4UZgIxWKMcCmTrb0NMhs4abO39CHb/PXz4UM3qe8VbLampgI79O7zWnZ8P47rkAedwwrEZAnbYMer92p0SE/j6B2fUqwQsjq0+dIpq3j44zd+LIAJrXkpmSN7RWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dISPlnCS; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dISPlnCS"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2bd9a485bd6so2358005eec.1
        for <patches@lists.linux.dev>; Thu, 09 Apr 2026 10:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775757399; x=1776362199; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3El7mew6bkljZoosx65G45vP8VAox+2w32bCRkf0mPQ=;
        b=dISPlnCSR1bBkEutMg2UCDsG3w+sptxz5TRJSc8jzfoByXbdvKcGOF3OnFZIdHg8r+
         lPsHM/yZjNw01p2eO9S0RLPYJoT2avRaMz+fETgbMZCBGspDpDH+NG7CNVjpwnFEAEpo
         rObHahQMyLVjzQv9KaPE3p1qmAjOigZ2U1PXSMpGxY+T1wZSm1mWbZS2hmvl00Tu1m0T
         1V9Vl8EQleXoTPwwltsafn3aTuerMA1+diWdcsM7xCO2rVzVsmK15pVYv7J2os9pLue7
         fAmjOK43AiwbvkucodUjAiJTPtn58hPwi5x3L3Y49M92ej/Yr7MlyRiTFz5deDy5Yyop
         nygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775757399; x=1776362199;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3El7mew6bkljZoosx65G45vP8VAox+2w32bCRkf0mPQ=;
        b=hvHmPOXdQiggvjss1M/i8HgRIQuI10CHzMhFAN1nhcn9OTYCpSOm/mQyVG6et/1ARO
         UQvUYkasJ+Tsqj5ykNLMEHaFy27Q3KWxnWlhNQOAUl4ygw+HlVHu23FBTpz/Ue2i8kco
         lBlkeJa2lzia37evnftKYEmtuQrz5nWkv/KDTsiJXZ3nUhZ6ka5flzi8DVKLGdkURq+X
         qO5utUp3DG35I2Wb7G0tOchcOeE9fVpjQrIrQ8UM+Wqcqh32d/NxvzDpmJLoBedI6tOd
         JqUQCcAb6WTlCGX49uTTolExwbpfwpdJU4Qn6oqQ5WbAAPtY5AatxPFFyt/HEOP2vC0w
         raRQ==
X-Gm-Message-State: AOJu0YxTHm/KkyeEEnH1CR40xbDNuMnVlyKYqbX2/jDoV7DfrVmD1KWa
	R3AK5FyBNhLyCtsI1tH4Vg9RcaEZ3QUJQMJuL0xPHXiILmkcg3F62pa6
X-Gm-Gg: AeBDiesglxVOAhuV2q/CHApAHvMRPt+K8o7DFDxEq2NlV7FReJoVWlfKxg7jsxk+Wl2
	w/Cn1rEUVdcwNWvKitzioxyEHVqHpkkQN9z6GpY6pgs3+y0M97wO6xqwBHd/rzd3i6hNbexhOAx
	A/8Sk3qfBlQNrKVRE/P4130FZr1e8UePncr2GllfY77CIIFljjwgjbVHsFhvp6YLF0UKMXlxZDR
	3zInIzvd+Q224WXlu7EPqB2NknghAQB5tbk/WC0Rbi48Gi+qodvR/Iz+fsyPNrKsLRMOdCF5fQh
	3eZ4ik3H4aP01+S4RMpx1Vq2k+//2WR2hzg5l7gw+Eg2yGhI/IukcxbTxjvH0HUt9tlwerzHqe9
	U2F9UOyJIx86L+Cqaoaeb9VckjFKkLqoHmapC44PYrMZyOwo/y+0Vq/7m0ttwKrg7EJc1AlTbJH
	q0sKRcm+CHC5sSgtJVC1tCe2r/mVOFp7yktTFwwfwyvq3XrCT0gA==
X-Received: by 2002:a05:7300:cb0a:b0:2d3:dff7:13b1 with SMTP id 5a478bee46e88-2d589463ba1mr22997eec.15.1775757399144;
        Thu, 09 Apr 2026 10:56:39 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d561cd3138sm629933eec.14.2026.04.09.10.56.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 10:56:37 -0700 (PDT)
Message-ID: <304e55c8-7e0f-49b3-b952-17c14dd79201@gmail.com>
Date: Thu, 9 Apr 2026 10:56:35 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/160] 6.6.134-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260408175913.177092714@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/26 11:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.134 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.134-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
