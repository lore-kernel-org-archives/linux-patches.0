Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D745227E95;
	Tue, 29 Apr 2025 18:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950261; cv=none; b=n1WswClBuaKoIrdnnLAiksXTmOpvxW5vtOdgDgWsU2av6OBOtTMU3V3f2+oS3VmtZrlCKmJbjtOQAcvtfzvbPeSEzJ4k78SwaVUNdOa4zh41h8u7jka3Q/ytO+X28E0WW5jRyh1PaGSbpSbriBGLfLZ75DYxHX3nIAWCA1gDvyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950261; c=relaxed/simple;
	bh=gQcjohJti4bOtH1zcqXd9k9Ya2cbmgDY5V/l00QfBKo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KIoaK+UCG43dtloGZ+3GyOY5Zpe7r0JW9X9DeaLu5pAWIBoJ0dYDMN0jcGTtr0tFxVeAOm2xXEPl4h5gqxakB1h7GNyPzVUGL+smFbwF/HIETsBiUoMmaGEP4SzLT9WRuevfgx0/BZSlAnz4XG5I1YJo2D82SbaJRm0m92QFhf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGmxEKhi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGmxEKhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86160C4CEE3;
	Tue, 29 Apr 2025 18:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950261;
	bh=gQcjohJti4bOtH1zcqXd9k9Ya2cbmgDY5V/l00QfBKo=;
	h=From:To:Cc:Subject:Date:From;
	b=bGmxEKhiwXqpAAp2LD/I3vkj6HS/WKOrmcSTkabk4Kdjh74KrpJd2p61cbAPqX0hp
	 4ZvnZb2QDETsL52z/2sPIJcXBOzvt+nv/xnb4rJhmcuvyM2WI24hh1tXJpGRPUlpQ9
	 GnbwaGRd6+h/WaZj6B/ltcD4rVKDBous68as4Uao=
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
Subject: [PATCH 6.6 000/204] 6.6.89-rc1 review
Date: Tue, 29 Apr 2025 18:41:28 +0200
Message-ID: <20250429161059.396852607@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.89-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.89-rc1
X-KernelTest-Deadline: 2025-05-01T16:11+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.89 release.
There are 204 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.89-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.89-rc1

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Silence more KCOV warnings, part 2

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Ignore end-of-section jumps for KCOV/GCOV

Hannes Reinecke <hare@kernel.org>
    nvme: fixup scan failure for non-ANA multipath controllers

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    MIPS: cm: Fix warning if MIPS_CM is disabled

Robin Murphy <robin.murphy@arm.com>
    iommu: Handle race with default domain setup

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: enable STU methods for 6320 family

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: enable .port_set_policy() for 6320 family

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: enable PVT for 6321 switch

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: fix atu_move_port_mask for 6341 family

Baokun Li <libaokun1@huawei.com>
    ext4: goto right label 'out_mmap_sem' in ext4_setattr()

Ian Abbott <abbotti@mev.co.uk>
    comedi: jr3_pci: Fix synchronous deletion of timer

Daniel Borkmann <daniel@iogearbox.net>
    vmxnet3: Fix malformed packet sizing in vmxnet3_process_xdp

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    driver core: fix potential NULL pointer dereference in dev_uevent()

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    driver core: introduce device_set_driver() helper

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Revert "drivers: core: synchronize really_probe() and dev_uevent()"

Ard Biesheuvel <ardb@kernel.org>
    x86/pvh: Call C code via the kernel virtual mapping

Tamura Dai <kirinode0@gmail.com>
    spi: spi-imx: Add check for spi_imx_setupxfer()

Meir Elisha <meir.elisha@volumez.com>
    md/raid1: Add check for missing source disk in process_checks()

Pi Xiange <xiange.pi@intel.com>
    x86/cpu: Add CPU model number for Bartlett Lake CPUs with Raptor Cove cores

Mostafa Saleh <smostafa@google.com>
    ubsan: Fix panic from test_ubsan_out_of_bounds

Breno Leitao <leitao@debian.org>
    spi: tegra210-quad: add rate limiting and simplify timeout error message

Breno Leitao <leitao@debian.org>
    spi: tegra210-quad: use WARN_ON_ONCE instead of WARN_ON for timeouts

Yunlong Xing <yunlong.xing@unisoc.com>
    loop: aio inherit the ioprio of original request

Andrew Jones <ajones@ventanamicro.com>
    riscv: Provide all alternative macros all the time

Gou Hao <gouhao@uniontech.com>
    iomap: skip unnecessary ifs_block_is_uptodate check

Fernando Fernandez Mancera <ffmancera@riseup.net>
    x86/i8253: Call clockevent_i8253_disable() with interrupts disabled

