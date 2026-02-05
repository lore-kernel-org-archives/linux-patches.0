Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F065F3033F6
	for <patches@lists.linux.dev>; Thu,  5 Feb 2026 06:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770271430; cv=pass; b=TG3rJVw5OYwFGaOcqKns2+JJkpotiG7igfCxnccIrb/lKenQCz110FYFbjLnxjW0sFIGA0JBsUnHFEntox081e0x4LbDWr/ZZ2ywgXYD/lXsE2KV5qNOTJ4XH38y3z5CF0xcd6EnCick70dE5tDsOM8+J2Q7TwT/YbfESBq+uvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770271430; c=relaxed/simple;
	bh=yRf5QJz+ArYgrZk2b1iVHtzuSq/jXO7soQC9UJFAiAQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PP879A4VOU0OQbD2uKvaI+ZbYfoRMvvCAAHkIzX+rpOeb5MQdf0s+4sZoG7sd7C/h2ccQ40/QN5SDh+u8JwAk3v0XAEBw5YhUe1dDwKf4VLUV7ZUgnKmTm5hbGEJ1CVeLd0hq3hn8nvmCJjWAZYpmCRYWhUDN8K9ippOU5W2tAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kwftg98Q; arc=pass smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kwftg98Q"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2b71515d8adso465322eec.1
        for <patches@lists.linux.dev>; Wed, 04 Feb 2026 22:03:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770271429; cv=none;
        d=google.com; s=arc-20240605;
        b=SeKUyjNQHMCZCHm+4/0sY6nIA9sTnwGxm3ivuz3SPMeeHUb95T5gEgKUwMSPnGZg8u
         EWptRLl799+yEdgTffUrPjB61ycVfUceJVSeSw8hhVHsKKqysJLz0O8yMldIDpjwaETR
         PZednEMkCctF/WCKP4HZA0gfBiwlpPBdUjjA/I53HhwQkXnQPHa2OaKi3foq4Gz2g2Ah
         WFpZ5dZRTg7i+WKaMf7YXgkNOWXgqUqrqT5zxOT9FPngBos+lQ9FZmW5NauiEhb0n4fR
         EvN4dwN5XXTr9nP8RZbTIJfSHYLYmCRRqqjARAFJKRfO1nSUk+XBsa3i30GNEWxYjTdN
         CNEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eNJl7tavEV6atrTBHdPf/LciTp7gZrFsEpexpP9y8es=;
        fh=H28eWXAW8mPA7+6w/7Ot3xci2fqXaQK9zprl0r7oqNE=;
        b=UGaR6aD1XUeXIRtilj8HrN32Q4krhBDPsf0iNAZjYqVzp1pCex0QlY6KRlVaFE9ler
         XX0ABbzuMPPFIWs+u1sIPW+ssyrmraF88vqjzoxz9qW3800yrqOWrDsmFfLT2DYQ5Vyc
         29vhVU1/cAnS/alcDVXhMKKXUpM0kbUfz7be7ftzZq7c31GzR3onYPNchMPLX5LZ5xX0
         zBUKKyHBDVMsDP2ScLJdlLKyNVa0ph/CKeJHisZIVJKN3YpnNFr7Zc1gGv20zx0y9ZEn
         sN32nq1UufRrV4E1Gn+Y47PxFjLkoai/F5k1cEHIe2KBsvTZ+Zu7yhdOBivy73DWmY1Y
         23uA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770271429; x=1770876229; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eNJl7tavEV6atrTBHdPf/LciTp7gZrFsEpexpP9y8es=;
        b=Kwftg98QyKN7mCrgRqwaoqmeeJ8az7t+GhfGwCvKMz/LqwNSMb/Ok5lb+hnkPDvfLs
         vCoQGm7CTZbCzts/bpoHTTiY1tkv3cQ0FmkQ7eHgzOqkdhQdOeMO7M8mftryFm4UD+p7
         X5EfXUrT8CjZNK8BAblW/1lnn8394Ek3/g4gawGWRp6gNCDoj5GPr/DWI+h5hfJRQZnl
         vqxbzIBTydZ/0X0ubaMRfJ17gwuI0LgppMumESdELU3JqgjfMZE9IJPnKkBpua82G5gT
         lzfnW3hFr6pabh12QJUiSz0R3u73BBORa2KmBFJrvDCw1uj+ZqkAZcsVAhuch6Wim1vR
         pIKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770271429; x=1770876229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eNJl7tavEV6atrTBHdPf/LciTp7gZrFsEpexpP9y8es=;
        b=wVWd+tJTmWJkbbX57lSgs3VQ1OZhcGr9scguqFIGHU5EFp2+kaByc3njqIEvitFaJR
         mdWvsmYufLhM8mW003IBaHRu/lplK3ozjLzBtHS5JKz+BnFwbY//cXydLlZwMC2DwRkU
         Rz5eCIkoYuHfkp22EVgYFlyid471r6ah5rJ8Rj8Zu/XWbvkSiz3AcYDSRqrU4hpwqlik
         Jh64m9Z+RW5wIs6O+c0ed2ykhn4PxiEzd4tokldCs7DlxbY71KsAsNytV/KLsNcVs8qr
         xS1rdLppoJaEw0JVyIHm82n1NfRB7KRjjLiWU4pk4t1avbXZjKJ4HYy8CWCb56I2WtUP
         HvSA==
