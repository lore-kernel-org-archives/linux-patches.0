Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3533B2FD9;
	Mon, 23 Mar 2026 14:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275118; cv=none; b=WM5v/odLS6eoyqSaotXBEzeJE3a+UOSlfK0612mFdQ8rvnYlhSvmoPNWpWbr7FGZdcGp7zMzhfyZfqaOJ+8TfDEc4yYvmXo3uqw2gSrXY7Wr1MkEkNva0DlGvIy15KcGxnyTU4aIlbt4RAWJToY9Oq56jx4Vw4H3TUg5XguQA+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275118; c=relaxed/simple;
	bh=VDuElaQXEkj5fqKI+qiLZA1aiLveJX6Yo3eKT0ncvug=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=awNMUmmmY9gRJqSJN+7TRqvYSNOoSi+GOjOJLXnPia7sv3LgPipGfkCWXd0e1fziwU+22n/rNTK+rRWyhDWDlrqPAG4CMtqep8lfaZ5XYFLYif5d3aFR0J7cS2lPe+Z/CEwWVoFOg6r+VWIS8GglUQHi3GkDuvSC4jPZEVQL3Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NB+VN7WR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NB+VN7WR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838AEC2BCB3;
	Mon, 23 Mar 2026 14:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275118;
	bh=VDuElaQXEkj5fqKI+qiLZA1aiLveJX6Yo3eKT0ncvug=;
	h=From:To:Cc:Subject:Date:From;
	b=NB+VN7WRkbHYQHCMEcwvG8Xdt10pCxTMUGfvnzc27H3BCaK2WwkCG+IlX96rYeNSB
	 Z5ne3DGAXSHOdSpVdb8vMR3THSTXArtP+jHKYMeZElRY062nW4hhJtKNOQKN0cFO6v
	 lWusCq4y9uaGupvu6oQ2anP0mHyiGzOsJkMO1ktI=
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
Subject: [PATCH 6.1 000/481] 6.1.167-rc1 review
Date: Mon, 23 Mar 2026 14:39:42 +0100
Message-ID: <20260323134525.256603107@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.167-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.167-rc1
X-KernelTest-Deadline: 2026-03-25T13:45+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.167 release.
There are 481 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.167-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.167-rc1

Nathan Gao <zcgao@amazon.com>
    Revert "selftests: net: amt: wait longer for connection before sending packets"

Jaskaran Singh <jsingh@cloudlinux.com>
    nvme: nvme-fc: Ensure ->ioerr_work is cancelled in nvme_fc_delete_ctrl()

Jaskaran Singh <jsingh@cloudlinux.com>
    Revert "nvme: nvme-fc: Ensure ->ioerr_work is cancelled in nvme_fc_delete_ctrl()"

Johan Hovold <johan@kernel.org>
    i2c: cp2615: fix serial string NULL-deref at probe

Justin Stitt <justinstitt@google.com>
    i2c: cp2615: replace deprecated strncpy with strscpy

Chunyan Zhang <zhangchunyan@iscas.ac.cn>
    riscv: stacktrace: Disable KASAN checks for non-current tasks

Duoming Zhou <duoming@zju.edu.cn>
    wifi: brcmfmac: fix use-after-free when rescheduling brcmf_btcoex_info work

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_pipapo: prevent overflow in lookup table allocation

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: missing objects with no memcg accounting

Alexander Aring <aahringo@redhat.com>
    dlm: fix possible lkb_resource null dereference

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: in-kernel: always set ID as avail when rm endp

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: stmmac: fix TSO DMA API usage causing oops

Chao Yu <chao@kernel.org>
    f2fs: fix to trigger foreground gc during f2fs_map_blocks() in lfs mode

Keith Busch <kbusch@kernel.org>
    nvme: fix admin request_queue lifetime

Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
    ntfs: set dummy blocksize to read boot_block when mounting

Zqiang <qiang.zhang1211@gmail.com>
    rcu/nocb: Fix possible invalid rdp's->nocb_cb_kthread pointer access

Jibin Zhang <jibin.zhang@mediatek.com>
    net: fix segmentation of forwarding fraglist GRO

Felix Fietkau <nbd@nbd.name>
    net: gso: fix tcp fraglist segmentation after pull from frag_list

Felix Fietkau <nbd@nbd.name>
    net: add support for segmenting TCP fraglist GSO packets

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Use pm_display_cfg in legacy DPM (v2)

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Add pixel_clock to amd_pp_display_configuration

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: clarify DC checks

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: use proper DC check in amdgpu_display_supported_domains()

Jakub Kicinski <kuba@kernel.org>
    net: clear the dst when changing skb protocol

Heiko Carstens <hca@linux.ibm.com>
    s390/xor: Fix xor_xc_2() inline assembly constraints

Guodong Xu <guodong@riscstar.com>
    dmaengine: mmp_pdma: Fix race condition in mmp_pdma_residue()

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: split gc into unlink and reclaim phase

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: de-constify set commit ops function argument

Josh Law <objecting@objecting.org>
    tools/bootconfig: fix fd leak in load_xbc_file() on fstat failure

Josh Law <objecting@objecting.org>
    lib/bootconfig: check xbc_init_node() return in override path

Rahul Bukte <rahul.bukte@sony.com>
    drm/i915/gt: Check set_default_submission() before deferencing

Hyunwoo Kim <imv4bel@gmail.com>
    ksmbd: fix use-after-free of share_conf in compound request

Kamal Dasu <kamal.dasu@broadcom.com>
    mtd: rawnand: brcmnand: skip DMA during panic write

Kamal Dasu <kamal.dasu@broadcom.com>
    mtd: rawnand: serialize lock/unlock against other NAND operations

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: fsi: Fix a potential leak in fsi_i2c_probe()

Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
    USB: serial: f81232: fix incomplete serial port generation

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Fix pelt clock sync when entering idle

Joonwon Kang <joonwonkang@google.com>
    mailbox: Prevent out-of-bounds access in of_mbox_index_xlate()

Kuniyuki Iwashima <kuniyu@google.com>
    Bluetooth: hci_core: Fix use-after-free in vhci_flush()

Maarten Lankhorst <dev@lankhorst.se>
    drm: Fix use-after-free on framebuffers and property blobs when calling drm_dev_unplug

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix accepting multiple L2CAP_ECRED_CONN_REQ

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pmbus/isl68137) Fix unchecked return value and use sysfs_emit()

Weiming Shi <bestswngs@gmail.com>
    icmp: fix NULL pointer dereference in icmp_tag_validation()

Anas Iqbal <mohd.abd.6602@gmail.com>
    net: dsa: bcm_sf2: fix missing clk_disable_unprepare() in error paths

Muhammad Hammad Ijaz <mhijaz@amazon.com>
    net: mvpp2: guard flow control update with global_tx_fc in buffer switching

Weiming Shi <bestswngs@gmail.com>
    nfnetlink_osf: validate individual option lengths in fingerprints

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: release flowtable after rcu grace period on error

Xiang Mei <xmei5@asu.edu>
    net: bonding: fix NULL deref in bond_debug_rlb_hash_show

Xiang Mei <xmei5@asu.edu>
    udp_tunnel: fix NULL deref caused by udp_sock_create6 when CONFIG_IPV6=n

Fedor Pchelkin <pchelkin@ispras.ru>
    net: macb: fix uninitialized rx_fs_lock

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: processor: Fix previous acpi_processor_errata_piix4() fix

Guenter Roeck <linux@roeck-us.net>
    wifi: wlcore: Return -ENOMEM instead of -EAGAIN if there is not enough headroom

Xiang Mei <xmei5@asu.edu>
    wifi: mac80211: fix NULL deref in mesh_matches_local()

Petr Oros <poros@redhat.com>
    iavf: fix VLAN filter lost on add/delete race

Kohei Enju <kohei@enjuk.jp>
    igc: fix missing update of skb->tail in igc_xmit_frame()

Nikola Z. Ivanov <zlatistiv@gmail.com>
    net: usb: aqc111: Do not perform PM inside suspend callback

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: teql: Fix double-free in teql_master_xmit

Jiayuan Chen <jiayuan.chen@shopee.com>
    net/smc: fix NULL dereference and UAF in smc_tcp_syn_recv_sock()

Bart Van Assche <bvanassche@acm.org>
    PM: runtime: Fix a race condition related to device removal

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    sched: idle: Consolidate the handling of two special cases

Dipayaan Roy <dipayanroy@linux.microsoft.com>
    net: mana: fix use-after-free in mana_hwc_destroy_channel() by reordering teardown

Justin Chen <justin.chen@broadcom.com>
    net: bcmgenet: increase WoL poll timeout

Jenny Guanni Qu <qguanni@gmail.com>
    netfilter: nf_conntrack_h323: check for zero length in DecodeQ931()

Jenny Guanni Qu <qguanni@gmail.com>
    netfilter: xt_time: use unsigned int for monthday bit shift

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: xt_CT: drop pending enqueued packets on template removal

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_ct: drop pending enqueued packets on removal

Andrii Melnychenko <a.melnychenko@vyos.io>
    netfilter: nft_ct: add seqadj extension for natted connections

Jenny Guanni Qu <qguanni@gmail.com>
    netfilter: nf_conntrack_h323: fix OOB read in decode_int() CONS case

Lukas Johannes Möller <research@johannes-moeller.dev>
    netfilter: nf_conntrack_sip: fix Content-Length u32 truncation in sip_help_tcp()

Hyunwoo Kim <imv4bel@gmail.com>
    netfilter: ctnetlink: fix use-after-free in ctnetlink_dump_exp_ct()

Florian Westphal <fw@strlen.de>
    netfilter: ctnetlink: remove refcounting in expectation dumpers

Jiayuan Chen <jiayuan.chen@shopee.com>
    net/rose: fix NULL pointer dereference in rose_transmit_link on reconnect

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    Bluetooth: qca: fix ROM version reading on WCN3998 chips

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: HIDP: Fix possible UAF

Michael Grzeschik <m.grzeschik@pengutronix.de>
    Bluetooth: hci_sync: Fix hci_le_create_conn_sync

Christian Eggers <ceggers@arri.de>
    Bluetooth: SMP: make SM/PER/KDU/BI-04-C happy

