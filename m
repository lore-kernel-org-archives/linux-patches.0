Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E327C1E25E8;
	Thu,  1 May 2025 08:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746087261; cv=none; b=iga7BqRWs3wh3YsMFSlYbpMhHe9T2f1kNufTunFnPWvhkOREPqV8Xus0J1+ZujPq9yIjcGsZQfq9hw0Ghm25buW66NFF2+j7j0SFeTtSL08VTOxYKrJ9yJ60kDWbf7J4PIAwGt8UQSnKmxRPZAQxNxRERyjKWi7bYqvxIoSCHV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746087261; c=relaxed/simple;
	bh=koVx/+PjtaFnVhf7hCKQ0TQ/yyoTOXEB46g1Jej4Fio=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=j4yEhTo1Hj7flWS5hGS7LjbxLUguAuI47usrTslKGGC0wyOWWtuQN6n1SWqLRWODDbd4xrg9pozgxAC1X7irQOAaUu159QjeiSHkb1HtvM0SnBWF+RlnPDahDD8QEaoaU73008R3bhK7wd7+sSJmJEFeqkPnvSqkdpRE4k9yESE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXPlmYGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXPlmYGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5B9C4CEE3;
	Thu,  1 May 2025 08:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746087260;
	bh=koVx/+PjtaFnVhf7hCKQ0TQ/yyoTOXEB46g1Jej4Fio=;
	h=From:To:Cc:Subject:Date:From;
	b=xXPlmYGTjRqMYwXE/v37J4pnczscQdit/yVQ94ijfpcv3CKPBvEacnb9qVDYMy3NM
	 2YNt8AahT/3Qq5EfZXdQW5RJ2lRriXeBEWn0FdJmXAJUy2JDoI/3WjX4+TmwGxuwHP
	 7fBEBN9gzS3/B+1L2hb8y/fyIMcNGN9HRsK9ovp8=
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
Subject: [PATCH 6.1 000/157] 6.1.136-rc2 review
Date: Thu,  1 May 2025 10:14:15 +0200
Message-ID: <20250501080849.930068482@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.136-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.136-rc2
X-KernelTest-Deadline: 2025-05-03T08:08+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.136 release.
There are 157 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 03 May 2025 08:08:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.136-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.136-rc2

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Silence more KCOV warnings, part 2

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qcom: q6afe-dai: fix Display Port Playback stream name

Rob Herring <robh@kernel.org>
    PCI: Fix use-after-free in pci_bus_release_domain_nr()

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Remove pointer (asterisk) and brackets from cpumask_t field

Richard Zhu <hongxing.zhu@nxp.com>
    phy: freescale: imx8m-pcie: Add one missing error return

Richard Zhu <hongxing.zhu@nxp.com>
    phy: freescale: imx8m-pcie: Do CMN_RST just before PHY PLL lock check

Hannes Reinecke <hare@kernel.org>
    nvme: fixup scan failure for non-ANA multipath controllers

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    MIPS: cm: Fix warning if MIPS_CM is disabled

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    xdp: Reset bpf_redirect_info before running a xdp's BPF prog.

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: enable STU methods for 6320 family

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: enable .port_set_policy() for 6320 family

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: enable PVT for 6321 switch

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: fix atu_move_port_mask for 6341 family

Jakub Kicinski <kuba@kernel.org>
    net/sched: act_mirred: don't override retval if we already lost the skb

Marek Behún <kabel@kernel.org>
    crypto: atmel-sha204a - Set hwrng quality to lowest possible

Ian Abbott <abbotti@mev.co.uk>
    comedi: jr3_pci: Fix synchronous deletion of timer

Dave Kleikamp <dave.kleikamp@oracle.com>
    jfs: define xtree root and page independently

Sergey Shtylyov <s.shtylyov@omp.ru>
    of: module: add buffer overflow check in of_modalias()

Tamura Dai <kirinode0@gmail.com>
    spi: spi-imx: Add check for spi_imx_setupxfer()

Meir Elisha <meir.elisha@volumez.com>
    md/raid1: Add check for missing source disk in process_checks()

Mostafa Saleh <smostafa@google.com>
    ubsan: Fix panic from test_ubsan_out_of_bounds

Breno Leitao <leitao@debian.org>
    spi: tegra210-quad: add rate limiting and simplify timeout error message

Breno Leitao <leitao@debian.org>
    spi: tegra210-quad: use WARN_ON_ONCE instead of WARN_ON for timeouts

Yunlong Xing <yunlong.xing@unisoc.com>
    loop: aio inherit the ioprio of original request

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

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Stop UNRET validation on UD2

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

Ming Lei <ming.lei@redhat.com>
    selftests: ublk: fix test_stripe_04

