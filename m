Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FDE27A123;
	Mon, 13 Oct 2025 14:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367506; cv=none; b=VujO+t73ykFWlmmk34zBhReDOUnwtF4Ji4OURzT1uUhvuUlPFyyl6jph5ObvJjAHl5zMbnw0GsoMpr9CGMwtfcks9gyl1zRjcVaJ+RU1kgtzHmo0p2klaaCHxA1a5+CtyXfgxng5gi9Ky2ATR5gwJKgKpEQkPpqrvN/RNrvsPY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367506; c=relaxed/simple;
	bh=BX7lAFzbHVDqlDr4tVNPgeXrsE7KTKycB8kObW/apfs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cGBU5SVtqYj9nrqGWyNbsANIviLJTTDpEbKMZai/EFKaUu8b2QpIoexw7NDcdXPGOhaJkiEQKXwa8YkZH7xoFVQjnJkLANRxrDKnfNPXLE6/X4u31NyaFL+EE21H6ZkSWmZQRkiromNNqwK2YBQZavsXei6bfa7gmwshkl0Eti4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04534Sai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04534Sai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09598C4CEE7;
	Mon, 13 Oct 2025 14:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367505;
	bh=BX7lAFzbHVDqlDr4tVNPgeXrsE7KTKycB8kObW/apfs=;
	h=From:To:Cc:Subject:Date:From;
	b=04534SaiDHJTuVLQQeojeyv/0lpSLQiDZCiyGs7eEV5s9+DEIuE82rlyS1aiMobxn
	 6zLf2HsUFbsldJfEfMpGEMRYtGCyVg+r0M8SlNRybTEclLh/gBx5I1FgRqBYqWh4gH
	 nV62Wqx+TClH7kVd3yUN3O/abE6WgFUma+6fgydQ=
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
Subject: [PATCH 6.6 000/196] 6.6.112-rc1 review
Date: Mon, 13 Oct 2025 16:43:11 +0200
Message-ID: <20251013144315.184275491@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.112-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.112-rc1
X-KernelTest-Deadline: 2025-10-15T14:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.112 release.
There are 196 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.112-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.112-rc1

Miaoqian Lin <linmq006@gmail.com>
    usb: cdns3: cdnsp-pci: remove redundant pci_disable_device() call

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: qcm2290: Disable USB SS bus instances in park mode

Sven Peter <sven@kernel.org>
    usb: typec: tipd: Clear interrupts first

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: asix: hold PM usage ref to avoid PM/MDIO + RTNL deadlock

Salah Triki <salah.triki@gmail.com>
    bus: fsl-mc: Check return value of platform_get_resource()

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    pinctrl: check the return value of pinmux_ops::get_function_name()

Zhen Ni <zhen.ni@easystack.cn>
    remoteproc: pru: Fix potential NULL pointer dereference in pru_rproc_set_ctable()

Lei Lu <llfamsec@gmail.com>
    sunrpc: fix null pointer dereference on zero-length checksum

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

Youling Tang <tangyouling@kylinos.cn>
    LoongArch: Automatically disable kaslr if boot from kexec_file

Zheng Qixing <zhengqixing@huawei.com>
    dm: fix NULL pointer dereference in __dm_suspend()

Zheng Qixing <zhengqixing@huawei.com>
    dm: fix queue start/stop imbalance under suspend/load/resume races

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    mfd: vexpress-sysreg: Check the return value of devm_gpiochip_add_data()

Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
    mfd: rz-mtu3: Fix MTU5 NFCR register offset

Deepak Sharma <deepak.sharma.472935@gmail.com>
    net: nfc: nci: Add parameter validation for packet data

Larshin Sergey <Sergey.Larshin@kaspersky.com>
    fs: udf: fix OOB read in lengthAllocDescs handling

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: ipc3-topology: Fix multi-core and static pipelines tear down

Ma Ke <make24@iscas.ac.cn>
    ASoC: wcd934x: fix error handling in wcd934x_codec_parse_data()

