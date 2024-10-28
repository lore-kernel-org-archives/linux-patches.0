Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8179D18F2DB;
	Mon, 28 Oct 2024 06:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097208; cv=none; b=r4Lz4ZqmRH0TD99Vdam26IR2JWInykuN46rq5eGO1Fncl2x/lb5QBexlWqltb1LFsG1Jxnx/kQZiMTByn/8f2YHYrmQEIJUkZQN22bbb1qou8tBVhm3MMUxr6TgKUyvRC5OKU+XDjUJLEQw3/picTv6RkYHdP8dZS7H868a0BqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097208; c=relaxed/simple;
	bh=PC4oTikwQ/csEFmhcNaGI6vl3DJYSsODI5WBj028GN8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sHfQUvj38mviksRqdioDiYkgdlIScVMKhPQWwMyKr6tPMaERLcLtSRBjvzfw0AjH9So3/OgIbDZcDf4zZrgTv7thH4Cb6f5ribgPl5fN4Z4PZD6selp+LUvt+E2plBx18lYgnLx5aF5U45xoPtmY+xH9DioCJI9JzRmXSRkW1Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BskVJBc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BskVJBc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BF3C4CEEF;
	Mon, 28 Oct 2024 06:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097208;
	bh=PC4oTikwQ/csEFmhcNaGI6vl3DJYSsODI5WBj028GN8=;
	h=From:To:Cc:Subject:Date:From;
	b=BskVJBc8SiCvMek7n6tBB/eI/twKRSTl70Lk7Uwwq6YjylM/3HfaUlNloBM1hvBIN
	 la8fQHvVVnAfbDRO/uMMP9+H/DEvrDnBjKriZckotSDgRIOnRx/jbZ5fIXSei058gL
	 OxcltqirvZaoPQw1bHc/0ND4x4eevlhkr6bDK534=
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
Subject: [PATCH 6.1 000/137] 6.1.115-rc1 review
Date: Mon, 28 Oct 2024 07:23:57 +0100
Message-ID: <20241028062258.708872330@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.115-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.115-rc1
X-KernelTest-Deadline: 2024-10-30T06:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.115 release.
There are 137 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 30 Oct 2024 06:22:39 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.115-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.115-rc1

junhua huang <huang.junhua@zte.com.cn>
    arm64/uprobes: change the uprobe_opcode_t typedef to fix the sparse warning

Dan Carpenter <dan.carpenter@linaro.org>
    ACPI: PRM: Clean up guid type in struct prm_handler_info

Armin Wolf <W_Armin@gmx.de>
    platform/x86: dell-wmi: Ignore suspend notifications

Zichen Xie <zichenxie0106@gmail.com>
    ASoC: qcom: Fix NULL Dereference in asoc_qcom_lpass_cpu_platform_probe()

Xinyu Zhang <xizhang@purestorage.com>
    block: fix sanity checks in blk_rq_map_user_bvec

Michel Alex <Alex.Michel@wiedemann-group.com>
    net: phy: dp83822: Fix reset pin definitions

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    serial: protect uart_port_dtr_rts() in uart_shutdown() too

Paul Moore <paul@paul-moore.com>
    selinux: improve error checking in sel_write_load()

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Disable PSR-SU on Parade 08-01 TCON too

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Fix VF namespace also in synthetic NIC NETDEV_REGISTER event

Petr Vaganov <p.vaganov@ideco.ru>
    xfrm: fix one more kernel-infoleak in algo dumping

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Get correct cores_per_package for SMT systems

José Relvas <josemonsantorelvas@gmail.com>
    ALSA: hda/realtek: Add subwoofer quirk for Acer Predator G9-593

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Don't eagerly teardown the vgic on init error

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

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Update default depop procedure

Yuan Can <yuancan@huawei.com>
    powercap: dtpm_devfreq: Fix error check against dev_pm_qos_add_request()

Andrey Shumilin <shum.sdl@nppct.ru>
    ALSA: firewire-lib: Avoid division by zero in apply_constraint_to_size()