Christian Eggers <ceggers@arri.de>
    Bluetooth: LE L2CAP: Disconnect if sum of payload sizes exceed SDU

Christian Eggers <ceggers@arri.de>
    Bluetooth: LE L2CAP: Disconnect if received packet's SDU exceeds IMTU

Felix Gu <ustc.gu@gmail.com>
    firmware: arm_scpi: Fix device_node reference leak in probe path

Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>
    wifi: cfg80211: cancel pmsr_free_wk in cfg80211_pmsr_wdev_down

Kuniyuki Iwashima <kuniyu@google.com>
    wifi: mac80211: Fix static_branch_dec() underflow for aql_disable.

Richard Genoud <richard.genoud@bootlin.com>
    soc: fsl: qbman: fix race condition in qman_destroy_fq

ZhengYuan Huang <gality369@gmail.com>
    btrfs: tree-checker: fix misleading root drop_level error message

Zilin Guan <zilin@seu.edu.cn>
    binfmt_misc: restore write access before closing files opened by open_exec()

Håkon Bugge <haakon.bugge@oracle.com>
    PCI/ACPI: Restrict program_hpx_type2() to AER bits

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: stmmac: remove support for lpi_intr_o

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: drop redundant sched job cleanup when cs is aborted

Khairul Anuar Romli <khairul.anuar.romli@altera.com>
    spi: cadence-quadspi: Implement refcount to handle unbind during busy

Jakub Kicinski <kuba@kernel.org>
    eth: bnxt: always recalculate features after XDP clearing, fix null-deref

Qu Wenruo <wqu@suse.com>
    btrfs: do not strictly require dirty metadata threshold for metadata writepages

Qu Wenruo <wqu@suse.com>
    btrfs: send: check for inline extents in range_is_hole_in_parent()

Oleg Nesterov <oleg@redhat.com>
    x86/uprobes: Fix XOL allocation failure for 32-bit tasks

Jeongjun Park <aha310510@gmail.com>
    drm/exynos: vidi: use ctx->lock to protect struct vidi_context member variables related to memory alloc/free

Jeongjun Park <aha310510@gmail.com>
    drm/exynos: vidi: fix to avoid directly dereferencing user pointer

Jeongjun Park <aha310510@gmail.com>
    drm/exynos: vidi: use priv->vidi_dev for ctx lookup in vidi_connection_ioctl()

Ankit Garg <nktgrg@google.com>
    gve: defer interrupt enabling until NAPI registration

Frederic Weisbecker <frederic@kernel.org>
    net: Handle napi_schedule() calls from non-interrupt

Huacai Chen <chenhuacai@kernel.org>
    net: stmmac: dwmac-loongson: Set clk_csr_i to 100-150MHz

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Fix handling of lrbp->cmd

Eric Dumazet <edumazet@google.com>
    net/sched: cls_u32: use skb_header_pointer_careful()

Eric Dumazet <edumazet@google.com>
    net: add skb_header_pointer_careful() helper

Mikulas Patocka <mpatocka@redhat.com>
    dm-verity: disable recursive forward error correction

Wei Fang <wei.fang@nxp.com>
    net: enetc: allocate vf_state during PF probes

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: reimplement RFS/RSS memory clearing as PCI quirk

Daniel Golle <daniel@makrotopia.org>
    mtd: spinand: macronix: use scratch buffer for DMA operation

Eric Biggers <ebiggers@kernel.org>
    net/tcp-md5: Fix MAC comparison to be constant-time

Eric Biggers <ebiggers@kernel.org>
    ksmbd: Compare MACs in constant time

Eric Biggers <ebiggers@kernel.org>
    smb: client: Compare MACs in constant time

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: No more self recovery

Kevin Groeneveld <kgroeneveld@lenbrook.com>
    net: fec: handle page_pool_dev_alloc_pages error

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: improve shutdown sequence

Lang Yu <Lang.Yu@amd.com>
    drm/amdgpu: unmap and remove csa_va properly

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Kill timer properly at removal

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: fix odr switch when turning buffer off

Jakub Staniszewski <jakub.staniszewski@linux.intel.com>
    ice: reintroduce retry mechanism for indirect AQ

Michal Schmidt <mschmidt@redhat.com>
    ice: sleep, don't busy-wait, in the SQ send retry loop

Michal Schmidt <mschmidt@redhat.com>
    ice: remove unused buffer copy code in ice_sq_send_cmd_retry()

Maíra Canal <mcanal@igalia.com>
    pmdomain: bcm: bcm2835-power: Increase ASB control timeout

Kevin Hao <haokexin@gmail.com>
    net: macb: Reinitialize tx/rx queue pointer registers and rx ring during resume

Kevin Hao <haokexin@gmail.com>
    net: macb: Introduce gem_init_rx_ring()

Vineeth Karumanchi <vineeth.karumanchi@amd.com>
    net: macb: queue tie-off or disable during WOL suspend

Jeff Layton <jlayton@kernel.org>
    nfsd: fix heap overflow in NFSv4.0 LOCK replay cache

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Hold net reference for the lifetime of /proc/fs/nfs/exports fd

Tom Rix <trix@redhat.com>
    nfsd: define exports_proc_ops with CONFIG_PROC_FS

Yang Yang <n05ec@lzu.edu.cn>
    batman-adv: avoid OGM aggregation when skb tailroom is insufficient

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: light: bh1780: fix PM runtime leak on error path

Filipe Manana <fdmanana@suse.com>
    btrfs: fix transaction abort on set received ioctl due to item overflow

Filipe Manana <fdmanana@suse.com>
    btrfs: fix transaction abort when snapshotting received subvolumes

Nuno Sá <nuno.sa@analog.com>
    iio: buffer: Fix wait_queue not being removed

Nuno Sá <nuno.sa@analog.com>
    iio: buffer: fix coding style warnings

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    kprobes: Remove unneeded warnings from __arm_kprobe_ftrace()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    kprobes: Remove unneeded goto

Shyam Prasad N <sprasad@microsoft.com>
    cifs: open files should not hold ref on superblock

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-sha204a - Fix OOM ->tfm_count leak

Long Li <leo.lilong@huawei.com>
    xfs: ensure dquot item is deleted from AIL only after log shutdown

Long Li <leo.lilong@huawei.com>
    xfs: fix integer overflow in bmap intent sort comparator

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Enable AUTOSEL_DOM for CCA serialnr sysfs attribute

Kevin Hao <haokexin@gmail.com>
    net: macb: Shuffle the tx ring before enabling tx

Luca Ceresoli <luca.ceresoli@bootlin.com>
    drm/bridge: ti-sn65dsi83: halve horizontal syncs for dual LVDS output

Thomas Fourier <fourier.thomas@gmail.com>
    drm/msm: Fix dma_free_attrs() buffer size

Thorsten Blum <thorsten.blum@linux.dev>
    ksmbd: Don't log keys in SMB3 signing and encryption key generation

Catalin Marinas <catalin.marinas@arm.com>
    arm64: mm: Add PTE_DIRTY back to PAGE_KERNEL* to fix kexec/hibernation

Joey Gouly <joey.gouly@arm.com>
    arm64: reorganise PAGE_/PROT_ macros

Maíra Canal <mcanal@igalia.com>
    pmdomain: bcm: bcm2835-power: Fix broken reset status read

Huiwen He <hehuiwen@kylinos.cn>
    tracing: Fix syscall events activation by ensuring refcount hits zero

Darrick J. Wong <djwong@kernel.org>
    iomap: reject delalloc mappings during writeback

Alexander Potapenko <glider@google.com>
    mm/kfence: disable KFENCE upon KASAN HW tags enablement

Alexander Potapenko <glider@google.com>
    mm/kfence: fix KASAN hardware tag faults during late enablement

Ravi Hothi <ravi.hothi@oss.qualcomm.com>
    ASoC: qcom: qdsp6: Fix q6apm remove ordering during ADSP stop and start

Xu Yang <xu.yang_2@nxp.com>
    usb: roles: get usb role switch from parent only for usb-b-connector

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    usb: gadget: f_tcm: Fix NULL pointer dereferences in nexus handling

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Set/clear CR8 write interception when AVIC is (de)activated

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_can_open(): always configure bitrates before starting device

Mehul Rao <mehulrao@gmail.com>
    ALSA: pcm: fix use-after-free on linked stream runtime in snd_pcm_drain()

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: pcm: fix wait_time calculations

Paul Moses <p@1g4.org>
    net/sched: act_gate: snapshot parameters with RCU on replace

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: check RM_ADDR not sent over same subflow

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: in-kernel: always mark signal+subflow endp as used

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: avoid sending RM_ADDR over same subflow

Natalie Vock <natalie.vock@gmx.de>
    drm/amd/display: Use GFP_ATOMIC in dc_create_stream_for_sink

Andrew Lunn <andrew@lunn.ch>
    net: phy: register phy led_triggers during probe to avoid AB-BA deadlock

Kim Phillips <kim.phillips@amd.com>
    x86/sev: Allow IBPB-on-Entry feature for SNP guests

Daniil Dulov <d.dulov@aladdin.ru>
    wifi: cfg80211: cancel rfkill_block work in wiphy_unregister()

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: move scan done work to wiphy work

Daniel Hodges <git@danielhodges.dev>
    wifi: libertas: fix use-after-free in lbs_free_adapter()

Jan Kara <jack@suse.cz>
    ext4: always allocate blocks only from groups inode can use

Brian Foster <bfoster@redhat.com>
    ext4: fix dirtyclusters double decrement on fs shutdown

Fedor Pchelkin <pchelkin@ispras.ru>
    ksmbd: call ksmbd_vfs_kern_path_end_removing() on some error paths

David Hildenbrand (Red Hat) <david@kernel.org>
    mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather

David Hildenbrand (Red Hat) <david@kernel.org>
    mm/hugetlb: fix two comments related to huge_pmd_unshare()

David Hildenbrand (Red Hat) <david@kernel.org>
    mm/hugetlb: fix hugetlb_pmd_shared()

