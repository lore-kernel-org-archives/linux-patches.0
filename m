Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B691C20FE
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 22:45:59 +0000 (UTC)
Received: by mail-qt1-f178.google.com with SMTP id a27so14953203qtw.10
        for <patches@lists.linux.dev>; Tue, 06 Dec 2022 14:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HhusZo0UZpLkHp2hkG0XwlRQvwly+H9BUTlbjfbvJMw=;
        b=G5rwXV86DqYOuntYVKt2rBWXbW2Ib7WhMzic6olCKjyrb+r1rlO2bXg08RZwDsNL0m
         9x/7PEQU0Q2V0HZFhg8BZNehre+jQJEGt2RkP6HRON3qoiqygxpkf6opKVa8ZKqfTRhW
         DaWm/aO7hFeI5EEDlpCkNeeFdWz6UgMOO2QJ2d+wOSjzStCtIM+8FZpXKOSESoqIqkQD
         +/RJIDgQ6zEw7Z24ILqf8Q3vDqb53uVoAT0RhuCajJrbRn/mYL4Sj4t0CnOy7PiEvKoK
         0Gx0T5BO2CE0RSG9vPvFDIQ94UqhbDNBFhkcap6YE3SqPHc7wZXMueh4+8ZEpIe7SxJC
         mznw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HhusZo0UZpLkHp2hkG0XwlRQvwly+H9BUTlbjfbvJMw=;
        b=mKQQJgZTIhqzFRwZEY9fLCokn/w1shZsN1Pzto5yVMeiis86n0btxsAHyBMdp4DJEm
         fieEXCFXeShRMXqSJ7Z8lP34PPGFG6OPLgoAZtcyAR3NwMY/xHwpFXc2p8yIjrDPKhNG
         9/wuvl8b8fG9m7wZSAxTGGYhJ8Bo0AGBvnxqNunrLBcHc8jcs3KYB61t5jcjA+BQkaF/
         9hLVmO9T/l17tPa/EIw13C4Q3FshGTz7ZeP/U0DP2b2cEJgubZkVkEXaVUzBb2L2R2kf
         9Myu1OzFR0n2Llm6wksvFNzdU5RSRgcwjNQY672MCWUgFFV2+w9t/rzFKzAl0LfanBTd
         8Mkg==
X-Gm-Message-State: ANoB5pkmqOjSg2I2pWxwKDyhRTmqt3srNpqOhzDyanI4WE3aCwB5btgy
	ewKBgFLHumS0hZCqihaUsXXEknjCGsL1bg==
X-Google-Smtp-Source: AA0mqf66qzaR2dpf2TG54CKjE86fDCbs73ZBLCAKWxnqMoOxPGuqmYPJL58epYiAfV58VAJviR1ihA==
X-Received: by 2002:a05:622a:1e94:b0:3a5:1ab8:4250 with SMTP id bz20-20020a05622a1e9400b003a51ab84250mr68202211qtb.182.1670366758538;
        Tue, 06 Dec 2022 14:45:58 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m15-20020a05620a290f00b006fc6529abaesm16076691qkp.101.2022.12.06.14.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 14:45:58 -0800 (PST)
Message-ID: <139be316-d52c-126b-d5e4-24e846ef88f4@gmail.com>
Date: Tue, 6 Dec 2022 14:45:54 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/96] 5.10.158-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221206124048.850573317@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221206124048.850573317@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/6/22 04:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.158 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.158-rc2.gz
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

