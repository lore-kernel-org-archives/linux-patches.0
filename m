Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820872C375E;
	Wed, 21 Jan 2026 18:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019512; cv=none; b=IdItNzXXVkt4t7wAAthKoVjBMOz6G9TA0/8NFbIzZj0/CRte1ZZu4epstrv1SfCABKa41q6KVpEbQ8e1NJyOeslCQtHqPVSoSYLJUZHM7fTWAiE0pY0VqubxP6K1Qp8OOwxPN+XusFJyLJLhvayeht5Ezao+h39Br4Yil9I6Kps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019512; c=relaxed/simple;
	bh=KHkO+6rFaSqGIRO/YchO5nb0riedVXms6Moflhz7l40=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MSwgNdXo5kY9BhxH3Qm3OV+YE41USerlCiqn0BMhbEnjLEsPOiE0wC6UWEYoi9DCBcUOR4umQtoafj3e33jNlYH7bbD9+gQ2OaNuG/X1gdtcccDN0chVnA0yNeVzIHjMbNpytSQDEzmXt5mTyWVIQg71ffVxNL9QLWCJ4ygbGKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRRIoFdt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRRIoFdt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC25C4CEF1;
	Wed, 21 Jan 2026 18:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019512;
	bh=KHkO+6rFaSqGIRO/YchO5nb0riedVXms6Moflhz7l40=;
	h=From:To:Cc:Subject:Date:From;
	b=cRRIoFdtW63Zf45h65CeqthbRFfT41hcP6df9I/8iDzZZ17GHCMFgCfdEw801nhuT
	 ncqN3Yn8Ug0DE1eByVfHS0TzAGLwSgmP1UcgYiw11NoBpuVzLst6fB677bPafB39ah
	 WlPlP2RTMsN5JcmbqxmhOZ6XcLw0brSXSv59T6XQ=
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
Subject: [PATCH 6.12 000/139] 6.12.67-rc1 review
Date: Wed, 21 Jan 2026 19:14:08 +0100
Message-ID: <20260121181411.452263583@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.67-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.67-rc1
X-KernelTest-Deadline: 2026-01-23T18:14+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.67 release.
There are 139 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 23 Jan 2026 18:13:43 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.67-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.67-rc1

Bruno Faccini <bfaccini@nvidia.com>
    mm/fake-numa: handle cases with no SRAT info

Vlastimil Babka <vbabka@suse.cz>
    mm/page_alloc: prevent pcp corruption with SMP=n

Joshua Hahn <joshua.hahnjy@gmail.com>
    mm/page_alloc: batch page freeing in decay_pcp_high

Joshua Hahn <joshua.hahnjy@gmail.com>
    mm/page_alloc/vmstat: simplify refresh_cpu_vm_stats change detection

Zhen Ni <zhen.ni@easystack.cn>
    dmaengine: fsl-edma: Fix clk leak on alloc_chan_resources failure

Wentao Liang <vulab@iscas.ac.cn>
    phy: rockchip: inno-usb2: Fix a double free bug in rockchip_usb2phy_probe()

Dragan Simic <dsimic@manjaro.org>
    phy: phy-rockchip-inno-usb2: Use dev_err_probe() in the probe path

Ben Dooks <ben.dooks@codethink.co.uk>
    mm: numa,memblock: include <asm/numa.h> for 'numa_nodes_parsed'

Bruno Faccini <bfaccini@nvidia.com>
    mm/fake-numa: allow later numa node hotplug

Ryan Roberts <ryan.roberts@arm.com>
    mm: kmsan: fix poisoning of high-order non-compound pages

Paul Chaignon <paul.chaignon@gmail.com>
    selftests/bpf: Test invalid narrower ctx load

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Reject narrower access to pointer ctx fields

SeongJae Park <sj@kernel.org>
    mm/damon/sysfs-scheme: cleanup access_pattern subdirs on scheme dir setup failure

SeongJae Park <sj@kernel.org>
    mm/damon/sysfs-scheme: cleanup quotas subdirs on scheme dir setup failure

Brian Foster <bfoster@redhat.com>
    xfs: set max_agbno to allow sparse alloc of last full inode chunk

