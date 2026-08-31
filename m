Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C3F43030D;
	Mon, 31 Aug 2026 13:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184755; cv=none; b=Jj/9Vd2ExjrcNzV3UGyyDcN9M9k35DMvIz3PxisOKmmEz4LQEZNmYZnGCmKK77lBLbRKrW184P5sosJd05Q5PUp5gcQkJHk9xJ691kT4jTE2dB+q5IKfTWiu/cCb6u0sqo52jjkKnNLgrk5UQMwYhMd/BrGa68iLmJ8bmzPlRCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184755; c=relaxed/simple;
	bh=ACCLGO3/r4QmiKyi89MaFgK9OcZYFB8vk9EbCPRF7rM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LpyZYeJ0Q1z324jBIuzrZZFRDLa7Pdw0GrYJ6YIEPrT/33MgFZN0pP8f8Tzji2szCcEbdEoNhQcWxA3fYI5VSI5HIc8sWUI75oyQvDotGMwHoiWsLXSnL+C2yKzJ+wewLhQIHclGc7Mj93rbFgAcaroPkX93j5PW869K29j33og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QjrW7+CF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QjrW7+CF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9571F000E9;
	Mon, 31 Aug 2026 13:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184753;
	bh=o7q5vDHv5KJVZOo7/ZGjyRnFTnTT/nsF9CuLOETY9Jw=;
	h=From:To:Cc:Subject:Date;
	b=QjrW7+CFZ7mt299AOQtyIN/TYk9NRBs7+MKSY2LEdBSt9FKLv3xZ8uxlHR0CEjsFa
	 sQemj+Pf1OPgtdVCtBzHWfLE13oIy6iNkP5dHzRcBfYn33pGklMWgER/MRCT7z+r8r
	 o0ol//tkLrzvESdak64j8uFU6S6B8VzGdXzXqj1E=
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
Subject: [PATCH 6.1 00/92] 6.1.187-rc1 review
Date: Mon, 31 Aug 2026 15:33:58 +0200
Message-ID: <20260831133359.482388899@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.187-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.187-rc1
X-KernelTest-Deadline: 2026-09-02T13:34+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.187 release.
There are 92 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.187-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.187-rc1

Miguel Peñaranda <mig.penaranda07@gmail.com>
    usb: usbfs: fix use-after-free of usb_device in usbdev_release()

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    USB: c67x00: fix use-after-free in c67x00_add_iso_urb()

Johan Hovold <johan@kernel.org>
    USB: serial: spcp8x5: drop broken carrier detect support

Jiale Yao <yaojiale02@163.com>
    USB: serial: option: fix slab OOB read in interrupt URB callback

Will Porter <mrwillporter@gmail.com>
    ALSA: usb-audio: Complete cleanup after system-resume errors

Marouane El Moufid <eun0us@espilon.net>
    ALSA: usb-audio: fix OOB write in snd_usbmidi_novation_output()

Griffin Kroah-Hartman <griffin@kroah.com>
    usb: core: Strengthen error handling in hub_hub_status()

Griffin Kroah-Hartman <griffin@kroah.com>
    usb: core: Add lock to usb_wakeup_notification()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix hci_conn_hash_lookup_cis

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: vsie: zero stale crypto bits

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    crypto: qce - Remove unsafe/deprecated algorithms

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: mxs-dcp - fix source scatterlist length access

Md Sadre Alam <md.alam@oss.qualcomm.com>
    crypto: qce - fix CCM AAD buffer underallocation

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-tdes - use scatterlist length before DMA mapping

Eric Biggers <ebiggers@kernel.org>
    mm/swap: reject swapon() on filesystem-level encrypted files

Kyle Zeng <kylebot@openai.com>
    ipv6: seg6: clear IPv4 control block on IPIP decapsulation

Norbert Szetei <norbert@doyensec.com>
    net: bridge: mcast: fix use-after-free of a master VLAN's multicast context

Zihan Xi <zihanx@nebusec.ai>
    xfrm: fix xfrm_state_construct() auth-trunc leak

Asim Viladi Oglu Manizada <manizada@pm.me>
    xfrm: ah6: validate routing header segments_left

Zhiling Zou <roxy520tt@gmail.com>
    xfrm: drop ESP-in-TCP packets with no ingress device

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: espintcp: fix UAF during close

Jiayuan Chen <jiayuan.chen@linux.dev>
    tls: device: fix out-of-bounds write in tls_append_frag()

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    usb: gadget: f_tcm: keep port count until LUN teardown completes

Aleksandr Nogikh <nogikh@google.com>
    usb: usbtest: disable dynamic ID support

