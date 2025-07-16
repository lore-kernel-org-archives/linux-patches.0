Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3542C2153C6;
	Wed, 16 Jul 2025 14:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752675262; cv=none; b=MqMBOK1R2MZEH2Y3EjT2b4oHmx7CsEAUwtbYbjrjSYCSWaI1d2QrMPYBaTQ1PbyzlqwwclS3+xPv1Ib1hCSe/aVCGWFQc4ntEZSqmt8wpp0t+YVmF3zpitjiQ+SUMdxYJbWINIL4UBjqDb/2BTF6AdKdLmNO6KjxaCJ03e6+69A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752675262; c=relaxed/simple;
	bh=hJQYZ3dBSCJkW7dz3e5TLoM52l7ptu1WpiWY8ZjY2Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NOyLi2lfRxtmPltvN/iodLUu+NDb+CoWMI8ajo/L9B0EyDrsdacWbtkRIZOws6OH9fidIn5aSwfpyZwm60G/DvOChV3My7QRsaBbRN98WopzaYEdVRsbqddtDeYpJreP1FjeVUw+RHQSIIzAtkadoweKAOUHgnoLA1FS01l6QmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SlO3jpvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SlO3jpvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40611C4CEE7;
	Wed, 16 Jul 2025 14:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752675261;
	bh=hJQYZ3dBSCJkW7dz3e5TLoM52l7ptu1WpiWY8ZjY2Gc=;
	h=From:To:Cc:Subject:Date:From;
	b=SlO3jpvfJuLa4gmtBiWc7cdMQt/W56BOzdzMRrwjlfX/NWoORiSTZ3gSPrriH6lDs
	 LqI9oItAm4NR+AZp7Q/IxsxmQ9IdrACZCHURSNpXveOLhGNLbRY4VuAFve5F18E1Cc
	 V4QL7mggGUVP6UP0UoyyibP4U7Z8vVgE/5SDTbzk=
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
Subject: [PATCH 5.4 000/144] 5.4.296-rc2 review
Date: Wed, 16 Jul 2025 16:14:18 +0200
Message-ID: <20250716141302.507854168@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.296-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.296-rc2
X-KernelTest-Deadline: 2025-07-18T14:13+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.4.296 release.
There are 144 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 18 Jul 2025 14:12:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.296-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.296-rc2

Georg Kohmann <geokohma@cisco.com>
    net: ipv6: Discard next-hop MTU less than minimum link MTU

Jann Horn <jannh@google.com>
    x86/mm: Disable hugetlb page table sharing on 32-bit

Hans de Goede <hdegoede@redhat.com>
    Input: atkbd - do not skip atkbd_deactivate() when skipping ATKBD_CMD_GETID

Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
    HID: quirks: Add quirk for 2 Chicony Electronics HP 5MP Cameras

Zhang Heng <zhangheng@kylinos.cn>
    HID: Add IGNORE quirk for SMARTLINKTECHNOLOGY

Nicolas Pitre <npitre@baylibre.com>
    vt: add missing notification when switching back to text mode

Xiaowei Li <xiaowei.li@simcom.com>
    net: usb: qmi_wwan: add SIMCom 8230C composition

Thomas Fourier <fourier.thomas@gmail.com>
    atm: idt77252: Add missing `dma_map_error()`

Somnath Kotur <somnath.kotur@broadcom.com>
    bnxt_en: Set DMA unmap len correctly for XDP_REDIRECT

Shravya KN <shravya.k-n@broadcom.com>
    bnxt_en: Fix DCB ETS validation

Sean Nyekjaer <sean@geanix.com>
    can: m_can: m_can_handle_lost_msg(): downgrade msg lost in rx message to debug level

Oleksij Rempel <linux@rempel-privat.de>
    net: phy: microchip: limit 100M workaround to link-down events on LAN88xx

Kito Xu <veritas501@foxmail.com>
    net: appletalk: Fix device refcount leak in atrtr_create()

Wang Jinchao <wangjinchao600@gmail.com>
    md/raid1: Fix stack memory use after return in raid1_reshape

Daniil Dulov <d.dulov@aladdin.ru>
    wifi: zd1211rw: Fix potential NULL pointer dereference in zd_mac_tx_to_dev()

Christian König <christian.koenig@amd.com>
    dma-buf: fix timeout handling in dma_resv_wait_timeout v2

