Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEE31C68C;
	Sun,  1 Sep 2024 16:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208742; cv=none; b=YjPgAjP1blT5i9YBXp6glcVmnCe8eOi/A4zKK+L3/ouS4mhzLVZFgB+eP/awSFYDQ9bMqNkO10HnUEXx5c0q2tCCCT4Xegut5xqtF2sg8QP5hc8K81ZihETPqumLOWenO+hhFIO6s0cOJ71LaM6+rybTeGEjS9fu37Nxb3ydpkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208742; c=relaxed/simple;
	bh=EqJ2s6fKNRU9OvLKvUeoc79SN9Mem9wj9NCAw0V6cPM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NLmnlQWqBMjRPehM4cshMKRt9AKGLQtUK2rX8CAFR0p+04qzwqbT3Owy5wD8xFvyz0UKNZeKVxiN6iM6wnXwWCsAHm88Lwujv11yJEkaH/C3hpclVR6Rh3lYK+UMgdemTvQ0TQaedGOdGWwZ5tuQ1t7kHOlj2ohvmVayCSr7KCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rH1b8QMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rH1b8QMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7259BC4CEC3;
	Sun,  1 Sep 2024 16:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208742;
	bh=EqJ2s6fKNRU9OvLKvUeoc79SN9Mem9wj9NCAw0V6cPM=;
	h=From:To:Cc:Subject:Date:From;
	b=rH1b8QMzqO6Pm14TkgS0goXLGN2vioFae7YSFsDZRJ4tP+qRM9OfIguEEkbmm2KHy
	 Og1ZSrlbftlDu5f3Zu9/QcH3UkAQDZsHQC3KKKEPHUGjc1AfGnsyeQs2ub0Rt/JghF
	 oXlP6kji0gh2OFKTCjGHIXC08yX8qnuTlIAi4pDA=
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
	allen.lkml@gmail.com,
	broonie@kernel.org
Subject: [PATCH 5.4 000/134] 5.4.283-rc1 review
Date: Sun,  1 Sep 2024 18:15:46 +0200
Message-ID: <20240901160809.752718937@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.283-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.283-rc1
X-KernelTest-Deadline: 2024-09-03T16:08+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.4.283 release.
There are 134 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.283-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.283-rc1

Ben Hutchings <benh@debian.org>
    scsi: aacraid: Fix double-free on probe failure

Andrew Lunn <andrew@lunn.ch>
    net: dsa: mv8e6xxx: Fix stub function parameters

Zijun Hu <quic_zijuhu@quicinc.com>
    usb: core: sysfs: Unmerge @usb3_hardware_lpm_attr_group in remove_power_attributes()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    usb: dwc3: st: add missing depopulate in probe error path

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    usb: dwc3: st: fix probed platform device ref count on probe error path

Selvarasu Ganesan <selvarasu.g@samsung.com>
    usb: dwc3: core: Prevent USB core invalid event buffer address access

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    usb: dwc3: omap: add missing depopulate in probe error path

ZHANG Yuntian <yt@radxa.com>
    USB: serial: option: add MeiG Smart SRM825L

Ian Ray <ian.ray@gehealthcare.com>
    cdc-acm: Add DISABLE_ECHO quirk for GE HealthCare UI Controller

Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
    soc: qcom: cmd-db: Map shared memory as WC, not WB

Aleksandr Mishin <amishin@t-argos.ru>
    nfc: pn533: Add poll mod list filling check

Lars Poeschel <poeschel@lemonage.de>
    nfc: pn533: Add autopoll capability

Lars Poeschel <poeschel@lemonage.de>
    nfc: pn533: Add dev_up/dev_down hooks to phy_ops

Eric Dumazet <edumazet@google.com>
    net: busy-poll: use ktime_get_ns() instead of local_clock()

Cong Wang <cong.wang@bytedance.com>
    gtp: fix a potential NULL pointer dereference

Jamie Bainbridge <jamie.bainbridge@gmail.com>
    ethtool: check device is present when getting link settings

