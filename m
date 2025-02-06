Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED131A3165;
	Thu,  6 Feb 2025 16:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738857986; cv=none; b=kX4dGe316i2sKd8riuXf6fQswx5QwEdx9UPQBd97lnqgGgnAUwkH4lywfvr4eEWmkmHsSQT9abZoRw/K3DF4Yzo2dUsLae90Y3P1osga7BpikrHlB8jThsUgPs1aqoydhB3maxKLKMSu4zQ6sqIUStp8H0cT7XpndEvlqJ/wwSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738857986; c=relaxed/simple;
	bh=aNsa7KxW6A8cjW50hPTsc9Crz2c7ZWAS8VGRy6toRhE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZxzxZb7uv0+XcmaS2A3n/PDK1eWTtvVDGeQFrH+mFvFFLVNSP8C/25iM2lGnTbTqNezxJRs6N9WPeTL7OejV+XVnW45JRPd/+Sk4Eom2J6Ba9EqDF8+A6SYijzoMRHWUejjywa/LpvmwiRb7WEN9kpbqjPHYxdS5YTblrvh7koA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUy9ec/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUy9ec/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A20C4CEDD;
	Thu,  6 Feb 2025 16:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738857986;
	bh=aNsa7KxW6A8cjW50hPTsc9Crz2c7ZWAS8VGRy6toRhE=;
	h=From:To:Cc:Subject:Date:From;
	b=DUy9ec/biRU5Zn8RfSLQre1em8jucB/IG+34O+xQtbKf55O5wW04pLoVKa7TvlyZT
	 PK9AYDLDK7BVBoQsKAUmkM8Hcor4mzfJ2QKOgDLYkyquMvrK6tASQf/AMowEDSiad5
	 pengVLYbV2N+mx+cp02xSlvo6PMbxACCSicERtpw=
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
Subject: [PATCH 6.6 000/389] 6.6.76-rc2 review
Date: Thu,  6 Feb 2025 17:06:18 +0100
Message-ID: <20250206155234.095034647@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.76-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.76-rc2
X-KernelTest-Deadline: 2025-02-08T15:52+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.76 release.
There are 389 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 08 Feb 2025 15:51:12 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.76-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.76-rc2

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Change 8 to 14 for LOONGARCH_MAX_{BRP,WRP}

Nathan Chancellor <nathan@kernel.org>
    s390: Add '-std=gnu11' to decompressor and purgatory CFLAGS

Qu Wenruo <wqu@suse.com>
    btrfs: output the reason for open_ctree() failure

Dan Carpenter <dan.carpenter@linaro.org>
    media: imx-jpeg: Fix potential error pointer dereference in detach_pm()

Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
    staging: media: max96712: fix kernel oops when removing module

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: f_tcm: Don't free command immediately

Calvin Owens <calvin@wbinvd.org>
    pps: Fix a use-after-free

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: uvcvideo: Fix double free in error path

Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
    remoteproc: core: Fix ida_free call while not allocated

Paolo Abeni <pabeni@redhat.com>
    mptcp: handle fastopen disconnect correctly

Paolo Abeni <pabeni@redhat.com>
    mptcp: consolidate suboption status

Kyle Tso <kyletso@google.com>
    usb: typec: tcpci: Prevent Sink disconnection before vPpsShutdown in SPR PPS

Jos Wang <joswang@lenovo.com>
    usb: typec: tcpm: set SRC_SEND_CAPABILITIES timeout to PD_T_SENDER_RESPONSE

Kyle Tso <kyletso@google.com>
    usb: dwc3: core: Defer the probe until USB power supply ready

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    usb: dwc3-am62: Fix an OF node leak in phy_syscon_pll_refclk()

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: f_tcm: Fix Get/SetInterface return value

Sean Rhodes <sean@starlabs.systems>
    drivers/card_reader/rtsx_usb: Restore interrupt based detection

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Fix NULL pointer dereference on certain command aborts

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    net: usb: rtl8150: enable basic endpoint checking

Lianqin Hu <hulianqin@vivo.com>
    ALSA: usb-audio: Add delay quirk for iBasso DC07 Pro

Ricardo B. Marliere <rbm@suse.com>
    ktest.pl: Check kernelrelease return in get_version

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests/rseq: Fix handling of glibc without rseq support

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: reject mismatching sum of field_len with set key length

Parth Pancholi <parth.pancholi@toradex.com>
    kbuild: switch from lz4c to lz4 for compression

Chuck Lever <chuck.lever@oracle.com>
    Revert "SUNRPC: Reduce thread wake-up rate when receiving large RPC messages"

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Reset cb_seq_status after NFS4ERR_DELAY

Daniel Lee <chullee@google.com>
    f2fs: Introduce linear search for dentries

Lin Yujun <linyujun809@huawei.com>
    hexagon: Fix unbalanced spinlock in die()

Willem de Bruijn <willemb@google.com>
    hexagon: fix using plain integer as NULL pointer warning in cmpxchg

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: fix memory leak in sym_warn_unmet_dep()

Sergey Senozhatsky <senozhatsky@chromium.org>
    kconfig: WERROR unmet symbol dependency

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: deduplicate code in conf_read_simple()

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: remove unused code for S_DEF_AUTO in conf_read_simple()

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: require a space after '#' for valid input

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: fix file name in warnings when loading KCONFIG_DEFCONFIG_LIST

Pali Rohár <pali@kernel.org>
    cifs: Fix getting and setting SACLs over SMB1

Pali Rohár <pali@kernel.org>
    cifs: Validate EAs for WSL reparse points

Jens Axboe <axboe@kernel.dk>
    io_uring/uring_cmd: use cached cmd_op in io_uring_cmd_sock()

Detlev Casanova <detlev.casanova@collabora.com>
    ASoC: rockchip: i2s_tdm: Re-add the set_sysclk callback

Palmer Dabbelt <palmer@rivosinc.com>
    RISC-V: Mark riscv_v_init() as __init

Hongbo Li <lihongbo22@huawei.com>
    hostfs: fix the host directory parse when mounting.

Nathan Chancellor <nathan@kernel.org>
    hostfs: Add const qualifier to host_root in hostfs_fill_super()

Al Viro <viro@zeniv.linux.org.uk>
    hostfs: fix string handling in __dentry_name()

Hongbo Li <lihongbo22@huawei.com>
    hostfs: convert hostfs to use the new mount API

Masahiro Yamada <masahiroy@kernel.org>
    genksyms: fix memory leak when the same symbol is read from *.symref file

Masahiro Yamada <masahiroy@kernel.org>
    genksyms: fix memory leak when the same symbol is added from source

Eric Dumazet <edumazet@google.com>
    net: hsr: fix fill_frame_info() regression vs VLAN packets

Kory Maincent <kory.maincent@bootlin.com>
    net: sh_eth: Fix missing rtnl lock in suspend/resume path

Toke Høiland-Jørgensen <toke@redhat.com>
    net: xdp: Disallow attaching device-bound programs in generic mode

Jon Maloy <jmaloy@redhat.com>
    tcp: correct handling of extreme memory squeeze

Rafał Miłecki <rafal@milecki.pl>
    bgmac: reduce max frame size to support just MTU 1500

Michal Luczaj <mhal@rbox.co>
    vsock: Allow retrying on connect() failure

Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
    Bluetooth: btnxpuart: Fix glitches seen in dual A2DP streaming

Howard Chu <howardchu95@gmail.com>
    perf trace: Fix runtime error of index out of bounds

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    net: stmmac: Limit FIFO size by hardware capability

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    net: stmmac: Limit the number of MTL queues to hardware capability

Thomas Weißschuh <linux@weissschuh.net>
    ptp: Properly handle compat ioctls

Chenyuan Yang <chenyuan0y@gmail.com>
    net: davicom: fix UAF in dm9000_drv_remove

Shigeru Yoshida <syoshida@redhat.com>
    vxlan: Fix uninit-value in vxlan_vnifilter_dump()

Jakub Kicinski <kuba@kernel.org>
    net: netdevsim: try to close UDP port harness races

Eric Dumazet <edumazet@google.com>
    net: rose: fix timer races against user threads

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    iavf: allow changing VLAN state without calling PF

Wentao Liang <vulab@iscas.ac.cn>
    PM: hibernate: Add error handling for syscore_suspend()

Eric Dumazet <edumazet@google.com>
    ipmr: do not call mr_mfc_uses_dev() for unres entries