Jane Chu <jane.chu@oracle.com>
    mm/hugetlb: fix copy_hugetlb_page_range() to use ->pt_share_count

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: apply state adjust rules to some additional HAINAN vairants

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: apply state adjust rules to some additional HAINAN vairants

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/mmhub3.0: add bounds checking for cid

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/mmhub3.0.2: add bounds checking for cid

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/mmhub3.0.1: add bounds checking for cid

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/mmhub2.3: add bounds checking for cid

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/mmhub2.0: add bounds checking for cid

Maciej Andrzejewski ICEYE <maciej.andrzejewski@m-works.net>
    serial: uartlite: fix PM runtime usage count underflow on probe

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Add late synchronize_irq() to shutdown to handle DW UART BUSY

Raul E Rangel <rrangel@chromium.org>
    serial: 8250: Fix TX deadlock when using DMA

Martin Roukala (né Peres) <martin.roukala@mupuf.org>
    serial: 8250_pci: add support for the AX99100

Guanghui Feng <guanghuifeng@linux.alibaba.com>
    iommu/vt-d: Fix intel iommu iotlb sync hardlockup and retry

Finn Thain <fthain@linux-m68k.org>
    mtd: Avoid boot crash in RedBoot partition table parser

Chen Ni <nichen@iscas.ac.cn>
    mtd: rawnand: cadence: Fix error check for dma_alloc_coherent() in cadence_nand_init()

Olivier Sobrie <olivier@sobrie.be>
    mtd: rawnand: pl353: make sure optimal timings are applied

Johan Hovold <johan@kernel.org>
    spi: fix statistics allocation

Johan Hovold <johan@kernel.org>
    spi: fix use-after-free on controller registration failure

Luke Wang <ziniu.wang_1@nxp.com>
    mmc: sdhci: fix timing selection for 1-bit bus width

Matthew Schwartz <matthew.schwartz@linux.dev>
    mmc: sdhci-pci-gli: fix GL9750 DMA write corruption

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: unset conn->binding on failed binding request

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix krb5 mount with username option

Lukas Johannes Möller <research@johannes-moeller.dev>
    Bluetooth: L2CAP: Validate L2CAP_INFO_RSP payload length before access

Lukas Johannes Möller <research@johannes-moeller.dev>
    Bluetooth: L2CAP: Fix type confusion in l2cap_ecred_reconf_rsp()

Fedor Pchelkin <pchelkin@ispras.ru>
    net: macb: fix use-after-free access to PTP clock

Ian Ray <ian.ray@gehealthcare.com>
    NFC: nxp-nci: allow GPIOs to sleep

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Give more information if kmem access failed

Ira Weiny <ira.weiny@intel.com>
    nvdimm/bus: Fix potential use after free in asynchronous initialization

Jeff Layton <jlayton@kernel.org>
    sunrpc: fix cache_request leak in cache_release

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: check if target buffer list is still legacy on recycle

Jens Axboe <axboe@kernel.dk>
    io_uring/io-wq: check IO_WQ_BIT_EXIT inside work run loop

Eric Dumazet <edumazet@google.com>
    l2tp: do not use sock_hold() in pppol2tp_session_get_sock()

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Forget ranges when refining tnum after JSET

Eric Dumazet <edumazet@google.com>
    ipv6: use RCU in ip6_xmit()

John Ripple <john.ripple@keysight.com>
    drm/bridge: ti-sn65dsi86: Add support for DisplayPort mode with HPD

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Add missing TID field to no-op command descriptor

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Restart DMA ring correctly after dequeue abort

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Use ETIMEDOUT instead of ETIME for timeout errors

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: fix odr switch to the same value

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: gyro: mpu3050-i2c: fix pm_runtime error handling

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: gyro: mpu3050-core: fix pm_runtime error handling

Chris Spencer <spencercw@gmail.com>
    iio: chemical: bme680: Fix measurement wait duration calculation

Lukas Schmid <lukas.schmid@netcube.li>
    iio: potentiometer: mcp4131: fix double application of wiper shift

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: chemical: sps30_i2c: fix buffer size in sps30_i2c_read_meas()

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: chemical: sps30_serial: fix buffer size in sps30_serial_read_meas()

Oleksij Rempel <linux@rempel-privat.de>
    iio: dac: ds4424: reject -128 RAW value

Filipe Manana <fdmanana@suse.com>
    btrfs: abort transaction on failure to update root in the received subvol ioctl

Filipe Manana <fdmanana@suse.com>
    btrfs: fix transaction abort on file creation due to name hash collision

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: fix iface port assignment in parse_server_interfaces

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix atomic open with O_DIRECT & O_SYNC

Josh Law <objecting@objecting.org>
    lib/bootconfig: check bounds before writing in __xbc_open_brace()

Josh Law <objecting@objecting.org>
    lib/bootconfig: fix snprintf truncation check in xbc_node_compose_key_after()

Shashank Balaji <shashank.mahadasyam@sony.com>
    x86/apic: Disable x2apic on resume if the kernel expects so

Junxiao Bi <junxiao.bi@oracle.com>
    scsi: core: Fix error handling for scsi_alloc_sdev()

Josh Law <objecting@objecting.org>
    lib/bootconfig: fix off-by-one in xbc_verify_tree() unclosed brace error

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Copy detected format information to secondary device

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Move quiesce state with pprc swap

Darrick J. Wong <djwong@kernel.org>
    xfs: fix undersized l_iclog_roundoff values

Calvin Owens <calvin@wbinvd.org>
    tracing: Fix trace_buf_size= cmdline parameter with sizes >= 2G

Luca Ceresoli <luca.ceresoli@bootlin.com>
    drm/bridge: ti-sn65dsi83: fix CHA_DSI_CLK_RANGE rounding

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Set num IP blocks to 0 if discovery fails

Alysa Liu <Alysa.Liu@amd.com>
    drm/amdgpu: Fix use-after-free race in VM acquire

Fan Wu <fanwu01@zju.edu.cn>
    net: ethernet: arc: emac: quiesce interrupts before requesting IRQ

Jian Zhang <zhangjian.3032@bytedance.com>
    net: ncsi: fix skb leak in error paths

Marios Makassikis <mmakassikis@freebox.fr>
    smb: server: fix use-after-free in smb2_open()

Helge Deller <deller@gmx.de>
    parisc: Check kernel mapping earlier at bootup

Helge Deller <deller@gmx.de>
    parisc: Fix initial page table creation for boot

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pmbus/q54sj108a2) fix stack overflow in debugfs read

Dave Airlie <airlied@redhat.com>
    nouveau/dpcd: return EBUSY for aux xfer if the device is asleep

Helge Deller <deller@gmx.de>
    parisc: Increase initial mapping to 64 MB with KALLSYMS

Sven Eckelmann <sven@narfation.org>
    batman-adv: Avoid double-rtnl_lock ELP metric worker

Jakub Staniszewski <jakub.staniszewski@linux.intel.com>
    ice: fix retry for AQ command 0x06EE

Long Li <longli@microsoft.com>
    net: mana: Ring doorbell at 4 CQ wraparounds

Ariel Silver <arielsilver77@gmail.com>
    media: dvb-net: fix OOB access in ULE extension header tables

Luka Gejak <luka.gejak@linux.dev>
    staging: rtl8723bs: fix potential out-of-bounds read in rtw_restruct_wmm_ie

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    staging: rtl8723bs: properly validate the data in rtw_get_ie_ex()

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    ixgbevf: fix link setup issue

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v3-its: Limit number of per-device MSIs to the range the ITS supports

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    device property: Allow secondary lookup in fwnode_get_next_child_node()

Franz Schnyder <franz.schnyder@toradex.com>
    drm/bridge: ti-sn65dsi86: Enable HPD polling if IRQ is not used

Steven Rostedt <rostedt@goodmis.org>
    time/jiffies: Mark jiffies_64_to_clock_t() notrace

Randy Dunlap <rdunlap@infradead.org>
    time: add kernel-doc in time.c

Max Kellermann <max.kellermann@ionos.com>
    ceph: fix i_nlink underrun during async unlink

Ilya Dryomov <idryomov@gmail.com>
    libceph: admit message frames only in CEPH_CON_S_OPEN state

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Use u32 for non-negative values in ceph_monmap_decode()

Ilya Dryomov <idryomov@gmail.com>
    libceph: prevent potential out-of-bounds reads in process_message_header()

Ilya Dryomov <idryomov@gmail.com>
    libceph: reject preamble if control segment is empty

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix potential out-of-bounds access in ceph_handle_auth_reply()

Mehul Rao <mehulrao@gmail.com>
    tipc: fix divide-by-zero in tipc_sk_filter_connect()

Penghe Geng <pgeng@nvidia.com>
    mmc: core: Avoid bitfield RMW for claim/retune flags

Felix Gu <ustc.gu@gmail.com>
    mmc: mmci: Fix device_node reference leak in of_get_dml_pipe_index()

Kalesh Singh <kaleshsingh@google.com>
    mm/tracing: rss_stat: ensure curr is false from kthread context

Ziyi Guo <n7l8m4@u.northwestern.edu>
    usb: image: mdc800: kill download URB on timeout

Oliver Neukum <oneukum@suse.com>
    usb: mdc800: handle signal and read racing

Fan Wu <fanwu01@zju.edu.cn>
    usb: renesas_usbhs: fix use-after-free in ISR during device removal

Oliver Neukum <oneukum@suse.com>
    usb: class: cdc-wdm: fix reordering issue in read code path

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Limit the length of unkillable synchronous timeouts

Alan Stern <stern@rowland.harvard.edu>
    USB: usbtmc: Use usb_bulk_msg_killable() with user-specified timeouts

Alan Stern <stern@rowland.harvard.edu>
    USB: usbcore: Introduce usb_bulk_msg_killable()

Marc Zyngier <maz@kernel.org>
    usb: cdc-acm: Restore CAP_BRK functionnality to CH343

Gabor Juhos <j4g8y7@gmail.com>
    usb: core: don't power off roothub PHYs if phy_set_mode() fails

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: misc: uss720: properly clean up reference in uss720_probe()

Oliver Neukum <oneukum@suse.com>
    usb: yurex: fix race in probe

