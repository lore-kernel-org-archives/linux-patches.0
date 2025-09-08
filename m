Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3C3307AFC;
	Mon,  8 Sep 2025 16:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757347503; cv=none; b=ZxSCUv7CLyRwVhxqFkGDzBEcssy5xLw+rUwlBwKl9vtNKObxnVlQMhtnKwp4EMVgSx1VAxlObTuOY/Q5usW6OwUn5/afKNXw59D4RV+byEZWmRjWq0G2BJAnOLBQUkWaXRO4JpltdqCwhtDOsO7rlL3hC4022leFv/9fgmQh9QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757347503; c=relaxed/simple;
	bh=b6cHxSurIqXx0T0Qs6hHaBEDR5p0rHgc2P/jMNeaaPE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Rf8mZ7zDQyoiFOJSrAULDjxeoJGLnuxJ37bUoelijL3d3KgSTpMh0PkMiw/l6WHtuN6iFcmnXwsqSNaMo16DYer5c6sEyQHIcr2JdtYamF5MAnFQHhxkuxqfEeYiWBMBT0qCA9O1Aru5UDWI9x0pHOhYf99qUV4l05wLohUuw7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JAY0O5IX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JAY0O5IX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C49C4CEF1;
	Mon,  8 Sep 2025 16:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757347502;
	bh=b6cHxSurIqXx0T0Qs6hHaBEDR5p0rHgc2P/jMNeaaPE=;
	h=From:To:Cc:Subject:Date:From;
	b=JAY0O5IXt9fwMJ6mxU4AfONeFZOaIgDb1W8yd8qHV/E0Cp5kxcjpxnuwilCZ4RIxT
	 j9XcBN2ANiWaDRhvv73qCCo75kpuV7qnrdGGlqRrvvcSodLcZxMaWmIwI+sopGiEBK
	 xSOFkXVMdmrfbg0jGpGnv6hje6EoXDE/RHJZb5Qc=
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
Subject: [PATCH 6.1 000/101] 6.1.151-rc2 review
Date: Mon,  8 Sep 2025 18:04:58 +0200
Message-ID: <20250908151840.509077218@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.151-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.151-rc2
X-KernelTest-Deadline: 2025-09-10T15:18+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.151 release.
There are 101 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 10 Sep 2025 15:18:27 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.151-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.151-rc2

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Check turbo_is_disabled() in store_no_turbo()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Read global.no_turbo under READ_ONCE()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Rearrange show_no_turbo() and store_no_turbo()

Aaron Kling <webgeek1234@gmail.com>
    spi: tegra114: Use value to check for invalid delays

Qiu-ji Chen <chenqiuji666@gmail.com>
    dmaengine: mediatek: Fix a flag reuse error in mtk_cqdma_tx_status()

yangshiguang <yangshiguang@xiaomi.com>
    mm: slub: avoid wake up kswapd in set_track_prepare

Chengming Zhou <zhouchengming@bytedance.com>
    slub: Reflow ___slab_alloc()

Vlastimil Babka <vbabka@suse.cz>
    mm, slub: refactor free debug processing

zhang jiao <zhangjiao2@cmss.chinamobile.com>
    tools: gpio: remove the include directory on make clean

zhangjiao <zhangjiao2@cmss.chinamobile.com>
    tools: gpio: rm .*.cmd on make clean

Colin Ian King <colin.i.king@gmail.com>
    drm/amd/amdgpu: Fix missing error return on kzalloc failure

Hawking Zhang <Hawking.Zhang@amd.com>
    drm/amdgpu: Replace DRM_* with dev_* in amdgpu_psp.c

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Make flashing messages quieter

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Skip TMR allocation if not required

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/amdgpu: Fix style problems in amdgpu_psp.c

Tao Zhou <tao.zhou1@amd.com>
    drm/amdgpu: remove the check of init status in psp_ras_initialize

Candice Li <candice.li@amd.com>
    drm/amdgpu: Optimize RAS TA initialization and TA unload funcs

Michael Walle <mwalle@kernel.org>
    drm/bridge: ti-sn65dsi86: fix REFCLK setting

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

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check link_res->hpo_dp_link_enc before using it

