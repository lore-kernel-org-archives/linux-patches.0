Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700B71624C3;
	Fri, 28 Mar 2025 14:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743173541; cv=none; b=IpYhZjghvBwGLYOB5TgJG3efQ/209eMj08Fo6HYRo8y4UHsxGza5L9Jc4kri66435NCaIwZzzLtT6Wk/Sk/fLK3G/zpMWBCom6tI1YyE27IZ5y/kDm/RezGqxgsr+mVEPmW4vIX9wRCypHG2krXn7kJ8eQAxerZQJDieVjqYktQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743173541; c=relaxed/simple;
	bh=u8HZkBHk33/7uyUy5NTwVMnc49O8zZAT11ihgUr7MKA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Y3jrEk9Q0fkpUeCJv4hsPQhLzo4M1IJvtv3T3bg1V+X3Xw452LbQJit1D5Aa0BoQliTQmnK8eU1st8QSUwCFpYpcJRMbw4JtMAGG3SgxM3HmXzq5yLW43tLBxK5TGIoMCJqBi4kFhnCwFrU789yQALTuOAC7CZMp9IhD93lnV0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ztSvHw7L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ztSvHw7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E952C4CEE4;
	Fri, 28 Mar 2025 14:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743173540;
	bh=u8HZkBHk33/7uyUy5NTwVMnc49O8zZAT11ihgUr7MKA=;
	h=From:To:Cc:Subject:Date:From;
	b=ztSvHw7LuOJMQHzoZJfYWPea2FoQCIs71rPF+4SsogdAIevgdYtDZ6XMaiEoB8GIE
	 bAnZEPEQXkYvBtFi2hK25WnxVkk824tkFB4RxUU5k8h3GESQuyyjuXulrYB+IIW2Q5
	 8Sd73wcJbg1dvHZ7/MARYVH+6SQfoKyezJVBs8mY=
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
Subject: [PATCH 6.6 00/75] 6.6.85-rc3 review
Date: Fri, 28 Mar 2025 15:50:54 +0100
Message-ID: <20250328145011.672606157@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.85-rc3.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.85-rc3
X-KernelTest-Deadline: 2025-03-30T14:50+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.85 release.
There are 75 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 30 Mar 2025 14:49:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.85-rc3.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.85-rc3

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    netfilter: nft_counter: Use u64_stats_t for statistic.

Benjamin Berg <benjamin.berg@intel.com>
    wifi: iwlwifi: mvm: ensure offloading TID queue exists

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: support BIOS override for 5G9 in CA also in LARI version 8

Shravya KN <shravya.k-n@broadcom.com>
    bnxt_en: Fix receive ring space parameters when XDP is active

Josef Bacik <josef@toxicpanda.com>
    btrfs: make sure that WRITTEN is set on all metadata blocks

Dietmar Eggemann <dietmar.eggemann@arm.com>
    Revert "sched/core: Reduce cost of sched_move_task when config autogroup"

Justin Klaassen <justin@tidylabs.net>
    arm64: dts: rockchip: fix u2phy1_host status for NanoPi R4S

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Eagerly switch ZCR_EL{1,2}

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Mark some header functions as inline

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Refactor exit handlers

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Remove VHE host restore of CPACR_EL1.SMEN

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Remove VHE host restore of CPACR_EL1.ZEN

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Remove host FPSIMD saving for non-protected KVM

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Unconditionally save+flush host FPSIMD/SVE/SME state

Fuad Tabba <tabba@google.com>
    KVM: arm64: Calculate cptr_el2 traps on activating traps

Arthur Mongodin <amongodin@randorisec.fr>
    mptcp: Fix data stream corruption in the address announcement

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix incorrect validation for num_aces field of smb_acl

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Use HW lock mgr for PSR1 when only one eDP

Martin Tsai <martin.tsai@amd.com>
    drm/amd/display: should support dmub hw lock on Replay

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Fix JPEG video caps max size for navi1x and raven

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Fix MPEG2, MPEG4 and VC1 video caps max size

qianyi liu <liuqianyi125@gmail.com>
    drm/sched: Fix fence reference count leak

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    drm/radeon: fix uninitialized size issue in radeon_vce_cs_parse()

Saranya R <quic_sarar@quicinc.com>
    soc: qcom: pdr: Fix the potential deadlock

Sven Eckelmann <sven@narfation.org>
    batman-adv: Ignore own maximum aggregation size during RX

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    xsk: fix an integer overflow in xp_create_and_assign_umem()

Ard Biesheuvel <ardb@kernel.org>
    efi/libstub: Avoid physical address 0x0 when doing random allocation

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: shmobile: smp: Enforce shmobile_smp_* alignment

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    ARM: dts: imx6qdl-apalis: Fix poweroff on Apalis iMX6

Ye Bin <yebin10@huawei.com>
    proc: fix UAF in proc_get_inode()

