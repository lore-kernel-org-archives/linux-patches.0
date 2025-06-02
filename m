Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A8C2253BC;
	Mon,  2 Jun 2025 14:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873029; cv=none; b=oKCwjdC05gxNw75MJFauHQE3uvKCtgasGJKJbBKlE4Mt2a2HQN8jK8hyWKNoh/246Fan591fgUNUH4ItMrUeWBo37vh1YihJQ430/bTci1Y/5Cb1EepCf0AUY17XMUEPCpKf9AWqlrh6e2UH5IsKGERdsjZuiMi0q1LeAKXu4O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873029; c=relaxed/simple;
	bh=dTZY2ov+/m7/yt2boWPRXXkTf2XefgI9LeMGVl5JiKE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=I9tdnXJXsDeMgx3Z2iuLA/TBG0E/MY8kWNCqldEtLiCBriMzrRQCtKleV0Yh+LFwqJkbw/OxCrX7wp78EfV2SBca2yT21jEVfLA9HoSrb379BNNC+cBhWBWR4mt5lGAlkqDRNyNoo74H7xYG40DyAKPLie/WoslIoSAkvvhN1Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2egsL3Vk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2egsL3Vk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC84C4CEEB;
	Mon,  2 Jun 2025 14:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873029;
	bh=dTZY2ov+/m7/yt2boWPRXXkTf2XefgI9LeMGVl5JiKE=;
	h=From:To:Cc:Subject:Date:From;
	b=2egsL3Vk/rehzMYLgNWG9OVbEAa/OfD0AzY9ZtyZFJ4qGVbVy5xaR2OwtBbaIPWT8
	 g48K5ZmUgybszTE7dA7/UCUiK1z2uKaU2a20JptAIlyPkK7tGkMo9vz7gs6G7BSzam
	 yWEcqSp3uyXs82v331D0/GLgV/i1WP3hmB/Vu77A=
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
Subject: [PATCH 6.6 000/444] 6.6.93-rc1 review
Date: Mon,  2 Jun 2025 15:41:04 +0200
Message-ID: <20250602134340.906731340@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.93-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.93-rc1
X-KernelTest-Deadline: 2025-06-04T13:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.93 release.
There are 444 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.93-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.93-rc1

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use list_first_entry_or_null for opinfo_get_list()

Nishanth Menon <nm@ti.com>
    net: ethernet: ti: am65-cpsw: Lower random mac address error print to info

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: thinkpad_acpi: Ignore battery threshold change event notification

Valtteri Koskivuori <vkoskiv@gmail.com>
    platform/x86: fujitsu-laptop: Support Lifebook S2110 hotkeys

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Avoid flushing data while holding directory locks in nfs_rename()

Ilya Guterman <amfernusus@gmail.com>
    nvme-pci: add NVME_QUIRK_NO_DEEPEST_PS quirk for SOLIDIGM P44 Pro

Alessandro Grassi <alessandro.grassi@mailbox.org>
    spi: spi-sun4i: fix early activation

Hal Feng <hal.feng@starfivetech.com>
    phy: starfive: jh7110-usb: Fix USB 2.0 host occasional detection failure

George Shen <george.shen@amd.com>
    drm/amd/display: fix link_set_dpms_off multi-display MST corner case

Masahiro Yamada <masahiroy@kernel.org>
    um: let 'make clean' properly clean underlying SUBARCH as well

John Chau <johnchau@0atlas.com>
    platform/x86: thinkpad_acpi: Support also NEC Lavie X1475JAS

Jeff Layton <jlayton@kernel.org>
    nfs: don't share pNFS DS connections between net namespaces

Milton Barrera <miltonjosue2001@gmail.com>
    HID: quirks: Add ADATA XPG alpha wireless mouse support

Purva Yeshi <purvayeshi550@gmail.com>
    dmaengine: idxd: cdev: Fix uninitialized use of sva in idxd_cdev_open

Christian Brauner <brauner@kernel.org>
    coredump: hand a pidfd to the usermode coredump helper

Christian Brauner <brauner@kernel.org>
    coredump: fix error handling for replace_fd()

Robin Murphy <robin.murphy@arm.com>
    perf/arm-cmn: Initialise cmn->cpu earlier

Robin Murphy <robin.murphy@arm.com>
    perf/arm-cmn: Fix REQ2/SNP2 mixup

Pedro Tammela <pctammela@mojatatu.com>
    net_sched: hfsc: Address reentrant enqueue adding class to eltree twice

Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
    arm64: dts: ti: k3-am68-sk: Fix regulator hierarchy

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: sm8550: Add missing properties for cryptobam

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: sm8450: Add missing properties for cryptobam

Alok Tiwari <alok.a.tiwari@oracle.com>
    arm64: dts: qcom: sm8350: Fix typo in pil_camera_mem node

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: ipq9574: Add missing properties for cryptobam

Shigeru Yoshida <syoshida@redhat.com>
    af_unix: Fix uninit-value in __unix_walk_scc()

Michal Luczaj <mhal@rbox.co>
    af_unix: Fix garbage collection of embryos carrying OOB with SCM_RIGHTS

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Add dead flag to struct scm_fp_list.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Don't access successor in unix_del_edges() during GC.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Try not to hold unix_gc_lock during accept().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Remove lock dance in unix_peek_fds().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Replace garbage collection algorithm.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Detect dead SCC.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Assign a unique index to SCC.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Avoid Tarjan's algorithm if unnecessary.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Skip GC if no cycle exists.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Save O(n) setup of Tarjan's algo.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Fix up unix_edge.successor for embryo socket.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Save listener for embryo socket.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Detect Strongly Connected Components.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Iterate all vertices by DFS.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Bulk update unix_tot_inflight/unix_inflight when queuing skb.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Link struct unix_edge when queuing skb.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Allocate struct unix_edge for each inflight AF_UNIX fd.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Allocate struct unix_vertex for each inflight AF_UNIX fd.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Remove CONFIG_UNIX_SCM.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Remove io_uring code for GC.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Replace BUG_ON() with WARN_ON_ONCE().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Try to run GC async.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Run GC on only one CPU.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Return struct unix_sock from unix_get_socket().

Boris Burkov <boris@bur.io>
    btrfs: check folio mapping after unlock in relocate_one_folio()

Frederic Weisbecker <frederic@kernel.org>
    hrtimers: Force migrate away hrtimers queued after CPUHP_AP_HRTIMERS_DYING

Axel Forsman <axfo@kvaser.com>
    can: kvaser_pciefd: Force IRQ edge in case of nested IRQ

Thomas Zimmermann <tzimmermann@suse.de>
    drm/gem: Internally test import_attach for imported objects

Balbir Singh <balbirs@nvidia.com>
    x86/mm/init: Handle the special case of device private pages in add_pages(), to not increase max_pfn and trigger dma_addressing_limited() bounce buffers bounce buffers

Nathan Chancellor <nathan@kernel.org>
    i3c: master: svc: Fix implicit fallthrough in svc_i3c_master_ibi_work()

Dan Carpenter <dan.carpenter@linaro.org>
    pinctrl: tegra: Fix off by one in tegra_pinctrl_get_group()

Arnd Bergmann <arnd@arndb.de>
    watchdog: aspeed: fix 64-bit division

Geert Uytterhoeven <geert+renesas@glider.be>
    serial: sh-sci: Save and restore more registers

Brett Creeley <brett.creeley@amd.com>
    pds_core: Prevent possible adminq overflow/stuck condition

Matthew Wilcox (Oracle) <willy@infradead.org>
    highmem: add folio_test_partial_kmap()

Alexey Dobriyan <adobriyan@gmail.com>
    x86/boot: Compile boot code with -std=gnu11 too

Larisa Grigore <larisa.grigore@nxp.com>
    spi: spi-fsl-dspi: Reset SR flags before sending a new message

Bogdan-Gabriel Roman <bogdan-gabriel.roman@nxp.com>
    spi: spi-fsl-dspi: Halt the module after a new message transfer

Larisa Grigore <larisa.grigore@nxp.com>
    spi: spi-fsl-dspi: restrict register range for regmap access

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix stream write failure

Jernej Skrabec <jernej.skrabec@gmail.com>
    Revert "arm64: dts: allwinner: h6: Use RSB for AXP805 PMIC connection"

Tianyang Zhang <zhangtianyang@loongson.cn>
    mm/page_alloc.c: avoid infinite retries caused by cpuset race

Breno Leitao <leitao@debian.org>
    memcg: always call cond_resched() after fn()

Vicki Pfau <vi@endrift.com>
    Input: xpad - add more controllers

Mario Limonciello <mario.limonciello@amd.com>
    Revert "drm/amd: Keep display off while going into S4"

Wang Zhaolong <wangzhaolong1@huawei.com>
    smb: client: Reset all search buffer pointers when releasing buffer

Gabor Juhos <j4g8y7@gmail.com>
    arm64: dts: marvell: uDPU: define pinctrl state for alarm LEDs

Wang Zhaolong <wangzhaolong1@huawei.com>
    smb: client: Fix use-after-free in cifs_fill_dirent

feijuan.li <feijuan.li@samsung.com>
    drm/edid: fixed the bug that hdr metadata was not reset

Zhang Rui <rui.zhang@intel.com>
    thermal: intel: x86_pkg_temp_thermal: Fix bogus trip temperature

Vladimir Moskovkin <Vladimir.Moskovkin@kaspersky.com>
    platform/x86: dell-wmi-sysman: Avoid buffer overflow in current_password_store()