Dheeraj Reddy Jonnalagadda <dheeraj.linuxdev@gmail.com>
    net: fec: implement TSO descriptor cleanup

Ahmad Fatoum <a.fatoum@pengutronix.de>
    gpio: mxc: remove dead code after switch to DT-only

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix oops when unload drivers paralleling

Alexander Stein <alexander.stein@ew.tq-group.com>
    regulator: core: Add missing newline character

pangliyuan <pangliyuan1@huawei.com>
    ubifs: skip dumping tnc tree when zroot is null

Ming Wang <wangming01@loongson.cn>
    rtc: loongson: clear TOY_MATCH0_REG in loongson_rtc_isr()

Oleksij Rempel <o.rempel@pengutronix.de>
    rtc: pcf85063: fix potential OOB write in PCF85063 NVMEM read

Alexandre Cassen <acassen@corp.free.fr>
    xfrm: delete intermediate secpath entry in packet offload mode

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    dmaengine: ti: edma: fix OF node reference leaks in edma_driver

Jianbo Liu <jianbol@nvidia.com>
    xfrm: replay: Fix the update of replay_esn->oseq_hi for GSO

Luo Yifan <luoyifan@cmss.chinamobile.com>
    tools/bootconfig: Fix the wrong format specifier

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Fix warnings during S3 suspend

Olga Kornievskaia <okorniev@redhat.com>
    NFSv4.2: mark OFFLOAD_CANCEL MOVEABLE

Olga Kornievskaia <okorniev@redhat.com>
    NFSv4.2: fix COPY_NOTIFY xdr buf size calculation

John Ogness <john.ogness@linutronix.de>
    serial: 8250: Adjust the timeout for FIFO mode

Zijun Hu <quic_zijuhu@quicinc.com>
    driver core: class: Fix wild pointer dereferences in API class_dev_iter_next()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    module: Extend the preempt disabled section in dereference_symbol_descriptor().

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: protect access to buffers with no active references

Matthew Wilcox (Oracle) <willy@infradead.org>
    nilfs2: convert nilfs_lookup_dirty_data_buffers to use folio_create_empty_buffers

Matthew Wilcox (Oracle) <willy@infradead.org>
    buffer: make folio_create_empty_buffers() return a buffer_head

Su Yue <glass.su@suse.com>
    ocfs2: mark dquot as inactive if failed to start trans while releasing dquot

Guixin Liu <kanie@linux.alibaba.com>
    scsi: ufs: bsg: Delete bsg_dev when setting up bsg fails

Paul Menzel <pmenzel@molgen.mpg.de>
    scsi: mpt3sas: Set ioc->manu_pg11.EEDPTagMode directly to 1

Manivannan Sadhasivam <mani@kernel.org>
    PCI: endpoint: pci-epf-test: Fix check for DMA MEMCPY test

Mohamed Khalfella <khalfella@gmail.com>
    PCI: endpoint: pci-epf-test: Set dma_chan_rx pointer to NULL on error

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: imx6: Skip controller_id generation logic for i.MX7D

Frank Li <Frank.Li@nxp.com>
    PCI: imx6: Simplify clock handling by using clk_bulk*() function

King Dix <kingdix10@qq.com>
    PCI: rcar-ep: Fix incorrect variable used when calling devm_request_mem_region()

Desnes Nunes <desnesn@redhat.com>
    media: dvb-usb-v2: af9035: fix ISO C90 compilation error on af9035_i2c_master_xfer

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    staging: media: imx: fix OF node leak in imx_media_add_of_subdevs()

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    watchdog: rti_wdt: Fix an OF node leak in rti_wdt_probe()

Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
    media: nxp: imx8-isi: fix v4l2-compliance test errors

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    mtd: hyperbus: hbmc-am654: fix an OF node reference leak

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mtd: hyperbus: hbmc-am654: Convert to platform remove callback returning void

david regan <dregan@broadcom.com>
    mtd: rawnand: brcmnand: fix status read of brcmnand_waitfunc

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Propagate buf->error to userspace

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    media: camif-core: Add check for clk_enable()

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    media: mipi-csis: Add check for clk_enable()

Dave Stevenson <dave.stevenson@raspberrypi.com>
    media: i2c: ov9282: Correct the exposure offset

Luca Weiss <luca.weiss@fairphone.com>
    media: i2c: imx412: Add missing newline to prints

Dave Stevenson <dave.stevenson@raspberrypi.com>
    media: i2c: imx290: Register 0x3011 varies between imx327 and imx290

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    media: marvell: Add check for clk_enable()

Zijun Hu <quic_zijuhu@quicinc.com>
    PCI: endpoint: Destroy the EPC device in devm_pci_epc_destroy()

Chen Ni <nichen@iscas.ac.cn>
    media: lmedm04: Handle errors for lme2510_int_read

Oliver Neukum <oneukum@suse.com>
    media: rc: iguanair: handle timeouts

Mark Brown <broonie@kernel.org>
    spi: omap2-mcspi: Correctly handle devm_clk_get_optional() errors

Qasim Ijaz <qasdev00@gmail.com>
    iommufd/iova_bitmap: Fix shift-out-of-bounds in iova_bitmap_offset_to_index()

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix the warning "__rxe_cleanup+0x12c/0x170 [rdma_rxe]"

Randy Dunlap <rdunlap@infradead.org>
    efi: sysfb_efi: fix W=1 warnings when EFI is not set

Zijun Hu <quic_zijuhu@quicinc.com>
    of: reserved-memory: Do not make kmemleak ignore freed address

Michael Guralnik <michaelgur@nvidia.com>
    RDMA/mlx5: Fix indirect mkey ODP page count

Pei Xiao <xiaopei01@kylinos.cn>
    i3c: dw: Fix use-after-free in dw_i3c_master driver due to race condition

Billy Tsai <billy_tsai@aspeedtech.com>
    i3c: dw: Add hot-join support.

Akhil R <akhilrajeev@nvidia.com>
    arm64: tegra: Fix DMA ID for SPI2

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    fbdev: omapfb: Fix an OF node leak in dss_of_port_get_parent_device()

Rafał Miłecki <rafal@milecki.pl>
    ARM: dts: mediatek: mt7623: fix IR nodename

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    arm64: dts: qcom: sm8250: Fix interrupt types of camss interrupts

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    arm64: dts: qcom: sdm845: Fix interrupt types of camss interrupts

Val Packett <val@packett.cool>
    arm64: dts: mediatek: add per-SoC compatibles for keypad nodes

Jason-JH.Lin <jason-jh.lin@mediatek.com>
    dts: arm64: mediatek: mt8195: Remove MT8183 compatible for OVL

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sc8280xp: Fix up remoteproc register space sizes

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: qcom: sm8150-microsoft-surface-duo: fix typos in da7280 properties

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: qcom: sc7180: fix psci power domain node names

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sc7180: change labels to lower-case

David Wronek <davidwronek@gmail.com>
    arm64: dts: qcom: Add SM7125 device tree

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: qcom: sc7180-trogdor-pompom: rename 5v-choke thermal zone

Konrad Dybcio <konrad.dybcio@linaro.org>
    arm64: dts: qcom: sc7180-*: Remove thermal zone polling delays

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: qcom: sc7180-trogdor-quackingstick: add missing avee-supply

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: qcom: sdm845-db845c-navigation-mezzanine: remove disabled ov7251 camera

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    arm64: dts: qcom: sdm845-db845c-navigation-mezzanine: Convert mezzanine riser to dtso

Aaro Koskinen <aaro.koskinen@iki.fi>
    ARM: omap1: Fix up the Retu IRQ on Nokia 770

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Fix to drop reference to the mmap entry in case of error

Vasily Khoruzhick <anarsoul@gmail.com>
    arm64: dts: allwinner: a64: explicitly assign clock parent for TCON0

Bryan Brattlof <bb@ti.com>
    arm64: dts: ti: k3-am62a: Remove duplicate GICR reg

Bryan Brattlof <bb@ti.com>
    arm64: dts: ti: k3-am62: Remove duplicate GICR reg

Cristian Birsan <cristian.birsan@microchip.com>
    ARM: dts: microchip: sama5d27_wlsom1_ek: Add no-1-8-v property to sdmmc0 node