Nilton Perim Neto <niltonperimneto@gmail.com>
    Input: xpad - support Acer NGR 200 Controller

Vicki Pfau <vi@endrift.com>
    Input: xpad - add VID for Turtle Beach controllers

Matt Reynolds <mattreynolds@chromium.org>
    Input: xpad - add support for Amazon Game Controller

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/flexfiles: Fix handling of NFS level errors in I/O

Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
    flexfiles/pNFS: update stats on NFS4ERR_DELAY for v4.1 DSes

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix vport loopback for MPV device

Kuniyuki Iwashima <kuniyu@google.com>
    netlink: Fix rmem check in netlink_broadcast_deliver().

Jakub Kicinski <kuba@kernel.org>
    netlink: make sure we allow at least one dump skb

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: mediatek: Ensure to disable clocks in error path

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "ACPI: battery: negate current when discharging"

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: u_serial: Fix race condition in TTY wakeup

Matthew Brost <matthew.brost@intel.com>
    drm/sched: Increment job count before swapping tail spsc queue

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    pinctrl: qcom: msm: mark certain pins as invalid for interrupts

JP Kobryn <inwardvessel@gmail.com>
    x86/mce: Make sure CMCI banks are cleared during shutdown on Intel

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/mce: Don't remove sysfs if thresholding sysfs init fails

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/mce/amd: Fix threshold limit reset

David Howells <dhowells@redhat.com>
    rxrpc: Fix oops due to non-existence of prealloc backlog struct

Victor Nogueira <victor@mojatatu.com>
    net/sched: Abort __tc_modify_qdisc if parent class does not exist

Yue Haibing <yuehaibing@huawei.com>
    atm: clip: Fix NULL pointer dereference in vcc_sendmsg()

Kuniyuki Iwashima <kuniyu@google.com>
    atm: clip: Fix infinite recursive call of clip_push().

Kuniyuki Iwashima <kuniyu@google.com>
    atm: clip: Fix memory leak of struct clip_vcc.

Kuniyuki Iwashima <kuniyu@google.com>
    atm: clip: Fix potential null-ptr-deref in to_atmarpd().

Kuniyuki Iwashima <kuniyu@google.com>
    tipc: Fix use-after-free in tipc_conn_close().

Kuniyuki Iwashima <kuniyu@google.com>
    netlink: Fix wraparounds of sk->sk_rmem_alloc.

Al Viro <viro@zeniv.linux.org.uk>
    fix proc_sys_compare() handling of in-lookup dentries

Eric W. Biederman <ebiederm@xmission.com>
    proc: Clear the pieces of proc_inode that proc_evict_inode cares about

Kaustabh Chakraborty <kauschluss@disroot.org>
    drm/exynos: exynos7_drm_decon: add vblank check in IRQ handling

Nathan Chancellor <nathan@kernel.org>
    staging: rtl8723bs: Avoid memset() in aes_cipher() and aes_decipher()

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Rollback non processed entities on error

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Send control events for partial succeeds

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Return the number of processed controls

Seiji Nishikawa <snishika@redhat.com>
    ACPI: PAD: fix crash in exit_round_robin()

Andrei Kuchynski <akuchynski@chromium.org>
    usb: typec: displayport: Fix potential deadlock

Oliver Neukum <oneukum@suse.com>
    Logitech C-270 even more broken

Kohei Enju <enjuk@amazon.com>
    rose: fix dangling neighbour pointers in rose_rt_device_down()

Gustavo A. R. Silva <gustavoars@kernel.org>
    net: rose: Fix fall-through warnings for Clang

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915/gt: Fix timeline left held on VMA alloc error

Dan Carpenter <dan.carpenter@linaro.org>
    drm/i915/selftests: Change mock_request() to return error pointers

James Clark <james.clark@linaro.org>
    spi: spi-fsl-dspi: Clear completion counter before initiating transfer

Vladimir Oltean <vladimir.oltean@nxp.com>
    spi: spi-fsl-dspi: Fix interrupt-less DMA mode taking an XSPI code path

Vladimir Oltean <vladimir.oltean@nxp.com>
    spi: spi-fsl-dspi: Rename fifo_{read,write} and {tx,cmd}_fifo_write

Fushuai Wang <wangfushuai@baidu.com>
    dpaa2-eth: fix xdp_rxq_info leak