X-Forwarded-Encrypted: i=1; AJvYcCVJJsrm2TuTxqYr36HdJf3yuzT/e+WgDRoYL9lsWk4bD33ytXnNcwli8oDM9BQel+KIb/2dzqR9@lists.linux.dev
X-Gm-Message-State: AOJu0YyaZfEqBbL3EbQdjbrXoN8dBFdaXPP+kd3wcDnTUFR7qtzLB4TK
	Zbmtu/mvtmJU9Qsz7tFGCw1vl/1Sn9feNv3bSPG5fFQgxmQllGnwB6EhnOBPpwAWTrgFlqKwtFK
	mUF8l9LslibzEO5bagxO15/EtuFzp1I8=
X-Gm-Gg: AZuq6aJ780ytjiDHB4aEqdK5bfs5oPHADlqPykN6Ae37407r8/S64eqdF0oqR4JU+Vk
	y387B+45QUf2qFGTcENFxkaGTyhQsajf3LpEbqfmyGtrOLACKQjQipHDNxKJdXDGs2kj/0CISQp
	cFomRjgvigdqxGqnTOSINpQUSacB3yAL8ZuCSN638xelaHHTK9P2kX4g0mE/paxuoXDMk9t3AYv
	61cQnhPmqRQcsYMDdZEjZSBLOcdJr5NwU0V+blAcITbHHoYrf7AFe9NypgwViW3BVN9DHQjWryA
	Qj7orsNNrEXO+nsaIaaf4P9i2XUpVTRsMxVmhNt3xpZ8xUc7u9dtGKjQuJEvMswRNY/3hdBOt/A
	j5drRmkD9c/sw7eTbGbewKQU3J4W61r/WBcTFZL5kMpOJJY3GSI2Znp+SQQ4Qw/ImVag+IQ97BO
	1FTRYbUw894cU=
X-Received: by 2002:a05:7301:2288:b0:2b7:ee0e:e9ce with SMTP id
 5a478bee46e88-2b8329c271bmr2196408eec.23.1770271428781; Wed, 04 Feb 2026
 22:03:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260204143851.857060534@linuxfoundation.org>
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Thu, 5 Feb 2026 07:03:35 +0100
X-Gm-Features: AZwV_QgW6b24UJ8A-g7ibD7baDN7yRiFfP_WsF6BwJcny-TXEXqMpthXvwqKLW8
Message-ID: <CADo9pHhsekHOpnLhy4BsRQT9G=pXzsvESkegqDu5UcV1i4PiOg@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/122] 6.18.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

running Arch Linux with the testing repos enabled:
https://archlinux.org/ https://archboot.com/
https://wiki.archlinux.org/title/Arch_Testing_Team

