Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F6314B06C;
	Tue, 10 Sep 2024 10:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964003; cv=none; b=EzSxE8zneUpm0pmJF5h+H4qF2lJpcdidq3TethX+Znfo05k6Vw04LAgfcGMMKOMP6ZJ3K+cx9zcKL1gKQMr+bM53JG8TgjwZq7j9i2dQ5Yk61K3AdyE1j7GB1homEfH8bUnI1+My0XxaIPDd7AXV2NsaD/nCKUYMSNVJ0JbwA+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964003; c=relaxed/simple;
	bh=NcrKvaxGe7MuvkWnmrlO2cKYKCayxiOUM3++TDitWPk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=B68O+ULZesgzSPBJ3GRfJaxrgAeRX6YPk5B2fHnjD3rkEKbdxayFQRi/6C8FTz5tZgNalD2K+fPnpAgzBxf34gYmGISPKlseDtS1KfYqNJu3Rs1OS2d2bJWfD9SLL574yupQHXZPSA9G+d2O5YEB1jflhLKsywQxddWokaUaRKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cl+QtQg7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cl+QtQg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24676C4CEC3;
	Tue, 10 Sep 2024 10:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964002;
	bh=NcrKvaxGe7MuvkWnmrlO2cKYKCayxiOUM3++TDitWPk=;
	h=From:To:Cc:Subject:Date:From;
	b=Cl+QtQg76qIAa9ce0qt8MigeOya47nmPC6QAs31KdcurcawHBZESTP9/AXOyPdU4f
	 lF9N9vHR4QLyvy5Ol0rZRwwpZILSGHU3xkArb9REZr11kx+gw8QJfNTpMKdFHqRUct
	 SHKDsHmrgYhOpQLIrAJiHdWWBmO9aG8seK+c1BJw=
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
Subject: [PATCH 6.6 000/269] 6.6.51-rc1 review
Date: Tue, 10 Sep 2024 11:29:47 +0200
Message-ID: <20240910092608.225137854@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.51-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.51-rc1
X-KernelTest-Deadline: 2024-09-12T09:26+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.51 release.
There are 269 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.51-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.51-rc1

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix UAF on hci_abort_conn_sync

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix UAF on create_le_conn_complete

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix UAF in hci_acl_create_conn_sync

Stefan Wahren <wahrenst@gmx.net>
    spi: spi-fsl-lpspi: Fix off-by-one in prescale max

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race between direct IO write and fsync when using same fd

Thomas Gleixner <tglx@linutronix.de>
    x86/mm: Fix PTI for i386 some more

Andrea Parri <parri.andrea@gmail.com>
    membarrier: riscv: Add full memory barrier in switch_mm()

Li Nan <linan122@huawei.com>
    ublk_drv: fix NULL pointer dereference in ublk_ctrl_start_recovery()

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

Stephen Boyd <swboyd@chromium.org>
    clk: qcom: gcc-sm8550: Don't park the USB RCG at registration time

Stephen Boyd <swboyd@chromium.org>
    clk: qcom: gcc-sm8550: Don't use parking clk_ops for QUPs

Matteo Martelli <matteomartelli3@gmail.com>
    ASoC: sunxi: sun4i-i2s: fix LRCLK polarity in i2s mode

Chen-Yu Tsai <wenst@chromium.org>
    ASoc: SOF: topology: Clear SOF link platform name upon unload

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

Nicholas Piggin <npiggin@gmail.com>
    workqueue: Improve scalability of workqueue watchdog touch

Nicholas Piggin <npiggin@gmail.com>
    workqueue: wq_watchdog_touch is always called with valid CPU

Usama Arif <usamaarif642@gmail.com>
    Revert "mm: skip CMA pages when they are not available"

Vern Hao <vernhao@tencent.com>
    mm/vmscan: use folio_migratetype() instead of get_pageblock_migratetype()

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

Carlos Llamas <cmllamas@google.com>
    binder: fix UAF caused by offsets overwrite

Sukrut Bellary <sukrut.bellary@linux.com>
    misc: fastrpc: Fix double free of 'buf' in error path

Prashanth K <quic_prashk@quicinc.com>
    usb: dwc3: Avoid waking up gadget during startxfer

Pawel Laszczak <pawell@cadence.com>
    usb: cdns2: Fix controller reset issue

