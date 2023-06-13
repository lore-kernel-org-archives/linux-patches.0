Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598EA38CA4
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 18:01:23 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1b3c0c476d1so24224765ad.1
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 11:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686679282; x=1689271282;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=T/a3r5sKbhzcbRyUYdob5Nl5dKbRVOL3UiqhaaSpST4=;
        b=B6nGrki7dC4POqaR5IBxM33VDnBBh6hQssOvi3oTmV1FtbtGlyf/oH/GrKPfyyMN39
         DysgEThI0bkvujQPvKr3Rk0cwrbhwQ1MgnyA8JmeLHOqK/RXVqucEmohMBUbNvKO6kOC
         XZ3vgysp+C/iWYuS1c8FqYgeDBeHqeF2kvmcFZmAhZbDeKR92VNlB7htxTP6VM6V3GpN
         wZIlREJxiAudVkeXHYz6hglcTFPIyT1Kgcj9sPYD9FFDgGjrsAoemGeT81K4JEBexbcT
         YIz4I8QAmbZn7HcOYtXXTiz9Ew7co96YRYqpZqucUV9Enp0c9xvihLKkHjcIbxXDyP0N
         k5PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686679282; x=1689271282;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T/a3r5sKbhzcbRyUYdob5Nl5dKbRVOL3UiqhaaSpST4=;
        b=dPdeljqnhmymoLMNuuhMsPsDRuKTqF0k6fU8GnC1y3xzbJh9eWirtX3p1TY/HCZfFC
         pQ0YZ8p4r60KMvIt1ZNejCO36s5zfGua8+5hVEVdym0aAqe1F1NDXuH3wMXrKe+HJKfu
         U1WMlblA6n1rsVt3ZZWItHuYD7cWgh9JNPt1B0NUIQpCsgVpLBH2XCa0J8HfSWIvfpnS
         XBxohhvsGyJaw5ove8TfieeWX2vfLrhvFY6MbOSyrGAF4s3YARYTcg7rGpXTLgVuRpFy
         sdXTqhO+/L9XWpmTdrzQwRY4119t+cJqbY78Nsx0pJcWeNM0g2oWxqJDNqYGfsPOqTUD
         ABaQ==
X-Gm-Message-State: AC+VfDzU4uP4Y2So8m52GEPjJn67z7aN/zxmJGPNC5Ys78N1VKGYaTQl
	aEV3yJungMF30fQdMKXnW2Y=
X-Google-Smtp-Source: ACHHUZ4nDCJfmPpznJna2xSkhH384iiKUB8svBrHAmcq/f5IuT5ldnsId6M4h29uvNbu8gE2E0MgPw==
X-Received: by 2002:a17:902:e752:b0:1b0:6038:2982 with SMTP id p18-20020a170902e75200b001b060382982mr12451026plf.41.1686679282498;
        Tue, 13 Jun 2023 11:01:22 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k5-20020a170902ba8500b001ae5fe602c3sm10546479pls.159.2023.06.13.11.01.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 11:01:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <0a725f74-d077-8556-6e55-25f55dfc95ff@roeck-us.net>
Date: Tue, 13 Jun 2023 11:01:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.10 00/68] 5.10.184-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20230612101658.437327280@linuxfoundation.org>
 <ab4e5232-ccc4-144a-cb72-2a0cce825f31@roeck-us.net>
 <2023061300-cardstock-buckshot-0ccc@gregkh>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <2023061300-cardstock-buckshot-0ccc@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/13/23 10:36, Greg Kroah-Hartman wrote:
> On Tue, Jun 13, 2023 at 09:35:37AM -0700, Guenter Roeck wrote:
>> On 6/12/23 03:25, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.10.184 release.
>>> There are 68 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
>>> Anything received after that time might be too late.
>>>
>>
>> Am I the only one seeing this problem ?
>>
>> Build reference: v5.10.183-69-g32cae866b182
>> Compiler version: x86_64-linux-gcc (GCC) 11.3.0
>> Assembler version: GNU assembler (GNU Binutils) 2.39
>>
>> Building x86_64:allyesconfig ... failed
>> --------------
>> Error log:
>> x86_64-linux-objcopy: vmlinux: unsupported relocation type 0x44
>> x86_64-linux-objcopy: vmlinux[.text]: relocation count is negative: bad value
>> make[3]: *** [arch/x86/boot/compressed/Makefile:114: arch/x86/boot/compressed/vmlinux.bin] Error 1
>> make[3]: *** Waiting for unfinished jobs....
>> Unsupported relocation type: unknown type rel type name (-1939958716)
>> make[3]: *** [arch/x86/boot/compressed/Makefile:122: arch/x86/boot/compressed/vmlinux.relocs] Error 1
>> make[3]: *** Deleting file 'arch/x86/boot/compressed/vmlinux.relocs'
>> make[2]: *** [arch/x86/boot/Makefile:115: arch/x86/boot/compressed/vmlinux] Error 2
>> make[1]: *** [arch/x86/Makefile:274: bzImage] Error 2
>> make: *** [Makefile:192: __sub-make] Error 2
>>
>> It affects 5.4.y and 5.10.y for me.
> 
> Odd.  Let me go build with gcc-11, I have just moved to gcc-12 on those
> two branches locally...
> 

Don't bother. This seems to be related to my build environment, not to the kernel.
Rebuilding passed on different servers. It may have to do with my recent update
to Ubuntu 22.04 on the server experiencing the problem. I'll try to figure out
what is going on.  Sorry for the noise.

Guenter

