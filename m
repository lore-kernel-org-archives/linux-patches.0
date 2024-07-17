Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F0E1B970;
	Wed, 17 Jul 2024 06:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721198361; cv=none; b=Mdq1Wj/cWHvOWvnn7f26rbUbdw5qALVypJMGnPqLCy0tw67+QZCwQr9ILhIqqw79puFY60xQzXmgk2lYL1IW6Cw5KvqPy0VvUsvq+8gsDZeicA9BNeztvQVnnCZTDmTkfz0emUOOo31TF9mxiOb8sQpVdbLfG6lV0MU15PQ8rLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721198361; c=relaxed/simple;
	bh=Sslbjsi0/cufYT13SXJ05CGiD2UNZJy/9+jp19xYlKM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RJ0kdW5kZdACvdxCUJAzRhSnC7ie7D8oRa85zpKDATOvzzAFhk4lZ3+kUolaqSEEnAfJUJxvTQF79GF8OmYQOJkkYjH90UgJgQpQepfHiCzsOkw5eVGIiP5vLAC6rkPvsXLRE1ero7hpvB5jQ/ZZ1E6R/2gUYpbSwCqmp2WFeK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CmePoFf1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CmePoFf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD544C32782;
	Wed, 17 Jul 2024 06:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721198360;
	bh=Sslbjsi0/cufYT13SXJ05CGiD2UNZJy/9+jp19xYlKM=;
	h=From:To:Cc:Subject:Date:From;
	b=CmePoFf1F8Qw0li1NEwD4hGSJuVZOewG3aodYywk2BJt8ZH1y9luxfmAWSctaVt+B
	 6gq3sLt8V4goPdHKWVQtZQDRfOSaBeV+qkzvrIrrofqg9aVjb15EHhOlPnCySM55jM
	 +U7igQx5KPGVqE9wql+LyEDDsMSxmC2B5k8QY2ow=
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
Subject: [PATCH 5.15 000/145] 5.15.163-rc2 review
Date: Wed, 17 Jul 2024 08:39:16 +0200
Message-ID: <20240717063804.076815489@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.163-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.163-rc2
X-KernelTest-Deadline: 2024-07-19T06:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.163 release.
There are 145 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.163-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.163-rc2

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

Geert Uytterhoeven <geert+renesas@glider.be>
    i2c: rcar: Add R-Car Gen4 support

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: mark HostNotify target address as used

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: bring hardware to known state when probing

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix kernel bug on rename operation of broken directory

Eduard Zingerman <eddyz87@gmail.com>
    bpf: Allow reads from uninit stack

Eric Dumazet <edumazet@google.com>
    ipv6: prevent NULL dereference in ip6_output()

Eric Dumazet <edumazet@google.com>
    ipv6: annotate data-races around cnf.disable_ipv6

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: send: annotate intentional data race in checking empty queue

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: queueing: annotate intentional data race in cpu round robin

Helge Deller <deller@kernel.org>
    wireguard: allowedips: avoid unaligned 64-bit memory accesses

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

Thomas Weißschuh <linux@weissschuh.net>
    nvmem: core: only change name to fram for current attribute

Joy Chakraborty <joychakr@google.com>
    nvmem: meson-efuse: Fix return value of nvmem callbacks

Joy Chakraborty <joychakr@google.com>
    nvmem: rmem: Fix return value of rmem_read()

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

Jian Hui Lee <jianhui.lee@canonical.com>
    net: ethernet: mtk-star-emac: set mac_managed_pm when probing

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: ethernet: lantiq_etop: fix double free in detach

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: lantiq_etop: add blank line after declaration

Michal Kubiak <michal.kubiak@intel.com>
    i40e: Fix XDP program unloading while removing the driver

Hugh Dickins <hughd@google.com>
    net: fix rc7's __skb_datagram_iter()

Aleksandr Mishin <amishin@t-argos.ru>
    octeontx2-af: Fix incorrect value output on error path in rvu_check_rsrc_availability()

Geliang Tang <tanggeliang@kylinos.cn>
    skmsg: Skip zero length skb in sk_msg_recvmsg

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

