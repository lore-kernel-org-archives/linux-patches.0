Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544BA18E348;
	Mon, 28 Oct 2024 06:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097519; cv=none; b=BbKoaRQXJnSwhMzxIB5nR3qTzatYQ0M0y+lCLEpWYs/WjPofqLoU812gJElzFepN3iSJWY2Z+PczPjGqAz2F/hXcvbotT8XCxaC3XM7UruWeAGXiEniyqz2ZMybX9V7q78MlLTeZq8kxEt4rdqoj3xRttbxU01Lc245wRAkn3z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097519; c=relaxed/simple;
	bh=a7Hq0jUV6OXR813XOPJc0objU00AehGLzO0NvjbGvOg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=h8JExvaMLSVcJxmoEbvx6XCEfqt4Ogd0w+rqWiiIgsHCNBlEWgD8xHFQKp8nO3vgOHU38WKH/wM233w8D6CrN3Ir4u6DCxAlo1d+KlondoKExSHRYJA5HeSGTsXgQH174uckjxj0+N5wuZlb5/7kFfUeRRYdaLdtI+BGcwKHZl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJfMNjeS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJfMNjeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DB5C4CEC3;
	Mon, 28 Oct 2024 06:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097519;
	bh=a7Hq0jUV6OXR813XOPJc0objU00AehGLzO0NvjbGvOg=;
	h=From:To:Cc:Subject:Date:From;
	b=NJfMNjeS1oSesxCStZC+yS2PxN2UJ4jomtMb0z+sGNA47Vk1BecKCO8NcjmNeXBpU
	 wTLd/aY55xQiTTH7n4BlFb9CS6rI08nKYaz56GKuZhcc5wT/O47OuyPcnsQfqCU+WE
	 RDgSG41kGGFr/5IhW3d//ta8j/D9co3n8Nll2UBU=
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
Subject: [PATCH 6.6 000/208] 6.6.59-rc1 review
Date: Mon, 28 Oct 2024 07:23:00 +0100
Message-ID: <20241028062306.649733554@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.59-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.59-rc1
X-KernelTest-Deadline: 2024-10-30T06:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.59 release.
There are 208 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 30 Oct 2024 06:22:39 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.59-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.59-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    task_work: make TWA_NMI_CURRENT handling conditional on IRQ_WORK

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: probes: Fix to zero initialize a local variable

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Fix unconditional fence for newer adapters

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Avoid creating fence MR for newer adapters

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix the offset for GenP7 adapters for user applications

Dan Carpenter <dan.carpenter@linaro.org>
    ACPI: PRM: Clean up guid type in struct prm_handler_info

Armin Wolf <W_Armin@gmx.de>
    platform/x86: dell-wmi: Ignore suspend notifications

Zichen Xie <zichenxie0106@gmail.com>
    ASoC: qcom: Fix NULL Dereference in asoc_qcom_lpass_cpu_platform_probe()

Niklas Cassel <cassel@kernel.org>
    ata: libata: Set DID_TIME_OUT for commands that actually timed out

Xinyu Zhang <xizhang@purestorage.com>
    block: fix sanity checks in blk_rq_map_user_bvec

Michel Alex <Alex.Michel@wiedemann-group.com>
    net: phy: dp83822: Fix reset pin definitions

Paul Moore <paul@paul-moore.com>
    selinux: improve error checking in sel_write_load()

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Disable PSR-SU on Parade 08-01 TCON too

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Fix VF namespace also in synthetic NIC NETDEV_REGISTER event

Petr Vaganov <p.vaganov@ideco.ru>
    xfrm: fix one more kernel-infoleak in algo dumping

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Make KASAN usable for variable cpu_vabits

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Enable IRQ if do_ale() triggered in irq-enabled context

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Get correct cores_per_package for SMT systems

José Relvas <josemonsantorelvas@gmail.com>
    ALSA: hda/realtek: Add subwoofer quirk for Acer Predator G9-593

Eric Biggers <ebiggers@google.com>
    ALSA: hda/tas2781: select CRC32 instead of CRC32_SARWATE

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/lam: Disable ADDRESS_MASKING in most cases

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Don't eagerly teardown the vgic on init error

Ilkka Koskinen <ilkka@os.amperecomputing.com>
    KVM: arm64: Fix shift-out-of-bounds bug

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Ignore nCR3[4:0] when loading PDPTEs from memory

Aleksa Sarai <cyphar@cyphar.com>
    openat2: explicitly return -E2BIG for (usize > PAGE_SIZE)

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix kernel bug due to missing clearing of buffer delay flag

