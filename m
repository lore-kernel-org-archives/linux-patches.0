Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508C43BF2FD;
	Thu, 15 Jan 2026 17:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496771; cv=none; b=QVQoXjfDYNf5aJ5cE+zsELXmZO1FcsFBQ/e6s+l93gWhalPMinve3NGY3Jn2Zd1d3vlWRWnrF1g0yZu0E7d6Ly2NIVAZbWMqTD32+aNshXb/twmlsBGr/5Vw8NtbiIp9w1lHXD+x2xfku+HdYjHY0nA9jZ43UZM1JNyWYqTZyFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496771; c=relaxed/simple;
	bh=QwodK+MVD5QVRouDn0D6fBFGXlqdxOqtCtSCqeGHWXI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NTvQpW3FQNBLG5stjbpQXn07c2cLegBMSSaI2vrJ1gfZMTaNH0H9lQuDmNbDWhFTwOhZIAd2+k/c2PGNRndCbP4uIxi10/7mvvYdLlA2xac3w26d+xmSux/FDBuMg8V8pd6uq4WaZua0o8XKdfb4rMnC6Tl869fWdpKT2l5fc1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FreKbzYH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FreKbzYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65057C116D0;
	Thu, 15 Jan 2026 17:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496770;
	bh=QwodK+MVD5QVRouDn0D6fBFGXlqdxOqtCtSCqeGHWXI=;
	h=From:To:Cc:Subject:Date:From;
	b=FreKbzYHCzVTDykNR21vhtXIQ5Q3qxVGUaWd3U7V5KtBGORJnKOS+r/OEZA1IYEyF
	 lY6okrTcoZCwsTQH2cHIguGd00iTu4D4eeOG4wRlRMrVkBYTZuoGRKZBaPPIQwvZiQ
	 TbGScD/ktVGUin0iRR/4sC1tWJwSW3Ood3WeM0Bk=
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.6 00/88] 6.6.121-rc1 review
Date: Thu, 15 Jan 2026 17:47:43 +0100
Message-ID: <20260115164146.312481509@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.121-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.121-rc1
X-KernelTest-Deadline: 2026-01-17T16:41+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.121 release.
There are 88 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.121-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.121-rc1

Sascha Hauer <s.hauer@pengutronix.de>
    gpio: pca953x: fix wrong error probe return value

Shardul Bankar <shardulsb08@gmail.com>
    bpf: test_run: Fix ctx leak in bpf_prog_test_run_xdp error path

Michal Rábek <mrabek@redhat.com>
    scsi: sg: Fix occasional bogus elapsed time that exceeds timeout

Alexander Stein <alexander.stein@ew.tq-group.com>
    ASoC: fsl_sai: Add missing registers to cache default

Andrew Elantsev <elantsew.andrew@gmail.com>
    ASoC: amd: yc: Add quirk for Honor MagicBook X16 2025

Jussi Laako <jussi@sonarnerd.net>
    ALSA: usb-audio: Update for native DSD support quirks

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: make j1939_session_activate() fail if device is no longer registered

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: Fix DP no audio issue

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: avoid chain re-validation if possible

Sumeet Pawnikar <sumeet4linux@gmail.com>
    powercap: fix sscanf() error return value handling

Sumeet Pawnikar <sumeet4linux@gmail.com>
    powercap: fix race condition in register_control_type()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    bpf: Fix reference count leak in bpf_prog_test_run_xdp()

Toke Høiland-Jørgensen <toke@redhat.com>
    bpf, test_run: Subtract size of xdp_frame from allowed metadata size

Amery Hung <ameryhung@gmail.com>
    bpf: Support specifying linear xdp packet data size for BPF_PROG_TEST_RUN

Amery Hung <ameryhung@gmail.com>
    bpf: Make variables in bpf_prog_test_run_xdp less confusing

Yonghong Song <yonghong.song@linux.dev>
    bpf: Fix an issue in bpf_prog_test_run_xdp when page size greater than 4K

Björn Töpel <bjorn@rivosinc.com>
    riscv: uprobes: Add missing fence.i after building the XOL buffer

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Select which microcode patch to load

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Remove NFSERR_EAGAIN

Mike Snitzer <snitzer@kernel.org>
    nfs_common: factor out nfs_errtbl and nfs_stat_to_errno

Chen Hanxiao <chenhx.fnst@fujitsu.com>
    NFS: trace: show TIMEDOUT instead of 0x6e

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    ALSA: ac97: fix a double free in snd_ac97_controller_register()

