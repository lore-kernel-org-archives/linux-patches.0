Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042A41DF73C;
	Tue, 29 Apr 2025 17:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946695; cv=none; b=hi9AdjQO3xGa6YnwdAl0MRoMuCJsjY9WqU7nGghtA9euEATrouHeFPVkm2u5w96HPkNyNfctJxz5n2geIdkAtMYWE3j6o0qXp6T4REOTUg3gWCTYESaii4PC9CCtBl23GojdZyIlQTKswmFjxTS/vLpd9YWOWQxnz2G/QfWNbPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946695; c=relaxed/simple;
	bh=ECJGKWMlQ9oA5EWZbxTBx8RrzRJT1xo2WXBgviT3A30=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=C497pn8tMnn7GOrnV2NxPgJQlRbpw2t0KRfMwXI9xg/iIFY9iUUecVASJSGyWA61eaj7eyDTT8+bx1XUtqv5obEBCn4hcjDmhy40EcVOCvgrUk9M08wR5s+m+M9YSlBbn4hs0ztYtMaDwcM8tUoYq96Je3neeZekX429bqGN32I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UW4NfM+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UW4NfM+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE71C4CEE3;
	Tue, 29 Apr 2025 17:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946694;
	bh=ECJGKWMlQ9oA5EWZbxTBx8RrzRJT1xo2WXBgviT3A30=;
	h=From:To:Cc:Subject:Date:From;
	b=UW4NfM+c+IsK9Kt/zJjTtXf17S9NYls1fogiMysBlnBSe1pjUFPmNjL+O0O3+aoGB
	 wP0Z5D+ZE7xA+QLpOFWJO68EcmyEpc/TOutfdFLsWB4dsQvGzL0H+OHe4BzWAmgBLJ
	 oJs+AsiZrGojmyllG0KfmfEWDpjEPZXILM7iD9Ls=
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
Subject: [PATCH 5.10 000/286] 5.10.237-rc1 review
Date: Tue, 29 Apr 2025 18:38:24 +0200
Message-ID: <20250429161107.848008295@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.237-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.237-rc1
X-KernelTest-Deadline: 2025-05-01T16:11+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.237 release.
There are 286 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.237-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.237-rc1

Stanimir Varbanov <stanimir.varbanov@linaro.org>
    media: venus: hfi_parser: Check for instance after hfi platform get

Colin Ian King <colin.king@canonical.com>
    media: venus: Fix uninitialized variable count being checked for zero

Krzysztof Kozlowski <krzk@kernel.org>
    soc: samsung: exynos-chipid: correct helpers __init annotation

Rob Herring <robh@kernel.org>
    PCI: Fix use-after-free in pci_bus_release_domain_nr()

Hannes Reinecke <hare@kernel.org>
    nvme: fixup scan failure for non-ANA multipath controllers

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    MIPS: cm: Fix warning if MIPS_CM is disabled

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    xdp: Reset bpf_redirect_info before running a xdp's BPF prog.

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

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: make block validity check resistent to sb bh corruption

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

Hannes Reinecke <hare@kernel.org>
    nvme: requeue namespace scan on missed AENs

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

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool, ASoC: codecs: wcd934x: Remove potential undefined behavior in wcd934x_slim_irq_handler()

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

Sean Christopherson <seanjc@google.com>
    KVM: x86: Reset IRTE to host control if *new* route isn't postable

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add panther lake H DID

Oliver Neukum <oneukum@suse.com>
    USB: storage: quirk for ADATA Portable HDD CH94

Haoxiang Li <haoxiang_li2024@163.com>
    mcb: fix a double free bug in chameleon_parse_gdd()

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Allocate IR data using atomic allocation

Halil Pasic <pasic@linux.ibm.com>
    virtio_console: fix missing byte order handling for cols and rows

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

Henry Martin <bsdhenrymartin@gmail.com>
    cpufreq: scpi: Fix null-ptr-deref in scpi_cpufreq_get_rate()

Arnd Bergmann <arnd@arndb.de>
    dma/contiguous: avoid warning about unused size_bytes

Matthew Auld <matthew.auld@intel.com>
    drm/amdgpu/dma_buf: fix page_link check

Ramesh Errabolu <Ramesh.Errabolu@amd.com>
    drm/amdgpu: Remove amdgpu_device arg from free_sgt api (v2)

Lee Jones <lee.jones@linaro.org>
    drm/amd/amdgpu/amdgpu_vram_mgr: Add missing descriptions for 'dev' and 'dir'

Mark Brown <broonie@kernel.org>
    selftests/mm: generate a temporary mountpoint for cgroup filesystem

Ma Ke <make24@iscas.ac.cn>
    PCI: Fix reference leak in pci_register_host_bridge()

