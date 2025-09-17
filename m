Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1471F1E1E19;
	Wed, 17 Sep 2025 12:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112584; cv=none; b=aPh3tuMfvkxgTUEKpAN8BPyUeUUcM0wnE9CEEmIAryJWTLpu0CySSVgmxWbkX/npQXlw9z/fNFih0dZWs0DYku8Yvks4h2iDtT7mLJ4E3h0oxyRSU3rsSawmQoyUYOys/T1jkSa0qiOEPWkePObcQQYoxwj3YPN2Tj2KGWoYtoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112584; c=relaxed/simple;
	bh=/oUXk2Sx25oEC0I8Gh/hBnF6L3CWiMN9BsDhRNHif2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lrPNC0wPRbpBDcFvw24PNxgdzwW+g5C77cbiwN+zNN8rYA9RVTl8hPCQlOc9QDMI/AqPsDOsAi/tH32Olra9pAZjieAKsh0eXDD1aummTlnoWgaSFofNp3IuLt4aGjW7JseUwneF25Utr4etHScx85cGsVDVYjU33aqy32p3N2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eHo2779U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eHo2779U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3979C4CEF0;
	Wed, 17 Sep 2025 12:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112583;
	bh=/oUXk2Sx25oEC0I8Gh/hBnF6L3CWiMN9BsDhRNHif2Q=;
	h=From:To:Cc:Subject:Date:From;
	b=eHo2779UMYCu/PMdXNVTO+PVVW87XpilS7gOINR2JSmf2KZQxjtymrbbWwe+HJD3v
	 0wwFAbcNd+vrNmXYfVYXMvyQAU22GoVVq6XZQOneXU84TmpqHbfMjRKNqbos+MvEhg
	 gJk8byewaexeBOznseFFL6oQ0EiRYSgT+kvAA7DM=
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
	broonie@kernel.org,
	achill@achill.org
Subject: [PATCH 6.16 000/189] 6.16.8-rc1 review
Date: Wed, 17 Sep 2025 14:31:50 +0200
Message-ID: <20250917123351.839989757@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.16.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.16.8-rc1
X-KernelTest-Deadline: 2025-09-19T12:33+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.16.8 release.
There are 189 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.16.8-rc1

Johan Hovold <johan@kernel.org>
    phy: ti-pipe3: fix device leak at unbind

Johan Hovold <johan@kernel.org>
    phy: ti: omap-usb2: fix device leak at unbind

Johan Hovold <johan@kernel.org>
    phy: tegra: xusb: fix device and OF node leak at probe

Stephan Gerhold <stephan.gerhold@linaro.org>
    phy: qcom: qmp-pcie: Fix PHY initialization when powered down by firmware

Miaoqian Lin <linmq006@gmail.com>
    dmaengine: dw: dmamux: Fix device reference leak in rzn1_dmamux_route_allocate

Stephan Gerhold <stephan.gerhold@linaro.org>
    dmaengine: qcom: bam_dma: Fix DT error handling for num-channels/ees

Takashi Iwai <tiwai@suse.de>
    usb: gadget: midi2: Fix MIDI2 IN EP max packet size

Takashi Iwai <tiwai@suse.de>
    usb: gadget: midi2: Fix missing UMP group attributes initialization

RD Babiera <rdbabiera@google.com>
    usb: typec: tcpm: properly deliver cable vdms to altmode drivers

Alan Stern <stern@rowland.harvard.edu>
    USB: gadget: dummy-hcd: Fix locking bug in RT-enabled kernels

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix memory leak regression when freeing xhci vdev devices depth first

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: Fix full DbC transfer ring after several reconnects

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: decouple endpoint allocation from initialization

Yuezhang Mo <Yuezhang.Mo@sony.com>
    erofs: fix runtime warning on truncate_folio_batch_exceptionals()

Andreas Kemnade <akemnade@kernel.org>
    regulator: sy7636a: fix lifecycle of power good gpio

Anders Roxell <anders.roxell@linaro.org>
    dmaengine: ti: edma: Fix memory allocation size for queue_priority_map

Gao Xiang <xiang@kernel.org>
    erofs: fix invalid algorithm for encoded extents

Gao Xiang <xiang@kernel.org>
    erofs: unify meta buffers in z_erofs_fill_inode()

Gao Xiang <xiang@kernel.org>
    erofs: remove need_kmap in erofs_read_metabuf()

Gao Xiang <xiang@kernel.org>
    erofs: get rid of {get,put}_page() for ztailpacking data

