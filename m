Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F542236F4;
	Mon,  2 Jun 2025 14:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875121; cv=none; b=GVFT1CBNl7D0ayV2HNK49HDeu3nZ/ka8Hs5Ww7nI4KXX2K++nqK45EThoVoI6xGnl89qJnlXMUJxpJp5H4Obm1BQ5qYrwTsa25ItiJ5zQXWz3Y2u1PDU+RC/mzTZ8uIOaB9mGRkLyPaI9Ldq0BUQlSbldqYqkje3cP7N4lLgJTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875121; c=relaxed/simple;
	bh=XMDVy4OM1HBuZl/F+/2m8DKerpBG/X1bQwETccJUqLg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DqeRBti7kJxA6rvT4fNhsCX3K2ebnPlGCWVhA3cntXW3tQG/kZv3SgVHbpCWvlyZMNGkJy6SvmJeZsCI0kWUtesp2vQApQmNNNNVXC0MjcCcjoFva6VQXGVixtsm8ip62UELqBCB6g+zOVkAPflEgszvXNHfbjoaK/nVxDW6KjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eiRfCd0V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eiRfCd0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A323C4CEEB;
	Mon,  2 Jun 2025 14:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875120;
	bh=XMDVy4OM1HBuZl/F+/2m8DKerpBG/X1bQwETccJUqLg=;
	h=From:To:Cc:Subject:Date:From;
	b=eiRfCd0VQ9wKpA8fsd3d2eVxiKKi4YTRVUIJ9quvkXvMgOvoFSmBRz4x04I79lPF0
	 B2KHEKrcyFQoz5rpVWShZ6ahG0FJmNtH/VnCt9vxchNza4cMlsVAqxDAQevjGmR/z3
	 yV/61brei/5rwc6azd3jHpWvefb0g/6Z0k9q70VI=
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
Subject: [PATCH 5.10 000/270] 5.10.238-rc1 review
Date: Mon,  2 Jun 2025 15:44:45 +0200
Message-ID: <20250602134307.195171844@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.238-rc1
X-KernelTest-Deadline: 2025-06-04T13:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.238 release.
There are 270 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.238-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.238-rc1

Robin Murphy <robin.murphy@arm.com>
    perf/arm-cmn: Initialise cmn->cpu earlier

Juergen Gross <jgross@suse.com>
    xen/swiotlb: relax alignment requirements

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: thinkpad_acpi: Ignore battery threshold change event notification

Valtteri Koskivuori <vkoskiv@gmail.com>
    platform/x86: fujitsu-laptop: Support Lifebook S2110 hotkeys

Michal Suchanek <msuchanek@suse.de>
    tpm: tis: Double the timeout B to 4s

Alessandro Grassi <alessandro.grassi@mailbox.org>
    spi: spi-sun4i: fix early activation

Masahiro Yamada <masahiroy@kernel.org>
    um: let 'make clean' properly clean underlying SUBARCH as well

John Chau <johnchau@0atlas.com>
    platform/x86: thinkpad_acpi: Support also NEC Lavie X1475JAS

Jeff Layton <jlayton@kernel.org>
    nfs: don't share pNFS DS connections between net namespaces

Milton Barrera <miltonjosue2001@gmail.com>
    HID: quirks: Add ADATA XPG alpha wireless mouse support

Christian Brauner <brauner@kernel.org>
    coredump: hand a pidfd to the usermode coredump helper

Christian Brauner <brauner@kernel.org>
    fork: use pidfd_prepare()

Christian Brauner <brauner@kernel.org>
    pid: add pidfd_prepare()

Christian Brauner <brauner@kernel.org>
    coredump: fix error handling for replace_fd()

Pedro Tammela <pctammela@mojatatu.com>
    net_sched: hfsc: Address reentrant enqueue adding class to eltree twice

Wang Zhaolong <wangzhaolong1@huawei.com>
    smb: client: Reset all search buffer pointers when releasing buffer

Wang Zhaolong <wangzhaolong1@huawei.com>
    smb: client: Fix use-after-free in cifs_fill_dirent

Jani Nikula <jani.nikula@intel.com>
    drm/i915/gvt: fix unterminated-string-initialization warning

Nathan Chancellor <nathan@kernel.org>
    kbuild: Disable -Wdefault-const-init-unsafe

Larisa Grigore <larisa.grigore@nxp.com>
    spi: spi-fsl-dspi: Reset SR flags before sending a new message

Bogdan-Gabriel Roman <bogdan-gabriel.roman@nxp.com>
    spi: spi-fsl-dspi: Halt the module after a new message transfer

Larisa Grigore <larisa.grigore@nxp.com>
    spi: spi-fsl-dspi: restrict register range for regmap access

Tianyang Zhang <zhangtianyang@loongson.cn>
    mm/page_alloc.c: avoid infinite retries caused by cpuset race

Breno Leitao <leitao@debian.org>
    memcg: always call cond_resched() after fn()

feijuan.li <feijuan.li@samsung.com>
    drm/edid: fixed the bug that hdr metadata was not reset

Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
    llc: fix data loss when reading from a socket in llc_ui_recvmsg()

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix race of buffer access at PCM OSS layer

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: add missing rcu read protection for procfs content

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: add locking for bcm_op runtime updates

Dominik Grzegorzek <dominik.grzegorzek@oracle.com>
    padata: do not leak refcount in reorder_work

Ivan Pravdin <ipravdin.official@gmail.com>
    crypto: algif_hash - fix double free in hash_accept

Wang Liang <wangliang74@huawei.com>
    net/tipc: fix slab-use-after-free Read in tipc_aead_encrypt_done

Cong Wang <xiyou.wangcong@gmail.com>
    sch_hfsc: Fix qlen accounting bug when using peek in hfsc_enqueue()

Paul Kocialkowski <paulk@sys-base.io>
    net: dwmac-sun8i: Use parsed internal PHY address instead of 1