Shubham Panwar <shubiisp8@gmail.com>
    ACPI: button: Add DMI quirk for Samsung Galaxy Book2 to fix initial lid detection issue

Koba Ko <kobak@nvidia.com>
    ACPI: PRM: Find EFI_MEMORY_RUNTIME block for PRM handler and context

Christian Heusel <christian@heusel.eu>
    ACPI: resource: Add LG 16T90SP to irq1_level_low_skip_override[]

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Guard against bad data for ATIF ACPI method

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fix zone unusable accounting for freed reserved extent

Yue Haibing <yuehaibing@huawei.com>
    btrfs: fix passing 0 to ERR_PTR in btrfs_search_dir_index_item()

liwei <liwei728@huawei.com>
    cpufreq: CPPC: fix perf_to_khz/khz_to_perf conversion exception

Vincent Guittot <vincent.guittot@linaro.org>
    cpufreq/cppc: Move and rename cppc_cpufreq_{perf_to_khz|khz_to_perf}()

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: Handle kstrdup failures for passwords

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Update default depop procedure

Yang Erkun <yangerkun@huaweicloud.com>
    nfsd: cancel nfsd_shrinker_work using sync mode in nfs4_state_shutdown_net

Yuan Can <yuancan@huawei.com>
    powercap: dtpm_devfreq: Fix error check against dev_pm_qos_add_request()

Andrey Shumilin <shum.sdl@nppct.ru>
    ALSA: firewire-lib: Avoid division by zero in apply_constraint_to_size()

Chancel Liu <chancel.liu@nxp.com>
    ASoC: fsl_micfil: Add a flag to distinguish with different volume control types

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    ASoC: rsnd: Fix probe failure on HiHope boards due to endpoint parsing

Colin Ian King <colin.i.king@gmail.com>
    ASoC: max98388: Fix missing increment of variable slot_found

Binbin Zhou <zhoubinbin@loongson.cn>
    ASoC: loongson: Fix component check failed on FDT systems

Miquel Raynal <miquel.raynal@bootlin.com>
    ASoC: dt-bindings: davinci-mcasp: Fix interrupt properties

Miquel Raynal <miquel.raynal@bootlin.com>
    ASoC: dt-bindings: davinci-mcasp: Fix interrupts property

Shenghao Yang <me@shenghaoyang.info>
    net: dsa: mv88e6xxx: support 4000ps cycle counter period

Shenghao Yang <me@shenghaoyang.info>
    net: dsa: mv88e6xxx: read cycle counter period from hardware

Shenghao Yang <me@shenghaoyang.info>
    net: dsa: mv88e6xxx: group cycle counter coefficients

Jiri Olsa <jolsa@kernel.org>
    bpf,perf: Fix perf_event_detach_bpf_prog error handling

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Fix UAF on iso_sock_timeout

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SCO: Fix UAF on sco_sock_timeout

Jinjie Ruan <ruanjinjie@huawei.com>
    posix-clock: posix-clock: Fix unbalanced locking in pc_clock_settime()

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: avoid unsolicited interrupts

Dmitry Antipov <dmantipov@yandex.ru>
    net: sched: use RCU read-side critical section in taprio_dump()

Dmitry Antipov <dmantipov@yandex.ru>
    net: sched: fix use-after-free in taprio_change()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net/sched: act_api: deny mismatched skip_sw/skip_hw flags for actions created by classifiers

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Remove MEM_UNINIT from skb/xdp MTU helpers

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix overloading of MEM_UNINIT's meaning

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Add MEM_WRITE attribute

Andrei Matei <andreimatei1@gmail.com>
    bpf: Simplify checking size of helper accesses

Oliver Neukum <oneukum@suse.com>
    net: usb: usbnet: fix name regression

Eric Dumazet <edumazet@google.com>
    net: fix races in netdev_tx_sent_queue()/dev_watchdog()

Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
    net/sched: adjust device watchdog timer to detect stopped queue at right time

Lin Ma <linma@zju.edu.cn>
    net: wwan: fix global oob in wwan_rtnl_policy

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: xtables: fix typo causing some targets not to load on IPv6

Aleksandr Mishin <amishin@t-argos.ru>
    fsl/fman: Fix refcount handling of fman-related devices

Aleksandr Mishin <amishin@t-argos.ru>
    fsl/fman: Save device references taken in mac_probe()

Peter Rashleigh <peter@rashleigh.ca>
    net: dsa: mv88e6xxx: Fix error when setting port policy on mv88e6393x

