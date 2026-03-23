Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9017DC145;
	Mon, 23 Mar 2026 14:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274571; cv=none; b=b/ipppsvpVKFk7gRZH8YQvO6ZdaoEA+TJfeSPqtEQka2jaq8/FCDpsPMhWXuH7YxX0YBbt8LeBMaH7AJdves5Bu38Gv0FQD69dFwC6PIRaHqG8hyhfXzwsn34IFWJtTcLdm0qQNPn8rHoG1jM/Eby65LQPubc+FjAl0FezTLNBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274571; c=relaxed/simple;
	bh=fsgWJ/05vLQ0AlUrlVpTxuOh4RlD8C9C7WqBXj6cj6k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=o+OkAcHQCJXkmA0wmV6wi4sHYi8ZiaUXS3MjePJ4BWQ9Ua6GSuAcMwfNc3Fshwi9M6m+3+VootJHrvf+KMGtBWHkoh9hWoFIxwOHWgxohytXdkzSiMkYUfDMNN413/+JEmQx4jIA5UcdLLM2Qf4R7rxVBWxYy8Bn1Pn1z8oyptk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aEto36c9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aEto36c9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A980DC2BCB3;
	Mon, 23 Mar 2026 14:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274571;
	bh=fsgWJ/05vLQ0AlUrlVpTxuOh4RlD8C9C7WqBXj6cj6k=;
	h=From:To:Cc:Subject:Date:From;
	b=aEto36c9wkgfN4X9J/0V83l4avgnJ17Gca62PTGpPxPiidWsuFShZUlzMdvN3KtzU
	 SzSTR9+KYFO+ArCJHIdDcbFjxTfT+CohVRqHQOocz8zBjqRkPOLClNPKRtsPVONiMC
	 9yxMI3k7WxRiUdv8hfEZRv0QbsZzdgMEnVRhWe6c=
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
Subject: [PATCH 6.18 000/212] 6.18.20-rc1 review
Date: Mon, 23 Mar 2026 14:43:41 +0100
Message-ID: <20260323134503.770111826@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.20-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.20-rc1
X-KernelTest-Deadline: 2026-03-25T13:45+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.20 release.
There are 212 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.20-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.20-rc1

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max6639) Fix pulses-per-revolution implementation

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: realm: Fix PTE_NS_SHARED for 52bit PA support

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

Jonas Karlman <jonas@kwiboo.se>
    drm/bridge: dw-hdmi-qp: fix multi-channel audio output

Andy Nguyen <theofficialflow1996@gmail.com>
    drm/amd: fix dcn 2.01 check

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix DisplayID not-found handling in parse_edid_displayid_vrr()

Lizhi Hou <lizhi.hou@amd.com>
    iommu/sva: Fix crash in iommu_sva_unbind_device()

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Don't overwrite KMS surface dirty tracker

Felix Gu <ustc.gu@gmail.com>
    spi: amlogic-spisg: Fix memory leak in aml_spisg_probe()

Felix Gu <ustc.gu@gmail.com>
    spi: amlogic: spifc-a4: Remove redundant clock cleanup

Kamal Dasu <kamal.dasu@broadcom.com>
    mtd: rawnand: brcmnand: skip DMA during panic write

Kamal Dasu <kamal.dasu@broadcom.com>
    mtd: rawnand: serialize lock/unlock against other NAND operations

Andrei Vagin <avagin@google.com>
    binfmt_elf_fdpic: fix AUXV size calculation for ELF_HWCAP3 and ELF_HWCAP4

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix trace_marker copy link list updates

Kyle Meyer <kyle.meyer@hpe.com>
    x86/platform/uv: Handle deconfigured sockets

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix failure to read user space from system call trace events

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    ring-buffer: Fix to update per-subbuf entries of persistent ring buffer

Breno Leitao <leitao@debian.org>
    perf/x86: Move event pointer setup earlier in x86_pmu_enable()

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Add missing branch counters constraint apply

Felix Gu <ustc.gu@gmail.com>
    irqchip/riscv-rpmi-sysmsi: Fix mailbox channel leak in rpmi_sysmsi_probe()

