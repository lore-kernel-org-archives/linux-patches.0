Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5238E55B;
	Tue, 25 Mar 2025 12:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905903; cv=none; b=nKkDaPOVhXRRz6uNzIp7dWUYjKwejQxWmovYfc2EgVTfDoLNCxrWpEY+8GvzD57icZC9759Sx5mgadzueTendrt+l4Pe/yHf6qWFogJP0i9gDWCcKk/ac5i/i+B76qTffZTj+Vl+fDHHFudyjOC6/olUrl+ae99XkaAJqKzkov4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905903; c=relaxed/simple;
	bh=BLS3C9BQsZM6oZ6LWax/ituF9yyqB6mvONm7l2h6Ot0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DYXClU5pLCMRSaRi2o0LVK50GiRD8uQj6Xy6pYQnyCkjIR8T39mJqGK2KSMFgO/PT3rTXq+4zAGjZ2JocJyV4q3ef5B1POFxWeMltPKhMkZa8D+Jkj5YKd2dHGTEhKuSMxzCTlgbqgNbM/fru0Ta2f80yiLhBdn1AZKxIOqSpOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bzp3415B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bzp3415B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B49C4CEE4;
	Tue, 25 Mar 2025 12:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905903;
	bh=BLS3C9BQsZM6oZ6LWax/ituF9yyqB6mvONm7l2h6Ot0=;
	h=From:To:Cc:Subject:Date:From;
	b=Bzp3415B7I42+oiWc3T76RpMjKU+6eOI+92DNYDscAhnEHA/HRFDM1dEsVHRGkYc1
	 s7B3cKfCOD/0hEunQ6AOMdv7Z35gYbU2mGm5MhG7nwO7XNlc6cVck5Ic2L0RX16xHM
	 3pBeEZYm+nNoaNgn0Eod3EEH82bWcn2kZ3D0gVpk=
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
Subject: [PATCH 6.13 000/119] 6.13.9-rc1 review
Date: Tue, 25 Mar 2025 08:20:58 -0400
Message-ID: <20250325122149.058346343@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.9-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.13.9-rc1
X-KernelTest-Deadline: 2025-03-27T12:21+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.13.9 release.
There are 119 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 27 Mar 2025 12:21:27 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.9-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.13.9-rc1

Arthur Mongodin <amongodin@randorisec.fr>
    mptcp: Fix data stream corruption in the address announcement

Dietmar Eggemann <dietmar.eggemann@arm.com>
    Revert "sched/core: Reduce cost of sched_move_task when config autogroup"

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

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/net: fix sendzc double notif flush

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix incorrect validation for num_aces field of smb_acl

Jay Cornwall <jay.cornwall@amd.com>
    drm/amdkfd: Fix instruction hazard in gfx12 trap handler

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Fix user queue validation on Gfx7/8

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Fix JPEG video caps max size for navi1x and raven

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Fix MPEG2, MPEG4 and VC1 video caps max size

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Remove JPEG from vega and carrizo video caps

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/pm: wire up hwmon fan speed for smu 14.0.2

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    drm/amdgpu/pm: Handle SCLK offset correctly in overdrive for smu 14.0.2

David Belanger <david.belanger@amd.com>
    drm/amdgpu: Restore uncached behaviour on GFX12

Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
    drm/amd/pm: add unique_id for gfx12

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Use HW lock mgr for PSR1 when only one eDP

Yilin Chen <Yilin.Chen@amd.com>
    drm/amd/display: Fix message for support_edp0_on_dp1

Wentao Liang <vulab@iscas.ac.cn>
    drm/amdgpu/gfx12: correct cleanup of 'me' field with gfx_v12_0_me_fini()

qianyi liu <liuqianyi125@gmail.com>
    drm/sched: Fix fence reference count leak

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    drm/radeon: fix uninitialized size issue in radeon_vce_cs_parse()

Xianwei Zhao <xianwei.zhao@amlogic.com>
    pmdomain: amlogic: fix T7 ISP secpower

Saranya R <quic_sarar@quicinc.com>
    soc: qcom: pdr: Fix the potential deadlock

Sven Eckelmann <sven@narfation.org>
    batman-adv: Ignore own maximum aggregation size during RX

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    xsk: fix an integer overflow in xp_create_and_assign_umem()

