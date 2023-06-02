Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3517F15BF
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 12:33:16 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1b024e29657so10323155ad.3
        for <patches@lists.linux.dev>; Fri, 02 Jun 2023 05:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685709195; x=1688301195;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=SbMziD+yODVijD+pmZlHL1+LyDW7UnKosThfDRRDpqI=;
        b=lnI9Myn4s53cPHi64DPoUhQQvE9BPIhpUG8CJDK5Qnj582pRJz78Nig/yIm9dG6hsK
         Z3Dl2fqm/oiLW3GwP9yClT71vM0lvQBbdFD/OwRd01xDjJLVD+g3wTB6W/67IOftFxOt
         A/qDlC9i9wzL/RG+ctBg5TVypbqzY+S7IM4cw8VGg/H+qaOjjCKIB3pTlRnIixoyQTYh
         zlS2caD6emOM14ERRaWbZSkp7V6KJfEwd1rxjYgbcU8duRlhbxCUm8M0ebX53WAW2QBv
         3t/FrwkcnQ90Hq2dzAg5IWQXioFX/mGq3yyg+6DLZEM88AEVGR2LTyd8sfOeyE7zz2hK
         ss3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685709195; x=1688301195;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SbMziD+yODVijD+pmZlHL1+LyDW7UnKosThfDRRDpqI=;
        b=STKbnu9n97yDYQGALGquJDrlKzuFfzgiTjmVpXmFzdENE7QoiEh5eAlBzsd7k9SAGB
         Cyj2ORTrakoo60ChHRWBlp5eOXhaAcpNoOuXmO80UfQTBx/eb0Mkwi1W/o49ASSjAeIN
         6Ug35LELrAWdIDQY5u2+zwghaI+0H9jqhnO5HJkYLXvYYhluNUPZUzPouaBz/2xWb/Qi
         rIL3rr/8kLhfxiP2zzpmkhb4JPYGX6W4f0o9iQlk8F8Rd9kiXkr2TXtw+JI8cG4DZte6
         UHKn9vjNNTCWKpVY1bxOtdm9918VExC/6DHhspBy9NuG832Mf+sO3i7ajYQP/Lwm9vhX
         wlMw==
X-Gm-Message-State: AC+VfDwfS9Zhkpl9/6oHpsb6gDhk7UDjgJj299REUUGSVAdHnOO9Dvd1
	ParFSnjiSIIynNK96ga5i6g=
X-Google-Smtp-Source: ACHHUZ6FfTlTWl7qTtPtQUKLnxk2CSa7+vYgTId2M3DW/LYkx6g5ZV/0CkRVeRWnpc9d5T3LmwCtvA==
X-Received: by 2002:a17:903:2291:b0:1b0:6541:91c2 with SMTP id b17-20020a170903229100b001b0654191c2mr1329274plh.63.1685709195419;
        Fri, 02 Jun 2023 05:33:15 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l17-20020a170902f69100b001a96d295f15sm1228685plg.284.2023.06.02.05.33.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jun 2023 05:33:14 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <779687e0-7e21-77fb-8559-49e2100853ed@roeck-us.net>
Date: Fri, 2 Jun 2023 05:33:12 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5.15 00/37] 5.15.115-rc2 review
Content-Language: en-US
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230601143331.405588582@linuxfoundation.org>
 <CADVatmPDwobeqntQ5+LQibMSHK86FmwUpN+E3JUd+GMs3bWpDQ@mail.gmail.com>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <CADVatmPDwobeqntQ5+LQibMSHK86FmwUpN+E3JUd+GMs3bWpDQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/2/23 05:07, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Thu, 1 Jun 2023 at 15:36, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 5.15.115 release.
>> There are 37 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> 
> s390 allmodconfig build fails with the error:
> 
> arch/s390/kernel/uv.c: In function 'should_export_before_import':
> arch/s390/kernel/uv.c:204:40: error: 'mm_context_t' has no member
> named 'protected_count'
>    204 |         return atomic_read(&mm->context.protected_count) > 1;
>        |                                        ^
> arch/s390/kernel/uv.c:205:1: error: control reaches end of non-void
> function [-Werror=return-type]
>    205 | }
>        | ^
> 

Missing commit 07fbdf7f93479 ("KVM: s390: pv: usage counter
instead of flag"), but I don't know if that alone is sufficient
(there have been other commits adding to its use).

Guenter