Igor Pylypiv <ipylypiv@google.com>
    scsi: pm80xx: Set phy_attached to zero when device is gone

Peter Griffin <peter.griffin@linaro.org>
    scsi: ufs: exynos: Ensure pre_link() executes before exynos_ufs_phy_init()

Xingui Yang <yangxingui@huawei.com>
    scsi: hisi_sas: Fix I/O errors caused by hardware port ID changes

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: make block validity check resistent to sb bh corruption

Pali Rohár <pali@kernel.org>
    cifs: Fix querying of WSL CHR and BLK reparse points over SMB1

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    timekeeping: Add a lockdep override in tick_freeze()

Pali Rohár <pali@kernel.org>
    cifs: Fix encoding of SMB1 Session Setup Kerberos Request in non-UNICODE mode

Daniel Wagner <wagi@kernel.org>
    nvmet-fc: put ref when assoc->del_work is already scheduled

Daniel Wagner <wagi@kernel.org>
    nvmet-fc: take tgtport reference only once

Josh Poimboeuf <jpoimboe@kernel.org>
    x86/bugs: Don't fill RSB on context switch with eIBRS

Josh Poimboeuf <jpoimboe@kernel.org>
    x86/bugs: Don't fill RSB on VMEXIT with eIBRS+retpoline

Josh Poimboeuf <jpoimboe@kernel.org>
    x86/bugs: Use SBPB in write_ibpb() if applicable

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    selftests/mincore: Allow read-ahead pages to reach the end of the file

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpiolib: of: Move Atmel HSMCI quirk up out of the regulator comment

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Stop UNRET validation on UD2

Uday Shankar <ushankar@purestorage.com>
    nvme: multipath: fix return value of nvme_available_path

Hannes Reinecke <hare@kernel.org>
    nvme: re-read ANA log page after ns scan completes

Jean-Marc Eurin <jmeurin@google.com>
    ACPI PPTT: Fix coding mistakes in a couple of sizeof() calls

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: EC: Set ec_no_wakeup for Lenovo Go S

Hannes Reinecke <hare@kernel.org>
    nvme: requeue namespace scan on missed AENs

Jason Andryuk <jason.andryuk@amd.com>
    xen: Change xen-acpi-processor dom0 dependency

Gabriel Shahrouzi <gshahrouzi@gmail.com>
    perf/core: Fix WARN_ON(!ctx) in __free_event() for partial init

Ming Lei <ming.lei@redhat.com>
    selftests: ublk: fix test_stripe_04

Xiaogang Chen <xiaogang.chen@amd.com>
    udmabuf: fix a buf size overflow issue during udmabuf creation

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    KVM: s390: Don't use %pK through debug printing

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    KVM: s390: Don't use %pK through tracepoints

Oleg Nesterov <oleg@redhat.com>
    sched/isolation: Make CONFIG_CPU_ISOLATION depend on CONFIG_SMP

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: always do atomic put from iowq

Lukas Stockmann <lukas.stockmann@siemens.com>
    rtc: pcf85063: do a SW reset if POR failed

Dominique Martinet <asmadeus@codewreck.org>
    9p/net: fix improper handling of bogus negative read/write replies

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    ntb_hw_amd: Add NTB PCI ID for new gen CPU

Arnd Bergmann <arnd@arndb.de>
    ntb: reduce stack usage in idt_scan_mws

Al Viro <viro@zeniv.linux.org.uk>
    qibfs: fix _another_ leak

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool, lkdtm: Obfuscate the do_nothing() pointer

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool, regulator: rk808: Remove potential undefined behavior in rk806_set_mode_dcdc()

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool, ASoC: codecs: wcd934x: Remove potential undefined behavior in wcd934x_slim_irq_handler()

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool, panic: Disable SMAP in __stack_chk_fail()

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Silence more KCOV warnings

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Scan retimers after device router has been enumerated

Théo Lebrun <theo.lebrun@bootlin.com>
    usb: host: xhci-plat: mvebu: use ->quirks instead of ->init_quirk() func

Chenyuan Yang <chenyuan0y@gmail.com>
    usb: gadget: aspeed: Add NULL pointer check in ast_vhub_init_dev()

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Avoid Stop Endpoint retry loop if the endpoint seems Running

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    dmaengine: dmatest: Fix dmatest waiting less when interrupted

John Stultz <jstultz@google.com>
    sound/virtio: Fix cancel_sync warnings on uninitialized work_structs

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: dwc3: gadget: Avoid using reserved endpoints on Intel Merrifield

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: dwc3: gadget: Refactor loop to avoid NULL endpoints

Edward Adam Davis <eadavis@qq.com>
    fs/ntfs3: Fix WARNING in ntfs_extend_initialized_size

