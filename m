Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E3A13DBA0;
	Mon, 16 Sep 2024 12:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488148; cv=none; b=dVpsLpqZ0q88Bqabo2Ri76SjXSzMDipUnL0n/Rb9CkC0Ou9SKRdl8mXqPpRp4i+n78l739HjwTez0Nnm+80W4Q8qfY+3wUnnif6+sUdcJfWMGX61Y4l18H7lRhfOpOOqywsq1ZEgEVkWYxJgIb+YUQZvEeaOLfXFslB3LYi8qng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488148; c=relaxed/simple;
	bh=/8MA5vy7bRo7/VnQPBN5Jk4Cre/gIzNmiW6PA92Ms7k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EaySKyAypeI+1SPI9xlrCKCu6k3A/GBtZ/nJ0PFf6e7MlGPpP+DCyPMRdTt1Dpefwh7VSu97NkuRAp/fa+96JO6o4pzAw+pZrsOy5nROR2q67AkS4/o8dntSgQCt83SM7UVBSHjE6G7y/jTLPlIigvdeFTt13BPpZ8UanDw4Xzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tyz/qtHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tyz/qtHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26507C4CEC4;
	Mon, 16 Sep 2024 12:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488147;
	bh=/8MA5vy7bRo7/VnQPBN5Jk4Cre/gIzNmiW6PA92Ms7k=;
	h=From:To:Cc:Subject:Date:From;
	b=Tyz/qtHL6Rcl/eLpM1SawVzsf/1gu9M0+EhcZn0SGhFSrSFM1ar4DS23jPc52MFSg
	 qhmESWmWMSVCOS0qOrqPdMX+sTaq2nA82l0wNMbKIDVnO6GlvGKN2VYLJ1m/WzE4J7
	 p3yVhewWX48VjS1K4R3+UUVj2DA8+rleoHpYZBAU=
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
Subject: [PATCH 6.10 000/121] 6.10.11-rc1 review
Date: Mon, 16 Sep 2024 13:42:54 +0200
Message-ID: <20240916114228.914815055@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.11-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.10.11-rc1
X-KernelTest-Deadline: 2024-09-18T11:42+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.10.11 release.
There are 121 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 18 Sep 2024 11:42:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.11-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.10.11-rc1

Jameson Thies <jthies@google.com>
    usb: typec: ucsi: Only set number of plug altmodes after registration

Arseniy Krasnov <avkrasnov@salutedevices.com>
    ASoC: meson: axg-card: fix 'use-after-free'

Mika Westerberg <mika.westerberg@linux.intel.com>
    pinctrl: meteorlake: Add Arrow Lake-H/U ACPI ID

David Howells <dhowells@redhat.com>
    cifs: Fix signature miscalculation

Jani Nikula <jani.nikula@intel.com>
    drm/xe/display: fix compat IS_DISPLAY_STEP() range end

Su Hui <suhui@nfschina.com>
    ASoC: codecs: avoid possible garbage value in peb2466_reg_read()

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    drm/i915/guc: prevent a possible int overflow in wq offsets

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: geni-qcom: Fix incorrect free_irq() sequence

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: geni-qcom: Undo runtime PM changes at driver exit time

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: Intel: soc-acpi-intel-mtl-match: add missing empty item

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: Intel: soc-acpi-intel-lnl-match: add missing empty item

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/kprobes: Fix build error when find_module() is not available

Matthew Auld <matthew.auld@intel.com>
    drm/xe/client: add missing bo locking in show_meminfo()

Matthew Auld <matthew.auld@intel.com>
    drm/xe/client: fix deadlock in show_meminfo()

David (Ming Qiang) Wu <David.Wu3@amd.com>
    drm/amd/amdgpu: apply command submission parser for JPEG v2+

David (Ming Qiang) Wu <David.Wu3@amd.com>
    drm/amd/amdgpu: apply command submission parser for JPEG v1

Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
    drm/amd/display: Avoid race between dcn35_set_drr() and dc_state_destruct()

Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
    drm/amd/display: Avoid race between dcn10_set_drr() and dc_state_destruct()

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

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    netlink: specs: mptcp: fix port endianness

Sean Anderson <sean.anderson@linux.dev>
    net: dpaa: Pad packets to ETH_ZLEN

Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
    net: dsa: felix: ignore pending status of TAS module when it's disabled

Jeongjun Park <aha310510@gmail.com>
    net: hsr: prevent NULL pointer dereference in hsr_proxy_announce()

