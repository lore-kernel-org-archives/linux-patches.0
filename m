Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB766AA0;
	Tue,  5 Dec 2023 03:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJHTbIPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35100C433C7;
	Tue,  5 Dec 2023 03:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746325;
	bh=xwjU5njY2X1hCcBusRntnq4lmODqc/gRQoKgw0mnz7g=;
	h=From:To:Cc:Subject:Date:From;
	b=ZJHTbIPq2cGOAxT/351Rqsh8+kBYfVaSYz1U309gOq8Ovd+VzOrFQfRz3Ki/S1yxm
	 FNMFkXpyxReIUZvnVFl3heo8HpldS1FlYuJqEAlB/uB1VA+xUVqsjQH2gmUfGQnRNK
	 +WU99DqlRHmJol4FEIfBooGx3ZkkRuwwg8Q3n1m0=
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
Subject: [PATCH 4.14 00/30] 4.14.332-rc1 review
Date: Tue,  5 Dec 2023 12:16:07 +0900
Message-ID: <20231205031511.476698159@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.332-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.332-rc1
X-KernelTest-Deadline: 2023-12-07T03:15+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 4.14.332 release.
There are 30 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.332-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.332-rc1

Saravana Kannan <saravanak@google.com>
    driver core: Release all resources during unbind before updating device links

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    net: ravb: Start TX queues after HW initialization succeeded

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    ravb: Fix races between ravb_tx_timeout_work() and net related ops

Zhengchao Shao <shaozhengchao@huawei.com>
    ipv4: igmp: fix refcnt uaf issue when receiving igmp query packet

Jann Horn <jannh@google.com>
    btrfs: send: ensure send_fd is writable

Filipe Manana <fdmanana@suse.com>
    btrfs: fix off-by-one when checking chunk map includes logical address

Timothy Pearson <tpearson@raptorengineering.com>
    powerpc: Don't clobber f0/vs0 during fp|altivec register save

Wu Bo <bo.wu@vivo.com>
    dm verity: don't perform FEC for failed readahead IO

Mikulas Patocka <mpatocka@redhat.com>
    dm-verity: align struct dm_verity_fec_io properly

Yang Yingliang <yangyingliang@huawei.com>
    firewire: core: fix possible memory leak in create_units()

Maria Yu <quic_aiquny@quicinc.com>
    pinctrl: avoid reload of p state in list iteration

Ricardo Ribalda <ribalda@chromium.org>
    usb: dwc3: set the dma max_seg_size

Lech Perczak <lech.perczak@gmail.com>
    USB: serial: option: don't claim interface 4 for ZTE MF290

Puliang Lu <puliang.lu@fibocom.com>
    USB: serial: option: fix FM101R-GL defines

Victor Fragoso <victorffs@hotmail.com>
    USB: serial: option: add Fibocom L7xx modules

Rand Deeb <rand.sec96@gmail.com>
    bcache: prevent potential division by zero error

Coly Li <colyli@suse.de>
    bcache: check return value from btree_node_alloc_replacement()

Asuna Yang <spriteovo@gmail.com>
    USB: serial: option: add Luat Air72*U series products

Jan Höppner <hoeppner@linux.ibm.com>
    s390/dasd: protect device queue against concurrent access

Claire Lin <claire.lin@broadcom.com>
    mtd: rawnand: brcmnand: Fix ecc chunk calculation for erased page bitfips

Samuel Holland <samuel.holland@sifive.com>
    net: axienet: Fix check for partial TX checksum

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: propagate the correct speed and duplex status

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: handle corner-case during sfp hotplug

Stefano Stabellini <sstabellini@kernel.org>
    arm/xen: fix xen_vcpu_info allocation alignment

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    net: usb: ax88179_178a: fix failed operations during ax88179_reset

Kunwu Chan <chentao@kylinos.cn>
    ipv4: Correct/silence an endian warning in __ip_do_redirect

Jonas Karlman <jonas@kwiboo.se>
    drm/rockchip: vop: Fix color for RGB888/BGR888 format on VOP full

Chen Ni <nichen@iscas.ac.cn>
    ata: pata_isapnp: Add missing error check for devm_ioport_map()

Marek Vasut <marex@denx.de>
    drm/panel: simple: Fix Innolux G101ICE-L01 timings

Christopher Bednarz <christopher.n.bednarz@intel.com>
    RDMA/irdma: Prevent zero-length STAG registration


-------------

Diffstat:

 Makefile                                          |  4 ++--
 arch/arm/xen/enlighten.c                          |  3 ++-
 arch/powerpc/kernel/fpu.S                         | 13 ++++++++++++
 arch/powerpc/kernel/vector.S                      |  2 ++
 drivers/ata/pata_isapnp.c                         |  3 +++
 drivers/base/dd.c                                 |  4 ++--
 drivers/firewire/core-device.c                    | 11 ++++-------
 drivers/gpu/drm/panel/panel-simple.c              | 12 ++++++------
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c       | 14 ++++++++++---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c          |  6 ++++++
 drivers/infiniband/hw/i40iw/i40iw_type.h          |  2 ++
 drivers/infiniband/hw/i40iw/i40iw_verbs.c         | 10 ++++++++--
 drivers/md/bcache/btree.c                         |  2 ++
 drivers/md/bcache/sysfs.c                         |  2 +-
 drivers/md/dm-verity-fec.c                        |  3 ++-
 drivers/md/dm-verity-target.c                     |  4 +++-
 drivers/md/dm-verity.h                            |  6 ------
 drivers/mtd/nand/brcmnand/brcmnand.c              |  5 ++++-
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c      | 11 ++++++++---
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c         | 14 ++++++++++++-
 drivers/net/ethernet/renesas/ravb_main.c          | 15 +++++++++++---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |  2 +-
 drivers/net/usb/ax88179_178a.c                    |  4 ++--
 drivers/pinctrl/core.c                            |  6 +++---
 drivers/s390/block/dasd.c                         | 24 ++++++++++++-----------
 drivers/usb/dwc3/core.c                           |  2 ++
 drivers/usb/serial/option.c                       | 11 ++++++++---
 fs/btrfs/send.c                                   |  2 +-
 fs/btrfs/volumes.c                                |  2 +-
 net/ipv4/igmp.c                                   |  6 ++++--
 net/ipv4/route.c                                  |  2 +-
 31 files changed, 142 insertions(+), 65 deletions(-)


