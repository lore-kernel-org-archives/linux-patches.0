Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF41A185924;
	Fri, 15 Nov 2024 06:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653255; cv=none; b=XnuoTFuQsVBiuS6K7A6kxB/S4REJUHHWLu45Aa1Yz2vMX71L2I1RgTPInFfYxIp0gUEDvoRVvxbka980NbpROQBSJlIkdeoY7L46wQDC7+X18Wdsyq/9KbK4M00MKDHiK/u3pT2lthf5RDZxPmxAtVwY3/Poy9hNoO5zRX8oM7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653255; c=relaxed/simple;
	bh=ktNEFlEKZ/U0DfeyFA5YBuSRHYFOWQ7vZmX700KuZqs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pIOeuduF+1gE9mijDgdbwMNobi/qbauhL15JYMl2Os4nh51oOuERiR8Uonervta/RIBY+zDq0SUInjkJ11QbQZOHtMYHmbD4lIExUAqLmYyBnoQ7B/wnrnmdrxG/lrjUWGTDLLOCrxTNMiJBHjpKh1icGxkUqIeJUB6pDJag9wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N2hOjrRZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2hOjrRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E75CC4CECF;
	Fri, 15 Nov 2024 06:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653255;
	bh=ktNEFlEKZ/U0DfeyFA5YBuSRHYFOWQ7vZmX700KuZqs=;
	h=From:To:Cc:Subject:Date:From;
	b=N2hOjrRZ4FEyym3PvkZRA0n0xL7Wnxe9ItpJcDNo8r11bXOrZ4pmOTBGTDNUYrdwP
	 XhxdZR49+Jws3srQcFA8KEO3gpMPtPwUYewJ8TCdaTi3QqPuFiInthVbKShdLGyf7j
	 ziCDcRLHdBag7vke7Ob6x3dRnRlA8R5ff4gZbJ4w=
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
Subject: [PATCH 6.11 00/63] 6.11.9-rc1 review
Date: Fri, 15 Nov 2024 07:37:23 +0100
Message-ID: <20241115063725.892410236@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.9-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.11.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.11.9-rc1
X-KernelTest-Deadline: 2024-11-17T06:37+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.11.9 release.
There are 63 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.9-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.11.9-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    9p: fix slab cache name creation for real

Qun-Wei Lin <qun-wei.lin@mediatek.com>
    mm: krealloc: Fix MTE false alarm in __do_krealloc

Nirmoy Das <nirmoy.das@intel.com>
    drm/xe: Don't restart parallel queues multiple times on GT reset

Nirmoy Das <nirmoy.das@intel.com>
    drm/xe/ufence: Prefetch ufence addr to catch bogus address

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe: Handle unreliable MMIO reads during forcewake

Badal Nilawar <badal.nilawar@intel.com>
    drm/xe/guc/ct: Flush g2h worker in case of g2h response timeout

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe: Enlarge the invalidation timeout from 150 to 500

Hou Tao <houtao1@huawei.com>
    bpf: Check validity of link->type in bpf_link_show_fdinfo()

Reinhard Speyerer <rspmn@arcor.de>
    net: usb: qmi_wwan: add Fibocom FG132 0x0112 composition

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: KVM: Mark hrtimer to expire in hard interrupt context

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: Add sample rate constraint

Yanteng Si <siyanteng@cqsoftware.com.cn>
    LoongArch: Use "Exception return address" to comment ERA

Jack Yu <jack.yu@realtek.com>
    ASoC: rt722-sdca: increase clk_stop_timeout to fix clock stop issue

Cyan Yang <cyan.yang@sifive.com>
    RISCV: KVM: use raw_spinlock for critical section in imsic

Alexey Klimov <alexey.klimov@linaro.org>
    ASoC: codecs: lpass-rx-macro: fix RXn(rx,n) macro for DSM_CTL and SEC7 regs

Hans de Goede <hdegoede@redhat.com>
    HID: lenovo: Add support for Thinkpad X1 Tablet Gen 3 keyboard

Kenneth Albanowski <kenalba@chromium.org>
    HID: multitouch: Add quirk for Logitech Bolt receiver w/ Casa touchpad

