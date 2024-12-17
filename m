Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D0F8615A;
	Tue, 17 Dec 2024 17:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456031; cv=none; b=V3h2DYKu1FMvrho6d4H27W+Hd0+YM09R2lKtQop+pbbfW+2AUe2iLmuwlvhvLoyrOM9btOq11WwSPxY0IWqu1T8LWpd4RUcLULXijoLK0Ks2XWNvGwBJPVoC7AyGasamqkxLEoDkp3q6gHTxnRYr3CiqYAVI+kZI3y0JaARXjf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456031; c=relaxed/simple;
	bh=hch3o0XU9WSONDAtxY4m1uzSBa6/kOWcxsw7nB4IME8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FxluCB2ZTE9MHFeEgo0wtbVmRoL363VNX37LnXWjfhtVGMAAs5YSAbPG9CXT3cYZggA4mror/kaYaK3/ODpRrlMGzxcIstX7+KTQBmrOHsO7CgV9hSYV2pvYDKyFY9tCCAVMWHNIRFeBqtz6RMYYIiK5yaY3gl2PyPhtcF5ttTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHN9Syea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHN9Syea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C4AC4CED3;
	Tue, 17 Dec 2024 17:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456031;
	bh=hch3o0XU9WSONDAtxY4m1uzSBa6/kOWcxsw7nB4IME8=;
	h=From:To:Cc:Subject:Date:From;
	b=hHN9SyeasiKzMWWencgrjeBr328W00FpNU1ZAstDhJMa8vQMXrtDRrpUuyogLDezw
	 mjGIm2Np6Leezs30Z7sUqpkGniEWm7hyKEhcKIkNMo/7qaO6I1O9GwWmSQCA0wufVL
	 Rq9LKD74cPr6/K4U7IB9hk18lORu2PiIdCJvJVhY=
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
Subject: [PATCH 6.6 000/109] 6.6.67-rc1 review
Date: Tue, 17 Dec 2024 18:06:44 +0100
Message-ID: <20241217170533.329523616@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.67-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.67-rc1
X-KernelTest-Deadline: 2024-12-19T17:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.67 release.
There are 109 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.67-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.67-rc1

Dan Carpenter <dan.carpenter@linaro.org>
    ALSA: usb-audio: Fix a DMA to stack memory bug

Juergen Gross <jgross@suse.com>
    x86/xen: remove hypercall page

Juergen Gross <jgross@suse.com>
    x86/xen: use new hypercall functions instead of hypercall page

Juergen Gross <jgross@suse.com>
    x86/xen: add central hypercall functions

Juergen Gross <jgross@suse.com>
    x86/xen: don't do PV iret hypercall through hypercall page

Juergen Gross <jgross@suse.com>
    x86/static-call: provide a way to do very early static-call updates

Juergen Gross <jgross@suse.com>
    objtool/x86: allow syscall instruction

Juergen Gross <jgross@suse.com>
    x86: make get_cpu_vendor() accessible from Xen code

Juergen Gross <jgross@suse.com>
    xen/netfront: fix crash when removing device

Radu Rendec <rrendec@redhat.com>
    net: rswitch: Avoid use-after-free in rswitch_poll()

Shung-Hsi Yu <shung-hsi.yu@suse.com>
    selftests/bpf: remove use of __xlated()

Daniel Borkmann <daniel@iogearbox.net>
    selftests/bpf: Add netlink helper library

Nikolay Kuratov <kniv@yandex-team.ru>
    tracing/kprobes: Skip symbol counting logic for module symbols in create_local_trace_kprobe()

Eduard Zingerman <eddyz87@gmail.com>
    bpf: sync_linked_regs() must preserve subreg_def

James Morse <james.morse@arm.com>
    KVM: arm64: Disable MPAM visibility by default and ignore VMM writes

Weizhao Ouyang <o451686892@gmail.com>
    kselftest/arm64: abi: fix SVCR detection

Nathan Chancellor <nathan@kernel.org>
    blk-iocost: Avoid using clamp() on inuse in __propagate_weights()

Jesse Van Gavere <jesseevg@gmail.com>
    net: dsa: microchip: KSZ9896 register regmap alignment to 32 bit boundaries

