Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AAD1C68C;
	Sun,  1 Sep 2024 16:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209430; cv=none; b=OXdu2W2FWwP4Vtoef1CbP2SMFbSQkDQRPp08MiRrAQUYmvKoUBYFZvfmhmGvZvIR+dR6zlsqVpH6EFUqw9gi6YWQ5z9cDh3UlF7o90v8dy6hVoa63mr4w5Jik23V08JX/SWU7MNZ+8jB9YvILxsCCkUlHyY+BCQS1PwvTrvwvWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209430; c=relaxed/simple;
	bh=kKpiAjpTL9OmYbIpa6NLfK2EcoQIEoMRgr0vqrrygSs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OddiBt/hCzaQ2xiqGSDceixtSUwwbHSntV5QsxelY9oJ23CHPjLLoO0xpxh1rAeFrQ2PmHbdyrLVKruCSxyWQ/fhbL2a0HQTf/8iJRye2d5KQh0tyLkLuksoqq2oPTJrpJ2E+BXF5Zv8bub8cw3Jxpw5I8Hx6XIl+uOWx4AHbK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9FCERsl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9FCERsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48001C4CEC3;
	Sun,  1 Sep 2024 16:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209430;
	bh=kKpiAjpTL9OmYbIpa6NLfK2EcoQIEoMRgr0vqrrygSs=;
	h=From:To:Cc:Subject:Date:From;
	b=E9FCERsl0f/cRUukoKoodGOoq6rGsAX+GH12kga1aFGSqiN/audR5icGjEiiKFZKV
	 cF5GdrSDeXnWMAnEtHtMLlUSv5VeNYfc3K6zwaqjWn7nddjA89X+xPK9WCF3eZwTAq
	 64CS6HqAtJCic01ylWUoPbU1mBnVSJUH0bbHjTlM=
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
Subject: [PATCH 5.10 000/151] 5.10.225-rc1 review
Date: Sun,  1 Sep 2024 18:16:00 +0200
Message-ID: <20240901160814.090297276@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.225-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.225-rc1
X-KernelTest-Deadline: 2024-09-03T16:08+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.225 release.
There are 151 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.225-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.225-rc1

Guenter Roeck <linux@roeck-us.net>
    apparmor: fix policy_unpack_test on big endian systems

Ben Hutchings <benh@debian.org>
    scsi: aacraid: Fix double-free on probe failure

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

Eric Dumazet <edumazet@google.com>
    net: busy-poll: use ktime_get_ns() instead of local_clock()

Cong Wang <cong.wang@bytedance.com>
    gtp: fix a potential NULL pointer dereference

Jamie Bainbridge <jamie.bainbridge@gmail.com>
    ethtool: check device is present when getting link settings

Serge Semin <fancer.lancer@gmail.com>
    dmaengine: dw: Add memory bus width verification

Serge Semin <fancer.lancer@gmail.com>
    dmaengine: dw: Add peripheral bus width verification

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    soundwire: stream: fix programming slave ports for non-continous port maps

Miklos Szeredi <mszeredi@redhat.com>
    ovl: do not fail because of O_NOATIME

Allison Henderson <allison.henderson@oracle.com>
    net:rds: Fix possible deadlock in rds_message_put

Chen Ridong <chenridong@huawei.com>
    cgroup/cpuset: Prevent UAF in proc_cpuset_show()

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Fix null pointer dereference on error

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "Input: ioc3kbd - convert to platform remove callback returning void"

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix integer overflow calculating timestamp

Alex Deucher <alexander.deucher@amd.com>
    drm/amdkfd: don't allow mapping the MMIO HDP page with large pages

Rafael Aquini <aquini@redhat.com>
    ipc: replace costly bailout check in sysvipc_find_ipc()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: sched: check both backup in retrans

Sascha Hauer <s.hauer@pengutronix.de>
    wifi: mwifiex: duplicate static structs used in driver instances

