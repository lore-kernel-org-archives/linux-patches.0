Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B53231AF36;
	Tue, 26 Aug 2025 11:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756206784; cv=none; b=QS0z/AaEn5QbJBrRlnNV61hqd+ckBZ9hO4cyILSuSsB9OQI48zx365DFD4L1FhtaHZ8yXhpmNVxc2+HM/dnjDlhqzSS4L9w+fDVKtbLdyOqUTp0zdSvej3sy6fhMzXseI24inrLUC5p3SwmSPQ7rhXR8BBzSL6ZXsSj4aRVLlvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756206784; c=relaxed/simple;
	bh=49Ob0tKpra+dm/+LSPJ47ukHHbE5VFdqKRe/DrPCGNk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CTuwEvQSdkM6e5yNGucvnQ9hMsxY2bs3Kh2OE/FeQXdB1K5iZGtneYA6AZYcGHt0BgS/9BdFnAO3XZGgHq1fTFL+9edec4gByxV9nngbmUr8601SFC5HP2R3SNy6GxxeLnPI+xcrGuGAd9Bs68Ee9nFkZhF2L4ZBa0zeOdDvCLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sqg4cda3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sqg4cda3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11074C4CEF1;
	Tue, 26 Aug 2025 11:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756206783;
	bh=49Ob0tKpra+dm/+LSPJ47ukHHbE5VFdqKRe/DrPCGNk=;
	h=From:To:Cc:Subject:Date:From;
	b=Sqg4cda3hXofU1mdDdDaCieEj6LPOx82MbyHfvTZTQ/EfYyDuZa/wCKWAeg4YxUsO
	 2kkF0VlRwxeBABZiQCShLBu5f/k2Syppq/8rSkMvaCqaFQuPKjNOARgQVY/h7vwdO9
	 PZU38ZilFeUCgGals9lIjjWQberVER8bFdm2mG3s=
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
Subject: [PATCH 6.12 000/322] 6.12.44-rc1 review
Date: Tue, 26 Aug 2025 13:06:55 +0200
Message-ID: <20250826110915.169062587@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.44-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.44-rc1
X-KernelTest-Deadline: 2025-08-28T11:09+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.44 release.
There are 322 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 28 Aug 2025 11:08:26 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.44-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.44-rc1

Al Viro <viro@zeniv.linux.org.uk>
    alloc_fdtable(): change calling conventions.

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

Alexei Lazar <alazar@nvidia.com>
    net/mlx5e: Query FW for buffer ownership

Oren Sidi <osidi@nvidia.com>
    net/mlx5: Add IFC bits and enums for buf_ownership

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5: Relocate function declarations from port.h to mlx5_core.h

Daniel Jurgens <danielj@nvidia.com>
    net/mlx5: Base ECVF devlink port attrs from 0

Hariprasad Kelam <hkelam@marvell.com>
    Octeontx2-af: Skip overlap check for SPI field

Hangbin Liu <liuhangbin@gmail.com>
    bonding: send LACPDUs periodically in passive mode after receiving partner's LACPDU

Hangbin Liu <liuhangbin@gmail.com>
    bonding: update LACP activity flag after setting lacp_active

Dewei Meng <mengdewei@cqsoftware.com.cn>
    ALSA: timer: fix ida_free call while not allocated

William Liu <will@willsroot.io>
    net/sched: Remove unnecessary WARNING condition for empty child qdisc in htb_activate

William Liu <will@willsroot.io>
    net/sched: Make cake_enqueue return NET_XMIT_CN when past buffer_limit

Tristram Ha <tristram.ha@microchip.com>
    net: dsa: microchip: Fix KSZ9477 HSR port setup issue

ValdikSS <iam@valdikss.org.ru>
    igc: fix disabling L1.2 PCI-E link substate on I226 on init

Jason Xing <kernelxing@tencent.com>
    ixgbe: xsk: resolve the negative overflow of budget in ixgbe_xmit_zc

Heiko Carstens <hca@linux.ibm.com>
    s390/mm: Do not map lowcore with identity mapping

Kanglong Wang <wangkanglong@loongson.cn>
    LoongArch: Optimize module load time by optimizing PLT/GOT counting

Parthiban Veerasooran <parthiban.veerasooran@microchip.com>
    microchip: lan865x: fix missing Timer Increment config for Rev.B0/B1

Parthiban Veerasooran <parthiban.veerasooran@microchip.com>
    microchip: lan865x: fix missing netif_start_queue() call on device open

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix UAF on smcsk after smc_listen_out()

Jordan Rhee <jordanrhee@google.com>
    gve: prevent ethtool ops after shutdown

Yuichiro Tsuji <yuichtsu@amazon.com>
    net: usb: asix_devices: Fix PHY address mask in MDIO bus initialization

Horatiu Vultur <horatiu.vultur@microchip.com>
    phy: mscc: Fix timestamping for vsc8584

David Howells <dhowells@redhat.com>
    cifs: Fix oops due to uninitialised variable

MD Danish Anwar <danishanwar@ti.com>
    net: ti: icssg-prueth: Fix HSR and switch offload Enablement during firwmare reload.

Qingfang Deng <dqfext@gmail.com>
    ppp: fix race conditions in ppp_fill_forward_path

Qingfang Deng <dqfext@gmail.com>
    net: ethernet: mtk_ppe: add RCU lock around dev_fill_forward_path

Minhong He <heminhong@kylinos.cn>
    ipv6: sr: validate HMAC algorithm ID in seg6_hmac_info_add

Jakub Ramaseuski <jramaseu@redhat.com>
    net: gso: Forbid IPv6 TSO with extensions on devices with only IPV6_CSUM

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Don't print errors for nonexistent connectors

Chenyuan Yang <chenyuan0y@gmail.com>
    drm/amd/display: Add null pointer check in mod_hdcp_hdcp1_create_session()

