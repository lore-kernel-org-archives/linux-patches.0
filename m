Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5892F9982;
	Tue, 26 Aug 2025 11:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756206778; cv=none; b=TbmthEMfpq8C7WE8HKYdTj2RMLRM9EhW3JBQLitx27Ry8qOcP9zPf268LPwG7gDXjPhozQgU0kRxy+urMknocxyxEBhLZj3MDplftZsZZuypjtYq4Z68uEn+S4JI2cwpTDdKfVfsASf1EhbOVKrRTFsH5e2kXjieA+RQRB1zh/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756206778; c=relaxed/simple;
	bh=BoFxyUFw/lgTyCwkNTc5AOiM29z+ISjKl+1b40t+Qmc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BjutxplhJZAxjIqtZEtcXqwblMXDMztO5SRFq/fFYMZNVAyxu3XAgXtFf8ddoRN0pboGHQG8KZH3gG0RUSVufqaFaOWtNXJRJtGGSPOAMdD3mh3rXN39n9Tfpd7zqfFLG1UC9v7uAeQ9xjUqZw9AQ+4JucRtCrIPXndPsIEloKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ibGI0Ta9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ibGI0Ta9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8EDC4CEF4;
	Tue, 26 Aug 2025 11:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756206778;
	bh=BoFxyUFw/lgTyCwkNTc5AOiM29z+ISjKl+1b40t+Qmc=;
	h=From:To:Cc:Subject:Date:From;
	b=ibGI0Ta96LbpaUml36crfxNljbNOu4RqI2bS9yUzivKxlZ/V+S9pZWqH/Vf2oANS8
	 gMtpbLo8vprvZH36fQ/qCRwJ+91kPH3WB0ERTKsKl7pTWmE9oP+g5qZZt5DqnLYBb0
	 J8BjYly7V286QBMMZO8aobrh6fbBTcgo95EaLQKo=
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
Subject: [PATCH 6.6 000/587] 6.6.103-rc1 review
Date: Tue, 26 Aug 2025 13:02:29 +0200
Message-ID: <20250826110952.942403671@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.103-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.103-rc1
X-KernelTest-Deadline: 2025-08-28T11:10+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.103 release.
There are 587 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 28 Aug 2025 11:08:24 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.103-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.103-rc1

Florian Westphal <fw@strlen.de>
    netfilter: nf_reject: don't leak dst refcount for loopback packets

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/hypfs: Enable limited access during lockdown

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/hypfs: Avoid unnecessary ioctl registration in debugfs

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Use correct sub-type for UAC3 feature unit validation

Armen Ratner <armeng@nvidia.com>
    net/mlx5e: Preserve shared buffer capacity during headroom updates

Daniel Jurgens <danielj@nvidia.com>
    net/mlx5: Base ECVF devlink port attrs from 0

Hariprasad Kelam <hkelam@marvell.com>
    Octeontx2-af: Skip overlap check for SPI field

Hangbin Liu <liuhangbin@gmail.com>
    bonding: send LACPDUs periodically in passive mode after receiving partner's LACPDU

Aahil Awatramani <aahila@google.com>
    bonding: Add independent control state machine

Hangbin Liu <liuhangbin@gmail.com>
    bonding: update LACP activity flag after setting lacp_active

William Liu <will@willsroot.io>
    net/sched: Remove unnecessary WARNING condition for empty child qdisc in htb_activate

William Liu <will@willsroot.io>
    net/sched: Make cake_enqueue return NET_XMIT_CN when past buffer_limit

ValdikSS <iam@valdikss.org.ru>
    igc: fix disabling L1.2 PCI-E link substate on I226 on init

Jason Xing <kernelxing@tencent.com>
    ixgbe: xsk: resolve the negative overflow of budget in ixgbe_xmit_zc

Kanglong Wang <wangkanglong@loongson.cn>
    LoongArch: Optimize module load time by optimizing PLT/GOT counting

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix UAF on smcsk after smc_listen_out()

Jordan Rhee <jordanrhee@google.com>
    gve: prevent ethtool ops after shutdown

Yuichiro Tsuji <yuichtsu@amazon.com>
    net: usb: asix_devices: Fix PHY address mask in MDIO bus initialization

Horatiu Vultur <horatiu.vultur@microchip.com>
    phy: mscc: Fix timestamping for vsc8584

Qingfang Deng <dqfext@gmail.com>
    ppp: fix race conditions in ppp_fill_forward_path

Qingfang Deng <dqfext@gmail.com>
    net: ethernet: mtk_ppe: add RCU lock around dev_fill_forward_path

Minhong He <heminhong@kylinos.cn>
    ipv6: sr: validate HMAC algorithm ID in seg6_hmac_info_add

Jakub Ramaseuski <jramaseu@redhat.com>
    net: gso: Forbid IPv6 TSO with extensions on devices with only IPV6_CSUM

Chenyuan Yang <chenyuan0y@gmail.com>
    drm/amd/display: Add null pointer check in mod_hdcp_hdcp1_create_session()

Dan Carpenter <dan.carpenter@linaro.org>
    ALSA: usb-audio: Fix size validation in convert_chmap_v3()

Baihan Li <libaihan@huawei.com>
    drm/hisilicon/hibmc: fix the hibmc loaded failed bug

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum: Forward packets with an IPv4 link-local source IP

Sergey Shtylyov <s.shtylyov@omp.ru>
    Bluetooth: hci_conn: do return error from hci_enhanced_setup_sync()

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_event: fix MTU for BN == 0 in CIS Established

Kees Cook <kees@kernel.org>
    iommu/amd: Avoid stack buffer overflow from kernel cmdline

Dan Carpenter <dan.carpenter@linaro.org>
    scsi: qla4xxx: Prevent a potential error pointer dereference

Wang Liang <wangliang74@huawei.com>
    net: bridge: fix soft lockup in br_multicast_query_expired()

Anantha Prabhu <anantha.prabhu@broadcom.com>
    RDMA/bnxt_re: Fix to initialize the PBL array

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Fix to remove workload check in SRQ limit path

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Fix to do SRQ armena by default

Boshi Yu <boshiyu@linux.alibaba.com>
    RDMA/erdma: Fix ignored return value of init_kernel_qp

Nitin Gote <nitin.r.gote@intel.com>
    iosys-map: Fix undefined behavior in iosys_map_clear()

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Use static_branch_enable_cpuslocked() on cpusets_insane_config_key

Fanhua Li <lifanhua5@huawei.com>
    drm/nouveau/nvif: Fix potential memory leak in nvif_vmm_ctor().

Stefan Wahren <wahrenst@gmx.net>
    spi: spi-fsl-lpspi: Clamp too high speed_hz

Tianxiang Peng <txpeng@tencent.com>
    x86/cpu/hygon: Add missing resctrl_cpu_detect() in bsp_init helper

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: maxim_contaminant: disable low power mode when reading comparator values

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: maxim_contaminant: re-enable cc toggle if cc is open and port is clean

Weitao Wang <WeitaoWang-oc@zhaoxin.com>
    usb: xhci: Fix slot_id resource race conflict

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: change invalid data error to -EBUSY

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: imu: inv_icm42600: Convert to uXX and sXX integer types

David Lechner <dlechner@baylibre.com>
    iio: imu: inv_icm42600: use = { } instead of memset()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: imu: inv_icm42600: switch timestamp type from int64_t __aligned(8) to aligned_s64

David Lechner <dlechner@baylibre.com>
    iio: temperature: maxim_thermocouple: use DMA-safe buffer for spi_read()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: light: as73211: Ensure buffer holes are zeroed

Pu Lehui <pulehui@huawei.com>
    tracing: Limit access to parser->buffer when trace_get_user failed

Steven Rostedt <rostedt@goodmis.org>
    tracing: Remove unneeded goto out logic

Jakub Kicinski <kuba@kernel.org>
    tls: fix handling of zero-length records on the rx_list

Michal Suchanek <msuchanek@suse.de>
    powerpc/boot: Fix build with gcc 15

Victor Shih <victor.shih@genesyslogic.com.tw>
    mmc: sdhci-pci-gli: GL9763e: Mask the replay timer timeout of AER

Jan Beulich <jbeulich@suse.com>
    compiler: remove __ADDRESSABLE_ASM{_STR,}() again

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Don't overclock DCE 6 by 15%

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add support for the Intel Wildcat Lake

Selvarasu Ganesan <selvarasu.g@samsung.com>
    usb: dwc3: Remove WARN_ON for device endpoint command timeouts

Kuen-Han Tsai <khtsai@google.com>
    usb: dwc3: Ignore late xferNotReady event to prevent halt timeout

Zenm Chen <zenmchen@gmail.com>
    USB: storage: Ignore driver CD mode for Realtek multi-mode Wi-Fi dongles

Thorsten Blum <thorsten.blum@linux.dev>
    usb: storage: realtek_cr: Use correct byte order for bcs->Residue

Mael GUERIN <mael.guerin@murena.io>
    USB: storage: Add unusual-devs entry for Novatek NTK96550-based camera

Marek Vasut <marek.vasut+renesas@mailbox.org>
    usb: renesas-xhci: Fix External ROM access timeouts

Xu Yang <xu.yang_2@nxp.com>
    usb: core: hcd: fix accessing unmapped memory in SINGLE_STEP_SET_FEATURE test

Ian Abbott <abbotti@mev.co.uk>
    comedi: Fix use of uninitialized memory in do_insn_ioctl() and do_insnlist_ioctl()

Edward Adam Davis <eadavis@qq.com>
    comedi: pcl726: Prevent invalid irq number

Ian Abbott <abbotti@mev.co.uk>
    comedi: Make insn_rw_emulate_bits() do insn->n samples

Miao Li <limiao@kylinos.cn>
    usb: quirks: Add DELAY_INIT quick for another SanDisk 3.2Gen1 Flash Drive

Thorsten Blum <thorsten.blum@linux.dev>
    cdx: Fix off-by-one error in cdx_rpmsg_probe()

Miaoqian Lin <linmq006@gmail.com>
    most: core: Drop device reference after usage in get_channel()

David Lechner <dlechner@baylibre.com>
    iio: proximity: isl29501: fix buffered read on big-endian systems

Salah Triki <salah.triki@gmail.com>
    iio: pressure: bmp280: Use IS_ERR() in bmp280_common_probe()

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Also allocate and copy hash for reading of filter files

Xu Yilun <yilun.xu@linux.intel.com>
    fpga: zynq_fpga: Fix the wrong usage of dma_map_sgtable()

Imre Deak <imre.deak@intel.com>
    drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: governors: menu: Avoid selecting states with too much latency

Christian Loehle <christian.loehle@arm.com>
    cpuidle: menu: Remove iowait influence

Victor Shih <victor.shih@genesyslogic.com.tw>
    mmc: sdhci-pci-gli: Add a new function to simplify the code

Bjorn Helgaas <bhelgaas@google.com>
    mmc: sdhci-pci-gli: Use PCI AER definitions, not hard-coded values

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: pm: check flush doesn't reset limits

Geliang Tang <tanggeliang@kylinos.cn>
    mptcp: disable add_addr retransmission when timeout is 0

Geliang Tang <tanggeliang@kylinos.cn>
    mptcp: remove duplicate sk_reset_timer call

Al Viro <viro@zeniv.linux.org.uk>
    use uniform permission checks for all mount propagation changes

Ye Bin <yebin10@huawei.com>
    fs/buffer: fix use-after-free when call bh_read() helper

Stefan Metzmacher <metze@samba.org>
    smb: server: split ksmbd_rdma_stop_listening() out of ksmbd_rdma_destroy()

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62-main: Remove eMMC High Speed DDR support

Baokun Li <libaokun1@huawei.com>
    ext4: preserve SB_I_VERSION on remount

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Serialize admin queue BAR writes on 32-bit systems

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Drop unnecessary volatile from __iomem pointers

André Draszik <andre.draszik@linaro.org>
    scsi: ufs: exynos: Fix programming of HCI_UTRL_NEXUS_TYPE

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: imx6: Add IMX8MM_EP and IMX8MP_EP fixed 256-byte BAR 4 in epc_features

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: imx6: Delay link start until configfs 'start' written

Geraldo Nascimento <geraldogabriel@gmail.com>
    PCI: rockchip: Set Target Link Speed to 5.0 GT/s before retraining

Geraldo Nascimento <geraldogabriel@gmail.com>
    PCI: rockchip: Use standard PCIe definitions