Naman Jain <namjain@linux.microsoft.com>
    uio_hv_generic: Let userspace take care of interrupt mask

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: fix uninit-value in squashfs_get_parent

Yazhou Tang <tangyazhou518@outlook.com>
    bpf: Reject negative offsets for ALU ops

zhang jiao <zhangjiao2@cmss.chinamobile.com>
    vhost: vringh: Modify the return value check

Jakub Kicinski <kuba@kernel.org>
    Revert "net/mlx5e: Update and set Xon/Xoff upon MTU set"

Enzo Matsumiya <ematsumiya@suse.de>
    smb: client: fix crypto buffers in non-linear memory

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

Fan Wu <wufan@kernel.org>
    KEYS: X.509: Fix Basic Constraints CA flag parsing

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

Leo Yan <leo.yan@arm.com>
    coresight: etm4x: Support atclk

Yuanfang Zhang <yuanfang.zhang@oss.qualcomm.com>
    coresight-etm4x: Conditionally access register TRCEXTINSELR

Stephan Gerhold <stephan.gerhold@linaro.org>
    remoteproc: qcom: q6v5: Avoid disabling handover IRQ twice

Nagarjuna Kristam <nkristam@nvidia.com>
    PCI: tegra194: Fix duplicate PLL disable in pex_ep_event_pex_rst_assert()

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: rtw89: avoid circular locking dependency in ser_state_run()

Gui-Dong Han <hanguidong02@gmail.com>
    RDMA/rxe: Fix race in do_task() when draining

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon/qm - set NULL to qm->debug.qm_diff_regs

Zilin Guan <zilin@seu.edu.cn>
    vfio/pds: replace bitmap_free with vfree

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
    scsi: qla2xxx: Fix incorrect sign of error code in qla_nvme_xmt_ls_rsp()

Qianfeng Rong <rongqianfeng@vivo.com>
    scsi: qla2xxx: Fix incorrect sign of error code in START_SP_W_RETRIES()

Qianfeng Rong <rongqianfeng@vivo.com>
    scsi: qla2xxx: edif: Fix incorrect sign of error code

Colin Ian King <colin.i.king@gmail.com>
    ACPI: NFIT: Fix incorrect ndr_desc being reportedin dev_err message

Chao Yu <chao@kernel.org>
    f2fs: fix to mitigate overhead of f2fs_zero_post_eof_page()

Chao Yu <chao@kernel.org>
    f2fs: fix to truncate first page in error path of f2fs_truncate()

Chao Yu <chao@kernel.org>
    f2fs: fix to update map->m_next_extent correctly in f2fs_map_blocks()

Abdun Nihaal <abdun.nihaal@gmail.com>
    wifi: mt76: fix potential memory leak in mt76_wmac_probe()

Håkon Bugge <haakon.bugge@oracle.com>
    RDMA/cm: Rate limit destroy CM ID timeout error message

Donet Tom <donettom@linux.ibm.com>
    drivers/base/node: handle error properly in register_one_node()

Christophe Leroy <christophe.leroy@csgroup.eu>
    watchdog: mpc8xxx_wdt: Reload the watchdog timer when enabling the watchdog

Zhang Tengfei <zhtfdev@gmail.com>
    ipvs: Use READ_ONCE/WRITE_ONCE for ipvs->enable

Zhen Ni <zhen.ni@easystack.cn>
    netfilter: ipset: Remove unused htable_bits in macro ahash_region

Hans de Goede <hansg@kernel.org>
    iio: consumers: Fix offset handling in iio_convert_raw_to_processed()

Hans de Goede <hansg@kernel.org>
    iio: consumers: Fix handling of negative channel scale in iio_convert_raw_to_processed()

Moon Hee Lee <moonhee.lee.ca@gmail.com>
    fs/ntfs3: reject index allocation if $BITMAP is empty but blocks exist

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

Seppo Takalo <seppo.takalo@nordicsemi.no>
    tty: n_gsm: Don't block input queue by waiting MSC

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

