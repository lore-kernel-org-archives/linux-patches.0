Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AB1185949;
	Fri, 15 Nov 2024 06:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653558; cv=none; b=m1q5SM+eY+K14CKt6gc5Gt+b5tbh8U7YvgiTJwOrbMJdeH4Dhvs/cpHUt4RrI8BT7AlPw26d2Bn2h5jkUUwe23ZTvYemqXMsS//31WD5WwzWBD0n2Lmk36OCwylvBbSba+/UAhBGdhg38Z5S4U9KicwTXcWIAEMiLkFhtO5wpDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653558; c=relaxed/simple;
	bh=tPCZ1ZkUl+MQMg9jAZFGjJstm7Lnf2YW82dtfB4mTnM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VvqPQDs4d5VH7BEeqhuIPC4l5eVdkZ0D3U1vjgwKN0D5IHhZgJqzXGfM4+ELnXDPYxLmag8M2cHki44eTth3egKc4AlRknchQjwHXKUCz7SuuPPs9CaOHMIjY1Wn+eS74FUJbA+MZnMi9SJlLFaPhVg+pctdepZj/PjTl57UWqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o3Qti4FJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o3Qti4FJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62122C4CECF;
	Fri, 15 Nov 2024 06:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653558;
	bh=tPCZ1ZkUl+MQMg9jAZFGjJstm7Lnf2YW82dtfB4mTnM=;
	h=From:To:Cc:Subject:Date:From;
	b=o3Qti4FJRDpl3a1owhzMKR/Rr7Txnj1zNmUFDXV47p30oxdPfEGnK1HJtxfbnq5re
	 yRZ2IVDjXeEc9p3wk7MhUeCps6Bgdny/CCYOvtKQ/hvyG3N35qo+ewqk0y4xI/e8YX
	 BESinn1sLPwlrK9po1K3Y3HyChNoi7c4ftnZJ2Kw=
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
Subject: [PATCH 6.1 00/39] 6.1.118-rc1 review
Date: Fri, 15 Nov 2024 07:38:10 +0100
Message-ID: <20241115063722.599985562@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.118-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.118-rc1
X-KernelTest-Deadline: 2024-11-17T06:37+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.118 release.
There are 39 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.118-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.118-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    9p: fix slab cache name creation for real

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix general protection fault in run_is_mapped_full

Hans de Goede <hdegoede@redhat.com>
    platform/x86: x86-android-tablets: Fix use after free on platform_device_register() errors

Qun-Wei Lin <qun-wei.lin@mediatek.com>
    mm: krealloc: Fix MTE false alarm in __do_krealloc

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix uaf in l2cap_connect

Xiaxi Shen <shenxiaxi26@gmail.com>
    ext4: fix timer use-after-free on failed mount

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: amdkfd_free_gtt_mem clear the correct pointer

Qiao Ma <mqaio@linux.alibaba.com>
    uprobe: avoid out-of-bounds memory access of fetching args

Andrii Nakryiko <andrii@kernel.org>
    uprobes: encapsulate preparation of uprobe args buffer

Hagar Hemdan <hagarhem@amazon.com>
    io_uring: fix possible deadlock in io_register_iowq_max_workers()

Li Nan <linan122@huawei.com>
    md/raid10: improve code of mrdev in raid10_sync_request

Reinhard Speyerer <rspmn@arcor.de>
    net: usb: qmi_wwan: add Fibocom FG132 0x0112 composition

Yanteng Si <siyanteng@cqsoftware.com.cn>
    LoongArch: Use "Exception return address" to comment ERA

Hans de Goede <hdegoede@redhat.com>
    HID: lenovo: Add support for Thinkpad X1 Tablet Gen 3 keyboard

Kenneth Albanowski <kenalba@chromium.org>
    HID: multitouch: Add quirk for Logitech Bolt receiver w/ Casa touchpad

Alessandro Zanni <alessandro.zanni87@gmail.com>
    fs: Fix uninitialized value issue in from_kuid and from_kgid

Jiawei Ye <jiawei.ye@foxmail.com>
    bpf: Fix mismatched RCU unlock flavour in bpf_out_neigh_v6

Yuan Can <yuancan@huawei.com>
    vDPA/ifcvf: Fix pci_read_config_byte() return code handling

Nilay Shroff <nilay@linux.ibm.com>
    nvme: make keep-alive synchronous operation

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/powernv: Free name on error in opal_event_init()

Keith Busch <kbusch@kernel.org>
    nvme-multipath: defer partition scanning

Will Deacon <will@kernel.org>
    kasan: Disable Software Tag-Based KASAN with GCC

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

Pedro Falcato <pedro.falcato@gmail.com>
    9p: Avoid creating multiple slab caches with the same name

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "Bluetooth: hci_conn: Consolidate code for aborting connections"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "Bluetooth: hci_core: Fix possible buffer overflow"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "Bluetooth: af_bluetooth: Fix deadlock"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "Bluetooth: hci_sync: Fix overwriting request callback"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "Bluetooth: fix use-after-free in accessing skb after sending it"


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/loongarch/include/asm/loongarch.h             |   2 +-
 arch/powerpc/platforms/powernv/opal-irqchip.c      |   1 +
 block/elevator.c                                   |   4 +-
 crypto/algapi.c                                    |   2 +-
 drivers/crypto/marvell/cesa/hash.c                 |  12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |  14 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h         |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |   4 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c       |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |   2 +-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h                |   3 -
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-lenovo.c                           |   8 ++
 drivers/hid/hid-multitouch.c                       |  13 ++
 drivers/irqchip/irq-mscc-ocelot.c                  |   4 +-
 drivers/md/raid10.c                                |  23 +--
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/nvme/host/core.c                           |  31 ++--
 drivers/nvme/host/multipath.c                      |  33 +++++
 drivers/nvme/host/nvme.h                           |   1 +
 drivers/nvme/host/tcp.c                            |   7 +-
 drivers/platform/x86/x86-android-tablets.c         |   3 +-
 drivers/vdpa/ifcvf/ifcvf_base.c                    |   2 +-
 fs/ext4/super.c                                    |   2 +-
 fs/ntfs3/inode.c                                   |   9 ++
 fs/ocfs2/file.c                                    |   9 +-
 include/net/bluetooth/hci_core.h                   |   3 +-
 io_uring/io_uring.c                                |   5 +
 kernel/bpf/verifier.c                              |   4 +-
 kernel/trace/trace_uprobe.c                        |  86 +++++------
 lib/Kconfig.kasan                                  |   7 +-
 mm/slab_common.c                                   |   2 +-
 net/9p/client.c                                    |  12 +-
 net/bluetooth/af_bluetooth.c                       |  10 +-
 net/bluetooth/hci_conn.c                           | 158 ++++++++++++++++-----
 net/bluetooth/hci_core.c                           |  50 +++----
 net/bluetooth/hci_event.c                          |  20 +--
 net/bluetooth/hci_sync.c                           |  44 ++----
 net/bluetooth/l2cap_core.c                         |   9 --
 net/bluetooth/mgmt.c                               |  15 +-
 net/core/filter.c                                  |   2 +-
 sound/Kconfig                                      |   2 +-
 48 files changed, 401 insertions(+), 243 deletions(-)


