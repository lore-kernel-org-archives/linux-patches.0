Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAA224BC04;
	Tue, 29 Apr 2025 16:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945177; cv=none; b=iw4yTN92r5q1Me+7WBkw4g60MaWAOdu51b9aYP5pDMlY/Nqq4+akEAdrG++w0vSFPicCtXbLorQTeEHwmqouAHlQKQn9uEQq0CppeConl9anpMP7EvSEe8v8mfknvB4TRzh3YipmFiHKeMVdnuD3E4Oxn20w5fwSNy+jEE62OqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945177; c=relaxed/simple;
	bh=PodtBUOalk0qe4hf9kTgx0TYc8YvPR1QVssHx3rFzKg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ijQeQps8ppvyQ0+j3XpZbd8+ZcY1q5Quo6u/Fg0QeYSEqJgGnkrdZ0NHdqJTfEVtCX9MT2jpZggWRRewFjdToLixcVZNrZIJSBaSC0WBzEoDHbRkry7kUZu8ibWEQ31iziVT2YbFRO4XSzro9zldu9PmZeEYUk8hJF4SWdTo7UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oxqR68Ak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxqR68Ak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B421C4CEE9;
	Tue, 29 Apr 2025 16:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945176;
	bh=PodtBUOalk0qe4hf9kTgx0TYc8YvPR1QVssHx3rFzKg=;
	h=From:To:Cc:Subject:Date:From;
	b=oxqR68AknKzbvbMKJpEw0MIOr0Xj5v/1QxIsqbZmEEp5MlvjK4vzS4kJF0bgzacIY
	 q73bTSPoadMgNbnzQ7Z21M0Wbi1OyP9WF3G5ZTejZKMHNy0l9rFTymxUH3W6q06rlO
	 p2pIRGgwTlGjU3fSkhD1X+NnV0xPkRFP6Xejy21A=
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
Subject: [PATCH 5.4 000/179] 5.4.293-rc1 review
Date: Tue, 29 Apr 2025 18:39:01 +0200
Message-ID: <20250429161049.383278312@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.293-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.293-rc1
X-KernelTest-Deadline: 2025-05-01T16:10+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.4.293 release.
There are 179 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.293-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.293-rc1

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    MIPS: cm: Fix warning if MIPS_CM is disabled

Marek Behún <kabel@kernel.org>
    crypto: atmel-sha204a - Set hwrng quality to lowest possible

Ian Abbott <abbotti@mev.co.uk>
    comedi: jr3_pci: Fix synchronous deletion of timer

David Hildenbrand <david@redhat.com>
    s390/virtio_ccw: Don't allocate/assign airqs for non-existing queues

Meir Elisha <meir.elisha@volumez.com>
    md/raid1: Add check for missing source disk in process_checks()

Igor Pylypiv <ipylypiv@google.com>
    scsi: pm80xx: Set phy_attached to zero when device is gone

Josh Poimboeuf <jpoimboe@kernel.org>
    x86/bugs: Don't fill RSB on VMEXIT with eIBRS+retpoline

Jean-Marc Eurin <jmeurin@google.com>
    ACPI PPTT: Fix coding mistakes in a couple of sizeof() calls

Ming Lei <ming.lei@redhat.com>
    selftests: ublk: fix test_stripe_04

Xiaogang Chen <xiaogang.chen@amd.com>
    udmabuf: fix a buf size overflow issue during udmabuf creation

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    KVM: s390: Don't use %pK through tracepoints

Oleg Nesterov <oleg@redhat.com>
    sched/isolation: Make CONFIG_CPU_ISOLATION depend on CONFIG_SMP

Arnd Bergmann <arnd@arndb.de>
    ntb: reduce stack usage in idt_scan_mws

Al Viro <viro@zeniv.linux.org.uk>
    qibfs: fix _another_ leak

Chenyuan Yang <chenyuan0y@gmail.com>
    usb: gadget: aspeed: Add NULL pointer check in ast_vhub_init_dev()

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    dmaengine: dmatest: Fix dmatest waiting less when interrupted