Amir Goldstein <amir73il@gmail.com>
    fs: relax assertions on failure to encode file handles

Stefan Binding <sbinding@opensource.cirrus.com>
    ALSA: hda/realtek: Add support for HP Agusta using CS35L41 HDA

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    cpufreq: intel_pstate: Unchecked MSR aceess in legacy mode

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Do not update global.turbo_disabled after initialization

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Fold intel_pstate_max_within_limits() into caller

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    cpufreq: intel_pstate: Revise global turbo disable check

Aaron Kling <webgeek1234@gmail.com>
    spi: tegra114: Don't fail set_cs_timing when delays are zero

Alexander Danilenko <al.b.danilenko@gmail.com>
    spi: tegra114: Remove unnecessary NULL-pointer checks

Ronak Doshi <ronak.doshi@broadcom.com>
    vmxnet3: update MTU after device quiesce

Jakob Unterwurzacher <jakobunt@gmail.com>
    net: dsa: microchip: linearize skb for tail-tagging switches

Pieter Van Trappen <pieter.van.trappen@cern.ch>
    net: dsa: microchip: update tag_ksz masks for KSZ9477 family

Chris Chiu <chris.chiu@canonical.com>
    ALSA: hda/realtek - Add new HP ZBook laptop with micmute led fixup

Qiu-ji Chen <chenqiuji666@gmail.com>
    dmaengine: mediatek: Fix a possible deadlock error in mtk_cqdma_tx_status()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: designware: Fix an error handling path in i2c_dw_pci_probe()

Luca Ceresoli <luca.ceresoli@bootlin.com>
    iio: light: opt3001: fix deadlock due to concurrent flag access

David Lechner <dlechner@baylibre.com>
    iio: chemical: pms7003: use aligned_s64 for timestamp

Josef Bacik <josef@toxicpanda.com>
    btrfs: adjust subpage bit start based on sectorsize

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq/sched: Explicitly synchronize limits_changed flag handling

Jonathan Currier <dullfire@yahoo.com>
    PCI/MSI: Add an option to write MSIX ENTRY_DATA before any reads

Li Qiong <liqiong@nfschina.com>
    mm/slub: avoid accessing metadata when pointer is invalid in object_err()

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

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: drop hw access in non-DC audio fini

Qianfeng Rong <rongqianfeng@vivo.com>
    wifi: mwifiex: Initialize the chan_stats array to zero

wangzijie <wangzijie1@honor.com>
    proc: fix missing pde_set_flags() for net proc files

Edward Adam Davis <eadavis@qq.com>
    ocfs2: prevent release journal inode after journal shutdown

Harry Yoo <harry.yoo@oracle.com>
    mm: move page table sync declarations to linux/pgtable.h

Harry Yoo <harry.yoo@oracle.com>
    x86/mm/64: define ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings()

Ma Ke <make24@iscas.ac.cn>
    pcmcia: Fix a NULL pointer dereference in __iodyn_find_io_region()

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

Zhen Ni <zhen.ni@easystack.cn>
    i40e: Fix potential invalid access when MAC list is empty

Liu Jian <liujian56@huawei.com>
    net/smc: fix one NULL pointer dereference in smc_ib_is_sg_need_sync()

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

Phil Sutter <phil@nwl.cc>
    netfilter: conntrack: helper: Replace -EEXIST by -EBUSY

Wang Liang <wangliang74@huawei.com>
    netfilter: br_netfilter: do not check confirmed bit in br_nf_local_in() after confirm

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: cfg80211: fix use-after-free in cmp_bss()

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

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Don't warn when missing DCE encoder caps

