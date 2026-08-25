Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA02C3E3C4D;
	Tue, 25 Aug 2026 13:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665192; cv=none; b=Vx6Lh7aUZsKTJnIyK9gaT9SIO8TtUSviXAr/0CVFHAVLbbga+634UokDP0Zur2lrxk/C/HCqWEysxtOMiekpWV9N5Hb1lbuBpgjt+nXVpOCf2Ly3KkD9neOoL1l//eeeKc4c9f2b2w7EJMCme3jRuk5a9HeRUMOM8hS8NSOXDsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665192; c=relaxed/simple;
	bh=k9z+9/wQ/qSGDhB2TxMQMu7W/uDCsPXcNc9LEQinR6M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SWSXqAuhY8fBH4Su6JtKGcdXA8rNSA0J5hDnieML+CZoseS2QBYYXRoU+8CIa/HfGq4qCmS+OtGlxwdOlw4j8ePdASN/U6O1AJW91mBuYEPwP5XxpMRy12wrnnfMHxj6hqO5GswDUyW9jXpTZbSa/8ST/4cz7XHuVWGNfSrrEOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHMhd379; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHMhd379"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15E11F00A3A;
	Tue, 25 Aug 2026 13:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665190;
	bh=A0gb/1TvtMZ6qZuR5D/xdArHnOA21ZN8cJOiouvIzxc=;
	h=From:To:Cc:Subject:Date;
	b=rHMhd3799sPDFoZFlm/8oIPQzphPtYpOjhehhJqRq70XHcL2JLnJ8uDGUFEdgaVOl
	 i6xKXa9infozvA7dMylFYk9CbsweDm14DhURUpJX5MCX7ykj2lelkBi2zmHS5O076m
	 44SgS5ZfPEnQE64IbihkDvhPzC/hD8+BBHcvy5EU=
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
Subject: [PATCH 6.18 00/94] 6.18.47-rc1 review
Date: Tue, 25 Aug 2026 15:24:56 +0200
Message-ID: <20260825132541.887883084@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.47-rc1
X-KernelTest-Deadline: 2026-08-27T13:25+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.47 release.
There are 94 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.47-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.47-rc1

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    Bluetooth: hci_aml: validate firmware segment lengths

Ali Ahmet Memis <ali@iusegentoo.com>
    Bluetooth: MGMT: reject HCI_CMD_SYNC params_len above 255

Ali Ahmet Memis <ali@iusegentoo.com>
    Bluetooth: ISO: zero the sockaddr before returning it in getname

Ali Ahmet Memis <ali@iusegentoo.com>
    Bluetooth: ISO: do not force BT_LISTEN after a failed BIG sync

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_sync: Fix accept list UAF during suspend

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    Bluetooth: hci_event: validate LE Set CIG Parameters response

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_event: fix LE list UAF on reset

Linus Torvalds <torvalds@linux-foundation.org>
    drm/xe: Don't hand out the flat CCS storage as usable VRAM

Michael Bommarito <michael.bommarito@gmail.com>
    HID: hyperv: validate initial device info bounds

Ibrahim Hashimov <security@auditcode.ai>
    HID: uclogic: fix use-after-free of inrange_timer on remove

Haoxiang Li <haoxiang_li2024@163.com>
    HID: sensor: custom: Fix use-after-free in enable_sensor

Jann Horn <jannh@google.com>
    HID: core: fix number/pointer type confusion on long items

Jiangshan Yi <yijiangshan@kylinos.cn>
    HID: nintendo: stop device IO before hid_hw_stop on probe failure

Jiangshan Yi <yijiangshan@kylinos.cn>
    HID: nintendo: register input device after capabilities are set

Ibrahim Hashimov <security@auditcode.ai>
    HID: nintendo: fix out-of-bounds read in joycon_ctlr_read_handler()

Peter Zijlstra <peterz@infradead.org>
    futex: Fix might_sleep() warning in futex_pivot_pending()

Hyunwoo Kim <imv4bel@gmail.com>
    futex: Fix race on the initial mm->futex.phash.ref allocation

Thomas Gleixner <tglx@kernel.org>
    futex/pi: Plug private futex exec() race

Thomas Gleixner <tglx@kernel.org>
    futex: Sanitize and document task_struct::futex::state transitions

Kyle Zeng <kylebot@openai.com>
    futex/pi: Reject cross-mm private futex owners

Donglin Lyu <DongLin_Lyu@outlook.com>
    Input: atkbd - skip deactivate for HONOR ZQC-P

Cryolitia PukNgae <cryolitia.pukngae@linux.dev>
    Input: atkbd - skip deactivate for HONOR FMB-P's internal keyboard

