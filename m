Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAC318B482;
	Tue, 10 Sep 2024 09:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961288; cv=none; b=WOZ4LojLqfUecMhEL+I2r5ZuYC4vWdbvCxBK3LqnzwbyHeIe1VLoa9RleZzkaL2RWjITAU5UEtBhxeRCHNXGQUpV5C02Y1ZgP14Jr624A3+lPcOpeHd95NejWMT6nQaEg8PdERYQ2zhgT5ebftq0SBG+E4YBd7hR9ErQHKFeZ0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961288; c=relaxed/simple;
	bh=FCj3ItmNm9FiSFWb/e9JoTMM4OO5Ok7lhHpgDKDZIHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=m/fGoJ/I0SRNyFxOTYUbX8bqniB3DoZDDJd2yZE3CJToJu7ZpbB4O2CRv+4BghMp8SI5XMeRsMU9Y4rdRK5R9ZsxhIYJW/TqNxjuQ5L5FegFaEvLM4YSOGQv3G9hnPEZuKoIqKbOoLknP7JPTip6ozDTzyAdWHsZfTKRVHm2HDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5avsi9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5avsi9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FEEC4CEC3;
	Tue, 10 Sep 2024 09:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961288;
	bh=FCj3ItmNm9FiSFWb/e9JoTMM4OO5Ok7lhHpgDKDZIHQ=;
	h=From:To:Cc:Subject:Date:From;
	b=C5avsi9gLD41KUqx0JO1hXVkREyzhke4murj5BrVGiyIZA1LZ3iLh3Y7/eNqyYb3A
	 uUpBFM/QFgtPsDOS249QwiI9UKnis1tH05FA/xSKCPIPgoNUxKNolr1lJ9IjG5BPfI
	 2OByNmeGUdupcdrmLk5/wtoXaCZEiC2yqpkEuI5o=
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
	allen.lkml@gmail.com,
	broonie@kernel.org
Subject: [PATCH 6.10 000/375] 6.10.10-rc1 review
Date: Tue, 10 Sep 2024 11:26:37 +0200
Message-ID: <20240910092622.245959861@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.10.10-rc1
X-KernelTest-Deadline: 2024-09-12T09:26+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.10.10 release.
There are 375 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.10-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.10.10-rc1

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Use accessors to page table entries instead of direct dereference

Stefan Wahren <wahrenst@gmx.net>
    spi: spi-fsl-lpspi: Fix off-by-one in prescale max

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race between direct IO write and fsync when using same fd

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/display: Increase Fast Wake Sync length as a quirk

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/display: Add mechanism to use sink model when applying quirk

Thomas Gleixner <tglx@linutronix.de>
    x86/mm: Fix PTI for i386 some more

Li Nan <linan122@huawei.com>
    ublk_drv: fix NULL pointer dereference in ublk_ctrl_start_recovery()

Maurizio Lombardi <mlombard@redhat.com>
    nvmet: Identify-Active Namespace ID List command should reject invalid nsid

Weiwen Hu <huweiwen@linux.alibaba.com>
    nvme: rename CDR/MORE/DNR to NVME_STATUS_*

Weiwen Hu <huweiwen@linux.alibaba.com>
    nvme: fix status magic numbers

Weiwen Hu <huweiwen@linux.alibaba.com>
    nvme: rename nvme_sc_to_pr_err to nvme_status_to_pr_err

David Howells <dhowells@redhat.com>
    cifs: Fix SMB1 readv/writev callback in the same way as SMB2/3

David Howells <dhowells@redhat.com>
    cifs: Fix zero_point init on inode initialisation

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Fix RISCV_ALTERNATIVE_EARLY

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Improve sbi_ecall() code generation by reordering arguments

Samuel Holland <samuel.holland@sifive.com>
    riscv: Add tracepoints for SBI calls and returns

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Do not restrict memory size because of linear mapping on nommu

Anton Blanchard <antonb@tenstorrent.com>
    riscv: Fix toolchain vector detection

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix double put of @cfile in smb2_rename_path()

Liao Chen <liaochen4@huawei.com>
    gpio: modepin: Enable module autoloading

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    gpio: rockchip: fix OF node leak in probe()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    drm/i915/fence: Mark debug_fence_free() with __maybe_unused

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    drm/i915/fence: Mark debug_fence_init_onstack() with __maybe_unused

Dave Airlie <airlied@redhat.com>
    nouveau: fix the fwsec sb verification register.

Stephen Boyd <swboyd@chromium.org>
    clk: qcom: gcc-sm8550: Don't park the USB RCG at registration time

Stephen Boyd <swboyd@chromium.org>
    clk: qcom: gcc-sm8550: Don't use parking clk_ops for QUPs

Matteo Martelli <matteomartelli3@gmail.com>
    ASoC: sunxi: sun4i-i2s: fix LRCLK polarity in i2s mode

Charlie Jenkins <charlie@rivosinc.com>
    riscv: mm: Do not restrict mmap address based on hint

Charlie Jenkins <charlie@rivosinc.com>
    riscv: selftests: Remove mmap hint address checks

Chen-Yu Tsai <wenst@chromium.org>
    ASoc: SOF: topology: Clear SOF link platform name upon unload

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    clk: qcom: gcc-x1e80100: Don't use parking clk_ops for QUPs

Keith Busch <kbusch@kernel.org>
    nvme-pci: allocate tagset on reset if necessary

Maurizio Lombardi <mlombard@redhat.com>
    nvmet-tcp: fix kernel crash if commands allocation fails

Mohan Kumar <mkumard@nvidia.com>
    ASoC: tegra: Fix CBB error during probe()

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/vdso: Don't discard rela sections

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/64e: Define mmu_pte_psize static

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64e: split out nohash Book3E 64-bit code

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64e: remove unused IBM HTW code

devi priya <quic_devipriy@quicinc.com>
    clk: qcom: ipq9574: Update the alpha PLL type for GPLLs

Abel Vesa <abel.vesa@linaro.org>
    clk: qcom: gcc-x1e80100: Fix USB 0 and 1 PHY GDSC pwrsts flags

Bommu Krishnaiah <krishnaiah.bommu@intel.com>
    drm/xe/xe2lpg: Extend workaround 14021402888

Bommu Krishnaiah <krishnaiah.bommu@intel.com>
    drm/xe/xe2: Add workaround 14021402888

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: SHAMPO, Fix page leak

Yoray Zack <yorayz@nvidia.com>
    net/mlx5e: SHAMPO, Use KSMs instead of KLMs

Arnd Bergmann <arnd@arndb.de>
    hid: bpf: add BPF_JIT dependency

Jia Jie Ho <jiajie.ho@starfivetech.com>
    crypto: starfive - Fix nent assignment in rsa dec

Jia Jie Ho <jiajie.ho@starfivetech.com>
    crypto: starfive - Align rsa input data to 32-bit

Igor Pylypiv <ipylypiv@google.com>
    ata: libata-scsi: Check ATA_QCFLAG_RTF_FILLED before using result_tf

Igor Pylypiv <ipylypiv@google.com>
    ata: libata-scsi: Remove redundant sense_buffer memsets

Marek Olšák <marek.olsak@amd.com>
    drm/amdgpu: handle gfx12 in amdgpu_display_verify_sizes

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd: Add gfx12 swizzle mode defs

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: rx: add workaround for erratum DS80000789E 6 of mcp2518fd

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: clarify the meaning of timestamp

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: rx: prepare to workaround broken RX FIFO head index erratum

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: mcp251xfd_handle_rxif_ring_uinc(): factor out in separate function

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    arm64: acpi: Harden get_cpu_for_acpi_id() against missing CPU entry

James Morse <james.morse@arm.com>
    arm64: acpi: Move get_cpu_for_acpi_id() to a header

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    ACPI: processor: Fix memory leaks in error paths of processor_add()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    ACPI: processor: Return an error if acpi_processor_get_info() fails in processor_add()

Christian Brauner <brauner@kernel.org>
    fs: relax permissions for listmount()

Christian Brauner <brauner@kernel.org>
    fs: simplify error handling

Christian Brauner <brauner@kernel.org>
    path: add cleanup helper

Nicholas Piggin <npiggin@gmail.com>
    workqueue: Improve scalability of workqueue watchdog touch

Nicholas Piggin <npiggin@gmail.com>
    workqueue: wq_watchdog_touch is always called with valid CPU

Mike Yuan <me@yhndnzj.com>
    mm/memcontrol: respect zswap.writeback setting from parent cg too

