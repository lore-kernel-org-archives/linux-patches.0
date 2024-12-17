Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC991F76C3;
	Tue, 17 Dec 2024 17:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456314; cv=none; b=dW8hupEBKD2VidaQ4IhFnITxTD3XgPClNMq6/rlYsNpubdxzGvStBAzshN1n7uO5pL8QZTGhKLgoFlLaOcXxZAN6ZIKBWSEIVylnB1YTTa8UOEvVlTh1UjgWmgGYnkbJ9ogN2YrEjLICJZo3yHEbgz+4AqiZDqlycdm9uqD1KGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456314; c=relaxed/simple;
	bh=H2TqaZKbakjrcIq817y6a2BY9q4hrZI7VRfQz7zMPUE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sI3Jm5Bk2Slc7YASa01kW4wdRn6kVDPDnsLjyr2SBO4dMoHpfDCtP2T7Tq/gpUPVF4lMTN57uVAp+4nD6NWjxcXVfB7xNKLfRk8y900kChS7YSa6kqLqUwCL/vhcOS7F7zDaRBSduMT1CT57gWwaVs79qKweLJ0Bic3vS4yf1HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ImFZPdXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ImFZPdXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFD4C4CED3;
	Tue, 17 Dec 2024 17:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456313;
	bh=H2TqaZKbakjrcIq817y6a2BY9q4hrZI7VRfQz7zMPUE=;
	h=From:To:Cc:Subject:Date:From;
	b=ImFZPdXR0F/pYsTOshm7X3ysVw3O17+nxt+KwonzX5kWSvnOaoiioBAM+mCbpKETG
	 2p8GGb5e5lFe/7rT0+grj2RosXwEVi39XYflr/LLKxvADfmcN6c+4n8p/Q/jY2s4hL
	 OH3vVwbfTMjA6jqfU4+JAnMbm8G1yW3qu2pZrVe4=
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
Subject: [PATCH 6.12 000/172] 6.12.6-rc1 review
Date: Tue, 17 Dec 2024 18:05:56 +0100
Message-ID: <20241217170546.209657098@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.6-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.6-rc1
X-KernelTest-Deadline: 2024-12-19T17:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.6 release.
There are 172 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.6-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.6-rc1

Juergen Gross <jgross@suse.com>
    x86/xen: remove hypercall page

Juergen Gross <jgross@suse.com>
    x86/xen: use new hypercall functions instead of hypercall page

Juergen Gross <jgross@suse.com>
    x86/xen: add central hypercall functions

Juergen Gross <jgross@suse.com>
    x86/xen: don't do PV iret hypercall through hypercall page

Juergen Gross <jgross@suse.com>
    x86/static-call: provide a way to do very early static-call updates

Juergen Gross <jgross@suse.com>
    objtool/x86: allow syscall instruction

Juergen Gross <jgross@suse.com>
    x86: make get_cpu_vendor() accessible from Xen code

Juergen Gross <jgross@suse.com>
    xen/netfront: fix crash when removing device

James Morse <james.morse@arm.com>
    KVM: arm64: Disable MPAM visibility by default and ignore VMM writes

Miguel Ojeda <ojeda@kernel.org>
    rust: kbuild: set `bindgen`'s Rust target version

Nilay Shroff <nilay@linux.ibm.com>
    block: Fix potential deadlock while freezing queue and acquiring sysfs_lock

Ming Lei <ming.lei@redhat.com>
    blk-mq: move cpuhp callback registering out of q->sysfs_lock

Weizhao Ouyang <o451686892@gmail.com>
    kselftest/arm64: abi: fix SVCR detection

Nathan Chancellor <nathan@kernel.org>
    blk-iocost: Avoid using clamp() on inuse in __propagate_weights()

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/xe/reg_sr: Remove register pool

Mirsad Todorovac <mtodorovac69@gmail.com>
    drm/xe: fix the ERR_PTR() returned on failure to allocate tiny pt

