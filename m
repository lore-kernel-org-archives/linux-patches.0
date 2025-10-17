Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044C619E7F7;
	Fri, 17 Oct 2025 14:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713032; cv=none; b=QpgCLDopS033vQ4qOGjLYFxjDH8mBtEh3MaOt5+lvOhXpq931iiHj+No9Yz1JLa9vu/8rP7dKMVFFJH18vm7i5XxMk2ejn05XdvlH8Xj1d3x28AFZZjgfUlF+cxaq1XtQOgAqYDkE5EhTEEpaj0/IQpNABwsIS349p0Ss9YgLxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713032; c=relaxed/simple;
	bh=qOmSQhYa7XjTwwh3nvR8PXbdUOkliuBYRai4h7DdxY8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DhjhQxJEUsw092nmVbfBRTtIneM6ef86eS/i8c3hh8Syd07s2cg1YLHY5p2ygeY1ivulKlFZRpPn53/XIKWlu4JuaZi8MjDEc7BngB5TXjmUCJudPJ5IiFdWUdFshO/582hgfmLtT9YxzFxva0t8oOc8zS0CHxNnm4dmnQg8zgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVjnfLBi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVjnfLBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD3EC4CEF9;
	Fri, 17 Oct 2025 14:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713031;
	bh=qOmSQhYa7XjTwwh3nvR8PXbdUOkliuBYRai4h7DdxY8=;
	h=From:To:Cc:Subject:Date:From;
	b=WVjnfLBi0qdsyUSUsNW+phPtmGjnp+c/FUv/PEeDmpnSV4XhQ/TTDhkjlJtndZaWV
	 pgEWloXF4CxfiawmAV5/ElB2uaD6YSUrxrEK1p0xBxN7+yKo/hCJVzn6j4ViNIj9GA
	 kD49dGlsj/1YV1eNI3J5v+tcbJiRxH1M56dNyEMs=
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
Subject: [PATCH 6.1 000/168] 6.1.157-rc1 review
Date: Fri, 17 Oct 2025 16:51:19 +0200
Message-ID: <20251017145129.000176255@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.157-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.157-rc1
X-KernelTest-Deadline: 2025-10-19T14:51+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.157 release.
There are 168 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.157-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.157-rc1

Jason Andryuk <jason.andryuk@amd.com>
    xen/events: Update virq_to_irq on migration

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

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: in-kernel: usable client side with C-flag

Varad Gautam <varadgautam@google.com>
    asm-generic/io.h: Skip trace helpers if rwmmio events are disabled

Vladimir Oltean <vladimir.oltean@nxp.com>
    asm-generic/io.h: suppress endianness warnings for relaxed accessors

Sai Prakash Ranjan <quic_saipraka@quicinc.com>
    asm-generic/io: Add _RET_IP_ to MMIO trace for more accurate debug info

Lance Yang <lance.yang@linux.dev>
    selftests/mm: skip soft-dirty tests when CONFIG_MEM_SOFT_DIRTY is disabled

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: property: Do not pass NULL handles to acpi_attach_data()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: property: Add code comments explaining what is going on

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: property: Disregard references in data-only subnode lists

Guenter Roeck <linux@roeck-us.net>
    ipmi: Fix handling of messages with provided receive message pointer

Corey Minyard <corey@minyard.net>
    ipmi: Rework user message limit handling

Thomas Gleixner <tglx@linutronix.de>
    rseq: Protect event mask against membarrier IPI

Qu Wenruo <wqu@suse.com>
    btrfs: fix the incorrect max_bytes value for find_lock_delalloc_range()

Hans de Goede <hansg@kernel.org>
    mfd: intel_soc_pmic_chtdc_ti: Set use_single_read regmap_config flag

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_soc_pmic_chtdc_ti: Drop unneeded assignment for cache_type

Hans de Goede <hdegoede@redhat.com>
    mfd: intel_soc_pmic_chtdc_ti: Fix invalid regmap-config max_register value

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    PCI: endpoint: pci-epf-test: Add NULL check for DMA channels before release

Wang Jiang <jiangwang@kylinos.cn>
    PCI: endpoint: Remove surplus return statement from pci_epf_test_clean_dma_chan()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add max ip connections parameter

