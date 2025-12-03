Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7A333E352
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 18:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764786600; cv=none; b=KLy1JszZj3nxnQ8RXqbmRzm0jitmeUm/NmnwVZoiTeZjNxpM3E6HrR6wJBiPyC88wnCwtQv5erqMCSdGbNU17YHOovNVULqWo1czdcDsrZL7nRwHelt6cYh1Q265jPczwh5vbuWbMFl0FjMskjH0KehcmrcKB6Vov8uBzKmSbL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764786600; c=relaxed/simple;
	bh=PluX3wdObdNX1HiZ8k39xSSiuNhuCbc+SBesJzZBB64=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YSYK2Ut+U8j1WrKvJ+UF6KTuaermqm+jElTFb0BqUuZY0PLq3SOQLebhczODAfUMmJivb5p4W4dW7lzUICwy/a28tQAR/w5feGBYYgElOEo9JDBSP8m9dgUqkufqJIfjxLv2zJxmS6oq9DO72kC4jFgOupvDuh0Kb4AGQdC9O3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f6gCAlW0; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f6gCAlW0"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8b5c81bd953so2579185a.1
        for <patches@lists.linux.dev>; Wed, 03 Dec 2025 10:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764786598; x=1765391398; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VV4t1NW023cvwTw1rbmTo/1U8JjaBfCScs6Ix0NDmA8=;
        b=f6gCAlW0Upv+4Dck28LH9uQ0xB0+8WGdf0SYUX244RFkQeUQe2JfLlMDxPW7lzB1hM
         W9kArTpmEbNk5taQTxl6XRgqWH6XCupYL/7/BkbYSzWRRvalkA3cIW7dFopo5ecxtyo8
         WeYWKxfxJQlYcGGwoX7qvqOOI2GKSMjdw/95Ta68/AHZBpW6MGllxPyd2btBZF95e5B9
         VuVyWNH2v5Y+pW+7EP5dzUCSWPA1z02gbf/eFyaQOvfABGN0bXl+a2V2tHfO/NJFJde5
         ETpxQ1dMhED7zTL9fHL3eRUWorx4ePXlvmv5LpuYXIuwv9ajTSfZ7juZfVj7zfvAoupl
         wJ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764786598; x=1765391398;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VV4t1NW023cvwTw1rbmTo/1U8JjaBfCScs6Ix0NDmA8=;
        b=CvPVdbFcETHz0EwsazLRGLy9wFcr14trRD0O8luVndkGeMk/eAPwnCHB/t9gwLGxbm
         WRexfWkclm345Ie6f88gU1QT9bVWKmMJLvygF+4vhj6xFUSyY8D5HVnUYa/4MzkZc/jM
         yqK911mU/yK8BlhKsh4P0jFZJlIoHyECgqVifynFRh0uHWl5WljlTekzIz9bM6DbAEzR
         SLkYWknrZNRYASSktvJj70t1uFuqaKjG7e/bHBqjVd0n/CfocuBxmYNVZ/DqOFodPIzJ
         JyCPAEHoWdk1+NnaM83kveKHoFpWcDrYb4uSisWFQmwpKFSfOqxBkhoQxRkpm9srytG/
         RU2A==
X-Gm-Message-State: AOJu0YyGH3Z0howb8rgqmGyAc81IujMew3I2Qqw/x/ODbhBc77Dy/rz7
	RskWQ/BnoyAwsV4EpAwYfpTn9dlo/EGR21Pm74fr99bxeDHlyJUfgbZk
X-Gm-Gg: ASbGncvrcuPbBG0vDL00LZKt8EMHD6ah2J9VlVZWiV62CU3DvPq53BLcH4lvFVR5Q6Y
	g0puPpzVRH9NBBJF/I2Cp41NhcpFSVeuQCuK12+Ep3T17AbiRymav6x7K35B3C03fcgV9pwWjDX
	3YJFJs+05KcEY3dz+aflUW7dnpPUfApm4nS/KvyWobiJeFtuVBvzk7E8DbXisV5bdZyOenWAlj2
	DjfxcASAm+pKXxOMHtVF+4y/GPLZRElqOiOyjtkBiqETSZQNIEBNmaT51mgP6OFpjVu2NFmXU74
	NQea5vMU4Z1yk2IrUTAeMxG1Q+UzVSzsQmLKogG+ZLO65Had0BXDVbjm2CkuqJqOT3dDbs9LQA4
	a6bHF7jZbMzLyGanGPx2UPm+4lO+80LrJQD8S5M2tRtqWw2yy5uL71EtrS4yy2ooIybP2OwXNOe
	l9bhHLcwQt5yIH5w2F+4/kiDIf+Bo+FNf21uLLiw==
X-Google-Smtp-Source: AGHT+IHiJ8n/50vlqbm1/NN3ThQqkkDO8VFXcQXQ9LLAOKP0PwiMkAgZqgZdrHX78YGv2Ll5CM/8mg==
X-Received: by 2002:a05:620a:190d:b0:85f:82c1:c8ed with SMTP id af79cd13be357-8b6181724d0mr10843585a.37.1764786597652;
        Wed, 03 Dec 2025 10:29:57 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b529993839sm1397870185a.8.2025.12.03.10.29.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 10:29:56 -0800 (PST)
Message-ID: <3591a9b9-35b8-4f5c-992b-84bc03297e41@gmail.com>
Date: Wed, 3 Dec 2025 10:29:53 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/93] 6.6.119-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251203152336.494201426@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/25 07:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.119 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.119-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
