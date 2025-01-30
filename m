Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E1A1BDA95;
	Thu, 30 Jan 2025 14:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246966; cv=none; b=pqxZf2GPO3/hTbiGT8EyqTbqxvXpMfDmd52lI9VovfF92X7NNDXN5yZU2Xx5f2cVs+24VbwWrTuYVHXKdop48puLEKU7tVjT41VrcobzJdPi8lAkJopXNW9zQlSa+PwGbcb3JWBYTlg+G/KZxl5dCjiUNr6vmCWVLqKrDXNQlEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246966; c=relaxed/simple;
	bh=9bKRSAIuRhPwlpJ9GhzpUrPevVdNTTxnG+NUGNLiIZs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rckXUJyivVOhzsRhaGddWP5w7bMOs+A18JR5oD3UF4/P8rYm+DXeE1lV9ItEGhqVKxwiPlDE5sRWg3iVBdU4TxtbYEaPGjX7j7RR1QkMG59wiFIeLSahqyYm0E5iRrNey15KNw6RO6XiKpca4Zz5cCDPFtOgJ1ZnvZ3lTGJHNhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fj34Npdn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fj34Npdn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8553C4CED2;
	Thu, 30 Jan 2025 14:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246966;
	bh=9bKRSAIuRhPwlpJ9GhzpUrPevVdNTTxnG+NUGNLiIZs=;
	h=From:To:Cc:Subject:Date:From;
	b=fj34NpdnWCPMTQNP1MoWP60HrpSoN8JzbZbEpoUYarQ+QNcmTPy6i0KO/j3uE7OY6
	 0vDL5qsl4hhhkGCoiM7Q3wsvJ04fASpjf+T3sC8rE8XhHUlavp8Z/mZZ5EObyA2TsG
	 ZZc/GtNO4RAj77XuSXEmTyRzoeiRA7EpbCXscB9k=
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
Subject: [PATCH 5.10 000/133] 5.10.234-rc1 review
Date: Thu, 30 Jan 2025 14:59:49 +0100
Message-ID: <20250130140142.491490528@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.234-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.234-rc1
X-KernelTest-Deadline: 2025-02-01T14:01+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.234 release.
There are 133 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 01 Feb 2025 14:01:14 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.234-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.234-rc1

Jack Greiner <jack@emoss.org>
    Input: xpad - add support for wooting two he (arm)

Nilton Perim Neto <niltonperimneto@gmail.com>
    Input: xpad - add unofficial Xbox 360 wireless receiver clone

Mark Pearson <mpearson-lenovo@squebb.ca>
    Input: atkbd - map F23 key to support default copilot shortcut

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "usb: gadget: u_serial: Disable ep before setting port to null to fix the crash caused by port being null"

Qasim Ijaz <qasdev00@gmail.com>
    USB: serial: quatech2: fix null-ptr-deref in qt2_process_read_urb()

Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
    wifi: iwlwifi: add a few rate index validity checks

Ido Schimmel <idosch@nvidia.com>
    ipv4: ip_tunnel: Fix suspicious RCU usage warning in ip_tunnel_find()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: RFCOMM: Fix not validating setsockopt user input

Alex Williamson <alex.williamson@redhat.com>
    vfio/platform: check the bounds of read/write syscalls

Eric W. Biederman <ebiederm@xmission.com>
    signal/m68k: Use force_sigsegv(SIGSEGV) in fpsp040_die

Al Viro <viro@zeniv.linux.org.uk>
    m68k: Update ->thread.esp0 before calling syscall_trace() in ret_from_signal

Jamal Hadi Salim <jhs@mojatatu.com>
    net: sched: fix ets qdisc OOB Indexing

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Truncate address space when flipping GFS2_DIF_JDATA flag

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: samsung: Add missing depends on I2C

Philippe Simons <simons.philippe@gmail.com>
    irqchip/sunxi-nmi: Add missing SKIP_WAKE flag