Thomas Fourier <fourier.thomas@gmail.com>
    ethernet: atl1: Add missing DMA mapping error checks and count errors

Filipe Manana <fdmanana@suse.com>
    btrfs: use btrfs_record_snapshot_destroy() during rmdir

Filipe Manana <fdmanana@suse.com>
    btrfs: propagate last_unlink_trans earlier when doing a rmdir

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix CC counters query for MPV

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Create and destroy counters in the ib_core

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Fix spelling of a sysfs attribute name

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Disable interrupts before resetting the GPU

Sergey Senozhatsky <senozhatsky@chromium.org>
    mtk-sd: reset host->mrq on prepare_data() error

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    mtk-sd: Prevent memory corruption from DMA map failure

Yue Hu <huyue2@yulong.com>
    mmc: mediatek: use data instead of mrq parameter from msdc_{un}prepare_data()

Manivannan Sadhasivam <mani@kernel.org>
    regulator: gpio: Fix the out-of-bounds access to drvdata::gpiods

Jerome Neanne <jneanne@baylibre.com>
    regulator: gpio: Add input_supply support in gpio_regulator_config

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Refuse to evaluate a method if arguments are missing

Johannes Berg <johannes.berg@intel.com>
    wifi: ath6kl: remove WARN on bad firmware input

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: drop invalid source address OCB frames

Madhavan Srinivasan <maddy@linux.ibm.com>
    powerpc: Fix struct termio related ioctl macros

Johannes Berg <johannes.berg@intel.com>
    ata: pata_cs5536: fix build on 32-bit UML

Takashi Iwai <tiwai@suse.de>
    ALSA: sb: Force to disable DMAs once when DMA mode is changed

Lion Ackermann <nnamrec@gmail.com>
    net/sched: Always pass notifications when child class becomes empty

Thomas Fourier <fourier.thomas@gmail.com>
    nui: Fix dma_mapping_error() check

Alok Tiwari <alok.a.tiwari@oracle.com>
    enic: fix incorrect MTU comparison in enic_change_mtu()

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: align CL37 AN sequence as per databook

Dan Carpenter <dan.carpenter@linaro.org>
    lib: test_objagg: Set error message in check_expect_hints_stats()

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/exynos: fimd: Guard display clock control with runtime PM calls

Filipe Manana <fdmanana@suse.com>
    btrfs: fix missing error handling when searching for inode refs during log replay

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: qla4xxx: Fix missing DMA mapping error in qla4xxx_alloc_pdu()

Kuniyuki Iwashima <kuniyu@google.com>
    nfs: Clean up /proc/net/rpc/nfs when nfs_fs_proc_net_init() fails.

Mark Zhang <markzhang@nvidia.com>
    RDMA/mlx5: Initialize obj_event->obj_sub_list before xa_insert

David Thompson <davthompson@nvidia.com>
    platform/mellanox: mlxbf-tmfifo: fix vring_desc.len assignment

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    mtk-sd: Fix a pagefault in dma_unmap_sg() for not prepared data

RD Babiera <rdbabiera@google.com>
    usb: typec: altmodes/displayport: do not index invalid pin_assignments

Ulf Hansson <ulf.hansson@linaro.org>
    Revert "mmc: sdhci: Disable SD card clock before changing parameters"

Victor Shih <victor.shih@genesyslogic.com.tw>
    mmc: sdhci: Add a helper function for dump register in dynamic debug mode

HarshaVardhana S A <harshavardhana.sa@broadcom.com>
    vsock/vmci: Clear the vmci transport packet properly when initializing it

Omar Sandoval <osandov@fb.com>
    btrfs: don't abort filesystem when attempting to snapshot deleted subvolume

Dev Jain <dev.jain@arm.com>
    arm64: Restrict pagetable teardown to avoid false warning

Nathan Chancellor <nathan@kernel.org>
    s390: Add '-std=gnu11' to decompressor and purgatory CFLAGS

Aradhya Bhatia <a-bhatia1@ti.com>
    drm/bridge: cdns-dsi: Check return value when getting default PHY config

Aradhya Bhatia <a-bhatia1@ti.com>
    drm/bridge: cdns-dsi: Fix connecting to next bridge

Aradhya Bhatia <a-bhatia1@ti.com>
    drm/bridge: cdns-dsi: Fix the clock variable for mode_valid()

Thierry Reding <treding@nvidia.com>
    drm/tegra: Assign plane type before registration

