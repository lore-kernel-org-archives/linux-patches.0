Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C0F11C88
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 14:54:09 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1c06f6f98c0so7085645ad.3
        for <patches@lists.linux.dev>; Thu, 31 Aug 2023 07:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693493649; x=1694098449; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tEC87zX549E+U9vV1oszlAIcg0x95pSsoYr9+gGAPGg=;
        b=Pk1BX/1OnMJqQz5ir9wtiIC5kY2Iv9U9+DCtR/k2QrMIHK8tXnQcVdqBic056cxVJY
         oDFutb6XIoqwWm8C0oqOhTROSSNKYa92DtycEHuIEGpBYLJ2dgoZNbAc9v/E4LYT8Tqn
         ze9sk/w5geR1VBYSo48bCETew0+Gx+3sscooFGMEH6WEQDKJpixoy1AKc0UZx96Mfrfc
         yQ/ky0fVcpS3Xd0kOJ3so4l9rNv0jqJdScVVwUAYTd/VKMKhgVUoX2cXr4Z0DfFioWpk
         bo5IamFdgOSYDqXin6m0qhv7ppsw2FN1/FBPU5nK/Cko/XsUPbt0AMhn3u6R0P3FHJtp
         UDEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693493649; x=1694098449;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tEC87zX549E+U9vV1oszlAIcg0x95pSsoYr9+gGAPGg=;
        b=bIw6ZhbKhn2LgErueLeZgGjXAKVoRFdBIoCVcycnkFAkDoVgBhJw4z5n1DfRLoHFgk
         ePCmp193Q12V1eyFo5kA2jCVzGjntoTxlBaNwha1WWOPv9capqRAs1yYPHEi4Xatw3wy
         gLMdh7baIPpbk7vorZoIUcugFNui0CpWTSyWgTIocb2WC5ysk94gME02HCWp0VfB36X0
         TS3x08+/o16872fq7FPNLKbudsS6uXEeKLJFrl2UPrihFbja/xwy/wl8y31QyM3PdAaB
         /UPcLt48S73e10EQV41iuQXwZK8D7xWhSVCNHfenZW6ZcZVRDANP8ljkyMwhD0X3qFFA
         2mdA==
X-Gm-Message-State: AOJu0YwKL9vsZuEuk0zPdbUkzPbHB2Rb+fDVzb6W2qv8iP/AUvcJgU5S
	vAtlBx58E3OcDVK7GPmTU14=
X-Google-Smtp-Source: AGHT+IFif2uVPz+tA6oL7Hzvt2UjKSQ9canwj2E14FUfSGqTe6utdnK5JoLTrBnjrZkAGA3TVO+A1g==
X-Received: by 2002:a17:903:11c5:b0:1bb:c06e:647a with SMTP id q5-20020a17090311c500b001bbc06e647amr5915734plh.53.1693493649066;
        Thu, 31 Aug 2023 07:54:09 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:f5ca:eebd:7e8f:7734? ([2600:8802:b00:4a48:f5ca:eebd:7e8f:7734])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b001bb1f0605b2sm1357534plg.214.2023.08.31.07.54.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Aug 2023 07:54:08 -0700 (PDT)
Message-ID: <4a69c0c0-5e8a-9a3a-6527-3eb7e51a955e@gmail.com>
Date: Thu, 31 Aug 2023 07:54:06 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH 5.10 00/84] 5.10.193-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Manuel Lauss <manuel.lauss@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, stable <stable@vger.kernel.org>,
 patches@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org,
 Pavel Machek <pavel@denx.de>, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, Thomas Bogendoerfer <tsbogend@alpha.franken.de>
References: <20230828101149.146126827@linuxfoundation.org>
 <5b30ff73-46cb-1d1e-3823-f175dbfbd91b@roeck-us.net>
 <2023083014-barley-upscale-518e@gregkh>
 <64374066-4086-3e92-8650-ab1563350f0c@roeck-us.net>
 <95baa835-9940-a257-cf96-93c543aa389f@gmail.com>
 <CAOLZvyEuj=93tpObwDgyAK01Jyz8NfXQzJfAX5=vVwG1wxo-cA@mail.gmail.com>
 <2023083138-frustrate-race-9264@gregkh>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <2023083138-frustrate-race-9264@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/31/2023 3:31 AM, Greg Kroah-Hartman wrote:
> On Wed, Aug 30, 2023 at 07:38:09PM +0200, Manuel Lauss wrote:
>> Hello all,
>>
>> Florian Fainelli <f.fainelli@gmail.com> schrieb am Mi., 30. Aug. 2023, 19:07:
>>>
>>> + Manuel,
>>>
>>> On 8/30/23 09:01, Guenter Roeck wrote:
>>>> On 8/30/23 03:52, Greg Kroah-Hartman wrote:
>>>>> On Mon, Aug 28, 2023 at 09:42:11AM -0700, Guenter Roeck wrote:
>>>>>> On 8/28/23 03:13, Greg Kroah-Hartman wrote:
>>>>>>> This is the start of the stable review cycle for the 5.10.193 release.
>>>>>>> There are 84 patches in this series, all will be posted as a response
>>>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>>>> let me know.
>>>>>>>
>>>>>>> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
>>>>>>> Anything received after that time might be too late.
>>>>>>>
>>>>>>
>>>>>> FWIW, commit 619672bf2d04 ("MIPS: Alchemy: fix dbdma2") should be
>>>>>> reverted
>>>>>> v5.10.y since it doesn't fix anything but breaks the build for
>>>>>> affected boards
>>>>>> completely.
>>>>>>
>>>>>> arch/mips/alchemy/common/dbdma.c: In function 'au1xxx_dbdma_put_source':
>>>>>> arch/mips/alchemy/common/dbdma.c:632:14: error:
>>>>>> 'dma_default_coherent' undeclared
>>>>>>
>>>>>> There is no 'dma_default_coherent' in v5.10.y.
>>>>>
>>>>> But that was added in 5.10.185, from back in June.  What changed to
>>>>> suddenly cause this to fail now?
>>>>>
>>>>
>>>> Nothing. I started to build this configuration and tracked down the
>>>> problem after the build failure was reported by others. Sorry, I didn't
>>>> initially realize that this is an old problem.
>>>
>>> We could back port 6d4e9a8efe3d59f31367d79e970c2f328da139a4 ("driver
>>> core: lift dma_default_coherent into common code") but that won't work
>>> too well on 4.14 or 4.19. I believe it would be simpler to adjust the
>>> branches with this patch, Manuel does that work?
>>
>> Please drop this patch from all stable releases. I didn't CC stable
>> when I submitted it,
>> and have no idea why it ended up there anyway.
>> It was intended to fix a problem initially found in 5.18 (I think).
> 
> I'm going to revert it now, thanks!

I prepared reverts yesterday that I can send out if you want?
-- 
Florian
