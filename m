Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E100418A959
	for <patches@lists.linux.dev>; Mon, 19 Aug 2024 17:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724087041; cv=none; b=PLPfy0Jg8+oAQE3KQqd7QTyosnkeZOv2Zhyh9fZMZ/OGCQXZPszE7rJ0j4cy097myDMCcZw4jG5KB21I8i8lWklS/2Vb412tT9YE888r6hVgyOjHbX5HUHT5vRdcMDeurwey5b88TszWggRi1Cp/DLuhk/H+VIdlw6+ytCBigaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724087041; c=relaxed/simple;
	bh=JgmieXg4Iblau/5Q/kxt2DnEgSgVYdSGYAbJ5VjaqKY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IjlqhnyeFPTYY5T+16Y1VMZdflu2EH+pRJZOjrORU3BOs6/B4/THIYgJ90zhFdSzcW2ynGlF4Aqj52duPFEIDx1cuyL2jtTx2U55YVbB/65oW+T5d3u6UVrdj7xZ23zwIWzv4GwLF/Nxnfqk4yPMKu21aUzDoh4OlyvcfL3JWXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UlPU64+Q; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UlPU64+Q"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7a1d6f4714bso451938685a.1
        for <patches@lists.linux.dev>; Mon, 19 Aug 2024 10:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724087039; x=1724691839; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a3BIaVWnwxuWR27UJ/fveub/Cw3H6dA+grq2xxd+b3c=;
        b=UlPU64+Qh0BI3KB2ePhAwilUpSDGvnBOM+dzrOAFCHH9MFzXUQTgRgrOgFpMXkswqd
         YBF/cYLVePgTQFNFpwiWDrq2VwcfQLt2TceQNhoBYMYjQ39b+UE9tdAi1dVyq/dW/Wqd
         4s9zOdezdpGEqq6awLPuoHEUM2245y29ntHAWrJndoprl6ZKQcHLgbg8b9e5mrIW2y40
         ZNCD51WQVCUhPA8G9lr51KvRQxq6+/fwJzXmjm6Qgvr3Ih9s4VAWQW3cd4mLPwU9ZX4V
         3IhbNx8hUOX0pboh0qs+SWA7btVdWbAgYVvwFM4kF13hNaJf9E+wJfppj7CEes8EOdhG
         fyIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724087039; x=1724691839;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a3BIaVWnwxuWR27UJ/fveub/Cw3H6dA+grq2xxd+b3c=;
        b=d1uwXOYPQvCwo3i5n9ppiFrRMz7H3ObmR+0jRqawfxc6c3IZ2hejCwN7i/wrNL9URz
         lK9AUaL9c4K64ezrdS1NTgF5SfejPFKs34VFIeRhF5kdI+4GvecnpRGYlY9ITa/tp/dY
         7Iz8PKdCJPYJPvUrCcUfmDLz3CxRlzdk9vX7DthfZYkxsfwk1ccOjZspSNN63un1Zqtf
         Qi8d5SkjG8ybDd4H23E1w1K8GaycXiYc4L9Y88qr3BsEdBPAdkks30TgISTMIsqTldRZ
         JZGtwHiieDkyj/1XFdYyhYoKDvHaDGGL7bjrBRcVwtVruf0OvBoX2SzxHaSKzgEf5Y8A
         ybxA==
X-Gm-Message-State: AOJu0YySFz8YWYoVBnbdzuDfacmcYBmVsR9bYhE6Y1GRg9hXwKafx6JO
	icZZtXQZ5lKzAXlr3+TykqKUss68tOH3+ZFDYxJZ8M5jHydq+W+XMT/zFg==
X-Google-Smtp-Source: AGHT+IFbUhEcPgxK/XfmNoG6Hn+cKrtm8a4uxXkzp4ZBuOe/ugGXCGOPKI+bgtCqYGHfkyGl+yVDfQ==
X-Received: by 2002:a05:620a:24cb:b0:7a2:1bc:be05 with SMTP id af79cd13be357-7a667c53723mr46511485a.31.1724087038449;
        Mon, 19 Aug 2024 10:03:58 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7a4ff0faec2sm444637185a.105.2024.08.19.10.03.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2024 10:03:55 -0700 (PDT)
Message-ID: <96ad9bc6-1cac-4ebf-8385-661c0d4f1b99@gmail.com>
Date: Mon, 19 Aug 2024 10:03:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: 5.10.225-rc1 [Was: Re: [PATCH 5.10 000/345] 5.10.224-rc3 review]
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240817074737.217182940@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240817074737.217182940@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/24 00:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.224 release.
> There are 345 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 19 Aug 2024 07:46:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.224-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build on ARM/ARM64/MIPS with:

/local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-in.o: 
in function `bitmap_zero':
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/../include/linux/bitmap.h:40: 
undefined reference to `ALIGN'
/local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-in.o: 
in function `bitmap_alloc':
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/../include/linux/bitmap.h:126: 
undefined reference to `ALIGN'
/local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/../include/linux/bitmap.h:126: 
undefined reference to `ALIGN'
/local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/../include/linux/bitmap.h:126: 
undefined reference to `ALIGN'
/local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/../include/linux/bitmap.h:126: 
undefined reference to `ALIGN'
/local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-in.o:/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/../include/linux/bitmap.h:40: 
more undefined references to `ALIGN' follow
collect2: error: ld returned 1 exit status

this is coming from "bitmap: introduce generic optimized bitmap_size()".
-- 
Florian

