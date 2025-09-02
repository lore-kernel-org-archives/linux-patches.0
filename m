Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D16333436D;
	Tue,  2 Sep 2025 13:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820533; cv=none; b=WZUbgL3cEXEs9/YdIKs9kiyqJTm9mmHY8MuI3k09ePmLjILkBYf8pFIE7kUrXjqCDFJjjQhghMrnQ/2B22kdWHpkkEe0df21lstKo5gLXkICrUIB6xL9gUpVKNakWW8vZfMM3s4rJaCZ/rhjlakrK1iU//xFXXtdEVxsvqxYL4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820533; c=relaxed/simple;
	bh=2/iR/uIcgwB42IfEEw8WJHNtpReBdY9p846kS/7dtCI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kX5Z/tovoTBdz/hGXo7mZPJ0cf76m8G2N1DjZhfeOs8gLDPbBMvZfrcijo0c7ZS01TSN8YaKzAxSylZoyJBiufbqbVFBvdElNDzAX34eT8dSyNEMQDo6dGlXbbWztrEuypCPJwduat7mYXeplE0PeoaMp9yi1V+nb8/uwco6YGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBs8VxFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBs8VxFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2216C4CEED;
	Tue,  2 Sep 2025 13:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820533;
	bh=2/iR/uIcgwB42IfEEw8WJHNtpReBdY9p846kS/7dtCI=;
	h=From:To:Cc:Subject:Date:From;
	b=eBs8VxFeYTS4hjifvdm7H+8yD3UaLVVMW9wSV7e8Zlma9qBvycVPKb6PiDbVHAcEb
	 SdkcK61C2DTagHIj8hRRN8OHWl2dT+/PpqrhRpg462WFxDBc6crQHUP+7Br4xb6R9d
	 x/PJuRvBuHOkhs/g9+MB/eTyXn1lr65kp7ITKvus=
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
Subject: [PATCH 5.15 00/33] 5.15.191-rc1 review
Date: Tue,  2 Sep 2025 15:21:18 +0200
Message-ID: <20250902131927.045875971@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.191-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.191-rc1
X-KernelTest-Deadline: 2025-09-04T13:19+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.191 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.191-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.191-rc1

Eric Sandeen <sandeen@redhat.com>
    xfs: do not propagate ENODATA disk errors into xattr code

Imre Deak <imre.deak@intel.com>
    Revert "drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS"

Hamish Martin <hamish.martin@alliedtelesis.co.nz>
    HID: mcp2221: Handle reads greater than 60 bytes

Hamish Martin <hamish.martin@alliedtelesis.co.nz>
    HID: mcp2221: Don't set bus speed on every transfer

James Jones <jajones@nvidia.com>
    drm/nouveau/disp: Always accept linear modifier

Fabio Porcedda <fabio.porcedda@gmail.com>
    net: usb: qmi_wwan: add Telit Cinterion LE910C4-WWX new compositions

Shanker Donthineni <sdonthineni@nvidia.com>
    dma/pool: Ensure DMA_DIRECT_REMAP allocations are decrypted

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/amdgpu: fix incorrect vm flags to map bo"

Minjong Kim <minbell.kim@samsung.com>
    HID: hid-ntrig: fix unable to handle page fault in ntrig_report_version()

Ping Cheng <pinglinux@gmail.com>
    HID: wacom: Add a new Art Pen 2

Qasim Ijaz <qasdev00@gmail.com>
    HID: multitouch: fix slab out-of-bounds access in mt_report_fixup()

Qasim Ijaz <qasdev00@gmail.com>
    HID: asus: fix UAF via HID_CLAIMED_INPUT validation

Thijs Raymakers <thijs@raymakers.nl>
    KVM: x86: use array_index_nospec with indices that come from guest

Li Nan <linan122@huawei.com>
    efivarfs: Fix slab-out-of-bounds in efivarfs_d_compare

Eric Dumazet <edumazet@google.com>
    sctp: initialize more fields in sctp_v6_from_sk()

Rohan G Thomas <rohan.g.thomas@altera.com>
    net: stmmac: xgmac: Do not enable RX FIFO Overflow interrupts

Alexei Lazar <alazar@nvidia.com>
    net/mlx5e: Set local Xoff after FW update

