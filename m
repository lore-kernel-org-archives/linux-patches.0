Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A0D1F4735;
	Tue,  3 Dec 2024 14:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236493; cv=none; b=DdV7n65JmXD/Cegl+vb8BxojHv6r1CFqXo6IW5Kp3KakHag/NxM8UN3P/9Fuy8VckrrPj1P9aISO0HDrr3CaenUilFaEiwuo1uBhCpGNYLgScP3B8BfRc8JQjfkKM2ky1jQNv0ptJLmaEkzzUYkuOGqVmiosPMD08sh5BgvuPtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236493; c=relaxed/simple;
	bh=zfkl3xiqRdEFAtMZ70yBuaKNHpttsF6GpuAWZAYB6nY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QnK30bsppf8V7TF5+FkP6NbsFhzF/T3uRaEDOs2PNYKy88qCRszbokQuLm8A72E1MKxYQW6P9fngLf7ymhwDBY6ZgFTu/B2Nxw1fqupxcTcn/dV6mAKppPZIAC8VbR3RrS0EnW2qsfCYj/zwdyQ8hEMMoF4BIbqtsR/RQaVkMRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPnDR183; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPnDR183"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6380FC4CECF;
	Tue,  3 Dec 2024 14:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236493;
	bh=zfkl3xiqRdEFAtMZ70yBuaKNHpttsF6GpuAWZAYB6nY=;
	h=From:To:Cc:Subject:Date:From;
	b=xPnDR183ezQwWvJR7TuBf1kz+3x8tKeJsO5ec8kNAQlyMv02ZMPj67B5hNp2Kl/cD
	 R7341PH/+36g4T0gPblOnEkAdryojGRqaBOx/ZEoukD66RvHq8pJlX0tspDfKfHbWV
	 4xhZ7MEV0W1lmDAQIAADvobYJaCU3klwQozmFHqQ=
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
Subject: [PATCH 4.19 000/138] 4.19.325-rc1 review
Date: Tue,  3 Dec 2024 15:30:29 +0100
Message-ID: <20241203141923.524658091@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.325-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.325-rc1
X-KernelTest-Deadline: 2024-12-05T14:19+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

------------------
Note, this is the LAST 4.19.y kernel to be released.  After this one, it
is end-of-life.  It's been 6 years, everyone should have moved off of it
by now.
------------------

This is the start of the stable review cycle for the 4.19.325 release.
There are 138 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 05 Dec 2024 14:18:57 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.325-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.325-rc1

Dan Carpenter <dan.carpenter@linaro.org>
    sh: intc: Fix use-after-free bug in register_intc_controller()

Masahiro Yamada <masahiroy@kernel.org>
    modpost: remove incorrect code in do_eisa_entry()

Alex Zenla <alex@edera.dev>
    9p/xen: fix release of IRQ

Alex Zenla <alex@edera.dev>
    9p/xen: fix init sequence

Christoph Hellwig <hch@lst.de>
    block: return unsigned int from bdev_io_min

Qingfang Deng <qingfang.deng@siflower.com.cn>
    jffs2: fix use of uninitialized variable

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: Fix duplicate slab cache names while attaching

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Correct the total block count by deducting journal reservation

Yongliang Gao <leonylgao@tencent.com>
    rtc: check if __rtc_read_time was successful in rtc_timer_do_work()

Jinjie Ruan <ruanjinjie@huawei.com>
    rtc: st-lpc: Use IRQF_NO_AUTOEN flag in request_irq()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.0: Fix a use-after-free problem in the asynchronous open()

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix the return value of elf_core_copy_task_fpregs

Bjorn Andersson <quic_bjorande@quicinc.com>
    rpmsg: glink: Propagate TX failures in intentless mode as well

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent a potential integer overflow

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    lib: string_helpers: silence snprintf() output truncation warning

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix checking for number of TRBs left

Qiu-ji Chen <chenqiuji666@gmail.com>
    media: wl128x: Fix atomicity violation in fmc_send_cmd()

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Interpret tilt data from Intuos Pro BT as signed values

Muchun Song <songmuchun@bytedance.com>
    block: fix ordering between checking BLK_MQ_S_STOPPED request adding

Will Deacon <will@kernel.org>
    arm64: tls: Fix context-switching of tpidrro_el0 when kpti is enabled

Huacai Chen <chenhuacai@loongson.cn>
    sh: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK

Tiwei Bie <tiwei.btw@antgroup.com>
    um: vector: Do not use drvdata in release

Bin Liu <b-liu@ti.com>
    serial: 8250: omap: Move pm_runtime_get_sync

Tiwei Bie <tiwei.btw@antgroup.com>
    um: net: Do not use drvdata in release

Tiwei Bie <tiwei.btw@antgroup.com>
    um: ubd: Do not use drvdata in release

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: wl: Put source PEB into correct list if trying locking LEB failed

Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
    spi: Fix acpi deferred irq probe

Jeongjun Park <aha310510@gmail.com>
    netfilter: ipset: add missing range check in bitmap_ip_uadt

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "serial: sh-sci: Clean sci_ports[0] after at earlycon exit"

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Clean sci_ports[0] after at earlycon exit

Michal Vrastil <michal.vrastil@hidglobal.com>
    Revert "usb: gadget: composite: fix OS descriptors w_value logic"

Benoît Sevens <bsevens@google.com>
    ALSA: usb-audio: Fix potential out-of-bound accesses for Extigy and Mbox devices

Andrej Shadura <andrew.shadura@collabora.co.uk>
    Bluetooth: Fix type of len in rfcomm_sock_getsockopt{,_old}()

Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
    tty: ldsic: fix tty_ldisc_autoload sysctl's proc_handler

Lukas Wunner <lukas@wunner.de>
    PCI: Fix use-after-free of slot->bus on hot remove

Qiu-ji Chen <chenqiuji666@gmail.com>
    ASoC: codecs: Fix atomicity violation in snd_soc_component_get_drvdata()

Artem Sadovnikov <ancowi69@gmail.com>
    jfs: xattr: check invalid xattr size more strictly

Theodore Ts'o <tytso@mit.edu>
    ext4: fix FS_IOC_GETFSMAP handling

Jeongjun Park <aha310510@gmail.com>
    ext4: supress data-race warnings in ext4_free_inodes_{count,set}()

Vitalii Mordan <mordan@ispras.ru>
    usb: ehci-spear: fix call balance of sehci clk handling routines

chao liu <liuzgyid@outlook.com>
    apparmor: fix 'Do simple duplicate message elimination'

Jinjie Ruan <ruanjinjie@huawei.com>
    misc: apds990x: Fix missing pm_runtime_disable()

Edward Adam Davis <eadavis@qq.com>
    USB: chaoskey: Fix possible deadlock chaoskey_list_lock

Oliver Neukum <oneukum@suse.com>
    USB: chaoskey: fail open after removal

Jeongjun Park <aha310510@gmail.com>
    usb: using mutex lock and supporting O_NONBLOCK flag in iowarrior_read()

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: dwmac-socfpga: Set RX watchdog interrupt as broken

Vitalii Mordan <mordan@ispras.ru>
    marvell: pxa168_eth: fix call balance of pep->clk handling routines

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: lan78xx: Fix refcounting and autosuspend on invalid WoL configuration

Pavan Chebbi <pavan.chebbi@broadcom.com>
    tg3: Set coherent DMA mask bits to 31 for BCM57766 chipsets

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: lan78xx: Fix memory leak on device unplug by freeing PHY device

Bart Van Assche <bvanassche@acm.org>
    power: supply: core: Remove might_sleep() from power_supply_put()

Avihai Horon <avihaih@nvidia.com>
    vfio/pci: Properly hide first-in-list PCIe extended capability

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Cap the number of bytes copied by nfs4_reset_recoverydir()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent NULL dereference in nfsd4_process_cb_update()

Jonathan Marek <jonathan@marek.ca>
    rpmsg: glink: use only lower 16-bits of param2 for CMD_OPEN name length

Bjorn Andersson <quic_bjorande@quicinc.com>
    rpmsg: glink: Fix GLINK command prefix

Arun Kumar Neelakantam <aneela@codeaurora.org>
    rpmsg: glink: Send READ_NOTIFY command in FIFO full case

Arun Kumar Neelakantam <aneela@codeaurora.org>
    rpmsg: glink: Add TX_DATA_CONT command while sending

Antonio Quartulli <antonio@mandelbit.com>
    m68k: coldfire/device.c: only build FEC when HW macros are defined

Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
    m68k: mcfgpio: Fix incorrect register offset for CONFIG_M5441x

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: cpqphp: Fix PCIBIOS_* return value confusion