Florian Westphal <fw@strlen.de>
    netfilter: nft_socket: make cgroupsv2 matching work with namespaces

Florian Westphal <fw@strlen.de>
    netfilter: nft_socket: fix sk refcount leaks

Charlie Jenkins <charlie@rivosinc.com>
    riscv: Disable preemption while handling PR_RISCV_CTX_SW_FENCEI_OFF

Alexandre Ghiti <alexghiti@rivosinc.com>
    drivers: perf: Fix smp_processor_id() use in preemptible code

Sean Anderson <sean.anderson@linux.dev>
    selftests: net: csum: Fix checksums for packets with non-zero padding

Tomas Paukrt <tomaspaukrt@email.cz>
    net: phy: dp83822: Fix NULL pointer dereference on DP83825 devices

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

Eric Dumazet <edumazet@google.com>
    net: hsr: remove seqnr_lock

Lukasz Majewski <lukma@denx.de>
    net: hsr: Send supervisory frames to HSR network with ProxyNodeTable data

Michal Luczaj <mhal@rbox.co>
    selftests/bpf: Support SOCK_STREAM in unix_inet_redir_to_connected()

Alison Schofield <alison.schofield@intel.com>
    cxl: Restore XOR'd position bits during address translation

peng guo <engguopeng@buaa.edu.cn>
    cxl/core: Fix incorrect vendor debug UUID define

Li Qiang <liqiang01@kylinos.cn>
    clk/sophgo: Using BUG() instead of unreachable() in mmux_get_parent_id()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    eeprom: digsy_mtc: Fix 93xx46 driver probe failure

Ilya Bakoulin <ilya.bakoulin@amd.com>
    drm/amd/display: Fix FEC_READY write on DP LT

Cruise <cruise.hung@amd.com>
    drm/amd/display: Disable error correction if it's not supported

Xingyu Wu <xingyu.wu@starfivetech.com>
    riscv: dts: starfive: jh7110-common: Fix lower rate of CPUfreq by setting PLL0 rate to 1.5GHz

Dan Carpenter <dan.carpenter@linaro.org>
    firmware: qcom: uefisecapp: Fix deadlock in qcuefi_acquire()

FUKAUMI Naoki <naoki@radxa.com>
    arm64: dts: rockchip: fix PMIC interrupt pin in pinctrl for ROCK Pi E

Kent Overstreet <kent.overstreet@linux.dev>
    bcachefs: Don't delete open files in online fsck

Kent Overstreet <kent.overstreet@linux.dev>
    bcachefs: Revert lockless buffered IO path

Kent Overstreet <kent.overstreet@linux.dev>
    bcachefs: Fix bch2_extents_match() false positive

Linus Torvalds <torvalds@linux-foundation.org>
    mm: avoid leaving partial pfn mappings around in error case

Anirudh Rayabharam (Microsoft) <anirudh@anirudhrb.com>
    x86/hyperv: fix kexec crash due to VP assist page corruption

Dexuan Cui <decui@microsoft.com>
    clocksource: hyper-v: Use lapic timer in a TDX VM without paravisor

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: fix a race condition when accessing recalc_sector

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: fix number of Rx and Tx descriptors

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
    s390/mm: Pin identity mapping base to zero

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/mm: Prevent lowcore vs identity mapping overlap

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/xe: use devm instead of drmm for managed bo

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/xe: fix WA 14018094691

Ngai-Mint Kwan <ngai-mint.kwan@linux.intel.com>
    drm/xe/xe2lpm: Extend Wa_16021639441

Takashi Iwai <tiwai@suse.de>
    Input: i8042 - add Fujitsu Lifebook E756 to i8042 quirk table

Rob Clark <robdclark@chromium.org>
    drm/msm/adreno: Fix error return if missing firmware-name

Sean Anderson <sean.anderson@linux.dev>
    spi: zynqmp-gqspi: Scale timeout by data size

Maximilian Luz <luzmaximilian@gmail.com>
    platform/surface: aggregator_registry: Add support for Surface Laptop 6

Maximilian Luz <luzmaximilian@gmail.com>
    platform/surface: aggregator_registry: Add fan and thermal sensor support for Surface Laptop 5

Maximilian Luz <luzmaximilian@gmail.com>
    platform/surface: aggregator_registry: Add support for Surface Laptop Studio 2

Maximilian Luz <luzmaximilian@gmail.com>
    platform/surface: aggregator_registry: Add support for Surface Laptop Go 3

