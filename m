Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 815341A3150
	for <patches@lists.linux.dev>; Thu, 22 May 2025 05:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747890205; cv=none; b=jfi6Qvo7BAEj+/0Jy1nQ6o5eBMv4drsMqLjMb2L9VD8w5h+vVQubdXLHCVf9j702DKcIZOKVpM4M1U76ZzNenLgIpzGZ3nAqoxWhP1O0S6Lvq/30UXYA8sTuanq3CwZrX0KqGwX4LGXIQwbgcA7PPYSnWEpg2dNY695CAK4yxrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747890205; c=relaxed/simple;
	bh=BuQ5lhq7E8MvmLMt6B91iD7EHJOhAEgupI/t34ILVAo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tY90Hgs0XjOj9jpWFhkO6u/0ciYEAB8BHX3RyKqq9Cc7iLHRNjvEpFTFAf74RTGgT6qVJOt/LDhmlWevcWBH56QmKaNpsIHdeQ+gTLnnPBnEmHFiWquR/XSPqbny2D/hOLTpbDmP5UAJv5CCCF5jckYhDoIgMAYCGyvi0Nx7Z+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Btl/YHJC; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Btl/YHJC"
Received: from [100.65.232.110] (unknown [20.236.10.129])
	by linux.microsoft.com (Postfix) with ESMTPSA id 248C2206834A;
	Wed, 21 May 2025 22:03:22 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 248C2206834A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1747890202;
	bh=0a9UHdSnZ44WD78KvAXy47Mc7Q8EjH1iVYkjiAAjopw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Btl/YHJChfbTimf3EPpJqyNyjJEpXjr9MGoVkkD5JywDRKHtBEKPj85FyB3jzy0sQ
	 XS/a0gudqPuCcsuJkX51hL0/rxXED4GjR/AOStZtJ6TeUIE+2tPdT1BaC5dvH0SCVr
	 oV6pWHfA8TgY1waqRbaGvC7nc1owoygmdCNtz1gk=
Message-ID: <cf76221b-e8ff-422e-b09f-fc13302ff81f@linux.microsoft.com>
Date: Wed, 21 May 2025 22:03:21 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/143] 6.12.30-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250520125810.036375422@linuxfoundation.org>
Content-Language: en-US
From: Hardik Garg <hargar@linux.microsoft.com>
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The kernel, bpf tool and perf tool builds fine for v6.12.30-rc1 on x86
and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik

On 5/20/2025 6:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.30 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.30-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
>      Linux 6.12.30-rc1
>
> Alex Deucher <alexander.deucher@amd.com>
>      drm/amdgpu: fix pm notifier handling
>
> Dan Carpenter <dan.carpenter@linaro.org>
>      phy: tegra: xusb: remove a stray unlock
>
> Andrei Kuchynski <akuchynski@chromium.org>
>      usb: typec: ucsi: displayport: Fix deadlock
>
> Fabio Estevam <festevam@denx.de>
>      drm/tiny: panel-mipi-dbi: Use drm_client_setup_with_fourcc()
>
> Thomas Zimmermann <tzimmermann@suse.de>
>      drm/panel-mipi-dbi: Run DRM default client setup
>
> Thomas Zimmermann <tzimmermann@suse.de>
>      drm/fbdev-dma: Support struct drm_driver.fbdev_probe
>
> Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
>      Bluetooth: btnxpuart: Fix kernel panic during FW release
>
> Luca Ceresoli <luca.ceresoli@bootlin.com>
>      iio: light: opt3001: fix deadlock due to concurrent flag access
>
> Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
>      accel/ivpu: Fix fw log printing
>
> Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
>      accel/ivpu: Refactor functions in ivpu_fw_log.c
>
> Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>
>      accel/ivpu: Reset fw log on cold boot
>
> Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
>      accel/ivpu: Rename ivpu_log_level to fw_log_level
>
> Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>      mm/page_alloc: fix race condition in unaccepted memory handling
>
> Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
>      drm/xe/gsc: do not flush the GSC worker from the reset path
>
> Ritvik Budhiraja <rbudhiraja@microsoft.com>
>      CIFS: New mount option for cifs.upcall namespace resolution
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
> Barry Song <baohua@kernel.org>
>      mm: userfaultfd: correct dirty flags set for both present and swap pte
>
> Nathan Chancellor <nathan@kernel.org>
>      net: qede: Initialize qede_ll_ops with designated initializer
>
> Steven Rostedt <rostedt@goodmis.org>
>      ring-buffer: Fix persistent buffer when commit page is the reader page
>
> Fedor Pchelkin <pchelkin@ispras.ru>
>      wifi: mt76: disable napi on driver removal
>
> Jarkko Sakkinen <jarkko@kernel.org>
>      tpm: Mask TPM RC in tpm2_start_auth_session()
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
> Nathan Chancellor <nathan@kernel.org>
>      kbuild: Disable -Wdefault-const-init-unsafe
>
> Michael Kelley <mhklinux@outlook.com>
>      Drivers: hv: vmbus: Remove vmbus_sendpacket_pagebuffer()
>
> Michael Kelley <mhklinux@outlook.com>
>      Drivers: hv: Allow vmbus_sendpacket_mpb_desc() to create multiple ranges
>
> Dragan Simic <dsimic@manjaro.org>
>      arm64: dts: rockchip: Remove overdrive-mode OPPs from RK3588J SoC dtsi
>
> Christian Hewitt <christianshewitt@gmail.com>
>      arm64: dts: amlogic: dreambox: fix missing clkc_audio node
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
> Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
>      gpio: pca953x: fix IRQ storm on system wake up
>
> Alexey Makhalov <alexey.makhalov@broadcom.com>
>      MAINTAINERS: Update Alexey Makhalov's email address
>
> Wayne Lin <Wayne.Lin@amd.com>
>      drm/amd/display: Avoid flooding unnecessary info messages
>
> Wayne Lin <Wayne.Lin@amd.com>
>      drm/amd/display: Correct the reply value when AUX write incomplete
>
> Philip Yang <Philip.Yang@amd.com>
>      drm/amdgpu: csa unmap use uninterruptible lock
>
> Tim Huang <tim.huang@amd.com>
>      drm/amdgpu: fix incorrect MALL size for GFX1151
>
> David (Ming Qiang) Wu <David.Wu3@amd.com>
>      drm/amdgpu: read back register after written for VCN v4.0.5
>
> Melissa Wen <mwen@igalia.com>
>      Revert "drm/amd/display: Hardware cursor changes color when switched to software cursor"
>
> Kyoji Ogasawara <sawara04.o@gmail.com>
>      btrfs: add back warning for mount option commit values exceeding 300
>
> Boris Burkov <boris@bur.io>
>      btrfs: fix folio leak in submit_one_async_extent()
>
> Filipe Manana <fdmanana@suse.com>
>      btrfs: fix discard worker infinite loop after disabling discard
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
> Huacai Chen <chenhuacai@kernel.org>
>      LoongArch: Move __arch_cpu_idle() to .cpuidle.text section
>
> Tianyang Zhang <zhangtianyang@loongson.cn>
>      LoongArch: Prevent cond_resched() occurring within kernel-fpu
>
> Rong Zhang <i@rong.moe>
>      HID: bpf: abort dispatch if device destroyed
>
> Jan Kara <jack@suse.cz>
>      udf: Make sure i_lenExtents is uptodate on inode eviction
>
> Tejun Heo <tj@kernel.org>
>      sched_ext: bpf_iter_scx_dsq_new() should always initialize iterator
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
> Pengtao He <hept.hept.hept@gmail.com>
>      net/tls: fix kernel panic when alloc_page failed
>
> Ido Schimmel <idosch@nvidia.com>
>      mlxsw: spectrum_router: Fix use-after-free when deleting GRE net devices
>
> Kees Cook <kees@kernel.org>
>      wifi: mac80211: Set n_channels after allocating struct cfg80211_scan_request
>
> Subbaraya Sundeep <sbhatta@marvell.com>
>      octeontx2-pf: Do not reallocate all ntuple filters
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
> Jakub Kicinski <kuba@kernel.org>
>      netlink: specs: tc: all actions are indexed arrays
>
> Jakub Kicinski <kuba@kernel.org>
>      netlink: specs: tc: fix a couple of attribute names
>
> Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
>      drm/xe: Save CTX_TIMESTAMP mmio value instead of LRC value
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
> Konstantin Shkolnyy <kshk@linux.ibm.com>
>      vsock/test: Fix occasional failure in SIOCOUTQ tests
>
> Jonas Gorski <jonas.gorski@gmail.com>
>      net: dsa: b53: prevent standalone from trying to forward to other ports
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
> Mathieu Othacehe <m.othacehe@gmail.com>
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
> Cosmin Ratiu <cratiu@nvidia.com>
>      tests/ncdevmem: Fix double-free of queue array
>
> Stanislav Fomichev <sdf@fomichev.me>
>      selftests: ncdevmem: Switch to AF_INET6
>
> Stanislav Fomichev <sdf@fomichev.me>
>      selftests: ncdevmem: Make client_ip optional
>
> Stanislav Fomichev <sdf@fomichev.me>
>      selftests: ncdevmem: Unify error handling
>
> Stanislav Fomichev <sdf@fomichev.me>
>      selftests: ncdevmem: Separate out dmabuf provider
>
> Stanislav Fomichev <sdf@fomichev.me>
>      selftests: ncdevmem: Redirect all non-payload output to stderr
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
> Cong Wang <xiyou.wangcong@gmail.com>
>      net_sched: Flush gso_skb list too during ->change()
>
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>      Bluetooth: MGMT: Fix MGMT_OP_ADD_DEVICE invalid device flags
>
> Zhu Yanjun <yanjun.zhu@linux.dev>
>      RDMA/core: Fix "KASAN: slab-use-after-free Read in ib_register_device" problem
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
> Koichiro Den <koichiro.den@canonical.com>
>      virtio_net: ensure netdev_tx_reset_queue is called on bind xsk for tx
>
> Koichiro Den <koichiro.den@canonical.com>
>      virtio_ring: add a func argument 'recycle_done' to virtqueue_reset()
>
> David Lechner <dlechner@baylibre.com>
>      iio: chemical: sps30: use aligned_s64 for timestamp
>
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>      iio: adc: ad7768-1: Fix insufficient alignment of timestamp.
>
> Mathias Nyman <mathias.nyman@linux.intel.com>
>      xhci: dbc: Avoid event polling busyloop if pending rx transfers are inactive.
>
> Mathias Nyman <mathias.nyman@linux.intel.com>
>      xhci: dbc: Improve performance by removing delay in transfer event polling.
>
> Alex Deucher <alexander.deucher@amd.com>
>      Revert "drm/amd: Stop evicting resources on APUs in suspend"
>
> Mario Limonciello <mario.limonciello@amd.com>
>      drm/amd: Add Suspend/Hibernate notification callback support
>
> David Lechner <dlechner@baylibre.com>
>      iio: pressure: mprls0025pa: use aligned_s64 for timestamp
>
> David Lechner <dlechner@baylibre.com>
>      iio: chemical: pms7003: use aligned_s64 for timestamp
>
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>      iio: adc: ad7266: Fix potential timestamp alignment issue.
>
> Sean Christopherson <seanjc@google.com>
>      KVM: x86/mmu: Prevent installing hugepages when mem attributes are changing
>
> Isaku Yamahata <isaku.yamahata@intel.com>
>      KVM: Add member to struct kvm_gfn_range to indicate private/shared
>
> Naman Jain <namjain@linux.microsoft.com>
>      uio_hv_generic: Fix sysfs creation path for ring buffer
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
> Himanshu Bhavani <himanshu.bhavani@siliconsignals.io>
>      arm64: dts: imx8mp-var-som: Fix LDO5 shutdown causing SD card timeout
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
> Ze Huang <huangze@whut.edu.cn>
>      riscv: dts: sophgo: fix DMA data-width configuration for CV18xx
>
> Mario Limonciello <mario.limonciello@amd.com>
>      drivers/platform/x86/amd: pmf: Check for invalid Smart PC Policies
>
> Mario Limonciello <mario.limonciello@amd.com>
>      drivers/platform/x86/amd: pmf: Check for invalid sideloaded Smart PC Policies
>
> Stephen Smalley <stephen.smalley.work@gmail.com>
>      fs/xattr.c: fix simple_xattr_list to always include security.* xattrs
>
> Tom Vincent <linux@tlvince.com>
>      arm64: dts: rockchip: Assign RT5616 MCLK rate on rk3588-friendlyelec-cm3588
>
>
> -------------
>
> Diffstat:
>
>   Documentation/netlink/specs/tc.yaml                |  10 +-
>   MAINTAINERS                                        |   6 +-
>   Makefile                                           |   4 +-
>   .../boot/dts/amlogic/meson-g12b-dreambox.dtsi      |   4 +
>   arch/arm64/boot/dts/freescale/imx8mp-var-som.dtsi  |  12 +-
>   .../dts/rockchip/rk3588-friendlyelec-cm3588.dtsi   |   4 +
>   arch/arm64/boot/dts/rockchip/rk3588j.dtsi          |  53 +--
>   arch/loongarch/include/asm/ptrace.h                |   2 +-
>   arch/loongarch/include/asm/uprobes.h               |   1 -
>   arch/loongarch/kernel/genex.S                      |   7 +-
>   arch/loongarch/kernel/kfpu.c                       |  22 +-
>   arch/loongarch/kernel/time.c                       |   2 +-
>   arch/loongarch/kernel/uprobes.c                    |  11 +-
>   arch/loongarch/power/hibernate.c                   |   3 +
>   arch/riscv/boot/dts/sophgo/cv18xx.dtsi             |   2 +-
>   arch/x86/kvm/mmu/mmu.c                             |  83 ++++-
>   block/bio.c                                        |   2 +-
>   drivers/accel/ivpu/ivpu_debugfs.c                  |   2 +-
>   drivers/accel/ivpu/ivpu_fw.c                       |   4 +-
>   drivers/accel/ivpu/ivpu_fw_log.c                   | 119 +++---
>   drivers/accel/ivpu/ivpu_fw_log.h                   |   9 +-
>   drivers/accel/ivpu/ivpu_pm.c                       |   1 +
>   drivers/acpi/pptt.c                                |  11 +-
>   drivers/bluetooth/btnxpuart.c                      |   6 +-
>   drivers/char/tpm/tpm2-sessions.c                   |  20 +-
>   drivers/char/tpm/tpm_tis_core.h                    |   2 +-
>   drivers/dma-buf/dma-resv.c                         |   5 +-
>   drivers/dma/dmatest.c                              |   6 +-
>   drivers/dma/idxd/init.c                            | 159 +++++---
>   drivers/dma/ti/k3-udma.c                           |  10 +-
>   drivers/gpio/gpio-pca953x.c                        |   6 +
>   drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   3 +-
>   drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |  18 -
>   drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c            |   2 +-
>   drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  47 ++-
>   drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  11 +-
>   drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c             |  12 +
>   drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c            |   8 +
>   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   3 +-
>   .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  16 +-
>   .../drm/amd/display/dc/dpp/dcn401/dcn401_dpp_cm.c  |   5 +-
>   drivers/gpu/drm/drm_fbdev_dma.c                    |  60 +--
>   drivers/gpu/drm/tiny/Kconfig                       |   1 +
>   drivers/gpu/drm/tiny/panel-mipi-dbi.c              |   7 +-
>   drivers/gpu/drm/xe/instructions/xe_mi_commands.h   |   4 +
>   drivers/gpu/drm/xe/xe_gsc.c                        |  22 ++
>   drivers/gpu/drm/xe/xe_gsc.h                        |   1 +
>   drivers/gpu/drm/xe/xe_gsc_proxy.c                  |  11 +
>   drivers/gpu/drm/xe/xe_gsc_proxy.h                  |   1 +
>   drivers/gpu/drm/xe/xe_gt.c                         |   2 +-
>   drivers/gpu/drm/xe/xe_lrc.c                        |   2 +-
>   drivers/gpu/drm/xe/xe_ring_ops.c                   |   7 +-
>   drivers/gpu/drm/xe/xe_uc.c                         |   8 +-
>   drivers/gpu/drm/xe/xe_uc.h                         |   1 +
>   drivers/hid/bpf/hid_bpf_dispatch.c                 |   9 +
>   drivers/hid/hid-thrustmaster.c                     |   1 +
>   drivers/hid/hid-uclogic-core.c                     |   7 +-
>   drivers/hv/channel.c                               |  65 +---
>   drivers/hv/hyperv_vmbus.h                          |   6 +
>   drivers/hv/vmbus_drv.c                             | 100 ++++-
>   drivers/iio/adc/ad7266.c                           |   2 +-
>   drivers/iio/adc/ad7768-1.c                         |   2 +-
>   drivers/iio/chemical/pms7003.c                     |   5 +-
>   drivers/iio/chemical/sps30.c                       |   2 +-
>   drivers/iio/light/opt3001.c                        |   5 +-
>   drivers/iio/pressure/mprls0025pa.h                 |  17 +-
>   drivers/infiniband/core/device.c                   |   6 +-
>   drivers/infiniband/sw/rxe/rxe_cq.c                 |   5 +-
>   drivers/net/dsa/b53/b53_common.c                   |  33 ++
>   drivers/net/dsa/b53/b53_regs.h                     |  14 +
>   drivers/net/dsa/sja1105/sja1105_main.c             |   6 +-
>   drivers/net/ethernet/cadence/macb_main.c           |  19 +-
>   drivers/net/ethernet/engleder/tsnep_main.c         |  30 +-
>   drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   5 +
>   .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c  |   3 +-
>   .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   1 +
>   .../ethernet/marvell/octeontx2/nic/otx2_devlink.c  |   1 +
>   .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |   3 +-
>   drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   2 +-
>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   4 +
>   .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   3 +
>   drivers/net/ethernet/qlogic/qede/qede_main.c       |   2 +-
>   .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |   7 +-
>   drivers/net/hyperv/hyperv_net.h                    |  13 +-
>   drivers/net/hyperv/netvsc.c                        |  57 ++-
>   drivers/net/hyperv/netvsc_drv.c                    |  62 +---
>   drivers/net/hyperv/rndis_filter.c                  |  24 +-
>   drivers/net/virtio_net.c                           |   5 +-
>   drivers/net/wireless/mediatek/mt76/dma.c           |   1 +
>   drivers/nvme/host/pci.c                            |   4 +-
>   drivers/phy/renesas/phy-rcar-gen3-usb2.c           |  38 +-
>   drivers/phy/tegra/xusb-tegra186.c                  |  46 ++-
>   drivers/phy/tegra/xusb.c                           |   8 +-
>   drivers/platform/x86/amd/pmc/pmc-quirks.c          |   7 +
>   drivers/platform/x86/amd/pmf/tee-if.c              |  23 +-
>   drivers/platform/x86/asus-wmi.c                    |   3 +-
>   drivers/regulator/max20086-regulator.c             |   7 +-
>   drivers/scsi/sd_zbc.c                              |   6 +-
>   drivers/scsi/storvsc_drv.c                         |   1 +
>   drivers/spi/spi-loopback-test.c                    |   2 +-
>   drivers/spi/spi-tegra114.c                         |   6 +-
>   drivers/uio/uio_hv_generic.c                       |  39 +-
>   drivers/usb/gadget/function/f_midi2.c              |   2 +-
>   drivers/usb/host/xhci-dbgcap.c                     |  21 +-
>   drivers/usb/host/xhci-dbgcap.h                     |   3 +
>   drivers/usb/typec/ucsi/displayport.c               |  19 +-
>   drivers/usb/typec/ucsi/ucsi.c                      |  34 ++
>   drivers/usb/typec/ucsi/ucsi.h                      |   2 +
>   drivers/virtio/virtio_ring.c                       |   6 +-
>   fs/binfmt_elf.c                                    |  71 ++--
>   fs/btrfs/discard.c                                 |  17 +-
>   fs/btrfs/fs.h                                      |   1 +
>   fs/btrfs/inode.c                                   |   7 +
>   fs/btrfs/super.c                                   |   4 +
>   fs/nfs/nfs4proc.c                                  |   9 +-
>   fs/nfs/pnfs.c                                      |   9 +
>   fs/smb/client/cifs_spnego.c                        |  16 +
>   fs/smb/client/cifsfs.c                             |  25 ++
>   fs/smb/client/cifsglob.h                           |   7 +
>   fs/smb/client/connect.c                            |  20 +
>   fs/smb/client/fs_context.c                         |  39 ++
>   fs/smb/client/fs_context.h                         |  10 +
>   fs/smb/client/smb2pdu.c                            |   2 +-
>   fs/udf/truncate.c                                  |   2 +-
>   fs/xattr.c                                         |  24 ++
>   include/drm/drm_fbdev_dma.h                        |  12 +
>   include/linux/bio.h                                |   1 +
>   include/linux/hyperv.h                             |  13 +-
>   include/linux/kvm_host.h                           |   6 +
>   include/linux/tpm.h                                |  21 +-
>   include/linux/virtio.h                             |   3 +-
>   include/net/sch_generic.h                          |  15 +
>   include/sound/ump_msg.h                            |   4 +-
>   kernel/cgroup/cpuset.c                             |   6 +-
>   kernel/sched/ext.c                                 |   6 +
>   kernel/trace/ring_buffer.c                         |   8 +-
>   kernel/trace/trace_dynevent.c                      |  16 +-
>   kernel/trace/trace_dynevent.h                      |   1 +
>   kernel/trace/trace_events_trigger.c                |   2 +-
>   kernel/trace/trace_functions.c                     |   6 +-
>   kernel/trace/trace_kprobe.c                        |   2 +-
>   kernel/trace/trace_probe.c                         |   9 +
>   kernel/trace/trace_uprobe.c                        |   2 +-
>   mm/page_alloc.c                                    |  23 --
>   mm/userfaultfd.c                                   |  12 +-
>   net/bluetooth/mgmt.c                               |   9 +-
>   net/mac80211/main.c                                |   6 +-
>   net/mctp/device.c                                  |  65 ++--
>   net/mctp/route.c                                   |   4 +-
>   net/sched/sch_codel.c                              |   2 +-
>   net/sched/sch_fq.c                                 |   2 +-
>   net/sched/sch_fq_codel.c                           |   2 +-
>   net/sched/sch_fq_pie.c                             |   2 +-
>   net/sched/sch_hhf.c                                |   2 +-
>   net/sched/sch_pie.c                                |   2 +-
>   net/tls/tls_strp.c                                 |   3 +-
>   samples/ftrace/sample-trace-array.c                |   2 +-
>   scripts/Makefile.extrawarn                         |  12 +
>   sound/core/seq/seq_clientmgr.c                     |  52 ++-
>   sound/core/seq/seq_ump_convert.c                   |  18 +
>   sound/core/seq/seq_ump_convert.h                   |   1 +
>   sound/pci/es1968.c                                 |   6 +-
>   sound/sh/Kconfig                                   |   2 +-
>   sound/usb/quirks.c                                 |   4 +
>   tools/net/ynl/ethtool.py                           |  22 +-
>   tools/testing/selftests/net/ncdevmem.c             | 404 ++++++++++++---------
>   tools/testing/vsock/vsock_test.c                   |  28 +-
>   virt/kvm/guest_memfd.c                             |   2 +
>   virt/kvm/kvm_main.c                                |  14 +
>   169 files changed, 1823 insertions(+), 918 deletions(-)
>
>