Den ons 4 feb. 2026 kl 16:38 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> This is the start of the stable review cycle for the 6.18.9 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 6.18.9-rc1
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
>     mptcp: avoid dup SUB_CLOSED events after disconnect
>
> Tejun Heo <tj@kernel.org>
>     sched_ext: Fix SCX_KICK_WAIT to work reliably
>
> Tejun Heo <tj@kernel.org>
>     sched_ext: Don't kick CPUs running higher classes
>
> Chen Ni <nichen@iscas.ac.cn>
>     net/sched: act_ife: convert comma to semicolon
>
> John Ogness <john.ogness@linutronix.de>
>     Revert "drm/nouveau/disp: Set drm_mode_config_funcs.atomic_(check|com=
mit)"
>
> Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
>     libbpf: Fix -Wdiscarded-qualifiers under C23
>
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     gpiolib: acpi: Fix potential out-of-boundary left shift
>
> Nicolin Chen <nicolinc@nvidia.com>
>     iommu/tegra241-cmdqv: Reset VCMDQ in tegra241_vcmdq_hw_init_user()
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu: Fix cond_exec handling in amdgpu_ib_schedule()
>
> Jon Doron <jond@wiz.io>
>     drm/amdgpu: fix NULL pointer dereference in amdgpu_gmc_filter_faults_=
remove
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu/gfx12: adjust KGQ reset sequence
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu/gfx12: fix wptr reset in KGQ init
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu/gfx11: adjust KGQ reset sequence
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu/gfx11: fix wptr reset in KGQ init
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu/gfx10: fix wptr reset in KGQ init
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu/soc21: fix xclk for APUs
>
> Yang Wang <kevinyang.wang@amd.com>
>     drm/amd/pm: fix smu v14 soft clock frequency setting issue
>
> Yang Wang <kevinyang.wang@amd.com>
>     drm/amd/pm: fix smu v13 soft clock frequency setting issue
>
> Johan Hovold <johan@kernel.org>
>     drm/imx/tve: fix probe device leak
>
> Johan Hovold <johan@kernel.org>
>     drm/msm/a6xx: fix bogus hwcg register updates
>
> Miguel Ojeda <ojeda@kernel.org>
>     drm/tyr: depend on `COMMON_CLK` to fix build error
>
> Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
>     drm/xe/xelp: Fix Wa_18022495364
>
> Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
>     drm: Do not allow userspace to trigger kernel warnings in drm_gem_cha=
nge_handle_ioctl()
>
> Tamir Duberstein <tamird@kernel.org>
>     scripts: generate_rust_analyzer: Add compiler_builtins -> core dep
>
> SeungJong Ha <engineer.jjhama@gmail.com>
>     scripts: generate_rust_analyzer: fix resolution of #[pin_data] macros
>
> Tamir Duberstein <tamird@kernel.org>
>     scripts: generate_rust_analyzer: compile sysroot with correct edition
>
> Onur =C3=96zkan <work@onurozkan.dev>
>     scripts: generate_rust_analyzer: remove sysroot assertion
>
> Tamir Duberstein <tamird@kernel.org>
>     scripts: generate_rust_analyzer: Add pin_init_internal deps
>
> Tamir Duberstein <tamird@kernel.org>
>     scripts: generate_rust_analyzer: Add pin_init -> compiler_builtins de=
p
>
> Alexandre Courbot <acourbot@nvidia.com>
>     rust: sync: refcount: always inline functions using build_assert with=
 arguments