Xiaogang Chen <xiaogang.chen@amd.com>
    udmabuf: fix a buf size overflow issue during udmabuf creation

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    KVM: s390: Don't use %pK through tracepoints

Oleg Nesterov <oleg@redhat.com>
    sched/isolation: Make CONFIG_CPU_ISOLATION depend on CONFIG_SMP

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
    objtool, ASoC: codecs: wcd934x: Remove potential undefined behavior in wcd934x_slim_irq_handler()

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

Sean Christopherson <seanjc@google.com>
    KVM: x86: Reset IRTE to host control if *new* route isn't postable

Sean Christopherson <seanjc@google.com>
    KVM: x86: Explicitly treat routing entry type changes as changes

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add panther lake H DID

Oliver Neukum <oneukum@suse.com>
    USB: storage: quirk for ADATA Portable HDD CH94

Haoxiang Li <haoxiang_li2024@163.com>
    mcb: fix a double free bug in chameleon_parse_gdd()

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Allocate IR data using atomic allocation

Petr Tesarik <ptesarik@suse.com>
    LoongArch: Remove a bogus reference to ZONE_DMA

Ming Wang <wangming01@loongson.cn>
    LoongArch: Return NULL from huge_pte_offset() for invalid PMD

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Force full update in gpu reset

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Fix gpu reset in multidisplay config

Oleksij Rempel <linux@rempel-privat.de>
    net: selftests: initialize TCP header and skb payload with zero

Alexey Nepomnyashih <sdl@nppct.ru>
    xen-netfront: handle NULL returned by xdp_convert_buff_to_frame()

Halil Pasic <pasic@linux.ibm.com>
    virtio_console: fix missing byte order handling for cols and rows

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw88: use ieee80211_purge_tx_queue() to purge TX skb

Ping-Ke Shih <pkshih@realtek.com>
    wifi: mac80211: export ieee80211_purge_tx_queue() for drivers

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Make regs_irqs_disabled() more clear

Yuli Wang <wangyuli@uniontech.com>
    LoongArch: Select ARCH_USE_MEMTEST

Luo Gengkun <luogengkun@huaweicloud.com>
    perf/x86: Fix non-sampling (counting) events on certain x86 platforms

Sean Christopherson <seanjc@google.com>
    iommu/amd: Return an error if vCPU affinity is set for non-vCPU IRTE

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: hfsc: Fix a potential UAF in hfsc_dequeue() too

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: hfsc: Fix a UAF vulnerability in class handling

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

Henry Martin <bsdhenrymartin@gmail.com>
    cpufreq: scpi: Fix null-ptr-deref in scpi_cpufreq_get_rate()

Henry Martin <bsdhenrymartin@gmail.com>
    cpufreq: scmi: Fix null-ptr-deref in scmi_cpufreq_get_rate()

Arnd Bergmann <arnd@arndb.de>
    dma/contiguous: avoid warning about unused size_bytes

Mark Brown <broonie@kernel.org>
    selftests/mm: generate a temporary mountpoint for cgroup filesystem

Evgeny Pimenov <pimenoveu12@gmail.com>
    ASoC: qcom: Fix sc7280 lpass potential buffer overflow

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qcom: q6dsp: add support to more display ports

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    phy: freescale: imx8m-pcie: assert phy reset and perst in power off

Richard Zhu <hongxing.zhu@nxp.com>
    phy: freescale: imx8m-pcie: Add i.MX8MP PCIe PHY support

Ma Ke <make24@iscas.ac.cn>
    PCI: Fix reference leak in pci_register_host_bridge()

Pali Rohár <pali@kernel.org>
    PCI: Assign PCI domain IDs by ida_alloc()

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

Herve Codina <herve.codina@bootlin.com>
    backlight: led_bl: Hold led_access lock when calling led_sysfs_disable()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    backlight: led_bl: Convert to platform remove callback returning void

Sergiu Cuciurean <sergiu.cuciurean@analog.com>
    iio: adc: ad7768-1: Fix conversion result sign

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7768-1: Move setting of val a bit later to avoid unnecessary return value check

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: fix VTU methods for 6320 family

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: fix internal PHYs for 6320 family

Alexis Lothoré <alexis.lothore@bootlin.com>
    net: dsa: mv88e6xxx: add field to specify internal phys layout

Alexis Lothoré <alexis.lothore@bootlin.com>
    net: dsa: mv88e6xxx: pass directly chip structure to mv88e6xxx_phy_is_internal

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: dsa: mv88e6xxx: move link forcing to mac_prepare/mac_finish

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: dsa: add support for mac_prepare() and mac_finish() calls

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: mv88e6xxx: don't dispose of Global2 IRQ mappings from mdiobus code

