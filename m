Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE02376E2
	for <patches@lists.linux.dev>; Sun, 21 Jan 2024 16:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705855987; cv=none; b=qSz8d9Ed5J1t4owKVhmfJ2cYvxTrv94MM+uBqfPZHm4Viw8D7i80JxyrrZl5PLL147a2bsUonu7ye5UaDcxJiXYEJVSGs4861p49C5ScbNE9mRjs6IYACeGdapcbIU9/UWTiltpuQfI1ELYkuF56VI6Y89R8oXlG/9u7yIYpDy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705855987; c=relaxed/simple;
	bh=kAbSDrFdrLAUsF2e5e18sP9A385biMhnkaVEQcxwnUw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EQlFRBT9y2BZIYzwhB2NXupWyL9Cml7Q/8fVF585W+Y5AUBuYvDCYXzXAPoRjFr4ZRp31ix1DWl92Yed9ShGaEFtib3EFnVPaoSyW6JwlIwbeXrcIhadOUElWu1OvcQvk4shjdx7Isn+mSVBkapLeno7Qq6xQt4dEXH9J5dLkgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hwltvb2h; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hwltvb2h"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7bf7e37dc60so107980139f.3
        for <patches@lists.linux.dev>; Sun, 21 Jan 2024 08:53:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705855985; x=1706460785; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8qJWbDDhASFxoa0nzAKvVG8hoM9XlDndgYsXpvEO704=;
        b=hwltvb2hLqjsruxwdMv4g2BL6iq9kfrYNHGr0VWk9Swuy22SbIwoGm5umh5GP8+h7K
         RstIoJ/JR5fsSnFwVhA/7fxjxuVQa+g6Jebkm8sOnG0QiWvZKZL7FHQHH4h+4if5jGS4
         oDoy3zy73hmrr1v2yUaVexqQnfVXuIhLGRlNpcTWDrvJ8M9K+5qjP406Guz7WVGQtjG5
         IGFPevBWeaMv6j1cy6lr0OHS3eXTDMUuEpmFKNF+H1og97bJ2cqXGFtLJd3DAHO9hgDV
         mbLn5mu1gFJmCejD5xCpxNRC1V7S/tRaYr9TdTYAZX3lDFAHbdwuZWgGsMVqznbMp1Y3
         mVNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705855985; x=1706460785;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8qJWbDDhASFxoa0nzAKvVG8hoM9XlDndgYsXpvEO704=;
        b=rJfftkkTu4IsW2FIdSDS/9KwItLQSPj5R698hcijOwEYnayewz+5sEUjTw2XpscAhT
         tEPT7T5Lce9bA5ypb11+p48QdSz9eoymI1jT3opWE78fA79e0uLGyU5Gtlr06qDo+C5T
         90zIbcDw7sSeREhR/ZRhVe3rdfBZ23yU4ex0lT6zlv8TEs0Ta9KkOuQ5KM9dDa/hO9uY
         kR+6R8sWkVY+axQ3e2/lQ1Pj8fGA1EQFIEN0RoZG/Dr10ntbTwj2IH6cDVbPeeL0WwbU
         YMUSL061Gw9+Vrwk7Z4PbN8rdvds3th+D8r2WjYthFHNmUZge2eh5k6lmw7SjEWNmNzl
         B6iQ==
X-Gm-Message-State: AOJu0YyvMN/xlwvPE6r56xUingsd7X3V/S47KWW5FKw0U77fDv21c+lA
	Z9+20U0Y3Ew0ydOAbf7gCuatr339NrnfJoykwb9Ey0ob+6t6Ad4O
X-Google-Smtp-Source: AGHT+IER6KOx6Ju4rB6Nk9IsIWP0QuHXgtG4a0tkNEX6N/yK/ut9gL5bDMh43OnA3P99H1SFqqSYqg==
X-Received: by 2002:a92:c5ad:0:b0:361:a595:19a3 with SMTP id r13-20020a92c5ad000000b00361a59519a3mr4511646ilt.1.1705855983014;
        Sun, 21 Jan 2024 08:53:03 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:ba1:a148:4065:354f:1b27? ([2600:8802:b00:ba1:a148:4065:354f:1b27])
        by smtp.gmail.com with ESMTPSA id l2-20020a170902eb0200b001d756c2f653sm214267plb.289.2024.01.21.08.52.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jan 2024 08:53:02 -0800 (PST)
Message-ID: <b3ddf95a-7f4a-4f15-b701-c37cfe95a4cb@gmail.com>
Date: Sun, 21 Jan 2024 08:52:55 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mips/smp: Call rcu_cpu_starting() earlier
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Stefan Wiehler <stefan.wiehler@nokia.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Huacai Chen <chenhuacai@loongson.cn>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>
References: <2024011935-snowman-regain-b820@gregkh>
 <20240119163811.3884999-1-stefan.wiehler@nokia.com>
 <2024012047-prompter-driveway-c418@gregkh>
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 HGuUuzv+GKZ6nsysJw==
In-Reply-To: <2024012047-prompter-driveway-c418@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/19/2024 10:38 PM, Greg Kroah-Hartman wrote:
> On Fri, Jan 19, 2024 at 05:38:11PM +0100, Stefan Wiehler wrote:
>> rcu_cpu_starting() must be called before clockevents_register_device() to avoid
>> the following lockdep splat triggered by calling list_add() when
>> CONFIG_PROVE_RCU_LIST=y:
>>
>>    WARNING: suspicious RCU usage
>>    ...
>>    -----------------------------
>>    kernel/locking/lockdep.c:3680 RCU-list traversed in non-reader section!!
>>
>>    other info that might help us debug this:
>>
>>    RCU used illegally from offline CPU!
>>    rcu_scheduler_active = 1, debug_locks = 1
>>    no locks held by swapper/1/0.
>>    ...
>>    Call Trace:
>>    [<ffffffff8012a434>] show_stack+0x64/0x158
>>    [<ffffffff80a93d98>] dump_stack_lvl+0x90/0xc4
>>    [<ffffffff801c9e9c>] __lock_acquire+0x1404/0x2940
>>    [<ffffffff801cbf3c>] lock_acquire+0x14c/0x448
>>    [<ffffffff80aa4260>] _raw_spin_lock_irqsave+0x50/0x88
>>    [<ffffffff8021e0c8>] clockevents_register_device+0x60/0x1e8
>>    [<ffffffff80130ff0>] r4k_clockevent_init+0x220/0x3a0
>>    [<ffffffff801339d0>] start_secondary+0x50/0x3b8
>>
>> raw_smp_processor_id() is required in order to avoid calling into lockdep
>> before RCU has declared the CPU to be watched for readers.
>>
>> See also commit 29368e093921 ("x86/smpboot:  Move rcu_cpu_starting() earlier"),
>> commit de5d9dae150c ("s390/smp: move rcu_cpu_starting() earlier") and commit
>> 99f070b62322 ("powerpc/smp: Call rcu_cpu_starting() earlier").
>>
>> Signed-off-by: Stefan Wiehler <stefan.wiehler@nokia.com>
>> Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
>> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
>> ---
>>   arch/mips/kernel/smp.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> What is the git commit id of this change in Linus's tree?  What
> kernel(s) should this be applied to?

The upstream commit is 55702ec9603ebeffb15e6f7b113623fe1d8872f4 
("mips/smp: Call rcutree_report_cpu_starting() earlier") and this change 
from Stefan should be applied to both the 6.1 stable and 6.6 stable 
branches. Thanks!
-- 
Florian