Takashi Iwai <tiwai@suse.de>
    ALSA: ac97bus: Use guard() for mutex locks

Hengqi Chen <hengqi.chen@gmail.com>
    LoongArch: Add more instruction opcodes and emit_* helpers

Eric Dumazet <edumazet@google.com>
    arp: do not assume dev_hard_header() does not change skb->head

Wei Fang <wei.fang@nxp.com>
    net: enetc: fix build warning when PAGE_SIZE is greater than 128K

Petko Manolov <petkan@nucleusys.com>
    net: usb: pegasus: fix memory leak in update_eth_regs_async()

Xiang Mei <xmei5@asu.edu>
    net/sched: sch_qfq: Fix NULL deref when deactivating inactive aggregate in qfq_reset

René Rebe <rene@exactco.de>
    HID: quirks: work around VID/PID conflict for appledisplay

Mohammad Heib <mheib@redhat.com>
    net: fix memory leak in skb_segment_list for GRO packets

Srijit Bose <srijit.bose@broadcom.com>
    bnxt_en: Fix potential data corruption with HW GRO/LRO

Zilin Guan <zilin@seu.edu.cn>
    net: wwan: iosm: Fix memory leak in ipc_mux_deinit()

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Don't print error message due to invalid module

Di Zhu <zhud@hygon.cn>
    netdev: preserve NETIF_F_ALL_FOR_ALL across TSO updates

Weiming Shi <bestswngs@gmail.com>
    net: sock: fix hardened usercopy panic in sock_recv_errqueue

yuan.gao <yuan.gao@ucloud.cn>
    inet: ping: Fix icmp out counting

Jerry Wu <w.7erry@foxmail.com>
    net: mscc: ocelot: Fix crash when adding interface under a lag

Alexandre Knecht <knecht.alexandre@gmail.com>
    bridge: fix C-VLAN preservation in 802.1ad vlan_tunnel egress

Alok Tiwari <alok.a.tiwari@oracle.com>
    net: marvell: prestera: fix NULL dereference on devlink_alloc() failure

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nf_conncount: update last_gc only when GC has been performed

Zilin Guan <zilin@seu.edu.cn>
    netfilter: nf_tables: fix memory leak in nf_tables_newrule()

Ernest Van Hoecke <ernest.vanhoecke@toradex.com>
    gpio: pca953x: handle short interrupt pulses on PCAL devices

Potin Lai <potin.lai.pt@gmail.com>
    gpio: pca953x: Add support for level-triggered interrupts

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: pca953x: Utilise temporary variable for struct device

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: pca953x: Utilise dev_err_probe() where it makes sense

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nft_synproxy: avoid possible data-race on update operation

Marek Vasut <marek.vasut@mailbox.org>
    arm64: dts: imx8mp: Fix LAN8740Ai PHY reference clock on DH electronics i.MX8M Plus DHCOM

Ian Ray <ian.ray@gehealthcare.com>
    ARM: dts: imx6q-ba16: fix RTC interrupt level

Haibo Chen <haibo.chen@nxp.com>
    arm64: dts: add off-on-delay-us for usdhc2 regulator

Xingui Yang <yangxingui@huawei.com>
    scsi: Revert "scsi: libsas: Fix exp-attached device scan after probe failure scanned in again after probe failed"

Brian Kao <powenkao@google.com>
    scsi: ufs: core: Fix EH failure after W-LUN resume error

Wen Xiong <wenxiong@linux.ibm.com>
    scsi: ipr: Enable/disable IRQD_NO_BALANCING during reset

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/client: fix NT_STATUS_NO_DATA_DETECTED value

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/client: fix NT_STATUS_DEVICE_DOOR_OPEN value

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/client: fix NT_STATUS_UNABLE_TO_FREE_VM value

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix up the automount fs_context to use the correct cred

Scott Mayhew <smayhew@redhat.com>
    NFSv4: ensure the open stateid seqid doesn't go backwards

Mikulas Patocka <mpatocka@redhat.com>
    dm-snapshot: fix 'scheduling while atomic' on real-time kernels

Sam James <sam@gentoo.org>
    alpha: don't reference obsolete termio struct for TC* constants

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    ARM: 9461/1: Disable HIGHPTE on PREEMPT_RT kernels

Yang Li <yang.li85200@gmail.com>
    csky: fix csky_cmpxchg_fixup not working