Faisal Hassan <quic_faisalh@quicinc.com>
    usb: dwc3: core: update LC timer as per USB Spec V3.2

Dumitru Ceclan <mitrutzceclan@gmail.com>
    iio: adc: ad7124: fix chip ID mismatch

Guillaume Stols <gstols@baylibre.com>
    iio: adc: ad7606: remove frstdata check for serial mode

Dumitru Ceclan <mitrutzceclan@gmail.com>
    iio: adc: ad7124: fix config comparison

Matteo Martelli <matteomartelli3@gmail.com>
    iio: fix scale application in iio_convert_raw_to_processed_unlocked

David Lechner <dlechner@baylibre.com>
    iio: buffer-dmaengine: fix releasing dma channel on error

Aleksandr Mishin <amishin@t-argos.ru>
    staging: iio: frequency: ad9834: Validate frequency parameter value

Sasha Neftin <sasha.neftin@intel.com>
    intel: legacy: Partial revert of field get conversion

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    tcp: process the 3rd ACK with sk_socket for TFO/MPTCP

Perry Yuan <perry.yuan@amd.com>
    cpufreq: amd-pstate: fix the highest frequency issue which limits performance

Meng Li <li.meng@amd.com>
    cpufreq: amd-pstate: Enable amd-pstate preferred core support

Meng Li <li.meng@amd.com>
    ACPI: CPPC: Add helper to get the highest performance value

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Use accessors to page table entries instead of direct dereference

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: mm: Only compile pgtable.c if MMU

Alexandre Ghiti <alexghiti@rivosinc.com>
    mm: Introduce pudp/p4dp/pgdp_get() functions

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Use WRITE_ONCE() when setting page table entries

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

Arnd Bergmann <arnd@arndb.de>
    regmap: maple: work around gcc-14.1 false-positive warning

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Use correct API to map cmdline in relocate_kernel()

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

Filipe Manana <fdmanana@suse.com>
    btrfs: replace BUG_ON() with error handling at update_ref_for_cow()

Josef Bacik <josef@toxicpanda.com>
    btrfs: clean up our handling of refs == 0 in snapshot delete

Josef Bacik <josef@toxicpanda.com>
    btrfs: replace BUG_ON with ASSERT in walk_down_proc()

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Check more cases when directory is corrupted

Zqiang <qiang.zhang1211@gmail.com>
    smp: Add missing destroy_work_on_stack() call in smp_call_on_cpu()

Christian König <christian.koenig@amd.com>
    drm/amdgpu: reject gang submit on reserved VMIDs

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

Hareshx Sankar Raj <hareshx.sankar.raj@intel.com>
    crypto: qat - fix unintentional re-enabling of error interrupts

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

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Handle volatile descriptor status read

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

Jamie Bainbridge <jamie.bainbridge@gmail.com>
    selftests: net: enable bind tests

Pawel Dembicki <paweldembicki@gmail.com>
    net: dsa: vsc73xx: fix possible subblocks range of CAPT block

Jonas Gorski <jonas.gorski@bisdn.de>
    net: bridge: br_fdb_external_learn_add(): always set EXT_LEARN

Hayes Wang <hayeswang@realtek.com>
    r8152: fix the firmware doesn't work

Kuniyuki Iwashima <kuniyu@amazon.com>
    fou: Fix null-ptr-deref in GRO.

Guillaume Nault <gnault@redhat.com>
    bareudp: Fix device stats updates.

Tze-nan Wu <Tze-nan.Wu@mediatek.com>
    bpf, net: Fix a potential race in do_sock_getsockopt()

Breno Leitao <leitao@debian.org>
    net/socket: Break down __sys_getsockopt

Breno Leitao <leitao@debian.org>
    net/socket: Break down __sys_setsockopt

Breno Leitao <leitao@debian.org>
    bpf: Add sockptr support for setsockopt

Breno Leitao <leitao@debian.org>
    bpf: Add sockptr support for getsockopt

Oliver Neukum <oneukum@suse.com>
    usbnet: modern method to get random MAC

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: do not bring the VSI up, if it was down before the XDP setup

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: protect XDP configuration with a mutex

Jinjie Ruan <ruanjinjie@huawei.com>
    net: phy: Fix missing of_node_put() for leds