Ido Schimmel <idosch@nvidia.com>
    bridge: netfilter: Fix forwarding of fragmented packets

Paul Chaignon <paul.chaignon@gmail.com>
    xfrm: Sanitize marks before insert

Al Viro <viro@zeniv.linux.org.uk>
    __legitimize_mnt(): check for MNT_SYNC_UMOUNT should be under mount_lock

Jason Andryuk <jason.andryuk@amd.com>
    xenbus: Allow PVH dom0 a non-local xenstore

Goldwyn Rodrigues <rgoldwyn@suse.de>
    btrfs: correct the order of prelim_ref arguments in btrfs__prelim_ref

Alistair Francis <alistair.francis@wdc.com>
    nvmet-tcp: don't restore null sk_state_change

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Add quirk for HP Spectre x360 15-df1xxx

Takashi Iwai <tiwai@suse.de>
    ASoC: Intel: bytcr_rt5640: Add DMI quirk for Acer Aspire SW3-013

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    pinctrl: meson: define the pull up/down resistor value as 60 kOhm

Jessica Zhang <quic_jesszhan@quicinc.com>
    drm: Add valid clones check

Simona Vetter <simona.vetter@ffwll.ch>
    drm/atomic: clarify the rules around drm_atomic_state->allow_modeset

Isaac Scott <isaac.scott@ideasonboard.com>
    regulator: ad5398: Add device tree support

Sean Anderson <sean.anderson@linux.dev>
    spi: zynqmp-gqspi: Always acknowledge interrupts

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Don't use static local variable in rtw8822b_set_tx_power_index_by_rate

Ravi Bangoria <ravi.bangoria@amd.com>
    perf/amd/ibs: Fix perf_ibs_op.cnt_mask for CurCnt

Viktor Malik <vmalik@redhat.com>
    bpftool: Fix readlink usage in get_fd_type

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: Find VBIOS mode from regular display size

junan <junan76@163.com>
    HID: usbkbd: Fix the bit shift number for LED_KANA

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: st: Restore some drive settings after reset

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Handle duplicate D_IDs in ndlp search-by D_ID routine

Ankur Arora <ankur.a.arora@oracle.com>
    rcu: fix header guard for rcu_all_qs()

Ankur Arora <ankur.a.arora@oracle.com>
    rcu: handle quiescent states for PREEMPT_RCU=n, PREEMPT_COUNT=y

Ido Schimmel <idosch@nvidia.com>
    vxlan: Annotate FDB data races

Andrey Vatoropin <a.vatoropin@crpt.ru>
    hwmon: (xgene-hwmon) use appropriate type for the latency value

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Fix download_firmware_validate() for RTL8814AU

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: fib_rules: Fetch net from fib_rule in fib[46]_rule_configure().

William Tu <witu@nvidia.com>
    net/mlx5e: reduce rep rxq depth to 256 for ECPF

William Tu <witu@nvidia.com>
    net/mlx5e: set the tx_queue_len for pfifo_fast

Alexei Lazar <alazar@nvidia.com>
    net/mlx5: Extend Ethtool loopback selftest to support non-linear SKB

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Initial psr_version with correct setting

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    phy: core: don't require set_mode() callback for phy_get_mode() to work

Kees Cook <kees@kernel.org>
    net/mlx4_core: Avoid impossible mlx4_db_alloc() order value

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l: Memset argument to 0 before calling get_mbus_config pad op

Konstantin Andreev <andreev@swemel.ru>
    smack: recognize ipv4 CIPSO w/o categories

Valentin Caron <valentin.caron@foss.st.com>
    pinctrl: devicetree: do not goto err when probing hogs in pinctrl_dt_to_map

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-dai: check return value at snd_soc_dai_set_tdm_slot()

Hector Martin <marcan@marcan.st>
    ASoC: tas2764: Power up/down amp on mute ops

Martin Povišer <povik+lin@cutebit.org>
    ASoC: ops: Enforce platform maximum on initial value

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5: Apply rate-limiting to high temperature warning

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5: Modify LSB bitmask in temperature event to include only the first bit

Xiaofei Tan <tanxiaofei@huawei.com>
    ACPI: HED: Always initialize before evged

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Fix old_size lower bound in calculate_iosize() too

Jakub Kicinski <kuba@kernel.org>
    eth: mlx4: don't try to complete XDP frames in netpoll

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    can: c_can: Use of_property_present() to test existence of DT property

Arnd Bergmann <arnd@arndb.de>
    EDAC/ie31200: work around false positive build warning

Peter Seiderer <ps.report@gmx.net>
    net: pktgen: fix access outside of user given buffer in pktgen_thread_write()

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Fix rtw_desc_to_mcsrate() to handle MCS16-31

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Fix rtw_init_ht_cap() for RTL8814AU

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Fix rtw_init_vht_cap() for RTL8814AU

Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
    scsi: mpt3sas: Send a diag reset if target reset fails

Paul Burton <paulburton@kernel.org>
    clocksource: mips-gic-timer: Enable counter when CPUs start

Paul Burton <paulburton@kernel.org>
    MIPS: pm-cps: Use per-CPU variables as per-CPU, not per-core

Bibo Mao <maobibo@loongson.cn>
    MIPS: Use arch specific syscall name match function

Nandakumar Edamana <nandakumar@nandakumar.co.in>
    libbpf: Fix out-of-bound read

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: menu: Avoid discarding useful information

Waiman Long <longman@redhat.com>
    x86/nmi: Add an emergency handler in nmi_desc & use it in nmi_shootdown_cpus()

Andrew Davis <afd@ti.com>
    soc: ti: k3-socinfo: Do not use syscon helper to build regmap

Hangbin Liu <liuhangbin@gmail.com>
    bonding: report duplicate MAC address in all situations

Arnd Bergmann <arnd@arndb.de>
    net: xgene-v2: remove incorrect ACPI_PTR annotation

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: KFD release_work possible circular locking

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Avoid report two health errors on same syndrome

