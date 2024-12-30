Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F8A15E8B;
	Mon, 30 Dec 2024 15:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573792; cv=none; b=YsdU/LEDfvJPSLAqHwBa04L0xq5UC5pkn6IpMlvAtLkkkEH9i41tSL/ldnYqPiIPk0G3HEoojxps8D/E7rAwFd1aHLWgXJNJ/dFtatZgonMnm+12zMxqs1sH3tAvMrIB1+ULTKcWpjFR7BRkEfhac6WbEEAXTvdQeF4m33gj+Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573792; c=relaxed/simple;
	bh=fozgOnkBlTpgZISapMSj4srflXBn5YcocE5hK6Aw7u0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=A0/RGQR2+qrAWC0xF0ZFgVn1BT7YIupl5uCh+PGrig7xJscUM/uQvQoWfzW0lv4z22J7PpYX7Cla17NdRY4e2nC5TcHcTqHXEx/YqDNXuLCLMjkHtnWn82Q33oTNZmrN9+2LwajBL9rzlaktU9PERnYUipsknfctoaKT1HxRDO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1O0/An/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1O0/An/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4D2C4CED0;
	Mon, 30 Dec 2024 15:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573792;
	bh=fozgOnkBlTpgZISapMSj4srflXBn5YcocE5hK6Aw7u0=;
	h=From:To:Cc:Subject:Date:From;
	b=o1O0/An/cQUoaSGVSGpIXS309Epl0RhmgHpOR5o0uFsYOwxWqzXirN6rdVSnbyzyX
	 QcQSkc85sZfc8azZ+VxBoUGh0F53eYEeFG4JYfBoYd1h7zJ5N5dqTH2d1XyXA5bnem
	 foesukbQcIpxp7cI1eBO0Fa2I1GzPqfXPapWxnJA=
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
Subject: [PATCH 6.6 00/86] 6.6.69-rc1 review
Date: Mon, 30 Dec 2024 16:42:08 +0100
Message-ID: <20241230154211.711515682@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.69-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.69-rc1
X-KernelTest-Deadline: 2025-01-01T15:42+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.69 release.
There are 86 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 01 Jan 2025 15:41:48 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.69-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.69-rc1

Ming Lei <ming.lei@redhat.com>
    block: avoid to reuse `hctx` not removed from cpuhp callback list

Colin Ian King <colin.i.king@gmail.com>
    ALSA: hda/realtek: Fix spelling mistake "Firelfy" -> "Firefly"

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/cpu/intel: Drop stray FAM6 check with new Intel CPU model defines

Takashi Iwai <tiwai@suse.de>
    ALSA: sh: Fix wrong argument order for copy_from_iter()

Qu Wenruo <wqu@suse.com>
    btrfs: sysfs: fix direct super block member reads

Filipe Manana <fdmanana@suse.com>
    btrfs: avoid monopolizing a core when activating a swap file

Dimitri Fedrau <dimitri.fedrau@liebherr.com>
    power: supply: gpio-charger: Fix set charge current limits

Conor Dooley <conor.dooley@microchip.com>
    i2c: microchip-core: fix "ghost" detections

Carlos Song <carlos.song@nxp.com>
    i2c: imx: add imx7d compatible string for applying erratum ERR007805

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Handle lack of irqdomain gracefully

Conor Dooley <conor.dooley@microchip.com>
    i2c: microchip-core: actually use repeated sends

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/sqpoll: fix sqpoll error handling races

Lizhi Xu <lizhi.xu@windriver.com>
    tracing: Prevent bad count for tracing_cpumask_write

Christian Göttsche <cgzones@googlemail.com>
    tracing: Constify string literal data member in struct trace_event_call

Chen Ridong <chenridong@huawei.com>
    freezer, sched: Report frozen tasks as 'D' instead of 'R'

Jesse.zhang@amd.com <Jesse.zhang@amd.com>
    drm/amdkfd: pause autosuspend when creating pdd

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdkfd: Use device based logging for errors

Alex Deucher <alexander.deucher@amd.com>
    drm/amdkfd: drop struct kfd_cu_info

Alex Deucher <alexander.deucher@amd.com>
    drm/amdkfd: reduce stack size in kfd_topology_add_device()

Len Brown <len.brown@intel.com>
    x86/cpu: Add Lunar Lake to list of CPUs with a broken MONITOR implementation

Tony Luck <tony.luck@intel.com>
    x86/cpu/intel: Switch to new Intel CPU model defines

Tony Luck <tony.luck@intel.com>
    x86/cpu/vfm: Update arch/x86/include/asm/intel-family.h

Tony Luck <tony.luck@intel.com>
    x86/cpu/vfm: Add/initialize x86_vfm field to struct cpuinfo_x86

Tony Luck <tony.luck@intel.com>
    x86/cpu: Add model number for another Intel Arrow Lake mobile processor

Tony Luck <tony.luck@intel.com>
    x86/cpu: Add model number for Intel Clearwater Forest processor

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/hdp6.0: do a posting read when flushing HDP

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/hdp5.0: do a posting read when flushing HDP

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/hdp4.0: do a posting read when flushing HDP