Qasim Ijaz <qasdev00@gmail.com>
    HID: wacom: fix kobject reference count leak

Qasim Ijaz <qasdev00@gmail.com>
    HID: wacom: fix memory leak on sysfs attribute creation failure

Qasim Ijaz <qasdev00@gmail.com>
    HID: wacom: fix memory leak on kobject creation failure

Heinz Mauelshagen <heinzm@redhat.com>
    dm-raid: fix variable in journal device check

Frédéric Danis <frederic.danis@collabora.com>
    Bluetooth: L2CAP: Fix L2CAP MTU negotiation

Kuniyuki Iwashima <kuniyu@google.com>
    atm: Release atm_dev_mutex after removing procfs in atm_dev_deregister().

Simon Horman <horms@kernel.org>
    net: enetc: Correct endianness handling in _enetc_rd_reg64

Tiwei Bie <tiwei.btw@antgroup.com>
    um: ubd: Add missing error check in start_io_thread()

Stefano Garzarella <sgarzare@redhat.com>
    vsock/uapi: fix linux/vm_sockets.h userspace compilation errors

Lachlan Hodges <lachlan.hodges@morsemicro.com>
    wifi: mac80211: fix beacon interval calculation overflow

Al Viro <viro@zeniv.linux.org.uk>
    attach_recursive_mnt(): do not lock the covering tree when sliding something under it

Youngjun Lee <yjjuny.lee@samsung.com>
    ALSA: usb-audio: Fix out-of-bounds read in snd_usb_get_audioformat_uac3()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: robotfuzz-osif: disable zero-length read messages

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: tiny-usb: disable zero-length read messages

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    RDMA/iwcm: Fix use-after-free of work objects after cm_id destruction

Weihang Li <liweihang@huawei.com>
    RDMA/core: Use refcount_t instead of atomic_t on refcount of iwcm_id_private

Denis Arefev <arefev@swemel.ru>
    media: vivid: Change the siize of the composing

Marek Szyprowski <m.szyprowski@samsung.com>
    media: omap3isp: use sgtable-based scatterlist wrappers

Edward Adam Davis <eadavis@qq.com>
    media: cxusb: no longer judge rbuf when the write fails

Sean Young <sean@mess.org>
    media: cxusb: use dev_dbg() rather than hand-rolled debug

Vasiliy Kovalev <kovalev@altlinux.org>
    jfs: validate AG parameters in dbMount() to prevent crashes

Dave Kleikamp <dave.kleikamp@oracle.com>
    fs/jfs: consolidate sanity checking in dbMount

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    ASoC: meson: meson-card-utils: use of_property_present() for DT parsing

Rob Herring <robh@kernel.org>
    of: Add of_property_present() helper

Michael Walle <michael@walle.cc>
    of: property: define of_property_read_u{8,16,32,64}_array() unconditionally

Arnd Bergmann <arnd@arndb.de>
    kbuild: hdrcheck: fix cross build with clang

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: add --target to correctly cross-compile UAPI headers with Clang

Masahiro Yamada <masahiroy@kernel.org>
    bpfilter: match bit size of bpfilter_umh to that of the kernel

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: use -MMD instead of -MD to exclude system headers from dependency

Wupeng Ma <mawupeng1@huawei.com>
    VMCI: fix race between vmci_host_setup_notify and vmci_ctx_unset_notify

George Kennedy <george.kennedy@oracle.com>
    VMCI: check context->notify_page after call to get_user_pages_fast() to avoid GPF

Kees Cook <kees@kernel.org>
    ovl: Check for NULL d_inode() in ovl_dentry_upper()

Dmitry Kandybka <d.kandybka@gmail.com>
    ceph: fix possible integer overflow in ceph_zero_objects()

Cezary Rojewski <cezary.rojewski@intel.com>
    ALSA: hda: Ignore unsol events for cards being shut down

Jos Wang <joswang@lenovo.com>
    usb: typec: displayport: Receive DP Status Update NAK request exit dp altmode

Robert Hodaszi <robert.hodaszi@digi.com>
    usb: cdc-wdm: avoid setting WDM_READ for ZLP-s

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: Add checks for snprintf() calls in usb_alloc_dev()

Jakub Lewalski <jakub.lewalski@nokia.com>
    tty: serial: uartlite: register uart driver in init

