Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C89242D94;
	Tue, 29 Apr 2025 17:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947499; cv=none; b=mdFQaqVaQP8BiclpcorOkIyS6oi4L2RVRsdXPefQCjDWzKHI3WblaVJYd4AcAuueaBLskcjnZ5Xdw3SUwxuRcxIiGtgGpgLGEpAz9QAF5PDAwxT0IcC8b9DbwWI/xMhBgezi3DRh+RTd0wQndo/qNZW9enHlX3++EVwDDn5DXk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947499; c=relaxed/simple;
	bh=yFa21N6fUdMXXKOxzUTBFPYiB94hdEgEgJGPTONNmQk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jChAQdWTCJ5fFZgUMnF7g9CyWQkQ0seemPYLT6AhyR7K82r6TdnM4AUru3lg4L0Kf9z8G9paE9eYjxKuGrxn/1IYyx2lOzs4bgbLErTbPx2GMSBv5Kr0jUQZbqa+iwvu/6K8ErCwUgl3p4PBX4SlZefjeJ1JeH3b9NebmZ6KaO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amB3gpvZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amB3gpvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73713C4CEEE;
	Tue, 29 Apr 2025 17:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947499;
	bh=yFa21N6fUdMXXKOxzUTBFPYiB94hdEgEgJGPTONNmQk=;
	h=From:To:Cc:Subject:Date:From;
	b=amB3gpvZgRHUzGiYOnXXKlfoiMwCXJErjhWg9Y5CmQXzgEZoATth7OLbeXqlaLdCY
	 k7krlJx14Dx+pwLnHqKh0m5QgqfFeC+JKgWkbS49fs7jq9i4+2XWYKe/ITZojqDczY
	 bF+vC8t/gjvo2EOrrM6k4n79WKNnRNutE4w5/nWo=
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
Subject: [PATCH 6.12 000/280] 6.12.26-rc1 review
Date: Tue, 29 Apr 2025 18:39:01 +0200
Message-ID: <20250429161115.008747050@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.26-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.26-rc1
X-KernelTest-Deadline: 2025-05-01T16:11+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.26 release.
There are 280 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.26-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.26-rc1

Christoph Hellwig <hch@lst.de>
    mq-deadline: don't call req_get_ioprio from the I/O completion handler

Keerthy <j-keerthy@ti.com>
    arm64: dts: ti: k3-j784s4-j742s2-main-common: Correct the GICD size

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: Kconfig - Select LIB generic option

Dan Carpenter <dan.carpenter@linaro.org>
    usb: typec: class: Unlocked on error in typec_register_partner()

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Silence more KCOV warnings, part 2

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Ignore end-of-section jumps for KCOV/GCOV

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Fix Short Packet handling rework ignoring errors

Hannes Reinecke <hare@kernel.org>
    nvme: fixup scan failure for non-ANA multipath controllers

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    MIPS: cm: Fix warning if MIPS_CM is disabled

Dan Carpenter <dan.carpenter@linaro.org>
    media: i2c: imx214: Fix uninitialized variable in imx214_set_ctrl()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: lib/Kconfig - Hide arch options from user

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

Marek Behún <kabel@kernel.org>
    Revert "net: dsa: mv88e6xxx: fix internal PHYs for 6320 family"

Andrei Kuchynski <akuchynski@chromium.org>
    usb: typec: class: Invalidate USB device pointers on partner unregistration

Baokun Li <libaokun1@huawei.com>
    ext4: goto right label 'out_mmap_sem' in ext4_setattr()

Ian Abbott <abbotti@mev.co.uk>
    comedi: jr3_pci: Fix synchronous deletion of timer

Daniel Borkmann <daniel@iogearbox.net>
    vmxnet3: Fix malformed packet sizing in vmxnet3_process_xdp

Andrei Kuchynski <akuchynski@chromium.org>
    usb: typec: class: Fix NULL pointer access

Shigeru Yoshida <syoshida@redhat.com>
    selftests/bpf: Adjust data size to have ETH_HLEN

Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
    selftests/bpf: check program redirect in xdp_cpumap_attach

Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
    selftests/bpf: make xdp_cpumap_attach keep redirect prog attached

Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
    selftests/bpf: fix bpf_map_redirect call for cpu map test

Christoph Hellwig <hch@lst.de>
    xfs: flush inodegc before swapon

Christoph Hellwig <hch@lst.de>
    xfs: rename xfs_iomap_swapfile_activate to xfs_vm_swap_activate

Carlos Maiolino <cem@kernel.org>
    xfs: Do not allow norecovery mount with quotacheck

Lukas Herbolt <lukas@herbolt.com>
    xfs: do not check NEEDSREPAIR if ro,norecovery mount.

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    driver core: fix potential NULL pointer dereference in dev_uevent()

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    driver core: introduce device_set_driver() helper

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Revert "drivers: core: synchronize really_probe() and dev_uevent()"

Tamura Dai <kirinode0@gmail.com>
    spi: spi-imx: Add check for spi_imx_setupxfer()

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Use the right function for hdp flush

Christian König <christian.koenig@amd.com>
    drm/amdgpu: use a dummy owner for sysfs triggered cleaner shaders v4

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

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix WARNING "do not call blocking ops when !TASK_RUNNING"