Alexander Stein <alexander.stein@mailbox.org>
    usb: host: max3421-hcd: Add missing spi_device_id table

Sudeep Holla <sudeep.holla@arm.com>
    mailbox: pcc: Always clear the platform ack interrupt first

Huisong Li <lihuisong@huawei.com>
    mailbox: pcc: Fix the possible race in updation of chan_in_use flag

Yafang Shao <laoar.shao@gmail.com>
    bpf: Reject attaching fexit/fmod_ret to __noreturn functions

Martin KaFai Lau <martin.lau@kernel.org>
    bpf: Only fails the busy counter check in bpf_cgrp_storage_get if it creates storage

Sewon Nam <swnam0729@gmail.com>
    bpf: bpftool: Setting error code in do_loader()

Haoxiang Li <haoxiang_li2024@163.com>
    s390/tty: Fix a potential memory leak bug

Haoxiang Li <haoxiang_li2024@163.com>
    s390/sclp: Add check for get_zeroed_page()

Yu-Chun Lin <eleanor15x@gmail.com>
    parisc: PDT: Fix missing prototype warning

Heiko Stuebner <heiko@sntech.de>
    clk: check for disabled clock-provider in of_clk_get_hw_from_clkspec()

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix deadlock between rcu_tasks_trace and event_mutex.

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: null - Use spin lock instead of mutex

Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
    crypto: ccp - Add support for PCI device 0x1134

Gregory CLEMENT <gregory.clement@bootlin.com>
    MIPS: cm: Detect CM quirks from device tree

Chenyuan Yang <chenyuan0y@gmail.com>
    pinctrl: renesas: rza2: Fix potential NULL pointer dereference

Oliver Neukum <oneukum@suse.com>
    USB: wdm: add annotation

Oliver Neukum <oneukum@suse.com>
    USB: wdm: wdm_wwan_port_tx_complete mutex in atomic context

Oliver Neukum <oneukum@suse.com>
    USB: wdm: close race between wdm_open and wdm_wwan_port_stop

Oliver Neukum <oneukum@suse.com>
    USB: wdm: handle IO errors in wdm_wwan_port_start

Oliver Neukum <oneukum@suse.com>
    USB: VLI disk crashes if LPM is used

Miao Li <limiao@kylinos.cn>
    usb: quirks: Add delay init quirk for SanDisk 3.2Gen1 Flash Drive

Miao Li <limiao@kylinos.cn>
    usb: quirks: add DELAY_INIT quirk for Silicon Motion Flash Drive

Mike Looijmans <mike.looijmans@topic.nl>
    usb: dwc3: xilinx: Prevent spike in reset signal

Frode Isaksen <frode@meta.com>
    usb: dwc3: gadget: check that event count does not exceed event buffer length

Huacai Chen <chenhuacai@kernel.org>
    USB: OHCI: Add quirk for LS7A OHCI controller (rev 0x02)

Fedor Pchelkin <pchelkin@ispras.ru>
    usb: chipidea: ci_hdrc_imx: implement usb_phy_init() error handling

Fedor Pchelkin <pchelkin@ispras.ru>
    usb: chipidea: ci_hdrc_imx: fix call balance of regulator routines

Fedor Pchelkin <pchelkin@ispras.ru>
    usb: chipidea: ci_hdrc_imx: fix usbmisc handling

Ralph Siemsen <ralph.siemsen@linaro.org>
    usb: cdns3: Fix deadlock when using NCM gadget

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Fix invalid pointer dereference in Etron workaround

Craig Hesling <craig@hesling.com>
    USB: serial: simple: add OWON HDS200 series oscilloscope support

Adam Xue <zxue@semtech.com>
    USB: serial: option: add Sierra Wireless EM9291

Michael Ehrenreich <michideep@gmail.com>
    USB: serial: ftdi_sio: add support for Abacus Electrics Optical Probe

Ryo Takakura <ryotkkr98@gmail.com>
    serial: sifive: lock port in startup()/shutdown() callbacks

Stephan Gerhold <stephan.gerhold@linaro.org>
    serial: msm: Configure correct working mode before starting earlycon

Rengarajan S <rengarajan.s@microchip.com>
    misc: microchip: pci1xxxx: Fix incorrect IRQ status handling during ack

Rengarajan S <rengarajan.s@microchip.com>
    misc: microchip: pci1xxxx: Fix Kernel panic during IRQ handler registration

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    char: misc: register chrdev region with all possible minors

Sean Christopherson <seanjc@google.com>
    KVM: x86: Reset IRTE to host control if *new* route isn't postable