Pali Rohár <pali@kernel.org>
    PCI: Assign PCI domain IDs by ida_alloc()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    PCI: Coalesce host bridge contiguous apertures

Boqun Feng <boqun.feng@gmail.com>
    PCI: Introduce domain_nr in pci_host_bridge

Alexandra Diupina <adiupina@astralinux.ru>
    cifs: avoid NULL pointer dereference in dbg call

Enzo Matsumiya <ematsumiya@suse.de>
    cifs: print TIDs as hex

Herve Codina <herve.codina@bootlin.com>
    backlight: led_bl: Hold led_access lock when calling led_sysfs_disable()

Sergiu Cuciurean <sergiu.cuciurean@analog.com>
    iio: adc: ad7768-1: Fix conversion result sign

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7768-1: Move setting of val a bit later to avoid unnecessary return value check

Chenyuan Yang <chenyuan0y@gmail.com>
    soc: samsung: exynos-chipid: Add NULL pointer check in exynos_chipid_probe()

Sam Protsenko <semen.protsenko@linaro.org>
    soc: samsung: exynos-chipid: Pass revision reg offsets

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    soc: samsung: exynos-chipid: avoid soc_device_to_device()

Krzysztof Kozlowski <krzk@kernel.org>
    soc: samsung: exynos-chipid: convert to driver and merge exynos-asv

Krzysztof Kozlowski <krzk@kernel.org>
    soc: samsung: exynos-chipid: initialize later - with arch_initcall

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: fix VTU methods for 6320 family

Vikash Garodia <quic_vgarodia@quicinc.com>
    media: venus: hfi_parser: refactor hfi packet parsing logic

Stanimir Varbanov <stanimir.varbanov@linaro.org>
    media: venus: Get codecs and capabilities from hfi platform

Stanimir Varbanov <stanimir.varbanov@linaro.org>
    media: venus: hfi_plat: Add codecs and capabilities ops

Stanimir Varbanov <stanimir.varbanov@linaro.org>
    media: venus: Rename venus_caps to hfi_plat_caps

Stanimir Varbanov <stanimir.varbanov@linaro.org>
    media: venus: Create hfi platform and move vpp/vsp there

Stanimir Varbanov <stanimir.varbanov@linaro.org>
    media: venus: pm_helpers: Check instance state when calculate instance frequency

Stanimir Varbanov <stanimir.varbanov@linaro.org>
    media: venus: hfi: Correct session init return error

Stanimir Varbanov <stanimir.varbanov@linaro.org>
    media: venus: Limit HFI sessions to the maximum supported

Stanimir Varbanov <stanimir.varbanov@linaro.org>
    media: venus: venc: Init the session only once in queue_setup

Murad Masimov <m.masimov@mt-integration.ru>
    media: streamzap: fix race between device disconnection and urb callback

Sean Young <sean@mess.org>
    media: streamzap: remove unused struct members

Sean Young <sean@mess.org>
    media: streamzap: less chatter

Sean Young <sean@mess.org>
    media: streamzap: no need for usb pid/vid in device name

Sean Young <sean@mess.org>
    media: streamzap: remove unnecessary ir_raw_event_reset and handle

Douglas Raillard <douglas.raillard@arm.com>
    tracing: Fix synth event printk format for str fields

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Allow synthetic events to pass around stacktraces

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Correct command storage data length

Hans de Goede <hdegoede@redhat.com>
    drivers: staging: rtl8723bs: Fix locking in rtw_scan_timeout_handler()

Kunwu Chan <chentao@kylinos.cn>
    pmdomain: ti: Add a null pointer check to the omap_prm_domain_init

Miroslav Franc <mfranc@suse.cz>
    s390/dasd: fix double module refcount decrement

Duoming Zhou <duoming@zju.edu.cn>
    drivers: staging: rtl8723bs: Fix deadlock in rtw_surveydone_event_callback()

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    mm: fix apply_to_existing_page_range()

Oleg Nesterov <oleg@redhat.com>
    fs/proc: do_task_stat: use sig->stats_lock to gather the threads/children stats

Chris Wilson <chris.p.wilson@intel.com>
    drm/i915/gt: Cleanup partial engine discovery failures

Miaohe Lin <linmiaohe@huawei.com>
    kernel/resource: fix kfree() of bootmem memory again

Abhishek Sahu <abhsahu@nvidia.com>
    vfio/pci: fix memory leak during D3hot to D0 transition

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: fix flushing uninitialized delayed_work on cache_ctr error

Pei Li <peili.dev@gmail.com>
    jfs: Fix shift-out-of-bounds in dbDiscardAG

WangYuli <wangyuli@uniontech.com>
    MIPS: ds1287: Match ds1287_set_base_clock() function types

