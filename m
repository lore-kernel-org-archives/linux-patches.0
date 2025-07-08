Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9CD2E5432;
	Tue,  8 Jul 2025 16:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751991851; cv=none; b=nkc+rpjZzOflQ43+/qxDAz1+0C5JGNsSMAr9EX4VKSd/PC3zMhScp0txb/fqJMttnJUmWZnq1Rjm2rwcwp56QYFMEivdhMbGDtfQPaR440H6gNcO+2V00zhDlf5mnPYdEDLdwdR+Z+HQ1fi4mmZGvVqe1BC68ZJ+hmQJVsAXpXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751991851; c=relaxed/simple;
	bh=bHB2TBgSNreGVs+Id8pVwJNU1KyXo35UOXGBbnWs3Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=d/KpvD8vF4M2lebekV3nhNj/7OPCxIrgu6CpiIteWL+ZPnw0uHjesaQU+yQzWiQWpxYfEjmgFbuUWVn9ep1yfjh9RmmHFho/IIbjvUlwnclEXdc3+d0EjiUffvlQeyxlJfpJCtijkHmDAEI50hR9RENHFGmnA5oPAosHUhyAuDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6/7s7ae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6/7s7ae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8632FC4CEED;
	Tue,  8 Jul 2025 16:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751991851;
	bh=bHB2TBgSNreGVs+Id8pVwJNU1KyXo35UOXGBbnWs3Lw=;
	h=From:To:Cc:Subject:Date:From;
	b=T6/7s7aeWbnvnjjGt+b2v+6G8V/03Dk+NLuryvOmeZxKxj39wTpr1AoDQRzWvhnLu
	 sLvzEy1aEKGCReTqhmUrYgfSgnG6nJF5U9N4AGg1HIVspcsiaYAy+h3dnaizR5Kyo3
	 75A4HDYv+rSKF1a92KzsaMnbrXdP6tcEXWbaCLfk=
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
	broonie@kernel.org
Subject: [PATCH 6.6 000/132] 6.6.97-rc1 review
Date: Tue,  8 Jul 2025 18:21:51 +0200
Message-ID: <20250708162230.765762963@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.97-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.97-rc1
X-KernelTest-Deadline: 2025-07-10T16:22+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.97 release.
There are 132 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.97-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.97-rc1

Borislav Petkov (AMD) <bp@alien8.de>
    x86/process: Move the buffer clearing before MONITOR

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Add TSA microcode SHAs

Borislav Petkov (AMD) <bp@alien8.de>
    KVM: SVM: Advertise TSA CPUID bits to guests

Borislav Petkov (AMD) <bp@alien8.de>
    x86/bugs: Add a Transient Scheduler Attacks mitigation

Borislav Petkov (AMD) <bp@alien8.de>
    x86/bugs: Rename MDS machinery to something more generic

Madhavan Srinivasan <maddy@linux.ibm.com>
    powerpc/kernel: Fix ppc_save_regs inclusion in build

Andrei Kuchynski <akuchynski@chromium.org>
    usb: typec: displayport: Fix potential deadlock

Kurt Borja <kuurtb@gmail.com>
    platform/x86: think-lmi: Fix sysfs group cleanup

Kurt Borja <kuurtb@gmail.com>
    platform/x86: think-lmi: Fix kobject cleanup

Kurt Borja <kuurtb@gmail.com>
    platform/x86: think-lmi: Create ksets consecutively

Zhang Rui <rui.zhang@intel.com>
    powercap: intel_rapl: Do not change CLAMPING bit if ENABLE bit cannot be changed

Simon Xue <xxm@rock-chips.com>
    iommu/rockchip: prevent iommus dead loop when two masters share one IOMMU

Oliver Neukum <oneukum@suse.com>
    Logitech C-270 even more broken

Michael J. Ruhl <michael.j.ruhl@intel.com>
    i2c/designware: Fix an initialization issue

Christian König <christian.koenig@amd.com>
    dma-buf: fix timeout handling in dma_resv_wait_timeout v2

Philipp Kerling <pkerling@casix.org>
    smb: client: fix readdir returning wrong type with POSIX extensions

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: udc: disconnect/reconnect from host when do suspend/resume

Peter Chen <peter.chen@cixtech.com>
    usb: cdnsp: do not disable slot for disabled slot

Jeff LaBundy <jeff@labundy.com>
    Input: iqs7222 - explicitly define number of external channels

Nilton Perim Neto <niltonperimneto@gmail.com>
    Input: xpad - support Acer NGR 200 Controller