Haoxiang Li <haoxiang_li2024@163.com>
    auxdisplay: hd44780: Fix an API misuse in hd44780.c

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    auxdisplay: hd44780: Convert to platform remove callback returning void

Steven Rostedt <rostedt@goodmis.org>
    tracing: Verify event formats that have "%*p.."

Steven Rostedt <rostedt@goodmis.org>
    tracing: Add __print_dynamic_array() helper

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Add __string_len() example

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Fix cpumask() example typo

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Add __cpumask to denote a trace event field that is a cpumask_t

Thorsten Leemhuis <linux@leemhuis.info>
    module: sign with sha512 instead of sha1 by default


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/loongarch/Kconfig                             |   1 +
 arch/loongarch/include/asm/ptrace.h                |   4 +-
 arch/loongarch/mm/hugetlbpage.c                    |   2 +-
 arch/loongarch/mm/init.c                           |   3 -
 arch/mips/include/asm/mips-cm.h                    |  22 +++
 arch/mips/kernel/mips-cm.c                         |  14 ++
 arch/parisc/kernel/pdt.c                           |   2 +
 arch/s390/kvm/trace-s390.h                         |   4 +-
 arch/x86/entry/entry.S                             |   2 +-
 arch/x86/events/core.c                             |   2 +-
 arch/x86/kernel/cpu/bugs.c                         |  36 ++---
 arch/x86/kernel/i8253.c                            |   3 +-
 arch/x86/kvm/svm/avic.c                            |  60 +++----
 arch/x86/kvm/vmx/posted_intr.c                     |  28 ++--
 arch/x86/kvm/x86.c                                 |   3 +-
 arch/x86/mm/tlb.c                                  |   6 +-
 crypto/crypto_null.c                               |  37 +++--
 drivers/acpi/ec.c                                  |  28 ++++
 drivers/acpi/pptt.c                                |   4 +-
 drivers/auxdisplay/hd44780.c                       |   9 +-
 drivers/block/loop.c                               |   2 +-
 drivers/char/virtio_console.c                      |   7 +-
 drivers/clk/clk.c                                  |   4 +
 drivers/clk/renesas/r9a07g043-cpg.c                |  28 +++-
 drivers/clk/renesas/r9a07g044-cpg.c                |  21 ++-
 drivers/clk/renesas/rzg2l-cpg.c                    | 178 +++++++++++++++------
 drivers/clk/renesas/rzg2l-cpg.h                    |  24 +--
 drivers/comedi/drivers/jr3_pci.c                   |  17 +-
 drivers/cpufreq/cppc_cpufreq.c                     |   2 +-
 drivers/cpufreq/scmi-cpufreq.c                     |  10 +-
 drivers/cpufreq/scpi-cpufreq.c                     |  13 +-
 drivers/crypto/atmel-sha204a.c                     |   7 +-
 drivers/dma-buf/udmabuf.c                          |   2 +-
 drivers/dma/dmatest.c                              |   6 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   9 +-
 drivers/iio/adc/ad7768-1.c                         |   5 +-
 drivers/infiniband/hw/qib/qib_fs.c                 |   1 +
 drivers/iommu/amd/iommu.c                          |   2 +-
 drivers/mcb/mcb-parse.c                            |   2 +-
 drivers/md/raid1.c                                 |  26 +--
 drivers/misc/lkdtm/perms.c                         |  14 +-
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c    |   8 +-
 drivers/misc/mei/hw-me-regs.h                      |   1 +
 drivers/misc/mei/pci-me.c                          |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c                   | 106 ++++++++----
 drivers/net/dsa/mv88e6xxx/chip.h                   |   5 +
 drivers/net/dsa/mv88e6xxx/global2.c                |  25 +--
 drivers/net/phy/phy_led_triggers.c                 |  23 +--
 drivers/net/wireless/realtek/rtw88/main.c          |   2 +-
 drivers/net/wireless/realtek/rtw88/tx.c            |   2 +-
 drivers/net/xen-netfront.c                         |  19 ++-
 drivers/ntb/hw/amd/ntb_hw_amd.c                    |   1 +
 drivers/ntb/hw/idt/ntb_hw_idt.c                    |  18 +--
 drivers/nvme/host/core.c                           |   9 ++
 drivers/nvme/target/fc.c                           |  25 ++-
 drivers/of/device.c                                |   7 +-
 drivers/of/resolver.c                              |  37 ++---
 drivers/pci/pci.c                                  | 107 +++++++------
 drivers/pci/probe.c                                |  16 +-
 drivers/pci/remove.c                               |   7 +
 drivers/phy/freescale/phy-fsl-imx8m-pcie.c         |  46 +++++-
 drivers/pinctrl/renesas/pinctrl-rza2.c             |   3 +
 drivers/rtc/rtc-pcf85063.c                         |  19 ++-
 drivers/s390/char/sclp_con.c                       |  17 ++
 drivers/s390/char/sclp_tty.c                       |  12 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c              |  20 +++
 drivers/scsi/pm8001/pm8001_sas.c                   |   1 +
 drivers/scsi/scsi_lib.c                            |   6 +-
 drivers/spi/spi-imx.c                              |   5 +-
 drivers/spi/spi-tegra210-quad.c                    |   6 +-
 drivers/thunderbolt/tb.c                           |  16 +-
 drivers/tty/serial/msm_serial.c                    |   6 +
 drivers/tty/serial/sifive.c                        |   6 +
 drivers/ufs/host/ufs-exynos.c                      |  10 +-
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
 drivers/usb/host/xhci-ring.c                       |  11 +-
 drivers/usb/serial/ftdi_sio.c                      |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   5 +
 drivers/usb/serial/option.c                        |   3 +
 drivers/usb/serial/usb-serial-simple.c             |   7 +
 drivers/usb/storage/unusual_uas.h                  |   7 +
 drivers/video/backlight/led_bl.c                   |  11 +-
 drivers/xen/Kconfig                                |   2 +-
 fs/btrfs/file.c                                    |   9 +-
 fs/ext4/block_validity.c                           |   5 +-
 fs/ext4/inode.c                                    |   7 +-
 fs/jfs/jfs_dinode.h                                |   2 +-
 fs/jfs/jfs_imap.c                                  |   6 +-
 fs/jfs/jfs_incore.h                                |   2 +-
 fs/jfs/jfs_txnmgr.c                                |   4 +-
 fs/jfs/jfs_xtree.c                                 |   4 +-
 fs/jfs/jfs_xtree.h                                 |  37 +++--
 fs/ntfs3/file.c                                    |   1 +
 include/dt-bindings/sound/qcom,q6dsp-lpass-ports.h |   8 +
 include/linux/filter.h                             |   9 +-
 include/linux/pci.h                                |   1 +
 include/net/dsa.h                                  |   6 +
 include/net/mac80211.h                             |  13 ++
 include/trace/bpf_probe.h                          |   6 +
 include/trace/perf.h                               |   6 +
 include/trace/stages/stage1_struct_define.h        |   6 +
 include/trace/stages/stage2_data_offsets.h         |   6 +
 include/trace/stages/stage3_trace_output.h         |  14 ++
 include/trace/stages/stage4_event_fields.h         |  12 ++
 include/trace/stages/stage5_get_offsets.h          |   6 +
 include/trace/stages/stage6_event_callback.h       |  20 +++
 include/trace/stages/stage7_class_define.h         |   3 +
 init/Kconfig                                       |   2 +-
 kernel/dma/contiguous.c                            |   3 +-
 kernel/module/Kconfig                              |   1 +
 kernel/trace/bpf_trace.c                           |   7 +-
 kernel/trace/trace_events.c                        |   7 +
 lib/test_ubsan.c                                   |  18 ++-
 net/9p/client.c                                    |  30 ++--
 net/core/lwtunnel.c                                |  26 ++-
 net/core/selftests.c                               |  18 ++-
 net/dsa/port.c                                     |  32 ++++
 net/mac80211/ieee80211_i.h                         |   2 -
 net/mac80211/status.c                              |   1 +
 net/sched/act_mirred.c                             |  22 +--
 net/sched/sch_hfsc.c                               |  23 ++-
 net/tipc/monitor.c                                 |   3 +-
 samples/trace_events/trace-events-sample.c         |   2 +-
 samples/trace_events/trace-events-sample.h         |  46 +++++-
 scripts/Makefile.lib                               |   2 +-
 sound/soc/codecs/wcd934x.c                         |   2 +-
 sound/soc/qcom/lpass.h                             |   3 +-
 sound/soc/qcom/qdsp6/q6afe-dai.c                   |   2 +-
 sound/soc/qcom/qdsp6/q6dsp-lpass-ports.c           |  43 +++--
 sound/virtio/virtio_pcm.c                          |  21 ++-
 tools/objtool/check.c                              |   9 ++
 tools/testing/selftests/mincore/mincore_selftest.c |   3 -
 tools/testing/selftests/ublk/test_stripe_04.sh     |  24 +++
 .../selftests/vm/charge_reserved_hugetlb.sh        |   4 +-
 .../selftests/vm/hugetlb_reparenting_test.sh       |   2 +-
 148 files changed, 1434 insertions(+), 580 deletions(-)


