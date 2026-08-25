Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42502423A85;
	Tue, 25 Aug 2026 13:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666010; cv=none; b=QnCMczm5g0TJ+2pk/y8hq9O4r+sZVP/uGOYNND+mDZXtQCw00GLS4V/JODmLd3wmfHrmD6kBvi5ifmlTinGS/i0Prakxmo9pyfYqVI+VXf02rZCg+ldZIT69TQBe8aJ6GDIZBBljkSm01PCVhmOp9J3tS6NgjyQQd22SyOem9bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666010; c=relaxed/simple;
	bh=qXMvxcEzQob0AQUEFvKR/+mZPVZWdtCbZuhdyqJ4KBc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OqQLJ4Ruli8L/ApUMPavXASqJCKFxkNYjxtiZt0am1TNAv4pLqw2uLL0KYaFQ+z4O7jUVyfopRUWWDfZGVE/Xu4vthnF6QZ5h0kBlZEIi3DzaALFlf2z2tCDeHB5WMI2CTEtqNFwI6i8SnlOQsmYDCaFuJi7zPzaPdoyYRX7GKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/XdCaEy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/XdCaEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEC61F000E9;
	Tue, 25 Aug 2026 13:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666008;
	bh=+gPDg4rfbksLsTd9N502cxD6FH2VmMHeUwEW3lxd2Pw=;
	h=From:To:Cc:Subject:Date;
	b=X/XdCaEy5ax+cuZCTJPgJee2PlanN5lzNWrGVtUwhmS+Rghl3YN7t6CVs0eNzw9av
	 fJIZOToNOs2RfoL1ShtVoLESAize7R/qSNvCMG8LDE1FACNUUQIB/yOhVpR5Teo9VO
	 KxeTU/JdF/DoSemmhbjPXvsc9zcW7HNCYvjh7wOA=
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
Subject: [PATCH 6.1 00/79] 6.1.185-rc1 review
Date: Tue, 25 Aug 2026 15:25:40 +0200
Message-ID: <20260825132541.677185791@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.185-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.185-rc1
X-KernelTest-Deadline: 2026-08-27T13:25+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.185 release.
There are 79 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.185-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.185-rc1

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_event: fix LE list UAF on reset

Michael Bommarito <michael.bommarito@gmail.com>
    HID: hyperv: validate initial device info bounds

Haoxiang Li <haoxiang_li2024@163.com>
    HID: sensor: custom: Fix use-after-free in enable_sensor

Jann Horn <jannh@google.com>
    HID: core: fix number/pointer type confusion on long items

Ibrahim Hashimov <security@auditcode.ai>
    HID: nintendo: fix out-of-bounds read in joycon_ctlr_read_handler()

Sukrut Bellary <sukrut.bellary@linux.com>
    misc: fastrpc: Fix double free of 'buf' in error path

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: fix timer drain order, wakeup handling and tx_gen ordering

Oliver Hartkopp <socketcan@hartkopp.net>
    can: use skb hash instead of private variable in headroom

Donglin Lyu <DongLin_Lyu@outlook.com>
    Input: atkbd - skip deactivate for HONOR ZQC-P

Cryolitia PukNgae <cryolitia.pukngae@linux.dev>
    Input: atkbd - skip deactivate for HONOR FMB-P's internal keyboard

Eric Farman <farman@linux.ibm.com>
    s390/vfio_ccw: Free all memory if cp_init() fails

Xiang Mei (Microsoft) <xmei5@asu.edu>
    xfrm: fix sk_dst_cache double-free in xfrm_user_policy()

Baul Lee <baul.lee@xbow.com>
    HID: core: fix OOB read of field->usage in hid_set_field()

Lee Jones <lee@kernel.org>
    HID: magicmouse: Prevent out-of-bounds (OOB) read during DOUBLE_REPORT_ID

Jose Villaseñor Montfort <pepemontfort@gmail.com>
    HID: magicmouse: do not keep a stale msc->input if no input is claimed

Qing Luo <luoqing@kylinos.cn>
    mptcp: pm: fix data race in add_addr timer callback

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ADD_ADDR rtx: free sk if last

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ADD_ADDR rtx: always decrease sk refcount

Dawid Wróbel <me@dawidwrobel.com>
    ASoC: codecs: lpass-tx-macro: Fix enum kcontrol accesses

Linmao Li <lilinmao@kylinos.cn>
    Input: byd - synchronize timer deletion before freeing private data

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    nvmet-tcp: Do not WARN on remotely-controlled oversized SGL allocations

Jiang HongHui <jiang_hh2019@163.com>
    nvmet-fc: fix invalid free in LS IOD error path

Bryam Vargas <hexlabsecurity@proton.me>
    nvmet-auth: zero the AUTH_RECEIVE response buffer

