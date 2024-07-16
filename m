Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B29F19AD93;
	Tue, 16 Jul 2024 15:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145354; cv=none; b=BBHSF2l6cxf1sPrKonMSkFO/KglyucQ5dRetApxmq1IMfcukpRMq/43ctSVuUefIibjM+RqWPwGOfeU9ft+7bcmoDMDoNVjDNT0RKqAG+4mANDdrS7+S5bRcuFz197GLwqkiHGAR6b+TKljvzxgqHFYfRC3kd4DSyS57NcPNb+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145354; c=relaxed/simple;
	bh=tm7aVMSRW4H5rCz1KUovZQRy1KHvfAsTb8dg+wAylog=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=o4tEHEfuZvffQwQwD+n0AUn3lC1BbH3MalNZmIIF4PEYRGa4z8X2F3rdMoihrGtuqeJqyl7I5xZoowkzSibfaBEEMq9LMRHqDx94uvTFjqX0eyw8ccXeOrj4KdlNm1kPWsyUYsmwx+iSMOlISTh94HTbJQdM1jtuNiDJlf5zdJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+MzSt7M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+MzSt7M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5072C116B1;
	Tue, 16 Jul 2024 15:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145354;
	bh=tm7aVMSRW4H5rCz1KUovZQRy1KHvfAsTb8dg+wAylog=;
	h=From:To:Cc:Subject:Date:From;
	b=k+MzSt7M9IdDoPXLeVyCUOVADM2PdzeHXQwu9z2Z+0quMebFsIfqFbllQtRXyW/Gu
	 9dPXDbHDHUkpK7OGabfcfiha6YQaw1zC0X1Rzd5TPZrxdXOibPKEqKwFXNpwBYEwJ1
	 enkjszU+stmf6ZCBrKvbCFayqE+Gtjw0XynIpw/8=
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
	pavel@denx.de,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	allen.lkml@gmail.com,
	broonie@kernel.org
Subject: [PATCH 6.1 00/96] 6.1.100-rc1 review
Date: Tue, 16 Jul 2024 17:31:11 +0200
Message-ID: <20240716152746.516194097@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.100-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.100-rc1
X-KernelTest-Deadline: 2024-07-18T15:27+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.100 release.
There are 96 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.100-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.100-rc1

Dan Carpenter <dan.carpenter@linaro.org>
    i2c: rcar: fix error code in probe()

Nathan Chancellor <nathan@kernel.org>
    kbuild: Make ld-version.sh more robust against version string changes

Alexandre Chartre <alexandre.chartre@oracle.com>
    x86/bhi: Avoid warning in #DB handler due to BHI mitigation

Brian Gerst <brgerst@gmail.com>
    x86/entry/64: Remove obsolete comment on tracing vs. SYSRET

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: clear NO_RXDMA flag after resetting

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: testunit: avoid re-issued work after read message

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: ensure Gen3+ reset does not disturb local targets

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: introduce Gen4 devices

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: reset controller is mandatory for Gen3+

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: mark HostNotify target address as used

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: bring hardware to known state when probing

John Stultz <jstultz@google.com>
    sched: Move psi_account_irqtime() out of update_rq_clock_task() hotpath

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix kernel bug on rename operation of broken directory

Eduard Zingerman <eddyz87@gmail.com>
    bpf: Allow reads from uninit stack

Paulo Alcantara <pc@manguebit.com>
    cifs: avoid dup prefix path in dfs_get_automount_devname()

Paulo Alcantara <pc@cjr.nz>
    cifs: use origin fullpath for automounts

Jim Mattson <jmattson@google.com>
    x86/retpoline: Move a NOENDBR annotation to the SRSO dummy return thunk

Ekansh Gupta <quic_ekangupt@quicinc.com>
    misc: fastrpc: Copy the complete capability structure to user

Ekansh Gupta <quic_ekangupt@quicinc.com>
    misc: fastrpc: Avoid updating PD type for capability request

Ekansh Gupta <quic_ekangupt@quicinc.com>
    misc: fastrpc: Fix DSP capabilities request

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: send: annotate intentional data race in checking empty queue

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: queueing: annotate intentional data race in cpu round robin

Helge Deller <deller@kernel.org>
    wireguard: allowedips: avoid unaligned 64-bit memory accesses

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: selftests: use acpi=off instead of -no-acpi for recent QEMU

Kuan-Wei Chiu <visitorckw@gmail.com>
    ACPI: processor_idle: Fix invalid comparison with insertion sort for latency