Nikita Yushchenko <nikita.yoush@cogentembedded.com>
    net: renesas: rswitch: fix initial MPIC register setting

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    Bluetooth: btmtk: avoid UAF in btmtk_process_coredump

Frédéric Danis <frederic.danis@collabora.com>
    Bluetooth: SCO: Add support for 16 bits transparent voice setting

Iulia Tanasescu <iulia.tanasescu@nxp.com>
    Bluetooth: iso: Fix recursive locking warning

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Fix using rcu_read_(un)lock while iterating

Iulia Tanasescu <iulia.tanasescu@nxp.com>
    Bluetooth: ISO: Reassociate a socket with an active BIS

Daniil Tatianin <d-tatianin@yandex-team.ru>
    ACPICA: events/evxfregn: don't release the ContextMutex that was never acquired

Daniel Borkmann <daniel@iogearbox.net>
    team: Fix feature propagation of NETIF_F_GSO_ENCAP_ALL

Daniel Borkmann <daniel@iogearbox.net>
    bonding: Fix feature propagation of NETIF_F_GSO_ENCAP_ALL

Martin Ottens <martin.ottens@fau.de>
    net/sched: netem: account for backlog updates from child qdisc

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: fix stuck CPU-injected packets with short taprio windows

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: do not defer rule destruction via call_rcu

Phil Sutter <phil@nwl.cc>
    netfilter: IDLETIMER: Fix for possible ABBA deadlock

James Clark <james.clark@linaro.org>
    libperf: evlist: Fix --cpu argument on hybrid platform

Nikita Yushchenko <nikita.yoush@cogentembedded.com>
    net: renesas: rswitch: handle stop vs interrupt race

Nikita Yushchenko <nikita.yoush@cogentembedded.com>
    net: renesas: rswitch: avoid use-after-put for a device tree node

Nikita Yushchenko <nikita.yoush@cogentembedded.com>
    net: renesas: rswitch: fix leaked pointer on error path

Nikita Yushchenko <nikita.yoush@cogentembedded.com>
    net: renesas: rswitch: fix race window between tx start and complete

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: rswitch: Add jumbo frames handling for TX

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: rswitch: Add a setting ext descriptor function

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: rswitch: Add unmap_addrs instead of dma address in each desc

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: rswitch: Use build_skb() for RX

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: rswitch: Use unsigned int for desc related array index

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: rswitch: Drop unused argument/return value

Paul Barker <paul.barker.ct@bp.renesas.com>
    Documentation: PM: Clarify pm_runtime_resume_and_get() return value

Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
    ASoC: amd: yc: Fix the wrong return value

Takashi Iwai <tiwai@suse.de>
    ALSA: control: Avoid WARN() for symlink errors

Stefan Wahren <wahrenst@gmx.net>
    qca_spi: Make driver probing reliable

Stefan Wahren <wahrenst@gmx.net>
    qca_spi: Fix clock speed for multiple QCA7000

Anumula Murali Mohan Reddy <anumula@chelsio.com>
    cxgb4: use port number to set mac addr

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    ACPI: resource: Fix memory resource type union access

Daniel Machon <daniel.machon@microchip.com>
    net: sparx5: fix the maximum frame length register

Daniel Machon <daniel.machon@microchip.com>
    net: sparx5: fix FDMA performance issue

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    spi: aspeed: Fix an error handling path in aspeed_spi_[read|write]_user()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: perform error cleanup in ocelot_hwstamp_set()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: be resilient to loss of PTP packets during transmission

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: ocelot->ts_id_lock and ocelot_port->tx_skbs.lock are IRQ-safe

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: improve handling of TX timestamp for unknown skb

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix memory leak on ocelot_port_add_txtstamp_skb()

Eric Dumazet <edumazet@google.com>
    net: defer final 'struct net' free in netns dismantle

Eric Dumazet <edumazet@google.com>
    net: lapb: increase LAPB_HEADER_LEN

Thomas Weißschuh <linux@weissschuh.net>
    ptp: kvm: x86: Return EOPNOTSUPP instead of ENODEV from kvm_arch_ptp_init()

Danielle Ratson <danieller@nvidia.com>
    selftests: mlxsw: sharedbuffer: Ensure no extra packets are counted

