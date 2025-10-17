Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B403337109;
	Fri, 17 Oct 2025 15:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714894; cv=none; b=Zvpb+mj3/bLW1qA7sry+UojwfVql6VA0sLpR5rh6t3DEJyOX9xdxMN+tLZY1m7/3zhmL2AkPczZivPMXuTtngw4bXG8LeR670nIVfAWe27MCnoaLxOZYzeobg8MP0LS3Qo3F8jyVLp3szYQR21TBrL8mBwtjtyhwfQppK5thmGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714894; c=relaxed/simple;
	bh=VPSnF5m0aI+9S8S5clsOnauu90guyCQQ72q5Eb6NzYI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Bl3lmM4jFLN8w/kqf8cw47BF3TJak2YMtLP651v6tEbOuqadLqJ2QLbYprxn/iJv9nMU6BmD5itixRXA7Yq7EPwiK0Y3jPji6A816M+GbduuBwmnEAeeU3xLdrwe43TNhULw+NISfVtk+/qCqhw/boQyDYZic+4BrxDk2SyRbHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kECguDe8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kECguDe8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC2FC4CEE7;
	Fri, 17 Oct 2025 15:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714894;
	bh=VPSnF5m0aI+9S8S5clsOnauu90guyCQQ72q5Eb6NzYI=;
	h=From:To:Cc:Subject:Date:From;
	b=kECguDe8GPqOWGGp3qtzsEF55cMCBIn4kqpHGqg6JwGcslzlIgTohGbYNsXm0GXvV
	 JkbsS6LPKcaFi3hwEea4vBu/o7oIHX8Qn5Tv+tUdTNaN0ZvigvoUJ4XNMUMKfrsslr
	 bsePOSNedCHME8x+HSr+Cqhs3fl5OKhVhAt0mJ98=
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
Subject: [PATCH 6.17 000/371] 6.17.4-rc1 review
Date: Fri, 17 Oct 2025 16:49:35 +0200
Message-ID: <20251017145201.780251198@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.4-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.17.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.17.4-rc1
X-KernelTest-Deadline: 2025-10-19T14:52+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.17.4 release.
There are 371 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.4-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.17.4-rc1

Christian Brauner <brauner@kernel.org>
    mount: handle NULL values in mnt_ns_release()

Christian Brauner <brauner@kernel.org>
    pidfs: validate extensible ioctls

Darrick J. Wong <djwong@kernel.org>
    iomap: error out on file IO when there is no inline_data buffer

Jan Kara <jack@suse.cz>
    writeback: Avoid excessively long inode switching times

Jan Kara <jack@suse.cz>
    writeback: Avoid softlockup when switching many inodes

Al Viro <viro@zeniv.linux.org.uk>
    mnt_ns_tree_remove(): DTRT if mnt_ns had never been added to mnt_ns_list

Christian Brauner <brauner@kernel.org>
    nsfs: validate extensible ioctls

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

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: property: Do not pass NULL handles to acpi_attach_data()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: property: Add code comments explaining what is going on

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: property: Disregard references in data-only subnode lists

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    arm64: dts: qcom: qcs615: add missing dt property in QUP SEs

Edward Adam Davis <eadavis@qq.com>
    media: mc: Clear minor number before put device

Donet Tom <donettom@linux.ibm.com>
    mm/ksm: fix incorrect KSM counter handling in mm_struct during fork

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: reject negative file sizes in squashfs_read_inode()

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: add additional inode sanity checking

Guenter Roeck <linux@roeck-us.net>
    ipmi: Fix handling of messages with provided receive message pointer

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

Jan Kara <jack@suse.cz>
    ext4: fail unaligned direct IO write with EINVAL

Baokun Li <libaokun1@huawei.com>
    ext4: add ext4_sb_bread_nofail() helper function for ext4_free_branches()

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Allow stop on firmware only if start was issued.

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Fix format check for CAPTURE plane in try_fmt

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Fix missing LAST flag handling during drain

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Send dummy buffer address for all codecs during drain

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Update vbuf flags before v4l2_m2m_buf_done

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Simplify session stop logic by relying on vb2 checks

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Always destroy internal buffers on firmware release response

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Allow substate transition to load resources during output streaming

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Fix buffer count reporting in internal buffer check

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Fix port streaming handling

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: vpu3x: Add MNoC low power handshake during hardware power-off

Neil Armstrong <neil.armstrong@linaro.org>
    media: iris: fix module removal if firmware download failed

Stephan Gerhold <stephan.gerhold@linaro.org>
    media: iris: Fix firmware reference leak and unmap memory after load

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    media: iris: Call correct power off callback in cleanup path

Olga Kornievskaia <okorniev@redhat.com>
    nfsd: nfserr_jukebox in nlm_fopen should lead to a retry

Thorsten Blum <thorsten.blum@linux.dev>
    NFSD: Fix destination buffer size in nfsd4_ssc_setup_dul()

Scott Mayhew <smayhew@redhat.com>
    nfsd: decouple the xprtsec policy check from check_nfsd_access()

SeongJae Park <sj@kernel.org>
    mm/damon/lru_sort: use param_ctx for damon_attrs staging

SeongJae Park <sj@kernel.org>
    mm/damon/vaddr: do not repeat pte_offset_map_lock() until success

Li RongQing <lirongqing@baidu.com>
    mm/hugetlb: early exit from hugetlb_pages_alloc_boot() when max_huge_pages=0

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    mm/page_alloc: only set ALLOC_HIGHATOMIC for __GPF_HIGH allocations

Lance Yang <lance.yang@linux.dev>
    mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-filled mTHP subpage to shared zeropage

Lance Yang <lance.yang@linux.dev>
    mm/thp: fix MTE tag mismatch when replacing zero-filled subpages

Nick Morrow <morrownr@gmail.com>
    wifi: mt76: mt7921u: Add VID/PID for Netgear A7500

Nick Morrow <morrownr@gmail.com>
    wifi: mt76: mt7925u: Add VID/PID for Netgear A9000

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: rtw89: avoid possible TX wait initialization race

Miaoqian Lin <linmq006@gmail.com>
    wifi: iwlwifi: Fix dentry reference leak in iwl_mld_add_link_debugfs

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

Heiko Carstens <hca@linux.ibm.com>
    s390/cio/ioasm: Fix __xsch() condition code handling

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: validate C-flag + def limit

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: reset blackhole on success with non-loopback ifaces

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: in-kernel: usable client side with C-flag

Sean Christopherson <seanjc@google.com>
    x86/umip: Fix decoding of register forms of 0F 01 (SGDT and SIDT aliases)

Sean Christopherson <seanjc@google.com>
    x86/umip: Check that the instruction opcode is at least two bytes

Xin Li (Intel) <xin@zytor.com>
    x86/fred: Remove ENDBR64 from FRED entry points

Darrick J. Wong <djwong@kernel.org>
    xfs: use deferred intent items for reaping crosslinked blocks