Ilya Dryomov <idryomov@gmail.com>
    libceph: fix race between delayed_work() and ceph_monc_stop()

Audra Mitchell <audra@redhat.com>
    Fix userfaultfd_api to return EINVAL as expected

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Limit mic boost on VAIO PRO PX

Nazar Bilinskyi <nbilinskyi@gmail.com>
    ALSA: hda/realtek: Enable Mute LED on HP 250 G7

Michał Kopeć <michal.kopec@3mdeb.com>
    ALSA: hda/realtek: add quirk for Clevo V5[46]0TU

Armin Wolf <W_Armin@gmx.de>
    platform/x86: toshiba_acpi: Fix array out-of-bounds access

Thomas Weißschuh <linux@weissschuh.net>
    nvmem: core: only change name to fram for current attribute

Joy Chakraborty <joychakr@google.com>
    nvmem: meson-efuse: Fix return value of nvmem callbacks

Joy Chakraborty <joychakr@google.com>
    nvmem: rmem: Fix return value of rmem_read()

Hobin Woo <hobin.woo@samsung.com>
    ksmbd: discard write access to the directory open

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: always resume roothubs if xHC was reset during resume

He Zhe <zhe.he@windriver.com>
    hpet: Support 32-bit userspace

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix duplicate endpoint bug by clearing reserved bits in the descriptor

Lee Jones <lee@kernel.org>
    usb: gadget: configfs: Prevent OOB read/write in usb_string_copy()

WangYuli <wangyuli@uniontech.com>
    USB: Add USB_QUIRK_NO_SET_INTF quirk for START BP-850k

Dmitry Smirnov <d.smirnov@inbox.lv>
    USB: serial: mos7840: fix crash on resume

Vanillan Wang <vanillanwang@163.com>
    USB: serial: option: add Rolling RW350-GL variants

Mank Wang <mank.wang@netprisma.us>
    USB: serial: option: add Netprisma LCUK54 series modules

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add support for Foxconn T99W651

Bjørn Mork <bjorn@mork.no>
    USB: serial: option: add Fibocom FM350-GL

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit FN912 rmnet compositions

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit generic core-dump composition

Ronald Wahl <ronald.wahl@raritan.com>
    net: ks8851: Fix potential TX stall after interface reopen

Ronald Wahl <ronald.wahl@raritan.com>
    net: ks8851: Fix deadlock with the SPI chip variant

Eric Dumazet <edumazet@google.com>
    tcp: avoid too many retransmit packets

Eric Dumazet <edumazet@google.com>
    tcp: use signed arithmetic in tcp_rtx_probe0_timed_out()

Josh Don <joshdon@google.com>
    Revert "sched/fair: Make sure to try to detach at least one movable task"

Steve French <stfrench@microsoft.com>
    cifs: fix setting SecurityFlags to true

Satheesh Paul <psatheesh@marvell.com>
    octeontx2-af: fix issue with IPv4 match for RSS

Kiran Kumar K <kirankumark@marvell.com>
    octeontx2-af: fix issue with IPv6 ext match for RSS

Kiran Kumar K <kirankumark@marvell.com>
    octeontx2-af: extend RSS supported offload types

Michal Mazur <mmazur2@marvell.com>
    octeontx2-af: fix detection of IP layer

Srujana Challa <schalla@marvell.com>
    octeontx2-af: fix a issue with cpt_lf_alloc mailbox

Srujana Challa <schalla@marvell.com>
    octeontx2-af: update cpt lf alloc mailbox

Nithin Dabilpuram <ndabilpuram@marvell.com>
    octeontx2-af: replace cpt slot with lf id on reg write

Chen Ni <nichen@iscas.ac.cn>
    ARM: davinci: Convert comma to semicolon

Richard Fitzgerald <rf@opensource.cirrus.com>
    firmware: cs_dsp: Use strnlen() on name fields in V1 wmfw files

Richard Fitzgerald <rf@opensource.cirrus.com>
    firmware: cs_dsp: Prevent buffer overrun when processing V2 alg headers

Richard Fitzgerald <rf@opensource.cirrus.com>
    firmware: cs_dsp: Validate payload length before processing block

Richard Fitzgerald <rf@opensource.cirrus.com>
    firmware: cs_dsp: Return error if block header overflows file

Richard Fitzgerald <rf@opensource.cirrus.com>
    firmware: cs_dsp: Fix overflow checking of wmfw header