Axel Forsman <axfo@kvaser.com>
    can: kvaser_pciefd: Continue parsing DMA buf after dropped RX

Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
    llc: fix data loss when reading from a socket in llc_ui_recvmsg()

Ed Burcher <git@edburcher.com>
    ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14ASP10

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix race of buffer access at PCM OSS layer

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-pcm: Delay reporting is only supported for playback direction

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoc: SOF: topology: connect DAI to a single DAI link

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-control: Use SOF_CTRL_CMD_BINARY as numid for bytes_ext

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: add missing rcu read protection for procfs content

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: add locking for bcm_op runtime updates

Carlos Sanchez <carlossanchez@geotab.com>
    can: slcan: allow reception of short error messages

Dominik Grzegorzek <dominik.grzegorzek@oracle.com>
    padata: do not leak refcount in reorder_work

Ivan Pravdin <ipravdin.official@gmail.com>
    crypto: algif_hash - fix double free in hash_accept

André Draszik <andre.draszik@linaro.org>
    clk: s2mps11: initialise clk_hw_onecell_data::num before accessing ::hws[] in probe()

Geetha sowjanya <gakula@marvell.com>
    octeontx2-af: Fix APR entry mapping based on APR_LMT_CFG

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-af: Set LMT_ENA bit for APR table entries

Wang Liang <wangliang74@huawei.com>
    net/tipc: fix slab-use-after-free Read in tipc_aead_encrypt_done

Suman Ghosh <sumang@marvell.com>
    octeontx2-pf: Add AF_XDP non-zero copy support

Cong Wang <xiyou.wangcong@gmail.com>
    sch_hfsc: Fix qlen accounting bug when using peek in hfsc_enqueue()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix overflow resched cqe reordering

Thangaraj Samynathan <thangaraj.s@microchip.com>
    net: lan743x: Restore SGMII CTRL register on resume

Paul Kocialkowski <paulk@sys-base.io>
    net: dwmac-sun8i: Use parsed internal PHY address instead of 1

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    pinctrl: qcom: switch to devm_register_sys_off_handler()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pinctrl: qcom/msm: Convert to platform remove callback returning void

Dave Ertman <david.m.ertman@intel.com>
    ice: Fix LACP bonds without SRIOV environment

Jacob Keller <jacob.e.keller@intel.com>
    ice: fix vf->num_mac count with port representors

Ido Schimmel <idosch@nvidia.com>
    bridge: netfilter: Fix forwarding of fragmented packets

En-Wei Wu <en-wei.wu@canonical.com>
    Bluetooth: btusb: use skb_pull to avoid unsafe access in QCA dump handling

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix not checking l2cap_chan security level

Stefan Wahren <wahrenst@gmx.net>
    dmaengine: fsl-edma: Fix return code for unhandled interrupts

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: Fix ->poll() return value

Paul Chaignon <paul.chaignon@gmail.com>
    xfrm: Sanitize marks before insert

Andre Przywara <andre.przywara@arm.com>
    clk: sunxi-ng: d1: Add missing divider for MMC mod clocks

Matti Lehtimäki <matti.lehtimaki@gmail.com>
    remoteproc: qcom_wcnss: Fix on platforms without fallback regulators

David Hildenbrand <david@redhat.com>
    kernel/fork: only call untrack_pfn_clear() on VMAs duplicated for fork()

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    dmaengine: idxd: Fix allowing write() from different address spaces

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: add wq driver name support for accel-config user tool

Sabrina Dubroca <sd@queasysnail.net>
    espintcp: remove encap socket caching to avoid reference leak

Charles Keepax <ckeepax@opensource.cirrus.com>
    soundwire: bus: Fix race on the creation of the IRQ domain

Al Viro <viro@zeniv.linux.org.uk>
    __legitimize_mnt(): check for MNT_SYNC_UMOUNT should be under mount_lock

Jason Andryuk <jason.andryuk@amd.com>
    xenbus: Allow PVH dom0 a non-local xenstore

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: add support for Killer on MTL

David Wei <dw@davidwei.uk>
    tools: ynl-gen: validate 0 len strings from kernel

Qu Wenruo <wqu@suse.com>
    btrfs: avoid NULL pointer dereference if no valid csum tree

Goldwyn Rodrigues <rgoldwyn@suse.de>
    btrfs: correct the order of prelim_ref arguments in btrfs__prelim_ref

Pali Rohár <pali@kernel.org>
    cifs: Fix changing times and read-only attr over SMB1 smb_set_file_info() function

Pali Rohár <pali@kernel.org>
    cifs: Fix and improve cifs_query_path_info() and cifs_query_file_info()

Jens Axboe <axboe@kernel.dk>
    io_uring/fdinfo: annotate racy sq/cq head/tail reads

Alistair Francis <alistair.francis@wdc.com>
    nvmet-tcp: don't restore null sk_state_change

Wentao Guan <guanwentao@uniontech.com>
    nvme-pci: add quirks for WDC Blue SN550 15b7:5009

Wentao Guan <guanwentao@uniontech.com>
    nvme-pci: add quirks for device 126f:1001

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Add quirk for HP Spectre x360 15-df1xxx

Takashi Iwai <tiwai@suse.de>
    ASoC: Intel: bytcr_rt5640: Add DMI quirk for Acer Aspire SW3-013

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l43: Disable headphone clamps during type detection

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    pinctrl: meson: define the pull up/down resistor value as 60 kOhm

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    book3s64/radix: Fix compile errors when CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP=n

Chenyuan Yang <chenyuan0y@gmail.com>
    ASoC: imx-card: Adjust over allocation of memory in imx_card_parse_of()

Jessica Zhang <quic_jesszhan@quicinc.com>
    drm: Add valid clones check

Douglas Anderson <dianders@chromium.org>
    drm/panel-edp: Add Starry 116KHD024006

Simona Vetter <simona.vetter@ffwll.ch>
    drm/atomic: clarify the rules around drm_atomic_state->allow_modeset

Olivier Moysan <olivier.moysan@foss.st.com>
    drm: bridge: adv7511: fill stream capabilities

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath12k: Fix end offset bit definition in monitor ring descriptor

Rosen Penev <rosenp@gmail.com>
    wifi: ath9k: return by of_get_mac_address

Youssef Samir <quic_yabdulra@quicinc.com>
    accel/qaic: Mask out SR-IOV PCI resources

Nicolas Escande <nico.escande@gmail.com>
    wifi: ath12k: fix ath12k_hal_tx_cmd_ext_desc_setup() info1 override

Isaac Scott <isaac.scott@ideasonboard.com>
    regulator: ad5398: Add device tree support

Sean Anderson <sean.anderson@linux.dev>
    spi: zynqmp-gqspi: Always acknowledge interrupts

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: add wiphy_lock() to work that isn't held wiphy_lock() yet

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Don't use static local variable in rtw8822b_set_tx_power_index_by_rate

Soeren Moch <smoch@web.de>
    wifi: rtl8xxxu: retry firmware download on error

Ravi Bangoria <ravi.bangoria@amd.com>
    perf/amd/ibs: Fix ->config to sample period calculation for OP PMU

Ravi Bangoria <ravi.bangoria@amd.com>
    perf/amd/ibs: Fix perf_ibs_op.cnt_mask for CurCnt

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scmi: Relax duplicate name constraint across protocol ids

Viktor Malik <vmalik@redhat.com>
    bpftool: Fix readlink usage in get_fd_type

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: Find VBIOS mode from regular display size

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: rt722-sdca: Add some missing readable registers

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: codecs: pcm3168a: Allow for 24-bit in provider mode

Naman Trivedi <naman.trivedimanojbhai@amd.com>
    arm64: zynqmp: add clock-output-names property in clock nodes

junan <junan76@163.com>
    HID: usbkbd: Fix the bit shift number for LED_KANA

Avula Sri Charan <quic_asrichar@quicinc.com>
    wifi: ath12k: Avoid napi_sync() before napi_enable()

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: st: Restore some drive settings after reset

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Free phba irq in lpfc_sli4_enable_msi() when pci_irq_vector() fails

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Handle duplicate D_IDs in ndlp search-by D_ID routine

Konstantin Taranov <kotaranov@microsoft.com>
    net/mana: fix warning in the writer of client oob

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    ice: count combined queues using Rx/Tx count

Peter Zijlstra (Intel) <peterz@infradead.org>
    perf: Avoid the read if the count is already updated

Ankur Arora <ankur.a.arora@oracle.com>
    rcu: fix header guard for rcu_all_qs()

Ankur Arora <ankur.a.arora@oracle.com>
    rcu: handle unstable rdp in rcu_read_unlock_strict()

Ankur Arora <ankur.a.arora@oracle.com>
    rcu: handle quiescent states for PREEMPT_RCU=n, PREEMPT_COUNT=y

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    ice: treat dyn_allowed only as suggestion

Petr Machata <petrm@nvidia.com>
    bridge: mdb: Allow replace of a host-joined group

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: don't scan PHY addresses > 0

Geert Uytterhoeven <geert@linux-m68k.org>
    ipv4: ip_gre: Fix set but not used warning in ipgre_err() if IPv4-only

Ido Schimmel <idosch@nvidia.com>
    vxlan: Annotate FDB data races

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Avoid WARN_ON when configuring MQPRIO with HTB offload enabled

Depeng Shao <quic_depengs@quicinc.com>
    media: qcom: camss: csid: Only add TPG v4l2 ctrl if TPG hardware is available

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: introduce f2fs_base_attr for global sysfs entries

