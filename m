Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EE0197A76
	for <patches@lists.linux.dev>; Tue, 12 Aug 2025 21:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755034736; cv=none; b=g3PTadjfFq267CzwoXiO3jbq42cIHDdSEXohpVz0ots8PuecaMCZ8Sjflerrbd8qhCn0E7OKoR21bK/i7bpaQfxkjx9u50O+++kRHURVMK9bJ2rf8hIH7ZzFuNs9dUJQn3V3Ks+LBVHI0T6s/rg1lfZcwIplcg911XavdHCVpps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755034736; c=relaxed/simple;
	bh=axiH4a3QJQrYWUfX19Djcue+yx0b1xai/MtOzqIXfxs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fkmm0N3ntsv89LygV3bS1EL135IwX2dNE5aRJuJDpJAYwo5EmrElFn0b/B7sX6EWXM1d+kO3JIvHNArjrlQZp9RmjeDJrUPPfBswr+k/4sCL/K5yy1HxMaT4zIeY8MwsDWGCywyPrlihQ5shlmxcK+zYjxP8qIwxG768TwPpOQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K2vtrssX; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K2vtrssX"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2ea6dd628a7so5143612fac.1
        for <patches@lists.linux.dev>; Tue, 12 Aug 2025 14:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755034734; x=1755639534; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QJal0HDcOW5BIJClCSpK9SqQz87Zh1sXeHnZhQzPs10=;
        b=K2vtrssXlZE2bl+jhh1THiJtLebhOtXWHdrnSJqGSHxfeyYzszeVADFqYbYrv0G0hK
         6HtdwQszGs9KLhGIXAcAYCGlnPrteGyukqh0XWgBtgonZJlnBt5erNNvYKaX5YX0EhVo
         AebGg5QjbHskiomUZqILlcXko59kRwNZPCKKu9ASC692+mcgUv47ypo8JO9aeu6mSRYr
         HonbwrJX10JZcQGyfYoMsEVi54NOWVOGV+EYaLJuKY2sGOjp6o6dJGXyb3a67k7U9Bye
         oYrFuNDt6AvO5LBG+OYOOt7+pMMVfGcCZOQ0GZbFBojIrYmm8xWbA394UZXKPPZ/1sii
         5fXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755034734; x=1755639534;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QJal0HDcOW5BIJClCSpK9SqQz87Zh1sXeHnZhQzPs10=;
        b=jlG8UQfu+eAOqlCYw6jj+HzmmUF0KouvpnNhcLbpVo2TRsZ+SI3Cor+dYtltld7RpC
         U/0qSovvwVqaT5Us1RRqi0nPl3pVcJvHjmkE1TpNlFmH++IekStxtxz0ASgFVZcblTb7
         V5yXx6kE6LeWKHZxd/8mujM/ceT2KdqfNk8Kt770srbt/rdGiHBmNMkeOJAc06Ni8nwJ
         DV+Qnn+iOkGasito1178ScOD1hPCy3Mkn3b0NkXYNHtpXPfocvGpR1rrID24rhOTW/oz
         lX+snnaQ+n5MD1ae962F2zShSxMTAsZIKBSCwQA4vCQPqyOIOr3tOqXYjriS8E1TGxjm
         9YRQ==
X-Gm-Message-State: AOJu0YxHJsEo41geYu14keTf2UUr06VdgdE1JhSbMN/1Hyy/sglVSc4v
	tWXMEPSgkoA0qn0xZGIOprlS8M/Us9v6o2zozk2TEE782HtrTrL84n0u
X-Gm-Gg: ASbGncsBTkEA2hv3pSa7bCfv2uyEMYAa/N2EJkwyNPsYqq4adwoR+RXJmddFW94G7SX
	qBPliaOt81kTC55yN31IkwJ+vs3XMwbQaCcMzP+KG5zdCp5e3B/+c1YWR7a7wEJYkzOOcX64Oyp
	JmvKZkqTcILh+H8zpquv7HTeJrxnAwVfpJFe+b6LB2tKSLMezp4G2jLHtKS5dg32wjZOOzSH3gA
	QYIuzVnkcBdvFyIWSCQItKql5TaPB+S/Gm1lp3cD1NqDk4YuHA28OpgKQ68BbVTp6nAGELkb1Rq
	SVvbOr7D1dFEKHEm9P378YfoFYSKtjpU7B1h5aqa486cMZH8OZfYDO9RaVq5fopbGT9p3vFlrOJ
	r7efPqHsF9VdUsMIN9jTfnlaO1l4vjt55uuMTwkCpTNwhTeJLnPUvROw=
X-Google-Smtp-Source: AGHT+IFl2Y79ozRu1ULZq6ZoNCGOMk+NLdBFPuMjL831oBJp6MM/dM0bPqYtOM4m4GbvYYJh+hxX/w==
X-Received: by 2002:a05:6870:a408:b0:2c7:6ad3:fe56 with SMTP id 586e51a60fabf-30cb5ae8711mr504002fac.15.1755034734291;
        Tue, 12 Aug 2025 14:38:54 -0700 (PDT)
Received: from [10.236.102.133] ([108.147.189.97])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7436f87a22fsm465486a34.16.2025.08.12.14.38.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Aug 2025 14:38:53 -0700 (PDT)
Message-ID: <c33f7e60-9754-4cc2-82e0-e056313365f0@gmail.com>
Date: Tue, 12 Aug 2025 14:38:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/369] 6.12.42-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250812173014.736537091@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/12/2025 10:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.42 release.
> There are 369 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Aug 2025 17:27:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.42-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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

