Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327C81A4F19;
	Wed, 20 Nov 2024 12:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107513; cv=none; b=PkflU4QjPfSBZyBZbptQeLBKSm4FY/4X+YjnDXjQ/TF//GTg76VQMvK1Ghd+t03jOZyK1sR9y4XFuGaWhV3Da0QI8l6W5QtfFL8tRcdvY3PsQPq7pfYuBLFy/JHGj9HMsYfUDYbNSF5Giwp2DRgoqzsTn3+wDQ90t3z0BMm1qjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107513; c=relaxed/simple;
	bh=jmMlgelbgbeqSpOsk3A+ZLa6hLgmoIhyx6XOoBUTWDY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lEFuYps9d7RJju+uounmL8yhSXWdsvTDgZXUnhVd48jRTWREzlY1Cv0IZfQXYfNQspMNkG6fRhBhjXnyPrNYbH5Jikih9EkPzdvgi+8GVLAKZ4g/Y9JoM+iUUTG1Ka+yfVczsaGoyKxXeN1CAQ6D/KxOlMDENYpsBproESjiVHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMd/TvyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMd/TvyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFDAC4CECD;
	Wed, 20 Nov 2024 12:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107513;
	bh=jmMlgelbgbeqSpOsk3A+ZLa6hLgmoIhyx6XOoBUTWDY=;
	h=From:To:Cc:Subject:Date:From;
	b=JMd/TvyZUe1zyegweQGqxGbBu4mj7Eir/vd6TaEtzEPIAJ41PhLnxdsM3Sew0iF3C
	 kqVZrtFui7ToU80dzDkvI/xY89aaPcLr7SWFdAc9a+Rj/lO2S8+2U9fBIqrDl+0Z+3
	 AFUU4Y7GykXorGmB917Kinjzu3dejOWjuACswk3s=
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
Subject: [PATCH 6.11 000/107] 6.11.10-rc1 review
Date: Wed, 20 Nov 2024 13:55:35 +0100
Message-ID: <20241120125629.681745345@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.11.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.11.10-rc1
X-KernelTest-Deadline: 2024-11-22T12:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.11.10 release.
There are 107 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 22 Nov 2024 12:56:14 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.10-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.11.10-rc1

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: dvbdev: fix the logic when DVB_DYNAMIC_MINORS is not set

Alexandre Ferrieux <alexandre.ferrieux@gmail.com>
    net: sched: u32: Add test case for systematic hnode IDR leaks

Jiri Olsa <jolsa@kernel.org>
    lib/buildid: Fix build ID parsing logic

Matthew Auld <matthew.auld@intel.com>
    drm/xe: improve hibernation on igpu

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Restore system memory GGTT mappings

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm: refactor arch_calc_vm_flag_bits() and arm64 MTE handling

Hamish Claxton <hamishclaxton@gmail.com>
    drm/amd/display: Fix failure to read vram info due to static BP_RESULT

Ryan Seto <ryanseto@amd.com>
    drm/amd/display: Handle dml allocation failure to avoid crash

Dillon Varone <dillon.varone@amd.com>
    drm/amd/display: Require minimum VBlank size for stutter optimization

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Adjust VSDB parser for replay feature

Jack Xiao <Jack.Xiao@amd.com>
    drm/amdgpu/mes12: correct kiq unmap latency

Christian König <christian.koenig@amd.com>
    drm/amdgpu: enable GTT fallback handling for dGPUs only

Tim Huang <tim.huang@amd.com>
    drm/amd/pm: print pp_dpm_mclk in ascending order on SMU v14.0.0

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Fix video caps for H264 and HEVC encode maximum size

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix check in gmc_v9_0_get_vm_pte()

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    drm/amd: Fix initialization mistake for NBIO 7.7.0

Dave Airlie <airlied@redhat.com>
    nouveau/dp: handle retries for AUX CH transfers with GSP.

