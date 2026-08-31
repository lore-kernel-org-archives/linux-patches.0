Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0663A582B9A;
	Mon, 31 Aug 2026 13:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184205; cv=none; b=qCnnFqa+2Vl1iBoCjTOxUfdE1IwqFlgql8apFDfu9TrfbIEi0j8RiMQXg3RsdcLMs+J0Onlo6flLSiKbHLUSiG/hF8j1q0IvUWWIJNnkPCg5DDFejrgRMOm+aAjYeLaiYUJI558swiAEO7kwqwUYKrZIs2AaPHOqqm2CnKBSEOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184205; c=relaxed/simple;
	bh=HKC4sZjaSuaf7OUx5APi4ZeR8wVuw/KZQNx3gISLiHY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bBSHMPI2Rr1DhWfEzrD6b5Io3tVoLXUJ//D1/FQ4ZR9j6FQnGlPPF3PrVI3L84WPnFhaMB4T4Dlzc1+1mWFZqo8UAnOFJIy9pWxNd3iHLt+FTcErkuZHbLMntQKSwe+9sz5Xkl9MwehssGgr8R6zL1pT0YRTpahMTpgKcmKM3II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1SGmYSY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1SGmYSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767831F00A3F;
	Mon, 31 Aug 2026 13:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184202;
	bh=/V/R84HYagfrQHP9x+qpQlp8wSVoSk4YQr8HNEbEa+g=;
	h=From:To:Cc:Subject:Date;
	b=g1SGmYSY5vnQwhjOGVdLA851WohN6LKnxexFpUaENml1f7wZZzaw5loB3Gl1ungCG
	 92VqxpmAqQmcoEaUWn5I8ctCqWTD4DT/Wgd8dB2NakHzZ5acQXFRFBwQ5ewMLNmeLg
	 KvOf/feMwqe4JV54yZr9QusECAIiouRnjBC8QCYM=
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
Subject: [PATCH 6.12 00/99] 6.12.108-rc1 review
Date: Mon, 31 Aug 2026 15:33:29 +0200
Message-ID: <20260831133359.740409777@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.108-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.108-rc1
X-KernelTest-Deadline: 2026-09-02T13:34+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.108 release.
There are 99 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.108-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.108-rc1

Miguel Peñaranda <mig.penaranda07@gmail.com>
    usb: usbfs: fix use-after-free of usb_device in usbdev_release()

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt7925: ensure tx headroom in usb_sdio_tx_prepare_skb

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
    crypto: qcom-rng - Remove crypto_rng interface

Eric Biggers <ebiggers@kernel.org>
    crypto: qcom-rng - Allow zero as a random number

Eric Biggers <ebiggers@kernel.org>
    crypto: qcom-rng - Enable clock in hwrng case

Eric Biggers <ebiggers@kernel.org>
    mm/swap: reject swapon() on filesystem-level encrypted files

Fourie Zhang <littleddfu@gmail.com>
    netfilter: nf_tables: don't queue packet path object notifications

Kyle Zeng <kylebot@openai.com>
    vxlan: keep the last remote linked during FDB flush

Kyle Zeng <kylebot@openai.com>
    batman-adv: reject unrepresentable multicast TVLV offsets

Kyle Zeng <kylebot@openai.com>
    ipv6: seg6: clear IPv4 control block on IPIP decapsulation

Norbert Szetei <norbert@doyensec.com>
    net: bridge: mcast: fix use-after-free of a master VLAN's multicast context

Zihan Xi <zihanx@nebusec.ai>
    xfrm: bound nat keepalive state collection

Zihan Xi <zihanx@nebusec.ai>
    xfrm: fix xfrm_state_construct() auth-trunc leak

Asim Viladi Oglu Manizada <manizada@pm.me>
    xfrm: ah6: validate routing header segments_left

Zihan Xi <xizh2024@lzu.edu.cn>
    xfrm: avoid lock inversion in nat keepalive work

Zhiling Zou <roxy520tt@gmail.com>
    xfrm: drop ESP-in-TCP packets with no ingress device

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: espintcp: fix UAF during close

Hyunwoo Kim <imv4bel@gmail.com>
    net/tcp-ao: fix use-after-free of current_key on reconnect to another peer

Qing Ming <a0yami@mailbox.org>
    tcp: fix AO info use-after-free in tcp_ao_connect_init()

Rastislav Szabo <rastislav.szabo@isovalent.com>
    net/tcp: fix TCP-AO key deletion in VRFs

Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>
    x86/CPU/AMD: Carve out a Zen5 models range

