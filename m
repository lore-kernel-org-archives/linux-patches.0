Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57594AD27
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 06:29:31 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-54290603887so844343a12.1
        for <patches@lists.linux.dev>; Thu, 29 Jun 2023 23:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688106570; x=1690698570;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=PAq7BJ48mpqsi8BZO+XAPQUWw6V+9NeCDL8VutkDMfM=;
        b=EA03BEcOuim1I5UzVjtwh4so5IQAPLEiKsFRdfBecOreCy+Gne7HPLZKDWDvONddta
         OSw3PUdOUjYYLjf5a3KaNsd12gC/w5zkL8/P4Vk5K4zNAbn7B4+Q+2UTQQbF7rdkol7s
         gODtN3ocNS+VsACkAV1GZ7c2z32UzPFTbvGa4FEsofAG/xJrGsGIFmX7+DtUsbbvaiUu
         ZDD2uq9xHqR9YkVV5AtrTMseReovfEzZKriOIkLx504O+tz2vbdzbpo9HRgNA6rKypah
         O1C6NN19SLejda/Smeh4bdTeCHcgq7xEJLSwkjhUtRn/+t+a7Uv9QzG9n9aEzXHsUALA
         5DZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688106570; x=1690698570;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PAq7BJ48mpqsi8BZO+XAPQUWw6V+9NeCDL8VutkDMfM=;
        b=PfJnMWg3Cja1nmNszk0eikjcf6BqCB0laoNrCgJqzkUdJCtMvV0F92yZ4Q3tdu5reF
         RqXUdF4jEhaTvNeauTTQM6Z9imkbRk2lZgic5t106L8UPA+uk7jsa28grCOepU0UBKIK
         qWhUizRZ4fkfmFGAqgR1sIhoL7fn/HdmiyaK32mzghyiyjxOtHWc3kG0h5kyGCtOpedT
         jtTryITNzID+HGKtaOeVqAkPK2FIcxrMMpSwAoV2IN5/6sn7gQuq+Z0xrnqhQQPBem8T
         V10NjQ0ogFSD+a0mJELNJm2VimLkSAC8TaaIvEn+KwTdk40S8TaUZvVADuL53aib9RP1
         YMTw==
X-Gm-Message-State: ABy/qLZWLRBu3V3qKUpV0qi/Uc3xrMEI7Jm9OaVkjEdYx1FUMMBTzvt4
	N5/8LIZH29TNZaxLKfeIy34=
X-Google-Smtp-Source: APBJJlFlRG2eTs1rMzH7koWOJWvQ8XKpyOFRhiRbwYW1+lILqmZnrVd4LwIt4xEiaBBuhilPmzfAyA==
X-Received: by 2002:a17:903:1205:b0:1b3:b998:8007 with SMTP id l5-20020a170903120500b001b3b9988007mr1220475plh.55.1688106570509;
        Thu, 29 Jun 2023 23:29:30 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p11-20020a1709026b8b00b001b82862d3besm4823934plk.127.2023.06.29.23.29.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jun 2023 23:29:29 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <fbe57907-b03f-ac8c-f3f4-4d6959bbc59c@roeck-us.net>
Date: Thu, 29 Jun 2023 23:29:27 -0700
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
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <CAHk-=whaO3RZmKj8NDjs4f6JEwuwQWWesOfFu-URzOqTkyPoxw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/29/23 23:16, Linus Torvalds wrote:
> On Thu, 29 Jun 2023 at 22:31, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>>
>> arch/parisc/mm/fault.c: In function 'do_page_fault':
>> arch/parisc/mm/fault.c:292:22: error: 'prev' undeclared (first use in this function)
>>    292 |                 if (!prev || !(prev->vm_flags & VM_GROWSUP))
> 
> Bah. "prev" should be "prev_vma" here.
> 
> I've pushed out the fix. Greg, apologies. It's
> 
>     ea3f8272876f parisc: fix expand_stack() conversion
> 
> and Naresh already pointed to the similarly silly sparc32 fix.
> 
>               Linus

Did you see that one (in mainline) ?

Building csky:defconfig ... failed
--------------
Error log:
arch/csky/mm/fault.c: In function 'do_page_fault':
arch/csky/mm/fault.c:240:40: error: 'address' undeclared (first use in this function); did you mean 'addr'?
   240 |         vma = lock_mm_and_find_vma(mm, address, regs);

Guenter