Yosry Ahmed <yosryahmed@google.com>
    mm: zswap: rename is_zswap_enabled() to zswap_is_enabled()

Peter Zijlstra <peterz@infradead.org>
    perf/aux: Fix AUX buffer serialization

Sven Schnelle <svens@linux.ibm.com>
    uprobes: Use kzalloc to allocate xol area

Daniel Lezcano <daniel.lezcano@linaro.org>
    clocksource/drivers/timer-of: Remove percpu irq related code

Jacky Bai <ping.bai@nxp.com>
    clocksource/drivers/imx-tpm: Fix next event not taking effect sometime

Jacky Bai <ping.bai@nxp.com>
    clocksource/drivers/imx-tpm: Fix return -ETIME when delta exceeds INT_MAX

David Fernandez Gonzalez <david.fernandez.gonzalez@oracle.com>
    VMCI: Fix use-after-free when removing resource in vmci_resource_remove()

Naman Jain <namjain@linux.microsoft.com>
    Drivers: hv: vmbus: Fix rescind handling in uio_hv_generic

Saurabh Sengar <ssengar@linux.microsoft.com>
    uio_hv_generic: Fix kernel NULL pointer dereference in hv_uio_rescind

Geert Uytterhoeven <geert+renesas@glider.be>
    nvmem: Fix return type of devm_nvmem_device_get() in kerneldoc

John Thomson <git@johnthomson.fastmail.com.au>
    nvmem: u-boot-env: error if NVMEM device is too small

Michal Simek <michal.simek@amd.com>
    dt-bindings: nvmem: Use soc-nvmem node name instead of nvmem

Carlos Llamas <cmllamas@google.com>
    binder: fix UAF caused by offsets overwrite

Sukrut Bellary <sukrut.bellary@linux.com>
    misc: fastrpc: Fix double free of 'buf' in error path

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: Fix the partner PD revision

Prashanth K <quic_prashk@quicinc.com>
    usb: dwc3: Avoid waking up gadget during startxfer

Pawel Laszczak <pawell@cadence.com>
    usb: cdns2: Fix controller reset issue

Faisal Hassan <quic_faisalh@quicinc.com>
    usb: dwc3: core: update LC timer as per USB Spec V3.2

Dumitru Ceclan <mitrutzceclan@gmail.com>
    iio: adc: ad7124: fix DT configuration parsing

Dumitru Ceclan <mitrutzceclan@gmail.com>
    iio: adc: ad7124: fix chip ID mismatch

Nuno Sa <nuno.sa@analog.com>
    iio: adc: ad_sigma_delta: fix irq_flags on irq request

Guillaume Stols <gstols@baylibre.com>
    iio: adc: ad7606: remove frstdata check for serial mode

Dumitru Ceclan <mitrutzceclan@gmail.com>
    iio: adc: ad7124: fix config comparison

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_mpu6050: fix interrupt status read for old buggy chips

Matteo Martelli <matteomartelli3@gmail.com>
    iio: fix scale application in iio_convert_raw_to_processed_unlocked

David Lechner <dlechner@baylibre.com>
    iio: buffer-dmaengine: fix releasing dma channel on error

Aleksandr Mishin <amishin@t-argos.ru>
    staging: iio: frequency: ad9834: Validate frequency parameter value

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    tcp: process the 3rd ACK with sk_socket for TFO/MPTCP

Christian Brauner <brauner@kernel.org>
    fs: only copy to userspace on success in listmount()

Yunxiang Li <Yunxiang.Li@amd.com>
    drm/amdgpu: Fix amdgpu_device_reset_sriov retry logic

Yunxiang Li <Yunxiang.Li@amd.com>
    drm/amdgpu: Add reset_context flag for host FLR

Yunxiang Li <Yunxiang.Li@amd.com>
    drm/amdgpu: Fix two reset triggered in a row

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Add missing rescheduling points in nfs_client_return_marked_delegations

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/server: fix potential null-ptr-deref of lease_ctx_info in smb2_open()

Michael Ellerman <mpe@ellerman.id.au>
    ata: pata_macio: Use WARN instead of BUG

Carlos Song <carlos.song@nxp.com>
    spi: spi-fsl-lpspi: limit PRESCALE bit in TCR register

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: cevt-r4k: Don't call get_c0_compare_int if timer irq is installed

Ivan Orlov <ivan.orlov0322@gmail.com>
    kunit/overflow: Fix UB in overflow_allocation_test

Peiyang Wang <wangpeiyang1@huawei.com>
    net: hns3: void array out of bound when loop tnl_num

Kent Overstreet <kent.overstreet@linux.dev>
    lib/generic-radix-tree.c: Fix rare race in __genradix_ptr_alloc()

Stefan Wiehler <stefan.wiehler@nokia.com>
    of/irq: Prevent device address out-of-bounds read in interrupt map walk

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: sanity check symbolic link size

Oliver Neukum <oneukum@suse.com>
    usbnet: ipheth: race between ipheth_close and error handling

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: uinput - reject requests with unreasonable number of slots

Olivier Sobrie <olivier@sobrie.be>
    HID: amd_sfh: free driver_data after destroying hid device

Camila Alvarez <cam.alvarez.i@gmail.com>
    HID: cougar: fix slab-out-of-bounds Read in cougar_report_fixup

Heiko Carstens <hca@linux.ibm.com>
    s390/vmlinux.lds.S: Move ro_after_init section behind rodata section

David Sterba <dsterba@suse.com>
    btrfs: initialize location to fix -Wmaybe-uninitialized in btrfs_lookup_dentry()

Devyn Liu <liudingyuan@huawei.com>
    spi: hisi-kunpeng: Add verification for the max_frequency provided by the firmware

Zenghui Yu <yuzenghui@huawei.com>
    kselftests: dmabuf-heaps: Ensure the driver name is null-terminated

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i3c: mipi-i3c-hci: Error out instead on BUG_ON() in IBI DMA setup

Frank Li <Frank.Li@nxp.com>
    i3c: master: svc: resend target address when get NACK

David Howells <dhowells@redhat.com>
    vfs: Fix potential circular locking through setxattr() and removexattr()

David Howells <dhowells@redhat.com>
    cachefiles: Set the max subreq size for cache writes to MAX_RW_COUNT

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/boot: Do not assume the decompressor range is reserved

Arnd Bergmann <arnd@arndb.de>
    regmap: maple: work around gcc-14.1 false-positive warning

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Use correct API to map cmdline in relocate_kernel()

YiPeng Chai <YiPeng.Chai@amd.com>
    drm/amdgpu: add mutex to protect ras shared memory

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dpaa: avoid on-stack arrays of NR_CPUS elements

Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
    Bluetooth: btnxpuart: Fix Null pointer dereference in btnxpuart_flush()

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Don't drop SYN+ACK for simultaneous connect().

Dan Williams <dan.j.williams@intel.com>
    PCI: Add missing bridge lock to pci_bus_lock()

yang.zhang <yang.zhang@hexintek.com>
    riscv: set trap vector earlier

Alison Schofield <alison.schofield@intel.com>
    cxl/region: Verify target positions using the ordered target list

Jakub Kicinski <kuba@kernel.org>
    ethtool: fail closed if we can't get max channel used in indirection tables

Filipe Manana <fdmanana@suse.com>
    btrfs: don't BUG_ON() when 0 reference count at btrfs_lookup_extent_info()

Filipe Manana <fdmanana@suse.com>
    btrfs: replace BUG_ON() with error handling at update_ref_for_cow()

Josef Bacik <josef@toxicpanda.com>
    btrfs: handle errors from btrfs_dec_ref() properly

Josef Bacik <josef@toxicpanda.com>
    btrfs: clean up our handling of refs == 0 in snapshot delete

Josef Bacik <josef@toxicpanda.com>
    btrfs: replace BUG_ON with ASSERT in walk_down_proc()

Josef Bacik <josef@toxicpanda.com>
    btrfs: don't BUG_ON on ENOMEM from btrfs_lookup_extent_info() in walk_down_proc()

Qu Wenruo <wqu@suse.com>
    btrfs: slightly loosen the requirement for qgroup removal

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Check more cases when directory is corrupted

Zqiang <qiang.zhang1211@gmail.com>
    smp: Add missing destroy_work_on_stack() call in smp_call_on_cpu()

Christian König <christian.koenig@amd.com>
    drm/amdgpu: reject gang submit on reserved VMIDs

Sascha Hauer <s.hauer@pengutronix.de>
    watchdog: imx7ulp_wdt: keep already running watchdog enabled

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    bpf: Remove tst_run from lwt_seg6local_prog_ops.