David Howells <dhowells@redhat.com>
    keys: Fix UAF in key_put()

Ard Biesheuvel <ardb@kernel.org>
    efi/libstub: Avoid physical address 0x0 when doing random allocation

Johan Hovold <johan+linaro@kernel.org>
    firmware: qcom: uefisecapp: fix efivars registration race

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: shmobile: smp: Enforce shmobile_smp_* alignment

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    ARM: dts: imx6qdl-apalis: Fix poweroff on Apalis iMX6

Shakeel Butt <shakeel.butt@linux.dev>
    memcg: drain obj stock on cpu hotplug teardown

Ye Bin <yebin10@huawei.com>
    proc: fix UAF in proc_get_inode()

Zi Yan <ziy@nvidia.com>
    mm/huge_memory: drop beyond-EOF folios with the right number of refs

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    mm/page_alloc: fix memory accept before watermarks gets initialized

Zi Yan <ziy@nvidia.com>
    mm/migrate: fix shmem xarray update during migration

Raphael S. Carvalho <raphaelsc@scylladb.com>
    mm: fix error handling in __filemap_get_folio() with FGP_NOWAIT

Rafael Aquini <raquini@redhat.com>
    selftests/mm: run_vmtests.sh: fix half_ufd_size_MB calculation

Gu Bowen <gubowen5@huawei.com>
    mmc: atmel-mci: Add missing clk_disable_unprepare()

Kamal Dasu <kamal.dasu@broadcom.com>
    mmc: sdhci-brcmstb: add cqhci suspend/resume to PM ops

Dragan Simic <dsimic@manjaro.org>
    arm64: dts: rockchip: Add missing PCIe supplies to RockPro64 board dtsi

Dragan Simic <dsimic@manjaro.org>
    arm64: dts: rockchip: Add avdd HDMI supplies to RockPro64 board dtsi

Justin Klaassen <justin@tidylabs.net>
    arm64: dts: rockchip: fix u2phy1_host status for NanoPi R4S

Quentin Schulz <quentin.schulz@cherry.de>
    arm64: dts: rockchip: fix pinmux of UART5 for PX30 Ringneck on Haikou

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

Max Kellermann <max.kellermann@ionos.com>
    netfs: Call `invalidate_cache` only if implemented

E Shattow <e@freeshell.de>
    riscv: dts: starfive: Fix a typo in StarFive JH7110 pin function definitions

Jens Axboe <axboe@kernel.dk>
    io_uring/net: don't clear REQ_F_NEED_CLEANUP unconditionally

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Don't run jobs that have errors flagged in its fence

Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>
    drm/xe: Fix exporting xe buffers multiple times

Haibo Chen <haibo.chen@nxp.com>
    can: flexcan: disable transceiver during system PM

Haibo Chen <haibo.chen@nxp.com>
    can: flexcan: only change CAN state when link up in system PM

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: ucan: fix out of bound read in strscpy() source

Biju Das <biju.das.jz@bp.renesas.com>
    can: rcar_canfd: Fix page entries in the AFL list

Biju Das <biju.das.jz@bp.renesas.com>
    dt-bindings: can: renesas,rcar-canfd: Fix typo in pattern properties for R-Car V4M

Haiyang Zhang <haiyangz@microsoft.com>
    net: mana: Support holes in device list reply msg

Andreas Kemnade <andreas@kemnade.info>
    i2c: omap: fix IRQ storms

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: tprobe-events: Fix leakage of module refcount

Hans Verkuil <hverkuil@xs4all.nl>
    media: rtl2832_sdr: assign vb2 lock before vb2_queue_init

Guillaume Nault <gnault@redhat.com>
    Revert "gre: Fix IPv6 link-local address generation."

Lin Ma <linma@zju.edu.cn>
    net/neighbor: add missing policy for NDTPA_QUEUE_LENBYTES

Yongjian Sun <sunyongjian1@huawei.com>
    libfs: Fix duplicate directory entry in offset_dir_lookup

Justin Iurman <justin.iurman@uliege.be>
    net: ipv6: ioam6: fix lwtunnel_output() loop

