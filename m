Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FDC158DC5;
	Mon,  6 Jan 2025 15:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177030; cv=none; b=KE1ePHb6jAFh7gRRAmkJXP/NGyl4I48K+9pGL7vNYG2ak2ySu1SjUUze1F5CuumJ9ZkmRHPqhrQ0gDboKGuykMEbjahxrFnIzqIM5Hg/xtgZj/Bj8dIzM670X5NzVUxz03c+iav2NwLP9yrpBjsKlyVAIawrWF4y3cQHQD9e3R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177030; c=relaxed/simple;
	bh=lpdCozKerw8YEYAyrl2nB3S1hoUMDdRCWWksEjd9PhI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=soARsomrYtPGuZ+WzowEOLIybCFE0BmTs5XYGHMP8iN9bQF9+htsKBwnWmkudtmOOb3SDVJhaHt9wPFY5PhmFk8K+4f4ibtqaHJUSHw/RENUdfjpv0P8KYADkpSfYlKhL2QQyVd0D/+zeub4ZzYyiXbKjHN8Zhr+27LAOVGx/ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xaafu3HI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xaafu3HI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23026C4CED2;
	Mon,  6 Jan 2025 15:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177030;
	bh=lpdCozKerw8YEYAyrl2nB3S1hoUMDdRCWWksEjd9PhI=;
	h=From:To:Cc:Subject:Date:From;
	b=xaafu3HIi6dcJyJD4Mik+PSje/tHgdQDo27Hpg9EjpuUQI9wyGw+YahL2Mh06MEyQ
	 BedoXVfla/lIMWjq+A3LKbq1Y188LRHCgf7gpaOQXOkPc6f1QgL9bLSl20f7mlKVhH
	 C2PEo5xqI1hQRwJVzMZONh6M5TTky2U/tYgEE1hs=
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
Subject: [PATCH 6.6 000/222] 6.6.70-rc1 review
Date: Mon,  6 Jan 2025 16:13:24 +0100
Message-ID: <20250106151150.585603565@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.70-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.70-rc1
X-KernelTest-Deadline: 2025-01-08T15:11+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.70 release.
There are 222 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.70-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.70-rc1

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Remove redundant checks for automatic debugfs dump

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Fix max SGEs for the Work Request

Paolo Abeni <pabeni@redhat.com>
    mptcp: don't always assume copied data in mptcp_cleanup_rbuf()

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix recvbuffer adjust on sleeping rcvmsg

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix TCP options overflow.

Seiji Nishikawa <snishika@redhat.com>
    mm: vmscan: account for free pages to prevent infinite Loop in throttle_direct_reclaim()

Alessandro Carminati <acarmina@redhat.com>
    mm/kmemleak: fix sleeping function called from invalid context at print message

Yafang Shao <laoar.shao@gmail.com>
    mm/readahead: fix large folio support in async readahead

Joshua Washington <joshwash@google.com>
    gve: guard XDP xmit NDO on existence of xdp queues

Joshua Washington <joshwash@google.com>
    gve: guard XSK operations on the existence of queues

David Hildenbrand <david@redhat.com>
    fs/proc/task_mmu: fix pagemap flags with PMD THP entries on 32bit

Biju Das <biju.das.jz@bp.renesas.com>
    drm: adv7511: Fix use-after-free in adv7533_attach_dsi()

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

Kuan-Wei Chiu <visitorckw@gmail.com>
    scripts/sorttable: fix orc_sort_cmp() to maintain symmetry and transitivity

Arnd Bergmann <arnd@arndb.de>
    kcov: mark in_softirq_really() as __always_inline

Dennis Lam <dennis.lamerice@gmail.com>
    ocfs2: fix slab-use-after-free due to dangling pointer dqi_priv

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Fix races at processing SysEx messages

Daniel Schaefer <dhs@frame.work>
    ALSA hda/realtek: Add quirk for Framework F111:000C

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Check UMP support for midi_version change

Shung-Hsi Yu <shung-hsi.yu@suse.com>
    Revert "bpf: support non-r10 register spill/fill to/from stack in precision tracking"

Masahiro Yamada <masahiroy@kernel.org>
    modpost: fix the missed iteration for the max bit in do_input()

Masahiro Yamada <masahiroy@kernel.org>
    modpost: fix input MODULE_DEVICE_TABLE() built for 64-bit on 32-bit host

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix the max WQE size for static WQE support

Nathan Lynch <nathanl@linux.ibm.com>
    seq_buf: Make DECLARE_SEQ_BUF() usable

