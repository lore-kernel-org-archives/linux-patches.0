Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1D8126C05;
	Mon,  6 Jan 2025 15:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176774; cv=none; b=KG8p9XxSrBGr+QAfLYh2qWz9VxHAVQKhacHrT48uN+XlUe/fGa/QHDIRFLZ7XKjuf5TbQztqM9+lxgo19cpGjO2xj1KNwn9KUcOY72M4uBtQFmw/H5mpZyx8IOk9ASFSzloszI+56E516uCwmpgOJUe2FVP63W/kTg5zUNFjQt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176774; c=relaxed/simple;
	bh=55etlmkFK5gAsBVB69do1sWcZz4fSxZcNn+gcxHGnkY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QV3TA7QNjwGWcpe2Oo2sdGB9vpyimL8ve+F5kkeSQL7umY644YtLcKzf1MsZu0BzcGntfz9AziJe2bQrEUVi/jE5j6bRls/6QfxQhKw4f8P0ktxp9N0xyxGq0QwJK8NwxXZPefQjNaurba3ZwLQuGsKS7vGh8+UOZ+p2qwZW000=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hLmk9v+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hLmk9v+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95CCC4CED2;
	Mon,  6 Jan 2025 15:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176773;
	bh=55etlmkFK5gAsBVB69do1sWcZz4fSxZcNn+gcxHGnkY=;
	h=From:To:Cc:Subject:Date:From;
	b=hLmk9v+TtYkkISstClgy2WfEseIiy9M/roq5GXXquKg6aJXwwf+cUXw5R0maflwUR
	 1hRaD8u2oHYswrvzrj58yg1RvX29bAbo3tI+SECmNSikLk0NpEUblIwSHxPxfCd0ZV
	 BSy+MwTGmo9QK6IignhZkNUgfiUmQgisHZtLld0w=
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
	hargar@microsoft.com,
	broonie@kernel.org
Subject: [PATCH 6.1 00/81] 6.1.124-rc1 review
Date: Mon,  6 Jan 2025 16:15:32 +0100
Message-ID: <20250106151129.433047073@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.124-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.124-rc1
X-KernelTest-Deadline: 2025-01-08T15:11+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.124 release.
There are 81 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.124-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.124-rc1

Paolo Abeni <pabeni@redhat.com>
    mptcp: don't always assume copied data in mptcp_cleanup_rbuf()

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix recvbuffer adjust on sleeping rcvmsg

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix TCP options overflow.

Seiji Nishikawa <snishika@redhat.com>
    mm: vmscan: account for free pages to prevent infinite Loop in throttle_direct_reclaim()

Yafang Shao <laoar.shao@gmail.com>
    mm/readahead: fix large folio support in async readahead

Biju Das <biju.das.jz@bp.renesas.com>
    dt-bindings: display: adi,adv7533: Drop single lane support

Biju Das <biju.das.jz@bp.renesas.com>
    drm: adv7511: Drop dsi single lane support

Nikolay Kuratov <kniv@yandex-team.ru>
    net/sctp: Prevent autoclose integer overflow in sctp_association_init()

Pascal Hambourg <pascal@plouf.fr.eu.org>
    sky2: Add device ID 11ab:4373 for Marvell 88E8075

Evgenii Shatokhin <e.shatokhin@yadro.com>
    pinctrl: mcp23s08: Fix sleeping in atomic context due to regmap locking

Dan Carpenter <dan.carpenter@linaro.org>
    RDMA/uverbs: Prevent integer overflow issue

Arnd Bergmann <arnd@arndb.de>
    kcov: mark in_softirq_really() as __always_inline

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Fix races at processing SysEx messages

Daniel Schaefer <dhs@frame.work>
    ALSA hda/realtek: Add quirk for Framework F111:000C

Masahiro Yamada <masahiroy@kernel.org>
    modpost: fix the missed iteration for the max bit in do_input()

