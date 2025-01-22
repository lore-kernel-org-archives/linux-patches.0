Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA2D8F7D;
	Wed, 22 Jan 2025 08:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737533038; cv=none; b=tyPKfy+JhqQzqCM795cFrHQdHixrHa+AaPJzCDuDzPJAc1iQkfA1lXoMgQwPRqu6UINfeUcsTBfZ7swpuY+lGp1WaAgvLGlyzjfi3Rz+9aYtzI4lp0zZs4OfHfW2ra1eBUL3I8MBDnUIp1mp9qmf2RxHbIbO6XNtwFjMAOIHBUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737533038; c=relaxed/simple;
	bh=lxpClQ3wH5IHcKHpyUPEvONOuDZLcy3Jo8KCJG75krs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Idfbzx7d7D3EzJ4V8y1JUqSnMBDinQv3uQ7MKhE1nJQRf0b9qIq4BOnshSXaimlqLPgCiqmUMJ6KixNms/3RONdTz4znyhiW7BYcqtQITRslrzAXYJaF6yXEl41QcUuoToXkhVWQJFlu3wBkwZdA2OmVlR+tfvHbzvLsda0qSK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNEe+8o3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNEe+8o3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21444C4CED6;
	Wed, 22 Jan 2025 08:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737533037;
	bh=lxpClQ3wH5IHcKHpyUPEvONOuDZLcy3Jo8KCJG75krs=;
	h=From:To:Cc:Subject:Date:From;
	b=zNEe+8o3vTLNBTl9hQBIMRGrcGrPiC0yk0m65Q5FAdcyk0/OfIlQTQq/URVsq7aUI
	 TIj03zlbVJqKR/Rs0b4vyE3PTnZsym8Il3mmgxjwdhaQrI6LhKmlCQR1MwZLPzUXV5
	 3IGKHEamv92ZOGYybkZNFPUD29pJhmki9SGl8zp8=
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
Subject: [PATCH 5.15 000/127] 5.15.177-rc2 review
Date: Wed, 22 Jan 2025 09:03:53 +0100
Message-ID: <20250122073830.779239943@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.177-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.177-rc2
X-KernelTest-Deadline: 2025-01-24T07:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.177 release.
There are 127 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 24 Jan 2025 07:38:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.177-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.177-rc2

Wang Liang <wangliang74@huawei.com>
    net: fix data-races around sk->sk_forward_alloc

Suraj Sonawane <surajsonawane0215@gmail.com>
    scsi: sg: Fix slab-use-after-free read in sg_release()

Juergen Gross <jgross@suse.com>
    x86/xen: fix SLS mitigation in xen_hypercall_iret()

Youzhong Yang <youzhong@gmail.com>
    nfsd: add list_head nf_gc to struct nfsd_file

Eric Dumazet <edumazet@google.com>
    ipv6: avoid possible NULL deref in rt6_uncached_list_flush_dev()

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: discard packets if the transport changes

Tejun Heo <tj@kernel.org>
    blk-cgroup: Fix UAF in blkcg_unpin_online()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "regmap: detach regmap from dev on regmap_exit"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "drm/amdgpu: rework resume handling for display (v2)"

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: adc: rockchip_saradc: fix information leak in triggered buffer

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: fix timestamps after suspend if sensor is on

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: fix spi burst write not supported

Terry Tritton <terry.tritton@linaro.org>
    Revert "PCI: Use preserve_config in place of pci_flags"

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/fb: Relax clear color alignment to 64 bytes

Koichiro Den <koichiro.den@canonical.com>
    hrtimers: Handle CPU state correctly on hotplug

Yogesh Lal <quic_ylal@quicinc.com>
    irqchip/gic-v3: Handle CPU_PM_ENTER_FAILED correctly

Zhongqiu Han <quic_zhonhan@quicinc.com>
    gpiolib: cdev: Fix use after free in lineinfo_changed_notify

Rik van Riel <riel@surriel.com>
    fs/proc: fix softlockup in __read_vmcore (part 2)

Marco Nelissen <marco.nelissen@gmail.com>
    filemap: avoid truncating 64-bit offset to 32 bits

Stefano Garzarella <sgarzare@redhat.com>
    vsock: prevent null-ptr-deref in vsock_*[has_data|has_space]

Stefano Garzarella <sgarzare@redhat.com>
    vsock: reset socket state when de-assigning the transport

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: cancel close work in the destructor

Heiner Kallweit <hkallweit1@gmail.com>
    net: ethernet: xgbe: re-add aneg to supported features in PHY quirks