Qing Ming <a0yami@mailbox.org>
    gtp: serialize PDP context updates

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

Jose Villaseñor Montfort <pepemontfort@gmail.com>
    HID: magicmouse: prevent unbounded recursion in magicmouse_raw_event()

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_sync: Fix accept list UAF during suspend

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: hci_sync: Use bt_dev_err() to log error message in hci_update_event_filter_sync()

Ibrahim Hashimov <security@auditcode.ai>
    HID: uclogic: fix use-after-free of inrange_timer on remove

Raman Varabets <kernel-linux-20260610-80b7ab08@raman.v1.sg>
    HID: ft260: fix stack-use-after-return write in I2C read race

Michael Zaidman <michael.zaidman@gmail.com>
    HID: ft260: validate i2c input report length

Jann Horn <jannh@google.com>
    HID: asus: fix missing hid_is_usb() check

Antheas Kapenekakis <lkml@antheas.dev>
    HID: asus: simplify RGB init sequence

Baul Lee <baul.lee@xbow.com>
    HID: pidff: fix OOB write when hid->inputs is empty

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: clang-format pass

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Use ARRAY_SIZE macro instead of sizeof

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Rework pidff_set_time() to fix warnings

Bryam Vargas <hexlabsecurity@proton.me>
    nfc: nci: add data_len bound checks to activation parameter extractors

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: reject invalid block index in GC ioctl

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: correct return value kernel-doc descriptions for ioctl functions

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: harden file lifetime during session teardown

Aboorva Devarajan <aboorvad@linux.ibm.com>
    powerpc/hv-gpci: fix preempt count leak in sysfs show paths

Jesper Dangaard Brouer <hawk@kernel.org>
    veth: fix OOB txq access in veth_poll() with asymmetric queue counts

Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
    ring buffer: Propagate __rb_map_vma return value to caller

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

Kyle Zeng <kylebot@openai.com>
    perf: Reject exited events as group leaders

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

Carlos Llamas <cmllamas@google.com>
    HID: uhid: convert to hid_safe_input_report()

Dmitry Bogdanov <d.bogdanov@yadro.com>
    nvme-tcp: fix usage of page_frag_cache

Vishnu Razdan <vrazdan@openai.com>
    io_uring/io-wq: fix worker accounting when canceling creation callbacks

Eric Biggers <ebiggers@kernel.org>
    ext4: don't enable DAX on new encrypted files

Jinu Kim <kimjw04271234@gmail.com>
    KVM: x86/mmu: Check write tracking in all address spaces

Peiyang He <peiyang_he@smail.nju.edu.cn>
    RDMA/rxe: Fix OOB in free_rd_atomic_resources()

Ibrahim Hashimov <security@auditcode.ai>
    RDMA/rxe: Fix responder UAF on IB_QP_MAX_DEST_RD_ATOMIC modify_qp


-------------

