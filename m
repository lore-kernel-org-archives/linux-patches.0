Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FA21DFEF;
	Wed, 20 Nov 2024 13:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107669; cv=none; b=kaE3d63WYlfyzA11B6ajWqYTcGV5flxQgcKoB30iqAFhzHh+D6ffOMAgYPi1najp5WxHxjSIlymvtQALXjO+kNSTN9zYWDhquvRw1Mt/wfNt3CyrOhlaeNDNpxQ2eAvSr17ATYRpEj0xAzd7hRgtio4NU2WoVYjg80fdGf/17p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107669; c=relaxed/simple;
	bh=RIud3tY6QQzX67nCk6FvsLvLyYOaaCOW3dMmAWKFaiA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HGEZEbuJ3auIbLOnWs1zgbm+6d+wi+/ZhawNYrAV5NOfpsEvO36dyxaRo/DotPPkA/lAuuezmrXmnyGOYpTCn8ba+P2wbU9z7RCFdaODptcmHchaDHkDG5SXJ2cBomP+6FWrzOB1nb5q3i3fIW0VojXBHSIgTE3x2oNGCpI1trc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGhAg+I6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGhAg+I6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A55C4CECD;
	Wed, 20 Nov 2024 13:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107669;
	bh=RIud3tY6QQzX67nCk6FvsLvLyYOaaCOW3dMmAWKFaiA=;
	h=From:To:Cc:Subject:Date:From;
	b=VGhAg+I6hpZ7u2dnG+6Y4wz8IJqwYP4pt760u6dFa6kNLbKrb8L1d6E84VxajSh79
	 OkRTUtAYf5mOhHchxJvJ9YVTvWUYK+327gFHzg62kMQAXJeObEvPU4BWaguF4UFy2h
	 M4M87BUmA31gWcX5xloDOzGyqpm8JOwNO3T5Uv0U=
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
Subject: [PATCH 6.1 00/73] 6.1.119-rc1 review
Date: Wed, 20 Nov 2024 13:57:46 +0100
Message-ID: <20241120125809.623237564@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.119-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.119-rc1
X-KernelTest-Deadline: 2024-11-22T12:58+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.119 release.
There are 73 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 22 Nov 2024 12:57:58 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.119-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.119-rc1

Michal Luczaj <mhal@rbox.co>
    net: Make copy_safe_from_sockptr() match documentation

Eli Billauer <eli.billauer@gmail.com>
    char: xillybus: Fix trivial bug with mutex

Mikulas Patocka <mpatocka@redhat.com>
    parisc: fix a possible DMA corruption

Damien Le Moal <dlemoal@kernel.org>
    null_blk: Fix return value of nullb_device_power_store()

Yu Kuai <yukuai3@huawei.com>
    null_blk: fix null-ptr-dereference while configuring 'power' and 'submit_queues'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    null_blk: Remove usage of the deprecated ida_simple_xx() API

Eli Billauer <eli.billauer@gmail.com>
    char: xillybus: Prevent use-after-free due to race condition

Lin.Cao <lincao12@amd.com>
    drm/amd: check num of link levels when update pcie param

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm: resolve faulty mmap_region() error path behaviour

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm: refactor arch_calc_vm_flag_bits() and arm64 MTE handling

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm: unconditionally close VMAs on error

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm: avoid unsafe VMA hook invocation when error arises on mmap hook

Andrew Morton <akpm@linux-foundation.org>
    mm: revert "mm: shmem: fix data-race in shmem_getattr()"

Wei Fang <wei.fang@nxp.com>
    net: fec: remove .ndo_poll_controller to avoid deadlocks

Vladimir Oltean <vladimir.oltean@nxp.com>
    net/sched: taprio: extend minimum interval restriction to entire cycle too

Chen Hanxiao <chenhx.fnst@fujitsu.com>
    ipvs: properly dereference pe in ip_vs_add_service

Eric Van Hensbergen <ericvh@kernel.org>
    fs/9p: fix uninitialized values during inode evict