Robert Hodaszi <robert.hodaszi@digi.com>
    net: dsa: tag_ocelot_8021q: fix broken reception

Jesse Van Gavere <jesseevg@gmail.com>
    net: dsa: microchip: KSZ9896 register regmap alignment to 32 bit boundaries

Nikita Yushchenko <nikita.yoush@cogentembedded.com>
    net: renesas: rswitch: fix initial MPIC register setting

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    Bluetooth: btmtk: avoid UAF in btmtk_process_coredump

Iulia Tanasescu <iulia.tanasescu@nxp.com>
    Bluetooth: iso: Fix circular lock in iso_conn_big_sync

Iulia Tanasescu <iulia.tanasescu@nxp.com>
    Bluetooth: iso: Fix circular lock in iso_listen_bis

Frédéric Danis <frederic.danis@collabora.com>
    Bluetooth: SCO: Add support for 16 bits transparent voice setting

Iulia Tanasescu <iulia.tanasescu@nxp.com>
    Bluetooth: iso: Fix recursive locking warning

Iulia Tanasescu <iulia.tanasescu@nxp.com>
    Bluetooth: iso: Always release hdev at the end of iso_listen_bis

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Fix using rcu_read_(un)lock while iterating

Daniil Tatianin <d-tatianin@yandex-team.ru>
    ACPICA: events/evxfregn: don't release the ContextMutex that was never acquired

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: Intel: sof_sdw: Add space for a terminator into DAIs array

Daniel Borkmann <daniel@iogearbox.net>
    team: Fix feature propagation of NETIF_F_GSO_ENCAP_ALL

Daniel Borkmann <daniel@iogearbox.net>
    team: Fix initial vlan_feature set in __team_compute_features

Daniel Borkmann <daniel@iogearbox.net>
    bonding: Fix feature propagation of NETIF_F_GSO_ENCAP_ALL

Daniel Borkmann <daniel@iogearbox.net>
    bonding: Fix initial {vlan,mpls}_feature set in bond_compute_features

Daniel Borkmann <daniel@iogearbox.net>
    net, team, bonding: Add netdev_base_features helper

Martin Ottens <martin.ottens@fau.de>
    net/sched: netem: account for backlog updates from child qdisc

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: fix stuck CPU-injected packets with short taprio windows

Maxim Levitsky <mlevitsk@redhat.com>
    net: mana: Fix irq_contexts memory leak in mana_gd_setup_irqs

Maxim Levitsky <mlevitsk@redhat.com>
    net: mana: Fix memory leak in mana_gd_setup_irqs

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: do not defer rule destruction via call_rcu

Phil Sutter <phil@nwl.cc>
    netfilter: IDLETIMER: Fix for possible ABBA deadlock

Phil Sutter <phil@nwl.cc>
    selftests: netfilter: Stabilize rpath.sh

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_spdif: change IFACE_PCM to IFACE_MIXER

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_xcvr: change IFACE_PCM to IFACE_MIXER

James Clark <james.clark@linaro.org>
    libperf: evlist: Fix --cpu argument on hybrid platform

Michal Luczaj <mhal@rbox.co>
    Bluetooth: Improve setsockopt() handling of malformed user input

Shenghao Ding <shenghao-ding@ti.com>
    ASoC: tas2781: Fix calibration issue in stress test

Nikita Yushchenko <nikita.yoush@cogentembedded.com>
    net: renesas: rswitch: handle stop vs interrupt race

Nikita Yushchenko <nikita.yoush@cogentembedded.com>
    net: renesas: rswitch: avoid use-after-put for a device tree node

Nikita Yushchenko <nikita.yoush@cogentembedded.com>
    net: renesas: rswitch: fix leaked pointer on error path

Nikita Yushchenko <nikita.yoush@cogentembedded.com>
    net: renesas: rswitch: fix race window between tx start and complete

Nikita Yushchenko <nikita.yoush@cogentembedded.com>
    net: renesas: rswitch: fix possible early skb release

