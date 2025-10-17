Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF09F2F12B0;
	Fri, 17 Oct 2025 15:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714121; cv=none; b=PIdGGkal+B8xD2hrzHncNM0/foT1HKc8rY3ODFGmhHSjlrn8OVru/Dl75ZsckoOfYGwXxkEGWGyv4geGypgcyg42d/ePdQK6Aa+lf1haATu99ga051fh7DefzPJDCXO12KvvU5ankj2YqkC4yewHNXj9HUxZzQt2fHoODh8Id34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714121; c=relaxed/simple;
	bh=ACSHGd63U0OJWqBTHze1qxqB3AzIi5wB6rnHb/fW540=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oHZw/Y5vqqiY8w2fJW2hZqSIBplo1EIu2en0Ru2U5fIJ+jwDBixn9QP78zkk4Q1/hXzfQffU879FTLD7+x7Pm0R0kEE3TYaeYiQ6XRzPqWSaMhF/EKek/f6eTGomVW7xkk9TXVroSISPkHM3BzFpvOPnJBiy6RXwsOywF7aiX7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahSdJbGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahSdJbGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01D3C4CEE7;
	Fri, 17 Oct 2025 15:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714121;
	bh=ACSHGd63U0OJWqBTHze1qxqB3AzIi5wB6rnHb/fW540=;
	h=From:To:Cc:Subject:Date:From;
	b=ahSdJbGxVMvbNvklC3F3dkZQCWUKYSZo+08OApH1gvFYBGvUWKpydqLtgoPa6r2H7
	 BiqMEEBL1y08D72T51/eCtHx4DYAhxLdcgqQjtfeeu8uZJab0dwyBGziVDE8X4OGUL
	 gvuUy9CWoOI4alZLUQ+8LYauGxy1t6gwUtPlczDs=
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
Subject: [PATCH 6.12 000/277] 6.12.54-rc1 review
Date: Fri, 17 Oct 2025 16:50:07 +0200
Message-ID: <20251017145147.138822285@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.54-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.54-rc1
X-KernelTest-Deadline: 2025-10-19T14:51+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.54 release.
There are 277 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.54-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.54-rc1

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: SOF: ipc4-pcm: fix start offset calculation for chain DMA

Olga Kornievskaia <okorniev@redhat.com>
    nfsd: fix access checking for NLM under XPRTSEC policies

Olga Kornievskaia <okorniev@redhat.com>
    nfsd: fix __fh_verify for localio

Ian Rogers <irogers@google.com>
    perf test stat: Avoid hybrid assumption when virtualized

K Prateek Nayak <kprateek.nayak@amd.com>
    sched/fair: Block delayed tasks on throttled hierarchy during dequeue

Jan Kara <jack@suse.cz>
    writeback: Avoid excessively long inode switching times

Jan Kara <jack@suse.cz>
    writeback: Avoid softlockup when switching many inodes

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    cramfs: Verify inode mode when loading from disk

Lichen Liu <lichliu@redhat.com>
    fs: Add 'initramfs_options' to set initramfs mount options

Oleg Nesterov <oleg@redhat.com>
    pid: make __task_pid_nr_ns(ns => NULL) safe for zombie callers

gaoxiang17 <gaoxiang17@xiaomi.com>
    pid: Add a judgment for ns null in pid_nr_ns

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    minixfs: Verify inode mode when loading from disk

Miklos Szeredi <mszeredi@redhat.com>
    copy_file_range: limit size if in compat mode

Lucas Zampieri <lzampier@redhat.com>
    irqchip/sifive-plic: Avoid interrupt ID 0 handling during suspend/resume

Hongbo Li <lihongbo22@huawei.com>
    irqchip/sifive-plic: Make use of __assign_bit()

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Write back tail call counter for BPF_TRAMP_F_CALL_ORIG

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Write back tail call counter for BPF_PSEUDO_CALL

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Describe the frame using a struct instead of constants

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Centralize frame offset calculations

Lance Yang <lance.yang@linux.dev>
    mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-filled mTHP subpage to shared zeropage

Guenter Roeck <linux@roeck-us.net>
    ipmi: Fix handling of messages with provided receive message pointer

Corey Minyard <corey@minyard.net>
    ipmi: Rework user message limit handling

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: in-kernel: usable client side with C-flag

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: property: Do not pass NULL handles to acpi_attach_data()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: property: Add code comments explaining what is going on

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: property: Disregard references in data-only subnode lists

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: battery: Add synchronization between interface updates

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ACPI: battery: Check for error code from devm_mutex_init() call

Thomas Weißschuh <linux@weissschuh.net>
    ACPI: battery: initialize mutexes through devm_ APIs

Thomas Weißschuh <linux@weissschuh.net>
    ACPI: battery: allocate driver data through devm_ APIs

Olga Kornievskaia <okorniev@redhat.com>
    nfsd: unregister with rpcbind when deleting a transport

NeilBrown <neilb@suse.de>
    nfsd: don't use sv_nrthreads in connection limiting calculations.

NeilBrown <neilb@suse.de>
    nfsd: refine and rename NFSD_MAY_LOCK

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace use of NFSD_MAY_LOCK in nfsd4_lock()

Pali Rohár <pali@kernel.org>
    nfsd: Fix NFSD_MAY_BYPASS_GSS and NFSD_MAY_BYPASS_GSS_ON_ROOT

Sean Christopherson <seanjc@google.com>
    x86/kvm: Force legacy PCI hole to UC when overriding MTRRs for TDX/SNP

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    x86/mtrr: Rename mtrr_overwrite_state() to guest_force_mtrr_state()

Catalin Marinas <catalin.marinas@arm.com>
    arm64: mte: Do not flag the zero page as PG_mte_tagged

Christian Brauner <brauner@kernel.org>
    statmount: don't call path_put() under namespace semaphore

Borislav Petkov (AMD) <bp@alien8.de>
    KVM: x86: Advertise SRSO_USER_KERNEL_NO to userspace

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Make drivers using CPUFREQ_ETERNAL specify transition latency

Qu Wenruo <wqu@suse.com>
    btrfs: fix the incorrect max_bytes value for find_lock_delalloc_range()

Hans de Goede <hansg@kernel.org>
    mfd: intel_soc_pmic_chtdc_ti: Set use_single_read regmap_config flag

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_soc_pmic_chtdc_ti: Drop unneeded assignment for cache_type