Robbie Ko <robbieko@synology.com>
    btrfs: fix deadlock in wait_current_trans() due to ignored transaction type

Nathan Chancellor <nathan@kernel.org>
    HID: intel-ish-hid: Fix -Wcast-function-type-strict in devm_ishtp_alloc_workqueue()

Zhang Lixu <lixu.zhang@intel.com>
    HID: intel-ish-hid: Use dedicated unbound workqueues to prevent resume blocking

Johan Hovold <johan@kernel.org>
    dmaengine: ti: k3-udma: fix device leak on udma lookup

Johan Hovold <johan@kernel.org>
    dmaengine: ti: dma-crossbar: fix device leak on am335x route allocation

Johan Hovold <johan@kernel.org>
    dmaengine: ti: dma-crossbar: fix device leak on dra7x route allocation

Johan Hovold <johan@kernel.org>
    dmaengine: stm32: dmamux: fix OF node leak on route allocation failure

Johan Hovold <johan@kernel.org>
    dmaengine: stm32: dmamux: fix device leak on route allocation

Biju Das <biju.das.jz@bp.renesas.com>
    dmaengine: sh: rz-dmac: Fix rz_dmac_terminate_all()

Miaoqian Lin <linmq006@gmail.com>
    dmaengine: qcom: gpi: Fix memory leak in gpi_peripheral_config()

Johan Hovold <johan@kernel.org>
    dmaengine: lpc32xx-dmamux: fix device leak on route allocation

Johan Hovold <johan@kernel.org>
    dmaengine: lpc18xx-dmamux: fix device leak on route allocation

Johan Hovold <johan@kernel.org>
    dmaengine: idxd: fix device leaks on compat bind and unbind

Johan Hovold <johan@kernel.org>
    dmaengine: dw: dmamux: fix OF node leak on route allocation failure

Johan Hovold <johan@kernel.org>
    dmaengine: bcm-sba-raid: fix device leak on probe

Johan Hovold <johan@kernel.org>
    dmaengine: at_hdmac: fix device leak on of_dma_xlate()

Janne Grunau <j@jannau.net>
    dmaengine: apple-admac: Add "apple,t8103-admac" compatible

Binbin Zhou <zhoubinbin@loongson.cn>
    LoongArch: dts: loongson-2k2000: Add default interrupt controller address cells

Binbin Zhou <zhoubinbin@loongson.cn>
    LoongArch: dts: loongson-2k1000: Fix i2c-gpio node names

Binbin Zhou <zhoubinbin@loongson.cn>
    LoongArch: dts: loongson-2k1000: Add default interrupt controller address cells

Binbin Zhou <zhoubinbin@loongson.cn>
    LoongArch: dts: loongson-2k0500: Add default interrupt controller address cells

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    drm/vmwgfx: Fix an error return check in vmw_compat_shader_add()

Marek Vasut <marex@nabladev.com>
    drm/panel-simple: fix connector type for DataImage SCF0700C48GGU18 panel

Lyude Paul <lyude@redhat.com>
    drm/nouveau/disp/nv50-: Set lock_core in curs507a_prepare

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    drm/amdkfd: fix a memory leak in device_queue_manager_init()

Mario Limonciello (AMD) <superm1@kernel.org>
    drm/amd: Clean up kfd node on surprise disconnect

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Bump the HDMI clock to 340MHz

Lisa Robinson <lisa@bytefly.space>
    LoongArch: Fix PMU counter allocation for mixed-type event groups

SeongJae Park <sj@kernel.org>
    mm/damon/sysfs: cleanup attrs subdirs on context dir setup failure

Aboorva Devarajan <aboorvad@linux.ibm.com>
    mm/page_alloc: make percpu_pagelist_high_fraction reads lock-free

Pavel Butsykin <pbutsykin@cloudlinux.com>
    mm/zswap: fix error pointer free in zswap_cpu_comp_prepare()

Nilay Shroff <nilay@linux.ibm.com>
    nvme: fix PCIe subsystem reset controller state transition

Xiaochen Shen <shenxiaochen@open-hieco.net>
    x86/resctrl: Fix memory bandwidth counter width for Hygon

