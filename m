Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA059175D47
	for <patches@lists.linux.dev>; Thu, 22 May 2025 05:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747890313; cv=none; b=BaqkXg7RY3qjsdd6pbQ2V+Nub5krX1PxK8+jjJB73NzUaCTA3WDoxDGZbVZyZMy05Bj5HX9NFvG67/MZ1edejwl0uk8cs3xy+m4Te0SPvr4DxGKDlBlBLjOvirzvnA8l8dkHPh5DLuTHpIsKFmajBA6U31F/7lcWANQ0xFdZe4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747890313; c=relaxed/simple;
	bh=8zoCKTCZUmS42ZTg0psMbydaIoBjSm4rRUAru2CtK0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mgyBYr9rp3jf1QvWFkx6HpqSL8x8iQfp45AVP8tAGqTffeRxwoKkFRMg+BETvlUbwxa2w0Xu+ADxx5CwbBTkKmnbUGcesXrGWdyGF225MYW2lKjS7ebjI8veraVPEBeFhM7UluNnMzHobuieF2pblje4p3k4m4XgjcTYlHc8ZSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=hLUC2Fg1; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="hLUC2Fg1"
Received: from [100.65.232.110] (unknown [20.236.10.129])
	by linux.microsoft.com (Postfix) with ESMTPSA id 69D4D206834A;
	Wed, 21 May 2025 22:05:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 69D4D206834A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1747890309;
	bh=r2seuEPb39KRpEV+CcHyk5dzS86Ek5Iv8ZkoDys1W1w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hLUC2Fg1pqg7rFuvL2JY0oStu5+01PMpwQ54GiRRryX22rFtJRDAyo7HpZSYLPBkC
	 Y/FK30CbdJ1fr2jBUuU0wWD3yFTI4F1vN0MaD41QkSsliA2st6k5tXO5zEDDbUVwHK
	 2V+CbHqTZ5Q9sqK8cpbgVQKI0l0Z+g9OpDK0oANE=
Message-ID: <9f2569f0-a09d-4b07-811f-11116b8bf138@linux.microsoft.com>
Date: Wed, 21 May 2025 22:05:08 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/117] 6.6.92-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250520125803.981048184@linuxfoundation.org>
Content-Language: en-US
From: Hardik Garg <hargar@linux.microsoft.com>
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The kernel, bpf tool and perf tool builds fine for v6.6.92-rc1 on x86
and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik

On 5/20/2025 6:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.92 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.92-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
>      Linux 6.6.92-rc1
>
> Alex Deucher <alexander.deucher@amd.com>
>      drm/amdgpu: fix pm notifier handling
>
> Dan Carpenter <dan.carpenter@linaro.org>
>      phy: tegra: xusb: remove a stray unlock
>
> Filipe Manana <fdmanana@suse.com>
>      btrfs: don't BUG_ON() when 0 reference count at btrfs_lookup_extent_info()
>
> Eric Dumazet <edumazet@google.com>
>      sctp: add mutual exclusion in proc_sctp_do_udp_port()
>
> Ma Wupeng <mawupeng1@huawei.com>
>      hwpoison, memory_hotplug: lock folio before unmap hwpoisoned folio
>
> Tom Lendacky <thomas.lendacky@amd.com>
>      memblock: Accept allocated memory before use in memblock_double_array()
>
> Huacai Chen <chenhuacai@kernel.org>
>      LoongArch: Explicitly specify code model in Makefile
>
> Peter Collingbourne <pcc@google.com>
>      bpf, arm64: Fix address emission with tag-based KASAN enabled
>
> Puranjay Mohan <puranjay@kernel.org>
>      bpf, arm64: Fix trampoline for BPF_TRAMP_F_CALL_ORIG
>
> Zi Yan <ziy@nvidia.com>
>      mm/migrate: correct nr_failed in migrate_pages_sync()
>
> Feng Tang <feng.tang@linux.alibaba.com>
>      selftests/mm: compaction_test: support platform with huge mount of memory
>
> Andrei Kuchynski <akuchynski@chromium.org>
>      usb: typec: ucsi: displayport: Fix deadlock
>
> Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
>      Bluetooth: btnxpuart: Fix kernel panic during FW release
>
> Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>      mm/page_alloc: fix race condition in unaccepted memory handling
>
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>      x86/its: Fix build error for its_static_thunk()
>
> Shuai Xue <xueshuai@linux.alibaba.com>
>      dmaengine: idxd: Refactor remove call with idxd_cleanup() helper
>
> Shuai Xue <xueshuai@linux.alibaba.com>
>      dmaengine: idxd: fix memory leak in error handling path of idxd_pci_probe
>
> Shuai Xue <xueshuai@linux.alibaba.com>
>      dmaengine: idxd: fix memory leak in error handling path of idxd_alloc
>
> Shuai Xue <xueshuai@linux.alibaba.com>
>      dmaengine: idxd: Add missing idxd cleanup to fix memory leak in remove call
>
> Shuai Xue <xueshuai@linux.alibaba.com>
>      dmaengine: idxd: Add missing cleanups in cleanup internals
>
> Shuai Xue <xueshuai@linux.alibaba.com>
>      dmaengine: idxd: Add missing cleanup for early error out in idxd_setup_internals
>
> Shuai Xue <xueshuai@linux.alibaba.com>
>      dmaengine: idxd: fix memory leak in error handling path of idxd_setup_groups
>
> Shuai Xue <xueshuai@linux.alibaba.com>
>      dmaengine: idxd: fix memory leak in error handling path of idxd_setup_engines
>
> Shuai Xue <xueshuai@linux.alibaba.com>
>      dmaengine: idxd: fix memory leak in error handling path of idxd_setup_wqs
>
> Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
>      dmaengine: ti: k3-udma: Use cap_mask directly from dma_device structure instead of a local copy
>
> Ronald Wahl <ronald.wahl@legrand.com>
>      dmaengine: ti: k3-udma: Add missing locking
>
> Nathan Chancellor <nathan@kernel.org>
>      net: qede: Initialize qede_ll_ops with designated initializer
>
> Fedor Pchelkin <pchelkin@ispras.ru>
>      wifi: mt76: disable napi on driver removal
>
> Aaron Kling <webgeek1234@gmail.com>
>      spi: tegra114: Use value to check for invalid delays
>
> Jethro Donaldson <devel@jro.nz>
>      smb: client: fix memory leak during error handling for POSIX mkdir
>
> Steve Siwinski <ssiwinski@atto.com>
>      scsi: sd_zbc: block: Respect bio vector limits for REPORT ZONES buffer
>
> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>      phy: renesas: rcar-gen3-usb2: Set timing registers only once
>
> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>      phy: renesas: rcar-gen3-usb2: Fix role detection on unbind/bind
>
> Ma Ke <make24@iscas.ac.cn>
>      phy: Fix error handling in tegra_xusb_port_init
>
> Wayne Chang <waynec@nvidia.com>
>      phy: tegra: xusb: Use a bitmask for UTMI pad power state tracking
>
> Steven Rostedt <rostedt@goodmis.org>
>      tracing: samples: Initialize trace_array_printk() with the correct function
>
> pengdonglin <pengdonglin@xiaomi.com>
>      ftrace: Fix preemption accounting for stacktrace filter command
>
> pengdonglin <pengdonglin@xiaomi.com>
>      ftrace: Fix preemption accounting for stacktrace trigger command
>
> Michael Kelley <mhklinux@outlook.com>
>      Drivers: hv: vmbus: Remove vmbus_sendpacket_pagebuffer()
>
> Michael Kelley <mhklinux@outlook.com>
>      Drivers: hv: Allow vmbus_sendpacket_mpb_desc() to create multiple ranges
>
> Michael Kelley <mhklinux@outlook.com>
>      hv_netvsc: Remove rmsg_pgcnt
>
> Michael Kelley <mhklinux@outlook.com>
>      hv_netvsc: Preserve contiguous PFN grouping in the page buffer array
>
> Michael Kelley <mhklinux@outlook.com>
>      hv_netvsc: Use vmbus_sendpacket_mpb_desc() to send VMBus messages
>
> Hyejeong Choi <hjeong.choi@samsung.com>
>      dma-buf: insert memory barrier before updating num_fences
>
> Nicolas Chauvet <kwizart@gmail.com>
>      ALSA: usb-audio: Add sample rate quirk for Microdia JP001 USB Camera
>
> Christian Heusel <christian@heusel.eu>
>      ALSA: usb-audio: Add sample rate quirk for Audioengine D1
>
> Wentao Liang <vulab@iscas.ac.cn>
>      ALSA: es1968: Add error handling for snd_pcm_hw_constraint_pow2()
>
> Jeremy Linton <jeremy.linton@arm.com>
>      ACPI: PPTT: Fix processor subtable walk
>
> Wayne Lin <Wayne.Lin@amd.com>
>      drm/amd/display: Avoid flooding unnecessary info messages
>
> Wayne Lin <Wayne.Lin@amd.com>
>      drm/amd/display: Correct the reply value when AUX write incomplete
>
> Tiezhu Yang <yangtiezhu@loongson.cn>
>      LoongArch: uprobes: Remove redundant code about resume_era
>
> Tiezhu Yang <yangtiezhu@loongson.cn>
>      LoongArch: uprobes: Remove user_{en,dis}able_single_step()
>
> Huacai Chen <chenhuacai@kernel.org>
>      LoongArch: Fix MAX_REG_OFFSET calculation
>
> Huacai Chen <chenhuacai@kernel.org>
>      LoongArch: Save and restore CSR.CNTC for hibernation
>
> Tianyang Zhang <zhangtianyang@loongson.cn>
>      LoongArch: Prevent cond_resched() occurring within kernel-fpu
>
> Jan Kara <jack@suse.cz>
>      udf: Make sure i_lenExtents is uptodate on inode eviction
>
> Nathan Lynch <nathan.lynch@amd.com>
>      dmaengine: Revert "dmaengine: dmatest: Fix dmatest waiting less when interrupted"
>
> Trond Myklebust <trond.myklebust@hammerspace.com>
>      NFSv4/pnfs: Reset the layout state after a layoutreturn
>
> Gerhard Engleder <gerhard@engleder-embedded.com>
>      tsnep: fix timestamping with a stacked DSA driver
>
> Gerhard Engleder <gerhard@engleder-embedded.com>
>      tsnep: Inline small fragments within TX descriptor
>
> Pengtao He <hept.hept.hept@gmail.com>
>      net/tls: fix kernel panic when alloc_page failed
>
> Ido Schimmel <idosch@nvidia.com>
>      mlxsw: spectrum_router: Fix use-after-free when deleting GRE net devices
>
> Kees Cook <kees@kernel.org>
>      wifi: mac80211: Set n_channels after allocating struct cfg80211_scan_request
>
> Hariprasad Kelam <hkelam@marvell.com>
>      octeontx2-af: Fix CGX Receive counters
>
> Bo-Cun Chen <bc-bocun.chen@mediatek.com>
>      net: ethernet: mtk_eth_soc: fix typo for declaration MT7988 ESW capability
>
> Subbaraya Sundeep <sbhatta@marvell.com>
>      octeontx2-pf: macsec: Fix incorrect max transmit size in TX secy
>
> Cosmin Tanislav <demonsingur@gmail.com>
>      regulator: max20086: fix invalid memory access
>
> Abdun Nihaal <abdun.nihaal@gmail.com>
>      qlcnic: fix memory leak in qlcnic_sriov_channel_cfg_cmd()
>
> Carolina Jubran <cjubran@nvidia.com>
>      net/mlx5e: Disable MACsec offload for uplink representor profile
>
> Geert Uytterhoeven <geert+renesas@glider.be>
>      ALSA: sh: SND_AICA should depend on SH_DMA_API
>
> Keith Busch <kbusch@kernel.org>
>      nvme-pci: acquire cq_poll_lock in nvme_poll_irqdisable
>
> Kees Cook <kees@kernel.org>
>      nvme-pci: make nvme_pci_npages_prp() __always_inline
>
> Vladimir Oltean <vladimir.oltean@nxp.com>
>      net: dsa: sja1105: discard incoming frames in BR_STATE_LISTENING
>
> Mathieu Othacehe <othacehe@gnu.org>
>      net: cadence: macb: Fix a possible deadlock in macb_halt_tx.
>
> Takashi Iwai <tiwai@suse.de>
>      ALSA: ump: Fix a typo of snd_ump_stream_msg_device_info
>
> Takashi Iwai <tiwai@suse.de>
>      ALSA: seq: Fix delivery of UMP events to group ports
>
> Andrew Jeffery <andrew@codeconstruct.com.au>
>      net: mctp: Ensure keys maintain only one ref to corresponding dev
>
> Matt Johnston <matt@codeconstruct.com.au>
>      net: mctp: Don't access ifa_index when missing
>
> Eric Dumazet <edumazet@google.com>
>      mctp: no longer rely on net->dev_index_head[]
>
> Hangbin Liu <liuhangbin@gmail.com>
>      tools/net/ynl: ethtool: fix crash when Hardware Clock info is missing
>
> Rahul Rameshbabu <rrameshbabu@nvidia.com>
>      tools: ynl: ethtool.py: Output timestamping statistics from tsinfo-get operation
>
> Cong Wang <xiyou.wangcong@gmail.com>
>      net_sched: Flush gso_skb list too during ->change()
>
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>      Bluetooth: MGMT: Fix MGMT_OP_ADD_DEVICE invalid device flags
>
> Geert Uytterhoeven <geert+renesas@glider.be>
>      spi: loopback-test: Do not split 1024-byte hexdumps
>
> Li Lingfeng <lilingfeng3@huawei.com>
>      nfs: handle failure of nfs_get_lock_context in unlock path
>
> Henry Martin <bsdhenrymartin@gmail.com>
>      HID: uclogic: Add NULL check in uclogic_input_configured()
>
> Qasim Ijaz <qasdev00@gmail.com>
>      HID: thrustmaster: fix memory leak in thrustmaster_interrupts()
>
> Zhu Yanjun <yanjun.zhu@linux.dev>
>      RDMA/rxe: Fix slab-use-after-free Read in rxe_queue_cleanup bug
>
> David Lechner <dlechner@baylibre.com>
>      iio: chemical: sps30: use aligned_s64 for timestamp
>
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>      iio: adc: ad7768-1: Fix insufficient alignment of timestamp.
>
> Alex Deucher <alexander.deucher@amd.com>
>      Revert "drm/amd: Stop evicting resources on APUs in suspend"
>
> Mario Limonciello <mario.limonciello@amd.com>
>      drm/amd: Add Suspend/Hibernate notification callback support
>
> Zhigang Luo <Zhigang.Luo@amd.com>
>      drm/amdgpu: trigger flr_work if reading pf2vf data failed
>
> Ma Jun <Jun.Ma2@amd.com>
>      drm/amdgpu: Fix the runtime resume failure issue
>
> Mario Limonciello <mario.limonciello@amd.com>
>      drm/amd: Stop evicting resources on APUs in suspend
>
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>      iio: adc: ad7266: Fix potential timestamp alignment issue.
>
> Mikhail Lobanov <m.lobanov@rosa.ru>
>      KVM: SVM: Forcibly leave SMM mode on SHUTDOWN interception
>
> Peter Gonda <pgonda@google.com>
>      KVM: SVM: Update SEV-ES shutdown intercepts with more metadata
>
> Cristian Marussi <cristian.marussi@arm.com>
>      firmware: arm_scmi: Fix timeout checks on polling path
>
> Luke Parkin <luke.parkin@arm.com>
>      firmware: arm_scmi: Track basic SCMI communication debug metrics
>
> Luke Parkin <luke.parkin@arm.com>
>      firmware: arm_scmi: Add support for debug metrics at the interface
>
> Cristian Marussi <cristian.marussi@arm.com>
>      firmware: arm_scmi: Add message dump traces for bad and unexpected replies
>
> Cristian Marussi <cristian.marussi@arm.com>
>      firmware: arm_scmi: Add helper to trace bad messages
>
> Michal Suchanek <msuchanek@suse.de>
>      tpm: tis: Double the timeout B to 4s
>
> Masami Hiramatsu (Google) <mhiramat@kernel.org>
>      tracing: probes: Fix a possible race in trace_probe_log APIs
>
> Waiman Long <longman@redhat.com>
>      cgroup/cpuset: Extend kthread_is_per_cpu() check to all PF_NO_SETAFFINITY tasks
>
> Hans de Goede <hdegoede@redhat.com>
>      platform/x86: asus-wmi: Fix wlan_ctrl_by_user detection
>
> Runhua He <hua@aosc.io>
>      platform/x86/amd/pmc: Declare quirk_spurious_8042 for MECHREVO Wujie 14XA (GX4HRXL)
>
> Kees Cook <kees@kernel.org>
>      binfmt_elf: Move brk for static PIE even if ASLR disabled
>
> Kees Cook <kees@kernel.org>
>      binfmt_elf: Honor PT_LOAD alignment for static PIE
>
> Kees Cook <kees@kernel.org>
>      binfmt_elf: Calculate total_size earlier
>
> Kees Cook <kees@kernel.org>
>      selftests/exec: Build both static and non-static load_address tests
>
> Kees Cook <keescook@chromium.org>
>      binfmt_elf: Leave a gap between .bss and brk
>
> Muhammad Usama Anjum <usama.anjum@collabora.com>
>      selftests/exec: load_address: conform test to TAP format output
>
> Kees Cook <keescook@chromium.org>
>      binfmt_elf: elf_bss no longer used by load_elf_binary()
>
> Eric W. Biederman <ebiederm@xmission.com>
>      binfmt_elf: Support segments with 0 filesz and misaligned starts
>
> Stephen Smalley <stephen.smalley.work@gmail.com>
>      fs/xattr.c: fix simple_xattr_list to always include security.* xattrs
>
>
> -------------
>
> Diffstat:
>
>   Makefile                                           |   4 +-
>   arch/arm64/net/bpf_jit_comp.c                      |  12 +-
>   arch/loongarch/Makefile                            |   2 +-
>   arch/loongarch/include/asm/ptrace.h                |   2 +-
>   arch/loongarch/include/asm/uprobes.h               |   1 -
>   arch/loongarch/kernel/kfpu.c                       |  22 +-
>   arch/loongarch/kernel/time.c                       |   2 +-
>   arch/loongarch/kernel/uprobes.c                    |  11 +-
>   arch/loongarch/power/hibernate.c                   |   3 +
>   arch/x86/kernel/alternative.c                      |  17 +-
>   arch/x86/kvm/smm.c                                 |   1 +
>   arch/x86/kvm/svm/svm.c                             |  19 +-
>   block/bio.c                                        |   2 +-
>   drivers/acpi/pptt.c                                |  11 +-
>   drivers/bluetooth/btnxpuart.c                      |   6 +-
>   drivers/char/tpm/tpm_tis_core.h                    |   2 +-
>   drivers/dma-buf/dma-resv.c                         |   5 +-
>   drivers/dma/dmatest.c                              |   6 +-
>   drivers/dma/idxd/init.c                            | 159 ++++++++----
>   drivers/dma/ti/k3-udma.c                           |  10 +-
>   drivers/firmware/arm_scmi/Kconfig                  |  14 +
>   drivers/firmware/arm_scmi/common.h                 |  35 +++
>   drivers/firmware/arm_scmi/driver.c                 |  89 ++++++-
>   drivers/firmware/arm_scmi/mailbox.c                |   3 +
>   drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   1 +
>   drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  51 +++-
>   drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  11 +-
>   drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c           |  29 ++-
>   drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h           |   3 +
>   drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c              |   2 +
>   drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c              |   2 +
>   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   3 +-
>   .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  16 +-
>   drivers/hid/hid-thrustmaster.c                     |   1 +
>   drivers/hid/hid-uclogic-core.c                     |   7 +-
>   drivers/hv/channel.c                               |  65 +----
>   drivers/iio/adc/ad7266.c                           |   2 +-
>   drivers/iio/adc/ad7768-1.c                         |   2 +-
>   drivers/iio/chemical/sps30.c                       |   2 +-
>   drivers/infiniband/sw/rxe/rxe_cq.c                 |   5 +-
>   drivers/net/dsa/sja1105/sja1105_main.c             |   6 +-
>   drivers/net/ethernet/cadence/macb_main.c           |  19 +-
>   drivers/net/ethernet/engleder/tsnep_hw.h           |   2 +
>   drivers/net/ethernet/engleder/tsnep_main.c         | 131 +++++++---
>   drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   5 +
>   .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c  |   3 +-
>   drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   2 +-
>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   4 +
>   .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   3 +
>   drivers/net/ethernet/qlogic/qede/qede_main.c       |   2 +-
>   .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |   7 +-
>   drivers/net/hyperv/hyperv_net.h                    |  13 +-
>   drivers/net/hyperv/netvsc.c                        |  57 ++++-
>   drivers/net/hyperv/netvsc_drv.c                    |  62 +----
>   drivers/net/hyperv/rndis_filter.c                  |  24 +-
>   drivers/net/wireless/mediatek/mt76/dma.c           |   1 +
>   drivers/nvme/host/pci.c                            |   4 +-
>   drivers/phy/renesas/phy-rcar-gen3-usb2.c           |  38 ++-
>   drivers/phy/tegra/xusb-tegra186.c                  |  46 ++--
>   drivers/phy/tegra/xusb.c                           |   8 +-
>   drivers/platform/x86/amd/pmc/pmc-quirks.c          |   7 +
>   drivers/platform/x86/asus-wmi.c                    |   3 +-
>   drivers/regulator/max20086-regulator.c             |   7 +-
>   drivers/scsi/sd_zbc.c                              |   6 +-
>   drivers/scsi/storvsc_drv.c                         |   1 +
>   drivers/spi/spi-loopback-test.c                    |   2 +-
>   drivers/spi/spi-tegra114.c                         |   6 +-
>   drivers/usb/gadget/function/f_midi2.c              |   2 +-
>   drivers/usb/typec/ucsi/displayport.c               |  19 +-
>   drivers/usb/typec/ucsi/ucsi.c                      |  34 +++
>   drivers/usb/typec/ucsi/ucsi.h                      |   2 +
>   fs/binfmt_elf.c                                    | 281 ++++++++++++---------
>   fs/btrfs/extent-tree.c                             |  25 +-
>   fs/nfs/nfs4proc.c                                  |   9 +-
>   fs/nfs/pnfs.c                                      |   9 +
>   fs/smb/client/smb2pdu.c                            |   2 +-
>   fs/udf/truncate.c                                  |   2 +-
>   fs/xattr.c                                         |  24 ++
>   include/linux/bio.h                                |   1 +
>   include/linux/hyperv.h                             |   7 -
>   include/linux/tpm.h                                |   2 +-
>   include/net/sch_generic.h                          |  15 ++
>   include/sound/ump_msg.h                            |   4 +-
>   kernel/cgroup/cpuset.c                             |   6 +-
>   kernel/trace/trace_dynevent.c                      |  16 +-
>   kernel/trace/trace_dynevent.h                      |   1 +
>   kernel/trace/trace_events_trigger.c                |   2 +-
>   kernel/trace/trace_functions.c                     |   6 +-
>   kernel/trace/trace_kprobe.c                        |   2 +-
>   kernel/trace/trace_probe.c                         |   9 +
>   kernel/trace/trace_uprobe.c                        |   2 +-
>   mm/memblock.c                                      |   9 +-
>   mm/memory_hotplug.c                                |   6 +-
>   mm/migrate.c                                       |  16 +-
>   mm/page_alloc.c                                    |  27 --
>   net/bluetooth/mgmt.c                               |   9 +-
>   net/mac80211/main.c                                |   6 +-
>   net/mctp/device.c                                  |  65 +++--
>   net/mctp/route.c                                   |   4 +-
>   net/sched/sch_codel.c                              |   2 +-
>   net/sched/sch_fq.c                                 |   2 +-
>   net/sched/sch_fq_codel.c                           |   2 +-
>   net/sched/sch_fq_pie.c                             |   2 +-
>   net/sched/sch_hhf.c                                |   2 +-
>   net/sched/sch_pie.c                                |   2 +-
>   net/sctp/sysctl.c                                  |   4 +
>   net/tls/tls_strp.c                                 |   3 +-
>   samples/ftrace/sample-trace-array.c                |   2 +-
>   sound/core/seq/seq_clientmgr.c                     |  52 ++--
>   sound/core/seq/seq_ump_convert.c                   |  18 ++
>   sound/core/seq/seq_ump_convert.h                   |   1 +
>   sound/pci/es1968.c                                 |   6 +-
>   sound/sh/Kconfig                                   |   2 +-
>   sound/usb/quirks.c                                 |   4 +
>   tools/net/ynl/ethtool.py                           |  29 ++-
>   tools/testing/selftests/exec/Makefile              |  19 +-
>   tools/testing/selftests/exec/load_address.c        |  83 ++++--
>   tools/testing/selftests/mm/compaction_test.c       |  19 +-
>   118 files changed, 1294 insertions(+), 693 deletions(-)
>
>
