Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD730332EA0;
	Thu, 27 Nov 2025 14:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255549; cv=none; b=a5IbjNgIdKVYB1DXmNTe5oYkU7TYuweuOT5IH2mhCWSfG/OB43yYhthftgfkmCoq1M4tfTZMSCXNyk7jdX+AICXjIN8yleV2/slp4ahZXWD5tbLt9AbdkYNItRiIa5LqjmcGBABBMUcLc4NHENRF8ZX7232Z6hq20ifoQGrRpTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255549; c=relaxed/simple;
	bh=Q/otjjDB77HD9vXNuMUsBsFdM2YTfMF/qxnTmHYrlnY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UaT4kc8g98XPu0fe72OvpDaYRCLLru3nqUWPscqjdhgykC5IO2aWv9YDuJukP/dxii+UfqZjMOctf2vqgkWJLEvohEyZ8SG4qDdYYw127WgtqvLxxqnsv0ecybZk8iG9tb8bRijbMRoOoYvEppkw8xWTCB1Z8DtBXIj661grb58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+FMSBDt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+FMSBDt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16ACC4CEF8;
	Thu, 27 Nov 2025 14:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255549;
	bh=Q/otjjDB77HD9vXNuMUsBsFdM2YTfMF/qxnTmHYrlnY=;
	h=From:To:Cc:Subject:Date:From;
	b=s+FMSBDtGy5Cph7v44JU/AxS/9bfS9u1hYKwDUkWfFMA8FGDRutUo/wuCjuqLXp9q
	 08HamBd+8btr8tyXie5G1tKX9xowPBtrgi48VSogP+SyonkJ6nBSs78TNcrI6x3mNu
	 +tSVmx1/hGc+75lg4KG+vQpNkkBNzLsO6TAsywCs=
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
Subject: [PATCH 6.17 000/175] 6.17.10-rc1 review
Date: Thu, 27 Nov 2025 15:44:13 +0100
Message-ID: <20251127144042.945669935@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.17.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.17.10-rc1
X-KernelTest-Deadline: 2025-11-29T14:40+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.17.10 release.
There are 175 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 29 Nov 2025 14:40:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.10-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.17.10-rc1

Emil Tsalapatis <etsal@meta.com>
    sched_ext: fix flag check for deferred callbacks

Andrea Righi <arighi@nvidia.com>
    sched_ext: Fix scx_kick_pseqs corruption on concurrent scheduler loads

Ankit Nautiyal <ankit.k.nautiyal@intel.com>
    drm/i915/dp: Add device specific quirk to limit eDP rate to HBR2

Ankit Nautiyal <ankit.k.nautiyal@intel.com>
    Revert "drm/i915/dp: Reject HBR3 when sink doesn't support TPS4"

Jari Ruusu <jariruusu@protonmail.com>
    tty/vt: fix up incorrect backport to stable releases

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Prevent Gating DTBCLK before It Is Properly Latched

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: Insert dccg log for easy debug

Gang Yan <yangang@kylinos.cn>
    mptcp: fix address removal logic in mptcp_pm_nl_rm_addr

Darrick J. Wong <djwong@kernel.org>
    xfs: fix out of bounds memory read error in symlink repair

Marcelo Moreira <marcelomoreira1905@gmail.com>
    xfs: Replace strncpy with memcpy

Sathishkumar S <sathishkumar.sundararaju@amd.com>
    drm/amdgpu/jpeg: Add parse_cs for JPEG5_0_1

Sathishkumar S <sathishkumar.sundararaju@amd.com>
    drm/amdgpu/jpeg: Move parse_cs to amdgpu_jpeg.c

Imre Deak <imre.deak@intel.com>
    drm/i915/dp_mst: Disable Panel Replay

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Check drm_dp_dpcd_read return value on PSR dpcd init

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: fix incomplete backport in cfids_invalidation_worker()

Samuel Zhang <guoqing.zhang@amd.com>
    drm/amdgpu: fix gpu page fault after hibernation on PF passthrough

Filipe Manana <fdmanana@suse.com>
    btrfs: set inode flag BTRFS_INODE_COPY_EVERYTHING when logging new name

