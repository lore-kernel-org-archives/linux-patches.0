Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8257E1C9EC5;
	Tue, 27 Aug 2024 15:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771847; cv=none; b=stwsLeFxHiJ6PLplb3G86ClYPDwVpwihNHvZXBeHQqvcaNX8jw/eE7q8hTJ0LbQRGjNfsEXbbVRot71lGcfmppQFZb/RA8zrBbmU2AHIZXQnpflCTVFswpxRcICcUVWYm3GMxPD8KR/BaQsO6y/PdFHCVj72aZXlLQrGYJGkVuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771847; c=relaxed/simple;
	bh=7/JC0/443ZxtXWAG+ZW2gw4rQxzM0znTN5moZp6g7zg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gwISU0sqFpJQOV8fNfonxIal6DwUf0HeTXjvhWL1oDFvGXPG6v/dOkfvqcMfn/yYebInrPHEXbphW+LXZrEuYIDUQsHVFPYHJ+r8VZnkM5k6Rtx5adakV8HmruL3JOEv5oNCpdxshxOIFVqrD2ZWUc0qfIri+x1PtI/U/mzxGQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KMXvTpuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KMXvTpuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3E0C61040;
	Tue, 27 Aug 2024 15:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771847;
	bh=7/JC0/443ZxtXWAG+ZW2gw4rQxzM0znTN5moZp6g7zg=;
	h=From:To:Cc:Subject:Date:From;
	b=KMXvTpuhfVnllwfyV7Y7r/x6re+t3LAo9pQoLTvhgddvgVKQN44ZyAWf8AnzK3JdY
	 oERn0PevrpeHrcrpEt/SOToAHR8bN23UP2vl/QVSrE67VxCnH+nIkKwpNzECdfzI1/
	 luvrs5ltsfBnjtMmSpOmHORdOjcNKyfHG2ayyQLk=
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
Subject: [PATCH 6.1 000/321] 6.1.107-rc1 review
Date: Tue, 27 Aug 2024 16:35:08 +0200
Message-ID: <20240827143838.192435816@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.107-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.107-rc1
X-KernelTest-Deadline: 2024-08-29T14:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.107 release.
There are 321 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.107-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.107-rc1

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Input: MT - limit max slots

Paolo Abeni <pabeni@redhat.com>
    selftests: net: more strict check in net_helper

Yuri Benditovich <yuri.benditovich@daynix.com>
    net: change maximum number of UDP segments to 128

Dave Kleikamp <dave.kleikamp@oracle.com>
    Revert "jfs: fix shift-out-of-bounds in dbJoin"

Jesse Brandeburg <jesse.brandeburg@intel.com>
    ice: fix W=1 headers mismatch

Felix Fietkau <nbd@nbd.name>
    udp: fix receiving fraglist GSO packets

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Remove freeze_go_demote_ok

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Remove LM_FLAG_PRIORITY flag

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: don't withdraw if init_threads() got interrupted

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix another freeze/thaw hang

Felix Fietkau <nbd@nbd.name>
    wifi: cfg80211: fix receiving mesh packets without RFC1042 header

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: fix potential null pointer dereference

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: drop bogus static keywords in A-MSDU rx

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: fix receiving mesh packets in forwarding=0 networks

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: fix flow dissection for forwarded packets

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: fix mesh forwarding

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: fix mesh path discovery based on unicast packets

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: add documentation for amsdu_mesh_control

Willem de Bruijn <willemb@google.com>
    net: drop bad gso csum_start and offset in virtio_net_hdr

Willem de Bruijn <willemb@google.com>
    net: more strict VIRTIO_NET_HDR_GSO_UDP_L4 validation

Yan Zhai <yan@cloudflare.com>
    gso: fix dodgy bit handling for GSO_UDP_L4

Andrew Melnychenko <andrew@daynix.com>
    udp: allow header check for dodgy GSO_UDP_L4 packets.

Jan Höppner <hoeppner@linux.ibm.com>
    Revert "s390/dasd: Establish DMA alignment"

Li RongQing <lirongqing@baidu.com>
    KVM: x86: fire timer when it is migrated and expired, and in oneshot mode

Boyuan Zhang <boyuan.zhang@amd.com>
    drm/amdgpu/vcn: not pause dpg for unified queue

Boyuan Zhang <boyuan.zhang@amd.com>
    drm/amdgpu/vcn: identify unified queue in sw init

Lee, Chun-Yi <joeyli.kernel@gmail.com>
    Bluetooth: hci_ldisc: check HCI_UART_PROTO_READY flag in HCIUARTGETPROTO

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd: Fix a regression in nfsd_setattr()

NeilBrown <neilb@suse.de>
    nfsd: don't call locks_release_private() twice concurrently

Jeff Layton <jlayton@kernel.org>
    nfsd: drop the nfsd_put helper

NeilBrown <neilb@suse.de>
    nfsd: call nfsd_last_thread() before final nfsd_put()

NeilBrown <neilb@suse.de>
    NFSD: simplify error paths in nfsd_svc()

NeilBrown <neilb@suse.de>
    nfsd: separate nfsd_last_thread() from nfsd_put()

NeilBrown <neilb@suse.de>
    nfsd: Simplify code around svc_exit_thread() call in nfsd()

Zi Yan <ziy@nvidia.com>
    mm/numa: no task_numa_fault() call if PTE is changed

Zi Yan <ziy@nvidia.com>
    mm/numa: no task_numa_fault() call if PMD is changed

Hailong Liu <hailong.liu@oppo.com>
    mm/vmalloc: fix page mapping if vm_area_alloc_pages() with high order fallback to order 0

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Relax start tick time check for slave timer elements

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: (ltc2992) Fix memory leak in ltc2992_parse_dt()

Eric Dumazet <edumazet@google.com>
    tcp: do not export tcp_twsk_purge()

Alex Hung <alex.hung@amd.com>
    Revert "drm/amd/display: Validate hw_points_num before using it"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "usb: gadget: uvc: cleanup request when not in correct state"

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: only decrement add_addr_accepted for MPJ req

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: re-using ID of unused flushed subflows

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: re-using ID of unused removed subflows

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: re-using ID of unused removed ADD_ADDR

Peng Fan <peng.fan@nxp.com>
    pmdomain: imx: wait SSAR when i.MX93 power domain on

Ben Whitten <ben.whitten@gmail.com>
    mmc: dw_mmc: allow biu and ciu clocks to defer

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Make ICC_*SGI*_EL1 undef in the absence of a vGICv3