Andrey Vatoropin <a.vatoropin@crpt.ru>
    hwmon: (xgene-hwmon) use appropriate type for the latency value

Jordan Crouse <jorcrous@amazon.com>
    clk: qcom: camcc-sm8250: Use clk_rcg2_shared_ops for some RCGs

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Fix __rtw_download_firmware() for RTL8814AU

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Fix download_firmware_validate() for RTL8814AU

Zhang Yi <yi.zhang@huawei.com>
    ext4: remove writable userspace mappings before truncating page cache

Zhang Yi <yi.zhang@huawei.com>
    ext4: don't write back data before punch hole in nojournal mode

Marek Vasut <marex@denx.de>
    leds: trigger: netdev: Configure LED blink interval for HW offload

Kees Cook <kees@kernel.org>
    pstore: Change kmsg_bytes storage size to u32

Aleksander Jan Bajkowski <olek2@wp.pl>
    r8152: add vendor/device ID pair for Dell Alienware AW1022z

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: fib_rules: Fetch net from fib_rule in fib[46]_rule_configure().

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    arch/powerpc/perf: Check the instruction type before creating sample with perf_mem_data_src

Gaurav Batra <gbatra@linux.ibm.com>
    powerpc/pseries/iommu: memory notifier incorrectly adds TCEs for pmemory

Csókás, Bence <csokas.bence@prolan.hu>
    net: fec: Refactor MAC reset to function

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: remove misplaced drv_mgd_complete_tx() call

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't unconditionally call drv_mgd_complete_tx()

Stefan Wahren <wahrenst@gmx.net>
    drm/v3d: Add clock handling

William Tu <witu@nvidia.com>
    net/mlx5e: reduce the max log mpwrq sz for ECPF and reps

William Tu <witu@nvidia.com>
    net/mlx5e: reduce rep rxq depth to 256 for ECPF

William Tu <witu@nvidia.com>
    net/mlx5e: set the tx_queue_len for pfifo_fast

Alexei Lazar <alazar@nvidia.com>
    net/mlx5: Extend Ethtool loopback selftest to support non-linear SKB

Chaohai Chen <wdhh66@163.com>
    scsi: target: spc: Fix loop traversal in spc_rsoc_get_descr()

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display/dm: drop hw_support check in amdgpu_dm_i2c_xfer()

Shiwu Zhang <shiwu.zhang@amd.com>
    drm/amdgpu: enlarge the VBIOS binary size limit

Joshua Aberback <joshua.aberback@amd.com>
    drm/amd/display: Increase block_sequence array size

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Initial psr_version with correct setting

George Shen <george.shen@amd.com>
    drm/amd/display: Update CR AUX RD interval interpretation

Jiang Liu <gerry@linux.alibaba.com>
    drm/amdgpu: reset psp->cmd to NULL after releasing the buffer

Ilya Bakoulin <Ilya.Bakoulin@amd.com>
    drm/amd/display: Don't try AUX transactions on disconnected link

Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
    drm/amdgpu: Set snoop bit for SDMA for MI series

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    soundwire: amd: change the soundwire wake enable/disable sequence

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    phy: core: don't require set_mode() callback for phy_get_mode() to work

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Update the suspend/resume support

zihan zhou <15645113830zzh@gmail.com>
    sched: Reduce the default slice to avoid tasks getting an extra tick

Peter Zijlstra <peterz@infradead.org>
    x86/traps: Cleanup and robustify decode_bug()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    clk: qcom: clk-alpha-pll: Do not use random stack value for recalc rate

Karl Chan <exxxxkc@getgoogleoff.me>
    clk: qcom: ipq5018: allow it to be bulid on arm32

Kees Cook <kees@kernel.org>
    net/mlx4_core: Avoid impossible mlx4_db_alloc() order value

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l: Memset argument to 0 before calling get_mbus_config pad op

David Plowman <david.plowman@raspberrypi.com>
    media: i2c: imx219: Correct the minimum vblanking value

Brendan Jackman <jackmanb@google.com>
    kunit: tool: Use qboot on QEMU x86_64

Konstantin Andreev <andreev@swemel.ru>
    smack: Revert "smackfs: Added check catlen"

Konstantin Andreev <andreev@swemel.ru>
    smack: recognize ipv4 CIPSO w/o categories

Valentin Caron <valentin.caron@foss.st.com>
    pinctrl: devicetree: do not goto err when probing hogs in pinctrl_dt_to_map

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-dai: check return value at snd_soc_dai_set_tdm_slot()

Hector Martin <marcan@marcan.st>
    ASoC: tas2764: Power up/down amp on mute ops

Hector Martin <marcan@marcan.st>
    ASoC: tas2764: Mark SW_RESET as volatile

Hector Martin <marcan@marcan.st>
    ASoC: tas2764: Add reg defaults for TAS2764_INT_CLK_CFG

Martin Povišer <povik+lin@cutebit.org>
    ASoC: ops: Enforce platform maximum on initial value

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_ffa: Reject higher major version as incompatible

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5: Apply rate-limiting to high temperature warning

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5: Modify LSB bitmask in temperature event to include only the first bit

Hans Verkuil <hverkuil@xs4all.nl>
    media: test-drivers: vivid: don't call schedule in loop

Petr Machata <petrm@nvidia.com>
    vxlan: Join / leave MC group after remote changes

Xiaofei Tan <tanxiaofei@huawei.com>
    ACPI: HED: Always initialize before evged

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Fix old_size lower bound in calculate_iosize() too

Jakub Kicinski <kuba@kernel.org>
    eth: mlx4: don't try to complete XDP frames in netpoll

Eduard Zingerman <eddyz87@gmail.com>
    bpf: don't do clean_live_states when state->loop_entry->branches > 0

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    can: c_can: Use of_property_present() to test existence of DT property

Ahmad Fatoum <a.fatoum@pengutronix.de>
    pmdomain: imx: gpcv2: use proper helper for property detection

Michael Margolin <mrgolin@amazon.com>
    RDMA/core: Fix best page size finding when it can cross SG entries

Alexis Lothoré <alexis.lothore@bootlin.com>
    serial: mctrl_gpio: split disable_ms into sync and no_sync APIs

Harry VanZyllDeJong <hvanzyll@amd.com>
    drm/amd/display: Add support for disconnected eDP streams

Frank Li <Frank.Li@nxp.com>
    i3c: master: svc: Flush FIFO before sending Dynamic Address Assignment(DAA)

Arnd Bergmann <arnd@arndb.de>
    EDAC/ie31200: work around false positive build warning

Peter Seiderer <ps.report@gmx.net>
    net: pktgen: fix access outside of user given buffer in pktgen_thread_write()

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: fw: propagate error code from rtw89_h2c_tx()

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

Jason Gunthorpe <jgg@ziepe.ca>
    genirq/msi: Store the IOMMU IOVA directly in msi_desc instead of iommu_cookie

Bibo Mao <maobibo@loongson.cn>
    MIPS: Use arch specific syscall name match function

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: skcipher - Zap type in crypto_alloc_sync_skcipher

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: ahash - Set default reqsize from ahash_alg

Balbir Singh <balbirs@nvidia.com>
    x86/kaslr: Reduce KASLR entropy on most x86 systems

Patrisious Haddad <phaddad@nvidia.com>
    net/mlx5: Change POOL_NEXT_SIZE define value and make it global

Jinliang Zheng <alexjlzheng@gmail.com>
    dm: fix unconditional IO throttle caused by REQ_PREFLUSH

Nandakumar Edamana <nandakumar@nandakumar.co.in>
    libbpf: Fix out-of-bound read

Matthias Fend <matthias.fend@emfend.at>
    media: tc358746: improve calculation of the D-PHY timing registers

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: adv7180: Disable test-pattern control on adv7180

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: menu: Avoid discarding useful information

Konstantin Shkolnyy <kshk@linux.ibm.com>
    vdpa/mlx5: Fix mlx5_vdpa_get_config() endianness on big-endian machines

Mike Christie <michael.christie@oracle.com>
    vhost-scsi: Return queue full for page alloc failures during copy

Waiman Long <longman@redhat.com>
    x86/nmi: Add an emergency handler in nmi_desc & use it in nmi_shootdown_cpus()

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    ASoC: mediatek: mt8188: Add reference for dmic clocks

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    ASoC: mediatek: mt8188: Treat DMIC_GAINx_CUR as non-volatile

Yihan Zhu <Yihan.Zhu@amd.com>
    drm/amd/display: handle max_downscale_src_width fail check

Nir Lichtman <nir@lichtman.org>
    x86/build: Fix broken copy command in genimage.sh when making isoimage

Hariprasad Kelam <hkelam@marvell.com>
    Octeontx2-af: RPM: Register driver with PCI subsys IDs

Andrew Davis <afd@ti.com>
    soc: ti: k3-socinfo: Do not use syscon helper to build regmap

Ramasamy Kaliappan <quic_rkaliapp@quicinc.com>
    wifi: ath12k: Improve BSS discovery with hidden SSID in 6 GHz band

Hangbin Liu <liuhangbin@gmail.com>
    bonding: report duplicate MAC address in all situations

Arnd Bergmann <arnd@arndb.de>
    net: xgene-v2: remove incorrect ACPI_PTR annotation

Eric Woudstra <ericwouds@gmail.com>
    net: ethernet: mtk_ppe_offload: Allow QinQ, double ETH_P_8021Q only

Yuanjun Gong <ruc_gongyuanjun@163.com>
    leds: pwm-multicolor: Add check for fwnode_property_read_u32

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

