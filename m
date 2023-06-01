Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269F633DF
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 20:53:22 +0000 (UTC)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-19f36a8ac3bso52129fac.1
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 13:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1685652802; x=1688244802;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z3zbtC4fs6iwn19rbtHLRSSwCQsJZ082r3e5xMiH0W0=;
        b=NJ6m/XlhCb9Yu0+HY8UN9zEPxU30xNbkUAeoHhbVV+OkefcSl2Sz/76yHSxSzxKJFp
         5rPnX6SOtYr8AGpQRQG4NNROdscP7f+PB4/d4ldPBw2ZSTZFS5grsQ2h6foH4Q3BFHFq
         9tyft3RA7PTnVWTiWHxcmqlNRh+0o5bFrUOMQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685652802; x=1688244802;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z3zbtC4fs6iwn19rbtHLRSSwCQsJZ082r3e5xMiH0W0=;
        b=e9LrBmPyt+XZRHxLvrO6ngQ6qdie/gGU4qVeYX7sQR0KAZz4gFXB50gxpxzpB+1cEY
         +yAdeQ6OiYX3ovo4+KvIFALIZOhuxUPhO+oBb2o78Lv/y7ODSo16nELjZkIWV7bHYrLL
         78WRazQjhX1D0092UrQOgSjddk4pqWJVBuA+gReNdWlY88wWM0iCBLlSBcPSU+SeE+fN
         LYMqlQgQsBidHgfu4Den2n5ohD/hpj69bGCHHbKh3NP/pTR5zKIHDhCxMofUsKOfijE4
         BrqSZT6hOjhyKLZoWcTdd5TyAEmnfImTPgNW5ABejuEzXACG0GtXAKBgeh6EbzB8g6Wr
         Eutw==
X-Gm-Message-State: AC+VfDzdOxTXScHNlqaSMoQ/3UI8sc9tptXYFWz6pc2AUGOVVqoJaIum
	9O5hiv1T3YmVeab9+38w0q4y1A==
X-Google-Smtp-Source: ACHHUZ5gH3b+6neBYh8JVjcuSrxQf5c6CZ4Imyc9YCixdM9S1n5N9pXAbgZ0yzfjoO3ldRO3FU/yiA==
X-Received: by 2002:a05:6870:f617:b0:192:5e53:2e64 with SMTP id ek23-20020a056870f61700b001925e532e64mr4694450oab.1.1685652802060;
        Thu, 01 Jun 2023 13:53:22 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id cv4-20020a056638498400b0041659b1e2afsm2575525jab.14.2023.06.01.13.53.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 13:53:21 -0700 (PDT)
Message-ID: <1d9589ea-ade8-e93a-e9c8-9937fd1597e9@linuxfoundation.org>
Date: Thu, 1 Jun 2023 14:53:20 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.4 00/16] 5.4.245-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230601131931.947241286@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230601131931.947241286@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/1/23 07:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.245 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Jun 2023 13:19:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.245-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
