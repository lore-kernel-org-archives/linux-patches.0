Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAB620ADFD;
	Tue, 12 Nov 2024 10:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407621; cv=none; b=YHGhYsfEWKPnVJ0qBG/p7wmEE8gn8/bhDR8gQdLWrenWxeNH15t136Wz67NM+wh1OXbUnXGyq89P1R9eVFlqhvkPW+QPdch+CBaXPB2mdaxTBRIVb8CWgsYozonF8w6owp6a4Vp/NwnmOIEfzIGuVmL3245uE4U+Hfh3euzrg/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407621; c=relaxed/simple;
	bh=g5LpoqAQ4OkGB5oepG7SKXcmKz/WJ/FE87hQqFVzKw8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iYrJtuAaGCwzUXHoZKW3OUTHNADzM1mnUqi9Dexus6EaKfA8e1b0kW5+fBFg66Zm447zIwd4cZLcs4XleeLFLYyIf67xtDTcPGhk3b61Wy7khaURs+6oGNl6TT0chPrQK3Zxh20zl0Be/bo/BGYldI2WIW0itpTtFczxOAzXXYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G1nLiKtt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G1nLiKtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2978C4CECD;
	Tue, 12 Nov 2024 10:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407619;
	bh=g5LpoqAQ4OkGB5oepG7SKXcmKz/WJ/FE87hQqFVzKw8=;
	h=From:To:Cc:Subject:Date:From;
	b=G1nLiKtt6YqEjdByDElSEiSz2SlB/rfyvOj/miGV6Pnx/6tMD47rxBcHOlIwRGmS4
	 cS1HEVV6ORcp4m04UA05/7sdB+ZNY6cztsgSBKsYsdqa/Mkj37uSMLfp+E9t9i/dY1
	 mcuYDOzy76X3W3OyTcZl+3ptM5KnJIIcqv27Ova4=
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
Subject: [PATCH 6.6 000/119] 6.6.61-rc1 review
Date: Tue, 12 Nov 2024 11:20:08 +0100
Message-ID: <20241112101848.708153352@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.61-rc1
X-KernelTest-Deadline: 2024-11-14T10:18+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.61 release.
There are 119 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 14 Nov 2024 10:18:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.61-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.61-rc1

Hyunwoo Kim <v4bel@theori.io>
    vsock/virtio: Initialization of the dangling pointer occurring in vsk->trans

Hyunwoo Kim <v4bel@theori.io>
    hv_sock: Initializing vsk->trans to NULL to prevent a dangling pointer

Mingcong Bai <jeffbai@aosc.io>
    ASoC: amd: yc: fix internal mic on Xiaomi Book Pro 14 2022

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

Rex Nie <rex.nie@jaguarmicro.com>
    usb: typec: qcom-pmic: init value of hdr_len/txbuf_len earlier

Roger Quadros <rogerq@kernel.org>
    usb: dwc3: fix fault at system suspend if device was already runtime suspended

Zijun Hu <quic_zijuhu@quicinc.com>
    usb: musb: sunxi: Fix accessing an released usb phy

Roman Gushchin <roman.gushchin@linux.dev>
    signal: restore the override_rlimit logic

Qi Xi <xiqi2@huawei.com>
    fs/proc: fix compile warning about variable 'vmcore_mmap_ops'

Liu Peibao <loven.liu@jaguarmicro.com>
    i2c: designware: do not hold SCL low when I2C_DYNAMIC_TAR_UPDATE is not set

Trond Myklebust <trond.myklebust@hammerspace.com>
    filemap: Fix bounds checking in filemap_read()

Benoit Sevens <bsevens@google.com>
    media: uvcvideo: Skip parsing frames of type UVC_VS_UNDEFINED in uvc_parse_format

Pu Lehui <pulehui@huawei.com>
    Revert "selftests/bpf: Implement get_hw_ring_size function to retrieve current and max interface size"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "wifi: mac80211: fix RCU list iterations"

Daniel Maslowski <cyrevolt@googlemail.com>
    riscv/purgatory: align riscv_kernel_entry

Filipe Manana <fdmanana@suse.com>
    btrfs: reinitialize delayed ref list after deleting it from the list

Mark Rutland <mark.rutland@arm.com>
    arm64: smccc: Remove broken support for SMCCCv1.3 SVE discard hint