Alexander Stein <alexander.stein@mailbox.org>
    usb: host: max3421-hcd: Add missing spi_device_id table

Yu-Chun Lin <eleanor15x@gmail.com>
    parisc: PDT: Fix missing prototype warning

Heiko Stuebner <heiko@sntech.de>
    clk: check for disabled clock-provider in of_clk_get_hw_from_clkspec()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: null - Use spin lock instead of mutex

Gregory CLEMENT <gregory.clement@bootlin.com>
    MIPS: cm: Detect CM quirks from device tree

Oliver Neukum <oneukum@suse.com>
    USB: VLI disk crashes if LPM is used

Miao Li <limiao@kylinos.cn>
    usb: quirks: Add delay init quirk for SanDisk 3.2Gen1 Flash Drive

Miao Li <limiao@kylinos.cn>
    usb: quirks: add DELAY_INIT quirk for Silicon Motion Flash Drive

Frode Isaksen <frode@meta.com>
    usb: dwc3: gadget: check that event count does not exceed event buffer length

Huacai Chen <chenhuacai@loongson.cn>
    USB: OHCI: Add quirk for LS7A OHCI controller (rev 0x02)

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

Oliver Neukum <oneukum@suse.com>
    USB: storage: quirk for ADATA Portable HDD CH94

Haoxiang Li <haoxiang_li2024@163.com>
    mcb: fix a double free bug in chameleon_parse_gdd()

Halil Pasic <pasic@linux.ibm.com>
    virtio_console: fix missing byte order handling for cols and rows

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: hfsc: Fix a potential UAF in hfsc_dequeue() too

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: hfsc: Fix a UAF vulnerability in class handling

Tung Nguyen <tung.quang.nguyen@est.tech>
    tipc: fix NULL pointer dereference in tipc_mon_reinit_self()

Qingfang Deng <qingfang.deng@siflower.com.cn>
    net: phy: leds: fix memory leak

Henry Martin <bsdhenrymartin@gmail.com>
    cpufreq: scpi: Fix null-ptr-deref in scpi_cpufreq_get_rate()

Denis Arefev <arefev@swemel.ru>
    drm/amd/pm: Prevent division by zero

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    misc: pci_endpoint_test: Fix displaying 'irq_type' after 'request_irq' error

Damien Le Moal <dlemoal@kernel.org>
    misc: pci_endpoint_test: Use INTX instead of LEGACY

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Rename PCI_IRQ_LEGACY to PCI_IRQ_INTX

Sergiu Cuciurean <sergiu.cuciurean@analog.com>
    iio: adc: ad7768-1: Fix conversion result sign

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7768-1: Move setting of val a bit later to avoid unnecessary return value check

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: fix VTU methods for 6320 family

Matthew Majewski <mattwmajewski@gmail.com>
    media: vim2m: print device name after registering device

Acs, Jakub <acsjakub@amazon.de>
    ext4: fix OOB read when checking dotdot dir

Theodore Ts'o <tytso@mit.edu>
    ext4: optimize __ext4_check_dir_entry()

Theodore Ts'o <tytso@mit.edu>
    ext4: don't over-report free space or inodes in statvfs

Chengguang Xu <cgxu519@mykernel.net>
    ext4: code cleanup for ext4_statfs_project()

Jan Kara <jack@suse.cz>
    ext4: simplify checking quota limits in ext4_statfs()

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Correct command storage data length

WangYuli <wangyuli@uniontech.com>
    MIPS: ds1287: Match ds1287_set_base_clock() function types

WangYuli <wangyuli@uniontech.com>
    MIPS: cevt-ds1287: Add missing ds1287.h include

WangYuli <wangyuli@uniontech.com>
    MIPS: dec: Declare which_prom() as static

Xie Yongji <xieyongji@bytedance.com>
    virtio-net: Add validation for used length