Miquel Raynal <miquel.raynal@bootlin.com>
    ASoC: dt-bindings: davinci-mcasp: Fix interrupt properties

Miquel Raynal <miquel.raynal@bootlin.com>
    ASoC: dt-bindings: davinci-mcasp: Fix interrupts property

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
    net: sched: fix use-after-free in taprio_change()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net/sched: act_api: deny mismatched skip_sw/skip_hw flags for actions created by classifiers

Oliver Neukum <oneukum@suse.com>
    net: usb: usbnet: fix name regression

Eric Dumazet <edumazet@google.com>
    net: fix races in netdev_tx_sent_queue()/dev_watchdog()

Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
    net/sched: adjust device watchdog timer to detect stopped queue at right time

Jakub Kicinski <kuba@kernel.org>
    net: provide macros for commonly copied lockless queue stop/wake code

Jakub Kicinski <kuba@kernel.org>
    docs: net: reformat driver.rst from a list to sections

Lin Ma <linma@zju.edu.cn>
    net: wwan: fix global oob in wwan_rtnl_policy

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: xtables: fix typo causing some targets not to load on IPv6

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

Eyal Birger <eyal.birger@gmail.com>
    xfrm: respect ip protocols rules criteria when performing dst lookups

Eyal Birger <eyal.birger@gmail.com>
    xfrm: extract dst lookup parameters into a struct

Leo Yan <leo.yan@arm.com>
    tracing: Consider the NULL character when validating the event length

Dave Kleikamp <dave.kleikamp@oracle.com>
    jfs: Fix sanity check in dbMount

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    LoongArch: Don't crash in stack_top() for tasks without vDSO

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Add support to clone a time namespace

Crag Wang <crag_wang@dell.com>
    platform/x86: dell-sysman: add support for alienware products

Alexey Klimov <alexey.klimov@linaro.org>
    ASoC: qcom: sm8250: add qrb4210-rb2-sndcard compatible string

Gianfranco Trad <gianf.trad@gmail.com>
    udf: fix uninit-value use in udf_get_fileshortad

Zhao Mengmeng <zhaomengmeng@kylinos.cn>
    udf: refactor udf_current_aext() to handle error

Mark Rutland <mark.rutland@arm.com>
    arm64: Force position-independent veneers

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_sai: Enable 'FIFO continue on error' FCONT bit

Alexey Klimov <alexey.klimov@linaro.org>
    ASoC: codecs: lpass-rx-macro: add missing CDC_RX_BCL_VBAT_RF_PROC2 to default regs values

Hans de Goede <hdegoede@redhat.com>
    drm/vboxvideo: Replace fake VLA at end of vbva_mouse_pointer_shape with real VLA

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Add more attributes checks in mi_enum_attr()

Mateusz Guzik <mjguzik@gmail.com>
    exec: don't WARN for racy path_noexec check

Yu Kuai <yukuai3@huawei.com>
    block, bfq: fix procress reference leakage for bfqq in merge chain

Marek Vasut <marex@denx.de>
    serial: imx: Update mctrl old_status on RTSD interrupt

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: Make uart_handle_cts_change() status param bool active

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    tty/serial: Make ->dcd_change()+uart_handle_dcd_change() status bool active

Roger Quadros <rogerq@kernel.org>
    usb: dwc3: core: Fix system suspend on TI AM62 platforms

Frank Li <Frank.Li@nxp.com>
    XHCI: Separate PORT and CAPs macros into dedicated file

Elson Roy Serrao <quic_eserrao@quicinc.com>
    usb: gadget: Add function wakeup support

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

Mark Rutland <mark.rutland@arm.com>
    arm64: probes: Fix uprobes for big-endian kernels

junhua huang <huang.junhua@zte.com.cn>
    arm64:uprobe fix the uprobe SWBP_INSN in big-endian

Jordan Rome <linux@jordanrome.com>
    bpf: Fix iter/task tid filtering

Andrea Parri <parri.andrea@gmail.com>
    riscv, bpf: Make BPF_CMPXCHG fully ordered

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5: Unregister notifier on eswitch init failure

