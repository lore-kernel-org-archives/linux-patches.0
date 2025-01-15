Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5556B1DB13A;
	Wed, 15 Jan 2025 10:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938520; cv=none; b=eTabf8CfIT8+eTEIbwD1JqVDxvj+pR3ZFfvW1fY0nZLT9MQggKBK+3cCVgxUsMjZrX7lNaRpqKh2JN9IyuGzsA2QBzNb0mINPpco9oos785ofGvOP4Bc+jypY+WHGD4i8v/CofW4smaG6CPnLObA0KHElDfrSfqLxqFJB6xAI9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938520; c=relaxed/simple;
	bh=Vi5trMSt6jrm6Y2tQh+idtSfqLGvGTzKtZqVn+WpxPk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HJ054CPZpsaoMIa5xN+SXHpn5FHnZV8WAXEDISDM9l4dcpi2jnyq/aRDEYrltIb4UczmrpK5Xxci2Txsy4IwuJcHTPmq8VYQF7k4VwksOBhW4UCZdSYkZoVqqQG24QWF2eNrCHq277MowZtJls53+coJQbBl996Bb8KAVG9g08I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yw923MIG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yw923MIG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D87C4CEDF;
	Wed, 15 Jan 2025 10:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938520;
	bh=Vi5trMSt6jrm6Y2tQh+idtSfqLGvGTzKtZqVn+WpxPk=;
	h=From:To:Cc:Subject:Date:From;
	b=yw923MIGN2WEESzUNRfYH4dzrnetv3naxllQZSVg6Lbh7bb1MTglb9Mq4oYExQKkr
	 cP8XcmZWmMsl740hryBT+AISRIx0VeeelnLtUPhtMNno9no9485tkieOV661TwHjAy
	 qf6CUDCsMJiCrr3G/cmyW7JliDUJAKolsCnFAonM=
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
Subject: [PATCH 6.6 000/129] 6.6.72-rc1 review
Date: Wed, 15 Jan 2025 11:36:15 +0100
Message-ID: <20250115103554.357917208@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.72-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.72-rc1
X-KernelTest-Deadline: 2025-01-17T10:35+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.72 release.
There are 129 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 17 Jan 2025 10:34:58 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.72-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.72-rc1

Daniel Golle <daniel@makrotopia.org>
    drm/mediatek: Only touch DISP_REG_OVL_PITCH_MSB if AFBC is supported

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Fix text patching when IPI are used

Liu Shixin <liushixin2@huawei.com>
    mm: hugetlb: independent PMD page table shared count

David Hildenbrand <david@redhat.com>
    mm/hugetlb: enforce that PMD PT sharing has split PMD PT locks

Peter Xu <peterx@redhat.com>
    fs/Kconfig: make hugetlbfs a menuconfig

Alexander Gordeev <agordeev@linux.ibm.com>
    pgtable: fix s390 ptdesc field comments

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    workqueue: Do not warn when cancelling WQ_MEM_RECLAIM work from !WQ_MEM_RECLAIM worker

Tejun Heo <tj@kernel.org>
    workqueue: Update lock debugging code

Xuewen Yan <xuewen.yan@unisoc.com>
    workqueue: Add rcu lock check at the end of work item execution

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    pmdomain: imx: gpcv2: fix an OF node reference leak in imx_gpcv2_probe()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    pmdomain: imx: gpcv2: Simplify with scoped for each OF child loop

Peter Geis <pgwipeout@gmail.com>
    arm64: dts: rockchip: add hevc power domain clock to rk3328

Yu Kuai <yukuai3@huawei.com>
    block, bfq: fix waker_bfqq UAF after bfq_split_bfqq()

Daniil Stas <daniil.stas@posteo.net>
    hwmon: (drivetemp) Fix driver producing garbage data when SCSI errors occur

Jesse Taube <Mr.Bossman075@gmail.com>
    ARM: dts: imxrt1050: Fix clocks for mmc

Jens Axboe <axboe@kernel.dk>
    io_uring/eventfd: ensure io_eventfd_signal() defers another RCU period

