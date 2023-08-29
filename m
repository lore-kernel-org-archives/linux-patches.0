Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2674E17751
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 20:23:23 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1bdf4752c3cso29735735ad.2
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 13:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693340603; x=1693945403; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9JouhxBa4CgjE8m+MiUTn5+R6KTenHsJATYLj7J/g98=;
        b=m2LG+Ra/1QqUGbv5endFlHrw/1Pd3quulZQItGy5akD0M5BZQ3pVjGwn9gMVnCk++x
         l4XFbgrl69zUcfUM+h+S5iCqkb2YkxneMWo4HbfZ+wT6X8YZEVaOuhgU6mmjavwszYy4
         WTWkizcPAwLsxHb/qpUwDvzWta0LNcZWAUwfZkYIDni0kDtHCxR9sHsgvw//dBYKI8Zf
         pH1k+OE97FDZq0yuAI5CChKvAr4/cH6ktSzOQOvCsyX3qT1UUwXeWuJV5K6IdRPXwPPE
         A3MW9O5l7tAfvNdsna42HxwWlAQ6fsndYvUrESnI/g8vBlHJ7CtDOmUeODOPN5H6Gt6p
         YePA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693340603; x=1693945403;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9JouhxBa4CgjE8m+MiUTn5+R6KTenHsJATYLj7J/g98=;
        b=A6MvWH9IB/osg3/7KBY8BwlMZzd0tFNcxpnZ6jT46SJviCIucA3drzQNMju9mnjEUI
         eQRH0jVXk0PTK+wxoYY9oc2Ry1xCiOvRtVEi/kBOy+DfkGPNPNEwMXB8QMH0WclGvMsv
         ke5ewjRs6lRYi0nYl+xtp66GUMysFhQHe4Zggszvpv76WMqCNxQdZNm0k/yw44SEpMY3
         3K1vP9EJGjg01wRrI9BddgRFMyhoSI9ktxiGRtf5OVZYkvF6ofqni7T5gUGm8Ak3LUlr
         9u1kjX8giVhQbaCC06VTVyFIuDCa3eeiUQKOwbKmsRqPngkmlgEmZDeUlngQ5efaK5jg
         M74g==
X-Gm-Message-State: AOJu0YxDvbCdw2bBRakAoqBc+zdmt6cXDVqthrglUe501FXI9g91epbo
	OH814S1iTWFTXtGvJVspTnU=
X-Google-Smtp-Source: AGHT+IH/ZV7YXX4NiEwT0xnxwNSN6YFUbRam+I4C1qDFpuGDwrSQrE7rRyGcyXBU50rSToFzJRlY8Q==
X-Received: by 2002:a17:902:6507:b0:1b8:c1f:fd2c with SMTP id b7-20020a170902650700b001b80c1ffd2cmr195154plk.33.1693340603373;
        Tue, 29 Aug 2023 13:23:23 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id v11-20020a170902d68b00b001bdc2d10753sm9707929ply.215.2023.08.29.13.23.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 13:23:22 -0700 (PDT)
Message-ID: <3d3f693c-c6b2-9bfe-6293-2ef623d7e7dd@gmail.com>
Date: Tue, 29 Aug 2023 13:23:03 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.4 000/129] 6.4.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230828101157.383363777@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/28/23 03:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.13 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
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

