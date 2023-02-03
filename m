Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA6679C6
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 15:51:22 +0000 (UTC)
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-142b72a728fso7073564fac.9
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 07:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IK6isyKHVl+ukxzyYdmFd+ltn6OU3spgEFoTeGzWtKY=;
        b=RzRYmChixrro+XXjPnRj22WOQGgXV1aSazeKDi5It479Nnz5GC1ZI+4u40rt3M4MCQ
         NHKfvBdm/WNHw0Nmjr5ik2mgrTpEDdznGueoIZ6l+5OwzL++sDwVmP5X2mrqUz1iJ5rJ
         o/MsjSEv9rUM12DnQtsmqMJsMrM3ibE52YxV0t+xSSY9VlQP0z1lWLSM8mKFhMiff/la
         83T/kV/2J9K1erdO4mtdO3A1YNthVPO8r2veQMGH6cdxJ+c88NEaWOm9eVsoZ2HkIjiP
         g6smtqabWwzrQ9cogtupDqkKd9eYPXr5jSDAZ9oY2tn03Vel9dMY6lfZJeGDaKQLR/fJ
         tZkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IK6isyKHVl+ukxzyYdmFd+ltn6OU3spgEFoTeGzWtKY=;
        b=hJDd+VSMY40x4hqnr/CTAYLTQvMgTB97+R25X+LOxh9fZCuhHlKTbdXs2oJxDJCjaD
         rYbBjypVQETzxP/36/s025Q+d6D7RhKNflhg1O+SvWK8Z3uS/q6CuHsIkrzTqsTfTytx
         +79jKjR3lDIeeiRVlRSXC3LzYMCmj0PVt29AeSxOWz2vcHKy/2sg+l4vg2LPIM4SfhtN
         rO5wYLuSdbRJvHKHYJxQfoEV8I21U/TGKwUxra+fPrxBVAK4rWu+uwHKDHfRoaES3fP2
         VzUHkPShzrZkVsVxCDcFHNvNGTZA+sEnKQDjvoE7Qea7hBajcd20c+L6rawRgf8aEWV9
         No/A==
X-Gm-Message-State: AO0yUKUsLoxy2YTsbLytote78nBzGFa4mNCiirFRkeSpbRe3Cebbcboy
	YXXEQxNKr7g2KbyWnKr2R34=
X-Google-Smtp-Source: AK7set+VlhBh9rvzj1I7nWfKRfrwsnMZOBDegZcQS4Gyf+gDfh/RGhnk9JMeGaRyssOYlc6ALtFI3w==
X-Received: by 2002:a05:6870:414b:b0:163:a45a:9e34 with SMTP id r11-20020a056870414b00b00163a45a9e34mr5960269oad.31.1675439481097;
        Fri, 03 Feb 2023 07:51:21 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w1-20020a4a2741000000b004f269f9b8f3sm540579oow.25.2023.02.03.07.51.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 07:51:19 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <4e5a447b-1796-513c-135a-f9e9c870d88a@roeck-us.net>
Date: Fri, 3 Feb 2023 07:51:17 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 Naresh Kamboju <naresh.kamboju@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Gaosheng Cui <cuigaosheng1@huawei.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20230203101015.263854890@linuxfoundation.org>
 <CA+G9fYvd8D3LfxPg2afZXKFC3WNHrhyE7c3fFLViaG4WhJeHVg@mail.gmail.com>
 <5ed630fd-8bd7-4b80-9fa8-a3dab2eb0447@linaro.org>
From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 4.19 00/80] 4.19.272-rc1 review
In-Reply-To: <5ed630fd-8bd7-4b80-9fa8-a3dab2eb0447@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/3/23 04:28, Krzysztof Kozlowski wrote:
> On 03/02/2023 12:04, Naresh Kamboju wrote:
>> On Fri, 3 Feb 2023 at 15:48, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>>
>>> This is the start of the stable review cycle for the 4.19.272 release.
>>> There are 80 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>          https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.272-rc1.gz
>>> or in the git tree and branch at:
>>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> Following patch caused build error on arm,
>>
>>> Gaosheng Cui <cuigaosheng1@huawei.com>
>>>      memory: mvebu-devbus: Fix missing clk_disable_unprepare in mvebu_devbus_probe()
>>
>> drivers/memory/mvebu-devbus.c: In function 'mvebu_devbus_probe':
>> drivers/memory/mvebu-devbus.c:297:8: error: implicit declaration of
>> function 'devm_clk_get_enabled'
>> [-Werror=implicit-function-declaration]
>>    297 |  clk = devm_clk_get_enabled(&pdev->dev, NULL);
>>        |        ^~~~~~~~~~~~~~~~~~~~
> 
> Already reported:
> https://lore.kernel.org/all/202302020048.ZsmUJDHo-lkp@intel.com/
> 

I don't usually check if release candidate reports have been reported already.
If I know about it, I may add a reference to the report, but typically I still
report it.

Personally I find it discouraging to get those "already reported" e-mails.
To me it sounds like "hey, you didn't do your job properly". It should not matter
if a problem was already reported or not, and I find it valuable if it is
reported multiple times because it gives an indication of the level of test
coverage. I would find it better if people would use something like "Also
reported:" instead. But then maybe I am just oversensitive, who knows.

Anyway, yes, I noticed this problem as well (and probably overlooked it
in my previous report to Greg - sorry for that).

Thanks,
Guenter

