Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1731991AA;
	Wed, 20 Nov 2024 12:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107598; cv=none; b=L949IVqmsayYBRuREeM1cWCoSRUscvf5JWiMpAHMV9toa51OSGYrGYH5+ZaoGbczIMQdKthoJ2T+krxg5pXoh9a9QGUfCNDqBfJL01n51/g+kCCZnTWzvJ/H70f0uiFTuEpqnuZAlkj2payZtGsSgYAblhtfyNDTk7UjHhVBfgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107598; c=relaxed/simple;
	bh=vrC5Pah260xy7rmUcfZmWdXTz6T/FgretDHj1XxiN1g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lHbFOor0jnmH0LMftK+EXDnWf85QEs0SjkpcbKGiXZk6HyIl1vxM4aWN8MtCcDqWsL6xTat7+OEhSMAg9Qpv0bYElcaxo0W8+EaNSZlDzhrrIq/EDBKGxgM5D322+HKlq+J3ed3m9qncTdQyLNf8L5jhoog3sR399vRf3nqn9EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DAJzg03k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DAJzg03k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDB0C4CECD;
	Wed, 20 Nov 2024 12:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107598;
	bh=vrC5Pah260xy7rmUcfZmWdXTz6T/FgretDHj1XxiN1g=;
	h=From:To:Cc:Subject:Date:From;
	b=DAJzg03kzKQLHynLp5+aO29ZJEVuMFWCQ8MTwKrZcgIjhVelQDRNj+E0lbWs3mDn2
	 5h/CpnjrtE4HF4LPPiRCbQH3BmCWRGLUSbbfPtNLvlxC8TrVK2mCnyXvWC0Oz3pszp
	 JF1Ueaol3zpIdSDti0Q2kqHTZm6tpeqx27HdAd78=
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
Subject: [PATCH 6.6 00/82] 6.6.63-rc1 review
Date: Wed, 20 Nov 2024 13:56:10 +0100
Message-ID: <20241120125629.623666563@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.63-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.63-rc1
X-KernelTest-Deadline: 2024-11-22T12:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.63 release.
There are 82 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 22 Nov 2024 12:56:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.63-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.63-rc1

SeongJae Park <sj@kernel.org>
    mm/damon/core: copy nr_accesses when splitting region

SeongJae Park <sj@kernel.org>
    mm/damon/core: handle zero schemes apply interval

SeongJae Park <sj@kernel.org>
    mm/damon/core: check apply interval in damon_do_apply_schemes()

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm: resolve faulty mmap_region() error path behaviour

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm: refactor arch_calc_vm_flag_bits() and arm64 MTE handling

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm: refactor map_deny_write_exec()

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm: unconditionally close VMAs on error

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm: avoid unsafe VMA hook invocation when error arises on mmap hook

George Stark <gnstark@salutedevices.com>
    leds: mlxreg: Use devm_mutex_init() for mutex initialization

Eric Van Hensbergen <ericvh@kernel.org>
    fs/9p: fix uninitialized values during inode evict

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/amd/pm: Vangogh: Fix kernel memory out of bounds write

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: use _rcu variant under rcu_read_lock

Geliang Tang <tanggeliang@kylinos.cn>
    mptcp: drop lookup_by_id in lookup_addr

Geliang Tang <tanggeliang@kylinos.cn>
    mptcp: hold pm lock when deleting entry

Geliang Tang <tanggeliang@kylinos.cn>
    mptcp: update local address flags when setting it

Geliang Tang <tanggeliang@kylinos.cn>
    mptcp: add userspace_pm_lookup_addr_by_id helper

Geliang Tang <geliang.tang@suse.com>
    mptcp: define more local variables sk

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Never decrement pending_async_copies on error

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Initialize struct nfsd4_copy earlier

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Limit the number of concurrent async COPY operations

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Async COPY result needs to return a write verifier

Dai Ngo <dai.ngo@oracle.com>
    NFSD: initialize copy->cp_clp early in nfsd4_copy for use by trace point

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: dvbdev: fix the logic when DVB_DYNAMIC_MINORS is not set

Jiri Olsa <jolsa@kernel.org>
    lib/buildid: Fix build ID parsing logic

Umang Jain <umang.jain@ideasonboard.com>
    staging: vchiq_arm: Use devm_kzalloc() for vchiq_arm_state allocation

Stefan Wahren <wahrenst@gmx.net>
    staging: vchiq_arm: Get the rid off struct vchiq_2835_state

SeongJae Park <sj@kernel.org>
    mm/damon/core: handle zero {aggregation,ops_update} intervals

SeongJae Park <sj@kernel.org>
    mm/damon/core: implement scheme-specific apply interval

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Adjust VSDB parser for replay feature

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    drm/amd: Fix initialization mistake for NBIO 7.7.0

Dave Airlie <airlied@redhat.com>
    nouveau: fw: sync dma after setup is called.

Peng Fan <peng.fan@nxp.com>
    pmdomain: imx93-blk-ctrl: correct remove path

