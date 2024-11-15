Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7347FEAD0;
	Fri, 15 Nov 2024 06:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653491; cv=none; b=Kt5+4MB+cSjauYBeJMWRgfg5LDHMbd0c1V19NjjHwKGK8/eBsVObqf6L4C4Iw6SUppGL2hsOXuV0icBIVK3NKpMKS5rDW/EE3egN4kw3aH82I445hCzejt+krDudpJD7xkAaVK0d0Jn3smcPpVZcPw7FoHdh0X3I++NFA9E2sKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653491; c=relaxed/simple;
	bh=GNDFkGwBHGkkXEbxwhMWzsvzcg8N3KvmEXZnsiGdheU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NUobNfBBZaiqbpVoj/ytdF9FTxT3a/2kidbsrN31M6u4z5mSDsUaBPBIopmUlyy5IqTD+5xEuD/xH2aK6D5qd3q41Gd7wyXlpi02jHrQRs53NPDGHN1fVH0Cnqr0ph69ieFj7l4vx/RVcWJsVdVlSazayrr53XDZvLWqM66ITlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z3ANG2QT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3ANG2QT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785C7C4CECF;
	Fri, 15 Nov 2024 06:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653491;
	bh=GNDFkGwBHGkkXEbxwhMWzsvzcg8N3KvmEXZnsiGdheU=;
	h=From:To:Cc:Subject:Date:From;
	b=Z3ANG2QTUcmY2QeRDVuIfMASXh6ojlsKXKiaDKzOKf6QsPKgr/AExwn5aoCBSb2f8
	 s8c6ir71LsF7omIATsfYlNiNkFs5/ZTrpCrn0QiYZOccHAypv2LwOK+0uMMTDLWPRd
	 bAX1/gOe1cSgxh/lGUCz7pKyFpZ4FxU4qAC/Pogg=
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
Subject: [PATCH 6.6 00/48] 6.6.62-rc1 review
Date: Fri, 15 Nov 2024 07:37:49 +0100
Message-ID: <20241115063722.962047137@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.62-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.62-rc1
X-KernelTest-Deadline: 2024-11-17T06:37+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.62 release.
There are 48 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.62-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.62-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    9p: fix slab cache name creation for real

Hugh Dickins <hughd@google.com>
    mm/thp: fix deferred split unqueue naming and locking

Kefeng Wang <wangkefeng.wang@huawei.com>
    mm: refactor folio_undo_large_rmappable()

Matthew Wilcox (Oracle) <willy@infradead.org>
    mm: always initialise folio->_deferred_list

Matthew Wilcox (Oracle) <willy@infradead.org>
    mm: support order-1 folios in the page cache

Ryan Roberts <ryan.roberts@arm.com>
    mm/readahead: do not allow order-1 folio

Hugh Dickins <hughd@google.com>
    mm: add page_rmappable_folio() wrapper

Qun-Wei Lin <qun-wei.lin@mediatek.com>
    mm: krealloc: Fix MTE false alarm in __do_krealloc

Hagar Hemdan <hagarhem@amazon.com>
    io_uring: fix possible deadlock in io_register_iowq_max_workers()

Hou Tao <houtao1@huawei.com>
    bpf: Check validity of link->type in bpf_link_show_fdinfo()

Reinhard Speyerer <rspmn@arcor.de>
    net: usb: qmi_wwan: add Fibocom FG132 0x0112 composition

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: Add sample rate constraint

Yanteng Si <siyanteng@cqsoftware.com.cn>
    LoongArch: Use "Exception return address" to comment ERA

Jack Yu <jack.yu@realtek.com>
    ASoC: rt722-sdca: increase clk_stop_timeout to fix clock stop issue

Cyan Yang <cyan.yang@sifive.com>
    RISCV: KVM: use raw_spinlock for critical section in imsic

Hans de Goede <hdegoede@redhat.com>
    HID: lenovo: Add support for Thinkpad X1 Tablet Gen 3 keyboard

Kenneth Albanowski <kenalba@chromium.org>
    HID: multitouch: Add quirk for Logitech Bolt receiver w/ Casa touchpad

Alessandro Zanni <alessandro.zanni87@gmail.com>
    fs: Fix uninitialized value issue in from_kuid and from_kgid

Ilya Dudikov <ilyadud@mail.ru>
    ASoC: amd: yc: Fix non-functional mic on ASUS E1404FA

Christian Heusel <christian@heusel.eu>
    ASoC: amd: yc: Add quirk for ASUS Vivobook S15 M3502RA

Jiawei Ye <jiawei.ye@foxmail.com>
    bpf: Fix mismatched RCU unlock flavour in bpf_out_neigh_v6

Zijian Zhang <zijianzhang@bytedance.com>
    bpf: Add sk_is_inet and IS_ICSK check in tls_sw_has_ctx_tx/rx

Yuan Can <yuancan@huawei.com>
    vDPA/ifcvf: Fix pci_read_config_byte() return code handling

Breno Leitao <leitao@debian.org>
    nvme/host: Fix RCU list traversal to use SRCU primitive

Kuniyuki Iwashima <kuniyu@amazon.com>
    smb: client: Fix use-after-free of network namespace.

Nilay Shroff <nilay@linux.ibm.com>
    nvme: make keep-alive synchronous operation

