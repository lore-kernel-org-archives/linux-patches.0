Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E15F476CC0;
	Mon, 31 Aug 2026 13:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184507; cv=none; b=GInh+ICNJV1E31tuW6LkVldG/6CZASugSPI9of7VgsctpJJloNAtcvmMDU8ks5ieacVwNMWabIDC2iWtouM05W15ibisCvJCBgVldeYFf5sdgPivEHJbby1Pu9FXZNWmPoFws+O8Z+cTkkUTHxgEovnRUJorDIfZ/2PXNhS7sDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184507; c=relaxed/simple;
	bh=5IeptGrjrJZ/H8B8MPOngiWHxura80i0Jck0n4aEzyA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=me3tj0AbfBE4+BAEEqhk5/MUqrf7vUXTpd4+LF3hAL4pPmcZ1EZlDxE6m2A3BN6dE4MIoJtXHzcKoaQgo5uI8sfnhWWsx7JgC5v2H3OP5f9vESj5rJdA+SbGXfWwVREPfC8pr3Z+J1Zf/GAvKuU0vQWoseF8ovG1st93koSGXEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zfwZVXPf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zfwZVXPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A1D1F000E9;
	Mon, 31 Aug 2026 13:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184505;
	bh=52shDqKXY/Jl2zeRps0CjY7gAnaNRkO1dMT/8Wpsvpg=;
	h=From:To:Cc:Subject:Date;
	b=zfwZVXPfqbL1G3AK1ebwrbTM029m1ItUwVAmALKhXTLzU79zLa3FPa42YDLwfFxoF
	 0GbFqJUCppZHMeEYxun9nEjVGgP/dzbfllRU1EGmjF2DPXHUzxX39++PaVNLt0wrd+
	 wEaXCcqvIk0W3xTyeihrKKVsWA+x3oeqO6H1zNqs=
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
Subject: [PATCH 6.6 00/91] 6.6.156-rc1 review
Date: Mon, 31 Aug 2026 15:33:48 +0200
Message-ID: <20260831133359.468089036@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.156-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.156-rc1
X-KernelTest-Deadline: 2026-09-02T13:34+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.156 release.
There are 91 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.156-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.156-rc1

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

Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>
    x86/CPU/AMD: Carve out a Zen5 models range

Perry Yuan <perry.yuan@amd.com>
    x86/CPU/AMD: Add models 0x60-0x6f to the Zen5 range

Wenkuan Wang <Wenkuan.Wang@amd.com>
    x86/CPU/AMD: Add models 0x10-0x1f to the Zen5 range

Mario Limonciello <mario.limonciello@amd.com>
    x86/CPU/AMD: Add more models to X86_FEATURE_ZEN5

Borislav Petkov (AMD) <bp@alien8.de>
    x86/CPU/AMD: Add X86_FEATURE_ZEN5

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

Darrick J. Wong <djwong@kernel.org>
    xfs: remove file_path tracepoint data

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_sync: Fix accept list UAF during suspend

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: hci_sync: Use bt_dev_err() to log error message in hci_update_event_filter_sync()

Baul Lee <baul.lee@xbow.com>
    HID: pidff: fix OOB write when hid->inputs is empty

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: clang-format pass

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Support device error response from PID_BLOCK_LOAD

Ibrahim Hashimov <security@auditcode.ai>
    HID: uclogic: fix use-after-free of inrange_timer on remove

Raman Varabets <kernel-linux-20260610-80b7ab08@raman.v1.sg>
    HID: ft260: fix stack-use-after-return write in I2C read race

Michael Zaidman <michael.zaidman@gmail.com>
    HID: ft260: validate i2c input report length

Jiangshan Yi <yijiangshan@kylinos.cn>
    HID: nintendo: stop device IO before hid_hw_stop on probe failure

Ibrahim Hashimov <security@auditcode.ai>
    nvmet-tcp: bound SGL data length before allocating command buffers

Weiwen Hu <huweiwen@linux.alibaba.com>
    nvme: rename CDR/MORE/DNR to NVME_STATUS_*

Weiwen Hu <huweiwen@linux.alibaba.com>
    nvme: fix status magic numbers

Weiwen Hu <huweiwen@linux.alibaba.com>
    nvme: rename nvme_sc_to_pr_err to nvme_status_to_pr_err

Jose Villaseñor Montfort <pepemontfort@gmail.com>
    HID: magicmouse: prevent unbounded recursion in magicmouse_raw_event()

Christopher Kodama <ckhordiasma@gmail.com>
    HID: magicmouse: re-enable multitouch after reset-resume

Bryam Vargas <hexlabsecurity@proton.me>
    nfc: nci: add data_len bound checks to activation parameter extractors

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: reject invalid block index in GC ioctl

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: correct return value kernel-doc descriptions for ioctl functions

Guanghui Yang <3497809730@qq.com>
    ext4: propagate errors from fast commit range replay

Baokun Li <libaokun1@huawei.com>
    ext4: make some fast commit functions reuse extents path

Kemeng Shi <shikemeng@huaweicloud.com>
    ext4: make state in ext4_mb_mark_bb to be bool

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: harden file lifetime during session teardown

Jia Jie Ho <jiajie.ho@starfivetech.com>
    crypto: starfive - Do not free stack buffer

Aboorva Devarajan <aboorvad@linux.ibm.com>
    powerpc/hv-gpci: fix preempt count leak in sysfs show paths

Johannes Berg <johannes.berg@intel.com>
    net/sched: initialize noop_qdisc owner

Eric Dumazet <edumazet@google.com>
    net/sched: Fix mirred deadlock on device recursion

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

Kyle Zeng <kylebot@openai.com>
    perf: Reject exited events as group leaders