Armin Wolf <W_Armin@gmx.de>
    hwmon: (hp-wmi-sensors) Check if WMI event data exists

Dan Carpenter <dan.carpenter@linaro.org>
    igc: Unlock on error in igc_io_resume()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix not generating command complete for MGMT_OP_DISCONNECT

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Introduce hci_cmd_sync_run/hci_cmd_sync_run_once

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Attempt to dequeue connection attempt

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Add helper functions to manipulate cmd_sync queue

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_conn: Fix UAF Write in __hci_acl_create_connection_sync

Jonas Dreßler <verdre@v0yd.nl>
    Bluetooth: Remove pending ACL connection attempts

Jonas Dreßler <verdre@v0yd.nl>
    Bluetooth: hci_conn: Only do ACL connections sequentially

Jonas Dreßler <verdre@v0yd.nl>
    Bluetooth: hci_event: Use HCI error defines instead of magic values

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

Aleksandr Mishin <amishin@t-argos.ru>
    platform/x86: dell-smbios: Fix error path in dell_smbios_init()

Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
    ice: Add netif_device_attach/detach into PF reset flow

Daiwei Li <daiweili@google.com>
    igb: Fix not clearing TimeSync interrupts for 82580

David Howells <dhowells@redhat.com>
    cifs: Fix FALLOC_FL_ZERO_RANGE to preflush buffered part of target region

Andreas Hindborg <a.hindborg@samsung.com>
    rust: kbuild: fix export of bss symbols

Matthew Maurer <mmaurer@google.com>
    rust: Use awk instead of recent xargs

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: fix ring configuration when switching from CAN-CC to CAN-FD mode

Simon Horman <horms@kernel.org>
    can: m_can: Release irq on error in m_can_open

Kuniyuki Iwashima <kuniyu@amazon.com>
    can: bcm: Remove proc entry when dev is unregistered.

Marek Olšák <marek.olsak@amd.com>
    drm/amdgpu: check for LINEAR_ALIGNED correctly in check_tiling_flags_gfx6

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check denominator pbn_div before used

Jules Irenge <jbi.octave@gmail.com>
    pcmcia: Use resource_size function on resource object

Chen Ni <nichen@iscas.ac.cn>
    media: qcom: camss: Add check for v4l2_fwnode_endpoint_parse

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ili210x - use kvmalloc() to allocate buffer for firmware update

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: keystone: Add workaround for Errata #i2037 (AM65x SR 1.0)

Eric Joyner <eric.joyner@intel.com>
    ice: Check all ice_vsi_rebuild() errors in function

Shivaprasad G Bhat <sbhat@linux.ibm.com>
    vfio/spapr: Always clear TCEs before unsetting the window

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vivid: don't set HDMI TX controls if there are no HDMI outputs

Danijel Slivka <danijel.slivka@amd.com>
    drm/amdgpu: clear RB_OVERFLOW bit when enabling interrupts

Hawking Zhang <Hawking.Zhang@amd.com>
    drm/amdgpu: Fix smatch static checker warning

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check HDCP returned status

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Run DC_LOG_DC after checking link->link_enc

Ma Ke <make24@iscas.ac.cn>
    usb: gadget: aspeed_udc: validate endpoint index for ast udc

Shantanu Goel <sgoel01@yahoo.com>
    usb: uas: set host status byte on data completion error

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

Yunjian Wang <wangyunjian@huawei.com>
    netfilter: nf_conncount: fix wrong variable type

Jernej Skrabec <jernej.skrabec@gmail.com>
    iommu: sun50i: clear bypass register

Brian Johannesmeyer <bjohannesmeyer@gmail.com>
    x86/kmsan: Fix hook for unaligned accesses

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Remove put_pid()/put_cred() in copy_peercred().

Pali Rohár <pali@kernel.org>
    irqchip/armada-370-xp: Do not allow mapping IRQ 0 and 1

Rakesh Ughreja <rughreja@habana.ai>
    accel/habanalabs/gaudi2: unsecure edma max outstanding register

Alexey Dobriyan <adobriyan@gmail.com>
    ELF: fix kernel.randomize_va_space double read

Leon Hwang <hffilwlqm@gmail.com>
    bpf, verifier: Correct tail_call_reachable for bpf prog

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

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/i915: Do not attempt to load the GSC multiple times

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

