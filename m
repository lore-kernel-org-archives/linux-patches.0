Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAA637B
	for <patches@lists.linux.dev>; Wed,  8 Feb 2023 01:52:13 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id g13so12862944ple.10
        for <patches@lists.linux.dev>; Tue, 07 Feb 2023 17:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aPilZBrvyzgqjsmqEP8Qm1Zad9diYGZYlfH9HP2RVME=;
        b=MQKhOHJts6z//UPEl+WhIfzfwHlZU1MQJynwBlxINA6DXfbAYZsUyjQyKjMrhJsudh
         P82X4M9ssJAOFwHETUUn8pyMebXnTTRrR3bG1qV60hNilJaHNdcPq4MSiURbedW3jEz/
         eVhqmQYFwC+gOf8lMs5HtsGqpF4VOIJG6ScjHfwd2gzAT/9PS7mHHCd/sFIsKe+mQe1W
         J4kQ5c6LAI4wwCEDr9p6pX7ZbIQ/HbyCD1LKOTHy/spJKT0QQwANX47Wbd9mbuHpzNkq
         /o7yxEY1yTO1v1O/RbY9T0Ly3vM2Oi631BVaLK6aRJkPdkmkHc894AHlx0b9iqtlQO2E
         VBQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aPilZBrvyzgqjsmqEP8Qm1Zad9diYGZYlfH9HP2RVME=;
        b=FVf9YeCeoWmwSa5ZrZbB/hpBrCY4geTrmIekgS1RbOrAVlujq1Lpsz31OAdE8a/BuH
         Z2xULSkbONQa+v01qWDaMN6rC5fJLuY33uUkr6huVZHZUJv3u+0MyVEfPrHY9+I3eouh
         W+VcgFL+mPodeXY19kbzxfn57p+WK/lA7ieQobjEyYlbI5otVysqMWDoAUiZAVGe5zZx
         Q5YrlRQtAar688dNoa/K82tpiL2dwpdO9TmQBk5jAqi1z1GaKT7Qgak1SgJqmEG6SZvd
         HpRhgbr5Mr2prYsXUV/46TV97fJHfxJOvjuLmnK39TkMCg91LhEqRcoSWHyW2cDfjQsq
         EM/A==
X-Gm-Message-State: AO0yUKXHzcfR8PfeLx3oSdjkIlfnhuMWvuLUmnXhE7YUq5QG+B3FCx1C
	g5UK/i6zepbEV0paq3aCkAM=
X-Google-Smtp-Source: AK7set+9+THITSv0u/2MrM0c5aqwptCz230WHuS/r54mf5+W8GrlqVJOGl/cdgs1q5bio5YyJqu08g==
X-Received: by 2002:a17:902:f392:b0:199:48fc:3dcb with SMTP id f18-20020a170902f39200b0019948fc3dcbmr183954ple.68.1675821133051;
        Tue, 07 Feb 2023 17:52:13 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u1-20020a170903124100b00172b87d9770sm9641676plh.81.2023.02.07.17.52.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 17:52:12 -0800 (PST)
Message-ID: <a8b73e1a-8909-b316-48f9-b83fff322fc7@gmail.com>
Date: Tue, 7 Feb 2023 17:52:10 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 000/208] 6.1.11-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230207125634.292109991@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/7/2023 4:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.11 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.11-rc1.gz
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
-- 
Florian
