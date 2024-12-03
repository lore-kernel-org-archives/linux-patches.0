Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF92D1F8924;
	Tue,  3 Dec 2024 15:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240149; cv=none; b=CjzGQ6ZVgpBfZWOfhub0Hi9K8eEqaEMRQj6LZEBoOK4XOocusNUqRLsLkMR3qXSdQ33U3DNz0eu6dp8mwpqfE6MzvYWVTWRw3QQB00TqJnbiKRc6XVPBNijbd3OBTaYV3/xzsi4uXklyp+3gAd3Vbdi6zhTqm6tbnLEd/Hi29eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240149; c=relaxed/simple;
	bh=6l1rI1IPeiOunE89pMET1KlnAix7gcffoP6CBCW3bVw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kus/t5Fy35eX/6UyDr3OWwCN2DX9EKeKOlt+HEwiClG82h0beEhqFjcxjy8f9osaO8FxMpT/ja/M6Uqawb02PkPF8jNGdTA90dmUy8w7QDYk3DdDMUo/R4f6g3kdFYAILJnd7tKdbEDSqMtSrVppMihm+OQ2jBeiLKEhpOXmazE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B0fbO4uO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B0fbO4uO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E8DC4CECF;
	Tue,  3 Dec 2024 15:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240148;
	bh=6l1rI1IPeiOunE89pMET1KlnAix7gcffoP6CBCW3bVw=;
	h=From:To:Cc:Subject:Date:From;
	b=B0fbO4uOhHQ3ha3SEwI0G5jsg4L2ttvbKMoWXhSS3BVzWXnLOI90ikmoynVD2U5/s
	 fgqQZ9VbxhFLtaF8bzMWbtAV1n+bO7tjI4+Ph01LOMGw/40NhrlBtLcrApi1cfRAmN
	 xkBNrJa3j41qsd+yqVaGw910ZNKG2a1XChqozcjQ=
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
Subject: [PATCH 6.12 000/826] 6.12.2-rc1 review
Date: Tue,  3 Dec 2024 15:35:27 +0100
Message-ID: <20241203144743.428732212@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.2-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.2-rc1
X-KernelTest-Deadline: 2024-12-05T14:48+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.2 release.
There are 826 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 05 Dec 2024 14:45:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.2-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.2-rc1

Ming Lei <ming.lei@redhat.com>
    block: don't verify IO lock for freeze/unfreeze in elevator_init_mq()

Ming Lei <ming.lei@redhat.com>
    block: always verify unfreeze lock on the owner task

Patryk Wlazlyn <patryk.wlazlyn@linux.intel.com>
    tools/power turbostat: Fix child's argument forwarding

Zhang Rui <rui.zhang@intel.com>
    tools/power turbostat: Fix trailing '\n' parsing

Dan Carpenter <dan.carpenter@linaro.org>
    sh: intc: Fix use-after-free bug in register_intc_controller()

Zhang Xianwei <zhang.xianwei8@zte.com.cn>
    brd: decrease the number of allocated pages which discarded

Yu Kuai <yukuai3@huawei.com>
    block, bfq: fix bfqq uaf in bfq_limit_depth()

Benjamin Coddington <bcodding@redhat.com>
    nfs/blocklayout: Limit repeat device registration on failure

Benjamin Coddington <bcodding@redhat.com>
    nfs/blocklayout: Don't attempt unregister for invalid block device

Liu Jian <liujian56@huawei.com>
    sunrpc: fix one UAF issue caused by sunrpc kernel tcp socket

Benjamin Coddington <bcodding@redhat.com>
    SUNRPC: timeout and cancel TLS handshake with -ETIMEDOUT

Liu Jian <liujian56@huawei.com>
    sunrpc: clear XPRT_SOCK_UPD_TIMEOUT when reset transport

Li Lingfeng <lilingfeng3@huawei.com>
    nfs: ignore SB_RDONLY when mounting nfs

Dan Carpenter <dan.carpenter@linaro.org>
    cifs: unlock on error in smb3_reconfigure()

Shyam Prasad N <sprasad@microsoft.com>
    cifs: during remount, make sure passwords are in sync

Masahiro Yamada <masahiroy@kernel.org>
    modpost: remove incorrect code in do_eisa_entry()

John Garry <john.g.garry@oracle.com>
    block: Don't allow an atomic write be truncated in blkdev_write_iter()

Paul Aurich <paul@darkrain42.org>
    smb: Initialize cfid->tcon before performing network ops

Matt Fleming <mfleming@cloudflare.com>
    kbuild: deb-pkg: Don't fail if modules.order is missing

Masahiro Yamada <masahiroy@kernel.org>
    Rename .data.once to .data..once to fix resetting WARN*_ONCE

Masahiro Yamada <masahiroy@kernel.org>
    Rename .data.unlikely to .data..unlikely

Maxime Chevallier <maxime.chevallier@bootlin.com>
    rtc: ab-eoz9: don't fail temperature reads on undervoltage notification

Pali Rohár <pali@kernel.org>
    cifs: Fix parsing reparse point with native symlink in SMB1 non-UNICODE session

Pali Rohár <pali@kernel.org>
    cifs: Fix parsing native symlinks relative to the export

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    x86/Documentation: Update algo in init_size description of boot protocol

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: disable directory caching when dir_cache_timeout is zero

Namhyung Kim <namhyung@kernel.org>
    perf/arm-cmn: Ensure port and device id bits are set properly

Chun-Tse Shao <ctshao@google.com>
    perf/arm-smmuv3: Fix lockdep assert in ->event_init()

Alex Zenla <alex@edera.dev>
    9p/xen: fix release of IRQ

Alex Zenla <alex@edera.dev>
    9p/xen: fix init sequence

Nilay Shroff <nilay@linux.ibm.com>
    nvme-fabrics: fix kernel crash while shutting down controller

Christoph Hellwig <hch@lst.de>
    block: return unsigned int from bdev_io_min

Yu Kuai <yukuai3@huawei.com>
    block: fix uaf for flush rq while iterating tags

Ming Lei <ming.lei@redhat.com>
    block: model freeze & enter queue as lock for supporting lockdep

Ming Lei <ming.lei@redhat.com>
    blk-mq: add non_owner variant of start_freeze/unfreeze queue APIs

Breno Leitao <leitao@debian.org>
    nvme/multipath: Fix RCU list traversal to use SRCU primitive

Trond Myklebust <trond.myklebust@hammerspace.com>
    Revert "nfs: don't reuse partially completed requests in nfs_lock_and_join_requests"

Wolfram Sang <wsa+renesas@sang-engineering.com>
    rtc: rzn1: fix BCD to rtc_time conversion errors

Mirsad Todorovac <mtodorovac69@gmail.com>
    net/9p/usbg: fix handling of the failed kzalloc() memory allocation

ZhangPeng <zhangpeng362@huawei.com>
    hostfs: Fix the NULL vs IS_ERR() bug for __filemap_get_folio()

Qingfang Deng <qingfang.deng@siflower.com.cn>
    jffs2: fix use of uninitialized variable

Waqar Hameed <waqar.hameed@axis.com>
    ubifs: authentication: Fix use-after-free in ubifs_tnc_end_commit

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: Fix duplicate slab cache names while attaching

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Correct the total block count by deducting journal reservation

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: wl: Schedule fm_work if wear-leveling pool is empty

Yongliang Gao <leonylgao@tencent.com>
    rtc: check if __rtc_read_time was successful in rtc_timer_do_work()

Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
    rtc: abx80x: Fix WDT bit position of the status register

Jinjie Ruan <ruanjinjie@huawei.com>
    rtc: st-lpc: Use IRQF_NO_AUTOEN flag in request_irq()

NeilBrown <neilb@suse.de>
    nfs/localio: must clear res.replen in nfs_local_read_done

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.0: Fix a use-after-free problem in the asynchronous open()

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Always dump trace for specified task in show_stack

Tiwei Bie <tiwei.btw@antgroup.com>
    um: ubd: Initialize ubd's disk pointer in ubd_add

Christoph Hellwig <hch@lst.de>
    kfifo: don't include dma-mapping.h in kfifo.h

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix the return value of elf_core_copy_task_fpregs

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix potential integer overflow during physmem setup

Yang Erkun <yangerkun@huawei.com>
    SUNRPC: make sure cache entry active before cache_show

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent a potential integer overflow

Yuan Can <yuancan@huawei.com>
    Input: cs40l50 - fix wrong usage of INIT_WORK()

Ma Wupeng <mawupeng1@huawei.com>
    ipc: fix memleak if msg_init_ns failed in create_ipc_ns

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on node blkaddr in truncate_node()

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    lib: string_helpers: silence snprintf() output truncation warning

Ming Lei <ming.lei@redhat.com>
    ublk: fix error code for unsupported command

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    counter: stm32-timer-cnt: fix device_node handling in probe_encoder()

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    staging: vchiq_arm: Fix missing refcount decrement in error path for fw_node

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix looping of queued SG entries

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix checking for number of TRBs left

Selvarasu Ganesan <selvarasu.g@samsung.com>
    usb: dwc3: gadget: Add missing check for single port RAM in TxFIFO resizing logic

Hubert Wiśniewski <hubert.wisniewski.25632@gmail.com>
    usb: musb: Fix hardware lockup on first Rx endpoint request

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: ep0: Don't clear ep0 DWC3_EP_TRANSFER_STARTED

Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
    usb: misc: ljca: move usb_autopm_put_interface() after wait for response

Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
    usb: misc: ljca: set small runtime autosuspend delay

Paul Aurich <paul@darkrain42.org>
    smb: During unmount, ensure all cached dir instances drop their dentry

Paul Aurich <paul@darkrain42.org>
    smb: prevent use-after-free due to open_cached_dir error paths

Paul Aurich <paul@darkrain42.org>
    smb: Don't leak cfid when reconnect races with open_cached_dir

Paulo Alcantara <pc@manguebit.com>
    smb: client: handle max length for SMB symlinks

Steve French <stfrench@microsoft.com>
    smb3: request handle caching when caching directories

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix use-after-free of signing key

Ralph Boehme <slow@samba.org>
    fs/smb/client: implement chmod() for SMB3 POSIX Extensions

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Apply quirk for Medion E15433

Dirk Su <dirk.su@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs don't work for EliteBook X G1i

Dinesh Kumar <desikumar81@gmail.com>
    ALSA: hda/realtek: Fix Internal Speaker and Mic boost of Infinix Y4 Max

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Set PCBeep to default value for ALC274

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Enable speaker pins for Medion E15443 platform

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Update ALC225 depop procedure

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Add sanity NULL check for the default mmap fault handler

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Fix evaluation of MIDI 1.0 FB info

Takashi Iwai <tiwai@suse.de>
    ALSA: rawmidi: Fix kvfree() call in spinlock

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Flush patch buffer mapping after application

Borislav Petkov (AMD) <bp@alien8.de>
    x86/mm: Carve out INVLPG inline asm for use by others

Hans Verkuil <hverkuil@xs4all.nl>
    media: v4l2-core: v4l2-dv-timings: check cvt/gtf result

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    soc: fsl: rcpm: fix missing of_node_put() in copy_ippdexpcr1_setting()

Herve Codina <herve.codina@bootlin.com>
    soc: fsl: cpm1: qmc: Set the ret error code on platform_get_irq() failure

Joe Damato <jdamato@fastly.com>
    netdev-genl: Hold rcu_read_lock in napi_get

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8186-corsola-voltorb: Merge speaker codec nodes

Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
    media: intel/ipu6: do not handle interrupts when device is disabled

Qiu-ji Chen <chenqiuji666@gmail.com>
    media: wl128x: Fix atomicity violation in fmc_send_cmd()

Peter Große <pegro@friiks.de>
    i40e: Fix handling changed priv flags

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Interpret tilt data from Intuos Pro BT as signed values

Ziwei Xiao <ziweixiao@google.com>
    gve: Flow steering trigger reset only for timeout error

Bart Van Assche <bvanassche@acm.org>
    blk-mq: Make blk_mq_quiesce_tagset() hold the tag list mutex less long

Muchun Song <muchun.song@linux.dev>
    block: fix ordering between checking BLK_MQ_S_STOPPED request adding

Muchun Song <muchun.song@linux.dev>
    block: fix ordering between checking QUEUE_FLAG_QUIESCED request adding

Muchun Song <muchun.song@linux.dev>
    block: fix missing dispatching request when queue is started or unquiesced

Will Deacon <will@kernel.org>
    arm64: tls: Fix context-switching of tpidrro_el0 when kpti is enabled

Ming Lei <ming.lei@redhat.com>
    ublk: fix ublk_ch_mmap() for 64K page size

Zicheng Qu <quzicheng@huawei.com>
    iio: gts: Fix uninitialized symbol 'ret'

Huacai Chen <chenhuacai@kernel.org>
    sh: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK

Tiwei Bie <tiwei.btw@antgroup.com>
    um: vector: Do not use drvdata in release

Damien Le Moal <dlemoal@kernel.org>
    block: Prevent potential deadlock in blk_revalidate_disk_zones()

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    mtd: ubi: fix unreleased fwnode_handle in find_volume_fwnode()

Zach Wade <zachwade.k@gmail.com>
    Revert "block, bfq: merge bfq_release_process_ref() into bfq_put_cooperator()"

Arnd Bergmann <arnd@arndb.de>
    serial: amba-pl011: fix build regression

Kartik Rajput <kkartik@nvidia.com>
    serial: amba-pl011: Fix RX stall when DMA is used

Bin Liu <b-liu@ti.com>
    serial: 8250: omap: Move pm_runtime_get_sync

Filip Brozovic <fbrozovic@gmail.com>
    serial: 8250_fintek: Add support for F81216E

Michal Simek <michal.simek@amd.com>
    dt-bindings: serial: rs485: Fix rs485-rts-delay property

Tiwei Bie <tiwei.btw@antgroup.com>
    um: net: Do not use drvdata in release

Tiwei Bie <tiwei.btw@antgroup.com>
    um: ubd: Do not use drvdata in release

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: wl: Put source PEB into correct list if trying locking LEB failed

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    x86/CPU/AMD: Terminate the erratum_1386_microcode array

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    irqchip/irq-mvebu-sei: Move misplaced select() callback to SEI CP domain

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    platform/chrome: cros_ec_typec: fix missing fwnode reference decrement

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix NULL ptr deref in crypto_aead_setkey()

Yunseong Kim <yskelg@gmail.com>
    ksmbd: fix use-after-free in SMB request handling

Jesse Taube <jesse@rivosinc.com>
    RISC-V: Check scalar unaligned access on all CPUs

Jesse Taube <jesse@rivosinc.com>
    RISC-V: Scalar unaligned access emulated on hotplug CPUs

Josh Poimboeuf <jpoimboe@kernel.org>
    parisc/ftrace: Fix function graph tracing disablement

Meetakshi Setiya <msetiya@microsoft.com>
    cifs: support mounting with alternate password to allow password rotation

Jinjie Ruan <ruanjinjie@huawei.com>
    cpufreq: mediatek-hw: Fix wrong return value in mtk_cpufreq_get_cpu_power()

Cheng Ming Lin <chengminglin@mxic.com.tw>
    mtd: spi-nor: core: replace dummy buswidth from addr to data

Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
    spi: Fix acpi deferred irq probe

Jeongjun Park <aha310510@gmail.com>
    netfilter: ipset: add missing range check in bitmap_ip_uadt

Sai Kumar Cholleti <skmr537@gmail.com>
    gpio: exar: set value when external pull-up or pull-down is present

Mikulas Patocka <mpatocka@redhat.com>
    blk-settings: round down io_opt to physical_block_size

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: check for overflows in io_pin_pages

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix corner case forgetting to vunmap

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "serial: sh-sci: Clean sci_ports[0] after at earlycon exit"

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Clean sci_ports[0] after at earlycon exit

Michal Vrastil <michal.vrastil@hidglobal.com>
    Revert "usb: gadget: composite: fix OS descriptors w_value logic"

Jaegeuk Kim <jaegeuk@kernel.org>
    Revert "f2fs: remove unreachable lazytime mount option parsing"

Christian Brauner <brauner@kernel.org>
    Revert "fs: don't block i_writecount during exec"

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    wifi: brcmfmac: release 'root' node in all execution paths

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    wifi: ath12k: fix crash when unbinding

Aleksei Vetrov <vvvvvv@google.com>
    wifi: nl80211: fix bounds checker error in nl80211_parse_sched_scan

Guilherme G. Piccoli <gpiccoli@igalia.com>
    wifi: rtlwifi: Drastically reduce the attempts to read efuse in case of failures

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    wifi: ath12k: fix warning when unbinding

Andreas Kemnade <andreas@kemnade.info>
    ARM: dts: omap36xx: declare 1GHz OPP as turbo again

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Avoid queuing redundant Stop Endpoint commands

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Fix TD invalidation under pending Set TR Dequeue

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Limit Stop Endpoint retries

Andrej Shadura <andrew.shadura@collabora.co.uk>
    Bluetooth: Fix type of len in rfcomm_sock_getsockopt{,_old}()

Kuangyi Chiang <ki.chiang65@gmail.com>
    xhci: Don't issue Reset Device command to Etron xHCI host

Kuangyi Chiang <ki.chiang65@gmail.com>
    xhci: Don't perform Soft Retry for Etron xHCI host

Kuangyi Chiang <ki.chiang65@gmail.com>
    xhci: Combine two if statements for Etron xHCI host

Kuangyi Chiang <ki.chiang65@gmail.com>
    xhci: Fix control transfer error on Etron xHCI host

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix out-of-bounds access of directory entries

Namjae Jeon <linkinjeon@kernel.org>
    exfat: fix uninit-value in __exfat_get_dentry_set

Angelo Dureghello <adureghello@baylibre.com>
    dt-bindings: iio: dac: ad3552r: fix maximum spi speed

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: pinctrl: samsung: Fix interrupt constraint for variants with fallbacks

Johan Hovold <johan+linaro@kernel.org>
    pinctrl: qcom: spmi: fix debugfs drive strength