Andrew Jones <ajones@ventanamicro.com>
    riscv: Provide all alternative macros all the time

Gou Hao <gouhao@uniontech.com>
    iomap: skip unnecessary ifs_block_is_uptodate check

Song Liu <song@kernel.org>
    netfs: Only create /proc/fs/netfs with CONFIG_PROC_FS

Fernando Fernandez Mancera <ffmancera@riseup.net>
    x86/i8253: Call clockevent_i8253_disable() with interrupts disabled

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_asrc_dma: get codec or cpu dai from backend

Igor Pylypiv <ipylypiv@google.com>
    scsi: pm80xx: Set phy_attached to zero when device is gone

Peter Griffin <peter.griffin@linaro.org>
    scsi: ufs: exynos: gs101: Put UFS device in reset on .suspend()

Peter Griffin <peter.griffin@linaro.org>
    scsi: ufs: exynos: Move phy calls to .exit() callback

Peter Griffin <peter.griffin@linaro.org>
    scsi: ufs: exynos: Enable PRDT pre-fetching with UFSHCD_CAP_CRYPTO

Peter Griffin <peter.griffin@linaro.org>
    scsi: ufs: exynos: Ensure pre_link() executes before exynos_ufs_phy_init()

Xingui Yang <yangxingui@huawei.com>
    scsi: hisi_sas: Fix I/O errors caused by hardware port ID changes

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: make block validity check resistent to sb bh corruption

Robin Murphy <robin.murphy@arm.com>
    iommu: Clear iommu-dma ops on cleanup

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

Roger Pau Monne <roger.pau@citrix.com>
    x86/xen: disable CPU idle and frequency drivers for PVH dom0

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpiolib: of: Move Atmel HSMCI quirk up out of the regulator comment

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Stop UNRET validation on UD2

Uday Shankar <ushankar@purestorage.com>
    nvme: multipath: fix return value of nvme_available_path

Hannes Reinecke <hare@kernel.org>
    nvme: re-read ANA log page after ns scan completes

Julia Filipchuk <julia.filipchuk@intel.com>
    drm/xe/xe3lpg: Apply Wa_14022293748, Wa_22019794406

Jay Cornwall <jay.cornwall@amd.com>
    drm/amdgpu: Increase KIQ invalidate_tlbs timeout

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

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Don't allow creation of local partition over a remote one

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    KVM: s390: Don't use %pK through debug printing

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    KVM: s390: Don't use %pK through tracepoints

Oleg Nesterov <oleg@redhat.com>
    sched/isolation: Make CONFIG_CPU_ISOLATION depend on CONFIG_SMP

Xi Ruoyao <xry111@xry111.site>
    kbuild: add dependency from vmlinux to sorttable

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: always do atomic put from iowq

Lukas Stockmann <lukas.stockmann@siemens.com>
    rtc: pcf85063: do a SW reset if POR failed

Ignacio Encinas <ignacio@iencinas.com>
    9p/trans_fd: mark concurrent read and writes to p9_conn->err

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

Benjamin Berg <benjamin.berg@intel.com>
    um: work around sched_yield not yielding in time-travel mode

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Scan retimers after device router has been enumerated

Théo Lebrun <theo.lebrun@bootlin.com>
    usb: host: xhci-plat: mvebu: use ->quirks instead of ->init_quirk() func

Chenyuan Yang <chenyuan0y@gmail.com>
    usb: gadget: aspeed: Add NULL pointer check in ast_vhub_init_dev()

Andy Yan <andy.yan@rock-chips.com>
    phy: rockchip: usbdp: Avoid call hpd_event_trigger in dp_phy_init

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Avoid Stop Endpoint retry loop if the endpoint seems Running

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    dmaengine: dmatest: Fix dmatest waiting less when interrupted

Stanley Chu <yschu@nuvoton.com>
    i3c: master: svc: Add support for Nuvoton npcm845 i3c

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Handle spurious events on Etron host isoc enpoints

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Fix isochronous Ring Underrun/Overrun event handling

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Complete 'error mid TD' transfers when handling Missed Service

John Stultz <jstultz@google.com>
    sound/virtio: Fix cancel_sync warnings on uninitialized work_structs

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: dwc3: gadget: Avoid using reserved endpoints on Intel Merrifield

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: dwc3: gadget: Refactor loop to avoid NULL endpoints

Edward Adam Davis <eadavis@qq.com>
    fs/ntfs3: Fix WARNING in ntfs_extend_initialized_size

Lizhi Xu <lizhi.xu@windriver.com>
    fs/ntfs3: Keep write operations atomic

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

Yonghong Song <yonghong.song@linux.dev>
    bpf: Fix kmemleak warning for percpu hashmap

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: null - Use spin lock instead of mutex

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: lib/Kconfig - Fix lib built-in failure when arch is modular

Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
    crypto: ccp - Add support for PCI device 0x1134

Gregory CLEMENT <gregory.clement@bootlin.com>
    MIPS: cm: Detect CM quirks from device tree

Dmitry Mastykin <mastichi@gmail.com>
    pinctrl: mcp23s08: Get rid of spurious level interrupts

