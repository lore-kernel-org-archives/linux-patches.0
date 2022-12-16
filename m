Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA362F53
	for <patches@lists.linux.dev>; Fri, 16 Dec 2022 19:06:50 +0000 (UTC)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-381662c78a9so45946277b3.7
        for <patches@lists.linux.dev>; Fri, 16 Dec 2022 11:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BKNh90Lruex5LAQVx5cYcXCYZ3q4FsH8oAZBjIKNToo=;
        b=faEBGsNCbPrJQjhPt7zew12CHmk9bGgxaalNqc4ELtgLZCac6DcgndYwqv2fumfjGZ
         0QnVb6LOj5Lx6fXwEHvR9gmnBa29rOZZsg/VET3NiLv9BqQ6gGIzVCLvKVDWM8z38s4l
         wj3hcQFbBtlk3MHGItM+fNwqiALGHyTwqRO0Rwv0PwrmTXTI5Z+/o72vGihY0mSADsMF
         Rk8E0MXXA8NNFr5F5hd/DZ69FTOTlhYIwE5uDbMIXgrURlJgUR9L19ARqqQtUc3qVld7
         9I8L8Y83AmN3nqzASkJ6L1d6xbuzKIXv42DQIg22sijzO64DNSn6UT9pYIewkQiWdimr
         nKAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BKNh90Lruex5LAQVx5cYcXCYZ3q4FsH8oAZBjIKNToo=;
        b=MH9rytBEUU5vJhWtozNVhbAFXryQIlGpePA9Id+9T64SXgXtijZ7LbsrcA/tiqDMLw
         wlE3h+uyaARCjiitGVWSKE1B4Vi6ocGZqCk+EjUipIMg5qMw774JmGJ98y9Bsr9pEDtq
         ZAreru65rHkaMH7So9rISBhfNTbv7/KsY37LAwesCD5rbiO2GPKBvDFmqVzS/n8LohSs
         dGvpEsOidTrcco2lq2yqGagvLQlP2ejZQZdvicTYYCBAonWmZgClb4PTmqrs7ys61sB9
         QB7ZZVlsnXefIoI+dE7pSx7DKDnVAfx5tphC1jEY/anjY99AvmG53+nTI2xJdW1oZkak
         4+gw==
X-Gm-Message-State: ANoB5pm0b9ynSlEDOgZf02uIGMBAcUCYc4SMC17VCXYRYWu63wlzInYP
	gm3sN8twxkBG/ybJKToSykk=
X-Google-Smtp-Source: AA0mqf5McHIiY23aK+5KDxvpzI54RDbkKkvL3/zZY31DOkZjpjvJiWHlsng4dOOC6LzVCjGmB3J6nA==
X-Received: by 2002:a05:7500:413:b0:ea:8267:6a4 with SMTP id f19-20020a057500041300b000ea826706a4mr5475544gab.40.1671217609769;
        Fri, 16 Dec 2022 11:06:49 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x17-20020a05620a449100b006fc2e2198easm2057704qkp.95.2022.12.16.11.06.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 11:06:49 -0800 (PST)
Message-ID: <656e4296-5810-9eff-a7cf-513d134656de@gmail.com>
Date: Fri, 16 Dec 2022 11:06:45 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 0/9] 5.4.228-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221215172905.468656378@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221215172905.468656378@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/15/22 10:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.228 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.228-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

