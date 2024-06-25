Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1383D14A084;
	Tue, 25 Jun 2024 09:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308878; cv=none; b=SmmFZFS8DMNgOuHWzW8My5Ct4S5xd0oiBgcX+sieJ09gT4yDK9cybkaLEptp10oSsIQ3va+jHtndiRJRILyehZKfDZ4QjUPnkP9xzlZ5cvc8fcjHzC4F1yu8bnKAwYg88AhH1Vubg1AC4OqEZS0fJVwmqgqIcjirJFIkoTa5Nx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308878; c=relaxed/simple;
	bh=l2V0FCZmj2g8shRr+48x9FMKDdAcwj3nBJjY44MyJZw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IGTPyAA/tCr06yfrdzzMAZ+IxuL1mTL351vOseIkQVAQ6Igi6J9jK311y2baPVASwfGQqlmiLYILP55ioYZhJ/z7GO3CDqx5emX/d6CZdAlmHsSvYh7YjXzgsNRE0FKYKMhIs+3Q23oUQDRuohUsMcXnxONAUomOd7VF+l4MnqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a+XOEGB8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a+XOEGB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBE3C32781;
	Tue, 25 Jun 2024 09:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308877;
	bh=l2V0FCZmj2g8shRr+48x9FMKDdAcwj3nBJjY44MyJZw=;
	h=From:To:Cc:Subject:Date:From;
	b=a+XOEGB8RtmlTVwiIepxxEM5mjqzHNhVwq/fGHYpLKEv0vA3LNJhPu6BrGyJ7YrLQ
	 gFznn8apAJtW8KBgdjr0i08w4GP5kkn9My2Rg69fiCK2KTarG+9ysZMrk3/FxSaVw4
	 Eeeo+S+vCqYRXtG6SbwObhtEL8QlwX61fbCLPAys=
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
Subject: [PATCH 6.6 000/192] 6.6.36-rc1 review
Date: Tue, 25 Jun 2024 11:31:12 +0200
Message-ID: <20240625085537.150087723@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.36-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.36-rc1
X-KernelTest-Deadline: 2024-06-27T08:55+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.36 release.
There are 192 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.36-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.36-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    Revert "mm: mmap: allow for the maximum number of bits for randomizing mmap_base by default"

Andrew Ballance <andrewjballance@gmail.com>
    hid: asus: asus_report_fixup: fix potential read out of bounds

Linus Torvalds <torvalds@linux-foundation.org>
    kprobe/ftrace: fix build error due to bad function definition

Davide Caratti <dcaratti@redhat.com>
    net/sched: unregister lockdep keys in qdisc_create/qdisc_alloc error path

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof-sdw: really remove FOUR_SPEAKER quirk

Martin Leung <martin.leung@amd.com>
    drm/amd/display: revert Exit idle optimizations before HDCP execution

Jiaxun Yang <jiaxun.yang@flygoat.com>
    LoongArch: Fix entry point in kernel image header

Wang Yao <wangyao@lemote.com>
    efi/loongarch: Directly position the loaded image file

Arnd Bergmann <arnd@arndb.de>
    efi: move screen_info into efi init code

Arnd Bergmann <arnd@arndb.de>
    vgacon: rework screen_info #ifdef checks

Nam Cao <namcao@linutronix.de>
    riscv: force PAGE_SIZE linear mapping if debug_pagealloc is enabled

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Don't use PGD entries for the linear mapping

Tony Luck <tony.luck@intel.com>
    x86/cpu: Fix x86_match_cpu() to match just X86_VENDOR_INTEL

Tony Luck <tony.luck@intel.com>
    x86/cpu/vfm: Add new macros to work with (vendor/family/model) values

Jeff Johnson <quic_jjohnson@quicinc.com>
    tracing: Add MODULE_DESCRIPTION() to preemptirq_delay_test

Bart Van Assche <bvanassche@acm.org>
    nbd: Fix signal handling

Bart Van Assche <bvanassche@acm.org>
    nbd: Improve the documentation of the locking assumptions

Su Yue <glass.su@suse.com>
    ocfs2: update inode fsync transaction id in ocfs2_unlink and ocfs2_link

Jeff Layton <jlayton@kernel.org>
    ocfs2: convert to new timestamp accessors

Martin Kaistra <martin.kaistra@linutronix.de>
    wifi: rtl8xxxu: enable MFP support with security flag of RX descriptor

Adrian Hunter <adrian.hunter@intel.com>
    perf script: Show also errors for --insn-trace option

Changbin Du <changbin.du@huawei.com>
    perf: script: add raw|disasm arguments to --insn-trace option

Patrice Chotard <patrice.chotard@foss.st.com>
    spi: stm32: qspi: Clamp stm32_qspi_get_mode() output to CCR_BUSWIDTH_4

