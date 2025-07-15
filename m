Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9036623ABAF;
	Tue, 15 Jul 2025 13:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585799; cv=none; b=cIuRIBk9Y+DCCRQp2ekB/uE+1N5loEiZgZDl/epCPcyKGaBthdETgWoG7644FlxH3qpzPMCpRN8BJLLCvc5xGT40LDwuWDjHOznp0mMbdsTms/ENxbvyMFZ0BsXXXxh6TD562F75Pmwr6l4IWDz/8hk1aXif0YQ9BS0DHAWSIG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585799; c=relaxed/simple;
	bh=ung99prBxLOFu/9DpaWaBvlSOVuVYyGltylA1FpBsaI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iHHGAnJn4T4vQC95u+uyVMPnVSpiZ+x6YrsMi/RaUmMZbEZvzKZyXyYTQCY1IuBl+SCpCAtPfESC2AfuvmBDUovPuAdnfEBGeix8884RnxWnGs1Xta0Bc9QJ6OaLk043abGs4D5LjPiVgj7mJHQR+mB47vaD+Ynv2EypPrqY5bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NCtI3Z/S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NCtI3Z/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC483C4CEE3;
	Tue, 15 Jul 2025 13:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585798;
	bh=ung99prBxLOFu/9DpaWaBvlSOVuVYyGltylA1FpBsaI=;
	h=From:To:Cc:Subject:Date:From;
	b=NCtI3Z/SeFwuTL6pKpmfF2jEcKm+lC16aYsH8JMvi2GqXucjMipIiCyLG4YCFKQLB
	 51KvVZ3JjUuj84XOnvZCgS4M5YG0WTlqmP4dMrtuaOLdfisk0oa/A/VI9L54szw6GD
	 kj/DvKVl5p2bcTfXtGegmq1icSVCRAESLHomvR8E=
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
Subject: [PATCH 6.6 000/109] 6.6.99-rc1 review
Date: Tue, 15 Jul 2025 15:12:16 +0200
Message-ID: <20250715130758.864940641@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.99-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.99-rc1
X-KernelTest-Deadline: 2025-07-17T13:08+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.99 release.
There are 109 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.99-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.99-rc1

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix potential use-after-free in oplock/lease break ack

Yeoreum Yun <yeoreum.yun@arm.com>
    kasan: remove kasan_find_vm_area() to prevent possible deadlock

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix potential race in cifs_put_tcon()

Willem de Bruijn <willemb@google.com>
    selftests/bpf: adapt one more case in test_lru_map to the new target_free

Hans de Goede <hdegoede@redhat.com>
    Input: atkbd - do not skip atkbd_deactivate() when skipping ATKBD_CMD_GETID

Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
    HID: quirks: Add quirk for 2 Chicony Electronics HP 5MP Cameras

Zhang Heng <zhangheng@kylinos.cn>
    HID: Add IGNORE quirk for SMARTLINKTECHNOLOGY

Willem de Bruijn <willemb@google.com>
    bpf: Adjust free target to avoid global starvation of LRU map

Nicolas Pitre <npitre@baylibre.com>
    vt: add missing notification when switching back to text mode

Filipe Manana <fdmanana@suse.com>
    btrfs: fix assertion when building free space tree

Long Li <longli@microsoft.com>
    net: mana: Record doorbell physical address in PF mode

Akira Inoue <niyarium@gmail.com>
    HID: lenovo: Add support for ThinkPad X1 Tablet Thin Keyboard Gen2

Xiaowei Li <xiaowei.li@simcom.com>
    net: usb: qmi_wwan: add SIMCom 8230C composition

Yasmin Fitzgerald <sunoflife1.git@gmail.com>
    ALSA: hda/realtek - Enable mute LED on HP Pavilion Laptop 15-eg100

Yuzuru10 <yuzuru_10@proton.me>
    ASoC: amd: yc: add quirk for Acer Nitro ANV15-41 internal mic

Fengnan Chang <changfengnan@bytedance.com>
    io_uring: make fallocate be hashed work

Tiwei Bie <tiwei.btw@antgroup.com>
    um: vector: Reduce stack usage in vector_eth_configure()

Thomas Fourier <fourier.thomas@gmail.com>
    atm: idt77252: Add missing `dma_map_error()`