Dave Airlie <airlied@redhat.com>
    nouveau: handle EBUSY and EAGAIN for GSP aux errors.

Dave Airlie <airlied@redhat.com>
    nouveau: fw: sync dma after setup is called.

Sibi Sankar <quic_sibis@quicinc.com>
    pmdomain: core: Add GENPD_FLAG_DEV_NAME_FW flag

Sibi Sankar <quic_sibis@quicinc.com>
    pmdomain: arm: Use FLAG_DEV_NAME_FW to ensure unique names

Peng Fan <peng.fan@nxp.com>
    pmdomain: imx93-blk-ctrl: correct remove path

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/oa: Fix "Missing outer runtime PM protection" warning

Matthew Auld <matthew.auld@intel.com>
    drm/xe: handle flat ccs during hibernation on igpu

Francesco Dolcini <francesco.dolcini@toradex.com>
    drm/bridge: tc358768: Fix DSI command tx

Andre Przywara <andre.przywara@arm.com>
    mmc: sunxi-mmc: Fix A100 compatible description

Sibi Sankar <quic_sibis@quicinc.com>
    firmware: arm_scmi: Report duplicate opps as firmware bugs

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Skip opp duplicates

Sibi Sankar <quic_sibis@quicinc.com>
    mailbox: qcom-cpucp: Mark the irq with IRQF_NO_SUSPEND flag

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix incorrect comparison for delayed refs

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/amd/display: parse umc_info or vram_info based on ASIC"

Aurelien Jarno <aurelien@aurel32.net>
    Revert "mmc: dw_mmc: Fix IDMAC operation with pages bigger than 4K"

Donet Tom <donettom@linux.ibm.com>
    selftests: hugetlb_dio: fixup check for initial conditions to skip in the start

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Make KASAN work with 5-level page-tables

Bibo Mao <maobibo@loongson.cn>
    LoongArch: Fix AP booting issue in VM mode

Kanglong Wang <wangkanglong@loongson.cn>
    LoongArch: Add WriteCombine shadow mapping in KASAN

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Disable KASAN if PGDIR_SIZE is too large for cpu_vabits

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Fix early_numa_add_cpu() usage for FDT systems

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix null-ptr-deref in block_dirty_buffer tracepoint

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: fix UBSAN warning in ocfs2_verify_volume()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: use _rcu variant under rcu_read_lock

Geliang Tang <geliang@kernel.org>
    mptcp: hold pm lock when deleting entry

Geliang Tang <geliang@kernel.org>
    mptcp: update local address flags when setting it

Maksym Glubokiy <maxgl.kernel@gmail.com>
    ALSA: hda/realtek: fix mute/micmute LEDs for a HP EliteBook 645 G10

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - update set GPIO3 to default for Thinkpad with ALC1318

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Fixed Clevo platform headset Mic issue

Roman Gushchin <roman.gushchin@linux.dev>
    mm: page_alloc: move mlocked flag clearance into free_pages_prepare()

Jarkko Sakkinen <jarkko@kernel.org>
    tpm: Disable TPM on tpm2_create_primary() failure

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

Sean Christopherson <seanjc@google.com>
    KVM: selftests: Disable strict aliasing

Mateusz Guzik <mjguzik@gmail.com>
    evm: stop avoidably reading i_writecount in evm_file_release

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

Jann Horn <jannh@google.com>
    mm/mremap: fix address wraparound in move_page_tables()

Dan Carpenter <dan.carpenter@linaro.org>
    fs/proc/task_mmu: prevent integer overflow in pagemap_scan_get_args()

Qun-Wei Lin <qun-wei.lin@mediatek.com>
    sched/task_stack: fix object_is_on_stack() for KASAN tagged pointers

Dave Vasilevsky <dave@vasilevsky.ca>
    crash, powerpc: default to CRASH_DUMP=n on PPC_BOOK3S_32

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: uncache inode which has failed entering the group

Jinjiang Tu <tujinjiang@huawei.com>
    mm: fix NULL pointer dereference in alloc_pages_bulk_noprof

