Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B4215665C;
	Mon, 16 Sep 2024 12:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488527; cv=none; b=fWUS9guYMX/5Y5xihAPpiV65iNVW8b5/5dBXF7mLYXq1Ewx83GOYFCBRt79jkp2IuGJ/q8StTYjEmjht/6jd4sk3mfbbyzit3rqT7HQDC0Ltb4lskJF0zJm1k8ZgCtUYS7Fq8gTYos9vsKZez3GUttKCIhvNggnlqpWy7+UAHp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488527; c=relaxed/simple;
	bh=yDRHOBw8Z6+K4W3a7ZthNvxNLFF/qViWg47fXNB1Mhw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tl96LYESrcfdh88lAP1iDOW/IG4IE9vmWLDK28n2MAQW/4M8/WE9Mj2HIFlxpy8gnhH2wmaGSE0o4chgmuyBwoEW0aA3l6zW70T3CpSYhptLoomLYAZH/xgsCC3IyLrGr6EW0jM5Jp7x2aSQLOMYPLN6WgQp+irmaNw7nCo8VvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PoFhHFg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PoFhHFg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11C6C4CEC4;
	Mon, 16 Sep 2024 12:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488527;
	bh=yDRHOBw8Z6+K4W3a7ZthNvxNLFF/qViWg47fXNB1Mhw=;
	h=From:To:Cc:Subject:Date:From;
	b=PoFhHFg85mg8s9w0/p3kNEQTxpxhevPb/dJFaBAVLGsWHjAVznTwLMVb1DnikILIw
	 kAkxiCjpqqeYfoLTlqPHyKE3Qm5hxbgKKibi4zzioDUktlDxBL5RhRUUyGw7G89wwO
	 CFcL+GMvaXW5iiBGnvFg8KjJ+GmYBg48EBgS1HPs=
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
Subject: [PATCH 6.6 00/91] 6.6.52-rc1 review
Date: Mon, 16 Sep 2024 13:43:36 +0200
Message-ID: <20240916114224.509743970@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.52-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.52-rc1
X-KernelTest-Deadline: 2024-09-18T11:42+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.52 release.
There are 91 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 18 Sep 2024 11:42:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.52-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.52-rc1

William Qiu <william.qiu@starfivetech.com>
    riscv: dts: starfive: add assigned-clock* to limit frquency

Arseniy Krasnov <avkrasnov@salutedevices.com>
    ASoC: meson: axg-card: fix 'use-after-free'

Mika Westerberg <mika.westerberg@linux.intel.com>
    pinctrl: meteorlake: Add Arrow Lake-H/U ACPI ID

David Howells <dhowells@redhat.com>
    cifs: Fix signature miscalculation

Su Hui <suhui@nfschina.com>
    ASoC: codecs: avoid possible garbage value in peb2466_reg_read()

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    drm/i915/guc: prevent a possible int overflow in wq offsets

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: geni-qcom: Fix incorrect free_irq() sequence

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: geni-qcom: Undo runtime PM changes at driver exit time

David (Ming Qiang) Wu <David.Wu3@amd.com>
    drm/amd/amdgpu: apply command submission parser for JPEG v1

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/atomfirmware: Silence UBSAN warning

Ben Skeggs <bskeggs@nvidia.com>
    drm/nouveau/fb: restore init() for ramgp102

T.J. Mercier <tjmercier@google.com>
    dma-buf: heaps: Fix off-by-one in CMA heap fault handler

T.J. Mercier <tjmercier@google.com>
    drm/syncobj: Fix syncobj leak in drm_syncobj_eventfd_ioctl

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    soundwire: stream: Revert "soundwire: stream: fix programming slave ports for non-continous port maps"

Han Xu <han.xu@nxp.com>
    spi: nxp-fspi: fix the KASAN report out-of-bounds bug

Steven Rostedt <rostedt@goodmis.org>
    tracing/osnoise: Fix build when timerlat is not enabled

Sean Anderson <sean.anderson@linux.dev>
    net: dpaa: Pad packets to ETH_ZLEN

Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
    net: dsa: felix: ignore pending status of TAS module when it's disabled

Florian Westphal <fw@strlen.de>
    netfilter: nft_socket: make cgroupsv2 matching work with namespaces

Florian Westphal <fw@strlen.de>
    netfilter: nft_socket: fix sk refcount leaks

Sean Anderson <sean.anderson@linux.dev>
    selftests: net: csum: Fix checksums for packets with non-zero padding

