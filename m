Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AB840680F;
	Tue, 25 Aug 2026 13:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665671; cv=none; b=fMS45n/3K9XM8+nnEa2YrKPYbDX5MibJQ15n+r/Rtu4pr7dCPya53yknDp4Ylo2E08OUriHj54oUoqG7EGyq8Th8kMY8IePflv3nf26WQ4fIOy1ci4G1oYAtw+GiSyT601G1LWyF3nudNO10jmhef+7DUxuGG23uAeJFyXL47VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665671; c=relaxed/simple;
	bh=Dlz+IanbePfkco+znc79yAMDUmRmoVHmNThhnGCJMsM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=js5GnsxVyb9Fs9KqInehTA9RVjFvUXO6/ggr82DNqAgVpC4Ta0EkjVPVbrXnWW/2TaAAXcd+ayqaBI1zuLjgTLH4PNEN8iF+EV/2yrGkEp9y9f7vM0bXWKqh4QqOorALr6EyDG6EYn9fLwxc+R7IcCEeYebLqQbZqcPVDJCfYNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jRMcq/lc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jRMcq/lc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2011F000E9;
	Tue, 25 Aug 2026 13:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665669;
	bh=37e66emiQFyS8SwKQMxsvXYU+pwVL7sfXP2ZMUuOuhU=;
	h=From:To:Cc:Subject:Date;
	b=jRMcq/lc6o1UA8m+04JllaXGr62x/SrBlh0aP6oDh00TR+J3mdzEv7Ll/FuqkCya6
	 Tk5EL7hd6tNg44RR2d136iIRRa1tcAdhmgyyvwZmZ5sNixOryKFJnWBrVOLXnzYjxu
	 TCwMw8cB2wdfWxLalRhjN43QC5Wr/sopkWq8hC+E=
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
Subject: [PATCH 6.6 00/87] 6.6.154-rc1 review
Date: Tue, 25 Aug 2026 15:25:23 +0200
Message-ID: <20260825132541.813800447@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.154-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.154-rc1
X-KernelTest-Deadline: 2026-08-27T13:25+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.154 release.
There are 87 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.154-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.154-rc1

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

Ibrahim Hashimov <security@auditcode.ai>
    HID: nintendo: fix out-of-bounds read in joycon_ctlr_read_handler()

Bryam Vargas <hexlabsecurity@proton.me>
    selinux: require a class's permission values to cover its permission count

Bryam Vargas <hexlabsecurity@proton.me>
    selinux: reject a permission value exceeding the class permission count

Christian Göttsche <cgzones@googlemail.com>
    selinux: more strict policy parsing

Christian Göttsche <cgzones@googlemail.com>
    selinux: use u16 for security classes

Christian Göttsche <cgzones@googlemail.com>
    selinux: make more use of str_read() when loading the policy

Christian Göttsche <cgzones@googlemail.com>
    selinux: avoid unnecessary indirection in struct level_datum

Christian Göttsche <cgzones@googlemail.com>
    selinux: use known type instead of void pointer

Paul Moore <paul@paul-moore.com>
    selinux: fix style issues in security/selinux/ss/policydb.c

Paul Moore <paul@paul-moore.com>
    selinux: fix style issues in security/selinux/ss/policydb.h

Shardul Bankar <shardul.b@mpiricsoftware.com>
    mptcp: pm: fix memory leak from alloc-during-teardown race

Donglin Lyu <DongLin_Lyu@outlook.com>
    Input: atkbd - skip deactivate for HONOR ZQC-P

Cryolitia PukNgae <cryolitia.pukngae@linux.dev>
    Input: atkbd - skip deactivate for HONOR FMB-P's internal keyboard

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_sync: Fix advertising data UAFs

Xiang Mei (Microsoft) <xmei5@asu.edu>
    xfrm: fix sk_dst_cache double-free in xfrm_user_policy()

Baul Lee <baul.lee@xbow.com>
    HID: core: fix OOB read of field->usage in hid_set_field()

Lee Jones <lee@kernel.org>
    HID: magicmouse: Prevent out-of-bounds (OOB) read during DOUBLE_REPORT_ID

Jose Villaseñor Montfort <pepemontfort@gmail.com>
    HID: magicmouse: do not keep a stale msc->input if no input is claimed

Andrei Fed <andfed.net@gmail.com>
    HID: magicmouse: fix battery reporting for Bluetooth Magic Trackpad USB-C

Qing Luo <luoqing@kylinos.cn>
    mptcp: pm: fix data race in add_addr timer callback

Dawid Wróbel <me@dawidwrobel.com>
    ASoC: codecs: lpass-tx-macro: Fix enum kcontrol accesses

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-pcm: Continue the pipeline trigger in case of IPC timeout

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: pcm: Add snd_sof_pcm specific wrappers for dev_dbg() and dev_err()

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: pcm: Move period/buffer configuration print after platform open

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Relocate and rework functionality for PCM stream freeing

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: sof: pcm: use snd_pcm_direction_name()

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