Mihai Sain <mihai.sain@microchip.com>
    ARM: dts: microchip: sama5d27_wlsom1_ek: Remove mmc-ddr-3_3v property from sdmmc0 node

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm8450: correct sleep clock frequency

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm8350: correct sleep clock frequency

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm8250: correct sleep clock frequency

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm6375: correct sleep clock frequency

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm6125: correct sleep clock frequency

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm4450: correct sleep clock frequency

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sdx75: correct sleep clock frequency

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sc7280: correct sleep clock frequency

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: qrb4210-rb2: correct sleep clock frequency

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: q[dr]u1000: correct sleep clock frequency

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: qcs404: correct sleep clock frequency

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8994: correct sleep clock frequency

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8939: correct sleep clock frequency

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8916: correct sleep clock frequency

Luca Weiss <luca.weiss@fairphone.com>
    arm64: dts: qcom: sm7225-fairphone-fp4: Drop extra qcom,msm-id value

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: msm8994: Describe USB interrupts

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: msm8996: Fix up USB3 interrupts

Taniya Das <quic_tdas@quicinc.com>
    arm64: dts: qcom: sa8775p: Update sleep_clk frequency

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    arm64: dts: qcom: move common parts for sa8775p-ride variants into a .dtsi

Shazad Hussain <quic_shazhuss@quicinc.com>
    arm64: dts: qcom: sa8775p-ride: enable pmm8654au_0_pon_resin

Andrew Halaney <ahalaney@redhat.com>
    arm64: dts: qcom: sa8775p-ride: Describe sgmii_phy1 irq

Andrew Halaney <ahalaney@redhat.com>
    arm64: dts: qcom: sa8775p-ride: Describe sgmii_phy0 irq

Marek Vasut <marex@denx.de>
    arm64: dts: qcom: msm8996-xiaomi-gemini: Fix LP5562 LED1 reg property

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183-kukui-jacuzzi: Drop pp3300_panel voltage settings

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    memory: tegra20-emc: fix an OF node reference bug in tegra_emc_find_node_by_ram_code()

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Swap USART3 and UART8 alias on STM32MP15xx DHCOM SoM

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Deduplicate serial aliases and chosen node for STM32MP15xx DHCOM SoM

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    arm64: dts: mediatek: mt8195: Remove suspend-breaking reset from pcie1

Ma Ke <make_ruc2021@163.com>
    RDMA/srp: Fix error handling in srp_add_port

Hsin-Te Yuan <yuanhsinte@chromium.org>
    arm64: dts: mediatek: mt8183: willow: Support second source touchscreen

Hsin-Te Yuan <yuanhsinte@chromium.org>
    arm64: dts: mediatek: mt8183: kenzo: Support second source touchscreen

zhenwei pi <pizhenwei@bytedance.com>
    RDMA/rxe: Fix mismatched max_msg_sz

Li Zhijian <lizhijian@fujitsu.com>
    RDMA/rxe: Improve newline in printing messages

Mamta Shukla <mamta.shukla@leica-geosystems.com>
    arm: dts: socfpga: use reset-name "stmmaceth-ocp" instead of "ahb"

Ricky CX Wu <ricky.cx.wu.wiwynn@gmail.com>
    ARM: dts: aspeed: yosemite4: correct the compatible string for max31790

Ricky CX Wu <ricky.cx.wu.wiwynn@gmail.com>
    ARM: dts: aspeed: yosemite4: Add required properties for IOE on fan boards

Ricky CX Wu <ricky.cx.wu.wiwynn@gmail.com>
    ARM: dts: aspeed: yosemite4: correct the compatible string of adm1272

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173-evb: Fix MT6397 PMIC sub-node names

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173-elm: Fix MT6397 PMIC sub-node names

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8195-demo: Drop regulator-compatible property

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8195-cherry: Drop regulator-compatible property

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8192-asurada: Drop regulator-compatible property

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173-elm: Drop regulator-compatible property

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173-evb: Drop regulator-compatible property

Dan Carpenter <dan.carpenter@linaro.org>
    rdma/cxgb4: Prevent potential integer overflow on 32bit

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx4: Avoid false error about access to uninitialized gids array

Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
    ARM: dts: stm32: Fix IPCC EXTI declaration on stm32mp151

Val Packett <val@packett.cool>
    arm64: dts: mediatek: mt8516: reserve 192 KiB for TF-A

Val Packett <val@packett.cool>
    arm64: dts: mediatek: mt8516: add i2c clock-div property

Val Packett <val@packett.cool>
    arm64: dts: mediatek: mt8516: fix wdt irq type

Val Packett <val@packett.cool>
    arm64: dts: mediatek: mt8516: fix GICv2 range

Hsin-Yi Wang <hsinyi@chromium.org>
    arm64: dts: mt8183: set DMIC one-wire mode on Damu

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    arm64: dts: mediatek: mt8186: Move wakeup to MTU3 to get working suspend

Nicolas Ferre <nicolas.ferre@microchip.com>
    ARM: at91: pm: change BU Power Switch to automatic mode

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    soc: atmel: fix device_node release in atmel_soc_device_init()

Pali Rohár <pali@kernel.org>
    cifs: Use cifs_autodisable_serverino() for disabling CIFS_MOUNT_SERVER_INUM in readdir.c

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix oops due to unset link speed

Chen Ridong <chenridong@huawei.com>
    padata: avoid UAF for reorder_work

Chen Ridong <chenridong@huawei.com>
    padata: add pd get/put refcnt helper

Chen Ridong <chenridong@huawei.com>
    padata: fix UAF in padata_reorder

Chun-Tse Shao <ctshao@google.com>
    perf lock: Fix parse_lock_type which only retrieve one lock flag

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Fixed headphone distorted sound on Acer Aspire A115-31 laptop

Daniel Xu <dxu@dxuuu.xyz>
    bpf: tcp: Mark bpf_load_hdr_opt() arg2 as read-write

Puranjay Mohan <puranjay@kernel.org>
    bpf: Send signals asynchronously if !preemptible

Maciej S. Szmigiero <mail@maciej.szmigiero.name>
    pinctrl: amd: Take suspend type into consideration which pins are non-wake

Mingwei Zheng <zmw12306@gmail.com>
    pinctrl: stm32: Add check for clk_enable()

Jiachen Zhang <me@jcix.top>
    perf report: Fix misleading help message about --demangle

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Fix theoretical infinite loop

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Do not readq() u32 registers

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Abstract IPC handling

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Prefix SKL/APL-specific members

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf namespaces: Fixup the nsinfo__in_pidns() return type, its bool

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf namespaces: Introduce nsinfo__set_in_pidns()

Christophe Leroy <christophe.leroy@csgroup.eu>
    perf machine: Don't ignore _etext when not a text symbol

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf top: Don't complain about lack of vmlinux when not resolving some kernel samples

Thomas Weißschuh <linux@weissschuh.net>
    padata: fix sysfs store callback check

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Make dependency on UMP clearer

Masahiro Yamada <masahiroy@kernel.org>
    ALSA: seq: remove redundant 'tristate' for SND_SEQ_UMP_CLIENT

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    crypto: ixp4xx - fix OF node reference leaks in init_ixp_crypto()

Wenkai Lin <linwenkai6@hisilicon.com>
    crypto: hisilicon/sec2 - fix for aead invalid authsize

Wenkai Lin <linwenkai6@hisilicon.com>
    crypto: hisilicon/sec2 - fix for aead icv error

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon/sec2 - optimize the error return process

Martin KaFai Lau <martin.lau@kernel.org>
    bpf: bpf_local_storage: Always use bpf_mem_alloc in PREEMPT_RT

Ba Jing <bajing@cmss.chinamobile.com>
    ktest.pl: Remove unused declarations in run_bisect_test function

Levi Yun <yeoreum.yun@arm.com>
    perf expr: Initialize is_test value in expr__ctx_new()

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    ASoC: renesas: rz-ssi: Use only the proper amount of dividers

Zhongqiu Han <quic_zhonhan@quicinc.com>
    perf bpf: Fix two memory leakages when calling perf_env__insert_bpf_prog_info()

Zhongqiu Han <quic_zhonhan@quicinc.com>
    perf header: Fix one memory leakage in process_bpf_prog_info()

Zhongqiu Han <quic_zhonhan@quicinc.com>
    perf header: Fix one memory leakage in process_bpf_btf()

Gaurav Jain <gaurav.jain@nxp.com>
    crypto: caam - use JobR's space to access page 0 regs

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: api - Fix boot-up self-test race

Saket Kumar Bhaskar <skb99@linux.ibm.com>
    selftests/bpf: Fix fill_link_info selftest on powerpc

George Lander <lander@jagmn.com>
    ASoC: sun4i-spdif: Add clock multiplier settings