Nikolay Kuratov <kniv@yandex-team.ru>
    cxgb4: add forgotten u64 ivlan cast before shift

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - use new forcenorestore quirk to replace old buggy quirk combination

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - add forcenorestore quirk to leave controller untouched even on s3

Siarhei Vishniakou <svv@google.com>
    HID: microsoft: Add rumble support to latest xbox controllers

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Defer calculation of resolution until resolution_code is known

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Loongson64: Set timer mode in cpu-probe

Candice Li <candice.li@amd.com>
    drm/amdgpu: Validate TA binary size

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: the buffer of smb2 query dir response has at least 1 byte

Chaotian Jing <chaotian.jing@mediatek.com>
    scsi: core: Fix the return value of scsi_logical_block_count()

Griffin Kroah-Hartman <griffin@kroah.com>
    Bluetooth: MGMT: Add error handling to pair_device()

Dan Carpenter <dan.carpenter@linaro.org>
    mmc: mmc_test: Fix NULL dereference on allocation failure

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: cleanup FB if dpu_format_populate_layout fails

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm/msm/dp: reset the link phy params before link training

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm/msm/dp: fix the max supported bpp logic

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: don't play tricks with debug macros

Sean Anderson <sean.anderson@linux.dev>
    net: xilinx: axienet: Fix dangling multicast addresses

Sean Anderson <sean.anderson@linux.dev>
    net: xilinx: axienet: Always disable promiscuous mode

Bharat Bhushan <bbhushan2@marvell.com>
    octeontx2-af: Fix CPT AF register offset calculation

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: validate vlan header

Eric Dumazet <edumazet@google.com>
    ipv6: prevent possible UAF in ip6_xmit()

Eric Dumazet <edumazet@google.com>
    ipv6: fix possible UAF in ip6_finish_output2()

Eric Dumazet <edumazet@google.com>
    ipv6: prevent UAF in ip6_send_skb()

Stephen Hemminger <stephen@networkplumber.org>
    netem: fix return value if duplicate enqueue fails

Joseph Huang <Joseph.Huang@garmin.com>
    net: dsa: mv88e6xxx: Fix out-of-bound access

Dan Carpenter <dan.carpenter@linaro.org>
    dpaa2-switch: Fix error checking in dpaa2_switch_seed_bp()

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: fix ICE_LAST_OFFSET formula

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: fix page reuse when PAGE_SIZE is over 8k

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: Pull out next_to_clean bump out of ice_put_rx_buf()

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: Store page count inside ice_rx_buf

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: Add xdp_buff to ice_rx_ring struct

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: Prepare legacy-rx for upcoming XDP multi-buffer support

Nikolay Aleksandrov <razor@blackwall.org>
    bonding: fix xfrm state handling when clearing active slave

Nikolay Aleksandrov <razor@blackwall.org>
    bonding: fix xfrm real_dev null pointer dereference

Nikolay Aleksandrov <razor@blackwall.org>
    bonding: fix null pointer deref in bond_ipsec_offload_ok

Nikolay Aleksandrov <razor@blackwall.org>
    bonding: fix bond_ipsec_offload_ok return type

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    ip6_tunnel: Fix broken GRO

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    netfilter: nft_counter: Synchronize nft_counter_reset() against reader.

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    netfilter: nft_counter: Disable BH in nft_counter_offload_stats().

Kuniyuki Iwashima <kuniyu@amazon.com>
    kcm: Serialise kcm_sendmsg() for the same socket.

Jeremy Kerr <jk@codeconstruct.com.au>
    net: mctp: test: Use correct skb for route input check

Florian Westphal <fw@strlen.de>
    tcp: prevent concurrent execution of tcp_sk_exit_batch

Eric Dumazet <edumazet@google.com>
    tcp/dccp: do not care about families in inet_twsk_purge()

Eric Dumazet <edumazet@google.com>
    tcp/dccp: bypass empty buckets in inet_twsk_purge()

Hangbin Liu <liuhangbin@gmail.com>
    selftests: udpgro: report error when receive failed

Lucas Karpinski <lkarpins@redhat.com>
    selftests/net: synchronize udpgro tests' tx and rx connection

Simon Horman <horms@kernel.org>
    tc-testing: don't access non-existent variable on exception

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: serialize access to the injection/extraction groups

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix QoS class for injected packets with "ocelot-8021q"

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: use ocelot_xmit_get_vlan_info() also for FDMA and register injection

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: tag_ocelot: call only the relevant portion of __skb_vlan_pop() on TX

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: tag_ocelot: do not rely on skb_mac_header() for VLAN xmit

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SMP: Fix assumption of Central always being Initiator

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix LE quote calculation

Lang Yu <Lang.Yu@amd.com>
    drm/amdkfd: reserve the BO before validating it

Maximilian Luz <luzmaximilian@gmail.com>
    platform/surface: aggregator: Fix warning when controller is destroyed in probe

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Adjust cursor position

Filipe Manana <fdmanana@suse.com>
    btrfs: send: allow cloning non-aligned extent if it ends at i_size

David Sterba <dsterba@suse.com>
    btrfs: replace sb::s_blocksize by fs_info::sectorsize

Long Li <longli@microsoft.com>
    net: mana: Fix doorbell out of order violation and avoid unnecessary doorbell rings

Mikulas Patocka <mpatocka@redhat.com>
    dm suspend: return -ERESTARTSYS instead of -EINTR

Breno Leitao <leitao@debian.org>
    i2c: tegra: Do not mark ACPI devices as irq safe

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    i2c: tegra: allow VI support to be compiled out

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    i2c: tegra: allow DVC support to be compiled out

Aurelien Jarno <aurelien@aurel32.net>
    media: solo6x10: replace max(a, min(b, c)) by clamp(b, a, c)

Eric Dumazet <edumazet@google.com>
    gtp: pull network headers in gtp_dev_xmit()

Phil Chang <phil.chang@mediatek.com>
    hrtimer: Prevent queuing of hrtimer without a function callback

Jesse Zhang <jesse.zhang@amd.com>
    drm/amdgpu: fix dereference null return value for the function amdgpu_vm_pt_parent

Sagi Grimberg <sagi@grimberg.me>
    nvmet-rdma: fix possible bad dereference when freeing rsps

Baokun Li <libaokun1@huawei.com>
    ext4: set the type of max_zeroout to unsigned int to avoid overflow

Guanrui Huang <guanrui.huang@linux.alibaba.com>
    irqchip/gic-v3-its: Remove BUG_ON in its_vpe_irq_domain_alloc

Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>
    fbdev: offb: replace of_node_put with __free(device_node)

Krishna Kurapati <quic_kriskura@quicinc.com>
    usb: dwc3: core: Skip setting event buffers for host only controllers

