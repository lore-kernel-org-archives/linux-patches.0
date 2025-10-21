Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B741A00CE;
	Tue, 21 Oct 2025 20:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077252; cv=none; b=VT3LzbqLkENTdj/DUSF/ZEdMySMf1eTEp7oP/HJrCp0elCRbPPtlg9eDq8FUIipZBZMbnMB084q2LA6tDXJWcbpQ7MHd0XYE9ebxZQmJ00uHbOv0htvnXQSzPXf3Z+TBaAVyTElvZ1GtBuYeRxIWb+n6fO3L/hhfiFZu7G0+r4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077252; c=relaxed/simple;
	bh=D+2zt5IsiAGpbAni7Hgu2clT//yyGlf3MrcBYkEL4wM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=N2evMHSN3LBBoX50i/hzK9c57z9cKiDDOxQJ6jQsv+TNYpyNMXxP8VrbFFvKb0gofRO35pE5vKJs1pTvXLnwNLoODKGiWbLts/wGNA5uWpAfLnHu0DWV0gB5VpHjIqZWNuLi254+QZCsJa1+Mu/Pca9/DgXPVvmtNxbuU8Kp4tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gBhD5jN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBhD5jN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82969C4CEF1;
	Tue, 21 Oct 2025 20:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077252;
	bh=D+2zt5IsiAGpbAni7Hgu2clT//yyGlf3MrcBYkEL4wM=;
	h=From:To:Cc:Subject:Date:From;
	b=gBhD5jN57qjjv/IdnnZZvOX1aSk/9dVghPskMrTwQbiquIh22MYWZmev994z179zK
	 Vlr714fi9bq/fOuBhHsYkB/N5JH2C4z1mnZ3GU5K4EHnYjDW2stW5V46VD5LUaoOrd
	 Puw68yXpGT1W1SqZs3LQMmE+nnc5ta+RxENPVsPw=
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
	achill@achill.org
Subject: [PATCH 6.17 000/159] 6.17.5-rc1 review
Date: Tue, 21 Oct 2025 21:49:37 +0200
Message-ID: <20251021195043.182511864@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.5-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.17.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.17.5-rc1
X-KernelTest-Deadline: 2025-10-23T19:50+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.17.5 release.
There are 159 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 23 Oct 2025 19:49:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.5-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.17.5-rc1

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Don't allow evicting of BOs in same VM in array of VM binds

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/xe: Move rebar to be done earlier

Piotr Piórkowski <piotr.piorkowski@intel.com>
    drm/xe: Unify the initialization of VRAM regions

Piotr Piórkowski <piotr.piorkowski@intel.com>
    drm/xe: Move struct xe_vram_region to a dedicated header

Piotr Piórkowski <piotr.piorkowski@intel.com>
    drm/xe: Use dynamic allocation for tile and device VRAM region structures

Piotr Piórkowski <piotr.piorkowski@intel.com>
    drm/xe: Use devm_ioremap_wc for VRAM mapping and drop manual unmap

Devarsh Thakkar <devarsht@ti.com>
    phy: cadence: cdns-dphy: Update calibration wait time for startup state machine

Dave Jiang <dave.jiang@intel.com>
    cxl: Fix match_region_by_range() to use region_res_match_cxl_range()

Babu Moger <babu.moger@amd.com>
    x86/resctrl: Fix miscount of bandwidth event when reactivating previously unavailable RMID

Babu Moger <babu.moger@amd.com>
    x86/resctrl: Refactor resctrl_arch_rmid_read()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Define a proc_layoutcommit for the FlexFiles layout type

Devarsh Thakkar <devarsht@ti.com>
    phy: cadence: cdns-dphy: Fix PLL lock and O_CMN_READY polling

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    phy: cdns-dphy: Store hs_clk_rate and return it

Sergey Bashirov <sergeybashirov@gmail.com>
    NFSD: Fix last write offset handling in layoutcommit

Sergey Bashirov <sergeybashirov@gmail.com>
    NFSD: Implement large extent array support in pNFS