Dan Carpenter <dan.carpenter@linaro.org>
    ALSA: usb-audio: Fix size validation in convert_chmap_v3()

Baihan Li <libaihan@huawei.com>
    drm/hisilicon/hibmc: fix the hibmc loaded failed bug

Baihan Li <libaihan@huawei.com>
    drm/hisilicon/hibmc: fix the i2c device resource leak when vdac init failed

Baihan Li <libaihan@huawei.com>
    drm/hisilicon/hibmc: refactored struct hibmc_drm_private

Miguel Ojeda <ojeda@kernel.org>
    rust: alloc: fix `rusttest` by providing `Cmalloc::aligned_layout` too

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum: Forward packets with an IPv4 link-local source IP

Sergey Shtylyov <s.shtylyov@omp.ru>
    Bluetooth: hci_conn: do return error from hci_enhanced_setup_sync()

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_event: fix MTU for BN == 0 in CIS Established

Yang Li <yang.li@amlogic.com>
    Bluetooth: hci_sync: Prevent unintended PA sync when SID is 0xFF

Jiande Lu <jiande.lu@mediatek.com>
    Bluetooth: btmtk: Fix wait_on_bit_timeout interruption during shutdown

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix scan state after PA Sync has been established

Kees Cook <kees@kernel.org>
    iommu/amd: Avoid stack buffer overflow from kernel cmdline

Dan Carpenter <dan.carpenter@linaro.org>
    scsi: qla4xxx: Prevent a potential error pointer dereference

Justin Lai <justinlai0215@realtek.com>
    rtase: Fix Rx descriptor CRC error bit definition

Wang Liang <wangliang74@huawei.com>
    net: bridge: fix soft lockup in br_multicast_query_expired()

Suraj Gupta <suraj.gupta2@amd.com>
    net: xilinx: axienet: Fix RX skb ring management in DMAengine mode

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix dip entries leak on devices newer than hip09

Anantha Prabhu <anantha.prabhu@broadcom.com>
    RDMA/bnxt_re: Fix to initialize the PBL array

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Fix a possible memory leak in the driver

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Fix to remove workload check in SRQ limit path

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Fix to do SRQ armena by default

wenglianfa <wenglianfa@huawei.com>
    RDMA/hns: Fix querying wrong SCC context for DIP algorithm

Boshi Yu <boshiyu@linux.alibaba.com>
    RDMA/erdma: Fix ignored return value of init_kernel_qp

Danilo Krummrich <dakr@kernel.org>
    rust: alloc: replace aligned_size() with Kmalloc::aligned_layout()

Nitin Gote <nitin.r.gote@intel.com>
    iosys-map: Fix undefined behavior in iosys_map_clear()

José Expósito <jose.exposito89@gmail.com>
    drm/tests: Fix drm_test_fb_xrgb8888_to_xrgb2101010() on big-endian

Thomas Zimmermann <tzimmermann@suse.de>
    drm/tests: Do not use drm_fb_blit() in format-helper tests

Thomas Zimmermann <tzimmermann@suse.de>
    drm/format-helper: Add generic conversion to 32-bit formats

Thomas Zimmermann <tzimmermann@suse.de>
    drm/format-helper: Move helpers for pixel conversion to header file

Kerem Karabay <kekrby@gmail.com>
    drm/format-helper: Add conversion from XRGB8888 to BGR888

Jocelyn Falempe <jfalempe@redhat.com>
    drm/panic: Move drawing functions to drm_draw

José Expósito <jose.exposito89@gmail.com>
    drm/tests: Fix endian warning

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Fix a partition error with CPU hotplug

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Use static_branch_enable_cpuslocked() on cpusets_insane_config_key

Fanhua Li <lifanhua5@huawei.com>
    drm/nouveau/nvif: Fix potential memory leak in nvif_vmm_ctor().

Stefan Wahren <wahrenst@gmx.net>
    spi: spi-fsl-lpspi: Clamp too high speed_hz

Tianxiang Peng <txpeng@tencent.com>
    x86/cpu/hygon: Add missing resctrl_cpu_detect() in bsp_init helper

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: change invalid data error to -EBUSY

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: imu: inv_icm42600: Convert to uXX and sXX integer types

David Lechner <dlechner@baylibre.com>
    iio: imu: inv_icm42600: use = { } instead of memset()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: imu: inv_icm42600: switch timestamp type from int64_t __aligned(8) to aligned_s64

Jakub Kicinski <kuba@kernel.org>
    tls: fix handling of zero-length records on the rx_list

Michal Suchanek <msuchanek@suse.de>
    powerpc/boot: Fix build with gcc 15

NeilBrown <neil@brown.name>
    ovl: use I_MUTEX_PARENT when locking parent in ovl_create_temp()

Imre Deak <imre.deak@intel.com>
    drm/i915/icl+/tc: Cache the max lane count value

Jan Beulich <jbeulich@suse.com>
    compiler: remove __ADDRESSABLE_ASM{_STR,}() again

Imre Deak <imre.deak@intel.com>
    drm/i915/icl+/tc: Convert AUX powered WARN to a debug message

Pu Lehui <pulehui@huawei.com>
    tracing: Limit access to parser->buffer when trace_get_user failed

Steven Rostedt <rostedt@goodmis.org>
    tracing: Remove unneeded goto out logic

David Lechner <dlechner@baylibre.com>
    iio: temperature: maxim_thermocouple: use DMA-safe buffer for spi_read()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: light: as73211: Ensure buffer holes are zeroed

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: light: Use aligned_s64 instead of open coding alignment.

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add support for the Intel Wildcat Lake

Selvarasu Ganesan <selvarasu.g@samsung.com>
    usb: dwc3: Remove WARN_ON for device endpoint command timeouts

Kuen-Han Tsai <khtsai@google.com>
    usb: dwc3: Ignore late xferNotReady event to prevent halt timeout

