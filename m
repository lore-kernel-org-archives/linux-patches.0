Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE483A7E0B;
	Thu, 15 Jan 2026 16:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495998; cv=none; b=mnelTUPICDoZ+eygwp38kU+mJgnmvdnwt5H3ufW92pShJdDU8AmXdk17trBIdlzlVo0jRRn+xyWdjSnweJx8N180B/IRSAFYjy6OUMduwgJkNMIiQeVKIHA+xKimoyFeAXPaMn6s013KkL3ih9LkhHi0fwxjlSiVc3xx0Gz/Vdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495998; c=relaxed/simple;
	bh=gsitTm2oAH1qAeKo79cNinL+tmi3P3cicycE80RZVuA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MSNwkVDlggfIpEV932nm2qiP03seeylm2qtsq9hR82Rg3uiCfwdGWTypC6Oks30dyU5TLq/FDujBvPgWk4OgwgMg0bXihQ3etwdsd8WZre7NAUsgE6EqS3Q1FsRGLfGC13Rf2Ps8ZjNrWFLJ+FRWZp3VO0n9LCEhL2FrpCqHvnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPVn/uEX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPVn/uEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38EA1C116D0;
	Thu, 15 Jan 2026 16:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495997;
	bh=gsitTm2oAH1qAeKo79cNinL+tmi3P3cicycE80RZVuA=;
	h=From:To:Cc:Subject:Date:From;
	b=pPVn/uEXpWR9TF8dCy/8MjCWI0wdvoDneMORaRUgmHseqYOud9JjwltiQR378RHdg
	 i2oUeKg5OJVqyF9PCwBYKB30ybitYo8038/mwpvpPQPr4rBlIHq2RGYOcBJtq4UWAj
	 ahNEW/T9rJMjR8cUp8iE+SYmFSeJ65PjLFC24Ryk=
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.18 000/181] 6.18.6-rc1 review
Date: Thu, 15 Jan 2026 17:45:37 +0100
Message-ID: <20260115164202.305475649@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.6-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.6-rc1
X-KernelTest-Deadline: 2026-01-17T16:42+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.6 release.
There are 181 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.6-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.6-rc1

Mateusz Litwin <mateusz.litwin@nokia.com>
    spi: cadence-quadspi: Prevent lost complete() call during indirect read

Michal Rábek <mrabek@redhat.com>
    scsi: sg: Fix occasional bogus elapsed time that exceeds timeout

Alexander Stein <alexander.stein@ew.tq-group.com>
    ASoC: fsl_sai: Add missing registers to cache default

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/realtek: enable woofer speakers on Medion NM14LNL

Andrew Elantsev <elantsew.andrew@gmail.com>
    ASoC: amd: yc: Add quirk for Honor MagicBook X16 2025

Jussi Laako <jussi@sonarnerd.net>
    ALSA: usb-audio: Update for native DSD support quirks

Caleb Sander Mateos <csander@purestorage.com>
    block: validate pi_offset integrity limit

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: make j1939_session_activate() fail if device is no longer registered

Brian Kocoloski <brian.kocoloski@amd.com>
    drm/amdkfd: Fix improper NULL termination of queue restore SMI event string

Fei Shao <fshao@chromium.org>
    spi: mt65xx: Use IRQF_ONESHOT with threaded IRQ

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: Fix DP no audio issue

Mario Limonciello (AMD) <superm1@kernel.org>
    accel/amdxdna: Block running under a hypervisor

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Disable LPM on ST2000DM008-2FR102

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: avoid chain re-validation if possible

Sumeet Pawnikar <sumeet4linux@gmail.com>
    powercap: fix sscanf() error return value handling

Sumeet Pawnikar <sumeet4linux@gmail.com>
    powercap: fix race condition in register_control_type()

Marcus Hughes <marcus.hughes@betterinternet.ltd>
    net: sfp: extend Potron XGSPON quirk to cover additional EEPROM variant

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    bpf: Fix reference count leak in bpf_prog_test_run_xdp()

Toke Høiland-Jørgensen <toke@redhat.com>
    bpf, test_run: Subtract size of xdp_frame from allowed metadata size

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    gpio: mpsse: fix reference leak in gpio_mpsse_probe() error paths