Bart Van Assche <bvanassche@acm.org>
    RDMA/srpt: Support specifying the srpt_service_guid parameter

Ilya Maximets <i.maximets@ovn.org>
    openvswitch: fix lockup on tx to unregistering netdev with carrier

Felix Huettner <felix.huettner@mail.schwarz>
    net: openvswitch: fix race on port output

Seunghwan Baek <sh8267.baek@samsung.com>
    mmc: cqhci: Fix checking of CQHCI_HALT state

WangYuli <wangyuli@uniontech.com>
    nvmet-fc: Remove unused functions

Martin Kepplinger <martin.kepplinger@puri.sm>
    usb: dwc3: support continuous runtime PM with dual role

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    misc: pci_endpoint_test: Fix 'irq_type' to convey the correct type

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    misc: pci_endpoint_test: Avoid issue of interrupts remaining after request_irq error

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp/dccp: Don't use timer_pending() in reqsk_queue_unlink().

Nathan Chancellor <natechancellor@gmail.com>
    powerpc/prom_init: Use -ffreestanding to avoid a reference to bcmp

Nathan Chancellor <nathan@kernel.org>
    kbuild: Add '-fno-builtin-wcslen'

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Reference count policy in cpufreq_update_limits()

Rolf Eike Beer <eb@emlix.com>
    drm/sti: remove duplicate object names

Chris Bainbridge <chris.bainbridge@gmail.com>
    drm/nouveau: prime: fix ttm_bo_delayed_delete oops

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    drm/repaper: fix integer overflows in repeat functions

Thorsten Leemhuis <linux@leemhuis.info>
    module: sign with sha512 instead of sha1 by default

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Fix the scale of IIO free running counters on SNR

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Allow to update user space GPRs from PEBS records

Xiangsheng Hou <xiangsheng.hou@mediatek.com>
    virtiofs: add filesystem context source name check

Nathan Chancellor <nathan@kernel.org>
    riscv: Avoid fortify warning in syscall_get_arguments()

Edward Adam Davis <eadavis@qq.com>
    isofs: Prevent the use of too small fid

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    i2c: cros-ec-tunnel: defer probe if parent EC is not present

Vasiliy Kovalev <kovalev@altlinux.org>
    hfs/hfsplus: fix slab-out-of-bounds in hfs_bnode_read_key

Johannes Kimmel <kernel@bareminimum.eu>
    btrfs: correctly escape subvol in btrfs_show_options()

Eric Biggers <ebiggers@google.com>
    nfs: add missing selections of CONFIG_CRC32

Jeff Layton <jlayton@kernel.org>
    nfs: move nfs_fhandle_hash to common include file

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Constify @fh argument of knfsd_fh_hash()

Denis Arefev <arefev@swemel.ru>
    asus-laptop: Fix an uninitialized variable

Andreas Gruenbacher <agruenba@redhat.com>
    writeback: fix false warning in inode_to_wb()

Jonas Gorski <jonas.gorski@gmail.com>
    net: b53: enable BPDU reception for management port

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix nested key length validation in the set() action

Johannes Berg <johannes.berg@intel.com>
    Revert "wifi: mac80211: Update skb's control block key in ieee80211_tx_dequeue()"

Dan Carpenter <dan.carpenter@linaro.org>
    Bluetooth: btrtl: Prevent potential NULL dereference

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Fix sending MGMT_EV_DEVICE_FOUND for invalid address

Yue Haibing <yuehaibing@huawei.com>
    RDMA/usnic: Fix passing zero to PTR_ERR in usnic_ib_pci_probe()

Miaoqian Lin <linmq006@gmail.com>
    scsi: iscsi: Fix missing scsi_host_put() in error path

Abdun Nihaal <abdun.nihaal@gmail.com>
    wifi: wl1251: fix memory leak in wl1251_tx_work

Remi Pommarel <repk@triplefau.lt>
    wifi: mac80211: Purge vif txq in ieee80211_do_stop()

