Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4613F32898D;
	Wed, 17 Sep 2025 12:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113276; cv=none; b=XQ0iIqu1w7v4Ppn56ZFkl6Oxx+CyQG5lAhH2LAHng2O2P6ZtJKF7km726UJ+1fMcN6j2RIaA4zFTDKPj9bmBqAZ1Bs/xY2PPhb3Jf1FUSw4QcD9x6XeL1YU36WMOxlgCrqX+MVDGNF2gMnOB1kSjO3lK/3d7KGWBm0YCmr+WAxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113276; c=relaxed/simple;
	bh=SWQCg8ou0hn4ZRa4jweHb+tDX2+Mgz7sYC1/V8JeiRU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=n301oehHhyAWgvoeblfr+/nCqEZODcpzTGvH9FH5yQ5v0qFh0bkc7rGQ2oOAqQZcGutBVyKfMABmt82i/Ji6EaizFkZsKui4jCKdmc5qf/QHwmgt7CxEJ1ecmXeOrGnKWuOo9uKLP1FJvBvi+ljUu6FRsmzK3qNuyjQQG5M9X3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJ7zeg0f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJ7zeg0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75172C4CEF5;
	Wed, 17 Sep 2025 12:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113276;
	bh=SWQCg8ou0hn4ZRa4jweHb+tDX2+Mgz7sYC1/V8JeiRU=;
	h=From:To:Cc:Subject:Date:From;
	b=TJ7zeg0fnJBiobkjvdkOWhZ0aNoDblybytqbTVMh8CF/zzJ/7YuCAgZtbvTfVmugZ
	 gsr4IXhDJMoA3bt9IRji38byShHxhGc2cZpMDkZo8H6FuuvqSsfwdm7H5wUl3vHl/O
	 ws9L6Msj7kSR6StRZviTUr4bX0qKnyWC+QekC3as=
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
Subject: [PATCH 6.12 000/140] 6.12.48-rc1 review
Date: Wed, 17 Sep 2025 14:32:52 +0200
Message-ID: <20250917123344.315037637@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.48-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.48-rc1
X-KernelTest-Deadline: 2025-09-19T12:33+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.48 release.
There are 140 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.48-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.48-rc1

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix a memory leak in fence cleanup when unloading

Jani Nikula <jani.nikula@intel.com>
    drm/i915/power: fix size for for_each_set_bit() in abox iteration

Buday Csaba <buday.csaba@prolan.hu>
    net: mdiobus: release reset_gpio in mdiobus_unregister_device()

K Prateek Nayak <kprateek.nayak@amd.com>
    x86/cpu/topology: Always try cpu_parse_topology_ext() on AMD/Hygon

Johan Hovold <johan@kernel.org>
    phy: ti-pipe3: fix device leak at unbind

Johan Hovold <johan@kernel.org>
    phy: ti: omap-usb2: fix device leak at unbind

Johan Hovold <johan@kernel.org>
    phy: tegra: xusb: fix device and OF node leak at probe

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

Palmer Dabbelt <palmer@rivosinc.com>
    RISC-V: Remove unnecessary include from compat.h

Andreas Kemnade <akemnade@kernel.org>
    regulator: sy7636a: fix lifecycle of power good gpio

Anders Roxell <anders.roxell@linaro.org>
    dmaengine: ti: edma: Fix memory allocation size for queue_priority_map

Dan Carpenter <dan.carpenter@linaro.org>
    dmaengine: idxd: Fix double free in idxd_setup_wqs()

Yi Sun <yi.sun@intel.com>
    dmaengine: idxd: Fix refcount underflow on module unload

Yi Sun <yi.sun@intel.com>
    dmaengine: idxd: Remove improper idxd_free

Pengyu Luo <mitltlatltl@gmail.com>
    phy: qualcomm: phy-qcom-eusb2-repeater: fix override properties

Hangbin Liu <liuhangbin@gmail.com>
    hsr: use hsr_for_each_port_rtnl in hsr_port_get_hsr

Hangbin Liu <liuhangbin@gmail.com>
    hsr: use rtnl lock when iterating over ports