Gabor Juhos <j4g8y7@gmail.com>
    i2c: pxa: defer reset on Armada 3700 when recovery is used

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: fsi: Fix a potential leak in fsi_i2c_probe()

Johan Hovold <johan@kernel.org>
    i2c: cp2615: fix serial string NULL-deref at probe

Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
    USB: serial: f81232: fix incomplete serial port generation

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pmbus/isl68137) Fix unchecked return value and use sysfs_emit()

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pmbus/mp2869) Check pmbus_read_byte_data() before using its return value

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pmbus/mp2975) Add error check for pmbus_read_word_data() return value

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pmbus/ina233) Add error check for pmbus_read_word_data() return value

Li Xiasong <lixiasong1@huawei.com>
    MPTCP: fix lock class name family in pm_nl_create_listen_socket

Weiming Shi <bestswngs@gmail.com>
    icmp: fix NULL pointer dereference in icmp_tag_validation()

Anas Iqbal <mohd.abd.6602@gmail.com>
    net: dsa: bcm_sf2: fix missing clk_disable_unprepare() in error paths

Jakub Kicinski <kuba@kernel.org>
    net: shaper: protect from late creation of hierarchy

Jakub Kicinski <kuba@kernel.org>
    net: shaper: protect late read accesses to the hierarchy

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

Wesley Atwell <atwellwea@gmail.com>
    netdevsim: drop PSP ext ref on forward failure

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: processor: Fix previous acpi_processor_errata_piix4() fix

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: always free skb on ieee80211_tx_prepare_skb() failure

Guenter Roeck <linux@roeck-us.net>
    wifi: wlcore: Return -ENOMEM instead of -EAGAIN if there is not enough headroom

Xiang Mei <xmei5@asu.edu>
    wifi: mac80211: fix NULL deref in mesh_matches_local()

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    libie: prevent memleak in fwlog code

Petr Oros <poros@redhat.com>
    iavf: fix VLAN filter lost on add/delete race

Zdenek Bouska <zdenek.bouska@siemens.com>
    igc: fix page fault in XDP TX timestamps handling

Kohei Enju <kohei@enjuk.jp>
    igc: fix missing update of skb->tail in igc_xmit_frame()

Saket Dumbre <saket.dumbre@intel.com>
    ACPICA: Update the format of Arg3 of _DSM

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

Guenter Roeck <linux@roeck-us.net>
    crypto: ccp - Fix leaking the same page twice

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

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix NULL dereference on notify error path

Felix Gu <ustc.gu@gmail.com>
    firmware: arm_scpi: Fix device_node reference leak in probe path

Yeoreum Yun <yeoreum.yun@arm.com>
    firmware: arm_ffa: Remove vm_id argument in ffa_rxtx_unmap()

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    arm64: dts: renesas: rzg3s-smarc-som: Set bypass for Versa3 PLL2

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    arm64: dts: renesas: r9a09g087: Fix CPG register region sizes

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    arm64: dts: renesas: r9a09g077: Fix CPG register region sizes

Fabrizio Castro <fabrizio.castro.jz@renesas.com>
    arm64: dts: renesas: r9a09g057: Remove wdt{0,2,3} nodes

Ovidiu Panait <ovidiu.panait.rb@renesas.com>
    arm64: dts: renesas: r9a09g057: Add RTC node

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    arm64: dts: renesas: rzv2-evk-cn15-sd: Add ramp delay for SD0 regulator

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    arm64: dts: renesas: rzt2h-n2h-evk: Add ramp delay for SD0 card regulator

Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>
    wifi: cfg80211: cancel pmsr_free_wk in cfg80211_pmsr_wdev_down

Kuniyuki Iwashima <kuniyu@google.com>
    wifi: mac80211: Fix static_branch_dec() underflow for aql_disable.

Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
    wifi: mac80211: use jiffies_delta_to_msecs() for sta_info inactive times

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: remove keys after disabling beaconing