Sergey Bashirov <sergeybashirov@gmail.com>
    NFSD: Minor cleanup in layoutcommit processing

Sergey Bashirov <sergeybashirov@gmail.com>
    NFSD: Rework encoding and decoding of nfsd4_deviceid

Christoph Hellwig <hch@lst.de>
    xfs: fix log CRC mismatches between i386 and other architectures

Christoph Hellwig <hch@lst.de>
    xfs: rename the old_crc variable in xlog_recover_process

Mark Rutland <mark.rutland@arm.com>
    arm64: errata: Apply workarounds for Neoverse-V3AE

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Neoverse-V3AE definitions

Ada Couprie Diaz <ada.coupriediaz@arm.com>
    arm64: debug: always unmask interrupts in el0_softstp()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix slab-out-of-bounds read in hfsplus_strcasecmp()

Miguel Ojeda <ojeda@kernel.org>
    rust: cpufreq: fix formatting

Wilfred Mallawa <wilfred.mallawa@wdc.com>
    nvme/tcp: handle tls partially sent records in write_space()

Xing Guo <higuoxing@gmail.com>
    selftests: arg_parsing: Ensure data is flushed to disk before reading.

Matthew Auld <matthew.auld@intel.com>
    drm/xe/evict: drop bogus assert

Li Qiang <liqiang01@kylinos.cn>
    ASoC: amd/sdw_utils: avoid NULL deref when devm_kasprintf() fails

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    HID: multitouch: fix name of Stylus input devices

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: hid-input: only ignore 0 battery events for digitizers

Ming Lei <ming.lei@redhat.com>
    block: Remove elevator_lock usage from blkg_conf frozen operations

Yu Kuai <yukuai3@huawei.com>
    blk-mq: fix stale tag depth for shared sched tags in blk_mq_update_nr_requests()

Jiaming Zhang <r772577952@gmail.com>
    ALSA: usb-audio: Fix NULL pointer deference in try_to_register_card

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: make arg_parsing.c more robust to crashes

Alison Schofield <alison.schofield@intel.com>
    cxl/trace: Subtract to find an hpa_alias0 in cxl_poison events

Martin George <martinus.gpy@gmail.com>
    nvme-auth: update sc_c in host response

Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>
    accel/qaic: Synchronize access to DBC request queue head & tail pointer

Youssef Samir <quic_yabdulra@quicinc.com>
    accel/qaic: Treat remaining == 0 as error in find_and_map_user_pages()

Jeff Hugo <jeff.hugo@oss.qualcomm.com>
    accel/qaic: Fix bootlog initialization ordering

Randy Dunlap <rdunlap@infradead.org>
    ALSA: firewire: amdtp-stream: fix enum kernel-doc warnings

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Fix pelt lost idle time detection

Peter Zijlstra (Intel) <peterz@infradead.org>
    sched/deadline: Stop dl_server before CPU goes offline

Even Xu <even.xu@intel.com>
    HID: intel-thc-hid: Intel-quickspi: switch first interrupt from level to edge detection

Alok Tiwari <alok.a.tiwari@oracle.com>
    drm/rockchip: vop2: use correct destination rectangle height check

Francesco Valla <francesco@valla.it>
    drm/draw: fix color truncation in drm_draw_fill24

Ingo Molnar <mingo@kernel.org>
    x86/mm: Fix SMP ordering in switch_mm_irqs_off()

Dave Jiang <dave.jiang@intel.com>
    cxl/features: Add check for no entries in cxl_feature_info

Vinay Belgaumkar <vinay.belgaumkar@intel.com>
    drm/xe: Enable media sampler power gating

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/powerplay: Fix CIK shutdown temperature

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: drop unused structures in amdgpu_drm.h

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: set an error on all fences from a bad context

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: handle wrap around in reemit handling

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix handling of harvesting for ip_discovery firmware

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: add support for cyan skillfish without IP discovery

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: add ip offset support for cyan skillfish

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/fb: Fix the set_tiling vs. addfb race, again

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/frontbuffer: Move bo refcounting intel_frontbuffer_{get,release}()