Jason Gunthorpe <jgg@ziepe.ca>
    iommufd: Require drivers to supply the cache_invalidate_user ops

Umang Jain <umang.jain@ideasonboard.com>
    staging: vchiq_core: Bubble up wait_event_interruptible() return value

Mrinmay Sarkar <quic_msarkar@quicinc.com>
    PCI: qcom: Override NO_SNOOP attribute for SA8775P RC

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Hide Topdown metrics events if the feature is not enumerated

Sascha Hauer <s.hauer@pengutronix.de>
    wifi: mwifiex: Do not return unused priv in mwifiex_get_priv_by_id()

Yicong Yang <yangyicong@hisilicon.com>
    dma-mapping: benchmark: Don't starve others when doing the test

Ye Bin <yebin10@huawei.com>
    jbd2: avoid mount failed when commit block is partial submitted

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: fix possible tid_t sequence overflows

Yifan Zha <Yifan.Zha@amd.com>
    drm/amdgpu: Set no_hw_access when VF request full GPU fails

Andreas Ziegler <ziegler.andreas@siemens.com>
    libbpf: Add NULL checks to bpf_object__{prev_map,next_map}

Shenghao Ding <shenghao-ding@ti.com>
    ASoc: TAS2781: replace beXX_to_cpup with get_unaligned_beXX for potentially broken alignment

Guenter Roeck <linux@roeck-us.net>
    hwmon: (w83627ehf) Fix underflows seen when writing limit attributes

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nct6775-core) Fix underflows seen when writing limit attributes

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm95234) Fix underflows seen when writing limit attributes

Guenter Roeck <linux@roeck-us.net>
    hwmon: (adc128d818) Fix underflows seen when writing limit attributes

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/kprobes: Add symbol counting check when module loads

Hareshx Sankar Raj <hareshx.sankar.raj@intel.com>
    crypto: qat - fix unintentional re-enabling of error interrupts

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Handle mailbox timeouts in lpfc_get_sfp_info

Igor Pylypiv <ipylypiv@google.com>
    scsi: pm80xx: Set phy->enable_completion only when we wait for it

Kyoungrul Kim <k831.kim@samsung.com>
    scsi: ufs: core: Remove SCSI host only if added

Marcin Ślusarz <mslusarz@renau.com>
    wifi: rtw88: usb: schedule rx work after everything is set up

Xuan Zhuo <xuanzhuo@linux.alibaba.com>
    virtio_ring: fix KMSAN error for premapped mode

Krishna Kumar <krishnak@linux.ibm.com>
    pci/hotplug/pnv_php: Fix hotplug driver crash on Powernv

Zijun Hu <quic_zijuhu@quicinc.com>
    devres: Initialize an uninitialized struct member

Johannes Berg <johannes.berg@intel.com>
    um: line: always fill *error_out in setup_one_line()

Waiman Long <longman@redhat.com>
    cgroup: Protect css->cgroup write under css_set_lock

Christoph Hellwig <hch@lst.de>
    block: don't call bio_uninit from bio_endio

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Remove control over Execute-Requested requests

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Handle volatile descriptor status read

Huang Ying <ying.huang@intel.com>
    cxl/region: Fix a race condition in memory hotplug notifier

Benjamin Marzinski <bmarzins@redhat.com>
    dm init: Handle minors larger than 255

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: topology: Properly initialize soc_enum values

Sean Anderson <sean.anderson@linux.dev>
    phy: zynqmp: Take the phy mutex in xlate

Richard Fitzgerald <rf@opensource.cirrus.com>
    firmware: cs_dsp: Don't allow writes to read-only controls

Viresh Kumar <viresh.kumar@linaro.org>
    xen: privcmd: Fix possible access to a freed kirqfd instance

Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
    tools/net/ynl: fix cli.py --subscribe feature

Jamie Bainbridge <jamie.bainbridge@gmail.com>
    selftests: net: enable bind tests

Pawel Dembicki <paweldembicki@gmail.com>
    net: dsa: vsc73xx: fix possible subblocks range of CAPT block

Sean Anderson <sean.anderson@linux.dev>
    net: xilinx: axienet: Fix race in axienet_stop

Jonas Gorski <jonas.gorski@bisdn.de>
    net: bridge: br_fdb_external_learn_add(): always set EXT_LEARN

Hayes Wang <hayeswang@realtek.com>
    r8152: fix the firmware doesn't work

Kuniyuki Iwashima <kuniyu@amazon.com>
    fou: Fix null-ptr-deref in GRO.

Guillaume Nault <gnault@redhat.com>
    bareudp: Fix device stats updates.

Jeongjun Park <aha310510@gmail.com>
    bpf: add check for invalid name in btf_name_valid_section()

Tze-nan Wu <Tze-nan.Wu@mediatek.com>
    bpf, net: Fix a potential race in do_sock_getsockopt()

Breno Leitao <leitao@debian.org>
    net: dqs: Do not use extern for unused dql_group

Oliver Neukum <oneukum@suse.com>
    usbnet: modern method to get random MAC

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: do not bring the VSI up, if it was down before the XDP setup

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: remove ICE_CFG_BUSY locking from AF_XDP code

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: check ICE_VSI_DOWN under rtnl_lock when preparing for reset

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: protect XDP configuration with a mutex

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: move netif_queue_set_napi to rtnl-protected sections

Vadim Fedorenko <vadim.fedorenko@linux.dev>
    ptp: ocp: adjust sysfs entries to expose tty information

Vadim Fedorenko <vadim.fedorenko@linux.dev>
    ptp: ocp: convert serial ports to array

Jinjie Ruan <ruanjinjie@huawei.com>
    net: phy: Fix missing of_node_put() for leds

Roger Quadros <rogerq@kernel.org>
    net: ethernet: ti: am65-cpsw: Fix RX statistics for XDP_TX and XDP_REDIRECT

Namhyung Kim <namhyung@kernel.org>
    perf lock contention: Fix spinlock and rwlock accounting

Armin Wolf <W_Armin@gmx.de>
    hwmon: (hp-wmi-sensors) Check if WMI event data exists

Dan Carpenter <dan.carpenter@linaro.org>
    igc: Unlock on error in igc_io_resume()

Marc Zyngier <maz@kernel.org>
    scripts: fix gfp-translate after ___GFP_*_BITS conversion to an enum

Pawel Dembicki <paweldembicki@gmail.com>
    hwmon: ltc2991: fix register bits defines

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix not generating command complete for MGMT_OP_DISCONNECT

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Introduce hci_cmd_sync_run/hci_cmd_sync_run_once

Douglas Anderson <dianders@chromium.org>
    Bluetooth: qca: If memdump doesn't work, re-enable IBS

Martin Jocic <martin.jocic@kvaser.com>
    can: kvaser_pciefd: Use a single write when releasing RX buffers

Martin Jocic <martin.jocic@kvaser.com>
    can: kvaser_pciefd: Move reset of DMA RX buffers to the end of the ISR

Martin Jocic <martin.jocic@kvaser.com>
    can: kvaser_pciefd: Rename board_irq to pci_irq

Martin Jocic <martin.jocic@kvaser.com>
    can: kvaser_pciefd: Remove unnecessary comment

Martin Jocic <martin.jocic@kvaser.com>
    can: kvaser_pciefd: Skip redundant NULL pointer check in ISR

Douglas Anderson <dianders@chromium.org>
    regulator: core: Stub devm_regulator_bulk_get_const() if !CONFIG_REGULATOR

Charles Han <hanchunchao@inspur.com>
    spi: intel: Add check devm_kasprintf() returned value

Aleksandr Mishin <amishin@t-argos.ru>
    platform/x86: dell-smbios: Fix error path in dell_smbios_init()

Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
    ice: Add netif_device_attach/detach into PF reset flow

Daiwei Li <daiweili@google.com>
    igb: Fix not clearing TimeSync interrupts for 82580

David Howells <dhowells@redhat.com>
    cifs: Fix FALLOC_FL_ZERO_RANGE to preflush buffered part of target region

David Howells <dhowells@redhat.com>
    cifs: Fix copy offload to flush destination region

David Howells <dhowells@redhat.com>
    netfs, cifs: Fix handling of short DIO read

David Howells <dhowells@redhat.com>
    cifs: Fix lack of credit renegotiation on read retry

Andreas Hindborg <a.hindborg@samsung.com>
    rust: kbuild: fix export of bss symbols

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: fix ring configuration when switching from CAN-CC to CAN-FD mode

