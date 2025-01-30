Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170181DDE9;
	Thu, 30 Jan 2025 14:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246642; cv=none; b=N94x0uzKNy46b6+ot9M12/LruIEFUOD4hMuxp0JZrVzTnvCdRSdNQCsK0zXdvsgZCxk1hJX7UbuFSqbIFDimCAwX1iBmjz54zVdOhDNqCwYgVIwYSfN9xEbHOYz2E5lh+uXx5tr2Zalkz8OqDa1m19zq2ZVJtKFJ+5pBfX/wZl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246642; c=relaxed/simple;
	bh=hNCANixllyG0kFspue4HHHinL2ojD31tR4AswisqPEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fAhZCbSnOks2m4WzM2aYPiG6ILFqWBrtTBJJIIGGUsxdQ7rRgDGupC2pqtuMxzgemXm1zIEgG9DXPzN9eIEMiKtT8RBlqGp0p59paqdgnR1gpYRjQ1U8ESPh20sgOClL/s/9YFyVTs8v4CCg5k8pf8HUfbELw1uBGGRkRYcubfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V06i3NQM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V06i3NQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C77EC4CED2;
	Thu, 30 Jan 2025 14:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246642;
	bh=hNCANixllyG0kFspue4HHHinL2ojD31tR4AswisqPEQ=;
	h=From:To:Cc:Subject:Date:From;
	b=V06i3NQMFFb1vG9HhZMNbt56MsZmkfF9uYLFNyP39JlRJONNJJocVtFzWBxdPjUL/
	 AU56F0e7OEGJGfj2ZMfjNeCIDAh/7RhA5JhaGcgStljV5o2KCn2lT6a+4EDM/Jn3JO
	 ErO/7iGMASVLB3VwT1fqATcaZau7aufAe5hbItE8=
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
Subject: [PATCH 5.4 00/91] 5.4.290-rc1 review
Date: Thu, 30 Jan 2025 15:00:19 +0100
Message-ID: <20250130140133.662535583@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.290-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.290-rc1
X-KernelTest-Deadline: 2025-02-01T14:01+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.4.290 release.
There are 91 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 01 Feb 2025 14:01:13 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.290-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.290-rc1

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

Baokun Li <libaokun1@huawei.com>
    ext4: fix slab-use-after-free in ext4_split_extent_at()

Theodore Ts'o <tytso@mit.edu>
    ext4: avoid ext4_error()'s caused by ENOMEM in the truncate path

Alex Williamson <alex.williamson@redhat.com>
    vfio/platform: check the bounds of read/write syscalls

Jeongjun Park <aha310510@gmail.com>
    net/xen-netback: prevent UAF in xenvif_flush_hash()

Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>
    net: xen-netback: hash.c: Use built-in RCU list checking

Eric W. Biederman <ebiederm@xmission.com>
    signal/m68k: Use force_sigsegv(SIGSEGV) in fpsp040_die

Liam Howlett <liam.howlett@oracle.com>
    m68k: Add missing mmap_read_lock() to sys_cacheflush()

Al Viro <viro@zeniv.linux.org.uk>
    m68k: Update ->thread.esp0 before calling syscall_trace() in ret_from_signal

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Truncate address space when flipping GFS2_DIF_JDATA flag

Philippe Simons <simons.philippe@gmail.com>
    irqchip/sunxi-nmi: Add missing SKIP_WAKE flag

Xiang Zhang <hawkxiang.cpp@gmail.com>
    scsi: iscsi: Fix redundant response for ISCSI_UEVENT_GET_HOST_STATS request

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm8994: Add depends on MFD core

Wang Liang <wangliang74@huawei.com>
    net: fix data-races around sk->sk_forward_alloc

Suraj Sonawane <surajsonawane0215@gmail.com>
    scsi: sg: Fix slab-use-after-free read in sg_release()

Eric Dumazet <edumazet@google.com>
    ipv6: avoid possible NULL deref in rt6_uncached_list_flush_dev()

Koichiro Den <koichiro.den@canonical.com>
    hrtimers: Handle CPU state correctly on hotplug

Yogesh Lal <quic_ylal@quicinc.com>
    irqchip/gic-v3: Handle CPU_PM_ENTER_FAILED correctly

Rik van Riel <riel@surriel.com>
    fs/proc: fix softlockup in __read_vmcore (part 2)

Heiner Kallweit <hkallweit1@gmail.com>
    net: ethernet: xgbe: re-add aneg to supported features in PHY quirks

Luis Chamberlain <mcgrof@kernel.org>
    nvmet: propagate npwg topology

Oleg Nesterov <oleg@redhat.com>
    poll_wait: add mb() to fix theoretical race between waitqueue_active() and .poll()

David Howells <dhowells@redhat.com>
    kheaders: Ignore silly-rename files

Leo Stone <leocstone@gmail.com>
    hfs: Sanity check the root record