Aleksandr Mishin <amishin@t-argos.ru>
    octeon_ep: Add SKB allocation failures handling in __octep_oq_process_rx()

Aleksandr Mishin <amishin@t-argos.ru>
    octeon_ep: Implement helper for iterating packets in Rx queue

Jakub Boehm <boehm.jakub@gmail.com>
    net: plip: fix break; causing plip to never transmit

Wang Hai <wanghai38@huawei.com>
    be2net: fix potential memory leak in be_xmit()

Wang Hai <wanghai38@huawei.com>
    net/sun3_82586: fix potential memory leak in sun3_82586_send_packet()

Florian Westphal <fw@strlen.de>
    netfilter: bpf: must hold reference on net namespace

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: validate new SA's prefixlen using SA family when sel.family is unset

Antony Antony <antony.antony@secunet.com>
    xfrm: Add Direction to the SA in or out

Eyal Birger <eyal.birger@gmail.com>
    xfrm: respect ip protocols rules criteria when performing dst lookups

Eyal Birger <eyal.birger@gmail.com>
    xfrm: extract dst lookup parameters into a struct

Leo Yan <leo.yan@arm.com>
    tracing: Consider the NULL character when validating the event length

Mikel Rychliski <mikel@mikelr.com>
    tracing/probes: Fix MAX_TRACE_ARGS limit handling

Dave Kleikamp <dave.kleikamp@oracle.com>
    jfs: Fix sanity check in dbMount

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    LoongArch: Don't crash in stack_top() for tasks without vDSO

Crag Wang <crag_wang@dell.com>
    platform/x86: dell-sysman: add support for alienware products

Pali Rohár <pali@kernel.org>
    cifs: Validate content of NFS reparse point buffer

Alexey Klimov <alexey.klimov@linaro.org>
    ASoC: qcom: sm8250: add qrb4210-rb2-sndcard compatible string

Gianfranco Trad <gianf.trad@gmail.com>
    udf: fix uninit-value use in udf_get_fileshortad

Zhao Mengmeng <zhaomengmeng@kylinos.cn>
    udf: refactor inode_bmap() to handle error

Zhao Mengmeng <zhaomengmeng@kylinos.cn>
    udf: refactor udf_next_aext() to handle error

Zhao Mengmeng <zhaomengmeng@kylinos.cn>
    udf: refactor udf_current_aext() to handle error

Mark Rutland <mark.rutland@arm.com>
    arm64: Force position-independent veneers

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_sai: Enable 'FIFO continue on error' FCONT bit

Alexey Klimov <alexey.klimov@linaro.org>
    ASoC: codecs: lpass-rx-macro: add missing CDC_RX_BCL_VBAT_RF_PROC2 to default regs values

David Lawrence Glanzman <davidglanzman@yahoo.com>
    ASoC: amd: yc: Add quirk for HP Dragonfly pro one

Hans de Goede <hdegoede@redhat.com>
    drm/vboxvideo: Replace fake VLA at end of vbva_mouse_pointer_shape with real VLA

Mateusz Guzik <mjguzik@gmail.com>
    exec: don't WARN for racy path_noexec check

Qiao Ma <mqaio@linux.alibaba.com>
    uprobe: avoid out-of-bounds memory access of fetching args

Andrii Nakryiko <andrii@kernel.org>
    uprobes: prevent mutex_lock() under rcu_read_lock()

Andrii Nakryiko <andrii@kernel.org>
    uprobes: prepare uprobe args buffer lazily

Andrii Nakryiko <andrii@kernel.org>
    uprobes: encapsulate preparation of uprobe args buffer

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Support $argN in return probe (kprobe and fprobe)

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: cleanup: Set trace_probe::nr_args at trace_probe_init

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/fprobe-event: cleanup: Fix a wrong comment in fprobe event

Roger Quadros <rogerq@kernel.org>
    usb: dwc3: core: Fix system suspend on TI AM62 platforms

Frank Li <Frank.Li@nxp.com>
    XHCI: Separate PORT and CAPs macros into dedicated file

Kevin Groeneveld <kgroeneveld@lenbrook.com>
    usb: gadget: f_uac2: fix return value for UAC2_ATTRIBUTE_STRING store

John Keeping <jkeeping@inmusicbrands.com>
    usb: gadget: f_uac2: fix non-newline-terminated function name