Vinith Kumar R <quic_vinithku@quicinc.com>
    wifi: ath12k: Report proper tx completion status to mac80211

Hector Martin <marcan@marcan.st>
    soc: apple: rtkit: Implement OSLog buffers properly

Janne Grunau <j@jannau.net>
    soc: apple: rtkit: Use high prio work queue

Rob Herring (Arm) <robh@kernel.org>
    perf: arm_pmuv3: Call kvm_vcpu_pmu_resync_el0() before enabling counters

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
    media: uvcvideo: Handle uvc menu translation inside uvc_get_le_value

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Add sanity check to uvc_ioctl_xu_ctrl_map

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop2: Add uv swap for cluster window

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv4: fib: Move fib_valid_key_len() to rtm_to_fib_config().

Maciej S. Szmigiero <mail@maciej.szmigiero.name>
    ALSA: hda/realtek: Enable PC beep passthrough for HP EliteBook 855 G7

Saket Kumar Bhaskar <skb99@linux.ibm.com>
    perf/hw_breakpoint: Return EOPNOTSUPP for unsupported breakpoint type

Peter Seiderer <ps.report@gmx.net>
    net: pktgen: fix mpls maximum labels list parsing

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    net: ethernet: ti: cpsw_new: populate netdev of_node

Artur Weber <aweber.kernel@gmail.com>
    pinctrl: bcm281xx: Use "unsigned int" instead of bare "unsigned"

Hans Verkuil <hverkuil@xs4all.nl>
    media: cx231xx: set device_caps for 417

George Shen <george.shen@amd.com>
    drm/amd/display: Skip checking FRL_MODE bit for PCON BW determination

Victor Lu <victorchengchi.lu@amd.com>
    drm/amdgpu: Do not program AGP BAR regs under SRIOV in gfxhub_v1_0.c

Matti Lehtimäki <matti.lehtimaki@gmail.com>
    remoteproc: qcom_wcnss: Handle platforms with only single power domain

Choong Yong Liang <yong.liang.choong@linux.intel.com>
    net: phylink: use pl->link_interface in phylink_expects_phy()

Thomas Zimmermann <tzimmermann@suse.de>
    drm/gem: Test for imported GEM buffers with helper

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

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Improve data consistency at polling

Andreas Schwab <schwab@linux-m68k.org>
    powerpc/prom_init: Fixup missing #size-cells on PowerBook6,7

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Resize aperture for the IGX PCIe C5 slot

Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
    arm64: tegra: p2597: Fix gpio for vdd-1v8-dis regulator

Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
    drm/amdkfd: Set per-process flags only once cik/vi

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: lzo - Fix compression buffer overrun

Chin-Ting Kuo <chin-ting_kuo@aspeedtech.com>
    watchdog: aspeed: Update bootstatus handling

Aaron Kling <luceoscutum@gmail.com>
    cpufreq: tegra186: Share policy per cluster

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd/pgtbl_v2: Improve error handling

Alexey Klimov <alexey.klimov@linaro.org>
    ASoC: qcom: sm8250: explicitly set format in sm8250_be_hw_params_fixup()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    auxdisplay: charlcd: Partially revert "Move hwidth and bwidth to struct hd44780_common"

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Check for empty queue in run_queue

Leon Huang <Leon.Huang1@amd.com>
    drm/amd/display: Fix incorrect DPCD configs while Replay/PSR switch

Zhikai Zhai <zhikai.zhai@amd.com>
    drm/amd/display: calculate the remain segments for all pipes

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: remove minimum Dispclk and apply oem panel timing.

Willem de Bruijn <willemb@google.com>
    ipv6: save dontfrag in cork

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: fix debug actions order

Marcos Paulo de Souza <mpdesouza@suse.com>
    printk: Check CON_SUSPEND when unblanking a console

Kurt Borja <kuurtb@gmail.com>
    hwmon: (dell-smm) Increment the number of fans

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Don't change the status of stalled TDs on failed Stop EP

Erick Shepherd <erick.shepherd@ni.com>
    mmc: sdhci: Disable SD card clock before changing parameters

Kaustabh Chakraborty <kauschluss@disroot.org>
    mmc: dw_mmc: add exynos7870 DW MMC support

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

Baokun Li <libaokun1@huawei.com>
    ext4: do not convert the unwritten extents if data writeback fails

Baokun Li <libaokun1@huawei.com>
    ext4: reject the 'data_err=abort' option in nojournal mode

Ryan Walklin <ryan@testtoast.com>
    ASoC: sun4i-codec: support hp-det-gpios property

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Update SRIOV video codec caps

Shree Ramamoorthy <s-ramamoorthy@ti.com>
    mfd: tps65219: Remove TPS65219_REG_TI_DEV_ID check

Prathamesh Shete <pshete@nvidia.com>
    pinctrl-tegra: Restore SFSEL bit when freeing pins

Frediano Ziglio <frediano.ziglio@cloud.com>
    xen: Add support for XenServer 6.1 platform device

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: use the correct ndev to find pnetid by pnetid table

Mikulas Patocka <mpatocka@redhat.com>
    dm: restrict dm device size to 2^63-512 bytes

Shashank Gupta <shashankg@marvell.com>
    crypto: octeontx2 - suppress auth failure screaming due to negative tests

Seyediman Seyedarab <imandevel@gmail.com>
    kbuild: fix argument parsing in scripts/config

Yonghong Song <yonghong.song@linux.dev>
    bpf: Allow pre-ordering for bpf cgroup progs

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    ASoC: mediatek: mt6359: Add stub for mt6359_accdet_enable_jack_detect

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Do not add non-active NVM if NVM upgrade is disabled for retimer

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Fix error handling inconsistencies in check()

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: rv3032: fix EERD location

Ilpo Järvinen <ij@kernel.org>
    tcp: reorganize tcp_in_ack_event() and tcp_count_delivered()

Jan Kara <jack@suse.cz>
    jbd2: do not try to recover wiped journal

Mykyta Yatsenko <yatsenko@meta.com>
    bpf: Return prog btf_id without capable check

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Handle INTx IRQ_NOTCONNECTED

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: st: ERASE does not change tape location

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: st: Tighten the page format heuristics with MODE SELECT

Al Viro <viro@zeniv.linux.org.uk>
    hypfs_create_cpu_files(): add missing check for hypfs_mkdir() failure

Christian Göttsche <cgzones@googlemail.com>
    ext4: reorder capability check last

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Update min_low_pfn to match changes in uml_reserved

Benjamin Berg <benjamin@sipsolutions.net>
    um: Store full CSGSFS and SS register from mcontext

Heming Zhao <heming.zhao@suse.com>
    dlm: make tcp still work in multi-link env

Stanley Chu <yschu@nuvoton.com>
    i3c: master: svc: Fix missing STOP for master request

Jing Zhou <Jing.Zhou@amd.com>
    drm/amd/display: Guard against setting dispclk low for dcn31x

Filipe Manana <fdmanana@suse.com>
    btrfs: send: return -ENAMETOOLONG when attempting a path that is too long

Filipe Manana <fdmanana@suse.com>
    btrfs: get zone unusable bytes while holding lock at btrfs_reclaim_bgs_work()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix non-empty delayed iputs list on unmount due to async workers

Qu Wenruo <wqu@suse.com>
    btrfs: run btrfs_error_commit_super() early

Mark Harmstone <maharmstone@fb.com>
    btrfs: avoid linker error in btrfs_find_create_tree_block()

Boris Burkov <boris@bur.io>
    btrfs: make btrfs_discard_workfn() block_group ref explicit

Vitalii Mordan <mordan@ispras.ru>
    i2c: pxa: fix call balance of i2c->clk handling routines

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    i2c: qup: Vote for interconnect bandwidth to DRAM

Philip Redkin <me@rarity.fan>
    x86/mm: Check return value from memblock_phys_alloc_range()

Ingo Molnar <mingo@kernel.org>
    x86/stackprotector/64: Only export __ref_stack_chk_guard on CONFIG_SMP

Benjamin Lin <benjamin-jw.lin@mediatek.com>
    wifi: mt76: mt7996: revise TXS size

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: only mark tx-status-failed frames as ACKed on mt76x0/2

Erick Shepherd <erick.shepherd@ni.com>
    mmc: host: Wait for Vdd to settle on card power off

Robert Richter <rrichter@amd.com>
    libnvdimm/labels: Fix divide error in nd_label_data_init()

Nicolas Bretz <bretznic@gmail.com>
    ext4: on a remount, only log the ro or r/w state when it has changed

Roger Pau Monne <roger.pau@citrix.com>
    PCI: vmd: Disable MSI remapping bypass under Xen

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS/flexfiles: Report ENETDOWN as a connection error

Ian Rogers <irogers@google.com>
    tools/build: Don't pass test log files to linker

Frank Li <Frank.Li@nxp.com>
    PCI: dwc: ep: Ensure proper iteration over outbound map windows

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Properly disable uaccess validation

Ryo Takakura <ryotkkr98@gmail.com>
    lockdep: Fix wait context check on softirq for PREEMPT_RT

Jing Su <jingsusu@didiglobal.com>
    dql: Fix dql->limit value when reset.

Alice Guo <alice.guo@nxp.com>
    thermal/drivers/qoriq: Power down TMU on system suspend

Luis de Arquer <luis.dearquer@inertim.com>
    spi-rockchip: Fix register out of bounds access

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: rpcbind should never reset the port to the value '0'

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: rpc_clnt_set_transport() must not change the autobind setting

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Treat ENETUNREACH errors as fatal for state recovery

