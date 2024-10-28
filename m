Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0906B18CC1F;
	Mon, 28 Oct 2024 06:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096907; cv=none; b=FXPm2Bek4bBMYgIXhjhmmIHd2IO66xdgSQOqm8f1I6oEqAODIreg2u71pTqkQyb7MgY+bsCmQAw3NiI7SoKKAjlFIzvgA2Snx0WpG2adYFiejsaENx4/CWQW9Jev2/Nj/6xjbFC3mmKnlCvEITfSsPGLjsIKwu0Fsv+9BOrYhiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096907; c=relaxed/simple;
	bh=sDGgD4G9XKJExtgo3TdwhVFlctSWCtOx6m6OgoRLT5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ibeWhlf9Cw1F5lx6PrW0J5LJZWzDhl06hWgLR2/cPqKxXAcukC+HtxhaB2i+BEyCJwX6L9fq2xDlpVkpuS/O4K7kAFua4Uf+U5aj36x6xhuCTSjTUfnZLJljIoPbSYaGKjQauUfks0WUQfMWv19s+Sr1/IPgNTTYkGrVTjNZWMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B55ZHJ0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B55ZHJ0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7458BC4CEC3;
	Mon, 28 Oct 2024 06:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096906;
	bh=sDGgD4G9XKJExtgo3TdwhVFlctSWCtOx6m6OgoRLT5Y=;
	h=From:To:Cc:Subject:Date:From;
	b=B55ZHJ0bl08EMt1wxSPWtbRDJjaln8zbvIYbcTdh1DlvfRgLUcFll9ARJ7iZII98G
	 Sqy/M2h4crBjW1IOErDoYtQw+5ljSdSoU5rA9o7zjF4f4XdTl3I2s5LPYKtgTECib6
	 DsEpw1JHUnYxoorMmESYpjt8NGJteG+iZ5ZO6wpc=
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
Subject: [PATCH 5.15 00/80] 5.15.170-rc1 review
Date: Mon, 28 Oct 2024 07:24:40 +0100
Message-ID: <20241028062252.611837461@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.170-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.170-rc1
X-KernelTest-Deadline: 2024-10-30T06:22+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.170 release.
There are 80 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 30 Oct 2024 06:22:39 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.170-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.170-rc1

Zichen Xie <zichenxie0106@gmail.com>
    ASoC: qcom: Fix NULL Dereference in asoc_qcom_lpass_cpu_platform_probe()

Michel Alex <Alex.Michel@wiedemann-group.com>
    net: phy: dp83822: Fix reset pin definitions

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    serial: protect uart_port_dtr_rts() in uart_shutdown() too

Paul Moore <paul@paul-moore.com>
    selinux: improve error checking in sel_write_load()

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Fix VF namespace also in synthetic NIC NETDEV_REGISTER event

Petr Vaganov <p.vaganov@ideco.ru>
    xfrm: fix one more kernel-infoleak in algo dumping

José Relvas <josemonsantorelvas@gmail.com>
    ALSA: hda/realtek: Add subwoofer quirk for Acer Predator G9-593

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Ignore nCR3[4:0] when loading PDPTEs from memory

Aleksa Sarai <cyphar@cyphar.com>
    openat2: explicitly return -E2BIG for (usize > PAGE_SIZE)

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix kernel bug due to missing clearing of buffer delay flag

Shubham Panwar <shubiisp8@gmail.com>
    ACPI: button: Add DMI quirk for Samsung Galaxy Book2 to fix initial lid detection issue

Christian Heusel <christian@heusel.eu>
    ACPI: resource: Add LG 16T90SP to irq1_level_low_skip_override[]

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Guard against bad data for ATIF ACPI method

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fix zone unusable accounting for freed reserved extent

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Update default depop procedure

Andrey Shumilin <shum.sdl@nppct.ru>
    ALSA: firewire-lib: Avoid division by zero in apply_constraint_to_size()

Jiri Olsa <jolsa@kernel.org>
    bpf,perf: Fix perf_event_detach_bpf_prog error handling

Jinjie Ruan <ruanjinjie@huawei.com>
    posix-clock: posix-clock: Fix unbalanced locking in pc_clock_settime()

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: avoid unsolicited interrupts

Dmitry Antipov <dmantipov@yandex.ru>
    net: sched: fix use-after-free in taprio_change()