Kuniyuki Iwashima <kuniyu@google.com>
    tls: Use __sk_dst_get() and dst_dev_rcu() in get_netdev_for_sock().

Chuck Lever <chuck.lever@oracle.com>
    NFSD: NFSv4 file creation neglects setting ACL

Stephen Smalley <stephen.smalley.work@gmail.com>
    nfsd: set security label during create operations

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd: Fix NFSv3 atomicity bugs in nfsd_setattr()

Jeff Layton <jlayton@kernel.org>
    nfsd: convert to new timestamp accessors

Sharath Chandra Vurukala <quic_sharathv@quicinc.com>
    net: Add locking to protect skb->dev access in ip_output

Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
    ksm: use range-walk function to jump over holes in scan_get_next_rmap_item

Ilya Dryomov <idryomov@gmail.com>
    libceph: make calc_target() set t->paused, not just clear it

Sam Edwards <cfsworks@gmail.com>
    libceph: reset sparse-read state in osd_fault()

Ilya Dryomov <idryomov@gmail.com>
    libceph: return the handler error from mon_handle_auth_done()

Tuo Li <islituo@gmail.com>
    libceph: make free_choose_arg_map() resilient to partial allocation

Ilya Dryomov <idryomov@gmail.com>
    libceph: replace overzealous BUG_ON in osdmap_apply_incremental()

ziming zhang <ezrakiez@gmail.com>
    libceph: prevent potential out-of-bounds reads in handle_auth_done()

Eric Dumazet <edumazet@google.com>
    wifi: avoid kernel-infoleak from struct iw_point

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    pinctrl: qcom: lpass-lpi: mark the GPIO controller as sleeping

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: rockchip: mark the GPIO controller as sleeping

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: Remove __counted_by from ClockInfoArray.clockInfo[]

Miaoqian Lin <linmq006@gmail.com>
    drm/pl111: Fix error handling in pl111_amba_probe

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    counter: interrupt-cnt: Drop IRQF_NO_THREAD flag

Haotian Zhang <vulab@iscas.ac.cn>
    counter: 104-quad-8: Fix incorrect return value in IRQ handler

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: aes: Fix missing MMU protection for AES S-box

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add nova lake point S DID

Filipe Manana <fdmanana@suse.com>
    btrfs: always detect conflicting inodes when logging inode refs

Thomas Fourier <fourier.thomas@gmail.com>
    net: 3com: 3c59x: fix possible null dereference in vortex_probe1()

Thomas Fourier <fourier.thomas@gmail.com>
    atm: Fix dma_free_coherent() size

NeilBrown <neil@brown.name>
    nfsd: provide locking for v4_end_grace

