Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30433AD536;
	Mon, 23 Mar 2026 14:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275107; cv=none; b=KfKf1CLP72BV79OdDyPl6WaKMxg9SRfEBYzz5soOWOhecWbl9QsUGhJT9Ab28ZBakWnJi/Xs4GySepzDxbPK/5nGLOyazjD8ToPPHOnBUeRd7xd4xxnnkpxgQCZvWIO8u90f+OaV9VtIYbkXuXXmWNkqJKhD/4nWRBwGcTvglIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275107; c=relaxed/simple;
	bh=PZuTzhkOsp5NwKO5LYmfBx4CyWl+dgAP1SgZcBAXrWY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gx9TdCJaEbgdCgo6Mf9VTG9u+8GrM4zXpZKuBxi1ISvT/iK5AXfIVY/tapm5OWSGV+BC+1FXtnDS5SvCu5VP68QPekQdemR0ZJOEUFZiFDky7Woy3HHAHRQ2cMpB3KOlJb1fEr2J1zXfexzncv5NY0NR59X2uqgBdNT5+EmfqU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E5aWNuiu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E5aWNuiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38D5C4CEF7;
	Mon, 23 Mar 2026 14:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275107;
	bh=PZuTzhkOsp5NwKO5LYmfBx4CyWl+dgAP1SgZcBAXrWY=;
	h=From:To:Cc:Subject:Date:From;
	b=E5aWNuiuiIAoKuxXaogHKY3StMa5cy5uNGG325Qh7wYyDmTsAWCtjb8jloPlyBK1u
	 t2ntgbGaOlsS7Fkl1Cn+LgzmWAOymWwMRZ19EGxKYMTGcEDHlGoQuBNyAeGCNr7Sqh
	 Enl+Mhu0zxlJ0Y22V33qo+g3o/0I9/YHIuDDB6M8=
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
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.12 000/460] 6.12.78-rc1 review
Date: Mon, 23 Mar 2026 14:39:56 +0100
Message-ID: <20260323134526.647552166@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.78-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.78-rc1
X-KernelTest-Deadline: 2026-03-25T13:45+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.78 release.
There are 460 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.78-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.78-rc1

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Add missing branch counters constraint apply

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max6639) Fix pulses-per-revolution implementation

Josh Law <objecting@objecting.org>
    tools/bootconfig: fix fd leak in load_xbc_file() on fstat failure

Josh Law <objecting@objecting.org>
    lib/bootconfig: check xbc_init_node() return in override path

Kees Cook <kees@kernel.org>
    fs/tests: exec: Remove bad test vector

Rahul Bukte <rahul.bukte@sony.com>
    drm/i915/gt: Check set_default_submission() before deferencing

Hyunwoo Kim <imv4bel@gmail.com>
    ksmbd: fix use-after-free in durable v2 replay of active file handles

Hyunwoo Kim <imv4bel@gmail.com>
    ksmbd: fix use-after-free of share_conf in compound request

Andy Nguyen <theofficialflow1996@gmail.com>
    drm/amd: fix dcn 2.01 check

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix DisplayID not-found handling in parse_edid_displayid_vrr()

Kamal Dasu <kamal.dasu@broadcom.com>
    mtd: rawnand: brcmnand: skip DMA during panic write

Kamal Dasu <kamal.dasu@broadcom.com>
    mtd: rawnand: serialize lock/unlock against other NAND operations

Kairui Song <kasong@tencent.com>
    mm/shmem, swap: avoid redundant Xarray lookup during swapin

Kairui Song <kasong@tencent.com>
    mm/shmem, swap: improve cached mTHP handling and fix potential hang

Kemeng Shi <shikemeng@huaweicloud.com>
    mm: shmem: avoid unpaired folio_unlock() in shmem_swapin_folio()

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm: shmem: fix potential data corruption during shmem swapin

Pratyush Yadav <p.yadav@ti.com>
    mtd: spi-nor: core: avoid odd length/address writes in 8D-8D-8D mode

Pratyush Yadav <p.yadav@ti.com>
    mtd: spi-nor: core: avoid odd length/address reads on 8D-8D-8D mode

Kyle Meyer <kyle.meyer@hpe.com>
    x86/platform/uv: Handle deconfigured sockets

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    ring-buffer: Fix to update per-subbuf entries of persistent ring buffer

Gabor Juhos <j4g8y7@gmail.com>
    i2c: pxa: defer reset on Armada 3700 when recovery is used

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: fsi: Fix a potential leak in fsi_i2c_probe()

Johan Hovold <johan@kernel.org>
    i2c: cp2615: fix serial string NULL-deref at probe

Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
    USB: serial: f81232: fix incomplete serial port generation

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Compute PSR entry_setup_frames into intel_crtc_state

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pmbus/isl68137) Fix unchecked return value and use sysfs_emit()

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pmbus/mp2975) Add error check for pmbus_read_word_data() return value

Weiming Shi <bestswngs@gmail.com>
    icmp: fix NULL pointer dereference in icmp_tag_validation()

Anas Iqbal <mohd.abd.6602@gmail.com>
    net: dsa: bcm_sf2: fix missing clk_disable_unprepare() in error paths

Muhammad Hammad Ijaz <mhijaz@amazon.com>
    net: mvpp2: guard flow control update with global_tx_fc in buffer switching

Weiming Shi <bestswngs@gmail.com>
    nfnetlink_osf: validate individual option lengths in fingerprints

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: release flowtable after rcu grace period on error

Florian Westphal <fw@strlen.de>
    netfilter: bpf: defer hook memory release until rcu readers are done

Xiang Mei <xmei5@asu.edu>
    net: bonding: fix NULL deref in bond_debug_rlb_hash_show

Xiang Mei <xmei5@asu.edu>
    udp_tunnel: fix NULL deref caused by udp_sock_create6 when CONFIG_IPV6=n

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Fix race condition during IPSec ESN update

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Prevent concurrent access to IPSec ASO context

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5: qos: Restrict RTNL area to avoid a lock cycle

Fedor Pchelkin <pchelkin@ispras.ru>
    net: macb: fix uninitialized rx_fs_lock

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: processor: Fix previous acpi_processor_errata_piix4() fix

Guenter Roeck <linux@roeck-us.net>
    wifi: wlcore: Return -ENOMEM instead of -EAGAIN if there is not enough headroom

Xiang Mei <xmei5@asu.edu>
    wifi: mac80211: fix NULL deref in mesh_matches_local()

Petr Oros <poros@redhat.com>
    iavf: fix VLAN filter lost on add/delete race

Zdenek Bouska <zdenek.bouska@siemens.com>
    igc: fix page fault in XDP TX timestamps handling

Kohei Enju <kohei@enjuk.jp>
    igc: fix missing update of skb->tail in igc_xmit_frame()

Nikola Z. Ivanov <zlatistiv@gmail.com>
    net: usb: aqc111: Do not perform PM inside suspend callback

Daniel Borkmann <daniel@iogearbox.net>
    clsact: Fix use-after-free in init/destroy rollback asymmetry

Tobi Gaertner <tob.gaertner@me.com>
    net: usb: cdc_ncm: add ndpoffset to NDP32 nframes bounds check

Tobi Gaertner <tob.gaertner@me.com>
    net: usb: cdc_ncm: add ndpoffset to NDP16 nframes bounds check

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Remove airoha_dev_stop() in airoha_remove()

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Read completion queue data in airoha_qdma_tx_napi_poll()

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: fix PSE memory configuration in airoha_fe_pse_ports_init()

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: read default PSE reserved pages value before updating

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: teql: Fix double-free in teql_master_xmit

Jiayuan Chen <jiayuan.chen@shopee.com>
    net/smc: fix NULL dereference and UAF in smc_tcp_syn_recv_sock()

Eric Dumazet <edumazet@google.com>
    bonding: prevent potential infinite loop in bond_header_parse()

Bart Van Assche <bvanassche@acm.org>
    PM: runtime: Fix a race condition related to device removal

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    sched: idle: Consolidate the handling of two special cases

Dipayaan Roy <dipayanroy@linux.microsoft.com>
    net: mana: fix use-after-free in mana_hwc_destroy_channel() by reordering teardown

Justin Chen <justin.chen@broadcom.com>
    net: bcmgenet: increase WoL poll timeout

Jenny Guanni Qu <qguanni@gmail.com>
    netfilter: nf_conntrack_h323: check for zero length in DecodeQ931()

Jenny Guanni Qu <qguanni@gmail.com>
    netfilter: xt_time: use unsigned int for monthday bit shift

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: xt_CT: drop pending enqueued packets on template removal

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_ct: drop pending enqueued packets on removal

Pablo Neira Ayuso <pablo@netfilter.org>
    nf_tables: nft_dynset: fix possible stateful expression memleak in error path

Jenny Guanni Qu <qguanni@gmail.com>
    netfilter: nf_conntrack_h323: fix OOB read in decode_int() CONS case

Lukas Johannes Möller <research@johannes-moeller.dev>
    netfilter: nf_conntrack_sip: fix Content-Length u32 truncation in sip_help_tcp()

Hyunwoo Kim <imv4bel@gmail.com>
    netfilter: ctnetlink: fix use-after-free in ctnetlink_dump_exp_ct()

Florian Westphal <fw@strlen.de>
    netfilter: ctnetlink: remove refcounting in expectation dumpers

Sabrina Dubroca <sd@queasysnail.net>
    mpls: add missing unregister_netdevice_notifier to mpls_init

Jiayuan Chen <jiayuan.chen@shopee.com>
    net/rose: fix NULL pointer dereference in rose_transmit_link on reconnect

Hyunwoo Kim <imv4bel@gmail.com>
    bridge: cfm: Fix race condition in peer_mep deletion

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    Bluetooth: qca: fix ROM version reading on WCN3998 chips

Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
    Bluetooth: L2CAP: Fix use-after-free in l2cap_unregister_user

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: HIDP: Fix possible UAF