Nam Cao <namcao@linutronix.de>
    riscv: kprobes: Fix incorrect address calculation

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
    iio: adc: rockchip_saradc: fix information leak in triggered buffer

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: imu: kmx61: fix information leak in triggered buffer

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: light: vcnl4035: fix information leak in triggered buffer

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: dummy: iio_simply_dummy_buffer: fix information leak in triggered buffer

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: pressure: zpa2326: fix information leak in triggered buffer

Ingo Rohloff <ingo.rohloff@lauterbach.com>
    usb: gadget: configfs: Ignore trailing LF for user strings to cdev

Akash M <akash.m5@samsung.com>
    usb: gadget: f_fs: Remove WARN_ON in functionfs_bind

Dan Carpenter <dan.carpenter@linaro.org>
    usb: typec: tcpm/tcpci_maxim: fix error code in max_contaminant_read_resistance_kohm()

Prashanth K <quic_prashk@quicinc.com>
    usb: gadget: f_uac2: Fix incorrect setting of bNumEndpoints

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    usb: chipidea: ci_hdrc_imx: decrement device's refcount in .remove() and in the error path of .probe()

Takashi Iwai <tiwai@suse.de>
    usb: gadget: midi2: Reverse-select at the right place

Ma Ke <make_ruc2021@163.com>
    usb: fix reference leak in usb_new_device()

Kai-Heng Feng <kaihengf@nvidia.com>
    USB: core: Disable LPM only for non-suspended ports

Jun Yan <jerrysteve1101@gmail.com>
    USB: usblp: return error when setting unsupported protocol

Prashanth K <quic_prashk@quicinc.com>
    usb: dwc3-am62: Disable autosuspend during remove

Rick Edgecombe <rick.p.edgecombe@intel.com>
    x86/fpu: Ensure shadow stack is active before "getting" registers

Lianqin Hu <hulianqin@vivo.com>
    usb: gadget: u_serial: Disable ep before setting port to null to fix the crash caused by port being null

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    tty: serial: 8250: Fix another runtime PM usage counter underflow

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

Milan Broz <gmazyland@gmail.com>
    dm-verity FEC: Fix RS FEC repair for roots unaligned to block size (take 2)

Ye Bin <yebin10@huawei.com>
    f2fs: fix null-ptr-deref in f2fs_submit_page_bio()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/timeout: fix multishot updates

Melissa Wen <mwen@igalia.com>
    drm/amd/display: increase MAX_SURFACES to the value supported by hw

Jesse.zhang@amd.com <Jesse.zhang@amd.com>
    drm/amdkfd: fixed page fault when enable MES shader debugger

Hans de Goede <hdegoede@redhat.com>
    ACPI: resource: Add Asus Vivobook X1504VAP to irq1_level_low_skip_override[]

Hans de Goede <hdegoede@redhat.com>
    ACPI: resource: Add TongFang GM5HG0A to irq1_edge_low_force_override[]

Nam Cao <namcao@linutronix.de>
    riscv: Fix sleeping in invalid context in die()

Meetakshi Setiya <msetiya@microsoft.com>
    smb: client: sync the root session and superblock context passwords before automounting

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    thermal: of: fix OF node leak in of_thermal_zone_find()

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Add check for granularity in dml ceil/floor helpers

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: Implement new SMB3 POSIX type

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

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: sysctl: sched: avoid using current->nsproxy

Mikulas Patocka <mpatocka@redhat.com>
    dm-ebs: don't set the flag DM_TARGET_PASSES_INTEGRITY

Manivannan Sadhasivam <mani@kernel.org>
    scsi: ufs: qcom: Power off the PHY if it was already powered on in ufs_qcom_power_up_sequence()

Krister Johansen <kjlx@templeofstupid.com>
    dm thin: make get_first_thin use rcu-safe list first function

Xu Lu <luxu.kernel@bytedance.com>
    riscv: mm: Fix the out of bound issue of vmemmap address

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    cpuidle: riscv-sbi: fix device node release in early exit of for_each_possible_cpu

