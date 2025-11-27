Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB2828CF42;
	Thu, 27 Nov 2025 14:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255166; cv=none; b=NGjN5Mt8wfp7UJqlvTPTuth+G8ys+YBoCJmrAmRVQvZieOMOZxHYwKvYNMg0n+9LT6R7qDkhvGZSDltC/LdA1eQpp3a/9ZaDCvi/ewEL3d+Wa94NNs01m6s7H2OUn/nB5TNzqfXSmS8Aptk17Gpzw/RTV9duI2SWvuA4IR2n/7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255166; c=relaxed/simple;
	bh=pbkMGgB4IW9YyeRG7rxxqq1vyXuVqGsBvIjZrA2zZvc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=f7faVF//IAEdk2stCF9Y0GYScgIxJjvDpoN25f4r5QkNO+0iYTGi9SLGLT7EsamHgOaIZdz5efomCqT2eRzHiEWOB222yLH8HU4FfP/06M3pNTvDonrsxTYco6dXDEtpzy+xJz/42cb5UflwAbSg9qBixkcpL7Q9IKAzKLp5ajQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NY9PYwZM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NY9PYwZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A8DC4CEF8;
	Thu, 27 Nov 2025 14:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255166;
	bh=pbkMGgB4IW9YyeRG7rxxqq1vyXuVqGsBvIjZrA2zZvc=;
	h=From:To:Cc:Subject:Date:From;
	b=NY9PYwZM/pior7hef09MaVSs5Fj+jgRI3QXBm9L5J3IODk+eKatQwlydH2UkMy+4d
	 ce8RDif6JLdSajXLTzwrKY4oPq7gBAumhcIibiTkZcBM+orL4JrYcmneXTcEKg3nsC
	 kHf7rak/ek90cKcCN2PtAhAJSXr2jKcIhQExsLZE=
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.12 000/112] 6.12.60-rc1 review
Date: Thu, 27 Nov 2025 15:45:02 +0100
Message-ID: <20251127144032.705323598@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.60-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.60-rc1
X-KernelTest-Deadline: 2025-11-29T14:40+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.60 release.
There are 112 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 29 Nov 2025 14:40:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.60-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.60-rc1

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Prevent Gating DTBCLK before It Is Properly Latched

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: Insert dccg log for easy debug

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: disable DPP RCG before DPP CLK enable

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: avoid reset DTBCLK at clock init

Darrick J. Wong <djwong@kernel.org>
    xfs: fix out of bounds memory read error in symlink repair

Marcelo Moreira <marcelomoreira1905@gmail.com>
    xfs: Replace strncpy with memcpy

Eric Dumazet <edumazet@google.com>
    mptcp: fix a race in mptcp_pm_del_add_timer()

Imre Deak <imre.deak@intel.com>
    drm/i915/dp_mst: Disable Panel Replay

Martin Kaiser <martin@kaiser.cx>
    maple_tree: fix tracepoint string pointers

Jari Ruusu <jariruusu@protonmail.com>
    tty/vt: fix up incorrect backport to stable releases

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: fix incomplete backport in cfids_invalidation_worker()

Samuel Zhang <guoqing.zhang@amd.com>
    drm/amdgpu: fix gpu page fault after hibernation on PF passthrough

Zhang Chujun <zhangchujun@cmss.chinamobile.com>
    tracing/tools: Fix incorrcet short option in usage text for --threads

Nishanth Menon <nm@ti.com>
    net: ethernet: ti: netcp: Standardize knav_dma_open_channel to return NULL on error

René Rebe <rene@exactco.de>
    ALSA: usb-audio: fix uac2 clock source at terminal parser

Heiko Carstens <hca@linux.ibm.com>
    s390/mm: Fix __ptep_rdp() inline assembly

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe: Prevent BIT() overflow when handling invalid prefetch region

Wentao Guan <guanwentao@uniontech.com>
    Revert "RDMA/irdma: Update Kconfig"

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Make all 32bit ID registers fully writable

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix missing unlock at error path of maxpacksize check

Jakub Horký <jakub.git@horky.net>
    kconfig/nconf: Initialize the default locale at startup