Wang Tao <wangtao554@huawei.com>
    Bluetooth: MGMT: Fix list corruption and UAF in command complete handlers

Michael Grzeschik <m.grzeschik@pengutronix.de>
    Bluetooth: hci_sync: Fix hci_le_create_conn_sync

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Fix defer tests being unstable

Christian Eggers <ceggers@arri.de>
    Bluetooth: SMP: make SM/PER/KDU/BI-04-C happy

Christian Eggers <ceggers@arri.de>
    Bluetooth: LE L2CAP: Disconnect if sum of payload sizes exceed SDU

Christian Eggers <ceggers@arri.de>
    Bluetooth: LE L2CAP: Disconnect if received packet's SDU exceeds IMTU

Felix Gu <ustc.gu@gmail.com>
    firmware: arm_scpi: Fix device_node reference leak in probe path

Yeoreum Yun <yeoreum.yun@arm.com>
    firmware: arm_ffa: Remove vm_id argument in ffa_rxtx_unmap()

Fabrizio Castro <fabrizio.castro.jz@renesas.com>
    arm64: dts: renesas: r9a09g057: Remove wdt{0,2,3} nodes

Ovidiu Panait <ovidiu.panait.rb@renesas.com>
    arm64: dts: renesas: r9a09g057: Add RTC node

Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>
    wifi: cfg80211: cancel pmsr_free_wk in cfg80211_pmsr_wdev_down

Kuniyuki Iwashima <kuniyu@google.com>
    wifi: mac80211: Fix static_branch_dec() underflow for aql_disable.

Chen Ni <nichen@iscas.ac.cn>
    soc: fsl: cpm1: qmc: Fix error check for devm_ioremap_resource() in qmc_qe_init_resources()

Richard Genoud <richard.genoud@bootlin.com>
    soc: fsl: qbman: fix race condition in qman_destroy_fq

Shawn Lin <shawn.lin@rock-chips.com>
    soc: rockchip: grf: Add missing of_node_put() when returning

Felix Gu <ustc.gu@gmail.com>
    cache: ax45mp: Fix device node reference leak in ax45mp_cache_init()

Felix Gu <ustc.gu@gmail.com>
    cache: starfive: fix device node leak in starlink_cache_init()

Zilin Guan <zilin@seu.edu.cn>
    soc: microchip: mpfs: Fix memory leak in mpfs_sys_controller_probe()

ZhengYuan Huang <gality369@gmail.com>
    btrfs: tree-checker: fix misleading root drop_level error message

Filipe Manana <fdmanana@suse.com>
    btrfs: log new dentries when logging parent dir of a conflicting inode

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: report correct sense field pointer in ata_scsiop_maint_in()

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: Return residual for emulated SCSI commands

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix accepting multiple L2CAP_ECRED_CONN_REQ

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Open-code GGTT MMIO access protection

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/oa: Allow reading after disabling OA stream

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: apply state adjust rules to some additional HAINAN vairants

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: apply state adjust rules to some additional HAINAN vairants

Alessio Belle <alessio.belle@imgtec.com>
    drm/imagination: Fix deadlock in soft reset sequence

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/mmhub4.1.0: add bounds checking for cid

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/mmhub3.0: add bounds checking for cid

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/mmhub3.0.2: add bounds checking for cid

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/mmhub3.0.1: add bounds checking for cid

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/mmhub2.3: add bounds checking for cid

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/mmhub2.0: add bounds checking for cid

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gmc9.0: add bounds checking for cid

Xi Ruoyao <xry111@xry111.site>
    drm/amd/display: Wrap dcn32_override_min_req_memclk() in DC_FP_{START, END}

Maarten Lankhorst <dev@lankhorst.se>
    drm: Fix use-after-free on framebuffers and property blobs when calling drm_dev_unplug

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: propagate BUF_MORE through early buffer commit path

Maciej Andrzejewski ICEYE <maciej.andrzejewski@m-works.net>
    serial: uartlite: fix PM runtime usage count underflow on probe

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Add late synchronize_irq() to shutdown to handle DW UART BUSY

Raul E Rangel <rrangel@chromium.org>
    serial: 8250: Fix TX deadlock when using DMA

Martin Roukala (né Peres) <martin.roukala@mupuf.org>
    serial: 8250_pci: add support for the AX99100

Guanghui Feng <guanghuifeng@linux.alibaba.com>
    iommu/vt-d: Fix intel iommu iotlb sync hardlockup and retry

Finn Thain <fthain@linux-m68k.org>
    mtd: Avoid boot crash in RedBoot partition table parser

Chen Ni <nichen@iscas.ac.cn>
    mtd: rawnand: cadence: Fix error check for dma_alloc_coherent() in cadence_nand_init()

Olivier Sobrie <olivier@sobrie.be>
    mtd: rawnand: pl353: make sure optimal timings are applied

Johan Hovold <johan@kernel.org>
    spi: fix statistics allocation

Johan Hovold <johan@kernel.org>
    spi: fix use-after-free on controller registration failure

Maíra Canal <mcanal@igalia.com>
    pmdomain: bcm: bcm2835-power: Increase ASB control timeout

Luke Wang <ziniu.wang_1@nxp.com>
    mmc: sdhci: fix timing selection for 1-bit bus width

Matthew Schwartz <matthew.schwartz@linux.dev>
    mmc: sdhci-pci-gli: fix GL9750 DMA write corruption

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-core: disable LPM on ADATA SU680 SSD

Kevin Hao <haokexin@gmail.com>
    net: macb: Reinitialize tx/rx queue pointer registers and rx ring during resume

Kevin Hao <haokexin@gmail.com>
    net: macb: Introduce gem_init_rx_ring()

Yang Yang <n05ec@lzu.edu.cn>
    batman-adv: avoid OGM aggregation when skb tailroom is insufficient

Filipe Manana <fdmanana@suse.com>
    btrfs: fix transaction abort when snapshotting received subvolumes

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    kprobes: Remove unneeded warnings from __arm_kprobe_ftrace()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    kprobes: Remove unneeded goto

Hari Bathini <hbathini@linux.ibm.com>
    powerpc64/bpf: fix kfunc call support

Naveen N Rao <naveen@kernel.org>
    powerpc64/bpf: Fold bpf_jit_emit_func_call_hlp() into bpf_jit_emit_func_call_rel()

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Enable AUTOSEL_DOM for CCA serialnr sysfs attribute

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Write DSC parameters on Selective Update in ET mode

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/dsc: Add helper for writing DSC Selective Update ET parameters

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/dsc: Add Selective Update register definitions

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use volume UUID in FS_OBJECT_ID_INFORMATION

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: unset conn->binding on failed binding request

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix krb5 mount with username option

Lukas Johannes Möller <research@johannes-moeller.dev>
    Bluetooth: L2CAP: Validate L2CAP_INFO_RSP payload length before access

Lukas Johannes Möller <research@johannes-moeller.dev>
    Bluetooth: L2CAP: Fix type confusion in l2cap_ecred_reconf_rsp()

Felix Fietkau <nbd@nbd.name>
    mac80211: fix crash in ieee80211_chan_bw_change for AP_VLAN stations

Helge Deller <deller@gmx.de>
    parisc: Flush correct cache in cacheflush() syscall

Fedor Pchelkin <pchelkin@ispras.ru>
    net: macb: fix use-after-free access to PTP clock

Ian Ray <ian.ray@gehealthcare.com>
    NFC: nxp-nci: allow GPIOs to sleep

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Give more information if kmem access failed

Ira Weiny <ira.weiny@intel.com>
    nvdimm/bus: Fix potential use after free in asynchronous initialization

Jeff Layton <jlayton@kernel.org>
    sunrpc: fix cache_request leak in cache_release

Benjamin Tissoires <bentiss@kernel.org>
    HID: bpf: prevent buffer overflow in hid_hw_request

Benjamin Tissoires <bentiss@kernel.org>
    selftests/hid: fix compilation when bpf_wq and hid_device are not exported

Jeff Layton <jlayton@kernel.org>
    nfsd: fix heap overflow in NFSv4.0 LOCK replay cache

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Hold net reference for the lifetime of /proc/fs/nfs/exports fd

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Add basic validation for RAS header

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Use pm_display_cfg in legacy DPM (v2)

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Add pixel_clock to amd_pp_display_configuration

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Repeat Selective Update area alignment

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/alpm: ALPM disable fixes

Heiko Carstens <hca@linux.ibm.com>
    s390/xor: Fix xor_xc_2() inline assembly constraints

Heiko Carstens <hca@linux.ibm.com>
    s390/stackleak: Fix __stackleak_poison() inline assembly constraint

Peter Zijlstra <peterz@infradead.org>
    sched/fair: Fix zero_vruntime tracking

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: check if target buffer list is still legacy on recycle

Cheng-Yang Chou <yphbchou0911@gmail.com>
    sched_ext: Remove redundant css_put() in scx_cgroup_init()

Deepanshu Kartikey <kartikey406@gmail.com>
    mm: thp: deny THP for files on anonymous inodes

Gao Xiang <xiang@kernel.org>
    erofs: fix inline data read failure for ztailpacking pclusters

Darrick J. Wong <djwong@kernel.org>
    xfs: get rid of the xchk_xfile_*_descr calls

Zilin Guan <zilin@seu.edu.cn>
    binfmt_misc: restore write access before closing files opened by open_exec()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: properly keep track of conduit reference

Guodong Xu <guodong@riscstar.com>
    dmaengine: mmp_pdma: Fix race condition in mmp_pdma_residue()

Han Guangjiang <hanguangjiang@lixiang.com>
    blk-throttle: fix access race during throttle policy activation

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid migrating empty section

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: compress: fix UAF of f2fs_inode_info in f2fs_free_dic

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: compress: change the first parameter of page_array_{alloc,free} to sbi

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: stmmac: remove support for lpi_intr_o

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: in-kernel: always set ID as avail when rm endp

