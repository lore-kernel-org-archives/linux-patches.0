Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BFD2E414;
	Mon, 30 Dec 2024 15:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573543; cv=none; b=kDIjxDh3ceSXijc4NEfMj/tjxWiw7l6c7xrdlpn/r8JjkjhpZMZ4CQcVcOrRWyjbDpQRzcCcmgr5yuYhQWSgrcQOhqFl1fywQdrv2HyyUEhUOfiVp1OYVJyS2QwMMzlgd6F+W94LKqpdm2ZrZckgz1kuBY53s7ly5y8bnphoVdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573543; c=relaxed/simple;
	bh=80WZfaquYjxRe2fx/sC8+N3TyD2hRVXluO2vPGsRP44=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZuGyTzo73eivQlM4fawFE3yXk1JUwEBe89FC/HHHgGMpSqEvaKZMOP7YOyoP92+QKzbAlDN/NhuLWRFieMRh2Qp3wJM3O47YgD4tOZPa8jBeqIt+XuEluraQ9Qg2X7+2i3uCPX6YqS5R3wOzrO8X7nd0rDBaVAxB6jC20xLrBww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0X5lxoO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0X5lxoO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8665CC4CED0;
	Mon, 30 Dec 2024 15:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573543;
	bh=80WZfaquYjxRe2fx/sC8+N3TyD2hRVXluO2vPGsRP44=;
	h=From:To:Cc:Subject:Date:From;
	b=0X5lxoO1QMGfEa5xUVWDrVYhY46DP/HgQoX7XprGLQ1F/Pfl74+Gk6xwxC77FGo7d
	 LLWE0RkxZw0VsRvZxOKbMeMNPCdOI6g8oyJhJ+doAkDcFFBkK73wcB86XQYhTlxz+8
	 kabw/lKS77yK0dVJ9eG7fwwjTwS87iBGLLPG0v+M=
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
Subject: [PATCH 6.1 00/60] 6.1.123-rc1 review
Date: Mon, 30 Dec 2024 16:42:10 +0100
Message-ID: <20241230154207.276570972@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.123-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.123-rc1
X-KernelTest-Deadline: 2025-01-01T15:42+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.123 release.
There are 60 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 01 Jan 2025 15:41:48 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.123-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.123-rc1

Colin Ian King <colin.i.king@gmail.com>
    ALSA: hda/realtek: Fix spelling mistake "Firelfy" -> "Firefly"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "rcu-tasks: Fix access non-existent percpu rtpcp variable in rcu_tasks_need_gpcb()"

Yang Erkun <yangerkun@huaweicloud.com>
    nfsd: cancel nfsd_shrinker_work using sync mode in nfs4_state_shutdown_net

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

NeilBrown <neilb@suse.de>
    sched/core: Report correct state for TASK_IDLE | TASK_FREEZABLE

Ulf Hansson <ulf.hansson@linaro.org>
    pmdomain: core: Add missing put_device()

Chris Chiu <chris.chiu@canonical.com>
    ALSA: hda/realtek: fix micmute LEDs don't work on HP Laptops

Dirk Su <dirk.su@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs don't work for EliteBook X G1i

Hou Tao <houtao1@huawei.com>
    bpf: Check validity of link->type in bpf_link_show_fdinfo()

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Don't call cleanup on profile rollback failure

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: mipsregs: Set proper ISA level for virt extensions

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Probe toolchain support of -msym32

Matthew Wilcox (Oracle) <willy@infradead.org>
    vmalloc: fix accounting with i915

Ming Lei <ming.lei@redhat.com>
    blk-mq: register cpuhp callback after hctx is added to xarray table

Ming Lei <ming.lei@redhat.com>
    virtio-blk: don't keep queue frozen during system suspend

Imre Deak <imre.deak@intel.com>
    drm/dp_mst: Ensure mst_primary pointer is valid in drm_dp_mst_handle_up_req()

Cathy Avery <cavery@redhat.com>
    scsi: storvsc: Do not flag MAINTENANCE_IN return of SRB_STATUS_DATA_OVERRUN as an error

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpt3sas: Diag-Reset when Doorbell-In-Use bit is set during driver load time