Yuan Chen <chenyuan@kylinos.cn>
    tracing: Fix race condition in kprobe initialization causing NULL pointer dereference

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: reject negative file sizes in squashfs_read_inode()

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: add additional inode sanity checking

Edward Adam Davis <eadavis@qq.com>
    media: mc: Clear minor number before put device

Sean Christopherson <seanjc@google.com>
    KVM: x86: Don't (re)check L1 intercepts when completing userspace I/O

Ma Ke <make24@iscas.ac.cn>
    ASoC: wcd934x: fix error handling in wcd934x_codec_parse_data()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wcd934x: Simplify with dev_err_probe

Nathan Chancellor <nathan@kernel.org>
    lib/crypto/curve25519-hacl64: Disable KASAN with clang-17 and older

Jan Kara <jack@suse.cz>
    ext4: free orphan info with kvfree

Huacai Chen <chenhuacai@kernel.org>
    ACPICA: Allow to skip Global Lock initialization

Ahmet Eray Karadag <eraykrdg1@gmail.com>
    ext4: guard against EA inode refcount underflow in xattr update

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: correctly handle queries for metadata mappings

Yongjian Sun <sunyongjian1@huawei.com>
    ext4: increase i_disksize to offset + len in ext4_update_disksize_before_punch()

Jan Kara <jack@suse.cz>
    ext4: verify orphan file size is not too big

Olga Kornievskaia <okorniev@redhat.com>
    nfsd: nfserr_jukebox in nlm_fopen should lead to a retry

Thorsten Blum <thorsten.blum@linux.dev>
    NFSD: Fix destination buffer size in nfsd4_ssc_setup_dul()

Li RongQing <lirongqing@baidu.com>
    mm/hugetlb: early exit from hugetlb_pages_alloc_boot() when max_huge_pages=0

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    mm/page_alloc: only set ALLOC_HIGHATOMIC for __GPF_HIGH allocations

Muhammad Usama Anjum <usama.anjum@collabora.com>
    wifi: ath11k: HAL SRNG: don't deinitialize and re-initialize again

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: validate C-flag + def limit

Sean Christopherson <seanjc@google.com>
    x86/umip: Fix decoding of register forms of 0F 01 (SGDT and SIDT aliases)

Sean Christopherson <seanjc@google.com>
    x86/umip: Check that the instruction opcode is at least two bytes

Pratyush Yadav <pratyush@kernel.org>
    spi: cadence-quadspi: Flush posted register writes before DAC access

Pratyush Yadav <pratyush@kernel.org>
    spi: cadence-quadspi: Flush posted register writes before INDAC access

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Handle errors in BPMP response

Niklas Cassel <cassel@kernel.org>
    PCI: tegra194: Fix broken tegra_pcie_ep_raise_msi_irq()

Marek Vasut <marek.vasut+renesas@mailbox.org>
    PCI: rcar-host: Convert struct rcar_msi mask_lock into raw spinlock

Marek Vasut <marek.vasut+renesas@mailbox.org>
    PCI: rcar-host: Drop PMSR spinlock

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

Brian Norris <briannorris@google.com>
    PCI/sysfs: Ensure devices are powered for config reads

Marek Vasut <marek.vasut+renesas@mailbox.org>
    PCI: tegra: Convert struct tegra_msi mask_lock into raw spinlock

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

Miaoqian Lin <linmq006@gmail.com>
    xtensa: simdisk: add input size check in proc_write_simdisk

Ma Ke <make24@iscas.ac.cn>
    sparc: fix error handling in scan_one_device()

Anthony Yznaga <anthony.yznaga@oracle.com>
    sparc64: fix hugetlb for sun4u

Eric Biggers <ebiggers@kernel.org>
    sctp: Fix MAC comparison to be constant-time

Thorsten Blum <thorsten.blum@linux.dev>
    scsi: hpsa: Fix potential memory leak in hpsa_big_passthru_ioctl()

Harshit Agarwal <harshit@nutanix.com>
    sched/deadline: Fix race in push_dl_task()

Jisheng Zhang <jszhang@kernel.org>
    pwm: berlin: Fix wrong register in suspend/resume

Nam Cao <namcao@linutronix.de>
    powerpc/pseries/msi: Fix potential underflow and leak issue

Nam Cao <namcao@linutronix.de>
    powerpc/powernv/pci: Fix underflow and leak issue

