Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78223D524D
	for <patches@lists.linux.dev>; Thu,  9 Jul 2026 09:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783589088; cv=none; b=cqmu0q6VGWFhNb7rd4fvtJiTiGVwHLjsXBLGXz+j51VSzrT02ANg6pzMVlRhVWpoqdwZT86e5vAAA8+J4cRlq301gxxDeLMpUH1gE3zJE/ocXJBFQQfW4d5S6FNb35QS4jNw8v8pG8nFWbp1t0OxDLsahA2SwxxX8oAdMr+K0Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783589088; c=relaxed/simple;
	bh=CyRGUnL/glmmjF33KlopSetVt16IiT5LwvVSGVv4SJI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=mWitdqZLL2UPSzU1Or5knu6xert+Yvt3kHk2WIjPNpjZgOTqgJ7WAqaFcdgjKvUU4RKwrhd2wktlVS676BcwJ7ZEVVM/0VvlgUXw2HYegGiNMFqYWtwT+O1wdWAN3z/gFSlkAPzv2YBgN3CP/PI0mF8JgfOpTo396OPXlBzTYzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DHXhB+FF; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DHXhB+FF"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493b27c7451so8632855e9.0
        for <patches@lists.linux.dev>; Thu, 09 Jul 2026 02:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783589085; x=1784193885; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MKZMe0/wt8dPAc36BMO9qSsLEtJCrLevE84kprfUPEc=;
        b=DHXhB+FFxZ6ViD+13VmdVlBQNA9NJuXz6RBJuVrQs7eHLZpqK0pRb7pnU7vQ3zQsn8
         qiaOYObo1GcuJPjNRgQ+Tq9b9uvXTWstMFjtUMFPBNFhsBBVRE7bCqN6TNPEtXmUpXAc
         ozbO4MsFKgpFl2Vq7ypa38xDMqqBG32OiNYi/+rA5CKB0aLkjoelPNw8KS0Kz5dtZOI6
         JChd3ZOZTXO5FuExDs9Gxi2oQRCRzOge2H4Zg1tIBA1ANwH00f44RQHOhNaMG2ktrvrY
         rMLXTmnubJLpsmKdbUvcjUZbFboJ0hfwgjEB0wrjfUG2IYuZgOsL87heQ97+C4LIUTh0
         YYMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783589085; x=1784193885;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MKZMe0/wt8dPAc36BMO9qSsLEtJCrLevE84kprfUPEc=;
        b=gUFVunq6UsasBtmlJtr/s8J/s5O6ONjeHel1C1s9iB40XVK1IUNt4twWKd8pOvIdKC
         MnvA1PMtYzb1pvxyPOfwkxBiJ7I4Rd32+8wtNs3oHM//FY2yZLxqr0mGkoTwrL0TA+Sq
         nPUa1bjlCoGCrwYwcTaZ+4gYWxQfFHq5hd0Dw0jzhihnSHYqeXfpGPnWw0BhDR3s7Eoh
         p5ujmtfYVHi1rM+Kx9qhjaoluqEEzqTTNLAbLaUPrGkKYRQrHYz0ACUkflrUNirw3h8a
         1A7ZUUK24wTvSQ3EESexqQx74EMIwfnyyhC0yVvwR+5IJlCkMc5TQdlb0xivSOqSOOAw
         ErCw==
X-Gm-Message-State: AOJu0YxdNCwVe0VV4D15+pCQudQ2gFpl9vtWxFS5x4PMAsU7JLM+eQpu
	EM1uNj0EsTmf1fbJh4x20qznzDNnBwbB+8XCua4rGVTTf9sT1LRrLhxN
X-Gm-Gg: AfdE7cmi9D8HE4bNqlwaXK/IpjnxaglkJpb6cDk0EnfYFbAiudJG2+t+HqCd3Ppxjgj
	7kei6F1U32+wRrwfRmBZTbQ7bsKLj375elV0GtzquuOY6/ca4Hg9yfNofLFwIOFAe8AkUzgpRSO
	tBxMGhqkHeMT74WhObWAS1yRoRA+kon6aYPat01C0y6Poh7Vsnstwb+NTrau+Ef9nCsemYU8hXU
	l4lIB9l6ZoviHZce4huVn/YE+kSX1UAbwRSMjYl0TOceU1HC84h7IKNTgojz4PH8KlxciZ0kS2n
	ORxaQFm7PjqFUcIvBIdGYslmLd6RrJW1x1L/VzSyx+DetbAqCVLXW5hr59isAHA5jZvzsam6ZPP
	YXSdXaYUd0cSuw3Tnd/ha1MUVtyqJj8YZvEWx64/2LMOgga3oAQaYtRIyL+DfU0FcpvSyK6IGwy
	OuqmVJFr4/Q24Bsb2rpJu3tDFdoUwWjFlX5kgZpbfDjDvhEkGC/iA6oq54d4Hoqw==
X-Received: by 2002:a05:600c:8885:b0:492:7025:13fd with SMTP id 5b1f17b1804b1-493ec32a1a9mr14033375e9.0.1783589084775;
        Thu, 09 Jul 2026 02:24:44 -0700 (PDT)
Received: from [192.168.0.105] (88-187-52-200.subs.proxad.net. [88.187.52.200])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e580cc6asm101789795e9.1.2026.07.09.02.24.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2026 02:24:43 -0700 (PDT)
Message-ID: <5110c357-45db-4a5b-9498-5f5607d0b37c@gmail.com>
Date: Thu, 9 Jul 2026 11:24:34 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 00/95] 5.15.211-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260702155109.196223802@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/2/2026 6:19 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.211 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.211-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

