Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326F922F14C;
	Mon,  2 Jun 2025 14:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875951; cv=none; b=a/5Ta8gO6T86QF2ye6vRRYOISYGHr2HCGgOnLvTp4uZoOV4kBWaoiNYljKlHLNj0MsZv9/J9KV9fR5JbZFit30skzHNJsnPGxpK9m2JviB00rxb+satNvVKXnzSLwWMYBSSAjiag7caMRfqKEVis9v7LMSHinE/coJ6K5eatyZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875951; c=relaxed/simple;
	bh=ZauKq4SgUzRFydCqFKHVSaRweF+8rMDRJEmPTcBd7KQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=C5HQkQtT2pmTDGxo5E65uDxjskfMPqHfF2HMHUXzfaqz1KKy/PoCVIUv6VBXLW7IXpcqKebHfH8de7pVPs0bI5dLzvkhqExYJYhJuRrdFrJNGchyJzZa2JyiOc3ai0bSeek3R8EW1BsD4OMDRqn/of4/ErEQkMA6OuhWzVDogrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PE9Ke3Sy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PE9Ke3Sy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B50EC4CEEB;
	Mon,  2 Jun 2025 14:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875951;
	bh=ZauKq4SgUzRFydCqFKHVSaRweF+8rMDRJEmPTcBd7KQ=;
	h=From:To:Cc:Subject:Date:From;
	b=PE9Ke3SykyKjc+GzrBIhgJoNVvoqR+TcFa0o1LaLWnqGUt0OEQjLLz/+g/rux1Mph
	 QxsA1qA+vGuuRq+xsJ4/ffdmuaSImk7p4/3PvRAr4uwslUGgrgpOTI5eH2JkoqjY8o
	 K+psEme1ypvicpPVRboLFZjHF3TbY6dxU+Yi5Y6Q=
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
Subject: [PATCH 5.15 000/207] 5.15.185-rc1 review
Date: Mon,  2 Jun 2025 15:46:12 +0200
Message-ID: <20250602134258.769974467@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.185-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.185-rc1
X-KernelTest-Deadline: 2025-06-04T13:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.185 release.
There are 207 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.185-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.185-rc1

Robin Murphy <robin.murphy@arm.com>
    perf/arm-cmn: Initialise cmn->cpu earlier

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: thinkpad_acpi: Ignore battery threshold change event notification

Valtteri Koskivuori <vkoskiv@gmail.com>
    platform/x86: fujitsu-laptop: Support Lifebook S2110 hotkeys

Michal Suchanek <msuchanek@suse.de>
    tpm: tis: Double the timeout B to 4s

Ilya Guterman <amfernusus@gmail.com>
    nvme-pci: add NVME_QUIRK_NO_DEEPEST_PS quirk for SOLIDIGM P44 Pro

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

Alok Tiwari <alok.a.tiwari@oracle.com>
    arm64: dts: qcom: sm8350: Fix typo in pil_camera_mem node

Wang Zhaolong <wangzhaolong1@huawei.com>
    smb: client: Reset all search buffer pointers when releasing buffer

Wang Zhaolong <wangzhaolong1@huawei.com>
    smb: client: Fix use-after-free in cifs_fill_dirent

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/its: Fix undefined reference to cpu_wants_rethunk_at()

Jani Nikula <jani.nikula@intel.com>
    drm/i915/gvt: fix unterminated-string-initialization warning

Juergen Gross <jgross@suse.com>
    xen/swiotlb: relax alignment requirements

Nathan Chancellor <nathan@kernel.org>
    i3c: master: svc: Fix implicit fallthrough in svc_i3c_master_ibi_work()

Nathan Chancellor <nathan@kernel.org>
    kbuild: Disable -Wdefault-const-init-unsafe

Larisa Grigore <larisa.grigore@nxp.com>
    spi: spi-fsl-dspi: Reset SR flags before sending a new message

Bogdan-Gabriel Roman <bogdan-gabriel.roman@nxp.com>
    spi: spi-fsl-dspi: Halt the module after a new message transfer

Larisa Grigore <larisa.grigore@nxp.com>
    spi: spi-fsl-dspi: restrict register range for regmap access

Jernej Skrabec <jernej.skrabec@gmail.com>
    Revert "arm64: dts: allwinner: h6: Use RSB for AXP805 PMIC connection"