Ma Ke <make24@iscas.ac.cn>
    pinctrl: single: fix potential NULL dereference in pcs_get_function()

Huang-Huang Bao <i@eh5.me>
    pinctrl: rockchip: correct RK3328 iomux width flag for GPIO2-B pins

Sami Tolvanen <samitolvanen@google.com>
    KVM: arm64: Don't use cbz/adr with external symbols

Jesse Zhang <jesse.zhang@amd.com>
    drm/amdgpu: Using uninitialized value *size when calling amdgpu_vce_cs_reloc

Alexander Lobakin <aleksander.lobakin@intel.com>
    tools: move alignment-related macros to new <linux/align.h>

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Input: MT - limit max slots

Lee, Chun-Yi <joeyli.kernel@gmail.com>
    Bluetooth: hci_ldisc: check HCI_UART_PROTO_READY flag in HCIUARTGETPROTO

Kuniyuki Iwashima <kuniyu@amazon.com>
    nfsd: Don't call freezable_schedule_timeout() after each successful page allocation in svc_alloc_arg().

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Relax start tick time check for slave timer elements

Alex Hung <alex.hung@amd.com>
    Revert "drm/amd/display: Validate hw_points_num before using it"

Ben Whitten <ben.whitten@gmail.com>
    mmc: dw_mmc: allow biu and ciu clocks to defer

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Make ICC_*SGI*_EL1 undef in the absence of a vGICv3

Nikolay Kuratov <kniv@yandex-team.ru>
    cxgb4: add forgotten u64 ivlan cast before shift

Siarhei Vishniakou <svv@google.com>
    HID: microsoft: Add rumble support to latest xbox controllers

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Defer calculation of resolution until resolution_code is known

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Loongson64: Set timer mode in cpu-probe

Laurent Vivier <laurent@vivier.eu>
    binfmt_misc: pass binfmt_misc flags to the interpreter

Griffin Kroah-Hartman <griffin@kroah.com>
    Bluetooth: MGMT: Add error handling to pair_device()

Dan Carpenter <dan.carpenter@linaro.org>
    mmc: mmc_test: Fix NULL dereference on allocation failure

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm/msm/dp: reset the link phy params before link training

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: don't play tricks with debug macros

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

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: fix ICE_LAST_OFFSET formula

Nikolay Aleksandrov <razor@blackwall.org>
    bonding: fix xfrm state handling when clearing active slave

Nikolay Aleksandrov <razor@blackwall.org>
    bonding: fix xfrm real_dev null pointer dereference

Nikolay Aleksandrov <razor@blackwall.org>
    bonding: fix null pointer deref in bond_ipsec_offload_ok

Nikolay Aleksandrov <razor@blackwall.org>
    bonding: fix bond_ipsec_offload_ok return type

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    ip6_tunnel: Fix broken GRO

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    netfilter: nft_counter: Synchronize nft_counter_reset() against reader.

Kuniyuki Iwashima <kuniyu@amazon.com>
    kcm: Serialise kcm_sendmsg() for the same socket.

Simon Horman <horms@kernel.org>
    tc-testing: don't access non-existent variable on exception

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SMP: Fix assumption of Central always being Initiator

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix LE quote calculation

Mikulas Patocka <mpatocka@redhat.com>
    dm suspend: return -ERESTARTSYS instead of -EINTR

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

Jian Shen <shenjian15@huawei.com>
    net: hns3: add checking for vf id of mailbox

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: bnep: Fix out-of-bound access

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

Christophe Kerello <christophe.kerello@foss.st.com>
    memory: stm32-fmc2-ebi: check regmap_read return value

Kees Cook <keescook@chromium.org>
    x86: Increase brk randomness entropy for 64-bit systems

Li Nan <linan122@huawei.com>
    md: clean up invalid BUG_ON in md_ioctl

Eric Dumazet <edumazet@google.com>
    netlink: hold nlk->cb_mutex longer in __netlink_dump_start()

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

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: qcom: venus: fix incorrect return value

