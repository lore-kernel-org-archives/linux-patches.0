Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4E8FC1D
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 14:39:57 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so836737a12.1
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 07:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685630397; x=1688222397;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=vAtDJ4UZJBm7+uLnpiZVzFRiwuCQbc5zdoMX8rHHbbU=;
        b=qt7Q1bUpshWH93RKlnxUNBqecIEtKUcuPoKkhnCZxE2gPC4w/HAKWUFxEhX0tLVXUe
         S8jOYv048Br31vztTF78G6zqhLr8ZEPx5/MKGpurvWErugkg8dzfAeAbWdJ76CQksWXA
         CU9Tv319FOi24XK7aa4QW3qGckz/P6VC3W1qVM3iwms5RpwRVU63bVis1PVsnpvXKrem
         edL1YH8fqp3jMwPd8JW7/49rfG68WADIhR6IW6rdnueZ6RtHH4sV2CrJH8ytApV6AGtg
         sHaN2TVVIq71aSbOvo6wPhcghG2/LZyY8TkSYspa7TsfklM65Mrm3PEcsA9ZbAsaX336
         Orxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685630397; x=1688222397;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vAtDJ4UZJBm7+uLnpiZVzFRiwuCQbc5zdoMX8rHHbbU=;
        b=cz894RrImY2uq/9WD4pOMatKporrx9z/v5VZFcPWIb1tiJ1thDiAILEznGxUpU4YZD
         IrnwIA+Bz9VardlbicPGQ8HsEohaEOLrV55BAdQSfJOFJpB5fCxyTfNJLGwN3AhwZ87U
         v4izdBrzVwsYOYc6YaPzLYFz3tASCKoXH3gOlvVld6zIBXafJs4ZhvF5hK+ykbu2qSIN
         OgSVrwKbC62p7AoEjGPLpSAYAKe29n9KAMJh03Qxb7g013K7dNSKJ2qdTusoBTY/F5xj
         C6/SMkCr2k/In3ctlqf9qQTXngzHDKKjRPuYHKIBaPPsvSUzEaMBO8Y8kxRH3p6I8zeY
         6Mcg==
X-Gm-Message-State: AC+VfDwPw5U1PR4CWZ2WSjNRtWB8ctN3Qc7a/K68A+w23q2HBshpPAB3
	c/y+zCEJf5br88YF+ojyeWc=
X-Google-Smtp-Source: ACHHUZ6Jv02LlEGCNcPy0HmfO3xCPRrdohvyHO41n2g1iUckmlF9UBgI5AF/WMluGfIiSqOD4lOFXQ==
X-Received: by 2002:a05:6a20:604:b0:110:9210:f6b8 with SMTP id 4-20020a056a20060400b001109210f6b8mr7456893pzl.35.1685630396922;
        Thu, 01 Jun 2023 07:39:56 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m15-20020aa7900f000000b0064d6b6aac5dsm5143732pfo.73.2023.06.01.07.39.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 07:39:56 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <e7f9cbd1-f19d-2f08-8876-45163910ad93@roeck-us.net>
Date: Thu, 1 Jun 2023 07:39:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.1 00/42] 6.1.32-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20230601131939.051934720@linuxfoundation.org>
 <CA+G9fYuHjNhe-5TboAbrOeZrL3xL-CYYSaEnL=8onebLUqDt8g@mail.gmail.com>
 <2023060101-coconut-smugness-4c7a@gregkh>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <2023060101-coconut-smugness-4c7a@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/1/23 07:26, Greg Kroah-Hartman wrote:
> On Thu, Jun 01, 2023 at 07:41:08PM +0530, Naresh Kamboju wrote:
>> On Thu, 1 Jun 2023 at 18:57, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>>
>>> This is the start of the stable review cycle for the 6.1.32 release.
>>> There are 42 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat, 03 Jun 2023 13:19:19 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>          https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.32-rc1.gz
>>> or in the git tree and branch at:
>>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>>
>> Following build errors noticed on 6.1 and 5.15.
>>
>> drivers/dma/at_xdmac.c: In function 'atmel_xdmac_resume':
>> drivers/dma/at_xdmac.c:2049:9: error: implicit declaration of function
>> 'pm_runtime_get_noresume' [-Werror=implicit-function-declaration]
>>   2049 |         pm_runtime_get_noresume(atxdmac->dev);
>>        |         ^~~~~~~~~~~~~~~~~~~~~~~
>> drivers/dma/at_xdmac.c:2049:40: error: 'struct at_xdmac' has no member
>> named 'dev'
>>   2049 |         pm_runtime_get_noresume(atxdmac->dev);
>>        |                                        ^~
>> cc1: some warnings being treated as errors
>>
>> reported link:
>> https://lore.kernel.org/stable/CA+G9fYswtPyrYJbwcGFhc5o7mkRmWZEWCCeSjmR64M+N-odQhQ@mail.gmail.com/
>>
>> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Ah, the .h file was added by 650b0e990cbd ("dmaengine: at_xdmac: add
> runtime pm support"), which isn't needed here.  I'll go add it by hand

Really ? Some of the dma patches seem to fix runtime pm support, and
"dmaengine: at_xdmac: disable/enable clock directly on suspend/resume"
is even tagged with

Fixes: 650b0e990cbd ("dmaengine: at_xdmac: add runtime pm support")

Why do we need to fix code which isn't present in 6.1.y ?

Guenter

> and push out some -rc2 releases for this and 5.15.y, thanks!
> 
> greg k-h