Gergo Koteles <soyer@irl.hu>
    platform/x86: lg-laptop: fix %s null argument warning

Adrian Hunter <adrian.hunter@intel.com>
    clocksource: Make watchdog and suspend-timing multiplication overflow safe

Biju Das <biju.das.jz@bp.renesas.com>
    irqchip/renesas-rzg2l: Do not set TIEN and TINT source at the same time

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/iucv: fix receive buffer virtual vs physical address confusion

Oreoluwa Babatunde <quic_obabatun@quicinc.com>
    openrisc: Call setup_memory() earlier in the init sequence

NeilBrown <neilb@suse.de>
    NFS: avoid infinite loop in pnfs_update_layout.

Hannes Reinecke <hare@suse.de>
    nvmet-tcp: do not continue for invalid icreq

Jian Shen <shenjian15@huawei.com>
    net: hns3: add checking for vf id of mailbox

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: nct3018y: fix possible NULL dereference

Richard Fitzgerald <rf@opensource.cirrus.com>
    firmware: cirrus: cs_dsp: Initialize debugfs_root to invalid

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: bnep: Fix out-of-bound access

Keith Busch <kbusch@kernel.org>
    nvme: clear caller pointer on identify failure

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    usb: gadget: fsl: Increase size of name buffer for endpoints

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: fix to do sanity check in update_sit_entry

David Sterba <dsterba@suse.com>
    btrfs: delete pointless BUG_ON check on quota root in btrfs_qgroup_account_extent()

David Sterba <dsterba@suse.com>
    btrfs: change BUG_ON to assertion in tree_move_down()

David Sterba <dsterba@suse.com>
    btrfs: send: handle unexpected data in header buffer in begin_cmd()

David Sterba <dsterba@suse.com>
    btrfs: handle invalid root reference found in may_destroy_subvol()

David Sterba <dsterba@suse.com>
    btrfs: tests: allocate dummy fs_info and root in test_find_delalloc()

David Sterba <dsterba@suse.com>
    btrfs: change BUG_ON to assertion when checking for delayed_node root

David Sterba <dsterba@suse.com>
    btrfs: delayed-inode: drop pointless BUG_ON in __btrfs_remove_delayed_item()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/boot: Only free if realloc() succeeds

Li zeming <zeming@nfschina.com>
    powerpc/boot: Handle allocation failure in simple_realloc()

Helge Deller <deller@gmx.de>
    parisc: Use irq_enter_rcu() to fix warning at kernel/context_tracking.c:367

Christophe Kerello <christophe.kerello@foss.st.com>
    memory: stm32-fmc2-ebi: check regmap_read return value

Kees Cook <keescook@chromium.org>
    x86: Increase brk randomness entropy for 64-bit systems

Li Nan <linan122@huawei.com>
    md: clean up invalid BUG_ON in md_ioctl

Eric Dumazet <edumazet@google.com>
    netlink: hold nlk->cb_mutex longer in __netlink_dump_start()

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clocksource/drivers/arm_global_timer: Guard against division by zero

Stefan Hajnoczi <stefanha@redhat.com>
    virtiofs: forbid newlines in tags

Costa Shulyupin <costa.shul@redhat.com>
    hrtimer: Select housekeeping CPU during migration

Erico Nunes <nunes.erico@gmail.com>
    drm/lima: set gp bus_stop bit before hard reset

Kees Cook <keescook@chromium.org>
    net/sun3_82586: Avoid reading past buffer in debug output

Philipp Stanner <pstanner@redhat.com>
    media: drivers/media/dvb-core: copy user arrays safely

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Initialize status local variable in lpfc_sli4_repost_sgl_list()

Max Filippov <jcmvbkbc@gmail.com>
    fs: binfmt_elf_efpic: don't use missing interpreter's properties

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: pci: cx23885: check cx23885_vdev_init() return

Neel Natu <neelnatu@google.com>
    kernfs: fix false-positive WARN(nr_mmapped) in kernfs_drain_open_files

Jan Kara <jack@suse.cz>
    quota: Remove BUG_ON from dqget()

Al Viro <viro@zeniv.linux.org.uk>
    fuse: fix UAF in rcu pathwalks

Al Viro <viro@zeniv.linux.org.uk>
    afs: fix __afs_break_callback() / afs_drop_open_mmap() race

Baokun Li <libaokun1@huawei.com>
    ext4: do not trim the group with corrupted block bitmap

Daniel Wagner <dwagner@suse.de>
    nvmet-trace: avoid dereferencing pointer too early

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Refcounting fix in gfs2_thaw_super

Zijun Hu <quic_zijuhu@quicinc.com>
    Bluetooth: hci_conn: Check non NULL function before calling for HFP offload

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop2: clear afbc en and transform bit for cluster window at linear mode

Kees Cook <keescook@chromium.org>
    hwmon: (pc87360) Bounds check data->innr usage

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: SOF: ipc4: check return value of snd_sof_ipc_msg_data

Kunwu Chan <chentao@kylinos.cn>
    powerpc/xics: Check return value of kasprintf in icp_native_map_one_cpu

Ashish Mhetre <amhetre@nvidia.com>
    memory: tegra: Skip SID programming if SID registers aren't set

Rob Clark <robdclark@chromium.org>
    drm/msm: Reduce fallout of fence signaling vs reclaim hangs

Li Lingfeng <lilingfeng3@huawei.com>
    block: Fix lockdep warning in blk_mq_mark_tag_wait

Samuel Holland <samuel.holland@sifive.com>
    arm64: Fix KASAN random tag seed initialization

Masahiro Yamada <masahiroy@kernel.org>
    rust: fix the default format for CONFIG_{RUSTC,BINDGEN}_VERSION_TEXT

Masahiro Yamada <masahiroy@kernel.org>
    rust: suppress error messages from CONFIG_{RUSTC,BINDGEN}_VERSION_TEXT

Miguel Ojeda <ojeda@kernel.org>
    rust: work around `bindgen` 0.69.0 issue

Miguel Ojeda <ojeda@kernel.org>
    kbuild: rust_is_available: handle failures calling `$RUSTC`/`$BINDGEN`

Miguel Ojeda <ojeda@kernel.org>
    kbuild: rust_is_available: normalize version matching

Antoniu Miclaus <antoniu.miclaus@analog.com>
    hwmon: (ltc2992) Avoid division by zero

Chengfeng Ye <dg573847474@gmail.com>
    IB/hfi1: Fix potential deadlock on &irq_src_lock and &dd->uctxt_lock