Yuanfang Zhang <quic_yuanfang@quicinc.com>
    coresight: Only register perf symlink for sinks with alloc_buffer

Eric Dumazet <edumazet@google.com>
    inet: ping: check sock_net() in ping_get_port() and ping_lookup()

Zhushuai Yin <yinzhushuai@huawei.com>
    crypto: hisilicon/qm - check whether the input function and PF are on the same device

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon - re-enable address prefetch after device resuming

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon/zip - remove unnecessary validation for high-performance mode configurations

Arnd Bergmann <arnd@arndb.de>
    media: st-delta: avoid excessive stack usage

Qianfeng Rong <rongqianfeng@vivo.com>
    ALSA: lx_core: use int type to store negative error codes

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix vport loopback forcing for MPV device

Zhang Shurong <zhang_shurong@foxmail.com>
    media: rj54n1cb0c: Fix memleak in rj54n1_probe()

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: myrs: Fix dma_alloc_coherent() error check

Niklas Cassel <cassel@kernel.org>
    scsi: pm80xx: Fix array-index-out-of-of-bounds on rmmod

Arnd Bergmann <arnd@arndb.de>
    hwrng: nomadik - add ARM_AMBA dependency

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: keembay - Add missing check after sg_nents_for_len()

Liao Yuanhong <liaoyuanhong@vivo.com>
    drm/amd/display: Remove redundant semicolons

Dan Carpenter <dan.carpenter@linaro.org>
    serial: max310x: Add error checking in probe()

Komal Bajaj <komal.bajaj@oss.qualcomm.com>
    usb: misc: qcom_eud: Access EUD_MODE_MANAGER2 through secure calls

Dan Carpenter <dan.carpenter@linaro.org>
    usb: host: max3421-hcd: Fix error pointer dereference in probe cleanup

Jonas Karlman <jonas@kwiboo.se>
    phy: rockchip: naneng-combphy: Enable U3 OTG port for RK3568

Jacopo Mondi <jacopo.mondi@ideasonboard.com>
    media: zoran: Remove zoran_fh structure

Chia-I Wu <olvaffe@gmail.com>
    drm/bridge: it6505: select REGMAP_I2C

Chao Yu <chao@kernel.org>
    f2fs: fix condition in __allow_reserved_blocks()

Brahmajit Das <listout@listout.xyz>
    drm/radeon/r600_cs: clean up of dead code in r600_cs

Brigham Campbell <me@brighamcampbell.com>
    drm/panel: novatek-nt35560: Fix invalid return value

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Enforce expected_attach_type for tailcall compatibility

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    i2c: designware: Add disabling clocks when probe fails

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    i2c: designware: Fix clock issue when PM is disabled

Leilk.Liu <leilk.liu@mediatek.com>
    i2c: mediatek: fix potential incorrect use of I2C_MASTER_WRRD

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    thermal/drivers/qcom/lmh: Add missing IRQ includes

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    thermal/drivers/qcom: Make LMH select QCOM_SCM

Vadim Pasternak <vadimp@nvidia.com>
    hwmon: (mlxreg-fan) Separate methods of fan setting coming from different subsystems

Qi Xi <xiqi2@huawei.com>
    once: fix race by moving DO_ONCE to separate section

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

Dmitry Antipov <dmantipov@yandex.ru>
    ACPICA: Fix largest possible resource descriptor index

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: tiehrpwm: Fix corner case in clock divisor calculation

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt8516-pumpkin: Fix machine compatible

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt6795-xperia-m5: Fix mmc0 latch-ck value

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt6331: Fix pmic, regulators, rtc, keys node names

Johan Hovold <johan@kernel.org>
    cpuidle: qcom-spm: fix device and OF node leaks at probe

Johan Hovold <johan@kernel.org>
    firmware: firmware: meson-sm: fix compile-test default

Eric Dumazet <edumazet@google.com>
    nbd: restrict sockets to TCP and UDP