Hans de Goede <hdegoede@redhat.com>
    mfd: intel_soc_pmic_chtdc_ti: Fix invalid regmap-config max_register value

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: SOF: ipc4-pcm: fix delay calculation when DSP resamples

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-pcm: Enable delay reporting for ChainDMA streams

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    PCI: endpoint: pci-epf-test: Add NULL check for DMA channels before release

Wang Jiang <jiangwang@kylinos.cn>
    PCI: endpoint: Remove surplus return statement from pci_epf_test_clean_dma_chan()

Donet Tom <donettom@linux.ibm.com>
    mm/ksm: fix incorrect KSM counter handling in mm_struct during fork

Yuan Chen <chenyuan@kylinos.cn>
    tracing: Fix race condition in kprobe initialization causing NULL pointer dereference

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: reject negative file sizes in squashfs_read_inode()

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: add additional inode sanity checking

Edward Adam Davis <eadavis@qq.com>
    media: mc: Clear minor number before put device

Lance Yang <lance.yang@linux.dev>
    selftests/mm: skip soft-dirty tests when CONFIG_MEM_SOFT_DIRTY is disabled

Nathan Chancellor <nathan@kernel.org>
    lib/crypto/curve25519-hacl64: Disable KASAN with clang-17 and older

Jan Kara <jack@suse.cz>
    ext4: free orphan info with kvfree

Huacai Chen <chenhuacai@kernel.org>
    ACPICA: Allow to skip Global Lock initialization

Deepanshu Kartikey <kartikey406@gmail.com>
    ext4: validate ea_ino and size in check_xattrs

Ahmet Eray Karadag <eraykrdg1@gmail.com>
    ext4: guard against EA inode refcount underflow in xattr update

Zhang Yi <yi.zhang@huawei.com>
    ext4: fix an off-by-one issue during moving extents

Theodore Ts'o <tytso@mit.edu>
    ext4: avoid potential buffer over-read in parse_apply_sb_mount_options()

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: correctly handle queries for metadata mappings

Yongjian Sun <sunyongjian1@huawei.com>
    ext4: increase i_disksize to offset + len in ext4_update_disksize_before_punch()

Jan Kara <jack@suse.cz>
    ext4: verify orphan file size is not too big

Baokun Li <libaokun1@huawei.com>
    ext4: add ext4_sb_bread_nofail() helper function for ext4_free_branches()

Olga Kornievskaia <okorniev@redhat.com>
    nfsd: nfserr_jukebox in nlm_fopen should lead to a retry

Thorsten Blum <thorsten.blum@linux.dev>
    NFSD: Fix destination buffer size in nfsd4_ssc_setup_dul()

SeongJae Park <sj@kernel.org>
    mm/damon/lru_sort: use param_ctx for damon_attrs staging

SeongJae Park <sj@kernel.org>
    mm/damon/vaddr: do not repeat pte_offset_map_lock() until success

Li RongQing <lirongqing@baidu.com>
    mm/hugetlb: early exit from hugetlb_pages_alloc_boot() when max_huge_pages=0

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    mm/page_alloc: only set ALLOC_HIGHATOMIC for __GPF_HIGH allocations

Lance Yang <lance.yang@linux.dev>
    mm/thp: fix MTE tag mismatch when replacing zero-filled subpages

Nick Morrow <morrownr@gmail.com>
    wifi: mt76: mt7921u: Add VID/PID for Netgear A7500

Nick Morrow <morrownr@gmail.com>
    wifi: mt76: mt7925u: Add VID/PID for Netgear A9000

Muhammad Usama Anjum <usama.anjum@collabora.com>
    wifi: ath11k: HAL SRNG: don't deinitialize and re-initialize again

Suren Baghdasaryan <surenb@google.com>
    slab: mark slab->obj_exts allocation failures unconditionally

Suren Baghdasaryan <surenb@google.com>
    slab: prevent warnings when slab obj_exts vector allocation fails

Heiko Carstens <hca@linux.ibm.com>
    s390: Add -Wno-pointer-sign to KBUILD_CFLAGS_DECOMPRESSOR

Jaehoon Kim <jhkim@linux.ibm.com>
    s390/dasd: Return BLK_STS_INVAL for EINVAL from do_dasd_request

Jaehoon Kim <jhkim@linux.ibm.com>
    s390/dasd: enforce dma_alignment to ensure proper buffer validation

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: validate C-flag + def limit

Sean Christopherson <seanjc@google.com>
    x86/umip: Fix decoding of register forms of 0F 01 (SGDT and SIDT aliases)

Sean Christopherson <seanjc@google.com>
    x86/umip: Check that the instruction opcode is at least two bytes

Xin Li (Intel) <xin@zytor.com>
    x86/fred: Remove ENDBR64 from FRED entry points

Santhosh Kumar K <s-k6@ti.com>
    spi: cadence-quadspi: Fix cqspi_setup_flash()

Pratyush Yadav <pratyush@kernel.org>
    spi: cadence-quadspi: Flush posted register writes before DAC access

Pratyush Yadav <pratyush@kernel.org>
    spi: cadence-quadspi: Flush posted register writes before INDAC access

Niklas Cassel <cassel@kernel.org>
    PCI: tegra194: Reset BARs when running in PCIe endpoint mode

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Handle errors in BPMP response

Niklas Cassel <cassel@kernel.org>
    PCI: tegra194: Fix broken tegra_pcie_ep_raise_msi_irq()

Marek Vasut <marek.vasut+renesas@mailbox.org>
    PCI: rcar-host: Convert struct rcar_msi mask_lock into raw spinlock

Marek Vasut <marek.vasut+renesas@mailbox.org>
    PCI: rcar-host: Drop PMSR spinlock

Marek Vasut <marek.vasut+renesas@mailbox.org>
    PCI: rcar-gen4: Fix PHY initialization

Siddharth Vadapalli <s-vadapalli@ti.com>
    PCI: keystone: Use devm_request_irq() to free "ks-pcie-error-irq" on exit

Siddharth Vadapalli <s-vadapalli@ti.com>
    PCI: j721e: Fix programming sequence of "strap" settings

Lukas Wunner <lukas@wunner.de>
    PCI/AER: Support errors introduced by PCIe r6.0

