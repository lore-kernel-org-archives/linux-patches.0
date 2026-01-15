Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA0B29ACDD;
	Thu, 15 Jan 2026 17:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496503; cv=none; b=BDjgN3qbSUWh6EOouGcNa5H5Q9dQXs72IqENxr5xR7sgNQ+odl+XWgc0Labf+4DYhQ7iJf5/re+Xqu6Ak1LsDpLeqdIKw9GVFDEZ/tDgTGZoCYySJgNXJSuzBRrcOsNROBXJPWmkPyfLPcbjy1otEb7UUq96keZoWG7ttmm2lRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496503; c=relaxed/simple;
	bh=dBW10uyVvLVXV0tNOdcwXo/C3MyhGW114hoyWCGPrxM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DqjCuQxofgSwflltRSobgt5lMZ7jbRJlyFgI5ga6BRJpEFNgDdsrLx1u3fsCV3JkyljjvJxw69i6nu2LCaUskYWfGs2dMZQqKhGn7U3tYF05sFUVq01kBfx1Bv6hUubfvmw7nTkIcnsVD+WAKQE6yk02Z4u+t6ticYgIK9CqaZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHpuewWo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHpuewWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6935C116D0;
	Thu, 15 Jan 2026 17:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496503;
	bh=dBW10uyVvLVXV0tNOdcwXo/C3MyhGW114hoyWCGPrxM=;
	h=From:To:Cc:Subject:Date:From;
	b=dHpuewWo3n+L6bwAUOmqdxpSqT6c+W4RLu/l5F7Ou2VNiottiJStvLKUwj5pDvyTN
	 MU9X14GX51g36ujBUGATQHWBKgK8vhTBPbAqiy3sezQor4qYHNyYUbmhW23FIqOhS6
	 2mbQFezJi9AQ8lgjpwFcnzWIc1tQ1f16jMM6/Viw=
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
Subject: [PATCH 6.12 000/119] 6.12.66-rc1 review
Date: Thu, 15 Jan 2026 17:46:55 +0100
Message-ID: <20260115164151.948839306@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.66-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.66-rc1
X-KernelTest-Deadline: 2026-01-17T16:41+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.66 release.
There are 119 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.66-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.66-rc1

Shardul Bankar <shardulsb08@gmail.com>
    bpf: test_run: Fix ctx leak in bpf_prog_test_run_xdp error path

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: intel-dsp-config: Prefer legacy driver as fallback

Jarkko Sakkinen <jarkko@kernel.org>
    tpm2-sessions: Fix out of range indexing in name_size

Mateusz Litwin <mateusz.litwin@nokia.com>
    spi: cadence-quadspi: Prevent lost complete() call during indirect read

Michal Rábek <mrabek@redhat.com>
    scsi: sg: Fix occasional bogus elapsed time that exceeds timeout

Alexander Stein <alexander.stein@ew.tq-group.com>
    ASoC: fsl_sai: Add missing registers to cache default

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/realtek: enable woofer speakers on Medion NM14LNL

Andrew Elantsev <elantsew.andrew@gmail.com>
    ASoC: amd: yc: Add quirk for Honor MagicBook X16 2025

Jussi Laako <jussi@sonarnerd.net>
    ALSA: usb-audio: Update for native DSD support quirks

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: make j1939_session_activate() fail if device is no longer registered

Brian Kocoloski <brian.kocoloski@amd.com>
    drm/amdkfd: Fix improper NULL termination of queue restore SMI event string

Fei Shao <fshao@chromium.org>
    spi: mt65xx: Use IRQF_ONESHOT with threaded IRQ

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: Fix DP no audio issue

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Disable LPM on ST2000DM008-2FR102

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: avoid chain re-validation if possible

Sumeet Pawnikar <sumeet4linux@gmail.com>
    powercap: fix sscanf() error return value handling

Sumeet Pawnikar <sumeet4linux@gmail.com>
    powercap: fix race condition in register_control_type()

Marcus Hughes <marcus.hughes@betterinternet.ltd>
    net: sfp: extend Potron XGSPON quirk to cover additional EEPROM variant

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