Zi Yan <ziy@nvidia.com>
    mm/migrate: fix shmem xarray update during migration

Raphael S. Carvalho <raphaelsc@scylladb.com>
    mm: fix error handling in __filemap_get_folio() with FGP_NOWAIT

Gu Bowen <gubowen5@huawei.com>
    mmc: atmel-mci: Add missing clk_disable_unprepare()

Kamal Dasu <kamal.dasu@broadcom.com>
    mmc: sdhci-brcmstb: add cqhci suspend/resume to PM ops

Quentin Schulz <quentin.schulz@cherry.de>
    arm64: dts: rockchip: fix pinmux of UART0 for PX30 Ringneck on Haikou

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    arm64: dts: freescale: imx8mm-verdin-dahlia: add Microphone Jack to sound card

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    arm64: dts: freescale: imx8mp-verdin-dahlia: add Microphone Jack to sound card

Dan Carpenter <dan.carpenter@linaro.org>
    accel/qaic: Fix integer overflow in qaic_validate_req()

Christian Eggers <ceggers@arri.de>
    regulator: check that dummy regulator has been probed before using it

Christian Eggers <ceggers@arri.de>
    regulator: dummy: force synchronous probing

E Shattow <e@freeshell.de>
    riscv: dts: starfive: Fix a typo in StarFive JH7110 pin function definitions

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Don't run jobs that have errors flagged in its fence

Haibo Chen <haibo.chen@nxp.com>
    can: flexcan: disable transceiver during system PM

Haibo Chen <haibo.chen@nxp.com>
    can: flexcan: only change CAN state when link up in system PM

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: ucan: fix out of bound read in strscpy() source

Biju Das <biju.das.jz@bp.renesas.com>
    can: rcar_canfd: Fix page entries in the AFL list

Andreas Kemnade <andreas@kemnade.info>
    i2c: omap: fix IRQ storms

Guillaume Nault <gnault@redhat.com>
    Revert "gre: Fix IPv6 link-local address generation."

Lin Ma <linma@zju.edu.cn>
    net/neighbor: add missing policy for NDTPA_QUEUE_LENBYTES

Justin Iurman <justin.iurman@uliege.be>
    net: lwtunnel: fix recursion loops

Dan Carpenter <dan.carpenter@linaro.org>
    net: atm: fix use after free in lec_send()

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv6: Set errno after ip_fib_metrics_init() in ip6_route_info_create().

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv6: Fix memleak of nhc_pcpu_rth_output in fib_check_nh_v6_gw().

David Lechner <dlechner@baylibre.com>
    ARM: davinci: da850: fix selecting ARCH_DAVINCI_DA8XX

Jeffrey Hugo <quic_jhugo@quicinc.com>
    accel/qaic: Fix possible data corruption in BOs > 2G

Arkadiusz Bokowy <arkadiusz.bokowy@gmail.com>
    Bluetooth: hci_event: Fix connection regression between LE and non-LE adapters

Dan Carpenter <dan.carpenter@linaro.org>
    Bluetooth: Fix error code in chan_alloc_skb_cb()

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix wrong value of max_sge_rd

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix a missing rollback in error path of hns_roce_create_qp_common()

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix unmatched condition in error path of alloc_user_qp_db()

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix soft lockup during bt pages loop

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    RDMA/bnxt_re: Avoid clearing VLAN_ID mask in modify qp path

Phil Elwell <phil@raspberrypi.com>
    ARM: dts: bcm2711: Don't mark timer regs unconfigured

Arnd Bergmann <arnd@arndb.de>
    ARM: OMAP1: select CONFIG_GENERIC_IRQ_CHIP

Qasim Ijaz <qasdev00@gmail.com>
    RDMA/mlx5: Handle errors returned from mlx5r_ib_rate()

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Add missing paranthesis in map_qp_id_to_tbl_indx

Yao Zi <ziyao@disroot.org>
    arm64: dts: rockchip: Remove undocumented sdmmc property from lubancat-1

Phil Elwell <phil@raspberrypi.com>
    ARM: dts: bcm2711: PL011 UARTs are actually r1p5

Peng Fan <peng.fan@nxp.com>
    soc: imx8m: Unregister cpufreq and soc dev in cleanup path

Marek Vasut <marex@denx.de>
    soc: imx8m: Use devm_* to simplify probe failure handling

Marek Vasut <marex@denx.de>
    soc: imx8m: Remove global soc_uid

Cosmin Ratiu <cratiu@nvidia.com>
    xfrm_output: Force software GSO only in tunnel mode

Alexandre Cassen <acassen@corp.free.fr>
    xfrm: fix tunnel mode TX datapath in packet offload mode