Dan Carpenter <dan.carpenter@linaro.org>
    soc: qcom: mdt_loader: Fix error return values in mdt_header_valid()

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fill display clock and vblank time in dce110_fill_display_configs

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Find first CRTC and its line time in dce110_fill_display_configs

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fix DP audio DTO1 clock source on DCE 6.

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fix fractional fb divider in set_pixel_clock_v3

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Avoid a NULL pointer dereference

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/sclp: Fix SCCB present check

Evgeniy Harchenko <evgeniyharchenko.dev@gmail.com>
    ALSA: hda/realtek: Add support for HP EliteBook x360 830 G6 and EliteBook 830 G6

Jinjiang Tu <tujinjiang@huawei.com>
    mm/memory-failure: fix infinite UCE for VM_PFNMAP pfn

Herton R. Krzesinski <herton@redhat.com>
    mm/debug_vm_pgtable: clear page table entries at destroy_args()

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: fix memory leak in squashfs_fill_super

Victor Shih <victor.shih@genesyslogic.com.tw>
    mmc: sdhci-pci-gli: GL9763e: Rename the gli_set_gl9763e() for consistency

Jiayi Li <lijiayi@kylinos.cn>
    memstick: Fix deadlock by moving removing flag earlier

Will Deacon <will@kernel.org>
    KVM: arm64: Fix kernel BUG() due to bad backport of FPSIMD/SVE/SME fix

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Fix frequency selection for non-invariant case

Vincent Guittot <vincent.guittot@linaro.org>
    topology: Set capacity_freq_ref in all cases

Vincent Guittot <vincent.guittot@linaro.org>
    arm64/amu: Use capacity_ref_freq() to set AMU ratio

Vincent Guittot <vincent.guittot@linaro.org>
    cpufreq/cppc: Set the frequency used for computing the capacity

Vincent Guittot <vincent.guittot@linaro.org>
    energy_model: Use a fixed reference frequency

Vincent Guittot <vincent.guittot@linaro.org>
    cpufreq/schedutil: Use a fixed reference frequency

Vincent Guittot <vincent.guittot@linaro.org>
    cpufreq: Use the fixed and coherent frequency for scaling capacity

Vincent Guittot <vincent.guittot@linaro.org>
    sched/topology: Add a new arch_scale_freq_ref() method

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    kbuild: userprogs: use correct linker when mixing clang and GNU ld

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: Return aborted command when missing sense and result TF

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Take active children into account in pm_runtime_get_if_in_use()

Sakari Ailus <sakari.ailus@linux.intel.com>
    PM: runtime: Simplify pm_runtime_get_if_active() usage

Damien Le Moal <dlemoal@kernel.org>
    ata: Fix SATA_MOBILE_LPM_POLICY description in Kconfig

Johan Hovold <johan@kernel.org>
    usb: dwc3: imx8mp: fix device leak at unbind

Anshuman Khandual <anshuman.khandual@arm.com>
    mm/ptdump: take the memory hotplug lock inside ptdump_walk_pgd()

Mikhail Lobanov <m.lobanov@rosa.ru>
    wifi: mac80211: check basic rates validity in sta_link_apply_parameters

Sean Christopherson <seanjc@google.com>
    KVM: x86: Take irqfds.lock when adding/deleting IRQ bypass producer

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    s390/mm: Remove possible false-positive warning in pte_free_defer()

Filipe Manana <fdmanana@suse.com>
    btrfs: send: make fs_path_len() inline and constify its argument

Filipe Manana <fdmanana@suse.com>
    btrfs: send: use fallocate for hole punching with send stream v2

Filipe Manana <fdmanana@suse.com>
    btrfs: send: avoid path allocation for the current inode when issuing commands

Filipe Manana <fdmanana@suse.com>
    btrfs: send: keep the current inode's path cached

Filipe Manana <fdmanana@suse.com>
    btrfs: send: add and use helper to rename current inode when processing refs

Filipe Manana <fdmanana@suse.com>
    btrfs: send: only use boolean variables at process_recorded_refs()

Filipe Manana <fdmanana@suse.com>
    btrfs: send: factor out common logic when sending xattrs

Qu Wenruo <wqu@suse.com>
    btrfs: populate otime when logging an inode item

David Sterba <dsterba@suse.com>
    btrfs: constify more pointer parameters

Boris Burkov <boris@bur.io>
    btrfs: fix ssd_spread overallocation

David Sterba <dsterba@suse.com>
    btrfs: open code timespec64 in struct btrfs_inode

Christoph Hellwig <hch@lst.de>
    xfs: fully decouple XFS_IBULK* flags from XFS_IWALK* flags

Filipe Manana <fdmanana@suse.com>
    btrfs: abort transaction on unexpected eb generation at btrfs_copy_root()

Filipe Manana <fdmanana@suse.com>
    btrfs: always abort transaction on failure to add block group to free space tree

David Sterba <dsterba@suse.com>
    btrfs: move transaction aborts to the error site in add_block_group_free_space()

Filipe Manana <fdmanana@suse.com>
    btrfs: qgroup: fix race between quota disable and quota rescan ioctl

Filipe Manana <fdmanana@suse.com>
    btrfs: don't ignore inode missing when replaying log tree

Sebastian Reichel <sebastian.reichel@collabora.com>
    usb: typec: fusb302: cache PD RX state

Lukas Wunner <lukas@wunner.de>
    PCI/ACPI: Fix runtime PM ref imbalance on Hot-Plug Capable ports

Damien Le Moal <dlemoal@kernel.org>
    block: Make REQ_OP_ZONE_FINISH a write operation

Christoph Hellwig <hch@lst.de>
    block: reject invalid operation in submit_bio_noacct

Eric Biggers <ebiggers@kernel.org>
    fscrypt: Don't use problematic non-inline crypto engines

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    leds: flash: leds-qcom-flash: Fix registry access after re-bind

Fenglin Wu <quic_fenglinw@quicinc.com>
    leds: flash: leds-qcom-flash: Limit LED current based on thermal condition

Davide Caratti <dcaratti@redhat.com>
    net/sched: ets: use old 'nbands' while purging unused classes

Eric Dumazet <edumazet@google.com>
    net_sched: sch_ets: implement lockless ets_dump()

Wang Zhaolong <wangzhaolong@huaweicloud.com>
    smb: client: fix netns refcount leak after net_passive changes

Eric Dumazet <edumazet@google.com>
    net: better track kernel sockets lifetime

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Add net_passive_inc() and net_passive_dec().

Isaac J. Manjarres <isaacmanjarres@google.com>
    selftests/memfd: add test for mapping write-sealed memfd read-only

Isaac J. Manjarres <isaacmanjarres@google.com>
    mm: reinstate ability to map write-sealed memfd mappings read-only

Isaac J. Manjarres <isaacmanjarres@google.com>
    mm: update memfd seal write check to include F_SEAL_WRITE

Isaac J. Manjarres <isaacmanjarres@google.com>
    mm: drop the assumption that VM_SHARED always implies writable

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: kernel: flush: do not reset ADD_ADDR limit

Christoph Paasch <cpaasch@openai.com>
    mptcp: drop skb if MPTCP skb extension allocation fails

Chen Yu <yu.c.chen@intel.com>
    ACPI: pfr_update: Fix the driver update version check

Eric Biggers <ebiggers@kernel.org>
    ipv6: sr: Fix MAC comparison to be constant-time

Jakub Acs <acsjakub@amazon.de>
    net, hsr: reject HSR frame if skb can't hold tag

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Don't overwrite dce60_clk_mgr

Michel Dänzer <mdaenzer@redhat.com>
    drm/amd/display: Add primary plane to commits for correct VRR handling

Amber Lin <Amber.Lin@amd.com>
    drm/amdkfd: Destroy KFD debugfs after destroy KFD wq

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: update mmhub 3.0.1 client id mappings

Gang Ba <Gang.Ba@amd.com>
    drm/amdgpu: Avoid extra evict-restore process.

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Restore cached power limit during resume

Ricardo Ribalda <ribalda@chromium.org>
    media: venus: venc: Clamp param smaller than 1fps and bigger than 240

Ricardo Ribalda <ribalda@chromium.org>
    media: venus: vdec: Clamp param smaller than 1fps and bigger than 240.

Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
    media: venus: protect against spurious interrupts during probe

Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
    media: venus: hfi: explicitly release IRQ during teardown

Vedang Nagar <quic_vnagar@quicinc.com>
    media: venus: Add a check for packet size after reading from shared memory

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    media: qcom: camss: cleanup media device allocated resource on error path

Hans de Goede <hansg@kernel.org>
    media: ivsc: Fix crash at shutdown due to missing mei_cldev_disable() calls

Zhang Shurong <zhang_shurong@foxmail.com>
    media: ov2659: Fix memory leaks in ov2659_probe()

Gui-Dong Han <hanguidong02@gmail.com>
    media: rainshadow-cec: fix TOCTOU race condition in rain_interrupt()

Ludwig Disterhof <ludwig@disterhof.eu>
    media: usbtv: Lock resolution while streaming

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l2-ctrls: Don't reset handler's error in v4l2_ctrl_handler_free()

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: verisilicon: Fix AV1 decoder clock frequency

Hans Verkuil <hverkuil@xs4all.nl>
    media: vivid: fix wrong pixel_array control size

Haoxiang Li <haoxiang_li2024@163.com>
    media: imx: fix a potential memory leak in imx_media_csc_scaler_device_init()

Bingbu Cao <bingbu.cao@intel.com>
    media: hi556: correct the test pattern configuration

Dan Carpenter <dan.carpenter@linaro.org>
    media: gspca: Add bounds checking to firmware parser

John David Anglin <dave.anglin@bell.net>
    parisc: Update comments in make_insert_tlb

John David Anglin <dave.anglin@bell.net>
    parisc: Try to fixup kernel exception in bad_area_nosemaphore path of do_page_fault()

John David Anglin <dave.anglin@bell.net>
    parisc: Revise gateway LWS calls to probe user read access

John David Anglin <dave.anglin@bell.net>
    parisc: Revise __get_user() to probe user read access

John David Anglin <dave.anglin@bell.net>
    parisc: Rename pte_needs_flush() to pte_needs_cache_flush() in cache.c

Randy Dunlap <rdunlap@infradead.org>
    parisc: Makefile: explain that 64BIT requires both 32-bit and 64-bit compilers

John David Anglin <dave.anglin@bell.net>
    parisc: Drop WARN_ON_ONCE() from flush_cache_vmap

John David Anglin <dave.anglin@bell.net>
    parisc: Define and use set_pte_at()

John David Anglin <dave.anglin@bell.net>
    parisc: Check region is readable by user in raw_copy_from_user()

Jon Hunter <jonathanh@nvidia.com>
    soc/tegra: pmc: Ensure power-domains are in a known state

Baokun Li <libaokun1@huawei.com>
    jbd2: prevent softlockup in jbd2_log_do_checkpoint()

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid out-of-boundary access in dnode page

Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
    phy: qcom: phy-qcom-m31: Update IPQ5332 M31 USB phy initialization sequence

Will Deacon <will@kernel.org>
    vhost/vsock: Avoid allocating arbitrarily-sized SKBs

Will Deacon <will@kernel.org>
    vsock/virtio: Validate length in packet header before skb_put()

Damien Le Moal <dlemoal@kernel.org>
    PCI: endpoint: Fix configfs group removal on driver teardown

Damien Le Moal <dlemoal@kernel.org>
    PCI: endpoint: Fix configfs group list head handling

Thomas Fourier <fourier.thomas@gmail.com>
    mtd: rawnand: renesas: Add missing check after DMA map

Thomas Fourier <fourier.thomas@gmail.com>
    mtd: rawnand: fsmc: Add missing check after DMA map

Gabor Juhos <j4g8y7@gmail.com>
    mtd: spinand: propagate spinand_wait() errors from spinand_write_page()

Michael Walle <mwalle@kernel.org>
    mtd: spi-nor: Fix spi_nor_try_unlock_all()

Tim Harvey <tharvey@gateworks.com>
    hwmon: (gsc-hwmon) fix fan pwm setpoint show functions

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: mediatek: Fix duty and period setting

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: mediatek: Handle hardware enable and clock enable separately

Laurentiu Mihalcea <laurentiu.mihalcea@nxp.com>
    pwm: imx-tpm: Reset counter if CMOD is 0

Johan Hovold <johan+linaro@kernel.org>
    wifi: ath11k: fix dest ring-buffer corruption when ring is full

Johan Hovold <johan+linaro@kernel.org>
    wifi: ath11k: fix source ring-buffer corruption

Johan Hovold <johan+linaro@kernel.org>
    wifi: ath11k: fix dest ring-buffer corruption

Johan Hovold <johan+linaro@kernel.org>
    wifi: ath12k: fix dest ring-buffer corruption when ring is full

