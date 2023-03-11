Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB38EA1
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 02:09:32 +0000 (UTC)
Received: by mail-il1-f178.google.com with SMTP id y9so4088446ill.3
        for <patches@lists.linux.dev>; Fri, 10 Mar 2023 18:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678500571;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=41aygJ5SYte9HSlYMkbUpX0opg3YPHib82+u9lz3ejA=;
        b=fl6S8j+9bPkRwcv3748VyAdqOgRi2yYrJq0o+Y5q7CQXGJKhGXID6vn6eqMGxmZhaP
         dtgyIc2IDGE4aYGnZyUn296FM6/zWv05oIkjyZx9fEJ0enxtYl01wp+dYenNzHLp/PBW
         8QcC5e/7EMv+TrMO6Iuu9moGCTBTbMHU7ItfA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678500571;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=41aygJ5SYte9HSlYMkbUpX0opg3YPHib82+u9lz3ejA=;
        b=7KZ5NqRvuO2rI/XQO8PkGO5wCH+fkdS9jWqfTuTfbRzh52vnA/khn3B8/tO+to1AhW
         i/hXKtnM836P62D4ri9eU0e8wLqZEIP2PZHJ9mfsylT9mIaOtPdUklE22249+1vyD7NS
         NAiNYLF4fdRLQT0k7Zs0F9DekB/FdS7dGjOVGtqSekGYIZlCFovOkCTsWWQCb2OC0aGK
         gLul8cB8N10nhMv0gITd845x1+YHQjqvKJ9Z04vH14XfbR7aOGR2fmKMAdWJVwfeo6Kx
         VYlBHZw7N2ITM0wvHep5SFp28cLaeQhK1+zpQfpjzUVcLMbpFArtTaiId0El0BTNhnw2
         WrAQ==
X-Gm-Message-State: AO0yUKWYd9vhpZCScEthmCnPqVS3HmUn03wwxWOD7AvL3U3B+GdIH3Ep
	Yvs7rPbHKKSIAyKJkZ9olcRTKQ==
X-Google-Smtp-Source: AK7set/ocK1dzDSFKqceBiea/2d8FPc3KoKV6Fxj/GwJVl6n80Z9kz+55zJV4TZNa0y2TqKCkYjrkQ==
X-Received: by 2002:a05:6e02:1d16:b0:316:ef1e:5e1f with SMTP id i22-20020a056e021d1600b00316ef1e5e1fmr3214944ila.1.1678500571693;
        Fri, 10 Mar 2023 18:09:31 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id p9-20020a92c109000000b003109f26455csm461229ile.55.2023.03.10.18.09.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Mar 2023 18:09:31 -0800 (PST)
Message-ID: <9621762e-0594-9076-42bc-86521dab6312@linuxfoundation.org>
Date: Fri, 10 Mar 2023 19:09:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 4.19 000/252] 4.19.276-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/23 06:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.276 release.
> There are 252 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.276-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