Ronnie Sahlberg <rsahlberg@whamcloud.com>
    ublk: sanity check add_dev input for underflow

Somnath Kotur <somnath.kotur@broadcom.com>
    bnxt_en: Set DMA unmap len correctly for XDP_REDIRECT

Shravya KN <shravya.k-n@broadcom.com>
    bnxt_en: Fix DCB ETS validation

Alok Tiwari <alok.a.tiwari@oracle.com>
    net: ll_temac: Fix missing tx_pending check in ethtools_set_ringparam()

Sean Nyekjaer <sean@geanix.com>
    can: m_can: m_can_handle_lost_msg(): downgrade msg lost in rx message to debug level

Oleksij Rempel <o.rempel@pengutronix.de>
    net: phy: microchip: limit 100M workaround to link-down events on LAN88xx

Mingming Cao <mmc@linux.ibm.com>
    ibmvnic: Fix hardcoded NUM_RX_STATS/NUM_TX_STATS with dynamic sizeof

Kito Xu <veritas501@foxmail.com>
    net: appletalk: Fix device refcount leak in atrtr_create()

Eric Dumazet <edumazet@google.com>
    netfilter: flowtable: account for Ethernet header in nf_flow_pppoe_proto()

Zheng Qixing <zhengqixing@huawei.com>
    nbd: fix uaf in nbd_genl_connect() error path

Nigel Croxon <ncroxon@redhat.com>
    raid10: cleanup memleak at raid10_make_request

Wang Jinchao <wangjinchao600@gmail.com>
    md/raid1: Fix stack memory use after return in raid1_reshape

Mikko Perttunen <mperttunen@nvidia.com>
    drm/tegra: nvdec: Fix dma_alloc_coherent error check

Daniil Dulov <d.dulov@aladdin.ru>
    wifi: zd1211rw: Fix potential NULL pointer dereference in zd_mac_tx_to_dev()

Shyam Prasad N <sprasad@microsoft.com>
    cifs: all initializations for tcon should happen in tcon_info_alloc

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix DFS interlink failover

Paulo Alcantara <pc@manguebit.com>
    smb: client: avoid unnecessary reconnects when refreshing referrals

Kuen-Han Tsai <khtsai@google.com>
    usb: dwc3: Abort suspend on soft disconnect failure

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fix issue with CV Bad Descriptor test

Lee Jones <lee@kernel.org>
    usb: cdnsp: Replace snprintf() with the safer scnprintf() variant

Pawel Laszczak <pawell@cadence.com>
    usb:cdnsp: remove TRB_FLUSH_ENDPOINT command

Filipe Manana <fdmanana@suse.com>
    btrfs: fix inode lookup error handling during log replay

Filipe Manana <fdmanana@suse.com>
    btrfs: return a btrfs_inode from btrfs_iget_logging()

Filipe Manana <fdmanana@suse.com>
    btrfs: remove redundant root argument from fixup_inode_link_count()

Filipe Manana <fdmanana@suse.com>
    btrfs: remove redundant root argument from btrfs_update_inode_fallback()

Filipe Manana <fdmanana@suse.com>
    btrfs: remove noinline from btrfs_update_inode()

Jakub Kicinski <kuba@kernel.org>
    netlink: make sure we allow at least one dump skb

Kuniyuki Iwashima <kuniyu@google.com>
    netlink: Fix rmem check in netlink_broadcast_deliver().

Chao Yu <chao@kernel.org>
    erofs: fix to add missing tracepoint in erofs_read_folio()

Al Viro <viro@zeniv.linux.org.uk>
    ksmbd: fix a mount write count leak in ksmbd_vfs_kern_path_locked()

Stefan Metzmacher <metze@samba.org>
    smb: server: make use of rdma_destroy_qp()

Jann Horn <jannh@google.com>
    x86/mm: Disable hugetlb page table sharing on 32-bit

Mikhail Paulyshka <me@mixaill.net>
    x86/rdrand: Disable RDSEED on AMD Cyan Skillfish

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: mediatek: Ensure to disable clocks in error path

Alexander Gordeev <agordeev@linux.ibm.com>
    mm/vmalloc: leave lazy MMU mode on PTE mapping error

Florian Fainelli <florian.fainelli@broadcom.com>
    scripts/gdb: fix interrupts.py after maple tree conversion