Mary Strodl <mstrodl@csh.rit.edu>
    gpio: mpsse: add quirk support

Mary Strodl <mstrodl@csh.rit.edu>
    gpio: mpsse: ensure worker is torn down

Qu Wenruo <wqu@suse.com>
    btrfs: fix beyond-EOF write handling

Filipe Manana <fdmanana@suse.com>
    btrfs: use variable for end offset in extent_writepage_io()

Filipe Manana <fdmanana@suse.com>
    btrfs: truncate ordered extent when skipping writeback past i_size

Gao Xiang <xiang@kernel.org>
    erofs: fix file-backed mounts no longer working on EROFS partitions

Gao Xiang <xiang@kernel.org>
    erofs: don't bother with s_stack_depth increasing for now

Lorenzo Pieralisi <lpieralisi@kernel.org>
    irqchip/gic-v5: Fix gicv5_its_map_event() ITTE read endianness

Ming Lei <ming.lei@redhat.com>
    ublk: fix use-after-free in ublk_partition_scan_work

Eric Dumazet <edumazet@google.com>
    arp: do not assume dev_hard_header() does not change skb->head

Wei Fang <wei.fang@nxp.com>
    net: enetc: fix build warning when PAGE_SIZE is greater than 128K

Petko Manolov <petkan@nucleusys.com>
    net: usb: pegasus: fix memory leak in update_eth_regs_async()

Xiang Mei <xmei5@asu.edu>
    net/sched: sch_qfq: Fix NULL deref when deactivating inactive aggregate in qfq_reset

Benjamin Berg <benjamin.berg@intel.com>
    wifi: mac80211_hwsim: fix typo in frequency notification

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Fix schedule while atomic in airoha_ppe_deinit()

René Rebe <rene@exactco.de>
    HID: quirks: work around VID/PID conflict for appledisplay

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    sparc/PCI: Correct 64-bit non-pref -> pref BAR resources

Ben Dooks <ben.dooks@codethink.co.uk>
    trace: ftrace_dump_on_oops[] is not exported, make it static

Caleb Sander Mateos <csander@purestorage.com>
    block: don't merge bios with different app_tags

Yohei Kojima <yk@y-koj.net>
    net: netdevsim: fix inconsistent carrier state after link/unlink

Gal Pressman <gal@nvidia.com>
    selftests: drv-net: Bring back tool() to driver __init__s

Shivani Gupta <shivani07g@gmail.com>
    net/sched: act_api: avoid dereferencing ERR_PTR in tcf_idrinfo_destroy

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: sfp: return the number of written bytes for smbus single byte access

Eric Dumazet <edumazet@google.com>
    udp: call skb_orphan() before skb_attempt_defer_free()

Vladimir Oltean <vladimir.oltean@nxp.com>
    Revert "dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude configurable"

Larysa Zaremba <larysa.zaremba@intel.com>
    idpf: fix aux device unplugging when rdma is not supported by vport

Joshua Hay <joshua.a.hay@intel.com>
    idpf: cap maximum Rx buffer size

Sreedevi Joshi <sreedevi.joshi@intel.com>
    idpf: Fix error handling in idpf_vport_open()

Sreedevi Joshi <sreedevi.joshi@intel.com>
    idpf: Fix RSS LUT NULL ptr issue after soft reset

Sreedevi Joshi <sreedevi.joshi@intel.com>
    idpf: Fix RSS LUT configuration on down interfaces

Sreedevi Joshi <sreedevi.joshi@intel.com>
    idpf: Fix RSS LUT NULL pointer crash on early ethtool operations

Erik Gabriel Carrillo <erik.g.carrillo@intel.com>
    idpf: fix issue with ethtool -n command display

Sreedevi Joshi <sreedevi.joshi@intel.com>
    idpf: fix memory leak of flow steer list on rmmod

Emil Tantilov <emil.s.tantilov@intel.com>
    idpf: fix error handling in the init_task on load

Emil Tantilov <emil.s.tantilov@intel.com>
    idpf: fix memory leak in idpf_vc_core_deinit()

Emil Tantilov <emil.s.tantilov@intel.com>
    idpf: fix memory leak in idpf_vport_rel()

