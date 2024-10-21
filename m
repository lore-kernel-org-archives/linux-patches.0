Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D551E3DDB;
	Mon, 21 Oct 2024 10:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507292; cv=none; b=jd8aIne6bEiUwsC60DqVtSz9ZLLDDDst8FFRhv80+N6XbLvAsTSEajxfDbf2Uoyl87+z1jKjVe0txtQl7cfYj2RfhuTZt/j/Mktz93N5Mu0w0xNWo9xADOUOuoNoqks+//OAm11PdzWs3cqzHux/h79epAflGP1ytwYnpdcpEFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507292; c=relaxed/simple;
	bh=zOMLSPc3pd5T5Sfdfz7likWS6q2kd1GbeE8B6oyaTE8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AeFaBuLxFc88fNJZlfP1nWdRJvEuZo+QxNDlJMJO+XXTsnlmsvIJMWmI4g3RASBIa/kbO7XOGoYJagHnhWsEt0JJ8W3HRn/77lb5mZ3H8NJG7mP54+c/mMINAp2u8HihGiWKtEGEK7wijeM1rCF8Kk+ZqT/RZrLkkDAIenPXCz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11dq29E6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11dq29E6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F507C4CEC3;
	Mon, 21 Oct 2024 10:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507291;
	bh=zOMLSPc3pd5T5Sfdfz7likWS6q2kd1GbeE8B6oyaTE8=;
	h=From:To:Cc:Subject:Date:From;
	b=11dq29E6kV8fUiql1AjJdHk6Hwo/Xd40cCm/8DUs24BnTbKddcQm648DPI+EBBJpx
	 //+4VGAsJ9+FS/72Kz0KIVq7LmY4zEtbSouxfGuTVHQYVHB4mtkKgkthzQe2VQ1lUJ
	 wwHJ1ym1b2nQ61ltj9qRsdjaqkZkh9PNuI2WzRMY=
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
Subject: [PATCH 6.1 00/91] 6.1.114-rc1 review
Date: Mon, 21 Oct 2024 12:24:14 +0200
Message-ID: <20241021102249.791942892@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.114-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.114-rc1
X-KernelTest-Deadline: 2024-10-23T10:22+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.114 release.
There are 91 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.114-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.114-rc1

Vasiliy Kovalev <kovalev@altlinux.org>
    ALSA: hda/conexant - Use cached pin control for Node 0x1d on HP EliteOne 1000 G2

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64: Add big-endian ELFv2 flavour to crypto VMX asm generation

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: propagate directory read errors from nilfs_find_entry()

Paolo Abeni <pabeni@redhat.com>
    mptcp: prevent MPC handshake on port-based signal endpoints

Paolo Abeni <pabeni@redhat.com>
    tcp: fix mptcp DSS corruption due to large pmtu xmit

Nam Cao <namcao@linutronix.de>
    irqchip/sifive-plic: Unmask interrupt in plic_irq_enable()

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v4: Don't allow a VMOVP on a dying VPE

Ma Ke <make24@iscas.ac.cn>
    pinctrl: apple: check devm_kasprintf() returned value

Sergey Matsievskiy <matsievskiysv@gmail.com>
    pinctrl: ocelot: fix system hang on level based interrupts

Longlong Xia <xialonglong@kylinos.cn>
    tty: n_gsm: Fix use-after-free in gsm_cleanup_mux

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/entry_32: Clear CPU buffers after register restore in NMI return

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/entry_32: Do not clobber user EFLAGS.ZF

Zhang Rui <rui.zhang@intel.com>
    x86/apic: Always explicitly disarm TSC-deadline timer

Nathan Chancellor <nathan@kernel.org>
    x86/resctrl: Annotate get_mem_config() functions as __init

Takashi Iwai <tiwai@suse.de>
    parport: Proper fix for array out-of-bounds access

Prashanth K <quic_prashk@quicinc.com>
    usb: dwc3: Wait for EndXfer completion before restoring GUSB2PHYCFG

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit FN920C04 MBIM compositions

Benjamin B. Frost <benjamin@geanix.com>
    USB: serial: option: add support for Quectel EG916Q-GL

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Mitigate failed set dequeue pointer commands

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix incorrect stream context type macro

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: btusb: Fix regression with fake CSR controllers 0a12:0001