Nilay Shroff <nilay@linux.ibm.com>
    nvme-loop: flush off pending I/O while shutting down loop controller

Linus Walleij <linus.walleij@linaro.org>
    net: phy: mdio-bcm-unimac: Add BCM6846 support

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/powernv: Free name on error in opal_event_init()

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Accounting pdd vram_usage for svm

Keith Busch <kbusch@kernel.org>
    nvme-multipath: defer partition scanning

Will Deacon <will@kernel.org>
    kasan: Disable Software Tag-Based KASAN with GCC

Showrya M N <showrya@chelsio.com>
    RDMA/siw: Add sendpage_ok() check to disable MSG_SPLICE_PAGES

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Limit display layout ioctl array size to VMWGFX_NUM_DISPLAY_UNITS

Julian Vetter <jvetter@kalrayinc.com>
    sound: Make CONFIG_SND depend on INDIRECT_IOMEM instead of UML

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: marvell/cesa - Disable hash algorithms

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: api - Fix liveliness check in crypto_alg_tested

Rik van Riel <riel@surriel.com>
    bpf: use kvzmalloc to allocate BPF verifier environment

Greg Joyce <gjoyce@linux.ibm.com>
    nvme: disable CC.CRIME (NVME_CC_CRIME)

Robin Murphy <robin.murphy@arm.com>
    iommu/arm-smmu: Clarify MMU-500 CPRE workaround

WangYuli <wangyuli@uniontech.com>
    HID: multitouch: Add quirk for HONOR MagicBook Art 14 touchpad

Stefan Blum <stefanblum2004@gmail.com>
    HID: multitouch: Add support for B2402FVA track point

SurajSonawane2415 <surajsonawane0215@gmail.com>
    block: Fix elevator_get_default() checking for NULL q->tag_set

Hannes Reinecke <hare@suse.de>
    nvme: tcp: avoid race between queue_lock lock and destroy

Sergey Matsievskiy <matsievskiysv@gmail.com>
    irqchip/ocelot: Fix trigger register address

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: Verify that sync_linked_regs preserves subreg_def

Pedro Falcato <pedro.falcato@gmail.com>
    9p: Avoid creating multiple slab caches with the same name

Dominique Martinet <asmadeus@codewreck.org>
    9p: v9fs_fid_find: also lookup by inode if not found dentry


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/loongarch/include/asm/loongarch.h             |  2 +-
 arch/powerpc/platforms/powernv/opal-irqchip.c      |  1 +
 arch/riscv/kvm/aia_imsic.c                         |  8 +--
 block/elevator.c                                   |  4 +-
 crypto/algapi.c                                    |  2 +-
 drivers/crypto/marvell/cesa/hash.c                 | 12 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |  4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               | 26 +++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |  4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |  4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h                |  3 -
 drivers/hid/hid-ids.h                              |  1 +
 drivers/hid/hid-lenovo.c                           |  8 +++
 drivers/hid/hid-multitouch.c                       | 13 +++++
 drivers/infiniband/sw/siw/siw_qp_tx.c              |  2 +
 drivers/iommu/arm/arm-smmu/arm-smmu-impl.c         |  4 +-
 drivers/irqchip/irq-mscc-ocelot.c                  |  4 +-
 drivers/net/mdio/mdio-bcm-unimac.c                 |  1 +
 drivers/net/usb/qmi_wwan.c                         |  1 +
 drivers/nvme/host/core.c                           | 52 +++++++++--------
 drivers/nvme/host/multipath.c                      | 33 +++++++++++
 drivers/nvme/host/nvme.h                           |  1 +
 drivers/nvme/host/tcp.c                            |  7 ++-
 drivers/nvme/target/loop.c                         | 13 +++++
 drivers/vdpa/ifcvf/ifcvf_base.c                    |  2 +-
 fs/9p/fid.c                                        |  5 +-
 fs/ocfs2/file.c                                    |  9 ++-
 fs/smb/client/connect.c                            | 14 ++++-
 include/net/tls.h                                  | 12 +++-
 io_uring/io_uring.c                                |  5 ++
 kernel/bpf/syscall.c                               | 14 +++--
 kernel/bpf/verifier.c                              |  4 +-
 lib/Kconfig.kasan                                  |  7 ++-
 mm/filemap.c                                       |  2 -
 mm/huge_memory.c                                   | 59 ++++++++++++-------
 mm/hugetlb.c                                       |  1 +
 mm/internal.h                                      | 27 ++++++++-
 mm/memcontrol.c                                    | 29 ++++++++++
 mm/mempolicy.c                                     | 17 +-----
 mm/page_alloc.c                                    | 21 +++----
 mm/readahead.c                                     | 11 +---
 mm/slab_common.c                                   |  2 +-
 net/9p/client.c                                    | 12 +++-
 net/core/filter.c                                  |  2 +-
 sound/Kconfig                                      |  2 +-
 sound/soc/amd/yc/acp6x-mach.c                      | 14 +++++
 sound/soc/codecs/rt722-sdca-sdw.c                  |  2 +-
 sound/soc/fsl/fsl_micfil.c                         | 38 ++++++++++++
 .../selftests/bpf/progs/verifier_scalar_ids.c      | 67 ++++++++++++++++++++++
 52 files changed, 456 insertions(+), 144 deletions(-)