Murali Karicheri <m-karicheri2@ti.com>
    net: hsr: Add VLAN CTAG filter support

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

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: xilinx_can: xcan_write_frame(): fix use-after-free of transmitted SKB

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: j1939_local_ecu_get(): undo increment when j1939_local_ecu_get() fails

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: j1939_sk_bind(): call j1939_priv_put() immediately when j1939_local_ecu_get() failed

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: use udelay rather than fsleep

Michal Schmidt <mschmidt@redhat.com>
    i40e: fix IRQ freeing in i40e_vsi_request_irq_msix error path

Kohei Enju <enjuk@amazon.com>
    igb: fix link test skipping when interface is admin down

Alex Tran <alex.t.tran@gmail.com>
    docs: networking: can: change bcm_msg_head frames member to support flexible array

Antoine Tenart <atenart@kernel.org>
    tunnels: reset the GSO metadata before reusing the skb

Petr Machata <petrm@nvidia.com>
    net: bridge: Bounce invalid boolopts

Alok Tiwari <alok.a.tiwari@oracle.com>
    genetlink: fix genl_bind() invoking bind() after -EPERM

Stefan Wahren <wahrenst@gmx.net>
    net: fec: Fix possible NPD in fec_enet_phy_reset_after_clk_enable()

Chia-I Wu <olvaffe@gmail.com>
    drm/panthor: validate group queue count

Linus Torvalds <torvalds@linux-foundation.org>
    Disable SLUB_TINY for build testing

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

Christoffer Sandberg <cs@tuxedo.de>
    Input: i8042 - add TUXEDO InfinityBook Pro Gen10 AMD to i8042 quirk table

Jeff LaBundy <jeff@labundy.com>
    Input: iqs7222 - avoid enabling unused interrupts

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    hrtimers: Unconditionally update target CPU base after offline timer migration

Qu Wenruo <wqu@suse.com>
    btrfs: fix corruption reading compressed range when block size is smaller than page size

Boris Burkov <boris@bur.io>
    btrfs: use readahead_expand() on compressed extents

Santhosh Kumar K <s-k6@ti.com>
    mtd: spinand: winbond: Fix oob_layout for W25N01JW

Jeongjun Park <aha310510@gmail.com>
    mm/hugetlb: add missing hugetlb_lock in __unmap_hugepage_range()

Quanmin Yan <yanquanmin1@huawei.com>
    mm/damon/reclaim: avoid divide-by-zero in damon_reclaim_apply_parameters()

Stanislav Fort <stanislav.fort@aisle.com>
    mm/damon/sysfs: fix use-after-free in state_show()

Alex Markuze <amarkuze@redhat.com>
    ceph: fix race condition where r_parent becomes stale before sending message

Alex Markuze <amarkuze@redhat.com>
    ceph: fix race condition validating r_parent before applying state

Ilya Dryomov <idryomov@gmail.com>
    libceph: fix invalid accesses to ceph_connection_v1_info

Chen Ridong <chenridong@huawei.com>
    kernfs: Fix UAF in polling when open file is released

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    netlink: specs: mptcp: fix if-idx attribute type

Jakub Kicinski <kuba@kernel.org>
    netlink: specs: mptcp: replace underscores with dashes in names

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    netlink: specs: mptcp: clearly mention attributes

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    netlink: specs: mptcp: add missing 'server-side' attr

David Rosca <david.rosca@amd.com>
    drm/amdgpu/vcn4: Fix IB parsing with multiple engine info packages

David Rosca <david.rosca@amd.com>
    drm/amdgpu/vcn: Allow limiting ctx to instance 0 for AV1 at any time

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe: Attempt to bring bos back to VRAM after eviction

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

Wei Yang <richard.weiyang@gmail.com>
    mm/khugepaged: fix the address passed to notifier on testing young

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

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    mtd: nand: raw: atmel: Respect tAR, tCLR in read setup timing

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: asix: ax88772: drop phylink use in PM to avoid MDIO runtime PM wakeups

Chiasheng Lee <chiasheng.lee@linux.intel.com>
    i2c: i801: Hide Intel Birch Stream SoC TCO WDT

Omar Sandoval <osandov@fb.com>
    btrfs: fix subvolume deletion lockup caused by inodes xarray race

Boris Burkov <boris@bur.io>
    btrfs: fix squota compressed stats leak

