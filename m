Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0386FE16;
	Wed,  7 Aug 2024 15:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042959; cv=none; b=AEAkT5wPhf7xaO6CtkTfOUbvzLAERA4fo+GPQTmeJueuxbmMUDO81McYIFCGQYJeNCs3F2xQA7X5mBJD2KDz+taWmXBGT496b/RjsC9ah8lou7XGJ83VNHz6SdfrDft+mh9uLZy6BR7yQQNAwqry+9Ly/UbNmn+me7zwj/Pa1t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042959; c=relaxed/simple;
	bh=3XaRsgmEUTGZXQxjdDID5fiLikS3P8oSGvb5hpRXOkU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=blXhOGkADTztkdnrTudB/rwzIFnumX7YHLUn6x87pYtzN5QcSn8LvjJ5BasOoXesEBX59nW4LmF0eTsuhLd5hFom9cpWroT1L7uQUulwNussCOoADcwzSa6vqJi+72xORrtVkUSyx92daRLyNoCLRmyRXZ7hCf22OPEKKENb6PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VzcH6ogH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VzcH6ogH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4697C32781;
	Wed,  7 Aug 2024 15:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042959;
	bh=3XaRsgmEUTGZXQxjdDID5fiLikS3P8oSGvb5hpRXOkU=;
	h=From:To:Cc:Subject:Date:From;
	b=VzcH6ogH/CMc3CsHVy2V407oyMPK4XBU/wcJ1lpcUvf3dt0aSd3121uLJ7UQqBOwx
	 Mn51X8JrvTgTHbCTkF1h7SAk+2N6W/tsiFSqUDaB2Wi7hGZ0qAq5cvyj8NLFt82nzS
	 OVp1IdaNUO5bJOzKGJ8ITV7h6/Hn9h9dEPzXiN5E=
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
Subject: [PATCH 6.10 000/123] 6.10.4-rc1 review
Date: Wed,  7 Aug 2024 16:58:39 +0200
Message-ID: <20240807150020.790615758@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.4-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.10.4-rc1
X-KernelTest-Deadline: 2024-08-09T15:00+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.10.4 release.
There are 123 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 09 Aug 2024 14:59:54 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.4-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.10.4-rc1

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: check backup support in signal endp

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: validate backup in MPJ

Liu Jing <liujing@cmss.chinamobile.com>
    selftests: mptcp: always close input's FD if opened

Paolo Abeni <pabeni@redhat.com>
    selftests: mptcp: fix error path

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix duplicate data handling

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: only set request_bkup flag when sending MP_PRIO

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: fix backup support in signal endpoints

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix bad RCVPRUNED mib accounting

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: mib: count MPJ with backup flag

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix NL PM announced address accounting

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: distinguish rcv vs sent backup flag in requests

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix user-space PM announced address accounting

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: don't increment tx_dropped in case of NETDEV_TX_BUSY

Herve Codina <herve.codina@bootlin.com>
    net: wan: fsl_qmc_hdlc: Discard received CRC

Herve Codina <herve.codina@bootlin.com>
    net: wan: fsl_qmc_hdlc: Convert carrier_lock spinlock to a mutex

Ma Ke <make24@iscas.ac.cn>
    net: usb: sr9700: fix uninitialized variable use in sr_mdio_read

Olivier Langlois <olivier@trillion01.com>
    io_uring: keep multishot request NAPI timeout current

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: use monitor sdata with driver only if desired

Johan Hovold <johan+linaro@kernel.org>
    wifi: ath12k: fix soft lockup on suspend

Dave Airlie <airlied@redhat.com>
    nouveau: set placement to original placement on uvmm validate.

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Fix setting DISCOVERY_FINDING for passive scanning

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/v3d: Validate passed in drm syncobj handles in the performance extension

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/v3d: Validate passed in drm syncobj handles in the timestamp extension

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/v3d: Fix potential memory leak in the performance extension

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/v3d: Fix potential memory leak in the timestamp extension

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/v3d: Prevent out of bounds access in performance query extensions

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    drm/i915: Fix possible int overflow in skl_ddi_calculate_wrpll()

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/virtio: Fix type of dma-fence context variable

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix contiguous handling for IB parsing v2

