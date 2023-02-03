Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2B5AD5A
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 19:43:41 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id g13so1520990ple.10
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 11:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=42CtTtaJ+bIWw65Z5N53SH3D5A7x3sruWivwIA8MBz4=;
        b=YBApVbZdYcIYgirrMardhbQqxnlujFcRrYiSbTrhwQ6tSdI/JpBHQLS5jxc60vg+ul
         N6xB0HTS7/al/+RQW0NHpJnrKKiesii+OPNHShNxn/JUE5SIxzMugJwbm4AtbZsVOoap
         gfnMnpiFSDzKh7THWY+kDWLk/Qd4ukYWItdFbwQZPmvdXbKHz65tpRmTiYedYiSqrv5e
         JJyngGKrQe3Wd5oHfcql7rVxDBf08nXfKGQF3H3nNnfTXevpUzWEkMVzuWutADol5CT8
         6R5SFOpHdgk5GZoF6mSbySBj694BMSKNbyk/EyO5gjQCjtRgXj5hN56zjmMZzcNrihta
         gbeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=42CtTtaJ+bIWw65Z5N53SH3D5A7x3sruWivwIA8MBz4=;
        b=6OWTAZVexfOerSJWgTVOfwFOzOh0Az2JX/qaLrb7WumhdG670IdnfSnkO++Rt2bNea
         GBfO9cOKkfUw1MmFRwKVBiskh2fqX+Ja52fM3zzh2HxiiyGNbTSb+x4oaWWIPipE0Z1v
         XsnI9bifHIuHeIMKb1uWwtGJOvhHoJpu/FZqrvTmo+qvI+tTwPu24+rlqQ8ssw39CzQO
         W+jbZhQtsRVQ6G6riYqE8ocl6++NnYpQeOlApQtJraMe1CsRInD0fIsNHQiLkAOzBX68
         f9YZBKvdA0ZrXIWWyNJK5Q7yYLUzrmvCQ8Xe0crjCSb6v2d5F4LNaC5pUYK0pslih1AP
         7NyQ==
X-Gm-Message-State: AO0yUKWnhXQcI9SsnM/FIMkduzwG6asCgN310IKhB6Q0iDAvg/xtGelG
	oDyxyNwHG/+xgRfJP9OmRQg=
X-Google-Smtp-Source: AK7set9CeAhZOXwl0vO0C7M4hLMVyJt2o2PkRR8mPMMQV5vdtyaNxysn9P247BCKotJaAwBcNbgNPQ==
X-Received: by 2002:a05:6a21:1644:b0:bf:8aea:c555 with SMTP id no4-20020a056a21164400b000bf8aeac555mr7563018pzb.13.1675453420752;
        Fri, 03 Feb 2023 11:43:40 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o16-20020a170902d4d000b0019678eb963fsm1984607plg.145.2023.02.03.11.43.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 11:43:39 -0800 (PST)
Message-ID: <52da33af-f6cb-3179-b77c-636894eef52a@gmail.com>
Date: Fri, 3 Feb 2023 11:43:34 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 0/9] 5.10.167-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230203101006.422534094@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230203101006.422534094@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/3/23 02:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.167 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.167-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