Shay Drory <shayd@nvidia.com>
    net/mlx5: Fix command bitmask initialization

Shay Drory <shayd@nvidia.com>
    net/mlx5: split mlx5_cmd_init() to probe and reload routines

Shay Drory <shayd@nvidia.com>
    net/mlx5: Remove redundant cmdif revision check

Ye Bin <yebin10@huawei.com>
    Bluetooth: bnep: fix wild-memory-access in proto_unregister

Heiko Carstens <hca@linux.ibm.com>
    s390: Initialize psw mask in perf_arch_fetch_caller_regs()

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    usb: typec: altmode should keep reference to parent

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix OOBs when building SMB2_IOCTL request

Wang Hai <wanghai38@huawei.com>
    scsi: target: core: Fix null-ptr-deref in target_alloc_device()

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    net: ravb: Only advertise Rx/Tx timestamps if hardware supports it

Gal Pressman <gal@nvidia.com>
    ravb: Remove setting of RX software timestamp

Eric Dumazet <edumazet@google.com>
    genetlink: hold RCU in genlmsg_mcast()

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp/dccp: Don't use timer_pending() in reqsk_queue_unlink().

Jessica Zhang <quic_jesszhan@quicinc.com>
    drm/msm/dpu: don't always program merge_3d block

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dpu: Wire up DSC mask for active CTL configuration

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

Oliver Neukum <oneukum@suse.com>
    net: usb: usbnet: fix race in probe failure

Douglas Anderson <dianders@chromium.org>
    drm/msm: Allocate memory for disp snapshot with kvzalloc()

Douglas Anderson <dianders@chromium.org>
    drm/msm: Avoid NULL dereference in msm_disp_state_print_regs()

Jonathan Marek <jonathan@marek.ca>
    drm/msm/dsi: fix 32-bit signed integer extension in pclk_rate calculation

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: make sure phys resources are properly initialized

Bhargava Chenna Marreddy <bhargava.marreddy@broadcom.com>
    RDMA/bnxt_re: Fix a bug while setting up Level-2 PBL pages

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Return more meaningful error

Xin Long <lucien.xin@gmail.com>
    ipv4: give an IPv4 dev to blackhole_netdev

Bart Van Assche <bvanassche@acm.org>
    RDMA/srpt: Make slab cache names unique

Alexander Zubkov <green@qrator.net>
    RDMA/irdma: Fix misspelling of "accept*"

Anumula Murali Mohan Reddy <anumula@chelsio.com>
    RDMA/cxgb4: Fix RDMA_CM_EVENT_UNREACHABLE error for iWARP

Murad Masimov <m.masimov@maxima.ru>
    ALSA: hda/cs8409: Fix possible NULL dereference

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

Florian Klink <flokli@flokli.de>
    ARM: dts: bcm2837-rpi-cm3-io3: Fix HDMI hpd-gpio pin

Martin Kletzander <nert.pinx@gmail.com>
    x86/resctrl: Avoid overflow in MB settings in bw_validate()

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Add a check for memory allocation

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    RDMA/bnxt_re: Fix incorrect AVID type in WQE structure

Jiri Olsa <jolsa@kernel.org>
    bpf: Fix memory leak in bpf_core_apply

Florian Kauer <florian.kauer@linutronix.de>
    bpf: devmap: provide rxq after redirect

Toke Høiland-Jørgensen <toke@redhat.com>
    bpf: Make sure internal and UAPI bpf_redirect flags don't overlap

Mikhail Lobanov <m.lobanov@rosalinux.ru>
    iio: accel: bma400: Fix uninitialized variable field_value in tap event handling.

Wander Lairson Costa <wander.lairson@gmail.com>
    bpf: Use raw_spinlock_t in ringbuf


-------------

