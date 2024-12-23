Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B78188006;
	Mon, 23 Dec 2024 16:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970279; cv=none; b=cfdCxcZKAEgiKVb98KzkFuGWY+U0/nTaDyPjcriR9poDsuoeivyjxE4919cwFkP8l51zB4Uh6p7+SanNfNV5hdGOEu/cOPYJQWDd7gLnlKDgKw4xODtr90mqhcRNL0IinzJThHep55RL754wMWuNNY6717Dsk4d0ggufaev/RiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970279; c=relaxed/simple;
	bh=sK3+eZ1/nY4kxIh0M0BAxteMxv37u6CVw7Jyxmc17Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mHOB/MvT3UL5n4CsK7lvaR1wQX1PyQFnTN7Hpsz6i7xdOZ9W8aEtFlMtgxXIw55oKXdogl1cqBxmqFCQPdWBtRDUBLWJ9iYHQwuaJlfF1q8M0qxxWaZD5cXSj1l6B6xcSviHOkUrljGnV7zroEKN5e24+2J0B6vl93Y3gyE87JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ivqXpgZb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ivqXpgZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31199C4CED3;
	Mon, 23 Dec 2024 16:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970278;
	bh=sK3+eZ1/nY4kxIh0M0BAxteMxv37u6CVw7Jyxmc17Bg=;
	h=From:To:Cc:Subject:Date:From;
	b=ivqXpgZbHcQ/bxTkbAMkH5CW+pRlaJVl1hwpp5yniK2p7EkbLBX9GXdW3edU9WQsm
	 BL+8nxC7H9HQ2FPpyquR4V5qsO8cXi3HTBN5szqyUpwjk5eA6+18R8Ig1jyJ2b87vF
	 t8ZrbUwRSzFbuBVsMVY3SqyjDRESPLvdSz1hBPoE=
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
Subject: [PATCH 6.6 000/116] 6.6.68-rc1 review
Date: Mon, 23 Dec 2024 16:57:50 +0100
Message-ID: <20241223155359.534468176@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.68-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.68-rc1
X-KernelTest-Deadline: 2024-12-25T15:54+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.68 release.
There are 116 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 27 Dec 2024 15:53:30 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.68-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.68-rc1

Michel Dänzer <mdaenzer@redhat.com>
    drm/amdgpu: Handle NULL bo->tbo.resource (again) in amdgpu_vm_bo_update

Francesco Dolcini <francesco.dolcini@toradex.com>
    net: fec: make PPS channel configurable

Francesco Dolcini <francesco.dolcini@toradex.com>
    net: fec: refactor PPS channel configuration

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/rw: avoid punting to io-wq directly

Jens Axboe <axboe@kernel.dk>
    io_uring/rw: treat -EOPNOTSUPP for IOCB_NOWAIT like -EAGAIN

Jens Axboe <axboe@kernel.dk>
    io_uring/rw: split io_read() into a helper

Xuewen Yan <xuewen.yan@unisoc.com>
    epoll: Add synchronous wakeup support for ep_poll_callback

Max Kellermann <max.kellermann@ionos.com>
    ceph: fix memory leaks in __ceph_sync_read()

Alex Markuze <amarkuze@redhat.com>
    ceph: improve error handling and short/overflow-read logic in __ceph_sync_read()

Ilya Dryomov <idryomov@gmail.com>
    ceph: validate snapdirname option length when mounting

Zijun Hu <quic_zijuhu@quicinc.com>
    of: Fix refcount leakage for OF node returned by __of_get_dma_parent()

Herve Codina <herve.codina@bootlin.com>
    of: Fix error path in of_parse_phandle_with_args_map()

Jann Horn <jannh@google.com>
    udmabuf: also check for F_SEAL_FUTURE_WRITE

Edward Adam Davis <eadavis@qq.com>
    nilfs2: prevent use of deleted inode

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix buffer head leaks in calls to truncate_inode_pages()

Zijun Hu <quic_zijuhu@quicinc.com>
    of/irq: Fix using uninitialized variable @addr_len in API of_irq_parse_one()

Zijun Hu <quic_zijuhu@quicinc.com>
    of/irq: Fix interrupt-map cell length check in of_irq_parse_imap_parent()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS/pnfs: Fix a live lock between recalled layouts and layoutget

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: check if iowq is killed before queuing