Dan Carpenter <dan.carpenter@linaro.org>
    dmaengine: idxd: Fix double free in idxd_setup_wqs()

Yi Sun <yi.sun@intel.com>
    dmaengine: idxd: Fix refcount underflow on module unload

Yi Sun <yi.sun@intel.com>
    dmaengine: idxd: Remove improper idxd_free

Pengyu Luo <mitltlatltl@gmail.com>
    phy: qualcomm: phy-qcom-eusb2-repeater: fix override properties

Hangbin Liu <liuhangbin@gmail.com>
    hsr: hold rcu and dev lock for hsr_get_port_ndev

Hangbin Liu <liuhangbin@gmail.com>
    hsr: use hsr_for_each_port_rtnl in hsr_port_get_hsr

Hangbin Liu <liuhangbin@gmail.com>
    hsr: use rtnl lock when iterating over ports

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: restart set lookup on base_seq change

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: make nft_set_do_lookup available unconditionally

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: place base_seq in struct net

Phil Sutter <phil@nwl.cc>
    netfilter: nf_tables: Reintroduce shortened deletion notifications

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_rbtree: continue traversal if element is inactive

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: don't check genbit from packetpath lookups

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: don't return bogus extension pointer

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: merge pipapo_get/lookup

Florian Westphal <fw@strlen.de>
    netfilter: nft_set: remove one argument from lookup and update functions

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: remove unused arguments

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_bitmap: fix lockdep splat due to missing annotation

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: xilinx_can: xcan_write_frame(): fix use-after-free of transmitted SKB

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: j1939_local_ecu_get(): undo increment when j1939_local_ecu_get() fails

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: j1939_sk_bind(): call j1939_priv_put() immediately when j1939_local_ecu_get() failed

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: implement NETDEV_UNREGISTER notification handler

Davide Caratti <dcaratti@redhat.com>
    selftests: can: enable CONFIG_CAN_VCAN as a module

Stanislav Fomichev <sdf@fomichev.me>
    macsec: sync features on RTM_NEWLINK

Carolina Jubran <cjubran@nvidia.com>
    net: dev_ioctl: take ops lock in hwtstamp lower paths

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: use udelay rather than fsleep

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/configfs: Don't touch survivability_mode on fini

Michal Schmidt <mschmidt@redhat.com>
    i40e: fix IRQ freeing in i40e_vsi_request_irq_msix error path

Kohei Enju <enjuk@amazon.com>
    igb: fix link test skipping when interface is admin down

Tianyu Xu <tianyxu@cisco.com>
    igb: Fix NULL pointer dereference in ethtool loopback test

Alex Tran <alex.t.tran@gmail.com>
    docs: networking: can: change bcm_msg_head frames member to support flexible array

Antoine Tenart <atenart@kernel.org>
    tunnels: reset the GSO metadata before reusing the skb

Petr Machata <petrm@nvidia.com>
    net: bridge: Bounce invalid boolopts

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix ageing time for BCM53101

Alok Tiwari <alok.a.tiwari@oracle.com>
    genetlink: fix genl_bind() invoking bind() after -EPERM

Klaus Kudielka <klaus.kudielka@gmail.com>
    PCI: mvebu: Fix use of for_each_of_range() iterator

Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
    wifi: ath12k: fix WMI TLV header misalignment

Sriram R <quic_srirrama@quicinc.com>
    wifi: ath12k: Add support to enqueue management frame at MLD level

Sarika Sharma <quic_sarishar@quicinc.com>
    wifi: ath12k: add link support for multi-link in arsta

Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
    wifi: ath12k: Fix missing station power save configuration

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: phy: transfer phy_config_inband() locking responsibility to phylink

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: phylink: add lock for serializing concurrent pl->phydev writes with resolver

Stefan Wahren <wahrenst@gmx.net>
    net: fec: Fix possible NPD in fec_enet_phy_reset_after_clk_enable()

Chia-I Wu <olvaffe@gmail.com>
    drm/panthor: validate group queue count

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mtd: rawnand: nuvoton: Fix an error handling path in ma35_nand_chips_init()

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion LE910C4-WWX new compositions

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion FN990A w/audio compositions

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: serial: brcm,bcm7271-uart: Constrain clocks

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: fix bug in flow control levels init

Fabian Vogt <fvogt@suse.de>
    tty: hvc_console: Call hvc_kick in hvc_write unconditionally