Mark Tinguely <mark.tinguely@oracle.com>
    ocfs2: fix recursive semaphore deadlock in fiemap call

Krister Johansen <kjlx@templeofstupid.com>
    mptcp: sockopt: make sync_socket_options propagate SOCK_KEEPOPEN

Nathan Chancellor <nathan@kernel.org>
    compiler-clang.h: define __SANITIZE_*__ macros only when undefined

Trond Myklebust <trond.myklebust@hammerspace.com>
    Revert "SUNRPC: Don't allow waiting for exiting tasks"

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

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix out-of-bounds dynptr write in bpf_crypto_crypt

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_cf: Deny all sampling events by counter PMU

Thomas Richter <tmricht@linux.ibm.com>
    s390/pai: Deny all events not handled by this PMU

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

Max Kellermann <max.kellermann@ionos.com>
    fs/nfs/io: make nfs_start_io_*() killable

Vladimir Riabchun <ferr.lambarginio@gmail.com>
    ftrace/samples: Fix function size computation

Scott Mayhew <smayhew@redhat.com>
    nfs/localio: restore creds before releasing pageio data

Mike Snitzer <snitzer@kernel.org>
    nfs/localio: add direct IO enablement with sync and async IO support

Mike Snitzer <snitzer@kernel.org>
    nfs/localio: remove extra indirect nfs_to call to check {read,write}_iter

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

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Don't clear capabilities that won't be reset

Justin Worrell <jworrell@gmail.com>
    SUNRPC: call xs_sock_process_cmsg for all cmsg

Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
    flexfiles/pNFS: fix NULL checks on result of ff_layout_choose_ds_for_read

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Add back JPEG to video caps for carrizo and newer

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Fix built-in mic assignment on ASUS VivoBook X515UA

Aurabindo Pillai <aurabindo.pillai@amd.com>
    Revert "drm/amd/display: Optimize cursor position updates"

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix error pointers in amdgpu_dm_crtc_mem_type_changed

Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
    drm/i915/pmu: Fix zero delta busyness issue

Theodore Ts'o <tytso@mit.edu>
    ext4: introduce linear search for dentries

Huan Yang <link@vivo.com>
    Revert "udmabuf: fix vmap_udmabuf error page set"

Maurizio Lombardi <mlombard@redhat.com>
    nvme-pci: skip nvme_write_sq_db on empty rqlist

Fedor Pchelkin <pchelkin@ispras.ru>
    dma-debug: fix physical address calculation for struct dma_debug_entry

Sean Anderson <sean.anderson@linux.dev>
    dma-mapping: fix swapped dir/flags arguments to trace_dma_alloc_sgt_err

Harry Yoo <harry.yoo@oracle.com>
    mm: introduce and use {pgd,p4d}_populate_kernel()

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: HWS, change error flow on matcher disconnect

Yeoreum Yun <yeoreum.yun@arm.com>
    kunit: kasan_test: disable fortify string checker on kasan_strings() test

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    dma-debug: don't enforce dma mapping check on noncoherent allocations

Sean Anderson <sean.anderson@linux.dev>
    dma-mapping: trace more error paths

Sean Anderson <sean.anderson@linux.dev>
    dma-mapping: use trace_dma_alloc for dma_alloc* instead of using trace_dma_map

Sean Anderson <sean.anderson@linux.dev>
    dma-mapping: trace dma_alloc/free direction

Christoph Hellwig <hch@lst.de>
    dma-debug: store a phys_addr_t in struct dma_debug_entry

Amir Goldstein <amir73il@gmail.com>
    fhandle: use more consistent rules for decoding file handle from userns


-------------

