Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098163128AF;
	Tue,  2 Sep 2025 13:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820697; cv=none; b=HYchu4xtMkv8cIWxXKX3fgXBJL7CM6wGNxT14scaMTynwbDZSv5FQYXeQZ6VSzVJvkl8APOadSNkKN4KR1Ka7aeZQLrMyYknFsc4D9XWa7KoT9EaNwsyptGBl51ydYpF2i+C6t8MI+QTf1nJZgqKz8QF+FicL5FQPgTUFegIy7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820697; c=relaxed/simple;
	bh=5pMzXFrxPTDT3Z2PexdQ6d9teAyKHl1HKqcaOk3CjRI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jF9ZiO40X7KsdN0wwfgHIwMXhMwcPi+f0kR9dXay4C7ucbU0W2m3N962wuU0uogGU6enRUQ90mzl1eIvub9WaDfpDWBblhFSFe5l1eE/CDf5DaXt+v8eOstVKlzlAUGE9sjMmIyBWYEOPg5ze645rfPooo7pGTlGbpRqtxyUvc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NPfJiQm/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPfJiQm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FE2C4CEED;
	Tue,  2 Sep 2025 13:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820696;
	bh=5pMzXFrxPTDT3Z2PexdQ6d9teAyKHl1HKqcaOk3CjRI=;
	h=From:To:Cc:Subject:Date:From;
	b=NPfJiQm/9RymRFM/BSUMSoDRR/W9ZPPWWz6TVTIePvCeU3+1I9hjIfuSTKzW2WInr
	 9q1/LUka7hlZra6lMP6XkuY+PjN/KB8VLzfMJo9uXV1BJ89kXInZjXJAwicutzES8x
	 bchJCNGOTQhM61XCPX3wsgY+lODZRVPM5BL0XP+4=
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
Subject: [PATCH 5.10 00/34] 5.10.242-rc1 review
Date: Tue,  2 Sep 2025 15:21:26 +0200
Message-ID: <20250902131926.607219059@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.242-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.242-rc1
X-KernelTest-Deadline: 2025-09-04T13:19+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.242 release.
There are 34 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.242-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.242-rc1

Eric Sandeen <sandeen@redhat.com>
    xfs: do not propagate ENODATA disk errors into xattr code

Brent Lu <brent.lu@intel.com>
    ASoC: Intel: sof_da7219_mx98360a: fail to initialize soundcard

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: glk_rt5682_max98357a: shrink platform_id below 20 characters

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_rt5682: shrink platform_id names below 20 characters

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: bxt_da7219_max98357a: shrink platform_id below 20 characters

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

Nikolay Kuratov <kniv@yandex-team.ru>
    vhost/net: Protect ubufs with rcu read lock in vhost_net_ubuf_put()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix a race when updating an existing write

Christoph Hellwig <hch@lst.de>
    nfs: fold nfs_page_group_lock_subrequests into nfs_lock_and_join_requests

Tianxiang Peng <txpeng@tencent.com>
    x86/cpu/hygon: Add missing resctrl_cpu_detect() in bsp_init helper

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
 arch/x86/kernel/cpu/hygon.c                        |   3 +
 arch/x86/kvm/lapic.c                               |   2 +
 arch/x86/kvm/x86.c                                 |   7 +-
 drivers/atm/atmtcp.c                               |  17 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c            |   4 +-
 drivers/gpu/drm/drm_dp_helper.c                    |   2 +-
 drivers/gpu/drm/nouveau/dispnv50/wndw.c            |   4 +
 drivers/hid/hid-asus.c                             |   8 +-
 drivers/hid/hid-mcp2221.c                          |  71 +++++++----
 drivers/hid/hid-ntrig.c                            |   3 +
 drivers/hid/wacom_wac.c                            |   1 +
 drivers/net/ethernet/dlink/dl2k.c                  |   2 +-
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |   3 +-
 .../ethernet/mellanox/mlx5/core/en/port_buffer.h   |  12 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  19 ++-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |   4 -
 drivers/net/usb/qmi_wwan.c                         |   3 +
 drivers/pinctrl/Kconfig                            |   1 +
 drivers/scsi/scsi_sysfs.c                          |   4 +-
 drivers/vhost/net.c                                |   9 +-
 fs/efivarfs/super.c                                |   4 +
 fs/nfs/pagelist.c                                  |  86 +------------
 fs/nfs/write.c                                     | 142 +++++++++++++--------
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
 sound/soc/intel/boards/bxt_da7219_max98357a.c      |  12 +-
 sound/soc/intel/boards/glk_rt5682_max98357a.c      |   4 +-
 sound/soc/intel/boards/sof_da7219_max98373.c       |   2 +-
 sound/soc/intel/boards/sof_rt5682.c                |  12 +-
 sound/soc/intel/common/soc-acpi-intel-bxt-match.c  |   2 +-
 sound/soc/intel/common/soc-acpi-intel-cml-match.c  |   2 +-
 sound/soc/intel/common/soc-acpi-intel-glk-match.c  |   4 +-
 sound/soc/intel/common/soc-acpi-intel-jsl-match.c  |   2 +-
 sound/soc/intel/common/soc-acpi-intel-tgl-match.c  |   4 +-
 44 files changed, 317 insertions(+), 213 deletions(-)


