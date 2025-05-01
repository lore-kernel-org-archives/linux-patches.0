Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5D828399;
	Thu,  1 May 2025 08:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746087495; cv=none; b=myb9YaDp7+mAK/RiyuZyVCfWiNTEQy1Lia/4rPTv/N6p7KvdQOkD/PI4LvogMyr3xR1mg6zlldqR5PVdQCtAKzs+vW8lawYar3qS1lO9KWFJm62tmTjxVEpY5HV1kyl7PH88EFOc5rZE2AYpCvsXSajMbH8QvdLTcNC/VtkSkJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746087495; c=relaxed/simple;
	bh=OuQI7+De7i6qW/RuedtTEOvYRaoCy7/XCqQN+m9d3DU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WgzUsSJtTD1dweo9LyFOyiNFgk615aOLzYiWqKwlm9zx3lV1Rszj+DPHxVFsGDO32sF8X09nQiZ2ZvhQ8V4pSyStOemZL1sDSjpmrp64oQgIfN6hSAYXHAyh0cMAMCViij/DiFPQQLnwUhCd1ErWkkWA8uA24wlXem4d280ZLTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5xu0ocf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5xu0ocf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC53C4CEE3;
	Thu,  1 May 2025 08:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746087494;
	bh=OuQI7+De7i6qW/RuedtTEOvYRaoCy7/XCqQN+m9d3DU=;
	h=From:To:Cc:Subject:Date:From;
	b=C5xu0ocfCa/YDPhUNPzeA0KzST2+aY733H2pFUk7NDCcCi915Mo0YzNmHTLogOVsJ
	 V1QtuzFlepvE2FCEk4ZYkUSbxrLQP7EXl9rT2wWu6PdQVnWGkpLn1EcYD9HotCK5uv
	 W9d/vPwAaZ8alOso7OwVJcyir/4zfXjXNN1LSM1M=
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
Subject: [PATCH 5.15 000/368] 5.15.181-rc2 review
Date: Thu,  1 May 2025 10:18:10 +0200
Message-ID: <20250501081459.064070563@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.181-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.181-rc2
X-KernelTest-Deadline: 2025-05-03T08:15+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.181 release.
There are 368 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 03 May 2025 08:13:53 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.181-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.181-rc2

Ross Lagerwall <ross.lagerwall@citrix.com>
    PCI: Release resource invalidated by coalescing

Geert Uytterhoeven <geert+renesas@glider.be>
    PCI: Fix dropping valid root bus resources with .end = zero

Rob Herring <robh@kernel.org>
    PCI: Fix use-after-free in pci_bus_release_domain_nr()

Hannes Reinecke <hare@kernel.org>
    nvme: fixup scan failure for non-ANA multipath controllers

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    MIPS: cm: Fix warning if MIPS_CM is disabled

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    xdp: Reset bpf_redirect_info before running a xdp's BPF prog.

Tim Huang <tim.huang@amd.com>
    drm/amd/display: fix double free issue during amdgpu module unload

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: enable .port_set_policy() for 6320 family

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: enable PVT for 6321 switch

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: fix atu_move_port_mask for 6341 family

Marek Behún <kabel@kernel.org>
    crypto: atmel-sha204a - Set hwrng quality to lowest possible

Ian Abbott <abbotti@mev.co.uk>
    comedi: jr3_pci: Fix synchronous deletion of timer

Dave Kleikamp <dave.kleikamp@oracle.com>
    jfs: define xtree root and page independently

Meir Elisha <meir.elisha@volumez.com>
    md/raid1: Add check for missing source disk in process_checks()

Mostafa Saleh <smostafa@google.com>
    ubsan: Fix panic from test_ubsan_out_of_bounds

Yunlong Xing <yunlong.xing@unisoc.com>
    loop: aio inherit the ioprio of original request

Igor Pylypiv <ipylypiv@google.com>
    scsi: pm80xx: Set phy_attached to zero when device is gone

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

Arnd Bergmann <arnd@arndb.de>
    ntb: reduce stack usage in idt_scan_mws

Al Viro <viro@zeniv.linux.org.uk>
    qibfs: fix _another_ leak

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool, ASoC: codecs: wcd934x: Remove potential undefined behavior in wcd934x_slim_irq_handler()

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

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: null - Use spin lock instead of mutex

Gregory CLEMENT <gregory.clement@bootlin.com>
    MIPS: cm: Detect CM quirks from device tree

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

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Fix gpu reset in multidisplay config

Oleksij Rempel <linux@rempel-privat.de>
    net: selftests: initialize TCP header and skb payload with zero

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

Marc Zyngier <maz@kernel.org>
    cpufreq: cppc: Fix invalid return value in .get() callback

Henry Martin <bsdhenrymartin@gmail.com>
    cpufreq: scpi: Fix null-ptr-deref in scpi_cpufreq_get_rate()

Henry Martin <bsdhenrymartin@gmail.com>
    cpufreq: scmi: Fix null-ptr-deref in scmi_cpufreq_get_rate()

Arnd Bergmann <arnd@arndb.de>
    dma/contiguous: avoid warning about unused size_bytes

Akhil P Oommen <quic_akhilpo@quicinc.com>
    drm/msm/a6xx: Fix stale rpmh votes from GPU

Akhil P Oommen <quic_akhilpo@quicinc.com>
    drm/msm/a6xx: Avoid gx gbit halt during rpm suspend