Johan Hovold <johan+linaro@kernel.org>
    wifi: ath12k: fix source ring-buffer corruption

Johan Hovold <johan+linaro@kernel.org>
    wifi: ath12k: fix dest ring-buffer corruption

Nathan Chancellor <nathan@kernel.org>
    wifi: brcmsmac: Remove const from tbl_ptr parameter in wlc_lcnphy_common_read_table()

David Lechner <dlechner@baylibre.com>
    iio: adc: ad_sigma_delta: change to buffer predisable

David Lechner <dlechner@baylibre.com>
    iio: imu: bno055: fix OOB access of hw_xlate array

Marek Szyprowski <m.szyprowski@samsung.com>
    zynq_fpga: use sgtable-based scatterlist wrappers

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    soc: qcom: mdt_loader: Ensure we don't read past the ELF header

Igor Pylypiv <ipylypiv@google.com>
    ata: libata-scsi: Fix CDL control

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: ufs-pci: Fix default runtime and system PM levels

Archana Patni <archana.patni@intel.com>
    scsi: ufs: ufs-pci: Fix hibernate state transition for Intel MTL-like host controllers

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: Fix ata_to_sense_error() status handling

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Fix race between config read submit and interrupt completion

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: display: sprd,sharkl3-dsi-host: Fix missing clocks constraints

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: display: sprd,sharkl3-dpu: Fix missing clocks constraints

Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
    arm64: dts: ti: k3-am62-verdin: Enable pull-ups on I2C buses

Hong Guan <hguan@ti.com>
    arm64: dts: ti: k3-am62a7-sk: fix pinmux for main_uart1

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    arm64: dts: ti: k3-pinctrl: Enable Schmitt Trigger by default

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fix write time activation failure for metadata block group

Zhang Yi <yi.zhang@huawei.com>
    ext4: fix hole length calculation overflow in non-extent inodes

Liao Yuanhong <liaoyuanhong@vivo.com>
    ext4: use kmalloc_array() for array space allocation

Theodore Ts'o <tytso@mit.edu>
    ext4: don't try to clear the orphan_present feature block device is r/o

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: fix reserved gdt blocks handling in fsmap

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: fix fsmap end of range reporting with bigalloc

Andreas Dilger <adilger@dilger.ca>
    ext4: check fast symlink for ea_inode correctly

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: fprobe-event: Sanitize wildcard for fprobe event name

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: extend the connection limiting mechanism to support IPv6

Ziyan Xu <ziyan@securitygossip.com>
    ksmbd: fix refcount leak causing resource not released

Helge Deller <deller@gmx.de>
    Revert "vgacon: Add check for vc_origin address range in vgacon_scroll()"

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - flush misc workqueue during device shutdown

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - lower priority for skcipher and aead algorithms

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: mips/chacha: Fix clang build and remove unneeded byteswap

Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
    vt: defkeymap: Map keycodes above 127 to K_HOLE

Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
    vt: keyboard: Don't process Unicode characters in K_OFF mode

Youssef Samir <quic_yabdulra@quicinc.com>
    bus: mhi: host: Detect events pointing to unexpected TREs

Alexander Wilhelm <alexander.wilhelm@westermo.com>
    bus: mhi: host: Fix endianness of BHI vector table

Johan Hovold <johan@kernel.org>
    usb: dwc3: meson-g12a: fix device leaks at unbind

Johan Hovold <johan@kernel.org>
    usb: musb: omap2430: fix device leak at unbind

Johan Hovold <johan@kernel.org>
    usb: gadget: udc: renesas_usb3: fix device leak at unbind

Nathan Chancellor <nathan@kernel.org>
    usb: atm: cxacru: Merge cxacru_upload_firmware() into cxacru_heavy_init()

Finn Thain <fthain@linux-m68k.org>
    m68k: Fix lost column on framebuffer debug console

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_ec: Unregister notifier in cros_ec_unregister()

Dan Carpenter <dan.carpenter@linaro.org>
    cpufreq: armada-8k: Fix off by one in armada_8k_cpufreq_free_table()

Yunhui Cui <cuiyunhui@bytedance.com>
    serial: 8250: fix panic due to PSLVERR

Frederic Weisbecker <frederic@kernel.org>
    rcu: Fix racy re-initialization of irq_work causing hangs

Aditya Garg <gargaditya08@live.com>
    HID: apple: avoid setting up battery timer for devices without battery

Aditya Garg <gargaditya08@live.com>
    HID: magicmouse: avoid setting up battery timer when not needed

Pedro Falcato <pfalcato@suse.de>
    RDMA/siw: Fix the sendmsg byte count in siw_tcp_sendpages

Willy Tarreau <w@1wt.eu>
    tools/nolibc: fix spelling of FD_SETBITMASK in FD_* macros

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Do not mark valid metadata as invalid

Vedang Nagar <quic_vnagar@quicinc.com>
    media: venus: Fix OOB read due to missing payload bound check

Youngjun Lee <yjjuny.lee@samsung.com>
    media: uvcvideo: Fix 1-byte out-of-bounds read in uvc_parse_format()

Breno Leitao <leitao@debian.org>
    mm/kmemleak: avoid deadlock by moving pr_warn() outside kmemleak_lock

Waiman Long <longman@redhat.com>
    mm/kmemleak: avoid soft lockup in __kmemleak_do_cleanup()

Randy Dunlap <rdunlap@infradead.org>
    parisc: Makefile: fix a typo in palo.conf

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Fix panic during namespace deletion with VF

Sravan Kumar Gundu <sravankumarlpu@gmail.com>
    fbdev: Fix vmalloc out-of-bounds write in fast_imageblit

Qu Wenruo <wqu@suse.com>
    btrfs: do not allow relocation of partially dropped subvolumes

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: do not select metadata BG as finish target

Filipe Manana <fdmanana@suse.com>
    btrfs: fix log tree replay failure due to file with 0 links and extents

Filipe Manana <fdmanana@suse.com>
    btrfs: clear dirty status from extent buffer on error at insert_new_root()

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: do not remove unwritten non-data block group

Filipe Manana <fdmanana@suse.com>
    btrfs: abort transaction during log replay if walk_log_tree() failed

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: use filesystem size not disk size for reclaim decision

Oliver Neukum <oneukum@suse.com>
    cdc-acm: fix race between initial clearing halt and open

Eric Biggers <ebiggers@kernel.org>
    thunderbolt: Fix copy+paste error in match_service_id()

Ian Abbott <abbotti@mev.co.uk>
    comedi: fix race between polling and detaching

Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
    usb: typec: ucsi: Update power_supply on power role change

Ricky Wu <ricky_wu@realtek.com>
    misc: rtsx: usb: Ensure mmc child device is active when card is present

Xinyu Liu <katieeliu@tencent.com>
    usb: core: config: Prevent OOB read in SS endpoint companion parsing

Baokun Li <libaokun1@huawei.com>
    ext4: fix largest free orders lists corruption on mb_optimize_scan switch

Baokun Li <libaokun1@huawei.com>
    ext4: fix zombie groups in average fragment size lists

Jason Gunthorpe <jgg@ziepe.ca>
    iommufd: Prevent ALIGN() overflow

Nicolin Chen <nicolinc@nvidia.com>
    iommufd: Report unmapped bytes in the error path of iopt_unmap_iova_range

Alexey Klimov <alexey.klimov@linaro.org>
    iommu/arm-smmu-qcom: Add SM6115 MDSS compatible

Shyam Prasad N <sprasad@microsoft.com>
    cifs: reset iface weights when we cannot find a candidate

Jack Xiao <Jack.Xiao@amd.com>
    drm/amdgpu: fix incorrect vm flags to map bo

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_sai: replace regmap_write with regmap_update_bits

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    scsi: lpfc: Remove redundant assignment to avoid memory leak

Meagan Lloyd <meaganlloyd@linux.microsoft.com>
    rtc: ds1307: remove clear of oscillator stop flag (OSF) in probe

Sergey Bashirov <sergeybashirov@gmail.com>
    pNFS: Fix uninited ptr deref in block/scsi layout

Sergey Bashirov <sergeybashirov@gmail.com>
    pNFS: Handle RPC size limit for layoutcommits

Sergey Bashirov <sergeybashirov@gmail.com>
    pNFS: Fix disk addr range check in block/scsi layout

Sergey Bashirov <sergeybashirov@gmail.com>
    pNFS: Fix stripe mapping in block/scsi layout

John Garry <john.g.garry@oracle.com>
    block: avoid possible overflow for chunk_sectors check in blk_stack_limits()

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Fix uninitialized pointer error in probe()

Buday Csaba <buday.csaba@prolan.hu>
    net: phy: smsc: add proper reset flags for LAN8710A

Corey Minyard <corey@minyard.net>
    ipmi: Fix strcpy source and destination the same

Yann E. MORIN <yann.morin.1998@free.fr>
    kconfig: lxdialog: fix 'space' to (de)select options

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: gconf: fix potential memory leak in renderer_edited()

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: gconf: avoid hardcoding model2 in on_treeview2_cursor_changed()

Breno Leitao <leitao@debian.org>
    ipmi: Use dev_warn_ratelimited() for incorrect message warnings

Artem Sadovnikov <a.sadovnikov@ispras.ru>
    vfio/mlx5: fix possible overflow in tracking max message size

John Garry <john.g.garry@oracle.com>
    scsi: aacraid: Stop using PCI_IRQ_AFFINITY

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: core: Generate correct identifiers for PR OUT transport IDs

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: Fix sas_user_scan() to handle wildcard and multi-channel scans

Shankari Anand <shankari.ak0208@gmail.com>
    kconfig: nconf: Ensure null termination where strncpy is used

Keith Busch <kbusch@kernel.org>
    vfio/type1: conditional rescheduling while pinning

Suchit Karunakaran <suchitkarunakaran@gmail.com>
    kconfig: lxdialog: replace strcpy() with strncpy() in inputbox.c

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: check the generic conditions first

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: add cluster chain loop check for dir

fangzhong.zhou <myth5@myth5.com>
    i2c: Force DLL0945 touchpad i2c freq to 100khz

Mateusz Guzik <mjguzik@gmail.com>
    apparmor: use the condition in AA_BUG_FMT even with debug disabled

Benjamin Marzinski <bmarzins@redhat.com>
    dm-table: fix checking for rq stackable devices

Mikulas Patocka <mpatocka@redhat.com>
    dm-mpath: don't print the "loaded" message if registering fails

Jorge Marques <jorge.marques@analog.com>
    i3c: master: Initialize ret in i3c_i2c_notifier_call()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i3c: don't fail if GETHDRCAP is unsupported

Gabriel Totev <gabriel.totev@zetier.com>
    apparmor: shift ouid when mediating hard links in userns

Meagan Lloyd <meaganlloyd@linux.microsoft.com>
    rtc: ds1307: handle oscillator stop flag (OSF) for ds1341

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i3c: add missing include to internal header

Petr Pavlu <petr.pavlu@suse.com>
    module: Prevent silent truncation of module name in delete_module(2)

Purva Yeshi <purvayeshi550@gmail.com>
    md: dm-zoned-target: Initialize return variable r to avoid uninitialized use

Charles Keepax <ckeepax@opensource.cirrus.com>
    soundwire: Move handle_nested_irq outside of sdw_dev_lock

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    soundwire: amd: serialize amd manager resume sequence during pm_prepare

Bharat Bhushan <bbhushan2@marvell.com>
    crypto: octeontx2 - add timeout for load_fvc completion poll

chenchangcheng <chenchangcheng@kylinos.cn>
    media: uvcvideo: Fix bandwidth issue for Alcor camera

Alex Guo <alexguo1023@gmail.com>
    media: dvb-frontends: w7090p: fix null-ptr-deref in w7090p_tuner_write_serpar and w7090p_tuner_read_serpar

Alex Guo <alexguo1023@gmail.com>
    media: dvb-frontends: dib7090p: fix null-ptr-deref in dib7090p_rw_on_apb()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    media: usb: hdpvr: disable zero-length read messages

Dave Stevenson <dave.stevenson@raspberrypi.com>
    media: tc358743: Increase FIFO trigger level to 374

Dave Stevenson <dave.stevenson@raspberrypi.com>
    media: tc358743: Return an appropriate colorspace from tc358743_set_fmt

Dave Stevenson <dave.stevenson@raspberrypi.com>
    media: tc358743: Check I2C succeeded during probe

Cheick Traore <cheick.traore@foss.st.com>
    pinctrl: stm32: Manage irq affinity settings

Damien Le Moal <dlemoal@kernel.org>
    scsi: mpi3mr: Correctly handle ATA device errors