Zilin Guan <zilin@seu.edu.cn>
    usb: xhci: Fix memory leak in xhci_disable_slot()

Vyacheslav Vahnenko <vahnenko2003@gmail.com>
    USB: ezcap401 needs USB_QUIRK_NO_BOS to function on 10gbs usb speed

Christoffer Sandberg <cs@tuxedo.de>
    usb/core/quirks: Add Huawei ME906S-device to wakeup quirk

A1RM4X <dev@a1rm4x.com>
    USB: add QUIRK_NO_BOS for video capture several devices

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Initialize AVIC VMCB fields if AVIC is enabled with in-kernel APIC

Zhang Heng <zhangheng@kylinos.cn>
    ASoC: amd: yc: Add DMI quirk for ASUS EXPERTBOOK PM1503CDA

Oleksij Rempel <linux@rempel-privat.de>
    net: usb: lan78xx: skip LTM configuration for LAN7850

Oleksij Rempel <linux@rempel-privat.de>
    net: usb: lan78xx: fix TX byte statistics for small packets

Oleksij Rempel <linux@rempel-privat.de>
    net: usb: lan78xx: fix silent drop of packets with checksum errors

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Check endpoint numbers at parsing Scarlett2 mixer interfaces

Qingye Zhao <zhaoqingye@honor.com>
    cgroup: fix race between task migration and iteration

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sdm845-oneplus: Mark l14a regulator as boot-on"

Seungjin Bae <eeodqql09@gmail.com>
    usb: gadget: f_mass_storage: Fix potential integer overflow in check_command_size_in_blocks()

Alok Tiwari <alok.a.tiwari@oracle.com>
    octeontx2-af: devlink: fix NIX RAS reporter to use RAS interrupt status

Przemek Kitszel <przemyslaw.kitszel@intel.com>
    octeontx2-af: devlink health: use retained error fmsg API

Alok Tiwari <alok.a.tiwari@oracle.com>
    octeontx2-af: devlink: fix NIX RAS reporter recovery condition

Ricardo B. Marlière <rbm@suse.com>
    net: bonding: Fix nd_tbl NULL dereference when IPv6 is disabled

Casey Connolly <casey.connolly@linaro.org>
    ASoC: detect empty DMI strings

Chen Ni <nichen@iscas.ac.cn>
    ASoC: amd: acp3x-rt5682-max9836: Add missing error check for clock acquisition

Ben Dooks <ben.dooks@codethink.co.uk>
    ACPI: OSL: fix __iomem type on return from acpi_os_map_generic_address()

Matt Vollrath <tactii@gmail.com>
    e1000/e1000e: Fix leak in DMA error cleanup

Alok Tiwari <alok.a.tiwari@oracle.com>
    i40e: fix src IP mask checks and memcpy argument names in cloud filter

Sungwoo Kim <iam@sung-woo.kim>
    nvme-pci: Fix race bug in nvme_poll_irqdisable()

Sungwoo Kim <iam@sung-woo.kim>
    nvme-pci: Fix slab-out-of-bounds in nvme_dbbuf_set

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    sched: idle: Make skipping governor callbacks more consistent

Peng Fan <peng.fan@nxp.com>
    regulator: pca9450: Correct interrupt type

Frieder Schrempf <frieder.schrempf@kontron.de>
    regulator: pca9450: Make IRQ optional

Yuan Tan <tanyuan98@outlook.com>
    netfilter: xt_IDLETIMER: reject rev0 reuse of ALARM timer labels

Hyunwoo Kim <imv4bel@gmail.com>
    netfilter: nfnetlink_cthelper: fix OOB read in nfnl_cthelper_dump_table()

Hyunwoo Kim <imv4bel@gmail.com>
    netfilter: nfnetlink_queue: fix entry leak in bridge verdict error path

David Dull <monderasdor@gmail.com>
    netfilter: x_tables: guard option walkers against 1-byte tail reads

Jenny Guanni Qu <qguanni@gmail.com>
    netfilter: nft_set_pipapo: fix stack out-of-bounds read in pipapo_drop()

Chengfeng Ye <dg573847474@gmail.com>
    mctp: route: hold key->lock in mctp_flow_prepare_output()

Wenyuan Li <2063309626@qq.com>
    can: hi311x: hi3110_open(): add check for hi3110_power_enable() return value

Haiyue Wang <haiyuewa@163.com>
    mctp: i2c: fix skb memory leak in receive path

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    serial: caif: hold tty->link reference in ldisc_open and ser_release

matteo.cotifava <cotifavamatteo@gmail.com>
    ASoC: soc-core: flush delayed work before removing DAIs and widgets

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: core: Do not call link_exit() on uninitialized rtd objects

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: core: Exit all links before removing their components

matteo.cotifava <cotifavamatteo@gmail.com>
    ASoC: soc-core: drop delayed_work_pending() check before flush

Weiming Shi <bestswngs@gmail.com>
    net/sched: teql: fix NULL pointer dereference in iptunnel_xmit on TEQL slave xmit

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix DMA FIFO desync on error CQE SQ recovery

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5: Fix deadlock between devlink lock and esw->wq

Daniel Jurgens <danielj@nvidia.com>
    net/mlx5: Query to see if host PF is disabled

Daniel Jurgens <danielj@nvidia.com>
    net/mlx5: IFC updates for disabled host PF

Hangbin Liu <liuhangbin@gmail.com>
    bonding: handle BOND_LINK_FAIL, BOND_LINK_BACK as valid link states

Mieczyslaw Nalewaj <namiltd@yahoo.com>
    net: dsa: realtek: rtl8365mb: remove ifOutDiscards from rx_packets

Eric Badger <ebadger@purestorage.com>
    xprtrdma: Decrement re_receiving on the early exit paths

J. Neuschäfer <j.ne@posteo.net>
    powerpc: 83xx: km83xx: Fix keymile vendor prefix

Tzung-Bi Shih <tzungbi@kernel.org>
    remoteproc: mediatek: Unprepare SCP clock during system suspend

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    remoteproc: sysmon: Correct subsys_name_len type in QMI request

Christophe Leroy (CS GROUP) <chleroy@kernel.org>
    powerpc/uaccess: Fix inline assembly for clang build on PPC32

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Check max frame size for implicit feedback mode, too

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Avoid implicit feedback mode on DIYINHK USB Audio 2.0

Azamat Almazbek uulu <almazbek1608@gmail.com>
    ASoC: amd: yc: Add ASUS EXPERTBOOK BM1503CDA to quirk table

Tomas Henzl <thenzl@redhat.com>
    scsi: ses: Fix devices attaching to different hosts

Sofia Schneider <sofia@schn.dev>
    ACPI: OSI: Add DMI quirk for Acer Aspire One D255

Ramanathan Choodamani <quic_rchoodam@quicinc.com>
    wifi: mac80211: set default WMM parameters on all links

Al Viro <viro@zeniv.linux.org.uk>
    unshare: fix unshare_fs() handling

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Add NULL checks when resetting request and reply queues

Piotr Mazek <pmazek@outlook.com>
    ACPI: PM: Save NVS memory on Lenovo G70-35

Jan Kiszka <jan.kiszka@siemens.com>
    scsi: storvsc: Fix scheduling while atomic on PREEMPT_RT

Menglong Dong <menglong8.dong@gmail.com>
    net: tcp: accept old ack during closing

Victor Nogueira <victor@mojatatu.com>
    net/sched: Only allow act_ct to bind to clsact/ingress qdiscs and shared blocks

Guenter Roeck <linux@roeck-us.net>
    tracing: Add NULL pointer check to trigger_data_free()

Larysa Zaremba <larysa.zaremba@intel.com>
    xdp: produce a warning when calculated tailroom is negative

Larysa Zaremba <larysa.zaremba@intel.com>
    xdp: use modulo operation to calculate XDP frag tailroom

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: act_ife: Fix metalist update behavior

Jiayuan Chen <jiayuan.chen@shopee.com>
    net: ipv6: fix panic when IPv4 route references loopback IPv6 nexthop

Fernando Fernandez Mancera <fmancera@suse.de>
    net: vxlan: fix nd_tbl NULL dereference when IPv6 is disabled

Fernando Fernandez Mancera <fmancera@suse.de>
    net: bridge: fix nd_tbl NULL dereference when IPv6 is disabled

Lorenzo Bianconi <lorenzo@kernel.org>
    net: ethernet: mtk_eth_soc: Reset prog ptr to old_prog in case of error in mtk_xdp_setup()

Ovidiu Panait <ovidiu.panait.rb@renesas.com>
    net: stmmac: Fix error handling in VLAN add and delete paths

Jakub Kicinski <kuba@kernel.org>
    nfc: rawsock: cancel tx_work before socket teardown

Jakub Kicinski <kuba@kernel.org>
    nfc: nci: clear NCI_DATA_EXCHANGE before calling completion callback

Jakub Kicinski <kuba@kernel.org>
    nfc: nci: free skb on nci_transceive early error paths

Ian Ray <ian.ray@gehealthcare.com>
    net: nfc: nci: Fix zero-length proprietary notifications

Koichiro Den <den@valinux.co.jp>
    net: sched: avoid qdisc_reset_all_tx_gt() vs dequeue race for lockless qdiscs

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: fix sleep while atomic on suspend/resume

Jakub Kicinski <kuba@kernel.org>
    ipv6: fix NULL pointer deref in ip6_rt_get_dev_rcu()

Lang Xu <xulang@uniontech.com>
    bpf: Fix a UAF issue in bpf_trampoline_link_cgroup_shim

Kui-Feng Lee <thinker.li@gmail.com>
    bpf: export bpf_link_inc_not_zero.

David Thomson <dt@linux-mail.net>
    xen/acpi-processor: fix _CST detection using undersized evaluation buffer

Eric Dumazet <edumazet@google.com>
    indirect_call_wrapper: do not reevaluate function pointer

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: Fix possible oob access in mt76_connac2_mac_write_txwi_80211()

Bart Van Assche <bvanassche@acm.org>
    wifi: wlcore: Fix a locking bug

Bart Van Assche <bvanassche@acm.org>
    wifi: cw1200: Fix locking in error paths