Victor Zhao <Victor.Zhao@amd.com>
    drm/amd/amdgpu: allow use kiq to do hdp flush under sriov

Ulf Hansson <ulf.hansson@linaro.org>
    pmdomain: core: Add missing put_device()

Chris Chiu <chris.chiu@canonical.com>
    ALSA: hda/realtek: fix micmute LEDs don't work on HP Laptops

Dirk Su <dirk.su@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs don't work for EliteBook X G1i

Qun-Wei Lin <qun-wei.lin@mediatek.com>
    sched/task_stack: fix object_is_on_stack() for KASAN tagged pointers

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: mipsregs: Set proper ISA level for virt extensions

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Probe toolchain support of -msym32

Ming Lei <ming.lei@redhat.com>
    blk-mq: move cpuhp callback registering out of q->sysfs_lock

Ming Lei <ming.lei@redhat.com>
    blk-mq: register cpuhp callback after hctx is added to xarray table

Ming Lei <ming.lei@redhat.com>
    virtio-blk: don't keep queue frozen during system suspend

Imre Deak <imre.deak@intel.com>
    drm/dp_mst: Ensure mst_primary pointer is valid in drm_dp_mst_handle_up_req()

Purushothama Siddaiah <psiddaiah@mvista.com>
    spi: omap2-mcspi: Fix the IS_ERR() bug for devm_clk_get_optional_enabled()

Cathy Avery <cavery@redhat.com>
    scsi: storvsc: Do not flag MAINTENANCE_IN return of SRB_STATUS_DATA_OVERRUN as an error

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpt3sas: Diag-Reset when Doorbell-In-Use bit is set during driver load time

Aapo Vienamo <aapo.vienamo@iki.fi>
    spi: intel: Add Panther Lake SPI controller support

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

Jan Kara <jack@suse.cz>
    udf: Skip parent dir link count update if corrupted

Tomas Henzl <thenzl@redhat.com>
    scsi: megaraid_sas: Fix for a potential deadlock

Magnus Lindholm <linmag7@gmail.com>
    scsi: qla1280: Fix hw revision numbering for ISP1020/1040

Yassine Oudjana <y.oudjana@protonmail.com>
    watchdog: mediatek: Add support for MT6735 TOPRGU/WDT

James Hilliard <james.hilliard1@gmail.com>
    watchdog: it87_wdt: add PWRGD enable quirk for Qotom QCML04

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/kprobe: Make trace_kprobe's module callback called after jump_label update

Alexander Lobakin <aleksander.lobakin@intel.com>
    stddef: make __struct_group() UAPI C++-friendly

Haren Myneni <haren@linux.ibm.com>
    powerpc/pseries/vas: Add close() callback in vas_vm_ops struct

Dan Carpenter <dan.carpenter@linaro.org>
    mtd: rawnand: fix double free in atmel_pmecc_create_user()

Chen Ridong <chenridong@huawei.com>
    dmaengine: at_xdmac: avoid null_prt_deref in at_xdmac_prep_dma_memset

Sasha Finkelstein <fnkl.kernel@gmail.com>
    dmaengine: apple-admac: Avoid accessing registers in probe

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    dmaengine: fsl-edma: implement the cleanup path of fsl_edma3_attach_pd()

Akhil R <akhilrajeev@nvidia.com>
    dmaengine: tegra: Return correct DMA status when paused

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: dw: Select only supported masters for ACPI devices

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    dmaengine: mv_xor: fix child node refcount handling in early exit

Chukun Pan <amadeus@jmu.edu.cn>
    phy: rockchip: naneng-combphy: fix phy reset

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

Bart Van Assche <bvanassche@acm.org>
    mm/vmstat: fix a W=1 clang compiler warning

Ilya Dryomov <idryomov@gmail.com>
    ceph: allocate sparse_ext map only for sparse reads

Ilya Dryomov <idryomov@gmail.com>
    ceph: fix memory leak in ceph_direct_read_write()