WangYuli <wangyuli@uniontech.com>
    MIPS: cevt-ds1287: Add missing ds1287.h include

WangYuli <wangyuli@uniontech.com>
    MIPS: dec: Declare which_prom() as static

Eric Dumazet <edumazet@google.com>
    net: defer final 'struct net' free in netns dismantle

Guixin Liu <kanie@linux.alibaba.com>
    scsi: ufs: bsg: Set bsg_queue to NULL after removal

Tuo Li <islituo@gmail.com>
    scsi: lpfc: Fix a possible data race in lpfc_unregister_fcf_rescan()

Ilya Maximets <i.maximets@ovn.org>
    openvswitch: fix lockup on tx to unregistering netdev with carrier

Felix Huettner <felix.huettner@mail.schwarz>
    net: openvswitch: fix race on port output

Chen Hanxiao <chenhx.fnst@fujitsu.com>
    ipvs: properly dereference pe in ip_vs_add_service

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5e: Fix use-after-free of encap entry in neigh update handler

Xiaxi Shen <shenxiaxi26@gmail.com>
    ext4: fix timer use-after-free on failed mount

Li Nan <linan122@huawei.com>
    blk-iocost: do not WARN if iocg was already offlined

Yu Kuai <yukuai3@huawei.com>
    blk-cgroup: support to track if policy is online

Hou Tao <houtao1@huawei.com>
    bpf: Check rcu_read_lock_trace_held() before calling bpf map helpers

Andrii Nakryiko <andrii@kernel.org>
    bpf: avoid holding freeze_mutex during mmap operation

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix NULL ptr deref in crypto_aead_setkey()

Enzo Matsumiya <ematsumiya@suse.de>
    smb: client: fix UAF in async decryption

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix potential UAF in cifs_stats_proc_show()

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix potential deadlock when releasing mids

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix UAF in cifs_demultiplex_thread()

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix use-after-free bug in cifs_debug_data_proc_show()

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix potential UAF in cifs_debug_files_proc_show()

WangYuli <wangyuli@uniontech.com>
    nvmet-fc: Remove unused functions

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix out-of-bounds access in 'dcn21_link_encoder_create'

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Stop amdgpu_dm initialize when link nums greater than max_links

Kang Yang <quic_kangyang@quicinc.com>
    wifi: ath10k: avoid NULL pointer error during sdio remove

Miaoqian Lin <linmq006@gmail.com>
    phy: tegra: xusb: Fix return value of tegra_xusb_find_port_node function

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/rtas: Prevent Spectre v1 gadget construction in sys_rtas()

Chunguang Xu <chunguang.xu@shopee.com>
    nvme: avoid double free special payload

Ard Biesheuvel <ardb@kernel.org>
    x86/pvh: Call C code via the kernel virtual mapping

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    misc: pci_endpoint_test: Fix 'irq_type' to convey the correct type

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    misc: pci_endpoint_test: Fix displaying 'irq_type' after 'request_irq' error

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    misc: pci_endpoint_test: Avoid issue of interrupts remaining after request_irq error

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: sockopt: fix getting IPV6_V6ONLY

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: only inc MPJoinAckHMacFailure for HMAC failures

Gang Yan <yangang@kylinos.cn>
    mptcp: fix NULL pointer in can_accept_new_subflow

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp/dccp: Don't use timer_pending() in reqsk_queue_unlink().

Nathan Chancellor <nathan@kernel.org>
    kbuild: Add '-fno-builtin-wcslen'

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Reference count policy in cpufreq_update_limits()

Rolf Eike Beer <eb@emlix.com>
    drm/sti: remove duplicate object names

Chris Bainbridge <chris.bainbridge@gmail.com>
    drm/nouveau: prime: fix ttm_bo_delayed_delete oops

Denis Arefev <arefev@swemel.ru>
    drm/amd/pm/powerplay/hwmgr/vega20_thermal: Prevent division by zero

Denis Arefev <arefev@swemel.ru>
    drm/amd/pm/powerplay/hwmgr/smu7_thermal: Prevent division by zero

Denis Arefev <arefev@swemel.ru>
    drm/amd/pm/powerplay: Prevent division by zero

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    drm/repaper: fix integer overflows in repeat functions

Thorsten Leemhuis <linux@leemhuis.info>
    module: sign with sha512 instead of sha1 by default

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Fix the scale of IIO free running counters on ICX

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Fix the scale of IIO free running counters on SNR

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Allow to update user space GPRs from PEBS records

Xiangsheng Hou <xiangsheng.hou@mediatek.com>
    virtiofs: add filesystem context source name check

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix filter string testing

Nathan Chancellor <nathan@kernel.org>
    riscv: Avoid fortify warning in syscall_get_arguments()

