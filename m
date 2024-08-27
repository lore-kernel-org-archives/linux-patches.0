Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449DB1C578B;
	Tue, 27 Aug 2024 14:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769740; cv=none; b=tIXjSMObolTNbL3pTbeGS//o7eyq50dJwfiTliBCytGTkIetk3UULHUcfkIiP2cCP0Ly+SszGL7lE2YjaZE4JCgzpnG0pcWc6XzwladXxR2cwIw7ILfFbbdb/Khd4CXNoEiDOA3lkYqJLMkBiysQ7VhtUZFxJCekq9NhRxKde+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769740; c=relaxed/simple;
	bh=aRESbM402iMv82M13PqcFRsxmXf/3F2SHOgIuw6L7Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=N2jKUOxYVdzJ6EbZ5sE48iut1dK1q3sQo+tvwG3eh0Gga0pOsHnbtxY0PIV+qQrEXsslgpCyJhhTBaEJWtBDrE0wynoJY9cMim5ys4djQ0dElB5jv4eRzDwlp9jr97qUEC8yJJIcAhBxo8V1sog8JaGTs5aom1pzio3N4pRoyIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=up3QPpL3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="up3QPpL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A968C4AF4D;
	Tue, 27 Aug 2024 14:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769739;
	bh=aRESbM402iMv82M13PqcFRsxmXf/3F2SHOgIuw6L7Uc=;
	h=From:To:Cc:Subject:Date:From;
	b=up3QPpL3CZ7ZDx9vRUHdgwa3nTboVnlQP4kUMSA71Sak+LuG5OhEX5tc6XoxLCRL4
	 tq7O0w9LrNB06KDxgY0nt0fFxjMilHmH7nnNX+adXqEPLZNaq7h9g0ontNbIwa/LpR
	 bMC+/m7lMxV7b9roHCtLwlbromgtKfvJCiAmvymI=
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
Subject: [PATCH 6.6 000/341] 6.6.48-rc1 review
Date: Tue, 27 Aug 2024 16:33:51 +0200
Message-ID: <20240827143843.399359062@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.48-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.48-rc1
X-KernelTest-Deadline: 2024-08-29T14:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.48 release.
There are 341 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.48-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.48-rc1

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Input: MT - limit max slots

Jan Höppner <hoeppner@linux.ibm.com>
    Revert "s390/dasd: Establish DMA alignment"

Mengyuan Lou <mengyuanlou@net-swift.com>
    net: ngbe: Fix phy mode set to external phy

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix race condition between destroy_previous_session() and smb2 operations()

Boyuan Zhang <boyuan.zhang@amd.com>
    drm/amdgpu/vcn: not pause dpg for unified queue

Boyuan Zhang <boyuan.zhang@amd.com>
    drm/amdgpu/vcn: identify unified queue in sw init

NeilBrown <neilb@suse.de>
    NFSD: simplify error paths in nfsd_svc()

Yonghong Song <yonghong.song@linux.dev>
    selftests/bpf: Add a test to verify previous stacksafe() fix

Yonghong Song <yonghong.song@linux.dev>
    bpf: Fix a kernel verifier crash in stacksafe()

Zi Yan <ziy@nvidia.com>
    mm/numa: no task_numa_fault() call if PTE is changed

Zi Yan <ziy@nvidia.com>
    mm/numa: no task_numa_fault() call if PMD is changed

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Relax start tick time check for slave timer elements

Faizal Rahim <faizal.abdul.rahim@linux.intel.com>
    igc: Fix qbv tx latency by setting gtxoffset

Jianhua Lu <lujianhua000@gmail.com>
    drm/panel: nt36523: Set 120Hz fps for xiaomi,elish panels

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/mdss: specify cfg bandwidth for SDM670

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: (ltc2992) Fix memory leak in ltc2992_parse_dt()

Eric Dumazet <edumazet@google.com>
    tcp: do not export tcp_twsk_purge()

Jithu Joseph <jithu.joseph@intel.com>
    platform/x86/intel/ifs: Call release_firmware() when handling errors.

Alex Hung <alex.hung@amd.com>
    Revert "drm/amd/display: Validate hw_points_num before using it"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "usb: gadget: uvc: cleanup request when not in correct state"

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: check re-using ID of closed subflow

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: validate fullmesh endp on 1st sf

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: avoid possible UaF when selecting endp

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: fullmesh: select the right ID later

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: only in-kernel cannot have entries with ID 0

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: check add_addr_accept_max before accepting new ADD_ADDR

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: only decrement add_addr_accepted for MPJ req

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: only mark 'subflow' endp as available

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: remove mptcp_pm_remove_subflow()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: re-using ID of unused flushed subflows

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: re-using ID of unused removed subflows

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: re-using ID of unused removed ADD_ADDR

Dave Airlie <airlied@redhat.com>
    nouveau/firmware: use dma non-coherent allocator

Peng Fan <peng.fan@nxp.com>
    pmdomain: imx: wait SSAR when i.MX93 power domain on

Alexander Stein <alexander.stein@ew.tq-group.com>
    pmdomain: imx: scu-pd: Remove duplicated clocks

Ben Whitten <ben.whitten@gmail.com>
    mmc: dw_mmc: allow biu and ciu clocks to defer

Mengqi Zhang <mengqi.zhang@mediatek.com>
    mmc: mtk-sd: receive cmd8 data when hs400 tuning fail

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Make ICC_*SGI*_EL1 undef in the absence of a vGICv3

Nikolay Kuratov <kniv@yandex-team.ru>
    cxgb4: add forgotten u64 ivlan cast before shift

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - use new forcenorestore quirk to replace old buggy quirk combination

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - add forcenorestore quirk to leave controller untouched even on s3

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Defer calculation of resolution until resolution_code is known

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Loongson64: Set timer mode in cpu-probe

Martin Whitaker <foss@martin-whitaker.me.uk>
    net: dsa: microchip: fix PTP config failure when using multiple ports