Sean Christopherson <seanjc@google.com>
    KVM: x86: Explicitly treat routing entry type changes as changes

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add panther lake H DID

Damien Le Moal <dlemoal@kernel.org>
    scsi: Improve CDL control

Oliver Neukum <oneukum@suse.com>
    USB: storage: quirk for ADATA Portable HDD CH94

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: Fix ata_msense_control_ata_feature()

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: Fix ata_mselect_control_ata_feature() return type

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: Improve CDL control

Haoxiang Li <haoxiang_li2024@163.com>
    mcb: fix a double free bug in chameleon_parse_gdd()

Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
    cxl/core/regs.c: Skip Memory Space Enable check for RCD and RCH Ports

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Allocate IR data using atomic allocation

Jens Axboe <axboe@kernel.dk>
    io_uring: fix 'sync' handling of io_fallback_tw()

Petr Tesarik <ptesarik@suse.com>
    LoongArch: Remove a bogus reference to ZONE_DMA

Ming Wang <wangming01@loongson.cn>
    LoongArch: Return NULL from huge_pte_offset() for invalid PMD

Suzuki K Poulose <suzuki.poulose@arm.com>
    irqchip/gic-v2m: Prevent use after free of gicv2m_get_fwnode()

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Force full update in gpu reset

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Fix gpu reset in multidisplay config

Fiona Klute <fiona.klute@gmx.de>
    net: phy: microchip: force IRQ polling mode for lan88xx

Oleksij Rempel <o.rempel@pengutronix.de>
    net: selftests: initialize TCP header and skb payload with zero

Alexey Nepomnyashih <sdl@nppct.ru>
    xen-netfront: handle NULL returned by xdp_convert_buff_to_frame()

Marek Behún <kabel@kernel.org>
    crypto: atmel-sha204a - Set hwrng quality to lowest possible

Halil Pasic <pasic@linux.ibm.com>
    virtio_console: fix missing byte order handling for cols and rows

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Make do_xyz() exception handlers more robust

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Make regs_irqs_disabled() more clear

Yuli Wang <wangyuli@uniontech.com>
    LoongArch: Select ARCH_USE_MEMTEST

Luo Gengkun <luogengkun@huaweicloud.com>
    perf/x86: Fix non-sampling (counting) events on certain x86 platforms

T.J. Mercier <tjmercier@google.com>
    splice: remove duplicate noinline from pipe_clear_nowait

Björn Töpel <bjorn@rivosinc.com>
    riscv: uprobes: Add missing fence.i after building the XOL buffer

Sean Christopherson <seanjc@google.com>
    iommu/amd: Return an error if vCPU affinity is set for non-vCPU IRTE

Shannon Nelson <shannon.nelson@amd.com>
    pds_core: make wait_context part of q_info

Brett Creeley <brett.creeley@amd.com>
    pds_core: Remove unnecessary check in pds_client_adminq_cmd()

Brett Creeley <brett.creeley@amd.com>
    pds_core: handle unsupported PDS_CORE_CMD_FW_CONTROL result

Daniel Golle <daniel@makrotopia.org>
    net: dsa: mt7530: sync driver-specific behavior of MT7531 variants

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: hfsc: Fix a potential UAF in hfsc_dequeue() too

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: hfsc: Fix a UAF vulnerability in class handling

Al Viro <viro@zeniv.linux.org.uk>
    fix a couple of races in MNT_TREE_BENEATH handling by do_move_mount()

Bo-Cun Chen <bc-bocun.chen@mediatek.com>
    net: ethernet: mtk_eth_soc: net: revise NETSYSv3 hardware configuration

Tung Nguyen <tung.quang.nguyen@est.tech>
    tipc: fix NULL pointer dereference in tipc_mon_reinit_self()

Qingfang Deng <qingfang.deng@siflower.com.cn>
    net: phy: leds: fix memory leak

Justin Iurman <justin.iurman@uliege.be>
    net: lwtunnel: disable BHs when required

Anastasia Kovaleva <a.kovaleva@yadro.com>
    scsi: core: Clear flags for scsi_cmnd that did not complete

Qu Wenruo <wqu@suse.com>
    btrfs: avoid page_lockend underflow in btrfs_punch_hole_lock_range()

Marc Zyngier <maz@kernel.org>
    cpufreq: cppc: Fix invalid return value in .get() callback

Chenyuan Yang <chenyuan0y@gmail.com>
    scsi: ufs: mcq: Add NULL check in ufshcd_mcq_abort()

Henry Martin <bsdhenrymartin@gmail.com>
    cpufreq: scpi: Fix null-ptr-deref in scpi_cpufreq_get_rate()

Henry Martin <bsdhenrymartin@gmail.com>
    cpufreq: scmi: Fix null-ptr-deref in scmi_cpufreq_get_rate()

