Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D14720F078;
	Wed, 30 Jul 2025 09:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868308; cv=none; b=cM6HC1EWIIV+1Vc9cagshJe0eTkvP50EF37sSispzpOzkLnb7ZZ/0aB6RcmAs9lZl1G7JpWHmHeaNisBxomfWeMsTzXP03S5b/lOFvAwwFivW2ka/kY+Um7CCEWsYrkkrCQm/iYAaJ95XjrZMUh1f3ZO1cf4PISfsBzsK+2MXAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868308; c=relaxed/simple;
	bh=pRNuFhfe6J7LIoGRpoziCUBYI/Pee0a4GmZfuvnSLXc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jNaxBG0+XRplCtj/hMmyPA/thnUNvOAfkSXohDmj7OZAFWQczlAqppjAVFYg/ULjbb62R7gCxoqD5aHRItb68vz4sfsHbeHeohRJvfyBmmd+uFxvzSgnncsBNiT80uJvBwg05rHFxg0xUbxVoZO2KoUYsyx7BsH6NcDtBxTvX4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WG463kuU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WG463kuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA171C4CEE7;
	Wed, 30 Jul 2025 09:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868308;
	bh=pRNuFhfe6J7LIoGRpoziCUBYI/Pee0a4GmZfuvnSLXc=;
	h=From:To:Cc:Subject:Date:From;
	b=WG463kuU1CcBbpGsqSLOmDmcFyqacIvxJU+0CrCHMxQXwGYhnjdURdAR2DeLpQu55
	 nE50jGNpKIYBMf7r2nakLLu6Hn78p/fiMtcN7JdDQs1KEx1jiaBi8eyRmnDl9Vb2Wf
	 ylPwxPaZ7uVKuNE9CqcJ7JazVIbdCT2xJSDlDn60=
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
Subject: [PATCH 6.6 00/76] 6.6.101-rc1 review
Date: Wed, 30 Jul 2025 11:34:53 +0200
Message-ID: <20250730093226.854413920@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.101-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.101-rc1
X-KernelTest-Deadline: 2025-08-01T09:32+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.101 release.
There are 76 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.101-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.101-rc1

Shung-Hsi Yu <shung-hsi.yu@suse.com>
    Revert "selftests/bpf: Add a cgroup prog bpf_get_ns_current_pid_tgid() test"

Khairul Anuar Romli <khairul.anuar.romli@altera.com>
    spi: cadence-quadspi: fix cleanup of rx_chan on failure paths

Lin.Cao <lincao12@amd.com>
    drm/sched: Remove optimization that causes hang when killing dependent jobs

Nathan Chancellor <nathan@kernel.org>
    ARM: 9448/1: Use an absolute path to unified.h in KBUILD_AFLAGS

Paolo Abeni <pabeni@redhat.com>
    mptcp: reset fallback status gracefully at disconnect() time

Paolo Abeni <pabeni@redhat.com>
    mptcp: plug races between subflow fail and subflow creation

Paolo Abeni <pabeni@redhat.com>
    mptcp: make fallback action and fallback decision atomic

Nianyao Tang <tangnianyao@huawei.com>
    arm64/cpufeatures/kvm: Add ARMv8.9 FEAT_ECBHB bits in ID_AA64MMFR1 register

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add free_transport ops in ksmbd connection

Deren Wu <deren.wu@mediatek.com>
    wifi: mt76: mt7921: prevent decap offload config before STA initialization

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix crash in icl_update_topdown_event()

Md Sadre Alam <quic_mdalam@quicinc.com>
    mtd: rawnand: qcom: Fix last codeword read in qcom_param_page_type_exec()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in __smb2_lease_break_noti()

Zhang Lixu <lixu.zhang@intel.com>
    iio: hid-sensor-prox: Restore lost scale assignments

Zhang Lixu <lixu.zhang@intel.com>
    iio: hid-sensor-prox: Fix incorrect OFFSET calculation

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - add shutdown handler to qat_dh895xcc

Eric Biggers <ebiggers@google.com>
    crypto: powerpc/poly1305 - add depends on BROKEN for now

Gao Xiang <xiang@kernel.org>
    erofs: address D-cache aliasing

Liu Shixin <liushixin2@huawei.com>
    mm: khugepaged: fix call hpage_collapse_scan_file() for anonymous vma

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/dp: Fix 2.7 Gbps DP_LINK_BW value on g4x