Leon Romanovsky <leon@kernel.org>
    ARC: build: Try to guess GCC variant of cross compiler

Uros Bizjak <ubizjak@gmail.com>
    irqchip/gic: Correct declaration of *percpu_base pointer in union gic_base

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix sleeping function called from invalid context

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit FE910C04 compositions

Enzo Matsumiya <ematsumiya@suse.de>
    smb: client: destroy cfid_put_wq on module exit

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: set ATTR_CTIME flags when setting mtime

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

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/ca0132: Use standard HD-audio quirk matching helpers

Filipe Manana <fdmanana@suse.com>
    btrfs: flush delalloc workers queue before stopping cleaner kthread during unmount

Prike Liang <Prike.Liang@amd.com>
    drm/amdkfd: Correct the migration DMA map direction

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: mac80211: wake the queues in case of failure in resume

Issam Hamdi <ih@simonwunderlich.de>
    wifi: mac80211: fix mbss changed flags corruption on 32 bit systems

Meghana Malladi <m-malladi@ti.com>
    net: ti: icssg-prueth: Fix clearing of IEP_CMP_CFG registers during iep_init

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

Liang Jie <liangjie@lixiang.com>
    net: sfc: Correct key_len for efx_tc_ct_zone_ht_params

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

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Skip restore TC rules for vport rep without loaded flag

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: macsec: Maintain TX SA from encoding_sa

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5: DR, select MSIX vector 0 for completion queue creation

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

Wang Liang <wangliang74@huawei.com>
    net: fix memory leak in tcp_conn_request()

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    net: stmmac: restructure the error path of stmmac_probe_config_dt()

Andrew Halaney <ahalaney@redhat.com>
    net: stmmac: don't create a MDIO bus if unnecessary

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

Tristram Ha <tristram.ha@microchip.com>
    net: dsa: microchip: Fix KSZ9477 set_ageing_time function

Stefan Ekenberg <stefan.ekenberg@axis.com>
    drm/bridge: adv7511_audio: Update Audio InfoFrame properly

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix the locking while accessing the QP table

Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
    RDMA/bnxt_re: Fix MSN table size for variable wqe mode

Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
    RDMA/bnxt_re: Add send queue size check for variable wqe

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Disable use of reserved wqes

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Add support for Variable WQE in Genp7 adapters

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix max_qp_wrs reported

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Fix reporting hw_ver in query_device

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    RDMA/bnxt_re: Add check for path mtu in modify_qp

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Fix the check for 9060 condition

Robert Beckett <bob.beckett@collabora.com>
    nvme-pci: 512 byte aligned dma pool segment quirk

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Avoid sending the modify QP workaround for latest adapters

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Avoid initializing the software queue for user queues

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Enforce same type port association for multiport RoCE

Leon Romanovsky <leon@kernel.org>
    RDMA/bnxt_re: Remove always true dattr validity check

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Allow MSN table capability check

Steven Rostedt <rostedt@goodmis.org>
    tracing: Check "%s" dereference via the field and not the TP_printk format

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix trace_check_vprintf() when tp_printk is used

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Handle old buffer mappings for event strings and functions

Kees Cook <keescook@chromium.org>
    seq_buf: Introduce DECLARE_SEQ_BUF and seq_buf_str()

Matthew Wilcox (Oracle) <willy@infradead.org>
    powerpc: Remove initialisation of readpos

Matthew Wilcox (Oracle) <willy@infradead.org>
    tracing: Move readpos from seq_buf to trace_seq

Jeremy Kerr <jk@codeconstruct.com.au>
    net: mctp: handle skb cleanup on sock_queue failures

Max Kellermann <max.kellermann@ionos.com>
    ceph: give up on paths longer than PATH_MAX

Xiubo Li <xiubli@redhat.com>
    ceph: print cluster fsid and client global_id in all debug logs

Xiubo Li <xiubli@redhat.com>
    libceph: add doutc and *_client debug macros support

Steven Rostedt <rostedt@goodmis.org>
    tracing: Have process_string() also allow arrays

Eric Biggers <ebiggers@google.com>
    mmc: sdhci-msm: fix crypto key eviction

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: fix use-after-free in btrfs_encoded_read_endio()

Thiébaud Weksteen <tweek@google.com>
    selinux: ignore unknown extended permissions