Eric Dumazet <edumazet@google.com>
    nfc: llcp: fix nfc_llcp_setsockopt() unsafe copies

Eric Dumazet <edumazet@google.com>
    net: add copy_safe_from_sockptr() helper

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix potencial out-of-bounds when buffer offset is invalid

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix slab-out-of-bounds in smb_strndup_from_utf16()

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

Paolo Abeni <pabeni@redhat.com>
    mptcp: cope racing subflow creation in mptcp_rcv_space_adjust

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

Dan Carpenter <dan.carpenter@linaro.org>
    cxl/pci: fix error code in __cxl_hdm_decode_init()

Jiri Olsa <jolsa@kernel.org>
    lib/buildid: Fix build ID parsing logic

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Fix not validating setsockopt user input

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Additional check in ntfs_file_release

Umang Jain <umang.jain@ideasonboard.com>
    staging: vchiq_arm: Use devm_kzalloc() for vchiq_arm_state allocation

Stefan Wahren <wahrenst@gmx.net>
    staging: vchiq_arm: Get the rid off struct vchiq_2835_state

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    drm/amd: Fix initialization mistake for NBIO 7.7.0

Francesco Dolcini <francesco.dolcini@toradex.com>
    drm/bridge: tc358768: Fix DSI command tx

Andre Przywara <andre.przywara@arm.com>
    mmc: sunxi-mmc: Fix A100 compatible description

Aurelien Jarno <aurelien@aurel32.net>
    Revert "mmc: dw_mmc: Fix IDMAC operation with pages bigger than 4K"

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix null-ptr-deref in block_dirty_buffer tracepoint

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: fix UBSAN warning in ocfs2_verify_volume()

Maksym Glubokiy <maxgl.kernel@gmail.com>
    ALSA: hda/realtek: fix mute/micmute LEDs for a HP EliteBook 645 G10

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Fixed Clevo platform headset Mic issue

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

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: uncache inode which has failed entering the group

Jinjiang Tu <tujinjiang@huawei.com>
    mm: fix NULL pointer dereference in alloc_pages_bulk_noprof

Baoquan He <bhe@redhat.com>
    x86/mm: Fix a kdump kernel failure on SME system when CONFIG_IMA_KEXEC=y

Harith G <harith.g@alifsemi.com>
    ARM: 9419/1: mm: Fix kernel memory mapping for xip kernels

Hangbin Liu <liuhangbin@gmail.com>
    bonding: add ns target multicast address to slave device

Wei Fang <wei.fang@nxp.com>
    samples: pktgen: correct dev to DEV

Alexandre Ferrieux <alexandre.ferrieux@gmail.com>
    net: sched: cls_u32: Fix u32's systematic failure to free IDR entries for hnodes.

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: cls_u32: replace int refcounts with proper refcounts

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix calling mgmt_device_connected

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    Bluetooth: hci_event: Remove code to removed CONFIG_BT_HS

Michal Luczaj <mhal@rbox.co>
    virtio/vsock: Fix accept_queue memory leak

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5e: CT: Fix null-ptr-deref in add rule err flow

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: kTLS, Fix incorrect page refcounting

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: fs, lock FTE when checking if active

Paolo Abeni <pabeni@redhat.com>
    mptcp: error out earlier on disconnect

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop: Fix a dereferenced before check warning

Stefan Wahren <wahrenst@gmx.net>
    net: vertexcom: mse102x: Fix tx_bytes calculation