Christian Brauner <christian.brauner@ubuntu.com>
    binfmt_misc: cleanup on filesystem umount

Chengfeng Ye <dg573847474@gmail.com>
    staging: ks7010: disable bh on tx_dev_lock

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Validate hw_points_num before using it

David Lechner <dlechner@baylibre.com>
    staging: iio: resolver: ad2s1210: fix use before initialization

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: radio-isa: use dev_name to fill in bus_info

Heiko Carstens <hca@linux.ibm.com>
    s390/smp,mcck: fix early IPI handling

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rtrs: Fix the problem of variable not initialized fully

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: riic: avoid potential division by zero

Jeff Johnson <quic_jjohnson@quicinc.com>
    wifi: cw1200: Avoid processing an invalid TIM IE

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix BA session teardown race

Rand Deeb <rand.sec96@gmail.com>
    ssb: Fix division by zero issue in ssb_calc_clock_rate

Parsa Poorshikhian <parsa.poorsh@gmail.com>
    ALSA: hda/realtek: Fix noise from speakers on Lenovo IdeaPad 3 15IAU7

Jie Wang <wangjie125@huawei.com>
    net: hns3: fix a deadlock problem when config TC during resetting

Jie Wang <wangjie125@huawei.com>
    net: hns3: fix wrong use of semaphore up

Donald Hunter <donald.hunter@gmail.com>
    netfilter: flowtable: initialise extack before use

Eugene Syromiatnikov <esyr@redhat.com>
    mptcp: correct MPTCP_SUBFLOW_ATTR_SSN_OFFSET reserved size

Pawel Dembicki <paweldembicki@gmail.com>
    net: dsa: vsc73xx: check busy flag in MDIO operations

Pawel Dembicki <paweldembicki@gmail.com>
    net: dsa: vsc73xx: use read_poll_timeout instead delay loop

Pawel Dembicki <paweldembicki@gmail.com>
    net: dsa: vsc73xx: pass value in phy_write operation

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    net: axienet: Fix register defines comment description

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

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/jpeg2: properly set atomics vmid field