Damien Le Moal <dlemoal@kernel.org>
    scsi: mpt3sas: Correctly handle ATA device errors

Abel Vesa <abel.vesa@linaro.org>
    power: supply: qcom_battmgr: Add lithium-polymer entry

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Check for hdwq null ptr when cleaning up lpfc_vport structure

Arnd Bergmann <arnd@arndb.de>
    RDMA/core: reduce stack using in nldev_stat_get_doit()

Yury Norov [NVIDIA] <yury.norov@gmail.com>
    RDMA: hfi1: fix possible divide-by-zero in find_hw_thread_mask()

Amelie Delaunay <amelie.delaunay@foss.st.com>
    dmaengine: stm32-dma: configure next sg only if there are more than 2 sgs

Johan Adolfsson <johan.adolfsson@axis.com>
    leds: leds-lp50xx: Handle reg to get correct multi_index

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: v4l2-common: Reduce warnings about missing V4L2_CID_LINK_FREQ control

Shiji Yang <yangshiji66@outlook.com>
    MIPS: lantiq: falcon: sysctrl: fix request memory check logic

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    MIPS: Don't crash in stack_top() for tasks without ABI or vDSO

Markus Theil <theil.markus@gmail.com>
    crypto: jitter - fix intermediary handling

Arnaud Lecomte <contact@arnaud-lcm.com>
    jfs: upper bound check of tree index in dbAllocAG

Edward Adam Davis <eadavis@qq.com>
    jfs: Regular file corruption check

Lizhi Xu <lizhi.xu@windriver.com>
    jfs: truncate good inode pages when hard link is 0

jackysliu <1972843537@qq.com>
    scsi: bfa: Double-free fix

Ziyan Fu <fuzy5@lenovo.com>
    watchdog: iTCO_wdt: Report error if timeout configuration fails

Shiji Yang <yangshiji66@outlook.com>
    MIPS: vpe-mt: add missing prototypes for vpe_{alloc,start,stop,free}

George Moussalem <george.moussalem@outlook.com>
    clk: qcom: ipq5018: keep XO clock always on

Florin Leotescu <florin.leotescu@nxp.com>
    hwmon: (emc2305) Set initial PWM minimum value during probe based on thermal state

Sebastian Reichel <sebastian.reichel@collabora.com>
    watchdog: dw_wdt: Fix default timeout

Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
    fs/orangefs: use snprintf() instead of sprintf()

Showrya M N <showrya@chelsio.com>
    scsi: libiscsi: Initialize iscsi_conn->dd_data only if memory is allocated

Geraldo Nascimento <geraldogabriel@gmail.com>
    phy: rockchip-pcie: Properly disable TEST_WRITE strobe signal

Chen-Yu Tsai <wens@csie.org>
    mfd: axp20x: Set explicit ID for AXP313 regulator

Pei Xiao <xiaopei01@kylinos.cn>
    clk: tegra: periph: Fix error handling and resolve unsigned compare warning

Theodore Ts'o <tytso@mit.edu>
    ext4: do not BUG when INLINE_DATA_FL lacks system.data xattr

Zhiqi Song <songzhiqi1@huawei.com>
    crypto: hisilicon/hpre - fix dma unmap sequence

Yongzhen Zhang <zhangyongzhen@kylinos.cn>
    fbdev: fix potential buffer overflow in do_register_framebuffer()

Pali Rohár <pali@kernel.org>
    cifs: Fix calling CIFSFindFirst() for root path without msearch

Aaron Plattner <aplattner@nvidia.com>
    watchdog: sbsa: Adjust keepalive timeout to avoid MediaTek WS0 race condition

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Avoid configuring PSR granularity if PSR-SU not supported

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Only finalize atomic_obj if it was initialized

Jason Wang <jasowang@redhat.com>
    vhost: fail early when __vhost_add_used() fails

Will Deacon <will@kernel.org>
    vsock/virtio: Resize receive buffers so that each SKB fits in a 4K page

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: fix IP_MULTICAST_CTRL on BCM5325

Joel Fernandes <joelagnelf@nvidia.com>
    rcu: Fix rcu_read_unlock() deadloop due to IRQ work

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/ttm: Respect the shrinker core free target

Wayne Lin <Wayne.Lin@amd.com>
    drm/amd/display: Avoid trying AUX transactions on disconnected ports

Yonghong Song <yonghong.song@linux.dev>
    selftests/bpf: Fix a user_ringbuf failure with arm64 64KB page size

Ihor Solodrai <isolodrai@meta.com>
    bpf: Make reg_not_null() true for CONST_PTR_TO_MAP

Jakub Kicinski <kuba@kernel.org>
    uapi: in6: restore visibility of most IPv6 socket options

Emily Deng <Emily.Deng@amd.com>
    drm/ttm: Should to return the evict error

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    drm: renesas: rz-du: mipi_dsi: Add min check for VCLK range

Hari Kalavakunta <kalavakunta.hari.prasad@gmail.com>
    net: ncsi: Fix buffer overflow in fetching version id

Shannon Nelson <shannon.nelson@amd.com>
    ionic: clean dbpage in de-init

Thomas Fourier <fourier.thomas@gmail.com>
    wifi: rtlwifi: fix possible skb memory leak in _rtl_pci_init_one_rxdesc()

Breno Leitao <leitao@debian.org>
    ptp: Use ratelimite for freerun error message

Yuan Chen <chenyuan@kylinos.cn>
    bpftool: Fix JSON writer resource leak in version command

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: prevent SWITCH_CTRL access on BCM5325

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: prevent DIS_LEARNING access on BCM5325

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: prevent GMII_PORT_OVERRIDE_CTRL access on BCM5325

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: fix b53_imp_vlan_setup for BCM5325

Alok Tiwari <alok.a.tiwari@oracle.com>
    gve: Return error for unknown admin queue command

Gal Pressman <gal@nvidia.com>
    net: vlan: Replace BUG() with WARN_ON_ONCE() in vlan_dev_* stubs

Gal Pressman <gal@nvidia.com>
    net: vlan: Make is_vlan_dev() a stub when VLAN is not configured

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Allow printing VanGogh OD SCLK levels without setting dpm to manual

Heiner Kallweit <hkallweit1@gmail.com>
    dpaa_eth: don't use fixed_phy_change_carrier

Nicolas Escande <nico.escande@gmail.com>
    neighbour: add support for NUD_PERMANENT proxy entries

Stanislaw Gruszka <stf_xl@wp.pl>
    wifi: iwlegacy: Check rate_idx range after addition

Mina Almasry <almasrymina@google.com>
    netmem: fix skb_frag_address_safe with unreadable skbs

Thomas Fourier <fourier.thomas@gmail.com>
    powerpc: floppy: Add missing checks after DMA map

Karthikeyan Kathirvel <quic_kathirve@quicinc.com>
    wifi: ath12k: Decrement TID on RX peer frag setup error handling

Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>
    wifi: ath12k: Enable REO queue lookup table feature on QCN9274 hw2.0

Thomas Fourier <fourier.thomas@gmail.com>
    wifi: rtlwifi: fix possible skb memory leak in `_rtl_pci_rx_interrupt()`.

Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>
    wifi: mac80211: update radar_required in channel context after channel switch

Wen Chen <Wen.Chen3@amd.com>
    drm/amd/display: Fix 'failed to blank crtc!'

Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
    wifi: iwlwifi: fw: Fix possible memory leak in iwl_fw_dbg_collect

Rand Deeb <rand.sec96@gmail.com>
    wifi: iwlwifi: dvm: fix potential overflow in rs_fill_link_cmd()

Sarika Sharma <quic_sarishar@quicinc.com>
    wifi: ath12k: Add memset and update default rate value in wmi tx completion

Ilya Bakoulin <Ilya.Bakoulin@amd.com>
    drm/amd/display: Separate set_gsl from set_gsl_source_select

Jonas Rebmann <jre@pengutronix.de>
    net: fec: allow disable coalescing

Eric Work <work.eric@gmail.com>
    net: atlantic: add set_power to fw_ops for atl2 to fix wol

Aakash Kumar S <saakashkumar@marvell.com>
    xfrm: Duplicate SPI Handling

zhangjianrong <zhangjianrong5@huawei.com>
    net: thunderbolt: Fix the parameter passing of tb_xdomain_enable_paths()/tb_xdomain_disable_paths()

zhangjianrong <zhangjianrong5@huawei.com>
    net: thunderbolt: Enable end-to-end flow control also in transmit

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Specify SVE data when testing VL set in sve-ptrace

David Bauer <mail@david-bauer.net>
    wifi: mt76: mt7915: mcu: re-init MCU before loading FW patch

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw89: Disable deep power saving for USB/SDIO

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw89: Fix rtw89_mac_power_switch() for USB

Rob Clark <robdclark@chromium.org>
    drm/msm: use trylock for debugfs

Hari Chandrakanthan <quic_haric@quicinc.com>
    wifi: mac80211: fix rx link assignment for non-MLO stations

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: mcast: Check inet6_dev->dead under idev->mc_lock in __ipv6_dev_mc_inc().

Thomas Fourier <fourier.thomas@gmail.com>
    (powerpc/512) Fix possible `dma_unmap_single()` on uninitialized pointer

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't complete management TX on SAE commit

Chris Mason <clm@fb.com>
    sched/fair: Bump sd->max_newidle_lb_cost when newidle balance fails

Sven Schnelle <svens@linux.ibm.com>
    s390/stp: Remove udelay from stp_sync_clock()

Avraham Stern <avraham.stern@intel.com>
    wifi: iwlwifi: mvm: fix scan request validation

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    um: Re-evaluate thread flags repeatedly

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: mvm: set gtk id also in older FWs

Alok Tiwari <alok.a.tiwari@oracle.com>
    perf/cxlpmu: Remove unintended newline from IRQ name format string

Biju Das <biju.das.jz@bp.renesas.com>
    net: phy: micrel: Add ksz9131_resume()

Alok Tiwari <alok.a.tiwari@oracle.com>
    net: thunderx: Fix format-truncation warning in bgx_acpi_match_id()

Oscar Maes <oscmaes92@gmail.com>
    net: ipv4: fix incorrect MTU in broadcast routes

Ilan Peer <ilan.peer@intel.com>
    wifi: cfg80211: Fix interface type validation

Matt Johnston <matt@codeconstruct.com.au>
    net: mctp: Prevent duplicate binds

Paul E. McKenney <paulmck@kernel.org>
    rcu: Protect ->defer_qs_iw_pending from data race

Breno Leitao <leitao@debian.org>
    arm64: Mark kernel as tainted on SAE and SError panic

Leon Romanovsky <leon@kernel.org>
    net/mlx5e: Properly access RCU protected qdisc_sleeping variable

Thomas Fourier <fourier.thomas@gmail.com>
    net: ag71xx: Add missing check after DMA map

Thomas Fourier <fourier.thomas@gmail.com>
    et131x: Add missing check after DMA map

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw89: Lower the timeout in rtw89_fw_read_c2h_reg() for USB

Alok Tiwari <alok.a.tiwari@oracle.com>
    be2net: Use correct byte order and format string for TCP seq and ack_seq

Sven Schnelle <svens@linux.ibm.com>
    s390/time: Use monotonic clock in get_cycles()

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: reject HTC bit for management frames

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl: Prevent recursion of default variable options

Sarika Sharma <quic_sarishar@quicinc.com>
    wifi: ath12k: Correct tid cleanup when tid setup fails

Oliver Neukum <oneukum@suse.com>
    net: usb: cdc-ncm: check for filtering capability

Anthoine Bourgeois <anthoine.bourgeois@vates.tech>
    xen/netfront: Fix TX response spurious interrupts

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: hci_sock: Reset cookie to zero in hci_sock_free_cookie()

Steven Rostedt <rostedt@goodmis.org>
    powerpc/thp: tracing: Hide hugepage events under CONFIG_PPC_BOOK3S_64

Srinivas Kandagatla <srini@kernel.org>
    ASoC: qcom: use drvdata instead of component to keep id

Xinxin Wan <xinxin.wan@intel.com>
    ASoC: codecs: rt5640: Retry DEVICE_ID verification

Jonathan Santos <Jonathan.Santos@analog.com>
    iio: adc: ad7768-1: Ensure SYNC_IN pulse minimum timing requirement

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Avoid precedence issues in mixer_quirks macros

Christophe Leroy <christophe.leroy@csgroup.eu>
    ALSA: pcm: Rewrite recalculate_boundary() to avoid costly loop

Lucy Thrun <lucy.thrun@digital-rabbithole.de>
    ALSA: hda/ca0132: Fix buffer overflow in add_tuning_control