weiyufeng <weiyufeng@kylinos.cn>
    PCI: cpqphp: Use PCI_POSSIBLE_ERROR() to check config reads

Leo Yan <leo.yan@arm.com>
    perf probe: Correct demangled symbols in C++ program

Nuno Sa <nuno.sa@analog.com>
    clk: clk-axi-clkgen: make sure to enable the AXI bus clock

Alexandru Ardelean <alexandru.ardelean@analog.com>
    clk: axi-clkgen: use devm_platform_ioremap_resource() short-hand

Nuno Sa <nuno.sa@analog.com>
    dt-bindings: clock: axi-clkgen: include AXI clk

Alexandru Ardelean <alexandru.ardelean@analog.com>
    dt-bindings: clock: adi,axi-clkgen: convert old binding to yaml format

Zhen Lei <thunder.leizhen@huawei.com>
    fbdev: sh7760fb: Fix a possible memory leak in sh7760fb_alloc_mem()

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev/sh7760fb: Alloc DMA memory from hardware device

Michal Suchanek <msuchanek@suse.de>
    powerpc/sstep: make emulate_vsx_load and emulate_vsx_store static

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: fix uninitialized value in ocfs2_file_read_iter()

Zhen Lei <thunder.leizhen@huawei.com>
    scsi: qedi: Fix a possible memory leak in qedi_alloc_and_init_sb()

Zeng Heng <zengheng4@huawei.com>
    scsi: fusion: Remove unused variable 'rc'

Ye Bin <yebin10@huawei.com>
    scsi: bfa: Fix use-after-free in bfad_im_module_exit()

Zhang Changzhong <zhangchangzhong@huawei.com>
    mfd: rt5033: Fix missing regmap_del_irq_chip()

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Check cqe flags to know imm_data vs inv_irkey

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: atmel: Fix possible memory leak

Yuan Can <yuancan@huawei.com>
    cpufreq: loongson2: Unregister platform_driver on failure

Marcus Folkesson <marcus.folkesson@gmail.com>
    mfd: da9052-spi: Change read-mask to write-mask

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/vdso: Flag VDSO64 entry points as functions

Levi Yun <yeoreum.yun@arm.com>
    trace/trace_event_perf: remove duplicate samples on the first tracepoint event

Breno Leitao <leitao@debian.org>
    netpoll: Use rcu_access_pointer() in netpoll_poll_lock

Takashi Iwai <tiwai@suse.de>
    ALSA: 6fire: Release resources at card release

Takashi Iwai <tiwai@suse.de>
    ALSA: caiaq: Use snd_card_free_when_closed() at disconnection

Takashi Iwai <tiwai@suse.de>
    ALSA: us122l: Use snd_card_free_when_closed() at disconnection

Mingwei Zheng <zmw12306@gmail.com>
    net: rfkill: gpio: Add check for clk_enable()

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: hold GPU lock across perfmon sampling

Doug Brown <doug@schmorgal.com>
    drm/etnaviv: fix power register offset on GC300

Marc Kleine-Budde <mkl@pengutronix.de>
    drm/etnaviv: dump: fix sparse warnings

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: consolidate hardware fence handling in etnaviv_gpu

Matthias Schiffer <matthias.schiffer@tq-group.com>
    drm: fsl-dcu: enable PIXCLK on LS1021A

Thomas Zimmermann <tzimmermann@suse.de>
    drm/fsl-dcu: Convert to Linux IRQ interfaces

Thomas Zimmermann <tzimmermann@suse.de>
    drm/fsl-dcu: Set GEM CMA functions with DRM_GEM_CMA_DRIVER_OPS

Thomas Zimmermann <tzimmermann@suse.de>
    drm/fsl-dcu: Use GEM CMA object functions

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/fsl-dcu: Drop drm_gem_prime_export/import

Noralf Trønnes <noralf@tronnes.org>
    drm/fsl-dcu: Use drm_fbdev_generic_setup()

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gtt: Enable full-ppgtt by default everywhere

Alper Nebi Yasak <alpernebiyasak@gmail.com>
    wifi: mwifiex: Fix memcpy() field-spanning write warning in mwifiex_config_scan()

Yuan Chen <chenyuan@kylinos.cn>
    bpf: Fix the xdp_adjust_tail sample prog issue