Xiaochen Shen <shenxiaochen@open-hieco.net>
    x86/resctrl: Add missing resctrl initialization for Hygon

Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
    i2c: riic: Move suspend handling to NOIRQ phase

Arnaud Ferraris <arnaud.ferraris@collabora.com>
    tcpm: allow looking for role_sw device in the main node

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    EDAC/i3200: Fix a resource leak in i3200_probe1()

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    EDAC/x38: Fix a resource leak in x38_probe1()

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    hrtimer: Fix softirq base check in update_needs_ipi()

Yang Erkun <yangerkun@huawei.com>
    ext4: fix iloc.bh leak in ext4_xattr_inode_update_ref

Johan Hovold <johan@kernel.org>
    ASoC: codecs: wsa881x: fix unnecessary initialisation

Ilikara Zheng <ilikara@aosc.io>
    nvme-pci: disable secondary temp for Wodposit WPBSNM8

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    USB: serial: ftdi_sio: add support for PICAXE AXE027 cable

Ulrich Mohr <u.mohr@semex-engcon.com>
    USB: serial: option: add Telit LE910 MBIM composition

Huacai Chen <chenhuacai@kernel.org>
    USB: OHCI/UHCI: Add soft dependencies on ehci_platform

Johannes Brüderl <johannes.bruederl@gmail.com>
    usb: core: add USB_QUIRK_NO_BOS for devices that hang on BOS descriptor

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: Check for USB4 IP_NAME

Wayne Chang <waynec@nvidia.com>
    phy: tegra: xusb: Explicitly configure HS_DISCON_LEVEL to 0x7

Louis Chauvet <louis.chauvet@bootlin.com>
    phy: rockchip: inno-usb2: fix disconnection in gadget mode

Rafael Beims <rafael.beims@toradex.com>
    phy: freescale: imx8m-pcie: assert phy reset during power on

Johan Hovold <johan@kernel.org>
    phy: ti: gmii-sel: fix regmap leak on probe failure

Luca Ceresoli <luca.ceresoli@bootlin.com>
    phy: rockchip: inno-usb2: fix communication disruption in gadget mode

Dan Williams <dan.j.williams@intel.com>
    x86/kaslr: Recognize all ZONE_DEVICE users as physaddr consumers

Shakeel Butt <shakeel.butt@linux.dev>
    lib/buildid: use __kernel_read() for sleepable context

Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
    xfs: Fix the return value of xfs_rtcopy_summary()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    net: can: j1939: j1939_xtp_rx_rts_session_active(): deactivate session upon receiving the second rts

Ondrej Ille <ondrej.ille@gmail.com>
    can: ctucanfd: fix SSP_SRC in cases when bit-rate is higher than 1 MBit.

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_usb_receive_bulk_callback(): fix URB memory leak

Nilay Shroff <nilay@linux.ibm.com>
    null_blk: fix kmemleak by releasing references to fault configfs items

Jaroslav Kysela <perex@perex.cz>
    ALSA: pcm: Improve the fix for race of buffer access at PCM OSS layer

Brian Kao <powenkao@google.com>
    scsi: core: Fix error handler encryption support

Ming Lei <ming.lei@redhat.com>
    io_uring: move local task_work in exit cancel loop

Tzung-Bi Shih <tzungbi@kernel.org>
    drm/amd/display: mark static functions noinline_for_stack

Johan Hovold <johan@kernel.org>
    ASoC: codecs: wsa883x: fix unnecessary initialisation

Ido Schimmel <idosch@nvidia.com>
    bridge: mcast: Fix use-after-free during router port configuration

Benjamin Tissoires <bentiss@kernel.org>
    HID: usbhid: paper over wrong bNumDescriptor field

Neil Armstrong <neil.armstrong@linaro.org>
    i2c: qcom-geni: make sure I2C hub controllers can't use SE DMA

Haotian Zhang <vulab@iscas.ac.cn>
    dmaengine: omap-dma: fix dma_pool resource leak in error paths

Günther Noack <gnoack3000@gmail.com>
    selftests/landlock: Properly close a file descriptor

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    phy: broadcom: ns-usb3: Fix Wvoid-pointer-to-enum-cast warning (again)

Matthieu Buffet <matthieu@buffet.re>
    selftests/landlock: Remove invalid unix socket bind()