Zhang Chujun <zhangchujun@cmss.chinamobile.com>
    tracing/tools: Fix incorrcet short option in usage text for --threads

Nishanth Menon <nm@ti.com>
    net: ethernet: ti: netcp: Standardize knav_dma_open_channel to return NULL on error

Nitin Rawat <nitin.rawat@oss.qualcomm.com>
    scsi: ufs: ufs-qcom: Fix UFS OCP issue during UFS power down (PC=3)

René Rebe <rene@exactco.de>
    ALSA: usb-audio: fix uac2 clock source at terminal parser

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe: Prevent BIT() overflow when handling invalid prefetch region

Jakub Horký <jakub.git@horky.net>
    kconfig/nconf: Initialize the default locale at startup

Jakub Horký <jakub.git@horky.net>
    kconfig/mconf: Initialize the default locale at startup

Borislav Petkov (AMD) <bp@alien8.de>
    x86/CPU/AMD: Extend Zen6 model range

Shahar Shitrit <shshitrit@nvidia.com>
    net: tls: Cancel RX async resync request on rcd_delta overflow

Carlos Llamas <cmllamas@google.com>
    blk-crypto: use BLK_STS_INVAL for alignment errors

Shahar Shitrit <shshitrit@nvidia.com>
    net: tls: Change async resync helpers argument

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests: net: use BASH for bareudp testing

Paulo Alcantara <pc@manguebit.org>
    smb: client: handle lack of IPC in dfs_cache_refresh()

Sidharth Seela <sidharthseela@gmail.com>
    selftests: cachestat: Fix warning on declaration under label

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Limit Entrysign signature checking to known generations

dongsheng <dongsheng.x.zhang@intel.com>
    perf/x86/intel/uncore: Add uncore PMU support for Wildcat Lake

Eren Demir <eren.demir2479090@gmail.com>
    ALSA: hda/realtek: Fix mute led for HP Victus 15-fa1xxx (MB 8C2D)

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Fix a regression triggered by scsi_host_busy()

Steve French <stfrench@microsoft.com>
    cifs: fix typo in enable_gcm_256 module parameter

Shuming Fan <shumingf@realtek.com>
    ASoC: rt721: fix prepare clock stop failed

Rob Clark <robin.clark@oss.qualcomm.com>
    drm/msm: Fix pgtable prealloc error path

Emil Tsalapatis <etsal@meta.com>
    sched_ext: defer queue_balance_callback() until after ops.dispatch

Rafał Miłecki <rafal@milecki.pl>
    bcma: don't register devices disabled in OF

Tejun Heo <tj@kernel.org>
    sched_ext: Allocate scx_kick_cpus_pnt_seqs lazily using kvzalloc()

J-Donald Tournier <jdtournier@gmail.com>
    ALSA: hda/realtek: Add quirk for Lenovo Yoga 7 2-in-1 14AKP10

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    MIPS: kernel: Fix random segmentation faults

Malaya Kumar Rout <mrout@redhat.com>
    timekeeping: Fix resource leak in tk_aux_sysfs_init() error paths

Michal Luczaj <mhal@rbox.co>
    vsock: Ignore signal/timeout on connect() if already established

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf: Fix 0 count issue of cpu-clock

Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
    cifs: fix memory leak in smb3_fs_context_parse_param error path

Thomas Weißschuh <linux@weissschuh.net>
    LoongArch: Use UAPI types in ptrace UAPI header

Wen Yang <wen.yang@linux.dev>
    tick/sched: Fix bogus condition in report_idle_softirq()

Wei Fang <wei.fang@nxp.com>
    net: phylink: add missing supported link modes for the fixed-link

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: cdev: make sure the cdev fd is still active before emitting events

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Read sk_peek_offset() again after sleeping in unix_stream_read_generic().

Pradyumn Rahar <pradyumn.rahar@oracle.com>
    net/mlx5: Clean up only new IRQ glue on request_irq() failure

Shay Drory <shayd@nvidia.com>
    devlink: rate: Unset parent pointer in devl_rate_nodes_destroy