Chen Yufeng <chenyufeng@iie.ac.cn>
    usb: potential integer overflow in usbg_make_tpg()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: pressure: zpa2326: Use aligned_s64 for the timestamp

Yu Kuai <yukuai3@huawei.com>
    md/md-bitmap: fix dm-raid max_write_behind setting

Thomas Gessler <thomas.gessler@brueckmann-gmbh.de>
    dmaengine: xilinx_dma: Set dma_device directions

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    mfd: max14577: Fix wakeup source leaks on device unbind

Peng Fan <peng.fan@nxp.com>
    mailbox: Not protect module_put with spin_lock_irqsave

Pali Rohár <pali@kernel.org>
    cifs: Fix cifs_query_path_info() for Windows NT servers


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-driver-ufs         |   2 +-
 Makefile                                           |   4 +-
 arch/arm64/mm/mmu.c                                |   3 +-
 arch/powerpc/include/uapi/asm/ioctls.h             |   8 +-
 arch/s390/Makefile                                 |   2 +-
 arch/s390/purgatory/Makefile                       |   2 +-
 arch/um/drivers/ubd_user.c                         |   2 +-
 arch/x86/Kconfig                                   |   2 +-
 arch/x86/kernel/cpu/mce/amd.c                      |  15 +-
 arch/x86/kernel/cpu/mce/core.c                     |   8 +-
 arch/x86/kernel/cpu/mce/intel.c                    |   1 +
 drivers/acpi/acpi_pad.c                            |   7 +-
 drivers/acpi/acpica/dsmethod.c                     |   7 +
 drivers/acpi/battery.c                             |  19 +-
 drivers/ata/pata_cs5536.c                          |   2 +-
 drivers/atm/idt77252.c                             |   5 +
 drivers/dma-buf/dma-resv.c                         |   5 +-
 drivers/dma/xilinx/xilinx_dma.c                    |   2 +
 drivers/gpu/drm/bridge/cdns-dsi.c                  |  11 +-
 drivers/gpu/drm/exynos/exynos7_drm_decon.c         |   4 +
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |  12 +
 drivers/gpu/drm/i915/gt/intel_ringbuffer.c         |   3 +-
 drivers/gpu/drm/i915/selftests/i915_request.c      |  20 +-
 drivers/gpu/drm/i915/selftests/mock_request.c      |   2 +-
 drivers/gpu/drm/tegra/dc.c                         |  12 +-
 drivers/gpu/drm/tegra/hub.c                        |   4 +-
 drivers/gpu/drm/tegra/hub.h                        |   3 +-
 drivers/gpu/drm/v3d/v3d_drv.h                      |   9 +
 drivers/gpu/drm/v3d/v3d_gem.c                      |   2 +
 drivers/gpu/drm/v3d/v3d_irq.c                      |  36 ++-
 drivers/hid/hid-ids.h                              |   5 +
 drivers/hid/hid-quirks.c                           |   3 +
 drivers/hid/wacom_sys.c                            |   6 +-
 drivers/i2c/busses/i2c-robotfuzz-osif.c            |   6 +
 drivers/i2c/busses/i2c-tiny-usb.c                  |   6 +
 drivers/iio/pressure/zpa2326.c                     |   2 +-
 drivers/infiniband/core/device.c                   |   1 +
 drivers/infiniband/core/iwcm.c                     |  38 +--
 drivers/infiniband/core/iwcm.h                     |   2 +-
 .../infiniband/core/uverbs_std_types_counters.c    |  17 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   2 +-
 drivers/infiniband/hw/mlx5/main.c                  |  55 ++--
 drivers/input/joystick/xpad.c                      |   5 +
 drivers/input/keyboard/atkbd.c                     |   3 +-
 drivers/mailbox/mailbox.c                          |   2 +-
 drivers/md/dm-raid.c                               |   2 +-
 drivers/md/md-bitmap.c                             |   2 +-
 drivers/md/raid1.c                                 |   1 +
 drivers/media/platform/omap3isp/ispccdc.c          |   8 +-
 drivers/media/platform/omap3isp/ispstat.c          |   6 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |   2 +-
 drivers/media/usb/dvb-usb/cxusb.c                  |  36 ++-
 drivers/media/usb/uvc/uvc_ctrl.c                   |  61 +++--
 drivers/mfd/max14577.c                             |   1 +
 drivers/misc/vmw_vmci/vmci_host.c                  |   9 +-
 drivers/mmc/host/mtk-sd.c                          |  39 ++-
 drivers/mmc/host/sdhci.c                           |   9 +-
 drivers/mmc/host/sdhci.h                           |  16 ++
 drivers/net/can/m_can/m_can.c                      |   2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-common.h        |   2 +
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |   9 +
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   4 +-
 drivers/net/ethernet/atheros/atlx/atl1.c           |  78 ++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c      |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   2 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |   4 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  26 +-
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    |   2 +-
 drivers/net/ethernet/sun/niu.c                     |  31 ++-
 drivers/net/ethernet/sun/niu.h                     |   4 +
 drivers/net/phy/microchip.c                        |   2 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/wireless/ath/ath6kl/bmi.c              |   4 +-
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c       |   6 +-
 drivers/pinctrl/qcom/pinctrl-msm.c                 |  20 ++
 drivers/platform/mellanox/mlxbf-tmfifo.c           |   3 +-
 drivers/pwm/pwm-mediatek.c                         |  15 +-
 drivers/regulator/gpio-regulator.c                 |  19 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |   2 +
 drivers/scsi/ufs/ufs-sysfs.c                       |   4 +-
 drivers/spi/spi-fsl-dspi.c                         |  55 ++--
 drivers/staging/rtl8723bs/core/rtw_security.c      |  46 +---
 drivers/tty/serial/uartlite.c                      |  15 +-
 drivers/tty/vt/vt.c                                |   1 +
 drivers/usb/class/cdc-wdm.c                        |  23 +-
 drivers/usb/core/quirks.c                          |   3 +-
 drivers/usb/core/usb.c                             |  14 +-
 drivers/usb/gadget/function/f_tcm.c                |   4 +-
 drivers/usb/gadget/function/u_serial.c             |   6 +-
 drivers/usb/typec/altmodes/displayport.c           |   5 +-
 fs/btrfs/inode.c                                   |  36 +--
 fs/btrfs/ioctl.c                                   |   3 +
 fs/btrfs/tree-log.c                                |   4 +-
 fs/ceph/file.c                                     |   2 +-
 fs/cifs/misc.c                                     |   8 +
 fs/jfs/jfs_dmap.c                                  |  41 +--
 fs/namespace.c                                     |   8 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             | 144 +++++++---
 fs/nfs/inode.c                                     |  17 +-
 fs/overlayfs/util.c                                |   4 +-
 fs/proc/inode.c                                    |  16 +-
 fs/proc/proc_sysctl.c                              |  18 +-
 include/drm/spsc_queue.h                           |   4 +-
 include/linux/of.h                                 | 291 ++++++++++-----------
 include/linux/regulator/gpio-regulator.h           |   2 +
 include/linux/usb/typec_dp.h                       |   1 +
 include/rdma/ib_verbs.h                            |   7 +-
 include/uapi/linux/vm_sockets.h                    |   4 +
 init/Kconfig                                       |   4 +-
 lib/test_objagg.c                                  |   4 +-
 net/appletalk/ddp.c                                |   1 +
 net/atm/clip.c                                     |  64 +++--
 net/atm/resources.c                                |   3 +-
 net/bluetooth/l2cap_core.c                         |   9 +-
 net/bpfilter/Makefile                              |   5 +-
 net/ipv6/route.c                                   |   3 +-
 net/mac80211/rx.c                                  |   4 +
 net/mac80211/util.c                                |   2 +-
 net/netlink/af_netlink.c                           |  90 ++++---
 net/rose/rose_route.c                              |  15 +-
 net/rxrpc/call_accept.c                            |   3 +
 net/sched/sch_api.c                                |  42 +--
 net/tipc/topsrv.c                                  |   2 +
 net/vmw_vsock/vmci_transport.c                     |   4 +-
 scripts/Kbuild.include                             |   2 +-
 scripts/Makefile.host                              |   4 +-
 scripts/Makefile.lib                               |   8 +-
 sound/isa/sb/sb16_main.c                           |   4 +
 sound/pci/hda/hda_bind.c                           |   2 +-
 sound/soc/meson/meson-card-utils.c                 |   2 +-
 sound/usb/stream.c                                 |   2 +
 usr/include/Makefile                               |   6 +-
 132 files changed, 1183 insertions(+), 685 deletions(-)


