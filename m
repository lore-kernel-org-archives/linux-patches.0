Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE1F4AA403;
	Mon, 31 Aug 2026 13:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184009; cv=none; b=s7iiFsITrvQ/gmKsNxLuZr6zQoWrDFetI4Iwa6es+MCxR+Red2TJh7JDSzotbcOsr6WBaB1JJ/UY1kN2Z2feiHYwuRU25/lGSPaz2A65wHii7duZYhelCMxIHknGyf4C2sLlrSzIdQEoRSjTcxS1AmX4tjCq1/I1eRJsT9HrhFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184009; c=relaxed/simple;
	bh=gfPGG30TMT0Qzaau8CtQZ22zNjQPSKQVJpDXwi1PXX8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hDKBxuRi58eg5VcfG6m7g/SpGmGNSBN8K7xYonuSZZfI11uykYAzYIkh/BkzMfFQDZjLleqqev4qkXnI5jgd8nQ9lOMJZbDkyIcdOfVDBOtQCicN/ZtF7Mstj+UgMIciABDmNEt6d7LVPfLLhyFNxw4JbfVy1MBbZAcf/q95/Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ndqe0SR8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ndqe0SR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2ED1F00ADF;
	Mon, 31 Aug 2026 13:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184002;
	bh=7NGFQby2y4MJ/GdPhOxA1q0AB/3nUFGVIreRpYhMDBE=;
	h=From:To:Cc:Subject:Date;
	b=Ndqe0SR8o6qoszyNHK1uDipqa1P0aA9asxikYStSjAL84pvO4nPwZduoNye3kAVPv
	 G7UMlXi0qVF+/4deRfpZQoI0o5eoYx6mLZohD7F5SeX8sKl0utj5gyzsyUzqLzNC9N
	 m8v6EG3ch6ZQ4vwtqu0/rOQfPl2jxl184xxNbcAc=
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
Subject: [PATCH 6.18 00/83] 6.18.49-rc1 review
Date: Mon, 31 Aug 2026 15:33:36 +0200
Message-ID: <20260831133359.207714926@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.49-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.49-rc1
X-KernelTest-Deadline: 2026-09-02T13:34+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.49 release.
There are 83 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.49-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.49-rc1

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

Jan Sebastian Götte <linux@jaseg.de>
    crypto: krb5 - use kfree_sensitive() for derived key buffers

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-tdes - use scatterlist length before DMA mapping

Eric Biggers <ebiggers@kernel.org>
    crypto: qcom-rng - Allow zero as a random number

Eric Biggers <ebiggers@kernel.org>
    crypto: qcom-rng - Remove crypto_rng interface

Eric Biggers <ebiggers@kernel.org>
    crypto: qcom-rng - Enable clock in hwrng case

Bryam Vargas <hexlabsecurity@proton.me>
    crypto: virtio - bound the akcipher result length

Eric Biggers <ebiggers@kernel.org>
    kunit: irq: Continue increasing hrtimer interval for longer

Eric Biggers <ebiggers@kernel.org>
    mm/swap: reject swapon() on filesystem-level encrypted files

Fourie Zhang <littleddfu@gmail.com>
    netfilter: nf_tables: don't queue packet path object notifications

Eric Biggers <ebiggers@kernel.org>
    netfilter: nft_set_pipapo_avx2: add missing vzeroupper

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

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Wire up kvm_x86_ops.gmem_xxx() if and only if CONFIG_KVM_AMD_SEV=y

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Mark vCPU RUNNABLE after AP_CREATE, even if VMSA is unusable

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Extract loading of guest-provided VMSA to a separate helper

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Track the GPA of the guest-controlled VMSA used for SNP guests

Pankaj Gupta <pankaj.gupta@amd.com>
    KVM: SEV: Drop FOLL_WRITE for encrypted region registration

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

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Handle bogus TRB pointers in Missed Service Error events

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    accessibility: speakup: unregister tty ldisc on later init failures

Griffin Kroah-Hartman <griffin@kroah.com>
    fpga: dfl: fme: add error handling

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: harden file lifetime during session teardown

