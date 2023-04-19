Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E5C3236
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 18:48:31 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id b14so170121pll.10
        for <patches@lists.linux.dev>; Wed, 19 Apr 2023 11:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681930110; x=1684522110;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D+SqyhX+3FqHam7C3q5QGtUBNfi8q4FZTru56mM6qbE=;
        b=RzC9ADprsx/h8HXKtQDNfM8dxoNlVlh09sxEpOYd+VfMAAg6p8i0BmSyuFYXupcKoE
         l2NnD9c0WnohldgQE0x+N4xn6jAYjQW/bbaG5wlPOaibUIOX337opAIZ0ymZfm3EvY0f
         JqzsKLZVfe/dzf+egRGzFyUVkbYXdCuTZDl9gJkfqAJLIrM7FGK/7++RsbrVBO6pyZjC
         wNj8KCThgJsaBL9E18Qj6jIQQ8eCPaqgFGQvP8SqZt+7dk4/Ri/8HbTUaTpEUlzC747F
         gcLg4D2UWmueyGYyvNL1wWkxkcC5i999zdEHD9+ekqBB/jKFR9DcocprDjfQChlqaNUA
         v2qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681930110; x=1684522110;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D+SqyhX+3FqHam7C3q5QGtUBNfi8q4FZTru56mM6qbE=;
        b=h01r7s9GrkzQThC0BP8ae2KPP8b1eEdUNEedp5TLUpFpJPfaGAGcGCyg9gSruIvxTj
         95K2qb2IdKIUypl2gTgHWRbqh/no12ZHmXzNzKzouyOXDgWKCZWqcSkbKAAAnf8F8QvV
         Sg0SGGNOic7/sPbUfThLn7oE3/7L4vvUSyYIziR+ryVzmD6NG6qvx5vImN4yTB0kAjha
         jFcxjCWozNHAKRPq7csvk/WmjOcwIq1r3cSV370L9OJUg2hUlBHJ5S2NraOJz/RzHUJ4
         RO4EFJQudxdCuxTBLICl+ttiIAeuU9cxHdkXrwLn0OM2CBP5O+92qYWY1F3F+r5VaBIR
         C0DA==
X-Gm-Message-State: AAQBX9epJSJEGp9L0+S4NxPbk3eObnSVRr9xJlHylRey5oHocRvrt2qz
	FkqWfS+DSKnwxIhXJI1Td+8=
X-Google-Smtp-Source: AKy350avFjskgNR3WRTTklTxIYMSEHrgekcU1SuOqrQwD8V74+LOBJcu3Gt4aFNfPV8NLLUuZG9wHA==
X-Received: by 2002:a05:6a20:2619:b0:ec:7696:ee96 with SMTP id i25-20020a056a20261900b000ec7696ee96mr3218648pze.38.1681930110495;
        Wed, 19 Apr 2023 11:48:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r10-20020a63d90a000000b0051b72ef978fsm8829366pgg.20.2023.04.19.11.48.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 11:48:29 -0700 (PDT)
Message-ID: <e40e811d-51fc-d7c2-c3a8-69f22e8663b6@gmail.com>
Date: Wed, 19 Apr 2023 11:48:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.1 000/129] 6.1.25-rc3 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230419132048.193275637@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230419132048.193275637@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/19/23 06:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.25 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Apr 2023 13:20:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.25-rc3.gz
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