Xiang Mei (Microsoft) <xmei5@asu.edu>
    xfrm: fix sk_dst_cache double-free in xfrm_user_policy()

Anand Khoje <anand.a.khoje@oracle.com>
    net/ionic: avoid OOB TX partner lookup for hwstamp RXQ

Baul Lee <baul.lee@xbow.com>
    HID: pidff: fix OOB write when hid->inputs is empty

Baul Lee <baul.lee@xbow.com>
    HID: core: fix OOB read of field->usage in hid_set_field()

Lee Jones <lee@kernel.org>
    HID: magicmouse: Prevent out-of-bounds (OOB) read during DOUBLE_REPORT_ID

Jose Villaseñor Montfort <pepemontfort@gmail.com>
    HID: magicmouse: do not keep a stale msc->input if no input is claimed

Christopher Kodama <ckhordiasma@gmail.com>
    HID: magicmouse: re-enable multitouch after reset-resume

Andrei Fed <andfed.net@gmail.com>
    HID: magicmouse: fix battery reporting for Bluetooth Magic Trackpad USB-C

Dawid Wróbel <me@dawidwrobel.com>
    ASoC: codecs: lpass-tx-macro: Fix enum kcontrol accesses

Bryam Vargas <hexlabsecurity@proton.me>
    selinux: require a class's permission values to cover its permission count

Christian Göttsche <cgzones@googlemail.com>
    selinux: more strict policy parsing

Christian Göttsche <cgzones@googlemail.com>
    selinux: use u16 for security classes

Shardul Bankar <shardul.b@mpiricsoftware.com>
    mptcp: pm: fix memory leak from alloc-during-teardown race

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: uniform announced addresses helpers

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: rename add_entry structure to add_addr

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: use for_each_subflow helper

Yifei Gao <gyf161023@gmail.com>
    nvmet: pci-epf: put CQ ref on create_cq mapping failure

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    nvmet: pci-epf: fix use-after-free in nvmet_pci_epf_exec_iod_work()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    nvmet-tcp: Do not WARN on remotely-controlled oversized SGL allocations

Ibrahim Hashimov <security@auditcode.ai>
    nvmet-tcp: bound SGL data length before allocating command buffers

Jiang HongHui <jiang_hh2019@163.com>
    nvmet-fc: fix invalid free in LS IOD error path

Bryam Vargas <hexlabsecurity@proton.me>
    nvmet-auth: zero the AUTH_RECEIVE response buffer

Griffin Kroah-Hartman <griffin@kroah.com>
    dmaengine: fsl-edma: Add error handling for devm_kasprintf

Griffin Kroah-Hartman <griffin@kroah.com>
    mailbox: mchp-ipc-sbi: Add null check for devm_kasprintf()

Luxiao Xu <rakukuip@gmail.com>
    ipv6: fix use-after-free in ip6_finish_output2()

Yong Wang <edragain@163.com>
    ipv4: reject undersized MTUs in ip_do_fragment()

Maarten Lankhorst <dev@lankhorst.se>
    drm/xe: Fix DPT allocation paths.

Linmao Li <lilinmao@kylinos.cn>
    nfc: nci: free destination parameters when closing a connection

Samuel Page <sam@bynar.io>
    nfc: nci: fix uninit-value in the RF discover/activated NTF handlers

Samuel Page <sam@bynar.io>
    nfc: nci: fix out-of-bounds write in nci_target_auto_activated()

Bryam Vargas <hexlabsecurity@proton.me>
    nfc: nci: add data_len bound checks to activation parameter extractors

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

Pavitra Jha <jhapavitra98@gmail.com>
    libceph: fix OOB read in decode_watchers() via missing bounds check

Hongling Zeng <zenghongling@kylinos.cn>
    xfs: validate attr entry pointer before field access

Jiazi Liu <jiazi.liu1984@gmail.com>
    ext4: fix incorrect function call when initializing s_resgid

Eric Biggers <ebiggers@kernel.org>
    ext4: don't enable DAX on new encrypted files

Guanghui Yang <3497809730@qq.com>
    ext4: propagate errors from fast commit range replay

Jia Zhu <zhujia.zj@bytedance.com>
    ext4: avoid tail write_begin walk for uptodate folios

Guanghui Yang <3497809730@qq.com>
    ext4: clear error before retrying inode xattr space fallback

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: reject invalid block index in GC ioctl

Matthias Goergens <matthias.goergens@gmail.com>
    ext4: stop retrying saturated xattr cache entries

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    kcov: fix data corruption and race conditions on PREEMPT_RT

Rik van Riel <riel@surriel.com>
    null_blk: fix UBSAN shift-out-of-bounds when zone_size is 0 or overflows