Frank Li <Frank.Li@nxp.com>
    arm64: dts: imx8qm-mek: fix gpio number for reg_usdhc2_vmmc

Patrice Chotard <patrice.chotard@foss.st.com>
    spi: stm32: qspi: Fix dual flash mode sanity test in stm32_qspi_setup()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: i2c: google,cros-ec-i2c-tunnel: correct path to i2c-controller schema

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: i2c: atmel,at91sam: correct path to i2c-controller schema

Grygorii Tertychnyi <grembeter@gmail.com>
    i2c: ocores: set IACK bit after core is enabled

Peter Xu <peterx@redhat.com>
    mm/page_table_check: fix crash on ZONE_DEVICE

Eric Dumazet <edumazet@google.com>
    tcp: clear tp->retrans_stamp in tcp_rcv_fastopen_synack()

Rafael Aquini <aquini@redhat.com>
    mm: mmap: allow for the maximum number of bits for randomizing mmap_base by default

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_dw: Revert "Move definitions to the shared header"

Ard Biesheuvel <ardb@kernel.org>
    efi/x86: Free EFI memory map only when installing a new one.

Aleksandr Nogikh <nogikh@google.com>
    kcov: don't lose track of remote references during softirqs

Peter Oberparleiter <oberpar@linux.ibm.com>
    gcov: add support for GCC 14

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix NULL pointer dereference in ocfs2_abort_trigger()

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix NULL pointer dereference in ocfs2_journal_dirty()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: dma: fsl-edma: fix dma-channels constraints

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix UBSAN warning in kv_dpm.c

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix UBSAN warning in kv_dpm.c

Jani Nikula <jani.nikula@intel.com>
    drm/i915/mso: using joiner is not possible with eDP MSO

Pablo Caño <pablocpascual@gmail.com>
    ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14AHP9

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Limit mic boost on N14AP7

Andy Chi <andy.chi@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs don't work for ProBook 445/465 G11.

Miklos Szeredi <mszeredi@redhat.com>
    ovl: fix encoding fid for lower only root

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx5: Follow rb_key.ats when creating new mkeys

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx5: Remove extra unlock on error path

Honggang LI <honggangli@163.com>
    RDMA/rxe: Fix data copy for IB_SEND_INLINE

Sean Christopherson <seanjc@google.com>
    KVM: x86: Always sync PIR to IRR prior to scanning I/O APIC routes

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Disassociate vcpus from redistributor region on teardown

Breno Leitao <leitao@debian.org>
    KVM: Fix a data race on last_boosted_vcpu in kvm_vcpu_on_spin()

Hui Li <lihui@loongson.cn>
    LoongArch: Fix multiple hardware watchpoint issues

Hui Li <lihui@loongson.cn>
    LoongArch: Trigger user-space watchpoints correctly

Hui Li <lihui@loongson.cn>
    LoongArch: Fix watchpoint setting error

Steve French <stfrench@microsoft.com>
    cifs: fix typo in module parameter enable_gcm_256

Joel Slebodnick <jslebodn@redhat.com>
    scsi: ufs: core: Free memory allocated for model before reinit

Boris Burkov <boris@bur.io>
    btrfs: retry block group reclaim without infinite loop

Ignat Korchagin <ignat@cloudflare.com>
    net: do not leave a dangling sk pointer, when socket creation fails

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    net: usb: ax88179_178a: improve reset check

Oleksij Rempel <o.rempel@pengutronix.de>
    net: stmmac: Assign configured channel value to EXTTS event

Carlos Llamas <cmllamas@google.com>
    locking/atomic: scripts: fix ${atomic}_sub_and_test() kerneldoc

Baokun Li <libaokun1@huawei.com>
    ext4: fix slab-out-of-bounds in ext4_mb_find_good_group_avg_frag_lists()

Baokun Li <libaokun1@huawei.com>
    ext4: avoid overflow when setting values via sysfs

Martin Kaiser <martin@kaiser.cx>
    arm64: defconfig: enable the vf610 gpio driver

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: Evaluate orphan _REG under EC device

Konstantin Taranov <kotaranov@microsoft.com>
    RDMA/mana_ib: Ignore optional access flags for MRs

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Add check for srq max_sge attribute

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Fix unwind flow as part of mlx5_ib_stage_init_init

Sudeep Holla <sudeep.holla@arm.com>
    firmware: psci: Fix return value from psci_system_suspend()

Chenliang Li <cliang01.li@samsung.com>
    io_uring/rsrc: fix incorrect assignment of iter->nr_segs in io_import_fixed

Marc Kleine-Budde <mkl@pengutronix.de>
    spi: spi-imx: imx51: revert burst length calculation back to bits_per_word

