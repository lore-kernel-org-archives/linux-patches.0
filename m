Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC9617BB21;
	Sun,  7 Sep 2025 20:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276943; cv=none; b=qaWtxwnyBh9ViOjfHls4fo6pEsD3fWOeJT4ioetEjFXDG66Gq/DdrCiC2cRDQCApbIdc1MqkXiPPa38q3w0lsDJWN7EzG5riNDeViM88XXLncTH5qhABceFQhGRRj0mmEFzsc7yHwamBMCeVWTOkHNe9GJ/9p0HaympsdKMPSEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276943; c=relaxed/simple;
	bh=6dSoixTgdy7/JN84H/GsYQ6DVYt6tiPi1fJhQUKCt24=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cRrg2CQCxeWVMls3KOgGPVps6G9+t+6yd8fHFu2gab1+DsAPmPNGmVEapc9zd44SenjMa0k+8BjMEqMNZfdosxU16ga2rs8cL9o9di9XuJDaTUUU9OBO2zgJ/0NxgL0WF50h4NTFPbCuFEvXDfxQJYmx02aanMYRGAfVzYiA/YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KRSoawcO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KRSoawcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C378CC4CEF0;
	Sun,  7 Sep 2025 20:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276943;
	bh=6dSoixTgdy7/JN84H/GsYQ6DVYt6tiPi1fJhQUKCt24=;
	h=From:To:Cc:Subject:Date:From;
	b=KRSoawcOW916q5kgkYBp02Z0kDuP+nQV2jhhhOB+ZszdgOEfgjJy91mYIUKrpVtvF
	 zUZ/hA3ouLDEQs03ClLcCp3V0BevNvwY0dYAK9JGBF6/EeKG9Kpm20Q3opxv8AKECO
	 eobxorQyMlpskEhudIxcbqXeFJOypRpgM0nFhEFQ=
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
Subject: [PATCH 6.12 000/175] 6.12.46-rc1 review
Date: Sun,  7 Sep 2025 21:56:35 +0200
Message-ID: <20250907195614.892725141@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.46-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.46-rc1
X-KernelTest-Deadline: 2025-09-09T19:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.46 release.
There are 175 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.46-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.46-rc1

Qiu-ji Chen <chenqiuji666@gmail.com>
    dmaengine: mediatek: Fix a flag reuse error in mtk_cqdma_tx_status()

Yu Kuai <yukuai3@huawei.com>
    md/raid1: fix data lost for writemostly rdev

Radim Krčmář <rkrcmar@ventanamicro.com>
    riscv, bpf: use lw when reading int cpu in bpf_get_smp_processor_id

Radim Krčmář <rkrcmar@ventanamicro.com>
    riscv, bpf: use lw when reading int cpu in BPF_MOV64_PERCPU_REG

Radim Krčmář <rkrcmar@ventanamicro.com>
    riscv: use lw when reading int cpu in asm_per_cpu

Radim Krčmář <rkrcmar@ventanamicro.com>
    riscv: use lw when reading int cpu in new_vmalloc_check

Nathan Chancellor <nathan@kernel.org>
    riscv: Only allow LTO with CMODEL_MEDANY

Anup Patel <apatel@ventanamicro.com>
    ACPI: RISC-V: Fix FFH_CPPC_CSR error handling

Li Nan <linan122@huawei.com>
    md: prevent incorrect update of resync/recovery offset

zhang jiao <zhangjiao2@cmss.chinamobile.com>
    tools: gpio: remove the include directory on make clean

Colin Ian King <colin.i.king@gmail.com>
    drm/amd/amdgpu: Fix missing error return on kzalloc failure

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

Ming Lei <ming.lei@redhat.com>
    scsi: sr: Reinstate rotational media flag

Christoph Hellwig <hch@lst.de>
    block: add a queue_limits_commit_update_frozen helper

Vadim Pasternak <vadimp@nvidia.com>
    hwmon: mlxreg-fan: Prevent fans from getting stuck at 0 RPM

David Arcari <darcari@redhat.com>
    platform/x86/intel: power-domains: Use topology_logical_package_id() for package ID

Antheas Kapenekakis <lkml@antheas.dev>
    platform/x86: asus-wmi: Remove extra keys from ignore_key_wlan quirk

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

