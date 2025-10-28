Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D7A301715;
	Tue, 28 Oct 2025 09:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761643768; cv=none; b=lh0sToiXbb6NimeoWXIHMpXZtquFfoPbhXgzzGQhs51pLMEiVakXWGIyVP2s0elwbE+P+8kSi8NDOiQRX2JgWhOJ2c1yZVofuzCRO5v79pFwUF3G1qdeRofHjlqON4j+j0hcb1Q0jc6C/B7Fz3NoTm6lJ6uMJBXJ5lGAbT/RTDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761643768; c=relaxed/simple;
	bh=vzTY4RjbI0IYdIQfuVHD3tP/xhI5hHNchwV/R1597xc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Z43/63R8rDu2fAHstDr+036hoD3YnhTgLqsZduJrEZ+9byEoRK18D2v83c6DCDHWtTfALEiO1q5p7eWA5W2xuMOrPguDyLMiIIcLes4A4MokIGOH9Pq2nQd9BlIjRK+4fPe14i2m/aQo3AKTJnamrFHqaWUOvSD1xjn+TLZdC0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iqBO51k7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iqBO51k7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA09C4CEFF;
	Tue, 28 Oct 2025 09:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761643768;
	bh=vzTY4RjbI0IYdIQfuVHD3tP/xhI5hHNchwV/R1597xc=;
	h=From:To:Cc:Subject:Date:From;
	b=iqBO51k72A6/n/4exvqxMJ4ZJBj+ei+YsC45bkAQG+uoPRT+asmeoo4v36QC50k1c
	 OM0UvhfRTogPYwnSK/0q6qrZNcdzzw/bkbhJijPO8z8nO5CpHhxuTSb+fV0HFoZNF9
	 qQudb6aaclt9zfJOeXmezWrqj5o3R4S/SIsxM+wA=
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
Subject: [PATCH 5.10 000/325] 5.10.246-rc2 review
Date: Tue, 28 Oct 2025 10:29:21 +0100
Message-ID: <20251028092846.265406861@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.246-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.246-rc2
X-KernelTest-Deadline: 2025-10-30T09:28+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.246 release.
There are 325 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 30 Oct 2025 09:28:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.246-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.246-rc2

Li Jinlin <lijinlin3@huawei.com>
    fsdax: Fix infinite loop in dax_iomap_rw()

Zhengchao Shao <shaozhengchao@huawei.com>
    net: rtnetlink: fix module reference count leak issue in rtnetlink_rcv_msg

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    arch_topology: Fix incorrect error check in topology_parse_cpu_capacity()

Darrick J. Wong <djwong@kernel.org>
    fuse: fix livelock in synchronous file put from fuseblk workers

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Define a proc_layoutcommit for the FlexFiles layout type

Jan Kara <jack@suse.cz>
    vfs: Don't leak disconnected dentries on umount

Gui-Dong Han <hanguidong02@gmail.com>
    drm/amdgpu: use atomic functions with memory barriers for vm fault info

Pratyush Yadav <pratyush@kernel.org>
    spi: cadence-quadspi: Flush posted register writes before DAC access

Theodore Ts'o <tytso@mit.edu>
    ext4: avoid potential buffer over-read in parse_apply_sb_mount_options()

Brian Norris <briannorris@google.com>
    PCI/sysfs: Ensure devices are powered for config reads

Krzysztof Wilczyński <kw@linux.com>
    PCI/sysfs: Use sysfs_emit() and sysfs_emit_at() in "show" functions

Maximilian Luz <luzmaximilian@gmail.com>
    PCI: Add sysfs attribute for device power state

Siddharth Vadapalli <s-vadapalli@ti.com>
    PCI: j721e: Fix programming sequence of "strap" settings

Muhammad Usama Anjum <usama.anjum@collabora.com>
    wifi: ath11k: HAL SRNG: don't deinitialize and re-initialize again

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Handle errors in BPMP response

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: rockchip - Fix dma_unmap_sg() nents value

Eric Biggers <ebiggers@kernel.org>
    KEYS: trusted_tpm1: Compare HMAC values in constant time

Sergey Bashirov <sergeybashirov@gmail.com>
    NFSD: Fix last write offset handling in layoutcommit

Sergey Bashirov <sergeybashirov@gmail.com>
    NFSD: Minor cleanup in layoutcommit processing

Sergey Bashirov <sergeybashirov@gmail.com>
    NFSD: Rework encoding and decoding of nfsd4_deviceid

Sean Nyekjaer <sean@geanix.com>
    iio: imu: inv_icm42600: Simplify pm_runtime setup

Bence Csókás <csokas.bence@prolan.hu>
    PM: runtime: Add new devm functions

Sean Nyekjaer <sean@geanix.com>
    iio: imu: inv_icm42600: Avoid configuring if already pm_runtime suspended

David Lechner <dlechner@baylibre.com>
    iio: imu: inv_icm42600: use = { } instead of memset()

Xiao Liang <shaw.leon@gmail.com>
    padata: Reset next CPU when reorder sequence wraps around

Arnd Bergmann <arnd@arndb.de>
    media: s5p-mfc: remove an unused/uninitialized variable

Stefano Garzarella <sgarzare@redhat.com>
    vsock: fix lock inversion in vsock_assign_transport()

Mark Rutland <mark.rutland@arm.com>
    arm64: errata: Apply workarounds for Neoverse-V3AE

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Neoverse-V3AE definitions

Florian Eckert <fe@dev.tdt.de>
    serial: 8250_exar: add support for Advantech 2 port card with Device ID 0x0018

Victoria Votokina <Victoria.Votokina@kaspersky.com>
    most: usb: hdm_probe: Fix calling put_device() before device initialization

