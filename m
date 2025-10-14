Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0599308F2C
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 17:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760464366; cv=none; b=TL3kUvrKY5G3JDkU4GedmJTnRqpDx8xhnQJ265+sewSPeqbxH64p7jEw1Rtu/d0zli+UVCvCLfT+9KTwJyAJnPSLSzI1P5UtjxTjD7yw+Q8/5juN0NtT1KAdH5gw1LpNVQOZJSGXbAsDfqxG58rGnG9it+zC7HF8UQoIFlQtMp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760464366; c=relaxed/simple;
	bh=Vk8hTPSpCZlav1c+s4Whx35A6sxLw90BVbohmPvOMCI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=liWMKad7ZYIrL88xMpjoYMuLp9ytifbn0aSnCb72aiNQGbu7zFgqAtIThF2ATM3WXynyMRUAF0PwptI8xQL8A9+F3q02+OuximHBzVdWGRtr1wgsS5015tFy96tniG3daGwjgmeD+qNVHGF7iX0y/nKBjx1XB2ajODQ3xKLowWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RbRkDMvo; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RbRkDMvo"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-92aee734485so205413039f.1
        for <patches@lists.linux.dev>; Tue, 14 Oct 2025 10:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1760464364; x=1761069164; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jGxq/8VkxT40k9wgER3vpLBqBiF/8xTWMryj+EkLgt4=;
        b=RbRkDMvoqcssaSymmSQqKHzfGYeSVVkMlLenZ4kvvUijWG6oSgq5EDfiidhRjT8UkP
         zuRDVcKvWHVFKqOZZ0864dJi7bhBpA1rYY789vT3pWXwRR2OUEcAn9btYQC5oO3+qlOm
         rc37ovew63nlQO2K5OptiJrGN+wh9cIIwX1s8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760464364; x=1761069164;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jGxq/8VkxT40k9wgER3vpLBqBiF/8xTWMryj+EkLgt4=;
        b=FDsXjGPfS8DeivspipleWI2gr5c6gWZSl5m+hQnbUBM/6k188lPFXWe2YlJEkXOe9H
         8ExQHMGMHy9mHA+BhmC38QY5fHdjgHH6z+kMnS8nPDft/wAboQ3ZssxL1MDiu3t5XjLO
         EZUxjTApXHkInvs2xh/sRHRURtK6o1ufhLLXNLovFm8JKYGDGJPWLrX+PNv4/E1UYXTY
         pqsgP7HlIlKOkv319fU4wP6igtIt8TLJ7ixpdQMgRnV6JoWiQDazTLlOs1m71XFC2oBf
         D5S8dq0HVmL1cGIp1Ei01VfJ+osOpEiT6q34UwdTzHW/4YNmIe/HWTGAUwC3Z84yV0nH
         7kZg==
X-Gm-Message-State: AOJu0YxiFNgPz/ylwDdRBeoYitWwwwsQCWhKkH5aQ4NXnJJvl3YGBCLR
	yA4B2FbgIZd47u+3UNSgVrOE1RhrLvt8qzjtDqTJD1aSIXoABeeLnf4ATt/ArJEw7mc=
X-Gm-Gg: ASbGncuCh/6CeiMtyPClsa1CYo0INr1X/uzk4Y7PaD/QdJO8gC3dq+DnWtYy+WckucN
	ZwBxGWhgx1lbeuSNw+O1TNbWvsGmvnXo5ZsdLc0hp/ubWQLSOdnuMg0AitC2ZstV/T2T4pECGtM
	0SjXCV8pBjz9LMNghI1MyYH+k2HU/Wx3x3qwIRhaZS/7hBERuWJagCBs1O33wVfNHkyJIc/Rpy3
	mGg9wUXwXbCdwf3bTNRErinRhN+fjHGW99uCD9rjY8NtyzeM1KJ6KgTeJP3zcBoO9FYFdGrzdhS
	4yV6t5YVOfa6gfNUXyusg1vh8yuSgh4SPwr1ZoPmmexKSedggFpgT81DlJ4CZiaSIvMe6evf2td
	6ONjhny6rJ9cecNRcA7h8ZAfTJkf1PB0Wb333Wba07O8WQSVCB8sX7NnC2gW6tAEF
X-Google-Smtp-Source: AGHT+IED4NsTeiB2tjQZ1qN+qgCtT8LJzFvJwI544fSE/j1qtAtUcoMqpbm1m3kTi+yIqsP0iV05WQ==
X-Received: by 2002:a05:6e02:1fe3:b0:42f:95a1:2e8 with SMTP id e9e14a558f8ab-42f95a104bfmr177063845ab.24.1760464363522;
        Tue, 14 Oct 2025 10:52:43 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-430a7c45b1csm4645205ab.40.2025.10.14.10.52.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 10:52:43 -0700 (PDT)
Message-ID: <6e9ba617-8731-4a78-bb56-eeecc6a25897@linuxfoundation.org>
Date: Tue, 14 Oct 2025 11:52:42 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/262] 6.12.53-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/25 08:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.53 release.
> There are 262 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.53-rc1.gz
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
