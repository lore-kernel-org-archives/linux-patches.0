Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450F42D8DB9;
	Mon, 27 Oct 2025 18:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590431; cv=none; b=nSI3rdlkH7m+Vwt5oG5tfjYIwNh7m/dmYMve78vsQ/Z92tDA0/KIPyigzYmn+QBa6KXv8Tuap96jlHnJYOOhvUoFShKaN/Fw4FMaaYt6WW5xlycyM/BA8woeGCTu0MijiYpU3AVTvirmYm8raA4GYw4QCqjwNAYzv2gZztri42c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590431; c=relaxed/simple;
	bh=11YHtLCY+P85/M2aXgYTffSiiPZ8ZGC3Bb5KTAmqvXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=s0fu1T6IybRqs+JnmEh3ycLWgZC/Qd+zPA0J0scbZCqNh1HYoLje2w/eFYMlFfMiUSPnqU94S7QMkHidkH2a4o06oMpANwjt2YsK1rikjdbYeSOzbVDSr1ffJrPNM6wI71wECLeey/sqctHjV3/irJ4/5vdQ37SITtiu1aTatbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6miTxWS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6miTxWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7E1C4CEF1;
	Mon, 27 Oct 2025 18:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590431;
	bh=11YHtLCY+P85/M2aXgYTffSiiPZ8ZGC3Bb5KTAmqvXQ=;
	h=From:To:Cc:Subject:Date:From;
	b=x6miTxWSVbJcA8ug2U8F4cUgTmlffkWoPk2S7rtCNlJBOWfs6fsHCPkuzj4b2292F
	 zpq81JzKFOzqzRHMiavuK/VoVa/G8qWqjBTM/t1sJdOOthmDkVIuAKnYc9oyKebcEH
	 RHQXkvkIhcq82LhLGN6GzrkVnibnlO1pa3M8Fd7E=
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
Subject: [PATCH 5.4 000/224] 5.4.301-rc1 review
Date: Mon, 27 Oct 2025 19:32:26 +0100
Message-ID: <20251027183508.963233542@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.301-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.301-rc1
X-KernelTest-Deadline: 2025-10-29T18:35+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.4.301 release.
There are 224 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.301-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.301-rc1

Zhengchao Shao <shaozhengchao@huawei.com>
    net: rtnetlink: fix module reference count leak issue in rtnetlink_rcv_msg

Arnd Bergmann <arnd@arndb.de>
    media: s5p-mfc: remove an unused/uninitialized variable

Sergey Bashirov <sergeybashirov@gmail.com>
    NFSD: Fix last write offset handling in layoutcommit

Sergey Bashirov <sergeybashirov@gmail.com>
    NFSD: Minor cleanup in layoutcommit processing

Xiao Liang <shaw.leon@gmail.com>
    padata: Reset next CPU when reorder sequence wraps around

Eric Biggers <ebiggers@kernel.org>
    KEYS: trusted_tpm1: Compare HMAC values in constant time

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Define a proc_layoutcommit for the FlexFiles layout type

Jan Kara <jack@suse.cz>
    vfs: Don't leak disconnected dentries on umount

Zhang Yi <yi.zhang@huawei.com>
    jbd2: ensure that all ongoing I/O complete before freeing blocks

Deepanshu Kartikey <kartikey406@gmail.com>
    ext4: detect invalid INLINE_DATA + EXTENTS flag combination

Gui-Dong Han <hanguidong02@gmail.com>
    drm/amdgpu: use atomic functions with memory barriers for vm fault info

Theodore Ts'o <tytso@mit.edu>
    ext4: avoid potential buffer over-read in parse_apply_sb_mount_options()

Pratyush Yadav <pratyush@kernel.org>
    spi: cadence-quadspi: Flush posted register writes before DAC access

Pratyush Yadav <pratyush@kernel.org>
    spi: cadence-quadspi: Flush posted register writes before INDAC access

Zhen Ni <zhen.ni@easystack.cn>
    memory: samsung: exynos-srom: Fix of_iomap leak in exynos_srom_probe

Krzysztof Kozlowski <krzk@kernel.org>
    memory: samsung: exynos-srom: Correct alignment

Mark Rutland <mark.rutland@arm.com>
    arm64: errata: Apply workarounds for Neoverse-V3AE

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Neoverse-V3AE definitions

Deepanshu Kartikey <kartikey406@gmail.com>
    comedi: fix divide-by-zero in comedi_buf_munge()

Alice Ryhl <aliceryhl@google.com>
    binder: remove "invalid inc weak" check

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: enable back DbC in resume if it was enabled before suspend

Tim Guttzeit <t.guttzeit@tuxedocomputers.com>
    usb/core/quirks: Add Huawei ME906S to wakeup quirk

