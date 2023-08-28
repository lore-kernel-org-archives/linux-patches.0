Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE36410F4
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 20:32:41 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-68c3b9f8333so1719797b3a.1
        for <patches@lists.linux.dev>; Mon, 28 Aug 2023 13:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693254761; x=1693859561; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=2DctLJ0sN1rLWYEamaeYJQ0hHmAoC8BkhI/utXkH6Aw=;
        b=QdVQ5xR82ovZtGW//1ExQWXag5bCn4fjRAHQC/SwsDkFJFmG2RUMGrPlPHwua03LFc
         OmXgUDKlAG4Q6okMr7rtnM4hshrCDEJoeUSoVMP3umpAsA80eI3Ue8v5Dd7d8F9kMo5c
         BQC255U70PAUv+dQ8P29rlpinajT6nmj5A0xzwrYbbMdfSNQW9OFrK53asRi4TMvWM4m
         f37eHw5W897hVashfo3IbwCt9xhM0xrsRfFMBjvyrlPVH1oJk4w3uylvgVmm6wxNoipB
         R4tc2soOSTW7LbevO40PwYVplMX5jfm+ZUTZGn4f7D5e0bd40xkDPYc1YUODCu6YM6Nu
         4LEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693254761; x=1693859561;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2DctLJ0sN1rLWYEamaeYJQ0hHmAoC8BkhI/utXkH6Aw=;
        b=DNE9ZE5t0e5skd6vpaaQkIbD/4RgJPjRL1nyp+d3GYwQbRVeE901//18xDdvEIKWAi
         fpKAbsz7jBVKUQP0pWVHdz4Rpj8NJye+vV1GCUnrhdjDRCEavLGQl4qS+HBV82sbOU+G
         T/n9+W9OA9DoFAEDesGPP20kkEbiqHGXYU0vTAgWTpKwQ3LB9lbED7PvJ92bAolnkw6u
         zDRTqeZg1piLWbIZjvzHB7revsdKqbpLRQrC70KK3wzlU3P+Ti0jJSpqhigv49RG18g2
         YYhayQufOLYBfgNxAplq9ZNMKHncHPRChGiNogUqmZVX2ywxYxz6ATeETjNdOogPkCTR
         bPTA==
X-Gm-Message-State: AOJu0YzlN4pUfpY0Iv+pqSlSv/G8GwDIK0K3pjPigMBHffBmoHOkjhqm
	bX7pTM6q9fMiSCRizJSZayk=
X-Google-Smtp-Source: AGHT+IExS4GSW+/X8U9BFi2G0OwOd4T6jCEWg8kgMcckw/tc7P9drIQDk7DlD2SzNFGol3eWBvEbmw==
X-Received: by 2002:a05:6a00:35c4:b0:68c:59cb:2dd9 with SMTP id dc4-20020a056a0035c400b0068c59cb2dd9mr1026403pfb.1.1693254760933;
        Mon, 28 Aug 2023 13:32:40 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m14-20020aa78a0e000000b0062cf75a9e6bsm7092592pfa.131.2023.08.28.13.32.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Aug 2023 13:32:40 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <ef24157c-75ff-6874-d8e5-723baa2ac7ea@roeck-us.net>
Date: Mon, 28 Aug 2023 13:32:38 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 4.19 000/129] 4.19.293-rc1 review
Content-Language: en-US
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
References: <20230828101153.030066927@linuxfoundation.org>
 <CADVatmPpi8pLT=MKNuPjkTP5pLHPnCKu2v2Ms98YhzXUhAvyyA@mail.gmail.com>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <CADVatmPpi8pLT=MKNuPjkTP5pLHPnCKu2v2Ms98YhzXUhAvyyA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/28/23 13:20, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, 28 Aug 2023 at 11:24, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 4.19.293 release.
>> There are 129 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
>> Anything received after that time might be too late.
> 
> Just an initial report.
> 
> mips builds are failing with the error:
> arch/mips/alchemy/common/dbdma.c:33:10: fatal error:
> linux/dma-map-ops.h: No such file or directory
> 33 | #include <linux/dma-map-ops.h> /* for dma_default_coherent */
> | ^~~~~~~~~~~~~~~~~~~~~
> 
> arm build has failed with:
> arch/arm/mach-ep93xx/timer-ep93xx.c:12:10: fatal error: platform.h: No
> such file or directory
> 12 | #include "platform.h"
> | ^~~~~~~~~~~~
> 
> 
I'd guess that the mips dma patch which fail to build in v5.10.y
(and by extension in all older kernels) have been applied to
those older kernels. AFAICs the problem now affects all releases
form v4.14.y to v5.10.y.

Guenter