Jann Horn <jannh@google.com>
    io_uring: Fix registered ring file refcount leak

Tiezhu Yang <yangtiezhu@loongson.cn>
    selftests/bpf: Use asm constraint "m" for LoongArch

Isaac J. Manjarres <isaacmanjarres@google.com>
    selftests/memfd: run sysctl tests when PID namespace support is enabled

Steven Rostedt <rostedt@goodmis.org>
    tracing: Add "%s" check in test_event_printk()

Steven Rostedt <rostedt@goodmis.org>
    tracing: Add missing helper functions in event pointer dereference check

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix test_event_printk() to process entire print argument

Enzo Matsumiya <ematsumiya@suse.de>
    smb: client: fix TCP timers deadlock after rmmod

Sean Christopherson <seanjc@google.com>
    KVM: x86: Play nice with protected guests in complete_hypercall_exit()

Michael Kelley <mhklinux@outlook.com>
    Drivers: hv: util: Avoid accessing a ringbuffer not initialized yet

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: reject inline extent items with 0 ref count

Matthew Wilcox (Oracle) <willy@infradead.org>
    vmalloc: fix accounting with i915

Kairui Song <kasong@tencent.com>
    zram: fix uninitialized ZRAM not releasing backing device

Kairui Song <kasong@tencent.com>
    zram: refuse to use zero sized block device as backing device

Murad Masimov <m.masimov@maxima.ru>
    hwmon: (tmp513) Fix interpretation of values of Temperature Result and Limit Registers

Murad Masimov <m.masimov@maxima.ru>
    hwmon: (tmp513) Fix Current Register value interpretation

Murad Masimov <m.masimov@maxima.ru>
    hwmon: (tmp513) Fix interpretation of values of Shunt Voltage and Limit Registers

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    hwmon: (tmp513) Use SI constants from units.h

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    hwmon: (tmp513) Simplify with dev_err_probe()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    hwmon: (tmp513) Don't use "proxy" headers

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/amdgpu: don't access invalid sched

Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
    i915/guc: Accumulate active runtime on gt reset

Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
    i915/guc: Ensure busyness counter increases motonically

Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
    i915/guc: Reset engine utilization buffer before registration

Yang Yingliang <yangyingliang@huawei.com>
    drm/panel: novatek-nt35950: fix return value check in nt35950_probe()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/modes: Avoid divide by zero harder in drm_mode_vrefresh()

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Improve redrive mode handling

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit FE910C04 rmnet compositions

Jack Wu <wojackbb@gmail.com>
    USB: serial: option: add MediaTek T7XX compositions

Mank Wang <mank.wang@netprisma.com>
    USB: serial: option: add Netprisma LCUK54 modules for WWAN Ready

Michal Hrusecky <michal.hrusecky@turris.com>
    USB: serial: option: add MeiG Smart SLM770A

Daniel Swanemar <d.swanemar@gmail.com>
    USB: serial: option: add TCL IK512 MBIM & ECM

Nathan Chancellor <nathan@kernel.org>
    hexagon: Disable constant extender optimization for LLVM prior to 19.1.0

James Bottomley <James.Bottomley@HansenPartnership.com>
    efivarfs: Fix error on non-existent file

Geert Uytterhoeven <geert+renesas@glider.be>
    i2c: riic: Always round-up when calculating bus period

Dan Carpenter <dan.carpenter@linaro.org>
    chelsio/chtls: prevent potential integer overflow on 32bit

Eric Dumazet <edumazet@google.com>
    net: tun: fix tun_napi_alloc_frags()

Sean Christopherson <seanjc@google.com>
    KVM: x86: Cache CPUID.0xD XSTATE offsets+sizes during module init

Borislav Petkov (AMD) <bp@alien8.de>
    EDAC/amd64: Simplify ECC check on unified memory controllers

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    mmc: mtk-sd: disable wakeup in .remove() and in the error path of .probe()

Prathamesh Shete <pshete@nvidia.com>
    mmc: sdhci-tegra: Remove SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC quirk

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    net: mdiobus: fix an OF node reference leak

Adrian Moreno <amorenoz@redhat.com>
    selftests: openvswitch: fix tcpdump execution

Phil Sutter <phil@nwl.cc>
    netfilter: ipset: Fix for recursive locking warning