LI Qingwu <Qing-wu.Li@leica-geosystems.com.cn>
    USB: serial: option: add Telit FN920C04 ECM compositions

Reinhard Speyerer <rspmn@arcor.de>
    USB: serial: option: add Quectel RG255C

Renjun Wang <renjunw0@foxmail.com>
    USB: serial: option: add UNISOC UIS7720

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    net: ravb: Ensure memory write completes before ringing TX doorbell

Michal Pecio <michal.pecio@gmail.com>
    net: usb: rtl8150: Fix frame padding

Deepanshu Kartikey <kartikey406@gmail.com>
    ocfs2: clear extent cache after moving/defragmenting extents

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Malta: Fix keyboard resource preventing i8042 driver from registering

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "cpuidle: menu: Avoid discarding useful information"

Tonghao Zhang <tonghao@bamaicloud.com>
    net: bonding: fix possible peer notify event loss or dup issue

Alexey Simakov <bigalex934@gmail.com>
    sctp: avoid NULL dereference when chunk data buffer is missing

Huang Ying <ying.huang@linux.alibaba.com>
    arm64, mm: avoid always making PTE dirty in pte_mkwrite()

Wei Fang <wei.fang@nxp.com>
    net: enetc: correct the value of ENETC_RXB_TRUESIZE

Johannes Wiesböck <johannes.wiesboeck@aisec.fraunhofer.de>
    rtnetlink: Allow deleting FDB entries in user namespace

Nikolay Aleksandrov <razor@blackwall.org>
    net: rtnetlink: add NLM_F_BULK support to rtnl_fdb_del

Nikolay Aleksandrov <razor@blackwall.org>
    net: add ndo_fdb_del_bulk

Nikolay Aleksandrov <razor@blackwall.org>
    net: rtnetlink: add bulk delete support flag

Nikolay Aleksandrov <razor@blackwall.org>
    net: netlink: add NLM_F_BULK delete request modifier

Nikolay Aleksandrov <razor@blackwall.org>
    net: rtnetlink: use BIT for flag values

Nikolay Aleksandrov <razor@blackwall.org>
    net: rtnetlink: add helper to extract msg type's kind

Nikolay Aleksandrov <razor@blackwall.org>
    net: rtnetlink: add msg kind names

Colin Ian King <colin.king@canonical.com>
    net: rtnetlink: remove redundant assignment to variable err

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k: bitops: Fix find_*_bit() signatures

Yangtao Li <frank.li@vivo.com>
    hfsplus: return EIO when type of hidden directory mismatch in hfsplus_fill_super()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: fix KMSAN uninit-value issue in hfs_find_set_zero_bits()

Alexander Aring <aahringo@redhat.com>
    dlm: check for defined force value in dlm_lockspace_release

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix KMSAN uninit-value issue in hfsplus_delete_cat()

Yang Chenzhi <yang.chenzhi@vivo.com>
    hfs: validate record offset in hfsplus_bmap_alloc

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix KMSAN uninit-value issue in __hfsplus_ext_cache_extent()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: make proper initalization of struct hfs_find_data

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: clear offset and space out of valid records in b-tree node

Xichao Zhao <zhao.xichao@vivo.com>
    exec: Fix incorrect type for ret

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix slab-out-of-bounds read in hfsplus_strcasecmp()

Randy Dunlap <rdunlap@infradead.org>
    ALSA: firewire: amdtp-stream: fix enum kernel-doc warnings

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Fix pelt lost idle time detection

Ingo Molnar <mingo@kernel.org>
    sched/balancing: Rename newidle_balance() => sched_balance_newidle()

Barry Song <song.bao.hua@hisilicon.com>
    sched/fair: Trivial correction of the newidle_balance() comment

Chen Yu <yu.c.chen@intel.com>
    sched: Make newidle_balance() static again

Sabrina Dubroca <sd@queasysnail.net>
    tls: don't rely on tx_work during send()

Sabrina Dubroca <sd@queasysnail.net>
    tls: always set record_type in tls_process_cmsg

Alexey Simakov <bigalex934@gmail.com>
    tg3: prevent use of uninitialized remote_adv and local_adv variables

Eric Dumazet <edumazet@google.com>
    tcp: fix tcp_tso_should_defer() vs large RTT

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: Avoid spurious link down messages during interface toggle

Dmitry Safonov <0x7f454c46@gmail.com>
    net/ip6_tunnel: Prevent perpetual tunnel growth

Yeounsu Moon <yyyynoom@gmail.com>
    net: dlink: handle dma_map_single() failure properly

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: dl2k: switch from 'pci_' to 'dma_' API

Thomas Fourier <fourier.thomas@gmail.com>
    media: pci: ivtv: Add missing check after DMA map

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: pci/ivtv: switch from 'pci_' to 'dma_' API

