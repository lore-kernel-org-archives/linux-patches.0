Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C960B296170;
	Wed, 30 Jul 2025 09:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868628; cv=none; b=gkapO6Lcqi8PPklNN24QXB87MJnrpGLiu66d8xpd0vUTrjyxmpKI9ucWIhwRIjkeIZucAqeKt2m9x5CQ0JAXPvNS54GP2o/xk/YGKcxqPY+TT1iVCPG4wyOxLZuDOupxcixJud+SnpkLrG3nldZAdDNsbIry+X1+lGa6j+SYchI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868628; c=relaxed/simple;
	bh=wHmBZ09U7nWm46Vtbjrqu6BQC7RCl7dYwIAjJZvofEs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UtMD0U3vuz/ugZxeRWHamHgnZEFUhWhy8SoAamYf+zWQXSLh7ZHB2NkMBrNO0qIcqzELJ3bPy3m6YiwIhJRJhozelJBwnXEgyKZt780QnPUFkL07jPCL6PJWqix3THT/b/2TsUxGrmC0g9WNojre7XwTKwLmloeOGpmUpJE36+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1ObQCEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1ObQCEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21821C4CEF5;
	Wed, 30 Jul 2025 09:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868628;
	bh=wHmBZ09U7nWm46Vtbjrqu6BQC7RCl7dYwIAjJZvofEs=;
	h=From:To:Cc:Subject:Date:From;
	b=U1ObQCEc0apvd74pzGo2qT/Go2wsSrhltexTzBkr7LyNJMUpbS3XuGnD8GnJ/4uoP
	 mhLHZ9Nn/SXgNCmk47vRjvr3aepq9YG8hCoLGdsZ+GgbFXb0HT8wL8uha65Pj4C7nR
	 YvjcHaa7PkAytrRymhB40bMLsiQrNbCh/QZQjSWM=
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
Subject: [PATCH 6.12 000/117] 6.12.41-rc1 review
Date: Wed, 30 Jul 2025 11:34:29 +0200
Message-ID: <20250730093233.592541778@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.41-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.41-rc1
X-KernelTest-Deadline: 2025-08-01T09:32+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.41 release.
There are 117 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.41-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.41-rc1

Liu Shixin <liushixin2@huawei.com>
    mm: khugepaged: fix call hpage_collapse_scan_file() for anonymous vma

Sean Christopherson <seanjc@google.com>
    KVM: x86: Free vCPUs before freeing VM state

Tomita Moeko <tomitamoeko@gmail.com>
    Revert "drm/xe/forcewake: Add a helper xe_force_wake_ref_has_domain()"

Tomita Moeko <tomitamoeko@gmail.com>
    Revert "drm/xe/devcoredump: Update handling of xe_force_wake_get return"

Tomita Moeko <tomitamoeko@gmail.com>
    Revert "drm/xe/tests/mocs: Update xe_force_wake_get() return handling"

Tomita Moeko <tomitamoeko@gmail.com>
    Revert "drm/xe/gt: Update handling of xe_force_wake_get return"

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/dp: Fix 2.7 Gbps DP_LINK_BW value on g4x

Daniel Dadap <ddadap@nvidia.com>
    ALSA: hda: Add missing NVIDIA HDA codec IDs

Mohan Kumar D <mkumard@nvidia.com>
    ALSA: hda/tegra: Add Tegra264 support

Naman Jain <namjain@linux.microsoft.com>
    Drivers: hv: Make the sysfs node size for the ring buffer dynamic

Nathan Chancellor <nathan@kernel.org>
    ARM: 9448/1: Use an absolute path to unified.h in KBUILD_AFLAGS

Zhang Lixu <lixu.zhang@intel.com>
    iio: hid-sensor-prox: Fix incorrect OFFSET calculation

Zhang Lixu <lixu.zhang@intel.com>
    iio: hid-sensor-prox: Restore lost scale assignments

Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
    wifi: mt76: mt7925: adjust rm BSS flow to prevent next connection failure