Edward Adam Davis <eadavis@qq.com>
    isofs: Prevent the use of too small fid

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    i2c: cros-ec-tunnel: defer probe if parent EC is not present

Vasiliy Kovalev <kovalev@altlinux.org>
    hfs/hfsplus: fix slab-out-of-bounds in hfs_bnode_read_key

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: caam/qi - Fix drv_ctx refcount bug

Johannes Kimmel <kernel@bareminimum.eu>
    btrfs: correctly escape subvol in btrfs_show_options()

Li Lingfeng <lilingfeng3@huawei.com>
    nfsd: decrease sc_count directly if fail to queue dl_recall

Eric Biggers <ebiggers@google.com>
    nfs: add missing selections of CONFIG_CRC32

Jeff Layton <jlayton@kernel.org>
    nfs: move nfs_fhandle_hash to common include file

Denis Arefev <arefev@swemel.ru>
    asus-laptop: Fix an uninitialized variable

Andreas Gruenbacher <agruenba@redhat.com>
    writeback: fix false warning in inode_to_wb()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq/sched: Fix the usage of CPUFREQ_NEED_UPDATE_LIMITS

WangYuli <wangyuli@uniontech.com>
    riscv: KGDB: Remove ".option norvc/.option rvc" for kgdb_compiled_break

WangYuli <wangyuli@uniontech.com>
    riscv: KGDB: Do not inline arch_kgdb_breakpoint()

Jonas Gorski <jonas.gorski@gmail.com>
    net: b53: enable BPDU reception for management port

Abdun Nihaal <abdun.nihaal@gmail.com>
    cxgb4: fix memory leak in cxgb4_init_ethtool_filters() error path

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix nested key length validation in the set() action

Christopher S M Hall <christopher.s.hall@intel.com>
    igc: cleanup PTP module if probe fails

Christopher S M Hall <christopher.s.hall@intel.com>
    igc: handle the IGC_PTP_ENABLED flag correctly

Johannes Berg <johannes.berg@intel.com>
    Revert "wifi: mac80211: Update skb's control block key in ieee80211_tx_dequeue()"

Dan Carpenter <dan.carpenter@linaro.org>
    Bluetooth: btrtl: Prevent potential NULL dereference

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Fix sending MGMT_EV_DEVICE_FOUND for invalid address

Shay Drory <shayd@nvidia.com>
    RDMA/core: Silence oversized kvmalloc() warning

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix wrong maximum DMA segment size

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

Stephan Gerhold <stephan.gerhold@linaro.org>
    pinctrl: qcom: Clear latched interrupt status when changing IRQ type

Ma Ke <make24@iscas.ac.cn>
    PCI: Fix reference leak in pci_alloc_child_bus()

Stanimir Varbanov <svarbanov@suse.de>
    PCI: brcmstb: Fix missing of_node_put() in brcm_pcie_probe()

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

Chenyuan Yang <chenyuan0y@gmail.com>
    mfd: ene-kb3930: Fix a potential NULL pointer dereference

Jan Kara <jack@suse.cz>
    jbd2: remove wrong sb->s_sequence check

Manjunatha Venkatesh <manjunatha.venkatesh@nxp.com>
    i3c: Add NULL pointer check in i3c_master_queue_ibi()

Si-Wei Liu <si-wei.liu@oracle.com>
    vdpa/mlx5: Fix oversized null mkey longer than 32bit

Artem Sadovnikov <a.sadovnikov@ispras.ru>
    ext4: fix off-by-one error in do_split

Alexey Klimov <alexey.klimov@linaro.org>
    ASoC: qdsp6: q6asm-dai: fix q6asm_dai_compr_set_params error path

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    wifi: mac80211: fix integer overflow in hwmp_route_info_get()

Alexandre Torgue <alexandre.torgue@foss.st.com>
    clocksource/drivers/stm32-lptimer: Use wakeup capable instead of init wakeup

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    mtd: Replace kcalloc() with devm_kcalloc()

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

Miquel Raynal <miquel.raynal@bootlin.com>
    spi: cadence-qspi: Fix probe on AM62A LP SK

Douglas Anderson <dianders@chromium.org>
    arm64: errata: Add QCOM_KRYO_4XX_GOLD to the spectre_bhb_k24_list

Douglas Anderson <dianders@chromium.org>
    arm64: cputype: Add MIDR_CORTEX_A76AE

Jan Beulich <jbeulich@suse.com>
    xenfs/xensyms: respect hypervisor's "next" indication

Yuan Can <yuancan@huawei.com>
    media: siano: Fix error handling in smsdvb_module_init()

Matthew Majewski <mattwmajewski@gmail.com>
    media: vim2m: print device name after registering device

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

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: rcar: Improve register calculation

