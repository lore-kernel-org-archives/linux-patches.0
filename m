Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A989E469851;
	Tue, 25 Aug 2026 13:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666231; cv=none; b=ai1y6Nsf9ir0aBhhMC6b2unfMTNDwghKW0uKrJ4BT00srYcCbHjQOBjIEYsJ4/bdMzjR0/npQGt+d9REzw7AxKqkidkGDpEUlStCOlmKWKP4KAemIMT5rH3hYjPikVL478h+Vy7K6k8szwuogrt9RZY9DML7dOMctMjBvdE3tKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666231; c=relaxed/simple;
	bh=GEz2mIzEJr9ZxmwePGJhzbdKfY5bd1Ku0XL7n+SAhBE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Y/DpDGctnRbY7KC/sRuVQA9p7+XsLIX78SW0wcbqS0NobNJc9LdwixyBXFE43GENIr8QXQxktA6MerVm4OnlQtLYKZPeO/OlcTVBsjeDA+jVkm0qcHOzAcDSXkGIkyzz1P/NTre3l4hQ1RhJ4SnlugpyGuoESP8OAIVldSYOVTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GK4QO7+G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GK4QO7+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EB21F000E9;
	Tue, 25 Aug 2026 13:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666229;
	bh=K9RlBzyYStn+ZM1VuV5BySYrweVqS0zVWpR9Jf6/myY=;
	h=From:To:Cc:Subject:Date;
	b=GK4QO7+Goboidu6u8rSNrfn8AxJFwWY4lnVWJEuiL09HZp7yH6oxguqHhfqUXBaO4
	 nJnMW2AzJCzvr5SWf3eApHid15WnnEpY8cPH8mJLVkdpYlP2deKjT6zjWwh7H9tKw1
	 t3cS7Sb+xzbPD5BEbAk+CqXoj7fHu4qQI94wJrO4=
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
Subject: [PATCH 5.15 00/76] 5.15.218-rc1 review
Date: Tue, 25 Aug 2026 15:25:53 +0200
Message-ID: <20260825132541.568214149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.218-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.218-rc1
X-KernelTest-Deadline: 2026-08-27T13:25+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.218 release.
There are 76 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.218-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.218-rc1

Michael Bommarito <michael.bommarito@gmail.com>
    HID: hyperv: validate initial device info bounds

Haoxiang Li <haoxiang_li2024@163.com>
    HID: sensor: custom: Fix use-after-free in enable_sensor

Jann Horn <jannh@google.com>
    HID: core: fix number/pointer type confusion on long items

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: fix timer drain order, wakeup handling and tx_gen ordering

Oliver Hartkopp <socketcan@hartkopp.net>
    can: use skb hash instead of private variable in headroom

Qing Luo <luoqing@kylinos.cn>
    mptcp: pm: fix data race in add_addr timer callback

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ADD_ADDR rtx: free sk if last

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ADD_ADDR rtx: always decrease sk refcount

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ADD_ADDR rtx: allow ID 0

Donglin Lyu <DongLin_Lyu@outlook.com>
    Input: atkbd - skip deactivate for HONOR ZQC-P

Cryolitia PukNgae <cryolitia.pukngae@linux.dev>
    Input: atkbd - skip deactivate for HONOR FMB-P's internal keyboard

Eric Farman <farman@linux.ibm.com>
    s390/vfio_ccw: Free all memory if cp_init() fails

Joanne Koong <joannelkoong@gmail.com>
    iomap: adjust read range correctly for non-block-aligned positions

Sean Christopherson <seanjc@google.com>
    KVM: x86: Retry page fault if MMU reload is pending and root has no sp

Xiang Mei (Microsoft) <xmei5@asu.edu>
    xfrm: fix sk_dst_cache double-free in xfrm_user_policy()

Baul Lee <baul.lee@xbow.com>
    HID: core: fix OOB read of field->usage in hid_set_field()