Zhanjun Dong <zhanjun.dong@intel.com>
    drm/i915/guc: Skip communication warning on reset in progress

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ASoC: nau8821: Add DMI quirk to bypass jack debounce circuit

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ASoC: nau8821: Consistently clear interrupts before unmasking

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ASoC: nau8821: Generalize helper to clear IRQ status

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ASoC: nau8821: Cancel jdet_work before handling jack ejection

Christophe Leroy <christophe.leroy@csgroup.eu>
    ASoC: codecs: Fix gain setting ranges for Renesas IDT821034 codec

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/fadump: skip parameter area allocation when fadump is disabled

Marek Vasut <marek.vasut@mailbox.org>
    drm/bridge: lt9211: Drop check for last nibble of version register

Fabian Vogt <fvogt@suse.de>
    riscv: kprobes: Fix probe address validation

Amit Chaudhary <achaudhary@purestorage.com>
    nvme-multipath: Skip nr_active increments in RETRY disposition

Ketil Johnsen <ketil.johnsen@arm.com>
    drm/panthor: Ensure MCU is disabled on suspend

I Viswanath <viswanathiyyappan@gmail.com>
    net: usb: lan78xx: fix use of improperly initialized dev->chipid in lan78xx_reset

Breno Leitao <leitao@debian.org>
    netdevsim: set the carrier when the device goes up

Sabrina Dubroca <sd@queasysnail.net>
    tls: don't rely on tx_work during send()

Sabrina Dubroca <sd@queasysnail.net>
    tls: wait for pending async decryptions if tls_strp_msg_hold fails

Sabrina Dubroca <sd@queasysnail.net>
    tls: always set record_type in tls_process_cmsg

Sabrina Dubroca <sd@queasysnail.net>
    tls: wait for async encrypt in case of error during latter iterations of sendmsg

Sabrina Dubroca <sd@queasysnail.net>
    tls: trim encrypted message to match the plaintext on short splice

Alexey Simakov <bigalex934@gmail.com>
    tg3: prevent use of uninitialized remote_adv and local_adv variables

Marios Makassikis <mmakassikis@freebox.fr>
    ksmbd: fix recursive locking in RPC handle list access

Florian Westphal <fw@strlen.de>
    net: core: fix lockdep splat on device unregister

Wang Liang <wangliang74@huawei.com>
    selftests: net: check jq command is supported

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Take into account out-of-order tx completions in airoha_dev_xmit()

Eric Dumazet <edumazet@google.com>
    tcp: fix tcp_tso_should_defer() vs large RTT

Zqiang <qiang.zhang@linux.dev>
    usbnet: Fix using smp_processor_id() in preemptible code warnings

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    Octeontx2-af: Fix missing error code in cgx_probe()

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: Avoid spurious link down messages during interface toggle

Marek Vasut <marek.vasut@mailbox.org>
    net: phy: realtek: Avoid PHYCR2 access if PHYCR2 not present

Koichiro Den <den@valinux.co.jp>
    ixgbe: fix too early devlink_free() in ixgbe_remove()

Milena Olech <milena.olech@intel.com>
    idpf: cleanup remaining SKBs in PTP flows

Dmitry Safonov <0x7f454c46@gmail.com>
    net/ip6_tunnel: Prevent perpetual tunnel growth

Kamil Horák - 2N <kamilh@axis.com>
    net: phy: bcm54811: Fix GMII/MII/MII-Lite selection

Linmao Li <lilinmao@kylinos.cn>
    r8169: fix packet truncation after S4 resume on RTL8168H/RTL8111H

Ivan Vecera <ivecera@redhat.com>
    dpll: zl3073x: Handle missing or corrupted flash configuration

Ivan Vecera <ivecera@redhat.com>
    dpll: zl3073x: Refactor DPLL initialization

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: add missing calls in NETDEV_UNREGISTER notification handler

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    doc: fix seg6_flowlabel path

Yeounsu Moon <yyyynoom@gmail.com>
    net: dlink: handle dma_map_single() failure properly