Weitao Wang <WeitaoWang-oc@zhaoxin.com>
    usb: xhci: Fix slot_id resource race conflict

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: maxim_contaminant: re-enable cc toggle if cc is open and port is clean

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: maxim_contaminant: disable low power mode when reading comparator values

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

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    kcov, usb: Don't disable interrupts in kcov_remote_start_usb_softirq()

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

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Disable HS400 for AM62P SR1.0 and SR1.1

Imre Deak <imre.deak@intel.com>
    drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: governors: menu: Avoid selecting states with too much latency

Christian Loehle <christian.loehle@arm.com>
    cpuidle: menu: Remove iowait influence

Al Viro <viro@zeniv.linux.org.uk>
    use uniform permission checks for all mount propagation changes

Ye Bin <yebin10@huawei.com>
    fs/buffer: fix use-after-free when call bh_read() helper

Stefan Metzmacher <metze@samba.org>
    smb: server: split ksmbd_rdma_stop_listening() out of ksmbd_rdma_destroy()

Charalampos Mitrodimas <charmitro@posteo.net>
    debugfs: fix mount options not being applied

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62*: Move eMMC pinmux to top level board file

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am6*: Remove disable-wp for eMMC

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62*: Add non-removable flag for eMMC

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am6*: Add boot phase flag to support MMC boot

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: subpage: keep TOWRITE tag until folio is cleaned

Baokun Li <libaokun1@huawei.com>
    ext4: preserve SB_I_VERSION on remount

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Serialize admin queue BAR writes on 32-bit systems

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Drop unnecessary volatile from __iomem pointers

David Lechner <dlechner@baylibre.com>
    iio: adc: ad7173: fix setting ODR in probe

Geraldo Nascimento <geraldogabriel@gmail.com>
    PCI: rockchip: Set Target Link Speed to 5.0 GT/s before retraining

Geraldo Nascimento <geraldogabriel@gmail.com>
    PCI: rockchip: Use standard PCIe definitions

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: imx6: Add IMX8MQ_EP third 64-bit BAR in epc_features

Frank Li <Frank.Li@nxp.com>
    PCI: imx6: Add i.MX8Q PCIe Endpoint (EP) support

Simon Richter <Simon.Richter@hogyros.de>
    Mark xe driver as BROKEN if kernel page size is not 4kB

Geliang Tang <geliang@kernel.org>
    mptcp: disable add_addr retransmission when timeout is 0

Geliang Tang <geliang@kernel.org>
    mptcp: remove duplicate sk_reset_timer call

Dan Carpenter <dan.carpenter@linaro.org>
    soc: qcom: mdt_loader: Fix error return values in mdt_header_valid()

Mike Christie <michael.christie@oracle.com>
    scsi: core: Fix command pass through retry regression

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fill display clock and vblank time in dce110_fill_display_configs

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Find first CRTC and its line time in dce110_fill_display_configs

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fix DP audio DTO1 clock source on DCE 6.

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Fix Xorg desktop unresponsive on Replay panel

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fix fractional fb divider in set_pixel_clock_v3

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Don't overclock DCE 6 by 15%

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Avoid a NULL pointer dereference

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/swm14: Update power limit logic

Thorsten Blum <thorsten.blum@linux.dev>
    accel/habanalabs/gaudi2: Use kvfree() for memory allocated with kvcalloc()

Keith Busch <kbusch@kernel.org>
    kvm: retry nx_huge_page_recovery_thread creation

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86/intel-uncore-freq: Check write blocked for ELC

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/sclp: Fix SCCB present check

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Flush delayed SKBs while releasing RXE resources

Evgeniy Harchenko <evgeniyharchenko.dev@gmail.com>
    ALSA: hda/realtek: Add support for HP EliteBook x360 830 G6 and EliteBook 830 G6

Jinjiang Tu <tujinjiang@huawei.com>
    mm/memory-failure: fix infinite UCE for VM_PFNMAP pfn

Herton R. Krzesinski <herton@redhat.com>
    mm/debug_vm_pgtable: clear page table entries at destroy_args()

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: fix memory leak in squashfs_fill_super

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix a race when updating an existing write

Victor Shih <victor.shih@genesyslogic.com.tw>
    mmc: sdhci-pci-gli: GL9763e: Rename the gli_set_gl9763e() for consistency

Victor Shih <victor.shih@genesyslogic.com.tw>
    mmc: sdhci-pci-gli: GL9763e: Mask the replay timer timeout of AER

Jiayi Li <lijiayi@kylinos.cn>
    memstick: Fix deadlock by moving removing flag earlier

Victor Shih <victor.shih@genesyslogic.com.tw>
    mmc: sdhci-pci-gli: Add a new function to simplify the code

Nicolin Chen <nicolinc@nvidia.com>
    iommu/arm-smmu-v3: Fix smmu_domain->nr_ats_masters decrement

Dominique Martinet <asmadeus@codewreck.org>
    iov_iter: iterate_folioq: fix handling of offset >= folio size

Jens Axboe <axboe@kernel.dk>
    io_uring/futex: ensure io_futex_wait() cleans up properly on failure

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "can: ti_hecc: fix -Woverflow compiler warning"

Andrea Righi <arighi@nvidia.com>
    sched_ext: initialize built-in idle state before ops.init()

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: Return aborted command when missing sense and result TF

Jens Axboe <axboe@kernel.dk>
    io_uring/net: commit partial buffers on retry

David Howells <dhowells@redhat.com>
    netfs: Fix unbuffered write error handling

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

Christoph Hellwig <hch@lst.de>
    xfs: fully decouple XFS_IBULK* flags from XFS_IWALK* flags

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: requeue to unused block group list if zone finish failed

Boris Burkov <boris@bur.io>
    btrfs: codify pattern for adding block_group to bg_list

Boris Burkov <boris@bur.io>
    btrfs: explicitly ref count block_group on new_bgs list