Juergen Gross <jgross@suse.com>
    x86/asm: Make serialize() always_inline

Kairui Song <kasong@tencent.com>
    zram: fix potential UAF of zram table

Luis Chamberlain <mcgrof@kernel.org>
    nvmet: propagate npwg topology

Oleg Nesterov <oleg@redhat.com>
    poll_wait: add mb() to fix theoretical race between waitqueue_active() and .poll()

Hans de Goede <hdegoede@redhat.com>
    ACPI: resource: acpi_dev_irq_override(): Check DMI match last

David Howells <dhowells@redhat.com>
    kheaders: Ignore silly-rename files

Zhang Kunbo <zhangkunbo@huawei.com>
    fs: fix missing declaration of init_files

Leo Stone <leocstone@gmail.com>
    hfs: Sanity check the root record

Lizhi Xu <lizhi.xu@windriver.com>
    mac802154: check local interfaces before deleting sdata list

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: fix NACK handling when being a target

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: mux: demux-pinctrl: check initial mux selection, too

Pratyush Yadav <pratyush@kernel.org>
    Revert "mtd: spi-nor: core: replace dummy buswidth from addr to data"

David Lechner <dlechner@baylibre.com>
    hwmon: (tmp513) Fix division of negative numbers

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Ensure job pointer is set to NULL after job completion

Patrisious Haddad <phaddad@nvidia.com>
    net/mlx5: Fix RDMA TX steering prio

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: Refactor mlx5_get_flow_namespace

Aharon Landau <aharonl@nvidia.com>
    net/mlx5: Add priorities for counters in RDMA namespaces

Sean Anderson <sean.anderson@linux.dev>
    net: xilinx: axienet: Fix IRQ coalescing packet count overflow

Dan Carpenter <dan.carpenter@linaro.org>
    nfp: bpf: prevent integer overflow in nfp_bpf_event_output()

Kuniyuki Iwashima <kuniyu@amazon.com>
    gtp: Destroy device along with udp socket's netns dismantle.

Kuniyuki Iwashima <kuniyu@amazon.com>
    gtp: Use for_each_netdev_rcu() in gtp_genl_dump_pdp().

Eric Dumazet <edumazet@google.com>
    gtp: use exit_batch_rtnl() method

Eric Dumazet <edumazet@google.com>
    net: add exit_batch_rtnl() method

Artem Chernyshev <artem.chernyshev@red-soft.ru>
    pktgen: Avoid out-of-bounds access in get_imix_entries

Michal Luczaj <mhal@rbox.co>
    bpf: Fix bpf_sk_select_reuseport() memory leak

Sudheer Kumar Doredla <s-doredla@ti.com>
    net: ethernet: ti: cpsw_ale: Fix cpsw_ale_get_field()

Justin Chen <justinpopo6@gmail.com>
    phy: usb: Fix clock imbalance for suspend/resume

Justin Chen <justinpopo6@gmail.com>
    phy: usb: Use slow clock for wake enabled suspend

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix TCP options overflow.

Geliang Tang <geliang.tang@suse.com>
    mptcp: drop port parameter of mptcp_pm_add_addr_signal

Dennis Lam <dennis.lamerice@gmail.com>
    ocfs2: fix slab-use-after-free due to dangling pointer dqi_priv

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: correct return value of ocfs2_local_free_info()

Justin Chen <justin.chen@broadcom.com>
    phy: usb: Toggle the PHY power during init

Al Cooper <alcooperx@gmail.com>
    phy: usb: Add "wake on" functionality for newer Synopsis XHCI controllers

Andrea della Porta <andrea.porta@suse.com>
    of: address: Preserve the flags portion on 1:1 dma-ranges mapping

Rob Herring <robh@kernel.org>
    of: address: Store number of bus flag cells rather than bool

Herve Codina <herve.codina@bootlin.com>
    of: address: Remove duplicated functions

Herve Codina <herve.codina@bootlin.com>
    of: address: Fix address translation when address-size is greater than 2

Rob Herring <robh@kernel.org>
    of/address: Add support for 3 address cell bus

Rob Herring <robh@kernel.org>
    of: unittest: Add bus address range parsing tests

Peter Geis <pgwipeout@gmail.com>
    arm64: dts: rockchip: add hevc power domain clock to rk3328

Yu Kuai <yukuai3@huawei.com>
    block, bfq: fix waker_bfqq UAF after bfq_split_bfqq()

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    iio: adc: ad7124: Disable all channels at probe time

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    iio: inkern: call iio_device_put() only on mapped devices

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    iio: adc: at91: call input_free_device() on allocated iio_dev