Damien Le Moal <dlemoal@kernel.org>
    null_blk: Do not allow runt zone with zone capacity smaller then zone size

Edward Adam Davis <eadavis@qq.com>
    nfc/nci: Add the inconsistency check between the input data length and count

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: fix short log for AS in link-vmlinux.sh

Sagi Grimberg <sagi@grimberg.me>
    nvmet: fix a possible leak when destroy a ctrl during qp establishment

hmtheboy154 <buingoc67@gmail.com>
    platform/x86: touchscreen_dmi: Add info for the EZpad 6s Pro

hmtheboy154 <buingoc67@gmail.com>
    platform/x86: touchscreen_dmi: Add info for GlobalSpace SolT IVW 11.6" tablet

Jim Wylder <jwylder@google.com>
    regmap-i2c: Subtract reg size from max_write

Kundan Kumar <kundan.kumar@samsung.com>
    nvme: adjust multiples of NVME_CTRL_PAGE_SIZE in offset

Fedor Pchelkin <pchelkin@ispras.ru>
    dma-mapping: benchmark: avoid needless copy_to_user if benchmark fails

Nilay Shroff <nilay@linux.ibm.com>
    nvme-multipath: find NUMA path only for online numa-node

Jian-Hong Pan <jhp@endlessos.org>
    ALSA: hda/realtek: Enable headset mic of JP-IK LEAP W502 with ALC897

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Mark volume as dirty if xattr is broken

Piotr Wojtaszczyk <piotr.wojtaszczyk@timesys.com>
    i2c: pnx: Fix potential deadlock warning from del_timer_sync() call in isr

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: gcc-sm6350: Fix gpll6* & gpll7 parents

Mauro Carvalho Chehab <mchehab@kernel.org>
    media: dw2102: fix a potential buffer overflow

GUO Zihua <guozihua@huawei.com>
    ima: Avoid blocking in RCU read-side critical section

Ghadi Elie Rahme <ghadi.rahme@canonical.com>
    bnx2x: Fix multiple UBSAN array-index-out-of-bounds

Val Packett <val@packett.cool>
    mtd: rawnand: rockchip: ensure NVDDR timings are rejected

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: Bypass a couple of sanity checks during NAND identification

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: Ensure ECC configuration is propagated to upper layers

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

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: fix adding block group to a reclaim list and the unused list during reclaim

Jan Kara <jack@suse.cz>
    mm: avoid overflows in dirty throttling logic

Jinliang Zheng <alexjlzheng@tencent.com>
    mm: optimize the redundant loop of mm_update_owner_next()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: add missing check for inode numbers on directory entries

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix inode number range checks

Sasha Neftin <sasha.neftin@intel.com>
    Revert "igc: fix a log entry using uninitialized netdev"

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    gpiolib: of: add polarity quirk for TSC2005

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    gpiolib: of: add a quirk for reset line polarity for Himax LCDs

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    gpiolib: of: factor out code overriding gpio line polarity

Shigeru Yoshida <syoshida@redhat.com>
    inet_diag: Initialize pad field in struct inet_diag_req_v2

Zijian Zhang <zijianzhang@bytedance.com>
    selftests: make order checking verbose in msg_zerocopy selftest

Zijian Zhang <zijianzhang@bytedance.com>
    selftests: fix OOM in msg_zerocopy selftest

Sam Sun <samsun1006219@gmail.com>
    bonding: Fix out-of-bounds read in bond_option_arp_ip_targets_set()

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: unconditionally flush pending work before notifier

Song Shuai <songshuaishuai@tinylab.org>
    riscv: kexec: Avoid deadlock in kexec crash path

Jozef Hopko <jozef.hopko@altana.com>
    wifi: wilc1000: fix ies_len type in connect path

Sagi Grimberg <sagi@grimberg.me>
    net: allow skb_datagram_iter to be called from any context

Dima Ruinskiy <dima.ruinskiy@intel.com>
    e1000e: Fix S0ix residency on corporate systems

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: fix LPSWEY handling

Jakub Kicinski <kuba@kernel.org>
    tcp_metrics: validate source addr length

