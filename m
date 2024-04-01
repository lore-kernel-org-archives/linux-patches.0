Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108A15337E
	for <patches@lists.linux.dev>; Mon,  1 Apr 2024 19:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712000427; cv=none; b=dLNuUzrOW5s6155J6aQJ+IiH+4u5VZMQ65pl1AzK/oGo2/gniN+shoVRP+PLxla8taounUus16G/wthSJQ6VhZ/29DDx8dFTLoQIZ9a1aqyL7LPupeBc+R7mG1Qpnr5FuObaekDDzd7+OAUruOqPXtPvrWrusmgB9IiBGc2XXGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712000427; c=relaxed/simple;
	bh=iE55jzW3WGrKrwweAWb5hpbGTzV27uCLqvKcnt4a4co=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iAd1SrvNGH0b7yVuvRwUNMeJz7dlh0/wsIY2BCYVBTp84XkK5LVlUAPsjC28eqfOtuRlqnXi5mJPmx4QGZMTX9hYHdqt0AiTYw/nP6CitizXNOgcrjD9o2anHIyGtOuehCJkiC3ZI+g7a0LD3T3TGD1/XffnvHl7TSnFUz6XI3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zK43A/Dv; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zK43A/Dv"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2d47a92cfefso52977501fa.1
        for <patches@lists.linux.dev>; Mon, 01 Apr 2024 12:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712000424; x=1712605224; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qudJF0zUtr8KAClGNxT67zrcaNhIEzpGPECqC2LCVe8=;
        b=zK43A/DvTOPT2UducIQkGdkkqm6i349AD7GDDoySzSBaoQ4UZ/3GGJDYGV8dQUCjAO
         wAMXZbbDGgQarUK4ToXUnUi3yPXbmB7eaI1Hmw+yDFYQAeStXHbORP4rDP7ChgDGvpf/
         gP+hfmkYQY18uaAD1oAnBsFnGhyyG4DLU8Qo5xWgbJ+2jjrkEiZ2+U/q2JSOR+zHhmIr
         Dyvv2xiqKbI4BcqNoy44m8OEQuDRsFPsYnhCyvVOXoMFCtGfX8DDC2d3qu1iiMbYXLls
         ee+JDTkgHrMKkI0wx8HVAJ3XcCnUtbtRRBeK7JliYrrKdNRxAkQtZXfL5rEUJZ5uIpKd
         c2ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712000424; x=1712605224;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qudJF0zUtr8KAClGNxT67zrcaNhIEzpGPECqC2LCVe8=;
        b=sVn7ru9UdQVj62hidf0+1J5H02dA7F3haDZgFqH3prXxl4uG8CqtFukomG9NRsRvzK
         BahTYgHn6hQBTEp1ksSRlEUajeouj15vOsRdyNs2jiXyGnGX04pNPwlp54mOcu6L7/7D
         kmIorvWMorDZnlQ8x47IUz/iyg5/S1DbSu7UftQ5SzNtpSMuV8qTIvXmMzrHjnu+gniy
         KPN3nsQKbD3egFnNVOXp9YtdyHmI8QiTWWSuWPJhbbg6xDSmjqlrOK+NffKIRL7RHA73
         4fFVe8qIt6UJXYTGkPuR9IWwERYxg3yPj1sfYVc2kJi1G1Gn2S1eHm7QtukGsrJKwKyZ
         t4lw==
X-Forwarded-Encrypted: i=1; AJvYcCXf7COl4AhiCU7LTSTZTwlMrS6AqbOCLmt0+PtCwR6oO4haEwRqSeu1tmCypEs7AtxCiNMmPJX5d6XDmUp2pdoKdgURscX/1A==
X-Gm-Message-State: AOJu0YzriaSGFr4k2jvYCVGKU149/Gi4RWgqL6VDPtFsXYaHUE//uuR9
	obvQ6J57DgX1yV9vl3Io2jE4WpNAgF0USLHOXIA72pcIy+TQqmiN2ODgG8vEGa91ttcV3qpGsvR
	sG6wDKgp1cDfYvWwm0E21g4HUDngGnQWwO8y5lQ==
