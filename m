Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B1F481256;
	Tue, 25 Aug 2026 13:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665419; cv=none; b=I/luZBzLgJkKTXb3ObADad0A40TwHr32RawZAgXkK5Er5kDmbz4iALiic0Q3s8UrhGRcCOuhmWd3HdUGfAbmZTmiWz8HyFUL3uQ9zabEmyS3BrGjvGTdcZZp1k01no14djilJ5MCBgLTGRC6Uw+aD8SIjihw7KuuFYyAhnCzQBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665419; c=relaxed/simple;
	bh=BHgm7YRvOS9oc2ZknIbjidcaoOTfASpDA5d0nfXd8/I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WOUq3hhYoY02kCbmyL/UI74kTfS4R1zkg7vHiosmHHaBY6bAgrgyWRCEyQ0bBrc+GcHZxi87H8JeosmfS+WUFfjG+yygwQyv3uhub62t0Gjk4DHOzrLnUyjEuMDFMEuCjQRMUeEwimXtKvBZ/Hs3rM9PtwuehbUEtmMgs0+bRsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/EJx6ac; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/EJx6ac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278B91F000E9;
	Tue, 25 Aug 2026 13:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665416;
	bh=z9O0fvU+q6h29LFaRJ6ytTFrfIUa4Oi2wphVFPRcddc=;
	h=From:To:Cc:Subject:Date;
	b=x/EJx6acjRTsxGoT1Xezm7x3FlgLkYCF/5cRrnxV8Erl68FZlJTO7nFX5ughbWDAv
	 7pJOT0PClNDLkdGxMTA9dKqN00NxfnsPz4xthYAF966Yhbvo2N/pBxNSbdiWakBlYC
	 lvlqtYXBDbUu8fLSVD0ExgxKcsOYAZhXxtf61i08=
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
Subject: [PATCH 6.12 00/77] 6.12.106-rc1 review
Date: Tue, 25 Aug 2026 15:25:22 +0200
Message-ID: <20260825132541.580275153@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.106-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.106-rc1
X-KernelTest-Deadline: 2026-08-27T13:25+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.106 release.
There are 77 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.106-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.106-rc1

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    Bluetooth: hci_aml: validate firmware segment lengths

Ali Ahmet Memis <ali@iusegentoo.com>
    Bluetooth: ISO: do not force BT_LISTEN after a failed BIG sync

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    Bluetooth: hci_event: validate LE Set CIG Parameters response

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_event: fix LE list UAF on reset

Michael Bommarito <michael.bommarito@gmail.com>
    HID: hyperv: validate initial device info bounds

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

Donglin Lyu <DongLin_Lyu@outlook.com>
    Input: atkbd - skip deactivate for HONOR ZQC-P

Cryolitia PukNgae <cryolitia.pukngae@linux.dev>
    Input: atkbd - skip deactivate for HONOR FMB-P's internal keyboard

Shardul Bankar <shardul.b@mpiricsoftware.com>
    mptcp: pm: fix memory leak from alloc-during-teardown race

Eric Dumazet <edumazet@google.com>
    ipv4: start using dst_dev_rcu()

Xiang Mei (Microsoft) <xmei5@asu.edu>
    xfrm: fix sk_dst_cache double-free in xfrm_user_policy()

Anand Khoje <anand.a.khoje@oracle.com>
    net/ionic: avoid OOB TX partner lookup for hwstamp RXQ

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

Maarten Lankhorst <dev@lankhorst.se>
    drm/xe: Fix DPT allocation paths.

Dawid Wróbel <me@dawidwrobel.com>
    ASoC: codecs: lpass-tx-macro: Fix enum kcontrol accesses

Qing Luo <luoqing@kylinos.cn>
    mptcp: pm: fix data race in add_addr timer callback

Bryam Vargas <hexlabsecurity@proton.me>
    selinux: require a class's permission values to cover its permission count

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    nvmet-tcp: Do not WARN on remotely-controlled oversized SGL allocations

Ibrahim Hashimov <security@auditcode.ai>
    nvmet-tcp: bound SGL data length before allocating command buffers

Jiang HongHui <jiang_hh2019@163.com>
    nvmet-fc: fix invalid free in LS IOD error path

Bryam Vargas <hexlabsecurity@proton.me>
    nvmet-auth: zero the AUTH_RECEIVE response buffer

Luxiao Xu <rakukuip@gmail.com>
    ipv6: fix use-after-free in ip6_finish_output2()

Yong Wang <edragain@163.com>
    ipv4: reject undersized MTUs in ip_do_fragment()

Linmao Li <lilinmao@kylinos.cn>
    Input: byd - synchronize timer deletion before freeing private data

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

Pavitra Jha <jhapavitra98@gmail.com>
    libceph: fix OOB read in decode_watchers() via missing bounds check