Lee Jones <lee@kernel.org>
    usb: gadget: f_uac2: Replace snprintf() with the safer scnprintf() variant

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: honor usb transfer size boundaries.

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    xhci: dbgtty: use kfifo from tty_port struct

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    xhci: dbgtty: remove kfifo_out() wrapper

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: adc: ti-lmp92064: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

Yang Shi <yang@os.amperecomputing.com>
    mm: khugepaged: fix the arguments order in khugepaged_collapse_file trace point

Matthew Wilcox (Oracle) <willy@infradead.org>
    khugepaged: remove hpage from collapse_file()

Matthew Wilcox (Oracle) <willy@infradead.org>
    khugepaged: convert alloc_charge_hpage to alloc_charge_folio

Matthew Wilcox (Oracle) <willy@infradead.org>
    khugepaged: inline hpage_collapse_alloc_folio()

Matthew Wilcox (Oracle) <willy@infradead.org>
    mm/khugepaged: use a folio more in collapse_file()

Matthew Wilcox (Oracle) <willy@infradead.org>
    mm: convert collapse_huge_page() to use a folio

Vishal Moola (Oracle) <vishal.moola@gmail.com>
    mm/khugepaged: convert alloc_charge_hpage() to use folios

Josh Poimboeuf <jpoimboe@kernel.org>
    cdrom: Avoid barrier_nospec() in cdrom_ioctl_media_changed()

Jordan Rome <linux@jordanrome.com>
    bpf: Fix iter/task tid filtering

Maurizio Lombardi <mlombard@redhat.com>
    nvme-pci: fix race condition between reset and nvme_dev_disable()

William Butler <wab@google.com>
    nvme-pci: set doorbell config before unquiescing

Andrea Parri <parri.andrea@gmail.com>
    riscv, bpf: Make BPF_CMPXCHG fully ordered

Michal Luczaj <mhal@rbox.co>
    bpf, vsock: Drop static vsock_bpf_prot initialization

Michal Luczaj <mhal@rbox.co>
    vsock: Update msg_count on read_skb()

Michal Luczaj <mhal@rbox.co>
    vsock: Update rx_bytes on read_skb()

Michal Luczaj <mhal@rbox.co>
    bpf, sockmap: SK_DROP on attempted redirects of unsupported af_vsock

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5: Unregister notifier on eswitch init failure

Shay Drory <shayd@nvidia.com>
    net/mlx5: Fix command bitmask initialization

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Check for invalid vector index on EQ creation

Daniel Borkmann <daniel@iogearbox.net>
    vmxnet3: Fix packet corruption in vmxnet3_xdp_xmit_frame

Ye Bin <yebin10@huawei.com>
    Bluetooth: bnep: fix wild-memory-access in proto_unregister

Tyrone Wu <wudevelops@gmail.com>
    bpf: Fix link info netfilter flags to populate defrag flag

Heiko Carstens <hca@linux.ibm.com>
    s390: Initialize psw mask in perf_arch_fetch_caller_regs()

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    usb: typec: altmode should keep reference to parent

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix OOBs when building SMB2_IOCTL request

Su Hui <suhui@nfschina.com>
    smb: client: fix possible double free in smb2_set_ea()

Wang Hai <wanghai38@huawei.com>
    scsi: target: core: Fix null-ptr-deref in target_alloc_device()

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    net: ravb: Only advertise Rx/Tx timestamps if hardware supports it

Gal Pressman <gal@nvidia.com>
    ravb: Remove setting of RX software timestamp

Eric Dumazet <edumazet@google.com>
    genetlink: hold RCU in genlmsg_mcast()

Peter Rashleigh <peter@rashleigh.ca>
    net: dsa: mv88e6xxx: Fix the max_vid definition for the MV88E6361

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp/dccp: Don't use timer_pending() in reqsk_queue_unlink().

Wang Hai <wanghai38@huawei.com>
    net: bcmasp: fix potential memory leak in bcmasp_xmit()

Jessica Zhang <quic_jesszhan@quicinc.com>
    drm/msm/dpu: don't always program merge_3d block

Fabrizio Castro <fabrizio.castro.jz@renesas.com>
    irqchip/renesas-rzg2l: Fix missing put_device

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    irqchip/renesas-rzg2l: Add support for suspend to RAM

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    irqchip/renesas-rzg2l: Document structure members

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    irqchip/renesas-rzg2l: Align struct member names to tabs

Wang Hai <wanghai38@huawei.com>
    net: systemport: fix potential memory leak in bcm_sysport_xmit()

Dimitar Kanaliev <dimitar.kanaliev@siteground.com>
    bpf: Fix truncation bug in coerce_reg_to_size_sx()

