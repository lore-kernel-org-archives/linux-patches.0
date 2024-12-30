Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7AE15748F;
	Mon, 30 Dec 2024 15:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574053; cv=none; b=cqcvjFFapOrJMBBYe+ctdFSBiPXuNRjsufsp+ncB9bvZXDHayoEzLYboV88bQmoue3BqozhvTG39vFZhYpgLRIw7srSbel+s230ZRid8zFS0/nsXkDld5h1OKyqqCvMSHju0KET/AilOV6FW180N+Xp1QHH/vOY7XGkqp3SGk/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574053; c=relaxed/simple;
	bh=0FEHZbo0LUlG4olpMOPNaO4KtvVEFNxRXbg8TSk6RAk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iKWcj9dKVjbVxLwjqveR4VUfgxSONK2xGhHG99oMbP2AiAATSXgSlzh1yrhAlh45mVfujarqdzElYtJ/Kgkgc9PcDY1M5Y7z5gaKs9KI1CsWfd+tg3p17oPzRFOyNq28hSrgZPG/DZWRztXr+xWYgT4ZmuRDYbqb6IPAs0ulf/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PYuYYtv5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PYuYYtv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E152AC4CED0;
	Mon, 30 Dec 2024 15:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574053;
	bh=0FEHZbo0LUlG4olpMOPNaO4KtvVEFNxRXbg8TSk6RAk=;
	h=From:To:Cc:Subject:Date:From;
	b=PYuYYtv5R9t9RjZrvWODBEYAn39E3bx1JPBhxeJ1k2g2X7PftqaVmFxV+2LIfbopP
	 GVSu9ZyDPhQFlu/CGnybfq/RQvPbWkAVBstjdT7T/I4mqrAqv1GjY48Ory6cLcp6Q1
	 oUIC02qrXoKpy0s9dpVAo1ANJt4tl3Km8KMsfPjQ=
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
Subject: [PATCH 6.12 000/114] 6.12.8-rc1 review
Date: Mon, 30 Dec 2024 16:41:57 +0100
Message-ID: <20241230154218.044787220@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.8-rc1
X-KernelTest-Deadline: 2025-01-01T15:42+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.8 release.
There are 114 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 01 Jan 2025 15:41:48 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.8-rc1

Takashi Iwai <tiwai@suse.de>
    ALSA: sh: Fix wrong argument order for copy_from_iter()

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Shut up truncated string warning

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btusb: mediatek: change the conditions for ISO interface

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btusb: mediatek: add intf release flow when usb disconnect

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btusb: mediatek: add callback function in btusb_disconnect

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btusb: mediatek: move Bluetooth power off command position

Boris Burkov <boris@bur.io>
    btrfs: check folio mapping after unlock in relocate_one_folio()

Boris Burkov <boris@bur.io>
    btrfs: check folio mapping after unlock in put_file_data()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix use-after-free when COWing tree bock and tracing is enabled

Qu Wenruo <wqu@suse.com>
    btrfs: sysfs: fix direct super block member reads

Julian Sun <sunjunchao2870@gmail.com>
    btrfs: fix transaction atomicity bug when enabling simple quotas

Filipe Manana <fdmanana@suse.com>
    btrfs: fix swap file activation failure due to extents that used to be shared

Filipe Manana <fdmanana@suse.com>
    btrfs: avoid monopolizing a core when activating a swap file

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race with memory mapped writes when activating swap file

Dimitri Fedrau <dimitri.fedrau@liebherr.com>
    power: supply: gpio-charger: Fix set charge current limits

Thomas Weißschuh <linux@weissschuh.net>
    power: supply: cros_charge-control: hide start threshold on v2 cmd

Thomas Weißschuh <linux@weissschuh.net>
    power: supply: cros_charge-control: allow start_threshold == end_threshold

Thomas Weißschuh <linux@weissschuh.net>
    power: supply: cros_charge-control: add mutex for driver data

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/ds: Add PEBS format 6

Conor Dooley <conor.dooley@microchip.com>
    i2c: microchip-core: fix "ghost" detections

Carlos Song <carlos.song@nxp.com>
    i2c: imx: add imx7d compatible string for applying erratum ERR007805

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix bitmask of OCR and FRONTEND events for LNC

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Handle lack of irqdomain gracefully

