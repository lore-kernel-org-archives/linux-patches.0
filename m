Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD5F32E738;
	Wed, 17 Sep 2025 12:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113695; cv=none; b=d5bgRQ/w0enn8ZDYxyG45WsV2XRVUguQM6rxhXSoSKYZzfdWoLiFTe9r6MFJ9Lsp/o1qbzmtiEEXY7Djq6DosMKY1U1EABDjVaZbze5mAHxXsKQG7TYgSJJyLIYZ6co6ApasWlvs/44PcGUjQC+yPCwEA4biUMFypqy+vJT+AW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113695; c=relaxed/simple;
	bh=QyU5aWByYkc13FSV3+YDMwpk5CKOuEzw/gp6Hu0yddw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=j9cFCvCIuBoSMD8IfGOFYmV59GQJ5VdciUyS4jktlw+OutSs+gC+BirNR76qUtbjRX5ckuIiXQSALmWCccb4RNboT95yqiBlzzN3YStgHMG4iOZLdMbuHgMoZlNyHnJiWst4O/1DOPCxgm/Ux3oycAdManB5k5Qx0iOutnMLKHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6ACOout; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6ACOout"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC22FC4CEF0;
	Wed, 17 Sep 2025 12:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113695;
	bh=QyU5aWByYkc13FSV3+YDMwpk5CKOuEzw/gp6Hu0yddw=;
	h=From:To:Cc:Subject:Date:From;
	b=R6ACOout8k3LOJqPqgPpJwfDPVGqtnc/0DUPLfczyvVq9bUaOv9wuzn1yuyhWtrWL
	 UvKsgyPtXagkr7yg8sOzoh3infO6E2er4RhO2HeerZayaLfRzX0kjs3XEsk1fBqggh
	 1iIk2WjeQtt7EQb+AkVtJfJcAQmVWRqoPUZHZaL0=
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
Subject: [PATCH 6.6 000/101] 6.6.107-rc1 review
Date: Wed, 17 Sep 2025 14:33:43 +0200
Message-ID: <20250917123336.863698492@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.107-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.107-rc1
X-KernelTest-Deadline: 2025-09-19T12:33+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.107 release.
There are 101 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.107-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.107-rc1

Jani Nikula <jani.nikula@intel.com>
    drm/i915/power: fix size for for_each_set_bit() in abox iteration

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix a memory leak in fence cleanup when unloading

Buday Csaba <buday.csaba@prolan.hu>
    net: mdiobus: release reset_gpio in mdiobus_unregister_device()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix null pointer dereference in alloc_preauth_hash()

Johan Hovold <johan@kernel.org>
    phy: ti-pipe3: fix device leak at unbind

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

Alan Stern <stern@rowland.harvard.edu>
    USB: gadget: dummy-hcd: Fix locking bug in RT-enabled kernels

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix memory leak regression when freeing xhci vdev devices depth first

Palmer Dabbelt <palmer@rivosinc.com>
    RISC-V: Remove unnecessary include from compat.h

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    hrtimers: Unconditionally update target CPU base after offline timer migration

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    hrtimer: Rename __hrtimer_hres_active() to hrtimer_hres_active()

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    hrtimer: Remove unused function

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

Hangbin Liu <liuhangbin@gmail.com>
    hsr: use hsr_for_each_port_rtnl in hsr_port_get_hsr

Hangbin Liu <liuhangbin@gmail.com>
    hsr: use rtnl lock when iterating over ports

Murali Karicheri <m-karicheri2@ti.com>
    net: hsr: Add VLAN CTAG filter support

Murali Karicheri <m-karicheri2@ti.com>
    net: hsr: Add support for MC filtering at the slave device

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: xilinx_can: xcan_write_frame(): fix use-after-free of transmitted SKB

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: j1939_local_ecu_get(): undo increment when j1939_local_ecu_get() fails

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: j1939_sk_bind(): call j1939_priv_put() immediately when j1939_local_ecu_get() failed

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

Stefan Wahren <wahrenst@gmx.net>
    net: fec: Fix possible NPD in fec_enet_phy_reset_after_clk_enable()

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

Chen Ridong <chenridong@huawei.com>
    kernfs: Fix UAF in polling when open file is released

Yang Erkun <yangerkun@huawei.com>
    cifs: fix pagecache leak when do writepages

Wei Yang <richard.weiyang@gmail.com>
    mm/khugepaged: fix the address passed to notifier on testing young

Vishal Moola (Oracle) <vishal.moola@gmail.com>
    mm/khugepaged: convert hpage_collapse_scan_pmd() to use folios

Qu Wenruo <wqu@suse.com>
    btrfs: fix corruption reading compressed range when block size is smaller than page size

Boris Burkov <boris@bur.io>
    btrfs: use readahead_expand() on compressed extents

Quanmin Yan <yanquanmin1@huawei.com>
    mm/damon/lru_sort: avoid divide-by-zero in damon_lru_sort_apply_parameters()

Quanmin Yan <yanquanmin1@huawei.com>
    mm/damon/reclaim: avoid divide-by-zero in damon_reclaim_apply_parameters()