Tomasz Michalec <tmichalec@google.com>
    platform/chrome: cros_ec_typec: Defer probe on missing EC parent

Kees Cook <kees@kernel.org>
    platform/x86: thinkpad_acpi: Handle KCOV __init vs inline mismatches

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    soc: qcom: mdt_loader: Actually use the e_phoff

Krzysztof Hałasa <khalasa@piap.pl>
    imx8m-blk-ctrl: set ISI panic write hurry level

Gautham R. Shenoy <gautham.shenoy@amd.com>
    pm: cpupower: Fix the snapshot-order of tsc,mperf, clock in mperf_stop()

Oliver Neukum <oneukum@suse.com>
    usb: core: usb_submit_urb: downgrade type check

Tomasz Michalec <tmichalec@google.com>
    usb: typec: intel_pmc_mux: Defer probe if SCU IPC isn't present

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: core: Check for rtd == NULL in snd_soc_remove_pcm_runtime()

Alok Tiwari <alok.a.tiwari@oracle.com>
    ALSA: intel8x0: Fix incorrect codec index usage in mixer for ICH4

Mark Brown <broonie@kernel.org>
    ASoC: hdac_hdmi: Rate limit logging on connection and disconnection

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Avoid warning when overriding return thunk

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Disable jack polling at shutdown

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Handle the jack polling always via a work

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: rtsx_usb_sdmmc: Fix error-path in sd_set_power_mode()

Hans de Goede <hansg@kernel.org>
    mei: bus: Check for still connected devices in mei_cl_bus_dev_release()

Zijun Hu <zijun.hu@oss.qualcomm.com>
    char: misc: Fix improper and inaccurate error code returned by misc_init()

Peter Robinson <pbrobinson@gmail.com>
    reset: brcmstb: Enable reset drivers for ARCH_BCM2835

Eliav Farber <farbere@amazon.com>
    pps: clients: gpio: fix interrupt handling order in remove path

Breno Leitao <leitao@debian.org>
    ACPI: APEI: GHES: add TAINT_MACHINE_CHECK on GHES panic path

Sarthak Garg <quic_sartgarg@quicinc.com>
    mmc: sdhci-msm: Ensure SD card power isn't ON when card removed

Sebastian Ott <sebott@redhat.com>
    ACPI: processor: fix acpi_object initialization

tuhaowen <tuhaowen@uniontech.com>
    PM: sleep: console: Fix the black screen issue

Hsin-Te Yuan <yuanhsinte@chromium.org>
    thermal: sysfs: Return ENODATA instead of EAGAIN for reads

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Clear power.needs_force_resume in pm_runtime_reinit()

Thierry Reding <treding@nvidia.com>
    firmware: tegra: Fix IVC dependency problems

Zhu Qiyu <qiyuzhu2@amd.com>
    ACPI: PRM: Reduce unnecessary printing to avoid user confusion

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    selftests: tracing: Use mutex_unlock for testing glob filter

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    tools/build: Fix s390(x) cross-compilation with clang

Aaron Kling <webgeek1234@gmail.com>
    ARM: tegra: Use I/O memcpy to write to IRAM

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: tps65912: check the return value of regmap_update_bits()

David Lechner <dlechner@baylibre.com>
    iio: adc: ad_sigma_delta: don't overallocate scan buffer

Thomas Weißschuh <linux@weissschuh.net>
    tools/nolibc: define time_t in terms of __kernel_old_time_t

David Collins <david.collins@oss.qualcomm.com>
    thermal/drivers/qcom-spmi-temp-alarm: Enable stage 2 shutdown when required

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-dapm: set bias_level if snd_soc_dapm_set_bias_level() was successed

Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
    EDAC/synopsys: Clear the ECC counters on init

Lifeng Zheng <zhenglifeng1@huawei.com>
    PM / devfreq: governor: Replace sscanf() with kstrtoul() in set_freq_store()

Alexander Kochetkov <al.kochet@gmail.com>
    ARM: rockchip: fix kernel hang during smp initialization

Lifeng Zheng <zhenglifeng1@huawei.com>
    cpufreq: Exit governor when failed to start old governor

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: wcd934x: check the return value of regmap_update_bits()

Hiago De Franco <hiago.franco@toradex.com>
    remoteproc: imx_rproc: skip clock enable when M-core is managed by the SCU

Shuai Xue <xueshuai@linux.alibaba.com>
    ACPI: APEI: send SIGBUS to current task if synchronous memory error not recovered

Maulik Shah <maulik.shah@oss.qualcomm.com>
    soc: qcom: rpmh-rsc: Add RSC version 4 support

Mario Limonciello <mario.limonciello@amd.com>
    usb: xhci: Avoid showing errors during surprise removal

Jay Chen <shawn2000100@gmail.com>
    usb: xhci: Set avg_trb_len = 8 for EP0 during Address Device Command

Mario Limonciello <mario.limonciello@amd.com>
    usb: xhci: Avoid showing warnings for dying controller

Benson Leung <bleung@chromium.org>
    usb: typec: ucsi: psy: Set current max to 100mA for BC 1.2 and Default

Cynthia Huang <cynthia@andestech.com>
    selftests/futex: Define SYS_futex on 32-bit architectures with 64-bit time_t

Prashant Malani <pmalani@google.com>
    cpufreq: CPPC: Mark driver with NEED_UPDATE_LIMITS flag

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd: pmc: Add Lenovo Yoga 6 13ALC6 to pmc quirk list

Su Hui <suhui@nfschina.com>
    usb: xhci: print xhci->xhc_state when queue_command failed

Steven Rostedt <rostedt@goodmis.org>
    tracefs: Add d_delete to remove negative dentries

Al Viro <viro@zeniv.linux.org.uk>
    securityfs: don't pin dentries twice, once is enough...

Al Viro <viro@zeniv.linux.org.uk>
    fix locking in efi_secret_unlink()

Wei Gao <wegao@suse.com>
    ext2: Handle fiemap on empty files to prevent EINVAL

Rong Zhang <ulin0208@gmail.com>
    fs/ntfs3: correctly create symlink for relative path

Lizhi Xu <lizhi.xu@windriver.com>
    fs/ntfs3: Add sanity check for file name

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-sata: Disallow changing LPM state if not supported

Al Viro <viro@zeniv.linux.org.uk>
    better lockdep annotations for simple_recursive_removal()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: fix not erasing deleted b-tree node issue

Sarah Newman <srn@prgmr.com>
    drbd: add missing kref_get in handle_write_conflicts

Jan Kara <jack@suse.cz>
    udf: Verify partition map count

Jan Kara <jack@suse.cz>
    loop: Avoid updating block size under exclusive owner

Andrew Price <anprice@redhat.com>
    gfs2: Set .migrate_folio in gfs2_{rgrp,meta}_aops

Keith Busch <kbusch@kernel.org>
    nvme-pci: try function level reset on init failure

NeilBrown <neil@brown.name>
    smb/server: avoid deadlock when linking with ReplaceIfExists

Kees Cook <kees@kernel.org>
    arm64: Handle KCOV __init vs inline mismatches

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    hfsplus: don't use BUG_ON() in hfsplus_create_attributes_file()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix slab-out-of-bounds read in hfsplus_uni2asc()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix slab-out-of-bounds in hfsplus_bnode_read()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: fix slab-out-of-bounds in hfs_bnode_read()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: fix general protection fault in hfs_find_init()

Jakub Kicinski <kuba@kernel.org>
    tls: handle data disappearing from under the TLS ULP

Jeongjun Park <aha310510@gmail.com>
    ptp: prevent possible ABBA deadlock in ptp_clock_freerun()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: governors: menu: Avoid using invalid recent intervals data

Len Brown <len.brown@intel.com>
    intel_idle: Allow loading ACPI tables for any family

Xin Long <lucien.xin@gmail.com>
    sctp: linearize cloned gso packets in sctp_rcv

Alok Tiwari <alok.a.tiwari@oracle.com>
    net: ti: icss-iep: Fix incorrect type for return value in extts_enable()

Florian Westphal <fw@strlen.de>
    netfilter: ctnetlink: fix refcount leak on table dump

Sabrina Dubroca <sd@queasysnail.net>
    udp: also consider secpath when evaluating ipsec use for checksumming

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: VMX: Preserve host's DEBUGCTLMSR_FREEZE_IN_SMM while running the guest

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: VMX: Wrap all accesses to IA32_DEBUGCTL with getter/setter APIs

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: nVMX: Check vmcs12->guest_ia32_debugctl on nested VM-Enter

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Extract checking of guest's DEBUGCTL into helper

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Allow guest to set DEBUGCTL.RTM_DEBUG if RTM is supported

Sean Christopherson <seanjc@google.com>
    KVM: x86: Drop kvm_x86_ops.set_dr6() in favor of a new KVM_RUN flag

Sean Christopherson <seanjc@google.com>
    KVM: x86: Convert vcpu_run()'s immediate exit param into a generic bitmap

Sean Christopherson <seanjc@google.com>
    KVM: x86: Fully defer to vendor code to decide how to force immediate exit

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Handle KVM-induced preemption timer exits in fastpath for L2

Sean Christopherson <seanjc@google.com>
    KVM: x86: Move handling of is_guest_mode() into fastpath exit handlers

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Handle forced exit due to preemption timer in fastpath

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Re-enter guest in fastpath for "spurious" preemption timer exits

Sean Christopherson <seanjc@google.com>
    KVM: x86: Plumb "force_immediate_exit" into kvm_entry() tracepoint

Sean Christopherson <seanjc@google.com>
    KVM: x86: Snapshot the host's DEBUGCTL after disabling IRQs

Sean Christopherson <seanjc@google.com>
    KVM: x86: Snapshot the host's DEBUGCTL in common x86

Chao Gao <chao.gao@intel.com>
    KVM: nVMX: Defer SVI update to vmcs01 on EOI when L2 is active w/o VID

Sean Christopherson <seanjc@google.com>
    KVM: x86: Plumb in the vCPU to kvm_x86_ops.hwapic_isr_update()

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Set RFLAGS.IF=1 in C code, to get VMRUN out of the STI shadow

Manuel Andreas <manuel.andreas@tum.de>
    KVM: x86/hyper-v: Skip non-canonical addresses during PV TLB flush

Stefan Metzmacher <metze@samba.org>
    smb: client: don't wait for info->send_pending == 0 on error

Stefan Metzmacher <metze@samba.org>
    smb: client: let send_done() cleanup before calling smbd_disconnect_rdma_connection()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: processor: perflib: Move problematic pr->performance check

Jiayi Li <lijiayi@kylinos.cn>
    ACPI: processor: perflib: Fix initial _PPC limit application

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    Documentation: ACPI: Fix parent device references

Jann Horn <jannh@google.com>
    eventpoll: Fix semi-unbounded recursion

Sasha Levin <sashal@kernel.org>
    fs: Prevent file descriptor table allocations exceeding INT_MAX

Ma Ke <make24@iscas.ac.cn>
    sunvdc: Balance device refcount in vdc_port_mpgroup_check

Haoran Jiang <jianghaoran@kylinos.cn>
    LoongArch: BPF: Fix jump offset calculation in tailcall

Huacai Chen <chenhuacai@kernel.org>
    PCI: Extend isolated function probing to LoongArch

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix the setting of capabilities when automounting a new filesystem

Dai Ngo <dai.ngo@oracle.com>
    NFSD: detect mismatch of file handle and delegation stateid in OPEN op

Jeff Layton <jlayton@kernel.org>
    nfsd: handle get_client_locked() failure in nfsd4_setclientid_confirm()

Jens Axboe <axboe@kernel.dk>
    io_uring/net: commit partial buffers on retry

Xu Yang <xu.yang_2@nxp.com>
    net: usb: asix_devices: add phy_mask for ax88772 mdio bus

Johan Hovold <johan@kernel.org>
    net: dpaa: fix device leak when querying time stamp info

Johan Hovold <johan@kernel.org>
    net: ti: icss-iep: fix device and OF node leaks at probe

Johan Hovold <johan@kernel.org>
    net: mtk_eth_soc: fix device leak at probe

Johan Hovold <johan@kernel.org>
    net: enetc: fix device and OF node leak at probe

Johan Hovold <johan@kernel.org>
    net: gianfar: fix device leak when querying time stamp info

Florian Larysch <fl@n621.de>
    net: phy: micrel: fix KSZ8081/KSZ8091 cable test

Fedor Pchelkin <pchelkin@ispras.ru>
    netlink: avoid infinite retry looping in netlink_unicast()

