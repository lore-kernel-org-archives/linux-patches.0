Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF7918059;
	Wed, 17 Jul 2024 06:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721198352; cv=none; b=JqkRL657lcvWb0KYjnTUmFRy/W4w3UeY+s/Vgfgd8IlZOB7N8oIWEY2ZOBjNldKDl8zk9MrGICkW9MDBqN6p0VQYgyk9YRf7Sq+NepmdD6REIxlZZRE8efR6XpA5SUuMCZ1baaQcEkhks9qtVCGGwubuYhOGJVaAGjPF21Uum7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721198352; c=relaxed/simple;
	bh=vTn5YwnWOJ5tW/8Mcb19sBqMZzeFzjGTfslUeLqGkXs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OxBSEh2zmSyK/f8O4/U3E/iAFvkj+WBFAgbtPFYojeTJCX+3K49zIfITJ6saCcV8FfDIJAmhMKuV5sbG/d+G9p4SyowjRWyf0m/lIcMXMKbAbdArZRt9mkYIWMzJXn8qi3LMiCanxl6kSo6b0R9pvNmk2e4QM3gqK9mbwCD+LoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cE2K/dzB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cE2K/dzB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B447DC32782;
	Wed, 17 Jul 2024 06:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721198352;
	bh=vTn5YwnWOJ5tW/8Mcb19sBqMZzeFzjGTfslUeLqGkXs=;
	h=From:To:Cc:Subject:Date:From;
	b=cE2K/dzBD3ym62n2W7Q/i+A+2sUAevTu+UtnyyJ+BUKf8SD9O35HUVDiBF1LjbZb3
	 zgNvGWVbiz18nzQ02AMzhbgKmjW7A124UCaBrxgGgdXl5IL+D7ssGW85p1ftbDaF2v
	 tGmOkuq4Ld2S7g6oMBVBvzHNvKR2pZrGt35I6BO8=
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
Subject: [PATCH 5.4 00/79] 5.4.280-rc2 review
Date: Wed, 17 Jul 2024 08:39:08 +0200
Message-ID: <20240717063752.619384275@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.280-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.280-rc2
X-KernelTest-Deadline: 2024-07-19T06:37+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.4.280 release.
There are 79 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.280-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.280-rc2

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: bring hardware to known state when probing

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix kernel bug on rename operation of broken directory

Eric Dumazet <edumazet@google.com>
    tcp: avoid too many retransmit packets

Eric Dumazet <edumazet@google.com>
    tcp: use signed arithmetic in tcp_rtx_probe0_timed_out()

Menglong Dong <imagedong@tencent.com>
    net: tcp: fix unexcepted socket die when snd_wnd is 0

Eric Dumazet <edumazet@google.com>
    tcp: refactor tcp_retransmit_timer()

felix <fuzhen5@huawei.com>
    SUNRPC: Fix RPC client cleaned up the freed pipefs dentries

Ilya Dryomov <idryomov@gmail.com>
    libceph: fix race between delayed_work() and ceph_monc_stop()

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Limit mic boost on VAIO PRO PX

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

Michal Mazur <mmazur2@marvell.com>
    octeontx2-af: fix detection of IP layer

Chen Ni <nichen@iscas.ac.cn>
    ARM: davinci: Convert comma to semicolon

Sven Schnelle <svens@linux.ibm.com>
    s390: Mark psw in __load_psw_mask() as __unitialized

Kuniyuki Iwashima <kuniyu@amazon.com>
    udp: Set SOCK_RCU_FREE earlier in udp_lib_get_port().

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

Jason Baron <jbaron@akamai.com>
    tcp: add TCP_INFO status for failed client TFO

Brian Foster <bfoster@redhat.com>
    vfs: don't mod negative dentry count when on shrinker list

linke li <lilinke99@qq.com>
    fs/dcache: Re-use value stored to dentry->d_flags instead of re-reading

Jeff Layton <jlayton@kernel.org>
    filelock: fix potential use-after-free in posix_lock_inode

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix incorrect inode allocation from reserved inodes

Nilay Shroff <nilay@linux.ibm.com>
    nvme-multipath: find NUMA path only for online numa-node

Jian-Hong Pan <jhp@endlessos.org>
    ALSA: hda/realtek: Enable headset mic of JP-IK LEAP W502 with ALC897

Piotr Wojtaszczyk <piotr.wojtaszczyk@timesys.com>
    i2c: pnx: Fix potential deadlock warning from del_timer_sync() call in isr

Mauro Carvalho Chehab <mchehab@kernel.org>
    media: dw2102: fix a potential buffer overflow

Ghadi Elie Rahme <ghadi.rahme@canonical.com>
    bnx2x: Fix multiple UBSAN array-index-out-of-bounds

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

Yuchung Cheng <ycheng@google.com>
    net: tcp better handling of reordering then loss cases

Yousuk Seung <ysseung@google.com>
    tcp: add ece_ack flag to reno sack functions

zhang kai <zhangkaiheb@126.com>
    tcp: tcp_mark_head_lost is only valid for sack-tcp

