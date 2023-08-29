Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9650E1643E
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 18:52:18 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-56b2e689828so2931523a12.1
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 11:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693335138; x=1693939938; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l704Aik3201dAT3xaPekHycqSJkh+bdmlwzdqElcllM=;
        b=CFZmSQw6SlWr5dOyBxManVkmqyeQZ9ciZguLGoiWa2rot4ldxoXyx+E3LILwEY8FnY
         +5wRIa3pK7bPMWWXeQjG0PO5uZ1LQ8OZd1fCzPD1lGAUTI1G/hvegAQPlwcE6jD5mHVn
         dgJwSlgGD1zuHQTHSrNlvtOqd1idraAshpBEUD01xTeZnb8lHI9XwGPGQrWLckhLUYdd
         javesB8ct3bFSP7H43iqc1SZMACGPYyK5Rh7A0ECz38/m78vKdQAzTC6pGmZfVAc2JBz
         3u98fLX0YG+PUcM13NMFzNnJjpYh18Lbuq0KWnuKiCA4kyITKxWXNqC4rLksk+0XbWJO
         uicg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693335138; x=1693939938;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l704Aik3201dAT3xaPekHycqSJkh+bdmlwzdqElcllM=;
        b=ClstE+N6rdUQNy3HW2N17fBGiBcefN9jiMGDXQhAhvgmRnW/ypmcnN9ZUuCYYG9tfm
         CTY+VuE86aYmiqIdu3qJd31bAd0GEqsyBEh0JGlx9bV1gdaPwYvF35MZ5pzk0zS/QFU5
         +Rg2pqPfU/w/+mZH32fVuHj5SQRl+UHSIEZW55XLaZTIf8maLBRjyke6ezxz2NhKVDzf
         4rUBteYI9rlZfSLVRz05k7GrqM1mkawPYqPzZlkHHIPSUUKmvwqN/kKHAiQ2L65245zT
         zro9eYscYZU2BifJDMqAiT0AdFf4YAS/v4hOD8CcLsWD7ocejMkQ8qZmcanZYA3q/dT1
         d1eA==
X-Gm-Message-State: AOJu0Ywv/eHJ/g6+gqheIVtGnvkE0/ekxIO6PLZBEvxkeH5VEt/w/Eh3
	En/ku6XKtPAjtKvajz1ZLSw=
X-Google-Smtp-Source: AGHT+IFOQSJnZ5nO0IQjbJcAlfqk6huWA2MWRBZgkY4FkaEig+/fpIgF/euiU+uxX48VIJ93YI1uNg==
X-Received: by 2002:a17:90b:ed4:b0:26b:e2b:6c8d with SMTP id gz20-20020a17090b0ed400b0026b0e2b6c8dmr41893pjb.41.1693335137829;
        Tue, 29 Aug 2023 11:52:17 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j16-20020a17090a061000b002676e961261sm1921129pjj.1.2023.08.29.11.52.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 11:52:17 -0700 (PDT)
Message-ID: <be80528e-ce50-ce41-bf11-519f71dad2be@gmail.com>
Date: Tue, 29 Aug 2023 11:52:06 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 00/89] 5.15.129-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230828101150.163430842@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230828101150.163430842@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/28/23 03:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.129 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.129-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