Florian Fainelli <florian.fainelli@broadcom.com>
    scripts/gdb: de-reference per-CPU MCE interrupts

Florian Fainelli <florian.fainelli@broadcom.com>
    scripts/gdb: fix interrupts display after MCP on x86

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm: fix the inaccurate memory statistics issue for users

Wei Yang <richard.weiyang@gmail.com>
    maple_tree: fix mt_destroy_walk() on root leaf node

Achill Gilgenast <fossdd@pwned.life>
    kallsyms: fix build without execinfo

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "ACPI: battery: negate current when discharging"

Thomas Zimmermann <tzimmermann@suse.de>
    drm/framebuffer: Acquire internal references on GEM handles

Kuen-Han Tsai <khtsai@google.com>
    Revert "usb: gadget: u_serial: Add null pointer check in gs_start_io"

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: u_serial: Fix race condition in TTY wakeup

Simona Vetter <simona.vetter@ffwll.ch>
    drm/gem: Fix race in drm_gem_handle_create_tail()

Christian König <christian.koenig@amd.com>
    drm/ttm: fix error handling in ttm_buffer_object_transfer

Matthew Brost <matthew.brost@intel.com>
    drm/sched: Increment job count before swapping tail spsc queue

Thomas Zimmermann <tzimmermann@suse.de>
    drm/gem: Acquire references on GEM handles for framebuffers

Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
    wifi: prevent A-MSDU attacks in mesh networks

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    pinctrl: qcom: msm: mark certain pins as invalid for interrupts

Håkon Bugge <haakon.bugge@oracle.com>
    md/md-bitmap: fix GPF in bitmap_get_stats()

Guillaume Nault <gnault@redhat.com>
    gre: Fix IPv6 multicast route creation.

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Reject SEV{-ES} intra host migration if vCPU creation is in-flight

David Woodhouse <dwmw@amazon.co.uk>
    KVM: x86/xen: Allow 'out of range' event channel ports in IRQ routing table.

JP Kobryn <inwardvessel@gmail.com>
    x86/mce: Make sure CMCI banks are cleared during shutdown on Intel

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/mce: Don't remove sysfs if thresholding sysfs init fails

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/mce/amd: Fix threshold limit reset

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/mce/amd: Add default names for MCA banks and blocks

Dan Carpenter <dan.carpenter@linaro.org>
    ipmi:msghandler: Fix potential memory corruption in ipmi_create_user()

David Howells <dhowells@redhat.com>
    rxrpc: Fix oops due to non-existence of prealloc backlog struct

Christian Eggers <ceggers@arri.de>
    Bluetooth: HCI: Set extended advertising data synchronously

Leo Yan <leo.yan@arm.com>
    perf: build: Setup PKG_CONFIG_LIBDIR for cross compilation

Liam R. Howlett <Liam.Howlett@oracle.com>
    maple_tree: fix MA_STATE_PREALLOC flag in mas_preallocate()

David Howells <dhowells@redhat.com>
    rxrpc: Fix bug due to prealloc collision

Victor Nogueira <victor@mojatatu.com>
    net/sched: Abort __tc_modify_qdisc if parent class does not exist

Yue Haibing <yuehaibing@huawei.com>
    atm: clip: Fix NULL pointer dereference in vcc_sendmsg()

Kuniyuki Iwashima <kuniyu@google.com>
    atm: clip: Fix infinite recursive call of clip_push().

Kuniyuki Iwashima <kuniyu@google.com>
    atm: clip: Fix memory leak of struct clip_vcc.

Kuniyuki Iwashima <kuniyu@google.com>
    atm: clip: Fix potential null-ptr-deref in to_atmarpd().

Oleksij Rempel <o.rempel@pengutronix.de>
    net: phy: smsc: Fix link failure in forced mode with Auto-MDIX

Oleksij Rempel <o.rempel@pengutronix.de>
    net: phy: smsc: Force predictable MDI-X state on LAN87xx

Oleksij Rempel <o.rempel@pengutronix.de>
    net: phy: smsc: Fix Auto-MDIX configuration when disabled by strap

EricChan <chenchuangyu@xiaomi.com>
    net: stmmac: Fix interrupt handling for level-triggered mode in DWC_XGMAC2

Michal Luczaj <mhal@rbox.co>
    vsock: Fix IOCTL_VM_SOCKETS_GET_LOCAL_CID to check also `transport_local`

