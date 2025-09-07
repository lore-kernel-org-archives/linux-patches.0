Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B646189BB0;
	Sun,  7 Sep 2025 20:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276607; cv=none; b=NkZSyfWSZ3hOi+gh6Mt/tJQexZwIOSwrG5RX8Fe+Rpem7u/9ycLM7pS6js4W9vtDEJTS68nM8cJOgkcx8htqMAnxte3wbtJqy5lOR2WsQeK1UiVDxkj1PWk1ULSLKLJ7siIN39/I/SxIIMGIn4JDcX2YKP7B2acjeoCJJ9CenX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276607; c=relaxed/simple;
	bh=RqQWIAy7mCvCEcxdj3WSoZ+obgb8xydnvdsK7II8STI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YU7zRyCFIYscup7uyFc2vx6fjxAZu3qaQx75l4Wyab9qpYLVFBI2HTKEzPVyRwMUgTXovvRY6/WTacmrIZcpeyj8ObalxBw7YHD6ztqFZJCmlnc9Hq3RXb4PQoDfxCVdpRXc3un3AIlvxmC6thwKrvkXS/ZOleGoZYHBNym18GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtJtHvEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtJtHvEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A808EC4CEF0;
	Sun,  7 Sep 2025 20:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276607;
	bh=RqQWIAy7mCvCEcxdj3WSoZ+obgb8xydnvdsK7II8STI=;
	h=From:To:Cc:Subject:Date:From;
	b=qtJtHvECcSvJOM4fjPQMFuDrurKhK81xDYWwArlBD6EhAfsHdVYyHpk6KqYVYetcy
	 MpUDOhdAtzuWJSm2D04qhF0QtOH5tLuCrNgKCstdBuGJfH60C/7LHNsCEV7XkFNh18
	 0sS+1MZIYHoase6twiheMU/T40WuFHDRor5BK8+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@denx.de,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org
Subject: [PATCH 6.6 000/121] 6.6.105-rc1 review
Date: Sun,  7 Sep 2025 21:57:16 +0200
Message-ID: <20250907195609.817339617@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.105-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.105-rc1
X-KernelTest-Deadline: 2025-09-09T19:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.105 release.
There are 121 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.105-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.105-rc1

Kevin Hao <haokexin@gmail.com>
    spi: fsl-qspi: Fix double cleanup in probe error path

Qiu-ji Chen <chenqiuji666@gmail.com>
    dmaengine: mediatek: Fix a flag reuse error in mtk_cqdma_tx_status()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Check turbo_is_disabled() in store_no_turbo()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Read global.no_turbo under READ_ONCE()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Rearrange show_no_turbo() and store_no_turbo()

Radim Krčmář <rkrcmar@ventanamicro.com>
    riscv: use lw when reading int cpu in asm_per_cpu

yangshiguang <yangshiguang@xiaomi.com>
    mm: slub: avoid wake up kswapd in set_track_prepare

Chengming Zhou <zhouchengming@bytedance.com>
    slub: Reflow ___slab_alloc()

zhang jiao <zhangjiao2@cmss.chinamobile.com>
    tools: gpio: remove the include directory on make clean

zhangjiao <zhangjiao2@cmss.chinamobile.com>
    tools: gpio: rm .*.cmd on make clean

Colin Ian King <colin.i.king@gmail.com>
    drm/amd/amdgpu: Fix missing error return on kzalloc failure

Hawking Zhang <Hawking.Zhang@amd.com>
    drm/amdgpu: Replace DRM_* with dev_* in amdgpu_psp.c

Ian Rogers <irogers@google.com>
    perf bpf-utils: Harden get_bpf_prog_info_linear

Ian Rogers <irogers@google.com>
    perf bpf-utils: Constify bpil_array_desc

Ian Rogers <irogers@google.com>
    perf bpf-event: Fix use-after-free in synthesis