Dzmitry Sankouski <dsankouski@gmail.com>
    power: supply: max77976_charger: fix constant current reporting

Georg Gottleuber <ggo@tuxedocomputers.com>
    nvme-pci: Add TUXEDO IBS Gen8 to Samsung sleep quirk

John David Anglin <dave.anglin@bell.net>
    parisc: Remove spurious if statement from raw_copy_from_user()

Sam James <sam@gentoo.org>
    parisc: don't reference obsolete termio struct for TC* constants

Askar Safin <safinaskar@zohomail.com>
    openat2: don't trigger automounts with RESOLVE_NO_XDEV

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

Haoxiang Li <haoxiang_li2024@163.com>
    fs/ntfs3: Fix a resource leak bug in wnd_extend()

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: atmel - Fix dma_unmap_sg() direction

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: aspeed - Fix dma_unmap_sg() direction

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Fix object lifecycle issue in update_qos_request()

Simon Schuster <schuster.simon@siemens-energy.com>
    copy_sighand: Handle architectures where sizeof(unsigned long) < sizeof(u64)

Adam Xue <zxue@semtech.com>
    bus: mhi: host: Do not use uninitialized 'dev' pointer in mhi_init_irq_setup()

Anderson Nascimento <anderson@allelesecurity.com>
    btrfs: avoid potential out-of-bounds in btrfs_encode_fh()

Yu Kuai <yukuai3@huawei.com>
    blk-crypto: fix missing blktrace bio split events

Shuhao Fu <sfual@cse.ust.hk>
    drm/nouveau: fix bad ret code in nouveau_bo_move_prep

Ma Ke <make24@iscas.ac.cn>
    media: lirc: Fix error handling in lirc_register()

Thomas Fourier <fourier.thomas@gmail.com>
    media: pci: ivtv: Add missing check after DMA map

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: mc: Fix MUST_CONNECT handling for pads with no links

Qianfeng Rong <rongqianfeng@vivo.com>
    media: i2c: mt9v111: fix incorrect type for ret

Thomas Fourier <fourier.thomas@gmail.com>
    media: cx18: Add missing check after DMA map

Johan Hovold <johan@kernel.org>
    firmware: meson_sm: fix device leak at probe

Lukas Wunner <lukas@wunner.de>
    xen/manage: Fix suspend error path

Jason Andryuk <jason.andryuk@amd.com>
    xen/events: Cleanup find_virq() return codes

Michael Riesch <michael.riesch@collabora.com>
    dt-bindings: phy: rockchip-inno-csi-dphy: make power-domains non-required

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: governors: menu: Avoid using invalid recent intervals data

Miaoqian Lin <linmq006@gmail.com>
    ARM: OMAP2+: pm33xx-core: ix device node reference leaks in amx3_idle_init

Vibhore Vardhan <vibhore@ti.com>
    arm64: dts: ti: k3-am62a-main: Fix main padcfg length

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: sdm845: Fix slimbam num-channels/ees

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: msm8916: Add missing MDSS reset

Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
    ACPI: debug: fix signedness issues in read/write helpers

Daniel Tang <danielzgtg.opensource@gmail.com>
    ACPI: TAD: Add missing sysfs_remove_group() for ACPI_TAD_RT

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: property: Fix buffer properties extraction for subnodes

KaFai Wan <kafai.wan@linux.dev>
    bpf: Avoid RCU context warning when unpinning htab with internal structs

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: wcd934x: mark the GPIO controller as sleeping

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: wcd934x: Remove duplicate assignment of of_gpio_n_cells

Gunnar Kudrjavets <gunnarku@amazon.com>
    tpm_tis: Fix incorrect arguments in tpm_tis_probe_irq_single

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: essiv - Check ssize for decryption and in-place encryption

Eric Woudstra <ericwouds@gmail.com>
    bridge: br_vlan_fill_forward_path_pvid: use br_vlan_group_rcu()

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
    drm/vmwgfx: Fix copy-paste typo in validation

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Fix Use-after-free in validation

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: Update purge function to unregister the unused subchannels

Dan Carpenter <dan.carpenter@linaro.org>
    net/mlx4: prevent potential use after free in mlx4_en_do_uc_filter()

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Init acpi_gbl_use_global_lock to false

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Remove CONFIG_ACPI_TABLE_UPGRADE in platform_init()

