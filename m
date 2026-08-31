Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28BF49B1FD;
	Mon, 31 Aug 2026 13:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183577; cv=none; b=m7Bl2OMvDAUHjg5fzAQl1gC8NL4VeamcyILkUg8jjPvfXQEhyAKfhestCVd5GQTmC4jlNYU+t21+lzyESVZbKAvq3MS1Gdge9IvsXBLqehlpRoBMVDkbNzPHJPKIut2RTbqz+CWF6/CeixryCLBrpZUmCMqgGJAhuYpNowJMIjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183577; c=relaxed/simple;
	bh=6qSS0Ta9kd27hMotfZgmmBb0m4yzXJK7wE0Mzms2r2A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KyHjgWol6z+X1X345XAXoRqd/ouNB4Dh42pKy+mW1vij4enxlWKr8CfEhl5USHrTds9shHPSk75Tz/0xcn1MhaTfMzSPW8nlI97ljx6XWIN13sbRISnmZNlgSg3dO5n2kVhM46L1SlXxenlFlQ5LLCmDL4cw3uxYFpSLM/gO1Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxIXhE1U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxIXhE1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7571F000E9;
	Mon, 31 Aug 2026 13:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183575;
	bh=6wy/mnOCVGabFaecKdCZZTSflQm2rkdTDN6gFPgOVPg=;
	h=From:To:Cc:Subject:Date;
	b=LxIXhE1UWbvD+gsLOde6MNoxtYCTgbuqurJ3+c6Lwjyz7627Ig1l9h87zxKJW1hes
	 gGmDcGleDSwU++7TlKeuu4DlOva5BWdfdMuDGGOExbXxB27CPr5Xz7dsE5hU0vFAA9
	 adP8JwCceN92kWZx3MAbAwItIT8S9/CDwbETpc+s=
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
Subject: [PATCH 7.2 00/71] 7.2.3-rc1 review
Date: Mon, 31 Aug 2026 15:33:25 +0200
Message-ID: <20260831133359.055927882@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.3-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.2.3-rc1
X-KernelTest-Deadline: 2026-09-02T13:34+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.2.3 release.
There are 71 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.3-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.2.3-rc1

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

Trevor Vorhees <vorhees-work@proton.me>
    ALSA: usb-audio: Fix sample rates for PreSonus AudioBox USB

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

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: iaa - fall back to software for multi-entry scatterlists

Md Sadre Alam <md.alam@oss.qualcomm.com>
    crypto: qce - fix CCM AAD buffer underallocation

Jan Sebastian Götte <linux@jaseg.de>
    crypto: krb5 - use kfree_sensitive() for derived key buffers

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-tdes - use scatterlist length before DMA mapping

Eric Biggers <ebiggers@kernel.org>
    crypto: sun8i-ss - Remove crypto_rng interface

Eric Biggers <ebiggers@kernel.org>
    crypto: sun8i-ce - Remove crypto_rng interface

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

Kyle Zeng <kylebot@openai.com>
    net/packet: defer vmalloc TX_RING free until skbs finish

Eric Dumazet <edumazet@google.com>
    vlan: fix skb_under_panic and races when toggling HW VLAN offload

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

Yong Wang <edragain@163.com>
    tcp: clamp route advmss to TCP_MIN_MSS

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: espintcp: fix UAF during close

Jiayuan Chen <jiayuan.chen@linux.dev>
    net: advertise TCP MSS from the configured MTU, not the learned PMTU

Hyunwoo Kim <imv4bel@gmail.com>
    net/tcp-ao: fix use-after-free of current_key on reconnect to another peer

Qing Ming <a0yami@mailbox.org>
    tcp: fix AO info use-after-free in tcp_ao_connect_init()

Rastislav Szabo <rastislav.szabo@isovalent.com>
    net/tcp: fix TCP-AO key deletion in VRFs

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

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Allocate full pages for {DE,EN}CRYPT ops on SNP-enabled hosts

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    usb: gadget: f_tcm: keep port count until LUN teardown completes

Aleksandr Nogikh <nogikh@google.com>
    usb: usbtest: disable dynamic ID support

Baokun Li <libaokun@linux.alibaba.com>
    fuse: fix invalidate lock leak on open O_TRUNC DAX failure

Baokun Li <libaokun@linux.alibaba.com>
    fuse: fix invalidate lock leak on setattr writeback failure

Rochan Avlur <rochan.avlur@gmail.com>
    fuse: wait for FR_FINISHED on abort_on_kill to prevent use-after-free

Joanne Koong <joannelkoong@gmail.com>
    fuse: publish io-uring queues with release semantics

Joanne Koong <joannelkoong@gmail.com>
    fuse: fix missing barrier when checking io-uring readiness

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix race between interrupt and resend

Lucas De Marchi <ldemarchi@nvidia.com>
    xhci: dbgtty: Fix unregister on tty_alloc_driver() failure

Lucas De Marchi <ldemarchi@nvidia.com>
    xhci: dbgtty: Fix unregister on tty_register_driver() failure

Breno Leitao <leitao@debian.org>
    usb: xhci: bail out of setup if the controller is inaccessible

Semih Baskan <strst.gs@gmail.com>
    usb: xhci: Handle USB3 port events when there is one roothub

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Handle bogus TRB pointers in Missed Service Error events

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    accessibility: speakup: unregister tty ldisc on later init failures

Griffin Kroah-Hartman <griffin@kroah.com>
    fpga: dfl: fme: add error handling

Jiayuan Chen <jiayuan.chen@linux.dev>
    selftests/bpf: Fix test_maps sockmap failure

