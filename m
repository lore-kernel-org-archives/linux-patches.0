Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C83417FFF
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 20:20:22 +0000 (UTC)
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-77dcff76e35so62380339f.1
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 13:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1687292421; x=1689884421;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SAU0bCQDfaWeQQcZMARHMr/mQ05K05NW42OZYQoDD9I=;
        b=NmtnABWAabO8gsDl2yLzFJTJkqCqcpLEXRaRCjfnQdF25iwNWkicyBt1KrmG7AcZbD
         YRhZx8fhVqQovtYz7hdLW0amX7knX7flOf19kghho3QxRdV2uaVAo4YeNVsoPv+YZHM2
         xbR/JrKYxrBpxi7eI6DRr/pTQKzx7XxY72Qtc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687292421; x=1689884421;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SAU0bCQDfaWeQQcZMARHMr/mQ05K05NW42OZYQoDD9I=;
        b=JcB8vhl0W/KCELBIeKGCb35bYiBk2NExqstUEQUfYrnYRqMDjAH2zM0uZkEyp6hkK4
         0YDd0lBUJ11yYaNoA3D02iBa79/kmKUbHXJr7iwxCkb7MIRLTpdBEVxSe0m8PCqhhNez
         FIMGQHmdmQ/GOME13fr5947QWagDLEiZQCR07qoWSD3VJaX8T/FHx8DfCBxMk5mfbxCz
         RlqES2IprxAV4gTGNtgHLsFIGunVCyttrUNb+3i3DPKdO1vB2kB8ierSkYFYtAeCoTBF
         Vtb/D2K3oUy5hgCCLK/zsNRTHvO2+0hRWwG76d2SOTNBFkULTZiuSMYA09OUBVeq8nta
         V1ig==
X-Gm-Message-State: AC+VfDy+aaJbnc8QVjTDdwXOP0MBUep0GIDrpW3WwLPhYWZeSMRj1OaH
	MBaWUvE1XdHXciy7wkQnTYuHxA==
X-Google-Smtp-Source: ACHHUZ5qLF5YGtIgsIFZ5nLQufIMRoj7oggdbC461d/Lt7J56XQo2v5v7dhI2WolDYlcP83BlamFUA==
X-Received: by 2002:a05:6e02:13e2:b0:341:c98a:529 with SMTP id w2-20020a056e0213e200b00341c98a0529mr10102365ilj.0.1687292421399;
        Tue, 20 Jun 2023 13:20:21 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id y7-20020a92c747000000b003383276d260sm795767ilp.40.2023.06.20.13.20.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 13:20:21 -0700 (PDT)
Message-ID: <249cf242-ca56-77a3-a775-172951f1d0bb@linuxfoundation.org>
Date: Tue, 20 Jun 2023 14:20:20 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 6.1 000/166] 6.1.35-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/19/23 04:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.35 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.35-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