Matthieu Buffet <matthieu@buffet.re>
    selftests/landlock: Fix TCP bind(AF_UNSPEC) test case

Haotian Zhang <vulab@iscas.ac.cn>
    phy: ti: da8xx-usb: Handle devm_pm_runtime_enable() errors

Dan Carpenter <dan.carpenter@linaro.org>
    phy: stm32-usphyc: Fix off by one in probe()

Loic Poulain <loic.poulain@oss.qualcomm.com>
    phy: qcom-qusb2: Fix NULL pointer dereference on early suspend

Johan Hovold <johan+linaro@kernel.org>
    phy: drop probe registration printks

Ivaylo Ivanov <ivo.ivanov.ivanov1@gmail.com>
    phy: phy-snps-eusb2: refactor constructs names

Stefano Radaelli <stefano.radaelli21@gmail.com>
    phy: fsl-imx8mq-usb: Clear the PCS_TX_SWING_FULL field before using it

Suraj Gupta <suraj.gupta2@amd.com>
    dmaengine: xilinx_dma: Fix uninitialized addr_width when "xlnx,addrwidth" property is missing

Sheetal <sheetal@nvidia.com>
    dmaengine: tegra-adma: Fix use-after-free

Anthony Brandon <anthony@amarulasolutions.com>
    dmaengine: xilinx: xdma: Fix regmap max_register

Bagas Sanjaya <bagasdotme@gmail.com>
    mm, kfence: describe @slab parameter in __kfence_obj_info()

Bagas Sanjaya <bagasdotme@gmail.com>
    textsearch: describe @list member in ts_ops search

Bagas Sanjaya <bagasdotme@gmail.com>
    mm: describe @flags parameter in memalloc_flags_save()

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: fix smu overdrive data type wrong issue on smu 14.0.2

Emil Svendsen <emas@bang-olufsen.dk>
    ASoC: tlv320adcx140: fix word length

Emil Svendsen <emas@bang-olufsen.dk>
    ASoC: tlv320adcx140: fix null pointer

Cole Leavitt <cole@unwrap.rs>
    ASoC: sdw_utils: cs42l43: Enable Headphone pin for LINEOUT jack type

Eric Dumazet <edumazet@google.com>
    net/sched: sch_qfq: do not free existing class in qfq_change_class()

Gal Pressman <gal@nvidia.com>
    selftests: drv-net: fix RPS mask handling for high CPU numbers

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: Fix use-after-free in inet6_addr_del().

Aditya Garg <gargaditya@linux.microsoft.com>
    net: hv_netvsc: reject RSS hash key programming without RX indirection table

Richard Fitzgerald <rf@opensource.cirrus.com>
    ALSA: hda/cirrus_scodec_test: Fix incorrect setup of gpiochip

Kery Qi <qikeyu2017@gmail.com>
    net: octeon_ep_vf: fix free_irq dev_id mismatch in IRQ rollback

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    btrfs: fix memory leaks in create_space_info() error paths

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: introduce btrfs_space_info sub-group

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: factor out check_removing_space_info() from btrfs_free_block_groups()

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: factor out init_space_info() from create_space_info()

Saeed Mahameed <saeedm@nvidia.com>
    net/mlx5e: Restore destroying state bit after profile cleanup

Saeed Mahameed <saeedm@nvidia.com>
    net/mlx5e: Pass netdev to mlx5e_destroy_netdev instead of priv

Saeed Mahameed <saeedm@nvidia.com>
    net/mlx5e: Don't store mlx5e_priv in mlx5e_dev devlink priv

Saeed Mahameed <saeedm@nvidia.com>
    net/mlx5e: Fix crash on profile change rollback failure

Stefano Garzarella <sgarzare@redhat.com>
    vsock/test: add a final full barrier after run all tests

Eric Dumazet <edumazet@google.com>
    ipv4: ip_gre: make ipgre_header() robust

Eric Dumazet <edumazet@google.com>
    macvlan: fix possible UAF in macvlan_forward_source()

Eric Dumazet <edumazet@google.com>
    net: update netdev_lock_{type,name}

Eric Dumazet <edumazet@google.com>
    ip6_tunnel: use skb_vlan_inet_prepare() in __ip6_tnl_rcv()