Hongyu Xie <xiehongyu1@kylinos.cn>
    xhci: Disable stream for xHC controller with XHCI_BROKEN_STREAMS

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: Flush queued requests before stopping dbc

Łukasz Bartosik <ukaszb@chromium.org>
    xhci: dbctty: disable ECHO flag by default

Raju Rangoju <Raju.Rangoju@amd.com>
    usb: xhci: quirk for data loss in ISOC transfers

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Fix stale function handles in error handling

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/flexfiles: Fix handling of NFS level errors in I/O

Shivank Garg <shivankg@amd.com>
    fs: export anon_inode_make_secure_inode() and fix secretmem LSM bypass

Peter Zijlstra <peterz@infradead.org>
    module: Provide EXPORT_SYMBOL_GPL_FOR_MODULES() helper

Niklas Schnelle <schnelle@linux.ibm.com>
    iommu: Allow .iotlb_sync_map to fail and handle s390's -ENOMEM return

Jason Gunthorpe <jgg@ziepe.ca>
    iommu: Add IOMMU_DOMAIN_PLATFORM for S390

Kurt Borja <kuurtb@gmail.com>
    platform/x86: hp-bioscfg: Fix class device unregistration

Thomas Weißschuh <linux@weissschuh.net>
    platform/x86: hp-bioscfg: Directly use firmware_attributes_class

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Disable interrupts before resetting the GPU

Uladzislau Rezki (Sony) <urezki@gmail.com>
    rcu: Return early if callback is not specified

Pablo Martin-Gomez <pmartin-gomez@freebox.fr>
    mtd: spinand: fix memory leak of ECC engine conf

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Refuse to evaluate a method if arguments are missing

Johannes Berg <johannes.berg@intel.com>
    wifi: ath6kl: remove WARN on bad firmware input

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: drop invalid source address OCB frames

Justin Sanders <jsanders.devel@gmail.com>
    aoe: defer rexmit timer downdev work to workqueue

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: Fix NULL pointer dereference in core_scsi3_decode_spec_i_port()

Heiko Stuebner <heiko@sntech.de>
    regulator: fan53555: add enable_time support and soft-start times

Raven Black <ravenblack@gmail.com>
    ASoC: amd: yc: update quirk data for HP Victus

Madhavan Srinivasan <maddy@linux.ibm.com>
    powerpc: Fix struct termio related ioctl macros

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd/pmc: Add PCSpecialist Lafite Pro V 14M to 8042 quirks list

Gabriel Santese <santesegabriel@gmail.com>
    ASoC: amd: yc: Add quirk for MSI Bravo 17 D7VF internal mic

Johannes Berg <johannes.berg@intel.com>
    ata: pata_cs5536: fix build on 32-bit UML

Tasos Sahanidis <tasos@tasossah.com>
    ata: libata-acpi: Do not assume 40 wire cable if no devices are enabled

Takashi Iwai <tiwai@suse.de>
    ALSA: sb: Force to disable DMAs once when DMA mode is changed

Takashi Iwai <tiwai@suse.de>
    ALSA: sb: Don't allow changing the DMA mode during operations

Rob Clark <robdclark@chromium.org>
    drm/msm: Fix another leak in the submit error path

Rob Clark <robdclark@chromium.org>
    drm/msm: Fix a fence leak in submit error path

Xin Li (Intel) <xin@zytor.com>
    drm/i915/dp_mst: Work around Thunderbolt sink disconnect after SINK_COUNT_ESI read

Thomas Zimmermann <tzimmermann@suse.de>
    drm/simpledrm: Do not upcast in release helpers

anvithdosapati <anvithdosapati@google.com>
    scsi: ufs: core: Fix clk scaling to be conditional in reset and restore

Manivannan Sadhasivam <mani@kernel.org>
    scsi: ufs: core: Add OPP support for scaling clocks and regulators

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Fix abnormal scale up after last cmd finish

Chao Yu <chao@kernel.org>
    f2fs: fix to zero post-eof page

Chao Yu <chao@kernel.org>
    f2fs: convert f2fs_vm_page_mkwrite() to use folio

Daeho Jeong <daehojeong@google.com>
    f2fs: prevent writing without fallocate() for pinned files

Chao Yu <chao@kernel.org>
    f2fs: add tracepoint for f2fs_vm_page_mkwrite()

Xin Li (Intel) <xin@zytor.com>
    x86/traps: Initialize DR6 by writing its architectural reset value