Henry Martin <bsdhenrymartin@gmail.com>
    cpufreq: apple-soc: Fix null-ptr-deref in apple_soc_cpufreq_get_rate()

Arnd Bergmann <arnd@arndb.de>
    dma/contiguous: avoid warning about unused size_bytes

David Howells <dhowells@redhat.com>
    ceph: Fix incorrect flush end position calculation

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq/sched: Explicitly synchronize limits_changed flag handling

Vincent Guittot <vincent.guittot@linaro.org>
    sched/cpufreq: Rework schedutil governor performance estimation

Vincent Guittot <vincent.guittot@linaro.org>
    sched/topology: Consolidate and clean up access to a CPU's max compute capacity

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Support mmap() of PCI resources except for ISM devices

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Report PCI error recovery results via SCLP

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/sclp: Allow user-space to provide PCI reports for optical modules

Tudor Ambarus <tudor.ambarus@linaro.org>
    scsi: ufs: qcom: fix dev reference leaked through of_qcom_ice_get

David Hildenbrand <david@redhat.com>
    s390/virtio_ccw: Don't allocate/assign airqs for non-existing queues

Halil Pasic <pasic@linux.ibm.com>
    s390/virtio_ccw: fix virtual vs physical address confusion

Ma Ke <make24@iscas.ac.cn>
    PCI: Fix reference leak in pci_register_host_bridge()

Zijun Hu <quic_zijuhu@quicinc.com>
    of: resolver: Fix device node refcount leakage in of_resolve_phandles()

Rob Herring (Arm) <robh@kernel.org>
    of: resolver: Simplify of_resolve_phandles() using __free()

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    clk: renesas: r9a07g043: Fix HP clock source for RZ/Five

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    clk: renesas: r9a07g04[34]: Fix typo for sel_shdi variable

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    clk: renesas: r9a07g04[34]: Use SEL_SDHI1_STS status configuration for SD1 mux

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    clk: renesas: rzg2l: Refactor SD mux driver

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    clk: renesas: rzg2l: Remove CPG_SDHI_DSEL from generic header

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    clk: renesas: rzg2l: Add struct clk_hw_data

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    clk: renesas: rzg2l: Use u32 for flag and mux_flags

Ninad Malwade <nmalwade@nvidia.com>
    arm64: tegra: Remove the Orin NX/Nano suspend key

Sergiu Cuciurean <sergiu.cuciurean@analog.com>
    iio: adc: ad7768-1: Fix conversion result sign

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7768-1: Move setting of val a bit later to avoid unnecessary return value check

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: q6apm-dai: make use of q6apm_get_hw_pointer

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: qcom: Fix trivial code style issues

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    ASoC: qcom: lpass: Make asoc_qcom_lpass_cpu_platform_remove() return void

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: q6apm-dai: schedule all available frames to avoid dsp under-runs

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: qcom: q6apm-dai: drop unused 'q6apm_dai_rtd' fields

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: fix VTU methods for 6320 family

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: fix internal PHYs for 6320 family

Haoxiang Li <haoxiang_li2024@163.com>
    auxdisplay: hd44780: Fix an API misuse in hd44780.c

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    auxdisplay: hd44780: Convert to platform remove callback returning void

Tudor Ambarus <tudor.ambarus@linaro.org>
    mmc: sdhci-msm: fix dev reference leaked through of_qcom_ice_get

Tudor Ambarus <tudor.ambarus@linaro.org>
    soc: qcom: ice: introduce devm_of_qcom_ice_get

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    media: vimc: skip .s_stream() for stopped entities

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: subdev: Add v4l2_subdev_is_streaming()

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: subdev: Improve v4l2_subdev_enable/disable_streams_fallback

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: subdev: Fix use of sd->enabled_streams in call_s_stream()

Steven Rostedt <rostedt@goodmis.org>
    tracing: Verify event formats that have "%*p.."

Steven Rostedt <rostedt@goodmis.org>
    tracing: Add __print_dynamic_array() helper

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Add __string_len() example

Shuai Xue <xueshuai@linux.alibaba.com>
    x86/mce: use is_copy_from_user() to determine copy-from-user context

Tong Tiangen <tongtiangen@huawei.com>
    x86/extable: Remove unused fixup type EX_TYPE_COPY

Shakeel Butt <shakeel.butt@linux.dev>
    memcg: drain obj stock on cpu hotplug teardown

Thorsten Leemhuis <linux@leemhuis.info>
    module: sign with sha512 instead of sha1 by default


-------------