Emil Tantilov <emil.s.tantilov@intel.com>
    idpf: detach and close netdevs while handling a reset

Emil Tantilov <emil.s.tantilov@intel.com>
    idpf: convert vport state to bitmap

Emil Tantilov <emil.s.tantilov@intel.com>
    idpf: keep the netdev when a reset fails

Mario Limonciello (AMD) <superm1@kernel.org>
    PCI/VGA: Don't assume the only VGA device on a system is `boot_vga`

Mohammad Heib <mheib@redhat.com>
    net: fix memory leak in skb_segment_list for GRO packets

Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
    riscv: pgtable: Cleanup useless VA_USER_XXX definitions

Guodong Xu <guodong@riscstar.com>
    riscv: cpufeature: Fix Zk bundled extension missing Zknh

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Fix npu rx DMA definitions

Suchit Karunakaran <suchitkarunakaran@gmail.com>
    btrfs: fix NULL pointer dereference in do_abort_log_replay()

Qu Wenruo <wqu@suse.com>
    btrfs: only enforce free space tree if v1 cache is required for bs < ps cases

Filipe Manana <fdmanana@suse.com>
    btrfs: release path before initializing extent tree in btrfs_read_locked_inode()

Michal Luczaj <mhal@rbox.co>
    vsock: Make accept()ed sockets use custom setsockopt()

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: force send pcie parmater on navi1x

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: fix wrong pcie parameter on navi1x

Peter Zijlstra <peterz@infradead.org>
    perf: Ensure swevent hrtimer is properly destroyed

Florian Westphal <fw@strlen.de>
    inet: frags: drop fraglist conntrack references

Kommula Shiva Shankar <kshankar@marvell.com>
    virtio_net: fix device mismatch in devm_kzalloc/devm_kfree

Srijit Bose <srijit.bose@broadcom.com>
    bnxt_en: Fix potential data corruption with HW GRO/LRO

Zilin Guan <zilin@seu.edu.cn>
    net: wwan: iosm: Fix memory leak in ipc_mux_deinit()

Frank Liang <xiliang@redhat.com>
    net/ena: fix missing lock when update devlink params

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Dealloc forgotten PSP RX modify header

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Don't print error message due to invalid module

Alexei Lazar <alazar@nvidia.com>
    net/mlx5e: Don't gate FEC histograms on ppcnt_statistical_group

Patrisious Haddad <phaddad@nvidia.com>
    net/mlx5: Lag, multipath, give priority for routes with smaller network prefix

Di Zhu <zhud@hygon.cn>
    netdev: preserve NETIF_F_ALL_FOR_ALL across TSO updates

Weiming Shi <bestswngs@gmail.com>
    net: sock: fix hardened usercopy panic in sock_recv_errqueue

Stefano Radaelli <stefano.r@variscite.com>
    net: phy: mxl-86110: Add power management and soft reset support

yuan.gao <yuan.gao@ucloud.cn>
    inet: ping: Fix icmp out counting

Jerry Wu <w.7erry@foxmail.com>
    net: mscc: ocelot: Fix crash when adding interface under a lag

Alexandre Knecht <knecht.alexandre@gmail.com>
    bridge: fix C-VLAN preservation in 802.1ad vlan_tunnel egress

Alok Tiwari <alok.a.tiwari@oracle.com>
    net: marvell: prestera: fix NULL dereference on devlink_alloc() failure

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nf_conncount: update last_gc only when GC has been performed

Zilin Guan <zilin@seu.edu.cn>
    netfilter: nf_tables: fix memory leak in nf_tables_newrule()

Ernest Van Hoecke <ernest.vanhoecke@toradex.com>
    gpio: pca953x: handle short interrupt pulses on PCAL devices

Paweł Narewski <pawel.narewski@nokia.com>
    gpiolib: fix race condition for gdev->srcu

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpiolib: rename GPIO chip printk macros

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpiolib: remove unnecessary 'out of memory' messages

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nft_synproxy: avoid possible data-race on update operation

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: fix range overlap detection

Alexander Stein <alexander.stein@ew.tq-group.com>
    arm64: dts: mba8mx: Fix Ethernet PHY IRQ support

Sherry Sun <sherry.sun@nxp.com>
    arm64: dts: imx8qm-ss-dma: correct the dma channels of lpuart