Markus Schneider-Pargmann <msp@baylibre.com>
    can: m_can: Reset cached active_interrupts on start

Markus Schneider-Pargmann <msp@baylibre.com>
    can: m_can: disable_all_interrupts, not clear active_interrupts

Markus Schneider-Pargmann <msp@baylibre.com>
    can: m_can: Do not cancel timer from within timer

Markus Schneider-Pargmann <msp@baylibre.com>
    can: m_can: Remove m_can_rx_peripheral indirection

Markus Schneider-Pargmann <msp@baylibre.com>
    can: m_can: Remove coalesing disable in isr during suspend

Markus Schneider-Pargmann <msp@baylibre.com>
    can: m_can: Reset coalescing during suspend/resume

Simon Horman <horms@kernel.org>
    can: m_can: Release irq on error in m_can_open

Kuniyuki Iwashima <kuniyu@amazon.com>
    can: bcm: Remove proc entry when dev is unregistered.

Marek Olšák <marek.olsak@amd.com>
    drm/amdgpu/display: handle gfx12 in amdgpu_dm_plane_format_mod_supported

Hawking Zhang <Hawking.Zhang@amd.com>
    drm/amdgpu: Correct register used to clear fault status

Marek Olšák <marek.olsak@amd.com>
    drm/amdgpu: check for LINEAR_ALIGNED correctly in check_tiling_flags_gfx6

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check denominator crb_pipes before used

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check denominator pbn_div before used

Jules Irenge <jbi.octave@gmail.com>
    pcmcia: Use resource_size function on resource object

Chen Ni <nichen@iscas.ac.cn>
    media: qcom: camss: Add check for v4l2_fwnode_endpoint_parse

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ili210x - use kvmalloc() to allocate buffer for firmware update

Kishon Vijay Abraham I <kishon@kernel.org>
    PCI: keystone: Add workaround for Errata #i2037 (AM65x SR 1.0)

Eric Joyner <eric.joyner@intel.com>
    ice: Check all ice_vsi_rebuild() errors in function

Andrei Vagin <avagin@google.com>
    seccomp: release task filters when the task exits

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/rtas: Prevent Spectre v1 gadget construction in sys_rtas()

Christian Brauner <brauner@kernel.org>
    fs: relax permissions for statmount()

Christian Brauner <brauner@kernel.org>
    fs: don't copy to userspace under namespace semaphore

Shivaprasad G Bhat <sbhat@linux.ibm.com>
    vfio/spapr: Always clear TCEs before unsetting the window

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vivid: don't set HDMI TX controls if there are no HDMI outputs

Jiwei Sun <sunjw10@lenovo.com>
    crypto: qat - initialize user_input.lock for rate_limiting

Danijel Slivka <danijel.slivka@amd.com>
    drm/amdgpu: clear RB_OVERFLOW bit when enabling interrupts

Hawking Zhang <Hawking.Zhang@amd.com>
    drm/amdgpu: Fix smatch static checker warning

Bob Zhou <bob.zhou@amd.com>
    drm/amdgpu: add missing error handling in function amdgpu_gmc_flush_gpu_tlb_pasid

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Validate function returns

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check HDCP returned status

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Run DC_LOG_DC after checking link->link_enc

Hawking Zhang <Hawking.Zhang@amd.com>
    drm/amdgpu: Fix register access violation

Ma Ke <make24@iscas.ac.cn>
    usb: gadget: aspeed_udc: validate endpoint index for ast udc

Shantanu Goel <sgoel01@yahoo.com>
    usb: uas: set host status byte on data completion error

Chih-Kang Chang <gary.chang@realtek.com>
    wifi: rtw89: wow: prevent to send unexpected H2C during download Firmware

Arend van Spriel <arend.vanspriel@broadcom.com>
    wifi: brcmsmac: advertise MFP_CAPABLE to enable WPA3

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    leds: spi-byte: Call of_node_put() on error path

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vivid: fix wrong sizeimage value for mplane

Samuel Holland <samuel.holland@sifive.com>
    riscv: kprobes: Use patch_text_nosync() for insn slots

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: One more reason to mark inode bad

Jan Kara <jack@suse.cz>
    udf: Avoid excessive partition lengths

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: use IWL_FW_CHECK for link ID check

Ziwei Xiao <ziweixiao@google.com>
    gve: Add adminq mutex lock

Yunjian Wang <wangyunjian@huawei.com>
    netfilter: nf_conncount: fix wrong variable type

Jernej Skrabec <jernej.skrabec@gmail.com>
    iommu: sun50i: clear bypass register

Brian Johannesmeyer <bjohannesmeyer@gmail.com>
    x86/kmsan: Fix hook for unaligned accesses

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Remove put_pid()/put_cred() in copy_peercred().

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: b2c2: flexcop-usb: fix flexcop_usb_memory_req

Pali Rohár <pali@kernel.org>
    irqchip/armada-370-xp: Do not allow mapping IRQ 0 and 1

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    irqchip/renesas-rzg2l: Reorder function calls in rzg2l_irqc_irq_disable()

Rakesh Ughreja <rughreja@habana.ai>
    accel/habanalabs/gaudi2: unsecure edma max outstanding register

Alexey Dobriyan <adobriyan@gmail.com>
    ELF: fix kernel.randomize_va_space double read

Leon Hwang <hffilwlqm@gmail.com>
    bpf, verifier: Correct tail_call_reachable for bpf prog

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    virt: sev-guest: Mark driver struct with __refdata to prevent section mismatch

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Delay setting of CS_CPU_EXCLUSIVE until valid partition

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check UnboundedRequestEnabled's value

Konstantin Andreev <andreev@swemel.ru>
    smack: unix sockets: fix accept()ed socket label

Ajith C <quic_ajithc@quicinc.com>
    wifi: ath12k: fix firmware crash due to invalid peer nss

Aaradhana Sahu <quic_aarasahu@quicinc.com>
    wifi: ath12k: fix uninitialize symbol error on ath12k_peer_assoc_h_he()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Add input value sanity checks to HDMI channel map controls

Takashi Iwai <tiwai@suse.de>
    ALSA: control: Apply sanity check of input values for user elements

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    ALSA: hda/realtek: extend quirks for Clevo V5[46]0

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: Lock DC and exit IPS when changing backlight

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/i915: Do not attempt to load the GSC multiple times

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: always allocate cleared VRAM for GEM allocations

Matt Coster <matt.coster@imgtec.com>
    drm/imagination: Free pvr_vm_gpuva after unlink

Mary Guillemard <mary.guillemard@collabora.com>
    drm/panthor: Restrict high priorities on group_create

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panthor: flush FW AS caches in slow reset path

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/xe/gsc: Do not attempt to load the GSC multiple times

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: handle broken write pointer on zones

Fedor Pchelkin <pchelkin@ispras.ru>
    btrfs: qgroup: don't use extent changeset when not needed

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix state management in error path of log writing function

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: protect references to superblock parameters exposed in sysfs

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix missing cleanup on rollforward recovery error

Toke Høiland-Jørgensen <toke@redhat.com>
    sched: sch_cake: fix bulk flow accounting logic for host fairness

Eric Dumazet <edumazet@google.com>
    ila: call nf_unregister_net_hooks() sooner

Cong Wang <cong.wang@bytedance.com>
    tcp_bpf: fix return value of tcp_bpf_sendmsg()

Baochen Qiang <quic_bqiang@quicinc.com>
    Revert "wifi: ath11k: support hibernation"

Baochen Qiang <quic_bqiang@quicinc.com>
    Revert "wifi: ath11k: restore country code during resume"

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/amdgpu: align pp_power_profile_mode with kernel docs"

Yuntao Wang <yuntao.wang@linux.dev>
    x86/apic: Make x2apic_disable() work correctly

Mitchell Levy <levymitchell0@gmail.com>
    x86/fpu: Avoid writing LBR bit to IA32_XSS unless supported

Matt Johnston <matt@codeconstruct.com.au>
    net: mctp-serial: Fix missing escapes on transmit

Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>
    net: mana: Fix error handling in mana_create_txq/rxq's NAPI cleanup

Steven Rostedt <rostedt@goodmis.org>
    eventfs: Use list_del_rcu() for SRCU protected list variable

Baokun Li <libaokun1@huawei.com>
    fscache: delete fscache_cookie_lru_timer when fscache exits to avoid UAF

Jann Horn <jannh@google.com>
    userfaultfd: fix checks for huge PMDs

Jann Horn <jannh@google.com>
    userfaultfd: don't BUG_ON() if khugepaged yanks our page table

