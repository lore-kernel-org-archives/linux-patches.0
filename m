Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C1B1E7C06;
	Mon, 21 Oct 2024 10:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506914; cv=none; b=lu9lhg65ylurElFV2NomKGFxg906qQjqFCGKteQvPoMLoRDN2uV81xAOWuIetwXrKfm3hTu7VmeqHB62HUZlFv1zw22n2SKxUTEMYtFqwnH5iPWChuHpFANSeZdNPq+wr4wnvx4Wrs7HsJkiwqgJOM8kf6KfuWtQdzA3x/6qCxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506914; c=relaxed/simple;
	bh=rPst642MVDt/gNpYX0XvoLgYsCPh/IZqswzmR//nPrs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eUPKkc62ZKR+xKv6v8/XU9QzYTbpQGXTKOdJ3dtKQTGRzv/x9w0yqzv8V2rcySW3wS0G/ACIMbwRQfiRmTpkJnyYFiPlqObTN7KuXmoxBhJsIfGjjngl3a4CYvbj/pa+RpBQVqB1OKCIXYrMk8/Pa4CxzADQbp6eqUub8LhnbRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACxLBgqB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACxLBgqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98671C4CEC7;
	Mon, 21 Oct 2024 10:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506914;
	bh=rPst642MVDt/gNpYX0XvoLgYsCPh/IZqswzmR//nPrs=;
	h=From:To:Cc:Subject:Date:From;
	b=ACxLBgqBXzaX6JJH/lueDbrEyEW3XXRRexh0UHqLcGRAvorfLZKyMh/ec1wuTuEw9
	 A3vmc3n6esVegf3oEQYgB8poI77wWmUOCUJGZMmHrT/x41phhAfq+oe7+3/F7hOLm4
	 F0pqtNGfTVJNGbl73F6QmxOmqRXMpAWsmiissKJU=
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
	allen.lkml@gmail.com,
	broonie@kernel.org
Subject: [PATCH 6.6 000/124] 6.6.58-rc1 review
Date: Mon, 21 Oct 2024 12:23:24 +0200
Message-ID: <20241021102256.706334758@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.58-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.58-rc1
X-KernelTest-Deadline: 2024-10-23T10:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.58 release.
There are 124 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.58-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.58-rc1

Vasiliy Kovalev <kovalev@altlinux.org>
    ALSA: hda/conexant - Use cached pin control for Node 0x1d on HP EliteOne 1000 G2

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: propagate directory read errors from nilfs_find_entry()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: remove duplicated variables

Paolo Abeni <pabeni@redhat.com>
    selftests: mptcp: join: test for prohibited MPC to port-based endp

Geliang Tang <tanggeliang@kylinos.cn>
    selftests: mptcp: join: change capture/checksum as bool

Paolo Abeni <pabeni@redhat.com>
    tcp: fix mptcp DSS corruption due to large pmtu xmit

Johan Hovold <johan+linaro@kernel.org>
    serial: qcom-geni: fix receiver enable

Johan Hovold <johan+linaro@kernel.org>
    serial: qcom-geni: fix dma rx cancellation

Johan Hovold <johan+linaro@kernel.org>
    serial: qcom-geni: revert broken hibernation support

Johan Hovold <johan+linaro@kernel.org>
    serial: qcom-geni: fix polled console initialisation

Nam Cao <namcao@linutronix.de>
    irqchip/sifive-plic: Unmask interrupt in plic_irq_enable()

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v4: Don't allow a VMOVP on a dying VPE

Ma Ke <make24@iscas.ac.cn>
    pinctrl: apple: check devm_kasprintf() returned value

Ma Ke <make24@iscas.ac.cn>
    pinctrl: stm32: check devm_kasprintf() returned value

Sergey Matsievskiy <matsievskiysv@gmail.com>
    pinctrl: ocelot: fix system hang on level based interrupts

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Use code segment selector for VERW operand

Longlong Xia <xialonglong@kylinos.cn>
    tty: n_gsm: Fix use-after-free in gsm_cleanup_mux

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/entry_32: Clear CPU buffers after register restore in NMI return

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/entry_32: Do not clobber user EFLAGS.ZF

John Allen <john.allen@amd.com>
    x86/CPU/AMD: Only apply Zenbleed fix for Zen2 during late microcode load

Zhang Rui <rui.zhang@intel.com>
    x86/apic: Always explicitly disarm TSC-deadline timer

Nathan Chancellor <nathan@kernel.org>
    x86/resctrl: Annotate get_mem_config() functions as __init