Raju Rangoju <Raju.Rangoju@amd.com>
    ACPICA: Revert "ACPICA: avoid Info: mapping multiple BARs. Your kernel is fine."

Max Krummenacher <max.krummenacher@toradex.com>
    arm64: dts: freescale: imx8mm-verdin: enable hysteresis on slow input pin

Fabio Estevam <festevam@gmail.com>
    arm64: dts: imx93-11x11-evk: Remove the 'no-sdio' property

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: freescale: imx8mp-venice-gw73xx-2x: fix BT shutdown GPIO

Marek Vasut <marex@denx.de>
    arm64: dts: imx8mp: Fix TC9595 input clock on DH i.MX8M Plus DHCOM SoM

Marek Vasut <marex@denx.de>
    arm64: dts: imx8mp: Fix TC9595 reset GPIO on DH i.MX8M Plus DHCOM SoM

Julien Panis <jpanis@baylibre.com>
    thermal/drivers/mediatek/lvts_thermal: Return error in case of invalid efuse data

Kalle Niemi <kaleposti@gmail.com>
    regulator: bd71815: fix ramp values

Nikita Shubin <n.shubin@yadro.com>
    dmaengine: ioatdma: Fix missing kmem_cache_destroy()

Arnd Bergmann <arnd@arndb.de>
    dmaengine: fsl-edma: avoid linking both modules

Nikita Shubin <n.shubin@yadro.com>
    dmaengine: ioatdma: Fix kmemleak in ioat_pci_probe()

Nikita Shubin <n.shubin@yadro.com>
    dmaengine: ioatdma: Fix error path in ioat3_dma_probe()

Nikita Shubin <n.shubin@yadro.com>
    dmaengine: ioatdma: Fix leaking on version mismatch

Li RongQing <lirongqing@baidu.com>
    dmaengine: idxd: Fix possible Use-After-Free in irq_process_work_list

Biju Das <biju.das.jz@bp.renesas.com>
    regulator: core: Fix modpost error "regulator_get_regmap" undefined

Honggang LI <honggangli@163.com>
    RDMA/rxe: Fix responder length checking for UD request packets

Charles Keepax <ckeepax@opensource.cirrus.com>
    spi: cs42l43: Correct SPI root clock speed

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix the max msix vectors macro

Oliver Neukum <oneukum@suse.com>
    net: usb: rtl8150 fix unintiatilzed variables in rtl8150_get_link_ksettings

Pavan Chebbi <pavan.chebbi@broadcom.com>
    bnxt_en: Restore PTP tx_avail count in case of skb_pad() error

Marcin Szycik <marcin.szycik@linux.intel.com>
    ice: Fix VSI list rule with ICE_SW_LKUP_LAST type

Jianguo Wu <wujianguo@chinatelecom.cn>
    netfilter: move the sysctl nf_hooks_lwtunnel into the netfilter core

Jianguo Wu <wujianguo@chinatelecom.cn>
    seg6: fix parameter passing when calling NF_HOOK() in End.DX4 and End.DX6 behaviors

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Fix suspicious rcu_dereference_protected()

Geetha sowjanya <gakula@marvell.com>
    octeontx2-pf: Fix linking objects into multiple modules

Simon Horman <horms@kernel.org>
    octeontx2-pf: Add error handling to VLAN unoffload handling

Heng Qi <hengqi@linux.alibaba.com>
    virtio_net: fixing XDP for fully checksummed packets handling

Heng Qi <hengqi@linux.alibaba.com>
    virtio_net: checksum offloading handling fix

Xiaolei Wang <xiaolei.wang@windriver.com>
    net: stmmac: No need to calculate speed divider when offload is disabled

Simon Horman <horms@kernel.org>
    selftests: openvswitch: Use bash as interpreter

Dan Carpenter <dan.carpenter@linaro.org>
    ptp: fix integer overflow in max_vclocks_store

Xin Long <lucien.xin@gmail.com>
    sched: act_ct: add netns into the key of tcf_ct_flow_table

Xin Long <lucien.xin@gmail.com>
    tipc: force a dst refcount before doing decryption

David Ruth <druth@chromium.org>
    net/sched: act_api: fix possible infinite loop in tcf_idr_check_alloc()

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: act_api: rely on rcu in tcf_idr_check_alloc

Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
    net: phy: mxl-gpy: Remove interrupt mask clearing from config_init

Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
    net: lan743x: Support WOL at both the PHY and MAC appropriately

Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
    net: lan743x: disable WOL upon resume to restore full data path operation

Stefan Wahren <wahrenst@gmx.net>
    qca_spi: Make interrupt remembering atomic

Yue Haibing <yuehaibing@huawei.com>
    netns: Make get_net_ns() handle zero refcount net

Eric Dumazet <edumazet@google.com>
    xfrm6: check ip6_dst_idev() return value in xfrm6_get_saddr()