Stanimir Varbanov <svarbanov@suse.de>
    PCI: brcmstb: Add a softdep to MIP MSI-X driver

Stanimir Varbanov <svarbanov@suse.de>
    PCI: brcmstb: Expand inbound window size up to 64GB

Kuhanh Murugasen Krishnan <kuhanh.murugasen.krishnan@intel.com>
    fpga: altera-cvp: Increase credit timeout

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: mtk_dpi: Add checks for reg_h_fre_con existence

Alexander Stein <alexander.stein@ew.tq-group.com>
    hwmon: (gpio-fan) Add missing mutex locks

Breno Leitao <leitao@debian.org>
    x86/bugs: Make spectre user default depend on MITIGATION_SPECTRE_V2

Ahmad Fatoum <a.fatoum@pengutronix.de>
    clk: imx8mp: inform CCF of maximum frequency of clocks

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv4: fib: Move fib_valid_key_len() to rtm_to_fib_config().

Peter Seiderer <ps.report@gmx.net>
    net: pktgen: fix mpls maximum labels list parsing

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    net: ethernet: ti: cpsw_new: populate netdev of_node

Artur Weber <aweber.kernel@gmail.com>
    pinctrl: bcm281xx: Use "unsigned int" instead of bare "unsigned"

Hans Verkuil <hverkuil@xs4all.nl>
    media: cx231xx: set device_caps for 417

Victor Lu <victorchengchi.lu@amd.com>
    drm/amdgpu: Do not program AGP BAR regs under SRIOV in gfxhub_v1_0.c

Matthew Wilcox (Oracle) <willy@infradead.org>
    orangefs: Do not truncate file size

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: prevent BUG_ON by blocking retries on failed device resumes

Markus Elfring <elfring@users.sourceforge.net>
    media: c8sectpfe: Call of_node_put(i2c_bus) only once in c8sectpfe_probe()

Svyatoslav Ryhel <clamor95@gmail.com>
    ARM: tegra: Switch DSI-B clock parent to PLLD on Tegra114

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ieee802154: ca8210: Use proper setters and getters for bitwise types

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: ds1307: stop disabling alarms on probe

Eric Dumazet <edumazet@google.com>
    tcp: bring back NUMA dispersion in inet_ehash_locks_alloc()

Andreas Schwab <schwab@linux-m68k.org>
    powerpc/prom_init: Fixup missing #size-cells on PowerBook6,7

Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
    arm64: tegra: p2597: Fix gpio for vdd-1v8-dis regulator

Willem de Bruijn <willemb@google.com>
    ipv6: save dontfrag in cork

Erick Shepherd <erick.shepherd@ni.com>
    mmc: sdhci: Disable SD card clock before changing parameters

Ryan Roberts <ryan.roberts@arm.com>
    arm64/mm: Check PUD_TYPE_TABLE in pud_bad()

Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
    netfilter: conntrack: Bound nf_conntrack sysctl writes

Eric Dumazet <edumazet@google.com>
    posix-timers: Add cond_resched() to posix_timer_add() search loop

Frediano Ziglio <frediano.ziglio@cloud.com>
    xen: Add support for XenServer 6.1 platform device

Mikulas Patocka <mpatocka@redhat.com>
    dm: restrict dm device size to 2^63-512 bytes

Seyediman Seyedarab <imandevel@gmail.com>
    kbuild: fix argument parsing in scripts/config

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: rv3032: fix EERD location

Ilpo Järvinen <ij@kernel.org>
    tcp: reorganize tcp_in_ack_event() and tcp_count_delivered()

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: st: ERASE does not change tape location

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: st: Tighten the page format heuristics with MODE SELECT

Christian Göttsche <cgzones@googlemail.com>
    ext4: reorder capability check last

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Update min_low_pfn to match changes in uml_reserved

Benjamin Berg <benjamin@sipsolutions.net>
    um: Store full CSGSFS and SS register from mcontext

Nick Hu <nick.hu@sifive.com>
    clocksource/drivers/timer-riscv: Stop stimecmp when cpu hotplug

Filipe Manana <fdmanana@suse.com>
    btrfs: send: return -ENAMETOOLONG when attempting a path that is too long

Mark Harmstone <maharmstone@fb.com>
    btrfs: avoid linker error in btrfs_find_create_tree_block()

Vitalii Mordan <mordan@ispras.ru>
    i2c: pxa: fix call balance of i2c->clk handling routines

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    i2c: qup: Vote for interconnect bandwidth to DRAM

Erick Shepherd <erick.shepherd@ni.com>
    mmc: host: Wait for Vdd to settle on card power off

Robert Richter <rrichter@amd.com>
    libnvdimm/labels: Fix divide error in nd_label_data_init()

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS/flexfiles: Report ENETDOWN as a connection error

Ian Rogers <irogers@google.com>
    tools/build: Don't pass test log files to linker

Jing Su <jingsusu@didiglobal.com>
    dql: Fix dql->limit value when reset.

Alice Guo <alice.guo@nxp.com>
    thermal/drivers/qoriq: Power down TMU on system suspend

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: rpcbind should never reset the port to the value '0'

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: rpc_clnt_set_transport() must not change the autobind setting

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Treat ENETUNREACH errors as fatal for state recovery

Zsolt Kajtar <soci@c64.rulez.org>
    fbdev: core: tileblit: Implement missing margin clearing for tileblit

Zsolt Kajtar <soci@c64.rulez.org>
    fbcon: Use correct erase colour for clearing in fbcon

Shixiong Ou <oushixiong@kylinos.cn>
    fbdev: fsl-diu-fb: add missing device_remove_file()

Tudor Ambarus <tudor.ambarus@linaro.org>
    mailbox: use error ret code of of_parse_phandle_with_args()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Check for delegation validity in nfs_start_delegation_return_locked()

Daniel Gomez <da.gomez@samsung.com>
    kconfig: merge_config: use an empty file as initfile

gaoxu <gaoxu2@honor.com>
    cgroup: Fix compilation issue due to cgroup_mutex not being exported