Jason Andryuk <jason.andryuk@amd.com>
    xen/events: Update virq_to_irq on migration

Ma Ke <make24@iscas.ac.cn>
    media: lirc: Fix error handling in lirc_register()

keliu <liuke94@huawei.com>
    media: rc: Directly use ida_free()

Kaustabh Chakraborty <kauschluss@disroot.org>
    drm/exynos: exynos7_drm_decon: remove ctx->suspended

Anderson Nascimento <anderson@allelesecurity.com>
    btrfs: avoid potential out-of-bounds in btrfs_encode_fh()

Jisheng Zhang <jszhang@kernel.org>
    pwm: berlin: Fix wrong register in suspend/resume

Thomas Fourier <fourier.thomas@gmail.com>
    media: cx18: Add missing check after DMA map

Jason Andryuk <jason.andryuk@amd.com>
    xen/events: Cleanup find_virq() return codes

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    cramfs: Verify inode mode when loading from disk

Lichen Liu <lichliu@redhat.com>
    fs: Add 'initramfs_options' to set initramfs mount options

gaoxiang17 <gaoxiang17@xiaomi.com>
    pid: Add a judgment for ns null in pid_nr_ns

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    minixfs: Verify inode mode when loading from disk

Yuan Chen <chenyuan@kylinos.cn>
    tracing: Fix race condition in kprobe initialization causing NULL pointer dereference

Zheng Qixing <zhengqixing@huawei.com>
    dm: fix NULL pointer dereference in __dm_suspend()

Hans de Goede <hansg@kernel.org>
    mfd: intel_soc_pmic_chtdc_ti: Set use_single_read regmap_config flag

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_soc_pmic_chtdc_ti: Drop unneeded assignment for cache_type

Hans de Goede <hdegoede@redhat.com>
    mfd: intel_soc_pmic_chtdc_ti: Fix invalid regmap-config max_register value

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: reject negative file sizes in squashfs_read_inode()

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: add additional inode sanity checking

Edward Adam Davis <eadavis@qq.com>
    media: mc: Clear minor number before put device

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    mfd: vexpress-sysreg: Check the return value of devm_gpiochip_add_data()

Larshin Sergey <Sergey.Larshin@kaspersky.com>
    fs: udf: fix OOB read in lengthAllocDescs handling

Sean Christopherson <seanjc@google.com>
    KVM: x86: Don't (re)check L1 intercepts when completing userspace I/O

Nalivayko Sergey <Sergey.Nalivayko@kaspersky.com>
    net/9p: fix double req put in p9_fd_cancelled

Ahmet Eray Karadag <eraykrdg1@gmail.com>
    ext4: guard against EA inode refcount underflow in xattr update

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: correctly handle queries for metadata mappings

Yongjian Sun <sunyongjian1@huawei.com>
    ext4: increase i_disksize to offset + len in ext4_update_disksize_before_punch()

Olga Kornievskaia <okorniev@redhat.com>
    nfsd: nfserr_jukebox in nlm_fopen should lead to a retry

Sean Christopherson <seanjc@google.com>
    x86/umip: Fix decoding of register forms of 0F 01 (SGDT and SIDT aliases)

Sean Christopherson <seanjc@google.com>
    x86/umip: Check that the instruction opcode is at least two bytes

Siddharth Vadapalli <s-vadapalli@ti.com>
    PCI: keystone: Use devm_request_irq() to free "ks-pcie-error-irq" on exit

Niklas Schnelle <schnelle@linux.ibm.com>
    PCI/AER: Fix missing uevent on recovery when a reset is requested

Niklas Schnelle <schnelle@linux.ibm.com>
    PCI/IOV: Add PCI rescan-remove locking when enabling/disabling SR-IOV

Sean Christopherson <seanjc@google.com>
    rseq/selftests: Use weak symbol reference, not definition, to link with glibc

Esben Haabendal <esben@geanix.com>
    rtc: interface: Fix long-standing race when setting alarm

Esben Haabendal <esben@geanix.com>
    rtc: interface: Ensure alarm irq is enabled when UIE is enabled

Rex Chen <rex.chen_1@nxp.com>
    mmc: core: SPI mode remove cmd7

Linus Walleij <linus.walleij@linaro.org>
    mtd: rawnand: fsmc: Default to autodetect buswidth

Ma Ke <make24@iscas.ac.cn>
    sparc: fix error handling in scan_one_device()

Anthony Yznaga <anthony.yznaga@oracle.com>
    sparc64: fix hugetlb for sun4u

Eric Biggers <ebiggers@kernel.org>
    sctp: Fix MAC comparison to be constant-time

Thorsten Blum <thorsten.blum@linux.dev>
    scsi: hpsa: Fix potential memory leak in hpsa_big_passthru_ioctl()

Sam James <sam@gentoo.org>
    parisc: don't reference obsolete termio struct for TC* constants

