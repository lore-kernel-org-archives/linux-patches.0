Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D671D2BD033;
	Mon, 27 Oct 2025 19:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593161; cv=none; b=Vdfyxr8PIiT/EJFiIFpdS2RHxmtlKqi13U77O0WELgBulvOTxkuNpTSs2e2O5Owbps3+wnJa9VfInvfFN1X1h6hnnbO9kH5p2bMRUJDXS53mpL18ptCDLMqXVbP3TV2wMdyIm/WN+4P6NNffBkN4ljqpZsvaNBPVeZI6+ooCtYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593161; c=relaxed/simple;
	bh=uOEYzVkwWofA/H6xMTQU/3qfGva8MoKLI2YKoaQL9Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fo8KGKnRK8JPQ6irxjRrbsGP2VcVm+T2Gtvabq/nNzvy4EoCl6gjr2LD8UCkmP35QAz5UE4I8hbN9fJkQ6R8CBdLPkEd4r9W2Buf5bv4hgV7F7MffxlbjgwFX61tAFMYJTi7OVNZr1QW7s5IUTa+eGHpeyAAD8j2DJBwlaGG0mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zO8Aw1oa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zO8Aw1oa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1784FC4CEF1;
	Mon, 27 Oct 2025 19:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593161;
	bh=uOEYzVkwWofA/H6xMTQU/3qfGva8MoKLI2YKoaQL9Pg=;
	h=From:To:Cc:Subject:Date:From;
	b=zO8Aw1oa4b8NbHry6FX2vKGCNobLcZRY+xhKXzbgV1/7gmEf2IVNSGx07xBcs1G90
	 mmoCEvQ4N9wGYX/oy7cQvcbEj2ZI39AZVhDNyxztElmK09D5jFTTeO/uytE6oTlcnW
	 xRM5MftK5K9eFumEOwjorM/UiPwiuhdzSQDdYWjY=
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.17 000/184] 6.17.6-rc1 review
Date: Mon, 27 Oct 2025 19:34:42 +0100
Message-ID: <20251027183514.934710872@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.6-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.17.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.17.6-rc1
X-KernelTest-Deadline: 2025-10-29T18:35+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.17.6 release.
There are 184 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.6-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.17.6-rc1

William Breathitt Gray <wbg@kernel.org>
    gpio: idio-16: Define fixed direction of the GPIO lines

Ioana Ciornei <ioana.ciornei@nxp.com>
    gpio: regmap: add the .fixed_direction_output configuration parameter

Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>
    gpio: regmap: Allow to allocate regmap-irq device

Darrick J. Wong <djwong@kernel.org>
    xfs: always warn about deprecated mount options

David Hildenbrand <david@redhat.com>
    vmw_balloon: indicate success when effectively deflating during migration

David Hildenbrand <david@redhat.com>
    treewide: remove MIGRATEPAGE_SUCCESS

David Hildenbrand <david@redhat.com>
    mm/migrate: remove MIGRATEPAGE_UNMAP

Dave Penkler <dpenkler@gmail.com>
    staging: gpib: Fix sending clear and trigger events

Dave Penkler <dpenkler@gmail.com>
    staging: gpib: Return -EINTR on device clear

Dave Penkler <dpenkler@gmail.com>
    staging: gpib: Fix no EOI on 1 and 2 byte writes

Ma Ke <make24@iscas.ac.cn>
    staging: gpib: Fix device reference leak in fmh_gpib driver

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: remove useless enable of enhanced features

Daniel Golle <daniel@makrotopia.org>
    serial: 8250_mtk: Enable baud clock and manage in runtime PM

Florian Eckert <fe@dev.tdt.de>
    serial: 8250_exar: add support for Advantech 2 port card with Device ID 0x0018

Artem Shimko <a.shimko.dev@gmail.com>
    serial: 8250_dw: handle reset control deassert error

Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
    dt-bindings: usb: qcom,snps-dwc3: Fix bindings for X1E80100

Xu Yang <xu.yang_2@nxp.com>
    dt-bindings: usb: dwc3-imx8mp: dma-range is required only for imx8mp

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: serial: sh-sci: Fix r8a78000 interrupts

Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
    tty: serial: sh-sci: fix RSCI FIFO overrun handling

Michael Grzeschik <m.grzeschik@pengutronix.de>
    tcpm: switch check for role_sw device with fw_node