Aaron Thompson <dev@aaront.org>
    Bluetooth: ISO: Fix multiple init when debugfs is disabled

Aaron Thompson <dev@aaront.org>
    Bluetooth: Remove debugfs directory on module init failure

Aaron Thompson <dev@aaront.org>
    Bluetooth: Call iso_exit() on module unload

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: adc: ti-ads124s08: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: dac: ad3552r: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: proximity: mb1232: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: dac: ad5766: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

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

Seunghwan Baek <sh8267.baek@samsung.com>
    scsi: ufs: core: Set SDEV_OFFLINE when UFS is shut down

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

Wachowski, Karol <karol.wachowski@intel.com>
    drm/shmem-helper: Fix BUG_ON() on mmap(PROT_WRITE, MAP_PRIVATE)

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    maple_tree: correct tree corruption on spanning store

Jakub Kicinski <kuba@kernel.org>
    devlink: bump the instance index directly when iterating

Jakub Kicinski <kuba@kernel.org>
    devlink: drop the filter argument from devlinks_xa_find_get

Liu Shixin <liushixin2@huawei.com>
    mm/swapfile: skip HugeTLB pages for unuse_vma

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    fat: fix uninitialized variable

Nianyao Tang <tangnianyao@huawei.com>
    irqchip/gic-v3-its: Fix VSYNC referencing an unmapped VPE on GIC v4.1

Oleksij Rempel <linux@rempel-privat.de>
    net: macb: Avoid 20s boot delay by skipping MDIO bus registration for fixed-link PHY

Mark Rutland <mark.rutland@arm.com>
    arm64: probes: Fix simulate_ldr*_literal()

Mark Rutland <mark.rutland@arm.com>
    arm64: probes: Remove broken LDR (literal) uprobe support

Jinjie Ruan <ruanjinjie@huawei.com>
    posix-clock: Fix missing timespec64 check in pc_clock_settime()

Wei Fang <wei.fang@nxp.com>
    net: enetc: add missing static descriptor and inline keyword

Wei Fang <wei.fang@nxp.com>
    net: enetc: remove xdp_drops statistic from enetc_xdp_drop()

Jan Kara <jack@suse.cz>
    udf: Don't return bh from udf_expand_dir_adinicb()

Jan Kara <jack@suse.cz>
    udf: Handle error when expanding directory

Jan Kara <jack@suse.cz>
    udf: Remove old directory iteration code

Jan Kara <jack@suse.cz>
    udf: Convert udf_link() to new directory iteration code

Jan Kara <jack@suse.cz>
    udf: Convert udf_mkdir() to new directory iteration code

Jan Kara <jack@suse.cz>
    udf: Convert udf_add_nondir() to new directory iteration

Jan Kara <jack@suse.cz>
    udf: Implement adding of dir entries using new iteration code

Jan Kara <jack@suse.cz>
    udf: Convert udf_unlink() to new directory iteration code

Jan Kara <jack@suse.cz>
    udf: Convert udf_rmdir() to new directory iteration code

Jan Kara <jack@suse.cz>
    udf: Convert empty_dir() to new directory iteration code

Jan Kara <jack@suse.cz>
    udf: Convert udf_get_parent() to new directory iteration code

Jan Kara <jack@suse.cz>
    udf: Convert udf_lookup() to use new directory iteration code

Jan Kara <jack@suse.cz>
    udf: Convert udf_readdir() to new directory iteration

Jan Kara <jack@suse.cz>
    udf: Convert udf_rename() to new directory iteration code

Jan Kara <jack@suse.cz>
    udf: Provide function to mark entry as deleted using new directory iteration code

Jan Kara <jack@suse.cz>
    udf: Implement searching for directory entry using new iteration code

Jan Kara <jack@suse.cz>
    udf: Move udf_expand_dir_adinicb() to its callsite

Jan Kara <jack@suse.cz>
    udf: Convert udf_expand_dir_adinicb() to new directory iteration

