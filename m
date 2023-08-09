Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E3E24513
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 19:38:54 +0000 (UTC)
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6bc9254a1baso147435a34.2
        for <patches@lists.linux.dev>; Wed, 09 Aug 2023 12:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691609933; x=1692214733;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZaTe1EqwYOzn8O80KdtH3kNt1a9FT3Yhi0ZfT/Z/G8o=;
        b=FBR/I6GSX7g5L4+DYcUjOHmmh41YZ9ahuhCPkULHJjX64s+cWRH+5yvVwwBQz1G9CW
         NvdSKm+G8tn0TUhKDJCtMQ5Ac5En//0otMlgKyn/s/4jK2L5V9PtktOx94jrbJ7fmcyv
         lhTyR4yQtv6f/+OfD23G2edsJz2U9XlPQK87jzNOzpac5sROvykiNtHPms0XErmb5C7G
         8jmr+hM32jpiPqX+2xtvrsiZmHpQ+fCR69tcfogT56c4iRdOQq53XasotC+D4O5HOJ9I
         5WyuImkQ8A3tYwhM/moCQOXzxamUTrD/gyZLLcFWM8v5Qm6XeoE/xRo3GDa+FS77D0hR
         HdCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691609933; x=1692214733;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZaTe1EqwYOzn8O80KdtH3kNt1a9FT3Yhi0ZfT/Z/G8o=;
        b=hK2Mz8VyMYHFO0Mi3B4fEiugdftbUOeFDBFP8khILJUvKN92yppTAaECUGN+W5QocH
         Ruz63bwkLCf7115D5x42O4gGAIdKVo6ZGCNM8OworE9q5IOj8hQjT7h6TBcxv9wxFgH1
         oT0+vvVjZYE2sF+2X2WrdGA5ZsehZxeYcWSOBLoESt1xQGbILkeATYGsitf7gQ9eF1p5
         Wyeyc4Dg9EOhn0ymnBLVg7G9l/4zgu5YHHB6wQTOXPKw2eb+Q+HuSDNBXS1ptpnkRZAP
         GoviBCe5DS3UJ1quPXv1jQQxwTkUcuJCshD4DX7s4n4V2cpDSmBmprF2JATv7OLU+fBX
         JtlQ==
X-Gm-Message-State: AOJu0Yyf4Ujd/VGNJs5MogbO2SOn24th8O+PMokTdd0edvQ3VSs5n5Cr
	j9UqVeudLhay/IrV/88v3vk=
X-Google-Smtp-Source: AGHT+IELs7Z3Qgdb0kPj7kMQLbLRGaj2RW9exSA+VyXP8PRR+A3e7h6usNjnFGoBSW1O3lymxfyFrg==
X-Received: by 2002:a05:6808:10ca:b0:3a7:71fd:57cc with SMTP id s10-20020a05680810ca00b003a771fd57ccmr433118ois.12.1691609933593;
        Wed, 09 Aug 2023 12:38:53 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f31-20020a17090a702200b00267ee71f463sm4414336pjk.0.2023.08.09.12.38.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 12:38:53 -0700 (PDT)
Message-ID: <4db69d01-0325-213e-ae62-a375e064a8e4@gmail.com>
Date: Wed, 9 Aug 2023 12:38:47 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.15 00/92] 5.15.126-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230809103633.485906560@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230809103633.485906560@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/9/23 03:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.126 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.126-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

SCMI with the SMC transport fails to build because of "[PATCH 5.15 
11/92] firmware: arm_scmi: Fix chan_free cleanup on SMC" where the 
specific details have been reported there. Here is the build failure FWIW:

drivers/firmware/arm_scmi/smc.c:39:6: error: duplicate member 'irq'
   int irq;
       ^~~
drivers/firmware/arm_scmi/smc.c: In function 'smc_chan_setup':
drivers/firmware/arm_scmi/smc.c:118:20: error: 'irq' undeclared (first 
use in this function); did you mean 'rq'?
    scmi_info->irq = irq;
                     ^~~
                     rq
drivers/firmware/arm_scmi/smc.c:118:20: note: each undeclared identifier 
is reported only once for each function it appears in
   CC      drivers/mmc/core/slot-gpio.o
host-make[5]: *** [scripts/Makefile.build:289: 
drivers/firmware/arm_scmi/smc.o] Error 1
host-make[5]: *** Waiting for unfinished jobs....
-- 
Florian