Matthew Wilcox <willy@infradead.org>
    tee: shm: Remove refcounting of kernel pages

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

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Compute PSR entry_setup_frames into intel_crtc_state

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix accepting multiple L2CAP_ECRED_CONN_REQ

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Open-code GGTT MMIO access protection

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/oa: Allow reading after disabling OA stream

Zhanjun Dong <zhanjun.dong@intel.com>
    drm/xe/guc: Ensure CT state transitions via STOP before DISABLED

Imre Deak <imre.deak@intel.com>
    drm/i915/dmc: Fix an unlikely NULL pointer deference at probe

Jesse.Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: Limit BO list entry count to prevent resource exhaustion

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: apply state adjust rules to some additional HAINAN vairants

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: apply state adjust rules to some additional HAINAN vairants

Alessio Belle <alessio.belle@imgtec.com>
    drm/imagination: Synchronize interrupts before suspending the GPU

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

Maciej Andrzejewski ICEYE <maciej.andrzejewski@m-works.net>
    serial: uartlite: fix PM runtime usage count underflow on probe

Jiayuan Chen <jiayuan.chen@shopee.com>
    serial: core: fix infinite loop in handle_tx() for PORT_UNKNOWN

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_dw: Ensure BUSY is deasserted

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Add late synchronize_irq() to shutdown to handle DW UART BUSY

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_dw: Rework IIR_NO_INT handling to stop interrupt storm

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_dw: Rework dw8250_handle_irq() locking and IIR handling

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Add serial8250_handle_irq_locked()

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_dw: Avoid unnecessary LCR writes

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Protect LCR write in shutdown

Peng Zhang <zhangpeng.00@bytedance.com>
    serial: 8250: always disable IRQ during THRE test

Raul E Rangel <rrangel@chromium.org>
    serial: 8250: Fix TX deadlock when using DMA

Martin Roukala (né Peres) <martin.roukala@mupuf.org>
    serial: 8250_pci: add support for the AX99100

Nicolas Pitre <npitre@baylibre.com>
    vt: save/restore unicode screen buffer for alternate screen

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: propagate BUF_MORE through early buffer commit path

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: fix missing BUF_MORE for incremental buffers at EOF

Jens Axboe <axboe@kernel.dk>
    io_uring/poll: fix multishot recv missing EOF on wakeup race

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Only handle IOPF for SVA when PRI is supported

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
    ata: libata-scsi: report correct sense field pointer in ata_scsiop_maint_in()

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-core: disable LPM on ADATA SU680 SSD

Zi Yan <ziy@nvidia.com>
    mm/huge_memory: fix a folio_split() race condition with folio_try_get()

Corey Minyard <corey@minyard.net>
    ipmi:msghandler: Handle error returns from the SMI sender

Corey Minyard <corey@minyard.net>
    ipmi: Consolidate the run to completion checking for xmit msgs lock

Tejun Heo <tj@kernel.org>
    sched_ext: Disable preemption between scx_claim_exit() and kicking helper work

Tejun Heo <tj@kernel.org>
    sched_ext: Simplify breather mechanism with scx_aborting flag

Tejun Heo <tj@kernel.org>
    sched_ext: Fix starvation of scx_enable() under fair-class saturation

Christian Brauner <brauner@kernel.org>
    nsfs: tighten permission checks for ns iteration ioctls

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/sync: Fix user fence leak on alloc failure

Shengming Hu <hu.shengming@zte.com.cn>
    fgraph: Fix thresh_return nosleeptime double-adjust

Thorsten Blum <thorsten.blum@linux.dev>
    ksmbd: Don't log keys in SMB3 signing and encryption key generation

Kevin Hao <haokexin@gmail.com>
    net: macb: Shuffle the tx ring before enabling tx

Théo Lebrun <theo.lebrun@bootlin.com>
    net: macb: sort #includes

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/vrr: Configure VRR timings after enabling TRANS_DDI_FUNC_CTL

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/vrr: Move HAS_VRR() check into intel_vrr_set_transcoder_timings()

Varun Gupta <varun.gupta@intel.com>
    drm/xe: Fix memory leak in xe_vm_madvise_ioctl