Armin Wolf <W_Armin@gmx.de>
    platform/x86: asus-nb-wmi: Ignore unknown event 0xCF

Mark Brown <broonie@kernel.org>
    regmap: Use correct format specifier for logging range errors

Brahmajit Das <brahmajit.xyz@gmail.com>
    smb: server: Fix building with GCC 15

bo liu <bo.liu@senarytech.com>
    ALSA: hda/conexant: fix Z60MR100 startup pop issue

Tomas Henzl <thenzl@redhat.com>
    scsi: megaraid_sas: Fix for a potential deadlock

Magnus Lindholm <linmag7@gmail.com>
    scsi: qla1280: Fix hw revision numbering for ISP1020/1040

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

Cong Wang <cong.wang@bytedance.com>
    bpf: Check negative offsets in __bpf_skb_min_len()

Zijian Zhang <zijianzhang@bytedance.com>
    tcp_bpf: Add sk_rmem_alloc related logic for tcp_bpf ingress redirection

Cong Wang <cong.wang@bytedance.com>
    tcp_bpf: Charge receive socket buffer in bpf_tcp_ingress()

Bart Van Assche <bvanassche@acm.org>
    mm/vmstat: fix a W=1 clang compiler warning

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    media: dvb-frontends: dib3000mb: fix uninit-value in dib3000_write_reg


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/mips/Makefile                                 |   2 +-
 arch/mips/include/asm/mipsregs.h                   |  13 ++-
 arch/powerpc/platforms/book3s/vas-api.c            |  36 ++++++
 block/blk-mq.c                                     |  15 ++-
 drivers/base/power/domain.c                        |   1 +
 drivers/base/regmap/regmap.c                       |   4 +-
 drivers/block/virtio_blk.c                         |   7 +-
 drivers/dma/apple-admac.c                          |   7 +-
 drivers/dma/at_xdmac.c                             |   2 +
 drivers/dma/dw/acpi.c                              |   6 +-
 drivers/dma/dw/internal.h                          |   8 ++
 drivers/dma/dw/pci.c                               |   4 +-
 drivers/dma/mv_xor.c                               |   2 +
 drivers/dma/tegra186-gpc-dma.c                     |  10 ++
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |  24 +++-
 drivers/i2c/busses/i2c-imx.c                       |   1 +
 drivers/i2c/busses/i2c-microchip-corei2c.c         | 126 ++++++++++++++++-----
 drivers/media/dvb-frontends/dib3000mb.c            |   2 +-
 drivers/mtd/nand/raw/arasan-nand-controller.c      |  11 +-
 drivers/mtd/nand/raw/atmel/pmecc.c                 |   4 +-
 drivers/mtd/nand/raw/diskonchip.c                  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   4 +-
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
 drivers/watchdog/it87_wdt.c                        |  39 +++++++
 fs/btrfs/inode.c                                   |   2 +
 fs/btrfs/sysfs.c                                   |   6 +-
 fs/nfsd/nfs4callback.c                             |   4 +-
 fs/nfsd/nfs4state.c                                |   2 +-
 fs/smb/server/smb_common.c                         |   4 +-
 include/linux/sched.h                              |   5 +-
 include/linux/skmsg.h                              |  11 +-
 include/linux/trace_events.h                       |   2 +-
 include/linux/vmstat.h                             |   2 +-
 include/net/sock.h                                 |  10 +-
 include/uapi/linux/stddef.h                        |  13 ++-
 io_uring/sqpoll.c                                  |   6 +
 kernel/bpf/syscall.c                               |  13 ++-
 kernel/rcu/tasks.h                                 |  82 +++++---------
 kernel/trace/trace.c                               |   3 +
 kernel/trace/trace_kprobe.c                        |   2 +-
 mm/vmalloc.c                                       |   6 +-
 net/core/filter.c                                  |  21 +++-
 net/core/skmsg.c                                   |   6 +-
 net/ipv4/tcp_bpf.c                                 |   6 +-
 sound/pci/hda/patch_conexant.c                     |  28 +++++
 sound/pci/hda/patch_realtek.c                      |   7 ++
 tools/include/uapi/linux/stddef.h                  |  15 ++-
 57 files changed, 474 insertions(+), 187 deletions(-)