Xiubo Li <xiubli@redhat.com>
    ceph: try to allocate a smaller extent map for sparse read

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    media: dvb-frontends: dib3000mb: fix uninit-value in dib3000_write_reg


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/loongarch/include/asm/inst.h                  |  12 +-
 arch/loongarch/kernel/efi.c                        |   2 +-
 arch/loongarch/kernel/inst.c                       |   2 +-
 arch/loongarch/net/bpf_jit.c                       |   6 +-
 arch/mips/Makefile                                 |   2 +-
 arch/mips/include/asm/mipsregs.h                   |  13 ++-
 arch/powerpc/platforms/book3s/vas-api.c            |  36 ++++++
 arch/x86/include/asm/intel-family.h                |  87 ++++++++++++++
 arch/x86/include/asm/processor.h                   |  20 +++-
 arch/x86/kernel/cpu/intel.c                        | 118 ++++++++++---------
 arch/x86/kernel/cpu/match.c                        |   3 +-
 block/blk-mq.c                                     | 119 ++++++++++++++++---
 drivers/base/power/domain.c                        |   1 +
 drivers/base/regmap/regmap.c                       |   4 +-
 drivers/block/virtio_blk.c                         |   7 +-
 drivers/dma/apple-admac.c                          |   7 +-
 drivers/dma/at_xdmac.c                             |   2 +
 drivers/dma/dw/acpi.c                              |   6 +-
 drivers/dma/dw/internal.h                          |   8 ++
 drivers/dma/dw/pci.c                               |   4 +-
 drivers/dma/fsl-edma-common.h                      |   1 +
 drivers/dma/fsl-edma-main.c                        |  41 ++++++-
 drivers/dma/mv_xor.c                               |   2 +
 drivers/dma/tegra186-gpc-dma.c                     |  10 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |  22 ----
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h         |   2 -
 drivers/gpu/drm/amd/amdgpu/hdp_v4_0.c              |  14 ++-
 drivers/gpu/drm/amd/amdgpu/hdp_v5_0.c              |   9 +-
 drivers/gpu/drm/amd/amdgpu/hdp_v6_0.c              |   8 +-
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c              |  28 ++---
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  15 +++
 drivers/gpu/drm/amd/amdkfd/kfd_flat_memory.c       |   3 +-
 drivers/gpu/drm/amd/amdkfd/kfd_kernel_queue.c      |  21 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c       |  32 +++---
 drivers/gpu/drm/amd/amdkfd/kfd_packet_manager.c    |  63 +++++++----
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |  43 +++----
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c          |  44 ++++---
 drivers/gpu/drm/amd/include/kgd_kfd_interface.h    |  14 ---
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |  24 +++-
 drivers/i2c/busses/i2c-imx.c                       |   1 +
 drivers/i2c/busses/i2c-microchip-corei2c.c         | 126 ++++++++++++++++-----
 drivers/media/dvb-frontends/dib3000mb.c            |   2 +-
 drivers/mtd/nand/raw/arasan-nand-controller.c      |  11 +-
 drivers/mtd/nand/raw/atmel/pmecc.c                 |   4 +-
 drivers/mtd/nand/raw/diskonchip.c                  |   2 +-
 drivers/pci/msi/irqdomain.c                        |   7 +-
 drivers/pci/msi/msi.c                              |   4 +
 drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c  |   6 +
 drivers/phy/phy-core.c                             |  21 ++--
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c            |   2 +-
 drivers/phy/rockchip/phy-rockchip-naneng-combphy.c |   2 +-
 drivers/platform/x86/asus-nb-wmi.c                 |   1 +
 drivers/power/supply/gpio-charger.c                |   8 ++
 drivers/scsi/megaraid/megaraid_sas_base.c          |   5 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   7 +-
 drivers/scsi/qla1280.h                             |  12 +-
 drivers/scsi/storvsc_drv.c                         |   7 +-
 drivers/spi/spi-intel-pci.c                        |   2 +
 drivers/spi/spi-omap2-mcspi.c                      |   6 +-
 drivers/watchdog/it87_wdt.c                        |  39 +++++++
 drivers/watchdog/mtk_wdt.c                         |   6 +
 fs/btrfs/inode.c                                   |   2 +
 fs/btrfs/sysfs.c                                   |   6 +-
 fs/ceph/addr.c                                     |   4 +-
 fs/ceph/file.c                                     |  43 +++----
 fs/ceph/super.h                                    |  14 +++
 fs/nfsd/export.c                                   |  31 +----
 fs/nfsd/export.h                                   |   4 +-
 fs/nfsd/nfs4callback.c                             |   4 +-
 fs/smb/server/smb_common.c                         |   4 +-
 fs/udf/namei.c                                     |   6 +-
 include/linux/ceph/osd_client.h                    |   7 +-
 include/linux/sched.h                              |   3 +-
 include/linux/sched/task_stack.h                   |   2 +
 include/linux/skmsg.h                              |  11 +-
 include/linux/trace_events.h                       |   2 +-
 include/linux/vmstat.h                             |   2 +-
 include/net/sock.h                                 |  10 +-
 include/uapi/linux/stddef.h                        |  13 ++-
 io_uring/sqpoll.c                                  |   6 +
 kernel/trace/trace.c                               |   3 +
 kernel/trace/trace_kprobe.c                        |   2 +-
 net/ceph/osd_client.c                              |   2 +
 net/core/filter.c                                  |  21 +++-
 net/core/skmsg.c                                   |   6 +-
 net/ipv4/tcp_bpf.c                                 |   6 +-
 sound/pci/hda/patch_conexant.c                     |  28 +++++
 sound/pci/hda/patch_realtek.c                      |   7 ++
 sound/sh/sh_dac_audio.c                            |   5 +-
 tools/include/uapi/linux/stddef.h                  |  15 ++-
 91 files changed, 980 insertions(+), 429 deletions(-)