Raman Varabets <kernel-linux-20260610-80b7ab08@raman.v1.sg>
    HID: ft260: fix stack-use-after-return write in I2C read race

Michael Zaidman <michael.zaidman@gmail.com>
    HID: ft260: validate i2c input report length

Jann Horn <jannh@google.com>
    HID: asus: fix missing hid_is_usb() check

Antheas Kapenekakis <lkml@antheas.dev>
    HID: asus: simplify RGB init sequence

Jose Villaseñor Montfort <pepemontfort@gmail.com>
    HID: magicmouse: prevent unbounded recursion in magicmouse_raw_event()

Jens Axboe <axboe@kernel.dk>
    io_uring: defer eventfd signaling when queued from a wakeup handler

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/rsrc: improve regbuf iov validation

Caleb Sander Mateos <csander@purestorage.com>
    io_uring: simplify IORING_SETUP_DEFER_TASKRUN && !SQPOLL check

Jens Axboe <axboe@kernel.dk>
    io_uring/futex: only mark private futex waits as inflight

Aboorva Devarajan <aboorvad@linux.ibm.com>
    powerpc/hv-gpci: fix preempt count leak in sysfs show paths

Jesper Dangaard Brouer <hawk@kernel.org>
    veth: fix OOB txq access in veth_poll() with asymmetric queue counts

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: switch two allocations to use kzalloc_objs()

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ASoC: nau8821: Cancel pending work before suspend

Michael Neuling <mikey@neuling.org>
    riscv: Fix register corruption from uninitialized cregs on error

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix use-after-free in offloaded map/prog info fill

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ASoC: nau8821: Cancel delayed work on component remove

Bryam Vargas <hexlabsecurity@proton.me>
    selinux: require a class's permission values to cover its permission count

Bryam Vargas <hexlabsecurity@proton.me>
    selinux: reject a permission value exceeding the class permission count

Christian Göttsche <cgzones@googlemail.com>
    selinux: more strict policy parsing

Christian Göttsche <cgzones@googlemail.com>
    selinux: use u16 for security classes

Wentao Guan <guanwentao@uniontech.com>
    Revert "selinux: reject a permission value exceeding the class permission count"

Dmitry Bogdanov <d.bogdanov@yadro.com>
    nvme-tcp: fix usage of page_frag_cache

Jinu Kim <kimjw04271234@gmail.com>
    KVM: x86/mmu: Check write tracking in all address spaces

Jia Yao <jia.yao@intel.com>
    drm/xe/guc_ads: use uncached mapping for UM queue BO

Jia Yao <jia.yao@intel.com>
    drm/xe/guc_ads: allocate UM queues in VRAM on dGFX

Jia Yao <jia.yao@intel.com>
    drm/xe/guc_ads: allocate UM queues in a separate BO

Peiyang He <peiyang_he@smail.nju.edu.cn>
    RDMA/rxe: Fix OOB in free_rd_atomic_resources()

Ibrahim Hashimov <security@auditcode.ai>
    RDMA/rxe: Fix responder UAF on IB_QP_MAX_DEST_RD_ATOMIC modify_qp


-------------