Li RongQing <lirongqing@baidu.com>
    virt: tdx-guest: Just leak decrypted memory on unrecoverable errors

Xin Li (Intel) <xin@zytor.com>
    x86/fred: Clear WFE in missing-ENDBRANCH #CPs

Conor Dooley <conor.dooley@microchip.com>
    i2c: microchip-core: actually use repeated sends

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/sqpoll: fix sqpoll error handling races

Tomas Glozar <tglozar@redhat.com>
    rtla/timerlat: Fix histogram ALL for zero samples

Lizhi Xu <lizhi.xu@windriver.com>
    tracing: Prevent bad count for tracing_cpumask_write

Christian Göttsche <cgzones@googlemail.com>
    tracing: Constify string literal data member in struct trace_event_call

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Add Clearwater Forest support

Binbin Zhou <zhoubinbin@loongson.cn>
    dmaengine: loongson2-apb: Change GENMASK to GENMASK_ULL

Chen Ridong <chenridong@huawei.com>
    freezer, sched: Report frozen tasks as 'D' instead of 'R'

chenchangcheng <ccc194101@163.com>
    objtool: Add bch2_trans_unlocked_error() to bcachefs noreturns

John Harrison <John.C.Harrison@Intel.com>
    drm/xe: Move the coredump registration to the worker thread

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Take PM ref in delayed snapshot capture worker

Ming Lei <ming.lei@redhat.com>
    ublk: detach gendisk from ublk device if add_disk() fails

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: be less noisy if the NIC is dead in S3

Ming Lei <ming.lei@redhat.com>
    blk-mq: register cpuhp callback after hctx is added to xarray table

Ming Lei <ming.lei@redhat.com>
    virtio-blk: don't keep queue frozen during system suspend

Imre Deak <imre.deak@intel.com>
    drm/dp_mst: Ensure mst_primary pointer is valid in drm_dp_mst_handle_up_req()

Purushothama Siddaiah <psiddaiah@mvista.com>
    spi: omap2-mcspi: Fix the IS_ERR() bug for devm_clk_get_optional_enabled()

Qinxin Xia <xiaqinxin@huawei.com>
    ACPI/IORT: Add PMCG platform information for HiSilicon HIP09A

Cathy Avery <cavery@redhat.com>
    scsi: storvsc: Do not flag MAINTENANCE_IN return of SRB_STATUS_DATA_OVERRUN as an error

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Handling of fault code for insufficient power

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Start controller indexing from 0

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Fix corrupt config pages PHY state is switched in sysfs

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Synchronize access to ioctl data buffer

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpt3sas: Diag-Reset when Doorbell-In-Use bit is set during driver load time

Aapo Vienamo <aapo.vienamo@iki.fi>
    spi: intel: Add Panther Lake SPI controller support

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Zero index arg error string for dynptr and iter

Armin Wolf <W_Armin@gmx.de>
    platform/x86: asus-nb-wmi: Ignore unknown event 0xCF

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: BPF: Adjust the parameter of emit_jirl()

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Fix reserving screen info memory for above-4G firmware

Mark Brown <broonie@kernel.org>
    regmap: Use correct format specifier for logging range errors

Brahmajit Das <brahmajit.xyz@gmail.com>
    smb: server: Fix building with GCC 15

Takashi Iwai <tiwai@suse.de>
    ALSA: sh: Use standard helper for buffer accesses

bo liu <bo.liu@senarytech.com>
    ALSA: hda/conexant: fix Z60MR100 startup pop issue

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Update legacy substream names upon FB info update

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Indicate the inactive group in legacy substream names

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Don't open legacy substream for an inactive group

Jan Kara <jack@suse.cz>
    udf: Verify inode link counts before performing rename

Jan Kara <jack@suse.cz>
    udf: Skip parent dir link count update if corrupted

Tomas Henzl <thenzl@redhat.com>
    scsi: megaraid_sas: Fix for a potential deadlock

Magnus Lindholm <linmag7@gmail.com>
    scsi: qla1280: Fix hw revision numbering for ISP1020/1040

Yassine Oudjana <y.oudjana@protonmail.com>
    watchdog: mediatek: Add support for MT6735 TOPRGU/WDT

Peter Griffin <peter.griffin@linaro.org>
    Revert "watchdog: s3c2410_wdt: use exynos_get_pmu_regmap_by_phandle() for PMU regs"

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    watchdog: rzg2l_wdt: Power on the watchdog domain in the restart handler

