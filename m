Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7E01E25E1;
	Wed, 30 Jul 2025 09:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869099; cv=none; b=Hzw4lYzALfPNPp+oyzjYS8HiTlcUcL4BSDt/AW9qxzFCJFvoAnDy9K+Nou+tO0K46kPiVYLg2/E7o8Uyt6F4S2cvj5LXR3UAhut8NxuRCnnupMVVptpq/7krDTh7oNAv6WYvv8jFEwMhRcXBFSyxg99OZ3Vd/GnMZ8c4h8gi6B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869099; c=relaxed/simple;
	bh=YF2DfIvKIZh+2WA9y4d8pJKzMr1H6ufF79Oc9Rrp6JA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MeZlbn2NQpP6e/jvTk0zFWx+ug+sOqALs1ZDIsIqpyUrE6zCT4cK9eKuNMc38MY5EshF0HL5hwno9wbYLKBXlzVParKrmAU9TF2kNDLCEhkGmgO6trkl3OcaTTNgd10thDXGYigmNBov//jgYw2Mfo/Z1pd8ZcbWtyHVdexPclY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPpkYbWB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPpkYbWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF97AC4CEF5;
	Wed, 30 Jul 2025 09:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869099;
	bh=YF2DfIvKIZh+2WA9y4d8pJKzMr1H6ufF79Oc9Rrp6JA=;
	h=From:To:Cc:Subject:Date:From;
	b=WPpkYbWByjg3/UvAQeKp45w7rAcN/MHjBrKM4Q9AOpNVYpOT+i0BMq/mb/1i62pof
	 LL0ry0KsSL3LM0cbjxE4LJPEOSh7IrqMqzYptByjC1mdzO7aweyCFDKmrVAYhwNLHq
	 Ac3wNfTJqQX/0FxDWC3s0Ykrqmwzg4ICMVG8r5NQ=
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
Subject: [PATCH 6.15 00/92] 6.15.9-rc1 review
Date: Wed, 30 Jul 2025 11:35:08 +0200
Message-ID: <20250730093230.629234025@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.9-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.15.9-rc1
X-KernelTest-Deadline: 2025-08-01T09:32+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.15.9 release.
There are 92 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.9-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.15.9-rc1

Daniel Dadap <ddadap@nvidia.com>
    ALSA: hda: Add missing NVIDIA HDA codec IDs

Mohan Kumar D <mkumard@nvidia.com>
    ALSA: hda/tegra: Add Tegra264 support

Khairul Anuar Romli <khairul.anuar.romli@altera.com>
    spi: cadence-quadspi: fix cleanup of rx_chan on failure paths

RD Babiera <rdbabiera@google.com>
    usb: typec: tcpm: apply vbus before data bringup in tcpm_src_attach

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: typec: tcpm: allow switching to mode accessory to mux properly

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: typec: tcpm: allow to use sink in accessory mode

Thomas Zimmermann <tzimmermann@suse.de>
    Revert "drm/gem-shmem: Use dma_buf from GEM object instance"

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/shmem-helper: Remove obsoleted is_iomem test

Jesse Zhang <jesse.zhang@amd.com>
    drm/amdgpu: Fix SDMA engine reset with logical instance ID

Jesse.zhang@amd.com <Jesse.zhang@amd.com>
    drm/amdgpu: Implement SDMA soft reset directly for v5.x

Jesse.zhang@amd.com <Jesse.zhang@amd.com>
    drm/amdgpu: Add the new sdma function pointers for amdgpu_sdma.h

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Make WA BB part of LRC BO

Yonghong Song <yonghong.song@linux.dev>
    selftests/bpf: Add tests with stack ptr register in conditional jmp

Harry Yoo <harry.yoo@oracle.com>
    mm/zsmalloc: do not pass __GFP_MOVABLE if CONFIG_COMPACTION=n

Jinjiang Tu <tujinjiang@huawei.com>
    mm/vmscan: fix hwpoisoned large folio handling in shrink_folio_list

Zi Yan <ziy@nvidia.com>
    selftests/mm: fix split_huge_page_test for folio_split() tests

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: also cover checksum

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: also cover alt modes

Akinobu Mita <akinobu.mita@gmail.com>
    resource: fix false warning in __request_region()

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    PCI/pwrctrl: Create pwrctrl devices only when CONFIG_PCI_PWRCTRL is enabled

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

Johan Hovold <johan@kernel.org>
    ASoC: mediatek: common: fix device and OF node leak

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
    ARM: 9448/1: Use an absolute path to unified.h in KBUILD_AFLAGS

