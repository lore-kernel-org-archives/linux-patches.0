Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEFB2D46B3;
	Mon, 13 Oct 2025 14:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366898; cv=none; b=QHre+pwEm17Vw3gZUCC1xztdQi3f5hW3+W+k2PiHnkZqjLFWE3BJqEAIaVYlrzruFHMGDhc0bm9djnT8pk6krtxcuouxIOZMi+Kur2N/C9Yt6umq0uKYWWsehJ1kDu48/GSwAul+c1NrfwLrG3c+qdHGswt8GrJTlPIHb15cjkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366898; c=relaxed/simple;
	bh=Et98TPsNTIRdi4pRiQLrFeQi4NvA0kUu83E67pl2dLY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Bk+SeXJLfp2PBSf21SqsMbT083MZRaciiojsze3gXJuV6aWgpaBmUOkeC7qPKi40bPa6ubB3QDA1gVnIMCEynaHZt7Ow3E5Du6IKNvHyJPwzpA5IRv/wsp1epgBJKABs9ZrPT+uH8XP6JKYT4dVfsbFAtHHM9yKAkTkfdcbsywU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pFQ0YM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pFQ0YM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA12C4CEFE;
	Mon, 13 Oct 2025 14:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760366896;
	bh=Et98TPsNTIRdi4pRiQLrFeQi4NvA0kUu83E67pl2dLY=;
	h=From:To:Cc:Subject:Date:From;
	b=1pFQ0YM/g6qfjfGDYbuPJxbo45gilr+LQorqF076Ja2shCclr54TW8VfzcKD+dkaM
	 noUCN0niGuFS2sph6prOHo6bvvgl9ZKKDyH8vbHOPP6vQzQprNvmKhN9K2BWtKA7wT
	 1/T0SWzf63R4OrMEJQ6e38kXKdujVgnyxin91chg=
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
	achill@achill.org
Subject: [PATCH 6.1 000/196] 6.1.156-rc1 review
Date: Mon, 13 Oct 2025 16:42:53 +0200
Message-ID: <20251013144314.549284796@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.156-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.156-rc1
X-KernelTest-Deadline: 2025-10-15T14:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.156 release.
There are 196 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.156-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.156-rc1

K Prateek Nayak <kprateek.nayak@amd.com>
    drivers: base: cacheinfo: Update cpu_map_populated during CPU Hotplug

Yicong Yang <yangyicong@hisilicon.com>
    cacheinfo: Fix LLC is not exported through sysfs

Pierre Gondois <pierre.gondois@arm.com>
    cacheinfo: Initialize variables in fetch_cache_info()

Miaoqian Lin <linmq006@gmail.com>
    usb: cdns3: cdnsp-pci: remove redundant pci_disable_device() call

Sven Peter <sven@kernel.org>
    usb: typec: tipd: Clear interrupts first

Oleksij Rempel <linux@rempel-privat.de>
    net: usb: asix: hold PM usage ref to avoid PM/MDIO + RTNL deadlock

Salah Triki <salah.triki@gmail.com>
    bus: fsl-mc: Check return value of platform_get_resource()

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    pinctrl: check the return value of pinmux_ops::get_function_name()

Zhen Ni <zhen.ni@easystack.cn>
    Input: uinput - zero-initialize uinput_ff_upload_compat to avoid info leak

Marek Vasut <marek.vasut@mailbox.org>
    Input: atmel_mxt_ts - allow reset GPIO to sleep

Ling Xu <quic_lxu5@quicinc.com>
    misc: fastrpc: Skip reference for DMA handles

Ling Xu <quic_lxu5@quicinc.com>
    misc: fastrpc: fix possible map leak in fastrpc_put_args

Ling Xu <quic_lxu5@quicinc.com>
    misc: fastrpc: Fix fastrpc_map_lookup operation

Guangshuo Li <lgs201920130244@gmail.com>
    nvdimm: ndtest: Return -ENOMEM if devm_kcalloc() fails in ndtest_probe()

Yang Shi <yang@os.amperecomputing.com>
    mm: hugetlb: avoid soft lockup when mprotect to large memory area

Jan Kara <jack@suse.cz>
    ext4: fix checks for orphan inodes

Matvey Kovalev <matvey.kovalev@ispras.ru>
    ksmbd: fix error code overwriting in smb2_get_info_filesystem()

Zheng Qixing <zhengqixing@huawei.com>
    dm: fix NULL pointer dereference in __dm_suspend()