Geert Uytterhoeven <geert+renesas@glider.be>
    pwm: rcar: Simplify multiplication/shift logic

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

Luca Ceresoli <luca.ceresoli@bootlin.com>
    drm/bridge: panel: forbid initializing a panel with unknown connector type

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

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid out-of-bounds access in f2fs_truncate_inode_blocks()

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

Douglas Anderson <dianders@chromium.org>
    arm64: cputype: Add QCOM_CPU_PART_KRYO_3XX_GOLD

Mark Rutland <mark.rutland@arm.com>
    perf: arm_pmu: Don't disable counter in armpmu_add()

Max Grobecker <max@grobecker.info>
    x86/cpu: Don't clear X86_FEATURE_LAHF_LM flag in init_amd_k8() on AMD when running in a virtual machine

Zhongqiu Han <quic_zhonhan@quicinc.com>
    pm: cpupower: bench: Prevent NULL dereference on malloc failure

Trond Myklebust <trond.myklebust@hammerspace.com>
    umount: Allow superblock owners to force umount

Florian Westphal <fw@strlen.de>
    nft_set_pipapo: fix incorrect avx2 match of 5th field octet

Arnaud Lecomte <contact@arnaud-lcm.com>
    net: ppp: Add bound checking for skb data on ppp_sync_txmung

Daniel Wagner <wagi@kernel.org>
    nvmet-fcloop: swap list_add_tail arguments

Wentao Liang <vulab@iscas.ac.cn>
    ata: sata_sx4: Add error handling in pdc20621_i2c_read()

Hannes Reinecke <hare@suse.de>
    ata: sata_sx4: Drop pointless VPRINTK() calls and convert the remaining ones

Jakub Kicinski <kuba@kernel.org>
    net: tls: explicitly disallow disconnect

Cong Wang <xiyou.wangcong@gmail.com>
    codel: remove sch->q.qlen check before qdisc_tree_reduce_backlog()

Tung Nguyen <tung.quang.nguyen@est.tech>
    tipc: fix memory leak in tipc_link_xmit

Henry Martin <bsdhenrymartin@gmail.com>
    ata: pata_pxa: Fix potential NULL pointer dereference in pxa_ata_probe()


-------------

