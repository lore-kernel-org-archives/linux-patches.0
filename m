Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C07115689A;
	Mon, 16 Sep 2024 11:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726487971; cv=none; b=pIFkc+eVHI10SL1vIjGYcgyLaMdI92cHD1ynvlhCTBg39fg+1C7kqvDUh07B8GEZ2OEkD4NxAg+YXaw190Fv+ymgq7h27dR1bz31zvtiRbZ8imB15aSOjvKshDvsz9lVsrp/0YT6QlUW2/YNkrZnjmCfpP7CavICX0SQ8J/zT7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726487971; c=relaxed/simple;
	bh=L3czxo4OvCVj53TdCdPmrZZD0MgFwtZAyFiQw6B3u6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EErysZ88jQ4o+H5cqlDzODODy4Lic6Cq9dY1BrqP/M+B4q6FTtnVWh94BtrE5YYpt4bJfEYIAQi0kCXACFv9phYCpmmXINuxRrWcqvfjuwhzKG09DVhzU/qroCfxqzyB/o9VcKggi7puGL37D5bpIxnXu3ae0ncQsCktLe2dm2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCBgFIbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCBgFIbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D03EC4CEC4;
	Mon, 16 Sep 2024 11:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726487970;
	bh=L3czxo4OvCVj53TdCdPmrZZD0MgFwtZAyFiQw6B3u6Q=;
	h=From:To:Cc:Subject:Date:From;
	b=eCBgFIbJRE24wbZu08xXjwr032+xLsOCxR4yym6glKn0NH8Ay/8BA1Hkl8NfrlDd6
	 5nNDeVDdFSrnylx7Edq3A6HRpt3wScwIVwdgCNhjdNMojRwfY7K/Lv8/rH77s1+uI2
	 8Jz5eYO6uh0YutsR9ZjcTpsxXpiN8Uwd3I1qeuSc=
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
Subject: [PATCH 6.1 00/63] 6.1.111-rc1 review
Date: Mon, 16 Sep 2024 13:43:39 +0200
Message-ID: <20240916114221.021192667@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.111-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.111-rc1
X-KernelTest-Deadline: 2024-09-18T11:42+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.111 release.
There are 63 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 18 Sep 2024 11:42:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.111-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.111-rc1

Arseniy Krasnov <avkrasnov@salutedevices.com>
    ASoC: meson: axg-card: fix 'use-after-free'

Mika Westerberg <mika.westerberg@linux.intel.com>
    pinctrl: meteorlake: Add Arrow Lake-H/U ACPI ID

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    drm/i915/guc: prevent a possible int overflow in wq offsets

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: geni-qcom: Fix incorrect free_irq() sequence

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: geni-qcom: Undo runtime PM changes at driver exit time

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    spi: geni-qcom: Convert to platform remove callback returning void

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/atomfirmware: Silence UBSAN warning

T.J. Mercier <tjmercier@google.com>
    dma-buf: heaps: Fix off-by-one in CMA heap fault handler

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    soundwire: stream: Revert "soundwire: stream: fix programming slave ports for non-continous port maps"

Han Xu <han.xu@nxp.com>
    spi: nxp-fspi: fix the KASAN report out-of-bounds bug

Sean Anderson <sean.anderson@linux.dev>
    net: dpaa: Pad packets to ETH_ZLEN

Florian Westphal <fw@strlen.de>
    netfilter: nft_socket: make cgroupsv2 matching work with namespaces

Florian Westphal <fw@strlen.de>
    netfilter: nft_socket: fix sk refcount leaks

Jacky Chou <jacky_chou@aspeedtech.com>
    net: ftgmac100: Enable TX interrupt to avoid TX timeout

Naveen Mamindlapalli <naveenm@marvell.com>
    octeontx2-af: Modify SMQ flush sequence to drop packets

Naveen Mamindlapalli <naveenm@marvell.com>
    octeontx2-af: Set XOFF on other child transmit schedulers during SMQ flush

Muhammad Usama Anjum <usama.anjum@collabora.com>
    fou: fix initialization of grc