Eric Dumazet <edumazet@google.com>
    net: bridge: annotate data-races around fdb->{updated,used}

Qu Wenruo <wqu@suse.com>
    btrfs: send: check for inline extents in range_is_hole_in_parent()

Shivam Kumar <kumar.shivam43666@gmail.com>
    nvme-tcp: fix NULL pointer dereferences in nvmet_tcp_build_pdu_iovec

Szymon Wilczek <swilczek.lx@gmail.com>
    can: etas_es58x: allow partial RX URB allocation to succeed

Yaxiong Tian <tianyaxiong@kylinos.cn>
    PM: EM: Fix incorrect description of the cost field in struct em_perf_state

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Merge vmw_bo_release and vmw_bo_free functions

Zilin Guan <zilin@seu.edu.cn>
    pnfs/blocklayout: Fix memory leak in bl_parse_scsi()

Zilin Guan <zilin@seu.edu.cn>
    pnfs/flexfiles: Fix memory leak in nfs4_ff_alloc_deviceid_node()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix a deadlock involving nfs_release_folio()

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS: Fix a deadlock when returning a delegation during open()

Antony Antony <antony.antony@secunet.com>
    xfrm: set ipv4 no_pmtu_disc flag only on output sa when direction is set

Jianbo Liu <jianbol@nvidia.com>
    xfrm: Fix inner mode lookup in tunnel mode GSO segmentation

Johan Hovold <johan@kernel.org>
    ASoC: codecs: wsa884x: fix codec initialisation

Sean Christopherson <seanjc@google.com>
    x86/fpu: Clear XSTATE_BV[i] in guest XSAVE state whenever XFD[i]=1

Andreas Gruenbacher <agruenba@redhat.com>
    Revert "gfs2: Fix use of bio_chain"

Morduan Zang <zhangdandan@uniontech.com>
    efi/cper: Fix cper_bits_to_str buffer handling and return value