Jakub Kicinski <kuba@kernel.org>
    netlink: terminate outstanding dump on socket close


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/kernel/head.S                             |   8 +-
 arch/arm/mm/mmu.c                                  |  34 +++--
 arch/arm64/include/asm/mman.h                      |  10 +-
 arch/parisc/Kconfig                                |   1 +
 arch/parisc/include/asm/cache.h                    |  11 +-
 arch/x86/kvm/lapic.c                               |  29 ++--
 arch/x86/kvm/vmx/nested.c                          |  30 +++-
 arch/x86/kvm/vmx/vmx.c                             |   6 +-
 arch/x86/mm/ioremap.c                              |   6 +-
 drivers/block/null_blk/main.c                      |  45 ++++--
 drivers/char/xillybus/xillybus_class.c             |   7 +-
 drivers/char/xillybus/xillyusb.c                   |  22 ++-
 drivers/cxl/core/pci.c                             |   2 +-
 drivers/gpu/drm/amd/amdgpu/nbio_v7_7.c             |   6 +
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c     |   3 +
 drivers/gpu/drm/bridge/tc358768.c                  |  21 ++-
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |   8 +-
 drivers/media/dvb-core/dvbdev.c                    |  15 +-
 drivers/mmc/host/dw_mmc.c                          |   4 +-
 drivers/mmc/host/sunxi-mmc.c                       |   6 +-
 drivers/net/bonding/bond_main.c                    |  16 +-
 drivers/net/bonding/bond_options.c                 |  82 ++++++++++-
 drivers/net/ethernet/freescale/fec_main.c          |  26 ----
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  19 ++-
 drivers/net/ethernet/vertexcom/mse102x.c           |   4 +-
 .../vc04_services/interface/vchiq_arm/vchiq_arm.c  |  25 +---
 drivers/vdpa/mlx5/core/mr.c                        |   8 +-
 drivers/vdpa/virtio_pci/vp_vdpa.c                  |  10 +-
 fs/9p/vfs_inode.c                                  |  23 +--
 fs/nfsd/netns.h                                    |   1 +
 fs/nfsd/nfs4proc.c                                 |  36 +++--
 fs/nfsd/nfs4state.c                                |   1 +
 fs/nfsd/xdr4.h                                     |   1 +
 fs/nilfs2/btnode.c                                 |   2 -
 fs/nilfs2/gcinode.c                                |   4 +-
 fs/nilfs2/mdt.c                                    |   1 -
 fs/nilfs2/page.c                                   |   2 +-
 fs/ntfs3/file.c                                    |  12 +-
 fs/ocfs2/resize.c                                  |   2 +
 fs/ocfs2/super.c                                   |  13 +-
 fs/smb/server/smb2misc.c                           |  26 +++-
 fs/smb/server/smb2pdu.c                            |  48 +++---
 include/linux/mman.h                               |   7 +-
 include/linux/sockptr.h                            |  27 ++++
 include/net/bond_options.h                         |   2 +
 lib/buildid.c                                      |   2 +-
 mm/internal.h                                      |  19 +++
 mm/mmap.c                                          | 120 ++++++++-------
 mm/nommu.c                                         |   9 +-
 mm/page_alloc.c                                    |   3 +-
 mm/shmem.c                                         |   5 -
 mm/util.c                                          |  33 +++++
 net/bluetooth/hci_core.c                           |   2 -
 net/bluetooth/hci_event.c                          | 163 ---------------------
 net/bluetooth/iso.c                                |  32 ++--
 net/mptcp/pm_netlink.c                             |  15 +-
 net/mptcp/pm_userspace.c                           |  77 ++++++----
 net/mptcp/protocol.c                               |  16 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |  10 +-
 net/netlink/af_netlink.c                           |  31 +---
 net/netlink/af_netlink.h                           |   2 -
 net/nfc/llcp_sock.c                                |  12 +-
 net/sched/cls_u32.c                                |  54 ++++---
 net/sched/sch_taprio.c                             |  10 +-
 net/vmw_vsock/virtio_transport_common.c            |   8 +
 samples/pktgen/pktgen_sample01_simple.sh           |   2 +-
 security/integrity/ima/ima_template_lib.c          |  14 +-
 sound/pci/hda/patch_realtek.c                      |   3 +
 .../tc-testing/tc-tests/qdiscs/taprio.json         |  22 +++
 72 files changed, 763 insertions(+), 587 deletions(-)