Candice Li <candice.li@amd.com>
    drm/amdgpu: Validate TA binary size

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: the buffer of smb2 query dir response has at least 1 byte

Chaotian Jing <chaotian.jing@mediatek.com>
    scsi: core: Fix the return value of scsi_logical_block_count()

Griffin Kroah-Hartman <griffin@kroah.com>
    Bluetooth: MGMT: Add error handling to pair_device()

Paulo Alcantara <pc@manguebit.com>
    smb: client: ignore unhandled reparse tags

Dan Carpenter <dan.carpenter@linaro.org>
    mmc: mmc_test: Fix NULL dereference on allocation failure

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm/msm: fix the highest_bank_bit for sc7180

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/mdss: Handle the reg bus ICC path

Konrad Dybcio <konrad.dybcio@linaro.org>
    drm/msm/mdss: Rename path references to mdp_path

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/mdss: switch mdss to use devm_of_icc_get()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: take plane rotation into account for wide planes

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm/msm/dpu: try multirect based on mdp clock limits

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: cleanup FB if dpu_format_populate_layout fails

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm/msm/dp: reset the link phy params before link training

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm/msm/dpu: move dpu_encoder's connector assignment to atomic_enable()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: capture snapshot on the first commit_done timeout

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: split dpu_encoder_wait_for_event into two functions

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: drop MSM_ENC_VBLANK support

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: use drmm-managed allocation for dpu_encoder_phys

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm/msm/dp: fix the max supported bpp logic

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: don't play tricks with debug macros

Menglong Dong <menglong8.dong@gmail.com>
    net: ovs: fix ovs_drop_reasons error

Sean Anderson <sean.anderson@linux.dev>
    net: xilinx: axienet: Fix dangling multicast addresses

Sean Anderson <sean.anderson@linux.dev>
    net: xilinx: axienet: Always disable promiscuous mode

Bharat Bhushan <bbhushan2@marvell.com>
    octeontx2-af: Fix CPT AF register offset calculation

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: validate vlan header

Somnath Kotur <somnath.kotur@broadcom.com>
    bnxt_en: Fix double DMA unmapping for XDP_REDIRECT

Eric Dumazet <edumazet@google.com>
    ipv6: prevent possible UAF in ip6_xmit()

Eric Dumazet <edumazet@google.com>
    ipv6: fix possible UAF in ip6_finish_output2()

Eric Dumazet <edumazet@google.com>
    ipv6: prevent UAF in ip6_send_skb()

Felix Fietkau <nbd@nbd.name>
    udp: fix receiving fraglist GSO packets

Stephen Hemminger <stephen@networkplumber.org>
    netem: fix return value if duplicate enqueue fails

Joseph Huang <Joseph.Huang@garmin.com>
    net: dsa: mv88e6xxx: Fix out-of-bound access

Paolo Abeni <pabeni@redhat.com>
    igb: cope with large MAX_SKB_FRAGS

Dan Carpenter <dan.carpenter@linaro.org>
    dpaa2-switch: Fix error checking in dpaa2_switch_seed_bp()

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: fix truesize operations for PAGE_SIZE >= 8192

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: fix ICE_LAST_OFFSET formula

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: fix page reuse when PAGE_SIZE is over 8k

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

Simon Horman <horms@kernel.org>
    tc-testing: don't access non-existent variable on exception

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: serialize access to the injection/extraction groups

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix QoS class for injected packets with "ocelot-8021q"

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: use ocelot_xmit_get_vlan_info() also for FDMA and register injection

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SMP: Fix assumption of Central always being Initiator

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix LE quote calculation

Lang Yu <Lang.Yu@amd.com>
    drm/amdkfd: reserve the BO before validating it

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/tas2781: Use correct endian conversion

Maximilian Luz <luzmaximilian@gmail.com>
    platform/surface: aggregator: Fix warning when controller is destroyed in probe

David (Ming Qiang) Wu <David.Wu3@amd.com>
    drm/amd/amdgpu: command submission parser for JPEG

Melissa Wen <mwen@igalia.com>
    drm/amd/display: fix cursor offset on rotation 180

Loan Chen <lo-an.chen@amd.com>
    drm/amd/display: Enable otg synchronization logic for DCN321

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Adjust cursor position

Filipe Manana <fdmanana@suse.com>
    btrfs: send: allow cloning non-aligned extent if it ends at i_size

David Sterba <dsterba@suse.com>
    btrfs: replace sb::s_blocksize by fs_info::sectorsize

Hailong Liu <hailong.liu@oppo.com>
    mm/vmalloc: fix page mapping if vm_area_alloc_pages() with high order fallback to order 0

Suren Baghdasaryan <surenb@google.com>
    change alloc_pages name in dma_map_ops to avoid name conflicts

Muhammad Usama Anjum <usama.anjum@collabora.com>
    selftests: memfd_secret: don't build memfd_secret test on unsupported arches

Ryan Roberts <ryan.roberts@arm.com>
    selftests/mm: log run_vmtests.sh results in TAP format

Itaru Kitayama <itaru.kitayama@linux.dev>
    tools/testing/selftests/mm/run_vmtests.sh: lower the ptrace permissions

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    mm: fix endless reclaim on machines with unaccepted memory

Mikulas Patocka <mpatocka@redhat.com>
    dm suspend: return -ERESTARTSYS instead of -EINTR

Celeste Liu <coelacanthushex@gmail.com>
    riscv: entry: always initialize regs->a0 to -ENOSYS

Sean Nyekjaer <sean@geanix.com>
    i2c: stm32f7: Add atomic_xfer method to driver

Dave Kleikamp <dave.kleikamp@oracle.com>
    jfs: define xtree root and page independently

Eric Dumazet <edumazet@google.com>
    gtp: pull network headers in gtp_dev_xmit()

Keith Busch <kbusch@kernel.org>
    nvme: fix namespace removal list

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/skx_common: Allow decoding of SGX addresses