Zheng Qixing <zhengqixing@huawei.com>
    dm: fix queue start/stop imbalance under suspend/load/resume races

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    mfd: vexpress-sysreg: Check the return value of devm_gpiochip_add_data()

Deepak Sharma <deepak.sharma.472935@gmail.com>
    net: nfc: nci: Add parameter validation for packet data

Larshin Sergey <Sergey.Larshin@kaspersky.com>
    fs: udf: fix OOB read in lengthAllocDescs handling

Naman Jain <namjain@linux.microsoft.com>
    uio_hv_generic: Let userspace take care of interrupt mask

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: fix uninit-value in squashfs_get_parent

zhang jiao <zhangjiao2@cmss.chinamobile.com>
    vhost: vringh: Modify the return value check

Jakub Kicinski <kuba@kernel.org>
    Revert "net/mlx5e: Update and set Xon/Xoff upon MTU set"

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: fw reset, add reset timeout work

Shay Drory <shayd@nvidia.com>
    net/mlx5: pagealloc: Fix reclaim race during command interface teardown

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Stop polling for command response if interface goes down

Yeounsu Moon <yyyynoom@gmail.com>
    net: dlink: handle copy_thresh allocation failure

Kohei Enju <enjuk@amazon.com>
    net: ena: return 0 in ena_get_rxfh_key_size() when RSS hash key is not configurable

Kohei Enju <enjuk@amazon.com>
    nfp: fix RSS hash key size when RSS is not supported

Erick Karanja <karanja99erick@gmail.com>
    mtd: rawnand: atmel: Fix error handling path in atmel_nand_controller_add_nands

Donet Tom <donettom@linux.ibm.com>
    drivers/base/node: fix double free in register_one_node()

Dan Carpenter <dan.carpenter@linaro.org>
    ocfs2: fix double free in user_cluster_connect()

Nishanth Menon <nm@ti.com>
    hwrng: ks-sa - fix division by zero in ks_sa_rng_init

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix using random address for BIG/PA advertisements

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: don't leak skb in ISO_CONT RX

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Fix possible UAF on iso_conn_free

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix not exposing debug UUID on MGMT_OP_READ_EXP_FEATURES_INFO

Michael S. Tsirkin <mst@redhat.com>
    vhost: vringh: Fix copy_to_iter return value check

I Viswanath <viswanathiyyappan@gmail.com>
    net: usb: Remove disruptive netif_wake_queue in rtl8150_set_multicast

Bernard Metzler <bernard.metzler@linux.dev>
    RDMA/siw: Always report immediate post SQ errors

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    usb: vhci-hcd: Prevent suspending virtually attached devices

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpt3sas: Fix crash in transport port remove by using ioc_info()

Slavin Liu <slavin452@gmail.com>
    ipvs: Defer ip_vs_ftp unregister during netns cleanup

Anthony Iliopoulos <ailiop@suse.com>
    NFSv4.1: fix backchannel max_resp_sz verification check

Leo Yan <leo.yan@arm.com>
    coresight: trbe: Return NULL pointer for allocation failures

Yuanfang Zhang <yuanfang.zhang@oss.qualcomm.com>
    coresight-etm4x: Conditionally access register TRCEXTINSELR

Stephan Gerhold <stephan.gerhold@linaro.org>
    remoteproc: qcom: q6v5: Avoid disabling handover IRQ twice

Nagarjuna Kristam <nkristam@nvidia.com>
    PCI: tegra194: Fix duplicate PLL disable in pex_ep_event_pex_rst_assert()

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: rtw89: avoid circular locking dependency in ser_state_run()

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon/qm - set NULL to qm->debug.qm_diff_regs

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
    sparc: fix accurate exception reporting in copy_{from,to}_user for M7

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
    sparc: fix accurate exception reporting in copy_to_user for Niagara 4

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
    sparc: fix accurate exception reporting in copy_{from_to}_user for Niagara

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
    sparc: fix accurate exception reporting in copy_{from_to}_user for UltraSPARC III

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
    sparc: fix accurate exception reporting in copy_{from_to}_user for UltraSPARC

Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
    wifi: mac80211: fix Rx packet handling when pubsta information is not available

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath10k: avoid unnecessary wait for service ready message

Bagas Sanjaya <bagasdotme@gmail.com>
    Documentation: trace: historgram-design: Separate sched_waking histogram section heading and the following diagram

Vlad Dumitrescu <vdumitrescu@nvidia.com>
    IB/sa: Fix sa_local_svc_timeout_ms read race