Johan Hovold <johan@kernel.org>
    lib/genalloc: fix device leak in of_gen_pool_get()

Michael Hennerich <michael.hennerich@analog.com>
    iio: frequency: adf4350: Fix prescaler usage.

Qianfeng Rong <rongqianfeng@vivo.com>
    iio: dac: ad5421: use int type to store negative error codes

Qianfeng Rong <rongqianfeng@vivo.com>
    iio: dac: ad5360: use int type to store negative error codes

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: atmel - Fix dma_unmap_sg() direction

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Fix object lifecycle issue in update_qos_request()

Shuhao Fu <sfual@cse.ust.hk>
    drm/nouveau: fix bad ret code in nouveau_bo_move_prep

Qianfeng Rong <rongqianfeng@vivo.com>
    media: i2c: mt9v111: fix incorrect type for ret

Johan Hovold <johan@kernel.org>
    firmware: meson_sm: fix device leak at probe

Lukas Wunner <lukas@wunner.de>
    xen/manage: Fix suspend error path

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: msm8916: Add missing MDSS reset

Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
    ACPI: debug: fix signedness issues in read/write helpers

Daniel Tang <danielzgtg.opensource@gmail.com>
    ACPI: TAD: Add missing sysfs_remove_group() for ACPI_TAD_RT

Gunnar Kudrjavets <gunnarku@amazon.com>
    tpm_tis: Fix incorrect arguments in tpm_tis_probe_irq_single

Lino Sanfilippo <l.sanfilippo@kunbus.com>
    tpm, tpm_tis: Claim locality before writing interrupt registers

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: essiv - Check ssize for decryption and in-place encryption

Harini T <harini.t@amd.com>
    mailbox: zynqmp-ipi: Remove dev.parent check in zynqmp_ipi_free_mboxes

Harini T <harini.t@amd.com>
    mailbox: zynqmp-ipi: Remove redundant mbox_controller_unregister() call

Leo Yan <leo.yan@arm.com>
    tools build: Align warning options with perf

Erick Karanja <karanja99erick@gmail.com>
    net: fsl_pq_mdio: Fix device node reference leak in fsl_pq_mdio_probe

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Don't call reqsk_fastopen_remove() in tcp_conn_request().

Alexandr Sapozhnikov <alsp705@gmail.com>
    net/sctp: fix a null dereference in sctp_disposition sctp_sf_do_5_1D_ce()

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Fix Use-after-free in validation

Dan Carpenter <dan.carpenter@linaro.org>
    net/mlx4: prevent potential use after free in mlx4_en_do_uc_filter()

Duoming Zhou <duoming@zju.edu.cn>
    scsi: mvsas: Fix use-after-free bugs in mvs_work_queue

John Garry <john.garry@huawei.com>
    scsi: mvsas: Use sas_task_find_rq() for tagging

John Garry <john.garry@huawei.com>
    scsi: mvsas: Delete mvs_tag_init()

John Garry <john.garry@huawei.com>
    scsi: libsas: Add sas_task_find_rq()

Alok Tiwari <alok.a.tiwari@oracle.com>
    clk: nxp: Fix pll0 rate check condition in LPC18xx CGU driver

Brian Masney <bmasney@redhat.com>
    clk: nxp: lpc18xx-cgu: convert from round_rate() to determine_rate()

Leo Yan <leo.yan@arm.com>
    perf session: Fix handling when buffer exceeds 2 GiB

Rob Herring (Arm) <robh@kernel.org>
    rtc: x1205: Fix Xicor X1205 vendor prefix

Yunseong Kim <ysk@kzalloc.com>
    perf util: Fix compression checks returning -1 as bool

Michael Hennerich <michael.hennerich@analog.com>
    iio: frequency: adf4350: Fix ADF4350_REG3_12BIT_CLKDIV_MODE

Zhen Ni <zhen.ni@easystack.cn>
    clocksource/drivers/clps711x: Fix resource leaks in error paths

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    pinctrl: check the return value of pinmux_ops::get_function_name()

Zhen Ni <zhen.ni@easystack.cn>
    Input: uinput - zero-initialize uinput_ff_upload_compat to avoid info leak

Yang Shi <yang@os.amperecomputing.com>
    mm: hugetlb: avoid soft lockup when mprotect to large memory area

Naman Jain <namjain@linux.microsoft.com>
    uio_hv_generic: Let userspace take care of interrupt mask

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: fix uninit-value in squashfs_get_parent

Jakub Kicinski <kuba@kernel.org>
    Revert "net/mlx5e: Update and set Xon/Xoff upon MTU set"

Kohei Enju <enjuk@amazon.com>
    net: ena: return 0 in ena_get_rxfh_key_size() when RSS hash key is not configurable