Chenyuan Yang <chenyuan0y@gmail.com>
    pinctrl: renesas: rza2: Fix potential NULL pointer dereference

Amery Hung <ameryhung@gmail.com>
    selftests/bpf: Fix stdout race condition in traffic monitor

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

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Limit time spent with xHC interrupts disabled during bus resume

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

Günther Noack <gnoack3000@gmail.com>
    tty: Require CAP_SYS_ADMIN for all usages of TIOCL_SELMOUSEREPORT

Mahesh Rao <mahesh.rao@intel.com>
    firmware: stratix10-svc: Add of_platform_default_populate()

Rengarajan S <rengarajan.s@microchip.com>
    misc: microchip: pci1xxxx: Fix incorrect IRQ status handling during ack

Rengarajan S <rengarajan.s@microchip.com>
    misc: microchip: pci1xxxx: Fix Kernel panic during IRQ handler registration

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    char: misc: register chrdev region with all possible minors

Sean Christopherson <seanjc@google.com>
    KVM: x86: Take irqfds.lock when adding/deleting IRQ bypass producer

Sean Christopherson <seanjc@google.com>
    KVM: x86: Reset IRTE to host control if *new* route isn't postable

Sean Christopherson <seanjc@google.com>
    KVM: x86: Explicitly treat routing entry type changes as changes

Hans de Goede <hdegoede@redhat.com>
    mei: vsc: Fix fortify-panic caused by invalid counted_by() use

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

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Fix PMU pass-through issue if VM exits to host finally

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Fully clear some CSRs when VM reboot

Petr Tesarik <ptesarik@suse.com>
    LoongArch: Remove a bogus reference to ZONE_DMA

Ming Wang <wangming01@loongson.cn>
    LoongArch: Return NULL from huge_pte_offset() for invalid PMD

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Handle fp, lsx, lasx and lbt assembly symbols

Suzuki K Poulose <suzuki.poulose@arm.com>
    irqchip/gic-v2m: Prevent use after free of gicv2m_get_fwnode()

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    x86/insn: Fix CTEST instruction decoding

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Force full update in gpu reset

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Fix gpu reset in multidisplay config

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    drm: panel: jd9365da: fix reset signal polarity in unprepare

Christian Schrefl <chrisi.schrefl@gmail.com>
    rust: firmware: Use `ffi::c_char` type in `FwFunc`

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Fix pending I/O counter

Fiona Klute <fiona.klute@gmx.de>
    net: phy: microchip: force IRQ polling mode for lan88xx

Oleksij Rempel <o.rempel@pengutronix.de>
    net: selftests: initialize TCP header and skb payload with zero

Alexey Nepomnyashih <sdl@nppct.ru>
    xen-netfront: handle NULL returned by xdp_convert_buff_to_frame()

Marek Behún <kabel@kernel.org>
    crypto: atmel-sha204a - Set hwrng quality to lowest possible

Breno Leitao <leitao@debian.org>
    sched_ext: Use kvzalloc for large exit_dump allocation

Halil Pasic <pasic@linux.ibm.com>
    virtio_console: fix missing byte order handling for cols and rows

Florian Westphal <fw@strlen.de>
    netfilter: fib: avoid lookup if socket is available

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    KVM: SVM: Disable AVIC on SNP-enabled system without HvInUseWrAllowed feature

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Make do_xyz() exception handlers more robust

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Make regs_irqs_disabled() more clear

Yuli Wang <wangyuli@uniontech.com>
    LoongArch: Select ARCH_USE_MEMTEST

Luo Gengkun <luogengkun@huaweicloud.com>
    perf/x86: Fix non-sampling (counting) events on certain x86 platforms

Alexei Starovoitov <ast@kernel.org>
    bpf: Add namespace to BPF internal symbols

T.J. Mercier <tjmercier@google.com>
    splice: remove duplicate noinline from pipe_clear_nowait

Björn Töpel <bjorn@rivosinc.com>
    riscv: uprobes: Add missing fence.i after building the XOL buffer

Björn Töpel <bjorn@rivosinc.com>
    riscv: Replace function-like macro by static inline function

Sean Christopherson <seanjc@google.com>
    iommu/amd: Return an error if vCPU affinity is set for non-vCPU IRTE

Christoph Hellwig <hch@lst.de>
    block: never reduce ra_pages in blk_apply_bdi_limits

Shannon Nelson <shannon.nelson@amd.com>
    pds_core: make wait_context part of q_info

Brett Creeley <brett.creeley@amd.com>
    pds_core: Remove unnecessary check in pds_client_adminq_cmd()

Brett Creeley <brett.creeley@amd.com>
    pds_core: handle unsupported PDS_CORE_CMD_FW_CONTROL result

Brett Creeley <brett.creeley@amd.com>
    pds_core: Prevent possible adminq overflow/stuck condition

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

Chenyuan Yang <chenyuan0y@gmail.com>
    scsi: ufs: core: Add NULL check in ufshcd_mcq_compl_pending_transfer()

Anastasia Kovaleva <a.kovaleva@yadro.com>
    scsi: core: Clear flags for scsi_cmnd that did not complete

Henry Martin <bsdhenrymartin@gmail.com>
    net/mlx5: Move ttc allocation after switch case to prevent leaks