Victoria Votokina <Victoria.Votokina@kaspersky.com>
    most: usb: Fix use-after-free in hdm_disconnect

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add wildcat lake P DID

Deepanshu Kartikey <kartikey406@gmail.com>
    comedi: fix divide-by-zero in comedi_buf_munge()

Alice Ryhl <aliceryhl@google.com>
    binder: remove "invalid inc weak" check

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: enable back DbC in resume if it was enabled before suspend

Andrey Konovalov <andreyknvl@gmail.com>
    usb: raw-gadget: do not limit transfer length

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

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-eth: fix the pointer passed to PTR_ALIGN on Tx path

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

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/powerplay: Fix CIK shutdown temperature

I Viswanath <viswanathiyyappan@gmail.com>
    net: usb: lan78xx: fix use of improperly initialized dev->chipid in lan78xx_reset

Oleksij Rempel <linux@rempel-privat.de>
    net: usb: lan78xx: Add error handling to lan78xx_init_mac_address

Jakub Kicinski <kuba@kernel.org>
    net: usb: use eth_hw_addr_set() instead of ether_addr_copy()

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

Linmao Li <lilinmao@kylinos.cn>
    r8169: fix packet truncation after S4 resume on RTL8168H/RTL8111H

Yeounsu Moon <yyyynoom@gmail.com>
    net: dlink: handle dma_map_single() failure properly

Yuezhang Mo <Yuezhang.Mo@sony.com>
    dax: skip read lock assertion for read-only filesystems

Christoph Hellwig <hch@lst.de>
    fsdax: switch dax_iomap_rw to use iomap_iter

Christoph Hellwig <hch@lst.de>
    iomap: add the new iomap_iter model

Benjamin Tissoires <bentiss@kernel.org>
    HID: multitouch: fix sticky fingers

Jason Andryuk <jason.andryuk@amd.com>
    xen/events: Update virq_to_irq on migration

Ma Ke <make24@iscas.ac.cn>
    media: lirc: Fix error handling in lirc_register()

keliu <liuke94@huawei.com>
    media: rc: Directly use ida_free()

Kaustabh Chakraborty <kauschluss@disroot.org>
    drm/exynos: exynos7_drm_decon: remove ctx->suspended

Adam Xue <zxue@semtech.com>
    bus: mhi: host: Do not use uninitialized 'dev' pointer in mhi_init_irq_setup()

Anderson Nascimento <anderson@allelesecurity.com>
    btrfs: avoid potential out-of-bounds in btrfs_encode_fh()

Yu Kuai <yukuai3@huawei.com>
    blk-crypto: fix missing blktrace bio split events

Jisheng Zhang <jszhang@kernel.org>
    pwm: berlin: Fix wrong register in suspend/resume

Deepanshu Kartikey <kartikey406@gmail.com>
    ext4: detect invalid INLINE_DATA + EXTENTS flag combination

Zhang Yi <yi.zhang@huawei.com>
    jbd2: ensure that all ongoing I/O complete before freeing blocks

Jason A. Donenfeld <Jason@zx2c4.com>
    wifi: rt2x00: use explicitly signed or unsigned types

Dan Carpenter <dan.carpenter@linaro.org>
    mm/slab: make __free(kfree) accept error pointers

Mikhail Kobuk <m.kobuk@ispras.ru>
    media: pci: ivtv: Add check for DMA map result

Thomas Fourier <fourier.thomas@gmail.com>
    media: cx18: Add missing check after DMA map

Thomas Fourier <fourier.thomas@gmail.com>
    media: pci: ivtv: Add missing check after DMA map

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: pci/ivtv: switch from 'pci_' to 'dma_' API

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

Linus Torvalds <torvalds@linux-foundation.org>
    minmax: make generic MIN() and MAX() macros available everywhere

Linus Torvalds <torvalds@linux-foundation.org>
    minmax: simplify and clarify min_t()/max_t() implementation

Linus Torvalds <torvalds@linux-foundation.org>
    minmax: add a few more MIN_T/MAX_T users

Linus Torvalds <torvalds@linux-foundation.org>
    minmax: avoid overly complicated constant expressions in VM code

David Laight <David.Laight@ACULAB.COM>
    minmax: relax check to allow comparison between unsigned arguments and signed constants

David Laight <David.Laight@ACULAB.COM>
    minmax: allow comparisons of 'int' against 'unsigned char/short'

David Laight <David.Laight@ACULAB.COM>
    minmax: fix indentation of __cmp_once() and __clamp_once()

David Laight <David.Laight@ACULAB.COM>
    minmax: allow min()/max()/clamp() if the arguments have the same signedness.

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    minmax: fix header inclusions

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    minmax: deduplicate __unconst_integer_typeof()

Herve Codina <herve.codina@bootlin.com>
    minmax: Introduce {min,max}_array()

Matthew Wilcox (Oracle) <willy@infradead.org>
    minmax: add in_range() macro

Jason A. Donenfeld <Jason@zx2c4.com>
    minmax: clamp more efficiently by avoiding extra comparison

Jason A. Donenfeld <Jason@zx2c4.com>
    minmax: sanity check constant bounds when clamping

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: remove duplicated in_range() macro

Bart Van Assche <bvanassche@acm.org>
    overflow, tracing: Define the is_signed_type() macro once

Catalin Marinas <catalin.marinas@arm.com>
    arm64: mte: Do not flag the zero page as PG_mte_tagged

Aleksa Sarai <cyphar@cyphar.com>
    fscontext: do not consume log entries when returning -EMSGSIZE

Peter Zijlstra <peterz@infradead.org>
    locking: Introduce __cleanup() based infrastructure

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    cramfs: Verify inode mode when loading from disk