Scott Mayhew <smayhew@redhat.com>
    NFSD: Fix permission check for read access to executable-only files


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/alpha/include/uapi/asm/ioctls.h               |   8 +-
 arch/arm/Kconfig                                   |   2 +-
 arch/arm/boot/dts/nxp/imx/imx6q-ba16.dtsi          |   2 +-
 .../arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi |   1 +
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts       |   1 +
 arch/csky/mm/fault.c                               |   4 +-
 arch/loongarch/include/asm/inst.h                  |  13 +++
 arch/riscv/kernel/probes/uprobes.c                 |  10 +-
 arch/x86/kernel/cpu/microcode/amd.c                | 104 +++++++++++------
 drivers/atm/he.c                                   |   3 +-
 drivers/counter/104-quad-8.c                       |  20 +++-
 drivers/counter/interrupt-cnt.c                    |   3 +-
 drivers/gpio/gpio-pca953x.c                        |  93 ++++++++++-----
 drivers/gpio/gpio-rockchip.c                       |   1 +
 .../amd/display/dc/dce110/dce110_hw_sequencer.c    |   8 +-
 drivers/gpu/drm/pl111/pl111_drv.c                  |   2 +-
 drivers/gpu/drm/radeon/pptable.h                   |   2 +-
 drivers/hid/hid-quirks.c                           |   9 ++
 drivers/md/dm-exception-store.h                    |   2 +-
 drivers/md/dm-snap.c                               |  73 ++++++------
 drivers/misc/mei/hw-me-regs.h                      |   2 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/net/ethernet/3com/3c59x.c                  |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  15 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   4 +-
 drivers/net/ethernet/freescale/enetc/enetc.h       |   4 +-
 .../ethernet/marvell/prestera/prestera_devlink.c   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |   3 +-
 drivers/net/ethernet/mscc/ocelot.c                 |   6 +-
 drivers/net/usb/pegasus.c                          |   2 +
 drivers/net/wwan/iosm/iosm_ipc_mux.c               |   6 +
 drivers/pinctrl/qcom/pinctrl-lpass-lpi.c           |   2 +-
 drivers/powercap/powercap_sys.c                    |  22 ++--
 drivers/scsi/ipr.c                                 |  28 ++++-
 drivers/scsi/libsas/sas_internal.h                 |  14 ---
 drivers/scsi/sg.c                                  |  20 ++--
 drivers/ufs/core/ufshcd.c                          |  40 +++++--
 fs/btrfs/tree-log.c                                |   6 +-
 fs/nfs/Kconfig                                     |   1 +
 fs/nfs/namespace.c                                 |   5 +
 fs/nfs/nfs2xdr.c                                   |  70 +-----------
 fs/nfs/nfs3xdr.c                                   | 108 ++++--------------
 fs/nfs/nfs4proc.c                                  |  13 ++-
 fs/nfs/nfs4trace.h                                 |   1 +
 fs/nfs/nfs4xdr.c                                   |   4 +-
 fs/nfs_common/Makefile                             |   2 +
 fs/nfs_common/common.c                             |  66 +++++++++++
 fs/nfsd/Kconfig                                    |   1 +
 fs/nfsd/blocklayout.c                              |   3 +-
 fs/nfsd/netns.h                                    |   2 +
 fs/nfsd/nfs3proc.c                                 |  10 +-
 fs/nfsd/nfs3xdr.c                                  |   5 +-
 fs/nfsd/nfs4proc.c                                 |  13 +--
 fs/nfsd/nfs4state.c                                |  44 ++++++-
 fs/nfsd/nfsctl.c                                   |   5 +-
 fs/nfsd/nfsd.h                                     |   1 -
 fs/nfsd/nfsproc.c                                  |   6 +-
 fs/nfsd/state.h                                    |   2 +-
 fs/nfsd/vfs.c                                      |  26 +++--
 fs/nfsd/vfs.h                                      |  11 +-
 fs/nfsd/xdr3.h                                     |   2 +-
 fs/smb/client/nterr.h                              |   6 +-
 include/linux/netdevice.h                          |   3 +-
 include/linux/nfs_common.h                         |  16 +++
 include/net/dst.h                                  |  12 ++
 include/net/netfilter/nf_tables.h                  |  34 ++++--
 include/trace/misc/nfs.h                           |   3 +-
 include/uapi/linux/nfs.h                           |   1 -
 lib/crypto/aes.c                                   |   4 +-
 mm/ksm.c                                           | 126 ++++++++++++++++++---
 net/bpf/test_run.c                                 |  60 ++++++----
 net/bridge/br_vlan_tunnel.c                        |  11 +-
 net/can/j1939/transport.c                          |   2 +
 net/ceph/messenger_v2.c                            |   2 +
 net/ceph/mon_client.c                              |   2 +-
 net/ceph/osd_client.c                              |  14 ++-
 net/ceph/osdmap.c                                  |  24 ++--
 net/core/skbuff.c                                  |   8 +-
 net/core/sock.c                                    |   7 +-
 net/ipv4/arp.c                                     |   7 +-
 net/ipv4/ip_output.c                               |  15 ++-
 net/ipv4/ping.c                                    |   4 +-
 net/netfilter/nf_conncount.c                       |   2 +-
 net/netfilter/nf_tables_api.c                      |  72 +++++++++++-
 net/netfilter/nft_synproxy.c                       |   6 +-
 net/sched/sch_qfq.c                                |   2 +-
 net/tls/tls_device.c                               |  18 +--
 net/wireless/wext-core.c                           |   4 +
 net/wireless/wext-priv.c                           |   4 +
 sound/ac97/bus.c                                   |  32 +++---
 sound/soc/amd/yc/acp6x-mach.c                      |   7 ++
 sound/soc/fsl/fsl_sai.c                            |   3 +
 sound/usb/quirks.c                                 |  10 ++
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     |  96 ++++++++++++++--
 .../bpf/prog_tests/xdp_context_test_run.c          |   4 +-
 .../bpf/progs/test_xdp_adjust_tail_grow.c          |   8 +-
 97 files changed, 1050 insertions(+), 525 deletions(-)