Henry Martin <bsdhenrymartin@gmail.com>
    net/mlx5: Fix null-ptr-deref in mlx5_create_{inner_,}ttc_table()

Dongli Zhang <dongli.zhang@oracle.com>
    vhost-scsi: Fix vhost_scsi_send_status()

Dongli Zhang <dongli.zhang@oracle.com>
    vhost-scsi: Fix vhost_scsi_send_bad_target()

Mike Christie <michael.christie@oracle.com>
    vhost-scsi: Add better resource allocation failure handling

T.J. Mercier <tjmercier@google.com>
    cgroup/cpuset-v1: Add missing support for cpuset_v2_mode

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: return EIO on RAID1 block group write pointer mismatch

Qu Wenruo <wqu@suse.com>
    btrfs: avoid page_lockend underflow in btrfs_punch_hole_lock_range()

Johan Hovold <johan+linaro@kernel.org>
    cpufreq: fix compile-test defaults

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    cpufreq: Do not enable by default during compile testing

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

Andre Przywara <andre.przywara@arm.com>
    cpufreq: sun50i: prevent out-of-bounds access

David Howells <dhowells@redhat.com>
    ceph: Fix incorrect flush end position calculation

Nathan Chancellor <nathan@kernel.org>
    lib/Kconfig.ubsan: Remove 'default UBSAN' from UBSAN_INTEGER_WRAP

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display/dml2: use vzalloc rather than kzalloc

Rohit Chavan <roheetchavan@gmail.com>
    drm/amd/display: Fix unnecessary cast warnings from checkpatch

Matt Roper <matthew.d.roper@intel.com>
    drm/xe/bmg: Add one additional PCI ID

Jonathan Currier <dullfire@yahoo.com>
    net/niu: Niu requires MSIX ENTRY_DATA fields touch before entry reads

Peter Griffin <peter.griffin@linaro.org>
    scsi: ufs: exynos: Disable iocc if dma-coherent property isn't set

Peter Griffin <peter.griffin@linaro.org>
    scsi: ufs: exynos: Move UFS shareability value to drvdata

Peter Griffin <peter.griffin@linaro.org>
    scsi: ufs: exynos: Add gs101_ufs_drv_init() hook and enable WriteBooster

Tudor Ambarus <tudor.ambarus@linaro.org>
    scsi: ufs: exynos: Remove superfluous function parameter

Tudor Ambarus <tudor.ambarus@linaro.org>
    scsi: ufs: exynos: Remove empty drv_init method

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in __smb2_lease_break_noti()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: browse interfaces list on FSCTL_QUERY_INTERFACE_INFO IOCTL

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add netdev-up/down event debug print

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use __GFP_RETRY_MAYFAIL

Andrzej Kacprowski <Andrzej.Kacprowski@intel.com>
    accel/ivpu: Fix the NPU's DPU frequency calculation

Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
    accel/ivpu: Add auto selection logic for job scheduler

Jonathan Currier <dullfire@yahoo.com>
    PCI/MSI: Add an option to write MSIX ENTRY_DATA before any reads

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Handle the NOMASK flag correctly for all PCI/MSI backends

Roger Pau Monne <roger.pau@citrix.com>
    PCI/MSI: Convert pci_msi_ignore_mask to per MSI domain flag

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Support mmap() of PCI resources except for ISM devices

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Report PCI error recovery results via SCLP

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/sclp: Allow user-space to provide PCI reports for optical modules

Tudor Ambarus <tudor.ambarus@linaro.org>
    scsi: ufs: qcom: fix dev reference leaked through of_qcom_ice_get

Zijun Hu <quic_zijuhu@quicinc.com>
    of: resolver: Fix device node refcount leakage in of_resolve_phandles()

Rob Herring (Arm) <robh@kernel.org>
    of: resolver: Simplify of_resolve_phandles() using __free()

Siddharth Vadapalli <s-vadapalli@ti.com>
    arm64: dts: ti: k3-j784s4-j742s2-main-common: Fix serdes_ln_ctrl reg-masks

Manorit Chawdhry <m-chawdhry@ti.com>
    arm64: dts: ti: Refactor J784s4 SoC files to a common file

Sergiu Cuciurean <sergiu.cuciurean@analog.com>
    iio: adc: ad7768-1: Fix conversion result sign

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7768-1: Move setting of val a bit later to avoid unnecessary return value check

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: fix VTU methods for 6320 family

Ming Lei <ming.lei@redhat.com>
    block: make sure ->nr_integrity_segments is cloned in blk_rq_prep_clone

Christoph Hellwig <hch@lst.de>
    block: remove the ioprio field from struct request

Christoph Hellwig <hch@lst.de>
    block: remove the write_hint field from struct request

Hans de Goede <hdegoede@redhat.com>
    media: ov08x40: Add missing ov08x40_identify_module() call on stream-start

Hans de Goede <hdegoede@redhat.com>
    media: ov08x40: Move ov08x40_identify_module() function up

André Apitzsch <git@apitzsch.eu>
    media: i2c: imx214: Fix link frequency validation

André Apitzsch <git@apitzsch.eu>
    media: i2c: imx214: Check number of lanes from device tree