Wang Hai <wanghai38@huawei.com>
    net: xilinx: axienet: fix potential memory leak in axienet_start_xmit()

Li RongQing <lirongqing@baidu.com>
    net/smc: Fix searching in list of known pnetids in smc_pnet_add_pnetid

Wang Hai <wanghai38@huawei.com>
    net: ethernet: aeroflex: fix potential memory leak in greth_start_xmit_gbit()

Eric Dumazet <edumazet@google.com>
    netdevsim: use cond_resched() in nsim_dev_trap_report_work()

Sabrina Dubroca <sd@queasysnail.net>
    macsec: don't increment counters for an unrelated SA

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/amdgpu: Fix double unlock in amdgpu_mes_add_ring

Colin Ian King <colin.i.king@gmail.com>
    octeontx2-af: Fix potential integer overflows on integer shifts

Paritosh Dixit <paritoshd@nvidia.com>
    net: stmmac: dwmac-tegra: Fix link bring-up sequence

Oliver Neukum <oneukum@suse.com>
    net: usb: usbnet: fix race in probe failure

Kai Shen <KaiShen@linux.alibaba.com>
    net/smc: Fix memory leak when using percpu refs

Justin Chen <justin.chen@broadcom.com>
    firmware: arm_scmi: Queue in scmi layer for mailbox implementation

Douglas Anderson <dianders@chromium.org>
    drm/msm: Allocate memory for disp snapshot with kvzalloc()

Douglas Anderson <dianders@chromium.org>
    drm/msm: Avoid NULL dereference in msm_disp_state_print_regs()

Jonathan Marek <jonathan@marek.ca>
    drm/msm/dsi: fix 32-bit signed integer extension in pclk_rate calculation

Jonathan Marek <jonathan@marek.ca>
    drm/msm/dsi: improve/fix dsc pclk calculation

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: check for overflow in _dpu_crtc_setup_lm_bounds()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: make sure phys resources are properly initialized

Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>
    accel/qaic: Fix the for loop used to walk SG table

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Fix the GID table length

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Update the BAR offsets

Bhargava Chenna Marreddy <bhargava.marreddy@broadcom.com>
    RDMA/bnxt_re: Fix a bug while setting up Level-2 PBL pages

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Return more meaningful error

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Fix out of bound check

Abhishek Mohapatra <abhishek.mohapatra@broadcom.com>
    RDMA/bnxt_re: Fix the max CQ WQEs for older adapters

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Support new 5760X P7 devices

Xin Long <lucien.xin@gmail.com>
    ipv4: give an IPv4 dev to blackhole_netdev

Bart Van Assche <bvanassche@acm.org>
    RDMA/srpt: Make slab cache names unique

Alexander Zubkov <green@qrator.net>
    RDMA/irdma: Fix misspelling of "accept*"

Anumula Murali Mohan Reddy <anumula@chelsio.com>
    RDMA/cxgb4: Fix RDMA_CM_EVENT_UNREACHABLE error for iWARP

Su Hui <suhui@nfschina.com>
    firmware: arm_scmi: Fix the double free in scmi_debugfs_common_setup()

Murad Masimov <m.masimov@maxima.ru>
    ALSA: hda/cs8409: Fix possible NULL dereference

Waiman Long <longman@redhat.com>
    sched/core: Disable page allocation in task_tick_mm_cid()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    task_work: Add TWA_NMI_CURRENT as an additional notify mode.

Tony Ambardar <tony.ambardar@gmail.com>
    selftests/bpf: Fix cross-compiling urandom_read

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Handle possible ENOMEM in vmw_stdu_connector_atomic_check

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: frequency: admv4420: fix missing select REMAP_SPI in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: frequency: {admv4420,adrf6780}: format Kconfig entries

Toke Høiland-Jørgensen <toke@redhat.com>
    bpf: fix kfunc btf caching for modules

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Handle PCI error codes other than 0x3a

Tyrone Wu <wudevelops@gmail.com>
    selftests/bpf: fix perf_event link info name_len assertion

Jiri Olsa <jolsa@kernel.org>
    selftests/bpf: Add cookies check for perf_event fill_link_info test

Jiri Olsa <jolsa@kernel.org>
    selftests/bpf: Use bpf_link__destroy in fill_link_info tests

Tyrone Wu <wudevelops@gmail.com>
    bpf: fix unpopulated name_len field in perf_event link info

Jiri Olsa <jolsa@kernel.org>
    bpf: Add cookie to perf_event bpf_link_info records