Akhil P Oommen <quic_akhilpo@quicinc.com>
    drm/msm/a6xx: Handle GMU prepare-slumber hfi failure

Akhil P Oommen <quic_akhilpo@quicinc.com>
    drm/msm/a6xx: Improve gpu recovery sequence

Peter Collingbourne <pcc@google.com>
    string: Add load_unaligned_zeropad() code path to sized_strscpy()

Alexander Potapenko <glider@google.com>
    kmsan: disable strscpy() optimization under KMSAN

Mark Brown <broonie@kernel.org>
    selftests/mm: generate a temporary mountpoint for cgroup filesystem

Denis Arefev <arefev@swemel.ru>
    ksmbd: Prevent integer overflow in calculation of deadtime

Ma Ke <make24@iscas.ac.cn>
    PCI: Fix reference leak in pci_register_host_bridge()

Pali Rohár <pali@kernel.org>
    PCI: Assign PCI domain IDs by ida_alloc()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    PCI: Coalesce host bridge contiguous apertures

Guixin Liu <kanie@linux.alibaba.com>
    gpio: tegra186: fix resource handling in ACPI probe path

Thierry Reding <treding@nvidia.com>
    gpio: tegra186: Force one interrupt per bank

Roman Smirnov <r.smirnov@omp.ru>
    cifs: fix integer overflow in match_server()

Alexandra Diupina <adiupina@astralinux.ru>
    cifs: avoid NULL pointer dereference in dbg call

Enzo Matsumiya <ematsumiya@suse.de>
    cifs: print TIDs as hex

Herve Codina <herve.codina@bootlin.com>
    backlight: led_bl: Hold led_access lock when calling led_sysfs_disable()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    backlight: led_bl: Convert to platform remove callback returning void

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

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: fix VTU methods for 6320 family

Haoxiang Li <haoxiang_li2024@163.com>
    auxdisplay: hd44780: Fix an API misuse in hd44780.c

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    auxdisplay: hd44780: Convert to platform remove callback returning void

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

Thorsten Leemhuis <linux@leemhuis.info>
    module: sign with sha512 instead of sha1 by default

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SCO: Fix UAF on sco_sock_timeout

Nathan Chancellor <nathan@kernel.org>
    f2fs: Add inline to f2fs_build_fault_attr() stub

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix null pointer dereference after failing to issue FLOGI and PLOGI

Kunwu Chan <chentao@kylinos.cn>
    pmdomain: ti: Add a null pointer check to the omap_prm_domain_init

Chao Yu <chao@kernel.org>
    f2fs: check validation of fault attrs in f2fs_build_fault_attr()

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    mm: fix apply_to_existing_page_range()

Oleg Nesterov <oleg@redhat.com>
    fs/proc: do_task_stat: use sig->stats_lock to gather the threads/children stats

Chris Wilson <chris.p.wilson@intel.com>
    drm/i915/gt: Cleanup partial engine discovery failures

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

Qun-Wei Lin <qun-wei.lin@mediatek.com>
    sched/task_stack: fix object_is_on_stack() for KASAN tagged pointers

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix potential UAF in cifs_stats_proc_show()

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix potential deadlock when releasing mids

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/server: fix potential null-ptr-deref of lease_ctx_info in smb2_open()

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix NULL ptr deref in crypto_aead_setkey()

Enzo Matsumiya <ematsumiya@suse.de>
    smb: client: fix UAF in async decryption

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix UAF in cifs_demultiplex_thread()

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix use-after-free bug in cifs_debug_data_proc_show()

Eric Dumazet <edumazet@google.com>
    net: make sock_inuse_add() available

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix potencial out-of-bounds when buffer offset is invalid

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix potential UAF in cifs_dump_full_key()

WangYuli <wangyuli@uniontech.com>
    nvmet-fc: Remove unused functions

Mickaël Salaün <mic@digikod.net>
    landlock: Add the errata interface

Vitaly Prosyak <vitaly.prosyak@amd.com>
    drm/amdgpu: fix usage slab after free

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add null checks for 'stream' and 'plane' before dereferencing

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

Ard Biesheuvel <ardb@kernel.org>
    x86/pvh: Call C code via the kernel virtual mapping

Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>
    net: mana: Fix error handling in mana_create_txq/rxq's NAPI cleanup

Michal Schmidt <mschmidt@redhat.com>
    bnxt_re: avoid shift undefined behavior in bnxt_qplib_alloc_init_hwq

Rémi Denis-Courmont <courmisch@gmail.com>
    phonet/pep: fix racy skb_queue_empty() use

Trond Myklebust <trond.myklebust@hammerspace.com>
    filemap: Fix bounds checking in filemap_read()

Wang Liang <wangliang74@huawei.com>
    net: fix crash when config small gso_max_size/gso_ipv4_max_size

Paolo Abeni <pabeni@redhat.com>
    ipv6: release nexthop on device removal

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    misc: pci_endpoint_test: Fix 'irq_type' to convey the correct type

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    misc: pci_endpoint_test: Fix displaying 'irq_type' after 'request_irq' error

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    misc: pci_endpoint_test: Avoid issue of interrupts remaining after request_irq error

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: sockopt: fix getting IPV6_V6ONLY