Lichen Liu <lichliu@redhat.com>
    fs: Add 'initramfs_options' to set initramfs mount options

gaoxiang17 <gaoxiang17@xiaomi.com>
    pid: Add a judgment for ns null in pid_nr_ns

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    minixfs: Verify inode mode when loading from disk

Nalivayko Sergey <Sergey.Nalivayko@kaspersky.com>
    net/9p: fix double req put in p9_fd_cancelled

Sean Christopherson <seanjc@google.com>
    KVM: x86: Don't (re)check L1 intercepts when completing userspace I/O

Ma Ke <make24@iscas.ac.cn>
    ASoC: wcd934x: fix error handling in wcd934x_codec_parse_data()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wcd934x: Simplify with dev_err_probe

Larshin Sergey <Sergey.Larshin@kaspersky.com>
    fs: udf: fix OOB read in lengthAllocDescs handling

Gianfranco Trad <gianf.trad@gmail.com>
    udf: fix uninit-value use in udf_get_fileshortad

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: reject negative file sizes in squashfs_read_inode()

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: add additional inode sanity checking

Edward Adam Davis <eadavis@qq.com>
    media: mc: Clear minor number before put device

Hans de Goede <hansg@kernel.org>
    mfd: intel_soc_pmic_chtdc_ti: Set use_single_read regmap_config flag

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_soc_pmic_chtdc_ti: Drop unneeded assignment for cache_type

Hans de Goede <hdegoede@redhat.com>
    mfd: intel_soc_pmic_chtdc_ti: Fix invalid regmap-config max_register value

Zheng Qixing <zhengqixing@huawei.com>
    dm: fix NULL pointer dereference in __dm_suspend()

Yuan Chen <chenyuan@kylinos.cn>
    tracing: Fix race condition in kprobe initialization causing NULL pointer dereference

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: sdm845: Fix slimbam num-channels/ees

Nathan Chancellor <nathan@kernel.org>
    lib/crypto/curve25519-hacl64: Disable KASAN with clang-17 and older

Ahmet Eray Karadag <eraykrdg1@gmail.com>
    ext4: guard against EA inode refcount underflow in xattr update

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: correctly handle queries for metadata mappings

Yongjian Sun <sunyongjian1@huawei.com>
    ext4: increase i_disksize to offset + len in ext4_update_disksize_before_punch()

Olga Kornievskaia <okorniev@redhat.com>
    nfsd: nfserr_jukebox in nlm_fopen should lead to a retry

Thorsten Blum <thorsten.blum@linux.dev>
    NFSD: Fix destination buffer size in nfsd4_ssc_setup_dul()

Sean Christopherson <seanjc@google.com>
    x86/umip: Fix decoding of register forms of 0F 01 (SGDT and SIDT aliases)

Sean Christopherson <seanjc@google.com>
    x86/umip: Check that the instruction opcode is at least two bytes

Pratyush Yadav <pratyush@kernel.org>
    spi: cadence-quadspi: Flush posted register writes before INDAC access

Niklas Cassel <cassel@kernel.org>
    PCI: tegra194: Fix broken tegra_pcie_ep_raise_msi_irq()

Siddharth Vadapalli <s-vadapalli@ti.com>
    PCI: keystone: Use devm_request_irq() to free "ks-pcie-error-irq" on exit

Lukas Wunner <lukas@wunner.de>
    PCI/AER: Support errors introduced by PCIe r6.0

Niklas Schnelle <schnelle@linux.ibm.com>
    PCI/AER: Fix missing uevent on recovery when a reset is requested

Lukas Wunner <lukas@wunner.de>
    PCI/ERR: Fix uevent on failure to recover

Niklas Schnelle <schnelle@linux.ibm.com>
    PCI/IOV: Add PCI rescan-remove locking when enabling/disabling SR-IOV

Sean Christopherson <seanjc@google.com>
    rseq/selftests: Use weak symbol reference, not definition, to link with glibc

Esben Haabendal <esben@geanix.com>
    rtc: interface: Fix long-standing race when setting alarm

Esben Haabendal <esben@geanix.com>
    rtc: interface: Ensure alarm irq is enabled when UIE is enabled

Zhen Ni <zhen.ni@easystack.cn>
    memory: samsung: exynos-srom: Fix of_iomap leak in exynos_srom_probe

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

Askar Safin <safinaskar@zohomail.com>
    openat2: don't trigger automounts with RESOLVE_NO_XDEV

Johan Hovold <johan@kernel.org>
    lib/genalloc: fix device leak in of_gen_pool_get()

Sean Nyekjaer <sean@geanix.com>
    iio: imu: inv_icm42600: Drop redundant pm_runtime reinitialization in resume

Huacai Chen <chenhuacai@loongson.cn>
    init: handle bootloader identifier in kernel parameters

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

Simon Schuster <schuster.simon@siemens-energy.com>
    copy_sighand: Handle architectures where sizeof(unsigned long) < sizeof(u64)

Shuhao Fu <sfual@cse.ust.hk>
    drm/nouveau: fix bad ret code in nouveau_bo_move_prep

Qianfeng Rong <rongqianfeng@vivo.com>
    media: i2c: mt9v111: fix incorrect type for ret

Johan Hovold <johan@kernel.org>
    firmware: meson_sm: fix device leak at probe

Lukas Wunner <lukas@wunner.de>
    xen/manage: Fix suspend error path

Jason Andryuk <jason.andryuk@amd.com>
    xen/events: Cleanup find_virq() return codes

Miaoqian Lin <linmq006@gmail.com>
    ARM: OMAP2+: pm33xx-core: ix device node reference leaks in amx3_idle_init

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: msm8916: Add missing MDSS reset

Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
    ACPI: debug: fix signedness issues in read/write helpers