Prashant Malani <pmalani@chromium.org>
    r8152: Factor out OOB link list waits

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    soundwire: stream: fix programming slave ports for non-continous port maps

Allison Henderson <allison.henderson@oracle.com>
    net:rds: Fix possible deadlock in rds_message_put

Chen Ridong <chenridong@huawei.com>
    cgroup/cpuset: Prevent UAF in proc_cpuset_show()

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Fix null pointer dereference on error

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix integer overflow calculating timestamp

Long Li <leo.lilong@huawei.com>
    filelock: Correct the filelock owner in fcntl_setlk/fcntl_setlk64

Alex Deucher <alexander.deucher@amd.com>
    drm/amdkfd: don't allow mapping the MMIO HDP page with large pages

Rafael Aquini <aquini@redhat.com>
    ipc: replace costly bailout check in sysvipc_find_ipc()

Sascha Hauer <s.hauer@pengutronix.de>
    wifi: mwifiex: duplicate static structs used in driver instances

Ma Ke <make24@iscas.ac.cn>
    pinctrl: single: fix potential NULL dereference in pcs_get_function()

Jesse Zhang <jesse.zhang@amd.com>
    drm/amdgpu: Using uninitialized value *size when calling amdgpu_vce_cs_reloc

Alexander Lobakin <aleksander.lobakin@intel.com>
    tools: move alignment-related macros to new <linux/align.h>

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Input: MT - limit max slots

Lee, Chun-Yi <joeyli.kernel@gmail.com>
    Bluetooth: hci_ldisc: check HCI_UART_PROTO_READY flag in HCIUARTGETPROTO

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Relax start tick time check for slave timer elements

Ben Whitten <ben.whitten@gmail.com>
    mmc: dw_mmc: allow biu and ciu clocks to defer

Nikolay Kuratov <kniv@yandex-team.ru>
    cxgb4: add forgotten u64 ivlan cast before shift

Siarhei Vishniakou <svv@google.com>
    HID: microsoft: Add rumble support to latest xbox controllers

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Defer calculation of resolution until resolution_code is known

Griffin Kroah-Hartman <griffin@kroah.com>
    Bluetooth: MGMT: Add error handling to pair_device()

Dan Carpenter <dan.carpenter@linaro.org>
    mmc: mmc_test: Fix NULL dereference on allocation failure

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: don't play tricks with debug macros

Jani Nikula <jani.nikula@intel.com>
    drm/msm: use drm_debug_enabled() to check for debug categories

Sean Anderson <sean.anderson@linux.dev>
    net: xilinx: axienet: Fix dangling multicast addresses

Sean Anderson <sean.anderson@linux.dev>
    net: xilinx: axienet: Always disable promiscuous mode

Eric Dumazet <edumazet@google.com>
    ipv6: prevent UAF in ip6_send_skb()

Stephen Hemminger <stephen@networkplumber.org>
    netem: fix return value if duplicate enqueue fails

Joseph Huang <Joseph.Huang@garmin.com>
    net: dsa: mv88e6xxx: Fix out-of-bound access

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: mv88e6xxx: replace ATU violation prints with trace points

Hans J. Schultz <netdev@kapio-technology.com>
    net: dsa: mv88e6xxx: read FID when handling ATU violations

Andrew Lunn <andrew@lunn.ch>
    net: dsa: mv88e6xxx: global1_atu: Add helper for get next

Andrew Lunn <andrew@lunn.ch>
    net: dsa: mv88e6xxx: global2: Expose ATU stats register

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    netfilter: nft_counter: Synchronize nft_counter_reset() against reader.

Kuniyuki Iwashima <kuniyu@amazon.com>
    kcm: Serialise kcm_sendmsg() for the same socket.

Simon Horman <horms@kernel.org>
    tc-testing: don't access non-existent variable on exception

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix LE quote calculation

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix not handling link timeouts propertly

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Make use of __check_timeout on hci_sched_le

Mikulas Patocka <mpatocka@redhat.com>
    dm suspend: return -ERESTARTSYS instead of -EINTR

Ming Lei <ming.lei@redhat.com>
    dm: do not use waitqueue for request-based DM