Santhosh Kumar K <s-k6@ti.com>
    spi: cadence-quadspi: Fix cqspi_setup_flash()

Pratyush Yadav <pratyush@kernel.org>
    spi: cadence-quadspi: Flush posted register writes before DAC access

Pratyush Yadav <pratyush@kernel.org>
    spi: cadence-quadspi: Flush posted register writes before INDAC access

Johan Hovold <johan+linaro@kernel.org>
    PCI/pwrctrl: Fix device leak at device stop

Johan Hovold <johan+linaro@kernel.org>
    PCI/pwrctrl: Fix device and OF node leak at bus scan

Johan Hovold <johan+linaro@kernel.org>
    PCI/pwrctrl: Fix device leak at registration

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

Siddharth Vadapalli <s-vadapalli@ti.com>
    PCI: j721e: Fix module autoloading

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Fix failure detection during resource resize

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Ensure relaxed tail alignment does not increase min_align

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

Patrice Chotard <patrice.chotard@foss.st.com>
    memory: stm32_omm: Fix req2ack update test

Zhen Ni <zhen.ni@easystack.cn>
    memory: samsung: exynos-srom: Fix of_iomap leak in exynos_srom_probe

Rex Chen <rex.chen_1@nxp.com>
    mmc: mmc_spi: multiple block read remove read crc ack

Rex Chen <rex.chen_1@nxp.com>
    mmc: core: SPI mode remove cmd7

Maarten Zanders <maarten@zanders.be>
    mtd: nand: raw: gpmi: fix clocks when CONFIG_PM=N

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

Bharath SM <bharathsm@microsoft.com>
    smb client: fix bug with newly created file in cached dir

Eric Biggers <ebiggers@kernel.org>
    sctp: Fix MAC comparison to be constant-time

Abinash Singh <abinashsinghlalotra@gmail.com>
    scsi: sd: Fix build warning in sd_revalidate_disk()

Thorsten Blum <thorsten.blum@linux.dev>
    scsi: hpsa: Fix potential memory leak in hpsa_big_passthru_ioctl()

Harshit Agarwal <harshit@nutanix.com>
    sched/deadline: Fix race in push_dl_task()

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: use an atomic xchg in pudp_huge_get_and_clear()

Corey Minyard <corey@minyard.net>
    Revert "ipmi: fix msg stack when IPMI is disconnected"

Colin Ian King <colin.i.king@gmail.com>
    pwm: Fix incorrect variable used in error message

Jisheng Zhang <jszhang@kernel.org>
    pwm: berlin: Fix wrong register in suspend/resume

Nam Cao <namcao@linutronix.de>
    powerpc/pseries/msi: Fix potential underflow and leak issue

Nam Cao <namcao@linutronix.de>
    powerpc/powernv/pci: Fix underflow and leak issue

Dzmitry Sankouski <dsankouski@gmail.com>
    power: supply: max77976_charger: fix constant current reporting

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: hibernate: Restrict GFP mask in power_down()

Mario Limonciello (AMD) <superm1@kernel.org>
    PM: hibernate: Fix hybrid-sleep

Christian Loehle <christian.loehle@arm.com>
    PM: EM: Fix late boot with holes in CPU topology

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    pinctrl: samsung: Drop unused S3C24xx driver data

Georg Gottleuber <ggo@tuxedocomputers.com>
    nvme-pci: Add TUXEDO IBS Gen8 to Samsung sleep quirk

John David Anglin <dave.anglin@bell.net>
    parisc: Remove spurious if statement from raw_copy_from_user()

Sam James <sam@gentoo.org>
    parisc: don't reference obsolete termio struct for TC* constants

Xiao Liang <shaw.leon@gmail.com>
    padata: Reset next CPU when reorder sequence wraps around

Askar Safin <safinaskar@zohomail.com>
    openat2: don't trigger automounts with RESOLVE_NO_XDEV

Ma Ke <make24@iscas.ac.cn>
    of: unittest: Fix device reference count leak in of_unittest_pci_node_verify

Yu Kuai <yukuai3@huawei.com>
    md: fix mssing blktrace bio split events

Li Chen <me@linux.beauty>
    loop: fix backing file reference leak on validation error

Johan Hovold <johan@kernel.org>
    lib/genalloc: fix device leak in of_gen_pool_get()

Pratyush Yadav <pratyush@kernel.org>
    kho: only fill kimage if KHO is finalized

Eric Biggers <ebiggers@kernel.org>
    KEYS: trusted_tpm1: Compare HMAC values in constant time

Oleg Nesterov <oleg@redhat.com>
    kernel/sys.c: fix the racy usage of task_lock(tsk->group_leader) in sys_prlimit64() paths

Corey Minyard <corey@minyard.net>
    ipmi:msghandler:Change seq_lock to a mutex

Corey Minyard <corey@minyard.net>
    ipmi: Rework user message limit handling

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: PRS isn't usable if PDS isn't supported

Sean Nyekjaer <sean@geanix.com>
    iio: imu: inv_icm42600: Avoid configuring if already pm_runtime suspended

Sean Nyekjaer <sean@geanix.com>
    iio: imu: inv_icm42600: Drop redundant pm_runtime reinitialization in resume

Sean Nyekjaer <sean@geanix.com>
    iio: imu: inv_icm42600: Simplify pm_runtime setup

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

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i3c: Fix default I2C adapter timeout value

Conor Dooley <conor.dooley@microchip.com>
    gpio: mpfs: fix setting gpio direction to output

Darrick J. Wong <djwong@kernel.org>
    fuse: fix livelock in synchronous file put from fuseblk workers

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix possibly missing fuse_copy_finish() call in fuse_notify()

Ryan Roberts <ryan.roberts@arm.com>
    fsnotify: pass correct offset to fsnotify_mmap_perm()

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

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: CPPC: Avoid using CPUFREQ_ETERNAL as transition delay

Simon Schuster <schuster.simon@siemens-energy.com>
    copy_sighand: Handle architectures where sizeof(unsigned long) < sizeof(u64)

Denzeel Oliva <wachiturroxd150@gmail.com>
    clk: samsung: exynos990: Replace bogus divs with fixed-factor clocks

Denzeel Oliva <wachiturroxd150@gmail.com>
    clk: samsung: exynos990: Fix CMU_TOP mux/div bit widths

Denzeel Oliva <wachiturroxd150@gmail.com>
    clk: samsung: exynos990: Use PLL_CON0 for PLL parent muxes

Abel Vesa <abel.vesa@linaro.org>
    clk: qcom: tcsrcc-x1e80100: Set the bi_tcxo as parent to eDP refclk

Miaoqian Lin <linmq006@gmail.com>
    cdx: Fix device node reference leak in cdx_msi_domain_init

Adam Xue <zxue@semtech.com>
    bus: mhi: host: Do not use uninitialized 'dev' pointer in mhi_init_irq_setup()