Daniel Tang <danielzgtg.opensource@gmail.com>
    ACPI: TAD: Add missing sysfs_remove_group() for ACPI_TAD_RT

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: wcd934x: mark the GPIO controller as sleeping

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: wcd934x: Remove duplicate assignment of of_gpio_n_cells

Gunnar Kudrjavets <gunnarku@amazon.com>
    tpm_tis: Fix incorrect arguments in tpm_tis_probe_irq_single

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: essiv - Check ssize for decryption and in-place encryption

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Properly disable scaling on DCE6

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Properly clear SCL_*_FILTER_CONTROL on DCE6

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Add missing DCE6 SCL_HORZ_FILTER_INIT* SRIs

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: Add additional DCE6 SCL registers

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix metadata_dst leak __bpf_redirect_neigh_v{4,6}

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

Brian Masney <bmasney@redhat.com>
    clk: at91: peripheral: fix return value

Ian Rogers <irogers@google.com>
    libperf event: Ensure tracing data is multiple of 8 sized

Michael Hennerich <michael.hennerich@analog.com>
    iio: frequency: adf4350: Fix ADF4350_REG3_12BIT_CLKDIV_MODE

Zhen Ni <zhen.ni@easystack.cn>
    clocksource/drivers/clps711x: Fix resource leaks in error paths

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    fs: always return zero on success from replace_fd()

Salah Triki <salah.triki@gmail.com>
    bus: fsl-mc: Check return value of platform_get_resource()

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    pinctrl: check the return value of pinmux_ops::get_function_name()

Zhen Ni <zhen.ni@easystack.cn>
    Input: uinput - zero-initialize uinput_ff_upload_compat to avoid info leak

Marek Vasut <marek.vasut@mailbox.org>
    Input: atmel_mxt_ts - allow reset GPIO to sleep

Yang Shi <yang@os.amperecomputing.com>
    mm: hugetlb: avoid soft lockup when mprotect to large memory area

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    mfd: vexpress-sysreg: Check the return value of devm_gpiochip_add_data()

Naman Jain <namjain@linux.microsoft.com>
    uio_hv_generic: Let userspace take care of interrupt mask

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: fix uninit-value in squashfs_get_parent

Jakub Kicinski <kuba@kernel.org>
    Revert "net/mlx5e: Update and set Xon/Xoff upon MTU set"

Yeounsu Moon <yyyynoom@gmail.com>
    net: dlink: handle copy_thresh allocation failure

Kohei Enju <enjuk@amazon.com>
    net: ena: return 0 in ena_get_rxfh_key_size() when RSS hash key is not configurable

Kohei Enju <enjuk@amazon.com>
    nfp: fix RSS hash key size when RSS is not supported

Donet Tom <donettom@linux.ibm.com>
    drivers/base/node: fix double free in register_one_node()

Dan Carpenter <dan.carpenter@linaro.org>
    ocfs2: fix double free in user_cluster_connect()

Nishanth Menon <nm@ti.com>
    hwrng: ks-sa - fix division by zero in ks_sa_rng_init

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix not exposing debug UUID on MGMT_OP_READ_EXP_FEATURES_INFO

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

Bagas Sanjaya <bagasdotme@gmail.com>
    Documentation: trace: historgram-design: Separate sched_waking histogram section heading and the following diagram

Vlad Dumitrescu <vdumitrescu@nvidia.com>
    IB/sa: Fix sa_local_svc_timeout_ms read race

Parav Pandit <parav@nvidia.com>
    RDMA/core: Resolve MAC of next-hop device without ARP support

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

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu: Power up UVD 3 for FW validation (v2)

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

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt8516-pumpkin: Fix machine compatible

Qianfeng Rong <rongqianfeng@vivo.com>
    pinctrl: renesas: Use int type to store negative error codes

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: core: Clear power.must_resume in noirq suspend error path

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

Yureka Lilian <yuka@yuka.dev>
    libbpf: Fix reuse of DEVMAP

Geert Uytterhoeven <geert+renesas@glider.be>
    regmap: Remove superfluous check for !config in __regmap_init()

Uros Bizjak <ubizjak@gmail.com>
    x86/vdso: Fix output operand size of RDPID

Leo Yan <leo.yan@arm.com>
    perf: arm_spe: Prevent overflow in PERF_IDX2OFF()

Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
    selftests: arm64: Check fread return value in exec_target

Jeff Layton <jlayton@kernel.org>
    filelock: add FL_RECLAIM to show_fl_flags() macro

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: rng - Ensure set_ent is always present

Igor Artemiev <Igor.A.Artemiev@mcst.ru>
    drm/amd/display: Fix potential null dereference

Roman Li <roman.li@amd.com>
    drm/amd/display: Remove redundant safeguards for dmub-srv destroy()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    driver core/PM: Set power.no_callbacks along with power.no_pm

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    staging: axis-fifo: flush RX FIFO on read errors

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    staging: axis-fifo: fix maximum TX packet length check

Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
    serial: stm32: allow selecting console when the driver is module

Arnaud Lecomte <contact@arnaud-lcm.com>
    hid: fix I2C read buffer overflow in raw_event() for mcp2221

hupu <hupu.gm@gmail.com>
    perf subcmd: avoid crash in exclude_cmds when excludes is empty

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: limit MAX_TAG_SIZE to 255

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtlwifi: rtl8192cu: Don't claim USB ID 07b8:8188

Xiaowei Li <xiaowei.li@simcom.com>
    USB: serial: option: add SIMCom 8230C compositions

Duoming Zhou <duoming@zju.edu.cn>
    media: i2c: tc358743: Fix use-after-free bugs caused by orphan timer in probe