James Hilliard <james.hilliard1@gmail.com>
    watchdog: it87_wdt: add PWRGD enable quirk for Qotom QCML04

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/kprobe: Make trace_kprobe's module callback called after jump_label update

Alexander Lobakin <aleksander.lobakin@intel.com>
    stddef: make __struct_group() UAPI C++-friendly

Hans de Goede <hdegoede@redhat.com>
    power: supply: bq24190: Fix BQ24296 Vbus regulator support

Haren Myneni <haren@linux.ibm.com>
    powerpc/pseries/vas: Add close() callback in vas_vm_ops struct

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: Intel: sof_sdw: Fix DMI match for Lenovo 21Q6 and 21Q7

Chen-Yu Tsai <wenst@chromium.org>
    ASoC: dt-bindings: realtek,rt5645: Fix CPVDD voltage comment

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: Intel: sof_sdw: Fix DMI match for Lenovo 21QA and 21QB

Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
    ASoC: amd: ps: Fix for enabling DMIC on acp63 platform via _DSD entry

Dan Carpenter <dan.carpenter@linaro.org>
    mtd: rawnand: fix double free in atmel_pmecc_create_user()

Dustin L. Howett <dustin@howett.net>
    platform/chrome: cros_ec_lpc: fix product identity for early Framework Laptops

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: hda-dai: Do not release the link DMA on STOP

Chen Ridong <chenridong@huawei.com>
    dmaengine: at_xdmac: avoid null_prt_deref in at_xdmac_prep_dma_memset

Sasha Finkelstein <fnkl.kernel@gmail.com>
    dmaengine: apple-admac: Avoid accessing registers in probe

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    dmaengine: fsl-edma: implement the cleanup path of fsl_edma3_attach_pd()

Lizhi Hou <lizhi.hou@amd.com>
    dmaengine: amd: qdma: Remove using the private get and set dma_ops APIs

Akhil R <akhilrajeev@nvidia.com>
    dmaengine: tegra: Return correct DMA status when paused

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: dw: Select only supported masters for ACPI devices

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    dmaengine: mv_xor: fix child node refcount handling in early exit

Fedor Pchelkin <pchelkin@ispras.ru>
    ALSA: memalloc: prefer dma_mapping_error() over explicit address checking

Chukun Pan <amadeus@jmu.edu.cn>
    phy: rockchip: naneng-combphy: fix phy reset

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    phy: rockchip: samsung-hdptx: Set drvdata before enabling runtime PM

Justin Chen <justin.chen@broadcom.com>
    phy: usb: Toggle the PHY power during init

Zijun Hu <quic_zijuhu@quicinc.com>
    phy: core: Fix that API devm_phy_destroy() fails to destroy the phy

Zijun Hu <quic_zijuhu@quicinc.com>
    phy: core: Fix that API devm_of_phy_provider_unregister() fails to unregister the phy provider

Zijun Hu <quic_zijuhu@quicinc.com>
    phy: core: Fix that API devm_phy_put() fails to release the phy

Zijun Hu <quic_zijuhu@quicinc.com>
    phy: core: Fix an OF node refcount leakage in of_phy_provider_lookup()

Zijun Hu <quic_zijuhu@quicinc.com>
    phy: core: Fix an OF node refcount leakage in _of_phy_get()

Krishna Kurapati <quic_kriskura@quicinc.com>
    phy: qcom-qmp: Fix register name in RX Lane config of SC8280XP

Maciej Andrzejewski <maciej.andrzejewski@m-works.net>
    mtd: rawnand: arasan: Fix missing de-registration of NAND

Maciej Andrzejewski <maciej.andrzejewski@m-works.net>
    mtd: rawnand: arasan: Fix double assertion of chip-select

Zichen Xie <zichenxie0106@gmail.com>
    mtd: diskonchip: Cast an operand to prevent potential overflow

NeilBrown <neilb@suse.de>
    nfsd: restore callback functionality for NFSv4.0

Yang Erkun <yangerkun@huawei.com>
    nfsd: Revert "nfsd: release svc_expkey/svc_export with rcu_work"

Cong Wang <cong.wang@bytedance.com>
    bpf: Check negative offsets in __bpf_skb_min_len()