Lubomir Rintel <lkundrak@v3.sk>
    cdc_ncm: Flag Intel OEM version of Fibocom L850-GL as WWAN

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

 Makefile                                           |   4 +-
 .../arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi |   1 +
 .../boot/dts/rockchip/rk3399-pinebook-pro.dts      |   1 +
 arch/x86/include/asm/pgtable_64_types.h            |   3 +
 arch/x86/mm/init_64.c                              |  18 ++
 drivers/acpi/arm64/iort.c                          |   4 +-
 drivers/cpufreq/intel_pstate.c                     | 126 ++++-------
 drivers/dma/mediatek/mtk-cqdma.c                   |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            | 235 +++++++++++----------
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/dce_v10_0.c             |   5 -
 drivers/gpu/drm/amd/amdgpu/dce_v11_0.c             |   5 -
 drivers/gpu/drm/amd/amdgpu/dce_v6_0.c              |   5 -
 drivers/gpu/drm/amd/amdgpu/dce_v8_0.c              |   5 -
 .../gpu/drm/amd/display/dc/dce/dce_link_encoder.c  |   8 +-
 .../gpu/drm/amd/display/dc/link/link_hwss_hpo_dp.c |   7 +
 drivers/gpu/drm/bridge/ti-sn65dsi86.c              |  11 +
 drivers/hwmon/mlxreg-fan.c                         |   5 +-
 drivers/i2c/busses/i2c-designware-pcidrv.c         |   4 +-
 drivers/iio/chemical/pms7003.c                     |   5 +-
 drivers/iio/light/opt3001.c                        |   5 +-
 drivers/isdn/mISDN/dsp_hwec.c                      |   6 +-
 drivers/net/ethernet/cadence/macb_main.c           |  28 +--
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |  20 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c        |  10 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c      |   4 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  10 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c           |   2 +-
 drivers/net/pcs/pcs-rzn1-miic.c                    |   2 +-
 drivers/net/phy/mscc/mscc_ptp.c                    |  18 +-
 drivers/net/ppp/ppp_generic.c                      |   6 +-
 drivers/net/usb/cdc_ncm.c                          |   7 +
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   5 +-
 drivers/net/wireless/marvell/libertas/cfg.c        |   9 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   5 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |   4 +-
 drivers/net/wireless/st/cw1200/sta.c               |   2 +-
 drivers/pci/msi/msi.c                              |   3 +
 drivers/pcmcia/omap_cf.c                           |   2 +
 drivers/pcmcia/rsrc_iodyn.c                        |   3 +
 drivers/pcmcia/rsrc_nonstatic.c                    |   4 +-
 drivers/scsi/lpfc/lpfc_nvmet.c                     |  10 +-
 drivers/spi/spi-fsl-lpspi.c                        |  15 +-
 drivers/spi/spi-tegra114.c                         |  18 +-
 drivers/tee/optee/ffa_abi.c                        |   4 +-
 drivers/tee/tee_shm.c                              |   6 +-
 fs/btrfs/btrfs_inode.h                             |   2 +-
 fs/btrfs/extent_io.c                               |   2 +-
 fs/btrfs/inode.c                                   |   1 +
 fs/btrfs/tree-log.c                                |  78 ++++---
 fs/fs-writeback.c                                  |   9 +-
 fs/notify/fdinfo.c                                 |   4 +-
 fs/ocfs2/inode.c                                   |   3 +
 fs/overlayfs/copy_up.c                             |   5 +-
 fs/proc/generic.c                                  |  38 ++--
 fs/smb/client/cifs_unicode.c                       |   3 +
 include/linux/bpf-cgroup.h                         |   5 -
 include/linux/bpf.h                                |  60 ++++--
 include/linux/pci.h                                |   2 +
 include/linux/pgtable.h                            |  16 ++
 include/linux/vmalloc.h                            |  16 --
 kernel/bpf/core.c                                  |  50 +++--
 kernel/bpf/syscall.c                               |  19 +-
 kernel/sched/cpufreq_schedutil.c                   |  28 ++-
 mm/slub.c                                          | 216 ++++++++++---------
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
 net/smc/smc_clc.c                                  |   2 -
 net/smc/smc_ib.c                                   |   3 +
 net/wireless/scan.c                                |   3 +-
 net/wireless/sme.c                                 |   5 +-
 sound/pci/hda/patch_hdmi.c                         |   1 +
 sound/pci/hda/patch_realtek.c                      |   5 +
 sound/usb/mixer_quirks.c                           |   2 +
 tools/gpio/Makefile                                |   4 +-
 tools/testing/selftests/net/bind_bhash.c           |   4 +-
 86 files changed, 774 insertions(+), 560 deletions(-)