Jacky Chou <jacky_chou@aspeedtech.com>
    net: ftgmac100: Enable TX interrupt to avoid TX timeout

Naveen Mamindlapalli <naveenm@marvell.com>
    octeontx2-af: Modify SMQ flush sequence to drop packets

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
    net/mlx5e: Add missing link mode to ptys2ext_ethtool_map

Patrisious Haddad <phaddad@nvidia.com>
    IB/mlx5: Rename 400G_8X speed to comply to naming convention

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5e: Add missing link modes to ptys2ethtool_map

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Update the list of the PCI supported devices

Sriram Yagnaraman <sriram.yagnaraman@est.tech>
    igb: Always call igb_xdp_ring_update_tail() under Tx lock

Michal Schmidt <mschmidt@redhat.com>
    ice: fix VSI lists confusion when adding VLANs

Jacob Keller <jacob.e.keller@intel.com>
    ice: fix accounting for filters shared by multiple VSIs

Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>
    ice: Fix lldp packets dropping after changing the number of channels

Patryk Biel <pbiel7@gmail.com>
    hwmon: (pmbus) Conditionally clear individual status bits for pmbus rev >= 1.2

Michal Luczaj <mhal@rbox.co>
    selftests/bpf: Support SOCK_STREAM in unix_inet_redir_to_connected()

peng guo <engguopeng@buaa.edu.cn>
    cxl/core: Fix incorrect vendor debug UUID define

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    eeprom: digsy_mtc: Fix 93xx46 driver probe failure

Ilya Bakoulin <ilya.bakoulin@amd.com>
    drm/amd/display: Fix FEC_READY write on DP LT

Cruise <cruise.hung@amd.com>
    drm/amd/display: Disable error correction if it's not supported

FUKAUMI Naoki <naoki@radxa.com>
    arm64: dts: rockchip: fix PMIC interrupt pin in pinctrl for ROCK Pi E

Sean Anderson <sean.anderson@linux.dev>
    net: xilinx: axienet: Fix race in axienet_stop

Linus Torvalds <torvalds@linux-foundation.org>
    mm: avoid leaving partial pfn mappings around in error case

Anirudh Rayabharam (Microsoft) <anirudh@anirudhrb.com>
    x86/hyperv: fix kexec crash due to VP assist page corruption

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

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: restrict fullmesh endp on 1st sf

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

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/mm: Prevent lowcore vs identity mapping overlap

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

Peiyang Wang <wangpeiyang1@huawei.com>
    net: hns3: use correct release function during uninitialization

Bert Karwatzki <spasswolf@web.de>
    wifi: mt76: mt7921: fix NULL pointer access in mt7921_ipv6_addr_change

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

Foster Snowhill <forst@pen.gy>
    usbnet: ipheth: do not stop RX on failing RX callback

Foster Snowhill <forst@pen.gy>
    usbnet: ipheth: drop RX URBs with no payload

Foster Snowhill <forst@pen.gy>
    usbnet: ipheth: remove extraneous rx URB length check

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: override fsids for smb2_query_info()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: override fsids for share path check

John Thomson <git@johnthomson.fastmail.com.au>
    nvmem: u-boot-env: error if NVMEM device is too small

Rafał Miłecki <rafal@milecki.pl>
    nvmem: u-boot-env: improve coding style

Rafał Miłecki <rafal@milecki.pl>
    nvmem: u-boot-env: use nvmem device helpers

Rafał Miłecki <rafal@milecki.pl>
    nvmem: u-boot-env: use nvmem_add_one_cell() nvmem subsystem helper

Rafał Miłecki <rafal@milecki.pl>
    nvmem: core: add nvmem_dev_size() helper