Eric Dumazet <edumazet@google.com>
    ipv6: prevent possible NULL dereference in rt6_probe()

Eric Dumazet <edumazet@google.com>
    ipv6: prevent possible NULL deref in fib6_nh_init()

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    netrom: Fix a memory leak in nr_heartbeat_expiry()

Ajrat Makhmutov <rautyrauty@gmail.com>
    ALSA: hda/realtek: Enable headset mic on IdeaPad 330-17IKB 81DM

Florian Westphal <fw@strlen.de>
    bpf: Avoid splat in pskb_pull_reason

Simon Trimmer <simont@opensource.cirrus.com>
    ALSA: hda: tas2781: Component should be unbound before deconstruction

Simon Trimmer <simont@opensource.cirrus.com>
    ALSA: hda: cs35l56: Component should be unbound before deconstruction

Ondrej Mosnacek <omosnace@redhat.com>
    cipso: fix total option length computation

Aryan Srivastava <aryan.srivastava@alliedtelesis.co.nz>
    net: mvpp2: use slab_build_skb for oversized frames

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: allocate dummy checksums for zoned NODATASUM writes

En-Wei Wu <en-wei.wu@canonical.com>
    ice: avoid IRQ collision to fix init failure on ACPI S3 resume

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA/hda: intel-dsp-config: Document AVS as dsp_driver option

Dustin L. Howett <dustin@howett.net>
    ALSA: hda/realtek: Remove Framework Laptop 16 from quirks

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: Build event generation tests only as modules

Christian Marangi <ansuelsmth@gmail.com>
    mips: bmips: BCM6358: make sure CBR is correctly set

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    MIPS: Routerboard 532: Fix vendor retry check code

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: ump: Fix missing System Reset message handling

Simon Trimmer <simont@opensource.cirrus.com>
    ALSA: hda: cs35l41: Possible null pointer dereference in cs35l41_hda_unbind()

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Do not wait for disconnected devices when resuming

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: Install address space handler at the namespace root

Peng Ma <andypma@tencent.com>
    cpufreq: amd-pstate: fix memory leak on CPU EPP exit

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Collect hot-reset devices to local buffer

Linus Torvalds <torvalds@linux-foundation.org>
    tty: add the option to have a tty reject a new ldisc

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: gadget: function: Remove usage of the deprecated ida_simple_xx() API

Parker Newman <pnewman@connecttech.com>
    serial: exar: adding missing CTI and Exar PCI ids

Esben Haabendal <esben@geanix.com>
    serial: imx: Introduce timeout when waiting on transmitter empty

Songyang Li <leesongyang@outlook.com>
    MIPS: Octeon: Add PCIe link status check

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: don't set RO when shutting down f2fs

Mario Limonciello <mario.limonciello@amd.com>
    PCI/PM: Avoid D3cold for HP Pavilion 17 PC/1972 PCIe Ports

Roman Smirnov <r.smirnov@omp.ru>
    udf: udftime: prevent overflow in udf_disk_stamp_to_time()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    usb: typec: ucsi_glink: drop special handling for CCI_BUSY

Hans de Goede <hdegoede@redhat.com>
    usb: dwc3: pci: Don't set "linux,phy_charger_detect" property on Lenovo Yoga Tab2 1380

Joao Pinto <Joao.Pinto@synopsys.com>
    Avoid hw_desc array overrun in dw-axi-dmac

Alex Henrie <alexhenrie24@gmail.com>
    usb: misc: uss720: check for incompatible versions of the Belkin F5U002

Yunlei He <heyunlei@oppo.com>
    f2fs: remove clear SB_INLINECRYPT flag in default_options

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: gadget: uvc: configfs: ensure guid to be valid before set

Stephen Brennan <stephen.s.brennan@oracle.com>
    kprobe/ftrace: bail out if ftrace was killed

Baokun Li <libaokun1@huawei.com>
    ext4: fix uninitialized ratelimit_state->lock access in __ext4_fill_super()

Aleksandr Aprelkov <aaprelkov@usergate.com>
    iommu/arm-smmu-v3: Free MSIs in case of ENOMEM

Tzung-Bi Shih <tzungbi@kernel.org>
    power: supply: cros_usbpd: provide ID table for avoiding fallback match

Ben Fradella <bfradell@netapp.com>
    platform/x86: p2sb: Don't init until unassigned resources have been assigned

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/io: Avoid clang null pointer arithmetic warnings

Fullway Wang <fullwaywang@outlook.com>
    media: mtk-vcodec: potential null pointer deference in SCP

Ricardo Ribalda <ribalda@chromium.org>
    media: intel/ipu6: Fix build with !ACPI

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries: Enforce hcall result buffer validity and size