Baokun Li <libaokun@linux.alibaba.com>
    fuse: fix invalidate lock leak on open O_TRUNC DAX failure

Baokun Li <libaokun@linux.alibaba.com>
    fuse: fix invalidate lock leak on setattr writeback failure

Lucas De Marchi <ldemarchi@nvidia.com>
    xhci: dbgtty: Fix unregister on tty_alloc_driver() failure

Lucas De Marchi <ldemarchi@nvidia.com>
    xhci: dbgtty: Fix unregister on tty_register_driver() failure

Semih Baskan <strst.gs@gmail.com>
    usb: xhci: Handle USB3 port events when there is one roothub

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    accessibility: speakup: unregister tty ldisc on later init failures

Griffin Kroah-Hartman <griffin@kroah.com>
    fpga: dfl: fme: add error handling

Eric Dumazet <edumazet@google.com>
    ipv4: igmp: Fix potential UAF in igmp_gq_start_timer()

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    Bluetooth: hci_event: validate LE Set CIG Parameters response

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_event: fix Set CIG Parameters error status handling

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: use correct CIS order in Set CIG Parameters event

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_conn: Fix not matching by CIS ID

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_sync: Fix accept list UAF during suspend

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: hci_sync: Use bt_dev_err() to log error message in hci_update_event_filter_sync()

Raman Varabets <kernel-linux-20260610-80b7ab08@raman.v1.sg>
    HID: ft260: fix stack-use-after-return write in I2C read race

Michael Zaidman <michael.zaidman@gmail.com>
    HID: ft260: validate i2c input report length

Michael Zaidman <michael.zaidman@gmail.com>
    HID: ft260: missed NACK from busy device

Michael Zaidman <michael.zaidman@gmail.com>
    HID: ft260: wake up device from power saving mode

Michael Zaidman <michael.zaidman@gmail.com>
    HID: ft260: skip unexpected HID input reports

Michael Zaidman <michael.zaidman@gmail.com>
    HID: ft260: improve i2c large reads performance

Michael Zaidman <michael.zaidman@gmail.com>
    HID: ft260: improve i2c write performance

Ibrahim Hashimov <security@auditcode.ai>
    HID: uclogic: fix use-after-free of inrange_timer on remove

Jiangshan Yi <yijiangshan@kylinos.cn>
    HID: nintendo: stop device IO before hid_hw_stop on probe failure

Ibrahim Hashimov <security@auditcode.ai>
    nvmet-tcp: bound SGL data length before allocating command buffers

Weiwen Hu <huweiwen@linux.alibaba.com>
    nvme: rename CDR/MORE/DNR to NVME_STATUS_*

Christopher Kodama <ckhordiasma@gmail.com>
    HID: magicmouse: re-enable multitouch after reset-resume

Jose Villaseñor Montfort <pepemontfort@gmail.com>
    HID: magicmouse: prevent unbounded recursion in magicmouse_raw_event()

Andrei Fed <andfed.net@gmail.com>
    HID: magicmouse: fix battery reporting for Bluetooth Magic Trackpad USB-C

Bryam Vargas <hexlabsecurity@proton.me>
    nfc: nci: add data_len bound checks to activation parameter extractors

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: reject invalid block index in GC ioctl

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: correct return value kernel-doc descriptions for ioctl functions

Guanghui Yang <3497809730@qq.com>
    ext4: propagate errors from fast commit range replay

Shardul Bankar <shardul.b@mpiricsoftware.com>
    mptcp: pm: fix memory leak from alloc-during-teardown race

Christoph Hellwig <hch@lst.de>
    block: make bio_check_eod work for zero sized devices

Jon Hunter <jonathanh@nvidia.com>
    ASoC: tegra: Fix Master Volume Control

Sasha Levin <sashal@kernel.org>
    Revert "smb: client: use kvzalloc() for megabyte buffer in simple fallocate"

Sasha Levin <sashal@kernel.org>
    Revert "mtd: maps: vmu-flash: fix fault in unaligned fixup"

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: switch two allocations to use kzalloc_objs()

Kuniyuki Iwashima <kuniyu@google.com>
    smc: Use __sk_dst_get() and dst_dev_rcu() in smc_vlan_by_tcpsk().

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ASoC: nau8821: Cancel pending work before suspend

Sasha Levin <sashal@kernel.org>
    Revert "PM: sleep: Use complete() in device_pm_sleep_init()"

Michael Neuling <mikey@neuling.org>
    riscv: Fix register corruption from uninitialized cregs on error

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix use-after-free in offloaded map/prog info fill

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ASoC: nau8821: Cancel delayed work on component remove