Michal Luczaj <mhal@rbox.co>
    vsock: Fix transport_* TOCTOU

Michal Luczaj <mhal@rbox.co>
    vsock: Fix transport_{g2h,h2g} TOCTOU

Jiayuan Chen <jiayuan.chen@linux.dev>
    tcp: Correct signedness in skb remaining space calculation

Kuniyuki Iwashima <kuniyu@google.com>
    tipc: Fix use-after-free in tipc_conn_close().

Stefano Garzarella <sgarzare@redhat.com>
    vsock: fix `vsock_proto` declaration

Kuniyuki Iwashima <kuniyu@google.com>
    netlink: Fix wraparounds of sk->sk_rmem_alloc.

Al Viro <viro@zeniv.linux.org.uk>
    fix proc_sys_compare() handling of in-lookup dentries

Mario Limonciello <mario.limonciello@amd.com>
    pinctrl: amd: Clear GPIO debounce for suspend

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Fix not marking Broadcast Sink BIS as connected

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix not disabling advertising instance

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: probe() should fail if the device ID is not recognized

Peter Zijlstra <peterz@infradead.org>
    perf: Revert to requiring CAP_SYS_ADMIN for uprobes

Luo Gengkun <luogengkun@huaweicloud.com>
    perf/core: Fix the WARN_ON_ONCE is out of lock protected region

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_asrc: use internal measured ratio for non-ideal ratio mode

Kaustabh Chakraborty <kauschluss@disroot.org>
    drm/exynos: exynos7_drm_decon: add vblank check in IRQ handling

Linus Torvalds <torvalds@linux-foundation.org>
    eventpoll: don't decrement ep refcount while still holding the ep mutex


-------------

