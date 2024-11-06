Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2D918B482
	for <patches@lists.linux.dev>; Wed,  6 Nov 2024 13:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730900846; cv=none; b=IKv8HyLFzVGBw+QWuobA0odeAPtb+BbPudEQ4PRQKPEu1YXaQLNtFwAJXdoMaUeIkW1he0hgsSftNdUNghhMx+2ObvF/hqKSkqmIGgbWzuIdiBif8eYvujl9B1TI4b7ugXUdT+QTBHFZ4t+Ruv/17CxnVPSkLi2rCf2ppbu8M3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730900846; c=relaxed/simple;
	bh=uS/tecamDu9yZ8uf+RwFPqw3LRwCWhVtxYINWClGXrQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sZM/7ZU8CQXQ9spbOvq75H4ODejhS1AFsdDypKjlVDKrPw6rIIRZF+gwMwL7qaXlOTHZJhHOoeP4qnndc54pgD3AewmQGVMj9MQk9RFdUgtElbHX4ZoNf+i0XzXjjoV18eRsAuA2Ph3sol6HN8eGpyJE8BTGLoyjBJgyDGhgWac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PiURYBhN; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PiURYBhN"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2e2d1858cdfso4885484a91.1
        for <patches@lists.linux.dev>; Wed, 06 Nov 2024 05:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730900843; x=1731505643; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YyZQzDAbRfCDgj4htGcmIjJlMdDA9TzaUCgK/aXR2co=;
        b=PiURYBhNo76qzp0g5LJS9i4k0e4qYt+8qWN1ydkS320t85dCxXnDC9qQByuhiv0QEW
         JTuJQBJY6Z3D9fIweAa4H4KTnUGZnegjL6Ulo13m73W4HOL+kuroZPbCGmv5+ax7I1MC
         O3aPznFN4zMHTbF9GbZJOKTTnEkRxJCQ/0UM/OwPnWwnh3DuyFH4v7j3TA7s7j4neJC4
         z9I/YmoB9mNHT0gNNXbskHSw5ytWTUItgVzgM9NeWPSUrP4tBKxEZz1dwRObIQmiz9j0
         g5kSSqh/UtBWL5NHrzGTE0C+5PKu2obSf0KQzHwiL+25bcSnW+kEf7mS6Uz9RJ3PZiIn
         Xqrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730900843; x=1731505643;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YyZQzDAbRfCDgj4htGcmIjJlMdDA9TzaUCgK/aXR2co=;
        b=jFTAJIlhpIGXYyBkDpTr9Rs+mj1Ubx8MNesciGbQWDS+cJBszYIlutFeMm1rX+/XcV
         9F85DvblBS1PWmrXEAZtlAFr1nxhQvX6f6w74YwKo6HxwJlY2A9JjXrhjnj2NiyNTUwK
         qDTS8wysXME++TtHGL0mhRO9EUctqwEZkDOuFjfHZhBoIfglL4+njughS1IiEx9SLxvU
         WT5qcTQTb2xRwY8Jy/t2rr5R0jGYS0/fS7nH8PW1ec7mpTMHBvSJWNgkMHXFdQegehQ+
         NV9XQX4TVrj5ihDHsSQrLA/6m0j2ZJRGtDS5cIqqTvFUulXQrs5JrM2vuKuZE6DswHt0
         19IA==
X-Forwarded-Encrypted: i=1; AJvYcCWmk3fMkWIRMcZwmwXSwm9vNtPsnN1aMD4XOiIjCxBhrOfp4VSw+8npRoTYQuvFeS+LEqKyIokr@lists.linux.dev
X-Gm-Message-State: AOJu0Yyev11yTrzcIi1z9omlaCKXSnHopdJvlfw8SFPxe+faVZwHhSJi
	gfyEvuk/v4LPrgcFxuwmM3HgH96v+pGeIwyDLNFufrwgsMO5S/89q6zeJZ2n4RRPqEUE2fyaMUr
	cYF/aL792OEbabs6xSjaMImg8dbo=
X-Google-Smtp-Source: AGHT+IEoV87nderKSH/oCvRryWsvmzCHXP58seiO8nTFGix4RZOTEfwC3iYN75RmaCSKcvaTlvPHk5+M+HnH9uQnhGw=
X-Received: by 2002:a17:90a:a011:b0:2e9:2e69:ee10 with SMTP id
 98e67ed59e1d1-2e92e6a02dcmr28025900a91.19.1730900842605; Wed, 06 Nov 2024
 05:47:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241106120319.234238499@linuxfoundation.org>
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Wed, 6 Nov 2024 14:47:09 +0100
Message-ID: <CADo9pHghs9XXXJqG20Q+a4RM0594MajdW+0+ZVszu879=KNBEA@mail.gmail.com>
Subject: Re: [PATCH 6.11 000/245] 6.11.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, 
	broonie@kernel.org
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

