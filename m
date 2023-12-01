Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A9F19472;
	Fri,  1 Dec 2023 08:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EbxsWd6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62013C433C7;
	Fri,  1 Dec 2023 08:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701419157;
	bh=WYK2BIUdtWrr05nr4TbxmaokmcXMwcd8+e2s0vLcCr4=;
	h=From:To:Cc:Subject:Date:From;
	b=EbxsWd6EY3RWDtDRpxQ4EwBbgawTYf1V9qk2R4UXbR0Fewa7/PRhYO86qt0LQQddz
	 kTFqc2dneoZVIldgKDc+0aQVxhmhp4ItU8Y7C/kOxcESfdq3P4/mPOqeRbynMCgDTU
	 MvNOBZvogaNNd3G+AS9RD126GHfjieCypXWKgyQU=
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
	allen.lkml@gmail.com
Subject: [PATCH 5.15 00/68] 5.15.141-rc2 review
Date: Fri,  1 Dec 2023 08:25:54 +0000
Message-ID: <20231201082345.123842367@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.141-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.141-rc2
X-KernelTest-Deadline: 2023-12-03T08:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.141 release.
There are 68 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 03 Dec 2023 08:23:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.141-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.141-rc2

Keith Busch <kbusch@kernel.org>
    io_uring: fix off-by one bvec index

Johan Hovold <johan+linaro@kernel.org>
    USB: dwc3: qcom: fix wakeup after probe deferral

Johan Hovold <johan+linaro@kernel.org>
    USB: dwc3: qcom: fix software node leak on probe errors

Ricardo Ribalda <ribalda@chromium.org>
    usb: dwc3: set the dma max_seg_size

Alexander Stein <alexander.stein@ew.tq-group.com>
    usb: dwc3: Fix default mode initialization

Oliver Neukum <oneukum@suse.com>
    USB: dwc2: write HCINT with INTMASK applied

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Skip hard reset when in error recovery

Lech Perczak <lech.perczak@gmail.com>
    USB: serial: option: don't claim interface 4 for ZTE MF290

Puliang Lu <puliang.lu@fibocom.com>
    USB: serial: option: fix FM101R-GL defines

Victor Fragoso <victorffs@hotmail.com>
    USB: serial: option: add Fibocom L7xx modules

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fix deadlock issue during using NCM gadget

Mingzhe Zou <mingzhe.zou@easystack.cn>
    bcache: fixup lock c->root error

Mingzhe Zou <mingzhe.zou@easystack.cn>
    bcache: fixup init dirty data errors

Rand Deeb <rand.sec96@gmail.com>
    bcache: prevent potential division by zero error

Coly Li <colyli@suse.de>
    bcache: check return value from btree_node_alloc_replacement()

Mikulas Patocka <mpatocka@redhat.com>
    dm-delay: fix a race between delay_presuspend and delay_bio

Long Li <longli@microsoft.com>
    hv_netvsc: Mark VF as slave before exposing it to user-mode

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Fix race of register_netdevice_notifier and VF register

Asuna Yang <spriteovo@gmail.com>
    USB: serial: option: add Luat Air72*U series products

Jan Höppner <hoeppner@linux.ibm.com>
    s390/dasd: protect device queue against concurrent access

Charles Mirabile <cmirabil@redhat.com>
    io_uring/fs: consider link->flags when getting path for LINKAT

Mingzhe Zou <mingzhe.zou@easystack.cn>
    bcache: fixup multi-threaded bch_sectors_dirty_init() wake-up race

Song Liu <song@kernel.org>
    md: fix bi_status reporting in md_end_clone_io

Coly Li <colyli@suse.de>
    bcache: replace a mistaken IS_ERR() by IS_ERR_OR_NULL() in btree_gc_coalesce()

Keith Busch <kbusch@kernel.org>
    swiotlb-xen: provide the "max_mapping_size" method

Hans de Goede <hdegoede@redhat.com>
    ACPI: resource: Skip IRQ override on ASUS ExpertBook B1402CVA

Krister Johansen <kjlx@templeofstupid.com>
    proc: sysctl: prevent aliased sysctls from getting passed to init

Zhang Yi <yi.zhang@huawei.com>
    ext4: make sure allocate pending entry not fail

Baokun Li <libaokun1@huawei.com>
    ext4: fix slab-use-after-free in ext4_es_insert_extent()

Baokun Li <libaokun1@huawei.com>
    ext4: using nofail preallocation in ext4_es_insert_extent()

Baokun Li <libaokun1@huawei.com>
    ext4: using nofail preallocation in ext4_es_insert_delayed_block()

Baokun Li <libaokun1@huawei.com>
    ext4: using nofail preallocation in ext4_es_remove_extent()

Baokun Li <libaokun1@huawei.com>
    ext4: use pre-allocated es in __es_remove_extent()

Baokun Li <libaokun1@huawei.com>
    ext4: use pre-allocated es in __es_insert_extent()

Baokun Li <libaokun1@huawei.com>
    ext4: factor out __es_alloc_extent() and __es_free_extent()

Baokun Li <libaokun1@huawei.com>
    ext4: add a new helper to check if es must be kept

Andrey Konovalov <andrey.konovalov@linaro.org>
    media: qcom: camss: Fix csid-gen2 for test pattern generator

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: qcom: camss: Fix set CSI2_RX_CFG1_VC_MODE when VC is greater than 3

Milen Mitkov <quic_mmitkov@quicinc.com>
    media: camss: sm8250: Virtual channels for CSID

Souptick Joarder (HPE) <jrdr.linux@gmail.com>
    media: camss: Replace hard coded value with parameter

Huacai Chen <chenhuacai@kernel.org>
    MIPS: KVM: Fix a build warning about variable set but not used