Zijian Zhang <zijianzhang@bytedance.com>
    tcp_bpf: Add sk_rmem_alloc related logic for tcp_bpf ingress redirection

Cong Wang <cong.wang@bytedance.com>
    tcp_bpf: Charge receive socket buffer in bpf_tcp_ingress()

Bharath SM <bharathsm.hsk@gmail.com>
    smb: fix bytes written value in /proc/fs/cifs/Stats

Dragan Simic <dsimic@manjaro.org>
    smb: client: Deduplicate "select NETFS_SUPPORT" in Kconfig

Jerome Marchand <jmarchan@redhat.com>
    selftests/bpf: Fix compilation error in get_uprobe_offset()

Bart Van Assche <bvanassche@acm.org>
    mm/vmstat: fix a W=1 clang compiler warning

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    fork: avoid inappropriate uprobe access to invalid mm

Andrea Righi <arighi@nvidia.com>
    bpf: Fix bpf_get_smp_processor_id() on !CONFIG_SMP

Willow Cunningham <willow.e.cunningham@gmail.com>
    arm64: dts: broadcom: Fix L2 linesize for Raspberry Pi 5

Ilya Dryomov <idryomov@gmail.com>
    ceph: allocate sparse_ext map only for sparse reads

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    media: dvb-frontends: dib3000mb: fix uninit-value in dib3000_write_reg


-------------

