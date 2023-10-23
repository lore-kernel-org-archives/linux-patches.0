Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB48414281
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 19:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JW5+bxsD"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-27e4e41a4fcso950341a91.3
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 12:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698091011; x=1698695811; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=wc6K7DVSn4OJ7r3oQRSjAdBZCjLBaSJ+yDFvOsX+BDw=;
        b=JW5+bxsDG1GnPddv92XpyyXWGwxBStbMdTE1QLcTTVBn9cvzzjvVNm08SYAYuaS4yH
         uSpjhxKYyTfPFX3V8NR/1Fk20p8d6330NY3iUSnNA5trQR2Ex3MOFySJQpaLls7h8roQ
         gPeidI6HPp49cQikwZqdD51kSNlhjWCran7SqX2CNTMRHlE2wA8vr8EK2uE6DJAiUAgH
         h5Twz27B7Uc35X2/ms+/zK2KR6jUvNQydfKsqv7T8Gw6IJwkWJtUy/97gQnD4PYo4G65
         JvjVYVhB5lQtD5CetYWwNSYP6hq5ZbC3q293timX28ltlW+9s0L9mfPVDf5VgGPDOIlW
         PAfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698091011; x=1698695811;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wc6K7DVSn4OJ7r3oQRSjAdBZCjLBaSJ+yDFvOsX+BDw=;
        b=N/+v3Zmi7RFDg4oWMKGPpu5r7xU8odqHRDbD+kKg2u+2U++81ZsuDB7smbqqkh9ne4
         Mo3EsgCmWiB+UknbXrQekMqyqH3/q3ObrdE55fcqqnqnC8R8x/+ZbUS3N30X+CZF/czP
         fzXaIHA/mfhLDOcAo3yhVx6Gd+KA9peEaETbePGVzKxLCtDkmnzJchfwr8WlfSt3CLb3
         B+9pW3Eb0/mjPfV110ltYEvWxktmodZkQp41+a/jvivtlZm05/foSAvR63HLcxp+2Ek7
         t7tN1WjcUeiyOiKKlX8+iA+iGwWEfugOJL/5cA+gOZELkstXjxjy9IEvsvb4L4rBGg/K
         RBlg==
X-Gm-Message-State: AOJu0YzPdzrsEjOKwPd87Joa/nkPj1vTa/jpTdP9TkfhNGOjkprXjPvh
	GucHBJQWPX6DSq7m1I6ZCC4=
X-Google-Smtp-Source: AGHT+IFiOGCEgt/6NFMUK8O593DH6eSaJOZjIWQ05INXwwmBnsM/jdAeT1lwkl6CkuNceUr2bbsaZw==
X-Received: by 2002:a17:90a:194b:b0:27d:1ea0:bc84 with SMTP id 11-20020a17090a194b00b0027d1ea0bc84mr7132522pjh.34.1698091010803;
        Mon, 23 Oct 2023 12:56:50 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id mj7-20020a17090b368700b0026b70d2a8a2sm6049103pjb.29.2023.10.23.12.56.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Oct 2023 12:56:50 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <9737cd7b-f3c6-7e90-f92c-0ceeed788980@roeck-us.net>
Date: Mon, 23 Oct 2023 12:56:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 5.15 000/137] 5.15.137-rc1 review
Content-Language: en-US
To: Geert Uytterhoeven <geert@linux-m68k.org>,
 =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 Marc Zyngier <maz@kernel.org>
References: <20231023104820.849461819@linuxfoundation.org>
 <724521b8-9c63-4645-b3e0-30d9635573a7@linaro.org>
 <CAEUSe7-zbuRsgsr2EYq+OeW9iEJyZHmo8u9K3pDCAFRKnCEv0A@mail.gmail.com>
 <CAMuHMdXYB6QAE15RYs7eg9sVofesqNN1+vmPHkosqC_8A-JTSg@mail.gmail.com>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <CAMuHMdXYB6QAE15RYs7eg9sVofesqNN1+vmPHkosqC_8A-JTSg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/23/23 11:50, Geert Uytterhoeven wrote:
> CC maz
> 
> On Mon, Oct 23, 2023 at 7:17 PM Daniel Díaz <daniel.diaz@linaro.org> wrote:
>> On Mon, 23 Oct 2023 at 09:11, Daniel Díaz <daniel.diaz@linaro.org> wrote:
>>> On 23/10/23 4:55 a. m., Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 5.15.137 release.
>>>> There are 137 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>>        https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.137-rc1.gz
>>>> or in the git tree and branch at:
>>>>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>
>>> We see lots of errors on Arm 32-bits:
>>>
>>> -----8<-----
>>> /builds/linux/drivers/gpio/gpio-vf610.c:249:11: error: 'IRQCHIP_IMMUTABLE' undeclared here (not in a function); did you mean 'IS_IMMUTABLE'?
>>>     .flags = IRQCHIP_IMMUTABLE | IRQCHIP_MASK_ON_SUSPEND
>>>              ^~~~~~~~~~~~~~~~~
>>>              IS_IMMUTABLE
>>> /builds/linux/drivers/gpio/gpio-vf610.c:251:2: error: 'GPIOCHIP_IRQ_RESOURCE_HELPERS' undeclared here (not in a function)
>>>     GPIOCHIP_IRQ_RESOURCE_HELPERS,
>>>     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>> /builds/linux/drivers/gpio/gpio-vf610.c:251:2: warning: excess elements in struct initializer
>>> /builds/linux/drivers/gpio/gpio-vf610.c:251:2: note: (near initialization for 'vf610_irqchip')
>>> /builds/linux/drivers/gpio/gpio-vf610.c: In function 'vf610_gpio_probe':
>>> /builds/linux/drivers/gpio/gpio-vf610.c:340:2: error: implicit declaration of function 'gpio_irq_chip_set_chip'; did you mean 'gpiochip_get_data'? [-Werror=implicit-function-declaration]
>>>     gpio_irq_chip_set_chip(girq, &vf610_irqchip);
>>>     ^~~~~~~~~~~~~~~~~~~~~~
>>>     gpiochip_get_data
>>> cc1: some warnings being treated as errors
>>> ----->8-----
>>
>> Bisection points to "gpio: vf610: make irq_chip immutable" (upstream
>> commit e6ef4f8ede09f4af7cde000717b349b50bc62576).
> 
> IRQCHIP_IMMUTABLE was introduced in commit 6c846d026d490b23 ("gpio:
> Don't fiddle with irqchips marked as immutable") in v5.19.
> Backporting (part of) that is probably not safe.
> 

In this context: What exactly does commit e6ef4f8ede09 fix that makes it
a stable release candidate ?

Outch, I realize I am violating the new "no more than 15 quoted lines"
rule. Sigh.

Guenter