Jammy Huang <jammy_huang@aspeedtech.com>
    drm/ast: Fix black screen after resume

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: astdp: Wake up during connector status detection

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: Fix handling of dumb buffers

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: Fix a deadlock in dma buf fence polling

Blazej Kucman <blazej.kucman@intel.com>
    PCI: pciehp: Retain Power Indicator bits for userspace indicators

Edmund Raile <edmund.raile@protonmail.com>
    Revert "ALSA: firewire-lib: operate for period elapse event in process context"

Edmund Raile <edmund.raile@protonmail.com>
    Revert "ALSA: firewire-lib: obsolete workqueue for period update"

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: ump: Optimize conversions from SysEx to UMP

Mavroudis Chatzilazaridis <mavchatz@protonmail.com>
    ALSA: hda/realtek: Add quirk for Acer Aspire E5-574G

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Correct surround channels in UAC1 channel map

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: sched: check both directions for backup

Al Viro <viro@zeniv.linux.org.uk>
    protect the fetch of ->fd[fd] in do_dup2() from mispredictions

Boris Burkov <boris@bur.io>
    btrfs: make cow_file_range_inline() honor locked_page on error

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: do not subtract delalloc from avail bytes

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fix zone_unusable accounting on making block group read-write again

Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>
    HID: wacom: Modify pen IDs

Patryk Duda <patrykd@google.com>
    platform/chrome: cros_ec_proto: Lock device when updating MKBP version

Heiko Carstens <hca@linux.ibm.com>
    s390/fpu: Re-add exception handling in load_fpu_state()

Xiubo Li <xiubli@redhat.com>
    ceph: force sending a cap update msg back to MDS for revoke op

Alice Ryhl <aliceryhl@google.com>
    rust: SHADOW_CALL_STACK is incompatible with Rust

Will Deacon <will@kernel.org>
    arm64: jump_label: Ensure patched jump_labels are visible to all CPUs

Stuart Menefy <stuart.menefy@codasip.com>
    riscv: Fix linear mapping checks for non-contiguous memory regions

Nick Hu <nick.hu@sifive.com>
    RISC-V: Enable the IPI before workqueue_online_cpu()

Zhe Qiao <qiaozhe@iscas.ac.cn>
    riscv/mm: Add handling for VM_FAULT_SIGSEGV in mm_fault_error()

Shifrin Dmitry <dmitry.shifrin@syntacore.com>
    perf: riscv: Fix selecting counters in legacy mode

Eric Lin <eric.lin@sifive.com>
    perf arch events: Fix duplicate RISC-V SBI firmware event name

Daniel Maslowski <cyrevolt@googlemail.com>
    riscv/purgatory: align riscv_kernel_entry

Maciej Żenczykowski <maze@google.com>
    ipv6: fix ndisc_is_useropt() handling for PIO

Faizal Rahim <faizal.abdul.rahim@linux.intel.com>
    igc: Fix double reset adapter triggered from a single taprio cmd

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5e: Add a check for the return value from mlx5_port_set_eth_ptys

Chris Mi <cmi@nvidia.com>
    net/mlx5e: Fix CT entry update leaks of modify header context

Rahul Rameshbabu <rrameshbabu@nvidia.com>
    net/mlx5e: Require mlx5 tc classifier action support for IPsec prio capability

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Fix missing lock on sync reset reload

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: Lag, don't use the hardcoded value of the first port

Shay Drory <shayd@nvidia.com>
    net/mlx5: Fix error handling in irq_pool_request_irq

Shay Drory <shayd@nvidia.com>
    net/mlx5: Always drain health in shutdown callback

Kuniyuki Iwashima <kuniyu@amazon.com>
    netfilter: iptables: Fix potential null-ptr-deref in ip6table_nat_table_init().

Kuniyuki Iwashima <kuniyu@amazon.com>
    netfilter: iptables: Fix null-ptr-deref in iptable_nat_table_init().

André Almeida <andrealmeid@igalia.com>
    drm/atomic: Allow userspace to use damage clips with async flips

André Almeida <andrealmeid@igalia.com>
    drm/atomic: Allow userspace to use explicit sync with atomic async flips

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Conditionally use snooping for AMD HDMI

