Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A114D53B
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 16:37:01 +0000 (UTC)
Received: by mail-il1-f177.google.com with SMTP id g2so18053049ila.4
        for <patches@lists.linux.dev>; Thu, 05 Jan 2023 08:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y/kxRv6fDXpaPXcp/0ocKs2qh6YQ87UzMYUDDy7haK0=;
        b=P/ReJo2wNBxBTrUvbATD2VYqnybUbmSQkMNCwYbq6tWw0ZpaAzN028TO6fxbH3uT4p
         kur/SrzvKiAHIRzJTvJVUZlYb0/p5yCeY+3Gsq18ulNrxpc5nEokk24OzLMUJC9jYgjP
         xA1KCyrZd8ywvsgKpPXeN3GmTgrxh4kkoYVPg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y/kxRv6fDXpaPXcp/0ocKs2qh6YQ87UzMYUDDy7haK0=;
        b=03L8ImnOzO6bN1gnNu9ksPKRcBi0upYGAH/fMHJtSx056UA67MB32lqeIyOJg9nEBo
         am+8W7sn1qKVThoNYSeRHd9geJtcukuoGneKTQZuD5gsBvQE02y9wH8SsyMYQajZVXEY
         2WdMT1s6kxnTliodi+bMeeU1vXwIe8HmUz8XvGXujA8wARr3n2Dz1FXy3WtlUHAo00y0
         ODbHNdP1OHvUu/qoueCl5/UCVfAd/qzCzgcw+r6Z2Q4wQIXKF/eVtBmDcL1Yp3hya8qO
         loXEIi4rD0gg27U/wIcAepN+63Kz8zN4qj/TUesF5dWARySUXhezdXqJs/PsvnhjTeGP
         Bheg==
X-Gm-Message-State: AFqh2kp266ieaXEeNrOaPT+y+5u3dVNF6FttwGsYwdkWyzdHQun8mwFb
	FxDWPPpMhb9ud31Ap9ZxG1wWhw==
X-Google-Smtp-Source: AMrXdXu1OcNEMegWeMxBM8DfgQFOIdcUp7iZ2c0I4lCdhAQPGLaAYkGDxFbcnpE3v+nFuo9yTF85kw==
X-Received: by 2002:a92:c151:0:b0:303:9c30:7eff with SMTP id b17-20020a92c151000000b003039c307effmr7706859ilh.2.1672936620210;
        Thu, 05 Jan 2023 08:37:00 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id f16-20020a02a810000000b0038a8f0b4919sm11973940jaj.140.2023.01.05.08.36.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jan 2023 08:36:59 -0800 (PST)
Message-ID: <a5148d63-a4cd-cb49-58b9-6421bb8aab97@linuxfoundation.org>
Date: Thu, 5 Jan 2023 09:36:58 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.9 000/251] 4.9.337-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/5/23 05:52, Greg Kroah-Hartman wrote:
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
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
