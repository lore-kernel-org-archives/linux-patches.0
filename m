Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF80227EB2;
	Mon,  2 Jun 2025 14:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874401; cv=none; b=ITdZuvdHXGUsxmnhc1OdttxwBKn+cE1ge67seB/tPuYcI0E50ZQdW5LhUWQEmbXKIbR8yYxu4jP970zBz59m1T91g1O7DsCiyvSIzOJYk0XfZhX4QiqvoVWSHx2Y0VD9bYL9QB7qpgxJcN0ew/Qbvsm4Gd05UyX6KBusO9XswyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874401; c=relaxed/simple;
	bh=nCd/qFwUcS358i2HMokkHlSKgt0Cqml2AajEzO14chw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WdupEBZi61WxUprTKunNw0x4i11rdh7FXD//7b2DvOb+fZm9kCH0vhGaTxkpzVLqUdokHNXXgZO2Pe2W2Z4QBFn18BSlMdp8qX+BXPp7pcQfgoF84atrOCI51ikYWDZSvROjX8MWWa3Y7MSqAHOAxJxGX0WGPxYLbKpSc6cjZYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BplxPrcB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BplxPrcB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936AAC4CEEB;
	Mon,  2 Jun 2025 14:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874401;
	bh=nCd/qFwUcS358i2HMokkHlSKgt0Cqml2AajEzO14chw=;
	h=From:To:Cc:Subject:Date:From;
	b=BplxPrcBn7T+Ubjilars2/XDP+ZCzIYW+PpcrY6psjocHS/pSC8YXwtGSUXSR18As
	 /Y1Z7xHcQMODSQyuCV1ppeYFB9MpHWxkYKDxao2SvpGZU8XREYzG76cIDP0fYL0Cno
	 VY+dMGcapVVOTS0vVYtdwTY1cHtXpc540MGyJvzk=
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
Subject: [PATCH 5.4 000/204] 5.4.294-rc1 review
Date: Mon,  2 Jun 2025 15:45:33 +0200
Message-ID: <20250602134255.449974357@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.294-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.294-rc1
X-KernelTest-Deadline: 2025-06-04T13:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.4.294 release.
There are 204 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.294-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.294-rc1

Juergen Gross <jgross@suse.com>
    xen/swiotlb: relax alignment requirements

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: thinkpad_acpi: Ignore battery threshold change event notification

Valtteri Koskivuori <vkoskiv@gmail.com>
    platform/x86: fujitsu-laptop: Support Lifebook S2110 hotkeys

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

Christian Brauner <christian.brauner@ubuntu.com>
    pidfd: check pid has attached task in fdinfo

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

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: do not defer rule destruction via call_rcu

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: wait for rcu grace period on net_device removal

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx

Nathan Chancellor <nathan@kernel.org>
    kbuild: Disable -Wdefault-const-init-unsafe

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

Ivan Pravdin <ipravdin.official@gmail.com>
    crypto: algif_hash - fix double free in hash_accept

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
    ASoC: Intel: bytcr_rt5640: Add DMI quirk for Acer Aspire SW3-013

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    pinctrl: meson: define the pull up/down resistor value as 60 kOhm

Jessica Zhang <quic_jesszhan@quicinc.com>
    drm: Add valid clones check

Simona Vetter <simona.vetter@ffwll.ch>
    drm/atomic: clarify the rules around drm_atomic_state->allow_modeset

Isaac Scott <isaac.scott@ideasonboard.com>
    regulator: ad5398: Add device tree support

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Don't use static local variable in rtw8822b_set_tx_power_index_by_rate

Viktor Malik <vmalik@redhat.com>
    bpftool: Fix readlink usage in get_fd_type

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

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: fib_rules: Fetch net from fib_rule in fib[46]_rule_configure().

William Tu <witu@nvidia.com>
    net/mlx5e: reduce rep rxq depth to 256 for ECPF

William Tu <witu@nvidia.com>
    net/mlx5e: set the tx_queue_len for pfifo_fast

Alexei Lazar <alazar@nvidia.com>
    net/mlx5: Extend Ethtool loopback selftest to support non-linear SKB

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    phy: core: don't require set_mode() callback for phy_get_mode() to work

Kees Cook <kees@kernel.org>
    net/mlx4_core: Avoid impossible mlx4_db_alloc() order value