Duoming Zhou <duoming@zju.edu.cn>
    scsi: mvsas: Fix use-after-free bugs in mvs_work_queue

John Garry <john.garry@huawei.com>
    scsi: mvsas: Use sas_task_find_rq() for tagging

John Garry <john.garry@huawei.com>
    scsi: mvsas: Delete mvs_tag_init()

John Garry <john.garry@huawei.com>
    scsi: libsas: Add sas_task_find_rq()

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
    perf test: Don't leak workload gopipe in PERF_RECORD_*

Leo Yan <leo.yan@arm.com>
    perf session: Fix handling when buffer exceeds 2 GiB

Leo Yan <leo.yan@arm.com>
    perf arm_spe: Correct memory level for remote access

Leo Yan <leo.yan@arm.com>
    perf arm-spe: Rename the common data source encoding

German Gomez <german.gomez@arm.com>
    perf arm-spe: Refactor arm-spe to support operation packet type

Leo Yan <leo.yan@arm.com>
    perf arm_spe: Correct setting remote access

Clément Le Goffic <clement.legoffic@foss.st.com>
    rtc: optee: fix memory leak on driver removal

Rob Herring (Arm) <robh@kernel.org>
    rtc: x1205: Fix Xicor X1205 vendor prefix

Yunseong Kim <ysk@kzalloc.com>
    perf util: Fix compression checks returning -1 as bool

Brian Masney <bmasney@redhat.com>
    clk: at91: peripheral: fix return value

Ian Rogers <irogers@google.com>
    libperf event: Ensure tracing data is multiple of 8 sized

Ian Rogers <irogers@google.com>
    perf evsel: Avoid container_of on a NULL leader

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: v4l2-subdev: Fix alloc failure check in v4l2_subdev_call_state_try()

Michael Hennerich <michael.hennerich@analog.com>
    iio: frequency: adf4350: Fix ADF4350_REG3_12BIT_CLKDIV_MODE

Zhen Ni <zhen.ni@easystack.cn>
    clocksource/drivers/clps711x: Fix resource leaks in error paths