Victoria Votokina <Victoria.Votokina@kaspersky.com>
    most: usb: hdm_probe: Fix calling put_device() before device initialization

Victoria Votokina <Victoria.Votokina@kaspersky.com>
    most: usb: Fix use-after-free in hdm_disconnect

Junhao Xie <bigfoot@radxa.com>
    misc: fastrpc: Fix dma_buf object leak in fastrpc_map_lookup

Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
    nvmem: rcar-efuse: add missing MODULE_DEVICE_TABLE

Miguel Ojeda <ojeda@kernel.org>
    objtool/rust: add one more `noreturn` Rust function

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add wildcat lake P DID

Deepanshu Kartikey <kartikey406@gmail.com>
    comedi: fix divide-by-zero in comedi_buf_munge()

Alice Ryhl <aliceryhl@google.com>
    binder: remove "invalid inc weak" check

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/microcode: Fix Entrysign revision check for Zen1/Naples

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: fix bogus 1024 byte prefix if ttyDBC read races with stall event

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: enable back DbC in resume if it was enabled before suspend

Andrey Konovalov <andreyknvl@gmail.com>
    usb: raw-gadget: do not limit transfer length

Tim Guttzeit <t.guttzeit@tuxedocomputers.com>
    usb/core/quirks: Add Huawei ME906S to wakeup quirk

LI Qingwu <Qing-wu.Li@leica-geosystems.com.cn>
    USB: serial: option: add Telit FN920C04 ECM compositions

Reinhard Speyerer <rspmn@arcor.de>
    USB: serial: option: add Quectel RG255C

Renjun Wang <renjunw0@foxmail.com>
    USB: serial: option: add UNISOC UIS7720

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    sched: Remove never used code in mm_cid_get()

Alok Tiwari <alok.a.tiwari@oracle.com>
    io_uring: correct __must_hold annotation in io_install_fixed_file

Haotian Zhang <vulab@iscas.ac.cn>
    gpio: ljca: Fix duplicated IRQ mapping

Christoph Hellwig <hch@lst.de>
    block: require LBA dma_alignment when using PI

Lorenzo Pieralisi <lpieralisi@kernel.org>
    of/irq: Add msi-parent check to of_msi_xlate()

Lorenzo Pieralisi <lpieralisi@kernel.org>
    of/irq: Convert of_msi_map_id() callers to of_msi_xlate()

Jocelyn Falempe <jfalempe@redhat.com>
    drm/panic: Fix 24bit pixel crossing page boundaries

Jocelyn Falempe <jfalempe@redhat.com>
    drm/panic: Fix qr_code, ensure vmargin is positive

Jocelyn Falempe <jfalempe@redhat.com>
    drm/panic: Fix drawing the logo on a small narrow screen

Ondrej Mosnacek <omosnace@redhat.com>
    nbd: override creds to kernel when calling sock_{send,recv}msg()

Alok Tiwari <alok.a.tiwari@oracle.com>
    io_uring: fix incorrect unlikely() usage in io_waitid_prep()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (sht3x) Fix error handling

Li Qiang <liqiang01@kylinos.cn>
    hwmon: (cgbc-hwmon) Add missing NULL check after devm_kzalloc()

Erick Karanja <karanja99erick@gmail.com>
    hwmon: (pmbus/isl68137) Fix child node reference leak on early return

Paul Walmsley <pjw@kernel.org>
    riscv: hwprobe: avoid uninitialized variable use in hwprobe_arch_id()

Anup Patel <apatel@ventanamicro.com>
    RISC-V: Don't print details of CPUs disabled in DT

Anup Patel <apatel@ventanamicro.com>
    RISC-V: Define pgprot_dmacoherent() for non-coherent devices

Akash Goel <akash.goel@arm.com>
    drm/panthor: Fix kernel panic on partial unmap of a GPU VA region

Fernando Fernandez Mancera <fmancera@suse.de>
    sysfs: check visibility before changing group attribute ownership

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    spi: airoha: fix reading/writing of flashes with more than one plane per lun

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    spi: airoha: switch back to non-dma mode in the case of error

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    spi: airoha: add support of dual/quad wires spi modes to exec_op() handler

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    spi: airoha: return an error for continuous mode dirmap creation cases

Artem Shimko <a.shimko.dev@gmail.com>
    firmware: arm_scmi: Fix premature SCMI_XFER_FLAG_IS_RAW clearing in raw mode