Konstantin Andreev <andreev@swemel.ru>
    smack: recognize ipv4 CIPSO w/o categories

Valentin Caron <valentin.caron@foss.st.com>
    pinctrl: devicetree: do not goto err when probing hogs in pinctrl_dt_to_map

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

Arnd Bergmann <arnd@arndb.de>
    EDAC/ie31200: work around false positive build warning

Peter Seiderer <ps.report@gmx.net>
    net: pktgen: fix access outside of user given buffer in pktgen_thread_write()

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Fix rtw_init_ht_cap() for RTL8814AU

Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
    scsi: mpt3sas: Send a diag reset if target reset fails

Paul Burton <paulburton@kernel.org>
    MIPS: pm-cps: Use per-CPU variables as per-CPU, not per-core

Bibo Mao <maobibo@loongson.cn>
    MIPS: Use arch specific syscall name match function

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: menu: Avoid discarding useful information

Waiman Long <longman@redhat.com>
    x86/nmi: Add an emergency handler in nmi_desc & use it in nmi_shootdown_cpus()

Hangbin Liu <liuhangbin@gmail.com>
    bonding: report duplicate MAC address in all situations

Arnd Bergmann <arnd@arndb.de>
    net: xgene-v2: remove incorrect ACPI_PTR annotation

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: KFD release_work possible circular locking

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Avoid report two health errors on same syndrome

Kuhanh Murugasen Krishnan <kuhanh.murugasen.krishnan@intel.com>
    fpga: altera-cvp: Increase credit timeout

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: mtk_dpi: Add checks for reg_h_fre_con existence

Alexander Stein <alexander.stein@ew.tq-group.com>
    hwmon: (gpio-fan) Add missing mutex locks

Breno Leitao <leitao@debian.org>
    x86/bugs: Make spectre user default depend on MITIGATION_SPECTRE_V2

Peter Seiderer <ps.report@gmx.net>
    net: pktgen: fix mpls maximum labels list parsing

Artur Weber <aweber.kernel@gmail.com>
    pinctrl: bcm281xx: Use "unsigned int" instead of bare "unsigned"

Hans Verkuil <hverkuil@xs4all.nl>
    media: cx231xx: set device_caps for 417

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

Andreas Schwab <schwab@linux-m68k.org>
    powerpc/prom_init: Fixup missing #size-cells on PowerBook6,7

Erick Shepherd <erick.shepherd@ni.com>
    mmc: sdhci: Disable SD card clock before changing parameters

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

Filipe Manana <fdmanana@suse.com>
    btrfs: send: return -ENAMETOOLONG when attempting a path that is too long

Mark Harmstone <maharmstone@fb.com>
    btrfs: avoid linker error in btrfs_find_create_tree_block()

Vitalii Mordan <mordan@ispras.ru>
    i2c: pxa: fix call balance of i2c->clk handling routines

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

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: rpc_clnt_set_transport() must not change the autobind setting

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Treat ENETUNREACH errors as fatal for state recovery

Zsolt Kajtar <soci@c64.rulez.org>
    fbdev: core: tileblit: Implement missing margin clearing for tileblit

Shixiong Ou <oushixiong@kylinos.cn>
    fbdev: fsl-diu-fb: add missing device_remove_file()

Tudor Ambarus <tudor.ambarus@linaro.org>
    mailbox: use error ret code of of_parse_phandle_with_args()

Daniel Gomez <da.gomez@samsung.com>
    kconfig: merge_config: use an empty file as initfile

gaoxu <gaoxu2@honor.com>
    cgroup: Fix compilation issue due to cgroup_mutex not being exported

Marek Szyprowski <m.szyprowski@samsung.com>
    dma-mapping: avoid potential unused data compilation warning

Dmitry Bogdanov <d.bogdanov@yadro.com>
    scsi: target: iscsi: Fix timeout on deleted connection

Eelco Chaudron <echaudro@redhat.com>
    openvswitch: Fix unsafe attribute parsing in output_userspace()

Aditya Garg <gargaditya08@live.com>
    Input: synaptics - enable InterTouch on TUXEDO InfinityBook Pro 14 v5

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics - enable SMBus for HP Elitebook 850 G1

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    clocksource/i8253: Use raw_spinlock_irqsave() in clockevent_i8253_disable()

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    phy: renesas: rcar-gen3-usb2: Set timing registers only once