Duoming Zhou <duoming@zju.edu.cn>
    media: tuner: xc5000: Fix use-after-free in xc5000_release

Ricardo Ribalda <ribalda@chromium.org>
    media: tunner: xc5000: Refactor firmware load

Kuniyuki Iwashima <kuniyu@amazon.com>
    udp: Fix memory accounting leak.

Larshin Sergey <Sergey.Larshin@kaspersky.com>
    media: rc: fix races with imon_disconnect()

Duoming Zhou <duoming@zju.edu.cn>
    media: b2c2: Fix use-after-free causing by irq_check_work in flexcop_pci_remove

Wang Haoran <haoranwangsec@gmail.com>
    scsi: target: target_core_configfs: Add length check to avoid buffer overflow


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-pci            |   9 +
 Documentation/admin-guide/kernel-parameters.txt    |   3 +
 Documentation/arm64/silicon-errata.rst             |   2 +
 Documentation/trace/histogram-design.rst           |   4 +-
 Makefile                                           |   4 +-
 arch/arm/mach-omap2/pm33xx-core.c                  |   6 +-
 arch/arm/mm/pageattr.c                             |   6 +-
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/boot/dts/mediatek/mt8516-pumpkin.dts    |   2 +-
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |   2 +
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |   4 +-
 arch/arm64/include/asm/cputype.h                   |   2 +
 arch/arm64/include/asm/pgtable.h                   |   3 +-
 arch/arm64/kernel/cpu_errata.c                     |   1 +
 arch/arm64/kernel/cpufeature.c                     |  10 +-
 arch/arm64/kernel/mte.c                            |   3 +-
 arch/m68k/include/asm/bitops.h                     |  25 +-
 arch/mips/mti-malta/malta-setup.c                  |   2 +-
 arch/parisc/include/uapi/asm/ioctls.h              |   8 +-
 arch/sparc/kernel/of_device_32.c                   |   1 +
 arch/sparc/kernel/of_device_64.c                   |   1 +
 arch/sparc/lib/M7memcpy.S                          |  20 +-
 arch/sparc/lib/Memcpy_utils.S                      |   9 +
 arch/sparc/lib/NG4memcpy.S                         |   2 +-
 arch/sparc/lib/NGmemcpy.S                          |  29 ++-
 arch/sparc/lib/U1memcpy.S                          |  19 +-
 arch/sparc/lib/U3memcpy.S                          |   2 +-
 arch/sparc/mm/hugetlbpage.c                        |  20 ++
 arch/um/drivers/mconsole_user.c                    |   2 +
 arch/x86/include/asm/segment.h                     |   8 +-
 arch/x86/kernel/umip.c                             |  15 +-
 arch/x86/kvm/emulate.c                             |  11 +-
 arch/x86/kvm/kvm_emulate.h                         |   2 +-
 arch/x86/kvm/x86.c                                 |   9 +-
 arch/x86/mm/pgtable.c                              |   2 +-
 block/blk-crypto-fallback.c                        |   3 +
 block/blk-mq-sysfs.c                               |   6 +-
 block/blk-settings.c                               |   3 +-
 crypto/essiv.c                                     |  14 +-
 crypto/rng.c                                       |   8 +
 drivers/acpi/acpi_dbg.c                            |  26 +-
 drivers/acpi/acpi_tad.c                            |   3 +
 drivers/acpi/nfit/core.c                           |   2 +-
 drivers/acpi/processor_idle.c                      |   3 +
 drivers/android/binder.c                           |  11 +-
 drivers/base/arch_topology.c                       |   2 +-
 drivers/base/node.c                                |   4 +
 drivers/base/power/main.c                          |  14 +-
 drivers/base/power/runtime.c                       |  44 ++++
 drivers/base/regmap/regmap.c                       |   2 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |   3 +
 drivers/bus/mhi/host/init.c                        |   5 +-
 drivers/char/hw_random/ks-sa-rng.c                 |   4 +
 drivers/char/tpm/tpm_tis_core.c                    |   4 +-
 drivers/clk/at91/clk-peripheral.c                  |   7 +-
 drivers/clk/nxp/clk-lpc18xx-cgu.c                  |  20 +-
 drivers/clocksource/clps711x-timer.c               |  23 +-
 drivers/cpufreq/intel_pstate.c                     |   8 +-
 drivers/cpuidle/governors/menu.c                   |  21 +-
 drivers/crypto/atmel-tdes.c                        |   2 +-
 drivers/crypto/rockchip/rk3288_crypto_ahash.c      |   3 +-
 drivers/dma/ioat/dma.c                             |  12 +-
 drivers/edac/sb_edac.c                             |   4 +-
 drivers/edac/skx_common.h                          |   1 -
 drivers/firmware/meson/meson_sm.c                  |   7 +-
 drivers/gpio/gpio-wcd934x.c                        |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   5 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c              |   7 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c              |   7 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c              |  29 ++-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   5 +-
 drivers/gpu/drm/amd/display/dc/dce/dce_transform.c |  21 +-
 drivers/gpu/drm/amd/display/dc/dce/dce_transform.h |   4 +
 .../gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c    |   2 +
 .../gpu/drm/amd/include/asic_reg/dce/dce_6_0_d.h   |   7 +
 .../drm/amd/include/asic_reg/dce/dce_6_0_sh_mask.h |   2 +
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h |  14 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |   3 +-
 drivers/gpu/drm/arm/display/include/malidp_utils.h |   2 +-
 .../drm/arm/display/komeda/komeda_pipeline_state.c |  24 +-
 drivers/gpu/drm/drm_color_mgmt.c                   |   2 +-
 drivers/gpu/drm/exynos/exynos7_drm_decon.c         |  36 ---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |   6 -
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   2 +-
 drivers/gpu/drm/radeon/evergreen_cs.c              |   2 +
 drivers/gpu/drm/radeon/r600_cs.c                   |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_validation.c         |   4 +-
 drivers/hid/hid-mcp2221.c                          |   4 +
 drivers/hid/hid-multitouch.c                       |  27 ++-
 drivers/hwmon/adt7475.c                            |  24 +-
 drivers/i2c/busses/i2c-designware-platdrv.c        |   1 +
 drivers/i2c/busses/i2c-mt65xx.c                    |  17 +-
 drivers/iio/dac/ad5360.c                           |   2 +-
 drivers/iio/dac/ad5421.c                           |   2 +-
 drivers/iio/frequency/adf4350.c                    |  20 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c  |   5 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c   |  39 +--
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c   |   5 +-
 drivers/iio/inkern.c                               |   2 +-
 drivers/infiniband/core/addr.c                     |  10 +-
 drivers/infiniband/core/cm.c                       |   4 +-
 drivers/infiniband/core/sa_query.c                 |   6 +-
 drivers/infiniband/sw/siw/siw_verbs.c              |  25 +-
 drivers/input/misc/uinput.c                        |   1 +
 drivers/input/touchscreen/atmel_mxt_ts.c           |   2 +-
 drivers/input/touchscreen/cyttsp4_core.c           |   2 +-
 drivers/mailbox/zynqmp-ipi-mailbox.c               |   7 +-
 drivers/md/dm-integrity.c                          |   8 +-
 drivers/md/dm.c                                    |   7 +-
 drivers/media/dvb-frontends/stv0367_priv.h         |   3 +
 drivers/media/i2c/mt9v111.c                        |   2 +-
 drivers/media/i2c/rj54n1cb0c.c                     |   9 +-
 drivers/media/i2c/tc358743.c                       |   4 +-
 drivers/media/mc/mc-devnode.c                      |   6 +-
 drivers/media/pci/b2c2/flexcop-pci.c               |   2 +-
 drivers/media/pci/cx18/cx18-queue.c                |  12 +-
 drivers/media/pci/ivtv/ivtv-driver.c               |   2 +-
 drivers/media/pci/ivtv/ivtv-irq.c                  |   2 +-
 drivers/media/pci/ivtv/ivtv-queue.c                |  18 +-
 drivers/media/pci/ivtv/ivtv-streams.c              |  22 +-
 drivers/media/pci/ivtv/ivtv-udma.c                 |  27 ++-
 drivers/media/pci/ivtv/ivtv-yuv.c                  |  24 +-
 drivers/media/pci/ivtv/ivtvfb.c                    |   6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c    |  35 +--
 drivers/media/rc/imon.c                            |  27 ++-
 drivers/media/rc/lirc_dev.c                        |  15 +-
 drivers/media/rc/rc-main.c                         |   6 +-
 drivers/media/tuners/xc5000.c                      |  41 ++--
 drivers/memory/samsung/exynos-srom.c               |  10 +-
 drivers/mfd/intel_soc_pmic_chtdc_ti.c              |   5 +-
 drivers/mfd/vexpress-sysreg.c                      |   6 +-
 drivers/misc/genwqe/card_ddcb.c                    |   2 +-
 drivers/misc/mei/hw-me-regs.h                      |   2 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/mmc/core/sdio.c                            |   6 +-
 drivers/most/most_usb.c                            |  13 +-
 drivers/mtd/nand/raw/fsmc_nand.c                   |   6 +-
 drivers/net/bonding/bond_main.c                    |  40 ++-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |   5 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |   1 -
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |   1 +
 drivers/net/ethernet/broadcom/tg3.c                |   5 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |  18 +-
 drivers/net/ethernet/dlink/dl2k.c                  |  30 ++-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   3 +-
 drivers/net/ethernet/freescale/enetc/enetc.h       |   2 +-
 drivers/net/ethernet/freescale/fsl_pq_mdio.c       |   2 +
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   2 +-
 .../ethernet/mellanox/mlx5/core/en/port_buffer.h   |  12 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  17 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   2 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   5 +-
 drivers/net/ethernet/renesas/ravb_main.c           |   8 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   2 +-
 drivers/net/fjes/fjes_main.c                       |   4 +-
 drivers/net/usb/aqc111.c                           |   2 +-
 drivers/net/usb/lan78xx.c                          |  42 +++-
 drivers/net/usb/r8152.c                            |   2 +-
 drivers/net/usb/rndis_host.c                       |   2 +-
 drivers/net/usb/rtl8150.c                          |  15 +-
 drivers/net/wireless/ath/ath11k/core.c             |   6 +-
 drivers/net/wireless/ath/ath11k/hal.c              |  16 ++
 drivers/net/wireless/ath/ath11k/hal.h              |   1 +
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   7 +-
 drivers/net/wireless/mediatek/mt76/mt7603/soc.c    |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c     |   8 +-
 drivers/net/wireless/ralink/rt2x00/rt2400pci.h     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c     |   8 +-
 drivers/net/wireless/ralink/rt2x00/rt2500pci.h     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500usb.c     |   8 +-
 drivers/net/wireless/ralink/rt2x00/rt2500usb.h     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |  36 +--
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h     |   8 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c     |   6 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.c       |   4 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.h       |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt73usb.c       |   4 +-
 drivers/net/wireless/ralink/rt2x00/rt73usb.h       |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/sw.c    |   1 -
 drivers/nfc/pn544/i2c.c                            |   2 -
 drivers/pci/controller/cadence/pci-j721e.c         |  25 ++
 drivers/pci/controller/dwc/pci-keystone.c          |   4 +-
 drivers/pci/controller/dwc/pcie-tegra194.c         |  22 +-
 drivers/pci/controller/pci-tegra.c                 |   2 +-
 drivers/pci/iov.c                                  |   5 +
 drivers/pci/pci-driver.c                           |   1 +
 drivers/pci/pci-label.c                            |  10 +-
 drivers/pci/pci-sysfs.c                            |  98 +++++---
 drivers/pci/pcie/aer.c                             |  12 +-
 drivers/pci/pcie/err.c                             |   8 +-
 drivers/perf/arm_spe_pmu.c                         |   3 +-
 drivers/pinctrl/meson/pinctrl-meson-gxl.c          |  10 +
 drivers/pinctrl/pinmux.c                           |   2 +-
 drivers/pinctrl/renesas/pinctrl.c                  |   3 +-
 drivers/platform/x86/sony-laptop.c                 |   1 -
 drivers/pps/kapi.c                                 |   5 +-
 drivers/pps/pps.c                                  |   5 +-
 drivers/pwm/pwm-berlin.c                           |   4 +-
 drivers/pwm/pwm-tiehrpwm.c                         |   4 +-
 drivers/remoteproc/qcom_q6v5.c                     |   3 -
 drivers/rtc/interface.c                            |  27 +++
 drivers/rtc/rtc-x1205.c                            |   2 +-
 drivers/scsi/hpsa.c                                |  21 +-
 drivers/scsi/isci/init.c                           |   6 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |   8 +-
 drivers/scsi/mvsas/mv_defs.h                       |   1 +
 drivers/scsi/mvsas/mv_init.c                       |  13 +-
 drivers/scsi/mvsas/mv_sas.c                        |  42 ++--
 drivers/scsi/mvsas/mv_sas.h                        |   8 +-
 drivers/scsi/myrs.c                                |   8 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |   9 +-
 drivers/soc/qcom/rpmh-rsc.c                        |   7 +-
 drivers/spi/spi-cadence-quadspi.c                  |   5 +
 drivers/staging/axis-fifo/axis-fifo.c              |  32 ++-
 drivers/staging/comedi/comedi_buf.c                |   2 +-
 .../pci/hive_isp_css_include/math_support.h        |   5 -
 drivers/target/target_core_configfs.c              |   2 +-
 drivers/tty/serial/8250/8250_exar.c                |  11 +
 drivers/tty/serial/Kconfig                         |   2 +-
 drivers/tty/serial/max310x.c                       |   2 +
 drivers/uio/uio_hv_generic.c                       |   7 +-
 drivers/usb/core/quirks.c                          |   2 +
 drivers/usb/gadget/configfs.c                      |   2 +
 drivers/usb/gadget/legacy/raw_gadget.c             |   2 -
 drivers/usb/host/max3421-hcd.c                     |   2 +-
 drivers/usb/host/xhci-dbgcap.c                     |   9 +-
 drivers/usb/phy/phy-twl6030-usb.c                  |   3 +-
 drivers/usb/serial/option.c                        |  16 ++
 drivers/usb/usbip/vhci_hcd.c                       |  22 ++
 drivers/watchdog/mpc8xxx_wdt.c                     |   2 +
 drivers/xen/events/events_base.c                   |  20 +-
 drivers/xen/manage.c                               |   3 +-
 fs/btrfs/ctree.h                                   |   2 -
 fs/btrfs/export.c                                  |   8 +-
 fs/btrfs/extent_io.c                               |   1 +
 fs/btrfs/file-item.c                               |   1 +
 fs/btrfs/misc.h                                    |   2 -
 fs/btrfs/raid56.c                                  |   1 +
 fs/btrfs/tree-checker.c                            |   2 +-
 fs/cramfs/inode.c                                  |  11 +-
 fs/dax.c                                           |  54 +++--
 fs/dcache.c                                        |   2 +
 fs/dlm/lockspace.c                                 |   2 +-
 fs/erofs/zdata.h                                   |   2 +-
 fs/exec.c                                          |   2 +-
 fs/ext2/balloc.c                                   |   2 -
 fs/ext4/ext4.h                                     |   2 -
 fs/ext4/fsmap.c                                    |  14 +-
 fs/ext4/inode.c                                    |  18 +-
 fs/ext4/super.c                                    |  10 +-
 fs/ext4/xattr.c                                    |  15 +-
 fs/file.c                                          |   5 +-
 fs/fsopen.c                                        |  70 +++---
 fs/fuse/file.c                                     |   8 +-
 fs/hfs/bfind.c                                     |   8 +-
 fs/hfs/brec.c                                      |  27 ++-
 fs/hfs/mdb.c                                       |   2 +-
 fs/hfsplus/bfind.c                                 |   8 +-
 fs/hfsplus/bnode.c                                 |  41 ----
 fs/hfsplus/btree.c                                 |   6 +
 fs/hfsplus/hfsplus_fs.h                            |  42 ++++
 fs/hfsplus/super.c                                 |  25 +-
 fs/hfsplus/unicode.c                               |  24 ++
 fs/iomap/apply.c                                   |  74 +++++-
 fs/iomap/trace.h                                   |  37 ++-
 fs/jbd2/transaction.c                              |  13 +-
 fs/minix/inode.c                                   |   8 +-
 fs/namei.c                                         |   8 +
 fs/namespace.c                                     |  11 +-
 fs/nfs/nfs4proc.c                                  |   2 +-
 fs/nfsd/blocklayout.c                              |   5 +-
 fs/nfsd/blocklayoutxdr.c                           |   7 +-
 fs/nfsd/flexfilelayout.c                           |   8 +
 fs/nfsd/flexfilelayoutxdr.c                        |   3 +-
 fs/nfsd/lockd.c                                    |  15 ++
 fs/nfsd/nfs4layouts.c                              |   1 -
 fs/nfsd/nfs4proc.c                                 |  36 ++-
 fs/nfsd/nfs4xdr.c                                  |  14 +-
 fs/nfsd/xdr4.h                                     |  36 ++-
 fs/ocfs2/move_extents.c                            |   5 +
 fs/ocfs2/stack_user.c                              |   1 +
 fs/squashfs/inode.c                                |  31 ++-
 fs/squashfs/squashfs_fs_i.h                        |   2 +-
 fs/udf/inode.c                                     |  12 +-
 fs/ufs/util.h                                      |   6 -
 include/linux/cleanup.h                            | 171 +++++++++++++
 include/linux/compiler-clang.h                     |   9 +
 include/linux/compiler.h                           |  15 ++
 include/linux/compiler_attributes.h                |   6 +
 include/linux/device.h                             |  10 +
 include/linux/file.h                               |   6 +
 include/linux/iio/frequency/adf4350.h              |   2 +-
 include/linux/iomap.h                              |  56 +++++
 include/linux/irqflags.h                           |   7 +
 include/linux/minmax.h                             | 267 ++++++++++++++++-----
 include/linux/mutex.h                              |   4 +
 include/linux/netdevice.h                          |   9 +
 include/linux/overflow.h                           |   1 -
 include/linux/percpu.h                             |   4 +
 include/linux/pm_runtime.h                         |   4 +
 include/linux/preempt.h                            |   5 +
 include/linux/rcupdate.h                           |   3 +
 include/linux/rwsem.h                              |   9 +
 include/linux/sched/task.h                         |   2 +
 include/linux/slab.h                               |   3 +
 include/linux/spinlock.h                           |  32 +++
 include/linux/srcu.h                               |   5 +
 include/linux/trace_events.h                       |   2 -
 include/net/ip_tunnels.h                           |  15 ++
 include/net/rtnetlink.h                            |  16 +-
 include/scsi/libsas.h                              |  18 ++
 include/trace/events/filelock.h                    |   3 +-
 include/uapi/linux/netlink.h                       |   1 +
 init/main.c                                        |  14 ++
 kernel/fork.c                                      |   2 +-
 kernel/padata.c                                    |   6 +-
 kernel/pid.c                                       |   2 +-
 kernel/sched/fair.c                                |  38 +--
 kernel/trace/preemptirq_delay_test.c               |   2 -
 kernel/trace/trace_kprobe.c                        |  11 +-
 kernel/trace/trace_probe.h                         |   9 +-
 kernel/trace/trace_uprobe.c                        |  12 +-
 lib/btree.c                                        |   1 -
 lib/crypto/Makefile                                |   4 +
 lib/decompress_unlzma.c                            |   2 +
 lib/genalloc.c                                     |   5 +-
 lib/logic_pio.c                                    |   3 -
 lib/vsprintf.c                                     |   2 +-
 lib/zstd/zstd_internal.h                           |   2 -
 mm/hugetlb.c                                       |   2 +
 mm/zsmalloc.c                                      |   1 -
 net/9p/trans_fd.c                                  |   8 +-
 net/bluetooth/mgmt.c                               |  10 +-
 net/core/filter.c                                  |  18 +-
 net/core/rtnetlink.c                               |  87 +++++--
 net/ipv4/ip_tunnel.c                               |  14 --
 net/ipv4/proc.c                                    |   2 +-
 net/ipv4/tcp.c                                     |   9 +-
 net/ipv4/tcp_input.c                               |   1 -
 net/ipv4/tcp_output.c                              |  19 +-
 net/ipv4/udp.c                                     |  16 +-
 net/ipv6/ip6_tunnel.c                              |   3 +-
 net/ipv6/proc.c                                    |   2 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   8 +-
 net/netfilter/ipvs/ip_vs_ftp.c                     |   4 +-
 net/netfilter/nf_nat_core.c                        |   6 +-
 net/sctp/inqueue.c                                 |  13 +-
 net/sctp/sm_make_chunk.c                           |   3 +-
 net/sctp/sm_statefuns.c                            |   6 +-
 net/tipc/core.h                                    |   2 +-
 net/tipc/link.c                                    |  10 +-
 net/tls/tls_main.c                                 |   7 +-
 net/tls/tls_sw.c                                   |  13 +
 net/vmw_vsock/af_vsock.c                           |  38 +--
 scripts/checkpatch.pl                              |   2 +-
 security/keys/trusted-keys/trusted_tpm1.c          |   7 +-
 sound/firewire/amdtp-stream.h                      |   2 +-
 sound/pci/lx6464es/lx_core.c                       |   4 +-
 sound/soc/codecs/wcd934x.c                         |  30 ++-
 sound/soc/intel/boards/bytcht_es8316.c             |  20 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |   7 +-
 sound/soc/intel/boards/bytcr_rt5651.c              |  26 +-
 tools/build/feature/Makefile                       |   4 +-
 tools/lib/bpf/libbpf.c                             |  10 +
 tools/lib/perf/include/perf/event.h                |   1 +
 tools/lib/subcmd/help.c                            |   3 +
 tools/perf/util/lzma.c                             |   2 +-
 tools/perf/util/session.c                          |   2 +-
 tools/perf/util/zlib.c                             |   2 +-
 tools/testing/selftests/arm64/pauth/exec_target.c  |   7 +-
 tools/testing/selftests/rseq/rseq.c                |   8 +-
 tools/testing/selftests/watchdog/watchdog-test.c   |   6 +
 372 files changed, 2799 insertions(+), 1321 deletions(-)