Den ons 6 nov. 2024 kl 13:26 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> This is the start of the stable review cycle for the 6.11.7 release.
> There are 245 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.11.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.11.y
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
>     Linux 6.11.7-rc1
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu: handle default profile on on devices without fullscreen 3=
D
>
> Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
>     fs/ntfs3: Sequential field availability check in mi_enum_attr()
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu/swsmu: default to fullscreen 3D profile for dGPUs
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu/swsmu: fix ordering for setting workload_mask
>
> Tejas Upadhyay <tejas.upadhyay@intel.com>
>     drm/xe: Write all slices if its mcr register
>
> Tejas Upadhyay <tejas.upadhyay@intel.com>
>     drm/xe: Define STATELESS_COMPRESSION_CTRL as mcr register
>
> Shekhar Chauhan <shekhar.chauhan@intel.com>
>     drm/xe/xe2: Add performance turning changes
>
> Akshata Jahagirdar <akshata.jahagirdar@intel.com>
>     drm/xe/xe2: Introduce performance changes
>
> Sai Teja Pottumuttu <sai.teja.pottumuttu@intel.com>
>     drm/xe/xe2hpg: Introduce performance tuning changes for Xe2_HPG
>
> Tejas Upadhyay <tejas.upadhyay@intel.com>
>     drm/xe: Move enable host l2 VRAM post MCR init
>
> Tejas Upadhyay <tejas.upadhyay@intel.com>
>     drm/xe/xe2hpg: Add Wa_15016589081
>
> Thomas Zimmermann <tzimmermann@suse.de>
>     drm/xe: Support 'nomodeset' kernel command-line option
>
> Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
>     drm/i915/display: Don't enable decompression on Xe2 with Tile4
>
> Jouni H=C3=B6gander <jouni.hogander@intel.com>
>     drm/i915/psr: Prevent Panel Replay if CRC calculation is enabled
>
> Jani Nikula <jani.nikula@intel.com>
>     drm/xe/display: drop unused rawclk_freq and RUNTIME_INFO()
>
> Jani Nikula <jani.nikula@intel.com>
>     drm/i915: move rawclk from runtime to display runtime info
>
> Suraj Kandpal <suraj.kandpal@intel.com>
>     drm/i915/pps: Disable DPLS_GATING around pps sequence
>
> Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>
>     drm/i915/display/dp: Compute AS SDP when vrr is also enabled
>
> Suraj Kandpal <suraj.kandpal@intel.com>
>     drm/i915/dp: Clear VSC SDP during post ddi disable routine
>
> Suraj Kandpal <suraj.kandpal@intel.com>
>     drm/i915/hdcp: Add encoder check in hdcp2_get_capability
>
> Suraj Kandpal <suraj.kandpal@intel.com>
>     drm/i915/hdcp: Add encoder check in intel_hdcp_get_capability
>
> Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>
>     drm/i915/display: WA for Re-initialize dispcnlunitt1 xosc clock
>
> Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>
>     drm/i915/display: Cache adpative sync caps to use it later
>
> Matthew Auld <matthew.auld@intel.com>
>     drm/i915: disable fbc due to Wa_16023588340
>
> Gustavo Sousa <gustavo.sousa@intel.com>
>     drm/i915: Skip programming FIA link enable bits for MTL+
>
> Johan Hovold <johan+linaro@kernel.org>
>     arm64: dts: qcom: x1e80100: fix PCIe4 and PCIe6a PHY clocks
>
> Abel Vesa <abel.vesa@linaro.org>
>     arm64: dts: qcom: x1e80100: Add Broadcast_AND region in LLCC block
>
> Haibo Chen <haibo.chen@nxp.com>
>     arm64: dts: imx8ulp: correct the flexspi compatible string
>
> Johan Hovold <johan+linaro@kernel.org>
>     arm64: dts: qcom: x1e80100-crd: fix nvme regulator boot glitch
>
> Johan Hovold <johan+linaro@kernel.org>
>     arm64: dts: qcom: x1e80100-qcp: fix nvme regulator boot glitch
>
> Johan Hovold <johan+linaro@kernel.org>
>     arm64: dts: qcom: x1e80100: fix PCIe4 interconnect
>
> Johan Hovold <johan+linaro@kernel.org>
>     arm64: dts: qcom: x1e80100-vivobook-s15: fix nvme regulator boot glit=
ch
>
> Konrad Dybcio <konradybcio@kernel.org>
>     arm64: dts: qcom: x1e80100: Fix up BAR spaces
>
> Johan Hovold <johan+linaro@kernel.org>
>     arm64: dts: qcom: x1e80100-yoga-slim7x: fix nvme regulator boot glitc=
h
>
> Fabien Parent <fabien.parent@linaro.org>
>     arm64: dts: qcom: msm8939: revert use of APCS mbox for RPM
>
> Conor Dooley <conor.dooley@microchip.com>
>     riscv: dts: starfive: disable unused csi/camss nodes
>
> E Shattow <e@freeshell.de>
>     riscv: dts: starfive: Update ethernet phy0 delay parameter values for=
 Star64
>
> Yu Zhao <yuzhao@google.com>
>     mm: multi-gen LRU: use {ptep,pmdp}_clear_young_notify()
>
> Zhiguo Jiang <justinjiang@vivo.com>
>     mm: shrink skip folio mapped by an exiting process
>
> Yu Zhao <yuzhao@google.com>
>     mm: multi-gen LRU: remove MM_LEAF_OLD and MM_NONLEAF_TOTAL stats
>
> Yuanchu Xie <yuanchu@google.com>
>     mm: multi-gen LRU: ignore non-leaf pmd_young for force_scan=3Dtrue
>
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     Input: fix regression when re-registering input handlers
>
> Vlastimil Babka <vbabka@suse.cz>
>     mm, mmap: limit THP alignment of anonymous mappings to PMD-aligned si=
zes
>
> Gregory Price <gourry@gourry.net>
>     vmscan,migrate: fix page count imbalance on node stats when demoting =
pages
>
> Johan Hovold <johan+linaro@kernel.org>
>     gpiolib: fix debugfs dangling chip separator
>
> Johan Hovold <johan+linaro@kernel.org>
>     gpiolib: fix debugfs newline separators
>
> Filipe Manana <fdmanana@suse.com>
>     btrfs: fix defrag not merging contiguous extents due to merged extent=
 maps