Sumit Kumar <sumit.kumar@oss.qualcomm.com>
    bus: mhi: ep: Fix chained transfer handling in read path

Anderson Nascimento <anderson@allelesecurity.com>
    btrfs: avoid potential out-of-bounds in btrfs_encode_fh()

Yu Kuai <yukuai3@huawei.com>
    blk-crypto: fix missing blktrace bio split events

Ard Biesheuvel <ardb@kernel.org>
    drm/amd/display: Fix unsafe uses of kernel mode FPU

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Enable Dynamic DTBCLK Switch

Jesse Agate <jesse.agate@amd.com>
    drm/amd/display: Incorrect Mirror Cositing

Matthew Auld <matthew.auld@intel.com>
    drm/xe/uapi: loosen used tracking restriction

Shuhao Fu <sfual@cse.ust.hk>
    drm/nouveau: fix bad ret code in nouveau_bo_move_prep

Marek Vasut <marek.vasut+renesas@mailbox.org>
    drm/rcar-du: dsi: Fix 1/2/3 lane support

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Fix PDC sleep sequence

Jann Horn <jannh@google.com>
    drm/panthor: Fix memory leak in panthor_ioctl_group_create()

Kaustabh Chakraborty <kauschluss@disroot.org>
    drm/exynos: exynos7_drm_decon: remove ctx->suspended

Ma Ke <make24@iscas.ac.cn>
    media: lirc: Fix error handling in lirc_register()

Jai Luthra <jai.luthra@ideasonboard.com>
    media: ti: j721e-csi2rx: Fix source subdev link creation

Jai Luthra <jai.luthra@ideasonboard.com>
    media: ti: j721e-csi2rx: Use devm_of_platform_populate

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: vsp1: Export missing vsp1_isp_free_buffer symbol

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: vivid: fix disappearing <Vendor Command With ID> messages

Renjiang Han <quic_renjiang@quicinc.com>
    media: venus: pm_helpers: add fallback for the opp-table

Stephan Gerhold <stephan.gerhold@linaro.org>
    media: venus: firmware: Use correct reset sequence for IRIS2

Desnes Nunes <desnesn@redhat.com>
    media: uvcvideo: Avoid variable shadowing in uvc_ctrl_cleanup_fh

Bingbu Cao <bingbu.cao@intel.com>
    media: staging/ipu7: fix isys device runtime PM usage in firmware closing

Arnd Bergmann <arnd@arndb.de>
    media: s5p-mfc: remove an unused/uninitialized variable

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    media: platform: mtk-mdp3: Add missing MT8188 compatible to comp_dt_ids

David Lechner <dlechner@baylibre.com>
    media: pci: mg4b: fix uninitialized iio scan data

Thomas Fourier <fourier.thomas@gmail.com>
    media: pci: ivtv: Add missing check after DMA map

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: mc: Fix MUST_CONNECT handling for pads with no links

Qianfeng Rong <rongqianfeng@vivo.com>
    media: i2c: mt9v111: fix incorrect type for ret

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: i2c: mt9p031: fix mbus code initialization

Thomas Fourier <fourier.thomas@gmail.com>
    media: cx18: Add missing check after DMA map

Randy Dunlap <rdunlap@infradead.org>
    media: cec: extron-da-hd-4k-plus: drop external-module make commands

Johan Hovold <johan@kernel.org>
    firmware: meson_sm: fix device leak at probe

Tudor Ambarus <tudor.ambarus@linaro.org>
    firmware: exynos-acpm: fix PMIC returned errno

Jason Andryuk <jason.andryuk@amd.com>
    xen/events: Update virq_to_irq on migration

Jason Andryuk <jason.andryuk@amd.com>
    xen/events: Return -EEXIST for bound VIRQs

Lukas Wunner <lukas@wunner.de>
    xen/manage: Fix suspend error path

Jason Andryuk <jason.andryuk@amd.com>
    xen/events: Cleanup find_virq() return codes

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    xen: take system_transition_mutex on suspend

Michael Riesch <michael.riesch@collabora.com>
    dt-bindings: phy: rockchip-inno-csi-dphy: make power-domains non-required

Tony Lindgren <tony.lindgren@linux.intel.com>
    KVM: TDX: Fix uninitialized error code for __tdx_bringup()

Hou Wenlong <houwenlong.hwl@antgroup.com>
    KVM: SVM: Re-load current, not host, TSC_AUX on #VMEXIT from SEV-ES guest

Sean Christopherson <seanjc@google.com>
    x86/kvm: Force legacy PCI hole to UC when overriding MTRRs for TDX/SNP

Fuad Tabba <tabba@google.com>
    KVM: arm64: Fix page leak in user_mem_abort()

Ben Horgan <ben.horgan@arm.com>
    KVM: arm64: Fix debug checking for np-guests using huge mappings

Gautam Gala <ggala@linux.ibm.com>
    KVM: s390: Fix to clear PTE when discarding a swapped page

Robin Murphy <robin.murphy@arm.com>
    perf/arm-cmn: Fix CMN S3 DTM offset

Johan Hovold <johan@kernel.org>
    firmware: arm_scmi: quirk: Prevent writes to string constants

Miaoqian Lin <linmq006@gmail.com>
    ARM: OMAP2+: pm33xx-core: ix device node reference leaks in amx3_idle_init

Alexander Sverdlin <alexander.sverdlin@gmail.com>
    ARM: AM33xx: Implement TI advisory 1.0.36 (EMU0/EMU1 pins state on reset)

Catalin Marinas <catalin.marinas@arm.com>
    arm64: mte: Do not flag the zero page as PG_mte_tagged

Yang Shi <yang@os.amperecomputing.com>
    arm64: kprobes: call set_memory_rox() for kprobe page

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62p: Fix supported hardware for 1GHz OPP

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

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: battery: Add synchronization between interface updates

Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
    ACPI: debug: fix signedness issues in read/write helpers

Ahmed Salem <x0rw3ll@gmail.com>
    ACPICA: Debugger: drop ACPI_NONSTRING attribute from name_seg

Daniel Tang <danielzgtg.opensource@gmail.com>
    ACPI: TAD: Add missing sysfs_remove_group() for ACPI_TAD_RT

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: property: Fix buffer properties extraction for subnodes

Ahmed Salem <x0rw3ll@gmail.com>
    ACPICA: acpidump: drop ACPI_NONSTRING attribute from file_name

Nathan Chancellor <nathan@kernel.org>
    s390/vmlinux.lds.S: Move .vmlinux.info to end of allocatable sections

Alexey Gladkov <legion@kernel.org>
    s390: vmlinux.lds.S: Reorder sections

Nathan Chancellor <nathan@kernel.org>
    kbuild: Add '.rel.*' strip pattern for vmlinux