Quentin Monnet <qmo@kernel.org>
    libbpf: Fix segfault due to libelf functions not setting errno

Marco Leogrande <leogrande@google.com>
    tools/testing/selftests/bpf/test_tc_tunnel.sh: Fix wait for server bind

Andrii Nakryiko <andrii@kernel.org>
    libbpf: don't adjust USDT semaphore address if .stapsdt.base addr is missing

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    net/rose: prevent integer overflows in rose_setsockopt()

Mahdi Arghavani <ma.arghavani@yahoo.com>
    tcp_cubic: fix incorrect HyStart round start detection

Roger Quadros <rogerq@kernel.org>
    net: ethernet: ti: am65-cpsw: fix freeing IRQ in am65_cpsw_nuss_remove_tx_chns()

Florian Westphal <fw@strlen.de>
    netfilter: nft_flow_offload: update tcp state flags under lock

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: fix set size with rbtree backend

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_rbtree: prefer sync gc to async worker

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_rbtree: rename gc deactivate+erase function

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: de-constify set commit ops function argument

Jamal Hadi Salim <jhs@mojatatu.com>
    net: sched: Disallow replacing of child qdisc from one parent to another

Antoine Tenart <atenart@kernel.org>
    net: avoid race between device unregistration and ethnl ops

Shinas Rasheed <srasheed@marvell.com>
    octeon_ep: remove firmware stats fetch in ndo_get_stats64

Maher Sanalla <msanalla@nvidia.com>
    net/mlxfw: Drop hard coded max FW flash image size

Liu Jian <liujian56@huawei.com>
    net: let net.core.dev_weight always be non-zero

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Fix error message

Mingwei Zheng <zmw12306@gmail.com>
    pwm: stm32: Add check for clk_enable()

Bo Gan <ganboing@gmail.com>
    clk: analogbits: Fix incorrect calculation of vco rate delta

Eric Dumazet <edumazet@google.com>
    inet: ipmr: fix data-races

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: cfg80211: adjust allocation of colocated AP data

Ilan Peer <ilan.peer@intel.com>
    wifi: cfg80211: Handle specific BSSID in 6GHz scanning

Dmitry V. Levin <ldv@strace.io>
    selftests: harness: fix printing of mismatch values in __EXPECT()

Geert Uytterhoeven <geert+renesas@glider.be>
    selftests: timers: clocksource-switch: Adapt progress to kselftest framework

Gautham R. Shenoy <gautham.shenoy@amd.com>
    cpufreq: ACPI: Fix max-frequency computation

Peter Chiu <chui-hao.chiu@mediatek.com>
    wifi: mt76: mt7996: fix ldpc setting

Benjamin Lin <benjamin-jw.lin@mediatek.com>
    wifi: mt76: mt7996: fix incorrect indexing of MIB FW event

Howard Hsu <howard-yh.hsu@mediatek.com>
    wifi: mt76: mt7996: fix HE Phy capability

Howard Hsu <howard-yh.hsu@mediatek.com>
    wifi: mt76: mt7996: fix the capability of reception of EHT MU PPDU

Peter Chiu <chui-hao.chiu@mediatek.com>
    wifi: mt76: mt7996: add max mpdu len capability

Peter Chiu <chui-hao.chiu@mediatek.com>
    wifi: mt76: mt7996: fix register mapping

Peter Chiu <chui-hao.chiu@mediatek.com>
    wifi: mt76: mt7915: fix register mapping

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: fix omac index assignment after hardware reset

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: improve hardware restart reliability

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: connac: move mt7615_mcu_del_wtbl_all to connac

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: firmware restart on devices with a second pcie link

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: fix rx filter setting for bfee functionality

xueqin Luo <luoxueqin@kylinos.cn>
    wifi: mt76: mt7915: fix overflows seen when writing limit attributes

Michael Lo <michael.lo@mediatek.com>
    wifi: mt76: mt7921: fix using incorrect group cipher after disconnection.

WangYuli <wangyuli@uniontech.com>
    wifi: mt76: mt76u_vendor_request: Do not print error messages when -EPROTO

Mickaël Salaün <mic@digikod.net>
    landlock: Handle weird files

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: fix data error when recvmsg with MSG_PEEK flag

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    clk: ralink: mtmips: remove duplicated 'xtal' clock for Ralink SoC RT3883

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't flush non-uploaded STAs

Ilan Peer <ilan.peer@intel.com>
    wifi: mac80211: Fix common size calculation for ML element

Andy Strohman <andrew@andrewstrohman.com>
    wifi: mac80211: fix tid removal during mesh forwarding

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: prohibit deactivating all links

Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
    wifi: mt76: mt7915: Fix mesh scan on MT7916 DBDC

Andreas Kemnade <andreas@kemnade.info>
    wifi: wlcore: fix unbalanced pm_runtime calls

Zichen Xie <zichenxie0106@gmail.com>
    samples/landlock: Fix possible NULL dereference in parse_path()

Rob Herring (Arm) <robh@kernel.org>
    mfd: syscon: Fix race in device_node_get_regmap()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    mfd: syscon: Use scoped variables with memory allocators to simplify error paths

Peter Griffin <peter.griffin@linaro.org>
    mfd: syscon: Add of_syscon_register_regmap() API

Peter Griffin <peter.griffin@linaro.org>
    mfd: syscon: Remove extern from function prototypes

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    leds: cht-wcove: Use devm_led_classdev_register() to avoid memory leak

Terry Tritton <terry.tritton@linaro.org>
    HID: fix generic desktop D-Pad controls

Karol Przybylski <karprzy7@gmail.com>
    HID: hid-thrustmaster: Fix warning in thrustmaster_probe by adding endpoint check

Amit Pundir <amit.pundir@linaro.org>
    clk: qcom: gcc-sdm845: Do not use shared clk_ops for QUPs

Sathishkumar Muruganandam <quic_murugana@quicinc.com>
    wifi: ath12k: fix tx power, max reg power update to firmware

Quan Nguyen <quan@os.amperecomputing.com>
    ipmi: ssif_bmc: Fix new request loss when bmc ready for a response

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    OPP: OF: Fix an OF node leak in _opp_add_static_v2()

Eric Dumazet <edumazet@google.com>
    ax25: rcu protect dev->ax25_ptr

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    regulator: of: Implement the unwind path of of_regulator_match()

Vasily Khoruzhick <anarsoul@gmail.com>
    clk: sunxi-ng: a64: stop force-selecting PLL-MIPI as TCON0 parent

Vasily Khoruzhick <anarsoul@gmail.com>
    clk: sunxi-ng: a64: drop redundant CLK_PLL_VIDEO0_2X and CLK_PLL_MIPI

Vasily Khoruzhick <anarsoul@gmail.com>
    dt-bindings: clock: sunxi: Export PLL_VIDEO_2X and PLL_MIPI

Octavian Purdila <tavip@google.com>
    team: prevent adding a device which is already a team device lower

Marek Vasut <marex@denx.de>
    clk: imx8mp: Fix clkout1/2 support

Manivannan Sadhasivam <mani@kernel.org>
    cpufreq: qcom: Implement clk_ops::determine_rate() for qcom_cpufreq* clocks

Manivannan Sadhasivam <mani@kernel.org>
    cpufreq: qcom: Fix qcom_cpufreq_hw_recalc_rate() to query LUT if LMh IRQ is not available

Luca Ceresoli <luca.ceresoli@bootlin.com>
    gpio: pca953x: log an error when failing to get the reset GPIO

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: pca953x: Fully convert to device managed resources

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: pca953x: Drop unused fields in struct pca953x_platform_data

Sultan Alsawaf (unemployed) <sultan@kerneltoast.com>
    cpufreq: schedutil: Fix superfluous updates caused by need_freq_update

Mingwei Zheng <zmw12306@gmail.com>
    pwm: stm32-lp: Add check for clk_enable()

Eric Dumazet <edumazet@google.com>
    inetpeer: do not get a refcount in inet_getpeer()

Eric Dumazet <edumazet@google.com>
    inetpeer: update inetpeer timestamp in inet_getpeer()

Eric Dumazet <edumazet@google.com>
    inetpeer: remove create argument of inet_getpeer()

Eric Dumazet <edumazet@google.com>
    inetpeer: remove create argument of inet_getpeer_v[46]()

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    leds: netxbig: Fix an OF node reference leak in netxbig_leds_get_of_pdata()

Matti Vaittinen <mazziesaccount@gmail.com>
    dt-bindings: mfd: bd71815: Fix rsense and typos