Vimlesh Kumar <vimleshk@marvell.com>
    octeon_ep: avoid compiler and IQ/OQ reordering

Vimlesh Kumar <vimleshk@marvell.com>
    octeon_ep: Relocate counter updates before NAPI

Mieczyslaw Nalewaj <namiltd@yahoo.com>
    net: dsa: realtek: rtl8365mb: fix rtl8365mb_phy_ocp_write return value

Shuvam Pandey <shuvampandey1@gmail.com>
    kunit: tool: copy caller args in run_kernel to prevent mutation

Rae Moar <rmoar@google.com>
    kunit: tool: Add command line interface to filter and report attributes

Daniel Latypov <dlatypov@google.com>
    kunit: tool: fix pre-existing `mypy --strict` errors and update run_checks.py

Daniel Latypov <dlatypov@google.com>
    kunit: tool: remove unused imports and variables

Alexander Pantyukhin <apantykhin@gmail.com>
    kunit: kunit.py extract handlers

Daniel Latypov <dlatypov@google.com>
    kunit: tool: make parser preserve whitespace when printing test log

Daniel Latypov <dlatypov@google.com>
    kunit: tool: don't include KTAP headers and the like in the test log

Rae Moar <rmoar@google.com>
    kunit: tool: parse KTAP compliant test output

Daniel Latypov <dlatypov@google.com>
    kunit: tool: make --json do nothing if --raw_ouput is set

Daniel Latypov <dlatypov@google.com>
    kunit: tool: print summary of failed tests if a few failed out of a lot

Alban Bedel <alban.bedel@lht.dlh.de>
    can: mcp251x: fix deadlock in error path of mcp251x_open

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: fix locking for bcm_op runtime updates

Jiayuan Chen <jiayuan.chen@shopee.com>
    atm: lec: fix null-ptr-deref in lec_arp_clear_vccs

Guenter Roeck <linux@roeck-us.net>
    dpaa2-switch: Fix interrupt storm after receiving bad if_id in IRQ handler

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-switch: do not clear any interrupts automatically

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dpaa2-switch: serialize changes to priv->mac with a mutex

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dpaa2-switch replace direct MAC access with dpaa2_switch_port_has_mac()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dpaa2-switch: assign port_priv->mac after dpaa2_mac_connect() call

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dpaa2: replace dpaa2_mac_is_type_fixed() with dpaa2_mac_is_type_phy()

Chintan Vankar <c-vankar@ti.com>
    net: ethernet: ti: am65-cpsw-nuss/cpsw-ale: Fix multicast entry handling in ALE table

Jonathan Teh <jonathan.teh@outlook.com>
    platform/x86: thinkpad_acpi: Fix errors reading battery thresholds

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    ARM: clean up the memset64() C wrapper

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: check removing signal+subflow endp

Paolo Abeni <pabeni@redhat.com>
    selftests: mptcp: more stable simult_flows tests

Junxiao Bi <junxiao.bi@oracle.com>
    scsi: core: Fix refcount leak for tagset_refcnt

Thorsten Blum <thorsten.blum@linux.dev>
    smb: client: Don't log plaintext credentials in cifs_set_cifscreds

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix broken multichannel with krb5+signing

Lars Ellenberg <lars.ellenberg@linbit.com>
    drbd: fix "LOGIC BUG" in drbd_al_begin_io_nonblock()

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: check metadata block offset is within range

Prithvi Tambewagh <activprithvi@gmail.com>
    scsi: target: Fix recursive locking in __configfs_open_file()

Davide Caratti <dcaratti@redhat.com>
    net/sched: ets: fix divide by zero in the offload path

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/irdma: Fix kernel stack leak in irdma_create_user_ah()

Jason Gunthorpe <jgg@ziepe.ca>
    IB/mthca: Add missed mthca_unmap_user_db() for mthca_create_srq()

Vahagn Vardanian <vahagn@redrays.io>
    wifi: mac80211: fix NULL pointer dereference in mesh_rx_csa_frame()

Johannes Berg <johannes.berg@intel.com>
    wifi: radiotap: reject radiotap with unknown bits

Jun Seo <jun.seo.93@proton.me>
    ALSA: usb-audio: Use correct version for UAC3 header validation

Kurt Borja <kuurtb@gmail.com>
    platform/x86: dell-wmi: Add audio/mic mute key codes

Thorsten Blum <thorsten.blum@linux.dev>
    platform/x86: dell-wmi-sysman: Don't hex dump plaintext password data

Mike Rapoport (Microsoft) <rppt@kernel.org>
    x86/efi: defer freeing of boot services memory

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: Add HID_CLAIMED_INPUT guards in raw_event callbacks missing them

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    can: usb: etas_es58x: correctly anchor the urb in the read bulk callback

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    can: ucan: Fix infinite loop from zero-length messages

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    can: ems_usb: ems_usb_read_bulk_callback(): check the proper length of a message

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    net: usb: pegasus: validate USB endpoints

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    net: usb: kalmia: validate USB endpoints

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    net: usb: kaweth: validate USB endpoints

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    nfc: pn533: properly drop the usb interface reference on disconnect

Jens Axboe <axboe@kernel.dk>
    media: dvb-core: fix wrong reinitialization of ringbuffer on reopen

Jann Horn <jannh@google.com>
    eventpoll: Fix integer overflow in ep_loop_check_proc()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: keep vga memory on MacBooks with switchable graphics

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Drop special case for yellow carp without discovery

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    net: arcnet: com20020-pci: fix support for 2.5Mbit cards

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Fix headphone jack handling on Acer Swift SF314

Gui-Dong Han <hanguidong02@gmail.com>
    hwmon: (max16065) Use READ/WRITE_ONCE to avoid compiler optimization induced race

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Add quirk for HP ZBook Studio G4

Thomas Richard (TI) <thomas.richard@bootlin.com>
    usb: cdns3: fix role switching during resume

Théo Lebrun <theo.lebrun@bootlin.com>
    usb: cdns3: call cdns_power_is_lost() only once in cdns_resume()

Hongyu Xie <xiehongyu1@kylinos.cn>
    usb: cdns3: remove redundant if branch

Johan Hovold <johan@kernel.org>
    clk: tegra: tegra124-emc: fix device leak on set_rate()

Shawn Lin <shawn.lin@rock-chips.com>
    arm64: dts: rockchip: Fix rk356x PCIe range mappings

Johan Hovold <johan@kernel.org>
    mfd: omap-usb-host: Fix OF populate on driver rebind

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mfd: omap-usb-host: Convert to platform remove callback returning void

Johan Hovold <johan@kernel.org>
    mfd: qcom-pm8xxx: Fix OF populate on driver rebind

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mfd: qcom-pm8xxx: Convert to platform remove callback returning void

Yongjian Sun <sunyongjian1@huawei.com>
    ext4: fix e4b bitmap inconsistency reports

Matthew Wilcox (Oracle) <willy@infradead.org>
    ext4: convert bd_buddy_page to bd_buddy_folio

Matthew Wilcox (Oracle) <willy@infradead.org>
    ext4: convert bd_bitmap_page to bd_bitmap_folio

Gou Hao <gouhao@uniontech.com>
    ext4: delete redundant calculations in ext4_mb_get_buddy_page_lock()

Theodore Ts'o <tytso@mit.edu>
    ext4: convert some BUG_ON's in mballoc to use WARN_RATELIMITED instead

Kemeng Shi <shikemeng@huaweicloud.com>
    ext4: remove unnecessary e4b->bd_buddy_page check in ext4_mb_load_buddy_gfp

Zhang Yi <yi.zhang@huawei.com>
    ext4: drop extent cache when splitting extent fails

Zhang Yi <yi.zhang@huawei.com>
    ext4: drop extent cache after doing PARTIAL_VALID1 zeroout

Zhang Yi <yi.zhang@huawei.com>
    ext4: don't zero the entire extent if EXT4_EXT_DATA_PARTIAL_VALID1

Zhang Yi <yi.zhang@huawei.com>
    ext4: subdivide EXT4_EXT_DATA_VALID1

Baokun Li <libaokun1@huawei.com>
    ext4: get rid of ppath in ext4_split_extent_at()

Baokun Li <libaokun1@huawei.com>
    ext4: get rid of ppath in ext4_ext_insert_extent()

Baokun Li <libaokun1@huawei.com>
    ext4: get rid of ppath in ext4_ext_create_new_leaf()

Baokun Li <libaokun1@huawei.com>
    ext4: get rid of ppath in ext4_find_extent()

Baokun Li <libaokun1@huawei.com>
    ext4: make ext4_es_remove_extent() return void

Johan Hovold <johan@kernel.org>
    bus: omap-ocp2scp: fix OF populate on driver rebind

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    bus: omap-ocp2scp: Convert to platform remove callback returning void

Johan Hovold <johan@kernel.org>
    drm/tegra: dsi: fix device leak on probe

Sean Christopherson <seanjc@google.com>
    KVM: x86: Ignore -EBUSY when checking nested events from vcpu_block()

Sean Christopherson <seanjc@google.com>
    KVM: x86: WARN if a vCPU gets a valid wakeup that KVM can't yet inject

Alper Ak <alperyasinak1@gmail.com>
    media: qcom: camss: vfe: Fix out-of-bounds access in vfe_isr_reg_update()

Milen Mitkov <quic_mmitkov@quicinc.com>
    media: camss: vfe-480: Multiple outputs support for SM8250

Zilin Guan <zilin@seu.edu.cn>
    media: tegra-video: Fix memory leak in __tegra_channel_try_format()

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: tegra-video: Use accessors for pad config 'try_*' fields

Sean Christopherson <seanjc@google.com>
    KVM: x86: Return "unsupported" instead of "invalid" on access to unsupported PV MSR

Sean Christopherson <seanjc@google.com>
    KVM: x86: Rename KVM_MSR_RET_INVALID to KVM_MSR_RET_UNSUPPORTED

Mathias Krause <minipli@grsecurity.net>
    KVM: x86: Fix KVM_GET_MSRS stack info leak

Sean Christopherson <seanjc@google.com>
    KVM: x86/pmu: Provide "error" semantics for unsupported-but-known PMU MSRs

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Use resource_set_range() that correctly sets ->end

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    resource: Add resource set range and size helpers