Takashi Iwai <tiwai@suse.de>
    parport: Proper fix for array out-of-bounds access

Marek Vasut <marex@denx.de>
    serial: imx: Update mctrl old_status on RTSD interrupt

Heiko Thiery <heiko.thiery@gmail.com>
    misc: microchip: pci1xxxx: add support for NVMEM_DEVID_AUTO for OTP device

Heiko Thiery <heiko.thiery@gmail.com>
    misc: microchip: pci1xxxx: add support for NVMEM_DEVID_AUTO for EEPROM device

Prashanth K <quic_prashk@quicinc.com>
    usb: dwc3: Wait for EndXfer completion before restoring GUSB2PHYCFG

Jonathan Marek <jonathan@marek.ca>
    usb: typec: qcom-pmic-typec: fix sink status being overwritten with RP_DEF

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit FN920C04 MBIM compositions

Benjamin B. Frost <benjamin@geanix.com>
    USB: serial: option: add support for Quectel EG916Q-GL

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Mitigate failed set dequeue pointer commands

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix incorrect stream context type macro

Henry Lin <henryl@nvidia.com>
    xhci: tegra: fix checked USB2 port number

Jeongjun Park <aha310510@gmail.com>
    vt: prevent kernel-infoleak in con_font_get()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: btusb: Fix regression with fake CSR controllers 0a12:0001

Aaron Thompson <dev@aaront.org>
    Bluetooth: ISO: Fix multiple init when debugfs is disabled

Aaron Thompson <dev@aaront.org>
    Bluetooth: Remove debugfs directory on module init failure

Aaron Thompson <dev@aaront.org>
    Bluetooth: Call iso_exit() on module unload

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: accel: kx022a: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: adc: ti-ads124s08: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: adc: ti-lmp92064: add missing select REGMAP_SPI in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: dac: ad3552r: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: proximity: mb1232: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: dac: ad5766: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: light: bu27008: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: frequency: adf4377: add missing select REMAP_SPI in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: amplifiers: ada4250: add missing select REGMAP_SPI in Kconfig

Emil Gedenryd <emil.gedenryd@axis.com>
    iio: light: opt3001: add missing full-scale range value

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: light: veml6030: fix IIO device retrieval from embedded device

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: light: veml6030: fix ALS sensor resolution

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio: hid-sensors: Fix an error handling path in _hid_sensor_set_report_latency()

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: adc: ti-ads8688: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: dac: stm32-dac-core: add missing select REGMAP_MMIO in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: dac: ltc1660: add missing select REGMAP_SPI in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: dac: ad5770r: add missing select REGMAP_SPI in Kconfig

Mohammed Anees <pvmohammedanees2003@gmail.com>
    drm/amdgpu: prevent BO_HANDLES error from being overwritten

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/swsmu: Only force workload setup on init

Nikolay Kuratov <kniv@yandex-team.ru>
    drm/vmwgfx: Handle surface check failure correctly

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/radeon: Fix encoder->possible_clones

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Fix the issue of ICU failure

Seunghwan Baek <sh8267.baek@samsung.com>
    scsi: ufs: core: Set SDEV_OFFLINE when UFS is shut down

John Edwards <uejji@uejji.net>
    Input: xpad - add support for MSI Claw A1M

Yun Lu <luyun@kylinos.cn>
    selftest: hid: add the missing tests directory

Ming Lei <ming.lei@redhat.com>
    ublk: don't allow user copy for unprivileged device

Jens Axboe <axboe@kernel.dk>
    io_uring/sqpoll: close race on waiting for sqring entries

Omar Sandoval <osandov@fb.com>
    blk-rq-qos: fix crash on rq_qos_wait vs. rq_qos_wake_function race

Johannes Wikner <kwikner@ethz.ch>
    x86/bugs: Do not use UNTRAIN_RET with IBPB on entry

Johannes Wikner <kwikner@ethz.ch>
    x86/bugs: Skip RSB fill at VMEXIT

Johannes Wikner <kwikner@ethz.ch>
    x86/entry: Have entry_ibpb() invalidate return predictions

Johannes Wikner <kwikner@ethz.ch>
    x86/cpufeatures: Add a IBPB_NO_RET BUG flag

Jim Mattson <jmattson@google.com>
    x86/cpufeatures: Define X86_FEATURE_AMD_IBPB_RET

Michael Mueller <mimu@linux.ibm.com>
    KVM: s390: Change virtual to physical address access in diag 0x258 handler