Jiri Olsa <jolsa@kernel.org>
    bpf: Add missed value to kprobe perf link info

Florian Klink <flokli@flokli.de>
    ARM: dts: bcm2837-rpi-cm3-io3: Fix HDMI hpd-gpio pin

Martin Kletzander <nert.pinx@gmail.com>
    x86/resctrl: Avoid overflow in MB settings in bw_validate()

Anumula Murali Mohan Reddy <anumula@chelsio.com>
    RDMA/core: Fix ENODEV error for iWARP test over vlan

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Add a check for memory allocation

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    RDMA/bnxt_re: Fix incorrect AVID type in WQE structure

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Fix a possible memory leak

Jiri Olsa <jolsa@kernel.org>
    bpf: Fix memory leak in bpf_core_apply

Timo Grautstueck <timo.grautstueck@web.de>
    lib/Kconfig.debug: fix grammar in RUST_BUILD_ASSERT_ALLOW

Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
    cpufreq/amd-pstate: Fix amd_pstate mode switch on shared memory systems

Florian Kauer <florian.kauer@linutronix.de>
    bpf: devmap: provide rxq after redirect

Toke Høiland-Jørgensen <toke@redhat.com>
    bpf: Make sure internal and UAPI bpf_redirect flags don't overlap

Mikhail Lobanov <m.lobanov@rosalinux.ru>
    iio: accel: bma400: Fix uninitialized variable field_value in tap event handling.


-------------