He Rongguang <herongguang@linux.alibaba.com>
    cpupower: fix TSC MHz calculation

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    ACPI: fan: cleanup resources in the error path of .probe()

Marcel Hamer <marcel.hamer@windriver.com>
    wifi: brcmfmac: add missing header include for brcmf_dbg

Chen-Yu Tsai <wenst@chromium.org>
    regulator: dt-bindings: mt6315: Drop regulator-compatible property

Jiri Kosina <jkosina@suse.com>
    HID: multitouch: fix support for Goodix PID 0x01e9

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: pci: wait for firmware loading before releasing memory

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: fix memory leaks and invalid access at probe error path

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: destroy workqueue at rtl_deinit_core

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: remove unused check_buddy_priv

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: leds: class-multicolor: Fix path to color definitions

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    clk: fix an OF node reference leak in of_clk_get_parent_name()

Luca Ceresoli <luca.ceresoli@bootlin.com>
    of: remove internal arguments from of_property_for_each_u32()

Alvin Šipraga <alsi@bang-olufsen.dk>
    clk: si5351: allow PLLs to be adjusted without reset

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: use device_property APIs when configuring irda mode

Neil Armstrong <neil.armstrong@linaro.org>
    dt-bindings: mmc: controller: clarify the address-cells description

David Howells <dhowells@redhat.com>
    rxrpc: Fix handling of received connection abort

Mingwei Zheng <zmw12306@gmail.com>
    spi: zynq-qspi: Add check for clk_enable()

Octavian Purdila <tavip@google.com>
    net_sched: sch_sfq: don't allow 1 packet limit

Eric Dumazet <edumazet@google.com>
    net_sched: sch_sfq: handle bigger packets

Eric Dumazet <edumazet@google.com>
    net_sched: sch_sfq: annotate data-races around q->perturb_period

Barnabás Czémán <barnabas.czeman@mainlining.org>
    wifi: wcn36xx: fix channel survey memory allocation size

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: usb: fix workqueue leak when probe fails

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: fix init_sw_vars leak when probe fails

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: wait for firmware loading before releasing memory

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: rtl8192se: rise completion of firmware loading as last step

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: do not complete firmware loading needlessly

Balaji Pothunoori <quic_bpothuno@quicinc.com>
    wifi: ath11k: Fix unexpected return buffer manager error for WCN6750/WCN6855

Charles Han <hanchunchao@inspur.com>
    ipmi: ipmb: Add check devm_kasprintf() returned value

Thomas Gleixner <tglx@linutronix.de>
    genirq: Make handle_enforce_irqctx() unconditionally available

Jiang Liu <gerry@linux.alibaba.com>
    drm/amdgpu: tear down ttm range manager for doorbell in amdgpu_ttm_fini()

Hermes Wu <hermes.wu@ite.com.tw>
    drm/bridge: it6505: Change definition of AUX_FIFO_MAX_SIZE

Sui Jingfeng <sui.jingfeng@linux.dev>
    drm/msm: Check return value of of_dma_configure()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: link DSPP_2/_3 blocks on SM8550

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: link DSPP_2/_3 blocks on SM8350

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: link DSPP_2/_3 blocks on SM8250

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: link DSPP_2/_3 blocks on SC8180X

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: link DSPP_2/_3 blocks on SM8150

Neil Armstrong <neil.armstrong@linaro.org>
    OPP: fix dev_pm_opp_find_bw_*() when bandwidth table not initialized

Neil Armstrong <neil.armstrong@linaro.org>
    OPP: add index check to assert to avoid buffer overflow in _read_freq()

Bokun Zhang <bokun.zhang@amd.com>
    drm/amdgpu/vcn: reset fw_shared under SRIOV

Min-Hua Chen <minhuadotchen@gmail.com>
    drm/rockchip: vop2: include rockchip_drm_drv.h

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: move output interface related definition to rockchip_drm_drv.h

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop2: Check linear format for Cluster windows on rk3566/8

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop2: Fix the windows switch between different layers

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop2: set bg dly and prescan dly at vop2_post_config

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop2: Set YUV/RGB overlay mode

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop2: Fix the mixer alpha setup for layer 0

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop2: Fix cluster windows alpha ctrl regsiters offset

Ivan Stepchenko <sid@itb.spb.ru>
    drm/amdgpu: Fix potential NULL pointer dereference in atomctrl_get_smc_sclk_range_table

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm/amd/pm: Fix an error handling path in vega10_enable_se_edc_force_stall_config()

Alan Stern <stern@rowland.harvard.edu>
    HID: core: Fix assumption that Resolution Multipliers must be in Logical Collections

Sui Jingfeng <sui.jingfeng@linux.dev>
    drm/etnaviv: Fix page property being used for non writecombine buffers

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dp: set safe_to_exit_level before printing it

K Prateek Nayak <kprateek.nayak@amd.com>
    x86/topology: Use x86_sched_itmt_flags for PKG domain unconditionally

Perry Yuan <perry.yuan@amd.com>
    x86/cpu: Enable SD_ASYM_PACKING for PKG domain on AMD

Peter Zijlstra <peterz@infradead.org>
    sched/topology: Rename 'DIE' domain to 'PKG'

Peter Zijlstra <peterz@infradead.org>
    sched/fair: Fix value reported by hot tasks pulled in /proc/schedstat

Yabin Cui <yabinc@google.com>
    perf/core: Save raw sample data conditionally based on sample type

David Howells <dhowells@redhat.com>
    afs: Fix the fallback handling for the YFS.RemoveFile2 RPC call

Jens Axboe <axboe@kernel.dk>
    nvme: fix bogus kzalloc() return check in nvme_init_effects_log()

Christophe Leroy <christophe.leroy@csgroup.eu>
    select: Fix unbalanced user_access_end()

Randy Dunlap <rdunlap@infradead.org>
    partitions: ldm: remove the initial kernel-doc notation

Keisuke Nishimura <keisuke.nishimura@inria.fr>
    nvme: Add error path for xa_store in nvme_init_effects

Michael Ellerman <mpe@ellerman.id.au>
    selftests/powerpc: Fix argument order to timer_sub()

Keisuke Nishimura <keisuke.nishimura@inria.fr>
    nvme: Add error check for xa_store in nvme_get_effects_log

Eugen Hristev <eugen.hristev@linaro.org>
    pstore/blk: trivial typo fixes

Yu Kuai <yukuai3@huawei.com>
    nbd: don't allow reconnect after disconnect

Yang Erkun <yangerkun@huawei.com>
    block: retry call probe after request_module in blk_request_module

Jinliang Zheng <alexjlzheng@gmail.com>
    fs: fix proc_handler for sysctl_nr_open

David Howells <dhowells@redhat.com>
    afs: Fix cleanup of immediately failed async calls

David Howells <dhowells@redhat.com>
    afs: Fix directory format encoding struct

David Howells <dhowells@redhat.com>
    afs: Fix EEXIST error returned from afs_rmdir() to be ENOTEMPTY

Alexander Aring <aahringo@redhat.com>
    dlm: fix srcu_read_lock() return type to int

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/book3s64/hugetlb: Fix disabling hugetlb when fadump is active


-------------