Maximilian Luz <luzmaximilian@gmail.com>
    platform/surface: aggregator_registry: Add Support for Surface Pro 10

Luke D. Jones <luke@ljones.dev>
    platform/x86: asus-wmi: Add quirk for ROG Ally X

Anders Roxell <anders.roxell@linaro.org>
    scripts: kconfig: merge_config: config files: add a trailing newline

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Eliminate unncessary sched domains rebuilds in hotplug

Felix Kaechele <felix@kaechele.ca>
    Input: edt-ft5x06 - add support for FocalTech FT8201

Dmitry Savin <envelsavinds@gmail.com>
    HID: multitouch: Add support for GT7868Q

Luke D. Jones <luke@ljones.dev>
    hid-asus: add ROG Ally X prod ID to quirk list

Jonathan Denose <jdenose@google.com>
    Input: synaptics - enable SMBus for HP Elitebook 840 G2

Marek Vasut <marex@denx.de>
    Input: ads7846 - ratelimit the spi_sync error message

Jeff Layton <jlayton@kernel.org>
    btrfs: update target inode's ctime on unlink

Peiyang Wang <wangpeiyang1@huawei.com>
    net: hns3: use correct release function during uninitialization

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu: Update kmd_fw_shared for VCN5

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

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: Set sensible cursor width/height values to fix crash

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: Fix cable registration

Jameson Thies <jthies@google.com>
    usb: typec: ucsi: Always set number of alternate modes


-------------