Diffstat:

 Makefile                                           |   7 +-
 arch/arm/mach-exynos/Kconfig                       |   1 -
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   6 +-
 arch/arm64/include/asm/cputype.h                   |   4 +
 arch/arm64/kernel/proton-pack.c                    |   1 +
 arch/mips/dec/prom/init.c                          |   2 +-
 arch/mips/include/asm/ds1287.h                     |   2 +-
 arch/mips/include/asm/mips-cm.h                    |  22 +++
 arch/mips/kernel/cevt-ds1287.c                     |   1 +
 arch/mips/kernel/mips-cm.c                         |  14 ++
 arch/parisc/kernel/pdt.c                           |   2 +
 arch/powerpc/kernel/rtas.c                         |   4 +
 arch/riscv/include/asm/kgdb.h                      |   9 +-
 arch/riscv/include/asm/syscall.h                   |   7 +-
 arch/riscv/kernel/kgdb.c                           |   6 +
 arch/s390/kvm/trace-s390.h                         |   4 +-
 arch/sparc/mm/tlb.c                                |   5 +-
 arch/x86/entry/entry.S                             |   2 +-
 arch/x86/events/intel/ds.c                         |   8 +-
 arch/x86/events/intel/uncore_snbep.c               |  49 ++-----
 arch/x86/kernel/cpu/amd.c                          |   2 +-
 arch/x86/kernel/cpu/bugs.c                         |   8 +-
 arch/x86/kernel/e820.c                             |  17 ++-
 arch/x86/kvm/svm/avic.c                            |  60 ++++----
 arch/x86/kvm/vmx/posted_intr.c                     |  28 ++--
 arch/x86/platform/pvh/head.S                       |   7 +-
 block/blk-cgroup.c                                 |  24 +++-
 block/blk-iocost.c                                 |   7 +-
 crypto/crypto_null.c                               |  37 +++--
 drivers/acpi/pptt.c                                |   4 +-
 drivers/ata/ahci.c                                 |   2 +
 drivers/ata/libata-eh.c                            |  11 +-
 drivers/ata/pata_pxa.c                             |   6 +
 drivers/ata/sata_sx4.c                             | 118 ++++++---------
 drivers/bluetooth/btrtl.c                          |   2 +
 drivers/bluetooth/hci_ldisc.c                      |  19 ++-
 drivers/bluetooth/hci_uart.h                       |   1 +
 drivers/char/virtio_console.c                      |   7 +-
 drivers/clk/clk.c                                  |   4 +
 drivers/clocksource/timer-stm32-lp.c               |   4 +-
 drivers/cpufreq/cpufreq.c                          |   8 ++
 drivers/cpufreq/scpi-cpufreq.c                     |  13 +-
 drivers/crypto/atmel-sha204a.c                     |   7 +-
 drivers/crypto/caam/qi.c                           |   6 +-
 drivers/crypto/ccp/sp-pci.c                        |  15 +-
 drivers/dma-buf/udmabuf.c                          |   2 +-
 drivers/dma/dmatest.c                              |   6 +-
 drivers/gpio/gpio-zynq.c                           |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c        |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |   6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  10 ++
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  14 +-
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |   2 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_thermal.c  |   4 +-
 .../drm/amd/pm/powerplay/hwmgr/vega10_thermal.c    |   4 +-
 .../drm/amd/pm/powerplay/hwmgr/vega20_thermal.c    |   2 +-
 drivers/gpu/drm/drm_atomic_helper.c                |   2 +-
 drivers/gpu/drm/drm_panel.c                        |   5 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |  10 +-
 drivers/gpu/drm/i915/gt/intel_engine_cs.c          |   7 +-
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |   9 ++
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   3 +
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   3 -
 drivers/gpu/drm/sti/Makefile                       |   2 -
 drivers/gpu/drm/tiny/repaper.c                     |   4 +-
 drivers/hid/usbhid/hid-pidff.c                     |  60 +++++---
 drivers/hsi/clients/ssi_protocol.c                 |   1 +
 drivers/i2c/busses/i2c-cros-ec-tunnel.c            |   3 +
 drivers/i3c/master.c                               |   3 +
 drivers/iio/adc/ad7768-1.c                         |   5 +-
 drivers/infiniband/core/umem_odp.c                 |   6 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   2 +-
 drivers/infiniband/hw/qib/qib_fs.c                 |   1 +
 drivers/infiniband/hw/usnic/usnic_ib_main.c        |  14 +-
 drivers/iommu/amd/iommu.c                          |   2 +-
 drivers/mcb/mcb-parse.c                            |   2 +-
 drivers/md/dm-cache-target.c                       |  24 ++--
 drivers/md/dm-integrity.c                          |   3 +
 drivers/md/raid1.c                                 |  26 ++--
 drivers/media/common/siano/smsdvb-main.c           |   2 +
 drivers/media/i2c/adv748x/adv748x.h                |   2 +-
 drivers/media/i2c/ov7251.c                         |   4 +-
 drivers/media/platform/qcom/venus/Makefile         |   3 +-
 drivers/media/platform/qcom/venus/core.c           |  17 ---
 drivers/media/platform/qcom/venus/core.h           |  41 +-----
 drivers/media/platform/qcom/venus/helpers.c        |  60 ++++----
 drivers/media/platform/qcom/venus/helpers.h        |   2 +-
 drivers/media/platform/qcom/venus/hfi.c            |  18 ++-
 drivers/media/platform/qcom/venus/hfi_parser.c     | 159 ++++++++++++++++-----
 drivers/media/platform/qcom/venus/hfi_parser.h     |   2 +-
 drivers/media/platform/qcom/venus/hfi_platform.c   |  49 +++++++
 drivers/media/platform/qcom/venus/hfi_platform.h   |  61 ++++++++
 .../media/platform/qcom/venus/hfi_platform_v4.c    |  60 ++++++++
 drivers/media/platform/qcom/venus/hfi_venus.c      |  18 ++-
 drivers/media/platform/qcom/venus/pm_helpers.c     |  12 +-
 drivers/media/platform/qcom/venus/vdec.c           |   8 +-
 drivers/media/platform/qcom/venus/venc.c           |  91 ++++++++----
 drivers/media/rc/streamzap.c                       | 135 +++++++----------
 drivers/media/test-drivers/vim2m.c                 |   6 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |   4 +-
 drivers/mfd/ene-kb3930.c                           |   2 +-
 drivers/misc/mei/hw-me-regs.h                      |   1 +
 drivers/misc/mei/pci-me.c                          |   1 +
 drivers/misc/pci_endpoint_test.c                   |   6 +-
 drivers/mtd/inftlcore.c                            |   9 +-
 drivers/mtd/mtdpstore.c                            |   9 +-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |   2 +-
 drivers/mtd/nand/raw/r852.c                        |   3 +
 drivers/net/dsa/b53/b53_common.c                   |  10 ++
 drivers/net/dsa/mv88e6xxx/chip.c                   |  25 +++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c |   1 +
 drivers/net/ethernet/intel/igc/igc_main.c          |   1 +
 drivers/net/ethernet/intel/igc/igc_ptp.c           |   7 +
 .../net/ethernet/mellanox/mlx5/core/en/rep/neigh.c |  15 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  33 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   3 +
 drivers/net/phy/phy_led_triggers.c                 |  23 +--
 drivers/net/ppp/ppp_synctty.c                      |   5 +
 drivers/net/wireless/ath/ath10k/sdio.c             |   5 +-
 drivers/net/wireless/atmel/at76c50x-usb.c          |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   1 +
 drivers/net/wireless/ti/wl1251/tx.c                |   4 +-
 drivers/ntb/hw/idt/ntb_hw_idt.c                    |  18 +--
 drivers/ntb/ntb_transport.c                        |   2 +-
 drivers/nvme/host/core.c                           |  10 ++
 drivers/nvme/target/fc.c                           |  14 --
 drivers/nvme/target/fcloop.c                       |   2 +-
 drivers/of/irq.c                                   |  13 +-
 drivers/pci/controller/pcie-brcmstb.c              |  13 +-
 drivers/pci/pci.c                                  | 107 ++++++++------
 drivers/pci/probe.c                                |  60 ++++++--
 drivers/pci/remove.c                               |   7 +
 drivers/perf/arm_pmu.c                             |   8 +-
 drivers/phy/tegra/xusb.c                           |   2 +-
 drivers/pinctrl/qcom/pinctrl-msm.c                 |  12 +-
 drivers/platform/x86/asus-laptop.c                 |   9 +-
 .../x86/intel_speed_select_if/isst_if_common.c     |   2 +-
 drivers/pwm/pwm-fsl-ftm.c                          |   6 +
 drivers/pwm/pwm-mediatek.c                         |  20 ++-
 drivers/pwm/pwm-rcar.c                             |  24 ++--
 drivers/s390/block/dasd.c                          |   5 +-
 drivers/s390/virtio/virtio_ccw.c                   |  16 ++-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   2 +
 drivers/scsi/pm8001/pm8001_sas.c                   |   1 +
 drivers/scsi/scsi_transport_iscsi.c                |   7 +-
 drivers/scsi/st.c                                  |   2 +-
 drivers/scsi/ufs/ufs_bsg.c                         |   1 +
 drivers/soc/samsung/Kconfig                        |  12 +-
 drivers/soc/samsung/Makefile                       |   3 +-
 drivers/soc/samsung/exynos-asv.c                   |  45 ++----
 drivers/soc/samsung/exynos-asv.h                   |   2 +
 drivers/soc/samsung/exynos-chipid.c                | 139 +++++++++++++-----
 drivers/soc/ti/omap_prm.c                          |   2 +
 drivers/spi/spi-cadence-quadspi.c                  |   6 +
 drivers/staging/comedi/drivers/jr3_pci.c           |  15 +-
 drivers/staging/rtl8723bs/core/rtw_mlme.c          |   2 +
 drivers/thermal/rockchip_thermal.c                 |   1 +
 drivers/tty/serial/sifive.c                        |   6 +
 drivers/usb/cdns3/gadget.c                         |   2 +
 drivers/usb/core/quirks.c                          |   9 ++
 drivers/usb/dwc3/gadget.c                          |   6 +
 drivers/usb/gadget/udc/aspeed-vhub/dev.c           |   3 +
 drivers/usb/host/max3421-hcd.c                     |   7 +
 drivers/usb/host/ohci-pci.c                        |  23 +++
 drivers/usb/serial/ftdi_sio.c                      |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   5 +
 drivers/usb/serial/option.c                        |   3 +
 drivers/usb/serial/usb-serial-simple.c             |   7 +
 drivers/usb/storage/unusual_uas.h                  |   7 +
 drivers/vdpa/mlx5/core/mr.c                        |   7 +-
 drivers/vfio/pci/vfio_pci.c                        |  13 ++
 drivers/video/backlight/led_bl.c                   |   5 +-
 drivers/video/fbdev/omap2/omapfb/dss/dispc.c       |   6 +-
 drivers/xen/xenfs/xensyms.c                        |   4 +-
 fs/Kconfig                                         |   1 +
 fs/btrfs/super.c                                   |   3 +-
 fs/cifs/cifs_debug.c                               |   6 +
 fs/cifs/cifsglob.h                                 |   9 ++
 fs/cifs/cifsproto.h                                |   7 +-
 fs/cifs/connect.c                                  |   2 +-
 fs/cifs/smb2misc.c                                 |  11 +-
 fs/cifs/smb2ops.c                                  |  48 ++++---
 fs/cifs/smb2pdu.c                                  |  10 +-
 fs/cifs/transport.c                                |  43 +++---
 fs/ext4/block_validity.c                           |   5 +-
 fs/ext4/inode.c                                    |  76 +++++++---
 fs/ext4/namei.c                                    |   2 +-
 fs/ext4/super.c                                    |  19 ++-
 fs/ext4/xattr.c                                    |  11 +-
 fs/f2fs/node.c                                     |   9 +-
 fs/fuse/virtio_fs.c                                |   3 +
 fs/hfs/bnode.c                                     |   6 +
 fs/hfsplus/bnode.c                                 |   6 +
 fs/isofs/export.c                                  |   2 +-
 fs/jbd2/journal.c                                  |   1 -
 fs/jfs/jfs_dmap.c                                  |  12 +-
 fs/jfs/jfs_imap.c                                  |   2 +-
 fs/namespace.c                                     |   3 +-
 fs/nfs/Kconfig                                     |   2 +-
 fs/nfs/internal.h                                  |  22 ---
 fs/nfs/nfs4session.h                               |   4 -
 fs/nfsd/Kconfig                                    |   1 +
 fs/nfsd/nfs4state.c                                |   2 +-
 fs/nfsd/nfsfh.h                                    |   7 -
 fs/proc/array.c                                    |  64 +++++----
 include/linux/backing-dev.h                        |   1 +
 include/linux/blk-cgroup.h                         |   1 +
 include/linux/filter.h                             |   4 +
 include/linux/nfs.h                                |  13 ++
 include/linux/pci.h                                |  12 ++
 include/linux/soc/samsung/exynos-chipid.h          |   6 +-
 include/net/net_namespace.h                        |   1 +
 include/net/sctp/structs.h                         |   3 +-
 include/uapi/linux/kfd_ioctl.h                     |   2 +
 include/xen/interface/xen-mca.h                    |   2 +-
 init/Kconfig                                       |   3 +-
 kernel/bpf/helpers.c                               |  11 +-
 kernel/bpf/syscall.c                               |  17 ++-
 kernel/dma/contiguous.c                            |   3 +-
 kernel/locking/lockdep.c                           |   3 +
 kernel/resource.c                                  |  41 ++----
 kernel/sched/cpufreq_schedutil.c                   |  18 ++-
 kernel/trace/ftrace.c                              |   1 +
 kernel/trace/trace.h                               |   4 +
 kernel/trace/trace_events.c                        |   4 +-
 kernel/trace/trace_events_filter.c                 |   4 +-
 kernel/trace/trace_events_hist.c                   |   7 +-
 kernel/trace/trace_events_synth.c                  |  82 ++++++++++-
 kernel/trace/trace_synth.h                         |   1 +
 lib/sg_split.c                                     |   2 -
 mm/memory.c                                        |   4 +-
 mm/vmscan.c                                        |   2 +-
 net/8021q/vlan_dev.c                               |  31 +---
 net/bluetooth/hci_event.c                          |   5 +-
 net/core/dev.c                                     |   1 +
 net/core/filter.c                                  |  80 ++++++-----
 net/core/net_namespace.c                           |  21 ++-
 net/core/page_pool.c                               |   8 +-
 net/ipv4/inet_connection_sock.c                    |  19 ++-
 net/mac80211/iface.c                               |   3 +
 net/mac80211/mesh_hwmp.c                           |  14 +-
 net/mptcp/protocol.c                               |  45 ++++++
 net/mptcp/subflow.c                                |  15 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |  10 +-
 net/netfilter/nft_set_pipapo_avx2.c                |   3 +-
 net/openvswitch/actions.c                          |   4 +-
 net/openvswitch/flow_netlink.c                     |   3 +-
 net/sched/sch_codel.c                              |   5 +-
 net/sched/sch_fq_codel.c                           |   6 +-
 net/sched/sch_hfsc.c                               |  23 ++-
 net/sctp/socket.c                                  |  22 +--
 net/sctp/transport.c                               |   2 +
 net/tipc/link.c                                    |   1 +
 net/tipc/monitor.c                                 |   3 +-
 net/tls/tls_main.c                                 |   6 +
 sound/pci/hda/hda_intel.c                          |  15 +-
 sound/soc/codecs/wcd934x.c                         |   2 +-
 sound/soc/qcom/qdsp6/q6asm-dai.c                   |  19 ++-
 sound/usb/midi.c                                   |  80 ++++++++++-
 tools/objtool/check.c                              |   3 +
 tools/power/cpupower/bench/parse.c                 |   4 +
 tools/testing/selftests/mincore/mincore_selftest.c |   3 -
 tools/testing/selftests/ublk/test_stripe_04.sh     |  24 ++++
 .../selftests/vm/charge_reserved_hugetlb.sh        |   4 +-
 .../selftests/vm/hugetlb_reparenting_test.sh       |   2 +-
 268 files changed, 2396 insertions(+), 1209 deletions(-)