Guoqing Jiang <guoqing.jiang@canonical.com>
    arm64: dts: mediatek: mt8195: Remove suspend-breaking reset from pcie0

Genjian Zhang <zhanggenjian@kylinos.cn>
    null_blk: Fix the description of the cache_size module argument

Qianfeng Rong <rongqianfeng@vivo.com>
    pinctrl: renesas: Use int type to store negative error codes

Andy Yan <andyshrk@163.com>
    power: supply: cw2015: Fix a alignment coding style issue

Dan Carpenter <dan.carpenter@linaro.org>
    PM / devfreq: mtk-cci: Fix potential error pointer dereference in probe()

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ARM: dts: omap: am335x-cm-t335: Remove unused mcasp num-serializer property

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ARM: dts: ti: omap: omap3-devkit8000-lcd: Fix ti,keep-vref-on property to use correct boolean syntax in DTS

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ARM: dts: ti: omap: am335x-baltos: Fix ti,en-ck32k-xtal property in DTS to use correct boolean syntax

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: core: Clear power.must_resume in noirq suspend error path

Qianfeng Rong <rongqianfeng@vivo.com>
    block: use int to store blk_stack_limits() return value

Benjamin Berg <benjamin.berg@intel.com>
    selftests/nolibc: fix EXPECT_NZ macro

Qianfeng Rong <rongqianfeng@vivo.com>
    regulator: scmi: Use int type to store negative error codes

Janne Grunau <j@jannau.net>
    arm64: dts: apple: t8103-j457: Fix PCIe ethernet iommu-map

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

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Write back tail call counter for BPF_TRAMP_F_CALL_ORIG

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Write back tail call counter for BPF_PSEUDO_CALL

Fenglin Wu <fenglin.wu@oss.qualcomm.com>
    leds: flash: leds-qcom-flash: Update torch current clamp setting

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: renesas: porter: Fix CAN pin group

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

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/i10nm: Skip DIMM enumeration on a disabled memory controller

Stefan Metzmacher <metze@samba.org>
    smb: server: fix IRD/ORD negotiation with the client

Leo Yan <leo.yan@arm.com>
    perf: arm_spe: Prevent overflow in PERF_IDX2OFF()

Leo Yan <leo.yan@arm.com>
    coresight: trbe: Prevent overflow in PERF_IDX2OFF()

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix GLF_INVALIDATE_IN_PROGRESS flag clearing in do_xmote

Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
    selftests: arm64: Check fread return value in exec_target

Johannes Nixdorf <johannes@nixdorf.dev>
    seccomp: Fix a race with WAIT_KILLABLE_RECV if the tracer replies too fast

Geert Uytterhoeven <geert+renesas@glider.be>
    init: INITRAMFS_PRESERVE_MTIME should depend on BLK_DEV_INITRD

Jeff Layton <jlayton@kernel.org>
    filelock: add FL_RECLAIM to show_fl_flags() macro


-------------