Heiko Carstens <hca@linux.ibm.com>
    s390/mm/ptdump: Fix handling of identity mapping area

Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
    net: phy: micrel: Fix the KSZ9131 MDI-X status issue

Dan Carpenter <dan.carpenter@linaro.org>
    net: mvpp2: Don't re-use loop iterator

Suraj Kandpal <suraj.kandpal@intel.com>
    drm/i915/hdcp: Fix HDCP2_STREAM_STATUS macro

Alexandra Winter <wintera@linux.ibm.com>
    net/iucv: fix use after free in iucv_sock_close()

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: xsk: fix txq interrupt mapping

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: add missing WRITE_ONCE when clearing ice_rx_ring::xdp_prog

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: improve updating ice_{t,r}x_ring::xsk_pool

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: toggle netif_carrier when setting up XSK pool

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: modify error handling when setting XSK pool in ndo_bpf

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: replace synchronize_rcu with synchronize_net

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: don't busy wait for Rx queue disable in ice_qp_dis()

Michal Kubiak <michal.kubiak@intel.com>
    ice: respect netif readiness in AF_XDP ZC related ndo's

Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
    i915/perf: Remove code to update PWR_CLK_STATE for gen12

Kuniyuki Iwashima <kuniyu@amazon.com>
    rtnetlink: Don't ignore IFLA_TARGET_NETNSID when ifname is specified in rtnl_dellink().

Andy Chiu <andy.chiu@sifive.com>
    net: axienet: start napi before enabling Rx/Tx

Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
    tcp: Adjust clamping window for applications specifying SO_RCVBUF

Jakub Kicinski <kuba@kernel.org>
    ethtool: fix setting key and resetting indir at once

Dan Carpenter <dan.carpenter@linaro.org>
    drm/client: Fix error code in drm_client_buffer_vmap_local()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix suspending with wrong filter policy

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel: Fail setup on error

songxiebing <songxiebing@kylinos.cn>
    ALSA: hda: conexant: Fix headset auto detect fail in the polling mode

Mark Mentovai <mark@mentovai.com>
    net: phy: realtek: add support for RTL8366S Gigabit PHY

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: correct S1G beacon length calculation

Veerendranath Jakkam <quic_vjakkam@quicinc.com>
    wifi: cfg80211: fix reporting failed MLO links status with cfg80211_connect_done

Eric Dumazet <edumazet@google.com>
    sched: act_ct: take care of padding in struct zones_ht_key

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Trigger a modeset when the screen moves

Jakub Kicinski <kuba@kernel.org>
    ethtool: rss: echo the context number back

Jakub Kicinski <kuba@kernel.org>
    netlink: specs: correct the spec of ethtool

Pavan Chebbi <pavan.chebbi@broadcom.com>
    bnxt_en: Fix RSS logic in __bnxt_reserve_rings()

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Fix overlay when using Screen Targets

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: Make sure the screen surface is ref counted

Danilo Krummrich <dakr@kernel.org>
    drm/nouveau: prime: fix refcount underflow

Danilo Krummrich <dakr@redhat.com>
    drm/gpuvm: fix missing dependency to DRM_EXEC

Casey Chen <cachen@purestorage.com>
    perf tool: fix dereferencing NULL al->maps

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Move sensor discovery before HID device initialization

Linus Walleij <linus.walleij@linaro.org>
    ARM: 9408/1: mm: CFI: Fix some erroneous reset prototypes

Jinjie Ruan <ruanjinjie@huawei.com>
    ARM: 9406/1: Fix callchain_trace() return value

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: dts: loongson: Fix ls2k1000-rtc interrupt

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: dts: loongson: Fix liointc IRQ polarity

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Loongson64: DTS: Fix PCIe port nodes for ls7a

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Add a distinct name for Granite Rapids

Tony Luck <tony.luck@intel.com>
    perf/x86/intel: Switch to new Intel CPU model defines

Xu Yang <xu.yang_2@nxp.com>
    perf: imx_perf: fix counter start and config sequence

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: assign CURSEG_ALL_DATA_ATGC if blkaddr is valid

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: fix to avoid use SSR allocate when do defragment

Zhang Yi <yi.zhang@huawei.com>
    ext4: check the extent status again before inserting delalloc block