Stefan Binding <sbinding@opensource.cirrus.com>
    ALSA: hda/realtek: Add quirks for Lenovo 13X

Erico Nunes <nunes.erico@gmail.com>
    drm/lima: mask irqs in timeout path before hard reset

Erico Nunes <nunes.erico@gmail.com>
    drm/lima: add mask irq callback to gp and pp

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: add quirk for Dell SKU 0C0F

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: add JD2 quirk for HP Omen 14

Arvid Norlander <lkml@vorpal.se>
    platform/x86: toshiba_acpi: Add quirk for buttons on Z830

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Exit idle optimizations before HDCP execution

Uri Arev <me@wantyapps.xyz>
    Bluetooth: ath3k: Fix multiple issues reported by checkpatch.pl

Takashi Iwai <tiwai@suse.de>
    ACPI: video: Add backlight=native quirk for Lenovo Slim 7 16ARH7

Luke D. Jones <luke@ljones.dev>
    HID: asus: fix more n-key report descriptors if n-key quirked

Sean O'Brien <seobrien@chromium.org>
    HID: Add quirk for Logitech Casa touchpad

Leon Yen <leon.yen@mediatek.com>
    wifi: mt76: mt7921s: fix potential hung tasks during chip recovery

Breno Leitao <leitao@debian.org>
    netpoll: Fix race condition in netpoll_owner_active

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    net: dsa: realtek: keep default LED state in rtl8366rb

Kunwu Chan <chentao@kylinos.cn>
    kselftest: arm64: Add a null pointer check

Davide Caratti <dcaratti@redhat.com>
    net/sched: fix false lockdep warning on qdisc root lock

Daniel Golle <daniel@makrotopia.org>
    net: sfp: add quirk for ATS SFP-GE-T 1000Base-TX module

Manish Rangankar <mrangankar@marvell.com>
    scsi: qedi: Fix crash while reading debugfs attribute

Wander Lairson Costa <wander@redhat.com>
    drop_monitor: replace spin_lock by raw_spin_lock

Hans de Goede <hdegoede@redhat.com>
    ACPI: x86: Add PNP_UART1_SKIP quirk for Lenovo Blade2 tablets

Eric Dumazet <edumazet@google.com>
    af_packet: avoid a false positive warning in packet_setsockopt()

Arnd Bergmann <arnd@arndb.de>
    wifi: ath9k: work around memset overflow warning

Eric Dumazet <edumazet@google.com>
    batman-adv: bypass empty buckets in batadv_purge_orig_ref()

Yonghong Song <yonghong.song@linux.dev>
    selftests/bpf: Fix flaky test btf_map_in_map/lookup_update

Alessandro Carminati (Red Hat) <alessandro.carminati@gmail.com>
    selftests/bpf: Prevent client connect before server bind in test_tc_tunnel.sh

Rand Deeb <rand.sec96@gmail.com>
    ssb: Fix potential NULL pointer dereference in ssb_device_uevent()

Justin Stitt <justinstitt@google.com>
    block/ioctl: prefer different overflow check

Zqiang <qiang.zhang1211@gmail.com>
    rcutorture: Fix invalid context warning when enable srcu barrier testing

Zqiang <qiang.zhang1211@gmail.com>
    rcutorture: Make stall-tasks directly exit when rcutorture tests end

Paul E. McKenney <paulmck@kernel.org>
    rcutorture: Fix rcu_torture_one_read() pipe_count overflow comment

Jens Axboe <axboe@kernel.dk>
    io_uring/sqpoll: work around a potential audit memory leak

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon/qm - Add the err memory release process to qm uninit

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon/sec - Fix memory leak for sec resource release

Herbert Xu <herbert@gondor.apana.org.au>
    padata: Disable BH when taking works lock on MT path

Kemeng Shi <shikemeng@huaweicloud.com>
    fs/writeback: bail out if there is no more inodes for IO and queued once


-------------

