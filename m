Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A2E242D7A
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 22:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752098408; cv=none; b=WgLhzNISjNkGe+zFmkUISlvD4MrFf8GH5MUn7jBWQThKqSTNfrqT3ylkHTYeVX9Tse0j3rklImwMTVo5PtYZMjv6RYDYRlBXWW/xGDYhr+2ZWswlYaCuLbBUprOeZx2Ihfe2VJyKQSzGgC8jhiwYkrgj38BQODj0YzEVeP8JYUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752098408; c=relaxed/simple;
	bh=E9Q5ZD8hLPIv4GGP/IuhXIhHJdD5qFjRVobn8MvJD5k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iVD0cN/3EHZHTSyCEUTgv4aa9Pj1lHPj1y6yKGaK0LnDOniiCUayoC7hrqFiHfU/PXIzb4uiXpv6AkL9cAd3C8TkQ6iR/gpsSiLmaHdCPW0b1h0FoSazXOnlJ/4U4SxOlKv0mafqUHovZpWqo0gunPFwg8zkQri1+TXiPi5M85o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZG8gN0c; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZG8gN0c"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-875ce3c8e24so18770839f.1
        for <patches@lists.linux.dev>; Wed, 09 Jul 2025 15:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1752098406; x=1752703206; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=85sUwqG3UTvSBY9eq2mbMCJ2LiIG5KRrSnwcZNLE650=;
        b=AZG8gN0cIKb1SM7N4Xt2Y0ibgO8iuWFrYvsDECg6IavtFV0+w9ux6F0xBa9vy8D+g1
         mySsiCYQiEq8bQIOCSyFg4ewoPm5XeeXzGInT/KIXL87Jmku5wbMiLBiA4wZDm+yoX7M
         3YJLftluPNkdiagmLLTwN8US8TFZN4Bz3CqnQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752098406; x=1752703206;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=85sUwqG3UTvSBY9eq2mbMCJ2LiIG5KRrSnwcZNLE650=;
        b=D/K8JFPzm869CJwedQZQg0KXg272o7XHVUituhpu/jVbIRZKg+LZMEvig4fIHAengL
         A/ATP4sRqjyuXzSdfRATiKAAvnnSEGcBd9bEf3kTVKlt3HRaCwZKPVq5LmkHhKyDHwxC
         Y0DWiCXJnIlPO6uy4Xq/KhNgjwDjuPJSX+0QwAzIFlZsJXvwypyYqsEVRrq6vlwFJHIV
         IW/1t5+o9fng2aTP1R9XsI39hRPo0Sx91WA7tTiT1k2cpU+8ddkIYuVzD1wP+i9ulPLL
         UCaPhRu2og33md+VfooOMIwIfKLKam4kh0FIlfJUezDzTHVDlwI2bTNc9S2sORvlN4Xg
         3p5A==
X-Gm-Message-State: AOJu0YxRNwGQz0C4dj1p7jkx6uF1vi4kc4Q4JLG/ndQWqnefKUpx7O0p
	uP5nZkvJAcnAoMlsHnuClreZjvYjXinRXmgEqxjkPi9fNZKpQRgDyAJZTflW/z5QwVk=
X-Gm-Gg: ASbGnctFNW8jsZmBBiywpB/Ib0lVDOzMCxq+RchCu6OaelAkf27vN6RF8sGJ94w3qi2
	XtrnOQWBKgscQkiTvkwxgn/24Eo4lFFTUZO35GeluAItuuoFezywEorLpApW2syFTfmZSBY8E1p
	4m+kvIYppxQLHi34WWTZ3YWzpuaHhTzWkZe9s1uMS9j2497BhH5IN/RYbHZ8Wg2sZVrIedCTSA4
	3zBX48gNxcnLoSRiAg/ip3KI+GiSPYE1em1aoT3HWctxKqpsg4GSL7FmzKS8LRFKSFOIxv7cJwR
	nxfPcgC+foGbxFS/1QcqHfqyNS/586Lb+CKOg1cVeKVcd1cfytYc81FUZLn8g17t71AcuhtwYBb
	Bl5mRt7Py
X-Google-Smtp-Source: AGHT+IHun6TfsfnEv/6FmCADt8kyWi0Ooqlkv+w+GZgNdAI9IkWYVqmqHa88dkbi68Y4nRcRs4o3SA==
X-Received: by 2002:a05:6602:4c82:b0:876:b001:2cb0 with SMTP id ca18e2360f4ac-879663b35b9mr178724039f.11.1752098406062;
        Wed, 09 Jul 2025 15:00:06 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50556b25536sm33365173.133.2025.07.09.15.00.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jul 2025 15:00:05 -0700 (PDT)
Message-ID: <903f7d9b-74dd-418d-8016-264d60cf6af9@linuxfoundation.org>
Date: Wed, 9 Jul 2025 16:00:04 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/232] 6.12.37-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/8/25 10:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.37 release.
> There are 232 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.37-rc1.gz
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