Fabio Estevam <festevam@gmail.com>
    iio: adc: ti-ads124s08: Use gpiod_set_value_cansleep()

Carlos Song <carlos.song@nxp.com>
    iio: gyro: fxas21002c: Fix missing data update in trigger handler

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: adc: ti-ads8688: fix information leak in triggered buffer

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: imu: kmx61: fix information leak in triggered buffer

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: light: vcnl4035: fix information leak in triggered buffer

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: dummy: iio_simply_dummy_buffer: fix information leak in triggered buffer

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: pressure: zpa2326: fix information leak in triggered buffer

Akash M <akash.m5@samsung.com>
    usb: gadget: f_fs: Remove WARN_ON in functionfs_bind

Prashanth K <quic_prashk@quicinc.com>
    usb: gadget: f_uac2: Fix incorrect setting of bNumEndpoints

Ma Ke <make_ruc2021@163.com>
    usb: fix reference leak in usb_new_device()

Kai-Heng Feng <kaihengf@nvidia.com>
    USB: core: Disable LPM only for non-suspended ports

Jun Yan <jerrysteve1101@gmail.com>
    USB: usblp: return error when setting unsupported protocol

Lianqin Hu <hulianqin@vivo.com>
    usb: gadget: u_serial: Disable ep before setting port to null to fix the crash caused by port being null

Li Huafei <lihuafei1@huawei.com>
    topology: Keep the cpumask unchanged when printing cpumap

André Draszik <andre.draszik@linaro.org>
    usb: dwc3: gadget: fix writing NYET threshold

Johan Hovold <johan@kernel.org>
    USB: serial: cp210x: add Phoenix Contact UPS Device

Lubomir Rintel <lrintel@redhat.com>
    usb-storage: Add max sectors quirk for Nokia 208

Zicheng Qu <quzicheng@huawei.com>
    staging: iio: ad9832: Correct phase range check

Zicheng Qu <quzicheng@huawei.com>
    staging: iio: ad9834: Correct phase range check

Michal Hrusecky <michal.hrusecky@turris.com>
    USB: serial: option: add Neoway N723-EA support

Chukun Pan <amadeus@jmu.edu.cn>
    USB: serial: option: add MeiG Smart SRM815

Gui-Dong Han <2045gemini@gmail.com>
    md/raid5: fix atomicity violation in raid5_cache_count

Kuan-Wei Chiu <visitorckw@gmail.com>
    scripts/sorttable: fix orc_sort_cmp() to maintain symmetry and transitivity

Kairui Song <kasong@tencent.com>
    zram: fix uninitialized ZRAM not releasing backing device

Dominique Martinet <dominique.martinet@atmark-techno.com>
    zram: check comp is non-NULL before calling comp_destroy

Sergey Senozhatsky <senozhatsky@chromium.org>
    drivers/block/zram/zram_drv.c: do not keep dangling zcomp pointer after zram reset

Melissa Wen <mwen@igalia.com>
    drm/amd/display: increase MAX_SURFACES to the value supported by hw

Hans de Goede <hdegoede@redhat.com>
    ACPI: resource: Add Asus Vivobook X1504VAP to irq1_level_low_skip_override[]

Hans de Goede <hdegoede@redhat.com>
    ACPI: resource: Add TongFang GM5HG0A to irq1_edge_low_force_override[]

Nam Cao <namcao@linutronix.de>
    riscv: Fix sleeping in invalid context in die()

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Add check for granularity in dml ceil/floor helpers

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    sctp: sysctl: plpmtud_probe_interval: avoid using current->nsproxy

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    sctp: sysctl: udp_port: avoid using current->nsproxy

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    sctp: sysctl: auth_enable: avoid using current->nsproxy

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    sctp: sysctl: rto_min/max: avoid using current->nsproxy

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    sctp: sysctl: cookie_hmac_alg: avoid using current->nsproxy

Mikulas Patocka <mpatocka@redhat.com>
    dm-ebs: don't set the flag DM_TARGET_PASSES_INTEGRITY

Krister Johansen <kjlx@templeofstupid.com>
    dm thin: make get_first_thin use rcu-safe list first function

David Howells <dhowells@redhat.com>
    afs: Fix the maximum cell name length

Wentao Liang <liangwentao@iscas.ac.cn>
    ksmbd: fix a missing return value check bug

Jason-JH.Lin <jason-jh.lin@mediatek.com>
    drm/mediatek: Add support for 180-degree rotation in the display driver

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: conntrack: clamp maximum hashtable size to INT_MAX

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: imbalance in flowtable binding