Miguel Ojeda <ojeda@kernel.org>
    rust: support Rust >= 1.91.0 target spec

Qiu-ji Chen <chenqiuji666@gmail.com>
    dmaengine: mediatek: Fix a possible deadlock error in mtk_cqdma_tx_status()

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    thermal/drivers/mediatek/lvts: Disable low offset IRQ for minimum threshold

Sumanth Korikkar <sumanthk@linux.ibm.com>
    mm: fix accounting of memmap pages

Yeoreum Yun <yeoreum.yun@arm.com>
    kunit: kasan_test: disable fortify string checker on kasan_strings() test

Dave Airlie <airlied@redhat.com>
    nouveau: fix disabling the nonstall irq due to storm code

Li Qiong <liqiong@nfschina.com>
    mm/slub: avoid accessing metadata when pointer is invalid in object_err()

Vlastimil Babka <vbabka@suse.cz>
    mm, slab: cleanup slab_bug() parameters

Hyesoo Yu <hyesoo.yu@samsung.com>
    mm: slub: call WARN() when detecting a slab corruption

Hyesoo Yu <hyesoo.yu@samsung.com>
    mm: slub: Print the broken data before restoring them

Su Yue <glass.su@suse.com>
    md/md-bitmap: fix wrong bitmap_limit for clustermd when write sb

Wang Liang <wangliang74@huawei.com>
    net: fix NULL pointer dereference in l3mdev_l3_rcv

Wen Gong <quic_wgong@quicinc.com>
    wifi: ath11k: update channel list in worker when wait flag is set

Wen Gong <quic_wgong@quicinc.com>
    wifi: ath11k: update channel list in reg notifier instead reg worker

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: avoid journaling sb update on error if journal is destroying

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: define ext4_journal_destroy wrapper

Zheng Qixing <zhengqixing@huawei.com>
    md/raid1,raid10: strip REQ_NOWAIT from member bios

Yu Kuai <yukuai3@huawei.com>
    md/raid1,raid10: don't handle IO error for REQ_RAHEAD and REQ_NOWAIT

Yu Kuai <yukuai3@huawei.com>
    md/raid1,raid10: don't ignore IO flags

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: do not enable EEE on bcm63xx

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: dsa: b53/bcm_sf2: implement .support_eee() method

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: dsa: provide implementation of .support_eee()

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: dsa: add hook to determine whether EEE is supported

Al Viro <viro@zeniv.linux.org.uk>
    fs/fhandle.c: fix a race in call of has_locked_children()

Stefan Wahren <wahrenst@gmx.net>
    microchip: lan865x: Fix LAN8651 autoloading

Stefan Wahren <wahrenst@gmx.net>
    microchip: lan865x: Fix module autoloading

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

Ivan Lipski <ivan.lipski@amd.com>
    drm/amd/display: Clear the CUR_ENABLE register on DCN314 w/out DPP PG

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: drop hw access in non-DC audio fini

Stefan Wahren <wahrenst@gmx.net>
    net: ethernet: oa_tc6: Handle failure of spi_setup

Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
    wifi: mt76: mt7925: fix the wrong bss cleanup for SAP

Nathan Chancellor <nathan@kernel.org>
    wifi: mt76: mt7996: Initialize hdr before passing to skb_put_data()

Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
    wifi: mt76: mt7925u: use connac3 tx aggr check in tx complete

Qianfeng Rong <rongqianfeng@vivo.com>
    wifi: mwifiex: Initialize the chan_stats array to zero

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    soc: qcom: mdt_loader: Deal with zero e_shentsize

Yin Tirui <yintirui@huawei.com>
    of_numa: fix uninitialized memory nodes causing kernel panic

wangzijie <wangzijie1@honor.com>
    proc: fix missing pde_set_flags() for net proc files

Edward Adam Davis <eadavis@qq.com>
    ocfs2: prevent release journal inode after journal shutdown

Ada Couprie Diaz <ada.coupriediaz@arm.com>
    kasan: fix GCC mem-intrinsic prefix with sw tags

Christian Loehle <christian.loehle@arm.com>
    sched: Fix sched_numa_find_nth_cpu() if mask offline