Yan Zhai <yan@cloudflare.com>
    bnxt: properly flush XDP redirect lists

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: finish link init before RCU publish

Muna Sinada <muna.sinada@oss.qualcomm.com>
    wifi: mac80211: Add link iteration macro for link data

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: chan: chandef is non-NULL for reserved

Kuniyuki Iwashima <kuniyu@google.com>
    Bluetooth: hci_core: Fix use-after-free in vhci_flush()

Stefan Metzmacher <metze@samba.org>
    smb: client: remove \t from TP_printk statements

Filipe Manana <fdmanana@suse.com>
    btrfs: fix qgroup reservation leak on failure to allocate ordered extent

Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
    Revert "drm/i915/gem: Allow EXEC_CAPTURE on recoverable contexts on DG1"

Wang Zhaolong <wangzhaolong@huaweicloud.com>
    smb: client: fix race condition in negotiate timeout by using more precise timing

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: do not double read link status

Lion Ackermann <nnamrec@gmail.com>
    net/sched: Always pass notifications when child class becomes empty

Thomas Fourier <fourier.thomas@gmail.com>
    nui: Fix dma_mapping_error() check

Kohei Enju <enjuk@amazon.com>
    rose: fix dangling neighbour pointers in rose_rt_device_down()

Alok Tiwari <alok.a.tiwari@oracle.com>
    enic: fix incorrect MTU comparison in enic_change_mtu()

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: align CL37 AN sequence as per databook

Dan Carpenter <dan.carpenter@linaro.org>
    lib: test_objagg: Set error message in check_expect_hints_stats()

Vitaly Lifshits <vitaly.lifshits@intel.com>
    igc: disable L1.2 PCI-E link substate to avoid performance issue

Junxiao Chang <junxiao.chang@intel.com>
    drm/i915/gsc: mei interrupt top half should be in irq disabled context

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915/gt: Fix timeline left held on VMA alloc error

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: lan78xx: fix WARN in __netif_napi_del_locked on disconnect

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix warning when reconnecting channel

Alok Tiwari <alok.a.tiwari@oracle.com>
    platform/mellanox: mlxreg-lc: Fix logic error in power state check

Kurt Borja <kuurtb@gmail.com>
    platform/x86: dell-wmi-sysman: Fix class device unregistration

Thomas Weißschuh <linux@weissschuh.net>
    platform/x86: dell-sysman: Directly use firmware_attributes_class

Kurt Borja <kuurtb@gmail.com>
    platform/x86: think-lmi: Fix class device unregistration

Thomas Weißschuh <linux@weissschuh.net>
    platform/x86: think-lmi: Directly use firmware_attributes_class

Thomas Weißschuh <linux@weissschuh.net>
    platform/x86: firmware_attributes_class: Simplify API

Thomas Weißschuh <linux@weissschuh.net>
    platform/x86: firmware_attributes_class: Move include linux/device/class.h

Ricardo B. Marliere <ricardo@marliere.net>
    platform/x86: make fw_attr_class constant

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: qcom: sm8550: add UART14 nodes

Kurt Borja <kuurtb@gmail.com>
    platform/x86: dell-wmi-sysman: Fix WMI data block retrieval in sysfs callbacks

Dan Carpenter <dan.carpenter@linaro.org>
    drm/i915/selftests: Change mock_request() to return error pointers

James Clark <james.clark@linaro.org>
    spi: spi-fsl-dspi: Clear completion counter before initiating transfer

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/exynos: fimd: Guard display clock control with runtime PM calls

Fushuai Wang <wangfushuai@baidu.com>
    dpaa2-eth: fix xdp_rxq_info leak

Thomas Fourier <fourier.thomas@gmail.com>
    ethernet: atl1: Add missing DMA mapping error checks and count errors

Filipe Manana <fdmanana@suse.com>
    btrfs: use btrfs_record_snapshot_destroy() during rmdir

Filipe Manana <fdmanana@suse.com>
    btrfs: propagate last_unlink_trans earlier when doing a rmdir

Anand Jain <anand.jain@oracle.com>
    btrfs: rename err to ret in btrfs_rmdir()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix iteration of extrefs during log replay

Filipe Manana <fdmanana@suse.com>
    btrfs: fix missing error handling when searching for inode refs during log replay

Yang Li <yang.li@amlogic.com>
    Bluetooth: Prevent unintended pause by checking if advertising is active