Benjamin Poirier <bpoirier@nvidia.com>
    net/mlx5: Fix bridge mode operations when there are no VFs

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5: Verify support for scheduling element and TSAR type

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5: Correct TASR typo into TSAR

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5: Add missing masks and QoS bit masks for scheduling elements

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5: Explicitly set scheduling element and TSAR type

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5e: Add missing link modes to ptys2ethtool_map

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Update the list of the PCI supported devices

Sriram Yagnaraman <sriram.yagnaraman@est.tech>
    igb: Always call igb_xdp_ring_update_tail() under Tx lock

Jacob Keller <jacob.e.keller@intel.com>
    ice: fix accounting for filters shared by multiple VSIs

Patryk Biel <pbiel7@gmail.com>
    hwmon: (pmbus) Conditionally clear individual status bits for pmbus rev >= 1.2

Michal Luczaj <mhal@rbox.co>
    selftests/bpf: Support SOCK_STREAM in unix_inet_redir_to_connected()

peng guo <engguopeng@buaa.edu.cn>
    cxl/core: Fix incorrect vendor debug UUID define

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    eeprom: digsy_mtc: Fix 93xx46 driver probe failure

FUKAUMI Naoki <naoki@radxa.com>
    arm64: dts: rockchip: fix PMIC interrupt pin in pinctrl for ROCK Pi E

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Use kvfree to free memory allocated by kvmalloc

Kunwu Chan <chentao@kylinos.cn>
    pmdomain: ti: Add a null pointer check to the omap_prm_domain_init

Sean Anderson <sean.anderson@linux.dev>
    net: xilinx: axienet: Fix race in axienet_stop

Linus Torvalds <torvalds@linux-foundation.org>
    mm: avoid leaving partial pfn mappings around in error case

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: fix a race condition when accessing recalc_sector

Willem de Bruijn <willemb@google.com>
    net: tighten bad gso csum offset check in virtio_net_hdr

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    minmax: reduce min/max macro expansion in atomisp driver

Quentin Schulz <quentin.schulz@cherry.de>
    arm64: dts: rockchip: override BIOS_DISABLE signal via GPIO hog on RK3399 Puma

Quentin Schulz <quentin.schulz@cherry.de>
    arm64: dts: rockchip: fix eMMC/SPI corruption when audio has been used on RK3399 Puma

Edward Adam Davis <eadavis@qq.com>
    mptcp: pm: Fix uaf in __timer_delete_sync

Hans de Goede <hdegoede@redhat.com>
    platform/x86: panasonic-laptop: Allocate 1 entry extra in the sinf array

Hans de Goede <hdegoede@redhat.com>
    platform/x86: panasonic-laptop: Fix SINF array out of bounds accesses

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Avoid unnecessary rescanning of the per-server delegation list

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix clearing of layout segments in layoutreturn

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/server: fix return value of smb2_open()

Takashi Iwai <tiwai@suse.de>
    Input: i8042 - add Fujitsu Lifebook E756 to i8042 quirk table

Rob Clark <robdclark@chromium.org>
    drm/msm/adreno: Fix error return if missing firmware-name

Maximilian Luz <luzmaximilian@gmail.com>
    platform/surface: aggregator_registry: Add support for Surface Laptop Go 3

Maximilian Luz <luzmaximilian@gmail.com>
    platform/surface: aggregator_registry: Add Support for Surface Pro 10

Anders Roxell <anders.roxell@linaro.org>
    scripts: kconfig: merge_config: config files: add a trailing newline

Dmitry Savin <envelsavinds@gmail.com>
    HID: multitouch: Add support for GT7868Q

Jonathan Denose <jdenose@google.com>
    Input: synaptics - enable SMBus for HP Elitebook 840 G2

Marek Vasut <marex@denx.de>
    Input: ads7846 - ratelimit the spi_sync error message

Jeff Layton <jlayton@kernel.org>
    btrfs: update target inode's ctime on unlink

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/mm: Fix boot warning with hugepages and CONFIG_DEBUG_VIRTUAL

Pawel Dembicki <paweldembicki@gmail.com>
    net: phy: vitesse: repair vsc73xx autonegotiation

Bouke Sybren Haarsma <boukehaarsma23@gmail.com>
    drm: panel-orientation-quirks: Add quirk for Ayn Loki Max

