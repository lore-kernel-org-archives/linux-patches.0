Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6ED4DF69
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 20:54:42 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7956fa58016so20748939f.0
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 13:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1693947281; x=1694552081; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UVR084rR5RH1R/uQ9mTd3tl74UrOU5b3+sORgEFRSn8=;
        b=APwWVKi/pQ8feTg37FP0/Smhv9Gst6jvKYnvYnsFzc3TMTldnU6WAAhwchFCjdI4cj
         i65KoE8ybERt+KM+yy8Q61xjNmEKVMSQiZCnkHZRk+fcvdGz2UMIRmd8SrN9xrriYwIJ
         bpA4W1De5tu26fP+ygjuZNe8Q4Flkb4csn9As=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693947281; x=1694552081;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UVR084rR5RH1R/uQ9mTd3tl74UrOU5b3+sORgEFRSn8=;
        b=XJEIKUTNOGqS09AC90ShqSuGreK+tTX7u3oR8hzUwmah34iUeb4Ix54bwv4YeDfmoF
         xZRfAQrrAcwuaNyB76nUU0NUzRFX2mvJO62KegsGGYk59bEfWdWJopqIq3Y5m8+STcId
         y0bTeXVzLHJi58BSkGhx4PhB7PsYUbMT7rg28vEZNN9tzlN/jM8oQ2fE1VFySLTTNpk4
         TaLNInZlUZdx6DOgzNH/EW+PAZW5Ww8JSrtaql6CTIiJOeDlAPv1fVUrRPUjMUCOgAxH
         URWKlH0kXsptfFkjxGmtk3T1OcNS/JAiLtepyVjm1FxoTzIiZqCTNglBNlOISaGIeQpN
         AO7g==
X-Gm-Message-State: AOJu0YzrLlrMA5nBl1l0+GV7yed8G446WK7IuPV9p58daESC8Ie35s8n
	DqHhqaPMFPgTefG2F1lLpAH7vg==
X-Google-Smtp-Source: AGHT+IHIIrUy/PhIHwld2vNpd1q5Dv99pD5KOfcReJmDcupcmmT0Ucx+K1vnS/bAoXk+c9GG0Lx7Sw==
X-Received: by 2002:a05:6602:3e96:b0:792:7c78:55be with SMTP id el22-20020a0566023e9600b007927c7855bemr14393908iob.0.1693947281724;
        Tue, 05 Sep 2023 13:54:41 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id x20-20020a056602211400b007836e9ff198sm4454637iox.55.2023.09.05.13.54.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Sep 2023 13:54:41 -0700 (PDT)
Message-ID: <a82772c6-eb0a-f103-936f-e0201aba1673@linuxfoundation.org>
Date: Tue, 5 Sep 2023 14:54:40 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.4 00/32] 6.4.15-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230904182947.899158313@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230904182947.899158313@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/23 12:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.15 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Sep 2023 18:29:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
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
