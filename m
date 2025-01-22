Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FE4196;
	Wed, 22 Jan 2025 09:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737538254; cv=none; b=ujOyHUlAYOydxFL/EG9R6kGtNAW4yKLFOyOzpbl/tSmtLB3Bysd53+aCvsyzhKwTXuYqmaI7931vksw3xSXr1ukWLUnhFVPchIXyzFSHS1QGrnkExbMp6l2NyWjcr9jy5bWTlzsGbNPBLXwYMLdnaR8dmp2/u5enFiET6j8Pd0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737538254; c=relaxed/simple;
	bh=Pbm+jw6qcfUqSqwHzOIKqbuWFWgKKAmRVq2Yv5/bfOM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=J/87qNt+Th1V5icTGaEuaV8zP6Q5W0v5OwG3K/HR6FVJKalW5rdzO5lQLSjprjohhC0GQt+cUoHIWrsdLATD4HdtUIRxcPJmkiU2m279S+OgRjtiMWHDjA9hIILDBOcqQMbSzjpAol8DPmlTn9yAmA1DhECLLYWmCWvhH0goLfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MKJCCnuy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKJCCnuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515C6C4CED6;
	Wed, 22 Jan 2025 09:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737538253;
	bh=Pbm+jw6qcfUqSqwHzOIKqbuWFWgKKAmRVq2Yv5/bfOM=;
	h=From:To:Cc:Subject:Date:From;
	b=MKJCCnuyqDiScrZ861dyem7NxUQa3C5gb0u8k5nAWzi2WfvfOWF7M/9euqwI/fUM0
	 QsYA0R2Y3A5dB4ZJk45Z8Ik7MgWj+f9g5Ac6IJ+He9WReyAKLzOta3alCG8x0FHBHP
	 OM6mqMyToYQ0J6krnJTqxi13JfijEscX6DyM5Eqk=
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
Subject: [PATCH 6.12 000/121] 6.12.11-rc2 review
Date: Wed, 22 Jan 2025 10:30:49 +0100
Message-ID: <20250122093007.141759421@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.11-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.11-rc2
X-KernelTest-Deadline: 2025-01-24T09:30+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.11 release.
There are 121 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 24 Jan 2025 09:29:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.11-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.11-rc2

Ryan Lee <ryan.lee@canonical.com>
    apparmor: allocate xmatch for nullpdb inside aa_alloc_null

Wayne Lin <Wayne.Lin@amd.com>
    drm/amd/display: Validate mdoe under MST LCT=1 case as well

Nicholas Susanto <Nicholas.Susanto@amd.com>
    Revert "drm/amd/display: Enable urgent latency adjustments for DCN35"

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: Do not wait for PSR disable on vbl enable

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Disable replay and psr while VRR is enabled

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Fix PSR-SU not support but still call the amdgpu_dm_psr_enable

Christian König <christian.koenig@amd.com>
    drm/amdgpu: always sync the GFX pipe on ctx switch

Kenneth Feng <kenneth.feng@amd.com>
    drm/amdgpu: disable gfxoff with the compute workload on gfx12

Gui Chengming <Jack.Gui@amd.com>
    drm/amdgpu: fix fw attestation for MP0_14_0_{2/3}

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/smu13: update powersave optimizations

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/oa: Add missing VISACTL mux registers

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Mark ComputeCS read mode as UC on iGPU

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/fb: Relax clear color alignment to 64 bytes

Xin Li (Intel) <xin@zytor.com>
    x86/fred: Fix the FRED RSP0 MSR out of sync with its per-CPU cache

Frederic Weisbecker <frederic@kernel.org>
    timers/migration: Enforce group initialization visibility to tree walkers

Frederic Weisbecker <frederic@kernel.org>
    timers/migration: Fix another race between hotplug and idle entry/exit

Koichiro Den <koichiro.den@canonical.com>
    hrtimers: Handle CPU state correctly on hotplug

Tomas Krcka <krckatom@amazon.de>
    irqchip/gic-v3-its: Don't enable interrupts in its_irq_set_vcpu_affinity()