Puranjay Mohan <puranjay12@gmail.com>
    PCI: Use resource names in PCI log messages

Puranjay Mohan <puranjay12@gmail.com>
    PCI: Update BAR # and window messages

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Fix printk field formatting

Mika Westerberg <mika.westerberg@linux.intel.com>
    PCI: Introduce pci_dev_for_each_resource()

Johan Hovold <johan@kernel.org>
    memory: mtk-smi: fix device leak on larb probe

Johan Hovold <johan@kernel.org>
    memory: mtk-smi: fix device leaks on common probe

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    memory: mtk-smi: Convert to platform remove callback returning void

Kohei Enju <kohei@enjuk.jp>
    bpf: Fix stack-out-of-bounds write in devmap

Mark Harmstone <mark@harmstone.com>
    btrfs: fix compat mask in error messages in btrfs_check_features()

Mark Harmstone <mark@harmstone.com>
    btrfs: fix incorrect key offset in error message in check_dev_extent_item()

Josef Bacik <josef@toxicpanda.com>
    btrfs: move btrfs_crc32c_final into free-space-cache.c

Peter Zijlstra <peterz@infradead.org>
    perf: Fix __perf_event_overflow() vs perf_remove_from_context() race

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Use inclusive terms

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Cap the packet size pre-calculations

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Move link recovery for hibern8 exit failure to wl_resume

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Always initialize the UIC done completion

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: Remove VALIDATE_RATES quirk for Focusrite devices

Salomon Dushimirimana <salomondush@google.com>
    scsi: pm8001: Fix use-after-free in pm8001_queue_command()

Mathias Krause <minipli@grsecurity.net>
    scsi: lpfc: Properly set WC for DPP mapping

Nam Cao <namcao@linutronix.de>
    irqchip/sifive-plic: Fix frozen interrupt due to affinity setting

Felix Gu <ustc.gu@gmail.com>
    drm/logicvc: Fix device node reference leak in logicvc_drm_config_parse()

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Return the correct value in vmw_translate_ptr functions

Brad Spengler <brad.spengler@opensrcsec.com>
    drm/vmwgfx: Fix invalid kref_put callback in vmw_bo_dirty_release


-------------