>
> Filipe Manana <fdmanana@suse.com>
>     btrfs: fix extent map merging not happening for adjacent extents
>
> Jens Axboe <axboe@kernel.dk>
>     io_uring/rw: fix missing NOWAIT check for O_DIRECT start write
>
> Matthew Brost <matthew.brost@intel.com>
>     drm/xe: Don't short circuit TDR on jobs not started
>
> Matthew Brost <matthew.brost@intel.com>
>     drm/xe: Add mmio read before GGTT invalidate
>
> Michal Wajdeczko <michal.wajdeczko@intel.com>
>     drm/xe: Kill regs/xe_sriov_regs.h
>
> Michal Wajdeczko <michal.wajdeczko@intel.com>
>     drm/xe: Fix register definition order in xe_regs.h
>
> Jinjie Ruan <ruanjinjie@huawei.com>
>     drm/tests: hdmi: Fix memory leaks in drm_display_mode_from_cea_vic()
>
> Jinjie Ruan <ruanjinjie@huawei.com>
>     drm/connector: hdmi: Fix memory leak in drm_display_mode_from_cea_vic=
()
>
> Jinjie Ruan <ruanjinjie@huawei.com>
>     drm/tests: helpers: Add helper for drm_display_mode_from_cea_vic()
>
> Andrey Konovalov <andreyknvl@gmail.com>
>     kasan: remove vmalloc_percpu test
>
> Keith Busch <kbusch@kernel.org>
>     nvme: re-fix error-handling for io_uring nvme-passthrough
>
> Vitaliy Shevtsov <v.shevtsov@maxima.ru>
>     nvmet-auth: assign dh_key to NULL after kfree_sensitive
>
> Christoffer Sandberg <cs@tuxedo.de>
>     ALSA: hda/realtek: Fix headset mic on TUXEDO Stellaris 16 Gen6 mb1
>
> Christoffer Sandberg <cs@tuxedo.de>
>     ALSA: hda/realtek: Fix headset mic on TUXEDO Gemini 17 Gen3
>
> Christoph Hellwig <hch@lst.de>
>     xfs: fix finding a last resort AG in xfs_filestream_pick_ag
>
> Andrzej Kacprowski <Andrzej.Kacprowski@intel.com>
>     accel/ivpu: Fix NOC firewall interrupt handling
>
> Zhihao Cheng <chengzhihao1@huawei.com>
>     btrfs: fix use-after-free of block device file in __btrfs_free_extra_=
devids()
>
> Matt Johnston <matt@codeconstruct.com.au>
>     mctp i2c: handle NULL header address
>
> Gregory Price <gourry@gourry.net>
>     resource,kexec: walk_system_ram_res_rev must retain resource flags
>
> Edward Adam Davis <eadavis@qq.com>
>     ocfs2: pass u64 to ocfs2_truncate_inline maybe overflow
>
> Sabyrzhan Tasbolatov <snovitoll@gmail.com>
>     x86/traps: move kmsan check after instrumentation_begin
>
> Gatlin Newhouse <gatlin.newhouse@gmail.com>
>     x86/traps: Enable UBSAN traps on x86
>
> Matt Fleming <mfleming@cloudflare.com>
>     mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserv=
es
>
> Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>     fork: only invoke khugepaged, ksm hooks if no error
>
> Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>     fork: do not invoke uffd on fork if error occurs
>
> Alexander Usyskin <alexander.usyskin@intel.com>
>     mei: use kvmalloc for read buffer
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
>     mptcp: init: protect sched with rcu_read_lock
>
> Jarkko Sakkinen <jarkko@kernel.org>
>     tpm: Lazily flush the auth session
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu/smu13: fix profile reporting
>
> Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
>     drm/amd/pm: Vangogh: Fix kernel memory out of bounds write
>
> Jarkko Sakkinen <jarkko@kernel.org>
>     tpm: Rollback tpm2_load_null()
>
> Jarkko Sakkinen <jarkko@kernel.org>
>     tpm: Return tpm2_sessions_init() when null key creation fails
>
> Hugh Dickins <hughd@google.com>
>     iov_iter: fix copy_page_from_iter_atomic() if KMAP_LOCAL_FORCE_MAP
>
> Benjamin Segall <bsegall@google.com>
>     posix-cpu-timers: Clear TICK_DEP_BIT_POSIX_TIMER on clone
>
> Shawn Wang <shawnwang@linux.alibaba.com>
>     sched/numa: Fix the potential null pointer dereference in task_numa_w=
ork()
>
> Dan Williams <dan.j.williams@intel.com>
>     cxl/acpi: Ensure ports ready at cxl_acpi_probe() return
>
> Dan Williams <dan.j.williams@intel.com>
>     cxl/port: Fix cxl_bus_rescan() vs bus_rescan_devices()
>
> Peter Wang <peter.wang@mediatek.com>
>     scsi: ufs: core: Fix another deadlock during RTC update
>
> Chunyan Zhang <zhangchunyan@iscas.ac.cn>
>     riscv: Remove duplicated GET_RM
>
> Chunyan Zhang <zhangchunyan@iscas.ac.cn>
>     riscv: Remove unused GENERATING_ASM_OFFSETS
>
> WangYuli <wangyuli@uniontech.com>
>     riscv: Use '%u' to format the output of 'cpu'
>
> Miquel Sabat=C3=A9 Sol=C3=A0 <mikisabate@gmail.com>
>     riscv: Prevent a bad reference count on CPU nodes
>
> Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
>     riscv: efi: Set NX compat flag in PE/COFF header
>
> Kailang Yang <kailang@realtek.com>
>     ALSA: hda/realtek: Limit internal Mic boost on Dell platform
>
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     Input: edt-ft5x06 - fix regmap leak when probe fails
>
> Alexandre Ghiti <alexghiti@rivosinc.com>
>     riscv: vdso: Prevent the compiler from inserting calls to memset()
>
> Frank Li <Frank.Li@nxp.com>
>     spi: spi-fsl-dspi: Fix crash when not using GPIO chip select
>
> Naohiro Aota <naohiro.aota@wdc.com>
>     btrfs: fix error propagation of split bios
>
> Qu Wenruo <wqu@suse.com>
>     btrfs: merge btrfs_orig_bbio_end_io() into btrfs_bio_end_io()
>
> Richard Zhu <hongxing.zhu@nxp.com>
>     phy: freescale: imx8m-pcie: Do CMN_RST just before PHY PLL lock check
>
> Chen Ridong <chenridong@huawei.com>
>     cgroup/bpf: use a dedicated workqueue for cgroup bpf destruction
>
> Xinyu Zhang <xizhang@purestorage.com>
>     block: fix sanity checks in blk_rq_map_user_bvec
>
> Ben Chuang <ben.chuang@genesyslogic.com.tw>
>     mmc: sdhci-pci-gli: GL9767: Fix low power mode in the SD Express proc=
ess
>
> Ben Chuang <ben.chuang@genesyslogic.com.tw>
>     mmc: sdhci-pci-gli: GL9767: Fix low power mode on the set clock funct=
ion
>
> Dan Williams <dan.j.williams@intel.com>
>     cxl/port: Fix CXL port initialization order when the subsystem is bui=
lt-in
>
> Dan Williams <dan.j.williams@intel.com>
>     cxl/port: Fix use-after-free, permit out-of-order decoder shutdown
>
> Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
>     soc: qcom: pmic_glink: Handle GLINK intent allocation rejections
>
> Gil Fine <gil.fine@linux.intel.com>
>     thunderbolt: Honor TMU requirements in the domain when setting TMU mo=
de
>
> Mika Westerberg <mika.westerberg@linux.intel.com>
>     thunderbolt: Fix KASAN reported stack out-of-bounds read in tb_retime=
r_scan()
>
> Conor Dooley <conor.dooley@microchip.com>
>     firmware: microchip: auto-update: fix poll_complete() to not report s=
purious timeout errors
>
> Chen Ridong <chenridong@huawei.com>
>     mm: shrinker: avoid memleak in alloc_shrinker_info
>
> Wladislav Wiebe <wladislav.kw@gmail.com>
>     tools/mm: -Werror fixes in page-types/slabinfo
>
> Jeongjun Park <aha310510@gmail.com>
>     mm: shmem: fix data-race in shmem_getattr()
>
> Yunhui Cui <cuiyunhui@bytedance.com>
>     RISC-V: ACPI: fix early_ioremap to early_memremap
>
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>     nilfs2: fix potential deadlock with newly created symlinks
>
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>     nilfs2: fix kernel bug due to missing clearing of checked flag
>
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     iio: light: veml6030: fix microlux value calculation
>
> Jinjie Ruan <ruanjinjie@huawei.com>
>     iio: gts-helper: Fix memory leaks in iio_gts_build_avail_scale_table(=
)
>
> Jinjie Ruan <ruanjinjie@huawei.com>
>     iio: gts-helper: Fix memory leaks for the error path of iio_gts_build=
_avail_scale_table()
>
> Zicheng Qu <quzicheng@huawei.com>
>     iio: adc: ad7124: fix division by zero in ad7124_set_channel_odr()
>
> Julien Stephan <jstephan@baylibre.com>
>     dt-bindings: iio: adc: ad7380: fix ad7380-4 reference supply
>
> Zicheng Qu <quzicheng@huawei.com>
>     staging: iio: frequency: ad9832: fix division by zero in ad9832_calc_=
freqreg()
>
> Johannes Berg <johannes.berg@intel.com>
>     wifi: iwlwifi: mvm: fix 6 GHz scan construction
>
> Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>     wifi: iwlegacy: Clear stale interrupts before resuming device
>
> Johannes Berg <johannes.berg@intel.com>
>     wifi: cfg80211: clear wdev->cqm_config pointer on free
>
> Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
>     wifi: ath10k: Fix memory leak in management tx
>
> Felix Fietkau <nbd@nbd.name>
>     wifi: mac80211: do not pass a stopped vif to the driver in .get_txpow=
er
>
> Edward Liaw <edliaw@google.com>
>     Revert "selftests/mm: replace atomic_bool with pthread_barrier_t"
>
> Edward Liaw <edliaw@google.com>
>     Revert "selftests/mm: fix deadlock for fork after pthread_create on A=
RM"
>
> Ovidiu Bunea <Ovidiu.Bunea@amd.com>
>     Revert "drm/amd/display: update DML2 policy EnhancedPrefetchScheduleA=
ccelerationFinal DCN35"
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Revert "driver core: Fix uevent_show() vs driver detach race"
>
> Basavaraj Natikar <Basavaraj.Natikar@amd.com>
>     xhci: Use pm_runtime_get to prevent RPM on unsupported systems
>
> Faisal Hassan <quic_faisalh@quicinc.com>
>     xhci: Fix Link TRB DMA in command ring stopped completion event
>
> Johan Hovold <johan+linaro@kernel.org>
>     phy: qcom: qmp-usbc: fix NULL-deref on runtime suspend
>
> Johan Hovold <johan+linaro@kernel.org>
>     phy: qcom: qmp-usb-legacy: fix NULL-deref on runtime suspend
>
> Johan Hovold <johan+linaro@kernel.org>
>     phy: qcom: qmp-usb: fix NULL-deref on runtime suspend
>
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     usb: typec: qcom-pmic-typec: fix missing fwnode removal in error path
>
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     usb: typec: qcom-pmic-typec: use fwnode_handle_put() to release fwnod=
es
>
> Amit Sunil Dhamne <amitsd@google.com>
>     usb: typec: tcpm: restrict SNK_WAIT_CAPABILITIES_TIMEOUT transitions =
to non self-powered devices
>
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     usb: typec: fix unreleased fwnode_handle in typec_port_register_altmo=
des()
>
> Zijun Hu <quic_zijuhu@quicinc.com>
>     usb: phy: Fix API devm_usb_put_phy() can not release the phy
>
> Zongmin Zhou <zhouzongmin@kylinos.cn>
>     usbip: tools: Fix detach_port() invalid port error path
>
> Bitterblue Smith <rtl8821cerfe2@gmail.com>
>     wifi: rtlwifi: rtl8192du: Don't claim USB ID 0bda:8171
>
> Jan Sch=C3=A4r <jan@jschaer.ch>
>     ALSA: usb-audio: Add quirks for Dell WD19 dock
>
> Chuck Lever <chuck.lever@oracle.com>
>     rpcrdma: Always release the rpcrdma_device's xa_array
>
> Chuck Lever <chuck.lever@oracle.com>
>     NFSD: Never decrement pending_async_copies on error
>
> Chuck Lever <chuck.lever@oracle.com>
>     NFSD: Initialize struct nfsd4_copy earlier
>
> Dimitri Sivanich <sivanich@hpe.com>
>     misc: sgi-gru: Don't disable preemption in GRU driver
>
> Dai Ngo <dai.ngo@oracle.com>
>     NFS: remove revoked delegation from server's delegation list
>
> Daniel Palmer <daniel@0x0f.com>
>     net: amd: mvme147: Fix probe banner message
>
> Zhang Rui <rui.zhang@intel.com>
>     thermal: intel: int340x: processor: Add MMIO RAPL PL4 support
>
> Zhang Rui <rui.zhang@intel.com>
>     thermal: intel: int340x: processor: Remove MMIO RAPL CPU hotplug supp=
ort
>
> Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
>     powercap: intel_rapl_msr: Add PL4 support for Arrowlake-U
>
> Hans de Goede <hdegoede@redhat.com>
>     ACPI: resource: Fold Asus Vivobook Pro N6506M* DMI quirks together
>
> Pali Roh=C3=A1r <pali@kernel.org>
>     cifs: Fix creating native symlinks pointing to current or parent dire=
ctory
>
> Pali Roh=C3=A1r <pali@kernel.org>
>     cifs: Improve creating native symlinks pointing to directory
>
> Benjamin Marzinski <bmarzins@redhat.com>
>     scsi: scsi_transport_fc: Allow setting rport state to current state
>
> Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
>     rust: device: change the from_raw() function
>
> Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
>     fs/ntfs3: Additional check in ntfs_file_release
>
> Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
>     fs/ntfs3: Fix general protection fault in run_is_mapped_full
>
> Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
>     fs/ntfs3: Additional check in ni_clear()
>
> Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
>     fs/ntfs3: Fix possible deadlock in mi_read
>
> Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
>     fs/ntfs3: Add rough attr alloc_size check
>
> Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
>     fs/ntfs3: Stale inode instead of bad
>
> Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
>     fs/ntfs3: Fix warning possible deadlock in ntfs_set_state
>
> Andrew Ballance <andrewjballance@gmail.com>
>     fs/ntfs3: Check if more than chunk-size bytes are written
>
> lei lu <llfamsec@gmail.com>
>     ntfs3: Add bounds checking to mi_enum_attr()
>
> Boris Brezillon <boris.brezillon@collabora.com>
>     drm/panthor: Report group as timedout when we fail to properly suspen=
d
>
> Boris Brezillon <boris.brezillon@collabora.com>
>     drm/panthor: Fail job creation when the group is dead
>
> Boris Brezillon <boris.brezillon@collabora.com>
>     drm/panthor: Fix firmware initialization on systems with a page size =
> 4k
>
> Keith Busch <kbusch@kernel.org>
>     nvme: module parameter to disable pi with offsets
>
> Jason Gunthorpe <jgg@ziepe.ca>
>     PCI: Fix pci_enable_acs() support for the ACS quirks
>
> Shiju Jose <shiju.jose@huawei.com>
>     cxl/events: Fix Trace DRAM Event Record
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     drm/tegra: Fix NULL vs IS_ERR() check in probe()
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     drm/mediatek: Fix potential NULL dereference in mtk_crtc_destroy()
>
> Chun-Kuang Hu <chunkuang.hu@kernel.org>
>     drm/mediatek: Use cmdq_pkt_create() and cmdq_pkt_destroy()
>
> Liankun Yang <liankun.yang@mediatek.com>
>     drm/mediatek: Fix get efuse issue for MT8188 DPTX
>
> Hsin-Te Yuan <yuanhsinte@chromium.org>
>     drm/mediatek: Fix color format MACROs in OVL
>
> Jason-JH.Lin <jason-jh.lin@mediatek.com>
>     drm/mediatek: ovl: Remove the color format comment for ovl_fmt_conver=
t()
>
> Paulo Alcantara <pc@manguebit.com>
>     smb: client: set correct device number on nfs reparse points
>
> Paulo Alcantara <pc@manguebit.com>
>     smb: client: fix parsing of device numbers
>
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     gpio: sloppy-logic-analyzer: Check for error code from devm_mutex_ini=
t() call
>
> Pierre Gondois <pierre.gondois@arm.com>
>     ACPI: CPPC: Make rmw_lock a raw_spin_lock
>
> David Howells <dhowells@redhat.com>
>     afs: Fix missing subdir edit when renamed between parent dirs
>
> Xiongfeng Wang <wangxiongfeng2@huawei.com>
>     firmware: arm_sdei: Fix the input parameter of cpuhp_remove_state()
>
> Marco Elver <elver@google.com>
>     kasan: Fix Software Tag-Based KASAN with GCC
>
> Christoph Hellwig <hch@lst.de>
>     iomap: turn iomap_want_unshare_iter into an inline function
>
> Darrick J. Wong <djwong@kernel.org>
>     fsdax: dax_unshare_iter needs to copy entire blocks
>
> Darrick J. Wong <djwong@kernel.org>
>     fsdax: remove zeroing code from dax_unshare_iter
>
> Darrick J. Wong <djwong@kernel.org>
>     iomap: share iomap_unshare_iter predicate code with fsdax
>
> Darrick J. Wong <djwong@kernel.org>
>     iomap: don't bother unsharing delalloc extents
>
> Christoph Hellwig <hch@lst.de>
>     iomap: improve shared block detection in iomap_unshare_iter
>
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>     bpf, test_run: Fix LIVE_FRAME frame update after a page has been recy=
cled
>
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nft_payload: sanitize offset and length before calling skb=
_checksum()
>
> Daniel Golle <daniel@makrotopia.org>
>     net: ethernet: mtk_wed: fix path of MT7988 WO firmware
>
> Ido Schimmel <idosch@nvidia.com>
>     mlxsw: spectrum_ipip: Fix memory leak when changing remote IPv6 addre=
ss
>
> Amit Cohen <amcohen@nvidia.com>
>     mlxsw: pci: Sync Rx buffers for device
>
> Amit Cohen <amcohen@nvidia.com>
>     mlxsw: pci: Sync Rx buffers for CPU
>
> Amit Cohen <amcohen@nvidia.com>
>     mlxsw: spectrum_ptp: Add missing verification before pushing Tx heade=
r
>
> Beno=C3=AEt Monin <benoit.monin@gmx.fr>
>     net: skip offload for NETIF_F_IPV6_CSUM if ipv6 header contains exten=
sion
>
> Hou Tao <houtao1@huawei.com>
>     bpf: Check the validity of nr_words in bpf_iter_bits_new()
>
> Hou Tao <houtao1@huawei.com>
>     bpf: Add bpf_mem_alloc_check_size() helper
>
> Hou Tao <houtao1@huawei.com>
>     bpf: Free dynamically allocated bits in bpf_iter_bits_destroy()
>
> Sungwoo Kim <iam@sung-woo.kim>
>     Bluetooth: hci: fix null-ptr-deref in hci_read_supported_codecs
>
> Eric Dumazet <edumazet@google.com>
>     netfilter: nf_reject_ipv6: fix potential crash in nf_send_reset6()
>
> Dong Chenchen <dongchenchen2@huawei.com>
>     netfilter: Fix use-after-free in get_info()
>
> Wang Liang <wangliang74@huawei.com>
>     net: fix crash when config small gso_max_size/gso_ipv4_max_size
>
> Byeonguk Jeong <jungbu2855@gmail.com>
>     bpf: Fix out-of-bounds write in trie_get_next_key()
>
> Vladimir Oltean <vladimir.oltean@nxp.com>
>     net/sched: sch_api: fix xa_insert() error path in tcf_block_get_ext()
>
> Zichen Xie <zichenxie0106@gmail.com>
>     netdevsim: Add trailing zero to terminate the string in nsim_nexthop_=
bucket_activity_write()
>
> Eduard Zingerman <eddyz87@gmail.com>
>     bpf: Force checkpoint when jmp history is too long
>
> Pedro Tammela <pctammela@mojatatu.com>
>     net/sched: stop qdisc_tree_reduce_backlog on TC_H_ROOT
>
> Pablo Neira Ayuso <pablo@netfilter.org>
>     gtp: allow -1 to be specified as file description from userspace
>
> Ido Schimmel <idosch@nvidia.com>
>     ipv4: ip_tunnel: Fix suspicious RCU usage warning in ip_tunnel_find()
>
> Ido Schimmel <idosch@nvidia.com>
>     ipv4: ip_tunnel: Fix suspicious RCU usage warning in ip_tunnel_init_f=
low()
>
> Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>     ice: fix crash on probe for DPLL enabled E810 LOM
>
> Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>     ice: add callbacks for Embedded SYNC enablement on dpll pins
>
> Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>     dpll: add Embedded SYNC feature for a pin
>
> Wander Lairson Costa <wander@redhat.com>
>     igb: Disable threaded IRQ for igb_msix_other
>
> Furong Xu <0x1207@gmail.com>
>     net: stmmac: TSO: Fix unbalanced DMA map/unmap for non-paged SKB data
>
> Ley Foon Tan <leyfoon.tan@starfivetech.com>
>     net: stmmac: dwmac4: Fix high address display by updating reg_space[]=
 from register values