Niklas Schnelle <schnelle@linux.ibm.com>
    PCI/AER: Fix missing uevent on recovery when a reset is requested

Lukas Wunner <lukas@wunner.de>
    PCI/ERR: Fix uevent on failure to recover

Niklas Schnelle <schnelle@linux.ibm.com>
    PCI/IOV: Add PCI rescan-remove locking when enabling/disabling SR-IOV

Brian Norris <briannorris@google.com>
    PCI/sysfs: Ensure devices are powered for config reads

Marek Vasut <marek.vasut+renesas@mailbox.org>
    PCI: tegra: Convert struct tegra_msi mask_lock into raw spinlock

Jani Nurminen <jani.nurminen@windriver.com>
    PCI: xilinx-nwl: Fix ECAM programming

Sean Christopherson <seanjc@google.com>
    rseq/selftests: Use weak symbol reference, not definition, to link with glibc

Esben Haabendal <esben@geanix.com>
    rtc: interface: Fix long-standing race when setting alarm

Esben Haabendal <esben@geanix.com>
    rtc: interface: Ensure alarm irq is enabled when UIE is enabled

Zhen Ni <zhen.ni@easystack.cn>
    memory: samsung: exynos-srom: Fix of_iomap leak in exynos_srom_probe

Rex Chen <rex.chen_1@nxp.com>
    mmc: mmc_spi: multiple block read remove read crc ack

Rex Chen <rex.chen_1@nxp.com>
    mmc: core: SPI mode remove cmd7

Linus Walleij <linus.walleij@linaro.org>
    mtd: rawnand: fsmc: Default to autodetect buswidth

Alexander Lobakin <aleksander.lobakin@intel.com>
    xsk: Harden userspace-supplied xdp_desc validation

Miaoqian Lin <linmq006@gmail.com>
    xtensa: simdisk: add input size check in proc_write_simdisk

Ma Ke <make24@iscas.ac.cn>
    sparc: fix error handling in scan_one_device()

Anthony Yznaga <anthony.yznaga@oracle.com>
    sparc64: fix hugetlb for sun4u

Eric Biggers <ebiggers@kernel.org>
    sctp: Fix MAC comparison to be constant-time

Abinash Singh <abinashsinghlalotra@gmail.com>
    scsi: sd: Fix build warning in sd_revalidate_disk()

Thorsten Blum <thorsten.blum@linux.dev>
    scsi: hpsa: Fix potential memory leak in hpsa_big_passthru_ioctl()

Harshit Agarwal <harshit@nutanix.com>
    sched/deadline: Fix race in push_dl_task()

Corey Minyard <corey@minyard.net>
    Revert "ipmi: fix msg stack when IPMI is disconnected"

Jisheng Zhang <jszhang@kernel.org>
    pwm: berlin: Fix wrong register in suspend/resume

Nam Cao <namcao@linutronix.de>
    powerpc/pseries/msi: Fix potential underflow and leak issue

Nam Cao <namcao@linutronix.de>
    powerpc/powernv/pci: Fix underflow and leak issue

Dzmitry Sankouski <dsankouski@gmail.com>
    power: supply: max77976_charger: fix constant current reporting

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    pinctrl: samsung: Drop unused S3C24xx driver data

Georg Gottleuber <ggo@tuxedocomputers.com>
    nvme-pci: Add TUXEDO IBS Gen8 to Samsung sleep quirk

John David Anglin <dave.anglin@bell.net>
    parisc: Remove spurious if statement from raw_copy_from_user()

Sam James <sam@gentoo.org>
    parisc: don't reference obsolete termio struct for TC* constants

Askar Safin <safinaskar@zohomail.com>
    openat2: don't trigger automounts with RESOLVE_NO_XDEV

Ma Ke <make24@iscas.ac.cn>
    of: unittest: Fix device reference count leak in of_unittest_pci_node_verify

Li Chen <me@linux.beauty>
    loop: fix backing file reference leak on validation error

Johan Hovold <johan@kernel.org>
    lib/genalloc: fix device leak in of_gen_pool_get()

Eric Biggers <ebiggers@kernel.org>
    KEYS: trusted_tpm1: Compare HMAC values in constant time

Oleg Nesterov <oleg@redhat.com>
    kernel/sys.c: fix the racy usage of task_lock(tsk->group_leader) in sys_prlimit64() paths

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: PRS isn't usable if PDS isn't supported

Sean Nyekjaer <sean@geanix.com>
    iio: imu: inv_icm42600: Drop redundant pm_runtime reinitialization in resume

Huacai Chen <chenhuacai@kernel.org>
    init: handle bootloader identifier in kernel parameters

Sean Anderson <sean.anderson@linux.dev>
    iio: xilinx-ams: Unmask interrupts after updating alarms

Sean Anderson <sean.anderson@linux.dev>
    iio: xilinx-ams: Fix AMS_ALARM_THR_DIRECT_MASK

Michael Hennerich <michael.hennerich@analog.com>
    iio: frequency: adf4350: Fix prescaler usage.

Qianfeng Rong <rongqianfeng@vivo.com>
    iio: dac: ad5421: use int type to store negative error codes

Qianfeng Rong <rongqianfeng@vivo.com>
    iio: dac: ad5360: use int type to store negative error codes

Aleksandar Gerasimovski <aleksandar.gerasimovski@belden.com>
    iio/adc/pac1934: fix channel disable configuration

Darrick J. Wong <djwong@kernel.org>
    fuse: fix livelock in synchronous file put from fuseblk workers

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix possibly missing fuse_copy_finish() call in fuse_notify()

Shashank A P <shashank.ap@samsung.com>
    fs: quota: create dedicated workqueue for quota_release_work

Haoxiang Li <haoxiang_li2024@163.com>
    fs/ntfs3: Fix a resource leak bug in wnd_extend()

Finn Thain <fthain@linux-m68k.org>
    fbdev: Fix logic error in "offb" name match

Nam Cao <namcao@linutronix.de>
    eventpoll: Replace rwlock with spinlock

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: rockchip - Fix dma_unmap_sg() nents value

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: atmel - Fix dma_unmap_sg() direction

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: aspeed - Fix dma_unmap_sg() direction

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Fix object lifecycle issue in update_qos_request()

