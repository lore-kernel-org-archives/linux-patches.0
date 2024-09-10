Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BA518CBE6;
	Tue, 10 Sep 2024 10:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962770; cv=none; b=SZHbydpeDHeAXVWIfEGgxY6TkUIi8vOuPj8LTuV5TKMqCxC2wr0sxmdNgWevlmKbS52mrH4pCoY1hRQTI97pgGLakz1u03meUDBiazJoDKJGH8aHVDV2UYZC4S1LT4e8w97Wp3GylUkeewYOosDuxq1ImG8AjkQlwWHcwSpATlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962770; c=relaxed/simple;
	bh=EnQxpQmo1hCafic6lC3ZaxAtknAonfIF/6N40+s3qh8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=W74qSRwuLVnmkfRflpWRiTvRnAaay8gE0pU8VGpkzhLRs8XOFnuiBcpicVxKHDe85ygT47+uHBQtIbF2Fp4K89FgIYM4ehltz2ApqRZ6RsixImJurbn4LfJRz5V0Akc0LzdpU4RSMUjz9AoHA9oDwu5/KAGo3IwQ3sW0G7+NMKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jF1+82OP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jF1+82OP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C1AC4CEC3;
	Tue, 10 Sep 2024 10:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962770;
	bh=EnQxpQmo1hCafic6lC3ZaxAtknAonfIF/6N40+s3qh8=;
	h=From:To:Cc:Subject:Date:From;
	b=jF1+82OP4YucDq7lBmeZnvFVFp/mlhOxMawOImsPdVaiWt1lwy/OB71b5XK5OPjmf
	 rv4MrUam7H1s0/9H8h2cy00JpRUAGETtDbYEyeJAgN5msf78tX348dYapPsfPReH8Y
	 6q0HyCXIJCebfX5jezWzDifmaogRyxqXgoAnNi74=
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
Subject: [PATCH 6.1 000/192] 6.1.110-rc1 review
Date: Tue, 10 Sep 2024 11:30:24 +0200
Message-ID: <20240910092557.876094467@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.110-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.110-rc1
X-KernelTest-Deadline: 2024-09-12T09:26+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.110 release.
There are 192 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.110-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.110-rc1

Miklos Szeredi <mszeredi@redhat.com>
    fuse: add feature flag for expire-only

Peng Wu <wupeng58@huawei.com>
    regulator: of: fix a NULL vs IS_ERR() check in of_regulator_bulk_get_all()

Shakeel Butt <shakeel.butt@linux.dev>
    memcg: protect concurrent access to mem_cgroup_idr

Yonghong Song <yhs@fb.com>
    bpf: Silence a warning in btf_type_id_size()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race between direct IO write and fsync when using same fd

Thomas Gleixner <tglx@linutronix.de>
    x86/mm: Fix PTI for i386 some more

Li Nan <linan122@huawei.com>
    ublk_drv: fix NULL pointer dereference in ublk_ctrl_start_recovery()

Liao Chen <liaochen4@huawei.com>
    gpio: modepin: Enable module autoloading

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    gpio: rockchip: fix OF node leak in probe()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    drm/i915/fence: Mark debug_fence_free() with __maybe_unused

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    drm/i915/fence: Mark debug_fence_init_onstack() with __maybe_unused

Matteo Martelli <matteomartelli3@gmail.com>
    ASoC: sunxi: sun4i-i2s: fix LRCLK polarity in i2s mode

Chen-Yu Tsai <wenst@chromium.org>
    ASoc: SOF: topology: Clear SOF link platform name upon unload

Maurizio Lombardi <mlombard@redhat.com>
    nvmet-tcp: fix kernel crash if commands allocation fails

Mohan Kumar <mkumard@nvidia.com>
    ASoC: tegra: Fix CBB error during probe()

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/64e: Define mmu_pte_psize static

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64e: split out nohash Book3E 64-bit code

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64e: remove unused IBM HTW code

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

Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>
    net: mana: Fix error handling in mana_create_txq/rxq's NAPI cleanup

Jann Horn <jannh@google.com>
    userfaultfd: fix checks for huge PMDs