Filipe Manana <fdmanana@suse.com>
    btrfs: abort transaction on unexpected eb generation at btrfs_copy_root()

Filipe Manana <fdmanana@suse.com>
    btrfs: always abort transaction on failure to add block group to free space tree

David Sterba <dsterba@suse.com>
    btrfs: move transaction aborts to the error site in add_block_group_free_space()

Filipe Manana <fdmanana@suse.com>
    btrfs: qgroup: fix race between quota disable and quota rescan ioctl

David Sterba <dsterba@suse.com>
    btrfs: qgroup: drop unused parameter fs_info from __del_qgroup_rb()

Sebastian Reichel <sebastian.reichel@collabora.com>
    usb: typec: fusb302: cache PD RX state

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    USB: typec: Use str_enable_disable-like helpers

Tom Lendacky <thomas.lendacky@amd.com>
    x86/sev: Ensure SVSM reserved fields in a page validation entry are initialized to zero

SeongJae Park <sj@kernel.org>
    mm/damon/ops-common: ignore migration request to invalid nodes

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: pm: check flush doesn't reset limits

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: kernel: flush: do not reset ADD_ADDR limit

Christoph Paasch <cpaasch@openai.com>
    mptcp: drop skb if MPTCP skb extension allocation fails

Chen Yu <yu.c.chen@intel.com>
    ACPI: pfr_update: Fix the driver update version check

Eric Biggers <ebiggers@kernel.org>
    ipv6: sr: Fix MAC comparison to be constant-time

Andrea Righi <arighi@nvidia.com>
    sched/ext: Fix invalid task state transitions on class switch

Jakub Acs <acsjakub@amazon.de>
    net, hsr: reject HSR frame if skb can't hold tag

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Make function kvm_own_lbt() robust

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Don't overwrite dce60_clk_mgr

Siyang Liu <Security@tencent.com>
    drm/amd/display: fix a Null pointer dereference vulnerability

Michel Dänzer <mdaenzer@redhat.com>
    drm/amd/display: Add primary plane to commits for correct VRR handling

Amber Lin <Amber.Lin@amd.com>
    drm/amdkfd: Destroy KFD debugfs after destroy KFD wq

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: update mmhub 4.1.0 client id mappings

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: update mmhub 3.0.1 client id mappings

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Update external revid for GC v9.5.0

Nathan Chancellor <nathan@kernel.org>
    drm/amdgpu: Initialize data to NULL in imu_v12_0_program_rlc_ram()

Peter Shkenev <mustela@erminea.space>
    drm/amdgpu: check if hubbub is NULL in debugfs/amdgpu_dm_capabilities

Gang Ba <Gang.Ba@amd.com>
    drm/amdgpu: Avoid extra evict-restore process.

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Restore cached power limit during resume

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/discovery: fix fw based ip discovery

Ricardo Ribalda <ribalda@chromium.org>
    media: venus: venc: Clamp param smaller than 1fps and bigger than 240

Ricardo Ribalda <ribalda@chromium.org>
    media: venus: vdec: Clamp param smaller than 1fps and bigger than 240.

Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
    media: venus: protect against spurious interrupts during probe

Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
    media: venus: hfi: explicitly release IRQ during teardown

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    media: venus: Fix MSM8998 frequency table

Vedang Nagar <quic_vnagar@quicinc.com>
    media: venus: Add a check for packet size after reading from shared memory

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    media: qcom: camss: cleanup media device allocated resource on error path

Hans de Goede <hansg@kernel.org>
    media: ivsc: Fix crash at shutdown due to missing mei_cldev_disable() calls

Mathis Foerst <mathis.foerst@mt.com>
    media: mt9m114: Fix deadlock in get_frame_interval/set_frame_interval

Zhang Shurong <zhang_shurong@foxmail.com>
    media: ov2659: Fix memory leaks in ov2659_probe()

Jacopo Mondi <jacopo.mondi@ideasonboard.com>
    media: pisp_be: Fix pm_runtime underrun in probe

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

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ipu6: isys: Use correct pads for xlate_streams()

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

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    kbuild: userprogs: use correct linker when mixing clang and GNU ld

Baokun Li <libaokun1@huawei.com>
    jbd2: prevent softlockup in jbd2_log_do_checkpoint()

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid out-of-boundary access in dnode page

Muhammad Usama Anjum <usama.anjum@collabora.com>
    ASoC: SOF: amd: acp-loader: Use GFP_KERNEL for DMA allocations in resume context

Xaver Hugl <xaver.hugl@kde.org>
    amdgpu/amdgpu_discovery: increase timeout limit for IFWI init

Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
    phy: qcom: phy-qcom-m31: Update IPQ5332 M31 USB phy initialization sequence

Will Deacon <will@kernel.org>
    vhost/vsock: Avoid allocating arbitrarily-sized SKBs

Will Deacon <will@kernel.org>
    vsock/virtio: Validate length in packet header before skb_put()

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: imx6: Delay link start until configfs 'start' written

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: imx6: Remove apps_reset toggling from imx_pcie_{assert/deassert}_core_reset

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: imx6: Add IMX8MM_EP and IMX8MP_EP fixed 256-byte BAR 4 in epc_features

Damien Le Moal <dlemoal@kernel.org>
    PCI: endpoint: Fix configfs group removal on driver teardown

Damien Le Moal <dlemoal@kernel.org>
    PCI: endpoint: Fix configfs group list head handling

Lukas Wunner <lukas@wunner.de>
    PCI/portdrv: Use is_pciehp instead of is_hotplug_bridge

Chi Zhiling <chizhiling@kylinos.cn>
    readahead: fix return value of page_cache_next_miss() when no hole is found

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

André Draszik <andre.draszik@linaro.org>
    scsi: ufs: exynos: Fix programming of HCI_UTRL_NEXUS_TYPE

