Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B5D1E7C01;
	Mon, 21 Oct 2024 10:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507532; cv=none; b=gc+5Hlu74h6/BO88yfVuVKkXgW8oJGmj/4PM8iIDJ+RF72ltiEgG2JTiLBM5We9zD3hjv4igGhCdoEJDWzsxFEt3b8QQ+sFWjyStuuna6+aEiaWfYaRqrhc4y7NEsc2P1iqanMSRcxTJpsCUQXxZa5vWzwiLB6Vdc04PkWUw2Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507532; c=relaxed/simple;
	bh=EoRz985Isd7Gx2BEp5sjKgq5DSaMQEkxgVsXm1jyGoo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CjI61RlKz2sxqDSufXb90vl1DrhF+gFNL9nldh9RKD8QY/jaQGHAO+sdJqvLdW8Diw9OFUpQ2HxS6BA2JnKE+Njit6ML795tkj9tlV8RgSl6DOCrW7UiwnRbISF7auQsdTyyV2ONSzkZDAZ+oqtUvvtBkQiNux4sfbyRhFG/XKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RtT5f2b6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RtT5f2b6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5627FC4CEC7;
	Mon, 21 Oct 2024 10:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507531;
	bh=EoRz985Isd7Gx2BEp5sjKgq5DSaMQEkxgVsXm1jyGoo=;
	h=From:To:Cc:Subject:Date:From;
	b=RtT5f2b6Nd7TEoN4AagquDF7jLDIrw/1LTJ5iFoWQu67I42mLkyqMiZ/NUIB573K8
	 oaJQ/YuHg4XI0dD60F7de0cqYAVp7g+PW8GXXamVQhXhTEKUkg7wtpjjlCxdeHTNiF
	 bS3wkKqjm3hg0/4+4ps962K810IJrHUXeYrY6xvs=
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
Subject: [PATCH 5.15 00/82] 5.15.169-rc1 review
Date: Mon, 21 Oct 2024 12:24:41 +0200
Message-ID: <20241021102247.209765070@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.169-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.169-rc1
X-KernelTest-Deadline: 2024-10-23T10:22+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.169 release.
There are 82 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.169-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.169-rc1

Vasiliy Kovalev <kovalev@altlinux.org>
    ALSA: hda/conexant - Use cached pin control for Node 0x1d on HP EliteOne 1000 G2

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/mm: Always update max/min_low_pfn in mem_topology_setup()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: propagate directory read errors from nilfs_find_entry()

Paolo Abeni <pabeni@redhat.com>
    mptcp: prevent MPC handshake on port-based signal endpoints

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: fix UaF read in mptcp_pm_nl_rm_addr_or_subflow

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: fallback when MPTCP opts are dropped after 1st data

Paolo Abeni <pabeni@redhat.com>
    tcp: fix mptcp DSS corruption due to large pmtu xmit

Paolo Abeni <pabeni@redhat.com>
    mptcp: handle consistently DSS corruption

Geliang Tang <geliang.tang@suse.com>
    mptcp: track and update contiguous data status

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v4: Don't allow a VMOVP on a dying VPE

Sergey Matsievskiy <matsievskiysv@gmail.com>
    pinctrl: ocelot: fix system hang on level based interrupts

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
    Bluetooth: Remove debugfs directory on module init failure

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: adc: ti-ads124s08: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: proximity: mb1232: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

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

Nikolay Kuratov <kniv@yandex-team.ru>
    drm/vmwgfx: Handle surface check failure correctly

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/radeon: Fix encoder->possible_clones

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

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    s390/sclp_vt220: Convert newlines to CRLF instead of LFCR

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix incorrect pci_for_each_dma_alias() for non-PCI devices

Felix Moessbauer <felix.moessbauer@siemens.com>
    io_uring/sqpoll: do not put cpumask on stack

Jens Axboe <axboe@kernel.dk>
    io_uring/sqpoll: retain test for whether the CPU is valid

Felix Moessbauer <felix.moessbauer@siemens.com>
    io_uring/sqpoll: do not allow pinning outside of cpuset

Wachowski, Karol <karol.wachowski@intel.com>
    drm/shmem-helper: Fix BUG_ON() on mmap(PROT_WRITE, MAP_PRIVATE)