Jakub Horký <jakub.git@horky.net>
    kconfig/mconf: Initialize the default locale at startup

Shahar Shitrit <shshitrit@nvidia.com>
    net: tls: Cancel RX async resync request on rcd_delta overflow

Carlos Llamas <cmllamas@google.com>
    blk-crypto: use BLK_STS_INVAL for alignment errors

Shahar Shitrit <shshitrit@nvidia.com>
    net: tls: Change async resync helpers argument

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests: net: use BASH for bareudp testing

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Limit Entrysign signature checking to known generations

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Fix a regression triggered by scsi_host_busy()

Steve French <stfrench@microsoft.com>
    cifs: fix typo in enable_gcm_256 module parameter

Rafał Miłecki <rafal@milecki.pl>
    bcma: don't register devices disabled in OF

Michal Luczaj <mhal@rbox.co>
    vsock: Ignore signal/timeout on connect() if already established

Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
    cifs: fix memory leak in smb3_fs_context_parse_param error path

Thomas Weißschuh <linux@weissschuh.net>
    LoongArch: Use UAPI types in ptrace UAPI header

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Read sk_peek_offset() again after sleeping in unix_stream_read_generic().

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Cache state->msg in unix_stream_read_generic().

Pradyumn Rahar <pradyumn.rahar@oracle.com>
    net/mlx5: Clean up only new IRQ glue on request_irq() failure

Shay Drory <shayd@nvidia.com>
    devlink: rate: Unset parent pointer in devl_rate_nodes_destroy

Jared Kangas <jkangas@redhat.com>
    pinctrl: s32cc: initialize gpio_pin_config::list after kmalloc()

Jared Kangas <jkangas@redhat.com>
    pinctrl: s32cc: fix uninitialized memory in s32_pinctrl_desc

Grzegorz Nitka <grzegorz.nitka@intel.com>
    ice: fix PTP cleanup on driver removal in error path

Emil Tantilov <emil.s.tantilov@intel.com>
    idpf: fix possible vport_config NULL pointer deref in remove

Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
    net: qlogic/qede: fix potential out-of-bounds read in qede_tpa_cont() and qede_tpa_end()

Haotian Zhang <vulab@iscas.ac.cn>
    platform/x86/intel/speed_select_if: Convert PCIBIOS_* return codes to errnos

Ido Schimmel <idosch@nvidia.com>
    selftests: net: lib: Do not overwrite error messages

Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
    s390/ctcm: Fix double-kfree

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    nvme-multipath: fix lockdep WARN due to partition scan work

Chen Pei <cp0613@linux.alibaba.com>
    tools: riscv: Fixed misalignment of CSR related definitions

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: remove never-working support for setting nsh fields

Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
    net: mlxsw: linecards: fix missing error check in mlxsw_linecard_devlink_info_get()

Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
    net: dsa: hellcreek: fix missing error handling in LED registration

Prateek Agarwal <praagarwal@nvidia.com>
    drm/tegra: Add call to put_pid()

Zilin Guan <zilin@seu.edu.cn>
    mlxsw: spectrum: Fix memory leak in mlxsw_sp_flower_stats()

Armin Wolf <W_Armin@gmx.de>
    platform/x86: msi-wmi-platform: Fix typo in WMI GUID

Armin Wolf <W_Armin@gmx.de>
    platform/x86: msi-wmi-platform: Only load on MSI devices

Haotian Zhang <vulab@iscas.ac.cn>
    pinctrl: cirrus: Fix fwnode leak in cs42l43_pin_probe()

Jianbo Liu <jianbol@nvidia.com>
    xfrm: Prevent locally generated packets from direct output in tunnel mode

Jianbo Liu <jianbol@nvidia.com>
    xfrm: Determine inner GSO type from packet inner protocol

Yu-Chun Lin <eleanor.lin@realtek.com>
    pinctrl: realtek: Select REGMAP_MMIO for RTD driver

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: set err and extack on failure to create pcpu SA

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: drop SA reference in xfrm_state_update if dir doesn't match

Ivan Lipski <ivan.lipski@amd.com>
    drm/amd/display: Clear the CUR_ENABLE register on DCN20 on DPP5

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Fix pbn to kbps Conversion