Francesco Dolcini <francesco.dolcini@toradex.com>
    drm/bridge: tc358768: Fix DSI command tx

Andre Przywara <andre.przywara@arm.com>
    mmc: sunxi-mmc: Fix A100 compatible description

Aurelien Jarno <aurelien@aurel32.net>
    Revert "mmc: dw_mmc: Fix IDMAC operation with pages bigger than 4K"

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Make KASAN work with 5-level page-tables

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Disable KASAN if PGDIR_SIZE is too large for cpu_vabits

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Fix early_numa_add_cpu() usage for FDT systems

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix null-ptr-deref in block_dirty_buffer tracepoint

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: fix UBSAN warning in ocfs2_verify_volume()

Maksym Glubokiy <maxgl.kernel@gmail.com>
    ALSA: hda/realtek: fix mute/micmute LEDs for a HP EliteBook 645 G10

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Fixed Clevo platform headset Mic issue

Hajime Tazaki <thehajime@gmail.com>
    nommu: pass NULL argument to vma_iter_prealloc()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix null-ptr-deref in block_touch_buffer tracepoint

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Bury Intel PT virtualization (guest/host mode) behind CONFIG_BROKEN

Sean Christopherson <seanjc@google.com>
    KVM: x86: Unconditionally set irr_pending when updating APICv state

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Treat vpid01 as current if L2 is active, but with VPID disabled

Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
    ima: fix buffer overrun in ima_eventdigest_init_common

Xiaoguang Wang <lege.wang@jaguarmicro.com>
    vp_vdpa: fix id_table array not null terminated error

Si-Wei Liu <si-wei.liu@oracle.com>
    vdpa/mlx5: Fix PA offset with unaligned starting iotlb map

Philipp Stanner <pstanner@redhat.com>
    vdpa: solidrun: Fix UB bug with devres

Andrew Morton <akpm@linux-foundation.org>
    mm: revert "mm: shmem: fix data-race in shmem_getattr()"

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: uncache inode which has failed entering the group

Jinjiang Tu <tujinjiang@huawei.com>
    mm: fix NULL pointer dereference in alloc_pages_bulk_noprof

Baoquan He <bhe@redhat.com>
    x86/mm: Fix a kdump kernel failure on SME system when CONFIG_IMA_KEXEC=y