Pali Rohár <pali@kernel.org>
    cifs: Fix establishing NetBIOS session for SMB2+ connection

Namjae Jeon <linkinjeon@kernel.org>
    cifs: add validation check for the fields in smb_aces

Zsolt Kajtar <soci@c64.rulez.org>
    fbdev: core: tileblit: Implement missing margin clearing for tileblit

Zsolt Kajtar <soci@c64.rulez.org>
    fbcon: Use correct erase colour for clearing in fbcon

Shixiong Ou <oushixiong@kylinos.cn>
    fbdev: fsl-diu-fb: add missing device_remove_file()

Samuel Holland <samuel.holland@sifive.com>
    riscv: Allow NOMMU kernels to access all of RAM

Tudor Ambarus <tudor.ambarus@linaro.org>
    mailbox: use error ret code of of_parse_phandle_with_args()

Sudeep Holla <sudeep.holla@arm.com>
    mailbox: pcc: Use acpi_os_ioremap() instead of ioremap()

Diogo Ivo <diogo.ivo@siemens.com>
    ACPI: PNP: Add Intel OC Watchdog IDs to non-PNP device list

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    tracing: Mark binary printing functions with __printf() attribute

Jinqian Yang <yangjinqian1@huawei.com>
    arm64: Add support for HIP09 Spectre-BHB mitigation

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Don't allow waiting for exiting tasks

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't allow waiting for exiting tasks

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Check for delegation validity in nfs_start_delegation_return_locked()

Matt Johnston <matt@codeconstruct.com.au>
    fuse: Return EPERM rather than ENOSYS from link()

Wang Zhaolong <wangzhaolong1@huawei.com>
    smb: client: Store original IO parameters and prevent zero IO sizes

Pali Rohár <pali@kernel.org>
    cifs: Fix negotiate retry functionality

Pali Rohár <pali@kernel.org>
    cifs: Fix querying and creating MF symlinks over SMB1

Pali Rohár <pali@kernel.org>
    cifs: Add fallback for SMB2 CREATE without FILE_READ_ATTRIBUTES

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix no AP queue sharing allowed message written to kernel log

Daniel Gomez <da.gomez@samsung.com>
    kconfig: merge_config: use an empty file as initfile

Haoran Jiang <jianghaoran@kylinos.cn>
    samples/bpf: Fix compilation failure for samples/bpf on LoongArch Fedora

Brandon Kammerdiener <brandon.kammerdiener@intel.com>
    bpf: fix possible endless loop in BPF map iteration

Ihor Solodrai <ihor.solodrai@linux.dev>
    selftests/bpf: Mitigate sockmap_ktls disconnect_after_delete failure

Felix Kuehling <felix.kuehling@amd.com>
    drm/amdgpu: Allow P2P access through XGMI

Frederick Lawler <fred@cloudflare.com>
    ima: process_measurement() needlessly takes inode_lock() on MAY_READ

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: refactor bulk flipping of RX buffers to separate function

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Add level check to control event logging

Dongli Zhang <dongli.zhang@oracle.com>
    vhost-scsi: protect vq->log_used with vq->mutex

Stefano Garzarella <sgarzare@redhat.com>
    vhost_task: fix vhost_task_create() documentation

gaoxu <gaoxu2@honor.com>
    cgroup: Fix compilation issue due to cgroup_mutex not being exported

Marek Szyprowski <m.szyprowski@samsung.com>
    dma-mapping: avoid potential unused data compilation warning

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    intel_th: avoid using deprecated page->mapping, index fields

Zhongqiu Han <quic_zhonhan@quicinc.com>
    virtio_ring: Fix data race by tagging event_triggered as racy for KCSAN

Manish Pandey <quic_mapa@quicinc.com>
    scsi: ufs: Introduce quirk to extend PA_HIBERN8TIME for UFS devices

Dmitry Bogdanov <d.bogdanov@yadro.com>
    scsi: target: iscsi: Fix timeout on deleted connection

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    nvmem: qfprom: switch to 4-byte aligned reads

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    nvmem: core: update raw_len if the bit reading is required

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    nvmem: core: verify cell's raw_len

Heiko Stuebner <heiko@sntech.de>
    nvmem: rockchip-otp: add rk3576 variant data

Heiko Stuebner <heiko@sntech.de>
    nvmem: rockchip-otp: Move read-offset into variant-data

Pengyu Luo <mitltlatltl@gmail.com>
    cpufreq: Add SM8650 to cpufreq-dt-platdev blocklist

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    phy: renesas: rcar-gen3-usb2: Assert PLL reset on PHY power off

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    phy: renesas: rcar-gen3-usb2: Lock around hardware registers and driver data

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    phy: renesas: rcar-gen3-usb2: Move IRQ request in probe

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    phy: renesas: rcar-gen3-usb2: Add support to initialize the bus

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: designware: Fix an error handling path in i2c_dw_pci_probe()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    i2c: designware: Use temporary variable for struct device

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    i2c: designware: Remove ->disable() callback

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i2c: designware: Uniform initialization flow for polling mode

Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
    gpio: pca953x: fix IRQ storm on system wake up

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: pca953x: Simplify code with cleanup helpers

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: pca953x: Split pca953x_restore_context() and pca953x_save_context()


-------------