Shyam Prasad N <sprasad@microsoft.com>
    cifs: open files should not hold ref on superblock

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-sha204a - Fix OOM ->tfm_count leak

Breno Leitao <leitao@debian.org>
    netconsole: fix sysdata_release_enabled_show checking wrong flag

Mehul Rao <mehulrao@gmail.com>
    ublk: fix NULL pointer dereference in ublk_ctrl_set_size()

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Check return values for set_memory_{rw,rox}

Kevin Hao <haokexin@gmail.com>
    net: macb: Reinitialize tx/rx queue pointer registers and rx ring during resume

Kevin Hao <haokexin@gmail.com>
    net: macb: Introduce gem_init_rx_ring()

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

AlanSong-oc <AlanSong-oc@zhaoxin.com>
    crypto: padlock-sha - Disable for Zhaoxin processor

Felix Fietkau <nbd@nbd.name>
    mac80211: fix crash in ieee80211_chan_bw_change for AP_VLAN stations

Yang Yang <n05ec@lzu.edu.cn>
    batman-adv: avoid OGM aggregation when skb tailroom is insufficient

Helge Deller <deller@gmx.de>
    parisc: Flush correct cache in cacheflush() syscall

Junrui Luo <moonafterrain@outlook.com>
    bnxt_en: fix OOB access in DBG_BUF_PRODUCER async event handler

Fedor Pchelkin <pchelkin@ispras.ru>
    net: macb: fix use-after-free access to PTP clock

Ian Ray <ian.ray@gehealthcare.com>
    NFC: nxp-nci: allow GPIOs to sleep

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: No need to flush icache if text copy failed

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Give more information if kmem access failed

Wei Yang <richard.weiyang@gmail.com>
    mm/huge_memory: fix early failure try_to_migrate() when split huge pmd for shared THP

Chris Down <chris@chrisdown.name>
    mm/huge_memory: fix use of NULL folio in move_pages_huge_pmd()

Dev Jain <dev.jain@arm.com>
    mm/rmap: fix incorrect pte restoration for lazyfree folios

Thorsten Blum <thorsten.blum@linux.dev>
    crash_dump: don't log dm-crypt key bytes in read_key_from_user_keying

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

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Defer sub-object cleanup in export put callbacks


-------------