Masahiro Yamada <masahiroy@kernel.org>
    modpost: fix input MODULE_DEVICE_TABLE() built for 64-bit on 32-bit host

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Avoid queuing redundant Stop Endpoint commands

Leon Romanovsky <leon@kernel.org>
    ARC: build: Try to guess GCC variant of cross compiler

Uros Bizjak <ubizjak@gmail.com>
    irqchip/gic: Correct declaration of *percpu_base pointer in union gic_base

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix sleeping function called from invalid context

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit FE910C04 compositions

Hobin Woo <hobin.woo@samsung.com>
    ksmbd: retry iterate_dir in smb2_query_dir

Anton Protopopov <aspsk@isovalent.com>
    bpf: fix potential error return

Adrian Ratiu <adrian.ratiu@collabora.com>
    sound: usb: format: don't warn that raw DSD is unsupported

Adrian Ratiu <adrian.ratiu@collabora.com>
    sound: usb: enable DSD output for ddHiFi TC44C

Vasiliy Kovalev <kovalev@altlinux.org>
    ALSA: hda/realtek: Add new alc2xx-fixup-headset-mic model

Filipe Manana <fdmanana@suse.com>
    btrfs: flush delalloc workers queue before stopping cleaner kthread during unmount

Prike Liang <Prike.Liang@amd.com>
    drm/amdkfd: Correct the migration DMA map direction

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: mac80211: wake the queues in case of failure in resume

Filipe Manana <fdmanana@suse.com>
    btrfs: fix use-after-free when COWing tree bock and tracing is enabled

Filipe Manana <fdmanana@suse.com>
    btrfs: rename and export __btrfs_cow_block()

Eric Dumazet <edumazet@google.com>
    ila: serialize calls to nf_register_net_hooks()

Eric Dumazet <edumazet@google.com>
    af_packet: fix vlan_get_protocol_dgram() vs MSG_PEEK

Eric Dumazet <edumazet@google.com>
    af_packet: fix vlan_get_tci() vs MSG_PEEK

Maciej S. Szmigiero <mail@maciej.szmigiero.name>
    net: wwan: iosm: Properly check for valid exec stage in ipc_mmio_init()

Eric Dumazet <edumazet@google.com>
    net: restrict SO_REUSEPORT to inet sockets

Willem de Bruijn <willemb@google.com>
    net: reenable NETIF_F_IPV6_CSUM offload for BIG TCP packets

Li Zhijian <lizhijian@fujitsu.com>
    RDMA/rtrs: Ensure 'ib_sge list' is accessible

Jinjian Song <jinjian.song@fibocom.com>
    net: wwan: t7xx: Fix FSM command timeout issue

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    net: mv643xx_eth: fix an OF node reference leak

Vitalii Mordan <mordan@ispras.ru>
    eth: bcmsysport: fix call balance of priv->clk handling routines

Tanya Agarwal <tanyaagarwal25699@gmail.com>
    ALSA: usb-audio: US16x08: Initialize array before use

Antonio Pastor <antonio.pastor@gmail.com>
    net: llc: reset skb->transport_header

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_hash: unaligned atomic read on struct nft_set_ext

Rodrigo Vivi <rodrigo.vivi@intel.com>
    drm/i915/dg1: Fix power gate sequence.

Ilya Shchipletsov <rabbelkin@mail.ru>
    netrom: check buffer length before accessing it

Xiao Liang <shaw.leon@gmail.com>
    net: Fix netns for ip_tunnel_init_flow()

Ido Schimmel <idosch@nvidia.com>
    ipv4: ip_tunnel: Unmask upper DSCP bits in ip_tunnel_xmit()

Ido Schimmel <idosch@nvidia.com>
    ipv4: ip_tunnel: Unmask upper DSCP bits in ip_md_tunnel_xmit()

Ido Schimmel <idosch@nvidia.com>
    ipv4: ip_tunnel: Unmask upper DSCP bits in ip_tunnel_bind_dev()