Rex Lu <rex.lu@mediatek.com>
    net: mtk: wed: add dma mask limitation and GFP_DMA32 for device with more than 4GB DRAM

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: fix CAN state in system PM

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: m_can_chip_config(): bring up interface in correct state

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: m_can_handle_state_errors(): fix CAN state transition to Error Active

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: m_can_plat_remove(): add missing pm_runtime_disable()

Christian Brauner <brauner@kernel.org>
    coredump: fix core_pattern input validation

Yuezhang Mo <Yuezhang.Mo@sony.com>
    dax: skip read lock assertion for read-only filesystems

Benjamin Tissoires <bentiss@kernel.org>
    HID: multitouch: fix sticky fingers

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_ncm: Refactor bind path to use __free()

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_ecm: Refactor bind path to use __free()

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_acm: Refactor bind path to use __free()

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_rndis: Refactor bind path to use __free()

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: Introduce free_usb_request helper

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: Store endpoint pointer in usb_request

Guoniu Zhou <guoniu.zhou@nxp.com>
    media: nxp: imx8-isi: m2m: Fix streaming cleanup on release

Mario Limonciello (AMD) <superm1@kernel.org>
    drm/amd: Fix hybrid sleep

Mario Limonciello (AMD) <superm1@kernel.org>
    PM: hibernate: Add pm_hibernation_mode_is_suspend()

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Check whether secure display TA loaded successfully

Adrian Hunter <adrian.hunter@intel.com>
    perf/core: Fix MMAP2 event device with backing files

Adrian Hunter <adrian.hunter@intel.com>
    perf/core: Fix MMAP event path names with backing files

Adrian Hunter <adrian.hunter@intel.com>
    perf/core: Fix address filter match with backing files

Kenneth Graunke <kenneth@whitecape.org>
    drm/xe: Increase global invalidation timeout to 1000us

Jonathan Kim <jonathan.kim@amd.com>
    drm/amdgpu: fix gfx12 mes packet status return check

Gui-Dong Han <hanguidong02@gmail.com>
    drm/amdgpu: use atomic functions with memory barriers for vm fault info

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: Blank with VGACR17 sync enable, always clear VGACRB6 sync off

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/sched: Fix potential double free in drm_sched_job_add_resv_dependencies

Denis Arefev <arefev@swemel.ru>
    ALSA: hda: Fix missing pointer check in hda_component_manager_init function

Denis Arefev <arefev@swemel.ru>
    ALSA: hda: cs35l41: Fix NULL pointer dereference in cs35l41_get_acpi_mute_state()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Add quirk entry for HP ZBook 17 G6

Stuart Hayhurst <stuart.a.hayhurst@gmail.com>
    ALSA: hda/intel: Add MSI X870E Tomahawk to denylist

Dave Jiang <dave.jiang@intel.com>
    cxl/acpi: Fix setup of memory resource in cxl_acpi_set_cache_size()

Eugene Korenevsky <ekorenevsky@aliyun.com>
    cifs: parse_dfs_referrals: prevent oob on malformed input

Celeste Liu <uwu@coelacanthus.name>
    can: gs_usb: increase max interface to U8_MAX

Celeste Liu <uwu@coelacanthus.name>
    can: gs_usb: gs_make_candev(): populate net_device->dev_port

Filipe Manana <fdmanana@suse.com>
    btrfs: do not assert we found block group item when creating free space tree

Miquel Sabaté Solà <mssola@mssola.com>
    btrfs: fix memory leaks when rejecting a non SINGLE data profile without an RST

Boris Burkov <boris@bur.io>
    btrfs: fix incorrect readahead expansion length

Qu Wenruo <wqu@suse.com>
    btrfs: only set the device specific options after devices are opened

Miquel Sabaté Solà <mssola@mssola.com>
    btrfs: fix memory leak on duplicated memory in the qgroup assign ioctl

Filipe Manana <fdmanana@suse.com>
    btrfs: fix clearing of BTRFS_FS_RELOC_RUNNING if relocation already running