Nathan Chancellor <nathan@kernel.org>
    kbuild: Restore pattern to avoid stripping .rela.dyn from vmlinux

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: keep .modinfo section in vmlinux.unstripped

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: always create intermediate vmlinux.unstripped

KaFai Wan <kafai.wan@linux.dev>
    bpf: Avoid RCU context warning when unpinning htab with internal structs

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: wcd934x: mark the GPIO controller as sleeping

Gunnar Kudrjavets <gunnarku@amazon.com>
    tpm_tis: Fix incorrect arguments in tpm_tis_probe_irq_single

Pali Rohár <pali@kernel.org>
    cifs: Query EA $LXMOD in cifs_query_path_info() for WSL reparse points

Esben Haabendal <esben@geanix.com>
    rtc: isl12022: Fix initial enable_irq/disable_irq balance

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix missing timestamp updates after utime(2)

Fushuai Wang <wangfushuai@baidu.com>
    cifs: Fix copy_to_iter return value check

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Fix loopback mode configuration for GDM2 port

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: essiv - Check ssize for decryption and in-place encryption

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/zcrx: increment fallback loop src offset

Florian Westphal <fw@strlen.de>
    selftests: netfilter: query conntrack state to check for port clash resolution

Florian Westphal <fw@strlen.de>
    selftests: netfilter: nft_fib.sh: fix spurious test failures

Eric Woudstra <ericwouds@gmail.com>
    bridge: br_vlan_fill_forward_path_pvid: use br_vlan_group_rcu()

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nft_objref: validate objref and objrefmap expressions

T Pratham <t-pratham@ti.com>
    crypto: skcipher - Fix reqsize handling

Thomas Wismer <thomas.wismer@scs.ch>
    net: pse-pd: tps23881: Fix current measurement scaling

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Fix kfd process ref leaking when userptr unmapping

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Disable scaling on DCE6 for now

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

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Prevent tunnel reformat when tunnel mode not allowed

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5: Prevent tunnel mode conflicts between FDB and NIC IPsec tables

Daniel Machon <daniel.machon@microchip.com>
    net: sparx5/lan969x: fix flooding configuration on bridge join/leave

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: mdio: mdio-i2c: Hold the i2c bus lock during smbus transactions

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

Vincent Minet <v.minet@criteo.com>
    perf tools: Fix arm64 libjvmti build by generating unistd_64.h

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

Sidharth Seela <sidharthseela@gmail.com>
    selftest: net: ovpn: Fix uninit return values

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

Raag Jadav <raag.jadav@intel.com>
    drm/xe/i2c: Don't rely on d3cold.allowed flag in system PM path

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/hw_engine_group: Fix double write lock release in error path

Dan Carpenter <dan.carpenter@linaro.org>
    net/mlx4: prevent potential use after free in mlx4_en_do_uc_filter()

Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
    net: usb: lan78xx: Fix lost EEPROM read timeout error(-ETIMEDOUT) in lan78xx_read_raw_eeprom

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: Read the LLP via the associated Link DMA channel

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Init acpi_gbl_use_global_lock to false

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Fix build error for LTO with LLVM-18

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Add cflag -fno-isolate-erroneous-paths-dereference

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: hda-pcm: Place the constraint on period time instead of buffer time

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-topology: Account for different ChainDMA host buffer size

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-topology: Correct the minimum host DMA buffer size

Ian Rogers <irogers@google.com>
    perf bpf_counter: Fix handling of cpumap fixing hybrid

Sean Christopherson <seanjc@google.com>
    mshv: Handle NEED_RESCHED_LAZY before transferring to guest

Daniel Lee <chullee@google.com>
    scsi: ufs: sysfs: Make HID attributes visible

Ian Rogers <irogers@google.com>
    perf bpf-filter: Fix opts declaration on older libbpfs

Duoming Zhou <duoming@zju.edu.cn>
    scsi: mvsas: Fix use-after-free bugs in mvs_work_queue

Aaron Kling <webgeek1234@gmail.com>
    cpufreq: tegra186: Set target frequency for all cpus in policy

Pin-yen Lin <treapking@chromium.org>
    PM: sleep: Do not wait on SYNC_STATE_ONLY device links

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: core: Add two macros for walking device links

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: core: Annotate loops walking device links as _srcu

Feng Yang <yangfeng@kylinos.cn>
    tracing: Fix the bug where bpf_get_stackid returns -EFAULT on the ARM64

Jeff Layton <jlayton@kernel.org>
    nfsd: fix timestamp updates in CB_GETATTR

Jeff Layton <jlayton@kernel.org>
    nfsd: fix SETATTR updates for delegated timestamps

Jeff Layton <jlayton@kernel.org>
    nfsd: track original timestamps in nfs4_delegation

Jeff Layton <jlayton@kernel.org>
    nfsd: use ATTR_CTIME_SET for delegated ctime updates

Jeff Layton <jlayton@kernel.org>
    vfs: add ATTR_CTIME_SET flag

Jeff Layton <jlayton@kernel.org>
    nfsd: ignore ATTR_DELEG when checking ia_valid before notify_change()

Jeff Layton <jlayton@kernel.org>
    nfsd: fix assignment of ia_ctime.tv_nsec on delegated mtime update

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
    perf build-id: Ensure snprintf string is empty when size is 0

Ian Rogers <irogers@google.com>
    perf evsel: Ensure the fallback message is always written to

Ian Rogers <irogers@google.com>
    perf test: Avoid uncore_imc/clockticks in uniquification test

Ian Rogers <irogers@google.com>
    perf evsel: Fix uniquification when PMU given without suffix

Ian Rogers <irogers@google.com>
    perf test: Don't leak workload gopipe in PERF_RECORD_*

Leo Yan <leo.yan@arm.com>
    perf session: Fix handling when buffer exceeds 2 GiB

Fushuai Wang <wangfushuai@baidu.com>
    perf trace: Fix IS_ERR() vs NULL check bug

Ian Rogers <irogers@google.com>
    perf test shell lbr: Avoid failures with perf event paranoia

Ian Rogers <irogers@google.com>
    perf test: AMD IBS swfilt skip kernel tests if paranoia is >1

Ilkka Koskinen <ilkka@os.amperecomputing.com>
    perf vendor events arm64 AmpereOneX: Fix typo - should be l1d_cache_access_prefetches

Leo Yan <leo.yan@arm.com>
    perf arm_spe: Correct memory level for remote access

Leo Yan <leo.yan@arm.com>
    perf arm_spe: Correct setting remote access

Clément Le Goffic <clement.legoffic@foss.st.com>
    rtc: optee: fix memory leak on driver removal

Rob Herring (Arm) <robh@kernel.org>
    rtc: x1205: Fix Xicor X1205 vendor prefix

Yunseong Kim <ysk@kzalloc.com>
    perf util: Fix compression checks returning -1 as bool

GuoHan Zhao <zhaoguohan@kylinos.cn>
    perf drm_pmu: Fix fd_dir leaks in for_each_drm_fdinfo_in_dir()

