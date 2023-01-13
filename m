Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A46636C
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 01:12:22 +0000 (UTC)
Received: by mail-il1-f174.google.com with SMTP id m15so10223949ilq.2
        for <patches@lists.linux.dev>; Thu, 12 Jan 2023 17:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i3UT/Y1YH16gP2vBsAlIZgN/46hyjtu8955sOLq2zXk=;
        b=CEtDvhRoqlHH2IjISObtaCW7RbrvpPQfs5d5A1Zr7RrpXHABAaViv2PLgzJcDX9B9q
         n99D9ZzIrh3GTQgBvXhs9f+mqpF/OOO7pd81Z4FFui0jSQ1B+rqC5b/R4codAvTWe5SO
         5z1gQiF5IbdlqJiE174Jx1VqAqviKfuYL6nqE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i3UT/Y1YH16gP2vBsAlIZgN/46hyjtu8955sOLq2zXk=;
        b=QLCrawXgOu8R+FlA6WDQ/kfOAqnX6Qb+ynWHHWOrZjCeDoLJ5mEMEkh98ofViq0byB
         wNBAeU+C7L9If+ySY9VTSBWP5WMB9SYXU9tjALiuKkTJnDowHm3vRBGPthIBYf5+E5aZ
         IG7k3jl60M9IA7USUK1sgnF4Rd+JpIU5/Z4qy6Cusjzr01ZQ2K0eUPb80xBUrISO6+vG
         kfVjQg0ZoQZiAspVnLNQk1psnURzv3hMLGko2EzBfG95cvE/kVJHgQuEdicYBrl1PZc0
         gnoeUKzB/OMWv25rT24A9CMdi+U7is8ciHTYBFZ8moXVGd/nyMxntmcGPWIehTvFvNn2
         ezog==
X-Gm-Message-State: AFqh2kqpQkvFMpQwdbJHHGEoJPxzFhEl/FOUa5Ba+7ZtRem6aHwRHhHt
	xl1M2eDu5Y4GOu6kg1I8po422Q==
X-Google-Smtp-Source: AMrXdXvTNwz4bjP+BUdszRNeD3iupE/PtHp0EJPBt9ClwLR10prNcJZQzDA8KIxlCb22V83T13iPKg==
X-Received: by 2002:a92:1306:0:b0:30c:4991:2eac with SMTP id 6-20020a921306000000b0030c49912eacmr6276505ilt.0.1673572341143;
        Thu, 12 Jan 2023 17:12:21 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c3-20020a029603000000b0038ac01fb3bcsm5825882jai.14.2023.01.12.17.12.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 17:12:20 -0800 (PST)
Message-ID: <74201163-1084-fba3-5bf5-49ee5adaba45@linuxfoundation.org>
Date: Thu, 12 Jan 2023 18:12:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/783] 5.10.163-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/12/23 06:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.163 release.
> There are 783 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.163-rc1.gz
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