Sean Wang <sean.wang@mediatek.com>
    Revert "wifi: mt76: mt7925: Update mt7925_mcu_uni_[tx,rx]_ba for MLO"

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: x1-crd: Fix vreg_l2j_1p2 voltage

Roman Kisel <romank@linux.microsoft.com>
    x86/hyperv: Fix APIC ID and VP index confusion in hv_snp_boot_ap()

Manuel Andreas <manuel.andreas@tum.de>
    KVM: x86/hyper-v: Skip non-canonical addresses during PV TLB flush

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: model canonical checks more precisely

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: Add X86EMUL_F_MSR and X86EMUL_F_DT_LOAD to aid canonical checks

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: Route non-canonical checks in emulator through emulate_ops

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: drop x86.h include from cpuid.h

Zhang Yi <yi.zhang@huawei.com>
    ext4: fix out of bounds punch offset

Zhang Yi <yi.zhang@huawei.com>
    ext4: correct the error handle in ext4_fallocate()

Zhang Yi <yi.zhang@huawei.com>
    ext4: fix incorrect punch max_end

Zhang Yi <yi.zhang@huawei.com>
    ext4: move out common parts into ext4_fallocate()

Zhang Yi <yi.zhang@huawei.com>
    ext4: move out inode_lock into ext4_fallocate()

Zhang Yi <yi.zhang@huawei.com>
    ext4: factor out ext4_do_fallocate()

Zhang Yi <yi.zhang@huawei.com>
    ext4: refactor ext4_insert_range()

Zhang Yi <yi.zhang@huawei.com>
    ext4: refactor ext4_collapse_range()

Zhang Yi <yi.zhang@huawei.com>
    ext4: refactor ext4_zero_range()

Zhang Yi <yi.zhang@huawei.com>
    ext4: refactor ext4_punch_hole()

Zhang Yi <yi.zhang@huawei.com>
    ext4: don't explicit update times in ext4_fallocate()

Gao Xiang <xiang@kernel.org>
    erofs: fix large fragment handling

Gao Xiang <xiang@kernel.org>
    erofs: clean up header parsing for ztailpacking and fragments

Gao Xiang <xiang@kernel.org>
    erofs: simplify tail inline pcluster handling

Hongzhen Luo <hongzhen@linux.alibaba.com>
    erofs: use Z_EROFS_LCLUSTER_TYPE_MAX to simplify switches

Gao Xiang <xiang@kernel.org>
    erofs: refine z_erofs_get_extent_compressedlen()

Gao Xiang <xiang@kernel.org>
    erofs: simplify z_erofs_load_compact_lcluster()

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: x1e78100-t14s: mark l12b and l15b always-on

Md Sadre Alam <quic_mdalam@quicinc.com>
    mtd: rawnand: qcom: Fix last codeword read in qcom_param_page_type_exec()

Eric Biggers <ebiggers@google.com>
    crypto: powerpc/poly1305 - add depends on BROKEN for now

Ian Abbott <abbotti@mev.co.uk>
    comedi: comedi_test: Fix possible deletion of uninitialized timers

Dmitry Antipov <dmantipov@yandex.ru>
    jfs: reject on-disk inodes of an unsupported type

Michael Zhivich <mzhivich@akamai.com>
    x86/bugs: Fix use of possibly uninit value in amd_check_tsa_microcode()

Khairul Anuar Romli <khairul.anuar.romli@altera.com>
    spi: cadence-quadspi: fix cleanup of rx_chan on failure paths

RD Babiera <rdbabiera@google.com>
    usb: typec: tcpm: apply vbus before data bringup in tcpm_src_attach

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: typec: tcpm: allow switching to mode accessory to mux properly

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: typec: tcpm: allow to use sink in accessory mode

Yonghong Song <yonghong.song@linux.dev>
    selftests/bpf: Add tests with stack ptr register in conditional jmp

Miguel Ojeda <ojeda@kernel.org>
    rust: give Clippy the minimum supported Rust version

