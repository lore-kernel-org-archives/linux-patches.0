Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F361E0087;
	Mon, 21 Oct 2024 10:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506449; cv=none; b=Pie14Y/uvOSfNYXF8rA5xaLh1UiMPJAqgLBf39sJ9p1eMW+rQEATQ4gTg+bn6oDdDtyrRel5GNWoTb8jaK75U8/6x/If2b3nIo9IUQqDT5hXmXdaxoPE9sth2IC545q7u6vsVWpFV3wByeKj9mT/KOaoXt3JjkG4Igha73YhjEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506449; c=relaxed/simple;
	bh=i9YhUjq7xZxBbKbufL/2Zaq21bYhSFijr2FX5YyBKig=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iYNELLSW9Ia8zMMKEsPJeOtQbPXaYMbAhESq8kd7fzMOMJpMn1DMz6pfxuT/woeeEUeBfAnLWy4LteIPc4KL4tBRgyDfao7EUVFVzCczWiUvifZfoGgPG7qFxWpmyg+XRn0mF4wYMw/G5T4YKrW70oWUY12xY5qWRIaF9LNSUI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCt2M1F0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCt2M1F0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25822C4CEC3;
	Mon, 21 Oct 2024 10:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506448;
	bh=i9YhUjq7xZxBbKbufL/2Zaq21bYhSFijr2FX5YyBKig=;
	h=From:To:Cc:Subject:Date:From;
	b=pCt2M1F05824N07Mx2IPI5z/db/KqfukBdjDSl0Q1PyX4Kqgbfg29cr678U10w+er
	 HZVpPg1I4xr0LVjX+bDscLrne5Oc1k11UoOStRa6J1AYcr9Wf06ozVSPEjk0MX9YtC
	 bi599mmj0D3Es8wV84G/GmVcagwbZ/LX3C+SqES4=
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
Subject: [PATCH 6.11 000/135] 6.11.5-rc1 review
Date: Mon, 21 Oct 2024 12:22:36 +0200
Message-ID: <20241021102259.324175287@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.5-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.11.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.11.5-rc1
X-KernelTest-Deadline: 2024-10-23T10:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.11.5 release.
There are 135 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.5-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.11.5-rc1

Vasiliy Kovalev <kovalev@altlinux.org>
    ALSA: hda/conexant - Use cached pin control for Node 0x1d on HP EliteOne 1000 G2

Chris Li <chrisl@kernel.org>
    mm: vmscan.c: fix OOM on swap stress test

Johan Hovold <johan+linaro@kernel.org>
    serial: qcom-geni: fix receiver enable

Johan Hovold <johan+linaro@kernel.org>
    serial: qcom-geni: fix dma rx cancellation

Johan Hovold <johan+linaro@kernel.org>
    serial: qcom-geni: fix shutdown race

Johan Hovold <johan+linaro@kernel.org>
    serial: qcom-geni: revert broken hibernation support

Johan Hovold <johan+linaro@kernel.org>
    serial: qcom-geni: fix polled console initialisation

Charlie Jenkins <charlie@rivosinc.com>
    irqchip/sifive-plic: Return error code on failure

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

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    pinctrl: intel: platform: fix error path in device_for_each_child_node()

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    pinctrl: nuvoton: fix a double free in ma35_pinctrl_dt_node_to_map_func()

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

Roger Quadros <rogerq@kernel.org>
    usb: dwc3: core: Fix system suspend on TI AM62 platforms

Prashanth K <quic_prashk@quicinc.com>
    usb: dwc3: Wait for EndXfer completion before restoring GUSB2PHYCFG

Kevin Groeneveld <kgroeneveld@lenbrook.com>
    usb: gadget: f_uac2: fix return value for UAC2_ATTRIBUTE_STRING store

Alan Stern <stern@rowland.harvard.edu>
    USB: gadget: dummy-hcd: Fix "task hung" problem

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

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: btusb: Fix not being able to reconnect after suspend

Aaron Thompson <dev@aaront.org>
    Bluetooth: ISO: Fix multiple init when debugfs is disabled

Aaron Thompson <dev@aaront.org>
    Bluetooth: Remove debugfs directory on module init failure