Antheas Kapenekakis <lkml@antheas.dev>
    platform/x86/amd/pmc: Add support for Van Gogh SoC

Oleg Nesterov <oleg@redhat.com>
    x86/uprobes: Fix XOL allocation failure for 32-bit tasks

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    io_uring/uring_cmd: fix too strict requirement on ioctl

Hariprasad Kelam <hkelam@marvell.com>
    Octeontx2-af: Add proper checks for fwdata

Steven Rostedt <rostedt@goodmis.org>
    tracing: Add recursion protection in kernel stack trace recording

Paul Greenwalt <paul.greenwalt@intel.com>
    ice: fix devlink reload call trace

Qu Wenruo <wqu@suse.com>
    btrfs: do not strictly require dirty metadata threshold for metadata writepages

David Howells <dhowells@redhat.com>
    rxrpc: Fix recvmsg() unconditional requeue

Mikulas Patocka <mpatocka@redhat.com>
    dm-verity: disable recursive forward error correction

Eric Dumazet <edumazet@google.com>
    ipv6: use RCU in ip6_xmit()

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/sync: Cleanup partially initialized sync on parse failure

Long Li <leo.lilong@huawei.com>
    xfs: fix integer overflow in bmap intent sort comparator

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-sha204a - Fix OOM ->tfm_count leak

Shyam Prasad N <sprasad@microsoft.com>
    cifs: open files should not hold ref on superblock

Kevin Hao <haokexin@gmail.com>
    net: macb: Shuffle the tx ring before enabling tx

Luca Ceresoli <luca.ceresoli@bootlin.com>
    drm/bridge: ti-sn65dsi83: halve horizontal syncs for dual LVDS output

Thorsten Blum <thorsten.blum@linux.dev>
    ksmbd: Don't log keys in SMB3 signing and encryption key generation

Jim Mattson <jmattson@google.com>
    KVM: x86: Introduce KVM_X86_QUIRK_VMCS12_ALLOW_FREEZE_IN_SMM

Chao Gao <chao.gao@intel.com>
    KVM: nVMX: Add consistency checks for CR0.WP and CR4.CET

Yan Zhao <yan.y.zhao@intel.com>
    KVM: x86: Introduce Intel specific quirk KVM_X86_QUIRK_IGNORE_GUEST_PAT

Yan Zhao <yan.y.zhao@intel.com>
    KVM: x86: Introduce supported_quirks to block disabling quirks

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: Allow vendor code to disable quirks

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: do not allow re-enabling quirks

Sean Christopherson <seanjc@google.com>
    KVM: x86: Quirk initialization of feature MSRs to KVM's max configuration

Sean Christopherson <seanjc@google.com>
    KVM: x86: Co-locate initialization of feature MSRs in kvm_arch_vcpu_create()

Shengming Hu <hu.shengming@zte.com.cn>
    fgraph: Fix thresh_return clear per-task notrace

Darrick J. Wong <djwong@kernel.org>
    iomap: reject delalloc mappings during writeback

Tejun Heo <tj@kernel.org>
    sched_ext: Fix starvation of scx_enable() under fair-class saturation

Tejun Heo <tj@kernel.org>
    sched_ext: Disable preemption between scx_claim_exit() and kicking helper work

Christian Brauner <brauner@kernel.org>
    nsfs: tighten permission checks for ns iteration ioctls

Alexander Potapenko <glider@google.com>
    mm/kfence: fix KASAN hardware tag faults during late enablement

David Hildenbrand <david@redhat.com>
    mm/page_alloc: forward the gfp flags from alloc_contig_range() to post_alloc_hook()

David Hildenbrand <david@redhat.com>
    mm/page_alloc: sort out the alloc_contig_range() gfp flags mess

Matthew Wilcox (Oracle) <willy@infradead.org>
    mm/page_alloc: move set_page_refcounted() to callers of post_alloc_hook()

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: dw_mmc-rockchip: Fix runtime PM support for internal phase support

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: dw_mmc-rockchip: Add memory clock auto-gating support

Jisheng Zhang <jszhang@kernel.org>
    mmc: dw_mmc-rockchip: use modern PM macros

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Set/clear CR8 write interception when AVIC is (de)activated

Naveen N Rao <naveen@kernel.org>
    KVM: SVM: Add a helper to look up the max physical ID for AVIC

Naveen N Rao <naveen@kernel.org>
    KVM: SVM: Limit AVIC physical max index based on configured max_vcpu_ids

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    usb: gadget: f_tcm: Fix NULL pointer dereferences in nexus handling

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_ncm: Fix net_device lifecycle with device_move

Thomas Gleixner <tglx@linutronix.de>
    cleanup: Provide retain_and_null_ptr()

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_can_open(): always configure bitrates before starting device

Ethan Tidmore <ethantidmore06@gmail.com>
    xfs: Fix error pointer dereference

Paul Moses <p@1g4.org>
    net/sched: act_gate: snapshot parameters with RCU on replace

Nathan Chancellor <nathan@kernel.org>
    kbuild: Leave objtool binary around with 'make clean'

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: check RM_ADDR not sent over same subflow

Gang Yan <yangang@kylinos.cn>
    selftests: mptcp: add a check for 'add_addr_accepted'

Natalie Vock <natalie.vock@gmx.de>
    drm/amd/display: Use GFP_ATOMIC in dc_create_stream_for_sink

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: avoid sending RM_ADDR over same subflow

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: in-kernel: always mark signal+subflow endp as used

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Add per-scheduler IMC CAS count events

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Support more units on Granite Rapids

Daniel Hodges <git@danielhodges.dev>
    wifi: libertas: fix use-after-free in lbs_free_adapter()

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86: hp-bioscfg: Support allocations of larger data

Kim Phillips <kim.phillips@amd.com>
    x86/sev: Allow IBPB-on-Entry feature for SNP guests

Andrew Lunn <andrew@lunn.ch>
    net: phy: register phy led_triggers during probe to avoid AB-BA deadlock

Ankit Garg <nktgrg@google.com>
    gve: fix incorrect buffer cleanup in gve_tx_clean_pending_packets for QPL

Khairul Anuar Romli <khairul.anuar.romli@altera.com>
    spi: cadence-quadspi: Implement refcount to handle unbind during busy

Fedor Pchelkin <pchelkin@ispras.ru>
    ksmbd: call ksmbd_vfs_kern_path_end_removing() on some error paths

Eric Dumazet <edumazet@google.com>
    dst: fix races in rt6_uncached_list_del() and rt_del_uncached_list()

Eric Biggers <ebiggers@kernel.org>
    smb: client: Compare MACs in constant time

Eric Biggers <ebiggers@kernel.org>
    ksmbd: Compare MACs in constant time

Eric Biggers <ebiggers@kernel.org>
    net/tcp-md5: Fix MAC comparison to be constant-time

John Ripple <john.ripple@keysight.com>
    drm/bridge: ti-sn65dsi86: Add support for DisplayPort mode with HPD

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Add missing TID field to no-op command descriptor

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Restart DMA ring correctly after dequeue abort

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Use ETIMEDOUT instead of ETIME for timeout errors

Yasin Lee <yasin.lee.x@gmail.com>
    iio: proximity: hx9023s: Protect against division by zero in set_samp_freq

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: fix odr switch when turning buffer off

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: fix odr switch to the same value

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: gyro: mpu3050-i2c: fix pm_runtime error handling

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: gyro: mpu3050-core: fix pm_runtime error handling

Nuno Sá <nuno.sa@analog.com>
    iio: buffer: Fix wait_queue not being removed

Chris Spencer <spencercw@gmail.com>
    iio: chemical: bme680: Fix measurement wait duration calculation

Lukas Schmid <lukas.schmid@netcube.li>
    iio: potentiometer: mcp4131: fix double application of wiper shift

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: chemical: sps30_i2c: fix buffer size in sps30_i2c_read_meas()

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: chemical: sps30_serial: fix buffer size in sps30_serial_read_meas()

SeungJu Cheon <suunj1331@gmail.com>
    iio: frequency: adf4377: Fix duplicated soft reset mask

Oleksij Rempel <o.rempel@pengutronix.de>
    iio: dac: ds4424: reject -128 RAW value

Filipe Manana <fdmanana@suse.com>
    btrfs: abort transaction on failure to update root in the received subvol ioctl

Filipe Manana <fdmanana@suse.com>
    btrfs: fix transaction abort on set received ioctl due to item overflow

Filipe Manana <fdmanana@suse.com>
    btrfs: fix transaction abort on file creation due to name hash collision

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: fix iface port assignment in parse_server_interfaces

Bharath SM <bharathsm@microsoft.com>
    smb: client: fix in-place encryption corruption in SMB2_write()

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix atomic open with O_DIRECT & O_SYNC

Josh Law <objecting@objecting.org>
    lib/bootconfig: check bounds before writing in __xbc_open_brace()

Josh Law <objecting@objecting.org>
    lib/bootconfig: fix snprintf truncation check in xbc_node_compose_key_after()

Shashank Balaji <shashank.mahadasyam@sony.com>
    x86/apic: Disable x2apic on resume if the kernel expects so

Junxiao Bi <junxiao.bi@oracle.com>
    scsi: core: Fix error handling for scsi_alloc_sdev()

Josh Law <objecting@objecting.org>
    lib/bootconfig: fix off-by-one in xbc_verify_tree() unclosed brace error

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Copy detected format information to secondary device

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Move quiesce state with pprc swap

Long Li <leo.lilong@huawei.com>
    xfs: ensure dquot item is deleted from AIL only after log shutdown

Darrick J. Wong <djwong@kernel.org>
    xfs: fix undersized l_iclog_roundoff values

Carlos Maiolino <cem@kernel.org>
    xfs: fix returned valued from xfs_defer_can_append

Shyam Prasad N <sprasad@microsoft.com>
    cifs: make default value of retrans as zero