Nathan Chancellor <nathan@kernel.org>
    kbuild: Add '-fno-builtin-wcslen'

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Reference count policy in cpufreq_update_limits()

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Eagerly switch ZCR_EL{1,2}

Fuad Tabba <tabba@google.com>
    KVM: arm64: Calculate cptr_el2 traps on activating traps

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Remove VHE host restore of CPACR_EL1.ZEN

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Remove host FPSIMD saving for non-protected KVM

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Unconditionally save+flush host FPSIMD/SVE/SME state

Mark Brown <broonie@kernel.org>
    arm64/fpsimd: Stop using TIF_SVE to manage register saving in KVM

Mark Brown <broonie@kernel.org>
    arm64/fpsimd: Have KVM explicitly say which FP registers to save

Mark Brown <broonie@kernel.org>
    arm64/fpsimd: Track the saved FPSIMD state type separately to TIF_SVE

Mark Brown <broonie@kernel.org>
    KVM: arm64: Discard any SVE state when entering KVM guests

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Always start with clearing SVE flag on load

Mark Brown <broonie@kernel.org>
    KVM: arm64: Get rid of host SVE tracking/saving

Rolf Eike Beer <eb@emlix.com>
    drm/sti: remove duplicate object names

Chris Bainbridge <chris.bainbridge@gmail.com>
    drm/nouveau: prime: fix ttm_bo_delayed_delete oops

Matthew Auld <matthew.auld@intel.com>
    drm/amdgpu/dma_buf: fix page_link check

Denis Arefev <arefev@swemel.ru>
    drm/amd/pm/powerplay/hwmgr/vega20_thermal: Prevent division by zero

Denis Arefev <arefev@swemel.ru>
    drm/amd/pm/swsmu/smu13/smu_v13_0: Prevent division by zero

Denis Arefev <arefev@swemel.ru>
    drm/amd/pm/powerplay/hwmgr/smu7_thermal: Prevent division by zero

Denis Arefev <arefev@swemel.ru>
    drm/amd/pm/powerplay: Prevent division by zero

Denis Arefev <arefev@swemel.ru>
    drm/amd/pm: Prevent division by zero

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    drm/repaper: fix integer overflows in repeat functions

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Fix the scale of IIO free running counters on SPR

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

Baoquan He <bhe@redhat.com>
    mm/gup: fix wrongly calculated returned value in fault_in_safe_writeable()

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    loop: LOOP_SET_FD: send uevents for partitions

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    loop: properly send KOBJ_CHANGED uevent for disk device

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

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs:lpass-wsa-macro: Fix logic of enabling vi channels

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs:lpass-wsa-macro: Fix vi feedback rate

Alex Williamson <alex.williamson@redhat.com>
    Revert "PCI: Avoid reset when disabled via sysfs"

Andreas Gruenbacher <agruenba@redhat.com>
    writeback: fix false warning in inode_to_wb()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq/sched: Fix the usage of CPUFREQ_NEED_UPDATE_LIMITS

WangYuli <wangyuli@uniontech.com>
    riscv: KGDB: Remove ".option norvc/.option rvc" for kgdb_compiled_break

WangYuli <wangyuli@uniontech.com>
    riscv: KGDB: Do not inline arch_kgdb_breakpoint()

Björn Töpel <bjorn@rivosinc.com>
    riscv: Properly export reserved regions in /proc/iomem

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: avoid refcount warnings when ds->ops->tag_8021q_vlan_del() fails

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: mv88e6xxx: avoid unregistering devlink regions which were never registered

Jonas Gorski <jonas.gorski@gmail.com>
    net: b53: enable BPDU reception for management port

Abdun Nihaal <abdun.nihaal@gmail.com>
    cxgb4: fix memory leak in cxgb4_init_ethtool_filters() error path

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix nested key length validation in the set() action

Matt Johnston <matt@codeconstruct.com.au>
    net: mctp: Set SOCK_RCU_FREE

Christopher S M Hall <christopher.s.hall@intel.com>
    igc: cleanup PTP module if probe fails

Christopher S M Hall <christopher.s.hall@intel.com>
    igc: handle the IGC_PTP_ENABLED flag correctly

Christopher S M Hall <christopher.s.hall@intel.com>
    igc: move ktime snapshot into PTM retry loop

Christopher S M Hall <christopher.s.hall@intel.com>
    igc: fix PTM cycle trigger logic

Johannes Berg <johannes.berg@intel.com>
    Revert "wifi: mac80211: Update skb's control block key in ieee80211_tx_dequeue()"

Frédéric Danis <frederic.danis@collabora.com>
    Bluetooth: l2cap: Check encryption key size on incoming connection

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

Yu Kuai <yukuai3@huawei.com>
    md/raid10: fix missing discard IO accounting

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

Xingui Yang <yangxingui@huawei.com>
    scsi: hisi_sas: Enable force phy when SATA disk directly connected

John Garry <john.garry@huawei.com>
    scsi: libsas: Add struct sas_tmf_task

John Garry <john.garry@huawei.com>
    scsi: libsas: Delete lldd_clear_aca callback

John Garry <john.garry@huawei.com>
    scsi: hisi_sas: Fix setting of hisi_sas_slot.is_internal

John Garry <john.garry@huawei.com>
    scsi: hisi_sas: Factor out task prep and delivery code

John Garry <john.garry@huawei.com>
    scsi: hisi_sas: Pass abort structure for internal abort