Marek Szyprowski <m.szyprowski@samsung.com>
    dma-mapping: avoid potential unused data compilation warning

Dmitry Bogdanov <d.bogdanov@yadro.com>
    scsi: target: iscsi: Fix timeout on deleted connection

Alexander Lobakin <alexandr.lobakin@intel.com>
    ice: arfs: fix use-after-free when freeing @rx_cpu_rmap

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: do not defer rule destruction via call_rcu

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: wait for rcu grace period on net_device removal

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx

Filipe Manana <fdmanana@suse.com>
    btrfs: don't BUG_ON() when 0 reference count at btrfs_lookup_extent_info()

Feng Tang <feng.tang@linux.alibaba.com>
    selftests/mm: compaction_test: support platform with huge mount of memory

GONG Ruiqi <gongruiqi1@huawei.com>
    usb: typec: fix pm usage counter imbalance in ucsi_ccg_sync_control()

Dan Carpenter <dan.carpenter@linaro.org>
    usb: typec: fix potential array underflow in ucsi_ccg_sync_control()

RD Babiera <rdbabiera@google.com>
    usb: typec: altmodes/displayport: create sysfs nodes as driver's default device attribute group

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: Fix a deadlock in dma buf fence polling

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    ASoC: q6afe-clocks: fix reprobing of the driver

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    clocksource/i8253: Use raw_spinlock_irqsave() in clockevent_i8253_disable()

Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
    dmaengine: ti: k3-udma: Use cap_mask directly from dma_device structure instead of a local copy

Ronald Wahl <ronald.wahl@legrand.com>
    dmaengine: ti: k3-udma: Add missing locking

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: mt76: disable napi on driver removal

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    phy: renesas: rcar-gen3-usb2: Set timing registers only once

Ma Ke <make24@iscas.ac.cn>
    phy: Fix error handling in tegra_xusb_port_init

Steven Rostedt <rostedt@goodmis.org>
    tracing: samples: Initialize trace_array_printk() with the correct function

Wentao Liang <vulab@iscas.ac.cn>
    ALSA: es1968: Add error handling for snd_pcm_hw_constraint_pow2()

Jeremy Linton <jeremy.linton@arm.com>
    ACPI: PPTT: Fix processor subtable walk

Nathan Lynch <nathan.lynch@amd.com>
    dmaengine: Revert "dmaengine: dmatest: Fix dmatest waiting less when interrupted"

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pnfs: Reset the layout state after a layoutreturn

Abdun Nihaal <abdun.nihaal@gmail.com>
    qlcnic: fix memory leak in qlcnic_sriov_channel_cfg_cmd()

Geert Uytterhoeven <geert+renesas@glider.be>
    ALSA: sh: SND_AICA should depend on SH_DMA_API

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: discard incoming frames in BR_STATE_LISTENING

Mathieu Othacehe <othacehe@gnu.org>
    net: cadence: macb: Fix a possible deadlock in macb_halt_tx.

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: Flush gso_skb list too during ->change()

Geert Uytterhoeven <geert+renesas@glider.be>
    spi: loopback-test: Do not split 1024-byte hexdumps

Li Lingfeng <lilingfeng3@huawei.com>
    nfs: handle failure of nfs_get_lock_context in unlock path

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix slab-use-after-free Read in rxe_queue_cleanup bug

David Lechner <dlechner@baylibre.com>
    iio: chemical: sps30: use aligned_s64 for timestamp

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7768-1: Fix insufficient alignment of timestamp.

Hans de Goede <hdegoede@redhat.com>
    platform/x86: asus-wmi: Fix wlan_ctrl_by_user detection

Al Viro <viro@zeniv.linux.org.uk>
    do_umount(): add missing barrier before refcount checks in sync case

Daniel Wagner <wagi@kernel.org>
    nvme: unblock ctrl state transition for firmware update

Kevin Baker <kevinb@ventureresearch.com>
    drm/panel: simple: Update timings for AUO G101EVN010

Thorsten Blum <thorsten.blum@linux.dev>
    MIPS: Fix MAX_REG_OFFSET

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: dln2: Use aligned_s64 for timestamp

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    types: Complement the aligned types with signed 64-bit one

Dave Penkler <dpenkler@gmail.com>
    usb: usbtmc: Fix erroneous generic_read ioctl return

Dave Penkler <dpenkler@gmail.com>
    usb: usbtmc: Fix erroneous wait_srq ioctl return

Dave Penkler <dpenkler@gmail.com>
    usb: usbtmc: Fix erroneous get_stb ioctl error returns

Oliver Neukum <oneukum@suse.com>
    USB: usbtmc: use interruptible sleep in usbtmc_read

Andrei Kuchynski <akuchynski@chromium.org>
    usb: typec: ucsi: displayport: Fix NULL pointer access

RD Babiera <rdbabiera@google.com>
    usb: typec: tcpm: delay SNK_TRY_WAIT_DEBOUNCE to SRC_TRYWAIT transition

Jim Lin <jilin@nvidia.com>
    usb: host: tegra: Prevent host controller crash when OTG port is used

Wayne Chang <waynec@nvidia.com>
    usb: gadget: tegra-xudc: ACK ST_RC after clearing CTRL_RUN

Jan Kara <jack@suse.cz>
    ocfs2: stop quota recovery before disabling quotas

Jan Kara <jack@suse.cz>
    ocfs2: implement handshaking with ocfs2 recovery thread

Jan Kara <jack@suse.cz>
    ocfs2: switch osb->disable_recovery to enum

Dmitry Antipov <dmantipov@yandex.ru>
    module: ensure that kobject_put() is safe for module type kobjects

Jason Andryuk <jason.andryuk@amd.com>
    xenbus: Use kref to track req lifetime

Alexey Charkov <alchark@gmail.com>
    usb: uhci-platform: Make the clock really optional

Silvano Seva <s.seva@4sigma.it>
    iio: imu: st_lsm6dsx: fix possible lockup in st_lsm6dsx_read_tagged_fifo