David Howells <dhowells@redhat.com>
    cifs: Fix rmdir failure due to ongoing I/O on deleted file

Petr Machata <petrm@nvidia.com>
    Documentation: networking: Add a caveat to nexthop_compat_mode sysctl

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix aggregation ID mask to prevent oops on 5760X chips

LongPing Wei <weilongping@oppo.com>
    block: get wp_offset by bdev_offset_from_zone_start

Paul Barker <paul.barker.ct@bp.renesas.com>
    Documentation: PM: Clarify pm_runtime_resume_and_get() return value

Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
    ASoC: amd: yc: Fix the wrong return value

Takashi Iwai <tiwai@suse.de>
    ALSA: control: Avoid WARN() for symlink errors

Stefan Wahren <wahrenst@gmx.net>
    qca_spi: Make driver probing reliable

Stefan Wahren <wahrenst@gmx.net>
    qca_spi: Fix clock speed for multiple QCA7000

Anumula Murali Mohan Reddy <anumula@chelsio.com>
    cxgb4: use port number to set mac addr

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    ACPI: resource: Fix memory resource type union access

Daniel Machon <daniel.machon@microchip.com>
    net: sparx5: fix the maximum frame length register

Daniel Machon <daniel.machon@microchip.com>
    net: sparx5: fix FDMA performance issue

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    spi: aspeed: Fix an error handling path in aspeed_spi_[read|write]_user()

Philippe Simons <simons.philippe@gmail.com>
    regulator: axp20x: AXP717: set ramp_delay

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: perform error cleanup in ocelot_hwstamp_set()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: be resilient to loss of PTP packets during transmission

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: ocelot->ts_id_lock and ocelot_port->tx_skbs.lock are IRQ-safe

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: improve handling of TX timestamp for unknown skb

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix memory leak on ocelot_port_add_txtstamp_skb()

Eric Dumazet <edumazet@google.com>
    net: defer final 'struct net' free in netns dismantle

Eric Dumazet <edumazet@google.com>
    net: lapb: increase LAPB_HEADER_LEN

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix GSO type for HW GRO packets on 5750X chips

Thomas Weißschuh <linux@weissschuh.net>
    ptp: kvm: x86: Return EOPNOTSUPP instead of ENODEV from kvm_arch_ptp_init()

Danielle Ratson <danieller@nvidia.com>
    selftests: mlxsw: sharedbuffer: Ensure no extra packets are counted

Danielle Ratson <danieller@nvidia.com>
    selftests: mlxsw: sharedbuffer: Remove duplicate test cases

Danielle Ratson <danieller@nvidia.com>
    selftests: mlxsw: sharedbuffer: Remove h1 ingress test case

Haoyu Li <lihaoyu499@gmail.com>
    wifi: cfg80211: sme: init n_channels before channels[] access

Dan Carpenter <dan.carpenter@linaro.org>
    net/mlx5: DR, prevent potential error pointer dereference

Eric Dumazet <edumazet@google.com>
    tipc: fix NULL deref in cleanup_bearer()

Remi Pommarel <repk@triplefau.lt>
    batman-adv: Do not let TT changes list grows indefinitely

Remi Pommarel <repk@triplefau.lt>
    batman-adv: Remove uninitialized data in full table TT response

Remi Pommarel <repk@triplefau.lt>
    batman-adv: Do not send uninitialized TT changes

David (Ming Qiang) Wu <David.Wu3@amd.com>
    amdgpu/uvd: get ring reference from rq scheduler

Suraj Sonawane <surajsonawane0215@gmail.com>
    acpi: nfit: vmalloc-out-of-bounds Read in acpi_nfit_ctl

Arnaldo Carvalho de Melo <acme@kernel.org>
    perf machine: Initialize machine->env to address a segfault

Benjamin Lin <benjamin-jw.lin@mediatek.com>
    wifi: mac80211: fix station NSS capability initialization order

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: mac80211: fix a queue stall in certain cases of CSA