Steven Rostedt <rostedt@goodmis.org>
    tracing/timerlat: Add interface_lock around clearing of kthread in stop_kthread()

Zheng Yejian <zhengyejian@huaweicloud.com>
    tracing: Avoid possible softlockup in tracing_iter_reset()

Steven Rostedt <rostedt@goodmis.org>
    tracing/timerlat: Only clear timer if a kthread exists

Steven Rostedt <rostedt@goodmis.org>
    tracing/osnoise: Use a cpumask to know what threads are kthreads

Brian Norris <briannorris@chromium.org>
    spi: rockchip: Resolve unbalanced runtime PM / system PM handling

Usama Arif <usamaarif642@gmail.com>
    Revert "mm: skip CMA pages when they are not available"

Hao Ge <gehao@kylinos.cn>
    mm/slub: add check for s->flags in the alloc_tagging_slab_free_hook

Will Deacon <will@kernel.org>
    mm: vmalloc: ensure vmap_block is initialised before adding to queue

Petr Tesarik <ptesarik@suse.com>
    kexec_file: fix elfcorehdr digest exclusion when CONFIG_CRASH_HOTPLUG=y

Liam R. Howlett <Liam.Howlett@Oracle.com>
    maple_tree: remove rcu_read_lock() from mt_validate()

Hao Ge <gehao@kylinos.cn>
    codetag: debug: mark codetags for poisoned page as empty

Suren Baghdasaryan <surenb@google.com>
    alloc_tag: fix allocation tag reporting when CONFIG_MODULES=n

Adrian Huang <ahuang12@lenovo.com>
    mm: vmalloc: optimize vmap_lazy_nr arithmetic when purging each vmap_area

Simon Arlott <simon@octiron.net>
    can: mcp251x: fix deadlock if an interrupt occurs during mcp251x_open

Stephan Gerhold <stephan.gerhold@linaro.org>
    pinctrl: qcom: x1e80100: Bypass PDC wakeup parent for now

Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
    clk: qcom: clk-alpha-pll: Update set_rate for Zonda PLL

Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
    clk: qcom: clk-alpha-pll: Fix zonda set_rate failure when PLL is disabled

Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
    clk: qcom: clk-alpha-pll: Fix the trion pll postdiv set rate API

Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
    clk: qcom: clk-alpha-pll: Fix the pll post div mask

Xingyu Wu <xingyu.wu@starfivetech.com>
    clk: starfive: jh7110-sys: Add notifier for PLL0 clock

Helge Deller <deller@gmx.de>
    parisc: Delay write-protection until mark_rodata_ro() call

Samuel Holland <samuel.holland@sifive.com>
    riscv: misaligned: Restrict user access to kernel memory

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: Boards: Fix NULL pointer deref in BYT/CHT boards harder

Miklos Szeredi <mszeredi@redhat.com>
    fuse: clear PG_uptodate when using a stolen page

yangyun <yangyun50@huawei.com>
    fuse: fix memory leak in fuse_create_open

Jann Horn <jannh@google.com>
    fuse: use unsigned type for getxattr/listxattr size truncation

Joanne Koong <joannelkoong@gmail.com>
    fuse: check aborted connection before adding requests to pending list for resending

Bernd Schubert <bschubert@ddn.com>
    fuse: disable the combination of passthrough and writeback cache

Joanne Koong <joannelkoong@gmail.com>
    fuse: update stats for pages in dropped aux writeback list

Seunghwan Baek <sh8267.baek@samsung.com>
    mmc: cqhci: Fix checking of CQHCI_HALT state

Liao Chen <liaochen4@huawei.com>
    mmc: sdhci-of-aspeed: fix module autoloading

Sam Protsenko <semen.protsenko@linaro.org>
    mmc: dw_mmc: Fix IDMAC operation with pages bigger than 4K

Jonathan Bell <jonathan@raspberrypi.com>
    mmc: core: apply SD quirks earlier during probe

Muhammad Usama Anjum <usama.anjum@collabora.com>
    selftests: mm: fix build errors on armhf

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Ignore keys being loaded with invalid type

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Revert "Bluetooth: MGMT/SMP: Fix address type when using SMP over BREDR/LE"

Boqun Feng <boqun.feng@gmail.com>
    rust: macros: provide correct provenance when constructing THIS_MODULE

Georg Gottleuber <ggo@tuxedocomputers.com>
    nvme-pci: Add sleep quirk for Samsung 990 Evo

Dan Carpenter <dan.carpenter@linaro.org>
    irqchip/riscv-aplic: Fix an IS_ERR() vs NULL bug in probe()

Roland Xu <mu001999@outlook.com>
    rtmutex: Drop rt_mutex::wait_lock before scheduling

Thomas Gleixner <tglx@linutronix.de>
    x86/kaslr: Expose and use the end of the physical memory address space

Anup Patel <apatel@ventanamicro.com>
    irqchip/sifive-plic: Probe plic driver early for Allwinner D1 platform

Ma Ke <make24@iscas.ac.cn>
    irqchip/gic-v2m: Fix refcount leak in gicv2m_of_init()

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Limit the period on Haswell

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    x86/tdx: Fix data leak in mmio_read()

Zheng Qixing <zhengqixing@huawei.com>
    ata: libata: Fix memory leak for error path in ata_host_alloc()

Dan Carpenter <dan.carpenter@linaro.org>
    ksmbd: Unlock on in ksmbd_tcp_set_interfaces()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: unset the binding mark of a reused connection

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix double put of @cfile in smb2_set_path_size()

Nysal Jan K.A. <nysal@linux.ibm.com>
    powerpc/qspinlock: Fix deadlock in MCS queue

Maximilien Perreault <maximilienperreault@gmail.com>
    ALSA: hda/realtek: Support mute LED on HP Laptop 14-dq2xxx

Vasiliy Kovalev <kovalev@altlinux.org>
    ALSA: hda/realtek - Fix inactive headset mic jack for ASUS Vivobook 15 X1504VAP

Adam Queler <queler+k@gmail.com>
    ALSA: hda/realtek: Enable Mute Led for HP Victus 15-fb1xxx

Terry Cheong <htcheong@chromium.org>
    ALSA: hda/realtek: add patch for internal mic in Lenovo V145

Christoffer Sandberg <cs@tuxedo.de>
    ALSA: hda/conexant: Add pincfg quirk to enable top speakers on Sirius devices

Ravi Bangoria <ravi.bangoria@amd.com>
    KVM: SVM: Don't advertise Bus Lock Detect to guest if SVM support is missing

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: SVM: fix emulation of msr reads/writes of MSR_FS_BASE and MSR_GS_BASE

Sean Christopherson <seanjc@google.com>
    KVM: x86: Acquire kvm->srcu when handling KVM_SET_VCPU_EVENTS

robelin <robelin@nvidia.com>
    ASoC: dapm: Fix UAF for snd_soc_pcm_runtime object

Roger Quadros <rogerq@kernel.org>
    net: ethernet: ti: am65-cpsw: fix XDP_DROP, XDP_TX and XDP_REDIRECT

Jens Emil Schulz Østergaard <jensemil.schulzostergaard@microchip.com>
    net: microchip: vcap: Fix use-after-free error in kunit test

Roger Quadros <rogerq@kernel.org>
    net: ethernet: ti: am65-cpsw: Fix NULL dereference on XDP_TX

Dave Chinner <dchinner@redhat.com>
    xfs: xfs_finobt_count_blocks() walks the wrong btree

Stephen Hemminger <stephen@networkplumber.org>
    sch/netem: fix use after free in netem_dequeue

Christian Brauner <brauner@kernel.org>
    libfs: fix get_stashed_dentry()


-------------