Peter Zijlstra <peterz@infradead.org>
    lockdep: Fix block chain corruption

Johan Hovold <johan+linaro@kernel.org>
    USB: dwc3: qcom: fix ACPI platform device leak

Johan Hovold <johan+linaro@kernel.org>
    USB: dwc3: qcom: fix resource leaks on probe deferral

Christoph Hellwig <hch@lst.de>
    nvmet: nul-terminate the NQNs passed in the connect command

David Howells <dhowells@redhat.com>
    afs: Fix file locking on R/O volumes to operate in local mode

David Howells <dhowells@redhat.com>
    afs: Return ENOENT if no cell DNS record can be found

Samuel Holland <samuel.holland@sifive.com>
    net: axienet: Fix check for partial TX checksum

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: propagate the correct speed and duplex status

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: handle the corner-case during tx completion

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: handle corner-case during sfp hotplug

Suman Ghosh <sumang@marvell.com>
    octeontx2-pf: Fix ntuple rule creation to direct packet to VF with higher Rx queue than its PF

Stefano Stabellini <sstabellini@kernel.org>
    arm/xen: fix xen_vcpu_info allocation alignment

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: avoid data corruption caused by decline

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    net: usb: ax88179_178a: fix failed operations during ax88179_reset

Kunwu Chan <chentao@kylinos.cn>
    ipv4: Correct/silence an endian warning in __ip_do_redirect

Charles Yi <be286@163.com>
    HID: fix HID device resource race between HID core and debugging support

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: core: store the unique system identifier in hid_device

Jonas Karlman <jonas@kwiboo.se>
    drm/rockchip: vop: Fix color for RGB888/BGR888 format on VOP full

Chen Ni <nichen@iscas.ac.cn>
    ata: pata_isapnp: Add missing error check for devm_ioport_map()

Suman Ghosh <sumang@marvell.com>
    octeontx2-pf: Fix memory leak during interface down

Eric Dumazet <edumazet@google.com>
    wireguard: use DEV_STATS_INC()

Marek Vasut <marex@denx.de>
    drm/panel: simple: Fix Innolux G101ICE-L01 timings

Marek Vasut <marex@denx.de>
    drm/panel: simple: Fix Innolux G101ICE-L01 bus flags

Xuxin Xiong <xuxinxiong@huaqin.corp-partner.google.com>
    drm/panel: auo,b101uan08.3: Fine tune the panel power sequence

Shuijing Li <shuijing.li@mediatek.com>
    drm/panel: boe-tv101wum-nl6: Fine tune the panel power sequence

David Howells <dhowells@redhat.com>
    afs: Make error on cell lookup failure consistent with OpenAFS

David Howells <dhowells@redhat.com>
    afs: Fix afs_server_list to be cleaned up with RCU


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/xen/enlighten.c                           |   3 +-
 arch/mips/kvm/mmu.c                                |   3 +-
 drivers/acpi/resource.c                            |   7 +
 drivers/ata/pata_isapnp.c                          |   3 +
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c     |   7 +
 drivers/gpu/drm/panel/panel-simple.c               |  13 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |  14 +-
 drivers/hid/hid-core.c                             |  16 +-
 drivers/hid/hid-debug.c                            |   3 +
 drivers/md/bcache/btree.c                          |   4 +-
 drivers/md/bcache/sysfs.c                          |   2 +-
 drivers/md/bcache/writeback.c                      |  22 +-
 drivers/md/dm-delay.c                              |  17 +-
 drivers/md/md.c                                    |   3 +-
 drivers/media/platform/qcom/camss/camss-csid-170.c |  65 +++--
 drivers/media/platform/qcom/camss/camss-csid.c     |  44 ++-
 drivers/media/platform/qcom/camss/camss-csid.h     |  11 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |  14 +
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c       |  11 +-
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |  14 +-
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |  20 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   2 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   2 +-
 drivers/net/hyperv/netvsc_drv.c                    |  41 ++-
 drivers/net/usb/ax88179_178a.c                     |   4 +-
 drivers/net/wireguard/device.c                     |   4 +-
 drivers/net/wireguard/receive.c                    |  12 +-
 drivers/net/wireguard/send.c                       |   3 +-
 drivers/nvme/target/fabrics-cmd.c                  |   4 +
 drivers/s390/block/dasd.c                          |  24 +-
 drivers/usb/cdns3/cdnsp-ring.c                     |   3 +
 drivers/usb/dwc2/hcd_intr.c                        |  15 +-
 drivers/usb/dwc3/core.c                            |   2 +
 drivers/usb/dwc3/drd.c                             |   2 +-
 drivers/usb/dwc3/dwc3-qcom.c                       |  65 +++--
 drivers/usb/serial/option.c                        |  11 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   9 +
 drivers/xen/swiotlb-xen.c                          |   1 +
 fs/afs/dynroot.c                                   |   4 +-
 fs/afs/internal.h                                  |   1 +
 fs/afs/server_list.c                               |   2 +-
 fs/afs/super.c                                     |   2 +
 fs/afs/vl_rotate.c                                 |  10 +
 fs/ext4/extents_status.c                           | 306 +++++++++++++++------
 fs/proc/proc_sysctl.c                              |   7 +
 include/linux/hid.h                                |   5 +
 include/linux/sysctl.h                             |   6 +
 init/main.c                                        |   4 +
 io_uring/io_uring.c                                |   4 +-
 kernel/locking/lockdep.c                           |   3 +-
 net/ipv4/route.c                                   |   2 +-
 net/smc/af_smc.c                                   |   8 +-
 53 files changed, 629 insertions(+), 239 deletions(-)