Haoyu Li <lihaoyu499@gmail.com>
    wifi: mac80211: init cnt before accessing elem in ieee80211_copy_mbssid_beacon

Lin Ma <linma@zju.edu.cn>
    wifi: nl80211: fix NL80211_ATTR_MLO_LINK_ID off-by-one

Namhyung Kim <namhyung@kernel.org>
    perf tools: Fix build-id event recording

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Augment raw_tp arguments with PTR_MAYBE_NULL

Michal Luczaj <mhal@rbox.co>
    bpf, sockmap: Fix update element with same

Michal Luczaj <mhal@rbox.co>
    bpf, sockmap: Fix race between element replace and close()

Jiri Olsa <jolsa@kernel.org>
    bpf,perf: Fix invalid prog_array access in perf_event_detach_bpf_prog

Jann Horn <jannh@google.com>
    bpf: Fix theoretical prog_array UAF in __uprobe_perf_func()

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Check size for BTF-based ctx access of pointer members

Darrick J. Wong <djwong@kernel.org>
    xfs: unlock inodes when erroring out of xfs_trans_alloc_dir

Darrick J. Wong <djwong@kernel.org>
    xfs: only run precommits once per transaction object

Darrick J. Wong <djwong@kernel.org>
    xfs: fix scrub tracepoints when inode-rooted btrees are involved

Darrick J. Wong <djwong@kernel.org>
    xfs: return from xfs_symlink_verify early on V4 filesystems

Darrick J. Wong <djwong@kernel.org>
    xfs: fix null bno_hint handling in xfs_rtallocate_rtg

Darrick J. Wong <djwong@kernel.org>
    xfs: return a 64-bit block count from xfs_btree_count_blocks

Darrick J. Wong <djwong@kernel.org>
    xfs: don't drop errno values when we fail to ficlone the entire range

Darrick J. Wong <djwong@kernel.org>
    xfs: update btree keys correctly when _insrec splits an inode root block

Darrick J. Wong <djwong@kernel.org>
    xfs: set XFS_SICK_INO_SYMLINK_ZAPPED explicitly when zapping a symlink

Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
    drm/amdkfd: hard-code MALL cacheline size for gfx11, gfx12

Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
    drm/amdkfd: hard-code cacheline size for gfx11

Andrew Martin <Andrew.Martin@amd.com>
    drm/amdkfd: Dereference null return value

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix when the cleaner shader is emitted

Kenneth Feng <kenneth.feng@amd.com>
    drm/amd/pm: Set SMU v13.0.7 default workload type

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix UVD contiguous CS mapping problem

Eugene Kobyak <eugene.kobyak@intel.com>
    drm/i915: Fix NULL pointer dereference in capture_engine

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/color: Stop using non-posted DSB writes for legacy LUT

Jiasheng Jiang <jiashengjiangcool@outlook.com>
    drm/i915: Fix memory leak by correcting cache object name in error handler

Jesse.zhang@amd.com <Jesse.zhang@amd.com>
    drm/amdkfd: pause autosuspend when creating pdd

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/xe: Call invalidation_fence_fini for PT inval fences in error state

Yi Liu <yi.l.liu@intel.com>
    iommu/vt-d: Fix qi_batch NULL pointer with nested parent domain

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Remove cache tags before disabling ATS

Luis Claudio R. Goncalves <lgoncalv@redhat.com>
    iommu/tegra241-cmdqv: do not use smp_processor_id in preemptible context

Neal Frager <neal.frager@amd.com>
    usb: dwc3: xilinx: make sure pipe clock is deselected in usb2 only mode

Łukasz Bartosik <ukaszb@chromium.org>
    usb: typec: ucsi: Fix completion notifications

Lianqin Hu <hulianqin@vivo.com>
    usb: gadget: u_serial: Fix the issue that gs_start_io crashed due to accessing null pointer

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    usb: typec: anx7411: fix OF node reference leaks in anx7411_typec_switch_probe()