Paolo Abeni <pabeni@redhat.com>
    Revert "net: usb: asix: ax88772: drop phylink use in PM to avoid MDIO runtime PM wakeups"

Antheas Kapenekakis <lkml@antheas.dev>
    Input: xpad - add support for Flydigi Apex 5

Christoffer Sandberg <cs@tuxedo.de>
    Input: i8042 - add TUXEDO InfinityBook Pro Gen10 AMD to i8042 quirk table

Jeff LaBundy <jeff@labundy.com>
    Input: iqs7222 - avoid enabling unused interrupts

K Prateek Nayak <kprateek.nayak@amd.com>
    x86/cpu/topology: Always try cpu_parse_topology_ext() on AMD/Hygon

Reinette Chatre <reinette.chatre@intel.com>
    fs/resctrl: Eliminate false positive lockdep warning when reading SNC counters

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    hrtimers: Unconditionally update target CPU base after offline timer migration

Pratap Nirujogi <pratap.nirujogi@amd.com>
    drm/amd/amdgpu: Declare isp firmware binary file

Mario Limonciello (AMD) <mario.limonciello@amd.com>
    drm/amd/display: Drop dm_prepare_suspend() and dm_complete()

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Destroy cached state in complete() callback

Quanmin Yan <yanquanmin1@huawei.com>
    mm/damon/reclaim: avoid divide-by-zero in damon_reclaim_apply_parameters()

Stanislav Fort <stanislav.fort@aisle.com>
    mm/damon/sysfs: fix use-after-free in state_show()

Santhosh Kumar K <s-k6@ti.com>
    mtd: spinand: winbond: Fix oob_layout for W25N01JW

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spinand: winbond: Enable high-speed modes on w25n0xjw

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spinand: Add a ->configure_chip() hook

Max Kellermann <max.kellermann@ionos.com>
    ceph: fix crash after fscrypt_encrypt_pagecache_blocks() error

Max Kellermann <max.kellermann@ionos.com>
    ceph: always call ceph_shift_unused_folios_left()

Alex Markuze <amarkuze@redhat.com>
    ceph: fix race condition where r_parent becomes stale before sending message

Alex Markuze <amarkuze@redhat.com>
    ceph: fix race condition validating r_parent before applying state

Ilya Dryomov <idryomov@gmail.com>
    libceph: fix invalid accesses to ceph_connection_v1_info

Chen Ridong <chenridong@huawei.com>
    kernfs: Fix UAF in polling when open file is released

Qu Wenruo <wqu@suse.com>
    btrfs: fix corruption reading compressed range when block size is smaller than page size

Boris Burkov <boris@bur.io>
    btrfs: use readahead_expand() on compressed extents

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Disable DPCD Probe Quirk

Imre Deak <imre.deak@intel.com>
    drm/dp: Add an EDID quirk for the DPCD register access probe

Imre Deak <imre.deak@intel.com>
    drm/edid: Add support for quirks visible to DRM core and drivers

Imre Deak <imre.deak@intel.com>
    drm/edid: Define the quirks in an enum list

Geoffrey McRae <geoffrey.mcrae@amd.com>
    drm/amd/display: remove oem i2c adapter on finish

Ovidiu Bunea <ovidiu.bunea@amd.com>
    drm/amd/display: Correct sequences and delays for DCN35 PG & RCG

David Rosca <david.rosca@amd.com>
    drm/amdgpu/vcn4: Fix IB parsing with multiple engine info packages

David Rosca <david.rosca@amd.com>
    drm/amdgpu/vcn: Allow limiting ctx to instance 0 for AV1 at any time

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix a memory leak in fence cleanup when unloading

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe: Block exec and rebind worker while evicting for suspend / hibernate

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe: Allow the pm notifier to continue on failure

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe: Attempt to bring bos back to VRAM after eviction

Jani Nikula <jani.nikula@intel.com>
    drm/i915/power: fix size for for_each_set_bit() in abox iteration

Johan Hovold <johan@kernel.org>
    drm/mediatek: fix potential OF node use-after-free

Quanmin Yan <yanquanmin1@huawei.com>
    mm/damon/lru_sort: avoid divide-by-zero in damon_lru_sort_apply_parameters()

Sang-Heon Jeon <ekffu200098@gmail.com>
    mm/damon/core: set quota->charged_from to jiffies at first charge window

Kyle Meyer <kyle.meyer@hpe.com>
    mm/memory-failure: fix redundant updates for already poisoned pages