Yogesh Lal <quic_ylal@quicinc.com>
    irqchip/gic-v3: Handle CPU_PM_ENTER_FAILED correctly

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    irqchip: Plug a OF node reference leak in platform_irqchip_probe()

Steven Rostedt <rostedt@goodmis.org>
    tracing: gfp: Fix the GFP enum values shown for user space tracing tools

Donet Tom <donettom@linux.ibm.com>
    mm: vmscan : pgdemote vmstat is not getting updated when MGLRU is enabled.

Ryan Roberts <ryan.roberts@arm.com>
    mm: clear uffd-wp PTE/PMD state on mremap()

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: Do not elevate mem_type change to full update

Ryan Roberts <ryan.roberts@arm.com>
    selftests/mm: set allocated memory to non-zero content in cow test

Guo Weikang <guoweikang.kernel@gmail.com>
    mm/kmemleak: fix percpu memory leak detection failure

Xiaolei Wang <xiaolei.wang@windriver.com>
    pmdomain: imx8mp-blk-ctrl: add missing loop break condition

Suren Baghdasaryan <surenb@google.com>
    tools: fix atomic_set() definition to set the value correctly

Sean Anderson <sean.anderson@linux.dev>
    gpio: xilinx: Convert gpio_lock to raw spinlock

Rik van Riel <riel@surriel.com>
    fs/proc: fix softlockup in __read_vmcore (part 2)

Marco Nelissen <marco.nelissen@gmail.com>
    filemap: avoid truncating 64-bit offset to 32 bits

Paul Fertser <fercerpav@gmail.com>
    net/ncsi: fix locking in Get MAC Address handling

Takashi Iwai <tiwai@suse.de>
    drm/nouveau/disp: Fix missing backlight control on Macbook 5,1

Dave Airlie <airlied@redhat.com>
    nouveau/fence: handle cross device fences properly

Stefano Garzarella <sgarzare@redhat.com>
    vsock: prevent null-ptr-deref in vsock_*[has_data|has_space]

Stefano Garzarella <sgarzare@redhat.com>
    vsock: reset socket state when de-assigning the transport

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: cancel close work in the destructor

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: discard packets if the transport changes

Stefano Garzarella <sgarzare@redhat.com>
    vsock/bpf: return early if transport is not assigned

Heiner Kallweit <hkallweit1@gmail.com>
    net: ethernet: xgbe: re-add aneg to supported features in PHY quirks

Paolo Abeni <pabeni@redhat.com>
    selftests: mptcp: avoid spurious errors on disconnect

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix spurious wake-up on under memory pressure

Paolo Abeni <pabeni@redhat.com>
    mptcp: be sure to send ack when mptcp-level window re-opens

Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>
    i2c: atr: Fix client detach

Kairui Song <kasong@tencent.com>
    zram: fix potential UAF of zram table

Luke D. Jones <luke@ljones.dev>
    ALSA: hda/realtek: fixup ASUS H7606W

Luke D. Jones <luke@ljones.dev>
    ALSA: hda/realtek: fixup ASUS GA605W

Stefan Binding <sbinding@opensource.cirrus.com>
    ALSA: hda/realtek: Add support for Ayaneo System using CS35L41 HDA

Juergen Gross <jgross@suse.com>
    x86/asm: Make serialize() always_inline

Peter Zijlstra <peterz@infradead.org>
    sched/fair: Fix update_cfs_group() vs DELAY_DEQUEUE

Luis Chamberlain <mcgrof@kernel.org>
    nvmet: propagate npwg topology

Tejun Heo <tj@kernel.org>
    sched_ext: Fix dsq_local_on selftest

Hongguang Gao <hongguang.gao@broadcom.com>
    RDMA/bnxt_re: Fix to export port num to ib_query_qp

David Vernet <void@manifault.com>
    scx: Fix maximal BPF selftest prog

Ihor Solodrai <ihor.solodrai@pm.me>
    selftests/sched_ext: fix build after renames in sched_ext API