Daniel Dadap <ddadap@nvidia.com>
    ALSA: hda: Add missing NVIDIA HDA codec IDs

Mohan Kumar D <mkumard@nvidia.com>
    ALSA: hda/tegra: Add Tegra264 support

Ian Abbott <abbotti@mev.co.uk>
    comedi: comedi_test: Fix possible deletion of uninitialized timers

Dmitry Antipov <dmantipov@yandex.ru>
    jfs: reject on-disk inodes of an unsupported type

Michael Zhivich <mzhivich@akamai.com>
    x86/bugs: Fix use of possibly uninit value in amd_check_tsa_microcode()

RD Babiera <rdbabiera@google.com>
    usb: typec: tcpm: apply vbus before data bringup in tcpm_src_attach

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: typec: tcpm: allow switching to mode accessory to mux properly

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: typec: tcpm: allow to use sink in accessory mode

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Don't call mmput from MMU notifier callback

Harry Yoo <harry.yoo@oracle.com>
    mm/zsmalloc: do not pass __GFP_MOVABLE if CONFIG_COMPACTION=n

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

Rong Zhang <i@rong.moe>
    platform/x86: ideapad-laptop: Fix kbd backlight not remembered among boots

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

Douglas Anderson <dianders@chromium.org>
    drm/bridge: ti-sn65dsi86: Remove extra semicolon in ti_sn_bridge_probe()

Marc Kleine-Budde <mkl@pengutronix.de>
    can: netlink: can_changelink(): fix NULL pointer deref of struct can_priv::do_set_mode

Marc Kleine-Budde <mkl@pengutronix.de>
    can: dev: can_restart(): move debug message and stats after successful restart

Marc Kleine-Budde <mkl@pengutronix.de>
    can: dev: can_restart(): reverse logic to remove need for goto

Xiang Mei <xmei5@asu.edu>
    net/sched: sch_qfq: Avoid triggering might_sleep in atomic context in qfq_delete_class

Kito Xu (veritas501) <hxzene@gmail.com>
    net: appletalk: Fix use-after-free in AARP proxy probe

Jamie Bainbridge <jamie.bainbridge@gmail.com>
    i40e: When removing VF MAC filters, only check PF-set MAC

Dennis Chen <dechen@redhat.com>
    i40e: report VF tx_dropped with tx_errors instead of tx_discards

Yajun Deng <yajun.deng@linux.dev>
    i40e: Add rx_missed_errors for buffer exhaustion

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5: E-Switch, Fix peer miss rules to use peer eswitch

Chiara Meiohas <cmeiohas@nvidia.com>
    net/mlx5: Fix memory leak in cmd_exec()

Eyal Birger <eyal.birger@gmail.com>
    xfrm: interface: fix use-after-free after changing collect_md xfrm interface

Stefan Wahren <wahrenst@gmx.net>
    staging: vchiq_arm: Make vchiq_shutdown never fail

Torsten Hilbrich <torsten.hilbrich@secunet.com>
    platform/x86: Fix initialization order for firmware_attributes_class

Nuno Das Neves <nunodasneves@linux.microsoft.com>
    x86/hyperv: Fix usage of cpu_online_mask to get valid cpu

Abdun Nihaal <abdun.nihaal@gmail.com>
    regmap: fix potential memory leak of regmap_bus

David Lechner <dlechner@baylibre.com>
    iio: adc: ad7949: use spi_is_bpw_supported()

Xilin Wu <sophon@radxa.com>
    interconnect: qcom: sc7280: Add missing num_links to xm_pcie3_1 node

Maor Gottlieb <maorg@nvidia.com>
    RDMA/core: Rate limit GID cache warning messages

Alessandro Carminati <acarmina@redhat.com>
    regulator: core: fix NULL dereference on unbind due to stale coupling data