Jared Kangas <jkangas@redhat.com>
    pinctrl: s32cc: initialize gpio_pin_config::list after kmalloc()

Jared Kangas <jkangas@redhat.com>
    pinctrl: s32cc: fix uninitialized memory in s32_pinctrl_desc

Grzegorz Nitka <grzegorz.nitka@intel.com>
    ice: fix PTP cleanup on driver removal in error path

Emil Tantilov <emil.s.tantilov@intel.com>
    idpf: fix possible vport_config NULL pointer deref in remove

Venkata Ramana Nayana <venkata.ramana.nayana@intel.com>
    drm/xe/irq: Handle msix vector0 interrupt

Matt Roper <matthew.d.roper@intel.com>
    drm/xe/kunit: Fix forcewake assertion in mocs test

Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
    drm/i915/xe3: Restrict PTL intel_encoder_is_c10phy() to only PHY A

Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
    drm/i915/display: Add definition for wcl as subplatform

Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
    drm/pcids: Split PTL pciids group to make wcl subplatform

Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
    net: qlogic/qede: fix potential out-of-bounds read in qede_tpa_cont() and qede_tpa_end()

Randy Dunlap <rdunlap@infradead.org>
    platform/x86: intel-uncore-freq: fix all header kernel-doc warnings

Haotian Zhang <vulab@iscas.ac.cn>
    platform/x86/intel/speed_select_if: Convert PCIBIOS_* return codes to errnos

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Do not loopback traffic to GDM2 if it is available on the device

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Add wlan flowtable TX offload

Ido Schimmel <idosch@nvidia.com>
    selftests: net: lib: Do not overwrite error messages

Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
    s390/ctcm: Fix double-kfree

Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
    drm/i915/xe3lpd: Load DMC for Xe3_LPD version 30.02

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    nvme-multipath: fix lockdep WARN due to partition scan work

Alistair Francis <alistair.francis@wdc.com>
    nvmet-auth: update sc_c in target host hash calculation

Chen Pei <cp0613@linux.alibaba.com>
    tools: riscv: Fixed misalignment of CSR related definitions

Jesper Dangaard Brouer <hawk@kernel.org>
    veth: more robust handing of race to avoid txq getting stuck

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: remove never-working support for setting nsh fields

Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
    net: mlxsw: linecards: fix missing error check in mlxsw_linecard_devlink_info_get()

Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
    net: dsa: hellcreek: fix missing error handling in LED registration

Prateek Agarwal <praagarwal@nvidia.com>
    drm/tegra: Add call to put_pid()

Zilin Guan <zilin@seu.edu.cn>
    mlxsw: spectrum: Fix memory leak in mlxsw_sp_flower_stats()

Jiaming Zhang <r772577952@gmail.com>
    net: core: prevent NULL deref in generic_hwtstamp_ioctl_lower()

Aleksander Jan Bajkowski <olek2@wp.pl>
    mips: dts: econet: fix EN751221 core type

Armin Wolf <W_Armin@gmx.de>
    platform/x86: msi-wmi-platform: Fix typo in WMI GUID

Armin Wolf <W_Armin@gmx.de>
    platform/x86: msi-wmi-platform: Only load on MSI devices

Haotian Zhang <vulab@iscas.ac.cn>
    pinctrl: cirrus: Fix fwnode leak in cs42l43_pin_probe()

Jianbo Liu <jianbol@nvidia.com>
    xfrm: Prevent locally generated packets from direct output in tunnel mode

Jianbo Liu <jianbol@nvidia.com>
    xfrm: Determine inner GSO type from packet inner protocol

Jianbo Liu <jianbol@nvidia.com>
    xfrm: Check inner packet family directly from skb_dst

Yu-Chun Lin <eleanor.lin@realtek.com>
    pinctrl: realtek: Select REGMAP_MMIO for RTD driver

Chen-Yu Tsai <wens@kernel.org>
    clk: sunxi-ng: sun55i-a523-ccu: Lower audio0 pll minimum rate

Chen-Yu Tsai <wens@kernel.org>
    clk: sunxi-ng: sun55i-a523-r-ccu: Mark bus-r-dma as critical