Ian Bridges <icb@fastmail.org>
    ocfs2: fix missing metadata reservation for large xattrs

Jens Axboe <axboe@kernel.dk>
    io_uring/uring_cmd: don't skip completion for a synchronous multishot cmd

Ali Ahmet Memis <ali@iusegentoo.com>
    io_uring/rsrc: fix folio size overflow in io_vec_fill_bvec()

Vishnu Razdan <vrazdan@openai.com>
    io_uring/io-wq: fix worker accounting when canceling creation callbacks

Woraphat Khiaodaeng <worapat.kd2@gmail.com>
    io_uring/cmd: fix iovec leak when the async cmd is not recycled

Takashi Iwai <tiwai@suse.de>
    ALSA: dummy: Check card index validity at probe

Jens Axboe <axboe@kernel.dk>
    io_uring/futex: don't mark futex wake requests as inflight

Guixin Liu <kanie@linux.alibaba.com>
    nvmet: fix NULL pointer dereference in nvmet_execute_identify_nslist()

Griffin Kroah-Hartman <griffin@kroah.com>
    rndis_host: add overflow check in rndis_rx_fixup()

Geoffrey D. Bennett <g@b4.vu>
    ALSA: scarlett2: Use a private URB for the notification endpoint

Geoffrey D. Bennett <g@b4.vu>
    ALSA: FCP: Use a private URB for the notification endpoint

Peiyang He <peiyang_he@smail.nju.edu.cn>
    iommu/iommufd: Fix NULL pointer deref in iommufd_ioas_change_process when racing with iopt_map_file_pages

Shameer Kolothum <skolothumtho@nvidia.com>
    iommu/tegra241-cmdqv: Fix CMD_SYNC use-after-free on teardown

Ali Ahmet Memis <ali@iusegentoo.com>
    Bluetooth: RFCOMM: take rfcomm_mutex for the deferred setup accept

Steffen Persvold <spersvold@gmail.com>
    PCI: host-generic: Fix NULL pointer dereference on 32-bit CAM systems

Darrick J. Wong <djwong@kernel.org>
    xfs: don't livelock in scrub on a circular unlinked list

Darrick J. Wong <djwong@kernel.org>
    xfs: hoist per-bucket unlinked list check to helper

Darrick J. Wong <djwong@kernel.org>
    xfs: rtsummary scrub should treat rtbitmap corruption errors as an xref error

Christoph Hellwig <hch@lst.de>
    xfs: add a xchk_ip_set_corrupt helper

Luca Fresi <luca.fresi@bithiatec.com>
    serial: sc16is7xx: enable THRI before filling TX FIFO

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: use guards for simple mutex locks

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: rename EFR mutex with generic name


-------------