Oliver Neukum <oneukum@suse.com>
    net: usb: usbnet: fix name regression

Lin Ma <linma@zju.edu.cn>
    net: wwan: fix global oob in wwan_rtnl_policy

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: xtables: fix typo causing some targets not to load on IPv6

Peter Rashleigh <peter@rashleigh.ca>
    net: dsa: mv88e6xxx: Fix error when setting port policy on mv88e6393x

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

Crag Wang <crag_wang@dell.com>
    platform/x86: dell-sysman: add support for alienware products

Alexey Klimov <alexey.klimov@linaro.org>
    ASoC: qcom: sm8250: add qrb4210-rb2-sndcard compatible string

junhua huang <huang.junhua@zte.com.cn>
    arm64/uprobes: change the uprobe_opcode_t typedef to fix the sparse warning

Armin Wolf <W_Armin@gmx.de>
    platform/x86: dell-wmi: Ignore suspend notifications

Gianfranco Trad <gianf.trad@gmail.com>
    udf: fix uninit-value use in udf_get_fileshortad

Mark Rutland <mark.rutland@arm.com>
    arm64: Force position-independent veneers

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_sai: Enable 'FIFO continue on error' FCONT bit

Alexey Klimov <alexey.klimov@linaro.org>
    ASoC: codecs: lpass-rx-macro: add missing CDC_RX_BCL_VBAT_RF_PROC2 to default regs values

Hans de Goede <hdegoede@redhat.com>
    drm/vboxvideo: Replace fake VLA at end of vbva_mouse_pointer_shape with real VLA

Mateusz Guzik <mjguzik@gmail.com>
    exec: don't WARN for racy path_noexec check

Yu Kuai <yukuai3@huawei.com>
    block, bfq: fix procress reference leakage for bfqq in merge chain

Roger Quadros <rogerq@kernel.org>
    usb: dwc3: core: Fix system suspend on TI AM62 platforms

Frank Li <Frank.Li@nxp.com>
    XHCI: Separate PORT and CAPs macros into dedicated file

Elson Roy Serrao <quic_eserrao@quicinc.com>
    usb: gadget: Add function wakeup support

Nico Boehr <nrb@linux.ibm.com>
    KVM: s390: gaccess: Check if guest address is in memslot

Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    KVM: s390: gaccess: Cleanup access to guest pages

Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    KVM: s390: gaccess: Refactor access address range check

Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    KVM: s390: gaccess: Refactor gpa and length calculation

Mark Rutland <mark.rutland@arm.com>
    arm64: probes: Fix uprobes for big-endian kernels

junhua huang <huang.junhua@zte.com.cn>
    arm64:uprobe fix the uprobe SWBP_INSN in big-endian

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

Eric Dumazet <edumazet@google.com>
    genetlink: hold RCU in genlmsg_mcast()

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp/dccp: Don't use timer_pending() in reqsk_queue_unlink().

Wang Hai <wanghai38@huawei.com>
    net: systemport: fix potential memory leak in bcm_sysport_xmit()

Wang Hai <wanghai38@huawei.com>
    net: xilinx: axienet: fix potential memory leak in axienet_start_xmit()

Li RongQing <lirongqing@baidu.com>
    net/smc: Fix searching in list of known pnetids in smc_pnet_add_pnetid

Wang Hai <wanghai38@huawei.com>
    net: ethernet: aeroflex: fix potential memory leak in greth_start_xmit_gbit()

Sabrina Dubroca <sd@queasysnail.net>
    macsec: don't increment counters for an unrelated SA

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

Bhargava Chenna Marreddy <bhargava.marreddy@broadcom.com>
    RDMA/bnxt_re: Fix a bug while setting up Level-2 PBL pages

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Return more meaningful error

Xin Long <lucien.xin@gmail.com>
    ipv4: give an IPv4 dev to blackhole_netdev

Alexander Zubkov <green@qrator.net>
    RDMA/irdma: Fix misspelling of "accept*"

Anumula Murali Mohan Reddy <anumula@chelsio.com>
    RDMA/cxgb4: Fix RDMA_CM_EVENT_UNREACHABLE error for iWARP

Murad Masimov <m.masimov@maxima.ru>
    ALSA: hda/cs8409: Fix possible NULL dereference