Jinjie Ruan <ruanjinjie@huawei.com>
    drm/imx/ipuv3: Use IRQF_NO_AUTOEN flag in request_irq()

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/omap: Fix locking in omap_gem_new_dmabuf()

Jeongjun Park <aha310510@gmail.com>
    wifi: ath9k: add range check for conn_rsp_epid in htc_connect_service()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    drm/mm: Mark drm_mm_interval_tree*() functions with __maybe_unused

Luo Qiu <luoqiu@kylinsec.com.cn>
    firmware: arm_scpi: Check the DVFS OPP count returned by the firmware

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    regmap: irq: Set lockdep class for hierarchical IRQ domains

Andre Przywara <andre.przywara@arm.com>
    ARM: dts: cubieboard4: Fix DCDC5 regulator constraints

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    mmc: mmc_spi: drop buggy snprintf()

Dan Carpenter <dan.carpenter@linaro.org>
    soc: qcom: geni-se: fix array underflow in geni_se_clk_tbl_get()

Jinjie Ruan <ruanjinjie@huawei.com>
    soc: ti: smartreflex: Use IRQF_NO_AUTOEN flag in request_irq()

Miguel Ojeda <ojeda@kernel.org>
    time: Fix references to _msecs_to_jiffies() handling of values

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    crypto: cavium - Fix an error handling path in cpt_ucode_load_fw()

Chen Ridong <chenridong@huawei.com>
    crypto: bcm - add error check in the ahash_hmac_init function

Everest K.C <everestkc@everestkc.com.np>
    crypto: cavium - Fix the if condition to exit loop after timeout

Yi Yang <yiyang13@huawei.com>
    crypto: pcrypt - Call crypto layer directly when padata_do_parallel() return -EBUSY

Priyanka Singh <priyanka.singh@nxp.com>
    EDAC/fsl_ddr: Fix bad bit shift operations

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    hfsplus: don't query the device logical block size multiple times

Masahiro Yamada <masahiroy@kernel.org>
    s390/syscalls: Avoid creation of arch/arch/ directory

Aleksandr Mishin <amishin@t-argos.ru>
    acpi/arm64: Adjust error handling procedure in gtdt_parse_timer_block()

Daniel Palmer <daniel@0x0f.com>
    m68k: mvme147: Reinstate early console

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k: mvme16x: Add and use "mvme16x.h"

Daniel Palmer <daniel@0x0f.com>
    m68k: mvme147: Fix SCSI controller IRQ numbers

David Disseldorp <ddiss@suse.de>
    initramfs: avoid filename buffer overrun

Puranjay Mohan <pjy@amazon.com>
    nvme: fix metadata handling in nvme-passthrough

David Wang <00107082@163.com>
    proc/softirqs: replace seq_printf with seq_put_decimal_ull_width

Benoît Monin <benoit.monin@gmx.fr>
    net: usb: qmi_wwan: add Quectel RG650V

Arnd Bergmann <arnd@arndb.de>
    x86/amd_nb: Fix compile-testing without CONFIG_AMD_NB

Li Zhijian <lizhijian@fujitsu.com>
    selftests/watchdog-test: Fix system accidentally reset after watchdog-test

Ben Greear <greearb@candelatech.com>
    mac80211: fix user-power when emulating chanctx

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add DMI quirk for Vexia Edu Atla 10 tablet

Andrew Morton <akpm@linux-foundation.org>
    mm: revert "mm: shmem: fix data-race in shmem_getattr()"

Chris Down <chris@chrisdown.name>
    kbuild: Use uname for LINUX_COMPILE_HOST detection

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: dvbdev: fix the logic when DVB_DYNAMIC_MINORS is not set

Aurelien Jarno <aurelien@aurel32.net>
    Revert "mmc: dw_mmc: Fix IDMAC operation with pages bigger than 4K"

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix null-ptr-deref in block_dirty_buffer tracepoint

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: fix UBSAN warning in ocfs2_verify_volume()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix null-ptr-deref in block_touch_buffer tracepoint

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: uncache inode which has failed entering the group

Jakub Kicinski <kuba@kernel.org>
    netlink: terminate outstanding dump on socket close


-------------