Parav Pandit <parav@nvidia.com>
    RDMA/core: Resolve MAC of next-hop device without ARP support

Michal Pecio <michal.pecio@gmail.com>
    Revert "usb: xhci: Avoid Stop Endpoint retry loop if the endpoint seems Running"

wangzijie <wangzijie1@honor.com>
    f2fs: fix zero-sized extent for precache extents

Qianfeng Rong <rongqianfeng@vivo.com>
    scsi: qla2xxx: Fix incorrect sign of error code in START_SP_W_RETRIES()

Qianfeng Rong <rongqianfeng@vivo.com>
    scsi: qla2xxx: edif: Fix incorrect sign of error code

Colin Ian King <colin.i.king@gmail.com>
    ACPI: NFIT: Fix incorrect ndr_desc being reportedin dev_err message

Abdun Nihaal <abdun.nihaal@gmail.com>
    wifi: mt76: fix potential memory leak in mt76_wmac_probe()

Håkon Bugge <haakon.bugge@oracle.com>
    RDMA/cm: Rate limit destroy CM ID timeout error message

Donet Tom <donettom@linux.ibm.com>
    drivers/base/node: handle error properly in register_one_node()

Christophe Leroy <christophe.leroy@csgroup.eu>
    watchdog: mpc8xxx_wdt: Reload the watchdog timer when enabling the watchdog

Zhen Ni <zhen.ni@easystack.cn>
    netfilter: ipset: Remove unused htable_bits in macro ahash_region

Hans de Goede <hansg@kernel.org>
    iio: consumers: Fix offset handling in iio_convert_raw_to_processed()

Vitaly Grigoryev <Vitaly.Grigoryev@kaspersky.com>
    fs: ntfs3: Fix integer overflow in run_unpack()

Qianfeng Rong <rongqianfeng@vivo.com>
    drm/msm/dpu: fix incorrect type for ret

Takashi Iwai <tiwai@suse.de>
    ASoC: Intel: bytcr_rt5651: Fix invalid quirk input mapping

Takashi Iwai <tiwai@suse.de>
    ASoC: Intel: bytcr_rt5640: Fix invalid quirk input mapping

Takashi Iwai <tiwai@suse.de>
    ASoC: Intel: bytcht_es8316: Fix invalid quirk input mapping

Wang Liang <wangliang74@huawei.com>
    pps: fix warning in pps_register_cdev when register device fail

Colin Ian King <colin.i.king@gmail.com>
    misc: genwqe: Fix incorrect cmd field being reported in error

William Wu <william.wu@rock-chips.com>
    usb: gadget: configfs: Correctly set use_os_string at bind

Xichao Zhao <zhao.xichao@vivo.com>
    usb: phy: twl6030: Fix incorrect type for ret

Qianfeng Rong <rongqianfeng@vivo.com>
    drm/amdkfd: Fix error code sign for EINVAL in svm_ioctl()

Eric Dumazet <edumazet@google.com>
    tcp: fix __tcp_close() to only send RST when required

Alok Tiwari <alok.a.tiwari@oracle.com>
    PCI: tegra: Fix devm_kcalloc() argument order for port->phys allocation

Stefan Kerkmann <s.kerkmann@pengutronix.de>
    wifi: mwifiex: send world regulatory domain to driver

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Disable SCLK switching on Oland with high pixel clocks (v3)

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Disable MCLK switching with non-DC at 120 Hz+ (v2)

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Treat zero vblank time as too short in si_dpm (v3)

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Adjust si_upload_smc_data register programming (v3)

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Fix si_upload_smc_data (v3)

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Disable ULV even if unsupported (v3)

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu: Power up UVD 3 for FW validation (v2)

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon - re-enable address prefetch after device resuming

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon/zip - remove unnecessary validation for high-performance mode configurations

Arnd Bergmann <arnd@arndb.de>
    media: st-delta: avoid excessive stack usage

Qianfeng Rong <rongqianfeng@vivo.com>
    ALSA: lx_core: use int type to store negative error codes

Zhang Shurong <zhang_shurong@foxmail.com>
    media: rj54n1cb0c: Fix memleak in rj54n1_probe()

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: myrs: Fix dma_alloc_coherent() error check

Niklas Cassel <cassel@kernel.org>
    scsi: pm80xx: Fix array-index-out-of-of-bounds on rmmod

Arnd Bergmann <arnd@arndb.de>
    hwrng: nomadik - add ARM_AMBA dependency