Mark Rutland <mark.rutland@arm.com>
    arm64: Kconfig: Make SME depend on BROKEN for now

Mark Brown <broonie@kernel.org>
    arm64/sve: Discard stale CPU state when handling SVE traps

Geliang Tang <tanggeliang@kylinos.cn>
    mptcp: use sock_kfree_s instead of kfree

Stefan Wahren <wahrenst@gmx.net>
    net: vertexcom: mse102x: Fix possible double free of TX skb

Jinjie Ruan <ruanjinjie@huawei.com>
    net: wwan: t7xx: Fix off-by-one error in t7xx_dpmaif_rx_buf_alloc()

Roberto Sassu <roberto.sassu@huawei.com>
    nfs: Fix KMSAN warning in decode_getfattr_attrs()

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
    dm cache: fix flushing uninitialized delayed_work on cache_ctr error

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: correct the number of origin blocks to match the target length

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    thermal/drivers/qcom/lmh: Remove false lockdep backtrace

Antonio Quartulli <antonio@mandelbit.com>
    drm/amdgpu: prevent NULL pointer dereference if ATIF is not supported

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Fix DPX valid mode check on GC 9.4.3

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: Adjust debugfs register access permissions

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: add missing size check in amdgpu_debugfs_gprwave_read()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: Adjust debugfs eviction and IB access permissions

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    rpmsg: glink: Handle rejected intent request better

Erik Schumacher <erik.schumacher@iris-sensing.com>
    pwm: imx-tpm: Use correct MODULO value for EPWM mode

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix slab-use-after-free in smb3_preauth_hash_rsp

Jinjie Ruan <ruanjinjie@huawei.com>
    ksmbd: Fix the missing xa_store error check

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: check outstanding simultaneous SMB operations

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix slab-use-after-free in ksmbd_smb2_session_create

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: mcp251xfd_ring_alloc(): fix coalescing configuration when switching CAN modes

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: mcp251xfd_get_tef_len(): fix length calculation

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: m_can_close(): don't call free_irq() for IRQ-less devices

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

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: ar0521: don't overflow when checking PLL values

Jyri Sarha <jyri.sarha@linux.intel.com>
    ASoC: SOF: sof-client-probes-ipc4: Set param_size extension bits

Amelie Delaunay <amelie.delaunay@foss.st.com>
    ASoC: stm32: spdifrx: fix dma channel release in stm32_spdifrx_remove

Icenowy Zheng <uwu@icenowy.me>
    thermal/of: support thermal zones w/o trips subnode

Emil Dahl Juhl <emdj@bang-olufsen.dk>
    tools/lib/thermal: Fix sampling handler context ptr

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

Wentao Liang <Wentao_liang_g@163.com>
    drivers: net: ionic: add missed debugfs cleanup to ionic_probe() error path

David Howells <dhowells@redhat.com>
    rxrpc: Fix missing locking causing hanging calls

Johan Jonker <jbx6244@gmail.com>
    net: arc: rockchip: fix emac mdio node support

Johan Jonker <jbx6244@gmail.com>
    net: arc: fix the device for dma_map_single/dma_unmap_single

Philo Lu <lulie@linux.alibaba.com>
    virtio_net: Add hash_key_length check

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: wait for rcu grace period on net_device removal

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx

George Guo <guodongtai@kylinos.cn>
    netfilter: nf_tables: cleanup documentation

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    net: stmmac: Fix unbalanced IRQ wake disable warning on single irq case

Diogo Silva <diogompaissilva@gmail.com>
    net: phy: ti: add PHY_RST_AFTER_CLK_EN flag

Peiyang Wang <wangpeiyang1@huawei.com>
    net: hns3: fix kernel crash when uninstalling driver

Vitaly Lifshits <vitaly.lifshits@intel.com>
    e1000e: Remove Meteor Lake SMBUS workarounds

Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    i40e: fix race condition by adding filter's intermediate sync state

Mateusz Polchlopek <mateusz.polchlopek@intel.com>
    ice: change q_index variable type to s16 to store -1 value

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: c_can: fix {rx,tx}_errors statistics

Wei Fang <wei.fang@nxp.com>
    net: enetc: allocate vf_state during PF probes