Gabriel Krisman Bertazi <krisman@collabora.com>
    dm mpath: pass IO start time to path selector

Aurelien Jarno <aurelien@aurel32.net>
    media: solo6x10: replace max(a, min(b, c)) by clamp(b, a, c)

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    block: use "unsigned long" for blk_validate_block_size().

Eric Dumazet <edumazet@google.com>
    gtp: pull network headers in gtp_dev_xmit()

Phil Chang <phil.chang@mediatek.com>
    hrtimer: Prevent queuing of hrtimer without a function callback

Sagi Grimberg <sagi@grimberg.me>
    nvmet-rdma: fix possible bad dereference when freeing rsps

Baokun Li <libaokun1@huawei.com>
    ext4: set the type of max_zeroout to unsigned int to avoid overflow

Guanrui Huang <guanrui.huang@linux.alibaba.com>
    irqchip/gic-v3-its: Remove BUG_ON in its_vpe_irq_domain_alloc

Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>
    fbdev: offb: replace of_node_put with __free(device_node)

Krishna Kurapati <quic_kriskura@quicinc.com>
    usb: dwc3: core: Skip setting event buffers for host only controllers

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/iucv: fix receive buffer virtual vs physical address confusion

Oreoluwa Babatunde <quic_obabatun@quicinc.com>
    openrisc: Call setup_memory() earlier in the init sequence

NeilBrown <neilb@suse.de>
    NFS: avoid infinite loop in pnfs_update_layout.

Hannes Reinecke <hare@suse.de>
    nvmet-tcp: do not continue for invalid icreq

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: bnep: Fix out-of-bound access

Keith Busch <kbusch@kernel.org>
    nvme: clear caller pointer on identify failure

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    usb: gadget: fsl: Increase size of name buffer for endpoints

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: fix to do sanity check in update_sit_entry

David Sterba <dsterba@suse.com>
    btrfs: delete pointless BUG_ON check on quota root in btrfs_qgroup_account_extent()

David Sterba <dsterba@suse.com>
    btrfs: send: handle unexpected data in header buffer in begin_cmd()

David Sterba <dsterba@suse.com>
    btrfs: handle invalid root reference found in may_destroy_subvol()

David Sterba <dsterba@suse.com>
    btrfs: change BUG_ON to assertion when checking for delayed_node root

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/boot: Only free if realloc() succeeds

Li zeming <zeming@nfschina.com>
    powerpc/boot: Handle allocation failure in simple_realloc()

Helge Deller <deller@gmx.de>
    parisc: Use irq_enter_rcu() to fix warning at kernel/context_tracking.c:367

Kees Cook <keescook@chromium.org>
    x86: Increase brk randomness entropy for 64-bit systems

Li Nan <linan122@huawei.com>
    md: clean up invalid BUG_ON in md_ioctl

Stefan Hajnoczi <stefanha@redhat.com>
    virtiofs: forbid newlines in tags

Erico Nunes <nunes.erico@gmail.com>
    drm/lima: set gp bus_stop bit before hard reset

Kees Cook <keescook@chromium.org>
    net/sun3_82586: Avoid reading past buffer in debug output

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Initialize status local variable in lpfc_sli4_repost_sgl_list()

Max Filippov <jcmvbkbc@gmail.com>
    fs: binfmt_elf_efpic: don't use missing interpreter's properties

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: pci: cx23885: check cx23885_vdev_init() return

Jan Kara <jack@suse.cz>
    quota: Remove BUG_ON from dqget()

Baokun Li <libaokun1@huawei.com>
    ext4: do not trim the group with corrupted block bitmap

Daniel Wagner <dwagner@suse.de>
    nvmet-trace: avoid dereferencing pointer too early

Kunwu Chan <chentao@kylinos.cn>
    powerpc/xics: Check return value of kasprintf in icp_native_map_one_cpu

Chengfeng Ye <dg573847474@gmail.com>
    IB/hfi1: Fix potential deadlock on &irq_src_lock and &dd->uctxt_lock

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: abort scan when rfkill on but device enabled

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: setattr_chown: Add missing initialization