Liao Yuanhong <liaoyuanhong@vivo.com>
    drm/amd/display: Remove redundant semicolons

Dan Carpenter <dan.carpenter@linaro.org>
    serial: max310x: Add error checking in probe()

Dan Carpenter <dan.carpenter@linaro.org>
    usb: host: max3421-hcd: Fix error pointer dereference in probe cleanup

Brahmajit Das <listout@listout.xyz>
    drm/radeon/r600_cs: clean up of dead code in r600_cs

Brigham Campbell <me@brighamcampbell.com>
    drm/panel: novatek-nt35560: Fix invalid return value

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Enforce expected_attach_type for tailcall compatibility

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    i2c: designware: Add disabling clocks when probe fails

Leilk.Liu <leilk.liu@mediatek.com>
    i2c: mediatek: fix potential incorrect use of I2C_MASTER_WRRD

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    thermal/drivers/qcom/lmh: Add missing IRQ includes

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    thermal/drivers/qcom: Make LMH select QCOM_SCM

Vadim Pasternak <vadimp@nvidia.com>
    hwmon: (mlxreg-fan) Separate methods of fan setting coming from different subsystems

Zhouyi Zhou <zhouzhouyi@gmail.com>
    tools/nolibc: make time_t robust if __kernel_old_time_t is missing in host headers

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    smp: Fix up and expand the smp_call_function_many() kerneldoc

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Explicitly check accesses to bpf_sock_addr

Akhilesh Patil <akhilesh@ee.iitb.ac.in>
    selftests: watchdog: skip ping loop if WDIOF_KEEPALIVEPING not supported

Stanley Chu <stanley.chuys@gmail.com>
    i3c: master: svc: Recycle unused IBI slot

Stanley Chu <yschu@nuvoton.com>
    i3c: master: svc: Use manual response for IBI events

Daniel Wagner <wagi@kernel.org>
    nvmet-fc: move lsop put work to nvmet_fc_ls_req_op

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: tiehrpwm: Fix corner case in clock divisor calculation

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt8516-pumpkin: Fix machine compatible

Johan Hovold <johan@kernel.org>
    cpuidle: qcom-spm: fix device and OF node leaks at probe

Johan Hovold <johan@kernel.org>
    firmware: firmware: meson-sm: fix compile-test default

Eric Dumazet <edumazet@google.com>
    nbd: restrict sockets to TCP and UDP

Genjian Zhang <zhanggenjian@kylinos.cn>
    null_blk: Fix the description of the cache_size module argument

Qianfeng Rong <rongqianfeng@vivo.com>
    pinctrl: renesas: Use int type to store negative error codes

Andy Yan <andyshrk@163.com>
    power: supply: cw2015: Fix a alignment coding style issue

Dan Carpenter <dan.carpenter@linaro.org>
    PM / devfreq: mtk-cci: Fix potential error pointer dereference in probe()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: core: Clear power.must_resume in noirq suspend error path

Qianfeng Rong <rongqianfeng@vivo.com>
    block: use int to store blk_stack_limits() return value

Qianfeng Rong <rongqianfeng@vivo.com>
    regulator: scmi: Use int type to store negative error codes

Nicolas Ferre <nicolas.ferre@microchip.com>
    ARM: at91: pm: fix MCKx restore routine

Li Nan <linan122@huawei.com>
    blk-mq: check kobject state_in_sysfs before deleting in blk_mq_unregister_hctx

Da Xue <da@libre.computer>
    pinctrl: meson-gxl: add missing i2c_d pinmux

Sneh Mankad <sneh.mankad@oss.qualcomm.com>
    soc: qcom: rpmh-rsc: Unconditionally clear _TRIGGER bit for TCS

Huisong Li <lihuisong@huawei.com>
    ACPI: processor: idle: Fix memory leak when register cpuidle device failed

Florian Fainelli <florian.fainelli@broadcom.com>
    cpufreq: scmi: Account for malformed DT in scmi_dev_used_by_cpus()

Yureka Lilian <yuka@yuka.dev>
    libbpf: Fix reuse of DEVMAP

Tao Chen <chen.dylane@linux.dev>
    bpf: Remove migrate_disable in kprobe_multi_link_prog_run

Matt Bobrowski <mattbobrowski@google.com>
    bpf/selftests: Fix test_tcpnotify_user

Geert Uytterhoeven <geert+renesas@glider.be>
    regmap: Remove superfluous check for !config in __regmap_init()

Biju Das <biju.das.jz@bp.renesas.com>
    arm64: dts: renesas: rzg2lc-smarc: Disable CAN-FD channel0