Gustavo A. R. Silva <gustavoars@kernel.org>
    clk: visconti: Add bounds-checking coverage for struct visconti_pll_provider

Mukesh Sisodiya <mukesh.sisodiya@intel.com>
    wifi: iwlwifi: fw: Fix debugfs command sending

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: abort scan when rfkill on but device enabled

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: setattr_chown: Add missing initialization

Mike Christie <michael.christie@oracle.com>
    scsi: spi: Fix sshdr use

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: qcom: venus: fix incorrect return value

Mikko Perttunen <mperttunen@nvidia.com>
    drm/tegra: Zero-initialize iosys_map

Christian Brauner <brauner@kernel.org>
    binfmt_misc: cleanup on filesystem umount

Yu Kuai <yukuai3@huawei.com>
    md/raid5-cache: use READ_ONCE/WRITE_ONCE for 'conf->log'

Chengfeng Ye <dg573847474@gmail.com>
    media: s5p-mfc: Fix potential deadlock on condlock

Chengfeng Ye <dg573847474@gmail.com>
    staging: ks7010: disable bh on tx_dev_lock

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Validate hw_points_num before using it

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: gadget: uvc: cleanup request when not in correct state

David Lechner <dlechner@baylibre.com>
    staging: iio: resolver: ad2s1210: fix use before initialization

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: radio-isa: use dev_name to fill in bus_info

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Move dma unmapping after TLB flush

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i3c: mipi-i3c-hci: Do not unmap region not mapped for transfer

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i3c: mipi-i3c-hci: Remove BUG() when Ring Abort request times out

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/bridge: tc358768: Attempt to fix DSI horizontal timings

Heiko Carstens <hca@linux.ibm.com>
    s390/smp,mcck: fix early IPI handling

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rtrs: Fix the problem of variable not initialized fully

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: riic: avoid potential division by zero

Kamalesh Babulal <kamalesh.babulal@oracle.com>
    cgroup: Avoid extra dereference in css_populate_dir()

Jeff Johnson <quic_jjohnson@quicinc.com>
    wifi: cw1200: Avoid processing an invalid TIM IE

Paul E. McKenney <paulmck@kernel.org>
    rcu: Eliminate rcu_gp_slow_unregister() false positive

Zhen Lei <thunder.leizhen@huawei.com>
    rcu: Dump memory object info if callback function is invalid

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix BA session teardown race

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: check wiphy mutex is held for wdev mutex

Rand Deeb <rand.sec96@gmail.com>
    ssb: Fix division by zero issue in ssb_calc_clock_rate

Lee Jones <lee@kernel.org>
    drm/amd/amdgpu/imu_v11_0: Increase buffer size to ensure all possible values can be stored

Parsa Poorshikhian <parsa.poorsh@gmail.com>
    ALSA: hda/realtek: Fix noise from speakers on Lenovo IdeaPad 3 15IAU7

Jie Wang <wangjie125@huawei.com>
    net: hns3: fix a deadlock problem when config TC during resetting

Peiyang Wang <wangpeiyang1@huawei.com>
    net: hns3: use the user's cfg after reset

Jie Wang <wangjie125@huawei.com>
    net: hns3: fix wrong use of semaphore up

Phil Sutter <phil@nwl.cc>
    netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests

Phil Sutter <phil@nwl.cc>
    netfilter: nf_tables: Introduce nf_tables_getobj_single

Phil Sutter <phil@nwl.cc>
    netfilter: nf_tables: Carry reset boolean in nft_obj_dump_ctx

Phil Sutter <phil@nwl.cc>
    netfilter: nf_tables: nft_obj_filter fits into cb->ctx

Phil Sutter <phil@nwl.cc>
    netfilter: nf_tables: Carry s_idx in nft_obj_dump_ctx

Phil Sutter <phil@nwl.cc>
    netfilter: nf_tables: A better name for nft_obj_filter

Phil Sutter <phil@nwl.cc>
    netfilter: nf_tables: Unconditionally allocate nft_obj_filter

Phil Sutter <phil@nwl.cc>
    netfilter: nf_tables: Drop pointless memset in nf_tables_dump_obj

Phil Sutter <phil@nwl.cc>
    netfilter: nf_tables: Audit log dump reset after the fact

Florian Westphal <fw@strlen.de>
    netfilter: nf_queue: drop packets with cloned unconfirmed conntracks

Donald Hunter <donald.hunter@gmail.com>
    netfilter: flowtable: initialise extack before use

Tom Hughes <tom@compton.nu>
    netfilter: allow ipv6 fragments to arrive on different devices

Eugene Syromiatnikov <esyr@redhat.com>
    mptcp: correct MPTCP_SUBFLOW_ATTR_SSN_OFFSET reserved size

David Thompson <davthompson@nvidia.com>
    mlxbf_gige: disable RX filters until RX path initialized

Yue Haibing <yuehaibing@huawei.com>
    mlxbf_gige: Remove two unused function declarations

Pawel Dembicki <paweldembicki@gmail.com>
    net: dsa: vsc73xx: check busy flag in MDIO operations

Pawel Dembicki <paweldembicki@gmail.com>
    net: dsa: vsc73xx: use read_poll_timeout instead delay loop

Pawel Dembicki <paweldembicki@gmail.com>
    net: dsa: vsc73xx: pass value in phy_write operation

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    net: axienet: Fix register defines comment description

Dan Carpenter <dan.carpenter@linaro.org>
    atm: idt77252: prevent use after free in dequeue_rx()

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Correctly report errors for ethtool rx flows

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: Take state lock during tx timeout reporter

Faizal Rahim <faizal.abdul.rahim@linux.intel.com>
    igc: Fix packet still tx after gate close by reducing i226 MAC retry buffer

Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
    igc: Correct the launchtime offset

Takashi Iwai <tiwai@suse.de>
    ALSA: usb: Fix UBSAN warning in parse_audio_unit()

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Do copy_to_user out of run_lock

Pei Li <peili.dev@gmail.com>
    jfs: Fix shift-out-of-bounds in dbDiscardAG

Edward Adam Davis <eadavis@qq.com>
    jfs: fix null ptr deref in dtInsertEntry

Willem de Bruijn <willemb@google.com>
    fou: remove warn in gue_gro_receive on unsupported protocol

yunshui <jiangyunshui@kylinos.cn>
    bpf, net: Use DEV_STAT_INC()

Jan Kara <jack@suse.cz>
    udf: Fix bogus checksum computation in udf_rename()

Jan Kara <jack@suse.cz>
    ext4: do not create EA inode under buffer lock

Jan Kara <jack@suse.cz>
    ext4: fold quota accounting into ext4_xattr_inode_lookup_create()