Oleg Nesterov <oleg@redhat.com>
    poll_wait: add mb() to fix theoretical race between waitqueue_active() and .poll()

Lizhi Xu <lizhi.xu@windriver.com>
    afs: Fix merge preference rule failure condition

Marco Nelissen <marco.nelissen@gmail.com>
    iomap: avoid avoid truncating 64-bit offset to 32 bits

Henry Huang <henry.hj@antgroup.com>
    sched_ext: keep running prev when prev->scx.slice != 0

Hans de Goede <hdegoede@redhat.com>
    ACPI: resource: acpi_dev_irq_override(): Check DMI match last

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Add Clearwater Forest to support list

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86/intel: power-domains: Add Clearwater Forest support

Jakub Kicinski <kuba@kernel.org>
    selftests: tc-testing: reduce rshift value

Koichiro Den <koichiro.den@canonical.com>
    gpio: sim: lock up configfs that an instantiated device depends on

Koichiro Den <koichiro.den@canonical.com>
    gpio: virtuser: lock up configfs that an instantiated device depends on

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    scsi: ufs: core: Honor runtime/system PM levels if set by host controller drivers

Max Kellermann <max.kellermann@ionos.com>
    cachefiles: Parse the "secctx" immediately

David Howells <dhowells@redhat.com>
    netfs: Fix non-contiguous donation between completed reads

David Howells <dhowells@redhat.com>
    kheaders: Ignore silly-rename files

Zhang Kunbo <zhangkunbo@huawei.com>
    fs: fix missing declaration of init_files

Brahmajit Das <brahmajit.xyz@gmail.com>
    fs/qnx6: Fix building with GCC 15

Leo Stone <leocstone@gmail.com>
    hfs: Sanity check the root record

Lizhi Xu <lizhi.xu@windriver.com>
    mac802154: check local interfaces before deleting sdata list

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix double free of TCP_Server_Info::hostname

David Lechner <dlechner@baylibre.com>
    hwmon: (ltc2991) Fix mixed signed/unsigned in DIV_ROUND_CLOSEST

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: testunit: on errors, repeat NACK until STOP

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: fix NACK handling when being a target

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: mux: demux-pinctrl: check initial mux selection, too

Pratyush Yadav <pratyush@kernel.org>
    Revert "mtd: spi-nor: core: replace dummy buswidth from addr to data"

David Lechner <dlechner@baylibre.com>
    hwmon: (tmp513) Fix division of negative numbers

Chenyuan Yang <chenyuan0y@gmail.com>
    platform/x86: lenovo-yoga-tab2-pro-1380-fastcharger: fix serdev race

Chenyuan Yang <chenyuan0y@gmail.com>
    platform/x86: dell-uart-backlight: fix serdev race

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    i2c: core: fix reference leak in i2c_register_adapter()

MD Danish Anwar <danishanwar@ti.com>
    soc: ti: pruss: Fix pruss APIs

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    reset: rzg2l-usbphy-ctrl: Assign proper of node to the allocated device

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Ensure job pointer is set to NULL after job completion

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Add new keep_resv BO param

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Unreserve BO on error

Yu-Chun Lin <eleanor15x@gmail.com>
    drm/tests: helpers: Fix compiler warning

Jakub Kicinski <kuba@kernel.org>
    netdev: avoid CFI problems with sock priv helpers

Leon Romanovsky <leon@kernel.org>
    net/mlx5e: Always start IPsec sequence number from 1

Leon Romanovsky <leon@kernel.org>
    net/mlx5e: Rely on reqid in IPsec tunnel mode

Leon Romanovsky <leon@kernel.org>
    net/mlx5e: Fix inversion dependency warning while enabling IPsec tunnel

Mark Zhang <markzhang@nvidia.com>
    net/mlx5: Clear port select structure when fail to create

Chris Mi <cmi@nvidia.com>
    net/mlx5: SF, Fix add port error handling

Yishai Hadas <yishaih@nvidia.com>
    net/mlx5: Fix a lockdep warning as part of the write combining test

