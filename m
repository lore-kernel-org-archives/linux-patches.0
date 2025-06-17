Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6888A2586DA
	for <patches@lists.linux.dev>; Tue, 17 Jun 2025 21:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750195097; cv=none; b=cZVBR+fpwN3ud9PAeArMuW2vTgS+0bP3WY1Y0x7UlQcDdzkDxmXXEK1a0wi7IzWrU4XTRujbULrKD1AwyaPdF2nkFrzOv0B356wUwNWv/a/WnxR12dTp7wPFGGTT85HLKRQ2dS2KIAQ2HBYHcC7tba27SJjeuxAp8M3kpqzOehc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750195097; c=relaxed/simple;
	bh=TVwhUKNJWh38SAaQKE/6I1lTgFb1qJ4jUs+nTHCo20k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KMNjchDP0XaDzYJELocW3cxciyPZeYRYipc9UlKCp8HUTHsmvYiIhtG+aWVQn/JIfxGHLre30DLN98e3N1eLP/ufTznUGpcaF4/6CsFZpMj5JW2yjLXh9Rb2TH4aTlvvzdXUzVno3SWlZgNsA9KIMVLySjpY4Lr/tw21imq1uKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDGgONcG; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDGgONcG"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3ddd1cf40cfso22038445ab.1
        for <patches@lists.linux.dev>; Tue, 17 Jun 2025 14:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1750195094; x=1750799894; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lAXYvMlPvJqgHUS0OPvSDVehGX+5oMCjweHYTWvK2RM=;
        b=FDGgONcG6w7ODbgAfpvA+O0GG9c2+vOddyq/YlKR5wO7Zw41xZ87rKWXnoj092tg8O
         RHT+NzhOn1pTYYaQMUl18uePD5wVZ0ULKFv+M3gxW5MyCC0U01ARVcFPf4yl2BTmy1hy
         6hKy8FiLvNNEQ/QmFzVXNLRUK2mIKTYQRsEAw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750195094; x=1750799894;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lAXYvMlPvJqgHUS0OPvSDVehGX+5oMCjweHYTWvK2RM=;
        b=CBMpLHF2FTzLDsNKZo8dhAghymFLc7jqDYL3B++rHBYWCji9hCkIbY0hh8w8nSsqGL
         k1uk2hFmG5+5GBzAxjlsJ12rxHwLNmgZvbIrr4lRTbpCRq0o8wq1JgFUV369Gi+KiSpp
         oO5KhrG1HQWKWhFKcEP8nRtlxYpK3CZZqdXH6Ovup6e14AZ+s3r8HqE6TiARn/oT/guG
         o80eS8TRb/2+b4Q+GBp2OyrUAImBLJqS4i6fzqW8fSfpsyUQfmrkc2pUW6Orr0rF021D
         PLbi5+577rohIjeBeeYrdlHf13Pz4iYEIgT0fAZEDs/mUjhxBo2YHBm88sttCzFe6S9b
         uArA==
X-Gm-Message-State: AOJu0YyHZLcLzSrHMCMD4WYBZ8YMcMzCWolv9CHroqdHB0bqeoAZGfIP
	jUK9ToxHGfSqPzNF7yq7CQ4XoKiGUkdUf2pPHHSIn84vb/pu921Bfb4SL9QcW69DEK8=
X-Gm-Gg: ASbGncsdabYtgYtYNjByV+okO+1tCZ/Zf+oAx+EEpXCjkZ65ujFYEupRf9NRuXI+z6N
	Ll3Ke4VJES+qaoood4IAeZuL9tZbvRlD/sPQj/BJuG8sLiZM/3pHYI2Wbr0osU88wEGPloUiRgw
	R08g+ez9/x+9EBguDVOkXNtEygfjy5G5jAIjNmlje9UXS9C7Ni9sLEmsFEQofcvTyjorUNYIQZ/
	5jj68ZJyPw61d/fNS+P7dXLG2kR9CpQQBqFfeVnXSEuxAmmW9OV7g0vsu6Berb794S+QibUPocM
	6bspayGlTXRn7IcDvCKiigLM/Z6cds0F2PG4kRNWBj6Zeca64UewRRUHx0QFXiYO/0H3y+lIEw=
	=
X-Google-Smtp-Source: AGHT+IFQzbyhjfoaqCDmfEEPJM4MU0tVI/KTSBMdCJnveuC+5xBGYbQnQS4n5WKSyNltmb2v+iUGFw==
X-Received: by 2002:a05:6e02:11:b0:3dc:804b:2e74 with SMTP id e9e14a558f8ab-3de07d6429bmr174884875ab.19.1750195094480;
        Tue, 17 Jun 2025 14:18:14 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50149c68bfcsm2392917173.66.2025.06.17.14.18.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 14:18:14 -0700 (PDT)
Message-ID: <f373f634-8d37-4670-b119-940a8fc161f0@linuxfoundation.org>
Date: Tue, 17 Jun 2025 15:18:13 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/512] 6.12.34-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/17/25 09:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.34 release.
> There are 512 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jun 2025 15:22:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.34-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