Simon Schuster <schuster.simon@siemens-energy.com>
    copy_sighand: Handle architectures where sizeof(unsigned long) < sizeof(u64)

Abel Vesa <abel.vesa@linaro.org>
    clk: qcom: tcsrcc-x1e80100: Set the bi_tcxo as parent to eDP refclk

Adam Xue <zxue@semtech.com>
    bus: mhi: host: Do not use uninitialized 'dev' pointer in mhi_init_irq_setup()

Sumit Kumar <sumit.kumar@oss.qualcomm.com>
    bus: mhi: ep: Fix chained transfer handling in read path

Anderson Nascimento <anderson@allelesecurity.com>
    btrfs: avoid potential out-of-bounds in btrfs_encode_fh()

Yu Kuai <yukuai3@huawei.com>
    blk-crypto: fix missing blktrace bio split events

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Enable Dynamic DTBCLK Switch

Matthew Auld <matthew.auld@intel.com>
    drm/xe/uapi: loosen used tracking restriction

Shuhao Fu <sfual@cse.ust.hk>
    drm/nouveau: fix bad ret code in nouveau_bo_move_prep

Marek Vasut <marek.vasut+renesas@mailbox.org>
    drm/rcar-du: dsi: Fix 1/2/3 lane support

Jann Horn <jannh@google.com>
    drm/panthor: Fix memory leak in panthor_ioctl_group_create()

Ma Ke <make24@iscas.ac.cn>
    media: lirc: Fix error handling in lirc_register()

Jai Luthra <jai.luthra@ideasonboard.com>
    media: ti: j721e-csi2rx: Fix source subdev link creation

Jai Luthra <jai.luthra@ideasonboard.com>
    media: ti: j721e-csi2rx: Use devm_of_platform_populate

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: vivid: fix disappearing <Vendor Command With ID> messages

Stephan Gerhold <stephan.gerhold@linaro.org>
    media: venus: firmware: Use correct reset sequence for IRIS2

Arnd Bergmann <arnd@arndb.de>
    media: s5p-mfc: remove an unused/uninitialized variable

David Lechner <dlechner@baylibre.com>
    media: pci: mg4b: fix uninitialized iio scan data

Thomas Fourier <fourier.thomas@gmail.com>
    media: pci: ivtv: Add missing check after DMA map

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: mc: Fix MUST_CONNECT handling for pads with no links

Qianfeng Rong <rongqianfeng@vivo.com>
    media: i2c: mt9v111: fix incorrect type for ret

Thomas Fourier <fourier.thomas@gmail.com>
    media: cx18: Add missing check after DMA map

Randy Dunlap <rdunlap@infradead.org>
    media: cec: extron-da-hd-4k-plus: drop external-module make commands

Johan Hovold <johan@kernel.org>
    firmware: meson_sm: fix device leak at probe

Jason Andryuk <jason.andryuk@amd.com>
    xen/events: Update virq_to_irq on migration

Jason Andryuk <jason.andryuk@amd.com>
    xen/events: Return -EEXIST for bound VIRQs

Lukas Wunner <lukas@wunner.de>
    xen/manage: Fix suspend error path

Jason Andryuk <jason.andryuk@amd.com>
    xen/events: Cleanup find_virq() return codes

Michael Riesch <michael.riesch@collabora.com>
    dt-bindings: phy: rockchip-inno-csi-dphy: make power-domains non-required

Robin Murphy <robin.murphy@arm.com>
    perf/arm-cmn: Fix CMN S3 DTM offset

Miaoqian Lin <linmq006@gmail.com>
    ARM: OMAP2+: pm33xx-core: ix device node reference leaks in amx3_idle_init

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    ARM: AM33xx: Implement TI advisory 1.0.36 (EMU0/EMU1 pins state on reset)

Yang Shi <yang@os.amperecomputing.com>
    arm64: kprobes: call set_memory_rox() for kprobe page

Vibhore Vardhan <vibhore@ti.com>
    arm64: dts: ti: k3-am62a-main: Fix main padcfg length

Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
    arm64: dts: qcom: x1e80100-pmics: Disable pm8010 by default

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: sdm845: Fix slimbam num-channels/ees

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: msm8939: Add missing MDSS reset

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: msm8916: Add missing MDSS reset

Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
    ACPI: debug: fix signedness issues in read/write helpers

Daniel Tang <danielzgtg.opensource@gmail.com>
    ACPI: TAD: Add missing sysfs_remove_group() for ACPI_TAD_RT

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: property: Fix buffer properties extraction for subnodes

Nathan Chancellor <nathan@kernel.org>
    s390/vmlinux.lds.S: Move .vmlinux.info to end of allocatable sections

Alexey Gladkov <legion@kernel.org>
    s390: vmlinux.lds.S: Reorder sections

KaFai Wan <kafai.wan@linux.dev>
    bpf: Avoid RCU context warning when unpinning htab with internal structs

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: wcd934x: mark the GPIO controller as sleeping

Gunnar Kudrjavets <gunnarku@amazon.com>
    tpm_tis: Fix incorrect arguments in tpm_tis_probe_irq_single

Pali Rohár <pali@kernel.org>
    cifs: Query EA $LXMOD in cifs_query_path_info() for WSL reparse points

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix missing timestamp updates after utime(2)

Fushuai Wang <wangfushuai@baidu.com>
    cifs: Fix copy_to_iter return value check

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: essiv - Check ssize for decryption and in-place encryption

Florian Westphal <fw@strlen.de>
    selftests: netfilter: query conntrack state to check for port clash resolution

Eric Woudstra <ericwouds@gmail.com>
    bridge: br_vlan_fill_forward_path_pvid: use br_vlan_group_rcu()

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nft_objref: validate objref and objrefmap expressions

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Properly disable scaling on DCE6

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Properly clear SCL_*_FILTER_CONTROL on DCE6

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Add missing DCE6 SCL_HORZ_FILTER_INIT* SRIs

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: Add additional DCE6 SCL registers

Jason-JH Lin <jason-jh.lin@mediatek.com>
    mailbox: mtk-cmdq: Remove pm_runtime APIs from cmdq_mbox_send_data()

Sakari Ailus <sakari.ailus@linux.intel.com>
    mailbox: mtk-cmdq: Switch to pm_runtime_put_autosuspend()