yangshiguang <yangshiguang@xiaomi.com>
    mm: slub: avoid wake up kswapd in set_track_prepare

Gu Bowen <gubowen5@huawei.com>
    mm: fix possible deadlock in kmemleak

Harry Yoo <harry.yoo@oracle.com>
    mm: move page table sync declarations to linux/pgtable.h

Sasha Levin <sashal@kernel.org>
    mm/userfaultfd: fix kmap_local LIFO ordering for CONFIG_HIGHPTE

Harry Yoo <harry.yoo@oracle.com>
    x86/mm/64: define ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings()

Jens Axboe <axboe@kernel.dk>
    io_uring/msg_ring: ensure io_kiocb freeing is deferred for RCU

Ma Ke <make24@iscas.ac.cn>
    pcmcia: Fix a NULL pointer dereference in __iodyn_find_io_region()

panfan <panfan@qti.qualcomm.com>
    arm64: ftrace: fix unreachable PLT for ftrace_caller in init_module with CONFIG_DYNAMIC_FTRACE

Miaoqian Lin <linmq006@gmail.com>
    ACPI/IORT: Fix memory leak in iort_rmr_alloc_sids()

Karol Wachowski <karol.wachowski@intel.com>
    accel/ivpu: Prevent recovery work from being queued during device removal

Cryolitia PukNgae <cryolitia@uniontech.com>
    ALSA: usb-audio: Add mute TLV for playback volumes on some devices

Horatiu Vultur <horatiu.vultur@microchip.com>
    phy: mscc: Stop taking ts_lock for tx_queue and use its own lock

Kuniyuki Iwashima <kuniyu@google.com>
    selftest: net: Fix weird setsockopt() in bind_bhash.c.

Qingfang Deng <dqfext@gmail.com>
    ppp: fix memory leak in pad_compress_skb

Abin Joseph <abin.joseph@amd.com>
    net: xilinx: axienet: Add error handling for RX metadata pointer retrieval

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

Ido Schimmel <idosch@nvidia.com>
    vxlan: Fix NPD in {arp,neigh}_reduce() when using nexthop objects

Ido Schimmel <idosch@nvidia.com>
    vxlan: Rename FDB Tx lookup function

Ido Schimmel <idosch@nvidia.com>
    vxlan: Add RCU read-side critical sections in the Tx path

Ido Schimmel <idosch@nvidia.com>
    vxlan: Avoid unnecessary updates to FDB 'used' time

Ido Schimmel <idosch@nvidia.com>
    vxlan: Refresh FDB 'updated' time upon 'NTF_USE'

Radu Rendec <rrendec@redhat.com>
    net: vxlan: rename SKB_DROP_REASON_VXLAN_NO_REMOTE

Menglong Dong <menglong8.dong@gmail.com>
    net: vxlan: use kfree_skb_reason() in vxlan_mdb_xmit()

Menglong Dong <menglong8.dong@gmail.com>
    net: vxlan: use kfree_skb_reason() in vxlan_xmit()

Menglong Dong <menglong8.dong@gmail.com>
    net: vxlan: make vxlan_set_mac() return drop reasons

Ido Schimmel <idosch@nvidia.com>
    vxlan: Fix NPD when refreshing an FDB entry with a nexthop object

Menglong Dong <menglong8.dong@gmail.com>
    net: vxlan: make vxlan_snoop() return drop reasons

Menglong Dong <menglong8.dong@gmail.com>
    net: vxlan: add skb drop reasons to vxlan_rcv()

Menglong Dong <menglong8.dong@gmail.com>
    net: tunnel: add pskb_inet_may_pull_reason() helper

Menglong Dong <menglong8.dong@gmail.com>
    net: skb: add pskb_network_may_pull_reason() helper

Felix Fietkau <nbd@nbd.name>
    net: ethernet: mtk_eth_soc: fix tx vlan tag for llc packets

Christoph Paasch <cpaasch@openai.com>
    net/tcp: Fix socket memory leak in TCP-AO failure handling for IPv6

Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
    wifi: ath11k: fix group data packet drops during rekey

Alok Tiwari <alok.a.tiwari@oracle.com>
    ixgbe: fix incorrect map used in eee linkmode