Mario Limonciello (AMD) <superm1@kernel.org>
    drm/amd/display: Move sleep into each retry for retrieve_link_cap()

Mario Limonciello (AMD) <superm1@kernel.org>
    drm/amd/display: Increase DPCD read retries

Yifan Zha <Yifan.Zha@amd.com>
    drm/amdgpu: Skip emit de meta data on gfx11 with rs64 enabled

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Skip power ungate during suspend for VPE

Robert McClinton <rbmccav@gmail.com>
    drm/radeon: delete radeon_fence_process in is_signaled, no deadlock

Ma Ke <make24@iscas.ac.cn>
    drm/tegra: dc: Fix reference leak in tegra_dc_couple()

Paolo Abeni <pabeni@redhat.com>
    mptcp: do not fallback when OoO is present

Paolo Abeni <pabeni@redhat.com>
    mptcp: decouple mptcp fastclose from tcp close

Paolo Abeni <pabeni@redhat.com>
    mptcp: avoid unneeded subflow-level drops

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: userspace: longer timeout

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: endpoints: longer timeout

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix premature close in case of fallback

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix duplicate reset on fastclose

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix ack generation for fallback msk

Eric Dumazet <edumazet@google.com>
    mptcp: fix race condition in mptcp_schedule_work()

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Don't panic if no valid cache info for PCI

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: pinctrl: toshiba,visconti: Fix number of items in groups

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Malta: Fix !EVA SOC-it PCI MMIO

Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
    scsi: target: tcm_loop: Fix segfault in tcm_loop_tpg_address_show()

Bart Van Assche <bvanassche@acm.org>
    scsi: sg: Do not sleep in atomic context

Ewan D. Milne <emilne@redhat.com>
    nvme: nvme-fc: Ensure ->ioerr_work is cancelled in nvme_fc_delete_ctrl()

Ewan D. Milne <emilne@redhat.com>
    nvme: nvme-fc: move tagset removal to nvme_fc_delete_ctrl()

Nam Cao <namcao@linutronix.de>
    nouveau/firmware: Add missing kfree() of nvkm_falcon_fw::boot

Vlastimil Babka <vbabka@suse.cz>
    mm/mempool: fix poisoning order>0 pages with HIGHMEM

Seungjin Bae <eeodqql09@gmail.com>
    Input: pegasus-notetaker - fix potential out-of-bounds access

Dan Carpenter <dan.carpenter@linaro.org>
    Input: imx_sc_key - fix memory corruption on unload

Hans de Goede <hdegoede@redhat.com>
    Input: goodix - add support for ACPI ID GDIX1003

Tzung-Bi Shih <tzungbi@kernel.org>
    Input: cros_ec_keyb - fix an invalid memory access

Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
    Revert "drm/tegra: dsi: Clear enable register if powered by bootloader"

Oleksij Rempel <o.rempel@pengutronix.de>
    net: dsa: microchip: lan937x: Fix RGMII delay tuning

Andrey Vatoropin <a.vatoropin@crpt.ru>
    be2net: pass wrb_params in case of OS2BMC

Yihang Li <liyihang9@h-partners.com>
    ata: libata-scsi: Add missing scsi_device_put() in ata_scsi_dev_rescan()

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: introduce close_cached_dir_locked()

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: mm: Prevent a TLB shutdown on initial uniquification

Niklas Cassel <cassel@kernel.org>
    ata: libata-scsi: Fix system suspend for a security locked drive

Jiayuan Chen <jiayuan.chen@linux.dev>
    mptcp: Fix proto fallback detection with BPF

Jiayuan Chen <jiayuan.chen@linux.dev>
    mptcp: Disallow MPTCP subflows from sockmap

Yongpeng Yang <yangyongpeng@xiaomi.com>
    exfat: check return value of sb_min_blocksize in exfat_read_boot_sector

Mike Yuan <me@yhndnzj.com>
    shmem: fix tmpfs reconfiguration (remount) when noswap is set

Yongpeng Yang <yangyongpeng@xiaomi.com>
    isofs: check the return value of sb_min_blocksize() in isofs_fill_super

