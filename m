Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCEB3C3F
	for <patches@lists.linux.dev>; Mon, 31 Jul 2023 15:03:08 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1bba2318546so39372455ad.1
        for <patches@lists.linux.dev>; Mon, 31 Jul 2023 08:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690815788; x=1691420588;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=y7z84WLzQQAhksQ4Qty3hSLr3+i9Bp8oEu2LreTIujk=;
        b=Ftws52sX4PhxkpYjWZkaKpuyrTdXbWFlFyhHfs4SAgvye9Fj8mLt4kKLfpgSTI3uE0
         Ii5a2SQTdWJ045BCVlNIabVo4vvvuYHvNwNe4i9iX5tDMWeqrtoQ/CfLacFtXhK+SEbz
         vJ2kmzfUJ9qVluFzTPIrD7YzP/y9PysM0uOz3Y5mE58f+nZfmzyLAqSu+f7Xl8A4B+Af
         vmBS63glJpxFY5jKCjMI72Dl7HXII8nrulffQrIDfNIy/sMcD7UF6iO2w6Uv9ZwJipg8
         nIAn1F0X8uWFnmOGCNhPi14V2McRgOh+9jks6+H3kVb/RcIBGQnFHG00bYdmd6+gt+vM
         MncQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690815788; x=1691420588;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y7z84WLzQQAhksQ4Qty3hSLr3+i9Bp8oEu2LreTIujk=;
        b=AkxBLNEHvjBgyw57DJA8i66qY5/RGVB2otPA6GeM9KaM/EZizFmMkSrhFWxveA71cq
         3Y3EDMM3oIGsiSW08tg1owc9h5x/g7ScYiWELoYwYEATvHO0AKSGhbj7UyvWU5vipoMw
         lEVGDqEZtH9k8CpPUxDtJeq/3MiD00/fatQxxgWdyDXzDtscBiWwhiG3+SU73IJVgan6
         2xjaNsUkzqonviqm11FH5rQGmPn7GdrLPr9Ka3vN9SMEnSjyckRyKaPcO/7C4N8PRYS+
         bJNcdcOqdiqILKXKmiIeseEEXlkwWeriklEAjxPTXDvixk8qKbODXyK/pVoK2IZzmaPe
         s2rA==
X-Gm-Message-State: ABy/qLaXW6WmLjPnTYl8gYKsruZ0HS6HYX3XVALQZVISOKyvorC6cVg4
	tMCSu9Jw+J9lkAuNpNFhOYY=
X-Google-Smtp-Source: APBJJlEwrn2P6WxOGIDcA2iBk7KM7tT0dduXSYBHC4snXk1zI6KsJ7UDy3qaBzA0+fazhPxIQ97QSA==
X-Received: by 2002:a17:902:c40f:b0:1bb:a4e4:54b6 with SMTP id k15-20020a170902c40f00b001bba4e454b6mr12734060plk.62.1690815787707;
        Mon, 31 Jul 2023 08:03:07 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902d68b00b001b53d3d8f3dsm8652858ply.299.2023.07.31.08.03.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jul 2023 08:03:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <5f1b740e-592f-32d7-0f33-2fed88b949be@roeck-us.net>
Date: Mon, 31 Jul 2023 08:03:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: scheduler problems in -next (was: Re: [PATCH 6.4 000/227]
 6.4.7-rc1 review)
Content-Language: en-US
To: Peter Zijlstra <peterz@infradead.org>
Cc: Joel Fernandes <joel@joelfernandes.org>, paulmck@kernel.org,
 Pavel Machek <pavel@denx.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, rcu@vger.kernel.org,
 Ingo Molnar <mingo@kernel.org>
References: <2cfc68cc-3a2f-4350-a711-ef0c0d8385fd@paulmck-laptop>
 <D56D0318-A2EA-4448-8F4D-BE84706E26A5@joelfernandes.org>
 <3da81a5c-700b-8e21-1bde-27dd3a0b8945@roeck-us.net>
 <20230731141934.GK29590@hirez.programming.kicks-ass.net>
 <fdaaee62-b67e-556c-2675-aacd3ec994f6@roeck-us.net>
 <20230731144733.GL29590@hirez.programming.kicks-ass.net>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230731144733.GL29590@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/31/23 07:47, Peter Zijlstra wrote:
