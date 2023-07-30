Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DED62E
	for <patches@lists.linux.dev>; Sun, 30 Jul 2023 04:00:06 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1bb893e6365so21336795ad.2
        for <patches@lists.linux.dev>; Sat, 29 Jul 2023 21:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690689605; x=1691294405;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AAH7kcctHGY9q7+ANxa5bVlorYyFiJpGeFYFxj8E/sQ=;
        b=kUub4sDP5yS8kuvvBs7FUJotIVw6CXrxbwTd5U4zze+9PW3Fqcjh3DULx4HIgM8zEZ
         IJ5oj2wF/YGTPJ2vHwzw0RVKKtd7Y/RUB5oUkP7O1egAv/m3pMD7I6IJLU4o1+cZgllL
         4J2+q1lkfydk5+87hao6HxOdKN/m5FRC5Xw1CXqQlvozy0zDYlUW7dt4udwPP/4ifzT+
         oAilLlsDx+VMDgq2vnl9qtuQwTG9WHQ7in14AoabRPP6fJXhfilDjg2p/xlKTr9n0Jxt
         5OjLa1rSE0zvONJjNsMRS2VqNYyeHdIffVWXBf8VRITLZ+rVrrf5apszMIXj2WlqH7s6
         cDIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690689605; x=1691294405;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AAH7kcctHGY9q7+ANxa5bVlorYyFiJpGeFYFxj8E/sQ=;
        b=dBfOZYwg+100r2gqNrNCoYJkX9jFcJ8uaIs3U+HwSRWezUIAemgM7gwW0ptKj/Efog
         Oj+WiRkMoKlCf1iUUAh/gG/bY+zEtWw2LIfNbDXMm65rN/DZ+kJx0ZinxXhLqNrT5i6u
         tnobBf8Ha+FlZYjZSWQyCYo4FWa+IzbJ/wPqcoKwxnKFKx97gFBoNFfVY/iMkrPgdYIn
         HA/6As/R31iE0U2b/9ZmKPMpwEOpkks7uroMdrg6wU/3XKb6aSvIe1Q6554kub/YvkvY
         AfbiYgoM+MH0SvMel7/VCKDY2B7zsRA+SOln4uKW0pfWoGbjSkoa9NlMF6ak1m3WhgtU
         jE1w==
X-Gm-Message-State: ABy/qLYGjUr2nDAi2LG/OGiUEDVHwLQJQjn7OrPvdWJxJ2/3cVw1Cr1G
	XBtJhtKiAbvvIjC8uKYw1Wo=
X-Google-Smtp-Source: APBJJlE4XatKc4s8CMeQH+rvGk5qoJTBZ6cP3YOOttJNhx/ntAHN+p6q2otxn6gaq1UGPyJ+zwjYYw==
X-Received: by 2002:a17:903:1246:b0:1b7:e86f:7631 with SMTP id u6-20020a170903124600b001b7e86f7631mr7879946plh.19.1690689605362;
        Sat, 29 Jul 2023 21:00:05 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l19-20020a170902d35300b001bb9f104330sm5940212plk.240.2023.07.29.21.00.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Jul 2023 21:00:04 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <3da81a5c-700b-8e21-1bde-27dd3a0b8945@roeck-us.net>
Date: Sat, 29 Jul 2023 21:00:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To: Joel Fernandes <joel@joelfernandes.org>, paulmck@kernel.org
Cc: Pavel Machek <pavel@denx.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, rcu@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
References: <2cfc68cc-3a2f-4350-a711-ef0c0d8385fd@paulmck-laptop>
 <D56D0318-A2EA-4448-8F4D-BE84706E26A5@joelfernandes.org>
From: Guenter Roeck <linux@roeck-us.net>
Subject: scheduler problems in -next (was: Re: [PATCH 6.4 000/227] 6.4.7-rc1
 review)
In-Reply-To: <D56D0318-A2EA-4448-8F4D-BE84706E26A5@joelfernandes.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/27/23 16:18, Joel Fernandes wrote:

[ ... ]

>> I freely confess that I am having a hard time imagining what would
>> be CPU dependent in that code.  Timing, maybe?  Whatever the reason,
>> I am not seeing these failures in my testing.
>>
>> So which of the following Kconfig options is defined in your .config?
>> CONFIG_TASKS_RCU, CONFIG_TASKS_RUDE_RCU, and CONFIG_TASKS_TRACE_RCU.
>>
>> If you have more than one of them, could you please apply this patch
>> and show me the corresponding console output from the resulting hang?
> 
> FWIW, I am not able to repro this issue either. If a .config can be shared of the problem system, I can try it out to see if it can be reproduced on my side.
> 

I managed to bisect the problem. See bisect log below. Bisect repeated twice.
so it should be reliable. I don't really understand it, but the following
reverts fix the problem. This is on top of next-20230721 because next-20230728
crashes immediately in my tests.