Alexei Lazar <alazar@nvidia.com>
    net/mlx5e: Update and set Xon/Xoff upon port speed set

Alexei Lazar <alazar@nvidia.com>
    net/mlx5e: Update and set Xon/Xoff upon MTU set

Horatiu Vultur <horatiu.vultur@microchip.com>
    phy: mscc: Fix when PTP clock is register and unregister

Yeounsu Moon <yyyynoom@gmail.com>
    net: dlink: fix multicast stats being counted incorrectly

Kuniyuki Iwashima <kuniyu@google.com>
    atm: atmtcp: Prevent arbitrary write in atmtcp_recv_control().

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Detect if HCI_EV_NUM_COMP_PKTS is unbalanced

Madhavan Srinivasan <maddy@linux.ibm.com>
    powerpc/kvm: Fix ifdef to remove build warning

Oscar Maes <oscmaes92@gmail.com>
    net: ipv4: fix regression in local-broadcast routes

Jan Kara <jack@suse.cz>
    udf: Fix directory iteration for longer tail extents

Nikolay Kuratov <kniv@yandex-team.ru>
    vhost/net: Protect ubufs with rcu read lock in vhost_net_ubuf_put()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix a race when updating an existing write

Christoph Hellwig <hch@lst.de>
    nfs: fold nfs_page_group_lock_subrequests into nfs_lock_and_join_requests

Alexey Klimov <alexey.klimov@linaro.org>
    ASoC: codecs: tx-macro: correct tx_macro_component_drv name

Damien Le Moal <dlemoal@kernel.org>
    scsi: core: sysfs: Correct sysfs attributes access rights

Tengda Wu <wutengda@huaweicloud.com>
    ftrace: Fix potential warning in trace_printk_seq during ftrace_dump

Randy Dunlap <rdunlap@infradead.org>
    pinctrl: STMFX: add missing HAS_IOMEM dependency


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/powerpc/kernel/kvm.c                          |   8 +-
 arch/x86/kvm/lapic.c                               |   2 +
 arch/x86/kvm/x86.c                                 |   7 +-
 drivers/atm/atmtcp.c                               |  17 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c            |   4 +-
 drivers/gpu/drm/drm_dp_helper.c                    |   2 +-
 drivers/gpu/drm/nouveau/dispnv50/wndw.c            |   4 +
 drivers/hid/hid-asus.c                             |   8 +-
 drivers/hid/hid-mcp2221.c                          |  71 +++++++----
 drivers/hid/hid-multitouch.c                       |   8 ++
 drivers/hid/hid-ntrig.c                            |   3 +
 drivers/hid/wacom_wac.c                            |   1 +
 drivers/net/ethernet/dlink/dl2k.c                  |   2 +-
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |   3 +-
 .../ethernet/mellanox/mlx5/core/en/port_buffer.h   |  12 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  19 ++-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |   4 -
 drivers/net/phy/mscc/mscc.h                        |   4 +
 drivers/net/phy/mscc/mscc_main.c                   |   4 +-
 drivers/net/phy/mscc/mscc_ptp.c                    |  34 +++--
 drivers/net/usb/qmi_wwan.c                         |   3 +
 drivers/pinctrl/Kconfig                            |   1 +
 drivers/scsi/scsi_sysfs.c                          |   4 +-
 drivers/vhost/net.c                                |   9 +-
 fs/efivarfs/super.c                                |   4 +
 fs/nfs/pagelist.c                                  |  86 +------------
 fs/nfs/write.c                                     | 142 +++++++++++++--------
 fs/udf/directory.c                                 |   2 +-
 fs/xfs/libxfs/xfs_attr_remote.c                    |   7 +
 fs/xfs/libxfs/xfs_da_btree.c                       |   6 +
 include/linux/atmdev.h                             |   1 +
 include/linux/nfs_page.h                           |   2 +-
 kernel/dma/pool.c                                  |   4 +-
 kernel/trace/trace.c                               |   4 +-
 net/atm/common.c                                   |  15 ++-
 net/bluetooth/hci_event.c                          |  12 +-
 net/ipv4/route.c                                   |  10 +-
 net/sctp/ipv6.c                                    |   2 +
 sound/soc/codecs/lpass-tx-macro.c                  |   2 +-
 40 files changed, 328 insertions(+), 209 deletions(-)