Benjamin Coddington <bcodding@redhat.com>
    tls: Fix tls_sw_sendmsg error handling

Anumula Murali Mohan Reddy <anumula@chelsio.com>
    cxgb4: Avoid removal of uninserted tid

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    bnxt_en: Fix possible memory leak when hwrm_req_replace fails

Eric Dumazet <edumazet@google.com>
    net_sched: cls_flow: validate TCA_FLOW_RSHIFT attribute

Zhongqiu Duan <dzq.aishenghu0@gmail.com>
    tcp/dccp: allow a connection when sk_max_ack_backlog is zero

Jason Xing <kernelxing@tencent.com>
    tcp/dccp: complete lockless accesses to sk->sk_max_ack_backlog

Antonio Pastor <antonio.pastor@gmail.com>
    net: 802: LLC+SNAP OID:PID lookup on start of skb data

Keisuke Nishimura <keisuke.nishimura@inria.fr>
    ieee802154: ca8210: Add missing check for kfifo_alloc() in ca8210_probe()

Chen-Yu Tsai <wenst@chromium.org>
    ASoC: mediatek: disable buffer pre-allocation

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix the infinite loop in __exfat_free_cluster()

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix the infinite loop in exfat_readdir()

Ming-Hung Tsai <mtsai@redhat.com>
    dm array: fix cursor index when skipping across block boundaries

Ming-Hung Tsai <mtsai@redhat.com>
    dm array: fix unreleased btree blocks on closing a faulty array cursor

Ming-Hung Tsai <mtsai@redhat.com>
    dm array: fix releasing a faulty array block twice in dm_array_cursor_end

Zhang Yi <yi.zhang@huawei.com>
    jbd2: flush filesystem device before updating tail sequence