Bartłomiej Maryńczak <marynczakbartlomiej@gmail.com>
    HID: i2c-hid: Delayed i2c resume wakeup for 0x0d42 Goodix touchpad

David Howells <dhowells@redhat.com>
    afs: Fix lock recursion

Alessandro Zanni <alessandro.zanni87@gmail.com>
    fs: Fix uninitialized value issue in from_kuid and from_kgid

David Howells <dhowells@redhat.com>
    netfs: Downgrade i_rwsem for a buffered write

Derek Fang <derek.fang@realtek.com>
    ASoC: Intel: soc-acpi: lnl: Add match entry for TM2 laptops

Ilya Dudikov <ilyadud@mail.ru>
    ASoC: amd: yc: Fix non-functional mic on ASUS E1404FA

Christian Heusel <christian@heusel.eu>
    ASoC: amd: yc: Add quirk for ASUS Vivobook S15 M3502RA

Zhu Jun <zhujun2@cmss.chinamobile.com>
    ASoC: codecs: Fix error handling in aw_dev_get_dsp_status function

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: Intel: avs: Update stream status in a separate thread

Jiawei Ye <jiawei.ye@foxmail.com>
    bpf: Fix mismatched RCU unlock flavour in bpf_out_neigh_v6

Zijian Zhang <zijianzhang@bytedance.com>
    bpf: Add sk_is_inet and IS_ICSK check in tls_sw_has_ctx_tx/rx

Feng Liu <feliu@nvidia.com>
    virtio_pci: Fix admin vq cleanup by using correct info pointer

Yuan Can <yuancan@huawei.com>
    vDPA/ifcvf: Fix pci_read_config_byte() return code handling

Matthieu Buffet <matthieu@buffet.re>
    samples/landlock: Fix port parsing in sandboxer

Nilay Shroff <nilay@linux.ibm.com>
    nvme: make keep-alive synchronous operation

Nilay Shroff <nilay@linux.ibm.com>
    nvme-loop: flush off pending I/O while shutting down loop controller

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/xe/query: Increase timestamp width

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

Baojun Xu <baojun.xu@ti.com>
    ALSA: hda/tas2781: Add new quirk for Lenovo, ASUS, Dell projects

Showrya M N <showrya@chelsio.com>
    RDMA/siw: Add sendpage_ok() check to disable MSG_SPLICE_PAGES

Tyrone Wu <wudevelops@gmail.com>
    selftests/bpf: Assert link info uprobe_multi count & path_size if unset

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Limit display layout ioctl array size to VMWGFX_NUM_DISPLAY_UNITS

Julian Vetter <jvetter@kalrayinc.com>
    sound: Make CONFIG_SND depend on INDIRECT_IOMEM instead of UML

Harald Freudenberger <freude@linux.ibm.com>
    s390/ap: Fix CCA crypto card behavior within protected execution environment

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

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: intel: platform: Add Panther Lake to the list of supported

Rosen Penev <rosenp@gmail.com>
    pinctrl: aw9523: add missing mutex_destroy

Sergey Matsievskiy <matsievskiysv@gmail.com>
    irqchip/ocelot: Fix trigger register address

Nilay Shroff <nilay@linux.ibm.com>
    nvmet-passthru: clear EUID/NGUID/UUID while using loop target

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: Verify that sync_linked_regs preserves subreg_def

Pedro Falcato <pedro.falcato@gmail.com>
    9p: Avoid creating multiple slab caches with the same name

Dominique Martinet <asmadeus@codewreck.org>
    9p: v9fs_fid_find: also lookup by inode if not found dentry

Breno Leitao <leitao@debian.org>
    nvme/host: Fix RCU list traversal to use SRCU primitive