X-Google-Smtp-Source: AGHT+IGy8JbeqrKLR573kb2fS/juZ212ZZ+qxU/h8IOYKm68M9c/r2fce6KYP/UTZJC0Ur6jDg5d/d0E4iOujDkQ0h8=
X-Received: by 2002:a2e:3019:0:b0:2d5:9b15:8064 with SMTP id
 w25-20020a2e3019000000b002d59b158064mr5698383ljw.14.1712000424152; Mon, 01
 Apr 2024 12:40:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401152549.131030308@linuxfoundation.org>
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 2 Apr 2024 01:10:11 +0530
Message-ID: <CA+G9fYuHZ9TCsGYMuxisqSFVoJ3brQx4C5Xk7=FJ+23PHbhKWw@mail.gmail.com>
Subject: Re: [PATCH 6.8 000/399] 6.8.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Netdev <netdev@vger.kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>, 
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 1 Apr 2024 at 21:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.8.3 release.
> There are 399 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 03 Apr 2024 15:24:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following kernel BUG: unable to handle page fault for address and followed
by Kernel panic - not syncing: Fatal exception in interrupt noticed
on the qemu-i386 running  selftests: net: pmtu.sh test case and the kernel
built with kselftest merge net configs with clang.

We are investigating this problem on qemu-i386.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