Xu Yang <xu.yang_2@nxp.com>
    usb: dwc3: imx8mp: fix software node kernel dump

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    usb: typec: anx7411: fix fwnode_handle reference leak

Vitalii Mordan <mordan@ispras.ru>
    usb: ehci-hcd: fix call balance of clocks handling routines

Takashi Iwai <tiwai@suse.de>
    usb: gadget: midi2: Fix interpretation of is_midi1 bits

liuderong <liuderong@oppo.com>
    scsi: ufs: core: Update compl_time_stamp_local_clock after completing a cqe

Stefan Wahren <wahrenst@gmx.net>
    usb: dwc2: Fix HCD port connection race

Stefan Wahren <wahrenst@gmx.net>
    usb: dwc2: hcd: Fix GetPortStatus & SetPortFeature

Stefan Wahren <wahrenst@gmx.net>
    usb: dwc2: Fix HCD resume

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    ata: sata_highbank: fix OF node reference leak in highbank_initialize_phys()

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Revert "bpf: Mark raw_tp arguments with PTR_MAYBE_NULL"

Xu Yang <xu.yang_2@nxp.com>
    usb: core: hcd: only check primary hcd skip_phy_initialization

Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
    gpio: graniterapids: Check if GPIO line can be used for IRQs

Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
    gpio: graniterapids: Determine if GPIO pad can be used by driver

Shankar Bandal <shankar.bandal@intel.com>
    gpio: graniterapids: Fix invalid RXEVCFG register bitmask

Shankar Bandal <shankar.bandal@intel.com>
    gpio: graniterapids: Fix invalid GPI_IS register offset

Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
    gpio: graniterapids: Fix incorrect BAR assignment

Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
    gpio: graniterapids: Fix vGPIO driver crash

Damien Le Moal <dlemoal@kernel.org>
    block: Ignore REQ_NOWAIT for zone reset and zone finish operations

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    usb: host: max3421-hcd: Correctly abort a USB request.

Miguel Ojeda <ojeda@kernel.org>
    drm/panic: remove spurious empty line to clean warning

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon/debugfs - fix the struct pointer incorrectly offset problem

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Fix IPIs usage in kfence_protect_page()

Hridesh MG <hridesh699@gmail.com>
    ALSA: hda/realtek: Fix headset mic on Acer Nitro 5

Jaakko Salo <jaakkos@gmail.com>
    ALSA: usb-audio: Add implicit feedback quirk for Yamaha THR5

Haoyu Li <lihaoyu499@gmail.com>
    gpio: ljca: Initialize num before accessing item in ljca_gpio_config

Christian Loehle <christian.loehle@arm.com>
    spi: rockchip: Fix PM runtime count on no-op cs

Shakeel Butt <shakeel.butt@linux.dev>
    memcg: slub: fix SUnreclaim for post charged objects

Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
    gpio: graniterapids: Fix GPIO Ack functionality

Damien Le Moal <dlemoal@kernel.org>
    block: Prevent potential deadlocks in zone write plug error recovery

Damien Le Moal <dlemoal@kernel.org>
    dm: Fix dm-zoned-reclaim zone write pointer alignment

Damien Le Moal <dlemoal@kernel.org>
    block: Use a zone write plug BIO work for REQ_NOWAIT BIOs

Damien Le Moal <dlemoal@kernel.org>
    block: Switch to using refcount_t for zone write plugs

Tejun Heo <tj@kernel.org>
    blk-cgroup: Fix UAF in blkcg_unpin_online()

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Fix wrong usage of __pa() on a fixmap address

Björn Töpel <bjorn@rivosinc.com>
    riscv: mm: Do not call pmd dtor on vmemmap page table teardown

Koichiro Den <koichiro.den@canonical.com>
    virtio_net: ensure netdev_tx_reset_queue is called on tx ring resize

Koichiro Den <koichiro.den@canonical.com>
    virtio_ring: add a func argument 'recycle_done' to virtqueue_resize()

Koichiro Den <koichiro.den@canonical.com>
    virtio_net: correct netdev_tx_reset_queue() invocation point

