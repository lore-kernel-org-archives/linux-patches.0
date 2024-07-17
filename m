Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0908C134A8;
	Wed, 17 Jul 2024 06:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721198376; cv=none; b=j2jNysCEx7ii1VcxjQZ53GnQw0qGiro5v0sLcTRZ6Zi12NbR8kWT2kaLk4RR9QG7X0V+6Ts/U/VT4fo4vKK4+g/xHuEEpRSjaRKlva6/K0CxcrpxNjvFcx9Wrge/brvKKfcChEzro7aJ20mu3ifLXHrqAD4bHMK+iwjPSV+5NDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721198376; c=relaxed/simple;
	bh=LEASpJOLFOVM9BMQ2lGs+NFYh9h9OGQ4MR5TcJM0CDA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=s8EtB9p6ZAxie6fSq2Xhji7igjhOliFdYvJh9e+Ij6hYhlDnhJLPjOXLy44dxv5BtLQHvzwjy+DbqU+QuULWaK1Ns1pITYdLZr8J6VZJWD7/PEFd5Oh/mHHohHYzX1lNAvLD0FoM/NeOO1YOp1xVeDIHXmIbHQY8A6KjI2b+NjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ax+mxesJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ax+mxesJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69E1C32782;
	Wed, 17 Jul 2024 06:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721198375;
	bh=LEASpJOLFOVM9BMQ2lGs+NFYh9h9OGQ4MR5TcJM0CDA=;
	h=From:To:Cc:Subject:Date:From;
	b=Ax+mxesJ1C/6TF6ILBSLu2w6XtniQIcSS4aDKbymefVcri6cHPe1yrec57poqQkwe
	 3BzbeGgosn7c2S326AtanyslUI/oNVv+sWfdc1db2Io6hMbLMRaQn6m/aNVbAIHBbE
	 0gJXoPbbZPotE9owgqzNkg1zW0bbGabTGyms2COw=
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
Subject: [PATCH 5.10 000/109] 5.10.222-rc2 review
Date: Wed, 17 Jul 2024 08:39:31 +0200
Message-ID: <20240717063758.061781150@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.222-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.222-rc2
X-KernelTest-Deadline: 2024-07-19T06:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.222 release.
There are 109 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.222-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.222-rc2

Dan Carpenter <dan.carpenter@linaro.org>
    i2c: rcar: fix error code in probe()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: clear NO_RXDMA flag after resetting

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: ensure Gen3+ reset does not disturb local targets

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: introduce Gen4 devices

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: reset controller is mandatory for Gen3+

Geert Uytterhoeven <geert+renesas@glider.be>
    i2c: rcar: Add R-Car Gen4 support

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: mark HostNotify target address as used

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: bring hardware to known state when probing

Russell King <russell.king@oracle.com>
    arm64/bpf: Remove 128MB limit for BPF JIT programs

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix kernel bug on rename operation of broken directory

Eduard Zingerman <eddyz87@gmail.com>
    bpf: Allow reads from uninit stack

Eric Dumazet <edumazet@google.com>
    ipv6: prevent NULL dereference in ip6_output()

Eric Dumazet <edumazet@google.com>
    ipv6: annotate data-races around cnf.disable_ipv6

Ard Biesheuvel <ardb@kernel.org>
    efi: ia64: move IA64-only declarations to new asm/efi.h header

Jim Mattson <jmattson@google.com>
    x86/retpoline: Move a NOENDBR annotation to the SRSO dummy return thunk

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: send: annotate intentional data race in checking empty queue

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: queueing: annotate intentional data race in cpu round robin

Helge Deller <deller@kernel.org>
    wireguard: allowedips: avoid unaligned 64-bit memory accesses

Ilya Dryomov <idryomov@gmail.com>
    libceph: fix race between delayed_work() and ceph_monc_stop()

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Limit mic boost on VAIO PRO PX

Nazar Bilinskyi <nbilinskyi@gmail.com>
    ALSA: hda/realtek: Enable Mute LED on HP 250 G7