Laurent Vivier <lvivier@redhat.com>
    qmi_wwan: allow max_mtu above hard_mtu to control rx_urb_size

Calvin Owens <calvin@wbinvd.org>
    tracing: Fix trace_buf_size= cmdline parameter with sizes >= 2G

Andrei-Alexandru Tachici <andrei-alexandru.tachici@oss.qualcomm.com>
    tracing: Fix enabling multiple events on the kernel command line and bootconfig

Thomas Fourier <fourier.thomas@gmail.com>
    drm/msm: Fix dma_free_attrs() buffer size

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915: Fix potential overflow of shmem scatterlist length

Luca Ceresoli <luca.ceresoli@bootlin.com>
    drm/bridge: ti-sn65dsi83: fix CHA_DSI_CLK_RANGE rounding

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Set num IP blocks to 0 if discovery fails

Alysa Liu <Alysa.Liu@amd.com>
    drm/amdgpu: Fix use-after-free race in VM acquire

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: remove invalid gpu_metrics.energy_accumulator on smu v13.0.x

Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>
    net: dsa: microchip: Fix error path in PTP IRQ setup

Fan Wu <fanwu01@zju.edu.cn>
    net: ethernet: arc: emac: quiesce interrupts before requesting IRQ

Jian Zhang <zhangjian.3032@bytedance.com>
    net: ncsi: fix skb leak in error paths

Mehul Rao <mehulrao@gmail.com>
    net: nexthop: fix percpu use-after-free in remove_nh_grp_entry

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free by using call_rcu() for oplock_info

Marios Makassikis <mmakassikis@freebox.fr>
    smb: server: fix use-after-free in smb2_open()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in smb_lazy_parent_lease_break_close()

Dillon Varone <Dillon.Varone@amd.com>
    drm/amd/display: Fallback to boot snapshot for dispclk

Maximilian Pezzullo <maximilianpezzullo@gmail.com>
    ata: libata-core: Disable LPM on ST1000DM010-2EP102

Maíra Canal <mcanal@igalia.com>
    pmdomain: bcm: bcm2835-power: Fix broken reset status read

Helge Deller <deller@gmx.de>
    parisc: Check kernel mapping earlier at bootup

Piotr Jaroszynski <pjaroszynski@nvidia.com>
    arm64: contpte: fix set_access_flags() no-op check for SMMU/ATS faults

Helge Deller <deller@gmx.de>
    parisc: Fix initial page table creation for boot

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pmbus/q54sj108a2) fix stack overflow in debugfs read

Catalin Marinas <catalin.marinas@arm.com>
    arm64: mm: Add PTE_DIRTY back to PAGE_KERNEL* to fix kexec/hibernation

Dave Airlie <airlied@redhat.com>
    nouveau/dpcd: return EBUSY for aux xfer if the device is asleep

Helge Deller <deller@gmx.de>
    parisc: Increase initial mapping to 64 MB with KALLSYMS

Sven Eckelmann <sven@narfation.org>
    batman-adv: Avoid double-rtnl_lock ELP metric worker

Eric Biggers <ebiggers@kernel.org>
    net/tcp-ao: Fix MAC comparison to be constant-time

Huiwen He <hehuiwen@kylinos.cn>
    tracing: Fix syscall events activation by ensuring refcount hits zero

Jakub Staniszewski <jakub.staniszewski@linux.intel.com>
    ice: fix retry for AQ command 0x06EE

Long Li <longli@microsoft.com>
    net: mana: Ring doorbell at 4 CQ wraparounds

Ariel Silver <arielsilver77@gmail.com>
    media: dvb-net: fix OOB access in ULE extension header tables

Luka Gejak <luka.gejak@linux.dev>
    staging: rtl8723bs: fix potential out-of-bounds read in rtw_restruct_wmm_ie

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    staging: rtl8723bs: properly validate the data in rtw_get_ie_ex()

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    ixgbevf: fix link setup issue

Jakub Staniszewski <jakub.staniszewski@linux.intel.com>
    ice: reintroduce retry mechanism for indirect AQ

Mark Harmstone <mark@harmstone.com>
    btrfs: fix chunk map leak in btrfs_map_block() after btrfs_chunk_map_num_copies()

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v3-its: Limit number of per-device MSIs to the range the ITS supports

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    device property: Allow secondary lookup in fwnode_get_next_child_node()

Kuniyuki Iwashima <kuniyu@google.com>
    nfsd: Fix cred ref leak in nfsd_nl_listener_set_doit().

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/pfault: Fix virtual vs physical address confusion

Franz Schnyder <franz.schnyder@toradex.com>
    drm/bridge: ti-sn65dsi86: Enable HPD polling if IRQ is not used

Osama Abdelkader <osama.abdelkader@gmail.com>
    drm/bridge: samsung-dsim: Fix memory leak in error path

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Disable MES LR compute W/A

Xu Yang <xu.yang_2@nxp.com>
    Revert "tcpm: allow looking for role_sw device in the main node"

Linus Torvalds <torvalds@linux-foundation.org>
    Fix CC_HAS_ASM_GOTO_OUTPUT on non-x86 architectures

Thomas Gleixner <tglx@linutronix.de>
    kbuild: Disable CC_HAS_ASM_GOTO_OUTPUT on clang < 17

Xingui Yang <yangxingui@huawei.com>
    scsi: hisi_sas: Fix NULL pointer exception during user_scan()

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Use macro instead of magic number

Xingui Yang <yangxingui@huawei.com>
    scsi: hisi_sas: Add time interval between two H2D FIS following soft reset spec

Wang Shuaiwei <wangshuaiwei1@xiaomi.com>
    scsi: ufs: core: Fix SError in ufshcd_rtc_work() during UFS suspend

Adrian Ng Ho Yin <adrianhoyin.ng@altera.com>
    i3c: dw-i3c-master: Set SIR_REJECT in DAT on device attach and reattach

Steven Rostedt <rostedt@goodmis.org>
    time/jiffies: Mark jiffies_64_to_clock_t() notrace

Max Kellermann <max.kellermann@ionos.com>
    ceph: fix memory leaks in ceph_mdsc_build_path()

Max Kellermann <max.kellermann@ionos.com>
    ceph: fix i_nlink underrun during async unlink

Ilya Dryomov <idryomov@gmail.com>
    libceph: admit message frames only in CEPH_CON_S_OPEN state

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Use u32 for non-negative values in ceph_monmap_decode()

Ilya Dryomov <idryomov@gmail.com>
    libceph: prevent potential out-of-bounds reads in process_message_header()

Ilya Dryomov <idryomov@gmail.com>
    libceph: reject preamble if control segment is empty

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix potential out-of-bounds access in ceph_handle_auth_reply()

Max Kellermann <max.kellermann@ionos.com>
    ceph: add a bunch of missing ceph_path_info initializers

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    kprobes: avoid crash when rmmod/insmod after ftrace killed

Mehul Rao <mehulrao@gmail.com>
    tipc: fix divide-by-zero in tipc_sk_filter_connect()

Ravi Hothi <ravi.hothi@oss.qualcomm.com>
    ASoC: qcom: qdsp6: Fix q6apm remove ordering during ADSP stop and start

Penghe Geng <pgeng@nvidia.com>
    mmc: core: Avoid bitfield RMW for claim/retune flags

Alexander Potapenko <glider@google.com>
    mm/kfence: disable KFENCE upon KASAN HW tags enablement

Felix Gu <ustc.gu@gmail.com>
    mmc: mmci: Fix device_node reference leak in of_get_dml_pipe_index()

Kalesh Singh <kaleshsingh@google.com>
    mm/tracing: rss_stat: ensure curr is false from kthread context

Miguel Ojeda <ojeda@kernel.org>
    rust: kbuild: allow `unused_features`

Ziyi Guo <n7l8m4@u.northwestern.edu>
    usb: image: mdc800: kill download URB on timeout

Oliver Neukum <oneukum@suse.com>
    usb: mdc800: handle signal and read racing

Fan Wu <fanwu01@zju.edu.cn>
    usb: renesas_usbhs: fix use-after-free in ISR during device removal

Oliver Neukum <oneukum@suse.com>
    usb: class: cdc-wdm: fix reordering issue in read code path

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Limit the length of unkillable synchronous timeouts

Alan Stern <stern@rowland.harvard.edu>
    USB: usbtmc: Use usb_bulk_msg_killable() with user-specified timeouts

Alan Stern <stern@rowland.harvard.edu>
    USB: usbcore: Introduce usb_bulk_msg_killable()

RD Babiera <rdbabiera@google.com>
    usb: typec: altmode/displayport: set displayport signaling rate in configure message

Xu Yang <xu.yang_2@nxp.com>
    usb: roles: get usb role switch from parent only for usb-b-connector

Marc Zyngier <maz@kernel.org>
    usb: cdc-acm: Restore CAP_BRK functionnality to CH343

Gabor Juhos <j4g8y7@gmail.com>
    usb: core: don't power off roothub PHYs if phy_set_mode() fails

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: misc: uss720: properly clean up reference in uss720_probe()

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add support for the Intel Nova Lake -H

Oliver Neukum <oneukum@suse.com>
    usb: yurex: fix race in probe

Dayu Jiang <jiangdayu@xiaomi.com>
    usb: xhci: Prevent interrupt storm on host controller error (HCE)

Zilin Guan <zilin@seu.edu.cn>
    usb: xhci: Fix memory leak in xhci_disable_slot()

Vyacheslav Vahnenko <vahnenko2003@gmail.com>
    USB: ezcap401 needs USB_QUIRK_NO_BOS to function on 10gbs usb speed

Christoffer Sandberg <cs@tuxedo.de>
    usb/core/quirks: Add Huawei ME906S-device to wakeup quirk

A1RM4X <dev@a1rm4x.com>
    USB: add QUIRK_NO_BOS for video capture several devices

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Initialize AVIC VMCB fields if AVIC is enabled with in-kernel APIC