Al Viro <viro@zeniv.linux.org.uk>
    memcg_write_event_control(): fix a user-triggerable oops

Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
    drm/amdgpu: Actually check flags for all context ops.

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: add dev extent item checks

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

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Mark XDomain as unplugged when router is removed

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
 arch/arm64/kvm/hyp/entry.S                         |   6 +-
 arch/arm64/kvm/sys_regs.c                          |   6 +
 arch/arm64/kvm/vgic/vgic.h                         |   7 +
 arch/mips/kernel/cpu-probe.c                       |   4 +
 arch/openrisc/kernel/setup.c                       |   6 +-
 arch/parisc/kernel/irq.c                           |   4 +-
 arch/powerpc/boot/simple_alloc.c                   |   7 +-
 arch/powerpc/sysdev/xics/icp-native.c              |   2 +
 arch/s390/include/asm/uv.h                         |   5 +-
 arch/s390/kernel/early.c                           |  12 +-
 arch/s390/kernel/smp.c                             |   4 +-
 arch/x86/kernel/process.c                          |   5 +-
 drivers/ata/libata-core.c                          |   3 +
 drivers/atm/idt77252.c                             |   9 +-
 drivers/bluetooth/hci_ldisc.c                      |   3 +-
 drivers/dma/dw/core.c                              |  89 ++++++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c            |   8 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c             |   4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |   5 +-
 drivers/gpu/drm/lima/lima_gp.c                     |  12 ++
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.h            |  14 +-
 drivers/gpu/drm/msm/dp/dp_ctrl.c                   |   2 +
 drivers/hid/hid-ids.h                              |  10 +-
 drivers/hid/hid-microsoft.c                        |  11 +-
 drivers/hid/wacom_wac.c                            |   4 +-
 drivers/i2c/busses/i2c-riic.c                      |   2 +-
 drivers/infiniband/hw/hfi1/chip.c                  |   5 +-
 drivers/infiniband/ulp/rtrs/rtrs.c                 |   2 +-
 drivers/input/input-mt.c                           |   3 +
 drivers/input/serio/ioc3kbd.c                      |   6 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   2 -
 drivers/md/dm-clone-metadata.c                     |   5 -
 drivers/md/dm-ioctl.c                              |  22 ++-
 drivers/md/dm.c                                    |   4 +-
 drivers/md/md.c                                    |   5 -
 drivers/md/persistent-data/dm-space-map-metadata.c |   4 +-
 drivers/media/pci/cx23885/cx23885-video.c          |   8 +
 drivers/media/pci/solo6x10/solo6x10-offsets.h      |  10 +-
 drivers/media/platform/qcom/venus/pm_helpers.c     |   2 +-
 drivers/media/radio/radio-isa.c                    |   2 +-
 drivers/media/usb/uvc/uvc_video.c                  |  10 +-
 drivers/memory/stm32-fmc2-ebi.c                    | 122 ++++++++----
 drivers/mmc/core/mmc_test.c                        |   9 +-
 drivers/mmc/host/dw_mmc.c                          |   8 +
 drivers/net/bonding/bond_main.c                    |  21 +-
 drivers/net/bonding/bond_options.c                 |   2 +-
 drivers/net/dsa/mv88e6xxx/Makefile                 |   4 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c            |  82 ++++++--
 drivers/net/dsa/mv88e6xxx/trace.c                  |   6 +
 drivers/net/dsa/mv88e6xxx/trace.h                  |  66 +++++++
 drivers/net/dsa/vitesse-vsc73xx-core.c             |  69 +++++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |   3 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   3 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   4 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   7 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   4 +-
 drivers/net/ethernet/i825xx/sun3_82586.c           |   2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   2 +-
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |   2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |  17 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  25 +--
 drivers/net/gtp.c                                  |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   2 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  32 ++-
 drivers/net/wireless/st/cw1200/txrx.c              |   2 +-
 drivers/nfc/pn533/pn533.c                          |   5 +
 drivers/nvme/target/rdma.c                         |  16 +-
 drivers/nvme/target/tcp.c                          |   1 +
 drivers/nvme/target/trace.c                        |   6 +-
 drivers/nvme/target/trace.h                        |  28 +--
 drivers/pinctrl/pinctrl-rockchip.c                 |   2 +-
 drivers/pinctrl/pinctrl-single.c                   |   2 +
 drivers/s390/block/dasd.c                          |  36 ++--
 drivers/s390/block/dasd_3990_erp.c                 |  10 +-
 drivers/s390/block/dasd_eckd.c                     |  57 +++---
 drivers/s390/block/dasd_int.h                      |   2 +-
 drivers/s390/cio/idset.c                           |  12 +-
 drivers/scsi/aacraid/comminit.c                    |   2 +
 drivers/scsi/lpfc/lpfc_sli.c                       |   2 +-
 drivers/scsi/scsi_transport_spi.c                  |   4 +-
 drivers/soc/qcom/cmd-db.c                          |   2 +-
 drivers/soundwire/stream.c                         |   8 +-
 drivers/ssb/main.c                                 |   2 +-
 drivers/staging/iio/resolver/ad2s1210.c            |   7 +-
 drivers/staging/ks7010/ks7010_sdio.c               |   4 +-
 drivers/thunderbolt/switch.c                       |   1 +
 drivers/usb/class/cdc-acm.c                        |   3 +
 drivers/usb/core/sysfs.c                           |   1 +
 drivers/usb/dwc3/core.c                            |  21 ++
 drivers/usb/dwc3/dwc3-omap.c                       |   4 +-
 drivers/usb/dwc3/dwc3-st.c                         |  16 +-
 drivers/usb/gadget/udc/fsl_udc_core.c              |   2 +-
 drivers/usb/host/xhci.c                            |   8 +-
 drivers/usb/serial/option.c                        |   5 +
 drivers/video/fbdev/offb.c                         |   3 +-
 fs/binfmt_elf.c                                    |   5 +-
 fs/binfmt_elf_fdpic.c                              |   7 +-
 fs/binfmt_misc.c                                   | 220 ++++++++++++++++-----
 fs/btrfs/delayed-inode.c                           |   2 +-
 fs/btrfs/free-space-cache.c                        |   8 +-
 fs/btrfs/inode.c                                   |   9 +-
 fs/btrfs/qgroup.c                                  |   2 -
 fs/btrfs/send.c                                    |   7 +-
 fs/btrfs/tree-checker.c                            |  69 +++++++
 fs/ext4/extents.c                                  |   3 +-
 fs/ext4/mballoc.c                                  |   3 +
 fs/f2fs/segment.c                                  |   5 +-
 fs/file.c                                          |  28 ++-
 fs/fuse/dev.c                                      |   6 +-
 fs/fuse/virtio_fs.c                                |  10 +
 fs/gfs2/inode.c                                    |   2 +-
 fs/inode.c                                         |  39 +++-
 fs/nfs/pnfs.c                                      |   8 +
 fs/overlayfs/file.c                                |  11 +-
 fs/quota/dquot.c                                   |   5 +-
 include/linux/binfmts.h                            |   4 +
 include/linux/bitmap.h                             |  20 +-
 include/linux/blkdev.h                             |   2 +-
 include/linux/cpumask.h                            |   2 +-
 include/linux/fs.h                                 |   5 +
 include/net/busy_poll.h                            |   2 +-
 include/net/kcm.h                                  |   1 +
 include/uapi/linux/binfmts.h                       |   4 +
 ipc/util.c                                         |  16 +-
 kernel/cgroup/cpuset.c                             |  13 +-
 kernel/time/hrtimer.c                              |   2 +
 lib/math/prime_numbers.c                           |   2 -
 mm/memcontrol.c                                    |   7 +-
 net/bluetooth/bnep/core.c                          |   3 +-
 net/bluetooth/hci_core.c                           |  19 +-
 net/bluetooth/mgmt.c                               |   4 +
 net/bluetooth/smp.c                                | 146 +++++++-------
 net/core/net-sysfs.c                               |   2 +-
 net/ethtool/ioctl.c                                |   3 +
 net/ipv6/ip6_output.c                              |   2 +
 net/ipv6/ip6_tunnel.c                              |  12 +-
 net/iucv/iucv.c                                    |   3 +-
 net/kcm/kcmsock.c                                  |   4 +
 net/mac80211/agg-tx.c                              |   6 +-
 net/mac80211/driver-ops.c                          |   3 -
 net/mac80211/sta_info.c                            |  14 ++
 net/mptcp/diag.c                                   |   2 +-
 net/mptcp/protocol.c                               |   2 +-
 net/netfilter/nf_flow_table_offload.c              |   2 +-
 net/netfilter/nft_counter.c                        |   5 +
 net/netlink/af_netlink.c                           |  13 +-
 net/rds/recv.c                                     |  13 +-
 net/sched/sch_netem.c                              |  47 +++--
 net/sunrpc/svc_xprt.c                              |   2 +-
 security/apparmor/policy_unpack_test.c             |   6 +-
 security/selinux/avc.c                             |   2 +-
 sound/core/timer.c                                 |   2 +-
 sound/pci/hda/patch_realtek.c                      |   1 -
 sound/usb/quirks-table.h                           |   1 +
 tools/include/linux/align.h                        |  12 ++
 tools/include/linux/bitmap.h                       |   9 +-
 tools/testing/selftests/core/close_range_test.c    |  35 ++++
 tools/testing/selftests/tc-testing/tdc.py          |   1 -
 161 files changed, 1422 insertions(+), 597 deletions(-)