Cristian Marussi <cristian.marussi@arm.com>
    include: trace: Fix inflight count helper on failed initialization

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Account for failed debug initialization

Peter Robinson <pbrobinson@gmail.com>
    arm64: dts: broadcom: bcm2712: Define VGIC interrupt

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: broadcom: bcm2712: Add default GIC address cells

Mattijs Korpershoek <mkorpershoek@kernel.org>
    spi: cadence-quadspi: Fix pm_runtime unbalance on dma EPROBE_DEFER

Haibo Chen <haibo.chen@nxp.com>
    spi: spi-nxp-fspi: limit the clock rate for different sample clock source selection

Han Xu <han.xu@nxp.com>
    spi: spi-nxp-fspi: add extra delay after dll locked

Haibo Chen <haibo.chen@nxp.com>
    spi: spi-nxp-fspi: re-config the clock rate when operation require new clock rate

Haibo Chen <haibo.chen@nxp.com>
    spi: spi-nxp-fspi: add the support for sample data from DQS pad

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_ffa: Add support for IMPDEF value in the memory access descriptor

Marek Szyprowski <m.szyprowski@samsung.com>
    spi: rockchip-sfc: Fix DMA-API usage

SeongJae Park <sj@kernel.org>
    mm/damon/sysfs: dealloc commit test ctx always

SeongJae Park <sj@kernel.org>
    mm/damon/sysfs: catch commit test ctx alloc failure

Enze Li <lienze@kylinos.cn>
    mm/damon/core: fix potential memory leak by cleaning ops_filter in damon_destroy_scheme

SeongJae Park <sj@kernel.org>
    mm/damon/core: fix list_add_tail() call on damon_call()

SeongJae Park <sj@kernel.org>
    mm/damon/core: use damos_commit_quota_goal() for new goal commit

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: increase max link count and fix link->enc NULL pointer access

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Check return value of GGTT workqueue allocation

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm/mremap: correctly account old mapping after MREMAP_DONTUNMAP remap

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    mm: prevent poison consumption when splitting THP

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: mark 'delete re-add signal' as skipped if not supported

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: mark implicit tests as skipped if not supported

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: mark 'flush re-add' as skipped if not supported

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: in-kernel: C-flag: handle late ADD_ADDR

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    net: ravb: Ensure memory write completes before ringing TX doorbell

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    net: ravb: Enforce descriptor type ordering

Michal Pecio <michal.pecio@gmail.com>
    net: usb: rtl8150: Fix frame padding

Sebastian Reichel <sebastian.reichel@collabora.com>
    net: stmmac: dwmac-rk: Fix disabling set_clock_selection

Tonghao Zhang <tonghao@bamaicloud.com>
    net: bonding: update the slave array for broadcast mode

Stefano Garzarella <sgarzare@redhat.com>
    vsock: fix lock inversion in vsock_assign_transport()

Nam Cao <namcao@linutronix.de>
    rv: Make rtapp/pagefault monitor depends on CONFIG_MMU

Nam Cao <namcao@linutronix.de>
    rv: Fully convert enabled_monitors to use list_head as iterator

Deepanshu Kartikey <kartikey406@gmail.com>
    ocfs2: clear extent cache after moving/defragmenting extents

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Malta: Fix keyboard resource preventing i8042 driver from registering

Alexis Czezar Torreno <alexisczezar.torreno@analog.com>
    hwmon: (pmbus/max34440) Update adpm12160 coeff due to latest FW

Maarten Lankhorst <dev@lankhorst.se>
    devcoredump: Fix circular locking dependency with devcd->mutex.

David Howells <dhowells@redhat.com>
    cifs: Fix TCP_Server_Info::credits to be signed

Marc Kleine-Budde <mkl@pengutronix.de>
    can: netlink: can_changelink(): allow disabling of automatic restart

Catalin Marinas <catalin.marinas@arm.com>
    arm64: mte: Do not warn if the page is already tagged in copy_highpage()

Xi Ruoyao <xry111@xry111.site>
    ACPICA: Work around bogus -Wstringop-overread warning since GCC 11

Paulo Alcantara <pc@manguebit.org>
    smb: client: get rid of d_drop() in cifs_do_rename()

Hao Ge <gehao@kylinos.cn>
    slab: Fix obj_ext mistakenly considered NULL due to race condition

