Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C868F8C0B
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 20:29:13 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id u10so6394619pjc.5
        for <patches@lists.linux.dev>; Tue, 21 Feb 2023 12:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6ZBdxrcYvbI1Z3Ko4/Ygq22p0mSRneCJlicvJMQ62Kc=;
        b=Jvz+wJA5yDvMdWAHjRTB1t5IO+pWd8B5VE3kh5OvwMSNITqrdXX4S5AG4+8B0dCW6K
         4NlXKs2VU4tMme5Liv3qc2cFJLaWMSIuGw1aUC9eLMKi81zh/1Zar1Dp98/iIQo1nLZL
         CmmbcGMNQKNRcXdonKRydfoGI5gHnCIzrFmdaPu2BpqoSiJ0us/boaAhZVJLRqVAWLSA
         38F3y2ZnMxiZDuPDJqsJeYDndb75xIKeP7pR1Mmc4D6KVbzMHVqrSMa9qpD1LWQbeaDu
         D9nmQJMLmfR9Jg9Ri9cmZIYcW+YSaVlOKbRD8xza6YZXG5VJnqMOGIhx1KdiRV5Ub90E
         F50g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6ZBdxrcYvbI1Z3Ko4/Ygq22p0mSRneCJlicvJMQ62Kc=;
        b=jX0xZp9ONsZfbd4jIcqpHRlBadYyLpnEEJ95ztzr3BApeT8RUvNyF/WHTagr3qHhdc
         LBPR6atDwteeuDGDWiwJKrGXefm09ZNoLzwmH+c2vqOEpF6WIAvkrIkTgqyxwkVRckXg
         HS1MkUD3V0plfd5/aQhT4QR0gquT9zOtO7cOQIhsAqzPI9iRLkv2CRAsOjXNXow5erF6
         P6aT0k0sjxw4bDvT0xN6ddu/dBlsomBgRQmDvA0WBHSv6txTVZO6ZRjtsNTb88pfJ8bQ
         8ZbQKOT6RWtri7dzcMEMbTMhLHxAk08Ohd8tsE2JwKIT06SfJqQVzskPYjci1IQ18ipA
         iqbA==
X-Gm-Message-State: AO0yUKXaX9jYh9hUIHZYZrhS30GoSe+ye6Y37x4fv3LIxFvuMZg3M1ww
	D/xwSrN64godK2BRxRleBe0=
X-Google-Smtp-Source: AK7set8QdnIlUvdnGKNBL6HaRExsMpy3ecuBzjOW4TJDCCArDXbTrWZiABHdVxzQA2XS7dp56qHB3A==
X-Received: by 2002:a17:902:ea07:b0:19a:887d:98ac with SMTP id s7-20020a170902ea0700b0019a887d98acmr8151056plg.46.1677011353003;
        Tue, 21 Feb 2023 12:29:13 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bf3-20020a170902b90300b0019adbef6a63sm10257324plb.235.2023.02.21.12.29.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 12:29:12 -0800 (PST)
Message-ID: <27de6440-c062-db02-7f46-78154de1dee9@gmail.com>
Date: Tue, 21 Feb 2023 12:29:06 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 000/118] 6.1.13-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230220133600.368809650@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/20/23 05:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.13 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