Alok Tiwari <alok.a.tiwari@oracle.com>
    platform/mellanox: nvsw-sn2201: Fix bus number in adapter error message

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix vport loopback for MPV device

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix CC counters query for MPV

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix HW counters query for non-representor devices

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Fix spelling of a sysfs attribute name

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: qla4xxx: Fix missing DMA mapping error in qla4xxx_alloc_pdu()

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: qla2xxx: Fix DMA mapping test in qla24xx_get_port_database()

Benjamin Coddington <bcodding@redhat.com>
    NFSv4/pNFS: Fix a race to wake on NFS_LAYOUT_DRAIN

Kuniyuki Iwashima <kuniyu@google.com>
    nfs: Clean up /proc/net/rpc/nfs when nfs_fs_proc_net_init() fails.

Mark Zhang <markzhang@nvidia.com>
    RDMA/mlx5: Initialize obj_event->obj_sub_list before xa_insert

David Thompson <davthompson@nvidia.com>
    platform/mellanox: mlxbf-tmfifo: fix vring_desc.len assignment

Janne Grunau <j@jannau.net>
    arm64: dts: apple: t8103: Fix PCIe BCM4377 nodename

Sergey Senozhatsky <senozhatsky@chromium.org>
    mtk-sd: reset host->mrq on prepare_data() error

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    mtk-sd: Prevent memory corruption from DMA map failure

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    mtk-sd: Fix a pagefault in dma_unmap_sg() for not prepared data

RD Babiera <rdbabiera@google.com>
    usb: typec: altmodes/displayport: do not index invalid pin_assignments

Manivannan Sadhasivam <mani@kernel.org>
    regulator: gpio: Fix the out-of-bounds access to drvdata::gpiods

Christian Eggers <ceggers@arri.de>
    Bluetooth: MGMT: mesh_send: check instances prior disabling advertising

Christian Eggers <ceggers@arri.de>
    Bluetooth: MGMT: set_mesh: update LE scan interval and window

Christian Eggers <ceggers@arri.de>
    Bluetooth: hci_sync: revert some mesh modifications

Avri Altman <avri.altman@sandisk.com>
    mmc: core: sd: Apply BROKEN_SD_DISCARD quirk earlier

Ulf Hansson <ulf.hansson@linaro.org>
    Revert "mmc: sdhci: Disable SD card clock before changing parameters"

Victor Shih <victor.shih@genesyslogic.com.tw>
    mmc: sdhci: Add a helper function for dump register in dynamic debug mode

HarshaVardhana S A <harshavardhana.sa@broadcom.com>
    vsock/vmci: Clear the vmci transport packet properly when initializing it

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Do not try re-enabling load/store if device is disabled

Bui Quang Minh <minhquangbui99@gmail.com>
    virtio-net: ensure the received length does not exceed allocated size

Mateusz Jończyk <mat.jonczyk@o2.pl>
    rtc: cmos: use spin_lock_irqsave in cmos_interrupt