Justin Iurman <justin.iurman@uliege.be>
    net: lwtunnel: fix recursion loops

MD Danish Anwar <danishanwar@ti.com>
    net: ti: icssg-prueth: Add lock to stats

Dan Carpenter <dan.carpenter@linaro.org>
    net: atm: fix use after free in lec_send()

Jason Gunthorpe <jgg@ziepe.ca>
    gpu: host1x: Do not assume that a NULL domain means no DMA IOMMU

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    phy: fix xa_alloc_cyclic() error handling

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    dpll: fix xa_alloc_cyclic() error handling

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    devlink: fix xa_alloc_cyclic() error handling

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv6: Set errno after ip_fib_metrics_init() in ip6_route_info_create().

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv6: Fix memleak of nhc_pcpu_rth_output in fib_check_nh_v6_gw().

Felix Fietkau <nbd@nbd.name>
    net: ipv6: fix TCP GSO segmentation with NAT

Vignesh Raghavendra <vigneshr@ti.com>
    net: ethernet: ti: am65-cpsw: Fix NAPI registration sequence

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Add ATA_QUIRK_NO_LPM_ON_ATI for certain Samsung SSDs

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: tprobe-events: Fix to clean up tprobe correctly when module unload

David Lechner <dlechner@baylibre.com>
    ARM: davinci: da850: fix selecting ARCH_DAVINCI_DA8XX

Huisong Li <lihuisong@huawei.com>
    soc: hisilicon: kunpeng_hccs: Fix incorrect string assembly

Jeffrey Hugo <quic_jhugo@quicinc.com>
    accel/qaic: Fix possible data corruption in BOs > 2G

Arkadiusz Bokowy <arkadiusz.bokowy@gmail.com>
    Bluetooth: hci_event: Fix connection regression between LE and non-LE adapters

Dan Carpenter <dan.carpenter@linaro.org>
    Bluetooth: Fix error code in chan_alloc_skb_cb()

Horatiu Vultur <horatiu.vultur@microchip.com>
    reset: mchp: sparx5: Fix for lan966x

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix wrong value of max_sge_rd

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix missing xa_destroy()

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix a missing rollback in error path of hns_roce_create_qp_common()

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix invalid sq params not being blocked

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix unmatched condition in error path of alloc_user_qp_db()

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix soft lockup during bt pages loop

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    RDMA/bnxt_re: Avoid clearing VLAN_ID mask in modify qp path

Baochen Qiang <quic_bqiang@quicinc.com>
    dma-mapping: fix missing clear bdr in check_ram_in_range_map()

Chester A. Unal <chester.a.unal@arinc9.com>
    ARM: dts: BCM5301X: Fix switch port labels of ASUS RT-AC3200

Chester A. Unal <chester.a.unal@arinc9.com>
    ARM: dts: BCM5301X: Fix switch port labels of ASUS RT-AC5300

Phil Elwell <phil@raspberrypi.com>
    ARM: dts: bcm2711: Don't mark timer regs unconfigured

Arnd Bergmann <arnd@arndb.de>
    ARM: OMAP1: select CONFIG_GENERIC_IRQ_CHIP

Qasim Ijaz <qasdev00@gmail.com>
    RDMA/mlx5: Handle errors returned from mlx5r_ib_rate()

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Add missing paranthesis in map_qp_id_to_tbl_indx

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix the failure of ibv_query_device() and ibv_query_device_ex() tests

Yao Zi <ziyao@disroot.org>
    arm64: dts: rockchip: Remove undocumented sdmmc property from lubancat-1

Phil Elwell <phil@raspberrypi.com>
    arm64: dts: bcm2712: PL011 UARTs are actually r1p5

Phil Elwell <phil@raspberrypi.com>
    ARM: dts: bcm2711: PL011 UARTs are actually r1p5

Stefan Wahren <wahrenst@gmx.net>
    ARM: dts: bcm2711: Fix xHCI power-domain

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    Revert "arm64: dts: qcom: sdm845: Affirm IDR0.CCTW on apps_smmu"

Peng Fan <peng.fan@nxp.com>
    soc: imx8m: Unregister cpufreq and soc dev in cleanup path