Peng Fan <peng.fan@nxp.com>
    firmware: imx: scu-irq: Set mu_resource_id before get handle


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/loongarch/boot/dts/loongson-2k0500.dtsi       |   3 +
 arch/loongarch/boot/dts/loongson-2k1000.dtsi       |   6 +-
 arch/loongarch/boot/dts/loongson-2k2000.dtsi       |   3 +
 arch/loongarch/kernel/perf_event.c                 |  21 +-
 arch/x86/kernel/cpu/resctrl/core.c                 |  21 +-
 arch/x86/kernel/cpu/resctrl/internal.h             |   3 +
 arch/x86/kernel/fpu/core.c                         |  32 ++-
 arch/x86/kvm/x86.c                                 |   9 +
 arch/x86/mm/kaslr.c                                |  10 +-
 drivers/acpi/numa/srat.c                           |  95 ++++++++
 drivers/block/null_blk/main.c                      |  12 +-
 drivers/dma/apple-admac.c                          |   1 +
 drivers/dma/at_hdmac.c                             |   9 +-
 drivers/dma/bcm-sba-raid.c                         |   6 +-
 drivers/dma/dw/rzn1-dmamux.c                       |   4 +-
 drivers/dma/fsl-edma-common.c                      |   1 +
 drivers/dma/idxd/compat.c                          |  23 +-
 drivers/dma/lpc18xx-dmamux.c                       |  19 +-
 drivers/dma/lpc32xx-dmamux.c                       |  19 +-
 drivers/dma/qcom/gpi.c                             |   6 +-
 drivers/dma/sh/rz-dmac.c                           |   5 +
 drivers/dma/stm32/stm32-dmamux.c                   |  22 +-
 drivers/dma/tegra210-adma.c                        |  10 +-
 drivers/dma/ti/dma-crossbar.c                      |  18 +-
 drivers/dma/ti/k3-udma-private.c                   |   2 +-
 drivers/dma/ti/omap-dma.c                          |   4 +
 drivers/dma/xilinx/xdma-regs.h                     |   1 +
 drivers/dma/xilinx/xdma.c                          |   2 +-
 drivers/dma/xilinx/xilinx_dma.c                    |   7 +-
 drivers/edac/i3200_edac.c                          |  11 +-
 drivers/edac/x38_edac.c                            |   9 +-
 drivers/firmware/efi/cper.c                        |   2 +-
 drivers/firmware/imx/imx-scu-irq.c                 |  24 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   8 +
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  19 +-
 drivers/gpu/drm/amd/display/dc/dc_hdmi_types.h     |   2 +-
 .../drm/amd/display/dc/dml2/display_mode_core.c    |  12 +-
 .../dml21/src/dml2_core/dml2_core_dcn4_calcs.c     |   8 +-
 .../gpu/drm/amd/display/dc/link/link_detection.c   |   4 +-
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c   |   3 +-
 drivers/gpu/drm/nouveau/dispnv50/curs507a.c        |   1 +
 drivers/gpu/drm/panel/panel-simple.c               |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c                 |  22 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c             |   4 +-
 drivers/hid/intel-ish-hid/ipc/ipc.c                |  25 +-
 drivers/hid/intel-ish-hid/ipc/pci-ish.c            |   2 +-
 drivers/hid/intel-ish-hid/ishtp-hid-client.c       |   4 +-
 drivers/hid/intel-ish-hid/ishtp/bus.c              |  18 +-
 drivers/hid/intel-ish-hid/ishtp/hbm.c              |   4 +-
 drivers/hid/intel-ish-hid/ishtp/ishtp-dev.h        |   3 +
 drivers/hid/usbhid/hid-core.c                      |  17 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |  11 +-
 drivers/i2c/busses/i2c-riic.c                      |  46 +++-
 drivers/net/can/ctucanfd/ctucanfd_base.c           |   2 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   2 +-
 drivers/net/can/usb/gs_usb.c                       |   2 +
 .../ethernet/marvell/octeon_ep_vf/octep_vf_main.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  86 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  15 +-
 drivers/net/hyperv/netvsc_drv.c                    |   3 +
 drivers/net/macvlan.c                              |  20 +-
 drivers/nvme/host/pci.c                            |   7 +-
 drivers/nvme/target/tcp.c                          |  12 +
 drivers/pci/Kconfig                                |   6 -
 drivers/phy/broadcom/phy-bcm-ns-usb3.c             |   2 +-
 drivers/phy/broadcom/phy-bcm-ns2-pcie.c            |   2 -
 drivers/phy/broadcom/phy-bcm-ns2-usbdrd.c          |   1 -
 drivers/phy/broadcom/phy-bcm-sr-pcie.c             |   2 -
 drivers/phy/broadcom/phy-brcm-sata.c               |   2 +-
 drivers/phy/freescale/phy-fsl-imx8m-pcie.c         |   3 +-
 drivers/phy/freescale/phy-fsl-imx8mq-usb.c         |   1 +
 drivers/phy/marvell/phy-pxa-usb.c                  |   1 -
 drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c     |   2 -
 drivers/phy/qualcomm/phy-qcom-m31.c                |   2 -
 drivers/phy/qualcomm/phy-qcom-qusb2.c              |  18 +-
 drivers/phy/qualcomm/phy-qcom-snps-eusb2.c         | 256 ++++++++++-----------
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c      |  41 ++--
 drivers/phy/st/phy-stih407-usb.c                   |   2 -
 drivers/phy/st/phy-stm32-usbphyc.c                 |   6 +-
 drivers/phy/tegra/xusb-tegra186.c                  |   3 +
 drivers/phy/ti/phy-da8xx-usb.c                     |   7 +-
 drivers/phy/ti/phy-gmii-sel.c                      |   2 +-
 drivers/phy/ti/phy-twl4030-usb.c                   |   1 -
 drivers/scsi/scsi_error.c                          |  24 ++
 drivers/usb/core/config.c                          |   5 +
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/dwc3/core.c                            |   2 +
 drivers/usb/dwc3/core.h                            |   1 +
 drivers/usb/host/ohci-platform.c                   |   1 +
 drivers/usb/host/uhci-platform.c                   |   1 +
 drivers/usb/serial/ftdi_sio.c                      |   1 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   2 +
 drivers/usb/serial/option.c                        |   1 +
 drivers/usb/typec/tcpm/tcpm.c                      |   2 +-
 fs/btrfs/block-group.c                             |  60 +++--
 fs/btrfs/send.c                                    |   2 +
 fs/btrfs/space-info.c                              |  75 ++++--
 fs/btrfs/space-info.h                              |   9 +
 fs/btrfs/sysfs.c                                   |  18 +-
 fs/btrfs/transaction.c                             |  11 +-
 fs/ext4/xattr.c                                    |   1 +
 fs/gfs2/lops.c                                     |   2 +-
 fs/nfs/blocklayout/dev.c                           |   6 +-
 fs/nfs/file.c                                      |   3 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   2 +-
 fs/nfs/nfs4proc.c                                  |   6 +-
 fs/nfs/nfstrace.h                                  |   3 +
 fs/nfs/pnfs.c                                      |  58 +++--
 fs/nfs/pnfs.h                                      |  17 +-
 fs/nfs/write.c                                     |  33 +++
 fs/xfs/libxfs/xfs_ialloc.c                         |  11 +-
 fs/xfs/xfs_rtalloc.c                               |   2 +-
 include/acpi/acpi_numa.h                           |   5 +
 include/linux/energy_model.h                       |   2 +-
 include/linux/gfp.h                                |   2 +-
 include/linux/intel-ish-client-if.h                |   2 +
 include/linux/kfence.h                             |   1 +
 include/linux/nfs_fs.h                             |   1 +
 include/linux/numa_memblks.h                       |   3 +
 include/linux/sched/mm.h                           |   1 +
 include/linux/textsearch.h                         |   1 +
 include/linux/usb/quirks.h                         |   3 +
 include/scsi/scsi_eh.h                             |   6 +
 include/sound/pcm.h                                |   2 +-
 io_uring/io_uring.c                                |   8 +-
 kernel/bpf/cgroup.c                                |   8 +-
 kernel/time/hrtimer.c                              |   2 +-
 lib/buildid.c                                      |  32 ++-
 mm/Kconfig                                         |  10 +-
 mm/damon/sysfs-schemes.c                           |  10 +-
 mm/damon/sysfs.c                                   |   5 +-
 mm/kmsan/shadow.c                                  |   2 +-
 mm/numa_emulation.c                                |  45 +++-
 mm/numa_memblks.c                                  |   4 +-
 mm/page_alloc.c                                    |  74 ++++--
 mm/vmstat.c                                        |  28 +--
 mm/zswap.c                                         |   2 +-
 net/bridge/br_fdb.c                                |  28 ++-
 net/bridge/br_input.c                              |   4 +-
 net/bridge/br_multicast.c                          |   9 +
 net/can/j1939/transport.c                          |  10 +-
 net/core/dev.c                                     |  25 +-
 net/core/filter.c                                  |  20 +-
 net/ipv4/esp4_offload.c                            |   4 +-
 net/ipv4/ip_gre.c                                  |  11 +-
 net/ipv6/addrconf.c                                |   4 +-
 net/ipv6/esp6_offload.c                            |   4 +-
 net/ipv6/ip6_tunnel.c                              |   2 +-
 net/sched/sch_qfq.c                                |   6 +-
 net/xfrm/xfrm_state.c                              |   1 +
 sound/core/oss/pcm_oss.c                           |   4 +-
 sound/core/pcm_native.c                            |   9 +-
 sound/pci/hda/cirrus_scodec_test.c                 |   1 +
 sound/soc/codecs/tlv320adcx140.c                   |   8 +-
 sound/soc/codecs/wsa881x.c                         |   9 +
 sound/soc/codecs/wsa883x.c                         |   9 +
 sound/soc/codecs/wsa884x.c                         |   3 +-
 sound/soc/sdw_utils/soc_sdw_cs42l43.c              |   2 +-
 tools/testing/selftests/bpf/progs/verifier_ctx.c   |  25 ++
 tools/testing/selftests/landlock/common.h          |   1 +
 tools/testing/selftests/landlock/fs_test.c         |   6 +-
 tools/testing/selftests/landlock/net_test.c        |  16 +-
 tools/testing/selftests/net/toeplitz.c             |   4 +-
 tools/testing/vsock/util.c                         |  12 +
 166 files changed, 1424 insertions(+), 596 deletions(-)