0caafe9b94ab (HEAD) Revert "sched/fair: Remove sched_feat(START_DEBIT)"
518bdbd39fdb Revert "sched/fair: Add lag based placement"
a011162c3e32 Revert "sched/fair: Implement an EEVDF-like scheduling policy"
df579720bf98 Revert "sched/fair: Commit to lag based placement"
aac459a7e738 Revert "sched/smp: Use lag to simplify cross-runqueue placement"
8d686eb173e1 Revert "sched/fair: Commit to EEVDF"
486474c50f95 Revert "sched/debug: Rename sysctl_sched_min_granularity to sysctl_sched_base_slice"
79e94d67d08a Revert "sched/fair: Propagate enqueue flags into place_entity()"
ae867bc97b71 (tag: next-20230721) Add linux-next specific files for 20230721

For context: x86 images (32 and 64 bit) in -next tend to hang at

[    2.309323] RCU Tasks: Setting shift to 0 and lim to 1 rcu_task_cb_adjust=1.
[    2.311634] Running RCU-tasks wait API self tests

The hang is not seen with every boot; it happens roughly about once every
10 boot attempts. It is not CPU dependent as I initially thought.

Configuration file is at http://server.roeck-us.net/qemu/x86-next/config.
Example qemu command line:

qemu-system-x86_64 -kernel arch/x86/boot/bzImage -M q35 -cpu Broadwell-noTSX -no-reboot \
      -snapshot -device e1000,netdev=net0 -netdev user,id=net0 -m 256 \
      -drive file=rootfs.ext2,format=raw,if=ide \
      --append "earlycon=uart8250,io,0x3f8,9600n8 root=/dev/sda console=ttyS0" \
      -nographic -monitor none

Guenter

---
# bad: [ae867bc97b713121b2a7f5fcac68378a0774739b] Add linux-next specific files for 20230721
# good: [fdf0eaf11452d72945af31804e2a1048ee1b574c] Linux 6.5-rc2
git bisect start 'HEAD' 'v6.5-rc2'
# good: [f09bf8f6c8cbbff6f52523abcda88c86db72e31c] Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git
git bisect good f09bf8f6c8cbbff6f52523abcda88c86db72e31c
# good: [86374a6210aeebceb927204d80f9e65739134bc3] Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git
git bisect good 86374a6210aeebceb927204d80f9e65739134bc3
# bad: [d588c93cae9e3dff15d125e755edcba5d842f41a] Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace.git
git bisect bad d588c93cae9e3dff15d125e755edcba5d842f41a
# good: [acadcaf8c67062ad4c1a0ad0e05bf429b04740c5] Merge branch 'for-next' of git://git.kernel.dk/linux-block.git
git bisect good acadcaf8c67062ad4c1a0ad0e05bf429b04740c5
# good: [2c73542f4cdc59fd23514f9e963d0b3419bd5e16] Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git
git bisect good 2c73542f4cdc59fd23514f9e963d0b3419bd5e16
# good: [be15b91155cd5a6c4ac8f46740ae62e610981b79] Merge remote-tracking branch 'spi/for-6.6' into spi-next
git bisect good be15b91155cd5a6c4ac8f46740ae62e610981b79
# bad: [8f4995b370a57e7ad92c0f66664d171b23234337] Merge branch into tip/master: 'sched/eevdf'
git bisect bad 8f4995b370a57e7ad92c0f66664d171b23234337
# bad: [99d4d26551b56f4e523dd04e4970b94aa796a64e] rbtree: Add rb_add_augmented_cached() helper
git bisect bad 99d4d26551b56f4e523dd04e4970b94aa796a64e
# good: [7ff1693236f5d97a939dbeb660c07671a2d57071] sched/fair: Implement prefer sibling imbalance calculation between asymmetric groups
git bisect good 7ff1693236f5d97a939dbeb660c07671a2d57071
# good: [48b5583719cdfbdee238f9549a6a1a47af2b0469] sched/headers: Rename task_struct::state to task_struct::__state in the comments too
git bisect good 48b5583719cdfbdee238f9549a6a1a47af2b0469
# good: [af4cf40470c22efa3987200fd19478199e08e103] sched/fair: Add cfs_rq::avg_vruntime
git bisect good af4cf40470c22efa3987200fd19478199e08e103
# bad: [86bfbb7ce4f67a88df2639198169b685668e7349] sched/fair: Add lag based placement
git bisect bad 86bfbb7ce4f67a88df2639198169b685668e7349
# bad: [e0c2ff903c320d3fd3c2c604dc401b3b7c0a1d13] sched/fair: Remove sched_feat(START_DEBIT)
git bisect bad e0c2ff903c320d3fd3c2c604dc401b3b7c0a1d13
# first bad commit: [e0c2ff903c320d3fd3c2c604dc401b3b7c0a1d13] sched/fair: Remove sched_feat(START_DEBIT)

