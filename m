Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CF02E11DA;
	Tue,  8 Jul 2025 16:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751991861; cv=none; b=eac9g50DhXtHxcl4/6CKkMO3rrCPEIoWErt+ZQrrk3xR4e/qiTbdE01v0iAfxfDoYNTuDCKLUjSwm0E/woxJR/fsgCltjoqIeEMlLoxHPWIisSnjHih6ydzBva7dgtbh6n4J30YUm72MXNHVhj+qsTEJMLi9qOoLjZ48P8/KLLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751991861; c=relaxed/simple;
	bh=+pCpo8Ni5qzpjLPbVW3AiiWqLAcYbSNSmcPT3HxeKN0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WN+7Bm8zJDRSih/Y4YIc3bL/Q3N+UXvazp76xu44I3QHaOI6vFBfSnJG4S7yvGrqI8vo30fHPqm/NRKPKZvWlXeNaD8mKdWsi/O/73UY+Zxiz16BVsakbvpft9SnPRxHHFs2qCf58+IrWHi7gL9+1ar9tM1Xb59keJSii7rs95Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXmFn+yF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXmFn+yF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77571C4CEF6;
	Tue,  8 Jul 2025 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751991861;
	bh=+pCpo8Ni5qzpjLPbVW3AiiWqLAcYbSNSmcPT3HxeKN0=;
	h=From:To:Cc:Subject:Date:From;
	b=YXmFn+yFhrv7vOb/L6T08kebQqLOJ4QoyYMd2RoyA9gqXhCnEWglMNoAFI4Qx6OTt
	 u7l2aTSvUmpg8Ml/Hh5qKZGB9CnofVWnUQgPKcW3EyvP/A5au+p+hYE3ax2yzatEwG
	 NxrlXKyWusCEhz6c+hK7lVIsPLfoF12jzGupI4ds=
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
Subject: [PATCH 6.1 00/81] 6.1.144-rc1 review
Date: Tue,  8 Jul 2025 18:22:52 +0200
Message-ID: <20250708162224.795155912@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.144-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.144-rc1
X-KernelTest-Deadline: 2025-07-10T16:22+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.144 release.
There are 81 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.144-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.144-rc1

Borislav Petkov (AMD) <bp@alien8.de>
    x86/process: Move the buffer clearing before MONITOR

Borislav Petkov (AMD) <bp@alien8.de>
    KVM: SVM: Advertise TSA CPUID bits to guests

Borislav Petkov (AMD) <bp@alien8.de>
    x86/bugs: Add a Transient Scheduler Attacks mitigation

Borislav Petkov (AMD) <bp@alien8.de>
    x86/bugs: Rename MDS machinery to something more generic

Andrei Kuchynski <akuchynski@chromium.org>
    usb: typec: displayport: Fix potential deadlock

Kurt Borja <kuurtb@gmail.com>
    platform/x86: think-lmi: Fix kobject cleanup

Kurt Borja <kuurtb@gmail.com>
    platform/x86: think-lmi: Create ksets consecutively

Oliver Neukum <oneukum@suse.com>
    Logitech C-270 even more broken

Michael J. Ruhl <michael.j.ruhl@intel.com>
    i2c/designware: Fix an initialization issue

Christian König <christian.koenig@amd.com>
    dma-buf: fix timeout handling in dma_resv_wait_timeout v2

Peter Chen <peter.chen@cixtech.com>
    usb: cdnsp: do not disable slot for disabled slot

Hongyu Xie <xiehongyu1@kylinos.cn>
    xhci: Disable stream for xHC controller with XHCI_BROKEN_STREAMS

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: Flush queued requests before stopping dbc

Łukasz Bartosik <ukaszb@chromium.org>
    xhci: dbctty: disable ECHO flag by default

Oleksij Rempel <linux@rempel-privat.de>
    net: usb: lan78xx: fix WARN in __netif_napi_del_locked on disconnect

Kurt Borja <kuurtb@gmail.com>
    platform/x86: dell-wmi-sysman: Fix class device unregistration

Kurt Borja <kuurtb@gmail.com>
    platform/x86: think-lmi: Fix class device unregistration

Fushuai Wang <wangfushuai@baidu.com>
    dpaa2-eth: fix xdp_rxq_info leak

Filipe Manana <fdmanana@suse.com>
    btrfs: use btrfs_record_snapshot_destroy() during rmdir

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/flexfiles: Fix handling of NFS level errors in I/O

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Disable interrupts before resetting the GPU

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Fix stale function handles in error handling