Deepanshu Kartikey <kartikey406@gmail.com>
    ext4: detect invalid INLINE_DATA + EXTENTS flag combination

Zhang Yi <yi.zhang@huawei.com>
    ext4: wait for ongoing I/O to complete before freeing blocks

Zhang Yi <yi.zhang@huawei.com>
    jbd2: ensure that all ongoing I/O complete before freeing blocks

Tim Hostetler <thostet@google.com>
    gve: Check valid ts bit on RX descriptor before hw timestamping

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: fix wrong block mapping for multi-devices

Oliver Upton <oliver.upton@linux.dev>
    KVM: arm64: Prevent access to vCPU events before init

Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
    net: usb: lan78xx: Fix lost EEPROM write timeout error(-ETIMEDOUT) in lan78xx_write_raw_eeprom

Yi Cong <yicong@kylinos.cn>
    r8152: add error handling in rtl8152_driver_init

Matthew Schwartz <matthew.schwartz@linux.dev>
    Revert "drm/amd/display: Only restore backlight after amdgpu_dm_init or dm_resume"

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: protect mem region deregistration

Jens Axboe <axboe@kernel.dk>
    Revert "io_uring/rw: drop -EOPNOTSUPP check in __io_complete_rw_common()"

Hao Ge <gehao@kylinos.cn>
    slab: reset slab->obj_ext when freeing and it is OBJEXTS_ALLOC_FAIL

Rong Zhang <i@rong.moe>
    x86/CPU/AMD: Prevent reset reasons from being retained across reboot

Shuhao Fu <sfual@cse.ust.hk>
    smb: client: Fix refcount leak for cifs_sb_tlink

Conor Dooley <conor.dooley@microchip.com>
    rust: cfi: only 64-bit arm and x86 support CFI_CLANG

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    ixgbevf: fix mailbox API compatibility by negotiating supported features

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    ixgbevf: fix getting link speed data for E610 devices

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/guc: Check GuC running state before deregistering exec queue

Lorenzo Pieralisi <lpieralisi@kernel.org>
    arm64/sysreg: Fix GIC CDEOI instruction encoding

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-core: relax checks in ata_read_log_directory()

Jan Kara <jack@suse.cz>
    vfs: Don't leak disconnected dentries on umount

Inochi Amaoto <inochiama@gmail.com>
    PCI: vmd: Override irq_startup()/irq_shutdown() in vmd_init_dev_msi_info()

Andrey Albershteyn <aalbersh@redhat.com>
    Revert "fs: make vfs_fileattr_[get|set] return -EOPNOTSUPP"

Jonathan Corbet <corbet@lwn.net>
    docs: kdoc: handle the obsolescensce of docutils.ErrorString()


-------------