Diffstat:

 .../bindings/serial/brcm,bcm7271-uart.yaml         |   2 +-
 Documentation/filesystems/nfs/localio.rst          |  13 ++
 Documentation/netlink/specs/mptcp_pm.yaml          |  52 ++---
 Documentation/networking/can.rst                   |   2 +-
 Makefile                                           |   4 +-
 arch/riscv/include/asm/compat.h                    |   1 -
 arch/s390/kernel/perf_cpum_cf.c                    |   4 +-
 arch/s390/kernel/perf_pai_crypto.c                 |   4 +-
 arch/s390/kernel/perf_pai_ext.c                    |   2 +-
 arch/x86/kernel/cpu/topology_amd.c                 |  25 +--
 drivers/dma-buf/Kconfig                            |   1 -
 drivers/dma-buf/udmabuf.c                          |  22 +--
 drivers/dma/dw/rzn1-dmamux.c                       |  15 +-
 drivers/dma/idxd/init.c                            |  39 ++--
 drivers/dma/qcom/bam_dma.c                         |   8 +-
 drivers/dma/ti/edma.c                              |   4 +-
 drivers/edac/altera_edac.c                         |   1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c           |   3 -
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |  12 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |  60 +++---
 drivers/gpu/drm/amd/amdgpu/vi.c                    |   7 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   5 +
 .../gpu/drm/amd/display/dc/dpp/dcn10/dcn10_dpp.c   |   7 +-
 .../drm/amd/display/dc/dpp/dcn401/dcn401_dpp_cm.c  |   6 +-
 .../gpu/drm/amd/display/dc/hubp/dcn20/dcn20_hubp.c |   8 +-
 .../drm/amd/display/dc/hubp/dcn401/dcn401_hubp.c   |  10 +-
 .../drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c    |   2 +-
 drivers/gpu/drm/i915/display/intel_display_power.c |   6 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |  16 ++
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |  11 +-
 drivers/gpu/drm/panthor/panthor_drv.c              |   2 +-
 drivers/gpu/drm/xe/tests/xe_bo.c                   |   2 +-
 drivers/gpu/drm/xe/tests/xe_dma_buf.c              |  10 +-
 drivers/gpu/drm/xe/xe_bo.c                         |  16 +-
 drivers/gpu/drm/xe/xe_bo.h                         |   2 +-
 drivers/gpu/drm/xe/xe_dma_buf.c                    |   2 +-
 drivers/i2c/busses/i2c-i801.c                      |   2 +-
 drivers/input/misc/iqs7222.c                       |   3 +
 drivers/input/serio/i8042-acpipnpio.h              |  14 ++
 drivers/mtd/nand/raw/atmel/nand-controller.c       |  16 +-
 drivers/mtd/nand/raw/stm32_fmc2_nand.c             |  46 ++---
 drivers/mtd/nand/spi/winbond.c                     |  37 +++-
 drivers/net/can/xilinx_can.c                       |  16 +-
 drivers/net/ethernet/freescale/fec_main.c          |   3 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   2 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |   5 +-
 .../mlx5/core/steering/hws/mlx5hws_matcher.c       |  24 +--
 drivers/net/phy/mdio_bus.c                         |   4 +-
 drivers/nvme/host/pci.c                            |   3 +
 drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c     |   4 +-
 drivers/phy/tegra/xusb-tegra210.c                  |   6 +-
 drivers/phy/ti/phy-omap-usb2.c                     |  13 ++
 drivers/phy/ti/phy-ti-pipe3.c                      |  13 ++
 drivers/regulator/sy7636a-regulator.c              |   7 +-
 drivers/tty/hvc/hvc_console.c                      |   6 +-
 drivers/tty/serial/sc16is7xx.c                     |  14 +-
 drivers/usb/gadget/function/f_midi2.c              |  11 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |   8 +-
 drivers/usb/host/xhci-mem.c                        |   2 +-
 drivers/usb/serial/option.c                        |  17 ++
 drivers/usb/typec/tcpm/tcpm.c                      |  12 +-
 fs/btrfs/extent_io.c                               |  72 ++++++-
 fs/btrfs/inode.c                                   |  12 +-
 fs/btrfs/qgroup.c                                  |   6 +-
 fs/ceph/debugfs.c                                  |  14 +-
 fs/ceph/dir.c                                      |  17 +-
 fs/ceph/file.c                                     |  24 +--
 fs/ceph/inode.c                                    |  88 +++++++--
 fs/ceph/mds_client.c                               | 172 ++++++++++-------
 fs/ceph/mds_client.h                               |  18 +-
 fs/ext4/namei.c                                    |  14 +-
 fs/fhandle.c                                       |   8 +
 fs/fuse/file.c                                     |   5 +-
 fs/fuse/passthrough.c                              |   5 +
 fs/kernfs/file.c                                   |  58 ++++--
 fs/nfs/client.c                                    |   2 +
 fs/nfs/direct.c                                    |  22 ++-
 fs/nfs/file.c                                      |  21 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |  21 +-
 fs/nfs/inode.c                                     |   4 +-
 fs/nfs/internal.h                                  |  17 +-
 fs/nfs/io.c                                        |  55 ++++--
 fs/nfs/localio.c                                   | 125 +++++++++---
 fs/nfs/nfs42proc.c                                 |   2 +
 fs/nfs/nfs4file.c                                  |   2 +
 fs/nfs/nfs4proc.c                                  |   7 +-
 fs/nfs/write.c                                     |   1 +
 fs/ocfs2/extent_map.c                              |  10 +-
 fs/proc/generic.c                                  |   3 +-
 include/linux/compiler-clang.h                     |  31 ++-
 include/linux/fs.h                                 |  10 +-
 include/linux/nfs_xdr.h                            |   1 +
 include/linux/pgalloc.h                            |  29 +++
 include/linux/pgtable.h                            |  13 +-
 include/net/netfilter/nf_tables.h                  |  11 +-
 include/net/netfilter/nf_tables_core.h             |  49 ++---
 include/net/netns/nftables.h                       |   1 +
 include/trace/events/dma.h                         | 153 ++++++++++++++-
 include/uapi/linux/mptcp_pm.h                      |  50 ++---
 kernel/bpf/core.c                                  |  16 +-
 kernel/bpf/crypto.c                                |   2 +-
 kernel/bpf/helpers.c                               |   7 +-
 kernel/dma/debug.c                                 | 135 ++++++++-----
 kernel/dma/debug.h                                 |  20 ++
 kernel/dma/mapping.c                               |  41 ++--
 kernel/time/hrtimer.c                              |  11 +-
 kernel/trace/fgraph.c                              |   3 +-
 kernel/trace/trace.c                               |  10 +-
 mm/Kconfig                                         |   2 +-
 mm/damon/core.c                                    |   4 +
 mm/damon/lru_sort.c                                |   5 +
 mm/damon/reclaim.c                                 |   5 +
 mm/damon/sysfs.c                                   |  14 +-
 mm/hugetlb.c                                       |   9 +-
 mm/kasan/init.c                                    |  12 +-
 mm/kasan/kasan_test_c.c                            |   1 +
 mm/khugepaged.c                                    |   4 +-
 mm/memory-failure.c                                |  20 +-
 mm/percpu.c                                        |   6 +-
 mm/sparse-vmemmap.c                                |   6 +-
 net/bridge/br.c                                    |   7 +
 net/can/j1939/bus.c                                |   5 +-
 net/can/j1939/socket.c                             |   3 +
 net/ceph/messenger.c                               |   7 +-
 net/hsr/hsr_device.c                               |  97 +++++++++-
 net/hsr/hsr_main.c                                 |   4 +-
 net/hsr/hsr_main.h                                 |   3 +
 net/ipv4/ip_tunnel_core.c                          |   6 +
 net/ipv4/tcp_bpf.c                                 |   5 +-
 net/mptcp/sockopt.c                                |  11 +-
 net/netfilter/nf_tables_api.c                      | 123 +++++++-----
 net/netfilter/nft_dynset.c                         |   5 +-
 net/netfilter/nft_lookup.c                         |  67 +++++--
 net/netfilter/nft_objref.c                         |   5 +-
 net/netfilter/nft_set_bitmap.c                     |  11 +-
 net/netfilter/nft_set_hash.c                       |  54 +++---
 net/netfilter/nft_set_pipapo.c                     | 211 ++++++++-------------
 net/netfilter/nft_set_pipapo_avx2.c                |  29 +--
 net/netfilter/nft_set_rbtree.c                     |  46 +++--
 net/netlink/genetlink.c                            |   3 +
 net/sunrpc/sched.c                                 |   2 -
 net/sunrpc/xprtsock.c                              |   6 +-
 samples/ftrace/ftrace-direct-modify.c              |   2 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 144 files changed, 1887 insertions(+), 986 deletions(-)


