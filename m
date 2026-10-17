Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC4D34EEF3;
	Sat, 17 Oct 2026 15:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252576; cv=none; b=oM+iPgjHSAGryL5ctRa0UzLz5r3swMW7x3q09dyY/2s4t45ICl4gxJSYv+cd+oQPJmBtQyszAcNGf1wQFEO298cIJ4YwUxVc+0qdgV1tA8ERuDtNwT0FIxT0XwTNfN3+VJSd8QR5BjVxHtJKfv+aYUluoIJq/7ZwAouy0YK1BXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252576; c=relaxed/simple;
	bh=RjNMlg2IO7dnkjshfCv/58OuvCALFUNDpcpvFDqEZn4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S0g0asDuFrQi1vT858x9B8JviEYvXm8vT2zK48Q7PPkZf8bGLmqBETC733AIyyTR1uAlUDlyuKJJSHtwjfIlZUn2nCvEAXLiU18FRTUZUY3Ox00bGCDbfPIPqyvdOjfBaanISmFj6BAE3TTA1mkTMhwzXysq0+HXxOK6VTn+1Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ub4P5jd9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ub4P5jd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615941F000C4;
	Sat, 17 Oct 2026 15:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252574;
	bh=2XOJvniou8r0h52hRCQ7CYGc/YiASAB4UTfI51FTZmc=;
	h=From:To:Cc:Subject:Date;
	b=ub4P5jd9d44UTMBBYItXFBFj214eVre0slzTctnJF8nKJ2NxcrWICOHBDguEmMhya
	 nUDDvh0EK/cK88Xpt102QVm/0Ry6Gq7kgI7vCagez/sYe8GR/kv7cWrKmQpVuAEHUa
	 CyARBQz2UnKH1OjOJuK+JPd19a1j6fClW2D9ZIz4=
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
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.18 00/52] 6.18.58-rc1 review
Date: Sat, 17 Oct 2026 17:54:01 +0200
Message-ID: <20261017155104.830766652@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.58-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.58-rc1
X-KernelTest-Deadline: 2026-10-19T15:51+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.58 release.
There are 52 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 19 Oct 2026 15:50:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.58-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.58-rc1

Toke Høiland-Jørgensen <toke@toke.dk>
    wifi: atk9k: Revert "wifi: ath9k: reject short WMI command responses"

Mattia Meleleo <mattia.meleleo@coralogix.com>
    bpf, sockmap: Account for receive queue in FIONREAD without a verdict program

Pratyush Yadav <pratyush@kernel.org>
    kho: free chunks using free_page() instead of kfree()

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: don't charge provided buffer rings to RLIMIT_MEMLOCK

Hengyu Liang <hengyul@cs.unc.edu>
    io_uring: do not charge the SQ/CQ rings to RLIMIT_MEMLOCK

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: hold a reference on incoming sockets queued for accept()

Alexander Lobakin <aleksander.lobakin@intel.com>
    ice: fix broken Rx on VFs

Johan Hovold <johan@kernel.org>
    USB: iowarrior: fix use-after-free on disconnect race

Oliver Neukum <oneukum@suse.com>
    usb: iowarrior: remove inherent race with minor number

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: allow multiple opens of /sys/fs/selinux/policy

SeongJae Park <sj@kernel.org>
    mm/damon/core: fix damos_walk() vs kdamond_fn() exit race

SeongJae Park <sj@kernel.org>
    mm/damon/core: cancel damos_walk() before damon_ctx->kdamond reset

Long Li <leo.lilong@huawei.com>
    xfs: close crash window in attr dabtree inactivation

Long Li <leo.lilong@huawei.com>
    xfs: factor out xfs_attr3_leaf_init

Long Li <leo.lilong@huawei.com>
    xfs: factor out xfs_attr3_node_entry_remove

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: change XDP RxQ frag_size from DMA write length to xdp.frame_sz

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: fix rxq info registering in mbuf packets

Michal Schmidt <mschmidt@redhat.com>
    ice: fix crash in ethtool offline loopback test

Michal Kubiak <michal.kubiak@intel.com>
    ice: drop page splitting and recycling

Michal Kubiak <michal.kubiak@intel.com>
    ice: remove legacy Rx and construct SKB

Chris J Arges <carges@cloudflare.com>
    ima: Fix stack-out-of-bounds in is_bprm_creds_for_exec()

Coiby Xu <coxu@redhat.com>
    ima: Access decompressed kernel module to verify appended signature

Matteo Croce <technoboy85@gmail.com>
    fat: stop reading directory entries past the end-of-directory marker

Frank Sorenson <sorenson@redhat.com>
    cifs: fix time_last_write stamp placement in setattr/truncate paths

Fan Wu <fanwu01@zju.edu.cn>
    drm/xe/i2c: cancel the client work on remove

Stanley Jhu <stanleyjhu@google.com>
    scsi: ufs: core: Avoid unsafe MMIO reads in ufshcd_mcq_compl_all_cqes_lock()

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Add a comment block above ufshcd_mcq_compl_all_cqes_lock()

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Add debug log for MCQ command timeout

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Move an assignment in ufshcd_mcq_process_cqe()

Ahmed Abdelhaleem Ahmed <ahmedhal@gmail.com>
    scsi: ch: Do not keep references to data transfer element devices

Stanley Jhu <stanleyjhu@google.com>
    scsi: ufs: core: Decouple CQ sweep from request iterator in MCQ

Wei-Jie Hung <imbigking12@gmail.com>
    riscv: patch: fix handling of bpf-jit execmem addresses

Vivian Wang <wangruikang@iscas.ac.cn>
    riscv: patch: Avoid early phys_to_page()

Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
    net: mana: reserve RX buffer headroom to fix forwarding performance