Chao Yu <chao@kernel.org>
    f2fs: fix to wait dio completion

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    platform/x86: mlx-platform: call pci_dev_put() to balance the refcount

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Shut up truncated string warning

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Avoid queuing redundant Stop Endpoint commands

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    usb: typec: ucsi: glink: fix off-by-one in connector_status

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Fix a deadlock issue related to automatic dump

Uros Bizjak <ubizjak@gmail.com>
    cleanup: Remove address space of returned pointer

Stefan Berger <stefanb@linux.ibm.com>
    crypto: ecc - Prevent ecc_digits_from_bytes from reading too many bytes

Jan Beulich <jbeulich@suse.com>
    memblock: make memblock_set_node() also warn about use of MAX_NUMNODES

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btusb: mediatek: add callback function in btusb_disconnect

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btusb: add callback function in btusb suspend/resume

Filipe Manana <fdmanana@suse.com>
    btrfs: fix use-after-free when COWing tree bock and tracing is enabled

Filipe Manana <fdmanana@suse.com>
    btrfs: rename and export __btrfs_cow_block()

Xin Li (Intel) <xin@zytor.com>
    x86/fred: Clear WFE in missing-ENDBRANCH #CPs

Xin Li <xin3.li@intel.com>
    x86/ptrace: Add FRED additional information to the pt_regs structure

Xin Li <xin3.li@intel.com>
    x86/ptrace: Cleanup the definition of the pt_regs structure

Qinxin Xia <xiaqinxin@huawei.com>
    ACPI/IORT: Add PMCG platform information for HiSilicon HIP09A

Yicong Yang <yangyicong@hisilicon.com>
    ACPI/IORT: Add PMCG platform information for HiSilicon HIP10/11

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Start controller indexing from 0

Guixin Liu <kanie@linux.alibaba.com>
    scsi: mpi3mr: Use ida to manage mrioc ID

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Update legacy substream names upon FB info update

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Indicate the inactive group in legacy substream names

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Don't open legacy substream for an inactive group

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Use guard() for locking

Jan Kara <jack@suse.cz>
    udf: Verify inode link counts before performing rename

Al Viro <viro@zeniv.linux.org.uk>
    udf_rename(): only access the child content on cross-directory rename

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    watchdog: rzg2l_wdt: Power on the watchdog domain in the restart handler

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    watchdog: rzg2l_wdt: Rely on the reset driver for doing proper reset

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    watchdog: rzg2l_wdt: Remove reset de-assert from probe

Andrea della Porta <andrea.porta@suse.com>
    of: address: Preserve the flags portion on 1:1 dma-ranges mapping

Rob Herring <robh@kernel.org>
    of: address: Store number of bus flag cells rather than bool

Herve Codina <herve.codina@bootlin.com>
    of: address: Remove duplicated functions

Naman Jain <namjain@linux.microsoft.com>
    x86/hyperv: Fix hv tsc page based sched_clock for hibernation

Baoquan He <bhe@redhat.com>
    x86, crash: wrap crash dumping code into crash related ifdefs

Mario Limonciello <mario.limonciello@amd.com>
    thunderbolt: Don't display nvm_version unless upgrade supported

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Add support for Intel Panther Lake-M/P

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Add support for Intel Lunar Lake

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Turn NEC specific quirk for handling Stop Endpoint errors generic

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Limit Stop Endpoint retries

Michal Pecio <michal.pecio@gmail.com>
    xhci: retry Stop Endpoint on buggy NEC controllers

Nikita Yushchenko <nikita.yoush@cogentembedded.com>
    net: renesas: rswitch: fix possible early skb release

K Prateek Nayak <kprateek.nayak@amd.com>
    softirq: Allow raising SCHED_SOFTIRQ from SMP-call-function on RT kernel

Sebastian Ott <sebott@redhat.com>
    net/mlx5: unique names for per device caches

Nilay Shroff <nilay@linux.ibm.com>
    Revert "nvme: make keep-alive synchronous operation"

Nilay Shroff <nilay@linux.ibm.com>
    nvme: use helper nvme_ctrl_state in nvme_keep_alive_finish function

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    usb: typec: ucsi: glink: be more precise on orientation-aware ports

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    usb: typec: ucsi: glink: set orientation aware if supported

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    usb: typec: ucsi: add update_connector callback

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    usb: typec: ucsi: glink: move GPIO reading into connector_status callback

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    usb: typec: ucsi: add callback for connector status updates

Nuno Sa <nuno.sa@analog.com>
    iio: adc: ad7192: properly check spi_get_device_match_data()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7192: Convert from of specific to fwnode property handling

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: udc: limit usb request length to max 16KB

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: add CI_HDRC_HAS_SHORT_PKT_LIMIT flag

