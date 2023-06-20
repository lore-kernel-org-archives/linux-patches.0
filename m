Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156032AB2F
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 21:04:47 +0000 (UTC)
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-77de8cc1370so57967039f.1
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 14:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1687295087; x=1689887087;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AYujz9veDd2CO7G1dpy8ilcu4Kv8MRTtnNHN6uTYZNQ=;
        b=bFwYNvAcJpiZD8EVOOpBW5NIKQDuzbimB/glzhn4+Ek0kY8SC1Vwvg9f/WYcymgYl8
         77/0YR9JD6p04MQhaSDTuXAnTX2cHGkP8SG3V/9AUEpfNhcwKWezrAAljEdegUiQ1XTX
         wkvvQe3+pkn1UVl6oOgsqcGKpcf+fWI5aRdRM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687295087; x=1689887087;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AYujz9veDd2CO7G1dpy8ilcu4Kv8MRTtnNHN6uTYZNQ=;
        b=ANvvDrZyX2ixin18TBZfVlT8OizJlV2MBB634fYN2pG3pl2pvqXJq5x+7TFC5X1c2U
         uDPlrMt0l4p/hN4TAGbh9iG2rXAX8DCc5YwuOQV6mn+RUPslgf19qYLwI2KORqhFVCuL
         o4CCRpEDOyYx8DPaHRfRTOFAz3Vig+2JpsSCPMxxy2BaC+EYrZbJ4CrlFt+JQdl0C7Bz
         Rsv+fzenm0xyYx+Yb4QTnAfS4P2RaVGeVntTc+qHR2ObqeEVI4I5tRrRtJhHWSOqphx+
         os8RqGZmmitHDHd38/emYwvkyR0wFlpmRk01NHhePKr1xOfvwDGyvkn9KCC+FYUt4scK
         yxpw==
X-Gm-Message-State: AC+VfDzjOfH5ETqpACHh24MY7eyPhwtSSe3BuB4FIwQLumjzfwoUlTqk
	w+U9iU2hAmc1vg4OhXuSSLKAwg==
X-Google-Smtp-Source: ACHHUZ4VTwsl8aTrVK7Amfm6wbtGoXnbQw0L84oWsJQMh4ZBwhsU57quym3SYzHuZcgpSWwry4grjg==
X-Received: by 2002:a05:6602:3998:b0:780:a83a:7684 with SMTP id bw24-20020a056602399800b00780a83a7684mr2493834iob.2.1687295085634;
        Tue, 20 Jun 2023 14:04:45 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id h1-20020a5e8401000000b0077e35ffac2fsm903309ioj.32.2023.06.20.14.04.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 14:04:45 -0700 (PDT)
Message-ID: <facbb44d-5f33-fc8b-84df-c191bc7effb1@linuxfoundation.org>
Date: Tue, 20 Jun 2023 15:04:44 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.10 00/89] 5.10.185-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230619102138.279161276@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230619102138.279161276@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/19/23 04:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.185 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.185-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