Diffstat:

 Documentation/filesystems/fscrypt.rst              |   4 +
 Makefile                                           |   4 +-
 arch/arm64/kvm/arm.c                               |   6 +
 arch/powerpc/perf/hv-gpci.c                        |  24 +-
 arch/riscv/kernel/compat_signal.c                  |   2 +
 arch/riscv/kernel/ptrace.c                         |   4 +-
 arch/s390/kvm/vsie.c                               |   1 +
 arch/x86/kernel/cpu/amd.c                          |   1 +
 arch/x86/kvm/mmu/page_track.c                      |  32 +-
 drivers/accessibility/speakup/main.c               |   1 +
 drivers/base/power/main.c                          |   6 +-
 drivers/crypto/Kconfig                             |   1 -
 drivers/crypto/atmel-tdes.c                        |   5 +-
 drivers/crypto/mxs-dcp.c                           |   2 +-
 drivers/crypto/qce/aead.c                          |  58 +---
 drivers/crypto/qce/common.c                        |  55 +--
 drivers/crypto/qce/common.h                        |  16 +-
 drivers/crypto/qce/regs-v5.h                       |   4 -
 drivers/crypto/qce/sha.c                           |  30 +-
 drivers/crypto/qce/sha.h                           |   1 -
 drivers/crypto/qce/skcipher.c                      |  97 +-----
 drivers/crypto/qcom-rng.c                          | 156 ++-------
 drivers/fpga/dfl-fme-perf.c                        |   2 +
 drivers/hid/hid-asus.c                             |  52 ++-
 drivers/hid/hid-ft260.c                            |  41 ++-
 drivers/hid/hid-magicmouse.c                       |  25 +-
 drivers/hid/hid-uclogic-core.c                     |  12 +-
 drivers/hid/uhid.c                                 |   8 +-
 drivers/hid/usbhid/hid-pidff.c                     | 106 +++---
 drivers/infiniband/sw/rxe/rxe_qp.c                 |  18 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |  12 +-
 .../platform/samsung/exynos4-is/fimc-is-regs.c     |   1 +
 drivers/net/ethernet/ibm/ibmvnic.c                 |  30 +-
 drivers/net/gtp.c                                  |  21 +-
 drivers/net/veth.c                                 |   3 +-
 drivers/net/vxlan/vxlan_core.c                     |  11 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |   4 +
 drivers/nvme/host/tcp.c                            |   8 +
 drivers/target/target_core_fabric_configfs.c       |   8 +
 drivers/usb/c67x00/c67x00-sched.c                  |   4 +-
 drivers/usb/core/devio.c                           |   2 +-
 drivers/usb/core/hub.c                             |   7 +-
 drivers/usb/gadget/function/f_tcm.c                |   2 +-
 drivers/usb/host/xhci-dbgtty.c                     |  15 +-
 drivers/usb/host/xhci-ring.c                       |   2 +-
 drivers/usb/misc/usbtest.c                         |   1 +
 drivers/usb/serial/option.c                        |  20 +-
 drivers/usb/serial/spcp8x5.c                       |  13 -
 fs/exfat/nls.c                                     |   1 +
 fs/ext4/crypto.c                                   |  40 +--
 fs/ext4/ialloc.c                                   |   4 +
 fs/fuse/dir.c                                      |   9 +-
 fs/fuse/file.c                                     |   4 +-
 fs/jfs/inode.c                                     |   2 +-
 fs/jfs/jfs_discard.c                               |   3 +-
 fs/jfs/jfs_extent.c                                |  10 +
 fs/nilfs2/ioctl.c                                  | 251 +++++++-------
 fs/smb/server/smb2pdu.c                            |   6 +-
 fs/smb/server/vfs_cache.c                          | 179 ++++++++--
 fs/smb/server/vfs_cache.h                          |   4 +-
 include/linux/skbuff.h                             |  24 ++
 include/target/target_core_fabric.h                |   2 +
 io_uring/io-wq.c                                   |   9 +-
 kernel/bpf/offload.c                               |  10 +-
 kernel/events/core.c                               |  10 +
 kernel/trace/ring_buffer.c                         |   2 +-
 mm/swapfile.c                                      |   7 +
 net/batman-adv/tvlv.c                              |   5 +-
 net/bluetooth/hci_sync.c                           |  48 ++-
 net/bridge/br_multicast.c                          |   4 +-
 net/can/j1939/j1939-priv.h                         |   1 +
 net/can/j1939/main.c                               |   5 +
 net/can/j1939/socket.c                             |  55 +++
 net/ipv4/tcp_ao.c                                  |  19 +-
 net/ipv6/ah6.c                                     |  29 +-
 net/ipv6/seg6_local.c                              |   7 +
 net/netfilter/nf_tables_api.c                      |  36 +-
 net/nfc/nci/ntf.c                                  |  26 +-
 net/smc/smc_clc.c                                  |  67 ++--
 net/smc/smc_core.c                                 |  27 +-
 net/smc/smc_pnet.c                                 |  43 +--
 net/tls/tls_device.c                               |   3 +-
 net/xfrm/espintcp.c                                |   9 +-
 net/xfrm/xfrm_nat_keepalive.c                      |  53 ++-
 net/xfrm/xfrm_user.c                               |   2 +-
 security/selinux/include/security.h                |   1 +
 security/selinux/ss/avtab.c                        |  43 ++-
 security/selinux/ss/avtab.h                        |  21 +-
 security/selinux/ss/conditional.c                  |  47 +--
 security/selinux/ss/conditional.h                  |   6 +-
 security/selinux/ss/constraint.h                   |   1 +
 security/selinux/ss/ebitmap.c                      |   4 +-
 security/selinux/ss/ebitmap.h                      |   5 +-
 security/selinux/ss/mls.c                          |   6 +-
 security/selinux/ss/policydb.c                     | 375 +++++++++++++++------
 security/selinux/ss/policydb.h                     |  51 ++-
 security/selinux/ss/services.c                     |   8 +-
 sound/soc/codecs/nau8821.c                         |  13 +
 sound/usb/card.c                                   |  14 +-
 sound/usb/midi.c                                   |   2 +
 100 files changed, 1484 insertions(+), 1067 deletions(-)


