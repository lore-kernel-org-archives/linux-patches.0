Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA341E7C18;
	Wed, 15 Jan 2025 10:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937606; cv=none; b=OCPbYmOikXDm4BTlknUN9AcAlXCzuCc7SbbfMc13GkthRV7LO/+Eca8tMqny5cKk+4nr5+1MoUGOPKmjQwyguubwiPVXHFL2Xt6kMk4jD3xNKMsNR/iYnMx9XD8Mig7Lb+vSpJna2EBHUptICrhxM2v2vWtHyCypGh8o9GpkZ4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937606; c=relaxed/simple;
	bh=2K9EED5pjn7/lZc4SZik+TCjQkiaoKZRf166p6tefVE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DVqddVTlFwS0h3+8xeu7PbUorA759WAYSo3smIenlTIJwDSS91vmushTsZ52XwbW6lhKvRB6dUJc0vPclg8MWkerczaxGpTwncTRcyL4pIlAQhe2IoE0RP8ZmPuW6T/ozIFD6+lATj1aXlZ5tBsOZoa7IN1Pr6nOmLysQ/PZ4fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAD/xPsl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAD/xPsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92AC4C4CEE1;
	Wed, 15 Jan 2025 10:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937606;
	bh=2K9EED5pjn7/lZc4SZik+TCjQkiaoKZRf166p6tefVE=;
	h=From:To:Cc:Subject:Date:From;
	b=fAD/xPslOQtMbQNKo43s/4v1PAz86FplTy51oUz7atjNg0PlBdhAxQJs2KspIeeLZ
	 KgVsEkIPK0pMyXCrtA+e2FSWk8Zo7XFSAYKKSkXvbmlnPRK2/SgliqcN19pDdfChmG
	 T3SE4ppiEgUuk4oFiWajJDM/eQjm2P5dljxTzzXU=
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
Subject: [PATCH 6.1 00/92] 6.1.125-rc1 review
Date: Wed, 15 Jan 2025 11:36:18 +0100
Message-ID: <20250115103547.522503305@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.125-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.125-rc1
X-KernelTest-Deadline: 2025-01-17T10:35+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.125 release.
There are 92 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 17 Jan 2025 10:34:58 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.125-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.125-rc1

Biju Das <biju.das.jz@bp.renesas.com>
    drm: adv7511: Fix use-after-free in adv7533_attach_dsi()

Ahmad Fatoum <a.fatoum@pengutronix.de>
    drm: bridge: adv7511: use dev_err_probe in probe function

Dennis Lam <dennis.lamerice@gmail.com>
    ocfs2: fix slab-use-after-free due to dangling pointer dqi_priv

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: correct return value of ocfs2_local_free_info()

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

Jesse Taube <Mr.Bossman075@gmail.com>
    ARM: dts: imxrt1050: Fix clocks for mmc

Jens Axboe <axboe@kernel.dk>
    io_uring/eventfd: ensure io_eventfd_signal() defers another RCU period

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

Prashanth K <quic_prashk@quicinc.com>
    usb: dwc3-am62: Disable autosuspend during remove

Lianqin Hu <hulianqin@vivo.com>
    usb: gadget: u_serial: Disable ep before setting port to null to fix the crash caused by port being null

Rengarajan S <rengarajan.s@microchip.com>
    misc: microchip: pci1xxxx: Resolve return code mismatch during GPIO set config

Rengarajan S <rengarajan.s@microchip.com>
    misc: microchip: pci1xxxx: Resolve kernel panic during GPIO IRQ handling

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

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix overloading of MEM_UNINIT's meaning

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Add MEM_WRITE attribute

Milan Broz <gmazyland@gmail.com>
    dm-verity FEC: Fix RS FEC repair for roots unaligned to block size (take 2)

Melissa Wen <mwen@igalia.com>
    drm/amd/display: increase MAX_SURFACES to the value supported by hw

Hans de Goede <hdegoede@redhat.com>
    ACPI: resource: Add Asus Vivobook X1504VAP to irq1_level_low_skip_override[]

Hans de Goede <hdegoede@redhat.com>
    ACPI: resource: Add TongFang GM5HG0A to irq1_edge_low_force_override[]

Nam Cao <namcao@linutronix.de>
    riscv: Fix sleeping in invalid context in die()

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    thermal: of: fix OF node leak in of_thermal_zone_find()

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

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    cpuidle: riscv-sbi: fix device node release in early exit of for_each_possible_cpu

He Wang <xw897002528@gmail.com>
    ksmbd: fix unexpectedly changed path in ksmbd_vfs_kern_path_locked

David Howells <dhowells@redhat.com>
    afs: Fix the maximum cell name length

Wentao Liang <liangwentao@iscas.ac.cn>
    ksmbd: fix a missing return value check bug

Liankun Yang <liankun.yang@mediatek.com>
    drm/mediatek: Add return value check when reading DPCD

Liankun Yang <liankun.yang@mediatek.com>
    drm/mediatek: Fix mode valid issue for dp

Liankun Yang <liankun.yang@mediatek.com>
    drm/mediatek: Fix YCbCr422 color format issue for DP

Arnd Bergmann <arnd@arndb.de>
    drm/mediatek: stop selecting foreign drivers

Chenguang Zhao <zhaochenguang@kylinos.cn>
    net/mlx5: Fix variable not being completed when function returns

Toke Høiland-Jørgensen <toke@redhat.com>
    sched: sch_cake: add bounds checks to host bulk flow fairness counts

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: conntrack: clamp maximum hashtable size to INT_MAX

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: imbalance in flowtable binding