Diffstat:

 Makefile                                         |   4 +-
 drivers/block/null_blk/zoned.c                   |  10 +-
 drivers/bluetooth/hci_aml.c                      |  18 +-
 drivers/dma/fsl-edma-main.c                      |   2 +
 drivers/gpu/drm/xe/display/xe_fb_pin.c           |  32 +--
 drivers/gpu/drm/xe/xe_vram.c                     |  23 ++-
 drivers/hid/hid-core.c                           |  11 +-
 drivers/hid/hid-hyperv.c                         |  27 ++-
 drivers/hid/hid-input.c                          |   3 +
 drivers/hid/hid-magicmouse.c                     |  64 +++++-
 drivers/hid/hid-nintendo.c                       |  22 +-
 drivers/hid/hid-sensor-custom.c                  |  21 +-
 drivers/hid/hid-uclogic-core.c                   |  12 +-
 drivers/hid/usbhid/hid-pidff.c                   |  13 +-
 drivers/input/keyboard/atkbd.c                   |  23 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c      |   2 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h      |   1 +
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c   |  15 +-
 drivers/iommu/iommufd/ioas.c                     |   4 +
 drivers/mailbox/mailbox-mchp-ipc-sbi.c           |   2 +
 drivers/net/ethernet/pensando/ionic/ionic_lif.c  |  17 +-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c |   7 +-
 drivers/net/usb/rndis_host.c                     |   6 +-
 drivers/nfc/fdp/i2c.c                            |  27 +++
 drivers/nfc/microread/microread.c                |  31 ++-
 drivers/nfc/pn533/pn533.c                        |   1 +
 drivers/nfc/st21nfca/dep.c                       |   3 +
 drivers/nvme/target/admin-cmd.c                  |   2 +-
 drivers/nvme/target/fabrics-cmd-auth.c           |   2 +-
 drivers/nvme/target/fc.c                         |   2 +-
 drivers/nvme/target/pci-epf.c                    |  10 +-
 drivers/nvme/target/tcp.c                        |  18 +-
 drivers/pci/controller/pci-host-generic.c        |  11 +-
 drivers/pci/ecam.c                               |  13 ++
 drivers/tty/serial/sc16is7xx.c                   |  40 ++--
 fs/exec.c                                        |   8 +-
 fs/ext4/crypto.c                                 |  40 ++--
 fs/ext4/fast_commit.c                            |  16 +-
 fs/ext4/ialloc.c                                 |   4 +
 fs/ext4/inode.c                                  |  11 +-
 fs/ext4/super.c                                  |   2 +-
 fs/ext4/xattr.c                                  |   7 +-
 fs/nilfs2/ioctl.c                                |  20 +-
 fs/ocfs2/xattr.c                                 |  18 +-
 fs/xfs/libxfs/xfs_attr_leaf.c                    |  14 ++
 fs/xfs/scrub/agheader.c                          |  94 ++++++---
 fs/xfs/scrub/agheader_repair.c                   |  17 +-
 fs/xfs/scrub/bmap.c                              |   8 +-
 fs/xfs/scrub/common.c                            |  10 +-
 fs/xfs/scrub/common.h                            |   2 +
 fs/xfs/scrub/dir.c                               |   2 +-
 fs/xfs/scrub/dirtree.c                           |   4 +-
 fs/xfs/scrub/metapath.c                          |   6 +-
 fs/xfs/scrub/nlinks.c                            |  12 +-
 fs/xfs/scrub/parent.c                            |   6 +-
 fs/xfs/scrub/rtbitmap.c                          |  12 +-
 fs/xfs/scrub/rtsummary.c                         |  12 +-
 include/linux/futex.h                            |   2 +
 include/linux/pci-ecam.h                         |   3 +
 include/linux/sched.h                            |   8 +
 include/linux/wait.h                             |   1 +
 include/linux/wait_bit.h                         |   1 +
 io_uring/futex.c                                 |  11 +
 io_uring/futex.h                                 |   1 +
 io_uring/io-wq.c                                 |   9 +-
 io_uring/opdef.c                                 |   2 +-
 io_uring/rsrc.c                                  |   2 +-
 io_uring/uring_cmd.c                             |   8 +-
 kernel/futex/core.c                              | 122 +++++++----
 kernel/futex/futex.h                             |   9 +
 kernel/futex/pi.c                                | 125 +++++++++---
 kernel/kcov.c                                    |  90 ++++----
 kernel/sched/wait.c                              |  15 ++
 kernel/sched/wait_bit.c                          |  14 +-
 lib/Kconfig.debug                                |   5 +-
 net/bluetooth/hci_event.c                        |   8 +-
 net/bluetooth/hci_sync.c                         |  46 ++++-
 net/bluetooth/iso.c                              |  32 ++-
 net/bluetooth/mgmt.c                             |   8 +
 net/bluetooth/rfcomm/core.c                      |  24 ++-
 net/ceph/osd_client.c                            |   5 +-
 net/ipv4/ip_output.c                             |   4 +
 net/ipv6/ip6_output.c                            |   2 +
 net/mptcp/options.c                              |   2 +-
 net/mptcp/pm.c                                   |  74 ++++---
 net/mptcp/pm_kernel.c                            |  22 +-
 net/mptcp/pm_userspace.c                         |  10 +-
 net/mptcp/protocol.h                             |  25 +--
 net/mptcp/subflow.c                              |   4 +-
 net/nfc/digital_technology.c                     |   2 +
 net/nfc/llcp_commands.c                          |  18 +-
 net/nfc/llcp_core.c                              |  15 +-
 net/nfc/nci/ntf.c                                |  36 +++-
 net/nfc/nci/rsp.c                                |   1 +
 net/xfrm/xfrm_state.c                            |   4 +-
 security/selinux/include/security.h              |   1 +
 security/selinux/ss/avtab.c                      |  35 +++-
 security/selinux/ss/avtab.h                      |  13 ++
 security/selinux/ss/conditional.c                |  18 +-
 security/selinux/ss/constraint.h                 |   1 +
 security/selinux/ss/policydb.c                   | 248 +++++++++++++++++++----
 security/selinux/ss/policydb.h                   |  31 ++-
 security/selinux/ss/services.c                   |   8 +-
 sound/drivers/dummy.c                            |   6 +
 sound/soc/codecs/lpass-tx-macro.c                |   4 +-
 sound/usb/fcp.c                                  |  38 ++--
 sound/usb/mixer.c                                |   6 +
 sound/usb/mixer.h                                |   2 +
 sound/usb/mixer_scarlett2.c                      |  98 +++++----
 109 files changed, 1533 insertions(+), 570 deletions(-)


