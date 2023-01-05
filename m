Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCEBEB27
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 19:28:16 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id r18so25160401pgr.12
        for <patches@lists.linux.dev>; Thu, 05 Jan 2023 11:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GwfcSIICsOIyK5Yw2ufNNP2O+AzOBcTMp/lG61+JBDM=;
        b=kh374SFBr/3Zjd6AVfCclwb07M1Y9OhlvHUZXz/JTPe396pLR36qbmRS4S6dDAokjd
         Kx/TjJbAvjnZjiAo0rS1yD3scvKER93iL7YtElOSs8lvhKOzToQlL7TDBjdz0db+ZfJa
         hioWBBtEopPNoObjv9InHYftYSmbrP34O2KqBVVw64z0sVLI6uac4OdQBWXPkcbqGaVP
         ainjapKOvtabVGFESe8N1SGQHt39JqIiNc1l6XHIzNiC/CHdF5KXctwtU0KcVMAo/gfn
         CmE9UtLKThBjAIPUoYCI616Aq5Wwcc30NNfOh6zqQSatmR0O+whcKED8PVqQ0ckp+2hK
         GJlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GwfcSIICsOIyK5Yw2ufNNP2O+AzOBcTMp/lG61+JBDM=;
        b=LnK5EZ46ofZbnNopJwsEouvrF4tUUka48LwObjw86gBuXK+9RZlcyqe5tUb60BbTsQ
         Q3+uvAgk0tCYgkeaPKGpsw5D0AXb1SK5UUDKsVt6kqydfpoLrhmBxiz+LeLOvlk683f5
         i0szyHECoZ58AHKfXHdcZx9QcRoxpGRVMfl9IVb3zXmE8sXC3+n7ma0su8bvBAwBZXbK
         wxGICm1y6Lc2Yt+60I/EKr0CJLdUiIbAQoC++1+9Qgr2F9DSb8zQZcfxhBlXKYJqdvTw
         2b64IeWx+B66S4wMbCm0AI9+K6cAklF0aRL0ZFVAYGz9ypBb0voGTITp0BAsL1ShxL7T
         i4Ag==
X-Gm-Message-State: AFqh2ko+aI7EgCkrwzYObr4+09R08XmgVoKDbutaBICelxAlya3sqB5S
	TU4mz1HZwlQs8VuuYPMmiic=
X-Google-Smtp-Source: AMrXdXvxCAuKZtTYP7Ag3tfLxofAPlnM5XZCWWfwt0GC+1TZDtbXTZHCnH5UWdYKErDd68T0m+Sh6g==
X-Received: by 2002:a05:6a00:a1d:b0:581:73c4:f0bb with SMTP id p29-20020a056a000a1d00b0058173c4f0bbmr42876719pfh.2.1672946896252;
        Thu, 05 Jan 2023 11:28:16 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x24-20020aa78f18000000b0058134d2df41sm19977629pfr.146.2023.01.05.11.28.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jan 2023 11:28:15 -0800 (PST)
Message-ID: <4e46ff8f-c990-192c-7e20-d4ff819f846d@gmail.com>
Date: Thu, 5 Jan 2023 11:28:12 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.9 000/251] 4.9.337-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230105125334.727282894@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/5/23 04:52, Greg Kroah-Hartman wrote:
> -------------------------------------------
> NOTE:
> 
> This is going to be the LAST 4.9.y release to be made by the stable/LTS
> kernel maintainers.  After this release, it will be end-of-life and you
> should not use it at all.  You should have moved to a newer kernel
> branch by now (as seen on the https://kernel.org/category/releases.html
> page), but if NOT, and this is going to be a real hardship, please
> contact me directly.
> -------------------------------------------
> 
> This is the start of the stable review cycle for the 4.9.337 release.
> There are 251 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 07 Jan 2023 12:52:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.337-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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