Christian Brauner <brauner@kernel.org>
    fcntl: make F_DUPFD_QUERY associative

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    tools/nolibc: s390: include std.h

Ahmed Ehab <bottaawesome633@gmail.com>
    locking/lockdep: Avoid creating new name string literals in lockdep_set_subclass()

Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
    tty: ldsic: fix tty_ldisc_autoload sysctl's proc_handler

Angelo Dureghello <adureghello@baylibre.com>
    iio: dac: adi-axi-dac: fix wrong register bitfield

Jinjie Ruan <ruanjinjie@huawei.com>
    apparmor: test: Fix memory leak for aa_unpack_strdup()

Jann Horn <jannh@google.com>
    comedi: Flush partial mappings in error case

Jann Horn <jannh@google.com>
    fsnotify: Fix ordering of iput() and watched_objects decrement

Amir Goldstein <amir73il@gmail.com>
    fsnotify: fix sending inotify event with unexpected filename

Gustavo A. R. Silva <gustavoars@kernel.org>
    clk: clk-loongson2: Fix potential buffer overflow in flexible-array member access

Gustavo A. R. Silva <gustavoars@kernel.org>
    clk: clk-loongson2: Fix memory corruption bug in struct loongson2_clk_provider

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Explicitly specify code model in Makefile

Lukas Wunner <lukas@wunner.de>
    PCI: Fix use-after-free of slot->bus on hot remove

Jan Hendrik Farr <kernel@jfarr.cc>
    Compiler Attributes: disable __counted_by for clang < 19.1.3

Kunkun Jiang <jiangkunkun@huawei.com>
    KVM: arm64: vgic-its: Clear DTE when MAPD unmaps a device

Jing Zhang <jingzhangos@google.com>
    KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*

Raghavendra Rao Ananta <rananta@google.com>
    KVM: arm64: Get rid of userspace_irqchip_in_use

Kunkun Jiang <jiangkunkun@huawei.com>
    KVM: arm64: vgic-its: Clear ITE when DISCARD frees an ITE

Oliver Upton <oliver.upton@linux.dev>
    KVM: arm64: Don't retire aborted MMIO instruction

Sean Christopherson <seanjc@google.com>
    Revert "KVM: VMX: Move LOAD_IA32_PERF_GLOBAL_CTRL errata handling out of setup_vmcs_config()"

Raghavendra Rao Ananta <rananta@google.com>
    KVM: arm64: Ignore PMCNTENSET_EL0 while checking for overflow status

Marc Zyngier <maz@kernel.org>
    KVM: arm64: vgic-v3: Sanitise guest writes to GICR_INVLPIR

Gautam Menghani <gautam@linux.ibm.com>
    powerpc/pseries: Fix KVM guest detection for disabling hardlockup detector

Sean Christopherson <seanjc@google.com>
    KVM: x86: Break CONFIG_KVM_X86's direct dependency on KVM_INTEL || KVM_AMD

Arnd Bergmann <arnd@arndb.de>
    KVM: x86: add back X86_LOCAL_APIC dependency

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Skip the "try unsync" path iff the old SPTE was a leaf SPTE

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: switch hugepage recovery thread to vhost_task

Eric Biggers <ebiggers@google.com>
    crypto: x86/aegis128 - access 32-bit arguments as 32-bit

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel/pt: Fix buffer full but size is 0 case

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    ASoC: da7213: Populate max_register to regmap_config

Qiu-ji Chen <chenqiuji666@gmail.com>
    ASoC: codecs: Fix atomicity violation in snd_soc_component_get_drvdata()

Ilya Zverev <ilya@zverev.info>
    ASoC: amd: yc: Add a quirk for microfone on Lenovo ThinkPad P14s Gen 5 21MES00B00

Artem Sadovnikov <ancowi69@gmail.com>
    jfs: xattr: check invalid xattr size more strictly

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    docs: media: update location of the media patches

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    MAINTAINERS: update location of media main tree

Theodore Ts'o <tytso@mit.edu>
    ext4: fix FS_IOC_GETFSMAP handling

Jeongjun Park <aha310510@gmail.com>
    ext4: supress data-race warnings in ext4_free_inodes_{count,set}()

Darrick J. Wong <djwong@kernel.org>
    xfs: fix simplify extent lookup in xfs_can_free_eofblocks

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    usb: typec: ucsi: glink: fix off-by-one in connector_status

Vitalii Mordan <mordan@ispras.ru>
    usb: ehci-spear: fix call balance of sehci clk handling routines

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix out of bounds reads when finding clock sources

Benoît Sevens <bsevens@google.com>
    ALSA: usb-audio: Fix potential out-of-bound accesses for Extigy and Mbox devices

Qiu-ji Chen <chenqiuji666@gmail.com>
    xen: Fix the issue of resource not being properly released in xenbus_dev_probe()

Jakub Kicinski <kuba@kernel.org>
    net_sched: sch_fq: don't follow the fast path if Tx is behind now

Xiuhong Wang <xiuhong.wang@unisoc.com>
    f2fs: fix fiemap failure issue when page size is 16KB

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Fix potential double remove of hotplug slot

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    ASoC: mediatek: Check num_codecs is not zero to avoid panic during probe

Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
    ASoC: amd: yc: Fix for enabling DMIC on acp6x via _DSD entry

Zichen Xie <zichenxie0106@gmail.com>
    ALSA: core: Fix possible NULL dereference caused by kunit_kzalloc()

chao liu <liuzgyid@outlook.com>
    apparmor: fix 'Do simple duplicate message elimination'

Nirmoy Das <nirmoy.das@intel.com>
    drm/xe/ufence: Wake up waiters after setting ufence->signalled

Charles Han <hanchunchao@inspur.com>
    ASoC: imx-audmix: Add NULL check in imx_audmix_probe

Zicheng Qu <quzicheng@huawei.com>
    drm/amd/display: Fix null check for pipe_ctx->plane_state in hwss_setup_dpp

Zicheng Qu <quzicheng@huawei.com>
    drm/amd/display: Fix null check for pipe_ctx->plane_state in dcn20_program_pipe

Steven 'Steve' Kendall <skend@chromium.org>
    drm/radeon: Fix spurious unplug event on radeon HDMI

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Update ALC256 depop procedure

Gaosheng Cui <cuigaosheng1@huawei.com>
    firmware_loader: Fix possible resource leak in fw_log_firmware_info()

Dan Carpenter <dan.carpenter@linaro.org>
    usb: typec: fix potential array underflow in ucsi_ccg_sync_control()

Carl Vanderlip <quic_carlv@quicinc.com>
    bus: mhi: host: Switch trace_mhi_gen_tre fields to native endian

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    counter: ti-ecap-capture: Add check for clk_enable()

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    counter: stm32-timer-cnt: Add check for clk_enable()

Charles Han <hanchunchao@inspur.com>
    phy: realtek: usb: fix NULL deref in rtk_usb3phy_probe

Charles Han <hanchunchao@inspur.com>
    phy: realtek: usb: fix NULL deref in rtk_usb2phy_probe

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: accel: adxl380: fix raw sample read

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: adc: pac1921: Check for error code from devm_mutex_init() call

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: adc: ad4000: Check for error code from devm_mutex_init() call

David Lechner <dlechner@baylibre.com>
    iio: adc: ad4000: fix reading unsigned data

Yang Yingliang <yangyingliang@huawei.com>
    iio: backend: fix wrong pointer passed to IS_ERR()

Raviteja Laggyshetty <quic_rlaggysh@quicinc.com>
    interconnect: qcom: icc-rpmh: probe defer incase of missing QoS clock dependency

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: gadget: uvc: wake pump everytime we update the free list

Keita Morisaki <keyz@google.com>
    devres: Fix page faults when tracing devres from unloaded modules

Jinjie Ruan <ruanjinjie@huawei.com>
    misc: apds990x: Fix missing pm_runtime_disable()

Edward Adam Davis <eadavis@qq.com>
    USB: chaoskey: Fix possible deadlock chaoskey_list_lock

Oliver Neukum <oneukum@suse.com>
    USB: chaoskey: fail open after removal

Oliver Neukum <oneukum@suse.com>
    usb: yurex: make waiting on yurex_write interruptible

Jeongjun Park <aha310510@gmail.com>
    usb: using mutex lock and supporting O_NONBLOCK flag in iowarrior_read()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio: light: al3010: Fix an error handling path in al3010_probe()

Paolo Abeni <pabeni@redhat.com>
    ipmr: fix tables suspicious RCU usage

Paolo Abeni <pabeni@redhat.com>
    ip6mr: fix tables suspicious RCU usage

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix use-after-free of nreq in reqsk_timer_handler().

Michal Luczaj <mhal@rbox.co>
    rxrpc: Improve setsockopt() handling of malformed user input

Michal Luczaj <mhal@rbox.co>
    llc: Improve setsockopt() handling of malformed user input

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix possible deadlocks

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix slab-use-after-free Read in set_powered_sync

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Unregister PTP during PCI shutdown and suspend

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Refactor bnxt_ptp_init()

Shravya KN <shravya.k-n@broadcom.com>
    bnxt_en: Fix receive ring space parameters when XDP is active

Somnath Kotur <somnath.kotur@broadcom.com>
    bnxt_en: Fix queue start to update vnic RSS table

Shravya KN <shravya.k-n@broadcom.com>
    bnxt_en: Set backplane link modes correctly for ethtool

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    bnxt_en: Reserve rings after PCIe AER recovery if NIC interface is down

Eric Dumazet <edumazet@google.com>
    net: hsr: fix hsr_init_sk() vs network/transport headers.

Csókás, Bence <csokas.bence@prolan.hu>
    spi: atmel-quadspi: Fix register name in verbose logging function

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-af: Quiesce traffic before NIX block reset

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-af: RPM: fix stale FCFEC counters

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-af: RPM: fix stale RSFEC counters

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-af: RPM: Fix low network performance

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-af: RPM: Fix mismatch in lmac type

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: dwmac-socfpga: Set RX watchdog interrupt as broken

Vitalii Mordan <mordan@ispras.ru>
    marvell: pxa168_eth: fix call balance of pep->clk handling routines

Rosen Penev <rosenp@gmail.com>
    net: mdio-ipq4019: add missing error check

Hangbin Liu <liuhangbin@gmail.com>
    net/ipv6: delete temporary address if mngtmpaddr is removed or unmanaged

Justin Lai <justinlai0215@realtek.com>
    rtase: Corrects error handling of the rtase_check_mac_version_valid()

Justin Lai <justinlai0215@realtek.com>
    rtase: Correct the speed for RTL907XD-V1

Justin Lai <justinlai0215@realtek.com>
    rtase: Refactor the rtase_check_mac_version_valid() function

Sidraya Jayagond <sidraya@linux.ibm.com>
    s390/iucv: MSG_PEEK causes memory leak in iucv_sock_destruct()

James Chapman <jchapman@katalix.com>
    net/l2tp: fix warning in l2tp_exit_net found by syzbot

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix file being changed by unaligned direct write

Jakub Kicinski <kuba@kernel.org>
    netlink: fix false positive warning in extack during dumps

Guenter Roeck <linux@roeck-us.net>
    net: microchip: vcap: Add typegroup table terminators in kunit tests

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: lan78xx: Fix refcounting and autosuspend on invalid WoL configuration

Pavan Chebbi <pavan.chebbi@broadcom.com>
    tg3: Set coherent DMA mask bits to 31 for BCM57766 chipsets

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: lan78xx: Fix memory leak on device unplug by freeing PHY device

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: lan78xx: Fix double free issue with interrupt buffer allocation

Arnd Bergmann <arnd@arndb.de>
    power: reset: ep93xx: add AUXILIARY_BUS dependency

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Equivalent transition from page to folio

ChiYuan Huang <cy_huang@richtek.com>
    power: supply: rt9471: Use IC status regfield to report real charger status

ChiYuan Huang <cy_huang@richtek.com>
    power: supply: rt9471: Fix wrong WDT function regfield declaration

Barnabás Czémán <barnabas.czeman@mainlining.org>
    power: supply: bq27xxx: Fix registers of bq27426

Bart Van Assche <bvanassche@acm.org>
    power: supply: core: Remove might_sleep() from power_supply_put()

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: BPF: Sign-extend return values

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Fix build failure with GCC 15 (-std=gnu23)

Randy Dunlap <rdunlap@infradead.org>
    fs_parser: update mount_api doc to match function signature

Avihai Horon <avihaih@nvidia.com>
    vfio/pci: Properly hide first-in-list PCIe extended capability

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: zevio: Add missed label initialisation

Michael Ellerman <mpe@ellerman.id.au>
    selftests/mount_setattr: Fix failures on 64K PAGE_SIZE kernels

Yishai Hadas <yishaih@nvidia.com>
    vfio/mlx5: Fix unwind flows in mlx5vf_pci_save/resume_device_data()

Yishai Hadas <yishaih@nvidia.com>
    vfio/mlx5: Fix an unwind issue in mlx5vf_add_migration_pages()

Si-Wei Liu <si-wei.liu@oracle.com>
    vdpa/mlx5: Fix suboptimal range on iotlb iteration

Lorenzo Bianconi <lorenzo@kernel.org>
    phy: airoha: Fix REG_CSR_2L_RX{0,1}_REV0 definitions

Lorenzo Bianconi <lorenzo@kernel.org>
    phy: airoha: Fix REG_CSR_2L_JCPLL_SDM_HREN config in airoha_pcie_phy_init_ssc_jcpll()

Lorenzo Bianconi <lorenzo@kernel.org>
    phy: airoha: Fix REG_PCIE_PMA_TX_RESET config in airoha_pcie_phy_init_csr_2l()

Lorenzo Bianconi <lorenzo@kernel.org>
    phy: airoha: Fix REG_CSR_2L_PLL_CMN_RESERVE0 config in airoha_pcie_phy_init_clk_out()

Aleksa Savic <savicaleksa83@gmail.com>
    hwmon: (aquacomputer_d5next) Fix length of speed_input array

Murad Masimov <m.masimov@maxima.ru>
    hwmon: (tps23861) Fix reporting of negative temperatures

Hao Ge <gehao@kylinos.cn>
    perf bpf-filter: Return -ENOMEM directly when pfi allocation fails

Chao Yu <chao@kernel.org>
    f2fs: fix to do cast in F2FS_{BLK_TO_BYTES, BTYES_TO_BLK} to avoid overflow

Mike Snitzer <snitzer@kernel.org>
    nfs_common: must not hold RCU while calling nfsd_file_put_local

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix nfsd4_shutdown_copy()

Ye Bin <yebin10@huawei.com>
    svcrdma: fix miss destroy percpu_counter in svc_rdma_proc_init()

Yang Erkun <yangerkun@huawei.com>
    nfsd: release svc_expkey/svc_export with rcu_work

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Cap the number of bytes copied by nfs4_reset_recoverydir()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent NULL dereference in nfsd4_process_cb_update()

Zhongqiu Han <quic_zhonhan@quicinc.com>
    PCI: endpoint: epf-mhi: Avoid NULL dereference if DT lacks 'mmio'

Sibi Sankar <quic_sibis@quicinc.com>
    remoteproc: qcom_q6v5_mss: Re-order writes to the IMEM region

Jonathan Marek <jonathan@marek.ca>
    rpmsg: glink: use only lower 16-bits of param2 for CMD_OPEN name length

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    remoteproc: qcom: pas: add minidump_id to SM8350 resources

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    remoteproc: qcom: adsp: Remove subdevs on the error path of adsp_probe()

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    remoteproc: qcom: pas: Remove subdevs on the error path of adsp_probe()

Benjamin Peterson <benjamin@engflow.com>
    perf trace: Avoid garbage when not printing a syscall's arguments

Benjamin Peterson <benjamin@engflow.com>
    perf trace: Do not lose last events in a race

Howard Chu <howardchu95@gmail.com>
    perf trace: Fix tracing itself, creating feedback loops

Jean-Philippe Romain <jean-philippe.romain@foss.st.com>
    perf list: Fix topic and pmu_name argument order

Jeff Layton <jlayton@kernel.org>
    nfsd: drop inode parameter from nfsd4_change_attribute()

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Address an integer overflow

Antonio Quartulli <antonio@mandelbit.com>
    m68k: coldfire/device.c: only build FEC when HW macros are defined

Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
    m68k: mcfgpio: Fix incorrect register offset for CONFIG_M5441x

Benjamin Peterson <benjamin@engflow.com>
    perf trace: avoid garbage when not printing a trace event's arguments

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid forcing direct write to use buffered IO on inline_data inode

Chao Yu <chao@kernel.org>
    f2fs: fix to map blocks correctly for direct write

Long Li <leo.lilong@huawei.com>
    f2fs: fix race in concurrent f2fs_stop_gc_thread

Yicong Yang <yangyicong@hisilicon.com>
    perf build: Add missing cflags when building with custom libtraceevent

Siddharth Vadapalli <s-vadapalli@ti.com>
    PCI: j721e: Deassert PERST# after a delay of PCIE_T_PVPERL_MS milliseconds

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    PCI: tegra194: Move controller cleanups to pex_ep_event_pex_rst_deassert()

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    PCI: qcom-ep: Move controller cleanups to qcom_pcie_perst_deassert()

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    PCI: qcom: Enable MSI interrupts together with Link up if 'Global IRQ' is supported

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: fix to avoid use GC_AT when setting gc_mode as GC_URGENT_LOW or GC_URGENT_MID

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid potential deadlock in f2fs_record_stop_reason()

Zeng Heng <zengheng4@huawei.com>
    f2fs: Fix not used variable 'index'

Yongpeng Yang <yangyongpeng1@oppo.com>
    f2fs: check curseg->inited before write_sum_page in change_curseg

LongPing Wei <weilongping@oppo.com>
    f2fs: fix the wrong f2fs_bug_on condition in f2fs_do_replace_block

Frank Li <Frank.Li@nxp.com>
    i3c: master: Remove i3c_dev_disable_ibi_locked(olddev) on device hotjoin

Arnaldo Carvalho de Melo <acme@kernel.org>
    perf ftrace latency: Fix unit on histogram first entry when using --use-nsec