Qu Wenruo <wqu@suse.com>
    btrfs: fix beyond-EOF write handling

Filipe Manana <fdmanana@suse.com>
    btrfs: use variable for end offset in extent_writepage_io()

Filipe Manana <fdmanana@suse.com>
    btrfs: truncate ordered extent when skipping writeback past i_size

Qu Wenruo <wqu@suse.com>
    btrfs: remove btrfs_fs_info::sectors_per_page

Qu Wenruo <wqu@suse.com>
    btrfs: add extra error messages for delalloc range related errors

Qu Wenruo <wqu@suse.com>
    btrfs: subpage: dump the involved bitmap when ASSERT() failed

Qu Wenruo <wqu@suse.com>
    btrfs: fix error handling of submit_uncompressed_range()

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    ALSA: ac97: fix a double free in snd_ac97_controller_register()

Takashi Iwai <tiwai@suse.de>
    ALSA: ac97bus: Use guard() for mutex locks

Gao Xiang <xiang@kernel.org>
    erofs: fix file-backed mounts no longer working on EROFS partitions

Gao Xiang <xiang@kernel.org>
    erofs: don't bother with s_stack_depth increasing for now

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

Yohei Kojima <yk@y-koj.net>
    net: netdevsim: fix inconsistent carrier state after link/unlink

Joshua Hay <joshua.a.hay@intel.com>
    idpf: cap maximum Rx buffer size

Emil Tantilov <emil.s.tantilov@intel.com>
    idpf: fix memory leak in idpf_vport_rel()

Emil Tantilov <emil.s.tantilov@intel.com>
    idpf: keep the netdev when a reset fails

Mohammad Heib <mheib@redhat.com>
    net: fix memory leak in skb_segment_list for GRO packets

Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
    riscv: pgtable: Cleanup useless VA_USER_XXX definitions

Qu Wenruo <wqu@suse.com>
    btrfs: only enforce free space tree if v1 cache is required for bs < ps cases

Michal Luczaj <mhal@rbox.co>
    vsock: Make accept()ed sockets use custom setsockopt()

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

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nft_synproxy: avoid possible data-race on update operation

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: fix range overlap detection

Alexander Stein <alexander.stein@ew.tq-group.com>
    arm64: dts: mba8mx: Fix Ethernet PHY IRQ support

Sherry Sun <sherry.sun@nxp.com>
    arm64: dts: imx8qm-ss-dma: correct the dma channels of lpuart

Marek Vasut <marek.vasut@mailbox.org>
    arm64: dts: imx8mp: Fix LAN8740Ai PHY reference clock on DH electronics i.MX8M Plus DHCOM

Ian Ray <ian.ray@gehealthcare.com>
    ARM: dts: imx6q-ba16: fix RTC interrupt level

Haibo Chen <haibo.chen@nxp.com>
    arm64: dts: add off-on-delay-us for usdhc2 regulator

Harshita Bhilwaria <harshita.bhilwaria@intel.com>
    crypto: qat - fix duplicate restarting msg during AER error

Wadim Egorov <w.egorov@phytec.de>
    arm64: dts: ti: k3-am62-lp-sk-nand: Rename pinctrls to fix schema warnings

Nathan Chancellor <nathan@kernel.org>
    drm/amd/display: Apply e4479aecf658 to dml

Nathan Chancellor <nathan@kernel.org>
    drm/amd/display: Respect user's CONFIG_FRAME_WARN more for dml files

Miquel Sabaté Solà <mssola@mssola.com>
    btrfs: fix NULL dereference on root when tracing inode eviction

Filipe Manana <fdmanana@suse.com>
    btrfs: tracepoints: use btrfs_root_id() to get the id of a root

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: update all parent qgroups when doing quick inherit

Boris Burkov <boris@bur.io>
    btrfs: fix qgroup_snapshot_quick_inherit() squota bug

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

Rosen Penev <rosenp@gmail.com>
    drm/amd/display: shrink struct members

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix up the automount fs_context to use the correct cred

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    ASoC: rockchip: Fix Wvoid-pointer-to-enum-cast warning (again)

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