Sakari Ailus <sakari.ailus@linux.intel.com>
    mailbox: mtk-cmdq-mailbox: Switch to __pm_runtime_put_autosuspend()

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix metadata_dst leak __bpf_redirect_neigh_v{4,6}

Harini T <harini.t@amd.com>
    mailbox: zynqmp-ipi: Fix SGI cleanup on unbind

Harini T <harini.t@amd.com>
    mailbox: zynqmp-ipi: Fix out-of-bounds access in mailbox cleanup loop

Harini T <harini.t@amd.com>
    mailbox: zynqmp-ipi: Remove dev.parent check in zynqmp_ipi_free_mboxes

Harini T <harini.t@amd.com>
    mailbox: zynqmp-ipi: Remove redundant mbox_controller_unregister() call

Eric Dumazet <edumazet@google.com>
    tcp: take care of zero tp->window_clamp in tcp_set_rcvlowat()

Leo Yan <leo.yan@arm.com>
    perf python: split Clang options when invoking Popen

Leo Yan <leo.yan@arm.com>
    tools build: Align warning options with perf

Erick Karanja <karanja99erick@gmail.com>
    net: fsl_pq_mdio: Fix device node reference leak in fsl_pq_mdio_probe

Haotian Zhang <vulab@iscas.ac.cn>
    ice: ice_adapter: release xa entry on adapter allocation failure

Duoming Zhou <duoming@zju.edu.cn>
    net: mscc: ocelot: Fix use-after-free caused by cyclic delayed work

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Don't call reqsk_fastopen_remove() in tcp_conn_request().

Alexandr Sapozhnikov <alsp705@gmail.com>
    net/sctp: fix a null dereference in sctp_disposition sctp_sf_do_5_1D_ce()

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Fix copy-paste typo in validation

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Fix Use-after-free in validation

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: Fix a null-ptr access in the cursor snooper

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: Update purge function to unregister the unused subchannels

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/hw_engine_group: Fix double write lock release in error path

Dan Carpenter <dan.carpenter@linaro.org>
    net/mlx4: prevent potential use after free in mlx4_en_do_uc_filter()

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: Read the LLP via the associated Link DMA channel

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Init acpi_gbl_use_global_lock to false

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Add cflag -fno-isolate-erroneous-paths-dereference

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: hda-pcm: Place the constraint on period time instead of buffer time

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-topology: Account for different ChainDMA host buffer size

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-topology: Correct the minimum host DMA buffer size

Duoming Zhou <duoming@zju.edu.cn>
    scsi: mvsas: Fix use-after-free bugs in mvs_work_queue

Aaron Kling <webgeek1234@gmail.com>
    cpufreq: tegra186: Set target frequency for all cpus in policy

Fedor Pchelkin <pchelkin@ispras.ru>
    clk: tegra: do not overallocate memory for bpmp clocks

Alok Tiwari <alok.a.tiwari@oracle.com>
    clk: nxp: Fix pll0 rate check condition in LPC18xx CGU driver

Brian Masney <bmasney@redhat.com>
    clk: nxp: lpc18xx-cgu: convert from round_rate() to determine_rate()

Chen-Yu Tsai <wenst@chromium.org>
    clk: mediatek: clk-mux: Do not pass flags to clk_mux_determine_rate_flags()

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    clk: mediatek: mt8195-infra_ao: Fix parent for infra_ao_hdmi_26m

Ian Rogers <irogers@google.com>
    perf evsel: Ensure the fallback message is always written to

Namhyung Kim <namhyung@kernel.org>
    perf tools: Add fallback for exclude_guest

James Clark <james.clark@linaro.org>
    perf test: Add a test for default perf stat command

Ian Rogers <irogers@google.com>
    perf test: Don't leak workload gopipe in PERF_RECORD_*

Leo Yan <leo.yan@arm.com>
    perf session: Fix handling when buffer exceeds 2 GiB

Ian Rogers <irogers@google.com>
    perf test shell lbr: Avoid failures with perf event paranoia

Namhyung Kim <namhyung@kernel.org>
    perf test: Update sysfs path for core PMU caps

Ilkka Koskinen <ilkka@os.amperecomputing.com>
    perf vendor events arm64 AmpereOneX: Fix typo - should be l1d_cache_access_prefetches

Leo Yan <leo.yan@arm.com>
    perf arm_spe: Correct memory level for remote access

Leo Yan <leo.yan@arm.com>
    perf arm-spe: Rename the common data source encoding

Leo Yan <leo.yan@arm.com>
    perf arm_spe: Correct setting remote access

Clément Le Goffic <clement.legoffic@foss.st.com>
    rtc: optee: fix memory leak on driver removal

Rob Herring (Arm) <robh@kernel.org>
    rtc: x1205: Fix Xicor X1205 vendor prefix

Yunseong Kim <ysk@kzalloc.com>
    perf util: Fix compression checks returning -1 as bool

Yuan CHen <chenyuan@kylinos.cn>
    clk: renesas: cpg-mssr: Fix memory leak in cpg_mssr_reserved_init()

Brian Masney <bmasney@redhat.com>
    clk: at91: peripheral: fix return value

Dan Carpenter <dan.carpenter@linaro.org>
    clk: qcom: common: Fix NULL vs IS_ERR() check in qcom_cc_icc_register()

Ian Rogers <irogers@google.com>
    libperf event: Ensure tracing data is multiple of 8 sized

Ian Rogers <irogers@google.com>
    perf evsel: Avoid container_of on a NULL leader

Ian Rogers <irogers@google.com>
    perf test trace_btf_enum: Skip if permissions are insufficient

Ian Rogers <irogers@google.com>
    perf disasm: Avoid undefined behavior in incrementing NULL

Varad Gautam <varadgautam@google.com>
    asm-generic/io.h: Skip trace helpers if rwmmio events are disabled

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: v4l2-subdev: Fix alloc failure check in v4l2_subdev_call_state_try()

Michael Hennerich <michael.hennerich@analog.com>
    iio: frequency: adf4350: Fix ADF4350_REG3_12BIT_CLKDIV_MODE

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Emulate PERF_CNTR_GLOBAL_STATUS_SET for PerfMonV2

Petr Tesarik <ptesarik@suse.com>
    dma-mapping: fix direction in dma_alloc direction traces