Zhen Ni <zhen.ni@easystack.cn>
    i40e: Fix potential invalid access when MAC list is empty

Jacob Keller <jacob.e.keller@intel.com>
    i40e: remove read access to debugfs files

Emil Tantilov <emil.s.tantilov@intel.com>
    idpf: set mac type when adding and removing MAC filters

Jacob Keller <jacob.e.keller@intel.com>
    ice: fix NULL access of tx->in_use in ice_ll_ts_intr

Jeremy Kerr <jk@codeconstruct.com.au>
    net: mctp: mctp_fraq_queue should take ownership of passed skb

Liu Jian <liujian56@huawei.com>
    net/smc: fix one NULL pointer dereference in smc_ib_is_sg_need_sync()

Sabrina Dubroca <sd@queasysnail.net>
    macsec: read MACSEC_SA_ATTR_PN with nla_get_uint

Sean Anderson <sean.anderson@linux.dev>
    net: macb: Fix tx_ptr_lock locking

Fabian Bläse <fabian@blaese.de>
    icmp: fix icmp_ndo_send address translation for reply direction

Alok Tiwari <alok.a.tiwari@oracle.com>
    bnxt_en: fix incorrect page count in RX aggr ring log

Jakub Kicinski <kuba@kernel.org>
    selftests: drv-net: csum: fix interface name for remote host

Miaoqian Lin <linmq006@gmail.com>
    mISDN: Fix memory leak in dsp_hwec_enable()

Alok Tiwari <alok.a.tiwari@oracle.com>
    xirc2ps_cs: fix register access when enabling FullDuplex

Eric Dumazet <edumazet@google.com>
    net_sched: gen_estimator: fix est_timer() vs CONFIG_PREEMPT_RT=y

Florian Westphal <fw@strlen.de>
    netfilter: nft_flowtable.sh: re-run with random mtu sizes

Kuniyuki Iwashima <kuniyu@google.com>
    Bluetooth: Fix use-after-free in l2cap_sock_cleanup_listen()

Ivan Pravdin <ipravdin.official@gmail.com>
    Bluetooth: vhci: Prevent use-after-free by removing debugfs files early

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: uefi: check DSM item validity

Phil Sutter <phil@nwl.cc>
    netfilter: conntrack: helper: Replace -EEXIST by -EBUSY

Wang Liang <wangliang74@huawei.com>
    netfilter: br_netfilter: do not check confirmed bit in br_nf_local_in() after confirm

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: fix linked list corruption

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: free pending offchannel tx frames on wcid cleanup

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: prevent non-offchannel mgmt tx during scan/roc

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    wifi: mt76: mt7925: fix locking in mt7925_change_vif_links()

Duoming Zhou <duoming@zju.edu.cn>
    wifi: brcmfmac: fix use-after-free when rescheduling brcmf_btcoex_info work

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: cfg80211: fix use-after-free in cmp_bss()

Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
    mmc: sdhci-of-arasan: Ensure CD logic stabilization before power-up

Paul Alvin <alvin.paulp@amd.com>
    mmc: sdhci-of-arasan: Support for emmc hardware reset

Wentao Guan <guanwentao@uniontech.com>
    LoongArch: vDSO: Remove -nostdlib complier flag

Xi Ruoyao <xry111@xry111.site>
    LoongArch: vDSO: Remove --hash-style=sysv

Fabio Porcedda <fabio.porcedda@gmail.com>
    net: usb: qmi_wwan: add Telit Cinterion FN990A w/audio composition

Fabio Porcedda <fabio.porcedda@gmail.com>
    net: usb: qmi_wwan: fix Telit Cinterion FE990A name

Fabio Porcedda <fabio.porcedda@gmail.com>
    net: usb: qmi_wwan: fix Telit Cinterion FN990A name

Alan Stern <stern@rowland.harvard.edu>
    HID: core: Harden s32ton() against conversion to 0 bits

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: stop exporting hid_snto32()

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: simplify snto32()

Marek Vasut <marek.vasut@mailbox.org>
    arm64: dts: imx8mp: Fix missing microSD slot vqmmc on Data Modul i.MX8M Plus eDM SBC

