Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D78A21CC47
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 22:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744153176; cv=none; b=XY++1tMIKlfsvFB78/phcGVOeuMnjdvU91BYUlf2Ve9p37TDquozNlEVFH2E03mE8R5b0mgtcOSonvqydKHkooomAVzxCenTeVQQWMJcxaySVJ3ed7BcJ7jgIwqlWBu4yQeEGquRsYQI6/Rt9JxVNlVPu/d98HyTpZd50Awg5wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744153176; c=relaxed/simple;
	bh=l/3XS5nIqJsAU3kB74Nag1324TqFZCJpfxHsp40JYXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QUuyoYrH+MFs7z/Z1Q2rdepi28MtyRwDV1Mv1oTIOeq5Tq3HiydCAKandgcHIUvbmIU52tFI+4TOfJUGKld0X9+3fw5BDdXaqkg2OZzVjkXbKWh07PtZFqsVcI7kOD1QIn7nREpxGDcNu48KLElNkQO+p/eotqzecIRHOz4/8qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jdc68KCk; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jdc68KCk"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-6042c04fd18so1611841eaf.2
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 15:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744153174; x=1744757974; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=pkDcBJ/oOVKPcufA8BKKqayVLGOZ4HCiJgAEI5ThhLg=;
        b=Jdc68KCkTtY0ZWmW83FBYWgUMjK1ATUzWF21ZlnVC0WZh7bc4N8HUgCfsUY4wvjt8m
         /+RLnGYK8/tYrZ07G63Ng2byYSmI6dq6ljdnvmPTC0uRWAHuQFsU/aFxWqvbImdCYeB3
         cfRU2VI+4u+sSo7bL/JiDx4PL2/O+++zsDABkY3bzlOn1uzxZroQ1w8t9ZiI9OTNzZtr
         GOZojBtmyths0IHQQSCHScm8J4Y/5rHnkrUV1yRs6BKye0Xwqlr4kl9Fc5SewnxrNWhD
         Ca8H3xz+WXDoFAfR8CW+n3tot/sM6u4HnTNt4IIMUJrIw6msGaQ6eDsw86XPT4QyIW5f
         HnhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744153174; x=1744757974;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pkDcBJ/oOVKPcufA8BKKqayVLGOZ4HCiJgAEI5ThhLg=;
        b=ke1zKrIFxLw2hSkT4RlkSpsPw7csHqjiPBz1hNkNUAgaTOT1979k651s6bzzrdms1f
         u10Vr/P8vzvrI53Ngq5W0IR07Jh3ojwXMGZ0vik+bbtvMbBbVDwApDeQS4qxigKYklDF
         c/jAUUVCkDFoiH9jmyyDshjFrke9l6K3Q3I8qENAJWDa9+/HECCw6W0ZtCW/8CU0nuI3
         xGeRu7IC2KRCNlCcjdd2HmhudYzI3UWqnu5Tgn1ls2vVKO/DaTNxaPvCClVryLe5b9fg
         cq8LASOUzvmi5YmygLMQ4LTm99hl2OBi/CaGNcI02FnzE/T1cbxAKKNMXMUHTv6ylmw+
         q4DQ==
X-Gm-Message-State: AOJu0YxyrUHgy6KEdWsZB/wql6TG8LTFOaDiJyTtRY/Cif1DaWmI07nv
	4vfFqX/ZApnFTpqJFoXIWdodbL+EDkmlnideSPDkPWJGYUJoBq6r
X-Gm-Gg: ASbGncsOh1P+cDCTSKHHzfr3H1/75BET/igIR+xAuAmTRcAJ+muBdOBgrhD2aTK0Ua9
	0EHPaGMYlzenZF2prNNQFO/CMViE0BumRKfBsWdymiFsCgA3riCxGz5eEj+0QtPUayQ9rENYVKJ
	pnHft9hjqwN1okN4Mc+mWI/UeAQwe9oIMmnCjS1JNyowDg4IFBft/QNUoFgg9FEOg70n75RA4G2
	IqZ+2wZo7Y5bV3iZ/B7khRApZzsqzEa/tqib1EkbfwxSyuPLzPzIxtGmKlW5hQj+5CfOTIWAnV3
	/6aFuOlRVzgOGrjWrB/xbr1RBw+Wr5j06fZU6/zWblm3q8eYm0dywz+gJlIT4u3i8ThFBM3Z
X-Google-Smtp-Source: AGHT+IHpim01rEPiZ6UQ/H6fSpIL5PifTJj3vLc9mXL8VSN6dgPKWlZ1swy0NMpJLPIS+W4pMfJzqA==
X-Received: by 2002:a05:6871:6504:b0:2cc:3586:294f with SMTP id 586e51a60fabf-2d08dd7faddmr514579fac.9.1744153174245;
        Tue, 08 Apr 2025 15:59:34 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-72e6515c503sm624443a34.11.2025.04.08.15.59.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 15:59:33 -0700 (PDT)
Message-ID: <c3a72fdd-6344-4f53-b4a7-eb87e346cd1f@gmail.com>
Date: Tue, 8 Apr 2025 15:59:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/500] 6.13.11-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250408154123.083425991@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250408154123.083425991@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/25 08:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.11 release.
> There are 500 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 15:40:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.11-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
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