Motiejus JakÅ`tys <motiejus@jakstys.lt>
    tools/mm: fix compile error

Harith G <harith.g@alifsemi.com>
    ARM: 9419/1: mm: Fix kernel memory mapping for xip kernels

Hangbin Liu <liuhangbin@gmail.com>
    bonding: add ns target multicast address to slave device

Meghana Malladi <m-malladi@ti.com>
    net: ti: icssg-prueth: Fix 1 PPS sync

Vitalii Mordan <mordan@ispras.ru>
    stmmac: dwmac-intel-plat: fix call balance of tx_clk handling routines

Jisheng Zhang <jszhang@kernel.org>
    net: stmmac: rename stmmac_pltfr_remove_no_dt to stmmac_pltfr_remove

Jisheng Zhang <jszhang@kernel.org>
    net: stmmac: dwmac-visconti: use devm_stmmac_probe_config_dt()

Jisheng Zhang <jszhang@kernel.org>
    net: stmmac: dwmac-intel-plat: use devm_stmmac_probe_config_dt()

Michal Luczaj <mhal@rbox.co>
    net: Make copy_safe_from_sockptr() match documentation

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    net: stmmac: dwmac-mediatek: Fix inverted handling of mediatek,mac-wol

Wei Fang <wei.fang@nxp.com>
    samples: pktgen: correct dev to DEV

Alexandre Ferrieux <alexandre.ferrieux@gmail.com>
    net: sched: cls_u32: Fix u32's systematic failure to free IDR entries for hnodes.

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: cls_u32: replace int refcounts with proper refcounts

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel: Direct exception event to bluetooth stack

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix calling mgmt_device_connected

Leon Romanovsky <leon@kernel.org>
    Revert "RDMA/core: Fix ENODEV error for iWARP test over vlan"

Michal Luczaj <mhal@rbox.co>
    virtio/vsock: Fix accept_queue memory leak

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5e: CT: Fix null-ptr-deref in add rule err flow

William Tu <witu@nvidia.com>
    net/mlx5e: clear xdp features on non-uplink representors

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: kTLS, Fix incorrect page refcounting

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: fs, lock FTE when checking if active

Paolo Abeni <pabeni@redhat.com>
    mptcp: cope racing subflow creation in mptcp_rcv_space_adjust

Paolo Abeni <pabeni@redhat.com>
    mptcp: error out earlier on disconnect

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop: Fix a dereferenced before check warning

Stefan Wahren <wahrenst@gmx.net>
    net: vertexcom: mse102x: Fix tx_bytes calculation

Eric Dumazet <edumazet@google.com>
    sctp: fix possible UAF in sctp_v6_available()

Jakub Kicinski <kuba@kernel.org>
    netlink: terminate outstanding dump on socket close


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/kernel/head.S                             |   8 +-
 arch/arm/mm/mmu.c                                  |  34 +++---
 arch/arm64/include/asm/mman.h                      |  10 +-
 arch/loongarch/include/asm/kasan.h                 |   2 +-
 arch/loongarch/kernel/smp.c                        |   2 +-
 arch/loongarch/mm/kasan_init.c                     |  41 ++++++-
 arch/parisc/include/asm/mman.h                     |   5 +-
 arch/x86/kvm/lapic.c                               |  29 +++--
 arch/x86/kvm/vmx/nested.c                          |  30 ++++-
 arch/x86/kvm/vmx/vmx.c                             |   6 +-
 arch/x86/mm/ioremap.c                              |   6 +-
 drivers/bluetooth/btintel.c                        |   5 +-
 drivers/gpu/drm/amd/amdgpu/nbio_v7_7.c             |   6 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c   |   7 +-
 drivers/gpu/drm/bridge/tc358768.c                  |  21 +++-
 drivers/gpu/drm/nouveau/nvkm/falcon/fw.c           |  11 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |   8 +-
 drivers/infiniband/core/addr.c                     |   2 -
 drivers/leds/leds-mlxreg.c                         |  16 +--
 drivers/media/dvb-core/dvbdev.c                    |  15 +--
 drivers/mmc/host/dw_mmc.c                          |   4 +-
 drivers/mmc/host/sunxi-mmc.c                       |   6 +-
 drivers/net/bonding/bond_main.c                    |  16 ++-
 drivers/net/bonding/bond_options.c                 |  82 ++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  19 ++-
 .../net/ethernet/stmicro/stmmac/dwmac-intel-plat.c |  40 +++----
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c   |   4 +-
 .../net/ethernet/stmicro/stmmac/dwmac-visconti.c   |  18 +--
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  25 +---
 .../net/ethernet/stmicro/stmmac/stmmac_platform.h  |   1 -
 drivers/net/ethernet/ti/icssg/icssg_prueth.c       |  13 ++-
 drivers/net/ethernet/ti/icssg/icssg_prueth.h       |  12 ++
 drivers/net/ethernet/vertexcom/mse102x.c           |   4 +-
 drivers/pmdomain/imx/imx93-blk-ctrl.c              |   4 +-
 .../vc04_services/interface/vchiq_arm/vchiq_arm.c  |  25 +---
 drivers/vdpa/mlx5/core/mr.c                        |   8 +-
 drivers/vdpa/solidrun/snet_main.c                  |  14 ++-
 drivers/vdpa/virtio_pci/vp_vdpa.c                  |  10 +-
 fs/9p/vfs_inode.c                                  |  17 +--
 fs/nfsd/netns.h                                    |   1 +
 fs/nfsd/nfs4proc.c                                 |  36 +++---
 fs/nfsd/nfs4state.c                                |   1 +
 fs/nfsd/xdr4.h                                     |   1 +
 fs/nilfs2/btnode.c                                 |   2 -
 fs/nilfs2/gcinode.c                                |   4 +-
 fs/nilfs2/mdt.c                                    |   1 -
 fs/nilfs2/page.c                                   |   2 +-
 fs/ocfs2/resize.c                                  |   2 +
 fs/ocfs2/super.c                                   |  13 ++-
 include/linux/damon.h                              |  17 ++-
 include/linux/mman.h                               |  28 ++++-
 include/linux/sockptr.h                            |   4 +-
 include/net/bond_options.h                         |   2 +
 lib/buildid.c                                      |   2 +-
 mm/damon/core.c                                    |  84 ++++++++++++--
 mm/damon/dbgfs.c                                   |   3 +-
 mm/damon/lru_sort.c                                |   2 +
 mm/damon/reclaim.c                                 |   2 +
 mm/damon/sysfs-schemes.c                           |   2 +-
 mm/internal.h                                      |  45 ++++++++
 mm/mmap.c                                          | 128 ++++++++++++---------
 mm/mprotect.c                                      |   2 +-
 mm/nommu.c                                         |  11 +-
 mm/page_alloc.c                                    |   3 +-
 mm/shmem.c                                         |   5 -
 net/bluetooth/hci_core.c                           |   2 -
 net/mptcp/pm_netlink.c                             |  15 ++-
 net/mptcp/pm_userspace.c                           |  77 ++++++++-----
 net/mptcp/protocol.c                               |  16 ++-
 net/netlink/af_netlink.c                           |  31 ++---
 net/netlink/af_netlink.h                           |   2 -
 net/sched/cls_u32.c                                |  54 +++++----
 net/sctp/ipv6.c                                    |  19 ++-
 net/vmw_vsock/virtio_transport_common.c            |   8 ++
 samples/pktgen/pktgen_sample01_simple.sh           |   2 +-
 security/integrity/ima/ima_template_lib.c          |  14 ++-
 sound/pci/hda/patch_realtek.c                      |   3 +
 tools/mm/page-types.c                              |   2 +-
 83 files changed, 824 insertions(+), 429 deletions(-)