Aleksa Sarai <cyphar@cyphar.com>
    fscontext: do not consume log entries when returning -EMSGSIZE

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    fs: always return zero on success from replace_fd()


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   3 +
 .../bindings/phy/rockchip-inno-csi-dphy.yaml       |  15 +-
 Makefile                                           |   4 +-
 arch/arm/mach-omap2/pm33xx-core.c                  |   6 +-
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |   2 +
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |   4 +-
 arch/arm64/boot/dts/ti/k3-am62a-main.dtsi          |   2 +-
 arch/loongarch/kernel/setup.c                      |   5 +-
 arch/parisc/include/uapi/asm/ioctls.h              |   8 +-
 arch/parisc/lib/memcpy.c                           |   1 -
 arch/powerpc/platforms/powernv/pci-ioda.c          |   2 +-
 arch/powerpc/platforms/pseries/msi.c               |   2 +-
 arch/sparc/kernel/of_device_32.c                   |   1 +
 arch/sparc/kernel/of_device_64.c                   |   1 +
 arch/sparc/mm/hugetlbpage.c                        |  20 +
 arch/x86/kernel/umip.c                             |  15 +-
 arch/x86/kvm/emulate.c                             |  11 +-
 arch/x86/kvm/kvm_emulate.h                         |   2 +-
 arch/x86/kvm/x86.c                                 |   9 +-
 arch/xtensa/platforms/iss/simdisk.c                |   6 +-
 block/blk-crypto-fallback.c                        |   3 +
 crypto/essiv.c                                     |  14 +-
 drivers/acpi/acpi_dbg.c                            |  26 +-
 drivers/acpi/acpi_tad.c                            |   3 +
 drivers/acpi/acpica/evglock.c                      |   4 +
 drivers/acpi/property.c                            | 139 ++++---
 drivers/bus/mhi/host/init.c                        |   5 +-
 drivers/char/ipmi/ipmi_msghandler.c                | 422 ++++++++++-----------
 drivers/char/tpm/tpm_tis_core.c                    |   4 +-
 drivers/clk/at91/clk-peripheral.c                  |   7 +-
 drivers/clk/mediatek/clk-mt8195-infra_ao.c         |   2 +-
 drivers/clk/mediatek/clk-mux.c                     |   4 +-
 drivers/clk/nxp/clk-lpc18xx-cgu.c                  |  20 +-
 drivers/clk/tegra/clk-bpmp.c                       |   2 +-
 drivers/clocksource/clps711x-timer.c               |  23 +-
 drivers/cpufreq/intel_pstate.c                     |   8 +-
 drivers/cpufreq/tegra186-cpufreq.c                 |   8 +-
 drivers/cpuidle/governors/menu.c                   |  21 +-
 drivers/crypto/aspeed/aspeed-hace-crypto.c         |   2 +-
 drivers/crypto/atmel-tdes.c                        |   2 +-
 drivers/firmware/meson/meson_sm.c                  |   7 +-
 drivers/gpio/gpio-wcd934x.c                        |   3 +-
 drivers/gpu/drm/amd/display/dc/dce/dce_transform.c |  21 +-
 drivers/gpu/drm/amd/display/dc/dce/dce_transform.h |   4 +
 .../gpu/drm/amd/include/asic_reg/dce/dce_6_0_d.h   |   7 +
 .../drm/amd/include/asic_reg/dce/dce_6_0_sh_mask.h |   2 +
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_validation.c         |   6 +-
 drivers/iio/adc/xilinx-ams.c                       |  47 ++-
 drivers/iio/dac/ad5360.c                           |   2 +-
 drivers/iio/dac/ad5421.c                           |   2 +-
 drivers/iio/frequency/adf4350.c                    |  20 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c   |   4 -
 drivers/iommu/intel/iommu.c                        |   2 +-
 drivers/mailbox/zynqmp-ipi-mailbox.c               |   7 +-
 drivers/media/i2c/mt9v111.c                        |   2 +-
 drivers/media/mc/mc-devnode.c                      |   6 +-
 drivers/media/mc/mc-entity.c                       |   2 +-
 drivers/media/pci/cx18/cx18-queue.c                |  13 +-
 drivers/media/pci/ivtv/ivtv-irq.c                  |   2 +-
 drivers/media/pci/ivtv/ivtv-yuv.c                  |   8 +-
 drivers/media/rc/lirc_dev.c                        |   9 +-
 drivers/memory/samsung/exynos-srom.c               |  10 +-
 drivers/mfd/intel_soc_pmic_chtdc_ti.c              |   5 +-
 drivers/mmc/core/sdio.c                            |   6 +-
 drivers/mtd/nand/raw/fsmc_nand.c                   |   6 +-
 drivers/net/ethernet/freescale/fsl_pq_mdio.c       |   2 +
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   2 +-
 drivers/net/wireless/ath/ath11k/core.c             |   6 +-
 drivers/net/wireless/ath/ath11k/hal.c              |  16 +
 drivers/net/wireless/ath/ath11k/hal.h              |   1 +
 drivers/nvme/host/pci.c                            |   2 +
 drivers/pci/controller/dwc/pci-keystone.c          |   4 +-
 drivers/pci/controller/dwc/pcie-tegra194.c         |  22 +-
 drivers/pci/controller/pci-tegra.c                 |  27 +-
 drivers/pci/controller/pcie-rcar-host.c            |  40 +-
 drivers/pci/endpoint/functions/pci-epf-test.c      |  19 +-
 drivers/pci/iov.c                                  |   5 +
 drivers/pci/pci-driver.c                           |   1 +
 drivers/pci/pci-sysfs.c                            |  20 +-
 drivers/pci/pcie/aer.c                             |  12 +-
 drivers/pci/pcie/err.c                             |   8 +-
 drivers/power/supply/max77976_charger.c            |  12 +-
 drivers/pwm/pwm-berlin.c                           |   4 +-
 drivers/rtc/interface.c                            |  27 ++
 drivers/rtc/rtc-optee.c                            |   1 +
 drivers/rtc/rtc-x1205.c                            |   2 +-
 drivers/s390/cio/device.c                          |  37 +-
 drivers/scsi/hpsa.c                                |  21 +-
 drivers/scsi/mvsas/mv_defs.h                       |   1 +
 drivers/scsi/mvsas/mv_init.c                       |  13 +-
 drivers/scsi/mvsas/mv_sas.c                        |  42 +-
 drivers/scsi/mvsas/mv_sas.h                        |   8 +-
 drivers/spi/spi-cadence-quadspi.c                  |   5 +
 drivers/xen/events/events_base.c                   |  20 +-
 drivers/xen/manage.c                               |   3 +-
 fs/btrfs/export.c                                  |   8 +-
 fs/btrfs/extent_io.c                               |  14 +-
 fs/cramfs/inode.c                                  |  11 +-
 fs/ext4/fsmap.c                                    |  14 +-
 fs/ext4/inode.c                                    |  10 +-
 fs/ext4/orphan.c                                   |  17 +-
 fs/ext4/xattr.c                                    |  15 +-
 fs/file.c                                          |   5 +-
 fs/fs-writeback.c                                  |  32 +-
 fs/fsopen.c                                        |  70 ++--
 fs/minix/inode.c                                   |   8 +-
 fs/namei.c                                         |   8 +
 fs/namespace.c                                     |  11 +-
 fs/nfsd/lockd.c                                    |  15 +
 fs/nfsd/nfs4proc.c                                 |   2 +-
 fs/ntfs3/bitmap.c                                  |   1 +
 fs/smb/server/ksmbd_netlink.h                      |   5 +-
 fs/smb/server/server.h                             |   1 +
 fs/smb/server/transport_ipc.c                      |   3 +
 fs/smb/server/transport_tcp.c                      |  27 +-
 fs/squashfs/inode.c                                |  24 +-
 include/acpi/acpixf.h                              |   6 +
 include/asm-generic/io.h                           | 126 +++---
 include/linux/iio/frequency/adf4350.h              |   2 +-
 include/linux/sched.h                              |  11 +-
 include/media/v4l2-subdev.h                        |  30 +-
 include/scsi/libsas.h                              |  18 +
 include/trace/events/rwmmio.h                      |  43 ++-
 init/main.c                                        |  12 +
 kernel/bpf/inode.c                                 |   4 +-
 kernel/fork.c                                      |   2 +-
 kernel/pid.c                                       |   5 +-
 kernel/rseq.c                                      |  10 +-
 kernel/sched/deadline.c                            |  73 ++--
 kernel/sys.c                                       |  22 +-
 kernel/trace/trace_kprobe.c                        |  11 +-
 kernel/trace/trace_probe.h                         |   9 +-
 kernel/trace/trace_uprobe.c                        |  13 +-
 lib/crypto/Makefile                                |   4 +
 lib/genalloc.c                                     |   5 +-
 lib/trace_readwrite.c                              |  16 +-
 mm/hugetlb.c                                       |   3 +
 mm/page_alloc.c                                    |   2 +-
 net/bridge/br_vlan.c                               |   2 +-
 net/core/filter.c                                  |   2 +
 net/ipv4/tcp_input.c                               |   1 -
 net/mptcp/pm.c                                     |   7 +-
 net/mptcp/pm_netlink.c                             |  55 ++-
 net/mptcp/protocol.h                               |   8 +
 net/sctp/sm_make_chunk.c                           |   3 +-
 net/sctp/sm_statefuns.c                            |   6 +-
 security/keys/trusted-keys/trusted_tpm1.c          |   7 +-
 sound/soc/codecs/wcd934x.c                         |  30 +-
 tools/build/feature/Makefile                       |   4 +-
 tools/lib/perf/include/perf/event.h                |   1 +
 tools/perf/tests/perf-record.c                     |   4 +
 tools/perf/util/arm-spe-decoder/arm-spe-decoder.c  |  30 +-
 tools/perf/util/arm-spe-decoder/arm-spe-decoder.h  |  65 +++-
 tools/perf/util/arm-spe.c                          |  42 +-
 tools/perf/util/evsel.c                            |   2 +
 tools/perf/util/lzma.c                             |   2 +-
 tools/perf/util/session.c                          |   2 +-
 tools/perf/util/zlib.c                             |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  11 +
 tools/testing/selftests/rseq/rseq.c                |   8 +-
 tools/testing/selftests/vm/madv_populate.c         |   9 +-
 tools/testing/selftests/vm/soft-dirty.c            |   5 +-
 tools/testing/selftests/vm/vm_util.c               |  77 ++++
 tools/testing/selftests/vm/vm_util.h               |   2 +
 165 files changed, 1668 insertions(+), 873 deletions(-)