Toke Høiland-Jørgensen <toke@redhat.com>
    page_pool: Fix PP_MAGIC_MASK to avoid crashing on some 32-bit arches

Zhen Ni <zhen.ni@easystack.cn>
    clocksource/drivers/clps711x: Fix resource leaks in error paths

Christian Brauner <brauner@kernel.org>
    listmount: don't call path_put() under namespace semaphore

Thomas Gleixner <tglx@linutronix.de>
    rseq: Protect event mask against membarrier IPI

Omar Sandoval <osandov@fb.com>
    arm64: map [_text, _stext) virtual address range non-executable+read-only

Aleksa Sarai <cyphar@cyphar.com>
    fscontext: do not consume log entries when returning -EMSGSIZE

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    fs: always return zero on success from replace_fd()


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   3 +
 .../bindings/phy/rockchip-inno-csi-dphy.yaml       |  15 +-
 Makefile                                           |   4 +-
 arch/arm/mach-omap2/am33xx-restart.c               |  36 ++
 arch/arm/mach-omap2/pm33xx-core.c                  |   6 +-
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |   2 +
 arch/arm64/boot/dts/qcom/msm8939.dtsi              |   2 +
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |   4 +-
 arch/arm64/boot/dts/qcom/x1e80100-pmics.dtsi       |   2 +
 arch/arm64/boot/dts/ti/k3-am62a-main.dtsi          |   2 +-
 arch/arm64/kernel/cpufeature.c                     |  10 +-
 arch/arm64/kernel/mte.c                            |   3 +-
 arch/arm64/kernel/pi/map_kernel.c                  |   6 +
 arch/arm64/kernel/probes/kprobes.c                 |  12 +
 arch/arm64/kernel/setup.c                          |   4 +-
 arch/arm64/mm/init.c                               |   2 +-
 arch/arm64/mm/mmu.c                                |  14 +-
 arch/loongarch/Makefile                            |   2 +-
 arch/loongarch/kernel/setup.c                      |   1 +
 arch/parisc/include/uapi/asm/ioctls.h              |   8 +-
 arch/parisc/lib/memcpy.c                           |   1 -
 arch/powerpc/platforms/powernv/pci-ioda.c          |   2 +-
 arch/powerpc/platforms/pseries/msi.c               |   2 +-
 arch/s390/Makefile                                 |   1 +
 arch/s390/kernel/vmlinux.lds.S                     |  54 +--
 arch/s390/net/bpf_jit.h                            |  55 ---
 arch/s390/net/bpf_jit_comp.c                       | 139 ++++---
 arch/sparc/kernel/of_device_32.c                   |   1 +
 arch/sparc/kernel/of_device_64.c                   |   1 +
 arch/sparc/mm/hugetlbpage.c                        |  20 +
 arch/x86/entry/entry_64_fred.S                     |   2 +-
 arch/x86/hyperv/ivm.c                              |   2 +-
 arch/x86/include/asm/msr-index.h                   |   1 +
 arch/x86/include/asm/mtrr.h                        |  10 +-
 arch/x86/kernel/cpu/mtrr/generic.c                 |   6 +-
 arch/x86/kernel/cpu/mtrr/mtrr.c                    |   2 +-
 arch/x86/kernel/kvm.c                              |  21 +-
 arch/x86/kernel/umip.c                             |  15 +-
 arch/x86/kvm/cpuid.c                               |   2 +-
 arch/x86/kvm/pmu.c                                 |   5 +
 arch/x86/kvm/svm/pmu.c                             |   1 +
 arch/x86/kvm/x86.c                                 |   2 +
 arch/x86/xen/enlighten_pv.c                        |   4 +-
 arch/xtensa/platforms/iss/simdisk.c                |   6 +-
 block/blk-crypto-fallback.c                        |   3 +
 crypto/essiv.c                                     |  14 +-
 drivers/acpi/acpi_dbg.c                            |  26 +-
 drivers/acpi/acpi_tad.c                            |   3 +
 drivers/acpi/acpica/evglock.c                      |   4 +
 drivers/acpi/battery.c                             |  60 +--
 drivers/acpi/property.c                            | 139 ++++---
 drivers/block/loop.c                               |   8 +-
 drivers/bus/mhi/ep/main.c                          |  37 +-
 drivers/bus/mhi/host/init.c                        |   5 +-
 drivers/char/ipmi/ipmi_kcs_sm.c                    |  16 +-
 drivers/char/ipmi/ipmi_msghandler.c                | 422 ++++++++++-----------
 drivers/char/tpm/tpm_tis_core.c                    |   4 +-
 drivers/clk/at91/clk-peripheral.c                  |   7 +-
 drivers/clk/mediatek/clk-mt8195-infra_ao.c         |   2 +-
 drivers/clk/mediatek/clk-mux.c                     |   4 +-
 drivers/clk/nxp/clk-lpc18xx-cgu.c                  |  20 +-
 drivers/clk/qcom/common.c                          |   4 +-
 drivers/clk/qcom/tcsrcc-x1e80100.c                 |   4 +
 drivers/clk/renesas/renesas-cpg-mssr.c             |   7 +-
 drivers/clk/tegra/clk-bpmp.c                       |   2 +-
 drivers/clocksource/clps711x-timer.c               |  23 +-
 drivers/cpufreq/cpufreq-dt.c                       |   2 +-
 drivers/cpufreq/imx6q-cpufreq.c                    |   2 +-
 drivers/cpufreq/intel_pstate.c                     |   8 +-
 drivers/cpufreq/mediatek-cpufreq-hw.c              |   2 +-
 drivers/cpufreq/scmi-cpufreq.c                     |   2 +-
 drivers/cpufreq/scpi-cpufreq.c                     |   2 +-
 drivers/cpufreq/spear-cpufreq.c                    |   2 +-
 drivers/cpufreq/tegra186-cpufreq.c                 |   8 +-
 drivers/crypto/aspeed/aspeed-hace-crypto.c         |   2 +-
 drivers/crypto/atmel-tdes.c                        |   2 +-
 drivers/crypto/rockchip/rk3288_crypto_ahash.c      |   2 +-
 drivers/firmware/meson/meson_sm.c                  |   7 +-
 drivers/gpio/gpio-wcd934x.c                        |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   4 +
 drivers/gpu/drm/amd/display/dc/dce/dce_transform.c |  21 +-
 drivers/gpu/drm/amd/display/dc/dce/dce_transform.h |   4 +
 .../gpu/drm/amd/include/asic_reg/dce/dce_6_0_d.h   |   7 +
 .../drm/amd/include/asic_reg/dce/dce_6_0_sh_mask.h |   2 +
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   2 +-
 drivers/gpu/drm/panthor/panthor_drv.c              |  11 +-
 drivers/gpu/drm/renesas/rcar-du/rcar_mipi_dsi.c    |   5 +-
 .../gpu/drm/renesas/rcar-du/rcar_mipi_dsi_regs.h   |   8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |  17 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_validation.c         |   6 +-
 drivers/gpu/drm/xe/xe_hw_engine_group.c            |   6 +-
 drivers/gpu/drm/xe/xe_query.c                      |  15 +-
 drivers/iio/adc/pac1934.c                          |  20 +-
 drivers/iio/adc/xilinx-ams.c                       |  47 ++-
 drivers/iio/dac/ad5360.c                           |   2 +-
 drivers/iio/dac/ad5421.c                           |   2 +-
 drivers/iio/frequency/adf4350.c                    |  20 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c   |   4 -
 drivers/iommu/intel/iommu.c                        |   2 +-
 drivers/irqchip/irq-sifive-plic.c                  |  13 +-
 drivers/mailbox/mtk-cmdq-mailbox.c                 |  12 +-
 drivers/mailbox/zynqmp-ipi-mailbox.c               |  24 +-
 .../media/cec/usb/extron-da-hd-4k-plus/Makefile    |   6 -
 drivers/media/i2c/mt9v111.c                        |   2 +-
 drivers/media/mc/mc-devnode.c                      |   6 +-
 drivers/media/mc/mc-entity.c                       |   2 +-
 drivers/media/pci/cx18/cx18-queue.c                |  13 +-
 drivers/media/pci/ivtv/ivtv-irq.c                  |   2 +-
 drivers/media/pci/ivtv/ivtv-yuv.c                  |   8 +-
 drivers/media/pci/mgb4/mgb4_trigger.c              |   2 +-
 drivers/media/platform/qcom/venus/firmware.c       |   8 +-
 .../platform/samsung/s5p-mfc/s5p_mfc_cmd_v6.c      |  35 +-
 .../media/platform/ti/j721e-csi2rx/j721e-csi2rx.c  |   9 +-
 drivers/media/rc/lirc_dev.c                        |   9 +-
 drivers/media/test-drivers/vivid/vivid-cec.c       |  12 +-
 drivers/memory/samsung/exynos-srom.c               |  10 +-
 drivers/mfd/intel_soc_pmic_chtdc_ti.c              |   5 +-
 drivers/mmc/core/sdio.c                            |   6 +-
 drivers/mmc/host/mmc_spi.c                         |   2 +-
 drivers/mtd/nand/raw/fsmc_nand.c                   |   6 +-
 drivers/net/ethernet/freescale/fsl_pq_mdio.c       |   2 +
 drivers/net/ethernet/intel/ice/ice_adapter.c       |  10 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   2 +-
 drivers/net/ethernet/mscc/ocelot_stats.c           |   2 +-
 drivers/net/wireless/ath/ath11k/core.c             |   6 +-
 drivers/net/wireless/ath/ath11k/hal.c              |  16 +
 drivers/net/wireless/ath/ath11k/hal.h              |   1 +
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c    |   3 +
 drivers/net/wireless/mediatek/mt76/mt7925/usb.c    |   3 +
 drivers/nvme/host/pci.c                            |   2 +
 drivers/of/unittest.c                              |   1 +
 drivers/pci/controller/cadence/pci-j721e.c         |  25 ++
 drivers/pci/controller/dwc/pci-keystone.c          |   4 +-
 drivers/pci/controller/dwc/pcie-rcar-gen4.c        |   2 +-
 drivers/pci/controller/dwc/pcie-tegra194.c         |  32 +-
 drivers/pci/controller/pci-tegra.c                 |  27 +-
 drivers/pci/controller/pcie-rcar-host.c            |  40 +-
 drivers/pci/controller/pcie-xilinx-nwl.c           |   7 +-
 drivers/pci/endpoint/functions/pci-epf-test.c      |  19 +-
 drivers/pci/iov.c                                  |   5 +
 drivers/pci/pci-driver.c                           |   1 +
 drivers/pci/pci-sysfs.c                            |  20 +-
 drivers/pci/pcie/aer.c                             |  12 +-
 drivers/pci/pcie/err.c                             |   8 +-
 drivers/perf/arm-cmn.c                             |   9 +-
 drivers/pinctrl/samsung/pinctrl-samsung.h          |   4 -
 drivers/power/supply/max77976_charger.c            |  12 +-
 drivers/pwm/pwm-berlin.c                           |   4 +-
 drivers/rtc/interface.c                            |  27 ++
 drivers/rtc/rtc-optee.c                            |   1 +
 drivers/rtc/rtc-x1205.c                            |   2 +-
 drivers/s390/block/dasd.c                          |  17 +-
 drivers/s390/cio/device.c                          |  37 +-
 drivers/scsi/hpsa.c                                |  21 +-
 drivers/scsi/mvsas/mv_init.c                       |   2 +-
 drivers/scsi/sd.c                                  |  50 +--
 drivers/spi/spi-cadence-quadspi.c                  |  18 +-
 drivers/video/fbdev/core/fb_cmdline.c              |   2 +-
 drivers/xen/events/events_base.c                   |  37 +-
 drivers/xen/manage.c                               |   3 +-
 fs/btrfs/export.c                                  |   8 +-
 fs/btrfs/extent_io.c                               |  14 +-
 fs/cramfs/inode.c                                  |  11 +-
 fs/eventpoll.c                                     | 139 ++-----
 fs/ext4/ext4.h                                     |   2 +
 fs/ext4/fsmap.c                                    |  14 +-
 fs/ext4/indirect.c                                 |   2 +-
 fs/ext4/inode.c                                    |  10 +-
 fs/ext4/move_extent.c                              |   2 +-
 fs/ext4/orphan.c                                   |  17 +-
 fs/ext4/super.c                                    |  26 +-
 fs/ext4/xattr.c                                    |  19 +-
 fs/file.c                                          |   5 +-
 fs/fs-writeback.c                                  |  32 +-
 fs/fsopen.c                                        |  70 ++--
 fs/fuse/dev.c                                      |   2 +-
 fs/fuse/file.c                                     |   8 +-
 fs/minix/inode.c                                   |   8 +-
 fs/namei.c                                         |   8 +
 fs/namespace.c                                     | 106 ++++--
 fs/nfs/callback.c                                  |   4 -
 fs/nfs/callback_xdr.c                              |   1 +
 fs/nfsd/export.c                                   |  24 +-
 fs/nfsd/export.h                                   |   3 +-
 fs/nfsd/lockd.c                                    |  28 +-
 fs/nfsd/netns.h                                    |   4 +-
 fs/nfsd/nfs4proc.c                                 |   4 +-
 fs/nfsd/nfs4state.c                                |   6 +-
 fs/nfsd/nfs4xdr.c                                  |   2 +-
 fs/nfsd/nfsfh.c                                    |  22 +-
 fs/nfsd/trace.h                                    |   2 +-
 fs/nfsd/vfs.c                                      |  14 +-
 fs/nfsd/vfs.h                                      |   2 +-
 fs/ntfs3/bitmap.c                                  |   1 +
 fs/quota/dquot.c                                   |  10 +-
 fs/read_write.c                                    |  14 +-
 fs/smb/client/smb1ops.c                            |  62 ++-
 fs/smb/client/smb2inode.c                          |  22 +-
 fs/smb/client/smb2ops.c                            |  10 +-
 fs/squashfs/inode.c                                |  24 +-
 include/acpi/acpixf.h                              |   6 +
 include/asm-generic/io.h                           |  98 +++--
 include/linux/cpufreq.h                            |   3 +
 include/linux/iio/frequency/adf4350.h              |   2 +-
 include/linux/ksm.h                                |   8 +-
 include/linux/mm.h                                 |  22 +-
 include/linux/rseq.h                               |  11 +-
 include/linux/sunrpc/svc.h                         |   2 +-
 include/linux/sunrpc/svc_xprt.h                    |  19 +
 include/media/v4l2-subdev.h                        |  30 +-
 include/trace/events/dma.h                         |   1 +
 init/main.c                                        |  12 +
 kernel/bpf/inode.c                                 |   4 +-
 kernel/fork.c                                      |   2 +-
 kernel/pid.c                                       |   5 +-
 kernel/rseq.c                                      |  10 +-
 kernel/sched/deadline.c                            |  73 ++--
 kernel/sched/fair.c                                |   9 +-
 kernel/sys.c                                       |  22 +-
 kernel/trace/trace_fprobe.c                        |  11 +-
 kernel/trace/trace_kprobe.c                        |  11 +-
 kernel/trace/trace_probe.h                         |   9 +-
 kernel/trace/trace_uprobe.c                        |  12 +-
 lib/crypto/Makefile                                |   4 +
 lib/genalloc.c                                     |   5 +-
 mm/damon/lru_sort.c                                |   2 +-
 mm/damon/vaddr.c                                   |   8 +-
 mm/huge_memory.c                                   |  15 +-
 mm/hugetlb.c                                       |   3 +
 mm/migrate.c                                       |  23 +-
 mm/page_alloc.c                                    |   2 +-
 mm/slab.h                                          |   8 +-
 mm/slub.c                                          |   3 +-
 net/bridge/br_vlan.c                               |   2 +-
 net/core/filter.c                                  |   2 +
 net/core/page_pool.c                               |  76 ++--
 net/ipv4/tcp.c                                     |   5 +-
 net/ipv4/tcp_input.c                               |   1 -
 net/mptcp/pm.c                                     |   7 +-
 net/mptcp/pm_netlink.c                             |  50 ++-
 net/mptcp/protocol.h                               |   8 +
 net/netfilter/nft_objref.c                         |  39 ++
 net/sctp/sm_make_chunk.c                           |   3 +-
 net/sctp/sm_statefuns.c                            |   6 +-
 net/sunrpc/svc_xprt.c                              |  45 ++-
 net/sunrpc/svcsock.c                               |   2 +
 net/xdp/xsk_queue.h                                |  45 ++-
 security/keys/trusted-keys/trusted_tpm1.c          |   7 +-
 sound/soc/sof/intel/hda-pcm.c                      |  29 +-
 sound/soc/sof/intel/hda-stream.c                   |  29 +-
 sound/soc/sof/ipc4-pcm.c                           | 138 +++++--
 sound/soc/sof/ipc4-topology.c                      |  16 +-
 sound/soc/sof/ipc4-topology.h                      |  10 +-
 tools/build/feature/Makefile                       |   4 +-
 tools/lib/perf/include/perf/event.h                |   1 +
 tools/perf/builtin-stat.c                          |  18 +-
 .../arch/arm64/ampere/ampereonex/metrics.json      |  10 +-
 tools/perf/tests/perf-record.c                     |   4 +
 tools/perf/tests/shell/record_lbr.sh               |  29 +-
 tools/perf/tests/shell/stat.sh                     |  29 ++
 tools/perf/tests/shell/trace_btf_enum.sh           |  11 +
 tools/perf/util/arm-spe-decoder/arm-spe-decoder.h  |  18 +-
 tools/perf/util/arm-spe.c                          |  34 +-
 tools/perf/util/disasm.c                           |   7 +-
 tools/perf/util/evsel.c                            |  31 +-
 tools/perf/util/lzma.c                             |   2 +-
 tools/perf/util/session.c                          |   2 +-
 tools/perf/util/setup.py                           |   5 +-
 tools/perf/util/zlib.c                             |   2 +-
 tools/testing/selftests/mm/madv_populate.c         |  21 +-
 tools/testing/selftests/mm/soft-dirty.c            |   5 +-
 tools/testing/selftests/mm/vm_util.c               |  77 ++++
 tools/testing/selftests/mm/vm_util.h               |   1 +
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  11 +
 .../selftests/net/netfilter/nf_nat_edemux.sh       |  58 ++-
 tools/testing/selftests/rseq/rseq.c                |   8 +-
 276 files changed, 2812 insertions(+), 1556 deletions(-)