Danielle Ratson <danieller@nvidia.com>
    selftests: mlxsw: sharedbuffer: Remove duplicate test cases

Danielle Ratson <danieller@nvidia.com>
    selftests: mlxsw: sharedbuffer: Remove h1 ingress test case

Haoyu Li <lihaoyu499@gmail.com>
    wifi: cfg80211: sme: init n_channels before channels[] access

Dan Carpenter <dan.carpenter@linaro.org>
    net/mlx5: DR, prevent potential error pointer dereference

Eric Dumazet <edumazet@google.com>
    tipc: fix NULL deref in cleanup_bearer()

Remi Pommarel <repk@triplefau.lt>
    batman-adv: Do not let TT changes list grows indefinitely

Remi Pommarel <repk@triplefau.lt>
    batman-adv: Remove uninitialized data in full table TT response

Remi Pommarel <repk@triplefau.lt>
    batman-adv: Do not send uninitialized TT changes

David (Ming Qiang) Wu <David.Wu3@amd.com>
    amdgpu/uvd: get ring reference from rq scheduler

Suraj Sonawane <surajsonawane0215@gmail.com>
    acpi: nfit: vmalloc-out-of-bounds Read in acpi_nfit_ctl

Benjamin Lin <benjamin-jw.lin@mediatek.com>
    wifi: mac80211: fix station NSS capability initialization order

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: clean up 'ret' in sta_link_apply_parameters()

Haoyu Li <lihaoyu499@gmail.com>
    wifi: mac80211: init cnt before accessing elem in ieee80211_copy_mbssid_beacon

Lin Ma <linma@zju.edu.cn>
    wifi: nl80211: fix NL80211_ATTR_MLO_LINK_ID off-by-one

Tomas Glozar <tglozar@redhat.com>
    rtla/timerlat: Make timerlat_hist_cpu->*_count unsigned long long

Michal Luczaj <mhal@rbox.co>
    bpf, sockmap: Fix update element with same

Michal Luczaj <mhal@rbox.co>
    bpf, sockmap: Fix race between element replace and close()

Jiri Olsa <jolsa@kernel.org>
    bpf,perf: Fix invalid prog_array access in perf_event_detach_bpf_prog

Jann Horn <jannh@google.com>
    bpf: Fix theoretical prog_array UAF in __uprobe_perf_func()

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Check size for BTF-based ctx access of pointer members

Darrick J. Wong <djwong@kernel.org>
    xfs: only run precommits once per transaction object

Darrick J. Wong <djwong@kernel.org>
    xfs: fix scrub tracepoints when inode-rooted btrees are involved

Darrick J. Wong <djwong@kernel.org>
    xfs: return from xfs_symlink_verify early on V4 filesystems

Darrick J. Wong <djwong@kernel.org>
    xfs: don't drop errno values when we fail to ficlone the entire range

Darrick J. Wong <djwong@kernel.org>
    xfs: update btree keys correctly when _insrec splits an inode root block

Eugene Kobyak <eugene.kobyak@intel.com>
    drm/i915: Fix NULL pointer dereference in capture_engine

Jiasheng Jiang <jiashengjiangcool@outlook.com>
    drm/i915: Fix memory leak by correcting cache object name in error handler

Neal Frager <neal.frager@amd.com>
    usb: dwc3: xilinx: make sure pipe clock is deselected in usb2 only mode

Lianqin Hu <hulianqin@vivo.com>
    usb: gadget: u_serial: Fix the issue that gs_start_io crashed due to accessing null pointer

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    usb: typec: anx7411: fix OF node reference leaks in anx7411_typec_switch_probe()

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    usb: typec: anx7411: fix fwnode_handle reference leak

Vitalii Mordan <mordan@ispras.ru>
    usb: ehci-hcd: fix call balance of clocks handling routines

Takashi Iwai <tiwai@suse.de>
    usb: gadget: midi2: Fix interpretation of is_midi1 bits

liuderong <liuderong@oppo.com>
    scsi: ufs: core: Update compl_time_stamp_local_clock after completing a cqe

Stefan Wahren <wahrenst@gmx.net>
    usb: dwc2: Fix HCD port connection race