Zhang Heng <zhangheng@kylinos.cn>
    ASoC: amd: yc: Add DMI quirk for ASUS EXPERTBOOK PM1503CDA

Pedro Falcato <pfalcato@suse.de>
    ata: libata-core: Add BRIDGE_OK quirk for QEMU drives

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: lan78xx: skip LTM configuration for LAN7850

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: lan78xx: fix TX byte statistics for small packets

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: lan78xx: fix silent drop of packets with checksum errors

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Check endpoint numbers at parsing Scarlett2 mixer interfaces

Mehul Rao <mehulrao@gmail.com>
    ALSA: pcm: fix use-after-free on linked stream runtime in snd_pcm_drain()

Qingye Zhao <zhaoqingye@honor.com>
    cgroup: fix race between task migration and iteration

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sdm845-oneplus: Mark l14a regulator as boot-on"

Seungjin Bae <eeodqql09@gmail.com>
    usb: gadget: f_mass_storage: Fix potential integer overflow in check_command_size_in_blocks()

Andreas Kemnade <andreas@kemnade.info>
    iio: imu: inv-mpu9150: fix irq ack preventing irq storms

Eric Dumazet <edumazet@google.com>
    net: prevent NULL deref in ip[6]tunnel_xmit()

Alok Tiwari <alok.a.tiwari@oracle.com>
    octeontx2-af: devlink: fix NIX RAS reporter to use RAS interrupt status

Alok Tiwari <alok.a.tiwari@oracle.com>
    octeontx2-af: devlink: fix NIX RAS reporter recovery condition

Marek Behún <kabel@kernel.org>
    net: dsa: realtek: Fix LED group port bit for non-zero LED group

Ricardo B. Marlière <rbm@suse.com>
    net: bonding: Fix nd_tbl NULL dereference when IPv6 is disabled

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Unreserve bo if queue update failed

Casey Connolly <casey.connolly@linaro.org>
    ASoC: detect empty DMI strings

Chen Ni <nichen@iscas.ac.cn>
    ASoC: amd: acp3x-rt5682-max9836: Add missing error check for clock acquisition

Ben Dooks <ben.dooks@codethink.co.uk>
    ACPI: OSL: fix __iomem type on return from acpi_os_map_generic_address()

Nicolai Buchwitz <nb@tipi-net.de>
    net: bcmgenet: fix broken EEE by converting to phylib-managed state

Matt Vollrath <tactii@gmail.com>
    e1000/e1000e: Fix leak in DMA error cleanup

Alok Tiwari <alok.a.tiwari@oracle.com>
    i40e: fix src IP mask checks and memcpy argument names in cloud filter

Sungwoo Kim <iam@sung-woo.kim>
    nvme-pci: Fix race bug in nvme_poll_irqdisable()

Sungwoo Kim <iam@sung-woo.kim>
    nvme-pci: Fix slab-out-of-bounds in nvme_dbbuf_set

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    sched: idle: Make skipping governor callbacks more consistent

Chen Ni <nichen@iscas.ac.cn>
    perf ftrace: Fix hashmap__new() error checking

Peng Fan <peng.fan@nxp.com>
    regulator: pca9450: Correct interrupt type

Chen Ni <nichen@iscas.ac.cn>
    perf annotate: Fix hashmap__new() error checking

Yuan Tan <tanyuan98@outlook.com>
    netfilter: xt_IDLETIMER: reject rev0 reuse of ALARM timer labels

Hyunwoo Kim <imv4bel@gmail.com>
    netfilter: nfnetlink_cthelper: fix OOB read in nfnl_cthelper_dump_table()

Hyunwoo Kim <imv4bel@gmail.com>
    netfilter: nfnetlink_queue: fix entry leak in bridge verdict error path

David Dull <monderasdor@gmail.com>
    netfilter: x_tables: guard option walkers against 1-byte tail reads

Jenny Guanni Qu <qguanni@gmail.com>
    netfilter: nft_set_pipapo: fix stack out-of-bounds read in pipapo_drop()

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: always walk all pending catchall elements

Weiming Shi <bestswngs@gmail.com>
    net: add xmit recursion limit to tunnel xmit functions

Toke Høiland-Jørgensen <toke@redhat.com>
    xdp: register system page pool as an XDP memory model

Alexander Lobakin <aleksander.lobakin@intel.com>
    xdp: allow attaching already registered memory model to xdp_rxq_info

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: prevent CRC errors during RX adaptation with AN disabled

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: fix link status handling in xgbe_rx_adaptation

Chengfeng Ye <dg573847474@gmail.com>
    mctp: route: hold key->lock in mctp_flow_prepare_output()

Jiayuan Chen <jiayuan.chen@shopee.com>
    bonding: fix type confusion in bond_setup_by_slave()

Hangbin Liu <liuhangbin@gmail.com>
    bonding: use common function to compute the features

Hangbin Liu <liuhangbin@gmail.com>
    net: add a common function to compute features for upper devices

Cosmin Ratiu <cratiu@nvidia.com>
    bonding: Correctly support GSO ESP offload

Jianbo Liu <jianbol@nvidia.com>
    bonding: add ESP offload features when slaves support

Wenyuan Li <2063309626@qq.com>
    can: hi311x: hi3110_open(): add check for hi3110_power_enable() return value

Haiyue Wang <haiyuewa@163.com>
    mctp: i2c: fix skb memory leak in receive path

Pavan Chebbi <pavan.chebbi@broadcom.com>
    bnxt_en: Fix RSS table size check when changing ethtool channels

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    serial: caif: hold tty->link reference in ldisc_open and ser_release

Álvaro Fernández Rojas <noltari@gmail.com>
    net: sfp: improve Huawei MA5671a fixup

Sen Wang <sen@ti.com>
    ASoC: simple-card-utils: fix graph_util_is_ports0() for DT overlays

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: simple-card-utils: use __free(device_node) for device node

matteo.cotifava <cotifavamatteo@gmail.com>
    ASoC: soc-core: flush delayed work before removing DAIs and widgets

matteo.cotifava <cotifavamatteo@gmail.com>
    ASoC: soc-core: drop delayed_work_pending() check before flush

David Lechner <dlechner@baylibre.com>
    drm/sitronix/st7586: fix bad pixel data due to byte swap

Weiming Shi <bestswngs@gmail.com>
    net/sched: teql: fix NULL pointer dereference in iptunnel_xmit on TEQL slave xmit

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix DMA FIFO desync on error CQE SQ recovery

Patrisious Haddad <phaddad@nvidia.com>
    net/mlx5: Fix crash when moving to switchdev mode

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5: Fix deadlock between devlink lock and esw->wq

Daniel Jurgens <danielj@nvidia.com>
    net/mlx5: Query to see if host PF is disabled

Daniel Jurgens <danielj@nvidia.com>
    net/mlx5: IFC updates for disabled host PF

Hangbin Liu <liuhangbin@gmail.com>
    bonding: handle BOND_LINK_FAIL, BOND_LINK_BACK as valid link states

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: add missing od setting PP_OD_FEATURE_ZERO_FAN_BIT for smu v14

Pengyu Luo <mitltlatltl@gmail.com>
    drm/msm/dsi: fix pclk rate calculation for bonded dsi

Mieczyslaw Nalewaj <namiltd@yahoo.com>
    net: dsa: realtek: rtl8365mb: remove ifOutDiscards from rx_packets

Peter Collingbourne <pcc@google.com>
    perf disasm: Fix off-by-one bug in outside check

Breno Leitao <leitao@debian.org>
    workqueue: Use POOL_BH instead of WQ_BH when checking pool flags

Sun YangKai <sunk67188@gmail.com>
    btrfs: hold space_info->lock when clearing periodic reclaim ready

Eric Badger <ebadger@purestorage.com>
    xprtrdma: Decrement re_receiving on the early exit paths

Pengyu Luo <mitltlatltl@gmail.com>
    drm/msm/dsi: fix hdisplay calculation when programming dsi registers

Roberto Bergantinos Corpas <rbergant@redhat.com>
    nfs: return EISDIR on nfs3_proc_create if d_alias is a dir

Guenter Roeck <linux@roeck-us.net>
    smb/server: Fix another refcount leak in smb2_open()

J. Neuschäfer <j.ne@posteo.net>
    powerpc: 83xx: km83xx: Fix keymile vendor prefix

Tzung-Bi Shih <tzungbi@kernel.org>
    remoteproc: mediatek: Unprepare SCP clock during system suspend

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    remoteproc: sysmon: Correct subsys_name_len type in QMI request

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/crash: adjust the elfcorehdr size

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/kexec/core: use big-endian types for crash variables

Ben Collins <bcollins@kernel.org>
    kexec: Include kernel-end even without crashkernel

Eliav Farber <farbere@amazon.com>
    kexec: Consolidate machine_kexec_mask_interrupts() implementation

Christophe Leroy (CS GROUP) <chleroy@kernel.org>
    powerpc/uaccess: Fix inline assembly for clang build on PPC32

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Check max frame size for implicit feedback mode, too

sguttula <suresh.guttula@amd.com>
    drm/amdgpu/vcn5: Add SMU dpm interface type

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Avoid implicit feedback mode on DIYINHK USB Audio 2.0

wangshuaiwei <wangshuaiwei1@xiaomi.com>
    scsi: ufs: core: Fix shift out of bounds when MAXQ=32

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Fix possible NULL pointer dereference in ufshcd_add_command_trace()

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l43: Report insert for exotic peripherals

Azamat Almazbek uulu <almazbek1608@gmail.com>
    ASoC: amd: yc: Add ASUS EXPERTBOOK BM1503CDA to quirk table

Tomas Henzl <thenzl@redhat.com>
    scsi: ses: Fix devices attaching to different hosts

Sofia Schneider <sofia@schn.dev>
    ACPI: OSI: Add DMI quirk for Acer Aspire One D255