Neal Cardwell <ncardwell@google.com>
    UPSTREAM: tcp: fix DSACK undo in fast recovery to call tcp_try_to_open()

Len Brown <len.brown@intel.com>
    tools/power turbostat: Remember global max_die_id

Holger Dengler <dengler@linux.ibm.com>
    s390/pkey: Wipe sensitive data on failure

Wang Yong <wang.yong12@zte.com.cn>
    jffs2: Fix potential illegal address access in jffs2_free_inode

Jose E. Marchesi <jose.marchesi@oracle.com>
    bpf: Avoid uninitialized value in BPF_CORE_READ_BITFIELD

Corinna Vinschen <vinschen@redhat.com>
    igc: fix a log entry using uninitialized netdev

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

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: replace skb_put with skb_put_zero

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

George Stark <gnstark@salutedevices.com>
    locking/mutex: Introduce devm_mutex_init()

Heiko Carstens <hca@linux.ibm.com>
    Compiler Attributes: Add __uninitialized macro


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/mach-davinci/pm.c                         |   2 +-
 arch/powerpc/include/asm/io.h                      |   2 +-
 arch/powerpc/xmon/xmon.c                           |   6 +-
 arch/riscv/kernel/machine_kexec.c                  |  10 +-
 arch/s390/include/asm/kvm_host.h                   |   1 +
 arch/s390/include/asm/processor.h                  |   2 +-
 arch/s390/kvm/kvm-s390.c                           |   1 +
 arch/s390/kvm/kvm-s390.h                           |  15 ++
 arch/s390/kvm/priv.c                               |  32 ++++
 arch/x86/entry/entry_64.S                          |  19 +-
 arch/x86/entry/entry_64_compat.S                   |  14 +-
 crypto/aead.c                                      |   3 +-
 crypto/cipher.c                                    |   3 +-
 drivers/base/regmap/regmap-i2c.c                   |   3 +-
 drivers/block/null_blk/zoned.c                     |  11 ++
 drivers/bluetooth/hci_qca.c                        |  18 +-
 drivers/char/hpet.c                                |  34 +++-
 drivers/clk/qcom/gcc-sm6350.c                      |  10 +-
 drivers/firmware/dmi_scan.c                        |  11 ++
 drivers/gpio/gpiolib-of.c                          |  92 +++++++--
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
 drivers/i2c/i2c-slave-testunit.c                   |   7 +
 drivers/infiniband/core/user_mad.c                 |  21 +-
 drivers/input/ff-core.c                            |   7 +-
 drivers/media/dvb-frontends/as102_fe_types.h       |   2 +-
 drivers/media/dvb-frontends/tda10048.c             |   9 +-
 drivers/media/dvb-frontends/tda18271c2dd.c         |   4 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |  18 +-
 drivers/media/usb/dvb-usb/dw2102.c                 | 120 +++++++-----
 drivers/media/usb/s2255/s2255drv.c                 |  20 +-
 drivers/mtd/nand/raw/nand_base.c                   |  66 ++++---
 drivers/mtd/nand/raw/rockchip-nand-controller.c    |   6 +-
 drivers/net/bonding/bond_options.c                 |   6 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |   4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |   2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         | 132 ++++++-------
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   9 +-
 drivers/net/ethernet/lantiq_etop.c                 |   5 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  10 +-
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |   8 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cpt.c    |  33 +++-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  67 ++++++-
 drivers/net/ethernet/mediatek/mtk_star_emac.c      |   7 +
 drivers/net/ethernet/micrel/ks8851_common.c        |   2 +-
 drivers/net/ppp/ppp_generic.c                      |  15 ++
 drivers/net/wireguard/allowedips.c                 |   4 +-
 drivers/net/wireguard/queueing.h                   |   4 +-
 drivers/net/wireguard/send.c                       |   2 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  10 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   2 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |   3 +-
 drivers/nfc/virtual_ncidev.c                       |   4 +
 drivers/nvme/host/multipath.c                      |   2 +-
 drivers/nvme/host/pci.c                            |   3 +-
 drivers/nvme/target/core.c                         |   9 +
 drivers/nvmem/core.c                               |   5 +-
 drivers/nvmem/meson-efuse.c                        |  14 +-
 drivers/nvmem/rmem.c                               |   5 +-
 drivers/platform/x86/touchscreen_dmi.c             |  36 ++++
 drivers/s390/crypto/pkey_api.c                     |   4 +-
 drivers/scsi/qedf/qedf_io.c                        |   6 +-
 drivers/usb/core/config.c                          |  18 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/gadget/configfs.c                      |   3 +
 drivers/usb/serial/mos7840.c                       |  45 +++++
 drivers/usb/serial/option.c                        |  38 ++++
 fs/btrfs/block-group.c                             |  13 +-
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
 fs/ntfs3/xattr.c                                   |   5 +-
 fs/orangefs/super.c                                |   3 +-
 fs/userfaultfd.c                                   |   7 +-
 include/linux/compiler_attributes.h                |  12 ++
 include/linux/fsnotify.h                           |   8 +-
 include/linux/lsm_hook_defs.h                      |   2 +-
 include/linux/mmzone.h                             |   3 +-
 include/linux/mutex.h                              |  27 +++
 include/linux/security.h                           |   5 +-
 kernel/auditfilter.c                               |   5 +-
 kernel/bpf/verifier.c                              |  11 +-
 kernel/dma/map_benchmark.c                         |   3 +
 kernel/exit.c                                      |   2 +
 kernel/locking/mutex-debug.c                       |  12 ++
 lib/kunit/try-catch.c                              |   3 +-
 mm/page-writeback.c                                |  32 +++-
 net/ceph/mon_client.c                              |  14 +-
 net/core/datagram.c                                |  20 +-
 net/core/skmsg.c                                   |   3 +-
 net/ethtool/linkstate.c                            |  41 ++--
 net/ipv4/inet_diag.c                               |   2 +
 net/ipv4/tcp_input.c                               |  13 +-
 net/ipv4/tcp_metrics.c                             |   1 +
 net/ipv4/tcp_timer.c                               |  31 ++-
 net/ipv4/udp.c                                     |   4 +-
 net/ipv6/addrconf.c                                |   9 +-
 net/ipv6/ip6_input.c                               |   2 +-
 net/ipv6/ip6_output.c                              |   2 +-
 net/netfilter/nf_tables_api.c                      |   3 +-
 net/sched/act_ct.c                                 |   8 +
 net/sctp/socket.c                                  |   7 +-
 scripts/ld-version.sh                              |   8 +-
 scripts/link-vmlinux.sh                            |   2 +-
 security/apparmor/audit.c                          |   6 +-
 security/apparmor/include/audit.h                  |   2 +-
 security/integrity/ima/ima.h                       |   2 +-
 security/integrity/ima/ima_policy.c                |  15 +-
 security/security.c                                |   6 +-
 security/selinux/include/audit.h                   |   4 +-
 security/selinux/ss/services.c                     |   5 +-
 security/smack/smack_lsm.c                         |   4 +-
 sound/pci/hda/patch_realtek.c                      |  13 ++
 tools/lib/bpf/bpf_core_read.h                      |   1 +
 tools/power/x86/turbostat/turbostat.c              |  10 +-
 .../selftests/bpf/progs/test_global_func10.c       |   9 +-
 tools/testing/selftests/bpf/verifier/calls.c       |  13 +-
 .../selftests/bpf/verifier/helper_access_var_len.c | 104 ++++++----
 tools/testing/selftests/bpf/verifier/int_ptr.c     |   9 +-
 .../selftests/bpf/verifier/search_pruning.c        |  13 +-
 tools/testing/selftests/bpf/verifier/sock.c        |  27 ---
 tools/testing/selftests/bpf/verifier/spill_fill.c  | 211 +++++++++++++++++++++
 tools/testing/selftests/bpf/verifier/var_off.c     |  52 -----
 tools/testing/selftests/net/msg_zerocopy.c         |  14 +-
 146 files changed, 1585 insertions(+), 616 deletions(-)