Marek Vasut <marek.vasut@mailbox.org>
    arm64: dts: imx8mp: Fix LAN8740Ai PHY reference clock on DH electronics i.MX8M Plus DHCOM

Maud Spierings <maudspierings@gocontroll.com>
    arm64: dts: freescale: tx8p-ml81: fix eqos nvmem-cells

Maud Spierings <maudspierings@gocontroll.com>
    arm64: dts: freescale: moduline-display: fix compatible

Ian Ray <ian.ray@gehealthcare.com>
    ARM: dts: imx6q-ba16: fix RTC interrupt level

Haibo Chen <haibo.chen@nxp.com>
    arm64: dts: add off-on-delay-us for usdhc2 regulator

Haibo Chen <haibo.chen@nxp.com>
    arm64: dts: imx8qm-mek: correct the light sensor interrupt type to low level

Harshita Bhilwaria <harshita.bhilwaria@intel.com>
    crypto: qat - fix duplicate restarting msg during AER error

Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
    pinctrl: mediatek: mt8189: restore previous register base name array order

David Howells <dhowells@redhat.com>
    netfs: Fix early read unlock of page with EOF in middle

Even Xu <even.xu@intel.com>
    HID: Intel-thc-hid: Intel-thc: Fix wrong register reading

Thomas Fourier <fourier.thomas@gmail.com>
    HID: Intel-thc-hid: Intel-thc: fix dma_unmap_sg() nents value

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: it87: balance superio enter/exit calls in error path

Alexandre Courbot <acourbot@nvidia.com>
    gpu: nova-core: select RUST_FW_LOADER_ABSTRACTIONS

Wadim Egorov <w.egorov@phytec.de>
    arm64: dts: ti: k3-am62-lp-sk-nand: Rename pinctrls to fix schema warnings

Wadim Egorov <w.egorov@phytec.de>
    arm64: dts: ti: k3-am642-phyboard-electra-x27-gpio1-spi1-uart3: Fix schema warnings

Wadim Egorov <w.egorov@phytec.de>
    arm64: dts: ti: k3-am642-phyboard-electra-peb-c-010: Fix icssg-prueth schema warning

Zilin Guan <zilin@seu.edu.cn>
    of: unittest: Fix memory leak in unittest_data_add()

Leo Martins <loemra.dev@gmail.com>
    btrfs: fix use-after-free warning in btrfs_get_or_create_delayed_node()

Miquel Sabaté Solà <mssola@mssola.com>
    btrfs: fix NULL dereference on root when tracing inode eviction

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: update all parent qgroups when doing quick inherit

Boris Burkov <boris@bur.io>
    btrfs: fix qgroup_snapshot_quick_inherit() squota bug

Xingui Yang <yangxingui@huawei.com>
    scsi: Revert "scsi: libsas: Fix exp-attached device scan after probe failure scanned in again after probe failed"

Brian Kao <powenkao@google.com>
    scsi: ufs: core: Fix EH failure after W-LUN resume error

Wen Xiong <wenxiong@linux.ibm.com>
    scsi: ipr: Enable/disable IRQD_NO_BALANCING during reset

Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
    scsi: mpi3mr: Prevent duplicate SAS/SATA device entries in channel 1

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/client: fix NT_STATUS_NO_DATA_DETECTED value

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/client: fix NT_STATUS_DEVICE_DOOR_OPEN value

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/client: fix NT_STATUS_UNABLE_TO_FREE_VM value

Rosen Penev <rosenp@gmail.com>
    drm/amd/display: shrink struct members

Stefan Binding <sbinding@opensource.cirrus.com>
    ALSA: hda/realtek: Add support for ASUS UM3406GA

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix up the automount fs_context to use the correct cred

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    ASoC: rockchip: Fix Wvoid-pointer-to-enum-cast warning (again)

Scott Mayhew <smayhew@redhat.com>
    NFSv4: ensure the open stateid seqid doesn't go backwards

Mikulas Patocka <mpatocka@redhat.com>
    dm-snapshot: fix 'scheduling while atomic' on real-time kernels

Mikulas Patocka <mpatocka@redhat.com>
    dm-verity: disable recursive forward error correction

