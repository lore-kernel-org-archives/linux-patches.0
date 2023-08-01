Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2111F95C
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 16:48:59 +0000 (UTC)
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6bca3588edbso1507785a34.0
        for <patches@lists.linux.dev>; Tue, 01 Aug 2023 09:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690908538; x=1691513338;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y0yN6oK3W9vL3zkCb9k5pyMai7qNiWEPcK6Gyy1cYqA=;
        b=Ix/DTEX1m/gtD8uXOHuBBxW6hMOKamO9UAXE9c1LO0s4csrTFC/bweCy9bbE899qXX
         WpKI8EdLvpeeXT6xsunwg08RqeT+jxuqwbLip5JROV3XcnCFg3YSsp92f2WI9/2pb5sh
         SOSienQtHkV80z4qdnYqExUVRIteMzqbQxRR/ekxYZCeKRGzZnm3dxX864M1RFq0Ti0c
         0ht6ty6vc6eN2Ey6r8kLTXbibw2CUrGRxMYOnpaAnO1j1RCfbAIwjoB9eDzKDoESQU6D
         h7aVSOtomaPFrZ72fpd7IECb1xRxheRL5KZfcTEUR/gQTdTxR/rMholQ0ddOKfT6KJpk
         CfaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690908538; x=1691513338;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y0yN6oK3W9vL3zkCb9k5pyMai7qNiWEPcK6Gyy1cYqA=;
        b=Xl4Ahmw6V3I1acoHbB6xaRH6FKtNElzqBzT8ZX+dwo/DOvWInDWZpQE7aKmJmGzyFw
         tbvgK037r0JlKv6flsH8F1YGHWQyNMqgjAnqzpbhQRscyL3gyB0g10UwAhZ6yVonKDOR
         5qmHlBSuW6lv1tnd2n0dHju+RPDBSfI3wdFVn+1ZXvUjuu6HuLYLBooGqMKRawmeeco2
         Tat9fMTlnXO2w4wCu+vMT4B+E5wTvdSvAQKkUeEdeINXMEnUrYdkTAN+2pXAGlphtMdJ
         Wi3fwUOG1ug76TtcML90puiqK87OKI4bDyWk06ALCEa1i0JmzHMHeTyB4VUwZCmypdOg
         py2w==
X-Gm-Message-State: ABy/qLbLdGCv6RQtmKegB5CegVOQJwca57X8F797LbpGpFvHG+PMwZ2w
	8CMKby4qpBIIwiHTjIFWz60=
X-Google-Smtp-Source: APBJJlHOeh/7Q1YTGuo1v/PI5q/b2xtH3Wfwj95sIp3lC1DXJJ3qkXpBpoMlIx73ZvkebdPzr1qgAA==
X-Received: by 2002:a05:6358:5e0e:b0:139:8a11:8a00 with SMTP id q14-20020a0563585e0e00b001398a118a00mr1454370rwn.32.1690908537839;
        Tue, 01 Aug 2023 09:48:57 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a17-20020a0c8bd1000000b0063c6c7f4b92sm4768947qvc.1.2023.08.01.09.48.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 09:48:57 -0700 (PDT)
Message-ID: <11f91413-3300-bea3-7f61-3ad855ef8c59@gmail.com>
Date: Tue, 1 Aug 2023 09:48:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.1 000/228] 6.1.43-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230801091922.799813980@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/1/23 02:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.43 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Aug 2023 09:18:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.43-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