Li Zhong <floridsleeves@gmail.com>
    ext4: check the return value of ext4_xattr_inode_dec_ref()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: RFCOMM: Fix not validating setsockopt user input

Alexei Starovoitov <ast@kernel.org>
    bpf: Avoid kfree_rcu() under lock in bpf_lpm_trie.

Kees Cook <keescook@chromium.org>
    bpf: Replace bpf_lpm_trie_key 0-length array with flexible array

Donald Hunter <donald.hunter@gmail.com>
    docs/bpf: Document BPF_MAP_TYPE_LPM_TRIE map

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: check A-MSDU format more carefully

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: add a workaround for receiving non-standard mesh A-MSDU

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: fix receiving A-MSDU frames on mesh interfaces

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: remove mesh forwarding congestion check

Felix Fietkau <nbd@nbd.name>
    wifi: cfg80211: factor out bridge tunnel / RFC1042 header check

Felix Fietkau <nbd@nbd.name>
    wifi: cfg80211: move A-MSDU check in ieee80211_data_to_8023_exthdr

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: fix and simplify unencrypted drop check for mesh

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    pppoe: Fix memory leak in pppoe_sendmsg()

Dmitry Antipov <dmantipov@yandex.ru>
    net: sctp: fix skb leak in sctp_inq_free()

Allison Henderson <allison.henderson@oracle.com>
    net:rds: Fix possible deadlock in rds_message_put

Jan Kara <jack@suse.cz>
    quota: Detect loops in quota tree

Gao Xiang <xiang@kernel.org>
    erofs: avoid debugging output for (de)compressed data

Edward Adam Davis <eadavis@qq.com>
    reiserfs: fix uninit-value in comp_keys

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: fix variable overflow triggered by sysbot

Lizhi Xu <lizhi.xu@windriver.com>
    squashfs: squashfs_read_data need to check if the length is 0

Manas Ghandat <ghandatmanas@gmail.com>
    jfs: fix shift-out-of-bounds in dbJoin

Jakub Kicinski <kuba@kernel.org>
    net: don't dump stack on queue timeout

Yajun Deng <yajun.deng@linux.dev>
    net: sched: Print msecs when transmit queue time out

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix change_address deadlock during unregister

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: take wiphy lock for MAC addr change

Ying Hsu <yinghsu@chromium.org>
    Bluetooth: Fix hci_link_tx_to RCU lock usage

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Stop using gfs2_make_fs_ro for withdraw

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Rework freeze / thaw logic

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Rename SDF_{FS_FROZEN => FREEZE_INITIATOR}

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Rename gfs2_freeze_lock{ => _shared }

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Rename the {freeze,thaw}_super callbacks

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Rename remaining "transaction" glock references

Kees Cook <keescook@chromium.org>
    pid: Replace struct pid 1-element array with flex-array

Thomas Gleixner <tglx@linutronix.de>
    posix-timers: Ensure timer ID search-loop limit is valid

Andrii Nakryiko <andrii@kernel.org>
    bpf: drop unnecessary user-triggerable WARN_ONCE in verifierl log

Andrii Nakryiko <andrii@kernel.org>
    bpf: Split off basic BPF verifier log into separate file

Ivan Orlov <ivan.orlov0322@gmail.com>
    mm: khugepaged: fix kernel BUG in hpage_collapse_scan_file()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    nilfs2: initialize "struct nilfs_binfo_dat"->bi_pad field

Ivan Orlov <ivan.orlov0322@gmail.com>
    9P FS: Fix wild-memory-access write in v9fs_get_acl

Theodore Ts'o <tytso@mit.edu>
    ext4, jbd2: add an optimized bmap for the journal inode

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: prevent WARNING in nilfs_dat_commit_end()

Leon Hwang <leon.hwang@linux.dev>
    bpf: Fix updating attached freplace prog in prog_array map

Claudio Imbrenda <imbrenda@linux.ibm.com>
    s390/uv: Panic for set and remove shared access UVC errors

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/jpeg2: properly set atomics vmid field

Al Viro <viro@zeniv.linux.org.uk>
    memcg_write_event_control(): fix a user-triggerable oops

Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
    drm/amdgpu: Actually check flags for all context ops.

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: add dev extent item checks

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: properly take lock to read/update block group's zoned variables

Waiman Long <longman@redhat.com>
    mm/memory-failure: use raw_spinlock_t in struct memory_failure_cpu

Zhen Lei <thunder.leizhen@huawei.com>
    selinux: fix potential counting error in avc_add_xperms_decision()

Max Kellermann <max.kellermann@ionos.com>
    fs/netfs/fscache_cookie: add missing "n_accesses" check

Dan Carpenter <dan.carpenter@linaro.org>
    rtla/osnoise: Prevent NULL dereference in error handling

Andi Shyti <andi.shyti@kernel.org>
    i2c: qcom-geni: Add missing geni_icc_disable in geni_i2c_runtime_resume

Al Viro <viro@zeniv.linux.org.uk>
    fix bitmap corruption on close_range() with CLOSE_RANGE_UNSHARE

Alexander Lobakin <aleksander.lobakin@intel.com>
    bitmap: introduce generic optimized bitmap_size()

Alexander Lobakin <aleksander.lobakin@intel.com>
    btrfs: rename bitmap_set_bits() -> btrfs_bitmap_set_bits()

Alexander Lobakin <aleksander.lobakin@intel.com>
    s390/cio: rename bitmap_size() -> idset_bitmap_size()

Alexander Lobakin <aleksander.lobakin@intel.com>
    fs/ntfs3: add prefix to bitmap_size() and use BITS_TO_U64()

Zhihao Cheng <chengzhihao1@huawei.com>
    vfs: Don't evict inode under the inode lru traversing context

Mikulas Patocka <mpatocka@redhat.com>
    dm persistent data: fix memory allocation failure

Khazhismel Kumykov <khazhy@google.com>
    dm resume: don't return EINVAL when signalled

Haibo Xu <haibo1.xu@intel.com>
    arm64: ACPI: NUMA: initialize all values of acpi_early_node_map to NUMA_NO_NODE

Nam Cao <namcao@linutronix.de>
    riscv: change XIP's kernel_map.size to be size of the entire kernel

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix error recovery leading to data corruption on ESE devices

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Mark XDomain as unplugged when router is removed

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix Panther point NULL pointer deref at full-speed re-enumeration

Juan José Arboleda <soyjuanarbol@gmail.com>
    ALSA: usb-audio: Support Yamaha P-125 quirk entry

