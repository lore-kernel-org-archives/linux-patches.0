Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DF68F7A
	for <patches@lists.linux.dev>; Mon, 22 May 2023 21:13:23 +0000 (UTC)
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-3f38c23b06eso31248521cf.3
        for <patches@lists.linux.dev>; Mon, 22 May 2023 14:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684790002; x=1687382002;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pirlIKRk0YFkFPvt3TGZITFMYEgVbd3UZflYXO33MyY=;
        b=eX4x1LueFEmA7fupeRW3aT2J6as332T4g+to1tbNqe6efJilCJQ+/hSbaYDsNM8xPS
         YARrBSDq11eIK+Qal84odTy8SLnrxHErlCjmi8e5coiq85O24BwaLumCK3phr42OFpFK
         P2mi9FEkusGHgiYWAp4okeQehm73FfB2un2iQAgA2qy1eYISj1LOJsrBdU4wqQsFm6RU
         1UBTwEwWNBkAWHF/rhxzuIwqan/JrTM/KZiuJMnj8a2eNZaNay/QWIaryOTEbD52tjQ2
         S5tbvCpyovzNJL6W6k6E0O50/yhD4+DecxRR54a42zqStBzEGZjgs7Zh3oZ12sTP8gV0
         rTVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684790002; x=1687382002;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pirlIKRk0YFkFPvt3TGZITFMYEgVbd3UZflYXO33MyY=;
        b=cj4koys+4ZNPHkSDOUszYTlH/ABwHkj1XsmCiJD77bigoS+A68whbytt2/Y9Ng0/XW
         mnFpAdCVyadxDxINQX6B0Cf80Tzn8nX4rLCDcBifRlXOrCompk0l4m8r32y2iGRfvX2O
         77Hw1EpOKSL5vkBIhKg5JJ0w/240AZcW3CZ4HPQVd1X2OXeI5We/V5BTbIxackVXESVI
         FIw/3TrIO13IeEAxhysihSSJYXODjQE8QZV6KxjveZCBaM7lnRa2nCoqVxs5B5zqszHq
         VQ0yuRALB8ZSQV5oG8bvyTkodUWOo5t2KAT/L2Q8jV0HatmsieOXZzPosvkw21DxqbDQ
         ihFg==
X-Gm-Message-State: AC+VfDxFPX9VOf8A40iZIVpAOg4z81gM52LZFrY3zWC6B4sCFGVDR92x
	aS1dr7GntodN62Gzbm/9KaRgqe9mle6i0A==
X-Google-Smtp-Source: ACHHUZ6othM3EBxe/OnAH9E+ScL6NySoHr1dsxLW5fztmVa8magR6kocLfM+wXp7RxgptIxxVhrbtw==
X-Received: by 2002:ac8:4e94:0:b0:3ef:231c:cee7 with SMTP id 20-20020ac84e94000000b003ef231ccee7mr20339879qtp.7.1684790002192;
        Mon, 22 May 2023 14:13:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d17-20020ac847d1000000b003f38ae9e5cesm2359829qtr.33.2023.05.22.14.13.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 May 2023 14:13:08 -0700 (PDT)
Message-ID: <c35411bf-4fbf-a39f-19a6-7a8949626f6d@gmail.com>
Date: Mon, 22 May 2023 14:13:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 6.1 000/292] 6.1.30-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230522190405.880733338@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/22/23 12:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.30 release.
> There are 292 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 May 2023 19:03:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.30-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>

We would also need this patch from upstream to be backported into the 
stable-6.1.y queue to avoid:

[    0.001228] Early cacheinfo failed, ret = -22

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3522340199cc060b70f0094e3039bdb43c3f6ee1

Thanks!
-- 
Florian