Christophe Leroy <christophe.leroy@csgroup.eu>
    perf: Completely remove possibility to override MAX_NR_CPUS

Yuan CHen <chenyuan@kylinos.cn>
    clk: renesas: cpg-mssr: Fix memory leak in cpg_mssr_reserved_init()

Brian Masney <bmasney@redhat.com>
    clk: at91: peripheral: fix return value

Ian Rogers <irogers@google.com>
    perf parse-events: Handle fake PMUs in CPU terms

Lukas Bulwahn <lukas.bulwahn@redhat.com>
    clk: qcom: Select the intended config in QCS_DISPCC_615

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

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    clk: renesas: r9a08g045: Add MSTOP for GPIO

Michal Wilczynski <m.wilczynski@samsung.com>
    clk: thead: Correct parent for DPU pixel clocks

Icenowy Zheng <uwu@icenowy.me>
    clk: thead: th1520-ap: fix parent of padctrl0 clock

Icenowy Zheng <uwu@icenowy.me>
    clk: thead: th1520-ap: describe gate clocks with clk_gate

Arnd Bergmann <arnd@arndb.de>
    clk: npcm: select CONFIG_AUXILIARY_BUS

Varad Gautam <varadgautam@google.com>
    asm-generic/io.h: Skip trace helpers if rwmmio events are disabled

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: v4l2-subdev: Fix alloc failure check in v4l2_subdev_call_state_try()

Michael Hennerich <michael.hennerich@analog.com>
    iio: frequency: adf4350: Fix ADF4350_REG3_12BIT_CLKDIV_MODE

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Emulate PERF_CNTR_GLOBAL_STATUS_SET for PerfMonV2

Hou Wenlong <houwenlong.hwl@antgroup.com>
    KVM: x86: Add helper to retrieve current value of user return MSR

Olga Kornievskaia <okorniev@redhat.com>
    nfsd: unregister with rpcbind when deleting a transport

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Make drivers using CPUFREQ_ETERNAL specify transition latency

Petr Tesarik <ptesarik@suse.com>
    dma-mapping: fix direction in dma_alloc direction traces

Brian Norris <briannorris@chromium.org>
    PM: runtime: Update kerneldoc return codes

Toke Høiland-Jørgensen <toke@redhat.com>
    page_pool: Fix PP_MAGIC_MASK to avoid crashing on some 32-bit arches

Shakeel Butt <shakeel.butt@linux.dev>
    memcg: skip cgroup_file_notify if spinning is not allowed

Zhen Ni <zhen.ni@easystack.cn>
    clocksource/drivers/clps711x: Fix resource leaks in error paths

Christian Brauner <brauner@kernel.org>
    listmount: don't call path_put() under namespace semaphore

Christian Brauner <brauner@kernel.org>
    statmount: don't call path_put() under namespace semaphore

Thomas Gleixner <tglx@linutronix.de>
    rseq: Protect event mask against membarrier IPI

Omar Sandoval <osandov@fb.com>
    arm64: map [_text, _stext) virtual address range non-executable+read-only

