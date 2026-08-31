Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F51648B389;
	Mon, 31 Aug 2026 14:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185038; cv=none; b=qqhefkLzhctA3QoRoXu94aFWEt4O4V3p/huhKvLZAlEz+20yjGuGLc4+otwwhdqhE/D+8mVwuCFFS8sC6wFoJ/jgYG5dVFWPS9OvGiuR/vJDszDCQCKZr8MLCdvTgR0P8Ndekwt4XnSSsjRsJba4RMn+0jEHjMMS+2tTyKzCOuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185038; c=relaxed/simple;
	bh=+c/Jq0kSJQDA5f4DBytso9p2nuCi3Kg4kagdrPXfpVE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IwuvritGJ5JGt/ip/N57GVZ3RoBvHp9Yy6bvoCzYR9vPwR3kyDmNsGl71nmZcSPQKbwTQiYHikR5AKrxAaviH2n9cH8xtScGkitDoFGxx2LxnGxt7CNVpibXqVapkS2KYYyi+rHR7erIVak1ceVcHJgeg3rwH2+pXzotnUO6uDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gwO5N9cs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gwO5N9cs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5712E1F00A3D;
	Mon, 31 Aug 2026 14:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185036;
	bh=BAWGtlvhwKsFqNMTL/F4ZN6OYJHouXv5fDEdoiiQf6E=;
	h=From:To:Cc:Subject:Date;
	b=gwO5N9cswHdiyXgxShmdJb0WxfKmBp4vhMTYUgiJIx1sLa33DnPfZqRj1LAmrnZQW
	 eli+TLQzxo7E8dSLklvz9Kf1tcec+JUid+lpRuAOIwwzQYrOsxUX192fAkTKTmYDyT
	 IfFfvXpz6pJyycgQOy2H2jV/o0tjYGIs/Sg/ja9U=
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
Subject: [PATCH 5.15 00/69] 5.15.220-rc1 review
Date: Mon, 31 Aug 2026 15:34:33 +0200
Message-ID: <20260831133358.601894154@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.220-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.220-rc1
X-KernelTest-Deadline: 2026-09-02T13:34+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.220 release.
There are 69 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.220-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.220-rc1

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

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    accessibility: speakup: unregister tty ldisc on later init failures

Griffin Kroah-Hartman <griffin@kroah.com>
    fpga: dfl: fme: add error handling

Jose Villaseñor Montfort <pepemontfort@gmail.com>
    HID: input: read battery capacity from its actual report offset

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

Michael Zaidman <michael.zaidman@gmail.com>
    HID: ft260: fix i2c probing for hwmon devices

Ibrahim Hashimov <security@auditcode.ai>
    HID: uclogic: fix use-after-free of inrange_timer on remove

Ibrahim Hashimov <security@auditcode.ai>
    nvmet-tcp: bound SGL data length before allocating command buffers

Weiwen Hu <huweiwen@linux.alibaba.com>
    nvme: rename CDR/MORE/DNR to NVME_STATUS_*

Jose Villaseñor Montfort <pepemontfort@gmail.com>
    HID: magicmouse: prevent unbounded recursion in magicmouse_raw_event()

Bryam Vargas <hexlabsecurity@proton.me>
    nfc: nci: add data_len bound checks to activation parameter extractors

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: reject invalid block index in GC ioctl

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: correct return value kernel-doc descriptions for ioctl functions

Guanghui Yang <3497809730@qq.com>
    ext4: propagate errors from fast commit range replay

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    kcov: fix data corruption and race conditions on PREEMPT_RT

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    kcov: replace local_irq_save() with a local_lock_t

Eric Dumazet <edumazet@google.com>
    ipv4: igmp: Fix potential UAF in igmp_gq_start_timer()

Ji'an Zhou <eilaimemedsnaimel@gmail.com>
    ALSA: PCM: Fix wait queue list corruption in snd_pcm_drain() on linked streams

Mehul Rao <mehulrao@gmail.com>
    ALSA: pcm: fix use-after-free on linked stream runtime in snd_pcm_drain()

Jon Hunter <jonathanh@nvidia.com>
    ASoC: tegra: Fix Master Volume Control

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: pcm: fix wait_time calculations

Sasha Levin <sashal@kernel.org>
    Revert "smb: client: use kvzalloc() for megabyte buffer in simple fallocate"

Sasha Levin <sashal@kernel.org>
    Revert "mtd: maps: vmu-flash: fix fault in unaligned fixup"

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: switch two allocations to use kzalloc_objs()

Kuniyuki Iwashima <kuniyu@google.com>
    smc: Use __sk_dst_get() and dst_dev_rcu() in smc_vlan_by_tcpsk().

Sasha Levin <sashal@kernel.org>
    Revert "PM: sleep: Use complete() in device_pm_sleep_init()"

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix use-after-free in offloaded map/prog info fill

Oliver Upton <oliver.upton@linux.dev>
    KVM: arm64: Prevent access to vCPU events before init

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: make j1939_sk_bind() fail if device is no longer registered

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: add missing calls in NETDEV_UNREGISTER notification handler

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: implement NETDEV_UNREGISTER notification handler

Vasiliy Kovalev <kovalev@altlinux.org>
    jfs: add check read-only before txBeginAnon() call

Vasiliy Kovalev <kovalev@altlinux.org>
    jfs: add check read-only before truncation in jfs_truncate_nolock()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    bpf: Remove tst_run from lwt_seg6local_prog_ops.

Florian Westphal <fw@strlen.de>
    ipvs: reload ip header after head reallocation