Sam James <sam@gentoo.org>
    alpha: don't reference obsolete termio struct for TC* constants

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    ARM: 9461/1: Disable HIGHPTE on PREEMPT_RT kernels

Yang Li <yang.li85200@gmail.com>
    csky: fix csky_cmpxchg_fixup not working

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: intel-dsp-config: Prefer legacy driver as fallback

Ming Lei <ming.lei@redhat.com>
    ublk: reorder tag_set initialization before queue allocation

Ilya Dryomov <idryomov@gmail.com>
    libceph: make calc_target() set t->paused, not just clear it

Sam Edwards <cfsworks@gmail.com>
    libceph: reset sparse-read state in osd_fault()

Ilya Dryomov <idryomov@gmail.com>
    libceph: return the handler error from mon_handle_auth_done()

Tuo Li <islituo@gmail.com>
    libceph: make free_choose_arg_map() resilient to partial allocation

Ilya Dryomov <idryomov@gmail.com>
    libceph: replace overzealous BUG_ON in osdmap_apply_incremental()

ziming zhang <ezrakiez@gmail.com>
    libceph: prevent potential out-of-bounds reads in handle_auth_done()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: restore non-chanctx injection behaviour

Eric Dumazet <edumazet@google.com>
    wifi: avoid kernel-infoleak from struct iw_point

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    Revert "drm/mediatek: dsi: Fix DSI host and panel bridge pre-enable order"

Malaya Kumar Rout <mrout@redhat.com>
    PM: hibernate: Fix crash when freeing invalid crypto compressor

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    pinctrl: qcom: lpass-lpi: mark the GPIO controller as sleeping

Bjorn Helgaas <bhelgaas@google.com>
    PCI: meson: Report that link is up while in ASPM L0s and L1 states

Jens Axboe <axboe@kernel.dk>
    io_uring/io-wq: fix incorrect io_wq_for_each_worker() termination logic

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: rockchip: mark the GPIO controller as sleeping

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: Remove __counted_by from ClockInfoArray.clockInfo[]

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/tidss: Fix enable/disable order

Miaoqian Lin <linmq006@gmail.com>
    drm/pl111: Fix error handling in pl111_amba_probe

Linus Walleij <linusw@kernel.org>
    drm/atomic-helper: Export and namespace some functions

Alan Liu <haoping.liu@amd.com>
    drm/amdgpu: Fix query for VPE block_type and ip_count

Nathan Chancellor <nathan@kernel.org>
    drm/amd/display: Apply e4479aecf658 to dml

Carlos Song <carlos.song@nxp.com>
    arm64: dts: imx95: correct I3C2 pclk to IMX95_CLK_BUSWAKEUP

August Wikerfors <git@augustwikerfors.se>
    ALSA: hda/tas2781: properly initialize speaker_id for TAS2563

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    ALSA: ac97: fix a double free in snd_ac97_controller_register()

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    Revert "drm/atomic-helper: Re-order bridge chain pre-enable and post-disable"

Dave Airlie <airlied@redhat.com>
    nouveau: don't attempt fwsec on sb on newer platforms.

Vivian Wang <wangruikang@iscas.ac.cn>
    riscv: boot: Always make Image from vmlinux, not vmlinux.unstripped

Steven Rostedt <rostedt@goodmis.org>
    tracing: Add recursion protection in kernel stack trace recording

Alexander Sverdlin <alexander.sverdlin@gmail.com>
    counter: interrupt-cnt: Drop IRQF_NO_THREAD flag

Haotian Zhang <vulab@iscas.ac.cn>
    counter: 104-quad-8: Fix incorrect return value in IRQ handler

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: aes: Fix missing MMU protection for AES S-box

Alice Ryhl <aliceryhl@google.com>
    rust_binder: remove spin_lock() in rust_shrink_free_page()

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add nova lake point S DID

Filipe Manana <fdmanana@suse.com>
    btrfs: always detect conflicting inodes when logging inode refs

Breno Leitao <leitao@debian.org>
    bnxt_en: Fix NULL pointer crash in bnxt_ptp_enable during error cleanup

Yeoreum Yun <yeoreum.yun@arm.com>
    arm64: Fix cleared E0POE bit after cpu_suspend()/resume()