Ma Ke <make24@iscas.ac.cn>
    phy: Fix error handling in tegra_xusb_port_init

Wentao Liang <vulab@iscas.ac.cn>
    ALSA: es1968: Add error handling for snd_pcm_hw_constraint_pow2()

Jeremy Linton <jeremy.linton@arm.com>
    ACPI: PPTT: Fix processor subtable walk

Nathan Lynch <nathan.lynch@amd.com>
    dmaengine: Revert "dmaengine: dmatest: Fix dmatest waiting less when interrupted"

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pnfs: Reset the layout state after a layoutreturn

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pnfs: pnfs_set_layout_stateid() should update the layout cred

Abdun Nihaal <abdun.nihaal@gmail.com>
    qlcnic: fix memory leak in qlcnic_sriov_channel_cfg_cmd()

Geert Uytterhoeven <geert+renesas@glider.be>
    ALSA: sh: SND_AICA should depend on SH_DMA_API

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: discard incoming frames in BR_STATE_LISTENING

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

Gabriel Shahrouzi <gshahrouzi@gmail.com>
    staging: axis-fifo: Correct handling of tx_fifo_depth for size validation

Quentin Deslandes <quentin.deslandes@itdev.co.uk>
    staging: axis-fifo: avoid parsing ignored device tree properties

Gabriel Shahrouzi <gshahrouzi@gmail.com>
    staging: axis-fifo: Remove hardware resets for user errors

Quentin Deslandes <quentin.deslandes@itdev.co.uk>
    staging: axis-fifo: replace spinlock with mutex

Hans de Goede <hdegoede@redhat.com>
    platform/x86: asus-wmi: Fix wlan_ctrl_by_user detection

Al Viro <viro@zeniv.linux.org.uk>
    do_umount(): add missing barrier before refcount checks in sync case

Daniel Wagner <wagi@kernel.org>
    nvme: unblock ctrl state transition for firmware update

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
    staging: iio: adc: ad7816: Correct conditional logic for store mode

Aditya Garg <gargaditya08@live.com>
    Input: synaptics - enable InterTouch on Dell Precision M3800

Aditya Garg <gargaditya08@live.com>
    Input: synaptics - enable InterTouch on Dynabook Portege X30L-G

Manuel Fombuena <fombuena@outlook.com>
    Input: synaptics - enable InterTouch on Dynabook Portege X30-D

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix learning on VLAN unaware bridges

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: fix region locking in hash types

Cong Wang <xiyou.wangcong@gmail.com>
    sch_htb: make htb_deactivate() idempotent

Mike Christie <michael.christie@oracle.com>
    scsi: target: Fix WRITE_SAME No Data Buffer crash

Tudor Ambarus <tudor.ambarus@linaro.org>
    dm: fix copying after src array boundaries

Pavel Paklov <Pavel.Paklov@cyberprotect.ru>
    iommu/amd: Fix potential buffer overflow in parse_ivrs_acpihid

Heiko Stuebner <heiko@sntech.de>
    arm64: dts: rockchip: fix iface clock-name on px30 iommus

Fedor Pchelkin <pchelkin@ispras.ru>
    usb: chipidea: ci_hdrc_imx: implement usb_phy_init() error handling

Alexander Stein <alexander.stein@ew.tq-group.com>
    usb: chipidea: ci_hdrc_imx: use dev_err_probe()

Peter Chen <peter.chen@nxp.com>
    usb: chipidea: imx: refine the error handling for hsic

Peter Chen <peter.chen@nxp.com>
    usb: chipidea: imx: change hsic power regulator as optional

Suzuki K Poulose <suzuki.poulose@arm.com>
    irqchip/gic-v2m: Prevent use after free of gicv2m_get_fwnode()

Thomas Gleixner <tglx@linutronix.de>
    irqchip/gic-v2m: Mark a few functions __init

Xiang wangx <wangxiang@cdjrlc.com>
    irqchip/gic-v2m: Add const to of_device_id

Cong Wang <xiyou.wangcong@gmail.com>
    sch_htb: make htb_qlen_notify() idempotent

Sergey Shtylyov <s.shtylyov@omp.ru>
    of: module: add buffer overflow check in of_modalias()

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: imx6: Skip controller_id generation logic for i.MX7D

Mattias Barthel <mattias.barthel@atlascopco.com>
    net: fec: ERR007885 Workaround for conventional TX