Dan Carpenter <dan.carpenter@linaro.org>
    mtdchar: fix integer overflow in read/write ioctls

Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
    mtd: rawnand: cadence: fix DMA device NULL pointer dereference

Quentin Schulz <quentin.schulz@cherry.de>
    arm64: dts: rockchip: disable HS400 on RK3588 Tiger

Quentin Schulz <quentin.schulz@cherry.de>
    arm64: dts: rockchip: include rk3399-base instead of rk3399 in rk3399-op1

Mykola Kvach <xakep.amatop@gmail.com>
    arm64: dts: rockchip: fix PCIe 3.3V regulator voltage on orangepi-5

Diederik de Haas <diederik@cknow-tech.com>
    arm64: dts: rockchip: Fix vccio4-supply on rk3566-pinetab2

Zhang Heng <zhangheng@kylinos.cn>
    HID: quirks: work around VID/PID conflict for 0x4c4a/0x4155

Mario Limonciello (AMD) <superm1@kernel.org>
    HID: amd_sfh: Stop sensor before starting

Yipeng Zou <zouyipeng@huawei.com>
    timers: Fix NULL function pointer race in timer_shutdown_sync()

Sebastian Ene <sebastianene@google.com>
    KVM: arm64: Check the untrusted offset in FF-A memory share


-------------