Bouke Sybren Haarsma <boukehaarsma23@gmail.com>
    drm: panel-orientation-quirks: Add quirk for Ayn Loki Zero

Moon Yeounsu <yyyynoom@gmail.com>
    net: ethernet: use ip_hdrlen() instead of bit shift

Foster Snowhill <forst@pen.gy>
    usbnet: ipheth: fix carrier detection in modes 1 and 4

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: override fsids for smb2_query_info()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: override fsids for share path check


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts  |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      |  36 ++++-
 arch/powerpc/kernel/setup-common.c                 |   1 +
 arch/powerpc/mm/mem.c                              |   2 -
 drivers/cxl/cxlmem.h                               |   2 +-
 drivers/dma-buf/heaps/cma_heap.c                   |   2 +-
 drivers/gpu/drm/amd/include/atomfirmware.h         |   4 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |  12 ++
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |   4 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   2 +-
 drivers/hid/hid-ids.h                              |   2 +
 drivers/hid/hid-multitouch.c                       |  33 ++++
 drivers/hwmon/pmbus/pmbus.h                        |   6 +
 drivers/hwmon/pmbus/pmbus_core.c                   |  17 +-
 drivers/input/mouse/synaptics.c                    |   1 +
 drivers/input/serio/i8042-acpipnpio.h              |   9 ++
 drivers/input/touchscreen/ads7846.c                |   2 +-
 drivers/md/dm-integrity.c                          |   4 +-
 drivers/misc/eeprom/digsy_mtc_eeprom.c             |   2 +-
 drivers/net/ethernet/faraday/ftgmac100.h           |   2 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   9 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |   2 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  17 +-
 drivers/net/ethernet/jme.c                         |  10 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  15 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 177 ++++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   4 +
 .../net/ethernet/mellanox/mlx5/core/esw/legacy.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |  51 +++---
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/qos.c      |   7 +
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |   3 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   8 +
 drivers/net/phy/vitesse.c                          |  14 --
 drivers/net/usb/ipheth.c                           |   5 +-
 drivers/pinctrl/intel/pinctrl-meteorlake.c         |   1 +
 .../platform/surface/surface_aggregator_registry.c |   8 +-
 drivers/platform/x86/panasonic-laptop.c            |  58 +++++--
 drivers/soc/ti/omap_prm.c                          |   2 +
 drivers/soundwire/stream.c                         |   8 +-
 drivers/spi/spi-geni-qcom.c                        |  22 ++-
 drivers/spi/spi-nxp-fspi.c                         |   5 +-
 drivers/staging/media/atomisp/pci/sh_css_frac.h    |  26 ++-
 fs/btrfs/inode.c                                   |   1 +
 fs/nfs/delegation.c                                |  15 +-
 fs/nfs/nfs4proc.c                                  |   9 +-
 fs/nfs/pnfs.c                                      |   5 +-
 fs/ntfs3/attrlist.c                                |   4 +-
 fs/ntfs3/bitmap.c                                  |   4 +-
 fs/ntfs3/frecord.c                                 |   4 +-
 fs/ntfs3/super.c                                   |   2 +-
 fs/smb/server/mgmt/share_config.c                  |  15 +-
 fs/smb/server/mgmt/share_config.h                  |   4 +-
 fs/smb/server/mgmt/tree_connect.c                  |   9 +-
 fs/smb/server/mgmt/tree_connect.h                  |   4 +-
 fs/smb/server/smb2pdu.c                            |  11 +-
 fs/smb/server/smb_common.c                         |   9 +-
 fs/smb/server/smb_common.h                         |   2 +
 include/linux/mlx5/mlx5_ifc.h                      |  12 +-
 include/linux/virtio_net.h                         |   3 +-
 mm/memory.c                                        |  27 +++-
 net/ipv4/fou.c                                     |   4 +-
 net/mptcp/pm_netlink.c                             |  13 +-
 net/netfilter/nft_socket.c                         |  48 +++++-
 scripts/kconfig/merge_config.sh                    |   2 +
 sound/soc/meson/axg-card.c                         |   3 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c      |   3 +-
 68 files changed, 642 insertions(+), 177 deletions(-)