He Wang <xw897002528@gmail.com>
    ksmbd: fix unexpectedly changed path in ksmbd_vfs_kern_path_locked

Maciej S. Szmigiero <mail@maciej.szmigiero.name>
    platform/x86/amd/pmc: Only disable IRQ1 wakeup where i8042 actually enabled it

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

Guoqing Jiang <guoqing.jiang@canonical.com>
    drm/mediatek: Set private->all_drm_private[i]->drm to NULL if mtk_drm_bind returns err

Chenguang Zhao <zhaochenguang@kylinos.cn>
    net/mlx5: Fix variable not being completed when function returns

Parker Newman <pnewman@connecttech.com>
    net: stmmac: dwmac-tegra: Read iommu stream id from device tree

Toke Høiland-Jørgensen <toke@redhat.com>
    sched: sch_cake: add bounds checks to host bulk flow fairness counts

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: conntrack: clamp maximum hashtable size to INT_MAX

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: imbalance in flowtable binding

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: fix timestamps after suspend if sensor is on

Jan Beulich <jbeulich@suse.com>
    x86/mm/numa: Use NUMA_NO_NODE when calling memblock_set_node()

Wei Yang <richard.weiyang@gmail.com>
    memblock tests: fix implicit declaration of function 'numa_valid_node'

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Fix early ftrace nop patching

Daniel Borkmann <daniel@iogearbox.net>
    tcp: Annotate data-race around sk->sk_mark in tcp_v4_send_reset

Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
    Bluetooth: btnxpuart: Fix driver sending truncated data

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix Add Device to responding before completing

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix not setting Random Address when required

Jakub Kicinski <kuba@kernel.org>
    eth: gve: use appropriate helper to set xdp_features

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipvlan: Fix use-after-free in ipvlan_get_iflink().

Benjamin Coddington <bcodding@redhat.com>
    tls: Fix tls_sw_sendmsg error handling

En-Wei Wu <en-wei.wu@canonical.com>
    igc: return early when failing to read EECD register

Jesse Brandeburg <jesse.brandeburg@intel.com>
    igc: field get conversion

Przemyslaw Korba <przemyslaw.korba@intel.com>
    ice: fix incorrect PHY settings for 100 GB/s

Anumula Murali Mohan Reddy <anumula@chelsio.com>
    cxgb4: Avoid removal of uninserted tid

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    bnxt_en: Fix possible memory leak when hwrm_req_replace fails

Shannon Nelson <shannon.nelson@amd.com>
    pds_core: limit loop over fw name list

Qu Wenruo <wqu@suse.com>
    btrfs: avoid NULL pointer dereference if no valid extent tree

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: fix firmware mailbox abnormal return

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

Li Zhijian <lizhijian@fujitsu.com>
    selftests/alsa: Fix circular dependency involving global-timer

Chen-Yu Tsai <wenst@chromium.org>
    ASoC: mediatek: disable buffer pre-allocation

Shuming Fan <shumingf@realtek.com>
    ASoC: rt722: add delay time to wait for the calibration procedure

Gao Xiang <xiang@kernel.org>
    erofs: fix PSI memstall accounting

Gao Xiang <xiang@kernel.org>
    erofs: handle overlapped pclusters out of crafted images properly

Amir Goldstein <amir73il@gmail.com>
    ovl: support encoding fid from inode with no alias

Amir Goldstein <amir73il@gmail.com>
    ovl: pass realinode to ovl_encode_real_fh() instead of realdentry

Amir Goldstein <amir73il@gmail.com>
    ovl: do not encode lower fh with upper sb_writers held

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

Mike Rapoport (IBM) <rppt@kernel.org>
    memblock: use numa_valid_node() helper to check for invalid node ID