Joy Chakraborty <joychakr@google.com>
    nvmem: meson-efuse: Fix return value of nvmem callbacks

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

Eric Dumazet <edumazet@google.com>
    tcp: avoid too many retransmit packets

Eric Dumazet <edumazet@google.com>
    tcp: use signed arithmetic in tcp_rtx_probe0_timed_out()

Michal Mazur <mmazur2@marvell.com>
    octeontx2-af: fix detection of IP layer

Chen Ni <nichen@iscas.ac.cn>
    ARM: davinci: Convert comma to semicolon

Sven Schnelle <svens@linux.ibm.com>
    s390: Mark psw in __load_psw_mask() as __unitialized

Chengen Du <chengen.du@canonical.com>
    net/sched: Fix UAF when resolving a clash

Kuniyuki Iwashima <kuniyu@amazon.com>
    udp: Set SOCK_RCU_FREE earlier in udp_lib_get_port().

Oleksij Rempel <linux@rempel-privat.de>
    ethtool: netlink: do not return SQI value if link is down

Dmitry Antipov <dmantipov@yandex.ru>
    ppp: reject claimed-as-LCP but actually malformed packets

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: ethernet: lantiq_etop: fix double free in detach

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: lantiq_etop: add blank line after declaration

Aleksandr Mishin <amishin@t-argos.ru>
    octeontx2-af: Fix incorrect value output on error path in rvu_check_rsrc_availability()

Neal Cardwell <ncardwell@google.com>
    tcp: fix incorrect undo caused by DSACK of TLP retransmit

Brian Foster <bfoster@redhat.com>
    vfs: don't mod negative dentry count when on shrinker list

linke li <lilinke99@qq.com>
    fs/dcache: Re-use value stored to dentry->d_flags instead of re-reading

Jeff Layton <jlayton@kernel.org>
    filelock: fix potential use-after-free in posix_lock_inode

Waiman Long <longman@redhat.com>
    mm: prevent derefencing NULL ptr in pfn_section_valid()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix incorrect inode allocation from reserved inodes

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: fix short log for AS in link-vmlinux.sh

Sagi Grimberg <sagi@grimberg.me>
    nvmet: fix a possible leak when destroy a ctrl during qp establishment

hmtheboy154 <buingoc67@gmail.com>
    platform/x86: touchscreen_dmi: Add info for the EZpad 6s Pro

hmtheboy154 <buingoc67@gmail.com>
    platform/x86: touchscreen_dmi: Add info for GlobalSpace SolT IVW 11.6" tablet

Kundan Kumar <kundan.kumar@samsung.com>
    nvme: adjust multiples of NVME_CTRL_PAGE_SIZE in offset

Nilay Shroff <nilay@linux.ibm.com>
    nvme-multipath: find NUMA path only for online numa-node

Jian-Hong Pan <jhp@endlessos.org>
    ALSA: hda/realtek: Enable headset mic of JP-IK LEAP W502 with ALC897

Piotr Wojtaszczyk <piotr.wojtaszczyk@timesys.com>
    i2c: pnx: Fix potential deadlock warning from del_timer_sync() call in isr

Mauro Carvalho Chehab <mchehab@kernel.org>
    media: dw2102: fix a potential buffer overflow

GUO Zihua <guozihua@huawei.com>
    ima: Avoid blocking in RCU read-side critical section

Wang Yufen <wangyufen@huawei.com>
    bpf, sockmap: Fix sk->sk_forward_alloc warn_on in sk_stream_kill_queues

Ghadi Elie Rahme <ghadi.rahme@canonical.com>
    bnx2x: Fix multiple UBSAN array-index-out-of-bounds

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: Bypass a couple of sanity checks during NAND identification

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/atomfirmware: silence UBSAN warning

Ma Ke <make24@iscas.ac.cn>
    drm/nouveau: fix null pointer dereference in nouveau_connector_get_modes

Jan Kara <jack@suse.cz>
    Revert "mm/writeback: fix possible divide-by-zero in wb_dirty_limits(), again"

Jan Kara <jack@suse.cz>
    fsnotify: Do not generate events for O_PATH file descriptors

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: Explicitly initialize family in leafimx driver_info struct