Jernej Skrabec <jernej.skrabec@gmail.com>
    clk: sunxi-ng: Mark A523 bus-r-cpucfg clock as critical

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: set err and extack on failure to create pcpu SA

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: call xfrm_dev_state_delete when xfrm_state_migrate fails to add the state

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: also call xfrm_state_delete_tunnel at destroy time for states that were never added

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: drop SA reference in xfrm_state_update if dir doesn't match

Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
    pinctrl: mediatek: mt8189: align register base names to dt-bindings ones

Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
    pinctrl: mediatek: mt8196: align register base names to dt-bindings ones

Kiryl Shutsemau <kas@kernel.org>
    mm/truncate: unmap large folio on split failure

Ivan Lipski <ivan.lipski@amd.com>
    drm/amd/display: Clear the CUR_ENABLE register on DCN20 on DPP5

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Fix pbn to kbps Conversion

Mario Limonciello (AMD) <superm1@kernel.org>
    drm/amd/display: Move sleep into each retry for retrieve_link_cap()

Mario Limonciello (AMD) <superm1@kernel.org>
    drm/amd/display: Increase DPCD read retries

Yifan Zha <Yifan.Zha@amd.com>
    drm/amdgpu: Skip emit de meta data on gfx11 with rs64 enabled

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Skip power ungate during suspend for VPE

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/plane: Fix create_in_format_blob() return value

Robert McClinton <rbmccav@gmail.com>
    drm/radeon: delete radeon_fence_process in is_signaled, no deadlock

Ma Ke <make24@iscas.ac.cn>
    drm/tegra: dc: Fix reference leak in tegra_dc_couple()

Paolo Abeni <pabeni@redhat.com>
    mptcp: do not fallback when OoO is present

Paolo Abeni <pabeni@redhat.com>
    mptcp: decouple mptcp fastclose from tcp close

Paolo Abeni <pabeni@redhat.com>
    mptcp: avoid unneeded subflow-level drops

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: userspace: longer timeout

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: endpoints: longer timeout

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix premature close in case of fallback

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix duplicate reset on fastclose

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix ack generation for fallback msk

Eric Dumazet <edumazet@google.com>
    mptcp: fix a race in mptcp_pm_del_add_timer()

Eric Dumazet <edumazet@google.com>
    mptcp: fix race condition in mptcp_schedule_work()

Anthony Wong <anthony.wong@ubuntu.com>
    platform/x86: alienware-wmi-wmax: Add AWCC support to Alienware 16 Aurora

Kurt Borja <kuurtb@gmail.com>
    platform/x86: alienware-wmi-wmax: Add support for the whole "G" family

Kurt Borja <kuurtb@gmail.com>
    platform/x86: alienware-wmi-wmax: Add support for the whole "X" family

Kurt Borja <kuurtb@gmail.com>
    platform/x86: alienware-wmi-wmax: Add support for the whole "M" family

Kurt Borja <kuurtb@gmail.com>
    platform/x86: alienware-wmi-wmax: Fix "Alienware m16 R1 AMD" quirk order

Bibo Mao <maobibo@loongson.cn>
    LoongArch: Fix NUMA node parsing with numa_memblks

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Don't panic if no valid cache info for PCI

Vincent Li <vincent.mc.li@gmail.com>
    LoongArch: BPF: Disable trampoline for kernel module function trace

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: pinctrl: toshiba,visconti: Fix number of items in groups

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Malta: Fix !EVA SOC-it PCI MMIO

Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
    scsi: target: tcm_loop: Fix segfault in tcm_loop_tpg_address_show()

Bart Van Assche <bvanassche@acm.org>
    scsi: sg: Do not sleep in atomic context

Saket Kumar Bhaskar <skb99@linux.ibm.com>
    sched_ext: Fix scx_enable() crash on helper kthread creation failure

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: core: Fix runtime PM enabling in device_resume_early()

Ewan D. Milne <emilne@redhat.com>
    nvme: nvme-fc: Ensure ->ioerr_work is cancelled in nvme_fc_delete_ctrl()

