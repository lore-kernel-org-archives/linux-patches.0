Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E7A499F1D;
	Mon, 31 Aug 2026 14:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185271; cv=none; b=p7rkcSVBmt78slGfKq+77XldYkrNWcHiVh6lkgY3TalL8l32eSkyCHAEdYc3Ump0HD4aO3ne2fDeGF/vy4SypuZMCJAb2eC5okYFyEWYj4Yc8d/VLFUykzIjGuEdYocwz6bp3xnB2eacgPh1mSCiVJrGCoFiww3lNA7CDjEUaNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185271; c=relaxed/simple;
	bh=WGD//Sintj011sDQRH/oORvc4WwmZkbrgyPasizIIY0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Koc+zbY4vRQMcP5Te9cdz1fE3ODaY38f9C/xKIYm6Kly+OOazAh1aIlWG3NVcuKRZtbzFmE1yiZr5021LSVF4CdqzzxZaTeHBFnoSSNLcVkWomI3agYm7pvkCRi7T1DNTNscAvW0CI2gEXQBmhIwJAF+CBoiuETvLXfcbCkN9aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fYccZnZd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fYccZnZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE711F000E9;
	Mon, 31 Aug 2026 14:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185268;
	bh=I4Uzx3Mz9WmaDDTyAXSSjFIGlpzqXLol+wy0Dz1UefI=;
	h=From:To:Cc:Subject:Date;
	b=fYccZnZdb7IqOrCv+BEUBFCmftc9VyBscXpbNYf8YyLXsZqT46jP1c22eM0sjUBTp
	 XMXvzBktYDfRY+P1S7veJBVYC/n5pZP0+Dx6Nk2WJfwgfe7J5Z0Ejugz8ScAj3L0pg
	 NpQu+R/v6RgGPcJKS28y4K79kwTxrlZdrcSqyZHQ=
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
Subject: [PATCH 5.10 00/43] 5.10.269-rc1 review
Date: Mon, 31 Aug 2026 15:35:08 +0200
Message-ID: <20260831133358.571886287@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.269-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.269-rc1
X-KernelTest-Deadline: 2026-09-02T13:34+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.269 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.269-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.269-rc1

Miguel Peñaranda <mig.penaranda07@gmail.com>
    usb: usbfs: fix use-after-free of usb_device in usbdev_release()

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    USB: c67x00: fix use-after-free in c67x00_add_iso_urb()

Johan Hovold <johan@kernel.org>
    USB: serial: spcp8x5: drop broken carrier detect support

Jiale Yao <yaojiale02@163.com>
    USB: serial: option: fix slab OOB read in interrupt URB callback

Marouane El Moufid <eun0us@espilon.net>
    ALSA: usb-audio: fix OOB write in snd_usbmidi_novation_output()

Griffin Kroah-Hartman <griffin@kroah.com>
    usb: core: Strengthen error handling in hub_hub_status()

Griffin Kroah-Hartman <griffin@kroah.com>
    usb: core: Add lock to usb_wakeup_notification()

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: vsie: zero stale crypto bits

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: mxs-dcp - fix source scatterlist length access

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-tdes - use scatterlist length before DMA mapping

Eric Biggers <ebiggers@kernel.org>
    mm/swap: reject swapon() on filesystem-level encrypted files

Kyle Zeng <kylebot@openai.com>
    ipv6: seg6: clear IPv4 control block on IPIP decapsulation

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

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    accessibility: speakup: unregister tty ldisc on later init failures

Griffin Kroah-Hartman <griffin@kroah.com>
    fpga: dfl: fme: add error handling

Jose Villaseñor Montfort <pepemontfort@gmail.com>
    HID: input: read battery capacity from its actual report offset

Ibrahim Hashimov <security@auditcode.ai>
    nvmet-tcp: bound SGL data length before allocating command buffers

Bryam Vargas <hexlabsecurity@proton.me>
    nfc: nci: add data_len bound checks to activation parameter extractors

Jose Villaseñor Montfort <pepemontfort@gmail.com>
    HID: magicmouse: do not keep a stale msc->input if no input is claimed

Samuel Page <sam@bynar.io>
    nfc: nci: fix uninit-value in the RF discover/activated NTF handlers

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: reject invalid block index in GC ioctl

Guanghui Yang <3497809730@qq.com>
    ext4: propagate errors from fast commit range replay

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    kcov: fix data corruption and race conditions on PREEMPT_RT

Eric Dumazet <edumazet@google.com>
    ipv4: igmp: Fix potential UAF in igmp_gq_start_timer()