Stanislav Fort <stanislav.fort@aisle.com>
    mm/damon/sysfs: fix use-after-free in state_show()

Ilya Dryomov <idryomov@gmail.com>
    libceph: fix invalid accesses to ceph_connection_v1_info

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    mtd: nand: raw: atmel: Respect tAR, tCLR in read setup timing

Alexander Dahl <ada@thorsis.com>
    mtd: nand: raw: atmel: Fix comment in timings preparation

David Rosca <david.rosca@amd.com>
    drm/amdgpu/vcn4: Fix IB parsing with multiple engine info packages

David Rosca <david.rosca@amd.com>
    drm/amdgpu/vcn: Allow limiting ctx to instance 0 for AV1 at any time

Johan Hovold <johan@kernel.org>
    drm/mediatek: fix potential OF node use-after-free

Sang-Heon Jeon <ekffu200098@gmail.com>
    mm/damon/core: set quota->charged_from to jiffies at first charge window

Miaohe Lin <linmiaohe@huawei.com>
    mm/memory-failure: fix VM_BUG_ON_PAGE(PagePoisoned(page)) when unpoison memory

Miklos Szeredi <mszeredi@redhat.com>
    fuse: prevent overflow in copy_file_range return value

Miklos Szeredi <mszeredi@redhat.com>
    fuse: check if copy_file_range() returns larger than requested size

Christophe Kerello <christophe.kerello@foss.st.com>
    mtd: rawnand: stm32_fmc2: fix ECC overwrite

Christophe Kerello <christophe.kerello@foss.st.com>
    mtd: rawnand: stm32_fmc2: avoid overlapping mappings on ECC buffer

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: asix: ax88772: drop phylink use in PM to avoid MDIO runtime PM wakeups

Chiasheng Lee <chiasheng.lee@linux.intel.com>
    i2c: i801: Hide Intel Birch Stream SoC TCO WDT

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

Borislav Petkov (AMD) <bp@alien8.de>
    KVM: SVM: Set synthesized TSA CPUID flags

Paul E. McKenney <paulmck@kernel.org>
    rcu-tasks: Maintain real-time response in rcu_tasks_postscan()

Paul E. McKenney <paulmck@kernel.org>
    rcu-tasks: Eliminate deadlocks involving do_exit() and RCU tasks

Paul E. McKenney <paulmck@kernel.org>
    rcu-tasks: Maintain lists to eliminate RCU-tasks/do_exit() deadlocks

wangzijie <wangzijie1@honor.com>
    proc: fix type confusion in pde_set_flags()

Kuniyuki Iwashima <kuniyu@google.com>
    tcp_bpf: Call sk_msg_free() when tcp_bpf_send_verdict() fails to allocate psock->cork.

Peilin Ye <yepeilin@google.com>
    bpf: Tell memcg to use allow_spinning=false path in bpf_timer_init()

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_cf: Deny all sampling events by counter PMU

Pu Lehui <pulehui@huawei.com>
    tracing: Silence warning when chunk allocation fails in trace_pid_write

Jonathan Curley <jcurley@purestorage.com>
    NFSv4/flexfiles: Fix layout merge mirror check.

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

Luo Gengkun <luogengkun@huaweicloud.com>
    tracing: Fix tracing_marker may trigger page fault during preempt_disable

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Clear the NFS_CAP_XATTR flag if not supported by the server

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Clear the NFS_CAP_FS_LOCATIONS flag if it is not set

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Don't clear capabilities that won't be reset

Justin Worrell <jworrell@gmail.com>
    SUNRPC: call xs_sock_process_cmsg for all cmsg

Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
    flexfiles/pNFS: fix NULL checks on result of ff_layout_choose_ds_for_read

Mimi Zohar <zohar@linux.ibm.com>
    ima: limit the number of ToMToU integrity violations

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix null-ptr-deref by sock_lock_init_class_and_name() and rmmod.

André Apitzsch <git@apitzsch.eu>
    media: i2c: imx214: Fix link frequency validation

Chuck Lever <chuck.lever@oracle.com>
    NFSD: nfsd_unlink() clobbers non-zero status returned from fh_fill_pre_attrs()

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd: Fix a regression in nfsd_setattr()

Ada Couprie Diaz <ada.coupriediaz@arm.com>
    kasan: fix GCC mem-intrinsic prefix with sw tags

Harry Yoo <harry.yoo@oracle.com>
    mm: introduce and use {pgd,p4d}_populate_kernel()

Yeoreum Yun <yeoreum.yun@arm.com>
    kunit: kasan_test: disable fortify string checker on kasan_strings() test


-------------