Michael Walle <mwalle@kernel.org>
    drm/bridge: ti-sn65dsi86: fix REFCLK setting

Larisa Grigore <larisa.grigore@nxp.com>
    spi: spi-fsl-lpspi: Clear status register after disabling the module

Larisa Grigore <larisa.grigore@nxp.com>
    spi: spi-fsl-lpspi: Reset FIFO and disable module on transfer abort

Larisa Grigore <larisa.grigore@nxp.com>
    spi: spi-fsl-lpspi: Set correct chip-select polarity bit

Larisa Grigore <larisa.grigore@nxp.com>
    spi: spi-fsl-lpspi: Fix transmissions when using CONT

Vadim Pasternak <vadimp@nvidia.com>
    hwmon: mlxreg-fan: Prevent fans from getting stuck at 0 RPM

Wentao Liang <vulab@iscas.ac.cn>
    pcmcia: Add error handling for add_interval() in do_validate_mem()

Chen Ni <nichen@iscas.ac.cn>
    pcmcia: omap: Add missing check for platform_get_resource

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/amdgpu: Avoid extra evict-restore process."

Aaron Erhardt <aer@tuxedocomputers.com>
    ALSA: hda/realtek: Fix headset mic for TongFang X6[AF]R5xxY

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/hdmi: Add pin fix for another HP EliteDesk 800 G4 model

Ma Ke <make24@iscas.ac.cn>
    drm/mediatek: Fix device/node reference count leaks in mtk_drm_get_all_drm_priv

Jason-JH.Lin <jason-jh.lin@mediatek.com>
    drm/mediatek: Fix using wrong drm private data to bind mediatek-drm

Jason-JH.Lin <jason-jh.lin@mediatek.com>
    drm/mediatek: Add crtc path enum for all_drm_priv array

Ronak Doshi <ronak.doshi@broadcom.com>
    vmxnet3: update MTU after device quiesce

Jakob Unterwurzacher <jakobunt@gmail.com>
    net: dsa: microchip: linearize skb for tail-tagging switches

Pieter Van Trappen <pieter.van.trappen@cern.ch>
    net: dsa: microchip: update tag_ksz masks for KSZ9477 family

Qiu-ji Chen <chenqiuji666@gmail.com>
    dmaengine: mediatek: Fix a possible deadlock error in mtk_cqdma_tx_status()

Chris Chiu <chris.chiu@canonical.com>
    ALSA: hda/realtek - Add new HP ZBook laptop with micmute led fixup

Stefan Binding <sbinding@opensource.cirrus.com>
    ALSA: hda/realtek: Add support for HP Agusta using CS35L41 HDA

David Lechner <dlechner@baylibre.com>
    iio: pressure: mprls0025pa: use aligned_s64 for timestamp

Luca Ceresoli <luca.ceresoli@bootlin.com>
    iio: light: opt3001: fix deadlock due to concurrent flag access

David Lechner <dlechner@baylibre.com>
    iio: chemical: pms7003: use aligned_s64 for timestamp

David Lechner <dlechner@baylibre.com>
    iio: imu: inv_mpu6050: align buffer for timestamp

Josef Bacik <josef@toxicpanda.com>
    btrfs: adjust subpage bit start based on sectorsize

Shakeel Butt <shakeel.butt@linux.dev>
    memcg: drain obj stock on cpu hotplug teardown

Jonathan Currier <dullfire@yahoo.com>
    PCI/MSI: Add an option to write MSIX ENTRY_DATA before any reads

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    thermal/drivers/mediatek/lvts: Disable low offset IRQ for minimum threshold

Han Xu <han.xu@nxp.com>
    spi: fsl-qspi: use devm function instead of driver remove

Li Qiong <liqiong@nfschina.com>
    mm/slub: avoid accessing metadata when pointer is invalid in object_err()