Sven Schnelle <svens@linux.ibm.com>
    s390: Mark psw in __load_psw_mask() as __unitialized

Daniel Borkmann <daniel@iogearbox.net>
    net, sunrpc: Remap EPERM in case of connection failure in xs_tcp_setup_socket

Chengen Du <chengen.du@canonical.com>
    net/sched: Fix UAF when resolving a clash

Kuniyuki Iwashima <kuniyu@amazon.com>
    udp: Set SOCK_RCU_FREE earlier in udp_lib_get_port().

Oleksij Rempel <linux@rempel-privat.de>
    ethtool: netlink: do not return SQI value if link is down

Dmitry Antipov <dmantipov@yandex.ru>
    ppp: reject claimed-as-LCP but actually malformed packets

Jian Hui Lee <jianhui.lee@canonical.com>
    net: ethernet: mtk-star-emac: set mac_managed_pm when probing

Mohammad Shehar Yaar Tausif <sheharyaar48@gmail.com>
    bpf: fix order of args in call to bpf_map_kvcalloc

Martin KaFai Lau <martin.lau@kernel.org>
    bpf: Remove __bpf_local_storage_map_alloc

Yafang Shao <laoar.shao@gmail.com>
    bpf: use bpf_map_kvcalloc in bpf_local_storage

Martin KaFai Lau <martin.lau@kernel.org>
    bpf: Reduce smap->elem_size

Yonghong Song <yhs@fb.com>
    bpf: Refactor some inode/task/sk storage functions for reuse

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: ethernet: lantiq_etop: fix double free in detach

Michal Kubiak <michal.kubiak@intel.com>
    i40e: Fix XDP program unloading while removing the driver

Hugh Dickins <hughd@google.com>
    net: fix rc7's __skb_datagram_iter()

Aleksandr Mishin <amishin@t-argos.ru>
    octeontx2-af: Fix incorrect value output on error path in rvu_check_rsrc_availability()

Geliang Tang <tanggeliang@kylinos.cn>
    skmsg: Skip zero length skb in sk_msg_recvmsg

Oleksij Rempel <linux@rempel-privat.de>
    net: phy: microchip: lan87xx: reinit PHY after cable test

Neal Cardwell <ncardwell@google.com>
    tcp: fix incorrect undo caused by DSACK of TLP retransmit

Brian Foster <bfoster@redhat.com>
    vfs: don't mod negative dentry count when on shrinker list

linke li <lilinke99@qq.com>
    fs/dcache: Re-use value stored to dentry->d_flags instead of re-reading

Jeff Layton <jlayton@kernel.org>
    filelock: fix potential use-after-free in posix_lock_inode

Jingbo Xu <jefflexu@linux.alibaba.com>
    cachefiles: add missing lock protection when polling

Baokun Li <libaokun1@huawei.com>
    cachefiles: cyclic allocation of msg_id to avoid reuse

Hou Tao <houtao1@huawei.com>
    cachefiles: wait for ondemand_object_worker to finish when dropping object

Baokun Li <libaokun1@huawei.com>
    cachefiles: cancel all requests for the object that is being dropped

Baokun Li <libaokun1@huawei.com>
    cachefiles: stop sending new request when dropping object

Jia Zhu <zhujia.zj@bytedance.com>
    cachefiles: narrow the scope of triggering EPOLLIN events in ondemand mode

Baokun Li <libaokun1@huawei.com>
    cachefiles: propagate errors from vfs_getxattr() to avoid infinite loop

Waiman Long <longman@redhat.com>
    mm: prevent derefencing NULL ptr in pfn_section_valid()


-------------