>
> Miguel Ojeda <ojeda@kernel.org>
>     rust: sync: atomic: Provide stub for `rusttest` 32-bit hosts
>
> Alexandre Courbot <acourbot@nvidia.com>
>     rust: bits: always inline functions using build_assert with arguments
>
> Jibin Zhang <jibin.zhang@mediatek.com>
>     net: fix segmentation of forwarding fraglist GRO
>
> Kairui Song <kasong@tencent.com>
>     mm/shmem, swap: fix race of truncate and swap entry split
>
> Jane Chu <jane.chu@oracle.com>
>     mm/memory-failure: teach kill_accessing_process to accept hugetlb tai=
l page pfn
>
> robin.kuo <robin.kuo@mediatek.com>
>     mm, swap: restore swap_space attr aviod kernel panic
>
> Jane Chu <jane.chu@oracle.com>
>     mm/memory-failure: fix missing ->mf_stats count in hugetlb poison
>
> Pimyn Girgis <pimyn@google.com>
>     mm/kfence: randomize the freelist on initialization
>
> Qu Wenruo <wqu@suse.com>
>     btrfs: do not strictly require dirty metadata threshold for metadata =
writepages
>
> Jan Kara <jack@suse.cz>
>     flex_proportions: make fprop_new_period() hardirq safe
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
>     selftests: mptcp: join: fix local endp not being tracked
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
>     selftests: mptcp: check subflow errors in close events
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
>     selftests: mptcp: check no dup close events after error
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
>     mptcp: only reset subflow errors when propagated
>
> Andrey Ryabinin <ryabinin.a.a@gmail.com>
>     mm/kasan: fix KASAN poisoning in vrealloc()
>
> Robin Murphy <robin.murphy@arm.com>
>     gpio: rockchip: Stop calling pinctrl for set_direction
>
> Zhang Heng <zhangheng@kylinos.cn>
>     ALSA: hda/realtek: fix right sounds and mute/micmute LEDs for HP mach=
ine
>
> Ming Lei <ming.lei@redhat.com>
>     nvmet: fix race in nvmet_bio_done() leading to NULL pointer dereferen=
ce
>
> Kohei Enju <kohei@enjuk.jp>
>     efivarfs: fix error propagation in efivar_entry_get()
>
> Thomas Fourier <fourier.thomas@gmail.com>
>     scsi: qla2xxx: edif: Fix dma_free_coherent() size
>
> Chen Miao <chenmiao@openatom.club>
>     kbuild: rust: clean libpin_init_internal in mrproper
>
> Martin Larsson <martin.larsson@actia.se>
>     gpio: pca953x: mask interrupts in irq shutdown
>
> Zhang Heng <zhangheng@kylinos.cn>
>     ASoC: amd: yc: Add DMI quirk for Acer TravelMate P216-41-TCO
>
> Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
>     scsi: be2iscsi: Fix a memory leak in beiscsi_boot_get_sinfo()
>
> Fabio Estevam <festevam@gmail.com>
>     ASoC: fsl: imx-card: Do not force slot width to sample width
>
> Miguel Ojeda <ojeda@kernel.org>
>     rust: kbuild: give `--config-path` to `rustfmt` in `.rsi` target
>
> Hang Shu <m18080292938@163.com>
>     rust: rbtree: fix documentation typo in CursorMut peek_next method
>
> Han Gao <gaohan@iscas.ac.cn>
>     riscv: compat: fix COMPAT_UTS_MACHINE definition
>
> Takashi Sakamoto <o-takashi@sakamocchi.jp>
>     firewire: core: fix race condition against transaction list
>
> Steven Rostedt <rostedt@goodmis.org>
>     perf: sched: Fix perf crash with new is_user_task() helper
>
> Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
>     pinctrl: qcom: sm8350-lpass-lpi: Merge with SC7280 to fix I2S2 and SW=
R TX pins
>
> Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
>     pinctrl: meson: mark the GPIO controller as sleeping
>
> Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
>     pinctrl: lpass-lpi: implement .get_direction() for the GPIO driver
>
> Laveesh Bansal <laveeshb@laveeshbansal.com>
>     writeback: fix 100% CPU usage when dirtytime_expire_interval is 0
>
> Peter Zijlstra <peterz@infradead.org>
>     sched/deadline: Fix 'stuck' dl_server
>
> Peter Zijlstra <peterz@infradead.org>
>     sched/deadline: Document dl_server
>
> Shuicheng Lin <shuicheng.lin@intel.com>
>     drm/xe/nvm: Fix double-free on aux add failure
>
> Shuicheng Lin <shuicheng.lin@intel.com>
>     drm/xe/nvm: Manage nvm aux cleanup with devres
>
> Shuicheng Lin <shuicheng.lin@intel.com>
>     drm/xe/configfs: Fix is_bound() pci_dev lifetime
>
> Sai Sree Kartheek Adivi <s-adivi@ti.com>
>     dma/pool: distinguish between missing and exhausted atomic pools
>
> Shida Zhang <zhangshida@kylinos.cn>
>     bcache: fix I/O accounting leak in detached_dev_do_request
>
> Shida Zhang <zhangshida@kylinos.cn>
>     bcache: use bio cloning for detached device requests
>
> Shida Zhang <zhangshida@kylinos.cn>
>     bcache: fix improper use of bi_end_io
>
> Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>
>     of: reserved_mem: Allow reserved_mem framework detect "cma=3D" kernel=
 param
