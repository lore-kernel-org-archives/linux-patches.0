Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6B51FAC5F
	for <patches@lists.linux.dev>; Thu, 20 Feb 2025 16:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740067997; cv=none; b=Hh/lf9Y5gl21UR7IQhTVT3ICZY2QNWi0MiLjDhkcB0Ov0FL1GoZjy12ukYuk6WBauHtUgkHTs4LkhJqavVwXbaC2iyZYG1uax2YU9V7PnF9dymDFlNDjS9ZEv9uH22Nz2z6IZ4IX0R164+WTX7sHF6ZCGg71p4brBM3598DAqVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740067997; c=relaxed/simple;
	bh=ge8tDROtqPFb3OtBLB+xMWyNR3arwxc6s3la74fZId4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KS9dgV5QNkWLsd9DS1YeyNzLnV98SCvYdQ6HxIhh5QY4uotjcZBc1aQyqnwRp+ujAGGY8HNZeDnRCNB45oG4cpuoDjzTAf1aIiyw1DgiAnCdWuFpyIGP35c38zo5GmQEpDY9pm5ZD57ckLwzbiNtL8Hc9hkvUcR15lJsNf/hLw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VROuo81c; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VROuo81c"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-855b3e42c5bso31380139f.3
        for <patches@lists.linux.dev>; Thu, 20 Feb 2025 08:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1740067993; x=1740672793; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o64MbyeNKxrYo9iiqLxo3YEJFFUOkSLGKF7YrDzWVuU=;
        b=VROuo81caNOz33Vkep8z8YwOo/Bn3DlDF+/sl4zEyxwUyP3PfuSdYh1cXlG2WIgmk2
         dlYd23wtAO6Z+N2RBfR2FLzijQR9PUmq+Je8GfeuNjF9l0PAazcVJfejcQTkySSH8Kgy
         vTYC7/6zO5ir0AWXlwGpDfhyiIWrirhgcVmHQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740067993; x=1740672793;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o64MbyeNKxrYo9iiqLxo3YEJFFUOkSLGKF7YrDzWVuU=;
        b=kstcE8g8TeCR0noKcND+lISq7fbcWfrZiUBl23jZ5m6W/OtsnptRTYD0ZRGCfuZ6Rw
         wyKAnGZtuLwhiRdbpP3ZXb7SyXm6pIFjm22+uaJR1Vk79w2WbxfjqhrDhrfSqhBlD76N
         3WIbPDliNGYaKNoR7hOE8/p8CAahv7TqVuZ9UXXM4A8fU13CeS6BNXLRTw4jECgRyMBi
         IH0pI7IzNncVUMEz2BCTJwusTfxV7FCa1Acfj6jYRk1dfZS77DqQ68PG3ILjnoiHb76Q
         +15okYTduxjvJbF7bVTVWmZXP3Mtc/Ap/PmqTsVs7Ugmwl8lpaiBqd25anNkiTZ8TBRS
         R6PA==
X-Gm-Message-State: AOJu0Yxgn4dcHRIENQLGetHCpol+UStp0Oe1dCzayl0mHiwgmgh9kHM4
	zX2C0vu/aeoE9efwrcY7aUjk5dKceI8F4sPUrkW+3s+w0pxr4Au8W1sJfn2DM4w=
X-Gm-Gg: ASbGncsPosYxqzy44paLr5C6Hkybs00EJb/sEZvivnFLh/5vAq83PpStoO6Xq/gIOIm
	f7uyY5WJKNY/G/QjhTuK3enQhZV7B3dxa9LkCsKmar/d/QfuIln9iQSqlKtMjZjOngKgghFITgy
	9FWMN3jmC+sZkuh5CiAhQlq8xWGSpjnFzGM+Lnf2m+ayQ97bpaNYiX//KSm4apoh78FNzaYGr/h
	L4VpmEWCkiOjBAT2HyPc++v2Cz9jRT2aTVZisloF/EeZVA+MNzcWNRWSBPDpWV98Dna4cQf0yjt
	s2unurRLpeRV/bC8rT2ogKwDyw==
X-Google-Smtp-Source: AGHT+IFlFgsDehQjT4J7TYSzBZJFTYe25Dkt/CW5UyAf97Mbw/pAy0RXZVZebdzjiAytc48LSVF+oQ==
X-Received: by 2002:a05:6602:1607:b0:855:d60d:1115 with SMTP id ca18e2360f4ac-855d60d1332mr118178739f.13.1740067993088;
        Thu, 20 Feb 2025 08:13:13 -0800 (PST)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-855921817b2sm180941739f.17.2025.02.20.08.13.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2025 08:13:12 -0800 (PST)
Message-ID: <ec8f098b-c157-4ac3-b109-2e7be64d8747@linuxfoundation.org>
Date: Thu, 20 Feb 2025 09:13:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/274] 6.13.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/19/25 01:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.4 release.
> There are 274 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
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