Diffstat:

 Documentation/admin-guide/cifs/usage.rst           |  34 +--
 Makefile                                           |   4 +-
 arch/arm/mach-davinci/pm.c                         |   2 +-
 arch/s390/include/asm/processor.h                  |   2 +-
 arch/x86/entry/entry_64.S                          |  19 +-
 arch/x86/entry/entry_64_compat.S                   |  14 +-
 arch/x86/lib/retpoline.S                           |   2 +-
 drivers/acpi/processor_idle.c                      |  37 ++--
 drivers/char/hpet.c                                |  34 ++-
 drivers/firmware/cirrus/cs_dsp.c                   | 231 +++++++++++++++------
 drivers/i2c/busses/i2c-rcar.c                      |  67 +++---
 drivers/i2c/i2c-core-base.c                        |   1 +
 drivers/i2c/i2c-slave-testunit.c                   |   7 +
 drivers/misc/fastrpc.c                             |  14 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   9 +-
 drivers/net/ethernet/lantiq_etop.c                 |   4 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  10 +-
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |   8 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cpt.c    |  33 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  67 +++++-
 drivers/net/ethernet/mediatek/mtk_star_emac.c      |   7 +
 drivers/net/ethernet/micrel/ks8851_common.c        |  10 +-
 drivers/net/ethernet/micrel/ks8851_spi.c           |   4 +-
 drivers/net/phy/microchip_t1.c                     |   2 +-
 drivers/net/ppp/ppp_generic.c                      |  15 ++
 drivers/net/wireguard/allowedips.c                 |   4 +-
 drivers/net/wireguard/queueing.h                   |   4 +-
 drivers/net/wireguard/send.c                       |   2 +-
 drivers/nvmem/core.c                               |   5 +-
 drivers/nvmem/meson-efuse.c                        |  14 +-
 drivers/nvmem/rmem.c                               |   5 +-
 drivers/platform/x86/toshiba_acpi.c                |   1 +
 drivers/usb/core/config.c                          |  18 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/gadget/configfs.c                      |   3 +
 drivers/usb/host/xhci.c                            |  16 +-
 drivers/usb/serial/mos7840.c                       |  45 ++++
 drivers/usb/serial/option.c                        |  38 ++++
 fs/cachefiles/daemon.c                             |  14 +-
 fs/cachefiles/internal.h                           |  15 ++
 fs/cachefiles/ondemand.c                           |  52 ++++-
 fs/cachefiles/xattr.c                              |   5 +-
 fs/dcache.c                                        |  12 +-
 fs/locks.c                                         |   2 +-
 fs/nilfs2/dir.c                                    |  32 ++-
 fs/smb/client/cifs_dfs_ref.c                       |  36 +++-
 fs/smb/client/cifsglob.h                           |   4 +-
 fs/smb/client/cifsproto.h                          |  36 ++++
 fs/smb/client/dir.c                                |  21 +-
 fs/smb/server/smb2pdu.c                            |  13 +-
 fs/userfaultfd.c                                   |   7 +-
 include/linux/bpf.h                                |   8 +
 include/linux/bpf_local_storage.h                  |  17 +-
 include/linux/mmzone.h                             |   3 +-
 kernel/bpf/bpf_inode_storage.c                     |  38 +---
 kernel/bpf/bpf_local_storage.c                     | 199 +++++++++++-------
 kernel/bpf/bpf_task_storage.c                      |  38 +---
 kernel/bpf/syscall.c                               |  15 ++
 kernel/bpf/verifier.c                              |  11 +-
 kernel/sched/core.c                                |   7 +-
 kernel/sched/fair.c                                |  12 +-
 kernel/sched/psi.c                                 |  21 +-
 kernel/sched/sched.h                               |   1 +
 kernel/sched/stats.h                               |  11 +-
 net/ceph/mon_client.c                              |  14 +-
 net/core/bpf_sk_storage.c                          |  35 +---
 net/core/datagram.c                                |   3 +-
 net/core/skmsg.c                                   |   3 +-
 net/ethtool/linkstate.c                            |  41 ++--
 net/ipv4/tcp_input.c                               |  11 +-
 net/ipv4/tcp_timer.c                               |  31 ++-
 net/ipv4/udp.c                                     |   4 +-
 net/sched/act_ct.c                                 |   8 +
 net/sunrpc/xprtsock.c                              |   7 +
 scripts/ld-version.sh                              |   8 +-
 sound/pci/hda/patch_realtek.c                      |   4 +
 .../selftests/bpf/progs/test_global_func10.c       |   9 +-
 tools/testing/selftests/bpf/verifier/calls.c       |  13 +-
 .../selftests/bpf/verifier/helper_access_var_len.c | 104 ++++++----
 tools/testing/selftests/bpf/verifier/int_ptr.c     |   9 +-
 .../selftests/bpf/verifier/search_pruning.c        |  13 +-
 tools/testing/selftests/bpf/verifier/sock.c        |  27 ---
 tools/testing/selftests/bpf/verifier/spill_fill.c  |   7 +-
 tools/testing/selftests/bpf/verifier/var_off.c     |  52 -----
 tools/testing/selftests/wireguard/qemu/Makefile    |   8 +-
 86 files changed, 1204 insertions(+), 634 deletions(-)