Kuniyuki Iwashima <kuniyu@google.com>
    smc: Use __sk_dst_get() and dst_dev_rcu() in smc_clc_prfx_match().

Kuniyuki Iwashima <kuniyu@google.com>
    smc: Use __sk_dst_get() and dst_dev_rcu() in in smc_clc_prfx_set().

Oliver Upton <oliver.upton@linux.dev>
    KVM: arm64: Prevent access to vCPU events before init

Kuniyuki Iwashima <kuniyu@google.com>
    smc: Fix use-after-free in __pnet_find_base_ndev().

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: make j1939_sk_bind() fail if device is no longer registered

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: add missing calls in NETDEV_UNREGISTER notification handler

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: implement NETDEV_UNREGISTER notification handler

Vladimir Riabchun <ferr.lambarginio@gmail.com>
    mISDN: hfcpci: Fix warning when deleting uninitialized timer

Wentao Liang <vulab@iscas.ac.cn>
    media: platform: exynos4-is: Add hardware sync wait to fimc_is_hw_change_mode()

Namjae Jeon <linkinjeon@kernel.org>
    exfat: fix double free in delayed_free

Dylan Wolff <wolffd@comp.nus.edu.sg>
    jfs: Fix null-ptr-deref in jfs_ioc_trim

Nick Child <nnac123@linux.ibm.com>
    ibmvnic: Use kernel helpers for hex dumps

Vasiliy Kovalev <kovalev@altlinux.org>
    jfs: add check read-only before txBeginAnon() call

Vasiliy Kovalev <kovalev@altlinux.org>
    jfs: add check read-only before truncation in jfs_truncate_nolock()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    bpf: Remove tst_run from lwt_seg6local_prog_ops.

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/kms/nv50-: init hpd_irq_lock for PIOR DP

Ziyang Huang <hzyitc@outlook.com>
    wifi: ath11k: Add missing hw_ops->get_ring_selector() for IPQ5018

Ralf Lici <ralf@mandelbit.com>
    Revert "usb: phy: fsl-usb: Fix use-after-free in delayed work during device removal"

Florian Westphal <fw@strlen.de>
    ipvs: reload ip header after head reallocation

Vishnu Razdan <vrazdan@openai.com>
    io_uring/io-wq: fix worker accounting when canceling creation callbacks

Eric Biggers <ebiggers@kernel.org>
    ext4: don't enable DAX on new encrypted files

Jinu Kim <kimjw04271234@gmail.com>
    KVM: x86/mmu: Check write tracking in all address spaces

Eric Dumazet <edumazet@google.com>
    inet: RAW sockets using IPPROTO_RAW MUST drop incoming ICMP

Peiyang He <peiyang_he@smail.nju.edu.cn>
    RDMA/rxe: Fix OOB in free_rd_atomic_resources()


-------------

