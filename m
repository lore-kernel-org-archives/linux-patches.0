Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2FB19E992;
	Tue, 12 Nov 2024 10:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407038; cv=none; b=Z41GElfzUQ37tunzOCrH2nZ5TkMzvJ7Mg0LY+ohmXIUDLBBKnSKw6OVM3qoPYG68bvzIjJTTdzMXxR70J8XqtwHr8JofPfmuGOQByAexN5MzoF0k/cQmoW7DlVEM7BRrGBOtXUL+72f//chzOfVNT0FG/TV+4pQ7pLYut8nasm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407038; c=relaxed/simple;
	bh=jE4/sa13i1hdAfyxuEhnqBwmX7UdPPCAlMfJgfk9nBI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tjRrncY4kpI0X9sNiqTzVy9C8Ez8wwjI9VwjqOeJnzUyMdtxp6OUtCPC7buGxYYkqy8u8DGnEKU019n72Oo6bnYwLGpyCUQ8ZDBAfJyd0gb+KTdL8G5jlxFNkuRl60UqSekoWbThmXWg9ezRuPkGeZgpopZwoD1o9g9uiLFEVr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpLv9ndb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpLv9ndb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A18C4CECD;
	Tue, 12 Nov 2024 10:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407038;
	bh=jE4/sa13i1hdAfyxuEhnqBwmX7UdPPCAlMfJgfk9nBI=;
	h=From:To:Cc:Subject:Date:From;
	b=cpLv9ndbCaom9B74mdmaCGeHSXbghK/Fu07rHaRf4aIghiREnrm3+lN1ilRZIS9FT
	 HWCnSHX2Kt/1BJCmfUldgAWqbBY45m7YC/34yd4c72IJe3an9nUXaYhLqOw5bH85O0
	 PHSEpP3Gfd4/nXeYvsRO4evQ86jmhTFGL4sSYvEU=
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
Subject: [PATCH 5.15 00/76] 5.15.172-rc1 review
Date: Tue, 12 Nov 2024 11:20:25 +0100
Message-ID: <20241112101839.777512218@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.172-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.172-rc1
X-KernelTest-Deadline: 2024-11-14T10:18+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.172 release.
There are 76 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 14 Nov 2024 10:18:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.172-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.172-rc1

Jan Schär <jan@jschaer.ch>
    ALSA: usb-audio: Add endianness annotations

Hyunwoo Kim <v4bel@theori.io>
    vsock/virtio: Initialization of the dangling pointer occurring in vsk->trans

Hyunwoo Kim <v4bel@theori.io>
    hv_sock: Initializing vsk->trans to NULL to prevent a dangling pointer

Dan Carpenter <dan.carpenter@linaro.org>
    ACPI: PRM: Clean up guid type in struct prm_handler_info

Jan Schär <jan@jschaer.ch>
    ALSA: usb-audio: Add quirks for Dell WD19 dock

Jan Schär <jan@jschaer.ch>
    ALSA: usb-audio: Support jack detection on Dell dock

Andrei Vagin <avagin@google.com>
    ucounts: fix counter leak in inc_rlimit_get_ucounts()

Andrew Kanner <andrew.kanner@gmail.com>
    ocfs2: remove entry once instead of null-ptr-dereference in ocfs2_xa_remove()

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v3: Force propagation of the active state with a read-back

Benoît Monin <benoit.monin@gmx.fr>
    USB: serial: option: add Quectel RG650V

Reinhard Speyerer <rspmn@arcor.de>
    USB: serial: option: add Fibocom FG132 0x0112 composition

Jack Wu <wojackbb@gmail.com>
    USB: serial: qcserial: add support for Sierra Wireless EM86xx

Dan Carpenter <dan.carpenter@linaro.org>
    USB: serial: io_edgeport: fix use after free in debug printk

Dan Carpenter <dan.carpenter@linaro.org>
    usb: typec: fix potential out of bounds in ucsi_ccg_update_set_new_cam_cmd()

Roger Quadros <rogerq@kernel.org>
    usb: dwc3: fix fault at system suspend if device was already runtime suspended

Zijun Hu <quic_zijuhu@quicinc.com>
    usb: musb: sunxi: Fix accessing an released usb phy

Qi Xi <xiqi2@huawei.com>
    fs/proc: fix compile warning about variable 'vmcore_mmap_ops'

Benoit Sevens <bsevens@google.com>
    media: uvcvideo: Skip parsing frames of type UVC_VS_UNDEFINED in uvc_parse_format

Eric Dumazet <edumazet@google.com>
    net: do not delay dst_entries_add() in dst_release()

Ahmed Zaki <ahmed.zaki@intel.com>
    ice: Add a per-VF limit on number of FDIR filters

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: xmit: make sure we have at least eth header len bytes