Xin Long <lucien.xin@gmail.com>
    sctp: properly validate chunk size in sctp_sf_ootb()

Suraj Gupta <suraj.gupta2@amd.com>
    dt-bindings: net: xlnx,axi-ethernet: Correct phy-mode property value

Wei Fang <wei.fang@nxp.com>
    net: enetc: set MAC address to the VF net_device

ChiYuan Huang <cy_huang@richtek.com>
    regulator: rtq2208: Fix uninitialized use of regulator_config

Chen Ridong <chenridong@huawei.com>
    security/keys: fix slab-out-of-bounds in key_task_permission

Mike Snitzer <snitzer@kernel.org>
    nfs: avoid i_lock contention in nfs_clear_invalid_mapping

NeilBrown <neilb@suse.de>
    NFSv3: only use NFS timeout for MOUNT when protocols are compatible

NeilBrown <neilb@suse.de>
    sunrpc: handle -ENOTCONN in xs_tcp_setup_socket()

Corey Hickey <bugfood-c@fatooh.org>
    platform/x86/amd/pmc: Detect when STB is not available

Jiri Kosina <jkosina@suse.com>
    HID: core: zero-initialize the report buffer

Diederik de Haas <didi.debian@cknow.org>
    arm64: dts: rockchip: Correct GPIO polarity on brcm BT nodes

Heiko Stuebner <heiko@sntech.de>
    ARM: dts: rockchip: Fix the realtek audio codec on rk3036-kylin

Heiko Stuebner <heiko@sntech.de>
    ARM: dts: rockchip: Fix the spi controller on rk3036

Heiko Stuebner <heiko@sntech.de>
    ARM: dts: rockchip: drop grf reference from rk3036 hdmi

Heiko Stuebner <heiko@sntech.de>
    ARM: dts: rockchip: fix rk3036 acodec node

Heiko Stuebner <heiko@sntech.de>
    arm64: dts: rockchip: remove orphaned pinctrl-names from pinephone pro

Xinqi Zhang <quic_xinqzhan@quicinc.com>
    firmware: arm_scmi: Fix slab-use-after-free in scmi_bus_notifier()

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp: correct sdhc ipg clk

Alexander Stein <alexander.stein@ew.tq-group.com>
    arm64: dts: imx8-ss-vpu: Fix imx8qm VPU IRQs

Alexander Stein <alexander.stein@ew.tq-group.com>
    arm64: dts: imx8qxp: Add VPU subsystem file

Heiko Stuebner <heiko@sntech.de>
    arm64: dts: rockchip: remove num-slots property from rk3328-nanopi-r2s-plus

Heiko Stuebner <heiko@sntech.de>
    arm64: dts: rockchip: Fix LED triggers on rk3308-roc-cc

Heiko Stuebner <heiko@sntech.de>
    arm64: dts: rockchip: Remove #cooling-cells from fan on Theobroma lion

Heiko Stuebner <heiko@sntech.de>
    arm64: dts: rockchip: Remove undocumented supports-emmc property

Sergey Bostandzhyan <jin@mediatomb.cc>
    arm64: dts: rockchip: Add DTS for FriendlyARM NanoPi R2S Plus

Heiko Stuebner <heiko@sntech.de>
    arm64: dts: rockchip: Fix bluetooth properties on Rock960 boards

Heiko Stuebner <heiko@sntech.de>
    arm64: dts: rockchip: Fix bluetooth properties on rk3566 box demo

Heiko Stuebner <heiko@sntech.de>
    arm64: dts: rockchip: fix i2c2 pinctrl-names property on anbernic-rg353p/v

Diederik de Haas <didi.debian@cknow.org>
    arm64: dts: rockchip: Fix reset-gpios property on brcm BT nodes

Diederik de Haas <didi.debian@cknow.org>
    arm64: dts: rockchip: Fix wakeup prop names on PineNote BT node

Diederik de Haas <didi.debian@cknow.org>
    arm64: dts: rockchip: Remove hdmi's 2nd interrupt on rk3328

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: rockchip: Fix rt5651 compatible value on rk3399-sapphire-excavator

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: rockchip: Fix rt5651 compatible value on rk3399-eaidk-610


-------------