Remi Pommarel <repk@triplefau.lt>
    wifi: mac80211: Update skb's control block key in ieee80211_tx_dequeue()

Abdun Nihaal <abdun.nihaal@gmail.com>
    wifi: at76c50x: fix use after free access in at76_disconnect

Kaixin Wang <kxwang23@m.fudan.edu.cn>
    HSI: ssi_protocol: Fix use after free vulnerability in ssi_protocol Driver Due to Race Condition

Daniel Golle <daniel@makrotopia.org>
    pwm: mediatek: always use bus clock for PWM on MT7622

Arseniy Krasnov <avkrasnov@salutedevices.com>
    Bluetooth: hci_uart: Fix another race during initialization

Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
    x86/e820: Fix handling of subpage regions when calculating nosave ranges in e820__register_nosave_regions()

Ma Ke <make24@iscas.ac.cn>
    PCI: Fix reference leak in pci_alloc_child_bus()

Zijun Hu <quic_zijuhu@quicinc.com>
    of/irq: Fix device node refcount leakages in of_irq_init()

Zijun Hu <quic_zijuhu@quicinc.com>
    of/irq: Fix device node refcount leakage in API irq_of_parse_and_map()

Zijun Hu <quic_zijuhu@quicinc.com>
    of/irq: Fix device node refcount leakages in of_irq_count()

Fedor Pchelkin <pchelkin@ispras.ru>
    ntb: use 64-bit arithmetic for the MSI doorbell mask

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    gpio: zynq: Fix wakeup source leaks on device unbind

zhoumin <teczm@foxmail.com>
    ftrace: Add cond_resched() to ftrace_graph_set_hash()

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: set ti->error on memory allocation failure

Tom Lendacky <thomas.lendacky@amd.com>
    crypto: ccp - Fix check for the primary ASP device

Trevor Woerner <twoerner@gmail.com>
    thermal/drivers/rockchip: Add missing rk3328 mapping entry

Ricardo Cañuelo Navarro <rcn@igalia.com>
    sctp: detect and prevent references to a freed transport in sendmsg

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    mm: add missing release barrier on PGDAT_RECLAIM_LOCKED unlock

Ryan Roberts <ryan.roberts@arm.com>
    sparc/mm: disable preemption in lazy mmu mode

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173: Fix disp-pwm compatible string

Wentao Liang <vulab@iscas.ac.cn>
    mtd: rawnand: Add status chack in r852_ready()

Wentao Liang <vulab@iscas.ac.cn>
    mtd: inftlcore: Add error check for inftl_read_oob()

T Pratham <t-pratham@ti.com>
    lib: scatterlist: fix sg_split_phys to preserve original scatterlist offsets

Boqun Feng <boqun.feng@gmail.com>
    locking/lockdep: Decrease nr_unused_locks if lock unused in zap_class()

Jan Kara <jack@suse.cz>
    jbd2: remove wrong sb->s_sequence check

Manjunatha Venkatesh <manjunatha.venkatesh@nxp.com>
    i3c: Add NULL pointer check in i3c_master_queue_ibi()

Artem Sadovnikov <a.sadovnikov@ispras.ru>
    ext4: fix off-by-one error in do_split

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    wifi: mac80211: fix integer overflow in hwmp_route_info_get()

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: workaround RGMII transmit delay erratum for 6320 family

Vikash Garodia <quic_vgarodia@quicinc.com>
    media: venus: hfi_parser: add check to avoid out of bound access

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: i2c: ov7251: Introduce 1 ms delay between regulators and en GPIO

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: i2c: ov7251: Set enable GPIO low in probe

Karina Yankevich <k.yankevich@omp.ru>
    media: v4l2-dv-timings: prevent possible overflow in v4l2_detect_gtf()

Murad Masimov <m.masimov@mt-integration.ru>
    media: streamzap: prevent processing IR data on URB failure

Kamal Dasu <kamal.dasu@broadcom.com>
    mtd: rawnand: brcmnand: fix PM resume warning