Diffstat:

 Documentation/trace/histogram-design.rst           |   4 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/renesas/r8a7791-porter.dts       |   2 +-
 arch/arm/boot/dts/ti/omap/am335x-baltos.dtsi       |   2 +-
 arch/arm/boot/dts/ti/omap/am335x-cm-t335.dts       |   2 -
 .../dts/ti/omap/omap3-devkit8000-lcd-common.dtsi   |   2 +-
 arch/arm/mach-at91/pm_suspend.S                    |   4 +-
 arch/arm64/boot/dts/apple/t8103-j457.dts           |  12 +-
 arch/arm64/boot/dts/mediatek/mt6331.dtsi           |  10 +-
 .../boot/dts/mediatek/mt6795-sony-xperia-m5.dts    |   2 +-
 arch/arm64/boot/dts/mediatek/mt8195.dtsi           |   3 -
 arch/arm64/boot/dts/mediatek/mt8516-pumpkin.dts    |   2 +-
 arch/arm64/boot/dts/qcom/qcm2290.dtsi              |   1 +
 arch/arm64/boot/dts/renesas/rzg2lc-smarc.dtsi      |   5 +-
 arch/loongarch/kernel/relocate.c                   |   4 +
 arch/s390/net/bpf_jit_comp.c                       |  26 ++--
 arch/sparc/lib/M7memcpy.S                          |  20 +--
 arch/sparc/lib/Memcpy_utils.S                      |   9 ++
 arch/sparc/lib/NG4memcpy.S                         |   2 +-
 arch/sparc/lib/NGmemcpy.S                          |  29 +++--
 arch/sparc/lib/U1memcpy.S                          |  19 +--
 arch/sparc/lib/U3memcpy.S                          |   2 +-
 arch/x86/include/asm/segment.h                     |   8 +-
 block/blk-mq-sysfs.c                               |   6 +-
 block/blk-settings.c                               |   3 +-
 crypto/asymmetric_keys/x509_cert_parser.c          |  16 ++-
 drivers/acpi/acpica/aclocal.h                      |   2 +-
 drivers/acpi/nfit/core.c                           |   2 +-
 drivers/acpi/processor_idle.c                      |   3 +
 drivers/base/node.c                                |   4 +
 drivers/base/power/main.c                          |  14 ++-
 drivers/base/regmap/regmap.c                       |   2 +-
 drivers/block/nbd.c                                |   8 ++
 drivers/block/null_blk/main.c                      |   2 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |   3 +
 drivers/char/hw_random/Kconfig                     |   1 +
 drivers/char/hw_random/ks-sa-rng.c                 |   4 +
 drivers/cpufreq/scmi-cpufreq.c                     |  10 ++
 drivers/cpuidle/cpuidle-qcom-spm.c                 |   7 +-
 drivers/crypto/hisilicon/debugfs.c                 |   1 +
 drivers/crypto/hisilicon/hpre/hpre_main.c          |   3 +-
 drivers/crypto/hisilicon/qm.c                      |   7 +-
 drivers/crypto/hisilicon/sec2/sec_main.c           |  80 ++++++------
 drivers/crypto/hisilicon/zip/zip_main.c            |  17 +--
 .../crypto/intel/keembay/keembay-ocs-hcu-core.c    |   5 +-
 drivers/devfreq/mtk-cci-devfreq.c                  |   3 +-
 drivers/edac/i10nm_base.c                          |  14 +++
 drivers/firmware/meson/Kconfig                     |   2 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c              |  29 ++++-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |   2 +-
 .../display/dc/dml/dcn32/display_rq_dlg_calc_32.c  |   1 -
 drivers/gpu/drm/amd/pm/amdgpu_dpm_internal.c       |   7 ++
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |  92 +++++++++-----
 drivers/gpu/drm/bridge/Kconfig                     |   1 +
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c    |   2 +-
 drivers/gpu/drm/panel/panel-novatek-nt35560.c      |   2 +-
 drivers/gpu/drm/radeon/r600_cs.c                   |   4 +-
 drivers/hwmon/mlxreg-fan.c                         |  24 ++--
 drivers/hwtracing/coresight/coresight-core.c       |   5 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c |  31 +++--
 drivers/hwtracing/coresight/coresight-etm4x.h      |   6 +-
 drivers/hwtracing/coresight/coresight-trbe.c       |   9 +-
 drivers/i2c/busses/i2c-designware-platdrv.c        |   5 +-
 drivers/i2c/busses/i2c-mt65xx.c                    |  17 +--
 drivers/i3c/master/svc-i3c-master.c                |  31 ++++-
 drivers/iio/inkern.c                               |  30 ++---
 drivers/infiniband/core/addr.c                     |  10 +-
 drivers/infiniband/core/cm.c                       |   4 +-
 drivers/infiniband/core/sa_query.c                 |   6 +-
 drivers/infiniband/hw/mlx5/main.c                  |  19 ++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   1 +
 drivers/infiniband/sw/rxe/rxe_task.c               |   8 +-
 drivers/infiniband/sw/siw/siw_verbs.c              |  25 ++--
 drivers/input/misc/uinput.c                        |   1 +
 drivers/input/touchscreen/atmel_mxt_ts.c           |   2 +-
 drivers/leds/flash/leds-qcom-flash.c               |  62 ++++++----
 drivers/md/dm-core.h                               |   1 +
 drivers/md/dm.c                                    |  13 +-
 drivers/media/i2c/rj54n1cb0c.c                     |   9 +-
 drivers/media/pci/zoran/zoran.h                    |   6 -
 drivers/media/pci/zoran/zoran_driver.c             |   3 +-
 .../media/platform/st/sti/delta/delta-mjpeg-dec.c  |  20 +--
 drivers/mfd/rz-mtu3.c                              |   2 +-
 drivers/mfd/vexpress-sysreg.c                      |   6 +-
 drivers/misc/fastrpc.c                             |  62 ++++++----
 drivers/misc/genwqe/card_ddcb.c                    |   2 +-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |   4 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |   5 +-
 drivers/net/ethernet/dlink/dl2k.c                  |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   6 +-
 .../ethernet/mellanox/mlx5/core/en/port_buffer.h   |  12 --
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  17 +--
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  24 ++++
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   7 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   2 +-
 drivers/net/usb/asix_devices.c                     |  29 +++++
 drivers/net/usb/rtl8150.c                          |   2 -
 drivers/net/wireless/ath/ath10k/wmi.c              |  39 +++---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   7 +-
 drivers/net/wireless/mediatek/mt76/mt7603/soc.c    |   2 +-
 drivers/net/wireless/realtek/rtw89/ser.c           |   3 +-
 drivers/nvme/target/fc.c                           |  19 ++-
 drivers/pci/controller/dwc/pcie-tegra194.c         |   4 +-
 drivers/pci/controller/pci-tegra.c                 |   2 +-
 drivers/perf/arm_spe_pmu.c                         |   3 +-
 drivers/phy/rockchip/phy-rockchip-naneng-combphy.c |  12 ++
 drivers/pinctrl/meson/pinctrl-meson-gxl.c          |  10 ++
 drivers/pinctrl/pinmux.c                           |   2 +-
 drivers/pinctrl/renesas/pinctrl.c                  |   3 +-
 drivers/power/supply/cw2015_battery.c              |   3 +-
 drivers/pps/kapi.c                                 |   5 +-
 drivers/pps/pps.c                                  |   5 +-
 drivers/pwm/pwm-tiehrpwm.c                         |   4 +-
 drivers/regulator/scmi-regulator.c                 |   3 +-
 drivers/remoteproc/pru_rproc.c                     |   3 +-
 drivers/remoteproc/qcom_q6v5.c                     |   3 -
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |   8 +-
 drivers/scsi/myrs.c                                |   8 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |   9 +-
 drivers/scsi/qla2xxx/qla_edif.c                    |   4 +-
 drivers/scsi/qla2xxx/qla_init.c                    |   4 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   2 +-
 drivers/soc/qcom/rpmh-rsc.c                        |   7 +-
 drivers/thermal/qcom/Kconfig                       |   3 +-
 drivers/thermal/qcom/lmh.c                         |   2 +
 drivers/tty/n_gsm.c                                |  25 +++-
 drivers/tty/serial/max310x.c                       |   2 +
 drivers/uio/uio_hv_generic.c                       |   7 +-
 drivers/usb/cdns3/cdnsp-pci.c                      |   5 +-
 drivers/usb/gadget/configfs.c                      |   2 +
 drivers/usb/host/max3421-hcd.c                     |   2 +-
 drivers/usb/host/xhci-ring.c                       |  11 +-
 drivers/usb/misc/Kconfig                           |   1 +
 drivers/usb/misc/qcom_eud.c                        |  33 +++--
 drivers/usb/phy/phy-twl6030-usb.c                  |   3 +-
 drivers/usb/typec/tipd/core.c                      |  24 ++--
 drivers/usb/usbip/vhci_hcd.c                       |  22 ++++
 drivers/vfio/pci/pds/dirty.c                       |   2 +-
 drivers/vhost/vringh.c                             |  14 ++-
 drivers/watchdog/mpc8xxx_wdt.c                     |   2 +
 fs/ext4/ext4.h                                     |  10 ++
 fs/ext4/file.c                                     |   2 +-
 fs/ext4/inode.c                                    |   2 +-
 fs/ext4/orphan.c                                   |   6 +-
 fs/ext4/super.c                                    |   4 +-
 fs/f2fs/data.c                                     |   9 +-
 fs/f2fs/f2fs.h                                     |   4 +-
 fs/f2fs/file.c                                     |  49 ++++----
 fs/gfs2/glock.c                                    |   2 -
 fs/nfs/nfs4proc.c                                  |   2 +-
 fs/ntfs3/index.c                                   |  10 ++
 fs/ntfs3/run.c                                     |  12 +-
 fs/ocfs2/stack_user.c                              |   1 +
 fs/smb/client/smb2ops.c                            |  17 +--
 fs/smb/server/smb2pdu.c                            |   3 +-
 fs/smb/server/transport_rdma.c                     |  97 +++++++++++++--
 fs/squashfs/inode.c                                |   7 ++
 fs/squashfs/squashfs_fs_i.h                        |   2 +-
 fs/udf/inode.c                                     |   3 +
 include/asm-generic/vmlinux.lds.h                  |   1 +
 include/linux/bpf.h                                |   1 +
 include/linux/once.h                               |   4 +-
 include/trace/events/filelock.h                    |   3 +-
 init/Kconfig                                       |   1 +
 kernel/bpf/core.c                                  |   5 +
 kernel/bpf/verifier.c                              |   4 +-
 kernel/seccomp.c                                   |  12 +-
 kernel/smp.c                                       |  11 +-
 kernel/trace/bpf_trace.c                           |   9 +-
 mm/hugetlb.c                                       |   2 +
 net/bluetooth/hci_sync.c                           |  10 +-
 net/bluetooth/iso.c                                |   9 +-
 net/bluetooth/mgmt.c                               |  10 +-
 net/core/filter.c                                  |  16 ++-
 net/ipv4/ping.c                                    |  14 ++-
 net/ipv4/tcp.c                                     |   9 +-
 net/mac80211/rx.c                                  |  28 ++++-
 net/netfilter/ipset/ip_set_hash_gen.h              |   8 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |   4 +-
 net/netfilter/ipvs/ip_vs_core.c                    |  11 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   6 +-
 net/netfilter/ipvs/ip_vs_est.c                     |  16 +--
 net/netfilter/ipvs/ip_vs_ftp.c                     |   4 +-
 net/nfc/nci/ntf.c                                  | 135 +++++++++++++++------
 net/sunrpc/auth_gss/svcauth_gss.c                  |   2 +-
 sound/pci/lx6464es/lx_core.c                       |   4 +-
 sound/soc/codecs/wcd934x.c                         |  17 ++-
 sound/soc/intel/boards/bytcht_es8316.c             |  20 ++-
 sound/soc/intel/boards/bytcr_rt5640.c              |   7 +-
 sound/soc/intel/boards/bytcr_rt5651.c              |  26 +++-
 sound/soc/sof/ipc3-topology.c                      |  10 +-
 tools/include/nolibc/std.h                         |   2 +-
 tools/lib/bpf/libbpf.c                             |  10 ++
 tools/testing/nvdimm/test/ndtest.c                 |  13 +-
 tools/testing/selftests/arm64/pauth/exec_target.c  |   7 +-
 .../selftests/bpf/progs/test_tcpnotify_kern.c      |   1 -
 tools/testing/selftests/bpf/test_tcpnotify_user.c  |  20 +--
 tools/testing/selftests/nolibc/nolibc-test.c       |   4 +-
 tools/testing/selftests/watchdog/watchdog-test.c   |   6 +
 199 files changed, 1405 insertions(+), 721 deletions(-)