Max Kellermann <max.kellermann@ionos.com>
    ceph: give up on paths longer than PATH_MAX


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |   1 +
 arch/riscv/kernel/traps.c                          |   6 +-
 arch/x86/include/asm/special_insns.h               |   2 +-
 arch/x86/xen/xen-asm.S                             |   2 +-
 block/bfq-iosched.c                                |  12 ++-
 drivers/acpi/resource.c                            |  24 ++++-
 drivers/base/regmap/regmap.c                       |  12 ---
 drivers/base/topology.c                            |  24 ++++-
 drivers/block/zram/zram_drv.c                      |  24 ++---
 drivers/gpio/gpiolib-cdev.c                        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  45 +--------
 drivers/gpu/drm/amd/display/dc/dc.h                |   2 +-
 .../gpu/drm/amd/display/dc/dml/dml_inline_defs.h   |   8 ++
 drivers/gpu/drm/i915/display/intel_fb.c            |   2 +-
 drivers/gpu/drm/mediatek/mtk_disp_ovl.c            |  12 ++-
 drivers/gpu/drm/v3d/v3d_irq.c                      |   4 +
 drivers/hwmon/tmp513.c                             |   7 +-
 drivers/i2c/busses/i2c-rcar.c                      |  20 +++-
 drivers/i2c/muxes/i2c-demux-pinctrl.c              |   4 +-
 drivers/iio/adc/ad7124.c                           |   3 +
 drivers/iio/adc/at91_adc.c                         |   2 +-
 drivers/iio/adc/rockchip_saradc.c                  |   2 +
 drivers/iio/adc/ti-ads124s08.c                     |   4 +-
 drivers/iio/adc/ti-ads8688.c                       |   2 +-
 drivers/iio/dummy/iio_simple_dummy_buffer.c        |   2 +-
 drivers/iio/gyro/fxas21002c_core.c                 |  11 ++-
 drivers/iio/imu/inv_icm42600/inv_icm42600.h        |   1 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c   |  18 +++-
 drivers/iio/imu/inv_icm42600/inv_icm42600_spi.c    |   3 +-
 drivers/iio/imu/kmx61.c                            |   2 +-
 drivers/iio/inkern.c                               |   2 +-
 drivers/iio/light/vcnl4035.c                       |   2 +-
 drivers/iio/pressure/zpa2326.c                     |   2 +
 drivers/irqchip/irq-gic-v3.c                       |   2 +-
 drivers/md/dm-ebs-target.c                         |   2 +-
 drivers/md/dm-thin.c                               |   5 +-
 drivers/md/persistent-data/dm-array.c              |  19 ++--
 drivers/md/raid5.c                                 |  14 +--
 drivers/mtd/spi-nor/core.c                         |   2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |  19 +---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c      |   3 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  95 ++++++++++++++----
 drivers/net/ethernet/netronome/nfp/bpf/offload.c   |   3 +-
 drivers/net/ethernet/ti/cpsw_ale.c                 |  14 +--
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   6 ++
 drivers/net/gtp.c                                  |  42 ++++----
 drivers/net/ieee802154/ca8210.c                    |   6 +-
 drivers/nvme/target/io-cmd-bdev.c                  |   2 +-
 drivers/of/address.c                               |  76 ++++++++++----
 drivers/of/unittest-data/tests-address.dtsi        |   9 +-
 drivers/of/unittest.c                              | 109 +++++++++++++++++++++
 drivers/pci/controller/pci-host-common.c           |   4 +
 drivers/pci/probe.c                                |  20 ++--
 drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c  |  53 ++++++++--
 drivers/phy/broadcom/phy-brcm-usb-init.h           |   1 -
 drivers/phy/broadcom/phy-brcm-usb.c                |   8 +-
 drivers/scsi/sg.c                                  |   2 +-
 drivers/staging/iio/frequency/ad9832.c             |   2 +-
 drivers/staging/iio/frequency/ad9834.c             |   2 +-
 drivers/usb/class/usblp.c                          |   7 +-
 drivers/usb/core/hub.c                             |   6 +-
 drivers/usb/core/port.c                            |   7 +-
 drivers/usb/dwc3/core.h                            |   1 +
 drivers/usb/dwc3/gadget.c                          |   4 +-
 drivers/usb/gadget/function/f_fs.c                 |   2 +-
 drivers/usb/gadget/function/f_uac2.c               |   1 +
 drivers/usb/gadget/function/u_serial.c             |   8 +-
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/option.c                        |   4 +-
 drivers/usb/storage/unusual_devs.h                 |   7 ++
 fs/afs/afs.h                                       |   2 +-
 fs/afs/afs_vl.h                                    |   1 +
 fs/afs/vl_alias.c                                  |   8 +-
 fs/afs/vlclient.c                                  |   2 +-
 fs/ceph/mds_client.c                               |   9 +-
 fs/exfat/dir.c                                     |   3 +-
 fs/exfat/fatent.c                                  |  10 ++
 fs/file.c                                          |   1 +
 fs/hfs/super.c                                     |   4 +-
 fs/jbd2/commit.c                                   |   4 +-
 fs/ksmbd/smb2pdu.c                                 |   3 +
 fs/nfsd/filecache.c                                |  18 ++--
 fs/nfsd/filecache.h                                |   1 +
 fs/ocfs2/quota_global.c                            |   2 +-
 fs/ocfs2/quota_local.c                             |  10 +-
 fs/proc/vmcore.c                                   |   2 +
 include/linux/blk-cgroup.h                         |   6 +-
 include/linux/hrtimer.h                            |   1 +
 include/linux/mlx5/device.h                        |   2 +
 include/linux/mlx5/fs.h                            |   2 +
 include/linux/poll.h                               |  10 +-
 include/net/inet_connection_sock.h                 |   2 +-
 include/net/net_namespace.h                        |   3 +
 kernel/cpu.c                                       |   2 +-
 kernel/gen_kheaders.sh                             |   1 +
 kernel/time/hrtimer.c                              |  11 ++-
 mm/filemap.c                                       |   2 +-
 net/802/psnap.c                                    |   4 +-
 net/core/filter.c                                  |  30 +++---
 net/core/net_namespace.c                           |  31 +++++-
 net/core/pktgen.c                                  |   6 +-
 net/dccp/ipv6.c                                    |   2 +-
 net/ipv6/route.c                                   |   2 +-
 net/ipv6/tcp_ipv6.c                                |   4 +-
 net/mac802154/iface.c                              |   4 +
 net/mptcp/options.c                                |  12 ++-
 net/mptcp/pm.c                                     |   7 +-
 net/mptcp/protocol.h                               |   2 +-
 net/netfilter/nf_conntrack_core.c                  |   5 +-
 net/netfilter/nf_tables_api.c                      |  15 ++-
 net/sched/cls_flow.c                               |   3 +-
 net/sctp/sysctl.c                                  |  14 +--
 net/tls/tls_sw.c                                   |   2 +-
 net/vmw_vsock/af_vsock.c                           |  18 ++++
 net/vmw_vsock/virtio_transport_common.c            |  38 ++++---
 scripts/sorttable.h                                |   6 +-
 .../soc/mediatek/common/mtk-afe-platform-driver.c  |   4 +-
 119 files changed, 830 insertions(+), 347 deletions(-)