Lee Jones <lee@kernel.org>
    HID: magicmouse: Prevent out-of-bounds (OOB) read during DOUBLE_REPORT_ID

Jose Villaseñor Montfort <pepemontfort@gmail.com>
    HID: magicmouse: do not keep a stale msc->input if no input is claimed

Sean Christopherson <seanjc@google.com>
    KVM: x86: Check for invalid/obsolete root *after* making MMU pages available

David Matlack <dmatlack@google.com>
    KVM: x86/mmu: Rename __direct_map() to direct_map()

David Matlack <dmatlack@google.com>
    KVM: x86/mmu: Split out TDP MMU page fault handling

Chao Peng <chao.p.peng@linux.intel.com>
    KVM: Rename mmu_notifier_* to mmu_invalidate_*

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Document the "rules" for using host_pfn_mapping_level()

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Rename pte_list_{destroy,remove}() to show they zap SPTEs

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Directly "destroy" PTE list when recycling rmaps

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Retry page fault if root is invalidated by memslot update

Dawid Wróbel <me@dawidwrobel.com>
    ASoC: codecs: lpass-tx-macro: Fix enum kcontrol accesses

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: avoid combining some incoming suboptions

Eric Farman <farman@linux.ibm.com>
    s390/vfio_ccw: Implement a crw lock

Eric Farman <farman@linux.ibm.com>
    s390/vfio_ccw: Selectively expand io_mutex

Eric Farman <farman@linux.ibm.com>
    s390/vfio_ccw: Ensure index for read/write regions are within range

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    nvmet-tcp: Do not WARN on remotely-controlled oversized SGL allocations

Jiang HongHui <jiang_hh2019@163.com>
    nvmet-fc: fix invalid free in LS IOD error path

Luxiao Xu <rakukuip@gmail.com>
    ipv6: fix use-after-free in ip6_finish_output2()

Yong Wang <edragain@163.com>
    ipv4: reject undersized MTUs in ip_do_fragment()

Yang Wang <kevinyang.wang@amd.com>
    drm/amdgpu: check ASPM on the dGPU host link

Pavitra Jha <jhapavitra98@gmail.com>
    libceph: fix OOB read in decode_watchers() via missing bounds check

Linmao Li <lilinmao@kylinos.cn>
    nfc: nci: free destination parameters when closing a connection

Samuel Page <sam@bynar.io>
    nfc: nci: fix uninit-value in the RF discover/activated NTF handlers

Samuel Page <sam@bynar.io>
    nfc: nci: fix out-of-bounds write in nci_target_auto_activated()

Doruk Tan Ozturk <doruk@0sec.ai>
    nfc: st21nfca: validate ATR_REQ length against the received frame

Xu Rao <raoxu@uniontech.com>
    nfc: pn533: purge fragmented skbs during cleanup

Doruk Tan Ozturk <doruk@0sec.ai>
    nfc: llcp: reject PDUs shorter than the LLCP header

Muhammad Bilal <meatuni001@gmail.com>
    nfc: llcp: fix OOB read and u8 offset wrap in TLV parsers

Doruk Tan Ozturk <doruk@0sec.ai>
    nfc: llcp: bound the connect_sn TLV walk to the skb

Pengpeng Hou <pengpeng@iscas.ac.cn>
    nfc: microread: validate target discovery payload lengths

Bryam Vargas <hexlabsecurity@proton.me>
    nfc: fdp: bound the device-reported read length and fix an skb leak

Doruk Tan Ozturk <doruk@0sec.ai>
    nfc: digital: clamp SENSF_RES length to the destination buffer

Ibrahim Hashimov <security@auditcode.ai>
    xfs: bounds-check buffer log item's dirty bitmap

Eric Farman <farman@linux.ibm.com>
    s390/vfio_ccw: Cancel existing workqueues

Pei Xiao <xiaopei01@kylinos.cn>
    mmc: atmel-mci: Fix use-after-free in atmci_remove due to race condition