Luxiao Xu <rakukuip@gmail.com>
    ipv6: fix use-after-free in ip6_finish_output2()

Yong Wang <edragain@163.com>
    ipv4: reject undersized MTUs in ip_do_fragment()

Pavitra Jha <jhapavitra98@gmail.com>
    libceph: fix OOB read in decode_watchers() via missing bounds check

Eric Dumazet <edumazet@google.com>
    ndisc: ndisc_send_redirect() cleanup

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

Joanne Koong <joannelkoong@gmail.com>
    iomap: adjust read range correctly for non-block-aligned positions

Jakub Kicinski <kuba@kernel.org>
    tls: handle data disappearing from under the TLS ULP

Sabrina Dubroca <sd@queasysnail.net>
    tls: fix lockless read of strp->msg_ready in ->poll

Junjie Cao <junjie.cao@intel.com>
    gpio: ml-ioh: use raw_spinlock_t for the register lock

Yang Wang <kevinyang.wang@amd.com>
    drm/amdgpu: check ASPM on the dGPU host link

Ibrahim Hashimov <security@auditcode.ai>
    xfs: bounds-check buffer log item's dirty bitmap

Christoph Hellwig <hch@lst.de>
    xfs: don't use a xfs_log_iovec for ri_buf in log recovery

Eric Farman <farman@linux.ibm.com>
    s390/vfio_ccw: Implement a crw lock

Eric Farman <farman@linux.ibm.com>
    s390/vfio_ccw: Selectively expand io_mutex

Eric Farman <farman@linux.ibm.com>
    s390/vfio_ccw: Move cp cleanup out of not operational

Junrui Luo <moonafterrain@outlook.com>
    drm/amdgpu: disallow multiple FENCE chunks in one submit

Eric Farman <farman@linux.ibm.com>
    s390/vfio_ccw: Cancel existing workqueues

Pei Xiao <xiaopei01@kylinos.cn>
    mmc: atmel-mci: Fix use-after-free in atmci_remove due to race condition

Zhiling Zou <zhilinz@nebusec.ai>
    inet: frags: publish queues before arming timer

Zihan Xi <zihanx@nebusec.ai>
    packet: synchronize pressure clearing with ring reconfiguration

Eric Dumazet <edumazet@google.com>
    net/packet: convert po->pressure to an atomic flag

Luca Fresi <luca.fresi@bithiatec.com>
    serial: sc16is7xx: enable THRI before filling TX FIFO

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: use guards for simple mutex locks

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: rename EFR mutex with generic name

Lech Perczak <lech.perczak@camlingroup.com>
    serial: sc16is7xx: convert bitmask definitions to use BIT() macro

Lech Perczak <lech.perczak@camlingroup.com>
    serial: sc16is7xx: fix copy-paste errors in EFR_SWFLOWx_BIT constants

Qihang Tang <q.h.hack.winter@gmail.com>
    packet: use consistent hard_header_len in TX_RING send path

Qihang Tang <q.h.hack.winter@gmail.com>
    packet: use consistent hard_header_len in non-ring send paths

Aditya Chillara <aditya.chillara@oss.qualcomm.com>
    perf/core: Fix group leader use-after-free after sibling detach

Yeoreum Yun <yeoreum.yun@arm.com>
    perf: Fix dangling cgroup pointer in cpuctx

Peter Zijlstra <peterz@infradead.org>
    perf: Fix cgroup state vs ERROR

Yeoreum Yun <yeoreum.yun@arm.com>
    perf/core: Fix child_total_time_enabled accounting bug at task exit

Fan Wu <fanwu01@zju.edu.cn>
    serial: amba-pl011: synchronize DMA teardown

Koichiro Den <den@valinux.co.jp>
    NTB: ntb_netdev: Preserve RX queue depth on allocation failure

Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
    misc: fastrpc: Remove buffer from list prior to unmap operation

Abel Vesa <abel.vesa@linaro.org>
    misc: fastrpc: Rework fastrpc_req_munmap

Hongling Zeng <zenghongling@kylinos.cn>
    xfs: validate attr entry pointer before field access

Guanghui Yang <3497809730@qq.com>
    ext4: clear error before retrying inode xattr space fallback