Dave Airlie <airlied@redhat.com>
    nouveau: fix disabling the nonstall irq due to storm code

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    cpufreq: intel_pstate: Unchecked MSR aceess in legacy mode

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Do not update global.turbo_disabled after initialization

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Fold intel_pstate_max_within_limits() into caller

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    cpufreq: intel_pstate: Revise global turbo disable check

Jinfeng Wang <jinfeng.wang.cn@windriver.com>
    Revert "spi: spi-cadence-quadspi: Fix pm runtime unbalance"

Jinfeng Wang <jinfeng.wang.cn@windriver.com>
    Revert "spi: cadence-quadspi: fix cleanup of rx_chan on failure paths"

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    net: pcs: rzn1-miic: Correct MODCTRL register offset

Vitaly Lifshits <vitaly.lifshits@intel.com>
    e1000e: fix heap overflow in e1000_set_eeprom

Makar Semyonov <m.semenov@tssltd.ru>
    cifs: prevent NULL pointer dereference in UTF16 conversion

Stanislav Fort <stanislav.fort@aisle.com>
    batman-adv: fix OOB read/write in network-coding decode

John Evans <evans1210144@gmail.com>
    scsi: lpfc: Fix buffer free/clear order in deferred receive path

Christoffer Sandberg <cs@tuxedo.de>
    platform/x86/amd/pmc: Add TUXEDO IB Pro Gen10 AMD to spurious 8042 quirks list

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: drop hw access in non-DC audio fini

Nathan Chancellor <nathan@kernel.org>
    wifi: mt76: mt7996: Initialize hdr before passing to skb_put_data()

Qianfeng Rong <rongqianfeng@vivo.com>
    wifi: mwifiex: Initialize the chan_stats array to zero

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    soc: qcom: mdt_loader: Deal with zero e_shentsize

wangzijie <wangzijie1@honor.com>
    proc: fix missing pde_set_flags() for net proc files

Edward Adam Davis <eadavis@qq.com>
    ocfs2: prevent release journal inode after journal shutdown

Christian Loehle <christian.loehle@arm.com>
    sched: Fix sched_numa_find_nth_cpu() if mask offline

Harry Yoo <harry.yoo@oracle.com>
    mm: move page table sync declarations to linux/pgtable.h

Harry Yoo <harry.yoo@oracle.com>
    x86/mm/64: define ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings()

Ma Ke <make24@iscas.ac.cn>
    pcmcia: Fix a NULL pointer dereference in __iodyn_find_io_region()

panfan <panfan@qti.qualcomm.com>
    arm64: ftrace: fix unreachable PLT for ftrace_caller in init_module with CONFIG_DYNAMIC_FTRACE

Miaoqian Lin <linmq006@gmail.com>
    ACPI/IORT: Fix memory leak in iort_rmr_alloc_sids()

Cryolitia PukNgae <cryolitia@uniontech.com>
    ALSA: usb-audio: Add mute TLV for playback volumes on some devices

Horatiu Vultur <horatiu.vultur@microchip.com>
    phy: mscc: Stop taking ts_lock for tx_queue and use its own lock

Kuniyuki Iwashima <kuniyu@google.com>
    selftest: net: Fix weird setsockopt() in bind_bhash.c.

Qingfang Deng <dqfext@gmail.com>
    ppp: fix memory leak in pad_compress_skb

Wang Liang <wangliang74@huawei.com>
    net: atm: fix memory leak in atm_register_sysfs when device_register fail

Eric Dumazet <edumazet@google.com>
    ax25: properly unshare skbs in ax25_kiss_rcv()

Alok Tiwari <alok.a.tiwari@oracle.com>
    mctp: return -ENOPROTOOPT for unknown getsockopt options

Mahanta Jambigi <mjambigi@linux.ibm.com>
    net/smc: Remove validation of reserved bits in CLC Decline message

Dan Carpenter <dan.carpenter@linaro.org>
    ipv4: Fix NULL vs error pointer check in inet_blackhole_dev_init()