Tianyang Zhang <zhangtianyang@loongson.cn>
    mm/page_alloc.c: avoid infinite retries caused by cpuset race

Breno Leitao <leitao@debian.org>
    memcg: always call cond_resched() after fn()

Mario Limonciello <mario.limonciello@amd.com>
    Revert "drm/amd: Keep display off while going into S4"

feijuan.li <feijuan.li@samsung.com>
    drm/edid: fixed the bug that hdr metadata was not reset

Vladimir Moskovkin <Vladimir.Moskovkin@kaspersky.com>
    platform/x86: dell-wmi-sysman: Avoid buffer overflow in current_password_store()

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

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-af: Set LMT_ENA bit for APR table entries

Wang Liang <wangliang74@huawei.com>
    net/tipc: fix slab-use-after-free Read in tipc_aead_encrypt_done

Cong Wang <xiyou.wangcong@gmail.com>
    sch_hfsc: Fix qlen accounting bug when using peek in hfsc_enqueue()

Paul Kocialkowski <paulk@sys-base.io>
    net: dwmac-sun8i: Use parsed internal PHY address instead of 1

Ido Schimmel <idosch@nvidia.com>
    bridge: netfilter: Fix forwarding of fragmented packets

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix not checking l2cap_chan security level

Paul Chaignon <paul.chaignon@gmail.com>
    xfrm: Sanitize marks before insert

Matti Lehtimäki <matti.lehtimaki@gmail.com>
    remoteproc: qcom_wcnss: Fix on platforms without fallback regulators

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

Chenyuan Yang <chenyuan0y@gmail.com>
    ASoC: imx-card: Adjust over allocation of memory in imx_card_parse_of()

Jessica Zhang <quic_jesszhan@quicinc.com>
    drm: Add valid clones check

Simona Vetter <simona.vetter@ffwll.ch>
    drm/atomic: clarify the rules around drm_atomic_state->allow_modeset

Rosen Penev <rosenp@gmail.com>
    wifi: ath9k: return by of_get_mac_address

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

Konstantin Taranov <kotaranov@microsoft.com>
    net/mana: fix warning in the writer of client oob

Ankur Arora <ankur.a.arora@oracle.com>
    rcu: fix header guard for rcu_all_qs()

Ankur Arora <ankur.a.arora@oracle.com>
    rcu: handle quiescent states for PREEMPT_RCU=n, PREEMPT_COUNT=y

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: don't scan PHY addresses > 0

Ido Schimmel <idosch@nvidia.com>
    vxlan: Annotate FDB data races

Depeng Shao <quic_depengs@quicinc.com>
    media: qcom: camss: csid: Only add TPG v4l2 ctrl if TPG hardware is available

Andrey Vatoropin <a.vatoropin@crpt.ru>
    hwmon: (xgene-hwmon) use appropriate type for the latency value

Jordan Crouse <jorcrous@amazon.com>
    clk: qcom: camcc-sm8250: Use clk_rcg2_shared_ops for some RCGs

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Fix download_firmware_validate() for RTL8814AU

Aleksander Jan Bajkowski <olek2@wp.pl>
    r8152: add vendor/device ID pair for Dell Alienware AW1022z

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: fib_rules: Fetch net from fib_rule in fib[46]_rule_configure().

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    arch/powerpc/perf: Check the instruction type before creating sample with perf_mem_data_src

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: remove misplaced drv_mgd_complete_tx() call

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't unconditionally call drv_mgd_complete_tx()

William Tu <witu@nvidia.com>
    net/mlx5e: reduce rep rxq depth to 256 for ECPF

William Tu <witu@nvidia.com>
    net/mlx5e: set the tx_queue_len for pfifo_fast

Alexei Lazar <alazar@nvidia.com>
    net/mlx5: Extend Ethtool loopback selftest to support non-linear SKB

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Initial psr_version with correct setting

Jiang Liu <gerry@linux.alibaba.com>
    drm/amdgpu: reset psp->cmd to NULL after releasing the buffer

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

Michael Margolin <mrgolin@amazon.com>
    RDMA/core: Fix best page size finding when it can cross SG entries

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

Balbir Singh <balbirs@nvidia.com>
    x86/kaslr: Reduce KASLR entropy on most x86 systems