Jan Kara <jack@suse.cz>
    udf: New directory iteration code

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

 Makefile                                           |    4 +-
 arch/arm64/kernel/probes/decode-insn.c             |   16 +-
 arch/arm64/kernel/probes/simulate-insn.c           |   18 +-
 arch/s390/kvm/diag.c                               |    2 +-
 arch/s390/kvm/gaccess.c                            |    4 +
 arch/s390/kvm/gaccess.h                            |   14 +-
 arch/x86/entry/entry.S                             |    5 +
 arch/x86/entry/entry_32.S                          |    6 +-
 arch/x86/include/asm/cpufeatures.h                 |    4 +-
 arch/x86/kernel/apic/apic.c                        |   14 +-
 arch/x86/kernel/cpu/bugs.c                         |   32 +
 arch/x86/kernel/cpu/common.c                       |    3 +
 arch/x86/kernel/cpu/resctrl/core.c                 |    4 +-
 block/blk-rq-qos.c                                 |    2 +-
 drivers/bluetooth/btusb.c                          |   13 +-
 drivers/crypto/vmx/Makefile                        |   12 +-
 drivers/crypto/vmx/ppc-xlate.pl                    |   10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |    2 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |    6 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c             |    3 +
 drivers/gpu/drm/radeon/radeon_encoders.c           |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |    1 +
 drivers/iio/adc/Kconfig                            |    4 +
 drivers/iio/amplifiers/Kconfig                     |    1 +
 .../iio/common/hid-sensors/hid-sensor-trigger.c    |    2 +-
 drivers/iio/dac/Kconfig                            |    7 +
 drivers/iio/light/opt3001.c                        |    4 +
 drivers/iio/light/veml6030.c                       |    5 +-
 drivers/iio/proximity/Kconfig                      |    2 +
 drivers/iommu/intel/iommu.c                        |    4 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   26 +-
 drivers/irqchip/irq-sifive-plic.c                  |   21 +-
 drivers/net/ethernet/cadence/macb_main.c           |   14 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |    2 +-
 drivers/parport/procfs.c                           |   22 +-
 drivers/pinctrl/pinctrl-apple-gpio.c               |    3 +
 drivers/pinctrl/pinctrl-ocelot.c                   |    8 +-
 drivers/s390/char/sclp.c                           |    3 +-
 drivers/s390/char/sclp_vt220.c                     |    4 +-
 drivers/tty/n_gsm.c                                |    2 +
 drivers/ufs/core/ufshcd.c                          |    4 +-
 drivers/usb/dwc3/gadget.c                          |   10 +-
 drivers/usb/host/xhci-ring.c                       |    2 +-
 drivers/usb/host/xhci.h                            |    2 +-
 drivers/usb/serial/option.c                        |    8 +
 fs/btrfs/tree-log.c                                |    6 +-
 fs/fat/namei_vfat.c                                |    2 +-
 fs/nilfs2/dir.c                                    |   50 +-
 fs/nilfs2/namei.c                                  |   39 +-
 fs/nilfs2/nilfs.h                                  |    2 +-
 fs/smb/server/mgmt/user_session.c                  |   26 +-
 fs/smb/server/mgmt/user_session.h                  |    4 +
 fs/smb/server/server.c                             |    2 +
 fs/smb/server/smb2pdu.c                            |    8 +-
 fs/udf/dir.c                                       |  148 +--
 fs/udf/directory.c                                 |  594 ++++++++---
 fs/udf/inode.c                                     |   90 --
 fs/udf/namei.c                                     | 1037 +++++++-------------
 fs/udf/udfdecl.h                                   |   45 +-
 include/linux/fsl/enetc_mdio.h                     |    3 +-
 include/linux/irqchip/arm-gic-v4.h                 |    4 +-
 io_uring/io_uring.h                                |    9 +-
 kernel/time/posix-clock.c                          |    3 +
 lib/maple_tree.c                                   |   12 +-
 mm/swapfile.c                                      |    2 +-
 net/bluetooth/af_bluetooth.c                       |    3 +
 net/bluetooth/iso.c                                |    6 +-
 net/devlink/leftover.c                             |   40 +-
 net/ipv4/tcp_output.c                              |    4 +-
 net/mptcp/mib.c                                    |    1 +
 net/mptcp/mib.h                                    |    1 +
 net/mptcp/pm_netlink.c                             |    3 +-
 net/mptcp/protocol.h                               |    1 +
 net/mptcp/subflow.c                                |   11 +
 sound/pci/hda/patch_conexant.c                     |   19 +
 75 files changed, 1237 insertions(+), 1275 deletions(-)