Shannon Nelson <shannon.nelson@amd.com>
    ionic: check cmd_regs before copying in or out

Shannon Nelson <shannon.nelson@amd.com>
    ionic: use pci_is_enabled not open code

Phil Chang <phil.chang@mediatek.com>
    hrtimer: Prevent queuing of hrtimer without a function callback

Jesse Zhang <jesse.zhang@amd.com>
    drm/amdgpu: fix dereference null return value for the function amdgpu_vm_pt_parent

Keith Busch <kbusch@kernel.org>
    nvme: use srcu for iterating namespace list

Jakub Sitnicki <jakub@cloudflare.com>
    Revert "bpf, sockmap: Prevent lock inversion deadlock in map delete elem"

Cupertino Miranda <cupertino.miranda@oracle.com>
    selftests/bpf: Fix a few tests for GCC related warnings.

Sagi Grimberg <sagi@grimberg.me>
    nvmet-rdma: fix possible bad dereference when freeing rsps

Baokun Li <libaokun1@huawei.com>
    ext4: set the type of max_zeroout to unsigned int to avoid overflow

Guanrui Huang <guanrui.huang@linux.alibaba.com>
    irqchip/gic-v3-its: Remove BUG_ON in its_vpe_irq_domain_alloc

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
    btrfs: send: handle unexpected inode in header process_recorded_refs()

David Sterba <dsterba@suse.com>
    btrfs: send: handle unexpected data in header buffer in begin_cmd()

David Sterba <dsterba@suse.com>
    btrfs: handle invalid root reference found in may_destroy_subvol()

David Sterba <dsterba@suse.com>
    btrfs: push errors up from add_async_extent()

David Sterba <dsterba@suse.com>
    btrfs: tests: allocate dummy fs_info and root in test_find_delalloc()

David Sterba <dsterba@suse.com>
    btrfs: change BUG_ON to assertion when checking for delayed_node root

David Sterba <dsterba@suse.com>
    btrfs: defrag: change BUG_ON to assertion in btrfs_defrag_leaves()

David Sterba <dsterba@suse.com>
    btrfs: delayed-inode: drop pointless BUG_ON in __btrfs_remove_delayed_item()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/boot: Only free if realloc() succeeds

Li zeming <zeming@nfschina.com>
    powerpc/boot: Handle allocation failure in simple_realloc()

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: stop checkpoint when get a out-of-bounds segment

David Howells <dhowells@redhat.com>
    rxrpc: Don't pick values out of the wire header when setting up security

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

Frederic Weisbecker <frederic@kernel.org>
    tick: Move got_idle_tick away from common flags

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clocksource/drivers/arm_global_timer: Guard against division by zero

Avri Kehat <akehat@habana.ai>
    accel/habanalabs: fix debugfs files permissions

Stefan Hajnoczi <stefanha@redhat.com>
    virtiofs: forbid newlines in tags

Costa Shulyupin <costa.shul@redhat.com>
    hrtimer: Select housekeeping CPU during migration

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: sysfs: extend the critical section for unregistering sysfs devices

Erico Nunes <nunes.erico@gmail.com>
    drm/lima: set gp bus_stop bit before hard reset

Kees Cook <keescook@chromium.org>
    net/sun3_82586: Avoid reading past buffer in debug output

Shaul Triebitz <shaul.triebitz@intel.com>
    wifi: iwlwifi: mvm: avoid garbage iPN

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

Clément Léger <cleger@rivosinc.com>
    riscv: blacklist assembly symbols for kprobe

Jan Kara <jack@suse.cz>
    quota: Remove BUG_ON from dqget()

Jeff Johnson <quic_jjohnson@quicinc.com>
    wifi: ath12k: Add missing qmi_txn_cancel() calls

Al Viro <viro@zeniv.linux.org.uk>
    fuse: fix UAF in rcu pathwalks

Al Viro <viro@zeniv.linux.org.uk>
    afs: fix __afs_break_callback() / afs_drop_open_mmap() race

Qu Wenruo <wqu@suse.com>
    btrfs: zlib: fix and simplify the inline extent decompression

Baokun Li <libaokun1@huawei.com>
    ext4: do not trim the group with corrupted block bitmap

Daniel Wagner <dwagner@suse.de>
    nvmet-trace: avoid dereferencing pointer too early

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/skx_common: Filter out the invalid address

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Refcounting fix in gfs2_thaw_super

Zijun Hu <quic_zijuhu@quicinc.com>
    Bluetooth: hci_conn: Check non NULL function before calling for HFP offload

Mimi Zohar <zohar@linux.ibm.com>
    evm: don't copy up 'security.evm' xattr

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop2: clear afbc en and transform bit for cluster window at linear mode

Shannon Nelson <shannon.nelson@amd.com>
    ionic: no fw read when PCI reset failed

Shannon Nelson <shannon.nelson@amd.com>
    ionic: prevent pci disable of already disabled device

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/papr-sysparm: Validate buffer object lengths

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

Nysal Jan K.A <nysal@linux.ibm.com>
    powerpc/topology: Check if a core is online

Nysal Jan K.A <nysal@linux.ibm.com>
    cpu/SMT: Enable SMT only if a core is online

Masahiro Yamada <masahiroy@kernel.org>
    rust: fix the default format for CONFIG_{RUSTC,BINDGEN}_VERSION_TEXT

Masahiro Yamada <masahiroy@kernel.org>
    rust: suppress error messages from CONFIG_{RUSTC,BINDGEN}_VERSION_TEXT

Miguel Ojeda <ojeda@kernel.org>
    rust: work around `bindgen` 0.69.0 issue

Antoniu Miclaus <antoniu.miclaus@analog.com>
    hwmon: (ltc2992) Avoid division by zero

Chengfeng Ye <dg573847474@gmail.com>
    IB/hfi1: Fix potential deadlock on &irq_src_lock and &dd->uctxt_lock