Aaron Thompson <dev@aaront.org>
    Bluetooth: Call iso_exit() on module unload

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: accel: kx022a: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: adc: ad7944: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: resolver: ad2s1210: add missing select (TRIGGERED_)BUFFER in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: adc: ti-ads124s08: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: adc: ti-lmp92064: add missing select REGMAP_SPI in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: adc: ti-lmp92064: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: dac: ad3552r: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: proximity: mb1232: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: dac: ad5766: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: pressure: bm1390: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: resolver: ad2s1210 add missing select REGMAP in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: magnetometer: af8133j: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: light: bu27008: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: chemical: ens160: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

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

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/smu13: always apply the powersave optimization

Michael Chen <michael.chen@amd.com>
    drm/amdgpu/mes: fix issue of writing to the same log buffer from 2 MES pipes

Nikolay Kuratov <kniv@yandex-team.ru>
    drm/vmwgfx: Handle surface check failure correctly

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: Cleanup kms setup without 3d

Nirmoy Das <nirmoy.das@intel.com>
    drm/xe/ufence: ufence can be signaled right after wait_woken

Matthew Auld <matthew.auld@intel.com>
    drm/xe/xe_sync: initialise ufence.signalled

Imre Deak <imre.deak@intel.com>
    drm/i915/dp_mst: Don't require DSC hblank quirk for a non-DSC compatible mode

Imre Deak <imre.deak@intel.com>
    drm/i915/dp_mst: Handle error during DSC BW overhead/slice calculation

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/radeon: Fix encoder->possible_clones

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Requeue aborted request

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Fix the issue of ICU failure

Seunghwan Baek <sh8267.baek@samsung.com>
    scsi: ufs: core: Set SDEV_OFFLINE when UFS is shut down

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Validate SAS port assignments

John Edwards <uejji@uejji.net>
    Input: xpad - add support for MSI Claw A1M

Yun Lu <luyun@kylinos.cn>
    selftest: hid: add the missing tests directory

Jens Axboe <axboe@kernel.dk>
    io_uring/sqpoll: ensure task state is TASK_RUNNING when running task_work

Ming Lei <ming.lei@redhat.com>
    ublk: don't allow user copy for unprivileged device

Ming Lei <ming.lei@redhat.com>
    blk-mq: setup queue ->tag_set before initializing hctx

Jens Axboe <axboe@kernel.dk>
    io_uring/sqpoll: close race on waiting for sqring entries

Omar Sandoval <osandov@fb.com>
    blk-rq-qos: fix crash on rq_qos_wait vs. rq_qos_wake_function race

Stefan Kerkmann <s.kerkmann@pengutronix.de>
    Input: xpad - add support for 8BitDo Ultimate 2C Wireless Controller

Steven Rostedt <rostedt@goodmis.org>
    fgraph: Use CPU hotplug mechanism to initialize idle shadow stacks

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

Paolo Abeni <pabeni@redhat.com>
    tcp: fix mptcp DSS corruption due to large pmtu xmit

Jinjie Ruan <ruanjinjie@huawei.com>
    mm/damon/tests/sysfs-kunit.h: fix memory leak in damon_sysfs_test_add_targets()

Liu Shixin <liushixin2@huawei.com>
    mm/swapfile: skip HugeTLB pages for unuse_vma

Wei Xu <weixugc@google.com>
    mm/mglru: only clear kswapd_failures if reclaimable

Yang Shi <yang@os.amperecomputing.com>
    mm: khugepaged: fix the arguments order in khugepaged_collapse_file trace point

Jann Horn <jannh@google.com>
    mm/mremap: fix move_normal_pmd/retract_page_tables race

Edward Liaw <edliaw@google.com>
    selftests/mm: fix deadlock for fork after pthread_create on ARM

Edward Liaw <edliaw@google.com>
    selftests/mm: replace atomic_bool with pthread_barrier_t

Florian Westphal <fw@strlen.de>
    lib: alloc_tag_module_unload must wait for pending kfree_rcu calls

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    fat: fix uninitialized variable

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: propagate directory read errors from nilfs_find_entry()

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    maple_tree: correct tree corruption on spanning store

Paolo Abeni <pabeni@redhat.com>
    selftests: mptcp: join: test for prohibited MPC to port-based endp

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