Ewan D. Milne <emilne@redhat.com>
    nvme: nvme-fc: move tagset removal to nvme_fc_delete_ctrl()

Nam Cao <namcao@linutronix.de>
    nouveau/firmware: Add missing kfree() of nvkm_falcon_fw::boot

Vlastimil Babka <vbabka@suse.cz>
    mm/mempool: fix poisoning order>0 pages with HIGHMEM

Seungjin Bae <eeodqql09@gmail.com>
    Input: pegasus-notetaker - fix potential out-of-bounds access

Dan Carpenter <dan.carpenter@linaro.org>
    Input: imx_sc_key - fix memory corruption on unload

Hans de Goede <hansg@kernel.org>
    Input: goodix - add support for ACPI ID GDIX1003

Tzung-Bi Shih <tzungbi@kernel.org>
    Input: cros_ec_keyb - fix an invalid memory access

Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
    Revert "drm/tegra: dsi: Clear enable register if powered by bootloader"

Oleksij Rempel <o.rempel@pengutronix.de>
    net: dsa: microchip: lan937x: Fix RGMII delay tuning

Jens Axboe <axboe@kernel.dk>
    io_uring/cmd_net: fix wrong argument types for skb_queue_splice()

Andrey Vatoropin <a.vatoropin@crpt.ru>
    be2net: pass wrb_params in case of OS2BMC

Yihang Li <liyihang9@h-partners.com>
    ata: libata-scsi: Add missing scsi_device_put() in ata_scsi_dev_rescan()

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw89: hw_scan: Don't let the operating channel be last

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: introduce close_cached_dir_locked()

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: move avdcache to per-task security struct

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: rename task_security_struct to cred_security_struct

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: mm: Prevent a TLB shutdown on initial uniquification

Niklas Cassel <cassel@kernel.org>
    ata: libata-scsi: Fix system suspend for a security locked drive

Tony Luck <tony.luck@intel.com>
    ACPI: APEI: EINJ: Fix EINJV2 initialization and injection

Pasha Tatashin <pasha.tatashin@soleen.com>
    lib/test_kho: check if KHO is enabled

Jiayuan Chen <jiayuan.chen@linux.dev>
    mptcp: Fix proto fallback detection with BPF

Heiko Carstens <hca@linux.ibm.com>
    s390/mm: Fix __ptep_rdp() inline assembly

Jiayuan Chen <jiayuan.chen@linux.dev>
    mptcp: Disallow MPTCP subflows from sockmap

Yongpeng Yang <yangyongpeng@xiaomi.com>
    exfat: check return value of sb_min_blocksize in exfat_read_boot_sector

Mike Yuan <me@yhndnzj.com>
    shmem: fix tmpfs reconfiguration (remount) when noswap is set

Yongpeng Yang <yangyongpeng@xiaomi.com>
    isofs: check the return value of sb_min_blocksize() in isofs_fill_super

Yongpeng Yang <yangyongpeng@xiaomi.com>
    xfs: check the return value of sb_min_blocksize() in xfs_fs_fill_super

Dan Carpenter <dan.carpenter@linaro.org>
    mtdchar: fix integer overflow in read/write ioctls

Zhen Ni <zhen.ni@easystack.cn>
    fs: Fix uninitialized 'offp' in statmount_string()

Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
    mtd: rawnand: cadence: fix DMA device NULL pointer dereference

Yongpeng Yang <yangyongpeng@xiaomi.com>
    vfat: fix missing sb_min_blocksize() return value checks

Yosry Ahmed <yosry.ahmed@linux.dev>
    KVM: SVM: Fix redundant updates of LBR MSR intercepts

Quentin Schulz <quentin.schulz@cherry.de>
    arm64: dts: rockchip: disable HS400 on RK3588 Tiger

Quentin Schulz <quentin.schulz@cherry.de>
    arm64: dts: rockchip: include rk3399-base instead of rk3399 in rk3399-op1

Laurentiu Mihalcea <laurentiu.mihalcea@nxp.com>
    reset: imx8mp-audiomix: Fix bad mask values