Alexander Stein <alexander.stein@ew.tq-group.com>
    arm64: dts: freescale: tqma8mpql: Fix vqmmc-supply

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    firmware: imx-scu: fix OF node leak in .probe()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/broadcom/bcm2711.dtsi            |  11 +-
 arch/arm/boot/dts/nxp/imx/imx6qdl-apalis.dtsi      |  10 +-
 arch/arm/mach-davinci/Kconfig                      |   1 +
 arch/arm/mach-omap1/Kconfig                        |   1 +
 arch/arm/mach-shmobile/headsmp.S                   |   1 +
 .../boot/dts/freescale/imx8mm-verdin-dahlia.dtsi   |   6 +-
 .../arm64/boot/dts/freescale/imx8mp-tqma8mpql.dtsi |  16 +--
 .../boot/dts/freescale/imx8mp-verdin-dahlia.dtsi   |   6 +-
 .../boot/dts/rockchip/px30-ringneck-haikou.dts     |   2 +
 arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts |   2 +-
 arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts |   1 -
 arch/arm64/include/asm/kvm_host.h                  |   7 +-
 arch/arm64/include/asm/kvm_hyp.h                   |   1 +
 arch/arm64/kernel/fpsimd.c                         |  25 ----
 arch/arm64/kvm/arm.c                               |   1 -
 arch/arm64/kvm/fpsimd.c                            |  89 +++---------
 arch/arm64/kvm/hyp/entry.S                         |   5 +
 arch/arm64/kvm/hyp/include/hyp/switch.h            | 106 ++++++++++-----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |  15 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  29 +---
 arch/arm64/kvm/hyp/nvhe/switch.c                   | 112 ++++++++++-----
 arch/arm64/kvm/hyp/vhe/switch.c                    |  13 +-
 arch/arm64/kvm/reset.c                             |   3 +
 arch/riscv/boot/dts/starfive/jh7110-pinfunc.h      |   2 +-
 drivers/accel/qaic/qaic_data.c                     |   9 +-
 drivers/firmware/efi/libstub/randomalloc.c         |   4 +
 drivers/firmware/imx/imx-scu.c                     |   1 +
 drivers/gpu/drm/amd/amdgpu/nv.c                    |  20 +--
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |  20 +--
 drivers/gpu/drm/amd/amdgpu/vi.c                    |  36 ++---
 .../gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c  |  15 ++
 drivers/gpu/drm/radeon/radeon_vce.c                |   2 +-
 drivers/gpu/drm/scheduler/sched_entity.c           |  11 +-
 drivers/gpu/drm/v3d/v3d_sched.c                    |   9 +-
 drivers/i2c/busses/i2c-omap.c                      |  26 +---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   2 -
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h         |   3 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c           |  16 ++-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   2 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |  10 +-
 drivers/infiniband/hw/mlx5/ah.c                    |  14 +-
 drivers/mmc/host/atmel-mci.c                       |   4 +-
 drivers/mmc/host/sdhci-brcmstb.c                   |  10 ++
 drivers/net/can/flexcan/flexcan-core.c             |  18 ++-
 drivers/net/can/rcar/rcar_canfd.c                  |  28 ++--
 drivers/net/can/usb/ucan.c                         |  43 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  10 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  37 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  28 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |   3 +-
 drivers/regulator/core.c                           |  12 +-
 drivers/regulator/dummy.c                          |   2 +-
 drivers/soc/imx/soc-imx8m.c                        | 151 ++++++++++-----------
 drivers/soc/qcom/pdr_interface.c                   |   8 +-
 fs/btrfs/tree-checker.c                            |  30 ++--
 fs/btrfs/tree-checker.h                            |   1 +
 fs/proc/generic.c                                  |  10 +-
 fs/proc/inode.c                                    |   6 +-
 fs/proc/internal.h                                 |  14 ++
 fs/smb/server/smbacl.c                             |   5 +-
 include/linux/proc_fs.h                            |   7 +-
 include/net/bluetooth/hci.h                        |   2 +-
 kernel/sched/core.c                                |  22 +--
 mm/filemap.c                                       |  13 +-
 mm/migrate.c                                       |  10 +-
 net/atm/lec.c                                      |   3 +-
 net/batman-adv/bat_iv_ogm.c                        |   3 +-
 net/batman-adv/bat_v_ogm.c                         |   3 +-
 net/bluetooth/6lowpan.c                            |   7 +-
 net/core/lwtunnel.c                                |  65 +++++++--
 net/core/neighbour.c                               |   1 +
 net/ipv6/addrconf.c                                |  15 +-
 net/ipv6/route.c                                   |   5 +-
 net/mptcp/options.c                                |   6 +-
 net/netfilter/nft_counter.c                        |  90 ++++++------
 net/xdp/xsk_buff_pool.c                            |   2 +-
 net/xfrm/xfrm_output.c                             |  43 +++++-
 80 files changed, 799 insertions(+), 600 deletions(-)