Will Deacon <will@kernel.org>
    mm: vmalloc: ensure vmap_block is initialised before adding to queue

Petr Tesarik <ptesarik@suse.com>
    kexec_file: fix elfcorehdr digest exclusion when CONFIG_CRASH_HOTPLUG=y

Simon Arlott <simon@octiron.net>
    can: mcp251x: fix deadlock if an interrupt occurs during mcp251x_open

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

yangyun <yangyun50@huawei.com>
    fuse: fix memory leak in fuse_create_open

Jann Horn <jannh@google.com>
    fuse: use unsigned type for getxattr/listxattr size truncation

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

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Ignore keys being loaded with invalid type

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Revert "Bluetooth: MGMT/SMP: Fix address type when using SMP over BREDR/LE"

Boqun Feng <boqun.feng@gmail.com>
    rust: macros: provide correct provenance when constructing THIS_MODULE

Boqun Feng <boqun.feng@gmail.com>
    rust: types: Make Opaque::get const

Georg Gottleuber <ggo@tuxedocomputers.com>
    nvme-pci: Add sleep quirk for Samsung 990 Evo

Roland Xu <mu001999@outlook.com>
    rtmutex: Drop rt_mutex::wait_lock before scheduling

Thomas Gleixner <tglx@linutronix.de>
    x86/kaslr: Expose and use the end of the physical memory address space

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

Jens Emil Schulz Østergaard <jensemil.schulzostergaard@microchip.com>
    net: microchip: vcap: Fix use-after-free error in kunit test

Stephen Hemminger <stephen@networkplumber.org>
    sch/netem: fix use after free in netem_dequeue


-------------