Hao Ge <gehao@kylinos.cn>
    slab: Avoid race on slab->obj_exts in alloc_slab_obj_exts

Danilo Krummrich <dakr@kernel.org>
    rust: device: fix device context of Device::parent()

Paul Walmsley <pjw@kernel.org>
    riscv: cpufeature: avoid uninitialized variable in has_thead_homogeneous_vlenb()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "cpuidle: menu: Avoid discarding useful information"

Kurt Borja <kuurtb@gmail.com>
    platform/x86: alienware-wmi-wmax: Fix NULL pointer dereference in sleep handlers

tr1x_em <admin@trix.is-a.dev>
    platform/x86: alienware-wmi-wmax: Add AWCC support to Dell G15 5530

Darrick J. Wong <djwong@kernel.org>
    xfs: fix locking in xchk_nlinks_collect_dir

William Breathitt Gray <wbg@kernel.org>
    gpio: 104-idio-16: Define maximum valid register address offset

William Breathitt Gray <wbg@kernel.org>
    gpio: pci-idio-16: Define maximum valid register address offset

Amit Dhingra <mechanicalamit@gmail.com>
    btrfs: ref-verify: fix IS_ERR() vs NULL check in btrfs_build_ref_tree()

Ting-Chang Hou <tchou@synology.com>
    btrfs: send: fix duplicated rmdir operations when using extrefs

Dewei Meng <mengdewei@cqsoftware.com.cn>
    btrfs: directly free partially initialized fs_info in btrfs_check_leaked_roots()

Jens Axboe <axboe@kernel.dk>
    io_uring/sqpoll: be smarter on when to update the stime usage

Jens Axboe <axboe@kernel.dk>
    io_uring/sqpoll: switch away from getrusage() for CPU accounting

Jingwei Wang <wangjingwei@iscas.ac.cn>
    riscv: hwprobe: Fix stale vDSO data for late-initialized keys at boot

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    arch_topology: Fix incorrect error check in topology_parse_cpu_capacity()

Jason Wang <jasowang@redhat.com>
    virtio-net: zero unused hash fields

Marek Szyprowski <m.szyprowski@samsung.com>
    dma-debug: don't report false positives with DMA_BOUNCE_UNALIGNED_KMALLOC

Alexei Starovoitov <ast@kernel.org>
    mm: don't spin in add_stack_record when gfp flags don't allow

Lance Yang <lance.yang@linux.dev>
    hung_task: fix warnings caused by unaligned lock pointers

Tonghao Zhang <tonghao@bamaicloud.com>
    net: bonding: fix possible peer notify event loss or dup issue

Jakub Acs <acsjakub@amazon.de>
    fs/notify: call exportfs_encode_fid with s_umount

Patrisious Haddad <phaddad@nvidia.com>
    net/mlx5: Fix IPsec cleanup over MPV device

Robert Marko <robert.marko@sartura.hr>
    net: phy: micrel: always set shared->phydev for LAN8814

Ralf Lici <ralf@mandelbit.com>
    ovpn: use datagram_poll_queue for socket readiness in TCP

Ralf Lici <ralf@mandelbit.com>
    net: datagram: introduce datagram_poll_queue for custom receive queues

Ralf Lici <ralf@mandelbit.com>
    espintcp: use datagram_poll_queue for socket readiness

Fernando Fernandez Mancera <fmancera@suse.de>
    net: hsr: prevent creation of HSR device with slaves from another netns

Alexey Simakov <bigalex934@gmail.com>
    sctp: avoid NULL dereference when chunk data buffer is missing

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    ptp: ocp: Fix typo using index 1 instead of i in SMA initialization loop

Heiner Kallweit <hkallweit1@gmail.com>
    net: hibmcge: select FIXED_PHY

Gao Xiang <xiang@kernel.org>
    erofs: avoid infinite loops due to corrupted subpage compact indexes

Huang Ying <ying.huang@linux.alibaba.com>
    arm64, mm: avoid always making PTE dirty in pte_mkwrite()

Aksh Garg <a-garg7@ti.com>
    net: ethernet: ti: am65-cpts: fix timestamp loss due to race conditions

Wang Liang <wangliang74@huawei.com>
    net/smc: fix general protection fault in __smc_diag_dump

Amery Hung <ameryhung@gmail.com>
    net/mlx5e: RX, Fix generating skb from non-linear xdp_buff for striding RQ