Silvano Seva <s.seva@4sigma.it>
    iio: imu: st_lsm6dsx: fix possible lockup in st_lsm6dsx_read_fifo

Gabriel Shahrouzi <gshahrouzi@gmail.com>
    iio: adis16201: Correct inclinometer channel resolution

Angelo Dureghello <adureghello@baylibre.com>
    iio: adc: ad7606: fix serial register access

Gabriel Shahrouzi <gshahrouzi@gmail.com>
    staging: axis-fifo: Correct handling of tx_fifo_depth for size validation

Gabriel Shahrouzi <gshahrouzi@gmail.com>
    staging: axis-fifo: Remove hardware resets for user errors

Gabriel Shahrouzi <gshahrouzi@gmail.com>
    staging: iio: adc: ad7816: Correct conditional logic for store mode

Aditya Garg <gargaditya08@live.com>
    Input: synaptics - enable InterTouch on TUXEDO InfinityBook Pro 14 v5

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics - enable SMBus for HP Elitebook 850 G1

Aditya Garg <gargaditya08@live.com>
    Input: synaptics - enable InterTouch on Dell Precision M3800

Aditya Garg <gargaditya08@live.com>
    Input: synaptics - enable InterTouch on Dynabook Portege X30L-G

Manuel Fombuena <fombuena@outlook.com>
    Input: synaptics - enable InterTouch on Dynabook Portege X30-D

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix learning on VLAN unaware bridges

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix VLAN ID for untagged vlan on bridge leave

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: allow leaky reserved multicast

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: fix region locking in hash types

Oliver Hartkopp <socketcan@hartkopp.net>
    can: gw: fix RCU/BH usage in cgw_create_job()

Uladzislau Rezki (Sony) <urezki@gmail.com>
    rcu/kvfree: Add kvfree_rcu_mightsleep() and kfree_rcu_mightsleep()

Eric Dumazet <edumazet@google.com>
    can: gw: use call_rcu() instead of costly synchronize_rcu()

Eelco Chaudron <echaudro@redhat.com>
    openvswitch: Fix unsafe attribute parsing in output_userspace()

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: mcp251xfd_remove(): fix order of unregistration calls

Mike Christie <michael.christie@oracle.com>
    scsi: target: Fix WRITE_SAME No Data Buffer crash

Tudor Ambarus <tudor.ambarus@linaro.org>
    dm: fix copying after src array boundaries

Fedor Pchelkin <pchelkin@ispras.ru>
    usb: chipidea: ci_hdrc_imx: implement usb_phy_init() error handling

Alexander Stein <alexander.stein@ew.tq-group.com>
    usb: chipidea: ci_hdrc_imx: use dev_err_probe()

Suzuki K Poulose <suzuki.poulose@arm.com>
    irqchip/gic-v2m: Prevent use after free of gicv2m_get_fwnode()

Thomas Gleixner <tglx@linutronix.de>
    irqchip/gic-v2m: Mark a few functions __init

Xiang wangx <wangxiang@cdjrlc.com>
    irqchip/gic-v2m: Add const to of_device_id

Christian Hewitt <christianshewitt@gmail.com>
    Revert "drm/meson: vclk: fix calculation of 59.94 fractional rates"

Fiona Klute <fiona.klute@gmx.de>
    net: phy: microchip: force IRQ polling mode for lan88xx

Ioana Ciornei <ioana.ciornei@nxp.com>
    net: phy: microchip: remove the use of .ack_interrupt()

Ioana Ciornei <ioana.ciornei@nxp.com>
    net: phy: microchip: implement generic .handle_interrupt() callback

Sergey Shtylyov <s.shtylyov@omp.ru>
    of: module: add buffer overflow check in of_modalias()

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: imx6: Skip controller_id generation logic for i.MX7D

Mattias Barthel <mattias.barthel@atlascopco.com>
    net: fec: ERR007885 Workaround for conventional TX

Thangaraj Samynathan <thangaraj.s@microchip.com>
    net: lan743x: Fix memleak issue when GSO enabled

Michael Liang <mliang@purestorage.com>
    nvme-tcp: fix premature queue removal and I/O failover

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix ethtool -d byte order for 32-bit values

Felix Fietkau <nbd@nbd.name>
    net: ipv6: fix UDPv6 GSO segmentation with NAT

Simon Horman <horms@kernel.org>
    net: dlink: Correct endianness handling of led_mode

Victor Nogueira <victor@mojatatu.com>
    net_sched: qfq: Fix double list add in class with netem as child qdisc

Victor Nogueira <victor@mojatatu.com>
    net_sched: ets: Fix double list add in class with netem as child qdisc

Victor Nogueira <victor@mojatatu.com>
    net_sched: hfsc: Fix a UAF vulnerability in class with netem as child qdisc

Victor Nogueira <victor@mojatatu.com>
    net_sched: drr: Fix double list add in class with netem as child qdisc

Chris Mi <cmi@nvidia.com>
    net/mlx5: E-switch, Fix error handling for enabling roce

Wenpeng Liang <liangwenpeng@huawei.com>
    net/mlx5: Remove return statement exist at the end of void function

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: E-Switch, Initialize MAC Address for Default GID

Jakub Kicinski <kuba@kernel.org>
    net/sched: act_mirred: don't override retval if we already lost the skb

Jeongjun Park <aha310510@gmail.com>
    tracing: Fix oob write in trace_seq_to_buffer()

Mingcong Bai <jeffbai@aosc.io>
    iommu/vt-d: Apply quirk_iommu_igfx for 8086:0044 (QM57/QS57)

Pavel Paklov <Pavel.Paklov@cyberprotect.ru>
    iommu/amd: Fix potential buffer overflow in parse_ivrs_acpihid

Benjamin Marzinski <bmarzins@redhat.com>
    dm: always update the array size in realloc_argv on success

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: fix a warning on invalid table line