Nathan Chancellor <nathan@kernel.org>
    mm/ksm: fix -Wsometimes-uninitialized from clang-21 in advisor_mode_show()

Lin.Cao <lincao12@amd.com>
    drm/sched: Remove optimization that causes hang when killing dependent jobs

Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
    drm/amdgpu: Reset the clear flag in buddy during resume

Thomas Zimmermann <tzimmermann@suse.de>
    Revert "drm/gem-dma: Use dma_buf from GEM object instance"

Thomas Zimmermann <tzimmermann@suse.de>
    Revert "drm/gem-framebuffer: Use dma_buf from GEM object instance"

Thomas Zimmermann <tzimmermann@suse.de>
    Revert "drm/prime: Use dma_buf from GEM object instance"

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/dp: Fix 2.7 Gbps DP_LINK_BW value on g4x

Rong Zhang <i@rong.moe>
    platform/x86: ideapad-laptop: Fix kbd backlight not remembered among boots

Rong Zhang <i@rong.moe>
    platform/x86: ideapad-laptop: Fix FnLock not remembered among boots

Kurt Borja <kuurtb@gmail.com>
    platform/x86: alienware-wmi-wmax: Fix `dmi_system_id` array

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

Fernando Fernandez Mancera <fmancera@suse.de>
    xfrm: ipcomp: adjust transport header after decompressing

Tobias Brunner <tobias@strongswan.org>
    xfrm: Set transport header to fix UDP GRO handling

Leon Romanovsky <leon@kernel.org>
    xfrm: always initialize offload path

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

Gabor Juhos <j4g8y7@gmail.com>
    interconnect: icc-clk: destroy nodes in case of memory allocation failures

Xilin Wu <sophon@radxa.com>
    interconnect: qcom: sc7280: Add missing num_links to xm_pcie3_1 node

Markus Burri <markus.burri@mt.com>
    iio: fix potential out-of-bound write

Maor Gottlieb <maorg@nvidia.com>
    RDMA/core: Rate limit GID cache warning messages

Rahul Chandra <rahul@chandra.net>
    platform/x86: asus-nb-wmi: add DMI quirk for ASUS Zenbook Duo UX8406CA

Alessandro Carminati <acarmina@redhat.com>
    regulator: core: fix NULL dereference on unbind due to stale coupling data

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Don't allow OLED to go down to fully off

Laurent Vivier <lvivier@redhat.com>
    virtio_ring: Fix error reporting in virtqueue_resize

Laurent Vivier <lvivier@redhat.com>
    virtio_net: Enforce minimum TX ring size for reliability