Peter Zijlstra <peterz@infradead.org>
    mm: Rename pmd_read_atomic()

Peter Zijlstra <peterz@infradead.org>
    mm: Fix pmd_read_atomic()

Peter Zijlstra <peterz@infradead.org>
    x86/mm/pae: Make pmd_t similar to pte_t

yangyun <yangyun50@huawei.com>
    fuse: fix memory leak in fuse_create_open

Miklos Szeredi <mszeredi@redhat.com>
    fuse: add request extension

Dharmendra Singh <dsingh@ddn.com>
    fuse: allow non-extending parallel direct writes on the same file

Miklos Szeredi <mszeredi@redhat.com>
    fuse: add "expire only" mode to FUSE_NOTIFY_INVAL_ENTRY

Boqun Feng <boqun.feng@gmail.com>
    rust: macros: provide correct provenance when constructing THIS_MODULE

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

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    tcp: process the 3rd ACK with sk_socket for TFO/MPTCP

Michal Koutný <mkoutny@suse.com>
    io_uring/sqpoll: Do not set PF_NO_SETAFFINITY on sqpoll threads

Jens Axboe <axboe@kernel.dk>
    io_uring/io-wq: stop setting PF_NO_SETAFFINITY on io-wq workers

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: check re-re-adding ID 0 signal

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: validate event numbers

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: fix backport issues

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Add missing rescheduling points in nfs_client_return_marked_delegations

Michael Ellerman <mpe@ellerman.id.au>
    ata: pata_macio: Use WARN instead of BUG

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

Zenghui Yu <yuzenghui@huawei.com>
    kselftests: dmabuf-heaps: Ensure the driver name is null-terminated

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i3c: mipi-i3c-hci: Error out instead on BUG_ON() in IBI DMA setup

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dpaa: avoid on-stack arrays of NR_CPUS elements

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Don't drop SYN+ACK for simultaneous connect().

Dan Williams <dan.j.williams@intel.com>
    PCI: Add missing bridge lock to pci_bus_lock()

yang.zhang <yang.zhang@hexintek.com>
    riscv: set trap vector earlier

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

Sascha Hauer <s.hauer@pengutronix.de>
    wifi: mwifiex: Do not return unused priv in mwifiex_get_priv_by_id()

Yicong Yang <yangyicong@hisilicon.com>
    dma-mapping: benchmark: Don't starve others when doing the test

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: fix possible tid_t sequence overflows

Yifan Zha <Yifan.Zha@amd.com>
    drm/amdgpu: Set no_hw_access when VF request full GPU fails

Andreas Ziegler <ziegler.andreas@siemens.com>
    libbpf: Add NULL checks to bpf_object__{prev_map,next_map}

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

Pawel Dembicki <paweldembicki@gmail.com>
    net: dsa: vsc73xx: fix possible subblocks range of CAPT block

Jonas Gorski <jonas.gorski@bisdn.de>
    net: bridge: br_fdb_external_learn_add(): always set EXT_LEARN

Kuniyuki Iwashima <kuniyu@amazon.com>
    fou: Fix null-ptr-deref in GRO.

Guillaume Nault <gnault@redhat.com>
    bareudp: Fix device stats updates.

Oliver Neukum <oneukum@suse.com>
    usbnet: modern method to get random MAC

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: do not bring the VSI up, if it was down before the XDP setup

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: allow hot-swapping XDP programs

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: Use ice_max_xdp_frame_size() in ice_xdp_setup_prog()

Dan Carpenter <dan.carpenter@linaro.org>
    igc: Unlock on error in igc_io_resume()

Douglas Anderson <dianders@chromium.org>
    regulator: core: Stub devm_regulator_bulk_get_const() if !CONFIG_REGULATOR

Corentin Labbe <clabbe@baylibre.com>
    regulator: Add of_regulator_bulk_get_all

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

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vivid: don't set HDMI TX controls if there are no HDMI outputs

Danijel Slivka <danijel.slivka@amd.com>
    drm/amdgpu: clear RB_OVERFLOW bit when enabling interrupts