Lizhi Xu <lizhi.xu@windriver.com>
    mac802154: check local interfaces before deleting sdata list

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: mux: demux-pinctrl: check initial mux selection, too

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Ensure job pointer is set to NULL after job completion

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

Sudheer Kumar Doredla <s-doredla@ti.com>
    net: ethernet: ti: cpsw_ale: Fix cpsw_ale_get_field()

Anup Patel <anup.patel@wdc.com>
    RISC-V: Don't enable all interrupts in trap_init()

Paul Walmsley <paul.walmsley@sifive.com>
    riscv: prefix IRQ_ macro names with an RV_ namespace

Nam Cao <namcao@linutronix.de>
    riscv: Fix sleeping in invalid context in die()

Mattias Nissler <mnissler@rivosinc.com>
    riscv: Avoid enabling interrupts in die()

Palmer Dabbelt <palmer@rivosinc.com>
    RISC-V: Avoid dereferening NULL regs in die()

Rouven Czerwinski <rouven@czerwinskis.de>
    riscv: remove unused handle_exception symbol

Christoph Hellwig <hch@lst.de>
    riscv: abstract out CSR names for supervisor vs machine mode

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    sctp: sysctl: rto_min/max: avoid using current->nsproxy

Dennis Lam <dennis.lamerice@gmail.com>
    ocfs2: fix slab-use-after-free due to dangling pointer dqi_priv

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: correct return value of ocfs2_local_free_info()

Zijun Hu <quic_zijuhu@quicinc.com>
    phy: core: Fix that API devm_of_phy_provider_unregister() fails to unregister the phy provider

Vinod Koul <vkoul@kernel.org>
    phy: core: fix code style in devm_of_phy_provider_unregister

Peter Geis <pgwipeout@gmail.com>
    arm64: dts: rockchip: add hevc power domain clock to rk3328

Johan Jonker <jbx6244@gmail.com>
    arm64: dts: rockchip: add #power-domain-cells to power domain nodes

Johan Jonker <jbx6244@gmail.com>
    arm64: dts: rockchip: fix pd_tcpc0 and pd_tcpc1 node position on rk3399

Johan Jonker <jbx6244@gmail.com>
    arm64: dts: rockchip: fix defines in pd_vio node for rk3399

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

Melissa Wen <mwen@igalia.com>
    drm/amd/display: increase MAX_SURFACES to the value supported by hw

Hans de Goede <hdegoede@redhat.com>
    ACPI: resource: Add Asus Vivobook X1504VAP to irq1_level_low_skip_override[]

Hans de Goede <hdegoede@redhat.com>
    ACPI: resource: Add TongFang GM5HG0A to irq1_edge_low_force_override[]

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Add check for granularity in dml ceil/floor helpers

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    sctp: sysctl: auth_enable: avoid using current->nsproxy

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    sctp: sysctl: cookie_hmac_alg: avoid using current->nsproxy

Krister Johansen <kjlx@templeofstupid.com>
    dm thin: make get_first_thin use rcu-safe list first function

Benjamin Coddington <bcodding@redhat.com>
    tls: Fix tls_sw_sendmsg error handling

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

Ming-Hung Tsai <mtsai@redhat.com>
    dm array: fix cursor index when skipping across block boundaries

Ming-Hung Tsai <mtsai@redhat.com>
    dm array: fix unreleased btree blocks on closing a faulty array cursor

Ming-Hung Tsai <mtsai@redhat.com>
    dm array: fix releasing a faulty array block twice in dm_array_cursor_end

