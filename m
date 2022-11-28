Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9A217E
	for <patches@lists.linux.dev>; Mon, 28 Nov 2022 22:37:37 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id x13-20020a17090a46cd00b00218f611b6e9so11563539pjg.1
        for <patches@lists.linux.dev>; Mon, 28 Nov 2022 14:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OyvJmG+hXWLOKHOTgZkR3mwK6h+cOOTU1MyibLq0rL8=;
        b=d1O68c2jREVtAGf4fuehr56UzAoZaqFYlQscerX97Zbtc7zzgV1cGYNJlJxyH0KUUR
         hNXpQWXwdqFZhGX9UhUBg/zDV7wkR92eAeM78G++8vjpZvZnbqHyB7bWie5xWj4/Hoqe
         ZZpa4U3OshBZ0PkYzMAdg8nDedS4H3BhKh18tp31Qiq595CnrDmUj7Yej0ALrymDACSs
         5ZqwfAxBNRz7I12LZ65C2KSWulKoLJBZRwO4SdIugZI0+pZZhaSSG6QrPgOsBPVxPyEy
         Vs+Rz5JtNHDZLWz2ksiedKWvbGU4vs9CO40PuYUTIuJlB9E5xkXM296O2JIFxN4ltxH6
         OFQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OyvJmG+hXWLOKHOTgZkR3mwK6h+cOOTU1MyibLq0rL8=;
        b=LCnCdv9WunbtqOsM6l6XKtYJ/6O4fjzNaiCOqFKyyRbiQf3/zg3o7mwbCdsGm1FzE2
         jwpb259AQeGU6DczjleaVsX9nDUyx9D9USriGHUyZLk7spKKMvMJLvYXcmhjDLnILtB+
         O110ouK7aR/9//5vnWv5dDQbi4TwYo6ceo9eDMpYIETKKn9XIlBQfWfU3d6Ewft/Gowo
         h9McDuYRAdwKMVpuS71Q7jIcH1pjfCM1QXbmz8Od4qMGlrx0CKrPrKR/oTUr0pdfOsR0
         jETu7MCCLHib21n5HziXenijXYs4+7n/HaVzyGFwHsBW+EPietXdKw4RC7sXUk4whrcT
         GCLQ==
X-Gm-Message-State: ANoB5pmAfqSsgom5UtxbcFihmhgdgQwj5NziCDN+sr9++VbAExDcIc8P
	70xO7W7cQqVjMAOlVYoYZ3w=
X-Google-Smtp-Source: AA0mqf7kc/v3b9KLCQ9a4qlUbo6+LOHUKgDLH3uwq/67IqdRSiE4NoAz0Lgb6k5EQJ30ADg2sjwldA==
X-Received: by 2002:a17:90a:7d0d:b0:1fa:b51d:8d83 with SMTP id g13-20020a17090a7d0d00b001fab51d8d83mr35354570pjl.169.1669675057266;
        Mon, 28 Nov 2022 14:37:37 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id pc16-20020a17090b3b9000b00212cf2fe8c3sm73446pjb.1.2022.11.28.14.37.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 14:37:36 -0800 (PST)
Message-ID: <d87ecefc-0b71-fca6-2a0a-64f170d3d4d1@gmail.com>
Date: Mon, 28 Nov 2022 14:37:31 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/149] 5.10.156-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221123084557.945845710@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/23/22 00:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.156 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.156-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