John Garry <john.garry@huawei.com>
    scsi: hisi_sas: Start delivery hisi_sas_task_exec() directly

Arseniy Krasnov <avkrasnov@salutedevices.com>
    Bluetooth: hci_uart: Fix another race during initialization

Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
    x86/e820: Fix handling of subpage regions when calculating nosave ranges in e820__register_nosave_regions()

Nathan Chancellor <nathan@kernel.org>
    ACPI: platform-profile: Fix CFI violation when accessing sysfs files

Douglas Anderson <dianders@chromium.org>
    arm64: errata: Add newer ARM cores to the spectre_bhb_loop_affected() lists

Kaixin Wang <kxwang23@m.fudan.edu.cn>
    HSI: ssi_protocol: Fix use after free vulnerability in ssi_protocol Driver Due to Race Condition

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

Shuai Xue <xueshuai@linux.alibaba.com>
    mm/hwpoison: do not send SIGBUS to processes with recovered clean pages

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

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: only inc MPJoinAckHMacFailure for HMAC failures

Gang Yan <yangang@kylinos.cn>
    mptcp: fix NULL pointer in can_accept_new_subflow

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

Stanley Chu <yschu@nuvoton.com>
    i3c: master: svc: Use readsb helper for reading MDB

Si-Wei Liu <si-wei.liu@oracle.com>
    vdpa/mlx5: Fix oversized null mkey longer than 32bit

Artem Sadovnikov <a.sadovnikov@ispras.ru>
    ext4: fix off-by-one error in do_split

Jeff Hugo <quic_jhugo@quicinc.com>
    bus: mhi: host: Fix race between unprepare and queue_buf

Alexey Klimov <alexey.klimov@linaro.org>
    ASoC: qdsp6: q6asm-dai: fix q6asm_dai_compr_set_params error path

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    wifi: mac80211: fix integer overflow in hwmp_route_info_get()

Haoxiang Li <haoxiang_li2024@163.com>
    wifi: mt76: Add check for devm_kstrdup()

Alexandre Torgue <alexandre.torgue@foss.st.com>
    clocksource/drivers/stm32-lptimer: Use wakeup capable instead of init wakeup

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    mtd: Replace kcalloc() with devm_kcalloc()

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: workaround RGMII transmit delay erratum for 6320 family

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    mtd: Add check for devm_kcalloc()

Vikash Garodia <quic_vgarodia@quicinc.com>
    media: venus: hfi_parser: refactor hfi packet parsing logic

Vikash Garodia <quic_vgarodia@quicinc.com>
    media: venus: hfi_parser: add check to avoid out of bound access

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: i2c: ov7251: Introduce 1 ms delay between regulators and en GPIO

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: i2c: ov7251: Set enable GPIO low in probe

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: i2c: ccs: Set the device's runtime PM status correctly in probe

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: i2c: ccs: Set the device's runtime PM status correctly in remove

Karina Yankevich <k.yankevich@omp.ru>
    media: v4l2-dv-timings: prevent possible overflow in v4l2_detect_gtf()

Murad Masimov <m.masimov@mt-integration.ru>
    media: streamzap: prevent processing IR data on URB failure

Kamal Dasu <kamal.dasu@broadcom.com>
    mtd: rawnand: brcmnand: fix PM resume warning

Miquel Raynal <miquel.raynal@bootlin.com>
    spi: cadence-qspi: Fix probe on AM62A LP SK

Douglas Anderson <dianders@chromium.org>
    arm64: errata: Add KRYO 2XX/3XX/4XX silver cores to Spectre BHB safe list

Douglas Anderson <dianders@chromium.org>
    arm64: errata: Assume that unknown CPUs _are_ vulnerable to Spectre BHB

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

Ayush Jain <Ayush.jain3@amd.com>
    ktest: Fix Test Failures Due to Missing LOG_FILE Directories

Leonid Arapov <arapovl839@gmail.com>
    fbdev: omapfb: Add 'plane' value check

Ryo Takakura <ryotkkr98@gmail.com>
    PCI: vmd: Make vmd_dev::cfg_lock a raw_spinlock_t type

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: mtk_dpi: Explicitly manage TVD clock in power on/off

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Fix pqm_destroy_queue race with GPU reset

David Yat Sin <David.YatSin@amd.com>
    drm/amdkfd: clamp queue size to minimum

Lucas De Marchi <lucas.demarchi@intel.com>
    drivers: base: devres: Allow to release group on device release

Luca Ceresoli <luca.ceresoli@bootlin.com>
    drm/bridge: panel: forbid initializing a panel with unknown connector type

Andrew Wyatt <fewtarius@steamfork.org>
    drm: panel-orientation-quirks: Add new quirk for GPD Win 2

Andrew Wyatt <fewtarius@steamfork.org>
    drm: panel-orientation-quirks: Add support for AYANEO 2S

Zhikai Zhai <zhikai.zhai@amd.com>
    drm/amd/display: Update Cursor request mode to the beginning prefetch always

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

Zhongqiu Han <quic_zhonhan@quicinc.com>
    jfs: Fix uninit-value access of imap allocated in the diMount() function

Jason Xing <kerneljasonxing@gmail.com>
    page_pool: avoid infinite loop to schedule delayed worker

Ricard Wanderlof <ricard2013@butoba.net>
    ALSA: usb-audio: Fix CME quirk for UF series keyboards

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_audmix: register card device depends on 'dais' property

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

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: ethtool: Don't call .cleanup_data when prepare_data fails