Nandakumar Edamana <nandakumar@nandakumar.co.in>
    libbpf: Fix out-of-bound read

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: menu: Avoid discarding useful information

Waiman Long <longman@redhat.com>
    x86/nmi: Add an emergency handler in nmi_desc & use it in nmi_shootdown_cpus()

Yihan Zhu <Yihan.Zhu@amd.com>
    drm/amd/display: handle max_downscale_src_width fail check

Nir Lichtman <nir@lichtman.org>
    x86/build: Fix broken copy command in genimage.sh when making isoimage

Andrew Davis <afd@ti.com>
    soc: ti: k3-socinfo: Do not use syscon helper to build regmap

Hangbin Liu <liuhangbin@gmail.com>
    bonding: report duplicate MAC address in all situations

Arnd Bergmann <arnd@arndb.de>
    net: xgene-v2: remove incorrect ACPI_PTR annotation

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: KFD release_work possible circular locking

Kevin Krakauer <krakauer@google.com>
    selftests/net: have `gro.sh -t` return a correct exit code

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Avoid report two health errors on same syndrome

Viresh Kumar <viresh.kumar@linaro.org>
    firmware: arm_ffa: Set dma_mask for ffa devices

Stanimir Varbanov <svarbanov@suse.de>
    PCI: brcmstb: Add a softdep to MIP MSI-X driver

Stanimir Varbanov <svarbanov@suse.de>
    PCI: brcmstb: Expand inbound window size up to 64GB

Kuhanh Murugasen Krishnan <kuhanh.murugasen.krishnan@intel.com>
    fpga: altera-cvp: Increase credit timeout

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: mtk_dpi: Add checks for reg_h_fre_con existence

Li Bin <bin.li@microchip.com>
    ARM: at91: pm: fix at91_suspend_finish for ZQ calibration

Alexander Stein <alexander.stein@ew.tq-group.com>
    hwmon: (gpio-fan) Add missing mutex locks

Breno Leitao <leitao@debian.org>
    x86/bugs: Make spectre user default depend on MITIGATION_SPECTRE_V2

Ahmad Fatoum <a.fatoum@pengutronix.de>
    clk: imx8mp: inform CCF of maximum frequency of clocks

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Add sanity check to uvc_ioctl_xu_ctrl_map

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

Matti Lehtimäki <matti.lehtimaki@gmail.com>
    remoteproc: qcom_wcnss: Handle platforms with only single power domain

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

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: lzo - Fix compression buffer overrun

Aaron Kling <luceoscutum@gmail.com>
    cpufreq: tegra186: Share policy per cluster

Alexey Klimov <alexey.klimov@linaro.org>
    ASoC: qcom: sm8250: explicitly set format in sm8250_be_hw_params_fixup()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    auxdisplay: charlcd: Partially revert "Move hwidth and bwidth to struct hd44780_common"

Willem de Bruijn <willemb@google.com>
    ipv6: save dontfrag in cork

Erick Shepherd <erick.shepherd@ni.com>
    mmc: sdhci: Disable SD card clock before changing parameters

Ryan Roberts <ryan.roberts@arm.com>
    arm64/mm: Check PUD_TYPE_TABLE in pud_bad()

Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
    netfilter: conntrack: Bound nf_conntrack sysctl writes

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    timer_list: Don't use %pK through printk()

Eric Dumazet <edumazet@google.com>
    posix-timers: Add cond_resched() to posix_timer_add() search loop

Maher Sanalla <msanalla@nvidia.com>
    RDMA/uverbs: Propagate errors from rdma_lookup_get_uobject()

Frediano Ziglio <frediano.ziglio@cloud.com>
    xen: Add support for XenServer 6.1 platform device

Mikulas Patocka <mpatocka@redhat.com>
    dm: restrict dm device size to 2^63-512 bytes

Shashank Gupta <shashankg@marvell.com>
    crypto: octeontx2 - suppress auth failure screaming due to negative tests

Seyediman Seyedarab <imandevel@gmail.com>
    kbuild: fix argument parsing in scripts/config

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    ASoC: mediatek: mt6359: Add stub for mt6359_accdet_enable_jack_detect

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: rv3032: fix EERD location

Ilpo Järvinen <ij@kernel.org>
    tcp: reorganize tcp_in_ack_event() and tcp_count_delivered()

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Handle INTx IRQ_NOTCONNECTED

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