Hou Tao <houtao1@huawei.com>
    virtiofs: use pages instead of pointer for kernel direct IO

Li Huafei <lihuafei1@huawei.com>
    perf disasm: Fix not cleaning up disasm_line in symbol__disassemble_raw()

Li Huafei <lihuafei1@huawei.com>
    perf disasm: Use disasm_line__free() to properly free disasm_line

Francesco Zardi <frazar00@gmail.com>
    rust: block: fix formatting of `kernel::block::mq::request` module

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: cpqphp: Fix PCIBIOS_* return value confusion

Paolo Bonzini <pbonzini@redhat.com>
    rust: macros: fix documentation of the paste! macro

Yutaro Ohno <yutaro.ono.418@gmail.com>
    rust: kernel: fix THIS_MODULE header path in ThisModule doc comment

Leo Yan <leo.yan@arm.com>
    perf probe: Correct demangled symbols in C++ program

Ian Rogers <irogers@google.com>
    perf probe: Fix libdw memory leak

Ian Rogers <irogers@google.com>
    perf disasm: Fix capstone memory leak

Veronika Molnarova <vmolnaro@redhat.com>
    perf dso: Fix symtab_type for kmod compression

Chao Yu <chao@kernel.org>
    f2fs: fix to account dirty data in __get_secs_required()

Arnd Bergmann <arnd@arndb.de>
    mailbox, remoteproc: k3-m4+: fix compile testing

Ye Bin <yebin10@huawei.com>
    f2fs: fix null-ptr-deref in f2fs_submit_page_bio()

Qi Han <hanqi@vivo.com>
    f2fs: compress: fix inconsistent update of i_blocks in release_compress_blocks and reserve_compress_blocks

Miguel Ojeda <ojeda@kernel.org>
    rust: rbtree: fix `SAFETY` comments that should be `# Safety` sections

Veronika Molnarova <vmolnaro@redhat.com>
    perf test attr: Add back missing topdown events

Michael Petlan <mpetlan@redhat.com>
    perf trace: Keep exited threads for summary

Ian Rogers <irogers@google.com>
    perf stat: Fix affinity memory leaks on error path

Levi Yun <yeoreum.yun@arm.com>
    perf stat: Close cork_fd when create_perf_stat_counter() failed

Kan Liang <kan.liang@linux.intel.com>
    perf jevents: Don't stop at the first matched pmu when searching a events table

Todd Kjos <tkjos@google.com>
    PCI: Fix reset_method_store() memory leak

Fei Shao <fshao@chromium.org>
    dt-bindings: PCI: mediatek-gen3: Allow exact number of clocks only

Thomas Falcon <thomas.falcon@intel.com>
    perf mem: Fix printing PERF_MEM_LVLNUM_{L2_MHB|MSC}

Ian Rogers <irogers@google.com>
    perf stat: Uniquify event name improvements

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix unlinked inode cleanup

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Allow immediate GLF_VERIFY_DELETE work

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Rename GLF_VERIFY_EVICT to GLF_VERIFY_DELETE

James Clark <james.clark@linaro.org>
    perf cs-etm: Don't flush when packet_queue fills up

David Laight <David.Laight@ACULAB.COM>
    x86: fix off-by-one in access_ok()

Dan Carpenter <dan.carpenter@linaro.org>
    mailbox: arm_mhuv2: clean up loop in get_irq_chan_comb()

Yang Yingliang <yangyingliang@huawei.com>
    mailbox: mtk-cmdq: fix wrong use of sizeof in cmdq_get_clocks()

Paul Aurich <paul@darkrain42.org>
    smb: cached directories can be more than root file handle

Tomas Glozar <tglozar@redhat.com>
    rtla/timerlat: Do not set params->user_workload with -U

zhang jiao <zhangjiao2@cmss.chinamobile.com>
    pinctrl: k210: Undef K210_PC_DEFAULT

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sc8180x: Add a SoC-specific compatible to cpufreq-hw

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Correct the sequence of device suspend

Liu Shixin <liushixin2@huawei.com>
    zram: fix NULL pointer in comp_algorithm_show()

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: permit only one post-processing operation at a time

Nuno Sa <nuno.sa@analog.com>
    clk: clk-axi-clkgen: make sure to enable the AXI bus clock

Nuno Sa <nuno.sa@analog.com>
    dt-bindings: clock: axi-clkgen: include AXI clk

Lorenzo Bianconi <lorenzo@kernel.org>
    clk: en7523: fix estimation of fixed rate for EN7581

Lorenzo Bianconi <lorenzo@kernel.org>
    clk: en7523: introduce chip_scu regmap

Lorenzo Bianconi <lorenzo@kernel.org>
    clk: en7523: move clock_register in hw_init callback

Lorenzo Bianconi <lorenzo@kernel.org>
    clk: en7523: remove REG_PCIE*_{MEM,MEM_MASK} configuration

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    clk: ralink: mtmips: fix clocks probe order in oldest ralink SoCs

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    clk: ralink: mtmips: fix clock plan for Ralink SoC RT3883

Charles Han <hanchunchao@inspur.com>
    clk: clk-apple-nco: Add NULL check in applnco_probe

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Move events notifier registration to be after device registration

Zhen Lei <thunder.leizhen@huawei.com>
    fbdev: sh7760fb: Fix a possible memory leak in sh7760fb_alloc_mem()

Zhang Zekun <zhangzekun11@huawei.com>
    powerpc/kexec: Fix return of uninitialized variable

Kajol Jain <kjain@linux.ibm.com>
    KVM: PPC: Book3S HV: Fix kmv -> kvm typo

Feng Fang <fangfeng4@huawei.com>
    RDMA/hns: Fix different dgids mapping to the same dip_idx

Michal Suchanek <msuchanek@suse.de>
    powerpc/sstep: make emulate_vsx_load and emulate_vsx_store static

Gautam Menghani <gautam@linux.ibm.com>
    KVM: PPC: Book3S HV: Avoid returning to nested hypervisor on pending doorbells

Gautam Menghani <gautam@linux.ibm.com>
    KVM: PPC: Book3S HV: Stop using vc->dpdes for nested KVM guests

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    dax: delete a stale directory pmem

Nicolin Chen <nicolinc@nvidia.com>
    iommu/tegra241-cmdqv: Fix alignment failure at max_n_shift

Geert Uytterhoeven <geert@linux-m68k.org>
    zram: ZRAM_DEF_COMP should depend on ZRAM

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: fix uninitialized value in ocfs2_file_read_iter()

Dan Carpenter <dan.carpenter@linaro.org>
    kunit: skb: use "gfp" variable instead of hardcoding GFP_KERNEL

Sabyrzhan Tasbolatov <snovitoll@gmail.com>
    kasan: move checks to do_strncpy_from_user

Jinjie Ruan <ruanjinjie@huawei.com>
    cpufreq: CPPC: Fix wrong return value in cppc_get_cpu_power()

Jinjie Ruan <ruanjinjie@huawei.com>
    cpufreq: CPPC: Fix wrong return value in cppc_get_cpu_cost()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    cpufreq: loongson3: Check for error code from devm_mutex_init() call

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix NULL pointer derefernce in hns_roce_map_mr_sg()

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix out-of-order issue of requester when setting FENCE

Sourabh Jain <sourabhjain@linux.ibm.com>
    fadump: reserve param area if below boot_mem_top

Hari Bathini <hbathini@linux.ibm.com>
    powerpc/fadump: allocate memory for additional parameters early

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    x86/tdx: Dynamically disable SEPT violations from causing #VEs

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    x86/tdx: Rename tdx_parse_tdinfo() to tdx_setup()

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    x86/tdx: Introduce wrappers to read and write TD metadata

Bart Van Assche <bvanassche@acm.org>
    scsi: sg: Enable runtime power management

Zhen Lei <thunder.leizhen@huawei.com>
    scsi: qedi: Fix a possible memory leak in qedi_alloc_and_init_sb()

Zhen Lei <thunder.leizhen@huawei.com>
    scsi: qedf: Fix a possible memory leak in qedf_alloc_and_init_sb()

Zeng Heng <zengheng4@huawei.com>
    scsi: fusion: Remove unused variable 'rc'

Ye Bin <yebin10@huawei.com>
    scsi: bfa: Fix use-after-free in bfad_im_module_exit()

Baolin Liu <liubaolin@kylinos.cn>
    scsi: target: Fix incorrect function name in pscsi_create_type_disk()

Mirsad Todorovac <mtodorovac69@gmail.com>
    fs/proc/kcore.c: fix coccinelle reported ERROR instances

Raymond Hackley <raymondhackley@protonmail.com>
    leds: ktd2692: Set missing timing properties

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    leds: max5970: Fix unreleased fwnode_handle in probe function

Zhang Changzhong <zhangchangzhong@huawei.com>
    mfd: rt5033: Fix missing regmap_del_irq_chip()

Tamir Duberstein <tamird@gmail.com>
    checkpatch: always parse orig_commit in fixes tag

Zhenzhong Duan <zhenzhong.duan@intel.com>
    iommu/vt-d: Fix checks and print in pgtable_walk()

Zhenzhong Duan <zhenzhong.duan@intel.com>
    iommu/vt-d: Fix checks and print in dmar_fault_dump_ptes()

Yang Yingliang <yangyingliang@huawei.com>
    clk: imx: imx8-acm: Fix return value check in clk_imx_acm_attach_pm_domains()

Dong Aisheng <aisheng.dong@nxp.com>
    clk: imx: clk-scu: fix clk enable state save and restore

Peng Fan <peng.fan@nxp.com>
    clk: imx: fracn-gppll: fix pll power up

Peng Fan <peng.fan@nxp.com>
    clk: imx: fracn-gppll: correct PLL initialization flow

Peng Fan <peng.fan@nxp.com>
    clk: imx: lpcg-scu: SW workaround for errata (e10858)

Björn Töpel <bjorn@rivosinc.com>
    riscv: kvm: Fix out-of-bounds array access

Yong-Xuan Wang <yongxuan.wang@sifive.com>
    RISC-V: KVM: Fix APLIC in_clrip and clripnum write emulation

Chiara Meiohas <cmeiohas@nvidia.com>
    RDMA/mlx5: Ensure active slave attachment to the bond IB device

Chiara Meiohas <cmeiohas@nvidia.com>
    RDMA/core: Implement RoCE GID port rescan and export delete function

Chiara Meiohas <cmeiohas@nvidia.com>
    RDMA/mlx5: Call dev_put() after the blocking notifier

Liu Jian <liujian56@huawei.com>
    RDMA/rxe: Set queue pair cur_qp_state when being queried

Biju Das <biju.das.jz@bp.renesas.com>
    clk: renesas: rzg2l: Fix FOUTPOSTDIV clk

Andre Przywara <andre.przywara@arm.com>
    clk: sunxi-ng: d1: Fix PLL_AUDIO0 preset

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Check cqe flags to know imm_data vs inv_irkey

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix the qp flush warnings in req

wenglianfa <wenglianfa@huawei.com>
    RDMA/hns: Fix cpu stuck caused by printings during reset

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Use dev_* printings in hem code instead of ibdev_*

Yuyu Li <liyuyu6@huawei.com>
    RDMA/hns: Modify debugfs name

wenglianfa <wenglianfa@huawei.com>
    RDMA/hns: Fix flush cqe error when racing with destroy qp

wenglianfa <wenglianfa@huawei.com>
    RDMA/hns: Fix an AEQE overflow error caused by untimely update of eq_db_ci

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd/pgtbl_v2: Take protection domain lock before invalidating TLB

Jinjie Ruan <ruanjinjie@huawei.com>
    cpufreq: CPPC: Fix possible null-ptr-deref for cppc_get_cpu_cost()

Jinjie Ruan <ruanjinjie@huawei.com>
    cpufreq: CPPC: Fix possible null-ptr-deref for cpufreq_cpu_get_raw()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pseries: Fix dtl_access_lock to be a rw_semaphore

Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
    mtd: spi-nor: spansion: Use nor->addr_nbytes in octal DTR mode in RD_ANY_REG_OP

Zichen Xie <zichenxie0106@gmail.com>
    clk: sophgo: avoid integer overflow in sg2042_pll_recalc_rate()

Nicolin Chen <nicolinc@nvidia.com>
    iommu/tegra241-cmdqv: Staticize cmdqv_debugfs_dir

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/mm/fault: Fix kfence page fault reporting

Stephen Boyd <sboyd@kernel.org>
    clk: Allow kunit tests to run without OF_OVERLAY enabled

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: atmel: Fix possible memory leak

Biju Das <biju.das.jz@bp.renesas.com>
    mtd: hyperbus: rpc-if: Add missing MODULE_DEVICE_TABLE

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/fadump: Move fadump_cma_init to setup_arch() after initmem_init()

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/fadump: Refactor and prepare fadump_cma_init for late init

Yuan Can <yuancan@huawei.com>
    cpufreq: loongson2: Unregister platform_driver on failure

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_soc_pmic_bxtwc: Fix IRQ domain names duplication

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_soc_pmic_bxtwc: Use IRQ domain for PMIC devices

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_soc_pmic_bxtwc: Use IRQ domain for TMU device

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_soc_pmic_bxtwc: Use IRQ domain for USB Type-C device

Marcus Folkesson <marcus.folkesson@gmail.com>
    mfd: da9052-spi: Change read-mask to write-mask

Jinjie Ruan <ruanjinjie@huawei.com>
    mfd: tps65010: Use IRQF_NO_AUTOEN flag in request_irq() to fix race

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/vdso: Flag VDSO64 entry points as functions

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Enable all PHYs that are not disabled by user during controller reset

Matthew Rosato <mjrosato@linux.ibm.com>
    iommu/s390: Implement blocking domain

Jonathan Marek <jonathan@marek.ca>
    clk: qcom: videocc-sm8550: depend on either gcc-sm8550 or gcc-sm8650

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    pinctrl: renesas: Select PINCTRL_RZG2L for RZ/V2H(P) SoC

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    pinctrl: zynqmp: drop excess struct member description

Levi Yun <yeoreum.yun@arm.com>
    trace/trace_event_perf: remove duplicate samples on the first tracepoint event

Lukas Bulwahn <lukas.bulwahn@redhat.com>
    clk: mediatek: drop two dead config options

Biju Das <biju.das.jz@bp.renesas.com>
    pinctrl: renesas: rzg2l: Fix missing return in rzg2l_pinctrl_register()

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Disassociate mmap pages for all uctx when HW is being reset

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/core: Provide rdma_user_mmap_disassociate() to disassociate mmap pages

Jie Zhan <zhanjie9@hisilicon.com>
    cppc_cpufreq: Use desired perf if feedback ctrs are 0 or unchanged

André Almeida <andrealmeid@igalia.com>
    unicode: Fix utf8_load() error path

Jiayuan Chen <mrpre@163.com>
    bpf: fix recursive lock when verdict program return SK_PASS

Hangbin Liu <liuhangbin@gmail.com>
    wireguard: selftests: load nf_conntrack if not present

Breno Leitao <leitao@debian.org>
    netpoll: Use rcu_access_pointer() in netpoll_poll_lock

Jiawen Wu <jiawenwu@trustnetic.com>
    net: txgbe: fix null pointer to pcs

Jiawen Wu <jiawenwu@trustnetic.com>
    net: txgbe: remove GPIO interrupt controller

Jakub Kicinski <kuba@kernel.org>
    eth: fbnic: don't disable the PCI device twice

Alexander Aring <aahringo@redhat.com>
    dlm: fix dlm_recover_members refcount on error

Gao Xiang <xiang@kernel.org>
    erofs: handle NONHEAD !delta[1] lclusters gracefully

Hongzhen Luo <hongzhen@linux.alibaba.com>
    erofs: fix blksize < PAGE_SIZE for file-backed mounts

Gao Xiang <xiang@kernel.org>
    erofs: fix file-backed mounts over FUSE

Felix Maurer <fmaurer@redhat.com>
    xsk: Free skb when TX metadata options are invalid

Dmitry Antipov <dmantipov@yandex.ru>
    Bluetooth: fix use-after-free in device_for_each_child()

Iulia Tanasescu <iulia.tanasescu@nxp.com>
    Bluetooth: ISO: Send BIG Create Sync via hci_sync

Iulia Tanasescu <iulia.tanasescu@nxp.com>
    Bluetooth: ISO: Do not emit LE BIG Create Sync if previous is pending

Iulia Tanasescu <iulia.tanasescu@nxp.com>
    Bluetooth: ISO: Do not emit LE PA Create Sync if previous is pending

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Use kref to track lifetime of iso_conn

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    Bluetooth: btbcm: fix missing of_node_put() in btbcm_get_board_name()

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtk: adjust the position to init iso data anchor

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel: Do no pass vendor events to stack

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: Add handshake between driver and firmware

guanjing <guanjing@cmss.chinamobile.com>
    selftests: netfilter: Fix missing return values in conntrack_dump_flush

Igor Pylypiv <ipylypiv@google.com>
    i2c: dev: Fix memory leak when underlying adapter does not support I2C

Takashi Iwai <tiwai@suse.de>
    ALSA: 6fire: Release resources at card release

Takashi Iwai <tiwai@suse.de>
    ALSA: caiaq: Use snd_card_free_when_closed() at disconnection

Takashi Iwai <tiwai@suse.de>
    ALSA: us122l: Use snd_card_free_when_closed() at disconnection

Takashi Iwai <tiwai@suse.de>
    ALSA: usx2y: Use snd_card_free_when_closed() at disconnection

Xu Kuohai <xukuohai@huawei.com>
    bpf: Add kernel symbol for struct_ops trampoline

Xu Kuohai <xukuohai@huawei.com>
    bpf: Use function pointers count as struct_ops links count

Kalle Valo <kvalo@kernel.org>
    Revert "wifi: iwlegacy: do not skip frames with bad FCS"

Mingwei Zheng <zmw12306@gmail.com>
    net: rfkill: gpio: Add check for clk_enable()

Omid Ehtemam-Haghighi <omid.ehtemamhaghighi@menlosecurity.com>
    ipv6: Fix soft lockups in fib6_select_path under high next hop churn