Diffstat:

 Documentation/scheduler/sched-capacity.rst         |  13 +-
 Makefile                                           |   4 +-
 .../arm64/boot/dts/nvidia/tegra234-p3768-0000.dtsi |   7 -
 arch/loongarch/Kconfig                             |   1 +
 arch/loongarch/include/asm/ptrace.h                |   4 +-
 arch/loongarch/kernel/traps.c                      |  20 ++-
 arch/loongarch/mm/hugetlbpage.c                    |   2 +-
 arch/loongarch/mm/init.c                           |   3 -
 arch/mips/include/asm/mips-cm.h                    |  22 +++
 arch/mips/kernel/mips-cm.c                         |  14 ++
 arch/parisc/kernel/pdt.c                           |   2 +
 arch/riscv/include/asm/alternative-macros.h        |  21 +--
 arch/riscv/kernel/probes/uprobes.c                 |  10 +-
 arch/s390/Kconfig                                  |   4 +-
 arch/s390/include/asm/pci.h                        |   3 +
 arch/s390/include/asm/sclp.h                       |  33 ++++
 arch/s390/kvm/intercept.c                          |   2 +-
 arch/s390/kvm/interrupt.c                          |   8 +-
 arch/s390/kvm/kvm-s390.c                           |  10 +-
 arch/s390/kvm/trace-s390.h                         |   4 +-
 arch/s390/pci/Makefile                             |   2 +-
 arch/s390/pci/pci_event.c                          |  21 ++-
 arch/s390/pci/pci_fixup.c                          |  23 +++
 arch/s390/pci/pci_report.c                         | 111 +++++++++++++
 arch/s390/pci/pci_report.h                         |  16 ++
 arch/x86/entry/entry.S                             |   2 +-
 arch/x86/events/core.c                             |   2 +-
 arch/x86/include/asm/asm.h                         |   3 -
 arch/x86/include/asm/extable_fixup_types.h         |   2 +-
 arch/x86/include/asm/intel-family.h                |   2 +
 arch/x86/kernel/cpu/bugs.c                         |  36 ++---
 arch/x86/kernel/cpu/mce/severity.c                 |  12 +-
 arch/x86/kernel/i8253.c                            |   3 +-
 arch/x86/kvm/svm/avic.c                            |  60 +++----
 arch/x86/kvm/vmx/posted_intr.c                     |  28 ++--
 arch/x86/kvm/x86.c                                 |   3 +-
 arch/x86/mm/extable.c                              |   9 --
 arch/x86/mm/tlb.c                                  |   6 +-
 arch/x86/platform/pvh/head.S                       |   7 +-
 crypto/crypto_null.c                               |  37 +++--
 drivers/acpi/ec.c                                  |  28 ++++
 drivers/acpi/pptt.c                                |   4 +-
 drivers/ata/libata-scsi.c                          |  25 ++-
 drivers/auxdisplay/hd44780.c                       |   9 +-
 drivers/base/base.h                                |  17 ++
 drivers/base/bus.c                                 |   2 +-
 drivers/base/core.c                                |  38 ++++-
 drivers/base/dd.c                                  |   6 +-
 drivers/block/loop.c                               |   2 +-
 drivers/char/misc.c                                |   2 +-
 drivers/char/virtio_console.c                      |   7 +-
 drivers/clk/clk.c                                  |   4 +
 drivers/clk/renesas/r9a07g043-cpg.c                |  28 +++-
 drivers/clk/renesas/r9a07g044-cpg.c                |  21 ++-
 drivers/clk/renesas/rzg2l-cpg.c                    | 178 +++++++++++++++------
 drivers/clk/renesas/rzg2l-cpg.h                    |  24 +--
 drivers/comedi/drivers/jr3_pci.c                   |   2 +-
 drivers/cpufreq/apple-soc-cpufreq.c                |  10 +-
 drivers/cpufreq/cppc_cpufreq.c                     |   2 +-
 drivers/cpufreq/scmi-cpufreq.c                     |  10 +-
 drivers/cpufreq/scpi-cpufreq.c                     |  13 +-
 drivers/crypto/atmel-sha204a.c                     |   6 +
 drivers/crypto/ccp/sp-pci.c                        |   1 +
 drivers/cxl/core/regs.c                            |   4 -
 drivers/dma-buf/udmabuf.c                          |   2 +-
 drivers/dma/dmatest.c                              |   6 +-
 drivers/gpio/gpiolib-of.c                          |   6 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   9 +-
 drivers/iio/adc/ad7768-1.c                         |   5 +-
 drivers/infiniband/hw/qib/qib_fs.c                 |   1 +
 drivers/iommu/amd/iommu.c                          |   2 +-
 drivers/iommu/iommu.c                              |  16 ++
 drivers/irqchip/irq-gic-v2m.c                      |   2 +-
 drivers/mailbox/pcc.c                              |  15 +-
 drivers/mcb/mcb-parse.c                            |   2 +-
 drivers/md/raid1.c                                 |  26 +--
 drivers/media/test-drivers/vimc/vimc-streamer.c    |   6 +
 drivers/media/v4l2-core/v4l2-subdev.c              | 101 ++++++++----
 drivers/misc/lkdtm/perms.c                         |  14 +-
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c    |   8 +-
 drivers/misc/mei/hw-me-regs.h                      |   1 +
 drivers/misc/mei/pci-me.c                          |   1 +
 drivers/mmc/host/sdhci-msm.c                       |   2 +-
 drivers/net/dsa/mt7530.c                           |   6 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  27 +++-
 drivers/net/ethernet/amd/pds_core/adminq.c         |  36 ++---
 drivers/net/ethernet/amd/pds_core/auxbus.c         |   3 -
 drivers/net/ethernet/amd/pds_core/core.c           |   4 +-
 drivers/net/ethernet/amd/pds_core/core.h           |   2 +-
 drivers/net/ethernet/amd/pds_core/devlink.c        |   4 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  24 ++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |  10 +-
 drivers/net/phy/microchip.c                        |  46 +-----
 drivers/net/phy/phy_led_triggers.c                 |  23 +--
 drivers/net/vmxnet3/vmxnet3_xdp.c                  |   2 +-
 drivers/net/xen-netfront.c                         |  19 ++-
 drivers/ntb/hw/amd/ntb_hw_amd.c                    |   1 +
 drivers/ntb/hw/idt/ntb_hw_idt.c                    |  18 +--
 drivers/nvme/host/core.c                           |   9 ++
 drivers/nvme/host/multipath.c                      |   2 +-
 drivers/nvme/target/fc.c                           |  25 ++-
 drivers/of/resolver.c                              |  37 ++---
 drivers/pci/probe.c                                |   9 +-
 drivers/pinctrl/renesas/pinctrl-rza2.c             |   3 +
 drivers/regulator/rk808-regulator.c                |   4 +-
 drivers/rtc/rtc-pcf85063.c                         |  19 ++-
 drivers/s390/char/sclp.h                           |  14 --
 drivers/s390/char/sclp_con.c                       |  17 ++
 drivers/s390/char/sclp_pci.c                       |  19 +--
 drivers/s390/char/sclp_tty.c                       |  12 ++
 drivers/s390/net/ism_drv.c                         |   1 -
 drivers/s390/virtio/virtio_ccw.c                   |  94 ++++++-----
 drivers/scsi/hisi_sas/hisi_sas_main.c              |  20 +++
 drivers/scsi/pm8001/pm8001_sas.c                   |   1 +
 drivers/scsi/scsi.c                                |  36 +++--
 drivers/scsi/scsi_lib.c                            |   6 +-
 drivers/soc/qcom/ice.c                             |  48 ++++++
 drivers/spi/spi-imx.c                              |   5 +-
 drivers/spi/spi-tegra210-quad.c                    |   6 +-
 drivers/thunderbolt/tb.c                           |  16 +-
 drivers/tty/serial/msm_serial.c                    |   6 +
 drivers/tty/serial/sifive.c                        |   6 +
 drivers/ufs/core/ufs-mcq.c                         |  12 +-
 drivers/ufs/host/ufs-exynos.c                      |  10 +-
 drivers/ufs/host/ufs-qcom.c                        |   2 +-
 drivers/usb/cdns3/cdns3-gadget.c                   |   2 +
 drivers/usb/chipidea/ci_hdrc_imx.c                 |  44 +++--
 drivers/usb/class/cdc-wdm.c                        |  21 ++-
 drivers/usb/core/quirks.c                          |   9 ++
 drivers/usb/dwc3/dwc3-pci.c                        |  10 ++
 drivers/usb/dwc3/dwc3-xilinx.c                     |   4 +-
 drivers/usb/dwc3/gadget.c                          |  28 +++-
 drivers/usb/gadget/udc/aspeed-vhub/dev.c           |   3 +
 drivers/usb/host/max3421-hcd.c                     |   7 +
 drivers/usb/host/ohci-pci.c                        |  23 +++
 drivers/usb/host/xhci-mvebu.c                      |  10 --
 drivers/usb/host/xhci-mvebu.h                      |   6 -
 drivers/usb/host/xhci-plat.c                       |   2 +-
 drivers/usb/host/xhci-ring.c                       |  13 +-
 drivers/usb/serial/ftdi_sio.c                      |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   5 +
 drivers/usb/serial/option.c                        |   3 +
 drivers/usb/serial/usb-serial-simple.c             |   7 +
 drivers/usb/storage/unusual_uas.h                  |   7 +
 drivers/xen/Kconfig                                |   2 +-
 fs/btrfs/file.c                                    |   9 +-
 fs/ceph/inode.c                                    |   2 +-
 fs/ext4/block_validity.c                           |   5 +-
 fs/ext4/inode.c                                    |   9 +-
 fs/iomap/buffered-io.c                             |   2 +-
 fs/namespace.c                                     |  69 ++++----
 fs/ntfs3/file.c                                    |   1 +
 fs/smb/client/sess.c                               |  60 ++++---
 fs/smb/client/smb1ops.c                            |  36 +++++
 fs/splice.c                                        |   2 +-
 include/linux/energy_model.h                       |   1 -
 include/linux/pci_ids.h                            |   1 +
 include/media/v4l2-subdev.h                        |  25 ++-
 include/soc/qcom/ice.h                             |   2 +
 include/trace/stages/stage3_trace_output.h         |   8 +
 include/trace/stages/stage7_class_define.h         |   1 +
 init/Kconfig                                       |   2 +-
 io_uring/io_uring.c                                |  15 +-
 io_uring/refs.h                                    |   7 +
 kernel/bpf/bpf_cgrp_storage.c                      |  11 +-
 kernel/bpf/verifier.c                              |  32 ++++
 kernel/dma/contiguous.c                            |   3 +-
 kernel/events/core.c                               |   6 +-
 kernel/module/Kconfig                              |   1 +
 kernel/panic.c                                     |   6 +
 kernel/sched/core.c                                |  92 +++++------
 kernel/sched/cpudeadline.c                         |   2 +-
 kernel/sched/cpufreq_schedutil.c                   |  63 ++++++--
 kernel/sched/deadline.c                            |   4 +-
 kernel/sched/fair.c                                |  40 +++--
 kernel/sched/rt.c                                  |   2 +-
 kernel/sched/sched.h                               |  30 +---
 kernel/sched/topology.c                            |   7 +-
 kernel/time/tick-common.c                          |  22 +++
 kernel/trace/bpf_trace.c                           |   7 +-
 kernel/trace/trace_events.c                        |   7 +
 lib/test_ubsan.c                                   |  18 ++-
 mm/memcontrol.c                                    |   9 ++
 net/9p/client.c                                    |  30 ++--
 net/core/lwtunnel.c                                |  26 ++-
 net/core/selftests.c                               |  18 ++-
 net/sched/sch_hfsc.c                               |  23 ++-
 net/tipc/monitor.c                                 |   3 +-
 samples/trace_events/trace-events-sample.h         |  18 ++-
 scripts/Makefile.lib                               |   2 +-
 sound/soc/codecs/wcd934x.c                         |   2 +-
 sound/soc/qcom/apq8016_sbc.c                       |   2 +-
 sound/soc/qcom/apq8096.c                           |   2 +-
 sound/soc/qcom/common.c                            |   2 +-
 sound/soc/qcom/lpass-apq8016.c                     |   4 +-
 sound/soc/qcom/lpass-cpu.c                         |   7 +-
 sound/soc/qcom/lpass-hdmi.c                        |   2 +-
 sound/soc/qcom/lpass-ipq806x.c                     |   4 +-
 sound/soc/qcom/lpass-platform.c                    |   2 +-
 sound/soc/qcom/lpass-sc7180.c                      |   4 +-
 sound/soc/qcom/lpass-sc7280.c                      |   2 +-
 sound/soc/qcom/lpass.h                             |   4 +-
 sound/soc/qcom/qdsp6/q6afe.c                       |   8 +-
 sound/soc/qcom/qdsp6/q6apm-dai.c                   |  61 ++++---
 sound/soc/qcom/qdsp6/q6asm.h                       |  20 +--
 sound/soc/qcom/qdsp6/topology.c                    |   3 +-
 sound/soc/qcom/sc7180.c                            |   2 +-
 sound/soc/qcom/sc8280xp.c                          |   2 +-
 sound/soc/qcom/sdm845.c                            |   2 +-
 sound/soc/qcom/sdw.c                               |   2 +-
 sound/soc/qcom/sm8250.c                            |   2 +-
 sound/soc/qcom/storm.c                             |   2 +-
 sound/virtio/virtio_pcm.c                          |  21 ++-
 tools/bpf/bpftool/prog.c                           |   1 +
 tools/objtool/check.c                              |  36 ++++-
 tools/testing/selftests/mincore/mincore_selftest.c |   3 -
 tools/testing/selftests/ublk/test_stripe_04.sh     |  24 +++
 217 files changed, 2073 insertions(+), 1004 deletions(-)