> On Mon, Jul 31, 2023 at 07:35:13AM -0700, Guenter Roeck wrote:
> 
>>> Hurmph, let me see if I can reproduce on next-20230731 (not having the
>>> older next thingies around).
>>
>> That crashes hard with my configuration.
>>
>> [    6.353191] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
>> [    6.353392] BUG: unable to handle page fault for address: ffff9b10c0013cd0
>> [    6.353531] #PF: supervisor instruction fetch in kernel mode
>> [    6.353624] #PF: error_code(0x0011) - permissions violation
>> [    6.353751] PGD 1000067 P4D 1000067 PUD 1205067 PMD 1206067 PTE 800000000124e063
>> [    6.354011] Oops: 0011 [#1] PREEMPT SMP PTI
>> [    6.354164] CPU: 0 PID: 182 Comm: kunit_try_catch Tainted: G                 N 6.5.0-rc4-next-20230731 #1
>> [    6.354315] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
>> [    6.354525] RIP: 0010:0xffff9b10c0013cd0
>> [    6.354793] Code: ff ff 60 64 ce a9 ff ff ff ff 00 00 00 00 00 00 00 00 d1 3a bc a8 ff ff ff ff 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <f0> 00 01 44 10 8a ff ff b8 01 01 44 10 8a ff ff 00 00 00 00 00 00
>> [    6.355059] RSP: 0000:ffff9b10c027fd60 EFLAGS: 00000246
>> [    6.355157] RAX: ffff9b10c0013cd0 RBX: ffff8a1043bdb400 RCX: 0000000000000000
>> [    6.355259] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8a1043bdb400
>> [    6.355358] RBP: ffff9b10c027fdc8 R08: 0000000000000001 R09: 0000000000000001
>> [    6.355456] R10: 0000000000000001 R11: 0000000000000001 R12: ffff9b10c027fe74
>> [    6.355556] R13: ffff8a10440100f0 R14: ffff8a10440101b8 R15: ffff9b10c027fe74
>> [    6.355679] FS:  0000000000000000(0000) GS:ffff8a104fc00000(0000) knlGS:0000000000000000
>> [    6.355798] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [    6.355886] CR2: ffff9b10c0013cd0 CR3: 000000000e048000 CR4: 00000000003506f0
>> [    6.356029] Call Trace:
>> [    6.356158]  <TASK>
>> [    6.356334]  ? __die+0x1f/0x70
>> [    6.356472]  ? page_fault_oops+0x14a/0x460
>> [    6.356547]  ? exc_page_fault+0xee/0x1c0
>> [    6.356612]  ? asm_exc_page_fault+0x26/0x30
>> [    6.356703]  ? kunit_filter_attr_tests+0xc4/0x2e0
>> [    6.356796]  kunit_filter_suites+0x2e2/0x460
>> [    6.356889]  ? __pfx_kunit_generic_run_threadfn_adapter+0x10/0x10
>> [    6.356979]  filter_suites_test+0xea/0x2c0
>> [    6.357051]  ? __pfx_kunit_generic_run_threadfn_adapter+0x10/0x10
>> [    6.357148]  kunit_generic_run_threadfn_adapter+0x15/0x20
>> [    6.357228]  kthread+0xef/0x120
>> [    6.357282]  ? __pfx_kthread+0x10/0x10
>> [    6.357343]  ret_from_fork+0x2f/0x50
>> [    6.357399]  ? __pfx_kthread+0x10/0x10
>> [    6.357458]  ret_from_fork_asm+0x1b/0x30
>> [    6.357560]  </TASK>
>> [    6.357632] Modules linked in:
>> [    6.357786] CR2: ffff9b10c0013cd0
>> [    6.358010] ---[ end trace 0000000000000000 ]---
> 
> I get:
> 
> [    2.423691] ------------[ cut here ]------------
> [    2.424994] WARNING: CPU: 0 PID: 184 at mm/slab_common.c:992 free_large_kmalloc+0x4f/0x80
> [    2.426183] Modules linked in:
> [    2.426624] CPU: 0 PID: 184 Comm: kunit_try_catch Tainted: G                 N 6.5.0-rc4-next-20230731 #1
> [    2.427964] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-debian-1.16.0-5 04/01/2014
> [    2.429265] RIP: 0010:free_large_kmalloc+0x4f/0x80
> [    2.429952] Code: f7 da 48 63 d2 48 8b 03 be 06 00 00 00 48 c1 e8 3a 48 8b 3c c5 60 ba 11 ab e8 0d 52 ff ff 89 ee 48 89 df 5b 5d e9 41 df 03 00 <0f> 0b 80 3d 49 43 e9 01 00 75
> [    2.432511] RSP: 0000:ffffadcb0024bdb8 EFLAGS: 00010246
> [    2.433259] RAX: 0100000000001000 RBX: ffffd16bc018aa40 RCX: ffffadcb0024bd7c
> [    2.434262] RDX: ffffd16bc018aa48 RSI: ffffffffa96a9ec7 RDI: ffffd16bc018aa40
> [    2.435265] RBP: ffffadcb0024be60 R08: 0000000000000001 R09: 0000000000000001
> [    2.436269] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8a7084014410
> [    2.437267] R13: ffff8a70840c4000 R14: 0000000000000002 R15: ffff8a70840564a8
> [    2.438271] FS:  0000000000000000(0000) GS:ffff8a708f800000(0000) knlGS:0000000000000000
> [    2.439403] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    2.440215] CR2: ffff8a7089401000 CR3: 0000000007a48001 CR4: 0000000000170ef0
> [    2.441218] Call Trace:
> [    2.441568]  <TASK>
> [    2.441883]  ? free_large_kmalloc+0x4f/0x80
> [    2.442491]  ? __warn+0x80/0x170
> [    2.442988]  ? free_large_kmalloc+0x4f/0x80
> [    2.443591]  ? report_bug+0x171/0x1a0
> [    2.444145]  ? handle_bug+0x3c/0x70
> [    2.444662]  ? exc_invalid_op+0x17/0x70
> [    2.445225]  ? asm_exc_invalid_op+0x1a/0x20
> [    2.445844]  ? kunit_add_action+0xc7/0x140
> [    2.446455]  ? free_large_kmalloc+0x4f/0x80
> [    2.447054]  kunit_filter_suites+0x468/0x480
> [    2.447662]  ? kunit_add_action+0xc7/0x140
> [    2.448258]  ? __pfx_kunit_generic_run_threadfn_adapter+0x10/0x10
> [    2.449105]  filter_suites_test+0xea/0x2c0
> [    2.449702]  kunit_generic_run_threadfn_adapter+0x15/0x20
> [    2.450469]  kthread+0xf0/0x120
> [    2.450940]  ? __pfx_kthread+0x10/0x10
> [    2.451481]  ret_from_fork+0x2f/0x50
> [    2.452012]  ? __pfx_kthread+0x10/0x10
> [    2.452557]  ret_from_fork_asm+0x1b/0x30
> [    2.453146]  </TASK>
> [    2.453474] irq event stamp: 677
> [    2.453943] hardirqs last  enabled at (689): [<ffffffffa911c24a>] console_unlock+0x10a/0x160
> [    2.455151] hardirqs last disabled at (700): [<ffffffffa911c22f>] console_unlock+0xef/0x160
> [    2.456329] softirqs last  enabled at (662): [<ffffffffa909179a>] irq_exit_rcu+0x7a/0xa0
> [    2.457474] softirqs last disabled at (657): [<ffffffffa909179a>] irq_exit_rcu+0x7a/0xa0
> [    2.458610] ---[ end trace 0000000000000000 ]---
> 

Same problem. I see the warning on some architectures, the crash on others.
The fix for that problem is at
https://lore.kernel.org/linux-kselftest/20230729010003.4058582-1-ruanjinjie@huawei.com/
It is caused by the "kunit: Add test attributes API" patch series.
See https://lore.kernel.org/lkml/5205b6aa-c9ea-8f9c-f42c-b840346f740c@roeck-us.net/T/

Guenter

