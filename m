Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1834E148857
	for <patches@lists.linux.dev>; Wed,  7 Aug 2024 21:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723065015; cv=none; b=tzVasQ7ft+H5lqwoNUy8wuGpigI4pmu0eRCkr9BgvFIS9hJ1w6U/6pTadmwOB39bndTAXKeJGIjNtKYeA3nv4ZUGBfRDNoR7E6zAS/ms9BwlavU7OHfxlCXuRr+LYIsj9+JbPjAXh3duTEYNcqChFLwQ+kqw7CQIuI/vI+uHZiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723065015; c=relaxed/simple;
	bh=b16fxV+/Cww+CiHGutFpNzgMVbN71JfHg+uK3/x/JgI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K7E2gRBU028k8GCSasHLx3V9nENBuMetxdxgX+0IFMyGjn/PjzqXSoF6dJeHmg3RW4qUQuII+EkOs3ghMIYAefFuqgTVrN5DjiR88rnmfOsCMGcKbdD2cQ2zY1pk1ZPHjDHx7jua4Ygt0PR9X/kIRpKIOYTJC0yCCgeJy8i6vls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YWUlImmc; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YWUlImmc"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-7a115c427f1so229314a12.0
        for <patches@lists.linux.dev>; Wed, 07 Aug 2024 14:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723065012; x=1723669812; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jmVcTiwdUVnQyvPYgm7NdR9ygM43OTx4uAh6et3syrQ=;
        b=YWUlImmcwVZWkl0gP0gm6C7Rp1QZf6lSPZ6yInOTVYjIPGsPkEzzWhNHE4D1Eb3AOb
         5UoFgS6Rh8skZdc93iTU4IMjxVfBnazB15QRg4t+tnZHqWXiEWIMIRubQB3f0BRChtlM
         FPhT8UTNujhDE0IcmvfPRrB+UifeNWLXj+64hpIV5G5/3QBN71vy1rP0cnH4Qao9uo+5
         wuRGX86//U7IdQ9BYitze72r+t/2TtiHNm1bzMJnmQiPDBH29snSdujAvDe8C9c9dPUL
         rOjrJlLqpT0uAwtH9aj7lL1kBW2+mSD9JKJcQZIKHbYyoqg88RWIjjJCpB2dwZpbfBpW
         m3ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723065012; x=1723669812;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jmVcTiwdUVnQyvPYgm7NdR9ygM43OTx4uAh6et3syrQ=;
        b=BJkeBbyCuObm+6PrQPhj6R/gQokVMzv8gqj8/xWKa6+0TA2NRgTH5rgbWFNQaMD3pe
         la0socld+fLCix4hr7cnIKiDsyxHgPW7bFB4nymNPkelayhlO7L87XnulOFAA4poiXmb
         uO9n5QqKD70EUPf7aPpY68qwBNvtGO0ZGQ4YIMTAh5ceO6rYvXeqWBe5q96/ooqQkIxe
         py0qBjx9WqlVmjY3JDDcmXxRFhU8G8eLehn5HBbIiYIrOS0p6R3BpXhrfgINz1qgmiQ+
         4M9JzMT7dNw0rZkwY3sAS71KacySXqsyxo1uNA74rAbbxjni9RNOQhN0/4axFYO2THBD
         lenw==
X-Gm-Message-State: AOJu0YxDBh42Aw+9i2NgCRYwHRSg6R7YyaDHtFlThqE4xtUf70jCGBez
	8qRSJKqLqgwaNe+urygu0avh0RY0aRKPYzTz0YBBv0v+GKtHAxWy
X-Google-Smtp-Source: AGHT+IHtNiUZBlNNpmYneFqUZu7QQkcpy+VdBOt3klax5nPt/6QJfX3e+mIu11HLnUAGbFVCPFDGNw==
X-Received: by 2002:a05:6a20:c99a:b0:1c2:8af6:31c2 with SMTP id adf61e73a8af0-1c699642729mr20535485637.44.1723065012168;
        Wed, 07 Aug 2024 14:10:12 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7106ec414bfsm8801664b3a.65.2024.08.07.14.10.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Aug 2024 14:10:11 -0700 (PDT)
Message-ID: <35ebc15b-b3fa-4129-a542-fe348069df88@gmail.com>
Date: Wed, 7 Aug 2024 14:10:08 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/86] 6.1.104-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Justin Chen <justin.chen@broadcom.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240807150039.247123516@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/24 07:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.104 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Aug 2024 15:00:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.104-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

I have been getting some fairly unexplained oopses with 6.1.104-rc1, 
whereas 6.1.103 was stable. This is only seen with ARM64, not with ARM32 
running on the same board for some reason.

Here are a few samples, they most often fall within the workqueue code, 
but not always:

Loading modules...[    4.538506] usb 1-1: new high-speed USB device 
number 2 using xhci-hcd
[    4.621340] Unable to handle kernel paging request at virtual address 
ffffff8004ea078d
[    4.629297] Mem abort info:
[    4.632097]   ESR = 0x0000000096000021
[    4.635851]   EC = 0x25: DABT (current EL), IL = 32 bits
[    4.641172]   SET = 0, FnV = 0
[    4.644229]   EA = 0, S1PTW = 0
[    4.647374]   FSC = 0x21: alignment fault
[    4.651389] Data abort info:
[    4.654274]   ISV = 0, ISS = 0x00000021
[    4.658115]   CM = 0, WnR = 0
[    4.661085] swapper pgtable: 4k pages, 39-bit VAs, pgdp=000000004102f000
[    4.667795] [ffffff8004ea078d] pgd=18000000bdff8003, 
p4d=18000000bdff8003, pud=18000000bdff8003, pmd=18000000bdfd6003, 
pte=0068000044ea0707
[    4.680345] Internal error: Oops: 0000000096000021 [#1] SMP
[    4.685930] Modules linked in: udc_core(+)
[    4.690039] CPU: 0 PID: 1086 Comm: modprobe Not tainted 
6.1.104-1.1pre-gfcba0aeec90f #2
[    4.698058] Hardware name: BCM972164PCK (DT)
[    4.702334] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS 
BTYPE=--)
[    4.709308] pc : queue_work_on+0x70/0x90
[    4.713248] lr : queue_work_on+0x28/0x90
[    4.717178] sp : ffffffc00cd23940
[    4.720497] x29: ffffffc00cd23940 x28: ffffff8002de6800 x27: 
0000000000000000
[    4.727648] x26: ffffffc00a7b5c68 x25: ffffffc00cd23978 x24: 
0000000000000000
[    4.734798] x23: ffffffc00a630578 x22: ffffff8002c12c00 x21: 
0000000000000100
[    4.741948] x20: 0000000000000000 x19: ffffff8004ea078d x18: 
0000000000000000
[    4.749098] x17: 0000000000000000 x16: 0000000000000000 x15: 
000000000000000a
[    4.756247] x14: 0000000000000001 x13: 6e69622f7273752f x12: 
3a6e6962732f7273
[    4.763397] x11: 752f3a6e69622f3a x10: 0000000000000073 x9 : 
ffffffc00804d610
[    4.770547] x8 : ffffff8004ea080d x7 : 0000000000000000 x6 : 
0000000080200006
[    4.777696] x5 : 00000000ffffffff x4 : 0000000000000dc0 x3 : 
0000000000000080
[    4.784846] x2 : ffffff8004ea078d x1 : ffffff8002c12c00 x0 : 
0000000000000000
[    4.791997] Call trace:
[    4.794446]  queue_work_on+0x70/0x90
[    4.798028]  call_usermodehelper_exec+0xd4/0x1cc
[    4.802654]  kobject_uevent_env+0x6a0/0x6e0
[    4.806849]  kobject_uevent+0x10/0x18
[    4.810519]  kset_register+0x50/0x60
[    4.814102]  bus_register+0xa4/0x234
[    4.817686]  usb_udc_init+0x7c/0x1000 [udc_core]
[    4.822338]  do_one_initcall+0x80/0x1b0
[    4.826183]  do_init_module+0x54/0x1d8
[    4.829942]  load_module+0x1818/0x18e4
[    4.833699]  __do_sys_finit_module+0xec/0x10c
[    4.838064]  __arm64_sys_finit_module+0x20/0x28
[    4.842603]  invoke_syscall+0x80/0x118
[    4.846360]  el0_svc_common.constprop.3+0xb8/0xe4
[    4.851071]  do_el0_svc+0x98/0xbc
[    4.854392]  el0_svc+0x14/0x3c
[    4.857455]  el0t_64_sync_handler+0x64/0x140
[    4.861732]  el0t_64_sync+0x148/0x14c
[    4.865402] Code: a9425bf5 a8c37bfd d65f03c0 f9800271 (c85f7e60)
[    4.871506] ---[ end trace 0000000000000000 ]---
[    4.876130] note: modprobe[1086] exited with irqs disabled
/sbin/load_modules: line 21:  1086 Segmentation fault      modprobe -q $m
done

Another one was:

[    5.833060] Unable to handle kernel paging request at virtual address 
ffffff800586ebc6
[    5.841005] Mem abort info:
[    5.843812]   ESR = 0x0000000096000021
[    5.847576]   EC = 0x25: DABT (current EL), IL = 32 bits
[    5.852907]   SET = 0, FnV = 0
[    5.855974]   EA = 0, S1PTW = 0
[    5.859128]   FSC = 0x21: alignment fault
[    5.863154] Data abort info:
[    5.866047]   ISV = 0, ISS = 0x00000021
[    5.869897]   CM = 0, WnR = 0
[    5.872878] swapper pgtable: 4k pages, 39-bit VAs, pgdp=000000000102f000
[    5.879601] [ffffff800586ebc6] pgd=180000007dff8003, 
p4d=180000007dff8003, pud=180000007dff8003, pmd=180000007dfd1003, 
pte=006800000586e707
[    5.892173] Internal error: Oops: 0000000096000021 [#1] SMP
[    5.897764] Modules linked in:
[    5.900832] CPU: 1 PID: 24 Comm: kworker/u4:1 Not tainted 
6.1.104-1.1pre-gfcba0aeec90f #2
[    5.909032] Hardware name: BCM972604DV2GB (DT)
[    5.913489] Workqueue: events_unbound deferred_probe_work_func
[    5.919349] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS 
BTYPE=--)
[    5.926330] pc : kobject_get+0x6c/0x94
[    5.930096] lr : kobject_add_internal+0x5c/0x25c
[    5.934730] sp : ffffffc00aa1b760
[    5.938054] x29: ffffffc00aa1b760 x28: 0000000000000000 x27: 
0000000000000000
[    5.945213] x26: 000000000f700001 x25: ffffff8002f6ac10 x24: 
ffffff8002f6ac10
[    5.952373] x23: ffffffc008d99430 x22: ffffff800586eb8e x21: 
ffffffc008d99430
[    5.959533] x20: ffffff8004c49000 x19: ffffff800586eb8e x18: 
0000000000000000
[    5.966693] x17: 5f696368652e3030 x16: 3330306230663a6d x15: 
000000000000000a
[    5.973853] x14: 0000000000000001 x13: ffffff800589fa88 x12: 
ffffffffffffffff
[    5.981012] x11: 0000000000000020 x10: 0000000000000000 x9 : 
ffffffc00858c200
[    5.988171] x8 : 0101010101010101 x7 : 7f7f7f7f7f7f7f7f x6 : 
ffffff800345c098
[    5.995331] x5 : ffffffc00aa1b880 x4 : ffffff800586ebc6 x3 : 
ffffff800589fa80
[    6.002490] x2 : ffffffc00aa1b7b0 x1 : 0000000000000000 x0 : 
ffffff800586ebc6
[    6.009650] Call trace:
[    6.012104]  kobject_get+0x6c/0x94
[    6.015518]  kobject_add_internal+0x5c/0x25c
[    6.019804]  kobject_add+0xe0/0xfc
[    6.023220]  device_add+0x164/0x688
[    6.026724]  device_create_groups_vargs+0xac/0xfc
[    6.031445]  device_create+0x70/0x94
[    6.035035]  mon_bin_add+0x6c/0x80
[    6.038449]  mon_bus_init+0x74/0xa8
[    6.041954]  mon_notify+0x50/0xf8
[    6.045282]  notifier_call_chain+0x6c/0x8c
[    6.049398]  blocking_notifier_call_chain+0x48/0x70
[    6.054294]  usb_notify_add_bus+0x24/0x2c
[    6.058319]  usb_add_hcd+0x1f4/0x5fc
[    6.061908]  ehci_brcm_probe+0x164/0x1ac
[    6.065846]  platform_probe+0x6c/0xb8
[    6.069524]  really_probe+0x1b8/0x38c
[    6.073198]  __driver_probe_device+0x134/0x14c
[    6.077656]  driver_probe_device+0x40/0xf8
[    6.081766]  __device_attach_driver+0x108/0x11c
[    6.086311]  bus_for_each_drv+0xa0/0xc4
[    6.090158]  __device_attach+0xf0/0x178
[    6.094007]  device_initial_probe+0x18/0x20
[    6.098203]  bus_probe_device+0x34/0x94
[    6.102052]  deferred_probe_work_func+0xd4/0xe8
[    6.106597]  process_one_work+0x1a4/0x254
[    6.110623]  process_scheduled_works+0x44/0x48
[    6.115083]  worker_thread+0x1e8/0x264
[    6.118846]  kthread+0xbc/0xcc
[    6.121912]  ret_from_fork+0x10/0x20
[    6.125506] Code: a8c27bfd d65f03c0 9100e264 f9800091 (885f7c81)
[    6.131615] ---[ end trace 0000000000000000 ]---

It appears to be somewhat probabilistic because out of our dozen or so 
boards in the farm, not all of them will hit the panic for a given
"bad" commit in the bisection. The bisection eventually landed on:

commit 2f7f85911e7559b06c44561c1e31a69ee80a5f60
Author: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date:   Wed Jun 28 18:02:51 2023 +0300

     irqdomain: Use return value of strreplace()

     [ Upstream commit 67a4e1a3bf7c68ed3fbefc4213648165d912cabb ]

     Since strreplace() returns the pointer to the string itself, use it
     directly.

     Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
     Link: 
https://lore.kernel.org/r/20230628150251.17832-1-andriy.shevchenko@linux.intel.com
     Stable-dep-of: 6ce3e98184b6 ("irqdomain: Fixed unbalanced fwnode 
get and put")
     Signed-off-by: Sasha Levin <sashal@kernel.org>

  kernel/irq/irqdomain.c | 4 +---
  1 file changed, 1 insertion(+), 3 deletions(-)

Reverting that commit on top of 6.1.104-rc1 gives me a stable system 
again, but I really have no explanation why because the transformation 
seems correct to me, it is the *first* bad commit.

Andy, does that make any sense to you?
--
Florian