Thangaraj Samynathan <thangaraj.s@microchip.com>
    net: lan743x: Fix memleak issue when GSO enabled

Alexey Denisov <rtgbnm@gmail.com>
    lan743x: fix endianness when accessing descriptors

Colin Ian King <colin.king@canonical.com>
    lan743x: remove redundant initialization of variable current_head_index

Michael Liang <mliang@purestorage.com>
    nvme-tcp: fix premature queue removal and I/O failover

Simon Horman <horms@kernel.org>
    net: dlink: Correct endianness handling of led_mode

Victor Nogueira <victor@mojatatu.com>
    net_sched: qfq: Fix double list add in class with netem as child qdisc

Victor Nogueira <victor@mojatatu.com>
    net_sched: hfsc: Fix a UAF vulnerability in class with netem as child qdisc

Victor Nogueira <victor@mojatatu.com>
    net_sched: drr: Fix double list add in class with netem as child qdisc

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: E-Switch, Initialize MAC Address for Default GID

Jeongjun Park <aha310510@gmail.com>
    tracing: Fix oob write in trace_seq_to_buffer()

Benjamin Marzinski <bmarzins@redhat.com>
    dm: always update the array size in realloc_argv on success

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: fix a warning on invalid table line

Wentao Liang <vulab@iscas.ac.cn>
    wifi: brcm80211: fmac: Add error handling for brcmf_usb_dl_writeimage()

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


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   2 +
 Makefile                                           |  16 +-
 arch/arm/boot/dts/tegra114.dtsi                    |   2 +-
 arch/arm64/boot/dts/rockchip/px30.dtsi             |   4 +-
 arch/mips/include/asm/ftrace.h                     |  16 +
 arch/mips/include/asm/ptrace.h                     |   3 +-
 arch/mips/kernel/pm-cps.c                          |  30 +-
 arch/parisc/math-emu/driver.c                      |  16 +-
 arch/powerpc/kernel/prom_init.c                    |   4 +-
 arch/um/Makefile                                   |   1 +
 arch/um/kernel/mem.c                               |   1 +
 arch/x86/include/asm/nmi.h                         |   2 +
 arch/x86/kernel/cpu/bugs.c                         |  10 +-
 arch/x86/kernel/nmi.c                              |  42 +++
 arch/x86/kernel/reboot.c                           |  10 +-
 arch/x86/um/os-Linux/mcontext.c                    |   3 +-
 crypto/algif_hash.c                                |   4 -
 drivers/acpi/Kconfig                               |   2 +-
 drivers/acpi/hed.c                                 |   7 +-
 drivers/acpi/pptt.c                                |  11 +-
 drivers/clocksource/i8253.c                        |   6 +-
 drivers/cpuidle/governors/menu.c                   |  13 +-
 drivers/dma/dmatest.c                              |   6 +-
 drivers/edac/altera_edac.c                         |   9 +-
 drivers/edac/altera_edac.h                         |   2 +
 drivers/edac/ie31200_edac.c                        |  28 +-
 drivers/fpga/altera-cvp.c                          |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |  16 +-
 drivers/gpu/drm/drm_atomic_helper.c                |  28 ++
 drivers/gpu/drm/drm_edid.c                         |   1 +
 drivers/gpu/drm/i915/gvt/opregion.c                |   8 +-
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |   5 +-
 drivers/hid/hid-ids.h                              |   4 +
 drivers/hid/hid-quirks.c                           |   2 +
 drivers/hid/usbhid/usbkbd.c                        |   2 +-
 drivers/hwmon/gpio-fan.c                           |  16 +-
 drivers/hwmon/xgene-hwmon.c                        |   2 +-
 drivers/i2c/busses/i2c-imx-lpi2c.c                 |   4 +-
 drivers/i2c/busses/i2c-pxa.c                       |   5 +-
 drivers/iio/accel/adis16201.c                      |   4 +-
 drivers/iio/adc/ad7606_spi.c                       |   2 +-
 drivers/iio/adc/ad7768-1.c                         |   2 +-
 drivers/iio/adc/dln2-adc.c                         |   2 +-
 drivers/iio/chemical/sps30.c                       |   2 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c     |   6 +
 drivers/infiniband/sw/rxe/rxe_cq.c                 |   5 +-
 drivers/input/mouse/synaptics.c                    |   5 +
 drivers/iommu/amd_iommu_init.c                     |   8 +
 drivers/irqchip/irq-gic-v2m.c                      |   8 +-
 drivers/mailbox/mailbox.c                          |   7 +-
 drivers/md/dm-cache-target.c                       |  24 ++
 drivers/md/dm-integrity.c                          |   2 +-
 drivers/md/dm-table.c                              |   9 +-
 .../media/platform/sti/c8sectpfe/c8sectpfe-core.c  |   3 +-
 drivers/media/usb/cx231xx/cx231xx-417.c            |   2 +
 drivers/mmc/host/sdhci-pci-core.c                  |   6 +-
 drivers/mmc/host/sdhci.c                           |   9 +-
 drivers/net/bonding/bond_main.c                    |   2 +-
 drivers/net/dsa/b53/b53_common.c                   |   2 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |   6 +-
 drivers/net/ethernet/amd/xgbe/xgbe-desc.c          |   9 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |  24 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |  11 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   4 +
 drivers/net/ethernet/apm/xgene-v2/main.c           |   4 +-
 drivers/net/ethernet/dlink/dl2k.c                  |   2 +-
 drivers/net/ethernet/dlink/dl2k.h                  |   2 +-
 drivers/net/ethernet/freescale/fec_main.c          |   7 +-
 drivers/net/ethernet/mellanox/mlx4/alloc.c         |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   5 +
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c  |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/events.c   |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c     |   2 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |  75 ++--
 drivers/net/ethernet/microchip/lan743x_main.h      |  21 +-
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |   7 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   2 +-
 drivers/net/ieee802154/ca8210.c                    |   9 +-
 drivers/net/vxlan.c                                |  18 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   6 +-
 drivers/net/wireless/realtek/rtw88/main.c          |  17 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |  14 +-
 drivers/nvdimm/label.c                             |   3 +-
 drivers/nvme/host/core.c                           |   3 +-
 drivers/nvme/host/tcp.c                            |  31 +-
 drivers/nvme/target/tcp.c                          |   3 +
 drivers/of/device.c                                |   7 +-
 drivers/pci/controller/dwc/pci-imx6.c              |   5 +-
 drivers/pci/setup-bus.c                            |   6 +-
 drivers/phy/phy-core.c                             |   7 +-
 drivers/phy/renesas/phy-rcar-gen3-usb2.c           |   7 +-
 drivers/phy/tegra/xusb.c                           |   8 +-
 drivers/pinctrl/bcm/pinctrl-bcm281xx.c             |  44 +--
 drivers/pinctrl/devicetree.c                       |  10 +-
 drivers/pinctrl/meson/pinctrl-meson.c              |   2 +-
 drivers/platform/x86/asus-wmi.c                    |   3 +-
 drivers/platform/x86/fujitsu-laptop.c              |  33 +-
 drivers/platform/x86/thinkpad_acpi.c               |   7 +
 drivers/regulator/ad5398.c                         |  12 +-
 drivers/rtc/rtc-ds1307.c                           |   4 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  17 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |  12 +-
 drivers/scsi/st.c                                  |  29 +-
 drivers/scsi/st.h                                  |   2 +
 drivers/spi/spi-fsl-dspi.c                         |  20 +-
 drivers/spi/spi-loopback-test.c                    |   2 +-
 drivers/spi/spi-sun4i.c                            |   5 +-
 drivers/staging/axis-fifo/axis-fifo.c              | 417 ++++++++-------------
 drivers/staging/axis-fifo/axis-fifo.txt            |  18 +-
 drivers/staging/iio/adc/ad7816.c                   |   2 +-
 drivers/target/iscsi/iscsi_target.c                |   2 +-
 drivers/target/target_core_file.c                  |   3 +
 drivers/target/target_core_iblock.c                |   4 +
 drivers/target/target_core_sbc.c                   |   6 +
 drivers/usb/chipidea/ci_hdrc_imx.c                 |  42 ++-
 drivers/usb/class/usbtmc.c                         |  59 +--
 drivers/usb/host/uhci-platform.c                   |   2 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   2 +-
 drivers/usb/typec/ucsi/displayport.c               |   2 +
 drivers/video/fbdev/core/tileblit.c                |  37 +-
 drivers/video/fbdev/fsl-diu-fb.c                   |   1 +
 drivers/xen/platform-pci.c                         |   4 +
 drivers/xen/swiotlb-xen.c                          |  18 +-
 drivers/xen/xenbus/xenbus.h                        |   2 +
 drivers/xen/xenbus/xenbus_comms.c                  |   9 +-
 drivers/xen/xenbus/xenbus_dev_frontend.c           |   2 +-
 drivers/xen/xenbus/xenbus_probe.c                  |  14 +-
 drivers/xen/xenbus/xenbus_xs.c                     |  18 +-
 fs/btrfs/extent_io.c                               |   7 +-
 fs/btrfs/send.c                                    |   6 +-
 fs/cifs/readdir.c                                  |   7 +-
 fs/coredump.c                                      |  80 +++-
 fs/ext4/balloc.c                                   |   4 +-
 fs/namespace.c                                     |   9 +-
 fs/nfs/callback_proc.c                             |   2 +-
 fs/nfs/filelayout/filelayoutdev.c                  |   6 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |   1 +
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   6 +-
 fs/nfs/nfs4proc.c                                  |   9 +-
 fs/nfs/nfs4state.c                                 |  10 +-
 fs/nfs/pnfs.c                                      |  29 +-
 fs/nfs/pnfs.h                                      |   5 +-
 fs/nfs/pnfs_nfs.c                                  |   9 +-
 fs/ocfs2/journal.c                                 |  80 ++--
 fs/ocfs2/journal.h                                 |   1 +
 fs/ocfs2/ocfs2.h                                   |  17 +-
 fs/ocfs2/quota_local.c                             |   9 +-
 fs/ocfs2/super.c                                   |   3 +
 fs/orangefs/inode.c                                |   7 +-
 include/drm/drm_atomic.h                           |  23 +-
 include/linux/binfmts.h                            |   1 +
 include/linux/dma-mapping.h                        |  12 +-
 include/linux/mlx4/device.h                        |   2 +-
 include/linux/pid.h                                |   5 +
 include/linux/rcutree.h                            |   2 +-
 include/linux/types.h                              |   3 +-
 include/sound/pcm.h                                |   2 +
 include/trace/events/btrfs.h                       |   2 +-
 include/uapi/linux/types.h                         |   1 +
 kernel/cgroup/cgroup.c                             |   2 +-
 kernel/fork.c                                      | 108 +++++-
 kernel/params.c                                    |   4 +-
 kernel/rcu/tree_plugin.h                           |  11 +-
 kernel/time/posix-timers.c                         |   1 +
 kernel/trace/trace.c                               |   5 +-
 lib/dynamic_queue_limits.c                         |   2 +-
 mm/memcontrol.c                                    |   6 +-
 mm/page_alloc.c                                    |   8 +
 net/bridge/br_nf_core.c                            |   7 +-
 net/bridge/br_private.h                            |   1 +
 net/can/bcm.c                                      |  79 ++--
 net/core/pktgen.c                                  |  13 +-
 net/ipv4/fib_rules.c                               |   4 +-
 net/ipv6/fib6_rules.c                              |   4 +-
 net/llc/af_llc.c                                   |   8 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   2 +-
 net/netfilter/nf_conntrack_standalone.c            |  12 +-
 net/netfilter/nf_tables_api.c                      |  51 ++-
 net/openvswitch/actions.c                          |   3 +-
 net/sched/sch_drr.c                                |   9 +-
 net/sched/sch_hfsc.c                               |  15 +-
 net/sched/sch_htb.c                                |  13 +-
 net/sched/sch_qfq.c                                |  11 +-
 net/sunrpc/clnt.c                                  |   3 -
 net/xfrm/xfrm_policy.c                             |   3 +
 net/xfrm/xfrm_state.c                              |   3 +
 scripts/config                                     |  26 +-
 scripts/kconfig/merge_config.sh                    |   4 +-
 security/smack/smackfs.c                           |   4 +
 sound/core/oss/pcm_oss.c                           |   3 +-
 sound/core/pcm_native.c                            |  11 +
 sound/pci/es1968.c                                 |   6 +-
 sound/sh/Kconfig                                   |   2 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |  13 +
 sound/soc/soc-ops.c                                |  29 +-
 tools/bpf/bpftool/common.c                         |   3 +-
 tools/build/Makefile.build                         |   6 +-
 198 files changed, 1682 insertions(+), 840 deletions(-)