Gustavo A. R. Silva <gustavoars@kernel.org>
    clk: visconti: Add bounds-checking coverage for struct visconti_pll_provider

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: iwlwifi: check for kmemdup() return value in iwl_parse_tlv_firmware()

Mukesh Sisodiya <mukesh.sisodiya@intel.com>
    wifi: iwlwifi: fw: Fix debugfs command sending

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: abort scan when rfkill on but device enabled

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: setattr_chown: Add missing initialization

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: flush STA queues on unauthorization

Mike Christie <michael.christie@oracle.com>
    scsi: spi: Fix sshdr use

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: hda-dsp: Make sure that no irq handler is pending before suspend

Richard Acayan <mailingradian@gmail.com>
    iommu/arm-smmu-qcom: Add SDM670 MDSS compatible

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: qcom: venus: fix incorrect return value

Mikko Perttunen <mperttunen@nvidia.com>
    drm/tegra: Zero-initialize iosys_map

Christian Brauner <brauner@kernel.org>
    binfmt_misc: cleanup on filesystem umount

Yu Kuai <yukuai3@huawei.com>
    md/raid5-cache: use READ_ONCE/WRITE_ONCE for 'conf->log'

farah kassabri <fkassabri@habana.ai>
    accel/habanalabs: fix bug in timestamp interrupt handling

Tomer Tayar <ttayar@habana.ai>
    accel/habanalabs: export dma-buf only if size/offset multiples of PAGE_SIZE

Ofir Bitton <obitton@habana.ai>
    accel/habanalabs/gaudi2: unsecure tpc count registers

Chengfeng Ye <dg573847474@gmail.com>
    media: s5p-mfc: Fix potential deadlock on condlock

Jithu Joseph <jithu.joseph@intel.com>
    platform/x86/intel/ifs: Validate image size

Chengfeng Ye <dg573847474@gmail.com>
    staging: ks7010: disable bh on tx_dev_lock

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Validate hw_points_num before using it

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: gadget: uvc: cleanup request when not in correct state

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: fix race condition related to checking tx queue fill status

David Lechner <dlechner@baylibre.com>
    staging: iio: resolver: ad2s1210: fix use before initialization

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: ath11k: fix ath11k_mac_op_remain_on_channel() stack usage

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: radio-isa: use dev_name to fill in bus_info

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Move dma unmapping after TLB flush

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i3c: mipi-i3c-hci: Do not unmap region not mapped for transfer

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i3c: mipi-i3c-hci: Remove BUG() when Ring Abort request times out

Manish Dharanenthiran <quic_mdharane@quicinc.com>
    wifi: ath12k: fix WARN_ON during ath12k_mac_update_vif_chan

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

Yury Norov <yury.norov@gmail.com>
    sched/topology: Handle NUMA_NO_NODE in sched_numa_find_nth_cpu()

Lorenzo Bianconi <lorenzo@kernel.org>
    net: ethernet: mtk_wed: check update_wo_rx_stats in mtk_wed_update_rx_stats()

Paul E. McKenney <paulmck@kernel.org>
    rcu: Eliminate rcu_gp_slow_unregister() false positive

Zhen Lei <thunder.leizhen@huawei.com>
    rcu: Dump memory object info if callback function is invalid

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: fix recovery flow in CSA

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix BA session teardown race

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: check wiphy mutex is held for wdev mutex

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: lock wiphy in IP address notifier

Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>
    ASoC: cs35l45: Checks index of cs35l45_irqs[]

Rand Deeb <rand.sec96@gmail.com>
    ssb: Fix division by zero issue in ssb_calc_clock_rate

ZhenGuo Yin <zhenguo.yin@amd.com>
    drm/amdgpu: access RLC_SPM_MC_CNTL through MMIO in SRIOV runtime

Lee Jones <lee@kernel.org>
    drm/amd/amdgpu/imu_v11_0: Increase buffer size to ensure all possible values can be stored

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/pm: fix error flow in sensor fetching

Parsa Poorshikhian <parsa.poorsh@gmail.com>
    ALSA: hda/realtek: Fix noise from speakers on Lenovo IdeaPad 3 15IAU7

Asmaa Mnebhi <asmaa@nvidia.com>
    gpio: mlxbf3: Support shutdown() function

Jie Wang <wangjie125@huawei.com>
    net: hns3: fix a deadlock problem when config TC during resetting

Peiyang Wang <wangpeiyang1@huawei.com>
    net: hns3: use the user's cfg after reset

Jie Wang <wangjie125@huawei.com>
    net: hns3: fix wrong use of semaphore up

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: net: lib: kill PIDs before del netns

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: net: lib: ignore possible errors

Cong Wang <cong.wang@bytedance.com>
    vsock: fix recursive ->recvmsg calls

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

Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
    tcp: Update window clamping condition

Eugene Syromiatnikov <esyr@redhat.com>
    mptcp: correct MPTCP_SUBFLOW_ATTR_SSN_OFFSET reserved size

David Thompson <davthompson@nvidia.com>
    mlxbf_gige: disable RX filters until RX path initialized

Zheng Zhang <everything411@qq.com>
    net: ethernet: mtk_wed: fix use-after-free panic in mtk_wed_setup_tc_block_cb()

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
    igc: Fix reset adapter logics when tx mode change

Faizal Rahim <faizal.abdul.rahim@linux.intel.com>
    igc: Fix qbv_config_change_errors logics

Faizal Rahim <faizal.abdul.rahim@linux.intel.com>
    igc: Fix packet still tx after gate close by reducing i226 MAC retry buffer

Leon Hwang <leon.hwang@linux.dev>
    bpf: Fix updating attached freplace prog in prog_array map

Claudio Imbrenda <imbrenda@linux.ibm.com>
    s390/uv: Panic for set and remove shared access UVC errors

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/jpeg4: properly set atomics vmid field

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

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: reject BTRFS_FT_UNKNOWN dir type

Waiman Long <longman@redhat.com>
    mm/memory-failure: use raw_spinlock_t in struct memory_failure_cpu