Ard Biesheuvel <ardb@kernel.org>
    x86/stackprotector: Work around strict Clang TLS symbol requirements

Baoquan He <bhe@redhat.com>
    x86/mm: Fix a kdump kernel failure on SME system when CONFIG_IMA_KEXEC=y

Mario Limonciello <mario.limonciello@amd.com>
    x86/CPU/AMD: Clear virtualized VMLOAD/VMSAVE on Zen4 client

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Fix Panel Replay not update screen correctly

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Change some variable name of psr

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: Run idle optimizations at end of vblank handler

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/amd/pm: correct the workload setting"

Motiejus JakÅ`tys <motiejus@jakstys.lt>
    tools/mm: fix compile error

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: fix cacheflush with PAN

Harith G <harith.g@alifsemi.com>
    ARM: 9419/1: mm: Fix kernel memory mapping for xip kernels

Hangbin Liu <liuhangbin@gmail.com>
    bonding: add ns target multicast address to slave device

Meghana Malladi <m-malladi@ti.com>
    net: ti: icssg-prueth: Fix 1 PPS sync

Chen Ridong <chenridong@huawei.com>
    drm/vmwgfx: avoid null_ptr_deref in vmw_framebuffer_surface_create_handle

Vitalii Mordan <mordan@ispras.ru>
    stmmac: dwmac-intel-plat: fix call balance of tx_clk handling routines

Michal Luczaj <mhal@rbox.co>
    net: Make copy_safe_from_sockptr() match documentation

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    net: stmmac: dwmac-mediatek: Fix inverted handling of mediatek,mac-wol

Wei Fang <wei.fang@nxp.com>
    samples: pktgen: correct dev to DEV

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: phylink: ensure PHY momentary link-fails are handled

Alexandre Ferrieux <alexandre.ferrieux@gmail.com>
    net: sched: cls_u32: Fix u32's systematic failure to free IDR entries for hnodes.

Akash Goel <akash.goel@arm.com>
    drm/panthor: Fix handling of partial GPU mapping of BOs

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel: Direct exception event to bluetooth stack

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix calling mgmt_device_connected

Alexandre Ghiti <alexghiti@rivosinc.com>
    drivers: perf: Fix wrong put_cpu() placement

Leon Romanovsky <leon@kernel.org>
    Revert "RDMA/core: Fix ENODEV error for iWARP test over vlan"

Michal Luczaj <mhal@rbox.co>
    virtio/vsock: Improve MSG_ZEROCOPY error handling

Michal Luczaj <mhal@rbox.co>
    vsock: Fix sk_error_queue memory leak

Michal Luczaj <mhal@rbox.co>
    virtio/vsock: Fix accept_queue memory leak

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/i915/gsc: ARL-H and ARL-U need a newer GSC FW.

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Disable loopback self-test on multi-PF netdev

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5e: CT: Fix null-ptr-deref in add rule err flow

William Tu <witu@nvidia.com>
    net/mlx5e: clear xdp features on non-uplink representors

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: kTLS, Fix incorrect page refcounting

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: fs, lock FTE when checking if active

Parav Pandit <parav@nvidia.com>
    net/mlx5: Fix msix vectors to respect platform limit

Paolo Abeni <pabeni@redhat.com>
    mptcp: cope racing subflow creation in mptcp_rcv_space_adjust

Paolo Abeni <pabeni@redhat.com>
    mptcp: error out earlier on disconnect

Wang Liang <wangliang74@huawei.com>
    net: fix data-races around sk->sk_forward_alloc

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
 arch/arm/Kconfig                                   |   3 +
 arch/arm/kernel/head.S                             |   8 +-
 arch/arm/kernel/traps.c                            |   3 +
 arch/arm/mm/mmu.c                                  |  34 +++---
 arch/arm64/Kconfig                                 |   3 +
 arch/arm64/include/asm/mman.h                      |  10 +-
 arch/loongarch/Kconfig                             |   3 +
 arch/loongarch/include/asm/kasan.h                 |  13 ++-
 arch/loongarch/kernel/paravirt.c                   |  15 +++
 arch/loongarch/kernel/smp.c                        |   2 +-
 arch/loongarch/mm/kasan_init.c                     |  46 +++++++-
 arch/mips/Kconfig                                  |   3 +
 arch/parisc/include/asm/mman.h                     |   5 +-
 arch/powerpc/Kconfig                               |   4 +
 arch/riscv/Kconfig                                 |   3 +
 arch/s390/Kconfig                                  |   3 +
 arch/sh/Kconfig                                    |   3 +
 arch/x86/Kconfig                                   |   3 +
 arch/x86/Makefile                                  |   5 +-
 arch/x86/entry/entry.S                             |  16 +++
 arch/x86/include/asm/asm-prototypes.h              |   3 +
 arch/x86/kernel/cpu/amd.c                          |  11 ++
 arch/x86/kernel/cpu/common.c                       |   2 +
 arch/x86/kernel/vmlinux.lds.S                      |   3 +
 arch/x86/kvm/lapic.c                               |  29 +++--
 arch/x86/kvm/vmx/nested.c                          |  30 +++++-
 arch/x86/kvm/vmx/vmx.c                             |   6 +-
 arch/x86/mm/ioremap.c                              |   6 +-
 drivers/bluetooth/btintel.c                        |   5 +-
 drivers/char/tpm/tpm2-sessions.c                   |   7 +-
 drivers/firmware/arm_scmi/perf.c                   |  44 +++++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   3 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |  13 ++-
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/nbio_v7_7.c             |   6 ++
 drivers/gpu/drm/amd/amdgpu/nv.c                    |  12 +--
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |   4 +-
 drivers/gpu/drm/amd/amdgpu/soc21.c                 |  12 +--
 drivers/gpu/drm/amd/amdgpu/soc24.c                 |   2 +-
 drivers/gpu/drm/amd/amdgpu/vi.c                    |   8 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 117 +++++++++++----------
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |   2 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |  17 +--
 .../amd/display/amdgpu_dm/amdgpu_dm_irq_params.h   |   2 +-
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c |   6 +-
 drivers/gpu/drm/amd/display/dc/core/dc_state.c     |   3 +
 .../dml2/dml21/src/dml2_pmo/dml2_pmo_dcn4_fams2.c  |  11 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |  49 +++------
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h      |   4 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c  |   5 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c    |   5 +-
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |   5 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c   |   4 +-
 drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c    |   4 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |  20 +---
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |   5 +-
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c   |   5 +-
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c   |   9 +-
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c             |   8 --
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h             |   2 -
 drivers/gpu/drm/bridge/tc358768.c                  |  21 +++-
 drivers/gpu/drm/i915/gt/uc/intel_gsc_fw.c          |  50 +++++----
 drivers/gpu/drm/i915/i915_drv.h                    |   8 +-
 drivers/gpu/drm/i915/intel_device_info.c           |  24 ++++-
 drivers/gpu/drm/i915/intel_device_info.h           |   4 +-
 drivers/gpu/drm/nouveau/nvkm/engine/disp/r535.c    |  61 ++++++-----
 drivers/gpu/drm/nouveau/nvkm/falcon/fw.c           |  11 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c     |   6 +-
 drivers/gpu/drm/panthor/panthor_mmu.c              |   2 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |   8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   2 +
 drivers/gpu/drm/xe/xe_bo.c                         |  43 ++++----
 drivers/gpu/drm/xe/xe_bo_evict.c                   |  20 ++--
 drivers/gpu/drm/xe/xe_oa.c                         |   2 +
 drivers/infiniband/core/addr.c                     |   2 -
 drivers/mailbox/qcom-cpucp-mbox.c                  |   2 +-
 drivers/media/dvb-core/dvbdev.c                    |  15 +--
 drivers/mmc/host/dw_mmc.c                          |   4 +-
 drivers/mmc/host/sunxi-mmc.c                       |   6 +-
 drivers/net/bonding/bond_main.c                    |  16 ++-
 drivers/net/bonding/bond_options.c                 |  82 ++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c  |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  19 +++-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |  32 +++++-
 .../net/ethernet/stmicro/stmmac/dwmac-intel-plat.c |  25 +++--
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c   |   4 +-
 drivers/net/ethernet/ti/icssg/icssg_prueth.c       |  13 ++-
 drivers/net/ethernet/ti/icssg/icssg_prueth.h       |  12 +++
 drivers/net/ethernet/vertexcom/mse102x.c           |   4 +-
 drivers/net/phy/phylink.c                          |  14 +--
 drivers/perf/riscv_pmu_sbi.c                       |   4 +-
 drivers/pmdomain/arm/scmi_perf_domain.c            |   3 +-
 drivers/pmdomain/core.c                            |  49 ++++++---
 drivers/pmdomain/imx/imx93-blk-ctrl.c              |   4 +-
 drivers/vdpa/mlx5/core/mr.c                        |   8 +-
 drivers/vdpa/solidrun/snet_main.c                  |  14 ++-
 drivers/vdpa/virtio_pci/vp_vdpa.c                  |  10 +-
 fs/btrfs/delayed-ref.c                             |   2 +-
 fs/nilfs2/btnode.c                                 |   2 -
 fs/nilfs2/gcinode.c                                |   4 +-
 fs/nilfs2/mdt.c                                    |   1 -
 fs/nilfs2/page.c                                   |   2 +-
 fs/ocfs2/resize.c                                  |   2 +
 fs/ocfs2/super.c                                   |  13 ++-
 fs/proc/task_mmu.c                                 |   4 +-
 include/drm/intel/i915_pciids.h                    |  19 +++-
 include/linux/mman.h                               |   7 +-
 include/linux/pm_domain.h                          |   6 ++
 include/linux/sched/task_stack.h                   |   2 +
 include/linux/sockptr.h                            |   4 +-
 include/net/bond_options.h                         |   2 +
 kernel/Kconfig.kexec                               |   2 +-
 lib/buildid.c                                      |   2 +-
 mm/mmap.c                                          |   2 +-
 mm/mremap.c                                        |   2 +-
 mm/nommu.c                                         |   4 +-
 mm/page_alloc.c                                    |  18 +++-
 mm/shmem.c                                         |   5 -
 mm/swap.c                                          |  14 ---
 net/bluetooth/hci_core.c                           |   2 -
 net/dccp/ipv6.c                                    |   2 +-
 net/ipv6/tcp_ipv6.c                                |   4 +-
 net/mptcp/pm_netlink.c                             |   3 +-
 net/mptcp/pm_userspace.c                           |  15 +++
 net/mptcp/protocol.c                               |  16 ++-
 net/netlink/af_netlink.c                           |  31 ++----
 net/netlink/af_netlink.h                           |   2 -
 net/sched/cls_u32.c                                |  18 +++-
 net/sctp/ipv6.c                                    |  19 ++--
 net/vmw_vsock/af_vsock.c                           |   3 +
 net/vmw_vsock/virtio_transport_common.c            |   9 ++
 samples/pktgen/pktgen_sample01_simple.sh           |   2 +-
 security/integrity/evm/evm_main.c                  |   3 +-
 security/integrity/ima/ima_template_lib.c          |  14 ++-
 sound/pci/hda/patch_realtek.c                      |  13 ++-
 tools/mm/page-types.c                              |   2 +-
 tools/testing/selftests/kvm/Makefile               |   8 +-
 tools/testing/selftests/mm/hugetlb_dio.c           |   7 ++
 .../selftests/tc-testing/tc-tests/filters/u32.json |  24 +++++
 143 files changed, 1080 insertions(+), 537 deletions(-)