Rosen Penev <rosenp@gmail.com>
    net: thunder_bgx: decrement cleanup index before use

Rosen Penev <rosenp@gmail.com>
    net: thunder_bgx: add a missing of_node_put

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: cfg80211: sme: cap SSID length in __cfg80211_connect_result()

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: libertas: cap SSID len in lbs_associate()

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: cw1200: cap SSID length in cw1200_do_join()

Felix Fietkau <nbd@nbd.name>
    net: ethernet: mtk_eth_soc: fix tx vlan tag for llc packets

Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
    wifi: ath11k: fix group data packet drops during rekey

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: avoid forward declaration of ath11k_mac_start_vdev_delay()

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: rename ath11k_start_vdev_delay()

Jeff Johnson <quic_jjohnson@quicinc.com>
    wifi: ath11k: Introduce and use ath11k_sta_to_arsta()

Zhen Ni <zhen.ni@easystack.cn>
    i40e: Fix potential invalid access when MAC list is empty

Liu Jian <liujian56@huawei.com>
    net/smc: fix one NULL pointer dereference in smc_ib_is_sg_need_sync()

Sabrina Dubroca <sd@queasysnail.net>
    macsec: read MACSEC_SA_ATTR_PN with nla_get_uint

Jakub Kicinski <kuba@kernel.org>
    netlink: add variable-length / auto integers

Sean Anderson <sean.anderson@linux.dev>
    net: macb: Fix tx_ptr_lock locking

Fabian Bläse <fabian@blaese.de>
    icmp: fix icmp_ndo_send address translation for reply direction

Miaoqian Lin <linmq006@gmail.com>
    mISDN: Fix memory leak in dsp_hwec_enable()

Alok Tiwari <alok.a.tiwari@oracle.com>
    xirc2ps_cs: fix register access when enabling FullDuplex

Kuniyuki Iwashima <kuniyu@google.com>
    Bluetooth: Fix use-after-free in l2cap_sock_cleanup_listen()

Ivan Pravdin <ipravdin.official@gmail.com>
    Bluetooth: vhci: Prevent use-after-free by removing debugfs files early

Phil Sutter <phil@nwl.cc>
    netfilter: conntrack: helper: Replace -EEXIST by -EBUSY

Wang Liang <wangliang74@huawei.com>
    netfilter: br_netfilter: do not check confirmed bit in br_nf_local_in() after confirm

Duoming Zhou <duoming@zju.edu.cn>
    wifi: brcmfmac: fix use-after-free when rescheduling brcmf_btcoex_info work

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: cfg80211: fix use-after-free in cmp_bss()

Marek Vasut <marek.vasut@mailbox.org>
    arm64: dts: imx8mp: Fix missing microSD slot vqmmc on Data Modul i.MX8M Plus eDM SBC

Marek Vasut <marek.vasut@mailbox.org>
    arm64: dts: imx8mp: Fix missing microSD slot vqmmc on DH electronics i.MX8M Plus DHCOM

Sungbae Yoo <sungbaey@nvidia.com>
    tee: optee: ffa: fix a typo of "optee_ffa_api_is_compatible"

Peter Robinson <pbrobinson@gmail.com>
    arm64: dts: rockchip: Add vcc-supply to SPI flash on rk3399-pinebook-pro

Pei Xiao <xiaopei01@kylinos.cn>
    tee: fix NULL pointer dereference in tee_shm_put

Jiufei Xue <jiufei.xue@samsung.com>
    fs: writeback: fix use-after-free in __mark_inode_dirty()

Yang Li <yang.li@amlogic.com>
    Bluetooth: hci_sync: Avoid adding default advertising on startup

Shinji Nomoto <fj5851bi@fujitsu.com>
    cpupower: Fix a bug where the -t option of the set subcommand was not working.

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Don't warn when missing DCE encoder caps