Marek Vasut <marek.vasut@mailbox.org>
    arm64: dts: imx8mp: Fix missing microSD slot vqmmc on DH electronics i.MX8M Plus DHCOM

Markus Niebel <Markus.Niebel@ew.tq-group.com>
    arm64: dts: imx8mp-tqma8mpql: fix LDO5 power off

Sungbae Yoo <sungbaey@nvidia.com>
    tee: optee: ffa: fix a typo of "optee_ffa_api_is_compatible"

Peter Robinson <pbrobinson@gmail.com>
    arm64: dts: rockchip: Add vcc-supply to SPI flash on rk3399-pinebook-pro

Pei Xiao <xiaopei01@kylinos.cn>
    tee: fix memory leak in tee_dyn_shm_alloc_helper

Pei Xiao <xiaopei01@kylinos.cn>
    tee: fix NULL pointer dereference in tee_shm_put

Jiufei Xue <jiufei.xue@samsung.com>
    fs: writeback: fix use-after-free in __mark_inode_dirty()

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: skip ZONE FINISH of conventional zones

Piotr Zalewski <pZ010001011111@proton.me>
    drm/rockchip: vop2: make vp registers nonvolatile

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
    bpf: Move cgroup iterator helpers to bpf.h

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Move bpf map owner out of common struct

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Add cookie object to bpf maps


-------------