Uros Bizjak <ubizjak@gmail.com>
    x86/vdso: Fix output operand size of RDPID

Stefan Metzmacher <metze@samba.org>
    smb: server: fix IRD/ORD negotiation with the client

Leo Yan <leo.yan@arm.com>
    perf: arm_spe: Prevent overflow in PERF_IDX2OFF()

Leo Yan <leo.yan@arm.com>
    coresight: trbe: Prevent overflow in PERF_IDX2OFF()

Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
    selftests: arm64: Check fread return value in exec_target

Johannes Nixdorf <johannes@nixdorf.dev>
    seccomp: Fix a race with WAIT_KILLABLE_RECV if the tracer replies too fast

Geert Uytterhoeven <geert+renesas@glider.be>
    init: INITRAMFS_PRESERVE_MTIME should depend on BLK_DEV_INITRD

Jeff Layton <jlayton@kernel.org>
    filelock: add FL_RECLAIM to show_fl_flags() macro

Nalivayko Sergey <Sergey.Nalivayko@kaspersky.com>
    net/9p: fix double req put in p9_fd_cancelled

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: rng - Ensure set_ent is always present

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    driver core/PM: Set power.no_callbacks along with power.no_pm

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    staging: axis-fifo: flush RX FIFO on read errors

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    staging: axis-fifo: fix TX handling on copy_from_user() failure

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    staging: axis-fifo: fix maximum TX packet length check

Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
    serial: stm32: allow selecting console when the driver is module

Arnaud Lecomte <contact@arnaud-lcm.com>
    hid: fix I2C read buffer overflow in raw_event() for mcp2221

Duy Nguyen <duy.nguyen.rh@renesas.com>
    can: rcar_canfd: Fix controller mode setting

Chen Yufeng <chenyufeng@iie.ac.cn>
    can: hi311x: fix null pointer dereference when resuming from sleep before interface was enabled

David Sterba <dsterba@suse.com>
    btrfs: ref-verify: handle damaged extent root tree

Jack Yu <jack.yu@realtek.com>
    ASoC: rt5682s: Adjust SAR ADC button mode to fix noise issue

hupu <hupu.gm@gmail.com>
    perf subcmd: avoid crash in exclude_cmds when excludes is empty

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: limit MAX_TAG_SIZE to 255

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtlwifi: rtl8192cu: Don't claim USB ID 07b8:8188

Xiaowei Li <xiaowei.li@simcom.com>
    USB: serial: option: add SIMCom 8230C compositions

David Laight <David.Laight@ACULAB.COM>
    minmax.h: remove some #defines that are only expanded once

David Laight <David.Laight@ACULAB.COM>
    minmax.h: simplify the variants of clamp()

David Laight <David.Laight@ACULAB.COM>
    minmax.h: move all the clamp() definitions after the min/max() ones

David Laight <David.Laight@ACULAB.COM>
    minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()

David Laight <David.Laight@ACULAB.COM>
    minmax.h: reduce the #define expansion of min(), max() and clamp()

David Laight <David.Laight@ACULAB.COM>
    minmax.h: update some comments

David Laight <David.Laight@ACULAB.COM>
    minmax.h: add whitespace around operators and after commas

Linus Torvalds <torvalds@linux-foundation.org>
    minmax: fix up min3() and max3() too

Linus Torvalds <torvalds@linux-foundation.org>
    minmax: improve macro expansion and type checking

Linus Torvalds <torvalds@linux-foundation.org>
    minmax: simplify min()/max()/clamp() implementation

Linus Torvalds <torvalds@linux-foundation.org>
    minmax: don't use max() in situations that want a C constant expression

Duoming Zhou <duoming@zju.edu.cn>
    media: i2c: tc358743: Fix use-after-free bugs caused by orphan timer in probe

Duoming Zhou <duoming@zju.edu.cn>
    media: tuner: xc5000: Fix use-after-free in xc5000_release

Ricardo Ribalda <ribalda@chromium.org>
    media: tunner: xc5000: Refactor firmware load

Will Deacon <will@kernel.org>
    KVM: arm64: Fix softirq masking in FPSIMD register saving sequence

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: audioreach: fix potential null pointer dereference

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    media: uvcvideo: Mark invalid entities with id UVC_INVALID_ENTITY_ID

Larshin Sergey <Sergey.Larshin@kaspersky.com>
    media: rc: fix races with imon_disconnect()