Douglas Anderson <dianders@chromium.org>
    arm64: cputype: Add MIDR_CORTEX_A76AE

Jan Beulich <jbeulich@suse.com>
    xenfs/xensyms: respect hypervisor's "next" indication

Yuan Can <yuancan@huawei.com>
    media: siano: Fix error handling in smsdvb_module_init()

Vikash Garodia <quic_vgarodia@quicinc.com>
    media: venus: hfi: add check to handle incorrect queue size

Vikash Garodia <quic_vgarodia@quicinc.com>
    media: venus: hfi: add a check to handle OOB in sfr region

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: i2c: adv748x: Fix test pattern selection mask

Jann Horn <jannh@google.com>
    ext4: don't treat fhandle lookup of ea_inode as FS corruption

Eric Biggers <ebiggers@google.com>
    ext4: reject casefold inode flag without casefold feature

Willem de Bruijn <willemb@google.com>
    bpf: support SKF_NET_OFF and SKF_LL_OFF on skb frags

Ben Dooks <ben.dooks@sifive.com>
    bpf: Add endian modifiers to fix endian warnings

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: fsl-ftm: Handle clk_get_rate() returning 0

Josh Poimboeuf <jpoimboe@kernel.org>
    pwm: mediatek: Prevent divide-by-zero in pwm_mediatek_config()

Fabien Parent <fparent@baylibre.com>
    pwm: mediatek: Always use bus clock

Leonid Arapov <arapovl839@gmail.com>
    fbdev: omapfb: Add 'plane' value check

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: mtk_dpi: Explicitly manage TVD clock in power on/off

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Fix pqm_destroy_queue race with GPU reset

David Yat Sin <David.YatSin@amd.com>
    drm/amdkfd: clamp queue size to minimum

Andrew Wyatt <fewtarius@steamfork.org>
    drm: panel-orientation-quirks: Add new quirk for GPD Win 2

Andrew Wyatt <fewtarius@steamfork.org>
    drm: panel-orientation-quirks: Add support for AYANEO 2S

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm: allow encoder mode_set even when connectors change for crtc

Arseniy Krasnov <avkrasnov@salutedevices.com>
    Bluetooth: hci_uart: fix race during initialization

Gabriele Paoloni <gpaoloni@redhat.com>
    tracing: fix return value in __ftrace_event_enable_disable for TRACE_REG_UNREGISTER

Stanislav Fomichev <sdf@fomichev.me>
    net: vlan: don't propagate flags on open

Icenowy Zheng <uwu@icenowy.me>
    wifi: mt76: mt76x2u: add TP-Link TL-WDN6200 ID to device table

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: st: Fix array overflow in st_setup()

Bhupesh <bhupesh@igalia.com>
    ext4: ignore xattrs past end

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: protect ext4_release_dquot against freezing

Daniel Kral <d.kral@proxmox.com>
    ahci: add PCI ID for Marvell 88SE9215 SATA Controller

Niklas Cassel <cassel@kernel.org>
    ata: libata-eh: Do not use ATAPI DMA for a device limited to PIO mode

Edward Adam Davis <eadavis@qq.com>
    jfs: add sanity check for agwidth in dbMount

Edward Adam Davis <eadavis@qq.com>
    jfs: Prevent copying of nlink with value 0 from disk inode

Rand Deeb <rand.sec96@gmail.com>
    fs/jfs: Prevent integer overflow in AG size calculation

Rand Deeb <rand.sec96@gmail.com>
    fs/jfs: cast inactags to s64 to prevent potential overflow

Jason Xing <kerneljasonxing@gmail.com>
    page_pool: avoid infinite loop to schedule delayed worker

Ricard Wanderlof <ricard2013@butoba.net>
    ALSA: usb-audio: Fix CME quirk for UF series keyboards

Maxim Mikityanskiy <maxtram95@gmail.com>
    ALSA: hda: intel: Fix Optimus when GPU has no sound