Diffstat:

 Makefile                                           |   4 +-
 .../dts/freescale/imx8mp-data-modul-edm-sbc.dts    |   1 +
 .../arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi |   1 +
 .../freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts   |  13 +-
 .../dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts    |  13 +-
 .../arm64/boot/dts/freescale/imx8mp-tqma8mpql.dtsi |  22 ++++
 .../boot/dts/rockchip/rk3399-pinebook-pro.dts      |   1 +
 arch/arm64/include/asm/module.h                    |   1 +
 arch/arm64/include/asm/module.lds.h                |   1 +
 arch/arm64/kernel/ftrace.c                         |  13 +-
 arch/arm64/kernel/module-plts.c                    |  12 +-
 arch/arm64/kernel/module.c                         |  11 ++
 arch/loongarch/kernel/signal.c                     |  10 +-
 arch/loongarch/vdso/Makefile                       |   3 +-
 arch/riscv/Kconfig                                 |   2 +-
 arch/riscv/include/asm/asm.h                       |   2 +-
 arch/riscv/kernel/entry.S                          |   2 +-
 arch/riscv/net/bpf_jit_comp64.c                    |   4 +-
 arch/x86/include/asm/pgtable_64_types.h            |   3 +
 arch/x86/mm/init_64.c                              |  18 +++
 block/blk-integrity.c                              |   4 +-
 block/blk-settings.c                               |  24 ++++
 block/blk-zoned.c                                  |   7 +-
 drivers/accel/ivpu/ivpu_drv.c                      |   2 +-
 drivers/accel/ivpu/ivpu_pm.c                       |   4 +-
 drivers/accel/ivpu/ivpu_pm.h                       |   2 +-
 drivers/acpi/arm64/iort.c                          |   4 +-
 drivers/acpi/riscv/cppc.c                          |   4 +-
 drivers/block/virtio_blk.c                         |   4 +-
 drivers/bluetooth/hci_vhci.c                       |  57 ++++++---
 drivers/dma/mediatek/mtk-cqdma.c                   |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/dce_v10_0.c             |   5 -
 drivers/gpu/drm/amd/amdgpu/dce_v11_0.c             |   5 -
 drivers/gpu/drm/amd/amdgpu/dce_v6_0.c              |   5 -
 drivers/gpu/drm/amd/amdgpu/dce_v8_0.c              |   5 -
 .../gpu/drm/amd/display/dc/dce/dce_link_encoder.c  |   8 +-
 .../gpu/drm/amd/display/dc/dpp/dcn10/dcn10_dpp.c   |   9 ++
 .../gpu/drm/amd/display/dc/dpp/dcn10/dcn10_dpp.h   |   2 +
 .../gpu/drm/amd/display/dc/dpp/dcn30/dcn30_dpp.c   |   1 +
 .../drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c  |  72 +++++++++++
 .../drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.h  |   2 +
 .../drm/amd/display/dc/hwss/dcn314/dcn314_init.c   |   1 +
 drivers/gpu/drm/amd/display/dc/inc/hw/dpp.h        |   3 +
 drivers/gpu/drm/bridge/ti-sn65dsi86.c              |  11 ++
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/base.c    |   2 +
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/ga100.c   |  23 ++--
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/ga102.c   |   1 +
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/priv.h    |   2 +
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/r535.c    |   1 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |   9 +-
 drivers/hid/hid-core.c                             |  74 +++++------
 drivers/hid/hid-logitech-hidpp.c                   |   6 +-
 drivers/hwmon/mlxreg-fan.c                         |   5 +-
 drivers/isdn/mISDN/dsp_hwec.c                      |   6 +-
 drivers/md/md-bitmap.c                             |   6 +-
 drivers/md/md.c                                    |   5 +
 drivers/md/raid1-10.c                              |  10 ++
 drivers/md/raid1.c                                 |  28 ++--
 drivers/md/raid10.c                                |  20 ++-
 drivers/mmc/host/sdhci-of-arasan.c                 |  51 +++++++-
 drivers/net/dsa/b53/b53_common.c                   |  16 ++-
 drivers/net/dsa/b53/b53_priv.h                     |   1 +
 drivers/net/dsa/bcm_sf2.c                          |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   2 +-
 drivers/net/ethernet/cadence/macb_main.c           |  28 ++--
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |  20 +--
 drivers/net/ethernet/intel/e1000e/ethtool.c        |  10 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c      |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c     | 123 +++---------------
 drivers/net/ethernet/intel/ice/ice_main.c          |  12 +-
 drivers/net/ethernet/intel/idpf/idpf_lib.c         |   9 +-
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c    |  12 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |   4 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  10 +-
 drivers/net/ethernet/microchip/lan865x/lan865x.c   |   7 +-
 drivers/net/ethernet/oa_tc6.c                      |   3 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  10 ++
 drivers/net/ethernet/xircom/xirc2ps_cs.c           |   2 +-
 drivers/net/ipvlan/ipvlan_l3s.c                    |   1 -
 drivers/net/macsec.c                               |   8 +-
 drivers/net/pcs/pcs-rzn1-miic.c                    |   2 +-
 drivers/net/phy/mscc/mscc_ptp.c                    |  18 ++-
 drivers/net/ppp/ppp_generic.c                      |   6 +-
 drivers/net/usb/cdc_ncm.c                          |   7 +
 drivers/net/usb/qmi_wwan.c                         |   5 +-
 drivers/net/vxlan/vxlan_core.c                     | 122 +++++++++++-------
 drivers/net/vxlan/vxlan_mdb.c                      |   2 +-
 drivers/net/vxlan/vxlan_private.h                  |   4 +-
 drivers/net/wireless/ath/ath11k/core.c             |   1 +
 drivers/net/wireless/ath/ath11k/core.h             |   7 +-
 drivers/net/wireless/ath/ath11k/mac.c              | 125 ++++++++++++++++--
 drivers/net/wireless/ath/ath11k/reg.c              | 107 +++++++++++-----
 drivers/net/wireless/ath/ath11k/reg.h              |   3 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/btcoex.c  |   6 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c       |   6 +
 drivers/net/wireless/marvell/libertas/cfg.c        |   9 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   5 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |   4 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   4 +
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   |   7 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |   4 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |  12 +-
 drivers/net/wireless/st/cw1200/sta.c               |   2 +-
 drivers/of/of_numa.c                               |   5 +-
 drivers/pcmcia/omap_cf.c                           |   2 +
 drivers/pcmcia/rsrc_iodyn.c                        |   3 +
 drivers/pcmcia/rsrc_nonstatic.c                    |   4 +-
 drivers/platform/x86/amd/pmc/pmc-quirks.c          |  14 ++
 drivers/platform/x86/asus-nb-wmi.c                 |   2 -
 drivers/platform/x86/intel/tpmi_power_domains.c    |   2 +-
 drivers/scsi/lpfc/lpfc_nvmet.c                     |  10 +-
 drivers/scsi/sd.c                                  |  17 +--
 drivers/scsi/sr.c                                  |  19 +--
 drivers/soc/qcom/mdt_loader.c                      |  12 +-
 drivers/spi/spi-fsl-lpspi.c                        |  24 ++--
 drivers/tee/optee/ffa_abi.c                        |   4 +-
 drivers/tee/tee_shm.c                              |  14 +-
 drivers/thermal/mediatek/lvts_thermal.c            |  50 ++++++--
 fs/btrfs/btrfs_inode.h                             |   2 +-
 fs/btrfs/inode.c                                   |   1 +
 fs/btrfs/tree-log.c                                |  78 +++++++----
 fs/btrfs/zoned.c                                   |  55 +++++---
 fs/ext4/ext4.h                                     |   3 +-
 fs/ext4/ext4_jbd2.h                                |  29 +++++
 fs/ext4/super.c                                    |  32 ++---
 fs/fs-writeback.c                                  |   9 +-
 fs/namespace.c                                     |  18 ++-
 fs/ocfs2/inode.c                                   |   3 +
 fs/proc/generic.c                                  |  38 +++---
 fs/smb/client/cifs_unicode.c                       |   3 +
 include/linux/blkdev.h                             |   2 +
 include/linux/bpf-cgroup.h                         |   5 -
 include/linux/bpf.h                                |  60 ++++++---
 include/linux/hid.h                                |   1 -
 include/linux/io_uring_types.h                     |  12 +-
 include/linux/pgtable.h                            |  16 +++
 include/linux/skbuff.h                             |   8 +-
 include/linux/vmalloc.h                            |  16 ---
 include/net/dropreason-core.h                      |  40 ++++++
 include/net/dsa.h                                  |   2 +
 include/net/ip_tunnels.h                           |  10 +-
 io_uring/msg_ring.c                                |   4 +-
 kernel/bpf/core.c                                  |  50 +++++---
 kernel/bpf/syscall.c                               |  19 ++-
 kernel/sched/topology.c                            |   2 +
 mm/kasan/kasan_test_c.c                            |   1 +
 mm/kmemleak.c                                      |  27 +++-
 mm/slub.c                                          | 142 +++++++++++++--------
 mm/sparse-vmemmap.c                                |   5 -
 mm/sparse.c                                        |  15 ++-
 mm/userfaultfd.c                                   |   9 +-
 net/atm/resources.c                                |   6 +-
 net/ax25/ax25_in.c                                 |   4 +
 net/batman-adv/network-coding.c                    |   7 +-
 net/bluetooth/hci_sync.c                           |   2 +-
 net/bluetooth/l2cap_sock.c                         |   3 +
 net/bridge/br_netfilter_hooks.c                    |   3 -
 net/core/gen_estimator.c                           |   2 +
 net/dsa/port.c                                     |  16 +++
 net/dsa/user.c                                     |   8 ++
 net/ipv4/devinet.c                                 |   7 +-
 net/ipv4/icmp.c                                    |   6 +-
 net/ipv6/ip6_icmp.c                                |   6 +-
 net/ipv6/tcp_ipv6.c                                |  32 +++--
 net/mctp/af_mctp.c                                 |   2 +-
 net/mctp/route.c                                   |  35 ++---
 net/netfilter/nf_conntrack_helper.c                |   4 +-
 net/smc/smc_clc.c                                  |   2 -
 net/smc/smc_ib.c                                   |   3 +
 net/wireless/scan.c                                |   3 +-
 net/wireless/sme.c                                 |   5 +-
 scripts/Makefile.kasan                             |  12 +-
 scripts/generate_rust_target.rs                    |  12 +-
 sound/pci/hda/patch_hdmi.c                         |   1 +
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/usb/mixer_quirks.c                           |   2 +
 tools/gpio/Makefile                                |   2 +-
 tools/perf/util/bpf-event.c                        |  39 ++++--
 tools/perf/util/bpf-utils.c                        |  61 +++++----
 tools/power/cpupower/utils/cpupower-set.c          |   4 +-
 tools/testing/selftests/drivers/net/hw/csum.py     |   4 +-
 tools/testing/selftests/net/bind_bhash.c           |   4 +-
 .../selftests/net/netfilter/nft_flowtable.sh       | 113 ++++++++++------
 187 files changed, 1784 insertions(+), 926 deletions(-)