Florian Klink <flokli@flokli.de>
    ARM: dts: bcm2837-rpi-cm3-io3: Fix HDMI hpd-gpio pin

Martin Kletzander <nert.pinx@gmail.com>
    x86/resctrl: Avoid overflow in MB settings in bw_validate()

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Add a check for memory allocation

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    RDMA/bnxt_re: Fix incorrect AVID type in WQE structure

Florian Kauer <florian.kauer@linutronix.de>
    bpf: devmap: provide rxq after redirect

Toke Høiland-Jørgensen <toke@redhat.com>
    bpf: Make sure internal and UAPI bpf_redirect flags don't overlap


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts          |   2 +-
 arch/arm64/Makefile                                |   2 +-
 arch/arm64/include/asm/uprobes.h                   |  12 +-
 arch/arm64/kernel/probes/uprobes.c                 |   4 +-
 arch/s390/include/asm/perf_event.h                 |   1 +
 arch/s390/kvm/gaccess.c                            | 162 +++++++------
 arch/s390/kvm/gaccess.h                            |  14 +-
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c          |  23 +-
 arch/x86/kvm/svm/nested.c                          |   6 +-
 block/bfq-iosched.c                                |  37 ++-
 drivers/acpi/button.c                              |  11 +
 drivers/acpi/resource.c                            |   7 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |  15 +-
 drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c  |  19 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   2 +-
 drivers/gpu/drm/vboxvideo/hgsmi_base.c             |  10 +-
 drivers/gpu/drm/vboxvideo/vboxvideo.h              |   4 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |   2 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |   2 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |  21 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |   9 +-
 drivers/infiniband/hw/irdma/cm.c                   |   2 +-
 drivers/net/dsa/mv88e6xxx/port.c                   |   1 +
 drivers/net/ethernet/aeroflex/greth.c              |   3 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |   1 +
 drivers/net/ethernet/emulex/benet/be_main.c        |  10 +-
 drivers/net/ethernet/i825xx/sun3_82586.c           |   1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   4 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   4 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   2 +
 drivers/net/hyperv/netvsc_drv.c                    |  30 +++
 drivers/net/macsec.c                               |  18 --
 drivers/net/phy/dp83822.c                          |   4 +-
 drivers/net/plip/plip.c                            |   2 +-
 drivers/net/usb/usbnet.c                           |   4 +-
 drivers/net/wwan/wwan_core.c                       |   2 +-
 drivers/platform/x86/dell/dell-wmi-base.c          |   9 +
 drivers/platform/x86/dell/dell-wmi-sysman/sysman.c |   1 +
 drivers/target/target_core_device.c                |   2 +-
 drivers/target/target_core_user.c                  |   2 +-
 drivers/tty/serial/serial_core.c                   |  16 +-
 drivers/usb/dwc3/core.c                            |  19 ++
 drivers/usb/dwc3/core.h                            |   3 +
 drivers/usb/gadget/composite.c                     |  40 ++++
 drivers/usb/host/xhci-caps.h                       |  85 +++++++
 drivers/usb/host/xhci-port.h                       | 176 ++++++++++++++
 drivers/usb/host/xhci.h                            | 262 +--------------------
 drivers/usb/typec/class.c                          |   3 +
 fs/btrfs/block-group.c                             |   2 +
 fs/cifs/smb2pdu.c                                  |   9 +
 fs/exec.c                                          |  21 +-
 fs/jfs/jfs_dmap.c                                  |   2 +-
 fs/nilfs2/page.c                                   |   6 +-
 fs/open.c                                          |   2 +
 fs/udf/inode.c                                     |   9 +-
 include/linux/usb/composite.h                      |   6 +
 include/linux/usb/gadget.h                         |   1 +
 include/net/genetlink.h                            |   3 +-
 include/net/xfrm.h                                 |  28 ++-
 include/uapi/linux/bpf.h                           |  13 +-
 kernel/bpf/devmap.c                                |  11 +-
 kernel/time/posix-clock.c                          |   6 +-
 kernel/trace/bpf_trace.c                           |   2 -
 kernel/trace/trace_probe.c                         |   2 +-
 net/bluetooth/bnep/core.c                          |   3 +-
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
 91 files changed, 900 insertions(+), 643 deletions(-)


