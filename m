Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF23330646
	for <patches@lists.linux.dev>; Thu,  9 Jul 2026 13:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783605081; cv=none; b=l0rlfWaUPh+QO0I6HsFF9OpLerufN/mTwxU7DhdQ1z6XcFB/w5MRwjNzHeKMb0R6v3bFQIzgAYaCQNGiv3s50/NQjVLumuzMyTLv8Q4zBMuDvTwl0KHsGBaO8vSRJTI5RAUV3mPSUFhnMSC3T4SE57crNFAOtpazwHRk/6HWwQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783605081; c=relaxed/simple;
	bh=qpSIGxXePD5q+WNHiKXJBHgaLMuHvc3z0oUjbEqV+LY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ReXNnVWvIXSgQ2+nBYZdshiOg3buTVypXbJUUSdGyc2XmILXfgAixLX4TcUEdVWhll896fzIWuWnLZY2z6Y9FcUdjMUeddIxZzTbV0tTuaZJ/agbqWXzcJ69PLN9fsgeBhYSN1y0D3vA41MK0Vf6X5uIL3aIJhPl7TKIzkrP+1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TQCeXb04; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TQCeXb04"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4758b2a9e2aso564918f8f.2
        for <patches@lists.linux.dev>; Thu, 09 Jul 2026 06:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783605078; x=1784209878; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1i15TENNOeFnpEjkQ9JLbwEKpF9zI2nmRMO6KesUt6A=;
        b=TQCeXb04uqUbJ3MLC/CZneXOlogOGsiJfujZ6zjZv5RkM7YTidC91TmN+DAm+dteQT
         0Tyy3FpvRvpgtTIysV1EBoa1eVz25vByeMx04ZFuxRl0HK0E2emnQE73AnxgUqTauYKz
         Gk43/0iq3IagyxAHih4mXI3r5Bop98VMjo3akj0dA5p4oTIcj3++ppFaEWfUKVk7pmRP
         rj5OVfwAN6D4Br5BKczDDwk/Z7aGFNuU6vuqY09Ymkuy0p6B2rTeBSN96PR/mcTORsJw
         meFbnUsudGO5P0zeJoh7GiFfDDTHdBNSA6NAiq34Dabtj7v818doRQKaX0+4x/M4BIeO
         Nufg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783605078; x=1784209878;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1i15TENNOeFnpEjkQ9JLbwEKpF9zI2nmRMO6KesUt6A=;
        b=KZwA5muJyU9Bq5domAGzCQBQzEexwXmT8QWE6fxuGlQgg/G/41rxHUSiO57GwFOWfL
         6MtPXwqLdd8jDrxwBMH7pfVdTBpcgvPwJuY/LiEGoLKeGxzTJsedKw6t+IgvT+yi9jDA
         /7rWWZpruhKJc/9OFtm8eGj5ufbEH7mt1uuBUJgw+IlXeNtkSWXL3qariSJ69VWhYNV0
         I/SR/2A0bn5ck/RN/yQKPzQcREbkMXEM6HKM+SIQ3yN6mUiEQK7ZWOgDmMs3Je04ELqB
         0/u3e9k/k5h9ww2V6VHUhJwqtX/qW+yt5wDG2B57vKZBUGZZDLmxaGkO0pnoHBp5Xa2/
         XsDA==
X-Gm-Message-State: AOJu0YxqO/Ub8y+K0a6pdYJnPG40+tKfOzcKFwm9vTXfVmD2N8dVRKBi
	pQvw/z3uYQgEheumsencMLHU0dNRczYJfj7OQ6+8UoQPmvLxfaimDPP29K1AarbQ
X-Gm-Gg: AfdE7cks9LSS3SMw/LyotXAfpBvqI8cy4Y6XOQs/d/1yrE46AtuN2rNQ4YdkS+HZ9b5
	pzEy4hVs+1ffv+FyqCfGic5ncVHmRoMI03TYPzT5uJnmu8nZkAnlj3eeZDVwyVI05BolzUnZZL7
	U1XCBrY2PFdzYqsvy5TYaDo48ew0DSEXyg1sES16bEmRokohvYdqeNP/teRZIRbWAp5W42U4ZRo
	UqI8tLiipUrzNDsBr0DDBk6v7HKSsYhf7j2JDgc+1XTCjmaMECuVQIUh+rmVnu1RKUoETYZ1QQ0
	CAuVjR/Eryxb8S4gf0qFuZKYC9xDTLHSwZnw7BHeerktHv2WcEVzB6FOzhB1DuOdA2l7G+oNfZH
	bCJXcn+O8CXY9qXPoq7j6kcXRGwVA8J0jBlK+MmofNPyCU1fDFINIgBl7LP5hj7bUmzrk3S4w10
	rv9puqtRYY3jrr1HhU35GTPp/DDXT/TKopKDoUoyQrI++UYel0RpSpULmHtL+ZkA==
X-Received: by 2002:a05:6000:46d0:b0:47e:5c6c:5129 with SMTP id ffacd0b85a97d-47e5c6c51b1mr270729f8f.27.1783605078517;
        Thu, 09 Jul 2026 06:51:18 -0700 (PDT)
Received: from [192.168.0.105] (88-187-52-200.subs.proxad.net. [88.187.52.200])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9e4d83bdsm51644657f8f.13.2026.07.09.06.51.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2026 06:51:17 -0700 (PDT)
Message-ID: <b885d245-bf13-45e3-8c60-28417a63fd91@gmail.com>
Date: Thu, 9 Jul 2026 15:51:12 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/121] 7.1.3-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260703072822.817328079@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260703072822.817328079@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/3/2026 9:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.3 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jul 2026 07:28:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, please backport 
7ee7f48413c42b90230de4a8e40898b757bc8e82 ("perf trace beauty fcntl: Fix 
build with older kernel headers") fo the MIPS build of "perf" to pass:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