André Apitzsch <git@apitzsch.eu>
    media: i2c: imx214: Replace register addresses with macros

André Apitzsch <git@apitzsch.eu>
    media: i2c: imx214: Convert to CCI register access helpers

André Apitzsch <git@apitzsch.eu>
    media: i2c: imx214: Simplify with dev_err_probe()

André Apitzsch <git@apitzsch.eu>
    media: i2c: imx214: Use subdev active state

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: EM: Address RCU-related sparse warnings

Li RongQing <lirongqing@baidu.com>
    PM: EM: use kfree_rcu() to simplify the code

Tudor Ambarus <tudor.ambarus@linaro.org>
    mmc: sdhci-msm: fix dev reference leaked through of_qcom_ice_get

Tudor Ambarus <tudor.ambarus@linaro.org>
    soc: qcom: ice: introduce devm_of_qcom_ice_get

Jinjiang Tu <tujinjiang@huawei.com>
    mm/vmscan: don't try to reclaim hwpoison folio

Steven Rostedt <rostedt@goodmis.org>
    tracing: Verify event formats that have "%*p.."

Steven Rostedt <rostedt@goodmis.org>
    tracing: Add __print_dynamic_array() helper

Thorsten Leemhuis <linux@leemhuis.info>
    module: sign with sha512 instead of sha1 by default


-------------

