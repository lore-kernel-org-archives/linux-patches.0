Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0147364
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 01:55:43 +0000 (UTC)
Received: by mail-il1-f177.google.com with SMTP id e19so373540ili.4
        for <patches@lists.linux.dev>; Wed, 09 Nov 2022 17:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7DeNYIUBWTywG/gDOlDG5B77j0lwFlK62VoqsKy0P/s=;
        b=YzC5pl2/YElPt/nUcBH5Pbu91V4MS+zBf2si4gSI/KzE/Vn8UIP8mCCpqrEULGhPAz
         WDfp+yLTPMQyNDZQA63T0ZDgaTpNpFj2hxQmQ8thhvR+XBzHXJlLiC+y4d8TPlwR9Sq0
         XiYcYoT6a+PgvkIKwAAWn8qVpdxXE1VvVigYE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7DeNYIUBWTywG/gDOlDG5B77j0lwFlK62VoqsKy0P/s=;
        b=vro0DAtQaeyxART9a84sF15yyt6V/OFi+Y/3VaaZPdgTY3QtY1/vPbBBqkq8AWa0vY
         XYs5xueWDyp2Fj17G97jg3y/dKHNN1u6ycge11a9xPeVCHfZ/P5/6Af8au+exPM3rsij
         za6g0niL/yxR4CWj0RlsJN3A8Q8srQ/dPIJFpmIm1TmVXW+skqyClueURW+lUrAiYps2
         9iiNQepRnWTDLRZJvIMG6eEPjpX2RFa738zZ/LDrTzklZNXu4xhiRTx8F3gMhzd5ZsI9
         rJmaiET1pWitaLEyklKwjySe5obUZ2SpV17/qJJZs7zjjYVM37Wk8juwu+v69/KcdDsZ
         nPWQ==
X-Gm-Message-State: ACrzQf27xzsCoYc4xLGsbAUO6nBx42JMxn8UzavsVevVAi5fJWtA0xHI
	4rNORN32WmPPRnZKBpzQGVVTLQ==
X-Google-Smtp-Source: AMsMyM7fmqkJeiOtkQvq3BG/4R7lEavjiOcezpN8LETzccWoghHLFNxwWwOFZtHp30LZW14wF3ymPA==
X-Received: by 2002:a92:c910:0:b0:300:bfb8:65fa with SMTP id t16-20020a92c910000000b00300bfb865famr25830028ilp.276.1668045342797;
        Wed, 09 Nov 2022 17:55:42 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id b7-20020a02a587000000b00374cd28d842sm5369180jam.104.2022.11.09.17.55.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 17:55:42 -0800 (PST)
Message-ID: <43495c69-8110-0e51-3cbb-2f96c7d41c08@linuxfoundation.org>
Date: Wed, 9 Nov 2022 18:55:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.4 00/74] 5.4.224-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/8/22 06:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.224 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.224-rc1.gz
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