Patrisious Haddad <phaddad@nvidia.com>
    net/mlx5: Fix RDMA TX steering prio

Pavel Begunkov <asml.silence@gmail.com>
    net: make page_pool_ref_netmem work with net iovs

Kevin Groeneveld <kgroeneveld@lenbrook.com>
    net: fec: handle page_pool_dev_alloc_pages error

Sean Anderson <sean.anderson@linux.dev>
    net: xilinx: axienet: Fix IRQ coalescing packet count overflow

Dan Carpenter <dan.carpenter@linaro.org>
    nfp: bpf: prevent integer overflow in nfp_bpf_event_output()

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: Move endif to the end of Kconfig file

Kuniyuki Iwashima <kuniyu@amazon.com>
    pfcp: Destroy device along with udp socket's netns dismantle.

Kuniyuki Iwashima <kuniyu@amazon.com>
    gtp: Destroy device along with udp socket's netns dismantle.

Kuniyuki Iwashima <kuniyu@amazon.com>
    gtp: Use for_each_netdev_rcu() in gtp_genl_dump_pdp().

Qu Wenruo <wqu@suse.com>
    btrfs: add the missing error handling inside get_canonical_dev_path

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: teo: Update documentation after previous changes

Karol Kolacinski <karol.kolacinski@intel.com>
    ice: Add correct PHY lane assignment

Sergey Temerkhanov <sergey.temerkhanov@intel.com>
    ice: Use ice_adapter for PTP shared data instead of auxdev

Sergey Temerkhanov <sergey.temerkhanov@intel.com>
    ice: Add ice_get_ctrl_ptp() wrapper to simplify the code

Sergey Temerkhanov <sergey.temerkhanov@intel.com>
    ice: Introduce ice_get_phy_model() wrapper

Karol Kolacinski <karol.kolacinski@intel.com>
    ice: Fix ETH56G FC-FEC Rx offset value

Karol Kolacinski <karol.kolacinski@intel.com>
    ice: Fix quad registers read on E825

Karol Kolacinski <karol.kolacinski@intel.com>
    ice: Fix E825 initialization

Artem Chernyshev <artem.chernyshev@red-soft.ru>
    pktgen: Avoid out-of-bounds access in get_imix_entries

Ilya Maximets <i.maximets@ovn.org>
    openvswitch: fix lockup on tx to unregistering netdev with carrier

Paul Barker <paul.barker.ct@bp.renesas.com>
    net: ravb: Fix max TX frame size for RZ/V2M

Jakub Kicinski <kuba@kernel.org>
    eth: bnxt: always recalculate features after XDP clearing, fix null-deref

Michal Luczaj <mhal@rbox.co>
    bpf: Fix bpf_sk_select_reuseport() memory leak

Sudheer Kumar Doredla <s-doredla@ti.com>
    net: ethernet: ti: cpsw_ale: Fix cpsw_ale_get_field()