Viktor Malik <vmalik@redhat.com>
    selftests/bpf: skip the timer_lockup test for single-CPU nodes

Jiri Olsa <jolsa@kernel.org>
    bpf: Force uprobe bpf program to always return 0

Jiri Olsa <jolsa@kernel.org>
    bpf: Allow return values 0 and 1 for kprobe session

Yuan Can <yuancan@huawei.com>
    drm/amdkfd: Fix wrong usage of INIT_WORK()

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Fix map/unmap queue logic

Yang Wang <kevinyang.wang@amd.com>
    drm/amdgpu: fix ACA bank count boundary check error

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: tell iwlmei when we finished suspending

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: allow fast resume on ax200

Lingbo Kong <quic_lingbok@quicinc.com>
    wifi: cfg80211: Remove the Medium Synchronization Delay validity check

Paolo Abeni <pabeni@redhat.com>
    selftests: net: really check for bg process completion

Paolo Abeni <pabeni@redhat.com>
    ipv6: release nexthop on device removal

Zijian Zhang <zijianzhang@bytedance.com>
    bpf, sockmap: Fix sk_msg_reset_curr

Zijian Zhang <zijianzhang@bytedance.com>
    bpf, sockmap: Several fixes to bpf_msg_pop_data

Zijian Zhang <zijianzhang@bytedance.com>
    bpf, sockmap: Several fixes to bpf_msg_push_data

Zijian Zhang <zijianzhang@bytedance.com>
    selftests/bpf: Add push/pop checking for msg_verify_data in test_sockmap

Zijian Zhang <zijianzhang@bytedance.com>
    selftests/bpf: Fix total_bytes in msg_loop_rx in test_sockmap

Zijian Zhang <zijianzhang@bytedance.com>
    selftests/bpf: Fix SENDPAGE data logic in test_sockmap

Zijian Zhang <zijianzhang@bytedance.com>
    selftests/bpf: Add txmsg_pass to pull/push/pop in test_sockmap

Hao Ge <gehao@kylinos.cn>
    isofs: avoid memory leak in iocharset

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panthor: Fix OPP refcnt leaks in devfreq initialisation

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panthor: record current and maximum device clock frequencies

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panthor: introduce job cycle and timestamp accounting

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panfrost: Add missing OPP table refcnt decremental

Pei Xiao <xiaopei01@kylinos.cn>
    wifi: rtw89: coex: check NULL return of kmalloc in btc_fw_set_monreg()

Maurice Lambert <mauricelambert434@gmail.com>
    netlink: typographical error in nlmsg_type constants definition

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: must hold rcu read lock while iterating object type list

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: must hold rcu read lock while iterating expression type list

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: avoid false-positive lockdep splat on rule deletion

Jonathan Gray <jsg@jsg.id.au>
    drm: use ATOMIC64_INIT() for atomic64_t

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Mark raw_tp arguments with PTR_MAYBE_NULL

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdkfd: Use dynamic allocation for CU occupancy array in 'kfd_get_cu_occupancy()'

Li Huafei <lihuafei1@huawei.com>
    drm/amdgpu: Fix the memory allocation issue in amdgpu_discovery_get_nps_info()

José Expósito <jose.exposito89@gmail.com>
    drm/vkms: Drop unnecessary call to drm_crtc_cleanup()

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Tighten tail call checks for lingering locks, RCU, preempt_disable

Leon Hwang <leon.hwang@linux.dev>
    bpf, bpftool: Fix incorrect disasm pc

Zichen Xie <zichenxie0106@gmail.com>
    drm/msm/dpu: cast crtc_clk calculation to u64 in _dpu_core_perf_calc_clk()

Linus Walleij <linus.walleij@linaro.org>
    wifi: cw1200: Fix potential NULL dereference

Yuan Can <yuancan@huawei.com>
    wifi: wfx: Fix error handling in wfx_core_init()

Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>
    drm: xlnx: zynqmp_disp: layer may be null while releasing

Sean Anderson <sean.anderson@linux.dev>
    drm: zynqmp_kms: Unplug DRM device before removal

Li Huafei <lihuafei1@huawei.com>
    drm/nouveau/gr/gf100: Fix missing unlock in gf100_gr_chan_new()

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Reduce HPD Detection Interval for IPS

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Increase idle worker HPD detection time

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: hold GPU lock across perfmon sampling

Xiaolei Wang <xiaolei.wang@windriver.com>
    drm/etnaviv: Request pages from DMA32 zone on addressing_limited

Suraj Kandpal <suraj.kandpal@intel.com>
    drm/xe/hdcp: Fix gsc structure check in fw check status

Lukasz Luba <lukasz.luba@arm.com>
    drm/msm/gpu: Check the status of registration to PM QoS

Jinjie Ruan <ruanjinjie@huawei.com>
    drm/msm/adreno: Use IRQF_NO_AUTOEN flag in request_irq()

Xu Kuohai <xukuohai@huawei.com>
    bpf, arm64: Remove garbage frame for struct_ops trampoline

Steven Price <steven.price@arm.com>
    drm/panfrost: Remove unused id_mask from struct panfrost_model

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: rtw89: unlock on error path in rtw89_ops_unassign_vif_chanctx()

Po-Hao Huang <phhuang@realtek.com>
    wifi: rtw89: Fix TX fail with A2DP after scanning

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: rtw89: tweak driver architecture for impending MLO support

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: rtw89: refactor STA related func ahead for MLO

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: rtw89: refactor VIF related func ahead for MLO

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: rtw89: read link_sta corresponding to the link

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: rtw89: read bss_conf corresponding to the link

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: rtw89: rename rtw89_sta to rtw89_sta_link ahead for MLO

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: rtw89: rename rtw89_vif to rtw89_vif_link ahead for MLO

Andrii Nakryiko <andrii@kernel.org>
    libbpf: move global data mmap()'ing into bpf_object__load()

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: fix test_spin_lock_fail.c's global vars usage

Dipendra Khadka <kdipendra88@gmail.com>
    octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_dcbnl.c

Dipendra Khadka <kdipendra88@gmail.com>
    octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_dmac_flt.c

Dipendra Khadka <kdipendra88@gmail.com>
    octeontx2-pf: handle otx2_mbox_get_rsp errors in cn10k.c

Dipendra Khadka <kdipendra88@gmail.com>
    octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_flows.c

Dipendra Khadka <kdipendra88@gmail.com>
    octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_ethtool.c

Dipendra Khadka <kdipendra88@gmail.com>
    octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_common.c

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: drop LM_3 / LM_4 on MSM8998

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: drop LM_3 / LM_4 on SDM845

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: on SDM845 move DSPP_3 to LM_5 block

Ryan Walklin <ryan@testtoast.com>
    drm: panel: nv3052c: correct spi_device_id for RG35XX panel

Matthias Schiffer <matthias.schiffer@tq-group.com>
    drm: fsl-dcu: enable PIXCLK on LS1021A

Alper Nebi Yasak <alpernebiyasak@gmail.com>
    wifi: mwifiex: Fix memcpy() field-spanning write warning in mwifiex_config_scan()

Marek Vasut <marex@denx.de>
    wifi: wilc1000: Set MAC after operation mode

Sascha Hauer <s.hauer@pengutronix.de>
    wifi: mwifiex: add missing locking for cfg80211 calls

Zijian Zhang <zijianzhang@bytedance.com>
    selftests/bpf: Fix txmsg_redir of test_txmsg_pull in test_sockmap

Zijian Zhang <zijianzhang@bytedance.com>
    selftests/bpf: Fix msg_verify_data in test_sockmap

Miguel Ojeda <ojeda@kernel.org>
    drm/panic: Select ZLIB_DEFLATE for DRM_PANIC_SCREEN_QR_CODE

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/bridge: tc358767: Fix link properties discovery

Hangbin Liu <liuhangbin@gmail.com>
    netdevsim: copy addresses for both in and out paths

Andrii Nakryiko <andrii@kernel.org>
    libbpf: never interpret subprogs in .text as entry programs

Everest K.C <everestkc@everestkc.com.np>
    ASoC: rt722-sdca: Remove logically deadcode in rt722-sdca.c

Karol Wachowski <karol.wachowski@intel.com>
    accel/ivpu: Prevent recovery invocation during probe and resume

Andrii Nakryiko <andrii@kernel.org>
    libbpf: fix sym_is_subprog() logic for weak global subprogs

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: Correct generation check in vc4_hvs_lut_load

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: Match drm_dev_enter and exit calls in vc4_hvs_atomic_flush

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: Match drm_dev_enter and exit calls in vc4_hvs_lut_load

Maxime Ripard <mripard@kernel.org>
    drm/vc4: Introduce generation number enum

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: hdmi: Increase audio MAI fifo dreq threshold

Jacob Keller <jacob.e.keller@intel.com>
    ice: consistently use q_idx in ice_vc_cfg_qs_msg()

Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
    wifi: cfg80211: check radio iface combination for multi radio per wiphy

Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
    selftests/bpf: add missing header include for htons

Balaji Pothunoori <quic_bpothuno@quicinc.com>
    wifi: ath11k: Fix CE offset address calculation for WCN6750 in SSR

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: Fix backtrace printing for selftests crashes

Yuan Chen <chenyuan@kylinos.cn>
    bpf: Fix the xdp_adjust_tail sample prog issue

Björn Töpel <bjorn@rivosinc.com>
    selftests: bpf: Add missing per-arch include path

Björn Töpel <bjorn@rivosinc.com>
    libbpf: Add missing per-arch include path

Arnd Bergmann <arnd@arndb.de>
    wifi: ath12k: fix one more memcpy size error

Rameshkumar Sundaram <quic_ramess@quicinc.com>
    wifi: ath12k: fix use-after-free in ath12k_dp_cc_cleanup()

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: fix a memleak issue when driver is removed

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: acp: fix for cpu dai index logic

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: acp: fix for inconsistent indenting

Martin Kaistra <martin.kaistra@linutronix.de>
    wifi: rtl8xxxu: Perform update_beacon_work when beaconing is enabled

Alexander Aring <aahringo@redhat.com>
    dlm: fix swapped args sb_flags vs sb_status

Alan Maguire <alan.maguire@oracle.com>
    selftests/bpf: Fix uprobe_multi compilation error

Tony Ambardar <tony.ambardar@gmail.com>
    libbpf: Fix output .symtab byte-order during linking

Tao Chen <chen.dylane@gmail.com>
    libbpf: Fix expected_attach_type set handling in program load callback

Pin-yen Lin <treapking@chromium.org>
    drm/bridge: it6505: Drop EDID cache on bridge power off

Pin-yen Lin <treapking@chromium.org>
    drm/bridge: anx7625: Drop EDID cache on bridge power off

Geert Uytterhoeven <geert+renesas@glider.be>
    ASoC: fsl-asoc-card: Add missing handling of {hp,mic}-dt-gpios

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu/gfx9: Add Cleaner Shader Deinitialization in gfx_v9_0 Module

Macpaul Lin <macpaul.lin@mediatek.com>
    ASoC: dt-bindings: mt6359: Update generic node name and dmic-mode

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: fix regmap_write_bits usage

Igor Prusov <ivprusov@salutedevices.com>
    dt-bindings: vendor-prefixes: Add NeoFidelity, Inc

Ramya Gnanasekar <quic_rgnanase@quicinc.com>
    wifi: ath12k: Skip Rx TID cleanup for self peer

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath10k: fix invalid VHT parameters in supported_vht_mcs_rate_nss2

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath10k: fix invalid VHT parameters in supported_vht_mcs_rate_nss1

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Fix JPEG v4.0.3 register write

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Flush the MMU before we supply more memory to the binner

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Address race-condition in MMU flush

Linus Walleij <linus.walleij@linaro.org>
    drm/panel: nt35510: Make new commands optional

Alexander Stein <alexander.stein@ew.tq-group.com>
    drm/imx: Add missing DRM_BRIDGE_CONNECTOR dependency

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/imx: parallel-display: switch to drm_panel_bridge

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/imx: ldb: switch to drm_panel_bridge

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/imx: ldb: drop custom DDC bus support

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/imx: ldb: drop custom EDID support

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/imx: parallel-display: drop edid override support

Jinjie Ruan <ruanjinjie@huawei.com>
    drm/imx/ipuv3: Use IRQF_NO_AUTOEN flag in request_irq()

Jinjie Ruan <ruanjinjie@huawei.com>
    drm/imx/dcss: Use IRQF_NO_AUTOEN flag in request_irq()

Huan Yang <link@vivo.com>
    udmabuf: fix vmap_udmabuf error page set

Huan Yang <link@vivo.com>
    udmabuf: change folios array from kmalloc to kvmalloc

Jinjie Ruan <ruanjinjie@huawei.com>
    wifi: mwifiex: Use IRQF_NO_AUTOEN flag in request_irq()

Jinjie Ruan <ruanjinjie@huawei.com>
    wifi: p54: Use IRQF_NO_AUTOEN flag in request_irq()

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/v3d: Appease lockdep while updating GPU stats

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/omap: Fix locking in omap_gem_new_dmabuf()

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/omap: Fix possible NULL dereference

Jeongjun Park <aha310510@gmail.com>
    wifi: ath9k: add range check for conn_rsp_epid in htc_connect_service()

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Correct logic on stopping an HVS channel

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Remove incorrect limit from hvs_dlist debugfs function

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Fix dlist debug not resetting the next entry pointer

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: hdmi: Avoid hang with debug registers when suspended

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Don't write gamma luts on 2711

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    drm/mm: Mark drm_mm_interval_tree*() functions with __maybe_unused

Matt Coster <Matt.Coster@imgtec.com>
    drm/imagination: Use pvr_vm_context_get()

Chen Yufan <chenyufan@vivo.com>
    drm/imagination: Convert to use time_before macro

Yao Zi <ziyao@disroot.org>
    platform/x86: panasonic-laptop: Return errno correctly in show callback

Michael J. Ruhl <michael.j.ruhl@intel.com>
    platform/x86/intel/pmt: allow user offset for PMT callbacks

Armin Wolf <W_Armin@gmx.de>
    platform/x86: asus-wmi: Fix inconsistent use of thermal policies

Vitaly Kuznetsov <vkuznets@redhat.com>
    HID: hyperv: streamline driver probe to avoid devres issues

Tejun Heo <tj@kernel.org>
    sched_ext: scx_bpf_dispatch_from_dsq_set_*() are allowed from unlocked context

Chris Morgan <macromorgan@hotmail.com>
    arm64: dts: rockchip: correct analog audio name on Indiedroid Nova

Li Huafei <lihuafei1@huawei.com>
    media: atomisp: Add check for rgby_data memory allocation failure

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: Assume a disabled PWM to emit a constant inactive output

Sergey Senozhatsky <senozhatsky@chromium.org>
    media: venus: sync with threaded IRQ during inst destruction

Sergey Senozhatsky <senozhatsky@chromium.org>
    media: venus: fix enc/dec destruction order

Bingbu Cao <bingbu.cao@intel.com>
    media: ipu6: remove architecture DMA ops dependency in Kconfig

Bingbu Cao <bingbu.cao@intel.com>
    media: ipu6: not override the dma_ops of device in driver

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ipu6: Fix DMA and physical address debugging messages for 32-bit

Luo Qiu <luoqiu@kylinsec.com.cn>
    firmware: arm_scpi: Check the DVFS OPP count returned by the firmware

Reinette Chatre <reinette.chatre@intel.com>
    selftests/resctrl: Protect against array overrun during iMC config parsing

Reinette Chatre <reinette.chatre@intel.com>
    selftests/resctrl: Fix memory overflow due to unhandled wraparound

Reinette Chatre <reinette.chatre@intel.com>
    selftests/resctrl: Print accurate buffer size as part of MBM results

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183-kukui-jacuzzi: Add supplies for fixed regulators

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183-kukui-jacuzzi: Fix DP bridge supply names

Macpaul Lin <macpaul.lin@mediatek.com>
    arm64: dts: mediatek: mt6358: fix dtbs_check error

Frank Li <Frank.Li@nxp.com>
    arm64: dts: imx8mn-tqma8mqnl-mba8mx-usbot: fix coexistence of output-low and output-high in GPIO

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    arm64: dts: renesas: hihope: Drop #sound-dai-cells

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    regmap: irq: Set lockdep class for hierarchical IRQ domains

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: zynqmp-gqspi: Undo runtime PM changes at driver exit time​

Breno Leitao <leitao@debian.org>
    spi: tegra210-quad: Avoid shift-out-of-bounds

Zhang Zekun <zhangzekun11@huawei.com>
    pmdomain: ti-sci: Add missing of_node_put() for args.np

Usama Arif <usamaarif642@gmail.com>
    of/fdt: add dt_phys arg to early_init_dt_scan and early_init_dt_verify

Abel Vesa <abel.vesa@linaro.org>
    dt-bindings: cache: qcom,llcc: Fix X1E80100 reg entries

Konrad Dybcio <konradybcio@kernel.org>
    arm64: dts: qcom: x1e80100: Update C4/C5 residency/exit numbers

Niklas Schnelle <schnelle@linux.ibm.com>
    watchdog: Add HAS_IOPORT dependency for SBC8360 and SBC7240

Anurag Dutta <a-dutta@ti.com>
    arm64: dts: ti: k3-j721s2: Fix clock IDs for MCSPI instances

Anurag Dutta <a-dutta@ti.com>
    arm64: dts: ti: k3-j721e: Fix clock IDs for MCSPI instances

Anurag Dutta <a-dutta@ti.com>
    arm64: dts: ti: k3-j7200: Fix clock ids for MCSPI instances

Jared McArthur <j-mcarthur@ti.com>
    arm64: dts: ti: k3-j7200: Fix register map for main domain pmx

Andre Przywara <andre.przywara@arm.com>
    ARM: dts: cubieboard4: Fix DCDC5 regulator constraints