Daniel Borkmann <daniel@iogearbox.net>
    tcp: Annotate data-race around sk->sk_mark in tcp_v4_send_reset

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix not setting Random Address when required

Benjamin Coddington <bcodding@redhat.com>
    tls: Fix tls_sw_sendmsg error handling

Przemyslaw Korba <przemyslaw.korba@intel.com>
    ice: fix incorrect PHY settings for 100 GB/s

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

Kuan-Wei Chiu <visitorckw@gmail.com>
    scripts/sorttable: fix orc_sort_cmp() to maintain symmetry and transitivity

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

Zhang Yi <yi.zhang@huawei.com>
    jbd2: increase IO priority for writing revoke records

Qun-Wei Lin <qun-wei.lin@mediatek.com>
    sched/task_stack: fix object_is_on_stack() for KASAN tagged pointers

Michal Luczaj <mhal@rbox.co>
    bpf, sockmap: Fix race between element replace and close()

Max Kellermann <max.kellermann@ionos.com>
    ceph: give up on paths longer than PATH_MAX


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/imxrt1050.dtsi                   |   2 +-
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |   1 +
 arch/riscv/kernel/traps.c                          |   6 +-
 block/bfq-iosched.c                                |  12 +-
 drivers/acpi/resource.c                            |  18 +++
 drivers/base/topology.c                            |  24 +++-
 drivers/cpuidle/cpuidle-riscv-sbi.c                |   4 +-
 drivers/gpu/drm/amd/display/dc/dc.h                |   2 +-
 .../gpu/drm/amd/display/dc/dml/dml_inline_defs.h   |   8 ++
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       |   8 +-
 drivers/gpu/drm/bridge/adv7511/adv7533.c           |  22 ++--
 drivers/gpu/drm/mediatek/Kconfig                   |   5 -
 drivers/gpu/drm/mediatek/mtk_dp.c                  |  46 ++++---
 drivers/iio/adc/ad7124.c                           |   3 +
 drivers/iio/adc/at91_adc.c                         |   2 +-
 drivers/iio/adc/ti-ads124s08.c                     |   4 +-
 drivers/iio/adc/ti-ads8688.c                       |   2 +-
 drivers/iio/dummy/iio_simple_dummy_buffer.c        |   2 +-
 drivers/iio/gyro/fxas21002c_core.c                 |  11 +-
 drivers/iio/imu/kmx61.c                            |   2 +-
 drivers/iio/inkern.c                               |   2 +-
 drivers/iio/light/vcnl4035.c                       |   2 +-
 drivers/iio/pressure/zpa2326.c                     |   2 +
 drivers/md/dm-ebs-target.c                         |   2 +-
 drivers/md/dm-thin.c                               |   5 +-
 drivers/md/dm-verity-fec.c                         |  39 ++++--
 drivers/md/persistent-data/dm-array.c              |  19 +--
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c    |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c      |   3 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   5 +-
 drivers/net/ethernet/intel/ice/ice_ptp_consts.h    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   1 +
 drivers/net/ieee802154/ca8210.c                    |   6 +-
 drivers/of/address.c                               |  76 ++++++++---
 drivers/of/unittest-data/tests-address.dtsi        |   9 +-
 drivers/of/unittest.c                              | 109 ++++++++++++++++
 drivers/staging/iio/frequency/ad9832.c             |   2 +-
 drivers/staging/iio/frequency/ad9834.c             |   2 +-
 drivers/thermal/thermal_of.c                       |   1 +
 drivers/usb/class/usblp.c                          |   7 +-
 drivers/usb/core/hub.c                             |   6 +-
 drivers/usb/core/port.c                            |   7 +-
 drivers/usb/dwc3/core.h                            |   1 +
 drivers/usb/dwc3/dwc3-am62.c                       |   1 +
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
 fs/jbd2/commit.c                                   |   4 +-
 fs/jbd2/revoke.c                                   |   2 +-
 fs/ocfs2/quota_global.c                            |   2 +-
 fs/ocfs2/quota_local.c                             |  10 +-
 fs/smb/server/smb2pdu.c                            |   3 +
 fs/smb/server/vfs.c                                |   3 +-
 include/linux/bpf.h                                |  14 ++-
 include/linux/sched/task_stack.h                   |   2 +
 include/net/inet_connection_sock.h                 |   2 +-
 io_uring/io_uring.c                                |  13 +-
 kernel/bpf/helpers.c                               |  10 +-
 kernel/bpf/ringbuf.c                               |   2 +-
 kernel/bpf/syscall.c                               |   2 +-
 kernel/bpf/verifier.c                              |  76 ++++++-----
 kernel/trace/bpf_trace.c                           |   4 +-
 net/802/psnap.c                                    |   4 +-
 net/bluetooth/hci_sync.c                           |  11 +-
 net/core/filter.c                                  |   4 +-
 net/core/sock_map.c                                |   6 +-
 net/ipv4/tcp_ipv4.c                                |   2 +-
 net/netfilter/nf_conntrack_core.c                  |   5 +-
 net/netfilter/nf_tables_api.c                      |  15 ++-
 net/sched/cls_flow.c                               |   3 +-
 net/sched/sch_cake.c                               | 140 +++++++++++----------
 net/sctp/sysctl.c                                  |  14 ++-
 net/tls/tls_sw.c                                   |   2 +-
 scripts/sorttable.h                                |   6 +-
 .../soc/mediatek/common/mtk-afe-platform-driver.c  |   4 +-
 87 files changed, 624 insertions(+), 306 deletions(-)