Dumitru Ceclan <mitrutzceclan@gmail.com>
    iio: adc: ad7124: fix DT configuration parsing

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7124: Switch from of specific to fwnode based property handling

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    device property: Introduce device_for_each_child_node_scoped()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    device property: Add cleanup.h based fwnode_handle_put() scope based cleanup.


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts  |  2 +-
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      | 36 ++++++++-
 arch/powerpc/kernel/setup-common.c                 |  1 +
 arch/powerpc/mm/mem.c                              |  2 -
 .../dts/starfive/jh7110-starfive-visionfive-2.dtsi |  4 +
 arch/s390/kernel/setup.c                           | 19 ++++-
 arch/x86/hyperv/hv_init.c                          |  5 +-
 arch/x86/include/asm/mshyperv.h                    |  1 -
 arch/x86/kernel/cpu/mshyperv.c                     |  4 +-
 drivers/cxl/cxlmem.h                               |  2 +-
 drivers/dma-buf/heaps/cma_heap.c                   |  2 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.c             | 76 +++++++++++++++++-
 drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.h             | 11 +++
 .../amd/display/dc/link/protocols/link_dp_phy.c    | 53 ++++++-------
 drivers/gpu/drm/amd/include/atomfirmware.h         |  4 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     | 12 +++
 drivers/gpu/drm/drm_syncobj.c                      | 17 +++-
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |  4 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |  2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/ram.h       |  2 +
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramgp100.c  |  2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramgp102.c  |  1 +
 drivers/hid/hid-ids.h                              |  2 +
 drivers/hid/hid-multitouch.c                       | 33 ++++++++
 drivers/hwmon/pmbus/pmbus.h                        |  6 ++
 drivers/hwmon/pmbus/pmbus_core.c                   | 17 +++-
 drivers/iio/adc/ad7124.c                           | 58 ++++++--------
 drivers/infiniband/hw/mlx5/main.c                  |  2 +-
 drivers/input/mouse/synaptics.c                    |  1 +
 drivers/input/serio/i8042-acpipnpio.h              |  9 +++
 drivers/input/touchscreen/ads7846.c                |  2 +-
 drivers/md/dm-integrity.c                          |  4 +-
 drivers/misc/eeprom/digsy_mtc_eeprom.c             |  2 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             | 11 ++-
 drivers/net/ethernet/faraday/ftgmac100.h           |  2 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |  9 ++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           | 15 ++--
 drivers/net/ethernet/intel/ice/ice_switch.c        |  4 +-
 drivers/net/ethernet/intel/igb/igb_main.c          | 17 +++-
 drivers/net/ethernet/jme.c                         | 10 +--
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  3 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 59 +++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   | 10 +++
 .../net/ethernet/mellanox/mlx5/core/esw/legacy.c   |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  | 51 +++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/qos.c      |  7 ++
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |  3 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  8 ++
 drivers/net/phy/vitesse.c                          | 14 ----
 drivers/net/usb/ipheth.c                           | 18 +++--
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  2 +-
 drivers/nvmem/core.c                               | 13 ++++
 drivers/nvmem/u-boot-env.c                         | 91 +++++++++++-----------
 drivers/pinctrl/intel/pinctrl-meteorlake.c         |  1 +
 .../platform/surface/surface_aggregator_registry.c |  8 +-
 drivers/platform/x86/panasonic-laptop.c            | 58 +++++++++++---
 drivers/soundwire/stream.c                         |  8 +-
 drivers/spi/spi-geni-qcom.c                        | 17 ++--
 drivers/spi/spi-nxp-fspi.c                         |  5 +-
 drivers/staging/media/atomisp/pci/sh_css_frac.h    | 26 +++++--
 fs/btrfs/inode.c                                   |  1 +
 fs/nfs/delegation.c                                | 15 ++--
 fs/nfs/nfs4proc.c                                  |  9 ++-
 fs/nfs/pnfs.c                                      |  5 +-
 fs/smb/client/cifsencrypt.c                        |  2 +-
 fs/smb/server/mgmt/share_config.c                  | 15 +++-
 fs/smb/server/mgmt/share_config.h                  |  4 +-
 fs/smb/server/mgmt/tree_connect.c                  |  9 ++-
 fs/smb/server/mgmt/tree_connect.h                  |  4 +-
 fs/smb/server/smb2pdu.c                            | 11 ++-
 fs/smb/server/smb_common.c                         |  9 ++-
 fs/smb/server/smb_common.h                         |  2 +
 include/linux/mlx5/mlx5_ifc.h                      | 12 ++-
 include/linux/mlx5/port.h                          |  2 +-
 include/linux/nvmem-consumer.h                     |  1 +
 include/linux/property.h                           |  8 ++
 include/linux/virtio_net.h                         |  3 +-
 kernel/trace/trace_osnoise.c                       | 10 +--
 mm/memory.c                                        | 27 +++++--
 net/ipv4/fou_core.c                                |  4 +-
 net/mptcp/pm_netlink.c                             | 13 +++-
 net/netfilter/nft_socket.c                         | 48 ++++++++++--
 scripts/kconfig/merge_config.sh                    |  2 +
 sound/soc/codecs/peb2466.c                         |  3 +-
 sound/soc/meson/axg-card.c                         |  3 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c      |  3 +-
 tools/testing/selftests/net/csum.c                 | 16 +++-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  4 +-
 92 files changed, 797 insertions(+), 329 deletions(-)