Diffstat:

 .../bindings/pinctrl/toshiba,visconti-pinctrl.yaml |  26 +++---
 Documentation/wmi/driver-development-guide.rst     |   1 +
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/rockchip/rk3399-op1.dtsi       |   2 +-
 arch/arm64/boot/dts/rockchip/rk3566-pinetab2.dtsi  |   2 +-
 arch/arm64/boot/dts/rockchip/rk3588-tiger.dtsi     |   4 +-
 .../arm64/boot/dts/rockchip/rk3588s-orangepi-5.dts |   4 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c                      |   9 +-
 arch/arm64/kvm/sys_regs.c                          |  63 +++++++------
 arch/loongarch/include/uapi/asm/ptrace.h           |  40 ++++----
 arch/loongarch/pci/pci.c                           |   8 +-
 arch/mips/mm/tlb-r4k.c                             | 102 +++++++++++++--------
 arch/mips/mti-malta/malta-init.c                   |  20 ++--
 arch/s390/include/asm/pgtable.h                    |  12 +--
 arch/s390/mm/pgtable.c                             |   4 +-
 arch/x86/kernel/cpu/microcode/amd.c                |  20 +++-
 block/blk-crypto.c                                 |   2 +-
 drivers/ata/libata-scsi.c                          |  11 ++-
 drivers/bcma/main.c                                |   6 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   3 +-
 drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c         |   3 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c            |   4 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  59 +++++-------
 .../amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c   |  20 ++--
 .../gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c |  60 ++++++++----
 .../drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c    |   8 ++
 .../drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c    |  21 +++--
 .../display/dc/link/protocols/link_dp_capability.c |  11 ++-
 drivers/gpu/drm/i915/display/intel_psr.c           |   4 +
 drivers/gpu/drm/nouveau/nvkm/falcon/fw.c           |   2 +
 drivers/gpu/drm/radeon/radeon_fence.c              |   7 --
 drivers/gpu/drm/tegra/dc.c                         |   1 +
 drivers/gpu/drm/tegra/dsi.c                        |   9 --
 drivers/gpu/drm/tegra/uapi.c                       |   7 +-
 drivers/gpu/drm/xe/xe_vm.c                         |   4 +-
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c      |   2 +
 drivers/hid/hid-ids.h                              |   4 +-
 drivers/hid/hid-quirks.c                           |  13 ++-
 drivers/infiniband/hw/irdma/Kconfig                |   7 +-
 drivers/input/keyboard/cros_ec_keyb.c              |   6 ++
 drivers/input/keyboard/imx_sc_key.c                |   2 +-
 drivers/input/tablet/pegasus_notetaker.c           |   9 ++
 drivers/input/touchscreen/goodix.c                 |   1 +
 drivers/mtd/mtdchar.c                              |   6 +-
 drivers/mtd/nand/raw/cadence-nand-controller.c     |   3 +-
 drivers/net/dsa/hirschmann/hellcreek_ptp.c         |  14 ++-
 drivers/net/dsa/microchip/lan937x_main.c           |   1 +
 drivers/net/ethernet/emulex/benet/be_main.c        |   7 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           |  22 ++++-
 drivers/net/ethernet/intel/idpf/idpf_main.c        |   2 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |   6 +-
 .../net/ethernet/mellanox/mlxsw/core_linecards.c   |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |   6 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   5 +-
 drivers/net/ethernet/ti/netcp_core.c               |  10 +-
 drivers/nvme/host/fc.c                             |  15 +--
 drivers/nvme/host/multipath.c                      |   2 +-
 drivers/perf/riscv_pmu_sbi.c                       |   2 +-
 drivers/pinctrl/cirrus/pinctrl-cs42l43.c           |  21 ++++-
 drivers/pinctrl/nxp/pinctrl-s32cc.c                |   3 +-
 drivers/pinctrl/realtek/Kconfig                    |   1 +
 drivers/platform/x86/Kconfig                       |   1 +
 .../x86/intel/speed_select_if/isst_if_mmio.c       |   4 +-
 drivers/platform/x86/msi-wmi-platform.c            |  43 ++++++++-
 drivers/s390/net/ctcm_mpc.c                        |   1 -
 drivers/scsi/hosts.c                               |   5 +-
 drivers/scsi/sg.c                                  |  10 +-
 drivers/soc/ti/knav_dma.c                          |  14 +--
 drivers/target/loopback/tcm_loop.c                 |   3 +
 drivers/tty/vt/vt_ioctl.c                          |   4 +-
 fs/exfat/super.c                                   |   5 +-
 fs/isofs/inode.c                                   |   5 +
 fs/smb/client/cached_dir.c                         |  43 ++++++++-
 fs/smb/client/cifsfs.c                             |   2 +-
 fs/smb/client/fs_context.c                         |   4 +
 fs/xfs/scrub/symlink_repair.c                      |   4 +-
 include/linux/ata.h                                |   1 +
 include/net/tls.h                                  |  25 ++---
 include/net/xfrm.h                                 |   3 +-
 kernel/time/timer.c                                |   7 +-
 lib/maple_tree.c                                   |  30 +++---
 mm/mempool.c                                       |  32 +++++--
 mm/shmem.c                                         |  15 ++-
 net/devlink/rate.c                                 |   4 +-
 net/ipv4/esp4_offload.c                            |   6 +-
 net/ipv6/esp6_offload.c                            |   6 +-
 net/mptcp/options.c                                |  54 ++++++++++-
 net/mptcp/pm_netlink.c                             |  20 ++--
 net/mptcp/protocol.c                               |  84 +++++++++++------
 net/mptcp/protocol.h                               |   3 +-
 net/mptcp/subflow.c                                |   8 ++
 net/openvswitch/actions.c                          |  68 +-------------
 net/openvswitch/flow_netlink.c                     |  64 ++-----------
 net/openvswitch/flow_netlink.h                     |   2 -
 net/tls/tls_device.c                               |   4 +-
 net/unix/af_unix.c                                 |  36 ++++----
 net/vmw_vsock/af_vsock.c                           |  40 ++++++--
 net/xfrm/xfrm_output.c                             |   6 +-
 net/xfrm/xfrm_state.c                              |   8 +-
 net/xfrm/xfrm_user.c                               |   5 +-
 scripts/kconfig/mconf.c                            |   3 +
 scripts/kconfig/nconf.c                            |   3 +
 sound/usb/endpoint.c                               |   3 +-
 sound/usb/mixer.c                                  |   2 +-
 tools/arch/riscv/include/asm/csr.h                 |   5 +-
 tools/testing/selftests/net/bareudp.sh             |   2 +-
 .../selftests/net/forwarding/lib_sh_test.sh        |   7 ++
 tools/testing/selftests/net/lib.sh                 |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  18 ++--
 tools/tracing/latency/latency-collector.c          |   2 +-
 112 files changed, 914 insertions(+), 560 deletions(-)


