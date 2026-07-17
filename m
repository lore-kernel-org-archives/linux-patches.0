Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9002C3BED69
	for <patches@lists.linux.dev>; Fri, 17 Jul 2026 15:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302112; cv=none; b=AT4r6W9JTt+s0Fa/yXnShmV+iiREXFxSKWPx8haZH0niZVc4eGKYkq/XwFtQudVKauVwr03pfscCsMpwSsJ2XerYpQZoY+BW32Rt7phL/kQoCiKYDrU34oN8TFQGFxWDGlX7pEhMbezi854IoQw5WCPB1LXKXGzHcKp9hGcrcaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302112; c=relaxed/simple;
	bh=slActN+LG+kX4UR/U7IgxrFQHhsmFcw5paYWob5e1zE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iXUILGeGS/HKVWJBMGvyt/W8MB/SKcNZvGEo31YKAh9zYQ3fQNYHx86ATj/D1QQd/o5se1MNK9/4J2Co21aU0OBTCpugmStfwJqU3SCwhbMNS44huTGjkAtCW/ilG3pdSQ3AJ8ocAhjOhAURgrYn23rYoFfMfgI60/xchX7C6Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6/jub1Q; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6/jub1Q"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-497d3e4460aso1480785b6e.1
        for <patches@lists.linux.dev>; Fri, 17 Jul 2026 08:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1784302109; x=1784906909; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rBq4hL5G4a9IGwnsXBItyfm3yXQ9D6Km3DzDTKJ1mgU=;
        b=M6/jub1QGcxdFXzOhWbzLEldcfgYkvRZ593b6cTS4a7hDkE9Fr0Oy14XecMzx7ChY2
         k/5wh8vCWmZesPvMYeJR4ZI0OH+yapcMTYL85Ww8MJeF9uKlW36eWeMdiky1d2SHJO7Y
         0Wkde2nURyU3pXujoiMuAV0+NXHO4GjVC646s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784302109; x=1784906909;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rBq4hL5G4a9IGwnsXBItyfm3yXQ9D6Km3DzDTKJ1mgU=;
        b=iHgMG0hp9brsZmgOpHRA/pWgoEpiR6+KUdLyqsyQX3HmhuFbNg4R4NQ6ioGgVOXbOl
         g4uLU9m0fxOb1Ad2g40VyUysJLXwLtf6lSOFvpT9Y5+XEuKDI9aWE7wD7EyvKj4FO2c5
         znD0c7KKRALTTLB3853bVsanYlE+qOU2KOpfSSnC6IVN1FEXSgGvEOg3DR/2gXRUHemi
         QAQGazrh7A4RtnMRNJc/27izu1QZvKou2Z9RLHaNNXU5FCw/TVfX93GlPgPWutRuQDWg
         suhzy13wT3oOwKujyFFVDv60OsFyexy+1yEvuvhHhDzzod4AO/FzR0rqipeRLcg+48BV
         dV0w==
X-Gm-Message-State: AOJu0Yx1mgmBYv3zchMZh9MH+t3tvpXpdIU03OQTqnnAMqURyv5dELZL
	oYzr53l0/NoCr9HUMoFRgO2ehUsH1bw/ltZnzriwCoWQGJE0neUE5sTE+e0SL1vzqRg=
X-Gm-Gg: AfdE7ckgbH2RO6I43HzYa79K0Z8GX/6JSRJGGoqDxAhSa9GqcFQXxQoneRLMCFJ6fAu
	DvkZ3nvUUe+SHULiY9Rq09CNAFiVjwUSmd4+myCIsZANTixZXiRN7OyJw/FNf5vGkk8BgbY5WVQ
	XEJPvp/JeGb/4Rk2BpaCxHy7GFH2+DNMLQHJsjADSEGnVOw9SlS7rE1tTL97s+OgynkXMPoCk2V
	X8YW8psPSABUqMAAqnLAKCXjiY1TRoWf04tXUtimWucQtoWVU0LE5hV3XxYLjGGlSRDTLSFUOh2
	zMqU8EfJfmdhZSZQJhBHzSAaS0Hjb9QqQ5B99FuNWApNBnNGjR9Q06ME8QsoKnwR+vyZVXsC1tS
	LgViVq43Z/igXLvwY309mgJvp9Y+5lAUq8Bd3tNQeDTP+pyLbqs+7FuwKT23XOl+46dH4rLwTZ6
	kXH44Uqb2COWw=
X-Received: by 2002:a05:6808:2518:b0:495:7d58:77c0 with SMTP id 5614622812f47-4a4cf4f8db1mr1416900b6e.20.1784302108985;
        Fri, 17 Jul 2026 08:28:28 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4a4d3d4aa0dsm983905b6e.17.2026.07.17.08.28.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2026 08:28:28 -0700 (PDT)
Message-ID: <636105aa-266f-43b8-b648-af744c59ddfd@linuxfoundation.org>
Date: Fri, 17 Jul 2026 09:28:24 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/518] 7.1.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/26 07:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.4 release.
> There are 518 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Jul 2026 13:30:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
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