Mike Christie <michael.christie@oracle.com>
    scsi: spi: Fix sshdr use

Christian Brauner <christian.brauner@ubuntu.com>
    binfmt_misc: cleanup on filesystem umount

Chengfeng Ye <dg573847474@gmail.com>
    staging: ks7010: disable bh on tx_dev_lock

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: radio-isa: use dev_name to fill in bus_info

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: riic: avoid potential division by zero

Jeff Johnson <quic_jjohnson@quicinc.com>
    wifi: cw1200: Avoid processing an invalid TIM IE

Rand Deeb <rand.sec96@gmail.com>
    ssb: Fix division by zero issue in ssb_calc_clock_rate

Parsa Poorshikhian <parsa.poorsh@gmail.com>
    ALSA: hda/realtek: Fix noise from speakers on Lenovo IdeaPad 3 15IAU7

Jie Wang <wangjie125@huawei.com>
    net: hns3: fix a deadlock problem when config TC during resetting

Pawel Dembicki <paweldembicki@gmail.com>
    net: dsa: vsc73xx: pass value in phy_write operation

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    net: axienet: Fix register defines comment description

Andre Przywara <andre.przywara@arm.com>
    net: axienet: Autodetect 64-bit DMA capability

Andre Przywara <andre.przywara@arm.com>
    net: axienet: Upgrade descriptors to hold 64-bit addresses

Andre Przywara <andre.przywara@arm.com>
    net: axienet: Wrap DMA pointer writes to prepare for 64 bit

Andre Przywara <andre.przywara@arm.com>
    net: axienet: Drop MDIO interrupt registers from ethtools dump

Andre Przywara <andre.przywara@arm.com>
    net: axienet: Check for DMA mapping errors

Andre Przywara <andre.przywara@arm.com>
    net: axienet: Factor out TX descriptor chain cleanup

Andre Przywara <andre.przywara@arm.com>
    net: axienet: Improve DMA error handling

Andre Przywara <andre.przywara@arm.com>
    net: axienet: Fix DMA descriptor cleanup path

Dan Carpenter <dan.carpenter@linaro.org>
    atm: idt77252: prevent use after free in dequeue_rx()

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Correctly report errors for ethtool rx flows

Claudio Imbrenda <imbrenda@linux.ibm.com>
    s390/uv: Panic for set and remove shared access UVC errors

Alexander Lobakin <aleksander.lobakin@intel.com>
    btrfs: rename bitmap_set_bits() -> btrfs_bitmap_set_bits()

Alexander Lobakin <aleksander.lobakin@intel.com>
    s390/cio: rename bitmap_size() -> idset_bitmap_size()

Al Viro <viro@zeniv.linux.org.uk>
    memcg_write_event_control(): fix a user-triggerable oops

Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
    drm/amdgpu: Actually check flags for all context ops.

Zhen Lei <thunder.leizhen@huawei.com>
    selinux: fix potential counting error in avc_add_xperms_decision()

Al Viro <viro@zeniv.linux.org.uk>
    fix bitmap corruption on close_range() with CLOSE_RANGE_UNSHARE

Alexander Lobakin <aleksander.lobakin@intel.com>
    bitmap: introduce generic optimized bitmap_size()

Zhihao Cheng <chengzhihao1@huawei.com>
    vfs: Don't evict inode under the inode lru traversing context

Mikulas Patocka <mpatocka@redhat.com>
    dm persistent data: fix memory allocation failure

Khazhismel Kumykov <khazhy@google.com>
    dm resume: don't return EINVAL when signalled

Haibo Xu <haibo1.xu@intel.com>
    arm64: ACPI: NUMA: initialize all values of acpi_early_node_map to NUMA_NO_NODE

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix error recovery leading to data corruption on ESE devices

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix Panther point NULL pointer deref at full-speed re-enumeration

Juan José Arboleda <soyjuanarbol@gmail.com>
    ALSA: usb-audio: Support Yamaha P-125 quirk entry