Zijun Hu <quic_zijuhu@quicinc.com>
    Bluetooth: qca: Fix BT enable failure again for QCA6390 after warm reboot

Jan Kara <jack@suse.cz>
    mm: avoid overflows in dirty throttling logic

Jinliang Zheng <alexjlzheng@tencent.com>
    mm: optimize the redundant loop of mm_update_owner_next()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: add missing check for inode numbers on directory entries

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix inode number range checks

Shigeru Yoshida <syoshida@redhat.com>
    inet_diag: Initialize pad field in struct inet_diag_req_v2

Zijian Zhang <zijianzhang@bytedance.com>
    selftests: make order checking verbose in msg_zerocopy selftest

Zijian Zhang <zijianzhang@bytedance.com>
    selftests: fix OOM in msg_zerocopy selftest

Sam Sun <samsun1006219@gmail.com>
    bonding: Fix out-of-bounds read in bond_option_arp_ip_targets_set()

Jozef Hopko <jozef.hopko@altana.com>
    wifi: wilc1000: fix ies_len type in connect path

Jakub Kicinski <kuba@kernel.org>
    tcp_metrics: validate source addr length

Neal Cardwell <ncardwell@google.com>
    UPSTREAM: tcp: fix DSACK undo in fast recovery to call tcp_try_to_open()

Holger Dengler <dengler@linux.ibm.com>
    s390/pkey: Wipe sensitive data on failure

Wang Yong <wang.yong12@zte.com.cn>
    jffs2: Fix potential illegal address access in jffs2_free_inode

Jose E. Marchesi <jose.marchesi@oracle.com>
    bpf: Avoid uninitialized value in BPF_CORE_READ_BITFIELD

Greg Kurz <groug@kaod.org>
    powerpc/xmon: Check cpu id in commands "c#", "dp#" and "dx#"

Mickaël Salaün <mic@digikod.net>
    kunit: Fix timeout message

Mike Marshall <hubcap@omnibond.com>
    orangefs: fix out-of-bounds fsid access

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64: Set _IO_BASE to POISON_POINTER_DELTA not 0 for CONFIG_PCI=n

Heiner Kallweit <hkallweit1@gmail.com>
    i2c: i801: Annotate apanel_addr as __ro_after_init

Ricardo Ribalda <ribalda@chromium.org>
    media: dvb-frontends: tda10048: Fix integer overflow

Ricardo Ribalda <ribalda@chromium.org>
    media: s2255: Use refcount_t instead of atomic_t for num_channels

Ricardo Ribalda <ribalda@chromium.org>
    media: dvb-frontends: tda18271c2dd: Remove casting during div

Simon Horman <horms@kernel.org>
    net: dsa: mv88e6xxx: Correct check for empty list

Erick Archer <erick.archer@outlook.com>
    Input: ff-core - prefer struct_size over open coded arithmetic

Jean Delvare <jdelvare@suse.de>
    firmware: dmi: Stop decoding on broken entry

Erick Archer <erick.archer@outlook.com>
    sctp: prefer struct_size over open coded arithmetic

Michael Bunk <micha@freedict.org>
    media: dw2102: Don't translate i2c read into write

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Skip finding free audio for unknown engine_id

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check pipe offset before setting vblank

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check index msg_id before read or write

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu: Initialize timestamp for some legacy SOCs

Hailey Mothershead <hailmo@amazon.com>
    crypto: aead,cipher - zeroize key buffer after use

John Meneghini <jmeneghi@redhat.com>
    scsi: qedf: Make qedf_execute_tmf() non-preemptible

Michael Guralnik <michaelgur@nvidia.com>
    IB/core: Implement a limit on UMAD receive List

Ricardo Ribalda <ribalda@chromium.org>
    media: dvb-usb: dib0700_devices: Add missing release_firmware()

Ricardo Ribalda <ribalda@chromium.org>
    media: dvb: as102-fe: Fix as10x_register_addr packing

Erico Nunes <nunes.erico@gmail.com>
    drm/lima: fix shared irq handling on driver remove