Tomer Maimon <tmaimon77@gmail.com>
    usb: chipidea: add CI_HDRC_FORCE_VBUS_ACTIVE_ALWAYS flag

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix warning in ni_fiemap

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Implement fallocate for compressed files

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    remoteproc: qcom: pas: enable SAR2130P audio DSP support

Tengfei Fan <quic_tengfan@quicinc.com>
    remoteproc: qcom: pas: Add support for SA8775p ADSP, CDSP and GPDSP

Nikita Travkin <nikita@trvn.ru>
    remoteproc: qcom: pas: Add sc7180 adsp

Adam Young <admiyo@os.amperecomputing.com>
    mailbox: pcc: Check before sending MCTP PCC response ACK

Sudeep Holla <sudeep.holla@arm.com>
    ACPI: PCC: Add PCC shared memory region command and status bitfields

Huisong Li <lihuisong@huawei.com>
    mailbox: pcc: Support shared interrupt for multiple subspaces

Huisong Li <lihuisong@huawei.com>
    mailbox: pcc: Add support for platform notification handling

Devi Priya <quic_devipriy@quicinc.com>
    clk: qcom: clk-alpha-pll: Add NSS HUAYRA ALPHA PLL support for ipq9574

Rajendra Nayak <quic_rjendra@quicinc.com>
    clk: qcom: clk-alpha-pll: Add support for zonda ole pll configure

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Create all dump files during debugfs initialization

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Allocate DFX memory during dump trigger

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Directly call register snapshot instead of using workqueue

Hao Qin <hao.qin@mediatek.com>
    Bluetooth: btusb: Add new VID/PID 0489/e111 for MT7925

Jiande Lu <jiande.lu@mediatek.com>
    Bluetooth: btusb: Add USB HW IDs for MT7921/MT7922/MT7925

Ulrik Strid <ulrik@strid.tech>
    Bluetooth: btusb: Add new VID/PID 13d3/3602 for MT7925

Jingyang Wang <wjy7717@126.com>
    Bluetooth: Add support ITTIM PE50-M75C

Markus Elfring <elfring@users.sourceforge.net>
    Bluetooth: hci_conn: Reduce hci_conn_drop() calls in two functions

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i2c: i801: Add support for Intel Panther Lake

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i2c: i801: Add support for Intel Arrow Lake-H

Kang Yang <quic_kangyang@quicinc.com>
    wifi: ath10k: avoid NULL pointer error during sdio remove

Jeff Johnson <quic_jjohnson@quicinc.com>
    wifi: ath10k: Update Qualcomm Innovation Center, Inc. copyrights

Kalle Valo <quic_kvalo@quicinc.com>
    wifi: ath12k: fix atomic calls in ath12k_mac_op_set_bitrate_mask()

Rory Little <rory@candelatech.com>
    wifi: mac80211: Add non-atomic station iterator

Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
    wifi: ath12k: Optimize the mac80211 hw data access

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw88: use ieee80211_purge_tx_queue() to purge TX skb

Ping-Ke Shih <pkshih@realtek.com>
    wifi: mac80211: export ieee80211_purge_tx_queue() for drivers

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Force UVC version to 1.0a for 0408:4033

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: uvcvideo: Force UVC version to 1.0a for 0408:4035

Przemek Kitszel <przemyslaw.kitszel@intel.com>
    cleanup: Adjust scoped_guard() macros to avoid potential warning

Peter Zijlstra <peterz@infradead.org>
    cleanup: Add conditional guard support

Lukas Wunner <lukas@wunner.de>
    crypto: ecdsa - Avoid signed integer overflow on signature decoding

Stefan Berger <stefanb@linux.ibm.com>
    crypto: ecdsa - Use ecc_digits_from_bytes to convert signature

Stefan Berger <stefanb@linux.ibm.com>
    crypto: ecdsa - Rename keylen to bufsize where necessary

Stefan Berger <stefanb@linux.ibm.com>
    crypto: ecdsa - Convert byte arrays with key coordinates to digits

Brian Foster <bfoster@redhat.com>
    ext4: partial zero eof block on unaligned inode size extension

Jeff Layton <jlayton@kernel.org>
    ext4: convert to new timestamp accessors

Mike Rapoport (Microsoft) <rppt@kernel.org>
    memblock: allow zero threshold in validate_numa_converage()

Liam Ni <zhiguangni01@gmail.com>
    NUMA: optimize detection of memory with no node id assigned by firmware

