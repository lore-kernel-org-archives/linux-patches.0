Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1778746F
	for <patches@lists.linux.dev>; Wed, 30 Aug 2023 16:01:15 +0000 (UTC)
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-79275d86bc3so200386839f.0
        for <patches@lists.linux.dev>; Wed, 30 Aug 2023 09:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693411275; x=1694016075; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=a0lynSDcK/MXZGjR4De6oBFmLDHnkmxoSqFwHMUU6wM=;
        b=fTuPMXdZGdVDA0T37b0X6faBxtivqq9NrjBXZw9gyTGqTlua4E7JZaHISG3a5O4dOX
         +B3id9YG9lahHLIzwZ8Kb1n96iMePaX4QnM9v5q2QllLD68U4qC0mjaoB8V4eFtfpgFQ
         SIYjPb1WswhCr0rWTyxdkwzw3qJ42AuL4cgUC/zl2mzj5cdVmLYuKLN7hnvQgjVdvZwh
         tApaNBI4nJ/YNSk+Wy46+5+RuwChaY/A9iZ2EuMbN1lauZ5ld4R5/33TLY7JHKUFbPfl
         xEAqnPlV+OhSMr5Ey5+PfJXprwuC9fITj8S2wCK67nMGgnfJYD7xF7JR7H3PSHgZp7he
         sC4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693411275; x=1694016075;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a0lynSDcK/MXZGjR4De6oBFmLDHnkmxoSqFwHMUU6wM=;
        b=Qs6CX+SaR5PlE4cNOzJCwiff36wcqg0WZLD8q86rX9f9h6EohlsuRNEhFlManojSaV
         LzsPRIq8mlwcPjtUkLtnwjMOkTKyjDfFF0IIC12p6AAdtmJfXMGBwMUA+wdClEv2nqmU
         AWsu7za7069YIBRaVBjSlPQzlwyXXcjF6J1ZB5LX+5IM9ppvsYxgbdQVfLf+Wg0uHDzg
         XWDOQ7rvvsaw1AHNthmgvJOgWNdjpBeLSH+pgiEIvHspc9Ivbbcl9YniMt5dfJUFJzJS
         Dw5O5/RKGzAwaafdhBA53k3h9a4XZEq6jkW4JNgR+uA8Tqge1+ky8PlUftzv5xolw/PP
         omTA==
X-Gm-Message-State: AOJu0YzWn3rbWJ1dTy/OeKorwqiEtWDyiVLc7TZUwDW386gB05kGEegI
	LWOjECm216PjnD8skuZfKFc=
X-Google-Smtp-Source: AGHT+IFzA/jm06wu9XBZD9WV48KxFNNwIokByQmj7lSAa+tgEyR2kaWks0wCGP/f5dB32IdG6oNW0A==
X-Received: by 2002:a6b:e801:0:b0:783:572c:9caa with SMTP id f1-20020a6be801000000b00783572c9caamr3291689ioh.0.1693411274776;
        Wed, 30 Aug 2023 09:01:14 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n3-20020a6b5903000000b0077e40979b41sm4012584iob.45.2023.08.30.09.01.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Aug 2023 09:01:14 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <64374066-4086-3e92-8650-ab1563350f0c@roeck-us.net>
Date: Wed, 30 Aug 2023 09:01:12 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.10 00/84] 5.10.193-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>
References: <20230828101149.146126827@linuxfoundation.org>
 <5b30ff73-46cb-1d1e-3823-f175dbfbd91b@roeck-us.net>
 <2023083014-barley-upscale-518e@gregkh>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <2023083014-barley-upscale-518e@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/30/23 03:52, Greg Kroah-Hartman wrote:
> On Mon, Aug 28, 2023 at 09:42:11AM -0700, Guenter Roeck wrote:
>> On 8/28/23 03:13, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.10.193 release.
>>> There are 84 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
>>> Anything received after that time might be too late.
>>>
>>
>> FWIW, commit 619672bf2d04 ("MIPS: Alchemy: fix dbdma2") should be reverted
>> v5.10.y since it doesn't fix anything but breaks the build for affected boards
>> completely.
>>
>> arch/mips/alchemy/common/dbdma.c: In function 'au1xxx_dbdma_put_source':
>> arch/mips/alchemy/common/dbdma.c:632:14: error: 'dma_default_coherent' undeclared
>>
>> There is no 'dma_default_coherent' in v5.10.y.
> 
> But that was added in 5.10.185, from back in June.  What changed to
> suddenly cause this to fail now?
> 

Nothing. I started to build this configuration and tracked down the
problem after the build failure was reported by others. Sorry, I didn't
initially realize that this is an old problem.

Guenter