Hongling Zeng <zenghongling@kylinos.cn>
    xfs: validate attr entry pointer before field access

Guanghui Yang <3497809730@qq.com>
    ext4: propagate errors from fast commit range replay

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

Darrick J. Wong <djwong@kernel.org>
    xfs: don't livelock in scrub on a circular unlinked list

Darrick J. Wong <djwong@kernel.org>
    xfs: hoist per-bucket unlinked list check to helper

Ibrahim Hashimov <security@auditcode.ai>
    xfs: bounds-check buffer log item's dirty bitmap

Christoph Hellwig <hch@lst.de>
    xfs: don't use a xfs_log_iovec for ri_buf in log recovery

Darrick J. Wong <djwong@kernel.org>
    xfs: namespace the maximum length/refcount symbols

Luca Fresi <luca.fresi@bithiatec.com>
    serial: sc16is7xx: enable THRI before filling TX FIFO

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: use guards for simple mutex locks

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: rename EFR mutex with generic name

Fan Wu <fanwu01@zju.edu.cn>
    serial: amba-pl011: synchronize DMA teardown

Koichiro Den <den@valinux.co.jp>
    NTB: ntb_netdev: Preserve RX queue depth on allocation failure

Ryan Wilbur <rwilbur633@gmail.com>
    serial: 8250_of: clear stuck empty-FIFO RX-timeout on LPC32xx

Zhiling Zou <zhilinz@nebusec.ai>
    inet: frags: publish queues before arming timer

Eric Dumazet <edumazet@google.com>
    inet: frags: save a pair of atomic operations in reassembly

Eric Dumazet <edumazet@google.com>
    inet: frags: change inet_frag_kill() to defer refcount updates

Eric Dumazet <edumazet@google.com>
    ipv4: frags: remove ipq_put()

Eric Dumazet <edumazet@google.com>
    inet: frags: add inet_frag_putn() helper

David Howells <dhowells@redhat.com>
    netfs: Fix potential UAF in netfs_unlock_abandoned_read_pages()

Nobuhiro Iwamatsu <nobuhiro.iwamatsu.x90@mail.toshiba>
    hwmon: (ltc4286) Fix symbol namespace of MODULE_IMPORT_NS()

Jordan Rhee <jordanrhee@google.com>
    gve: fix zero-length skb frag with header-split

Junjie Cao <junjie.cao@intel.com>
    gpio: ml-ioh: use raw_spinlock_t for the register lock

Griffin Kroah-Hartman <griffin@kroah.com>
    rndis_host: add overflow check in rndis_rx_fixup()

Geoffrey D. Bennett <g@b4.vu>
    ALSA: scarlett2: Use a private URB for the notification endpoint

Ali Ahmet Memis <ali@iusegentoo.com>
    Bluetooth: RFCOMM: take rfcomm_mutex for the deferred setup accept

Steffen Persvold <spersvold@gmail.com>
    PCI: host-generic: Fix NULL pointer dereference on 32-bit CAM systems


-------------