Tomasz Pakuła <forest10pl@gmail.com>
    HID: pidff: Fix null pointer dereference in pidff_find_fields

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Do not send effect envelope if it's empty

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Convert infinite length from Linux API to PID standard

Kees Cook <kees@kernel.org>
    xen/mcelog: Add __nonstring annotations for unterminated strings

Mark Rutland <mark.rutland@arm.com>
    perf: arm_pmu: Don't disable counter in armpmu_add()

Max Grobecker <max@grobecker.info>
    x86/cpu: Don't clear X86_FEATURE_LAHF_LM flag in init_amd_k8() on AMD when running in a virtual machine

Zhongqiu Han <quic_zhonhan@quicinc.com>
    pm: cpupower: bench: Prevent NULL dereference on malloc failure

Arnaud Lecomte <contact@arnaud-lcm.com>
    net: ppp: Add bound checking for skb data on ppp_sync_txmung

Wentao Liang <vulab@iscas.ac.cn>
    ata: sata_sx4: Add error handling in pdc20621_i2c_read()

Hannes Reinecke <hare@suse.de>
    ata: sata_sx4: Drop pointless VPRINTK() calls and convert the remaining ones

Cong Wang <xiyou.wangcong@gmail.com>
    codel: remove sch->q.qlen check before qdisc_tree_reduce_backlog()

Tung Nguyen <tung.quang.nguyen@est.tech>
    tipc: fix memory leak in tipc_link_xmit

Henry Martin <bsdhenrymartin@gmail.com>
    ata: pata_pxa: Fix potential NULL pointer dereference in pxa_ata_probe()


-------------