Eric Dumazet <edumazet@google.com>
    ip_tunnel: annotate data-races around t->parms.link

Christian Ehrig <cehrig@cloudflare.com>
    ipip,ip_tunnel,sit: Add FOU support for externally controlled ipip devices

Wang Liang <wangliang74@huawei.com>
    net: fix memory leak in tcp_conn_request()

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    net: stmmac: restructure the error path of stmmac_probe_config_dt()

Andrew Halaney <ahalaney@redhat.com>
    net: stmmac: don't create a MDIO bus if unnecessary

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    net: stmmac: platform: provide devm_stmmac_probe_config_dt()

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix missing flush CQE for DWQE

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix warning storm caused by invalid input in IO path

wenglianfa <wenglianfa@huawei.com>
    RDMA/hns: Fix mapping error of zero-hop WQE buffer

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Remove unused parameters and variables

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Refactor mtr find

Tristram Ha <tristram.ha@microchip.com>
    net: dsa: microchip: Fix LAN937X set_ageing_time function

Oleksij Rempel <linux@rempel-privat.de>
    net: dsa: microchip: add ksz_rmw8() function

Tristram Ha <tristram.ha@microchip.com>
    net: dsa: microchip: Fix KSZ9477 set_ageing_time function

Stefan Ekenberg <stefan.ekenberg@axis.com>
    drm/bridge: adv7511_audio: Update Audio InfoFrame properly

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix the locking while accessing the QP table

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix max_qp_wrs reported

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Fix reporting hw_ver in query_device

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    RDMA/bnxt_re: Add check for path mtu in modify_qp

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Enforce same type port association for multiport RoCE

Jeremy Kerr <jk@codeconstruct.com.au>
    net: mctp: handle skb cleanup on sock_queue failures

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Turn NEC specific quirk for handling Stop Endpoint errors generic

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Limit Stop Endpoint retries

Michal Pecio <michal.pecio@gmail.com>
    xhci: retry Stop Endpoint on buggy NEC controllers

Mario Limonciello <mario.limonciello@amd.com>
    thunderbolt: Don't display nvm_version unless upgrade supported

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Add support for Intel Panther Lake-M/P

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Add support for Intel Lunar Lake

Steven Rostedt <rostedt@goodmis.org>
    tracing: Have process_string() also allow arrays

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: fix use-after-free in btrfs_encoded_read_endio()

Thiébaud Weksteen <tweek@google.com>
    selinux: ignore unknown extended permissions

Naman Jain <namjain@linux.microsoft.com>
    x86/hyperv: Fix hv tsc page based sched_clock for hibernation


-------------