Clark Wang <xiaoning.wang@nxp.com>
    pwm: imx27: Workaround of the pwm output bug when decrease the duty cycle

Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
    arm64: dts: mt8183: Damu: add i2c2's i2c-scl-internal-delay-ns

Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
    arm64: dts: mt8183: cozmo: add i2c2's i2c-scl-internal-delay-ns

Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
    arm64: dts: mt8183: burnet: add i2c2's i2c-scl-internal-delay-ns

Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
    arm64: dts: mt8183: fennel: add i2c2's i2c-scl-internal-delay-ns

Heiko Stuebner <heiko@sntech.de>
    arm64: dts: rockchip: Remove 'enable-active-low' from two boards

Tomasz Maciej Nowak <tmn505@gmail.com>
    arm64: tegra: p2180: Add mandatory compatible for WiFi node

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    power: sequencing: make the QCom PMU pwrseq driver depend on CONFIG_OF

Dragan Simic <dsimic@manjaro.org>
    regulator: rk808: Restrict DVS GPIOs to the RK808 variant only

Chen Ridong <chenridong@huawei.com>
    cgroup/bpf: only cgroup v2 can be attached by bpf programs

Chen Ridong <chenridong@huawei.com>
    Revert "cgroup: Fix memory leak caused by missing cgroup_bpf_offline"

Fei Shao <fshao@chromium.org>
    arm64: dts: mediatek: mt8195-cherry: Use correct audio codec DAI

Fei Shao <fshao@chromium.org>
    arm64: dts: mediatek: mt8188: Fix USB3 PHY port default status

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173-elm-hana: Add vdd-supply to second source trackpad

Srikar Dronamraju <srikar@linux.ibm.com>
    gpio: sloppy-logic-analyzer remove reference to rcu_momentary_dyntick_idle()

Nathan Morrisson <nmorrisson@phytec.com>
    arm64: dts: ti: k3-am62x-phyboard-lyra: Drop unnecessary McASP AFIFOs

Randy Dunlap <rdunlap@infradead.org>
    kernel-doc: allow object-like macros in ReST output

Sibi Sankar <quic_sibis@quicinc.com>
    arm64: dts: qcom: x1e80100: Resize GIC Redistributor register region

Hsin-Te Yuan <yuanhsinte@chromium.org>
    arm64: dts: mt8183: kukui: Fix the address of eeprom at i2c4

Hsin-Te Yuan <yuanhsinte@chromium.org>
    arm64: dts: mt8183: krane: Fix the address of eeprom at i2c4

Colin Ian King <colin.i.king@gmail.com>
    media: i2c: ds90ub960: Fix missing return check on ub960_rxport_read call

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: i2c: vgxy61: Fix an error handling path in vgxy61_detect()

Dan Carpenter <dan.carpenter@linaro.org>
    media: i2c: max96717: clean up on error in max96717_subdev_init()

Gregory Price <gourry@gourry.net>
    tpm: fix signed/unsigned bug when checking event logs

Jonathan Marek <jonathan@marek.ca>
    efi/libstub: fix efi_parse_options() ignoring the default command line

Stafford Horne <shorne@gmail.com>
    openrisc: Implement fixmap to fix earlycon

Abel Vesa <abel.vesa@linaro.org>
    arm64: dts: qcom: x1e80100-vivobook-s15: Drop orientation-switch from USB SS[0-1] QMP PHYs

Abel Vesa <abel.vesa@linaro.org>
    arm64: dts: qcom: x1e80100-slim7x: Drop orientation-switch from USB SS[0-1] QMP PHYs

Chen-Yu Tsai <wenst@chromium.org>
    scripts/kernel-doc: Do not track section counter across processed files

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    mmc: mmc_spi: drop buggy snprintf()

Andrei Simion <andrei.simion@microchip.com>
    ARM: dts: microchip: sam9x60: Add missing property atmel,usart-mode

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sda660-ifc6560: fix l10a voltage ranges

Luca Weiss <luca.weiss@fairphone.com>
    arm64: dts: qcom: sm6350: Fix GPU frequencies missing on some speedbins

Dan Carpenter <dan.carpenter@linaro.org>
    soc: qcom: geni-se: fix array underflow in geni_se_clk_tbl_get()

Jinjie Ruan <ruanjinjie@huawei.com>
    soc: ti: smartreflex: Use IRQF_NO_AUTOEN flag in request_irq()

Pin-yen Lin <treapking@chromium.org>
    arm64: dts: mt8183: Add port node to dpi node

Alper Nebi Yasak <alpernebiyasak@gmail.com>
    arm64: dts: mediatek: mt8183-kukui: Disable DPI display interface

Macpaul Lin <macpaul.lin@mediatek.com>
    arm64: dts: mt8195: Fix dtbs_check error for infracfg_ao node

Macpaul Lin <macpaul.lin@mediatek.com>
    arm64: dts: mt8195: Fix dtbs_check error for mutex node

Macpaul Lin <macpaul.lin@mediatek.com>
    arm64: dts: mediatek: mt8395-genio-1200-evk: Fix dtbs_check error for phy

Pablo Sun <pablo.sun@mediatek.com>
    arm64: dts: mediatek: mt8188: Fix wrong clock provider in MFG1 power domain

Michal Simek <michal.simek@amd.com>
    microblaze: Export xmb_manager functions

Gaosheng Cui <cuigaosheng1@huawei.com>
    drivers: soc: xilinx: add the missing kfree in xlnx_add_cb_for_suspend()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    ARM: dts: renesas: genmai: Fix partition size for QSPI NOR Flash

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: qcs6390-rb3gen2: use modem.mbn for modem DSP

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: spi-fsl-lpspi: Use IRQF_NO_AUTOEN flag in request_irq()

Min-Hua Chen <minhuadotchen@gmail.com>
    regulator: qcom-smd: make smd_vreg_rpm static

Samuel Holland <samuel.holland@sifive.com>
    irqchip/riscv-aplic: Prevent crash when MSI domain is missing

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    clocksource/drivers/timer-ti-dm: Fix child node refcount handling

Mark Brown <broonie@kernel.org>
    clocksource/drivers:sp804: Make user selectable

Eder Zulian <ezulian@redhat.com>
    rust: helpers: Avoid raw_spin_lock initialization for PREEMPT_RT

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    locking/rt: Add sparse annotation PREEMPT_RT's sleeping locks.

Thomas Gleixner <tglx@linutronix.de>
    sched/ext: Remove sched_fork() hack

Marco Elver <elver@google.com>
    kcsan, seqlock: Fix incorrect assumption in read_seqbegin()

Marco Elver <elver@google.com>
    kcsan, seqlock: Support seqcount_latch_t

Uros Bizjak <ubizjak@gmail.com>
    locking/atomic/x86: Use ALT_OUTPUT_SP() for __arch_{,try_}cmpxchg64_emu()

Uros Bizjak <ubizjak@gmail.com>
    locking/atomic/x86: Use ALT_OUTPUT_SP() for __alternative_atomic64()

Thomas Gleixner <tglx@linutronix.de>
    timers: Add missing READ_ONCE() in __run_timer_base()

Miguel Ojeda <ojeda@kernel.org>
    time: Fix references to _msecs_to_jiffies() handling of values

Miguel Ojeda <ojeda@kernel.org>
    time: Partially revert cleanup on msecs_to_jiffies() documentation

Uros Bizjak <ubizjak@gmail.com>
    cleanup: Remove address space of returned pointer

Carlos Llamas <cmllamas@google.com>
    Revert "scripts/faddr2line: Check only two symbols when calculating symbol size"

Zheng Yejian <zhengyejian@huaweicloud.com>
    x86/unwind/orc: Fix unwind for newly forked tasks

Daniel Lezcano <daniel.lezcano@linaro.org>
    thermal/lib: Fix memory leak on error in thermal_genl_auto()

Daniel Lezcano <daniel.lezcano@linaro.org>
    tools/lib/thermal: Make more generic the command encoding function

Uladzislau Rezki (Sony) <urezki@gmail.com>
    rcuscale: Do a proper cleanup if kfree_scale_init() fails

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    crypto: cavium - Fix an error handling path in cpt_ucode_load_fw()

Michal Suchanek <msuchanek@suse.de>
    crypto: aes-gcm-p10 - Use the correct bit to test for P10

Chen Ridong <chenridong@huawei.com>
    crypto: bcm - add error check in the ahash_hmac_init function

Chen Ridong <chenridong@huawei.com>
    crypto: caam - add error check to caam_rsa_set_priv_key_form

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: testing: Initialize some variables annoteded with _free()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: testing: Use DEFINE_FREE() and __free() to simplify code

Lifeng Zheng <zhenglifeng1@huawei.com>
    ACPI: CPPC: Fix _CPC register setting issue

Pei Xiao <xiaopei01@kylinos.cn>
    hwmon: (nct6775-core) Fix overflows seen when writing limit attributes

Jerome Brunet <jbrunet@baylibre.com>
    hwmon: (pmbus/core) clear faults after setting smbalert mask

Zqiang <qiang.zhang1211@gmail.com>
    rcu/nocb: Fix missed RCU barrier on deoffloading

Uladzislau Rezki (Sony) <urezki@gmail.com>
    rcu/kvfree: Fix data-race in __mod_timer / kvfree_call_rcu

Michal Schmidt <mschmidt@redhat.com>
    rcu/srcutiny: don't return before reenabling preemption

Baruch Siach <baruch@tkos.co.il>
    doc: rcu: update printed dynticks counter bits

Christian Loehle <christian.loehle@arm.com>
    sched/cpufreq: Ensure sd is rebuilt for EAS check

Li Huafei <lihuafei1@huawei.com>
    crypto: inside-secure - Fix the return value of safexcel_xcbcmac_cra_init()

Wang Hai <wanghai38@huawei.com>
    crypto: qat - Fix missing destroy_workqueue in adf_init_aer()

Orange Kao <orange@aiven.io>
    EDAC/igen6: Avoid segmentation fault on module unload

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - disable same error report before resetting

Gautham R. Shenoy <gautham.shenoy@amd.com>
    amd-pstate: Set min_perf to nominal_perf for active mode performance gov

Mario Limonciello <mario.limonciello@amd.com>
    cpufreq/amd-pstate: Don't update CPPC request in amd_pstate_cpu_boost_update()

Everest K.C <everestkc@everestkc.com.np>
    crypto: cavium - Fix the if condition to exit loop after timeout

Yi Yang <yiyang13@huawei.com>
    crypto: pcrypt - Call crypto layer directly when padata_do_parallel() return -EBUSY

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/{skx_common,i10nm}: Fix incorrect far-memory error source indicator

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/skx_common: Differentiate memory error sources

Priyanka Singh <priyanka.singh@nxp.com>
    EDAC/fsl_ddr: Fix bad bit shift operations

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Fix race between zone registration and system suspend

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Mark thermal zones as initializing to start with

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Represent suspend-related thermal zone flags as bits

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Rearrange PM notification code

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Initialize thermal zones before registering them

Ahsan Atta <ahsan.atta@intel.com>
    crypto: qat - remove faulty arbiter config reset

David Thompson <davthompson@nvidia.com>
    EDAC/bluefield: Fix potential integer overflow

Yuan Can <yuancan@huawei.com>
    firmware: google: Unregister driver_info on failure

Dan Carpenter <dan.carpenter@linaro.org>
    crypto: qat/qat_4xxx - fix off by one in uof_get_name()

Dan Carpenter <dan.carpenter@linaro.org>
    crypto: qat/qat_420xx - fix off by one in uof_get_name()

Danny Tsen <dtsen@linux.ibm.com>
    crypto: powerpc/p10-aes-gcm - Add dependency on CRYPTO_SIMDand re-enable CRYPTO_AES_GCM_P10

Danny Tsen <dtsen@linux.ibm.com>
    crypto: powerpc/p10-aes-gcm - Register modules as SIMD

Cabiddu, Giovanni <giovanni.cabiddu@intel.com>
    crypto: qat - remove check after debugfs_create_dir()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    crypto: caam - Fix the pointer passed to caam_qi_shutdown()

Tomas Paukrt <tomaspaukrt@email.cz>
    crypto: mxs-dcp - Fix AES-CBC with hardware-bound keys

Christoph Hellwig <hch@lst.de>
    virtio_blk: reverse request order in virtio_queue_rqs

Christoph Hellwig <hch@lst.de>
    nvme-pci: reverse request order in nvme_queue_rqs

Long Li <leo.lilong@huawei.com>
    ext4: fix race in buffer_head read fault injection

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    hfsplus: don't query the device logical block size multiple times

Masahiro Yamada <masahiroy@kernel.org>
    s390/syscalls: Avoid creation of arch/arch/ directory

Christoph Hellwig <hch@lst.de>
    block: fix bio_split_rw_at to take zone_write_granularity into account

Christoph Hellwig <hch@lst.de>
    block: take chunk_sectors into account in bio_split_write_zeroes

Zizhi Wo <wozizhi@huawei.com>
    netfs/fscache: Add a memory barrier for FSCACHE_VOLUME_CREATING

Zizhi Wo <wozizhi@huawei.com>
    cachefiles: Fix NULL pointer dereference in object->file

Zizhi Wo <wozizhi@huawei.com>
    cachefiles: Fix missing pos updates in cachefiles_ondemand_fd_write_iter()

Zizhi Wo <wozizhi@huawei.com>
    cachefiles: Fix incorrect length return value in cachefiles_ondemand_fd_write_iter()

Li Wang <liwang@redhat.com>
    loop: fix type of block size

Aleksandr Mishin <amishin@t-argos.ru>
    acpi/arm64: Adjust error handling procedure in gtdt_parse_timer_block()

Masahiro Yamada <masahiroy@kernel.org>
    arm64: fix .data.rel.ro size assertion when CONFIG_LTO_CLANG

Daniel Palmer <daniel@0x0f.com>
    m68k: mvme147: Reinstate early console

Daniel Palmer <daniel@0x0f.com>
    m68k: mvme147: Fix SCSI controller IRQ numbers

Christoph Hellwig <hch@lst.de>
    nvme-pci: fix freeing of the HMB descriptor table

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Fix encoding for SVE B16B16 test

Marc Zyngier <maz@kernel.org>
    arm64: Expose ID_AA64ISAR1_EL1.XS to sanitised feature consumers

David Disseldorp <ddiss@suse.de>
    initramfs: avoid filename buffer overrun

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: Fix and protect memory allocation of SDBs with mutex

Jonas Gorski <jonas.gorski@gmail.com>
    mips: asm: fix warning when disabling MIPS_FP_SUPPORT

Jan Kara <jack@suse.cz>
    ext4: avoid remount errors with 'abort' mount option

Yang Erkun <yangerkun@huawei.com>
    brd: defer automatic disk creation until module initialization succeeds

Ard Biesheuvel <ardb@kernel.org>
    x86/pvh: Call C code via the kernel virtual mapping

Heiko Carstens <hca@linux.ibm.com>
    s390/pageattr: Implement missing kernel_page_present()

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: Do not unregister the subchannel based on DNV

John Garry <john.g.garry@oracle.com>
    fs/block: Check for IOCB_DIRECT in generic_atomic_write_valid()

John Garry <john.g.garry@oracle.com>
    block/fs: Pass an iocb to generic_atomic_write_valid()

Andre Przywara <andre.przywara@arm.com>
    kselftest/arm64: mte: fix printf type warnings about longs

Andre Przywara <andre.przywara@arm.com>
    kselftest/arm64: mte: fix printf type warnings about __u64

Andre Przywara <andre.przywara@arm.com>
    kselftest/arm64: hwcap: fix f8dp2 cpuinfo name

Kristina Martsenko <kristina.martsenko@arm.com>
    arm64: probes: Disable kprobes/uprobes on MOPS instructions

Bill O'Donnell <bodonnel@redhat.com>
    efs: fix the efs new mount api implementation

Halil Pasic <pasic@linux.ibm.com>
    s390/virtio_ccw: Fix dma_parm pointer not set up

Gerd Bayer <gbayer@linux.ibm.com>
    s390/facilities: Fix warning about shadow of global variable

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Fix incorrect DSC recompute trigger

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Skip Invalid Streams from DSC Policy