Cosmin Ratiu <cratiu@nvidia.com>
    xfrm_output: Force software GSO only in tunnel mode

Alexandre Cassen <acassen@corp.free.fr>
    xfrm: fix tunnel mode TX datapath in packet offload mode

Heiko Stuebner <heiko.stuebner@cherry.de>
    arm64: dts: rockchip: remove supports-cqe from rk3588 tiger

Heiko Stuebner <heiko.stuebner@cherry.de>
    arm64: dts: rockchip: remove supports-cqe from rk3588 jaguar

Alexander Stein <alexander.stein@ew.tq-group.com>
    arm64: dts: freescale: tqma8mpql: Fix vqmmc-supply

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    firmware: imx-scu: fix OF node leak in .probe()

Dan Carpenter <dan.carpenter@linaro.org>
    firmware: qcom: scm: Fix error code in probe()


-------------

Diffstat:

 .../bindings/net/can/renesas,rcar-canfd.yaml       |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/broadcom/bcm2711-rpi.dtsi        |   5 -
 arch/arm/boot/dts/broadcom/bcm2711.dtsi            |  12 +-
 .../boot/dts/broadcom/bcm4709-asus-rt-ac3200.dts   |  12 +-
 .../boot/dts/broadcom/bcm47094-asus-rt-ac5300.dts  |   8 +-
 arch/arm/boot/dts/nxp/imx/imx6qdl-apalis.dtsi      |  10 +-
 arch/arm/mach-davinci/Kconfig                      |   1 +
 arch/arm/mach-omap1/Kconfig                        |   1 +
 arch/arm/mach-shmobile/headsmp.S                   |   1 +
 arch/arm64/boot/dts/broadcom/bcm2712.dtsi          |   2 +-
 .../boot/dts/freescale/imx8mm-verdin-dahlia.dtsi   |   6 +-
 .../arm64/boot/dts/freescale/imx8mp-tqma8mpql.dtsi |  16 +-
 .../boot/dts/freescale/imx8mp-verdin-dahlia.dtsi   |   6 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |   1 -
 .../boot/dts/rockchip/px30-ringneck-haikou.dts     |  12 +
 .../arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dtsi |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi |  14 +
 arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts |   1 -
 arch/arm64/boot/dts/rockchip/rk3588-jaguar.dts     |   1 -
 arch/arm64/boot/dts/rockchip/rk3588-tiger.dtsi     |   1 -
 arch/arm64/include/asm/kvm_host.h                  |  23 +-
 arch/arm64/kernel/fpsimd.c                         |  25 -
 arch/arm64/kvm/arm.c                               |   9 -
 arch/arm64/kvm/fpsimd.c                            | 100 +--
 arch/arm64/kvm/hyp/entry.S                         |   5 +
 arch/arm64/kvm/hyp/include/hyp/switch.h            | 133 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |  11 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  30 -
 arch/arm64/kvm/hyp/nvhe/switch.c                   | 140 ++--
 arch/arm64/kvm/hyp/vhe/switch.c                    |  21 +-
 arch/riscv/boot/dts/starfive/jh7110-pinfunc.h      |   2 +-
 drivers/accel/qaic/qaic_data.c                     |   9 +-
 drivers/ata/libata-core.c                          |  14 +-
 drivers/dpll/dpll_core.c                           |   2 +-
 drivers/firmware/efi/libstub/randomalloc.c         |   4 +
 drivers/firmware/imx/imx-scu.c                     |   1 +
 drivers/firmware/qcom/qcom_qseecom_uefisecapp.c    |  18 +-
 drivers/firmware/qcom/qcom_scm.c                   |   4 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c             |  22 +-
 drivers/gpu/drm/amd/amdgpu/nv.c                    |  20 +-
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |  21 +-
 drivers/gpu/drm/amd/amdgpu/vi.c                    |  43 +-
 drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler.h     | 703 +++++++++++----------
 .../gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx12.asm |  82 +--
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c             |  12 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |   8 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   2 +-
 .../gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c  |  11 +
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |   2 +
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c   |  96 +--
 drivers/gpu/drm/radeon/radeon_vce.c                |   2 +-
 drivers/gpu/drm/scheduler/sched_entity.c           |  11 +-
 drivers/gpu/drm/v3d/v3d_sched.c                    |   9 +-
 drivers/gpu/drm/xe/xe_bo.h                         |   2 -
 drivers/gpu/drm/xe/xe_dma_buf.c                    |   2 +-
 drivers/gpu/host1x/dev.c                           |   6 +
 drivers/i2c/busses/i2c-omap.c                      |  26 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   2 -
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h         |   3 +-
 drivers/infiniband/hw/hns/hns_roce_alloc.c         |   4 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c            |   1 +
 drivers/infiniband/hw/hns/hns_roce_hem.c           |  16 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   2 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |  20 +-
 drivers/infiniband/hw/mlx5/ah.c                    |  14 +-
 drivers/infiniband/sw/rxe/rxe.c                    |  25 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |   2 +-
 drivers/mmc/host/atmel-mci.c                       |   4 +-
 drivers/mmc/host/sdhci-brcmstb.c                   |  10 +
 drivers/net/can/flexcan/flexcan-core.c             |  18 +-
 drivers/net/can/rcar/rcar_canfd.c                  |  28 +-
 drivers/net/can/usb/ucan.c                         |  43 +-
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |  14 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  32 +-
 drivers/net/ethernet/ti/icssg/icssg_prueth.c       |   1 +
 drivers/net/ethernet/ti/icssg/icssg_prueth.h       |   2 +
 drivers/net/ethernet/ti/icssg/icssg_stats.c        |   4 +
 drivers/net/phy/phy_link_topology.c                |   2 +-
 drivers/pmdomain/amlogic/meson-secure-pwrc.c       |   2 +-
 drivers/regulator/core.c                           |  12 +-
 drivers/regulator/dummy.c                          |   2 +-
 drivers/reset/reset-microchip-sparx5.c             |  19 +-
 drivers/soc/hisilicon/kunpeng_hccs.c               |   4 +-
 drivers/soc/imx/soc-imx8m.c                        |  26 +-
 drivers/soc/qcom/pdr_interface.c                   |   8 +-
 fs/libfs.c                                         |   2 +-
 fs/netfs/write_collect.c                           |   3 +-
 fs/proc/generic.c                                  |  10 +-
 fs/proc/inode.c                                    |   6 +-
 fs/proc/internal.h                                 |  14 +
 fs/smb/server/smbacl.c                             |   5 +-
 include/linux/key.h                                |   1 +
 include/linux/libata.h                             |   2 +
 include/linux/proc_fs.h                            |   7 +-
 include/net/bluetooth/hci.h                        |   2 +-
 include/net/mana/gdma.h                            |  11 +-
 io_uring/net.c                                     |   5 +-
 kernel/dma/direct.c                                |  28 +-
 kernel/sched/core.c                                |  21 +-
 kernel/trace/trace_fprobe.c                        |  30 +-
 mm/filemap.c                                       |  13 +-
 mm/huge_memory.c                                   |   2 +-
 mm/memcontrol.c                                    |   9 +
 mm/migrate.c                                       |  10 +-
 mm/page_alloc.c                                    |  14 +-
 net/atm/lec.c                                      |   3 +-
 net/batman-adv/bat_iv_ogm.c                        |   3 +-
 net/batman-adv/bat_v_ogm.c                         |   3 +-
 net/bluetooth/6lowpan.c                            |   7 +-
 net/core/lwtunnel.c                                |  65 +-
 net/core/neighbour.c                               |   1 +
 net/devlink/core.c                                 |   2 +-
 net/ipv6/addrconf.c                                |  15 +-
 net/ipv6/ioam6_iptunnel.c                          |   8 +-
 net/ipv6/route.c                                   |   5 +-
 net/ipv6/tcpv6_offload.c                           |  21 +-
 net/mptcp/options.c                                |   6 +-
 net/xdp/xsk_buff_pool.c                            |   2 +-
 net/xfrm/xfrm_output.c                             |  43 +-
 security/keys/gc.c                                 |   4 +-
 security/keys/key.c                                |   2 +
 tools/testing/selftests/mm/run_vmtests.sh          |   4 +-
 124 files changed, 1344 insertions(+), 1116 deletions(-)