Xin Li (Intel) <xin@zytor.com>
    x86/traps: Initialize DR7 by writing its architectural reset value


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/Kconfig                                   |   2 +-
 arch/arm/Makefile                                  |   2 +-
 arch/arm64/include/asm/assembler.h                 |   5 +
 arch/arm64/kernel/entry.S                          |   6 +
 arch/x86/hyperv/irqdomain.c                        |   4 +-
 arch/x86/include/asm/debugreg.h                    |  19 ++-
 arch/x86/include/asm/kvm_host.h                    |   2 +-
 arch/x86/kernel/cpu/common.c                       |   2 +-
 arch/x86/kernel/kgdb.c                             |   2 +-
 arch/x86/kernel/process_32.c                       |   2 +-
 arch/x86/kernel/process_64.c                       |   2 +-
 arch/x86/kvm/x86.c                                 |   4 +-
 drivers/base/regmap/regmap.c                       |   2 +
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |  19 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c           |  44 +++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.h           |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |  17 +++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  12 +-
 drivers/gpu/drm/bridge/ti-sn65dsi86.c              |   2 +-
 drivers/gpu/drm/drm_buddy.c                        |  43 ++++++
 drivers/gpu/drm/drm_gem_dma_helper.c               |   2 +-
 drivers/gpu/drm/drm_gem_framebuffer_helper.c       |   8 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c             |  10 +-
 drivers/gpu/drm/drm_prime.c                        |   8 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   6 +
 drivers/gpu/drm/scheduler/sched_entity.c           |  21 +--
 drivers/gpu/drm/xe/xe_lrc.c                        |  37 ++---
 drivers/gpu/drm/xe/xe_lrc_types.h                  |   3 -
 drivers/i2c/busses/i2c-qup.c                       |   4 +-
 drivers/i2c/busses/i2c-tegra.c                     |  24 +--
 drivers/i2c/busses/i2c-virtio.c                    |  15 +-
 drivers/iio/adc/ad7949.c                           |   7 +-
 drivers/iio/industrialio-core.c                    |   5 +-
 drivers/infiniband/core/cache.c                    |   4 +-
 drivers/interconnect/icc-clk.c                     |   2 +
 drivers/interconnect/qcom/sc7280.c                 |   1 +
 drivers/net/can/dev/dev.c                          |  12 +-
 drivers/net/can/dev/netlink.c                      |  12 ++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  15 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |  15 +-
 drivers/net/ethernet/google/gve/gve_main.c         |  67 +++++----
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  31 ++++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  36 +++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c |   9 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   6 +-
 drivers/net/ethernet/intel/e1000e/defines.h        |   3 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |   2 +
 drivers/net/ethernet/intel/e1000e/nvm.c            |   6 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   6 +-
 drivers/net/ethernet/intel/ice/ice_ddp.c           |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   4 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 108 +++++++-------
 drivers/net/ethernet/ti/icssg/icssg_config.c       | 162 ++++++++++++++-------
 drivers/net/ethernet/ti/icssg/icssg_config.h       |  78 ++++++++--
 drivers/net/ethernet/ti/icssg/icssg_prueth.c       |  20 ++-
 drivers/net/ethernet/ti/icssg/icssg_prueth.h       |   2 +
 drivers/net/ethernet/ti/icssg/icssg_switch_map.h   |   3 +
 drivers/net/virtio_net.c                           |   6 +
 drivers/pci/probe.c                                |   7 +
 drivers/platform/mellanox/mlxbf-pmc.c              |  25 +++-
 drivers/platform/x86/Makefile                      |   3 +-
 drivers/platform/x86/asus-nb-wmi.c                 |   9 ++
 drivers/platform/x86/dell/alienware-wmi-wmax.c     |   1 +
 drivers/platform/x86/ideapad-laptop.c              |   4 +-
 drivers/regulator/core.c                           |   1 +
 drivers/s390/net/ism_drv.c                         |   3 +
 drivers/spi/spi-cadence-quadspi.c                  |   5 -
 .../vc04_services/interface/vchiq_arm/vchiq_arm.c  |   3 +-
 drivers/usb/typec/tcpm/tcpm.c                      |  64 ++++----
 drivers/virtio/virtio_ring.c                       |   8 +-
 fs/nilfs2/inode.c                                  |   9 +-
 include/drm/drm_buddy.h                            |   2 +
 include/linux/ism.h                                |   1 +
 include/linux/sprintf.h                            |   1 +
 include/net/xfrm.h                                 |   2 +-
 kernel/bpf/verifier.c                              |   7 +-
 kernel/resource.c                                  |   5 +-
 kernel/time/timekeeping.c                          |   2 +-
 mm/kasan/report.c                                  |   4 +-
 mm/ksm.c                                           |   6 +-
 mm/memory-failure.c                                |   4 +
 mm/vmscan.c                                        |   8 +
 mm/zsmalloc.c                                      |   3 +
 net/appletalk/aarp.c                               |  24 ++-
 net/ipv4/xfrm4_input.c                             |   3 +
 net/ipv6/xfrm6_input.c                             |   3 +
 net/sched/sch_qfq.c                                |   7 +-
 net/xfrm/xfrm_device.c                             |   1 -
 net/xfrm/xfrm_interface_core.c                     |   7 +-
 net/xfrm/xfrm_ipcomp.c                             |   2 +-
 net/xfrm/xfrm_state.c                              |  29 ++--
 net/xfrm/xfrm_user.c                               |   1 +
 sound/pci/hda/hda_tegra.c                          |  51 ++++++-
 sound/pci/hda/patch_hdmi.c                         |  20 +++
 sound/pci/hda/patch_realtek.c                      |   4 +-
 sound/soc/mediatek/common/mtk-soundcard-driver.c   |   4 +
 sound/soc/mediatek/mt8365/mt8365-dai-i2s.c         |   3 +-
 tools/hv/hv_fcopy_uio_daemon.c                     |  37 ++---
 .../selftests/bpf/progs/verifier_precision.c       |  53 +++++++
 tools/testing/selftests/drivers/net/lib/py/load.py |  23 ++-
 tools/testing/selftests/mm/split_huge_page_test.c  |   3 +-
 tools/testing/selftests/net/mptcp/Makefile         |   3 +-
 .../selftests/net/mptcp/mptcp_connect_checksum.sh  |   5 +
 .../selftests/net/mptcp/mptcp_connect_mmap.sh      |   5 +
 .../selftests/net/mptcp/mptcp_connect_sendfile.sh  |   5 +
 109 files changed, 998 insertions(+), 452 deletions(-)