Willem de Bruijn <willemb@google.com>
    net: do not write to msg_get_inq in callee

Thomas Fourier <fourier.thomas@gmail.com>
    net: 3com: 3c59x: fix possible null dereference in vortex_probe1()

Thomas Fourier <fourier.thomas@gmail.com>
    atm: Fix dma_free_coherent() size

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Remove NFSERR_EAGAIN

Edward Adam Davis <eadavis@qq.com>
    NFSD: net ref data still needs to be freed even if net hasn't startup

Olga Kornievskaia <okorniev@redhat.com>
    nfsd: check that server is running in unlock_filesystem

NeilBrown <neil@brown.name>
    nfsd: use correct loop termination in nfsd4_revoke_states()

NeilBrown <neil@brown.name>
    nfsd: provide locking for v4_end_grace

Scott Mayhew <smayhew@redhat.com>
    NFSD: Fix permission check for read access to executable-only files


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/alpha/include/uapi/asm/ioctls.h               |   8 +-
 arch/arm/Kconfig                                   |   2 +-
 arch/arm/boot/dts/nxp/imx/imx6q-ba16.dtsi          |   2 +-
 .../arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi |   1 +
 .../imx8mp-tx8p-ml81-moduline-display-106.dts      |   2 +-
 .../arm64/boot/dts/freescale/imx8mp-tx8p-ml81.dtsi |   5 +
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts       |   3 +-
 arch/arm64/boot/dts/freescale/imx8qm-ss-dma.dtsi   |   8 +-
 arch/arm64/boot/dts/freescale/imx95.dtsi           |   2 +-
 arch/arm64/boot/dts/freescale/mba8mx.dtsi          |   2 +-
 arch/arm64/boot/dts/ti/k3-am62-lp-sk-nand.dtso     |   2 +-
 .../ti/k3-am642-phyboard-electra-peb-c-010.dtso    |   7 +-
 ...m642-phyboard-electra-x27-gpio1-spi1-uart3.dtso |   8 +-
 arch/arm64/include/asm/suspend.h                   |   2 +-
 arch/arm64/mm/proc.S                               |   8 +
 arch/csky/mm/fault.c                               |   4 +-
 arch/riscv/boot/Makefile                           |   4 -
 arch/riscv/include/asm/pgtable.h                   |   4 -
 arch/riscv/kernel/cpufeature.c                     |  23 +-
 arch/sparc/kernel/pci.c                            |  23 ++
 block/blk-integrity.c                              |  23 +-
 block/blk-settings.c                               |   7 +-
 drivers/accel/amdxdna/aie2_pci.c                   |   6 +
 drivers/android/binder/page_range.rs               |   3 -
 drivers/ata/libata-core.c                          |   3 +
 drivers/atm/he.c                                   |   3 +-
 drivers/block/ublk_drv.c                           |  49 ++--
 drivers/counter/104-quad-8.c                       |  20 +-
 drivers/counter/interrupt-cnt.c                    |   3 +-
 drivers/crypto/intel/qat/qat_common/adf_aer.c      |   2 -
 drivers/gpio/gpio-it87.c                           |  11 +-
 drivers/gpio/gpio-mpsse.c                          | 227 +++++++++++++++-
 drivers/gpio/gpio-pca953x.c                        |  25 +-
 drivers/gpio/gpio-rockchip.c                       |   1 +
 drivers/gpio/gpiolib-cdev.c                        |   2 +-
 drivers/gpio/gpiolib-sysfs.c                       |   2 +-
 drivers/gpio/gpiolib.c                             | 128 +++++----
 drivers/gpio/gpiolib.h                             |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |   6 +
 drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c        |   2 +-
 drivers/gpu/drm/amd/display/dc/dml/Makefile        |   6 +-
 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c  |  11 +-
 drivers/gpu/drm/amd/display/include/audio_types.h  |  14 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c    |  33 ++-
 drivers/gpu/drm/drm_atomic_helper.c                | 122 +++++++--
 drivers/gpu/drm/mediatek/mtk_dsi.c                 |   6 -
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/ad102.c    |   3 +
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/fwsec.c    |   8 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/ga100.c    |   3 +
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/ga102.c    |   3 +
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/priv.h     |  23 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/tu102.c    |  15 ++
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/tu116.c    |   3 +
 drivers/gpu/drm/pl111/pl111_drv.c                  |   2 +-
 drivers/gpu/drm/radeon/pptable.h                   |   2 +-
 drivers/gpu/drm/tidss/tidss_kms.c                  |  30 ++-
 drivers/gpu/nova-core/Kconfig                      |   2 +-
 drivers/hid/hid-quirks.c                           |   9 +
 .../hid/intel-thc-hid/intel-thc/intel-thc-dev.c    |   4 +-
 .../hid/intel-thc-hid/intel-thc/intel-thc-dma.c    |   4 +-
 .../hid/intel-thc-hid/intel-thc/intel-thc-dma.h    |   2 +
 drivers/irqchip/irq-gic-v5-its.c                   |   2 +-
 drivers/md/dm-exception-store.h                    |   2 +-
 drivers/md/dm-snap.c                               |  73 +++--
 drivers/md/dm-verity-fec.c                         |   4 +-
 drivers/md/dm-verity-fec.h                         |   3 -
 drivers/md/dm-verity-target.c                      |   2 +-
 drivers/misc/mei/hw-me-regs.h                      |   2 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |  23 --
 drivers/net/dsa/mv88e6xxx/chip.h                   |   4 -
 drivers/net/dsa/mv88e6xxx/serdes.c                 |  46 ----
 drivers/net/dsa/mv88e6xxx/serdes.h                 |   5 -
 drivers/net/ethernet/3com/3c59x.c                  |   2 +-
 drivers/net/ethernet/airoha/airoha_ppe.c           |   9 +-
 drivers/net/ethernet/amazon/ena/ena_devlink.c      |   4 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  21 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   4 +-
 drivers/net/ethernet/freescale/enetc/enetc.h       |   4 +-
 drivers/net/ethernet/intel/idpf/idpf.h             |  19 +-
 drivers/net/ethernet/intel/idpf/idpf_ethtool.c     | 100 ++++---
 drivers/net/ethernet/intel/idpf/idpf_idc.c         |   2 +-
 drivers/net/ethernet/intel/idpf/idpf_lib.c         | 294 ++++++++++++---------
 .../net/ethernet/intel/idpf/idpf_singleq_txrx.c    |   2 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        |  48 ++--
 drivers/net/ethernet/intel/idpf/idpf_txrx.h        |   6 +-
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c    |  17 +-
 drivers/net/ethernet/intel/idpf/xdp.c              |   2 +-
 .../ethernet/marvell/prestera/prestera_devlink.c   |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_accel/psp.c |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c   |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |   3 +-
 drivers/net/ethernet/mscc/ocelot.c                 |   6 +-
 drivers/net/netdevsim/bus.c                        |   8 +
 drivers/net/phy/mxl-86110.c                        |   3 +
 drivers/net/phy/sfp.c                              |   4 +-
 drivers/net/usb/pegasus.c                          |   2 +
 drivers/net/virtio_net.c                           |   6 +-
 drivers/net/wireless/virtual/mac80211_hwsim.c      |   2 +-
 drivers/net/wwan/iosm/iosm_ipc_mux.c               |   6 +
 drivers/of/unittest.c                              |   8 +-
 drivers/pci/controller/dwc/pci-meson.c             |  37 +--
 drivers/pci/vgaarb.c                               |   7 -
 drivers/pinctrl/mediatek/pinctrl-mt8189.c          |   2 +-
 drivers/pinctrl/qcom/pinctrl-lpass-lpi.c           |   2 +-
 drivers/powercap/powercap_sys.c                    |  22 +-
 drivers/scsi/ipr.c                                 |  28 +-
 drivers/scsi/libsas/sas_internal.h                 |  14 -
 drivers/scsi/mpi3mr/mpi3mr.h                       |   4 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |   4 +-
 drivers/scsi/sg.c                                  |  20 +-
 drivers/spi/spi-cadence-quadspi.c                  |  10 +-
 drivers/spi/spi-mt65xx.c                           |   2 +-
 drivers/ufs/core/ufshcd.c                          |  40 ++-
 fs/btrfs/delayed-inode.c                           |  32 +--
 fs/btrfs/extent_io.c                               |  31 ++-
 fs/btrfs/inode.c                                   |  19 +-
 fs/btrfs/ordered-data.c                            |   5 +-
 fs/btrfs/qgroup.c                                  |  21 +-
 fs/btrfs/super.c                                   |  12 +-
 fs/btrfs/tree-log.c                                |   8 +-
 fs/erofs/super.c                                   |  19 +-
 fs/netfs/read_collect.c                            |   2 +-
 fs/nfs/namespace.c                                 |   5 +
 fs/nfs/nfs4proc.c                                  |  13 +-
 fs/nfs/nfs4trace.h                                 |   1 +
 fs/nfs_common/common.c                             |   1 -
 fs/nfsd/netns.h                                    |   2 +
 fs/nfsd/nfs4proc.c                                 |   2 +-
 fs/nfsd/nfs4state.c                                |  49 +++-
 fs/nfsd/nfsctl.c                                   |  12 +-
 fs/nfsd/nfsd.h                                     |   1 -
 fs/nfsd/nfssvc.c                                   |  28 +-
 fs/nfsd/state.h                                    |   6 +-
 fs/nfsd/vfs.c                                      |   4 +-
 fs/smb/client/nterr.h                              |   6 +-
 include/drm/drm_atomic_helper.h                    |  22 ++
 include/drm/drm_bridge.h                           | 249 +++++------------
 include/linux/netdevice.h                          |   3 +-
 include/linux/soc/airoha/airoha_offload.h          |   8 +-
 include/linux/trace_recursion.h                    |   9 +
 include/net/netfilter/nf_tables.h                  |  34 ++-
 include/trace/events/btrfs.h                       |   3 +-
 include/trace/misc/nfs.h                           |   2 -
 include/uapi/linux/nfs.h                           |   1 -
 io_uring/io-wq.c                                   |   6 +-
 kernel/events/core.c                               |   6 +
 kernel/power/swap.c                                |  14 +-
 kernel/trace/trace.c                               |   8 +-
 lib/crypto/aes.c                                   |   4 +-
 net/bpf/test_run.c                                 |  25 +-
 net/bridge/br_vlan_tunnel.c                        |  11 +-
 net/can/j1939/transport.c                          |   2 +
 net/ceph/messenger_v2.c                            |   2 +
 net/ceph/mon_client.c                              |   2 +-
 net/ceph/osd_client.c                              |  14 +-
 net/ceph/osdmap.c                                  |  24 +-
 net/core/skbuff.c                                  |   8 +-
 net/core/sock.c                                    |   7 +-
 net/ipv4/arp.c                                     |   7 +-
 net/ipv4/inet_fragment.c                           |   2 +
 net/ipv4/ping.c                                    |   4 +-
 net/ipv4/tcp.c                                     |   8 +-
 net/ipv4/udp.c                                     |   1 +
 net/mac80211/tx.c                                  |   2 +
 net/netfilter/nf_conncount.c                       |   2 +-
 net/netfilter/nf_tables_api.c                      |  72 ++++-
 net/netfilter/nft_set_pipapo.c                     |   4 +-
 net/netfilter/nft_synproxy.c                       |   6 +-
 net/sched/act_api.c                                |   2 +
 net/sched/sch_qfq.c                                |   2 +-
 net/unix/af_unix.c                                 |   8 +-
 net/vmw_vsock/af_vsock.c                           |   4 +
 net/wireless/wext-core.c                           |   4 +
 net/wireless/wext-priv.c                           |   4 +
 sound/ac97/bus.c                                   |  10 +-
 sound/hda/codecs/realtek/alc269.c                  |   2 +
 sound/hda/codecs/side-codecs/tas2781_hda_i2c.c     |   4 +-
 sound/hda/core/intel-dsp-config.c                  |   3 +-
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/fsl/fsl_sai.c                            |   3 +
 sound/soc/rockchip/rockchip_pdm.c                  |   2 +-
 sound/usb/quirks.c                                 |  10 +
 .../selftests/drivers/net/hw/lib/py/__init__.py    |   4 +-
 tools/testing/selftests/net/lib/py/__init__.py     |   4 +-
 187 files changed, 1765 insertions(+), 1095 deletions(-)