David Laight <David.Laight@ACULAB.COM>
    ipvs: Fix clamp() of ip_vs_conn_tab on small memory systems

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    net: ethernet: bgmac-platform: fix an OF node reference leak

Dan Carpenter <dan.carpenter@linaro.org>
    net: hinic: Fix cleanup in create_rxqs/txqs()

Marios Makassikis <mmakassikis@freebox.fr>
    ksmbd: fix broken transfers when exceeding max simultaneous operations

Marios Makassikis <mmakassikis@freebox.fr>
    ksmbd: count all requests in req_running counter

Nikita Yushchenko <nikita.yoush@cogentembedded.com>
    net: renesas: rswitch: rework ts tags management

Shannon Nelson <shannon.nelson@amd.com>
    ionic: use ee->offset when returning sprom data

Brett Creeley <brett.creeley@amd.com>
    ionic: Fix netdev notifier unregister on failure

Eric Dumazet <edumazet@google.com>
    netdevsim: prevent bad user input in nsim_dev_health_break_write()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix incorrect IFH SRC_PORT field in ocelot_ifh_set_basic()

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: check return value of sock_recvmsg when draining clc data

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: check smcd_v2_ext_offset when receiving proposal msg

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: check v2_ext_offset/eid_cnt/ism_gid_cnt when receiving proposal msg

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: check iparea_offset and ipv6_prefixes_cnt when receiving proposal msg

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: check sndbuf_space again after NOSPACE flag is set in smc_poll

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: protect link down work from execute after lgr freed

Huaisheng Ye <huaisheng.ye@intel.com>
    cxl/region: Fix region creation for greater than x2 switches

Davidlohr Bueso <dave@stgolabs.net>
    cxl/pci: Fix potential bogus return value upon successful probing

Olaf Hering <olaf@aepfle.de>
    tools: hv: change permissions of NetworkManager configuration file

Darrick J. Wong <djwong@kernel.org>
    xfs: reset rootdir extent size hint after growfsrt

Darrick J. Wong <djwong@kernel.org>
    xfs: take m_growlock when running growfsrt

Darrick J. Wong <djwong@kernel.org>
    xfs: use XFS_BUF_DADDR_NULL for daddrs in getfsmap code

Zizhi Wo <wozizhi@huawei.com>
    xfs: Fix the owner setting issue for rmap query in xfs fsmap

Darrick J. Wong <djwong@kernel.org>
    xfs: conditionally allow FS_XFLAG_REALTIME changes if S_DAX is set

Darrick J. Wong <djwong@kernel.org>
    xfs: attr forks require attr, not attr2

Julian Sun <sunjunchao2870@gmail.com>
    xfs: remove unused parameter in macro XFS_DQUOT_LOGRES

Darrick J. Wong <djwong@kernel.org>
    xfs: fix file_path handling in tracepoints

Chen Ni <nichen@iscas.ac.cn>
    xfs: convert comma to semicolon

lei lu <llfamsec@gmail.com>
    xfs: don't walk off the end of a directory data block

John Garry <john.g.garry@oracle.com>
    xfs: Fix xfs_prepare_shift() range for RT

John Garry <john.g.garry@oracle.com>
    xfs: Fix xfs_flush_unmap_range() range for RT

Darrick J. Wong <djwong@kernel.org>
    xfs: create a new helper to return a file's allocation unit

Darrick J. Wong <djwong@kernel.org>
    xfs: declare xfs_file.c symbols in xfs_file.h

Darrick J. Wong <djwong@kernel.org>
    xfs: use consistent uid/gid when grabbing dquots for inodes

Darrick J. Wong <djwong@kernel.org>
    xfs: verify buffer, inode, and dquot items every tx commit

Christoph Hellwig <hch@lst.de>
    xfs: fix the contact address for the sysfs ABI documentation

Vladimir Riabchun <ferr.lambarginio@gmail.com>
    i2c: pnx: Fix timeout in wait functions

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    p2sb: Do not scan and remove the P2SB device when it is unhidden

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    p2sb: Move P2SB hide and unhide code to p2sb_scan_and_cache()

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    p2sb: Introduce the global flag p2sb_hidden_by_bios

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    p2sb: Factor out p2sb_read_from_cache()

Hans de Goede <hdegoede@redhat.com>
    platform/x86: p2sb: Make p2sb_get_devfn() return void

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: stmmac: fix TSO DMA API usage causing oops

