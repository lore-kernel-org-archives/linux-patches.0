Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77459274B37;
	Wed, 17 Dec 2025 05:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765950453; cv=none; b=tzru+mCa6+nrZgsp538jw8bs//GtKIsDT51j9IZsTd8ND/d6fBW+sQRWncASyi7BhdWKCOtIm3aFviHOO2jvqkCxC1DGOH7tRtWo0KodGwXJeoOKZaNy1sPZIZg49m4B97I0gm4QSrbo4iwA35WNRIcHWjcXcR2sIxX0Z90AvVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765950453; c=relaxed/simple;
	bh=VsPWroj4FSnE4hIb0w51RWyICul6boitAKMB7f8k5wg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=th1H0wWNhQtpw5Yyg+WZoUAySA3rywj+knhKMBD97ROyqg2GtH5mChd03luI8NH5VVaKQWRdB+jM8vekyA65b37DV7opXtKicZ9VCAon3JeOPiWTfOXnt7NmbWOEV8yvRPtSNFxMITBxmRQrYDcNMUklea95f0smn0hEG1lavlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pAyUGZP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pAyUGZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148EFC4CEF5;
	Wed, 17 Dec 2025 05:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765950452;
	bh=VsPWroj4FSnE4hIb0w51RWyICul6boitAKMB7f8k5wg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0pAyUGZP+QQkNIJGSXuJgHdKFRhvU4vmyiVm11yZ2QvQ0GhLMzD/DvxkplBNbT9bl
	 mc2pQB5HsOCKENi/b3sRRKMSFKRo3shsci9r2XFy+k+c4MR8QfVRqV/uvAzbonMMHr
	 hsl2Heq0+6spsJ8FvntQwYpQRCNpkPw4aWBhWBj4=
Date: Wed, 17 Dec 2025 06:47:28 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ronald Warsow <rwarsow@gmx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, conor@kernel.org, hargar@microsoft.com,
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/614] 6.18.2-rc1 review
Message-ID: <2025121714-gory-cornhusk-eb87@gregkh>
References: <20251216111401.280873349@linuxfoundation.org>
 <1056aea9-1977-440e-9ad3-8a0b8b746288@gmx.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1056aea9-1977-440e-9ad3-8a0b8b746288@gmx.de>