Matthias Goergens <matthias.goergens@gmail.com>
    ext4: stop retrying saturated xattr cache entries

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    kcov: fix data corruption and race conditions on PREEMPT_RT

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
 drivers/block/null_blk/zoned.c             |  10 +-
 drivers/gpio/gpio-ml-ioh.c                 |  36 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c     |   4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |  50 ++++-
 drivers/hid/hid-core.c                     |  11 +-
 drivers/hid/hid-hyperv.c                   |  27 ++-
 drivers/hid/hid-magicmouse.c               |  26 +++
 drivers/hid/hid-nintendo.c                 |   7 +-
 drivers/hid/hid-sensor-custom.c            |  21 +-
 drivers/input/keyboard/atkbd.c             |  23 ++-
 drivers/input/mouse/byd.c                  |   2 +-
 drivers/misc/fastrpc.c                     |  64 +++---
 drivers/mmc/host/atmel-mci.c               |   2 +
 drivers/net/can/dev/skb.c                  |   2 -
 drivers/net/ntb_netdev.c                   |  15 +-
 drivers/net/usb/rndis_host.c               |   6 +-
 drivers/nfc/fdp/i2c.c                      |  27 +++
 drivers/nfc/microread/microread.c          |  31 ++-
 drivers/nfc/pn533/pn533.c                  |   1 +
 drivers/nfc/st21nfca/dep.c                 |   3 +
 drivers/nvme/target/fabrics-cmd-auth.c     |   2 +-
 drivers/nvme/target/fc.c                   |   2 +-
 drivers/nvme/target/tcp.c                  |   5 +-
 drivers/pci/controller/pci-host-generic.c  |  11 +-
 drivers/pci/ecam.c                         |  13 ++
 drivers/s390/cio/vfio_ccw_chp.c            |  26 ++-
 drivers/s390/cio/vfio_ccw_cp.c             |  30 ++-
 drivers/s390/cio/vfio_ccw_drv.c            |  26 ++-
 drivers/s390/cio/vfio_ccw_fsm.c            |   8 +-
 drivers/s390/cio/vfio_ccw_ops.c            |  27 +++
 drivers/s390/cio/vfio_ccw_private.h        |   9 +-
 drivers/tty/serial/amba-pl011.c            |   8 +-
 drivers/tty/serial/sc16is7xx.c             | 222 ++++++++++----------
 fs/ext4/xattr.c                            |   7 +-
 fs/iomap/buffered-io.c                     |  19 +-
 fs/ocfs2/xattr.c                           |  18 +-
 fs/xfs/libxfs/xfs_attr_leaf.c              |  14 ++
 fs/xfs/libxfs/xfs_log_recover.h            |   4 +-
 fs/xfs/xfs_attr_item.c                     |  24 +--
 fs/xfs/xfs_bmap_item.c                     |  18 +-
 fs/xfs/xfs_buf_item.c                      |   8 +-
 fs/xfs/xfs_buf_item.h                      |   2 +-
 fs/xfs/xfs_buf_item_recover.c              |  91 +++++---
 fs/xfs/xfs_dquot_item_recover.c            |  20 +-
 fs/xfs/xfs_extfree_item.c                  |  43 ++--
 fs/xfs/xfs_icreate_item.c                  |   2 +-
 fs/xfs/xfs_inode_item.c                    |   6 +-
 fs/xfs/xfs_inode_item.h                    |   4 +-
 fs/xfs/xfs_inode_item_recover.c            |  26 +--
 fs/xfs/xfs_log_recover.c                   |  16 +-
 fs/xfs/xfs_refcount_item.c                 |  16 +-
 fs/xfs/xfs_rmap_item.c                     |  16 +-
 fs/xfs/xfs_trans.h                         |   1 -
 include/linux/can/core.h                   |   1 +
 include/linux/can/skb.h                    |   2 -
 include/linux/netdevice.h                  |   6 +-
 include/linux/pci-ecam.h                   |   3 +
 include/linux/sched.h                      |   8 +
 include/net/tls.h                          |   3 +-
 kernel/events/core.c                       | 121 +++++------
 kernel/kcov.c                              |  90 ++++----
 lib/Kconfig.debug                          |   5 +-
 net/bluetooth/hci_event.c                  |   2 +
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
 net/ipv6/ndisc.c                           |   8 +-
 net/mptcp/pm_netlink.c                     |  36 ++--
 net/nfc/digital_technology.c               |   2 +
 net/nfc/llcp_commands.c                    |  18 +-
 net/nfc/llcp_core.c                        |  15 +-
 net/nfc/nci/ntf.c                          |  10 +-
 net/nfc/nci/rsp.c                          |   1 +
 net/packet/af_packet.c                     |  79 ++++---
 net/packet/internal.h                      |   2 +-
 net/tls/tls.h                              |   4 +-
 net/tls/tls_strp.c                         |  17 +-
 net/tls/tls_sw.c                           |   3 +-
 net/xfrm/xfrm_state.c                      |   4 +-
 sound/drivers/dummy.c                      |   6 +
 sound/soc/codecs/lpass-tx-macro.c          |   4 +-
 90 files changed, 1283 insertions(+), 670 deletions(-)