Xiang Zhang <hawkxiang.cpp@gmail.com>
    scsi: iscsi: Fix redundant response for ISCSI_UEVENT_GET_HOST_STATS request

Linus Walleij <linus.walleij@linaro.org>
    seccomp: Stub for !CONFIG_SECCOMP

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: samsung: Add missing selects for MFD_WM8994

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm8994: Add depends on MFD core

Wang Liang <wangliang74@huawei.com>
    net: fix data-races around sk->sk_forward_alloc

Suraj Sonawane <surajsonawane0215@gmail.com>
    scsi: sg: Fix slab-use-after-free read in sg_release()

Juergen Gross <jgross@suse.com>
    x86/xen: fix SLS mitigation in xen_hypercall_iret()

Stefano Garzarella <sgarzare@redhat.com>
    vsock: prevent null-ptr-deref in vsock_*[has_data|has_space]

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: discard packets if the transport changes

Willem de Bruijn <willemb@google.com>
    fou: remove warn in gue_gro_receive on unsupported protocol

Youzhong Yang <youzhong@gmail.com>
    nfsd: add list_head nf_gc to struct nfsd_file

Eric Dumazet <edumazet@google.com>
    ipv6: avoid possible NULL deref in rt6_uncached_list_flush_dev()

Tejun Heo <tj@kernel.org>
    blk-cgroup: Fix UAF in blkcg_unpin_online()

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix deadlock on SRQ async events.

Matthew Wilcox (Oracle) <willy@infradead.org>
    vmalloc: fix accounting with i915

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/radeon: check bo_va->bo is non-NULL before using it

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: adc: rockchip_saradc: fix information leak in triggered buffer

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: fix timestamps after suspend if sensor is on

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: fix spi burst write not supported

Terry Tritton <terry.tritton@linaro.org>
    Revert "PCI: Use preserve_config in place of pci_flags"

Koichiro Den <koichiro.den@canonical.com>
    hrtimers: Handle CPU state correctly on hotplug

Yogesh Lal <quic_ylal@quicinc.com>
    irqchip/gic-v3: Handle CPU_PM_ENTER_FAILED correctly

Zhongqiu Han <quic_zhonhan@quicinc.com>
    gpiolib: cdev: Fix use after free in lineinfo_changed_notify

Rik van Riel <riel@surriel.com>
    fs/proc: fix softlockup in __read_vmcore (part 2)

Stefano Garzarella <sgarzare@redhat.com>
    vsock: reset socket state when de-assigning the transport

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: cancel close work in the destructor

Heiner Kallweit <hkallweit1@gmail.com>
    net: ethernet: xgbe: re-add aneg to supported features in PHY quirks

Juergen Gross <jgross@suse.com>
    x86/asm: Make serialize() always_inline

Luis Chamberlain <mcgrof@kernel.org>
    nvmet: propagate npwg topology

Oleg Nesterov <oleg@redhat.com>
    poll_wait: add mb() to fix theoretical race between waitqueue_active() and .poll()

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

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Ensure job pointer is set to NULL after job completion

Patrisious Haddad <phaddad@nvidia.com>
    net/mlx5: Fix RDMA TX steering prio

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: Refactor mlx5_get_flow_namespace

Aharon Landau <aharonl@nvidia.com>
    net/mlx5: Add priorities for counters in RDMA namespaces

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

Yajun Deng <yajun.deng@linux.dev>
    net: net_namespace: Optimize the code

Michal Luczaj <mhal@rbox.co>
    bpf: Fix bpf_sk_select_reuseport() memory leak

Sudheer Kumar Doredla <s-doredla@ti.com>
    net: ethernet: ti: cpsw_ale: Fix cpsw_ale_get_field()

Justin Chen <justinpopo6@gmail.com>
    phy: usb: Fix clock imbalance for suspend/resume

Justin Chen <justinpopo6@gmail.com>
    phy: usb: Use slow clock for wake enabled suspend

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    sctp: sysctl: rto_min/max: avoid using current->nsproxy