Harry Yoo <harry.yoo@oracle.com>
    mm/zsmalloc: do not pass __GFP_MOVABLE if CONFIG_COMPACTION=n

Jinjiang Tu <tujinjiang@huawei.com>
    mm/vmscan: fix hwpoisoned large folio handling in shrink_folio_list

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: also cover checksum

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: also cover alt modes

Akinobu Mita <akinobu.mita@gmail.com>
    resource: fix false warning in __request_region()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: reject invalid file types when reading inodes

Marco Elver <elver@google.com>
    kasan: use vmalloc_dump_obj() for vmalloc error reports

Haoxiang Li <haoxiang_li2024@163.com>
    ice: Fix a null pointer dereference in ice_copy_and_init_pkg()

Praveen Kaligineedi <pkaligineedi@google.com>
    gve: Fix stuck TX queue for DQ queue format

Jacek Kowalski <jacek@jacekk.info>
    e1000e: ignore uninitialized checksum word on tgp

Jacek Kowalski <jacek@jacekk.info>
    e1000e: disregard NVM checksum on tgp when valid checksum bit is not set

Ma Ke <make24@iscas.ac.cn>
    dpaa2-switch: Fix device reference count leak in MAC endpoint handling

Ma Ke <make24@iscas.ac.cn>
    dpaa2-eth: Fix device reference count leak in MAC endpoint handling

Ada Couprie Diaz <ada.coupriediaz@arm.com>
    arm64/entry: Mask DAIF in cpu_switch_to(), call_on_irq_stack()

Edip Hazuri <edip@medip.dev>
    ALSA: hda/realtek - Add mute LED support for HP Victus 15-fa0xxx

Dawid Rezler <dawidrezler.patches@gmail.com>
    ALSA: hda/realtek - Add mute LED support for HP Pavilion 15-eg0xxx

Stephen Rothwell <sfr@canb.auug.org.au>
    sprintf.h requires stdarg.h

Ma Ke <make24@iscas.ac.cn>
    bus: fsl-mc: Fix potential double device reference in fsl_mc_get_endpoint()

Viresh Kumar <viresh.kumar@linaro.org>
    i2c: virtio: Avoid hang by using interruptible completion wait

Akhil R <akhilrajeev@nvidia.com>
    i2c: tegra: Fix reset error handling with ACPI

Yang Xiwen <forbidden405@outlook.com>
    i2c: qup: jump out of the loop in case of timeout

Markus Blöchl <markus@blochl.de>
    timekeeping: Zero initialize system_counterval when querying time from phc drivers

Nathan Chancellor <nathan@kernel.org>
    ARM: 9450/1: Fix allowing linker DCE with binutils < 2.36

Nathan Chancellor <nathan@kernel.org>
    mm/ksm: fix -Wsometimes-uninitialized from clang-21 in advisor_mode_show()

Lin.Cao <lincao12@amd.com>
    drm/sched: Remove optimization that causes hang when killing dependent jobs

Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
    drm/amdgpu: Reset the clear flag in buddy during resume

Rong Zhang <i@rong.moe>
    platform/x86: ideapad-laptop: Fix kbd backlight not remembered among boots

Rong Zhang <i@rong.moe>
    platform/x86: ideapad-laptop: Fix FnLock not remembered among boots

Jijie Shao <shaojijie@huawei.com>
    net: hns3: default enable tx bounce buffer when smmu enabled

Jian Shen <shenjian15@huawei.com>
    net: hns3: fixed vf get max channels bug

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: disable interrupt when ptp init failed

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix concurrent setting vlan filter issue

Halil Pasic <pasic@linux.ibm.com>
    s390/ism: fix concurrency management in ism_cmd()

Nimrod Oren <noren@nvidia.com>
    selftests: drv-net: wait for iperf client to stop sending

SHARAN KUMAR M <sharweshraajan@gmail.com>
    ALSA: hda/realtek: Fix mute LED mask on HP OMEN 16 laptop

