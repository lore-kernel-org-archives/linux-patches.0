Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC7F2D59FA
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 16:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765901247; cv=none; b=O8/QH79bv6LQ+J0W4rrwVshksdDdpf85OaNHiWEI0LMRhMvJNCfAKX3b79Z4PW52auhm0a9mQ+rWiqmhKJ3DbK0j6sJFBeZudWMgLjVuCfIuuKTJyYU1uc33BYhQFehNQl1vAWYcyXe4IHpGwNpZNZUUqFzW+UD1+BGPqC224WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765901247; c=relaxed/simple;
	bh=W1nYZmcKYzUO5XML6nNDgv6ZORF2qWFSdD8Hk27OtYk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HjYV0vje9dixNlvY+daOZiPPkbBH003ZMU0fRyuamCqhZ2CwAsjlRz2vlOjjWBBHVxLzNM0vJ3AxRCRIwS+w/+3Zd3kXM+LIdl9pfk9th9rcwIhC+Z45Z9TEXtN3tj9FzU0eHyatp9A1RYzJEjIWDjqLm9/DNu9WF75QU2uM8dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=sPBrEgE+; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="sPBrEgE+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1765901219; x=1766506019; i=rwarsow@gmx.de;
	bh=wOgMp7MWFA9oLsaKuWhl21+4QNYhSwkjh+MIlzwDhMs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=sPBrEgE+bEDtQeZCiwSz9ImFDcPlxUP78PerxiGNKxfX6y6lockqedV9o5iLyIAz
	 aQMJ9KT6KP43hGTvB2AXyz1KCzQIjxFZpJ3E2RSnv/DW3XYPgrhXFRj8x2svAdy7G
	 dfFMYvBAkH1y0yPkOob4RQEgAJ2eqo58vk5r5J+ylWuM6XakBNLkaazetss0aDid8
	 nmTCkRUkjZQ0c4aMcHDYnH8ziXobfIBMjSLnTrmysQ3RSZ+OEIxzW3TOVLOuz7+F8
	 0YvNxHl9Z2dIopM7pWUpuXpcYkGEutkN6PTkKc7NTCeIIPyrdwkdYNUmjzZ/oT6Ww
	 AOnedzejCfxpwobKmw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.34.243]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MsHnm-1vppJg4AaA-00s2PX; Tue, 16
 Dec 2025 17:06:59 +0100
Message-ID: <1056aea9-1977-440e-9ad3-8a0b8b746288@gmx.de>
Date: Tue, 16 Dec 2025 17:06:56 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/614] 6.18.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251216111401.280873349@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:DofNhiufZGrGjcYX4zeQUe8uaKibpRathx0IpaNU4wgFB28Wopz
 Oa4aXkBqKNVbrheAEXQgA0G3gDADLx8shSOO0jVA2pPvDv1T/wDKu4UZyzibhjYJPLZ9yOJ
 auTaTUyKkfdm4iLsr+e1DEjlJxZ7qJqV1G7dJY/PPl4whVbbwDn7jjoNolNaa0IoQOZehVm
 49eXPdouqg8D+0DqPB3TQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:WvBVwglKF1Q=;CFLFRoNGTqQu8eBG1uhkBvo1jE8
 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

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU), but *only*=20
when running GPU driver i915.

with GPU driver xe I get here:

[   14.391631] rfkill: input handler disabled
[   14.787149] ------------[ cut here ]------------
[   14.787153] refcount_t: underflow; use-after-free.
[   14.787167] WARNING: CPU: 10 PID: 2463 at lib/refcount.c:28=20
refcount_warn_saturate+0xbe/0x110
[   14.787174] Modules linked in: vboxnetadp(OE) vboxnetflt(OE)=20
vboxdrv(OE) rfcomm nf_conntrack_netbios_ns nf_conntrack_broadcast=20
nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet=20
nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat=20
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables bnep iwlmvm=20
mac80211 mei_hdcp mei_pxp btusb kvm_intel btintel iwlwifi bluetooth kvm=20
cfg80211 ecdh_generic irqbypass mei_me wmi_bmof mei nfnetlink xe=20
intel_vsec drm_suballoc_helper gpu_sched drm_gpuvm drm_exec i915=20
i2c_algo_bit drm_buddy drm_display_helper video wmi
[   14.787203] CPU: 10 UID: 60578 PID: 2463 Comm: pool-8 Tainted: G=20
U     OE       6.18.2-rc1_MY #1 PREEMPT(lazy)
[   14.787205] Tainted: [U]=3DUSER, [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODUL=
E
[   14.787206] Hardware name: ASUS System Product Name/ROG STRIX B560-G=20
GAMING WIFI, BIOS 2302 11/13/2024
[   14.787207] RIP: 0010:refcount_warn_saturate+0xbe/0x110
[   14.787210] Code: 02 01 e8 05 de 52 ff 0f 0b e9 7e ba a1 00 80 3d 8d=20
16 41 02 00 75 85 48 c7 c7 00 d5 f5 9e c6 05 7d 16 41 02 01 e8 e2 dd 52=20
ff <0f> 0b e9 5b ba a1 00 80 3d 6b 16 41 02 00 0f 85 5e ff ff ff 48 c7
[   14.787211] RSP: 0018:ffffa0ba88dbf918 EFLAGS: 00010246
[   14.787213] RAX: 0000000000000000 RBX: ffff900804a13800 RCX:=20
0000000000000027
[   14.787214] RDX: ffff900b4f917a88 RSI: 0000000000000001 RDI:=20
ffff900b4f917a80
[   14.787215] RBP: ffff90082578c000 R08: 0000000000000000 R09:=20
ffffa0ba88dbf7b0
[   14.787215] R10: ffffffff9fb451e8 R11: ffffffff9fa951e0 R12:=20
0000000000000000
[   14.787216] R13: ffffa0ba88dbf970 R14: ffff9008213f0218 R15:=20
0000000000000000
[   14.787217] FS:  0000000000000000(0000) GS:ffff900baedd9000(0000)=20
knlGS:0000000000000000
[   14.787218] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   14.787219] CR2: 00007fc6a725fed0 CR3: 000000011f3c5001 CR4:=20
0000000000770ef0
[   14.787220] PKRU: 55555554
[   14.787220] Call Trace:
[   14.787222]  <TASK>
[   14.787224]  xe_exec_queue_destroy+0x165/0x1a0 [xe]
[   14.787326]  xe_vm_close_and_put+0x1e3/0x950 [xe]
[   14.787414]  xe_file_close+0x108/0x1e0 [xe]
[   14.787463]  drm_file_free+0x238/0x2a0
[   14.787466]  drm_release_noglobal+0x78/0xc0
[   14.787468]  __fput+0xe6/0x2a0
[   14.787471]  task_work_run+0x5d/0x90
[   14.787473]  do_exit+0x273/0xa60
[   14.787476]  ? timerqueue_del+0x2e/0x60
[   14.787478]  ? __remove_hrtimer+0x41/0xb0
[   14.787480]  do_group_exit+0x2e/0xb0
[   14.787482]  ? hrtimer_cancel+0x21/0x40
[   14.787484]  get_signal+0x8b0/0x8f0
[   14.787485]  arch_do_signal_or_restart+0x8d/0x2a0
[   14.787489]  exit_to_user_mode_loop+0x80/0x170
[   14.787492]  do_syscall_64+0x1c5/0xfa0
[   14.787494]  ? __pfx_hrtimer_wakeup+0x10/0x10
[   14.787496]  ? __rseq_handle_notify_resume+0xa4/0x4d0
[   14.787499]  ? switch_fpu_return+0x4e/0xd0
[   14.787501]  ? do_syscall_64+0x1f8/0xfa0
[   14.787503]  ? __rseq_handle_notify_resume+0xa4/0x4d0
[   14.787504]  ? f_dupfd+0x62/0xa0
[   14.787506]  ? switch_fpu_return+0x4e/0xd0
[   14.787507]  ? do_syscall_64+0x1f8/0xfa0
[   14.787509]  ? __x64_sys_fcntl+0x96/0x110
[   14.787512]  ? do_syscall_64+0x7c/0xfa0
[   14.787514]  ? flush_tlb_func+0x119/0x380
[   14.787516]  ? sched_clock+0x10/0x30
[   14.787518]  ? sched_clock_cpu+0xf/0x230
[   14.787520]  ? __flush_smp_call_function_queue+0xae/0x410
[   14.787522]  ? sched_clock_cpu+0xf/0x230
[   14.787523]  ? irqtime_account_irq+0x3c/0xc0
[   14.787525]  ? clear_bhb_loop+0x40/0x90
[   14.787527]  ? clear_bhb_loop+0x40/0x90
[   14.787528]  ? clear_bhb_loop+0x40/0x90
[   14.787529]  ? clear_bhb_loop+0x40/0x90
[   14.787530]  entry_SYSCALL_64_after_hwframe+0x71/0x79
[   14.787532] RIP: 0033:0x7fa07a4ff34d
[   14.787540] Code: Unable to access opcode bytes at 0x7fa07a4ff323.
[   14.787541] RSP: 002b:00007f9f8bffe478 EFLAGS: 00000246 ORIG_RAX:=20
00000000000000ca
[   14.787543] RAX: fffffffffffffdfc RBX: 0000000000000001 RCX:=20
00007fa07a4ff34d
[   14.787544] RDX: 0000000000000002 RSI: 0000000000000080 RDI:=20
000055c50d821a20
[   14.787544] RBP: 00007f9f8bffe4e0 R08: 00007fa07b3c7000 R09:=20
000000000000000e
[   14.787545] R10: 00007f9f8bffe4a0 R11: 0000000000000246 R12:=20
00000000018ae951
[   14.787546] R13: 0000000000000001 R14: 0000000000000002 R15:=20
000055c50d821a10
[   14.787548]  </TASK>
[   14.787548] ---[ end trace 0000000000000000 ]---

=3D=3D=3D=3D

If I did the bisect correct, bisect-log:

# status: waiting for both good and bad commits
# good: [25442251cbda7590d87d8203a8dc1ddf2c93de61] Linux 6.18.1
git bisect good 25442251cbda7590d87d8203a8dc1ddf2c93de61
# status: waiting for bad commit, 1 good commit known
# bad: [103c79e44ce7c81882928abab98b96517a8bce88] Linux 6.18.2-rc1
git bisect bad 103c79e44ce7c81882928abab98b96517a8bce88
# bad: [d32e7ccac8c6afc6a3a46fa4e7cdf0568ee919bd] drm/msm: Fix NULL=20
pointer dereference in crashstate_get_vm_logs()
git bisect bad d32e7ccac8c6afc6a3a46fa4e7cdf0568ee919bd



Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