Wentao Liang <vulab@iscas.ac.cn>
    wifi: brcm80211: fmac: Add error handling for brcmf_usb_dl_writeimage()

Ruslan Piasetskyi <ruslan.piasetskyi@gmail.com>
    mmc: renesas_sdhi: Fix error handling in renesas_sdhi_probe

Vishal Badole <Vishal.Badole@amd.com>
    amd-xgbe: Fix to ensure dependent features are toggled with RX checksum offload

Helge Deller <deller@gmx.de>
    parisc: Fix double SIGFPE crash

Clark Wang <xiaoning.wang@nxp.com>
    i2c: imx-lpi2c: Fix clock count when probe defers

Niravkumar L Rabara <niravkumar.l.rabara@altera.com>
    EDAC/altera: Set DDR and SDMMC interrupt mask before registration

Niravkumar L Rabara <niravkumar.l.rabara@altera.com>
    EDAC/altera: Test the correct error reg offset

Philipp Stanner <phasta@kernel.org>
    drm/nouveau: Fix WARN_ON in nouveau_fence_context_kill()

Joachim Priesner <joachim.priesner@web.de>
    ALSA: usb-audio: Add second USB ID for Jabra Evolve 65 headset


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   2 +
 Makefile                                           |  16 +-
 arch/arm/boot/dts/tegra114.dtsi                    |   2 +-
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi     |   2 +-
 arch/arm64/include/asm/pgtable.h                   |   3 +-
 arch/mips/include/asm/ftrace.h                     |  16 ++
 arch/mips/include/asm/ptrace.h                     |   3 +-
 arch/mips/kernel/pm-cps.c                          |  30 +--
 arch/parisc/math-emu/driver.c                      |  16 +-
 arch/powerpc/kernel/prom_init.c                    |   4 +-
 arch/um/Makefile                                   |   1 +
 arch/um/kernel/mem.c                               |   1 +
 arch/x86/events/amd/ibs.c                          |   3 +-
 arch/x86/include/asm/nmi.h                         |   2 +
 arch/x86/include/asm/perf_event.h                  |   1 +
 arch/x86/kernel/cpu/bugs.c                         |  10 +-
 arch/x86/kernel/nmi.c                              |  42 +++++
 arch/x86/kernel/reboot.c                           |  10 +-
 arch/x86/um/os-Linux/mcontext.c                    |   3 +-
 crypto/algif_hash.c                                |   4 -
 drivers/acpi/Kconfig                               |   2 +-
 drivers/acpi/hed.c                                 |   7 +-
 drivers/acpi/pptt.c                                |  11 +-
 drivers/char/tpm/tpm_tis_core.h                    |   2 +-
 drivers/clk/imx/clk-imx8mp.c                       | 151 +++++++++++++++
 drivers/clocksource/i8253.c                        |   6 +-
 drivers/clocksource/mips-gic-timer.c               |   6 +-
 drivers/clocksource/timer-riscv.c                  |   6 +
 drivers/cpuidle/governors/menu.c                   |  13 +-
 drivers/dma/dmatest.c                              |   6 +-
 drivers/dma/ti/k3-udma.c                           |  10 +-
 drivers/edac/altera_edac.c                         |   9 +-
 drivers/edac/altera_edac.h                         |   2 +
 drivers/edac/ie31200_edac.c                        |  28 ++-
 drivers/fpga/altera-cvp.c                          |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfxhub_v1_0.c           |  10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |  16 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   1 +
 drivers/gpu/drm/ast/ast_mode.c                     |  10 +-
 drivers/gpu/drm/drm_atomic_helper.c                |  28 +++
 drivers/gpu/drm/drm_edid.c                         |   1 +
 drivers/gpu/drm/i915/gvt/opregion.c                |   8 +-
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |   5 +-
 drivers/gpu/drm/meson/meson_vclk.c                 |   6 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c            |   2 +-
 drivers/gpu/drm/panel/panel-simple.c               |  25 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c              |  17 +-
 drivers/hid/hid-ids.h                              |   4 +
 drivers/hid/hid-quirks.c                           |   2 +
 drivers/hid/usbhid/usbkbd.c                        |   2 +-
 drivers/hwmon/gpio-fan.c                           |  16 +-
 drivers/hwmon/xgene-hwmon.c                        |   2 +-
 drivers/i2c/busses/i2c-imx-lpi2c.c                 |   4 +-
 drivers/i2c/busses/i2c-pxa.c                       |   5 +-
 drivers/i2c/busses/i2c-qup.c                       |  36 ++++
 drivers/iio/accel/adis16201.c                      |   4 +-
 drivers/iio/adc/ad7606_spi.c                       |   2 +-
 drivers/iio/adc/ad7768-1.c                         |   2 +-
 drivers/iio/adc/dln2-adc.c                         |   2 +-
 drivers/iio/chemical/sps30.c                       |   2 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c     |   6 +
 drivers/infiniband/sw/rxe/rxe_cq.c                 |   5 +-
 drivers/input/mouse/synaptics.c                    |   5 +
 drivers/iommu/amd/init.c                           |   8 +
 drivers/iommu/intel/iommu.c                        |   4 +-
 drivers/irqchip/irq-gic-v2m.c                      |   8 +-
 drivers/mailbox/mailbox.c                          |   7 +-
 drivers/md/dm-cache-target.c                       |  24 +++
 drivers/md/dm-integrity.c                          |   2 +-
 drivers/md/dm-table.c                              |   9 +-
 .../media/platform/sti/c8sectpfe/c8sectpfe-core.c  |   3 +-
 drivers/media/usb/cx231xx/cx231xx-417.c            |   2 +
 drivers/media/v4l2-core/v4l2-subdev.c              |   2 +
 drivers/mmc/host/renesas_sdhi_core.c               |  10 +-
 drivers/mmc/host/sdhci-pci-core.c                  |   6 +-
 drivers/mmc/host/sdhci.c                           |   9 +-
 drivers/net/bonding/bond_main.c                    |   2 +-
 drivers/net/can/c_can/c_can_platform.c             |   2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |   2 +-
 drivers/net/dsa/b53/b53_common.c                   |  11 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |   6 +-
 drivers/net/ethernet/amd/xgbe/xgbe-desc.c          |   9 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |  24 ++-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |  11 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   4 +
 drivers/net/ethernet/apm/xgene-v2/main.c           |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  36 +++-
 drivers/net/ethernet/cadence/macb_main.c           |  19 +-
 drivers/net/ethernet/dlink/dl2k.c                  |   2 +-
 drivers/net/ethernet/dlink/dl2k.h                  |   2 +-
 drivers/net/ethernet/freescale/fec_main.c          |   7 +-
 drivers/net/ethernet/intel/ice/ice_arfs.c          |   9 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   5 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  20 +-
 drivers/net/ethernet/mellanox/mlx4/alloc.c         |   6 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   5 +
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c  |   3 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/events.c   |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c     |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/rdma.h     |   4 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |   8 +-
 drivers/net/ethernet/microchip/lan743x_main.h      |   1 +
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |   7 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   2 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |   1 +
 drivers/net/ieee802154/ca8210.c                    |   9 +-
 drivers/net/phy/microchip.c                        |  30 +--
 drivers/net/phy/microchip_t1.c                     |  28 ++-
 drivers/net/vxlan/vxlan_core.c                     |  18 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   6 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   1 +
 drivers/net/wireless/realtek/rtw88/main.c          |  40 ++--
 drivers/net/wireless/realtek/rtw88/reg.h           |   3 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |  14 +-
 drivers/net/wireless/realtek/rtw88/util.c          |   3 +-
 drivers/nvdimm/label.c                             |   3 +-
 drivers/nvme/host/core.c                           |   3 +-
 drivers/nvme/host/tcp.c                            |  31 ++-
 drivers/nvme/target/tcp.c                          |   3 +
 drivers/of/device.c                                |   7 +-
 drivers/pci/controller/dwc/pci-imx6.c              |   5 +-
 drivers/pci/controller/pcie-brcmstb.c              |   5 +-
 drivers/pci/setup-bus.c                            |   6 +-
 drivers/perf/arm-cmn.c                             |   2 +-
 drivers/phy/phy-core.c                             |   7 +-
 drivers/phy/renesas/phy-rcar-gen3-usb2.c           |   7 +-
 drivers/phy/tegra/xusb.c                           |   8 +-
 drivers/pinctrl/bcm/pinctrl-bcm281xx.c             |  44 ++---
 drivers/pinctrl/devicetree.c                       |  10 +-
 drivers/pinctrl/meson/pinctrl-meson.c              |   2 +-
 drivers/platform/x86/asus-wmi.c                    |   3 +-
 drivers/platform/x86/fujitsu-laptop.c              |  33 +++-
 drivers/platform/x86/thinkpad_acpi.c               |   7 +
 drivers/regulator/ad5398.c                         |  12 +-
 drivers/rtc/rtc-ds1307.c                           |   4 +-
 drivers/rtc/rtc-rv3032.c                           |   2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  17 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |  12 +-
 drivers/scsi/st.c                                  |  29 ++-
 drivers/scsi/st.h                                  |   2 +
 drivers/soc/ti/k3-socinfo.c                        |  13 +-
 drivers/spi/spi-fsl-dspi.c                         |  46 ++++-
 drivers/spi/spi-loopback-test.c                    |   2 +-
 drivers/spi/spi-sun4i.c                            |   5 +-
 drivers/spi/spi-zynqmp-gqspi.c                     |  22 +--
 drivers/staging/axis-fifo/axis-fifo.c              |  14 +-
 drivers/staging/iio/adc/ad7816.c                   |   2 +-
 drivers/target/iscsi/iscsi_target.c                |   2 +-
 drivers/target/target_core_file.c                  |   3 +
 drivers/target/target_core_iblock.c                |   4 +
 drivers/target/target_core_sbc.c                   |   6 +
 drivers/thermal/qoriq_thermal.c                    |  13 ++
 drivers/usb/chipidea/ci_hdrc_imx.c                 |  36 ++--
 drivers/usb/class/usbtmc.c                         |  59 +++---
 drivers/usb/gadget/udc/tegra-xudc.c                |   4 +
 drivers/usb/host/uhci-platform.c                   |   2 +-
 drivers/usb/host/xhci-tegra.c                      |   3 +
 drivers/usb/typec/altmodes/displayport.c           |  18 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   2 +-
 drivers/usb/typec/ucsi/displayport.c               |   2 +
 drivers/usb/typec/ucsi/ucsi_ccg.c                  |   5 +
 drivers/video/fbdev/core/bitblit.c                 |   5 +-
 drivers/video/fbdev/core/fbcon.c                   |  10 +-
 drivers/video/fbdev/core/fbcon.h                   |  38 +---
 drivers/video/fbdev/core/fbcon_ccw.c               |   5 +-
 drivers/video/fbdev/core/fbcon_cw.c                |   5 +-
 drivers/video/fbdev/core/fbcon_ud.c                |   5 +-
 drivers/video/fbdev/core/tileblit.c                |  45 ++++-
 drivers/video/fbdev/fsl-diu-fb.c                   |   1 +
 drivers/xen/platform-pci.c                         |   4 +
 drivers/xen/swiotlb-xen.c                          |  18 +-
 drivers/xen/xenbus/xenbus.h                        |   2 +
 drivers/xen/xenbus/xenbus_comms.c                  |   9 +-
 drivers/xen/xenbus/xenbus_dev_frontend.c           |   2 +-
 drivers/xen/xenbus/xenbus_probe.c                  |  14 +-
 drivers/xen/xenbus/xenbus_xs.c                     |  18 +-
 fs/btrfs/extent-tree.c                             |  25 ++-
 fs/btrfs/extent_io.c                               |   7 +-
 fs/btrfs/send.c                                    |   6 +-
 fs/cifs/readdir.c                                  |   7 +-
 fs/coredump.c                                      |  81 +++++++-
 fs/ext4/balloc.c                                   |   4 +-
 fs/namespace.c                                     |   9 +-
 fs/nfs/delegation.c                                |   3 +-
 fs/nfs/filelayout/filelayoutdev.c                  |   6 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |   1 +
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   6 +-
 fs/nfs/nfs4proc.c                                  |   9 +-
 fs/nfs/nfs4state.c                                 |  10 +-
 fs/nfs/pnfs.c                                      |   9 +
 fs/nfs/pnfs.h                                      |   4 +-
 fs/nfs/pnfs_nfs.c                                  |   9 +-
 fs/ocfs2/journal.c                                 |  80 +++++---
 fs/ocfs2/journal.h                                 |   1 +
 fs/ocfs2/ocfs2.h                                   |  17 +-
 fs/ocfs2/quota_local.c                             |   9 +-
 fs/ocfs2/super.c                                   |   3 +
 fs/orangefs/inode.c                                |   7 +-
 include/drm/drm_atomic.h                           |  23 ++-
 include/linux/binfmts.h                            |   1 +
 include/linux/dma-mapping.h                        |  12 +-
 include/linux/ipv6.h                               |   1 +
 include/linux/mlx4/device.h                        |   2 +-
 include/linux/pid.h                                |   1 +
 include/linux/rcupdate.h                           |   3 +
 include/linux/rcutree.h                            |   2 +-
 include/linux/tpm.h                                |   2 +-
 include/linux/types.h                              |   3 +-
 include/media/v4l2-subdev.h                        |   4 +-
 include/net/netfilter/nf_tables.h                  |   2 +-
 include/net/sch_generic.h                          |  15 ++
 include/sound/pcm.h                                |   2 +
 include/trace/events/btrfs.h                       |   2 +-
 include/uapi/linux/types.h                         |   1 +
 kernel/cgroup/cgroup.c                             |   2 +-
 kernel/fork.c                                      |  98 ++++++++--
 kernel/padata.c                                    |   3 +-
 kernel/params.c                                    |   4 +-
 kernel/rcu/tree_plugin.h                           |  11 +-
 kernel/time/posix-timers.c                         |   1 +
 kernel/trace/trace.c                               |   5 +-
 lib/dynamic_queue_limits.c                         |   2 +-
 mm/memcontrol.c                                    |   6 +-
 mm/page_alloc.c                                    |   8 +
 net/bridge/br_nf_core.c                            |   7 +-
 net/bridge/br_private.h                            |   1 +
 net/can/bcm.c                                      |  79 +++++---
 net/can/gw.c                                       | 167 +++++++++-------
 net/core/pktgen.c                                  |  13 +-
 net/ipv4/fib_frontend.c                            |  18 +-
 net/ipv4/fib_rules.c                               |   4 +-
 net/ipv4/fib_trie.c                                |  22 ---
 net/ipv4/inet_hashtables.c                         |  37 ++--
 net/ipv4/tcp_input.c                               |  56 +++---
 net/ipv4/udp_offload.c                             |  61 +++++-
 net/ipv6/fib6_rules.c                              |   4 +-
 net/ipv6/ip6_output.c                              |   9 +-
 net/llc/af_llc.c                                   |   8 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   2 +-
 net/netfilter/nf_conntrack_standalone.c            |  12 +-
 net/netfilter/nf_tables_api.c                      |  54 ++++--
 net/netfilter/nft_immediate.c                      |   2 +-
 net/openvswitch/actions.c                          |   3 +-
 net/sched/act_mirred.c                             |  22 ++-
 net/sched/sch_codel.c                              |   2 +-
 net/sched/sch_drr.c                                |   9 +-
 net/sched/sch_ets.c                                |   9 +-
 net/sched/sch_fq.c                                 |   2 +-
 net/sched/sch_fq_codel.c                           |   2 +-
 net/sched/sch_fq_pie.c                             |   2 +-
 net/sched/sch_hfsc.c                               |  15 +-
 net/sched/sch_hhf.c                                |   2 +-
 net/sched/sch_pie.c                                |   2 +-
 net/sched/sch_qfq.c                                |  11 +-
 net/sunrpc/clnt.c                                  |   3 -
 net/sunrpc/rpcb_clnt.c                             |   5 +-
 net/tipc/crypto.c                                  |   5 +
 net/xfrm/xfrm_policy.c                             |   3 +
 net/xfrm/xfrm_state.c                              |   3 +
 samples/ftrace/sample-trace-array.c                |   2 +-
 scripts/config                                     |  26 ++-
 scripts/kconfig/merge_config.sh                    |   4 +-
 security/smack/smackfs.c                           |   4 +
 sound/core/oss/pcm_oss.c                           |   3 +-
 sound/core/pcm_native.c                            |  11 ++
 sound/pci/es1968.c                                 |   6 +-
 sound/pci/hda/patch_realtek.c                      |  42 +++++
 sound/sh/Kconfig                                   |   2 +-
 sound/soc/codecs/tas2764.c                         |  51 +++--
 sound/soc/intel/boards/bytcr_rt5640.c              |  13 ++
 sound/soc/qcom/qdsp6/q6afe-clocks.c                | 209 +++++++++++----------
 sound/soc/qcom/qdsp6/q6afe.c                       |   2 +-
 sound/soc/qcom/qdsp6/q6afe.h                       |   2 +-
 sound/soc/soc-dai.c                                |   8 +-
 sound/soc/soc-ops.c                                |  29 ++-
 sound/usb/format.c                                 |   3 +-
 tools/bpf/bpftool/common.c                         |   3 +-
 tools/build/Makefile.build                         |   6 +-
 tools/lib/bpf/libbpf.c                             |   2 +-
 tools/testing/selftests/vm/compaction_test.c       |  19 +-
 284 files changed, 2415 insertions(+), 1075 deletions(-)