Lianqin Hu <hulianqin@vivo.com>
    ALSA: usb-audio: Add delay quirk for VIVO USB-C-XE710 HEADSET

Eli Billauer <eli.billauer@gmail.com>
    char: xillybus: Check USB endpoints when probing device

Eli Billauer <eli.billauer@gmail.com>
    char: xillybus: Refine workqueue handling

Eli Billauer <eli.billauer@gmail.com>
    char: xillybus: Don't destroy workqueue from work item running on it

Jann Horn <jannh@google.com>
    fuse: Initialize beyond-EOF page contents before setting uptodate

Mathieu Othacehe <othacehe@gnu.org>
    tty: atmel_serial: use the correct RTS flag.


-------------

Diffstat:

 Documentation/bpf/map_lpm_trie.rst                 | 181 ++++++++++
 Documentation/filesystems/gfs2-glocks.rst          |   3 +-
 Makefile                                           |   4 +-
 arch/arm64/kernel/acpi_numa.c                      |   2 +-
 arch/arm64/kernel/setup.c                          |   3 -
 arch/arm64/kernel/smp.c                            |   2 +
 arch/arm64/kvm/sys_regs.c                          |   6 +
 arch/arm64/kvm/vgic/vgic.h                         |   7 +
 arch/mips/kernel/cpu-probe.c                       |   4 +
 arch/openrisc/kernel/setup.c                       |   6 +-
 arch/parisc/kernel/irq.c                           |   4 +-
 arch/powerpc/boot/simple_alloc.c                   |   7 +-
 arch/powerpc/sysdev/xics/icp-native.c              |   2 +
 arch/riscv/mm/init.c                               |   4 +-
 arch/s390/include/asm/uv.h                         |   5 +-
 arch/s390/kernel/early.c                           |  12 +-
 arch/s390/kernel/smp.c                             |   4 +-
 arch/x86/kernel/process.c                          |   5 +-
 arch/x86/kvm/lapic.c                               |   8 +-
 block/blk-mq-tag.c                                 |   5 +-
 drivers/atm/idt77252.c                             |   9 +-
 drivers/bluetooth/hci_ldisc.c                      |   3 +-
 drivers/char/xillybus/xillyusb.c                   |  42 ++-
 drivers/clk/visconti/pll.c                         |   6 +-
 drivers/clocksource/arm_global_timer.c             |  11 +-
 drivers/firmware/cirrus/cs_dsp.c                   |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h         |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |  40 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c            |   8 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c         |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c            |  53 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c          |   6 +-
 drivers/gpu/drm/amd/amdgpu/imu_v11_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c             |   4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  24 +-
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |   2 +-
 drivers/gpu/drm/bridge/tc358768.c                  | 215 ++++++++++--
 drivers/gpu/drm/lima/lima_gp.c                     |  12 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.h            |  14 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c          |   3 +
 drivers/gpu/drm/msm/dp/dp_ctrl.c                   |   2 +
 drivers/gpu/drm/msm/dp/dp_panel.c                  |  19 +-
 drivers/gpu/drm/msm/msm_gem_shrinker.c             |   2 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |   5 +
 drivers/gpu/drm/tegra/gem.c                        |   2 +-
 drivers/hid/hid-ids.h                              |  10 +-
 drivers/hid/hid-microsoft.c                        |  11 +-
 drivers/hid/wacom_wac.c                            |   4 +-
 drivers/hwmon/ltc2992.c                            |   8 +-
 drivers/hwmon/pc87360.c                            |   6 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |   4 +-
 drivers/i2c/busses/i2c-riic.c                      |   2 +-
 drivers/i2c/busses/i2c-tegra.c                     |  41 ++-
 drivers/i3c/master/mipi-i3c-hci/dma.c              |   5 +-
 drivers/infiniband/hw/hfi1/chip.c                  |   5 +-
 drivers/infiniband/ulp/rtrs/rtrs.c                 |   2 +-
 drivers/input/input-mt.c                           |   3 +
 drivers/input/serio/i8042-acpipnpio.h              |  20 +-
 drivers/input/serio/i8042.c                        |  10 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   2 -
 drivers/irqchip/irq-renesas-rzg2l.c                |   5 +-
 drivers/md/dm-clone-metadata.c                     |   5 -
 drivers/md/dm-ioctl.c                              |  22 +-
 drivers/md/dm.c                                    |   4 +-
 drivers/md/md.c                                    |   5 -
 drivers/md/persistent-data/dm-space-map-metadata.c |   4 +-
 drivers/md/raid5-cache.c                           |  47 +--
 drivers/media/dvb-core/dvb_frontend.c              |  12 +-
 drivers/media/pci/cx23885/cx23885-video.c          |   8 +
 drivers/media/pci/solo6x10/solo6x10-offsets.h      |  10 +-
 drivers/media/platform/qcom/venus/pm_helpers.c     |   2 +-
 .../media/platform/samsung/s5p-mfc/s5p_mfc_enc.c   |   2 +-
 drivers/media/radio/radio-isa.c                    |   2 +-
 drivers/memory/stm32-fmc2-ebi.c                    | 122 +++++--
 drivers/memory/tegra/tegra186.c                    |   3 +
 drivers/mmc/core/mmc_test.c                        |   9 +-
 drivers/mmc/host/dw_mmc.c                          |   8 +
 drivers/net/bonding/bond_main.c                    |  21 +-
 drivers/net/bonding/bond_options.c                 |   2 +-
 drivers/net/dsa/mv88e6xxx/global1_atu.c            |   3 +-
 drivers/net/dsa/ocelot/felix.c                     |  11 +
 drivers/net/dsa/vitesse-vsc73xx-core.c             |  69 +++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |   3 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |   7 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   3 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  28 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   7 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |   3 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   4 +-
 drivers/net/ethernet/i825xx/sun3_82586.c           |   2 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |   4 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   8 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  10 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          | 117 +++----
 drivers/net/ethernet/intel/ice/ice_txrx.h          |   6 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c      |   1 +
 drivers/net/ethernet/intel/igc/igc_defines.h       |  15 +
 drivers/net/ethernet/intel/igc/igc_main.c          |   7 +
 drivers/net/ethernet/intel/igc/igc_regs.h          |   1 +
 drivers/net/ethernet/intel/igc/igc_tsn.c           |  64 ++++
 drivers/net/ethernet/intel/igc/igc_tsn.h           |   1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cpt.c    |  23 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |   2 +
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |   2 +-
 .../net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h  |   9 +-
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c |  10 +
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h |   2 +
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c   |  50 ++-
 drivers/net/ethernet/microsoft/mana/mana.h         |   1 +
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  22 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  91 ++++-
 drivers/net/ethernet/mscc/ocelot_fdma.c            |   3 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c         |   4 +
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |  17 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  25 +-
 drivers/net/gtp.c                                  |   3 +
 drivers/net/ppp/pppoe.c                            |  23 +-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   2 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |   2 +-
 drivers/net/wireless/st/cw1200/txrx.c              |   2 +-
 drivers/nvme/host/core.c                           |   5 +-
 drivers/nvme/target/rdma.c                         |  16 +-
 drivers/nvme/target/tcp.c                          |   1 +
 drivers/nvme/target/trace.c                        |   6 +-
 drivers/nvme/target/trace.h                        |  28 +-
 drivers/platform/surface/aggregator/controller.c   |   3 +-
 drivers/platform/x86/lg-laptop.c                   |   2 +-
 drivers/rtc/rtc-nct3018y.c                         |   6 +-
 drivers/s390/block/dasd.c                          |  36 +-
 drivers/s390/block/dasd_3990_erp.c                 |  10 +-
 drivers/s390/block/dasd_diag.c                     |   1 -
 drivers/s390/block/dasd_eckd.c                     |  58 ++-
 drivers/s390/block/dasd_int.h                      |   2 +-
 drivers/s390/cio/idset.c                           |  12 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   2 +-
 drivers/scsi/scsi_transport_spi.c                  |   4 +-
 drivers/soc/imx/imx93-pd.c                         |   5 +-
 drivers/ssb/main.c                                 |   2 +-
 drivers/staging/iio/resolver/ad2s1210.c            |   7 +-
 drivers/staging/ks7010/ks7010_sdio.c               |   4 +-
 drivers/thunderbolt/switch.c                       |   1 +
 drivers/tty/serial/atmel_serial.c                  |   2 +-
 drivers/usb/dwc3/core.c                            |  13 +
 drivers/usb/gadget/udc/fsl_udc_core.c              |   2 +-
 drivers/usb/host/xhci.c                            |   8 +-
 drivers/video/fbdev/offb.c                         |   3 +-
 fs/9p/xattr.c                                      |   8 +-
 fs/afs/file.c                                      |   8 +-
 fs/binfmt_elf_fdpic.c                              |   2 +-
 fs/binfmt_misc.c                                   | 216 +++++++++---
 fs/btrfs/delayed-inode.c                           |   4 +-
 fs/btrfs/disk-io.c                                 |   2 +
 fs/btrfs/extent_io.c                               |   4 +-
 fs/btrfs/free-space-cache.c                        |  22 +-
 fs/btrfs/inode.c                                   |  11 +-
 fs/btrfs/ioctl.c                                   |   2 +-
 fs/btrfs/qgroup.c                                  |   2 -
 fs/btrfs/reflink.c                                 |   6 +-
 fs/btrfs/send.c                                    |  63 +++-
 fs/btrfs/super.c                                   |   2 +-
 fs/btrfs/tests/extent-io-tests.c                   |  28 +-
 fs/btrfs/tree-checker.c                            |  69 ++++
 fs/erofs/decompressor.c                            |   8 +-
 fs/ext4/extents.c                                  |   3 +-
 fs/ext4/mballoc.c                                  |   3 +
 fs/ext4/super.c                                    |  23 ++
 fs/ext4/xattr.c                                    | 158 ++++-----
 fs/f2fs/segment.c                                  |   5 +-
 fs/file.c                                          |  28 +-
 fs/fscache/cookie.c                                |   4 +
 fs/fuse/cuse.c                                     |   3 +-
 fs/fuse/dev.c                                      |   6 +-
 fs/fuse/fuse_i.h                                   |   1 +
 fs/fuse/inode.c                                    |  15 +-
 fs/fuse/virtio_fs.c                                |  10 +
 fs/gfs2/glock.c                                    |  27 +-
 fs/gfs2/glock.h                                    |   9 -
 fs/gfs2/glops.c                                    |  66 ++--
 fs/gfs2/incore.h                                   |   2 +-
 fs/gfs2/inode.c                                    |   2 +-
 fs/gfs2/lock_dlm.c                                 |   5 -
 fs/gfs2/log.c                                      |   2 -
 fs/gfs2/ops_fstype.c                               |  13 +-
 fs/gfs2/recovery.c                                 |  28 +-
 fs/gfs2/super.c                                    | 197 ++++++++---
 fs/gfs2/super.h                                    |   1 +
 fs/gfs2/sys.c                                      |   2 +-
 fs/gfs2/util.c                                     |  53 +--
 fs/gfs2/util.h                                     |   5 +-
 fs/inode.c                                         |  39 ++-
 fs/jbd2/journal.c                                  |   9 +-
 fs/jfs/jfs_dmap.c                                  |   2 +
 fs/jfs/jfs_dtree.c                                 |   2 +
 fs/kernfs/file.c                                   |   8 +-
 fs/nfs/pnfs.c                                      |   8 +
 fs/nfsd/nfs4proc.c                                 |   4 +
 fs/nfsd/nfs4state.c                                |   2 +-
 fs/nfsd/nfsctl.c                                   |  32 +-
 fs/nfsd/nfsd.h                                     |   3 +-
 fs/nfsd/nfssvc.c                                   |  85 ++---
 fs/nfsd/vfs.c                                      |   6 +-
 fs/nilfs2/btree.c                                  |   1 +
 fs/nilfs2/dat.c                                    |  11 +
 fs/nilfs2/direct.c                                 |   1 +
 fs/ntfs3/bitmap.c                                  |   4 +-
 fs/ntfs3/frecord.c                                 |  75 +++-
 fs/ntfs3/fsntfs.c                                  |   2 +-
 fs/ntfs3/index.c                                   |  11 +-
 fs/ntfs3/ntfs_fs.h                                 |   4 +-
 fs/ntfs3/super.c                                   |   2 +-
 fs/quota/dquot.c                                   |   5 +-
 fs/quota/quota_tree.c                              | 128 +++++--
 fs/quota/quota_v2.c                                |  15 +-
 fs/reiserfs/stree.c                                |   2 +-
 fs/smb/server/smb2pdu.c                            |   3 +-
 fs/squashfs/block.c                                |   2 +-
 fs/squashfs/file.c                                 |   3 +-
 fs/squashfs/file_direct.c                          |   6 +-
 fs/udf/namei.c                                     |   1 -
 include/linux/bitmap.h                             |  20 +-
 include/linux/bpf_verifier.h                       |  23 +-
 include/linux/cpumask.h                            |   2 +-
 include/linux/dsa/ocelot.h                         |  47 +++
 include/linux/fs.h                                 |   5 +
 include/linux/if_vlan.h                            |  21 ++
 include/linux/jbd2.h                               |   8 +
 include/linux/pid.h                                |   2 +-
 include/linux/sched/signal.h                       |   2 +-
 include/linux/sunrpc/svc.h                         |  13 -
 include/linux/udp.h                                |   2 +-
 include/linux/virtio_net.h                         |  35 +-
 include/net/cfg80211.h                             |  40 ++-
 include/net/inet_timewait_sock.h                   |   2 +-
 include/net/kcm.h                                  |   1 +
 include/net/tcp.h                                  |   2 +-
 include/scsi/scsi_cmnd.h                           |   2 +-
 include/soc/mscc/ocelot.h                          |  12 +-
 include/trace/events/huge_memory.h                 |   3 +-
 include/uapi/linux/bpf.h                           |  19 +-
 init/Kconfig                                       |   7 +-
 kernel/bpf/Makefile                                |   3 +-
 kernel/bpf/log.c                                   |  82 +++++
 kernel/bpf/lpm_trie.c                              |  33 +-
 kernel/bpf/verifier.c                              |  69 ----
 kernel/cgroup/cgroup.c                             |   4 +-
 kernel/pid.c                                       |   7 +-
 kernel/pid_namespace.c                             |   2 +-
 kernel/rcu/rcu.h                                   |   7 +
 kernel/rcu/srcutiny.c                              |   1 +
 kernel/rcu/srcutree.c                              |   1 +
 kernel/rcu/tasks.h                                 |   1 +
 kernel/rcu/tiny.c                                  |   1 +
 kernel/rcu/tree.c                                  |   3 +-
 kernel/time/clocksource.c                          |  42 ++-
 kernel/time/hrtimer.c                              |   5 +-
 kernel/time/posix-timers.c                         |  31 +-
 lib/math/prime_numbers.c                           |   2 -
 mm/huge_memory.c                                   |  30 +-
 mm/khugepaged.c                                    |  20 ++
 mm/memcontrol.c                                    |   7 +-
 mm/memory-failure.c                                |  20 +-
 mm/memory.c                                        |  29 +-
 mm/vmalloc.c                                       |  11 +-
 net/bluetooth/bnep/core.c                          |   3 +-
 net/bluetooth/hci_conn.c                           |  11 +-
 net/bluetooth/hci_core.c                           |  24 +-
 net/bluetooth/mgmt.c                               |   4 +
 net/bluetooth/rfcomm/sock.c                        |  14 +-
 net/bluetooth/smp.c                                | 146 ++++----
 net/bridge/br_netfilter_hooks.c                    |   6 +-
 net/core/filter.c                                  |   8 +-
 net/core/skbuff.c                                  |   8 +-
 net/dccp/ipv4.c                                    |   2 +-
 net/dccp/ipv6.c                                    |   6 -
 net/dsa/tag_ocelot.c                               |  37 +-
 net/ipv4/fou.c                                     |   2 +-
 net/ipv4/inet_timewait_sock.c                      |  16 +-
 net/ipv4/tcp_ipv4.c                                |  16 +-
 net/ipv4/tcp_minisocks.c                           |   7 +-
 net/ipv4/tcp_offload.c                             |   3 +
 net/ipv4/udp_offload.c                             |  18 +-
 net/ipv6/ip6_output.c                              |  10 +
 net/ipv6/ip6_tunnel.c                              |  12 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |   4 +
 net/ipv6/tcp_ipv6.c                                |   6 -
 net/iucv/iucv.c                                    |   3 +-
 net/kcm/kcmsock.c                                  |   4 +
 net/mac80211/agg-tx.c                              |   6 +-
 net/mac80211/debugfs_netdev.c                      |   3 -
 net/mac80211/driver-ops.c                          |   3 -
 net/mac80211/ieee80211_i.h                         |   1 -
 net/mac80211/iface.c                               |  27 +-
 net/mac80211/rx.c                                  | 387 +++++++++++----------
 net/mac80211/sta_info.c                            |  17 +
 net/mac80211/sta_info.h                            |   3 +
 net/mctp/test/route-test.c                         |   2 +-
 net/mptcp/diag.c                                   |   2 +-
 net/mptcp/pm_netlink.c                             |  31 +-
 net/netfilter/nf_flow_table_inet.c                 |   3 +
 net/netfilter/nf_flow_table_ip.c                   |   3 +
 net/netfilter/nf_flow_table_offload.c              |   2 +-
 net/netfilter/nf_tables_api.c                      | 225 +++++++-----
 net/netfilter/nfnetlink_queue.c                    |  35 +-
 net/netfilter/nft_counter.c                        |   9 +-
 net/netlink/af_netlink.c                           |  13 +-
 net/rds/recv.c                                     |  13 +-
 net/sched/sch_generic.c                            |  11 +-
 net/sched/sch_netem.c                              |  47 ++-
 net/sctp/inqueue.c                                 |  14 +-
 net/wireless/core.h                                |   8 +-
 net/wireless/util.c                                | 195 +++++++----
 samples/bpf/map_perf_test_user.c                   |   2 +-
 samples/bpf/xdp_router_ipv4_user.c                 |   2 +-
 scripts/rust_is_available.sh                       |  41 ++-
 security/selinux/avc.c                             |   2 +-
 sound/core/timer.c                                 |   2 +-
 sound/pci/hda/patch_realtek.c                      |   1 -
 sound/soc/sof/ipc4.c                               |   9 +-
 sound/usb/mixer.c                                  |   7 +
 sound/usb/quirks-table.h                           |   1 +
 sound/usb/quirks.c                                 |   2 +
 tools/include/linux/bitmap.h                       |   7 +-
 tools/include/uapi/linux/bpf.h                     |  19 +-
 tools/testing/selftests/bpf/progs/map_ptr_kern.c   |   2 +-
 tools/testing/selftests/bpf/test_lpm_map.c         |  18 +-
 tools/testing/selftests/core/close_range_test.c    |  35 ++
 tools/testing/selftests/net/net_helper.sh          |  25 ++
 tools/testing/selftests/net/udpgro.sh              |  57 +--
 tools/testing/selftests/net/udpgro_bench.sh        |   5 +-
 tools/testing/selftests/net/udpgro_frglist.sh      |   5 +-
 tools/testing/selftests/net/udpgso.c               |   2 +-
 tools/testing/selftests/tc-testing/tdc.py          |   1 -
 tools/tracing/rtla/src/osnoise_top.c               |  11 +-
 335 files changed, 4050 insertions(+), 2027 deletions(-)