>
> Yuntao Wang <yuntao.wang@linux.dev>
>     of/reserved_mem: Simplify the logic of fdt_scan_reserved_mem_reg_node=
s()
>
> Ethan Zuo <yuxuan.zuo@outlook.com>
>     kbuild: Fix permissions of modules.builtin.modinfo
>
> Nathan Chancellor <nathan@kernel.org>
>     kbuild: rpm-pkg: Generate debuginfo package manually
>
> Doug Berger <opendmb@gmail.com>
>     gpio: brcmstb: correct hwirq to bank map
>
> Yang Wang <kevinyang.wang@amd.com>
>     drm/amd/pm: fix race in power state check before mutex lock
>
> Yuhao Huang <nekowong743@gmail.com>
>     gpio: virtuser: fix UAF in configfs release path
>
> Denis Sergeev <denserg.edu@gmail.com>
>     gpiolib: acpi: use BIT_ULL() for u64 mask in address space handler
>
> Tagir Garaev <tgaraev653@gmail.com>
>     ASoC: Intel: sof_es8336: fix headphone GPIO logic inversion
>
> Shuicheng Lin <shuicheng.lin@intel.com>
>     drm/xe: Skip address copy for sync-only execs
>
> Bard Liao <yung-chuan.liao@linux.intel.com>
>     ASoC: soc-acpi-intel-ptl-match: fix name_prefix of rt1320-2
>
> Kery Qi <qikeyu2017@gmail.com>
>     scsi: firewire: sbp-target: Fix overflow in sbp_make_tpg()
>
> Benjamin Berg <benjamin.berg@intel.com>
>     wifi: mac80211: correctly decode TTLM with default link map
>
> Benjamin Berg <benjamin.berg@intel.com>
>     wifi: mac80211: apply advertised TTLM from association response
>
> Benjamin Berg <benjamin.berg@intel.com>
>     wifi: mac80211: parse all TTLM entries
>
> Jianbo Liu <jianbol@nvidia.com>
>     net/mlx5e: Skip ESN replay window setup for IPsec crypto offload
>
> Parav Pandit <parav@nvidia.com>
>     net/mlx5: Fix vhca_id access call trace use before alloc
>
> Cosmin Ratiu <cratiu@nvidia.com>
>     net/mlx5: Initialize events outside devlink lock
>
> Shay Drory <shayd@nvidia.com>
>     net/mlx5: fs, Fix inverted cap check in tx flow table root disconnect
>
> Wei Fang <wei.fang@nxp.com>
>     net: phy: micrel: fix clk warning when removing the driver
>
> Daniel Zahka <daniel.zahka@gmail.com>
>     net/mlx5e: don't assume psp tx skbs are ipv6 csum handling
>
> Martin Kaiser <martin@kaiser.cx>
>     net: bridge: fix static key check
>
> Kuniyuki Iwashima <kuniyu@google.com>
>     nfc: nci: Fix race between rfkill and nci_unregister_device().
>
> Gal Pressman <gal@nvidia.com>
>     net/mlx5e: Account for netdev stats in ndo_get_stats64
>
> Mark Bloch <mbloch@nvidia.com>
>     net/mlx5e: TC, delete flows only for existing peers
>
> Jesse Brandeburg <jbrandeburg@cloudflare.com>
>     ice: stop counting UDP csum mismatch as rx_errors
>
> Aaron Ma <aaron.ma@canonical.com>
>     ice: Fix NULL pointer dereference in ice_vsi_set_napi_queues
>
> Kohei Enju <enjuk@amazon.com>
>     ixgbe: don't initialize aci lock in ixgbe_recovery_probe()
>
> Kohei Enju <enjuk@amazon.com>
>     ixgbe: fix memory leaks in the ixgbe_recovery_probe() path
>
> Nikolay Aleksandrov <razor@blackwall.org>
>     bonding: fix use-after-free due to enslave fail after slave array upd=
ate
>
> Kuniyuki Iwashima <kuniyu@google.com>
>     nfc: llcp: Fix memleak in nfc_llcp_send_ui_frame().
>
> Vivian Wang <wangruikang@iscas.ac.cn>
>     net: spacemit: Check for netif_carrier_ok() in emac_stats_update()
>
> Eric Dumazet <edumazet@google.com>
>     mptcp: fix race in mptcp_pm_nl_flush_addrs_doit()
>
> Kery Qi <qikeyu2017@gmail.com>
>     rocker: fix memory leak in rocker_world_port_post_fini()
>
> Zeng Chi <zengchi@kylinos.cn>
>     net/mlx5: Fix return type mismatch in mlx5_esw_vport_vhca_id()
>
> Kery Qi <qikeyu2017@gmail.com>
>     net: wwan: t7xx: fix potential skb->frags overflow in RX path
>
> Fernando Fernandez Mancera <fmancera@suse.de>
>     ipv6: use the right ifindex when replying to icmpv6 from localhost
>
> Zilin Guan <zilin@seu.edu.cn>
>     net: mvpp2: cls: Fix memory leak in mvpp2_ethtool_cls_rule_ins()
>
> Edward Cree <ecree.xilinx@gmail.com>
>     sfc: fix deadlock in RSS config read
>
> Eric Dumazet <edumazet@google.com>
>     bonding: annotate data-races around slave->last_rx
>
> Zilin Guan <zilin@seu.edu.cn>
>     octeon_ep: Fix memory leak in octep_device_setup()
>
> Justin Chen <justin.chen@broadcom.com>
>     net: bcmasp: fix early exit leak with fixed phy
>
> Marc Kleine-Budde <mkl@pengutronix.de>
>     can: gs_usb: gs_usb_receive_bulk_callback(): fix error message
>
> Zilin Guan <zilin@seu.edu.cn>
>     net/mlx5: Fix memory leak in esw_acl_ingress_lgcy_setup()
>
> Jianpeng Chang <jianpeng.chang.cn@windriver.com>
>     Bluetooth: MGMT: Fix memory leak in set_ssp_complete
>
> Jia-Hong Su <s11242586@gmail.com>
>     Bluetooth: hci_uart: fix null-ptr-deref in hci_uart_write_work
>
> Zilin Guan <zilin@seu.edu.cn>
>     can: at91_can: Fix memory leak in at91_can_probe()
>
> Qu Wenruo <wqu@suse.com>
>     btrfs: zlib: fix the folio leak on S390 hardware acceleration
>
> Amir Goldstein <amir73il@gmail.com>
>     readdir: require opt-in for d_type flags
>
>
> -------------
>
> Diffstat:
>
>  Makefile                                           |   7 +-
>  arch/arm64/configs/defconfig                       |   1 -
>  arch/riscv/include/asm/compat.h                    |   2 +-
>  drivers/bluetooth/hci_ldisc.c                      |   4 +-
>  drivers/firewire/core-transaction.c                |  19 +-
>  drivers/gpio/gpio-brcmstb.c                        |   8 +-
>  drivers/gpio/gpio-pca953x.c                        |   2 +
>  drivers/gpio/gpio-rockchip.c                       |   8 -
>  drivers/gpio/gpio-virtuser.c                       |   8 +-
>  drivers/gpio/gpiolib-acpi-core.c                   |  21 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c            |   7 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c             |   5 +-
>  drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   2 +-
>  drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |  25 +--
>  drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |  25 +--
>  drivers/gpu/drm/amd/amdgpu/soc21.c                 |   8 +-
>  drivers/gpu/drm/amd/pm/amdgpu_dpm.c                |   7 +-
>  drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h       |   1 +
>  drivers/gpu/drm/amd/pm/swsmu/inc/smu_v14_0.h       |   1 +
>  drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c     |   1 +
>  drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c     |   1 +
>  drivers/gpu/drm/drm_gem.c                          |  18 +-
>  drivers/gpu/drm/imx/ipuv3/imx-tve.c                |  13 ++
>  drivers/gpu/drm/msm/adreno/a6xx_catalog.c          |   2 -
>  drivers/gpu/drm/nouveau/nouveau_display.c          |   2 -
>  drivers/gpu/drm/tyr/Kconfig                        |   1 +
>  drivers/gpu/drm/xe/xe_configfs.c                   |   3 +-
>  drivers/gpu/drm/xe/xe_device.c                     |   2 -
>  drivers/gpu/drm/xe/xe_exec.c                       |   6 +-
>  drivers/gpu/drm/xe/xe_lrc.c                        |   2 +-
>  drivers/gpu/drm/xe/xe_nvm.c                        |  55 +++---
>  drivers/gpu/drm/xe/xe_nvm.h                        |   2 -
>  drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c     |   3 +
>  drivers/md/bcache/bcache.h                         |   9 +
>  drivers/md/bcache/request.c                        |  82 ++++----
>  drivers/md/bcache/super.c                          |  12 +-
>  drivers/net/bonding/bond_main.c                    |  28 +--
>  drivers/net/bonding/bond_options.c                 |   8 +-
>  drivers/net/can/at91_can.c                         |   2 +-
>  drivers/net/can/usb/gs_usb.c                       |   4 +-
>  drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c   |   5 +-
>  drivers/net/ethernet/intel/ice/ice_lib.c           |  10 +-
>  drivers/net/ethernet/intel/ice/ice_main.c          |   1 -
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  26 +--
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c     |   2 +-
>  .../net/ethernet/marvell/octeon_ep/octep_main.c    |   2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |  16 ++
>  .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   3 +-
>  .../mellanox/mlx5/core/en_accel/psp_rxtx.c         |  17 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  20 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  19 +-
>  .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      |   2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |   3 +-
>  drivers/net/ethernet/mellanox/mlx5/core/main.c     |  36 ++--
>  .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   1 +
>  .../ethernet/mellanox/mlx5/core/sf/dev/driver.c    |   1 +
>  drivers/net/ethernet/rocker/rocker_main.c          |   5 +-
>  drivers/net/ethernet/sfc/mcdi_filters.c            |   7 +-
>  drivers/net/ethernet/spacemit/k1_emac.c            |  34 +++-
>  drivers/net/phy/micrel.c                           |  17 +-
>  drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c         |   9 +-
>  drivers/nvme/target/io-cmd-bdev.c                  |   3 +-
>  drivers/of/of_reserved_mem.c                       |  44 +++--
>  drivers/pinctrl/meson/pinctrl-meson.c              |   2 +-
>  drivers/pinctrl/pinctrl-rockchip.c                 |   9 +-
>  drivers/pinctrl/qcom/Kconfig                       |  15 +-
>  drivers/pinctrl/qcom/Makefile                      |   1 -
>  drivers/pinctrl/qcom/pinctrl-lpass-lpi.c           |  17 ++
>  drivers/pinctrl/qcom/pinctrl-sc7280-lpass-lpi.c    |   3 +
>  drivers/pinctrl/qcom/pinctrl-sm8350-lpass-lpi.c    | 151 --------------
>  drivers/scsi/be2iscsi/be_mgmt.c                    |   1 +
>  drivers/scsi/qla2xxx/qla_os.c                      |   2 +-
>  drivers/target/sbp/sbp_target.c                    |   4 +-
>  fs/btrfs/disk-io.c                                 |  22 ---
>  fs/btrfs/extent_io.c                               |   3 +-
>  fs/btrfs/extent_io.h                               |   3 +-
>  fs/btrfs/zlib.c                                    |   1 +
>  fs/efivarfs/vars.c                                 |   2 +-
>  fs/fs-writeback.c                                  |  14 +-
>  fs/readdir.c                                       |   3 +
>  include/linux/cma.h                                |   9 +
>  include/linux/fs.h                                 |   6 +-
>  include/linux/kasan.h                              |  14 ++
>  include/linux/sched.h                              |   5 +
>  include/net/bonding.h                              |  13 +-
>  include/net/nfc/nfc.h                              |   2 +
>  kernel/dma/contiguous.c                            |  16 +-
>  kernel/dma/pool.c                                  |   7 +-
>  kernel/events/callchain.c                          |   2 +-
>  kernel/events/core.c                               |   6 +-
>  kernel/sched/deadline.c                            | 206 +++++++++++++++=
++++
>  kernel/sched/ext.c                                 |  57 +++---
>  kernel/sched/ext_internal.h                        |   6 +-
>  lib/flex_proportions.c                             |   5 +-
>  mm/kasan/common.c                                  |  21 ++
>  mm/kfence/core.c                                   |  23 ++-
>  mm/memory-failure.c                                |  99 ++++++----
>  mm/shmem.c                                         |  45 +++--
>  mm/swap.h                                          |   2 +-
>  mm/swap_state.c                                    |   3 +-
>  mm/vmalloc.c                                       |   7 +-
>  net/bluetooth/mgmt.c                               |   3 +
>  net/bridge/br_input.c                              |   2 +-
>  net/core/filter.c                                  |   2 +
>  net/ipv4/tcp_offload.c                             |   3 +-
>  net/ipv4/udp_offload.c                             |   3 +-
>  net/ipv6/icmp.c                                    |   4 +-
>  net/ipv6/tcpv6_offload.c                           |   3 +-
>  net/mac80211/ieee80211_i.h                         |   2 -
>  net/mac80211/mlme.c                                | 217 ++++++++++++---=
------
>  net/mptcp/pm_kernel.c                              |  16 +-
>  net/mptcp/protocol.c                               |  13 +-
>  net/nfc/core.c                                     |  27 ++-
>  net/nfc/llcp_commands.c                            |  17 +-
>  net/nfc/llcp_core.c                                |   4 +-
>  net/nfc/nci/core.c                                 |   4 +-
>  net/sched/act_ife.c                                |   6 +-
>  rust/kernel/bits.rs                                |   6 +-
>  rust/kernel/rbtree.rs                              |   2 +-
>  rust/kernel/sync/atomic/predefine.rs               |  11 ++
>  rust/kernel/sync/refcount.rs                       |   3 +-
>  scripts/Makefile.build                             |   2 +-
>  scripts/Makefile.vmlinux                           |   3 +-
>  scripts/generate_rust_analyzer.py                  |  40 +++-
>  scripts/package/kernel.spec                        |  65 +++---
>  sound/hda/codecs/realtek/alc269.c                  |   1 +
>  sound/soc/amd/yc/acp6x-mach.c                      |   8 +
>  sound/soc/fsl/imx-card.c                           |   1 -
>  sound/soc/intel/boards/sof_es8336.c                |   2 +-
>  sound/soc/intel/common/soc-acpi-intel-ptl-match.c  |   2 +-
>  tools/lib/bpf/libbpf.c                             |   7 +-
>  tools/testing/selftests/net/mptcp/mptcp_join.sh    |  81 +++++++-
>  133 files changed, 1285 insertions(+), 784 deletions(-)
>
>
>