Holger Dengler <dengler@linux.ibm.com>
    s390/pkey: Wipe sensitive data on failure

Wang Yong <wang.yong12@zte.com.cn>
    jffs2: Fix potential illegal address access in jffs2_free_inode

Greg Kurz <groug@kaod.org>
    powerpc/xmon: Check cpu id in commands "c#", "dp#" and "dx#"

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

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu: Initialize timestamp for some legacy SOCs

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

 Makefile                                          |   4 +-
 arch/arm/mach-davinci/pm.c                        |   2 +-
 arch/powerpc/include/asm/io.h                     |   2 +-
 arch/powerpc/xmon/xmon.c                          |   6 +-
 arch/s390/include/asm/processor.h                 |   2 +-
 drivers/char/hpet.c                               |  34 +++++-
 drivers/firmware/dmi_scan.c                       |  11 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c           |   8 ++
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c |   3 +
 drivers/gpu/drm/amd/include/atomfirmware.h        |   2 +-
 drivers/gpu/drm/lima/lima_gp.c                    |   2 +
 drivers/gpu/drm/lima/lima_mmu.c                   |   5 +
 drivers/gpu/drm/lima/lima_pp.c                    |   4 +
 drivers/gpu/drm/nouveau/nouveau_connector.c       |   3 +
 drivers/i2c/busses/i2c-i801.c                     |   2 +-
 drivers/i2c/busses/i2c-pnx.c                      |  48 ++-------
 drivers/i2c/busses/i2c-rcar.c                     |  17 ++-
 drivers/infiniband/core/user_mad.c                |  21 ++--
 drivers/input/ff-core.c                           |   7 +-
 drivers/media/dvb-frontends/as102_fe_types.h      |   2 +-
 drivers/media/dvb-frontends/tda10048.c            |   9 +-
 drivers/media/dvb-frontends/tda18271c2dd.c        |   4 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c       |  18 +++-
 drivers/media/usb/dvb-usb/dw2102.c                | 120 +++++++++++++---------
 drivers/media/usb/s2255/s2255drv.c                |  20 ++--
 drivers/net/bonding/bond_options.c                |   6 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c  |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c                  |   4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h       |   2 +-
 drivers/net/ethernet/lantiq_etop.c                |   5 +-
 drivers/net/ethernet/marvell/octeontx2/af/npc.h   |   8 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c   |   2 +-
 drivers/net/ppp/ppp_generic.c                     |  15 +++
 drivers/nvme/host/multipath.c                     |   2 +-
 drivers/nvmem/meson-efuse.c                       |  14 ++-
 drivers/s390/crypto/pkey_api.c                    |   4 +-
 drivers/scsi/qedf/qedf_io.c                       |   6 +-
 drivers/staging/wilc1000/wilc_hif.c               |   3 +-
 drivers/usb/core/config.c                         |  18 +++-
 drivers/usb/core/quirks.c                         |   3 +
 drivers/usb/gadget/configfs.c                     |   3 +
 drivers/usb/serial/option.c                       |  38 +++++++
 fs/dcache.c                                       |  12 ++-
 fs/jffs2/super.c                                  |   1 +
 fs/locks.c                                        |   2 +-
 fs/nilfs2/alloc.c                                 |  18 +++-
 fs/nilfs2/alloc.h                                 |   4 +-
 fs/nilfs2/dat.c                                   |   2 +-
 fs/nilfs2/dir.c                                   |  38 ++++++-
 fs/nilfs2/ifile.c                                 |   7 +-
 fs/nilfs2/nilfs.h                                 |  10 +-
 fs/nilfs2/the_nilfs.c                             |   6 ++
 fs/nilfs2/the_nilfs.h                             |   2 +-
 fs/orangefs/super.c                               |   3 +-
 include/linux/compiler_attributes.h               |  12 +++
 include/linux/fsnotify.h                          |   8 +-
 include/linux/sunrpc/clnt.h                       |   1 +
 include/linux/tcp.h                               |   2 +-
 include/uapi/linux/tcp.h                          |  10 +-
 kernel/exit.c                                     |   2 +
 mm/page-writeback.c                               |   2 +-
 net/ceph/mon_client.c                             |  14 ++-
 net/ipv4/inet_diag.c                              |   2 +
 net/ipv4/tcp.c                                    |   2 +
 net/ipv4/tcp_fastopen.c                           |   5 +-
 net/ipv4/tcp_input.c                              | 112 ++++++++++----------
 net/ipv4/tcp_metrics.c                            |   1 +
 net/ipv4/tcp_timer.c                              |  45 +++++++-
 net/ipv4/udp.c                                    |   4 +-
 net/sctp/socket.c                                 |   7 +-
 net/sunrpc/clnt.c                                 |   5 +-
 sound/pci/hda/patch_realtek.c                     |  11 ++
 tools/testing/selftests/net/msg_zerocopy.c        |  14 ++-
 73 files changed, 602 insertions(+), 252 deletions(-)