Macpaul Lin <macpaul.lin@mediatek.com>
    scsi: dt-bindings: mediatek,ufs: Add ufs-disable-mcq flag for UFS host

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: display: sprd,sharkl3-dsi-host: Fix missing clocks constraints

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: display: sprd,sharkl3-dpu: Fix missing clocks constraints

Helge Deller <deller@gmx.de>
    apparmor: Fix 8-byte alignment for initial dfa blob streams

Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
    arm64: dts: ti: k3-am62-verdin: Enable pull-ups on I2C buses

Hong Guan <hguan@ti.com>
    arm64: dts: ti: k3-am62a7-sk: fix pinmux for main_uart1

Peter Griffin <peter.griffin@linaro.org>
    arm64: dts: exynos: gs101: ufs: add dma-coherent property

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    arm64: dts: ti: k3-pinctrl: Enable Schmitt Trigger by default

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62-main: Remove eMMC High Speed DDR support

Kyoji Ogasawara <sawara04.o@gmail.com>
    btrfs: fix printing of mount info messages for NODATACOW/NODATASUM

Kyoji Ogasawara <sawara04.o@gmail.com>
    btrfs: restore mount option info messages during mount

Kyoji Ogasawara <sawara04.o@gmail.com>
    btrfs: fix incorrect log message for nobarrier mount option

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

Bharat Bhushan <bbhushan2@marvell.com>
    crypto: octeontx2 - Fix address alignment on CN10KB and CN10KA-B0

Bharat Bhushan <bbhushan2@marvell.com>
    crypto: octeontx2 - Fix address alignment on CN10K A0/A1 and OcteonTX2

Bharat Bhushan <bbhushan2@marvell.com>
    crypto: octeontx2 - Fix address alignment issue on ucode loading

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - flush misc workqueue during device shutdown

John Ernberg <john.ernberg@actia.se>
    crypto: caam - Prevent crash on suspend with iMX8QM / iMX8ULP

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
    usb: dwc3: imx8mp: fix device leak at unbind

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

Damien Le Moal <dlemoal@kernel.org>
    dm: Check for forbidden splitting of zone write operations

Damien Le Moal <dlemoal@kernel.org>
    dm: dm-crypt: Do not partially accept write BIOs with zoned targets

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Take active children into account in pm_runtime_get_if_in_use()

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_ec: Unregister notifier in cros_ec_unregister()

Dan Carpenter <dan.carpenter@linaro.org>
    cpufreq: armada-8k: Fix off by one in armada_8k_cpufreq_free_table()

Damien Le Moal <dlemoal@kernel.org>
    ata: Fix SATA_MOBILE_LPM_POLICY description in Kconfig

Yunhui Cui <cuiyunhui@bytedance.com>
    serial: 8250: fix panic due to PSLVERR


-------------