Bui Quang Minh <minhquangbui99@gmail.com>
    virtio-net: ensure the received length does not exceed allocated size

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

Raven Black <ravenblack@gmail.com>
    ASoC: amd: yc: update quirk data for HP Victus

Madhavan Srinivasan <maddy@linux.ibm.com>
    powerpc: Fix struct termio related ioctl macros

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

Wang Zhaolong <wangzhaolong@huaweicloud.com>
    smb: client: fix race condition in negotiate timeout by using more precise timing

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

Alok Tiwari <alok.a.tiwari@oracle.com>
    platform/mellanox: mlxreg-lc: Fix logic error in power state check

Kurt Borja <kuurtb@gmail.com>
    platform/x86: dell-wmi-sysman: Fix WMI data block retrieval in sysfs callbacks

Dan Carpenter <dan.carpenter@linaro.org>
    drm/i915/selftests: Change mock_request() to return error pointers

James Clark <james.clark@linaro.org>
    spi: spi-fsl-dspi: Clear completion counter before initiating transfer

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/exynos: fimd: Guard display clock control with runtime PM calls

Thomas Fourier <fourier.thomas@gmail.com>
    ethernet: atl1: Add missing DMA mapping error checks and count errors

Filipe Manana <fdmanana@suse.com>
    btrfs: fix iteration of extrefs during log replay

Filipe Manana <fdmanana@suse.com>
    btrfs: fix missing error handling when searching for inode refs during log replay

Yang Li <yang.li@amlogic.com>
    Bluetooth: Prevent unintended pause by checking if advertising is active

Alok Tiwari <alok.a.tiwari@oracle.com>
    platform/mellanox: nvsw-sn2201: Fix bus number in adapter error message

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix CC counters query for MPV

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