Filipe Manana <fdmanana@suse.com>
    btrfs: reinitialize delayed ref list after deleting it from the list

Roberto Sassu <roberto.sassu@huawei.com>
    nfs: Fix KMSAN warning in decode_getfattr_attrs()

Jens Axboe <axboe@kernel.dk>
    io_uring/rw: fix missing NOWAIT check for O_DIRECT start write

Amir Goldstein <amir73il@gmail.com>
    io_uring: use kiocb_{start,end}_write() helpers

Amir Goldstein <amir73il@gmail.com>
    fs: create kiocb_{start,end}_write() helpers

Amir Goldstein <amir73il@gmail.com>
    io_uring: rename kiocb_end_write() local helper

Benjamin Segall <bsegall@google.com>
    posix-cpu-timers: Clear TICK_DEP_BIT_POSIX_TIMER on clone

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add quirk for HP 320 FHD Webcam

Zichen Xie <zichenxie0106@gmail.com>
    dm-unstriped: cast an operand to sector_t to prevent potential uint32_t overflow

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: fix potential out-of-bounds access on the first resume

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: optimize dirty bit checking with find_next_bit when resizing

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: fix out-of-bounds access to the dirty bitset when resizing

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: correct the number of origin blocks to match the target length

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    thermal/drivers/qcom/lmh: Remove false lockdep backtrace

Antonio Quartulli <antonio@mandelbit.com>
    drm/amdgpu: prevent NULL pointer dereference if ATIF is not supported

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: add missing size check in amdgpu_debugfs_gprwave_read()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: Adjust debugfs eviction and IB access permissions

Erik Schumacher <erik.schumacher@iris-sensing.com>
    pwm: imx-tpm: Use correct MODULO value for EPWM mode

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: v4l2-ctrls-api: fix error handling for v4l2_g_ctrl()

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: v4l2-tpg: prevent the risk of a division by zero

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: pulse8-cec: fix data timestamp at pulse8_setup()

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: cx24116: prevent overflows on SNR calculus

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: s5p-jpeg: prevent buffer overflows

Amelie Delaunay <amelie.delaunay@foss.st.com>
    ASoC: stm32: spdifrx: fix dma channel release in stm32_spdifrx_remove

Murad Masimov <m.masimov@maxima.ru>
    ALSA: firewire-lib: fix return value on fail in amdtp_tscm_init()

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    scsi: sd_zbc: Use kvzalloc() to allocate REPORT ZONES buffer

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: adv7604: prevent underflow condition when reporting colorspace

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: dvb_frontend: don't play tricks with underflow values

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: dvbdev: prevent the risk of out of memory access

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: stb0899_algo: initialize cfr before using it

Jarosław Janik <jaroslaw.janik@gmail.com>
    Revert "ALSA: hda/conexant: Mute speakers at suspend / shutdown"

Johan Jonker <jbx6244@gmail.com>
    net: arc: fix the device for dma_map_single/dma_unmap_single

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    net: stmmac: Fix unbalanced IRQ wake disable warning on single irq case

Diogo Silva <diogompaissilva@gmail.com>
    net: phy: ti: add PHY_RST_AFTER_CLK_EN flag

Peiyang Wang <wangpeiyang1@huawei.com>
    net: hns3: fix kernel crash when uninstalling driver

Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    i40e: fix race condition by adding filter's intermediate sync state

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: c_can: fix {rx,tx}_errors statistics

Xin Long <lucien.xin@gmail.com>
    sctp: properly validate chunk size in sctp_sf_ootb()

Wei Fang <wei.fang@nxp.com>
    net: enetc: set MAC address to the VF net_device

Chen Ridong <chenridong@huawei.com>
    security/keys: fix slab-out-of-bounds in key_task_permission

Mike Snitzer <snitzer@kernel.org>
    nfs: avoid i_lock contention in nfs_clear_invalid_mapping

NeilBrown <neilb@suse.de>
    NFSv3: handle out-of-order write replies.

Benjamin Coddington <bcodding@redhat.com>
    NFS: Add a tracepoint to show the results of nfs_set_cache_invalid()

NeilBrown <neilb@suse.de>
    NFSv3: only use NFS timeout for MOUNT when protocols are compatible

Jiri Kosina <jkosina@suse.com>
    HID: core: zero-initialize the report buffer

Heiko Stuebner <heiko@sntech.de>
    ARM: dts: rockchip: Fix the realtek audio codec on rk3036-kylin

Heiko Stuebner <heiko@sntech.de>
    ARM: dts: rockchip: Fix the spi controller on rk3036

Heiko Stuebner <heiko@sntech.de>
    ARM: dts: rockchip: drop grf reference from rk3036 hdmi

Heiko Stuebner <heiko@sntech.de>
    ARM: dts: rockchip: fix rk3036 acodec node

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp: correct sdhc ipg clk