Jann Horn <jannh@google.com>
    fuse: Initialize beyond-EOF page contents before setting uptodate


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/kernel/acpi_numa.c                      |   2 +-
 arch/openrisc/kernel/setup.c                       |   6 +-
 arch/parisc/kernel/irq.c                           |   4 +-
 arch/powerpc/boot/simple_alloc.c                   |   7 +-
 arch/powerpc/sysdev/xics/icp-native.c              |   2 +
 arch/s390/include/asm/uv.h                         |   5 +-
 arch/x86/kernel/process.c                          |   5 +-
 drivers/ata/libata-core.c                          |   3 +
 drivers/atm/idt77252.c                             |   9 +-
 drivers/bluetooth/hci_ldisc.c                      |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c            |   8 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c            |   3 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |   5 +-
 drivers/gpu/drm/lima/lima_gp.c                     |  12 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.h            |  14 +-
 drivers/hid/hid-ids.h                              |  10 +-
 drivers/hid/hid-microsoft.c                        |  11 +-
 drivers/hid/wacom_wac.c                            |   4 +-
 drivers/i2c/busses/i2c-riic.c                      |   2 +-
 drivers/infiniband/hw/hfi1/chip.c                  |   5 +-
 drivers/input/input-mt.c                           |   3 +
 drivers/irqchip/irq-gic-v3-its.c                   |   2 -
 drivers/md/dm-clone-metadata.c                     |   5 -
 drivers/md/dm-ioctl.c                              |  22 +-
 drivers/md/dm-mpath.c                              |   9 +-
 drivers/md/dm-path-selector.h                      |   2 +-
 drivers/md/dm-queue-length.c                       |   2 +-
 drivers/md/dm-rq.c                                 |   4 -
 drivers/md/dm-service-time.c                       |   2 +-
 drivers/md/dm.c                                    |  67 ++--
 drivers/md/md.c                                    |   5 -
 drivers/md/persistent-data/dm-space-map-metadata.c |   4 +-
 drivers/media/pci/cx23885/cx23885-video.c          |   8 +
 drivers/media/pci/solo6x10/solo6x10-offsets.h      |  10 +-
 drivers/media/radio/radio-isa.c                    |   2 +-
 drivers/media/usb/uvc/uvc_video.c                  |  10 +-
 drivers/mmc/core/mmc_test.c                        |   9 +-
 drivers/mmc/host/dw_mmc.c                          |   8 +
 drivers/net/dsa/mv88e6xxx/Makefile                 |   4 +
 drivers/net/dsa/mv88e6xxx/global1.h                |   1 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c            |  87 +++++-
 drivers/net/dsa/mv88e6xxx/global2.c                |  13 +
 drivers/net/dsa/mv88e6xxx/global2.h                |  25 +-
 drivers/net/dsa/mv88e6xxx/trace.c                  |   6 +
 drivers/net/dsa/mv88e6xxx/trace.h                  |  66 ++++
 drivers/net/dsa/vitesse-vsc73xx-core.c             |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |   3 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   3 +
 drivers/net/ethernet/i825xx/sun3_82586.c           |   2 +-
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |   2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |  34 +--
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  | 337 +++++++++++++++------
 drivers/net/gtp.c                                  |   5 +-
 drivers/net/usb/r8152.c                            |  73 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   2 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  32 +-
 drivers/net/wireless/st/cw1200/txrx.c              |   2 +-
 drivers/nfc/pn533/pn533.c                          | 210 ++++++++++++-
 drivers/nfc/pn533/pn533.h                          |  19 +-
 drivers/nvme/host/core.c                           |   5 +-
 drivers/nvme/target/rdma.c                         |  16 +-
 drivers/nvme/target/tcp.c                          |   1 +
 drivers/nvme/target/trace.c                        |   6 +-
 drivers/nvme/target/trace.h                        |  28 +-
 drivers/pinctrl/pinctrl-single.c                   |   2 +
 drivers/s390/block/dasd.c                          |  36 ++-
 drivers/s390/block/dasd_3990_erp.c                 |  10 +-
 drivers/s390/block/dasd_eckd.c                     |  57 ++--
 drivers/s390/block/dasd_int.h                      |   2 +-
 drivers/s390/cio/idset.c                           |  12 +-
 drivers/scsi/aacraid/comminit.c                    |   2 +
 drivers/scsi/lpfc/lpfc_sli.c                       |   2 +-
 drivers/scsi/scsi_transport_spi.c                  |   4 +-
 drivers/soc/qcom/cmd-db.c                          |   2 +-
 drivers/soundwire/stream.c                         |   8 +-
 drivers/ssb/main.c                                 |   2 +-
 drivers/staging/ks7010/ks7010_sdio.c               |   4 +-
 drivers/usb/class/cdc-acm.c                        |   3 +
 drivers/usb/core/sysfs.c                           |   1 +
 drivers/usb/dwc3/core.c                            |  21 ++
 drivers/usb/dwc3/dwc3-omap.c                       |   4 +-
 drivers/usb/dwc3/dwc3-st.c                         |  16 +-
 drivers/usb/gadget/udc/fsl_udc_core.c              |   2 +-
 drivers/usb/host/xhci.c                            |   8 +-
 drivers/usb/serial/option.c                        |   5 +
 drivers/video/fbdev/offb.c                         |   3 +-
 fs/binfmt_elf_fdpic.c                              |   2 +-
 fs/binfmt_misc.c                                   | 216 ++++++++++---
 fs/btrfs/delayed-inode.c                           |   2 +-
 fs/btrfs/free-space-cache.c                        |   8 +-
 fs/btrfs/inode.c                                   |   9 +-
 fs/btrfs/qgroup.c                                  |   2 -
 fs/btrfs/send.c                                    |   7 +-
 fs/ext4/extents.c                                  |   3 +-
 fs/ext4/mballoc.c                                  |   3 +
 fs/f2fs/segment.c                                  |   5 +-
 fs/file.c                                          |  28 +-
 fs/fuse/dev.c                                      |   6 +-
 fs/fuse/virtio_fs.c                                |  10 +
 fs/gfs2/inode.c                                    |   2 +-
 fs/inode.c                                         |  39 ++-
 fs/locks.c                                         |   4 +-
 fs/nfs/pnfs.c                                      |   8 +
 fs/quota/dquot.c                                   |   5 +-
 include/linux/bitmap.h                             |  20 +-
 include/linux/blkdev.h                             |   2 +-
 include/linux/cpumask.h                            |   2 +-
 include/linux/device-mapper.h                      |   2 +
 include/linux/fs.h                                 |   5 +
 include/net/busy_poll.h                            |   2 +-
 include/net/kcm.h                                  |   1 +
 ipc/util.c                                         |  16 +-
 kernel/cgroup/cpuset.c                             |  13 +-
 kernel/time/hrtimer.c                              |   2 +
 lib/math/prime_numbers.c                           |   2 -
 mm/memcontrol.c                                    |   7 +-
 net/bluetooth/bnep/core.c                          |   3 +-
 net/bluetooth/hci_core.c                           |  58 ++--
 net/bluetooth/mgmt.c                               |   4 +
 net/core/ethtool.c                                 |   3 +
 net/core/net-sysfs.c                               |   2 +-
 net/ipv6/ip6_output.c                              |   2 +
 net/iucv/iucv.c                                    |   3 +-
 net/kcm/kcmsock.c                                  |   4 +
 net/netfilter/nft_counter.c                        |   5 +
 net/rds/recv.c                                     |  13 +-
 net/sched/sch_netem.c                              |  47 +--
 security/selinux/avc.c                             |   2 +-
 sound/core/timer.c                                 |   2 +-
 sound/pci/hda/patch_realtek.c                      |   1 -
 sound/usb/quirks-table.h                           |   1 +
 tools/include/linux/align.h                        |  12 +
 tools/include/linux/bitmap.h                       |   8 +-
 tools/testing/selftests/tc-testing/tdc.py          |   1 -
 135 files changed, 1506 insertions(+), 586 deletions(-)