Tao Lyu <tao.lyu@epfl.ch>
    bpf: Ensure reg is PTR_TO_STACK in process_iter_arg

Ralf Lici <ralf@mandelbit.com>
    Revert "usb: phy: fsl-usb: Fix use-after-free in delayed work during device removal"

Vishnu Razdan <vrazdan@openai.com>
    io_uring/io-wq: fix worker accounting when canceling creation callbacks

Eric Biggers <ebiggers@kernel.org>
    ext4: don't enable DAX on new encrypted files

Jinu Kim <kimjw04271234@gmail.com>
    KVM: x86/mmu: Check write tracking in all address spaces

Peiyang He <peiyang_he@smail.nju.edu.cn>
    RDMA/rxe: Fix OOB in free_rd_atomic_resources()


-------------

Diffstat:

 Documentation/filesystems/fscrypt.rst              |   4 +
 Makefile                                           |   4 +-
 arch/arm64/kvm/arm.c                               |   6 +
 arch/powerpc/perf/hv-gpci.c                        |  24 +-
 arch/riscv/kernel/compat_signal.c                  |   2 +
 arch/riscv/kernel/ptrace.c                         |   4 +-
 arch/s390/kvm/vsie.c                               |   1 +
 arch/x86/include/asm/cpufeatures.h                 |   4 +-
 arch/x86/kernel/cpu/amd.c                          |  28 ++-
 arch/x86/kvm/mmu/page_track.c                      |  32 ++-
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
 drivers/crypto/starfive/jh7110-rsa.c               |   1 -
 drivers/fpga/dfl-fme-perf.c                        |   2 +
 drivers/hid/hid-ft260.c                            |  41 +++-
 drivers/hid/hid-magicmouse.c                       |  44 +++-
 drivers/hid/hid-nintendo.c                         |  13 +-
 drivers/hid/hid-uclogic-core.c                     |  12 +-
 drivers/hid/usbhid/hid-pidff.c                     |  21 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   3 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |  12 +-
 .../platform/samsung/exynos4-is/fimc-is-regs.c     |   1 +
 drivers/net/ethernet/ibm/ibmvnic.c                 |  30 ++-
 drivers/nvme/host/constants.c                      |   2 +-
 drivers/nvme/host/core.c                           |  32 +--
 drivers/nvme/host/fabrics.c                        |   8 +-
 drivers/nvme/host/fault_inject.c                   |   2 +-
 drivers/nvme/host/fc.c                             |   8 +-
 drivers/nvme/host/multipath.c                      |   2 +-
 drivers/nvme/host/nvme.h                           |   4 +-
 drivers/nvme/host/pr.c                             |  10 +-
 drivers/nvme/target/admin-cmd.c                    |  24 +-
 drivers/nvme/target/core.c                         |  46 ++--
 drivers/nvme/target/discovery.c                    |  14 +-
 drivers/nvme/target/fabrics-cmd-auth.c             |  16 +-
 drivers/nvme/target/fabrics-cmd.c                  |  36 +--
 drivers/nvme/target/io-cmd-bdev.c                  |  12 +-
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
 fs/ext4/ext4.h                                     |   2 +-
 fs/ext4/extents.c                                  |  55 ++---
 fs/ext4/fast_commit.c                              |  35 ++-
 fs/ext4/ialloc.c                                   |   4 +
 fs/ext4/mballoc.c                                  |   4 +-
 fs/fuse/dir.c                                      |   9 +-
 fs/fuse/file.c                                     |   4 +-
 fs/jfs/inode.c                                     |   2 +-
 fs/jfs/jfs_discard.c                               |   3 +-
 fs/jfs/jfs_extent.c                                |  10 +
 fs/nilfs2/ioctl.c                                  | 251 ++++++++++-----------
 fs/smb/server/smb2pdu.c                            |   6 +-
 fs/smb/server/vfs_cache.c                          | 179 +++++++++++++--
 fs/smb/server/vfs_cache.h                          |   4 +-
 fs/xfs/scrub/trace.h                               |  12 +-
 include/linux/nvme.h                               |  16 +-
 include/net/sch_generic.h                          |   1 +
 include/target/target_core_fabric.h                |   2 +
 io_uring/io-wq.c                                   |   9 +-
 kernel/bpf/offload.c                               |  10 +-
 kernel/bpf/verifier.c                              |   5 +
 kernel/events/core.c                               |  10 +
 mm/swapfile.c                                      |   7 +
 net/bluetooth/hci_sync.c                           |  48 +++-
 net/bridge/br_multicast.c                          |   4 +-
 net/can/j1939/j1939-priv.h                         |   1 +
 net/can/j1939/main.c                               |   5 +
 net/can/j1939/socket.c                             |  55 +++++
 net/core/dev.c                                     |   6 +
 net/core/filter.c                                  |   1 -
 net/ipv6/ah6.c                                     |  29 ++-
 net/ipv6/seg6_local.c                              |   7 +
 net/nfc/nci/ntf.c                                  |  26 ++-
 net/sched/sch_generic.c                            |   2 +
 net/smc/smc_clc.c                                  |  67 +++---
 net/smc/smc_core.c                                 |  27 +--
 net/smc/smc_pnet.c                                 |  43 ++--
 net/tls/tls_device.c                               |   3 +-
 net/xfrm/espintcp.c                                |   9 +-
 net/xfrm/xfrm_user.c                               |   2 +-
 security/selinux/ss/conditional.c                  |  12 +-
 sound/soc/codecs/nau8821.c                         |  13 ++
 sound/usb/card.c                                   |  14 +-
 sound/usb/midi.c                                   |   2 +
 107 files changed, 1133 insertions(+), 846 deletions(-)