Diffstat:

 .../devicetree/bindings/dma/fsl,edma.yaml          |   4 +-
 .../devicetree/bindings/i2c/atmel,at91sam-i2c.yaml |   2 +-
 .../bindings/i2c/google,cros-ec-i2c-tunnel.yaml    |   2 +-
 Makefile                                           |   4 +-
 arch/alpha/kernel/setup.c                          |   2 +
 arch/alpha/kernel/sys_sio.c                        |   2 +
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi   |   2 +-
 .../arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi |   4 +-
 .../boot/dts/freescale/imx8mp-venice-gw73xx.dtsi   |   2 +-
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts       |   2 +-
 arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts  |   1 -
 arch/arm64/configs/defconfig                       |   1 +
 arch/arm64/kernel/efi.c                            |   4 -
 arch/arm64/kernel/image-vars.h                     |   2 +
 arch/arm64/kvm/vgic/vgic-init.c                    |   2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |  15 +-
 arch/arm64/kvm/vgic/vgic.h                         |   2 +-
 arch/csky/kernel/probes/ftrace.c                   |   3 +
 arch/ia64/kernel/setup.c                           |   6 +
 arch/loongarch/include/asm/efi.h                   |   2 -
 arch/loongarch/include/asm/hw_breakpoint.h         |   4 +-
 arch/loongarch/kernel/efi.c                        |   8 +-
 arch/loongarch/kernel/ftrace_dyn.c                 |   3 +
 arch/loongarch/kernel/head.S                       |   3 +-
 arch/loongarch/kernel/hw_breakpoint.c              |  96 ++++++-----
 arch/loongarch/kernel/image-vars.h                 |   3 +-
 arch/loongarch/kernel/ptrace.c                     |  47 ++---
 arch/loongarch/kernel/setup.c                      |   3 -
 arch/loongarch/kernel/vmlinux.lds.S                |  11 +-
 arch/mips/bmips/setup.c                            |   3 +-
 arch/mips/kernel/setup.c                           |   2 +-
 arch/mips/pci/ops-rc32434.c                        |   4 +-
 arch/mips/pci/pcie-octeon.c                        |   6 +
 arch/mips/sibyte/swarm/setup.c                     |   2 +-
 arch/mips/sni/setup.c                              |   2 +-
 arch/parisc/kernel/ftrace.c                        |   3 +
 arch/powerpc/include/asm/hvcall.h                  |   8 +-
 arch/powerpc/include/asm/io.h                      |  24 +--
 arch/powerpc/kernel/kprobes-ftrace.c               |   3 +
 arch/riscv/kernel/image-vars.h                     |   2 +
 arch/riscv/kernel/probes/ftrace.c                  |   3 +
 arch/riscv/kernel/setup.c                          |  12 --
 arch/riscv/mm/init.c                               |  13 +-
 arch/s390/kernel/ftrace.c                          |   3 +
 arch/x86/include/asm/cpu_device_id.h               |  98 +++++++++++
 arch/x86/include/asm/efi.h                         |   1 -
 arch/x86/kernel/cpu/match.c                        |   4 +-
 arch/x86/kernel/kprobes/ftrace.c                   |   3 +
 arch/x86/kvm/x86.c                                 |   9 +-
 arch/x86/platform/efi/memmap.c                     |  12 +-
 block/ioctl.c                                      |   2 +-
 drivers/acpi/acpica/acevents.h                     |   4 +
 drivers/acpi/acpica/evregion.c                     |   6 +-
 drivers/acpi/acpica/evxfregn.c                     |  54 ++++++
 drivers/acpi/acpica/exregion.c                     |  23 +--
 drivers/acpi/ec.c                                  |  28 ++-
 drivers/acpi/internal.h                            |   1 -
 drivers/acpi/video_detect.c                        |   8 +
 drivers/acpi/x86/utils.c                           |  20 ++-
 drivers/block/nbd.c                                |  34 ++--
 drivers/bluetooth/ath3k.c                          |  25 ++-
 drivers/cpufreq/amd-pstate.c                       |   7 +
 drivers/crypto/hisilicon/qm.c                      |   5 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |   4 +-
 drivers/dma/Kconfig                                |   2 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |   6 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac.h              |   1 +
 drivers/dma/idxd/irq.c                             |   4 +-
 drivers/dma/ioat/init.c                            |  55 +++---
 drivers/firmware/efi/efi-init.c                    |  14 +-
 drivers/firmware/efi/libstub/efi-stub-entry.c      |   8 +-
 drivers/firmware/efi/libstub/loongarch-stub.c      |   9 +-
 drivers/firmware/efi/libstub/loongarch-stub.h      |   4 +
 drivers/firmware/efi/libstub/loongarch.c           |   8 +-
 drivers/firmware/efi/memmap.c                      |   9 -
 drivers/firmware/psci/psci.c                       |   4 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c         |   2 +
 drivers/gpu/drm/i915/display/intel_dp.c            |   4 +
 drivers/gpu/drm/lima/lima_bcast.c                  |  12 ++
 drivers/gpu/drm/lima/lima_bcast.h                  |   3 +
 drivers/gpu/drm/lima/lima_gp.c                     |   8 +
 drivers/gpu/drm/lima/lima_pp.c                     |  18 ++
 drivers/gpu/drm/lima/lima_sched.c                  |   7 +
 drivers/gpu/drm/lima/lima_sched.h                  |   1 +
 drivers/gpu/drm/radeon/sumo_dpm.c                  |   2 +
 drivers/hid/hid-asus.c                             |  51 +++---
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-multitouch.c                       |   6 +
 drivers/i2c/busses/i2c-ocores.c                    |   2 +-
 drivers/infiniband/hw/bnxt_re/bnxt_re.h            |   4 +-
 drivers/infiniband/hw/mana/mr.c                    |   1 +
 drivers/infiniband/hw/mlx5/main.c                  |   4 +-
 drivers/infiniband/hw/mlx5/mr.c                    |   5 +-
 drivers/infiniband/hw/mlx5/srq.c                   |  13 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |  13 ++
 drivers/infiniband/sw/rxe/rxe_verbs.c              |   2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   2 +-
 drivers/media/pci/intel/ipu-bridge.c               |  66 +++++--
 .../mediatek/vcodec/common/mtk_vcodec_fw_scp.c     |   2 +
 drivers/net/dsa/realtek/rtl8366rb.c                |  87 +++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   5 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   7 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |   6 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   5 +-
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_dcbnl.c    |   7 +
 .../ethernet/marvell/octeontx2/nic/otx2_devlink.c  |   2 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |   5 +-
 drivers/net/ethernet/microchip/lan743x_ethtool.c   |  44 ++++-
 drivers/net/ethernet/microchip/lan743x_main.c      |  48 +++++-
 drivers/net/ethernet/microchip/lan743x_main.h      |  28 +++
 drivers/net/ethernet/qualcomm/qca_debug.c          |   6 +-
 drivers/net/ethernet/qualcomm/qca_spi.c            |  16 +-
 drivers/net/ethernet/qualcomm/qca_spi.h            |   3 +-
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |   6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  40 +++--
 drivers/net/phy/mxl-gpy.c                          |  58 ++++---
 drivers/net/phy/sfp.c                              |   3 +
 drivers/net/usb/ax88179_178a.c                     |  18 +-
 drivers/net/usb/rtl8150.c                          |   3 +-
 drivers/net/virtio_net.c                           |  32 +++-
 drivers/net/wireless/ath/ath.h                     |   6 +-
 drivers/net/wireless/ath/ath9k/main.c              |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   2 +
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |   2 -
 .../net/wireless/mediatek/mt76/mt7921/sdio_mac.c   |   2 -
 drivers/net/wireless/mediatek/mt76/sdio.c          |   3 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   9 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   7 +-
 drivers/pci/pci.c                                  |  17 ++
 drivers/platform/x86/p2sb.c                        |  29 ++--
 drivers/platform/x86/toshiba_acpi.c                |  36 +++-
 drivers/power/supply/cros_usbpd-charger.c          |  11 +-
 drivers/ptp/ptp_sysfs.c                            |   3 +-
 drivers/regulator/bd71815-regulator.c              |   2 +-
 drivers/regulator/core.c                           |   1 +
 drivers/scsi/qedi/qedi_debugfs.c                   |  12 +-
 drivers/spi/spi-cs42l43.c                          |   2 +-
 drivers/spi/spi-imx.c                              |  14 +-
 drivers/spi/spi-stm32-qspi.c                       |  12 +-
 drivers/ssb/main.c                                 |   4 +-
 drivers/thermal/mediatek/lvts_thermal.c            |   6 +-
 drivers/tty/serial/8250/8250_dw.c                  |  27 +++
 drivers/tty/serial/8250/8250_dwlib.h               |  32 ----
 drivers/tty/serial/8250/8250_exar.c                |  42 +++++
 drivers/tty/serial/imx.c                           |   7 +-
 drivers/tty/tty_ldisc.c                            |   6 +
 drivers/tty/vt/vt.c                                |  10 ++
 drivers/ufs/core/ufshcd.c                          |   1 +
 drivers/usb/dwc3/dwc3-pci.c                        |   8 +-
 drivers/usb/gadget/function/f_hid.c                |   6 +-
 drivers/usb/gadget/function/f_printer.c            |   6 +-
 drivers/usb/gadget/function/rndis.c                |   4 +-
 drivers/usb/gadget/function/uvc_configfs.c         |  14 +-
 drivers/usb/misc/uss720.c                          |  22 ++-
 drivers/usb/typec/ucsi/ucsi_glink.c                |   8 +-
 drivers/vfio/pci/vfio_pci_core.c                   |  78 +++++----
 fs/btrfs/bio.c                                     |   4 +-
 fs/btrfs/block-group.c                             |  11 +-
 fs/ext4/mballoc.c                                  |   4 +
 fs/ext4/super.c                                    |  22 ++-
 fs/ext4/sysfs.c                                    |  24 ++-
 fs/f2fs/super.c                                    |  12 +-
 fs/fs-writeback.c                                  |   7 +-
 fs/ocfs2/acl.c                                     |   4 +-
 fs/ocfs2/alloc.c                                   |   6 +-
 fs/ocfs2/aops.c                                    |   6 +-
 fs/ocfs2/dir.c                                     |   9 +-
 fs/ocfs2/dlmfs/dlmfs.c                             |   4 +-
 fs/ocfs2/dlmglue.c                                 |  29 ++--
 fs/ocfs2/file.c                                    |  30 ++--
 fs/ocfs2/inode.c                                   |  28 +--
 fs/ocfs2/journal.c                                 | 192 ++++++++++++---------
 fs/ocfs2/move_extents.c                            |   4 +-
 fs/ocfs2/namei.c                                   |  18 +-
 fs/ocfs2/ocfs2.h                                   |  27 +++
 fs/ocfs2/refcounttree.c                            |  12 +-
 fs/ocfs2/super.c                                   |   4 +-
 fs/ocfs2/xattr.c                                   |   4 +-
 fs/overlayfs/export.c                              |   6 +-
 fs/smb/client/cifsfs.c                             |   2 +-
 fs/udf/udftime.c                                   |  11 +-
 include/acpi/acpixf.h                              |   4 +
 include/linux/atomic/atomic-arch-fallback.h        |   6 +-
 include/linux/atomic/atomic-instrumented.h         |   8 +-
 include/linux/atomic/atomic-long.h                 |   4 +-
 include/linux/kcov.h                               |   2 +
 include/linux/kprobes.h                            |   7 +
 include/linux/mod_devicetable.h                    |   2 +
 include/linux/pci.h                                |   7 +-
 include/linux/tty_driver.h                         |   8 +
 include/net/netns/netfilter.h                      |   3 +
 include/net/sch_generic.h                          |   1 +
 io_uring/rsrc.c                                    |   1 -
 io_uring/sqpoll.c                                  |   8 +
 kernel/gcov/gcc_4_7.c                              |   4 +-
 kernel/kcov.c                                      |   1 +
 kernel/kprobes.c                                   |   6 +
 kernel/padata.c                                    |   8 +-
 kernel/rcu/rcutorture.c                            |  16 +-
 kernel/trace/Kconfig                               |   4 +-
 kernel/trace/ftrace.c                              |   1 +
 kernel/trace/preemptirq_delay_test.c               |   1 +
 mm/page_table_check.c                              |  11 +-
 net/batman-adv/originator.c                        |   2 +
 net/core/drop_monitor.c                            |  20 +--
 net/core/filter.c                                  |   5 +
 net/core/net_namespace.c                           |   9 +-
 net/core/netpoll.c                                 |   2 +-
 net/core/sock.c                                    |   3 +
 net/ipv4/cipso_ipv4.c                              |  12 +-
 net/ipv4/tcp_input.c                               |   1 +
 net/ipv6/route.c                                   |   4 +-
 net/ipv6/seg6_local.c                              |   8 +-
 net/ipv6/xfrm6_policy.c                            |   8 +-
 net/netfilter/core.c                               |  13 +-
 net/netfilter/ipset/ip_set_core.c                  |  11 +-
 net/netfilter/nf_conntrack_standalone.c            |  15 --
 net/netfilter/nf_hooks_lwtunnel.c                  |  67 +++++++
 net/netfilter/nf_internals.h                       |   6 +
 net/netrom/nr_timer.c                              |   3 +-
 net/packet/af_packet.c                             |  26 +--
 net/sched/act_api.c                                |  66 ++++---
 net/sched/act_ct.c                                 |  16 +-
 net/sched/sch_api.c                                |   1 +
 net/sched/sch_generic.c                            |   4 +
 net/sched/sch_htb.c                                |  22 +--
 net/tipc/node.c                                    |   1 +
 scripts/atomic/kerneldoc/sub_and_test              |   2 +-
 sound/core/seq/seq_ump_convert.c                   |   2 +
 sound/hda/intel-dsp-config.c                       |   2 +-
 sound/pci/hda/cs35l41_hda.c                        |   2 +-
 sound/pci/hda/cs35l56_hda.c                        |   4 +-
 sound/pci/hda/patch_realtek.c                      |  11 +-
 sound/pci/hda/tas2781_hda_i2c.c                    |   4 +-
 sound/soc/intel/boards/sof_sdw.c                   |  18 ++
 tools/perf/Documentation/perf-script.txt           |   7 +-
 tools/perf/builtin-script.c                        |  24 ++-
 tools/testing/selftests/arm64/tags/tags_test.c     |   4 +
 .../selftests/bpf/prog_tests/btf_map_in_map.c      |  26 +--
 tools/testing/selftests/bpf/test_tc_tunnel.sh      |  13 +-
 .../selftests/net/openvswitch/openvswitch.sh       |   2 +-
 virt/kvm/kvm_main.c                                |   5 +-
 243 files changed, 1956 insertions(+), 1007 deletions(-)