Douglas Anderson <dianders@chromium.org>
    drm/bridge: ti-sn65dsi86: Remove extra semicolon in ti_sn_bridge_probe()

Marc Kleine-Budde <mkl@pengutronix.de>
    can: netlink: can_changelink(): fix NULL pointer deref of struct can_priv::do_set_mode

Xiang Mei <xmei5@asu.edu>
    net/sched: sch_qfq: Avoid triggering might_sleep in atomic context in qfq_delete_class

Kito Xu (veritas501) <hxzene@gmail.com>
    net: appletalk: Fix use-after-free in AARP proxy probe

Jamie Bainbridge <jamie.bainbridge@gmail.com>
    i40e: When removing VF MAC filters, only check PF-set MAC

Dennis Chen <dechen@redhat.com>
    i40e: report VF tx_dropped with tx_errors instead of tx_discards

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5: E-Switch, Fix peer miss rules to use peer eswitch

Chiara Meiohas <cmeiohas@nvidia.com>
    net/mlx5: Fix memory leak in cmd_exec()

Himanshu Mittal <h-mittal1@ti.com>
    net: ti: icssg-prueth: Fix buffer allocation for ICSSG

Guoqing Jiang <guoqing.jiang@canonical.com>
    ASoC: mediatek: mt8365-dai-i2s: pass correct size to mt8365_dai_set_priv

Eyal Birger <eyal.birger@gmail.com>
    xfrm: interface: fix use-after-free after changing collect_md xfrm interface

Tobias Brunner <tobias@strongswan.org>
    xfrm: Set transport header to fix UDP GRO handling

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: state: use a consistent pcpu_id in xfrm_state_find

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: state: initialize state_ptrs earlier in xfrm_state_find

Stefan Wahren <wahrenst@gmx.net>
    staging: vchiq_arm: Make vchiq_shutdown never fail

Torsten Hilbrich <torsten.hilbrich@secunet.com>
    platform/x86: Fix initialization order for firmware_attributes_class

Nuno Das Neves <nunodasneves@linux.microsoft.com>
    x86/hyperv: Fix usage of cpu_online_mask to get valid cpu

Yasumasa Suenaga <yasuenag@gmail.com>
    tools/hv: fcopy: Fix incorrect file path conversion

Shravan Kumar Ramani <shravankr@nvidia.com>
    platform/mellanox: mlxbf-pmc: Use kstrtobool() to check 0/1 input

Shravan Kumar Ramani <shravankr@nvidia.com>
    platform/mellanox: mlxbf-pmc: Validate event/enable input

Shravan Kumar Ramani <shravankr@nvidia.com>
    platform/mellanox: mlxbf-pmc: Remove newline char from event name input

Abdun Nihaal <abdun.nihaal@gmail.com>
    regmap: fix potential memory leak of regmap_bus

David Lechner <dlechner@baylibre.com>
    iio: adc: ad7949: use spi_is_bpw_supported()

Xilin Wu <sophon@radxa.com>
    interconnect: qcom: sc7280: Add missing num_links to xm_pcie3_1 node

Maor Gottlieb <maorg@nvidia.com>
    RDMA/core: Rate limit GID cache warning messages

Rahul Chandra <rahul@chandra.net>
    platform/x86: asus-nb-wmi: add DMI quirk for ASUS Zenbook Duo UX8406CA

Alessandro Carminati <acarmina@redhat.com>
    regulator: core: fix NULL dereference on unbind due to stale coupling data

Laurent Vivier <lvivier@redhat.com>
    virtio_ring: Fix error reporting in virtqueue_resize

Laurent Vivier <lvivier@redhat.com>
    virtio_net: Enforce minimum TX ring size for reliability

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    Input: gpio-keys - fix a sleep while atomic with PREEMPT_RT

Xin Li (Intel) <xin@zytor.com>
    x86/traps: Initialize DR7 by writing its architectural reset value


-------------