Heming Zhao <heming.zhao@suse.com>
    dlm: make tcp still work in multi-link env

Stanley Chu <yschu@nuvoton.com>
    i3c: master: svc: Fix missing STOP for master request

Filipe Manana <fdmanana@suse.com>
    btrfs: send: return -ENAMETOOLONG when attempting a path that is too long

Filipe Manana <fdmanana@suse.com>
    btrfs: get zone unusable bytes while holding lock at btrfs_reclaim_bgs_work()

Mark Harmstone <maharmstone@fb.com>
    btrfs: avoid linker error in btrfs_find_create_tree_block()

Boris Burkov <boris@bur.io>
    btrfs: make btrfs_discard_workfn() block_group ref explicit

Vitalii Mordan <mordan@ispras.ru>
    i2c: pxa: fix call balance of i2c->clk handling routines

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    i2c: qup: Vote for interconnect bandwidth to DRAM

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: only mark tx-status-failed frames as ACKed on mt76x0/2

Erick Shepherd <erick.shepherd@ni.com>
    mmc: host: Wait for Vdd to settle on card power off

Robert Richter <rrichter@amd.com>
    libnvdimm/labels: Fix divide error in nd_label_data_init()

Roger Pau Monne <roger.pau@citrix.com>
    PCI: vmd: Disable MSI remapping bypass under Xen

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS/flexfiles: Report ENETDOWN as a connection error

Ian Rogers <irogers@google.com>
    tools/build: Don't pass test log files to linker

Frank Li <Frank.Li@nxp.com>
    PCI: dwc: ep: Ensure proper iteration over outbound map windows

Ryo Takakura <ryotkkr98@gmail.com>
    lockdep: Fix wait context check on softirq for PREEMPT_RT

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

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    tracing: Mark binary printing functions with __printf() attribute

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Check for delegation validity in nfs_start_delegation_return_locked()

Daniel Gomez <da.gomez@samsung.com>
    kconfig: merge_config: use an empty file as initfile

Haoran Jiang <jianghaoran@kylinos.cn>
    samples/bpf: Fix compilation failure for samples/bpf on LoongArch Fedora

Brandon Kammerdiener <brandon.kammerdiener@intel.com>
    bpf: fix possible endless loop in BPF map iteration

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: refactor bulk flipping of RX buffers to separate function

gaoxu <gaoxu2@honor.com>
    cgroup: Fix compilation issue due to cgroup_mutex not being exported

Marek Szyprowski <m.szyprowski@samsung.com>
    dma-mapping: avoid potential unused data compilation warning

Zhongqiu Han <quic_zhonhan@quicinc.com>
    virtio_ring: Fix data race by tagging event_triggered as racy for KCSAN