Diffstat:

 Documentation/filesystems/fscrypt.rst              |   4 +
 Makefile                                           |   4 +-
 arch/arm64/kvm/arm.c                               |   6 +
 arch/riscv/kernel/compat_signal.c                  |   2 +
 arch/riscv/kernel/ptrace.c                         |   4 +-
 arch/s390/kvm/vsie.c                               |   1 +
 arch/x86/kvm/mmu/page_track.c                      |  28 ++-
 block/blk-core.c                                   |   2 +-
 drivers/accessibility/speakup/main.c               |   1 +
 drivers/base/power/main.c                          |   6 +-
 drivers/crypto/atmel-tdes.c                        |   5 +-
 drivers/crypto/mxs-dcp.c                           |   2 +-
 drivers/crypto/qce/aead.c                          |  58 +----
 drivers/crypto/qce/common.c                        |  55 +----
 drivers/crypto/qce/common.h                        |  16 +-
 drivers/crypto/qce/regs-v5.h                       |   4 -
 drivers/crypto/qce/sha.c                           |  30 +--
 drivers/crypto/qce/sha.h                           |   1 -
 drivers/crypto/qce/skcipher.c                      |  97 +-------
 drivers/fpga/dfl-fme-perf.c                        |   2 +
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |   4 +
 drivers/hid/hid-ft260.c                            | 157 ++++++++++---
 drivers/hid/hid-input.c                            |   3 +
 drivers/hid/hid-magicmouse.c                       |  63 +++++-
 drivers/hid/hid-nintendo.c                         |  13 +-
 drivers/hid/hid-uclogic-core.c                     |  12 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   3 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |  12 +-
 .../platform/samsung/exynos4-is/fimc-is-regs.c     |   1 +
 drivers/mtd/maps/vmu-flash.c                       |   8 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  30 ++-
 drivers/net/wireless/ath/ath11k/hw.c               |   2 +-
 drivers/nvme/host/core.c                           |  18 +-
 drivers/nvme/host/fabrics.c                        |   8 +-
 drivers/nvme/host/fault_inject.c                   |   2 +-
 drivers/nvme/host/fc.c                             |   8 +-
 drivers/nvme/target/admin-cmd.c                    |  22 +-
 drivers/nvme/target/core.c                         |  46 ++--
 drivers/nvme/target/discovery.c                    |  14 +-
 drivers/nvme/target/fabrics-cmd-auth.c             |  16 +-
 drivers/nvme/target/fabrics-cmd.c                  |  36 +--
 drivers/nvme/target/io-cmd-bdev.c                  |  12 +-
 drivers/nvme/target/nvmet.h                        |   2 +-
 drivers/nvme/target/passthru.c                     |  10 +-
 drivers/nvme/target/rdma.c                         |  10 +-
 drivers/nvme/target/tcp.c                          |  17 +-
 drivers/nvme/target/zns.c                          |  30 +--
 drivers/target/target_core_fabric_configfs.c       |   8 +
 drivers/usb/c67x00/c67x00-sched.c                  |   4 +-
 drivers/usb/core/devio.c                           |   2 +-
 drivers/usb/core/hub.c                             |   7 +-
 drivers/usb/gadget/function/f_tcm.c                |   2 +-
 drivers/usb/host/xhci-dbgtty.c                     |  15 +-
 drivers/usb/host/xhci-ring.c                       |   2 +-
 drivers/usb/misc/usbtest.c                         |   1 +
 drivers/usb/phy/phy-fsl-usb.c                      |   1 -
 drivers/usb/serial/option.c                        |  20 +-
 drivers/usb/serial/spcp8x5.c                       |  13 --
 fs/exfat/nls.c                                     |   1 +
 fs/ext4/crypto.c                                   |  40 ++--
 fs/ext4/fast_commit.c                              |  10 +-
 fs/ext4/ialloc.c                                   |   4 +
 fs/fuse/dir.c                                      |   9 +-
 fs/fuse/file.c                                     |   4 +-
 fs/jfs/inode.c                                     |   2 +-
 fs/jfs/jfs_discard.c                               |   3 +-
 fs/jfs/jfs_extent.c                                |  10 +
 fs/nilfs2/ioctl.c                                  | 251 ++++++++++-----------
 fs/smb/client/smb2ops.c                            |   4 +-
 include/linux/inetdevice.h                         |   5 +
 include/linux/nvme.h                               |   6 +-
 include/net/bluetooth/hci_core.h                   |  15 +-
 include/target/target_core_fabric.h                |   2 +
 io_uring/io-wq.c                                   |   9 +-
 kernel/bpf/offload.c                               |  10 +-
 mm/swapfile.c                                      |   7 +
 net/bluetooth/hci_conn.c                           |   3 +-
 net/bluetooth/hci_event.c                          |  46 ++--
 net/bluetooth/hci_sync.c                           |  48 +++-
 net/bridge/br_multicast.c                          |   4 +-
 net/can/j1939/j1939-priv.h                         |   1 +
 net/can/j1939/main.c                               |   5 +
 net/can/j1939/socket.c                             |  55 +++++
 net/core/filter.c                                  |   1 -
 net/ipv4/icmp.c                                    |  14 +-
 net/ipv4/igmp.c                                    |  14 +-
 net/ipv6/ah6.c                                     |  29 ++-
 net/ipv6/icmp.c                                    |   3 +
 net/ipv6/seg6_local.c                              |   7 +
 net/mptcp/pm_netlink.c                             |   3 +
 net/mptcp/pm_userspace.c                           |  10 +-
 net/mptcp/protocol.c                               |   5 +
 net/mptcp/protocol.h                               |   7 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   6 +-
 net/nfc/nci/ntf.c                                  |  26 ++-
 net/smc/smc_clc.c                                  |  67 +++---
 net/smc/smc_core.c                                 |  27 +--
 net/smc/smc_pnet.c                                 |  43 ++--
 net/tls/tls_device.c                               |   3 +-
 net/xfrm/espintcp.c                                |   9 +-
 net/xfrm/xfrm_user.c                               |   2 +-
 security/selinux/ss/conditional.c                  |  12 +-
 sound/soc/codecs/nau8821.c                         |  13 ++
 sound/soc/tegra/tegra_pcm.c                        |   3 +
 sound/usb/card.c                                   |  14 +-
 sound/usb/midi.c                                   |   2 +
 106 files changed, 1028 insertions(+), 808 deletions(-)