Heiko Carstens <hca@linux.ibm.com>
    Compiler Attributes: Add __uninitialized macro


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/mach-davinci/pm.c                         |   2 +-
 arch/arm64/include/asm/extable.h                   |   9 -
 arch/arm64/include/asm/memory.h                    |   5 +-
 arch/arm64/kernel/traps.c                          |   2 +-
 arch/arm64/mm/extable.c                            |   3 +-
 arch/arm64/mm/ptdump.c                             |   2 -
 arch/arm64/net/bpf_jit_comp.c                      |   7 +-
 arch/ia64/include/asm/efi.h                        |  13 ++
 arch/ia64/kernel/efi.c                             |   1 +
 arch/ia64/kernel/machine_kexec.c                   |   1 +
 arch/ia64/kernel/mca.c                             |   1 +
 arch/ia64/kernel/smpboot.c                         |   1 +
 arch/ia64/kernel/time.c                            |   1 +
 arch/ia64/kernel/uncached.c                        |   4 +-
 arch/ia64/mm/contig.c                              |   1 +
 arch/ia64/mm/discontig.c                           |   1 +
 arch/ia64/mm/init.c                                |   1 +
 arch/powerpc/include/asm/io.h                      |   2 +-
 arch/powerpc/xmon/xmon.c                           |   6 +-
 arch/s390/include/asm/processor.h                  |   2 +-
 arch/x86/lib/retpoline.S                           |   2 +-
 crypto/aead.c                                      |   3 +-
 crypto/cipher.c                                    |   3 +-
 drivers/bluetooth/hci_qca.c                        |  18 +-
 drivers/char/hpet.c                                |  34 +++-
 drivers/firmware/dmi_scan.c                        |  11 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c            |   8 +
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   3 +
 .../amd/display/dc/irq/dce110/irq_service_dce110.c |   8 +-
 .../gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c    |   8 +
 drivers/gpu/drm/amd/include/atomfirmware.h         |   2 +-
 drivers/gpu/drm/lima/lima_gp.c                     |   2 +
 drivers/gpu/drm/lima/lima_mmu.c                    |   5 +
 drivers/gpu/drm/lima/lima_pp.c                     |   4 +
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   3 +
 drivers/i2c/busses/i2c-i801.c                      |   2 +-
 drivers/i2c/busses/i2c-pnx.c                       |  48 +----
 drivers/i2c/busses/i2c-rcar.c                      |  66 ++++---
 drivers/i2c/i2c-core-base.c                        |   1 +
 drivers/infiniband/core/user_mad.c                 |  21 +-
 drivers/input/ff-core.c                            |   7 +-
 drivers/media/dvb-frontends/as102_fe_types.h       |   2 +-
 drivers/media/dvb-frontends/tda10048.c             |   9 +-
 drivers/media/dvb-frontends/tda18271c2dd.c         |   4 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |  18 +-
 drivers/media/usb/dvb-usb/dw2102.c                 | 120 +++++++-----
 drivers/media/usb/s2255/s2255drv.c                 |  20 +-
 drivers/mtd/nand/raw/nand_base.c                   |  57 +++---
 drivers/net/bonding/bond_options.c                 |   6 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |   4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |   2 +-
 drivers/net/ethernet/lantiq_etop.c                 |   5 +-
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |   8 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   2 +-
 drivers/net/ethernet/micrel/ks8851_common.c        |   2 +-
 drivers/net/ppp/ppp_generic.c                      |  15 ++
 drivers/net/wireguard/allowedips.c                 |   4 +-
 drivers/net/wireguard/queueing.h                   |   4 +-
 drivers/net/wireguard/send.c                       |   2 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |   3 +-
 drivers/nvme/host/multipath.c                      |   2 +-
 drivers/nvme/host/pci.c                            |   3 +-
 drivers/nvme/target/core.c                         |   9 +
 drivers/nvmem/meson-efuse.c                        |  14 +-
 drivers/platform/x86/touchscreen_dmi.c             |  36 ++++
 drivers/s390/crypto/pkey_api.c                     |   4 +-
 drivers/scsi/qedf/qedf_io.c                        |   6 +-
 drivers/usb/core/config.c                          |  18 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/gadget/configfs.c                      |   3 +
 drivers/usb/serial/mos7840.c                       |  45 +++++
 drivers/usb/serial/option.c                        |  38 ++++
 fs/dcache.c                                        |  12 +-
 fs/jffs2/super.c                                   |   1 +
 fs/locks.c                                         |   2 +-
 fs/nilfs2/alloc.c                                  |  18 +-
 fs/nilfs2/alloc.h                                  |   4 +-
 fs/nilfs2/dat.c                                    |   2 +-
 fs/nilfs2/dir.c                                    |  38 +++-
 fs/nilfs2/ifile.c                                  |   7 +-
 fs/nilfs2/nilfs.h                                  |  10 +-
 fs/nilfs2/the_nilfs.c                              |   6 +
 fs/nilfs2/the_nilfs.h                              |   2 +-
 fs/orangefs/super.c                                |   3 +-
 include/linux/bpf.h                                |   1 +
 include/linux/compiler_attributes.h                |  12 ++
 include/linux/efi.h                                |   6 -
 include/linux/fsnotify.h                           |   8 +-
 include/linux/lsm_hook_defs.h                      |   2 +-
 include/linux/mmzone.h                             |   3 +-
 include/linux/security.h                           |   5 +-
 include/linux/skmsg.h                              |   1 +
 kernel/auditfilter.c                               |   5 +-
 kernel/bpf/verifier.c                              |  11 +-
 kernel/exit.c                                      |   2 +
 lib/kunit/try-catch.c                              |   3 +-
 mm/page-writeback.c                                |  32 +++-
 net/ceph/mon_client.c                              |  14 +-
 net/core/skmsg.c                                   |   1 +
 net/core/sock_map.c                                |  22 +++
 net/ethtool/linkstate.c                            |  41 ++--
 net/ipv4/inet_diag.c                               |   2 +
 net/ipv4/tcp_bpf.c                                 |   1 +
 net/ipv4/tcp_input.c                               |  13 +-
 net/ipv4/tcp_metrics.c                             |   1 +
 net/ipv4/tcp_timer.c                               |  31 ++-
 net/ipv4/udp.c                                     |   4 +-
 net/ipv6/addrconf.c                                |   9 +-
 net/ipv6/ip6_input.c                               |   2 +-
 net/ipv6/ip6_output.c                              |   2 +-
 net/sched/act_ct.c                                 |   8 +
 net/sctp/socket.c                                  |   7 +-
 scripts/link-vmlinux.sh                            |   2 +-
 security/apparmor/audit.c                          |   6 +-
 security/apparmor/include/audit.h                  |   2 +-
 security/integrity/ima/ima.h                       |   2 +-
 security/integrity/ima/ima_policy.c                |  15 +-
 security/security.c                                |   6 +-
 security/selinux/include/audit.h                   |   4 +-
 security/selinux/ss/services.c                     |   5 +-
 security/smack/smack_lsm.c                         |   4 +-
 sound/pci/hda/patch_realtek.c                      |  12 ++
 tools/lib/bpf/bpf_core_read.h                      |   1 +
 .../selftests/bpf/progs/test_global_func10.c       |  31 +++
 tools/testing/selftests/bpf/verifier/calls.c       |  13 +-
 .../selftests/bpf/verifier/helper_access_var_len.c | 104 ++++++----
 tools/testing/selftests/bpf/verifier/int_ptr.c     |   9 +-
 .../selftests/bpf/verifier/search_pruning.c        |  13 +-
 tools/testing/selftests/bpf/verifier/sock.c        |  27 ---
 tools/testing/selftests/bpf/verifier/spill_fill.c  | 211 +++++++++++++++++++++
 tools/testing/selftests/bpf/verifier/var_off.c     |  52 -----
 tools/testing/selftests/net/msg_zerocopy.c         |  14 +-
 134 files changed, 1215 insertions(+), 469 deletions(-)