Daniel Golle <daniel@makrotopia.org>
    Revert "leds: trigger: netdev: Configure LED blink interval for HW offload"

David Thompson <davthompson@nvidia.com>
    gpio: mlxbf3: use platform_get_irq_optional()

David Thompson <davthompson@nvidia.com>
    Revert "gpio: mlxbf3: only get IRQ for device instance 0"

David Thompson <davthompson@nvidia.com>
    gpio: mlxbf2: use platform_get_irq_optional()

Harald Mommer <harald.mommer@oss.qualcomm.com>
    gpio: virtio: Fix config space reading.

Wang Zhaolong <wangzhaolong@huaweicloud.com>
    smb: client: remove redundant lstrp update in negotiate protocol

Steve French <stfrench@microsoft.com>
    smb3: fix for slab out of bounds on mount to ksmbd

Christopher Eby <kreed@kreed.org>
    ALSA: hda/realtek: Add Framework Laptop 13 (AMD Ryzen AI 300) to quirks

Vasiliy Kovalev <kovalev@altlinux.org>
    ALSA: hda/realtek: Fix headset mic on HONOR BRB-X

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Validate UAC3 cluster segment descriptors

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Validate UAC3 power domain descriptors, too

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: don't use int for ABI


-------------

Diffstat:

 .../bindings/display/sprd/sprd,sharkl3-dpu.yaml    |   2 +-
 .../display/sprd/sprd,sharkl3-dsi-host.yaml        |   2 +-
 Documentation/filesystems/fscrypt.rst              |  37 +--
 Documentation/firmware-guide/acpi/i2c-muxes.rst    |   8 +-
 Documentation/networking/bonding.rst               |  12 +
 Documentation/networking/mptcp-sysctl.rst          |   2 +
 Documentation/power/runtime_pm.rst                 |   5 +-
 Makefile                                           |   6 +-
 arch/arm/include/asm/topology.h                    |   1 +
 arch/arm/mach-rockchip/platsmp.c                   |  15 +-
 arch/arm/mach-tegra/reset.c                        |   2 +-
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi           |   1 -
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi         |  12 +-
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts            |   4 +-
 arch/arm64/boot/dts/ti/k3-pinctrl.h                |  15 +-
 arch/arm64/include/asm/acpi.h                      |   2 +-
 arch/arm64/include/asm/topology.h                  |   1 +
 arch/arm64/kernel/fpsimd.c                         |   4 +-
 arch/arm64/kernel/topology.c                       |  26 +-
 arch/arm64/kernel/traps.c                          |   1 +
 arch/arm64/mm/fault.c                              |   1 +
 arch/arm64/mm/ptdump_debugfs.c                     |   3 -
 arch/loongarch/kernel/module-sections.c            |  38 +--
 arch/loongarch/net/bpf_jit.c                       |  21 +-
 arch/m68k/kernel/head.S                            |  31 +-
 arch/mips/crypto/chacha-core.S                     |  20 +-
 arch/mips/include/asm/vpe.h                        |   8 +
 arch/mips/kernel/process.c                         |  16 +-
 arch/mips/lantiq/falcon/sysctrl.c                  |  23 +-
 arch/parisc/Makefile                               |   6 +-
 arch/parisc/include/asm/pgtable.h                  |   7 +-
 arch/parisc/include/asm/special_insns.h            |  28 ++
 arch/parisc/include/asm/uaccess.h                  |  21 +-
 arch/parisc/kernel/cache.c                         |   6 +-
 arch/parisc/kernel/entry.S                         |  17 +-
 arch/parisc/kernel/syscall.S                       |  30 +-
 arch/parisc/lib/memcpy.c                           |  19 +-
 arch/parisc/mm/fault.c                             |   4 +
 arch/powerpc/boot/Makefile                         |   1 +
 arch/powerpc/include/asm/floppy.h                  |   5 +-
 arch/powerpc/platforms/512x/mpc512x_lpbfifo.c      |   6 +-
 arch/riscv/include/asm/topology.h                  |   1 +
 arch/s390/hypfs/hypfs_dbfs.c                       |  19 +-
 arch/s390/include/asm/timex.h                      |  13 +-
 arch/s390/kernel/time.c                            |   2 +-
 arch/s390/mm/dump_pagetables.c                     |   2 -
 arch/s390/mm/pgalloc.c                             |   5 -
 arch/um/include/asm/thread_info.h                  |   4 +
 arch/um/kernel/process.c                           |  18 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |   2 -
 arch/x86/include/asm/kvm_host.h                    |  22 +-
 arch/x86/include/asm/msr-index.h                   |   1 +
 arch/x86/include/asm/xen/hypercall.h               |   5 +-
 arch/x86/kernel/cpu/bugs.c                         |   5 +-
 arch/x86/kernel/cpu/hygon.c                        |   3 +
 arch/x86/kvm/hyperv.c                              |   3 +
 arch/x86/kvm/lapic.c                               |  19 +-
 arch/x86/kvm/lapic.h                               |   1 +
 arch/x86/kvm/svm/svm.c                             |  42 ++-
 arch/x86/kvm/svm/vmenter.S                         |   9 +-
 arch/x86/kvm/trace.h                               |   9 +-
 arch/x86/kvm/vmx/nested.c                          |  26 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |   8 +-
 arch/x86/kvm/vmx/vmx.c                             | 164 ++++++----
 arch/x86/kvm/vmx/vmx.h                             |  31 +-
 arch/x86/kvm/x86.c                                 |  46 ++-
 block/blk-core.c                                   |  26 +-
 block/blk-settings.c                               |   2 +-
 crypto/jitterentropy-kcapi.c                       |   9 +-
 drivers/acpi/acpi_processor.c                      |   2 +-
 drivers/acpi/apei/ghes.c                           |  13 +
 drivers/acpi/pfr_update.c                          |   2 +-
 drivers/acpi/prmt.c                                |  26 +-
 drivers/acpi/processor_perflib.c                   |  11 +
 drivers/ata/Kconfig                                |  35 +-
 drivers/ata/libata-sata.c                          |   5 +
 drivers/ata/libata-scsi.c                          |  58 ++--
 drivers/base/arch_topology.c                       |  69 ++--
 drivers/base/power/runtime.c                       |  59 +++-
 drivers/block/drbd/drbd_receiver.c                 |   6 +-
 drivers/block/loop.c                               |  38 ++-
 drivers/block/sunvdc.c                             |   4 +-
 drivers/bus/mhi/host/boot.c                        |   8 +-
 drivers/bus/mhi/host/internal.h                    |   4 +-
 drivers/bus/mhi/host/main.c                        |  12 +-
 drivers/cdx/controller/cdx_rpmsg.c                 |   3 +-
 drivers/char/ipmi/ipmi_msghandler.c                |   8 +-
 drivers/char/ipmi/ipmi_watchdog.c                  |  59 +++-
 drivers/char/misc.c                                |   4 +-
 drivers/clk/qcom/gcc-ipq5018.c                     |   2 +-
 drivers/clk/tegra/clk-periph.c                     |   4 +-
 drivers/comedi/comedi_fops.c                       |  38 ++-
 drivers/comedi/comedi_internal.h                   |   1 +
 drivers/comedi/drivers.c                           |  40 ++-
 drivers/comedi/drivers/pcl726.c                    |   3 +-
 drivers/cpufreq/armada-8k-cpufreq.c                |   2 +-
 drivers/cpufreq/cppc_cpufreq.c                     |   2 +-
 drivers/cpufreq/cpufreq.c                          |  12 +-
 drivers/cpuidle/governors/menu.c                   |  98 ++----
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |   8 +-
 .../crypto/intel/qat/qat_common/adf_common_drv.h   |   1 +
 drivers/crypto/intel/qat/qat_common/adf_init.c     |   1 +
 drivers/crypto/intel/qat/qat_common/adf_isr.c      |   5 +
 drivers/crypto/intel/qat/qat_common/qat_algs.c     |  12 +-
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c    |  16 +-
 drivers/devfreq/governor_userspace.c               |   6 +-
 drivers/dma/stm32-dma.c                            |   2 +-
 drivers/edac/synopsys_edac.c                       |  93 +++---
 drivers/firmware/tegra/Kconfig                     |   5 +-
 drivers/fpga/zynq-fpga.c                           |  10 +-
 drivers/gpio/gpio-mlxbf2.c                         |   2 +-
 drivers/gpio/gpio-mlxbf3.c                         |  52 +--
 drivers/gpio/gpio-tps65912.c                       |   7 +-
 drivers/gpio/gpio-virtio.c                         |   9 +-
 drivers/gpio/gpio-wcd934x.c                        |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c            |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c          |  57 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_module.c            |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   6 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |   9 +
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c  |   6 +-
 .../gpu/drm/amd/display/dc/bios/command_table.c    |   2 +-
 drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c   |   1 -
 .../amd/display/dc/clk_mgr/dce100/dce_clk_mgr.c    |   2 -
 .../amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c |  40 ++-
 .../amd/display/dc/clk_mgr/dce60/dce60_clk_mgr.c   |  31 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |  11 +-
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c    |   3 +-
 .../gpu/drm/amd/display/modules/hdcp/hdcp_psp.c    |   3 +
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   6 +
 drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c   |  37 +--
 drivers/gpu/drm/display/drm_dp_helper.c            |   2 +-
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c    |   4 +-
 drivers/gpu/drm/i915/intel_runtime_pm.c            |   5 +-
 drivers/gpu/drm/msm/msm_gem.c                      |   3 +-
 drivers/gpu/drm/msm/msm_gem.h                      |   6 +
 drivers/gpu/drm/nouveau/nvif/vmm.c                 |   3 +-
 drivers/gpu/drm/renesas/rcar-du/rzg2l_mipi_dsi.c   |   3 +
 drivers/gpu/drm/ttm/ttm_pool.c                     |   8 +-
 drivers/gpu/drm/ttm/ttm_resource.c                 |   3 +
 drivers/hid/hid-apple.c                            |  13 +-
 drivers/hid/hid-magicmouse.c                       |  56 ++--
 drivers/hwmon/emc2305.c                            |  10 +-
 drivers/hwmon/gsc-hwmon.c                          |   4 +-
 drivers/i2c/i2c-core-acpi.c                        |   1 +
 drivers/i3c/internals.h                            |   1 +
 drivers/i3c/master.c                               |   4 +-
 drivers/idle/intel_idle.c                          |   2 +-
 drivers/iio/adc/ad7768-1.c                         |  23 +-
 drivers/iio/adc/ad_sigma_delta.c                   |   6 +-
 drivers/iio/imu/bno055/bno055.c                    |  11 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600.h        |   8 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c  |  33 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c |  22 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.h |  10 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c   |   6 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c   |  43 ++-
 drivers/iio/imu/inv_icm42600/inv_icm42600_temp.c   |  12 +-
 drivers/iio/light/as73211.c                        |   2 +-
 drivers/iio/pressure/bmp280-core.c                 |   9 +-
 drivers/iio/proximity/isl29501.c                   |  14 +-
 drivers/iio/temperature/maxim_thermocouple.c       |  26 +-
 drivers/infiniband/core/nldev.c                    |  22 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   8 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |  30 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |   2 -
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |   2 +
 drivers/infiniband/hw/erdma/erdma_verbs.c          |   4 +-
 drivers/infiniband/hw/hfi1/affinity.c              |  44 +--
 drivers/infiniband/sw/siw/siw_qp_tx.c              |   5 +-
 drivers/iommu/amd/init.c                           |   4 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |   1 +
 drivers/iommu/iommufd/io_pagetable.c               |  48 ++-
 drivers/leds/flash/leds-qcom-flash.c               | 178 +++++++++-
 drivers/leds/leds-lp50xx.c                         |  11 +-
 drivers/leds/trigger/ledtrig-netdev.c              |  16 +-
 drivers/md/dm-ps-historical-service-time.c         |   4 +-
 drivers/md/dm-ps-queue-length.c                    |   4 +-
 drivers/md/dm-ps-round-robin.c                     |   4 +-
 drivers/md/dm-ps-service-time.c                    |   4 +-
 drivers/md/dm-table.c                              |  10 +-
 drivers/md/dm-zoned-target.c                       |   2 +-
 drivers/media/cec/usb/rainshadow/rainshadow-cec.c  |   3 +-
 drivers/media/dvb-frontends/dib7000p.c             |   8 +
 drivers/media/i2c/ccs/ccs-core.c                   |   2 +-
 drivers/media/i2c/hi556.c                          |  26 +-
 drivers/media/i2c/ov2659.c                         |   3 +-
 drivers/media/i2c/tc358743.c                       |  86 +++--
 drivers/media/pci/intel/ivsc/mei_ace.c             |   2 +
 drivers/media/pci/intel/ivsc/mei_csi.c             |   2 +
 drivers/media/platform/qcom/camss/camss.c          |   4 +-
 drivers/media/platform/qcom/venus/core.c           |   8 +-
 drivers/media/platform/qcom/venus/core.h           |   2 +
 drivers/media/platform/qcom/venus/hfi_msgs.c       |  83 +++--
 drivers/media/platform/qcom/venus/hfi_venus.c      |   5 +
 drivers/media/platform/qcom/venus/vdec.c           |   5 +-
 drivers/media/platform/qcom/venus/venc.c           |   5 +-
 .../media/platform/verisilicon/rockchip_vpu_hw.c   |   9 -
 drivers/media/test-drivers/vivid/vivid-ctrls.c     |   3 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |   4 +-
 drivers/media/usb/gspca/vicam.c                    |  10 +-
 drivers/media/usb/hdpvr/hdpvr-i2c.c                |   6 +
 drivers/media/usb/usbtv/usbtv-video.c              |   4 +
 drivers/media/usb/uvc/uvc_driver.c                 |   3 +
 drivers/media/usb/uvc/uvc_video.c                  |  21 +-
 drivers/media/v4l2-core/v4l2-common.c              |   8 +-
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |   1 -
 drivers/memstick/core/memstick.c                   |   1 -
 drivers/memstick/host/rtsx_usb_ms.c                |   1 +
 drivers/mfd/axp20x.c                               |   3 +-
 drivers/misc/cardreader/rtsx_usb.c                 |  16 +-
 drivers/misc/mei/bus.c                             |   6 +
 drivers/mmc/host/rtsx_usb_sdmmc.c                  |   4 +-
 drivers/mmc/host/sdhci-msm.c                       |  14 +
 drivers/mmc/host/sdhci-pci-gli.c                   |  35 +-
 drivers/most/core.c                                |   2 +-
 drivers/mtd/nand/raw/fsmc_nand.c                   |   2 +
 drivers/mtd/nand/raw/renesas-nand-controller.c     |   6 +
 drivers/mtd/nand/spi/core.c                        |   5 +-
 drivers/mtd/spi-nor/swp.c                          |  19 +-
 drivers/net/bonding/bond_3ad.c                     | 224 +++++++++++--
 drivers/net/bonding/bond_main.c                    |   1 +
 drivers/net/bonding/bond_netlink.c                 |  16 +
 drivers/net/bonding/bond_options.c                 |  29 +-
 drivers/net/dsa/b53/b53_common.c                   |  63 +++-
 drivers/net/dsa/b53/b53_regs.h                     |   2 +
 drivers/net/ethernet/agere/et131x.c                |  36 ++
 drivers/net/ethernet/aquantia/atlantic/aq_hw.h     |   2 +
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c   |  39 +++
 drivers/net/ethernet/atheros/ag71xx.c              |   9 +
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |   4 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |   8 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   2 -
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |   4 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |  14 +-
 drivers/net/ethernet/freescale/fec_main.c          |  34 +-
 drivers/net/ethernet/freescale/gianfar_ethtool.c   |   4 +-
 drivers/net/ethernet/google/gve/gve_adminq.c       |   1 +
 drivers/net/ethernet/google/gve/gve_main.c         |   2 +
 drivers/net/ethernet/intel/igc/igc_main.c          |  14 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   4 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |   4 +-
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |   2 +
 drivers/net/ethernet/mediatek/mtk_wed.c            |   1 -
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |  18 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c   |   2 +-
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c |   4 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   2 +
 drivers/net/ethernet/mellanox/mlxsw/trap.h         |   1 +
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   7 +-
 drivers/net/ethernet/ti/icssg/icss_iep.c           |  26 +-
 drivers/net/hyperv/hyperv_net.h                    |   3 +
 drivers/net/hyperv/netvsc_drv.c                    |  29 +-
 drivers/net/ipa/ipa_smp2p.c                        |   2 +-
 drivers/net/phy/micrel.c                           |  12 +-
 drivers/net/phy/mscc/mscc.h                        |  12 +
 drivers/net/phy/mscc/mscc_main.c                   |  12 +
 drivers/net/phy/mscc/mscc_ptp.c                    |  49 ++-
 drivers/net/phy/smsc.c                             |   1 +
 drivers/net/ppp/ppp_generic.c                      |  17 +-
 drivers/net/thunderbolt/main.c                     |  21 +-
 drivers/net/usb/asix_devices.c                     |   1 +
 drivers/net/usb/cdc_ncm.c                          |  20 +-
 drivers/net/wireless/ath/ath11k/ce.c               |   3 -
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   3 -
 drivers/net/wireless/ath/ath11k/hal.c              |  33 +-
 drivers/net/wireless/ath/ath12k/ce.c               |   3 -
 drivers/net/wireless/ath/ath12k/dp.c               |   3 +-
 drivers/net/wireless/ath/ath12k/hal.c              |  38 ++-
 drivers/net/wireless/ath/ath12k/hw.c               |   2 +-
 drivers/net/wireless/ath/ath12k/wmi.c              |   5 +
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c      |   2 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |   5 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  25 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |  23 +-
 drivers/net/wireless/realtek/rtw89/core.c          |   3 +
 drivers/net/wireless/realtek/rtw89/fw.c            |   9 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |   2 +
 drivers/net/wireless/realtek/rtw89/mac.c           |  19 ++
 drivers/net/wireless/realtek/rtw89/reg.h           |   1 +
 drivers/net/xen-netfront.c                         |   5 -
 drivers/nvme/host/pci.c                            |  24 +-
 drivers/pci/controller/dwc/pci-imx6.c              |   7 +-
 drivers/pci/controller/pcie-rockchip-host.c        |  49 +--
 drivers/pci/controller/pcie-rockchip.h             |  11 +-
 drivers/pci/endpoint/pci-ep-cfs.c                  |   1 +
 drivers/pci/endpoint/pci-epf-core.c                |   2 +-
 drivers/pci/pci-acpi.c                             |   4 +-
 drivers/pci/pci.c                                  |  10 +-
 drivers/pci/probe.c                                |   2 +-
 drivers/perf/cxl_pmu.c                             |   2 +-
 drivers/phy/qualcomm/phy-qcom-m31.c                |  14 +-
 drivers/phy/rockchip/phy-rockchip-pcie.c           |   3 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |   1 +
 drivers/platform/chrome/cros_ec.c                  |   3 +
 drivers/platform/chrome/cros_ec_typec.c            |   4 +-
 drivers/platform/x86/amd/pmc/pmc-quirks.c          |   9 +
 drivers/platform/x86/thinkpad_acpi.c               |   4 +-
 drivers/pmdomain/imx/imx8m-blk-ctrl.c              |  10 +
 drivers/power/supply/qcom_battmgr.c                |   2 +
 drivers/pps/clients/pps-gpio.c                     |   5 +-
 drivers/ptp/ptp_clock.c                            |   2 +-
 drivers/ptp/ptp_private.h                          |   5 +
 drivers/ptp/ptp_vclock.c                           |   7 +
 drivers/pwm/pwm-imx-tpm.c                          |   9 +
 drivers/pwm/pwm-mediatek.c                         |  71 ++--
 drivers/remoteproc/imx_rproc.c                     |   4 +-
 drivers/reset/Kconfig                              |  10 +-
 drivers/rtc/rtc-ds1307.c                           |  15 +-
 drivers/s390/char/sclp.c                           |  11 +-
 drivers/scsi/aacraid/comminit.c                    |   3 +-
 drivers/scsi/bfa/bfad_im.c                         |   1 +
 drivers/scsi/libiscsi.c                            |   3 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |   1 -
 drivers/scsi/lpfc/lpfc_scsi.c                      |   4 +
 drivers/scsi/mpi3mr/mpi3mr.h                       |   6 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  17 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |  22 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |  19 ++
 drivers/scsi/qla4xxx/ql4_os.c                      |   2 +
 drivers/scsi/scsi_scan.c                           |   2 +-
 drivers/scsi/scsi_transport_sas.c                  |  62 +++-
 drivers/soc/qcom/mdt_loader.c                      |  53 ++-
 drivers/soc/qcom/rpmh-rsc.c                        |   2 +-
 drivers/soc/tegra/pmc.c                            |  51 +--
 drivers/soundwire/amd_manager.c                    |   6 +-
 drivers/soundwire/bus.c                            |   6 +-
 drivers/spi/spi-fsl-lpspi.c                        |   8 +-
 drivers/staging/media/imx/imx-media-csc-scaler.c   |   2 +-
 drivers/target/target_core_fabric_lib.c            |  65 +++-
 drivers/target/target_core_internal.h              |   4 +-
 drivers/target/target_core_pr.c                    |  18 +-
 drivers/thermal/qcom/qcom-spmi-temp-alarm.c        |  43 ++-
 drivers/thermal/thermal_sysfs.c                    |   9 +-
 drivers/thunderbolt/domain.c                       |   2 +-
 drivers/tty/serial/8250/8250_port.c                |   3 +-
 drivers/tty/vt/defkeymap.c_shipped                 | 112 +++++++
 drivers/tty/vt/keyboard.c                          |   2 +-
 drivers/ufs/core/ufshcd-priv.h                     |   2 +-
 drivers/ufs/host/ufs-exynos.c                      |   4 +-
 drivers/ufs/host/ufshcd-pci.c                      |  42 ++-
 drivers/usb/atm/cxacru.c                           | 172 +++++-----
 drivers/usb/class/cdc-acm.c                        |  11 +-
 drivers/usb/core/config.c                          |  10 +-
 drivers/usb/core/hcd.c                             |   8 +-
 drivers/usb/core/quirks.c                          |   1 +
 drivers/usb/core/urb.c                             |   2 +-
 drivers/usb/dwc3/dwc3-imx8mp.c                     |   6 +-
 drivers/usb/dwc3/dwc3-meson-g12a.c                 |   3 +
 drivers/usb/dwc3/dwc3-pci.c                        |   2 +
 drivers/usb/dwc3/ep0.c                             |  20 +-
 drivers/usb/dwc3/gadget.c                          |  19 +-
 drivers/usb/gadget/udc/renesas_usb3.c              |   1 +
 drivers/usb/host/xhci-hub.c                        |   3 +-
 drivers/usb/host/xhci-mem.c                        |  24 +-
 drivers/usb/host/xhci-pci-renesas.c                |   7 +-
 drivers/usb/host/xhci-ring.c                       |  19 +-
 drivers/usb/host/xhci.c                            |  27 +-
 drivers/usb/host/xhci.h                            |   3 +-
 drivers/usb/musb/omap2430.c                        |  14 +-
 drivers/usb/storage/realtek_cr.c                   |   2 +-
 drivers/usb/storage/unusual_devs.h                 |  29 ++
 drivers/usb/typec/mux/intel_pmc_mux.c              |   2 +-
 drivers/usb/typec/tcpm/fusb302.c                   |   8 +
 drivers/usb/typec/tcpm/maxim_contaminant.c         |  54 +++
 drivers/usb/typec/tcpm/tcpci_maxim.h               |   1 +
 drivers/usb/typec/ucsi/psy.c                       |   2 +-
 drivers/usb/typec/ucsi/ucsi.c                      |   1 +
 drivers/usb/typec/ucsi/ucsi.h                      |   7 +-
 drivers/vfio/pci/mlx5/cmd.c                        |   4 +-
 drivers/vfio/vfio_iommu_type1.c                    |   7 +
 drivers/vhost/vhost.c                              |   3 +
 drivers/vhost/vsock.c                              |   6 +-
 drivers/video/console/vgacon.c                     |   2 +-
 drivers/video/fbdev/core/fbcon.c                   |   9 +-
 drivers/video/fbdev/core/fbmem.c                   |   3 +
 drivers/virt/coco/efi_secret/efi_secret.c          |  10 +-
 drivers/watchdog/dw_wdt.c                          |   2 +
 drivers/watchdog/iTCO_wdt.c                        |   6 +-
 drivers/watchdog/sbsa_gwdt.c                       |  50 ++-
 fs/btrfs/backref.c                                 |   6 +-
 fs/btrfs/block-group.c                             |  61 ++--
 fs/btrfs/block-group.h                             |  11 +-
 fs/btrfs/block-rsv.c                               |   2 +-
 fs/btrfs/block-rsv.h                               |   2 +-
 fs/btrfs/btrfs_inode.h                             |   3 +-
 fs/btrfs/ctree.c                                   |  24 +-
 fs/btrfs/ctree.h                                   |   6 +-
 fs/btrfs/delayed-inode.c                           |  12 +-
 fs/btrfs/discard.c                                 |   4 +-
 fs/btrfs/extent-tree.c                             |  33 +-
 fs/btrfs/file-item.c                               |   4 +-
 fs/btrfs/file-item.h                               |   2 +-
 fs/btrfs/free-space-tree.c                         |  17 +-
 fs/btrfs/inode-item.c                              |  10 +-
 fs/btrfs/inode-item.h                              |   4 +-
 fs/btrfs/inode.c                                   |  26 +-
 fs/btrfs/qgroup.c                                  |  31 +-
 fs/btrfs/relocation.c                              |  19 ++
 fs/btrfs/send.c                                    | 361 ++++++++++++---------
 fs/btrfs/space-info.c                              |  17 +-
 fs/btrfs/space-info.h                              |   6 +-
 fs/btrfs/tree-log.c                                |  72 ++--
 fs/btrfs/tree-mod-log.c                            |  14 +-
 fs/btrfs/tree-mod-log.h                            |   6 +-
 fs/btrfs/zoned.c                                   |  20 +-
 fs/btrfs/zoned.h                                   |   4 +-
 fs/buffer.c                                        |   2 +-
 fs/crypto/fscrypt_private.h                        |  16 +
 fs/crypto/hkdf.c                                   |   2 +-
 fs/crypto/keysetup.c                               |   3 +-
 fs/crypto/keysetup_v1.c                            |   3 +-
 fs/eventpoll.c                                     |  60 +++-
 fs/exfat/dir.c                                     |  12 +
 fs/exfat/fatent.c                                  |  10 +
 fs/exfat/namei.c                                   |   5 +
 fs/exfat/super.c                                   |  32 +-
 fs/ext2/inode.c                                    |  12 +-
 fs/ext4/fsmap.c                                    |  23 +-
 fs/ext4/indirect.c                                 |   4 +-
 fs/ext4/inline.c                                   |  19 +-
 fs/ext4/inode.c                                    |   2 +-
 fs/ext4/mballoc.c                                  |  69 ++--
 fs/ext4/orphan.c                                   |   5 +-
 fs/ext4/super.c                                    |   8 +-
 fs/f2fs/file.c                                     |  24 +-
 fs/f2fs/node.c                                     |  10 +
 fs/file.c                                          |  15 +
 fs/gfs2/meta_io.c                                  |   2 +
 fs/hfs/bfind.c                                     |   3 +
 fs/hfs/bnode.c                                     |  93 ++++++
 fs/hfs/btree.c                                     |  57 +++-
 fs/hfs/extent.c                                    |   2 +-
 fs/hfs/hfs_fs.h                                    |   1 +
 fs/hfsplus/bnode.c                                 |  92 ++++++
 fs/hfsplus/unicode.c                               |   7 +
 fs/hfsplus/xattr.c                                 |   6 +-
 fs/hugetlbfs/inode.c                               |   2 +-
 fs/jbd2/checkpoint.c                               |   1 +
 fs/jfs/file.c                                      |   3 +
 fs/jfs/inode.c                                     |   2 +-
 fs/jfs/jfs_dmap.c                                  |   6 +
 fs/libfs.c                                         |   4 +-
 fs/namespace.c                                     |  34 +-
 fs/nfs/blocklayout/blocklayout.c                   |   4 +-
 fs/nfs/blocklayout/dev.c                           |   5 +-
 fs/nfs/blocklayout/extent_tree.c                   |  20 +-
 fs/nfs/client.c                                    |  44 ++-
 fs/nfs/internal.h                                  |   2 +-
 fs/nfs/nfs4client.c                                |  20 +-
 fs/nfs/nfs4proc.c                                  |   2 +-
 fs/nfs/pnfs.c                                      |  11 +-
 fs/nfsd/nfs4state.c                                |  34 +-
 fs/ntfs3/dir.c                                     |   3 +
 fs/ntfs3/inode.c                                   |  31 +-
 fs/orangefs/orangefs-debugfs.c                     |   2 +-
 fs/smb/client/cifssmb.c                            |  10 +
 fs/smb/client/connect.c                            |  10 +-
 fs/smb/client/sess.c                               |   9 +
 fs/smb/client/smb2ops.c                            |  11 +-
 fs/smb/client/smbdirect.c                          |  24 +-
 fs/smb/server/connection.c                         |   3 +-
 fs/smb/server/connection.h                         |   7 +-
 fs/smb/server/oplock.c                             |  13 +-
 fs/smb/server/smb2pdu.c                            |  16 +-
 fs/smb/server/transport_rdma.c                     |   5 +-
 fs/smb/server/transport_rdma.h                     |   4 +-
 fs/smb/server/transport_tcp.c                      |  26 +-
 fs/squashfs/super.c                                |  14 +-
 fs/tracefs/inode.c                                 |  11 +
 fs/udf/super.c                                     |  13 +-
 fs/xfs/xfs_itable.c                                |   6 +-
 include/linux/arch_topology.h                      |   8 +
 include/linux/blk_types.h                          |   6 +-
 include/linux/compiler.h                           |   8 -
 include/linux/cpufreq.h                            |   1 +
 include/linux/energy_model.h                       |   6 +-
 include/linux/fs.h                                 |   4 +-
 include/linux/hypervisor.h                         |   3 +
 include/linux/if_vlan.h                            |  21 +-
 include/linux/iosys-map.h                          |   7 +-
 include/linux/memfd.h                              |  14 +
 include/linux/mm.h                                 |  76 +++--
 include/linux/pci.h                                |  10 +-
 include/linux/pm_runtime.h                         |  18 +-
 include/linux/sched/topology.h                     |   8 +
 include/linux/skbuff.h                             |   8 +-
 include/linux/usb/cdc_ncm.h                        |   1 +
 include/linux/virtio_vsock.h                       |   7 +-
 include/net/bond_3ad.h                             |   3 +
 include/net/bond_options.h                         |   1 +
 include/net/bonding.h                              |  23 ++
 include/net/cfg80211.h                             |   2 +-
 include/net/mac80211.h                             |   2 +
 include/net/neighbour.h                            |   1 +
 include/net/net_namespace.h                        |  16 +
 include/net/sock.h                                 |   1 +
 include/trace/events/btrfs.h                       |   6 +-
 include/trace/events/thp.h                         |   2 +
 include/uapi/linux/if_link.h                       |   1 +
 include/uapi/linux/in6.h                           |   4 +-
 include/uapi/linux/io_uring.h                      |   2 +-
 include/uapi/linux/pfrut.h                         |   1 +
 io_uring/net.c                                     |  19 +-
 kernel/bpf/verifier.c                              |   3 +-
 kernel/cgroup/cpuset.c                             |   2 +-
 kernel/fork.c                                      |   2 +-
 kernel/module/main.c                               |  10 +-
 kernel/power/console.c                             |   7 +-
 kernel/rcu/tree.c                                  |   2 +
 kernel/rcu/tree.h                                  |  14 +-
 kernel/rcu/tree_plugin.h                           |  44 ++-
 kernel/sched/cpufreq_schedutil.c                   |  30 +-
 kernel/sched/fair.c                                |  19 +-
 kernel/trace/ftrace.c                              |  19 +-
 kernel/trace/trace.c                               |  33 +-
 kernel/trace/trace.h                               |  10 +-
 mm/debug_vm_pgtable.c                              |   9 +-
 mm/filemap.c                                       |   2 +-
 mm/kmemleak.c                                      |  10 +-
 mm/madvise.c                                       |   2 +-
 mm/memfd.c                                         |   2 +-
 mm/memory-failure.c                                |   8 +
 mm/mmap.c                                          |  12 +-
 mm/ptdump.c                                        |   2 +
 mm/shmem.c                                         |   2 +-
 net/bluetooth/hci_conn.c                           |   3 +-
 net/bluetooth/hci_event.c                          |   8 +-
 net/bluetooth/hci_sock.c                           |   2 +-
 net/bridge/br_multicast.c                          |  16 +
 net/bridge/br_private.h                            |   2 +
 net/core/dev.c                                     |  12 +
 net/core/neighbour.c                               |  12 +-
 net/core/net_namespace.c                           |   8 +-
 net/core/sock.c                                    |  27 +-
 net/hsr/hsr_slave.c                                |   8 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |   6 +-
 net/ipv4/route.c                                   |   1 -
 net/ipv4/udp_offload.c                             |   2 +-
 net/ipv6/addrconf.c                                |   7 +-
 net/ipv6/mcast.c                                   |  11 +-
 net/ipv6/netfilter/nf_reject_ipv6.c                |   5 +-
 net/ipv6/seg6_hmac.c                               |   6 +-
 net/mac80211/cfg.c                                 |  12 +-
 net/mac80211/chan.c                                |   1 +
 net/mac80211/mlme.c                                |   9 +-
 net/mac80211/rx.c                                  |  12 +-
 net/mctp/af_mctp.c                                 |  28 +-
 net/mptcp/options.c                                |   6 +-
 net/mptcp/pm_netlink.c                             |  19 +-
 net/mptcp/subflow.c                                |   5 +-
 net/ncsi/internal.h                                |   2 +-
 net/ncsi/ncsi-rsp.c                                |   1 +
 net/netfilter/nf_conntrack_netlink.c               |  24 +-
 net/netlink/af_netlink.c                           |  12 +-
 net/rds/tcp.c                                      |   8 +-
 net/sched/sch_cake.c                               |  14 +-
 net/sched/sch_ets.c                                |  36 +-
 net/sched/sch_htb.c                                |   2 +-
 net/sctp/input.c                                   |   2 +-
 net/smc/af_smc.c                                   |   8 +-
 net/sunrpc/svcsock.c                               |   5 +-
 net/sunrpc/xprtsock.c                              |   8 +-
 net/tls/tls.h                                      |   2 +-
 net/tls/tls_strp.c                                 |  11 +-
 net/tls/tls_sw.c                                   |  10 +-
 net/vmw_vsock/virtio_transport.c                   |  14 +-
 net/wireless/mlme.c                                |   3 +-
 net/xfrm/xfrm_state.c                              |  74 +++--
 scripts/kconfig/gconf.c                            |   8 +-
 scripts/kconfig/lxdialog/inputbox.c                |   6 +-
 scripts/kconfig/lxdialog/menubox.c                 |   2 +-
 scripts/kconfig/nconf.c                            |   2 +
 scripts/kconfig/nconf.gui.c                        |   1 +
 security/apparmor/file.c                           |   6 +-
 security/apparmor/include/lib.h                    |   6 +-
 security/inode.c                                   |   2 -
 sound/core/pcm_native.c                            |  19 +-
 sound/hda/hdac_device.c                            |   2 +-
 sound/pci/hda/hda_codec.c                          |  44 +--
 sound/pci/hda/patch_ca0132.c                       |   2 +-
 sound/pci/hda/patch_realtek.c                      |   4 +
 sound/pci/intel8x0.c                               |   2 +-
 sound/soc/codecs/hdac_hdmi.c                       |  10 +-
 sound/soc/codecs/rt5640.c                          |   5 +
 sound/soc/fsl/fsl_sai.c                            |  20 +-
 sound/soc/intel/avs/core.c                         |   3 +-
 sound/soc/qcom/lpass-platform.c                    |  27 +-
 sound/soc/soc-core.c                               |   3 +
 sound/soc/soc-dapm.c                               |   4 +
 sound/usb/mixer_quirks.c                           |  14 +-
 sound/usb/stream.c                                 |  25 +-
 sound/usb/validate.c                               |  14 +-
 tools/bpf/bpftool/main.c                           |   6 +-
 tools/include/nolibc/std.h                         |   4 +-
 tools/include/nolibc/types.h                       |   4 +-
 tools/include/uapi/linux/if_link.h                 |   1 +
 .../cpupower/utils/idle_monitor/mperf_monitor.c    |   4 +-
 tools/scripts/Makefile.include                     |   4 +-
 tools/testing/ktest/ktest.pl                       |   5 +-
 tools/testing/selftests/arm64/fp/sve-ptrace.c      |   3 +-
 .../selftests/bpf/prog_tests/user_ringbuf.c        |  10 +-
 .../testing/selftests/bpf/progs/verifier_unpriv.c  |   2 +-
 .../ftrace/test.d/ftrace/func-filter-glob.tc       |   2 +-
 tools/testing/selftests/futex/include/futextest.h  |  11 +
 tools/testing/selftests/memfd/memfd_test.c         |  43 +++
 tools/testing/selftests/net/mptcp/pm_netlink.sh    |   1 +
 612 files changed, 6034 insertions(+), 2714 deletions(-)