Diffstat:

 Documentation/ABI/stable/sysfs-driver-dma-idxd     |   6 +
 Documentation/admin-guide/kernel-parameters.txt    |   2 +
 Documentation/driver-api/serial/driver.rst         |   2 +-
 Documentation/hwmon/dell-smm-hwmon.rst             |  14 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/nvidia/tegra114.dtsi             |   2 +-
 arch/arm/mach-at91/pm.c                            |  21 +-
 .../boot/dts/allwinner/sun50i-h6-beelink-gs1.dts   |  38 +-
 .../boot/dts/allwinner/sun50i-h6-orangepi-3.dts    |  14 +-
 .../boot/dts/allwinner/sun50i-h6-orangepi.dtsi     |  22 +-
 arch/arm64/boot/dts/marvell/armada-3720-uDPU.dtsi  |   8 +-
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi     |   2 +-
 .../dts/nvidia/tegra234-p3740-0002+p3701-0008.dts  |  10 +
 arch/arm64/boot/dts/qcom/ipq9574.dtsi              |   2 +
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |   2 +
 arch/arm64/boot/dts/qcom/sm8550.dtsi               |   2 +
 arch/arm64/boot/dts/ti/k3-am68-sk-base-board.dts   |  13 +-
 arch/arm64/boot/dts/xilinx/zynqmp-clk-ccf.dtsi     |  15 +-
 arch/arm64/include/asm/cputype.h                   |   2 +
 arch/arm64/include/asm/pgtable.h                   |   3 +-
 arch/arm64/kernel/proton-pack.c                    |   1 +
 arch/mips/include/asm/ftrace.h                     |  16 +
 arch/mips/kernel/pm-cps.c                          |  30 +-
 arch/powerpc/include/asm/mmzone.h                  |   1 +
 arch/powerpc/kernel/prom_init.c                    |   4 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c           |   3 +-
 arch/powerpc/mm/numa.c                             |   2 +-
 arch/powerpc/perf/core-book3s.c                    |  20 +
 arch/powerpc/perf/isa207-common.c                  |   4 +-
 arch/powerpc/platforms/pseries/iommu.c             |  29 +-
 arch/riscv/include/asm/page.h                      |  12 +-
 arch/riscv/include/asm/pgtable.h                   |   2 +-
 arch/s390/hypfs/hypfs_diag_fs.c                    |   2 +
 arch/um/Makefile                                   |   1 +
 arch/um/kernel/mem.c                               |   1 +
 arch/x86/Makefile                                  |   2 +-
 arch/x86/boot/genimage.sh                          |   5 +-
 arch/x86/entry/entry.S                             |   2 +-
 arch/x86/events/amd/ibs.c                          |  20 +-
 arch/x86/include/asm/bug.h                         |   5 +-
 arch/x86/include/asm/ibt.h                         |   4 +-
 arch/x86/include/asm/nmi.h                         |   2 +
 arch/x86/include/asm/perf_event.h                  |   1 +
 arch/x86/kernel/cpu/bugs.c                         |  10 +-
 arch/x86/kernel/nmi.c                              |  42 ++
 arch/x86/kernel/reboot.c                           |  10 +-
 arch/x86/kernel/traps.c                            |  82 ++-
 arch/x86/mm/init.c                                 |   9 +-
 arch/x86/mm/init_64.c                              |  15 +-
 arch/x86/mm/kaslr.c                                |  10 +-
 arch/x86/um/os-Linux/mcontext.c                    |   3 +-
 crypto/ahash.c                                     |   4 +
 crypto/algif_hash.c                                |   4 -
 crypto/lzo-rle.c                                   |   2 +-
 crypto/lzo.c                                       |   2 +-
 crypto/skcipher.c                                  |   1 +
 drivers/accel/qaic/qaic_drv.c                      |   2 +-
 drivers/acpi/Kconfig                               |   2 +-
 drivers/acpi/acpi_pnp.c                            |   2 +
 drivers/acpi/hed.c                                 |   7 +-
 drivers/auxdisplay/charlcd.c                       |   5 +-
 drivers/auxdisplay/charlcd.h                       |   5 +-
 drivers/auxdisplay/hd44780.c                       |   2 +-
 drivers/auxdisplay/lcd2s.c                         |   2 +-
 drivers/auxdisplay/panel.c                         |   2 +-
 drivers/bluetooth/btusb.c                          |  98 ++-
 drivers/clk/clk-s2mps11.c                          |   3 +-
 drivers/clk/imx/clk-imx8mp.c                       | 151 ++++
 drivers/clk/qcom/Kconfig                           |   2 +-
 drivers/clk/qcom/camcc-sm8250.c                    |  56 +-
 drivers/clk/qcom/clk-alpha-pll.c                   |  52 +-
 drivers/clk/sunxi-ng/ccu-sun20i-d1.c               |  42 +-
 drivers/clk/sunxi-ng/ccu_mp.h                      |  22 +
 drivers/clocksource/mips-gic-timer.c               |   6 +-
 drivers/cpufreq/cpufreq-dt-platdev.c               |   1 +
 drivers/cpufreq/tegra186-cpufreq.c                 |   7 +
 drivers/cpuidle/governors/menu.c                   |  13 +-
 .../crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c   |   7 +-
 drivers/dma/fsl-edma-main.c                        |   2 +-
 drivers/dma/idxd/cdev.c                            |  20 +-
 drivers/dma/idxd/dma.c                             |   6 +
 drivers/dma/idxd/idxd.h                            |   9 +
 drivers/dma/idxd/sysfs.c                           |  34 +
 drivers/edac/ie31200_edac.c                        |  28 +-
 drivers/firmware/arm_ffa/bus.c                     |   1 +
 drivers/firmware/arm_ffa/driver.c                  |   8 +
 drivers/firmware/arm_scmi/bus.c                    |  19 +-
 drivers/fpga/altera-cvp.c                          |   2 +-
 drivers/gpio/gpio-pca953x.c                        | 111 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c        |  30 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   7 +-
 drivers/gpu/drm/amd/amdgpu/gfxhub_v1_0.c           |  10 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_7.c            |  25 +
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c            |  27 +
 drivers/gpu/drm/amd/amdgpu/mmhub_v9_4.c            |  31 +
 drivers/gpu/drm/amd/amdgpu/nv.c                    |  16 +-
 drivers/gpu/drm/amd/amdgpu/soc21.c                 |  10 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  39 +-
 .../drm/amd/amdkfd/kfd_device_queue_manager_cik.c  |  69 +-
 .../drm/amd/amdkfd/kfd_device_queue_manager_vi.c   |  77 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |  16 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   7 +-
 .../amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c |  22 +-
 .../amd/display/dc/clk_mgr/dcn316/dcn316_clk_mgr.c |  15 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   1 +
 .../amd/display/dc/dce110/dce110_hw_sequencer.c    |   3 +-
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c   |  11 +-
 .../drm/amd/display/dc/dcn315/dcn315_resource.c    |  40 +-
 drivers/gpu/drm/amd/display/dc/inc/core_types.h    |   2 +-
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c    |  13 +-
 .../display/dc/link/protocols/link_dp_capability.c |  33 +-
 .../amd/display/dc/link/protocols/link_dp_phy.c    |   8 +-
 .../dc/link/protocols/link_dp_training_8b_10b.c    |   7 +-
 .../dc/link/protocols/link_edp_panel_control.c     |  25 +-
 .../include/asic_reg/mmhub/mmhub_9_4_1_offset.h    |  32 +
 .../include/asic_reg/mmhub/mmhub_9_4_1_sh_mask.h   |  48 ++
 drivers/gpu/drm/ast/ast_mode.c                     |  10 +-
 drivers/gpu/drm/bridge/adv7511/adv7511_audio.c     |   2 +
 drivers/gpu/drm/drm_atomic_helper.c                |  28 +
 drivers/gpu/drm/drm_edid.c                         |   1 +
 drivers/gpu/drm/drm_gem.c                          |   4 +-
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |   5 +-
 drivers/gpu/drm/panel/panel-edp.c                  |   1 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |   6 +-
 drivers/gpu/drm/v3d/v3d_drv.c                      |  25 +-
 drivers/hid/hid-ids.h                              |   4 +
 drivers/hid/hid-quirks.c                           |   2 +
 drivers/hid/usbhid/usbkbd.c                        |   2 +-
 drivers/hwmon/dell-smm-hwmon.c                     |   5 +-
 drivers/hwmon/gpio-fan.c                           |  16 +-
 drivers/hwmon/xgene-hwmon.c                        |   2 +-
 drivers/hwtracing/intel_th/Kconfig                 |   1 +
 drivers/hwtracing/intel_th/msu.c                   |  31 +-
 drivers/i2c/busses/i2c-designware-common.c         |   1 +
 drivers/i2c/busses/i2c-designware-core.h           |   5 +-
 drivers/i2c/busses/i2c-designware-master.c         |  43 +-
 drivers/i2c/busses/i2c-designware-pcidrv.c         |  40 +-
 drivers/i2c/busses/i2c-designware-platdrv.c        |  54 +-
 drivers/i2c/busses/i2c-designware-slave.c          |   3 +-
 drivers/i2c/busses/i2c-pxa.c                       |   5 +-
 drivers/i2c/busses/i2c-qup.c                       |  36 +
 drivers/i3c/master/svc-i3c-master.c                |   4 +
 drivers/infiniband/core/umem.c                     |  36 +-
 drivers/infiniband/core/uverbs_cmd.c               | 144 ++--
 drivers/infiniband/core/verbs.c                    |  11 +-
 drivers/input/joystick/xpad.c                      |   3 +
 drivers/iommu/amd/io_pgtable_v2.c                  |   2 +-
 drivers/iommu/dma-iommu.c                          |  28 +-
 drivers/leds/rgb/leds-pwm-multicolor.c             |   5 +-
 drivers/leds/trigger/ledtrig-netdev.c              |  16 +-
 drivers/mailbox/mailbox.c                          |   7 +-
 drivers/mailbox/pcc.c                              |   8 +-
 drivers/md/dm-cache-target.c                       |  24 +
 drivers/md/dm-table.c                              |   4 +
 drivers/md/dm.c                                    |   8 +-
 drivers/media/i2c/adv7180.c                        |  34 +-
 drivers/media/i2c/imx219.c                         |   2 +-
 drivers/media/i2c/tc358746.c                       |  19 +-
 drivers/media/platform/qcom/camss/camss-csid.c     |  64 +-
 .../platform/st/sti/c8sectpfe/c8sectpfe-core.c     |   3 +-
 .../media/test-drivers/vivid/vivid-kthread-cap.c   |  11 +-
 .../media/test-drivers/vivid/vivid-kthread-out.c   |  11 +-
 .../media/test-drivers/vivid/vivid-kthread-touch.c |  11 +-
 drivers/media/test-drivers/vivid/vivid-sdr-cap.c   |  11 +-
 drivers/media/usb/cx231xx/cx231xx-417.c            |   2 +
 drivers/media/usb/uvc/uvc_ctrl.c                   |  77 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |   6 +
 drivers/media/v4l2-core/v4l2-subdev.c              |   2 +
 drivers/mfd/tps65219.c                             |   7 -
 drivers/mmc/host/dw_mmc-exynos.c                   |  41 +-
 drivers/mmc/host/sdhci-pci-core.c                  |   6 +-
 drivers/mmc/host/sdhci.c                           |   9 +-
 drivers/net/bonding/bond_main.c                    |   2 +-
 drivers/net/can/c_can/c_can_platform.c             |   2 +-
 drivers/net/can/kvaser_pciefd.c                    |  90 ++-
 drivers/net/can/slcan/slcan-core.c                 |  26 +-
 drivers/net/ethernet/amd/pds_core/core.c           |   5 +-
 drivers/net/ethernet/amd/pds_core/core.h           |   2 +-
 drivers/net/ethernet/apm/xgene-v2/main.c           |   4 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |  16 +-
 drivers/net/ethernet/freescale/fec_main.c          |  52 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   3 +-
 drivers/net/ethernet/intel/ice/ice_irq.c           |  25 +-
 drivers/net/ethernet/intel/ice/ice_lag.c           |   6 +
 drivers/net/ethernet/intel/ice/ice_lib.c           |   2 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |   1 -
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  14 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cn10k.c  |  24 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  11 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   8 +-
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |  22 +-
 drivers/net/ethernet/mellanox/mlx4/alloc.c         |   6 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   2 -
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   5 +
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c  |   3 +
 .../net/ethernet/mellanox/mlx5/core/esw/legacy.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/events.c   |  11 +-
 .../net/ethernet/mellanox/mlx5/core/fs_ft_pool.c   |   6 +-
 .../net/ethernet/mellanox/mlx5/core/fs_ft_pool.h   |   2 -
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   1 +
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |   3 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |  19 +-
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |   2 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   2 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |   1 +
 drivers/net/ieee802154/ca8210.c                    |   9 +-
 drivers/net/phy/phylink.c                          |   2 +-
 drivers/net/usb/r8152.c                            |   1 +
 drivers/net/vxlan/vxlan_core.c                     |  36 +-
 drivers/net/wireless/ath/ath12k/core.h             |   1 +
 drivers/net/wireless/ath/ath12k/dp_tx.c            |   6 +-
 drivers/net/wireless/ath/ath12k/hal_desc.h         |   2 +-
 drivers/net/wireless/ath/ath12k/pci.c              |  13 +-
 drivers/net/wireless/ath/ath12k/wmi.c              |   4 +-
 drivers/net/wireless/ath/ath9k/init.c              |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |  10 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   2 +
 drivers/net/wireless/mediatek/mt76/mt76.h          |   1 +
 .../net/wireless/mediatek/mt76/mt76_connac3_mac.h  |   3 +
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |   4 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |   3 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  17 +-
 drivers/net/wireless/realtek/rtw88/mac.c           |   6 +-
 drivers/net/wireless/realtek/rtw88/main.c          |  40 +-
 drivers/net/wireless/realtek/rtw88/reg.h           |   3 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |  14 +-
 drivers/net/wireless/realtek/rtw88/util.c          |   3 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |   2 -
 drivers/net/wireless/realtek/rtw89/regd.c          |   2 +
 drivers/net/wireless/realtek/rtw89/ser.c           |   4 +
 drivers/nvdimm/label.c                             |   3 +-
 drivers/nvme/host/pci.c                            |   8 +
 drivers/nvme/target/tcp.c                          |   3 +
 drivers/nvmem/core.c                               |  16 +-
 drivers/nvmem/qfprom.c                             |  26 +-
 drivers/nvmem/rockchip-otp.c                       |  17 +-
 drivers/pci/Kconfig                                |   6 +
 drivers/pci/controller/dwc/pcie-designware-ep.c    |   2 +-
 drivers/pci/controller/pcie-brcmstb.c              |   5 +-
 drivers/pci/controller/vmd.c                       |  20 +
 drivers/pci/setup-bus.c                            |   6 +-
 drivers/perf/arm-cmn.c                             |  10 +-
 drivers/perf/arm_pmuv3.c                           |   4 +-
 drivers/phy/phy-core.c                             |   7 +-
 drivers/phy/renesas/phy-rcar-gen3-usb2.c           | 143 ++--
 drivers/phy/starfive/phy-jh7110-usb.c              |   7 +
 drivers/pinctrl/bcm/pinctrl-bcm281xx.c             |  44 +-
 drivers/pinctrl/devicetree.c                       |  10 +-
 drivers/pinctrl/meson/pinctrl-meson.c              |   2 +-
 drivers/pinctrl/qcom/pinctrl-apq8064.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-apq8084.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-ipq4019.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-ipq5018.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-ipq5332.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-ipq6018.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-ipq8064.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-ipq8074.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-ipq9574.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-mdm9607.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-mdm9615.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-msm.c                 |  27 +-
 drivers/pinctrl/qcom/pinctrl-msm.h                 |   2 +-
 drivers/pinctrl/qcom/pinctrl-msm8226.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-msm8660.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-msm8909.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-msm8916.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-msm8953.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-msm8960.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-msm8976.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-msm8994.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-msm8996.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-msm8998.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-msm8x74.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-qcm2290.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-qcs404.c              |   2 +-
 drivers/pinctrl/qcom/pinctrl-qdf2xxx.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-qdu1000.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-sa8775p.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-sc7180.c              |   2 +-
 drivers/pinctrl/qcom/pinctrl-sc7280.c              |   2 +-
 drivers/pinctrl/qcom/pinctrl-sc8180x.c             |   2 +-
 drivers/pinctrl/qcom/pinctrl-sc8280xp.c            |   2 +-
 drivers/pinctrl/qcom/pinctrl-sdm660.c              |   2 +-
 drivers/pinctrl/qcom/pinctrl-sdm670.c              |   2 +-
 drivers/pinctrl/qcom/pinctrl-sdm845.c              |   2 +-
 drivers/pinctrl/qcom/pinctrl-sdx55.c               |   2 +-
 drivers/pinctrl/qcom/pinctrl-sdx65.c               |   2 +-
 drivers/pinctrl/qcom/pinctrl-sdx75.c               |   2 +-
 drivers/pinctrl/qcom/pinctrl-sm6115.c              |   2 +-
 drivers/pinctrl/qcom/pinctrl-sm6125.c              |   2 +-
 drivers/pinctrl/qcom/pinctrl-sm6350.c              |   2 +-
 drivers/pinctrl/qcom/pinctrl-sm6375.c              |   2 +-
 drivers/pinctrl/qcom/pinctrl-sm7150.c              |   2 +-
 drivers/pinctrl/qcom/pinctrl-sm8150.c              |   2 +-
 drivers/pinctrl/qcom/pinctrl-sm8250.c              |   2 +-
 drivers/pinctrl/qcom/pinctrl-sm8350.c              |   2 +-
 drivers/pinctrl/qcom/pinctrl-sm8450.c              |   2 +-
 drivers/pinctrl/qcom/pinctrl-sm8550.c              |   2 +-
 drivers/pinctrl/tegra/pinctrl-tegra.c              |  59 +-
 drivers/pinctrl/tegra/pinctrl-tegra.h              |   6 +
 .../x86/dell/dell-wmi-sysman/passobj-attributes.c  |   2 +-
 drivers/platform/x86/fujitsu-laptop.c              |  33 +-
 drivers/platform/x86/thinkpad_acpi.c               |   7 +
 drivers/pmdomain/imx/gpcv2.c                       |   2 +-
 drivers/regulator/ad5398.c                         |  12 +-
 drivers/remoteproc/qcom_wcnss.c                    |  34 +-
 drivers/rtc/rtc-ds1307.c                           |   4 +-
 drivers/rtc/rtc-rv3032.c                           |   2 +-
 drivers/s390/crypto/vfio_ap_ops.c                  |  72 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  17 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   2 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |   3 +
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |  12 +-
 drivers/scsi/st.c                                  |  29 +-
 drivers/scsi/st.h                                  |   2 +
 drivers/soc/apple/rtkit-internal.h                 |   1 +
 drivers/soc/apple/rtkit.c                          |  58 +-
 drivers/soc/ti/k3-socinfo.c                        |  13 +-
 drivers/soundwire/amd_manager.c                    |   2 +
 drivers/soundwire/bus.c                            |   9 +-
 drivers/spi/spi-fsl-dspi.c                         |  46 +-
 drivers/spi/spi-rockchip.c                         |   2 +-
 drivers/spi/spi-sun4i.c                            |   5 +-
 drivers/spi/spi-zynqmp-gqspi.c                     |  22 +-
 drivers/target/iscsi/iscsi_target.c                |   2 +-
 drivers/target/target_core_spc.c                   |  14 +-
 drivers/thermal/intel/x86_pkg_temp_thermal.c       |   1 +
 drivers/thermal/qoriq_thermal.c                    |  13 +
 drivers/thunderbolt/retimer.c                      |   8 +-
 drivers/tty/serial/8250/8250_port.c                |   2 +-
 drivers/tty/serial/atmel_serial.c                  |   2 +-
 drivers/tty/serial/imx.c                           |   2 +-
 drivers/tty/serial/serial_mctrl_gpio.c             |  34 +-
 drivers/tty/serial/serial_mctrl_gpio.h             |  17 +-
 drivers/tty/serial/sh-sci.c                        |  98 ++-
 drivers/tty/serial/stm32-usart.c                   |   2 +-
 drivers/ufs/core/ufshcd.c                          |  29 +
 drivers/usb/host/xhci-ring.c                       |  12 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |   3 +
 drivers/vfio/pci/vfio_pci_config.c                 |   3 +-
 drivers/vfio/pci/vfio_pci_core.c                   |  10 +-
 drivers/vfio/pci/vfio_pci_intrs.c                  |   2 +-
 drivers/vhost/scsi.c                               |  23 +-
 drivers/video/fbdev/core/bitblit.c                 |   5 +-
 drivers/video/fbdev/core/fbcon.c                   |  10 +-
 drivers/video/fbdev/core/fbcon.h                   |  38 +-
 drivers/video/fbdev/core/fbcon_ccw.c               |   5 +-
 drivers/video/fbdev/core/fbcon_cw.c                |   5 +-
 drivers/video/fbdev/core/fbcon_ud.c                |   5 +-
 drivers/video/fbdev/core/tileblit.c                |  45 +-
 drivers/video/fbdev/fsl-diu-fb.c                   |   1 +
 drivers/virtio/virtio_ring.c                       |   2 +-
 drivers/watchdog/aspeed_wdt.c                      |  81 ++-
 drivers/xen/platform-pci.c                         |   4 +
 drivers/xen/xenbus/xenbus_probe.c                  |  14 +-
 fs/btrfs/block-group.c                             |  18 +-
 fs/btrfs/discard.c                                 |  34 +-
 fs/btrfs/disk-io.c                                 |  28 +-
 fs/btrfs/extent_io.c                               |   7 +-
 fs/btrfs/relocation.c                              |   6 +
 fs/btrfs/scrub.c                                   |   4 +-
 fs/btrfs/send.c                                    |   6 +-
 fs/coredump.c                                      |  81 ++-
 fs/dlm/lowcomms.c                                  |   4 +-
 fs/ext4/balloc.c                                   |   4 +-
 fs/ext4/ext4.h                                     |   5 +-
 fs/ext4/extents.c                                  |  19 +-
 fs/ext4/inode.c                                    |  81 ++-
 fs/ext4/page-io.c                                  |  16 +-
 fs/ext4/super.c                                    |  19 +-
 fs/f2fs/sysfs.c                                    |  74 +-
 fs/fuse/dir.c                                      |   2 +
 fs/gfs2/glock.c                                    |  11 +-
 fs/jbd2/recovery.c                                 |  11 +-
 fs/namespace.c                                     |   6 +-
 fs/nfs/client.c                                    |   2 +
 fs/nfs/delegation.c                                |   3 +-
 fs/nfs/dir.c                                       |  15 +-
 fs/nfs/filelayout/filelayoutdev.c                  |   6 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |   1 +
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   6 +-
 fs/nfs/inode.c                                     |   2 +
 fs/nfs/internal.h                                  |   5 +
 fs/nfs/nfs3proc.c                                  |   2 +-
 fs/nfs/nfs4proc.c                                  |   9 +-
 fs/nfs/nfs4state.c                                 |  10 +-
 fs/nfs/pnfs.h                                      |   4 +-
 fs/nfs/pnfs_nfs.c                                  |   9 +-
 fs/orangefs/inode.c                                |   7 +-
 fs/pstore/inode.c                                  |   2 +-
 fs/pstore/internal.h                               |   4 +-
 fs/pstore/platform.c                               |  11 +-
 fs/smb/client/cifsacl.c                            |  17 +-
 fs/smb/client/cifspdu.h                            |   5 +-
 fs/smb/client/cifsproto.h                          |   7 +
 fs/smb/client/cifssmb.c                            |  57 ++
 fs/smb/client/connect.c                            |  30 +-
 fs/smb/client/fs_context.c                         |   2 +
 fs/smb/client/fs_context.h                         |   3 +
 fs/smb/client/link.c                               |   8 +-
 fs/smb/client/readdir.c                            |   7 +-
 fs/smb/client/smb1ops.c                            | 228 +++++-
 fs/smb/client/smb2file.c                           |  11 +-
 fs/smb/client/smb2ops.c                            |  30 +-
 fs/smb/client/transport.c                          |   2 +-
 fs/smb/common/smb2pdu.h                            |   3 +
 fs/smb/server/oplock.c                             |   7 +-
 fs/smb/server/vfs.c                                |  14 +-
 include/crypto/hash.h                              |   3 +
 include/drm/drm_atomic.h                           |  23 +-
 include/drm/drm_gem.h                              |  13 +
 include/linux/bpf-cgroup.h                         |   1 +
 include/linux/coredump.h                           |   1 +
 include/linux/dma-mapping.h                        |  12 +-
 include/linux/highmem.h                            |   6 +-
 include/linux/hrtimer.h                            |   1 +
 include/linux/ipv6.h                               |   1 +
 include/linux/lzo.h                                |   8 +
 include/linux/mlx4/device.h                        |   2 +-
 include/linux/mlx5/fs.h                            |   2 +
 include/linux/msi.h                                |  33 +-
 include/linux/nfs_fs_sb.h                          |  12 +-
 include/linux/page-flags.h                         |   7 +
 include/linux/perf_event.h                         |   8 +-
 include/linux/rcupdate.h                           |   2 +-
 include/linux/rcutree.h                            |   2 +-
 include/linux/trace.h                              |   4 +-
 include/linux/trace_seq.h                          |   8 +-
 include/linux/usb/r8152.h                          |   1 +
 include/media/v4l2-subdev.h                        |   4 +-
 include/net/af_unix.h                              |  49 +-
 include/net/scm.h                                  |  11 +
 include/net/xfrm.h                                 |   1 -
 include/rdma/uverbs_std_types.h                    |   2 +-
 include/sound/hda_codec.h                          |   1 +
 include/sound/pcm.h                                |   2 +
 include/trace/events/btrfs.h                       |   2 +-
 include/uapi/linux/bpf.h                           |   1 +
 include/uapi/linux/idxd.h                          |   1 +
 include/ufs/ufs_quirks.h                           |   6 +
 io_uring/fdinfo.c                                  |   4 +-
 io_uring/io_uring.c                                |   1 +
 kernel/bpf/cgroup.c                                |  33 +-
 kernel/bpf/hashtab.c                               |   2 +-
 kernel/bpf/syscall.c                               |   7 +-
 kernel/bpf/verifier.c                              |   4 +
 kernel/cgroup/cgroup.c                             |   2 +-
 kernel/events/core.c                               |  33 +-
 kernel/events/hw_breakpoint.c                      |   5 +-
 kernel/events/ring_buffer.c                        |   1 +
 kernel/fork.c                                      |   9 +-
 kernel/padata.c                                    |   3 +-
 kernel/printk/printk.c                             |  14 +-
 kernel/rcu/tree_plugin.h                           |  22 +-
 kernel/sched/fair.c                                |   6 +-
 kernel/softirq.c                                   |  18 +
 kernel/time/hrtimer.c                              | 103 ++-
 kernel/time/posix-timers.c                         |   1 +
 kernel/time/timer_list.c                           |   4 +-
 kernel/trace/trace.c                               |  11 +-
 kernel/trace/trace.h                               |  16 +-
 kernel/vhost_task.c                                |   2 +-
 lib/dynamic_queue_limits.c                         |   2 +-
 lib/lzo/Makefile                                   |   2 +-
 lib/lzo/lzo1x_compress.c                           | 102 ++-
 lib/lzo/lzo1x_compress_safe.c                      |  18 +
 mm/memcontrol.c                                    |   6 +-
 mm/page_alloc.c                                    |   8 +
 net/Makefile                                       |   2 +-
 net/bluetooth/l2cap_core.c                         |  15 +-
 net/bridge/br_mdb.c                                |   2 +-
 net/bridge/br_nf_core.c                            |   7 +-
 net/bridge/br_private.h                            |   1 +
 net/can/bcm.c                                      |  79 ++-
 net/core/pktgen.c                                  |  13 +-
 net/core/scm.c                                     |  17 +
 net/ipv4/esp4.c                                    |  49 +-
 net/ipv4/fib_frontend.c                            |  18 +-
 net/ipv4/fib_rules.c                               |   4 +-
 net/ipv4/fib_trie.c                                |  22 -
 net/ipv4/inet_hashtables.c                         |  37 +-
 net/ipv4/ip_gre.c                                  |  16 +-
 net/ipv4/tcp_input.c                               |  56 +-
 net/ipv6/esp6.c                                    |  49 +-
 net/ipv6/fib6_rules.c                              |   4 +-
 net/ipv6/ip6_output.c                              |   9 +-
 net/llc/af_llc.c                                   |   8 +-
 net/mac80211/mlme.c                                |   4 +-
 net/netfilter/nf_conntrack_standalone.c            |  12 +-
 net/sched/sch_hfsc.c                               |  15 +-
 net/smc/smc_pnet.c                                 |   8 +-
 net/sunrpc/clnt.c                                  |   3 -
 net/sunrpc/rpcb_clnt.c                             |   5 +-
 net/sunrpc/sched.c                                 |   2 +
 net/tipc/crypto.c                                  |   5 +
 net/unix/Kconfig                                   |   5 -
 net/unix/Makefile                                  |   2 -
 net/unix/af_unix.c                                 | 120 ++--
 net/unix/garbage.c                                 | 779 ++++++++++++++-------
 net/unix/scm.c                                     | 161 -----
 net/unix/scm.h                                     |  10 -
 net/xfrm/xfrm_policy.c                             |   3 +
 net/xfrm/xfrm_state.c                              |   6 +-
 samples/bpf/Makefile                               |   2 +-
 scripts/config                                     |  26 +-
 scripts/kconfig/merge_config.sh                    |   4 +-
 security/integrity/ima/ima_main.c                  |   4 +-
 security/smack/smackfs.c                           |  21 +-
 sound/core/oss/pcm_oss.c                           |   3 +-
 sound/core/pcm_native.c                            |  11 +
 sound/core/seq/seq_clientmgr.c                     |   5 +-
 sound/core/seq/seq_memory.c                        |   1 +
 sound/pci/hda/hda_beep.c                           |  15 +-
 sound/pci/hda/patch_realtek.c                      |  77 +-
 sound/soc/codecs/cs42l43-jack.c                    |   7 +
 sound/soc/codecs/mt6359-accdet.h                   |   9 +
 sound/soc/codecs/pcm3168a.c                        |   6 +-
 sound/soc/codecs/rt722-sdca-sdw.c                  |  49 +-
 sound/soc/codecs/tas2764.c                         |  53 +-
 sound/soc/fsl/imx-card.c                           |   2 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |  13 +
 sound/soc/mediatek/mt8188/mt8188-afe-clk.c         |   8 +
 sound/soc/mediatek/mt8188/mt8188-afe-clk.h         |   8 +
 sound/soc/mediatek/mt8188/mt8188-afe-pcm.c         |   4 -
 sound/soc/qcom/sm8250.c                            |   3 +
 sound/soc/soc-dai.c                                |   8 +-
 sound/soc/soc-ops.c                                |  29 +-
 sound/soc/sof/ipc4-control.c                       |  11 +-
 sound/soc/sof/ipc4-pcm.c                           |   3 +-
 sound/soc/sof/topology.c                           |  18 +-
 sound/soc/sunxi/sun4i-codec.c                      |  53 ++
 tools/bpf/bpftool/common.c                         |   3 +-
 tools/build/Makefile.build                         |   6 +-
 tools/include/uapi/linux/bpf.h                     |   1 +
 tools/lib/bpf/libbpf.c                             |   2 +-
 tools/net/ynl/lib/ynl.c                            |   2 +-
 tools/objtool/check.c                              |  21 +-
 tools/testing/kunit/qemu_configs/x86_64.py         |   4 +-
 .../selftests/bpf/prog_tests/sockmap_ktls.c        |   1 -
 .../testing/selftests/net/forwarding/bridge_mdb.sh |   2 +-
 tools/testing/selftests/net/gro.sh                 |   3 +-
 552 files changed, 5765 insertions(+), 2788 deletions(-)