Zhiling Zou <zhilinz@nebusec.ai>
    inet: frags: publish queues before arming timer

Zihan Xi <zihanx@nebusec.ai>
    packet: synchronize pressure clearing with ring reconfiguration

Zijie Huang <milkory@outlook.com>
    net/sched: reject overly deep qdisc hierarchies

Qihang Tang <q.h.hack.winter@gmail.com>
    packet: use consistent hard_header_len in TX_RING send path

Qihang Tang <q.h.hack.winter@gmail.com>
    packet: use consistent hard_header_len in non-ring send paths

Fan Wu <fanwu01@zju.edu.cn>
    serial: amba-pl011: synchronize DMA teardown

Koichiro Den <den@valinux.co.jp>
    NTB: ntb_netdev: Preserve RX queue depth on allocation failure

Aditya Chillara <aditya.chillara@oss.qualcomm.com>
    perf/core: Fix group leader use-after-free after sibling detach

Yeoreum Yun <yeoreum.yun@arm.com>
    perf: Fix dangling cgroup pointer in cpuctx

Peter Zijlstra <peterz@infradead.org>
    perf: Fix cgroup state vs ERROR

Yeoreum Yun <yeoreum.yun@arm.com>
    perf/core: Fix child_total_time_enabled accounting bug at task exit

Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
    misc: fastrpc: Remove buffer from list prior to unmap operation

Abel Vesa <abel.vesa@linaro.org>
    misc: fastrpc: Rework fastrpc_req_munmap

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    misc: fastrpc: separate fastrpc device from channel context

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/huge_memory: fix huge_zero_pfn race

Junjie Cao <junjie.cao@intel.com>
    gpio: ml-ioh: use raw_spinlock_t for the register lock

Hongling Zeng <zenghongling@kylinos.cn>
    xfs: validate attr entry pointer before field access

Guanghui Yang <3497809730@qq.com>
    ext4: clear error before retrying inode xattr space fallback

Matthias Goergens <matthias.goergens@gmail.com>
    ext4: stop retrying saturated xattr cache entries

Rik van Riel <riel@surriel.com>
    null_blk: fix UBSAN shift-out-of-bounds when zone_size is 0 or overflows

Ian Bridges <icb@fastmail.org>
    ocfs2: fix missing metadata reservation for large xattrs

Takashi Iwai <tiwai@suse.de>
    ALSA: dummy: Check card index validity at probe

Griffin Kroah-Hartman <griffin@kroah.com>
    rndis_host: add overflow check in rndis_rx_fixup()

Ali Ahmet Memis <ali@iusegentoo.com>
    Bluetooth: RFCOMM: take rfcomm_mutex for the deferred setup accept

Steffen Persvold <spersvold@gmail.com>
    PCI: host-generic: Fix NULL pointer dereference on 32-bit CAM systems


-------------