Zhen Lei <thunder.leizhen@huawei.com>
    selinux: add the processing of the failure of avc_add_xperms_decision()

Zhen Lei <thunder.leizhen@huawei.com>
    selinux: fix potential counting error in avc_add_xperms_decision()

Max Kellermann <max.kellermann@ionos.com>
    fs/netfs/fscache_cookie: add missing "n_accesses" check

Janne Grunau <j@jannau.net>
    wifi: brcmfmac: cfg80211: Handle SSID based pmksa deletion

Long Li <longli@microsoft.com>
    net: mana: Fix doorbell out of order violation and avoid unnecessary doorbell rings

Haiyang Zhang <haiyangz@microsoft.com>
    net: mana: Fix RX buf alloc_size alignment and atomic op panic

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

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: Evaluate _REG outside the EC scope more carefully

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Add a depth argument to acpi_execute_reg_methods()

Breno Leitao <leitao@debian.org>
    i2c: tegra: Do not mark ACPI devices as irq safe

Nam Cao <namcao@linutronix.de>
    riscv: change XIP's kernel_map.size to be size of the entire kernel

Michael Mueller <mimu@linux.ibm.com>
    KVM: s390: fix validity interception issue when gisa is switched off

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix error recovery leading to data corruption on ESE devices

Baojun Xu <baojun.xu@ti.com>
    ALSA: hda/tas2781: fix wrong calibrated data order

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

Paul Moore <paul@paul-moore.com>
    selinux: revert our use of vma_is_initial_heap()

Xu Yang <xu.yang_2@nxp.com>
    Revert "usb: typec: tcpm: clear pd_event queue in PORT_RESET"

Griffin Kroah-Hartman <griffin@kroah.com>
    Revert "misc: fastrpc: Restrict untrusted app to attach to privileged PD"

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "ACPI: EC: Evaluate orphan _REG under EC device"

Mathieu Othacehe <othacehe@gnu.org>
    tty: atmel_serial: use the correct RTS flag.