Diffstat:

 .clang-format                                      |   1 +
 .../ethernet/freescale/dpaa2/mac-phy-support.rst   |   9 +-
 Makefile                                           |   4 +-
 arch/alpha/kernel/pci.c                            |   5 +-
 arch/arm/include/asm/string.h                      |  14 +-
 arch/arm/kernel/bios32.c                           |  16 +-
 arch/arm/mach-dove/pcie.c                          |  10 +-
 arch/arm/mach-mv78xx0/pcie.c                       |  10 +-
 arch/arm/mach-orion5x/pci.c                        |  10 +-
 .../arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi |   1 -
 arch/arm64/boot/dts/rockchip/rk3568.dtsi           |   4 +-
 arch/arm64/boot/dts/rockchip/rk356x.dtsi           |   2 +-
 arch/arm64/include/asm/pgtable-prot.h              |  76 ++--
 arch/loongarch/include/asm/uaccess.h               |  14 +-
 arch/mips/pci/ops-bcm63xx.c                        |   8 +-
 arch/mips/pci/pci-legacy.c                         |   3 +-
 arch/parisc/include/asm/pgtable.h                  |   2 +-
 arch/parisc/kernel/head.S                          |   7 +-
 arch/parisc/kernel/setup.c                         |  20 +-
 arch/powerpc/include/asm/uaccess.h                 |   2 +-
 arch/powerpc/kernel/pci-common.c                   |  21 +-
 arch/powerpc/platforms/4xx/pci.c                   |   8 +-
 arch/powerpc/platforms/52xx/mpc52xx_pci.c          |   5 +-
 arch/powerpc/platforms/83xx/km83xx.c               |   4 +-
 arch/powerpc/platforms/pseries/pci.c               |  16 +-
 arch/riscv/kernel/stacktrace.c                     |  21 +-
 arch/s390/lib/xor.c                                |   4 +-
 arch/sh/drivers/pci/pcie-sh7786.c                  |  10 +-
 arch/sparc/kernel/leon_pci.c                       |   5 +-
 arch/sparc/kernel/pci.c                            |  10 +-
 arch/sparc/kernel/pcic.c                           |   5 +-
 arch/x86/boot/compressed/sev.c                     |   1 +
 arch/x86/include/asm/efi.h                         |   2 +-
 arch/x86/include/asm/msr-index.h                   |   5 +-
 arch/x86/kernel/apic/apic.c                        |   6 +
 arch/x86/kernel/uprobes.c                          |  24 ++
 arch/x86/kvm/svm/avic.c                            |   8 +-
 arch/x86/kvm/svm/svm.c                             |  11 +-
 arch/x86/kvm/vmx/vmx.c                             |   2 +-
 arch/x86/kvm/x86.c                                 | 120 +++---
 arch/x86/kvm/x86.h                                 |  15 +-
 arch/x86/platform/efi/efi.c                        |   2 +-
 arch/x86/platform/efi/quirks.c                     |  55 ++-
 drivers/acpi/acpi_processor.c                      |  15 +-
 drivers/acpi/osi.c                                 |  13 +
 drivers/acpi/osl.c                                 |   2 +-
 drivers/acpi/sleep.c                               |   8 +
 drivers/base/power/runtime.c                       |   1 +
 drivers/base/property.c                            |  27 +-
 drivers/block/drbd/drbd_actlog.c                   |  53 +--
 drivers/block/drbd/drbd_interval.h                 |   5 +-
 drivers/bluetooth/btqca.c                          |   2 +
 drivers/bus/omap-ocp2scp.c                         |  19 +-
 drivers/clk/tegra/clk-tegra124-emc.c               |   2 +-
 drivers/cpuidle/cpuidle.c                          |  10 -
 drivers/crypto/atmel-sha204a.c                     |   5 +-
 drivers/dma/mmp_pdma.c                             |   6 +
 drivers/firmware/arm_scpi.c                        |   5 +-
 drivers/firmware/efi/mokvar-table.c                |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c            |  38 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_csa.h            |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  36 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c        |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c            |  14 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |  12 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c            |   9 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c          |   3 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_2.c          |   3 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   1 +
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c   |   1 +
 .../amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c |   2 +-
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c    |   2 +-
 drivers/gpu/drm/amd/display/dc/dm_services_types.h |   2 +-
 drivers/gpu/drm/amd/include/dm_pp_interface.h      |   1 +
 drivers/gpu/drm/amd/pm/amdgpu_dpm_internal.c       |  67 +++
 drivers/gpu/drm/amd/pm/inc/amdgpu_dpm_internal.h   |   2 +
 drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c         |   4 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/legacy_dpm.c     |   6 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |  69 ++-
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c   |  13 +-
 drivers/gpu/drm/bridge/ti-sn65dsi83.c              |  13 +-
 drivers/gpu/drm/bridge/ti-sn65dsi86.c              | 118 +++++-
 drivers/gpu/drm/drm_file.c                         |   5 +-
 drivers/gpu/drm/drm_mode_config.c                  |   9 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.h            |   1 +
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |  72 +++-
 drivers/gpu/drm/i915/gt/intel_engine_cs.c          |   3 +-
 drivers/gpu/drm/logicvc/logicvc_drm.c              |   4 +-
 drivers/gpu/drm/msm/msm_gpummu.c                   |   2 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   3 +
 drivers/gpu/drm/radeon/si_dpm.c                    |   4 +-
 drivers/gpu/drm/tegra/dsi.c                        |   6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c         |   9 +-
 drivers/hid/hid-cmedia.c                           |   2 +-
 drivers/hid/hid-creative-sb0540.c                  |   2 +-
 drivers/hid/hid-zydacron.c                         |   2 +-
 drivers/hwmon/max16065.c                           |  26 +-
 drivers/hwmon/pmbus/isl68137.c                     |   7 +-
 drivers/hwmon/pmbus/q54sj108a2.c                   |  19 +-
 drivers/i2c/busses/i2c-cp2615.c                    |   5 +-
 drivers/i2c/busses/i2c-fsi.c                       |   1 +
 drivers/i3c/master/mipi-i3c-hci/cmd.h              |   1 +
 drivers/i3c/master/mipi-i3c-hci/cmd_v1.c           |   2 +-
 drivers/i3c/master/mipi-i3c-hci/cmd_v2.c           |   2 +-
 drivers/i3c/master/mipi-i3c-hci/core.c             |   6 +-
 drivers/i3c/master/mipi-i3c-hci/dma.c              |   4 +-
 drivers/iio/chemical/bme680_core.c                 |   2 +-
 drivers/iio/chemical/sps30_i2c.c                   |   2 +-
 drivers/iio/chemical/sps30_serial.c                |   2 +-
 drivers/iio/dac/ds4424.c                           |   2 +-
 drivers/iio/gyro/mpu3050-core.c                    |  18 +-
 drivers/iio/gyro/mpu3050-i2c.c                     |   3 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c  |   2 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c |   3 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c   |   2 +
 drivers/iio/industrialio-buffer.c                  | 102 ++---
 drivers/iio/light/bh1780.c                         |   4 +-
 drivers/iio/potentiometer/mcp4131.c                |   2 +-
 drivers/infiniband/hw/irdma/verbs.c                |   2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c       |   5 +-
 drivers/iommu/intel/dmar.c                         |   3 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   4 +
 drivers/irqchip/irq-sifive-plic.c                  |   7 +-
 drivers/mailbox/mailbox.c                          |   6 +-
 drivers/md/dm-verity-fec.c                         |   4 +-
 drivers/md/dm-verity-fec.h                         |   3 -
 drivers/media/dvb-core/dmxdev.c                    |   4 +-
 drivers/media/dvb-core/dvb_net.c                   |   3 +
 drivers/media/platform/qcom/camss/camss-vfe-480.c  |  59 ++-
 drivers/memory/mtk-smi.c                           |  13 +-
 drivers/mfd/omap-usb-host.c                        |  11 +-
 drivers/mfd/qcom-pm8xxx.c                          |  14 +-
 drivers/mmc/host/mmci_qcom_dml.c                   |   1 +
 drivers/mmc/host/sdhci-pci-gli.c                   |   9 +
 drivers/mmc/host/sdhci.c                           |   9 +-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |   6 +-
 drivers/mtd/nand/raw/cadence-nand-controller.c     |   2 +-
 drivers/mtd/nand/raw/nand_base.c                   |  14 +-
 drivers/mtd/nand/raw/pl35x-nand-controller.c       |   3 +
 drivers/mtd/nand/spi/macronix.c                    |   3 +-
 drivers/mtd/parsers/redboot.c                      |   6 +-
 drivers/net/arcnet/com20020-pci.c                  |  16 +-
 drivers/net/bonding/bond_debugfs.c                 |  16 +-
 drivers/net/bonding/bond_main.c                    |  10 +-
 drivers/net/caif/caif_serial.c                     |   3 +
 drivers/net/can/spi/hi311x.c                       |   5 +-
 drivers/net/can/spi/mcp251x.c                      |  15 +-
 drivers/net/can/usb/ems_usb.c                      |   7 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   8 +-
 drivers/net/can/usb/gs_usb.c                       |  22 +-
 drivers/net/can/usb/ucan.c                         |   2 +-
 drivers/net/dsa/bcm_sf2.c                          |   8 +-
 drivers/net/dsa/realtek/rtl8365mb.c                |   5 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |  10 -
 drivers/net/ethernet/amd/xgbe/xgbe-main.c          |   1 -
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   3 -
 drivers/net/ethernet/arc/emac_main.c               |  11 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  25 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   7 -
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |   2 +-
 drivers/net/ethernet/cadence/macb.h                |   7 +
 drivers/net/ethernet/cadence/macb_main.c           | 184 +++++++-
 drivers/net/ethernet/cadence/macb_ptp.c            |   4 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |   7 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h   |  10 +-
 .../freescale/dpaa2/dpaa2-switch-ethtool.c         |  34 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |  57 ++-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.h    |   9 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    | 131 ++++--
 drivers/net/ethernet/freescale/fec_main.c          |  19 +-
 drivers/net/ethernet/google/gve/gve.h              |   1 +
 drivers/net/ethernet/google/gve/gve_main.c         |   5 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |   2 -
 drivers/net/ethernet/intel/e1000e/netdev.c         |   2 -
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  14 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   9 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |   8 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  35 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   7 +-
 drivers/net/ethernet/intel/ixgbevf/vf.c            |   3 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   4 +-
 .../net/ethernet/marvell/octeon_ep/octep_main.c    |  48 ++-
 drivers/net/ethernet/marvell/octeon_ep/octep_rx.c  |  27 +-
 .../ethernet/marvell/octeontx2/af/rvu_devlink.c    | 468 ++++++---------------
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  15 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  30 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   3 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  18 +-
 drivers/net/ethernet/microsoft/mana/hw_channel.c   |   6 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  23 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |   1 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |   4 -
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   |   9 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   2 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  61 +--
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   8 -
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   2 +-
 drivers/net/ethernet/ti/cpsw_ale.c                 |   9 +-
 drivers/net/mctp/mctp-i2c.c                        |   1 +
 drivers/net/phy/phy_device.c                       |  13 +-
 drivers/net/usb/aqc111.c                           |  12 +-
 drivers/net/usb/kalmia.c                           |   7 +
 drivers/net/usb/kaweth.c                           |  13 +
 drivers/net/usb/lan78xx.c                          |  10 +-
 drivers/net/usb/lan78xx.h                          |   3 +
 drivers/net/usb/pegasus.c                          |  13 +-
 drivers/net/vxlan/vxlan_core.c                     |   5 +
 .../wireless/broadcom/brcm80211/brcmfmac/btcoex.c  |   6 +-
 drivers/net/wireless/marvell/libertas/main.c       |   4 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |   1 +
 drivers/net/wireless/st/cw1200/pm.c                |   2 +
 drivers/net/wireless/ti/wlcore/main.c              |   4 +-
 drivers/net/wireless/ti/wlcore/tx.c                |   2 +-
 drivers/nfc/nxp-nci/i2c.c                          |   4 +-
 drivers/nfc/pn533/usb.c                            |   1 +
 drivers/nvdimm/bus.c                               |   5 +-
 drivers/nvme/host/core.c                           |   2 +
 drivers/nvme/host/fc.c                             |   2 +-
 drivers/nvme/host/pci.c                            |   8 +-
 drivers/pci/iov.c                                  |   7 +-
 drivers/pci/pci-acpi.c                             |  59 ++-
 drivers/pci/pci.c                                  |  85 +++-
 drivers/pci/pci.h                                  |   5 +
 drivers/pci/pcie/aer.c                             |   3 -
 drivers/pci/probe.c                                |  32 +-
 drivers/pci/quirks.c                               |  15 +-
 drivers/pci/remove.c                               |   5 +-
 drivers/pci/setup-bus.c                            |  57 +--
 drivers/pci/setup-res.c                            |  74 ++--
 drivers/pci/vgaarb.c                               |  17 +-
 drivers/pci/xen-pcifront.c                         |   4 +-
 drivers/platform/x86/dell/dell-wmi-base.c          |   6 +
 .../dell/dell-wmi-sysman/passwordattr-interface.c  |   1 -
 drivers/platform/x86/thinkpad_acpi.c               |   6 +-
 drivers/pnp/quirks.c                               |  29 +-
 drivers/regulator/pca9450-regulator.c              |  41 +-
 drivers/remoteproc/mtk_scp.c                       |  39 ++
 drivers/remoteproc/qcom_sysmon.c                   |   2 +-
 drivers/s390/block/dasd_eckd.c                     |  16 +
 drivers/s390/crypto/zcrypt_ccamisc.c               |  12 +-
 drivers/s390/crypto/zcrypt_cex4.c                  |   3 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   2 +
 drivers/scsi/lpfc/lpfc_sli.c                       |  36 +-
 drivers/scsi/lpfc/lpfc_sli4.h                      |   3 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  32 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |   5 +-
 drivers/scsi/scsi_scan.c                           |   7 +-
 drivers/scsi/ses.c                                 |   5 +-
 drivers/scsi/storvsc_drv.c                         |   5 +-
 drivers/soc/bcm/bcm2835-power.c                    |  18 +-
 drivers/soc/fsl/qbman/qman.c                       |  24 +-
 drivers/spi/spi-cadence-quadspi.c                  |  34 ++
 drivers/spi/spi.c                                  |  25 +-
 drivers/staging/media/tegra-video/vi.c             |  27 +-
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c     |  15 +-
 drivers/staging/rtl8723bs/core/rtw_mlme.c          |   5 +-
 drivers/target/target_core_configfs.c              |  15 +-
 drivers/tty/serial/8250/8250_dma.c                 |  15 +
 drivers/tty/serial/8250/8250_pci.c                 |  17 +
 drivers/tty/serial/8250/8250_port.c                |   6 +
 drivers/tty/serial/uartlite.c                      |   1 +
 drivers/ufs/core/ufshcd.c                          |  35 +-
 drivers/usb/cdns3/core.c                           |  11 +-
 drivers/usb/class/cdc-acm.c                        |   5 +
 drivers/usb/class/cdc-acm.h                        |   1 +
 drivers/usb/class/cdc-wdm.c                        |   4 +-
 drivers/usb/class/usbtmc.c                         |   6 +-
 drivers/usb/core/message.c                         | 100 ++++-
 drivers/usb/core/phy.c                             |   8 +-
 drivers/usb/core/quirks.c                          |  16 +
 drivers/usb/gadget/function/f_mass_storage.c       |  12 +-
 drivers/usb/gadget/function/f_tcm.c                |  14 +
 drivers/usb/host/xhci.c                            |   4 +-
 drivers/usb/image/mdc800.c                         |   6 +-
 drivers/usb/misc/uss720.c                          |   2 +-
 drivers/usb/misc/yurex.c                           |   2 +-
 drivers/usb/renesas_usbhs/common.c                 |   9 +
 drivers/usb/roles/class.c                          |   7 +-
 drivers/usb/serial/f81232.c                        |  77 ++--
 drivers/xen/xen-acpi-processor.c                   |   7 +-
 fs/binfmt_misc.c                                   |   4 +-
 fs/btrfs/ctree.h                                   |   7 +-
 fs/btrfs/disk-io.c                                 |  28 +-
 fs/btrfs/extent_io.c                               |   3 +-
 fs/btrfs/extent_io.h                               |   3 +-
 fs/btrfs/free-space-cache.c                        |   5 +
 fs/btrfs/inode.c                                   |  19 +
 fs/btrfs/ioctl.c                                   |  24 +-
 fs/btrfs/send.c                                    |   4 +
 fs/btrfs/transaction.c                             |  16 +
 fs/btrfs/tree-checker.c                            |   4 +-
 fs/btrfs/uuid-tree.c                               |  46 ++
 fs/ceph/dir.c                                      |  15 +-
 fs/dlm/lock.c                                      |  10 +-
 fs/eventpoll.c                                     |   5 +-
 fs/ext4/ext4.h                                     |   9 +-
 fs/ext4/extents.c                                  | 312 ++++++++------
 fs/ext4/extents_status.c                           |  12 +-
 fs/ext4/extents_status.h                           |   4 +-
 fs/ext4/fast_commit.c                              |   8 +-
 fs/ext4/inline.c                                   |  12 +-
 fs/ext4/inode.c                                    |   8 +-
 fs/ext4/mballoc.c                                  | 258 ++++++------
 fs/ext4/mballoc.h                                  |   4 +-
 fs/ext4/migrate.c                                  |   5 +-
 fs/ext4/move_extent.c                              |   7 +-
 fs/f2fs/data.c                                     |   5 +-
 fs/gfs2/util.c                                     |  31 +-
 fs/iomap/buffered-io.c                             |   7 +-
 fs/nfsd/nfs4xdr.c                                  |   9 +-
 fs/nfsd/nfsctl.c                                   |  31 +-
 fs/nfsd/state.h                                    |  17 +-
 fs/ntfs3/super.c                                   |   5 +
 fs/smb/client/cifsencrypt.c                        |   3 +-
 fs/smb/client/cifsfs.c                             |   9 +-
 fs/smb/client/cifsglob.h                           |  11 +
 fs/smb/client/cifsproto.h                          |   1 +
 fs/smb/client/connect.c                            |   5 +-
 fs/smb/client/dir.c                                |   1 +
 fs/smb/client/file.c                               |  29 +-
 fs/smb/client/misc.c                               |  41 ++
 fs/smb/client/smb2ops.c                            |  14 +-
 fs/smb/client/smb2pdu.c                            |  22 +-
 fs/smb/client/smb2transport.c                      |   4 +-
 fs/smb/server/auth.c                               |  26 +-
 fs/smb/server/smb2pdu.c                            |  17 +-
 fs/squashfs/cache.c                                |   3 +
 fs/xfs/xfs_bmap_item.c                             |   3 +-
 fs/xfs/xfs_dquot.c                                 |   8 +-
 fs/xfs/xfs_log.c                                   |   2 +
 include/asm-generic/tlb.h                          |  77 +++-
 include/linux/bpf.h                                |   6 +
 include/linux/hugetlb.h                            |  17 +-
 include/linux/indirect_call_wrapper.h              |  18 +-
 include/linux/ioport.h                             |  32 ++
 include/linux/irqchip/arm-gic-v3.h                 |   1 +
 include/linux/mlx5/mlx5_ifc.h                      |   4 +-
 include/linux/mm_types.h                           |   1 +
 include/linux/mmc/host.h                           |   9 +-
 include/linux/pci.h                                |  14 +
 include/linux/skbuff.h                             |  12 +
 include/linux/stmmac.h                             |   1 -
 include/linux/uprobes.h                            |   1 +
 include/linux/usb.h                                |   8 +-
 include/net/act_api.h                              |   1 +
 include/net/bluetooth/hci_core.h                   |   3 +
 include/net/netfilter/nf_tables.h                  |   7 +-
 include/net/sch_generic.h                          |  38 ++
 include/net/tc_act/tc_gate.h                       |  33 +-
 include/net/tc_act/tc_ife.h                        |   4 +-
 include/net/udp_tunnel.h                           |   2 +-
 include/sound/soc.h                                |   2 +
 include/trace/events/kmem.h                        |   8 +-
 io_uring/io-wq.c                                   |   2 +-
 io_uring/kbuf.c                                    |   8 +-
 kernel/bpf/devmap.c                                |  22 +-
 kernel/bpf/syscall.c                               |   3 +-
 kernel/bpf/trampoline.c                            |   4 +-
 kernel/bpf/verifier.c                              |   4 +
 kernel/cgroup/cgroup.c                             |   1 +
 kernel/events/core.c                               |  42 +-
 kernel/events/uprobes.c                            |  10 +-
 kernel/fork.c                                      |   2 +-
 kernel/kprobes.c                                   |  47 +--
 kernel/rcu/tree_nocb.h                             |   5 +-
 kernel/sched/fair.c                                |   6 -
 kernel/sched/idle.c                                |  45 +-
 kernel/time/time.c                                 | 171 +++++++-
 kernel/trace/trace.c                               |   6 +-
 kernel/trace/trace_events.c                        |  51 ++-
 kernel/trace/trace_events_trigger.c                |   3 +
 lib/bootconfig.c                                   |   9 +-
 mm/hugetlb.c                                       | 143 ++++---
 mm/kfence/core.c                                   |  22 +-
 mm/mmu_gather.c                                    |  33 ++
 mm/rmap.c                                          |  25 +-
 net/atm/lec.c                                      |  26 +-
 net/batman-adv/bat_iv_ogm.c                        |   3 +
 net/batman-adv/bat_v_elp.c                         |  10 +-
 net/batman-adv/hard-interface.c                    |   8 +-
 net/batman-adv/hard-interface.h                    |   1 +
 net/bluetooth/hci_core.c                           |  34 +-
 net/bluetooth/hci_sync.c                           |   2 +-
 net/bluetooth/hidp/core.c                          |  16 +-
 net/bluetooth/l2cap_core.c                         |  31 +-
 net/bluetooth/smp.c                                |   2 +-
 net/bridge/br_device.c                             |   2 +-
 net/bridge/br_input.c                              |   2 +-
 net/can/bcm.c                                      |   1 +
 net/ceph/auth.c                                    |   6 +-
 net/ceph/messenger_v2.c                            |  31 +-
 net/ceph/mon_client.c                              |   6 +-
 net/core/dev.c                                     |   2 +-
 net/core/filter.c                                  |  23 +-
 net/dsa/dsa2.c                                     |   7 +
 net/ipv4/icmp.c                                    |   4 +-
 net/ipv4/tcp.c                                     |   3 +-
 net/ipv4/tcp_input.c                               |  18 +-
 net/ipv4/tcp_ipv4.c                                |   3 +-
 net/ipv4/tcp_offload.c                             |  74 ++++
 net/ipv4/udp_offload.c                             |   3 +-
 net/ipv6/ip6_output.c                              |  35 +-
 net/ipv6/route.c                                   |  11 +-
 net/ipv6/tcp_ipv6.c                                |   3 +-
 net/ipv6/tcpv6_offload.c                           |  65 +++
 net/l2tp/l2tp_ppp.c                                |  25 +-
 net/mac80211/debugfs.c                             |  14 +-
 net/mac80211/link.c                                |   2 +
 net/mac80211/mesh.c                                |   6 +
 net/mctp/route.c                                   |  13 +-
 net/mptcp/pm.c                                     |   2 +-
 net/mptcp/pm_netlink.c                             |  72 +++-
 net/mptcp/protocol.h                               |   2 +
 net/ncsi/ncsi-aen.c                                |   3 +-
 net/ncsi/ncsi-rsp.c                                |  16 +-
 net/netfilter/nf_conntrack_h323_asn1.c             |   4 +
 net/netfilter/nf_conntrack_netlink.c               |  67 +--
 net/netfilter/nf_conntrack_sip.c                   |   6 +-
 net/netfilter/nf_tables_api.c                      |   8 +-
 net/netfilter/nfnetlink_cthelper.c                 |   8 +-
 net/netfilter/nfnetlink_osf.c                      |  13 +
 net/netfilter/nfnetlink_queue.c                    |   4 +-
 net/netfilter/nft_compat.c                         |   6 +-
 net/netfilter/nft_ct.c                             |   9 +
 net/netfilter/nft_log.c                            |   2 +-
 net/netfilter/nft_meta.c                           |   2 +-
 net/netfilter/nft_numgen.c                         |   2 +-
 net/netfilter/nft_set_pipapo.c                     | 123 ++++--
 net/netfilter/nft_set_pipapo.h                     |   2 +
 net/netfilter/nft_tunnel.c                         |   5 +-
 net/netfilter/xt_CT.c                              |   4 +
 net/netfilter/xt_IDLETIMER.c                       |   6 +
 net/netfilter/xt_dccp.c                            |   4 +-
 net/netfilter/xt_tcpudp.c                          |   6 +-
 net/netfilter/xt_time.c                            |   4 +-
 net/nfc/nci/core.c                                 |  21 +-
 net/nfc/nci/data.c                                 |  12 +-
 net/nfc/rawsock.c                                  |  11 +
 net/rose/af_rose.c                                 |   5 +
 net/sched/act_ct.c                                 |   6 +
 net/sched/act_gate.c                               | 264 ++++++++----
 net/sched/act_ife.c                                |  93 ++--
 net/sched/cls_api.c                                |   7 +
 net/sched/cls_u32.c                                |  13 +-
 net/sched/sch_ets.c                                |  12 +-
 net/sched/sch_generic.c                            |  27 --
 net/sched/sch_teql.c                               |   8 +-
 net/smc/af_smc.c                                   |  23 +-
 net/smc/smc.h                                      |   5 +
 net/smc/smc_close.c                                |   2 +-
 net/sunrpc/cache.c                                 |  26 +-
 net/sunrpc/xprtrdma/verbs.c                        |   7 +-
 net/tipc/socket.c                                  |   2 +
 net/wireless/core.c                                |   4 +-
 net/wireless/core.h                                |   4 +-
 net/wireless/pmsr.c                                |   1 +
 net/wireless/radiotap.c                            |   4 +-
 net/wireless/scan.c                                |  14 +-
 sound/core/pcm_lib.c                               |  11 +-
 sound/core/pcm_native.c                            |  25 +-
 sound/pci/hda/patch_conexant.c                     |  11 +
 sound/soc/amd/acp3x-rt5682-max9836.c               |   9 +-
 sound/soc/amd/yc/acp6x-mach.c                      |  14 +
 sound/soc/qcom/qdsp6/q6apm-dai.c                   |   1 +
 sound/soc/qcom/qdsp6/q6apm-lpass-dais.c            |   1 +
 sound/soc/qcom/qdsp6/q6apm.c                       |   1 +
 sound/soc/soc-core.c                               |  35 +-
 sound/usb/endpoint.c                               |  10 +-
 sound/usb/midi.c                                   |   3 +-
 sound/usb/mixer_scarlett2.c                        |   2 +
 sound/usb/quirks.c                                 |   4 +-
 sound/usb/validate.c                               |   2 +-
 tools/bootconfig/main.c                            |   7 +-
 tools/testing/kunit/kunit.py                       | 279 +++++++-----
 tools/testing/kunit/kunit_config.py                |   4 +-
 tools/testing/kunit/kunit_kernel.py                |  42 +-
 tools/testing/kunit/kunit_parser.py                | 171 +++++---
 tools/testing/kunit/kunit_tool_test.py             | 120 +++++-
 tools/testing/kunit/run_checks.py                  |   4 +-
 .../kunit/test_data/test_parse_ktap_output.log     |   8 +
 .../kunit/test_data/test_parse_subtest_header.log  |   7 +
 tools/testing/selftests/net/amt.sh                 |   7 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  49 +++
 tools/testing/selftests/net/mptcp/simult_flows.sh  |  11 +-
 495 files changed, 5835 insertions(+), 3013 deletions(-)