Kuniyuki Iwashima <kuniyu@amazon.com>
    smb: client: Fix use-after-free of network namespace.


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/loongarch/include/asm/loongarch.h             |  2 +-
 arch/loongarch/kvm/timer.c                         |  7 +-
 arch/loongarch/kvm/vcpu.c                          |  2 +-
 arch/powerpc/platforms/powernv/opal-irqchip.c      |  1 +
 arch/riscv/kvm/aia_imsic.c                         |  8 +--
 block/elevator.c                                   |  4 +-
 crypto/algapi.c                                    |  2 +-
 drivers/crypto/marvell/cesa/hash.c                 | 12 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |  4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               | 26 +++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |  4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |  4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h                |  3 -
 drivers/gpu/drm/xe/xe_device.c                     |  2 +-
 drivers/gpu/drm/xe/xe_force_wake.c                 | 12 +++-
 drivers/gpu/drm/xe/xe_guc_ct.c                     | 18 +++++
 drivers/gpu/drm/xe/xe_guc_submit.c                 | 14 +++-
 drivers/gpu/drm/xe/xe_query.c                      |  6 +-
 drivers/gpu/drm/xe/xe_sync.c                       |  3 +-
 drivers/hid/hid-ids.h                              |  2 +
 drivers/hid/hid-lenovo.c                           |  8 +++
 drivers/hid/hid-multitouch.c                       | 13 ++++
 drivers/hid/i2c-hid/i2c-hid-core.c                 | 10 +++
 drivers/infiniband/sw/siw/siw_qp_tx.c              |  2 +
 drivers/iommu/arm/arm-smmu/arm-smmu-impl.c         |  4 +-
 drivers/irqchip/irq-mscc-ocelot.c                  |  4 +-
 drivers/net/mdio/mdio-bcm-unimac.c                 |  1 +
 drivers/net/usb/qmi_wwan.c                         |  1 +
 drivers/nvme/host/core.c                           | 52 ++++++++------
 drivers/nvme/host/multipath.c                      | 33 +++++++++
 drivers/nvme/host/nvme.h                           |  1 +
 drivers/nvme/host/tcp.c                            |  7 +-
 drivers/nvme/target/loop.c                         | 13 ++++
 drivers/nvme/target/passthru.c                     |  6 +-
 drivers/pinctrl/intel/Kconfig                      |  1 +
 drivers/pinctrl/pinctrl-aw9523.c                   |  6 +-
 drivers/s390/crypto/ap_bus.c                       |  3 +-
 drivers/s390/crypto/ap_bus.h                       |  2 +-
 drivers/s390/crypto/ap_queue.c                     | 28 +++++---
 drivers/vdpa/ifcvf/ifcvf_base.c                    |  2 +-
 drivers/virtio/virtio_pci_common.c                 | 24 +++++--
 drivers/virtio/virtio_pci_common.h                 |  1 +
 drivers/virtio/virtio_pci_modern.c                 | 12 +---
 fs/9p/fid.c                                        |  5 +-
 fs/afs/internal.h                                  |  2 +
 fs/afs/rxrpc.c                                     | 83 +++++++++++++++-------
 fs/netfs/locking.c                                 |  3 +-
 fs/ocfs2/file.c                                    |  9 ++-
 fs/smb/client/connect.c                            | 14 +++-
 include/net/tls.h                                  | 12 +++-
 kernel/bpf/syscall.c                               | 14 ++--
 kernel/bpf/verifier.c                              |  4 +-
 lib/Kconfig.kasan                                  |  7 +-
 mm/slab_common.c                                   |  2 +-
 net/9p/client.c                                    | 12 +++-
 net/core/filter.c                                  |  2 +-
 samples/landlock/sandboxer.c                       | 32 ++++++++-
 sound/Kconfig                                      |  2 +-
 sound/pci/hda/patch_realtek.c                      | 29 ++++++++
 sound/soc/amd/yc/acp6x-mach.c                      | 14 ++++
 sound/soc/codecs/aw88399.c                         |  2 +-
 sound/soc/codecs/lpass-rx-macro.c                  | 15 ++--
 sound/soc/codecs/rt722-sdca-sdw.c                  |  2 +-
 sound/soc/fsl/fsl_micfil.c                         | 38 ++++++++++
 sound/soc/intel/avs/core.c                         |  3 +-
 sound/soc/intel/avs/pcm.c                          | 19 +++++
 sound/soc/intel/avs/pcm.h                          | 16 +++++
 sound/soc/intel/common/soc-acpi-intel-lnl-match.c  | 38 ++++++++++
 .../selftests/bpf/prog_tests/fill_link_info.c      |  9 +++
 .../selftests/bpf/progs/verifier_scalar_ids.c      | 67 +++++++++++++++++
 73 files changed, 670 insertions(+), 167 deletions(-)


