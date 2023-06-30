Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EC81FBE
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 06:33:46 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5577004e21bso663434a12.2
        for <patches@lists.linux.dev>; Thu, 29 Jun 2023 23:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688106826; x=1690698826;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=Op+LKHdU8y6N81Sx3p49AtLoiunnk8w8S7c7wKh9jA8=;
        b=Fud52Gyt0Pw0U36m4wnLQikKHxgKZ5lKjwasT55fGnEfOZsygxtTYqMwQW8Maa/i+R
         vFg1fiSg083NfMFlJZ3l7LOZ5CTLNL+9Z9TH/uAhW3EJxeGzNO4+Q0OjuMWJ3N1Dzpc9
         YKHEMCHg4pQE68Ygj4Ef4q7+EtETmZkJHLRRnRLl8XS6k1O6mGI4xoURAXFCtIG3GQYs
         kcBtPVNWLkeZ9Az7TMWaJnnlM5HNJzXHbJuBiEFOXZK4qnmSa1xkAtDTRuFIjmUbXNd+
         JYGB++MOGMk64r/K0iy/EoO/NCJ5EML4S5tCBRpyfsUGP921cuDTASzmTmo8bX250oc/
         xyPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688106826; x=1690698826;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Op+LKHdU8y6N81Sx3p49AtLoiunnk8w8S7c7wKh9jA8=;
        b=l/2gRoFlnWMnJFECRtUa9piZKMEyjxgj4VzAt7ApTSAuYZ7t9zYHmjZnSPye6O9jpl
         V4QKJYZlr6oSJwRcuxJoaaNVt5IedPfadl8vanAsnKwmwoS+Pj6l7sCT4SaBuGS2kIoa
         SmA4Ir6Km2jASdFW9ruqGyYiIGBCSAFXRSH66NeyQAwrz2lB6vIEAkZMZ1ycPg1Uo46M
         S4Pqky7+VxitCQzqysCrrD6gB4WzK+CmBz22Y1tkeo55N1rpn+B5ZPsgSWdWDkd3lJi9
         5F0KPtBd0EyuWBlc+VuyywP0jpgbfdXRsRjLhBlo5so8NsisoxsoomwsXLBq10aUNHV4
         buqQ==
X-Gm-Message-State: AC+VfDzGMQtqHL7fXR9/5EDnD9anET41fR4crsKmFLAa5vEwfvOjVgjK
	hbl6kaxAIcIwbKGi36meo/0aF7qFxn0=
X-Google-Smtp-Source: ACHHUZ6Q7+FNMCvbGV1gPuYq4+R0G2xSzIlfo9GmRlY8BZ3lGwlU/9BxAGLWn8DYRWsnySts1anV2A==
X-Received: by 2002:a05:6a20:1b2a:b0:122:cb38:637a with SMTP id ch42-20020a056a201b2a00b00122cb38637amr1496991pzb.29.1688106825942;
        Thu, 29 Jun 2023 23:33:45 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id iw13-20020a170903044d00b001b801044466sm7929015plb.114.2023.06.29.23.33.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jun 2023 23:33:45 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <958b921a-41ff-ffb1-2716-d354dd9c4d7c@roeck-us.net>
Date: Thu, 29 Jun 2023 23:33:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 6.4 00/28] 6.4.1-rc1 review
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
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
In-Reply-To: <fbe57907-b03f-ac8c-f3f4-4d6959bbc59c@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/29/23 23:29, Guenter Roeck wrote:
> On 6/29/23 23:16, Linus Torvalds wrote:
>> On Thu, 29 Jun 2023 at 22:31, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>>>
>>> arch/parisc/mm/fault.c: In function 'do_page_fault':
>>> arch/parisc/mm/fault.c:292:22: error: 'prev' undeclared (first use in this function)
>>>    292 |                 if (!prev || !(prev->vm_flags & VM_GROWSUP))
>>
>> Bah. "prev" should be "prev_vma" here.
>>
>> I've pushed out the fix. Greg, apologies. It's
>>
>>     ea3f8272876f parisc: fix expand_stack() conversion
>>
>> and Naresh already pointed to the similarly silly sparc32 fix.
>>
>>               Linus
> 
> Did you see that one (in mainline) ?
> 
> Building csky:defconfig ... failed
> --------------
> Error log:
> arch/csky/mm/fault.c: In function 'do_page_fault':
> arch/csky/mm/fault.c:240:40: error: 'address' undeclared (first use in this function); did you mean 'addr'?
>    240 |         vma = lock_mm_and_find_vma(mm, address, regs);
> 

This is also in {6.1,6.3,6.4}-rc unless I am missing something.

Guenter