Suraj Gupta <suraj.gupta2@amd.com>
    net: xilinx: axienet: Free outstanding DMA buffers on dmaengine stop

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    Bluetooth: RFCOMM: connect the session socket without rfcomm_mutex

Tejun Heo <tj@kernel.org>
    sched_ext: Fix CPU hotplug hang when a dying CPU's tasks sit in the BPF scheduler

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: validate the superblock on resume

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: fix NULL pointer dereference when the 'R' flag is used

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: connac: tolerate inactive BSS deactivation

Lubos Rendek <l.rendek@proxmox.com>
    nfsd: fix all-zero stateid in CB_OFFLOAD for async COPY

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP self-merge

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    iavf: send MAC change request synchronously

Corinna Vinschen <vinschen@redhat.com>
    iavf: iavf_virtchnl_completion: drop duplicate ether_addr_equal() test

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Create a device link between APU display and XHCI devices

Daehyeon Ko <4ncienth@gmail.com>
    ip6_gre: remove obsolete ERSPAN PMTU update

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    PCI: dwc: Return -EIO from dw_pcie_wait_for_link() if device is not active

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    PCI: dwc: Return -ENODEV from dw_pcie_wait_for_link() if device is not found

Cheng Xu <chengyou@linux.alibaba.com>
    RDMA/erdma: Use IRQ-safe XArray helpers for QP and CQ tables

Ethan Tidmore <ethantidmore06@gmail.com>
    usb: gadget: f_hid: Add missing error code

Johan Hovold <johan@kernel.org>
    spi: mpc52xx: clean up interrupt handling


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/riscv/kernel/patch.c                          |  21 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |  12 ++
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h      |  10 +
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c   |  45 ++++
 drivers/gpu/drm/xe/xe_i2c.c                        |   5 +-
 drivers/infiniband/hw/erdma/erdma_main.c           |   4 +-
 drivers/infiniband/hw/erdma/erdma_verbs.c          |  18 +-
 drivers/md/dm-integrity.c                          |  55 +++++
 drivers/net/ethernet/intel/iavf/iavf.h             |  11 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  85 ++++++--
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    | 111 ++++++++--
 drivers/net/ethernet/intel/ice/ice.h               |   3 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |  79 ++-----
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  10 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |  15 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  11 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          | 233 ++-------------------
 drivers/net/ethernet/intel/ice/ice_txrx.h          |  88 --------
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  75 +------
 drivers/net/ethernet/intel/ice/virt/queues.c       |   6 +-
 drivers/net/ethernet/microsoft/mana/mana_bpf.c     |   8 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  26 ++-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |   7 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  53 ++++-
 drivers/net/wireless/ath/ath9k/wmi.c               |  16 +-
 drivers/net/wireless/ath/ath9k/wmi.h               |   1 -
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   9 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |  23 ++
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |   6 +-
 drivers/pci/controller/dwc/pcie-designware.c       |  31 ++-
 drivers/scsi/ch.c                                  |  30 +--
 drivers/spi/spi-mpc52xx.c                          |  26 ++-
 drivers/ufs/core/ufs-mcq.c                         |  35 +++-
 drivers/ufs/core/ufshcd.c                          |  37 ++--
 drivers/usb/gadget/function/f_hid.c                |   4 +-
 drivers/usb/misc/iowarrior.c                       |  74 +++----
 fs/fat/dir.c                                       |  44 +++-
 fs/nfsd/nfs4proc.c                                 |   2 +
 fs/smb/client/inode.c                              |  27 ++-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |  22 ++
 fs/xfs/libxfs/xfs_attr_leaf.h                      |   3 +
 fs/xfs/libxfs/xfs_da_btree.c                       |  53 ++++-
 fs/xfs/libxfs/xfs_da_btree.h                       |   2 +
 fs/xfs/xfs_attr_inactive.c                         |  99 +++++----
 include/linux/damon.h                              |   1 +
 include/linux/kernel_read_file.h                   |   1 +
 include/linux/skmsg.h                              |  14 --
 include/net/bluetooth/rfcomm.h                     |   1 +
 include/net/mana/mana.h                            |   4 +-
 io_uring/io_uring.c                                |  12 +-
 io_uring/kbuf.c                                    |   6 +-
 io_uring/memmap.c                                  |  29 ++-
 io_uring/memmap.h                                  |   6 +-
 io_uring/register.c                                |  15 +-
 io_uring/zcrx.c                                    |   4 +-
 kernel/kexec_handover.c                            |   2 +-
 kernel/module/main.c                               |  17 +-
 kernel/sched/ext.c                                 |  29 ++-
 kernel/sched/sched.h                               |   5 +-
 mm/damon/core.c                                    |  24 ++-
 mm/mremap.c                                        |  38 +++-
 mm/vma.c                                           |  21 +-
 mm/vma.h                                           |   7 +-
 net/bluetooth/rfcomm/core.c                        | 134 ++++++++----
 net/ipv4/tcp_bpf.c                                 |  17 +-
 net/ipv6/ip6_gre.c                                 |   7 -
 net/rose/af_rose.c                                 |  44 +++-
 net/rose/rose_timer.c                              |   5 +
 security/integrity/ima/ima.h                       |   6 +-
 security/integrity/ima/ima_appraise.c              |  16 +-
 security/integrity/ima/ima_main.c                  |  30 ++-
 security/integrity/ima/ima_policy.c                |   3 +-
 security/ipe/hooks.c                               |   1 +
 security/selinux/hooks.c                           |   5 +-
 security/selinux/selinuxfs.c                       |  27 +--
 tools/testing/vma/vma.c                            |   4 +-
 77 files changed, 1160 insertions(+), 914 deletions(-)