Miguel Ojeda <ojeda@kernel.org>
    rust: allow `clippy::needless_lifetimes`

Miguel Ojeda <ojeda@kernel.org>
    rust: relax most deny-level lints to warnings

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/radeon: Delay Connector detecting when HPD singals is unstable"

Shixiong Ou <oushixiong@kylinos.cn>
    drm/radeon: Delay Connector detecting when HPD singals is unstable

Thomas Gleixner <tglx@linutronix.de>
    sched: Initialize idle tasks only once

Selvarasu Ganesan <selvarasu.g@samsung.com>
    usb: dwc3: gadget: Add missing check for single port RAM in TxFIFO resizing logic

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix use-after-free of signing key

Paulo Alcantara <pc@manguebit.com>
    smb: client: stop flooding dmesg in smb2_calc_signature()

Ralph Boehme <slow@samba.org>
    fs/smb/client: implement chmod() for SMB3 POSIX Extensions

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/client: rename cifs_ace to smb_ace

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/client: rename cifs_acl to smb_acl

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/client: rename cifs_sid to smb_sid

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/client: rename cifs_ntsd to smb_ntsd

Borislav Petkov (AMD) <bp@alien8.de>
    x86/mm: Carve out INVLPG inline asm for use by others

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    docs: media: update location of the media patches

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Fix incorrect DSC recompute trigger

Agustin Gutierrez <agustin.gutierrez@amd.com>
    drm/amd/display: Fix DSC-re-computing


-------------