Ard Biesheuvel <ardb@kernel.org>
    efi/zboot: Limit compression options to GZIP and ZSTD


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/x86/include/asm/special_insns.h               |   2 +-
 arch/x86/kernel/fred.c                             |   8 +-
 drivers/acpi/resource.c                            |   6 +-
 drivers/block/zram/zram_drv.c                      |   1 +
 drivers/cpufreq/Kconfig                            |   4 +-
 drivers/cpuidle/governors/teo.c                    |  91 +++----
 drivers/firmware/efi/Kconfig                       |   4 -
 drivers/firmware/efi/libstub/Makefile.zboot        |  18 +-
 drivers/gpio/gpio-sim.c                            |  48 +++-
 drivers/gpio/gpio-virtuser.c                       |  49 +++-
 drivers/gpio/gpio-xilinx.c                         |  32 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_fw_attestation.c |   4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c             |   4 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  41 ++-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c  |  25 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |   4 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.h |   2 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |   2 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  14 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c  |  35 ++-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.h  |   3 +-
 .../gpu/drm/amd/display/dc/dml/dcn35/dcn35_fpu.c   |   4 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |  11 +-
 drivers/gpu/drm/i915/display/intel_fb.c            |   2 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c            |   6 +-
 drivers/gpu/drm/nouveau/nvkm/engine/disp/mcp77.c   |   1 +
 drivers/gpu/drm/tests/drm_kunit_helpers.c          |   3 +-
 drivers/gpu/drm/v3d/v3d_irq.c                      |   4 +
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c                 |   3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.h                 |   3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |   7 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_gem.c                |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |  20 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c             |   7 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c         |   5 +-
 drivers/gpu/drm/xe/xe_hw_engine.c                  |   2 +-
 drivers/gpu/drm/xe/xe_oa.c                         |   1 +
 drivers/hwmon/ltc2991.c                            |   2 +-
 drivers/hwmon/tmp513.c                             |   7 +-
 drivers/i2c/busses/i2c-rcar.c                      |  20 +-
 drivers/i2c/i2c-atr.c                              |   2 +-
 drivers/i2c/i2c-core-base.c                        |   1 +
 drivers/i2c/i2c-slave-testunit.c                   |  19 +-
 drivers/i2c/muxes/i2c-demux-pinctrl.c              |   4 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   1 +
 drivers/infiniband/hw/bnxt_re/ib_verbs.h           |   4 +
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   1 +
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |   1 +
 drivers/irqchip/irq-gic-v3-its.c                   |   2 +-
 drivers/irqchip/irq-gic-v3.c                       |   2 +-
 drivers/irqchip/irqchip.c                          |   4 +-
 drivers/mtd/spi-nor/core.c                         |   2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |  19 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  25 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   7 -
 drivers/net/ethernet/freescale/fec_main.c          |  19 +-
 drivers/net/ethernet/intel/ice/ice.h               |   5 +
 drivers/net/ethernet/intel/ice/ice_adapter.c       |   6 +
 drivers/net/ethernet/intel/ice/ice_adapter.h       |  22 +-
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h    |   1 +
 drivers/net/ethernet/intel/ice/ice_common.c        |  51 ++++
 drivers/net/ethernet/intel/ice/ice_common.h        |   1 +
 drivers/net/ethernet/intel/ice/ice_main.c          |   6 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           | 165 +++++++-----
 drivers/net/ethernet/intel/ice/ice_ptp.h           |   9 +-
 drivers/net/ethernet/intel/ice/ice_ptp_consts.h    |   2 +-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c        | 285 +++++++++++----------
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h        |   5 +
 drivers/net/ethernet/intel/ice/ice_type.h          |   2 -
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |  22 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |  12 +-
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c    |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   1 +
 .../net/ethernet/mellanox/mlx5/core/lag/port_sel.c |   4 +-
 .../net/ethernet/mellanox/mlx5/core/sf/devlink.c   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/wc.c       |  24 +-
 drivers/net/ethernet/netronome/nfp/bpf/offload.c   |   3 +-
 drivers/net/ethernet/renesas/ravb_main.c           |   1 +
 drivers/net/ethernet/ti/cpsw_ale.c                 |  14 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   6 +
 drivers/net/gtp.c                                  |  26 +-
 drivers/net/pfcp.c                                 |  15 +-
 drivers/nvme/target/io-cmd-bdev.c                  |   2 +-
 drivers/platform/x86/dell/dell-uart-backlight.c    |   5 +-
 .../x86/intel/speed_select_if/isst_if_common.c     |   1 +
 drivers/platform/x86/intel/tpmi_power_domains.c    |   1 +
 .../x86/lenovo-yoga-tab2-pro-1380-fastcharger.c    |   5 +-
 drivers/pmdomain/imx/imx8mp-blk-ctrl.c             |   2 +-
 drivers/reset/reset-rzg2l-usbphy-ctrl.c            |   1 +
 drivers/ufs/core/ufshcd.c                          |   9 +-
 fs/afs/addr_prefs.c                                |   6 +-
 fs/btrfs/volumes.c                                 |   4 +
 fs/cachefiles/daemon.c                             |  14 +-
 fs/cachefiles/internal.h                           |   3 +-
 fs/cachefiles/security.c                           |   6 +-
 fs/file.c                                          |   1 +
 fs/hfs/super.c                                     |   4 +-
 fs/iomap/buffered-io.c                             |   2 +-
 fs/netfs/read_collect.c                            |   9 +-
 fs/proc/vmcore.c                                   |   2 +
 fs/qnx6/inode.c                                    |  11 +-
 fs/smb/client/connect.c                            |   3 +-
 include/linux/hrtimer.h                            |   1 +
 include/linux/poll.h                               |  10 +-
 include/linux/pruss_driver.h                       |  12 +-
 include/linux/userfaultfd_k.h                      |  12 +
 include/net/page_pool/helpers.h                    |   2 +-
 include/trace/events/mmflags.h                     |  63 +++++
 kernel/cpu.c                                       |   2 +-
 kernel/gen_kheaders.sh                             |   1 +
 kernel/sched/ext.c                                 |  11 +-
 kernel/sched/fair.c                                |   6 +-
 kernel/time/hrtimer.c                              |  11 +-
 kernel/time/timer_migration.c                      |  43 +++-
 mm/filemap.c                                       |   2 +-
 mm/huge_memory.c                                   |  12 +
 mm/hugetlb.c                                       |  14 +-
 mm/kmemleak.c                                      |   2 +-
 mm/mremap.c                                        |  32 ++-
 mm/vmscan.c                                        |   3 +
 net/core/filter.c                                  |  30 ++-
 net/core/netdev-genl-gen.c                         |  14 +-
 net/core/pktgen.c                                  |   6 +-
 net/mac802154/iface.c                              |   4 +
 net/mptcp/options.c                                |   6 +-
 net/mptcp/protocol.h                               |   9 +-
 net/ncsi/internal.h                                |   2 +
 net/ncsi/ncsi-manage.c                             |  16 +-
 net/ncsi/ncsi-rsp.c                                |  19 +-
 net/openvswitch/actions.c                          |   4 +-
 net/vmw_vsock/af_vsock.c                           |  18 ++
 net/vmw_vsock/virtio_transport_common.c            |  38 ++-
 net/vmw_vsock/vsock_bpf.c                          |   9 +
 security/apparmor/policy.c                         |   1 +
 sound/pci/hda/patch_realtek.c                      |   3 +
 tools/net/ynl/ynl-gen-c.py                         |  16 +-
 tools/testing/selftests/mm/cow.c                   |   8 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |  43 +++-
 .../selftests/sched_ext/ddsp_bogus_dsq_fail.bpf.c  |   2 +-
 .../selftests/sched_ext/ddsp_vtimelocal_fail.bpf.c |   4 +-
 .../testing/selftests/sched_ext/dsp_local_on.bpf.c |   7 +-
 tools/testing/selftests/sched_ext/dsp_local_on.c   |   5 +-
 .../selftests/sched_ext/enq_select_cpu_fails.bpf.c |   2 +-
 tools/testing/selftests/sched_ext/exit.bpf.c       |   4 +-
 tools/testing/selftests/sched_ext/maximal.bpf.c    |   8 +-
 .../selftests/sched_ext/select_cpu_dfl.bpf.c       |   2 +-
 .../sched_ext/select_cpu_dfl_nodispatch.bpf.c      |   2 +-
 .../selftests/sched_ext/select_cpu_dispatch.bpf.c  |   2 +-
 .../sched_ext/select_cpu_dispatch_bad_dsq.bpf.c    |   2 +-
 .../sched_ext/select_cpu_dispatch_dbl_dsp.bpf.c    |   4 +-
 .../selftests/sched_ext/select_cpu_vtime.bpf.c     |   8 +-
 .../tc-testing/tc-tests/filters/flow.json          |   4 +-
 tools/testing/shared/linux/maple_tree.h            |   2 +-
 tools/testing/vma/linux/atomic.h                   |   2 +-
 157 files changed, 1327 insertions(+), 639 deletions(-)