Miaohe Lin <linmiaohe@huawei.com>
    mm/memory-failure: fix VM_BUG_ON_PAGE(PagePoisoned(page)) when unpoison memory

Uladzislau Rezki (Sony) <urezki@gmail.com>
    mm/vmalloc, mm/kasan: respect gfp mask in kasan_populate_vmalloc()

Wei Yang <richard.weiyang@gmail.com>
    mm/khugepaged: fix the address passed to notifier on testing young

Jeongjun Park <aha310510@gmail.com>
    mm/hugetlb: add missing hugetlb_lock in __unmap_hugepage_range()

Miklos Szeredi <mszeredi@redhat.com>
    fuse: prevent overflow in copy_file_range return value

Miklos Szeredi <mszeredi@redhat.com>
    fuse: check if copy_file_range() returns larger than requested size

Amir Goldstein <amir73il@gmail.com>
    fuse: do not allow mapping a non-regular backing file

Christophe Kerello <christophe.kerello@foss.st.com>
    mtd: rawnand: stm32_fmc2: fix ECC overwrite

Christophe Kerello <christophe.kerello@foss.st.com>
    mtd: rawnand: stm32_fmc2: avoid overlapping mappings on ECC buffer

Alexander Sverdlin <alexander.sverdlin@gmail.com>
    mtd: nand: raw: atmel: Respect tAR, tCLR in read setup timing

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix data loss due to broken rename(2)

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix compound alignment with encryption

Breno Leitao <leitao@debian.org>
    s390: kexec: initialize kexec_buf struct

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: fix 130/1030 configs

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: hibernate: Restrict GFP mask in hibernation_snapshot()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: EM: Add function for registering a PD without capacity update

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: asix: ax88772: drop phylink use in PM to avoid MDIO runtime PM wakeups

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: fix to enable RSS

Jonas Jelonek <jelonek.jonas@gmail.com>
    i2c: rtl9300: remove broken SMBus Quick operation support

Jonas Jelonek <jelonek.jonas@gmail.com>
    i2c: rtl9300: ensure data length is within supported range

Chiasheng Lee <chiasheng.lee@linux.intel.com>
    i2c: i801: Hide Intel Birch Stream SoC TCO WDT

Omar Sandoval <osandov@fb.com>
    btrfs: fix subvolume deletion lockup caused by inodes xarray race

Boris Burkov <boris@bur.io>
    btrfs: fix squota compressed stats leak

Mark Tinguely <mark.tinguely@oracle.com>
    ocfs2: fix recursive semaphore deadlock in fiemap call

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    netlink: specs: mptcp: fix if-idx attribute type

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    doc: mptcp: net.mptcp.pm_type is deprecated

Krister Johansen <kjlx@templeofstupid.com>
    mptcp: sockopt: make sync_socket_options propagate SOCK_KEEPOPEN

Breno Leitao <leitao@debian.org>
    arm64: kexec: initialize kexec_buf struct in load_other_segments()

Nathan Chancellor <nathan@kernel.org>
    compiler-clang.h: define __SANITIZE_*__ macros only when undefined

Trond Myklebust <trond.myklebust@hammerspace.com>
    Revert "SUNRPC: Don't allow waiting for exiting tasks"

Jonas Jelonek <jelonek.jonas@gmail.com>
    i2c: rtl9300: fix channel number bound check

Salah Triki <salah.triki@gmail.com>
    EDAC/altera: Delete an inappropriate dma_free_coherent() call

wangzijie <wangzijie1@honor.com>
    proc: fix type confusion in pde_set_flags()

Kuniyuki Iwashima <kuniyu@google.com>
    tcp_bpf: Call sk_msg_free() when tcp_bpf_send_verdict() fails to allocate psock->cork.

Peilin Ye <yepeilin@google.com>
    bpf: Tell memcg to use allow_spinning=false path in bpf_timer_init()

KaFai Wan <kafai.wan@linux.dev>
    bpf: Allow fall back to interpreter for programs with stack size <= 512

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    rqspinlock: Choose trylock fallback for NMI waiters

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    xsk: Fix immature cq descriptor production

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix out-of-bounds dynptr write in bpf_crypto_crypt

Mario Limonciello (AMD) <superm1@kernel.org>
    cpufreq/amd-pstate: Fix a regression leading to EPP 0 after resume

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_cf: Deny all sampling events by counter PMU

Thomas Richter <tmricht@linux.ibm.com>
    s390/pai: Deny all events not handled by this PMU