Diffstat:

 .../bindings/display/bridge/adi,adv7533.yaml       |   2 +-
 Makefile                                           |   4 +-
 arch/arc/Makefile                                  |   2 +-
 arch/x86/kernel/cpu/mshyperv.c                     |  58 ++++++++
 drivers/clocksource/hyperv_timer.c                 |  14 +-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c           |   4 +-
 drivers/gpu/drm/bridge/adv7511/adv7511_audio.c     |  14 +-
 drivers/gpu/drm/bridge/adv7511/adv7533.c           |   2 +-
 drivers/gpu/drm/i915/gt/intel_rc6.c                |   2 +-
 drivers/infiniband/core/uverbs_cmd.c               |  16 ++-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |  28 ++--
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   2 +
 drivers/infiniband/hw/bnxt_re/qplib_sp.c           |   2 +-
 drivers/infiniband/hw/hns/hns_roce_alloc.c         |   3 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c            |  11 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |  12 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c           |  54 +++++---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         | 130 ++++++++---------
 drivers/infiniband/hw/hns/hns_roce_mr.c            |  95 ++++++++-----
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   4 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c           |   4 +-
 drivers/infiniband/hw/mlx5/main.c                  |   6 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |   2 +-
 drivers/irqchip/irq-gic.c                          |   2 +-
 drivers/net/dsa/microchip/ksz9477.c                |  47 +++++--
 drivers/net/dsa/microchip/ksz9477_reg.h            |   4 +-
 drivers/net/dsa/microchip/ksz_common.h             |   5 +
 drivers/net/dsa/microchip/lan937x_main.c           |  62 ++++++++-
 drivers/net/dsa/microchip/lan937x_reg.h            |   9 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |  21 ++-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |  14 +-
 drivers/net/ethernet/marvell/sky2.c                |   1 +
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |   3 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  | 153 +++++++++++++++------
 .../net/ethernet/stmicro/stmmac/stmmac_platform.h  |   2 +
 drivers/net/usb/qmi_wwan.c                         |   3 +
 drivers/net/wwan/iosm/iosm_ipc_mmio.c              |   2 +-
 drivers/net/wwan/t7xx/t7xx_state_monitor.c         |  26 ++--
 drivers/net/wwan/t7xx/t7xx_state_monitor.h         |   5 +-
 drivers/pinctrl/pinctrl-mcp23s08.c                 |   6 +
 drivers/thunderbolt/nhi.c                          |  12 ++
 drivers/thunderbolt/nhi.h                          |   6 +
 drivers/thunderbolt/retimer.c                      |  17 ++-
 drivers/usb/host/xhci-ring.c                       |  42 +++++-
 drivers/usb/host/xhci.c                            |  21 ++-
 drivers/usb/host/xhci.h                            |   2 +
 fs/btrfs/ctree.c                                   |  37 +++--
 fs/btrfs/ctree.h                                   |   7 +
 fs/btrfs/disk-io.c                                 |   9 ++
 fs/btrfs/inode.c                                   |   2 +-
 fs/smb/server/smb2pdu.c                            |  12 +-
 fs/smb/server/vfs.h                                |   1 +
 include/clocksource/hyperv_timer.h                 |   2 +
 include/linux/if_vlan.h                            |  16 ++-
 include/linux/mlx5/driver.h                        |   6 +
 include/net/bluetooth/hci_core.h                   | 108 ++++++++++-----
 include/net/ip_tunnels.h                           |  28 ++--
 include/net/netfilter/nf_tables.h                  |   7 +-
 kernel/bpf/core.c                                  |   6 +-
 kernel/kcov.c                                      |   2 +-
 kernel/trace/trace_events.c                        |  12 ++
 mm/readahead.c                                     |   6 +-
 mm/vmscan.c                                        |   9 +-
 net/bluetooth/hci_core.c                           |  10 +-
 net/bluetooth/iso.c                                |   6 +
 net/bluetooth/l2cap_core.c                         |  12 +-
 net/bluetooth/rfcomm/core.c                        |   6 +
 net/bluetooth/sco.c                                |  12 +-
 net/core/dev.c                                     |   4 +-
 net/core/sock.c                                    |   5 +-
 net/ipv4/ip_tunnel.c                               |  60 +++++---
 net/ipv4/ipip.c                                    |   1 +
 net/ipv4/tcp_input.c                               |   1 +
 net/ipv6/ila/ila_xlat.c                            |  16 ++-
 net/ipv6/sit.c                                     |   2 +-
 net/llc/llc_input.c                                |   2 +-
 net/mac80211/util.c                                |   3 +
 net/mctp/route.c                                   |  36 +++--
 net/mptcp/options.c                                |   7 +
 net/mptcp/protocol.c                               |  22 +--
 net/netrom/nr_route.c                              |   6 +
 net/packet/af_packet.c                             |  28 +---
 net/sctp/associola.c                               |   3 +-
 scripts/mod/file2alias.c                           |   4 +-
 security/selinux/ss/services.c                     |   8 +-
 sound/core/seq/oss/seq_oss_synth.c                 |   2 +
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/usb/format.c                                 |   7 +-
 sound/usb/mixer_us16x08.c                          |   2 +-
 sound/usb/quirks.c                                 |   2 +
 90 files changed, 1031 insertions(+), 444 deletions(-)