Stefan Wahren <wahrenst@gmx.net>
    usb: dwc2: hcd: Fix GetPortStatus & SetPortFeature

Stefan Wahren <wahrenst@gmx.net>
    usb: dwc2: Fix HCD resume

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    ata: sata_highbank: fix OF node reference leak in highbank_initialize_phys()

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    usb: host: max3421-hcd: Correctly abort a USB request.

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Fix IPIs usage in kfence_protect_page()

Jaakko Salo <jaakkos@gmail.com>
    ALSA: usb-audio: Add implicit feedback quirk for Yamaha THR5

Tejun Heo <tj@kernel.org>
    blk-cgroup: Fix UAF in blkcg_unpin_online()

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Fix wrong usage of __pa() on a fixmap address

MoYuanhao <moyuanhao3676@163.com>
    tcp: check space before adding MPTCP SYN options

Frederik Deweerdt <deweerdt.lkml@gmail.com>
    splice: do not checksum AF_UNIX sockets

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix racy issue from session lookup and expire

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/ds: Unconditionally drain PEBS DS when changing PEBS_DATA_CFG

Jann Horn <jannh@google.com>
    bpf: Fix UAF via mismatching bpf_prog/attachment RCU flavors


-------------

Diffstat:

 Documentation/power/runtime_pm.rst                 |   4 +-
 Makefile                                           |   4 +-
 arch/arm64/kvm/sys_regs.c                          |  52 ++-
 arch/riscv/include/asm/kfence.h                    |   4 +-
 arch/riscv/kernel/setup.c                          |   2 +-
 arch/x86/events/intel/ds.c                         |   2 +-
 arch/x86/include/asm/processor.h                   |   2 +
 arch/x86/include/asm/static_call.h                 |  15 +
 arch/x86/include/asm/sync_core.h                   |   6 +-
 arch/x86/include/asm/xen/hypercall.h               |  36 +-
 arch/x86/kernel/callthunks.c                       |   5 -
 arch/x86/kernel/cpu/common.c                       |  38 +-
 arch/x86/kernel/static_call.c                      |   9 +
 arch/x86/xen/enlighten.c                           |  65 +++-
 arch/x86/xen/enlighten_hvm.c                       |  13 +-
 arch/x86/xen/enlighten_pv.c                        |   4 +-
 arch/x86/xen/enlighten_pvh.c                       |   7 -
 arch/x86/xen/xen-asm.S                             |  50 ++-
 arch/x86/xen/xen-head.S                            | 106 ++++--
 arch/x86/xen/xen-ops.h                             |   9 +
 block/blk-cgroup.c                                 |   6 +-
 block/blk-iocost.c                                 |   9 +-
 drivers/acpi/acpica/evxfregn.c                     |   2 -
 drivers/acpi/nfit/core.c                           |   7 +-
 drivers/acpi/resource.c                            |   6 +-
 drivers/ata/sata_highbank.c                        |   1 +
 drivers/bluetooth/btmtk.c                          |  20 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c              |   2 +-
 drivers/gpu/drm/i915/i915_gpu_error.c              |  18 +-
 drivers/gpu/drm/i915/i915_scheduler.c              |   2 +-
 drivers/net/bonding/bond_main.c                    |   1 +
 drivers/net/dsa/microchip/ksz_common.c             |  42 +--
 drivers/net/dsa/ocelot/felix_vsc9959.c             |  17 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |   5 +-
 .../mellanox/mlx5/core/steering/dr_domain.c        |   4 +-
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |  11 +-
 .../net/ethernet/microchip/sparx5/sparx5_port.c    |   2 +-
 drivers/net/ethernet/mscc/ocelot_ptp.c             | 207 ++++++-----
 drivers/net/ethernet/qualcomm/qca_spi.c            |  26 +-
 drivers/net/ethernet/qualcomm/qca_spi.h            |   1 -
 drivers/net/ethernet/renesas/rswitch.c             | 385 +++++++++++++--------
 drivers/net/ethernet/renesas/rswitch.h             |  48 ++-
 drivers/net/team/team.c                            |   3 +-
 drivers/net/xen-netfront.c                         |   5 +-
 drivers/ptp/ptp_kvm_x86.c                          |   6 +-
 drivers/spi/spi-aspeed-smc.c                       |  10 +-
 drivers/ufs/core/ufshcd.c                          |   1 +
 drivers/usb/dwc2/hcd.c                             |  19 +-
 drivers/usb/dwc3/dwc3-xilinx.c                     |   5 +-
 drivers/usb/gadget/function/f_midi2.c              |   6 +-
 drivers/usb/gadget/function/u_serial.c             |   9 +-
 drivers/usb/host/ehci-sh.c                         |   9 +-
 drivers/usb/host/max3421-hcd.c                     |  16 +-
 drivers/usb/typec/anx7411.c                        |  66 ++--
 fs/smb/server/auth.c                               |   2 +
 fs/smb/server/mgmt/user_session.c                  |   6 +-
 fs/smb/server/server.c                             |   4 +-
 fs/smb/server/smb2pdu.c                            |  27 +-
 fs/xfs/libxfs/xfs_btree.c                          |  29 +-
 fs/xfs/libxfs/xfs_symlink_remote.c                 |   4 +-
 fs/xfs/scrub/trace.h                               |   2 +-
 fs/xfs/xfs_file.c                                  |   8 +
 fs/xfs/xfs_trans.c                                 |  16 +-
 include/linux/bpf.h                                |  13 +-
 include/linux/compiler.h                           |  39 ++-
 include/linux/dsa/ocelot.h                         |   1 +
 include/linux/static_call.h                        |   1 +
 include/net/bluetooth/bluetooth.h                  |   1 +
 include/net/bluetooth/hci_core.h                   |  24 ++
 include/net/lapb.h                                 |   2 +-
 include/net/net_namespace.h                        |   1 +
 include/net/netfilter/nf_tables.h                  |   4 -
 include/soc/mscc/ocelot.h                          |   2 -
 kernel/bpf/btf.c                                   |   6 +
 kernel/bpf/verifier.c                              |   5 +-
 kernel/static_call_inline.c                        |   2 +-
 kernel/trace/bpf_trace.c                           |  11 +
 kernel/trace/trace_kprobe.c                        |   2 +-
 kernel/trace/trace_uprobe.c                        |   6 +-
 net/batman-adv/translation-table.c                 |  58 +++-
 net/bluetooth/hci_conn.c                           |  32 +-
 net/bluetooth/hci_event.c                          |  33 +-
 net/bluetooth/iso.c                                |  87 ++++-
 net/bluetooth/sco.c                                |  29 +-
 net/core/net_namespace.c                           |  20 +-
 net/core/sock_map.c                                |   6 +-
 net/ipv4/tcp_output.c                              |   6 +-
 net/mac80211/cfg.c                                 |  11 +-
 net/netfilter/nf_tables_api.c                      |  32 +-
 net/netfilter/xt_IDLETIMER.c                       |  52 +--
 net/sched/sch_netem.c                              |  22 +-
 net/tipc/udp_media.c                               |   7 +-
 net/unix/af_unix.c                                 |   1 +
 net/wireless/nl80211.c                             |   2 +-
 net/wireless/sme.c                                 |   1 +
 sound/core/control_led.c                           |  14 +-
 sound/soc/amd/yc/acp6x-mach.c                      |  13 +-
 sound/usb/quirks.c                                 |  44 ++-
 tools/lib/perf/evlist.c                            |  18 +-
 tools/objtool/check.c                              |   9 +-
 .../testing/selftests/arm64/abi/syscall-abi-asm.S  |  32 +-
 tools/testing/selftests/bpf/Makefile               |  19 +-
 tools/testing/selftests/bpf/netlink_helpers.c      | 358 +++++++++++++++++++
 tools/testing/selftests/bpf/netlink_helpers.h      |  46 +++
 .../selftests/bpf/progs/verifier_btf_ctx_access.c  |   4 +-
 .../testing/selftests/bpf/progs/verifier_d_path.c  |   4 +-
 .../selftests/bpf/progs/verifier_scalar_ids.c      |  16 -
 .../selftests/drivers/net/mlxsw/sharedbuffer.sh    |  55 ++-
 tools/tracing/rtla/src/timerlat_hist.c             |  12 +-
 111 files changed, 1927 insertions(+), 748 deletions(-)