Amery Hung <ameryhung@gmail.com>
    net/mlx5e: RX, Fix generating skb from non-linear xdp_buff for legacy RQ

Xin Long <lucien.xin@gmail.com>
    selftests: net: fix server bind failure in sctp_vrf.sh

Marc Kleine-Budde <mkl@pengutronix.de>
    can: rockchip-canfd: rkcanfd_start_xmit(): use can_dev_dropped_skb() instead of can_dropped_invalid_skb()

Marc Kleine-Budde <mkl@pengutronix.de>
    can: esd: acc_start_xmit(): use can_dev_dropped_skb() instead of can_dropped_invalid_skb()

Marc Kleine-Budde <mkl@pengutronix.de>
    can: bxcan: bxcan_start_xmit(): use can_dev_dropped_skb() instead of can_dropped_invalid_skb()

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: phy: realtek: fix rtl8221b-vm-cg name

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-eth: fix the pointer passed to PTR_ALIGN on Tx path

Wei Fang <wei.fang@nxp.com>
    net: enetc: correct the value of ENETC_RXB_TRUESIZE

Jianpeng Chang <jianpeng.chang.cn@windriver.com>
    net: enetc: fix the deadlock of enetc_mdio_lock

Gao Xiang <xiang@kernel.org>
    erofs: fix crafted invalid cases for encoded extents

Johannes Wiesböck <johannes.wiesboeck@aisec.fraunhofer.de>
    rtnetlink: Allow deleting FDB entries in user namespace

Nathan Chancellor <nathan@kernel.org>
    net/mlx5e: Return 1 instead of 0 in invalid case in mlx5e_mpwrq_umr_entry_size()

Mario Limonciello (AMD) <superm1@kernel.org>
    cpufreq/amd-pstate: Fix a regression leading to EPP 0 after hibernate

David Thompson <davthompson@nvidia.com>
    platform/mellanox: mlxbf-pmc: add sysfs_attr_init() to count_clock init

Linus Torvalds <torvalds@linux-foundation.org>
    Unbreak 'make tools/*' for user-space targets

Stefan Metzmacher <metze@samba.org>
    smb: server: let smb_direct_flush_send_list() invalidate a remote key first

Stefan Metzmacher <metze@samba.org>
    smb: client: make use of ib_wc_status_msg() and skip IB_WC_WR_FLUSH_ERR logging

Stefan Metzmacher <metze@samba.org>
    smb: client: limit the range of info->receive_credit_target

Stefan Metzmacher <metze@samba.org>
    smb: client: queue post_recv_credits_work also if the peer raises the credit target

Heiko Carstens <hca@linux.ibm.com>
    s390/mm: Use __GFP_ACCOUNT for user page table allocations

Yicong Yang <yangyicong@hisilicon.com>
    drivers/perf: hisi: Relax the event ID check in the framework

Clément Léger <cleger@rivosinc.com>
    riscv: cpufeature: add validation for zfa, zfh and zfhmin

Junhui Liu <junhui.liu@pigmoral.tech>
    riscv: mm: Use mmu-type from FDT to limit SATP mode

Junhui Liu <junhui.liu@pigmoral.tech>
    riscv: mm: Return intended SATP mode for noXlvl options

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Remove PAGE_KERNEL_TEXT to fix startup failure

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k: bitops: Fix find_*_bit() signatures

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix unlikely race in gdlm_put_lock

Fuad Tabba <tabba@google.com>
    arm64: sysreg: Correct sign definitions for EIESB and DoubleLock

Junjie Cao <junjie.cao@intel.com>
    lkdtm: fortify: Fix potential NULL dereference on kmalloc failure

Kees Cook <kees@kernel.org>
    PCI: Test for bit underflow in pcie_set_readrq()

Yangtao Li <frank.li@vivo.com>
    hfsplus: return EIO when type of hidden directory mismatch in hfsplus_fill_super()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: fix KMSAN uninit-value issue in hfs_find_set_zero_bits()

Alexander Aring <aahringo@redhat.com>
    dlm: check for defined force value in dlm_lockspace_release

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix KMSAN uninit-value issue in hfsplus_delete_cat()

Yang Chenzhi <yang.chenzhi@vivo.com>
    hfs: validate record offset in hfsplus_bmap_alloc

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix KMSAN uninit-value issue in __hfsplus_ext_cache_extent()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: make proper initalization of struct hfs_find_data

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: clear offset and space out of valid records in b-tree node