Vishnu Razdan <vrazdan@openai.com>
    io_uring/io-wq: fix worker accounting when canceling creation callbacks

Eric Biggers <ebiggers@kernel.org>
    ext4: don't enable DAX on new encrypted files

Peiyang He <peiyang_he@smail.nju.edu.cn>
    RDMA/rxe: Fix OOB in free_rd_atomic_resources()


-------------

Diffstat:

 Documentation/filesystems/fscrypt.rst        |   4 +
 Makefile                                     |   4 +-
 arch/arm64/kvm/arm.c                         |   6 +
 arch/s390/kvm/vsie.c                         |   1 +
 drivers/accessibility/speakup/main.c         |   1 +
 drivers/base/power/main.c                    |   6 +-
 drivers/crypto/atmel-tdes.c                  |   5 +-
 drivers/crypto/mxs-dcp.c                     |   2 +-
 drivers/crypto/qce/aead.c                    |  58 +------
 drivers/crypto/qce/common.c                  |  55 ++----
 drivers/crypto/qce/common.h                  |  16 +-
 drivers/crypto/qce/regs-v5.h                 |   4 -
 drivers/crypto/qce/sha.c                     |  30 +---
 drivers/crypto/qce/sha.h                     |   1 -
 drivers/crypto/qce/skcipher.c                |  97 +----------
 drivers/fpga/dfl-fme-perf.c                  |   2 +
 drivers/hid/hid-ft260.c                      | 162 +++++++++++++----
 drivers/hid/hid-input.c                      |  17 +-
 drivers/hid/hid-magicmouse.c                 |  25 ++-
 drivers/hid/hid-uclogic-core.c               |  12 +-
 drivers/infiniband/sw/rxe/rxe_qp.c           |   3 +-
 drivers/mtd/maps/vmu-flash.c                 |   8 +-
 drivers/nvme/host/core.c                     |  12 +-
 drivers/nvme/host/fabrics.c                  |   8 +-
 drivers/nvme/host/fault_inject.c             |   2 +-
 drivers/nvme/host/fc.c                       |   8 +-
 drivers/nvme/target/admin-cmd.c              |  20 +--
 drivers/nvme/target/core.c                   |  42 ++---
 drivers/nvme/target/discovery.c              |  14 +-
 drivers/nvme/target/fabrics-cmd.c            |  32 ++--
 drivers/nvme/target/io-cmd-bdev.c            |  12 +-
 drivers/nvme/target/nvmet.h                  |   2 +-
 drivers/nvme/target/passthru.c               |  10 +-
 drivers/nvme/target/rdma.c                   |  10 +-
 drivers/nvme/target/tcp.c                    |  17 +-
 drivers/nvme/target/zns.c                    |  30 ++--
 drivers/target/target_core_fabric_configfs.c |   8 +
 drivers/usb/c67x00/c67x00-sched.c            |   4 +-
 drivers/usb/core/devio.c                     |   2 +-
 drivers/usb/core/hub.c                       |   7 +-
 drivers/usb/gadget/function/f_tcm.c          |   2 +-
 drivers/usb/host/xhci-dbgtty.c               |  15 +-
 drivers/usb/misc/usbtest.c                   |   1 +
 drivers/usb/serial/option.c                  |  20 ++-
 drivers/usb/serial/spcp8x5.c                 |  13 --
 fs/cifs/smb2ops.c                            |   4 +-
 fs/ext4/fast_commit.c                        |  10 +-
 fs/ext4/ialloc.c                             |   4 +
 fs/ext4/super.c                              |  40 ++---
 fs/fuse/dir.c                                |   9 +-
 fs/fuse/file.c                               |   4 +-
 fs/jfs/inode.c                               |   2 +-
 fs/jfs/jfs_extent.c                          |  10 ++
 fs/nilfs2/ioctl.c                            | 251 ++++++++++++---------------
 include/linux/hid.h                          |   1 +
 include/linux/inetdevice.h                   |   5 +
 include/linux/nvme.h                         |   4 +-
 include/linux/sched.h                        |   8 +
 include/target/target_core_fabric.h          |   2 +
 io_uring/io-wq.c                             |   9 +-
 kernel/bpf/offload.c                         |  10 +-
 kernel/kcov.c                                | 126 +++++++-------
 lib/Kconfig.debug                            |   5 +-
 mm/swapfile.c                                |   7 +
 net/bridge/br_multicast.c                    |   4 +-
 net/can/j1939/j1939-priv.h                   |   1 +
 net/can/j1939/main.c                         |   5 +
 net/can/j1939/socket.c                       |  55 ++++++
 net/core/filter.c                            |   1 -
 net/ipv4/igmp.c                              |  14 +-
 net/ipv6/ah6.c                               |  29 ++--
 net/ipv6/seg6_local.c                        |   7 +
 net/netfilter/ipvs/ip_vs_xmit.c              |   6 +-
 net/nfc/nci/ntf.c                            |  26 ++-
 net/smc/smc_core.c                           |  27 ++-
 net/xfrm/espintcp.c                          |   9 +-
 net/xfrm/xfrm_user.c                         |   2 +-
 security/selinux/ss/conditional.c            |  12 +-
 sound/core/pcm_lib.c                         |  11 +-
 sound/core/pcm_native.c                      |  32 ++--
 sound/soc/tegra/tegra_pcm.c                  |   3 +
 sound/usb/card.c                             |  14 +-
 sound/usb/midi.c                             |   2 +
 83 files changed, 839 insertions(+), 742 deletions(-)