Sasha Levin <sashal@kernel.org>
    Revert "smb: client: use kvzalloc() for megabyte buffer in simple fallocate"

Sasha Levin <sashal@kernel.org>
    Revert "mtd: maps: vmu-flash: fix fault in unaligned fixup"

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: switch two allocations to use kzalloc_objs()

Sasha Levin <sashal@kernel.org>
    Revert "PM: sleep: Use complete() in device_pm_sleep_init()"

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix use-after-free in offloaded map/prog info fill

Oliver Upton <oliver.upton@linux.dev>
    KVM: arm64: Prevent access to vCPU events before init

Vasiliy Kovalev <kovalev@altlinux.org>
    jfs: add check read-only before txBeginAnon() call

Vasiliy Kovalev <kovalev@altlinux.org>
    jfs: add check read-only before truncation in jfs_truncate_nolock()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    bpf: Remove tst_run from lwt_seg6local_prog_ops.

Vishnu Razdan <vrazdan@openai.com>
    io_uring/io-wq: fix worker accounting when canceling creation callbacks

Florian Westphal <fw@strlen.de>
    ipvs: reload ip header after head reallocation

Eric Biggers <ebiggers@kernel.org>
    ext4: don't enable DAX on new encrypted files

Ido Schimmel <idosch@nvidia.com>
    ipv6: mcast: Fix use-after-free when processing MLD queries

Peiyang He <peiyang_he@smail.nju.edu.cn>
    RDMA/rxe: Fix OOB in free_rd_atomic_resources()


-------------

Diffstat:

 Documentation/filesystems/fscrypt.rst        |  4 ++
 Makefile                                     |  4 +-
 arch/arm64/kvm/arm.c                         |  6 ++
 arch/s390/kvm/vsie.c                         |  1 +
 drivers/accessibility/speakup/main.c         |  1 +
 drivers/base/power/main.c                    |  6 +-
 drivers/crypto/atmel-tdes.c                  |  5 +-
 drivers/crypto/mxs-dcp.c                     |  2 +-
 drivers/fpga/dfl-fme-perf.c                  |  2 +
 drivers/hid/hid-input.c                      | 17 +++--
 drivers/hid/hid-magicmouse.c                 | 10 +++
 drivers/infiniband/sw/rxe/rxe_qp.c           |  3 +-
 drivers/mtd/maps/vmu-flash.c                 |  8 ++-
 drivers/nvme/target/tcp.c                    | 13 ++++
 drivers/target/target_core_fabric_configfs.c |  8 +++
 drivers/usb/c67x00/c67x00-sched.c            |  4 +-
 drivers/usb/core/devio.c                     |  2 +-
 drivers/usb/core/hub.c                       |  7 ++-
 drivers/usb/gadget/function/f_tcm.c          |  2 +-
 drivers/usb/misc/usbtest.c                   |  1 +
 drivers/usb/serial/option.c                  | 20 +++++-
 drivers/usb/serial/spcp8x5.c                 | 13 ----
 fs/cifs/smb2ops.c                            |  4 +-
 fs/ext4/fast_commit.c                        | 10 ++-
 fs/ext4/ialloc.c                             |  4 ++
 fs/ext4/super.c                              | 40 ++++++------
 fs/jfs/inode.c                               |  2 +-
 fs/jfs/jfs_extent.c                          | 10 +++
 fs/nilfs2/ioctl.c                            | 21 ++++++-
 include/linux/hid.h                          |  1 +
 include/linux/inetdevice.h                   |  5 ++
 include/linux/sched.h                        |  8 +++
 include/target/target_core_fabric.h          |  2 +
 io_uring/io-wq.c                             |  9 ++-
 kernel/bpf/offload.c                         | 10 ++-
 kernel/kcov.c                                | 93 ++++++++++++++--------------
 lib/Kconfig.debug                            |  5 +-
 mm/swapfile.c                                |  7 +++
 net/core/filter.c                            |  1 -
 net/ipv4/igmp.c                              | 14 +++--
 net/ipv6/ah6.c                               | 29 +++++----
 net/ipv6/mcast.c                             |  8 +--
 net/ipv6/seg6_local.c                        |  7 +++
 net/netfilter/ipvs/ip_vs_xmit.c              |  6 +-
 net/nfc/nci/ntf.c                            | 32 ++++++++--
 net/xfrm/espintcp.c                          |  9 ++-
 net/xfrm/xfrm_user.c                         |  2 +-
 security/selinux/ss/conditional.c            | 12 ++--
 sound/usb/midi.c                             |  2 +
 49 files changed, 326 insertions(+), 166 deletions(-)