Lubomir Rintel <lkundrak@v3.sk>
    cdc_ncm: Flag Intel OEM version of Fibocom L850-GL as WWAN

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Save LBT before FPU in setup_sigcontext()

Filipe Manana <fdmanana@suse.com>
    btrfs: avoid load/store tearing races when checking if an inode was logged

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race between setting last_dir_index_offset and inode logging

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race between logging inode and checking if it was logged before

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix oob access in cgroup local storage

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Move bpf map owner out of common struct

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Move cgroup iterator helpers to bpf.h

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Add cookie object to bpf maps


-------------

Diffstat:

 Documentation/userspace-api/netlink/specs.rst      |  18 +-
 Makefile                                           |   4 +-
 .../dts/freescale/imx8mp-data-modul-edm-sbc.dts    |   1 +
 .../arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi |   1 +
 .../boot/dts/rockchip/rk3399-pinebook-pro.dts      |   1 +
 arch/arm64/include/asm/module.h                    |   1 +
 arch/arm64/include/asm/module.lds.h                |   1 +
 arch/arm64/kernel/ftrace.c                         |  13 +-
 arch/arm64/kernel/module-plts.c                    |  12 +-
 arch/arm64/kernel/module.c                         |  11 +
 arch/loongarch/kernel/signal.c                     |  10 +-
 arch/riscv/include/asm/asm.h                       |   2 +-
 arch/x86/include/asm/pgtable_64_types.h            |   3 +
 arch/x86/mm/init_64.c                              |  18 +
 drivers/acpi/arm64/iort.c                          |   4 +-
 drivers/bluetooth/hci_vhci.c                       |  57 +-
 drivers/cpufreq/intel_pstate.c                     | 126 ++---
 drivers/dma/mediatek/mtk-cqdma.c                   |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            | 146 ++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/dce_v10_0.c             |   5 -
 drivers/gpu/drm/amd/amdgpu/dce_v11_0.c             |   5 -
 drivers/gpu/drm/amd/amdgpu/dce_v6_0.c              |   5 -
 drivers/gpu/drm/amd/amdgpu/dce_v8_0.c              |   5 -
 .../gpu/drm/amd/display/dc/dce/dce_link_encoder.c  |   8 +-
 drivers/gpu/drm/bridge/ti-sn65dsi86.c              |  11 +
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |  42 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.h             |   8 +-
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/base.c    |   2 +
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/ga100.c   |  23 +-
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/ga102.c   |   1 +
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/priv.h    |   2 +
 drivers/hwmon/mlxreg-fan.c                         |   5 +-
 drivers/iio/chemical/pms7003.c                     |   5 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c         |   2 +-
 drivers/iio/light/opt3001.c                        |   5 +-
 drivers/iio/pressure/mprls0025pa.c                 |  10 +-
 drivers/isdn/mISDN/dsp_hwec.c                      |   6 +-
 drivers/net/ethernet/cadence/macb_main.c           |  28 +-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |  20 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c        |  10 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c      |   4 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  10 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c           |   2 +-
 drivers/net/macsec.c                               |   8 +-
 drivers/net/pcs/pcs-rzn1-miic.c                    |   2 +-
 drivers/net/phy/mscc/mscc_ptp.c                    |  18 +-
 drivers/net/ppp/ppp_generic.c                      |   6 +-
 drivers/net/usb/cdc_ncm.c                          |   7 +
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   5 +-
 drivers/net/wireless/ath/ath11k/core.h             |   7 +
 drivers/net/wireless/ath/ath11k/debugfs.c          |   4 +-
 drivers/net/wireless/ath/ath11k/debugfs_sta.c      |  30 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   8 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |   4 +-
 drivers/net/wireless/ath/ath11k/mac.c              | 588 ++++++++++++---------
 drivers/net/wireless/ath/ath11k/peer.c             |   2 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/btcoex.c  |   6 +-
 drivers/net/wireless/marvell/libertas/cfg.c        |   9 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   5 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |   4 +-
 drivers/net/wireless/st/cw1200/sta.c               |   2 +-
 drivers/pci/msi/msi.c                              |   3 +
 drivers/pcmcia/omap_cf.c                           |   2 +
 drivers/pcmcia/rsrc_iodyn.c                        |   3 +
 drivers/pcmcia/rsrc_nonstatic.c                    |   4 +-
 drivers/platform/x86/amd/pmc/pmc-quirks.c          |  14 +
 drivers/scsi/lpfc/lpfc_nvmet.c                     |  10 +-
 drivers/soc/qcom/mdt_loader.c                      |  12 +-
 drivers/spi/spi-cadence-quadspi.c                  |   6 +-
 drivers/spi/spi-fsl-lpspi.c                        |  24 +-
 drivers/spi/spi-fsl-qspi.c                         |  36 +-
 drivers/tee/optee/ffa_abi.c                        |   4 +-
 drivers/tee/tee_shm.c                              |   6 +-
 drivers/thermal/mediatek/lvts_thermal.c            |  50 +-
 fs/btrfs/btrfs_inode.h                             |   2 +-
 fs/btrfs/extent_io.c                               |   2 +-
 fs/btrfs/inode.c                                   |   1 +
 fs/btrfs/tree-log.c                                |  78 ++-
 fs/fs-writeback.c                                  |   9 +-
 fs/ocfs2/inode.c                                   |   3 +
 fs/proc/generic.c                                  |  38 +-
 fs/smb/client/cifs_unicode.c                       |   3 +
 include/linux/bpf-cgroup.h                         |   5 -
 include/linux/bpf.h                                |  60 ++-
 include/linux/pci.h                                |   2 +
 include/linux/pgtable.h                            |  16 +
 include/linux/vmalloc.h                            |  16 -
 include/net/netlink.h                              |  69 ++-
 include/uapi/linux/netlink.h                       |   5 +
 kernel/bpf/core.c                                  |  50 +-
 kernel/bpf/syscall.c                               |  20 +-
 kernel/sched/topology.c                            |   2 +
 lib/nlattr.c                                       |  22 +
 mm/memcontrol.c                                    |   9 +
 mm/slub.c                                          |  66 ++-
 net/atm/resources.c                                |   6 +-
 net/ax25/ax25_in.c                                 |   4 +
 net/batman-adv/network-coding.c                    |   7 +-
 net/bluetooth/hci_sync.c                           |   2 +-
 net/bluetooth/l2cap_sock.c                         |   3 +
 net/bridge/br_netfilter_hooks.c                    |   3 -
 net/dsa/tag_ksz.c                                  |  22 +-
 net/ipv4/devinet.c                                 |   7 +-
 net/ipv4/icmp.c                                    |   6 +-
 net/ipv6/ip6_icmp.c                                |   6 +-
 net/mctp/af_mctp.c                                 |   2 +-
 net/netfilter/nf_conntrack_helper.c                |   4 +-
 net/netlink/policy.c                               |  14 +-
 net/smc/smc_clc.c                                  |   2 -
 net/smc/smc_ib.c                                   |   3 +
 net/wireless/scan.c                                |   3 +-
 net/wireless/sme.c                                 |   5 +-
 sound/pci/hda/patch_hdmi.c                         |   1 +
 sound/pci/hda/patch_realtek.c                      |   5 +
 sound/usb/mixer_quirks.c                           |   2 +
 tools/gpio/Makefile                                |   4 +-
 tools/perf/util/bpf-event.c                        |  39 +-
 tools/perf/util/bpf-utils.c                        |  61 ++-
 tools/power/cpupower/utils/cpupower-set.c          |   4 +-
 tools/testing/selftests/net/bind_bhash.c           |   4 +-
 123 files changed, 1405 insertions(+), 860 deletions(-)