Kohei Enju <enjuk@amazon.com>
    nfp: fix RSS hash key size when RSS is not supported

Donet Tom <donettom@linux.ibm.com>
    drivers/base/node: fix double free in register_one_node()

Dan Carpenter <dan.carpenter@linaro.org>
    ocfs2: fix double free in user_cluster_connect()

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

Stephan Gerhold <stephan.gerhold@linaro.org>
    remoteproc: qcom: q6v5: Avoid disabling handover IRQ twice

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

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath10k: avoid unnecessary wait for service ready message

Vlad Dumitrescu <vdumitrescu@nvidia.com>
    IB/sa: Fix sa_local_svc_timeout_ms read race

Parav Pandit <parav@nvidia.com>
    RDMA/core: Resolve MAC of next-hop device without ARP support

Abdun Nihaal <abdun.nihaal@gmail.com>
    wifi: mt76: fix potential memory leak in mt76_wmac_probe()

Donet Tom <donettom@linux.ibm.com>
    drivers/base/node: handle error properly in register_one_node()

Christophe Leroy <christophe.leroy@csgroup.eu>
    watchdog: mpc8xxx_wdt: Reload the watchdog timer when enabling the watchdog

Zhen Ni <zhen.ni@easystack.cn>
    netfilter: ipset: Remove unused htable_bits in macro ahash_region

Hans de Goede <hansg@kernel.org>
    iio: consumers: Fix offset handling in iio_convert_raw_to_processed()

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

Eric Dumazet <edumazet@google.com>
    tcp: fix __tcp_close() to only send RST when required

Alok Tiwari <alok.a.tiwari@oracle.com>
    PCI: tegra: Fix devm_kcalloc() argument order for port->phys allocation

Stefan Kerkmann <s.kerkmann@pengutronix.de>
    wifi: mwifiex: send world regulatory domain to driver

Qianfeng Rong <rongqianfeng@vivo.com>
    ALSA: lx_core: use int type to store negative error codes

Zhang Shurong <zhang_shurong@foxmail.com>
    media: rj54n1cb0c: Fix memleak in rj54n1_probe()

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: myrs: Fix dma_alloc_coherent() error check

Niklas Cassel <cassel@kernel.org>
    scsi: pm80xx: Fix array-index-out-of-of-bounds on rmmod

Dan Carpenter <dan.carpenter@linaro.org>
    serial: max310x: Add error checking in probe()

Dan Carpenter <dan.carpenter@linaro.org>
    usb: host: max3421-hcd: Fix error pointer dereference in probe cleanup

Brahmajit Das <listout@listout.xyz>
    drm/radeon/r600_cs: clean up of dead code in r600_cs

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    i2c: designware: Add disabling clocks when probe fails

Leilk.Liu <leilk.liu@mediatek.com>
    i2c: mediatek: fix potential incorrect use of I2C_MASTER_WRRD

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Explicitly check accesses to bpf_sock_addr

Akhilesh Patil <akhilesh@ee.iitb.ac.in>
    selftests: watchdog: skip ping loop if WDIOF_KEEPALIVEPING not supported

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: tiehrpwm: Fix corner case in clock divisor calculation

Qianfeng Rong <rongqianfeng@vivo.com>
    block: use int to store blk_stack_limits() return value

Li Nan <linan122@huawei.com>
    blk-mq: check kobject state_in_sysfs before deleting in blk_mq_unregister_hctx

Da Xue <da@libre.computer>
    pinctrl: meson-gxl: add missing i2c_d pinmux

Sneh Mankad <sneh.mankad@oss.qualcomm.com>
    soc: qcom: rpmh-rsc: Unconditionally clear _TRIGGER bit for TCS

Huisong Li <lihuisong@huawei.com>
    ACPI: processor: idle: Fix memory leak when register cpuidle device failed

Geert Uytterhoeven <geert+renesas@glider.be>
    regmap: Remove superfluous check for !config in __regmap_init()

Uros Bizjak <ubizjak@gmail.com>
    x86/vdso: Fix output operand size of RDPID

Leo Yan <leo.yan@arm.com>
    perf: arm_spe: Prevent overflow in PERF_IDX2OFF()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    driver core/PM: Set power.no_callbacks along with power.no_pm

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    staging: axis-fifo: flush RX FIFO on read errors

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    staging: axis-fifo: fix maximum TX packet length check

hupu <hupu.gm@gmail.com>
    perf subcmd: avoid crash in exclude_cmds when excludes is empty

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: limit MAX_TAG_SIZE to 255

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtlwifi: rtl8192cu: Don't claim USB ID 07b8:8188

Xiaowei Li <xiaowei.li@simcom.com>
    USB: serial: option: add SIMCom 8230C compositions