Diffstat:

 .../bindings/leds/leds-class-multicolor.yaml       |   2 +-
 .../devicetree/bindings/mfd/rohm,bd71815-pmic.yaml |  20 +-
 .../devicetree/bindings/mmc/mmc-controller.yaml    |   2 +-
 .../bindings/regulator/mt6315-regulator.yaml       |   6 -
 Makefile                                           |   6 +-
 .../dts/aspeed/aspeed-bmc-facebook-yosemite4.dts   |  24 +-
 .../boot/dts/intel/socfpga/socfpga_arria10.dtsi    |   6 +-
 arch/arm/boot/dts/mediatek/mt7623.dtsi             |   2 +-
 .../boot/dts/microchip/at91-sama5d27_wlsom1_ek.dts |   2 +-
 arch/arm/boot/dts/st/stm32mp151.dtsi               |   2 +-
 arch/arm/boot/dts/st/stm32mp15xx-dhcom-drc02.dtsi  |  12 -
 arch/arm/boot/dts/st/stm32mp15xx-dhcom-pdk2.dtsi   |  10 -
 .../arm/boot/dts/st/stm32mp15xx-dhcom-picoitx.dtsi |  10 -
 arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi    |   7 +
 arch/arm/mach-at91/pm.c                            |  31 +-
 arch/arm/mach-omap1/board-nokia770.c               |   2 +-
 .../boot/dts/allwinner/sun50i-a64-pinebook.dts     |   2 +
 .../boot/dts/allwinner/sun50i-a64-teres-i.dts      |   2 +
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi      |   2 +
 arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi       |  29 +-
 arch/arm64/boot/dts/mediatek/mt8173-evb.dts        |  25 +-
 .../dts/mediatek/mt8183-kukui-jacuzzi-damu.dts     |   4 +
 .../dts/mediatek/mt8183-kukui-jacuzzi-kenzo.dts    |  15 +
 .../dts/mediatek/mt8183-kukui-jacuzzi-willow.dtsi  |  15 +
 .../boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi    |   2 -
 arch/arm64/boot/dts/mediatek/mt8183.dtsi           |   3 +-
 arch/arm64/boot/dts/mediatek/mt8186.dtsi           |   8 +-
 arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi   |   3 -
 arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi    |   2 -
 arch/arm64/boot/dts/mediatek/mt8195-demo.dts       |   9 -
 arch/arm64/boot/dts/mediatek/mt8195.dtsi           |   5 +-
 arch/arm64/boot/dts/mediatek/mt8365.dtsi           |   3 +-
 arch/arm64/boot/dts/mediatek/mt8516.dtsi           |  11 +-
 arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi   |   2 -
 arch/arm64/boot/dts/nvidia/tegra234.dtsi           |   2 +-
 arch/arm64/boot/dts/qcom/Makefile                  |   3 +
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/msm8939.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/msm8994.dtsi              |  11 +-
 arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts |   2 +-
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |   9 +-
 arch/arm64/boot/dts/qcom/pm6150.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/pm6150l.dtsi              |   3 -
 arch/arm64/boot/dts/qcom/qcs404.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/qdu1000-idp.dts           |   2 +-
 arch/arm64/boot/dts/qcom/qrb4210-rb2.dts           |   2 +-
 arch/arm64/boot/dts/qcom/qru1000-idp.dts           |   2 +-
 arch/arm64/boot/dts/qcom/sa8775p-ride.dts          | 829 +--------------------
 arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi         | 814 ++++++++++++++++++++
 arch/arm64/boot/dts/qcom/sc7180-firmware-tfa.dtsi  |  84 +--
 .../arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi |   9 +-
 .../boot/dts/qcom/sc7180-trogdor-homestar.dtsi     |   9 +-
 .../arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi |   7 +-
 .../dts/qcom/sc7180-trogdor-quackingstick.dtsi     |   1 +
 .../boot/dts/qcom/sc7180-trogdor-wormdingler.dtsi  |   9 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi       |   3 -
 arch/arm64/boot/dts/qcom/sc7180.dtsi               | 387 +++++-----
 arch/arm64/boot/dts/qcom/sc7280.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi             |   6 +-
 ...dts => sdm845-db845c-navigation-mezzanine.dtso} |  46 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |  20 +-
 arch/arm64/boot/dts/qcom/sdx75.dtsi                |   2 +-
 arch/arm64/boot/dts/qcom/sm4450.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sm6125.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sm6375.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sm7125.dtsi               |  16 +
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts  |   2 +-
 .../boot/dts/qcom/sm8150-microsoft-surface-duo.dts |   4 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |  30 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |   2 +-
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi           |   1 -
 arch/arm64/boot/dts/ti/k3-am62a-main.dtsi          |   1 -
 arch/hexagon/include/asm/cmpxchg.h                 |   2 +-
 arch/hexagon/kernel/traps.c                        |   4 +-
 arch/loongarch/include/asm/hw_breakpoint.h         |   4 +-
 arch/loongarch/include/asm/loongarch.h             |  60 ++
 arch/loongarch/kernel/hw_breakpoint.c              |  16 +-
 arch/loongarch/power/platform.c                    |   2 +-
 arch/powerpc/include/asm/hugetlb.h                 |   9 +
 arch/powerpc/kernel/smp.c                          |   4 +-
 arch/powerpc/sysdev/xive/native.c                  |   4 +-
 arch/powerpc/sysdev/xive/spapr.c                   |   3 +-
 arch/riscv/kernel/vector.c                         |   2 +-
 arch/s390/Makefile                                 |   2 +-
 arch/s390/kernel/perf_cpum_cf.c                    |   2 +-
 arch/s390/kernel/perf_pai_crypto.c                 |   2 +-
 arch/s390/kernel/perf_pai_ext.c                    |   2 +-
 arch/s390/kernel/topology.c                        |   2 +-
 arch/s390/purgatory/Makefile                       |   2 +-
 arch/x86/events/amd/ibs.c                          |   2 +-
 arch/x86/kernel/smpboot.c                          |  12 +-
 block/genhd.c                                      |  22 +-
 block/partitions/ldm.h                             |   2 +-
 crypto/algapi.c                                    |   4 +-
 drivers/acpi/acpica/achware.h                      |   2 -
 drivers/acpi/fan_core.c                            |  10 +-
 drivers/base/class.c                               |   9 +-
 drivers/block/nbd.c                                |   1 +
 drivers/bluetooth/btnxpuart.c                      |   3 +-
 drivers/bus/ti-sysc.c                              |   4 +-
 drivers/char/ipmi/ipmb_dev_int.c                   |   3 +
 drivers/char/ipmi/ssif_bmc.c                       |   5 +-
 drivers/clk/analogbits/wrpll-cln28hpc.c            |   2 +-
 drivers/clk/clk-conf.c                             |   4 +-
 drivers/clk/clk-si5351.c                           |  76 +-
 drivers/clk/clk.c                                  |  14 +-
 drivers/clk/imx/clk-imx8mp.c                       |   5 +-
 drivers/clk/qcom/common.c                          |   4 +-
 drivers/clk/qcom/gcc-sdm845.c                      |  32 +-
 drivers/clk/ralink/clk-mtmips.c                    |   1 -
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c              |  13 +-
 drivers/clk/sunxi-ng/ccu-sun50i-a64.h              |   2 -
 drivers/clk/sunxi/clk-simple-gates.c               |   4 +-
 drivers/clk/sunxi/clk-sun8i-bus-gates.c            |   4 +-
 drivers/clocksource/samsung_pwm_timer.c            |   4 +-
 drivers/cpufreq/acpi-cpufreq.c                     |  36 +-
 drivers/cpufreq/qcom-cpufreq-hw.c                  |  34 +-
 drivers/crypto/caam/blob_gen.c                     |   3 +-
 drivers/crypto/hisilicon/sec2/sec.h                |   3 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         | 164 ++--
 drivers/crypto/hisilicon/sec2/sec_crypto.h         |  11 -
 drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c        |   3 +
 drivers/dma/ti/edma.c                              |   3 +-
 drivers/firmware/efi/sysfb_efi.c                   |   2 +-
 drivers/gpio/gpio-brcmstb.c                        |   5 +-
 drivers/gpio/gpio-mxc.c                            |   3 +-
 drivers/gpio/gpio-pca953x.c                        | 108 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c            |   2 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c    |   2 +
 .../drm/amd/pm/powerplay/hwmgr/vega10_powertune.c  |   5 +-
 drivers/gpu/drm/bridge/ite-it6505.c                |   2 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem.c              |  16 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |   8 +-
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_5_0_sm8150.h |   2 +
 .../drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h    |   2 +
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_6_0_sm8250.h |   2 +
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_7_0_sm8350.h |   2 +
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_9_0_sm8550.h |   2 +
 drivers/gpu/drm/msm/dp/dp_audio.c                  |   2 +-
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c    |   1 -
 drivers/gpu/drm/rockchip/cdn-dp-core.c             |   1 -
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c    |   1 -
 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c        |   1 -
 drivers/gpu/drm/rockchip/inno_hdmi.c               |   1 -
 drivers/gpu/drm/rockchip/rk3066_hdmi.c             |   1 -
 drivers/gpu/drm/rockchip/rockchip_drm_drv.h        |  18 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop.h        |  12 -
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       | 121 ++-
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.h       |  18 +-
 drivers/gpu/drm/rockchip/rockchip_lvds.c           |   1 -
 drivers/gpu/drm/rockchip/rockchip_rgb.c            |   1 -
 drivers/hid/hid-core.c                             |   2 +
 drivers/hid/hid-input.c                            |  37 +-
 drivers/hid/hid-multitouch.c                       |   2 +-
 drivers/hid/hid-thrustmaster.c                     |   8 +
 drivers/i3c/master/dw-i3c-master.c                 |  66 +-
 drivers/i3c/master/dw-i3c-master.h                 |   2 +
 drivers/iio/adc/ti_am335x_adc.c                    |   4 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   7 +-
 drivers/infiniband/hw/cxgb4/device.c               |   6 +-
 drivers/infiniband/hw/mlx4/main.c                  |   8 +-
 drivers/infiniband/hw/mlx5/odp.c                   |  32 +-
 drivers/infiniband/sw/rxe/rxe.c                    |   6 +-
 drivers/infiniband/sw/rxe/rxe.h                    |   6 +-
 drivers/infiniband/sw/rxe/rxe_comp.c               |   4 +-
 drivers/infiniband/sw/rxe/rxe_cq.c                 |   4 +-
 drivers/infiniband/sw/rxe/rxe_mr.c                 |  16 +-
 drivers/infiniband/sw/rxe/rxe_mw.c                 |   2 +-
 drivers/infiniband/sw/rxe/rxe_param.h              |   2 +-
 drivers/infiniband/sw/rxe/rxe_pool.c               |  11 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   8 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |  12 +-
 drivers/infiniband/sw/rxe/rxe_task.c               |   4 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              | 221 +++---
 drivers/infiniband/ulp/srp/ib_srp.c                |   1 -
 drivers/irqchip/irq-atmel-aic-common.c             |   4 +-
 drivers/irqchip/irq-pic32-evic.c                   |   4 +-
 drivers/leds/leds-cht-wcove.c                      |   6 +-
 drivers/leds/leds-netxbig.c                        |   1 +
 drivers/media/i2c/imx290.c                         |   3 +-
 drivers/media/i2c/imx412.c                         |  42 +-
 drivers/media/i2c/ov9282.c                         |   2 +-
 drivers/media/platform/marvell/mcam-core.c         |   7 +-
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c     |   7 +-
 .../media/platform/nxp/imx8-isi/imx8-isi-video.c   |   3 +
 .../media/platform/samsung/exynos4-is/mipi-csis.c  |  10 +-
 .../media/platform/samsung/s3c-camif/camif-core.c  |  13 +-
 drivers/media/rc/iguanair.c                        |   4 +-
 drivers/media/usb/dvb-usb-v2/af9035.c              |  18 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |  12 +-
 drivers/media/usb/uvc/uvc_queue.c                  |   3 +-
 drivers/media/usb/uvc/uvc_status.c                 |   1 +
 drivers/memory/tegra/tegra20-emc.c                 |   8 +-
 drivers/mfd/syscon.c                               |  81 +-
 drivers/mfd/ti_am335x_tscadc.c                     |   4 +-
 drivers/misc/cardreader/rtsx_usb.c                 |  15 +
 drivers/mtd/hyperbus/hbmc-am654.c                  |  25 +-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |   5 +
 drivers/net/ethernet/broadcom/bgmac.h              |   3 +-
 drivers/net/ethernet/davicom/dm9000.c              |   3 +-
 drivers/net/ethernet/freescale/fec_main.c          |  31 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        |  15 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   2 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   2 +
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  19 +-
 .../net/ethernet/marvell/octeon_ep/octep_main.c    |  10 -
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c    |   2 -
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c  |   8 +-
 drivers/net/ethernet/renesas/sh_eth.c              |   4 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  30 +
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   2 +-
 drivers/net/netdevsim/netdevsim.h                  |   1 +
 drivers/net/netdevsim/udp_tunnels.c                |  23 +-
 drivers/net/team/team.c                            |   7 +
 drivers/net/usb/rtl8150.c                          |  22 +
 drivers/net/vxlan/vxlan_vnifilter.c                |   5 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   1 +
 drivers/net/wireless/ath/ath11k/hal_rx.c           |   3 +-
 drivers/net/wireless/ath/ath12k/mac.c              |   6 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   5 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.h    |   2 +
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  10 -
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   1 -
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  11 +
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |   1 +
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  34 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |  15 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   2 +
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   1 +
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |   1 +
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   8 +-
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |  15 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |  47 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |   4 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |  13 +-
 drivers/net/wireless/realtek/rtlwifi/base.h        |   1 -
 drivers/net/wireless/realtek/rtlwifi/pci.c         |  61 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/sw.c    |   7 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |  12 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  12 -
 drivers/net/wireless/ti/wlcore/main.c              |  10 +-
 drivers/nvme/host/core.c                           |  34 +-
 drivers/of/of_reserved_mem.c                       |   3 +-
 drivers/opp/core.c                                 |  57 +-
 drivers/opp/of.c                                   |   4 +-
 drivers/pci/controller/dwc/pci-imx6.c              | 139 ++--
 drivers/pci/controller/pcie-rcar-ep.c              |   2 +-
 drivers/pci/endpoint/functions/pci-epf-test.c      |   6 +-
 drivers/pci/endpoint/pci-epc-core.c                |   2 +-
 drivers/pinctrl/nxp/pinctrl-s32cc.c                |   4 +-
 drivers/pinctrl/pinctrl-amd.c                      |  27 +-
 drivers/pinctrl/pinctrl-amd.h                      |   7 +-
 drivers/pinctrl/pinctrl-k210.c                     |   4 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |  76 +-
 drivers/pps/clients/pps-gpio.c                     |   4 +-
 drivers/pps/clients/pps-ktimer.c                   |   4 +-
 drivers/pps/clients/pps-ldisc.c                    |   6 +-
 drivers/pps/clients/pps_parport.c                  |   4 +-
 drivers/pps/kapi.c                                 |  10 +-
 drivers/pps/kc.c                                   |  10 +-
 drivers/pps/pps.c                                  | 127 ++--
 drivers/ptp/ptp_chardev.c                          |   4 +
 drivers/ptp/ptp_ocp.c                              |   2 +-
 drivers/pwm/pwm-samsung.c                          |   4 +-
 drivers/pwm/pwm-stm32-lp.c                         |   8 +-
 drivers/pwm/pwm-stm32.c                            |   7 +-
 drivers/regulator/core.c                           |   2 +-
 drivers/regulator/of_regulator.c                   |  14 +-
 drivers/remoteproc/remoteproc_core.c               |  14 +-
 drivers/rtc/rtc-loongson.c                         |  13 +-
 drivers/rtc/rtc-pcf85063.c                         |  11 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   3 +-
 drivers/soc/atmel/soc.c                            |   2 +-
 drivers/spi/spi-omap2-mcspi.c                      |  11 +-
 drivers/spi/spi-zynq-qspi.c                        |  13 +-
 drivers/staging/media/imx/imx-media-of.c           |   8 +-
 drivers/staging/media/max96712/max96712.c          |   4 +-
 drivers/tty/serial/8250/8250_port.c                |  32 +-
 drivers/tty/serial/sc16is7xx.c                     |  34 +-
 drivers/tty/sysrq.c                                |   4 +-
 drivers/ufs/core/ufs_bsg.c                         |   1 +
 drivers/usb/dwc3/core.c                            |  30 +-
 drivers/usb/dwc3/dwc3-am62.c                       |   1 +
 drivers/usb/gadget/function/f_tcm.c                |  14 +-
 drivers/usb/host/xhci-ring.c                       |   3 +-
 drivers/usb/misc/usb251xb.c                        |   4 +-
 drivers/usb/typec/tcpm/tcpci.c                     |  13 +-
 drivers/usb/typec/tcpm/tcpm.c                      |  10 +-
 drivers/vfio/iova_bitmap.c                         |   2 +-
 drivers/video/fbdev/omap2/omapfb/dss/dss-of.c      |   1 +
 drivers/watchdog/rti_wdt.c                         |   1 +
 fs/afs/dir.c                                       |   7 +-
 fs/afs/internal.h                                  |   9 +
 fs/afs/rxrpc.c                                     |  12 +-
 fs/afs/xdr_fs.h                                    |   2 +-
 fs/afs/yfsclient.c                                 |   5 +-
 fs/btrfs/super.c                                   |   2 +-
 fs/buffer.c                                        |  24 +-
 fs/dlm/lowcomms.c                                  |   3 +-
 fs/f2fs/dir.c                                      |  53 +-
 fs/f2fs/f2fs.h                                     |   6 +-
 fs/f2fs/inline.c                                   |   5 +-
 fs/file_table.c                                    |   2 +-
 fs/hostfs/hostfs_kern.c                            | 157 ++--
 fs/nfs/nfs42proc.c                                 |   2 +-
 fs/nfs/nfs42xdr.c                                  |   2 +
 fs/nfsd/nfs4callback.c                             |   1 +
 fs/nilfs2/segment.c                                |  11 +-
 fs/ocfs2/quota_global.c                            |   5 +
 fs/pstore/blk.c                                    |   4 +-
 fs/select.c                                        |   4 +-
 fs/smb/client/cifsacl.c                            |  25 +-
 fs/smb/client/cifsproto.h                          |   2 +-
 fs/smb/client/cifssmb.c                            |   4 +-
 fs/smb/client/readdir.c                            |   2 +-
 fs/smb/client/reparse.c                            |  22 +-
 fs/smb/client/smb2ops.c                            |   3 +-
 fs/ubifs/debug.c                                   |  22 +-
 include/acpi/acpixf.h                              |   1 +
 include/dt-bindings/clock/sun50i-a64-ccu.h         |   2 +
 include/linux/buffer_head.h                        |   4 +-
 include/linux/hid.h                                |   1 +
 include/linux/ieee80211.h                          |  11 +-
 include/linux/kallsyms.h                           |   2 +-
 include/linux/mfd/syscon.h                         |  33 +-
 include/linux/mroute_base.h                        |   6 +-
 include/linux/netdevice.h                          |   2 +-
 include/linux/of.h                                 |  15 +-
 include/linux/perf_event.h                         |   6 +
 include/linux/platform_data/pca953x.h              |  13 -
 include/linux/platform_data/si5351.h               |   2 +
 include/linux/pps_kernel.h                         |   3 +-
 include/linux/sched.h                              |   1 +
 include/linux/usb/tcpm.h                           |   3 +-
 include/net/ax25.h                                 |  10 +-
 include/net/inetpeer.h                             |  12 +-
 include/net/netfilter/nf_tables.h                  |   8 +-
 include/net/xfrm.h                                 |  16 +-
 include/trace/events/afs.h                         |   2 +
 include/trace/events/rxrpc.h                       |  25 +
 io_uring/uring_cmd.c                               |   2 +-
 kernel/bpf/bpf_local_storage.c                     |   8 +-
 kernel/events/core.c                               |  35 +-
 kernel/irq/internals.h                             |   9 +-
 kernel/padata.c                                    |  45 +-
 kernel/power/hibernate.c                           |   7 +-
 kernel/sched/cpufreq_schedutil.c                   |   4 +-
 kernel/sched/fair.c                                |  19 +-
 kernel/sched/topology.c                            |   8 +-
 kernel/trace/bpf_trace.c                           |  13 +-
 net/ax25/af_ax25.c                                 |  12 +-
 net/ax25/ax25_dev.c                                |   4 +-
 net/ax25/ax25_ip.c                                 |   3 +-
 net/ax25/ax25_out.c                                |  22 +-
 net/ax25/ax25_route.c                              |   2 +
 net/core/dev.c                                     |   4 +
 net/core/filter.c                                  |   2 +-
 net/core/sysctl_net_core.c                         |   5 +-
 net/ethtool/netlink.c                              |   2 +-
 net/hsr/hsr_forward.c                              |   7 +-
 net/ipv4/icmp.c                                    |   9 +-
 net/ipv4/inetpeer.c                                |  31 +-
 net/ipv4/ip_fragment.c                             |  15 +-
 net/ipv4/ipmr.c                                    |  28 +-
 net/ipv4/ipmr_base.c                               |   9 +-
 net/ipv4/route.c                                   |  17 +-
 net/ipv4/tcp_cubic.c                               |   8 +-
 net/ipv4/tcp_output.c                              |   9 +-
 net/ipv6/icmp.c                                    |   6 +-
 net/ipv6/ip6_output.c                              |   6 +-
 net/ipv6/ip6mr.c                                   |  28 +-
 net/ipv6/ndisc.c                                   |   8 +-
 net/mac80211/debugfs_netdev.c                      |   2 +-
 net/mac80211/driver-ops.h                          |   3 +
 net/mac80211/rx.c                                  |   1 +
 net/mptcp/options.c                                |  13 +-
 net/mptcp/protocol.c                               |   4 +-
 net/mptcp/protocol.h                               |  30 +-
 net/netfilter/nf_tables_api.c                      |  57 +-
 net/netfilter/nft_flow_offload.c                   |  16 +-
 net/netfilter/nft_set_pipapo.c                     |   7 +-
 net/netfilter/nft_set_rbtree.c                     | 178 +++--
 net/rose/af_rose.c                                 |  16 +-
 net/rose/rose_timer.c                              |  15 +
 net/rxrpc/conn_event.c                             |  12 +-
 net/sched/sch_api.c                                |   4 +
 net/sched/sch_sfq.c                                |  58 +-
 net/smc/af_smc.c                                   |   2 +-
 net/smc/smc_rx.c                                   |  37 +-
 net/smc/smc_rx.h                                   |   8 +-
 net/sunrpc/svcsock.c                               |  12 +-
 net/vmw_vsock/af_vsock.c                           |   5 +
 net/wireless/scan.c                                |  35 +
 net/xfrm/xfrm_replay.c                             |  10 +-
 samples/landlock/sandboxer.c                       |   7 +
 scripts/Makefile.lib                               |   4 +-
 scripts/genksyms/genksyms.c                        |  11 +-
 scripts/genksyms/genksyms.h                        |   2 +-
 scripts/genksyms/parse.y                           |  18 +-
 scripts/kconfig/conf.c                             |   6 +
 scripts/kconfig/confdata.c                         | 113 ++-
 scripts/kconfig/lkc_proto.h                        |   2 +
 scripts/kconfig/symbol.c                           |  10 +
 security/landlock/fs.c                             |  11 +-
 sound/core/seq/Kconfig                             |   5 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/codecs/arizona.c                         |  12 +-
 sound/soc/intel/avs/apl.c                          |  53 +-
 sound/soc/intel/avs/avs.h                          |  40 +-
 sound/soc/intel/avs/core.c                         |  51 +-
 sound/soc/intel/avs/ipc.c                          |  36 +-
 sound/soc/intel/avs/loader.c                       |   2 +-
 sound/soc/intel/avs/messages.h                     |  10 +-
 sound/soc/intel/avs/registers.h                    |   6 +-
 sound/soc/intel/avs/skl.c                          |  30 +-
 sound/soc/rockchip/rockchip_i2s_tdm.c              |  31 +-
 sound/soc/sh/rz-ssi.c                              |   3 +-
 sound/soc/sunxi/sun4i-spdif.c                      |   7 +
 sound/usb/quirks.c                                 |   2 +
 tools/bootconfig/main.c                            |   4 +-
 tools/lib/bpf/linker.c                             |  22 +-
 tools/lib/bpf/usdt.c                               |   2 +-
 tools/perf/builtin-lock.c                          |  66 +-
 tools/perf/builtin-report.c                        |   2 +-
 tools/perf/builtin-top.c                           |   2 +-
 tools/perf/builtin-trace.c                         |   6 +-
 tools/perf/util/bpf-event.c                        |  10 +-
 tools/perf/util/env.c                              |  13 +-
 tools/perf/util/env.h                              |   4 +-
 tools/perf/util/expr.c                             |   5 +-
 tools/perf/util/header.c                           |   8 +-
 tools/perf/util/machine.c                          |   2 +-
 tools/perf/util/namespaces.c                       |   7 +-
 tools/perf/util/namespaces.h                       |   3 +-
 .../cpupower/utils/idle_monitor/mperf_monitor.c    |  15 +-
 tools/testing/ktest/ktest.pl                       |   7 +-
 .../selftests/bpf/prog_tests/fill_link_info.c      |   4 +
 .../selftests/bpf/progs/test_fill_link_info.c      |  13 +-
 tools/testing/selftests/bpf/test_tc_tunnel.sh      |   1 +
 .../drivers/net/netdevsim/udp_tunnel_nic.sh        |  16 +-
 tools/testing/selftests/kselftest_harness.h        |  24 +-
 tools/testing/selftests/landlock/fs_test.c         |   3 +-
 .../selftests/powerpc/benchmarks/gettimeofday.c    |   2 +-
 tools/testing/selftests/rseq/rseq.c                |  32 +-
 tools/testing/selftests/rseq/rseq.h                |   9 +-
 .../testing/selftests/timers/clocksource-switch.c  |   6 +-
 455 files changed, 4496 insertions(+), 3375 deletions(-)


