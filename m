Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D701C6B7
	for <patches@lists.linux.dev>; Tue, 16 Jul 2024 18:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721156134; cv=none; b=gIZFz4DQsjqyMdhAryLh/W/0Yz3YAbEtzTgJJHYxtouXRc4JjaKWsVt0x5Vj4CHtljq5B1142Daf1leJmwNbiIFSkVaAkfGY6qFJaO5ckN86pjftzFJmXSmBX4tNNIxAfAd9OaSAAphZWKf+Xpmf+uy9qkL2v5brcv5flxatODY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721156134; c=relaxed/simple;
	bh=LErKYFC2hR7Vmj8YbOE9TRx2x0fegmkk1AQHDXh0PLw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G7AyEMqye2tB1I23Mo3/HbWz3so7sgfWmpwWUEWtKHzHtI2k5ZMSW7msJs7Y7p4NzRCfTi5lpXD+KYxB4ydnFiowCQbBWkVsX1kdqU5cyqXzjl1gh3XELhJRCFX/HimECayb7D4OX7hyuHk80uw9sTtybwpcXWahy9E7BaBUcYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JSHmIRCm; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JSHmIRCm"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2c97ff39453so4409765a91.0
        for <patches@lists.linux.dev>; Tue, 16 Jul 2024 11:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721156132; x=1721760932; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p3Xxw7BDEuKyJmTDIMc9lI8Wfvk7nIJjN6wyfUy+yy0=;
        b=JSHmIRCmh2IqsOI2qT0amTM2qH9sQKxbomNJXeUpgK79l4c48DDWeW3CaFBvI902nX
         zvbnVK/NN44BhntxkgdJhEYBA0mTYFv1ulA3uhb7LKyIfEZvRrYYjtNP7dlo4DHDzkE3
         BCHVOqCiYyMdO5ZVgz19s29M4XQBkEEZkz/Co7mRLOFuhAhWDP0DxwIT+pDyY711Loqy
         K4GLw6SUuKyBYk5erCXiDimaUSpnR2BztjbDMY7zYlnJkj405DSoQUo/xAxXUGylMSqI
         8ai28sgV0WI/qLS9zx0wH8eGVs1KbDvJP3ouKuzcF17XVF9TdOH5RApbpNcrmgRoVETI
         sqoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721156132; x=1721760932;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p3Xxw7BDEuKyJmTDIMc9lI8Wfvk7nIJjN6wyfUy+yy0=;
        b=iQnnfD6wkNiCYKbIolON8JWGxjt36vdfbOc1cd2pMWe8/4VKojYfCmuhpvSlZZkDjF
         ltP+jX8zC7pMINmn/cd0uGFdGO/tXqDIiKX6zcRC2Y+VSVNoU+w/vZG0B2Tkene+vBYc
         iLNSDytNHUummL277uIe/6d4SO8iTU29M5CPhGkHqNYL2/9zkPvCXyXQXRkbfnG62zya
         NbwkMvOZFLqdpJZmBV7X5fIDSiWT7LYcz31ZbqRkUwJgfqJ9bZTVmcijTVWoLajK9+tX
         7rZujBrIZsbpUWjOKXW7Xgqy0xu74y+eJXJnkxs39o+E6f0TV2I9ta6x0PyBUlUvOqMF
         N7PA==
X-Gm-Message-State: AOJu0YzLHkvlNKK225JFENxjrWMFcHW7h9xZX9O11eogIB1N4TBvhhFs
	M6M3Elf2v/az9AuOQETop6yiqoSqc5L207ltvB2If8ukM87zC1kh
X-Google-Smtp-Source: AGHT+IFnjnaa0UTdqD4xiKsAh4o5FvvGWp4g3Zm+rHPDutZFCM82EBdc1F0virkcSrS/hgz2K5/Yiw==
X-Received: by 2002:a17:90a:46cf:b0:2ca:8577:bc87 with SMTP id 98e67ed59e1d1-2cb374921afmr2361057a91.34.1721156132037;
        Tue, 16 Jul 2024 11:55:32 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-2caedc92c3esm6643327a91.42.2024.07.16.11.55.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 11:55:31 -0700 (PDT)
Message-ID: <caaf5079-11e9-4dcc-a62b-132acbc2c6ec@gmail.com>
Date: Tue, 16 Jul 2024 11:55:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/121] 6.6.41-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240716152751.312512071@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/24 08:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.41 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.41-rc1.gz
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