Biju Das <biju.das.jz@bp.renesas.com>
    drm: adv7511: Fix use-after-free in adv7533_attach_dsi()

Ahmad Fatoum <a.fatoum@pengutronix.de>
    drm: bridge: adv7511: use dev_err_probe in probe function

Alvin Šipraga <alsi@bang-olufsen.dk>
    drm: bridge: adv7511: unregister cec i2c device after cec adapter

Maxime Ripard <maxime@cerno.tech>
    drm/bridge: adv7533: Switch to devm MIPI-DSI helpers

Maxime Ripard <maxime@cerno.tech>
    drm/mipi-dsi: Create devm device attachment

Maxime Ripard <maxime@cerno.tech>
    drm/mipi-dsi: Create devm device registration

Xu Wang <vulab@iscas.ac.cn>
    drm: bridge: adv7511: Remove redundant null check before clk_disable_unprepare

Dennis Lam <dennis.lamerice@gmail.com>
    ocfs2: fix slab-use-after-free due to dangling pointer dqi_priv

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: correct return value of ocfs2_local_free_info()

Justin Chen <justin.chen@broadcom.com>
    phy: usb: Toggle the PHY power during init

Al Cooper <alcooperx@gmail.com>
    phy: usb: Add "wake on" functionality for newer Synopsis XHCI controllers

Christoph Hellwig <hch@lst.de>
    block: remove the update_bdev parameter to set_capacity_revalidate_and_notify

Christoph Hellwig <hch@lst.de>
    sd: update the bdev size in sd_revalidate_disk

Christoph Hellwig <hch@lst.de>
    nvme: let set_capacity_revalidate_and_notify update the bdev size

Christoph Hellwig <hch@lst.de>
    loop: let set_capacity_revalidate_and_notify update the bdev size

Peter Geis <pgwipeout@gmail.com>
    arm64: dts: rockchip: add hevc power domain clock to rk3328

Johan Jonker <jbx6244@gmail.com>
    arm64: dts: rockchip: add #power-domain-cells to power domain nodes

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

Ma Ke <make_ruc2021@163.com>
    usb: fix reference leak in usb_new_device()

Kai-Heng Feng <kaihengf@nvidia.com>
    USB: core: Disable LPM only for non-suspended ports

Jun Yan <jerrysteve1101@gmail.com>
    USB: usblp: return error when setting unsupported protocol

Lianqin Hu <hulianqin@vivo.com>
    usb: gadget: u_serial: Disable ep before setting port to null to fix the crash caused by port being null

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
    sctp: sysctl: auth_enable: avoid using current->nsproxy

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    sctp: sysctl: cookie_hmac_alg: avoid using current->nsproxy

Mikulas Patocka <mpatocka@redhat.com>
    dm-ebs: don't set the flag DM_TARGET_PASSES_INTEGRITY

Krister Johansen <kjlx@templeofstupid.com>
    dm thin: make get_first_thin use rcu-safe list first function

David Howells <dhowells@redhat.com>
    afs: Fix the maximum cell name length

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: conntrack: clamp maximum hashtable size to INT_MAX

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: imbalance in flowtable binding

Benjamin Coddington <bcodding@redhat.com>
    tls: Fix tls_sw_sendmsg error handling

Anumula Murali Mohan Reddy <anumula@chelsio.com>
    cxgb4: Avoid removal of uninserted tid

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

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_dynset: honor stateful expressions in set definition