On Tue, Dec 16, 2025 at 05:06:56PM +0100, Ronald Warsow wrote:
> Hi
> 
> no regressions here on x86_64 (RKL, Intel 11th Gen. CPU), but *only* when
> running GPU driver i915.
> 
> with GPU driver xe I get here:
> 
> [   14.391631] rfkill: input handler disabled
> [   14.787149] ------------[ cut here ]------------
> [   14.787153] refcount_t: underflow; use-after-free.
> [   14.787167] WARNING: CPU: 10 PID: 2463 at lib/refcount.c:28
> refcount_warn_saturate+0xbe/0x110
> [   14.787174] Modules linked in: vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE)
> rfcomm nf_conntrack_netbios_ns nf_conntrack_broadcast nft_fib_inet
> nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4
> nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack
> nf_defrag_ipv6 nf_defrag_ipv4 nf_tables bnep iwlmvm mac80211 mei_hdcp
> mei_pxp btusb kvm_intel btintel iwlwifi bluetooth kvm cfg80211 ecdh_generic
> irqbypass mei_me wmi_bmof mei nfnetlink xe intel_vsec drm_suballoc_helper
> gpu_sched drm_gpuvm drm_exec i915 i2c_algo_bit drm_buddy drm_display_helper
> video wmi
> [   14.787203] CPU: 10 UID: 60578 PID: 2463 Comm: pool-8 Tainted: G U     OE
> 6.18.2-rc1_MY #1 PREEMPT(lazy)
> [   14.787205] Tainted: [U]=USER, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
> [   14.787206] Hardware name: ASUS System Product Name/ROG STRIX B560-G
> GAMING WIFI, BIOS 2302 11/13/2024
> [   14.787207] RIP: 0010:refcount_warn_saturate+0xbe/0x110
> [   14.787210] Code: 02 01 e8 05 de 52 ff 0f 0b e9 7e ba a1 00 80 3d 8d 16
> 41 02 00 75 85 48 c7 c7 00 d5 f5 9e c6 05 7d 16 41 02 01 e8 e2 dd 52 ff <0f>
> 0b e9 5b ba a1 00 80 3d 6b 16 41 02 00 0f 85 5e ff ff ff 48 c7
> [   14.787211] RSP: 0018:ffffa0ba88dbf918 EFLAGS: 00010246
> [   14.787213] RAX: 0000000000000000 RBX: ffff900804a13800 RCX:
> 0000000000000027
> [   14.787214] RDX: ffff900b4f917a88 RSI: 0000000000000001 RDI:
> ffff900b4f917a80
> [   14.787215] RBP: ffff90082578c000 R08: 0000000000000000 R09:
> ffffa0ba88dbf7b0
> [   14.787215] R10: ffffffff9fb451e8 R11: ffffffff9fa951e0 R12:
> 0000000000000000
> [   14.787216] R13: ffffa0ba88dbf970 R14: ffff9008213f0218 R15:
> 0000000000000000
> [   14.787217] FS:  0000000000000000(0000) GS:ffff900baedd9000(0000)
> knlGS:0000000000000000
> [   14.787218] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   14.787219] CR2: 00007fc6a725fed0 CR3: 000000011f3c5001 CR4:
> 0000000000770ef0
> [   14.787220] PKRU: 55555554
> [   14.787220] Call Trace:
> [   14.787222]  <TASK>
> [   14.787224]  xe_exec_queue_destroy+0x165/0x1a0 [xe]
> [   14.787326]  xe_vm_close_and_put+0x1e3/0x950 [xe]
> [   14.787414]  xe_file_close+0x108/0x1e0 [xe]
> [   14.787463]  drm_file_free+0x238/0x2a0
> [   14.787466]  drm_release_noglobal+0x78/0xc0
> [   14.787468]  __fput+0xe6/0x2a0
> [   14.787471]  task_work_run+0x5d/0x90
> [   14.787473]  do_exit+0x273/0xa60
> [   14.787476]  ? timerqueue_del+0x2e/0x60
> [   14.787478]  ? __remove_hrtimer+0x41/0xb0
> [   14.787480]  do_group_exit+0x2e/0xb0
> [   14.787482]  ? hrtimer_cancel+0x21/0x40
> [   14.787484]  get_signal+0x8b0/0x8f0
> [   14.787485]  arch_do_signal_or_restart+0x8d/0x2a0
> [   14.787489]  exit_to_user_mode_loop+0x80/0x170
> [   14.787492]  do_syscall_64+0x1c5/0xfa0
> [   14.787494]  ? __pfx_hrtimer_wakeup+0x10/0x10
> [   14.787496]  ? __rseq_handle_notify_resume+0xa4/0x4d0
> [   14.787499]  ? switch_fpu_return+0x4e/0xd0
> [   14.787501]  ? do_syscall_64+0x1f8/0xfa0
> [   14.787503]  ? __rseq_handle_notify_resume+0xa4/0x4d0
> [   14.787504]  ? f_dupfd+0x62/0xa0
> [   14.787506]  ? switch_fpu_return+0x4e/0xd0
> [   14.787507]  ? do_syscall_64+0x1f8/0xfa0
> [   14.787509]  ? __x64_sys_fcntl+0x96/0x110
> [   14.787512]  ? do_syscall_64+0x7c/0xfa0
> [   14.787514]  ? flush_tlb_func+0x119/0x380
> [   14.787516]  ? sched_clock+0x10/0x30
> [   14.787518]  ? sched_clock_cpu+0xf/0x230
> [   14.787520]  ? __flush_smp_call_function_queue+0xae/0x410
> [   14.787522]  ? sched_clock_cpu+0xf/0x230
> [   14.787523]  ? irqtime_account_irq+0x3c/0xc0
> [   14.787525]  ? clear_bhb_loop+0x40/0x90
> [   14.787527]  ? clear_bhb_loop+0x40/0x90
> [   14.787528]  ? clear_bhb_loop+0x40/0x90
> [   14.787529]  ? clear_bhb_loop+0x40/0x90
> [   14.787530]  entry_SYSCALL_64_after_hwframe+0x71/0x79
> [   14.787532] RIP: 0033:0x7fa07a4ff34d
> [   14.787540] Code: Unable to access opcode bytes at 0x7fa07a4ff323.
> [   14.787541] RSP: 002b:00007f9f8bffe478 EFLAGS: 00000246 ORIG_RAX:
> 00000000000000ca
> [   14.787543] RAX: fffffffffffffdfc RBX: 0000000000000001 RCX:
> 00007fa07a4ff34d
> [   14.787544] RDX: 0000000000000002 RSI: 0000000000000080 RDI:
> 000055c50d821a20
> [   14.787544] RBP: 00007f9f8bffe4e0 R08: 00007fa07b3c7000 R09:
> 000000000000000e
> [   14.787545] R10: 00007f9f8bffe4a0 R11: 0000000000000246 R12:
> 00000000018ae951
> [   14.787546] R13: 0000000000000001 R14: 0000000000000002 R15:
> 000055c50d821a10
> [   14.787548]  </TASK>
> [   14.787548] ---[ end trace 0000000000000000 ]---
> 
> ====
> 
> If I did the bisect correct, bisect-log:
> 
> # status: waiting for both good and bad commits
> # good: [25442251cbda7590d87d8203a8dc1ddf2c93de61] Linux 6.18.1
> git bisect good 25442251cbda7590d87d8203a8dc1ddf2c93de61
> # status: waiting for bad commit, 1 good commit known
> # bad: [103c79e44ce7c81882928abab98b96517a8bce88] Linux 6.18.2-rc1
> git bisect bad 103c79e44ce7c81882928abab98b96517a8bce88
> # bad: [d32e7ccac8c6afc6a3a46fa4e7cdf0568ee919bd] drm/msm: Fix NULL pointer
> dereference in crashstate_get_vm_logs()
> git bisect bad d32e7ccac8c6afc6a3a46fa4e7cdf0568ee919bd

Is this also an issue with 6.19-rc1?  Are we missing something here?

thanks,

greg k-h

