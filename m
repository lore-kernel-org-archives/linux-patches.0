Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCC01B6557
	for <patches@lists.linux.dev>; Wed, 11 Sep 2024 18:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726077610; cv=none; b=J4ZsPhS+3yVuYnnfTAsM7g579lEWNoVkzs2qlDanmPgaSYBP5y2vTnPLAzXlNvqqSgpTh0pMJhk3/R5GlyoZYFogYkBa6QeCVSr7GmhWDcRrk0xjgrRWAvKN+VLVOdcS9z4EEY5gSEy0y/Ugl6wDIEI7s2BTeUiDEg8pJBTmk70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726077610; c=relaxed/simple;
	bh=IGUfTZM3RjT0S8QIGULK6eEVnu1Zyc4Xflws3B+6t4o=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Tf+ki1FsTfxi6dKjyl7fe65r4NBYwo4MCiJOlLBTiH6jKaR5CinzqrqQAng3Sc66Ob7lv05Oz6J8ofeQo5hnEokttDT87d3DIczwYigwogk6WEID/cuJJpKn0x8imiIFZ/P53EEbE3oqIL4QVkIRi/3H9RGzGYz+rt00u+pzgA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hdnAX4jR; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hdnAX4jR"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7a9b3cd75e5so9260185a.0
        for <patches@lists.linux.dev>; Wed, 11 Sep 2024 11:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726077607; x=1726682407; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7O/z9s31c8U7IgDWqDCwzkvn5+EALskUTbj+Et+ilxw=;
        b=hdnAX4jRsrsJbw/7Vs4O9kCIcwvNmujtnCIPJCDfgOZRZTtdyVE8ZY8EtYany/s1sX
         wc8ODf0DDue2Eg5BwJnTt0Mu+yYBWpzXGTzCfB4cCnZ+/73V3lnZVe/I9mLTH3eT7I7q
         spLVGMzUu/7HeSaxcwY/12tutf5pqC1e+OAagGVQmTwTvmgzOfRbF0etiz3IZJP2CW0S
         lFOaq+twlQYp+ZY7UKKw18jKT/G6m/BOlL62DzUpNWYod8VcWn5HYbPKonBAgSja4wSg
         fuU/eOgulaAWmijtt8HCXOO8hiULJJ+GgivjI8jlj4nOPUyMedKAMrUEtSc75T+r5jSN
         dnJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726077607; x=1726682407;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7O/z9s31c8U7IgDWqDCwzkvn5+EALskUTbj+Et+ilxw=;
        b=e6lQMG1+96mZmB0oq9VFoL+ERVkPiHqnk2LTVIJil6F86IxMMfOqxQQ2G1TgeGa+yn
         TgTD5OXauIukJVpu8iYeGnS3bc0igMNaecj91ZbMenzDtXyUkrihvaMShIhtr4Vu7ogl
         BvsSxfz1eP9BJXCarI+6CyW0PUKmF6I4He267BHavyyIcHyFLtRuThhFmVe/db9AnHaj
         ccTS5T8Qt2viD2EsmQHPvvdO7SryeTCDfNBVim7rtNPljdn2l7xKWTYf2YXZpFx+yWzR
         IsP6pfbqE0HgPLS0x1o26iT2VI2kYnZ1GMyxD8Hd4Hw2jx88iTFDM6B2A+VfA3SB0L1w
         CFRg==
X-Gm-Message-State: AOJu0Yw2hbZUCcljOzn9pLKTZ1ASYNTUkOAwiudbnk3ksh4VjB9uyazm
	D5bm31n6II8An45DOpWJO6V5zzGDe4ZoehKbw2OzdV7OrOM8QZdI
X-Google-Smtp-Source: AGHT+IEPscUdfvp1JBp3mSZwACCYlQV4uB6MSUv3gclADhMY/jhi8V1Lllwg+qhDYFJPTfh5lgMOLw==
X-Received: by 2002:a05:620a:2953:b0:7a9:b814:4aa4 with SMTP id af79cd13be357-7a9e5f5ee35mr30327785a.43.1726077606038;
        Wed, 11 Sep 2024 11:00:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a9a79456a1sm450538085a.22.2024.09.11.11.00.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2024 11:00:05 -0700 (PDT)
Message-ID: <198c45b0-6e8f-42a2-813b-b1e3d4198870@gmail.com>
Date: Wed, 11 Sep 2024 11:00:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.1 000/186] 6.1.110-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240911130536.697107864@linuxfoundation.org>
Content-Language: en-US
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 HGuUuzv+GKZ6nsysJw==
In-Reply-To: <20240911130536.697107864@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/11/2024 6:07 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.110 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Sep 2024 13:05:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.110-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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