Darrick J. Wong <djwong@kernel.org>
    MAINTAINERS: appoint myself the XFS maintainer for 6.12 LTS


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-fs-f2fs            |   7 +-
 Documentation/RCU/stallwarn.rst                    |   2 +-
 Documentation/admin-guide/blockdev/zram.rst        |   2 +
 Documentation/admin-guide/media/building.rst       |   2 +-
 Documentation/admin-guide/media/saa7134.rst        |   2 +-
 Documentation/arch/x86/boot.rst                    |  17 +-
 .../devicetree/bindings/cache/qcom,llcc.yaml       |  38 +-
 .../devicetree/bindings/clock/adi,axi-clkgen.yaml  |  22 +-
 .../devicetree/bindings/iio/dac/adi,ad3552r.yaml   |   2 +-
 .../bindings/pci/mediatek-pcie-gen3.yaml           |   5 +-
 .../pinctrl/samsung,pinctrl-wakeup-interrupt.yaml  |  19 +-
 .../devicetree/bindings/serial/rs485.yaml          |  19 +-
 .../devicetree/bindings/sound/mt6359.yaml          |  10 +-
 .../devicetree/bindings/vendor-prefixes.yaml       |   2 +
 Documentation/filesystems/mount_api.rst            |   3 +-
 Documentation/locking/seqlock.rst                  |   2 +-
 MAINTAINERS                                        | 335 ++++----
 Makefile                                           |   4 +-
 arch/arc/kernel/devtree.c                          |   2 +-
 .../boot/dts/allwinner/sun9i-a80-cubieboard4.dts   |   4 +-
 arch/arm/boot/dts/microchip/sam9x60.dtsi           |  12 +
 arch/arm/boot/dts/renesas/r7s72100-genmai.dts      |   2 +-
 arch/arm/boot/dts/ti/omap/omap36xx.dtsi            |   1 +
 arch/arm/kernel/devtree.c                          |   2 +-
 .../freescale/imx8mn-tqma8mqnl-mba8mx-usbotg.dtso  |  29 +-
 arch/arm64/boot/dts/mediatek/mt6358.dtsi           |   4 +-
 arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtsi  |   8 +
 .../dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts   |   3 +
 .../dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts    |   2 +
 .../dts/mediatek/mt8183-kukui-jacuzzi-damu.dts     |   3 +
 .../dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi  |   3 +
 .../boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi    |  30 +-
 .../boot/dts/mediatek/mt8183-kukui-kakadu.dtsi     |   4 +-
 .../boot/dts/mediatek/mt8183-kukui-kodama.dtsi     |   4 +-
 .../boot/dts/mediatek/mt8183-kukui-krane.dtsi      |   4 +-
 arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi     |   5 +
 arch/arm64/boot/dts/mediatek/mt8183.dtsi           |   4 +
 .../boot/dts/mediatek/mt8186-corsola-voltorb.dtsi  |  21 +-
 arch/arm64/boot/dts/mediatek/mt8186-corsola.dtsi   |   8 +-
 arch/arm64/boot/dts/mediatek/mt8188.dtsi           |   5 +-
 arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi    |   6 +-
 arch/arm64/boot/dts/mediatek/mt8195.dtsi           |   4 +-
 .../boot/dts/mediatek/mt8395-genio-1200-evk.dts    |   2 +-
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi     |   2 +-
 arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts       |   2 +-
 arch/arm64/boot/dts/qcom/sc8180x.dtsi              |   2 +-
 .../arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts |   2 +-
 arch/arm64/boot/dts/qcom/sm6350.dtsi               |  14 +-
 .../boot/dts/qcom/x1e80100-asus-vivobook-s15.dts   |   4 -
 .../boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts  |   4 -
 arch/arm64/boot/dts/qcom/x1e80100.dtsi             |   8 +-
 arch/arm64/boot/dts/renesas/hihope-rev2.dtsi       |   3 -
 arch/arm64/boot/dts/renesas/hihope-rev4.dtsi       |   3 -
 .../rk3568-wolfvision-pf5-io-expander.dtso         |   1 -
 .../boot/dts/rockchip/rk3588s-indiedroid-nova.dts  |   2 +-
 .../arm64/boot/dts/rockchip/rk3588s-orangepi-5.dts |   1 -
 arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi |   2 -
 .../boot/dts/ti/k3-j7200-common-proc-board.dts     |   2 +-
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi          |  38 +-
 arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi    |   6 +-
 arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi    |   6 +-
 arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi         |  16 +-
 arch/arm64/boot/dts/ti/k3-j721s2-mcu-wakeup.dtsi   |   6 +-
 arch/arm64/include/asm/insn.h                      |   1 +
 arch/arm64/include/asm/kvm_host.h                  |   2 -
 arch/arm64/kernel/cpufeature.c                     |   1 +
 arch/arm64/kernel/probes/decode-insn.c             |   7 +-
 arch/arm64/kernel/process.c                        |   2 +-
 arch/arm64/kernel/setup.c                          |   6 +-
 arch/arm64/kernel/vmlinux.lds.S                    |   6 +-
 arch/arm64/kvm/arch_timer.c                        |   3 +-
 arch/arm64/kvm/arm.c                               |  18 +-
 arch/arm64/kvm/mmio.c                              |  32 +-
 arch/arm64/kvm/pmu-emul.c                          |   1 -
 arch/arm64/kvm/vgic/vgic-its.c                     |  32 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   7 +-
 arch/arm64/kvm/vgic/vgic.h                         |  23 +
 arch/arm64/net/bpf_jit_comp.c                      |  47 +-
 arch/csky/kernel/setup.c                           |   4 +-
 arch/loongarch/Makefile                            |   4 +-
 arch/loongarch/kernel/setup.c                      |   2 +-
 arch/loongarch/net/bpf_jit.c                       |   2 +-
 arch/loongarch/vdso/Makefile                       |   2 +-
 arch/m68k/coldfire/device.c                        |   8 +-
 arch/m68k/include/asm/mcfgpio.h                    |   2 +-
 arch/m68k/include/asm/mvme147hw.h                  |   4 +-
 arch/m68k/kernel/early_printk.c                    |   5 +-
 arch/m68k/mvme147/config.c                         |  30 +
 arch/m68k/mvme147/mvme147.h                        |   6 +
 arch/microblaze/kernel/microblaze_ksyms.c          |  10 +
 arch/microblaze/kernel/prom.c                      |   2 +-
 arch/mips/include/asm/switch_to.h                  |   2 +-
 arch/mips/kernel/prom.c                            |   2 +-
 arch/mips/kernel/relocate.c                        |   2 +-
 arch/nios2/kernel/prom.c                           |   4 +-
 arch/openrisc/Kconfig                              |   3 +
 arch/openrisc/include/asm/fixmap.h                 |  21 +-
 arch/openrisc/kernel/prom.c                        |   2 +-
 arch/openrisc/mm/init.c                            |  37 +
 arch/parisc/kernel/ftrace.c                        |   2 +-
 arch/powerpc/crypto/Kconfig                        |   2 +-
 arch/powerpc/crypto/aes-gcm-p10-glue.c             | 141 +++-
 arch/powerpc/include/asm/dtl.h                     |   4 +-
 arch/powerpc/include/asm/fadump.h                  |   9 +
 arch/powerpc/include/asm/kvm_book3s_64.h           |   4 +-
 arch/powerpc/include/asm/sstep.h                   |   5 -
 arch/powerpc/include/asm/vdso.h                    |   1 +
 arch/powerpc/kernel/dt_cpu_ftrs.c                  |   2 +-
 arch/powerpc/kernel/fadump.c                       |  40 +-
 arch/powerpc/kernel/prom.c                         |   5 +-
 arch/powerpc/kernel/setup-common.c                 |   6 +-
 arch/powerpc/kernel/setup_64.c                     |   1 +
 arch/powerpc/kexec/file_load_64.c                  |   9 +-
 arch/powerpc/kvm/book3s_hv.c                       |  14 +-
 arch/powerpc/kvm/book3s_hv_nested.c                |  14 +-
 arch/powerpc/kvm/trace_hv.h                        |   2 +-
 arch/powerpc/lib/sstep.c                           |  12 +-
 arch/powerpc/mm/fault.c                            |  10 +-
 arch/powerpc/platforms/pseries/dtl.c               |   8 +-
 arch/powerpc/platforms/pseries/lpar.c              |   8 +-
 arch/powerpc/platforms/pseries/plpks.c             |   2 +-
 arch/riscv/include/asm/cpufeature.h                |   2 +
 arch/riscv/kernel/setup.c                          |   2 +-
 arch/riscv/kernel/traps_misaligned.c               |  14 +-
 arch/riscv/kernel/unaligned_access_speed.c         |   1 +
 arch/riscv/kvm/aia_aplic.c                         |   3 +-
 arch/riscv/kvm/vcpu_sbi.c                          |  11 +-
 arch/s390/include/asm/facility.h                   |  18 +-
 arch/s390/include/asm/pci.h                        |   4 +-
 arch/s390/include/asm/set_memory.h                 |   1 +
 arch/s390/kernel/perf_cpum_sf.c                    |   2 +-
 arch/s390/kernel/syscalls/Makefile                 |   2 +-
 arch/s390/mm/pageattr.c                            |  15 +
 arch/s390/pci/pci.c                                |  37 +-
 arch/s390/pci/pci_debug.c                          |  10 +-
 arch/sh/kernel/cpu/proc.c                          |   2 +-
 arch/sh/kernel/setup.c                             |   2 +-
 arch/um/drivers/net_kern.c                         |   2 +-
 arch/um/drivers/ubd_kern.c                         |   4 +-
 arch/um/drivers/vector_kern.c                      |   3 +-
 arch/um/kernel/dtb.c                               |   2 +-
 arch/um/kernel/physmem.c                           |   6 +-
 arch/um/kernel/process.c                           |   2 +-
 arch/um/kernel/sysrq.c                             |   2 +-
 arch/x86/coco/tdx/tdx.c                            | 111 ++-
 arch/x86/crypto/aegis128-aesni-asm.S               |  29 +-
 arch/x86/events/intel/pt.c                         |  11 +-
 arch/x86/events/intel/pt.h                         |   2 +
 arch/x86/include/asm/atomic64_32.h                 |   3 +-
 arch/x86/include/asm/cmpxchg_32.h                  |   6 +-
 arch/x86/include/asm/kvm_host.h                    |   4 +-
 arch/x86/include/asm/shared/tdx.h                  |  11 +-
 arch/x86/include/asm/tlb.h                         |   4 +
 arch/x86/kernel/cpu/amd.c                          |   1 +
 arch/x86/kernel/cpu/common.c                       |   4 +-
 arch/x86/kernel/cpu/microcode/amd.c                |  25 +-
 arch/x86/kernel/devicetree.c                       |   2 +-
 arch/x86/kernel/unwind_orc.c                       |   2 +-
 arch/x86/kvm/Kconfig                               |   5 +-
 arch/x86/kvm/mmu/mmu.c                             |  68 +-
 arch/x86/kvm/mmu/spte.c                            |  18 +-
 arch/x86/kvm/vmx/vmx.c                             |  54 +-
 arch/x86/mm/tlb.c                                  |   3 +-
 arch/x86/platform/pvh/head.S                       |   9 +-
 arch/xtensa/kernel/setup.c                         |   2 +-
 block/bfq-cgroup.c                                 |   1 +
 block/bfq-iosched.c                                |  43 +-
 block/blk-core.c                                   |  18 +-
 block/blk-merge.c                                  |  45 +-
 block/blk-mq.c                                     | 148 +++-
 block/blk-mq.h                                     |  13 +
 block/blk-settings.c                               |   7 +
 block/blk-sysfs.c                                  |   6 +-
 block/blk-zoned.c                                  |  14 +-
 block/blk.h                                        |  30 +-
 block/elevator.c                                   |  10 +-
 block/fops.c                                       |  25 +-
 block/genhd.c                                      |  24 +-
 crypto/pcrypt.c                                    |  12 +-
 drivers/accel/ivpu/ivpu_ipc.c                      |  35 +-
 drivers/accel/ivpu/ivpu_ipc.h                      |   7 +-
 drivers/accel/ivpu/ivpu_jsm_msg.c                  |  19 +-
 drivers/acpi/arm64/gtdt.c                          |   2 +-
 drivers/acpi/cppc_acpi.c                           |   1 -
 drivers/base/firmware_loader/main.c                |   5 +-
 drivers/base/regmap/regmap-irq.c                   |   4 +
 drivers/base/trace.h                               |   6 +-
 drivers/block/brd.c                                |  70 +-
 drivers/block/loop.c                               |   6 +-
 drivers/block/ublk_drv.c                           |  17 +-
 drivers/block/virtio_blk.c                         |  46 +-
 drivers/block/zram/Kconfig                         |   1 +
 drivers/block/zram/zram_drv.c                      |  21 +-
 drivers/block/zram/zram_drv.h                      |   1 +
 drivers/bluetooth/btbcm.c                          |   4 +-
 drivers/bluetooth/btintel.c                        |  62 +-
 drivers/bluetooth/btintel.h                        |   7 +
 drivers/bluetooth/btintel_pcie.c                   | 265 +++++-
 drivers/bluetooth/btintel_pcie.h                   |  16 +-
 drivers/bluetooth/btmtk.c                          |   1 -
 drivers/bluetooth/btusb.c                          |   1 +
 drivers/bus/mhi/host/trace.h                       |  25 +-
 drivers/clk/.kunitconfig                           |   1 +
 drivers/clk/Kconfig                                |   2 -
 drivers/clk/clk-apple-nco.c                        |   3 +
 drivers/clk/clk-axi-clkgen.c                       |  22 +-
 drivers/clk/clk-en7523.c                           | 270 +++++--
 drivers/clk/clk-loongson2.c                        |   6 +-
 drivers/clk/imx/clk-fracn-gppll.c                  |  10 +-
 drivers/clk/imx/clk-imx8-acm.c                     |   4 +-
 drivers/clk/imx/clk-lpcg-scu.c                     |  37 +-
 drivers/clk/imx/clk-scu.c                          |   2 +-
 drivers/clk/mediatek/Kconfig                       |  15 -
 drivers/clk/qcom/Kconfig                           |   4 +-
 drivers/clk/ralink/clk-mtmips.c                    |  26 +-
 drivers/clk/renesas/rzg2l-cpg.c                    |  11 +-
 drivers/clk/sophgo/clk-sg2042-pll.c                |   2 +-
 drivers/clk/sunxi-ng/ccu-sun20i-d1.c               |   2 +-
 drivers/clocksource/Kconfig                        |   3 +-
 drivers/clocksource/timer-ti-dm-systimer.c         |   4 +-
 drivers/comedi/comedi_fops.c                       |  12 +
 drivers/counter/stm32-timer-cnt.c                  |  17 +-
 drivers/counter/ti-ecap-capture.c                  |   7 +-
 drivers/cpufreq/amd-pstate.c                       |  26 +-
 drivers/cpufreq/cppc_cpufreq.c                     |  63 +-
 drivers/cpufreq/loongson2_cpufreq.c                |   4 +-
 drivers/cpufreq/loongson3_cpufreq.c                |   7 +-
 drivers/cpufreq/mediatek-cpufreq-hw.c              |   2 +-
 drivers/crypto/bcm/cipher.c                        |   5 +-
 drivers/crypto/caam/caampkc.c                      |  11 +-
 drivers/crypto/caam/qi.c                           |   2 +-
 drivers/crypto/cavium/cpt/cptpf_main.c             |   6 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c          |  35 +-
 drivers/crypto/hisilicon/qm.c                      |  47 +-
 drivers/crypto/hisilicon/sec2/sec_main.c           |  35 +-
 drivers/crypto/hisilicon/zip/zip_main.c            |  35 +-
 drivers/crypto/inside-secure/safexcel_hash.c       |   2 +-
 .../crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c |   2 +-
 .../crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c   |   2 +-
 drivers/crypto/intel/qat/qat_common/adf_aer.c      |   5 +-
 drivers/crypto/intel/qat/qat_common/adf_dbgfs.c    |  13 +-
 .../crypto/intel/qat/qat_common/adf_hw_arbiter.c   |   4 -
 drivers/crypto/mxs-dcp.c                           |  20 +-
 drivers/dax/pmem/Makefile                          |   7 -
 drivers/dax/pmem/pmem.c                            |  10 -
 drivers/dma-buf/Kconfig                            |   1 +
 drivers/dma-buf/udmabuf.c                          |  44 +-
 drivers/edac/bluefield_edac.c                      |   2 +-
 drivers/edac/fsl_ddr_edac.c                        |  22 +-
 drivers/edac/i10nm_base.c                          |   1 +
 drivers/edac/igen6_edac.c                          |   2 +
 drivers/edac/skx_common.c                          |  57 +-
 drivers/edac/skx_common.h                          |   8 +
 drivers/firmware/arm_scpi.c                        |   3 +
 drivers/firmware/efi/libstub/efi-stub.c            |   2 +-
 drivers/firmware/efi/tpm.c                         |  17 +-
 drivers/firmware/google/gsmi.c                     |   6 +-
 drivers/gpio/gpio-exar.c                           |  10 +-
 drivers/gpio/gpio-zevio.c                          |   6 +
 drivers/gpu/drm/Kconfig                            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |  63 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c              |   7 +
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   2 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c           |  18 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |  14 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  32 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |   3 +
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |   4 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |  11 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  15 +-
 .../gpu/drm/amd/display/dc/core/dc_hw_sequencer.c  |   3 +
 .../drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c    |   6 +-
 drivers/gpu/drm/bridge/analogix/anx7625.c          |   2 +
 drivers/gpu/drm/bridge/ite-it6505.c                |   2 +
 drivers/gpu/drm/bridge/tc358767.c                  |   7 +
 drivers/gpu/drm/drm_file.c                         |   2 +-
 drivers/gpu/drm/drm_mm.c                           |   2 +-
 drivers/gpu/drm/etnaviv/etnaviv_drv.c              |  10 +
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |  28 +-
 drivers/gpu/drm/fsl-dcu/Kconfig                    |   1 +
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c          |  15 +
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.h          |   3 +
 drivers/gpu/drm/imagination/pvr_ccb.c              |   2 +-
 drivers/gpu/drm/imagination/pvr_vm.c               |   4 +-
 drivers/gpu/drm/imx/dcss/dcss-crtc.c               |   6 +-
 drivers/gpu/drm/imx/ipuv3/Kconfig                  |  11 +-
 drivers/gpu/drm/imx/ipuv3/imx-ldb.c                | 122 +--
 drivers/gpu/drm/imx/ipuv3/ipuv3-crtc.c             |   6 +-
 drivers/gpu/drm/imx/ipuv3/parallel-display.c       |  51 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |   4 +-
 .../drm/msm/disp/dpu1/catalog/dpu_3_0_msm8998.h    |  12 -
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_4_0_sdm845.h |  14 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c      |   2 +-
 drivers/gpu/drm/msm/msm_gpu_devfreq.c              |   9 +-
 drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c     |   1 +
 drivers/gpu/drm/omapdrm/dss/base.c                 |  25 +-
 drivers/gpu/drm/omapdrm/dss/omapdss.h              |   3 +-
 drivers/gpu/drm/omapdrm/omap_drv.c                 |   4 +-
 drivers/gpu/drm/omapdrm/omap_gem.c                 |  10 +-
 drivers/gpu/drm/panel/panel-newvision-nv3052c.c    |   2 +-
 drivers/gpu/drm/panel/panel-novatek-nt35510.c      |  15 +-
 drivers/gpu/drm/panfrost/panfrost_devfreq.c        |   3 +-
 drivers/gpu/drm/panfrost/panfrost_gpu.c            |   1 -
 drivers/gpu/drm/panthor/panthor_devfreq.c          |  29 +-
 drivers/gpu/drm/panthor/panthor_device.h           |  28 +
 drivers/gpu/drm/panthor/panthor_sched.c            | 351 ++++++--
 drivers/gpu/drm/radeon/radeon_audio.c              |  12 +-
 drivers/gpu/drm/v3d/v3d_drv.h                      |   1 +
 drivers/gpu/drm/v3d/v3d_irq.c                      |   2 +
 drivers/gpu/drm/v3d/v3d_mmu.c                      |  31 +-
 drivers/gpu/drm/v3d/v3d_sched.c                    |  44 +-
 drivers/gpu/drm/vc4/tests/vc4_mock.c               |  12 +-
 drivers/gpu/drm/vc4/vc4_bo.c                       |  28 +-
 drivers/gpu/drm/vc4/vc4_crtc.c                     |  13 +-
 drivers/gpu/drm/vc4/vc4_drv.c                      |  22 +-
 drivers/gpu/drm/vc4/vc4_drv.h                      |   8 +-
 drivers/gpu/drm/vc4/vc4_gem.c                      |  24 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |  22 +-
 drivers/gpu/drm/vc4/vc4_hvs.c                      |  64 +-
 drivers/gpu/drm/vc4/vc4_irq.c                      |  10 +-
 drivers/gpu/drm/vc4/vc4_kms.c                      |  14 +-
 drivers/gpu/drm/vc4/vc4_perfmon.c                  |  20 +-
 drivers/gpu/drm/vc4/vc4_plane.c                    |  12 +-
 drivers/gpu/drm/vc4/vc4_render_cl.c                |   2 +-
 drivers/gpu/drm/vc4/vc4_v3d.c                      |  10 +-
 drivers/gpu/drm/vc4/vc4_validate.c                 |   8 +-
 drivers/gpu/drm/vc4/vc4_validate_shaders.c         |   2 +-
 drivers/gpu/drm/vkms/vkms_output.c                 |   5 +-
 drivers/gpu/drm/xe/display/xe_hdcp_gsc.c           |   2 +-
 drivers/gpu/drm/xe/xe_sync.c                       |   6 +-
 drivers/gpu/drm/xlnx/zynqmp_disp.c                 |   3 +
 drivers/gpu/drm/xlnx/zynqmp_kms.c                  |   2 +-
 drivers/hid/hid-hyperv.c                           |  58 +-
 drivers/hid/wacom_wac.c                            |   4 +-
 drivers/hwmon/aquacomputer_d5next.c                |   2 +-
 drivers/hwmon/nct6775-core.c                       |   7 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |  12 +-
 drivers/hwmon/tps23861.c                           |   2 +-
 drivers/i2c/i2c-dev.c                              |  17 +-
 drivers/i3c/master.c                               |  13 +-
 drivers/iio/accel/adxl380.c                        |   2 +-
 drivers/iio/adc/ad4000.c                           |   6 +-
 drivers/iio/adc/pac1921.c                          |   4 +-
 drivers/iio/dac/adi-axi-dac.c                      |   2 +-
 drivers/iio/industrialio-backend.c                 |   4 +-
 drivers/iio/industrialio-gts-helper.c              |   2 +-
 drivers/iio/light/al3010.c                         |  11 +-
 drivers/infiniband/core/roce_gid_mgmt.c            |  30 +-
 drivers/infiniband/core/uverbs.h                   |   2 +
 drivers/infiniband/core/uverbs_main.c              |  43 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   7 +-
 drivers/infiniband/hw/bnxt_re/main.c               |  28 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |   2 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c            |   4 +-
 drivers/infiniband/hw/hns/hns_roce_debugfs.c       |   3 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |  14 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c           |  48 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         | 257 +++---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   8 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   7 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c            |  11 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |  79 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c           |   4 +-
 drivers/infiniband/hw/mlx5/main.c                  |  69 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   2 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   1 +
 drivers/infiniband/sw/rxe/rxe_req.c                |   6 +-
 drivers/input/misc/cs40l50-vibra.c                 |   6 +-
 drivers/interconnect/qcom/icc-rpmh.c               |   3 +
 drivers/iommu/amd/io_pgtable_v2.c                  |   3 +
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c     |   5 +-
 drivers/iommu/intel/iommu.c                        |  40 +-
 drivers/iommu/s390-iommu.c                         |  75 +-
 drivers/irqchip/irq-mvebu-sei.c                    |   2 +-
 drivers/irqchip/irq-riscv-aplic-main.c             |   3 +-
 drivers/irqchip/irq-riscv-aplic-msi.c              |   3 +
 drivers/leds/flash/leds-ktd2692.c                  |   1 +
 drivers/leds/leds-max5970.c                        |   5 +-
 drivers/mailbox/arm_mhuv2.c                        |   8 +-
 drivers/mailbox/mtk-cmdq-mailbox.c                 |   2 +-
 drivers/mailbox/omap-mailbox.c                     |   1 +
 drivers/media/i2c/adv7604.c                        |   5 +-
 drivers/media/i2c/adv7842.c                        |  13 +-
 drivers/media/i2c/ds90ub960.c                      |   2 +-
 drivers/media/i2c/max96717.c                       |   6 +-
 drivers/media/i2c/vgxy61.c                         |   2 +-
 drivers/media/pci/intel/ipu6/Kconfig               |   6 -
 drivers/media/pci/intel/ipu6/ipu6-bus.c            |   6 -
 drivers/media/pci/intel/ipu6/ipu6-buttress.c       |  34 +-
 drivers/media/pci/intel/ipu6/ipu6-cpd.c            |  18 +-
 drivers/media/pci/intel/ipu6/ipu6-dma.c            | 202 +++--
 drivers/media/pci/intel/ipu6/ipu6-dma.h            |  34 +-
 drivers/media/pci/intel/ipu6/ipu6-fw-com.c         |  14 +-
 drivers/media/pci/intel/ipu6/ipu6-mmu.c            |  28 +-
 drivers/media/pci/intel/ipu6/ipu6.c                |   3 +
 drivers/media/platform/qcom/venus/vdec.c           |  19 +-
 drivers/media/platform/qcom/venus/venc.c           |  18 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |   3 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |  15 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          | 132 +--
 drivers/message/fusion/mptsas.c                    |   4 +-
 drivers/mfd/da9052-spi.c                           |   2 +-
 drivers/mfd/intel_soc_pmic_bxtwc.c                 | 144 ++--
 drivers/mfd/rt5033.c                               |   4 +-
 drivers/mfd/tps65010.c                             |   8 +-
 drivers/misc/apds990x.c                            |  12 +-
 drivers/misc/lkdtm/bugs.c                          |   2 +-
 drivers/mmc/host/mmc_spi.c                         |   9 +-
 drivers/mtd/hyperbus/rpc-if.c                      |   7 +
 drivers/mtd/nand/raw/atmel/pmecc.c                 |   8 +-
 drivers/mtd/nand/raw/atmel/pmecc.h                 |   2 -
 drivers/mtd/spi-nor/core.c                         |   2 +-
 drivers/mtd/spi-nor/spansion.c                     |   1 +
 drivers/mtd/ubi/attach.c                           |  12 +-
 drivers/mtd/ubi/fastmap-wl.c                       |  19 +-
 drivers/mtd/ubi/vmt.c                              |   2 +
 drivers/mtd/ubi/wl.c                               |  11 +-
 drivers/mtd/ubi/wl.h                               |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  37 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   9 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h      |   3 +-
 drivers/net/ethernet/broadcom/tg3.c                |   3 +
 drivers/net/ethernet/google/gve/gve_adminq.c       |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   2 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |  21 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  70 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |   5 +
 .../ethernet/marvell/octeontx2/af/lmac_common.h    |   7 +-
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c    |  87 +-
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h    |  18 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  45 +-
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c |   5 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   4 +
 .../ethernet/marvell/octeontx2/nic/otx2_dcbnl.c    |   5 +
 .../ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c |   9 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  10 +
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |  10 +
 drivers/net/ethernet/marvell/pxa168_eth.c          |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |  12 +
 drivers/net/ethernet/meta/fbnic/fbnic_pci.c        |   2 -
 .../net/ethernet/microchip/vcap/vcap_api_kunit.c   |  17 +-
 drivers/net/ethernet/realtek/rtase/rtase.h         |   7 +-
 drivers/net/ethernet/realtek/rtase/rtase_main.c    |  43 +-
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |   2 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c     |  24 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c    |   1 -
 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c     | 168 +---
 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h     |   2 -
 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h    |   7 +-
 drivers/net/mdio/mdio-ipq4019.c                    |   5 +-
 drivers/net/netdevsim/ipsec.c                      |  11 +-
 drivers/net/usb/lan78xx.c                          |  42 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   4 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |   3 +
 drivers/net/wireless/ath/ath12k/dp.c               |  19 +-
 drivers/net/wireless/ath/ath12k/mac.c              |   5 +-
 drivers/net/wireless/ath/ath12k/wow.c              |   2 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |   3 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |   3 +-
 drivers/net/wireless/intel/iwlegacy/3945.c         |   2 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   8 +-
 drivers/net/wireless/intersil/p54/p54spi.c         |   4 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |   2 +
 drivers/net/wireless/marvell/mwifiex/fw.h          |   2 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |   4 +-
 drivers/net/wireless/marvell/mwifiex/util.c        |   2 +
 drivers/net/wireless/microchip/wilc1000/netdev.c   |   6 +-
 drivers/net/wireless/realtek/rtl8xxxu/core.c       |   6 +-
 drivers/net/wireless/realtek/rtlwifi/efuse.c       |  11 +-
 drivers/net/wireless/realtek/rtw89/cam.c           | 259 ++++--
 drivers/net/wireless/realtek/rtw89/cam.h           |  24 +-
 drivers/net/wireless/realtek/rtw89/chan.c          | 219 +++--
 drivers/net/wireless/realtek/rtw89/chan.h          |   4 +-
 drivers/net/wireless/realtek/rtw89/coex.c          | 157 ++--
 drivers/net/wireless/realtek/rtw89/coex.h          |   6 +-
 drivers/net/wireless/realtek/rtw89/core.c          | 887 ++++++++++++++-------
 drivers/net/wireless/realtek/rtw89/core.h          | 421 +++++++---
 drivers/net/wireless/realtek/rtw89/debug.c         | 127 ++-
 drivers/net/wireless/realtek/rtw89/fw.c            | 637 ++++++++-------
 drivers/net/wireless/realtek/rtw89/fw.h            | 192 +++--
 drivers/net/wireless/realtek/rtw89/mac.c           | 698 +++++++++-------
 drivers/net/wireless/realtek/rtw89/mac.h           |  98 ++-
 drivers/net/wireless/realtek/rtw89/mac80211.c      | 657 ++++++++++++---
 drivers/net/wireless/realtek/rtw89/mac_be.c        |  69 +-
 drivers/net/wireless/realtek/rtw89/phy.c           | 401 ++++++----
 drivers/net/wireless/realtek/rtw89/phy.h           |   7 +-
 drivers/net/wireless/realtek/rtw89/ps.c            | 109 ++-
 drivers/net/wireless/realtek/rtw89/ps.h            |  14 +-
 drivers/net/wireless/realtek/rtw89/regd.c          |  79 +-
 drivers/net/wireless/realtek/rtw89/rtw8851b.c      |  13 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |  12 +-
 drivers/net/wireless/realtek/rtw89/rtw8852b.c      |  13 +-
 drivers/net/wireless/realtek/rtw89/rtw8852bt.c     |  13 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |  12 +-
 drivers/net/wireless/realtek/rtw89/rtw8922a.c      |  10 +-
 drivers/net/wireless/realtek/rtw89/ser.c           |  37 +-
 drivers/net/wireless/realtek/rtw89/wow.c           | 217 ++---
 drivers/net/wireless/realtek/rtw89/wow.h           |  10 +-
 drivers/net/wireless/silabs/wfx/main.c             |  17 +-
 drivers/net/wireless/st/cw1200/cw1200_spi.c        |   2 +-
 drivers/nvme/host/core.c                           |   5 +
 drivers/nvme/host/multipath.c                      |  21 +-
 drivers/nvme/host/pci.c                            |  55 +-
 drivers/of/fdt.c                                   |  14 +-
 drivers/of/kexec.c                                 |   2 +-
 drivers/pci/controller/cadence/pci-j721e.c         |  26 +-
 drivers/pci/controller/dwc/pcie-qcom-ep.c          |   6 +-
 drivers/pci/controller/dwc/pcie-qcom.c             |   4 +-
 drivers/pci/controller/dwc/pcie-tegra194.c         |   7 +-
 drivers/pci/endpoint/functions/pci-epf-mhi.c       |   6 +
 drivers/pci/hotplug/cpqphp_pci.c                   |  15 +-
 drivers/pci/pci.c                                  |   5 +-
 drivers/pci/slot.c                                 |   4 +-
 drivers/perf/arm-cmn.c                             |   4 +-
 drivers/perf/arm_smmuv3_pmu.c                      |  19 +-
 drivers/phy/phy-airoha-pcie-regs.h                 |   6 +-
 drivers/phy/phy-airoha-pcie.c                      |   8 +-
 drivers/phy/realtek/phy-rtk-usb2.c                 |   2 +
 drivers/phy/realtek/phy-rtk-usb3.c                 |   2 +
 drivers/pinctrl/pinctrl-k210.c                     |   2 +-
 drivers/pinctrl/pinctrl-zynqmp.c                   |   1 -
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           |   2 +-
 drivers/pinctrl/renesas/Kconfig                    |   1 +
 drivers/pinctrl/renesas/pinctrl-rzg2l.c            |   2 +-
 drivers/platform/chrome/cros_ec_typec.c            |   1 +
 drivers/platform/x86/asus-wmi.c                    |  64 +-
 drivers/platform/x86/intel/bxtwc_tmu.c             |  22 +-
 drivers/platform/x86/intel/pmt/class.c             |   8 +-
 drivers/platform/x86/intel/pmt/class.h             |   2 +-
 drivers/platform/x86/intel/pmt/telemetry.c         |   2 +-
 drivers/platform/x86/panasonic-laptop.c            |  10 +-
 drivers/pmdomain/ti/ti_sci_pm_domains.c            |   4 +
 drivers/power/reset/Kconfig                        |   1 +
 drivers/power/sequencing/Kconfig                   |   1 +
 drivers/power/supply/bq27xxx_battery.c             |  37 +-
 drivers/power/supply/power_supply_core.c           |   2 -
 drivers/power/supply/rt9471.c                      |  52 +-
 drivers/pwm/core.c                                 |  10 +-
 drivers/pwm/pwm-imx27.c                            |  98 ++-
 drivers/regulator/qcom_smd-regulator.c             |   2 +-
 drivers/regulator/rk808-regulator.c                |  15 +-
 drivers/remoteproc/Kconfig                         |   6 +-
 drivers/remoteproc/qcom_q6v5_adsp.c                |  11 +-
 drivers/remoteproc/qcom_q6v5_mss.c                 |   6 +-
 drivers/remoteproc/qcom_q6v5_pas.c                 |  22 +-
 drivers/rpmsg/qcom_glink_native.c                  |   3 +-
 drivers/rtc/interface.c                            |   7 +-
 drivers/rtc/rtc-ab-eoz9.c                          |   7 -
 drivers/rtc/rtc-abx80x.c                           |   2 +-
 drivers/rtc/rtc-rzn1.c                             |   8 +-
 drivers/rtc/rtc-st-lpc.c                           |   5 +-
 drivers/s390/cio/cio.c                             |   6 +-
 drivers/s390/cio/device.c                          |  18 +-
 drivers/s390/virtio/virtio_ccw.c                   |   4 +
 drivers/scsi/bfa/bfad.c                            |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   8 +-
 drivers/scsi/qedf/qedf_main.c                      |   1 +
 drivers/scsi/qedi/qedi_main.c                      |   1 +
 drivers/scsi/sg.c                                  |   9 +-
 drivers/sh/intc/core.c                             |   2 +-
 drivers/soc/fsl/qe/qmc.c                           |   4 +-
 drivers/soc/fsl/rcpm.c                             |   1 +
 drivers/soc/qcom/qcom-geni-se.c                    |   3 +-
 drivers/soc/ti/smartreflex.c                       |   4 +-
 drivers/soc/xilinx/xlnx_event_manager.c            |   4 +-
 drivers/spi/atmel-quadspi.c                        |   2 +-
 drivers/spi/spi-fsl-lpspi.c                        |  12 +-
 drivers/spi/spi-tegra210-quad.c                    |   2 +-
 drivers/spi/spi-zynqmp-gqspi.c                     |   2 +
 drivers/spi/spi.c                                  |  13 +-
 drivers/staging/media/atomisp/pci/sh_css_params.c  |   2 +
 .../vc04_services/interface/vchiq_arm/vchiq_arm.c  |   6 +-
 drivers/target/target_core_pscsi.c                 |   2 +-
 drivers/thermal/testing/zone.c                     |  32 +-
 drivers/thermal/thermal_core.c                     | 123 +--
 drivers/thermal/thermal_core.h                     |  12 +-
 drivers/tty/serial/8250/8250_fintek.c              |  14 +-
 drivers/tty/serial/8250/8250_omap.c                |   4 +-
 drivers/tty/serial/amba-pl011.c                    |   7 +
 drivers/tty/tty_io.c                               |   2 +-
 drivers/usb/dwc3/core.h                            |   4 +
 drivers/usb/dwc3/ep0.c                             |   2 +-
 drivers/usb/dwc3/gadget.c                          |  69 +-
 drivers/usb/gadget/composite.c                     |  18 +-
 drivers/usb/gadget/function/uvc_video.c            |   4 +
 drivers/usb/host/ehci-spear.c                      |   7 +-
 drivers/usb/host/xhci-pci.c                        |  10 +-
 drivers/usb/host/xhci-ring.c                       |  73 +-
 drivers/usb/host/xhci.c                            |  40 +-
 drivers/usb/host/xhci.h                            |   3 +
 drivers/usb/misc/chaoskey.c                        |  35 +-
 drivers/usb/misc/iowarrior.c                       |  50 +-
 drivers/usb/misc/usb-ljca.c                        |  20 +-
 drivers/usb/misc/yurex.c                           |   5 +-
 drivers/usb/musb/musb_gadget.c                     |  13 +-
 drivers/usb/typec/tcpm/wcove.c                     |   4 -
 drivers/usb/typec/ucsi/ucsi_ccg.c                  |   5 +
 drivers/usb/typec/ucsi/ucsi_glink.c                |   2 +-
 drivers/vdpa/mlx5/core/mr.c                        |   4 +-
 drivers/vfio/pci/mlx5/cmd.c                        |   6 +-
 drivers/vfio/pci/mlx5/main.c                       |  35 +-
 drivers/vfio/pci/vfio_pci_config.c                 |  16 +-
 drivers/video/fbdev/sh7760fb.c                     |   3 +-
 drivers/watchdog/Kconfig                           |   4 +-
 drivers/xen/xenbus/xenbus_probe.c                  |   8 +-
 fs/binfmt_elf.c                                    |   2 +
 fs/binfmt_elf_fdpic.c                              |   5 +-
 fs/binfmt_misc.c                                   |   7 +-
 fs/cachefiles/interface.c                          |  14 +-
 fs/cachefiles/ondemand.c                           |  38 +-
 fs/dlm/ast.c                                       |   2 +-
 fs/dlm/recoverd.c                                  |   2 +-
 fs/efs/super.c                                     |  43 +-
 fs/erofs/data.c                                    |  10 +-
 fs/erofs/internal.h                                |   1 +
 fs/erofs/super.c                                   |   6 +-
 fs/erofs/zmap.c                                    |  17 +-
 fs/exec.c                                          |  23 +-
 fs/exfat/file.c                                    |  10 +
 fs/exfat/namei.c                                   |  21 +-
 fs/ext4/balloc.c                                   |   4 +-
 fs/ext4/ext4.h                                     |  12 +-
 fs/ext4/extents.c                                  |   2 +-
 fs/ext4/fsmap.c                                    |  54 +-
 fs/ext4/ialloc.c                                   |   5 +-
 fs/ext4/indirect.c                                 |   2 +-
 fs/ext4/inode.c                                    |   4 +-
 fs/ext4/mballoc.c                                  |  18 +-
 fs/ext4/mballoc.h                                  |   1 +
 fs/ext4/mmp.c                                      |   2 +-
 fs/ext4/move_extent.c                              |   2 +-
 fs/ext4/resize.c                                   |   2 +-
 fs/ext4/super.c                                    |  42 +-
 fs/f2fs/checkpoint.c                               |   2 +-
 fs/f2fs/data.c                                     |  29 +-
 fs/f2fs/f2fs.h                                     |   3 +-
 fs/f2fs/file.c                                     |  17 +-
 fs/f2fs/gc.c                                       |   2 +
 fs/f2fs/node.c                                     |  10 +
 fs/f2fs/segment.c                                  |   5 +-
 fs/f2fs/segment.h                                  |  35 +-
 fs/f2fs/super.c                                    |  37 +-
 fs/fcntl.c                                         |   3 +
 fs/fuse/file.c                                     |  62 +-
 fs/fuse/fuse_i.h                                   |   6 +
 fs/fuse/virtio_fs.c                                |   1 +
 fs/gfs2/glock.c                                    |  19 +-
 fs/gfs2/glock.h                                    |   1 +
 fs/gfs2/incore.h                                   |   2 +-
 fs/gfs2/rgrp.c                                     |   2 +-
 fs/gfs2/super.c                                    |   2 +-
 fs/hfsplus/hfsplus_fs.h                            |   3 +-
 fs/hfsplus/wrapper.c                               |   2 +
 fs/hostfs/hostfs_kern.c                            |   4 +-
 fs/isofs/inode.c                                   |   8 +-
 fs/jffs2/erase.c                                   |   7 +-
 fs/jfs/xattr.c                                     |   2 +-
 fs/netfs/fscache_volume.c                          |   3 +-
 fs/nfs/blocklayout/blocklayout.c                   |  15 +-
 fs/nfs/blocklayout/dev.c                           |   6 +-
 fs/nfs/internal.h                                  |   2 +-
 fs/nfs/localio.c                                   |   6 +
 fs/nfs/nfs4proc.c                                  |   8 +-
 fs/nfs/write.c                                     |  49 +-
 fs/nfs_common/nfslocalio.c                         |   8 +-
 fs/nfsd/export.c                                   |  31 +-
 fs/nfsd/export.h                                   |   4 +-
 fs/nfsd/filecache.c                                |  14 +-
 fs/nfsd/filecache.h                                |   2 +-
 fs/nfsd/nfs4callback.c                             |  16 +-
 fs/nfsd/nfs4proc.c                                 |   7 +-
 fs/nfsd/nfs4recover.c                              |   3 +-
 fs/nfsd/nfs4state.c                                |   5 +-
 fs/nfsd/nfs4xdr.c                                  |   2 +-
 fs/nfsd/nfsfh.c                                    |  20 +-
 fs/nfsd/nfsfh.h                                    |   3 +-
 fs/notify/fsnotify.c                               |  23 +-
 fs/notify/mark.c                                   |  12 +-
 fs/ntfs3/file.c                                    |   2 +-
 fs/ocfs2/aops.h                                    |   2 +
 fs/ocfs2/file.c                                    |   4 +
 fs/proc/kcore.c                                    |  10 +-
 fs/read_write.c                                    |  15 +-
 fs/smb/client/cached_dir.c                         | 229 ++++--
 fs/smb/client/cached_dir.h                         |   6 +-
 fs/smb/client/cifsacl.c                            |  50 +-
 fs/smb/client/cifsfs.c                             |  12 +-
 fs/smb/client/cifsglob.h                           |   4 +-
 fs/smb/client/cifsproto.h                          |   5 +-
 fs/smb/client/connect.c                            |  59 +-
 fs/smb/client/fs_context.c                         |  85 +-
 fs/smb/client/fs_context.h                         |   1 +
 fs/smb/client/inode.c                              |   8 +-
 fs/smb/client/reparse.c                            |  95 ++-
 fs/smb/client/reparse.h                            |   6 +-
 fs/smb/client/smb1ops.c                            |   4 +-
 fs/smb/client/smb2file.c                           |  21 +-
 fs/smb/client/smb2inode.c                          |   6 +-
 fs/smb/client/smb2ops.c                            |   2 +-
 fs/smb/client/smb2pdu.c                            |   6 +-
 fs/smb/client/smb2proto.h                          |  11 +-
 fs/smb/client/smb2transport.c                      |  56 +-
 fs/smb/client/trace.h                              |   3 +
 fs/smb/server/server.c                             |   4 +
 fs/ubifs/super.c                                   |   6 +-
 fs/ubifs/tnc_commit.c                              |   2 +
 fs/unicode/utf8-core.c                             |   2 +-
 fs/xfs/xfs_bmap_util.c                             |   8 +-
 include/asm-generic/vmlinux.lds.h                  |   4 +-
 include/kunit/skbuff.h                             |   2 +-
 include/linux/blk-mq.h                             |   2 +
 include/linux/blkdev.h                             |  12 +-
 include/linux/bpf.h                                |   9 +-
 include/linux/cleanup.h                            |   4 +-
 include/linux/compiler_attributes.h                |  13 -
 include/linux/compiler_types.h                     |  19 +
 include/linux/f2fs_fs.h                            |   6 +-
 include/linux/fs.h                                 |   2 +-
 include/linux/hisi_acc_qm.h                        |   8 +-
 include/linux/intel_vsec.h                         |   3 +-
 include/linux/jiffies.h                            |   2 +-
 include/linux/kfifo.h                              |   1 -
 include/linux/kvm_host.h                           |   6 -
 include/linux/lockdep.h                            |   2 +-
 include/linux/mmdebug.h                            |   6 +-
 include/linux/netpoll.h                            |   2 +-
 include/linux/nfslocalio.h                         |  18 +-
 include/linux/of_fdt.h                             |   5 +-
 include/linux/once.h                               |   4 +-
 include/linux/once_lite.h                          |   2 +-
 include/linux/rcupdate.h                           |   2 +-
 include/linux/rwlock_rt.h                          |  10 +-
 include/linux/sched/ext.h                          |   1 -
 include/linux/seqlock.h                            |  98 ++-
 include/linux/spinlock_rt.h                        |  23 +-
 include/media/v4l2-dv-timings.h                    |  18 +-
 include/net/bluetooth/hci.h                        |   4 +-
 include/net/bluetooth/hci_core.h                   |  63 ++
 include/net/net_debug.h                            |   2 +-
 include/rdma/ib_verbs.h                            |  11 +
 include/uapi/linux/rtnetlink.h                     |   2 +-
 init/Kconfig                                       |   9 +
 init/initramfs.c                                   |  15 +
 io_uring/memmap.c                                  |  11 +-
 ipc/namespace.c                                    |   4 +-
 kernel/bpf/bpf_struct_ops.c                        | 114 ++-
 kernel/bpf/btf.c                                   |   5 +-
 kernel/bpf/dispatcher.c                            |   3 +-
 kernel/bpf/trampoline.c                            |   9 +-
 kernel/bpf/verifier.c                              | 103 ++-
 kernel/cgroup/cgroup.c                             |  21 +-
 kernel/fork.c                                      |  26 +-
 kernel/rcu/rcuscale.c                              |   6 +-
 kernel/rcu/srcutiny.c                              |   2 +-
 kernel/rcu/tree.c                                  |  14 +-
 kernel/rcu/tree_nocb.h                             |  13 +-
 kernel/sched/cpufreq_schedutil.c                   |   3 +-
 kernel/sched/ext.c                                 |   9 +-
 kernel/time/time.c                                 |   4 +-
 kernel/time/timer.c                                |   3 +-
 kernel/trace/bpf_trace.c                           |   5 +-
 kernel/trace/trace_event_perf.c                    |   6 +
 lib/overflow_kunit.c                               |   2 +-
 lib/string_helpers.c                               |   2 +-
 lib/strncpy_from_user.c                            |   5 +-
 mm/internal.h                                      |   2 +-
 net/9p/trans_usbg.c                                |   4 +-
 net/9p/trans_xen.c                                 |   9 +-
 net/bluetooth/hci_conn.c                           | 225 ++++--
 net/bluetooth/hci_event.c                          |  39 +-
 net/bluetooth/hci_sysfs.c                          |  15 +-
 net/bluetooth/iso.c                                | 101 ++-
 net/bluetooth/mgmt.c                               |  38 +-
 net/bluetooth/rfcomm/sock.c                        |  10 +-
 net/core/filter.c                                  |  88 +-
 net/core/netdev-genl.c                             |   2 +
 net/core/skmsg.c                                   |   4 +-
 net/hsr/hsr_device.c                               |   4 +-
 net/ipv4/inet_connection_sock.c                    |   2 +-
 net/ipv4/ipmr.c                                    |  44 +-
 net/ipv6/addrconf.c                                |  41 +-
 net/ipv6/ip6_fib.c                                 |   8 +-
 net/ipv6/ip6mr.c                                   |  40 +-
 net/ipv6/route.c                                   |  51 +-
 net/iucv/af_iucv.c                                 |  26 +-
 net/l2tp/l2tp_core.c                               |  22 +-
 net/llc/af_llc.c                                   |   2 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c             |   7 +-
 net/netfilter/nf_tables_api.c                      |  62 +-
 net/netlink/af_netlink.c                           |  21 +-
 net/rfkill/rfkill-gpio.c                           |   8 +-
 net/rxrpc/af_rxrpc.c                               |   7 +-
 net/sched/sch_fq.c                                 |   6 +
 net/sunrpc/cache.c                                 |   4 +-
 net/sunrpc/svcsock.c                               |   4 +
 net/sunrpc/xprtrdma/svc_rdma.c                     |  19 +-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c            |   8 +-
 net/sunrpc/xprtsock.c                              |  17 +-
 net/wireless/core.c                                |  64 +-
 net/wireless/mlme.c                                |   6 -
 net/wireless/nl80211.c                             |   1 +
 net/xdp/xsk.c                                      |  11 +-
 rust/helpers/spinlock.c                            |   8 +-
 rust/kernel/block/mq/request.rs                    |  67 +-
 rust/kernel/lib.rs                                 |   2 +-
 rust/kernel/rbtree.rs                              |   9 +-
 rust/macros/lib.rs                                 |   2 +-
 samples/bpf/xdp_adjust_tail_kern.c                 |   1 +
 samples/kfifo/dma-example.c                        |   1 +
 scripts/checkpatch.pl                              |  37 +-
 scripts/faddr2line                                 |   2 +-
 scripts/kernel-doc                                 |  47 +-
 scripts/mod/file2alias.c                           |   5 +-
 scripts/package/builddeb                           |  20 +-
 security/apparmor/capability.c                     |   2 +
 security/apparmor/policy_unpack_test.c             |   6 +
 sound/core/pcm_native.c                            |   6 +-
 sound/core/rawmidi.c                               |   4 +-
 sound/core/sound_kunit.c                           |  11 +
 sound/core/ump.c                                   |   5 +-
 sound/pci/hda/patch_realtek.c                      | 153 ++--
 sound/soc/amd/acp/acp-sdw-sof-mach.c               |  16 +-
 sound/soc/amd/yc/acp6x-mach.c                      |  25 +-
 sound/soc/codecs/da7213.c                          |   1 +
 sound/soc/codecs/da7219.c                          |   9 +-
 sound/soc/codecs/rt722-sdca.c                      |   8 +-
 sound/soc/fsl/fsl-asoc-card.c                      |   8 +-
 sound/soc/fsl/fsl_micfil.c                         |   4 +-
 sound/soc/fsl/imx-audmix.c                         |   3 +
 sound/soc/mediatek/mt8188/mt8188-mt6359.c          |   9 +-
 .../mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c  |   4 +-
 sound/soc/mediatek/mt8195/mt8195-mt6359.c          |   9 +-
 sound/usb/6fire/chip.c                             |  10 +-
 sound/usb/caiaq/audio.c                            |  10 +-
 sound/usb/caiaq/audio.h                            |   1 +
 sound/usb/caiaq/device.c                           |  19 +-
 sound/usb/caiaq/input.c                            |  12 +-
 sound/usb/caiaq/input.h                            |   1 +
 sound/usb/clock.c                                  |  24 +-
 sound/usb/quirks.c                                 |  27 +-
 sound/usb/usx2y/us122l.c                           |   5 +-
 sound/usb/usx2y/usbusx2y.c                         |   2 +-
 tools/bpf/bpftool/jit_disasm.c                     |  40 +-
 tools/gpio/gpio-sloppy-logic-analyzer.sh           |   2 +-
 tools/include/nolibc/arch-s390.h                   |   1 +
 tools/lib/bpf/Makefile                             |   3 +-
 tools/lib/bpf/libbpf.c                             |  99 +--
 tools/lib/bpf/linker.c                             |   2 +
 tools/lib/thermal/commands.c                       |  52 +-
 tools/perf/Makefile.config                         |   2 +-
 tools/perf/builtin-ftrace.c                        |   2 +-
 tools/perf/builtin-list.c                          |   4 +-
 tools/perf/builtin-stat.c                          |  52 +-
 tools/perf/builtin-trace.c                         |  23 +-
 tools/perf/pmu-events/empty-pmu-events.c           |   2 +-
 tools/perf/pmu-events/jevents.py                   |   2 +-
 tools/perf/tests/attr/test-stat-default            |  94 ++-
 tools/perf/tests/attr/test-stat-detailed-1         | 110 ++-
 tools/perf/tests/attr/test-stat-detailed-2         | 134 ++--
 tools/perf/tests/attr/test-stat-detailed-3         | 142 ++--
 tools/perf/tests/shell/test_stat_intel_tpebs.sh    |  11 +-
 tools/perf/util/bpf-filter.c                       |   2 +-
 tools/perf/util/cs-etm.c                           |  25 +-
 tools/perf/util/disasm.c                           |  15 +-
 tools/perf/util/evlist.c                           |  19 +-
 tools/perf/util/evlist.h                           |   1 +
 tools/perf/util/machine.c                          |   2 +-
 tools/perf/util/mem-events.c                       |   8 +-
 tools/perf/util/pfm.c                              |   4 +-
 tools/perf/util/pmus.c                             |   2 +-
 tools/perf/util/probe-finder.c                     |  21 +-
 tools/perf/util/probe-finder.h                     |   4 +-
 tools/perf/util/stat-display.c                     | 101 ++-
 tools/power/x86/turbostat/turbostat.c              |   5 +-
 tools/testing/selftests/arm64/abi/hwcap.c          |   6 +-
 .../selftests/arm64/mte/check_tags_inclusion.c     |   4 +-
 .../testing/selftests/arm64/mte/mte_common_util.c  |   4 +-
 tools/testing/selftests/bpf/Makefile               |   3 +-
 tools/testing/selftests/bpf/network_helpers.h      |   1 +
 .../selftests/bpf/prog_tests/timer_lockup.c        |   6 +
 .../selftests/bpf/progs/test_spin_lock_fail.c      |   4 +-
 .../selftests/bpf/progs/test_tp_btf_nullable.c     |   6 +-
 tools/testing/selftests/bpf/test_progs.c           |   9 +-
 tools/testing/selftests/bpf/test_sockmap.c         | 165 +++-
 tools/testing/selftests/bpf/uprobe_multi.c         |   4 +
 .../selftests/mount_setattr/mount_setattr_test.c   |   2 +-
 tools/testing/selftests/net/Makefile               |   1 +
 .../selftests/net/ipv6_route_update_soft_lockup.sh | 262 ++++++
 .../selftests/net/netfilter/conntrack_dump_flush.c |   6 +
 tools/testing/selftests/net/pmtu.sh                |   2 +-
 tools/testing/selftests/resctrl/fill_buf.c         |   2 +-
 tools/testing/selftests/resctrl/mbm_test.c         |  16 +-
 tools/testing/selftests/resctrl/resctrl_val.c      |   3 +-
 tools/testing/selftests/vDSO/parse_vdso.c          |   3 +-
 tools/testing/selftests/wireguard/netns.sh         |   1 +
 tools/tracing/rtla/src/timerlat_hist.c             |   2 +-
 tools/tracing/rtla/src/timerlat_top.c              |   2 +-
 virt/kvm/kvm_main.c                                | 103 ---
 905 files changed, 13449 insertions(+), 6768 deletions(-)