Diffstat:

 Makefile                                           |   7 +-
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   6 +-
 arch/arm64/include/asm/cputype.h                   |   2 +
 arch/mips/dec/prom/init.c                          |   2 +-
 arch/mips/include/asm/ds1287.h                     |   2 +-
 arch/mips/include/asm/mips-cm.h                    |  22 ++++
 arch/mips/kernel/cevt-ds1287.c                     |   1 +
 arch/mips/kernel/mips-cm.c                         |  14 +++
 arch/parisc/kernel/pdt.c                           |   2 +
 arch/powerpc/kernel/Makefile                       |   1 +
 arch/riscv/include/asm/syscall.h                   |   7 +-
 arch/s390/kvm/trace-s390.h                         |   4 +-
 arch/sparc/mm/tlb.c                                |   5 +-
 arch/x86/events/intel/ds.c                         |   8 +-
 arch/x86/events/intel/uncore_snbep.c               |  16 +--
 arch/x86/kernel/cpu/amd.c                          |   2 +-
 arch/x86/kernel/cpu/bugs.c                         |   8 +-
 arch/x86/kernel/e820.c                             |  17 ++-
 crypto/crypto_null.c                               |  37 ++++---
 drivers/acpi/pptt.c                                |   4 +-
 drivers/ata/ahci.c                                 |   2 +
 drivers/ata/libata-eh.c                            |  11 +-
 drivers/ata/pata_pxa.c                             |   6 ++
 drivers/ata/sata_sx4.c                             | 118 ++++++++-------------
 drivers/bluetooth/btrtl.c                          |   2 +
 drivers/bluetooth/hci_ldisc.c                      |  19 +++-
 drivers/bluetooth/hci_uart.h                       |   1 +
 drivers/char/virtio_console.c                      |   7 +-
 drivers/clk/clk.c                                  |   4 +
 drivers/cpufreq/cpufreq.c                          |   8 ++
 drivers/cpufreq/scpi-cpufreq.c                     |  13 ++-
 drivers/crypto/atmel-sha204a.c                     |   7 +-
 drivers/crypto/ccp/sp-pci.c                        |  15 +--
 drivers/dma-buf/udmabuf.c                          |   2 +-
 drivers/dma/dmatest.c                              |   6 +-
 drivers/gpio/gpio-zynq.c                           |   1 +
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  10 ++
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   2 +-
 .../gpu/drm/amd/powerplay/hwmgr/vega20_thermal.c   |   2 +-
 drivers/gpu/drm/drm_atomic_helper.c                |   2 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |  10 +-
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |   9 ++
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   3 +
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   3 -
 drivers/gpu/drm/sti/Makefile                       |   2 -
 drivers/gpu/drm/tiny/repaper.c                     |   4 +-
 drivers/hid/usbhid/hid-pidff.c                     |  60 +++++++----
 drivers/hsi/clients/ssi_protocol.c                 |   1 +
 drivers/i2c/busses/i2c-cros-ec-tunnel.c            |   3 +
 drivers/i3c/master.c                               |   3 +
 drivers/iio/adc/ad7768-1.c                         |   5 +-
 drivers/infiniband/hw/qib/qib_fs.c                 |   1 +
 drivers/infiniband/hw/usnic/usnic_ib_main.c        |  14 +--
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   8 +-
 drivers/mcb/mcb-parse.c                            |   2 +-
 drivers/md/dm-integrity.c                          |   3 +
 drivers/md/raid1.c                                 |  26 +++--
 drivers/media/common/siano/smsdvb-main.c           |   2 +
 drivers/media/i2c/adv748x/adv748x.h                |   2 +-
 drivers/media/i2c/ov7251.c                         |   4 +-
 drivers/media/platform/qcom/venus/hfi_parser.c     |   2 +
 drivers/media/platform/qcom/venus/hfi_venus.c      |  18 +++-
 drivers/media/platform/vim2m.c                     |   6 +-
 drivers/media/rc/streamzap.c                       |  68 ++++++------
 drivers/media/v4l2-core/v4l2-dv-timings.c          |   4 +-
 drivers/misc/pci_endpoint_test.c                   |  36 ++++---
 drivers/mmc/host/cqhci.c                           |   2 +-
 drivers/mtd/inftlcore.c                            |   9 +-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |   2 +-
 drivers/mtd/nand/raw/r852.c                        |   3 +
 drivers/net/dsa/b53/b53_common.c                   |  10 ++
 drivers/net/dsa/mv88e6xxx/chip.c                   |  25 ++++-
 drivers/net/phy/phy_led_triggers.c                 |  23 ++--
 drivers/net/ppp/ppp_synctty.c                      |   5 +
 drivers/net/virtio_net.c                           |  22 ++--
 drivers/net/wireless/atmel/at76c50x-usb.c          |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   1 +
 drivers/net/wireless/ti/wl1251/tx.c                |   4 +-
 drivers/ntb/hw/idt/ntb_hw_idt.c                    |  18 ++--
 drivers/ntb/ntb_transport.c                        |   2 +-
 drivers/nvme/target/fc.c                           |  14 ---
 drivers/of/irq.c                                   |  13 ++-
 drivers/pci/probe.c                                |   5 +-
 drivers/perf/arm_pmu.c                             |   8 +-
 drivers/platform/x86/asus-laptop.c                 |   9 +-
 .../x86/intel_speed_select_if/isst_if_common.c     |   2 +-
 drivers/pwm/pwm-fsl-ftm.c                          |   6 ++
 drivers/pwm/pwm-mediatek.c                         |  20 +++-
 drivers/s390/virtio/virtio_ccw.c                   |  16 ++-
 drivers/scsi/pm8001/pm8001_sas.c                   |   1 +
 drivers/scsi/scsi_transport_iscsi.c                |   7 +-
 drivers/scsi/st.c                                  |   2 +-
 drivers/staging/comedi/drivers/jr3_pci.c           |  15 ++-
 drivers/thermal/rockchip_thermal.c                 |   1 +
 drivers/tty/serial/sifive.c                        |   6 ++
 drivers/usb/cdns3/gadget.c                         |   2 +
 drivers/usb/core/quirks.c                          |   9 ++
 drivers/usb/dwc3/core.c                            |  11 +-
 drivers/usb/dwc3/gadget.c                          |   6 ++
 drivers/usb/gadget/udc/aspeed-vhub/dev.c           |   3 +
 drivers/usb/host/max3421-hcd.c                     |   7 ++
 drivers/usb/host/ohci-pci.c                        |  23 ++++
 drivers/usb/serial/ftdi_sio.c                      |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   5 +
 drivers/usb/serial/option.c                        |   3 +
 drivers/usb/serial/usb-serial-simple.c             |   7 ++
 drivers/usb/storage/unusual_uas.h                  |   7 ++
 drivers/video/fbdev/omap2/omapfb/dss/dispc.c       |   6 +-
 drivers/xen/xenfs/xensyms.c                        |   4 +-
 fs/Kconfig                                         |   1 +
 fs/btrfs/super.c                                   |   3 +-
 fs/ext4/dir.c                                      |  12 ++-
 fs/ext4/inode.c                                    |  69 ++++++++----
 fs/ext4/namei.c                                    |   2 +-
 fs/ext4/super.c                                    |  61 ++++++-----
 fs/ext4/xattr.c                                    |  11 +-
 fs/fuse/virtio_fs.c                                |   3 +
 fs/hfs/bnode.c                                     |   6 ++
 fs/hfsplus/bnode.c                                 |   6 ++
 fs/isofs/export.c                                  |   2 +-
 fs/jbd2/journal.c                                  |   1 -
 fs/jfs/jfs_dmap.c                                  |  10 +-
 fs/jfs/jfs_imap.c                                  |   2 +-
 fs/nfs/Kconfig                                     |   2 +-
 fs/nfs/internal.h                                  |  22 ----
 fs/nfs/nfs4session.h                               |   4 -
 fs/nfsd/Kconfig                                    |   1 +
 fs/nfsd/nfsfh.h                                    |  12 +--
 include/linux/backing-dev.h                        |   1 +
 include/linux/nfs.h                                |  13 +++
 include/linux/pci.h                                |   4 +-
 include/net/sctp/structs.h                         |   3 +-
 include/uapi/linux/kfd_ioctl.h                     |   2 +
 include/uapi/linux/pcitest.h                       |   3 +-
 include/xen/interface/xen-mca.h                    |   2 +-
 init/Kconfig                                       |   3 +-
 kernel/locking/lockdep.c                           |   3 +
 kernel/trace/ftrace.c                              |   1 +
 kernel/trace/trace_events.c                        |   4 +-
 lib/sg_split.c                                     |   2 -
 mm/vmscan.c                                        |   2 +-
 net/8021q/vlan_dev.c                               |  31 +-----
 net/bluetooth/hci_event.c                          |   5 +-
 net/core/dev.c                                     |   1 +
 net/core/filter.c                                  |  80 +++++++-------
 net/core/page_pool.c                               |   8 +-
 net/ipv4/inet_connection_sock.c                    |  19 +++-
 net/mac80211/iface.c                               |   3 +
 net/mac80211/mesh_hwmp.c                           |  14 ++-
 net/openvswitch/actions.c                          |   4 +-
 net/openvswitch/flow_netlink.c                     |   3 +-
 net/sched/sch_codel.c                              |   5 +-
 net/sched/sch_fq_codel.c                           |   6 +-
 net/sched/sch_hfsc.c                               |  23 ++--
 net/sctp/socket.c                                  |  22 ++--
 net/sctp/transport.c                               |   2 +
 net/tipc/link.c                                    |   1 +
 net/tipc/monitor.c                                 |   3 +-
 sound/pci/hda/hda_intel.c                          |  15 ++-
 sound/usb/midi.c                                   |  80 ++++++++++++--
 tools/power/cpupower/bench/parse.c                 |   4 +
 tools/testing/selftests/ublk/test_stripe_04.sh     |  24 +++++
 162 files changed, 1121 insertions(+), 557 deletions(-)