Yang Wang <kevinyang.wang@amd.com>
    drm/amdgpu: check ASPM on the dGPU host link

Nathan Lucas <nlucasgit@gmail.com>
    drm/amd/display: fix BT.2020 YCbCr limited output CSC matrix

Ilya Bakoulin <Ilya.Bakoulin@amd.com>
    drm/amd/display: Fix BT2020 YCbCr limited/full range input

Kenneth Feng <kenneth.feng@amd.com>
    drm/amd/amdgpu: disable ASPM in some situations

Eric Farman <farman@linux.ibm.com>
    s390/vfio_ccw: Implement a crw lock

Eric Farman <farman@linux.ibm.com>
    s390/vfio_ccw: Calculate idal length based on idaw type

Eric Farman <farman@linux.ibm.com>
    s390/vfio_ccw: Ensure first IDAW remains constant

Eric Farman <farman@linux.ibm.com>
    s390/vfio_ccw: Free all memory if cp_init() fails

Junjie Cao <junjie.cao@intel.com>
    gpio: ml-ioh: use raw_spinlock_t for the register lock

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

Ibrahim Hashimov <security@auditcode.ai>
    xfs: bounds-check buffer log item's dirty bitmap

Christoph Hellwig <hch@lst.de>
    xfs: don't use a xfs_log_iovec for ri_buf in log recovery

Pei Xiao <xiaopei01@kylinos.cn>
    mmc: atmel-mci: Fix use-after-free in atmci_remove due to race condition

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

Jan Sebastian Götte <linux@jaseg.de>
    serial: qcom-geni: fix TX DMA buffer flush

Aditya Chillara <aditya.chillara@oss.qualcomm.com>
    perf/core: Fix group leader use-after-free after sibling detach

Peter Zijlstra <peterz@infradead.org>
    perf: Unify perf_event_free_task() / perf_event_exit_task_context()

Fan Wu <fanwu01@zju.edu.cn>
    serial: amba-pl011: synchronize DMA teardown

Koichiro Den <den@valinux.co.jp>
    NTB: ntb_netdev: Preserve RX queue depth on allocation failure

Griffin Kroah-Hartman <griffin@kroah.com>
    rndis_host: add overflow check in rndis_rx_fixup()

Ali Ahmet Memis <ali@iusegentoo.com>
    Bluetooth: RFCOMM: take rfcomm_mutex for the deferred setup accept

Steffen Persvold <spersvold@gmail.com>
    PCI: host-generic: Fix NULL pointer dereference on 32-bit CAM systems


-------------