Diffstat:

 .../bindings/display/sprd/sprd,sharkl3-dpu.yaml    |   2 +-
 .../display/sprd/sprd,sharkl3-dsi-host.yaml        |   2 +-
 .../devicetree/bindings/ufs/mediatek,ufs.yaml      |   4 +
 Documentation/networking/mptcp-sysctl.rst          |   2 +
 Makefile                                           |   6 +-
 arch/arm64/boot/dts/exynos/google/gs101.dtsi       |   1 +
 arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts           |  36 ++
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi           |   1 -
 arch/arm64/boot/dts/ti/k3-am62-phycore-som.dtsi    |   1 -
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi         |  12 +-
 arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts     |   2 +-
 arch/arm64/boot/dts/ti/k3-am625-sk.dts             |  24 ++
 arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi   |   1 -
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts            |   7 +-
 arch/arm64/boot/dts/ti/k3-am62p5-sk.dts            |   2 +-
 arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi     |  24 --
 arch/arm64/boot/dts/ti/k3-am642-evm.dts            |   1 -
 arch/arm64/boot/dts/ti/k3-am654-base-board.dts     |   1 -
 .../dts/ti/k3-am6548-iot2050-advanced-common.dtsi  |   1 -
 arch/arm64/boot/dts/ti/k3-am69-sk.dts              |   1 -
 arch/arm64/boot/dts/ti/k3-pinctrl.h                |  15 +-
 arch/loongarch/kernel/module-sections.c            |  38 +--
 arch/loongarch/kvm/vcpu.c                          |   8 +-
 arch/m68k/kernel/head.S                            |  31 +-
 arch/mips/crypto/chacha-core.S                     |  20 +-
 arch/parisc/Makefile                               |   4 +-
 arch/parisc/include/asm/pgtable.h                  |   7 +-
 arch/parisc/include/asm/special_insns.h            |  28 ++
 arch/parisc/include/asm/uaccess.h                  |  21 +-
 arch/parisc/kernel/cache.c                         |   6 +-
 arch/parisc/kernel/entry.S                         |  17 +-
 arch/parisc/kernel/syscall.S                       |  30 +-
 arch/parisc/lib/memcpy.c                           |  19 +-
 arch/parisc/mm/fault.c                             |   4 +
 arch/powerpc/boot/Makefile                         |   1 +
 arch/s390/boot/vmem.c                              |   3 +
 arch/s390/hypfs/hypfs_dbfs.c                       |  19 +-
 arch/x86/coco/sev/shared.c                         |   3 +
 arch/x86/include/asm/xen/hypercall.h               |   5 +-
 arch/x86/kernel/cpu/hygon.c                        |   3 +
 arch/x86/kvm/mmu/mmu.c                             |  10 +-
 drivers/accel/habanalabs/gaudi2/gaudi2.c           |   2 +-
 drivers/acpi/pfr_update.c                          |   2 +-
 drivers/ata/Kconfig                                |  32 +-
 drivers/ata/libata-scsi.c                          |  58 ++--
 drivers/base/power/runtime.c                       |  27 +-
 drivers/bluetooth/btmtk.c                          |   7 +-
 drivers/bus/mhi/host/boot.c                        |   8 +-
 drivers/bus/mhi/host/internal.h                    |   4 +-
 drivers/bus/mhi/host/main.c                        |  12 +-
 drivers/cdx/controller/cdx_rpmsg.c                 |   3 +-
 drivers/comedi/comedi_fops.c                       |   5 +
 drivers/comedi/drivers.c                           |  27 +-
 drivers/comedi/drivers/pcl726.c                    |   3 +-
 drivers/cpufreq/armada-8k-cpufreq.c                |   2 +-
 drivers/cpuidle/governors/menu.c                   | 101 ++----
 drivers/crypto/caam/ctrl.c                         |   5 +-
 drivers/crypto/caam/intern.h                       |   1 +
 .../crypto/intel/qat/qat_common/adf_common_drv.h   |   1 +
 drivers/crypto/intel/qat/qat_common/adf_init.c     |   1 +
 drivers/crypto/intel/qat/qat_common/adf_isr.c      |   5 +
 drivers/crypto/intel/qat/qat_common/qat_algs.c     |  12 +-
 drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h | 125 +++++--
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c    |  35 +-
 drivers/fpga/zynq-fpga.c                           |  10 +-
 drivers/gpu/drm/Kconfig                            |   5 +
 drivers/gpu/drm/Makefile                           |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |  76 +++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/imu_v12_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c          |  57 ++--
 drivers/gpu/drm/amd/amdgpu/mmhub_v4_1_0.c          |  34 +-
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |   2 +
 drivers/gpu/drm/amd/amdkfd/kfd_module.c            |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   3 +
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |  28 ++
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |   2 +-
 drivers/gpu/drm/amd/display/dc/bios/bios_parser.c  |   5 +-
 .../gpu/drm/amd/display/dc/bios/command_table.c    |   2 +-
 drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c   |   1 -
 .../amd/display/dc/clk_mgr/dce100/dce_clk_mgr.c    |   2 -
 .../amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c |  40 ++-
 .../amd/display/dc/clk_mgr/dce60/dce60_clk_mgr.c   |  31 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  34 +-
 .../gpu/drm/amd/display/modules/hdcp/hdcp_psp.c    |   3 +
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   6 +
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c   |  30 +-
 drivers/gpu/drm/display/drm_dp_helper.c            |   2 +-
 drivers/gpu/drm/drm_draw.c                         | 155 +++++++++
 drivers/gpu/drm/drm_draw_internal.h                |  56 ++++
 drivers/gpu/drm/drm_format_helper.c                | 234 +++++++++----
 drivers/gpu/drm/drm_format_internal.h              | 127 ++++++++
 drivers/gpu/drm/drm_panic.c                        | 269 ++-------------
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c    |   4 +-
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.h    |  17 +-
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_i2c.c    |  42 +--
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c   |  29 +-
 drivers/gpu/drm/i915/display/intel_tc.c            |  58 +++-
 drivers/gpu/drm/nouveau/nvif/vmm.c                 |   3 +-
 drivers/gpu/drm/tests/drm_format_helper_test.c     | 176 +++++-----
 drivers/gpu/drm/xe/Kconfig                         |   1 +
 drivers/hwmon/gsc-hwmon.c                          |   4 +-
 drivers/iio/adc/ad7173.c                           |   3 +-
 drivers/iio/adc/ad_sigma_delta.c                   |   4 +-
 drivers/iio/imu/bno055/bno055.c                    |  11 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600.h        |   8 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c  |  33 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c |  22 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.h |  10 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c   |   6 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c   |  43 ++-
 drivers/iio/imu/inv_icm42600/inv_icm42600_temp.c   |  12 +-
 drivers/iio/light/adjd_s311.c                      |   2 +-
 drivers/iio/light/as73211.c                        |   4 +-
 drivers/iio/light/bh1745.c                         |   2 +-
 drivers/iio/light/isl29125.c                       |   2 +-
 drivers/iio/light/ltr501.c                         |   2 +-
 drivers/iio/light/max44000.c                       |   2 +-
 drivers/iio/light/rohm-bu27034.c                   |   2 +-
 drivers/iio/light/rpr0521.c                        |   2 +-
 drivers/iio/light/st_uvis25.h                      |   2 +-
 drivers/iio/light/tcs3414.c                        |   2 +-
 drivers/iio/light/tcs3472.c                        |   2 +-
 drivers/iio/pressure/bmp280-core.c                 |   9 +-
 drivers/iio/proximity/isl29501.c                   |  14 +-
 drivers/iio/temperature/maxim_thermocouple.c       |  26 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   8 +-
 drivers/infiniband/hw/bnxt_re/main.c               |  23 ++
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |  30 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |   2 -
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |   2 +
 drivers/infiniband/hw/erdma/erdma_verbs.c          |   4 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   6 +-
 drivers/infiniband/hw/hns/hns_roce_restrack.c      |   9 +-
 drivers/infiniband/sw/rxe/rxe_net.c                |  29 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   2 +-
 drivers/iommu/amd/init.c                           |   4 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   2 +-
 drivers/md/dm-crypt.c                              |  47 ++-
 drivers/md/dm.c                                    |  17 +-
 drivers/media/cec/usb/rainshadow/rainshadow-cec.c  |   3 +-
 drivers/media/i2c/hi556.c                          |  26 +-
 drivers/media/i2c/mt9m114.c                        |   8 -
 drivers/media/i2c/ov2659.c                         |   3 +-
 drivers/media/pci/intel/ipu6/ipu6-isys-csi2.c      |  12 +-
 drivers/media/pci/intel/ivsc/mei_ace.c             |   2 +
 drivers/media/pci/intel/ivsc/mei_csi.c             |   2 +
 drivers/media/platform/qcom/camss/camss.c          |   4 +-
 drivers/media/platform/qcom/venus/core.c           |  18 +-
 drivers/media/platform/qcom/venus/core.h           |   2 +
 drivers/media/platform/qcom/venus/hfi_venus.c      |   5 +
 drivers/media/platform/qcom/venus/vdec.c           |   5 +-
 drivers/media/platform/qcom/venus/venc.c           |   5 +-
 drivers/media/platform/raspberrypi/pisp_be/Kconfig |   1 +
 .../media/platform/raspberrypi/pisp_be/pisp_be.c   |   5 +-
 .../media/platform/verisilicon/rockchip_vpu_hw.c   |   9 -
 drivers/media/test-drivers/vivid/vivid-ctrls.c     |   3 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |   4 +-
 drivers/media/usb/gspca/vicam.c                    |  10 +-
 drivers/media/usb/usbtv/usbtv-video.c              |   4 +
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |   1 -
 drivers/memstick/core/memstick.c                   |   1 -
 drivers/memstick/host/rtsx_usb_ms.c                |   1 +
 drivers/mmc/host/sdhci-pci-gli.c                   |  37 ++-
 drivers/mmc/host/sdhci_am654.c                     |  18 +
 drivers/most/core.c                                |   2 +-
 drivers/mtd/nand/raw/fsmc_nand.c                   |   2 +
 drivers/mtd/nand/raw/renesas-nand-controller.c     |   6 +
 drivers/mtd/nand/spi/core.c                        |   5 +-
 drivers/mtd/spi-nor/swp.c                          |  19 +-
 drivers/net/bonding/bond_3ad.c                     |  67 +++-
 drivers/net/bonding/bond_options.c                 |   1 +
 drivers/net/can/ti_hecc.c                          |   2 +-
 drivers/net/dsa/microchip/ksz_common.c             |   6 +
 drivers/net/ethernet/google/gve/gve_main.c         |   2 +
 drivers/net/ethernet/intel/igc/igc_main.c          |  14 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   4 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |   4 +-
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h |   1 -
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |  18 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |  12 +-
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c |   4 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  87 +++++
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |  40 +--
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   2 +
 drivers/net/ethernet/mellanox/mlxsw/trap.h         |   1 +
 drivers/net/ethernet/microchip/lan865x/lan865x.c   |  21 ++
 drivers/net/ethernet/realtek/rtase/rtase.h         |   2 +-
 drivers/net/ethernet/ti/icssg/icssg_prueth.c       |  72 ++--
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   8 +-
 drivers/net/phy/mscc/mscc.h                        |  12 +
 drivers/net/phy/mscc/mscc_main.c                   |  12 +
 drivers/net/phy/mscc/mscc_ptp.c                    |  49 ++-
 drivers/net/ppp/ppp_generic.c                      |  17 +-
 drivers/net/usb/asix_devices.c                     |   2 +-
 drivers/net/wireless/ath/ath11k/ce.c               |   3 -
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   3 -
 drivers/net/wireless/ath/ath11k/hal.c              |  33 +-
 drivers/net/wireless/ath/ath12k/ce.c               |   3 -
 drivers/net/wireless/ath/ath12k/hal.c              |  38 ++-
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c      |   2 +-
 drivers/pci/controller/dwc/pci-imx6.c              |  32 +-
 drivers/pci/controller/pcie-rockchip-host.c        |  49 +--
 drivers/pci/controller/pcie-rockchip.h             |  11 +-
 drivers/pci/endpoint/pci-ep-cfs.c                  |   1 +
 drivers/pci/endpoint/pci-epf-core.c                |   2 +-
 drivers/pci/pcie/portdrv.c                         |   2 +-
 drivers/phy/qualcomm/phy-qcom-m31.c                |  14 +-
 drivers/platform/chrome/cros_ec.c                  |   3 +
 .../intel/uncore-frequency/uncore-frequency-tpmi.c |   5 +
 drivers/pwm/pwm-imx-tpm.c                          |   9 +
 drivers/pwm/pwm-mediatek.c                         |  71 ++--
 drivers/s390/char/sclp.c                           |  11 +-
 drivers/scsi/mpi3mr/mpi3mr.h                       |   6 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  17 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |   2 +
 drivers/scsi/qla4xxx/ql4_os.c                      |   2 +
 drivers/scsi/scsi_lib.c                            |   3 +
 drivers/soc/qcom/mdt_loader.c                      |  43 +++
 drivers/soc/tegra/pmc.c                            |  51 +--
 drivers/spi/spi-fsl-lpspi.c                        |   8 +-
 drivers/staging/media/imx/imx-media-csc-scaler.c   |   2 +-
 drivers/tty/serial/8250/8250_port.c                |   3 +-
 drivers/tty/vt/defkeymap.c_shipped                 | 112 +++++++
 drivers/tty/vt/keyboard.c                          |   2 +-
 drivers/ufs/host/ufs-exynos.c                      |   4 +-
 drivers/ufs/host/ufshcd-pci.c                      |  42 ++-
 drivers/usb/atm/cxacru.c                           | 172 +++++-----
 drivers/usb/core/hcd.c                             |  20 +-
 drivers/usb/core/quirks.c                          |   1 +
 drivers/usb/dwc3/dwc3-imx8mp.c                     |   7 +-
 drivers/usb/dwc3/dwc3-meson-g12a.c                 |   3 +
 drivers/usb/dwc3/dwc3-pci.c                        |   2 +
 drivers/usb/dwc3/ep0.c                             |  20 +-
 drivers/usb/dwc3/gadget.c                          |  19 +-
 drivers/usb/gadget/udc/renesas_usb3.c              |   1 +
 drivers/usb/host/xhci-hub.c                        |   3 +-
 drivers/usb/host/xhci-mem.c                        |  22 +-
 drivers/usb/host/xhci-pci-renesas.c                |   7 +-
 drivers/usb/host/xhci-ring.c                       |   9 +-
 drivers/usb/host/xhci.c                            |  21 +-
 drivers/usb/host/xhci.h                            |   3 +-
 drivers/usb/musb/omap2430.c                        |  14 +-
 drivers/usb/storage/realtek_cr.c                   |   2 +-
 drivers/usb/storage/unusual_devs.h                 |  29 ++
 drivers/usb/typec/class.c                          |   7 +-
 drivers/usb/typec/tcpm/fusb302.c                   |  32 +-
 drivers/usb/typec/tcpm/maxim_contaminant.c         |  58 ++++
 .../usb/typec/tcpm/qcom/qcom_pmic_typec_pdphy.c    |   3 +-
 .../typec/tcpm/qcom/qcom_pmic_typec_pdphy_stub.c   |   3 +-
 drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_port.c |   4 +-
 drivers/usb/typec/tcpm/tcpci_maxim.h               |   1 +
 drivers/usb/typec/tcpm/tcpm.c                      |   7 +-
 drivers/vhost/vsock.c                              |   6 +-
 drivers/video/console/vgacon.c                     |   2 +-
 fs/btrfs/block-group.c                             |  59 ++--
 fs/btrfs/ctree.c                                   |   9 +-
 fs/btrfs/free-space-tree.c                         |  17 +-
 fs/btrfs/qgroup.c                                  |  38 ++-
 fs/btrfs/send.c                                    | 361 ++++++++++++---------
 fs/btrfs/subpage.c                                 |  19 +-
 fs/btrfs/super.c                                   |  13 +-
 fs/btrfs/transaction.c                             |   1 +
 fs/btrfs/zoned.c                                   |  13 +-
 fs/buffer.c                                        |   2 +-
 fs/debugfs/inode.c                                 |  11 +-
 fs/ext4/fsmap.c                                    |  23 +-
 fs/ext4/indirect.c                                 |   4 +-
 fs/ext4/inode.c                                    |   2 +-
 fs/ext4/orphan.c                                   |   5 +-
 fs/ext4/super.c                                    |   8 +-
 fs/f2fs/node.c                                     |  10 +
 fs/file.c                                          |  75 ++---
 fs/jbd2/checkpoint.c                               |   1 +
 fs/namespace.c                                     |  34 +-
 fs/netfs/write_collect.c                           |  10 +-
 fs/netfs/write_issue.c                             |   4 +-
 fs/nfs/pagelist.c                                  |   9 +-
 fs/nfs/write.c                                     |  29 +-
 fs/overlayfs/copy_up.c                             |   2 +-
 fs/smb/client/smb2ops.c                            |   2 +-
 fs/smb/server/connection.c                         |   3 +-
 fs/smb/server/connection.h                         |   7 +-
 fs/smb/server/oplock.c                             |  13 +-
 fs/smb/server/transport_rdma.c                     |   5 +-
 fs/smb/server/transport_rdma.h                     |   4 +-
 fs/smb/server/transport_tcp.c                      |  26 +-
 fs/splice.c                                        |   3 +
 fs/squashfs/super.c                                |  14 +-
 fs/xfs/xfs_itable.c                                |   6 +-
 include/drm/drm_format_helper.h                    |  12 +
 include/linux/call_once.h                          |  43 ++-
 include/linux/compiler.h                           |   8 -
 include/linux/iosys-map.h                          |   7 +-
 include/linux/iov_iter.h                           |  20 +-
 include/linux/kcov.h                               |  47 +--
 include/linux/mlx5/mlx5_ifc.h                      |  14 +-
 include/linux/mlx5/port.h                          |  83 -----
 include/linux/netfs.h                              |   1 +
 include/linux/nfs_page.h                           |   1 +
 include/net/bond_3ad.h                             |   1 +
 include/uapi/linux/pfrut.h                         |   1 +
 io_uring/futex.c                                   |   3 +
 io_uring/net.c                                     |  27 +-
 kernel/cgroup/cpuset.c                             |   9 +-
 kernel/sched/ext.c                                 |  18 +-
 kernel/trace/ftrace.c                              |  19 +-
 kernel/trace/trace.c                               |  34 +-
 kernel/trace/trace.h                               |  10 +-
 mm/damon/paddr.c                                   |   4 +
 mm/debug_vm_pgtable.c                              |   9 +-
 mm/filemap.c                                       |   3 +-
 mm/memory-failure.c                                |   8 +
 net/bluetooth/hci_conn.c                           |   3 +-
 net/bluetooth/hci_event.c                          |   8 +-
 net/bluetooth/hci_sync.c                           |  19 +-
 net/bridge/br_multicast.c                          |  16 +
 net/bridge/br_private.h                            |   2 +
 net/core/dev.c                                     |  12 +
 net/hsr/hsr_slave.c                                |   8 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |   6 +-
 net/ipv6/netfilter/nf_reject_ipv6.c                |   5 +-
 net/ipv6/seg6_hmac.c                               |   6 +-
 net/mptcp/options.c                                |   6 +-
 net/mptcp/pm_netlink.c                             |  19 +-
 net/sched/sch_cake.c                               |  14 +-
 net/sched/sch_htb.c                                |   2 +-
 net/smc/af_smc.c                                   |   3 +-
 net/tls/tls_sw.c                                   |   7 +-
 net/vmw_vsock/virtio_transport.c                   |  12 +-
 rust/kernel/alloc/allocator.rs                     |  30 +-
 rust/kernel/alloc/allocator_test.rs                |  11 +
 security/apparmor/lsm.c                            |   4 +-
 sound/core/timer.c                                 |   4 +-
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/soc/sof/amd/acp-loader.c                     |   6 +-
 sound/usb/stream.c                                 |   2 +-
 sound/usb/validate.c                               |   2 +-
 tools/testing/selftests/net/mptcp/pm_netlink.sh    |   1 +
 341 files changed, 3816 insertions(+), 2245 deletions(-)