Diffstat:

 Makefile                                   |   4 +-
 arch/arm64/kvm/mmu.c                       |  10 +-
 arch/mips/kvm/mmu.c                        |  12 +-
 arch/powerpc/include/asm/kvm_book3s_64.h   |   2 +-
 arch/powerpc/kvm/book3s_64_mmu_host.c      |   4 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c        |   4 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c     |   6 +-
 arch/powerpc/kvm/book3s_64_vio_hv.c        |   2 +-
 arch/powerpc/kvm/book3s_hv_nested.c        |   2 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c        |   8 +-
 arch/powerpc/kvm/e500_mmu_host.c           |   4 +-
 arch/x86/kvm/mmu/mmu.c                     | 189 +++++++++++++----
 arch/x86/kvm/mmu/paging_tmpl.h             |  13 +-
 drivers/block/null_blk/zoned.c             |  10 +-
 drivers/gpio/gpio-ml-ioh.c                 |  36 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |  50 ++++-
 drivers/hid/hid-core.c                     |  11 +-
 drivers/hid/hid-hyperv.c                   |  27 ++-
 drivers/hid/hid-magicmouse.c               |  26 +++
 drivers/hid/hid-sensor-custom.c            |  21 +-
 drivers/input/keyboard/atkbd.c             |  23 ++-
 drivers/misc/fastrpc.c                     | 110 ++++++----
 drivers/mmc/host/atmel-mci.c               |   2 +
 drivers/net/can/dev/skb.c                  |   2 -
 drivers/net/can/slcan.c                    |   1 -
 drivers/net/ntb_netdev.c                   |  15 +-
 drivers/net/usb/rndis_host.c               |   6 +-
 drivers/nfc/fdp/i2c.c                      |  27 +++
 drivers/nfc/microread/microread.c          |  31 ++-
 drivers/nfc/pn533/pn533.c                  |   1 +
 drivers/nfc/st21nfca/dep.c                 |   3 +
 drivers/nvme/target/fc.c                   |   2 +-
 drivers/nvme/target/tcp.c                  |   5 +-
 drivers/pci/controller/pci-host-generic.c  |  11 +-
 drivers/pci/ecam.c                         |  13 ++
 drivers/s390/cio/vfio_ccw_async.c          |  16 ++
 drivers/s390/cio/vfio_ccw_chp.c            |  31 ++-
 drivers/s390/cio/vfio_ccw_cp.c             |  31 ++-
 drivers/s390/cio/vfio_ccw_drv.c            |  14 +-
 drivers/s390/cio/vfio_ccw_ops.c            |  15 +-
 drivers/s390/cio/vfio_ccw_private.h        |   7 +-
 drivers/tty/serial/amba-pl011.c            |   8 +-
 fs/ext4/xattr.c                            |   7 +-
 fs/iomap/buffered-io.c                     |  19 +-
 fs/ocfs2/xattr.c                           |  18 +-
 fs/xfs/libxfs/xfs_attr_leaf.c              |  14 ++
 fs/xfs/xfs_buf_item_recover.c              |  53 +++--
 include/linux/can/core.h                   |   1 +
 include/linux/can/skb.h                    |   3 -
 include/linux/kvm_host.h                   |  60 +++---
 include/linux/netdevice.h                  |   6 +-
 include/linux/pci-ecam.h                   |   3 +
 include/net/sch_generic.h                  |   1 +
 kernel/events/core.c                       | 121 +++++------
 mm/huge_memory.c                           |  52 +++--
 net/bluetooth/rfcomm/core.c                |  24 ++-
 net/can/af_can.c                           |  14 +-
 net/can/bcm.c                              |   2 -
 net/can/isotp.c                            | 320 +++++++++++++++++++++--------
 net/can/j1939/socket.c                     |   1 -
 net/can/j1939/transport.c                  |   2 -
 net/can/raw.c                              |   7 +-
 net/ceph/osd_client.c                      |   5 +-
 net/ipv4/inet_fragment.c                   |   6 +-
 net/ipv4/ip_output.c                       |   4 +
 net/ipv6/ip6_output.c                      |   2 +
 net/mptcp/options.c                        |  57 +++++
 net/mptcp/pm_netlink.c                     |  39 ++--
 net/mptcp/protocol.h                       |   1 +
 net/nfc/digital_technology.c               |   2 +
 net/nfc/llcp_commands.c                    |  18 +-
 net/nfc/llcp_core.c                        |  15 +-
 net/nfc/nci/ntf.c                          |  10 +-
 net/nfc/nci/rsp.c                          |   1 +
 net/packet/af_packet.c                     |  65 ++++--
 net/sched/sch_api.c                        |   9 +
 net/xfrm/xfrm_state.c                      |   4 +-
 sound/drivers/dummy.c                      |   6 +
 sound/soc/codecs/lpass-tx-macro.c          |   4 +-
 virt/kvm/kvm_main.c                        |  49 ++---
 80 files changed, 1314 insertions(+), 526 deletions(-)