Diffstat:

 Documentation/bpf/bpf_devel_QA.rst                 |    8 +
 Makefile                                           |    4 +-
 arch/arm/crypto/Kconfig                            |   10 +-
 .../arm64/boot/dts/ti/k3-j784s4-j742s2-common.dtsi |  148 ++
 .../boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi  | 2673 +++++++++++++++++++
 ...tsi => k3-j784s4-j742s2-mcu-wakeup-common.dtsi} |    2 +-
 ...l.dtsi => k3-j784s4-j742s2-thermal-common.dtsi} |    0
 arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi         | 2705 +-------------------
 arch/arm64/boot/dts/ti/k3-j784s4.dtsi              |  133 +-
 arch/arm64/crypto/Kconfig                          |    6 +-
 arch/loongarch/Kconfig                             |    1 +
 arch/loongarch/include/asm/fpu.h                   |   33 +-
 arch/loongarch/include/asm/lbt.h                   |   10 +-
 arch/loongarch/include/asm/ptrace.h                |    4 +-
 arch/loongarch/kernel/fpu.S                        |    6 +
 arch/loongarch/kernel/lbt.S                        |    4 +
 arch/loongarch/kernel/signal.c                     |   21 -
 arch/loongarch/kernel/traps.c                      |   20 +-
 arch/loongarch/kvm/vcpu.c                          |    8 +
 arch/loongarch/mm/hugetlbpage.c                    |    2 +-
 arch/loongarch/mm/init.c                           |    3 -
 arch/mips/crypto/Kconfig                           |    7 +-
 arch/mips/include/asm/mips-cm.h                    |   22 +
 arch/mips/kernel/mips-cm.c                         |   14 +
 arch/parisc/kernel/pdt.c                           |    2 +
 arch/powerpc/crypto/Kconfig                        |    7 +-
 arch/riscv/crypto/Kconfig                          |    1 -
 arch/riscv/include/asm/alternative-macros.h        |   21 +-
 arch/riscv/include/asm/cacheflush.h                |   15 +-
 arch/riscv/kernel/probes/uprobes.c                 |   10 +-
 arch/s390/Kconfig                                  |    4 +-
 arch/s390/crypto/Kconfig                           |    3 +-
 arch/s390/include/asm/pci.h                        |    3 +
 arch/s390/include/asm/sclp.h                       |   33 +
 arch/s390/kvm/intercept.c                          |    2 +-
 arch/s390/kvm/interrupt.c                          |    8 +-
 arch/s390/kvm/kvm-s390.c                           |   10 +-
 arch/s390/kvm/trace-s390.h                         |    4 +-
 arch/s390/pci/Makefile                             |    2 +-
 arch/s390/pci/pci_event.c                          |   21 +-
 arch/s390/pci/pci_fixup.c                          |   23 +
 arch/s390/pci/pci_report.c                         |  111 +
 arch/s390/pci/pci_report.h                         |   16 +
 arch/um/include/linux/time-internal.h              |    2 +
 arch/um/kernel/skas/syscall.c                      |   11 +
 arch/x86/crypto/Kconfig                            |   11 +-
 arch/x86/entry/entry.S                             |    2 +-
 arch/x86/events/core.c                             |    2 +-
 arch/x86/include/asm/cpufeatures.h                 |    1 +
 arch/x86/include/asm/intel-family.h                |    2 +
 arch/x86/kernel/cpu/bugs.c                         |   36 +-
 arch/x86/kernel/i8253.c                            |    3 +-
 arch/x86/kvm/svm/avic.c                            |   66 +-
 arch/x86/kvm/vmx/posted_intr.c                     |   28 +-
 arch/x86/kvm/x86.c                                 |   20 +-
 arch/x86/lib/x86-opcode-map.txt                    |    4 +-
 arch/x86/mm/tlb.c                                  |    6 +-
 arch/x86/pci/xen.c                                 |    8 +-
 arch/x86/xen/enlighten_pvh.c                       |   19 +-
 block/blk-merge.c                                  |   26 +-
 block/blk-mq.c                                     |    6 +-
 block/blk-settings.c                               |    8 +-
 block/mq-deadline.c                                |   13 +-
 crypto/Kconfig                                     |    3 +
 crypto/crypto_null.c                               |   37 +-
 drivers/accel/ivpu/ivpu_drv.c                      |   10 +-
 drivers/accel/ivpu/ivpu_drv.h                      |    2 +
 drivers/accel/ivpu/ivpu_fw.c                       |   18 +-
 drivers/accel/ivpu/ivpu_fw.h                       |    3 +
 drivers/accel/ivpu/ivpu_hw.h                       |   12 +-
 drivers/accel/ivpu/ivpu_hw_btrs.c                  |  128 +-
 drivers/accel/ivpu/ivpu_hw_btrs.h                  |    6 +-
 drivers/accel/ivpu/ivpu_job.c                      |   14 +-
 drivers/accel/ivpu/ivpu_sysfs.c                    |   24 +
 drivers/acpi/ec.c                                  |   28 +
 drivers/acpi/pptt.c                                |    4 +-
 drivers/ata/libata-scsi.c                          |   25 +-
 drivers/base/base.h                                |   17 +
 drivers/base/bus.c                                 |    2 +-
 drivers/base/core.c                                |   38 +-
 drivers/base/dd.c                                  |    7 +-
 drivers/char/misc.c                                |    2 +-
 drivers/char/virtio_console.c                      |    7 +-
 drivers/clk/clk.c                                  |    4 +
 drivers/comedi/drivers/jr3_pci.c                   |    2 +-
 drivers/cpufreq/Kconfig.arm                        |   20 +-
 drivers/cpufreq/apple-soc-cpufreq.c                |   10 +-
 drivers/cpufreq/cppc_cpufreq.c                     |    2 +-
 drivers/cpufreq/scmi-cpufreq.c                     |   10 +-
 drivers/cpufreq/scpi-cpufreq.c                     |   13 +-
 drivers/cpufreq/sun50i-cpufreq-nvmem.c             |   18 +-
 drivers/crypto/atmel-sha204a.c                     |    6 +
 drivers/crypto/ccp/sp-pci.c                        |    1 +
 drivers/cxl/core/regs.c                            |    4 -
 drivers/dma/dmatest.c                              |    6 +-
 drivers/firmware/stratix10-svc.c                   |   14 +-
 drivers/gpio/gpiolib-of.c                          |    6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |    1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |   14 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c            |   19 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |    8 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |   12 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |    6 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c             |    4 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c             |    4 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c             |    4 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |    2 +-
 drivers/gpu/drm/amd/amdgpu/psp_v11_0.c             |    2 +-
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c             |    2 +-
 drivers/gpu/drm/amd/amdgpu/psp_v14_0.c             |    2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |    9 +-
 .../drm/amd/display/dc/dml2/dml21/dml21_wrapper.c  |   11 +-
 drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c |    6 +-
 drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c   |    4 +-
 drivers/gpu/drm/xe/xe_wa_oob.rules                 |    2 +
 drivers/i3c/master/svc-i3c-master.c                |   17 +-
 drivers/iio/adc/ad7768-1.c                         |    5 +-
 drivers/infiniband/hw/qib/qib_fs.c                 |    1 +
 drivers/iommu/amd/iommu.c                          |    2 +-
 drivers/iommu/iommu.c                              |    8 +
 drivers/irqchip/irq-gic-v2m.c                      |    2 +-
 drivers/mailbox/pcc.c                              |   15 +-
 drivers/mcb/mcb-parse.c                            |    2 +-
 drivers/md/raid1.c                                 |   26 +-
 drivers/media/i2c/Kconfig                          |    1 +
 drivers/media/i2c/imx214.c                         |  934 ++++---
 drivers/media/i2c/ov08x40.c                        |   78 +-
 drivers/misc/lkdtm/perms.c                         |   14 +-
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c    |    8 +-
 drivers/misc/mei/hw-me-regs.h                      |    1 +
 drivers/misc/mei/pci-me.c                          |    1 +
 drivers/misc/mei/vsc-tp.c                          |   26 +-
 drivers/mmc/host/sdhci-msm.c                       |    2 +-
 drivers/net/dsa/mt7530.c                           |    6 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   27 +-
 drivers/net/ethernet/amd/pds_core/adminq.c         |   36 +-
 drivers/net/ethernet/amd/pds_core/auxbus.c         |    3 -
 drivers/net/ethernet/amd/pds_core/core.c           |    9 +-
 drivers/net/ethernet/amd/pds_core/core.h           |    4 +-
 drivers/net/ethernet/amd/pds_core/devlink.c        |    4 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   24 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   10 +-
 .../net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c   |   26 +-
 drivers/net/ethernet/sun/niu.c                     |    2 +
 drivers/net/phy/microchip.c                        |   46 +-
 drivers/net/phy/phy_led_triggers.c                 |   23 +-
 drivers/net/vmxnet3/vmxnet3_xdp.c                  |    2 +-
 drivers/net/xen-netfront.c                         |   19 +-
 drivers/ntb/hw/amd/ntb_hw_amd.c                    |    1 +
 drivers/ntb/hw/idt/ntb_hw_idt.c                    |   18 +-
 drivers/nvme/host/core.c                           |    9 +
 drivers/nvme/host/multipath.c                      |    2 +-
 drivers/nvme/target/fc.c                           |   25 +-
 drivers/of/resolver.c                              |   37 +-
 drivers/pci/msi/msi.c                              |   38 +-
 drivers/phy/rockchip/phy-rockchip-usbdp.c          |    1 -
 drivers/pinctrl/pinctrl-mcp23s08.c                 |   23 +-
 drivers/pinctrl/renesas/pinctrl-rza2.c             |    3 +
 drivers/regulator/rk808-regulator.c                |    4 +-
 drivers/rtc/rtc-pcf85063.c                         |   19 +-
 drivers/s390/char/sclp.h                           |   14 -
 drivers/s390/char/sclp_con.c                       |   17 +
 drivers/s390/char/sclp_pci.c                       |   19 +-
 drivers/s390/char/sclp_tty.c                       |   12 +
 drivers/s390/net/ism_drv.c                         |    1 -
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   20 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |    2 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |    1 +
 drivers/scsi/scsi.c                                |   36 +-
 drivers/scsi/scsi_lib.c                            |    6 +-
 drivers/scsi/sd.c                                  |    6 +-
 drivers/soc/qcom/ice.c                             |   48 +
 drivers/spi/spi-imx.c                              |    5 +-
 drivers/spi/spi-tegra210-quad.c                    |    6 +-
 drivers/thunderbolt/tb.c                           |   16 +-
 drivers/tty/serial/msm_serial.c                    |    6 +
 drivers/tty/serial/sifive.c                        |    6 +
 drivers/tty/vt/selection.c                         |    5 +-
 drivers/ufs/core/ufs-mcq.c                         |   12 +-
 drivers/ufs/core/ufshcd.c                          |    2 +
 drivers/ufs/host/ufs-exynos.c                      |  106 +-
 drivers/ufs/host/ufs-exynos.h                      |    8 +-
 drivers/ufs/host/ufs-qcom.c                        |    2 +-
 drivers/usb/cdns3/cdns3-gadget.c                   |    2 +
 drivers/usb/chipidea/ci_hdrc_imx.c                 |   44 +-
 drivers/usb/class/cdc-wdm.c                        |   21 +-
 drivers/usb/core/quirks.c                          |    9 +
 drivers/usb/dwc3/dwc3-pci.c                        |   10 +
 drivers/usb/dwc3/dwc3-xilinx.c                     |    4 +-
 drivers/usb/dwc3/gadget.c                          |   28 +-
 drivers/usb/gadget/udc/aspeed-vhub/dev.c           |    3 +
 drivers/usb/host/max3421-hcd.c                     |    7 +
 drivers/usb/host/ohci-pci.c                        |   23 +
 drivers/usb/host/xhci-hub.c                        |   30 +-
 drivers/usb/host/xhci-mvebu.c                      |   10 -
 drivers/usb/host/xhci-mvebu.h                      |    6 -
 drivers/usb/host/xhci-plat.c                       |    2 +-
 drivers/usb/host/xhci-ring.c                       |   75 +-
 drivers/usb/host/xhci.c                            |    4 +-
 drivers/usb/host/xhci.h                            |    4 +-
 drivers/usb/serial/ftdi_sio.c                      |    2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |    5 +
 drivers/usb/serial/option.c                        |    3 +
 drivers/usb/serial/usb-serial-simple.c             |    7 +
 drivers/usb/storage/unusual_uas.h                  |    7 +
 drivers/usb/typec/class.c                          |   24 +-
 drivers/usb/typec/class.h                          |    1 +
 drivers/vhost/scsi.c                               |   80 +-
 drivers/xen/Kconfig                                |    2 +-
 fs/btrfs/file.c                                    |    9 +-
 fs/btrfs/zoned.c                                   |    1 -
 fs/ceph/inode.c                                    |    2 +-
 fs/ext4/block_validity.c                           |    5 +-
 fs/ext4/inode.c                                    |    9 +-
 fs/iomap/buffered-io.c                             |    2 +-
 fs/namespace.c                                     |   69 +-
 fs/netfs/main.c                                    |    4 +
 fs/ntfs3/file.c                                    |   20 +-
 fs/smb/client/sess.c                               |   60 +-
 fs/smb/client/smb1ops.c                            |   36 +
 fs/smb/server/asn1.c                               |    6 +-
 fs/smb/server/auth.c                               |   19 +-
 fs/smb/server/connection.c                         |    8 +-
 fs/smb/server/crypto_ctx.c                         |    6 +-
 fs/smb/server/glob.h                               |    2 +
 fs/smb/server/ksmbd_netlink.h                      |    3 +-
 fs/smb/server/ksmbd_work.c                         |   10 +-
 fs/smb/server/mgmt/ksmbd_ida.c                     |   11 +-
 fs/smb/server/mgmt/share_config.c                  |   10 +-
 fs/smb/server/mgmt/tree_connect.c                  |    5 +-
 fs/smb/server/mgmt/user_config.c                   |    8 +-
 fs/smb/server/mgmt/user_session.c                  |   10 +-
 fs/smb/server/misc.c                               |   11 +-
 fs/smb/server/ndr.c                                |   10 +-
 fs/smb/server/oplock.c                             |   12 +-
 fs/smb/server/server.c                             |    4 +-
 fs/smb/server/server.h                             |    1 +
 fs/smb/server/smb2pdu.c                            |   42 +-
 fs/smb/server/smb_common.c                         |    2 +-
 fs/smb/server/smbacl.c                             |   23 +-
 fs/smb/server/transport_ipc.c                      |    7 +-
 fs/smb/server/transport_rdma.c                     |   10 +-
 fs/smb/server/transport_tcp.c                      |   93 +-
 fs/smb/server/transport_tcp.h                      |    2 +
 fs/smb/server/unicode.c                            |    4 +-
 fs/smb/server/vfs.c                                |   12 +-
 fs/smb/server/vfs_cache.c                          |   18 +-
 fs/splice.c                                        |    2 +-
 fs/xfs/xfs_aops.c                                  |   41 +-
 fs/xfs/xfs_qm_bhv.c                                |   49 +-
 fs/xfs/xfs_super.c                                 |    8 +-
 include/drm/intel/i915_pciids.h                    |    1 +
 include/linux/blk-mq.h                             |    8 +-
 include/linux/energy_model.h                       |   12 +-
 include/linux/msi.h                                |    3 +-
 include/linux/pci.h                                |    2 +
 include/linux/pci_ids.h                            |    1 +
 include/net/netfilter/nft_fib.h                    |   21 +
 include/soc/qcom/ice.h                             |    2 +
 include/trace/events/block.h                       |    6 +-
 include/trace/stages/stage3_trace_output.h         |    8 +
 include/trace/stages/stage7_class_define.h         |    1 +
 include/uapi/drm/ivpu_accel.h                      |    4 +-
 init/Kconfig                                       |    2 +-
 io_uring/io_uring.c                                |   15 +-
 io_uring/refs.h                                    |    7 +
 kernel/bpf/bpf_cgrp_storage.c                      |   11 +-
 kernel/bpf/hashtab.c                               |    6 +-
 kernel/bpf/preload/bpf_preload_kern.c              |    1 +
 kernel/bpf/syscall.c                               |    6 +-
 kernel/bpf/verifier.c                              |   32 +
 kernel/cgroup/cgroup.c                             |   29 +
 kernel/cgroup/cpuset-internal.h                    |    1 +
 kernel/cgroup/cpuset.c                             |   14 +
 kernel/dma/contiguous.c                            |    3 +-
 kernel/events/core.c                               |    6 +-
 kernel/irq/msi.c                                   |    2 +-
 kernel/module/Kconfig                              |    1 +
 kernel/panic.c                                     |    6 +
 kernel/power/energy_model.c                        |   47 +-
 kernel/sched/ext.c                                 |    4 +-
 kernel/time/tick-common.c                          |   22 +
 kernel/trace/bpf_trace.c                           |    7 +-
 kernel/trace/trace_events.c                        |    7 +
 lib/Kconfig.ubsan                                  |    1 -
 lib/crypto/Kconfig                                 |   37 +-
 lib/test_ubsan.c                                   |   18 +-
 mm/vmscan.c                                        |    7 +
 net/9p/client.c                                    |   30 +-
 net/9p/trans_fd.c                                  |   17 +-
 net/core/lwtunnel.c                                |   26 +-
 net/core/selftests.c                               |   18 +-
 net/ipv4/netfilter/nft_fib_ipv4.c                  |   11 +-
 net/ipv6/netfilter/nft_fib_ipv6.c                  |   19 +-
 net/sched/sch_hfsc.c                               |   23 +-
 net/tipc/monitor.c                                 |    3 +-
 rust/kernel/firmware.rs                            |    8 +-
 samples/trace_events/trace-events-sample.h         |   13 +-
 scripts/Makefile.lib                               |    2 +-
 scripts/Makefile.vmlinux                           |    4 +
 sound/soc/codecs/wcd934x.c                         |    2 +-
 sound/soc/fsl/fsl_asrc_dma.c                       |   15 +-
 sound/virtio/virtio_pcm.c                          |   21 +-
 tools/arch/x86/lib/x86-opcode-map.txt              |    4 +-
 tools/bpf/bpftool/prog.c                           |    1 +
 tools/objtool/check.c                              |   36 +-
 tools/testing/selftests/bpf/network_helpers.c      |   33 +-
 .../selftests/bpf/prog_tests/xdp_cpumap_attach.c   |   44 +-
 .../selftests/bpf/prog_tests/xdp_devmap_attach.c   |    8 +-
 .../bpf/progs/test_xdp_with_cpumap_helpers.c       |    7 +-
 tools/testing/selftests/mincore/mincore_selftest.c |    3 -
 tools/testing/selftests/ublk/test_stripe_04.sh     |   24 +
 312 files changed, 6080 insertions(+), 4681 deletions(-)