Duoming Zhou <duoming@zju.edu.cn>
    media: b2c2: Fix use-after-free causing by irq_check_work in flexcop_pci_remove

Wang Haoran <haoranwangsec@gmail.com>
    scsi: target: target_core_configfs: Add length check to avoid buffer overflow

Kees Cook <kees@kernel.org>
    gcc-plugins: Remove TODO_verify_il for GCC >= 16

Pierre Gondois <pierre.gondois@arm.com>
    arch_topology: Build cacheinfo from primary CPU

Pierre Gondois <pierre.gondois@arm.com>
    ACPI: PPTT: Update acpi_find_last_cache_level() to acpi_get_cache_info()

Pierre Gondois <pierre.gondois@arm.com>
    ACPI: PPTT: Remove acpi_find_cache_levels()

Pierre Gondois <pierre.gondois@arm.com>
    cacheinfo: Check 'cache-unified' property to count cache leaves

Pierre Gondois <pierre.gondois@arm.com>
    cacheinfo: Return error code in init_of_cache_level()

Pierre Gondois <pierre.gondois@arm.com>
    cacheinfo: Use RISC-V's init_cache_level() as generic OF implementation

Kenta Akagi <k@mgml.me>
    selftests: mptcp: connect: fix build regression caused by backport

Breno Leitao <leitao@debian.org>
    crypto: sha256 - fix crash at kexec


-------------

