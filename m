Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954258820
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 22:51:56 +0000 (UTC)
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3a1a47b33d8so1815360b6e.2
        for <patches@lists.linux.dev>; Fri, 30 Jun 2023 15:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688165515; x=1690757515;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s0DLJtIFkdaIm3EidvG6OQVVTyxJT0X48wGGYbh5HAw=;
        b=EXn+3tWSnFQ5GY6rP7GE9JMHCvrLOm+cLngXDgMJmXI0Ln4fgaMo3X+NBorR656w7O
         aevcccY+g/mmU3fLA/JpJRR3QQeW1SAHBtHvQZUAZ1owSD76HywJxmLYl0IiIyZCrG6r
         OcxquBB7yJU14hr9mKJ90AfPCsytIQZ/rUQcJvca+gtBLqCw8G9uiuckCJaYGLd9syrp
         v2unNgJHHVgzAL456iazwwB6n4xx0BjKQpx3WNcN377XTpY4U8cMJ5GESFF3hqh/WyFL
         /Sx4NCIWWbQKBxqPVU0VrKPxSMJdAMVTZen6eEuPA4jhK+LheD7b1j0wptKrkABctnBh
         6eCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688165515; x=1690757515;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s0DLJtIFkdaIm3EidvG6OQVVTyxJT0X48wGGYbh5HAw=;
        b=ZVl0K46yQUndT6UYaYlecgrrrT/uF1DYw74oLJMva9Pda8FfKi4l3H2CTXxe0k7cj9
         SKVGsRRqCXtbKmKgY8eSlTzlT3cID4J1DfbX51C0hTe7UOj/EWCTUGrWE4iRah5jWMCA
         /mo8vOBy6p0ulRe5o1KNPe1wObgLHK4lCichGO2TVg2gHNr5AbiFILWTJnd4Eu2bqVq7
         ax8trVIf3lpaAvW3DIyqm9Rc1qyzD50PUX/xVMW1i6vPQ1+XBdmeLry4VQkdGXFwnu3E
         G3bC7i1c/yi17cId5pbhS9TSbYtje6fpPxVcmOS5yGB9Rw1bAYs3EV4iVeW5HC2c0C6h
         NKEw==
X-Gm-Message-State: AC+VfDxDPCI0lt0dwNKhBgts8Wjkqlbr3LOoMRV6tfU8z2hL3myDA6OD
	fVeVffbft6IMyAGMrQt2rVs=
X-Google-Smtp-Source: ACHHUZ6c1GxefJyh3YrPniRtPAxf2uGw39aCAcbKu4NKgfYjiSxuM45CpYSbWVnkfDi5uUblP2rUSw==
X-Received: by 2002:a05:6808:318:b0:3a0:83cf:1d82 with SMTP id i24-20020a056808031800b003a083cf1d82mr3974942oie.22.1688165515388;
        Fri, 30 Jun 2023 15:51:55 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x14-20020a056a00270e00b005d22639b577sm6437968pfv.165.2023.06.30.15.51.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jun 2023 15:51:54 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <fb63ea7b-c44b-fb1b-2014-3d23794fa896@roeck-us.net>
Date: Fri, 30 Jun 2023 15:51:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, linux-parisc
 <linux-parisc@vger.kernel.org>, sparclinux@vger.kernel.org,
 Stephen Rothwell <sfr@canb.auug.org.au>, Helge Deller <deller@gmx.de>,
 Jason Wang <wangborong@cdjrlc.com>
References: <20230629184151.888604958@linuxfoundation.org>
 <CA+G9fYsM2s3q1k=+wHszvNbkKbHGe1pskkffWvaGXjYrp6qR=g@mail.gmail.com>
 <CAHk-=whaO3RZmKj8NDjs4f6JEwuwQWWesOfFu-URzOqTkyPoxw@mail.gmail.com>
 <fbe57907-b03f-ac8c-f3f4-4d6959bbc59c@roeck-us.net>
 <CAHk-=wgE9iTd_g20RU+FYa0NPhGSdiUDPW+moEqdHR4du1jmVA@mail.gmail.com>
 <CAHk-=wiN5H-2dh2zCo_jXE7_ekrxSHvQcMw4xfUKjuQs2=BN4w@mail.gmail.com>
From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 6.4 00/28] 6.4.1-rc1 review
In-Reply-To: <CAHk-=wiN5H-2dh2zCo_jXE7_ekrxSHvQcMw4xfUKjuQs2=BN4w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/29/23 23:47, Linus Torvalds wrote:
> On Thu, 29 Jun 2023 at 23:33, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Oh well.  We'll get them all. Eventually. Let me go fix up that csky case.
> 
> It's commit e55e5df193d2 ("csky: fix up lock_mm_and_find_vma() conversion").
> 
> Let's hope all the problems are these kinds of silly - but obvious -
> naming differences between different architectures.
> 
> Because as long as they cause build errors, they may be embarrassing,
> but easy to find and notice.
> 
> I may not have cared enough about some of these architectures, and it
> shows. sparc32. parisc. csky...
> 

There is one more, unfortunately.

Building xtensa:de212:kc705-nommu:nommu_kc705_defconfig ... failed
------------
Error log:
arch/xtensa/mm/fault.c: In function ‘do_page_fault’:
arch/xtensa/mm/fault.c:133:8: error: implicit declaration of function ‘lock_mm_and_find_vma’

This affects all stable release candidates as well as mainline.
mmu builds are fine, and indeed lock_mm_and_find_vma() is only declared
for CONFIG_MMU. I don't know if this needs a dummy or some other fix
for the nommu case.

Guenter