Larshin Sergey <Sergey.Larshin@kaspersky.com>
    media: rc: fix races with imon_disconnect()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    media: imon: grab lock earlier in imon_ir_change_protocol()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    media: imon: reorganize serialization

Flavius Georgescu <pretoriano.mp@gmail.com>
    media: rc: Add support for another iMON 0xffdc device

Duoming Zhou <duoming@zju.edu.cn>
    media: i2c: tc358743: Fix use-after-free bugs caused by orphan timer in probe

Duoming Zhou <duoming@zju.edu.cn>
    media: tuner: xc5000: Fix use-after-free in xc5000_release

Ricardo Ribalda <ribalda@chromium.org>
    media: tunner: xc5000: Refactor firmware load

Kuniyuki Iwashima <kuniyu@amazon.com>
    udp: Fix memory accounting leak.

Duoming Zhou <duoming@zju.edu.cn>
    media: b2c2: Fix use-after-free causing by irq_check_work in flexcop_pci_remove

Wang Haoran <haoranwangsec@gmail.com>
    scsi: target: target_core_configfs: Add length check to avoid buffer overflow


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   3 +
 Documentation/arm64/silicon-errata.rst             |   2 +
 Makefile                                           |   4 +-
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |   2 +
 arch/arm64/include/asm/cputype.h                   |   2 +
 arch/arm64/include/asm/pgtable.h                   |   3 +-
 arch/arm64/kernel/cpu_errata.c                     |   1 +
 arch/m68k/include/asm/bitops.h                     |  25 +--
 arch/mips/mti-malta/malta-setup.c                  |   2 +-
 arch/parisc/include/uapi/asm/ioctls.h              |   8 +-
 arch/sparc/kernel/of_device_32.c                   |   1 +
 arch/sparc/kernel/of_device_64.c                   |   1 +
 arch/sparc/lib/M7memcpy.S                          |  20 +--
 arch/sparc/lib/Memcpy_utils.S                      |   9 +
 arch/sparc/lib/NG4memcpy.S                         |   2 +-
 arch/sparc/lib/NGmemcpy.S                          |  29 ++--
 arch/sparc/lib/U1memcpy.S                          |  19 ++-
 arch/sparc/lib/U3memcpy.S                          |   2 +-
 arch/sparc/mm/hugetlbpage.c                        |  20 +++
 arch/x86/include/asm/kvm_emulate.h                 |   2 +-
 arch/x86/include/asm/segment.h                     |   8 +-
 arch/x86/kernel/umip.c                             |  15 +-
 arch/x86/kvm/emulate.c                             |  10 +-
 arch/x86/kvm/x86.c                                 |   9 +-
 block/blk-mq-sysfs.c                               |   6 +-
 block/blk-settings.c                               |   3 +-
 crypto/essiv.c                                     |  14 +-
 drivers/acpi/acpi_dbg.c                            |  26 +--
 drivers/acpi/acpi_tad.c                            |   3 +
 drivers/acpi/processor_idle.c                      |   3 +
 drivers/android/binder.c                           |  11 +-
 drivers/base/node.c                                |   4 +
 drivers/base/regmap/regmap.c                       |   2 +-
 drivers/char/tpm/tpm_tis_core.c                    |  26 +--
 drivers/clk/nxp/clk-lpc18xx-cgu.c                  |  20 ++-
 drivers/clocksource/clps711x-timer.c               |  23 ++-
 drivers/cpufreq/intel_pstate.c                     |   8 +-
 drivers/cpuidle/governors/menu.c                   |  21 +--
 drivers/crypto/atmel-tdes.c                        |   2 +-
 drivers/firmware/meson/meson_sm.c                  |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   5 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c              |   7 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c              |   7 +-
 drivers/gpu/drm/exynos/exynos7_drm_decon.c         |  36 ----
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   2 +-
 drivers/gpu/drm/radeon/r600_cs.c                   |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_validation.c         |   4 +-
 drivers/i2c/busses/i2c-designware-platdrv.c        |   1 +
 drivers/i2c/busses/i2c-mt65xx.c                    |  17 +-
 drivers/iio/dac/ad5360.c                           |   2 +-
 drivers/iio/dac/ad5421.c                           |   2 +-
 drivers/iio/frequency/adf4350.c                    |  20 ++-
 drivers/iio/inkern.c                               |   2 +-
 drivers/infiniband/core/addr.c                     |  10 +-
 drivers/infiniband/core/sa_query.c                 |   6 +-
 drivers/infiniband/sw/siw/siw_verbs.c              |  25 +--
 drivers/input/misc/uinput.c                        |   1 +
 drivers/mailbox/zynqmp-ipi-mailbox.c               |   7 +-
 drivers/md/dm-integrity.c                          |   2 +-
 drivers/md/dm.c                                    |   7 +-
 drivers/media/i2c/mt9v111.c                        |   2 +-
 drivers/media/i2c/rj54n1cb0c.c                     |   9 +-
 drivers/media/i2c/tc358743.c                       |   4 +-
 drivers/media/mc/mc-devnode.c                      |   6 +-
 drivers/media/pci/b2c2/flexcop-pci.c               |   2 +-
 drivers/media/pci/cx18/cx18-queue.c                |  12 +-
 drivers/media/pci/ivtv/ivtv-driver.c               |   2 +-
 drivers/media/pci/ivtv/ivtv-irq.c                  |   2 +-
 drivers/media/pci/ivtv/ivtv-queue.c                |  18 +-
 drivers/media/pci/ivtv/ivtv-streams.c              |  22 +--
 drivers/media/pci/ivtv/ivtv-udma.c                 |  19 ++-
 drivers/media/pci/ivtv/ivtv-yuv.c                  |  18 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c    |  35 ++--
 drivers/media/rc/imon.c                            | 189 +++++++++++++--------
 drivers/media/rc/lirc_dev.c                        |  15 +-
 drivers/media/rc/rc-main.c                         |   6 +-
 drivers/media/tuners/xc5000.c                      |  41 ++---
 drivers/memory/samsung/exynos-srom.c               |  32 ++--
 drivers/mfd/intel_soc_pmic_chtdc_ti.c              |   5 +-
 drivers/mfd/vexpress-sysreg.c                      |   6 +-
 drivers/misc/genwqe/card_ddcb.c                    |   2 +-
 drivers/mmc/core/sdio.c                            |   6 +-
 drivers/mtd/nand/raw/fsmc_nand.c                   |   6 +-
 drivers/mtd/spi-nor/cadence-quadspi.c              |   5 +
 drivers/net/bonding/bond_main.c                    |  40 ++---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |   5 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |   1 -
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |   1 +
 drivers/net/ethernet/broadcom/tg3.c                |   5 +-
 drivers/net/ethernet/dlink/dl2k.c                  |  99 ++++++-----
 drivers/net/ethernet/freescale/enetc/enetc.h       |   2 +-
 drivers/net/ethernet/freescale/fsl_pq_mdio.c       |   2 +
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   2 +-
 .../ethernet/mellanox/mlx5/core/en/port_buffer.h   |  12 --
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  17 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   2 +-
 drivers/net/ethernet/renesas/ravb_main.c           |   8 +
 drivers/net/usb/rtl8150.c                          |  13 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |  39 +++--
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   7 +-
 drivers/net/wireless/mediatek/mt76/mt7603/soc.c    |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/sw.c    |   1 -
 drivers/pci/controller/dwc/pci-keystone.c          |   4 +-
 drivers/pci/controller/pci-tegra.c                 |   2 +-
 drivers/pci/iov.c                                  |   5 +
 drivers/pci/pci-driver.c                           |   1 +
 drivers/perf/arm_spe_pmu.c                         |   3 +-
 drivers/pinctrl/meson/pinctrl-meson-gxl.c          |  10 ++
 drivers/pinctrl/pinmux.c                           |   2 +-
 drivers/pps/kapi.c                                 |   5 +-
 drivers/pps/pps.c                                  |   5 +-
 drivers/pwm/pwm-berlin.c                           |   4 +-
 drivers/pwm/pwm-tiehrpwm.c                         |   4 +-
 drivers/remoteproc/qcom_q6v5.c                     |   3 -
 drivers/rtc/interface.c                            |  27 +++
 drivers/rtc/rtc-x1205.c                            |   2 +-
 drivers/scsi/hpsa.c                                |  21 ++-
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |   8 +-
 drivers/scsi/mvsas/mv_defs.h                       |   1 +
 drivers/scsi/mvsas/mv_init.c                       |  13 +-
 drivers/scsi/mvsas/mv_sas.c                        |  42 ++---
 drivers/scsi/mvsas/mv_sas.h                        |   8 +-
 drivers/scsi/myrs.c                                |   8 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |   9 +-
 drivers/soc/qcom/rpmh-rsc.c                        |   7 +-
 drivers/staging/axis-fifo/axis-fifo.c              |  32 ++--
 drivers/staging/comedi/comedi_buf.c                |   2 +-
 drivers/target/target_core_configfs.c              |   2 +-
 drivers/tty/serial/max310x.c                       |   2 +
 drivers/uio/uio_hv_generic.c                       |   7 +-
 drivers/usb/core/quirks.c                          |   2 +
 drivers/usb/gadget/configfs.c                      |   2 +
 drivers/usb/host/max3421-hcd.c                     |   2 +-
 drivers/usb/host/xhci-dbgcap.c                     |   9 +-
 drivers/usb/phy/phy-twl6030-usb.c                  |   3 +-
 drivers/usb/serial/option.c                        |  16 ++
 drivers/usb/usbip/vhci_hcd.c                       |  22 +++
 drivers/watchdog/mpc8xxx_wdt.c                     |   2 +
 drivers/xen/events/events_base.c                   |  25 ++-
 drivers/xen/manage.c                               |   3 +-
 fs/btrfs/export.c                                  |   8 +-
 fs/cramfs/inode.c                                  |  11 +-
 fs/dcache.c                                        |   2 +
 fs/dlm/lockspace.c                                 |   2 +-
 fs/exec.c                                          |   2 +-
 fs/ext4/fsmap.c                                    |  14 +-
 fs/ext4/inode.c                                    |  18 +-
 fs/ext4/super.c                                    |  10 +-
 fs/ext4/xattr.c                                    |  15 +-
 fs/hfs/bfind.c                                     |   8 +-
 fs/hfs/brec.c                                      |  27 ++-
 fs/hfs/mdb.c                                       |   2 +-
 fs/hfsplus/bfind.c                                 |   8 +-
 fs/hfsplus/bnode.c                                 |  41 -----
 fs/hfsplus/btree.c                                 |   6 +
 fs/hfsplus/hfsplus_fs.h                            |  42 +++++
 fs/hfsplus/super.c                                 |  25 ++-
 fs/hfsplus/unicode.c                               |  24 +++
 fs/jbd2/transaction.c                              |  13 +-
 fs/minix/inode.c                                   |   8 +-
 fs/namespace.c                                     |  11 +-
 fs/nfs/nfs4proc.c                                  |   2 +-
 fs/nfsd/blocklayout.c                              |   5 +-
 fs/nfsd/flexfilelayout.c                           |   8 +
 fs/nfsd/lockd.c                                    |  15 ++
 fs/nfsd/nfs4proc.c                                 |  34 ++--
 fs/ocfs2/move_extents.c                            |   5 +
 fs/ocfs2/stack_user.c                              |   1 +
 fs/squashfs/inode.c                                |  31 +++-
 fs/squashfs/squashfs_fs_i.h                        |   2 +-
 fs/udf/inode.c                                     |   3 +
 include/linux/device.h                             |   3 +
 include/linux/iio/frequency/adf4350.h              |   2 +-
 include/linux/netdevice.h                          |   9 +
 include/net/ip_tunnels.h                           |  15 ++
 include/net/rtnetlink.h                            |  16 +-
 include/scsi/libsas.h                              |  18 ++
 include/uapi/linux/netlink.h                       |   1 +
 kernel/padata.c                                    |   6 +-
 kernel/pid.c                                       |   2 +-
 kernel/sched/fair.c                                |  38 +++--
 kernel/sched/sched.h                               |   4 -
 kernel/trace/trace_kprobe.c                        |  11 +-
 kernel/trace/trace_probe.h                         |   9 +-
 kernel/trace/trace_uprobe.c                        |  12 +-
 lib/genalloc.c                                     |   5 +-
 mm/hugetlb.c                                       |   2 +
 net/9p/trans_fd.c                                  |   8 +-
 net/core/filter.c                                  |  16 +-
 net/core/rtnetlink.c                               |  89 +++++++---
 net/ipv4/ip_tunnel.c                               |  14 --
 net/ipv4/tcp.c                                     |   9 +-
 net/ipv4/tcp_input.c                               |   1 -
 net/ipv4/tcp_output.c                              |  19 ++-
 net/ipv4/udp.c                                     |  16 +-
 net/ipv6/ip6_tunnel.c                              |   3 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   8 +-
 net/netfilter/ipvs/ip_vs_ftp.c                     |   4 +-
 net/sctp/inqueue.c                                 |  13 +-
 net/sctp/sm_make_chunk.c                           |   3 +-
 net/sctp/sm_statefuns.c                            |   6 +-
 net/tls/tls_main.c                                 |   7 +-
 net/tls/tls_sw.c                                   |  13 ++
 security/keys/trusted.c                            |   7 +-
 sound/firewire/amdtp-stream.h                      |   2 +-
 sound/pci/lx6464es/lx_core.c                       |   4 +-
 sound/soc/intel/boards/bytcht_es8316.c             |  20 ++-
 sound/soc/intel/boards/bytcr_rt5640.c              |   7 +-
 sound/soc/intel/boards/bytcr_rt5651.c              |  26 ++-
 tools/build/feature/Makefile                       |   4 +-
 tools/lib/subcmd/help.c                            |   3 +
 tools/perf/util/lzma.c                             |   2 +-
 tools/perf/util/session.c                          |   2 +-
 tools/perf/util/zlib.c                             |   2 +-
 tools/testing/selftests/rseq/rseq.c                |   8 +-
 tools/testing/selftests/watchdog/watchdog-test.c   |   6 +
 217 files changed, 1530 insertions(+), 941 deletions(-)