Gautham R. Shenoy <gautham.shenoy@amd.com>
    cpufreq/amd-pstate: Fix setting of CPPC.min_perf in active mode for performance governor

Jesper Dangaard Brouer <hawk@kernel.org>
    bpf, cpumap: Disable page_pool direct xdp_return need larger scope

Pu Lehui <pulehui@huawei.com>
    tracing: Silence warning when chunk allocation fails in trace_pid_write

Jonathan Curley <jcurley@purestorage.com>
    NFSv4/flexfiles: Fix layout merge mirror check.

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: nfs_invalidate_folio() must observe the offset and size arguments

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.2: Serialise O_DIRECT i/o and copy range

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.2: Serialise O_DIRECT i/o and clone range

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.2: Serialise O_DIRECT i/o and fallocate()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Serialise O_DIRECT i/o and truncate()

Wang Liang <wangliang74@huawei.com>
    tracing/osnoise: Fix null-ptr-deref in bitmap_parselist()

Vladimir Riabchun <ferr.lambarginio@gmail.com>
    ftrace/samples: Fix function size computation

Scott Mayhew <smayhew@redhat.com>
    nfs/localio: restore creds before releasing pageio data

Luo Gengkun <luogengkun@huaweicloud.com>
    tracing: Fix tracing_marker may trigger page fault during preempt_disable

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Clear the NFS_CAP_XATTR flag if not supported by the server

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Clear NFS_CAP_OPEN_XOR and NFS_CAP_DELEGTIME if not supported

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Clear the NFS_CAP_FS_LOCATIONS flag if it is not set

Guenter Roeck <linux@roeck-us.net>
    trace/fgraph: Fix error handling

Xiao Ni <xni@redhat.com>
    md: keep recovery_cp in mdp_superblock_s

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Don't clear capabilities that won't be reset

Justin Worrell <jworrell@gmail.com>
    SUNRPC: call xs_sock_process_cmsg for all cmsg

Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
    flexfiles/pNFS: fix NULL checks on result of ff_layout_choose_ds_for_read

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/amdgpu: Add more checks to PSP mailbox"

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Fix getname not returning broadcast fields

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_conn: Fix running bis_cleanup for hci_conn->type PA_LINK

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Make iotlb_sync_map a static property of dmar_domain

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/vt-d: Split paging_domain_compatible()

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/vt-d: Create unique domain ops for each stage

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/vt-d: Split intel_iommu_domain_alloc_paging_flags()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_conn: Fix not cleaning up Broadcaster/Broadcast Source

Dan Carpenter <dan.carpenter@linaro.org>
    irqchip/mvebu-gicp: Fix an IS_ERR() vs NULL check in probe()

Kan Liang <kan.liang@linux.intel.com>
    perf: Fix the POLL_HUP delivery breakage

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    dma-debug: don't enforce dma mapping check on noncoherent allocations

Amir Goldstein <amir73il@gmail.com>
    fhandle: use more consistent rules for decoding file handle from userns

Edward Adam Davis <eadavis@qq.com>
    fuse: Block access to folio overlimit

Christian Brauner <brauner@kernel.org>
    coredump: don't pointlessly check and spew warnings

Christoph Hellwig <hch@lst.de>
    block: don't silently ignore metadata for sync read/write

Christoph Hellwig <hch@lst.de>
    fs: add a FMODE_ flag to indicate IOCB_HAS_METADATA availability


-------------