Nico Boehr <nrb@linux.ibm.com>
    KVM: s390: gaccess: Check if guest address is in memslot

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    s390/sclp_vt220: Convert newlines to CRLF instead of LFCR

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    s390/sclp: Deactivate sclp after all its users

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix incorrect pci_for_each_dma_alias() for non-PCI devices

Paolo Abeni <pabeni@redhat.com>
    mptcp: prevent MPC handshake on port-based signal endpoints

Csókás, Bence <csokas.bence@prolan.hu>
    net: fec: Remove duplicated code

Csókás, Bence <csokas.bence@prolan.hu>
    net: fec: Move `fec_ptp_read()` to the top of the file

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    maple_tree: correct tree corruption on spanning store

Darrick J. Wong <djwong@kernel.org>
    xfs: restrict when we try to align cow fork delalloc to cowextsz hints

Darrick J. Wong <djwong@kernel.org>
    xfs: allow unlinked symlinks and dirs with zero size

Christoph Hellwig <hch@lst.de>
    xfs: fix freeing speculative preallocations for preallocated files

Dave Chinner <dchinner@redhat.com>
    xfs: fix unlink vs cluster buffer instantiation race

Wengang Wang <wen.gang.wang@oracle.com>
    xfs: make sure sb_fdblocks is non-negative

Darrick J. Wong <djwong@kernel.org>
    xfs: allow symlinks with short remote targets

Zhang Yi <yi.zhang@huawei.com>
    xfs: convert delayed extents to unwritten when zeroing post eof blocks

Zhang Yi <yi.zhang@huawei.com>
    xfs: make xfs_bmapi_convert_delalloc() to allocate the target offset

Zhang Yi <yi.zhang@huawei.com>
    xfs: make the seq argument to xfs_bmapi_convert_delalloc() optional

Zhang Yi <yi.zhang@huawei.com>
    xfs: match lock mode in xfs_buffered_write_iomap_begin()

Darrick J. Wong <djwong@kernel.org>
    xfs: use dontcache for grabbing inodes during scrub

Darrick J. Wong <djwong@kernel.org>
    xfs: revert commit 44af6c7e59b12

Darrick J. Wong <djwong@kernel.org>
    xfs: enforce one namespace per attribute

Darrick J. Wong <djwong@kernel.org>
    xfs: validate recovered name buffers when recovering xattr items

Darrick J. Wong <djwong@kernel.org>
    xfs: check shortform attr entry flags specifically

Darrick J. Wong <djwong@kernel.org>
    xfs: fix missing check for invalid attr flags

Darrick J. Wong <djwong@kernel.org>
    xfs: check opcode and iovec count match in xlog_recover_attri_commit_pass2

Darrick J. Wong <djwong@kernel.org>
    xfs: require XFS_SB_FEAT_INCOMPAT_LOG_XATTRS for attr log intent item recovery

Christoph Hellwig <hch@lst.de>
    xfs: remove a racy if_bytes check in xfs_reflink_end_cow_extent

Christoph Hellwig <hch@lst.de>
    xfs: fix xfs_bmap_add_extent_delay_real for partial conversions

Christoph Hellwig <hch@lst.de>
    xfs: fix error returns from xfs_bmapi_write

Liu Shixin <liushixin2@huawei.com>
    mm/swapfile: skip HugeTLB pages for unuse_vma

Wei Xu <weixugc@google.com>
    mm/mglru: only clear kswapd_failures if reclaimable

Jann Horn <jannh@google.com>
    mm/mremap: fix move_normal_pmd/retract_page_tables race

Edward Liaw <edliaw@google.com>
    selftests/mm: fix deadlock for fork after pthread_create on ARM

Edward Liaw <edliaw@google.com>
    selftests/mm: replace atomic_bool with pthread_barrier_t

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    fat: fix uninitialized variable

Nianyao Tang <tangnianyao@huawei.com>
    irqchip/gic-v3-its: Fix VSYNC referencing an unmapped VPE on GIC v4.1

Jinjie Ruan <ruanjinjie@huawei.com>
    net: microchip: vcap api: Fix memory leaks in vcap_api_encode_rule_test()

Oleksij Rempel <o.rempel@pengutronix.de>
    net: macb: Avoid 20s boot delay by skipping MDIO bus registration for fixed-link PHY

Mark Rutland <mark.rutland@arm.com>
    arm64: probes: Fix uprobes for big-endian kernels

Mark Rutland <mark.rutland@arm.com>
    arm64: probes: Fix simulate_ldr*_literal()