Hawking Zhang <Hawking.Zhang@amd.com>
    drm/amdgpu: Fix smatch static checker warning

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check HDCP returned status

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

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: One more reason to mark inode bad

Jan Kara <jack@suse.cz>
    udf: Avoid excessive partition lengths

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

Alexey Dobriyan <adobriyan@gmail.com>
    ELF: fix kernel.randomize_va_space double read

Konstantin Andreev <andreev@swemel.ru>
    smack: unix sockets: fix accept()ed socket label

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Add input value sanity checks to HDMI channel map controls

Takashi Iwai <tiwai@suse.de>
    ALSA: control: Apply sanity check of input values for user elements

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

Mitchell Levy <levymitchell0@gmail.com>
    x86/fpu: Avoid writing LBR bit to IA32_XSS unless supported

Matt Johnston <matt@codeconstruct.com.au>
    net: mctp-serial: Fix missing escapes on transmit

Zheng Yejian <zhengyejian@huaweicloud.com>
    tracing: Avoid possible softlockup in tracing_iter_reset()

Brian Norris <briannorris@chromium.org>
    spi: rockchip: Resolve unbalanced runtime PM / system PM handling

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

Stephen Hemminger <stephen@networkplumber.org>
    sch/netem: fix use after free in netem_dequeue


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/include/asm/acpi.h                      |  12 +
 arch/arm64/kernel/acpi_numa.c                      |  11 -
 arch/mips/kernel/cevt-r4k.c                        |  15 +-
 arch/powerpc/include/asm/nohash/mmu-e500.h         |   3 +-
 arch/powerpc/mm/nohash/Makefile                    |   2 +-
 arch/powerpc/mm/nohash/tlb.c                       | 398 +--------------------
 arch/powerpc/mm/nohash/tlb_64e.c                   | 361 +++++++++++++++++++
 arch/powerpc/mm/nohash/tlb_low_64e.S               | 195 ----------
 arch/riscv/kernel/head.S                           |   3 +
 arch/s390/kernel/vmlinux.lds.S                     |   9 +
 arch/um/drivers/line.c                             |   2 +
 arch/x86/coco/tdx/tdx.c                            |   1 -
 arch/x86/events/intel/core.c                       |  23 +-
 arch/x86/include/asm/fpu/types.h                   |   7 +
 arch/x86/include/asm/page_64.h                     |   1 +
 arch/x86/include/asm/pgtable-3level.h              |  96 +----
 arch/x86/include/asm/pgtable-3level_types.h        |   7 +
 arch/x86/include/asm/pgtable_64_types.h            |   5 +
 arch/x86/include/asm/pgtable_types.h               |   4 +-
 arch/x86/kernel/fpu/xstate.c                       |   3 +
 arch/x86/kernel/fpu/xstate.h                       |   4 +-
 arch/x86/kvm/svm/svm.c                             |  15 +
 arch/x86/kvm/x86.c                                 |   2 +
 arch/x86/lib/iomem.c                               |   5 +-
 arch/x86/mm/init_64.c                              |   4 +
 arch/x86/mm/kaslr.c                                |  34 +-
 arch/x86/mm/pti.c                                  |  45 ++-
 drivers/acpi/acpi_processor.c                      |  15 +-
 drivers/android/binder.c                           |   1 +
 drivers/ata/libata-core.c                          |   4 +-
 drivers/ata/pata_macio.c                           |   7 +-
 drivers/base/devres.c                              |   1 +
 drivers/block/ublk_drv.c                           |   2 +
 drivers/clk/qcom/clk-alpha-pll.c                   |  25 +-
 drivers/clocksource/timer-imx-tpm.c                |  16 +-
 drivers/clocksource/timer-of.c                     |  17 +-
 drivers/clocksource/timer-of.h                     |   1 -
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c      |   4 +-
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |   8 +-
 drivers/firmware/cirrus/cs_dsp.c                   |   3 +
 drivers/gpio/gpio-rockchip.c                       |   1 +
 drivers/gpio/gpio-zynqmp-modepin.c                 |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c        |  30 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c           |   4 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/ih_v6_0.c               |  28 ++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   2 +-
 .../drm/amd/display/modules/hdcp/hdcp1_execution.c |  15 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   6 +-
 drivers/gpu/drm/i915/i915_sw_fence.c               |   8 +-
 drivers/hid/amd-sfh-hid/amd_sfh_hid.c              |   4 +-
 drivers/hid/hid-cougar.c                           |   2 +-
 drivers/hv/vmbus_drv.c                             |   1 +
 drivers/hwmon/adc128d818.c                         |   4 +-
 drivers/hwmon/lm95234.c                            |   9 +-
 drivers/hwmon/nct6775-core.c                       |   2 +-
 drivers/hwmon/w83627ehf.c                          |   4 +-
 drivers/i3c/master/mipi-i3c-hci/dma.c              |   5 +-
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
 drivers/misc/vmw_vmci/vmci_resource.c              |   3 +-
 drivers/mmc/core/quirks.h                          |  22 +-
 drivers/mmc/core/sd.c                              |   4 +
 drivers/mmc/host/cqhci-core.c                      |   2 +-
 drivers/mmc/host/dw_mmc.c                          |   4 +-
 drivers/mmc/host/sdhci-of-aspeed.c                 |   1 +
 drivers/net/bareudp.c                              |  22 +-
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
 drivers/net/ethernet/intel/ice/ice_main.c          |  61 ++--
 drivers/net/ethernet/intel/igb/igb_main.c          |  10 +
 drivers/net/ethernet/intel/igc/igc_main.c          |   1 +
 drivers/net/ethernet/microsoft/mana/mana.h         |   2 +
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  22 +-
 drivers/net/mctp/mctp-serial.c                     |   4 +-
 drivers/net/usb/ipheth.c                           |   2 +-
 drivers/net/usb/usbnet.c                           |  11 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |   1 +
 drivers/net/wireless/marvell/mwifiex/main.h        |   3 +
 drivers/nvme/host/pci.c                            |  11 +
 drivers/nvme/target/tcp.c                          |   4 +-
 drivers/nvmem/core.c                               |   6 +-
 drivers/of/irq.c                                   |  15 +-
 drivers/pci/controller/dwc/pci-keystone.c          |  44 ++-
 drivers/pci/hotplug/pnv_php.c                      |   3 +-
 drivers/pci/pci.c                                  |  35 +-
 drivers/pcmcia/yenta_socket.c                      |   6 +-
 drivers/phy/xilinx/phy-zynqmp.c                    |   1 +
 drivers/platform/x86/dell/dell-smbios-base.c       |   5 +-
 drivers/regulator/of_regulator.c                   |  92 +++++
 drivers/spi/spi-rockchip.c                         |  23 +-
 drivers/staging/iio/frequency/ad9834.c             |   2 +-
 drivers/uio/uio_hv_generic.c                       |  11 +-
 drivers/usb/dwc3/core.c                            |  15 +
 drivers/usb/dwc3/core.h                            |   2 +
 drivers/usb/gadget/udc/aspeed_udc.c                |   2 +
 drivers/usb/storage/uas.c                          |   1 +
 fs/binfmt_elf.c                                    |   5 +-
 fs/btrfs/ctree.c                                   |  12 +-
 fs/btrfs/ctree.h                                   |   1 -
 fs/btrfs/extent-tree.c                             |  32 +-
 fs/btrfs/file.c                                    |  25 +-
 fs/btrfs/inode.c                                   |   2 +-
 fs/btrfs/transaction.h                             |   6 +
 fs/ext4/fast_commit.c                              |   8 +-
 fs/fuse/dev.c                                      |   6 +-
 fs/fuse/dir.c                                      |  72 ++--
 fs/fuse/file.c                                     |  51 ++-
 fs/fuse/fuse_i.h                                   |   8 +-
 fs/fuse/inode.c                                    |   3 +-
 fs/fuse/xattr.c                                    |   4 +-
 fs/nfs/super.c                                     |   2 +
 fs/nilfs2/recovery.c                               |  35 +-
 fs/nilfs2/segment.c                                |  10 +-
 fs/nilfs2/sysfs.c                                  |  43 ++-
 fs/ntfs3/dir.c                                     |  52 +--
 fs/ntfs3/frecord.c                                 |   4 +-
 fs/smb/client/smb2ops.c                            |  16 +-
 fs/smb/server/smb2pdu.c                            |   4 +
 fs/smb/server/transport_tcp.c                      |   4 +-
 fs/squashfs/inode.c                                |   7 +-
 fs/udf/super.c                                     |  15 +
 include/linux/mm.h                                 |   4 +
 include/linux/pgtable.h                            |  54 ++-
 include/linux/regulator/consumer.h                 |  16 +
 include/net/bluetooth/hci_core.h                   |   5 -
 include/uapi/drm/drm_fourcc.h                      |  18 +
 include/uapi/linux/fuse.h                          |  46 ++-
 io_uring/io-wq.c                                   |  16 +-
 io_uring/sqpoll.c                                  |   1 -
 kernel/bpf/btf.c                                   |  13 +-
 kernel/cgroup/cgroup.c                             |   2 +-
 kernel/dma/map_benchmark.c                         |  16 +
 kernel/events/core.c                               |  18 +-
 kernel/events/internal.h                           |   1 +
 kernel/events/ring_buffer.c                        |   2 +
 kernel/events/uprobes.c                            |   3 +-
 kernel/locking/rtmutex.c                           |   9 +-
 kernel/resource.c                                  |   6 +-
 kernel/smp.c                                       |   1 +
 kernel/trace/trace.c                               |   2 +
 kernel/workqueue.c                                 |  14 +-
 lib/generic-radix-tree.c                           |   2 +
 mm/hmm.c                                           |   2 +-
 mm/khugepaged.c                                    |   2 +-
 mm/mapping_dirty_helpers.c                         |   2 +-
 mm/memcontrol.c                                    |  22 +-
 mm/memory_hotplug.c                                |   2 +-
 mm/mprotect.c                                      |   2 +-
 mm/sparse.c                                        |   2 +-
 mm/userfaultfd.c                                   |  24 +-
 mm/vmscan.c                                        |   4 +-
 net/bluetooth/mgmt.c                               |  60 ++--
 net/bluetooth/smp.c                                |   7 -
 net/bridge/br_fdb.c                                |   6 +-
 net/can/bcm.c                                      |   4 +
 net/ipv4/fou.c                                     |  29 +-
 net/ipv4/tcp_bpf.c                                 |   2 +-
 net/ipv4/tcp_input.c                               |   6 +
 net/ipv6/ila/ila.h                                 |   1 +
 net/ipv6/ila/ila_main.c                            |   6 +
 net/ipv6/ila/ila_xlat.c                            |  13 +-
 net/netfilter/nf_conncount.c                       |   8 +-
 net/sched/sch_cake.c                               |  11 +-
 net/sched/sch_netem.c                              |   9 +-
 net/unix/af_unix.c                                 |   9 +-
 rust/Makefile                                      |   4 +-
 rust/macros/module.rs                              |   6 +-
 security/smack/smack_lsm.c                         |  12 +-
 sound/core/control.c                               |   6 +-
 sound/hda/hdmi_chmap.c                             |  18 +
 sound/pci/hda/patch_conexant.c                     |  11 +
 sound/pci/hda/patch_realtek.c                      |  10 +
 sound/soc/soc-dapm.c                               |   1 +
 sound/soc/soc-topology.c                           |   2 +
 sound/soc/sof/topology.c                           |   2 +
 sound/soc/sunxi/sun4i-i2s.c                        | 143 ++++----
 sound/soc/tegra/tegra210_ahub.c                    |  12 +-
 tools/lib/bpf/libbpf.c                             |   4 +-
 tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c |   4 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    | 234 ++++++++----
 tools/testing/selftests/net/mptcp/mptcp_lib.sh     |  15 +
 208 files changed, 2369 insertions(+), 1522 deletions(-)