Diffstat:

 .../bindings/sound/davinci-mcasp-audio.yaml        |  18 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/broadcom/bcm2837-rpi-cm3-io3.dts |   2 +-
 arch/arm64/Makefile                                |   2 +-
 arch/arm64/kvm/arm.c                               |   3 +
 arch/arm64/kvm/sys_regs.c                          |   2 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |   6 +-
 arch/loongarch/include/asm/bootinfo.h              |   4 +
 arch/loongarch/include/asm/kasan.h                 |   2 +-
 arch/loongarch/kernel/process.c                    |  14 +-
 arch/loongarch/kernel/setup.c                      |   3 +-
 arch/loongarch/kernel/traps.c                      |   5 +
 arch/riscv/net/bpf_jit_comp64.c                    |   4 +-
 arch/s390/include/asm/perf_event.h                 |   1 +
 arch/s390/pci/pci_event.c                          |  17 +-
 arch/x86/Kconfig                                   |   1 +
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c          |  23 +-
 arch/x86/kvm/svm/nested.c                          |   6 +-
 block/blk-map.c                                    |   4 +-
 drivers/accel/qaic/qaic_control.c                  |   2 +-
 drivers/accel/qaic/qaic_data.c                     |   6 +-
 drivers/acpi/button.c                              |  11 +
 drivers/acpi/cppc_acpi.c                           | 116 +++++++++
 drivers/acpi/prmt.c                                |  29 ++-
 drivers/acpi/resource.c                            |   7 +
 drivers/ata/libata-eh.c                            |   1 +
 drivers/cdrom/cdrom.c                              |   2 +-
 drivers/cpufreq/amd-pstate.c                       |  10 +
 drivers/cpufreq/cppc_cpufreq.c                     | 139 ++---------
 drivers/firmware/arm_scmi/driver.c                 |   4 +-
 drivers/firmware/arm_scmi/mailbox.c                |  32 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |  15 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c            |   5 +-
 .../drm/amd/display/modules/power/power_helpers.c  |   2 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c           |  17 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |   9 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c   |   2 +-
 drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c  |  19 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   4 +-
 drivers/gpu/drm/vboxvideo/hgsmi_base.c             |  10 +-
 drivers/gpu/drm/vboxvideo/vboxvideo.h              |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c               |   4 +
 drivers/iio/accel/bma400_core.c                    |   3 +-
 drivers/iio/adc/Kconfig                            |   2 +
 drivers/iio/frequency/Kconfig                      |  31 +--
 drivers/infiniband/core/addr.c                     |   2 +
 drivers/infiniband/hw/bnxt_re/hw_counters.c        |   6 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |  48 ++--
 drivers/infiniband/hw/bnxt_re/main.c               |  42 ++--
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   4 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |   2 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |   4 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |  23 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.h          |  20 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.c           |  22 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.h           |   1 +
 drivers/infiniband/hw/cxgb4/cm.c                   |   9 +-
 drivers/infiniband/hw/irdma/cm.c                   |   2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  80 ++++++-
 drivers/irqchip/irq-renesas-rzg2l.c                |  94 ++++++--
 drivers/net/dsa/mv88e6xxx/chip.c                   |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.h                   |   6 +-
 drivers/net/dsa/mv88e6xxx/port.c                   |   1 +
 drivers/net/dsa/mv88e6xxx/ptp.c                    | 108 ++++++---
 drivers/net/ethernet/aeroflex/greth.c              |   3 +-
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c   |   1 +
 drivers/net/ethernet/broadcom/bcmsysport.c         |   1 +
 drivers/net/ethernet/emulex/benet/be_main.c        |  10 +-
 drivers/net/ethernet/freescale/fman/mac.c          |  68 ++++--
 drivers/net/ethernet/freescale/fman/mac.h          |   6 +-
 drivers/net/ethernet/i825xx/sun3_82586.c           |   1 +
 drivers/net/ethernet/marvell/octeon_ep/octep_rx.c  |  82 +++++--
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   5 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   4 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  25 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c  |  18 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   2 +
 drivers/net/hyperv/netvsc_drv.c                    |  30 +++
 drivers/net/macsec.c                               |  18 --
 drivers/net/netdevsim/dev.c                        |  15 +-
 drivers/net/phy/dp83822.c                          |   4 +-
 drivers/net/plip/plip.c                            |   2 +-
 drivers/net/usb/usbnet.c                           |   4 +-
 drivers/net/vmxnet3/vmxnet3_xdp.c                  |   2 +-
 drivers/net/wwan/wwan_core.c                       |   2 +-
 drivers/nvme/host/pci.c                            |  21 +-
 drivers/platform/x86/dell/dell-wmi-base.c          |   9 +
 drivers/platform/x86/dell/dell-wmi-sysman/sysman.c |   1 +
 drivers/powercap/dtpm_devfreq.c                    |   2 +-
 drivers/target/target_core_device.c                |   2 +-
 drivers/target/target_core_user.c                  |   2 +-
 drivers/usb/dwc3/core.c                            |  19 ++
 drivers/usb/dwc3/core.h                            |   3 +
 drivers/usb/gadget/function/f_uac2.c               |  13 +-
 drivers/usb/host/xhci-caps.h                       |  85 +++++++
 drivers/usb/host/xhci-dbgcap.h                     |   2 +-
 drivers/usb/host/xhci-dbgtty.c                     |  71 ++++--
 drivers/usb/host/xhci-port.h                       | 176 ++++++++++++++
 drivers/usb/host/xhci.h                            | 262 +--------------------
 drivers/usb/typec/class.c                          |   3 +
 fs/btrfs/block-group.c                             |   2 +
 fs/btrfs/dir-item.c                                |   4 +-
 fs/btrfs/inode.c                                   |   7 +-
 fs/exec.c                                          |  21 +-
 fs/jfs/jfs_dmap.c                                  |   2 +-
 fs/nfsd/nfs4state.c                                |   2 +-
 fs/nilfs2/page.c                                   |   6 +-
 fs/open.c                                          |   2 +
 fs/smb/client/fs_context.c                         |   7 +
 fs/smb/client/reparse.c                            |  23 ++
 fs/smb/client/smb2ops.c                            |   3 +-
 fs/smb/client/smb2pdu.c                            |   9 +
 fs/udf/balloc.c                                    |  38 ++-
 fs/udf/directory.c                                 |  23 +-
 fs/udf/inode.c                                     | 202 ++++++++++------
 fs/udf/partition.c                                 |   6 +-
 fs/udf/super.c                                     |   3 +-
 fs/udf/truncate.c                                  |  43 +++-
 fs/udf/udfdecl.h                                   |  15 +-
 include/acpi/cppc_acpi.h                           |   2 +
 include/linux/bpf.h                                |  14 +-
 include/linux/memcontrol.h                         |  14 --
 include/linux/netdevice.h                          |  12 +
 include/linux/task_work.h                          |   6 +-
 include/linux/trace_events.h                       |   6 +-
 include/net/bluetooth/bluetooth.h                  |   1 +
 include/net/genetlink.h                            |   3 +-
 include/net/sock.h                                 |   5 +
 include/net/xfrm.h                                 |  29 ++-
 include/trace/events/huge_memory.h                 |  10 +-
 include/uapi/linux/bpf.h                           |  20 +-
 include/uapi/linux/xfrm.h                          |   6 +
 kernel/bpf/btf.c                                   |   1 +
 kernel/bpf/devmap.c                                |  11 +-
 kernel/bpf/helpers.c                               |  10 +-
 kernel/bpf/ringbuf.c                               |   2 +-
 kernel/bpf/syscall.c                               |  49 ++--
 kernel/bpf/task_iter.c                             |   2 +-
 kernel/bpf/verifier.c                              |  99 ++++----
 kernel/sched/core.c                                |   4 +-
 kernel/task_work.c                                 |  41 +++-
 kernel/time/posix-clock.c                          |   6 +-
 kernel/trace/bpf_trace.c                           |  11 +-
 kernel/trace/trace.c                               |   1 +
 kernel/trace/trace_eprobe.c                        |  15 +-
 kernel/trace/trace_fprobe.c                        |  65 +++--
 kernel/trace/trace_kprobe.c                        |  78 ++++--
 kernel/trace/trace_probe.c                         | 189 +++++++++++++--
 kernel/trace/trace_probe.h                         |  30 ++-
 kernel/trace/trace_probe_tmpl.h                    |  10 +-
 kernel/trace/trace_uprobe.c                        | 114 +++++----
 lib/Kconfig.debug                                  |   2 +-
 mm/khugepaged.c                                    | 127 +++++-----
 net/bluetooth/af_bluetooth.c                       |  22 ++
 net/bluetooth/bnep/core.c                          |   3 +-
 net/bluetooth/iso.c                                |  18 +-
 net/bluetooth/sco.c                                |  18 +-
 net/core/filter.c                                  |  50 ++--
 net/core/sock_map.c                                |   8 +
 net/ipv4/devinet.c                                 |  35 ++-
 net/ipv4/inet_connection_sock.c                    |  21 +-
 net/ipv4/xfrm4_policy.c                            |  38 ++-
 net/ipv6/xfrm6_policy.c                            |  31 +--
 net/l2tp/l2tp_netlink.c                            |   4 +-
 net/netfilter/nf_bpf_link.c                        |   7 +-
 net/netfilter/xt_NFLOG.c                           |   2 +-
 net/netfilter/xt_TRACE.c                           |   1 +
 net/netfilter/xt_mark.c                            |   2 +-
 net/netlink/genetlink.c                            |  28 +--
 net/sched/act_api.c                                |  23 +-
 net/sched/sch_generic.c                            |  17 +-
 net/sched/sch_taprio.c                             |  21 +-
 net/smc/smc_pnet.c                                 |   2 +-
 net/smc/smc_wr.c                                   |   6 +-
 net/vmw_vsock/virtio_transport_common.c            |  14 +-
 net/vmw_vsock/vsock_bpf.c                          |   8 -
 net/wireless/nl80211.c                             |   8 +-
 net/xfrm/xfrm_compat.c                             |   7 +-
 net/xfrm/xfrm_device.c                             |  17 +-
 net/xfrm/xfrm_policy.c                             |  50 +++-
 net/xfrm/xfrm_replay.c                             |   3 +-
 net/xfrm/xfrm_state.c                              |   8 +
 net/xfrm/xfrm_user.c                               | 148 +++++++++++-
 security/selinux/selinuxfs.c                       |  30 +--
 sound/firewire/amdtp-stream.c                      |   3 +
 sound/pci/hda/Kconfig                              |   2 +-
 sound/pci/hda/patch_cs8409.c                       |   5 +-
 sound/pci/hda/patch_realtek.c                      |  48 ++--
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/lpass-rx-macro.c                  |   2 +-
 sound/soc/codecs/max98388.c                        |   1 +
 sound/soc/fsl/fsl_micfil.c                         |  43 +++-
 sound/soc/fsl/fsl_sai.c                            |   5 +-
 sound/soc/fsl/fsl_sai.h                            |   1 +
 sound/soc/loongson/loongson_card.c                 |   1 +
 sound/soc/qcom/lpass-cpu.c                         |   2 +
 sound/soc/qcom/sm8250.c                            |   1 +
 sound/soc/sh/rcar/core.c                           |   7 +-
 tools/include/uapi/linux/bpf.h                     |   7 +
 tools/testing/selftests/bpf/Makefile               |   2 +-
 .../selftests/bpf/prog_tests/fill_link_info.c      |  69 ++++--
 .../bpf/progs/verifier_helper_value_access.c       |   8 +-
 .../selftests/bpf/progs/verifier_raw_stack.c       |   2 +-
 .../ftrace/test.d/dynevent/fprobe_syntax_errors.tc |   4 +
 .../ftrace/test.d/kprobe/kprobe_syntax_errors.tc   |   2 +
 208 files changed, 2889 insertions(+), 1471 deletions(-)