Elena Popa <elena.popa@nxp.com>
    rtc: pcf2127: fix SPI command byte for PCF2131

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    rtc: pcf2127: add missing semicolon after statement


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-devices-system-cpu |   1 +
 Documentation/ABI/testing/sysfs-driver-ufs         |   2 +-
 .../hw-vuln/processor_mmio_stale_data.rst          |   4 +-
 Documentation/admin-guide/kernel-parameters.txt    |  13 ++
 Documentation/arch/x86/mds.rst                     |   8 +-
 Documentation/core-api/symbol-namespaces.rst       |  22 +++
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/apple/t8103-jxxx.dtsi          |   2 +-
 arch/arm64/boot/dts/qcom/sm8550.dtsi               |  30 ++++
 arch/powerpc/include/uapi/asm/ioctls.h             |   8 +-
 arch/powerpc/kernel/Makefile                       |   2 -
 arch/s390/pci/pci_event.c                          |  18 +++
 arch/x86/Kconfig                                   |   9 ++
 arch/x86/entry/entry.S                             |   8 +-
 arch/x86/include/asm/cpu.h                         |  12 ++
 arch/x86/include/asm/cpufeatures.h                 |   6 +
 arch/x86/include/asm/irqflags.h                    |   4 +-
 arch/x86/include/asm/mwait.h                       |  28 ++--
 arch/x86/include/asm/nospec-branch.h               |  37 +++--
 arch/x86/include/uapi/asm/debugreg.h               |  21 ++-
 arch/x86/kernel/cpu/amd.c                          |  60 ++++++++
 arch/x86/kernel/cpu/bugs.c                         | 133 ++++++++++++++++-
 arch/x86/kernel/cpu/common.c                       |  38 +++--
 arch/x86/kernel/cpu/microcode/amd.c                |  12 --
 arch/x86/kernel/cpu/microcode/amd_shas.c           | 112 +++++++++++++++
 arch/x86/kernel/cpu/scattered.c                    |   2 +
 arch/x86/kernel/process.c                          |  16 ++-
 arch/x86/kernel/traps.c                            |  32 +++--
 arch/x86/kvm/cpuid.c                               |   8 +-
 arch/x86/kvm/reverse_cpuid.h                       |   8 ++
 arch/x86/kvm/svm/vmenter.S                         |   6 +
 arch/x86/kvm/vmx/vmx.c                             |   2 +-
 drivers/acpi/acpica/dsmethod.c                     |   7 +
 drivers/ata/libata-acpi.c                          |  24 ++--
 drivers/ata/pata_cs5536.c                          |   2 +-
 drivers/ata/pata_via.c                             |   6 +-
 drivers/base/cpu.c                                 |   3 +
 drivers/block/aoe/aoe.h                            |   1 +
 drivers/block/aoe/aoecmd.c                         |   8 +-
 drivers/block/aoe/aoedev.c                         |   5 +-
 drivers/dma-buf/dma-resv.c                         |  12 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |  12 ++
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |   2 +-
 drivers/gpu/drm/i915/gt/intel_gsc.c                |   2 +-
 drivers/gpu/drm/i915/gt/intel_ring_submission.c    |   3 +-
 drivers/gpu/drm/i915/selftests/i915_request.c      |  20 +--
 drivers/gpu/drm/i915/selftests/mock_request.c      |   2 +-
 drivers/gpu/drm/msm/msm_gem_submit.c               |  17 ++-
 drivers/gpu/drm/tiny/simpledrm.c                   |   4 +-
 drivers/gpu/drm/v3d/v3d_drv.h                      |   8 ++
 drivers/gpu/drm/v3d/v3d_gem.c                      |   2 +
 drivers/gpu/drm/v3d/v3d_irq.c                      |  37 +++--
 drivers/i2c/busses/i2c-designware-master.c         |   1 +
 drivers/infiniband/hw/mlx5/counters.c              |   4 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   2 +-
 drivers/infiniband/hw/mlx5/main.c                  |  33 +++++
 drivers/input/joystick/xpad.c                      |   2 +
 drivers/input/misc/iqs7222.c                       |   7 +-
 drivers/iommu/amd/iommu.c                          |   5 +-
 drivers/iommu/apple-dart.c                         |   5 +-
 drivers/iommu/intel/iommu.c                        |   5 +-
 drivers/iommu/iommu.c                              |  20 ++-
 drivers/iommu/msm_iommu.c                          |   5 +-
 drivers/iommu/mtk_iommu.c                          |   5 +-
 drivers/iommu/rockchip-iommu.c                     |   3 +-
 drivers/iommu/s390-iommu.c                         |  50 +++++--
 drivers/iommu/sprd-iommu.c                         |   5 +-
 drivers/iommu/sun50i-iommu.c                       |   6 +-
 drivers/mmc/core/quirks.h                          |  12 +-
 drivers/mmc/host/mtk-sd.c                          |  21 ++-
 drivers/mmc/host/sdhci.c                           |   9 +-
 drivers/mmc/host/sdhci.h                           |  16 +++
 drivers/mtd/nand/spi/core.c                        |   1 +
 drivers/net/ethernet/amd/xgbe/xgbe-common.h        |   2 +
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |  13 ++
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |  24 ++--
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   4 +-
 drivers/net/ethernet/atheros/atlx/atl1.c           |  79 +++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   7 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |   4 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  26 +++-
 drivers/net/ethernet/intel/igc/igc_main.c          |  10 ++
 drivers/net/ethernet/sun/niu.c                     |  31 +++-
 drivers/net/ethernet/sun/niu.h                     |   4 +
 drivers/net/usb/lan78xx.c                          |   2 -
 drivers/net/virtio_net.c                           |  38 ++++-
 drivers/net/wireless/ath/ath6kl/bmi.c              |   4 +-
 drivers/platform/mellanox/mlxbf-tmfifo.c           |   3 +-
 drivers/platform/mellanox/mlxreg-lc.c              |   2 +-
 drivers/platform/mellanox/nvsw-sn2201.c            |   2 +-
 drivers/platform/x86/amd/pmc/pmc-quirks.c          |   9 ++
 .../x86/dell/dell-wmi-sysman/dell-wmi-sysman.h     |   5 +
 .../x86/dell/dell-wmi-sysman/enum-attributes.c     |   5 +-
 .../x86/dell/dell-wmi-sysman/int-attributes.c      |   5 +-
 .../x86/dell/dell-wmi-sysman/passobj-attributes.c  |   5 +-
 .../x86/dell/dell-wmi-sysman/string-attributes.c   |   5 +-
 drivers/platform/x86/dell/dell-wmi-sysman/sysman.c |  25 ++--
 drivers/platform/x86/firmware_attributes_class.c   |  41 ++----
 drivers/platform/x86/firmware_attributes_class.h   |   5 +-
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c       |  14 +-
 drivers/platform/x86/think-lmi.c                   | 103 +++++--------
 drivers/powercap/intel_rapl_common.c               |  18 ++-
 drivers/regulator/fan53555.c                       |  14 ++
 drivers/regulator/gpio-regulator.c                 |   8 +-
 drivers/rtc/rtc-cmos.c                             |  10 +-
 drivers/rtc/rtc-pcf2127.c                          |   7 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   2 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |   2 +
 drivers/spi/spi-fsl-dspi.c                         |  11 +-
 drivers/target/target_core_pr.c                    |   4 +-
 drivers/ufs/core/ufs-sysfs.c                       |   4 +-
 drivers/ufs/core/ufshcd.c                          | 160 +++++++++++++++------
 drivers/usb/cdns3/cdnsp-ring.c                     |   4 +-
 drivers/usb/chipidea/udc.c                         |   7 +
 drivers/usb/core/quirks.c                          |   3 +-
 drivers/usb/host/xhci-dbgcap.c                     |   4 +
 drivers/usb/host/xhci-dbgtty.c                     |   1 +
 drivers/usb/host/xhci-mem.c                        |   4 +
 drivers/usb/host/xhci-pci.c                        |  25 ++++
 drivers/usb/host/xhci-plat.c                       |   3 +-
 drivers/usb/host/xhci.h                            |   1 +
 drivers/usb/typec/altmodes/displayport.c           |   5 +-
 fs/anon_inodes.c                                   |  23 ++-
 fs/btrfs/inode.c                                   |  56 ++++----
 fs/btrfs/ordered-data.c                            |  12 +-
 fs/btrfs/tree-log.c                                |   8 +-
 fs/f2fs/file.c                                     | 118 ++++++++++-----
 fs/nfs/flexfilelayout/flexfilelayout.c             | 121 +++++++++++-----
 fs/nfs/inode.c                                     |  17 ++-
 fs/nfs/pnfs.c                                      |   4 +-
 fs/smb/client/cifsglob.h                           |   2 +
 fs/smb/client/connect.c                            |   7 +-
 fs/smb/client/readdir.c                            |   2 +-
 fs/smb/client/smb2pdu.c                            |  10 +-
 fs/smb/client/trace.h                              |  18 +--
 include/linux/cpu.h                                |   1 +
 include/linux/export.h                             |  12 +-
 include/linux/fs.h                                 |   2 +
 include/linux/iommu.h                              |   4 +-
 include/linux/libata.h                             |   7 +-
 include/linux/usb/typec_dp.h                       |   1 +
 include/net/bluetooth/hci_core.h                   |   2 +
 include/trace/events/f2fs.h                        |  39 +++--
 include/ufs/ufshcd.h                               |   4 +
 kernel/rcu/tree.c                                  |   4 +
 lib/test_objagg.c                                  |   4 +-
 mm/secretmem.c                                     |  11 +-
 net/bluetooth/hci_core.c                           |  34 ++++-
 net/bluetooth/hci_sync.c                           |  20 ++-
 net/bluetooth/mgmt.c                               |  25 +++-
 net/mac80211/chan.c                                |   6 +-
 net/mac80211/ieee80211_i.h                         |   9 ++
 net/mac80211/link.c                                |  15 +-
 net/mac80211/rx.c                                  |   4 +
 net/rose/rose_route.c                              |  15 +-
 net/sched/sch_api.c                                |  19 +--
 net/vmw_vsock/vmci_transport.c                     |   4 +-
 sound/isa/sb/sb16_main.c                           |   7 +
 sound/soc/amd/yc/acp6x-mach.c                      |  14 ++
 159 files changed, 1840 insertions(+), 657 deletions(-)