Heiko Stuebner <heiko@sntech.de>
    arm64: dts: rockchip: Fix LED triggers on rk3308-roc-cc

Heiko Stuebner <heiko@sntech.de>
    arm64: dts: rockchip: Remove #cooling-cells from fan on Theobroma lion

Heiko Stuebner <heiko@sntech.de>
    arm64: dts: rockchip: Fix bluetooth properties on Rock960 boards

Diederik de Haas <didi.debian@cknow.org>
    arm64: dts: rockchip: Remove hdmi's 2nd interrupt on rk3328

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: rockchip: Fix rt5651 compatible value on rk3399-sapphire-excavator


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/rk3036-kylin.dts                 |   4 +-
 arch/arm/boot/dts/rk3036.dtsi                      |  14 +-
 arch/arm64/boot/dts/freescale/imx8mp.dtsi          |   6 +-
 arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts     |   4 +-
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |   3 +-
 arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi      |   1 -
 arch/arm64/boot/dts/rockchip/rk3399-rock960.dtsi   |   2 +-
 .../dts/rockchip/rk3399-sapphire-excavator.dts     |   2 +-
 drivers/acpi/prmt.c                                |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |   8 +-
 drivers/hid/hid-core.c                             |   2 +-
 drivers/irqchip/irq-gic-v3.c                       |   7 +
 drivers/md/dm-cache-target.c                       |  35 ++---
 drivers/md/dm-unstripe.c                           |   4 +-
 drivers/media/cec/usb/pulse8/pulse8-cec.c          |   2 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      |   3 +
 drivers/media/dvb-core/dvb_frontend.c              |   4 +-
 drivers/media/dvb-core/dvbdev.c                    |  17 ++-
 drivers/media/dvb-frontends/cx24116.c              |   7 +-
 drivers/media/dvb-frontends/stb0899_algo.c         |   2 +-
 drivers/media/i2c/adv7604.c                        |  26 ++--
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  17 ++-
 drivers/media/usb/uvc/uvc_driver.c                 |   2 +-
 drivers/media/v4l2-core/v4l2-ctrls-api.c           |  17 ++-
 drivers/net/can/c_can/c_can_main.c                 |   7 +-
 drivers/net/ethernet/arc/emac_main.c               |  27 ++--
 drivers/net/ethernet/freescale/enetc/enetc_vf.c    |   9 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        |   5 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   1 +
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c     |   1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  12 +-
 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c  |   2 +-
 drivers/net/ethernet/intel/ice/ice_fdir.h          |   3 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |  16 ++
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.h |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   1 +
 drivers/net/phy/dp83848.c                          |   2 +
 drivers/pwm/pwm-imx-tpm.c                          |   4 +-
 drivers/scsi/sd_zbc.c                              |   3 +-
 drivers/thermal/qcom/lmh.c                         |   7 +
 drivers/usb/dwc3/core.c                            |  25 ++-
 drivers/usb/musb/sunxi.c                           |   2 -
 drivers/usb/serial/io_edgeport.c                   |   8 +-
 drivers/usb/serial/option.c                        |   6 +
 drivers/usb/serial/qcserial.c                      |   2 +
 drivers/usb/typec/ucsi/ucsi_ccg.c                  |   2 +
 fs/btrfs/delayed-ref.c                             |   2 +-
 fs/nfs/inode.c                                     | 126 +++++++++++++--
 fs/nfs/nfstrace.h                                  |   1 +
 fs/nfs/super.c                                     |  10 +-
 fs/ocfs2/xattr.c                                   |   3 +-
 fs/proc/vmcore.c                                   |   9 +-
 include/linux/fs.h                                 |  36 +++++
 include/linux/nfs_fs.h                             |  47 ++++++
 include/linux/tick.h                               |   8 +
 io_uring/io_uring.c                                |  50 +++---
 kernel/fork.c                                      |   2 +
 kernel/ucount.c                                    |   3 +-
 net/bridge/br_device.c                             |   5 +
 net/core/dst.c                                     |  17 ++-
 net/sctp/sm_statefuns.c                            |   2 +-
 net/vmw_vsock/hyperv_transport.c                   |   1 +
 net/vmw_vsock/virtio_transport_common.c            |   1 +
 security/keys/keyring.c                            |   7 +-
 sound/firewire/tascam/amdtp-tascam.c               |   2 +-
 sound/pci/hda/patch_conexant.c                     |   2 -
 sound/soc/stm/stm32_spdifrx.c                      |   2 +-
 sound/usb/mixer.c                                  |   1 +
 sound/usb/mixer_quirks.c                           | 170 +++++++++++++++++++++
 sound/usb/quirks.c                                 |   2 +
 72 files changed, 674 insertions(+), 180 deletions(-)