Diffstat:

 .../devicetree/bindings/clock/adi,axi-clkgen.yaml  |  67 ++++++++
 .../devicetree/bindings/clock/axi-clkgen.txt       |  25 ---
 Makefile                                           |   4 +-
 arch/arm/boot/dts/sun9i-a80-cubieboard4.dts        |   4 +-
 arch/arm64/kernel/process.c                        |   2 +-
 arch/m68k/coldfire/device.c                        |   8 +-
 arch/m68k/include/asm/mcfgpio.h                    |   2 +-
 arch/m68k/include/asm/mvme147hw.h                  |   4 +-
 arch/m68k/kernel/early_printk.c                    |   9 +-
 arch/m68k/mvme147/config.c                         |  30 ++++
 arch/m68k/mvme147/mvme147.h                        |   6 +
 arch/m68k/mvme16x/config.c                         |   2 +
 arch/m68k/mvme16x/mvme16x.h                        |   6 +
 arch/powerpc/include/asm/sstep.h                   |   5 -
 arch/powerpc/include/asm/vdso.h                    |   1 +
 arch/powerpc/lib/sstep.c                           |  12 +-
 arch/s390/kernel/syscalls/Makefile                 |   2 +-
 arch/sh/kernel/cpu/proc.c                          |   2 +-
 arch/um/drivers/net_kern.c                         |   2 +-
 arch/um/drivers/ubd_kern.c                         |   2 +-
 arch/um/drivers/vector_kern.c                      |   3 +-
 arch/um/kernel/process.c                           |   2 +-
 arch/x86/include/asm/amd_nb.h                      |   5 +-
 block/blk-mq.c                                     |   6 +
 block/blk-mq.h                                     |  13 ++
 crypto/pcrypt.c                                    |  12 +-
 drivers/acpi/arm64/gtdt.c                          |   2 +-
 drivers/base/regmap/regmap-irq.c                   |   4 +
 drivers/clk/clk-axi-clkgen.c                       |  26 ++-
 drivers/cpufreq/loongson2_cpufreq.c                |   4 +-
 drivers/crypto/bcm/cipher.c                        |   5 +-
 drivers/crypto/cavium/cpt/cptpf_main.c             |   6 +-
 drivers/edac/fsl_ddr_edac.c                        |  22 +--
 drivers/firmware/arm_scpi.c                        |   3 +
 drivers/gpu/drm/drm_mm.c                           |   2 +-
 drivers/gpu/drm/etnaviv/etnaviv_drv.h              |  11 --
 drivers/gpu/drm/etnaviv/etnaviv_dump.c             |  13 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |  48 ++++--
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h              |  20 ++-
 drivers/gpu/drm/fsl-dcu/Kconfig                    |   1 +
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c          | 170 ++++++++++----------
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.h          |   4 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c                |  10 +-
 drivers/gpu/drm/imx/ipuv3-crtc.c                   |   6 +-
 drivers/gpu/drm/omapdrm/omap_gem.c                 |  10 +-
 drivers/hid/wacom_wac.c                            |   4 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   7 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |   2 +-
 drivers/media/dvb-core/dvbdev.c                    |  15 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |   3 +-
 drivers/message/fusion/mptsas.c                    |   4 +-
 drivers/mfd/da9052-spi.c                           |   2 +-
 drivers/mfd/rt5033.c                               |   4 +-
 drivers/misc/apds990x.c                            |  12 +-
 drivers/mmc/host/dw_mmc.c                          |   4 +-
 drivers/mmc/host/mmc_spi.c                         |   9 +-
 drivers/mtd/nand/raw/atmel/pmecc.c                 |   8 +-
 drivers/mtd/nand/raw/atmel/pmecc.h                 |   2 -
 drivers/mtd/ubi/attach.c                           |  12 +-
 drivers/mtd/ubi/wl.c                               |   9 +-
 drivers/net/ethernet/broadcom/tg3.c                |   3 +
 drivers/net/ethernet/marvell/pxa168_eth.c          |  13 +-
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |   2 +
 drivers/net/usb/lan78xx.c                          |  11 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/wireless/ath/ath9k/htc_hst.c           |   3 +
 drivers/net/wireless/marvell/mwifiex/fw.h          |   2 +-
 drivers/nvme/host/core.c                           |   7 +-
 drivers/pci/hotplug/cpqphp_pci.c                   |  19 ++-
 drivers/pci/slot.c                                 |   4 +-
 drivers/power/avs/smartreflex.c                    |   4 +-
 drivers/power/supply/power_supply_core.c           |   2 -
 drivers/rpmsg/qcom_glink_native.c                  | 175 ++++++++++++++-------
 drivers/rtc/interface.c                            |   7 +-
 drivers/rtc/rtc-st-lpc.c                           |   5 +-
 drivers/scsi/bfa/bfad.c                            |   3 +-
 drivers/scsi/qedi/qedi_main.c                      |   1 +
 drivers/sh/intc/core.c                             |   2 +-
 drivers/soc/qcom/qcom-geni-se.c                    |   3 +-
 drivers/spi/spi.c                                  |  13 +-
 drivers/tty/serial/8250/8250_omap.c                |   4 +-
 drivers/tty/tty_ldisc.c                            |   2 +-
 drivers/usb/dwc3/gadget.c                          |   9 +-
 drivers/usb/gadget/composite.c                     |  18 ++-
 drivers/usb/host/ehci-spear.c                      |   7 +-
 drivers/usb/misc/chaoskey.c                        |  35 +++--
 drivers/usb/misc/iowarrior.c                       |  46 ++++--
 drivers/vfio/pci/vfio_pci_config.c                 |  16 +-
 drivers/video/fbdev/sh7760fb.c                     |  11 +-
 fs/ext4/fsmap.c                                    |  54 ++++++-
 fs/ext4/mballoc.c                                  |  18 ++-
 fs/ext4/mballoc.h                                  |   1 +
 fs/ext4/super.c                                    |   8 +-
 fs/hfsplus/hfsplus_fs.h                            |   3 +-
 fs/hfsplus/wrapper.c                               |   2 +
 fs/jffs2/erase.c                                   |   7 +-
 fs/jfs/xattr.c                                     |   2 +-
 fs/nfs/nfs4proc.c                                  |   8 +-
 fs/nfsd/nfs4callback.c                             |  16 +-
 fs/nfsd/nfs4recover.c                              |   3 +-
 fs/nilfs2/btnode.c                                 |   2 -
 fs/nilfs2/gcinode.c                                |   4 +-
 fs/nilfs2/mdt.c                                    |   1 -
 fs/nilfs2/page.c                                   |   2 +-
 fs/ocfs2/aops.h                                    |   2 +
 fs/ocfs2/file.c                                    |   4 +
 fs/ocfs2/resize.c                                  |   2 +
 fs/ocfs2/super.c                                   |  13 +-
 fs/proc/softirqs.c                                 |   2 +-
 fs/ubifs/super.c                                   |   6 +-
 include/linux/blkdev.h                             |   2 +-
 include/linux/jiffies.h                            |   2 +-
 include/linux/netpoll.h                            |   2 +-
 init/initramfs.c                                   |  15 ++
 kernel/time/time.c                                 |   2 +-
 kernel/trace/trace_event_perf.c                    |   6 +
 lib/string_helpers.c                               |   2 +-
 mm/shmem.c                                         |   2 -
 net/9p/trans_xen.c                                 |   9 +-
 net/bluetooth/rfcomm/sock.c                        |  10 +-
 net/mac80211/main.c                                |   2 +
 net/netfilter/ipset/ip_set_bitmap_ip.c             |   7 +-
 net/netlink/af_netlink.c                           |  31 +---
 net/netlink/af_netlink.h                           |   2 -
 net/rfkill/rfkill-gpio.c                           |   8 +-
 samples/bpf/xdp_adjust_tail_kern.c                 |   1 +
 scripts/mkcompile_h                                |   2 +-
 scripts/mod/file2alias.c                           |   5 +-
 security/apparmor/capability.c                     |   2 +
 sound/soc/codecs/da7219.c                          |   9 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |  15 ++
 sound/usb/6fire/chip.c                             |  10 +-
 sound/usb/caiaq/audio.c                            |  10 +-
 sound/usb/caiaq/audio.h                            |   1 +
 sound/usb/caiaq/device.c                           |  19 ++-
 sound/usb/caiaq/input.c                            |  12 +-
 sound/usb/caiaq/input.h                            |   1 +
 sound/usb/quirks.c                                 |  18 ++-
 sound/usb/usx2y/us122l.c                           |   5 +-
 tools/perf/util/probe-finder.c                     |  17 +-
 tools/testing/selftests/vDSO/parse_vdso.c          |   3 +-
 tools/testing/selftests/watchdog/watchdog-test.c   |   6 +
 142 files changed, 998 insertions(+), 528 deletions(-)