Diffstat:

 Documentation/bpf/map_hash.rst                     |   8 +-
 Documentation/bpf/map_lru_hash_update.dot          |   6 +-
 Makefile                                           |   4 +-
 arch/um/drivers/vector_kern.c                      |  42 +--
 arch/x86/Kconfig                                   |   2 +-
 arch/x86/include/asm/msr-index.h                   |   1 +
 arch/x86/kernel/cpu/amd.c                          |   7 +
 arch/x86/kernel/cpu/mce/amd.c                      |  28 +-
 arch/x86/kernel/cpu/mce/core.c                     |   8 +-
 arch/x86/kernel/cpu/mce/intel.c                    |   1 +
 arch/x86/kvm/svm/sev.c                             |   4 +
 arch/x86/kvm/xen.c                                 |  15 +-
 drivers/acpi/battery.c                             |  19 +-
 drivers/atm/idt77252.c                             |   5 +
 drivers/block/nbd.c                                |   6 +-
 drivers/block/ublk_drv.c                           |   3 +-
 drivers/char/ipmi/ipmi_msghandler.c                |   3 +-
 drivers/gpu/drm/drm_framebuffer.c                  |  31 +-
 drivers/gpu/drm/drm_gem.c                          |  74 ++++-
 drivers/gpu/drm/drm_internal.h                     |   2 +
 drivers/gpu/drm/exynos/exynos7_drm_decon.c         |   4 +
 drivers/gpu/drm/tegra/nvdec.c                      |   6 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |  13 +-
 drivers/hid/hid-ids.h                              |   6 +
 drivers/hid/hid-lenovo.c                           |   8 +
 drivers/hid/hid-multitouch.c                       |   8 +-
 drivers/hid/hid-quirks.c                           |   3 +
 drivers/input/keyboard/atkbd.c                     |   3 +-
 drivers/md/md-bitmap.c                             |   3 +-
 drivers/md/raid1.c                                 |   1 +
 drivers/md/raid10.c                                |  10 +-
 drivers/net/can/m_can/m_can.c                      |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c      |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   2 +-
 drivers/net/ethernet/ibm/ibmvnic.h                 |   8 +-
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |   3 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |  24 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c        |   2 +-
 drivers/net/phy/microchip.c                        |   2 +-
 drivers/net/phy/smsc.c                             |  57 +++-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c       |   6 +-
 drivers/pinctrl/pinctrl-amd.c                      |  11 +
 drivers/pinctrl/qcom/pinctrl-msm.c                 |  20 ++
 drivers/pwm/pwm-mediatek.c                         |  13 +-
 drivers/tty/vt/vt.c                                |   1 +
 drivers/usb/cdns3/cdnsp-debug.h                    | 358 ++++++++++-----------
 drivers/usb/cdns3/cdnsp-ep0.c                      |  18 +-
 drivers/usb/cdns3/cdnsp-gadget.c                   |   6 +-
 drivers/usb/cdns3/cdnsp-gadget.h                   |  11 +-
 drivers/usb/cdns3/cdnsp-ring.c                     |  27 +-
 drivers/usb/dwc3/core.c                            |   9 +-
 drivers/usb/dwc3/gadget.c                          |  22 +-
 drivers/usb/gadget/function/u_serial.c             |  12 +-
 fs/btrfs/btrfs_inode.h                             |   2 +-
 fs/btrfs/free-space-tree.c                         |  16 +-
 fs/btrfs/inode.c                                   |  18 +-
 fs/btrfs/transaction.c                             |   2 +-
 fs/btrfs/tree-log.c                                | 331 +++++++++++--------
 fs/erofs/data.c                                    |   2 +
 fs/eventpoll.c                                     |  12 +-
 fs/proc/inode.c                                    |   2 +-
 fs/proc/proc_sysctl.c                              |  18 +-
 fs/proc/task_mmu.c                                 |  14 +-
 fs/smb/client/cifsglob.h                           |   3 +
 fs/smb/client/cifsproto.h                          |  13 +-
 fs/smb/client/connect.c                            |  47 ++-
 fs/smb/client/dfs.c                                |  73 ++---
 fs/smb/client/dfs.h                                |  42 ++-
 fs/smb/client/dfs_cache.c                          | 198 +++++++-----
 fs/smb/client/fs_context.h                         |   1 +
 fs/smb/client/misc.c                               |   9 +
 fs/smb/client/namespace.c                          |   2 +-
 fs/smb/server/smb2pdu.c                            |  29 +-
 fs/smb/server/transport_rdma.c                     |   5 +-
 fs/smb/server/vfs.c                                |   1 +
 include/drm/drm_file.h                             |   3 +
 include/drm/drm_framebuffer.h                      |   7 +
 include/drm/spsc_queue.h                           |   4 +-
 include/linux/mm.h                                 |   5 +
 include/net/af_vsock.h                             |   2 +-
 include/net/netfilter/nf_flow_table.h              |   2 +-
 io_uring/opdef.c                                   |   1 +
 kernel/bpf/bpf_lru_list.c                          |   9 +-
 kernel/bpf/bpf_lru_list.h                          |   1 +
 kernel/events/core.c                               |   6 +-
 lib/maple_tree.c                                   |  14 +-
 mm/kasan/report.c                                  |  13 +-
 mm/vmalloc.c                                       |  22 +-
 net/appletalk/ddp.c                                |   1 +
 net/atm/clip.c                                     |  64 +++-
 net/bluetooth/hci_event.c                          |  39 +--
 net/bluetooth/hci_sync.c                           | 215 ++++++++-----
 net/ipv4/tcp.c                                     |   2 +-
 net/ipv6/addrconf.c                                |   9 +-
 net/netlink/af_netlink.c                           |  90 +++---
 net/rxrpc/call_accept.c                            |   4 +
 net/sched/sch_api.c                                |  23 +-
 net/tipc/topsrv.c                                  |   2 +
 net/vmw_vsock/af_vsock.c                           |  57 +++-
 net/wireless/util.c                                |  52 ++-
 scripts/gdb/linux/constants.py.in                  |   7 +
 scripts/gdb/linux/interrupts.py                    |  16 +-
 scripts/gdb/linux/mapletree.py                     | 252 +++++++++++++++
 scripts/gdb/linux/xarray.py                        |  28 ++
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/cs35l56-shared.c                  |   2 +-
 sound/soc/fsl/fsl_asrc.c                           |   3 +-
 tools/arch/x86/include/asm/msr-index.h             |   1 +
 tools/build/feature/Makefile                       |  25 +-
 tools/include/linux/kallsyms.h                     |   4 +
 tools/perf/Makefile.perf                           |  27 +-
 tools/testing/selftests/bpf/test_lru_map.c         | 105 +++---
 114 files changed, 1887 insertions(+), 1029 deletions(-)


