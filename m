Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A770C45BD5E
	for <patches@lists.linux.dev>; Tue, 31 Mar 2026 22:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774994960; cv=none; b=gY8z4+WusaCOM+PbySBTzIqD4K2NLgpArhtZkYeR/foWFlhJm4AoNkwY599n1ey5beNGA36rIo7wMd0/aUXX++MCVuoR6k9Q2rB8c8YkzVHGoqlVtiHFQp5o9+HRwYQI8pfE0AnAdBfaLt5og1JWSA3wLxGkRFD7O+3EQ8We4GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774994960; c=relaxed/simple;
	bh=aCIzUS24G7f7mlW4FQqkMFZge3gDg/UjgmEjiZgCFQk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sp+fIt43U2pcBFk2Rgz5Wa3DUsoGoooy6e+pqGNrDy1gPl4W+h81nmF3lU1iSPTTzFLDmqqc6LqTL4IAsl2pc0LFrzurl0m+v4m3OJccLkQQYTFGGRC8HFDXK/x+K4MTtrcasmGjPA0+QB5ZAmid0WW5J59FtPUmU4d/f3jhBGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l55mLkBv; arc=none smtp.client-ip=74.125.82.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l55mLkBv"
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1271257ae53so6358840c88.1
        for <patches@lists.linux.dev>; Tue, 31 Mar 2026 15:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774994957; x=1775599757; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oIYjut8AQhdxjU3934zP0YIqNhOY/AQmYnZZkfDPxAc=;
        b=l55mLkBvFSa3rMQQbv8F1bHxom1MIg1/jfZsyRyazQtNT1EGVkkOWnu3THkc9H/6M3
         +oe27G/lMFnTunxJJr4MAmsJOqQg3SRNWdf6IzTqzvQgvhSyNp9BHeK1QXgc7avIkCnj
         AogI/0LRyYEqotxrmvr/K5UTBfdFSSyyJc0cZm97Q2qR3702wQZdBvywbzv8uhjzQO75
         cvWcXpagrOL5Yq/JPRcoE3vn/WXrwaIeEMZy/+agn0S9pZCe1UOjrpLp6dqCTssIiAHC
         CnGkCMim29/TxjPLdfMRXeCEUR77dQM/LmZgdIG6kvSbgHl9RM62fYOQIAGEhWrukalL
         Y/SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774994957; x=1775599757;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oIYjut8AQhdxjU3934zP0YIqNhOY/AQmYnZZkfDPxAc=;
        b=lSsvu0MFWpl/Zv+7QFz9/mdZzX5IvLdRQTlOIrTojKyXNpgjmhMfb0jX9gf1LMLEO6
         CakzR5Oer2hZECc7BCD0UbdR/D0X2GKIrDI1vz0LDksXBGSPkQBs2YCwVB2BR3O/XFcP
         6YGlZ7GVWUX2RWmfSJjTjLph/HN2SSDPnkgIdROAxNIA7Y3FQ94NwoRUYM16bp51wrJ6
         I0/uu8szNYUuPQGA6Dp9uZ3JZVrsYh6sjaBNp/Tp1jDWGhdKugtDCf0m5ZKdATe4kWtE
         cBSe+8N3EC/MJmS8dasR8U/gj/D+4Rg1o04cxAnQg8PIsoU0w8yeQrYzThLYP52z93+r
         5kMA==
X-Gm-Message-State: AOJu0YzHdgRcYavpD2KbSg/SfgHOhdl17Xk+7fumR92zXxq2dpiTtM8k
	GVm0GS/0EGi2fpcMn9/qRTJwhakPCYYo1spRZHGAeOhvENub87C2PVUx
X-Gm-Gg: ATEYQzz+V0hx1ChJJqnZyAfkcNplDlS6o8u8jmF9HNp9kmt3uI18ZZ1fd5a32rrJ/bg
	DBH/v+f5jDdpu8SR6QAbsC5TUEwmgjdhiPfqhlqZ7eIw/8kY26bZFol/S8o+ouB5pTQgoo/tlze
	Bynf9eDiVvoBF6CAqLlJ3C/ffMKqyMVKklQQpAfrQ/v/8aZQl6DUs+gMNwsglUbv4ZZ3orfWGLO
	IPwylNinoefcQBsIE/FUN9zrfgD3Bf+hG+m0WMx2aPS/NptExfGuAVPEvAEl0EVWky6Y3r1DwIJ
	gUVoF5ZEoaRjrZP+5eMwAtiouAWyYwrLXCm0ecnitYgdVpLK3NTEL4lAtusuxYPyuJUgP7KVKmh
	hIExsQdi4QjipPlmoqZ/KbFAgJACBmBxzprvkmJKaxrP/EIR1+czeT62UxP4x1h65n6UvPxOvXz
	lGY90MbsjtO/0KdrsLlkdGYmijUGNYrULPuBITrSoNxGW6WUjD0b3Op+ZMRWKh
X-Received: by 2002:a05:7022:6624:b0:12a:6c7e:bef2 with SMTP id a92af1059eb24-12be645def0mr693705c88.7.1774994956715;
        Tue, 31 Mar 2026 15:09:16 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12ab97cb08csm17996118c88.3.2026.03.31.15.09.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 15:09:16 -0700 (PDT)
Message-ID: <b5782135-b241-415f-a492-dd585c820edd@gmail.com>
Date: Tue, 31 Mar 2026 15:09:14 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/309] 6.18.21-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260331161753.468533260@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/31/26 09:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.21 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.21-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