Breno Leitao <leitao@debian.org>
    KVM: Fix a data race on last_boosted_vcpu in kvm_vcpu_on_spin()

Mikulas Patocka <mpatocka@redhat.com>
    dm-crypt, dm-verity: disable tasklets

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix potential key use-after-free

Patrick Roy <roypat@amazon.co.uk>
    secretmem: disable memfd_secret() if arch cannot set direct map

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
    udf: Fix bogus checksum computation in udf_rename()

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

Vasiliy Kovalev <kovalev@altlinux.org>
    ALSA: hda/conexant - Fix audio routing for HP EliteOne 1000 G2


-------------

Diffstat:

 Makefile                                           |    4 +-
 arch/arm64/kernel/probes/decode-insn.c             |   16 +-
 arch/arm64/kernel/probes/simulate-insn.c           |   18 +-
 arch/powerpc/mm/numa.c                             |    6 +-
 arch/s390/kvm/diag.c                               |    2 +-
 arch/x86/entry/entry.S                             |    5 +
 arch/x86/entry/entry_32.S                          |    6 +-
 arch/x86/include/asm/cpufeatures.h                 |    4 +-
 arch/x86/kernel/apic/apic.c                        |   14 +-
 arch/x86/kernel/cpu/bugs.c                         |   32 +
 arch/x86/kernel/cpu/common.c                       |    3 +
 arch/x86/kernel/cpu/resctrl/core.c                 |    4 +-
 block/blk-rq-qos.c                                 |    2 +-
 drivers/bluetooth/btusb.c                          |   13 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c             |    3 +
 drivers/gpu/drm/radeon/radeon_encoders.c           |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |    1 +
 drivers/iio/adc/Kconfig                            |    4 +
 .../iio/common/hid-sensors/hid-sensor-trigger.c    |    2 +-
 drivers/iio/dac/Kconfig                            |    3 +
 drivers/iio/light/opt3001.c                        |    4 +
 drivers/iio/light/veml6030.c                       |    5 +-
 drivers/iio/proximity/Kconfig                      |    2 +
 drivers/iommu/intel/iommu.c                        |    4 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   26 +-
 drivers/md/dm-crypt.c                              |   37 +-
 drivers/net/ethernet/cadence/macb_main.c           |   14 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |    2 +-
 drivers/parport/procfs.c                           |   22 +-
 drivers/pinctrl/pinctrl-ocelot.c                   |    8 +-
 drivers/s390/char/sclp_vt220.c                     |    4 +-
 drivers/usb/host/xhci-ring.c                       |    2 +-
 drivers/usb/host/xhci.h                            |    2 +-
 drivers/usb/serial/option.c                        |    8 +
 fs/fat/namei_vfat.c                                |    2 +-
 fs/nilfs2/dir.c                                    |   50 +-
 fs/nilfs2/namei.c                                  |   39 +-
 fs/nilfs2/nilfs.h                                  |    2 +-
 fs/udf/dir.c                                       |  148 +--
 fs/udf/directory.c                                 |  594 ++++++++---
 fs/udf/inode.c                                     |   90 --
 fs/udf/namei.c                                     | 1038 +++++++-------------
 fs/udf/udfdecl.h                                   |   45 +-
 include/linux/fsl/enetc_mdio.h                     |    3 +-
 include/linux/irqchip/arm-gic-v4.h                 |    4 +-
 io_uring/io_uring.c                                |   21 +-
 kernel/time/posix-clock.c                          |    3 +
 mm/secretmem.c                                     |    4 +-
 mm/swapfile.c                                      |    2 +-
 net/bluetooth/af_bluetooth.c                       |    1 +
 net/ipv4/tcp_output.c                              |    2 +-
 net/mac80211/cfg.c                                 |    3 +
 net/mac80211/key.c                                 |    2 +-
 net/mptcp/mib.c                                    |    3 +
 net/mptcp/mib.h                                    |    3 +
 net/mptcp/pm_netlink.c                             |    3 +-
 net/mptcp/protocol.c                               |   23 +-
 net/mptcp/protocol.h                               |    2 +
 net/mptcp/subflow.c                                |   19 +-
 sound/pci/hda/patch_conexant.c                     |   19 +
 virt/kvm/kvm_main.c                                |    5 +-
 61 files changed, 1172 insertions(+), 1242 deletions(-)