Ramanathan Choodamani <quic_rchoodam@quicinc.com>
    wifi: mac80211: set default WMM parameters on all links

Al Viro <viro@zeniv.linux.org.uk>
    unshare: fix unshare_fs() handling

Sean Rhodes <sean@starlabs.systems>
    ALSA: hda/realtek: Fix speaker pop on Star Labs StarFighter

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Add NULL checks when resetting request and reply queues

Piotr Mazek <pmazek@outlook.com>
    ACPI: PM: Save NVS memory on Lenovo G70-35

Jan Kiszka <jan.kiszka@siemens.com>
    scsi: storvsc: Fix scheduling while atomic on PREEMPT_RT


-------------

Diffstat:

 Documentation/virt/kvm/api.rst                     |  52 ++++
 Makefile                                           |  13 +-
 arch/arm/kernel/machine_kexec.c                    |  23 --
 arch/arm64/Kconfig                                 |   1 +
 .../arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi |   1 -
 arch/arm64/boot/dts/renesas/r9a09g057.dtsi         |  37 +--
 arch/arm64/include/asm/pgtable-prot.h              |  10 +-
 arch/arm64/kernel/machine_kexec.c                  |  31 ---
 arch/arm64/mm/contpte.c                            |  53 ++++-
 arch/loongarch/include/asm/uaccess.h               |  14 +-
 arch/parisc/include/asm/pgtable.h                  |   2 +-
 arch/parisc/kernel/cache.c                         |   4 +-
 arch/parisc/kernel/head.S                          |   7 +-
 arch/parisc/kernel/setup.c                         |  20 +-
 arch/powerpc/include/asm/kexec.h                   |   1 -
 arch/powerpc/include/asm/uaccess.h                 |   2 +-
 arch/powerpc/kexec/core.c                          |  60 ++---
 arch/powerpc/kexec/core_32.c                       |   1 +
 arch/powerpc/kexec/file_load_64.c                  |  14 +-
 arch/powerpc/net/bpf_jit_comp.c                    |   2 +-
 arch/powerpc/net/bpf_jit_comp64.c                  | 140 +++++++----
 arch/powerpc/platforms/83xx/km83xx.c               |   4 +-
 arch/riscv/kernel/machine_kexec.c                  |  23 --
 arch/s390/include/asm/processor.h                  |   2 +-
 arch/s390/lib/xor.c                                |   4 +-
 arch/s390/mm/pfault.c                              |   4 +-
 arch/x86/boot/compressed/sev.c                     |   1 +
 arch/x86/coco/sev/core.c                           |   1 +
 arch/x86/events/intel/core.c                       |  25 +-
 arch/x86/events/intel/uncore_snbep.c               |  78 ++++--
 arch/x86/include/asm/kvm_host.h                    |   9 +-
 arch/x86/include/asm/msr-index.h                   |   5 +-
 arch/x86/include/uapi/asm/kvm.h                    |   3 +
 arch/x86/kernel/apic/apic.c                        |   6 +
 arch/x86/kernel/apic/x2apic_uv_x.c                 |  18 +-
 arch/x86/kernel/uprobes.c                          |  24 ++
 arch/x86/kvm/mmu.h                                 |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |  10 +-
 arch/x86/kvm/svm/avic.c                            |  30 ++-
 arch/x86/kvm/svm/svm.c                             |  14 +-
 arch/x86/kvm/vmx/nested.c                          |  26 +-
 arch/x86/kvm/vmx/vmx.c                             |  50 +++-
 arch/x86/kvm/x86.c                                 |  23 +-
 arch/x86/kvm/x86.h                                 |   3 +
 block/blk-cgroup.c                                 |   6 -
 block/blk-cgroup.h                                 |   6 +
 block/blk-throttle.c                               |   6 +-
 block/blk-throttle.h                               |  18 +-
 drivers/acpi/acpi_processor.c                      |  15 +-
 drivers/acpi/osi.c                                 |  13 +
 drivers/acpi/osl.c                                 |   2 +-
 drivers/acpi/sleep.c                               |   8 +
 drivers/ata/libata-core.c                          |   5 +
 drivers/ata/libata-scsi.c                          |  83 ++++---
 drivers/base/power/runtime.c                       |   1 +
 drivers/base/property.c                            |  27 +--
 drivers/bluetooth/btqca.c                          |   2 +
 drivers/cache/ax45mp_cache.c                       |   4 +-
 drivers/cache/starfive_starlink_cache.c            |   4 +-
 drivers/cpuidle/cpuidle.c                          |  10 -
 drivers/crypto/atmel-sha204a.c                     |   5 +-
 drivers/dma/mmp_pdma.c                             |   6 +
 drivers/firewire/net.c                             |   5 +-
 drivers/firmware/arm_ffa/driver.c                  |   8 +-
 drivers/firmware/arm_scpi.c                        |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c     |  20 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |  21 +-
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c             |   5 -
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c             |   5 -
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c            |   9 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c          |   3 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_2.c          |   3 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v4_1_0.c          |   3 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c            |   4 +
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   1 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   4 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c   |   1 +
 drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c   |   8 +-
 .../amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c |   2 +-
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c    |   2 +-
 drivers/gpu/drm/amd/display/dc/dm_services_types.h |   2 +-
 .../drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c  |   6 +-
 .../amd/display/dc/resource/dcn32/dcn32_resource.c |   3 +
 drivers/gpu/drm/amd/include/dm_pp_interface.h      |   1 +
 drivers/gpu/drm/amd/pm/amdgpu_dpm_internal.c       |  67 ++++++
 drivers/gpu/drm/amd/pm/inc/amdgpu_dpm_internal.h   |   2 +
 drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c         |   4 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/legacy_dpm.c     |   6 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |  69 ++----
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c   |  11 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |   8 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |   3 +-
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c   |   3 +-
 drivers/gpu/drm/bridge/samsung-dsim.c              |  25 +-
 drivers/gpu/drm/bridge/ti-sn65dsi83.c              |  13 +-
 drivers/gpu/drm/bridge/ti-sn65dsi86.c              | 118 ++++++++-
 drivers/gpu/drm/drm_file.c                         |   5 +-
 drivers/gpu/drm/drm_mode_config.c                  |   9 +-
 drivers/gpu/drm/i915/display/intel_display_types.h |   1 +
 drivers/gpu/drm/i915/display/intel_psr.c           |  71 ++++--
 drivers/gpu/drm/i915/display/intel_vdsc.c          |  23 ++
 drivers/gpu/drm/i915/display/intel_vdsc.h          |   3 +
 drivers/gpu/drm/i915/display/intel_vdsc_regs.h     |  12 +
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c          |  12 +-
 drivers/gpu/drm/i915/gt/intel_engine_cs.c          |   3 +-
 drivers/gpu/drm/imagination/pvr_power.c            |  11 +-
 drivers/gpu/drm/msm/adreno/a2xx_gpummu.c           |   2 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  43 +++-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   3 +
 drivers/gpu/drm/radeon/si_dpm.c                    |   4 +-
 drivers/gpu/drm/tiny/st7586.c                      |  15 +-
 drivers/gpu/drm/xe/xe_ggtt.c                       |  10 +-
 drivers/gpu/drm/xe/xe_ggtt_types.h                 |   5 +-
 drivers/gpu/drm/xe/xe_oa.c                         |   7 +-
 drivers/gpu/drm/xe/xe_sync.c                       |  24 +-
 drivers/hid/bpf/hid_bpf_dispatch.c                 |   2 +
 drivers/hwmon/max6639.c                            |  10 +-
 drivers/hwmon/pmbus/isl68137.c                     |   7 +-
 drivers/hwmon/pmbus/mp2975.c                       |   2 +
 drivers/hwmon/pmbus/q54sj108a2.c                   |  19 +-
 drivers/i2c/busses/i2c-cp2615.c                    |   3 +
 drivers/i2c/busses/i2c-fsi.c                       |   1 +
 drivers/i2c/busses/i2c-pxa.c                       |  17 +-
 drivers/i3c/master/dw-i3c-master.c                 |   4 +-
 drivers/i3c/master/mipi-i3c-hci/cmd.h              |   1 +
 drivers/i3c/master/mipi-i3c-hci/cmd_v1.c           |   2 +-
 drivers/i3c/master/mipi-i3c-hci/cmd_v2.c           |   2 +-
 drivers/i3c/master/mipi-i3c-hci/core.c             |   6 +-
 drivers/i3c/master/mipi-i3c-hci/dma.c              |   4 +-
 drivers/iio/chemical/bme680_core.c                 |   2 +-
 drivers/iio/chemical/sps30_i2c.c                   |   2 +-
 drivers/iio/chemical/sps30_serial.c                |   2 +-
 drivers/iio/dac/ds4424.c                           |   2 +-
 drivers/iio/frequency/adf4377.c                    |   2 +-
 drivers/iio/gyro/mpu3050-core.c                    |  18 +-
 drivers/iio/gyro/mpu3050-i2c.c                     |   3 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c  |   2 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c |   4 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c   |   2 +
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c         |   8 +
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h          |   2 +
 drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c      |   5 +-
 drivers/iio/industrialio-buffer.c                  |   6 +-
 drivers/iio/potentiometer/mcp4131.c                |   2 +-
 drivers/iio/proximity/hx9023s.c                    |   3 +
 drivers/iommu/intel/dmar.c                         |   3 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   4 +
 drivers/md/dm-verity-fec.c                         |   4 +-
 drivers/md/dm-verity-fec.h                         |   3 -
 drivers/media/dvb-core/dvb_net.c                   |   3 +
 drivers/mmc/host/dw_mmc-rockchip.c                 |  51 +++-
 drivers/mmc/host/mmci_qcom_dml.c                   |   1 +
 drivers/mmc/host/sdhci-pci-gli.c                   |   9 +
 drivers/mmc/host/sdhci.c                           |   9 +-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |   6 +-
 drivers/mtd/nand/raw/cadence-nand-controller.c     |   2 +-
 drivers/mtd/nand/raw/nand_base.c                   |  14 +-
 drivers/mtd/nand/raw/pl35x-nand-controller.c       |   3 +
 drivers/mtd/parsers/redboot.c                      |   6 +-
 drivers/mtd/spi-nor/core.c                         | 145 ++++++++++-
 drivers/net/bonding/bond_debugfs.c                 |  16 +-
 drivers/net/bonding/bond_main.c                    | 138 +++++------
 drivers/net/caif/caif_serial.c                     |   3 +
 drivers/net/can/spi/hi311x.c                       |   5 +-
 drivers/net/can/usb/gs_usb.c                       |  22 +-
 drivers/net/dsa/bcm_sf2.c                          |   8 +-
 drivers/net/dsa/microchip/ksz_ptp.c                |  11 +-
 drivers/net/dsa/realtek/rtl8365mb.c                |   3 +-
 drivers/net/dsa/realtek/rtl8366rb-leds.c           |   6 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |   4 +
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |  82 ++++++-
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   4 +
 drivers/net/ethernet/arc/emac_main.c               |  11 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  31 +--
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |   5 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |   2 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |  10 +-
 drivers/net/ethernet/cadence/macb_main.c           | 124 +++++++++-
 drivers/net/ethernet/cadence/macb_ptp.c            |   4 +-
 drivers/net/ethernet/google/gve/gve_tx_dqo.c       |  52 ++--
 drivers/net/ethernet/intel/e1000/e1000_main.c      |   2 -
 drivers/net/ethernet/intel/e1000e/netdev.c         |   2 -
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  14 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   9 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |  13 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  35 ++-
 drivers/net/ethernet/intel/ice/ice_main.c          |   3 +-
 drivers/net/ethernet/intel/igc/igc.h               |   2 +
 drivers/net/ethernet/intel/igc/igc_main.c          |  14 +-
 drivers/net/ethernet/intel/igc/igc_ptp.c           |  33 +++
 drivers/net/ethernet/intel/ixgbevf/vf.c            |   3 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   4 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |   3 +
 .../ethernet/marvell/octeontx2/af/rvu_devlink.c    |   6 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_sdp.c    |   2 +-
 drivers/net/ethernet/mediatek/airoha_eth.c         |  52 ++--
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |   1 -
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |   1 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |   2 +-
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c    |  52 ++--
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |  23 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  30 ++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   3 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  18 +-
 drivers/net/ethernet/microsoft/mana/hw_channel.c   |   6 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  23 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |   1 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |   4 -
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   |   7 -
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   2 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  36 ---
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   8 -
 drivers/net/mctp/mctp-i2c.c                        |   1 +
 drivers/net/phy/phy_device.c                       |  25 +-
 drivers/net/phy/sfp.c                              |   8 +-
 drivers/net/usb/aqc111.c                           |  12 +-
 drivers/net/usb/cdc_ncm.c                          |  10 +-
 drivers/net/usb/lan78xx.c                          |  10 +-
 drivers/net/usb/lan78xx.h                          |   3 +
 drivers/net/usb/qmi_wwan.c                         |   4 +-
 drivers/net/usb/usbnet.c                           |   7 +-
 drivers/net/wireless/marvell/libertas/main.c       |   4 +-
 drivers/net/wireless/ti/wlcore/tx.c                |   2 +-
 drivers/nfc/nxp-nci/i2c.c                          |   4 +-
 drivers/nvdimm/bus.c                               |   5 +-
 drivers/nvme/host/pci.c                            |   8 +-
 drivers/platform/x86/amd/pmc/pmc.c                 |   3 +
 drivers/platform/x86/amd/pmc/pmc.h                 |   1 +
 .../platform/x86/hp/hp-bioscfg/enum-attributes.c   |   9 +-
 drivers/pmdomain/bcm/bcm2835-power.c               |  18 +-
 drivers/regulator/pca9450-regulator.c              |   2 +-
 drivers/remoteproc/mtk_scp.c                       |  39 +++
 drivers/remoteproc/qcom_sysmon.c                   |   2 +-
 drivers/s390/block/dasd_eckd.c                     |  16 ++
 drivers/s390/crypto/zcrypt_ccamisc.c               |  12 +-
 drivers/s390/crypto/zcrypt_cex4.c                  |   3 +-
 drivers/scsi/hisi_sas/hisi_sas.h                   |  43 +++-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |  42 +++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             | 246 ++++++++++++-------
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  32 +--
 drivers/scsi/scsi_scan.c                           |   8 +-
 drivers/scsi/ses.c                                 |   5 +-
 drivers/scsi/storvsc_drv.c                         |   5 +-
 drivers/soc/fsl/qbman/qman.c                       |  24 +-
 drivers/soc/fsl/qe/qmc.c                           |   4 +-
 drivers/soc/microchip/mpfs-sys-controller.c        |  13 +-
 drivers/soc/rockchip/grf.c                         |   1 +
 drivers/spi/spi-cadence-quadspi.c                  |  33 +++
 drivers/spi/spi.c                                  |  25 +-
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c     |  15 +-
 drivers/staging/rtl8723bs/core/rtw_mlme.c          |   5 +-
 drivers/tty/serial/8250/8250_dma.c                 |  15 ++
 drivers/tty/serial/8250/8250_pci.c                 |  17 ++
 drivers/tty/serial/8250/8250_port.c                |   6 +
 drivers/tty/serial/uartlite.c                      |   1 +
 drivers/ufs/core/ufshcd.c                          |   8 +-
 drivers/usb/class/cdc-acm.c                        |   5 +
 drivers/usb/class/cdc-acm.h                        |   1 +
 drivers/usb/class/cdc-wdm.c                        |   4 +-
 drivers/usb/class/usbtmc.c                         |   6 +-
 drivers/usb/core/message.c                         | 100 ++++++--
 drivers/usb/core/phy.c                             |   8 +-
 drivers/usb/core/quirks.c                          |  16 ++
 drivers/usb/dwc3/dwc3-pci.c                        |   2 +
 drivers/usb/gadget/function/f_mass_storage.c       |  12 +-
 drivers/usb/gadget/function/f_ncm.c                |  36 ++-
 drivers/usb/gadget/function/f_tcm.c                |  14 ++
 drivers/usb/gadget/function/u_ether.c              |  22 ++
 drivers/usb/gadget/function/u_ether.h              |  26 ++
 drivers/usb/gadget/function/u_ncm.h                |   2 +-
 drivers/usb/host/xhci-ring.c                       |   1 +
 drivers/usb/host/xhci.c                            |   4 +-
 drivers/usb/image/mdc800.c                         |   6 +-
 drivers/usb/misc/uss720.c                          |   2 +-
 drivers/usb/misc/yurex.c                           |   2 +-
 drivers/usb/renesas_usbhs/common.c                 |   9 +
 drivers/usb/roles/class.c                          |   7 +-
 drivers/usb/serial/f81232.c                        |  77 +++---
 drivers/usb/typec/altmodes/displayport.c           |   7 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   2 +-
 fs/binfmt_misc.c                                   |   4 +-
 fs/btrfs/disk-io.c                                 |  22 --
 fs/btrfs/extent_io.c                               |   3 +-
 fs/btrfs/extent_io.h                               |   3 +-
 fs/btrfs/inode.c                                   |  19 ++
 fs/btrfs/ioctl.c                                   |  24 +-
 fs/btrfs/space-info.c                              |   5 +-
 fs/btrfs/transaction.c                             |  16 ++
 fs/btrfs/tree-checker.c                            |   2 +-
 fs/btrfs/tree-log.c                                |   6 +
 fs/btrfs/uuid-tree.c                               |  38 +++
 fs/btrfs/uuid-tree.h                               |   2 +
 fs/btrfs/volumes.c                                 |   6 +-
 fs/ceph/debugfs.c                                  |   4 +-
 fs/ceph/dir.c                                      |  17 +-
 fs/ceph/file.c                                     |   4 +-
 fs/ceph/inode.c                                    |   2 +-
 fs/ceph/mds_client.c                               |   3 +
 fs/erofs/zdata.c                                   |  21 +-
 fs/f2fs/compress.c                                 |  74 +++---
 fs/f2fs/f2fs.h                                     |   2 +
 fs/f2fs/gc.c                                       |  16 +-
 fs/iomap/buffered-io.c                             |  15 +-
 fs/nfs/nfs3proc.c                                  |   7 +-
 fs/nfsd/nfs4xdr.c                                  |   9 +-
 fs/nfsd/nfsctl.c                                   |  16 +-
 fs/nfsd/state.h                                    |  17 +-
 fs/nsfs.c                                          |  21 ++
 fs/smb/client/cifsencrypt.c                        |   3 +-
 fs/smb/client/cifsfs.c                             |   7 +-
 fs/smb/client/cifsglob.h                           |  11 +
 fs/smb/client/cifsproto.h                          |   1 +
 fs/smb/client/connect.c                            |   4 +
 fs/smb/client/dir.c                                |   1 +
 fs/smb/client/file.c                               |  29 +--
 fs/smb/client/fs_context.c                         |   2 +-
 fs/smb/client/misc.c                               |  42 ++++
 fs/smb/client/smb2ops.c                            |  14 +-
 fs/smb/client/smb2pdu.c                            |   5 +-
 fs/smb/client/smb2transport.c                      |   4 +-
 fs/smb/client/trace.h                              |   2 +
 fs/smb/server/Kconfig                              |   1 +
 fs/smb/server/auth.c                               |  26 +-
 fs/smb/server/oplock.c                             |  35 ++-
 fs/smb/server/oplock.h                             |   5 +-
 fs/smb/server/smb2pdu.c                            |  34 ++-
 fs/tests/exec_kunit.c                              |   3 -
 fs/xfs/libxfs/xfs_defer.c                          |   2 +-
 fs/xfs/scrub/agheader_repair.c                     |  13 +-
 fs/xfs/scrub/alloc_repair.c                        |   5 +-
 fs/xfs/scrub/attr_repair.c                         |  20 +-
 fs/xfs/scrub/bmap_repair.c                         |   6 +-
 fs/xfs/scrub/common.h                              |  18 --
 fs/xfs/scrub/dir.c                                 |  13 +-
 fs/xfs/scrub/dir_repair.c                          |  11 +-
 fs/xfs/scrub/dirtree.c                             |  11 +-
 fs/xfs/scrub/ialloc_repair.c                       |   5 +-
 fs/xfs/scrub/nlinks.c                              |   6 +-
 fs/xfs/scrub/orphanage.c                           |   7 +-
 fs/xfs/scrub/parent.c                              |  11 +-
 fs/xfs/scrub/parent_repair.c                       |  23 +-
 fs/xfs/scrub/quotacheck.c                          |  13 +-
 fs/xfs/scrub/refcount_repair.c                     |  13 +-
 fs/xfs/scrub/rmap_repair.c                         |   5 +-
 fs/xfs/scrub/rtsummary.c                           |   7 +-
 fs/xfs/xfs_bmap_item.c                             |   3 +-
 fs/xfs/xfs_dquot.c                                 |   8 +-
 fs/xfs/xfs_log.c                                   |   2 +
 include/linux/cleanup.h                            |  19 ++
 include/linux/etherdevice.h                        |   3 +-
 include/linux/huge_mm.h                            |   4 +
 include/linux/if_ether.h                           |   3 +-
 include/linux/io_uring_types.h                     |   3 +
 include/linux/irq.h                                |   3 +
 include/linux/irqchip/arm-gic-v3.h                 |   1 +
 include/linux/mlx5/mlx5_ifc.h                      |   4 +-
 include/linux/mmc/host.h                           |   9 +-
 include/linux/netdev_features.h                    |  18 ++
 include/linux/netdevice.h                          |  40 +++-
 include/linux/stmmac.h                             |   1 -
 include/linux/trace_recursion.h                    |   9 +
 include/linux/uprobes.h                            |   1 +
 include/linux/usb.h                                |   8 +-
 include/linux/usb/usbnet.h                         |   1 +
 include/net/dsa.h                                  |   1 +
 include/net/ip6_tunnel.h                           |  14 ++
 include/net/ip_tunnels.h                           |   7 +
 include/net/netfilter/nf_tables.h                  |   2 +
 include/net/sch_generic.h                          |  33 +++
 include/net/tc_act/tc_gate.h                       |  33 ++-
 include/net/udp_tunnel.h                           |   2 +-
 include/net/xdp.h                                  |  32 +++
 include/trace/events/kmem.h                        |   8 +-
 include/trace/events/rxrpc.h                       |   4 +
 init/Kconfig                                       |   3 +
 io_uring/kbuf.c                                    |  18 +-
 io_uring/kbuf.h                                    |   4 +-
 io_uring/uring_cmd.c                               |   9 +-
 kernel/cgroup/cgroup.c                             |   1 +
 kernel/events/uprobes.c                            |  10 +-
 kernel/fork.c                                      |   2 +-
 kernel/irq/Kconfig                                 |   6 +
 kernel/irq/Makefile                                |   2 +-
 kernel/irq/kexec.c                                 |  40 ++++
 kernel/kprobes.c                                   |  51 ++--
 kernel/sched/ext.c                                 |  89 +++++--
 kernel/sched/fair.c                                |  84 ++++---
 kernel/sched/idle.c                                |  39 ++-
 kernel/time/time.c                                 |   2 +-
 kernel/trace/ring_buffer.c                         |   2 +-
 kernel/trace/trace.c                               |  12 +-
 kernel/trace/trace_events.c                        |  58 +++--
 kernel/trace/trace_functions_graph.c               |   6 +-
 kernel/workqueue.c                                 |   2 +-
 lib/bootconfig.c                                   |   9 +-
 mm/compaction.c                                    |   2 +
 mm/internal.h                                      |   3 +-
 mm/kfence/core.c                                   |  29 ++-
 mm/page_alloc.c                                    |  59 ++++-
 mm/shmem.c                                         |  97 ++++++--
 net/batman-adv/bat_iv_ogm.c                        |   3 +
 net/batman-adv/bat_v_elp.c                         |  10 +-
 net/batman-adv/hard-interface.c                    |   8 +-
 net/batman-adv/hard-interface.h                    |   1 +
 net/bluetooth/hci_conn.c                           |   4 +-
 net/bluetooth/hci_sync.c                           |   2 +-
 net/bluetooth/hidp/core.c                          |  16 +-
 net/bluetooth/l2cap_core.c                         |  51 ++--
 net/bluetooth/mgmt.c                               |   7 +-
 net/bluetooth/smp.c                                |   2 +-
 net/bridge/br_cfm.c                                |   4 +-
 net/ceph/auth.c                                    |   6 +-
 net/ceph/messenger_v2.c                            |  31 ++-
 net/ceph/mon_client.c                              |   6 +-
 net/core/dev.c                                     |  98 +++++++-
 net/core/dev.h                                     |  35 ---
 net/core/dst.c                                     |   1 +
 net/core/xdp.c                                     |  56 +++++
 net/dsa/dsa.c                                      |  59 +++--
 net/ethernet/eth.c                                 |   9 +-
 net/ipv4/Kconfig                                   |   1 +
 net/ipv4/icmp.c                                    |   4 +-
 net/ipv4/ip_gre.c                                  |   3 +-
 net/ipv4/ip_tunnel_core.c                          |  15 ++
 net/ipv4/nexthop.c                                 |  14 +-
 net/ipv4/route.c                                   |   4 +-
 net/ipv4/tcp.c                                     |   3 +-
 net/ipv4/tcp_ao.c                                  |   3 +-
 net/ipv4/tcp_ipv4.c                                |   3 +-
 net/ipv6/ip6_output.c                              |  35 +--
 net/ipv6/route.c                                   |   4 +-
 net/ipv6/tcp_ipv6.c                                |   3 +-
 net/mac80211/chan.c                                |   6 +-
 net/mac80211/debugfs.c                             |  14 +-
 net/mac80211/link.c                                |   2 +
 net/mac80211/mesh.c                                |   3 +
 net/mac802154/iface.c                              |   4 +-
 net/mctp/route.c                                   |  13 +-
 net/mpls/af_mpls.c                                 |   1 +
 net/mptcp/pm.c                                     |   2 +-
 net/mptcp/pm_netlink.c                             |  72 ++++--
 net/mptcp/protocol.h                               |   2 +
 net/ncsi/ncsi-aen.c                                |   3 +-
 net/ncsi/ncsi-rsp.c                                |  16 +-
 net/netfilter/nf_bpf_link.c                        |   2 +-
 net/netfilter/nf_conntrack_h323_asn1.c             |   4 +
 net/netfilter/nf_conntrack_netlink.c               |  67 ++++--
 net/netfilter/nf_conntrack_sip.c                   |   6 +-
 net/netfilter/nf_tables_api.c                      |   7 +-
 net/netfilter/nfnetlink_cthelper.c                 |   8 +-
 net/netfilter/nfnetlink_osf.c                      |  13 +
 net/netfilter/nfnetlink_queue.c                    |   4 +-
 net/netfilter/nft_ct.c                             |   4 +
 net/netfilter/nft_dynset.c                         |  10 +-
 net/netfilter/nft_set_pipapo.c                     |   3 +-
 net/netfilter/xt_CT.c                              |   4 +
 net/netfilter/xt_IDLETIMER.c                       |   6 +
 net/netfilter/xt_dccp.c                            |   4 +-
 net/netfilter/xt_tcpudp.c                          |   6 +-
 net/netfilter/xt_time.c                            |   4 +-
 net/phonet/af_phonet.c                             |   5 +-
 net/rose/af_rose.c                                 |   5 +
 net/rxrpc/recvmsg.c                                |  19 +-
 net/sched/act_gate.c                               | 264 +++++++++++++++------
 net/sched/sch_generic.c                            |  27 ---
 net/sched/sch_ingress.c                            |  14 +-
 net/sched/sch_teql.c                               |   8 +-
 net/smc/af_smc.c                                   |  23 +-
 net/smc/smc.h                                      |   5 +
 net/smc/smc_close.c                                |   2 +-
 net/sunrpc/cache.c                                 |  26 +-
 net/sunrpc/xprtrdma/verbs.c                        |   7 +-
 net/tipc/socket.c                                  |   2 +
 net/wireless/pmsr.c                                |   1 +
 sound/core/pcm_native.c                            |  19 +-
 sound/pci/hda/patch_realtek.c                      |  25 ++
 sound/soc/amd/acp3x-rt5682-max9836.c               |   9 +-
 sound/soc/amd/yc/acp6x-mach.c                      |  14 ++
 sound/soc/codecs/cs42l43-jack.c                    |   1 +
 sound/soc/generic/simple-card-utils.c              |  48 ++--
 sound/soc/qcom/qdsp6/q6apm-dai.c                   |   1 +
 sound/soc/qcom/qdsp6/q6apm-lpass-dais.c            |   1 +
 sound/soc/qcom/qdsp6/q6apm.c                       |   1 +
 sound/soc/soc-core.c                               |  11 +-
 sound/usb/endpoint.c                               |   1 +
 sound/usb/mixer_scarlett2.c                        |   2 +
 sound/usb/quirks.c                                 |   2 +
 tools/bootconfig/main.c                            |   7 +-
 tools/objtool/Makefile                             |   8 +-
 tools/perf/builtin-ftrace.c                        |   9 +-
 tools/perf/util/annotate.c                         |   5 +-
 tools/perf/util/disasm.c                           |   2 +-
 .../testing/selftests/hid/progs/hid_bpf_helpers.h  |  12 +
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  43 ++++
 500 files changed, 5178 insertions(+), 2252 deletions(-)