Diffstat:

 Documentation/netlink/specs/mptcp_pm.yaml          |   1 -
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts  |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      |  36 ++++-
 arch/powerpc/kernel/setup-common.c                 |   1 +
 arch/powerpc/mm/mem.c                              |   2 -
 arch/riscv/boot/dts/starfive/jh7110-common.dtsi    |   6 +
 arch/riscv/mm/cacheflush.c                         |  12 +-
 arch/s390/Kconfig                                  |  13 ++
 arch/s390/boot/startup.c                           |   3 +-
 arch/s390/kernel/setup.c                           |  19 ++-
 arch/x86/hyperv/hv_init.c                          |   5 +-
 arch/x86/include/asm/mshyperv.h                    |   1 -
 arch/x86/kernel/cpu/mshyperv.c                     |  20 ++-
 drivers/clk/sophgo/clk-cv18xx-ip.c                 |   2 +-
 drivers/clocksource/hyperv_timer.c                 |  16 ++-
 drivers/cxl/acpi.c                                 |  40 ++++++
 drivers/cxl/core/region.c                          |  23 ++--
 drivers/cxl/cxl.h                                  |   3 +
 drivers/cxl/cxlmem.h                               |   2 +-
 drivers/dma-buf/heaps/cma_heap.c                   |   2 +-
 drivers/firmware/qcom/qcom_qseecom_uefisecapp.c    |   4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h            |   5 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.c             |  76 ++++++++++-
 drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.h             |  11 ++
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c             |  63 ++++++++-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.h             |   6 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c             |   2 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c             |   1 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c             |   1 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.h             |   1 -
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c           |  57 +-------
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.h           |   7 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c           |   1 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c           |   3 +-
 .../drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c    |  20 +--
 .../drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c    |  20 +--
 .../amd/display/dc/link/protocols/link_dp_phy.c    |  53 ++++----
 drivers/gpu/drm/amd/include/atomfirmware.h         |   4 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |  12 ++
 drivers/gpu/drm/drm_syncobj.c                      |  17 ++-
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |   4 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |   4 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/ram.h       |   2 +
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramgp100.c  |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramgp102.c  |   1 +
 drivers/gpu/drm/xe/compat-i915-headers/i915_drv.h  |   2 +-
 drivers/gpu/drm/xe/xe_bo.c                         |   6 +-
 drivers/gpu/drm/xe/xe_drm_client.c                 |  45 ++++++-
 drivers/gpu/drm/xe/xe_gsc.c                        |   4 +-
 drivers/gpu/drm/xe/xe_wa.c                         |  10 ++
 drivers/hid/hid-asus.c                             |   3 +
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-multitouch.c                       |  33 +++++
 drivers/hwmon/pmbus/pmbus.h                        |   6 +
 drivers/hwmon/pmbus/pmbus_core.c                   |  17 ++-
 drivers/input/mouse/synaptics.c                    |   1 +
 drivers/input/serio/i8042-acpipnpio.h              |   9 ++
 drivers/input/touchscreen/ads7846.c                |   2 +-
 drivers/input/touchscreen/edt-ft5x06.c             |   6 +
 drivers/md/dm-integrity.c                          |   4 +-
 drivers/misc/eeprom/digsy_mtc_eeprom.c             |   2 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |  11 +-
 drivers/net/ethernet/faraday/ftgmac100.h           |   2 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   9 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |  15 ++-
 drivers/net/ethernet/intel/ice/ice_switch.c        |   4 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  17 ++-
 drivers/net/ethernet/jme.c                         |  10 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   3 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  59 ++++++--
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  10 ++
 .../net/ethernet/mellanox/mlx5/core/esw/legacy.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |  51 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/qos.c      |   7 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h       |   6 +-
 drivers/net/phy/dp83822.c                          |  35 +++--
 drivers/net/phy/vitesse.c                          |  14 --
 drivers/net/usb/ipheth.c                           |  18 +--
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   2 +-
 drivers/perf/riscv_pmu_sbi.c                       |   7 +-
 drivers/pinctrl/intel/pinctrl-meteorlake.c         |   1 +
 .../platform/surface/surface_aggregator_registry.c |  58 +++++++-
 drivers/platform/x86/asus-wmi.c                    |  16 ++-
 drivers/platform/x86/panasonic-laptop.c            |  58 ++++++--
 drivers/soundwire/stream.c                         |   8 +-
 drivers/spi/spi-geni-qcom.c                        |  17 ++-
 drivers/spi/spi-nxp-fspi.c                         |   5 +-
 drivers/spi/spi-zynqmp-gqspi.c                     |  30 ++++-
 drivers/staging/media/atomisp/pci/sh_css_frac.h    |  26 +++-
 drivers/usb/typec/ucsi/ucsi.c                      |  44 +++---
 drivers/usb/typec/ucsi/ucsi.h                      |   1 -
 fs/bcachefs/extents.c                              |  23 +++-
 fs/bcachefs/fs-io-buffered.c                       | 149 ++++++---------------
 fs/bcachefs/fs.c                                   |   8 ++
 fs/bcachefs/fs.h                                   |   7 +
 fs/bcachefs/fsck.c                                 |  18 +++
 fs/btrfs/inode.c                                   |   1 +
 fs/nfs/delegation.c                                |  15 +--
 fs/nfs/nfs4proc.c                                  |   9 +-
 fs/nfs/pnfs.c                                      |   5 +-
 fs/smb/client/cifsencrypt.c                        |   2 +-
 fs/smb/server/mgmt/share_config.c                  |  15 ++-
 fs/smb/server/mgmt/share_config.h                  |   4 +-
 fs/smb/server/mgmt/tree_connect.c                  |   9 +-
 fs/smb/server/mgmt/tree_connect.h                  |   4 +-
 fs/smb/server/smb2pdu.c                            |  11 +-
 fs/smb/server/smb_common.c                         |   9 +-
 fs/smb/server/smb_common.h                         |   2 +
 include/linux/mlx5/mlx5_ifc.h                      |  12 +-
 include/linux/virtio_net.h                         |   3 +-
 kernel/cgroup/cpuset.c                             |  33 ++---
 kernel/trace/trace_kprobe.c                        |  25 +++-
 kernel/trace/trace_osnoise.c                       |  10 +-
 mm/memory.c                                        |  27 +++-
 net/hsr/hsr_device.c                               | 102 +++++++++-----
 net/hsr/hsr_forward.c                              |  41 +++++-
 net/hsr/hsr_framereg.c                             |  12 ++
 net/hsr/hsr_framereg.h                             |   2 +
 net/hsr/hsr_main.h                                 |  10 +-
 net/hsr/hsr_netlink.c                              |   3 +-
 net/ipv4/fou_core.c                                |   4 +-
 net/mptcp/pm_netlink.c                             |  13 +-
 net/netfilter/nft_socket.c                         |  48 ++++++-
 scripts/kconfig/merge_config.sh                    |   2 +
 sound/soc/codecs/peb2466.c                         |   3 +-
 sound/soc/intel/common/soc-acpi-intel-lnl-match.c  |   1 +
 sound/soc/intel/common/soc-acpi-intel-mtl-match.c  |   1 +
 sound/soc/meson/axg-card.c                         |   3 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c      |   3 +-
 tools/testing/selftests/net/lib/csum.c             |  16 ++-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   4 +-
 135 files changed, 1378 insertions(+), 587 deletions(-)


