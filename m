Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F2E48A2B0
	for <patches@lists.linux.dev>; Tue,  5 May 2026 15:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777996271; cv=none; b=lGPwXQg6QqBRVZVxzkrHE2eerkxMizG353BBhqDNcrrUm7BCorMO+JcJgDUim0JohtARR5fwOmn2LPK71rpmUb3ctw8kqrurqrpjegfyOwfh1t3erzhN3KYFPmx/L/EJtiR2Yc+RebUB7eo1Dls5VoA78bpac62e7vV0kPveknI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777996271; c=relaxed/simple;
	bh=w146Uut7UMGYvpnLmP1yuMot4XAU7Vs4pCdLB4GWUuU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PH8/lAqB1XU2kI8I1aTTtMuWAZF+tndSGEwJsfLyWLFEtOC/GZh8C9L2Q6ftVw8bGLbMDen4EIWJ3J8mU6/BX7fBI6WIyLRBGNKFA1yGigJfIqmokZQf4rNX8qHEKwB+Z5TziwsFiU5idPQ8Sls7kBA3RJBatqlcQkDwVh5qJ08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C0zTUKjG; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0zTUKjG"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-408778a8ec4so3121091fac.0
        for <patches@lists.linux.dev>; Tue, 05 May 2026 08:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1777996268; x=1778601068; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I4RUK3AbsfMjANJLz4VS1j9XhA69zN4V5nVay6vTV/A=;
        b=C0zTUKjGsQFZiSbOz2P3arzLxuVhREirkijY51mdhiXmnP16TojE1ymW1buYPuoBNy
         Vf4hVGaX3q7Ru9+r4c0ji2BwMQm8zOOruTrd0xMrBB/d5M2IRJpCJx8CZOuElDiu0d7V
         Avps1zQCdwepM5ZTJfYY1fdYeEYPjCUUP0ufo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777996268; x=1778601068;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I4RUK3AbsfMjANJLz4VS1j9XhA69zN4V5nVay6vTV/A=;
        b=K/29uP3zUPSTmUpVJlb/rV+BuBdL7ercrxtDZQOV+q4oGIEtnJX/Ku1dZPQ9HNtLWU
         m8j2gVS14LJLM8l1AyYA+kEFhwmZzIIimA/5V3+vUMBuKW2PvWcSdjd4hnCPRHTKkPp1
         z7XfKqpl6B8v7eRAtF1mlBTZYk6NKFQvSOrpDG7i65NUpLQFR1GJtvf8N/pWVititlR4
         cwHh1fvg+ZgHnNYAMew9AJGWIZ/Rnon9ZIaBye2mg/GvBEWZgctYbqJedLTAHV9tdLWA
         B7h5AkuXQoRogSARGuIxSW2pnxT3aPY5jf7L/JNwI7ZLALZXAQOQtRhWAy9RnzF637gm
         BqQw==
X-Gm-Message-State: AOJu0YzaD9e+CuZyRIueL4V73MW97R3WhFOtA83rpvXnZ+9/12mw36vb
	48Fej02ftLvERHGeQxAee6rCKEGjlFnA3GErp9O69k5xI0eZ46WYE8IcqxAtQ+zpgww=
X-Gm-Gg: AeBDies7MdmQO0nTvRCHDvZn2ON1I+ILoWvDyK1s2w1LdacWsMrDIW7AMwosX9O5g2s
	keNKLsL5CqkGfAMudbXNJMFMJgZaSn4e3G95RZT4t+A/1WYerryjtpb/Ck4Q6VDL6GuTZlkHKoY
	nnVCkqddvavp3sQRexvdXX6dHeeWor1AxT+4ybDqPlaRM6PfY74v3fQhEHEnJZ6+UXjk4wrnNxM
	LVnPnXGiLAYh+4ukpAshiCKntavoqwzOkdoJ7+xe6oEjyIZ8nonxBYkzQzJImpAMdyDslj+9A2L
	vnpsELdJ1fuMzVPX4IR/xKWf0WGRj6NK9S+onZW4Ou3PC/J1sysT97ntT7DdClweRJ3aXA79c0V
	zwOEeAfaXvTbBEXHL8h/6mmGz1y8G4QXXMlrFR+2YbucK/XOKsViYOY+5OpT71KRnC0TqNEYmI6
	HwlulAghweLwShuNslCfHwVqF0VvokGFyDWnA1vvLz1mRK9hEGfNzT
X-Received: by 2002:a05:6870:780e:b0:42c:d6c:726d with SMTP id 586e51a60fabf-43475fc151amr7869745fac.8.1777996267731;
        Tue, 05 May 2026 08:51:07 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4347294b5afsm11563315fac.8.2026.05.05.08.51.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 08:51:07 -0700 (PDT)
Message-ID: <484804c2-9a07-4ebe-beae-341829c11ea4@linuxfoundation.org>
Date: Tue, 5 May 2026 09:51:05 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/307] 7.0.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/26 07:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.4 release.
> There are 307 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 May 2026 13:50:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
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