Diffstat:

 Documentation/admin-guide/cgroup-v2.rst            |  15 +-
 .../bindings/nvmem/xlnx,zynqmp-nvmem.yaml          |   2 +-
 Makefile                                           |   4 +-
 arch/arm64/include/asm/acpi.h                      |  12 +
 arch/arm64/kernel/acpi_numa.c                      |  11 -
 arch/loongarch/include/asm/hugetlb.h               |   4 +-
 arch/loongarch/include/asm/kfence.h                |   6 +-
 arch/loongarch/include/asm/pgtable.h               |  50 +--
 arch/loongarch/kernel/relocate.c                   |   4 +-
 arch/loongarch/kvm/mmu.c                           |   8 +-
 arch/loongarch/mm/hugetlbpage.c                    |   6 +-
 arch/loongarch/mm/init.c                           |  10 +-
 arch/loongarch/mm/kasan_init.c                     |  10 +-
 arch/loongarch/mm/pgtable.c                        |   2 +-
 arch/mips/kernel/cevt-r4k.c                        |  15 +-
 arch/parisc/mm/init.c                              |  16 +-
 arch/powerpc/include/asm/nohash/mmu-e500.h         |   3 +-
 arch/powerpc/kernel/rtas.c                         |   4 +
 arch/powerpc/kernel/vdso/vdso32.lds.S              |   4 +-
 arch/powerpc/kernel/vdso/vdso64.lds.S              |   4 +-
 arch/powerpc/lib/qspinlock.c                       |  10 +-
 arch/powerpc/mm/nohash/Makefile                    |   2 +-
 arch/powerpc/mm/nohash/tlb.c                       | 398 +--------------------
 arch/powerpc/mm/nohash/tlb_64e.c                   | 361 +++++++++++++++++++
 arch/powerpc/mm/nohash/tlb_low_64e.S               | 195 ----------
 arch/riscv/Kconfig                                 |   4 +-
 arch/riscv/include/asm/processor.h                 |  26 +-
 arch/riscv/include/asm/sbi.h                       |  30 +-
 arch/riscv/include/asm/trace.h                     |  54 +++
 arch/riscv/kernel/Makefile                         |   6 +-
 arch/riscv/kernel/head.S                           |   3 +
 arch/riscv/kernel/probes/kprobes.c                 |   5 +-
 arch/riscv/kernel/sbi.c                            |  56 ---
 arch/riscv/kernel/sbi_ecall.c                      |  48 +++
 arch/riscv/kernel/traps_misaligned.c               |   4 +-
 arch/riscv/mm/init.c                               |   2 +-
 arch/s390/boot/startup.c                           |   8 +-
 arch/s390/kernel/vmlinux.lds.S                     |  17 +-
 arch/um/drivers/line.c                             |   2 +
 arch/x86/coco/tdx/tdx.c                            |   1 -
 arch/x86/events/intel/core.c                       |  57 ++-
 arch/x86/include/asm/fpu/types.h                   |   7 +
 arch/x86/include/asm/page_64.h                     |   1 +
 arch/x86/include/asm/pgtable_64_types.h            |   4 +
 arch/x86/kernel/apic/apic.c                        |  11 +-
 arch/x86/kernel/fpu/xstate.c                       |   3 +
 arch/x86/kernel/fpu/xstate.h                       |   4 +-
 arch/x86/kvm/svm/svm.c                             |  15 +
 arch/x86/kvm/x86.c                                 |   2 +
 arch/x86/lib/iomem.c                               |   5 +-
 arch/x86/mm/init_64.c                              |   4 +
 arch/x86/mm/kaslr.c                                |  34 +-
 arch/x86/mm/pti.c                                  |  45 ++-
 block/bio.c                                        |  14 +-
 drivers/accel/habanalabs/gaudi2/gaudi2_security.c  |   1 +
 drivers/acpi/acpi_processor.c                      |  15 +-
 drivers/android/binder.c                           |   1 +
 drivers/ata/libata-core.c                          |   4 +-
 drivers/ata/libata-scsi.c                          |  24 +-
 drivers/ata/pata_macio.c                           |   7 +-
 drivers/base/devres.c                              |   1 +
 drivers/base/regmap/regcache-maple.c               |   3 +-
 drivers/block/ublk_drv.c                           |   2 +
 drivers/bluetooth/btnxpuart.c                      |  12 +-
 drivers/bluetooth/hci_qca.c                        |   1 +
 drivers/clk/qcom/clk-alpha-pll.c                   |  25 +-
 drivers/clk/qcom/clk-rcg.h                         |   1 +
 drivers/clk/qcom/clk-rcg2.c                        |  30 ++
 drivers/clk/qcom/gcc-ipq9574.c                     |  12 +-
 drivers/clk/qcom/gcc-sm8550.c                      |  54 +--
 drivers/clk/qcom/gcc-x1e80100.c                    |  52 +--
 drivers/clk/starfive/clk-starfive-jh7110-sys.c     |  31 +-
 drivers/clk/starfive/clk-starfive-jh71x0.h         |   2 +
 drivers/clocksource/timer-imx-tpm.c                |  16 +-
 drivers/clocksource/timer-of.c                     |  17 +-
 drivers/clocksource/timer-of.h                     |   1 -
 .../crypto/intel/qat/qat_common/adf_gen2_pfvf.c    |   4 +-
 drivers/crypto/intel/qat/qat_common/adf_rl.c       |   1 +
 .../intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c  |   8 +-
 drivers/crypto/starfive/jh7110-cryp.h              |   4 +-
 drivers/crypto/starfive/jh7110-rsa.c               |  15 +-
 drivers/cxl/core/region.c                          |  24 +-
 drivers/firmware/cirrus/cs_dsp.c                   |   3 +
 drivers/gpio/gpio-rockchip.c                       |   1 +
 drivers/gpio/gpio-zynqmp-modepin.c                 |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |  15 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  79 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c        |  30 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c            |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c            |  15 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.h            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            | 123 ++++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c         |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_reset.h          |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c           |   6 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/gfxhub_v1_2.c           |   8 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |   3 +-
 drivers/gpu/drm/amd/amdgpu/ih_v6_0.c               |  28 ++
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c            |   8 +-
 drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c              |   3 +-
 drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c              |   3 +-
 drivers/gpu/drm/amd/amdgpu/mxgpu_vi.c              |   3 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  15 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c    |  47 +--
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c       |   7 +-
 .../gpu/drm/amd/display/dc/dcn20/dcn20_hubbub.c    |   3 +-
 .../drm/amd/display/dc/dml2/display_mode_core.c    |   2 +-
 drivers/gpu/drm/amd/display/dc/link/link_factory.c |   6 +-
 .../display/dc/link/protocols/link_dp_training.c   |   3 +-
 .../display/dc/resource/dcn315/dcn315_resource.c   |   2 +-
 .../drm/amd/display/modules/hdcp/hdcp1_execution.c |  15 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   6 +-
 drivers/gpu/drm/i915/display/intel_display_types.h |   4 +
 drivers/gpu/drm/i915/display/intel_dp.c            |   4 +
 drivers/gpu/drm/i915/display/intel_dp_aux.c        |  16 +-
 drivers/gpu/drm/i915/display/intel_dp_aux.h        |   2 +-
 drivers/gpu/drm/i915/display/intel_psr.c           |   2 +-
 drivers/gpu/drm/i915/display/intel_quirks.c        |  68 ++++
 drivers/gpu/drm/i915/display/intel_quirks.h        |   6 +
 drivers/gpu/drm/i915/gt/uc/intel_gsc_uc.c          |   2 +-
 drivers/gpu/drm/i915/gt/uc/intel_uc_fw.h           |   5 +
 drivers/gpu/drm/i915/i915_sw_fence.c               |   8 +-
 drivers/gpu/drm/imagination/pvr_vm.c               |   4 +
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/fwsec.c    |   2 +-
 drivers/gpu/drm/panthor/panthor_drv.c              |  23 ++
 drivers/gpu/drm/panthor/panthor_fw.c               |   8 +-
 drivers/gpu/drm/panthor/panthor_mmu.c              |  21 +-
 drivers/gpu/drm/panthor/panthor_mmu.h              |   1 +
 drivers/gpu/drm/panthor/panthor_sched.c            |   2 +-
 drivers/gpu/drm/xe/regs/xe_gt_regs.h               |   1 +
 drivers/gpu/drm/xe/xe_gsc.c                        |  12 +
 drivers/gpu/drm/xe/xe_uc_fw.h                      |   9 +-
 drivers/gpu/drm/xe/xe_wa.c                         |   8 +
 drivers/hid/amd-sfh-hid/amd_sfh_hid.c              |   4 +-
 drivers/hid/bpf/Kconfig                            |   2 +-
 drivers/hid/hid-cougar.c                           |   2 +-
 drivers/hv/vmbus_drv.c                             |   1 +
 drivers/hwmon/adc128d818.c                         |   4 +-
 drivers/hwmon/hp-wmi-sensors.c                     |   2 +
 drivers/hwmon/lm95234.c                            |   9 +-
 drivers/hwmon/ltc2991.c                            |   6 +-
 drivers/hwmon/nct6775-core.c                       |   2 +-
 drivers/hwmon/w83627ehf.c                          |   4 +-
 drivers/i3c/master/mipi-i3c-hci/dma.c              |   5 +-
 drivers/i3c/master/svc-i3c-master.c                |  58 ++-
 drivers/iio/adc/ad7124.c                           |  30 +-
 drivers/iio/adc/ad7606.c                           |  28 +-
 drivers/iio/adc/ad7606.h                           |   2 +
 drivers/iio/adc/ad7606_par.c                       |  46 ++-
 drivers/iio/adc/ad_sigma_delta.c                   |   2 +-
 drivers/iio/buffer/industrialio-buffer-dmaengine.c |   4 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c      |  13 +-
 drivers/iio/inkern.c                               |   8 +-
 drivers/input/misc/uinput.c                        |  14 +
 drivers/input/touchscreen/ili210x.c                |   6 +-
 drivers/iommu/intel/dmar.c                         |   2 +-
 drivers/iommu/intel/iommu.c                        |   4 +-
 drivers/iommu/intel/iommu.h                        |   6 +-
 drivers/iommu/intel/pasid.c                        |   1 -
 drivers/iommu/intel/pasid.h                        |  10 -
 drivers/iommu/iommufd/hw_pagetable.c               |   3 +-
 drivers/iommu/sun50i-iommu.c                       |   1 +
 drivers/irqchip/irq-armada-370-xp.c                |   4 +
 drivers/irqchip/irq-gic-v2m.c                      |   6 +-
 drivers/irqchip/irq-renesas-rzg2l.c                |   2 +-
 drivers/irqchip/irq-riscv-aplic-main.c             |   4 +-
 drivers/irqchip/irq-sifive-plic.c                  | 115 +++---
 drivers/leds/leds-spi-byte.c                       |   6 +-
 drivers/md/dm-init.c                               |   4 +-
 drivers/media/platform/qcom/camss/camss.c          |   5 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |  17 +-
 drivers/media/test-drivers/vivid/vivid-vid-out.c   |  16 +-
 drivers/media/usb/b2c2/flexcop-usb.c               |   7 +-
 drivers/misc/fastrpc.c                             |   5 +-
 drivers/misc/vmw_vmci/vmci_resource.c              |   3 +-
 drivers/mmc/core/quirks.h                          |  22 +-
 drivers/mmc/core/sd.c                              |   4 +
 drivers/mmc/host/cqhci-core.c                      |   2 +-
 drivers/mmc/host/dw_mmc.c                          |   4 +-
 drivers/mmc/host/sdhci-of-aspeed.c                 |   1 +
 drivers/net/bareudp.c                              |  22 +-
 drivers/net/can/kvaser_pciefd.c                    |  43 ++-
 drivers/net/can/m_can/m_can.c                      | 100 ++++--
 drivers/net/can/spi/mcp251x.c                      |   2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |  28 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.c      |  11 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c     |  23 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c       | 165 ++++++---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c      |   2 +-
 .../net/can/spi/mcp251xfd/mcp251xfd-timestamp.c    |  22 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |  42 ++-
 drivers/net/dsa/vitesse-vsc73xx-core.c             |  10 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |  20 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |  10 +-
 drivers/net/ethernet/google/gve/gve.h              |   1 +
 drivers/net/ethernet/google/gve/gve_adminq.c       |  22 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |   6 +-
 drivers/net/ethernet/intel/ice/ice.h               |   2 +
 drivers/net/ethernet/intel/ice/ice_base.c          |  11 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           | 197 ++++------
 drivers/net/ethernet/intel/ice/ice_lib.h           |  10 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  63 +++-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  12 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  10 +
 drivers/net/ethernet/intel/igc/igc_main.c          |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  20 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  19 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  21 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  66 ++--
 .../net/ethernet/microchip/vcap/vcap_api_kunit.c   |  14 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  22 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  82 +++--
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |   3 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   8 +
 drivers/net/mctp/mctp-serial.c                     |   4 +-
 drivers/net/phy/phy_device.c                       |   2 +
 drivers/net/usb/ipheth.c                           |   2 +-
 drivers/net/usb/r8152.c                            |  17 +-
 drivers/net/usb/usbnet.c                           |  11 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |   4 +-
 drivers/net/wireless/ath/ath11k/core.c             | 119 ++----
 drivers/net/wireless/ath/ath11k/core.h             |   4 -
 drivers/net/wireless/ath/ath11k/hif.h              |  12 +-
 drivers/net/wireless/ath/ath11k/mhi.c              |  12 +-
 drivers/net/wireless/ath/ath11k/mhi.h              |   3 +-
 drivers/net/wireless/ath/ath11k/pci.c              |  44 +--
 drivers/net/wireless/ath/ath11k/qmi.c              |   2 +-
 drivers/net/wireless/ath/ath12k/mac.c              |   9 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   3 +-
 drivers/net/wireless/marvell/mwifiex/main.h        |   3 +
 drivers/net/wireless/realtek/rtw88/usb.c           |  13 +-
 drivers/net/wireless/realtek/rtw89/core.c          |   3 +-
 drivers/nvme/host/constants.c                      |   2 +-
 drivers/nvme/host/core.c                           |  40 +--
 drivers/nvme/host/fabrics.c                        |  10 +-
 drivers/nvme/host/fault_inject.c                   |   2 +-
 drivers/nvme/host/fc.c                             |   6 +-
 drivers/nvme/host/multipath.c                      |   2 +-
 drivers/nvme/host/nvme.h                           |   6 +-
 drivers/nvme/host/pci.c                            |  17 +
 drivers/nvme/host/pr.c                             |  10 +-
 drivers/nvme/target/admin-cmd.c                    |  34 +-
 drivers/nvme/target/core.c                         |  46 +--
 drivers/nvme/target/discovery.c                    |  14 +-
 drivers/nvme/target/fabrics-cmd-auth.c             |  16 +-
 drivers/nvme/target/fabrics-cmd.c                  |  36 +-
 drivers/nvme/target/io-cmd-bdev.c                  |  12 +-
 drivers/nvme/target/passthru.c                     |  10 +-
 drivers/nvme/target/rdma.c                         |  10 +-
 drivers/nvme/target/tcp.c                          |   8 +-
 drivers/nvme/target/zns.c                          |  30 +-
 drivers/nvmem/core.c                               |   6 +-
 drivers/nvmem/u-boot-env.c                         |   7 +
 drivers/of/irq.c                                   |  15 +-
 drivers/pci/controller/dwc/pci-keystone.c          |  44 ++-
 drivers/pci/controller/dwc/pcie-qcom.c             |  25 +-
 drivers/pci/hotplug/pnv_php.c                      |   3 +-
 drivers/pci/pci.c                                  |  35 +-
 drivers/pcmcia/yenta_socket.c                      |   6 +-
 drivers/phy/xilinx/phy-zynqmp.c                    |   1 +
 drivers/pinctrl/qcom/pinctrl-x1e80100.c            |   4 +-
 drivers/platform/x86/dell/dell-smbios-base.c       |   5 +-
 drivers/ptp/ptp_ocp.c                              | 168 +++++----
 drivers/scsi/lpfc/lpfc_els.c                       |  17 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |   4 +-
 drivers/spi/spi-fsl-lpspi.c                        |  31 +-
 drivers/spi/spi-hisi-kunpeng.c                     |   3 +
 drivers/spi/spi-intel.c                            |   3 +
 drivers/spi/spi-rockchip.c                         |  23 +-
 drivers/staging/iio/frequency/ad9834.c             |   2 +-
 .../vc04_services/interface/vchiq_arm/vchiq_core.c |  31 +-
 drivers/ufs/core/ufshcd.c                          |   7 +-
 drivers/uio/uio_hv_generic.c                       |  11 +-
 drivers/usb/dwc3/core.c                            |  15 +
 drivers/usb/dwc3/core.h                            |   2 +
 drivers/usb/dwc3/gadget.c                          |  41 +--
 drivers/usb/gadget/udc/aspeed_udc.c                |   2 +
 drivers/usb/gadget/udc/cdns2/cdns2-gadget.c        |  12 +-
 drivers/usb/gadget/udc/cdns2/cdns2-gadget.h        |   9 +
 drivers/usb/storage/uas.c                          |   1 +
 drivers/usb/typec/ucsi/ucsi.c                      |  50 +--
 drivers/vfio/vfio_iommu_spapr_tce.c                |  13 +-
 drivers/virt/coco/sev-guest/sev-guest.c            |   7 +-
 drivers/virtio/virtio_ring.c                       |   4 +-
 drivers/watchdog/imx7ulp_wdt.c                     |   5 +
 drivers/xen/privcmd.c                              |  10 +-
 fs/binfmt_elf.c                                    |   5 +-
 fs/btrfs/ctree.c                                   |  12 +-
 fs/btrfs/ctree.h                                   |   1 -
 fs/btrfs/extent-tree.c                             |  62 +++-
 fs/btrfs/file.c                                    |  25 +-
 fs/btrfs/inode.c                                   |   2 +-
 fs/btrfs/qgroup.c                                  |  90 ++++-
 fs/btrfs/transaction.h                             |   6 +
 fs/btrfs/zoned.c                                   |  30 +-
 fs/cachefiles/io.c                                 |   2 +-
 fs/ext4/fast_commit.c                              |   8 +-
 fs/fuse/dev.c                                      |  14 +-
 fs/fuse/dir.c                                      |   2 +-
 fs/fuse/file.c                                     |   8 +-
 fs/fuse/inode.c                                    |   7 +-
 fs/fuse/xattr.c                                    |   4 +-
 fs/jbd2/recovery.c                                 |  30 ++
 fs/libfs.c                                         |   6 +-
 fs/namespace.c                                     |  93 ++---
 fs/netfs/fscache_main.c                            |   1 +
 fs/netfs/io.c                                      |  19 +-
 fs/nfs/super.c                                     |   2 +
 fs/nilfs2/recovery.c                               |  35 +-
 fs/nilfs2/segment.c                                |  10 +-
 fs/nilfs2/sysfs.c                                  |  43 ++-
 fs/ntfs3/dir.c                                     |  52 +--
 fs/ntfs3/frecord.c                                 |   4 +-
 fs/smb/client/cifsfs.c                             |  21 +-
 fs/smb/client/cifsglob.h                           |   1 +
 fs/smb/client/cifssmb.c                            |  54 ++-
 fs/smb/client/file.c                               |  37 +-
 fs/smb/client/inode.c                              |   2 +
 fs/smb/client/smb2inode.c                          |   3 +
 fs/smb/client/smb2ops.c                            |  18 +-
 fs/smb/client/smb2pdu.c                            |  41 ++-
 fs/smb/client/trace.h                              |   1 +
 fs/smb/server/oplock.c                             |   2 +-
 fs/smb/server/smb2pdu.c                            |  14 +-
 fs/smb/server/transport_tcp.c                      |   4 +-
 fs/squashfs/inode.c                                |   7 +-
 fs/tracefs/event_inode.c                           |   2 +-
 fs/udf/super.c                                     |  15 +
 fs/xattr.c                                         |  91 ++---
 fs/xfs/libxfs/xfs_ialloc_btree.c                   |   2 +-
 include/linux/bpf-cgroup.h                         |   9 -
 include/linux/mlx5/device.h                        |   1 +
 include/linux/mm.h                                 |   4 +
 include/linux/netfs.h                              |   1 +
 include/linux/nvme.h                               |  16 +-
 include/linux/path.h                               |   9 +
 include/linux/regulator/consumer.h                 |   8 +
 include/linux/zswap.h                              |   4 +-
 include/net/bluetooth/hci_core.h                   |   5 -
 include/net/bluetooth/hci_sync.h                   |   4 +
 include/net/mana/mana.h                            |   2 +
 include/uapi/drm/drm_fourcc.h                      |  18 +
 include/uapi/drm/panthor_drm.h                     |   6 +-
 kernel/bpf/btf.c                                   |   4 +-
 kernel/bpf/verifier.c                              |   4 +-
 kernel/cgroup/cgroup.c                             |   2 +-
 kernel/cgroup/cpuset.c                             |  36 +-
 kernel/dma/map_benchmark.c                         |  16 +
 kernel/events/core.c                               |  18 +-
 kernel/events/internal.h                           |   1 +
 kernel/events/ring_buffer.c                        |   2 +
 kernel/events/uprobes.c                            |   3 +-
 kernel/exit.c                                      |   3 +-
 kernel/kexec_file.c                                |   2 +-
 kernel/locking/rtmutex.c                           |   9 +-
 kernel/resource.c                                  |   6 +-
 kernel/seccomp.c                                   |  23 +-
 kernel/smp.c                                       |   1 +
 kernel/trace/trace.c                               |   2 +
 kernel/trace/trace_kprobe.c                        | 125 ++++---
 kernel/trace/trace_osnoise.c                       |  50 ++-
 kernel/workqueue.c                                 |  14 +-
 lib/codetag.c                                      |  17 +-
 lib/generic-radix-tree.c                           |   2 +
 lib/maple_tree.c                                   |   7 +-
 lib/overflow_kunit.c                               |   3 +-
 mm/memcontrol.c                                    |  12 +-
 mm/memory_hotplug.c                                |   2 +-
 mm/page_alloc.c                                    |   7 +
 mm/slub.c                                          |   4 +
 mm/sparse.c                                        |   2 +-
 mm/userfaultfd.c                                   |  29 +-
 mm/vmalloc.c                                       |   7 +-
 mm/vmscan.c                                        |  24 +-
 mm/zswap.c                                         |   2 +-
 net/bluetooth/hci_conn.c                           |   6 +-
 net/bluetooth/hci_sync.c                           |  42 ++-
 net/bluetooth/mgmt.c                               | 144 ++++----
 net/bluetooth/smp.c                                |   7 -
 net/bridge/br_fdb.c                                |   6 +-
 net/can/bcm.c                                      |   4 +
 net/core/filter.c                                  |   1 -
 net/core/net-sysfs.c                               |   2 +-
 net/ethtool/channels.c                             |   6 +-
 net/ethtool/common.c                               |  26 +-
 net/ethtool/common.h                               |   2 +-
 net/ethtool/ioctl.c                                |   4 +-
 net/ipv4/fou_core.c                                |  29 +-
 net/ipv4/tcp_bpf.c                                 |   2 +-
 net/ipv4/tcp_input.c                               |   6 +
 net/ipv6/ila/ila.h                                 |   1 +
 net/ipv6/ila/ila_main.c                            |   6 +
 net/ipv6/ila/ila_xlat.c                            |  13 +-
 net/netfilter/nf_conncount.c                       |   8 +-
 net/sched/sch_cake.c                               |  11 +-
 net/sched/sch_netem.c                              |   9 +-
 net/socket.c                                       |   4 +-
 net/unix/af_unix.c                                 |   9 +-
 rust/Makefile                                      |   2 +-
 rust/macros/module.rs                              |   6 +-
 scripts/gfp-translate                              |  66 +++-
 security/smack/smack_lsm.c                         |  12 +-
 sound/core/control.c                               |   6 +-
 sound/hda/hdmi_chmap.c                             |  18 +
 sound/pci/hda/patch_conexant.c                     |  11 +
 sound/pci/hda/patch_realtek.c                      |  22 +-
 sound/soc/codecs/tas2781-fmwlib.c                  |  71 ++--
 sound/soc/intel/boards/bxt_rt298.c                 |   2 +-
 sound/soc/intel/boards/bytcht_cx2072x.c            |   2 +-
 sound/soc/intel/boards/bytcht_da7213.c             |   2 +-
 sound/soc/intel/boards/bytcht_es8316.c             |   2 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |   2 +-
 sound/soc/intel/boards/bytcr_rt5651.c              |   2 +-
 sound/soc/intel/boards/bytcr_wm5102.c              |   2 +-
 sound/soc/intel/boards/cht_bsw_rt5645.c            |   2 +-
 sound/soc/intel/boards/cht_bsw_rt5672.c            |   2 +-
 sound/soc/soc-dapm.c                               |   1 +
 sound/soc/soc-topology.c                           |   2 +
 sound/soc/sof/topology.c                           |   2 +
 sound/soc/sunxi/sun4i-i2s.c                        | 143 ++++----
 sound/soc/tegra/tegra210_ahub.c                    |  12 +-
 tools/lib/bpf/libbpf.c                             |   4 +-
 tools/net/ynl/lib/ynl.py                           |   7 +-
 tools/perf/util/bpf_lock_contention.c              |   3 +
 tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c |   4 +-
 tools/testing/selftests/mm/mseal_test.c            |  37 +-
 tools/testing/selftests/mm/seal_elf.c              |  13 +-
 tools/testing/selftests/net/Makefile               |   3 +-
 tools/testing/selftests/riscv/mm/mmap_bottomup.c   |   2 -
 tools/testing/selftests/riscv/mm/mmap_default.c    |   2 -
 tools/testing/selftests/riscv/mm/mmap_test.h       |  67 ----
 436 files changed, 4664 insertions(+), 3102 deletions(-)