Diffstat:

 .../bindings/serial/brcm,bcm7271-uart.yaml         |   2 +-
 Documentation/netlink/specs/mptcp_pm.yaml          |   2 +-
 Documentation/networking/can.rst                   |   2 +-
 Documentation/networking/mptcp.rst                 |   8 +-
 Makefile                                           |   4 +-
 arch/arm64/kernel/machine_kexec_file.c             |   2 +-
 arch/s390/kernel/kexec_elf.c                       |   2 +-
 arch/s390/kernel/kexec_image.c                     |   2 +-
 arch/s390/kernel/machine_kexec_file.c              |   6 +-
 arch/s390/kernel/perf_cpum_cf.c                    |   4 +-
 arch/s390/kernel/perf_pai_crypto.c                 |   4 +-
 arch/s390/kernel/perf_pai_ext.c                    |   2 +-
 arch/x86/kernel/cpu/topology_amd.c                 |  25 +-
 block/fops.c                                       |  13 +-
 drivers/cpufreq/amd-pstate.c                       |  19 +-
 drivers/cpufreq/intel_pstate.c                     |   4 +-
 drivers/dma/dw/rzn1-dmamux.c                       |  15 +-
 drivers/dma/idxd/init.c                            |  39 +--
 drivers/dma/qcom/bam_dma.c                         |   8 +-
 drivers/dma/ti/edma.c                              |   4 +-
 drivers/edac/altera_edac.c                         |   1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   4 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h            |  11 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c           |   2 -
 drivers/gpu/drm/amd/amdgpu/isp_v4_1_1.c            |   2 +
 drivers/gpu/drm/amd/amdgpu/psp_v10_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/psp_v11_0.c             |  31 +--
 drivers/gpu/drm/amd/amdgpu/psp_v11_0_8.c           |  25 +-
 drivers/gpu/drm/amd/amdgpu/psp_v12_0.c             |  18 +-
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c             |  25 +-
 drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c           |  25 +-
 drivers/gpu/drm/amd/amdgpu/psp_v14_0.c             |  25 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |  12 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |  60 +++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 106 +++++----
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   1 +
 drivers/gpu/drm/amd/display/dc/dc.h                |   1 +
 .../gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c |  74 +++---
 .../drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c    |   2 +-
 .../drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c    | 115 ++-------
 .../gpu/drm/amd/display/dc/hwss/dcn35/dcn35_init.c |   3 -
 .../drm/amd/display/dc/hwss/dcn351/dcn351_init.c   |   3 -
 drivers/gpu/drm/amd/display/dc/inc/hw/pg_cntl.h    |   1 +
 .../drm/amd/display/dc/pg/dcn35/dcn35_pg_cntl.c    |  78 +++---
 drivers/gpu/drm/display/drm_dp_helper.c            |  42 +++-
 drivers/gpu/drm/drm_edid.c                         | 232 +++++++++---------
 drivers/gpu/drm/i915/display/intel_display_power.c |   6 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |  11 +-
 drivers/gpu/drm/panthor/panthor_drv.c              |   2 +-
 drivers/gpu/drm/xe/tests/xe_bo.c                   |   2 +-
 drivers/gpu/drm/xe/tests/xe_dma_buf.c              |  10 +-
 drivers/gpu/drm/xe/xe_bo.c                         |  16 +-
 drivers/gpu/drm/xe/xe_bo.h                         |   2 +-
 drivers/gpu/drm/xe/xe_device_types.h               |   6 +
 drivers/gpu/drm/xe/xe_dma_buf.c                    |   2 +-
 drivers/gpu/drm/xe/xe_exec.c                       |   9 +
 drivers/gpu/drm/xe/xe_pm.c                         |  42 +++-
 drivers/gpu/drm/xe/xe_survivability_mode.c         |   3 +-
 drivers/gpu/drm/xe/xe_vm.c                         |  42 +++-
 drivers/gpu/drm/xe/xe_vm.h                         |   2 +
 drivers/gpu/drm/xe/xe_vm_types.h                   |   5 +
 drivers/i2c/busses/i2c-i801.c                      |   2 +-
 drivers/i2c/busses/i2c-rtl9300.c                   |  22 +-
 drivers/input/joystick/xpad.c                      |   2 +
 drivers/input/misc/iqs7222.c                       |   3 +
 drivers/input/serio/i8042-acpipnpio.h              |  14 ++
 drivers/iommu/intel/cache.c                        |   5 +-
 drivers/iommu/intel/iommu.c                        | 263 ++++++++++++++-------
 drivers/iommu/intel/iommu.h                        |  12 +
 drivers/iommu/intel/nested.c                       |   4 +-
 drivers/iommu/intel/svm.c                          |   1 -
 drivers/irqchip/irq-mvebu-gicp.c                   |   2 +-
 drivers/md/md.c                                    |   6 +-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |  16 +-
 .../mtd/nand/raw/nuvoton-ma35d1-nand-controller.c  |   4 +-
 drivers/mtd/nand/raw/stm32_fmc2_nand.c             |  46 ++--
 drivers/mtd/nand/spi/core.c                        |  18 +-
 drivers/mtd/nand/spi/winbond.c                     |  80 ++++++-
 drivers/net/can/xilinx_can.c                       |  16 +-
 drivers/net/dsa/b53/b53_common.c                   |  17 +-
 drivers/net/ethernet/freescale/fec_main.c          |   3 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   2 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |   5 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   3 +-
 drivers/net/ethernet/ti/icssg/icssg_prueth.c       |  20 +-
 drivers/net/ethernet/wangxun/libwx/wx_hw.c         |   4 -
 drivers/net/macsec.c                               |   1 +
 drivers/net/phy/phy.c                              |  12 +-
 drivers/net/phy/phylink.c                          |  28 ++-
 drivers/net/wireless/ath/ath12k/core.h             |   1 +
 drivers/net/wireless/ath/ath12k/dp_mon.c           |  22 +-
 drivers/net/wireless/ath/ath12k/dp_rx.c            |  11 +-
 drivers/net/wireless/ath/ath12k/hw.c               |  55 +++++
 drivers/net/wireless/ath/ath12k/hw.h               |   2 +
 drivers/net/wireless/ath/ath12k/mac.c              | 127 +++++-----
 drivers/net/wireless/ath/ath12k/peer.c             |   2 +-
 drivers/net/wireless/ath/ath12k/peer.h             |  28 +++
 drivers/net/wireless/ath/ath12k/wmi.c              |  58 ++++-
 drivers/net/wireless/ath/ath12k/wmi.h              |  16 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  26 +-
 drivers/pci/controller/pci-mvebu.c                 |  21 +-
 drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c     |   4 +-
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c           |  25 +-
 drivers/phy/tegra/xusb-tegra210.c                  |   6 +-
 drivers/phy/ti/phy-omap-usb2.c                     |  13 +
 drivers/phy/ti/phy-ti-pipe3.c                      |  13 +
 drivers/regulator/sy7636a-regulator.c              |   7 +-
 drivers/tty/hvc/hvc_console.c                      |   6 +-
 drivers/tty/serial/sc16is7xx.c                     |  14 +-
 drivers/usb/gadget/function/f_midi2.c              |  11 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |   8 +-
 drivers/usb/host/xhci-dbgcap.c                     |  94 +++++---
 drivers/usb/host/xhci-mem.c                        |   2 +-
 drivers/usb/serial/option.c                        |  17 ++
 drivers/usb/typec/tcpm/tcpm.c                      |  12 +-
 fs/btrfs/extent_io.c                               |  73 +++++-
 fs/btrfs/inode.c                                   |  12 +-
 fs/btrfs/qgroup.c                                  |   6 +-
 fs/ceph/addr.c                                     |   9 +-
 fs/ceph/debugfs.c                                  |  14 +-
 fs/ceph/dir.c                                      |  17 +-
 fs/ceph/file.c                                     |  24 +-
 fs/ceph/inode.c                                    |  88 +++++--
 fs/ceph/mds_client.c                               | 172 ++++++++------
 fs/ceph/mds_client.h                               |  18 +-
 fs/coredump.c                                      |   4 +
 fs/erofs/data.c                                    |   8 +-
 fs/erofs/fileio.c                                  |   2 +-
 fs/erofs/fscache.c                                 |   2 +-
 fs/erofs/inode.c                                   |   8 +-
 fs/erofs/internal.h                                |   2 +-
 fs/erofs/super.c                                   |  16 +-
 fs/erofs/zdata.c                                   |  17 +-
 fs/erofs/zmap.c                                    |  98 ++++----
 fs/exec.c                                          |   2 +-
 fs/fhandle.c                                       |   8 +
 fs/fuse/dev.c                                      |   2 +-
 fs/fuse/file.c                                     |   5 +-
 fs/fuse/passthrough.c                              |   5 +
 fs/kernfs/file.c                                   |  58 +++--
 fs/nfs/client.c                                    |   2 +
 fs/nfs/file.c                                      |   7 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |  21 +-
 fs/nfs/inode.c                                     |   4 +-
 fs/nfs/internal.h                                  |  10 +
 fs/nfs/io.c                                        |  13 +-
 fs/nfs/localio.c                                   |  12 +-
 fs/nfs/nfs42proc.c                                 |   2 +
 fs/nfs/nfs4file.c                                  |   2 +
 fs/nfs/nfs4proc.c                                  |   7 +-
 fs/nfs/write.c                                     |   1 +
 fs/ocfs2/extent_map.c                              |  10 +-
 fs/proc/generic.c                                  |   3 +-
 fs/resctrl/ctrlmondata.c                           |   2 +-
 fs/resctrl/internal.h                              |   4 +-
 fs/resctrl/monitor.c                               |   6 +-
 fs/smb/client/cifsglob.h                           |  13 +-
 fs/smb/client/file.c                               |  18 +-
 fs/smb/client/inode.c                              |  86 +++++--
 fs/smb/client/smb2glob.h                           |   3 +-
 fs/smb/client/smb2inode.c                          | 204 ++++++++++++----
 fs/smb/client/smb2ops.c                            |  32 ++-
 fs/smb/client/smb2proto.h                          |   3 +
 fs/smb/client/trace.h                              |   9 +-
 include/drm/display/drm_dp_helper.h                |   6 +
 include/drm/drm_connector.h                        |   4 +-
 include/drm/drm_edid.h                             |   8 +
 include/linux/compiler-clang.h                     |  31 ++-
 include/linux/energy_model.h                       |  10 +
 include/linux/fs.h                                 |   3 +-
 include/linux/kasan.h                              |   6 +-
 include/linux/mtd/spinand.h                        |   8 +
 include/net/netfilter/nf_tables.h                  |  11 +-
 include/net/netfilter/nf_tables_core.h             |  49 ++--
 include/net/netns/nftables.h                       |   1 +
 include/uapi/linux/raid/md_p.h                     |   2 +-
 io_uring/rw.c                                      |   3 +
 kernel/bpf/Makefile                                |   1 +
 kernel/bpf/core.c                                  |  16 +-
 kernel/bpf/cpumap.c                                |   4 +-
 kernel/bpf/crypto.c                                |   2 +-
 kernel/bpf/helpers.c                               |   7 +-
 kernel/bpf/rqspinlock.c                            |   2 +-
 kernel/dma/debug.c                                 |  48 +++-
 kernel/dma/debug.h                                 |  20 ++
 kernel/dma/mapping.c                               |   4 +-
 kernel/events/core.c                               |   1 +
 kernel/power/energy_model.c                        |  29 ++-
 kernel/power/hibernate.c                           |   1 +
 kernel/time/hrtimer.c                              |  11 +-
 kernel/trace/fgraph.c                              |   3 +-
 kernel/trace/trace.c                               |  10 +-
 kernel/trace/trace_osnoise.c                       |   3 +
 mm/damon/core.c                                    |   4 +
 mm/damon/lru_sort.c                                |   5 +
 mm/damon/reclaim.c                                 |   5 +
 mm/damon/sysfs.c                                   |  14 +-
 mm/hugetlb.c                                       |   9 +-
 mm/kasan/shadow.c                                  |  31 ++-
 mm/khugepaged.c                                    |   4 +-
 mm/memory-failure.c                                |  20 +-
 mm/vmalloc.c                                       |   8 +-
 net/bluetooth/hci_conn.c                           |  14 +-
 net/bluetooth/hci_event.c                          |   7 +-
 net/bluetooth/iso.c                                |   2 +-
 net/bridge/br.c                                    |   7 +
 net/can/j1939/bus.c                                |   5 +-
 net/can/j1939/j1939-priv.h                         |   1 +
 net/can/j1939/main.c                               |   3 +
 net/can/j1939/socket.c                             |  52 ++++
 net/ceph/messenger.c                               |   7 +-
 net/core/dev_ioctl.c                               |  22 +-
 net/hsr/hsr_device.c                               |  28 ++-
 net/hsr/hsr_main.c                                 |   4 +-
 net/hsr/hsr_main.h                                 |   3 +
 net/ipv4/ip_tunnel_core.c                          |   6 +
 net/ipv4/tcp_bpf.c                                 |   5 +-
 net/mptcp/sockopt.c                                |  11 +-
 net/netfilter/nf_tables_api.c                      | 123 ++++++----
 net/netfilter/nft_dynset.c                         |   5 +-
 net/netfilter/nft_lookup.c                         |  67 ++++--
 net/netfilter/nft_objref.c                         |   5 +-
 net/netfilter/nft_set_bitmap.c                     |  14 +-
 net/netfilter/nft_set_hash.c                       |  54 ++---
 net/netfilter/nft_set_pipapo.c                     | 211 ++++++-----------
 net/netfilter/nft_set_pipapo_avx2.c                |  29 +--
 net/netfilter/nft_set_rbtree.c                     |  46 ++--
 net/netlink/genetlink.c                            |   3 +
 net/sunrpc/sched.c                                 |   2 -
 net/sunrpc/xprtsock.c                              |   6 +-
 net/xdp/xsk.c                                      | 113 +++++++--
 net/xdp/xsk_queue.h                                |  12 +
 samples/ftrace/ftrace-direct-modify.c              |   2 +-
 tools/testing/selftests/net/can/config             |   3 +
 234 files changed, 3151 insertions(+), 1711 deletions(-)