Kuan-Wei Chiu <visitorckw@gmail.com>
    perf ftrace: Fix undefined behavior in cmp_profile_data()

MoYuanhao <moyuanhao3676@163.com>
    tcp: check space before adding MPTCP SYN options

Frederik Deweerdt <deweerdt.lkml@gmail.com>
    splice: do not checksum AF_UNIX sockets

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix racy issue from session lookup and expire

Christian Marangi <ansuelsmth@gmail.com>
    clk: en7523: Fix wrong BUS clock for EN7581

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/ds: Unconditionally drain PEBS DS when changing PEBS_DATA_CFG

Juri Lelli <juri.lelli@redhat.com>
    sched/deadline: Fix replenish_dl_new_period dl_server condition

Jann Horn <jannh@google.com>
    bpf: Fix UAF via mismatching bpf_prog/attachment RCU flavors

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Check if TX data was written to device in .tx_empty()

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    usb: misc: onboard_usb_dev: skip suspend/resume sequence for USB5744 SMBus support


-------------

Diffstat:

 Documentation/networking/ip-sysctl.rst             |   6 +
 Documentation/power/runtime_pm.rst                 |   4 +-
 Makefile                                           |   4 +-
 arch/arm64/kvm/sys_regs.c                          |  55 ++-
 arch/riscv/include/asm/kfence.h                    |   4 +-
 arch/riscv/kernel/setup.c                          |   2 +-
 arch/riscv/mm/init.c                               |   7 +-
 arch/x86/events/intel/ds.c                         |   2 +-
 arch/x86/include/asm/processor.h                   |   2 +
 arch/x86/include/asm/static_call.h                 |  15 +
 arch/x86/include/asm/sync_core.h                   |   6 +-
 arch/x86/include/asm/xen/hypercall.h               |  36 +-
 arch/x86/kernel/callthunks.c                       |   5 -
 arch/x86/kernel/cpu/common.c                       |  38 +-
 arch/x86/kernel/static_call.c                      |   9 +
 arch/x86/xen/enlighten.c                           |  64 ++-
 arch/x86/xen/enlighten_hvm.c                       |  13 +-
 arch/x86/xen/enlighten_pv.c                        |   4 +-
 arch/x86/xen/enlighten_pvh.c                       |   7 -
 arch/x86/xen/xen-asm.S                             |  50 +-
 arch/x86/xen/xen-head.S                            | 106 ++++-
 arch/x86/xen/xen-ops.h                             |   9 +
 block/blk-cgroup.c                                 |   6 +-
 block/blk-iocost.c                                 |   9 +-
 block/blk-mq-sysfs.c                               |  16 +-
 block/blk-mq.c                                     | 127 ++++-
 block/blk-sysfs.c                                  |   4 +-
 block/blk-zoned.c                                  | 526 +++++++++------------
 drivers/acpi/acpica/evxfregn.c                     |   2 -
 drivers/acpi/nfit/core.c                           |   7 +-
 drivers/acpi/resource.c                            |   6 +-
 drivers/ata/sata_highbank.c                        |   1 +
 drivers/bluetooth/btmtk.c                          |  20 +-
 drivers/clk/clk-en7523.c                           |   5 +-
 drivers/crypto/hisilicon/debugfs.c                 |   4 +-
 drivers/gpio/gpio-graniterapids.c                  |  52 +-
 drivers/gpio/gpio-ljca.c                           |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |  17 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c            |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  13 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c              |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c              |  24 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  15 +
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |  23 +-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |  12 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |   1 +
 drivers/gpu/drm/drm_panic_qr.rs                    |   1 -
 drivers/gpu/drm/i915/display/intel_color.c         |  30 +-
 drivers/gpu/drm/i915/i915_gpu_error.c              |  18 +-
 drivers/gpu/drm/i915/i915_scheduler.c              |   2 +-
 drivers/gpu/drm/xe/tests/xe_migrate.c              |   4 +-
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c        |   8 +
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h        |   1 +
 drivers/gpu/drm/xe/xe_pt.c                         |   3 +-
 drivers/gpu/drm/xe/xe_reg_sr.c                     |  31 +-
 drivers/gpu/drm/xe/xe_reg_sr_types.h               |   6 -
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c     |   2 +-
 drivers/iommu/intel/cache.c                        |  34 +-
 drivers/iommu/intel/iommu.c                        |   4 +-
 drivers/md/dm-zoned-reclaim.c                      |   6 +-
 drivers/net/bonding/bond_main.c                    |  10 +-
 drivers/net/dsa/microchip/ksz_common.c             |  42 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |  17 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  14 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   9 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |   5 +-
 .../mellanox/mlx5/core/steering/dr_domain.c        |   4 +-
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |  11 +-
 .../net/ethernet/microchip/sparx5/sparx5_port.c    |   2 +-
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |   6 +-
 drivers/net/ethernet/mscc/ocelot_ptp.c             | 207 ++++----
 drivers/net/ethernet/qualcomm/qca_spi.c            |  26 +-
 drivers/net/ethernet/qualcomm/qca_spi.h            |   1 -
 drivers/net/ethernet/renesas/rswitch.c             |  95 ++--
 drivers/net/ethernet/renesas/rswitch.h             |  14 +-
 drivers/net/team/team_core.c                       |  11 +-
 drivers/net/virtio_net.c                           |  24 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   2 +-
 drivers/net/xen-netfront.c                         |   5 +-
 drivers/ptp/ptp_kvm_x86.c                          |   6 +-
 drivers/regulator/axp20x-regulator.c               |  36 +-
 drivers/spi/spi-aspeed-smc.c                       |  10 +-
 drivers/spi/spi-rockchip.c                         |  14 +
 drivers/tty/serial/sh-sci.c                        |  29 ++
 drivers/ufs/core/ufshcd.c                          |   1 +
 drivers/usb/core/hcd.c                             |   8 +-
 drivers/usb/dwc2/hcd.c                             |  19 +-
 drivers/usb/dwc3/dwc3-imx8mp.c                     |  30 +-
 drivers/usb/dwc3/dwc3-xilinx.c                     |   5 +-
 drivers/usb/gadget/function/f_midi2.c              |   6 +-
 drivers/usb/gadget/function/u_serial.c             |   9 +-
 drivers/usb/host/ehci-sh.c                         |   9 +-
 drivers/usb/host/max3421-hcd.c                     |  16 +-
 drivers/usb/misc/onboard_usb_dev.c                 |   4 +-
 drivers/usb/typec/anx7411.c                        |  66 ++-
 drivers/usb/typec/ucsi/ucsi.c                      |   6 +-
 drivers/virtio/virtio_ring.c                       |   6 +-
 fs/smb/client/inode.c                              |   5 +-
 fs/smb/server/auth.c                               |   2 +
 fs/smb/server/mgmt/user_session.c                  |   6 +-
 fs/smb/server/server.c                             |   4 +-
 fs/smb/server/smb2pdu.c                            |  27 +-
 fs/xfs/libxfs/xfs_btree.c                          |  33 +-
 fs/xfs/libxfs/xfs_btree.h                          |   2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c                   |   4 +-
 fs/xfs/libxfs/xfs_symlink_remote.c                 |   4 +-
 fs/xfs/scrub/agheader.c                            |   6 +-
 fs/xfs/scrub/agheader_repair.c                     |   6 +-
 fs/xfs/scrub/fscounters.c                          |   2 +-
 fs/xfs/scrub/ialloc.c                              |   4 +-
 fs/xfs/scrub/refcount.c                            |   2 +-
 fs/xfs/scrub/symlink_repair.c                      |   3 +-
 fs/xfs/scrub/trace.h                               |   2 +-
 fs/xfs/xfs_bmap_util.c                             |   2 +-
 fs/xfs/xfs_file.c                                  |   8 +
 fs/xfs/xfs_rtalloc.c                               |   2 +-
 fs/xfs/xfs_trans.c                                 |  19 +-
 include/linux/blkdev.h                             |   5 +-
 include/linux/bpf.h                                |  19 +-
 include/linux/compiler.h                           |  39 +-
 include/linux/dsa/ocelot.h                         |   1 +
 include/linux/netdev_features.h                    |   7 +
 include/linux/static_call.h                        |   1 +
 include/linux/virtio.h                             |   3 +-
 include/net/bluetooth/bluetooth.h                  |  10 +-
 include/net/lapb.h                                 |   2 +-
 include/net/mac80211.h                             |   4 +-
 include/net/net_namespace.h                        |   1 +
 include/net/netfilter/nf_tables.h                  |   4 -
 include/soc/mscc/ocelot.h                          |   2 -
 kernel/bpf/btf.c                                   | 149 +++++-
 kernel/bpf/verifier.c                              |  79 +---
 kernel/sched/deadline.c                            |   2 +-
 kernel/static_call_inline.c                        |   2 +-
 kernel/trace/bpf_trace.c                           |  11 +
 kernel/trace/trace_uprobe.c                        |   6 +-
 mm/slub.c                                          |  21 +-
 net/batman-adv/translation-table.c                 |  58 ++-
 net/bluetooth/hci_event.c                          |  33 +-
 net/bluetooth/hci_sock.c                           |  14 +-
 net/bluetooth/iso.c                                |  71 ++-
 net/bluetooth/l2cap_sock.c                         |  20 +-
 net/bluetooth/rfcomm/sock.c                        |   9 +-
 net/bluetooth/sco.c                                |  40 +-
 net/core/net_namespace.c                           |  20 +-
 net/core/sock_map.c                                |   6 +-
 net/dsa/tag_ocelot_8021q.c                         |   2 +-
 net/ipv4/tcp_output.c                              |   6 +-
 net/mac80211/cfg.c                                 |   9 +-
 net/mac80211/ieee80211_i.h                         |  49 +-
 net/mac80211/iface.c                               |  12 +-
 net/mac80211/mlme.c                                |   2 -
 net/mac80211/util.c                                |  23 +-
 net/netfilter/nf_tables_api.c                      |  32 +-
 net/netfilter/xt_IDLETIMER.c                       |  52 +-
 net/sched/sch_netem.c                              |  22 +-
 net/tipc/udp_media.c                               |   7 +-
 net/unix/af_unix.c                                 |   1 +
 net/wireless/nl80211.c                             |   2 +-
 net/wireless/sme.c                                 |   1 +
 rust/Makefile                                      |  15 +-
 sound/core/control_led.c                           |  14 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/amd/yc/acp6x-mach.c                      |  13 +-
 sound/soc/codecs/tas2781-i2c.c                     |   2 +-
 sound/soc/fsl/fsl_spdif.c                          |   2 +-
 sound/soc/fsl/fsl_xcvr.c                           |   2 +-
 sound/soc/intel/boards/sof_sdw.c                   |   8 +-
 sound/usb/quirks.c                                 |   2 +
 tools/lib/perf/evlist.c                            |  18 +-
 tools/objtool/check.c                              |   9 +-
 tools/perf/builtin-ftrace.c                        |   3 +-
 tools/perf/util/build-id.c                         |   4 +-
 tools/perf/util/machine.c                          |   2 +
 .../testing/selftests/arm64/abi/syscall-abi-asm.S  |  32 +-
 .../selftests/bpf/progs/test_tp_btf_nullable.c     |   6 +-
 .../selftests/bpf/progs/verifier_btf_ctx_access.c  |   4 +-
 .../testing/selftests/bpf/progs/verifier_d_path.c  |   4 +-
 .../selftests/drivers/net/mlxsw/sharedbuffer.sh    |  55 ++-
 tools/testing/selftests/net/netfilter/rpath.sh     |  18 +-
 182 files changed, 2200 insertions(+), 1299 deletions(-)