Mateusz Jończyk <mat.jonczyk@o2.pl>
    rtc: cmos: use spin_lock_irqsave in cmos_interrupt


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-devices-system-cpu |   1 +
 Documentation/ABI/testing/sysfs-driver-ufs         |   2 +-
 .../hw-vuln/processor_mmio_stale_data.rst          |   4 +-
 Documentation/admin-guide/kernel-parameters.txt    |  13 ++
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/apple/t8103-jxxx.dtsi          |   2 +-
 arch/powerpc/include/uapi/asm/ioctls.h             |   8 +-
 arch/s390/pci/pci_event.c                          |  20 ++++
 arch/x86/Kconfig                                   |   9 ++
 arch/x86/entry/entry.S                             |   8 +-
 arch/x86/include/asm/cpu.h                         |  12 ++
 arch/x86/include/asm/cpufeatures.h                 |   6 +
 arch/x86/include/asm/irqflags.h                    |   4 +-
 arch/x86/include/asm/mwait.h                       |  19 ++-
 arch/x86/include/asm/nospec-branch.h               |  39 +++---
 arch/x86/kernel/cpu/amd.c                          |  58 +++++++++
 arch/x86/kernel/cpu/bugs.c                         | 133 ++++++++++++++++++++-
 arch/x86/kernel/cpu/common.c                       |  14 ++-
 arch/x86/kernel/cpu/scattered.c                    |   2 +
 arch/x86/kernel/process.c                          |  15 ++-
 arch/x86/kvm/cpuid.c                               |   9 +-
 arch/x86/kvm/reverse_cpuid.h                       |   8 ++
 arch/x86/kvm/svm/vmenter.S                         |   6 +
 arch/x86/kvm/vmx/vmx.c                             |   2 +-
 drivers/acpi/acpica/dsmethod.c                     |   7 ++
 drivers/ata/libata-acpi.c                          |  24 ++--
 drivers/ata/pata_cs5536.c                          |   2 +-
 drivers/ata/pata_via.c                             |   6 +-
 drivers/base/cpu.c                                 |   2 +
 drivers/block/aoe/aoe.h                            |   1 +
 drivers/block/aoe/aoecmd.c                         |   8 +-
 drivers/block/aoe/aoedev.c                         |   5 +-
 drivers/dma-buf/dma-resv.c                         |  12 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |  12 ++
 drivers/gpu/drm/i915/gt/intel_gsc.c                |   2 +-
 drivers/gpu/drm/i915/gt/intel_ring_submission.c    |   3 +-
 drivers/gpu/drm/i915/selftests/i915_request.c      |  20 ++--
 drivers/gpu/drm/i915/selftests/mock_request.c      |   2 +-
 drivers/gpu/drm/msm/msm_gem_submit.c               |  17 ++-
 drivers/gpu/drm/v3d/v3d_drv.h                      |   8 ++
 drivers/gpu/drm/v3d/v3d_gem.c                      |   2 +
 drivers/gpu/drm/v3d/v3d_irq.c                      |  37 ++++--
 drivers/i2c/busses/i2c-designware-master.c         |   1 +
 drivers/infiniband/hw/mlx5/counters.c              |   2 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   2 +-
 drivers/mmc/core/quirks.h                          |  12 +-
 drivers/mmc/host/mtk-sd.c                          |  21 +++-
 drivers/mmc/host/sdhci.c                           |   9 +-
 drivers/mmc/host/sdhci.h                           |  16 +++
 drivers/mtd/nand/spi/core.c                        |   1 +
 drivers/net/ethernet/amd/xgbe/xgbe-common.h        |   2 +
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |   9 ++
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   4 +-
 drivers/net/ethernet/atheros/atlx/atl1.c           |  79 ++++++++----
 drivers/net/ethernet/cisco/enic/enic_main.c        |   4 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  26 +++-
 drivers/net/ethernet/intel/igc/igc_main.c          |  10 ++
 drivers/net/ethernet/sun/niu.c                     |  31 ++++-
 drivers/net/ethernet/sun/niu.h                     |   4 +
 drivers/net/usb/lan78xx.c                          |   2 -
 drivers/net/virtio_net.c                           |  38 +++++-
 drivers/net/wireless/ath/ath6kl/bmi.c              |   4 +-
 drivers/platform/mellanox/mlxbf-tmfifo.c           |   3 +-
 drivers/platform/mellanox/mlxreg-lc.c              |   2 +-
 drivers/platform/mellanox/nvsw-sn2201.c            |   2 +-
 .../x86/dell/dell-wmi-sysman/dell-wmi-sysman.h     |   5 +
 .../x86/dell/dell-wmi-sysman/enum-attributes.c     |   5 +-
 .../x86/dell/dell-wmi-sysman/int-attributes.c      |   5 +-
 .../x86/dell/dell-wmi-sysman/passobj-attributes.c  |   5 +-
 .../x86/dell/dell-wmi-sysman/string-attributes.c   |   5 +-
 drivers/platform/x86/dell/dell-wmi-sysman/sysman.c |  12 +-
 drivers/platform/x86/think-lmi.c                   |  53 ++++----
 drivers/regulator/gpio-regulator.c                 |   8 +-
 drivers/rtc/rtc-cmos.c                             |  10 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   2 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |   2 +
 drivers/spi/spi-fsl-dspi.c                         |  11 +-
 drivers/target/target_core_pr.c                    |   4 +-
 drivers/ufs/core/ufs-sysfs.c                       |   4 +-
 drivers/usb/cdns3/cdnsp-ring.c                     |   4 +-
 drivers/usb/core/quirks.c                          |   3 +-
 drivers/usb/host/xhci-dbgcap.c                     |   4 +
 drivers/usb/host/xhci-dbgtty.c                     |   1 +
 drivers/usb/host/xhci-plat.c                       |   3 +-
 drivers/usb/typec/altmodes/displayport.c           |   5 +-
 fs/btrfs/inode.c                                   |   7 +-
 fs/btrfs/tree-log.c                                |   8 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             | 121 +++++++++++++------
 fs/nfs/inode.c                                     |  17 ++-
 fs/nfs/pnfs.c                                      |   4 +-
 fs/smb/client/cifsglob.h                           |   1 +
 fs/smb/client/connect.c                            |   7 +-
 include/linux/cpu.h                                |   1 +
 include/linux/libata.h                             |   7 +-
 include/linux/usb/typec_dp.h                       |   1 +
 kernel/rcu/tree.c                                  |   4 +
 lib/test_objagg.c                                  |   4 +-
 net/bluetooth/hci_sync.c                           |  20 ++--
 net/bluetooth/mgmt.c                               |  25 +++-
 net/mac80211/rx.c                                  |   4 +
 net/rose/rose_route.c                              |  15 +--
 net/sched/sch_api.c                                |  19 +--
 net/vmw_vsock/vmci_transport.c                     |   4 +-
 sound/isa/sb/sb16_main.c                           |   7 ++
 sound/soc/amd/yc/acp6x-mach.c                      |   7 ++
 105 files changed, 982 insertions(+), 304 deletions(-)