Diffstat:

 .clippy.toml                                       |   2 +
 Makefile                                           |   4 +-
 arch/arm/Kconfig                                   |   2 +-
 arch/arm/Makefile                                  |   2 +-
 .../dts/qcom/x1e78100-lenovo-thinkpad-t14s.dts     |   2 +
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts          |   4 +-
 arch/arm64/include/asm/assembler.h                 |   5 +
 arch/arm64/kernel/entry.S                          |   6 +
 arch/powerpc/crypto/Kconfig                        |   1 +
 arch/x86/hyperv/hv_init.c                          |  33 ++
 arch/x86/hyperv/hv_vtl.c                           |  44 +-
 arch/x86/hyperv/irqdomain.c                        |   4 +-
 arch/x86/hyperv/ivm.c                              |  22 +-
 arch/x86/include/asm/debugreg.h                    |  19 +-
 arch/x86/include/asm/kvm_host.h                    |   2 +-
 arch/x86/include/asm/mshyperv.h                    |   6 +-
 arch/x86/kernel/cpu/amd.c                          |   2 +
 arch/x86/kernel/cpu/common.c                       |   2 +-
 arch/x86/kernel/kgdb.c                             |   2 +-
 arch/x86/kernel/process_32.c                       |   2 +-
 arch/x86/kernel/process_64.c                       |   2 +-
 arch/x86/kvm/cpuid.h                               |   1 -
 arch/x86/kvm/emulate.c                             |  15 +-
 arch/x86/kvm/hyperv.c                              |   3 +
 arch/x86/kvm/kvm_emulate.h                         |   5 +
 arch/x86/kvm/mmu.h                                 |   1 +
 arch/x86/kvm/mmu/mmu.c                             |   2 +-
 arch/x86/kvm/mtrr.c                                |   1 +
 arch/x86/kvm/vmx/hyperv.c                          |   1 +
 arch/x86/kvm/vmx/nested.c                          |  24 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |   2 +-
 arch/x86/kvm/vmx/sgx.c                             |   5 +-
 arch/x86/kvm/vmx/vmx.c                             |   4 +-
 arch/x86/kvm/x86.c                                 |  19 +-
 arch/x86/kvm/x86.h                                 |  48 +-
 drivers/base/regmap/regmap.c                       |   2 +
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |  19 +-
 drivers/comedi/drivers/comedi_test.c               |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |  17 +
 drivers/gpu/drm/bridge/ti-sn65dsi86.c              |   2 +-
 drivers/gpu/drm/drm_buddy.c                        |  43 ++
 drivers/gpu/drm/i915/display/intel_dp.c            |   6 +
 drivers/gpu/drm/scheduler/sched_entity.c           |  21 +-
 drivers/gpu/drm/xe/tests/xe_mocs.c                 |  21 +-
 drivers/gpu/drm/xe/xe_devcoredump.c                |  14 +-
 drivers/gpu/drm/xe/xe_force_wake.h                 |  16 -
 drivers/gpu/drm/xe/xe_gt.c                         | 105 ++---
 drivers/hv/vmbus_drv.c                             |   2 +-
 drivers/i2c/busses/i2c-qup.c                       |   4 +-
 drivers/i2c/busses/i2c-tegra.c                     |  24 +-
 drivers/i2c/busses/i2c-virtio.c                    |  15 +-
 drivers/iio/adc/ad7949.c                           |   7 +-
 drivers/iio/light/hid-sensor-prox.c                |   8 +-
 drivers/infiniband/core/cache.c                    |   4 +-
 drivers/input/keyboard/gpio_keys.c                 |   4 +-
 drivers/interconnect/qcom/sc7280.c                 |   1 +
 drivers/mtd/nand/raw/qcom_nandc.c                  |  12 +-
 drivers/net/can/dev/dev.c                          |  12 +-
 drivers/net/can/dev/netlink.c                      |  12 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  15 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |  15 +-
 drivers/net/ethernet/google/gve/gve_main.c         |  67 +--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  31 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  36 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c |   9 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   6 +-
 drivers/net/ethernet/intel/e1000e/defines.h        |   3 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |   2 +
 drivers/net/ethernet/intel/e1000e/nvm.c            |   6 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   6 +-
 drivers/net/ethernet/intel/ice/ice_ddp.c           |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   4 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 108 ++---
 drivers/net/ethernet/ti/icssg/icssg_config.c       | 162 ++++---
 drivers/net/ethernet/ti/icssg/icssg_config.h       |  78 ++-
 drivers/net/ethernet/ti/icssg/icssg_prueth.c       |  20 +-
 drivers/net/ethernet/ti/icssg/icssg_prueth.h       |   2 +
 drivers/net/ethernet/ti/icssg/icssg_switch_map.h   |   3 +
 drivers/net/virtio_net.c                           |   6 +
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   |  76 +--
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    | 106 +++--
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.h    |   2 +
 drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h |   2 -
 drivers/platform/mellanox/mlxbf-pmc.c              |  25 +-
 drivers/platform/x86/Makefile                      |   3 +-
 drivers/platform/x86/asus-nb-wmi.c                 |   9 +
 drivers/platform/x86/ideapad-laptop.c              |   4 +-
 drivers/regulator/core.c                           |   1 +
 drivers/s390/net/ism_drv.c                         |   3 +
 drivers/spi/spi-cadence-quadspi.c                  |   5 -
 .../vc04_services/interface/vchiq_arm/vchiq_arm.c  |   3 +-
 drivers/usb/typec/tcpm/tcpm.c                      |  64 ++-
 drivers/virtio/virtio_ring.c                       |   8 +-
 fs/erofs/internal.h                                |  13 +-
 fs/erofs/zdata.c                                   |   2 +-
 fs/erofs/zmap.c                                    | 250 ++++------
 fs/ext4/ext4.h                                     |   2 +
 fs/ext4/extents.c                                  | 524 ++++++++-------------
 fs/ext4/inode.c                                    | 140 +++---
 fs/jfs/jfs_imap.c                                  |  13 +-
 fs/nilfs2/inode.c                                  |   9 +-
 include/drm/drm_buddy.h                            |   2 +
 include/linux/ism.h                                |   1 +
 include/linux/sprintf.h                            |   1 +
 kernel/bpf/verifier.c                              |   7 +-
 kernel/resource.c                                  |   5 +-
 kernel/time/timekeeping.c                          |   2 +-
 mm/kasan/report.c                                  |   4 +-
 mm/khugepaged.c                                    |   4 +-
 mm/ksm.c                                           |   6 +-
 mm/memory-failure.c                                |   4 +
 mm/vmscan.c                                        |   8 +
 mm/zsmalloc.c                                      |   3 +
 net/appletalk/aarp.c                               |  24 +-
 net/ipv4/xfrm4_input.c                             |   3 +
 net/ipv6/xfrm6_input.c                             |   3 +
 net/sched/sch_qfq.c                                |   7 +-
 net/xfrm/xfrm_interface_core.c                     |   7 +-
 net/xfrm/xfrm_state.c                              |  23 +-
 sound/pci/hda/hda_tegra.c                          |  51 +-
 sound/pci/hda/patch_hdmi.c                         |  20 +
 sound/pci/hda/patch_realtek.c                      |   4 +-
 sound/soc/mediatek/mt8365/mt8365-dai-i2s.c         |   3 +-
 tools/hv/hv_fcopy_uio_daemon.c                     |  37 +-
 .../selftests/bpf/progs/verifier_precision.c       |  53 +++
 tools/testing/selftests/drivers/net/lib/py/load.py |  23 +-
 tools/testing/selftests/net/mptcp/Makefile         |   3 +-
 .../selftests/net/mptcp/mptcp_connect_checksum.sh  |   5 +
 .../selftests/net/mptcp/mptcp_connect_mmap.sh      |   5 +
 .../selftests/net/mptcp/mptcp_connect_sendfile.sh  |   5 +
 133 files changed, 1615 insertions(+), 1230 deletions(-)