>
> Cong Wang <cong.wang@bytedance.com>
>     sock_map: fix a NULL pointer dereference in sock_map_link_update_prog=
()
>
> Aleksei Vetrov <vvvvvv@google.com>
>     ASoC: dapm: fix bounds checker error in dapm_widget_list_create
>
> Jianbo Liu <jianbol@nvidia.com>
>     macsec: Fix use-after-free while sending the offloading packet
>
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     ASoC: cs42l51: Fix some error handling paths in cs42l51_probe()
>
> Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>     Revert "wifi: iwlwifi: remove retry loops in start"
>
> Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>     wifi: iwlwifi: mvm: don't add default link in fw restart flow
>
> Daniel Gabay <daniel.gabay@intel.com>
>     wifi: iwlwifi: mvm: Fix response handling in iwl_mvm_send_recovery_cm=
d()
>
> Miri Korenblit <miriam.rachel.korenblit@intel.com>
>     wifi: iwlwifi: mvm: really send iwl_txpower_constraints_cmd
>
> Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>     wifi: iwlwifi: mvm: don't leak a link on AP removal
>
> Selvin Xavier <selvin.xavier@broadcom.com>
>     RDMA/bnxt_re: synchronize the qp-handle table array
>
> Selvin Xavier <selvin.xavier@broadcom.com>
>     RDMA/bnxt_re: Fix the usage of control path spin locks
>
> Patrisious Haddad <phaddad@nvidia.com>
>     RDMA/mlx5: Round max_rd_atomic/max_dest_rd_atomic up instead of down
>
> Leon Romanovsky <leon@kernel.org>
>     RDMA/cxgb4: Dump vendor specific QP details
>
> Geert Uytterhoeven <geert@linux-m68k.org>
>     wifi: brcm80211: BRCM_TRACING should depend on TRACING
>
> Ping-Ke Shih <pkshih@realtek.com>
>     wifi: rtw89: pci: early chips only enable 36-bit DMA on specific PCI =
hosts
>
> Remi Pommarel <repk@triplefau.lt>
>     wifi: ath11k: Fix invalid ring usage in full monitor mode
>
> Felix Fietkau <nbd@nbd.name>
>     wifi: mac80211: skip non-uploaded keys in ieee80211_iter_keys
>
> Geert Uytterhoeven <geert@linux-m68k.org>
>     mac80211: MAC80211_MESSAGE_TRACING should depend on TRACING
>
> Ben Hutchings <ben@decadent.org.uk>
>     wifi: iwlegacy: Fix "field-spanning write" warning in il_enqueue_hcmd=
()
>
> John Garry <john.g.garry@oracle.com>
>     scsi: scsi_debug: Fix do_device_access() handling of unexpected SG co=
py length
>
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf python: Fix up the build on architectures without HAVE_KVM_STAT_=
SUPPORT
>
> Jiri Slaby <jirislaby@kernel.org>
>     perf trace: Fix non-listed archs in the syscalltbl routines
>
> Pei Xiao <xiaopei01@kylinos.cn>
>     slub/kunit: fix a WARNING due to unwrapped __kmalloc_cache_noprof
>
> Georgi Djakov <djakov@kernel.org>
>     spi: geni-qcom: Fix boot warning related to pm_runtime and devres
>
> Xiu Jianfeng <xiujianfeng@huawei.com>
>     cgroup: Fix potential overflow issue when checking max_depth
>
> Frank Min <Frank.Min@amd.com>
>     drm/amdgpu: fix random data corruption for sdma 7
>
> Florian Westphal <fw@strlen.de>
>     lib: alloc_tag_module_unload must wait for pending kfree_rcu calls
>
>
> -------------
>
> Diffstat:
>
>  .../devicetree/bindings/iio/adc/adi,ad7380.yaml    |  21 ++
>  Documentation/driver-api/dpll.rst                  |  21 ++
>  Documentation/netlink/specs/dpll.yaml              |  24 ++
>  Makefile                                           |   4 +-
>  arch/arm64/boot/dts/freescale/imx8ulp.dtsi         |   2 +-
>  arch/arm64/boot/dts/qcom/msm8939.dtsi              |   2 +-
>  .../boot/dts/qcom/x1e80100-asus-vivobook-s15.dts   |   2 +
>  arch/arm64/boot/dts/qcom/x1e80100-crd.dts          |   2 +
>  .../boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts  |   2 +
>  arch/arm64/boot/dts/qcom/x1e80100-qcp.dts          |   2 +
>  arch/arm64/boot/dts/qcom/x1e80100.dtsi             |  34 ++-
>  arch/riscv/boot/dts/starfive/jh7110-common.dtsi    |   2 -
>  .../boot/dts/starfive/jh7110-pine64-star64.dts     |   3 +-
>  arch/riscv/kernel/acpi.c                           |   4 +-
>  arch/riscv/kernel/asm-offsets.c                    |   2 -
>  arch/riscv/kernel/cacheinfo.c                      |   7 +-
>  arch/riscv/kernel/cpu-hotplug.c                    |   2 +-
>  arch/riscv/kernel/efi-header.S                     |   2 +-
>  arch/riscv/kernel/traps_misaligned.c               |   2 -
>  arch/riscv/kernel/vdso/Makefile                    |   1 +
>  arch/x86/include/asm/bug.h                         |  12 +
>  arch/x86/kernel/traps.c                            |  71 ++++-
>  block/blk-map.c                                    |   4 +-
>  drivers/accel/ivpu/ivpu_debugfs.c                  |   9 +
>  drivers/accel/ivpu/ivpu_hw.c                       |   1 +
>  drivers/accel/ivpu/ivpu_hw.h                       |   1 +
>  drivers/accel/ivpu/ivpu_hw_ip.c                    |   5 +-
>  drivers/acpi/cppc_acpi.c                           |   9 +-
>  drivers/acpi/resource.c                            |  18 +-
>  drivers/base/core.c                                |  48 +++-
>  drivers/base/module.c                              |   4 -
>  drivers/char/tpm/tpm-chip.c                        |  10 +
>  drivers/char/tpm/tpm-dev-common.c                  |   3 +
>  drivers/char/tpm/tpm-interface.c                   |   6 +-
>  drivers/char/tpm/tpm2-sessions.c                   | 100 ++++---
>  drivers/cxl/Kconfig                                |   1 +
>  drivers/cxl/Makefile                               |  20 +-
>  drivers/cxl/acpi.c                                 |   7 +
>  drivers/cxl/core/hdm.c                             |  50 +++-
>  drivers/cxl/core/port.c                            |  13 +-
>  drivers/cxl/core/region.c                          |  48 +---
>  drivers/cxl/core/trace.h                           |  17 +-
>  drivers/cxl/cxl.h                                  |   3 +-
>  drivers/cxl/port.c                                 |  17 +-
>  drivers/dpll/dpll_netlink.c                        | 130 +++++++++
>  drivers/dpll/dpll_nl.c                             |   5 +-
>  drivers/firmware/arm_sdei.c                        |   2 +-
>  drivers/firmware/microchip/mpfs-auto-update.c      |  42 +--
>  drivers/gpio/gpio-sloppy-logic-analyzer.c          |   4 +-
>  drivers/gpio/gpiolib.c                             |   4 +-
>  drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c             |   9 +-
>  drivers/gpu/drm/amd/display/dc/dml2/dml2_policy.c  |   1 +
>  drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |  15 +-
>  drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c   |   4 +-
>  .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |   6 +-
>  drivers/gpu/drm/i915/display/intel_alpm.c          |   2 +-
>  drivers/gpu/drm/i915/display/intel_backlight.c     |  10 +-
>  .../gpu/drm/i915/display/intel_display_device.c    |   5 +
>  .../gpu/drm/i915/display/intel_display_device.h    |   2 +
>  drivers/gpu/drm/i915/display/intel_display_power.c |   8 +
>  .../drm/i915/display/intel_display_power_well.c    |   4 +-
>  drivers/gpu/drm/i915/display/intel_display_types.h |   1 +
>  drivers/gpu/drm/i915/display/intel_display_wa.h    |   8 +
>  drivers/gpu/drm/i915/display/intel_dp.c            |  29 +-
>  drivers/gpu/drm/i915/display/intel_dp.h            |   1 -
>  drivers/gpu/drm/i915/display/intel_dp_aux.c        |   4 +-
>  drivers/gpu/drm/i915/display/intel_dp_hdcp.c       |  11 +-
>  drivers/gpu/drm/i915/display/intel_fbc.c           |   6 +
>  drivers/gpu/drm/i915/display/intel_hdcp.c          |   7 +-
>  drivers/gpu/drm/i915/display/intel_pps.c           |  14 +-
>  drivers/gpu/drm/i915/display/intel_psr.c           |   6 +
>  drivers/gpu/drm/i915/display/intel_tc.c            |   3 +
>  drivers/gpu/drm/i915/display/intel_vrr.c           |   3 +-
>  drivers/gpu/drm/i915/display/skl_universal_plane.c |   5 -
>  drivers/gpu/drm/i915/intel_device_info.c           |   5 -
>  drivers/gpu/drm/i915/intel_device_info.h           |   2 -
>  drivers/gpu/drm/mediatek/mtk_crtc.c                |  47 +---
>  drivers/gpu/drm/mediatek/mtk_disp_ovl.c            |   9 +-
>  drivers/gpu/drm/mediatek/mtk_dp.c                  |  85 +++++-
>  drivers/gpu/drm/panthor/panthor_fw.c               |   4 +-
>  drivers/gpu/drm/panthor/panthor_gem.c              |  11 +-
>  drivers/gpu/drm/panthor/panthor_mmu.c              |  16 +-
>  drivers/gpu/drm/panthor/panthor_mmu.h              |   1 +
>  drivers/gpu/drm/panthor/panthor_sched.c            |  20 +-
>  drivers/gpu/drm/tegra/drm.c                        |   4 +-
>  drivers/gpu/drm/tests/drm_connector_test.c         |  24 +-
>  drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c |   8 +-
>  drivers/gpu/drm/tests/drm_kunit_helpers.c          |  42 +++
>  drivers/gpu/drm/xe/Makefile                        |   1 +
>  drivers/gpu/drm/xe/compat-i915-headers/i915_drv.h  |   1 -
>  drivers/gpu/drm/xe/display/xe_display_wa.c         |  16 ++
>  drivers/gpu/drm/xe/regs/xe_gt_regs.h               |  17 +-
>  drivers/gpu/drm/xe/regs/xe_regs.h                  |  10 +-
>  drivers/gpu/drm/xe/regs/xe_sriov_regs.h            |  23 --
>  drivers/gpu/drm/xe/xe_device_types.h               |   6 -
>  drivers/gpu/drm/xe/xe_ggtt.c                       |  10 +
>  drivers/gpu/drm/xe/xe_gt.c                         |  10 +-
>  drivers/gpu/drm/xe/xe_gt_sriov_pf.c                |   2 +-
>  drivers/gpu/drm/xe/xe_guc_submit.c                 |  18 +-
>  drivers/gpu/drm/xe/xe_lmtt.c                       |   2 +-
>  drivers/gpu/drm/xe/xe_module.c                     |  39 ++-
>  drivers/gpu/drm/xe/xe_sriov.c                      |   2 +-
>  drivers/gpu/drm/xe/xe_tuning.c                     |  21 +-
>  drivers/gpu/drm/xe/xe_wa.c                         |   4 +
>  drivers/iio/adc/ad7124.c                           |   2 +-
>  drivers/iio/industrialio-gts-helper.c              |   4 +-
>  drivers/iio/light/veml6030.c                       |   2 +-
>  drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   4 +
>  drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |  38 +--
>  drivers/infiniband/hw/bnxt_re/qplib_rcfw.h         |   2 +
>  drivers/infiniband/hw/cxgb4/provider.c             |   1 +
>  drivers/infiniband/hw/mlx5/qp.c                    |   4 +-
>  drivers/input/input.c                              | 134 +++++-----
>  drivers/input/touchscreen/edt-ft5x06.c             |  19 +-
>  drivers/misc/mei/client.c                          |   4 +-
>  drivers/misc/sgi-gru/grukservices.c                |   2 -
>  drivers/misc/sgi-gru/grumain.c                     |   4 -
>  drivers/misc/sgi-gru/grutlbpurge.c                 |   2 -
>  drivers/mmc/host/sdhci-pci-gli.c                   |  38 ++-
>  drivers/net/ethernet/amd/mvme147.c                 |   7 +-
>  drivers/net/ethernet/intel/ice/ice_dpll.c          | 293 +++++++++++++++=
+++++-
>  drivers/net/ethernet/intel/ice/ice_dpll.h          |   1 +
>  drivers/net/ethernet/intel/ice/ice_ptp_hw.c        |  21 +-
>  drivers/net/ethernet/intel/ice/ice_ptp_hw.h        |   1 +
>  drivers/net/ethernet/intel/igb/igb_main.c          |   2 +-
>  drivers/net/ethernet/mediatek/mtk_wed_wo.h         |   4 +-
>  drivers/net/ethernet/mellanox/mlxsw/pci.c          |  25 +-
>  .../net/ethernet/mellanox/mlxsw/spectrum_ipip.c    |  26 +-
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c |   7 +
>  drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |   8 +
>  drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h   |   2 +
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  22 +-
>  drivers/net/gtp.c                                  |  22 +-
>  drivers/net/macsec.c                               |   3 +-
>  drivers/net/mctp/mctp-i2c.c                        |   3 +
>  drivers/net/netdevsim/fib.c                        |   4 +-
>  drivers/net/wireless/ath/ath10k/wmi-tlv.c          |   7 +-
>  drivers/net/wireless/ath/ath10k/wmi.c              |   2 +
>  drivers/net/wireless/ath/ath11k/dp_rx.c            |   7 +-
>  drivers/net/wireless/broadcom/brcm80211/Kconfig    |   1 +
>  drivers/net/wireless/intel/iwlegacy/common.c       |  15 +-
>  drivers/net/wireless/intel/iwlegacy/common.h       |  12 +
>  drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  34 ++-
>  drivers/net/wireless/intel/iwlwifi/iwl-drv.h       |   3 +
>  drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  10 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  12 +-
>  .../net/wireless/intel/iwlwifi/mvm/mld-mac80211.c  |  34 ++-
>  drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   6 +-
>  .../net/wireless/realtek/rtlwifi/rtl8192du/sw.c    |   1 -
>  drivers/net/wireless/realtek/rtw89/pci.c           |  48 +++-
>  drivers/nvme/host/core.c                           |  19 +-
>  drivers/nvme/host/ioctl.c                          |   7 +-
>  drivers/nvme/target/auth.c                         |   1 +
>  drivers/pci/pci.c                                  |  14 +-
>  drivers/phy/freescale/phy-fsl-imx8m-pcie.c         |  10 +-
>  drivers/phy/qualcomm/phy-qcom-qmp-usb-legacy.c     |   1 +
>  drivers/phy/qualcomm/phy-qcom-qmp-usb.c            |   1 +
>  drivers/phy/qualcomm/phy-qcom-qmp-usbc.c           |   1 +
>  drivers/powercap/intel_rapl_msr.c                  |   1 +
>  drivers/scsi/scsi_debug.c                          |  10 +-
>  drivers/scsi/scsi_transport_fc.c                   |   4 +-
>  drivers/soc/qcom/pmic_glink.c                      |  25 +-
>  drivers/spi/spi-fsl-dspi.c                         |   6 +-
>  drivers/spi/spi-geni-qcom.c                        |   8 +-
>  drivers/staging/iio/frequency/ad9832.c             |   7 +-
>  .../intel/int340x_thermal/processor_thermal_rapl.c |  70 ++---
>  drivers/thunderbolt/retimer.c                      |   5 +-
>  drivers/thunderbolt/tb.c                           |  48 +++-
>  drivers/ufs/core/ufshcd.c                          |   2 +-
>  drivers/usb/host/xhci-pci.c                        |   6 +-
>  drivers/usb/host/xhci-ring.c                       |  16 +-
>  drivers/usb/phy/phy.c                              |   2 +-
>  drivers/usb/typec/class.c                          |   1 +
>  drivers/usb/typec/tcpm/qcom/qcom_pmic_typec.c      |  10 +-
>  drivers/usb/typec/tcpm/tcpm.c                      |  10 +-
>  fs/afs/dir.c                                       |  25 ++
>  fs/afs/dir_edit.c                                  |  91 ++++++-
>  fs/afs/internal.h                                  |   2 +
>  fs/btrfs/bio.c                                     |  62 ++---
>  fs/btrfs/bio.h                                     |   3 +
>  fs/btrfs/defrag.c                                  |  10 +-
>  fs/btrfs/extent_map.c                              |   7 +-
>  fs/btrfs/volumes.c                                 |   1 +
>  fs/dax.c                                           |  49 ++--
>  fs/iomap/buffered-io.c                             |   7 +-
>  fs/nfs/delegation.c                                |   5 +
>  fs/nfsd/nfs4proc.c                                 |  10 +-
>  fs/nilfs2/namei.c                                  |   3 +
>  fs/nilfs2/page.c                                   |   1 +
>  fs/ntfs3/file.c                                    |   9 +-
>  fs/ntfs3/frecord.c                                 |   4 +-
>  fs/ntfs3/inode.c                                   |  15 +-
>  fs/ntfs3/lznt.c                                    |   3 +
>  fs/ntfs3/namei.c                                   |   2 +-
>  fs/ntfs3/ntfs_fs.h                                 |   2 +-
>  fs/ntfs3/record.c                                  |  31 ++-
>  fs/ocfs2/file.c                                    |   8 +
>  fs/smb/client/cifs_unicode.c                       |  17 +-
>  fs/smb/client/reparse.c                            | 174 +++++++++++-
>  fs/smb/client/reparse.h                            |   9 +-
>  fs/smb/client/smb2inode.c                          |   3 +-
>  fs/smb/client/smb2proto.h                          |   1 +
>  fs/userfaultfd.c                                   |  28 ++
>  fs/xfs/xfs_filestream.c                            |  23 +-
>  fs/xfs/xfs_trace.h                                 |  15 +-
>  include/acpi/cppc_acpi.h                           |   2 +-
>  include/drm/drm_kunit_helpers.h                    |   4 +
>  include/linux/bpf_mem_alloc.h                      |   3 +
>  include/linux/compiler-gcc.h                       |   4 +
>  include/linux/device.h                             |   3 +
>  include/linux/dpll.h                               |  15 ++
>  include/linux/input.h                              |  10 +-
>  include/linux/iomap.h                              |  19 ++
>  include/linux/ksm.h                                |  10 +-
>  include/linux/mmzone.h                             |   7 +-
>  include/linux/tick.h                               |   8 +
>  include/linux/ubsan.h                              |   5 +
>  include/linux/userfaultfd_k.h                      |   5 +
>  include/net/ip_tunnels.h                           |   2 +-
>  include/trace/events/afs.h                         |   7 +-
>  include/uapi/linux/dpll.h                          |   3 +
>  io_uring/rw.c                                      |  23 +-
>  kernel/bpf/cgroup.c                                |  19 +-
>  kernel/bpf/helpers.c                               |  21 +-
>  kernel/bpf/lpm_trie.c                              |   2 +-
>  kernel/bpf/memalloc.c                              |  14 +-
>  kernel/bpf/verifier.c                              |   9 +-
>  kernel/cgroup/cgroup.c                             |   4 +-
>  kernel/fork.c                                      |  14 +-
>  kernel/resource.c                                  |   4 +-
>  kernel/sched/fair.c                                |   4 +-
>  lib/Kconfig.ubsan                                  |   4 +-
>  lib/codetag.c                                      |   3 +
>  lib/iov_iter.c                                     |   6 +-
>  lib/slub_kunit.c                                   |   2 +-
>  mm/kasan/kasan_test.c                              |  27 --
>  mm/migrate.c                                       |   2 +-
>  mm/mmap.c                                          |   3 +-
>  mm/page_alloc.c                                    |  10 +-
>  mm/rmap.c                                          |  24 +-
>  mm/shmem.c                                         |   2 +
>  mm/shrinker.c                                      |   8 +-
>  mm/vmscan.c                                        | 109 ++++----
>  net/bluetooth/hci_sync.c                           |  18 +-
>  net/bpf/test_run.c                                 |   1 +
>  net/core/dev.c                                     |   4 +
>  net/core/rtnetlink.c                               |   4 +-
>  net/core/sock_map.c                                |   4 +
>  net/ipv4/ip_tunnel.c                               |   2 +-
>  net/ipv6/netfilter/nf_reject_ipv6.c                |  15 +-
>  net/mac80211/Kconfig                               |   2 +-
>  net/mac80211/cfg.c                                 |   3 +-
>  net/mac80211/key.c                                 |  42 +--
>  net/mptcp/protocol.c                               |   2 +
>  net/netfilter/nft_payload.c                        |   3 +
>  net/netfilter/x_tables.c                           |   2 +-
>  net/sched/cls_api.c                                |   1 +
>  net/sched/sch_api.c                                |   2 +-
>  net/sunrpc/xprtrdma/ib_client.c                    |   1 +
>  net/wireless/core.c                                |   1 +
>  rust/kernel/device.rs                              |  15 +-
>  rust/kernel/firmware.rs                            |   2 +-
>  sound/pci/hda/patch_realtek.c                      |  23 +-
>  sound/soc/codecs/cs42l51.c                         |   7 +-
>  sound/soc/soc-dapm.c                               |   2 +
>  sound/usb/mixer_quirks.c                           |   3 +
>  tools/mm/page-types.c                              |   9 +-
>  tools/mm/slabinfo.c                                |   4 +-
>  tools/perf/util/python.c                           |   3 +
>  tools/perf/util/syscalltbl.c                       |  10 +
>  tools/testing/cxl/test/cxl.c                       |  14 +-
>  tools/testing/selftests/mm/uffd-common.c           |   5 +-
>  tools/testing/selftests/mm/uffd-common.h           |   3 +-
>  tools/testing/selftests/mm/uffd-unit-tests.c       |  21 +-
>  tools/usb/usbip/src/usbip_detach.c                 |   1 +
>  275 files changed, 2818 insertions(+), 1069 deletions(-)
>
>
>