Laurent Vivier <lvivier@redhat.com>
    virtio_ring: Fix error reporting in virtqueue_resize

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    Input: gpio-keys - fix a sleep while atomic with PREEMPT_RT


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/Makefile                                  |   2 +-
 arch/arm64/include/asm/assembler.h                 |   5 +
 arch/arm64/kernel/cpufeature.c                     |   1 +
 arch/arm64/kernel/entry.S                          |   6 ++
 arch/powerpc/crypto/Kconfig                        |   1 +
 arch/x86/events/intel/core.c                       |   2 +-
 arch/x86/hyperv/irqdomain.c                        |   4 +-
 arch/x86/kernel/cpu/amd.c                          |   2 +
 drivers/base/regmap/regmap.c                       |   2 +
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |  19 ++--
 drivers/comedi/drivers/comedi_test.c               |   2 +-
 drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c    |   9 ++
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |  47 +++++----
 drivers/gpu/drm/bridge/ti-sn65dsi86.c              |   2 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   6 ++
 drivers/gpu/drm/scheduler/sched_entity.c           |  25 +----
 drivers/i2c/busses/i2c-qup.c                       |   4 +-
 drivers/i2c/busses/i2c-tegra.c                     |  24 +----
 drivers/i2c/busses/i2c-virtio.c                    |  15 +--
 drivers/iio/adc/ad7949.c                           |   7 +-
 drivers/iio/light/hid-sensor-prox.c                |   8 +-
 drivers/infiniband/core/cache.c                    |   4 +-
 drivers/input/keyboard/gpio_keys.c                 |   4 +-
 drivers/interconnect/qcom/sc7280.c                 |   1 +
 drivers/mtd/nand/raw/qcom_nandc.c                  |  12 ++-
 drivers/net/can/dev/dev.c                          |  31 +++---
 drivers/net/can/dev/netlink.c                      |  12 +++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  15 ++-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |  15 ++-
 drivers/net/ethernet/google/gve/gve_main.c         |  67 +++++++------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  31 ++++++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  36 ++++---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c |   9 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   6 +-
 drivers/net/ethernet/intel/e1000e/defines.h        |   3 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |   2 +
 drivers/net/ethernet/intel/e1000e/nvm.c            |   6 ++
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   3 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  18 ++--
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   8 +-
 drivers/net/ethernet/intel/ice/ice_ddp.c           |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   4 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 108 ++++++++++-----------
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   3 +
 drivers/platform/x86/Makefile                      |   3 +-
 drivers/platform/x86/ideapad-laptop.c              |   2 +-
 drivers/regulator/core.c                           |   1 +
 drivers/s390/net/ism_drv.c                         |   3 +
 drivers/spi/spi-cadence-quadspi.c                  |   5 -
 .../vc04_services/interface/vchiq_arm/vchiq_arm.c  |   3 +-
 drivers/usb/typec/tcpm/tcpm.c                      |  64 +++++++-----
 drivers/virtio/virtio_ring.c                       |   8 +-
 fs/erofs/decompressor.c                            |   6 +-
 fs/erofs/zdata.c                                   |  32 +++---
 fs/jfs/jfs_imap.c                                  |  13 ++-
 fs/nilfs2/inode.c                                  |   9 +-
 fs/smb/server/connection.c                         |   4 +-
 fs/smb/server/connection.h                         |   1 +
 fs/smb/server/transport_rdma.c                     |  10 +-
 fs/smb/server/transport_tcp.c                      |  15 ++-
 fs/smb/server/transport_tcp.h                      |   1 +
 include/linux/ism.h                                |   1 +
 include/linux/sprintf.h                            |   1 +
 kernel/resource.c                                  |   5 +-
 mm/kasan/report.c                                  |   4 +-
 mm/khugepaged.c                                    |   4 +-
 mm/zsmalloc.c                                      |   3 +
 net/appletalk/aarp.c                               |  24 ++++-
 net/mptcp/options.c                                |   3 +-
 net/mptcp/pm.c                                     |   8 +-
 net/mptcp/protocol.c                               |  58 +++++++++--
 net/mptcp/protocol.h                               |  27 ++++--
 net/mptcp/subflow.c                                |  30 +++---
 net/sched/sch_qfq.c                                |   7 +-
 net/xfrm/xfrm_interface_core.c                     |   7 +-
 sound/pci/hda/hda_tegra.c                          |  51 ++++++++--
 sound/pci/hda/patch_hdmi.c                         |  20 ++++
 sound/pci/hda/patch_realtek.c                      |   1 +
 .../selftests/bpf/prog_tests/ns_current_pid_tgid.c |  73 --------------
 .../selftests/bpf/progs/test_ns_current_pid_tgid.c |   7 --
 tools/testing/selftests/net/mptcp/Makefile         |   3 +-
 .../selftests/net/mptcp/mptcp_connect_checksum.sh  |   5 +
 .../selftests/net/mptcp/mptcp_connect_mmap.sh      |   5 +
 .../selftests/net/mptcp/mptcp_connect_sendfile.sh  |   5 +
 86 files changed, 681 insertions(+), 450 deletions(-)


