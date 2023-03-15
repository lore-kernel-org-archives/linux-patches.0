Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90690538D
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 14:23:29 +0000 (UTC)
Received: by mail-il1-f169.google.com with SMTP id s7so2823069ilv.12
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 07:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678890208;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=rhGIf71XNMbSQYsIlu2QGVy+/bw7XEJxRW6NuKNyMUc=;
        b=nbmpyZujintm7OAS/LjGOGkGUoDbJxnBCWZho0e5oML/15cTKCZ83FF7NiydxTwYPm
         /i+vHoamCgmfbUapspT+sVSc7x2fvxqzB+xg+laNMiNpffmp7oD9zdkZcQ1elRpx/mDE
         rFZI7nuHslxql9S5XKZIeBrVTRszeEo/U5WRyrxM0vRM/1Nmcq0LMVyM92pka9WCaNPS
         uBw86bIs2nFY3rvL+5hR3KuG/J3ufXHCq/PUGAk9dxyzWcMphWsUKEpc/5zdOfce/IYP
         KiCy8irMvr1S/qR4KUkLoxEG5i5wNfd4xxFLI8s9EOlRElE3og8MMR3fZ27Q0P/RsO9a
         Zogg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678890208;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rhGIf71XNMbSQYsIlu2QGVy+/bw7XEJxRW6NuKNyMUc=;
        b=mYnV65my7ZivIKga/HWpV0AgCZVEjWrOv9Imm4nXhvNWIk+T0YLZEOStGlP6pF6QLk
         kH6dHSdaheJUGz0ZXP2nEi35f4Qb4Fo0SCwt/GMqtxozRfMq+uI3x4GpcRY2/XuPRQCn
         kV/PtLT2wBwlF4qTfCGhD23ILUpEcOjU78/C2ovtlp0U9h6YMXNQvErZ+onZaRkpz56R
         JSEQQZSd09e3qjCxbfFEG/1w+xsCR5cIwDOrr/FbEUbtwNKu932kLzv4gRp3LN89+2Ld
         myMZSUNFr7AnpOmr9MNvU7hyyPtImN97KVUG4MOas/vhmzwy/YNX+mpPv4B8Xz3vA4+c
         0/dQ==
X-Gm-Message-State: AO0yUKVv+pfCDTLqfWdE2zjilAOOUcemH/3mRWZ8SwFTWilMDMcG4Cp0
	4fIBM7aPi7wvszao1RopEVA=
X-Google-Smtp-Source: AK7set8iGk/H0LMTn6r/zDTe89x8jUR+c67UFN52D3vq7WBa5IZUV4nCdaRqTLURFOcAK9Zu5hyq4w==
X-Received: by 2002:a92:7f01:0:b0:314:1b08:c19f with SMTP id a1-20020a927f01000000b003141b08c19fmr4493772ild.1.1678890208544;
        Wed, 15 Mar 2023 07:23:28 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k2-20020a056e02134200b0030ef8f16056sm1634436ilr.72.2023.03.15.07.23.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 07:23:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <233afd55-6198-15e5-f6aa-b462ef399cff@roeck-us.net>
Date: Wed, 15 Mar 2023 07:23:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 000/104] 5.10.175-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de
References: <20230315115731.942692602@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/23 05:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.175 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 

Building arc:tb10x_defconfig ... failed
Building arcv2:allnoconfig ... failed
Building c6x:dsk6455_defconfig ... failed
Building h8300:allnoconfig ... failed
Building hexagon:allnoconfig ... failed
Building i386:allnoconfig ... failed
Building i386:tinyconfig ... failed

... and many more.

--------------
Error log:
In file included from kernel/sched/core.c:13:
kernel/sched/sched.h: In function 'cpu_in_capacity_inversion':
kernel/sched/sched.h:2560:27: error: 'struct rq' has no member named 'cpu_capacity_inverted'
  2560 |         return cpu_rq(cpu)->cpu_capacity_inverted;
       |                           ^~
In file included from kernel/sched/loadavg.c:9:
kernel/sched/sched.h: In function 'cpu_in_capacity_inversion':
kernel/sched/sched.h:2560:27: error: 'struct rq' has no member named 'cpu_capacity_inverted'
  2560 |         return cpu_rq(cpu)->cpu_capacity_inverted;

Guenter