Diffstat:

 Documentation/filesystems/fscrypt.rst              |   4 +
 Makefile                                           |   4 +-
 arch/powerpc/perf/hv-gpci.c                        |  24 +-
 arch/riscv/kernel/compat_signal.c                  |   2 +
 arch/riscv/kernel/ptrace.c                         |   4 +-
 arch/s390/kvm/vsie.c                               |   1 +
 arch/x86/kernel/cpu/amd.c                          |   1 +
 arch/x86/kvm/mmu/page_track.c                      |  32 ++-
 arch/x86/kvm/svm/sev.c                             |  76 +++---
 arch/x86/kvm/svm/svm.c                             |   8 +-
 arch/x86/kvm/svm/svm.h                             |  13 +-
 crypto/krb5/krb5_api.c                             |   8 +-
 drivers/accessibility/speakup/main.c               |   1 +
 drivers/crypto/Kconfig                             |   1 -
 drivers/crypto/atmel-tdes.c                        |   5 +-
 drivers/crypto/mxs-dcp.c                           |   2 +-
 drivers/crypto/qce/aead.c                          |  58 +----
 drivers/crypto/qce/common.c                        |  55 +----
 drivers/crypto/qce/common.h                        |  16 +-
 drivers/crypto/qce/regs-v5.h                       |   4 -
 drivers/crypto/qce/sha.c                           |  30 +--
 drivers/crypto/qce/sha.h                           |   1 -
 drivers/crypto/qce/skcipher.c                      |  97 +-------
 drivers/crypto/qcom-rng.c                          | 156 ++-----------
 .../crypto/virtio/virtio_crypto_akcipher_algs.c    |   3 +-
 drivers/fpga/dfl-fme-perf.c                        |   2 +
 drivers/gpu/drm/xe/xe_bo.h                         |  14 ++
 drivers/gpu/drm/xe/xe_guc_ads.c                    |  92 +++++---
 drivers/gpu/drm/xe/xe_guc_ads_types.h              |   5 +
 drivers/hid/hid-asus.c                             |  52 ++---
 drivers/hid/hid-ft260.c                            |  41 +++-
 drivers/hid/hid-magicmouse.c                       |  25 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |  18 +-
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
 drivers/usb/host/xhci-ring.c                       |  20 +-
 drivers/usb/misc/usbtest.c                         |   1 +
 drivers/usb/serial/option.c                        |  20 +-
 drivers/usb/serial/spcp8x5.c                       |  13 --
 fs/fuse/dir.c                                      |   9 +-
 fs/fuse/file.c                                     |   4 +-
 fs/smb/server/smb2pdu.c                            |   6 +-
 fs/smb/server/vfs_cache.c                          | 179 +++++++++++++--
 fs/smb/server/vfs_cache.h                          |   4 +-
 include/kunit/run-in-irq-context.h                 |  10 +-
 include/linux/io_uring_types.h                     |   8 +
 include/linux/skbuff.h                             |  24 ++
 include/target/target_core_fabric.h                |   2 +
 io_uring/eventfd.c                                 |   8 +-
 io_uring/eventfd.h                                 |   2 +-
 io_uring/futex.c                                   |  21 +-
 io_uring/io_uring.c                                |   7 +-
 io_uring/poll.c                                    |  23 +-
 io_uring/rsrc.c                                    |  31 +--
 io_uring/waitid.c                                  |   2 +-
 kernel/bpf/offload.c                               |  10 +-
 mm/swapfile.c                                      |   7 +
 net/batman-adv/tvlv.c                              |   5 +-
 net/bridge/br_multicast.c                          |   4 +-
 net/ipv4/tcp_ao.c                                  |  19 +-
 net/ipv6/ah6.c                                     |  29 ++-
 net/ipv6/seg6_local.c                              |   7 +
 net/netfilter/nf_tables_api.c                      |  36 +--
 net/netfilter/nft_set_pipapo_avx2.c                |  17 +-
 net/tls/tls_device.c                               |   3 +-
 net/xfrm/espintcp.c                                |   9 +-
 net/xfrm/xfrm_nat_keepalive.c                      |  53 ++++-
 net/xfrm/xfrm_user.c                               |   2 +-
 security/selinux/include/security.h                |   1 +
 security/selinux/ss/avtab.c                        |  35 ++-
 security/selinux/ss/avtab.h                        |  13 ++
 security/selinux/ss/conditional.c                  |  25 +-
 security/selinux/ss/constraint.h                   |   1 +
 security/selinux/ss/policydb.c                     | 254 +++++++++++++++++----
 security/selinux/ss/policydb.h                     |  31 ++-
 security/selinux/ss/services.c                     |   8 +-
 sound/soc/codecs/nau8821.c                         |  13 ++
 sound/usb/card.c                                   |  14 +-
 sound/usb/midi.c                                   |   2 +
 88 files changed, 1156 insertions(+), 776 deletions(-)