Dmitry Bogdanov <d.bogdanov@yadro.com>
    scsi: target: iscsi: Fix timeout on deleted connection


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   2 +
 Makefile                                           |  16 ++-
 arch/arm/boot/dts/tegra114.dtsi                    |   2 +-
 arch/arm/mach-at91/pm.c                            |  21 +--
 .../boot/dts/allwinner/sun50i-h6-beelink-gs1.dts   |  38 +++---
 .../boot/dts/allwinner/sun50i-h6-orangepi-3.dts    |  14 +-
 .../boot/dts/allwinner/sun50i-h6-orangepi.dtsi     |  22 +--
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi     |   2 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   2 +-
 arch/arm64/include/asm/pgtable.h                   |   3 +-
 arch/mips/include/asm/ftrace.h                     |  16 +++
 arch/mips/kernel/pm-cps.c                          |  30 ++--
 arch/powerpc/kernel/prom_init.c                    |   4 +-
 arch/powerpc/perf/core-book3s.c                    |  20 +++
 arch/powerpc/perf/isa207-common.c                  |   4 +-
 arch/um/Makefile                                   |   1 +
 arch/um/kernel/mem.c                               |   1 +
 arch/x86/boot/genimage.sh                          |   5 +-
 arch/x86/events/amd/ibs.c                          |   3 +-
 arch/x86/include/asm/alternative.h                 |   2 +-
 arch/x86/include/asm/nmi.h                         |   2 +
 arch/x86/include/asm/perf_event.h                  |   1 +
 arch/x86/kernel/cpu/bugs.c                         |  10 +-
 arch/x86/kernel/nmi.c                              |  42 ++++++
 arch/x86/kernel/reboot.c                           |  10 +-
 arch/x86/mm/kaslr.c                                |  10 +-
 arch/x86/um/os-Linux/mcontext.c                    |   3 +-
 crypto/algif_hash.c                                |   4 -
 crypto/lzo-rle.c                                   |   2 +-
 crypto/lzo.c                                       |   2 +-
 drivers/acpi/Kconfig                               |   2 +-
 drivers/acpi/hed.c                                 |   7 +-
 drivers/auxdisplay/charlcd.c                       |   5 +-
 drivers/auxdisplay/charlcd.h                       |   5 +-
 drivers/auxdisplay/hd44780.c                       |   2 +-
 drivers/auxdisplay/lcd2s.c                         |   2 +-
 drivers/auxdisplay/panel.c                         |   2 +-
 drivers/char/tpm/tpm_tis_core.h                    |   2 +-
 drivers/clk/imx/clk-imx8mp.c                       | 151 +++++++++++++++++++++
 drivers/clk/qcom/camcc-sm8250.c                    |  56 ++++----
 drivers/clocksource/mips-gic-timer.c               |   6 +-
 drivers/clocksource/timer-riscv.c                  |   6 +
 drivers/cpufreq/tegra186-cpufreq.c                 |   7 +
 drivers/cpuidle/governors/menu.c                   |  13 +-
 .../crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c   |   7 +-
 drivers/edac/ie31200_edac.c                        |  28 ++--
 drivers/firmware/arm_ffa/bus.c                     |   1 +
 drivers/fpga/altera-cvp.c                          |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   5 +-
 drivers/gpu/drm/amd/amdgpu/gfxhub_v1_0.c           |  10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |  16 +--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   5 -
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   1 +
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c   |  11 +-
 drivers/gpu/drm/ast/ast_mode.c                     |  10 +-
 drivers/gpu/drm/drm_atomic_helper.c                |  28 ++++
 drivers/gpu/drm/drm_edid.c                         |   1 +
 drivers/gpu/drm/i915/gvt/opregion.c                |   8 +-
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |   5 +-
 drivers/hid/hid-ids.h                              |   4 +
 drivers/hid/hid-quirks.c                           |   2 +
 drivers/hid/usbhid/usbkbd.c                        |   2 +-
 drivers/hwmon/gpio-fan.c                           |  16 ++-
 drivers/hwmon/xgene-hwmon.c                        |   2 +-
 drivers/i2c/busses/i2c-pxa.c                       |   5 +-
 drivers/i2c/busses/i2c-qup.c                       |  36 +++++
 drivers/i3c/master/svc-i3c-master.c                |   2 +
 drivers/infiniband/core/umem.c                     |  36 +++--
 drivers/infiniband/core/uverbs_cmd.c               | 144 ++++++++++----------
 drivers/infiniband/core/verbs.c                    |  11 +-
 drivers/mailbox/mailbox.c                          |   7 +-
 drivers/md/dm-cache-target.c                       |  24 ++++
 drivers/md/dm-table.c                              |   4 +
 drivers/media/platform/qcom/camss/camss-csid.c     |  64 +++++----
 .../media/platform/sti/c8sectpfe/c8sectpfe-core.c  |   3 +-
 drivers/media/usb/cx231xx/cx231xx-417.c            |   2 +
 drivers/media/usb/uvc/uvc_v4l2.c                   |   6 +
 drivers/media/v4l2-core/v4l2-subdev.c              |   2 +
 drivers/mmc/host/sdhci-pci-core.c                  |   6 +-
 drivers/mmc/host/sdhci.c                           |   9 +-
 drivers/net/bonding/bond_main.c                    |   2 +-
 drivers/net/can/c_can/c_can_platform.c             |   2 +-
 drivers/net/ethernet/apm/xgene-v2/main.c           |   4 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |  16 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu_cn10k.c  |  15 +-
 drivers/net/ethernet/mellanox/mlx4/alloc.c         |   6 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   5 +
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c  |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/events.c   |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   1 +
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |   2 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   2 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |   1 +
 drivers/net/ieee802154/ca8210.c                    |   9 +-
 drivers/net/usb/r8152.c                            |   1 +
 drivers/net/vxlan/vxlan_core.c                     |  18 +--
 drivers/net/wireless/ath/ath9k/init.c              |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   3 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |   3 +-
 drivers/net/wireless/realtek/rtw88/main.c          |  40 ++----
 drivers/net/wireless/realtek/rtw88/reg.h           |   3 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |  14 +-
 drivers/net/wireless/realtek/rtw88/util.c          |   3 +-
 drivers/nvdimm/label.c                             |   3 +-
 drivers/nvme/host/pci.c                            |   2 +
 drivers/nvme/target/tcp.c                          |   3 +
 drivers/pci/Kconfig                                |   6 +
 drivers/pci/controller/dwc/pcie-designware-ep.c    |   2 +-
 drivers/pci/controller/pcie-brcmstb.c              |   5 +-
 drivers/pci/controller/vmd.c                       |  20 +++
 drivers/pci/setup-bus.c                            |   6 +-
 drivers/perf/arm-cmn.c                             |   2 +-
 drivers/phy/phy-core.c                             |   7 +-
 drivers/pinctrl/bcm/pinctrl-bcm281xx.c             |  44 +++---
 drivers/pinctrl/devicetree.c                       |  10 +-
 drivers/pinctrl/meson/pinctrl-meson.c              |   2 +-
 .../x86/dell/dell-wmi-sysman/passobj-attributes.c  |   2 +-
 drivers/platform/x86/fujitsu-laptop.c              |  33 ++++-
 drivers/platform/x86/thinkpad_acpi.c               |   7 +
 drivers/regulator/ad5398.c                         |  12 +-
 drivers/remoteproc/qcom_wcnss.c                    |  34 ++++-
 drivers/rtc/rtc-ds1307.c                           |   4 +-
 drivers/rtc/rtc-rv3032.c                           |   2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  17 ++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |  12 +-
 drivers/scsi/st.c                                  |  29 +++-
 drivers/scsi/st.h                                  |   2 +
 drivers/soc/ti/k3-socinfo.c                        |  13 +-
 drivers/spi/spi-fsl-dspi.c                         |  46 ++++++-
 drivers/spi/spi-sun4i.c                            |   5 +-
 drivers/spi/spi-zynqmp-gqspi.c                     |  22 ++-
 drivers/target/iscsi/iscsi_target.c                |   2 +-
 drivers/thermal/qoriq_thermal.c                    |  13 ++
 drivers/vfio/pci/vfio_pci_config.c                 |   3 +-
 drivers/vfio/pci/vfio_pci_core.c                   |  10 +-
 drivers/vfio/pci/vfio_pci_intrs.c                  |   2 +-
 drivers/video/fbdev/core/bitblit.c                 |   5 +-
 drivers/video/fbdev/core/fbcon.c                   |  10 +-
 drivers/video/fbdev/core/fbcon.h                   |  38 +-----
 drivers/video/fbdev/core/fbcon_ccw.c               |   5 +-
 drivers/video/fbdev/core/fbcon_cw.c                |   5 +-
 drivers/video/fbdev/core/fbcon_ud.c                |   5 +-
 drivers/video/fbdev/core/tileblit.c                |  45 +++++-
 drivers/video/fbdev/fsl-diu-fb.c                   |   1 +
 drivers/virtio/virtio_ring.c                       |   2 +-
 drivers/xen/platform-pci.c                         |   4 +
 drivers/xen/swiotlb-xen.c                          |  18 ++-
 drivers/xen/xenbus/xenbus_probe.c                  |  14 +-
 fs/btrfs/block-group.c                             |  18 ++-
 fs/btrfs/discard.c                                 |  34 +++--
 fs/btrfs/extent_io.c                               |   7 +-
 fs/btrfs/send.c                                    |   6 +-
 fs/cifs/readdir.c                                  |   7 +-
 fs/coredump.c                                      |  80 ++++++++++-
 fs/dlm/lowcomms.c                                  |   4 +-
 fs/ext4/balloc.c                                   |   4 +-
 fs/namespace.c                                     |   6 +-
 fs/nfs/delegation.c                                |   3 +-
 fs/nfs/filelayout/filelayoutdev.c                  |   6 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |   1 +
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   6 +-
 fs/nfs/nfs4state.c                                 |  10 +-
 fs/nfs/pnfs.h                                      |   4 +-
 fs/nfs/pnfs_nfs.c                                  |   9 +-
 fs/orangefs/inode.c                                |   7 +-
 include/drm/drm_atomic.h                           |  23 +++-
 include/linux/binfmts.h                            |   1 +
 include/linux/dma-mapping.h                        |  12 +-
 include/linux/ipv6.h                               |   1 +
 include/linux/lzo.h                                |   8 ++
 include/linux/mlx4/device.h                        |   2 +-
 include/linux/pid.h                                |   1 +
 include/linux/rcutree.h                            |   2 +-
 include/linux/tpm.h                                |   2 +-
 include/linux/trace.h                              |   4 +-
 include/linux/trace_seq.h                          |   8 +-
 include/linux/usb/r8152.h                          |   1 +
 include/media/v4l2-subdev.h                        |   4 +-
 include/rdma/uverbs_std_types.h                    |   2 +-
 include/sound/pcm.h                                |   2 +
 include/trace/events/btrfs.h                       |   2 +-
 kernel/bpf/hashtab.c                               |   2 +-
 kernel/cgroup/cgroup.c                             |   2 +-
 kernel/fork.c                                      |  98 +++++++++++--
 kernel/padata.c                                    |   3 +-
 kernel/rcu/tree_plugin.h                           |  11 +-
 kernel/softirq.c                                   |  18 +++
 kernel/time/posix-timers.c                         |   1 +
 kernel/time/timer_list.c                           |   4 +-
 kernel/trace/trace.c                               |  11 +-
 kernel/trace/trace.h                               |  16 ++-
 lib/dynamic_queue_limits.c                         |   2 +-
 lib/lzo/Makefile                                   |   2 +-
 lib/lzo/lzo1x_compress.c                           | 102 ++++++++++----
 lib/lzo/lzo1x_compress_safe.c                      |  18 +++
 mm/memcontrol.c                                    |   6 +-
 mm/page_alloc.c                                    |   8 ++
 net/bluetooth/l2cap_core.c                         |  15 +-
 net/bridge/br_nf_core.c                            |   7 +-
 net/bridge/br_private.h                            |   1 +
 net/can/bcm.c                                      |  79 +++++++----
 net/core/pktgen.c                                  |  13 +-
 net/ipv4/fib_frontend.c                            |  18 ++-
 net/ipv4/fib_rules.c                               |   4 +-
 net/ipv4/fib_trie.c                                |  22 ---
 net/ipv4/inet_hashtables.c                         |  37 +++--
 net/ipv4/tcp_input.c                               |  56 ++++----
 net/ipv6/fib6_rules.c                              |   4 +-
 net/ipv6/ip6_output.c                              |   9 +-
 net/llc/af_llc.c                                   |   8 +-
 net/mac80211/mlme.c                                |   4 +-
 net/netfilter/nf_conntrack_standalone.c            |  12 +-
 net/sched/sch_hfsc.c                               |  15 +-
 net/sunrpc/clnt.c                                  |   3 -
 net/sunrpc/rpcb_clnt.c                             |   5 +-
 net/tipc/crypto.c                                  |   5 +
 net/xfrm/xfrm_policy.c                             |   3 +
 net/xfrm/xfrm_state.c                              |   3 +
 samples/bpf/Makefile                               |   2 +-
 scripts/config                                     |  26 ++--
 scripts/kconfig/merge_config.sh                    |   4 +-
 security/smack/smackfs.c                           |   4 +
 sound/core/oss/pcm_oss.c                           |   3 +-
 sound/core/pcm_native.c                            |  11 ++
 sound/pci/hda/patch_realtek.c                      |  42 ++++++
 sound/soc/codecs/mt6359-accdet.h                   |   9 ++
 sound/soc/codecs/tas2764.c                         |  51 +++----
 sound/soc/fsl/imx-card.c                           |   2 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |  13 ++
 sound/soc/qcom/sm8250.c                            |   3 +
 sound/soc/soc-dai.c                                |   8 +-
 sound/soc/soc-ops.c                                |  29 +++-
 tools/bpf/bpftool/common.c                         |   3 +-
 tools/build/Makefile.build                         |   6 +-
 tools/lib/bpf/libbpf.c                             |   2 +-
 tools/testing/selftests/net/gro.sh                 |   3 +-
 242 files changed, 2053 insertions(+), 882 deletions(-)


