Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2793147ACF6
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 17:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075777; cv=none; b=e+//fpnp2rbGFLxRqld9gW3A8IqGGUblKRMo3OZqX4/Bl0KIg1Cvjoa+1vhOyX5xb+dfyLX5oJaF5HQSz+3h2XHAjbAwHlufjjH3m8gUzwctyoOJOwYDr0K8QRQ0lp8E5eDn9hEt9C5yLjWjueVZpIgDZ7mcHeBQxvZs6vA31io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075777; c=relaxed/simple;
	bh=M3DVfwU/m0JULqch2OXrqQDoIktVGSlWi85bz3z9oSk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VuBLohPP5tGhz3sRFwDTbPwP/v9Y1bbkL3YHBnjBbm/+UzKnMGiNIOK/V81QFH4eT874VSRLiMidaDnbOsuWR04a6Uon3Hc1/oze68DkuY6RODko/HVl2l6O2izgmOd/YhhSsfWQaa9z7SPZdMAZ8U3shOtTpt5lm5zsBfKedbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6+XiVjt; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6+XiVjt"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7e6b5737bb2so126095a34.1
        for <patches@lists.linux.dev>; Tue, 18 Aug 2026 10:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1787075774; x=1787680574; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=889CWzIwcDqm1G8XCqrv2SBVsVdxaQlsOgfoPJyky4c=;
        b=Z6+XiVjt77uGcYg5MdcnXKzQoxmCyKP9js1uZ1fiwaD1lyur8b1pKtvsj3RW9f7CYy
         UVdGcg6OtExLs3V402gLLLgcQh/QCQzqAWbPixEWj9+aaFw1VVQ1H8bTWdolQCc88wWf
         nR4QkC8ZTuHAAvbHGGwY3UzxdFIBd/gIVyz3g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787075774; x=1787680574;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=889CWzIwcDqm1G8XCqrv2SBVsVdxaQlsOgfoPJyky4c=;
        b=RQu8BR0dMbtj5aXssmNjBtctGRd2HuyA57h5SkJAbO7ABnyeTX7fYRhGtH5LBsnf2t
         Xc8erCaH7RzxF74i2FFNSH750A5fVMFT0tdjv9WSlIhWlEuvXfs3fUHXu51qwC+EMWo6
         zVaIGFCMLxhHBhztYdZ+i6YaVpFLvBpEw1d6XhfjuykgmOoUXzCkEtyAD5C35up9eFlG
         HFKnGFvojz5hyhhGME2IN8vpqFfApymHEkRMXnZ7Z2LiCCDXycrlyeLRmM8dr6PTrij5
         VDOFXV2vjHtGdZrSm9n9NafYHh13jFmuLMWNku2SBu9WcjJe2sVenNOr4NypN/a6SiAS
         GU3g==
X-Gm-Message-State: AOJu0YwJQfH08EN7YNdeU1ixy9uspbET3ZsUGlPupeN4LajiAzpMs1AG
	HyYPYt6FBKvKPoRhSVTzPy7ZTAUpa4nDE4EePwdz5ly3FjjqUCHabVg63vpwFbmHU6E=
X-Gm-Gg: AR+sD11rSe9siV5ZIQ/E///B3U6VHkQ4OGGFbgrJN8GKZI4l7UAu4dRuoCHzpTgGMQo
	lcEcKYE3nZylt2ascoFBzb1pwg0s8yCQsqlLhb0Zhz7ubtvoqNYZEcEZdXma3h97i7qrpr7nfd1
	SeoRndfsNXKdiDKpBRh5FAYLkhCeEhE7yaLKDbbGR0oYLUsUOfEIvLr39VGYCbf11dsns6OXheE
	wTwLn7jbx6Gz7g9GbiQxRy7FDEQQb8EpzALZeXiaxvm4LWX0ecnfjVUQyIsuUhVwUlrwfCF/Tp7
	EFhaiCJaNAo1AKCizo1f+yN3BX8bOGgPg/DQA5GVsT8MBwYJG/3bYXKP9MyCgfe3IJo3l2AKRg6
	NLJVfaWrp/bycwn9mYvXRQqxGeUMxC8jPIN48UxUjABWuO9iDKOrzYdRv7GEUn7CTJ2Yu8Vlt9D
	30gUsH0rHh/akRJKDJlWMnnQGIHu+8pRwAafZvGdWUJO7J1GaROIzOTzlJKdouncOm6xt3Wg==
X-Received: by 2002:a05:6830:63cc:b0:7e6:f7fb:9678 with SMTP id 46e09a7af769-7f423c38469mr10395776a34.1.1787075773922;
        Tue, 18 Aug 2026 10:56:13 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f41bf2cc6dsm4804215a34.10.2026.08.18.10.56.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:56:13 -0700 (PDT)
Message-ID: <3c4f5e88-538c-47a5-8817-d222adbaab31@linuxfoundation.org>
Date: Tue, 18 Aug 2026 11:56:10 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/609] 6.1.183-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/26 07:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.183 release.
> There are 609 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.183-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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


