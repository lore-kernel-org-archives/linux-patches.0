Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5EDD2F2
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 22:25:20 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id ml21so10139736pjb.4
        for <patches@lists.linux.dev>; Tue, 04 Apr 2023 15:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680647120; x=1683239120;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HwDt+QHR3G6KkEjiSwaa5nmxSev2Xa6CmRhkLHnTpLs=;
        b=cEUbepfW0H/pwW8jjtKj0uOANsdtOCbKdHoh3qXms/eb44MXSAEJ3VNP3Z8Tl1WBRQ
         L7IciPTH2PGoxPGwtqWjCw74aqycAE9lB0+YcAUSRS16soiUbmIH01KWxfMw4+iASZVm
         7Htl7veMh3AmciUGnBXXQBNvt/5BbJImuI9G9hrS20nmGmQWu9kw0k0iU5vqi5vuYvUM
         hdkXwbFHWK5q+IlWZnmym07KiNbNELqCHFfKFXI+LUFAFGETHHIvIB9C0OFEF2Josbal
         ycGDl6ri5RJou0SF2+Wdkwj6qJfyvLUPIi+sFtB/EdobkxZKJEFKjcO7mvdDuv85PwaL
         Lg1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680647120; x=1683239120;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HwDt+QHR3G6KkEjiSwaa5nmxSev2Xa6CmRhkLHnTpLs=;
        b=6TKYqSMDunSlcJN8hOzOkOAQQeZJoyaICjMf45TpmzKTGoh6kjZwgGTXCjUJRATbuL
         jx6dLDWpJD5xhxztGPM2vt8ionmAFg4xH+Fm4u5WTMmMaXG+otPhrLj7bXGYRxnoAX/7
         dbPfD/G9ESMA/iMnDkK7FnVSK33n9k5cF00xrn18hSt0QthSmyxqAjvbsxbxJ//qgeD6
         pPUUj9GHyflZL2kIHb6e6RyiLmCojmHwU7EuuH/8xjpULvIcVSjbdwCiw01aN2LZcBiK
         cUIw9HrwINSi+4QSi5l/qIaL1gIggGJVDMUmn7u4lBOO5Zmd6wSziKUaXuiPTnTiRwYa
         sdeQ==
X-Gm-Message-State: AAQBX9e/6oAIMQIZu4ymU91nK3HQfaknC+ZSOwY2wXTGgPwWd+TbsldB
	qIxEMAmtucc8jjy2o+/Dr94=
X-Google-Smtp-Source: AKy350b4Q6M9UaQYFaFPe0p1j62qT4Q9VlD4DOjzroEbTCPnQ5rxj5BldOKhCSwlQMc7lMyPV/OjpQ==
X-Received: by 2002:a17:902:e5cf:b0:19e:6eb0:a746 with SMTP id u15-20020a170902e5cf00b0019e6eb0a746mr5254799plf.26.1680647120356;
        Tue, 04 Apr 2023 15:25:20 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id jl12-20020a170903134c00b0019edb3ae415sm8838604plb.14.2023.04.04.15.25.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 15:25:19 -0700 (PDT)
Message-ID: <0106c049-9ee4-5367-11fa-79aadc5a3654@gmail.com>
Date: Tue, 4 Apr 2023 15:25:16 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 6.1 000/179] 6.1.23-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230404183150.381314754@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230404183150.381314754@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/4/2023 11:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 179 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Apr 2023 18:31:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.23-rc2.gz
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