Jan Beulich <jbeulich@suse.com>
    memblock: make memblock_set_node() also warn about use of MAX_NUMNODES


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/nxp/imx/imxrt1050.dtsi           |   2 +-
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |   1 +
 arch/riscv/include/asm/cacheflush.h                |   6 +
 arch/riscv/include/asm/page.h                      |   1 +
 arch/riscv/include/asm/patch.h                     |   1 +
 arch/riscv/include/asm/pgtable.h                   |   2 +-
 arch/riscv/kernel/ftrace.c                         |  47 ++++++-
 arch/riscv/kernel/patch.c                          |  16 ++-
 arch/riscv/kernel/probes/kprobes.c                 |   2 +-
 arch/riscv/kernel/traps.c                          |   6 +-
 arch/riscv/mm/init.c                               |  17 ++-
 arch/x86/kernel/fpu/regset.c                       |   3 +-
 arch/x86/mm/numa.c                                 |   6 +-
 block/bfq-iosched.c                                |  12 +-
 drivers/acpi/resource.c                            |  18 +++
 drivers/base/topology.c                            |  24 +++-
 drivers/bluetooth/btnxpuart.c                      |   1 +
 drivers/cpuidle/cpuidle-riscv-sbi.c                |   4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_debug.c             |  17 +++
 drivers/gpu/drm/amd/display/dc/dc.h                |   2 +-
 .../gpu/drm/amd/display/dc/dml/dml_inline_defs.h   |   8 ++
 drivers/gpu/drm/mediatek/Kconfig                   |   5 -
 drivers/gpu/drm/mediatek/mtk_disp_ovl.c            |  57 ++++-----
 drivers/gpu/drm/mediatek/mtk_dp.c                  |  46 ++++---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |   2 +
 drivers/hwmon/drivetemp.c                          |   8 +-
 drivers/iio/adc/ad7124.c                           |   3 +
 drivers/iio/adc/at91_adc.c                         |   2 +-
 drivers/iio/adc/rockchip_saradc.c                  |   2 +
 drivers/iio/adc/ti-ads124s08.c                     |   4 +-
 drivers/iio/adc/ti-ads8688.c                       |   2 +-
 drivers/iio/dummy/iio_simple_dummy_buffer.c        |   2 +-
 drivers/iio/gyro/fxas21002c_core.c                 |  11 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c   |   8 +-
 drivers/iio/imu/kmx61.c                            |   2 +-
 drivers/iio/inkern.c                               |   2 +-
 drivers/iio/light/vcnl4035.c                       |   2 +-
 drivers/iio/pressure/zpa2326.c                     |   2 +
 drivers/md/dm-ebs-target.c                         |   2 +-
 drivers/md/dm-thin.c                               |   5 +-
 drivers/md/dm-verity-fec.c                         |  39 ++++--
 drivers/md/persistent-data/dm-array.c              |  19 +--
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c    |   4 +-
 drivers/net/ethernet/amd/pds_core/devlink.c        |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c      |   3 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   5 +-
 drivers/net/ethernet/google/gve/gve_main.c         |  14 ++-
 drivers/net/ethernet/intel/ice/ice_ptp_consts.h    |   4 +-
 drivers/net/ethernet/intel/igc/igc_base.c          |  12 +-
 drivers/net/ethernet/intel/igc/igc_i225.c          |   5 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   6 +-
 drivers/net/ethernet/intel/igc/igc_phy.c           |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c  |  14 ++-
 drivers/net/ethernet/wangxun/libwx/wx_hw.c         |  24 ++--
 drivers/net/ieee802154/ca8210.c                    |   6 +-
 drivers/platform/x86/amd/pmc/pmc.c                 |   8 +-
 drivers/pmdomain/imx/gpcv2.c                       |  10 +-
 drivers/staging/iio/frequency/ad9832.c             |   2 +-
 drivers/staging/iio/frequency/ad9834.c             |   2 +-
 drivers/thermal/thermal_of.c                       |   1 +
 drivers/tty/serial/8250/8250_core.c                |   3 +
 drivers/ufs/core/ufshcd-priv.h                     |   6 -
 drivers/ufs/core/ufshcd.c                          |   1 -
 drivers/ufs/host/ufs-qcom.c                        |  13 +-
 drivers/usb/chipidea/ci_hdrc_imx.c                 |  25 ++--
 drivers/usb/class/usblp.c                          |   7 +-
 drivers/usb/core/hub.c                             |   6 +-
 drivers/usb/core/port.c                            |   7 +-
 drivers/usb/dwc3/core.h                            |   1 +
 drivers/usb/dwc3/dwc3-am62.c                       |   1 +
 drivers/usb/dwc3/gadget.c                          |   4 +-
 drivers/usb/gadget/Kconfig                         |   4 +-
 drivers/usb/gadget/configfs.c                      |   6 +-
 drivers/usb/gadget/function/f_fs.c                 |   2 +-
 drivers/usb/gadget/function/f_uac2.c               |   1 +
 drivers/usb/gadget/function/u_serial.c             |   8 +-
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/option.c                        |   4 +-
 drivers/usb/storage/unusual_devs.h                 |   7 ++
 drivers/usb/typec/tcpm/maxim_contaminant.c         |   4 +-
 fs/Kconfig                                         |  24 ++--
 fs/afs/afs.h                                       |   2 +-
 fs/afs/afs_vl.h                                    |   1 +
 fs/afs/vl_alias.c                                  |   8 +-
 fs/afs/vlclient.c                                  |   2 +-
 fs/btrfs/scrub.c                                   |   4 +
 fs/erofs/zdata.c                                   |  66 +++++-----
 fs/exfat/dir.c                                     |   3 +-
 fs/exfat/fatent.c                                  |  10 ++
 fs/f2fs/super.c                                    |  12 +-
 fs/jbd2/commit.c                                   |   4 +-
 fs/jbd2/revoke.c                                   |   2 +-
 fs/overlayfs/copy_up.c                             |  62 +++++----
 fs/overlayfs/export.c                              |  49 ++++----
 fs/overlayfs/namei.c                               |  41 ++++--
 fs/overlayfs/overlayfs.h                           |  28 +++--
 fs/overlayfs/super.c                               |  20 ++-
 fs/overlayfs/util.c                                |  10 ++
 fs/smb/client/namespace.c                          |  19 ++-
 fs/smb/server/smb2pdu.c                            |  43 +++++++
 fs/smb/server/smb2pdu.h                            |  10 ++
 fs/smb/server/vfs.c                                |   3 +-
 include/linux/hugetlb.h                            |   5 +-
 include/linux/mm.h                                 |   1 +
 include/linux/mm_types.h                           |  34 ++++-
 include/linux/numa.h                               |   5 +
 include/net/inet_connection_sock.h                 |   2 +-
 include/ufs/ufshcd.h                               |   2 -
 io_uring/io_uring.c                                |  13 +-
 io_uring/timeout.c                                 |   4 +-
 kernel/workqueue.c                                 |  68 ++++++----
 mm/hugetlb.c                                       |  24 ++--
 mm/memblock.c                                      |  24 ++--
 net/802/psnap.c                                    |   4 +-
 net/bluetooth/hci_sync.c                           |  11 +-
 net/bluetooth/mgmt.c                               |  38 +++++-
 net/core/link_watch.c                              |  10 +-
 net/ipv4/tcp_ipv4.c                                |   2 +-
 net/mptcp/ctrl.c                                   |  11 +-
 net/netfilter/nf_conntrack_core.c                  |   5 +-
 net/netfilter/nf_tables_api.c                      |  15 ++-
 net/sched/cls_flow.c                               |   3 +-
 net/sched/sch_cake.c                               | 140 +++++++++++----------
 net/sctp/sysctl.c                                  |  14 ++-
 net/tls/tls_sw.c                                   |   2 +-
 sound/soc/codecs/rt722-sdca.c                      |   7 +-
 .../soc/mediatek/common/mtk-afe-platform-driver.c  |   4 +-
 tools/include/linux/numa.h                         |   5 +
 tools/testing/selftests/alsa/Makefile              |   2 +-
 131 files changed, 1032 insertions(+), 509 deletions(-)