# selftests: net: pmtu.sh
# TEST: ipv4: PMTU exceptions                                         [ OK ]
# TEST: ipv4: PMTU exceptions - nexthop objects                       [ OK ]
# TEST: ipv6: PMTU exceptions                                         [ OK ]
<trim>
# TEST: ipv4: cleanup of cached exceptions                            [ OK ]
# TEST: ipv4: cleanup of cached exceptions - nexthop objects          [ OK ]
# TEST: ipv6: cleanup of cached exceptions                            [ OK ]
# TEST: ipv6: cleanup of cached exceptions - nexthop objects          [ OK ]
<1>[  577.550133] BUG: unable to handle page fault for address: 26c2e000
<1>[  577.555420] #PF: supervisor read access in kernel mode
<1>[  577.555881] #PF: error_code(0x0000) - not-present page
<6>[  577.556265] *pde = 00000000
<4>[  577.558166] Oops: 0000 [#1] PREEMPT SMP
<4>[  577.559142] CPU: 1 PID: 59 Comm: kworker/u4:5 Not tainted 6.8.3-rc1 #1
<4>[  577.560387] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
<4>[  577.561517] Workqueue: netns cleanup_net
<4>[  577.563500] EIP: percpu_counter_add_batch+0x38/0xc0

<trim>

<4>[  577.569244] Call Trace:
<4>[  577.570414]  <SOFTIRQ>
<4>[  577.571182]  ? __die_body+0x56/0xa0
<4>[  577.571635]  ? __die+0x6b/0x80
<4>[  577.571877]  ? page_fault_oops+0x296/0x2e0
<4>[  577.572169]  ? kernelmode_fixup_or_oops+0xa0/0xb0
<4>[  577.572535]  ? __bad_area_nosemaphore+0x43/0x180
<4>[  577.572856]  ? bad_area_nosemaphore+0xd/0x20
<4>[  577.573186]  ? do_user_addr_fault+0x314/0x400
<4>[  577.573524]  ? exc_page_fault+0x49/0xa0
<4>[  577.573807]  ? pvclock_clocksource_read_nowd+0xec/0xec
<4>[  577.574143]  ? dst_release+0x60/0x60
<4>[  577.574408]  ? handle_exception+0x14b/0x14b
<4>[  577.574706]  ? dst_release+0x60/0x60
<4>[  577.574990]  ? pvclock_clocksource_read_nowd+0xec/0xec
<4>[  577.575340]  ? percpu_counter_add_batch+0x38/0xc0
<4>[  577.575664]  ? pvclock_clocksource_read_nowd+0xec/0xec
<4>[  577.576005]  ? percpu_counter_add_batch+0x38/0xc0
<4>[  577.576333]  ? dst_release+0x60/0x60
<4>[  577.576594]  dst_destroy+0x34/0xe0
<4>[  577.577017]  dst_destroy_rcu+0xb/0x10
<4>[  577.577298]  rcu_core+0x3f5/0x920
<4>[  577.577561]  rcu_core_si+0x8/0x10
<4>[  577.577803]  __do_softirq+0xa8/0x23e
<4>[  577.578088]  ? __lock_text_end+0x3/0x3
<4>[  577.578353]  do_softirq_own_stack+0x50/0x60
<4>[  577.578744]  </SOFTIRQ>
<4>[  577.578974]  ? sysvec_call_function_single+0x2c/0x2c
<4>[  577.579313]  irq_exit_rcu+0x3a/0x80
<4>[  577.579574]  sysvec_apic_timer_interrupt+0x1f/0x30
<4>[  577.579893]  handle_exception+0x14b/0x14b
<4>[  577.580315] EIP: rb_erase+0x1aa/0x270

<trim>

<4>[  577.581832]  ? sysvec_call_function_single+0x2c/0x2c
<4>[  577.582101]  ? sysvec_call_function_single+0x2c/0x2c
<4>[  577.582361]  ? rb_erase+0x1aa/0x270
<4>[  577.582631]  remove_proc_entry+0xce/0x1a0
<4>[  577.582959]  tcp4_proc_exit_net+0x10/0x20
<4>[  577.583251]  cleanup_net+0x1fb/0x350
<4>[  577.583515]  process_scheduled_works+0x1e1/0x3a0
<4>[  577.583837]  worker_thread+0x294/0x3c0
<4>[  577.584112]  kthread+0x13a/0x150
<4>[  577.584348]  ? pr_cont_work+0x180/0x180
<4>[  577.584624]  ? kthread_blkcg+0x30/0x30
<4>[  577.584892]  ? kthread_blkcg+0x30/0x30
<4>[  577.585175]  ret_from_fork+0x2b/0x40
<4>[  577.585433]  ret_from_fork_asm+0x12/0x18
<4>[  577.585734]  entry_INT80_32+0x108/0x108
<4>[  577.586133] Modules linked in: xfrm_user ipip bridge stp llc
geneve vxlan act_csum act_pedit cls_flower sch_prio xt_mark nft_compat
nf_tables libcrc32c sch_ingress act_mirred cls_basic sch_fq_codel vrf
macvtap macvlan tap ip_tables x_tables [last unloaded:
test_blackhole_dev]
<4>[  577.588292] CR2: 0000000026c2e000
<4>[  577.589067] ---[ end trace 0000000000000000 ]---
<4>[  577.589465] EIP: percpu_counter_add_batch+0x38/0xc0

<trim>

<0>[  577.592536] Kernel panic - not syncing: Fatal exception in interrupt
<0>[  577.598118] Kernel Offset: disabled
<0>[  577.598605] ---[ end Kernel panic - not syncing: Fatal exception
in interrupt ]---

Steps to reproduce:
-----
 - https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2eVRrC1WkGHyPnNFg2O7ZvT2Vgy/reproducer

Links:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.8.y/build/v6.8.2-400-gbffeaccf18b5/testrun/23255383/suite/log-parser-test/test/check-kernel-bug/log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.8.y/build/v6.8.2-400-gbffeaccf18b5/testrun/23255383/suite/log-parser-test/tests/
 - https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2eVRrC1WkGHyPnNFg2O7ZvT2Vgy


--
Linaro LKFT
https://lkft.linaro.org