Mark Rutland <mark.rutland@arm.com>
    arm64: probes: Remove broken LDR (literal) uprobe support

Jinjie Ruan <ruanjinjie@huawei.com>
    posix-clock: Fix missing timespec64 check in pc_clock_settime()

Wei Fang <wei.fang@nxp.com>
    net: enetc: add missing static descriptor and inline keyword

Wei Fang <wei.fang@nxp.com>
    net: enetc: disable NAPI after all rings are disabled

Wei Fang <wei.fang@nxp.com>
    net: enetc: disable Tx BD rings after they are empty

Wei Fang <wei.fang@nxp.com>
    net: enetc: block concurrent XDP transmissions during ring reconfiguration

Wei Fang <wei.fang@nxp.com>
    net: enetc: remove xdp_drops statistic from enetc_xdp_drop()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: fix UaF read in mptcp_pm_nl_rm_addr_or_subflow

Vasiliy Kovalev <kovalev@altlinux.org>
    ALSA: hda/conexant - Fix audio routing for HP EliteOne 1000 G2

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix user-after-free from session log off

Roi Martin <jroi.martin@gmail.com>
    btrfs: fix uninitialized pointer free on read_alloc_one_name() error

Roi Martin <jroi.martin@gmail.com>
    btrfs: fix uninitialized pointer free in add_inode_ref()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/include/asm/uprobes.h                   |   8 +-
 arch/arm64/kernel/probes/decode-insn.c             |  16 ++-
 arch/arm64/kernel/probes/simulate-insn.c           |  18 ++-
 arch/arm64/kernel/probes/uprobes.c                 |   4 +-
 arch/s390/kvm/diag.c                               |   2 +-
 arch/s390/kvm/gaccess.c                            |   4 +
 arch/s390/kvm/gaccess.h                            |  14 ++-
 arch/x86/entry/entry.S                             |   5 +
 arch/x86/entry/entry_32.S                          |   6 +-
 arch/x86/include/asm/cpufeatures.h                 |   4 +-
 arch/x86/include/asm/nospec-branch.h               |  11 +-
 arch/x86/kernel/apic/apic.c                        |  14 ++-
 arch/x86/kernel/cpu/amd.c                          |   3 +-
 arch/x86/kernel/cpu/bugs.c                         |  32 +++++
 arch/x86/kernel/cpu/common.c                       |   3 +
 arch/x86/kernel/cpu/resctrl/core.c                 |   4 +-
 block/blk-rq-qos.c                                 |   2 +-
 drivers/block/ublk_drv.c                           |  11 +-
 drivers/bluetooth/btusb.c                          |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   6 +-
 drivers/gpu/drm/radeon/radeon_encoders.c           |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   1 +
 drivers/iio/accel/Kconfig                          |   2 +
 drivers/iio/adc/Kconfig                            |   5 +
 drivers/iio/amplifiers/Kconfig                     |   1 +
 .../iio/common/hid-sensors/hid-sensor-trigger.c    |   2 +-
 drivers/iio/dac/Kconfig                            |   7 ++
 drivers/iio/frequency/Kconfig                      |   1 +
 drivers/iio/light/Kconfig                          |   2 +
 drivers/iio/light/opt3001.c                        |   4 +
 drivers/iio/light/veml6030.c                       |   5 +-
 drivers/iio/proximity/Kconfig                      |   2 +
 drivers/input/joystick/xpad.c                      |   2 +
 drivers/iommu/intel/iommu.c                        |   4 +-
 drivers/irqchip/irq-gic-v3-its.c                   |  26 ++--
 drivers/irqchip/irq-sifive-plic.c                  |  21 ++--
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_otpe2p.c  |   2 +
 drivers/net/ethernet/cadence/macb_main.c           |  14 ++-
 drivers/net/ethernet/freescale/enetc/enetc.c       |  56 +++++++--
 drivers/net/ethernet/freescale/enetc/enetc.h       |   1 +
 drivers/net/ethernet/freescale/fec_ptp.c           |  58 ++++-----
 .../net/ethernet/microchip/vcap/vcap_api_kunit.c   |   2 +
 drivers/parport/procfs.c                           |  22 ++--
 drivers/pinctrl/pinctrl-apple-gpio.c               |   3 +
 drivers/pinctrl/pinctrl-ocelot.c                   |   8 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |   9 +-
 drivers/s390/char/sclp.c                           |   3 +-
 drivers/s390/char/sclp_vt220.c                     |   4 +-
 drivers/tty/n_gsm.c                                |   2 +
 drivers/tty/serial/imx.c                           |  15 +++
 drivers/tty/serial/qcom_geni_serial.c              |  90 +++++++-------
 drivers/tty/vt/vt.c                                |   2 +-
 drivers/ufs/core/ufs-mcq.c                         |  15 +--
 drivers/ufs/core/ufshcd.c                          |   4 +-
 drivers/usb/dwc3/gadget.c                          |  10 +-
 drivers/usb/host/xhci-ring.c                       |   2 +-
 drivers/usb/host/xhci-tegra.c                      |   2 +-
 drivers/usb/host/xhci.h                            |   2 +-
 drivers/usb/serial/option.c                        |   8 ++
 drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_port.c |   1 -
 fs/btrfs/tree-log.c                                |   6 +-
 fs/fat/namei_vfat.c                                |   2 +-
 fs/nilfs2/dir.c                                    |  50 ++++----
 fs/nilfs2/namei.c                                  |  39 ++++--
 fs/nilfs2/nilfs.h                                  |   2 +-
 fs/smb/server/mgmt/user_session.c                  |  26 +++-
 fs/smb/server/mgmt/user_session.h                  |   4 +
 fs/smb/server/server.c                             |   2 +
 fs/smb/server/smb2pdu.c                            |   8 +-
 fs/xfs/libxfs/xfs_attr.c                           |  11 ++
 fs/xfs/libxfs/xfs_attr.h                           |   4 +-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |   6 +-
 fs/xfs/libxfs/xfs_attr_remote.c                    |   1 -
 fs/xfs/libxfs/xfs_bmap.c                           | 130 ++++++++++++++++----
 fs/xfs/libxfs/xfs_da_btree.c                       |  20 +--
 fs/xfs/libxfs/xfs_da_format.h                      |   5 +
 fs/xfs/libxfs/xfs_inode_buf.c                      |  49 ++++++--
 fs/xfs/libxfs/xfs_sb.c                             |   7 +-
 fs/xfs/scrub/attr.c                                |  47 ++++---
 fs/xfs/scrub/common.c                              |  12 +-
 fs/xfs/scrub/scrub.h                               |   7 ++
 fs/xfs/xfs_aops.c                                  |  54 +++------
 fs/xfs/xfs_attr_item.c                             |  98 ++++++++++++---
 fs/xfs/xfs_attr_list.c                             |  11 +-
 fs/xfs/xfs_bmap_util.c                             |  65 ++++++----
 fs/xfs/xfs_bmap_util.h                             |   2 +-
 fs/xfs/xfs_dquot.c                                 |   1 -
 fs/xfs/xfs_icache.c                                |   2 +-
 fs/xfs/xfs_inode.c                                 |  37 +++---
 fs/xfs/xfs_iomap.c                                 |  81 +++++++------
 fs/xfs/xfs_reflink.c                               |  20 ---
 fs/xfs/xfs_rtalloc.c                               |   2 -
 include/linux/fsl/enetc_mdio.h                     |   3 +-
 include/linux/irqchip/arm-gic-v4.h                 |   4 +-
 include/uapi/linux/ublk_cmd.h                      |   8 +-
 io_uring/io_uring.h                                |   9 +-
 kernel/time/posix-clock.c                          |   3 +
 lib/maple_tree.c                                   |  12 +-
 mm/mremap.c                                        |  11 +-
 mm/swapfile.c                                      |   2 +-
 mm/vmscan.c                                        |   4 +-
 net/bluetooth/af_bluetooth.c                       |   3 +
 net/bluetooth/iso.c                                |   6 +-
 net/ipv4/tcp_output.c                              |   4 +-
 net/mptcp/mib.c                                    |   1 +
 net/mptcp/mib.h                                    |   1 +
 net/mptcp/pm_netlink.c                             |   3 +-
 net/mptcp/protocol.h                               |   1 +
 net/mptcp/subflow.c                                |  11 ++
 sound/pci/hda/patch_conexant.c                     |  19 +++
 tools/testing/selftests/hid/Makefile               |   1 +
 tools/testing/selftests/mm/uffd-common.c           |   5 +-
 tools/testing/selftests/mm/uffd-common.h           |   3 +-
 tools/testing/selftests/mm/uffd-unit-tests.c       |  21 +++-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    | 135 +++++++++++++++------
 tools/testing/selftests/net/mptcp/mptcp_lib.sh     |  11 --
 118 files changed, 1126 insertions(+), 574 deletions(-)