Harald Freudenberger <freude@linux.ibm.com>
    s390/pkey: Forward keygenflags to ep11_unwrapkey

Simon Schuster <schuster.simon@siemens-energy.com>
    nios2: ensure that memblock.current_limit is set when setting pfn limits

Xichao Zhao <zhao.xichao@vivo.com>
    exec: Fix incorrect type for ret

Alexander Aring <aahringo@redhat.com>
    dlm: move to rinfo for all middle conversion cases

Randy Dunlap <rdunlap@infradead.org>
    cgroup/misc: fix misc_res_type kernel-doc warning

Jan Kara <jack@suse.cz>
    expfs: Fix exportfs_can_encode_fh() for EXPORT_FH_FID

Nipun Gupta <nipun.gupta@amd.com>
    vfio/cdx: update driver to build without CONFIG_GENERIC_MSI_IRQ

K Prateek Nayak <kprateek.nayak@amd.com>
    sched/fair: Block delayed tasks on throttled hierarchy during dequeue


-------------

Diffstat:

 .../devicetree/bindings/serial/renesas,scif.yaml   |   1 +
 .../devicetree/bindings/usb/fsl,imx8mp-dwc3.yaml   |  10 +-
 .../devicetree/bindings/usb/qcom,snps-dwc3.yaml    |   3 +
 Makefile                                           |   8 +-
 arch/arm64/boot/dts/broadcom/bcm2712.dtsi          |   3 +
 arch/arm64/include/asm/pgtable.h                   |   3 +-
 arch/arm64/mm/copypage.c                           |  11 +-
 arch/arm64/tools/sysreg                            |   4 +-
 arch/m68k/include/asm/bitops.h                     |  25 ++--
 arch/mips/mti-malta/malta-setup.c                  |   2 +-
 arch/nios2/kernel/setup.c                          |  15 +++
 arch/powerpc/include/asm/pgtable.h                 |  12 --
 arch/powerpc/mm/book3s32/mmu.c                     |   4 +-
 arch/powerpc/mm/pgtable_32.c                       |   2 +-
 arch/powerpc/platforms/pseries/cmm.c               |   2 +-
 arch/riscv/include/asm/hwprobe.h                   |   7 ++
 arch/riscv/include/asm/pgtable.h                   |   2 +
 arch/riscv/include/asm/vdso/arch_data.h            |   6 +
 arch/riscv/kernel/cpu.c                            |   4 +-
 arch/riscv/kernel/cpufeature.c                     |  10 +-
 arch/riscv/kernel/pi/cmdline_early.c               |   4 +-
 arch/riscv/kernel/pi/fdt_early.c                   |  40 ++++++
 arch/riscv/kernel/pi/pi.h                          |   1 +
 arch/riscv/kernel/sys_hwprobe.c                    |  94 ++++++++++----
 arch/riscv/kernel/unaligned_access_speed.c         |   9 +-
 arch/riscv/kernel/vdso/hwprobe.c                   |   2 +-
 arch/riscv/mm/init.c                               |  11 +-
 arch/s390/mm/pgalloc.c                             |  13 +-
 arch/x86/kernel/cpu/microcode/amd.c                |   2 +-
 block/blk-settings.c                               |  10 ++
 drivers/acpi/acpica/tbprint.c                      |   6 +
 drivers/android/binder.c                           |  11 +-
 drivers/base/arch_topology.c                       |   2 +-
 drivers/base/devcoredump.c                         | 136 +++++++++++++--------
 drivers/block/nbd.c                                |  15 +++
 drivers/comedi/comedi_buf.c                        |   2 +-
 drivers/cpufreq/amd-pstate.c                       |   6 +-
 drivers/cpuidle/governors/menu.c                   |  21 ++--
 drivers/firmware/arm_ffa/driver.c                  |  37 ++++--
 drivers/firmware/arm_scmi/common.h                 |  32 ++++-
 drivers/firmware/arm_scmi/driver.c                 |  54 +++-----
 drivers/gpio/gpio-104-idio-16.c                    |   1 +
 drivers/gpio/gpio-idio-16.c                        |   5 +
 drivers/gpio/gpio-ljca.c                           |  14 +--
 drivers/gpio/gpio-pci-idio-16.c                    |   1 +
 drivers/gpio/gpio-regmap.c                         |  53 +++++++-
 .../drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c  |   3 +
 drivers/gpu/drm/amd/display/dc/inc/hw/hw_shared.h  |   8 +-
 drivers/gpu/drm/drm_panic.c                        |  54 +++++++-
 drivers/gpu/drm/panthor/panthor_mmu.c              |  10 +-
 drivers/gpu/drm/xe/xe_ggtt.c                       |   3 +
 drivers/hwmon/cgbc-hwmon.c                         |   3 +
 drivers/hwmon/pmbus/isl68137.c                     |   3 +-
 drivers/hwmon/pmbus/max34440.c                     |  12 +-
 drivers/hwmon/sht3x.c                              |  27 ++--
 drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c        |   2 +-
 drivers/misc/fastrpc.c                             |   2 +
 drivers/misc/lkdtm/fortify.c                       |   6 +
 drivers/misc/mei/hw-me-regs.h                      |   2 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/misc/vmw_balloon.c                         |   8 +-
 drivers/most/most_usb.c                            |  13 +-
 drivers/net/bonding/bond_main.c                    |  47 ++++---
 drivers/net/can/bxcan.c                            |   2 +-
 drivers/net/can/dev/netlink.c                      |   6 +-
 drivers/net/can/esd/esdacc.c                       |   2 +-
 drivers/net/can/rockchip/rockchip_canfd-tx.c       |   2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   3 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |  25 +++-
 drivers/net/ethernet/freescale/enetc/enetc.h       |   2 +-
 drivers/net/ethernet/hisilicon/Kconfig             |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |   5 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |  25 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  51 ++++++--
 drivers/net/ethernet/renesas/ravb_main.c           |  24 +++-
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |   9 +-
 drivers/net/ethernet/ti/am65-cpts.c                |  63 +++++++---
 drivers/net/ovpn/tcp.c                             |  26 +++-
 drivers/net/phy/micrel.c                           |   4 +-
 drivers/net/phy/realtek/realtek_main.c             |  16 +--
 drivers/net/usb/rtl8150.c                          |  11 +-
 drivers/nvmem/rcar-efuse.c                         |   1 +
 drivers/of/irq.c                                   |  62 ++++++----
 drivers/pci/msi/irqdomain.c                        |   2 +-
 drivers/pci/pci.c                                  |   6 +-
 drivers/perf/hisilicon/hisi_uncore_pmu.c           |   2 +-
 drivers/perf/hisilicon/hisi_uncore_pmu.h           |   3 +-
 drivers/platform/mellanox/mlxbf-pmc.c              |   1 +
 drivers/platform/x86/dell/alienware-wmi-wmax.c     |  12 +-
 drivers/ptp/ptp_ocp.c                              |   2 +-
 drivers/s390/crypto/zcrypt_ep11misc.c              |   4 +-
 drivers/spi/spi-airoha-snfi.c                      | 128 ++++++++++++++-----
 drivers/spi/spi-cadence-quadspi.c                  |   5 +-
 drivers/spi/spi-nxp-fspi.c                         |  80 +++++++++++-
 drivers/spi/spi-rockchip-sfc.c                     |  12 +-
 .../staging/gpib/agilent_82350b/agilent_82350b.c   |  12 +-
 drivers/staging/gpib/fmh_gpib/fmh_gpib.c           |   5 +
 drivers/staging/gpib/ni_usb/ni_usb_gpib.c          |  13 +-
 drivers/tty/serial/8250/8250_dw.c                  |   4 +-
 drivers/tty/serial/8250/8250_exar.c                |  11 ++
 drivers/tty/serial/8250/8250_mtk.c                 |   6 +-
 drivers/tty/serial/sc16is7xx.c                     |   7 --
 drivers/tty/serial/sh-sci.c                        |  14 ++-
 drivers/usb/core/quirks.c                          |   2 +
 drivers/usb/gadget/legacy/raw_gadget.c             |   2 -
 drivers/usb/host/xhci-dbgcap.c                     |  15 ++-
 drivers/usb/serial/option.c                        |  10 ++
 drivers/usb/typec/tcpm/tcpm.c                      |   4 +-
 drivers/vfio/cdx/Makefile                          |   6 +-
 drivers/vfio/cdx/private.h                         |  14 +++
 drivers/virtio/virtio_balloon.c                    |   2 +-
 fs/aio.c                                           |   2 +-
 fs/btrfs/inode.c                                   |   4 +-
 fs/btrfs/ref-verify.c                              |   2 +-
 fs/btrfs/send.c                                    |  56 +++++++--
 fs/btrfs/super.c                                   |   8 +-
 fs/dlm/lock.c                                      |   2 +-
 fs/dlm/lockspace.c                                 |   2 +-
 fs/dlm/recover.c                                   |   2 +-
 fs/erofs/zmap.c                                    |  39 +++---
 fs/exec.c                                          |   2 +-
 fs/gfs2/lock_dlm.c                                 |  11 +-
 fs/hfs/bfind.c                                     |   8 +-
 fs/hfs/brec.c                                      |  27 +++-
 fs/hfs/mdb.c                                       |   2 +-
 fs/hfsplus/bfind.c                                 |   8 +-
 fs/hfsplus/bnode.c                                 |  41 -------
 fs/hfsplus/btree.c                                 |   6 +
 fs/hfsplus/hfsplus_fs.h                            |  42 +++++++
 fs/hfsplus/super.c                                 |  25 +++-
 fs/hugetlbfs/inode.c                               |   4 +-
 fs/jfs/jfs_metapage.c                              |   8 +-
 fs/notify/fdinfo.c                                 |   6 +
 fs/ocfs2/move_extents.c                            |   5 +
 fs/smb/client/cifsglob.h                           |   2 +-
 fs/smb/client/inode.c                              |   5 +-
 fs/smb/client/smbdirect.c                          |  30 +++--
 fs/smb/client/smbdirect.h                          |   2 +-
 fs/smb/server/transport_rdma.c                     |  11 +-
 fs/sysfs/group.c                                   |  26 +++-
 fs/xfs/scrub/nlinks.c                              |  34 +++++-
 fs/xfs/xfs_super.c                                 |  33 +++--
 include/linux/arm_ffa.h                            |  21 +++-
 include/linux/exportfs.h                           |   7 +-
 include/linux/gpio/regmap.h                        |  16 +++
 include/linux/hung_task.h                          |   8 +-
 include/linux/migrate.h                            |  11 +-
 include/linux/misc_cgroup.h                        |   2 +-
 include/linux/of_irq.h                             |   6 -
 include/linux/skbuff.h                             |   3 +
 include/linux/virtio_net.h                         |   4 +
 io_uring/fdinfo.c                                  |   8 +-
 io_uring/filetable.c                               |   2 +-
 io_uring/sqpoll.c                                  |  65 +++++++---
 io_uring/sqpoll.h                                  |   1 +
 io_uring/waitid.c                                  |   2 +-
 kernel/dma/debug.c                                 |   5 +-
 kernel/sched/fair.c                                |   9 +-
 kernel/sched/sched.h                               |   2 -
 kernel/trace/rv/monitors/pagefault/Kconfig         |   1 +
 kernel/trace/rv/rv.c                               |  12 +-
 mm/damon/core.c                                    |   7 +-
 mm/damon/sysfs.c                                   |   7 +-
 mm/huge_memory.c                                   |   3 +
 mm/migrate.c                                       |  88 +++++++------
 mm/migrate_device.c                                |   2 +-
 mm/mremap.c                                        |  15 +--
 mm/page_owner.c                                    |   3 +
 mm/slub.c                                          |  23 ++--
 mm/zsmalloc.c                                      |   4 +-
 net/core/datagram.c                                |  44 +++++--
 net/core/rtnetlink.c                               |   3 -
 net/hsr/hsr_netlink.c                              |   8 +-
 net/mptcp/pm_kernel.c                              |   6 +
 net/sctp/inqueue.c                                 |  13 +-
 net/smc/smc_inet.c                                 |  13 --
 net/vmw_vsock/af_vsock.c                           |  38 +++---
 net/xfrm/espintcp.c                                |   6 +-
 rust/kernel/auxiliary.rs                           |   8 +-
 rust/kernel/device.rs                              |   4 +-
 tools/objtool/check.c                              |   1 +
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   8 +-
 tools/testing/selftests/net/sctp_hello.c           |  17 +--
 tools/testing/selftests/net/sctp_vrf.sh            |  73 ++++++-----
 186 files changed, 1849 insertions(+), 834 deletions(-)