Diffstat:

 Documentation/admin-guide/media/building.rst       |   2 +-
 Documentation/admin-guide/media/saa7134.rst        |   2 +-
 Documentation/arch/arm64/silicon-errata.rst        |   5 +-
 .../bindings/display/bridge/adi,adv7533.yaml       |   2 +-
 Documentation/i2c/busses/i2c-i801.rst              |   2 +
 Makefile                                           |  29 +-
 arch/arc/Makefile                                  |   2 +-
 arch/loongarch/kernel/numa.c                       |  28 +-
 arch/powerpc/kernel/setup-common.c                 |   1 -
 arch/x86/entry/vsyscall/vsyscall_64.c              |   2 +-
 arch/x86/include/asm/ptrace.h                      | 104 ++-
 arch/x86/include/asm/tlb.h                         |   4 +
 arch/x86/kernel/Makefile                           |   4 +-
 arch/x86/kernel/cet.c                              |  30 +
 arch/x86/kernel/cpu/mshyperv.c                     |  68 +-
 arch/x86/kernel/kexec-bzimage64.c                  |   4 +
 arch/x86/kernel/kvm.c                              |   4 +-
 arch/x86/kernel/machine_kexec_64.c                 |   3 +
 arch/x86/kernel/process_64.c                       |   2 +-
 arch/x86/kernel/reboot.c                           |   4 +-
 arch/x86/kernel/setup.c                            |   2 +-
 arch/x86/kernel/smp.c                              |   2 +-
 arch/x86/mm/numa.c                                 |  34 +-
 arch/x86/mm/tlb.c                                  |   3 +-
 arch/x86/xen/enlighten_hvm.c                       |   4 +
 arch/x86/xen/mmu_pv.c                              |   2 +-
 crypto/ecc.c                                       |  22 +
 crypto/ecdsa.c                                     |  51 +-
 drivers/acpi/arm64/iort.c                          |   9 +
 drivers/bluetooth/btusb.c                          |  47 ++
 drivers/clk/qcom/clk-alpha-pll.c                   |  27 +
 drivers/clk/qcom/clk-alpha-pll.h                   |   5 +
 drivers/clocksource/hyperv_timer.c                 |  14 +-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c           |   4 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  16 +-
 drivers/gpu/drm/bridge/adv7511/adv7511_audio.c     |  14 +-
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       |  10 +-
 drivers/gpu/drm/bridge/adv7511/adv7533.c           |   4 +-
 drivers/gpu/drm/i915/gt/intel_rc6.c                |   2 +-
 drivers/i2c/busses/Kconfig                         |   2 +
 drivers/i2c/busses/i2c-i801.c                      |   9 +
 drivers/iio/adc/ad7192.c                           |  39 +-
 drivers/infiniband/core/uverbs_cmd.c               |  16 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |  63 +-
 drivers/infiniband/hw/bnxt_re/main.c               |  21 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |  93 +--
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |  19 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.h          |   6 +
 drivers/infiniband/hw/bnxt_re/qplib_sp.c           |  26 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.h           |   9 +
 drivers/infiniband/hw/bnxt_re/roce_hsi.h           |  30 +-
 drivers/infiniband/hw/hns/hns_roce_alloc.c         |   3 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c            |  11 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |  12 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c           |  54 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         | 130 ++--
 drivers/infiniband/hw/hns/hns_roce_mr.c            |  95 +--
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   4 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c           |   4 +-
 drivers/infiniband/hw/mlx5/main.c                  |   6 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |   2 +-
 drivers/irqchip/irq-gic.c                          |   2 +-
 drivers/mailbox/pcc.c                              | 136 +++-
 drivers/media/usb/uvc/uvc_driver.c                 |  22 +
 drivers/mmc/host/sdhci-msm.c                       |  16 +-
 drivers/net/dsa/microchip/ksz9477.c                |  47 +-
 drivers/net/dsa/microchip/ksz9477_reg.h            |   4 +-
 drivers/net/dsa/microchip/lan937x_main.c           |  62 +-
 drivers/net/dsa/microchip/lan937x_reg.h            |   9 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |  21 +-
 drivers/net/ethernet/google/gve/gve_main.c         |  25 +-
 drivers/net/ethernet/google/gve/gve_tx.c           |   5 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |  14 +-
 drivers/net/ethernet/marvell/sky2.c                |   1 +
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |   4 +
 .../net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   3 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   3 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   7 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   4 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |   3 +-
 drivers/net/ethernet/renesas/rswitch.c             |   5 +-
 drivers/net/ethernet/sfc/tc_conntrack.c            |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  | 120 ++--
 drivers/net/ethernet/ti/icssg/icss_iep.c           |   8 +
 drivers/net/usb/qmi_wwan.c                         |   3 +
 drivers/net/wireless/ath/ath10k/bmi.c              |   1 +
 drivers/net/wireless/ath/ath10k/ce.c               |   1 +
 drivers/net/wireless/ath/ath10k/core.c             |   1 +
 drivers/net/wireless/ath/ath10k/core.h             |   1 +
 drivers/net/wireless/ath/ath10k/coredump.c         |   1 +
 drivers/net/wireless/ath/ath10k/coredump.h         |   1 +
 drivers/net/wireless/ath/ath10k/debug.c            |   1 +
 drivers/net/wireless/ath/ath10k/debugfs_sta.c      |   1 +
 drivers/net/wireless/ath/ath10k/htc.c              |   1 +
 drivers/net/wireless/ath/ath10k/htt.h              |   1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   1 +
 drivers/net/wireless/ath/ath10k/htt_tx.c           |   1 +
 drivers/net/wireless/ath/ath10k/hw.c               |   1 +
 drivers/net/wireless/ath/ath10k/hw.h               |   1 +
 drivers/net/wireless/ath/ath10k/mac.c              |   1 +
 drivers/net/wireless/ath/ath10k/pci.c              |   1 +
 drivers/net/wireless/ath/ath10k/pci.h              |   1 +
 drivers/net/wireless/ath/ath10k/qmi.c              |   1 +
 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c     |   1 +
 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h     |   1 +
 drivers/net/wireless/ath/ath10k/rx_desc.h          |   1 +
 drivers/net/wireless/ath/ath10k/sdio.c             |   5 +-
 drivers/net/wireless/ath/ath10k/thermal.c          |   1 +
 drivers/net/wireless/ath/ath10k/usb.h              |   1 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.h          |   1 +
 drivers/net/wireless/ath/ath10k/wmi.c              |   1 +
 drivers/net/wireless/ath/ath10k/wmi.h              |   1 +
 drivers/net/wireless/ath/ath10k/wow.c              |   1 +
 drivers/net/wireless/ath/ath12k/mac.c              |  26 +-
 drivers/net/wireless/ath/ath12k/reg.c              |   6 +-
 drivers/net/wireless/realtek/rtw88/sdio.c          |   6 +-
 drivers/net/wireless/realtek/rtw88/usb.c           |   5 +-
 drivers/net/wwan/iosm/iosm_ipc_mmio.c              |   2 +-
 drivers/net/wwan/t7xx/t7xx_state_monitor.c         |  26 +-
 drivers/net/wwan/t7xx/t7xx_state_monitor.h         |   5 +-
 drivers/nvme/host/core.c                           |  27 +-
 drivers/nvme/host/nvme.h                           |   5 +
 drivers/nvme/host/pci.c                            |   9 +-
 drivers/of/address.c                               |  30 +-
 drivers/pinctrl/pinctrl-mcp23s08.c                 |   6 +
 drivers/platform/x86/mlx-platform.c                |   2 +
 drivers/remoteproc/qcom_q6v5_pas.c                 |  94 +++
 drivers/scsi/hisi_sas/hisi_sas.h                   |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |  17 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             | 200 +++---
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |  12 +-
 drivers/thunderbolt/nhi.c                          |  12 +
 drivers/thunderbolt/nhi.h                          |   6 +
 drivers/thunderbolt/retimer.c                      |  17 +-
 drivers/usb/chipidea/ci.h                          |   2 +
 drivers/usb/chipidea/ci_hdrc_imx.c                 |   1 +
 drivers/usb/chipidea/core.c                        |   2 +
 drivers/usb/chipidea/otg.c                         |   5 +-
 drivers/usb/chipidea/udc.c                         |   6 +
 drivers/usb/dwc3/core.h                            |   4 +
 drivers/usb/dwc3/gadget.c                          |  54 +-
 drivers/usb/host/xhci-ring.c                       |  42 +-
 drivers/usb/host/xhci.c                            |  21 +-
 drivers/usb/host/xhci.h                            |   2 +
 drivers/usb/typec/ucsi/ucsi.c                      |   9 +
 drivers/usb/typec/ucsi/ucsi.h                      |   5 +
 drivers/usb/typec/ucsi/ucsi_glink.c                |  60 +-
 drivers/watchdog/rzg2l_wdt.c                       |  83 ++-
 fs/btrfs/ctree.c                                   |  37 +-
 fs/btrfs/ctree.h                                   |   7 +
 fs/btrfs/disk-io.c                                 |   9 +
 fs/btrfs/inode.c                                   |   2 +-
 fs/ceph/acl.c                                      |   6 +-
 fs/ceph/addr.c                                     | 279 ++++----
 fs/ceph/caps.c                                     | 708 ++++++++++++---------
 fs/ceph/crypto.c                                   |  39 +-
 fs/ceph/debugfs.c                                  |   6 +-
 fs/ceph/dir.c                                      | 218 ++++---
 fs/ceph/export.c                                   |  39 +-
 fs/ceph/file.c                                     | 245 ++++---
 fs/ceph/inode.c                                    | 485 +++++++-------
 fs/ceph/ioctl.c                                    |  13 +-
 fs/ceph/locks.c                                    |  57 +-
 fs/ceph/mds_client.c                               | 563 +++++++++-------
 fs/ceph/mdsmap.c                                   |  24 +-
 fs/ceph/metric.c                                   |   5 +-
 fs/ceph/quota.c                                    |  29 +-
 fs/ceph/snap.c                                     | 174 ++---
 fs/ceph/super.c                                    |  70 +-
 fs/ceph/super.h                                    |   6 +
 fs/ceph/xattr.c                                    |  96 +--
 fs/ext4/ext4.h                                     |  20 +-
 fs/ext4/extents.c                                  |  18 +-
 fs/ext4/ialloc.c                                   |   4 +-
 fs/ext4/inline.c                                   |   4 +-
 fs/ext4/inode.c                                    |  72 ++-
 fs/ext4/ioctl.c                                    |  13 +-
 fs/ext4/namei.c                                    |  10 +-
 fs/ext4/super.c                                    |   2 +-
 fs/ext4/xattr.c                                    |   8 +-
 fs/f2fs/file.c                                     |  13 +
 fs/ntfs3/attrib.c                                  |  32 +-
 fs/ntfs3/frecord.c                                 | 103 +--
 fs/ntfs3/inode.c                                   |   3 +-
 fs/ntfs3/ntfs_fs.h                                 |   3 +-
 fs/ocfs2/quota_global.c                            |   2 +-
 fs/ocfs2/quota_local.c                             |   1 +
 fs/proc/task_mmu.c                                 |   2 +-
 fs/smb/client/cifsacl.c                            | 266 ++++----
 fs/smb/client/cifsacl.h                            |  20 +-
 fs/smb/client/cifsfs.c                             |   1 +
 fs/smb/client/cifsglob.h                           |  22 +-
 fs/smb/client/cifsproto.h                          |  26 +-
 fs/smb/client/cifssmb.c                            |   6 +-
 fs/smb/client/inode.c                              |   4 +-
 fs/smb/client/smb2inode.c                          |   4 +-
 fs/smb/client/smb2ops.c                            |  14 +-
 fs/smb/client/smb2pdu.c                            |  12 +-
 fs/smb/client/smb2pdu.h                            |   8 +-
 fs/smb/client/smb2proto.h                          |   4 +-
 fs/smb/client/smb2transport.c                      |  56 +-
 fs/smb/client/xattr.c                              |   4 +-
 fs/smb/server/smb2pdu.c                            |  22 +-
 fs/smb/server/vfs.h                                |   1 +
 fs/udf/namei.c                                     |  17 +-
 include/acpi/pcc.h                                 |  20 +
 include/clocksource/hyperv_timer.h                 |   2 +
 include/crypto/internal/ecc.h                      |  10 +
 include/linux/bpf_verifier.h                       |  31 +-
 include/linux/ceph/ceph_debug.h                    |  38 ++
 include/linux/cleanup.h                            |  88 ++-
 include/linux/if_vlan.h                            |  16 +-
 include/linux/memblock.h                           |   1 +
 include/linux/mlx5/driver.h                        |   6 +
 include/linux/mutex.h                              |   3 +-
 include/linux/rwsem.h                              |   8 +-
 include/linux/seq_buf.h                            |  25 +-
 include/linux/spinlock.h                           |  15 +
 include/linux/trace_events.h                       |   6 +-
 include/linux/trace_seq.h                          |   2 +
 include/linux/usb/chipidea.h                       |   2 +
 include/net/bluetooth/hci_core.h                   | 108 ++--
 include/net/mac80211.h                             |  31 +
 include/net/netfilter/nf_tables.h                  |   7 +-
 kernel/bpf/core.c                                  |   6 +-
 kernel/bpf/verifier.c                              | 175 +++--
 kernel/kcov.c                                      |   2 +-
 kernel/sched/core.c                                |  12 +-
 kernel/softirq.c                                   |  15 +-
 kernel/trace/trace.c                               | 231 ++-----
 kernel/trace/trace.h                               |   6 +-
 kernel/trace/trace_events.c                        |  44 +-
 kernel/trace/trace_output.c                        |   6 +-
 kernel/trace/trace_seq.c                           |   6 +-
 lib/seq_buf.c                                      |  26 +-
 mm/kmemleak.c                                      |   2 +-
 mm/memblock.c                                      |  38 ++
 mm/readahead.c                                     |   6 +-
 mm/vmscan.c                                        |   9 +-
 net/bluetooth/hci_conn.c                           |  13 +-
 net/bluetooth/hci_core.c                           |  10 +-
 net/bluetooth/iso.c                                |   6 +
 net/bluetooth/l2cap_core.c                         |  12 +-
 net/bluetooth/rfcomm/core.c                        |   6 +
 net/bluetooth/sco.c                                |  12 +-
 net/core/dev.c                                     |   4 +-
 net/core/sock.c                                    |   5 +-
 net/ipv4/ip_tunnel.c                               |  38 +-
 net/ipv4/tcp_input.c                               |   1 +
 net/ipv6/ila/ila_xlat.c                            |  16 +-
 net/llc/llc_input.c                                |   2 +-
 net/mac80211/ieee80211_i.h                         |   2 -
 net/mac80211/mesh.c                                |   6 +-
 net/mac80211/status.c                              |   1 +
 net/mac80211/util.c                                |  19 +-
 net/mctp/route.c                                   |  36 +-
 net/mptcp/options.c                                |   7 +
 net/mptcp/protocol.c                               |  22 +-
 net/netrom/nr_route.c                              |   6 +
 net/packet/af_packet.c                             |  28 +-
 net/sctp/associola.c                               |   3 +-
 rust/Makefile                                      |   4 +-
 scripts/mod/file2alias.c                           |   4 +-
 scripts/sorttable.h                                |   5 +-
 security/selinux/ss/services.c                     |   8 +-
 sound/core/seq/oss/seq_oss_synth.c                 |   2 +
 sound/core/seq/seq_clientmgr.c                     |  14 +-
 sound/core/ump.c                                   |  61 +-
 sound/pci/hda/patch_ca0132.c                       |  37 +-
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/usb/format.c                                 |   7 +-
 sound/usb/mixer_us16x08.c                          |   2 +-
 sound/usb/quirks.c                                 |   2 +
 .../bpf/progs/verifier_subprog_precision.c         |  23 +-
 tools/testing/selftests/bpf/verifier/precise.c     |  38 +-
 276 files changed, 4885 insertions(+), 3100 deletions(-)