Zhang Yi <yi.zhang@huawei.com>
    ext4: factor out a common helper to query extent map

Peter Xu <peterx@redhat.com>
    mm/migrate: putback split folios when numa hint migration fails

David Hildenbrand <david@redhat.com>
    mm/migrate: move NUMA hinting fault folio isolation + checks under PTL

David Hildenbrand <david@redhat.com>
    mm/migrate: make migrate_misplaced_folio() return 0 on success

Ryan Roberts <ryan.roberts@arm.com>
    mm: fix khugepaged activation policy

Ran Xiaokai <ran.xiaokai@zte.com.cn>
    mm/huge_memory: mark racy access onhuge_anon_orders_always


-------------

Diffstat:

 Documentation/admin-guide/mm/transhuge.rst         |  11 +-
 Documentation/netlink/specs/ethtool.yaml           |   2 +-
 Documentation/networking/ethtool-netlink.rst       |   1 +
 Makefile                                           |   4 +-
 arch/arm/kernel/perf_callchain.c                   |   3 +-
 arch/arm/mm/proc.c                                 |  20 +-
 arch/arm64/include/asm/jump_label.h                |   1 +
 arch/arm64/kernel/jump_label.c                     |  11 +-
 arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi |  81 ++--
 arch/riscv/kernel/sbi-ipi.c                        |   2 +-
 arch/riscv/mm/fault.c                              |  17 +-
 arch/riscv/mm/init.c                               |  15 +-
 arch/riscv/purgatory/entry.S                       |   2 +
 arch/s390/kernel/fpu.c                             |   2 +-
 arch/s390/mm/dump_pagetables.c                     |  21 +-
 arch/x86/events/intel/core.c                       | 162 +++----
 drivers/bluetooth/btintel.c                        |   3 +
 drivers/gpu/drm/Kconfig                            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |  16 +-
 drivers/gpu/drm/ast/ast_dp.c                       |   7 +
 drivers/gpu/drm/ast/ast_drv.c                      |   5 +
 drivers/gpu/drm/ast/ast_drv.h                      |   1 +
 drivers/gpu/drm/ast/ast_mode.c                     |  29 +-
 drivers/gpu/drm/drm_atomic_uapi.c                  |   5 +-
 drivers/gpu/drm/drm_client.c                       |   2 +-
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c      |   6 +-
 drivers/gpu/drm/i915/display/intel_hdcp_regs.h     |   2 +-
 drivers/gpu/drm/i915/i915_perf.c                   |  33 --
 drivers/gpu/drm/nouveau/nouveau_prime.c            |   3 +-
 drivers/gpu/drm/nouveau/nouveau_uvmm.c             |   1 +
 drivers/gpu/drm/v3d/v3d_drv.h                      |   4 +
 drivers/gpu/drm/v3d/v3d_sched.c                    |  44 +-
 drivers/gpu/drm/v3d/v3d_submit.c                   | 121 +++--
 drivers/gpu/drm/virtio/virtgpu_submit.c            |   2 +-
 drivers/gpu/drm/vmwgfx/vmw_surface_cache.h         |  10 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c                 | 127 +++---
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.h                 |  15 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |  40 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c              |  17 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                | 504 +++++++++------------
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h                |  17 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c                |  14 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c            |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_prime.c              |  32 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |  27 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c               |  33 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c               | 174 ++++---
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c            | 280 +++++++++++-
 drivers/gpu/drm/vmwgfx/vmwgfx_vkms.c               |  40 +-
 drivers/hid/amd-sfh-hid/amd_sfh_client.c           |  18 +-
 drivers/hid/wacom_wac.c                            |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   6 +-
 drivers/net/ethernet/intel/ice/ice.h               |  11 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |   4 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |  10 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           | 184 +++++---
 drivers/net/ethernet/intel/ice/ice_xsk.h           |  14 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |  33 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   1 +
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c    |   7 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   5 +-
 .../net/ethernet/mellanox/mlx5/core/irq_affinity.c |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   2 +-
 .../ethernet/mellanox/mlx5/core/sf/dev/driver.c    |   1 +
 drivers/net/ethernet/realtek/r8169_main.c          |   8 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   2 +-
 drivers/net/phy/micrel.c                           |  34 +-
 drivers/net/phy/realtek.c                          |   7 +
 drivers/net/usb/sr9700.c                           |  11 +-
 drivers/net/wan/fsl_qmc_hdlc.c                     |  33 +-
 drivers/net/wireless/ath/ath12k/pci.c              |   3 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |   4 +-
 drivers/perf/fsl_imx9_ddr_perf.c                   |   6 +-
 drivers/perf/riscv_pmu_sbi.c                       |   2 +-
 drivers/platform/chrome/cros_ec_proto.c            |   2 +
 fs/btrfs/block-group.c                             |  13 +-
 fs/btrfs/extent-tree.c                             |   3 +-
 fs/btrfs/free-space-cache.c                        |   4 +-
 fs/btrfs/inode.c                                   |  16 +-
 fs/btrfs/space-info.c                              |   5 +-
 fs/btrfs/space-info.h                              |   1 +
 fs/ceph/caps.c                                     |  35 +-
 fs/ceph/super.h                                    |   7 +-
 fs/ext4/inode.c                                    |  78 +++-
 fs/f2fs/segment.c                                  |   4 +-
 fs/file.c                                          |   1 +
 include/linux/cpuhotplug.h                         |   1 +
 include/linux/huge_mm.h                            |  12 -
 include/linux/migrate.h                            |   7 +
 include/trace/events/btrfs.h                       |   8 +
 include/trace/events/mptcp.h                       |   2 +-
 init/Kconfig                                       |   1 +
 io_uring/poll.c                                    |   1 +
 mm/huge_memory.c                                   |  20 +-
 mm/khugepaged.c                                    |  33 +-
 mm/memory.c                                        |  11 +-
 mm/migrate.c                                       |  94 ++--
 net/bluetooth/hci_core.c                           |   7 -
 net/bluetooth/hci_event.c                          |   5 +-
 net/bluetooth/hci_sync.c                           |  21 +
 net/core/rtnetlink.c                               |   2 +-
 net/ethtool/ioctl.c                                |   5 +-
 net/ethtool/rss.c                                  |   8 +-
 net/ipv4/netfilter/iptable_nat.c                   |  18 +-
 net/ipv4/tcp_input.c                               |  23 +-
 net/ipv6/ndisc.c                                   |  34 +-
 net/ipv6/netfilter/ip6table_nat.c                  |  14 +-
 net/iucv/af_iucv.c                                 |   4 +-
 net/mac80211/cfg.c                                 |   7 +-
 net/mac80211/tx.c                                  |   5 +-
 net/mac80211/util.c                                |   2 +-
 net/mptcp/mib.c                                    |   2 +
 net/mptcp/mib.h                                    |   2 +
 net/mptcp/options.c                                |   2 +-
 net/mptcp/pm.c                                     |  12 +
 net/mptcp/pm_netlink.c                             |  46 +-
 net/mptcp/pm_userspace.c                           |  18 +
 net/mptcp/protocol.c                               |  18 +-
 net/mptcp/protocol.h                               |   4 +
 net/mptcp/subflow.c                                |  26 +-
 net/sched/act_ct.c                                 |   4 +-
 net/wireless/scan.c                                |  11 +-
 net/wireless/sme.c                                 |   1 +
 sound/core/seq/seq_ump_convert.c                   |  41 +-
 sound/firewire/amdtp-stream.c                      |  38 +-
 sound/firewire/amdtp-stream.h                      |   1 +
 sound/pci/hda/hda_controller.h                     |   2 +-
 sound/pci/hda/hda_intel.c                          |  10 +-
 sound/pci/hda/patch_conexant.c                     |  54 +--
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/usb/stream.c                                 |   4 +-
 .../pmu-events/arch/riscv/andes/ax45/firmware.json |   2 +-
 .../pmu-events/arch/riscv/riscv-sbi-firmware.json  |   2 +-
 .../pmu-events/arch/riscv/sifive/u74/firmware.json |   2 +-
 .../arch/riscv/starfive/dubhe-80/firmware.json     |   2 +-
 .../arch/riscv/thead/c900-legacy/firmware.json     |   2 +-
 tools/perf/util/callchain.c                        |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |   8 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  74 ++-
 143 files changed, 2034 insertions(+), 1279 deletions(-)