Diffstat:

 Makefile                                         |  4 +-
 drivers/block/null_blk/zoned.c                   | 10 ++-
 drivers/bluetooth/hci_aml.c                      | 18 ++++-
 drivers/gpio/gpio-ml-ioh.c                       | 36 ++++-----
 drivers/gpu/drm/xe/display/xe_fb_pin.c           | 24 ++----
 drivers/hid/hid-core.c                           | 11 ++-
 drivers/hid/hid-hyperv.c                         | 27 ++++++-
 drivers/hid/hid-input.c                          |  3 +
 drivers/hid/hid-magicmouse.c                     | 64 +++++++++++++++-
 drivers/hid/hid-nintendo.c                       | 22 ++++--
 drivers/hid/hid-sensor-custom.c                  | 21 ++---
 drivers/hwmon/pmbus/ltc4286.c                    |  2 +-
 drivers/input/keyboard/atkbd.c                   | 23 +++++-
 drivers/input/mouse/byd.c                        |  2 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c     |  6 ++
 drivers/net/ethernet/pensando/ionic/ionic_lif.c  | 17 +++-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c |  7 +-
 drivers/net/ntb_netdev.c                         | 15 ++--
 drivers/net/usb/rndis_host.c                     |  6 +-
 drivers/nfc/fdp/i2c.c                            | 27 +++++++
 drivers/nfc/microread/microread.c                | 31 +++++++-
 drivers/nfc/pn533/pn533.c                        |  1 +
 drivers/nfc/st21nfca/dep.c                       |  3 +
 drivers/nvme/target/fabrics-cmd-auth.c           |  2 +-
 drivers/nvme/target/fc.c                         |  2 +-
 drivers/nvme/target/tcp.c                        | 18 ++++-
 drivers/pci/controller/pci-host-generic.c        | 11 +--
 drivers/pci/ecam.c                               | 13 ++++
 drivers/tty/serial/8250/8250_of.c                | 41 ++++++++++
 drivers/tty/serial/amba-pl011.c                  |  8 +-
 drivers/tty/serial/sc16is7xx.c                   | 40 +++++-----
 fs/ext4/fast_commit.c                            | 16 +++-
 fs/ext4/xattr.c                                  |  7 +-
 fs/netfs/buffered_read.c                         |  4 +-
 fs/netfs/read_collect.c                          |  2 +-
 fs/netfs/read_retry.c                            |  2 +-
 fs/ocfs2/xattr.c                                 | 18 +++--
 fs/xfs/libxfs/xfs_attr_leaf.c                    | 14 ++++
 fs/xfs/libxfs/xfs_format.h                       |  4 +-
 fs/xfs/libxfs/xfs_log_recover.h                  |  4 +-
 fs/xfs/libxfs/xfs_refcount.c                     | 18 ++---
 fs/xfs/scrub/agheader.c                          | 94 +++++++++++++++++------
 fs/xfs/scrub/agheader_repair.c                   | 17 +++-
 fs/xfs/scrub/refcount.c                          |  2 +-
 fs/xfs/scrub/refcount_repair.c                   |  4 +-
 fs/xfs/xfs_attr_item.c                           | 32 ++++----
 fs/xfs/xfs_bmap_item.c                           | 18 ++---
 fs/xfs/xfs_buf_item.c                            |  8 +-
 fs/xfs/xfs_buf_item.h                            |  2 +-
 fs/xfs/xfs_buf_item_recover.c                    | 95 ++++++++++++++---------
 fs/xfs/xfs_dquot_item_recover.c                  | 20 ++---
 fs/xfs/xfs_exchmaps_item.c                       |  8 +-
 fs/xfs/xfs_extfree_item.c                        | 43 ++++++-----
 fs/xfs/xfs_icreate_item.c                        |  2 +-
 fs/xfs/xfs_inode_item.c                          |  6 +-
 fs/xfs/xfs_inode_item.h                          |  4 +-
 fs/xfs/xfs_inode_item_recover.c                  | 26 +++----
 fs/xfs/xfs_log_recover.c                         | 16 ++--
 fs/xfs/xfs_refcount_item.c                       | 16 ++--
 fs/xfs/xfs_rmap_item.c                           | 16 ++--
 fs/xfs/xfs_trans.h                               |  1 -
 include/linux/netfs.h                            |  2 +-
 include/linux/pci-ecam.h                         |  3 +
 include/linux/sched.h                            |  8 ++
 include/net/inet_frag.h                          |  6 +-
 include/net/ipv6_frag.h                          |  5 +-
 kernel/kcov.c                                    | 90 +++++++++++-----------
 lib/Kconfig.debug                                |  5 +-
 net/bluetooth/hci_event.c                        |  8 +-
 net/bluetooth/iso.c                              | 30 ++++++--
 net/bluetooth/rfcomm/core.c                      | 24 +++++-
 net/ceph/osd_client.c                            |  5 +-
 net/ieee802154/6lowpan/reassembly.c              | 27 ++++---
 net/ipv4/icmp.c                                  |  6 +-
 net/ipv4/inet_fragment.c                         | 33 ++++----
 net/ipv4/ip_fragment.c                           | 54 ++++++-------
 net/ipv4/ip_output.c                             |  4 +
 net/ipv4/ipmr.c                                  |  2 +-
 net/ipv4/route.c                                 |  4 +-
 net/ipv6/ip6_output.c                            |  2 +
 net/ipv6/ndisc.c                                 |  8 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c          | 27 ++++---
 net/ipv6/reassembly.c                            | 29 +++----
 net/mptcp/pm_netlink.c                           |  9 ++-
 net/mptcp/pm_userspace.c                         |  7 +-
 net/mptcp/protocol.c                             |  9 +++
 net/mptcp/protocol.h                             |  7 +-
 net/nfc/digital_technology.c                     |  2 +
 net/nfc/llcp_commands.c                          | 18 ++++-
 net/nfc/llcp_core.c                              | 15 +++-
 net/nfc/nci/ntf.c                                | 10 ++-
 net/nfc/nci/rsp.c                                |  1 +
 net/xfrm/xfrm_state.c                            |  4 +-
 security/selinux/ss/policydb.c                   | 57 ++++++++++++--
 sound/drivers/dummy.c                            |  6 ++
 sound/soc/codecs/lpass-tx-macro.c                |  4 +-
 sound/usb/mixer.c                                |  6 ++
 sound/usb/mixer.h                                |  2 +
 sound/usb/mixer_scarlett2.c                      | 98 +++++++++++++++---------
 99 files changed, 1128 insertions(+), 543 deletions(-)