Jakub Kicinski <kuba@kernel.org>
    net: tls: explicitly disallow disconnect

Tung Nguyen <tung.quang.nguyen@est.tech>
    tipc: fix memory leak in tipc_link_xmit

Henry Martin <bsdhenrymartin@gmail.com>
    ata: pata_pxa: Fix potential NULL pointer dereference in pxa_ata_probe()


-------------

Diffstat:

 Documentation/scsi/libsas.rst                      |   2 -
 Makefile                                           |   7 +-
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   6 +-
 arch/arm64/include/asm/cputype.h                   |   4 +
 arch/arm64/include/asm/fpsimd.h                    |   4 +-
 arch/arm64/include/asm/kvm_host.h                  |  17 +-
 arch/arm64/include/asm/kvm_hyp.h                   |   7 +
 arch/arm64/include/asm/processor.h                 |   7 +
 arch/arm64/include/asm/spectre.h                   |   1 -
 arch/arm64/kernel/fpsimd.c                         | 115 +++++--
 arch/arm64/kernel/process.c                        |   3 +
 arch/arm64/kernel/proton-pack.c                    | 208 ++++++------
 arch/arm64/kernel/ptrace.c                         |   3 +
 arch/arm64/kernel/signal.c                         |   3 +
 arch/arm64/kvm/arm.c                               |   1 -
 arch/arm64/kvm/fpsimd.c                            |  72 ++--
 arch/arm64/kvm/hyp/entry.S                         |   5 +
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  86 +++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   9 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |  52 ++-
 arch/arm64/kvm/hyp/vhe/switch.c                    |   4 +
 arch/arm64/kvm/reset.c                             |   3 +
 arch/mips/dec/prom/init.c                          |   2 +-
 arch/mips/include/asm/ds1287.h                     |   2 +-
 arch/mips/include/asm/mips-cm.h                    |  22 ++
 arch/mips/kernel/cevt-ds1287.c                     |   1 +
 arch/mips/kernel/mips-cm.c                         |  14 +
 arch/parisc/kernel/pdt.c                           |   2 +
 arch/powerpc/kernel/rtas.c                         |   4 +
 arch/riscv/include/asm/kgdb.h                      |   9 +-
 arch/riscv/include/asm/syscall.h                   |   7 +-
 arch/riscv/kernel/kgdb.c                           |   6 +
 arch/riscv/kernel/setup.c                          |  36 +-
 arch/s390/kvm/trace-s390.h                         |   4 +-
 arch/sparc/mm/tlb.c                                |   5 +-
 arch/x86/entry/entry.S                             |   2 +-
 arch/x86/events/intel/ds.c                         |   8 +-
 arch/x86/events/intel/uncore_snbep.c               | 107 +-----
 arch/x86/kernel/cpu/amd.c                          |   2 +-
 arch/x86/kernel/cpu/bugs.c                         |  36 +-
 arch/x86/kernel/e820.c                             |  17 +-
 arch/x86/kvm/svm/avic.c                            |  60 ++--
 arch/x86/kvm/vmx/posted_intr.c                     |  28 +-
 arch/x86/mm/tlb.c                                  |   6 +-
 arch/x86/platform/pvh/head.S                       |   7 +-
 block/blk-cgroup.c                                 |  24 +-
 block/blk-iocost.c                                 |   7 +-
 crypto/crypto_null.c                               |  37 +-
 drivers/acpi/platform_profile.c                    |  20 +-
 drivers/acpi/pptt.c                                |   4 +-
 drivers/ata/ahci.c                                 |   2 +
 drivers/ata/libata-eh.c                            |  11 +-
 drivers/ata/pata_pxa.c                             |   6 +
 drivers/ata/sata_sx4.c                             | 118 +++----
 drivers/auxdisplay/hd44780.c                       |   9 +-
 drivers/base/devres.c                              |   7 +
 drivers/block/loop.c                               |   9 +-
 drivers/bluetooth/btrtl.c                          |   2 +
 drivers/bluetooth/hci_ldisc.c                      |  19 +-
 drivers/bluetooth/hci_uart.h                       |   1 +
 drivers/bus/mhi/host/main.c                        |  16 +-
 drivers/char/virtio_console.c                      |   7 +-
 drivers/clk/clk.c                                  |   4 +
 drivers/clocksource/timer-stm32-lp.c               |   4 +-
 drivers/comedi/drivers/jr3_pci.c                   |  17 +-
 drivers/cpufreq/cppc_cpufreq.c                     |   2 +-
 drivers/cpufreq/cpufreq.c                          |   8 +
 drivers/cpufreq/scmi-cpufreq.c                     |  10 +-
 drivers/cpufreq/scpi-cpufreq.c                     |  13 +-
 drivers/crypto/atmel-sha204a.c                     |   7 +-
 drivers/crypto/caam/qi.c                           |   6 +-
 drivers/crypto/ccp/sp-pci.c                        |  15 +-
 drivers/dma-buf/udmabuf.c                          |   2 +-
 drivers/dma/dmatest.c                              |   6 +-
 drivers/gpio/gpio-tegra186.c                       |  93 +++++-
 drivers/gpio/gpio-zynq.c                           |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c            |   6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  10 +
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  20 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |   2 +-
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |  22 +-
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |   2 +-
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c |   3 +
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubp.c  |   2 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_thermal.c  |   4 +-
 .../drm/amd/pm/powerplay/hwmgr/vega10_thermal.c    |   4 +-
 .../drm/amd/pm/powerplay/hwmgr/vega20_thermal.c    |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c  |   3 +
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c     |   2 +-
 drivers/gpu/drm/drm_atomic_helper.c                |   2 +-
 drivers/gpu/drm/drm_panel.c                        |   5 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |  10 +-
 drivers/gpu/drm/i915/gt/intel_engine_cs.c          |   7 +-
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |   9 +
 drivers/gpu/drm/msm/adreno/a6xx.xml.h              |   4 +
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              | 158 +++++----
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  14 +
 drivers/gpu/drm/msm/adreno/a6xx_gpu.h              |   1 +
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   3 +
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   3 -
 drivers/gpu/drm/sti/Makefile                       |   2 -
 drivers/gpu/drm/tiny/repaper.c                     |   4 +-
 drivers/hid/usbhid/hid-pidff.c                     |  60 ++--
 drivers/hsi/clients/ssi_protocol.c                 |   1 +
 drivers/i2c/busses/i2c-cros-ec-tunnel.c            |   3 +
 drivers/i3c/master.c                               |   3 +
 drivers/i3c/master/svc-i3c-master.c                |   2 +-
 drivers/iio/adc/ad7768-1.c                         |   5 +-
 drivers/infiniband/core/umem_odp.c                 |   6 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   3 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   2 +-
 drivers/infiniband/hw/qib/qib_fs.c                 |   1 +
 drivers/infiniband/hw/usnic/usnic_ib_main.c        |  14 +-
 drivers/iommu/amd/iommu.c                          |   2 +-
 drivers/mcb/mcb-parse.c                            |   2 +-
 drivers/md/dm-cache-target.c                       |  24 +-
 drivers/md/dm-integrity.c                          |   3 +
 drivers/md/raid1.c                                 |  26 +-
 drivers/md/raid10.c                                |   1 +
 drivers/media/common/siano/smsdvb-main.c           |   2 +
 drivers/media/i2c/adv748x/adv748x.h                |   2 +-
 drivers/media/i2c/ccs/ccs-core.c                   |   6 +-
 drivers/media/i2c/ov7251.c                         |   4 +-
 drivers/media/platform/qcom/venus/hfi_parser.c     | 100 ++++--
 drivers/media/platform/qcom/venus/hfi_venus.c      |  18 +-
 drivers/media/rc/streamzap.c                       | 135 +++-----
 drivers/media/test-drivers/vim2m.c                 |   6 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |   4 +-
 drivers/mfd/ene-kb3930.c                           |   2 +-
 drivers/misc/mei/hw-me-regs.h                      |   1 +
 drivers/misc/mei/pci-me.c                          |   1 +
 drivers/misc/pci_endpoint_test.c                   |   6 +-
 drivers/mtd/inftlcore.c                            |   9 +-
 drivers/mtd/mtdpstore.c                            |  12 +-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |   2 +-
 drivers/mtd/nand/raw/r852.c                        |   3 +
 drivers/net/dsa/b53/b53_common.c                   |  10 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |  32 +-
 drivers/net/dsa/mv88e6xxx/devlink.c                |   3 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c |   1 +
 drivers/net/ethernet/intel/igc/igc_defines.h       |   1 +
 drivers/net/ethernet/intel/igc/igc_main.c          |   1 +
 drivers/net/ethernet/intel/igc/igc_ptp.c           |  93 ++++--
 drivers/net/ethernet/microsoft/mana/mana.h         |   2 +
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  21 +-
 drivers/net/phy/phy_led_triggers.c                 |  23 +-
 drivers/net/ppp/ppp_synctty.c                      |   5 +
 drivers/net/wireless/ath/ath10k/sdio.c             |   5 +-
 drivers/net/wireless/atmel/at76c50x-usb.c          |   2 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        |   4 +
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   1 +
 drivers/net/wireless/ti/wl1251/tx.c                |   4 +-
 drivers/ntb/hw/idt/ntb_hw_idt.c                    |  18 +-
 drivers/ntb/ntb_transport.c                        |   2 +-
 drivers/nvme/host/core.c                           |   9 +
 drivers/nvme/target/fc.c                           |  39 +--
 drivers/nvme/target/fcloop.c                       |   2 +-
 drivers/of/irq.c                                   |  13 +-
 drivers/pci/controller/pcie-brcmstb.c              |  13 +-
 drivers/pci/controller/vmd.c                       |  12 +-
 drivers/pci/pci.c                                  | 111 +++---
 drivers/pci/probe.c                                |  56 +++-
 drivers/pci/remove.c                               |   7 +
 drivers/perf/arm_pmu.c                             |   8 +-
 drivers/phy/tegra/xusb.c                           |   2 +-
 drivers/pinctrl/qcom/pinctrl-msm.c                 |  12 +-
 drivers/platform/x86/asus-laptop.c                 |   9 +-
 drivers/pwm/pwm-fsl-ftm.c                          |   6 +
 drivers/pwm/pwm-mediatek.c                         |   8 +-
 drivers/pwm/pwm-rcar.c                             |  24 +-
 drivers/s390/char/sclp_con.c                       |  17 +
 drivers/s390/char/sclp_tty.c                       |  12 +
 drivers/scsi/aic94xx/aic94xx.h                     |   1 -
 drivers/scsi/aic94xx/aic94xx_init.c                |   1 -
 drivers/scsi/aic94xx/aic94xx_tmf.c                 |   9 -
 drivers/scsi/hisi_sas/hisi_sas.h                   |  14 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              | 371 ++++++++++-----------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |   2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |  13 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  16 +-
 drivers/scsi/isci/init.c                           |   1 -
 drivers/scsi/isci/task.c                           |  18 -
 drivers/scsi/isci/task.h                           |   4 -
 drivers/scsi/lpfc/lpfc_els.c                       |  51 ++-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   2 +
 drivers/scsi/mvsas/mv_defs.h                       |   5 -
 drivers/scsi/mvsas/mv_init.c                       |   1 -
 drivers/scsi/mvsas/mv_sas.c                        |  31 +-
 drivers/scsi/mvsas/mv_sas.h                        |   1 -
 drivers/scsi/pm8001/pm8001_hwi.c                   |   4 +-
 drivers/scsi/pm8001/pm8001_init.c                  |   1 -
 drivers/scsi/pm8001/pm8001_sas.c                   |  27 +-
 drivers/scsi/pm8001/pm8001_sas.h                   |  11 +-
 drivers/scsi/scsi_transport_iscsi.c                |   7 +-
 drivers/scsi/st.c                                  |   2 +-
 drivers/scsi/ufs/ufs_bsg.c                         |   1 +
 drivers/soc/samsung/exynos-chipid.c                |  74 +++-
 drivers/soc/ti/omap_prm.c                          |   2 +
 drivers/spi/spi-cadence-quadspi.c                  |   6 +
 drivers/thermal/rockchip_thermal.c                 |   1 +
 drivers/tty/serial/sifive.c                        |   6 +
 drivers/usb/cdns3/cdns3-gadget.c                   |   2 +
 drivers/usb/chipidea/ci_hdrc_imx.c                 |  44 ++-
 drivers/usb/class/cdc-wdm.c                        |  21 +-
 drivers/usb/core/quirks.c                          |   9 +
 drivers/usb/dwc3/dwc3-pci.c                        |  10 +
 drivers/usb/dwc3/gadget.c                          |   6 +
 drivers/usb/gadget/udc/aspeed-vhub/dev.c           |   3 +
 drivers/usb/host/max3421-hcd.c                     |   7 +
 drivers/usb/host/ohci-pci.c                        |  23 ++
 drivers/usb/host/xhci-ring.c                       |  11 +-
 drivers/usb/serial/ftdi_sio.c                      |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   5 +
 drivers/usb/serial/option.c                        |   3 +
 drivers/usb/serial/usb-serial-simple.c             |   7 +
 drivers/usb/storage/unusual_uas.h                  |   7 +
 drivers/vdpa/mlx5/core/mr.c                        |   7 +-
 drivers/video/backlight/led_bl.c                   |  11 +-
 drivers/video/fbdev/omap2/omapfb/dss/dispc.c       |   6 +-
 drivers/xen/Kconfig                                |   2 +-
 drivers/xen/xenfs/xensyms.c                        |   4 +-
 fs/Kconfig                                         |   1 +
 fs/btrfs/super.c                                   |   3 +-
 fs/cifs/cifs_debug.c                               |   4 +
 fs/cifs/cifsglob.h                                 |   1 +
 fs/cifs/cifsproto.h                                |   7 +-
 fs/cifs/connect.c                                  |   2 +-
 fs/cifs/fs_context.c                               |   5 +
 fs/cifs/ioctl.c                                    |   3 +-
 fs/cifs/smb2misc.c                                 |  11 +-
 fs/cifs/smb2ops.c                                  |  48 +--
 fs/cifs/smb2pdu.c                                  |  10 +-
 fs/cifs/transport.c                                |  43 +--
 fs/ext4/block_validity.c                           |   5 +-
 fs/ext4/inode.c                                    |  75 +++--
 fs/ext4/namei.c                                    |   2 +-
 fs/ext4/super.c                                    |  19 +-
 fs/ext4/xattr.c                                    |  11 +-
 fs/f2fs/f2fs.h                                     |  12 +-
 fs/f2fs/node.c                                     |   9 +-
 fs/f2fs/super.c                                    |  27 +-
 fs/f2fs/sysfs.c                                    |  14 +-
 fs/fuse/virtio_fs.c                                |   3 +
 fs/hfs/bnode.c                                     |   6 +
 fs/hfsplus/bnode.c                                 |   6 +
 fs/isofs/export.c                                  |   2 +-
 fs/jbd2/journal.c                                  |   1 -
 fs/jfs/jfs_dinode.h                                |   2 +-
 fs/jfs/jfs_dmap.c                                  |  12 +-
 fs/jfs/jfs_imap.c                                  |  10 +-
 fs/jfs/jfs_incore.h                                |   2 +-
 fs/jfs/jfs_txnmgr.c                                |   4 +-
 fs/jfs/jfs_xtree.c                                 |   4 +-
 fs/jfs/jfs_xtree.h                                 |  37 +-
 fs/ksmbd/oplock.c                                  |   2 +-
 fs/ksmbd/smb2misc.c                                |  22 +-
 fs/ksmbd/smb2pdu.c                                 |  49 +--
 fs/ksmbd/transport_ipc.c                           |   7 +-
 fs/namespace.c                                     |   3 +-
 fs/nfs/Kconfig                                     |   2 +-
 fs/nfs/internal.h                                  |  22 --
 fs/nfs/nfs4session.h                               |   4 -
 fs/nfsd/Kconfig                                    |   1 +
 fs/nfsd/nfs4state.c                                |   2 +-
 fs/nfsd/nfsfh.h                                    |   7 -
 fs/ntfs3/file.c                                    |   1 +
 fs/proc/array.c                                    |  59 ++--
 include/linux/backing-dev.h                        |   1 +
 include/linux/blk-cgroup.h                         |   1 +
 include/linux/filter.h                             |   9 +-
 include/linux/nfs.h                                |  13 +
 include/linux/pci.h                                |   1 +
 include/linux/sched/task_stack.h                   |   2 +
 include/linux/soc/samsung/exynos-chipid.h          |   6 +-
 include/net/bluetooth/bluetooth.h                  |   1 +
 include/net/net_namespace.h                        |   1 +
 include/net/sctp/structs.h                         |   3 +-
 include/net/sock.h                                 |  10 +
 include/scsi/libsas.h                              |  10 +-
 include/uapi/linux/kfd_ioctl.h                     |   2 +
 include/uapi/linux/landlock.h                      |   2 +
 include/xen/interface/xen-mca.h                    |   2 +-
 init/Kconfig                                       |   3 +-
 kernel/bpf/helpers.c                               |  14 +-
 kernel/bpf/syscall.c                               |  17 +-
 kernel/dma/contiguous.c                            |   3 +-
 kernel/locking/lockdep.c                           |   3 +
 kernel/sched/cpufreq_schedutil.c                   |  18 +-
 kernel/trace/ftrace.c                              |   1 +
 kernel/trace/trace_events.c                        |   4 +-
 kernel/trace/trace_events_filter.c                 |   4 +-
 lib/sg_split.c                                     |   2 -
 lib/string.c                                       |  15 +
 lib/test_ubsan.c                                   |  18 +-
 mm/filemap.c                                       |   2 +-
 mm/gup.c                                           |   4 +-
 mm/memory-failure.c                                |  11 +-
 mm/memory.c                                        |   4 +-
 mm/vmscan.c                                        |   2 +-
 net/8021q/vlan_dev.c                               |  31 +-
 net/bluetooth/af_bluetooth.c                       |  22 ++
 net/bluetooth/hci_event.c                          |   5 +-
 net/bluetooth/l2cap_core.c                         |   3 +-
 net/bluetooth/sco.c                                |  18 +-
 net/core/dev.c                                     |   1 +
 net/core/filter.c                                  |  80 +++--
 net/core/net_namespace.c                           |  21 +-
 net/core/page_pool.c                               |   8 +-
 net/core/rtnetlink.c                               |   2 +-
 net/core/selftests.c                               |  18 +-
 net/core/sock.c                                    |  10 -
 net/dsa/tag_8021q.c                                |   2 +-
 net/ethtool/netlink.c                              |   8 +-
 net/ipv6/route.c                                   |   6 +-
 net/mac80211/iface.c                               |   3 +
 net/mac80211/mesh_hwmp.c                           |  14 +-
 net/mctp/af_mctp.c                                 |   3 +
 net/mptcp/sockopt.c                                |  16 +
 net/mptcp/subflow.c                                |  23 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |  10 +-
 net/netfilter/nft_set_pipapo_avx2.c                |   3 +-
 net/openvswitch/actions.c                          |   4 +-
 net/openvswitch/flow_netlink.c                     |   3 +-
 net/phonet/pep.c                                   |  41 ++-
 net/sched/sch_hfsc.c                               |  23 +-
 net/sctp/socket.c                                  |  22 +-
 net/sctp/transport.c                               |   2 +
 net/tipc/link.c                                    |   1 +
 net/tipc/monitor.c                                 |   3 +-
 net/tls/tls_main.c                                 |   6 +
 security/landlock/errata.h                         |  87 +++++
 security/landlock/setup.c                          |  30 ++
 security/landlock/setup.h                          |   3 +
 security/landlock/syscalls.c                       |  22 +-
 sound/pci/hda/hda_intel.c                          |  15 +-
 sound/soc/codecs/lpass-wsa-macro.c                 | 139 +++++---
 sound/soc/codecs/wcd934x.c                         |   2 +-
 sound/soc/fsl/fsl_audmix.c                         |  16 +-
 sound/soc/qcom/qdsp6/q6asm-dai.c                   |  19 +-
 sound/usb/midi.c                                   |  80 ++++-
 sound/virtio/virtio_pcm.c                          |  21 +-
 tools/objtool/check.c                              |   3 +
 tools/power/cpupower/bench/parse.c                 |   4 +
 tools/testing/ktest/ktest.pl                       |   8 +
 tools/testing/selftests/landlock/base_test.c       |  46 ++-
 tools/testing/selftests/mincore/mincore_selftest.c |   3 -
 tools/testing/selftests/ublk/test_stripe_04.sh     |  24 ++
 .../selftests/vm/charge_reserved_hugetlb.sh        |   4 +-
 .../selftests/vm/hugetlb_reparenting_test.sh       |   2 +-
 352 files changed, 3478 insertions(+), 1968 deletions(-)


