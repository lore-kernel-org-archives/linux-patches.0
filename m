Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8C628F3
	for <patches@lists.linux.dev>; Thu,  8 Jun 2023 15:08:54 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-52c30fa5271so273578a12.0
        for <patches@lists.linux.dev>; Thu, 08 Jun 2023 08:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686236934; x=1688828934;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=IEn5e3O37UYFQUronoHDerBOhdacjq599KRhqwKq5KA=;
        b=Lz6uq5mRmJS7cgpQbs0Uohbo4RJFczfdSYfnTgkEmgO6cGhjQ6iQubwHsBpEFoTxse
         IeW9a4vfmoshpcO7p5NVtKJw6qpbZ+a2lh6rEpI6KgO02NBcTTjo3lg9HbKenMfR+c4y
         nB+7NLl4oVrrOC+v2bIrs06CdaA4/6ZwzSaX5nfFtOgp3lRaQWQQg6RHMypY+hZz6bXq
         vCRdm09yKaQ0ny5rMpvIM74o1OPrh2Iqtc8MMBgfZX027VgJcLVN54ta8ePWb6vInPW3
         eZGlsbYTHqDIhwhAwg4jJb3wEexNH5zu1RKOVtVPSvTTnKypWIS3t8krdIrZUFa9SQw/
         XxLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686236934; x=1688828934;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IEn5e3O37UYFQUronoHDerBOhdacjq599KRhqwKq5KA=;
        b=X1ha3APTuVys7jz2gCtkZN3M0kwQvAOz3lru77df8zdTJuENborkd0qtexPprx4msl
         xiwFrQVGRyPUFb16H11RK2ycXFf84buW9j27h+PEypS2pLR7HpWdpHRx+dlMvdzt5mYX
         vbHSu3381d3+dpVrss+fmQgGD9S4YxLT1fOiiQk8z9nWuCOHlW2J8I4hOTpc3V0+fqqo
         /4JLVv3BadluMKOQ8mhASiXW1GcPUOMIzUgcy7vuVSelG066+LWNu9y7c7D4lY4M+dW/
         8tYU4+WIUSw0Rb72CiPrrNC1KH+KnT93tERJ4Zyqo2H2C4DAue9fFY8tkBS4lYVJIkcs
         5CBw==
X-Gm-Message-State: AC+VfDzOAXdXqFapVWsLxkozOA28HSicddCP3xJIxW9QmE7YqxIGIX9F
	QTvMajKa4+trsGtWm+mFaW8=
X-Google-Smtp-Source: ACHHUZ7Uf5pFMO3YlEHqNSgVn+xEpUoTbXA+3SYvl36Bv0VcxB3XJPQilOfYZZgYbGfCYWrgcpvbbA==
X-Received: by 2002:a17:90b:2347:b0:256:4196:f722 with SMTP id ms7-20020a17090b234700b002564196f722mr4647476pjb.47.1686236933842;
        Thu, 08 Jun 2023 08:08:53 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ij14-20020a17090af80e00b002502161b063sm3190146pjb.54.2023.06.08.08.08.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jun 2023 08:08:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <cf6f959e-2885-1e7b-826d-61bff351ff14@roeck-us.net>
Date: Thu, 8 Jun 2023 08:08:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.1 000/225] 6.1.33-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de
References: <20230607200913.334991024@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/7/23 13:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.33 release.
> There are 225 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> Anything received after that time might be too late.
> 

Failed builds:
	loongarch:defconfig
	loongarch:allnoconfig
	loongarch:tinyconfig
	loongarch:allmodconfig

arch/loongarch/kernel/traps.c: In function 'trap_init':
arch/loongarch/kernel/traps.c:815:21: error: 'EXCCODE_BCE' undeclared

EXCCODE_BCE is indeed undeclared in v6.1.y.

Commit 'LoongArch: Relay BCE exceptions to userland as SIGSEGV with si_code=SEGV_BNDERR'
is not marked Fixes: or stable: and should arguably not have been backported.

The same problem affects 6.3.

Guenter