Peng Fan <peng.fan@nxp.com>
    tty: serial: fsl_lpuart: mark last busy before uart_add_one_port


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-devices-system-cpu |   3 +-
 Makefile                                           |   4 +-
 arch/alpha/kernel/pci_iommu.c                      |   2 +-
 arch/arm64/kernel/acpi_numa.c                      |   2 +-
 arch/arm64/kernel/setup.c                          |   3 -
 arch/arm64/kernel/smp.c                            |   2 +
 arch/arm64/kvm/sys_regs.c                          |   6 +
 arch/arm64/kvm/vgic/vgic.h                         |   7 +
 arch/mips/jazz/jazzdma.c                           |   2 +-
 arch/mips/kernel/cpu-probe.c                       |   4 +
 arch/openrisc/kernel/setup.c                       |   6 +-
 arch/parisc/kernel/irq.c                           |   4 +-
 arch/powerpc/boot/simple_alloc.c                   |   7 +-
 arch/powerpc/include/asm/topology.h                |  13 ++
 arch/powerpc/kernel/dma-iommu.c                    |   2 +-
 arch/powerpc/platforms/ps3/system-bus.c            |   4 +-
 arch/powerpc/platforms/pseries/papr-sysparm.c      |  47 +++++
 arch/powerpc/platforms/pseries/vio.c               |   2 +-
 arch/powerpc/sysdev/xics/icp-native.c              |   2 +
 arch/riscv/include/asm/asm.h                       |  10 +
 arch/riscv/kernel/entry.S                          |   3 +
 arch/riscv/kernel/traps.c                          |   3 +-
 arch/riscv/mm/init.c                               |   4 +-
 arch/s390/include/asm/uv.h                         |   5 +-
 arch/s390/kernel/early.c                           |  12 +-
 arch/s390/kernel/smp.c                             |   4 +-
 arch/s390/kvm/kvm-s390.h                           |   7 +-
 arch/x86/kernel/amd_gart_64.c                      |   2 +-
 arch/x86/kernel/process.c                          |   5 +-
 block/blk-mq-tag.c                                 |   5 +-
 drivers/accel/habanalabs/common/debugfs.c          |  14 +-
 drivers/accel/habanalabs/common/irq.c              |   3 +
 drivers/accel/habanalabs/common/memory.c           |  15 +-
 drivers/accel/habanalabs/gaudi2/gaudi2_security.c  |   1 +
 drivers/acpi/acpica/acevents.h                     |   6 +-
 drivers/acpi/acpica/evregion.c                     |  12 +-
 drivers/acpi/acpica/evxfregn.c                     |  64 +-----
 drivers/acpi/ec.c                                  |  14 +-
 drivers/acpi/internal.h                            |   1 +
 drivers/acpi/scan.c                                |   2 +
 drivers/atm/idt77252.c                             |   9 +-
 drivers/char/xillybus/xillyusb.c                   |  42 +++-
 drivers/clk/visconti/pll.c                         |   6 +-
 drivers/clocksource/arm_global_timer.c             |  11 +-
 drivers/edac/skx_common.c                          |   4 +
 drivers/firmware/cirrus/cs_dsp.c                   |   7 +-
 drivers/gpio/gpio-mlxbf3.c                         |  14 ++
 drivers/gpio/gpiolib-sysfs.c                       |  15 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h         |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |  40 +++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c            |   8 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c         |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c            |  53 +++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c          |   6 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |  13 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |  13 +-
 drivers/gpu/drm/amd/amdgpu/imu_v11_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c           |  63 +++++-
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.h           |   6 +
 drivers/gpu/drm/amd/amdgpu/soc15d.h                |   6 +
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  24 ++-
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |   4 +-
 .../drm/amd/display/dc/dcn321/dcn321_resource.c    |   3 +
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |  14 +-
 drivers/gpu/drm/bridge/tc358768.c                  | 215 +++++++++++++++++---
 drivers/gpu/drm/lima/lima_gp.c                     |  12 ++
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |  96 ++++++---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.h        |  22 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys.h   |   9 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c   |  43 +---
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c   |  22 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c    |  21 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c            |   2 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.h            |  14 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c          |  23 ++-
 drivers/gpu/drm/msm/dp/dp_ctrl.c                   |   2 +
 drivers/gpu/drm/msm/dp/dp_panel.c                  |  19 +-
 drivers/gpu/drm/msm/msm_drv.h                      |  12 --
 drivers/gpu/drm/msm/msm_gem_shrinker.c             |   2 +-
 drivers/gpu/drm/msm/msm_mdss.c                     |  84 +++++---
 drivers/gpu/drm/msm/msm_mdss.h                     |   1 +
 drivers/gpu/drm/nouveau/nvkm/core/firmware.c       |   9 +-
 drivers/gpu/drm/nouveau/nvkm/falcon/fw.c           |   6 +
 drivers/gpu/drm/panel/panel-novatek-nt36523.c      |   6 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |   5 +
 drivers/gpu/drm/tegra/gem.c                        |   2 +-
 drivers/hid/wacom_wac.c                            |   4 +-
 drivers/hwmon/ltc2992.c                            |   8 +-
 drivers/hwmon/pc87360.c                            |   6 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |   4 +-
 drivers/i2c/busses/i2c-riic.c                      |   2 +-
 drivers/i2c/busses/i2c-stm32f7.c                   |  51 ++++-
 drivers/i2c/busses/i2c-tegra.c                     |   4 +-
 drivers/i3c/master/mipi-i3c-hci/dma.c              |   5 +-
 drivers/infiniband/hw/hfi1/chip.c                  |   5 +-
 drivers/infiniband/ulp/rtrs/rtrs.c                 |   2 +-
 drivers/input/input-mt.c                           |   3 +
 drivers/input/serio/i8042-acpipnpio.h              |  20 +-
 drivers/input/serio/i8042.c                        |  10 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |   1 +
 drivers/iommu/dma-iommu.c                          |   2 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   2 -
 drivers/irqchip/irq-renesas-rzg2l.c                |   5 +-
 drivers/md/dm-clone-metadata.c                     |   5 -
 drivers/md/dm-ioctl.c                              |  22 +-
 drivers/md/dm.c                                    |   4 +-
 drivers/md/md.c                                    |   5 -
 drivers/md/persistent-data/dm-space-map-metadata.c |   4 +-
 drivers/md/raid5-cache.c                           |  47 +++--
 drivers/media/dvb-core/dvb_frontend.c              |  12 +-
 drivers/media/pci/cx23885/cx23885-video.c          |   8 +
 drivers/media/platform/qcom/venus/pm_helpers.c     |   2 +-
 .../media/platform/samsung/s5p-mfc/s5p_mfc_enc.c   |   2 +-
 drivers/media/radio/radio-isa.c                    |   2 +-
 drivers/memory/stm32-fmc2-ebi.c                    | 122 +++++++----
 drivers/memory/tegra/tegra186.c                    |   3 +
 drivers/misc/fastrpc.c                             |  22 +-
 drivers/mmc/core/mmc_test.c                        |   9 +-
 drivers/mmc/host/dw_mmc.c                          |   8 +
 drivers/mmc/host/mtk-sd.c                          |   8 +-
 drivers/net/bonding/bond_main.c                    |  21 +-
 drivers/net/bonding/bond_options.c                 |   2 +-
 drivers/net/dsa/microchip/ksz_ptp.c                |   5 +-
 drivers/net/dsa/mv88e6xxx/global1_atu.c            |   3 +-
 drivers/net/dsa/ocelot/felix.c                     |  11 +
 drivers/net/dsa/vitesse-vsc73xx-core.c             |  69 +++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   5 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |   3 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |   7 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   3 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  28 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   7 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |   3 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   4 +-
 drivers/net/ethernet/i825xx/sun3_82586.c           |   2 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |  21 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |  47 +----
 drivers/net/ethernet/intel/igb/igb_main.c          |   1 +
 drivers/net/ethernet/intel/igc/igc_defines.h       |   6 +
 drivers/net/ethernet/intel/igc/igc_main.c          |   8 +-
 drivers/net/ethernet/intel/igc/igc_tsn.c           |  76 +++++--
 drivers/net/ethernet/intel/igc/igc_tsn.h           |   1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cpt.c    |  23 +--
 drivers/net/ethernet/mediatek/mtk_wed.c            |   6 +-
 drivers/net/ethernet/mediatek/mtk_wed_mcu.c        |   3 +
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |   2 +
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |   2 +-
 .../net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h  |   8 +
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c |  10 +
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h |   2 +
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c   |  50 ++++-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  28 ++-
 drivers/net/ethernet/mscc/ocelot.c                 |  91 ++++++++-
 drivers/net/ethernet/mscc/ocelot_fdma.c            |   3 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c         |   4 +
 .../net/ethernet/pensando/ionic/ionic_bus_pci.c    |   9 +-
 drivers/net/ethernet/pensando/ionic/ionic_dev.c    |  33 ++-
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |   7 +-
 drivers/net/ethernet/pensando/ionic/ionic_fw.c     |   5 +
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |   3 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c      |   6 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |  17 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  25 +--
 drivers/net/gtp.c                                  |   3 +
 drivers/net/wireless/ath/ath11k/mac.c              |  42 ++--
 drivers/net/wireless/ath/ath12k/mac.c              |  27 ++-
 drivers/net/wireless/ath/ath12k/qmi.c              |   7 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  13 +-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    |   6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   2 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |  50 ++++-
 drivers/net/wireless/mediatek/mt76/mt76.h          |  24 +--
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt792x_core.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/tx.c            | 108 ++++++++--
 drivers/net/wireless/st/cw1200/txrx.c              |   2 +-
 drivers/nvme/host/core.c                           | 107 ++++++----
 drivers/nvme/host/ioctl.c                          |  15 +-
 drivers/nvme/host/multipath.c                      |  21 +-
 drivers/nvme/host/nvme.h                           |   4 +-
 drivers/nvme/target/rdma.c                         |  16 +-
 drivers/nvme/target/tcp.c                          |   1 +
 drivers/nvme/target/trace.c                        |   6 +-
 drivers/nvme/target/trace.h                        |  28 ++-
 drivers/parisc/ccio-dma.c                          |   2 +-
 drivers/parisc/sba_iommu.c                         |   2 +-
 drivers/platform/surface/aggregator/controller.c   |   3 +-
 drivers/platform/x86/intel/ifs/load.c              |   9 +
 drivers/platform/x86/lg-laptop.c                   |   2 +-
 drivers/pmdomain/imx/imx93-pd.c                    |   5 +-
 drivers/pmdomain/imx/scu-pd.c                      |   5 -
 drivers/rtc/rtc-nct3018y.c                         |   6 +-
 drivers/s390/block/dasd.c                          |  36 ++--
 drivers/s390/block/dasd_3990_erp.c                 |  10 +-
 drivers/s390/block/dasd_diag.c                     |   1 -
 drivers/s390/block/dasd_eckd.c                     |  58 +++---
 drivers/s390/block/dasd_int.h                      |   2 +-
 drivers/s390/cio/idset.c                           |  12 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   2 +-
 drivers/scsi/scsi_transport_spi.c                  |   4 +-
 drivers/ssb/main.c                                 |   2 +-
 drivers/staging/iio/resolver/ad2s1210.c            |   7 +-
 drivers/staging/ks7010/ks7010_sdio.c               |   4 +-
 drivers/thunderbolt/switch.c                       |   1 +
 drivers/tty/serial/atmel_serial.c                  |   2 +-
 drivers/tty/serial/fsl_lpuart.c                    |   1 +
 drivers/usb/dwc3/core.c                            |  13 ++
 drivers/usb/gadget/udc/fsl_udc_core.c              |   2 +-
 drivers/usb/host/xhci.c                            |   8 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   1 -
 drivers/xen/grant-dma-ops.c                        |   2 +-
 drivers/xen/swiotlb-xen.c                          |   2 +-
 fs/afs/file.c                                      |   8 +-
 fs/binfmt_elf_fdpic.c                              |   2 +-
 fs/binfmt_misc.c                                   | 216 +++++++++++++++-----
 fs/btrfs/compression.c                             |  23 ++-
 fs/btrfs/compression.h                             |   2 +-
 fs/btrfs/defrag.c                                  |   2 +-
 fs/btrfs/delayed-inode.c                           |   4 +-
 fs/btrfs/disk-io.c                                 |   2 +
 fs/btrfs/extent_io.c                               |   4 +-
 fs/btrfs/free-space-cache.c                        |  22 +-
 fs/btrfs/inode.c                                   |  24 ++-
 fs/btrfs/ioctl.c                                   |   2 +-
 fs/btrfs/qgroup.c                                  |   2 -
 fs/btrfs/reflink.c                                 |   6 +-
 fs/btrfs/send.c                                    |  71 +++++--
 fs/btrfs/super.c                                   |   2 +-
 fs/btrfs/tests/extent-io-tests.c                   |  28 ++-
 fs/btrfs/tree-checker.c                            |  74 ++++++-
 fs/btrfs/zlib.c                                    |  73 ++-----
 fs/ext4/extents.c                                  |   3 +-
 fs/ext4/mballoc.c                                  |   3 +
 fs/f2fs/segment.c                                  |  17 +-
 fs/file.c                                          |  28 ++-
 fs/fscache/cookie.c                                |   4 +
 fs/fuse/cuse.c                                     |   3 +-
 fs/fuse/dev.c                                      |   6 +-
 fs/fuse/fuse_i.h                                   |   1 +
 fs/fuse/inode.c                                    |  15 +-
 fs/fuse/virtio_fs.c                                |  10 +
 fs/gfs2/inode.c                                    |   2 +-
 fs/gfs2/super.c                                    |   2 +
 fs/inode.c                                         |  39 +++-
 fs/jfs/jfs_dinode.h                                |   2 +-
 fs/jfs/jfs_imap.c                                  |   6 +-
 fs/jfs/jfs_incore.h                                |   2 +-
 fs/jfs/jfs_txnmgr.c                                |   4 +-
 fs/jfs/jfs_xtree.c                                 |   4 +-
 fs/jfs/jfs_xtree.h                                 |  37 ++--
 fs/kernfs/file.c                                   |   8 +-
 fs/nfs/pnfs.c                                      |   8 +
 fs/nfsd/nfssvc.c                                   |  14 +-
 fs/ntfs3/bitmap.c                                  |   4 +-
 fs/ntfs3/fsntfs.c                                  |   2 +-
 fs/ntfs3/index.c                                   |  11 +-
 fs/ntfs3/ntfs_fs.h                                 |   4 +-
 fs/ntfs3/super.c                                   |   2 +-
 fs/quota/dquot.c                                   |   5 +-
 fs/smb/client/reparse.c                            |  11 +-
 fs/smb/server/connection.c                         |  34 +++-
 fs/smb/server/connection.h                         |   3 +-
 fs/smb/server/mgmt/user_session.c                  |   8 +
 fs/smb/server/smb2pdu.c                            |   5 +-
 include/acpi/acpixf.h                              |   5 +-
 include/linux/bitmap.h                             |  20 +-
 include/linux/bpf_verifier.h                       |   4 +-
 include/linux/cpumask.h                            |   2 +-
 include/linux/dma-map-ops.h                        |   2 +-
 include/linux/dsa/ocelot.h                         |  47 +++++
 include/linux/evm.h                                |   6 +
 include/linux/f2fs_fs.h                            |   1 +
 include/linux/fs.h                                 |   5 +
 include/net/af_vsock.h                             |   4 +
 include/net/inet_timewait_sock.h                   |   2 +-
 include/net/kcm.h                                  |   1 +
 include/net/mana/mana.h                            |   1 +
 include/net/tcp.h                                  |   2 +-
 include/scsi/scsi_cmnd.h                           |   2 +-
 include/soc/mscc/ocelot.h                          |  12 +-
 include/uapi/misc/fastrpc.h                        |   3 -
 init/Kconfig                                       |   7 +-
 kernel/bpf/verifier.c                              |   5 +-
 kernel/cgroup/cgroup.c                             |   4 +-
 kernel/cpu.c                                       |  12 +-
 kernel/dma/mapping.c                               |   4 +-
 kernel/rcu/rcu.h                                   |   7 +
 kernel/rcu/srcutiny.c                              |   1 +
 kernel/rcu/srcutree.c                              |   1 +
 kernel/rcu/tasks.h                                 |   1 +
 kernel/rcu/tiny.c                                  |   1 +
 kernel/rcu/tree.c                                  |   3 +-
 kernel/sched/topology.c                            |   3 +
 kernel/time/clocksource.c                          |  42 ++--
 kernel/time/hrtimer.c                              |   5 +-
 kernel/time/tick-sched.h                           |   2 +-
 lib/cpumask.c                                      |   4 +-
 lib/math/prime_numbers.c                           |   2 -
 mm/huge_memory.c                                   |  30 ++-
 mm/memcontrol.c                                    |   7 +-
 mm/memory-failure.c                                |  20 +-
 mm/memory.c                                        |  33 ++-
 mm/page_alloc.c                                    |  42 ++--
 mm/vmalloc.c                                       |  11 +-
 net/bluetooth/bnep/core.c                          |   3 +-
 net/bluetooth/hci_conn.c                           |  11 +-
 net/bluetooth/hci_core.c                           |  19 +-
 net/bluetooth/mgmt.c                               |   4 +
 net/bluetooth/smp.c                                | 146 ++++++-------
 net/bridge/br_netfilter_hooks.c                    |   6 +-
 net/core/sock_map.c                                |   6 -
 net/dccp/ipv4.c                                    |   2 +-
 net/dccp/ipv6.c                                    |   6 -
 net/dsa/tag_ocelot.c                               |  37 +---
 net/ipv4/inet_timewait_sock.c                      |  16 +-
 net/ipv4/tcp_input.c                               |  28 ++-
 net/ipv4/tcp_ipv4.c                                |  16 +-
 net/ipv4/tcp_minisocks.c                           |   7 +-
 net/ipv4/udp_offload.c                             |   3 +-
 net/ipv6/ip6_output.c                              |  10 +
 net/ipv6/ip6_tunnel.c                              |  12 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |   4 +
 net/ipv6/tcp_ipv6.c                                |   6 -
 net/iucv/iucv.c                                    |   3 +-
 net/kcm/kcmsock.c                                  |   4 +
 net/mac80211/agg-tx.c                              |   6 +-
 net/mac80211/driver-ops.c                          |   3 -
 net/mac80211/iface.c                               |  14 ++
 net/mac80211/main.c                                |  22 +-
 net/mac80211/sta_info.c                            |  46 +++--
 net/mctp/test/route-test.c                         |   2 +-
 net/mptcp/diag.c                                   |   2 +-
 net/mptcp/pm.c                                     |  13 --
 net/mptcp/pm_netlink.c                             | 142 ++++++++-----
 net/mptcp/protocol.h                               |   3 -
 net/netfilter/nf_flow_table_inet.c                 |   3 +
 net/netfilter/nf_flow_table_ip.c                   |   3 +
 net/netfilter/nf_flow_table_offload.c              |   2 +-
 net/netfilter/nf_tables_api.c                      | 225 ++++++++++++---------
 net/netfilter/nfnetlink_queue.c                    |  35 +++-
 net/netfilter/nft_counter.c                        |   9 +-
 net/netlink/af_netlink.c                           |  13 +-
 net/openvswitch/datapath.c                         |   2 +-
 net/rxrpc/rxkad.c                                  |   8 +-
 net/sched/sch_netem.c                              |  47 +++--
 net/vmw_vsock/af_vsock.c                           |  50 +++--
 net/vmw_vsock/vsock_bpf.c                          |   4 +-
 net/wireless/core.h                                |   8 +-
 scripts/rust_is_available.sh                       |   6 +-
 security/integrity/evm/evm_main.c                  |   7 +
 security/security.c                                |   2 +-
 security/selinux/avc.c                             |   8 +-
 security/selinux/hooks.c                           |  12 +-
 sound/core/timer.c                                 |   2 +-
 sound/pci/hda/patch_realtek.c                      |   1 -
 sound/pci/hda/tas2781_hda_i2c.c                    |  14 +-
 sound/soc/codecs/cs35l45.c                         |   5 +-
 sound/soc/sof/intel/hda-dsp.c                      |   3 +
 sound/soc/sof/ipc4.c                               |   9 +-
 sound/usb/quirks-table.h                           |   1 +
 sound/usb/quirks.c                                 |   2 +
 tools/include/linux/bitmap.h                       |   7 +-
 .../testing/selftests/bpf/progs/cpumask_failure.c  |   3 -
 tools/testing/selftests/bpf/progs/dynptr_fail.c    |  12 +-
 tools/testing/selftests/bpf/progs/iters.c          |  54 +++++
 .../selftests/bpf/progs/jeq_infer_not_null_fail.c  |   4 +
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |  47 +++--
 tools/testing/selftests/core/close_range_test.c    |  35 ++++
 tools/testing/selftests/mm/Makefile                |   2 +
 tools/testing/selftests/mm/run_vmtests.sh          |  53 ++++-
 tools/testing/selftests/net/lib.sh                 |  11 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  28 ++-
 tools/testing/selftests/net/udpgro.sh              |  44 ++--
 tools/testing/selftests/tc-testing/tdc.py          |   1 -
 tools/tracing/rtla/src/osnoise_top.c               |  11 +-
 386 files changed, 3829 insertions(+), 1937 deletions(-)