Roger Quadros <rogerq@kernel.org>
    usb: cdns3: Add quirk flag to enable suspend residency

Kai-Heng Feng <kai.heng.feng@canonical.com>
    PCI/AER: Disable AER service on suspend

Vidya Sagar <vidyas@nvidia.com>
    PCI: Use preserve_config in place of pci_flags

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: add quirk for Dell SKU 0B8C

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: fix jack detection on ADL-N variant RVP

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Loongson64: DTS: Fix msi node for ls7a

Roger Quadros <rogerq@kernel.org>
    usb: cdns3-ti: Add workaround for Errata i2409

Ajit Khaparde <ajit.khaparde@broadcom.com>
    PCI: Add ACS quirk for Broadcom BCM5760X NIC

Jiwei Sun <sunjw10@lenovo.com>
    PCI: vmd: Create domain symlink before pci_bus_add_devices()

Peng Hongchi <hongchi.peng@siengine.com>
    usb: dwc2: gadget: Don't write invalid mapped sg entries into dma_desc with iommu enabled

Lion Ackermann <nnamrec@gmail.com>
    net: sched: fix ordering of qlen adjustment


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-fs-xfs             |   8 +-
 Makefile                                           |   4 +-
 arch/hexagon/Makefile                              |   6 +
 .../boot/dts/loongson/loongson64g_4core_ls7a.dts   |   1 +
 arch/x86/kvm/cpuid.c                               |  31 +++-
 arch/x86/kvm/cpuid.h                               |   1 +
 arch/x86/kvm/x86.c                                 |   4 +-
 drivers/block/zram/zram_drv.c                      |  15 +-
 drivers/cxl/core/region.c                          |  25 ++-
 drivers/cxl/pci.c                                  |   3 +-
 drivers/dma-buf/udmabuf.c                          |   2 +-
 drivers/edac/amd64_edac.c                          |  32 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   7 +-
 drivers/gpu/drm/drm_modes.c                        |  11 +-
 drivers/gpu/drm/i915/gt/intel_engine_types.h       |   5 +
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |  41 ++++-
 drivers/gpu/drm/panel/panel-novatek-nt35950.c      |   4 +-
 drivers/hv/hv_kvp.c                                |   6 +
 drivers/hv/hv_snapshot.c                           |   6 +
 drivers/hv/hv_util.c                               |   9 +
 drivers/hv/hyperv_vmbus.h                          |   2 +
 drivers/hwmon/tmp513.c                             |  74 ++++----
 drivers/i2c/busses/i2c-pnx.c                       |   4 +-
 drivers/i2c/busses/i2c-riic.c                      |   2 +-
 drivers/mmc/host/mtk-sd.c                          |   2 +
 drivers/mmc/host/sdhci-tegra.c                     |   1 -
 drivers/net/ethernet/broadcom/bgmac-platform.c     |   5 +-
 .../chelsio/inline_crypto/chtls/chtls_main.c       |   5 +-
 drivers/net/ethernet/freescale/fec_ptp.c           |  11 +-
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |   2 +
 drivers/net/ethernet/mscc/ocelot.c                 |   2 +-
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |   4 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   4 +-
 drivers/net/ethernet/renesas/rswitch.c             |  68 +++----
 drivers/net/ethernet/renesas/rswitch.h             |  13 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   7 +-
 drivers/net/mdio/fwnode_mdio.c                     |  13 +-
 drivers/net/netdevsim/health.c                     |   2 +
 drivers/net/tun.c                                  |   2 +-
 drivers/of/address.c                               |   2 +-
 drivers/of/base.c                                  |  15 +-
 drivers/of/irq.c                                   |   2 +
 drivers/pci/controller/pci-host-common.c           |   4 -
 drivers/pci/controller/vmd.c                       |   8 +-
 drivers/pci/pcie/aer.c                             |  18 ++
 drivers/pci/probe.c                                |  22 ++-
 drivers/pci/quirks.c                               |   4 +
 drivers/platform/x86/p2sb.c                        |  94 ++++++----
 drivers/thunderbolt/tb.c                           |  41 +++++
 drivers/usb/cdns3/cdns3-ti.c                       |  15 +-
 drivers/usb/cdns3/core.h                           |   1 +
 drivers/usb/cdns3/drd.c                            |  10 +-
 drivers/usb/cdns3/drd.h                            |   3 +
 drivers/usb/dwc2/gadget.c                          |   4 +-
 drivers/usb/serial/option.c                        |  27 +++
 fs/btrfs/tree-checker.c                            |  27 ++-
 fs/ceph/file.c                                     |  34 ++--
 fs/ceph/super.c                                    |   2 +
 fs/efivarfs/inode.c                                |   2 +-
 fs/efivarfs/internal.h                             |   1 -
 fs/efivarfs/super.c                                |   3 -
 fs/eventpoll.c                                     |   5 +-
 fs/nfs/pnfs.c                                      |   2 +-
 fs/nilfs2/btnode.c                                 |   1 +
 fs/nilfs2/gcinode.c                                |   2 +-
 fs/nilfs2/inode.c                                  |  13 +-
 fs/nilfs2/namei.c                                  |   5 +
 fs/nilfs2/nilfs.h                                  |   1 +
 fs/smb/client/connect.c                            |  36 ++--
 fs/smb/server/connection.c                         |  18 +-
 fs/smb/server/connection.h                         |   1 -
 fs/smb/server/server.c                             |   7 +-
 fs/smb/server/server.h                             |   1 +
 fs/smb/server/transport_ipc.c                      |   5 +-
 fs/xfs/Kconfig                                     |  12 ++
 fs/xfs/libxfs/xfs_dir2_data.c                      |  31 +++-
 fs/xfs/libxfs/xfs_dir2_priv.h                      |   7 +
 fs/xfs/libxfs/xfs_quota_defs.h                     |   2 +-
 fs/xfs/libxfs/xfs_trans_resv.c                     |  28 +--
 fs/xfs/scrub/agheader_repair.c                     |   2 +-
 fs/xfs/scrub/bmap.c                                |   8 +-
 fs/xfs/scrub/trace.h                               |  10 +-
 fs/xfs/xfs.h                                       |   4 +
 fs/xfs/xfs_bmap_util.c                             |  22 ++-
 fs/xfs/xfs_buf_item.c                              |  32 ++++
 fs/xfs/xfs_dquot_item.c                            |  31 ++++
 fs/xfs/xfs_file.c                                  |  29 ++-
 fs/xfs/xfs_file.h                                  |  15 ++
 fs/xfs/xfs_fsmap.c                                 |   6 +-
 fs/xfs/xfs_inode.c                                 |  29 ++-
 fs/xfs/xfs_inode.h                                 |   2 +
 fs/xfs/xfs_inode_item.c                            |  32 ++++
 fs/xfs/xfs_ioctl.c                                 |  12 ++
 fs/xfs/xfs_iops.c                                  |   1 +
 fs/xfs/xfs_iops.h                                  |   3 -
 fs/xfs/xfs_rtalloc.c                               |  78 ++++++--
 fs/xfs/xfs_symlink.c                               |   8 +-
 include/linux/hyperv.h                             |   1 +
 include/linux/io_uring.h                           |   4 +-
 include/linux/wait.h                               |   1 +
 io_uring/io_uring.c                                |  15 +-
 io_uring/io_uring.h                                |   1 -
 io_uring/rw.c                                      |  31 +++-
 kernel/trace/trace_events.c                        | 199 ++++++++++++++++-----
 mm/vmalloc.c                                       |   6 +-
 net/netfilter/ipset/ip_set_list_set.c              |   3 +
 net/netfilter/ipvs/ip_vs_conn.c                    |   4 +-
 net/sched/sch_cake.c                               |   2 +-
 net/sched/sch_choke.c                              |   2 +-
 net/smc/af_smc.c                                   |  18 +-
 net/smc/smc_clc.c                                  |  17 +-
 net/smc/smc_clc.h                                  |  22 ++-
 net/smc/smc_core.c                                 |   9 +-
 sound/soc/intel/boards/sof_sdw.c                   |  18 ++
 tools/hv/hv_set_ifconfig.sh                        |   2 +-
 tools/testing/selftests/bpf/sdt.h                  |   2 +
 tools/testing/selftests/memfd/memfd_test.c         |  14 +-
 .../selftests/net/openvswitch/openvswitch.sh       |   6 +-
 119 files changed, 1223 insertions(+), 441 deletions(-)