Zhang Yi <yi.zhang@huawei.com>
    jbd2: flush filesystem device before updating tail sequence


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm64/boot/dts/rockchip/px30.dtsi             |  8 +++
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |  4 ++
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           | 40 ++++++++---
 arch/m68k/fpsp040/skeleton.S                       |  3 +-
 arch/m68k/kernel/entry.S                           |  2 +
 arch/m68k/kernel/sys_m68k.c                        |  2 +
 arch/m68k/kernel/traps.c                           |  2 +-
 arch/riscv/Kconfig                                 |  4 ++
 arch/riscv/include/asm/csr.h                       | 72 ++++++++++++++++---
 arch/riscv/include/asm/irqflags.h                  | 12 ++--
 arch/riscv/include/asm/processor.h                 |  2 +-
 arch/riscv/include/asm/ptrace.h                    | 16 ++---
 arch/riscv/include/asm/switch_to.h                 | 10 +--
 arch/riscv/kernel/asm-offsets.c                    |  8 +--
 arch/riscv/kernel/entry.S                          | 74 +++++++++++--------
 arch/riscv/kernel/fpu.S                            |  8 +--
 arch/riscv/kernel/head.S                           | 12 ++--
 arch/riscv/kernel/irq.c                            | 17 ++---
 arch/riscv/kernel/perf_callchain.c                 |  2 +-
 arch/riscv/kernel/process.c                        | 17 ++---
 arch/riscv/kernel/signal.c                         | 21 +++---
 arch/riscv/kernel/smp.c                            |  2 +-
 arch/riscv/kernel/traps.c                          | 34 ++++-----
 arch/riscv/lib/uaccess.S                           | 12 ++--
 arch/riscv/mm/extable.c                            |  4 +-
 arch/riscv/mm/fault.c                              |  6 +-
 drivers/acpi/resource.c                            | 18 +++++
 drivers/clocksource/timer-riscv.c                  |  8 +--
 drivers/gpu/drm/amd/display/dc/dc.h                |  2 +-
 .../gpu/drm/amd/display/dc/dml/dml_inline_defs.h   |  8 +++
 drivers/gpu/drm/v3d/v3d_irq.c                      |  4 ++
 drivers/i2c/muxes/i2c-demux-pinctrl.c              |  4 +-
 drivers/iio/adc/at91_adc.c                         |  2 +-
 drivers/iio/adc/ti-ads124s08.c                     |  4 +-
 drivers/iio/adc/ti-ads8688.c                       |  2 +-
 drivers/iio/dummy/iio_simple_dummy_buffer.c        |  2 +-
 drivers/iio/gyro/fxas21002c_core.c                 | 11 ++-
 drivers/iio/imu/kmx61.c                            |  2 +-
 drivers/iio/inkern.c                               |  2 +-
 drivers/iio/light/vcnl4035.c                       |  2 +-
 drivers/iio/pressure/zpa2326.c                     |  2 +
 drivers/input/joystick/xpad.c                      |  2 +
 drivers/input/keyboard/atkbd.c                     |  2 +-
 drivers/irqchip/irq-gic-v3.c                       |  2 +-
 drivers/irqchip/irq-sifive-plic.c                  | 11 +--
 drivers/irqchip/irq-sunxi-nmi.c                    |  3 +-
 drivers/md/dm-thin.c                               |  5 +-
 drivers/md/persistent-data/dm-array.c              | 19 +++--
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        | 19 +----
 drivers/net/ethernet/netronome/nfp/bpf/offload.c   |  3 +-
 drivers/net/ethernet/ti/cpsw_ale.c                 | 14 ++--
 drivers/net/gtp.c                                  | 42 ++++++-----
 drivers/net/ieee802154/ca8210.c                    |  6 +-
 drivers/net/xen-netback/hash.c                     |  7 +-
 drivers/nvme/target/io-cmd-bdev.c                  |  2 +-
 drivers/phy/phy-core.c                             |  7 +-
 drivers/scsi/scsi_transport_iscsi.c                |  4 +-
 drivers/scsi/sg.c                                  |  2 +-
 drivers/staging/iio/frequency/ad9832.c             |  2 +-
 drivers/staging/iio/frequency/ad9834.c             |  2 +-
 drivers/usb/class/usblp.c                          |  7 +-
 drivers/usb/core/hub.c                             |  6 +-
 drivers/usb/core/port.c                            |  7 +-
 drivers/usb/gadget/function/f_fs.c                 |  2 +-
 drivers/usb/serial/cp210x.c                        |  1 +
 drivers/usb/serial/option.c                        |  4 +-
 drivers/usb/serial/quatech2.c                      |  2 +-
 drivers/usb/storage/unusual_devs.h                 |  7 ++
 drivers/vfio/platform/vfio_platform_common.c       | 10 +++
 fs/ext4/ext4.h                                     |  1 +
 fs/ext4/extents.c                                  | 64 ++++++++++++++---
 fs/gfs2/file.c                                     |  1 +
 fs/hfs/super.c                                     |  4 +-
 fs/jbd2/commit.c                                   |  4 +-
 fs/ocfs2/quota_global.c                            |  2 +-
 fs/ocfs2/quota_local.c                             | 10 ++-
 fs/proc/vmcore.c                                   |  2 +
 include/linux/hrtimer.h                            |  1 +
 include/linux/poll.h                               | 10 ++-
 include/net/inet_connection_sock.h                 |  2 +-
 include/net/net_namespace.h                        |  3 +
 kernel/cpu.c                                       |  2 +-
 kernel/gen_kheaders.sh                             |  1 +
 kernel/time/hrtimer.c                              | 11 ++-
 net/802/psnap.c                                    |  4 +-
 net/core/net_namespace.c                           | 83 ++++++++++++++--------
 net/dccp/ipv6.c                                    |  2 +-
 net/ipv6/route.c                                   |  2 +-
 net/ipv6/tcp_ipv6.c                                |  4 +-
 net/mac802154/iface.c                              |  4 ++
 net/sched/cls_flow.c                               |  3 +-
 net/sctp/sysctl.c                                  |  9 +--
 net/tls/tls_sw.c                                   |  2 +-
 sound/soc/codecs/Kconfig                           |  1 +
 95 files changed, 589 insertions(+), 314 deletions(-)