Diffstat:

 Documentation/trace/histogram-design.rst           |   4 +-
 Makefile                                           |   4 +-
 arch/arm/mach-at91/pm_suspend.S                    |   4 +-
 arch/arm64/boot/dts/mediatek/mt8516-pumpkin.dts    |   2 +-
 arch/arm64/boot/dts/renesas/rzg2lc-smarc.dtsi      |   5 +-
 arch/arm64/kernel/cacheinfo.c                      |  11 +-
 arch/arm64/kernel/fpsimd.c                         |   8 +-
 arch/riscv/kernel/cacheinfo.c                      |  42 ----
 arch/sparc/lib/M7memcpy.S                          |  20 +-
 arch/sparc/lib/Memcpy_utils.S                      |   9 +
 arch/sparc/lib/NG4memcpy.S                         |   2 +-
 arch/sparc/lib/NGmemcpy.S                          |  29 ++-
 arch/sparc/lib/U1memcpy.S                          |  19 +-
 arch/sparc/lib/U3memcpy.S                          |   2 +-
 arch/x86/include/asm/segment.h                     |   8 +-
 block/blk-mq-sysfs.c                               |   6 +-
 block/blk-settings.c                               |   3 +-
 crypto/rng.c                                       |   8 +
 drivers/acpi/nfit/core.c                           |   2 +-
 drivers/acpi/pptt.c                                |  93 ++++----
 drivers/acpi/processor_idle.c                      |   3 +
 drivers/base/arch_topology.c                       |  12 +-
 drivers/base/cacheinfo.c                           | 168 ++++++++++++---
 drivers/base/node.c                                |   4 +
 drivers/base/power/main.c                          |  14 +-
 drivers/base/regmap/regmap.c                       |   2 +-
 drivers/block/nbd.c                                |   8 +
 drivers/block/null_blk/main.c                      |   2 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |   3 +
 drivers/char/hw_random/Kconfig                     |   1 +
 drivers/char/hw_random/ks-sa-rng.c                 |   4 +
 drivers/cpufreq/scmi-cpufreq.c                     |  10 +
 drivers/cpuidle/cpuidle-qcom-spm.c                 |   7 +-
 drivers/crypto/hisilicon/debugfs.c                 |   1 +
 drivers/crypto/hisilicon/hpre/hpre_main.c          |   3 +-
 drivers/crypto/hisilicon/qm.c                      |   3 -
 drivers/crypto/hisilicon/sec2/sec_main.c           |  80 +++----
 drivers/crypto/hisilicon/zip/zip_main.c            |  17 +-
 drivers/devfreq/mtk-cci-devfreq.c                  |   3 +-
 drivers/firmware/meson/Kconfig                     |   2 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c              |  29 ++-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |   2 +-
 .../display/dc/dml/dcn32/display_rq_dlg_calc_32.c  |   1 -
 drivers/gpu/drm/amd/pm/amdgpu_dpm_internal.c       |   7 +
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |  92 +++++---
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c             |   2 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c    |   2 +-
 drivers/gpu/drm/panel/panel-novatek-nt35560.c      |   2 +-
 drivers/gpu/drm/radeon/r600_cs.c                   |   4 +-
 drivers/hid/hid-mcp2221.c                          |   4 +
 drivers/hwmon/mlxreg-fan.c                         |  24 ++-
 drivers/hwtracing/coresight/coresight-etm4x-core.c |  11 +-
 drivers/hwtracing/coresight/coresight-etm4x.h      |   2 +
 drivers/hwtracing/coresight/coresight-trbe.c       |   9 +-
 drivers/i2c/busses/i2c-designware-platdrv.c        |   1 +
 drivers/i2c/busses/i2c-mt65xx.c                    |  17 +-
 drivers/i3c/master/svc-i3c-master.c                |  31 ++-
 drivers/iio/inkern.c                               |   2 +-
 drivers/infiniband/core/addr.c                     |  10 +-
 drivers/infiniband/core/cm.c                       |   4 +-
 drivers/infiniband/core/sa_query.c                 |   6 +-
 drivers/infiniband/sw/siw/siw_verbs.c              |  25 ++-
 drivers/input/misc/uinput.c                        |   1 +
 drivers/input/touchscreen/atmel_mxt_ts.c           |   2 +-
 drivers/input/touchscreen/cyttsp4_core.c           |   2 +-
 drivers/irqchip/irq-sun6i-r.c                      |   2 +-
 drivers/md/dm-core.h                               |   1 +
 drivers/md/dm-integrity.c                          |   4 +-
 drivers/md/dm.c                                    |  13 +-
 drivers/media/i2c/rj54n1cb0c.c                     |   9 +-
 drivers/media/i2c/tc358743.c                       |   4 +-
 drivers/media/pci/b2c2/flexcop-pci.c               |   2 +-
 .../media/platform/st/sti/delta/delta-mjpeg-dec.c  |  20 +-
 drivers/media/rc/imon.c                            |  27 ++-
 drivers/media/tuners/xc5000.c                      |  41 ++--
 drivers/media/usb/uvc/uvc_driver.c                 |  73 ++++---
 drivers/media/usb/uvc/uvcvideo.h                   |   2 +
 drivers/mfd/vexpress-sysreg.c                      |   6 +-
 drivers/misc/fastrpc.c                             |  62 ++++--
 drivers/misc/genwqe/card_ddcb.c                    |   2 +-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |   4 +-
 drivers/net/can/rcar/rcar_canfd.c                  |   7 +-
 drivers/net/can/spi/hi311x.c                       |  33 +--
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |   5 +-
 drivers/net/ethernet/dlink/dl2k.c                  |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   6 +-
 .../ethernet/mellanox/mlx5/core/en/port_buffer.h   |  12 --
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  17 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  24 +++
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   7 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   2 +-
 drivers/net/usb/asix_devices.c                     |  29 +++
 drivers/net/usb/rtl8150.c                          |   2 -
 drivers/net/wireless/ath/ath10k/wmi.c              |  39 ++--
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   7 +-
 drivers/net/wireless/mediatek/mt76/mt7603/soc.c    |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/sw.c    |   1 -
 drivers/net/wireless/realtek/rtw89/ser.c           |   3 +-
 drivers/nvme/target/fc.c                           |  19 +-
 drivers/pci/controller/dwc/pcie-tegra194.c         |   4 +-
 drivers/pci/controller/pci-tegra.c                 |   2 +-
 drivers/perf/arm_spe_pmu.c                         |   3 +-
 drivers/pinctrl/meson/pinctrl-meson-gxl.c          |  10 +
 drivers/pinctrl/pinmux.c                           |   2 +-
 drivers/pinctrl/renesas/pinctrl.c                  |   3 +-
 drivers/power/supply/cw2015_battery.c              |   3 +-
 drivers/pps/kapi.c                                 |   5 +-
 drivers/pps/pps.c                                  |   5 +-
 drivers/pwm/pwm-tiehrpwm.c                         |   4 +-
 drivers/regulator/scmi-regulator.c                 |   3 +-
 drivers/remoteproc/qcom_q6v5.c                     |   3 -
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |   8 +-
 drivers/scsi/myrs.c                                |   8 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |   9 +-
 drivers/scsi/qla2xxx/qla_edif.c                    |   4 +-
 drivers/scsi/qla2xxx/qla_init.c                    |   4 +-
 drivers/soc/qcom/rpmh-rsc.c                        |   7 +-
 drivers/staging/axis-fifo/axis-fifo.c              |  68 +++---
 drivers/target/target_core_configfs.c              |   2 +-
 drivers/thermal/qcom/Kconfig                       |   3 +-
 drivers/thermal/qcom/lmh.c                         |   2 +
 drivers/tty/serial/Kconfig                         |   2 +-
 drivers/tty/serial/max310x.c                       |   2 +
 drivers/uio/uio_hv_generic.c                       |   7 +-
 drivers/usb/cdns3/cdnsp-pci.c                      |   5 +-
 drivers/usb/gadget/configfs.c                      |   2 +
 drivers/usb/host/max3421-hcd.c                     |   2 +-
 drivers/usb/host/xhci-ring.c                       |  11 +-
 drivers/usb/phy/phy-twl6030-usb.c                  |   3 +-
 drivers/usb/serial/option.c                        |   6 +
 drivers/usb/typec/tipd/core.c                      |  24 +--
 drivers/usb/usbip/vhci_hcd.c                       |  22 ++
 drivers/vhost/vringh.c                             |  14 +-
 drivers/watchdog/mpc8xxx_wdt.c                     |   2 +
 fs/btrfs/ref-verify.c                              |   9 +-
 fs/btrfs/tree-checker.c                            |   2 +-
 fs/ext4/ext4.h                                     |  10 +
 fs/ext4/file.c                                     |   2 +-
 fs/ext4/inode.c                                    |   2 +-
 fs/ext4/orphan.c                                   |   6 +-
 fs/ext4/super.c                                    |   4 +-
 fs/f2fs/data.c                                     |   7 +-
 fs/nfs/nfs4proc.c                                  |   2 +-
 fs/ntfs3/run.c                                     |  12 +-
 fs/ocfs2/stack_user.c                              |   1 +
 fs/smb/server/smb2pdu.c                            |   3 +-
 fs/smb/server/transport_rdma.c                     |  97 +++++++--
 fs/squashfs/inode.c                                |   7 +
 fs/squashfs/squashfs_fs_i.h                        |   2 +-
 fs/udf/inode.c                                     |   3 +
 include/crypto/sha256_base.h                       |   2 +-
 include/linux/bpf.h                                |   1 +
 include/linux/cacheinfo.h                          |  11 +-
 include/linux/compiler.h                           |   9 +
 include/linux/device.h                             |   3 +
 include/linux/minmax.h                             | 236 ++++++++++++---------
 include/trace/events/filelock.h                    |   3 +-
 init/Kconfig                                       |   1 +
 kernel/bpf/core.c                                  |   5 +
 kernel/seccomp.c                                   |  12 +-
 kernel/smp.c                                       |  11 +-
 kernel/trace/bpf_trace.c                           |   9 +-
 lib/vsprintf.c                                     |   2 +-
 mm/hugetlb.c                                       |   2 +
 net/9p/trans_fd.c                                  |   8 +-
 net/bluetooth/hci_sync.c                           |  10 +-
 net/bluetooth/iso.c                                |   9 +-
 net/bluetooth/mgmt.c                               |  10 +-
 net/core/filter.c                                  |  16 +-
 net/ipv4/tcp.c                                     |   9 +-
 net/mac80211/rx.c                                  |  28 ++-
 net/netfilter/ipset/ip_set_hash_gen.h              |   8 +-
 net/netfilter/ipvs/ip_vs_ftp.c                     |   4 +-
 net/nfc/nci/ntf.c                                  | 135 ++++++++----
 scripts/gcc-plugins/gcc-common.h                   |   7 +
 sound/pci/lx6464es/lx_core.c                       |   4 +-
 sound/soc/codecs/rt5682s.c                         |  17 +-
 sound/soc/intel/boards/bytcht_es8316.c             |  20 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |   7 +-
 sound/soc/intel/boards/bytcr_rt5651.c              |  26 ++-
 sound/soc/qcom/qdsp6/topology.c                    |   4 +-
 tools/include/nolibc/std.h                         |   2 +-
 tools/lib/bpf/libbpf.c                             |  10 +
 tools/lib/subcmd/help.c                            |   3 +
 tools/testing/nvdimm/test/ndtest.c                 |  13 +-
 tools/testing/selftests/arm64/pauth/exec_target.c  |   7 +-
 .../selftests/bpf/progs/test_tcpnotify_kern.c      |   1 -
 tools/testing/selftests/bpf/test_tcpnotify_user.c  |  20 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |   2 +-
 tools/testing/selftests/watchdog/watchdog-test.c   |   6 +
 190 files changed, 1637 insertions(+), 903 deletions(-)