Diffstat:

 .../bindings/sound/davinci-mcasp-audio.yaml        |  18 +-
 Documentation/networking/driver.rst                |  97 +++++---
 Makefile                                           |   4 +-
 arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts          |   2 +-
 arch/arm64/Makefile                                |   2 +-
 arch/arm64/include/asm/uprobes.h                   |  12 +-
 arch/arm64/kernel/probes/uprobes.c                 |   4 +-
 arch/arm64/kvm/arm.c                               |   3 +
 arch/arm64/kvm/vgic/vgic-init.c                    |   6 +-
 arch/loongarch/Kconfig                             |   1 +
 arch/loongarch/include/asm/bootinfo.h              |   4 +
 arch/loongarch/include/asm/page.h                  |   1 +
 arch/loongarch/include/asm/vdso/gettimeofday.h     |   9 +-
 arch/loongarch/include/asm/vdso/vdso.h             |  32 ++-
 arch/loongarch/kernel/process.c                    |  14 +-
 arch/loongarch/kernel/setup.c                      |   3 +-
 arch/loongarch/kernel/vdso.c                       |  98 ++++++--
 arch/loongarch/vdso/vgetcpu.c                      |   2 +-
 arch/riscv/net/bpf_jit_comp64.c                    |   4 +-
 arch/s390/include/asm/perf_event.h                 |   1 +
 arch/s390/pci/pci_event.c                          |  17 +-
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c          |  23 +-
 arch/x86/kvm/svm/nested.c                          |   6 +-
 block/bfq-iosched.c                                |  37 ++-
 block/blk-map.c                                    |   4 +-
 drivers/acpi/button.c                              |  11 +
 drivers/acpi/cppc_acpi.c                           | 116 +++++++++
 drivers/acpi/prmt.c                                |  29 ++-
 drivers/acpi/resource.c                            |   7 +
 drivers/cpufreq/cppc_cpufreq.c                     | 139 ++---------
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |  15 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c            |   5 +-
 .../drm/amd/display/modules/power/power_helpers.c  |   2 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |   9 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c   |   1 +
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c   |   3 +-
 drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c  |  19 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   2 +-
 drivers/gpu/drm/vboxvideo/hgsmi_base.c             |  10 +-
 drivers/gpu/drm/vboxvideo/vboxvideo.h              |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c               |   4 +
 drivers/iio/accel/bma400_core.c                    |   3 +-
 drivers/iio/frequency/Kconfig                      |  31 +--
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |   2 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |   2 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |  21 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |   9 +-
 drivers/infiniband/hw/irdma/cm.c                   |   2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  80 ++++++-
 drivers/irqchip/irq-renesas-rzg2l.c                |  94 ++++++--
 drivers/net/dsa/mv88e6xxx/port.c                   |   1 +
 drivers/net/ethernet/aeroflex/greth.c              |   3 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |   1 +
 drivers/net/ethernet/emulex/benet/be_main.c        |  10 +-
 drivers/net/ethernet/i825xx/sun3_82586.c           |   1 +
 drivers/net/ethernet/marvell/octeon_ep/octep_rx.c  |  82 +++++--
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 138 ++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  15 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   2 +
 drivers/net/ethernet/realtek/r8169_main.c          |   4 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  25 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   2 +
 drivers/net/hyperv/netvsc_drv.c                    |  30 +++
 drivers/net/macsec.c                               |  18 --
 drivers/net/netdevsim/dev.c                        |  15 +-
 drivers/net/phy/dp83822.c                          |   4 +-
 drivers/net/plip/plip.c                            |   2 +-
 drivers/net/usb/usbnet.c                           |   4 +-
 drivers/net/wwan/wwan_core.c                       |   2 +-
 drivers/platform/x86/dell/dell-wmi-base.c          |   9 +
 drivers/platform/x86/dell/dell-wmi-sysman/sysman.c |   1 +
 drivers/powercap/dtpm_devfreq.c                    |   2 +-
 drivers/pps/clients/pps-ldisc.c                    |   6 +-
 drivers/target/target_core_device.c                |   2 +-
 drivers/target/target_core_user.c                  |   2 +-
 drivers/tty/serial/imx.c                           |  17 +-
 drivers/tty/serial/max3100.c                       |   2 +-
 drivers/tty/serial/max310x.c                       |   3 +-
 drivers/tty/serial/serial_core.c                   |  32 +--
 drivers/tty/serial/sunhv.c                         |   8 +-
 drivers/usb/dwc3/core.c                            |  19 ++
 drivers/usb/dwc3/core.h                            |   3 +
 drivers/usb/gadget/composite.c                     |  40 ++++
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
 fs/nilfs2/page.c                                   |   6 +-
 fs/ntfs3/record.c                                  |  67 +++++-
 fs/open.c                                          |   2 +
 fs/smb/client/smb2pdu.c                            |   9 +
 fs/udf/inode.c                                     |  49 ++--
 fs/udf/truncate.c                                  |  10 +-
 fs/udf/udfdecl.h                                   |   5 +-
 include/acpi/cppc_acpi.h                           |   2 +
 include/linux/netdevice.h                          |  13 +
 include/linux/serial_core.h                        |   6 +-
 include/linux/tty_ldisc.h                          |   4 +-
 include/linux/usb/composite.h                      |   6 +
 include/linux/usb/gadget.h                         |   1 +
 include/net/bluetooth/bluetooth.h                  |   1 +
 include/net/genetlink.h                            |   3 +-
 include/net/netdev_queues.h                        | 144 +++++++++++
 include/net/xfrm.h                                 |  28 ++-
 include/uapi/linux/bpf.h                           |  13 +-
 kernel/bpf/btf.c                                   |   1 +
 kernel/bpf/devmap.c                                |  11 +-
 kernel/bpf/ringbuf.c                               |  12 +-
 kernel/bpf/task_iter.c                             |   2 +-
 kernel/bpf/verifier.c                              |   8 +-
 kernel/time/posix-clock.c                          |   6 +-
 kernel/trace/bpf_trace.c                           |   2 -
 kernel/trace/trace_probe.c                         |   2 +-
 net/bluetooth/af_bluetooth.c                       |  22 ++
 net/bluetooth/bnep/core.c                          |   3 +-
 net/bluetooth/iso.c                                |  18 +-
 net/bluetooth/sco.c                                |  18 +-
 net/core/filter.c                                  |   8 +-
 net/ipv4/devinet.c                                 |  35 ++-
 net/ipv4/inet_connection_sock.c                    |  21 +-
 net/ipv4/xfrm4_policy.c                            |  38 ++-
 net/ipv6/xfrm6_policy.c                            |  31 +--
 net/l2tp/l2tp_netlink.c                            |   4 +-
 net/netfilter/xt_NFLOG.c                           |   2 +-
 net/netfilter/xt_TRACE.c                           |   1 +
 net/netfilter/xt_mark.c                            |   2 +-
 net/netlink/genetlink.c                            |  28 +--
 net/sched/act_api.c                                |  23 +-
 net/sched/sch_generic.c                            |  17 +-
 net/sched/sch_taprio.c                             |   3 +-
 net/smc/smc_pnet.c                                 |   2 +-
 net/wireless/nl80211.c                             |   8 +-
 net/xfrm/xfrm_device.c                             |  11 +-
 net/xfrm/xfrm_policy.c                             |  50 +++-
 net/xfrm/xfrm_user.c                               |   4 +-
 security/selinux/selinuxfs.c                       |  27 ++-
 sound/firewire/amdtp-stream.c                      |   3 +
 sound/pci/hda/patch_cs8409.c                       |   5 +-
 sound/pci/hda/patch_realtek.c                      |  48 ++--
 sound/soc/codecs/lpass-rx-macro.c                  |   2 +-
 sound/soc/fsl/fsl_sai.c                            |   5 +-
 sound/soc/fsl/fsl_sai.h                            |   1 +
 sound/soc/qcom/lpass-cpu.c                         |   2 +
 sound/soc/qcom/sm8250.c                            |   1 +
 tools/testing/selftests/bpf/Makefile               |   2 +-
 155 files changed, 1978 insertions(+), 1066 deletions(-)