Chen-Yu Tsai <wenst@chromium.org>
    ASoC: mediatek: disable buffer pre-allocation

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

 Makefile                                           |  4 +-
 arch/arm64/boot/dts/rockchip/px30.dtsi             |  8 ++
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |  4 +
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           | 20 +++++
 arch/m68k/fpsp040/skeleton.S                       |  3 +-
 arch/m68k/kernel/entry.S                           |  2 +
 arch/m68k/kernel/traps.c                           |  2 +-
 arch/riscv/kernel/traps.c                          |  6 +-
 arch/x86/include/asm/special_insns.h               |  2 +-
 arch/x86/xen/xen-asm.S                             |  2 +-
 block/genhd.c                                      | 13 ++-
 drivers/acpi/resource.c                            | 18 ++++
 drivers/block/loop.c                               |  8 +-
 drivers/block/virtio_blk.c                         |  2 +-
 drivers/block/xen-blkfront.c                       |  2 +-
 drivers/gpio/gpiolib-cdev.c                        |  2 +-
 drivers/gpu/drm/amd/display/dc/dc.h                |  2 +-
 .../gpu/drm/amd/display/dc/dml/dml_inline_defs.h   |  8 ++
 drivers/gpu/drm/bridge/adv7511/adv7511.h           |  1 -
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       | 17 ++--
 drivers/gpu/drm/bridge/adv7511/adv7533.c           | 38 +++------
 drivers/gpu/drm/drm_mipi_dsi.c                     | 81 ++++++++++++++++++
 drivers/gpu/drm/radeon/radeon_gem.c                |  2 +-
 drivers/gpu/drm/v3d/v3d_irq.c                      |  4 +
 drivers/i2c/busses/i2c-rcar.c                      | 20 +++--
 drivers/i2c/muxes/i2c-demux-pinctrl.c              |  4 +-
 drivers/iio/adc/at91_adc.c                         |  2 +-
 drivers/iio/adc/rockchip_saradc.c                  |  2 +
 drivers/iio/adc/ti-ads124s08.c                     |  4 +-
 drivers/iio/adc/ti-ads8688.c                       |  2 +-
 drivers/iio/dummy/iio_simple_dummy_buffer.c        |  2 +-
 drivers/iio/gyro/fxas21002c_core.c                 | 11 ++-
 drivers/iio/imu/inv_icm42600/inv_icm42600.h        |  1 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c   | 18 +++-
 drivers/iio/imu/inv_icm42600/inv_icm42600_spi.c    |  3 +-
 drivers/iio/imu/kmx61.c                            |  2 +-
 drivers/iio/inkern.c                               |  2 +-
 drivers/iio/light/vcnl4035.c                       |  2 +-
 drivers/iio/pressure/zpa2326.c                     |  2 +
 drivers/infiniband/hw/hns/hns_roce_main.c          |  1 +
 drivers/infiniband/hw/hns/hns_roce_srq.c           |  6 +-
 drivers/input/joystick/xpad.c                      |  2 +
 drivers/input/keyboard/atkbd.c                     |  2 +-
 drivers/irqchip/irq-gic-v3.c                       |  2 +-
 drivers/irqchip/irq-sunxi-nmi.c                    |  3 +-
 drivers/md/dm-ebs-target.c                         |  2 +-
 drivers/md/dm-thin.c                               |  5 +-
 drivers/md/persistent-data/dm-array.c              | 19 +++--
 drivers/md/raid5.c                                 | 14 ++--
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        | 19 +----
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  5 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  | 95 ++++++++++++++++++----
 drivers/net/ethernet/netronome/nfp/bpf/offload.c   |  3 +-
 drivers/net/ethernet/ti/cpsw_ale.c                 | 14 ++--
 drivers/net/gtp.c                                  | 42 ++++++----
 drivers/net/ieee802154/ca8210.c                    |  6 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |  7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |  9 +-
 drivers/nvme/host/core.c                           |  5 +-
 drivers/nvme/target/io-cmd-bdev.c                  |  2 +-
 drivers/pci/controller/pci-host-common.c           |  4 +
 drivers/pci/probe.c                                | 20 +++--
 drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c  | 53 +++++++++---
 drivers/phy/broadcom/phy-brcm-usb-init.h           |  1 -
 drivers/phy/broadcom/phy-brcm-usb.c                |  8 +-
 drivers/scsi/scsi_transport_iscsi.c                |  4 +-
 drivers/scsi/sd.c                                  |  9 +-
 drivers/scsi/sg.c                                  |  2 +-
 drivers/staging/iio/frequency/ad9832.c             |  2 +-
 drivers/staging/iio/frequency/ad9834.c             |  2 +-
 drivers/usb/class/usblp.c                          |  7 +-
 drivers/usb/core/hub.c                             |  6 +-
 drivers/usb/core/port.c                            |  7 +-
 drivers/usb/dwc3/core.h                            |  1 +
 drivers/usb/dwc3/gadget.c                          |  4 +-
 drivers/usb/gadget/function/f_fs.c                 |  2 +-
 drivers/usb/serial/cp210x.c                        |  1 +
 drivers/usb/serial/option.c                        |  4 +-
 drivers/usb/serial/quatech2.c                      |  2 +-
 drivers/usb/storage/unusual_devs.h                 |  7 ++
 drivers/vfio/platform/vfio_platform_common.c       | 10 +++
 fs/afs/afs.h                                       |  2 +-
 fs/afs/afs_vl.h                                    |  1 +
 fs/afs/vl_alias.c                                  |  8 +-
 fs/afs/vlclient.c                                  |  2 +-
 fs/ceph/mds_client.c                               |  9 +-
 fs/exfat/dir.c                                     |  3 +-
 fs/file.c                                          |  1 +
 fs/gfs2/file.c                                     |  1 +
 fs/hfs/super.c                                     |  4 +-
 fs/jbd2/commit.c                                   |  4 +-
 fs/nfsd/filecache.c                                | 18 ++--
 fs/nfsd/filecache.h                                |  1 +
 fs/ocfs2/quota_global.c                            |  2 +-
 fs/ocfs2/quota_local.c                             | 10 +--
 fs/proc/vmcore.c                                   |  2 +
 include/drm/drm_mipi_dsi.h                         |  4 +
 include/linux/blk-cgroup.h                         |  6 +-
 include/linux/genhd.h                              |  3 +-
 include/linux/hrtimer.h                            |  1 +
 include/linux/mlx5/device.h                        |  2 +
 include/linux/mlx5/fs.h                            |  2 +
 include/linux/poll.h                               | 10 ++-
 include/linux/seccomp.h                            |  2 +-
 include/net/inet_connection_sock.h                 |  2 +-
 include/net/net_namespace.h                        |  3 +
 include/net/netfilter/nf_tables.h                  |  2 +
 kernel/cpu.c                                       |  2 +-
 kernel/gen_kheaders.sh                             |  1 +
 kernel/time/hrtimer.c                              | 11 ++-
 mm/vmalloc.c                                       |  3 +-
 net/802/psnap.c                                    |  4 +-
 net/bluetooth/rfcomm/sock.c                        | 14 ++--
 net/core/filter.c                                  | 30 ++++---
 net/core/net_namespace.c                           | 83 ++++++++++++-------
 net/dccp/ipv6.c                                    |  2 +-
 net/ipv4/fou.c                                     |  2 +-
 net/ipv4/ip_tunnel.c                               |  2 +-
 net/ipv6/route.c                                   |  2 +-
 net/ipv6/tcp_ipv6.c                                |  4 +-
 net/mac802154/iface.c                              |  4 +
 net/netfilter/nf_conntrack_core.c                  |  5 +-
 net/netfilter/nf_tables_api.c                      | 38 ++++++++-
 net/netfilter/nft_dynset.c                         |  7 +-
 net/sched/cls_flow.c                               |  3 +-
 net/sched/sch_ets.c                                |  2 +
 net/sctp/sysctl.c                                  |  9 +-
 net/tls/tls_sw.c                                   |  2 +-
 net/vmw_vsock/af_vsock.c                           | 15 ++++
 net/vmw_vsock/virtio_transport_common.c            | 38 ++++++---
 scripts/sorttable.h                                | 10 ++-
 sound/soc/codecs/Kconfig                           |  1 +
 .../soc/mediatek/common/mtk-afe-platform-driver.c  |  4 +-
 sound/soc/samsung/Kconfig                          |  6 +-
 134 files changed, 806 insertions(+), 350 deletions(-)