Diffstat:

 Documentation/arch/arm64/silicon-errata.rst        |   2 +
 Documentation/networking/seg6-sysctl.rst           |   3 +
 Documentation/sphinx/kernel_feat.py                |   4 +-
 Documentation/sphinx/kernel_include.py             |   6 +-
 Documentation/sphinx/maintainers_include.py        |   4 +-
 Makefile                                           |   4 +-
 arch/Kconfig                                       |   1 +
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/include/asm/cputype.h                   |   2 +
 arch/arm64/include/asm/sysreg.h                    |  11 +-
 arch/arm64/kernel/cpu_errata.c                     |   1 +
 arch/arm64/kernel/entry-common.c                   |   8 +-
 arch/arm64/kvm/arm.c                               |   6 +
 arch/powerpc/kernel/fadump.c                       |   3 +
 arch/riscv/kernel/probes/kprobes.c                 |  13 +-
 arch/x86/kernel/cpu/amd.c                          |  16 +-
 arch/x86/kernel/cpu/resctrl/monitor.c              |  46 ++--
 arch/x86/mm/tlb.c                                  |  24 +-
 block/blk-cgroup.c                                 |  13 +-
 block/blk-mq-sched.c                               |   2 +-
 block/blk-mq-tag.c                                 |   5 +-
 block/blk-mq.c                                     |   2 +-
 block/blk-mq.h                                     |   3 +-
 drivers/accel/qaic/qaic.h                          |   2 +
 drivers/accel/qaic/qaic_control.c                  |   2 +-
 drivers/accel/qaic/qaic_data.c                     |  12 +-
 drivers/accel/qaic/qaic_debugfs.c                  |   5 +-
 drivers/accel/qaic/qaic_drv.c                      |   3 +
 drivers/ata/libata-core.c                          |  11 +-
 drivers/cxl/acpi.c                                 |   2 +-
 drivers/cxl/core/features.c                        |   3 +
 drivers/cxl/core/region.c                          |   7 +-
 drivers/cxl/core/trace.h                           |   2 +-
 drivers/dpll/zl3073x/core.c                        | 280 +++++++++++++--------
 drivers/dpll/zl3073x/core.h                        |   3 +
 drivers/dpll/zl3073x/devlink.c                     |  18 +-
 drivers/dpll/zl3073x/regs.h                        |   3 +
 drivers/gpu/drm/amd/amdgpu/Makefile                |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |  48 +++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c          |  54 +++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c           |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h           |   2 +-
 .../gpu/drm/amd/amdgpu/cyan_skillfish_reg_init.c   |  56 +++++
 drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c              |   7 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c              |   7 +-
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c             |   7 +-
 drivers/gpu/drm/amd/amdgpu/nv.h                    |   1 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  12 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |   7 -
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |   3 +-
 drivers/gpu/drm/ast/ast_mode.c                     |  18 +-
 drivers/gpu/drm/ast/ast_reg.h                      |   1 +
 drivers/gpu/drm/bridge/lontium-lt9211.c            |   3 +-
 drivers/gpu/drm/drm_draw.c                         |   2 +-
 drivers/gpu/drm/drm_draw_internal.h                |   2 +-
 drivers/gpu/drm/i915/display/intel_fb.c            |  38 +--
 drivers/gpu/drm/i915/display/intel_frontbuffer.c   |  10 +-
 .../gpu/drm/i915/gem/i915_gem_object_frontbuffer.h |   2 -
 drivers/gpu/drm/i915/gt/uc/intel_guc_ct.c          |   9 +-
 drivers/gpu/drm/panthor/panthor_fw.c               |   1 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |   2 +-
 drivers/gpu/drm/scheduler/sched_main.c             |  13 +-
 drivers/gpu/drm/xe/display/xe_fb_pin.c             |   5 +-
 drivers/gpu/drm/xe/display/xe_plane_initial.c      |   3 +-
 drivers/gpu/drm/xe/regs/xe_gt_regs.h               |   1 +
 drivers/gpu/drm/xe/xe_assert.h                     |   4 +-
 drivers/gpu/drm/xe/xe_bo.c                         |   1 +
 drivers/gpu/drm/xe/xe_bo.h                         |   4 +-
 drivers/gpu/drm/xe/xe_bo_evict.c                   |   8 -
 drivers/gpu/drm/xe/xe_bo_types.h                   |   1 +
 drivers/gpu/drm/xe/xe_device.c                     |  22 +-
 drivers/gpu/drm/xe/xe_device_types.h               |  62 +----
 drivers/gpu/drm/xe/xe_gt_idle.c                    |   8 +
 drivers/gpu/drm/xe/xe_gt_pagefault.c               |  13 +-
 drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c         |   3 +-
 drivers/gpu/drm/xe/xe_guc_submit.c                 |  13 +-
 drivers/gpu/drm/xe/xe_migrate.c                    |  25 +-
 drivers/gpu/drm/xe/xe_pci.c                        |   8 +
 drivers/gpu/drm/xe/xe_query.c                      |   5 +-
 drivers/gpu/drm/xe/xe_svm.c                        |  63 ++---
 drivers/gpu/drm/xe/xe_tile.c                       |  58 +++--
 drivers/gpu/drm/xe/xe_tile.h                       |  14 +-
 drivers/gpu/drm/xe/xe_ttm_stolen_mgr.c             |  10 +-
 drivers/gpu/drm/xe/xe_ttm_vram_mgr.c               |  22 +-
 drivers/gpu/drm/xe/xe_ttm_vram_mgr.h               |   3 +-
 drivers/gpu/drm/xe/xe_vm.c                         |  32 ++-
 drivers/gpu/drm/xe/xe_vm_types.h                   |   2 +
 drivers/gpu/drm/xe/xe_vram.c                       | 245 +++++++++++++-----
 drivers/gpu/drm/xe/xe_vram.h                       |  14 +-
 drivers/gpu/drm/xe/xe_vram_types.h                 |  85 +++++++
 drivers/hid/hid-input.c                            |   5 +-
 drivers/hid/hid-multitouch.c                       |  28 ++-
 .../intel-quickspi/quickspi-protocol.c             |   3 +-
 drivers/media/platform/nxp/imx8-isi/imx8-isi-m2m.c | 226 +++++++----------
 drivers/net/can/m_can/m_can.c                      |  64 +++--
 drivers/net/can/m_can/m_can_platform.c             |   2 +-
 drivers/net/can/usb/gs_usb.c                       |  23 +-
 drivers/net/ethernet/airoha/airoha_eth.c           |  16 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |   1 -
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |   1 +
 drivers/net/ethernet/broadcom/tg3.c                |   5 +-
 drivers/net/ethernet/dlink/dl2k.c                  |  23 +-
 drivers/net/ethernet/google/gve/gve.h              |   2 +
 drivers/net/ethernet/google/gve/gve_desc_dqo.h     |   3 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c       |  16 +-
 drivers/net/ethernet/intel/idpf/idpf_ptp.c         |   3 +
 .../net/ethernet/intel/idpf/idpf_virtchnl_ptp.c    |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   3 +-
 drivers/net/ethernet/intel/ixgbevf/defines.h       |   1 +
 drivers/net/ethernet/intel/ixgbevf/ipsec.c         |  10 +
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h       |   7 +
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |  34 ++-
 drivers/net/ethernet/intel/ixgbevf/mbx.h           |   8 +
 drivers/net/ethernet/intel/ixgbevf/vf.c            | 182 +++++++++++---
 drivers/net/ethernet/intel/ixgbevf/vf.h            |   1 +
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   1 +
 drivers/net/ethernet/mediatek/mtk_wed.c            |   8 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   5 +-
 drivers/net/netdevsim/netdev.c                     |   7 +
 drivers/net/phy/broadcom.c                         |  20 +-
 drivers/net/phy/realtek/realtek_main.c             |  23 +-
 drivers/net/usb/lan78xx.c                          |  19 +-
 drivers/net/usb/r8152.c                            |   7 +-
 drivers/net/usb/usbnet.c                           |   2 +
 drivers/nvme/host/auth.c                           |   6 +-
 drivers/nvme/host/multipath.c                      |   6 +-
 drivers/nvme/host/tcp.c                            |   3 +
 drivers/pci/controller/vmd.c                       |  13 +
 drivers/phy/cadence/cdns-dphy.c                    | 133 +++++++---
 drivers/usb/gadget/function/f_acm.c                |  42 ++--
 drivers/usb/gadget/function/f_ecm.c                |  48 ++--
 drivers/usb/gadget/function/f_ncm.c                |  78 +++---
 drivers/usb/gadget/function/f_rndis.c              |  85 +++----
 drivers/usb/gadget/udc/core.c                      |   3 +
 fs/btrfs/extent_io.c                               |   2 +-
 fs/btrfs/free-space-tree.c                         |  15 +-
 fs/btrfs/ioctl.c                                   |   2 +-
 fs/btrfs/relocation.c                              |  13 +-
 fs/btrfs/super.c                                   |   3 +-
 fs/btrfs/zoned.c                                   |   2 +-
 fs/coredump.c                                      |   2 +-
 fs/dax.c                                           |   2 +-
 fs/dcache.c                                        |   2 +
 fs/exec.c                                          |   2 +-
 fs/ext4/ext4_jbd2.c                                |  11 +-
 fs/ext4/inode.c                                    |   8 +
 fs/f2fs/data.c                                     |   2 +-
 fs/file_attr.c                                     |  12 +-
 fs/fuse/ioctl.c                                    |   4 -
 fs/hfsplus/unicode.c                               |  24 ++
 fs/jbd2/transaction.c                              |  13 +-
 fs/nfsd/blocklayout.c                              |  25 +-
 fs/nfsd/blocklayoutxdr.c                           |  86 ++++---
 fs/nfsd/blocklayoutxdr.h                           |   4 +-
 fs/nfsd/flexfilelayout.c                           |   8 +
 fs/nfsd/flexfilelayoutxdr.c                        |   3 +-
 fs/nfsd/nfs4layouts.c                              |   1 -
 fs/nfsd/nfs4proc.c                                 |  36 ++-
 fs/nfsd/nfs4xdr.c                                  |  25 +-
 fs/nfsd/pnfs.h                                     |   1 +
 fs/nfsd/xdr4.h                                     |  39 ++-
 fs/overlayfs/copy_up.c                             |   2 +-
 fs/overlayfs/inode.c                               |   5 +-
 fs/smb/client/inode.c                              |   6 +-
 fs/smb/client/misc.c                               |  17 ++
 fs/smb/client/smb2ops.c                            |   8 +-
 fs/smb/server/mgmt/user_session.c                  |   7 +-
 fs/smb/server/smb2pdu.c                            |   9 +-
 fs/smb/server/transport_ipc.c                      |  12 +
 fs/xfs/libxfs/xfs_log_format.h                     |  30 ++-
 fs/xfs/libxfs/xfs_ondisk.h                         |   2 +
 fs/xfs/xfs_log.c                                   |   8 +-
 fs/xfs/xfs_log_priv.h                              |   4 +-
 fs/xfs/xfs_log_recover.c                           |  34 ++-
 include/linux/brcmphy.h                            |   1 +
 include/linux/libata.h                             |   6 +
 include/linux/suspend.h                            |   2 +
 include/linux/usb/gadget.h                         |  25 ++
 include/net/ip_tunnels.h                           |  15 ++
 include/uapi/drm/amdgpu_drm.h                      |  21 --
 io_uring/register.c                                |   1 +
 io_uring/rw.c                                      |   2 +-
 kernel/events/core.c                               |   8 +-
 kernel/power/hibernate.c                           |  11 +
 kernel/sched/core.c                                |   2 +
 kernel/sched/deadline.c                            |   3 +
 kernel/sched/fair.c                                |  26 +-
 mm/slub.c                                          |   9 +-
 net/can/j1939/main.c                               |   2 +
 net/core/dev.c                                     |  40 ++-
 net/ipv4/ip_tunnel.c                               |  14 --
 net/ipv4/tcp_output.c                              |  19 +-
 net/ipv6/ip6_tunnel.c                              |   3 +-
 net/tls/tls_main.c                                 |   7 +-
 net/tls/tls_sw.c                                   |  31 ++-
 rust/kernel/cpufreq.rs                             |   3 +-
 sound/firewire/amdtp-stream.h                      |   2 +-
 sound/hda/codecs/realtek/alc269.c                  |   1 +
 sound/hda/codecs/side-codecs/cs35l41_hda.c         |   2 +
 sound/hda/codecs/side-codecs/hda_component.c       |   4 +
 sound/hda/controllers/intel.c                      |   1 +
 sound/soc/amd/acp/acp-sdw-sof-mach.c               |   2 +-
 sound/soc/codecs/idt821034.c                       |  12 +-
 sound/soc/codecs/nau8821.c                         | 115 +++++----
 sound/usb/card.c                                   |  10 +-
 .../testing/selftests/bpf/prog_tests/arg_parsing.c |  12 +-
 tools/testing/selftests/net/rtnetlink.sh           |   2 +
 tools/testing/selftests/net/vlan_bridge_binding.sh |   2 +
 211 files changed, 2408 insertions(+), 1262 deletions(-)