Dmitry Bogdanov <d.bogdanov@yadro.com>
    nvme-tcp: fix usage of page_frag_cache

Peiyang He <peiyang_he@smail.nju.edu.cn>
    RDMA/rxe: Fix OOB in free_rd_atomic_resources()

Ibrahim Hashimov <security@auditcode.ai>
    RDMA/rxe: Fix responder UAF on IB_QP_MAX_DEST_RD_ATOMIC modify_qp


-------------

Diffstat:

 Documentation/filesystems/fscrypt.rst              |   4 +
 Makefile                                           |   4 +-
 arch/s390/kvm/vsie.c                               |   1 +
 arch/x86/kvm/svm/sev.c                             |  99 ++++++++----
 arch/x86/kvm/svm/svm.c                             |   8 +-
 arch/x86/kvm/svm/svm.h                             |  13 +-
 crypto/krb5/krb5_api.c                             |   8 +-
 drivers/accessibility/speakup/main.c               |   1 +
 drivers/crypto/Kconfig                             |   1 -
 drivers/crypto/allwinner/Kconfig                   |  16 --
 drivers/crypto/allwinner/sun8i-ce/Makefile         |   1 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |  63 --------
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c  | 159 ------------------
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |  29 ----
 drivers/crypto/allwinner/sun8i-ss/Makefile         |   1 -
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c  |  45 ------
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c  | 177 ---------------------
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h       |  23 ---
 drivers/crypto/atmel-tdes.c                        |   5 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c         | 111 +++++++------
 drivers/crypto/intel/iaa/iaa_crypto_stats.c        |   9 ++
 drivers/crypto/intel/iaa/iaa_crypto_stats.h        |   2 +
 drivers/crypto/mxs-dcp.c                           |   2 +-
 drivers/crypto/qce/aead.c                          |  58 +------
 drivers/crypto/qce/common.c                        |  55 ++-----
 drivers/crypto/qce/common.h                        |  16 +-
 drivers/crypto/qce/regs-v5.h                       |   4 -
 drivers/crypto/qce/sha.c                           |  30 +---
 drivers/crypto/qce/sha.h                           |   1 -
 drivers/crypto/qce/skcipher.c                      |  97 +----------
 drivers/crypto/qcom-rng.c                          | 156 +++---------------
 .../crypto/virtio/virtio_crypto_akcipher_algs.c    |   3 +-
 drivers/fpga/dfl-fme-perf.c                        |   2 +
 drivers/infiniband/sw/rxe/rxe_qp.c                 |  18 ++-
 drivers/net/gtp.c                                  |  21 ++-
 drivers/net/vxlan/vxlan_core.c                     |  11 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |   4 +
 drivers/nvme/host/tcp.c                            |   8 +
 drivers/target/target_core_fabric_configfs.c       |   8 +
 drivers/usb/c67x00/c67x00-sched.c                  |   4 +-
 drivers/usb/core/devio.c                           |   2 +-
 drivers/usb/core/hub.c                             |   7 +-
 drivers/usb/gadget/function/f_tcm.c                |   2 +-
 drivers/usb/host/xhci-dbgtty.c                     |  15 +-
 drivers/usb/host/xhci-ring.c                       |  20 ++-
 drivers/usb/host/xhci.c                            |  11 +-
 drivers/usb/misc/usbtest.c                         |   1 +
 drivers/usb/serial/option.c                        |  20 ++-
 drivers/usb/serial/spcp8x5.c                       |  13 --
 fs/fuse/dev.c                                      |  41 ++---
 fs/fuse/dev_uring.c                                |  20 +--
 fs/fuse/dir.c                                      |   9 +-
 fs/fuse/file.c                                     |   4 +-
 include/kunit/run-in-irq-context.h                 |  10 +-
 include/linux/skbuff.h                             |  24 +++
 include/net/ip.h                                   |  25 +++
 include/net/ip6_route.h                            |  37 +++++
 include/net/tcp.h                                  |   5 +
 include/target/target_core_fabric.h                |   2 +
 mm/swapfile.c                                      |   7 +
 net/8021q/vlan_dev.c                               |  39 +----
 net/batman-adv/tvlv.c                              |   5 +-
 net/bridge/br_multicast.c                          |   4 +-
 net/ipv4/route.c                                   |   4 +-
 net/ipv4/tcp_ao.c                                  |  19 ++-
 net/ipv4/tcp_ipv4.c                                |   2 +-
 net/ipv4/tcp_minisocks.c                           |   2 +-
 net/ipv4/tcp_output.c                              |   6 +-
 net/ipv6/ah6.c                                     |  29 ++--
 net/ipv6/route.c                                   |   2 +-
 net/ipv6/seg6_local.c                              |   7 +
 net/ipv6/tcp_ipv6.c                                |   2 +-
 net/netfilter/nf_tables_api.c                      |  36 +++--
 net/netfilter/nft_set_pipapo_avx2.c                |  17 +-
 net/packet/af_packet.c                             |  96 +++++++++--
 net/tls/tls_device.c                               |   3 +-
 net/xfrm/espintcp.c                                |   9 +-
 net/xfrm/xfrm_nat_keepalive.c                      |  53 ++++--
 net/xfrm/xfrm_user.c                               |   2 +-
 sound/usb/card.c                                   |  14 +-
 sound/usb/midi.c                                   |   2 +
 sound/usb/quirks-table.h                           |  10 ++
 .../selftests/bpf/progs/sockmap_verdict_prog.c     |  14 +-
 83 files changed, 748 insertions(+), 1182 deletions(-)