Mykola Kvach <xakep.amatop@gmail.com>
    arm64: dts: rockchip: fix PCIe 3.3V regulator voltage on orangepi-5

Diederik de Haas <diederik@cknow-tech.com>
    arm64: dts: rockchip: Fix vccio4-supply on rk3566-pinetab2

Zhang Heng <zhangheng@kylinos.cn>
    HID: quirks: work around VID/PID conflict for 0x4c4a/0x4155

Mario Limonciello (AMD) <superm1@kernel.org>
    HID: amd_sfh: Stop sensor before starting

Alexey Charkov <alchark@gmail.com>
    arm64: dts: rockchip: Remove non-functioning CPU OPPs from RK3576

Yipeng Zou <zouyipeng@huawei.com>
    timers: Fix NULL function pointer race in timer_shutdown_sync()

Sebastian Ene <sebastianene@google.com>
    KVM: arm64: Check the untrusted offset in FF-A memory share


-------------

Diffstat:

 .../bindings/pinctrl/toshiba,visconti-pinctrl.yaml |  26 +++--
 Documentation/wmi/driver-development-guide.rst     |   1 +
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/rockchip/rk3399-op1.dtsi       |   2 +-
 arch/arm64/boot/dts/rockchip/rk3566-pinetab2.dtsi  |   2 +-
 arch/arm64/boot/dts/rockchip/rk3576.dtsi           |  12 --
 arch/arm64/boot/dts/rockchip/rk3588-tiger.dtsi     |   4 +-
 .../arm64/boot/dts/rockchip/rk3588s-orangepi-5.dts |   4 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c                      |   9 +-
 arch/loongarch/include/uapi/asm/ptrace.h           |  40 +++----
 arch/loongarch/kernel/numa.c                       |  60 +++-------
 arch/loongarch/net/bpf_jit.c                       |   3 +
 arch/loongarch/pci/pci.c                           |   8 +-
 arch/mips/boot/dts/econet/en751221.dtsi            |   2 +-
 arch/mips/kernel/process.c                         |   2 +-
 arch/mips/mm/tlb-r4k.c                             | 102 ++++++++++-------
 arch/mips/mti-malta/malta-init.c                   |  20 ++--
 arch/s390/include/asm/pgtable.h                    |  12 +-
 arch/s390/mm/pgtable.c                             |   4 +-
 arch/x86/events/intel/uncore.c                     |   1 +
 arch/x86/kernel/cpu/amd.c                          |   2 +-
 arch/x86/kernel/cpu/microcode/amd.c                |  20 +++-
 arch/x86/kvm/svm/svm.c                             |   9 +-
 arch/x86/kvm/svm/svm.h                             |   1 +
 block/blk-crypto.c                                 |   2 +-
 drivers/acpi/apei/einj-core.c                      |  64 +++++++----
 drivers/ata/libata-scsi.c                          |  11 +-
 drivers/base/power/main.c                          |  25 +++--
 drivers/bcma/main.c                                |   6 +
 drivers/clk/sunxi-ng/ccu-sun55i-a523-r.c           |   4 +-
 drivers/clk/sunxi-ng/ccu-sun55i-a523.c             |   2 +-
 drivers/gpio/gpiolib-cdev.c                        |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c           |  65 +++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.h           |  10 ++
 drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c         |   3 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c            |   4 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c             |  58 +---------
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.h             |   6 -
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c           |   2 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c           |   2 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c           |   2 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c           |   1 +
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  59 ++++------
 .../amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c   |   4 +-
 .../gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c |  26 ++++-
 .../drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c    |   8 ++
 .../display/dc/link/protocols/link_dp_capability.c |  11 +-
 drivers/gpu/drm/drm_plane.c                        |   4 +-
 drivers/gpu/drm/i915/display/intel_cx0_phy.c       |  14 +--
 .../gpu/drm/i915/display/intel_display_device.c    |  13 +++
 .../gpu/drm/i915/display/intel_display_device.h    |   4 +-
 drivers/gpu/drm/i915/display/intel_dmc.c           |  10 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |  30 ++---
 drivers/gpu/drm/i915/display/intel_psr.c           |  36 ++++--
 drivers/gpu/drm/i915/display/intel_quirks.c        |   9 ++
 drivers/gpu/drm/i915/display/intel_quirks.h        |   1 +
 drivers/gpu/drm/msm/msm_iommu.c                    |   5 +
 drivers/gpu/drm/nouveau/nvkm/falcon/fw.c           |   2 +
 drivers/gpu/drm/radeon/radeon_fence.c              |   7 --
 drivers/gpu/drm/tegra/dc.c                         |   1 +
 drivers/gpu/drm/tegra/dsi.c                        |   9 --
 drivers/gpu/drm/tegra/uapi.c                       |   7 +-
 drivers/gpu/drm/xe/tests/xe_mocs.c                 |   2 +-
 drivers/gpu/drm/xe/xe_irq.c                        |  18 +--
 drivers/gpu/drm/xe/xe_pci.c                        |   1 +
 drivers/gpu/drm/xe/xe_vm.c                         |   4 +-
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c      |   2 +
 drivers/hid/hid-ids.h                              |   4 +-
 drivers/hid/hid-quirks.c                           |  13 ++-
 drivers/input/keyboard/cros_ec_keyb.c              |   6 +
 drivers/input/keyboard/imx_sc_key.c                |   2 +-
 drivers/input/tablet/pegasus_notetaker.c           |   9 ++
 drivers/input/touchscreen/goodix.c                 |   1 +
 drivers/mtd/mtdchar.c                              |   6 +-
 drivers/mtd/nand/raw/cadence-nand-controller.c     |   3 +-
 drivers/net/dsa/hirschmann/hellcreek_ptp.c         |  14 ++-
 drivers/net/dsa/microchip/lan937x_main.c           |   1 +
 drivers/net/ethernet/airoha/airoha_eth.h           |  11 ++
 drivers/net/ethernet/airoha/airoha_ppe.c           |  95 +++++++++++-----
 drivers/net/ethernet/emulex/benet/be_main.c        |   7 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           |  22 +++-
 drivers/net/ethernet/intel/idpf/idpf_main.c        |   2 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |   6 +-
 .../net/ethernet/mellanox/mlxsw/core_linecards.c   |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |   6 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   5 +-
 drivers/net/ethernet/ti/netcp_core.c               |  10 +-
 drivers/net/phy/phylink.c                          |   3 +
 drivers/net/veth.c                                 |  38 ++++---
 drivers/net/wireless/realtek/rtw89/fw.c            |   7 ++
 drivers/nvme/host/fc.c                             |  15 +--
 drivers/nvme/host/multipath.c                      |   2 +-
 drivers/nvme/target/auth.c                         |   4 +-
 drivers/nvme/target/fabrics-cmd-auth.c             |   1 +
 drivers/nvme/target/nvmet.h                        |   1 +
 drivers/perf/riscv_pmu_sbi.c                       |   2 +-
 drivers/pinctrl/cirrus/pinctrl-cs42l43.c           |  21 +++-
 drivers/pinctrl/mediatek/pinctrl-mt8189.c          |   4 +-
 drivers/pinctrl/mediatek/pinctrl-mt8196.c          |   6 +-
 drivers/pinctrl/nxp/pinctrl-s32cc.c                |   3 +-
 drivers/pinctrl/realtek/Kconfig                    |   1 +
 drivers/platform/x86/Kconfig                       |   1 +
 drivers/platform/x86/dell/alienware-wmi-wmax.c     | 104 +++++-------------
 .../x86/intel/speed_select_if/isst_if_mmio.c       |   4 +-
 .../uncore-frequency/uncore-frequency-common.h     |   9 +-
 drivers/platform/x86/msi-wmi-platform.c            |  43 +++++++-
 drivers/reset/reset-imx8mp-audiomix.c              |   4 +-
 drivers/s390/net/ctcm_mpc.c                        |   1 -
 drivers/scsi/hosts.c                               |   5 +-
 drivers/scsi/sg.c                                  |  10 +-
 drivers/soc/ti/knav_dma.c                          |  14 +--
 drivers/target/loopback/tcm_loop.c                 |   3 +
 drivers/tty/vt/vt_ioctl.c                          |   4 +-
 drivers/ufs/host/ufs-qcom.c                        |  15 ++-
 fs/btrfs/inode.c                                   |   1 -
 fs/btrfs/tree-log.c                                |   3 +
 fs/exfat/super.c                                   |   5 +-
 fs/fat/inode.c                                     |   6 +-
 fs/isofs/inode.c                                   |   5 +
 fs/namespace.c                                     |   4 +-
 fs/smb/client/cached_dir.c                         |  43 +++++++-
 fs/smb/client/cifsfs.c                             |   2 +-
 fs/smb/client/cifsproto.h                          |   2 +
 fs/smb/client/connect.c                            |  38 +++----
 fs/smb/client/dfs_cache.c                          |  55 ++++++++--
 fs/smb/client/fs_context.c                         |   4 +
 fs/xfs/scrub/symlink_repair.c                      |   4 +-
 fs/xfs/xfs_super.c                                 |   5 +-
 include/drm/intel/pciids.h                         |   5 +-
 include/linux/ata.h                                |   1 +
 include/net/tls.h                                  |  25 +++--
 include/net/xfrm.h                                 |   3 +-
 io_uring/cmd_net.c                                 |   2 +-
 kernel/events/core.c                               |   2 +-
 kernel/sched/ext.c                                 | 121 +++++++++++++++++++--
 kernel/sched/sched.h                               |   1 +
 kernel/time/tick-sched.c                           |  11 +-
 kernel/time/timekeeping.c                          |  21 ++--
 kernel/time/timer.c                                |   7 +-
 lib/test_kho.c                                     |   3 +
 mm/mempool.c                                       |  32 +++++-
 mm/shmem.c                                         |  15 ++-
 mm/truncate.c                                      |  35 +++++-
 net/core/dev_ioctl.c                               |   3 +
 net/devlink/rate.c                                 |   4 +-
 net/ipv4/esp4_offload.c                            |   6 +-
 net/ipv6/esp6_offload.c                            |   6 +-
 net/mptcp/options.c                                |  54 ++++++++-
 net/mptcp/pm.c                                     |  20 ++--
 net/mptcp/pm_kernel.c                              |   2 +-
 net/mptcp/protocol.c                               |  84 +++++++++-----
 net/mptcp/protocol.h                               |   3 +-
 net/mptcp/subflow.c                                |   8 ++
 net/openvswitch/actions.c                          |  68 +-----------
 net/openvswitch/flow_netlink.c                     |  64 ++---------
 net/openvswitch/flow_netlink.h                     |   2 -
 net/tls/tls_device.c                               |   4 +-
 net/unix/af_unix.c                                 |   3 +-
 net/vmw_vsock/af_vsock.c                           |  40 +++++--
 net/xfrm/xfrm_device.c                             |   2 +-
 net/xfrm/xfrm_output.c                             |   8 +-
 net/xfrm/xfrm_state.c                              |  16 ++-
 net/xfrm/xfrm_user.c                               |   5 +-
 scripts/kconfig/mconf.c                            |   3 +
 scripts/kconfig/nconf.c                            |   3 +
 security/selinux/hooks.c                           |  79 +++++++-------
 security/selinux/include/objsec.h                  |  20 +++-
 sound/hda/codecs/realtek/alc269.c                  |   2 +
 sound/soc/codecs/rt721-sdca.c                      |   4 +
 sound/soc/codecs/rt721-sdca.h                      |   1 +
 sound/usb/mixer.c                                  |   2 +-
 tools/arch/riscv/include/asm/csr.h                 |   5 +-
 tools/testing/selftests/cachestat/test_cachestat.c |   4 +-
 tools/testing/selftests/net/bareudp.sh             |   2 +-
 .../selftests/net/forwarding/lib_sh_test.sh        |   7 ++
 tools/testing/selftests/net/lib.sh                 |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  18 +--
 tools/tracing/latency/latency-collector.c          |   2 +-
 184 files changed, 1552 insertions(+), 952 deletions(-)


