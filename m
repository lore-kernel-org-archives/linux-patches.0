Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A6C1D63D8
	for <patches@lists.linux.dev>; Tue, 30 Sep 2025 19:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759259821; cv=none; b=kxSTtr3WmjebI3q71ocMei7WdH3QYZE8SqdxXwWKy9IoYllsvSAxqQbCzLQWqXMg8Djp4vffIyzivcIKzcRWHMb41kDWsL2T9X0Jwgwf6gB1ZpEEbealcivLH3uGYTcE+d0BXreRd9mhv5hcLpFHM2ISq9f8bCOlw7nk4KU/jIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759259821; c=relaxed/simple;
	bh=TL10qIi5vjrSPsRXf1P1zHEKDMygNwBXTK7y+x5rlqU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X1uXc7/Gkqip3fAsM4Yfc7qHbptBDhuT0QxMfU5i1QQTVhkd8m6UiRunTXgLt3k1ZwbriF/gIun3kPdEZpOk4FZGqtA4A6Hkywl/iINI5muZ4VileRharwNyqSovMa+rLJIy4P+Xaorh0hsoEP87UkCZ8hy1jAfZVNK87CluF5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FfW3Dzj5; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FfW3Dzj5"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4de8bd25183so64988251cf.2
        for <patches@lists.linux.dev>; Tue, 30 Sep 2025 12:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759259819; x=1759864619; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fldU7lyCsffYvOHrWcygkgb504/OYTsYgLUlK9y6iPs=;
        b=FfW3Dzj5XcsmGlCsdaIQw3qgjSdOoWs7UVYNvAOljm40MtmzJRsQmBz9VFPeb32FCE
         2y0Qse+lhiPfP1Ad4M9Ri7dyv+4FJiZOlzO1uSBreBTZyJt/lx+DPePiZvi1Hm41sl0W
         K6kVXduQjwvXidJxZnsmY0moAE+hlyGeBto+SlFFwo/0hmNPjjl+qsR46X7ip0pB0WYn
         Rbo0LtcVAyxFXTBCDYVAAwP0LZ5FE/MdOrO0tqtTWOIqtqTdXX85qzAZdR/ODdp0fUJ5
         Y+Rh/T+/NRve5beKspvNsEz2DxCsx0wRKAEeognj4AzC54+an8OIc9cKnH6U+hrVhcDP
         7pmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759259819; x=1759864619;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fldU7lyCsffYvOHrWcygkgb504/OYTsYgLUlK9y6iPs=;
        b=dd8+6jvIyRE1tWaKmakvORoc8r/NSVOkVY4f5ZJvOTY2BGkI9cBX6vL+d56KOYgXCE
         wGY54zDQZyJn72eyO/bjMr9P0EGNAe/JdwkJpnPWdHkAS8OgiBdpetComvJLKOocIfJu
         TgthHwmf+cWoFcB3gxUEsWTQQlPE+lWD9Ug0almYSuO4ZTFW5sqXY/YZL5HPL6/uF4XZ
         oe1WTGYplHo/R/TSkCPUMLlb44tHOIhrgSqj7jFiYyuEk5k4ncwBkOzVS5P5ZAX8RMn+
         3qqBLhHC8kVPqqYHJ3alvXX6KSg/8u4B/9nBDgbLT/5osop5oQdmG9PiMzESz5LXIQFM
         QqSA==
X-Gm-Message-State: AOJu0Yx6rc7R7AZ5uMAcUrziyrYUOoEqDZ5zdHn+lzUlsJaoTs7KhP3Q
	eCSSQxj3mTz+n1+haUCHpxFy1f9djLXluiNuwSwdTNhmyyKAq2MGtMtf
X-Gm-Gg: ASbGncsk1LohwzhToY35uq/od6hax2up3Fqdb2DGM+OXK1BQjzoGyDsIq4MZZm9LIrN
	5I5MSi5yqotKsiwpEs13evoEC9CtpHCHjnMLWUYDUp6i9sH8ln/D1739Dl1dop86wNnTDLZ/JgZ
	LqNPOdDJCdJ7ZYllyH0S0yKshN1JCiNXN0Fn1r/oRHG2Z7wByY1283eVqW+inuwEs6V4UJHzv1m
	fMlwKCF8ErOR6VYjr2NAq2KK6O6Ycye2FvbYTpkTzy/Cp1pQ4R7W2sR15lDedmLN8jHB02hBNu6
	nKnVc2ghZQeeEOWs2ku2wdw2Vuob7vNMdQhNm3Vc1o+SYpaVljuGd1/EOAalqbkVVFeM5S86Pcm
	wiqYFY2RSrpP9VMr7ecjfi6tboGd0U9wXVD88DhBRqljyjGsgHqPA5XR2fhr79U0g0dKhZfpIKw
	==
X-Google-Smtp-Source: AGHT+IGAixLoYK/ccLf469fUOlnxBKQc/0dR8BmBYybPUAdOplQD177YW5poZcfV4hgeb9P1tBM7ow==
X-Received: by 2002:a05:622a:18a4:b0:4b5:da5f:d9b7 with SMTP id d75a77b69052e-4e41eb11651mr10050631cf.78.1759259818502;
        Tue, 30 Sep 2025 12:16:58 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0b9458e1sm99203111cf.15.2025.09.30.12.16.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 12:16:57 -0700 (PDT)
Message-ID: <f7f7f248-20d0-4624-a412-598c278b03d0@gmail.com>
Date: Tue, 30 Sep 2025 12:16:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/143] 6.16.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250930143831.236060637@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/25 07:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.10 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
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