Josua Mayer <josua@solid-run.com>
    arm64: dts: marvell: cn9130-sr-som: fix cp0 mdio pin numbers

Jakub Sitnicki <jakub@cloudflare.com>
    udp: Compute L4 checksum as usual when not segmenting the skb

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

Zhu Jun <zhujun2@cmss.chinamobile.com>
    ALSA: scarlett2: Add error check after retrieving PEQ filter values

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix user-after-free from session log off

Roi Martin <jroi.martin@gmail.com>
    btrfs: fix uninitialized pointer free on read_alloc_one_name() error

Roi Martin <jroi.martin@gmail.com>
    btrfs: fix uninitialized pointer free in add_inode_ref()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/boot/dts/marvell/cn9130-sr-som.dtsi     |   2 +-
 arch/arm64/include/asm/uprobes.h                   |   8 +-
 arch/arm64/kernel/probes/decode-insn.c             |  16 ++-
 arch/arm64/kernel/probes/simulate-insn.c           |  18 ++--
 arch/arm64/kernel/probes/uprobes.c                 |   4 +-
 arch/s390/kvm/diag.c                               |   2 +-
 arch/s390/kvm/gaccess.c                            |   4 +
 arch/s390/kvm/gaccess.h                            |  14 +--
 arch/x86/entry/entry.S                             |   5 +
 arch/x86/entry/entry_32.S                          |   6 +-
 arch/x86/include/asm/cpufeatures.h                 |   4 +-
 arch/x86/include/asm/nospec-branch.h               |  11 +-
 arch/x86/kernel/apic/apic.c                        |  14 ++-
 arch/x86/kernel/cpu/amd.c                          |   3 +-
 arch/x86/kernel/cpu/bugs.c                         |  32 ++++++
 arch/x86/kernel/cpu/common.c                       |   3 +
 arch/x86/kernel/cpu/resctrl/core.c                 |   4 +-
 block/blk-mq.c                                     |   8 +-
 block/blk-rq-qos.c                                 |   2 +-
 drivers/block/ublk_drv.c                           |  11 +-
 drivers/bluetooth/btusb.c                          |  27 ++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c             |   4 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   6 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |  22 ++--
 drivers/gpu/drm/i915/display/intel_dp_mst.c        |  40 +++++--
 drivers/gpu/drm/radeon/radeon_encoders.c           |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |  30 +-----
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c            |   9 +-
 drivers/gpu/drm/xe/xe_sync.c                       |   2 +-
 drivers/gpu/drm/xe/xe_wait_user_fence.c            |   3 -
 drivers/iio/accel/Kconfig                          |   2 +
 drivers/iio/adc/Kconfig                            |   9 ++
 drivers/iio/amplifiers/Kconfig                     |   1 +
 drivers/iio/chemical/Kconfig                       |   2 +
 .../iio/common/hid-sensors/hid-sensor-trigger.c    |   2 +-
 drivers/iio/dac/Kconfig                            |   7 ++
 drivers/iio/frequency/Kconfig                      |   1 +
 drivers/iio/light/Kconfig                          |   2 +
 drivers/iio/light/opt3001.c                        |   4 +
 drivers/iio/light/veml6030.c                       |   5 +-
 drivers/iio/magnetometer/Kconfig                   |   2 +
 drivers/iio/pressure/Kconfig                       |   3 +
 drivers/iio/proximity/Kconfig                      |   2 +
 drivers/iio/resolver/Kconfig                       |   3 +
 drivers/input/joystick/xpad.c                      |   3 +
 drivers/iommu/intel/iommu.c                        |   4 +-
 drivers/irqchip/irq-gic-v3-its.c                   |  18 ++--
 drivers/irqchip/irq-sifive-plic.c                  |  29 ++---
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_otpe2p.c  |   2 +
 drivers/net/ethernet/cadence/macb_main.c           |  14 ++-
 drivers/net/ethernet/freescale/enetc/enetc.c       |  56 +++++++---
 drivers/net/ethernet/freescale/enetc/enetc.h       |   1 +
 drivers/net/ethernet/freescale/fec_ptp.c           |  58 +++++-----
 .../net/ethernet/microchip/vcap/vcap_api_kunit.c   |   2 +
 drivers/parport/procfs.c                           |  22 ++--
 drivers/pinctrl/intel/pinctrl-intel-platform.c     |   3 +-
 drivers/pinctrl/nuvoton/pinctrl-ma35.c             |   2 +-
 drivers/pinctrl/pinctrl-apple-gpio.c               |   3 +
 drivers/pinctrl/pinctrl-ocelot.c                   |   8 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |   9 +-
 drivers/s390/char/sclp.c                           |   3 +-
 drivers/s390/char/sclp_vt220.c                     |   4 +-
 drivers/scsi/mpi3mr/mpi3mr.h                       |   4 +-
 drivers/scsi/mpi3mr/mpi3mr_transport.c             |  42 +++++---
 drivers/tty/n_gsm.c                                |   2 +
 drivers/tty/serial/imx.c                           |  15 +++
 drivers/tty/serial/qcom_geni_serial.c              |  91 ++++++++--------
 drivers/tty/vt/vt.c                                |   2 +-
 drivers/ufs/core/ufs-mcq.c                         |  15 +--
 drivers/ufs/core/ufshcd.c                          |  24 ++---
 drivers/usb/dwc3/core.c                            |  19 ++++
 drivers/usb/dwc3/core.h                            |   3 +
 drivers/usb/dwc3/gadget.c                          |  10 +-
 drivers/usb/gadget/function/f_uac2.c               |   6 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |  20 +++-
 drivers/usb/host/xhci-ring.c                       |   2 +-
 drivers/usb/host/xhci-tegra.c                      |   2 +-
 drivers/usb/host/xhci.h                            |   2 +-
 drivers/usb/serial/option.c                        |   8 ++
 drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_port.c |   1 -
 fs/btrfs/tree-log.c                                |   6 +-
 fs/fat/namei_vfat.c                                |   2 +-
 fs/nilfs2/dir.c                                    |  48 +++++----
 fs/nilfs2/namei.c                                  |  39 ++++---
 fs/nilfs2/nilfs.h                                  |   2 +-
 fs/smb/server/mgmt/user_session.c                  |  26 ++++-
 fs/smb/server/mgmt/user_session.h                  |   4 +
 fs/smb/server/server.c                             |   2 +
 fs/smb/server/smb2pdu.c                            |   8 +-
 include/linux/fsl/enetc_mdio.h                     |   3 +-
 include/linux/irqchip/arm-gic-v4.h                 |   4 +-
 include/trace/events/huge_memory.h                 |   4 +-
 include/uapi/linux/ublk_cmd.h                      |   8 +-
 io_uring/io_uring.h                                |  10 +-
 kernel/time/posix-clock.c                          |   3 +
 kernel/trace/fgraph.c                              |  28 +++--
 lib/codetag.c                                      |   3 +
 lib/maple_tree.c                                   |  12 +--
 mm/damon/sysfs-test.h                              |   1 +
 mm/khugepaged.c                                    |   2 +-
 mm/mremap.c                                        |  11 +-
 mm/swapfile.c                                      |   2 +-
 mm/vmscan.c                                        |   6 +-
 net/bluetooth/af_bluetooth.c                       |   3 +
 net/bluetooth/iso.c                                |   6 +-
 net/ipv4/tcp_output.c                              |   4 +-
 net/ipv4/udp.c                                     |   4 +-
 net/ipv6/udp.c                                     |   4 +-
 net/mptcp/mib.c                                    |   1 +
 net/mptcp/mib.h                                    |   1 +
 net/mptcp/pm_netlink.c                             |   3 +-
 net/mptcp/protocol.h                               |   1 +
 net/mptcp/subflow.c                                |  11 ++
 sound/pci/hda/patch_conexant.c                     |  19 ++++
 sound/usb/mixer_scarlett2.c                        |   2 +
 tools/testing/selftests/hid/Makefile               |   1 +
 tools/testing/selftests/mm/uffd-common.c           |   5 +-
 tools/testing/selftests/mm/uffd-common.h           |   3 +-
 tools/testing/selftests/mm/uffd-unit-tests.c       |  21 ++--
 tools/testing/selftests/net/mptcp/mptcp_join.sh    | 117 +++++++++++++++------
 122 files changed, 863 insertions(+), 453 deletions(-)