Diffstat:

 Documentation/arch/arm64/silicon-errata.rst        |   5 +-
 .../devicetree/bindings/sound/realtek,rt5645.yaml  |   2 +-
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/broadcom/bcm2712.dtsi          |   8 +-
 arch/loongarch/include/asm/inst.h                  |  12 +-
 arch/loongarch/kernel/efi.c                        |   2 +-
 arch/loongarch/kernel/inst.c                       |   2 +-
 arch/loongarch/net/bpf_jit.c                       |   6 +-
 arch/powerpc/platforms/book3s/vas-api.c            |  36 +++++
 arch/x86/events/intel/core.c                       |  12 +-
 arch/x86/events/intel/ds.c                         |   1 +
 arch/x86/events/intel/uncore.c                     |   1 +
 arch/x86/kernel/cet.c                              |  30 ++++
 block/blk-mq.c                                     |  15 +-
 drivers/acpi/arm64/iort.c                          |   2 +
 drivers/base/regmap/regmap.c                       |   4 +-
 drivers/block/ublk_drv.c                           |  26 +--
 drivers/block/virtio_blk.c                         |   7 +-
 drivers/bluetooth/btusb.c                          |  41 +++--
 drivers/dma/amd/qdma/qdma.c                        |  28 ++--
 drivers/dma/apple-admac.c                          |   7 +-
 drivers/dma/at_xdmac.c                             |   2 +
 drivers/dma/dw/acpi.c                              |   6 +-
 drivers/dma/dw/internal.h                          |   8 +
 drivers/dma/dw/pci.c                               |   4 +-
 drivers/dma/fsl-edma-common.h                      |   1 +
 drivers/dma/fsl-edma-main.c                        |  41 ++++-
 drivers/dma/ls2x-apb-dma.c                         |   2 +-
 drivers/dma/mv_xor.c                               |   2 +
 drivers/dma/tegra186-gpc-dma.c                     |  10 ++
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |  24 ++-
 drivers/gpu/drm/xe/xe_devcoredump.c                |  69 ++++----
 drivers/i2c/busses/i2c-imx.c                       |   1 +
 drivers/i2c/busses/i2c-microchip-corei2c.c         | 126 +++++++++++----
 drivers/media/dvb-frontends/dib3000mb.c            |   2 +-
 drivers/mtd/nand/raw/arasan-nand-controller.c      |  11 +-
 drivers/mtd/nand/raw/atmel/pmecc.c                 |   4 +-
 drivers/mtd/nand/raw/diskonchip.c                  |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  28 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   2 +
 drivers/pci/msi/irqdomain.c                        |   7 +-
 drivers/pci/msi/msi.c                              |   4 +
 drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c  |   6 +
 drivers/phy/phy-core.c                             |  21 ++-
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c            |   2 +-
 drivers/phy/rockchip/phy-rockchip-naneng-combphy.c |   2 +-
 drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c  |   3 +-
 drivers/platform/chrome/cros_ec_lpc.c              |   4 +-
 drivers/platform/x86/asus-nb-wmi.c                 |   1 +
 drivers/power/supply/bq24190_charger.c             |  12 +-
 drivers/power/supply/cros_charge-control.c         |  36 +++--
 drivers/power/supply/gpio-charger.c                |   8 +
 drivers/scsi/megaraid/megaraid_sas_base.c          |   5 +-
 drivers/scsi/mpi3mr/mpi3mr.h                       |   9 --
 drivers/scsi/mpi3mr/mpi3mr_app.c                   |  36 +++--
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    | 121 ++++++--------
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   7 +-
 drivers/scsi/qla1280.h                             |  12 +-
 drivers/scsi/storvsc_drv.c                         |   7 +-
 drivers/spi/spi-intel-pci.c                        |   2 +
 drivers/spi/spi-omap2-mcspi.c                      |   6 +-
 drivers/virt/coco/tdx-guest/tdx-guest.c            |   4 +-
 drivers/watchdog/Kconfig                           |   1 +
 drivers/watchdog/it87_wdt.c                        |  39 +++++
 drivers/watchdog/mtk_wdt.c                         |   6 +
 drivers/watchdog/rzg2l_wdt.c                       |  20 ++-
 drivers/watchdog/s3c2410_wdt.c                     |   8 +-
 fs/btrfs/ctree.c                                   |  11 +-
 fs/btrfs/inode.c                                   | 129 +++++++++++----
 fs/btrfs/qgroup.c                                  |   3 +-
 fs/btrfs/relocation.c                              |   6 +
 fs/btrfs/send.c                                    |   6 +
 fs/btrfs/sysfs.c                                   |   6 +-
 fs/ceph/file.c                                     |   2 +-
 fs/nfsd/export.c                                   |  31 +---
 fs/nfsd/export.h                                   |   4 +-
 fs/nfsd/nfs4callback.c                             |   4 +-
 fs/smb/client/Kconfig                              |   1 -
 fs/smb/client/smb2pdu.c                            |   3 +
 fs/smb/server/smb_common.c                         |   4 +-
 fs/udf/namei.c                                     |  16 +-
 include/linux/platform_data/amd_qdma.h             |   2 +
 include/linux/sched.h                              |   3 +-
 include/linux/skmsg.h                              |  11 +-
 include/linux/trace_events.h                       |   2 +-
 include/linux/vmstat.h                             |   2 +-
 include/net/sock.h                                 |  10 +-
 include/uapi/linux/stddef.h                        |  13 +-
 io_uring/sqpoll.c                                  |   6 +
 kernel/bpf/verifier.c                              |  18 ++-
 kernel/fork.c                                      |  13 +-
 kernel/trace/trace.c                               |   3 +
 kernel/trace/trace_kprobe.c                        |   2 +-
 net/ceph/osd_client.c                              |   2 +
 net/core/filter.c                                  |  21 ++-
 net/core/skmsg.c                                   |   6 +-
 net/ipv4/tcp_bpf.c                                 |   6 +-
 sound/core/memalloc.c                              |   2 +-
 sound/core/ump.c                                   |  26 ++-
 sound/pci/hda/patch_conexant.c                     |  28 ++++
 sound/sh/sh_dac_audio.c                            |   5 +-
 sound/soc/amd/ps/pci-ps.c                          |  17 +-
 sound/soc/intel/boards/sof_sdw.c                   |  23 ++-
 sound/soc/sof/intel/hda-dai.c                      |  25 ++-
 sound/soc/sof/intel/hda.h                          |   2 -
 tools/include/uapi/linux/stddef.h                  |  15 +-
 tools/objtool/noreturns.h                          |   1 +
 tools/testing/selftests/bpf/progs/dynptr_fail.c    |  22 +--
 .../selftests/bpf/progs/iters_state_safety.c       |  14 +-
 .../selftests/bpf/progs/iters_testmod_seq.c        |   4 +-
 .../selftests/bpf/progs/test_kfunc_dynptr_param.c  |   2 +-
 .../selftests/bpf/progs/verifier_bits_iter.c       |   4 +-
 tools/testing/selftests/bpf/trace_helpers.c        |   4 +
 tools/tracing/rtla/src/timerlat_hist.c             | 177 +++++++++++----------
 116 files changed, 1169 insertions(+), 548 deletions(-)