Diffstat:

 .../devicetree/bindings/net/xlnx,axi-ethernet.yaml |  2 +-
 Makefile                                           |  4 +-
 arch/arm/boot/dts/rockchip/rk3036-kylin.dts        |  4 +-
 arch/arm/boot/dts/rockchip/rk3036.dtsi             | 14 ++---
 arch/arm64/Kconfig                                 |  1 +
 arch/arm64/boot/dts/freescale/imx8-ss-vpu.dtsi     |  4 +-
 arch/arm64/boot/dts/freescale/imx8mp.dtsi          |  6 +--
 arch/arm64/boot/dts/freescale/imx8qxp-ss-vpu.dtsi  | 25 +++++++++
 arch/arm64/boot/dts/freescale/imx8qxp.dtsi         |  2 +-
 arch/arm64/boot/dts/rockchip/Makefile              |  1 +
 arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi    |  1 -
 arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts     |  4 +-
 .../boot/dts/rockchip/rk3328-nanopi-r2s-plus.dts   | 30 +++++++++++
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |  3 +-
 arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi      |  1 -
 arch/arm64/boot/dts/rockchip/rk3399-eaidk-610.dts  |  2 +-
 .../boot/dts/rockchip/rk3399-pinephone-pro.dts     |  2 -
 arch/arm64/boot/dts/rockchip/rk3399-rock960.dtsi   |  2 +-
 .../dts/rockchip/rk3399-sapphire-excavator.dts     |  2 +-
 .../boot/dts/rockchip/rk3566-anbernic-rg353p.dts   |  2 +-
 .../boot/dts/rockchip/rk3566-anbernic-rg353v.dts   |  2 +-
 arch/arm64/boot/dts/rockchip/rk3566-box-demo.dts   |  6 +--
 arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts |  1 -
 arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi  |  6 +--
 arch/arm64/boot/dts/rockchip/rk3566-radxa-cm3.dtsi |  2 +-
 arch/arm64/boot/dts/rockchip/rk3568-lubancat-2.dts |  1 -
 arch/arm64/kernel/fpsimd.c                         |  1 +
 arch/arm64/kernel/smccc-call.S                     | 35 ++-----------
 arch/riscv/purgatory/entry.S                       |  3 ++
 drivers/firmware/arm_scmi/bus.c                    |  7 +--
 drivers/firmware/smccc/smccc.c                     |  4 --
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |  4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        | 10 ++--
 drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c         |  2 +-
 drivers/hid/hid-core.c                             |  2 +-
 drivers/i2c/busses/i2c-designware-common.c         |  6 ++-
 drivers/i2c/busses/i2c-designware-core.h           |  1 +
 drivers/irqchip/irq-gic-v3.c                       |  7 +++
 drivers/md/dm-cache-target.c                       | 59 +++++++++++-----------
 drivers/md/dm-unstripe.c                           |  4 +-
 drivers/media/cec/usb/pulse8/pulse8-cec.c          |  2 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      |  3 ++
 drivers/media/dvb-core/dvb_frontend.c              |  4 +-
 drivers/media/dvb-core/dvbdev.c                    | 17 ++++++-
 drivers/media/dvb-frontends/cx24116.c              |  7 ++-
 drivers/media/dvb-frontends/stb0899_algo.c         |  2 +-
 drivers/media/i2c/adv7604.c                        | 26 ++++++----
 drivers/media/i2c/ar0521.c                         |  4 +-
 .../media/platform/samsung/s5p-jpeg/jpeg-core.c    | 17 ++++---
 drivers/media/usb/uvc/uvc_driver.c                 |  2 +-
 drivers/media/v4l2-core/v4l2-ctrls-api.c           | 17 ++++---
 drivers/net/can/c_can/c_can_main.c                 |  7 ++-
 drivers/net/can/m_can/m_can.c                      |  3 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c     |  8 +--
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c      | 10 ++--
 drivers/net/ethernet/arc/emac_main.c               | 27 ++++++----
 drivers/net/ethernet/arc/emac_mdio.c               |  9 +++-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    | 18 +++----
 drivers/net/ethernet/freescale/enetc/enetc_vf.c    |  9 +++-
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        |  5 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        | 17 ++-----
 drivers/net/ethernet/intel/i40e/i40e.h             |  1 +
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c     |  1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 12 ++++-
 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c  |  3 +-
 drivers/net/ethernet/intel/ice/ice_fdir.h          |  4 +-
 .../net/ethernet/pensando/ionic/ionic_bus_pci.c    |  1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  1 +
 drivers/net/ethernet/vertexcom/mse102x.c           |  5 +-
 drivers/net/phy/dp83848.c                          |  2 +
 drivers/net/virtio_net.c                           |  6 +++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c         |  2 +-
 drivers/platform/x86/amd/pmc/pmc.c                 |  5 ++
 drivers/pwm/pwm-imx-tpm.c                          |  4 +-
 drivers/regulator/rtq2208-regulator.c              |  2 +-
 drivers/rpmsg/qcom_glink_native.c                  | 10 ++--
 drivers/scsi/sd_zbc.c                              |  3 +-
 drivers/thermal/qcom/lmh.c                         |  7 +++
 drivers/thermal/thermal_of.c                       | 21 ++++----
 drivers/usb/dwc3/core.c                            | 25 +++++----
 drivers/usb/musb/sunxi.c                           |  2 -
 drivers/usb/serial/io_edgeport.c                   |  8 +--
 drivers/usb/serial/option.c                        |  6 +++
 drivers/usb/serial/qcserial.c                      |  2 +
 .../usb/typec/tcpm/qcom/qcom_pmic_typec_pdphy.c    |  8 +--
 drivers/usb/typec/ucsi/ucsi_ccg.c                  |  2 +
 fs/btrfs/delayed-ref.c                             |  2 +-
 fs/nfs/inode.c                                     | 21 ++++++--
 fs/nfs/super.c                                     | 10 +++-
 fs/ocfs2/xattr.c                                   |  3 +-
 fs/proc/vmcore.c                                   |  9 ++--
 fs/smb/server/connection.c                         |  1 +
 fs/smb/server/connection.h                         |  1 +
 fs/smb/server/mgmt/user_session.c                  | 15 ++++--
 fs/smb/server/server.c                             | 20 +++++---
 fs/smb/server/smb_common.c                         | 10 ++--
 fs/smb/server/smb_common.h                         |  2 +-
 include/linux/arm-smccc.h                          | 32 ++----------
 include/linux/tick.h                               |  8 +++
 include/linux/user_namespace.h                     |  3 +-
 include/net/netfilter/nf_tables.h                  | 55 ++++++++++++++++----
 include/trace/events/rxrpc.h                       |  1 +
 kernel/fork.c                                      |  2 +
 kernel/signal.c                                    |  3 +-
 kernel/ucount.c                                    |  9 ++--
 mm/filemap.c                                       |  2 +-
 net/mac80211/chan.c                                |  4 +-
 net/mac80211/mlme.c                                |  2 +-
 net/mac80211/scan.c                                |  2 +-
 net/mac80211/util.c                                |  4 +-
 net/mptcp/pm_userspace.c                           |  3 +-
 net/netfilter/nf_tables_api.c                      | 56 ++++++++++++++------
 net/netfilter/nft_immediate.c                      |  2 +-
 net/rxrpc/conn_client.c                            |  4 ++
 net/sctp/sm_statefuns.c                            |  2 +-
 net/sunrpc/xprtsock.c                              |  1 +
 net/vmw_vsock/hyperv_transport.c                   |  1 +
 net/vmw_vsock/virtio_transport_common.c            |  1 +
 security/keys/keyring.c                            |  7 ++-
 sound/firewire/tascam/amdtp-tascam.c               |  2 +-
 sound/pci/hda/patch_conexant.c                     |  2 -
 sound/soc/amd/yc/acp6x-mach.c                      |  7 +++
 sound/soc/sof/sof-client-probes-ipc4.c             |  1 +
 sound/soc/stm/stm32_spdifrx.c                      |  2 +-
 sound/usb/mixer.c                                  |  1 +
 sound/usb/quirks.c                                 |  2 +
 tools/lib/thermal/sampling.c                       |  2 +
 tools/testing/selftests/bpf/network_helpers.c      | 24 ---------
 tools/testing/selftests/bpf/network_helpers.h      |  4 --
 .../selftests/bpf/prog_tests/flow_dissector.c      |  1 +
 tools/testing/selftests/bpf/xdp_hw_metadata.c      | 14 +++++
 131 files changed, 611 insertions(+), 381 deletions(-)