Diffstat:

 MAINTAINERS                                        |   2 +-
 Makefile                                           |   4 +-
 arch/arm/include/asm/pgtable.h                     |   2 +
 arch/arm64/include/asm/acpi.h                      |  12 +
 arch/arm64/kernel/acpi_numa.c                      |  11 -
 arch/loongarch/kernel/relocate.c                   |   4 +-
 arch/mips/kernel/cevt-r4k.c                        |  15 +-
 arch/powerpc/include/asm/nohash/mmu-e500.h         |   3 +-
 arch/powerpc/kernel/vdso/vdso32.lds.S              |   4 +-
 arch/powerpc/kernel/vdso/vdso64.lds.S              |   4 +-
 arch/powerpc/lib/qspinlock.c                       |  10 +-
 arch/powerpc/mm/nohash/Makefile                    |   2 +-
 arch/powerpc/mm/nohash/tlb.c                       | 398 +--------------------
 arch/powerpc/mm/nohash/tlb_64e.c                   | 361 +++++++++++++++++++
 arch/powerpc/mm/nohash/tlb_low_64e.S               | 195 ----------
 arch/riscv/Kconfig                                 |   5 +-
 arch/riscv/include/asm/kfence.h                    |   4 +-
 arch/riscv/include/asm/membarrier.h                |  31 ++
 arch/riscv/include/asm/pgtable-64.h                |  22 +-
 arch/riscv/include/asm/pgtable.h                   |  33 +-
 arch/riscv/kernel/efi.c                            |   2 +-
 arch/riscv/kernel/head.S                           |   3 +
 arch/riscv/kernel/probes/kprobes.c                 |   5 +-
 arch/riscv/kvm/mmu.c                               |  22 +-
 arch/riscv/mm/Makefile                             |   3 +-
 arch/riscv/mm/context.c                            |   2 +
 arch/riscv/mm/fault.c                              |  16 +-
 arch/riscv/mm/hugetlbpage.c                        |  12 +-
 arch/riscv/mm/init.c                               |   2 +-
 arch/riscv/mm/kasan_init.c                         |  45 +--
 arch/riscv/mm/pageattr.c                           |  44 +--
 arch/riscv/mm/pgtable.c                            |  51 ++-
 arch/s390/kernel/vmlinux.lds.S                     |   9 +
 arch/um/drivers/line.c                             |   2 +
 arch/x86/coco/tdx/tdx.c                            |   1 -
 arch/x86/events/intel/core.c                       |  23 +-
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
 drivers/accel/habanalabs/gaudi2/gaudi2_security.c  |   1 +
 drivers/acpi/acpi_processor.c                      |  15 +-
 drivers/acpi/cppc_acpi.c                           |  13 +
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
 drivers/clk/starfive/clk-starfive-jh7110-sys.c     |  31 +-
 drivers/clk/starfive/clk-starfive-jh71x0.h         |   2 +
 drivers/clocksource/timer-imx-tpm.c                |  16 +-
 drivers/clocksource/timer-of.c                     |  17 +-
 drivers/clocksource/timer-of.h                     |   1 -
 drivers/cpufreq/amd-pstate.c                       | 147 +++++++-
 .../crypto/intel/qat/qat_common/adf_gen2_pfvf.c    |   4 +-
 .../intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c  |   8 +-
 drivers/crypto/starfive/jh7110-cryp.h              |   4 +-
 drivers/crypto/starfive/jh7110-rsa.c               |  15 +-
 drivers/cxl/core/region.c                          |   5 +-
 drivers/firmware/cirrus/cs_dsp.c                   |   3 +
 drivers/gpio/gpio-rockchip.c                       |   1 +
 drivers/gpio/gpio-zynqmp-modepin.c                 |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |  15 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c        |  30 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c            |  15 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.h            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c           |   4 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/ih_v6_0.c               |  28 ++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   2 +-
 drivers/gpu/drm/amd/display/dc/link/link_factory.c |   6 +-
 .../drm/amd/display/modules/hdcp/hdcp1_execution.c |  15 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   6 +-
 drivers/gpu/drm/i915/gt/uc/intel_gsc_uc.c          |   2 +-
 drivers/gpu/drm/i915/gt/uc/intel_uc_fw.h           |   5 +
 drivers/gpu/drm/i915/i915_sw_fence.c               |   8 +-
 drivers/hid/amd-sfh-hid/amd_sfh_hid.c              |   4 +-
 drivers/hid/hid-cougar.c                           |   2 +-
 drivers/hv/vmbus_drv.c                             |   1 +
 drivers/hwmon/adc128d818.c                         |   4 +-
 drivers/hwmon/hp-wmi-sensors.c                     |   2 +
 drivers/hwmon/lm95234.c                            |   9 +-
 drivers/hwmon/nct6775-core.c                       |   2 +-
 drivers/hwmon/w83627ehf.c                          |   4 +-
 drivers/i3c/master/mipi-i3c-hci/dma.c              |   5 +-
 drivers/i3c/master/svc-i3c-master.c                |  58 ++-
 drivers/iio/adc/ad7124.c                           |  27 +-
 drivers/iio/adc/ad7606.c                           |  28 +-
 drivers/iio/adc/ad7606.h                           |   2 +
 drivers/iio/adc/ad7606_par.c                       |  46 ++-
 drivers/iio/buffer/industrialio-buffer-dmaengine.c |   4 +-
 drivers/iio/inkern.c                               |   8 +-
 drivers/input/misc/uinput.c                        |  14 +
 drivers/input/touchscreen/ili210x.c                |   6 +-
 drivers/iommu/intel/dmar.c                         |   2 +-
 drivers/iommu/sun50i-iommu.c                       |   1 +
 drivers/irqchip/irq-armada-370-xp.c                |   4 +
 drivers/irqchip/irq-gic-v2m.c                      |   6 +-
 drivers/leds/leds-spi-byte.c                       |   6 +-
 drivers/md/dm-init.c                               |   4 +-
 drivers/media/platform/qcom/camss/camss.c          |   5 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |  17 +-
 drivers/media/test-drivers/vivid/vivid-vid-out.c   |  16 +-
 drivers/misc/fastrpc.c                             |   5 +-
 drivers/misc/vmw_vmci/vmci_resource.c              |   3 +-
 drivers/mmc/core/quirks.h                          |  22 +-
 drivers/mmc/core/sd.c                              |   4 +
 drivers/mmc/host/cqhci-core.c                      |   2 +-
 drivers/mmc/host/dw_mmc.c                          |   4 +-
 drivers/mmc/host/sdhci-of-aspeed.c                 |   1 +
 drivers/net/bareudp.c                              |  22 +-
 drivers/net/can/kvaser_pciefd.c                    |  43 ++-
 drivers/net/can/m_can/m_can.c                      |   5 +-
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
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |   2 +-
 drivers/net/ethernet/intel/ice/ice.h               |   2 +
 drivers/net/ethernet/intel/ice/ice_lib.c           |  34 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  46 ++-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |   3 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  10 +
 drivers/net/ethernet/intel/igc/igc_main.c          |   1 +
 .../net/ethernet/microchip/vcap/vcap_api_kunit.c   |  14 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  22 +-
 drivers/net/mctp/mctp-serial.c                     |   4 +-
 drivers/net/phy/phy_device.c                       |   2 +
 drivers/net/usb/ipheth.c                           |   2 +-
 drivers/net/usb/r8152.c                            |  17 +-
 drivers/net/usb/usbnet.c                           |  11 +-
 drivers/net/wireless/ath/ath12k/mac.c              |   9 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   3 +-
 drivers/net/wireless/marvell/mwifiex/main.h        |   3 +
 drivers/net/wireless/realtek/rtw88/usb.c           |  13 +-
 drivers/nvme/host/pci.c                            |  17 +
 drivers/nvme/target/tcp.c                          |   4 +-
 drivers/nvmem/core.c                               |   6 +-
 drivers/of/irq.c                                   |  15 +-
 drivers/pci/controller/dwc/pci-keystone.c          |  44 ++-
 drivers/pci/hotplug/pnv_php.c                      |   3 +-
 drivers/pci/pci.c                                  |  35 +-
 drivers/pcmcia/yenta_socket.c                      |   6 +-
 drivers/phy/xilinx/phy-zynqmp.c                    |   1 +
 drivers/platform/x86/dell/dell-smbios-base.c       |   5 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |   4 +-
 drivers/spi/spi-fsl-lpspi.c                        |  31 +-
 drivers/spi/spi-hisi-kunpeng.c                     |   3 +
 drivers/spi/spi-rockchip.c                         |  23 +-
 drivers/staging/iio/frequency/ad9834.c             |   2 +-
 drivers/ufs/core/ufshcd.c                          |   7 +-
 drivers/uio/uio_hv_generic.c                       |  11 +-
 drivers/usb/dwc3/core.c                            |  15 +
 drivers/usb/dwc3/core.h                            |   2 +
 drivers/usb/dwc3/gadget.c                          |  41 +--
 drivers/usb/gadget/udc/aspeed_udc.c                |   2 +
 drivers/usb/gadget/udc/cdns2/cdns2-gadget.c        |  12 +-
 drivers/usb/gadget/udc/cdns2/cdns2-gadget.h        |   9 +
 drivers/usb/storage/uas.c                          |   1 +
 drivers/vfio/vfio_iommu_spapr_tce.c                |  13 +-
 drivers/virtio/virtio_ring.c                       |   4 +-
 drivers/xen/privcmd.c                              |  10 +-
 fs/binfmt_elf.c                                    |   5 +-
 fs/btrfs/ctree.c                                   |  12 +-
 fs/btrfs/ctree.h                                   |   1 -
 fs/btrfs/extent-tree.c                             |  32 +-
 fs/btrfs/file.c                                    |  25 +-
 fs/btrfs/inode.c                                   |   2 +-
 fs/btrfs/transaction.h                             |   6 +
 fs/ext4/fast_commit.c                              |   8 +-
 fs/fscache/main.c                                  |   1 +
 fs/fuse/dir.c                                      |   2 +-
 fs/fuse/file.c                                     |   8 +-
 fs/fuse/xattr.c                                    |   4 +-
 fs/jbd2/recovery.c                                 |  30 ++
 fs/nfs/super.c                                     |   2 +
 fs/nilfs2/recovery.c                               |  35 +-
 fs/nilfs2/segment.c                                |  10 +-
 fs/nilfs2/sysfs.c                                  |  43 ++-
 fs/ntfs3/dir.c                                     |  52 +--
 fs/ntfs3/frecord.c                                 |   4 +-
 fs/smb/client/smb2inode.c                          |   3 +
 fs/smb/client/smb2ops.c                            |  16 +-
 fs/smb/server/oplock.c                             |   2 +-
 fs/smb/server/smb2pdu.c                            |  14 +-
 fs/smb/server/transport_tcp.c                      |   4 +-
 fs/squashfs/inode.c                                |   7 +-
 fs/tracefs/event_inode.c                           |   2 +-
 fs/udf/super.c                                     |  15 +
 fs/xattr.c                                         |  91 ++---
 include/acpi/cppc_acpi.h                           |   5 +
 include/linux/amd-pstate.h                         |   4 +
 include/linux/bpf-cgroup.h                         |  16 +-
 include/linux/mm.h                                 |   4 +
 include/linux/pgtable.h                            |  21 ++
 include/linux/regulator/consumer.h                 |   8 +
 include/net/bluetooth/hci.h                        |   3 +
 include/net/bluetooth/hci_core.h                   |  25 +-
 include/net/bluetooth/hci_sync.h                   |  24 +-
 include/net/mana/mana.h                            |   2 +
 include/net/sock.h                                 |   6 +-
 include/uapi/drm/drm_fourcc.h                      |  18 +
 kernel/bpf/cgroup.c                                |  25 +-
 kernel/bpf/verifier.c                              |   4 +-
 kernel/cgroup/cgroup.c                             |   2 +-
 kernel/dma/map_benchmark.c                         |  16 +
 kernel/events/core.c                               |  18 +-
 kernel/events/internal.h                           |   1 +
 kernel/events/ring_buffer.c                        |   2 +
 kernel/events/uprobes.c                            |   3 +-
 kernel/kexec_file.c                                |   2 +-
 kernel/locking/rtmutex.c                           |   9 +-
 kernel/resource.c                                  |   6 +-
 kernel/sched/core.c                                |   5 +-
 kernel/smp.c                                       |   1 +
 kernel/trace/trace.c                               |   2 +
 kernel/trace/trace_osnoise.c                       |  50 ++-
 kernel/workqueue.c                                 |  14 +-
 lib/generic-radix-tree.c                           |   2 +
 mm/memory_hotplug.c                                |   2 +-
 mm/sparse.c                                        |   2 +-
 mm/userfaultfd.c                                   |  29 +-
 mm/vmalloc.c                                       |   2 +-
 mm/vmscan.c                                        |  24 +-
 net/bluetooth/hci_conn.c                           | 158 ++------
 net/bluetooth/hci_event.c                          |  27 +-
 net/bluetooth/hci_sync.c                           | 307 +++++++++++++++-
 net/bluetooth/mgmt.c                               | 144 ++++----
 net/bluetooth/smp.c                                |   7 -
 net/bridge/br_fdb.c                                |   6 +-
 net/can/bcm.c                                      |   4 +
 net/core/sock.c                                    |   8 -
 net/ipv4/fou_core.c                                |  29 +-
 net/ipv4/tcp_bpf.c                                 |   2 +-
 net/ipv4/tcp_input.c                               |   6 +
 net/ipv6/ila/ila.h                                 |   1 +
 net/ipv6/ila/ila_main.c                            |   6 +
 net/ipv6/ila/ila_xlat.c                            |  13 +-
 net/netfilter/nf_conncount.c                       |   8 +-
 net/sched/sch_cake.c                               |  11 +-
 net/sched/sch_netem.c                              |   9 +-
 net/socket.c                                       | 104 ++++--
 net/unix/af_unix.c                                 |   9 +-
 rust/Makefile                                      |   4 +-
 rust/kernel/types.rs                               |   2 +-
 rust/macros/module.rs                              |   6 +-
 security/smack/smack_lsm.c                         |  12 +-
 sound/core/control.c                               |   6 +-
 sound/hda/hdmi_chmap.c                             |  18 +
 sound/pci/hda/patch_conexant.c                     |  11 +
 sound/pci/hda/patch_realtek.c                      |  10 +
 sound/soc/codecs/tas2781-fmwlib.c                  |  71 ++--
 sound/soc/soc-dapm.c                               |   1 +
 sound/soc/soc-topology.c                           |   2 +
 sound/soc/sof/topology.c                           |   2 +
 sound/soc/sunxi/sun4i-i2s.c                        | 143 ++++----
 sound/soc/tegra/tegra210_ahub.c                    |  12 +-
 tools/lib/bpf/libbpf.c                             |   4 +-
 tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c |   4 +-
 tools/testing/selftests/net/Makefile               |   3 +-
 285 files changed, 3319 insertions(+), 2007 deletions(-)


