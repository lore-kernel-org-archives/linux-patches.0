Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA9F1D5CE5
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 18:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751566729; cv=none; b=K9PL6QVLDZKtAxL3V20D8jaxJvwZQAGbLyQ1kQamQAmH9uCbuMBhdZ20SonCnXMgF9Pwb7DkQznp+OPtAIk3xPi3o12edF37ic/UMJaCYxttxp5Evfc1RC9gXcwHFjg4VcyWHsbGcJdfOoaOvmByUXBqtv88A6z2dKOJdsxw/VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751566729; c=relaxed/simple;
	bh=GxNdkH6iQCVxUnWcMd51/S+Cd967xzHQCnfjJ0BAEN0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W5E/aFbkZ70WeWOytjx6lHxjJwXKGIBNF5CAbqVhla1Q02ZEUUecbXJc6yS2rHEfMoN0iaAirJS106BkcLEj6OwnEYBOKR271Kg2Qa+NyY6w49ltwUgHG8b3EpJUw1oIe3V3VvU6D/C/5wrHsoh7tVkA/7298QjO+qLhqgvK/04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B6JIG6hd; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B6JIG6hd"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-74b54af901bso232797b3a.2
        for <patches@lists.linux.dev>; Thu, 03 Jul 2025 11:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751566727; x=1752171527; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Pq9v1egaCEmmTn6tGC6wjXjlzVVZKLgrhcUxwPAiILE=;
        b=B6JIG6hdJ6o/GWPC30L2+DHs97AOvYWt1H989LLIoj87hTweiKVyZy2WMg3Gpcux/V
         Xl14WP20cXW68NcsKyTqkxOUW1S3NliNoPOdPxI/da4ztoUAbmVhq95YgDPWwNiBgTAv
         TBnoycHKteIqPZBoZrRj1JZwLiky8z67hTrEjQDir01d4cYMTQABU+l/UKjjjC25my5H
         qACBJZnjUWyMeY/nHo8DMc7pMi16+4Ja7dAAXHZf9YB4wTrxGaH1Jyrq+Jkqq0eSmWaX
         MK529i1LgdjO41c9uNpNcv0nn+yrjGrRmLrFfQ1X34yOVi8BWpazmWr4WmocKYw6uY6J
         XNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751566727; x=1752171527;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pq9v1egaCEmmTn6tGC6wjXjlzVVZKLgrhcUxwPAiILE=;
        b=CiAVL5WTTOh1z8AkPyRHbpV01nGole8L7MtKG2+De+N5Cl48wkK6bHdkIL2O6ey23E
         sGrcAgimSufUtLXnKo7r8YuOgsVK7aDCAQF60LxoDImDeBtkaUtWMaCgqeRKi3Q00DFI
         IkC5Kji9bMxhBdw2YKBoXmqjCqD1mlSflgB/X5OAxWLyb37ASG9mo3iFhBgGWY6vaI1B
         TM+ZGBBp81QQOWHHjPoS/tdC99CIuwI1zw4Wxkfio9zW5rjMEQbmgCfXBWlFHWBjrmqA
         gJ+AJHAvV3xa+mZU10xuBCSdgxE/bwXswUBeiNOmzlael3UeWRyTqlekwWPE/H1iaGSm
         taYw==
X-Gm-Message-State: AOJu0Ywqar09h7aa0EcLOmDSLf7Q7Sz83wo8GMm/6jrO6LHI5wNCy/8a
	N2sQvpvKPvBMF4eCX88BA5wUI7vDrfwCR0p5Kqfi9EiphV/XIqiLTouR
X-Gm-Gg: ASbGncvcnaME6Gce6Zw4j1AUefyKsAaY+Rxu8OCSj1MRvqrbHBySIU6gDWdVOLHUBfM
	u4UlCa8zQPhpC3amDpa6D6BqhF01SbgZxogblbLz0TAzeW7vFWoeAWcnjtIv1anJin4fOqKHdJ/
	+gLlH5SBB56DxOMpZm9+0m8jlTWCkelfp/a7wDhUMguRgCxiKJ9H9TxXN3eSehkaB3H2/IBbkOx
	dhY5kl8Cn4pCOd3YUniaN7jNQn8QLPSQ9X34imGzfYFOAlhVZV6cC8R+95WuJyou7vsFjvu6Cy4
	4O6DjwRGWFUb169S9XLmuKWsV2/eLubdhNTtJu+qJhIdKvZ9WXRRS1v0DjSBQkU9z4vIrTMrQHf
	iBEcsnnvbxW4BOg==
X-Google-Smtp-Source: AGHT+IFLjwBAdlDd9cJlKxJ/HWzmu1qfhTpB86GtUGtpcDuu6Hmo8yAkYKnsm3qK15sOpO/111juCA==
X-Received: by 2002:a05:6a21:3283:b0:1f5:83bd:6cc1 with SMTP id adf61e73a8af0-222d7c4a868mr12704320637.0.1751566727396;
        Thu, 03 Jul 2025 11:18:47 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74ce35cd564sm185777b3a.56.2025.07.03.11.18.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 11:18:46 -0700 (PDT)
Message-ID: <d7d9fea8-75b8-4b04-ab1c-e879ee3c89a6@gmail.com>
Date: Thu, 3 Jul 2025 11:18:45 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250703144004.276210867@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/25 07:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
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