Qu Wenruo <wqu@suse.com>
    btrfs: fix the incorrect max_bytes value for find_lock_delalloc_range()

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
 arch/arm64/boot/dts/qcom/qcs615.dtsi               |   6 +
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |   4 +-
 arch/arm64/boot/dts/qcom/x1e80100-pmics.dtsi       |   2 +
 arch/arm64/boot/dts/ti/k3-am62a-main.dtsi          |   2 +-
 arch/arm64/boot/dts/ti/k3-am62p5.dtsi              |   2 +-
 arch/arm64/include/asm/ftrace.h                    |   1 +
 arch/arm64/kernel/cpufeature.c                     |  10 +-
 arch/arm64/kernel/mte.c                            |   2 +-
 arch/arm64/kernel/pi/map_kernel.c                  |   6 +
 arch/arm64/kernel/probes/kprobes.c                 |  12 +
 arch/arm64/kernel/setup.c                          |   4 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   9 +-
 arch/arm64/kvm/mmu.c                               |   9 +-
 arch/arm64/mm/init.c                               |   2 +-
 arch/arm64/mm/mmu.c                                |  14 +-
 arch/loongarch/Makefile                            |   4 +-
 arch/loongarch/kernel/setup.c                      |   1 +
 arch/parisc/include/uapi/asm/ioctls.h              |   8 +-
 arch/parisc/lib/memcpy.c                           |   1 -
 arch/powerpc/platforms/powernv/pci-ioda.c          |   2 +-
 arch/powerpc/platforms/pseries/msi.c               |   2 +-
 arch/riscv/include/asm/pgtable.h                   |  11 +
 arch/s390/Makefile                                 |   1 +
 arch/s390/include/asm/pgtable.h                    |  22 +
 arch/s390/kernel/vmlinux.lds.S                     |  54 +--
 arch/s390/mm/gmap_helpers.c                        |  12 +-
 arch/s390/mm/pgtable.c                             |  23 +-
 arch/sparc/kernel/of_device_32.c                   |   1 +
 arch/sparc/kernel/of_device_64.c                   |   1 +
 arch/sparc/mm/hugetlbpage.c                        |  20 +
 arch/x86/entry/entry_64_fred.S                     |   2 +-
 arch/x86/include/asm/kvm_host.h                    |   1 +
 arch/x86/include/asm/msr-index.h                   |   1 +
 arch/x86/kernel/kvm.c                              |  21 +-
 arch/x86/kernel/umip.c                             |  15 +-
 arch/x86/kvm/pmu.c                                 |   5 +
 arch/x86/kvm/svm/pmu.c                             |   1 +
 arch/x86/kvm/svm/sev.c                             |  10 +
 arch/x86/kvm/svm/svm.c                             |  25 +-
 arch/x86/kvm/svm/svm.h                             |   2 +
 arch/x86/kvm/vmx/tdx.c                             |  10 +-
 arch/x86/kvm/x86.c                                 |   8 +
 arch/xtensa/platforms/iss/simdisk.c                |   6 +-
 block/blk-crypto-fallback.c                        |   3 +
 crypto/essiv.c                                     |  14 +-
 crypto/skcipher.c                                  |   2 +
 drivers/acpi/acpi_dbg.c                            |  26 +-
 drivers/acpi/acpi_tad.c                            |   3 +
 drivers/acpi/acpica/acdebug.h                      |   2 +-
 drivers/acpi/acpica/evglock.c                      |   4 +
 drivers/acpi/battery.c                             |  43 +-
 drivers/acpi/property.c                            | 139 +++---
 drivers/base/base.h                                |   9 +
 drivers/base/core.c                                |   2 +-
 drivers/base/power/main.c                          |  24 +-
 drivers/base/power/runtime.c                       |   3 +-
 drivers/block/loop.c                               |   8 +-
 drivers/bus/mhi/ep/main.c                          |  37 +-
 drivers/bus/mhi/host/init.c                        |   5 +-
 drivers/cdx/cdx_msi.c                              |   1 +
 drivers/char/ipmi/ipmi_kcs_sm.c                    |  16 +-
 drivers/char/ipmi/ipmi_msghandler.c                | 490 ++++++++++-----------
 drivers/char/tpm/tpm_tis_core.c                    |   4 +-
 drivers/clk/Kconfig                                |   1 +
 drivers/clk/at91/clk-peripheral.c                  |   7 +-
 drivers/clk/mediatek/clk-mt8195-infra_ao.c         |   2 +-
 drivers/clk/mediatek/clk-mux.c                     |   4 +-
 drivers/clk/nxp/clk-lpc18xx-cgu.c                  |  20 +-
 drivers/clk/qcom/Kconfig                           |   2 +-
 drivers/clk/qcom/common.c                          |   4 +-
 drivers/clk/qcom/tcsrcc-x1e80100.c                 |   4 +
 drivers/clk/renesas/r9a08g045-cpg.c                |   3 +-
 drivers/clk/renesas/renesas-cpg-mssr.c             |   7 +-
 drivers/clk/samsung/clk-exynos990.c                |  52 ++-
 drivers/clk/tegra/clk-bpmp.c                       |   2 +-
 drivers/clk/thead/clk-th1520-ap.c                  | 390 ++++++++--------
 drivers/clocksource/clps711x-timer.c               |  23 +-
 drivers/cpufreq/cppc_cpufreq.c                     |  14 +-
 drivers/cpufreq/cpufreq-dt.c                       |   2 +-
 drivers/cpufreq/imx6q-cpufreq.c                    |   2 +-
 drivers/cpufreq/intel_pstate.c                     |   8 +-
 drivers/cpufreq/mediatek-cpufreq-hw.c              |   2 +-
 drivers/cpufreq/rcpufreq_dt.rs                     |   2 +-
 drivers/cpufreq/scmi-cpufreq.c                     |   2 +-
 drivers/cpufreq/scpi-cpufreq.c                     |   2 +-
 drivers/cpufreq/spear-cpufreq.c                    |   2 +-
 drivers/cpufreq/tegra186-cpufreq.c                 |   8 +-
 drivers/crypto/aspeed/aspeed-hace-crypto.c         |   2 +-
 drivers/crypto/atmel-tdes.c                        |   2 +-
 drivers/crypto/rockchip/rk3288_crypto_ahash.c      |   2 +-
 drivers/firmware/arm_scmi/quirks.c                 |  15 +-
 drivers/firmware/meson/meson_sm.c                  |   7 +-
 drivers/firmware/samsung/exynos-acpm-pmic.c        |  25 +-
 drivers/gpio/gpio-mpfs.c                           |   2 +-
 drivers/gpio/gpio-wcd934x.c                        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   9 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   4 +
 drivers/gpu/drm/amd/display/dc/dce/dce_transform.c |  21 +-
 drivers/gpu/drm/amd/display/dc/dce/dce_transform.h |   4 +
 .../gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c   |   4 +
 .../gpu/drm/amd/display/dc/dml/dcn35/dcn35_fpu.c   |   6 +-
 .../gpu/drm/amd/display/dc/dml/dcn351/dcn351_fpu.c |   4 +-
 .../amd/display/dc/resource/dce60/dce60_resource.c |   4 +-
 .../amd/display/dc/resource/dcn35/dcn35_resource.c |  16 +-
 .../display/dc/resource/dcn351/dcn351_resource.c   |  17 +-
 .../amd/display/dc/resource/dcn36/dcn36_resource.c |  16 +-
 drivers/gpu/drm/amd/display/dc/sspl/dc_spl.c       |  10 +-
 .../gpu/drm/amd/include/asic_reg/dce/dce_6_0_d.h   |   7 +
 .../drm/amd/include/asic_reg/dce/dce_6_0_sh_mask.h |   2 +
 drivers/gpu/drm/exynos/exynos7_drm_decon.c         |  36 --
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |  28 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.h              |   6 +
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   2 +-
 drivers/gpu/drm/panthor/panthor_drv.c              |  11 +-
 drivers/gpu/drm/renesas/rcar-du/rcar_mipi_dsi.c    |   5 +-
 .../gpu/drm/renesas/rcar-du/rcar_mipi_dsi_regs.h   |   8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |  17 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_validation.c         |   6 +-
 drivers/gpu/drm/xe/xe_hw_engine_group.c            |   6 +-
 drivers/gpu/drm/xe/xe_pm.c                         |   2 +-
 drivers/gpu/drm/xe/xe_query.c                      |  15 +-
 drivers/hv/mshv_common.c                           |   2 +-
 drivers/hv/mshv_root_main.c                        |   3 +-
 drivers/i3c/master.c                               |   2 +-
 drivers/iio/adc/pac1934.c                          |  20 +-
 drivers/iio/adc/xilinx-ams.c                       |  47 +-
 drivers/iio/dac/ad5360.c                           |   2 +-
 drivers/iio/dac/ad5421.c                           |   2 +-
 drivers/iio/frequency/adf4350.c                    |  20 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c   |  39 +-
 drivers/iommu/intel/iommu.c                        |   2 +-
 drivers/irqchip/irq-sifive-plic.c                  |   6 +-
 drivers/mailbox/mtk-cmdq-mailbox.c                 |  12 +-
 drivers/mailbox/zynqmp-ipi-mailbox.c               |  24 +-
 drivers/md/md-linear.c                             |   1 +
 drivers/md/raid0.c                                 |   4 +
 drivers/md/raid1.c                                 |   4 +
 drivers/md/raid10.c                                |   8 +
 drivers/md/raid5.c                                 |   2 +
 .../media/cec/usb/extron-da-hd-4k-plus/Makefile    |   6 -
 drivers/media/i2c/mt9p031.c                        |   4 +-
 drivers/media/i2c/mt9v111.c                        |   2 +-
 drivers/media/mc/mc-devnode.c                      |   6 +-
 drivers/media/mc/mc-entity.c                       |   2 +-
 drivers/media/pci/cx18/cx18-queue.c                |  13 +-
 drivers/media/pci/ivtv/ivtv-irq.c                  |   2 +-
 drivers/media/pci/ivtv/ivtv-yuv.c                  |   8 +-
 drivers/media/pci/mgb4/mgb4_trigger.c              |   2 +-
 .../media/platform/mediatek/mdp3/mtk-mdp3-comp.c   |   3 +
 drivers/media/platform/qcom/iris/iris_buffer.c     |  31 +-
 drivers/media/platform/qcom/iris/iris_buffer.h     |   1 +
 drivers/media/platform/qcom/iris/iris_core.c       |  10 +-
 drivers/media/platform/qcom/iris/iris_firmware.c   |  15 +-
 .../platform/qcom/iris/iris_hfi_gen1_command.c     |  45 +-
 .../platform/qcom/iris/iris_hfi_gen1_response.c    |   4 +-
 .../platform/qcom/iris/iris_hfi_gen2_response.c    |   5 +-
 drivers/media/platform/qcom/iris/iris_state.c      |   5 +-
 drivers/media/platform/qcom/iris/iris_state.h      |   1 +
 drivers/media/platform/qcom/iris/iris_vb2.c        |   8 +-
 drivers/media/platform/qcom/iris/iris_vdec.c       |   2 +-
 drivers/media/platform/qcom/iris/iris_vidc.c       |   1 +
 drivers/media/platform/qcom/iris/iris_vpu3x.c      |  32 +-
 drivers/media/platform/qcom/iris/iris_vpu_common.c |   2 +-
 drivers/media/platform/qcom/venus/firmware.c       |   8 +-
 drivers/media/platform/qcom/venus/pm_helpers.c     |   9 +-
 drivers/media/platform/renesas/vsp1/vsp1_vspx.c    |   1 +
 .../platform/samsung/s5p-mfc/s5p_mfc_cmd_v6.c      |  35 +-
 .../media/platform/ti/j721e-csi2rx/j721e-csi2rx.c  |   9 +-
 drivers/media/rc/lirc_dev.c                        |   9 +-
 drivers/media/test-drivers/vivid/vivid-cec.c       |  12 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |   3 +-
 drivers/memory/samsung/exynos-srom.c               |  10 +-
 drivers/memory/stm32_omm.c                         |   2 +-
 drivers/mmc/core/sdio.c                            |   6 +-
 drivers/mmc/host/mmc_spi.c                         |   2 +-
 drivers/mtd/nand/raw/fsmc_nand.c                   |   6 +-
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c         |  14 +-
 drivers/net/ethernet/airoha/airoha_eth.c           |   4 +-
 drivers/net/ethernet/airoha/airoha_regs.h          |   3 +
 drivers/net/ethernet/freescale/fsl_pq_mdio.c       |   2 +
 drivers/net/ethernet/intel/ice/ice_adapter.c       |  10 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |  38 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |   2 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |  32 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   5 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  18 +-
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |   5 +
 .../ethernet/microchip/sparx5/sparx5_switchdev.c   |  12 +
 .../net/ethernet/microchip/sparx5/sparx5_vlan.c    |  10 -
 drivers/net/ethernet/mscc/ocelot_stats.c           |   2 +-
 drivers/net/mdio/mdio-i2c.c                        |  39 +-
 drivers/net/pse-pd/tps23881.c                      |   2 +-
 drivers/net/usb/lan78xx.c                          |  11 +-
 drivers/net/wireless/ath/ath11k/core.c             |   6 +-
 drivers/net/wireless/ath/ath11k/hal.c              |  16 +
 drivers/net/wireless/ath/ath11k/hal.h              |   1 +
 drivers/net/wireless/intel/iwlwifi/mld/debugfs.c   |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c    |   3 +
 drivers/net/wireless/mediatek/mt76/mt7925/usb.c    |   3 +
 drivers/net/wireless/realtek/rtw89/core.c          |  39 +-
 drivers/net/wireless/realtek/rtw89/core.h          |   3 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   2 -
 drivers/nvme/host/pci.c                            |   2 +
 drivers/of/unittest.c                              |   1 +
 drivers/pci/bus.c                                  |  14 +-
 drivers/pci/controller/cadence/pci-j721e.c         |  26 ++
 drivers/pci/controller/dwc/pci-keystone.c          |   4 +-
 drivers/pci/controller/dwc/pcie-rcar-gen4.c        |   2 +-
 drivers/pci/controller/dwc/pcie-tegra194.c         |  32 +-
 drivers/pci/controller/pci-tegra.c                 |  27 +-
 drivers/pci/controller/pcie-rcar-host.c            |  40 +-
 drivers/pci/controller/pcie-xilinx-nwl.c           |   7 +-
 drivers/pci/iov.c                                  |   5 +
 drivers/pci/pci-driver.c                           |   1 +
 drivers/pci/pci-sysfs.c                            |  20 +-
 drivers/pci/pcie/aer.c                             |  12 +-
 drivers/pci/pcie/err.c                             |   8 +-
 drivers/pci/probe.c                                |  19 +-
 drivers/pci/remove.c                               |   2 +
 drivers/pci/setup-bus.c                            |  37 +-
 drivers/perf/arm-cmn.c                             |   9 +-
 drivers/pinctrl/samsung/pinctrl-samsung.h          |   4 -
 drivers/power/supply/max77976_charger.c            |  12 +-
 drivers/pwm/core.c                                 |   2 +-
 drivers/pwm/pwm-berlin.c                           |   4 +-
 drivers/rtc/interface.c                            |  27 ++
 drivers/rtc/rtc-isl12022.c                         |   1 +
 drivers/rtc/rtc-optee.c                            |   1 +
 drivers/rtc/rtc-x1205.c                            |   2 +-
 drivers/s390/block/dasd.c                          |  17 +-
 drivers/s390/cio/device.c                          |  37 +-
 drivers/s390/cio/ioasm.c                           |   7 +-
 drivers/scsi/hpsa.c                                |  21 +-
 drivers/scsi/mvsas/mv_init.c                       |   2 +-
 drivers/scsi/sd.c                                  |  50 ++-
 drivers/spi/spi-cadence-quadspi.c                  |  18 +-
 drivers/staging/media/ipu7/ipu7-isys-video.c       |   1 +
 drivers/ufs/core/ufs-sysfs.c                       |   2 +-
 drivers/ufs/core/ufs-sysfs.h                       |   1 +
 drivers/ufs/core/ufshcd.c                          |   2 +
 drivers/video/fbdev/core/fb_cmdline.c              |   2 +-
 drivers/xen/events/events_base.c                   |  37 +-
 drivers/xen/manage.c                               |  14 +-
 fs/attr.c                                          |  44 +-
 fs/btrfs/export.c                                  |   8 +-
 fs/btrfs/extent_io.c                               |  14 +-
 fs/cramfs/inode.c                                  |  11 +-
 fs/eventpoll.c                                     | 139 ++----
 fs/ext4/ext4.h                                     |   2 +
 fs/ext4/fsmap.c                                    |  14 +-
 fs/ext4/indirect.c                                 |   2 +-
 fs/ext4/inode.c                                    |  45 +-
 fs/ext4/move_extent.c                              |   2 +-
 fs/ext4/orphan.c                                   |  17 +-
 fs/ext4/super.c                                    |  26 +-
 fs/ext4/xattr.c                                    |  19 +-
 fs/file.c                                          |   5 +-
 fs/fs-writeback.c                                  |  32 +-
 fs/fsopen.c                                        |  70 +--
 fs/fuse/dev.c                                      |   2 +-
 fs/fuse/file.c                                     |   8 +-
 fs/iomap/buffered-io.c                             |  15 +-
 fs/iomap/direct-io.c                               |   3 +
 fs/minix/inode.c                                   |   8 +-
 fs/namei.c                                         |   8 +
 fs/namespace.c                                     | 110 +++--
 fs/nfsd/export.c                                   |  82 ++--
 fs/nfsd/export.h                                   |   3 +
 fs/nfsd/lockd.c                                    |  15 +
 fs/nfsd/nfs4proc.c                                 |  33 +-
 fs/nfsd/nfs4state.c                                |  44 +-
 fs/nfsd/nfs4xdr.c                                  |   5 +-
 fs/nfsd/nfsfh.c                                    |  24 +-
 fs/nfsd/state.h                                    |   8 +
 fs/nfsd/vfs.c                                      |   2 +-
 fs/nsfs.c                                          |   4 +-
 fs/ntfs3/bitmap.c                                  |   1 +
 fs/pidfs.c                                         |   2 +-
 fs/quota/dquot.c                                   |  10 +-
 fs/read_write.c                                    |  14 +-
 fs/smb/client/dir.c                                |   1 +
 fs/smb/client/smb1ops.c                            |  62 ++-
 fs/smb/client/smb2inode.c                          |  22 +-
 fs/smb/client/smb2ops.c                            |  10 +-
 fs/squashfs/inode.c                                |  24 +-
 fs/xfs/scrub/reap.c                                |   9 +-
 include/acpi/acpixf.h                              |   6 +
 include/asm-generic/io.h                           |  98 +++--
 include/asm-generic/vmlinux.lds.h                  |   2 +-
 include/linux/cpufreq.h                            |   3 +
 include/linux/fs.h                                 |  15 +
 include/linux/iio/frequency/adf4350.h              |   2 +-
 include/linux/ksm.h                                |   8 +-
 include/linux/memcontrol.h                         |  26 +-
 include/linux/mm.h                                 |  22 +-
 include/linux/pm_runtime.h                         |  56 +--
 include/linux/rseq.h                               |  11 +-
 include/linux/sunrpc/svc_xprt.h                    |   3 +
 include/media/v4l2-subdev.h                        |  30 +-
 include/trace/events/dma.h                         |   1 +
 init/main.c                                        |  12 +
 io_uring/zcrx.c                                    |   1 +
 kernel/bpf/inode.c                                 |   4 +-
 kernel/fork.c                                      |   2 +-
 kernel/kexec_handover.c                            |   2 +-
 kernel/padata.c                                    |   6 +-
 kernel/pid.c                                       |   5 +-
 kernel/power/energy_model.c                        |  11 +-
 kernel/power/hibernate.c                           |   6 +
 kernel/rseq.c                                      |  10 +-
 kernel/sched/deadline.c                            |  73 ++-
 kernel/sys.c                                       |  22 +-
 lib/genalloc.c                                     |   5 +-
 mm/damon/lru_sort.c                                |   2 +-
 mm/damon/vaddr.c                                   |   8 +-
 mm/huge_memory.c                                   |  15 +-
 mm/hugetlb.c                                       |   3 +
 mm/memcontrol.c                                    |   7 +-
 mm/migrate.c                                       |  23 +-
 mm/page_alloc.c                                    |   2 +-
 mm/slab.h                                          |   8 +-
 mm/slub.c                                          |   3 +-
 mm/util.c                                          |   3 +-
 net/bridge/br_vlan.c                               |   2 +-
 net/core/filter.c                                  |   2 +
 net/core/page_pool.c                               |  76 +++-
 net/ipv4/tcp.c                                     |   5 +-
 net/ipv4/tcp_input.c                               |   1 -
 net/mptcp/ctrl.c                                   |   2 +-
 net/mptcp/pm.c                                     |   7 +-
 net/mptcp/pm_kernel.c                              |  50 ++-
 net/mptcp/protocol.h                               |   8 +
 net/netfilter/nft_objref.c                         |  39 ++
 net/sctp/sm_make_chunk.c                           |   3 +-
 net/sctp/sm_statefuns.c                            |   6 +-
 net/sunrpc/svc_xprt.c                              |  13 +
 net/sunrpc/svcsock.c                               |   2 +
 net/xdp/xsk_queue.h                                |  45 +-
 rust/kernel/cpufreq.rs                             |   7 +-
 scripts/Makefile.vmlinux                           |  51 ++-
 scripts/mksysmap                                   |   3 +
 security/keys/trusted-keys/trusted_tpm1.c          |   7 +-
 sound/soc/sof/intel/hda-pcm.c                      |  29 +-
 sound/soc/sof/intel/hda-stream.c                   |  29 +-
 sound/soc/sof/ipc4-topology.c                      |   9 +-
 sound/soc/sof/ipc4-topology.h                      |   7 +-
 tools/build/feature/Makefile                       |   4 +-
 tools/lib/perf/include/perf/event.h                |   1 +
 tools/perf/Makefile.perf                           |   2 +-
 tools/perf/builtin-trace.c                         |   4 +-
 tools/perf/perf.h                                  |   2 -
 .../arch/arm64/ampere/ampereonex/metrics.json      |  10 +-
 tools/perf/tests/perf-record.c                     |   4 +
 tools/perf/tests/shell/amd-ibs-swfilt.sh           |  51 ++-
 tools/perf/tests/shell/record_lbr.sh               |  26 +-
 tools/perf/tests/shell/stat+event_uniquifying.sh   | 113 +++--
 tools/perf/tests/shell/trace_btf_enum.sh           |  11 +
 tools/perf/util/arm-spe.c                          |   6 +-
 tools/perf/util/bpf-filter.c                       |   8 +
 tools/perf/util/bpf_counter.c                      |  26 +-
 tools/perf/util/bpf_counter_cgroup.c               |   3 +-
 tools/perf/util/bpf_skel/kwork_top.bpf.c           |   2 -
 tools/perf/util/build-id.c                         |   7 +
 tools/perf/util/disasm.c                           |   7 +-
 tools/perf/util/drm_pmu.c                          |   4 +-
 tools/perf/util/evsel.c                            |  44 +-
 tools/perf/util/lzma.c                             |   2 +-
 tools/perf/util/parse-events.c                     | 116 ++---
 tools/perf/util/session.c                          |   2 +-
 tools/perf/util/setup.py                           |   5 +-
 tools/perf/util/zlib.c                             |   2 +-
 tools/power/acpi/tools/acpidump/apfiles.c          |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  11 +
 .../selftests/net/netfilter/nf_nat_edemux.sh       |  58 ++-
 tools/testing/selftests/net/netfilter/nft_fib.sh   |  13 +-
 tools/testing/selftests/net/ovpn/ovpn-cli.c        |   2 +
 tools/testing/selftests/rseq/rseq.c                |   8 +-
 385 files changed, 3704 insertions(+), 2240 deletions(-)