Xin Wang <x.wang@intel.com>
    drm/xe: Ensure GT is in C0 during resumes

Xin Wang <x.wang@intel.com>
    drm/xe: make xe_gt_idle_disable_c6() handle the forcewake internally

Kuniyuki Iwashima <kuniyu@google.com>
    tls: Use __sk_dst_get() and dst_dev_rcu() in get_netdev_for_sock().

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

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: restore non-chanctx injection behaviour

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

Alan Liu <haoping.liu@amd.com>
    drm/amdgpu: Fix query for VPE block_type and ip_count

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

Yeoreum Yun <yeoreum.yun@arm.com>
    arm64: Fix cleared E0POE bit after cpu_suspend()/resume()

Thomas Fourier <fourier.thomas@gmail.com>
    net: 3com: 3c59x: fix possible null dereference in vortex_probe1()

Thomas Fourier <fourier.thomas@gmail.com>
    atm: Fix dma_free_coherent() size

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Remove NFSERR_EAGAIN

Edward Adam Davis <eadavis@qq.com>
    NFSD: net ref data still needs to be freed even if net hasn't startup

Olga Kornievskaia <okorniev@redhat.com>
    nfsd: check that server is running in unlock_filesystem

NeilBrown <neil@brown.name>
    nfsd: use correct loop termination in nfsd4_revoke_states()

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
 arch/arm64/boot/dts/freescale/imx8qm-ss-dma.dtsi   |   8 +-
 arch/arm64/boot/dts/freescale/mba8mx.dtsi          |   2 +-
 arch/arm64/boot/dts/ti/k3-am62-lp-sk-nand.dtso     |   2 +-
 arch/arm64/include/asm/suspend.h                   |   2 +-
 arch/arm64/mm/proc.S                               |   8 ++
 arch/csky/mm/fault.c                               |   4 +-
 arch/riscv/include/asm/pgtable.h                   |   4 -
 drivers/ata/libata-core.c                          |   3 +
 drivers/atm/he.c                                   |   3 +-
 drivers/char/tpm/tpm2-cmd.c                        |  23 +++-
 drivers/char/tpm/tpm2-sessions.c                   | 114 ++++++++++++------
 drivers/counter/104-quad-8.c                       |  20 +++-
 drivers/counter/interrupt-cnt.c                    |   3 +-
 drivers/crypto/intel/qat/qat_common/adf_aer.c      |   2 -
 drivers/gpio/gpio-pca953x.c                        |  55 ++++++++-
 drivers/gpio/gpio-rockchip.c                       |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |   6 +
 drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c        |   2 +-
 drivers/gpu/drm/amd/display/dc/dml/Makefile        |  18 ++-
 drivers/gpu/drm/amd/display/dc/dml2/Makefile       |  22 ++--
 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c  |  11 +-
 drivers/gpu/drm/amd/display/include/audio_types.h  |  14 +--
 drivers/gpu/drm/pl111/pl111_drv.c                  |   2 +-
 drivers/gpu/drm/radeon/pptable.h                   |   2 +-
 drivers/gpu/drm/xe/xe_gt_idle.c                    |  20 ++--
 drivers/gpu/drm/xe/xe_gt_idle.h                    |   2 +-
 drivers/gpu/drm/xe/xe_guc_pc.c                     |  10 +-
 drivers/gpu/drm/xe/xe_pm.c                         |   8 +-
 drivers/hid/hid-quirks.c                           |   9 ++
 drivers/md/dm-exception-store.h                    |   2 +-
 drivers/md/dm-snap.c                               |  73 ++++++------
 drivers/misc/mei/hw-me-regs.h                      |   2 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/net/ethernet/3com/3c59x.c                  |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  15 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   4 +-
 drivers/net/ethernet/freescale/enetc/enetc.h       |   4 +-
 drivers/net/ethernet/intel/idpf/idpf_lib.c         |  19 ++-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        |   8 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.h        |   1 +
 .../ethernet/marvell/prestera/prestera_devlink.c   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |   3 +-
 drivers/net/ethernet/mscc/ocelot.c                 |   6 +-
 drivers/net/netdevsim/bus.c                        |   8 ++
 drivers/net/phy/sfp.c                              |   2 +
 drivers/net/usb/pegasus.c                          |   2 +
 drivers/net/wwan/iosm/iosm_ipc_mux.c               |   6 +
 drivers/pinctrl/qcom/pinctrl-lpass-lpi.c           |   2 +-
 drivers/powercap/powercap_sys.c                    |  22 ++--
 drivers/scsi/ipr.c                                 |  28 ++++-
 drivers/scsi/libsas/sas_internal.h                 |  14 ---
 drivers/scsi/sg.c                                  |  20 ++--
 drivers/spi/spi-cadence-quadspi.c                  |  10 +-
 drivers/spi/spi-mt65xx.c                           |   2 +-
 drivers/ufs/core/ufshcd.c                          |  40 +++++--
 fs/btrfs/disk-io.c                                 |   1 -
 fs/btrfs/extent_io.c                               |  68 ++++++++---
 fs/btrfs/fs.h                                      |   7 +-
 fs/btrfs/inode.c                                   |  29 ++---
 fs/btrfs/ordered-data.c                            |   5 +-
 fs/btrfs/qgroup.c                                  |  21 +++-
 fs/btrfs/subpage.c                                 | 129 ++++++++++++++-------
 fs/btrfs/super.c                                   |  12 +-
 fs/btrfs/tree-log.c                                |   6 +-
 fs/erofs/super.c                                   |  19 ++-
 fs/nfs/namespace.c                                 |   5 +
 fs/nfs/nfs4proc.c                                  |  13 ++-
 fs/nfs/nfs4trace.h                                 |   1 +
 fs/nfs_common/common.c                             |   1 -
 fs/nfsd/netns.h                                    |   2 +
 fs/nfsd/nfs4proc.c                                 |   2 +-
 fs/nfsd/nfs4state.c                                |  49 +++++++-
 fs/nfsd/nfsctl.c                                   |  12 +-
 fs/nfsd/nfsd.h                                     |   1 -
 fs/nfsd/nfssvc.c                                   |  28 ++---
 fs/nfsd/state.h                                    |   6 +-
 fs/nfsd/vfs.c                                      |   4 +-
 fs/smb/client/nterr.h                              |   6 +-
 include/linux/netdevice.h                          |   3 +-
 include/linux/tpm.h                                |  13 ++-
 include/net/netfilter/nf_tables.h                  |  34 ++++--
 include/trace/events/btrfs.h                       |  51 ++++----
 include/trace/misc/nfs.h                           |   2 -
 include/uapi/linux/nfs.h                           |   1 -
 lib/crypto/aes.c                                   |   4 +-
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
 net/ipv4/ping.c                                    |   4 +-
 net/mac80211/tx.c                                  |   2 +
 net/netfilter/nf_conncount.c                       |   2 +-
 net/netfilter/nf_tables_api.c                      |  72 +++++++++++-
 net/netfilter/nft_set_pipapo.c                     |   4 +-
 net/netfilter/nft_synproxy.c                       |   6 +-
 net/sched/sch_qfq.c                                |   2 +-
 net/tls/tls_device.c                               |  18 +--
 net/vmw_vsock/af_vsock.c                           |   4 +
 net/wireless/wext-core.c                           |   4 +
 net/wireless/wext-priv.c                           |   4 +
 security/keys/trusted-keys/trusted_tpm2.c          |  29 ++++-
 sound/ac97/bus.c                                   |  32 +++--
 sound/hda/intel-dsp-config.c                       |   3 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/amd/yc/acp6x-mach.c                      |   7 ++
 sound/soc/fsl/fsl_sai.c                            |   3 +
 sound/soc/rockchip/rockchip_pdm.c                  |   2 +-
 sound/usb/quirks.c                                 |  10 ++
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     |  96 +++++++++++++--
 .../bpf/prog_tests/xdp_context_test_run.c          |   4 +-
 .../bpf/progs/test_xdp_adjust_tail_grow.c          |   8 +-
 123 files changed, 1164 insertions(+), 522 deletions(-)


