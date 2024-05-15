Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44D038DE9
	for <patches@lists.linux.dev>; Wed, 15 May 2024 17:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715794276; cv=none; b=ri4mQd7NJsDkGAKlEyHuPyIk0lrLSusH63IgZ/k0ZrGi5M9Wi08d4q0cGDGwD6pemI9qDkEbx+/MP8elMje+RGccwWTCLZW9Q8W0GTzA8B/ASVn6N8GfGuSign/ro8AZFb646rxGm5P8kYVngrC1BfJ2I/9OQX9T6INlbNsz3nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715794276; c=relaxed/simple;
	bh=WspG4dbmpI7y3HN4/j9MrTs8m63DfPJvR1gFu99A4Pg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QJkuYd5vtjm+iTJLxrRWxQRiBj5QCKtI2ZR31Y26BoYQS3I7yz6CGURQVk8T4kMSEXhYQujWGyngK/fgfuMUHxuxdHKOjGOz/nVrhrfED1Mi/swJrwzfLbSK0f1Rlfk48mIyy67Q/Adx/izgVisxXitCbtYTeTIODxr35HD38mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jcobQkkf; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jcobQkkf"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5ff57410ebbso5644292a12.1
        for <patches@lists.linux.dev>; Wed, 15 May 2024 10:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715794275; x=1716399075; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wSbs3QJZgIV1wguU0m7Hf9knvWUOvS2qBtHCZHDe/GI=;
        b=jcobQkkfqfYxsFyzkB/iQzR36FwxmIUWJfIeNglvDB8h7B77r6RZZFTPavDvwYOrM2
         Ix51VMPdNsSuP7mhW6eyYRfV13dZj7WQZohkJQ7S8QrQn/OxjVr8hMRvu5q6lJoitLfd
         KL5XEGLAgggC526JpkauVF0iO6R1TVO7VSWjXLfilXhCBebpF3HvXVBTVB0XFUPmo8uW
         FGZjB24YQDJVJIDZzOIj6giFJLzNfZBAujgNbhhkWXIKkBMM4/SPzeiEl8ujxiEIVZU6
         oeINdk+iymIdQUv5rvsEiVXPY7iliBbP+ylV3RixNtu6mYCFnalJ9HZQ149UuaUDTtl7
         gJ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715794275; x=1716399075;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wSbs3QJZgIV1wguU0m7Hf9knvWUOvS2qBtHCZHDe/GI=;
        b=r7mWv4jO5XHkv0rWC4iBCR3udolBXyH4CAVJbOkT9Q4Rf1lXGZH+dfEkfW/G57LiKu
         nJVgphZNlgw7cuCukxQtfUANWWeJ9Fz5Oo3j5YXR4h7TXRz4TM5IDpyXbSplj+giTTsS
         LJaM8G5CLy8R0FiTczIURTBYHzPk9UAaP0YCOdFKCTzqUCxBHoHVEJV1NWsaJAHq1Chy
         wKkJ3iYHj0XyFPiz1g9i2RFv1ES4SqTd8stUZeIXU3wvH2BEs+c9gSwdaUg8cDf3ClJF
         UHYwIyhibYWtUkDsXqodRL7HL6DhgFllzPlmEKgH/nAIijN4cMXjTQ7K/2hv0W2I1uE7
         wgfg==
X-Gm-Message-State: AOJu0Yyv2vGQXrDmDktyc3+f3OZFpz3AnZRU/VEaXJbY8ZFHghNn7lBb
	ZpNriNuxSeh6WctaPPIyEO47LDZoW1p1w/KSCzCYSVk4ALaJodXa
X-Google-Smtp-Source: AGHT+IH+1P0V+5QqsR6vcs/Nm9esEuTsfpdd8aqAIj8buKx+p+1+eEn6RQ/BpkqOCtB/jKSmBYKcQw==
X-Received: by 2002:a17:902:744a:b0:1e5:3c5:55a5 with SMTP id d9443c01a7336-1ef43c0ceb1mr151404605ad.8.1715794274755;
        Wed, 15 May 2024 10:31:14 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-1ef0bad819csm121148485ad.84.2024.05.15.10.31.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 May 2024 10:31:14 -0700 (PDT)
Message-ID: <6c2a2127-6db5-461a-b54c-05b73cdd146d@gmail.com>
Date: Wed, 15 May 2024 10:31:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/309] 6.6.31-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240515082510.431870507@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240515082510.431870507@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/24 01:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.31 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.31-rc2.gz
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