Diffstat:

 Makefile                                           |   4 +-
 drivers/block/null_blk/zoned.c                     |  10 +-
 drivers/gpio/gpio-ml-ioh.c                         |  36 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         | 100 ++-
 drivers/gpu/drm/amd/amdgpu/nv.c                    |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   6 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |   2 +-
 drivers/gpu/drm/amd/display/dc/basics/dc_common.c  |   3 +-
 .../gpu/drm/amd/display/dc/core/dc_hw_sequencer.c  |  34 +-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   4 +-
 drivers/gpu/drm/amd/display/dc/dc_hw_types.h       |   4 +-
 .../drm/amd/display/dc/dce/dce_stream_encoder.c    |   3 +-
 .../amd/display/dc/dcn10/dcn10_stream_encoder.c    |   3 +-
 .../display/dc/dcn31/dcn31_hpo_dp_stream_encoder.c |   3 +-
 drivers/gpu/drm/amd/display/dc/inc/hw/dpp.h        |   6 +-
 .../amd/display/modules/info_packet/info_packet.c  |   4 +-
 drivers/hid/hid-core.c                             |  11 +-
 drivers/hid/hid-hyperv.c                           |  27 +-
 drivers/hid/hid-input.c                            |   3 +
 drivers/hid/hid-magicmouse.c                       |  45 +-
 drivers/hid/hid-nintendo.c                         |   7 +-
 drivers/hid/hid-sensor-custom.c                    |  21 +-
 drivers/input/keyboard/atkbd.c                     |  23 +-
 drivers/input/mouse/byd.c                          |   2 +-
 drivers/mmc/host/atmel-mci.c                       |   2 +
 drivers/net/ntb_netdev.c                           |  15 +-
 drivers/net/usb/rndis_host.c                       |   6 +-
 drivers/nfc/fdp/i2c.c                              |  27 +
 drivers/nfc/microread/microread.c                  |  31 +-
 drivers/nfc/pn533/pn533.c                          |   1 +
 drivers/nfc/st21nfca/dep.c                         |   3 +
 drivers/nvme/target/fabrics-cmd-auth.c             |   2 +-
 drivers/nvme/target/fc.c                           |   2 +-
 drivers/nvme/target/tcp.c                          |   5 +-
 drivers/pci/controller/pci-host-generic.c          |  11 +-
 drivers/pci/ecam.c                                 |  13 +
 drivers/s390/cio/vfio_ccw_chp.c                    |  26 +-
 drivers/s390/cio/vfio_ccw_cp.c                     |  43 +-
 drivers/s390/cio/vfio_ccw_cp.h                     |   2 +
 drivers/s390/cio/vfio_ccw_drv.c                    |   6 +
 drivers/s390/cio/vfio_ccw_ops.c                    |   4 +
 drivers/s390/cio/vfio_ccw_private.h                |   4 +
 drivers/tty/serial/amba-pl011.c                    |   8 +-
 drivers/tty/serial/qcom_geni_serial.c              |  51 +-
 drivers/tty/serial/sc16is7xx.c                     | 222 +++---
 fs/ext4/xattr.c                                    |   7 +-
 fs/ocfs2/xattr.c                                   |  18 +-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |  14 +
 fs/xfs/libxfs/xfs_log_recover.h                    |   4 +-
 fs/xfs/xfs_attr_item.c                             |  24 +-
 fs/xfs/xfs_bmap_item.c                             |  18 +-
 fs/xfs/xfs_buf_item.c                              |   8 +-
 fs/xfs/xfs_buf_item.h                              |   2 +-
 fs/xfs/xfs_buf_item_recover.c                      |  95 ++-
 fs/xfs/xfs_dquot_item_recover.c                    |  20 +-
 fs/xfs/xfs_extfree_item.c                          |  43 +-
 fs/xfs/xfs_icreate_item.c                          |   2 +-
 fs/xfs/xfs_inode_item.c                            |   6 +-
 fs/xfs/xfs_inode_item.h                            |   4 +-
 fs/xfs/xfs_inode_item_recover.c                    |  26 +-
 fs/xfs/xfs_log_recover.c                           |  16 +-
 fs/xfs/xfs_refcount_item.c                         |  16 +-
 fs/xfs/xfs_rmap_item.c                             |  16 +-
 fs/xfs/xfs_trans.h                                 |   1 -
 include/linux/pci-ecam.h                           |   3 +
 include/linux/sched.h                              |   8 +
 include/net/inet_frag.h                            |   6 +-
 include/net/ipv6_frag.h                            |   5 +-
 kernel/events/core.c                               | 161 ++---
 kernel/kcov.c                                      |  90 +--
 lib/Kconfig.debug                                  |   5 +-
 net/bluetooth/hci_event.c                          |   8 +-
 net/bluetooth/hci_sync.c                           | 137 +++-
 net/bluetooth/rfcomm/core.c                        |  24 +-
 net/ceph/osd_client.c                              |   5 +-
 net/ieee802154/6lowpan/reassembly.c                |  27 +-
 net/ipv4/inet_fragment.c                           |  33 +-
 net/ipv4/ip_fragment.c                             |  48 +-
 net/ipv4/ip_output.c                               |   4 +
 net/ipv6/ip6_output.c                              |   2 +
 net/ipv6/ndisc.c                                   |   8 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |  27 +-
 net/ipv6/reassembly.c                              |  29 +-
 net/mptcp/pm_netlink.c                             |   9 +-
 net/mptcp/pm_userspace.c                           |   7 +-
 net/mptcp/protocol.c                               |   9 +
 net/mptcp/protocol.h                               |   7 +-
 net/nfc/digital_technology.c                       |   2 +
 net/nfc/llcp_commands.c                            |  18 +-
 net/nfc/llcp_core.c                                |  15 +-
 net/nfc/nci/ntf.c                                  |  10 +-
 net/nfc/nci/rsp.c                                  |   1 +
 net/xfrm/xfrm_state.c                              |   4 +-
 security/selinux/include/security.h                |   1 +
 security/selinux/ss/avtab.c                        |  45 +-
 security/selinux/ss/avtab.h                        |  23 +-
 security/selinux/ss/conditional.c                  |  40 +-
 security/selinux/ss/conditional.h                  |   6 +-
 security/selinux/ss/constraint.h                   |   1 +
 security/selinux/ss/ebitmap.c                      |   4 +-
 security/selinux/ss/ebitmap.h                      |   5 +-
 security/selinux/ss/mls.c                          |   6 +-
 security/selinux/ss/policydb.c                     | 743 +++++++++++++--------
 security/selinux/ss/policydb.h                     | 249 +++----
 security/selinux/ss/services.c                     |   8 +-
 sound/drivers/dummy.c                              |   6 +
 sound/soc/codecs/lpass-tx-macro.c                  |   4 +-
 sound/soc/sof/ipc3-pcm.c                           |  13 +-
 sound/soc/sof/ipc3-topology.c                      |  20 +-
 sound/soc/sof/ipc4-pcm.c                           |  35 +-
 sound/soc/sof/ipc4-topology.c                      |  18 +-
 sound/soc/sof/pcm.c                                | 157 +++--
 sound/soc/sof/sof-audio.c                          |  36 -
 sound/soc/sof/sof-audio.h                          |  17 +-
 115 files changed, 2047 insertions(+), 1291 deletions(-)


