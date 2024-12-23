Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E648194AC7
	for <patches@lists.linux.dev>; Mon, 23 Dec 2024 22:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734993586; cv=none; b=mLUC8ck/qjHUduL0F/i9ZNv/yiHTJl9omg0JF7HdCToujQF3P6mmTLajmOKycLWMNox3ADFeOnkTvsvSQaWct/eIpVirPAPzloGNZgd+E5lUXXCnvH1lsaH668QPatB9RxJN500HzPndPR84TOfkC2xU3RJvrSYipZzYf2bVz3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734993586; c=relaxed/simple;
	bh=RiAI0tXdGDHFALVdgJYntF6iUfac1gyKXXGoBqwuDRU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nY3B1waA5JgFGdAmVMpG4xC4Kzs2x4jNcAyEtt+VWVfAtWOPFWtZuijt/2lmkz4UXkrhePUiNZwAN6FY/EtBAEio6EYiQ8LG+Xit2my9U3PtIgSvrzFN+lbYcV1GhCo/TWqXyAC8ZL+pRfH6xVrgEoQc2lWv4GVJ/OJJxLvdrtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1482FI0; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1482FI0"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-844d5444b3dso165354039f.1
        for <patches@lists.linux.dev>; Mon, 23 Dec 2024 14:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1734993583; x=1735598383; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=be7/RonVhjmu08VwAsKg4vuMbBxzDsJ2p7eX93MnT2k=;
        b=I1482FI0S6oL+y271OtRdkDmWalUiywGDptzlR5qwTv6m7pH+iham1QJLRwXdGQysJ
         DVhlW81zlskTEuTvC5A5FluIYhFXAfQ4WxOGvs6jovU7lRfcfFGeDaO5oLCzdq3jO3Za
         Svp24NAvKGi9ODeqmLTRR0BUOhzTj83/pUJ3U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734993583; x=1735598383;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=be7/RonVhjmu08VwAsKg4vuMbBxzDsJ2p7eX93MnT2k=;
        b=gdBMdsE4YaCPacUONBSFM3w1u2OoaWFVah7m5gHu1uMfEoAs/mu4Bmj0+bSx7rsjdB
         zgoaAgVmQtPgBwaNtuKQumbF6otFIiUK0EdjZi11z4lxpw2kQuHYz1eAhsPod1W1J1g2
         mbMpbQ3229fXEDpDpz23Tv9V3yLmlasGWgIN1XF0D4hMD3ZeRxUbbf8TRqSwEpK+slEn
         UN3f2aXg0kXO79vXAt+Ka0j660mKWQ+qpcbUiJzBo3MvO5PwreBb/ob//EJGtuyBXVQW
         3MAH9+xAHFl4TRi5aUYwcDMw27bIwx9yucqgiGkwkslW+sEc97IPjBmmmtGvim9pOJZz
         435w==
X-Gm-Message-State: AOJu0YyGNxey/0Uxh/b8a3qaEWOx19uUjLRh7DKdTr4modCgSvuvCAmQ
	gkOLL7bPRf2xIzwa2DJoqOZE0X3MuXdqbkaKwZJ8fJnFIyj5KhCllmY7FEM8x9c=
X-Gm-Gg: ASbGncs2fDmrTVz7wHDkEdTQBf0PDFvT18fwVT1oMrOEy5rzU79f3y3KSsTpdHPht43
	tgfICaL46X6sfP3n3ZF54PE9UaNfCB6wed6h9wgtsXVkucQQK83QmrbaExYUZW1iHnyBlmjGv0y
	KrhAD1LKe9pUnlAw20DOgWxg/+SRSM21e+VPjx/N7qNUWQUQZ6DvQzfUhHM4yJe5J8iXi1ud42s
	c59+GJJVRe6h2rlbkyAZdx9fuuDPGi2+90SHCi4cxE8HAHPUB5WK0Fb4ee9XN6lnvul
X-Google-Smtp-Source: AGHT+IEz+NIDzSEZUcGPPKarHrLAfuW2OviDkOfngOuKgwzh34HNpGJ2TKkOEJkYaXJ9EqsA+Mqy+A==
X-Received: by 2002:a05:6602:3a86:b0:844:2ef3:a95a with SMTP id ca18e2360f4ac-84988d25967mr1988497939f.7.1734993583027;
        Mon, 23 Dec 2024 14:39:43 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8498d8eb32asm239386639f.42.2024.12.23.14.39.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Dec 2024 14:39:42 -0800 (PST)
Message-ID: <33cb0bbb-d6d4-4637-818e-83ba4e7f278f@linuxfoundation.org>
Date: Mon, 23 Dec 2024 15:39:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/160] 6.12.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/23/24 08:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.7 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Dec 2024 15:53:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.7-rc1.gz
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