Diffstat:

 Documentation/netlink/specs/net_shaper.yaml        |  12 +-
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/renesas/r9a09g057.dtsi         |  37 +--
 arch/arm64/boot/dts/renesas/r9a09g077.dtsi         |   4 +-
 arch/arm64/boot/dts/renesas/r9a09g087.dtsi         |   4 +-
 arch/arm64/boot/dts/renesas/rzg3s-smarc-som.dtsi   |   2 +-
 .../boot/dts/renesas/rzt2h-n2h-evk-common.dtsi     |   1 +
 arch/arm64/boot/dts/renesas/rzv2-evk-cn15-sd.dtso  |   1 +
 arch/arm64/kernel/rsi.c                            |   3 +-
 arch/loongarch/include/asm/uaccess.h               |  14 +-
 arch/loongarch/kernel/inst.c                       |  21 +-
 arch/parisc/kernel/cache.c                         |   4 +-
 arch/x86/events/core.c                             |   3 +-
 arch/x86/events/intel/core.c                       |  31 ++-
 arch/x86/kernel/apic/x2apic_uv_x.c                 |  18 +-
 drivers/acpi/acpi_processor.c                      |  15 +-
 drivers/acpi/acpica/acpredef.h                     |   2 +-
 drivers/ata/libata-core.c                          |   3 +
 drivers/ata/libata-scsi.c                          |   2 +-
 drivers/base/power/runtime.c                       |   1 +
 drivers/block/ublk_drv.c                           |  12 +-
 drivers/bluetooth/btqca.c                          |   2 +
 drivers/cache/ax45mp_cache.c                       |   4 +-
 drivers/cache/starfive_starlink_cache.c            |   4 +-
 drivers/char/ipmi/ipmi_msghandler.c                | 144 ++++++----
 drivers/crypto/atmel-sha204a.c                     |   5 +-
 drivers/crypto/ccp/sev-dev.c                       |   4 +-
 drivers/crypto/padlock-sha.c                       |   7 +
 drivers/firewire/net.c                             |   5 +-
 drivers/firmware/arm_ffa/driver.c                  |   8 +-
 drivers/firmware/arm_scmi/notify.c                 |   4 +-
 drivers/firmware/arm_scpi.c                        |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c        |   4 +
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |  21 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c            |   9 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c          |   3 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_2.c          |   3 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v4_1_0.c          |   3 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   4 +-
 drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c   |   8 +-
 .../amd/display/dc/resource/dcn32/dcn32_resource.c |   3 +
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |   4 +-
 drivers/gpu/drm/bridge/synopsys/dw-hdmi-qp.c       |   2 +-
 drivers/gpu/drm/drm_file.c                         |   5 +-
 drivers/gpu/drm/drm_mode_config.c                  |   9 +-
 drivers/gpu/drm/i915/display/intel_display.c       |   2 -
 .../drm/i915/display/intel_display_power_well.c    |   2 +-
 drivers/gpu/drm/i915/display/intel_display_types.h |   1 +
 drivers/gpu/drm/i915/display/intel_dmc.c           |   3 +-
 drivers/gpu/drm/i915/display/intel_psr.c           |  16 +-
 drivers/gpu/drm/i915/display/intel_vdsc.c          |  23 ++
 drivers/gpu/drm/i915/display/intel_vdsc.h          |   3 +
 drivers/gpu/drm/i915/display/intel_vdsc_regs.h     |  12 +
 drivers/gpu/drm/i915/display/intel_vrr.c           |  17 ++
 drivers/gpu/drm/i915/gt/intel_engine_cs.c          |   3 +-
 drivers/gpu/drm/imagination/pvr_device.c           |  17 --
 drivers/gpu/drm/imagination/pvr_power.c            |  22 +-
 drivers/gpu/drm/radeon/si_dpm.c                    |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   3 +-
 drivers/gpu/drm/xe/xe_ggtt.c                       |  10 +-
 drivers/gpu/drm/xe/xe_ggtt_types.h                 |   5 +-
 drivers/gpu/drm/xe/xe_guc_ct.c                     |   1 +
 drivers/gpu/drm/xe/xe_oa.c                         |   7 +-
 drivers/gpu/drm/xe/xe_sync.c                       |   6 +-
 drivers/gpu/drm/xe/xe_vm_madvise.c                 |   3 +-
 drivers/hid/bpf/hid_bpf_dispatch.c                 |   2 +
 drivers/hwmon/max6639.c                            |  10 +-
 drivers/hwmon/pmbus/ina233.c                       |   2 +
 drivers/hwmon/pmbus/isl68137.c                     |   7 +-
 drivers/hwmon/pmbus/mp2869.c                       |  35 ++-
 drivers/hwmon/pmbus/mp2975.c                       |   2 +
 drivers/i2c/busses/i2c-cp2615.c                    |   3 +
 drivers/i2c/busses/i2c-fsi.c                       |   1 +
 drivers/i2c/busses/i2c-pxa.c                       |  17 +-
 drivers/iommu/intel/dmar.c                         |   3 +-
 drivers/iommu/intel/svm.c                          |  12 +-
 drivers/iommu/iommu-sva.c                          |  12 +-
 drivers/irqchip/irq-riscv-rpmi-sysmsi.c            |   1 +
 drivers/mmc/host/sdhci-pci-gli.c                   |   9 +
 drivers/mmc/host/sdhci.c                           |   9 +-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |   6 +-
 drivers/mtd/nand/raw/cadence-nand-controller.c     |   2 +-
 drivers/mtd/nand/raw/nand_base.c                   |  14 +-
 drivers/mtd/nand/raw/pl35x-nand-controller.c       |   3 +
 drivers/mtd/parsers/redboot.c                      |   6 +-
 drivers/net/bonding/bond_debugfs.c                 |  16 +-
 drivers/net/bonding/bond_main.c                    |   8 +-
 drivers/net/dsa/bcm_sf2.c                          |   8 +-
 drivers/net/ethernet/airoha/airoha_eth.c           |   1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |   2 +-
 drivers/net/ethernet/cadence/macb_main.c           | 161 +++++++++--
 drivers/net/ethernet/cadence/macb_ptp.c            |   4 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   9 +-
 drivers/net/ethernet/intel/igc/igc.h               |   2 +
 drivers/net/ethernet/intel/igc/igc_main.c          |  14 +-
 drivers/net/ethernet/intel/igc/igc_ptp.c           |  33 +++
 drivers/net/ethernet/intel/libie/fwlog.c           |  49 +++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   4 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |   1 +
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c    |  52 ++--
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |  23 +-
 drivers/net/ethernet/microsoft/mana/hw_channel.c   |   6 +-
 drivers/net/netconsole.c                           |   2 +-
 drivers/net/netdevsim/netdev.c                     |   5 +-
 drivers/net/usb/aqc111.c                           |  12 +-
 drivers/net/usb/cdc_ncm.c                          |  10 +-
 drivers/net/wireless/ath/ath9k/channel.c           |   6 +-
 drivers/net/wireless/mediatek/mt76/scan.c          |   4 +-
 drivers/net/wireless/ti/wlcore/tx.c                |   2 +-
 drivers/net/wireless/virtual/mac80211_hwsim.c      |   1 -
 drivers/nfc/nxp-nci/i2c.c                          |   4 +-
 drivers/nvdimm/bus.c                               |   5 +-
 drivers/pmdomain/bcm/bcm2835-power.c               |  12 +-
 drivers/soc/fsl/qbman/qman.c                       |  24 +-
 drivers/soc/fsl/qe/qmc.c                           |   4 +-
 drivers/soc/microchip/mpfs-sys-controller.c        |  13 +-
 drivers/soc/rockchip/grf.c                         |   1 +
 drivers/spi/spi-amlogic-spifc-a4.c                 |  46 +---
 drivers/spi/spi-amlogic-spisg.c                    |  12 +-
 drivers/spi/spi.c                                  |  25 +-
 drivers/tee/tee_shm.c                              |  27 --
 drivers/tty/serial/8250/8250.h                     |  25 ++
 drivers/tty/serial/8250/8250_dma.c                 |  15 +
 drivers/tty/serial/8250/8250_dw.c                  | 304 ++++++++++++++++-----
 drivers/tty/serial/8250/8250_pci.c                 |  17 ++
 drivers/tty/serial/8250/8250_port.c                |  75 +++--
 drivers/tty/serial/serial_core.c                   |   5 +-
 drivers/tty/serial/uartlite.c                      |   1 +
 drivers/tty/vt/vt.c                                |   8 +
 drivers/usb/serial/f81232.c                        |  77 ++++--
 fs/binfmt_elf_fdpic.c                              |   6 +
 fs/btrfs/tree-checker.c                            |   2 +-
 fs/btrfs/tree-log.c                                |   6 +
 fs/nfsd/export.c                                   |  63 ++++-
 fs/nfsd/export.h                                   |   7 +-
 fs/nfsd/nfs4xdr.c                                  |   9 +-
 fs/nfsd/nfsctl.c                                   |  22 +-
 fs/nfsd/state.h                                    |  17 +-
 fs/nsfs.c                                          |  13 +
 fs/smb/client/cifsfs.c                             |   7 +-
 fs/smb/client/cifsproto.h                          |   1 +
 fs/smb/client/connect.c                            |   4 +
 fs/smb/client/file.c                               |  11 -
 fs/smb/client/misc.c                               |  42 +++
 fs/smb/client/trace.h                              |   2 +
 fs/smb/server/auth.c                               |  22 +-
 fs/smb/server/smb2pdu.c                            |  17 +-
 fs/tests/exec_kunit.c                              |   3 -
 include/linux/auxvec.h                             |   2 +-
 include/linux/console_struct.h                     |   1 +
 include/linux/etherdevice.h                        |   3 +-
 include/linux/if_ether.h                           |   3 +-
 include/linux/io_uring_types.h                     |   3 +
 include/linux/netdevice.h                          |   6 +-
 include/linux/ns_common.h                          |   2 +
 include/linux/serial_8250.h                        |   1 +
 include/net/mac80211.h                             |   4 +-
 include/net/netfilter/nf_tables.h                  |   2 +
 include/net/sch_generic.h                          |  33 +++
 include/net/udp_tunnel.h                           |   2 +-
 io_uring/kbuf.c                                    |  14 +-
 io_uring/poll.c                                    |   9 +-
 kernel/crash_dump_dm_crypt.c                       |   4 +-
 kernel/nscommon.c                                  |   6 +
 kernel/sched/ext.c                                 | 132 ++++++---
 kernel/sched/idle.c                                |  30 +-
 kernel/trace/ring_buffer.c                         |   2 +-
 kernel/trace/trace.c                               |  36 ++-
 kernel/trace/trace_functions_graph.c               |  15 +-
 lib/bootconfig.c                                   |   3 +-
 mm/huge_memory.c                                   |  12 +-
 mm/rmap.c                                          |  21 +-
 net/batman-adv/bat_iv_ogm.c                        |   3 +
 net/bluetooth/hci_conn.c                           |   4 +-
 net/bluetooth/hci_sync.c                           |   2 +-
 net/bluetooth/hidp/core.c                          |  16 +-
 net/bluetooth/l2cap_core.c                         |  51 ++--
 net/bluetooth/mgmt.c                               |   7 +-
 net/bluetooth/smp.c                                |   2 +-
 net/bridge/br_cfm.c                                |   4 +-
 net/ethernet/eth.c                                 |   9 +-
 net/ipv4/icmp.c                                    |   4 +-
 net/ipv4/ip_gre.c                                  |   3 +-
 net/mac80211/cfg.c                                 |  12 +-
 net/mac80211/chan.c                                |   6 +-
 net/mac80211/debugfs.c                             |  14 +-
 net/mac80211/mesh.c                                |   3 +
 net/mac80211/sta_info.c                            |   7 +-
 net/mac80211/tx.c                                  |   4 +-
 net/mac802154/iface.c                              |   4 +-
 net/mpls/af_mpls.c                                 |   1 +
 net/mptcp/pm_kernel.c                              |   2 +-
 net/netfilter/nf_bpf_link.c                        |   2 +-
 net/netfilter/nf_conntrack_h323_asn1.c             |   4 +
 net/netfilter/nf_conntrack_netlink.c               |  26 +-
 net/netfilter/nf_conntrack_sip.c                   |   6 +-
 net/netfilter/nf_tables_api.c                      |   5 +-
 net/netfilter/nfnetlink_osf.c                      |  13 +
 net/netfilter/nft_ct.c                             |   4 +
 net/netfilter/nft_dynset.c                         |  10 +-
 net/netfilter/xt_CT.c                              |   4 +
 net/netfilter/xt_time.c                            |   4 +-
 net/phonet/af_phonet.c                             |   5 +-
 net/rose/af_rose.c                                 |   5 +
 net/sched/sch_generic.c                            |  27 --
 net/sched/sch_ingress.c                            |  14 +-
 net/sched/sch_teql.c                               |   7 +-
 net/shaper/shaper.c                                | 160 ++++++-----
 net/shaper/shaper_nl_gen.c                         |  12 +-
 net/shaper/shaper_nl_gen.h                         |   5 +
 net/smc/af_smc.c                                   |  23 +-
 net/smc/smc.h                                      |   5 +
 net/smc/smc_close.c                                |   2 +-
 net/sunrpc/cache.c                                 |  26 +-
 net/wireless/pmsr.c                                |   1 +
 tools/bootconfig/main.c                            |   7 +-
 .../testing/selftests/hid/progs/hid_bpf_helpers.h  |  12 +
 221 files changed, 2109 insertions(+), 963 deletions(-)


