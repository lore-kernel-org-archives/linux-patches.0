Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E2C30C176
	for <patches@lists.linux.dev>; Fri, 15 May 2026 20:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778877405; cv=none; b=M+8UYyDqjXju9yocyrY1d0Sy6JIAk1MTYccr/RrvW+nnqXiRKDDFa1FpJ8J3WChYEkkph1CikNe597s6A8RyD2+vcp6LymsYcXye9y+7wvdcWDzJ2Wl7OZhX7liZ9RTmxPgC1uB2NKIfu9c0T6tqE3eVPvGynUnUonq5fIwnD+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778877405; c=relaxed/simple;
	bh=AUGauvpW8ZQdtrjJ7+4XT+ajh18tzmyPgzRezBAnS+c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aU6CyNxmpNAQJpr1oxf6HP7kHDd+F9u4ZUbVBypmHR1sSNxpwxERU6+m8Q29KgNTmNRq3C4BqPZqytJpHRU8UTF1AwI/QmbU7OGrdcIeXYtnefLvmsmNWg8T/dg4Db55t4OOE01aH/rN0F4fUapzoU+Fp0EHEyVhnmNa+yEEb2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LMCiLiBM; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LMCiLiBM"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2f03d6cf77bso299390eec.0
        for <patches@lists.linux.dev>; Fri, 15 May 2026 13:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778877403; x=1779482203; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z4mFFwQJHfvlMsdIT8D+sKLdk6VQRqNMYh+zPM0xL60=;
        b=LMCiLiBMlj6h/73pMak2xXjFCb84GVE+FpyP18bazYOjRyDl/2ayJErB7hpXW+1QYj
         E+zAK7k2pMUbmUK4WRPHVuxeLX0QWjgpYEwWgAiME/3fyC7VA3WFnbhDIdV6Klws12K9
         gv3Wdb+t6OFkjv3d/VYudj8ZZHp357gGLThXZLTGGBgRSvPBSJJlYIFNKeP5BoO48PN9
         eGVYZVIdjZa4zt3pPyabbHS1MITskMXBwpc1zgEjcBu3Q1HfXl1suwvSUGEGSdugJx8c
         jq4VnmF7MVbvmlWu/66rMZ/+D/rxGVE6J7zcu2U52oiyWYDRTKs+QNaDtVI5HxkcT7y8
         iAsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778877403; x=1779482203;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z4mFFwQJHfvlMsdIT8D+sKLdk6VQRqNMYh+zPM0xL60=;
        b=jMCC773H0LthnWGF2RhQfwmkk1I3mvDKffWZOpMsfMNsTrX5AvYXrOaVhVdgK07m/E
         i+WbCQfhOQ1I6Y2V3jKRkg1nCKEtCZKefz2C2BkFbxUv9Xwvku+Ugnp3yZDl1Y1cE/4x
         3Wiktxt9Ia/mtJhDPxy4KfoyMhlt7Rh0lqEkygmPUuJa0l5JneECVyalg3eYIwh1dBoX
         AuXKYT+mlwPvbfxOZFDNHI3IZIrsRek3g+1xM3iue6c62JWvGi6Qn6FQdWsaHbvkR1SW
         XbuRHXQpI1lcGJ4Y5AIBRW447VSnDnQuhs0H/AhqvkGnh4OeCf9QxsefSTQqkhwvr9Ah
         3RhA==
X-Gm-Message-State: AOJu0YxUWXnCKByXLnlFqpS0yFOHRHlP7yttlXldEpq8qtUfl5mXlzUH
	K3lkqWVqthy+SodOOxKDt3kz9PNs4X36UehyIPFPOiICdJWrFPakeeCo
X-Gm-Gg: Acq92OEBpBIcEutt/quKWoAU4JSxygYKv56JfWKyQI0ccSqPFJSqRhauZWm/RomYbue
	5mzpYSpEgInYF0xMqjC6owOESUWNdRL4BbyKP3NAgxNJQ4kqq/GxFesNZjzbmc6Irfmyd7AWbXJ
	dCN49eAKegjh68Y/Xpz5MiNjZV4q0EDrKYuprg+fV4Plbpll3FmKrPkNGTFMNrbwOFKms0RzjnN
	zr8JwjsOgetckCgZ9mXCc8W/sV8ZlCO5sjk4JhwDEzBvt/11TORNDxqptp5+9IzGHzVn4EjwYZu
	em1yyndqwCpN5RLM/t22kHrNGHZRWULxWw9hbxZKUlF+wW5IrRIwvCtBCCRunEAQhd8YmpdsRfK
	0ZUdx9LqgCzjlGug2o7cJhNvHEu/1keXbJ5F0GHQSi2bTth2h+kgMIglzjGxI8mrYfmCxpWANIV
	fR4VwmGoIxkr6h1WZEfceKMler6x8ktsyP/ZPZYAjLaLCkd08UyQ==
X-Received: by 2002:a05:7301:644b:b0:2f0:4268:bc42 with SMTP id 5a478bee46e88-3039869954amr2698850eec.25.1778877403273;
        Fri, 15 May 2026 13:36:43 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30293e2ea6dsm8188616eec.4.2026.05.15.13.36.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 13:36:42 -0700 (PDT)
Message-ID: <74244fcd-5ff3-4886-a28d-fcaa49a91a6f@gmail.com>
Date: Fri, 15 May 2026 13:36:35 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/201] 7.0.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260515154658.538039039@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/26 08:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.9 release.
> There are 201 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
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