Diffstat:

 .../bindings/serial/brcm,bcm7271-uart.yaml         |   2 +-
 Documentation/networking/can.rst                   |   2 +-
 Makefile                                           |   4 +-
 arch/riscv/include/asm/compat.h                    |   1 -
 arch/s390/kernel/perf_cpum_cf.c                    |   4 +-
 arch/x86/kvm/cpuid.c                               |   5 +
 drivers/dma/dw/rzn1-dmamux.c                       |  15 +-
 drivers/dma/idxd/init.c                            |  39 ++---
 drivers/dma/qcom/bam_dma.c                         |   8 +-
 drivers/dma/ti/edma.c                              |   4 +-
 drivers/edac/altera_edac.c                         |   1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c           |   3 -
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |  12 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |  60 ++++----
 drivers/gpu/drm/i915/display/intel_display_power.c |   6 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |  11 +-
 drivers/i2c/busses/i2c-i801.c                      |   2 +-
 drivers/input/misc/iqs7222.c                       |   3 +
 drivers/input/serio/i8042-acpipnpio.h              |  14 ++
 drivers/media/i2c/imx214.c                         |  27 ++--
 drivers/mtd/nand/raw/atmel/nand-controller.c       |  18 ++-
 drivers/mtd/nand/raw/stm32_fmc2_nand.c             |  46 +++---
 drivers/net/can/xilinx_can.c                       |  16 +--
 drivers/net/ethernet/freescale/fec_main.c          |   3 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   2 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |   5 +-
 drivers/net/phy/mdio_bus.c                         |   4 +-
 drivers/phy/tegra/xusb-tegra210.c                  |   6 +-
 drivers/phy/ti/phy-ti-pipe3.c                      |  13 ++
 drivers/regulator/sy7636a-regulator.c              |   7 +-
 drivers/tty/hvc/hvc_console.c                      |   6 +-
 drivers/tty/serial/sc16is7xx.c                     |  14 +-
 drivers/usb/gadget/function/f_midi2.c              |  11 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |   8 +-
 drivers/usb/host/xhci-mem.c                        |   2 +-
 drivers/usb/serial/option.c                        |  17 +++
 fs/btrfs/extent_io.c                               |  78 ++++++++--
 fs/fuse/file.c                                     |   5 +-
 fs/kernfs/file.c                                   |  54 ++++---
 fs/nfs/client.c                                    |   2 +
 fs/nfs/direct.c                                    |  21 ++-
 fs/nfs/file.c                                      |  14 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |  21 +--
 fs/nfs/inode.c                                     |   4 +-
 fs/nfs/internal.h                                  |  17 ++-
 fs/nfs/io.c                                        |  55 ++++---
 fs/nfs/nfs42proc.c                                 |   2 +
 fs/nfs/nfs4file.c                                  |   2 +
 fs/nfs/nfs4proc.c                                  |   6 +-
 fs/nfsd/nfs4proc.c                                 |   4 +
 fs/nfsd/vfs.c                                      |  13 +-
 fs/ocfs2/extent_map.c                              |  10 +-
 fs/proc/generic.c                                  |   3 +-
 fs/smb/client/file.c                               |  16 ++-
 fs/smb/server/connection.h                         |  11 ++
 fs/smb/server/mgmt/user_session.c                  |   4 +-
 fs/smb/server/smb2pdu.c                            |  14 +-
 include/linux/compiler-clang.h                     |  31 +++-
 include/linux/pgalloc.h                            |  29 ++++
 include/linux/pgtable.h                            |  13 +-
 include/net/sock.h                                 |  40 +++++-
 kernel/bpf/helpers.c                               |   7 +-
 kernel/rcu/tasks.h                                 | 107 ++++++++++----
 kernel/time/hrtimer.c                              |  50 ++-----
 kernel/trace/trace.c                               |  10 +-
 mm/Kconfig                                         |   2 +-
 mm/damon/core.c                                    |   4 +
 mm/damon/lru_sort.c                                |   3 +
 mm/damon/reclaim.c                                 |   3 +
 mm/damon/sysfs.c                                   |  14 +-
 mm/kasan/init.c                                    |  12 +-
 mm/kasan/kasan_test.c                              |   1 +
 mm/khugepaged.c                                    |  22 +--
 mm/memory-failure.c                                |   7 +-
 mm/percpu.c                                        |   6 +-
 mm/sparse-vmemmap.c                                |   6 +-
 net/bridge/br.c                                    |   7 +
 net/can/j1939/bus.c                                |   5 +-
 net/can/j1939/socket.c                             |   3 +
 net/ceph/messenger.c                               |   7 +-
 net/core/sock.c                                    |   5 +
 net/hsr/hsr_device.c                               | 158 ++++++++++++++++++++-
 net/hsr/hsr_main.c                                 |   4 +-
 net/hsr/hsr_main.h                                 |   3 +
 net/ipv4/ip_tunnel_core.c                          |   6 +
 net/ipv4/tcp_bpf.c                                 |   5 +-
 net/mptcp/sockopt.c                                |  11 +-
 net/sunrpc/sched.c                                 |   2 -
 net/sunrpc/xprtsock.c                              |   6 +-
 samples/ftrace/ftrace-direct-modify.c              |   2 +-
 scripts/Makefile.kasan                             |  12 +-
 security/integrity/ima/ima_main.c                  |  16 ++-
 security/integrity/integrity.h                     |   3 +-
 93 files changed, 976 insertions(+), 403 deletions(-)


